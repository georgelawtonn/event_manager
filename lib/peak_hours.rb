require 'csv'
require 'time'

def organize_into_days(days_of_week, regdate)
  begin
    parsed_date = Time.strptime(regdate, '%m/%d/%y %H:%M')

    if parsed_date.year < 1970
      parsed_date = Time.new(parsed_date.year + 2000, parsed_date.month, parsed_date.day,
                             parsed_date.hour, parsed_date.min, parsed_date.sec)
    end

    days_of_week[parsed_date.wday] << parsed_date
  rescue ArgumentError => e
    puts "Error parsing date: #{regdate}. #{e.message}"
  end
end

def average_time(day_array)
  return "N/A" if day_array.empty?

  total_seconds = day_array.sum { |time| time.hour * 3600 + time.min * 60 + time.sec }
  average_seconds = total_seconds / day_array.length

  hours, remaining = average_seconds.divmod(3600)
  minutes, seconds = remaining.divmod(60)

  format("%02d:%02d", hours, minutes)
end

def day_with_most_registrations(days_of_week)
  day_counts = days_of_week.map(&:length)
  max_count = day_counts.max
  max_index = day_counts.index(max_count)
  days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

  [days[max_index], max_count]
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)


days_of_week = Array.new(7) { [] }

contents.each do |row|
  regdate = row[:regdate]
  organize_into_days(days_of_week, regdate)
end



days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
days_of_week.each_with_index do |day_array, index|
  puts "#{days[index]}'s Peak Hour Is About: #{average_time(day_array)}'"
  puts
end

busiest_day, registration_count = day_with_most_registrations(days_of_week)
puts "The day with the most registrations is #{busiest_day} with #{registration_count} registrations."