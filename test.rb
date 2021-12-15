require 'securerandom'
require 'base64'
require_relative 'crypto'
# Let's say dist1 is Actionboard folder
# Let's say dist2 is your folder

#STEP 1: This process is happening in your server

key  = SecureRandom.hex(16) #32 digit random number
iv   = SecureRandom.hex(8) #16 digit random number
text = "PING"

# you have to encrypt data using +our_public_key+ which we provided
encrypted_key  = Crypto::Asymmetric.public_encrypt(File.read("./keys/dist1/public.pem"), key)
encrypted_iv   = Crypto::Asymmetric.public_encrypt(File.read("./keys/dist1/public.pem"), iv)
encrypted_text = Crypto::Symmetric.encrypt(key, iv, text)

# Sending this payload to Actionboard
payload = {
  "encrypted_key"  => Base64.strict_encode64(encrypted_key),
  "encrypted_iv"   => Base64.strict_encode64(encrypted_iv),
  "encrypted_data" => Base64.strict_encode64(encrypted_text)
}

#STEP 2: This process will happen in Actionboard server
#Actionboard will decrypt your payload using our private key

pay_key  = Base64.strict_decode64(payload['encrypted_key'])
pay_iv   = Base64.strict_decode64(payload['encrypted_iv'])
pay_text = Base64.strict_decode64(payload['encrypted_data'])

key  = Crypto::Asymmetric.private_decrypt(File.read("./keys/dist1/private.pem"), pay_key)
iv   = Crypto::Asymmetric.private_decrypt(File.read("./keys/dist1/private.pem"), pay_iv)
text = Crypto::Symmetric.decrypt(key, iv, pay_text)
puts text

if text == 'PING'
  puts "You message is decoded successfully"

  #STEP 3: sending response
  #Now if success Actionboard will send a response to your message
  #Here we will encrypt message using your public key

  key  = SecureRandom.hex(16) #32 digit random number
  iv   = SecureRandom.hex(8) #16 digit random number
  text = "PONG"

  encrypted_key  = Crypto::Asymmetric.public_encrypt(File.read("./keys/dist2/public.pem"), key)
  encrypted_iv   = Crypto::Asymmetric.public_encrypt(File.read("./keys/dist2/public.pem"), iv)
  encrypted_text = Crypto::Symmetric.encrypt(key, iv, text)

  #Actionboard will send this response to you
  response = {
    "encrypted_key"  => Base64.strict_encode64(encrypted_key),
    "encrypted_iv"   => Base64.strict_encode64(encrypted_iv),
    "encrypted_data" => Base64.strict_encode64(encrypted_text)
  }

  #STEP 4: This process should happen in your server
  # you have to decrypt response using your private key

  res_key  = Base64.strict_decode64(response['encrypted_key'])
  res_iv   = Base64.strict_decode64(response['encrypted_iv'])
  res_text = Base64.strict_decode64(response['encrypted_data'])

  key  = Crypto::Asymmetric.private_decrypt(File.read("./keys/dist2/private.pem"), res_key)
  iv   = Crypto::Asymmetric.private_decrypt(File.read("./keys/dist2/private.pem"), res_iv)
  text = Crypto::Symmetric.decrypt(key, iv, res_text)
  puts text

else
  puts "Failure!!!"
end



