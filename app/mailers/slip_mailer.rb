class SlipMailer < ActionMailer::Base
  default from: 'Nicole <nicole@mindvalley.com>',
          subject: 'You\'ve got paid! :)',
          content_type: 'text/html'

  def payslip_email(payslip)
    @payslip = payslip
    @payslip.date_joined = Date.parse(payslip.date_joined)
    @payslip.bonus_percentage = (payslip.bonus.to_f / payslip.base_salary.to_f) * 100
    mail(to: @payslip.email)
  end
end