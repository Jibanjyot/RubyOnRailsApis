class AuthorsController < ApplicationController
    # before_action :authorize_request, except: [:create, :sign_in]
    skip_before_action :verify_authenticity_token
    
    def create
        author_params = JSON.parse(request.body.read)
        # password = author_params['password']
        # encrypted_password = BCrypt::Password.create(password)
        # author_params['password'] = encrypted_password

        author = Author.new(author_params)
        if author.save
          render json: { message: 'Author created successfully' }, status: :created
        else
          render json: { errors: author.errors.full_messages }, status: :unprocessable_entity
        end
    end


    def sign_in
        # authorParams = JSON.parse(request.body.read)
        author = Author.find_by(email: params[:email])

        if author && author.authenticate(params[:password])
          # Generate the token and return it in the response
          token = TokenService.encode({ author_id: author.id })
          render json: { message: 'Sign in successful', token: token }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
    end

    def send_custom_email
      emailParams = JSON.parse(request.body.read)
      email = emailParams["email"]
      subject = emailParams["subject"]
      content = emailParams["content"]
  
      if email.present? && subject.present? && content.present?
        EmailsMailer.custom_email(email, subject, content).deliver_now
        render json: { message: 'Custom email sent successfully' }, status: :ok
      else
        render json: { error: 'Email, subject, or content is missing' }, status: :unprocessable_entity
      end
    end
end
