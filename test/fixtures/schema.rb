ActiveRecord::Schema.define do
  create_table 'posts', :force => true do |t|
    t.column 'title', :string
    t.column 'text', :text
  end
  create_table 'users', :force => true do |t|
    t.column 'name', :string
  end
end
