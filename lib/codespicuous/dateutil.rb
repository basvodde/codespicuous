
module DateUtil

  def begin_of_week(date)
    date - (date.cwday-1)
  end

  def string_date(date)
    date.strftime("%Y-%m-%d")
  end

  def for_each_week
    (begin_of_week(earliest_commit_date)..begin_of_week(latest_commit_date)).step(7) { |week|
      yield week
    }
  end

end
