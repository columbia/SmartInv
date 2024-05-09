1 pragma solidity ^0.4.24;
2 
3 //part of Daonomic platform: https://daonomic.io
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address _owner, address _spender)
22     public view returns (uint256);
23 
24   function transferFrom(address _from, address _to, uint256 _value)
25     public returns (bool);
26 
27   function approve(address _spender, uint256 _value) public returns (bool);
28   event Approval(
29     address indexed owner,
30     address indexed spender,
31     uint256 value
32   );
33 }
34 
35 /**
36  * @title SafeERC20
37  * @dev Wrappers around ERC20 operations that throw on failure.
38  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
39  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
40  */
41 library SafeERC20 {
42   function safeTransfer(
43     ERC20Basic _token,
44     address _to,
45     uint256 _value
46   )
47     internal
48   {
49     require(_token.transfer(_to, _value));
50   }
51 
52   function safeTransferFrom(
53     ERC20 _token,
54     address _from,
55     address _to,
56     uint256 _value
57   )
58     internal
59   {
60     require(_token.transferFrom(_from, _to, _value));
61   }
62 
63   function safeApprove(
64     ERC20 _token,
65     address _spender,
66     uint256 _value
67   )
68     internal
69   {
70     require(_token.approve(_spender, _value));
71   }
72 }
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79 
80   /**
81   * @dev Multiplies two numbers, throws on overflow.
82   */
83   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
84     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
85     // benefit is lost if 'b' is also tested.
86     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87     if (_a == 0) {
88       return 0;
89     }
90 
91     c = _a * _b;
92     assert(c / _a == _b);
93     return c;
94   }
95 
96   /**
97   * @dev Integer division of two numbers, truncating the quotient.
98   */
99   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
100     // assert(_b > 0); // Solidity automatically throws when dividing by 0
101     // uint256 c = _a / _b;
102     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
103     return _a / _b;
104   }
105 
106   /**
107   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
108   */
109   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
110     assert(_b <= _a);
111     return _a - _b;
112   }
113 
114   /**
115   * @dev Adds two numbers, throws on overflow.
116   */
117   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
118     c = _a + _b;
119     assert(c >= _a);
120     return c;
121   }
122 }
123 
124 /**
125  * @title Basic token
126  * @dev Basic version of StandardToken, with no allowances.
127  */
128 contract BasicToken is ERC20Basic {
129   using SafeMath for uint256;
130 
131   mapping(address => uint256) internal balances;
132 
133   uint256 internal totalSupply_;
134 
135   /**
136   * @dev Total number of tokens in existence
137   */
138   function totalSupply() public view returns (uint256) {
139     return totalSupply_;
140   }
141 
142   /**
143   * @dev Transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) public returns (bool) {
148     require(_value <= balances[msg.sender]);
149     require(_to != address(0));
150 
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     emit Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public view returns (uint256) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * https://github.com/ethereum/EIPs/issues/20
173  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(
187     address _from,
188     address _to,
189     uint256 _value
190   )
191     public
192     returns (bool)
193   {
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196     require(_to != address(0));
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201     emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     emit Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(
227     address _owner,
228     address _spender
229    )
230     public
231     view
232     returns (uint256)
233   {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed[_spender] == 0. To increment
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _addedValue The amount of tokens to increase the allowance by.
245    */
246   function increaseApproval(
247     address _spender,
248     uint256 _addedValue
249   )
250     public
251     returns (bool)
252   {
253     allowed[msg.sender][_spender] = (
254       allowed[msg.sender][_spender].add(_addedValue));
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259   /**
260    * @dev Decrease the amount of tokens that an owner allowed to a spender.
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(
269     address _spender,
270     uint256 _subtractedValue
271   )
272     public
273     returns (bool)
274   {
275     uint256 oldValue = allowed[msg.sender][_spender];
276     if (_subtractedValue >= oldValue) {
277       allowed[msg.sender][_spender] = 0;
278     } else {
279       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
280     }
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285 }
286 
287 /**
288  * @title Ownable
289  * @dev The Ownable contract has an owner address, and provides basic authorization control
290  * functions, this simplifies the implementation of "user permissions".
291  */
292 contract Ownable {
293   address public owner;
294 
295 
296   event OwnershipRenounced(address indexed previousOwner);
297   event OwnershipTransferred(
298     address indexed previousOwner,
299     address indexed newOwner
300   );
301 
302 
303   /**
304    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
305    * account.
306    */
307   constructor() public {
308     owner = msg.sender;
309   }
310 
311   /**
312    * @dev Throws if called by any account other than the owner.
313    */
314   modifier onlyOwner() {
315     require(msg.sender == owner);
316     _;
317   }
318 
319   /**
320    * @dev Allows the current owner to relinquish control of the contract.
321    * @notice Renouncing to ownership will leave the contract without an owner.
322    * It will not be possible to call the functions with the `onlyOwner`
323    * modifier anymore.
324    */
325   function renounceOwnership() public onlyOwner {
326     emit OwnershipRenounced(owner);
327     owner = address(0);
328   }
329 
330   /**
331    * @dev Allows the current owner to transfer control of the contract to a newOwner.
332    * @param _newOwner The address to transfer ownership to.
333    */
334   function transferOwnership(address _newOwner) public onlyOwner {
335     _transferOwnership(_newOwner);
336   }
337 
338   /**
339    * @dev Transfers control of the contract to a newOwner.
340    * @param _newOwner The address to transfer ownership to.
341    */
342   function _transferOwnership(address _newOwner) internal {
343     require(_newOwner != address(0));
344     emit OwnershipTransferred(owner, _newOwner);
345     owner = _newOwner;
346   }
347 }
348 
349 /**
350  * @title Mintable token
351  * @dev Simple ERC20 Token example, with mintable token creation
352  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
353  */
354 contract MintableToken is StandardToken, Ownable {
355   event Mint(address indexed to, uint256 amount);
356   event MintFinished();
357 
358   bool public mintingFinished = false;
359 
360 
361   modifier canMint() {
362     require(!mintingFinished);
363     _;
364   }
365 
366   modifier hasMintPermission() {
367     require(msg.sender == owner);
368     _;
369   }
370 
371   /**
372    * @dev Function to mint tokens
373    * @param _to The address that will receive the minted tokens.
374    * @param _amount The amount of tokens to mint.
375    * @return A boolean that indicates if the operation was successful.
376    */
377   function mint(
378     address _to,
379     uint256 _amount
380   )
381     public
382     hasMintPermission
383     canMint
384     returns (bool)
385   {
386     totalSupply_ = totalSupply_.add(_amount);
387     balances[_to] = balances[_to].add(_amount);
388     emit Mint(_to, _amount);
389     emit Transfer(address(0), _to, _amount);
390     return true;
391   }
392 
393   /**
394    * @dev Function to stop minting new tokens.
395    * @return True if the operation was successful.
396    */
397   function finishMinting() public onlyOwner canMint returns (bool) {
398     mintingFinished = true;
399     emit MintFinished();
400     return true;
401   }
402 }
403 
404 /**
405  * @title Burnable Token
406  * @dev Token that can be irreversibly burned (destroyed).
407  */
408 contract BurnableToken is BasicToken {
409 
410   event Burn(address indexed burner, uint256 value);
411 
412   /**
413    * @dev Burns a specific amount of tokens.
414    * @param _value The amount of token to be burned.
415    */
416   function burn(uint256 _value) public {
417     _burn(msg.sender, _value);
418   }
419 
420   function _burn(address _who, uint256 _value) internal {
421     require(_value <= balances[_who]);
422     // no need to require value <= totalSupply, since that would imply the
423     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
424 
425     balances[_who] = balances[_who].sub(_value);
426     totalSupply_ = totalSupply_.sub(_value);
427     emit Burn(_who, _value);
428     emit Transfer(_who, address(0), _value);
429   }
430 }
431 
432 /**
433  * @title Pausable
434  * @dev Base contract which allows children to implement an emergency stop mechanism.
435  */
436 contract Pausable is Ownable {
437   event Pause();
438   event Unpause();
439 
440   bool public paused = false;
441 
442 
443   /**
444    * @dev Modifier to make a function callable only when the contract is not paused.
445    */
446   modifier whenNotPaused() {
447     require(!paused);
448     _;
449   }
450 
451   /**
452    * @dev Modifier to make a function callable only when the contract is paused.
453    */
454   modifier whenPaused() {
455     require(paused);
456     _;
457   }
458 
459   /**
460    * @dev called by the owner to pause, triggers stopped state
461    */
462   function pause() public onlyOwner whenNotPaused {
463     paused = true;
464     emit Pause();
465   }
466 
467   /**
468    * @dev called by the owner to unpause, returns to normal state
469    */
470   function unpause() public onlyOwner whenPaused {
471     paused = false;
472     emit Unpause();
473   }
474 }
475 
476 /**
477  * @title Pausable token
478  * @dev StandardToken modified with pausable transfers.
479  **/
480 contract PausableToken is StandardToken, Pausable {
481 
482   function transfer(
483     address _to,
484     uint256 _value
485   )
486     public
487     whenNotPaused
488     returns (bool)
489   {
490     return super.transfer(_to, _value);
491   }
492 
493   function transferFrom(
494     address _from,
495     address _to,
496     uint256 _value
497   )
498     public
499     whenNotPaused
500     returns (bool)
501   {
502     return super.transferFrom(_from, _to, _value);
503   }
504 
505   function approve(
506     address _spender,
507     uint256 _value
508   )
509     public
510     whenNotPaused
511     returns (bool)
512   {
513     return super.approve(_spender, _value);
514   }
515 
516   function increaseApproval(
517     address _spender,
518     uint _addedValue
519   )
520     public
521     whenNotPaused
522     returns (bool success)
523   {
524     return super.increaseApproval(_spender, _addedValue);
525   }
526 
527   function decreaseApproval(
528     address _spender,
529     uint _subtractedValue
530   )
531     public
532     whenNotPaused
533     returns (bool success)
534   {
535     return super.decreaseApproval(_spender, _subtractedValue);
536   }
537 }
538 
539 contract CCXToken is BurnableToken, PausableToken, MintableToken {
540   string public constant name = "Crypto Circle Exchange Token";
541   string public constant symbol = "CCX";
542   uint8 public constant decimals = 18;
543 }
544 
545 /**
546  * @title Crowdsale
547  * @dev Crowdsale is a base contract for managing a token crowdsale,
548  * allowing investors to purchase tokens with ether. This contract implements
549  * such functionality in its most fundamental form and can be extended to provide additional
550  * functionality and/or custom behavior.
551  * The external interface represents the basic interface for purchasing tokens, and conform
552  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
553  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
554  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
555  * behavior.
556  */
557 contract DaonomicCrowdsale {
558   using SafeMath for uint256;
559 
560   /**
561    * @dev This event should be emitted when user buys something
562    */
563   event Purchase(address indexed buyer, address token, uint256 value, uint256 sold, uint256 bonus, bytes txId);
564   /**
565    * @dev Should be emitted if new payment method added
566    */
567   event RateAdd(address token);
568   /**
569    * @dev Should be emitted if payment method removed
570    */
571   event RateRemove(address token);
572 
573   // -----------------------------------------
574   // Crowdsale external interface
575   // -----------------------------------------
576 
577   /**
578    * @dev fallback function ***DO NOT OVERRIDE***
579    */
580   function () external payable {
581     buyTokens(msg.sender);
582   }
583 
584   /**
585    * @dev low level token purchase ***DO NOT OVERRIDE***
586    * @param _beneficiary Address performing the token purchase
587    */
588   function buyTokens(address _beneficiary) public payable {
589 
590     uint256 weiAmount = msg.value;
591 
592     // calculate token amount to be created
593     (uint256 tokens, uint256 left) = _getTokenAmount(weiAmount);
594     uint256 weiEarned = weiAmount.sub(left);
595     uint256 bonus = _getBonus(tokens);
596     uint256 withBonus = tokens.add(bonus);
597 
598     _preValidatePurchase(_beneficiary, weiAmount, tokens, bonus);
599 
600     _processPurchase(_beneficiary, withBonus);
601     emit Purchase(
602       _beneficiary,
603       address(0),
604         weiEarned,
605       tokens,
606       bonus,
607       ""
608     );
609 
610     _updatePurchasingState(_beneficiary, weiEarned, withBonus);
611     _postValidatePurchase(_beneficiary, weiEarned);
612 
613     if (left > 0) {
614       _beneficiary.transfer(left);
615     }
616   }
617 
618   // -----------------------------------------
619   // Internal interface (extensible)
620   // -----------------------------------------
621 
622   /**
623    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
624    * @param _beneficiary Address performing the token purchase
625    * @param _weiAmount Value in wei involved in the purchase
626    */
627   function _preValidatePurchase(
628     address _beneficiary,
629     uint256 _weiAmount,
630     uint256 _tokens,
631     uint256 _bonus
632   )
633     internal
634   {
635     require(_beneficiary != address(0));
636     require(_weiAmount != 0);
637     require(_tokens != 0);
638   }
639 
640   /**
641    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
642    * @param _beneficiary Address performing the token purchase
643    * @param _weiAmount Value in wei involved in the purchase
644    */
645   function _postValidatePurchase(
646     address _beneficiary,
647     uint256 _weiAmount
648   )
649     internal
650   {
651     // optional override
652   }
653 
654   /**
655    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
656    * @param _beneficiary Address performing the token purchase
657    * @param _tokenAmount Number of tokens to be emitted
658    */
659   function _deliverTokens(
660     address _beneficiary,
661     uint256 _tokenAmount
662   ) internal;
663 
664   /**
665    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
666    * @param _beneficiary Address receiving the tokens
667    * @param _tokenAmount Number of tokens to be purchased
668    */
669   function _processPurchase(
670     address _beneficiary,
671     uint256 _tokenAmount
672   )
673     internal
674   {
675     _deliverTokens(_beneficiary, _tokenAmount);
676   }
677 
678   /**
679    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
680    * @param _beneficiary Address receiving the tokens
681    * @param _weiAmount Value in wei involved in the purchase
682    */
683   function _updatePurchasingState(
684     address _beneficiary,
685     uint256 _weiAmount,
686     uint256 _tokens
687   )
688     internal
689   {
690     // optional override
691   }
692 
693   /**
694    * @dev Override to extend the way in which ether is converted to tokens.
695    * @param _weiAmount Value in wei to be converted into tokens
696    * @return Number of tokens that can be purchased with the specified _weiAmount
697    *         and wei left (if no more tokens can be sold)
698    */
699   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256 tokens, uint256 weiLeft);
700 
701   function _getBonus(uint256 _tokens) internal view returns (uint256);
702 }
703 
704 contract Whitelist {
705   function isInWhitelist(address addr) public view returns (bool);
706 }
707 
708 contract WhitelistDaonomicCrowdsale is Ownable, DaonomicCrowdsale {
709   Whitelist public whitelist;
710 
711   constructor (Whitelist _whitelist) public {
712     whitelist = _whitelist;
713   }
714 
715   function getWhitelists() view public returns (Whitelist[]) {
716     Whitelist[] memory result = new Whitelist[](1);
717     result[0] = whitelist;
718     return result;
719   }
720 
721   function _preValidatePurchase(
722     address _beneficiary,
723     uint256 _weiAmount,
724     uint256 _tokens,
725     uint256 _bonus
726   ) internal {
727     super._preValidatePurchase(_beneficiary, _weiAmount, _tokens, _bonus);
728     require(canBuy(_beneficiary), "investor is not verified by Whitelist");
729   }
730 
731   function canBuy(address _beneficiary) constant public returns (bool) {
732     return whitelist.isInWhitelist(_beneficiary);
733   }
734 }
735 
736 contract RefundableDaonomicCrowdsale is DaonomicCrowdsale {
737   event Refund(address _address, uint256 investment);
738   mapping(address => uint256) public investments;
739 
740   function claimRefund() public {
741     require(isRefundable());
742     require(investments[msg.sender] > 0);
743 
744     uint investment = investments[msg.sender];
745     investments[msg.sender] = 0;
746 
747     msg.sender.transfer(investment);
748     emit Refund(msg.sender, investment);
749   }
750 
751   function isRefundable() public view returns (bool);
752 
753   function _updatePurchasingState(
754     address _beneficiary,
755     uint256 _weiAmount,
756     uint256 _tokens
757   ) internal {
758     super._updatePurchasingState(_beneficiary, _weiAmount, _tokens);
759     investments[_beneficiary] = investments[_beneficiary].add(_weiAmount);
760   }
761 }
762 
763 contract CCXSale is WhitelistDaonomicCrowdsale, RefundableDaonomicCrowdsale {
764 
765   event UsdEthRateChange(uint256 rate);
766   event Withdraw(address to, uint256 value);
767 
768   uint256 constant public SOFT_CAP = 50000000 * 10 ** 18;
769   uint256 constant public HARD_CAP = 225000000 * 10 ** 18;
770   uint256 constant public MINIMAL_CCX = 1000 * 10 ** 18;
771   uint256 constant public START = 1539820800; // 18 oct 2018 00:00:00
772   uint256 constant public END = 1549152000; // 3 feb 2019 00:00:00
773 
774   CCXToken public token;
775   uint256 public sold;
776   uint256 public rate;
777   address public operator;
778 
779   constructor(CCXToken _token, Whitelist _whitelist, uint256 _usdEthRate, address _operator)
780   WhitelistDaonomicCrowdsale(_whitelist) public {
781     token = _token;
782     operator = _operator;
783     setUsdEthRate(_usdEthRate);
784     //needed for Daonomic UI
785     emit RateAdd(address(0));
786   }
787 
788   function _preValidatePurchase(
789     address _beneficiary,
790     uint256 _weiAmount,
791     uint256 _tokens,
792     uint256 _bonus
793   ) internal {
794     super._preValidatePurchase(_beneficiary, _weiAmount, _tokens, _bonus);
795     require(now >= START);
796     require(now < END);
797     require(_tokens.add(_bonus) > MINIMAL_CCX);
798   }
799 
800   function setUsdEthRate(uint256 _usdEthRate) onlyOperatorOrOwner public {
801     rate = _usdEthRate.mul(100).div(9);
802     emit UsdEthRateChange(_usdEthRate);
803   }
804 
805   modifier onlyOperatorOrOwner() {
806     require(msg.sender == operator || msg.sender == owner);
807     _;
808   }
809 
810   function withdrawEth(address _to, uint256 _value) onlyOwner public {
811     _to.transfer(_value);
812     emit Withdraw(_to, _value);
813   }
814 
815   function setOperator(address _operator) onlyOwner public {
816     operator = _operator;
817   }
818 
819   function pauseToken() onlyOwner public {
820     token.pause();
821   }
822 
823   function unpauseToken() onlyOwner public {
824     token.unpause();
825   }
826 
827   function _deliverTokens(
828     address _beneficiary,
829     uint256 _tokenAmount
830   ) internal {
831     token.mint(_beneficiary, _tokenAmount);
832   }
833 
834   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256 tokens, uint256 weiLeft) {
835     tokens = _weiAmount.mul(rate);
836     if (sold.add(tokens) > HARD_CAP) {
837       tokens = HARD_CAP.sub(sold);
838       //alternative to Math.ceil(tokens / rate)
839       uint256 weiSpent = (tokens.add(rate).sub(1)).div(rate);
840       weiLeft =_weiAmount.sub(weiSpent);
841     } else {
842       weiLeft = 0;
843     }
844   }
845 
846   function _getBonus(uint256 _tokens) internal view returns (uint256) {
847     uint256 possibleBonus = getTimeBonus(_tokens) + getAmountBonus(_tokens);
848     if (sold.add(_tokens).add(possibleBonus) > HARD_CAP) {
849       return HARD_CAP.sub(sold).sub(_tokens);
850     } else {
851       return possibleBonus;
852     }
853   }
854 
855   function getTimeBonus(uint256 _tokens) public view returns (uint256) {
856     if (now < 1542931200) { //23 nov 2018 00:00:00
857       return _tokens.mul(15).div(100);
858     } else if (now < 1546041600) { // 29 dec 2018 00:00:00
859       return _tokens.mul(7).div(100);
860     } else {
861       return 0;
862     }
863   }
864 
865   function getAmountBonus(uint256 _tokens) public pure returns (uint256) {
866     if (_tokens < 10000 * 10 ** 18) {
867       return 0;
868     } else if (_tokens < 100000 * 10 ** 18) {
869       return _tokens.mul(3).div(100);
870     } else if (_tokens < 1000000 * 10 ** 18) {
871       return _tokens.mul(5).div(100);
872     } else if (_tokens < 10000000 * 10 ** 18) {
873       return _tokens.mul(7).div(100);
874     } else {
875       return _tokens.mul(10).div(100);
876     }
877   }
878 
879   function _updatePurchasingState(
880     address _beneficiary,
881     uint256 _weiAmount,
882     uint256 _tokens
883   ) internal {
884     super._updatePurchasingState(_beneficiary, _weiAmount, _tokens);
885 
886     sold = sold.add(_tokens);
887   }
888 
889   function isRefundable() public view returns (bool) {
890     return now > END && sold < SOFT_CAP;
891   }
892 
893   /**
894    * @dev function for Daonomic UI
895    */
896   function getRate(address _token) public view returns (uint256) {
897     if (_token == address(0)) {
898       return rate * 10 ** 18;
899     } else {
900       return 0;
901     }
902   }
903 
904   /**
905    * @dev function for Daonomic UI
906    */
907   function start() public pure returns (uint256) {
908     return START;
909   }
910 
911   /**
912    * @dev function for Daonomic UI
913    */
914   function end() public pure returns (uint256) {
915     return END;
916   }
917 
918 }