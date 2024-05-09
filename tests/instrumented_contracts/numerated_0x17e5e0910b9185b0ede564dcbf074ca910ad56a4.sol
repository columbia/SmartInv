1 contract TeikhosBounty {
2 
3     // Proof-of-public-key in format 2xbytes32, to support xor operator and ecrecover r, s v format
4     bytes32 proof_of_public_key1 = hex"381c185bf75548b134adc3affd0cc13e66b16feb125486322fa5f47cb80a5bf0";
5     bytes32 proof_of_public_key2 = hex"5f9d1d2152eae0513a4814bd8e6b0dd3ac8f6310c0494c03e9aa08bcd867c352";
6 
7     function authenticate(bytes _publicKey) { // Accepts an array of bytes, for example ["0x00","0xaa", "0xff"]
8 
9         // Get address from public key
10         address signer = address(keccak256(_publicKey));
11 
12         // Split public key in 2xbytes32, to support xor operator and ecrecover r, s v format
13 
14         bytes32 publicKey1;
15         bytes32 publicKey2;
16 
17         assembly {
18         publicKey1 := mload(add(_publicKey,0x20))
19         publicKey2 := mload(add(_publicKey,0x40))
20         }
21 
22         // Use xor (reverse cipher) to get signature in r, s v format
23         bytes32 r = proof_of_public_key1 ^ publicKey1;
24         bytes32 s = proof_of_public_key2 ^ publicKey2;
25 
26         bytes32 msgHash = keccak256("\x19Ethereum Signed Message:\n64", _publicKey);
27 
28         // The value v is not known, try both 27 and 28
29         if(ecrecover(msgHash, 27, r, s) == signer) suicide(msg.sender);
30         if(ecrecover(msgHash, 28, r, s) == signer) suicide(msg.sender);
31     }
32     
33     function() payable {}                            
34 
35 }