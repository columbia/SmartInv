1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
91 
92 /**
93  * @title Crowdsale
94  * @dev Crowdsale is a base contract for managing a token crowdsale,
95  * allowing investors to purchase tokens with ether. This contract implements
96  * such functionality in its most fundamental form and can be extended to provide additional
97  * functionality and/or custom behavior.
98  * The external interface represents the basic interface for purchasing tokens, and conform
99  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
100  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
101  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
102  * behavior.
103  */
104 contract Crowdsale {
105   using SafeMath for uint256;
106 
107   // The token being sold
108   ERC20 public token;
109 
110   // Address where funds are collected
111   address public wallet;
112 
113   // How many token units a buyer gets per wei.
114   // The rate is the conversion between wei and the smallest and indivisible token unit.
115   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
116   // 1 wei will give you 1 unit, or 0.001 TOK.
117   uint256 public rate;
118 
119   // Amount of wei raised
120   uint256 public weiRaised;
121 
122   /**
123    * Event for token purchase logging
124    * @param purchaser who paid for the tokens
125    * @param beneficiary who got the tokens
126    * @param value weis paid for purchase
127    * @param amount amount of tokens purchased
128    */
129   event TokenPurchase(
130     address indexed purchaser,
131     address indexed beneficiary,
132     uint256 value,
133     uint256 amount
134   );
135 
136   /**
137    * @param _rate Number of token units a buyer gets per wei
138    * @param _wallet Address where collected funds will be forwarded to
139    * @param _token Address of the token being sold
140    */
141   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
142     require(_rate > 0);
143     require(_wallet != address(0));
144     require(_token != address(0));
145 
146     rate = _rate;
147     wallet = _wallet;
148     token = _token;
149   }
150 
151   // -----------------------------------------
152   // Crowdsale external interface
153   // -----------------------------------------
154 
155   /**
156    * @dev fallback function ***DO NOT OVERRIDE***
157    */
158   function () external payable {
159     buyTokens(msg.sender);
160   }
161 
162   /**
163    * @dev low level token purchase ***DO NOT OVERRIDE***
164    * @param _beneficiary Address performing the token purchase
165    */
166   function buyTokens(address _beneficiary) public payable {
167 
168     uint256 weiAmount = msg.value;
169     _preValidatePurchase(_beneficiary, weiAmount);
170 
171     // calculate token amount to be created
172     uint256 tokens = _getTokenAmount(weiAmount);
173 
174     // update state
175     weiRaised = weiRaised.add(weiAmount);
176 
177     _processPurchase(_beneficiary, tokens);
178     emit TokenPurchase(
179       msg.sender,
180       _beneficiary,
181       weiAmount,
182       tokens
183     );
184 
185     _updatePurchasingState(_beneficiary, weiAmount);
186 
187     _forwardFunds();
188     _postValidatePurchase(_beneficiary, weiAmount);
189   }
190 
191   // -----------------------------------------
192   // Internal interface (extensible)
193   // -----------------------------------------
194 
195   /**
196    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
197    * @param _beneficiary Address performing the token purchase
198    * @param _weiAmount Value in wei involved in the purchase
199    */
200   function _preValidatePurchase(
201     address _beneficiary,
202     uint256 _weiAmount
203   )
204     internal
205   {
206     require(_beneficiary != address(0));
207     require(_weiAmount != 0);
208   }
209 
210   /**
211    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
212    * @param _beneficiary Address performing the token purchase
213    * @param _weiAmount Value in wei involved in the purchase
214    */
215   function _postValidatePurchase(
216     address _beneficiary,
217     uint256 _weiAmount
218   )
219     internal
220   {
221     // optional override
222   }
223 
224   /**
225    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
226    * @param _beneficiary Address performing the token purchase
227    * @param _tokenAmount Number of tokens to be emitted
228    */
229   function _deliverTokens(
230     address _beneficiary,
231     uint256 _tokenAmount
232   )
233     internal
234   {
235     token.transfer(_beneficiary, _tokenAmount);
236   }
237 
238   /**
239    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
240    * @param _beneficiary Address receiving the tokens
241    * @param _tokenAmount Number of tokens to be purchased
242    */
243   function _processPurchase(
244     address _beneficiary,
245     uint256 _tokenAmount
246   )
247     internal
248   {
249     _deliverTokens(_beneficiary, _tokenAmount);
250   }
251 
252   /**
253    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
254    * @param _beneficiary Address receiving the tokens
255    * @param _weiAmount Value in wei involved in the purchase
256    */
257   function _updatePurchasingState(
258     address _beneficiary,
259     uint256 _weiAmount
260   )
261     internal
262   {
263     // optional override
264   }
265 
266   /**
267    * @dev Override to extend the way in which ether is converted to tokens.
268    * @param _weiAmount Value in wei to be converted into tokens
269    * @return Number of tokens that can be purchased with the specified _weiAmount
270    */
271   function _getTokenAmount(uint256 _weiAmount)
272     internal view returns (uint256)
273   {
274     return _weiAmount.mul(rate);
275   }
276 
277   /**
278    * @dev Determines how ETH is stored/forwarded on purchases.
279    */
280   function _forwardFunds() internal {
281     wallet.transfer(msg.value);
282   }
283 }
284 
285 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
321    */
322   function renounceOwnership() public onlyOwner {
323     emit OwnershipRenounced(owner);
324     owner = address(0);
325   }
326 
327   /**
328    * @dev Allows the current owner to transfer control of the contract to a newOwner.
329    * @param _newOwner The address to transfer ownership to.
330    */
331   function transferOwnership(address _newOwner) public onlyOwner {
332     _transferOwnership(_newOwner);
333   }
334 
335   /**
336    * @dev Transfers control of the contract to a newOwner.
337    * @param _newOwner The address to transfer ownership to.
338    */
339   function _transferOwnership(address _newOwner) internal {
340     require(_newOwner != address(0));
341     emit OwnershipTransferred(owner, _newOwner);
342     owner = _newOwner;
343   }
344 }
345 
346 // File: contracts/ZeexWhitelistedCrowdsale.sol
347 
348 contract ZeexWhitelistedCrowdsale is Crowdsale, Ownable {
349 
350   address public whitelister;
351   mapping(address => bool) public whitelist;
352 
353   constructor(address _whitelister) public {
354     require(_whitelister != address(0));
355     whitelister = _whitelister;
356   }
357 
358   modifier isWhitelisted(address _beneficiary) {
359     require(whitelist[_beneficiary]);
360     _;
361   }
362 
363   function addToWhitelist(address _beneficiary) public onlyOwnerOrWhitelister {
364     whitelist[_beneficiary] = true;
365   }
366 
367   function addManyToWhitelist(address[] _beneficiaries) public onlyOwnerOrWhitelister {
368     for (uint256 i = 0; i < _beneficiaries.length; i++) {
369       whitelist[_beneficiaries[i]] = true;
370     }
371   }
372 
373   function removeFromWhitelist(address _beneficiary) public onlyOwnerOrWhitelister {
374     whitelist[_beneficiary] = false;
375   }
376 
377   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
378     super._preValidatePurchase(_beneficiary, _weiAmount);
379   }
380 
381   modifier onlyOwnerOrWhitelister() {
382     require(msg.sender == owner || msg.sender == whitelister);
383     _;
384   }
385 }
386 
387 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
388 
389 /**
390  * @title Basic token
391  * @dev Basic version of StandardToken, with no allowances.
392  */
393 contract BasicToken is ERC20Basic {
394   using SafeMath for uint256;
395 
396   mapping(address => uint256) balances;
397 
398   uint256 totalSupply_;
399 
400   /**
401   * @dev total number of tokens in existence
402   */
403   function totalSupply() public view returns (uint256) {
404     return totalSupply_;
405   }
406 
407   /**
408   * @dev transfer token for a specified address
409   * @param _to The address to transfer to.
410   * @param _value The amount to be transferred.
411   */
412   function transfer(address _to, uint256 _value) public returns (bool) {
413     require(_to != address(0));
414     require(_value <= balances[msg.sender]);
415 
416     balances[msg.sender] = balances[msg.sender].sub(_value);
417     balances[_to] = balances[_to].add(_value);
418     emit Transfer(msg.sender, _to, _value);
419     return true;
420   }
421 
422   /**
423   * @dev Gets the balance of the specified address.
424   * @param _owner The address to query the the balance of.
425   * @return An uint256 representing the amount owned by the passed address.
426   */
427   function balanceOf(address _owner) public view returns (uint256) {
428     return balances[_owner];
429   }
430 
431 }
432 
433 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
434 
435 /**
436  * @title Standard ERC20 token
437  *
438  * @dev Implementation of the basic standard token.
439  * @dev https://github.com/ethereum/EIPs/issues/20
440  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
441  */
442 contract StandardToken is ERC20, BasicToken {
443 
444   mapping (address => mapping (address => uint256)) internal allowed;
445 
446 
447   /**
448    * @dev Transfer tokens from one address to another
449    * @param _from address The address which you want to send tokens from
450    * @param _to address The address which you want to transfer to
451    * @param _value uint256 the amount of tokens to be transferred
452    */
453   function transferFrom(
454     address _from,
455     address _to,
456     uint256 _value
457   )
458     public
459     returns (bool)
460   {
461     require(_to != address(0));
462     require(_value <= balances[_from]);
463     require(_value <= allowed[_from][msg.sender]);
464 
465     balances[_from] = balances[_from].sub(_value);
466     balances[_to] = balances[_to].add(_value);
467     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
468     emit Transfer(_from, _to, _value);
469     return true;
470   }
471 
472   /**
473    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
474    *
475    * Beware that changing an allowance with this method brings the risk that someone may use both the old
476    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
477    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
478    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
479    * @param _spender The address which will spend the funds.
480    * @param _value The amount of tokens to be spent.
481    */
482   function approve(address _spender, uint256 _value) public returns (bool) {
483     allowed[msg.sender][_spender] = _value;
484     emit Approval(msg.sender, _spender, _value);
485     return true;
486   }
487 
488   /**
489    * @dev Function to check the amount of tokens that an owner allowed to a spender.
490    * @param _owner address The address which owns the funds.
491    * @param _spender address The address which will spend the funds.
492    * @return A uint256 specifying the amount of tokens still available for the spender.
493    */
494   function allowance(
495     address _owner,
496     address _spender
497    )
498     public
499     view
500     returns (uint256)
501   {
502     return allowed[_owner][_spender];
503   }
504 
505   /**
506    * @dev Increase the amount of tokens that an owner allowed to a spender.
507    *
508    * approve should be called when allowed[_spender] == 0. To increment
509    * allowed value is better to use this function to avoid 2 calls (and wait until
510    * the first transaction is mined)
511    * From MonolithDAO Token.sol
512    * @param _spender The address which will spend the funds.
513    * @param _addedValue The amount of tokens to increase the allowance by.
514    */
515   function increaseApproval(
516     address _spender,
517     uint _addedValue
518   )
519     public
520     returns (bool)
521   {
522     allowed[msg.sender][_spender] = (
523       allowed[msg.sender][_spender].add(_addedValue));
524     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
525     return true;
526   }
527 
528   /**
529    * @dev Decrease the amount of tokens that an owner allowed to a spender.
530    *
531    * approve should be called when allowed[_spender] == 0. To decrement
532    * allowed value is better to use this function to avoid 2 calls (and wait until
533    * the first transaction is mined)
534    * From MonolithDAO Token.sol
535    * @param _spender The address which will spend the funds.
536    * @param _subtractedValue The amount of tokens to decrease the allowance by.
537    */
538   function decreaseApproval(
539     address _spender,
540     uint _subtractedValue
541   )
542     public
543     returns (bool)
544   {
545     uint oldValue = allowed[msg.sender][_spender];
546     if (_subtractedValue > oldValue) {
547       allowed[msg.sender][_spender] = 0;
548     } else {
549       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
550     }
551     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
552     return true;
553   }
554 
555 }
556 
557 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
558 
559 /**
560  * @title Mintable token
561  * @dev Simple ERC20 Token example, with mintable token creation
562  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
563  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
564  */
565 contract MintableToken is StandardToken, Ownable {
566   event Mint(address indexed to, uint256 amount);
567   event MintFinished();
568 
569   bool public mintingFinished = false;
570 
571 
572   modifier canMint() {
573     require(!mintingFinished);
574     _;
575   }
576 
577   modifier hasMintPermission() {
578     require(msg.sender == owner);
579     _;
580   }
581 
582   /**
583    * @dev Function to mint tokens
584    * @param _to The address that will receive the minted tokens.
585    * @param _amount The amount of tokens to mint.
586    * @return A boolean that indicates if the operation was successful.
587    */
588   function mint(
589     address _to,
590     uint256 _amount
591   )
592     hasMintPermission
593     canMint
594     public
595     returns (bool)
596   {
597     totalSupply_ = totalSupply_.add(_amount);
598     balances[_to] = balances[_to].add(_amount);
599     emit Mint(_to, _amount);
600     emit Transfer(address(0), _to, _amount);
601     return true;
602   }
603 
604   /**
605    * @dev Function to stop minting new tokens.
606    * @return True if the operation was successful.
607    */
608   function finishMinting() onlyOwner canMint public returns (bool) {
609     mintingFinished = true;
610     emit MintFinished();
611     return true;
612   }
613 }
614 
615 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
616 
617 /**
618  * @title MintedCrowdsale
619  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
620  * Token ownership should be transferred to MintedCrowdsale for minting.
621  */
622 contract MintedCrowdsale is Crowdsale {
623 
624   /**
625    * @dev Overrides delivery by minting tokens upon purchase.
626    * @param _beneficiary Token purchaser
627    * @param _tokenAmount Number of tokens to be minted
628    */
629   function _deliverTokens(
630     address _beneficiary,
631     uint256 _tokenAmount
632   )
633     internal
634   {
635     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
636   }
637 }
638 
639 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
640 
641 /**
642  * @title CappedCrowdsale
643  * @dev Crowdsale with a limit for total contributions.
644  */
645 contract CappedCrowdsale is Crowdsale {
646   using SafeMath for uint256;
647 
648   uint256 public cap;
649 
650   /**
651    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
652    * @param _cap Max amount of wei to be contributed
653    */
654   constructor(uint256 _cap) public {
655     require(_cap > 0);
656     cap = _cap;
657   }
658 
659   /**
660    * @dev Checks whether the cap has been reached.
661    * @return Whether the cap was reached
662    */
663   function capReached() public view returns (bool) {
664     return weiRaised >= cap;
665   }
666 
667   /**
668    * @dev Extend parent behavior requiring purchase to respect the funding cap.
669    * @param _beneficiary Token purchaser
670    * @param _weiAmount Amount of wei contributed
671    */
672   function _preValidatePurchase(
673     address _beneficiary,
674     uint256 _weiAmount
675   )
676     internal
677   {
678     super._preValidatePurchase(_beneficiary, _weiAmount);
679     require(weiRaised.add(_weiAmount) <= cap);
680   }
681 
682 }
683 
684 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
685 
686 /**
687  * @title TimedCrowdsale
688  * @dev Crowdsale accepting contributions only within a time frame.
689  */
690 contract TimedCrowdsale is Crowdsale {
691   using SafeMath for uint256;
692 
693   uint256 public openingTime;
694   uint256 public closingTime;
695 
696   /**
697    * @dev Reverts if not in crowdsale time range.
698    */
699   modifier onlyWhileOpen {
700     // solium-disable-next-line security/no-block-members
701     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
702     _;
703   }
704 
705   /**
706    * @dev Constructor, takes crowdsale opening and closing times.
707    * @param _openingTime Crowdsale opening time
708    * @param _closingTime Crowdsale closing time
709    */
710   constructor(uint256 _openingTime, uint256 _closingTime) public {
711     // solium-disable-next-line security/no-block-members
712     require(_openingTime >= block.timestamp);
713     require(_closingTime >= _openingTime);
714 
715     openingTime = _openingTime;
716     closingTime = _closingTime;
717   }
718 
719   /**
720    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
721    * @return Whether crowdsale period has elapsed
722    */
723   function hasClosed() public view returns (bool) {
724     // solium-disable-next-line security/no-block-members
725     return block.timestamp > closingTime;
726   }
727 
728   /**
729    * @dev Extend parent behavior requiring to be within contributing period
730    * @param _beneficiary Token purchaser
731    * @param _weiAmount Amount of wei contributed
732    */
733   function _preValidatePurchase(
734     address _beneficiary,
735     uint256 _weiAmount
736   )
737     internal
738     onlyWhileOpen
739   {
740     super._preValidatePurchase(_beneficiary, _weiAmount);
741   }
742 
743 }
744 
745 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
746 
747 /**
748  * @title Pausable
749  * @dev Base contract which allows children to implement an emergency stop mechanism.
750  */
751 contract Pausable is Ownable {
752   event Pause();
753   event Unpause();
754 
755   bool public paused = false;
756 
757 
758   /**
759    * @dev Modifier to make a function callable only when the contract is not paused.
760    */
761   modifier whenNotPaused() {
762     require(!paused);
763     _;
764   }
765 
766   /**
767    * @dev Modifier to make a function callable only when the contract is paused.
768    */
769   modifier whenPaused() {
770     require(paused);
771     _;
772   }
773 
774   /**
775    * @dev called by the owner to pause, triggers stopped state
776    */
777   function pause() onlyOwner whenNotPaused public {
778     paused = true;
779     emit Pause();
780   }
781 
782   /**
783    * @dev called by the owner to unpause, returns to normal state
784    */
785   function unpause() onlyOwner whenPaused public {
786     paused = false;
787     emit Unpause();
788   }
789 }
790 
791 // File: contracts/ZeexCrowdsale.sol
792 
793 contract ZeexCrowdsale is CappedCrowdsale, MintedCrowdsale, TimedCrowdsale, Pausable, ZeexWhitelistedCrowdsale {
794   using SafeMath for uint256;
795 
796   uint256 public presaleOpeningTime;
797   uint256 public presaleClosingTime;
798   uint256 public presaleBonus = 25;
799   uint256 public minPresaleWei;
800   uint256 public maxPresaleWei;
801 
802   bytes1 public constant publicPresale = "0";
803   bytes1 public constant privatePresale = "1";
804 
805   address[] public bonusUsers;
806   mapping(address => mapping(bytes1 => uint256)) public bonusTokens;
807 
808   event Lock(address user, uint amount, bytes1 tokenType);
809   event ReleaseLockedTokens(bytes1 tokenType, address user, uint amount, address to);
810 
811   constructor(uint256 _openingTime, uint256 _closingTime, uint hardCapWei,
812     uint256 _presaleOpeningTime, uint256 _presaleClosingTime,
813     uint256 _minPresaleWei, uint256 _maxPresaleWei,
814     address _wallet, MintableToken _token, address _whitelister) public
815     Crowdsale(5000, _wallet, _token)
816     CappedCrowdsale(hardCapWei)
817     TimedCrowdsale(_openingTime, _closingTime)
818     validPresaleClosingTime(_presaleOpeningTime, _presaleClosingTime)
819     ZeexWhitelistedCrowdsale(_whitelister) {
820 
821     require(_presaleOpeningTime >= openingTime);
822     require(_maxPresaleWei >= _minPresaleWei);
823 
824     presaleOpeningTime = _presaleOpeningTime;
825     presaleClosingTime = _presaleClosingTime;
826     minPresaleWei = _minPresaleWei;
827     maxPresaleWei = _maxPresaleWei;
828 
829     paused = true;
830   }
831 
832   // Overrides
833   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
834     super._preValidatePurchase(_beneficiary, _weiAmount);
835 
836     if (isPresaleOn()) {
837       require(_weiAmount >= minPresaleWei && _weiAmount <= maxPresaleWei);
838     }
839   }
840 
841   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
842     return _weiAmount.mul(rate).add(getPresaleBonusAmount(_weiAmount));
843   }
844 
845   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
846     uint256 weiAmount = msg.value;
847     uint256 lockedAmount = getPresaleBonusAmount(weiAmount);
848     uint256 unlockedAmount = _tokenAmount.sub(lockedAmount);
849 
850     if (lockedAmount > 0) {
851       lockAndDeliverTokens(_beneficiary, lockedAmount, publicPresale);
852     }
853 
854     _deliverTokens(_beneficiary, unlockedAmount);
855   }
856   // End of Overrides
857 
858   function grantTokens(address _beneficiary, uint256 _tokenAmount) public onlyOwner {
859     _deliverTokens(_beneficiary, _tokenAmount);
860   }
861 
862   function grantBonusTokens(address _beneficiary, uint256 _tokenAmount) public onlyOwner {
863     lockAndDeliverTokens(_beneficiary, _tokenAmount, privatePresale);
864   }
865 
866   // lock tokens section
867 
868   function lockAndDeliverTokens(address _beneficiary, uint256 _tokenAmount, bytes1 _type) internal {
869     lockBonusTokens(_beneficiary, _tokenAmount, _type);
870     _deliverTokens(address(this), _tokenAmount);
871   }
872 
873   function lockBonusTokens(address _beneficiary, uint256 _amount, bytes1 _type) internal {
874     if (bonusTokens[_beneficiary][publicPresale] == 0 && bonusTokens[_beneficiary][privatePresale] == 0) {
875       bonusUsers.push(_beneficiary);
876     }
877 
878     bonusTokens[_beneficiary][_type] = bonusTokens[_beneficiary][_type].add(_amount);
879     emit Lock(_beneficiary, _amount, _type);
880   }
881 
882   function getBonusBalance(uint _from, uint _to) public view returns (uint total) {
883     require(_from >= 0 && _to >= _from && _to <= bonusUsers.length);
884 
885     for (uint i = _from; i < _to; i++) {
886       total = total.add(getUserBonusBalance(bonusUsers[i]));
887     }
888   }
889 
890   function getBonusBalanceByType(uint _from, uint _to, bytes1 _type) public view returns (uint total) {
891     require(_from >= 0 && _to >= _from && _to <= bonusUsers.length);
892 
893     for (uint i = _from; i < _to; i++) {
894       total = total.add(bonusTokens[bonusUsers[i]][_type]);
895     }
896   }
897 
898   function getUserBonusBalanceByType(address _user, bytes1 _type) public view returns (uint total) {
899     return bonusTokens[_user][_type];
900   }
901 
902   function getUserBonusBalance(address _user) public view returns (uint total) {
903     total = total.add(getUserBonusBalanceByType(_user, publicPresale));
904     total = total.add(getUserBonusBalanceByType(_user, privatePresale));
905   }
906 
907   function getBonusUsersCount() public view returns(uint count) {
908     return bonusUsers.length;
909   }
910 
911   function releasePublicPresaleBonusTokens(address[] _users, uint _percentage) public onlyOwner {
912     require(_percentage > 0 && _percentage <= 100);
913 
914     for (uint i = 0; i < _users.length; i++) {
915       address user = _users[i];
916       uint tokenBalance = bonusTokens[user][publicPresale];
917       uint amount = tokenBalance.mul(_percentage).div(100);
918       releaseBonusTokens(user, amount, user, publicPresale);
919     }
920   }
921 
922   function releaseUserPrivateBonusTokens(address _user, uint _amount, address _to) public onlyOwner {
923     releaseBonusTokens(_user, _amount, _to, privatePresale);
924   }
925 
926   function releasePrivateBonusTokens(address[] _users, uint[] _amounts) public onlyOwner {
927     for (uint i = 0; i < _users.length; i++) {
928       address user = _users[i];
929       uint amount = _amounts[i];
930       releaseBonusTokens(user, amount, user, privatePresale);
931     }
932   }
933 
934   function releaseBonusTokens(address _user, uint _amount, address _to, bytes1 _type) internal onlyOwner {
935     uint tokenBalance = bonusTokens[_user][_type];
936     require(tokenBalance >= _amount);
937 
938     bonusTokens[_user][_type] = bonusTokens[_user][_type].sub(_amount);
939     token.transfer(_to, _amount);
940     emit ReleaseLockedTokens(_type, _user, _amount, _to);
941   }
942 
943   // Presale section
944   function getPresaleBonusAmount(uint256 _weiAmount) internal view returns (uint256) {
945     uint256 tokenAmount = 0;
946     if (isPresaleOn()) tokenAmount = (_weiAmount.mul(presaleBonus).div(100)).mul(rate);
947 
948     return tokenAmount;
949   }
950 
951   function updatePresaleMinWei(uint _minPresaleWei) public onlyOwner {
952     require(maxPresaleWei >= _minPresaleWei);
953 
954     minPresaleWei = _minPresaleWei;
955   }
956 
957   function updatePresaleMaxWei(uint _maxPresaleWei) public onlyOwner {
958     require(_maxPresaleWei >= minPresaleWei);
959 
960     maxPresaleWei = _maxPresaleWei;
961   }
962 
963   function updatePresaleBonus(uint _presaleBonus) public onlyOwner {
964     presaleBonus = _presaleBonus;
965   }
966 
967   function isPresaleOn() public view returns (bool) {
968     return block.timestamp >= presaleOpeningTime && block.timestamp <= presaleClosingTime;
969   }
970 
971   modifier validPresaleClosingTime(uint _presaleOpeningTime, uint _presaleClosingTime) {
972     require(_presaleOpeningTime >= openingTime);
973     require(_presaleClosingTime >= _presaleOpeningTime);
974     require(_presaleClosingTime <= closingTime);
975     _;
976   }
977 
978   function setOpeningTime(uint256 _openingTime) public onlyOwner {
979     require(_openingTime >= block.timestamp);
980     require(presaleOpeningTime >= _openingTime);
981     require(closingTime >= _openingTime);
982 
983     openingTime = _openingTime;
984   }
985 
986   function setPresaleClosingTime(uint _presaleClosingTime) public onlyOwner validPresaleClosingTime(presaleOpeningTime, _presaleClosingTime) {
987     presaleClosingTime = _presaleClosingTime;
988   }
989 
990   function setPresaleOpeningClosingTime(uint256 _presaleOpeningTime, uint256 _presaleClosingTime) public onlyOwner validPresaleClosingTime(_presaleOpeningTime, _presaleClosingTime) {
991     presaleOpeningTime = _presaleOpeningTime;
992     presaleClosingTime = _presaleClosingTime;
993   }
994 
995   function setClosingTime(uint256 _closingTime) public onlyOwner {
996     require(_closingTime >= block.timestamp);
997     require(_closingTime >= openingTime);
998 
999     closingTime = _closingTime;
1000   }
1001 
1002   function setOpeningClosingTime(uint256 _openingTime, uint256 _closingTime) public onlyOwner {
1003     require(_openingTime >= block.timestamp);
1004     require(_closingTime >= _openingTime);
1005 
1006     openingTime = _openingTime;
1007     closingTime = _closingTime;
1008   }
1009 
1010   function transferTokenOwnership(address _to) public onlyOwner {
1011     Ownable(token).transferOwnership(_to);
1012   }
1013 }