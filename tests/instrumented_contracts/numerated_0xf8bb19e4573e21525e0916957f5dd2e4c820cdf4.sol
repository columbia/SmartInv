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
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal constant returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 contract Ownable {
61   address public owner;
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     if (newOwner != address(0)) {
85       owner = newOwner;
86     }
87   }
88 
89 }
90 
91 contract Pausable is Ownable {
92   event Pause();
93   event Unpause();
94 
95   bool public paused = false;
96 
97   function Pausable() public {}
98 
99   /**
100    * @dev modifier to allow actions only when the contract IS paused
101    */
102   modifier whenNotPaused() {
103     require(!paused);
104     _;
105   }
106 
107   /**
108    * @dev modifier to allow actions only when the contract IS NOT paused
109    */
110   modifier whenPaused {
111     require(paused);
112     _;
113   }
114 
115   /**
116    * @dev called by the owner to pause, triggers stopped state
117    */
118   function pause() public onlyOwner whenNotPaused returns (bool) {
119     paused = true;
120     Pause();
121     return true;
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() public onlyOwner whenPaused returns (bool) {
128     paused = false;
129     Unpause();
130     return true;
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
150 
151   bool public proofTokensAllocated;
152   address public proofMultiSig = 0x99892Ac6DA1b3851167Cb959fE945926bca89f09;
153 
154   uint256 public constant BASE_PRICE_IN_WEI = 88000000000000000;
155   uint256 public constant PUBLIC_TOKENS = 1181031 * (10 ** 18);
156   uint256 public constant TOTAL_PRESALE_TOKENS = 112386712924725508802400;
157   uint256 public constant TOKENS_ALLOCATED_TO_PROOF = 1181031 * (10 ** 18);
158 
159 
160 
161   uint256 public tokenCap = PUBLIC_TOKENS - TOTAL_PRESALE_TOKENS;
162   uint256 public cap = tokenCap / (10 ** 18);
163   uint256 public weiCap = cap * BASE_PRICE_IN_WEI;
164 
165   uint256 public firstDiscountPrice = (BASE_PRICE_IN_WEI * 85) / 100;
166   uint256 public secondDiscountPrice = (BASE_PRICE_IN_WEI * 90) / 100;
167   uint256 public thirdDiscountPrice = (BASE_PRICE_IN_WEI * 95) / 100;
168 
169   uint256 public firstDiscountCap = (weiCap * 5) / 100;
170   uint256 public secondDiscountCap = (weiCap * 10) / 100;
171   uint256 public thirdDiscountCap = (weiCap * 20) / 100;
172 
173   bool public started = false;
174 
175   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
176   event NewClonedToken(address indexed _cloneToken);
177   event OnTransfer(address _from, address _to, uint _amount);
178   event OnApprove(address _owner, address _spender, uint _amount);
179   event LogInt(string _name, uint256 _value);
180   event Finalized();
181 
182   function TokenSale(address _tokenAddress, uint256 _startTime, uint256 _endTime) public {
183     require(_tokenAddress != 0x0);
184     require(_startTime > 0);
185     require(_endTime > _startTime);
186 
187     startTime = _startTime;
188     endTime = _endTime;
189     proofToken = ProofTokenInterface(_tokenAddress);
190 
191     decimalsMultiplier = (10 ** 18);
192   }
193 
194 
195   /**
196    * High level token purchase function
197    */
198   function() public payable {
199     buyTokens(msg.sender);
200   }
201 
202   /**
203    * Low level token purchase function
204    * @param _beneficiary will receive the tokens.
205    */
206   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
207     require(_beneficiary != 0x0);
208     require(validPurchase());
209 
210     uint256 weiAmount = msg.value;
211     uint256 priceInWei = getPriceInWei();
212     totalWeiRaised = totalWeiRaised.add(weiAmount);
213 
214     uint256 tokens = weiAmount.mul(decimalsMultiplier).div(priceInWei);
215     tokensMinted = tokensMinted.add(tokens);
216     require(tokensMinted < tokenCap);
217 
218     contributors = contributors.add(1);
219 
220     proofToken.mint(_beneficiary, tokens);
221     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
222     forwardFunds();
223   }
224 
225 
226   /**
227    * Get the price in wei for current premium
228    * @return price {uint256}
229    */
230   function getPriceInWei() constant public returns (uint256) {
231 
232     uint256 price;
233 
234     if (totalWeiRaised < firstDiscountCap) {
235       price = firstDiscountPrice;
236     } else if (totalWeiRaised < secondDiscountCap) {
237       price = secondDiscountPrice;
238     } else if (totalWeiRaised < thirdDiscountCap) {
239       price = thirdDiscountPrice;
240     } else {
241       price = BASE_PRICE_IN_WEI;
242     }
243 
244     return price;
245   }
246 
247   /**
248   * Forwards funds to the tokensale wallet
249   */
250   function forwardFunds() internal {
251     proofMultiSig.transfer(msg.value);
252   }
253 
254 
255   /**
256   * Validates the purchase (period, minimum amount, within cap)
257   * @return {bool} valid
258   */
259   function validPurchase() internal constant returns (bool) {
260     uint256 current = now;
261     bool presaleStarted = (current >= startTime || started);
262     bool presaleNotEnded = current <= endTime;
263     bool nonZeroPurchase = msg.value != 0;
264     return nonZeroPurchase && presaleStarted && presaleNotEnded;
265   }
266 
267   /**
268   * Returns the total Proof token supply
269   * @return totalSupply {uint256} Proof Token Total Supply
270   */
271   function totalSupply() public constant returns (uint256) {
272     return proofToken.totalSupply();
273   }
274 
275   /**
276   * Returns token holder Proof Token balance
277   * @param _owner {address} Token holder address
278   * @return balance {uint256} Corresponding token holder balance
279   */
280   function balanceOf(address _owner) public constant returns (uint256) {
281     return proofToken.balanceOf(_owner);
282   }
283 
284   /**
285   * Change the Proof Token controller
286   * @param _newController {address} New Proof Token controller
287   */
288   function changeController(address _newController) public {
289     require(isContract(_newController));
290     proofToken.transferControl(_newController);
291   }
292 
293 
294   function enableTransfers() public {
295     if (now < endTime) {
296       require(msg.sender == owner);
297     }
298     proofToken.enableTransfers(true);
299   }
300 
301   function lockTransfers() public onlyOwner {
302     require(now < endTime);
303     proofToken.enableTransfers(false);
304   }
305 
306   function enableMasterTransfers() public onlyOwner {
307     proofToken.enableMasterTransfers(true);
308   }
309 
310   function lockMasterTransfers() public onlyOwner {
311     proofToken.enableMasterTransfers(false);
312   }
313 
314   function forceStart() public onlyOwner {
315     started = true;
316   }
317 
318   function allocateProofTokens() public onlyOwner whenNotFinalized {
319     proofToken.mint(proofMultiSig, TOKENS_ALLOCATED_TO_PROOF);
320     proofTokensAllocated = true;
321   }
322 
323   function finalize() public onlyOwner {
324     require(paused);
325     require(proofTokensAllocated);
326 
327     proofToken.finishMinting();
328     proofToken.enableTransfers(true);
329     Finalized();
330 
331     finalized = true;
332   }
333 
334 
335   function isContract(address _addr) constant internal returns(bool) {
336     uint size;
337     if (_addr == 0)
338       return false;
339     assembly {
340         size := extcodesize(_addr)
341     }
342     return size>0;
343   }
344 
345   modifier whenNotFinalized() {
346     require(!finalized);
347     _;
348   }
349 
350 }
351 
352 contract ProofTokenInterface is Controllable {
353 
354   event Mint(address indexed to, uint256 amount);
355   event MintFinished();
356   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
357   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
358   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
359   event Transfer(address indexed from, address indexed to, uint256 value);
360 
361   function totalSupply() public constant returns (uint);
362   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
363   function balanceOf(address _owner) public constant returns (uint256 balance);
364   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
365   function transfer(address _to, uint256 _amount) public returns (bool success);
366   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
367   function approve(address _spender, uint256 _amount) public returns (bool success);
368   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
369   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
370   function mint(address _owner, uint _amount) public returns (bool);
371   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
372   function lockPresaleBalances() public returns (bool);
373   function finishMinting() public returns (bool);
374   function enableTransfers(bool _value) public;
375   function enableMasterTransfers(bool _value) public;
376   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
377 
378 }