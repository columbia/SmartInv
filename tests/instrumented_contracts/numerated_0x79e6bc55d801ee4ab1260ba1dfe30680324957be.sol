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
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (_a == 0) {
29       return 0;
30     }
31 
32     c = _a * _b;
33     assert(c / _a == _b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     // assert(_b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = _a / _b;
43     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
44     return _a / _b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     assert(_b <= _a);
52     return _a - _b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
59     c = _a + _b;
60     assert(c >= _a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) internal balances;
73 
74   uint256 internal totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_value <= balances[msg.sender]);
90     require(_to != address(0));
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address _owner, address _spender)
115     public view returns (uint256);
116 
117   function transferFrom(address _from, address _to, uint256 _value)
118     public returns (bool);
119 
120   function approve(address _spender, uint256 _value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156     require(_to != address(0));
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue >= oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipRenounced(address indexed previousOwner);
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   constructor() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to relinquish control of the contract.
281    * @notice Renouncing to ownership will leave the contract without an owner.
282    * It will not be possible to call the functions with the `onlyOwner`
283    * modifier anymore.
284    */
285   function renounceOwnership() public onlyOwner {
286     emit OwnershipRenounced(owner);
287     owner = address(0);
288   }
289 
290   /**
291    * @dev Allows the current owner to transfer control of the contract to a newOwner.
292    * @param _newOwner The address to transfer ownership to.
293    */
294   function transferOwnership(address _newOwner) public onlyOwner {
295     _transferOwnership(_newOwner);
296   }
297 
298   /**
299    * @dev Transfers control of the contract to a newOwner.
300    * @param _newOwner The address to transfer ownership to.
301    */
302   function _transferOwnership(address _newOwner) internal {
303     require(_newOwner != address(0));
304     emit OwnershipTransferred(owner, _newOwner);
305     owner = _newOwner;
306   }
307 }
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
313  */
314 contract MintableToken is StandardToken, Ownable {
315   event Mint(address indexed to, uint256 amount);
316   event MintFinished();
317 
318   bool public mintingFinished = false;
319 
320 
321   modifier canMint() {
322     require(!mintingFinished);
323     _;
324   }
325 
326   modifier hasMintPermission() {
327     require(msg.sender == owner);
328     _;
329   }
330 
331   /**
332    * @dev Function to mint tokens
333    * @param _to The address that will receive the minted tokens.
334    * @param _amount The amount of tokens to mint.
335    * @return A boolean that indicates if the operation was successful.
336    */
337   function mint(
338     address _to,
339     uint256 _amount
340   )
341     public
342     hasMintPermission
343     canMint
344     returns (bool)
345   {
346     totalSupply_ = totalSupply_.add(_amount);
347     balances[_to] = balances[_to].add(_amount);
348     emit Mint(_to, _amount);
349     emit Transfer(address(0), _to, _amount);
350     return true;
351   }
352 
353   /**
354    * @dev Function to stop minting new tokens.
355    * @return True if the operation was successful.
356    */
357   function finishMinting() public onlyOwner canMint returns (bool) {
358     mintingFinished = true;
359     emit MintFinished();
360     return true;
361   }
362 }
363 
364 /**
365  * @title Crowdsale
366  * @dev Crowdsale is a base contract for managing a token crowdsale,
367  * allowing investors to purchase tokens with ether. This contract implements
368  * such functionality in its most fundamental form and can be extended to provide additional
369  * functionality and/or custom behavior.
370  * The external interface represents the basic interface for purchasing tokens, and conform
371  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
372  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
373  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
374  * behavior.
375  * @dev part of Daonomic platform
376  */
377 contract QashbackCrowdsale {
378   using SafeMath for uint256;
379 
380   /**
381    * @dev This event should be emitted when user buys something
382    */
383   event Purchase(address indexed buyer, address token, uint256 value, uint256 sold, uint256 bonus, bytes txId);
384   /**
385    * @dev Should be emitted if new payment method added
386    */
387   event RateAdd(address token);
388   /**
389    * @dev Should be emitted if payment method removed
390    */
391   event RateRemove(address token);
392 
393   // -----------------------------------------
394   // Crowdsale external interface
395   // -----------------------------------------
396 
397   /**
398    * @dev fallback function ***DO NOT OVERRIDE***
399    */
400   function () external payable {
401     buyTokens(msg.sender);
402   }
403 
404   /**
405    * @dev low level token purchase ***DO NOT OVERRIDE***
406    * @param _beneficiary Address performing the token purchase
407    */
408   function buyTokens(address _beneficiary) public payable {
409 
410     uint256 weiAmount = msg.value;
411 
412     // calculate token amount to be created
413     (uint256 tokens, uint256 left) = _getTokenAmount(weiAmount);
414     uint256 weiEarned = weiAmount.sub(left);
415     uint256 bonus = _getBonus(tokens);
416     uint256 withBonus = tokens.add(bonus);
417 
418     _preValidatePurchase(_beneficiary, weiAmount, tokens, bonus);
419 
420     _processPurchase(_beneficiary, withBonus);
421     emit Purchase(
422       _beneficiary,
423       address(0),
424         weiEarned,
425       tokens,
426       bonus,
427       ""
428     );
429 
430     _updatePurchasingState(_beneficiary, weiEarned, withBonus);
431     _postValidatePurchase(_beneficiary, weiEarned);
432 
433     if (left > 0) {
434       _beneficiary.transfer(left);
435     }
436   }
437 
438   // -----------------------------------------
439   // Internal interface (extensible)
440   // -----------------------------------------
441 
442   /**
443    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
444    * @param _beneficiary Address performing the token purchase
445    * @param _weiAmount Value in wei involved in the purchase
446    */
447   function _preValidatePurchase(
448     address _beneficiary,
449     uint256 _weiAmount,
450     uint256 _tokens,
451     uint256 _bonus
452   )
453     internal
454   {
455     require(_beneficiary != address(0));
456     require(_weiAmount != 0);
457     require(_tokens != 0);
458   }
459 
460   /**
461    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
462    * @param _beneficiary Address performing the token purchase
463    * @param _weiAmount Value in wei involved in the purchase
464    */
465   function _postValidatePurchase(
466     address _beneficiary,
467     uint256 _weiAmount
468   )
469     internal
470   {
471     // optional override
472   }
473 
474   /**
475    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
476    * @param _beneficiary Address performing the token purchase
477    * @param _tokenAmount Number of tokens to be emitted
478    */
479   function _deliverTokens(
480     address _beneficiary,
481     uint256 _tokenAmount
482   ) internal;
483 
484   /**
485    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
486    * @param _beneficiary Address receiving the tokens
487    * @param _tokenAmount Number of tokens to be purchased
488    */
489   function _processPurchase(
490     address _beneficiary,
491     uint256 _tokenAmount
492   )
493     internal
494   {
495     _deliverTokens(_beneficiary, _tokenAmount);
496   }
497 
498   /**
499    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
500    * @param _beneficiary Address receiving the tokens
501    * @param _weiAmount Value in wei involved in the purchase
502    */
503   function _updatePurchasingState(
504     address _beneficiary,
505     uint256 _weiAmount,
506     uint256 _tokens
507   )
508     internal
509   {
510     // optional override
511   }
512 
513   /**
514    * @dev Override to extend the way in which ether is converted to tokens.
515    * @param _weiAmount Value in wei to be converted into tokens
516    * @return Number of tokens that can be purchased with the specified _weiAmount
517    *         and wei left (if no more tokens can be sold)
518    */
519   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256 tokens, uint256 weiLeft);
520 
521   function _getBonus(uint256 _tokens) internal view returns (uint256);
522 }
523 
524 contract MintingQashbackCrowdsale is QashbackCrowdsale {
525     MintableToken public token;
526 
527     constructor(MintableToken _token) public {
528         token = _token;
529     }
530 
531     function _deliverTokens(
532         address _beneficiary,
533         uint256 _tokenAmount
534     ) internal {
535         token.mint(_beneficiary, _tokenAmount);
536     }
537 }
538 
539 contract Whitelist {
540   function isInWhitelist(address addr) public view returns (bool);
541 }
542 
543 contract WhitelistQashbackCrowdsale is QashbackCrowdsale {
544   Whitelist public whitelist;
545 
546   constructor (Whitelist _whitelist) public {
547     whitelist = _whitelist;
548   }
549 
550   function getWhitelists() view public returns (Whitelist[]) {
551     Whitelist[] memory result = new Whitelist[](1);
552     result[0] = whitelist;
553     return result;
554   }
555 
556   function _preValidatePurchase(
557     address _beneficiary,
558     uint256 _weiAmount,
559     uint256 _tokens,
560     uint256 _bonus
561   ) internal {
562     super._preValidatePurchase(_beneficiary, _weiAmount, _tokens, _bonus);
563     require(canBuy(_beneficiary), "investor is not verified by Whitelist");
564   }
565 
566   function canBuy(address _beneficiary) view public returns (bool) {
567     return whitelist.isInWhitelist(_beneficiary);
568   }
569 }
570 
571 /**
572  * @title Counting Crowdsale
573  * @dev calculates amount of sold tokens
574  */
575 contract CountingQashbackCrowdsale is QashbackCrowdsale {
576     uint256 public sold;
577 
578     function _updatePurchasingState(
579         address _beneficiary,
580         uint256 _weiAmount,
581         uint256 _tokens
582     ) internal {
583         super._updatePurchasingState(_beneficiary, _weiAmount, _tokens);
584 
585         sold = sold.add(_tokens);
586     }
587 }
588 
589 /**
590  * @title Burnable Token
591  * @dev Token that can be irreversibly burned (destroyed).
592  */
593 contract BurnableToken is BasicToken {
594 
595   event Burn(address indexed burner, uint256 value);
596 
597   /**
598    * @dev Burns a specific amount of tokens.
599    * @param _value The amount of token to be burned.
600    */
601   function burn(uint256 _value) public {
602     _burn(msg.sender, _value);
603   }
604 
605   function _burn(address _who, uint256 _value) internal {
606     require(_value <= balances[_who]);
607     // no need to require value <= totalSupply, since that would imply the
608     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
609 
610     balances[_who] = balances[_who].sub(_value);
611     totalSupply_ = totalSupply_.sub(_value);
612     emit Burn(_who, _value);
613     emit Transfer(_who, address(0), _value);
614   }
615 }
616 
617 /**
618  * @title Pausable
619  * @dev Base contract which allows children to implement an emergency stop mechanism.
620  */
621 contract Pausable is Ownable {
622   event Pause();
623   event Unpause();
624 
625   bool public paused = false;
626 
627 
628   /**
629    * @dev Modifier to make a function callable only when the contract is not paused.
630    */
631   modifier whenNotPaused() {
632     require(!paused);
633     _;
634   }
635 
636   /**
637    * @dev Modifier to make a function callable only when the contract is paused.
638    */
639   modifier whenPaused() {
640     require(paused);
641     _;
642   }
643 
644   /**
645    * @dev called by the owner to pause, triggers stopped state
646    */
647   function pause() public onlyOwner whenNotPaused {
648     paused = true;
649     emit Pause();
650   }
651 
652   /**
653    * @dev called by the owner to unpause, returns to normal state
654    */
655   function unpause() public onlyOwner whenPaused {
656     paused = false;
657     emit Unpause();
658   }
659 }
660 
661 /**
662  * @title Pausable token
663  * @dev StandardToken modified with pausable transfers.
664  **/
665 contract PausableToken is StandardToken, Pausable {
666 
667   function transfer(
668     address _to,
669     uint256 _value
670   )
671     public
672     whenNotPaused
673     returns (bool)
674   {
675     return super.transfer(_to, _value);
676   }
677 
678   function transferFrom(
679     address _from,
680     address _to,
681     uint256 _value
682   )
683     public
684     whenNotPaused
685     returns (bool)
686   {
687     return super.transferFrom(_from, _to, _value);
688   }
689 
690   function approve(
691     address _spender,
692     uint256 _value
693   )
694     public
695     whenNotPaused
696     returns (bool)
697   {
698     return super.approve(_spender, _value);
699   }
700 
701   function increaseApproval(
702     address _spender,
703     uint _addedValue
704   )
705     public
706     whenNotPaused
707     returns (bool success)
708   {
709     return super.increaseApproval(_spender, _addedValue);
710   }
711 
712   function decreaseApproval(
713     address _spender,
714     uint _subtractedValue
715   )
716     public
717     whenNotPaused
718     returns (bool success)
719   {
720     return super.decreaseApproval(_spender, _subtractedValue);
721   }
722 }
723 
724 contract QBKToken is BurnableToken, PausableToken, MintableToken {
725   string public constant name = "QashBack";
726   string public constant symbol = "QBK";
727   uint8 public constant decimals = 18;
728 
729   uint256 public constant MAX_TOTAL_SUPPLY = 1000000000 * 10 ** 18;
730 
731   function mint(address _to, uint256 _amount) public returns (bool) {
732     require(totalSupply_.add(_amount) <= MAX_TOTAL_SUPPLY);
733     return super.mint(_to, _amount);
734   }
735 }
736 
737 contract PausingQashbackSale is Ownable {
738     Pausable public pausableToken;
739 
740     constructor(Pausable _pausableToken) public {
741         pausableToken = _pausableToken;
742     }
743 
744     function pauseToken() onlyOwner public {
745         pausableToken.pause();
746     }
747 
748     function unpauseToken() onlyOwner public {
749         pausableToken.unpause();
750     }
751 }
752 
753 /**
754  * @title Token Holder with vesting period
755  * @dev holds any amount of tokens and allows to release selected number of tokens after every vestingInterval seconds
756  */
757 contract TokenHolder is Ownable {
758     using SafeMath for uint;
759 
760     event Released(uint amount);
761 
762     /**
763      * @dev start of the vesting period
764      */
765     uint public start;
766     /**
767      * @dev interval between token releases
768      */
769     uint public vestingInterval;
770     /**
771      * @dev already released value
772      */
773     uint public released;
774     /**
775      * @dev value can be released every period
776      */
777     uint public value;
778     /**
779      * @dev holding token
780      */
781     ERC20Basic public token;
782 
783     constructor(uint _start, uint _vestingInterval, uint _value, ERC20Basic _token) public {
784         start = _start;
785         vestingInterval = _vestingInterval;
786         value = _value;
787         token = _token;
788     }
789 
790     /**
791      * @dev transfers vested tokens to beneficiary (to the owner of the contract)
792      * @dev automatically calculates amount to release
793      */
794     function release() onlyOwner public {
795         uint toRelease = calculateVestedAmount().sub(released);
796         uint left = token.balanceOf(this);
797         if (left < toRelease) {
798             toRelease = left;
799         }
800         require(toRelease > 0, "nothing to release");
801         released = released.add(toRelease);
802         require(token.transfer(msg.sender, toRelease));
803         emit Released(toRelease);
804     }
805 
806     function calculateVestedAmount() view internal returns (uint) {
807         return now.sub(start).div(vestingInterval).mul(value);
808     }
809 }
810 
811 /**
812  * @title PoolDaonomicCrowdsale
813  * @dev can create TokenHolders
814  */
815 contract PoolQashbackCrowdsale is Ownable, MintingQashbackCrowdsale {
816     enum StartType { Fixed, Floating }
817 
818     event PoolCreatedEvent(string name, uint maxAmount, uint start, uint vestingInterval, uint value, StartType startType);
819     event TokenHolderCreatedEvent(string name, address addr, uint amount);
820 
821     mapping(string => PoolDescription) pools;
822 
823     struct PoolDescription {
824         /**
825          * @dev maximal amount of tokens in this pool
826          */
827         uint maxAmount;
828         /**
829          * @dev amount of tokens already released
830          */
831         uint releasedAmount;
832         /**
833          * @dev start of the vesting period
834          */
835         uint start;
836         /**
837          * @dev interval between token releases
838          */
839         uint vestingInterval;
840         /**
841          * @dev value which is released every vestingInterval (in percent)
842          */
843         uint value;
844         /**
845          * @dev start type of the holder (fixed - date is set in seconds since 01.01.1970, floating - date is set in seconds since holder creation)
846          */
847         StartType startType;
848     }
849 
850     constructor(MintableToken _token) MintingQashbackCrowdsale(_token) public {
851 
852     }
853 
854     function registerPool(string _name, uint _maxAmount, uint _start, uint _vestingInterval, uint _value, StartType _startType) internal {
855         require(_maxAmount > 0, "maxAmount should be greater than 0");
856         require(_vestingInterval > 0, "vestingInterval should be greater than 0");
857         require(_value > 0 && _value <= 100, "value should be >0 and <=100");
858         pools[_name] = PoolDescription(_maxAmount, 0, _start, _vestingInterval, _value, _startType);
859         emit PoolCreatedEvent(_name, _maxAmount, _start, _vestingInterval, _value, _startType);
860     }
861 
862     function createHolder(string _name, address _beneficiary, uint _amount) onlyOwner public returns (TokenHolder) {
863         PoolDescription storage pool = pools[_name];
864         require(pool.maxAmount != 0, "pool is not defined");
865         require(_amount.add(pool.releasedAmount) <= pool.maxAmount, "pool is depleted");
866         pool.releasedAmount = _amount.add(pool.releasedAmount);
867         uint start;
868         if (pool.startType == StartType.Fixed) {
869             start = pool.start;
870         } else {
871             start = now + pool.start;
872         }
873         TokenHolder created = new TokenHolder(start, pool.vestingInterval, _amount.mul(pool.value).div(100), token);
874         created.transferOwnership(_beneficiary);
875         token.mint(created, _amount);
876         emit TokenHolderCreatedEvent(_name, created, _amount);
877         return created;
878     }
879 
880     function getTokensLeft(string _name) view public returns (uint) {
881         PoolDescription storage pool = pools[_name];
882         require(pool.maxAmount != 0, "pool is not defined");
883         return pool.maxAmount.sub(pool.releasedAmount);
884     }
885 }
886 
887 /*
888    token:
889      burnable
890      pausable
891      mintable
892      with max total supply
893      paused at start
894    sale:
895      with hard cap
896      single eth rate (set via setUsdEthRate)
897      no bonus
898      start immediately, end on 12/21/2018 @ 12:00pm (UTC)
899      with direct transfer (capped with 100M tokens)
900      with timelocks (for Category_2 .. Category_10)
901      owner can withdraw eth immediately
902 */
903 contract QBKSale is PausingQashbackSale, PoolQashbackCrowdsale, CountingQashbackCrowdsale, WhitelistQashbackCrowdsale {
904     uint constant public HARD_CAP = 30000000 * 10 ** 18;
905     uint constant public TRANSFER_HARD_CAP = 100000000 * 10 ** 18;
906     uint constant public SUPPLY_HARD_CAP = 1000000000 * 10 ** 18;
907     uint256 constant public START = 1541073600; // 11/01/2018 @ 12:00pm (UTC)
908     uint256 constant public END = 1545393600; // 12/21/2018 @ 12:00pm (UTC)
909 
910     uint256 public rate;
911     uint256 public transferred;
912     address public operator;
913 
914     event UsdEthRateChange(uint256 rate);
915     event Withdraw(address to, uint256 value);
916 
917     constructor(QBKToken _token, Whitelist _whitelist, uint256 _usdEthRate)
918         PausingQashbackSale(_token)
919         PoolQashbackCrowdsale(_token)
920         WhitelistQashbackCrowdsale(_whitelist)
921         public {
922 
923         operator = owner;
924         //needed for Daonomic UI
925         emit RateAdd(address(0));
926         setUsdEthRate(_usdEthRate);
927         registerPool("Category_2", SUPPLY_HARD_CAP, 86400 * 365 * 10, 1, 100, StartType.Floating); //10 Years
928         registerPool("Category_3", SUPPLY_HARD_CAP, 86400, 1, 100, StartType.Floating); //1 day
929         registerPool("Category_4", SUPPLY_HARD_CAP, 86400 * 7, 1, 100, StartType.Floating); //7 days
930         registerPool("Category_5", SUPPLY_HARD_CAP, 86400 * 30, 1, 100, StartType.Floating); //30 days
931         registerPool("Category_6", SUPPLY_HARD_CAP, 86400 * 90, 1, 100, StartType.Floating); //90 days
932         registerPool("Category_7", SUPPLY_HARD_CAP, 86400 * 180, 1, 100, StartType.Floating); //180 days
933         registerPool("Category_8", SUPPLY_HARD_CAP, 86400 * 270, 1, 100, StartType.Floating); //270 days
934         registerPool("Category_9", SUPPLY_HARD_CAP, 86400 * 365, 1, 100, StartType.Floating); //365 days
935     }
936 
937     function _preValidatePurchase(
938         address _beneficiary,
939         uint256 _weiAmount,
940         uint256 _tokens,
941         uint256 _bonus
942     ) internal {
943         super._preValidatePurchase(_beneficiary, _weiAmount, _tokens, _bonus);
944         require(now >= START);
945         require(now < END);
946     }
947 
948     function setUsdEthRate(uint256 _usdEthRate) onlyOperatorOrOwner public {
949         rate = _usdEthRate.mul(10).div(4);
950         emit UsdEthRateChange(_usdEthRate);
951     }
952 
953     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256 tokens, uint256 weiLeft) {
954         tokens = _weiAmount.mul(rate);
955         if (sold.add(tokens) > HARD_CAP) {
956             tokens = HARD_CAP.sub(sold);
957             //alternative to Math.ceil(tokens / rate)
958             uint256 weiSpent = (tokens.add(rate).sub(1)).div(rate);
959             weiLeft =_weiAmount.sub(weiSpent);
960         } else {
961             weiLeft = 0;
962         }
963     }
964 
965     function directTransfer(address _beneficiary, uint _amount) onlyOwner public {
966         require(transferred.add(_amount) <= TRANSFER_HARD_CAP);
967         token.mint(_beneficiary, _amount);
968         transferred = transferred.add(_amount);
969     }
970 
971     function withdrawEth(address _to, uint256 _value) onlyOwner public {
972         _to.transfer(_value);
973         emit Withdraw(_to, _value);
974     }
975 
976     function _getBonus(uint256) internal view returns (uint256) {
977         return 0;
978     }
979 
980     /**
981      * @dev function for Daonomic UI
982      */
983     function getRate(address _token) public view returns (uint256) {
984         if (_token == address(0)) {
985             return rate * 10 ** 18;
986         } else {
987             return 0;
988         }
989     }
990 
991     /**
992      * @dev function for Daonomic UI
993      */
994     function start() public pure returns (uint256) {
995         return START;
996     }
997 
998     /**
999      * @dev function for Daonomic UI
1000      */
1001     function end() public pure returns (uint256) {
1002         return END;
1003     }
1004 
1005     /**
1006       * @dev function for Daonomic UI
1007       */
1008     function initialCap() public pure returns (uint256) {
1009         return HARD_CAP;
1010     }
1011 
1012     function setOperator(address _operator) onlyOwner public {
1013         operator = _operator;
1014     }
1015 
1016     modifier onlyOperatorOrOwner() {
1017         require(msg.sender == operator || msg.sender == owner);
1018         _;
1019     }
1020 }