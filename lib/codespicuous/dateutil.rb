
module DateUtil

  def begin_of_week(date)
    date - (date.cwday-1)
  end

  def string_date(date)
    date.strftime("%Y-%m-%d")
  end

  def for_each_week(start_date, end_date)
    (begin_of_week(start_date)..begin_of_week(end_date)).step(7) { |week|
      yield week
    }
  end

end
