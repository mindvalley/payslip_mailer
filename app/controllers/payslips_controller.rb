class PayslipsController < ApplicationController
  def index
    @payslip = Payslip.new
  end

  def create
    # raise params.inspect
    @payslip = Payslip.new(
      fullname: 'Tristan Gomez',
      email: 'tristan@mindvalley.com',
      date_joined: Time.now.to_s
    )
    SlipMailer.payslip_email(@payslip).deliver
  end
end
