class IssueNumbersController < ApplicationController

  def index
  	@issue_numbers_grid = initialize_grid(IssueNumber, 
      order:'id', 
      order_direction: 'desc')
  end

end
