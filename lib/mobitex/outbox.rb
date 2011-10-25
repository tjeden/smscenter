module Mobitex

  class Outbox
    DEFAULT_FROM = 'SMS Service'
    DEFAULT_TYPE = 'sms'

    @@default_from = DEFAULT_FROM unless defined? @@default_from
    def self.default_from; @@default_from; end
    def self.default_from=(default_from); @@default_from = default_from; end
        
    @@default_type = DEFAULT_TYPE unless defined? @@default_type
    def self.default_type; @@default_type; end
    def self.default_type=(default_type); @@default_type = default_type; end
        
    def self.configure
      yield self
    end

    def initialize(user, pass)
      @connection = Connection.new(Mobitex.site, user, pass)
    end

    def deliver_sms(receiver, message_text, opts = {})
      params = {
          :number => receiver,
          :text   => message_text,
          :from   => self.class.default_from,
          :type   => self.class.default_type
      }.merge!(opts)

      raw_response = @connection.post('/send.php', params)
      handle_response(parse_response(raw_response.body))
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