1 pragma solidity ^0.4.13;
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
120 
121   uint256 public constant BASE_PRICE_IN_WEI = 88000000000000000;
122 
123   uint256 public constant PUBLIC_TOKENS = 1181031 * (10 ** 18);
124   uint256 public constant TOTAL_PRESALE_TOKENS = 112386712924725508802400;
125   uint256 public constant TOKENS_ALLOCATED_TO_PROOF = 1181031 * (10 ** 18);
126 
127   address public constant PROOF_MULTISIG = 0x99892Ac6DA1b3851167Cb959fE945926bca89f09;
128 
129   uint256 public tokenCap = PUBLIC_TOKENS - TOTAL_PRESALE_TOKENS;
130   uint256 public cap = tokenCap / (10 ** 18);
131   uint256 public weiCap = cap * BASE_PRICE_IN_WEI;
132 
133   uint256 public firstCheckpointPrice = (BASE_PRICE_IN_WEI * 85) / 100;
134   uint256 public secondCheckpointPrice = (BASE_PRICE_IN_WEI * 90) / 100;
135   uint256 public thirdCheckpointPrice = (BASE_PRICE_IN_WEI * 95) / 100;
136 
137   uint256 public firstCheckpoint = (weiCap * 5) / 100;
138   uint256 public secondCheckpoint = (weiCap * 10) / 100;
139   uint256 public thirdCheckpoint = (weiCap * 20) / 100;
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
150   function TokenSale(
151     address _tokenAddress,
152     uint256 _startTime,
153     uint256 _endTime) public {
154     require(_tokenAddress != 0x0);
155     require(_startTime > 0);
156     require(_endTime > _startTime);
157 
158     startTime = _startTime;
159     endTime = _endTime;
160     proofToken = ProofTokenInterface(_tokenAddress);
161 
162     decimalsMultiplier = (10 ** 18);
163   }
164 
165 
166   /**
167    * High level token purchase function
168    */
169   function() public payable {
170     buyTokens(msg.sender);
171   }
172 
173   /**
174    * Low level token purchase function
175    * @param _beneficiary will receive the tokens.
176    */
177   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
178     require(_beneficiary != 0x0);
179     require(validPurchase());
180 
181     uint256 weiAmount = msg.value;
182     uint256 priceInWei = getPriceInWei();
183     totalWeiRaised = totalWeiRaised.add(weiAmount);
184 
185     uint256 tokens = weiAmount.mul(decimalsMultiplier).div(priceInWei);
186     tokensMinted = tokensMinted.add(tokens);
187     require(tokensMinted < tokenCap);
188 
189     contributors = contributors.add(1);
190 
191     proofToken.mint(_beneficiary, tokens);
192     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
193     forwardFunds();
194   }
195 
196 
197   /**
198    * Get the price in wei for current premium
199    * @return price
200    */
201   function getPriceInWei() constant public returns (uint256) {
202 
203     uint256 price;
204 
205     if (totalWeiRaised < firstCheckpoint) {
206       price = firstCheckpointPrice;
207     } else if (totalWeiRaised < secondCheckpoint) {
208       price = secondCheckpointPrice;
209     } else if (totalWeiRaised < thirdCheckpoint) {
210       price = thirdCheckpointPrice;
211     } else {
212       price = BASE_PRICE_IN_WEI;
213     }
214 
215     return price;
216   }
217 
218   /**
219   * Forwards funds to the tokensale wallet
220   */
221   function forwardFunds() internal {
222     PROOF_MULTISIG.transfer(msg.value);
223   }
224 
225 
226   /**
227   * Validates the purchase (period, minimum amount, within cap)
228   * @return {bool} valid
229   */
230   function validPurchase() internal constant returns (bool) {
231     uint256 current = now;
232     bool presaleStarted = (current >= startTime || started);
233     bool presaleNotEnded = current <= endTime;
234     bool nonZeroPurchase = msg.value != 0;
235     return nonZeroPurchase && presaleStarted && presaleNotEnded;
236   }
237 
238   /**
239   * Returns the total Proof token supply
240   * @return total supply {uint256}
241   */
242   function totalSupply() public constant returns (uint256) {
243     return proofToken.totalSupply();
244   }
245 
246   /**
247   * Returns token holder Proof Token balance
248   * @param _owner {address}
249   * @return token balance {uint256}
250   */
251   function balanceOf(address _owner) public constant returns (uint256) {
252     return proofToken.balanceOf(_owner);
253   }
254 
255   /**
256   * Change the Proof Token controller
257   * @param _newController {address}
258   */
259   function changeController(address _newController) public {
260     require(isContract(_newController));
261     proofToken.transferControl(_newController);
262   }
263 
264 
265   function enableTransfers() public {
266     if (now < endTime) {
267       require(msg.sender == owner);
268     }
269 
270     proofToken.enableTransfers(true);
271   }
272 
273   function lockTransfers() public onlyOwner {
274     require(now < endTime);
275     proofToken.enableTransfers(false);
276   }
277 
278   function enableMasterTransfers() public onlyOwner {
279     proofToken.enableMasterTransfers(true);
280   }
281 
282   function lockMasterTransfers() public onlyOwner {
283     proofToken.enableMasterTransfers(false);
284   }
285 
286   function isContract(address _addr) constant internal returns(bool) {
287       uint size;
288       if (_addr == 0)
289         return false;
290       assembly {
291           size := extcodesize(_addr)
292       }
293       return size>0;
294   }
295 
296   /**
297   * Allocates Proof tokens to the given Proof Token wallet
298   */
299   function allocateProofTokens() public onlyOwner whenNotFinalized {
300     proofToken.mint(PROOF_MULTISIG, TOKENS_ALLOCATED_TO_PROOF);
301     proofTokensAllocated = true;
302   }
303 
304   /**
305   * Finalize the token sale (can only be called by owner)
306   */
307   function finalize() public onlyOwner {
308     require(paused);
309     require(proofTokensAllocated);
310 
311     proofToken.finishMinting();
312     proofToken.enableTransfers(true);
313     Finalized();
314 
315     finalized = true;
316   }
317 
318   function forceStart() public onlyOwner {
319     started = true;
320   }
321 
322   modifier whenNotFinalized() {
323     require(!paused);
324     _;
325   }
326 
327 }
328 
329 contract Controllable {
330   address public controller;
331 
332 
333   /**
334    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
335    */
336   function Controllable() public {
337     controller = msg.sender;
338   }
339 
340   /**
341    * @dev Throws if called by any account other than the owner.
342    */
343   modifier onlyController() {
344     require(msg.sender == controller);
345     _;
346   }
347 
348   /**
349    * @dev Allows the current owner to transfer control of the contract to a newOwner.
350    * @param newController The address to transfer ownership to.
351    */
352   function transferControl(address newController) public onlyController {
353     if (newController != address(0)) {
354       controller = newController;
355     }
356   }
357 
358 }
359 
360 contract ProofTokenInterface is Controllable {
361 
362   event Mint(address indexed to, uint256 amount);
363   event MintFinished();
364   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
365   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
366   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
367   event Transfer(address indexed from, address indexed to, uint256 value);
368 
369   function totalSupply() public constant returns (uint);
370   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
371   function balanceOf(address _owner) public constant returns (uint256 balance);
372   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
373   function transfer(address _to, uint256 _amount) public returns (bool success);
374   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
375   function approve(address _spender, uint256 _amount) public returns (bool success);
376   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
377   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
378   function mint(address _owner, uint _amount) public returns (bool);
379   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
380   function lockPresaleBalances() public returns (bool);
381   function finishMinting() public returns (bool);
382   function enableTransfers(bool _value) public;
383   function enableMasterTransfers(bool _value) public;
384   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
385 
386 }