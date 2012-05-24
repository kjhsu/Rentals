#encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create( email: "ukisami@gmail.com", password: "asdf1234", password_confirmation: "asdf1234" )

city = City.create( name: '台北')

districts = Neighborhood.create([
  { name: '中正区', city_id: city.id},
  { name: '大同区', city_id: city.id},
  { name: '中山区', city_id: city.id},
  { name: '松山区', city_id: city.id},
  { name: '大安区', city_id: city.id},
  { name: '万华区', city_id: city.id},
  { name: '信义区', city_id: city.id},
  { name: '士林区', city_id: city.id},
  { name: '北投区', city_id: city.id},
  { name: '内湖区', city_id: city.id},
  { name: '南港区', city_id: city.id},
  { name: '文山区', city_id: city.id}
])

cancellation_policies = CancellationPolicy.create([
  { name: '方便' },
  { name: '严格' }
])

amenities = Amenity.create([
  { name: '空调', priority: 1},
  { name: '电视', priority: 2},
  { name: '电脑', priority: 3},
  { name: '毛巾', priority: 4},
  { name: '牙刷', priority: 5},
  { name: '打扫', priority: 6}
])


districts.each do |district|
  40.times do |id|
    listing = district.listings.create(
      user_id: user.id,
      title: "#{district.name}绝佳好住处#{id}",
      max_guests: [1,2,3,4].sample,
      property_type: [1,2,3].sample,
      rooms: [1,2].sample,
      certified: [true, false].sample,
      extra_cost: [0, 10, 50].sample,
      daily_price: rand(300) + 50,
      weekly_price: rand(2000) + 300,
      monthly_price: rand(8000) + 1000,
      size: rand(90) + 10,
      cancellation_policy: cancellation_policies.sample,
      checkin: 12,
      checkout: 12,
      deposit: rand(50)
    )
    amenities.sample(4).each do |amenity|
      listing.amenities << amenity
    end
  end
end

