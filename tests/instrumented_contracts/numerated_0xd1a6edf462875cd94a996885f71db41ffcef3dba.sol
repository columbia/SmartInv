1 pragma solidity 0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
4 
5 /**
6  * @title Elliptic curve signature operations
7  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
8  * TODO Remove this library once solidity supports passing a signature to ecrecover.
9  * See https://github.com/ethereum/solidity/issues/864
10  */
11 
12 library ECDSA {
13 
14   /**
15    * @dev Recover signer address from a message by using their signature
16    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
17    * @param signature bytes signature, the signature is generated using web3.eth.sign()
18    */
19   function recover(bytes32 hash, bytes signature)
20     internal
21     pure
22     returns (address)
23   {
24     bytes32 r;
25     bytes32 s;
26     uint8 v;
27 
28     // Check the signature length
29     if (signature.length != 65) {
30       return (address(0));
31     }
32 
33     // Divide the signature in r, s and v variables
34     // ecrecover takes the signature parameters, and the only way to get them
35     // currently is to use assembly.
36     // solium-disable-next-line security/no-inline-assembly
37     assembly {
38       r := mload(add(signature, 0x20))
39       s := mload(add(signature, 0x40))
40       v := byte(0, mload(add(signature, 0x60)))
41     }
42 
43     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
44     if (v < 27) {
45       v += 27;
46     }
47 
48     // If the version is correct return the signer address
49     if (v != 27 && v != 28) {
50       return (address(0));
51     } else {
52       // solium-disable-next-line arg-overflow
53       return ecrecover(hash, v, r, s);
54     }
55   }
56 
57   /**
58    * toEthSignedMessageHash
59    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
60    * and hash the result
61    */
62   function toEthSignedMessageHash(bytes32 hash)
63     internal
64     pure
65     returns (bytes32)
66   {
67     // 32 is the length in bytes of hash,
68     // enforced by the type signature above
69     return keccak256(
70       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
71     );
72   }
73 }
74 
75 // File: contracts/Web3Provider.sol
76 
77 contract Web3Provider {
78     
79     using ECDSA for bytes32;
80     
81     uint256 constant public REQUEST_PRICE = 100 wei;
82     
83     uint256 public clientDeposit;
84     uint256 public chargedService;
85     address public clientAddress;
86     address public web3provider;
87     uint256 public timelock;
88     bool public charged;
89     
90     
91     constructor() public {
92         web3provider = msg.sender;
93     }
94     
95     function() external {}
96     
97     function subscribeForProvider()
98         external
99         payable
100     {
101         require(clientAddress == address(0));
102         require(msg.value % REQUEST_PRICE == 0);
103         
104         clientDeposit = msg.value;
105         clientAddress = msg.sender;
106         timelock = now + 1 days;
107     }
108     
109     function chargeService(uint256 _amountRequests, bytes _sig) 
110         external
111     {
112         require(charged == false);
113         require(now <= timelock);
114         require(msg.sender == web3provider);
115         
116         bytes32 hash = keccak256(abi.encodePacked(_amountRequests));
117         require(hash.recover(_sig) == clientAddress);
118         chargedService = _amountRequests*REQUEST_PRICE;
119         require(chargedService <= clientDeposit);
120         charged = true;
121         web3provider.transfer(chargedService);
122     }
123     
124     function withdrawDeposit()
125         external
126     {
127         require(msg.sender == clientAddress);
128         require(now > timelock);
129         clientAddress.transfer(address(this).balance);
130     }
131 }