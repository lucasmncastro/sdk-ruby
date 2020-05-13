# frozen_string_literal: true

require('starkbank')
require('user')

RSpec.describe(StarkBank::Boleto, '#boleto#') do
  context 'at least 10 paid boletos' do
    it 'query' do
      boletos = StarkBank::Boleto.query(limit: 10, status: 'paid', before: DateTime.now).to_a
      expect(boletos.length).to(eq(10))
      boletos.each do |boleto|
        expect(boleto.id).not_to(be_nil)
        expect(boleto.status).to(eq('paid'))
      end
    end
  end

  context 'no requirements' do
    it 'create, get, get_pdf and delete' do
      boleto = StarkBank::Boleto.create([example])[0]
      get_boleto = StarkBank::Boleto.get(boleto.id)
      expect(boleto.id).to(eq(get_boleto.id))
      pdf = StarkBank::Boleto.pdf(boleto.id)
      File.open('boleto.pdf', 'w') { |file| file.write(pdf) }
      delete_boleto = StarkBank::Boleto.delete(boleto.id)
      expect(boleto.id).to(eq(delete_boleto.id))
    end
  end

  def example
    StarkBank::Boleto.new(
      amount: 100_000,
      due: Time.now + 5 * 24 * 3600,
      name: 'Random Company',
      street_line_1: 'Rua ABC',
      street_line_2: 'Ap 123',
      district: 'Jardim Paulista',
      city: 'São Paulo',
      state_code: 'SP',
      zip_code: '01234-567',
      tax_id: '012.345.678-90',
      overdue_limit: 10,
      receiver_name: 'Random Receiver',
      receiver_tax_id: '123.456.789-09',
      fine: 0.00,
      interest: 0.00,
      descriptions: [
        {
          text: 'product A',
          amount: 123
        },
        {
          text: 'product B',
          amount: 456
        },
        {
          text: 'product C',
          amount: 789
        }
      ],
      discounts: [
        {
          percentage: 5,
          date: Time.now + 24 * 3600
        },
        {
          percentage: 2.5,
          date: Time.now + 2 * 24 * 3600
        }
      ]
    )
  end
end
