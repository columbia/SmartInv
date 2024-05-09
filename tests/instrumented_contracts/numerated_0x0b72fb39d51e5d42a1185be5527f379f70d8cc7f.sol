1 pragma solidity ^0.4.26;
2 
3 // This is the ETH/ERC20 multisig contract for Ownbit.
4 //
5 // For 2-of-3 multisig, to authorize a spend, two signtures must be provided by 2 of the 3 owners.
6 // To generate the message to be signed, provide the destination address and
7 // spend amount (in wei) to the generateMessageToSign method.
8 // The signatures must be provided as the (v, r, s) hex-encoded coordinates.
9 // The S coordinate must be 0x00 or 0x01 corresponding to 0x1b and 0x1c, respectively.
10 //
11 // WARNING: The generated message is only valid until the next spend is executed.
12 //          after that, a new message will need to be calculated.
13 //
14 //
15 // INFO: This contract is ERC20 compatible.
16 // This contract can both receive ETH and ERC20 tokens.
17 // Notice that NFT (ERC721/ERC1155) is not supported.
18 
19 interface Erc20 {
20   function approve(address, uint256) public;
21 
22   function transfer(address, uint256) public;
23     
24   //function balanceOf(address) view public returns (uint256);
25 }
26 
27 contract OwnbitMultiSig {
28     
29   uint constant public MAX_OWNER_COUNT = 9;
30 
31   // The N addresses which control the funds in this contract. The
32   // owners of M of these addresses will need to both sign a message
33   // allowing the funds in this contract to be spent.
34   mapping(address => bool) private isOwner;
35   address[] private owners;
36   uint private required;
37 
38   // The contract nonce is not accessible to the contract so we
39   // implement a nonce-like variable for replay protection.
40   uint256 private spendNonce = 0;
41   
42   // An event sent when funds are received.
43   event Funded(address from, uint value);
44   
45   // An event sent when a spend is triggered to the given address.
46   event Spent(address to, uint transfer);
47   
48   // An event sent when a spendERC20 is triggered to the given address.
49   event SpentERC20(address erc20contract, address to, uint transfer);
50   
51   // An event sent when an spendAny is executed.
52   event SpentAny(address to, uint transfer);
53 
54   modifier validRequirement(uint ownerCount, uint _required) {
55     require (ownerCount <= MAX_OWNER_COUNT
56             && _required <= ownerCount
57             && _required >= 1);
58     _;
59   }
60   
61   /// @dev Contract constructor sets initial owners and required number of confirmations.
62   /// @param _owners List of initial owners.
63   /// @param _required Number of required confirmations.
64   constructor(address[] _owners, uint _required) public validRequirement(_owners.length, _required) {
65     for (uint i = 0; i < _owners.length; i++) {
66         //onwer should be distinct, and non-zero
67         if (isOwner[_owners[i]] || _owners[i] == address(0x0)) {
68             revert();
69         }
70         isOwner[_owners[i]] = true;
71     }
72     owners = _owners;
73     required = _required;
74   }
75 
76 
77   // The fallback function for this contract.
78   function() public payable {
79     if (msg.value > 0) {
80         emit Funded(msg.sender, msg.value);
81     }
82   }
83   
84   // @dev Returns list of owners.
85   // @return List of owner addresses.
86   function getOwners() public view returns (address[]) {
87     return owners;
88   }
89     
90   function getSpendNonce() public view returns (uint256) {
91     return spendNonce;
92   }
93     
94   function getRequired() public view returns (uint) {
95     return required;
96   }
97 
98   // Generates the message to sign given the output destination address and amount.
99   // includes this contract's address and a nonce for replay protection.
100   // One option to independently verify: https://leventozturk.com/engineering/sha3/ and select keccak
101   function generateMessageToSign(address erc20Contract, address destination, uint256 value) private view returns (bytes32) {
102     //the sequence should match generateMultiSigV2 in JS
103     bytes32 message = keccak256(abi.encodePacked(address(this), erc20Contract, destination, value, spendNonce));
104     return message;
105   }
106   
107   function _messageToRecover(address erc20Contract, address destination, uint256 value) private view returns (bytes32) {
108     bytes32 hashedUnsignedMessage = generateMessageToSign(erc20Contract, destination, value);
109     bytes memory prefix = "\x19Ethereum Signed Message:\n32";
110     return keccak256(abi.encodePacked(prefix, hashedUnsignedMessage));
111   }
112   
113   // @destination: the ether receiver address.
114   // @value: the ether value, in wei.
115   // @vs, rs, ss: the signatures
116   function spend(address destination, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss) external {
117     require(destination != address(this), "Not allow sending to yourself");
118     require(address(this).balance >= value && value > 0, "balance or spend value invalid");
119     require(_validSignature(address(0x0), destination, value, vs, rs, ss), "invalid signatures");
120     spendNonce = spendNonce + 1;
121     //transfer will throw if fails
122     destination.transfer(value);
123     emit Spent(destination, value);
124   }
125   
126   // @erc20contract: the erc20 contract address.
127   // @destination: the token receiver address.
128   // @value: the token value, in token minimum unit.
129   // @vs, rs, ss: the signatures
130   function spendERC20(address destination, address erc20contract, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss) external {
131     require(destination != address(this), "Not allow sending to yourself");
132     //transfer erc20 token
133     //uint256 tokenValue = Erc20(erc20contract).balanceOf(address(this));
134     require(value > 0, "Erc20 spend value invalid");
135     require(_validSignature(erc20contract, destination, value, vs, rs, ss), "invalid signatures");
136     spendNonce = spendNonce + 1;
137     // transfer tokens from this contract to the destination address
138     Erc20(erc20contract).transfer(destination, value);
139     emit SpentERC20(erc20contract, destination, value);
140   }
141   
142   //0x9 is used for spendAny
143   //be careful with any action, data is not included into signature computation. So any data can be included in spendAny.
144   //This is usually for some emergent recovery, for example, recovery of NTFs, etc.
145   //Owners should not generate 0x9 based signatures in normal cases.
146   function spendAny(address destination, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss, bytes data) external {
147     require(destination != address(this), "Not allow sending to yourself");
148     require(_validSignature(address(0x9), destination, value, vs, rs, ss), "invalid signatures");
149     spendNonce = spendNonce + 1;
150     //transfer tokens from this contract to the destination address
151     if (destination.call.value(value)(data)) {
152         emit SpentAny(destination, value);
153     }
154   }
155 
156   // Confirm that the signature triplets (v1, r1, s1) (v2, r2, s2) ...
157   // authorize a spend of this contract's funds to the given destination address.
158   function _validSignature(address erc20Contract, address destination, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss) private view returns (bool) {
159     require(vs.length == rs.length);
160     require(rs.length == ss.length);
161     require(vs.length <= owners.length);
162     require(vs.length >= required);
163     bytes32 message = _messageToRecover(erc20Contract, destination, value);
164     address[] memory addrs = new address[](vs.length);
165     for (uint i = 0; i < vs.length; i++) {
166         //recover the address associated with the public key from elliptic curve signature or return zero on error 
167         addrs[i] = ecrecover(message, vs[i]+27, rs[i], ss[i]);
168     }
169     require(_distinctOwners(addrs));
170     return true;
171   }
172   
173   // Confirm the addresses as distinct owners of this contract.
174   function _distinctOwners(address[] addrs) private view returns (bool) {
175     if (addrs.length > owners.length) {
176         return false;
177     }
178     for (uint i = 0; i < addrs.length; i++) {
179         if (!isOwner[addrs[i]]) {
180             return false;
181         }
182         //address should be distinct
183         for (uint j = 0; j < i; j++) {
184             if (addrs[i] == addrs[j]) {
185                 return false;
186             }
187         }
188     }
189     return true;
190   }
191   
192 }