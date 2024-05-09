1 pragma solidity 
2 
3 
4 
5 
6 ^0.5.0;
7 
8 contract Lockbox {
9 
10     event PayOut(
11         address indexed to,
12         uint indexed nonce,
13         uint256 amount
14     );
15 
16     uint constant UINT_MAX = ~uint(0);
17 
18     address public owner; // = msg.sender;
19     address payable public returnFundsAddress;
20 
21     mapping(uint256 => bool) usedNonces;
22 
23     constructor(address payable returnFunds) public payable {
24         owner = msg.sender;
25         returnFundsAddress = returnFunds;
26     }
27 
28     // @notice Will receive any eth sent to the contract
29     function () external payable {
30     }
31 
32     function getOwner() public view returns (address) {
33         return owner;
34     }
35 
36     function claimPayment(uint256 amount, uint nonce, bytes memory sig) public {
37         require(!usedNonces[nonce], "Reused nonce");
38 
39         // This recreates the message that was signed on the client.
40         bytes32 message = prefixed(keccak256(abi.encodePacked(amount, nonce, this)));
41 
42         //return recoverSigner(message, sig);
43         require(recoverSigner(message, sig) == owner, "Non-owner signature");
44         
45         if (nonce == 0) {
46             require(amount == 1, "Req. 1 WEI amt for 0 nonce");
47         } else {
48             usedNonces[nonce] = true;
49         }
50 
51         emit PayOut(msg.sender, nonce, amount);
52         msg.sender.transfer(amount);
53     }
54 
55     function returnFunds(uint256 amount, uint[] memory nonces) public {
56         require(msg.sender == owner, "Non-owner sender");
57 
58         for (uint i = 0; i < nonces.length; i++){
59             if (nonces[i] != 0)
60                 usedNonces[nonces[i]] = true;
61         }
62 
63         emit PayOut(returnFundsAddress, UINT_MAX, amount);
64         returnFundsAddress.transfer(amount);
65     }
66 
67     // Destroy contract and reclaim leftover funds.
68     function kill() public {
69         require(msg.sender == owner, "Non-owner sender");
70         selfdestruct(returnFundsAddress);
71     }
72 
73     // Signature methods
74     function splitSignature(bytes memory sig)
75         internal
76         pure
77         returns (uint8, bytes32, bytes32)
78     {
79         require(sig.length == 65, "Malformed sig");
80 
81         bytes32 r;
82         bytes32 s;
83         uint8 v;
84 
85         assembly {
86             // first 32 bytes, after the length prefix
87             r := mload(add(sig, 32))
88             // second 32 bytes
89             s := mload(add(sig, 64))
90             // final byte (first byte of the next 32 bytes)
91             v := byte(0, mload(add(sig, 96)))
92         }
93 
94         // support both versions of `eth_sign` responses
95         if (v < 27) 
96             v += 27;
97 
98         return (v, r, s);
99     }
100 
101     function recoverSigner(bytes32 message, bytes memory sig)
102         internal
103         pure
104         returns (address)
105     {
106         uint8 v;
107         bytes32 r;
108         bytes32 s;
109 
110         (v, r, s) = splitSignature(sig);
111 
112         return ecrecover(message, v, r, s);
113     }
114 
115     // Builds a prefixed hash to mimic the behavior of eth_sign.
116     function prefixed(bytes32 hash) internal pure returns (bytes32) {
117         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
118     }
119 }