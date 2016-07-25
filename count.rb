require 'csv'

results = []

WORDS = [
  'clinton',
  'hillary',
  'obama',
  'president',
  'trump',
  'father'
]

speech_files = Dir['./data/rnc16/*']
speech_files.each do |file|
  result = {}
  result[:name] = File.basename(file, '.txt').gsub('-', ' ')
  contents = File.read(file)

  WORDS.each do |word|
    result[word.to_sym] = contents.split(/#{word}/i).count
  end

  higher_hillary = [result[:clinton], result[:hillary]].max
  obama          = result[:obama]
  hillary_obama  = higher_hillary + obama
  higher_trump   = [result[:trump], result[:father]].max
  result['hillary + president'] = higher_hillary + obama
  result['hillary / trump'] = higher_hillary.to_f / result[:trump].to_f
  result['hillary+obama / trump'] = hillary_obama.to_f / result[:trump]

  results << result
end

CSV.open('results.csv', 'wb') do |csv|
  csv << results.first.keys
  results.each do |result|
    csv << result.values
  end
end

puts results
