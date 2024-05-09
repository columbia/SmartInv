1 pragma solidity ^0.4.21;
2 
3 // This is the ETH/ERC20 multisig contract for Ownbit.
4 //
5 // For 2-of-3 multisig, to authorize a spend, two signtures must be provided by 2 of the 3 owners.
6 // To generate the message to be signed, provide the destination address and
7 // spend amount (in wei) to the generateMessageToSignmethod.
8 // The signatures must be provided as the (v, r, s) hex-encoded coordinates.
9 // The S coordinate must be 0x00 or 0x01 corresponding to 0x1b and 0x1c, respectively.
10 // See the test file for example inputs.
11 //
12 // WARNING: The generated message is only valid until the next spend is executed.
13 //          after that, a new message will need to be calculated.
14 //
15 //
16 // INFO: This contract is ERC20 compatible.
17 // This contract can both receive ETH and ERC20 tokens.
18 // NFT is not supported
19 // Add support for DeFi (Compound)
20 
21 interface Erc20 {
22     function approve(address, uint256);
23 
24     function transfer(address, uint256);
25 }
26 
27 interface CErc20 {
28     function mint(uint256) external returns (uint256);
29 
30     function redeem(uint) external returns (uint);
31 
32     function redeemUnderlying(uint) external returns (uint);
33 }
34 
35 interface CEth {
36     function mint() external payable;
37 
38     function redeem(uint) external returns (uint);
39 
40     function redeemUnderlying(uint) external returns (uint);
41 }
42 
43 contract OwnbitMultiSig {
44     
45     uint constant public MAX_OWNER_COUNT = 9;
46 
47   // The N addresses which control the funds in this contract.  The
48   // owners of M of these addresses will need to both sign a message
49   // allowing the funds in this contract to be spent.
50   mapping(address => bool) private isOwner;
51   address[] private owners;
52   uint private required;
53 
54   // The contract nonce is not accessible to the contract so we
55   // implement a nonce-like variable for replay protection.
56   uint256 private spendNonce = 0;
57   
58   // An event sent when funds are received.
59   event Funded(uint new_balance);
60   
61   // An event sent when a spend is triggered to the given address.
62   event Spent(address to, uint transfer);
63   
64   // An event sent when a spend is triggered to the given address.
65   event SpentErc20(address erc20contract, address to, uint transfer);
66 
67   modifier validRequirement(uint ownerCount, uint _required) {
68         require (ownerCount <= MAX_OWNER_COUNT
69             && _required <= ownerCount
70             && _required > 0);
71         _;
72     }
73   
74     /// @dev Contract constructor sets initial owners and required number of confirmations.
75     /// @param _owners List of initial owners.
76     /// @param _required Number of required confirmations.
77     constructor(address[] _owners, uint _required) public validRequirement(_owners.length, _required) {
78         for (uint i=0; i<_owners.length; i++) {
79             //onwer should be distinct, and non-zero
80             if (isOwner[_owners[i]] || _owners[i] == 0) {
81                 revert();
82             }
83             isOwner[_owners[i]] = true;
84         }
85         owners = _owners;
86         required = _required;
87     }
88 
89 
90     // The fallback function for this contract.
91     function() public payable {
92         emit Funded(address(this).balance);
93     }
94   
95     /// @dev Returns list of owners.
96     /// @return List of owner addresses.
97     function getOwners() public constant returns (address[]) {
98         return owners;
99     }
100     
101     function getSpendNonce() public constant returns (uint256) {
102         return spendNonce;
103     }
104     
105     function getRequired() public constant returns (uint) {
106         return required;
107     }
108 
109   // Generates the message to sign given the output destination address and amount.
110   // includes this contract's address and a nonce for replay protection.
111   // One option to  independently verify: https://leventozturk.com/engineering/sha3/ and select keccak
112   function generateMessageToSign(address erc20Contract, address destination, uint256 value) public constant returns (bytes32) {
113     require(destination != address(this));
114     //the sequence should match generateMultiSigV2 in JS
115     bytes32 message = keccak256(this, erc20Contract, destination, value, spendNonce);
116     return message;
117   }
118   
119   function _messageToRecover(address erc20Contract, address destination, uint256 value) private constant returns (bytes32) {
120     bytes32 hashedUnsignedMessage = generateMessageToSign(erc20Contract, destination, value);
121     bytes memory prefix = "\x19Ethereum Signed Message:\n32";
122     return keccak256(prefix,hashedUnsignedMessage);
123   }
124   
125   function spend(address destination, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss) public {
126     // This require is handled by generateMessageToSign()
127     // require(destination != address(this));
128     require(address(this).balance >= value);
129     require(_validSignature(0x0000000000000000000000000000000000000000, destination, value, vs, rs, ss));
130     spendNonce = spendNonce + 1;
131     //transfer will throw if fails
132     destination.transfer(value);
133     emit Spent(destination, value);
134   }
135   
136   // @erc20contract: the erc20 contract address.
137   // @destination: the token or ether receiver address.
138   // @value: the token or ether value, in wei or token minimum unit.
139   // @vs, rs, ss: the signatures
140   function spendERC20(address destination, address erc20contract, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss) public {
141     // This require is handled by generateMessageToSign()
142     // require(destination != address(this));
143     //transfer erc20 token
144     //require(ERC20Interface(erc20contract).balanceOf(address(this)) >= value);
145     require(_validSignature(erc20contract, destination, value, vs, rs, ss));
146     spendNonce = spendNonce + 1;
147     // transfer the tokens from the sender to this contract
148     Erc20(erc20contract).transfer(destination, value);
149     emit SpentErc20(erc20contract, destination, value);
150   }
151 
152 
153     //cErc20Contract is just like the destination
154     function compoundAction(address cErc20Contract, address erc20contract, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss) public {
155         CEth ethToken;
156         CErc20 erc20Token;
157         
158         if (erc20contract == 0x0000000000000000000000000000000000000001) {
159             require(_validSignature(erc20contract, cErc20Contract, value, vs, rs, ss));
160             spendNonce = spendNonce + 1;
161             
162             //supply ETH
163             ethToken = CEth(cErc20Contract);
164             ethToken.mint.value(value).gas(250000)();
165         } else if (erc20contract == 0x0000000000000000000000000000000000000003) {
166             require(_validSignature(erc20contract, cErc20Contract, value, vs, rs, ss));
167             spendNonce = spendNonce + 1;
168             
169             //redeem ETH
170             ethToken = CEth(cErc20Contract);
171             ethToken.redeem(value);
172         } else if (erc20contract == 0x0000000000000000000000000000000000000004) {
173             require(_validSignature(erc20contract, cErc20Contract, value, vs, rs, ss));
174             spendNonce = spendNonce + 1;
175             
176             //redeem token
177             erc20Token = CErc20(cErc20Contract);
178             erc20Token.redeem(value);
179         } else if (erc20contract == 0x0000000000000000000000000000000000000005) {
180             require(_validSignature(erc20contract, cErc20Contract, value, vs, rs, ss));
181             spendNonce = spendNonce + 1;
182             
183             //redeemUnderlying ETH
184             ethToken = CEth(cErc20Contract);
185             ethToken.redeemUnderlying(value);
186         } else if (erc20contract == 0x0000000000000000000000000000000000000006) {
187             require(_validSignature(erc20contract, cErc20Contract, value, vs, rs, ss));
188             spendNonce = spendNonce + 1;
189             
190             //redeemUnderlying token
191             erc20Token = CErc20(cErc20Contract);
192             erc20Token.redeemUnderlying(value);
193         } else {
194             //Do not conflict with spendERC20
195             require(_validSignature(0x0000000000000000000000000000000000000002, cErc20Contract, value, vs, rs, ss));
196             spendNonce = spendNonce + 1;
197             
198             //supply token
199             // Create a reference to the underlying asset contract, like DAI.
200             Erc20 underlying = Erc20(erc20contract);
201             // Create a reference to the corresponding cToken contract, like cDAI
202             erc20Token = CErc20(cErc20Contract);
203             // Approve transfer on the ERC20 contract
204             underlying.approve(cErc20Contract, value);
205             // Mint cTokens
206             erc20Token.mint(value);
207         } 
208     }
209     
210 
211   // Confirm that the signature triplets (v1, r1, s1) (v2, r2, s2) ...
212   // authorize a spend of this contract's funds to the given
213   // destination address.
214   function _validSignature(address erc20Contract, address destination, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss) private constant returns (bool) {
215     require(vs.length == rs.length);
216     require(rs.length == ss.length);
217     require(vs.length <= owners.length);
218     require(vs.length >= required);
219     bytes32 message = _messageToRecover(erc20Contract, destination, value);
220     address[] memory addrs = new address[](vs.length);
221     for (uint i=0; i<vs.length; i++) {
222         //recover the address associated with the public key from elliptic curve signature or return zero on error 
223         addrs[i] = ecrecover(message, vs[i]+27, rs[i], ss[i]);
224     }
225     require(_distinctOwners(addrs));
226     return true;
227   }
228   
229   // Confirm the addresses as distinct owners of this contract.
230   function _distinctOwners(address[] addrs) private constant returns (bool) {
231     if (addrs.length > owners.length) {
232         return false;
233     }
234     for (uint i = 0; i < addrs.length; i++) {
235         if (!isOwner[addrs[i]]) {
236             return false;
237         }
238         //address should be distinct
239         for (uint j = 0; j < i; j++) {
240             if (addrs[i] == addrs[j]) {
241                 return false;
242             }
243         }
244     }
245     return true;
246   }
247 }