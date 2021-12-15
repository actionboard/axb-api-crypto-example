require 'openssl'

module Crypto
  class Asymmetric

    # OpenSSL::X509::Certificate

    def self.public_encrypt(public_key, plain_text)
      OpenSSL::PKey::RSA.new(public_key).public_encrypt(plain_text)
    end

    def self.private_decrypt(private_key, encrypted_text)
      OpenSSL::PKey::RSA.new(private_key).private_decrypt(encrypted_text)
    end
  end

  class Symmetric

    def self.encrypt(key, iv, plain_text)
      cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      cipher.encrypt
      cipher.key = key
      cipher.iv  = iv
      aes        = cipher.update(plain_text)
      aes << cipher.final
      aes
    end

    def self.decrypt(key, iv, encrypted_text)
      decipher = OpenSSL::Cipher::AES.new(256, :CBC)
      decipher.decrypt
      decipher.key = key
      decipher.iv  = iv
      aes          = decipher.update(encrypted_text)
      aes << decipher.final
      aes
    end
  end
end
