1 pragma solidity ^0.4.20;
2 
3 contract ReceiverPays {
4     address owner = msg.sender;
5 
6     mapping(uint256 => bool) usedNonces;
7 
8     // Funds are sent at deployment time.
9     function ReceiverPays() public payable { }
10 
11 
12     function claimPayment(uint256 amount, uint256 nonce, bytes sig) public {
13         require(!usedNonces[nonce]);
14         usedNonces[nonce] = true;
15 
16         // This recreates the message that was signed on the client.
17         bytes32 message = prefixed(keccak256(msg.sender, amount, nonce, this));
18 
19         require(recoverSigner(message, sig) == owner);
20 
21         msg.sender.transfer(amount);
22     }
23 
24     // Destroy contract and reclaim leftover funds.
25     function kill() public {
26         require(msg.sender == owner);
27         selfdestruct(msg.sender);
28     }
29 
30 
31     // Signature methods
32 
33     function splitSignature(bytes sig)
34         internal
35         pure
36         returns (uint8, bytes32, bytes32)
37     {
38         require(sig.length == 65);
39 
40         bytes32 r;
41         bytes32 s;
42         uint8 v;
43 
44         assembly {
45             // first 32 bytes, after the length prefix
46             r := mload(add(sig, 32))
47             // second 32 bytes
48             s := mload(add(sig, 64))
49             // final byte (first byte of the next 32 bytes)
50             v := byte(0, mload(add(sig, 96)))
51         }
52 
53         return (v, r, s);
54     }
55 
56     function recoverSigner(bytes32 message, bytes sig)
57         internal
58         pure
59         returns (address)
60     {
61         uint8 v;
62         bytes32 r;
63         bytes32 s;
64 
65         (v, r, s) = splitSignature(sig);
66 
67         return ecrecover(message, v, r, s);
68     }
69 
70     // Builds a prefixed hash to mimic the behavior of eth_sign.
71     function prefixed(bytes32 hash) internal pure returns (bytes32) {
72         return keccak256("\x19Ethereum Signed Message:\n32", hash);
73     }
74 }