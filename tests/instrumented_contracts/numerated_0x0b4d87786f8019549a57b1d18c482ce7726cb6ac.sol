1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 /**
113  * @title Helps contracts guard agains reentrancy attacks.
114  * @author Remco Bloemen <remco@2π.com>
115  * @notice If you mark a function `nonReentrant`, you should also
116  * mark it `external`.
117  */
118 contract ReentrancyGuard {
119 
120   /**
121    * @dev We use a single lock for the whole contract.
122    */
123   bool private reentrancyLock = false;
124 
125   /**
126    * @dev Prevents a contract from calling itself, directly or indirectly.
127    * @notice If you mark a function `nonReentrant`, you should also
128    * mark it `external`. Calling one nonReentrant function from
129    * another is not supported. Instead, you can implement a
130    * `private` function doing the actual work, and a `external`
131    * wrapper marked as `nonReentrant`.
132    */
133   modifier nonReentrant() {
134     require(!reentrancyLock);
135     reentrancyLock = true;
136     _;
137     reentrancyLock = false;
138   }
139 
140 }
141 
142 /**
143  * @title ERC20Basic
144  * @dev Simpler version of ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/179
146  */
147 contract ERC20Basic {
148   function totalSupply() public view returns (uint256);
149   function balanceOf(address who) public view returns (uint256);
150   function transfer(address to, uint256 value) public returns (bool);
151   event Transfer(address indexed from, address indexed to, uint256 value);
152 }
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 contract ERC20 is ERC20Basic {
159   function allowance(address owner, address spender)
160     public view returns (uint256);
161 
162   function transferFrom(address from, address to, uint256 value)
163     public returns (bool);
164 
165   function approve(address spender, uint256 value) public returns (bool);
166   event Approval(
167     address indexed owner,
168     address indexed spender,
169     uint256 value
170   );
171 }
172 
173 contract BablosTokenInterface is ERC20 {
174   bool public frozen;
175   function burn(uint256 _value) public;
176   function setSale(address _sale) public;
177   function thaw() external;
178 }
179 
180 contract PriceUpdaterInterface {
181   enum Currency { ETH, BTC, WME, WMZ, WMR, WMX }
182 
183   uint public decimalPrecision = 3;
184 
185   mapping(uint => uint) public price;
186 }
187 
188 contract BablosCrowdsaleWalletInterface {
189   enum State {
190     // gathering funds
191     GATHERING,
192     // returning funds to investors
193     REFUNDING,
194     // funds can be pulled by owners
195     SUCCEEDED
196   }
197 
198   event StateChanged(State state);
199   event Invested(address indexed investor, PriceUpdaterInterface.Currency currency, uint amount, uint tokensReceived);
200   event EtherWithdrawan(address indexed to, uint value);
201   event RefundSent(address indexed to, uint value);
202   event ControllerRetired(address was);
203 
204   /// @dev price updater interface
205   PriceUpdaterInterface public priceUpdater;
206 
207   /// @notice total amount of investments in currencies
208   mapping(uint => uint) public totalInvested;
209 
210   /// @notice state of the registry
211   State public state = State.GATHERING;
212 
213   /// @dev balances of investors in wei
214   mapping(address => uint) public weiBalances;
215 
216   /// @dev balances of tokens sold to investors
217   mapping(address => uint) public tokenBalances;
218 
219   /// @dev list of unique investors
220   address[] public investors;
221 
222   /// @dev token accepted for refunds
223   BablosTokenInterface public token;
224 
225   /// @dev operations will be controlled by this address
226   address public controller;
227 
228   /// @dev the team's tokens percent
229   uint public teamPercent;
230 
231   /// @dev tokens sent to initial PR - they will be substracted, when tokens will be burn
232   uint public prTokens;
233   
234   /// @dev performs only allowed state transitions
235   function changeState(State _newState) external;
236 
237   /// @dev records an investment
238   /// @param _investor who invested
239   /// @param _tokenAmount the amount of token bought, calculation is handled by ICO
240   /// @param _currency the currency in which investor invested
241   /// @param _amount the invested amount
242   function invested(address _investor, uint _tokenAmount, PriceUpdaterInterface.Currency _currency, uint _amount) external payable;
243 
244   /// @dev get total invested in ETH
245   function getTotalInvestedEther() external view returns (uint);
246 
247   /// @dev get total invested in EUR
248   function getTotalInvestedEur() external view returns (uint);
249 
250   /// @notice withdraw `_value` of ether to his address, can be called if crowdsale succeeded
251   /// @param _value amount of wei to withdraw
252   function withdrawEther(uint _value) external;
253 
254   /// @notice owner: send `_value` of tokens to his address, can be called if
255   /// crowdsale failed and some of the investors refunded the ether
256   /// @param _value amount of token-wei to send
257   function withdrawTokens(uint _value) external;
258 
259   /// @notice withdraw accumulated balance, called by payee in case crowdsale failed
260   /// @dev caller should approve tokens bought during ICO to this contract
261   function withdrawPayments() external;
262 
263   /// @dev returns investors count
264   function getInvestorsCount() external view returns (uint);
265 
266   /// @dev ability for controller to step down
267   function detachController() external;
268 
269   /// @dev unhold holded team's tokens
270   function unholdTeamTokens() external;
271 }
272 
273 contract BablosCrowdsale is ReentrancyGuard, Ownable {
274   using SafeMath for uint;
275 
276   enum SaleState { INIT, ACTIVE, PAUSED, SOFT_CAP_REACHED, FAILED, SUCCEEDED }
277 
278   SaleState public state = SaleState.INIT;
279 
280   // The token being sold
281   BablosTokenInterface public token;
282 
283   // Address where funds are collected
284   BablosCrowdsaleWalletInterface public wallet;
285 
286   // How many tokens per 1 ether
287   uint public rate;
288 
289   uint public openingTime;
290   uint public closingTime;
291 
292   uint public tokensSold;
293   uint public tokensSoldExternal;
294 
295   uint public softCap;
296   uint public hardCap;
297   uint public minimumAmount;
298 
299   address public controller;
300   PriceUpdaterInterface public priceUpdater;
301 
302   /**
303    * Event for token purchase logging
304    * @param purchaser who paid for the tokens
305    * @param beneficiary who got the tokens
306    * @param currency of paid value
307    * @param value paid for purchase
308    * @param amount amount of tokens purchased
309    */
310   event TokenPurchase(
311     address indexed purchaser,
312     address indexed beneficiary,
313     uint currency,
314     uint value,
315     uint amount
316   );
317 
318   event StateChanged(SaleState _state);
319   event FundTransfer(address _backer, uint _amount);
320 
321   // MODIFIERS
322 
323   modifier requiresState(SaleState _state) {
324     require(state == _state);
325     _;
326   }
327 
328   modifier onlyController() {
329     require(msg.sender == controller);
330     _;
331   }
332 
333   /// @dev triggers some state changes based on current time
334   /// @param _client optional refund parameter
335   /// @param _payment optional refund parameter
336   /// @param _currency currency
337   /// note: function body could be skipped!
338   modifier timedStateChange(address _client, uint _payment, PriceUpdaterInterface.Currency _currency) {
339     if (SaleState.INIT == state && getTime() >= openingTime) {
340       changeState(SaleState.ACTIVE);
341     }
342 
343     if ((state == SaleState.ACTIVE || state == SaleState.SOFT_CAP_REACHED) && getTime() >= closingTime) {
344       finishSale();
345 
346       if (_currency == PriceUpdaterInterface.Currency.ETH && _payment > 0) {
347         _client.transfer(_payment);
348       }
349     } else {
350       _;
351     }
352   }
353 
354   constructor(
355     uint _rate, 
356     BablosTokenInterface _token,
357     uint _openingTime, 
358     uint _closingTime, 
359     uint _softCap,
360     uint _hardCap,
361     uint _minimumAmount) 
362     public
363   {
364     require(_rate > 0);
365     require(_token != address(0));
366     require(_openingTime >= getTime());
367     require(_closingTime > _openingTime);
368     require(_softCap > 0);
369     require(_hardCap > 0);
370 
371     rate = _rate;
372     token = _token;
373     openingTime = _openingTime;
374     closingTime = _closingTime;
375     softCap = _softCap;
376     hardCap = _hardCap;
377     minimumAmount = _minimumAmount;
378   }
379 
380   function setWallet(BablosCrowdsaleWalletInterface _wallet) external onlyOwner {
381     require(_wallet != address(0));
382     wallet = _wallet;
383   }
384 
385   function setController(address _controller) external onlyOwner {
386     require(_controller != address(0));
387     controller = _controller;
388   }
389 
390   function setPriceUpdater(PriceUpdaterInterface _priceUpdater) external onlyOwner {
391     require(_priceUpdater != address(0));
392     priceUpdater = _priceUpdater;
393   }
394 
395   function isActive() public view returns (bool active) {
396     return state == SaleState.ACTIVE || state == SaleState.SOFT_CAP_REACHED;
397   }
398 
399   /**
400    * @dev fallback function
401    */
402   function () external payable {
403     require(msg.data.length == 0);
404     buyTokens(msg.sender);
405   }
406 
407   /**
408    * @dev token purchase
409    * @param _beneficiary Address performing the token purchase
410    */
411   function buyTokens(address _beneficiary) public payable {
412     uint weiAmount = msg.value;
413 
414     require(_beneficiary != address(0));
415     require(weiAmount != 0);
416 
417     // calculate token amount to be created
418     uint tokens = _getTokenAmount(weiAmount);
419 
420     require(tokens >= minimumAmount && token.balanceOf(address(this)) >= tokens);
421 
422     _internalBuy(_beneficiary, PriceUpdaterInterface.Currency.ETH, weiAmount, tokens);
423   }
424 
425   /**
426    * @dev external token purchase (BTC and WebMoney). Only allowed for merchant controller
427    * @param _beneficiary Address performing the token purchase
428    * @param _tokens Quantity of purchased tokens
429    */
430   function externalBuyToken(
431     address _beneficiary, 
432     PriceUpdaterInterface.Currency _currency, 
433     uint _amount, 
434     uint _tokens)
435       external
436       onlyController
437   {
438     require(_beneficiary != address(0));
439     require(_tokens >= minimumAmount && token.balanceOf(address(this)) >= _tokens);
440     require(_amount != 0);
441 
442     _internalBuy(_beneficiary, _currency, _amount, _tokens);
443   }
444 
445   /**
446    * @dev Override to extend the way in which ether is converted to tokens.
447    * @param _weiAmount Value in wei to be converted into tokens
448    * @return Number of tokens that can be purchased with the specified _weiAmount
449    */
450   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
451     return _weiAmount.mul(rate).div(1 ether);
452   }
453 
454   function _internalBuy(
455     address _beneficiary, 
456     PriceUpdaterInterface.Currency _currency, 
457     uint _amount, 
458     uint _tokens)
459       internal
460       nonReentrant
461       timedStateChange(_beneficiary, _amount, _currency)
462   {
463     require(isActive());
464     if (_currency == PriceUpdaterInterface.Currency.ETH) {
465       tokensSold = tokensSold.add(_tokens);
466     } else {
467       tokensSoldExternal = tokensSoldExternal.add(_tokens);
468     }
469     token.transfer(_beneficiary, _tokens);
470 
471     emit TokenPurchase(
472       msg.sender,
473       _beneficiary,
474       uint(_currency),
475       _amount,
476       _tokens
477     );
478 
479     if (_currency == PriceUpdaterInterface.Currency.ETH) {
480       wallet.invested.value(_amount)(_beneficiary, _tokens, _currency, _amount);
481       emit FundTransfer(_beneficiary, _amount);
482     } else {
483       wallet.invested(_beneficiary, _tokens, _currency, _amount);
484     }
485     
486     // check if soft cap reached
487     if (state == SaleState.ACTIVE && wallet.getTotalInvestedEther() >= softCap) {
488       changeState(SaleState.SOFT_CAP_REACHED);
489     }
490 
491     // check if all tokens are sold
492     if (token.balanceOf(address(this)) < minimumAmount) {
493       finishSale();
494     }
495 
496     // check if hard cap reached
497     if (state == SaleState.SOFT_CAP_REACHED && wallet.getTotalInvestedEur() >= hardCap) {
498       finishSale();
499     }
500   }
501 
502   function finishSale() private {
503     if (wallet.getTotalInvestedEther() < softCap) {
504       changeState(SaleState.FAILED);
505     } else {
506       changeState(SaleState.SUCCEEDED);
507     }
508   }
509 
510   /// @dev performs only allowed state transitions
511   function changeState(SaleState _newState) private {
512     require(state != _newState);
513 
514     if (SaleState.INIT == state) {
515       assert(SaleState.ACTIVE == _newState);
516     } else if (SaleState.ACTIVE == state) {
517       assert(
518         SaleState.PAUSED == _newState ||
519         SaleState.SOFT_CAP_REACHED == _newState ||
520         SaleState.FAILED == _newState ||
521         SaleState.SUCCEEDED == _newState
522       );
523     } else if (SaleState.SOFT_CAP_REACHED == state) {
524       assert(
525         SaleState.PAUSED == _newState ||
526         SaleState.SUCCEEDED == _newState
527       );
528     } else if (SaleState.PAUSED == state) {
529       assert(SaleState.ACTIVE == _newState || SaleState.FAILED == _newState);
530     } else {
531       assert(false);
532     }
533 
534     state = _newState;
535     emit StateChanged(state);
536 
537     if (SaleState.SOFT_CAP_REACHED == state) {
538       onSoftCapReached();
539     } else if (SaleState.SUCCEEDED == state) {
540       onSuccess();
541     } else if (SaleState.FAILED == state) {
542       onFailure();
543     }
544   }
545 
546   function onSoftCapReached() private {
547     wallet.changeState(BablosCrowdsaleWalletInterface.State.SUCCEEDED);
548   }
549 
550   function onSuccess() private {
551     // burn all remaining tokens
552     token.burn(token.balanceOf(address(this)));
553     token.thaw();
554     wallet.unholdTeamTokens();
555     wallet.detachController();
556   }
557 
558   function onFailure() private {
559     // allow clients to get their ether back
560     wallet.changeState(BablosCrowdsaleWalletInterface.State.REFUNDING);
561     wallet.unholdTeamTokens();
562     wallet.detachController();
563   }
564 
565   /// @dev to be overridden in tests
566   function getTime() internal view returns (uint) {
567     // solium-disable-next-line security/no-block-members
568     return now;
569   }
570 
571 }