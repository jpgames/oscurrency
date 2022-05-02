class CategorySweeper < ActionController::Caching::Sweeper
  observe Category
  
  def after_create(category)
    clear_cache
  end
  
  def after_update(category)
    clear_cache
  end
  
  def after_destroy(category)
    clear_cache
  end
  
  private
  
  def clear_cache
    #logger.info "cache sweep" # Causes heroku exception
    ActionController::Base.new.expire_fragment('skillbank', options = nil)
  end
end
