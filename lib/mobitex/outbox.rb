require 'mobitex/message'
require 'mobitex/connection'
require 'mobitex/delivery_errors'

module Mobitex

  class Outbox
    attr_accessor *Mobitex::Config::VALID_OPTIONS_KEYS

    def initialize(options = {})
      options = Mobitex.options.merge(options)

      Mobitex::Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, options[key]) # @api_site = options[:api_site]
      end

      @connection = Connection.new(Mobitex.api_site, options[:api_user], options[:api_pass])
    end

    def deliver(receiver, message, options = {})
      message = Mobitex::Message.new(receiver, message, {:from => message_from}.merge(options))
      raw_response = @connection.post('/send.php', message.to_params)
      handle_response(parse_response(raw_response.body))
    end

    def bulk_deliver(receivers, message, options = {})
      message = Mobitex::Message.new([*receivers].join(','), message, {:from => message_from}.merge(options))
      raw_response = @connection.post('/send.php', message.to_params)
      parse_bulk_response(raw_response.body)
    end

    private

    # Returns hash from Mobitex response:
    #
    #     parse_response('Status: 001, Id: 3e2dc963309c6b574f6c7467a62ef25b, Number: 123456789')
    #         # -> {'Status' => '001', 'Id' => '3e2dc963309c6b574f6c7467a62ef25b', 'Number' => '123456789'}
    def parse_response(raw_response)
      response = {}
      raw_response.to_s.split(',').map{ |e| part = e.partition(':'); response[part.first.strip] = part.last.strip }
      response
    end

    # Returns hash from Mobitex bulk response:
    #
    #     parse_bulk_response("Status: 001, Id: 3e2dc963309c6b574f6c7467a62ef25b, Number: 123456789\nStatus: 106, Id: 251eb8c426466a149bacf15f6c00eacf, Number: 987654321")
    #         # -> [{'Status' => '001', 'Id' => '3e2dc963309c6b574f6c7467a62ef25b', 'Number' => '123456789'},
    #         #     {'Status' => '106', 'Id' => '251eb8c426466a149bacf15f6c00eacf', 'Number' => '987654321'}]
    def parse_bulk_response(raw_bulk_response)
      raw_bulk_response.lines.map do |raw_response|
        parse_response(raw_response)
      end
    end

    def handle_response(response)
      case response['Status']
        when '001' then raise(UnauthorizedAccess.new(response))
        when '002' then response
        when '103' then raise(BlankText.new(response))
        when '104' then raise(NoSender.new(response))
        when '105' then raise(TextTooLong.new(response))
        when '106' then raise(BadNumber.new(response))
        when '107' then raise(BadType.new(response))
        when '110' then raise(TypeNotSupported.new(response))
        when '113' then raise(TextTooLong.new(response))
        when '114' then raise(SenderUnauthorized.new(response))
        when '201' then raise(System.new(response))
        when '202' then raise(EmptyAccount.new(response))
        when '204' then raise(AccountInactive.new(response))
        when '205' then raise(DestinationNetworkUnavailable.new(response))
        when '301' then raise(BadMessageId.new(response))
        else            raise(DeliveryError.new(response))
      end
    end

  end

end
