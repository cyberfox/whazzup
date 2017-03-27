class Tasks
  def initialize
    @hitlist = SBApplication.applicationWithBundleIdentifier("com.potionfactory.TheHitList")
    @last5 = []
  end

  def top(n)
    all_tasks.take(n)
  end

  def refresh(task)
    idx = @last5.index(task)
    @last5.insert(0, task)
    @last5.delete_at(idx+1) if idx != nil
    @last5 = @last5[0...5]
  end

  private
  def hitlist_tasks
    return to_enum(:hitlist_tasks) unless block_given?

    @hitlist.todayList.tasks.select do |task|
      !task.properties['completed'] && !task.properties['canceled']
    end.sort_by(&:priority).each do |task|
      yield task.title
    end
  end

  def all_tasks
    return to_enum(:all_tasks) unless block_given?

    done = {}
    @last5.each {|title| done[title]=true; yield title}
    hitlist_tasks.each {|title| yield title unless done[title]}
  end
end
