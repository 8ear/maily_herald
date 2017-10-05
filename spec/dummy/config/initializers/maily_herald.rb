MailyHerald.setup do |config|
  config.token_redirect {|subscription| "/" }

  config.context :all_users do |context|
    context.scope {User.active}
    context.destination {|user| user.email}
    context.attributes do |user| 
      attribute_group(:user) do
        attribute(:name) {user.name}
        attribute(:email) {user.email}
        attribute(:created_at) {user.created_at}
        attribute(:weekly_notifications) {user.weekly_notifications}
        attribute_group(:properties) do
          attribute(:prop1) { user.name[0] }
          attribute(:prop2) { 2 }
        end
      end
    end
  end

  config.list :locked_list do |list|
    list.context_name = :all_users
  end

  config.list :generic_list do |list|
    list.context_name = :all_users
  end

  config.one_time_mailing :locked_mailing do |mailing|
    mailing.enable
    mailing.title = "Locked mailing"
    mailing.subject = "Locked mailing"
    mailing.list = :generic_list
    mailing.start_at = "user.created_at"
    mailing.template = "User name: {{user.name}}."
  end

  config.one_time_mailing :test_mailing do |mailing|
    mailing.enable
    mailing.title = "Test mailing"
    mailing.subject = "Test mailing"
    mailing.list = :generic_list
    mailing.start_at = "user.created_at"
    mailing.template = "User name: {{user.name}}."
  end

  config.periodical_mailing :weekly_summary do |mailing|
    mailing.enable
    mailing.title = "Weekly summary"
    mailing.subject = "Weekly summary"
    mailing.list = :generic_list
    mailing.start_at = Proc.new{|user| user.created_at + 1.week}
    mailing.period = 1.week
    mailing.template = "User name: {{user.name}}."
  end
end
