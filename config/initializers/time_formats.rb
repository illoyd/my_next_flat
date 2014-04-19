Time::DATE_FORMATS[:short_date]  = ->(time) {
  time.year == Time.now.year ? time.strftime('%e %b') : time.strftime('%e %b \'%y')
}