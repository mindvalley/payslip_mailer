class Payslip
  include ::ActiveModel::Model
  attr_accessor :fullname,
    :email,
    :identification_no,
    :epf_no,
    :tax_ref_no,
    :date_joined,
    :days_worked,
    :days_worked_percentage,
    :base_salary,
    :basic_earned,
    :bonus,
    :gross_salary,
    :epf_employer,
    :epf_employee,
    :socso,
    :tax,
    :zakat,
    :adjustments,
    :comments,
    :total_deductions,
    :net_salary,

    :bonus_percentage

end