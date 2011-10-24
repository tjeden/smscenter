module Mobitex

  class Sms
    attr_accessor :type, :number, :text, :from, :ext_id

    def initialize(options = {})
    end

    def deliver!
      request = Curl::Easy.http_post('http://api.statsms.net/send.php',
                                     Curl::PostField.content('user', Mobitex.user),
                                     Curl::PostField.content('pass', Mobitex.pass),
                                     Curl::PostField.content('type', type),
                                     Curl::PostField.content('number', number),
                                     Curl::PostField.content('text', text),
                                     Curl::PostField.content('from', from),
                                     Curl::PostField.content('ext_id', ext_id))
      response = parse_response(request.body_str)

      if response['Status'] == '002'
        true
      else
        raise DeliveryError
      end
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

  end

end
