class ErrorMailer < ActionMailer::Base
 default from: 'Payroll <payroll@mindvalley.com>',
         content_type: 'text/html'

  def error_email(staff_email)
    mail(to: staff_email, subject: "#{staff_email} #{Date.today} Error.")
  end

end
