class Admin::SnackController < Admin::AdminController

  def index
    render json: { name: "donut", description: "delicious!" }
  end

end
