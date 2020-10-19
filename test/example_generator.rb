# frozen_string_literal: true

require_relative('./test_helper.rb')
require('securerandom')

class ExampleGenerator
  def self.boleto_payment_example(schedule: true)
    StarkBank::BoletoPayment.new(
      line: '34191.09008 61713.957308 71444.640008 2 934300' + rand(1e8 - 1).to_s.rjust(8, '0'),
      scheduled: schedule ? Date.today + 2 : nil,
      description: 'loading a random account',
      tax_id: '20.018.183/0001-80'
    )
  end

  def self.transaction_example
    StarkBank::Transaction.new(
      amount: 50,
      receiver_id: '5768064935133184',
      external_id: SecureRandom.base64,
      description: 'Transferência para Workspace aleatório'
    )
  end

  def self.transfer_example(schedule: false)
    StarkBank::Transfer.new(
      amount: rand(1000),
      name: 'João',
      tax_id: '01234567890',
      bank_code: '01',
      branch_code: '0001',
      account_number: '10000-0',
      scheduled: schedule ? Time.now + 24 * 3600 : nil
    )
  end

  def self.utility_payment_example(schedule: true)
    StarkBank::UtilityPayment.new(
      bar_code: '8366000' + rand(1e5).to_s.rjust(8, '0') + '01380074119002551100010601813',
      scheduled: schedule ? Date.today + 2 : nil,
      description: 'pagando a conta'
    )
  end

  def self.payment_request_example
    payment = create_payment
    due = nil
    unless payment.is_a?(StarkBank::Transaction)
      days = rand(1..10)
      due = Date.today + days
    end
    StarkBank::PaymentRequest.new(payment: payment, center_id: ENV['SANDBOX_CENTER_ID'], due: due)
  end

  def self.create_payment
    option = rand(4)
    case option
    when 0
      transfer_example(schedule: false)
    when 1
      transaction_example
    when 2
      boleto_payment_example(schedule: false)
    when 3
      utility_payment_example(schedule: false)
    else
      raise(ArgumentError, 'Bad random number')
    end
  end
end
