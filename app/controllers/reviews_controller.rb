class ReviewsController<ApplicationController
  before_action :set_item, only: [ :new, :create]
  before_action :set_review, only: [:edit, :update, :destroy]

  def new
  end

  def create
    if field_empty?
      flash[:error] = "Please fill in all fields in order to create a review."
      redirect_to "/items/#{@item.id}/reviews/new"
    else
      review = @item.reviews.create(review_params)
      if review.save
        flash[:success] = "Review successfully created"
        redirect_to "/items/#{@item.id}"
      else
        flash[:error] = "Rating must be between 1 and 5"
        render :new
      end
    end
  end

  def edit
  end

  def update
    @review.update(review_params)
    redirect_to "/items/#{@review.item.id}"
  end

  def destroy
    item = @review.item
    @review.destroy
    redirect_to "/items/#{item.id}"
  end

  private

  def review_params
    params.permit(:title,:content,:rating)
  end

  def field_empty?
    params = review_params
    params[:title].empty? || params[:content].empty? || params[:rating].empty?
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end
end
