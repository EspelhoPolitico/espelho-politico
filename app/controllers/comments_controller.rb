class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end
 
  def new
  end
 
  def create
  end
end