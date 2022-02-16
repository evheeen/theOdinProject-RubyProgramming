# frozen_string_literal: true

require 'date'
require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exists?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') { |file| file.puts form_letter }
end

def clean_phone_number(phone_number)
  phone_number.gsub!(/[^\d]/, '')
  if phone_number.length == 10
    phone_number
  elsif phone_number.length == 11 && phone_number[0] == '1'
    phone_number[1..10]
  else
    'Wrong Number!!'
  end
end

def count_frequency(array)
  array.max_by { |a| array.count(a) }
end

def event_manager
  puts 'EventManager initialized.'

  contents        = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol
  contents_size   = CSV.read('event_attendees.csv').length
  template_letter = File.read 'form_letter.erb'
  erb_template    = ERB.new template_letter
  contents_size  -= 1
  hour_of_day     = Array.new(contents_size)
  day_of_week     = Array.new(contents_size)
  cal = { 0 => 'sunday', 1 => 'monday', 2 => 'tuesday', 3 => 'wednesday',
          4 => 'thursday', 5 => 'friday', 6 => 'saturday' }

  contents.each_with_index do |row, index|
    id                 = row[0]
    name               = row[:first_name]
    zipcode            = clean_zipcode(row[:zipcode])
    legislators        = legislators_by_zipcode(zipcode)
    reg_date           = row[:regdate]
    untidy_numbers     = row[:homephone]
    phone_number       = clean_phone_number(row[:homephone])
    reg_date_to_print  = DateTime.strptime(reg_date, '%m/%d/%y %H:%M')
    hour_of_day[index] = reg_date_to_print.hour
    day_of_week[index] = reg_date_to_print.wday

    form_letter = erb_template.result(binding)
    save_thank_you_letter(id, form_letter)
  end

  puts "Most Active Hour is : #{count_frequency(hour_of_day)}"
  puts "Most Active Day is : #{cal[count_frequency(day_of_week)].capitalize}"
end

event_manager
