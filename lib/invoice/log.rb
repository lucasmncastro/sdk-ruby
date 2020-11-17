# frozen_string_literal: true

require_relative('../utils/resource')
require_relative('../utils/rest')
require_relative('../utils/checks')
require_relative('invoice')

module StarkBank
  class Invoice
    # # Invoice::Log object
    #
    # Every time an Invoice entity is updated, a corresponding Invoice::Log
    # is generated for the entity. This log is never generated by the
    # user, but it can be retrieved to check additional information
    # on the Invoice.
    #
    # ## Attributes:
    # - id [string]: unique id returned when the log is created. ex: '5656565656565656'
    # - invoice [Invoice]: Invoice entity to which the log refers to.
    # - errors [list of strings]: list of errors linked to this Invoice event
    # - type [string]: type of the Invoice event which triggered the log creation. ex: 'canceled' or 'paid'
    # - created [DateTime]: creation datetime for the log. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
    class Log < StarkBank::Utils::Resource
      attr_reader :id, :created, :type, :errors, :invoice
      def initialize(id:, created:, type:, errors:, invoice:)
        super(id)
        @type = type
        @errors = errors
        @invoice = invoice
        @created = StarkBank::Utils::Checks.check_datetime(created)
      end

      # # Retrieve a specific Log
      #
      # Receive a single Log object previously created by the Stark Bank API by passing its id
      #
      # ## Parameters (required):
      # - id [string]: object unique id. ex: '5656565656565656'
      #
      # ## Parameters (optional):
      # - user [Project object]: Project object. Not necessary if StarkBank.user was set before function call
      #
      # ## Return:
      # - Log object with updated attributes
      def self.get(id, user: nil)
        StarkBank::Utils::Rest.get_id(id: id, user: user, **resource)
      end

      # # Retrieve Logs
      #
      # Receive a generator of Log objects previously created in the Stark Bank API
      #
      # ## Parameters (optional):
      # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
      # - after [Date, DateTime, Time or string, default nil] date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
      # - before [Date, DateTime, Time or string, default nil] date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
      # - types [list of strings, default nil]: filter for log event types. ex: 'paid' or 'canceled'
      # - invoice_ids [list of strings, default nil]: list of Invoice ids to filter logs. ex: ['5656565656565656', '4545454545454545']
      # - user [Project object, default nil]: Project object. Not necessary if StarkBank.user was set before function call
      #
      # ## Return:
      # - list of Log objects with updated attributes
      def self.query(limit: nil, after: nil, before: nil, types: nil, invoice_ids: nil, user: nil)
        after = StarkBank::Utils::Checks.check_date(after)
        before = StarkBank::Utils::Checks.check_date(before)
        StarkBank::Utils::Rest.get_list(
          limit: limit,
          after: after,
          before: before,
          types: types,
          invoice_ids: invoice_ids,
          user: user,
          **resource
        )
      end

      def self.resource
        invoice_maker = StarkBank::Invoice.resource[:resource_maker]
        {
          resource_name: 'InvoiceLog',
          resource_maker: proc { |json|
            Log.new(
              id: json['id'],
              created: json['created'],
              type: json['type'],
              errors: json['errors'],
              invoice: StarkBank::Utils::API.from_api_json(invoice_maker, json['invoice'])
            )
          }
        }
      end
    end
  end
end