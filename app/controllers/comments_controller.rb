class CommentsController < ApplicationController
  allow_unauthenticated_access only: %i[ show ]
  before_action :set_product, only: %i[ show ]

  def show
  end

  def new
    @comment = Comment.new(product_id: params[:product_id])
    request.variant = determine_variant
  end

  def create
    @comment = Comment.create!(comment_params)

    respond_to do |format|
      format.html do
        redirect_to @comment.product
      end

      format.turbo_stream do
        render turbo_stream: turbo_stream.append("comments", partial: "comments/index_element", locals: { comment: @comment })
        #render turbo_stream: turbo_stream.refresh(request_id: nil)
      end
    end
  end

  private
    def determine_variant
      if turbo_frame_request?
        return :turbo_frame
      else
        return :html
      end
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.expect(comment: [ :product_id, :body ])
    end
end
