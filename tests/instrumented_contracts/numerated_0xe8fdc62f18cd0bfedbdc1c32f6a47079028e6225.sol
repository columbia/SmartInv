1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeERC20
5  * @dev Wrappers around ERC20 operations that throw on failure.
6  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
7  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
8  */
9 library SafeERC20 {
10 
11   using SafeMath for uint256;
12 
13   function safeTransfer(
14     IERC20 token,
15     address to,
16     uint256 value
17   )
18     internal
19   {
20     require(token.transfer(to, value));
21   }
22 
23   function safeTransferFrom(
24     IERC20 token,
25     address from,
26     address to,
27     uint256 value
28   )
29     internal
30   {
31     require(token.transferFrom(from, to, value));
32   }
33 
34   function safeApprove(
35     IERC20 token,
36     address spender,
37     uint256 value
38   )
39     internal
40   {
41     // safeApprove should only be called when setting an initial allowance, 
42     // or when resetting it to zero. To increase and decrease it, use 
43     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
44     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
45     require(token.approve(spender, value));
46   }
47 
48   function safeIncreaseAllowance(
49     IERC20 token,
50     address spender,
51     uint256 value
52   )
53     internal
54   {
55     uint256 newAllowance = token.allowance(address(this), spender).add(value);
56     require(token.approve(spender, newAllowance));
57   }
58 
59   function safeDecreaseAllowance(
60     IERC20 token,
61     address spender,
62     uint256 value
63   )
64     internal
65   {
66     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
67     require(token.approve(spender, newAllowance));
68   }
69 }
70 
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that revert on error
74  */
75 library SafeMath {
76 
77   /**
78   * @dev Multiplies two numbers, reverts on overflow.
79   */
80   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82     // benefit is lost if 'b' is also tested.
83     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
84     if (a == 0) {
85       return 0;
86     }
87 
88     uint256 c = a * b;
89     require(c / a == b);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
96   */
97   function div(uint256 a, uint256 b) internal pure returns (uint256) {
98     require(b > 0); // Solidity only automatically asserts when dividing by 0
99     uint256 c = a / b;
100     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101 
102     return c;
103   }
104 
105   /**
106   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     require(b <= a);
110     uint256 c = a - b;
111 
112     return c;
113   }
114 
115   /**
116   * @dev Adds two numbers, reverts on overflow.
117   */
118   function add(uint256 a, uint256 b) internal pure returns (uint256) {
119     uint256 c = a + b;
120     require(c >= a);
121 
122     return c;
123   }
124 
125   /**
126   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
127   * reverts when dividing by zero.
128   */
129   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130     require(b != 0);
131     return a % b;
132   }
133 }
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 interface IERC20 {
140   function totalSupply() external view returns (uint256);
141 
142   function balanceOf(address who) external view returns (uint256);
143 
144   function allowance(address owner, address spender)
145     external view returns (uint256);
146 
147   function transfer(address to, uint256 value) external returns (bool);
148 
149   function approve(address spender, uint256 value)
150     external returns (bool);
151 
152   function transferFrom(address from, address to, uint256 value)
153     external returns (bool);
154 
155   event Transfer(
156     address indexed from,
157     address indexed to,
158     uint256 value
159   );
160 
161   event Approval(
162     address indexed owner,
163     address indexed spender,
164     uint256 value
165   );
166 }
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
173  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract ERC20 is IERC20 {
176   using SafeMath for uint256;
177 
178   mapping (address => uint256) private _balances;
179 
180   mapping (address => mapping (address => uint256)) private _allowed;
181 
182   uint256 private _totalSupply;
183 
184   /**
185   * @dev Total number of tokens in existence
186   */
187   function totalSupply() public view returns (uint256) {
188     return _totalSupply;
189   }
190 
191   /**
192   * @dev Gets the balance of the specified address.
193   * @param owner The address to query the balance of.
194   * @return An uint256 representing the amount owned by the passed address.
195   */
196   function balanceOf(address owner) public view returns (uint256) {
197     return _balances[owner];
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param owner address The address which owns the funds.
203    * @param spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(
207     address owner,
208     address spender
209    )
210     public
211     view
212     returns (uint256)
213   {
214     return _allowed[owner][spender];
215   }
216 
217   /**
218   * @dev Transfer token for a specified address
219   * @param to The address to transfer to.
220   * @param value The amount to be transferred.
221   */
222   function transfer(address to, uint256 value) public returns (bool) {
223     _transfer(msg.sender, to, value);
224     return true;
225   }
226 
227   /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param spender The address which will spend the funds.
234    * @param value The amount of tokens to be spent.
235    */
236   function approve(address spender, uint256 value) public returns (bool) {
237     require(spender != address(0));
238 
239     _allowed[msg.sender][spender] = value;
240     emit Approval(msg.sender, spender, value);
241     return true;
242   }
243 
244   /**
245    * @dev Transfer tokens from one address to another
246    * @param from address The address which you want to send tokens from
247    * @param to address The address which you want to transfer to
248    * @param value uint256 the amount of tokens to be transferred
249    */
250   function transferFrom(
251     address from,
252     address to,
253     uint256 value
254   )
255     public
256     returns (bool)
257   {
258     require(value <= _allowed[from][msg.sender]);
259 
260     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
261     _transfer(from, to, value);
262     return true;
263   }
264 
265   /**
266    * @dev Increase the amount of tokens that an owner allowed to a spender.
267    * approve should be called when allowed_[_spender] == 0. To increment
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param spender The address which will spend the funds.
272    * @param addedValue The amount of tokens to increase the allowance by.
273    */
274   function increaseAllowance(
275     address spender,
276     uint256 addedValue
277   )
278     public
279     returns (bool)
280   {
281     require(spender != address(0));
282 
283     _allowed[msg.sender][spender] = (
284       _allowed[msg.sender][spender].add(addedValue));
285     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
286     return true;
287   }
288 
289   /**
290    * @dev Decrease the amount of tokens that an owner allowed to a spender.
291    * approve should be called when allowed_[_spender] == 0. To decrement
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param spender The address which will spend the funds.
296    * @param subtractedValue The amount of tokens to decrease the allowance by.
297    */
298   function decreaseAllowance(
299     address spender,
300     uint256 subtractedValue
301   )
302     public
303     returns (bool)
304   {
305     require(spender != address(0));
306 
307     _allowed[msg.sender][spender] = (
308       _allowed[msg.sender][spender].sub(subtractedValue));
309     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
310     return true;
311   }
312 
313   /**
314   * @dev Transfer token for a specified addresses
315   * @param from The address to transfer from.
316   * @param to The address to transfer to.
317   * @param value The amount to be transferred.
318   */
319   function _transfer(address from, address to, uint256 value) internal {
320     require(value <= _balances[from]);
321     require(to != address(0));
322 
323     _balances[from] = _balances[from].sub(value);
324     _balances[to] = _balances[to].add(value);
325     emit Transfer(from, to, value);
326   }
327 
328   /**
329    * @dev Internal function that mints an amount of the token and assigns it to
330    * an account. This encapsulates the modification of balances such that the
331    * proper events are emitted.
332    * @param account The account that will receive the created tokens.
333    * @param value The amount that will be created.
334    */
335   function _mint(address account, uint256 value) internal {
336     require(account != 0);
337     _totalSupply = _totalSupply.add(value);
338     _balances[account] = _balances[account].add(value);
339     emit Transfer(address(0), account, value);
340   }
341 }
342 
343 /**
344  * @title Helps contracts guard against reentrancy attacks.
345  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
346  * @dev If you mark a function `nonReentrant`, you should also
347  * mark it `external`.
348  */
349 contract ReentrancyGuard {
350 
351   /// @dev counter to allow mutex lock with only one SSTORE operation
352   uint256 private _guardCounter;
353 
354   constructor() internal {
355     // The counter starts at one to prevent changing it from zero to a non-zero
356     // value, which is a more expensive operation.
357     _guardCounter = 1;
358   }
359 
360   /**
361    * @dev Prevents a contract from calling itself, directly or indirectly.
362    * Calling a `nonReentrant` function from another `nonReentrant`
363    * function is not supported. It is possible to prevent this from happening
364    * by making the `nonReentrant` function external, and make it call a
365    * `private` function that does the actual work.
366    */
367   modifier nonReentrant() {
368     _guardCounter += 1;
369     uint256 localCounter = _guardCounter;
370     _;
371     require(localCounter == _guardCounter);
372   }
373 
374 }
375 
376 /**
377  * @title Ownable
378  * @dev The Ownable contract has an owner address, and provides basic authorization control
379  * functions, this simplifies the implementation of "user permissions".
380  * modifed to set specific owner
381  */
382 contract Ownable {
383   address internal _owner;
384 
385   event OwnershipTransferred(
386     address indexed previousOwner,
387     address indexed newOwner
388   );
389 
390   /**
391    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
392    * account.
393    */
394   constructor() internal {
395     _owner = msg.sender;
396     emit OwnershipTransferred(address(0), _owner);
397   }
398 
399   /**
400    * @return the address of the owner.
401    */
402   function owner() public view returns(address) {
403     return _owner;
404   }
405 
406   /**
407    * @dev Throws if called by any account other than the owner.
408    */
409   modifier onlyOwner() {
410     require(isOwner());
411     _;
412   }
413 
414   /**
415    * @return true if `msg.sender` is the owner of the contract.
416    */
417   function isOwner() public view returns(bool) {
418     return msg.sender == _owner;
419   }
420 
421   /**
422    * @dev Allows the current owner to transfer control of the contract to a newOwner.
423    * @param newOwner The address to transfer ownership to.
424    */
425   function transferOwnership(address newOwner) public onlyOwner {
426     _transferOwnership(newOwner);
427   }
428 
429   /**
430    * @dev Transfers control of the contract to a newOwner.
431    * @param newOwner The address to transfer ownership to.
432    */
433   function _transferOwnership(address newOwner) internal {
434     require(newOwner != address(0));
435     emit OwnershipTransferred(_owner, newOwner);
436     _owner = newOwner;
437   }
438 }
439 
440 /**
441  * @title Crowdsale
442  * @dev Crowdsale is a base contract for managing a token crowdsale,
443  * allowing investors to purchase tokens with ether. This contract implements
444  * such functionality in its most fundamental form and can be extended to provide additional
445  * functionality and/or custom behavior.
446  * The external interface represents the basic interface for purchasing tokens, and conform
447  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
448  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
449  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
450  * behavior.
451  */
452 contract Crowdsale is ReentrancyGuard {
453   using SafeMath for uint256;
454   using SafeERC20 for IERC20;
455 
456   // The token being sold
457   IERC20 private _token;
458 
459   // Address where funds are collected
460   address private _wallet;
461 
462   // How many token units a buyer gets per wei.
463   // The rate is the conversion between wei and the smallest and indivisible token unit.
464   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
465   // 1 wei will give you 1 unit, or 0.001 TOK.
466   uint256 private _rate;
467 
468   // Amount of wei raised
469   uint256 private _weiRaised;
470 
471   /**
472    * Event for token purchase logging
473    * @param purchaser who paid for the tokens
474    * @param beneficiary who got the tokens
475    * @param value weis paid for purchase
476    * @param amount amount of tokens purchased
477    */
478   event TokensPurchased(
479     address indexed purchaser,
480     address indexed beneficiary,
481     uint256 value,
482     uint256 amount
483   );
484 
485   /**
486    * @param rate Number of token units a buyer gets per wei
487    * @dev The rate is the conversion between wei and the smallest and indivisible
488    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
489    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
490    * @param wallet Address where collected funds will be forwarded to
491    * @param token Address of the token being sold
492    */
493   constructor(uint256 rate, address wallet, IERC20 token) internal {
494     require(rate > 0);
495     require(wallet != address(0));
496     require(token != address(0));
497 
498     _rate = rate;
499     _wallet = wallet;
500     _token = token;
501   }
502 
503   // -----------------------------------------
504   // Crowdsale external interface
505   // -----------------------------------------
506 
507   /**
508    * @dev fallback function ***DO NOT OVERRIDE***
509    * Note that other contracts will transfer fund with a base gas stipend
510    * of 2300, which is not enough to call buyTokens. Consider calling
511    * buyTokens directly when purchasing tokens from a contract.
512    */
513   function () external payable {
514     buyTokens(msg.sender);
515   }
516 
517   /**
518    * @return the token being sold.
519    */
520   function token() public view returns(IERC20) {
521     return _token;
522   }
523 
524   /**
525    * @return the address where funds are collected.
526    */
527   function wallet() public view returns(address) {
528     return _wallet;
529   }
530 
531   /**
532    * @return the number of token units a buyer gets per wei.
533    */
534   function rate() public view returns(uint256) {
535     return _rate;
536   }
537 
538   /**
539    * @return the amount of wei raised.
540    */
541   function weiRaised() public view returns (uint256) {
542     return _weiRaised;
543   }
544 
545   /**
546    * @dev low level token purchase ***DO NOT OVERRIDE***
547    * This function has a non-reentrancy guard, so it shouldn't be called by
548    * another `nonReentrant` function.
549    * @param beneficiary Recipient of the token purchase
550    */
551   function buyTokens(address beneficiary) public nonReentrant payable {
552 
553     uint256 weiAmount = msg.value;
554     _preValidatePurchase(beneficiary, weiAmount);
555 
556     // calculate token amount to be created
557     uint256 tokens = _getTokenAmount(weiAmount);
558 
559     // update state
560     _weiRaised = _weiRaised.add(weiAmount);
561 
562     _processPurchase(beneficiary, tokens);
563     emit TokensPurchased(
564       msg.sender,
565       beneficiary,
566       weiAmount,
567       tokens
568     );
569 
570     _updatePurchasingState(beneficiary, weiAmount);
571 
572     _forwardFunds();
573     _postValidatePurchase(beneficiary, weiAmount);
574   }
575 
576   // -----------------------------------------
577   // Internal interface (extensible)
578   // -----------------------------------------
579 
580   /**
581    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
582    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
583    *   super._preValidatePurchase(beneficiary, weiAmount);
584    *   require(weiRaised().add(weiAmount) <= cap);
585    * @param beneficiary Address performing the token purchase
586    * @param weiAmount Value in wei involved in the purchase
587    */
588   function _preValidatePurchase(
589     address beneficiary,
590     uint256 weiAmount
591   )
592     internal
593     view
594   {
595     require(beneficiary != address(0));
596     require(weiAmount != 0);
597   }
598 
599   /**
600    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
601    * @param beneficiary Address performing the token purchase
602    * @param weiAmount Value in wei involved in the purchase
603    */
604   function _postValidatePurchase(
605     address beneficiary,
606     uint256 weiAmount
607   )
608     internal
609     view
610   {
611     // optional override
612   }
613 
614   /**
615    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
616    * @param beneficiary Address performing the token purchase
617    * @param tokenAmount Number of tokens to be emitted
618    */
619   function _deliverTokens(
620     address beneficiary,
621     uint256 tokenAmount
622   )
623     internal
624   {
625     _token.safeTransfer(beneficiary, tokenAmount);
626   }
627 
628   /**
629    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
630    * @param beneficiary Address receiving the tokens
631    * @param tokenAmount Number of tokens to be purchased
632    */
633   function _processPurchase(
634     address beneficiary,
635     uint256 tokenAmount
636   )
637     internal
638   {
639     _deliverTokens(beneficiary, tokenAmount);
640   }
641 
642   /**
643    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
644    * @param beneficiary Address receiving the tokens
645    * @param weiAmount Value in wei involved in the purchase
646    */
647   function _updatePurchasingState(
648     address beneficiary,
649     uint256 weiAmount
650   )
651     internal
652   {
653     // optional override
654   }
655 
656   /**
657    * @dev Override to extend the way in which ether is converted to tokens.
658    * @param weiAmount Value in wei to be converted into tokens
659    * @return Number of tokens that can be purchased with the specified _weiAmount
660    */
661   function _getTokenAmount(uint256 weiAmount)
662     internal view returns (uint256)
663   {
664     return weiAmount.mul(_rate);
665   }
666 
667   /**
668    * @dev Determines how ETH is stored/forwarded on purchases.
669    */
670   function _forwardFunds() internal {
671     _wallet.transfer(msg.value);
672   }
673 }
674 
675 /**
676  * @title AllowanceCrowdsale
677  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
678  */
679 contract AllowanceCrowdsale is Crowdsale {
680   using SafeMath for uint256;
681   using SafeERC20 for IERC20;
682 
683   address private _tokenWallet;
684 
685   /**
686    * @dev Constructor, takes token wallet address.
687    * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
688    */
689   constructor(address tokenWallet) public {
690     require(tokenWallet != address(0));
691     _tokenWallet = tokenWallet;
692   }
693 
694   /**
695    * @return the address of the wallet that will hold the tokens.
696    */
697   function tokenWallet() public view returns(address) {
698     return _tokenWallet;
699   }
700 
701   /**
702    * @dev Checks the amount of tokens left in the allowance.
703    * @return Amount of tokens left in the allowance
704    */
705   function remainingTokens() public view returns (uint256) {
706     return token().allowance(_tokenWallet, this);
707   }
708 
709   /**
710    * @dev Overrides parent behavior by transferring tokens from wallet.
711    * @param beneficiary Token purchaser
712    * @param tokenAmount Amount of tokens purchased
713    */
714   function _deliverTokens(
715     address beneficiary,
716     uint256 tokenAmount
717   )
718     internal
719   {
720     token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
721   }
722 }
723 
724 
725 /**
726  *@title LILEPriceContract
727  * @dev Contract inherits the standard Crowdsale and update the token calculation 
728  * mechanism to deliver bonuses
729  */
730 contract LILEPriceContract is Crowdsale, Ownable {
731   
732   uint256 public minimumAllowed = 100000000000000000; // 0.1 ETH
733   uint256 public maximumAllowed = 101000000000000000000; // 101 ETH;
734   uint256 private _rate;
735   
736   /**
737    * LILE token price updated
738    */
739   event LILEPriceUpdated(uint256 oldPrice, uint256 newPrice);
740   
741   constructor (uint256 rate) public {
742       _rate = rate;
743   }
744   
745   function updateLILEPrice(uint256 _weiAmount) onlyOwner external {
746     require(_weiAmount > 0);
747     assert((1 ether) % _weiAmount == 0);
748     emit LILEPriceUpdated(_rate, _weiAmount);
749     _rate = _weiAmount;
750   }
751     
752   /**
753    * @dev Extend to validate ETH contribution limit
754    * @param beneficiary Address performing the token purchase
755    * @param weiAmount Value in wei involved in the purchase
756   */
757   function _preValidatePurchase(
758     address beneficiary,
759     uint256 weiAmount
760   )
761     internal
762     view
763   {
764     require(weiAmount >= minimumAllowed && weiAmount <= maximumAllowed);
765     super._preValidatePurchase(beneficiary, weiAmount);
766   }
767   
768   function rate() public view returns(uint256) {
769     return _rate;
770   }
771   
772   /**
773    * @dev Override to extend the way in which ether is converted to tokens.
774    * @param weiAmount Value in wei to be converted into tokens
775    * @return Number of tokens that can be purchased with the specified _weiAmount
776   */
777   function _getTokenAmount(uint256 weiAmount)
778     internal view returns (uint256)
779   {
780     uint256 amount = 0;
781     
782     //0.10 - 0.49 ETH
783     if(weiAmount >= 100000000000000000 && weiAmount < 500000000000000000){
784       amount = weiAmount.mul( _rate.add(_rate.mul(9).div(100)) );
785     }
786     //0.50 - 0.99
787         else if(weiAmount >= 500000000000000000 && weiAmount < 1000000000000000000) {
788       amount = weiAmount.mul( _rate.add(_rate.mul(18).div(100)) );
789     } 
790     //1.00 - 2.99
791     else if(weiAmount >= 1000000000000000000 && weiAmount < 3000000000000000000) {
792       amount = weiAmount.mul( _rate.add(_rate.mul(39).div(100)) );
793     } 
794     //3.00 - 4.99
795     else if(weiAmount >= 3000000000000000000 && weiAmount < 500000000000000000) {
796       amount = weiAmount.mul( _rate.add(_rate.mul(61).div(100)) );
797     } 
798     //5.00 - 101
799     else if (weiAmount >= 500000000000000000 && weiAmount < 101000000000000000000) 
800       amount = weiAmount.mul( _rate.add(_rate.mul(81).div(100)) );
801     // no bonus
802     else 
803       amount = weiAmount.mul( _rate);
804     
805     // update amount for 8 decimals (etherdecimals - tokendecimals, 18-8 = 10)  
806     amount = amount.div(10 ** 10);
807     return amount;
808   }
809   
810   /**
811    * @dev return tokens amount against given weiAmount
812   */
813   function getTokenAmount(uint256 weiAmount)
814     public view returns (uint256)
815   {
816     return _getTokenAmount(weiAmount);
817   }
818   
819 }
820 
821 /**
822  * @title LILECrowdsale
823  * @dev LILECrowdsale an AllowanceCrowdsale with bonuses
824  * _wallet: funds collection address
825  * _token: ERC20 token contract address
826  * _tokenWallet: address holding the funds
827  */ 
828 contract LILECrowdsale is AllowanceCrowdsale, LILEPriceContract    {
829   
830   uint256 private constant _rate = 38; //@USD: 250.00
831   
832   //amount of tokens to be sold in this Crowdsale
833   uint256 public forsale = 145623058000000;
834   
835   // funds will be transferred to this address
836   address private _wallet = address(0x546705A13550a039de877C0404A19BF4EAd65536);
837   
838   // token contract address
839   ERC20 private _token = ERC20(0x5B2988f2D77c38B46a753EA09a4f6Bf726E07e34);
840   
841   // address holding the tokens
842   address private _tokenWallet = address(0x51aceC3F6710469d3F4c59594ffef05de10b1728);
843 
844   constructor()
845     public
846     Crowdsale(_rate, _wallet, _token)
847     AllowanceCrowdsale(_tokenWallet)
848     LILEPriceContract(_rate)
849     {
850     }
851 }