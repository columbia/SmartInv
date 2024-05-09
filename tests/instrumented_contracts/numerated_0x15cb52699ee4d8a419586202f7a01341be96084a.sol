1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address _who) public view returns (uint256);
11   function transfer(address _to, uint256 _value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address _owner, address _spender)
21     public view returns (uint256);
22 
23   function transferFrom(address _from, address _to, uint256 _value)
24     public returns (bool);
25 
26   function approve(address _spender, uint256 _value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 /**
35  * @title SafeERC20
36  * @dev Wrappers around ERC20 operations that throw on failure.
37  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
38  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
39  */
40 library SafeERC20 {
41   function safeTransfer(
42     ERC20Basic _token,
43     address _to,
44     uint256 _value
45   )
46     internal
47   {
48     require(_token.transfer(_to, _value));
49   }
50 
51   function safeTransferFrom(
52     ERC20 _token,
53     address _from,
54     address _to,
55     uint256 _value
56   )
57     internal
58   {
59     require(_token.transferFrom(_from, _to, _value));
60   }
61 
62   function safeApprove(
63     ERC20 _token,
64     address _spender,
65     uint256 _value
66   )
67     internal
68   {
69     require(_token.approve(_spender, _value));
70   }
71 }
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79   /**
80   * @dev Multiplies two numbers, throws on overflow.
81   */
82   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
83     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
84     // benefit is lost if 'b' is also tested.
85     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86     if (_a == 0) {
87       return 0;
88     }
89 
90     c = _a * _b;
91     assert(c / _a == _b);
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers, truncating the quotient.
97   */
98   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
99     // assert(_b > 0); // Solidity automatically throws when dividing by 0
100     // uint256 c = _a / _b;
101     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
102     return _a / _b;
103   }
104 
105   /**
106   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
109     assert(_b <= _a);
110     return _a - _b;
111   }
112 
113   /**
114   * @dev Adds two numbers, throws on overflow.
115   */
116   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
117     c = _a + _b;
118     assert(c >= _a);
119     return c;
120   }
121 }
122 
123 /**
124  * @title Basic token
125  * @dev Basic version of StandardToken, with no allowances.
126  */
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) internal balances;
131 
132   uint256 internal totalSupply_;
133 
134   /**
135   * @dev Total number of tokens in existence
136   */
137   function totalSupply() public view returns (uint256) {
138     return totalSupply_;
139   }
140 
141   /**
142   * @dev Transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_value <= balances[msg.sender]);
148     require(_to != address(0));
149 
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public view returns (uint256) {
162     return balances[_owner];
163   }
164 
165 }
166 
167 /**
168  * @title Standard ERC20 token
169  *
170  * @dev Implementation of the basic standard token.
171  * https://github.com/ethereum/EIPs/issues/20
172  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  */
174 contract StandardToken is ERC20, BasicToken {
175 
176   mapping (address => mapping (address => uint256)) internal allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(
186     address _from,
187     address _to,
188     uint256 _value
189   )
190     public
191     returns (bool)
192   {
193     require(_value <= balances[_from]);
194     require(_value <= allowed[_from][msg.sender]);
195     require(_to != address(0));
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200     emit Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    * Beware that changing an allowance with this method brings the risk that someone may use both the old
207    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value) public returns (bool) {
214     allowed[msg.sender][_spender] = _value;
215     emit Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Function to check the amount of tokens that an owner allowed to a spender.
221    * @param _owner address The address which owns the funds.
222    * @param _spender address The address which will spend the funds.
223    * @return A uint256 specifying the amount of tokens still available for the spender.
224    */
225   function allowance(
226     address _owner,
227     address _spender
228    )
229     public
230     view
231     returns (uint256)
232   {
233     return allowed[_owner][_spender];
234   }
235 
236   /**
237    * @dev Increase the amount of tokens that an owner allowed to a spender.
238    * approve should be called when allowed[_spender] == 0. To increment
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _addedValue The amount of tokens to increase the allowance by.
244    */
245   function increaseApproval(
246     address _spender,
247     uint256 _addedValue
248   )
249     public
250     returns (bool)
251   {
252     allowed[msg.sender][_spender] = (
253       allowed[msg.sender][_spender].add(_addedValue));
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Decrease the amount of tokens that an owner allowed to a spender.
260    * approve should be called when allowed[_spender] == 0. To decrement
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _subtractedValue The amount of tokens to decrease the allowance by.
266    */
267   function decreaseApproval(
268     address _spender,
269     uint256 _subtractedValue
270   )
271     public
272     returns (bool)
273   {
274     uint256 oldValue = allowed[msg.sender][_spender];
275     if (_subtractedValue >= oldValue) {
276       allowed[msg.sender][_spender] = 0;
277     } else {
278       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
279     }
280     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284 }
285 
286 /**
287  * @title Ownable
288  * @dev The Ownable contract has an owner address, and provides basic authorization control
289  * functions, this simplifies the implementation of "user permissions".
290  */
291 contract Ownable {
292   address public owner;
293 
294 
295   event OwnershipRenounced(address indexed previousOwner);
296   event OwnershipTransferred(
297     address indexed previousOwner,
298     address indexed newOwner
299   );
300 
301 
302   /**
303    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
304    * account.
305    */
306   constructor() public {
307     owner = msg.sender;
308   }
309 
310   /**
311    * @dev Throws if called by any account other than the owner.
312    */
313   modifier onlyOwner() {
314     require(msg.sender == owner);
315     _;
316   }
317 
318   /**
319    * @dev Allows the current owner to relinquish control of the contract.
320    * @notice Renouncing to ownership will leave the contract without an owner.
321    * It will not be possible to call the functions with the `onlyOwner`
322    * modifier anymore.
323    */
324   function renounceOwnership() public onlyOwner {
325     emit OwnershipRenounced(owner);
326     owner = address(0);
327   }
328 
329   /**
330    * @dev Allows the current owner to transfer control of the contract to a newOwner.
331    * @param _newOwner The address to transfer ownership to.
332    */
333   function transferOwnership(address _newOwner) public onlyOwner {
334     _transferOwnership(_newOwner);
335   }
336 
337   /**
338    * @dev Transfers control of the contract to a newOwner.
339    * @param _newOwner The address to transfer ownership to.
340    */
341   function _transferOwnership(address _newOwner) internal {
342     require(_newOwner != address(0));
343     emit OwnershipTransferred(owner, _newOwner);
344     owner = _newOwner;
345   }
346 }
347 
348 /**
349  * @title Mintable token
350  * @dev Simple ERC20 Token example, with mintable token creation
351  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
352  */
353 contract MintableToken is StandardToken, Ownable {
354   event Mint(address indexed to, uint256 amount);
355   event MintFinished();
356 
357   bool public mintingFinished = false;
358 
359 
360   modifier canMint() {
361     require(!mintingFinished);
362     _;
363   }
364 
365   modifier hasMintPermission() {
366     require(msg.sender == owner);
367     _;
368   }
369 
370   /**
371    * @dev Function to mint tokens
372    * @param _to The address that will receive the minted tokens.
373    * @param _amount The amount of tokens to mint.
374    * @return A boolean that indicates if the operation was successful.
375    */
376   function mint(
377     address _to,
378     uint256 _amount
379   )
380     public
381     hasMintPermission
382     canMint
383     returns (bool)
384   {
385     totalSupply_ = totalSupply_.add(_amount);
386     balances[_to] = balances[_to].add(_amount);
387     emit Mint(_to, _amount);
388     emit Transfer(address(0), _to, _amount);
389     return true;
390   }
391 
392   /**
393    * @dev Function to stop minting new tokens.
394    * @return True if the operation was successful.
395    */
396   function finishMinting() public onlyOwner canMint returns (bool) {
397     mintingFinished = true;
398     emit MintFinished();
399     return true;
400   }
401 }
402 
403 /**
404  * @title Burnable Token
405  * @dev Token that can be irreversibly burned (destroyed).
406  */
407 contract BurnableToken is BasicToken {
408 
409   event Burn(address indexed burner, uint256 value);
410 
411   /**
412    * @dev Burns a specific amount of tokens.
413    * @param _value The amount of token to be burned.
414    */
415   function burn(uint256 _value) public {
416     _burn(msg.sender, _value);
417   }
418 
419   function _burn(address _who, uint256 _value) internal {
420     require(_value <= balances[_who]);
421     // no need to require value <= totalSupply, since that would imply the
422     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
423 
424     balances[_who] = balances[_who].sub(_value);
425     totalSupply_ = totalSupply_.sub(_value);
426     emit Burn(_who, _value);
427     emit Transfer(_who, address(0), _value);
428   }
429 }
430 
431 /**
432  * @title Pausable
433  * @dev Base contract which allows children to implement an emergency stop mechanism.
434  */
435 contract Pausable is Ownable {
436   event Pause();
437   event Unpause();
438 
439   bool public paused = false;
440 
441 
442   /**
443    * @dev Modifier to make a function callable only when the contract is not paused.
444    */
445   modifier whenNotPaused() {
446     require(!paused);
447     _;
448   }
449 
450   /**
451    * @dev Modifier to make a function callable only when the contract is paused.
452    */
453   modifier whenPaused() {
454     require(paused);
455     _;
456   }
457 
458   /**
459    * @dev called by the owner to pause, triggers stopped state
460    */
461   function pause() public onlyOwner whenNotPaused {
462     paused = true;
463     emit Pause();
464   }
465 
466   /**
467    * @dev called by the owner to unpause, returns to normal state
468    */
469   function unpause() public onlyOwner whenPaused {
470     paused = false;
471     emit Unpause();
472   }
473 }
474 
475 /**
476  * @title Pausable token
477  * @dev StandardToken modified with pausable transfers.
478  **/
479 contract PausableToken is StandardToken, Pausable {
480 
481   function transfer(
482     address _to,
483     uint256 _value
484   )
485     public
486     whenNotPaused
487     returns (bool)
488   {
489     return super.transfer(_to, _value);
490   }
491 
492   function transferFrom(
493     address _from,
494     address _to,
495     uint256 _value
496   )
497     public
498     whenNotPaused
499     returns (bool)
500   {
501     return super.transferFrom(_from, _to, _value);
502   }
503 
504   function approve(
505     address _spender,
506     uint256 _value
507   )
508     public
509     whenNotPaused
510     returns (bool)
511   {
512     return super.approve(_spender, _value);
513   }
514 
515   function increaseApproval(
516     address _spender,
517     uint _addedValue
518   )
519     public
520     whenNotPaused
521     returns (bool success)
522   {
523     return super.increaseApproval(_spender, _addedValue);
524   }
525 
526   function decreaseApproval(
527     address _spender,
528     uint _subtractedValue
529   )
530     public
531     whenNotPaused
532     returns (bool success)
533   {
534     return super.decreaseApproval(_spender, _subtractedValue);
535   }
536 }
537 
538 contract CCXToken is BurnableToken, PausableToken, MintableToken {
539   string public constant name = "Crypto Circle Exchange Token";
540   string public constant symbol = "CCX";
541   uint8 public constant decimals = 18;
542 }
543 
544 /**
545  * @title Crowdsale
546  * @dev Crowdsale is a base contract for managing a token crowdsale,
547  * allowing investors to purchase tokens with ether. This contract implements
548  * such functionality in its most fundamental form and can be extended to provide additional
549  * functionality and/or custom behavior.
550  * The external interface represents the basic interface for purchasing tokens, and conform
551  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
552  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
553  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
554  * behavior.
555  */
556 contract DaonomicCrowdsale {
557   using SafeMath for uint256;
558 
559   /**
560    * @dev This event should be emitted when user buys something
561    */
562   event Purchase(address indexed buyer, address token, uint256 value, uint256 sold, uint256 bonus, bytes txId);
563   /**
564    * @dev Should be emitted if new payment method added
565    */
566   event RateAdd(address token);
567   /**
568    * @dev Should be emitted if payment method removed
569    */
570   event RateRemove(address token);
571 
572   // -----------------------------------------
573   // Crowdsale external interface
574   // -----------------------------------------
575 
576   /**
577    * @dev fallback function ***DO NOT OVERRIDE***
578    */
579   function () external payable {
580     buyTokens(msg.sender);
581   }
582 
583   /**
584    * @dev low level token purchase ***DO NOT OVERRIDE***
585    * @param _beneficiary Address performing the token purchase
586    */
587   function buyTokens(address _beneficiary) public payable {
588 
589     uint256 weiAmount = msg.value;
590 
591     // calculate token amount to be created
592     (uint256 tokens, uint256 left) = _getTokenAmount(weiAmount);
593     uint256 weiEarned = weiAmount.sub(left);
594     uint256 bonus = _getBonus(tokens);
595     uint256 withBonus = tokens.add(bonus);
596 
597     _preValidatePurchase(_beneficiary, weiAmount, tokens, bonus);
598 
599     _processPurchase(_beneficiary, withBonus);
600     emit Purchase(
601       _beneficiary,
602       address(0),
603         weiEarned,
604       tokens,
605       bonus,
606       ""
607     );
608 
609     _updatePurchasingState(_beneficiary, weiEarned, withBonus);
610     _postValidatePurchase(_beneficiary, weiEarned);
611 
612     if (left > 0) {
613       _beneficiary.transfer(left);
614     }
615   }
616 
617   // -----------------------------------------
618   // Internal interface (extensible)
619   // -----------------------------------------
620 
621   /**
622    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
623    * @param _beneficiary Address performing the token purchase
624    * @param _weiAmount Value in wei involved in the purchase
625    */
626   function _preValidatePurchase(
627     address _beneficiary,
628     uint256 _weiAmount,
629     uint256 _tokens,
630     uint256 _bonus
631   )
632     internal
633   {
634     require(_beneficiary != address(0));
635     require(_weiAmount != 0);
636     require(_tokens != 0);
637   }
638 
639   /**
640    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
641    * @param _beneficiary Address performing the token purchase
642    * @param _weiAmount Value in wei involved in the purchase
643    */
644   function _postValidatePurchase(
645     address _beneficiary,
646     uint256 _weiAmount
647   )
648     internal
649   {
650     // optional override
651   }
652 
653   /**
654    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
655    * @param _beneficiary Address performing the token purchase
656    * @param _tokenAmount Number of tokens to be emitted
657    */
658   function _deliverTokens(
659     address _beneficiary,
660     uint256 _tokenAmount
661   ) internal;
662 
663   /**
664    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
665    * @param _beneficiary Address receiving the tokens
666    * @param _tokenAmount Number of tokens to be purchased
667    */
668   function _processPurchase(
669     address _beneficiary,
670     uint256 _tokenAmount
671   )
672     internal
673   {
674     _deliverTokens(_beneficiary, _tokenAmount);
675   }
676 
677   /**
678    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
679    * @param _beneficiary Address receiving the tokens
680    * @param _weiAmount Value in wei involved in the purchase
681    */
682   function _updatePurchasingState(
683     address _beneficiary,
684     uint256 _weiAmount,
685     uint256 _tokens
686   )
687     internal
688   {
689     // optional override
690   }
691 
692   /**
693    * @dev Override to extend the way in which ether is converted to tokens.
694    * @param _weiAmount Value in wei to be converted into tokens
695    * @return Number of tokens that can be purchased with the specified _weiAmount
696    *         and wei left (if no more tokens can be sold)
697    */
698   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256 tokens, uint256 weiLeft);
699 
700   function _getBonus(uint256 _tokens) internal view returns (uint256);
701 }
702 
703 contract Whitelist {
704   function isInWhitelist(address addr) public view returns (bool);
705 }
706 
707 contract WhitelistDaonomicCrowdsale is DaonomicCrowdsale {
708   Whitelist public whitelist;
709 
710   constructor (Whitelist _whitelist) public {
711     whitelist = _whitelist;
712   }
713 
714   function getWhitelists() view public returns (Whitelist[]) {
715     Whitelist[] memory result = new Whitelist[](1);
716     result[0] = whitelist;
717     return result;
718   }
719 
720   function _preValidatePurchase(
721     address _beneficiary,
722     uint256 _weiAmount,
723     uint256 _tokens,
724     uint256 _bonus
725   ) internal {
726     super._preValidatePurchase(_beneficiary, _weiAmount, _tokens, _bonus);
727     require(canBuy(_beneficiary), "investor is not verified by Whitelist");
728   }
729 
730   function canBuy(address _beneficiary) constant public returns (bool) {
731     return whitelist.isInWhitelist(_beneficiary);
732   }
733 }
734 
735 contract RefundableDaonomicCrowdsale is DaonomicCrowdsale {
736   event Refund(address _address, uint256 investment);
737   mapping(address => uint256) public investments;
738 
739   function claimRefund() public {
740     require(isRefundable());
741     require(investments[msg.sender] > 0);
742 
743     uint investment = investments[msg.sender];
744     investments[msg.sender] = 0;
745 
746     msg.sender.transfer(investment);
747     emit Refund(msg.sender, investment);
748   }
749 
750   function isRefundable() public view returns (bool);
751 
752   function _updatePurchasingState(
753     address _beneficiary,
754     uint256 _weiAmount,
755     uint256 _tokens
756   ) internal {
757     super._updatePurchasingState(_beneficiary, _weiAmount, _tokens);
758     investments[_beneficiary] = investments[_beneficiary].add(_weiAmount);
759   }
760 }
761 
762 /**
763  * @title Counting Crowdsale
764  * @dev calculates amount of sold tokens
765  */
766 contract CountingDaonomicCrowdsale is DaonomicCrowdsale {
767     uint256 public sold;
768 
769     function _updatePurchasingState(
770         address _beneficiary,
771         uint256 _weiAmount,
772         uint256 _tokens
773     ) internal {
774         super._updatePurchasingState(_beneficiary, _weiAmount, _tokens);
775 
776         sold = sold.add(_tokens);
777     }
778 }
779 
780 contract MintingDaonomicCrowdsale is DaonomicCrowdsale {
781     MintableToken public token;
782 
783     constructor(MintableToken _token) public {
784         token = _token;
785     }
786 
787     function _deliverTokens(
788         address _beneficiary,
789         uint256 _tokenAmount
790     ) internal {
791         token.mint(_beneficiary, _tokenAmount);
792     }
793 }
794 
795 /**
796  * @title Token Holder with vesting period
797  * @dev holds any amount of tokens and allows to release selected number of tokens after every vestingInterval seconds
798  */
799 contract TokenHolder is Ownable {
800     using SafeMath for uint;
801 
802     event Released(uint amount);
803 
804     /**
805      * @dev start of the vesting period
806      */
807     uint public start;
808     /**
809      * @dev interval between token releases
810      */
811     uint public vestingInterval;
812     /**
813      * @dev already released value
814      */
815     uint public released;
816     /**
817      * @dev value can be released every period
818      */
819     uint public value;
820     /**
821      * @dev holding token
822      */
823     ERC20Basic public token;
824 
825     constructor(uint _start, uint _vestingInterval, uint _value, ERC20Basic _token) public {
826         start = _start;
827         vestingInterval = _vestingInterval;
828         value = _value;
829         token = _token;
830     }
831 
832     /**
833      * @dev transfers vested tokens to beneficiary (to the owner of the contract)
834      * @dev automatically calculates amount to release
835      */
836     function release() onlyOwner public {
837         uint toRelease = calculateVestedAmount().sub(released);
838         uint left = token.balanceOf(this);
839         if (left < toRelease) {
840             toRelease = left;
841         }
842         require(toRelease > 0, "nothing to release");
843         released = released.add(toRelease);
844         require(token.transfer(msg.sender, toRelease));
845         emit Released(toRelease);
846     }
847 
848     function calculateVestedAmount() view internal returns (uint) {
849         return now.sub(start).div(vestingInterval).mul(value);
850     }
851 }
852 
853 /**
854  * @title PoolDaonomicCrowdsale
855  * @dev can create TokenHolders
856  */
857 contract PoolDaonomicCrowdsale is Ownable, MintingDaonomicCrowdsale {
858     event PoolCreatedEvent(string name, uint maxAmount, uint start, uint vestingInterval, uint value);
859     event TokenHolderCreatedEvent(string name, address addr, uint amount);
860 
861     mapping(string => PoolDescription) pools;
862 
863     struct PoolDescription {
864         /**
865          * @dev maximal amount of tokens in this pool
866          */
867         uint maxAmount;
868         /**
869          * @dev amount of tokens already released
870          */
871         uint releasedAmount;
872         /**
873          * @dev start of the vesting period
874          */
875         uint start;
876         /**
877          * @dev interval between token releases
878          */
879         uint vestingInterval;
880         /**
881          * @dev value which is released every vestingInterval (in percent)
882          */
883         uint value;
884     }
885 
886     constructor(MintableToken _token) MintingDaonomicCrowdsale(_token) public {
887 
888     }
889 
890     function registerPool(string _name, uint _maxAmount, uint _start, uint _vestingInterval, uint _value) internal {
891         require(_maxAmount > 0, "maxAmount should be greater than 0");
892         require(_vestingInterval > 0, "vestingInterval should be greater than 0");
893         require(_value > 0 && _value <= 100, "value should be >0 and <=100");
894         pools[_name] = PoolDescription(_maxAmount, 0, _start, _vestingInterval, _value);
895         emit PoolCreatedEvent(_name, _maxAmount, _start, _vestingInterval, _value);
896     }
897 
898     function releaseTokens(string _name, address _beneficiary, uint _amount) onlyOwner public returns (TokenHolder) {
899         PoolDescription storage pool = pools[_name];
900         require(pool.maxAmount != 0, "pool is not defined");
901         require(_amount.add(pool.releasedAmount) <= pool.maxAmount, "pool is depleted");
902         pool.releasedAmount = _amount.add(pool.releasedAmount);
903         TokenHolder created = new TokenHolder(pool.start, pool.vestingInterval, _amount.mul(pool.value).div(100), token);
904         created.transferOwnership(_beneficiary);
905         token.mint(created, _amount);
906         emit TokenHolderCreatedEvent(_name, created, _amount);
907         return created;
908     }
909 
910     function getTokensLeft(string _name) view public returns (uint) {
911         PoolDescription storage pool = pools[_name];
912         require(pool.maxAmount != 0, "pool is not defined");
913         return pool.maxAmount.sub(pool.releasedAmount);
914     }
915 }
916 
917 /**
918  * @title Crowdsale with direct transfer
919  * @dev has directTransfer function for sending tokens to early buyers
920  */
921 contract DirectTransferDaonomicCrowdsale is Ownable, DaonomicCrowdsale {
922     function directTransfer(address _beneficiary, uint _amount) onlyOwner public {
923         _deliverTokens(_beneficiary, _amount);
924         _updatePurchasingState(_beneficiary, 0, _amount);
925     }
926 }
927 
928 contract CCXSale is Ownable, PoolDaonomicCrowdsale, CountingDaonomicCrowdsale, WhitelistDaonomicCrowdsale, RefundableDaonomicCrowdsale, DirectTransferDaonomicCrowdsale {
929 
930   event UsdEthRateChange(uint256 rate);
931   event Withdraw(address to, uint256 value);
932 
933   uint256 constant public SOFT_CAP = 50000000 * 10 ** 18;
934   uint256 constant public HARD_CAP = 225000000 * 10 ** 18;
935   uint256 constant public MINIMAL_CCX = 1000 * 10 ** 18;
936   uint256 constant public START = 1539820800; // 18 oct 2018 00:00:00
937   uint256 constant public END = 1549152000; // 3 feb 2019 00:00:00
938 
939   Pausable public pausable;
940   uint256 public rate;
941   address public operator;
942 
943   constructor(CCXToken _token, Whitelist _whitelist, uint256 _usdEthRate, address _operator)
944   PoolDaonomicCrowdsale(_token)
945   WhitelistDaonomicCrowdsale(_whitelist) public {
946     pausable = _token;
947     operator = _operator;
948     setUsdEthRate(_usdEthRate);
949     //needed for Daonomic UI
950     emit RateAdd(address(0));
951 
952     registerPool("Team", 60000000 * 10 ** 18, END - 365 * 86400, 365 * 86400, 25);
953     registerPool("Bounty", 15000000 * 10 ** 18, END, 15 * 86400, 100);
954     registerPool("Airdrop", 15000000 * 10 ** 18, END, 15 * 86400, 100);
955     registerPool("Advisors", 15000000 * 10 ** 18, END - 182 * 86400, 182 * 86400, 50);
956     registerPool("Advertising", 18000000 * 10 ** 18, END, 14 * 86400, 50);
957     registerPool("Reserve", 27000000 * 10 ** 18, END, 1, 100);
958   }
959 
960   function _preValidatePurchase(
961     address _beneficiary,
962     uint256 _weiAmount,
963     uint256 _tokens,
964     uint256 _bonus
965   ) internal {
966     super._preValidatePurchase(_beneficiary, _weiAmount, _tokens, _bonus);
967     require(now >= START);
968     require(now < END);
969     require(_tokens.add(_bonus) > MINIMAL_CCX);
970   }
971 
972   function setUsdEthRate(uint256 _usdEthRate) onlyOperatorOrOwner public {
973     rate = _usdEthRate.mul(100).div(9);
974     emit UsdEthRateChange(_usdEthRate);
975   }
976 
977   modifier onlyOperatorOrOwner() {
978     require(msg.sender == operator || msg.sender == owner);
979     _;
980   }
981 
982   function withdrawEth(address _to, uint256 _value) onlyOwner public {
983     _to.transfer(_value);
984     emit Withdraw(_to, _value);
985   }
986 
987   function setOperator(address _operator) onlyOwner public {
988     operator = _operator;
989   }
990 
991   function pauseToken() onlyOwner public {
992     pausable.pause();
993   }
994 
995   function unpauseToken() onlyOwner public {
996     pausable.unpause();
997   }
998 
999   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256 tokens, uint256 weiLeft) {
1000     tokens = _weiAmount.mul(rate);
1001     if (sold.add(tokens) > HARD_CAP) {
1002       tokens = HARD_CAP.sub(sold);
1003       //alternative to Math.ceil(tokens / rate)
1004       uint256 weiSpent = (tokens.add(rate).sub(1)).div(rate);
1005       weiLeft =_weiAmount.sub(weiSpent);
1006     } else {
1007       weiLeft = 0;
1008     }
1009   }
1010 
1011   function _getBonus(uint256 _tokens) internal view returns (uint256) {
1012     uint256 possibleBonus = getTimeBonus(_tokens) + getAmountBonus(_tokens);
1013     if (sold.add(_tokens).add(possibleBonus) > HARD_CAP) {
1014       return HARD_CAP.sub(sold).sub(_tokens);
1015     } else {
1016       return possibleBonus;
1017     }
1018   }
1019 
1020   function getTimeBonus(uint256 _tokens) public view returns (uint256) {
1021     if (now < 1542931200) { //23 nov 2018 00:00:00
1022       return _tokens.mul(15).div(100);
1023     } else if (now < 1546041600) { // 29 dec 2018 00:00:00
1024       return _tokens.mul(7).div(100);
1025     } else {
1026       return 0;
1027     }
1028   }
1029 
1030   function getAmountBonus(uint256 _tokens) public pure returns (uint256) {
1031     if (_tokens < 10000 * 10 ** 18) {
1032       return 0;
1033     } else if (_tokens < 100000 * 10 ** 18) {
1034       return _tokens.mul(3).div(100);
1035     } else if (_tokens < 1000000 * 10 ** 18) {
1036       return _tokens.mul(5).div(100);
1037     } else if (_tokens < 10000000 * 10 ** 18) {
1038       return _tokens.mul(7).div(100);
1039     } else {
1040       return _tokens.mul(10).div(100);
1041     }
1042   }
1043 
1044   function isRefundable() public view returns (bool) {
1045     return now > END && sold < SOFT_CAP;
1046   }
1047 
1048   /**
1049    * @dev function for Daonomic UI
1050    */
1051   function getRate(address _token) public view returns (uint256) {
1052     if (_token == address(0)) {
1053       return rate * 10 ** 18;
1054     } else {
1055       return 0;
1056     }
1057   }
1058 
1059   /**
1060    * @dev function for Daonomic UI
1061    */
1062   function start() public pure returns (uint256) {
1063     return START;
1064   }
1065 
1066   /**
1067    * @dev function for Daonomic UI
1068    */
1069   function end() public pure returns (uint256) {
1070     return END;
1071   }
1072 
1073 }