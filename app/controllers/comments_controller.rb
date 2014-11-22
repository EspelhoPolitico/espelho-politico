class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end
 
  def new
  @comment = Comment.new
end
 
def create
  @comment = Comment.new(comment_params)
 
  if @comment.save
    flash[:success] = 'Your comment was successfully added!'
    redirect_to root_url
  else
    render 'new'
  end
end
 
end