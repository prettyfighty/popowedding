module CommentHelper
  def comment_message(comment)
    comment.message.size > 20 ? "#{comment.message[0..19]}..." : comment.message[0..19]
  end
end
