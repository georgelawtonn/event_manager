require 'csv'

def clean_phonenumber(phonenumber)
  phonenumber = phonenumber.scan(/\d/)
  if phonenumber.length >= 10 && phonenumber.length <= 11
    if phonenumber.length == 11
      if phonenumber[0].to_s == "1"
        return phonenumber[1..].join
      else
        return "Bad Number"
      end
    end
    return phonenumber.join
  end
  return "Bad Number"
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  phonenumber = row[:homephone]
  phonenumber = clean_phonenumber(phonenumber)
  puts phonenumber
end