require 'spec_helper'

describe TimeBlock do
  let :block do
    block = TimeBlock.create listing_id: 1
  end

  let :begin_date do
    Date.parse '2012-1-1'
  end

  let :end_date do
    Date.parse '2030-1-1'
  end


  context "when creating a time block" do
    it "should be created with valid times" do
      block.begin_date.should == begin_date
      block.end_date.should == end_date
      block.is_free.should == true
    end

    it "cannot be created without a listing_id" do
      invalid_block = TimeBlock.create
      invalid_block.should_not be_persisted
    end
  end

  context "when testing date range inclusion" do
    it "returns true if date range is included" do
      block.include?(begin_date.to_s, end_date.to_s).should == true
    end

    it "returns false if date range is not included" do
      block.include?((begin_date - 1).to_s, end_date.to_s).should == false
    end

    it "returns false if given invalid range" do
      block.include?('hello', nil).should == false
    end
  end

  context "when scoping by date range" do
    before :each do
      TimeBlock.create begin_date: Date.parse("2012-1-1"), end_date: Date.parse("2012-1-2"), listing_id: 1
      TimeBlock.create begin_date: Date.parse("2012-1-1"), end_date: Date.parse("2012-1-3"), listing_id: 1
    end

    it "should return scoped searches correctly for valid searches" do
      TimeBlock.in_range('2012-1-1', '2012-1-2').count.should == 2
      TimeBlock.in_range('2012-1-1', '2012-1-3').count.should == 1
      TimeBlock.in_range('2011-12-31', '2012-1-2').count.should == 0
    end

    it "should return empty list for invalid searches" do
      TimeBlock.in_range('Invalid', '2012-1-3').count.should == 0
      TimeBlock.in_range(nil, '2012-1-3').count.should == 0
    end
  end

  context "when scheduling a date range" do
    it "should not schedule if input is invalid" do
      block.schedule(nil, nil).should == false
      TimeBlock.count.should == 1
    end

    it "should not schedule if start date is equal to or greater than end date" do
      block.schedule('2012-6-4', '2012-6-4').should == false
      block.schedule('2012-6-5', '2012-6-4').should == false
      TimeBlock.count.should == 1
    end

    it "should not schedule if date is out of range with the time block" do
      block.schedule('2011-1-31', '2012-1-2').should == false
      block.schedule('2030-1-1', '2030-1-2').should == false
      TimeBlock.count.should == 1
    end

    it "should not schedule if the time block is not free" do
      block.update_attributes is_free: false
      block.schedule('2012-1-1', '2012-1-2').should == false
      TimeBlock.count.should == 1
    end

    it "should schedule correctly for case (start, schedule, end)" do
      schedule_begin_date = Date.parse '2012-1-2'
      schedule_end_date = Date.parse '2012-1-5'
      block.schedule(schedule_begin_date.to_s, schedule_end_date.to_s).should == true
      block.begin_date.should == schedule_begin_date
      block.end_date.should == schedule_end_date
      TimeBlock.count.should == 3
      TimeBlock.where(['begin_date = ? and end_date = ?', schedule_begin_date, schedule_end_date]).count.should == 1
      TimeBlock.where(['begin_date = ? and end_date = ?', begin_date, schedule_begin_date]).count.should == 1
      TimeBlock.where(['begin_date = ? and end_date = ?', schedule_end_date, end_date]).count.should == 1
    end

    it "should schedule correctly for case (schedule, end)" do
      schedule_begin_date = Date.parse '2012-1-1'
      schedule_end_date = Date.parse '2012-1-5'
      block.schedule(schedule_begin_date.to_s, schedule_end_date.to_s).should == true
      block.begin_date.should == schedule_begin_date
      block.end_date.should == schedule_end_date
      TimeBlock.count.should == 2
      TimeBlock.where(['begin_date = ? and end_date = ?', schedule_begin_date, schedule_end_date]).count.should == 1
      TimeBlock.where(['begin_date = ? and end_date = ?', schedule_end_date, end_date]).count.should == 1
    end

    it "should schedule correctly for case (start, schedule)" do
      schedule_begin_date = Date.parse '2029-12-31'
      schedule_end_date = Date.parse '2030-1-1'
      block.schedule(schedule_begin_date.to_s, schedule_end_date.to_s).should == true
      block.begin_date.should == schedule_begin_date
      block.end_date.should == schedule_end_date
      TimeBlock.count.should == 2
      TimeBlock.where(['begin_date = ? and end_date = ?', begin_date, schedule_begin_date]).count.should == 1
      TimeBlock.where(['begin_date = ? and end_date = ?', schedule_begin_date, schedule_end_date]).count.should == 1
    end

    it "should not be free when scheduled" do
      schedule_begin_date = Date.parse '2012-1-1'
      schedule_end_date = Date.parse '2030-1-1'
      block.schedule(schedule_begin_date.to_s, schedule_end_date.to_s).should == true
      TimeBlock.first.should_not be_free
    end
  end

  context "when unscheduling a timeblock" do
    it "turns into a free block" do
      block.update_attributes is_free: false
      block.unschedule
      block.should be_free
    end

    it "collapses with free blocks on both ends" do
      schedule_begin_date = Date.parse '2012-1-2'
      schedule_end_date = Date.parse '2012-1-5'
      block.schedule(schedule_begin_date.to_s, schedule_end_date.to_s)
      block.unschedule
      TimeBlock.count.should == 1
      block.begin_date.should == begin_date
      block.end_date.should == end_date
    end

    it "only collapse with free blocks belonging to the same listing" do
      schedule_begin_date = Date.parse '2012-1-2'
      schedule_end_date = Date.parse '2012-1-5'
      block.schedule(schedule_begin_date.to_s, schedule_end_date.to_s)
      TimeBlock.where(end_date: schedule_begin_date).first.update_attributes listing_id: 2
      TimeBlock.where(begin_date: schedule_end_date).first.update_attributes is_free: 2
      block.unschedule
      TimeBlock.count.should == 3
      block.begin_date.should == schedule_begin_date
      block.end_date.should == schedule_end_date
    end

    it "does not collapse with scheduled blocks" do
      schedule_begin_date = Date.parse '2012-1-2'
      schedule_end_date = Date.parse '2012-1-5'
      block.schedule(schedule_begin_date.to_s, schedule_end_date.to_s)
      TimeBlock.where(end_date: schedule_begin_date).first.update_attributes is_free: false
      TimeBlock.where(begin_date: schedule_end_date).first.update_attributes is_free: false
      block.unschedule
      TimeBlock.count.should == 3
      block.begin_date.should == schedule_begin_date
      block.end_date.should == schedule_end_date
    end
  end
end
