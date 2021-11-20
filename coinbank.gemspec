files=%w[README.md
bank1.csv
bin/prices
bin/prices_today.rb
coinbank.gemspec
]
Gem::Specification.new do |s|
  s.name = 'coinbank'
  s.version = '0.0.1'
  s.date = '2021-08-01'
  s.summary = "Personal portfolio tracker"
  s.authors = ["xxanon"]
  s.email = "ironald@gmail.com"
  s.files = files
  s.executables << 'prices'
  s.executables << 'prices_today.rb'
  s.homepage = "https://github.com/nonnax/coinbank.git"
  s.license = "GPL-3.0"

  # s.add_dependency "rover-df"
  # s.add_dependency "aitch"
end
