module Mobitex

  class DeliveryError < StandardError; end

  class DeliveryCallbackError < DeliveryError; end

  class UnauthorizedAccess < DeliveryError; end

  class BlankText < DeliveryError; end

  class NoSender < DeliveryError; end

  class TextTooLong < DeliveryError; end

  class BadNumber < DeliveryError; end

  class BadType < DeliveryError; end

  class TypeNotSupported < DeliveryError; end

  class SenderUnauthorized < DeliveryError; end

  class System < DeliveryError; end

  class EmptyAccount < DeliveryError; end

  class AccountInactive < DeliveryError; end

  class DestinationNetworkUnavailable < DeliveryError; end

  class BadMessageId < DeliveryError; end

end