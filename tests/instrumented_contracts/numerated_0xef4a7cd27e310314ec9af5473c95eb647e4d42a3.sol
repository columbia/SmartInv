1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     if (_a == 0) {
16       return 0;
17     }
18 
19     uint256 c = _a * _b;
20     require(c / _a == _b);
21 
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     require(_b > 0); // Solidity only automatically asserts when dividing by 0
30     uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32 
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     require(_b <= _a);
41     uint256 c = _a - _b;
42 
43     return c;
44   }
45 
46   /**
47   * @dev Adds two numbers, reverts on overflow.
48   */
49   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     uint256 c = _a + _b;
51     require(c >= _a);
52 
53     return c;
54   }
55 
56   /**
57   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
58   * reverts when dividing by zero.
59   */
60   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b != 0);
62     return a % b;
63   }
64 }
65 
66 /**
67  * @title SafeERC20
68  * @dev Wrappers around ERC20 operations that throw on failure.
69  */
70 library SafeERC20 {
71   function safeTransfer(
72     ERC20 _token,
73     address _to,
74     uint256 _value
75   )
76     internal
77   {
78     require(_token.transfer(_to, _value));
79   }
80 
81   function safeTransferFrom(
82     ERC20 _token,
83     address _from,
84     address _to,
85     uint256 _value
86   )
87     internal
88   {
89     require(_token.transferFrom(_from, _to, _value));
90   }
91 
92   function safeApprove(
93     ERC20 _token,
94     address _spender,
95     uint256 _value
96   )
97     internal
98   {
99     require(_token.approve(_spender, _value));
100   }
101 }
102 
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipRenounced(address indexed previousOwner);
108   event OwnershipTransferred(
109     address indexed previousOwner,
110     address indexed newOwner
111   );
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   constructor() public {
119     owner = msg.sender;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   /**
131    * @dev Allows the current owner to relinquish control of the contract.
132    * @notice Renouncing to ownership will leave the contract without an owner.
133    * It will not be possible to call the functions with the `onlyOwner`
134    * modifier anymore.
135    */
136   function renounceOwnership() public onlyOwner {
137     emit OwnershipRenounced(owner);
138     owner = address(0);
139   }
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param _newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address _newOwner) public onlyOwner {
146     _transferOwnership(_newOwner);
147   }
148 
149   /**
150    * @dev Transfers control of the contract to a newOwner.
151    * @param _newOwner The address to transfer ownership to.
152    */
153   function _transferOwnership(address _newOwner) internal {
154     require(_newOwner != address(0));
155     emit OwnershipTransferred(owner, _newOwner);
156     owner = _newOwner;
157 }
158 
159 }
160 
161 /**
162  * @title ERC20 interface
163  * @dev see https://github.com/ethereum/EIPs/issues/20
164  */
165 contract ERC20 {
166   function totalSupply() public view returns (uint256);
167 
168   function balanceOf(address _who) public view returns (uint256);
169 
170   function allowance(address _owner, address _spender)
171     public view returns (uint256);
172 
173   function transfer(address _to, uint256 _value) public returns (bool);
174 
175   function approve(address _spender, uint256 _value)
176     public returns (bool);
177 
178   function transferFrom(address _from, address _to, uint256 _value)
179     public returns (bool);
180 
181   event Transfer(
182     address indexed from,
183     address indexed to,
184     uint256 value
185   );
186 
187   event Approval(
188     address indexed owner,
189     address indexed spender,
190     uint256 value
191   );
192 }
193 
194 contract PercentRateProvider {}
195 contract PercentRateFeature is Ownable, PercentRateProvider {}
196 contract InvestedProvider is Ownable {}
197 contract WalletProvider is Ownable {}
198 contract RetrieveTokensFeature is Ownable {}
199 contract TokenProvider is Ownable {}
200 contract MintTokensInterface is TokenProvider {}
201 contract MintTokensFeature is MintTokensInterface {}
202 
203 contract CommonSale is PercentRateFeature, InvestedProvider, WalletProvider, RetrieveTokensFeature, MintTokensFeature {
204       function mintTokensExternal(address, uint) public;
205 }
206 
207 /**
208  * @title CrowdsaleWPTByRounds
209  * @dev This is an example of a fully fledged crowdsale.
210  * The way to add new features to a base crowdsale is by multiple inheritance.
211  * In this example we are providing following extensions:
212  * CappedCrowdsale - sets a max boundary for raised funds
213  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
214  *
215  * After adding multiple features it's good practice to run integration tests
216  * to ensure that subcontracts works together as intended.
217  */
218 // XXX There doesn't seem to be a way to split this line that keeps solium
219 // happy. See:
220 // https://github.com/duaraghav8/Solium/issues/205
221 // --elopio - 2018-05-10
222 // solium-disable-next-line max-len
223 contract CrowdsaleWPTByRounds is Ownable {
224   using SafeMath for uint256;
225   using SafeERC20 for ERC20;
226 
227   // The token being sold
228   ERC20 public token;
229 
230   // Address where funds are collected
231   address public wallet;
232 
233   // Address of tokens minter
234   CommonSale public minterContract;
235 
236   // How many token units a buyer gets per wei.
237   // The rate is the conversion between wei and the smallest and indivisible token unit.
238   uint256 public rate;
239 
240   // Amount of tokens raised
241   uint256 public tokensRaised;
242 
243   // Cap for current round
244   uint256 public cap;
245 
246   // Time ranges for current round
247   uint256 public openingTime;
248   uint256 public closingTime;
249 
250   //Minimal value of investment
251   uint public minInvestmentValue;
252 
253   /**
254    * @dev Allows the owner to set the minter contract.
255    * @param _minterAddr the minter address
256    */
257   function setMinter(address _minterAddr) public onlyOwner {
258     minterContract = CommonSale(_minterAddr);
259   }
260 
261   /**
262    * @dev Reverts if not in crowdsale time range.
263    */
264   modifier onlyWhileOpen {
265     // solium-disable-next-line security/no-block-members
266     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
267     _;
268   }
269 
270   /**
271    * Event for token purchase logging
272    * @param purchaser who paid for the tokens
273    * @param beneficiary who got the tokens
274    * @param value weis paid for purchase
275    * @param amount amount of tokens purchased
276    */
277   event TokenPurchase(
278     address indexed purchaser,
279     address indexed beneficiary,
280     uint256 value,
281     uint256 amount
282     );
283 
284 constructor () public {
285     rate = 400;//_rate;
286     wallet = 0xeA9cbceD36a092C596e9c18313536D0EEFacff46;
287     cap = 200000;
288     openingTime = 1534558186;
289     closingTime = 1535320800;
290 
291     minInvestmentValue = 0.02 ether;
292   }
293 
294    /**
295    * @dev Checks whether the cap has been reached.
296    * @return Whether the cap was reached
297    */
298   function capReached() public view returns (bool) {
299     return tokensRaised >= cap;
300   }
301 
302    /**
303    * @dev Correction of current rate.
304    */
305   function changeRate(uint256 newRate) public onlyOwner {
306     rate = newRate;
307   }
308 
309    /**
310    * @dev Close current round.
311    */
312   function closeRound() public onlyOwner {
313     closingTime = block.timestamp + 1;
314   }
315 
316    /**
317    * @dev Change minimal amount of investment.
318    */
319   function changeMinInvest(uint256 newMinValue) public onlyOwner {
320     rate = newMinValue;
321   }
322 
323    /**
324    * @dev Start new crowdsale round if already not started.
325    */
326   function startNewRound(uint256 _rate, address _wallet, ERC20 _token, uint256 _cap, uint256 _openingTime, uint256 _closingTime) payable public onlyOwner {
327     require(!hasOpened());
328     rate = _rate;
329     wallet = _wallet;
330     token = _token;
331     cap = _cap;
332     openingTime = _openingTime;
333     closingTime = _closingTime;
334   }
335 
336   /**
337    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
338    * @return Whether crowdsale period has elapsed
339    */
340   function hasClosed() public view returns (bool) {
341     // solium-disable-next-line security/no-block-members
342     return block.timestamp > closingTime;
343   }
344 
345   /**
346    * @dev Checks whether the period in which the crowdsale is open.
347    * @return Whether crowdsale period has opened
348    */
349   function hasOpened() public view returns (bool) {
350     // solium-disable-next-line security/no-block-members
351     return (openingTime < block.timestamp && block.timestamp < closingTime);
352   }
353 
354   // -----------------------------------------
355   // Crowdsale external interface
356   // -----------------------------------------
357 
358   /**
359    * @dev fallback function ***DO NOT OVERRIDE***
360    */
361   function () payable external {
362     buyTokens(msg.sender);
363   }
364 
365   /**
366    * @dev low level token purchase ***DO NOT OVERRIDE***
367    * @param _beneficiary Address performing the token purchase
368    */
369   function buyTokens(address _beneficiary) payable public{
370 
371     uint256 weiAmount = msg.value;
372     _preValidatePurchase(_beneficiary, weiAmount);
373 
374     // calculate token amount to be created
375     uint256 tokens = _getTokenAmount(weiAmount);
376 
377     // update state
378     tokensRaised = tokensRaised.add(tokens);
379 
380     minterContract.mintTokensExternal(_beneficiary, tokens);
381     
382     emit TokenPurchase(
383       msg.sender,
384       _beneficiary,
385       weiAmount,
386       tokens
387     );
388 
389     _forwardFunds();
390   }
391 
392   /**
393    * @dev Extend parent behavior requiring purchase to respect the funding cap.
394    * @param _beneficiary Token purchaser
395    * @param _weiAmount Amount of wei contributed
396    */
397   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
398   internal
399   view
400   onlyWhileOpen
401   {
402     require(_beneficiary != address(0));
403     require(_weiAmount != 0 && _weiAmount > minInvestmentValue);
404     require(tokensRaised.add(_getTokenAmount(_weiAmount)) <= cap);
405   }
406 
407   /**
408    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
409    * @param _beneficiary Address performing the token purchase
410    * @param _tokenAmount Number of tokens to be emitted
411    */
412   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
413     token.safeTransfer(_beneficiary, _tokenAmount);
414   }
415 
416   /**
417    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
418    * @param _beneficiary Address receiving the tokens
419    * @param _tokenAmount Number of tokens to be purchased
420    */
421   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
422     _deliverTokens(_beneficiary, _tokenAmount);
423   }
424 
425   /**
426    * @dev Override to extend the way in which ether is converted to tokens.
427    * @param _weiAmount Value in wei to be converted into tokens
428    * @return Number of tokens that can be purchased with the specified _weiAmount
429    */
430   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
431     return _weiAmount.mul(rate);
432   }
433 
434   /**
435    * @dev Determines how ETH is stored/forwarded on purchases.
436    */
437   function _forwardFunds() internal {
438     wallet.transfer(msg.value);
439   }
440 }