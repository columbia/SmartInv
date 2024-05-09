1 contract TeikhosBounty {
2 
3     // Proof-of-public-key in format 2xbytes32, to support xor operator and ecrecover r, s v format
4     bytes32 proof_of_public_key1 = hex"94cd5137c63cf80cdd176a2a6285572cc076f2fbea67c8b36e65065be7bc34ec";
5     bytes32 proof_of_public_key2 = hex"9f6463aadf1a8aed68b99aa14538f16d67bf586a4bdecb904d56d5edb2cfb13a";
6     
7     function authenticate(bytes _publicKey) returns (bool) { // Accepts an array of bytes, for example ["0x00","0xaa", "0xff"]
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
29         if(ecrecover(msgHash, 27, r, s) == signer) return true;
30         if(ecrecover(msgHash, 28, r, s) == signer) return true;
31     }
32     
33     function() payable {}                            
34 
35 }