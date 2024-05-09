1 pragma solidity ^0.4.15;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
9    */
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14   /**
15    * @dev Throws if called by any account other than the owner.
16    */
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   /**
23    * @dev Allows the current owner to transfer control of the contract to a newOwner.
24    * @param newOwner The address to transfer ownership to.
25    */
26   function transferOwnership(address newOwner) public onlyOwner {
27     if (newOwner != address(0)) {
28       owner = newOwner;
29     }
30   }
31 
32 }
33 
34 contract Controllable {
35   address public controller;
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
40    */
41   function Controllable() public {
42     controller = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyController() {
49     require(msg.sender == controller);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newController The address to transfer ownership to.
56    */
57   function transferControl(address newController) public onlyController {
58     if (newController != address(0)) {
59       controller = newController;
60     }
61   }
62 
63 }
64 
65 contract ProofTokenInterface is Controllable {
66 
67   event Mint(address indexed to, uint256 amount);
68   event MintFinished();
69   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
70   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
71   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 
74   function totalSupply() public constant returns (uint);
75   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
76   function balanceOf(address _owner) public constant returns (uint256 balance);
77   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
78   function transfer(address _to, uint256 _amount) public returns (bool success);
79   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
80   function approve(address _spender, uint256 _amount) public returns (bool success);
81   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
82   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
83   function mint(address _owner, uint _amount) public returns (bool);
84   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
85   function lockPresaleBalances() public returns (bool);
86   function finishMinting() public returns (bool);
87   function enableTransfers(bool _value) public;
88   function enableMasterTransfers(bool _value) public;
89   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
90 
91 }
92 
93 library SafeMath {
94   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
95     uint256 c = a * b;
96     assert(a == 0 || c / a == b);
97     return c;
98   }
99 
100   function div(uint256 a, uint256 b) internal constant returns (uint256) {
101     // assert(b > 0); // Solidity automatically throws when dividing by 0
102     uint256 c = a / b;
103     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104     return c;
105   }
106 
107   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   function add(uint256 a, uint256 b) internal constant returns (uint256) {
113     uint256 c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 contract Pausable is Ownable {
120   event Pause();
121   event Unpause();
122 
123   bool public paused = false;
124 
125   function Pausable() public {}
126 
127   /**
128    * @dev modifier to allow actions only when the contract IS paused
129    */
130   modifier whenNotPaused() {
131     require(!paused);
132     _;
133   }
134 
135   /**
136    * @dev modifier to allow actions only when the contract IS NOT paused
137    */
138   modifier whenPaused {
139     require(paused);
140     _;
141   }
142 
143   /**
144    * @dev called by the owner to pause, triggers stopped state
145    */
146   function pause() public onlyOwner whenNotPaused returns (bool) {
147     paused = true;
148     Pause();
149     return true;
150   }
151 
152   /**
153    * @dev called by the owner to unpause, returns to normal state
154    */
155   function unpause() public onlyOwner whenPaused returns (bool) {
156     paused = false;
157     Unpause();
158     return true;
159   }
160 }
161 
162 contract TokenSale is Pausable {
163 
164   using SafeMath for uint256;
165 
166   ProofTokenInterface public proofToken;
167   uint256 public totalWeiRaised;
168   uint256 public tokensMinted;
169   uint256 public totalSupply;
170   uint256 public contributors;
171   uint256 public decimalsMultiplier;
172   uint256 public startTime;
173   uint256 public endTime;
174   uint256 public remainingTokens;
175   uint256 public allocatedTokens;
176 
177   bool public finalized;
178   bool public proofTokensAllocated;
179 
180   uint256 public constant BASE_PRICE_IN_WEI = 88000000000000000;
181 
182   uint256 public constant PUBLIC_TOKENS = 1181031 * (10 ** 18);
183   uint256 public constant TOTAL_PRESALE_TOKENS = 112386712924725508802400;
184   uint256 public constant TOKENS_ALLOCATED_TO_PROOF = 1181031 * (10 ** 18);
185 
186   address public constant PROOF_MULTISIG = 0x99892Ac6DA1b3851167Cb959fE945926bca89f09;
187 
188   uint256 public tokenCap = PUBLIC_TOKENS - TOTAL_PRESALE_TOKENS;
189   uint256 public cap = tokenCap / (10 ** 18);
190   uint256 public weiCap = cap * BASE_PRICE_IN_WEI;
191 
192   uint256 public firstCheckpointPrice = (BASE_PRICE_IN_WEI * 85) / 100;
193   uint256 public secondCheckpointPrice = (BASE_PRICE_IN_WEI * 90) / 100;
194   uint256 public thirdCheckpointPrice = (BASE_PRICE_IN_WEI * 95) / 100;
195 
196   uint256 public firstCheckpoint = (weiCap * 5) / 100;
197   uint256 public secondCheckpoint = (weiCap * 10) / 100;
198   uint256 public thirdCheckpoint = (weiCap * 20) / 100;
199 
200   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
201   event NewClonedToken(address indexed _cloneToken);
202   event OnTransfer(address _from, address _to, uint _amount);
203   event OnApprove(address _owner, address _spender, uint _amount);
204   event LogInt(string _name, uint256 _value);
205   event Finalized();
206 
207   function TokenSale(
208     address _tokenAddress,
209     uint256 _startTime,
210     uint256 _endTime) public {
211     require(_tokenAddress != 0x0);
212     require(_startTime > 0);
213     require(_endTime > _startTime);
214 
215     startTime = _startTime;
216     endTime = _endTime;
217     proofToken = ProofTokenInterface(_tokenAddress);
218 
219     decimalsMultiplier = (10 ** 18);
220   }
221 
222 
223   /**
224    * High level token purchase function
225    */
226   function() public payable {
227     buyTokens(msg.sender);
228   }
229 
230   /**
231    * Low level token purchase function
232    * @param _beneficiary will receive the tokens.
233    */
234   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
235     require(_beneficiary != 0x0);
236     require(validPurchase());
237 
238     uint256 weiAmount = msg.value;
239     uint256 priceInWei = getPriceInWei();
240     totalWeiRaised = totalWeiRaised.add(weiAmount);
241 
242     uint256 tokens = weiAmount.mul(decimalsMultiplier).div(priceInWei);
243     tokensMinted = tokensMinted.add(tokens);
244     require(tokensMinted < tokenCap);
245 
246     contributors = contributors.add(1);
247 
248     proofToken.mint(_beneficiary, tokens);
249     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
250     forwardFunds();
251   }
252 
253 
254   /**
255    * Get the price in wei for current premium
256    * @return price
257    */
258   function getPriceInWei() constant public returns (uint256) {
259 
260     uint256 price;
261 
262     if (totalWeiRaised < firstCheckpoint) {
263       price = firstCheckpointPrice;
264     } else if (totalWeiRaised < secondCheckpoint) {
265       price = secondCheckpointPrice;
266     } else if (totalWeiRaised < thirdCheckpoint) {
267       price = thirdCheckpointPrice;
268     } else {
269       price = BASE_PRICE_IN_WEI;
270     }
271 
272     return price;
273   }
274 
275   /**
276   * Forwards funds to the tokensale wallet
277   */
278   function forwardFunds() internal {
279     PROOF_MULTISIG.transfer(msg.value);
280   }
281 
282 
283   /**
284   * Validates the purchase (period, minimum amount, within cap)
285   * @return {bool} valid
286   */
287   function validPurchase() internal constant returns (bool) {
288     uint256 current = now;
289     bool withinPeriod = current >= startTime && current <= endTime;
290     bool nonZeroPurchase = msg.value != 0;
291 
292     return nonZeroPurchase && withinPeriod;
293   }
294 
295   /**
296   * Returns the total Proof token supply
297   * @return total supply {uint256}
298   */
299   function totalSupply() public constant returns (uint256) {
300     return proofToken.totalSupply();
301   }
302 
303   /**
304   * Returns token holder Proof Token balance
305   * @param _owner {address}
306   * @return token balance {uint256}
307   */
308   function balanceOf(address _owner) public constant returns (uint256) {
309     return proofToken.balanceOf(_owner);
310   }
311 
312   /**
313   * Change the Proof Token controller
314   * @param _newController {address}
315   */
316   function changeController(address _newController) public {
317     require(isContract(_newController));
318     proofToken.transferControl(_newController);
319   }
320 
321 
322   function enableTransfers() public {
323     if (now < endTime) {
324       require(msg.sender == owner);
325     }
326 
327     proofToken.enableTransfers(true);
328   }
329 
330   function lockTransfers() public onlyOwner {
331     require(now < endTime);
332     proofToken.enableTransfers(false);
333   }
334 
335   function enableMasterTransfers() public onlyOwner {
336     proofToken.enableMasterTransfers(true);
337   }
338 
339   function lockMasterTransfers() public onlyOwner {
340     proofToken.enableMasterTransfers(false);
341   }
342 
343   function isContract(address _addr) constant internal returns(bool) {
344       uint size;
345       if (_addr == 0)
346         return false;
347       assembly {
348           size := extcodesize(_addr)
349       }
350       return size>0;
351   }
352 
353   /**
354   * Allocates Proof tokens to the given Proof Token wallet
355   */
356   function allocateProofTokens() public onlyOwner whenNotFinalized {
357     proofToken.mint(PROOF_MULTISIG, TOKENS_ALLOCATED_TO_PROOF);
358     proofTokensAllocated = true;
359   }
360 
361   /**
362   * Finalize the token sale (can only be called by owner)
363   */
364   function finalize() public onlyOwner {
365     require(paused);
366     require(proofTokensAllocated);
367 
368     proofToken.finishMinting();
369     proofToken.enableTransfers(true);
370     Finalized();
371 
372     finalized = true;
373   }
374 
375   modifier whenNotFinalized() {
376     require(!paused);
377     _;
378   }
379 
380 }