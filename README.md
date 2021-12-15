# axb-api-crypto-example

Install ruby in your computer

Then run
```
ruby test.rb
```

### Response

```
PING
You message is decoded successfully
PONG
```
----

### Steps for Encryption

1.	Generate 32 digit random number. Say RANDOMNO1.
2.	Encrypt RANDOMNO1 using RSA/ECB/PKCS1Padding and AXB Public Key.
3.	Encode the output of step 2 using Base64. Say ENCR_KEY.
4.	Generate another 16 digit random number. Say RANDOMNO2.
5.	Encode the output of step 4 using Base64. Say ENCR_IV.
6.	Perform AES-256-CBC encryption on DATA using RANDOMNO1 as key and RANDOMNO2 as IV.
7.	Encode the output of step 6 using Base64. Say ENCR_DATA.

Request Packet Sample:

```
{
 "encrypted_key": "<<ENCR_KEY>>",
 "encrypted_iv": "<<ENCR_IV>>",
 "encrypted_data": "<<ENCR_DATA>>"
}
```

-------

### Steps for Decryption

1. Base64 Decode the encrypted_key.
2. Decrypt the output of step 1 using (RSA/ECB/PKCS1) and the your Private Key.
3. Base64 Decode the encrypted_iv
4. Decrypt the output of step 3 using (RSA/ECB/PKCS1) and the your Private Key.
5. Base64 Decode the encrypted_data.
6. Decrypt output of step 5 using AES-256-CBC, step 2 output as key and step 4 output as IV.

