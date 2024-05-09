1 /*
2   Zethr | https://zethr.io
3   (c) Copyright 2018 | All Rights Reserved
4   This smart contract was developed by the Zethr Dev Team and its source code remains property of the Zethr Project.
5 */
6 
7 pragma solidity ^0.4.24;
8 
9 // File: contracts/Libraries/SafeMath.sol
10 
11 library SafeMath {
12   function mul(uint a, uint b) internal pure returns (uint) {
13     if (a == 0) {
14       return 0;
15     }
16     uint c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint a, uint b) internal pure returns (uint) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint a, uint b) internal pure returns (uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal pure returns (uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 // File: contracts/Bankroll/ZethrSnap.sol
41 
42 contract ZethrInterface {
43   function transfer(address _from, uint _amount) public;
44 
45   function myFrontEndTokens() public view returns (uint);
46 }
47 
48 contract ZethrMultiSigWalletInterface {
49   mapping(address => bool) public isOwner;
50 }
51 
52 contract ZethrSnap {
53 
54   struct SnapEntry {
55     uint blockNumber;
56     uint profit;
57   }
58 
59   struct Sig {
60     bytes32 r;
61     bytes32 s;
62     uint8 v;
63   }
64 
65   // Reference to the Zethr multi sig wallet for authentication
66   ZethrMultiSigWalletInterface public multiSigWallet;
67 
68   // Reference to Zethr token contract
69   ZethrInterface zethr;
70 
71   // The server's public address (used to confirm valid claims)
72   address signer;
73 
74   // Mapping of user address => snap.id => claimStatus
75   mapping(address => mapping(uint => bool)) public claimedMap;
76 
77   // Array of all snaps
78   SnapEntry[] public snaps;
79 
80   // Used to pause the contract in an emergency
81   bool public paused;
82 
83   // The number of tokens in this contract allocated to snaps
84   uint public allocatedTokens;
85 
86   constructor(address _multiSigWalletAddress, address _zethrAddress, address _signer)
87   public
88   {
89     multiSigWallet = ZethrMultiSigWalletInterface(_multiSigWalletAddress);
90     zethr = ZethrInterface(_zethrAddress);
91     signer = _signer;
92     paused = false;
93   }
94 
95   /**
96    * @dev Needs to accept ETH dividends from Zethr token contract
97    */
98   function()
99   public payable
100   {}
101 
102   /**
103    * @dev Paused claims in an emergency
104    * @param _paused The new pause state
105    */
106   function ownerSetPaused(bool _paused)
107   public
108   ownerOnly
109   {
110     paused = _paused;
111   }
112 
113   /**
114    * @dev Updates the multi sig wallet reference
115    * @param _multiSigWalletAddress The new multi sig wallet address
116    */
117   function walletSetWallet(address _multiSigWalletAddress)
118   public
119   walletOnly
120   {
121     multiSigWallet = ZethrMultiSigWalletInterface(_multiSigWalletAddress);
122   }
123 
124   /**
125    * @dev Withdraws dividends to multi sig wallet
126    */
127   function withdraw()
128   public
129   {
130     (address(multiSigWallet)).transfer(address(this).balance);
131   }
132 
133   /**
134    * @dev Updates the signer address
135    */
136   function walletSetSigner(address _signer)
137   public walletOnly
138   {
139     signer = _signer;
140   }
141 
142   /**
143    * @dev Withdraws tokens (for migrating to a new contract)
144    */
145   function walletWithdrawTokens(uint _amount)
146   public walletOnly
147   {
148     zethr.transfer(address(multiSigWallet), _amount);
149   }
150 
151   /**
152    * @return Total number of snaps stored
153    */
154   function getSnapsLength()
155   public view
156   returns (uint)
157   {
158     return snaps.length;
159   }
160 
161   /**
162    * @dev Creates a new snap
163    * @param _blockNumber The block number the server should use to calculate ownership
164    * @param _profitToShare The amount of profit to divide between all holders
165    */
166   function walletCreateSnap(uint _blockNumber, uint _profitToShare)
167   public
168   walletOnly
169   {
170     uint index = snaps.length;
171     snaps.length++;
172 
173     snaps[index].blockNumber = _blockNumber;
174     snaps[index].profit = _profitToShare;
175 
176     // Make sure we have enough free tokens to create this snap
177     uint balance = zethr.myFrontEndTokens();
178     balance = balance - allocatedTokens;
179     require(balance >= _profitToShare);
180 
181     // Update allocation token count
182     allocatedTokens = allocatedTokens + _profitToShare;
183   }
184 
185   /**
186    * @dev Retrieves snap details
187    * @param _snapId The ID of the snap to get details of
188    */
189   function getSnap(uint _snapId)
190   public view
191   returns (uint blockNumber, uint profit, bool claimed)
192   {
193     SnapEntry storage entry = snaps[_snapId];
194     return (entry.blockNumber, entry.profit, claimedMap[msg.sender][_snapId]);
195   }
196 
197   /**
198    * @dev Process a claim
199    * @param _snapId ID of the snap this claim is for
200    * @param _payTo Address to send the proceeds to
201    * @param _amount The amount of profit claiming
202    * @param _signatureBytes Signature of the server approving this claim
203    */
204   function claim(uint _snapId, address _payTo, uint _amount, bytes _signatureBytes)
205   public
206   {
207     // Check pause state
208     require(!paused);
209 
210     // Prevent multiple calls
211     require(claimedMap[msg.sender][_snapId] == false);
212     claimedMap[msg.sender][_snapId] = true;
213 
214     // Confirm that the server has approved this claim
215     // Note: the player cannot modify the _amount arbitrarily because it will invalidate the signature
216     Sig memory sig = toSig(_signatureBytes);
217     bytes32 hash = keccak256(abi.encodePacked("SNAP", _snapId, msg.sender, _amount));
218     address recoveredSigner = ecrecover(hash, sig.v, sig.r, sig.s);
219     require(signer == recoveredSigner);
220 
221     // Reduce allocated tokens by claim amount
222     require(_amount <= allocatedTokens);
223     allocatedTokens = allocatedTokens - _amount;
224 
225     // Send tokens
226     zethr.transfer(_payTo, _amount);
227   }
228 
229   /**
230    * @dev The contract accepts ZTH tokens in order to pay out claims
231    */
232   function tokenFallback(address /*_from*/, uint /*_amountOfTokens*/, bytes /*_data*/)
233   public view
234   returns (bool)
235   {
236     require(msg.sender == address(zethr), "Tokens must be ZTH");
237     return true;
238   }
239 
240   /**
241    * @dev Extract a Sig struct from given bytes
242    */
243   function toSig(bytes b)
244   internal pure
245   returns (Sig memory sig)
246   {
247     sig.r = bytes32(toUint(b, 0));
248     sig.s = bytes32(toUint(b, 32));
249     sig.v = uint8(b[64]);
250   }
251 
252   /**
253    * @dev Extracts a uint from bytes
254    */
255   function toUint(bytes _bytes, uint _start)
256   internal pure
257   returns (uint256)
258   {
259     require(_bytes.length >= (_start + 32));
260     uint256 tempUint;
261 
262     assembly {
263       tempUint := mload(add(add(_bytes, 0x20), _start))
264     }
265 
266     return tempUint;
267   }
268 
269   // Only the multi sig wallet can call this method
270   modifier walletOnly()
271   {
272     require(msg.sender == address(multiSigWallet));
273     _;
274   }
275 
276   // Only an owner can call this method (multi sig is always an owner)
277   modifier ownerOnly()
278   {
279     require(msg.sender == address(multiSigWallet) || multiSigWallet.isOwner(msg.sender));
280     _;
281   }
282 }