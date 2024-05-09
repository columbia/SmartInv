1 pragma solidity 0.4.25;
2 
3 contract TokenConfig {
4   string public constant NAME = "MANGO";
5   string public constant SYMBOL = "MANG";
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
201     owner = newOwner;
202     emit OwnershipTransferred(owner, newOwner);
203   }
204 }
205 
206 /**
207  * @title Pausable
208  * @dev Base contract which allows children to implement an emergency stop mechanism.
209  */
210 contract Pausable is Ownable {
211   event Paused(address account);
212   event Unpaused(address account);
213 
214   bool private _paused;
215 
216   constructor() internal {
217     _paused = false;
218   }
219 
220   /**
221    * @return true if the contract is paused, false otherwise.
222    */
223   function paused() public view returns(bool) {
224     return _paused;
225   }
226 
227   /**
228    * @dev Modifier to make a function callable only when the contract is not paused.
229    */
230   modifier whenNotPaused() {
231     require(!_paused, "paused.");
232     _;
233   }
234 
235   /**
236    * @dev Modifier to make a function callable only when the contract is paused.
237    */
238   modifier whenPaused() {
239     require(_paused, "Not paused.");
240     _;
241   }
242 
243   /**
244    * @dev called by the owner to pause, triggers stopped state
245    */
246   function pause() public onlyOwner whenNotPaused {
247     _paused = true;
248     emit Paused(msg.sender);
249   }
250 
251   /**
252    * @dev called by the owner to unpause, returns to normal state
253    */
254   function unpause() public onlyOwner whenPaused {
255     _paused = false;
256     emit Unpaused(msg.sender);
257   }
258 }
259 
260 /**
261  * @title Crowdsale white list address
262  */
263 contract Whitelist is Ownable {
264   event WhitelistAdded(address addr);
265   event WhitelistRemoved(address addr);
266 
267   mapping (address => bool) private _whitelist;
268 
269   /**
270    * @dev add addresses to the whitelist
271    * @param addrs addresses
272    */
273   function addWhiteListAddr(address[] addrs)
274     public
275   {
276     uint256 len = addrs.length;
277     for (uint256 i = 0; i < len; i++) {
278       _addAddressToWhitelist(addrs[i]);
279     }
280   }
281 
282   /**
283    * @dev remove an address from the whitelist
284    * @param addr address
285    */
286   function removeWhiteListAddr(address addr)
287     public
288   {
289     _removeAddressToWhitelist(addr);
290   }
291 
292   /**
293    * @dev getter to determine if address is in whitelist
294    */
295   function isWhiteListAddr(address addr)
296     public
297     view
298     returns (bool)
299   {
300     require(addr != address(0), "address is zero");
301     return _whitelist[addr];
302   }
303 
304   modifier onlyAuthorised(address beneficiary) {
305     require(isWhiteListAddr(beneficiary),"Not authorised");
306     _;
307   }
308 
309   /**
310    * @dev add an address to the whitelist
311    * @param addr address
312    */
313   function _addAddressToWhitelist(address addr)
314     internal
315     onlyOwner
316   {
317     require(addr != address(0), "address is zero");
318     _whitelist[addr] = true;
319     emit WhitelistAdded(addr);
320   }
321 
322     /**
323    * @dev remove an address from the whitelist
324    * @param addr address
325    */
326   function _removeAddressToWhitelist(address addr)
327     internal
328     onlyOwner
329   {
330     require(addr != address(0), "address is zero");
331     _whitelist[addr] = false;
332     emit WhitelistRemoved(addr);
333   }
334 }
335 
336 /**
337  * @title Crowdsale
338  * @dev Crowdsale is a base contract for managing a token crowdsale,
339  * allowing investors to purchase tokens with ether. This contract implements
340  * such functionality in its most fundamental form and can be extended to provide additional
341  * functionality and/or custom behavior.
342  * The external interface represents the basic interface for purchasing tokens, and conform
343  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
344  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
345  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
346  * behavior.
347  */
348 contract Crowdsale is TokenConfig, Pausable, ReentrancyGuard, Whitelist {
349   using SafeMath for uint256;
350   using SafeERC20 for IERC20;
351 
352   // The token being sold
353   IERC20 private _token;
354 
355   // Address where funds are collected
356   address private _wallet;
357 
358   // Address where funds are collected
359   address private _tokenholder;
360 
361   // How many token units a buyer gets per wei.
362   // The rate is the conversion between wei and the smallest and indivisible token unit.
363   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
364   // 1 wei will give you 1 unit, or 0.001 TOK.
365   uint256 private _rate;
366 
367   // Amount of contribution wei raised
368   uint256 private _weiRaised;
369 
370   // Amount of token sold
371   uint256 private _tokenSoldAmount;
372 
373   // Minimum contribution amount of fund
374   uint256 private _minWeiAmount;
375 
376   // balances of user should be sent
377   mapping (address => uint256) private _tokenBalances;
378 
379   // balances of user fund
380   mapping (address => uint256) private _weiBalances;
381 
382   // ICO period timestamp
383   uint256 private _openingTime;
384   uint256 private _closingTime;
385 
386   // Amount of token hardcap
387   uint256 private _hardcap;
388 
389   /**
390    * Event for token purchase logging
391    * @param purchaser who paid for the tokens
392    * @param beneficiary who got the tokens
393    * @param value weis paid for purchase
394    * @param amount amount of tokens purchased
395    */
396   event TokensPurchased(
397     address indexed purchaser,
398     address indexed beneficiary,
399     uint256 value,
400     uint256 amount
401   );
402   event TokensDelivered(address indexed beneficiary, uint256 amount);
403   event RateChanged(uint256 rate);
404   event MinWeiChanged(uint256 minWei);
405   event PeriodChanged(uint256 open, uint256 close);
406   event HardcapChanged(uint256 hardcap);
407 
408   constructor(
409     uint256 rate,
410     uint256 minWeiAmount,
411     address wallet,
412     address tokenholder,
413     IERC20 token,
414     uint256 hardcap,
415     uint256 openingTime,
416     uint256 closingTime
417   ) public {
418     require(rate > 0, "Rate is lower than zero.");
419     require(wallet != address(0), "Wallet address is zero");
420     require(tokenholder != address(0), "Tokenholder address is zero");
421     require(token != address(0), "Token address is zero");
422 
423     _rate = rate;
424     _minWeiAmount = minWeiAmount;
425     _wallet = wallet;
426     _tokenholder = tokenholder;
427     _token = token;
428     _hardcap = hardcap;
429     _openingTime = openingTime;
430     _closingTime = closingTime;
431   }
432 
433   // -----------------------------------------
434   // Crowdsale external interface
435   // -----------------------------------------
436 
437   /**
438    * @dev fallback function ***DO NOT OVERRIDE***
439    * Note that other contracts will transfer fund with a base gas stipend
440    * of 2300, which is not enough to call buyTokens. Consider calling
441    * buyTokens directly when purchasing tokens from a contract.
442    */
443   function () external payable {
444     buyTokens(msg.sender);
445   }
446 
447   /**
448    * @return the token being sold.
449    */
450   function token() public view returns(IERC20) {
451     return _token;
452   }
453 
454   /**
455    * @return token hardcap.
456    */
457   function hardcap() public view returns(uint256) {
458     return _hardcap;
459   }
460 
461   /**
462    * @return the address where funds are collected.
463    */
464   function wallet() public view returns(address) {
465     return _wallet;
466   }
467 
468   /**
469    * @return the number of token units a buyer gets per wei.
470    */
471   function rate() public view returns(uint256) {
472     return _rate;
473   }
474 
475   /**
476    * @return the amount of wei raised.
477    */
478   function weiRaised() public view returns (uint256) {
479     return _weiRaised;
480   }
481 
482   /**
483    * @return ICO opening time.
484    */
485   function openingTime() public view returns (uint256) {
486     return _openingTime;
487   }
488 
489   /**
490    * @return ICO closing time.
491    */
492   function closingTime() public view returns (uint256) {
493     return _closingTime;
494   }
495 
496   /**
497    * @return the amount of token raised.
498    */
499   function tokenSoldAmount() public view returns (uint256) {
500     return _tokenSoldAmount;
501   }
502 
503   /**
504    * @return the number of minimum amount buyer can fund.
505    */
506   function minWeiAmount() public view returns(uint256) {
507     return _minWeiAmount;
508   }
509 
510   /**
511    * @return is ICO period
512    */
513   function isOpen() public view returns (bool) {
514      // solium-disable-next-line security/no-block-members
515     return now >= _openingTime && now <= _closingTime;
516   }
517 
518   /**
519   * @dev Gets the token balance of the specified address for deliver
520   * @param owner The address to query the balance of.
521   * @return An uint256 representing the amount owned by the passed address.
522   */
523   function tokenBalanceOf(address owner) public view returns (uint256) {
524     return _tokenBalances[owner];
525   }
526 
527   /**
528   * @dev Gets the ETH balance of the specified address.
529   * @param owner The address to query the balance of.
530   * @return An uint256 representing the amount owned by the passed address.
531   */
532   function weiBalanceOf(address owner) public view returns (uint256) {
533     return _weiBalances[owner];
534   }
535 
536   function setRate(uint256 value) public onlyOwner {
537     _rate = value;
538     emit RateChanged(value);
539   }
540 
541   function setMinWeiAmount(uint256 value) public onlyOwner {
542     _minWeiAmount = value;
543     emit MinWeiChanged(value);
544   }
545 
546   function setPeriodTimestamp(uint256 open, uint256 close)
547     public
548     onlyOwner
549   {
550     _openingTime = open;
551     _closingTime = close;
552     emit PeriodChanged(open, close);
553   }
554 
555   function setHardcap(uint256 value) public onlyOwner {
556     _hardcap = value;
557     emit HardcapChanged(value);
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
600   function deliverTokens(address[] users)
601     public
602     whenNotPaused
603     onlyOwner
604   {
605     uint256 len = users.length;
606     for (uint256 i = 0; i < len; i++) {
607       address user = users[i];
608       uint256 tokenAmount = _tokenBalances[user];
609       _deliverTokens(user, tokenAmount);
610       _tokenBalances[user] = 0;
611 
612       emit TokensDelivered(user, tokenAmount);
613     }
614   }
615 
616   // -----------------------------------------
617   // Internal interface (extensible)
618   // -----------------------------------------
619 
620   /**
621    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
622    * @param beneficiary Address performing the token purchase
623    * @param weiAmount Value in wei involved in the purchase
624    */
625   function _preValidatePurchase(
626     address beneficiary,
627     uint256 weiAmount
628   )
629     internal
630     view
631     onlyAuthorised(beneficiary)
632   {
633     require(weiAmount != 0, "Zero ETH");
634     require(weiAmount >= _minWeiAmount, "Must be equal or higher than minimum");
635     require(beneficiary != address(0), "Beneficiary address is zero");
636     require(isOpen(), "Sales is close");
637   }
638 
639   /**
640    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
641    * @param beneficiary Address performing the token purchase
642    * @param tokenAmount Number of tokens to be emitted
643    */
644   function _deliverTokens(
645     address beneficiary,
646     uint256 tokenAmount
647   )
648     internal
649   {
650     _token.safeTransferFrom(_tokenholder, beneficiary, tokenAmount);
651   }
652 
653   /**
654    * @dev Override to extend the way in which ether is converted to tokens.
655    * @param weiAmount Value in wei to be converted into tokens
656    * @return Number of tokens that can be purchased with the specified _weiAmount
657    */
658   function _getTokenAmount(uint256 weiAmount) internal view returns (uint256)
659   {
660     uint ethDecimals = 18;
661     require(DECIMALS <= ethDecimals, "");
662 
663     uint256 covertedTokens = weiAmount;
664     if (DECIMALS != ethDecimals) {
665       covertedTokens = weiAmount.div((10 ** uint256(ethDecimals - DECIMALS)));
666     }
667     return covertedTokens.mul(_rate);
668   }
669 
670   /**
671     * @dev Determines how ETH is stored/forwarded on purchases.
672     */
673   function _forwardFunds() internal {
674     _wallet.transfer(msg.value);
675   }
676 }