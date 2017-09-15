# frozen_string_literal: true

ActiveAdmin.register User do
  menu priority: 2
  permit_params :first_name,
                :last_name,
                :institution,
                :role,
                :email,
                :phone_number,
                :password,
                :password_confirmation,
                :is_approved

  before_action :send_approval_emails, only: :update

  controller do
    def send_approval_emails
      nil if resource.is_approved || !params[:user][:is_approved].to_b
      AdminMailer.delay.new_user_approved_notification(resource, current_user)
    end
  end

  collection_action :send_invitation_emails, method: :post do
    UserMailer.delay.send_new_user_invitation(params)
    redirect_to admin_dashboard_path, notice: "Utilisateur #{params[:email]} invité."
  end

  action_item :impersonate, only: :show do
    link_to('Impersonate', impersonate_engine.impersonate_user_path(user.id))
  end

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :is_approved
    column 'Impersonate' do |user|
      link_to('Impersonate', impersonate_engine.impersonate_user_path(user.id))
    end
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :is_approved

  form do |f|
    f.inputs I18n.t('active_admin.user.user_info') do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :institution
      f.input :role
      f.input :phone_number
      f.input :password
      f.input :password_confirmation
      f.input :contact_page_order
      f.input :contact_page_role
    end

    f.inputs I18n.t('active_admin.user.user_activation') do
      f.input :is_approved, as: :boolean
    end

    f.actions
  end

  controller do
    def update
      update_params_depending_on_password
      redirect_or_display_form
    end

    def update_params_depending_on_password
      @user = User.find(params[:id])
      if params[:user][:password].blank?
        @user.update_without_password(update_without_password)
      else
        @user.update_attributes(update_with_password)
      end
    end

    def redirect_or_display_form
      if @user.errors.blank?
        redirect_to admin_users_path, notice: 'User updated successfully.'
      else
        render :edit
      end
    end

    def update_without_password
      params.require(:user).permit(
        %i[first_name last_name email institution role phone_number is_approved contact_page_order contact_page_role]
      )
    end

    def update_with_password
      permitted_keys = %i[first_name last_name email institution role phone_number password password_confirmation]
      permitted_keys += %i[is_approved contact_page_order contact_page_role]
      params.require(:user).permit(permitted_keys)
    end
  end
end
