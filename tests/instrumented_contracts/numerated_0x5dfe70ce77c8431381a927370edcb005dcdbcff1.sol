1 pragma solidity 0.4.25;
2 
3 contract TokenConfig {
4   string public constant NAME = "MANGO";
5   string public constant SYMBOL = "MAO";
6   uint8 public constant DECIMALS = 5;
7   uint public constant DECIMALSFACTOR = 10 ** uint(DECIMALS);
8   uint public constant TOTALSUPPLY = 10000000000 * DECIMALSFACTOR;
9 }
10 
11 interface IERC20 {
12   function totalSupply() external view returns (uint256);
13 
14   function balanceOf(address who) external view returns (uint256);
15 
16   function allowance(address owner, address spender)
17     external view returns (uint256);
18 
19   function transfer(address to, uint256 value) external returns (bool);
20 
21   function approve(address spender, uint256 value)
22     external returns (bool);
23 
24   function transferFrom(address from, address to, uint256 value)
25     external returns (bool);
26 
27   event Transfer(
28     address indexed from,
29     address indexed to,
30     uint256 value
31   );
32 
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45   /**
46   * @dev Multiplies two numbers, reverts on overflow.
47   */
48   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50     // benefit is lost if 'b' is also tested.
51     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52     if (a == 0) {
53       return 0;
54     }
55 
56     uint256 c = a * b;
57     require(c / a == b, "can't mul");
58 
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // Solidity only automatically asserts when dividing by 0
67     require(b > 0, "can't sub with zero.");
68 
69     uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72     return c;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     require(b <= a, "can't sub");
80     uint256 c = a - b;
81 
82     return c;
83   }
84 
85   /**
86   * @dev Adds two numbers, reverts on overflow.
87   */
88   function add(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a + b;
90     require(c >= a, "add overflow");
91 
92     return c;
93   }
94 
95   /**
96   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
97   * reverts when dividing by zero.
98   */
99   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100     require(b != 0, "can't mod with zero");
101     return a % b;
102   }
103 }
104 
105 library SafeERC20 {
106   using SafeMath for uint256;
107 
108   function safeTransfer(IERC20 token, address to, uint256 value) internal {
109     require(token.transfer(to, value), "safeTransfer");
110   }
111 
112   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
113     require(token.transferFrom(from, to, value), "safeTransferFrom");
114   }
115 
116   function safeApprove(IERC20 token, address spender, uint256 value) internal {
117     // safeApprove should only be called when setting an initial allowance,
118     // or when resetting it to zero. To increase and decrease it, use
119     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
120     require((value == 0) || (token.allowance(msg.sender, spender) == 0), "safeApprove");
121     require(token.approve(spender, value), "safeApprove");
122   }
123 
124   function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
125     uint256 newAllowance = token.allowance(address(this), spender).add(value);
126     require(token.approve(spender, newAllowance), "safeIncreaseAllowance");
127   }
128 
129   function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
130     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
131     require(token.approve(spender, newAllowance), "safeDecreaseAllowance");
132   }
133 }
134 
135 /**
136  * @title Helps contracts guard against reentrancy attacks.
137  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
138  * @dev If you mark a function `nonReentrant`, you should also
139  * mark it `external`.
140  */
141 contract ReentrancyGuard {
142   /// @dev counter to allow mutex lock with only one SSTORE operation
143   uint256 private _guardCounter;
144 
145   constructor () internal {
146     // The counter starts at one to prevent changing it from zero to a non-zero
147     // value, which is a more expensive operation.
148     _guardCounter = 1;
149   }
150 
151   /**
152     * @dev Prevents a contract from calling itself, directly or indirectly.
153     * Calling a `nonReentrant` function from another `nonReentrant`
154     * function is not supported. It is possible to prevent this from happening
155     * by making the `nonReentrant` function external, and make it call a
156     * `private` function that does the actual work.
157     */
158   modifier nonReentrant() {
159     _guardCounter += 1;
160     uint256 localCounter = _guardCounter;
161     _;
162     require(localCounter == _guardCounter, "nonReentrant.");
163   }
164 }
165 
166 /**
167  * @title Ownable
168  * @dev The Ownable contract has an owner address, and provides basic authorization control
169  * functions, this simplifies the implementation of "user permissions".
170  */
171 contract Ownable {
172   address public owner;
173 
174   event OwnershipTransferred(
175     address indexed previousOwner,
176     address indexed newOwner
177   );
178 
179   /**
180    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
181    * account.
182    */
183   constructor() public {
184     owner = msg.sender;
185   }
186 
187   /**
188    * @dev Throws if called by any account other than the owner.
189    */
190   modifier onlyOwner() {
191     require(msg.sender == owner, "only for owner.");
192     _;
193   }
194 
195   /**
196    * @dev Allows the current owner to transfer control of the contract to a newOwner.
197    * @param newOwner The address to transfer ownership to.
198    */
199   function transferOwnership(address newOwner) public onlyOwner {
200     require(newOwner != address(0), "address is zero.");
201     emit OwnershipTransferred(owner, newOwner);
202     owner = newOwner;
203   }
204 }
205 
206 /**
207  * @title Pausable
208  * @dev Base contract which allows children to implement an emergency stop mechanism.
209  */
210 contract Pausable is Ownable {
211   event Pause();
212   event Unpause();
213 
214   bool public paused = false;
215 
216   /**
217    * @dev Modifier to make a function callable only when the contract is not paused.
218    */
219   modifier whenNotPaused() {
220     require(!paused, "paused.");
221     _;
222   }
223 
224   /**
225    * @dev Modifier to make a function callable only when the contract is paused.
226    */
227   modifier whenPaused() {
228     require(paused, "Not paused.");
229     _;
230   }
231 
232   /**
233    * @dev called by the owner to pause, triggers stopped state
234    */
235   function pause() public onlyOwner whenNotPaused {
236     paused = true;
237     emit Pause();
238   }
239 
240   /**
241    * @dev called by the owner to unpause, returns to normal state
242    */
243   function unpause() public onlyOwner whenPaused {
244     paused = false;
245     emit Unpause();
246   }
247 }
248 
249 
250 /**
251  * @title Whitelist
252  */
253 contract Whitelist is Ownable {
254   event EnableWhitelist();
255   event DisableWhitelist();
256   event AddWhiteListed(address addr);
257   event RemoveWhiteListed(address addr);
258 
259   bool private _whitelistEnable = false;
260 
261   mapping (address => bool) private _whitelist;
262 
263    /**
264    * @dev add addresses to the whitelist
265    * @param addrs addresses
266    * @return true if at least one address was added to the whitelist,
267    * false if all addresses were already in the whitelist
268    */
269   function addWhiteListAddr(address[] addrs)
270     public
271     onlyOwner
272   {
273     uint256 len = addrs.length;
274     for (uint256 i = 0; i < len; i++) {
275       _addAddressToWhitelist(addrs[i]);
276     }
277   }
278 
279   /**
280    * @dev remove an address from the whitelist
281    * @param addr address
282    * @return true if the address was removed from the whitelist,
283    * false if the address wasn't in the whitelist in the first place
284    */
285   function removeWhiteListAddr(address addr)
286     public
287     onlyOwner
288   {
289     require(addr != address(0), "address is zero");
290     _whitelist[addr] = false;
291     emit RemoveWhiteListed(addr);
292   }
293 
294   function whitelistEnabled() public view returns(bool) {
295     return _whitelistEnable;
296   }
297 
298   function enableWhitelist() public onlyOwner {
299     _whitelistEnable = true;
300     emit EnableWhitelist();
301   }
302 
303   function disableWhitelist() public onlyOwner {
304     _whitelistEnable = true;
305     emit DisableWhitelist();
306   }
307 
308   modifier onlyAuthorised(address beneficiary) {
309     require(_isWhiteListAddr(beneficiary),"Not authorised");
310     _;
311   }
312 
313   /**
314    * @dev add an address to the whitelist
315    * @param addr address
316    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
317    */
318   function _addAddressToWhitelist(address addr)
319     internal
320     onlyOwner
321   {
322     require(addr != address(0), "address is zero");
323     _whitelist[addr] = true;
324     emit AddWhiteListed(addr);
325   }
326 
327   /**
328    * @dev getter to determine if address is in whitelist
329    */
330   function _isWhiteListAddr(address addr)
331     internal
332     view
333     returns (bool)
334   {
335     require(addr != address(0), "address is zero");
336 
337     if (whitelistEnabled()) {
338       return _whitelist[addr];
339     }
340     // if white list disabled, this function always returns 'true'.
341     return true;
342   }
343 }
344 
345 /**
346  * @title Crowdsale
347  * @dev Crowdsale is a base contract for managing a token crowdsale,
348  * allowing investors to purchase tokens with ether. This contract implements
349  * such functionality in its most fundamental form and can be extended to provide additional
350  * functionality and/or custom behavior.
351  * The external interface represents the basic interface for purchasing tokens, and conform
352  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
353  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
354  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
355  * behavior.
356  */
357 contract Crowdsale is TokenConfig, Pausable, ReentrancyGuard, Whitelist {
358   using SafeMath for uint256;
359   using SafeERC20 for IERC20;
360 
361   // The token being sold
362   IERC20 private _token;
363 
364   // Address where funds are collected
365   address private _wallet;
366 
367   // Address where funds are collected
368   address private _tokenholder;
369 
370   // How many token units a buyer gets per wei.
371   // The rate is the conversion between wei and the smallest and indivisible token unit.
372   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
373   // 1 wei will give you 1 unit, or 0.001 TOK.
374   uint256 private _rate;
375 
376   // Amount of contribution wei raised
377   uint256 private _weiRaised;
378 
379   // Amount of token sold
380   uint256 private _tokenSoldAmount;
381 
382   // Minimum contribution amount of fund
383   uint256 private _minWeiAmount;
384 
385   // balances of user should be sent
386   mapping (address => uint256) private _tokenBalances;
387 
388   // balances of user fund
389   mapping (address => uint256) private _weiBalances;
390 
391   // ICO period timestamp
392   uint256 private _openingTime;
393   uint256 private _closingTime;
394 
395   // Amount of token hardcap
396   uint256 private _hardcap;
397 
398   /**
399    * Event for token purchase logging
400    * @param purchaser who paid for the tokens
401    * @param beneficiary who got the tokens
402    * @param value weis paid for purchase
403    * @param amount amount of tokens purchased
404    */
405   event TokensPurchased(
406     address indexed purchaser,
407     address indexed beneficiary,
408     uint256 value,
409     uint256 amount
410   );
411   event TokensDelivered(address indexed beneficiary, uint256 amount);
412   event RateChanged(uint256 rate);
413   event MinWeiChanged(uint256 minWei);
414   event PeriodChanged(uint256 open, uint256 close);
415 
416   constructor(
417     uint256 rate,
418     uint256 minWeiAmount,
419     address wallet,
420     address tokenholder,
421     IERC20 token,
422     uint256 hardcap,
423     uint256 openingTime,
424     uint256 closingTime
425   ) public {
426     require(rate > 0, "Rate is lower than zero.");
427     require(wallet != address(0), "Wallet address is zero");
428     require(tokenholder != address(0), "Tokenholder address is zero");
429     require(token != address(0), "Token address is zero");
430 
431     _minWeiAmount = minWeiAmount;
432     _rate = rate;
433     _wallet = wallet;
434     _tokenholder = tokenholder;
435     _token = token;
436     _hardcap = hardcap;
437     _openingTime = openingTime;
438     _closingTime = closingTime;
439   }
440 
441   // -----------------------------------------
442   // Crowdsale external interface
443   // -----------------------------------------
444 
445   /**
446    * @dev fallback function ***DO NOT OVERRIDE***
447    * Note that other contracts will transfer fund with a base gas stipend
448    * of 2300, which is not enough to call buyTokens. Consider calling
449    * buyTokens directly when purchasing tokens from a contract.
450    */
451   function () external payable {
452     buyTokens(msg.sender);
453   }
454 
455   /**
456    * @return the token being sold.
457    */
458   function token() public view returns(IERC20) {
459     return _token;
460   }
461 
462   /**
463    * @return token hardcap.
464    */
465   function hardcap() public view returns(uint256) {
466     return _hardcap;
467   }
468 
469   /**
470    * @return the address where funds are collected.
471    */
472   function wallet() public view returns(address) {
473     return _wallet;
474   }
475 
476   /**
477    * @return the number of token units a buyer gets per wei.
478    */
479   function rate() public view returns(uint256) {
480     return _rate;
481   }
482 
483   /**
484    * @return the amount of wei raised.
485    */
486   function weiRaised() public view returns (uint256) {
487     return _weiRaised;
488   }
489 
490   /**
491    * @return ICO opening time.
492    */
493   function openingTime() public view returns (uint256) {
494     return _openingTime;
495   }
496 
497   /**
498    * @return ICO closing time.
499    */
500   function closingTime() public view returns (uint256) {
501     return _closingTime;
502   }
503 
504   /**
505    * @return the amount of token raised.
506    */
507   function tokenSoldAmount() public view returns (uint256) {
508     return _tokenSoldAmount;
509   }
510 
511   /**
512    * @return the number of minimum amount buyer can fund.
513    */
514   function minWeiAmount() public view returns(uint256) {
515     return _minWeiAmount;
516   }
517 
518   /**
519    * @return is ICO period
520    */
521   function isOpen() public view returns (bool) {
522      // solium-disable-next-line security/no-block-members
523     return now >= _openingTime && now <= _closingTime;
524   }
525 
526   /**
527   * @dev Gets the token balance of the specified address for deliver
528   * @param owner The address to query the balance of.
529   * @return An uint256 representing the amount owned by the passed address.
530   */
531   function tokenBalanceOf(address owner) public view returns (uint256) {
532     return _tokenBalances[owner];
533   }
534 
535   /**
536   * @dev Gets the ETH balance of the specified address.
537   * @param owner The address to query the balance of.
538   * @return An uint256 representing the amount owned by the passed address.
539   */
540   function weiBalanceOf(address owner) public view returns (uint256) {
541     return _weiBalances[owner];
542   }
543 
544   function setRate(uint256 value) public onlyOwner {
545     _rate = value;
546     emit RateChanged(value);
547   }
548 
549   function setMinWeiAmount(uint256 value) public onlyOwner {
550     _minWeiAmount = value;
551     emit MinWeiChanged(value);
552   }
553 
554   function setPeriodTimestamp(uint256 open, uint256 close) public onlyOwner {
555     _openingTime = open;
556     _closingTime = close;
557     emit PeriodChanged(open, close);
558   }
559 
560   /**
561    * @dev low level token purchase ***DO NOT OVERRIDE***
562    * This function has a non-reentrancy guard, so it shouldn't be called by
563    * another `nonReentrant` function.
564    * @param beneficiary Recipient of the token purchase
565    */
566   function buyTokens(address beneficiary)
567     public
568     nonReentrant
569     whenNotPaused
570     payable
571   {
572     uint256 weiAmount = msg.value;
573     _preValidatePurchase(beneficiary, weiAmount);
574 
575     // Calculate token amount to be created
576     uint256 tokens = _getTokenAmount(weiAmount);
577 
578     require(_hardcap > _tokenSoldAmount.add(tokens), "Over hardcap");
579 
580     // Update state
581     _weiRaised = _weiRaised.add(weiAmount);
582     _tokenSoldAmount = _tokenSoldAmount.add(tokens);
583 
584     _weiBalances[beneficiary] = _weiBalances[beneficiary].add(weiAmount);
585     _tokenBalances[beneficiary] = _tokenBalances[beneficiary].add(tokens);
586 
587     emit TokensPurchased(
588       msg.sender,
589       beneficiary,
590       weiAmount,
591       tokens
592     );
593 
594     _forwardFunds();
595   }
596 
597   /**
598    * @dev method that deliver token to user
599    */
600   function deliverTokens(address user) public onlyOwner{
601     uint256 tokenAmount = _tokenBalances[user];
602     _deliverTokens(user, tokenAmount);
603     _tokenBalances[user] = 0;
604     emit TokensDelivered(user, tokenAmount);
605   }
606 
607   // -----------------------------------------
608   // Internal interface (extensible)
609   // -----------------------------------------
610 
611   /**
612    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
613    * @param beneficiary Address performing the token purchase
614    * @param weiAmount Value in wei involved in the purchase
615    */
616   function _preValidatePurchase(
617     address beneficiary,
618     uint256 weiAmount
619   )
620     internal
621     view
622     onlyAuthorised(beneficiary)
623   {
624     require(weiAmount != 0, "Zero ETH");
625     require(weiAmount >= _minWeiAmount, "Must be equal or higher than minimum");
626     require(beneficiary != address(0), "Beneficiary address is zero");
627     require(isOpen(), "Sales is close");
628   }
629 
630   /**
631    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
632    * @param beneficiary Address performing the token purchase
633    * @param tokenAmount Number of tokens to be emitted
634    */
635   function _deliverTokens(
636     address beneficiary,
637     uint256 tokenAmount
638   )
639     internal
640   {
641     _token.safeTransferFrom(_tokenholder, beneficiary, tokenAmount);
642   }
643 
644   /**
645    * @dev Override to extend the way in which ether is converted to tokens.
646    * @param weiAmount Value in wei to be converted into tokens
647    * @return Number of tokens that can be purchased with the specified _weiAmount
648    */
649   function _getTokenAmount(uint256 weiAmount) internal view returns (uint256)
650   {
651     uint ethDecimals = 18;
652     require(DECIMALS <= ethDecimals, "");
653 
654     uint256 covertedTokens = weiAmount;
655     if (DECIMALS != ethDecimals) {
656       covertedTokens = weiAmount.div((10 ** uint256(ethDecimals - DECIMALS)));
657     }
658     return covertedTokens.mul(_rate);
659   }
660 
661   /**
662     * @dev Determines how ETH is stored/forwarded on purchases.
663     */
664   function _forwardFunds() internal {
665     _wallet.transfer(msg.value);
666   }
667 }