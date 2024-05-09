1 pragma solidity ^0.4.13;
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
34 contract ProofTokenInterface is Controllable {
35 
36   event Mint(address indexed to, uint256 amount);
37   event MintFinished();
38   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
39   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
40   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42 
43   function totalSupply() public constant returns (uint);
44   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
45   function balanceOf(address _owner) public constant returns (uint256 balance);
46   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
47   function transfer(address _to, uint256 _amount) public returns (bool success);
48   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
49   function approve(address _spender, uint256 _amount) public returns (bool success);
50   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
51   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
52   function mint(address _owner, uint _amount) public returns (bool);
53   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
54   function lockPresaleBalances() public returns (bool);
55   function finishMinting() public returns (bool);
56   function enableTransfers(bool _transfersEnabled) public;
57   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
58 
59 }
60 
61 library SafeMath {
62   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
63     uint256 c = a * b;
64     assert(a == 0 || c / a == b);
65     return c;
66   }
67 
68   function div(uint256 a, uint256 b) internal constant returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   function add(uint256 a, uint256 b) internal constant returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 contract Ownable {
88   address public owner;
89 
90 
91   /**
92    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
93    */
94   function Ownable() public {
95     owner = msg.sender;
96   }
97 
98   /**
99    * @dev Throws if called by any account other than the owner.
100    */
101   modifier onlyOwner() {
102     require(msg.sender == owner);
103     _;
104   }
105 
106   /**
107    * @dev Allows the current owner to transfer control of the contract to a newOwner.
108    * @param newOwner The address to transfer ownership to.
109    */
110   function transferOwnership(address newOwner) public onlyOwner {
111     if (newOwner != address(0)) {
112       owner = newOwner;
113     }
114   }
115 
116 }
117 
118 contract Pausable is Ownable {
119   event Pause();
120   event Unpause();
121 
122   bool public paused = false;
123 
124   function Pausable() public {}
125 
126   /**
127    * @dev modifier to allow actions only when the contract IS paused
128    */
129   modifier whenNotPaused() {
130     require(!paused);
131     _;
132   }
133 
134   /**
135    * @dev modifier to allow actions only when the contract IS NOT paused
136    */
137   modifier whenPaused {
138     require(paused);
139     _;
140   }
141 
142   /**
143    * @dev called by the owner to pause, triggers stopped state
144    */
145   function pause() public onlyOwner whenNotPaused returns (bool) {
146     paused = true;
147     Pause();
148     return true;
149   }
150 
151   /**
152    * @dev called by the owner to unpause, returns to normal state
153    */
154   function unpause() public onlyOwner whenPaused returns (bool) {
155     paused = false;
156     Unpause();
157     return true;
158   }
159 }
160 
161 contract TokenSale is Pausable {
162 
163   using SafeMath for uint256;
164 
165   ProofTokenInterface public proofToken;
166   uint256 public totalWeiRaised;
167   uint256 public tokensMinted;
168   uint256 public totalSupply;
169   uint256 public contributors;
170   uint256 public decimalsMultiplier;
171   uint256 public startTime;
172   uint256 public endTime;
173   uint256 public remainingTokens;
174   uint256 public allocatedTokens;
175   bool public finalized;
176 
177   uint256 public constant BASE_PRICE_IN_WEI = 88000000000000000;
178 
179   uint256 public constant PUBLIC_TOKENS = 1181031 * (10 ** 18);
180   uint256 public constant TOTAL_PRESALE_TOKENS = 112386712924725508802400;
181   uint256 public constant TOKENS_ALLOCATED_TO_PROOF = 1181031 * (10 ** 18);
182 
183   address public constant PROOF_MULTISIG = 0x11e3de1bdA2650fa6BC74e7Cea6A39559E59b103;
184   address public constant PROOF_TOKEN_WALLET = 0x11e3de1bdA2650fa6BC74e7Cea6A39559E59b103;
185 
186   uint256 public tokenCap = PUBLIC_TOKENS - TOTAL_PRESALE_TOKENS;
187   uint256 public cap = tokenCap / (10 ** 18);
188   uint256 public weiCap = cap * BASE_PRICE_IN_WEI;
189 
190   uint256 public firstCheckpointPrice = (BASE_PRICE_IN_WEI * 85) / 100;
191   uint256 public secondCheckpointPrice = (BASE_PRICE_IN_WEI * 90) / 100;
192   uint256 public thirdCheckpointPrice = (BASE_PRICE_IN_WEI * 95) / 100;
193 
194   uint256 public firstCheckpoint = (weiCap * 5) / 100;
195   uint256 public secondCheckpoint = (weiCap * 10) / 100;
196   uint256 public thirdCheckpoint = (weiCap * 20) / 100;
197 
198   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
199   event NewClonedToken(address indexed _cloneToken);
200   event OnTransfer(address _from, address _to, uint _amount);
201   event OnApprove(address _owner, address _spender, uint _amount);
202   event LogInt(string _name, uint256 _value);
203   event Finalized();
204 
205   function TokenSale(
206     address _tokenAddress,
207     uint256 _startTime,
208     uint256 _endTime) public {
209     require(_tokenAddress != 0x0);
210     require(_startTime > 0);
211     require(_endTime > _startTime);
212 
213     startTime = _startTime;
214     endTime = _endTime;
215     proofToken = ProofTokenInterface(_tokenAddress);
216 
217     decimalsMultiplier = (10 ** 18);
218   }
219 
220 
221   /**
222    * High level token purchase function
223    */
224   function() public payable {
225     buyTokens(msg.sender);
226   }
227 
228   /**
229    * Low level token purchase function
230    * @param _beneficiary will receive the tokens.
231    */
232   function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
233     require(_beneficiary != 0x0);
234     require(validPurchase());
235 
236     uint256 weiAmount = msg.value;
237     uint256 priceInWei = getPriceInWei();
238     totalWeiRaised = totalWeiRaised.add(weiAmount);
239 
240     uint256 tokens = weiAmount.mul(decimalsMultiplier).div(priceInWei);
241     tokensMinted = tokensMinted.add(tokens);
242     require(tokensMinted < tokenCap);
243 
244     contributors = contributors.add(1);
245 
246     proofToken.mint(_beneficiary, tokens);
247     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
248     forwardFunds();
249   }
250 
251 
252   /**
253    * Get the price in wei for current premium
254    * @return price
255    */
256   function getPriceInWei() constant public returns (uint256) {
257 
258     uint256 price;
259 
260     if (totalWeiRaised < firstCheckpoint) {
261       price = firstCheckpointPrice;
262     } else if (totalWeiRaised < secondCheckpoint) {
263       price = secondCheckpointPrice;
264     } else if (totalWeiRaised < thirdCheckpoint) {
265       price = thirdCheckpointPrice;
266     } else {
267       price = BASE_PRICE_IN_WEI;
268     }
269 
270     return price;
271   }
272 
273   /**
274   * Forwards funds to the tokensale wallet
275   */
276   function forwardFunds() internal {
277     PROOF_MULTISIG.transfer(msg.value);
278   }
279 
280 
281   /**
282   * Validates the purchase (period, minimum amount, within cap)
283   * @return {bool} valid
284   */
285   function validPurchase() internal constant returns (bool) {
286     uint256 current = now;
287     bool withinPeriod = current >= startTime && current <= endTime;
288     bool nonZeroPurchase = msg.value != 0;
289 
290     return nonZeroPurchase && withinPeriod;
291   }
292 
293   /**
294   * Returns the total Proof token supply
295   * @return total supply {uint256}
296   */
297   function totalSupply() public constant returns (uint256) {
298     return proofToken.totalSupply();
299   }
300 
301   /**
302   * Returns token holder Proof Token balance
303   * @param _owner {address}
304   * @return token balance {uint256}
305   */
306   function balanceOf(address _owner) public constant returns (uint256) {
307     return proofToken.balanceOf(_owner);
308   }
309 
310   //controller interface
311 
312   // function proxyPayment(address _owner) payable public {
313   //   revert();
314   // }
315 
316   /**
317   * Controller Interface transfer callback method
318   * @param _from {address}
319   * @param _to {address}
320   * @param _amount {number}
321   */
322   function onTransfer(address _from, address _to, uint _amount) public returns (bool) {
323     OnTransfer(_from, _to, _amount);
324     return true;
325   }
326 
327   /**
328   * Controller Interface transfer callback method
329   * @param _owner {address}
330   * @param _spender {address}
331   * @param _amount {number}
332    */
333   function onApprove(address _owner, address _spender, uint _amount) public returns (bool) {
334     OnApprove(_owner, _spender, _amount);
335     return true;
336   }
337 
338   /**
339   * Change the Proof Token controller
340   * @param _newController {address}
341   */
342   function changeController(address _newController) public onlyOwner {
343     proofToken.transferControl(_newController);
344   }
345 
346 
347   function enableTransfers(bool _transfersEnabled) public onlyOwner {
348     proofToken.enableTransfers(_transfersEnabled);
349   }
350 
351   /**
352   * Allocates Proof tokens to the given Proof Token wallet
353   * @param _tokens {uint256}
354   */
355   function allocateProofTokens(uint256 _tokens) public onlyOwner whenNotFinalized {
356     proofToken.mint(PROOF_TOKEN_WALLET, _tokens);
357   }
358 
359   /**
360   * Finalize the token sale (can only be called by owner)
361   */
362   function finalize() public onlyOwner {
363     require(paused);
364 
365     proofToken.finishMinting();
366     proofToken.enableTransfers(true);
367     Finalized();
368 
369     finalized = true;
370   }
371 
372   modifier whenNotFinalized() {
373     require(!paused);
374     _;
375   }
376 
377 }