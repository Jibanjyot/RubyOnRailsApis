class EmailsMailer < ApplicationMailer
    def custom_email(email, subject, content)
        mail(to: email, from:'jibanjyotikalita510@gmail.com',subject: subject) do |format|
          format.text { render plain: content }
        end
    end

end
