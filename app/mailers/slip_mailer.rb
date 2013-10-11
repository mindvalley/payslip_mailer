class SlipMailer < ActionMailer::Base
  default from: 'Payroll <payroll@mindvalley.com>',
          subject: 'You\'ve got paid! :)',
          content_type: 'text/html'

  def payslip_email(payslip)
    begin
      @payslip = payslip
      @payslip.date_joined = Date.strptime payslip.date_joined, '%m/%d/%Y'
      @payslip.payslip_date = Date.strptime payslip.payslip_date, '%m/%d/%Y'
      @payslip.bonus_percentage = (payslip.bonus.to_f / payslip.base_salary.to_f) * 100
      mail(to: @payslip.email)
    rescue Exception => e
      Rails.logger.error e.inspect
      ErrorMailer.error_email(@payslip.email, e).deliver
    end
  end
end