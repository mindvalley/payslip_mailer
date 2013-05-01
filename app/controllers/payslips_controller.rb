require 'csv'
class PayslipsController < ApplicationController
  def index
    @payslip = Payslip.new
  end

  def create
    # raise params[:payslip].inspect
    Rails.logger.info "*** Upload started #{Time.now} ***"

    infile = params[:payslip][:file].read

    n, errs, headers = 0, [], []
    CSV.parse(infile) do |row|
      n += 1
      if n == 1
        headers = row.map {|i| i.to_s.downcase.parameterize.underscore.to_sym }
        next
      end
      # skip blank row
      next if row.join.blank?

      line = {}
      headers.each_with_index {|header, index| line[header] = row[index]}

      @payslip = Payslip.new(line)
      SlipMailer.payslip_email(@payslip).deliver

    end

    Rails.logger.info "*** Upload ended #{Time.now} ***"
    redirect_to payslips_path, notice: 'CSV uploaded successfully'
  end
end
