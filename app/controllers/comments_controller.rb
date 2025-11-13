class CommentsController < ApplicationController
  allow_unauthenticated_access only: %i[ show ]
  before_action :set_product, only: %i[ show ]

  def show
  end

  def new
    @comment = Comment.new(product_id: params[:product_id])
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to Product.find(@comment.product_id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.expect(comment: [ :product_id, :body ])
    end
end
