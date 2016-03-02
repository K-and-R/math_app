ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role_ids

  index do
    selectable_column
    id_column
    column :email
    column :roles do |user|
      user.roles.each.map(&:name).join(", ")
    end
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  show do |user|
    attributes_table do
      row :name
      row :email
      row :created_at
      row :sign_in_count
      row :last_sign_in_at
      row :roles do |user|
        user.roles.each.map(&:name).join(", ")
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :email
      f.input :password, {placeholder: "Leave blank to remain unchanged", required: false}
      f.input :roles, as: :check_boxes
    end
    f.actions
  end

  controller do
    def create_resource(object)
      if params['user'].present? && params['user']['role_ids'].present?
        params['user']['role_ids'].compact.each do |id|
          object.roles << Role.find(id) if id.present?
        end
      end 
      object.skip_validation_for :password
      object.skip_confirmation!
      object.save! if object.valid?
    end
    def update_resource(object, attributes)
      roles = []
      if params['user'].present? && params['user']['role_ids'].present?
        params['user']['role_ids'].compact.each do |id|
          roles << Role.find(id) if id.present?
        end
      end 
      object.roles = roles
      object.skip_validation_for :password
      object.skip_confirmation!
      object.update_attributes(*attributes)
      object.save! if object.valid?
    end
  end
end
