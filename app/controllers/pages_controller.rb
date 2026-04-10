class PagesController < ApplicationController
  def home
    closure = Admin::ShopController.closure
    @shop_closed = closure && Date.today.between?(closure[:from], closure[:to])
    @shop_closure = closure if @shop_closed
  end

  def contact
  end
end
