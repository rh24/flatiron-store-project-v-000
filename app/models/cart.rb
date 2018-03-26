class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :line_items
  has_many :items, through: :line_items

  # def add_item(new_item)
  #   if item_ids.include?(new_item)
  #     update_line_item = line_items.find_by(item_id: new_item)
  #     update_line_item.quantity += 1
  #     update_line_item.save
  #     update_line_item
  #     binding.pry
  #   else
  #     LineItem.new(item_id: new_item, cart_id: self.id)
  #   end
  # end
  # Why does the above method fail cart_feature_spec.rb:141?


  def add_item(item_id)
    line_item = self.line_items.find_by(item_id: item_id)
    if line_item
      line_item.quantity += 1
    else
      line_item=self.line_items.build(item_id: item_id)
    end
    line_item
  end

  def total
    cost = 0
    line_items.each { |li| cost += (Item.find_by(id: li.item_id).price * li.quantity) }
    cost
  end

  def checkout
    line_items.each do |line_item|
      line_item.item.inventory -= line_item.quantity
      line_item.item.save
    end
    status = "submitted"
    user.remove_cart
  end
end
