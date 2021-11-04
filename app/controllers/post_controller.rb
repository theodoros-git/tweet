class PostController < ApplicationController

  def index
    render "post/index", layout: false
  end
end
