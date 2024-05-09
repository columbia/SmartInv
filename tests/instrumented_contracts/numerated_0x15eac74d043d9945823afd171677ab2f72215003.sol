1 pragma solidity ^0.4.15;
2 
3 contract Controllable {
4   address public controller;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
9    */
10   function Controllable() public {
11     controller = msg.sender;
12   }
13 
14   /**
15    * @dev Throws if called by any account other than the owner.
16    */
17   modifier onlyController() {
18     require(msg.sender == controller);
19     _;
20   }
21 
22   /**
23    * @dev Allows the current owner to transfer control of the contract to a newOwner.
24    * @param newController The address to transfer ownership to.
25    */
26   function transferControl(address newController) public onlyController {
27     if (newController != address(0)) {
28       controller = newController;
29     }
30   }
31 
32 }
33 
34 contract Ownable {
35   address public owner;
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     if (newOwner != address(0)) {
59       owner = newOwner;
60     }
61   }
62 
63 }
64 
65 contract Pausable is Ownable {
66   event Pause();
67   event Unpause();
68 
69   bool public paused = false;
70 
71   function Pausable() public {}
72 
73   /**
74    * @dev modifier to allow actions only when the contract IS paused
75    */
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   /**
82    * @dev modifier to allow actions only when the contract IS NOT paused
83    */
84   modifier whenPaused {
85     require(paused);
86     _;
87   }
88 
89   /**
90    * @dev called by the owner to pause, triggers stopped state
91    */
92   function pause() public onlyOwner whenNotPaused returns (bool) {
93     paused = true;
94     Pause();
95     return true;
96   }
97 
98   /**
99    * @dev called by the owner to unpause, returns to normal state
100    */
101   function unpause() public onlyOwner whenPaused returns (bool) {
102     paused = false;
103     Unpause();
104     return true;
105   }
106 }
107 
108 library SafeMath {
109   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
110     uint256 c = a * b;
111     assert(a == 0 || c / a == b);
112     return c;
113   }
114 
115   function div(uint256 a, uint256 b) internal constant returns (uint256) {
116     // assert(b > 0); // Solidity automatically throws when dividing by 0
117     uint256 c = a / b;
118     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119     return c;
120   }
121 
122   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
123     assert(b <= a);
124     return a - b;
125   }
126 
127   function add(uint256 a, uint256 b) internal constant returns (uint256) {
128     uint256 c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 }
133 
134 contract TokenSale is Pausable {
135 
136   using SafeMath for uint256;
137 
138   ProofTokenInterface public proofToken;
139   uint256 public totalWeiRaised;
140   uint256 public tokensMinted;
141   uint256 public totalSupply;
142   uint256 public contributors;
143   uint256 public decimalsMultiplier;
144   uint256 public startTime;
145   uint256 public endTime;
146   uint256 public remainingTokens;
147   uint256 public allocatedTokens;
148 
149   bool public finalized;
150   bool public proofTokensAllocated;
151   address public proofMultiSig = 0x99892Ac6DA1b3851167Cb959fE945926bca89f09;
152 
153   uint256 public constant BASE_PRICE_IN_WEI = 88000000000000000;
154   uint256 public constant PUBLIC_TOKENS = 1181031 * (10 ** 18);
155   uint256 public constant TOTAL_PRESALE_TOKENS = 112386712924725508802400;
156   uint256 public constant TOKENS_ALLOCATED_TO_PROOF = 1181031 * (10 ** 18);
157 
158 
159 
160   uint256 public tokenCap = PUBLIC_TOKENS - TOTAL_PRESALE_TOKENS;
161   uint256 public cap = tokenCap / (10 ** 18);
162   uint256 public weiCap = cap * BASE_PRICE_IN_WEI;
163 
164   uint256 public firstDiscountPrice = (BASE_PRICE_IN_WEI * 85) / 100;
165   uint256 public secondDiscountPrice = (BASE_PRICE_IN_WEI * 90) / 100;
166   uint256 public thirdDiscountPrice = (BASE_PRICE_IN_WEI * 95) / 100;
167 
168   uint256 public firstDiscountCap = (weiCap * 5) / 100;
169   uint256 public secondDiscountCap = (weiCap * 10) / 100;
170   uint256 public thirdDiscountCap = (weiCap * 20) / 100;
171 
172   bool public started = false;
173 
174   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
175   event NewClonedToken(address indexed _cloneToken);
176   event OnTransfer(address _from, address _to, uint _amount);
177   event OnApprove(address _owner, address _spender, uint _amount);
178   event LogInt(string _name, uint256 _value);
179   event Finalized();
180 
181   function TokenSale(address _tokenAddress, uint256 _startTime, uint256 _endTime) public {
182     require(_tokenAddress != 0x0);
183     require(_startTime > 0);
184     require(_endTime > _startTime);
185 
186     startTime = _startTime;
187     endTime = _endTime;
188     proofToken = ProofTokenInterface(_tokenAddress);
189 
190     decimalsMultiplier = (10 ** 18);
191   }
192 
193 
194   /**
195    * High level token purchase function
196    */
197   function() public payable {
198     buyTokens(msg.sender);
199   }
200 
201   /**
202    * Low level token purchase function
203    * @param _beneficiary will receive the tokens.
204    */
205   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
206     require(_beneficiary != 0x0);
207     require(validPurchase());
208 
209     uint256 weiAmount = msg.value;
210     uint256 priceInWei = getPriceInWei();
211     totalWeiRaised = totalWeiRaised.add(weiAmount);
212 
213     uint256 tokens = weiAmount.mul(decimalsMultiplier).div(priceInWei);
214     tokensMinted = tokensMinted.add(tokens);
215     require(tokensMinted < tokenCap);
216 
217     contributors = contributors.add(1);
218 
219     proofToken.mint(_beneficiary, tokens);
220     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
221     forwardFunds();
222   }
223 
224 
225   /**
226    * Get the price in wei for current premium
227    * @return price {uint256}
228    */
229   function getPriceInWei() constant public returns (uint256) {
230 
231     uint256 price;
232 
233     if (totalWeiRaised < firstDiscountCap) {
234       price = firstDiscountPrice;
235     } else if (totalWeiRaised < secondDiscountCap) {
236       price = secondDiscountPrice;
237     } else if (totalWeiRaised < thirdDiscountCap) {
238       price = thirdDiscountPrice;
239     } else {
240       price = BASE_PRICE_IN_WEI;
241     }
242 
243     return price;
244   }
245 
246   /**
247   * Forwards funds to the tokensale wallet
248   */
249   function forwardFunds() internal {
250     proofMultiSig.transfer(msg.value);
251   }
252 
253 
254   /**
255   * Validates the purchase (period, minimum amount, within cap)
256   * @return {bool} valid
257   */
258   function validPurchase() internal constant returns (bool) {
259     uint256 current = now;
260     bool presaleStarted = (current >= startTime || started);
261     bool presaleNotEnded = current <= endTime;
262     bool nonZeroPurchase = msg.value != 0;
263     return nonZeroPurchase && presaleStarted && presaleNotEnded;
264   }
265 
266   /**
267   * Returns the total Proof token supply
268   * @return totalSupply {uint256} Proof Token Total Supply
269   */
270   function totalSupply() public constant returns (uint256) {
271     return proofToken.totalSupply();
272   }
273 
274   /**
275   * Returns token holder Proof Token balance
276   * @param _owner {address} Token holder address
277   * @return balance {uint256} Corresponding token holder balance
278   */
279   function balanceOf(address _owner) public constant returns (uint256) {
280     return proofToken.balanceOf(_owner);
281   }
282 
283   /**
284   * Change the Proof Token controller
285   * @param _newController {address} New Proof Token controller
286   */
287   function changeController(address _newController) onlyOwner public returns (bool) {
288     proofToken.transferControl(_newController);
289     return true;
290   }
291 
292 
293   function enableTransfers() public returns (bool) {
294     if (now < endTime) {
295       require(msg.sender == owner);
296     }
297     proofToken.enableTransfers(true);
298     return true;
299   }
300 
301   function lockTransfers() public onlyOwner returns (bool) {
302     require(now < endTime);
303     proofToken.enableTransfers(false);
304     return true;
305   }
306 
307   function enableMasterTransfers() public onlyOwner returns (bool) {
308     proofToken.enableMasterTransfers(true);
309     return true;
310   }
311 
312   function lockMasterTransfers() public onlyOwner returns (bool) {
313     proofToken.enableMasterTransfers(false);
314     return true;
315   }
316 
317   function forceStart() public onlyOwner returns (bool) {
318     started = true;
319     return true;
320   }
321 
322   function allocateProofTokens() public onlyOwner whenNotFinalized returns (bool) {
323     require(!proofTokensAllocated);
324     proofToken.mint(proofMultiSig, TOKENS_ALLOCATED_TO_PROOF);
325     proofTokensAllocated = true;
326     return true;
327   }
328 
329   function finalize() public onlyOwner returns (bool) {
330     require(paused);
331     require(proofTokensAllocated);
332 
333     proofToken.finishMinting();
334     proofToken.enableTransfers(true);
335     Finalized();
336 
337     finalized = true;
338     return true;
339   }
340 
341 
342   function isContract(address _addr) constant internal returns (bool) {
343     uint size;
344     if (_addr == 0)
345       return false;
346     assembly {
347         size := extcodesize(_addr)
348     }
349     return size>0;
350   }
351 
352   modifier whenNotFinalized() {
353     require(!finalized);
354     _;
355   }
356 
357 }
358 
359 contract ProofTokenInterface is Controllable {
360 
361   event Mint(address indexed to, uint256 amount);
362   event MintFinished();
363   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
364   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
365   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
366   event Transfer(address indexed from, address indexed to, uint256 value);
367 
368   function totalSupply() public constant returns (uint);
369   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
370   function balanceOf(address _owner) public constant returns (uint256 balance);
371   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
372   function transfer(address _to, uint256 _amount) public returns (bool success);
373   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
374   function approve(address _spender, uint256 _amount) public returns (bool success);
375   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
376   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
377   function mint(address _owner, uint _amount) public returns (bool);
378   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
379   function lockPresaleBalances() public returns (bool);
380   function finishMinting() public returns (bool);
381   function enableTransfers(bool _value) public;
382   function enableMasterTransfers(bool _value) public;
383   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
384 
385 }