# frozen_string_literal: true

require('starkcore')
require_relative('../utils/rest')
require_relative('boleto')


module StarkBank
  class Boleto
    # # Boleto::Log object
    #
    # Every time a Boleto entity is updated, a corresponding Boleto::Log
    # is generated for the entity. This log is never generated by the
    # user, but it can be retrieved to check additional information
    # on the Boleto.
    #
    # ## Attributes:
    # - id [string]: unique id returned when the log is created. ex: '5656565656565656'
    # - boleto [Boleto]: Boleto entity to which the log refers to.
    # - errors [list of strings]: list of errors linked to this Boleto event
    # - type [string]: type of the Boleto event which triggered the log creation. ex: 'registered' or 'paid'
    # - created [DateTime]: creation datetime for the log. ex: DateTime.new(2020, 3, 10, 10, 30, 0, 0)
    class Log < StarkCore::Utils::Resource
      attr_reader :id, :created, :type, :errors, :boleto
      def initialize(id:, created:, type:, errors:, boleto:)
        super(id)
        @type = type
        @errors = errors
        @boleto = boleto
        @created = StarkCore::Utils::Checks.check_datetime(created)
      end

      # # Retrieve a specific Log
      #
      # Receive a single Log object previously created by the Stark Bank API by passing its id
      #
      # ## Parameters (required):
      # - id [string]: object unique id. ex: '5656565656565656'
      #
      # ## Parameters (optional):
      # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
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
      # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
      # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
      # - types [list of strings, default nil]: filter for log event types. ex: 'paid' or 'registered'
      # - boleto_ids [list of strings, default nil]: list of Boleto ids to filter logs. ex: ['5656565656565656', '4545454545454545']
      # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
      #
      # ## Return:
      # - list of Log objects with updated attributes
      def self.query(limit: nil, after: nil, before: nil, types: nil, boleto_ids: nil, user: nil)
        after = StarkCore::Utils::Checks.check_date(after)
        before = StarkCore::Utils::Checks.check_date(before)
        StarkBank::Utils::Rest.get_stream(
          limit: limit,
          after: after,
          before: before,
          types: types,
          boleto_ids: boleto_ids,
          user: user,
          **resource
        )
      end

      # # Retrieve paged Logs
      #
      # Receive a list of up to 100 Log objects previously created in the Stark Bank API and the cursor to the next page.
      # Use this function instead of query if you want to manually page your requests.
      #
      # ## Parameters (optional):
      # - cursor [string, default nil]: cursor returned on the previous page function call
      # - limit [integer, default nil]: maximum number of objects to be retrieved. Unlimited if nil. ex: 35
      # - after [Date, DateTime, Time or string, default nil]: date filter for objects created only after specified date. ex: Date.new(2020, 3, 10)
      # - before [Date, DateTime, Time or string, default nil]: date filter for objects created only before specified date. ex: Date.new(2020, 3, 10)
      # - types [list of strings, default nil]: filter for log event types. ex: 'paid' or 'registered'
      # - boleto_ids [list of strings, default nil]: list of Boleto ids to filter logs. ex: ['5656565656565656', '4545454545454545']
      # - user [Organization/Project object]: Organization or Project object. Not necessary if StarkBank.user was set before function call
      #
      # ## Return:
      # - list of Log objects with updated attributes and cursor to retrieve the next page of Log objects
      def self.page(cursor: nil, limit: nil, after: nil, before: nil, types: nil, boleto_ids: nil, user: nil)
        after = StarkCore::Utils::Checks.check_date(after)
        before = StarkCore::Utils::Checks.check_date(before)
        return StarkBank::Utils::Rest.get_page(
          cursor: cursor,
          limit: limit,
          after: after,
          before: before,
          types: types,
          boleto_ids: boleto_ids,
          user: user,
          **resource
        )
      end

      def self.resource
        boleto_maker = StarkBank::Boleto.resource[:resource_maker]
        {
          resource_name: 'BoletoLog',
          resource_maker: proc { |json|
            Log.new(
              id: json['id'],
              created: json['created'],
              type: json['type'],
              errors: json['errors'],
              boleto: StarkCore::Utils::API.from_api_json(boleto_maker, json['boleto'])
            )
          }
        }
      end
    end
  end
end
