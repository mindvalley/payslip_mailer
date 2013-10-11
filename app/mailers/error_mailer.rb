class ErrorMailer < ActionMailer::Base
 default from: 'Payroll <payroll@mindvalley.com>',
         content_type: 'text/html'

  def error_email(staff_email, error)
  	@staff_email = staff_email
  	@error = error
    mail(to: 'payroll@mindvalley.com', subject: "#{@staff_email} #{Date.today} Error.")
  end

end
