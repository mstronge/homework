# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Resource.all.each do |r|
  if r.name.blank?
     if !r.attachment.file.nil?
      r.name = r.attachment.file.original_filename
    else
      r.name = r.link
    end
    check = Resource.equal_param(name: r.name)
    check_id = check.first.present? ? check.first.id : nil
    r.name = "#{r.name}_#{r.id}" if check_id.present? && check_id != r.id
    r.save
  end
  puts r.name
end
