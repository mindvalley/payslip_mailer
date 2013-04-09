class PayslipsController < ApplicationController
  def index
    @payslip = Payslip.new(
      email: 'tristan@mindvalley.com',
      date_joined: Time.now.to_s
    )
    SlipMailer.payslip_email(@payslip).deliver
  end
end
