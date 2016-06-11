class CommentTopic < ActiveRecord::Migration
  def self.up
    create_table 'comment_topic', :id => false do |t|
    t.column 'comment_id', :integer
    t.column 'topic_id', :integer
    end
  end

  def self.down
    drop_table 'comment_topic'
  end
end
