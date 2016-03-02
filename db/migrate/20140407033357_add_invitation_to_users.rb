class AddInvitationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation_token, :string    
    add_column :users, :invited_at, :string
    add_column :users, :accepted_invite_at, :string
  end
end
