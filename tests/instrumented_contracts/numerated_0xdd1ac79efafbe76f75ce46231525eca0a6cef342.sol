1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
35    */
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     if (newOwner != address(0)) {
54       owner = newOwner;
55     }
56   }
57 
58 }
59 
60 contract Pausable is Ownable {
61   event Pause();
62   event Unpause();
63 
64   bool public paused = false;
65 
66   function Pausable() public {}
67 
68   /**
69    * @dev modifier to allow actions only when the contract IS paused
70    */
71   modifier whenNotPaused() {
72     require(!paused);
73     _;
74   }
75 
76   /**
77    * @dev modifier to allow actions only when the contract IS NOT paused
78    */
79   modifier whenPaused {
80     require(paused);
81     _;
82   }
83 
84   /**
85    * @dev called by the owner to pause, triggers stopped state
86    */
87   function pause() public onlyOwner whenNotPaused returns (bool) {
88     paused = true;
89     Pause();
90     return true;
91   }
92 
93   /**
94    * @dev called by the owner to unpause, returns to normal state
95    */
96   function unpause() public onlyOwner whenPaused returns (bool) {
97     paused = false;
98     Unpause();
99     return true;
100   }
101 }
102 
103 contract TokenSale is Pausable {
104 
105   using SafeMath for uint256;
106 
107   ProofTokenInterface public proofToken;
108   uint256 public totalWeiRaised;
109   uint256 public tokensMinted;
110   uint256 public totalSupply;
111   uint256 public contributors;
112   uint256 public decimalsMultiplier;
113   uint256 public startTime;
114   uint256 public endTime;
115   uint256 public remainingTokens;
116   uint256 public allocatedTokens;
117 
118   bool public finalized;
119   bool public proofTokensAllocated;
120   address public proofMultiSig = 0x99892Ac6DA1b3851167Cb959fE945926bca89f09;
121 
122   uint256 public constant BASE_PRICE_IN_WEI = 88000000000000000;
123   uint256 public constant PUBLIC_TOKENS = 1181031 * (10 ** 18);
124   uint256 public constant TOTAL_PRESALE_TOKENS = 112386712924725508802400;
125   uint256 public constant TOKENS_ALLOCATED_TO_PROOF = 1181031 * (10 ** 18);
126 
127 
128 
129   uint256 public tokenCap = PUBLIC_TOKENS - TOTAL_PRESALE_TOKENS;
130   uint256 public cap = tokenCap / (10 ** 18);
131   uint256 public weiCap = cap * BASE_PRICE_IN_WEI;
132 
133   uint256 public firstDiscountPrice = (BASE_PRICE_IN_WEI * 85) / 100;
134   uint256 public secondDiscountPrice = (BASE_PRICE_IN_WEI * 90) / 100;
135   uint256 public thirdDiscountPrice = (BASE_PRICE_IN_WEI * 95) / 100;
136 
137   uint256 public firstDiscountCap = (weiCap * 5) / 100;
138   uint256 public secondDiscountCap = (weiCap * 10) / 100;
139   uint256 public thirdDiscountCap = (weiCap * 20) / 100;
140 
141   bool public started = false;
142 
143   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
144   event NewClonedToken(address indexed _cloneToken);
145   event OnTransfer(address _from, address _to, uint _amount);
146   event OnApprove(address _owner, address _spender, uint _amount);
147   event LogInt(string _name, uint256 _value);
148   event Finalized();
149 
150   function TokenSale(address _tokenAddress, uint256 _startTime, uint256 _endTime) public {
151     require(_tokenAddress != 0x0);
152     require(_startTime > 0);
153     require(_endTime > _startTime);
154 
155     startTime = _startTime;
156     endTime = _endTime;
157     proofToken = ProofTokenInterface(_tokenAddress);
158 
159     decimalsMultiplier = (10 ** 18);
160   }
161 
162 
163   /**
164    * High level token purchase function
165    */
166   function() public payable {
167     buyTokens(msg.sender);
168   }
169 
170   /**
171    * Low level token purchase function
172    * @param _beneficiary will receive the tokens.
173    */
174   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
175     require(_beneficiary != 0x0);
176     require(validPurchase());
177 
178     uint256 weiAmount = msg.value;
179     uint256 priceInWei = getPriceInWei();
180     totalWeiRaised = totalWeiRaised.add(weiAmount);
181 
182     uint256 tokens = weiAmount.mul(decimalsMultiplier).div(priceInWei);
183     tokensMinted = tokensMinted.add(tokens);
184     require(tokensMinted < tokenCap);
185 
186     contributors = contributors.add(1);
187 
188     proofToken.mint(_beneficiary, tokens);
189     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
190     forwardFunds();
191   }
192 
193 
194   /**
195    * Get the price in wei for current premium
196    * @return price {uint256}
197    */
198   function getPriceInWei() constant public returns (uint256) {
199 
200     uint256 price;
201 
202     if (totalWeiRaised < firstDiscountCap) {
203       price = firstDiscountPrice;
204     } else if (totalWeiRaised < secondDiscountCap) {
205       price = secondDiscountPrice;
206     } else if (totalWeiRaised < thirdDiscountCap) {
207       price = thirdDiscountPrice;
208     } else {
209       price = BASE_PRICE_IN_WEI;
210     }
211 
212     return price;
213   }
214 
215   /**
216   * Forwards funds to the tokensale wallet
217   */
218   function forwardFunds() internal {
219     proofMultiSig.transfer(msg.value);
220   }
221 
222 
223   /**
224   * Validates the purchase (period, minimum amount, within cap)
225   * @return {bool} valid
226   */
227   function validPurchase() internal constant returns (bool) {
228     uint256 current = now;
229     bool presaleStarted = (current >= startTime || started);
230     bool presaleNotEnded = current <= endTime;
231     bool nonZeroPurchase = msg.value != 0;
232     return nonZeroPurchase && presaleStarted && presaleNotEnded;
233   }
234 
235   /**
236   * Returns the total Proof token supply
237   * @return totalSupply {uint256} Proof Token Total Supply
238   */
239   function totalSupply() public constant returns (uint256) {
240     return proofToken.totalSupply();
241   }
242 
243   /**
244   * Returns token holder Proof Token balance
245   * @param _owner {address} Token holder address
246   * @return balance {uint256} Corresponding token holder balance
247   */
248   function balanceOf(address _owner) public constant returns (uint256) {
249     return proofToken.balanceOf(_owner);
250   }
251 
252   /**
253   * Change the Proof Token controller
254   * @param _newController {address} New Proof Token controller
255   */
256   function changeController(address _newController) public {
257     proofToken.transferControl(_newController);
258   }
259 
260 
261   function enableTransfers() public {
262     if (now < endTime) {
263       require(msg.sender == owner);
264     }
265     proofToken.enableTransfers(true);
266   }
267 
268   function lockTransfers() public onlyOwner {
269     require(now < endTime);
270     proofToken.enableTransfers(false);
271   }
272 
273   function enableMasterTransfers() public onlyOwner {
274     proofToken.enableMasterTransfers(true);
275   }
276 
277   function lockMasterTransfers() public onlyOwner {
278     proofToken.enableMasterTransfers(false);
279   }
280 
281   function forceStart() public onlyOwner {
282     started = true;
283   }
284 
285   function allocateProofTokens() public onlyOwner whenNotFinalized {
286     require(!proofTokensAllocated);
287     proofToken.mint(proofMultiSig, TOKENS_ALLOCATED_TO_PROOF);
288     proofTokensAllocated = true;
289   }
290 
291   function finalize() public onlyOwner {
292     require(paused);
293     require(proofTokensAllocated);
294 
295     proofToken.finishMinting();
296     proofToken.enableTransfers(true);
297     Finalized();
298 
299     finalized = true;
300   }
301 
302 
303   function isContract(address _addr) constant internal returns(bool) {
304     uint size;
305     if (_addr == 0)
306       return false;
307     assembly {
308         size := extcodesize(_addr)
309     }
310     return size>0;
311   }
312 
313   modifier whenNotFinalized() {
314     require(!finalized);
315     _;
316   }
317 
318 }
319 
320 contract Controllable {
321   address public controller;
322 
323 
324   /**
325    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
326    */
327   function Controllable() public {
328     controller = msg.sender;
329   }
330 
331   /**
332    * @dev Throws if called by any account other than the owner.
333    */
334   modifier onlyController() {
335     require(msg.sender == controller);
336     _;
337   }
338 
339   /**
340    * @dev Allows the current owner to transfer control of the contract to a newOwner.
341    * @param newController The address to transfer ownership to.
342    */
343   function transferControl(address newController) public onlyController {
344     if (newController != address(0)) {
345       controller = newController;
346     }
347   }
348 
349 }
350 
351 contract ProofTokenInterface is Controllable {
352 
353   event Mint(address indexed to, uint256 amount);
354   event MintFinished();
355   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
356   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
357   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
358   event Transfer(address indexed from, address indexed to, uint256 value);
359 
360   function totalSupply() public constant returns (uint);
361   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
362   function balanceOf(address _owner) public constant returns (uint256 balance);
363   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
364   function transfer(address _to, uint256 _amount) public returns (bool success);
365   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
366   function approve(address _spender, uint256 _amount) public returns (bool success);
367   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
368   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
369   function mint(address _owner, uint _amount) public returns (bool);
370   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
371   function lockPresaleBalances() public returns (bool);
372   function finishMinting() public returns (bool);
373   function enableTransfers(bool _value) public;
374   function enableMasterTransfers(bool _value) public;
375   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
376 
377 }