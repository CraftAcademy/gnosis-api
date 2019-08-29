class RegistrationsController < ::DeviseTokenAuth::RegistrationsController
  
  def create

    build_resource
    if params[:role] == 'research_group'
      if params[:registration_key].nil?
        render_json_error_response('Registration key is required for Sign up') and return
      end

      reg_key = RegistrationKey.find_by(combination: params[:registration_key])

      unless reg_key.nil?
        @resource.university = reg_key.user 
      else
        render_json_error_response('Invalid registration key') and return
      end
    end 
  

    # every line of code for the rest of the create action is devise code
    unless @resource.present?
      raise DeviseTokenAuth::Errors::NoResourceDefinedError,
            "#{self.class.name} #build_resource does not define @resource,"\
            ' execution stopped.'
    end

    @redirect_url = params.fetch(
      :confirm_success_url,
      DeviseTokenAuth.default_confirm_success_url
    )

    if confirmable_enabled? && !@redirect_url
      return render_create_error_missing_confirm_success_url
    end

    return render_create_error_redirect_url_not_allowed if blacklisted_redirect_url?

    resource_class.set_callback('create', :after, :send_on_create_confirmation_instructions)
    resource_class.skip_callback('create', :after, :send_on_create_confirmation_instructions)

    if @resource.respond_to? :skip_confirmation_notification!
      @resource.skip_confirmation_notification!
    end

    if @resource.save
      yield @resource if block_given?

      unless @resource.confirmed?
        @resource.send_confirmation_instructions({
          client_config: params[:config_name],
          redirect_url: @redirect_url
        })
      end

      if active_for_authentication?
        @token = @resource.create_token
        @resource.save!
        update_auth_header
      end

      render_create_success

    else
      clean_up_passwords @resource
      render_create_error
    end

  end

  private

  def render_create_success
    if @resource.role == 'university'  
      5.times { RegistrationKey.create(user: @resource) }
      @resource.reload
    end
    
    render json: {
            status: 'success',
            data:
              resource_data.merge(
                registration_keys: @resource.registration_keys
              )
          }
  end

  def render_json_error_response(message)
    render json: {
      status: 'error',
      data:   resource_data,
      errors: message
    }, status: 422
  end
end
