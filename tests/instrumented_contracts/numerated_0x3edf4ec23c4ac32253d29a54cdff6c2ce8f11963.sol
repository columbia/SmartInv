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
17 // Notice that NFT (ERC721/ERC1155) is not supported. But can be transferred out throught spendAny.
18 // Last update time: 2020-12-21.
19 // copyright @ ownbit.io
20 //
21 // Accident Protection MultiSig, rules:
22 //
23 // Participants must keep themselves active by submitting transactions. 
24 // Not submitting any transaction within 3,000,000 ETH blocks (roughly 416 days) will be treated as wallet lost (i.e. accident happened), 
25 // other participants can still spend the assets as along as: valid signing count >= Min(mininual required count, active owners).
26 //
27 
28 interface Erc20 {
29   function approve(address, uint256) public;
30 
31   function transfer(address, uint256) public;
32     
33   //function balanceOf(address) view public returns (uint256);
34 }
35 
36 contract OwnbitMultiSig {
37     
38   uint constant public MAX_OWNER_COUNT = 9;
39   //uint constant public MAX_INACTIVE_BLOCKNUMBER = 300; //300 ETH blocks, roughly 1 hour, for testing.
40   uint constant public MAX_INACTIVE_BLOCKNUMBER = 3000000; //3,000,000 ETH blocks, roughly 416 days.
41 
42   // The N addresses which control the funds in this contract. The
43   // owners of M of these addresses will need to both sign a message
44   // allowing the funds in this contract to be spent.
45   mapping(address => uint256) private ownerBlockMap; //uint256 is the active blockNumber of this owner
46   address[] private owners;
47   uint private required;
48 
49   // The contract nonce is not accessible to the contract so we
50   // implement a nonce-like variable for replay protection.
51   uint256 private spendNonce = 0;
52   
53   // An event sent when funds are received.
54   event Funded(address from, uint value);
55   
56   // An event sent when a spend is triggered to the given address.
57   event Spent(address to, uint transfer);
58   
59   // An event sent when a spendERC20 is triggered to the given address.
60   event SpentERC20(address erc20contract, address to, uint transfer);
61   
62   // An event sent when an spendAny is executed.
63   event SpentAny(address to, uint transfer);
64 
65   modifier validRequirement(uint ownerCount, uint _required) {
66     require (ownerCount <= MAX_OWNER_COUNT
67             && _required <= ownerCount
68             && _required >= 1);
69     _;
70   }
71   
72   /// @dev Contract constructor sets initial owners and required number of confirmations.
73   /// @param _owners List of initial owners.
74   /// @param _required Number of required confirmations.
75   constructor(address[] _owners, uint _required) public validRequirement(_owners.length, _required) {
76     for (uint i = 0; i < _owners.length; i++) {
77         //onwer should be distinct, and non-zero
78         if (ownerBlockMap[_owners[i]] > 0 || _owners[i] == address(0x0)) {
79             revert();
80         }
81         ownerBlockMap[_owners[i]] = block.number;
82     }
83     owners = _owners;
84     required = _required;
85   }
86 
87 
88   // The fallback function for this contract.
89   function() public payable {
90     if (msg.value > 0) {
91         emit Funded(msg.sender, msg.value);
92     }
93   }
94   
95   // @dev Returns list of owners.
96   // @return List of owner addresses.
97   function getOwners() public view returns (address[]) {
98     return owners;
99   }
100     
101   function getSpendNonce() public view returns (uint256) {
102     return spendNonce;
103   }
104     
105   function getRequired() public view returns (uint) {
106     return required;
107   }
108   
109   //return the active block number of this owner
110   function getOwnerBlock(address addr) public view returns (uint) {
111     return ownerBlockMap[addr];
112   }
113 
114   // Generates the message to sign given the output destination address and amount.
115   // includes this contract's address and a nonce for replay protection.
116   // One option to independently verify: https://leventozturk.com/engineering/sha3/ and select keccak
117   function generateMessageToSign(address erc20Contract, address destination, uint256 value) private view returns (bytes32) {
118     //the sequence should match generateMultiSigV2 in JS
119     bytes32 message = keccak256(abi.encodePacked(address(this), erc20Contract, destination, value, spendNonce));
120     return message;
121   }
122   
123   function _messageToRecover(address erc20Contract, address destination, uint256 value) private view returns (bytes32) {
124     bytes32 hashedUnsignedMessage = generateMessageToSign(erc20Contract, destination, value);
125     bytes memory prefix = "\x19Ethereum Signed Message:\n32";
126     return keccak256(abi.encodePacked(prefix, hashedUnsignedMessage));
127   }
128   
129   // @destination: the ether receiver address.
130   // @value: the ether value, in wei.
131   // @vs, rs, ss: the signatures
132   function spend(address destination, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss) external {
133     require(destination != address(this), "Not allow sending to yourself");
134     require(address(this).balance >= value && value > 0, "balance or spend value invalid");
135     require(_validSignature(address(0x0), destination, value, vs, rs, ss), "invalid signatures");
136     spendNonce = spendNonce + 1;
137     //transfer will throw if fails
138     destination.transfer(value);
139     emit Spent(destination, value);
140   }
141   
142   // @erc20contract: the erc20 contract address.
143   // @destination: the token receiver address.
144   // @value: the token value, in token minimum unit.
145   // @vs, rs, ss: the signatures
146   function spendERC20(address destination, address erc20contract, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss) external {
147     require(destination != address(this), "Not allow sending to yourself");
148     //transfer erc20 token
149     //uint256 tokenValue = Erc20(erc20contract).balanceOf(address(this));
150     require(value > 0, "Erc20 spend value invalid");
151     require(_validSignature(erc20contract, destination, value, vs, rs, ss), "invalid signatures");
152     spendNonce = spendNonce + 1;
153     // transfer tokens from this contract to the destination address
154     Erc20(erc20contract).transfer(destination, value);
155     emit SpentERC20(erc20contract, destination, value);
156   }
157   
158   //0x9 is used for spendAny
159   //be careful with any action, data is not included into signature computation. So any data can be included in spendAny.
160   //This is usually for some emergent recovery, for example, recovery of NTFs, etc.
161   //Owners should not generate 0x9 based signatures in normal cases.
162   function spendAny(address destination, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss, bytes data) external {
163     require(destination != address(this), "Not allow sending to yourself");
164     require(_validSignature(address(0x9), destination, value, vs, rs, ss), "invalid signatures");
165     spendNonce = spendNonce + 1;
166     //transfer tokens from this contract to the destination address
167     if (destination.call.value(value)(data)) {
168         emit SpentAny(destination, value);
169     }
170   }
171   
172   //send a tx from the owner address to active the owner
173   //Allow the owner to transfer some ETH, although this is not necessary.
174   function active() external payable {
175     require(ownerBlockMap[msg.sender] > 0, "Not an owner");
176     ownerBlockMap[msg.sender] = block.number;
177   }
178   
179   function getRequiredWithoutInactive() public view returns (uint) {
180     uint activeOwner = 0;  
181     for (uint i = 0; i < owners.length; i++) {
182         //if the owner is active
183         if (ownerBlockMap[owners[i]] + MAX_INACTIVE_BLOCKNUMBER >= block.number) {
184             activeOwner++;
185         }
186     }
187     //active owners still equal or greater then required
188     if (activeOwner >= required) {
189         return required;
190     }
191     //active less than required, all active must sign
192     if (activeOwner >= 1) {
193         return activeOwner;
194     }
195     //at least needs one signature.
196     return 1;
197   }
198 
199   // Confirm that the signature triplets (v1, r1, s1) (v2, r2, s2) ...
200   // authorize a spend of this contract's funds to the given destination address.
201   function _validSignature(address erc20Contract, address destination, uint256 value, uint8[] vs, bytes32[] rs, bytes32[] ss) private returns (bool) {
202     require(vs.length == rs.length);
203     require(rs.length == ss.length);
204     require(vs.length <= owners.length);
205     require(vs.length >= getRequiredWithoutInactive());
206     bytes32 message = _messageToRecover(erc20Contract, destination, value);
207     address[] memory addrs = new address[](vs.length);
208     for (uint i = 0; i < vs.length; i++) {
209         //recover the address associated with the public key from elliptic curve signature or return zero on error 
210         addrs[i] = ecrecover(message, vs[i]+27, rs[i], ss[i]);
211     }
212     require(_distinctOwners(addrs));
213     _updateActiveBlockNumber(addrs); //update addrs' active block number
214     
215     //check again, this is important to prevent inactive owners from stealing the money.
216     require(vs.length >= getRequiredWithoutInactive(), "Active owners updated after the call, please call active() before calling spend.");
217     
218     return true;
219   }
220   
221   // Confirm the addresses as distinct owners of this contract.
222   function _distinctOwners(address[] addrs) private view returns (bool) {
223     if (addrs.length > owners.length) {
224         return false;
225     }
226     for (uint i = 0; i < addrs.length; i++) {
227         //> 0 means one of the owner
228         if (ownerBlockMap[addrs[i]] == 0) {
229             return false;
230         }
231         //address should be distinct
232         for (uint j = 0; j < i; j++) {
233             if (addrs[i] == addrs[j]) {
234                 return false;
235             }
236         }
237     }
238     return true;
239   }
240   
241   //update the active block number for those owners
242   function _updateActiveBlockNumber(address[] addrs) private {
243     for (uint i = 0; i < addrs.length; i++) {
244         //only update block number for owners
245         if (ownerBlockMap[addrs[i]] > 0) {
246             ownerBlockMap[addrs[i]] = block.number;
247         }
248     }
249   }
250   
251 }