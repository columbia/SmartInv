1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     _owner = msg.sender;
27   }
28 
29   /**
30    * @return the address of the owner.
31    */
32   function owner() public view returns(address) {
33     return _owner;
34   }
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(isOwner());
41     _;
42   }
43 
44   /**
45    * @return true if `msg.sender` is the owner of the contract.
46    */
47   function isOwner() public view returns(bool) {
48     return msg.sender == _owner;
49   }
50 
51   /**
52    * @dev Allows the current owner to relinquish control of the contract.
53    * @notice Renouncing to ownership will leave the contract without an owner.
54    * It will not be possible to call the functions with the `onlyOwner`
55    * modifier anymore.
56    */
57   function renounceOwnership() public onlyOwner {
58     emit OwnershipRenounced(_owner);
59     _owner = address(0);
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) public onlyOwner {
67     _transferOwnership(newOwner);
68   }
69 
70   /**
71    * @dev Transfers control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function _transferOwnership(address newOwner) internal {
75     require(newOwner != address(0));
76     emit OwnershipTransferred(_owner, newOwner);
77     _owner = newOwner;
78   }
79 }
80 
81 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 interface IERC20 {
88   function totalSupply() external view returns (uint256);
89 
90   function balanceOf(address who) external view returns (uint256);
91 
92   function allowance(address owner, address spender)
93     external view returns (uint256);
94 
95   function transfer(address to, uint256 value) external returns (bool);
96 
97   function approve(address spender, uint256 value)
98     external returns (bool);
99 
100   function transferFrom(address from, address to, uint256 value)
101     external returns (bool);
102 
103   event Transfer(
104     address indexed from,
105     address indexed to,
106     uint256 value
107   );
108 
109   event Approval(
110     address indexed owner,
111     address indexed spender,
112     uint256 value
113   );
114 }
115 
116 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
117 
118 /**
119  * @title SafeMath
120  * @dev Math operations with safety checks that revert on error
121  */
122 library SafeMath {
123 
124   /**
125   * @dev Multiplies two numbers, reverts on overflow.
126   */
127   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129     // benefit is lost if 'b' is also tested.
130     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
131     if (a == 0) {
132       return 0;
133     }
134 
135     uint256 c = a * b;
136     require(c / a == b);
137 
138     return c;
139   }
140 
141   /**
142   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
143   */
144   function div(uint256 a, uint256 b) internal pure returns (uint256) {
145     require(b > 0); // Solidity only automatically asserts when dividing by 0
146     uint256 c = a / b;
147     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148 
149     return c;
150   }
151 
152   /**
153   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
154   */
155   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156     require(b <= a);
157     uint256 c = a - b;
158 
159     return c;
160   }
161 
162   /**
163   * @dev Adds two numbers, reverts on overflow.
164   */
165   function add(uint256 a, uint256 b) internal pure returns (uint256) {
166     uint256 c = a + b;
167     require(c >= a);
168 
169     return c;
170   }
171 
172   /**
173   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
174   * reverts when dividing by zero.
175   */
176   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
177     require(b != 0);
178     return a % b;
179   }
180 }
181 
182 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
189  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract ERC20 is IERC20 {
192   using SafeMath for uint256;
193 
194   mapping (address => uint256) private _balances;
195 
196   mapping (address => mapping (address => uint256)) private _allowed;
197 
198   uint256 private _totalSupply;
199 
200   /**
201   * @dev Total number of tokens in existence
202   */
203   function totalSupply() public view returns (uint256) {
204     return _totalSupply;
205   }
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param owner The address to query the balance of.
210   * @return An uint256 representing the amount owned by the passed address.
211   */
212   function balanceOf(address owner) public view returns (uint256) {
213     return _balances[owner];
214   }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param owner address The address which owns the funds.
219    * @param spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222   function allowance(
223     address owner,
224     address spender
225    )
226     public
227     view
228     returns (uint256)
229   {
230     return _allowed[owner][spender];
231   }
232 
233   /**
234   * @dev Transfer token for a specified address
235   * @param to The address to transfer to.
236   * @param value The amount to be transferred.
237   */
238   function transfer(address to, uint256 value) public returns (bool) {
239     require(value <= _balances[msg.sender]);
240     require(to != address(0));
241 
242     _balances[msg.sender] = _balances[msg.sender].sub(value);
243     _balances[to] = _balances[to].add(value);
244     emit Transfer(msg.sender, to, value);
245     return true;
246   }
247 
248   /**
249    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
250    * Beware that changing an allowance with this method brings the risk that someone may use both the old
251    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254    * @param spender The address which will spend the funds.
255    * @param value The amount of tokens to be spent.
256    */
257   function approve(address spender, uint256 value) public returns (bool) {
258     require(spender != address(0));
259 
260     _allowed[msg.sender][spender] = value;
261     emit Approval(msg.sender, spender, value);
262     return true;
263   }
264 
265   /**
266    * @dev Transfer tokens from one address to another
267    * @param from address The address which you want to send tokens from
268    * @param to address The address which you want to transfer to
269    * @param value uint256 the amount of tokens to be transferred
270    */
271   function transferFrom(
272     address from,
273     address to,
274     uint256 value
275   )
276     public
277     returns (bool)
278   {
279     require(value <= _balances[from]);
280     require(value <= _allowed[from][msg.sender]);
281     require(to != address(0));
282 
283     _balances[from] = _balances[from].sub(value);
284     _balances[to] = _balances[to].add(value);
285     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
286     emit Transfer(from, to, value);
287     return true;
288   }
289 
290   /**
291    * @dev Increase the amount of tokens that an owner allowed to a spender.
292    * approve should be called when allowed_[_spender] == 0. To increment
293    * allowed value is better to use this function to avoid 2 calls (and wait until
294    * the first transaction is mined)
295    * From MonolithDAO Token.sol
296    * @param spender The address which will spend the funds.
297    * @param addedValue The amount of tokens to increase the allowance by.
298    */
299   function increaseAllowance(
300     address spender,
301     uint256 addedValue
302   )
303     public
304     returns (bool)
305   {
306     require(spender != address(0));
307 
308     _allowed[msg.sender][spender] = (
309       _allowed[msg.sender][spender].add(addedValue));
310     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
311     return true;
312   }
313 
314   /**
315    * @dev Decrease the amount of tokens that an owner allowed to a spender.
316    * approve should be called when allowed_[_spender] == 0. To decrement
317    * allowed value is better to use this function to avoid 2 calls (and wait until
318    * the first transaction is mined)
319    * From MonolithDAO Token.sol
320    * @param spender The address which will spend the funds.
321    * @param subtractedValue The amount of tokens to decrease the allowance by.
322    */
323   function decreaseAllowance(
324     address spender,
325     uint256 subtractedValue
326   )
327     public
328     returns (bool)
329   {
330     require(spender != address(0));
331 
332     _allowed[msg.sender][spender] = (
333       _allowed[msg.sender][spender].sub(subtractedValue));
334     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
335     return true;
336   }
337 
338   /**
339    * @dev Internal function that mints an amount of the token and assigns it to
340    * an account. This encapsulates the modification of balances such that the
341    * proper events are emitted.
342    * @param account The account that will receive the created tokens.
343    * @param amount The amount that will be created.
344    */
345   function _mint(address account, uint256 amount) internal {
346     require(account != 0);
347     _totalSupply = _totalSupply.add(amount);
348     _balances[account] = _balances[account].add(amount);
349     emit Transfer(address(0), account, amount);
350   }
351 
352   /**
353    * @dev Internal function that burns an amount of the token of a given
354    * account.
355    * @param account The account whose tokens will be burnt.
356    * @param amount The amount that will be burnt.
357    */
358   function _burn(address account, uint256 amount) internal {
359     require(account != 0);
360     require(amount <= _balances[account]);
361 
362     _totalSupply = _totalSupply.sub(amount);
363     _balances[account] = _balances[account].sub(amount);
364     emit Transfer(account, address(0), amount);
365   }
366 
367   /**
368    * @dev Internal function that burns an amount of the token of a given
369    * account, deducting from the sender's allowance for said account. Uses the
370    * internal burn function.
371    * @param account The account whose tokens will be burnt.
372    * @param amount The amount that will be burnt.
373    */
374   function _burnFrom(address account, uint256 amount) internal {
375     require(amount <= _allowed[account][msg.sender]);
376 
377     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
378     // this function needs to emit an event with the updated approval.
379     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
380       amount);
381     _burn(account, amount);
382   }
383 }
384 
385 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
386 
387 /**
388  * @title SafeERC20
389  * @dev Wrappers around ERC20 operations that throw on failure.
390  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
391  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
392  */
393 library SafeERC20 {
394   function safeTransfer(
395     IERC20 token,
396     address to,
397     uint256 value
398   )
399     internal
400   {
401     require(token.transfer(to, value));
402   }
403 
404   function safeTransferFrom(
405     IERC20 token,
406     address from,
407     address to,
408     uint256 value
409   )
410     internal
411   {
412     require(token.transferFrom(from, to, value));
413   }
414 
415   function safeApprove(
416     IERC20 token,
417     address spender,
418     uint256 value
419   )
420     internal
421   {
422     require(token.approve(spender, value));
423   }
424 }
425 
426 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
427 
428 /**
429  * @title Crowdsale
430  * @dev Crowdsale is a base contract for managing a token crowdsale,
431  * allowing investors to purchase tokens with ether. This contract implements
432  * such functionality in its most fundamental form and can be extended to provide additional
433  * functionality and/or custom behavior.
434  * The external interface represents the basic interface for purchasing tokens, and conform
435  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
436  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
437  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
438  * behavior.
439  */
440 contract Crowdsale {
441   using SafeMath for uint256;
442   using SafeERC20 for IERC20;
443 
444   // The token being sold
445   IERC20 private _token;
446 
447   // Address where funds are collected
448   address private _wallet;
449 
450   // How many token units a buyer gets per wei.
451   // The rate is the conversion between wei and the smallest and indivisible token unit.
452   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
453   // 1 wei will give you 1 unit, or 0.001 TOK.
454   uint256 private _rate;
455 
456   // Amount of wei raised
457   uint256 private _weiRaised;
458 
459   /**
460    * Event for token purchase logging
461    * @param purchaser who paid for the tokens
462    * @param beneficiary who got the tokens
463    * @param value weis paid for purchase
464    * @param amount amount of tokens purchased
465    */
466   event TokensPurchased(
467     address indexed purchaser,
468     address indexed beneficiary,
469     uint256 value,
470     uint256 amount
471   );
472 
473   /**
474    * @param rate Number of token units a buyer gets per wei
475    * @dev The rate is the conversion between wei and the smallest and indivisible
476    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
477    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
478    * @param wallet Address where collected funds will be forwarded to
479    * @param token Address of the token being sold
480    */
481   constructor(uint256 rate, address wallet, IERC20 token) public {
482     require(rate > 0);
483     require(wallet != address(0));
484     require(token != address(0));
485 
486     _rate = rate;
487     _wallet = wallet;
488     _token = token;
489   }
490 
491   // -----------------------------------------
492   // Crowdsale external interface
493   // -----------------------------------------
494 
495   /**
496    * @dev fallback function ***DO NOT OVERRIDE***
497    */
498   function () external payable {
499     buyTokens(msg.sender);
500   }
501 
502   /**
503    * @return the token being sold.
504    */
505   function token() public view returns(IERC20) {
506     return _token;
507   }
508 
509   /**
510    * @return the address where funds are collected.
511    */
512   function wallet() public view returns(address) {
513     return _wallet;
514   }
515 
516   /**
517    * @return the number of token units a buyer gets per wei.
518    */
519   function rate() public view returns(uint256) {
520     return _rate;
521   }
522 
523   /**
524    * @return the mount of wei raised.
525    */
526   function weiRaised() public view returns (uint256) {
527     return _weiRaised;
528   }
529 
530   /**
531    * @dev low level token purchase ***DO NOT OVERRIDE***
532    * @param beneficiary Address performing the token purchase
533    */
534   function buyTokens(address beneficiary) public payable {
535 
536     uint256 weiAmount = msg.value;
537     _preValidatePurchase(beneficiary, weiAmount);
538 
539     // calculate token amount to be created
540     uint256 tokens = _getTokenAmount(weiAmount);
541 
542     // update state
543     _weiRaised = _weiRaised.add(weiAmount);
544 
545     _processPurchase(beneficiary, tokens);
546     emit TokensPurchased(
547       msg.sender,
548       beneficiary,
549       weiAmount,
550       tokens
551     );
552 
553     _updatePurchasingState(beneficiary, weiAmount);
554 
555     _forwardFunds();
556     _postValidatePurchase(beneficiary, weiAmount);
557   }
558 
559   // -----------------------------------------
560   // Internal interface (extensible)
561   // -----------------------------------------
562 
563   /**
564    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
565    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
566    *   super._preValidatePurchase(beneficiary, weiAmount);
567    *   require(weiRaised().add(weiAmount) <= cap);
568    * @param beneficiary Address performing the token purchase
569    * @param weiAmount Value in wei involved in the purchase
570    */
571   function _preValidatePurchase(
572     address beneficiary,
573     uint256 weiAmount
574   )
575     internal
576   {
577     require(beneficiary != address(0));
578     require(weiAmount != 0);
579   }
580 
581   /**
582    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
583    * @param beneficiary Address performing the token purchase
584    * @param weiAmount Value in wei involved in the purchase
585    */
586   function _postValidatePurchase(
587     address beneficiary,
588     uint256 weiAmount
589   )
590     internal
591   {
592     // optional override
593   }
594 
595   /**
596    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
597    * @param beneficiary Address performing the token purchase
598    * @param tokenAmount Number of tokens to be emitted
599    */
600   function _deliverTokens(
601     address beneficiary,
602     uint256 tokenAmount
603   )
604     internal
605   {
606     _token.safeTransfer(beneficiary, tokenAmount);
607   }
608 
609   /**
610    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
611    * @param beneficiary Address receiving the tokens
612    * @param tokenAmount Number of tokens to be purchased
613    */
614   function _processPurchase(
615     address beneficiary,
616     uint256 tokenAmount
617   )
618     internal
619   {
620     _deliverTokens(beneficiary, tokenAmount);
621   }
622 
623   /**
624    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
625    * @param beneficiary Address receiving the tokens
626    * @param weiAmount Value in wei involved in the purchase
627    */
628   function _updatePurchasingState(
629     address beneficiary,
630     uint256 weiAmount
631   )
632     internal
633   {
634     // optional override
635   }
636 
637   /**
638    * @dev Override to extend the way in which ether is converted to tokens.
639    * @param weiAmount Value in wei to be converted into tokens
640    * @return Number of tokens that can be purchased with the specified _weiAmount
641    */
642   function _getTokenAmount(uint256 weiAmount)
643     internal view returns (uint256)
644   {
645     return weiAmount.mul(_rate);
646   }
647 
648   /**
649    * @dev Determines how ETH is stored/forwarded on purchases.
650    */
651   function _forwardFunds() internal {
652     _wallet.transfer(msg.value);
653   }
654 }
655 
656 // File: contracts/TimedCrowdsale.sol
657 
658 /**
659  * @title TimedCrowdsale
660  * @dev Crowdsale accepting contributions only within a time frame.
661  */
662 contract TimedCrowdsale is Ownable, Crowdsale {
663   using SafeMath for uint256;
664 
665   uint256 private _openingTime;
666   uint256 private _closingTime;
667 
668   /**
669    * @dev Reverts if not in crowdsale time range.
670    */
671   modifier onlyWhileOpen {
672     require(isOpen());
673     _;
674   }
675 
676   /**
677    * @dev Constructor, takes crowdsale opening and closing times.
678    * @param openingTime Crowdsale opening time
679    * @param closingTime Crowdsale closing time
680    */
681   constructor(uint256 openingTime, uint256 closingTime) public {
682     // solium-disable-next-line security/no-block-members
683     require(openingTime >= block.timestamp);
684     require(closingTime >= openingTime);
685 
686     _openingTime = openingTime;
687     _closingTime = closingTime;
688   }
689 
690   function closeCrowdsale() public onlyOwner returns(bool) {
691     // This is now alweys lower than current time.
692     _closingTime = block.timestamp-1;
693     return true;
694   }
695 
696   /**
697    * @return the crowdsale opening time.
698    */
699   function openingTime() public view returns(uint256) {
700     return _openingTime;
701   }
702 
703   /**
704    * @return the crowdsale closing time.
705    */
706   function closingTime() public view returns(uint256) {
707     return _closingTime;
708   }
709 
710   /**
711    * @return true if the crowdsale is open, false otherwise.
712    */
713   function isOpen() public view returns (bool) {
714     // solium-disable-next-line security/no-block-members
715     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
716   }
717 
718   /**
719    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
720    * @return Whether crowdsale period has elapsed
721    */
722   function hasClosed() public view returns (bool) {
723     // solium-disable-next-line security/no-block-members
724     return block.timestamp > _closingTime;
725   }
726 
727   /**
728    * @dev Extend parent behavior requiring to be within contributing period
729    * @param beneficiary Token purchaser
730    * @param weiAmount Amount of wei contributed
731    */
732   function _preValidatePurchase(
733     address beneficiary,
734     uint256 weiAmount
735   )
736     internal
737     onlyWhileOpen
738   {
739     super._preValidatePurchase(beneficiary, weiAmount);
740   }
741 
742   // We need to mock them for testing to test contracts active state. They should be accessible
743   function _turnBackTime(uint256 secs) internal {
744       _openingTime -= secs;
745       _closingTime -= secs;
746   }
747 
748 }
749 
750 // File: contracts/BonusableCrowdsale.sol
751 
752 contract BonusableCrowdsale is Ownable, TimedCrowdsale {
753 
754   // Currently active bonus
755   uint256 private _currentBonus;
756 
757   /**
758    * @dev Calculates bonus based on participation amount.
759    * @param weiAmount Participation amount in Wei
760    * @return tokenAmount Number of tokens to be minted
761    */
762   function _getCurrentTokenBonus(uint256 weiAmount)
763       internal view returns (uint256)
764   {
765       // It there is currently active bonus take it
766       if (_currentBonus > 0) { return _currentBonus; }
767 
768       uint256 bonus = 0;
769       uint256 currentTime = block.timestamp;
770       uint256 threshold = 10;
771 
772       if (openingTime().add(7 days) > currentTime) {
773           return weiAmount >= threshold.mul(1 ether) ? 50 : 40;
774       } else if (openingTime().add(14 days) > currentTime) {
775           return weiAmount >= threshold.mul(1 ether) ? 40 : 30;
776       } else {
777           return weiAmount >= threshold.mul(1 ether) ? 30 : 20;
778       }
779   }
780 
781   /**
782    * @dev Sets bonus that will override time and volume based bonus schema
783    * @param newBonus New bonus that will be active in percents
784    * @return Currently active bonus
785    */
786   function setCurrentBonus(uint256 newBonus)
787     public onlyOwner returns (uint256)
788   {
789       _currentBonus = newBonus;
790       return _currentBonus;
791   }
792 
793   /**
794    * @dev Takes away bonus that will override time and volume based bonus schema
795    * @return Currently active bonus
796    */
797   function cancelCurrentBonus()
798     public onlyOwner returns (uint256)
799   {
800     _currentBonus = 0;
801     return _currentBonus;
802   }
803 }
804 
805 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
806 
807 /**
808  * @title CappedCrowdsale
809  * @dev Crowdsale with a limit for total contributions.
810  */
811 contract CappedCrowdsale is Crowdsale {
812   using SafeMath for uint256;
813 
814   uint256 private _cap;
815 
816   /**
817    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
818    * @param cap Max amount of wei to be contributed
819    */
820   constructor(uint256 cap) public {
821     require(cap > 0);
822     _cap = cap;
823   }
824 
825   /**
826    * @return the cap of the crowdsale.
827    */
828   function cap() public view returns(uint256) {
829     return _cap;
830   }
831 
832   /**
833    * @dev Checks whether the cap has been reached.
834    * @return Whether the cap was reached
835    */
836   function capReached() public view returns (bool) {
837     return weiRaised() >= _cap;
838   }
839 
840   /**
841    * @dev Extend parent behavior requiring purchase to respect the funding cap.
842    * @param beneficiary Token purchaser
843    * @param weiAmount Amount of wei contributed
844    */
845   function _preValidatePurchase(
846     address beneficiary,
847     uint256 weiAmount
848   )
849     internal
850   {
851     super._preValidatePurchase(beneficiary, weiAmount);
852     require(weiRaised().add(weiAmount) <= _cap);
853   }
854 
855 }
856 
857 // File: contracts/CitowisePreIcoCrowdsale.sol
858 
859 contract CitowisePreIcoCrowdsale is Ownable,
860                                     Crowdsale,
861                                     TimedCrowdsale,
862                                     BonusableCrowdsale,
863                                     CappedCrowdsale
864 {
865     using SafeMath for uint;
866 
867     uint256 private constant PREICO_HARDCAP_ETH = 19000;  // Pre ICO stage hardcap
868 
869     uint256 baseExchangeRate = 3888;
870     uint256 minimumParticipationAmount = 500 finney; // half of an Ether
871 
872     //  uint256 public beginTime; // = 1537023600; // 2018-09-15 12pm UTC+3;
873     //  uint256 public endTime; // = 1539615600; // 2018-10-15 12pm UTC+3;
874 
875     constructor(uint256 beginTime, uint256 endTime, address walletAddress, address tokenAddress) public
876         Crowdsale(
877             baseExchangeRate,
878             walletAddress,
879             ERC20(tokenAddress))
880         TimedCrowdsale(
881             beginTime,
882             endTime)
883         CappedCrowdsale(
884             PREICO_HARDCAP_ETH.mul(1 ether))
885     {
886 
887     }
888 
889     /**
890      * @dev Returns token amoun taken into accoun currently active bonus schema bonus schema
891      *   1 day:
892      *     amounts > 10 ETH - 50% bonus
893      *     amounts < 10 ETH - 40% bonus
894      *   1 week:
895      *     amounts > 10 ETH - 40% bonus
896      *     amounts < 10 ETH - 30% bonus
897      *   Rest time:
898      *     amounts > 10 ETH - 30% bonus
899      *     amounts < 10 ETH - 20% bonus
900      * @param weiAmount Value in wei to be converted into tokens
901      * @return Number of tokens that can be purchased with the specified _weiAmount
902      */
903     function _getTokenAmount(uint256 weiAmount)
904         internal view returns (uint256)
905     {
906         uint256 currentBonus = _getCurrentTokenBonus(weiAmount);
907         uint256 hundered = 100;
908         uint256 tokensAmount = super._getTokenAmount(weiAmount);
909 
910         return tokensAmount.mul(hundered.add(currentBonus)).div(hundered);
911     }
912 
913     /**
914      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
915      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
916      *   super._preValidatePurchase(beneficiary, weiAmount);
917      *   require(weiRaised().add(weiAmount) <= cap);
918      * @param beneficiary Address performing the token purchase
919      * @param weiAmount Value in wei involved in the purchase
920      */
921     function _preValidatePurchase(
922       address beneficiary,
923       uint256 weiAmount
924     )
925       internal
926     {
927       super._preValidatePurchase(beneficiary, weiAmount);
928       require(msg.value >= minimumParticipationAmount);
929     }
930 
931     /**
932      * @dev Overrides delivery by minting tokens upon purchase.
933      * @param beneficiary Token purchaser
934      * @param tokenAmount Number of tokens to be minted
935      */
936     function _deliverTokens(
937       address beneficiary,
938       uint256 tokenAmount
939     )
940       internal
941     {
942       // Potentially dangerous assumption about the type of the token.
943       require(token().transfer(beneficiary, tokenAmount));
944     }
945 }