module Mobitex

  class Sms
    attr_accessor :type, :number, :text, :from, :ext_id

    def self.connection(refresh = false)
      @connection = Connection.new(Mobitex.site, Mobitex.user, Mobitex.pass) if refresh || @connection.nil?
      @connection
    end

    def initialize(options = {})
    end

    def deliver!
      response = connection.post('/send.php', {:type => type, :number => number, :text => text, :from => from}) # 'ext_id', ext_id
      handle_response(parse_response(response.body))
    end

    protected

    def connection(refresh = false)
      self.class.connection(refresh)
    end

    private

    # Returns hash from Mobitex response:
    #
    #     parse_response('Status: 001, Id: 3e2dc963309c6b574f6c7467a62ef25b, Number: 123456789')
    #         # -> {'Status' => '001', 'Id' => '3e2dc963309c6b574f6c7467a62ef25b', 'Number' => '123456789'}
    def parse_response(response)
      parsed = {}
      response.to_s.split(',').map{ |e| part = e.partition(':'); parsed[part.first.strip] = part.last.strip }
      parsed
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
