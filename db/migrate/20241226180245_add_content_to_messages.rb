class AddContentToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :content, :string
  end
end
