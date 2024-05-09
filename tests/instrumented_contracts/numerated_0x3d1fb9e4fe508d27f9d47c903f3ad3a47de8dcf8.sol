1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() public {
83     owner = msg.sender;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address newOwner) public onlyOwner {
99     require(newOwner != address(0));
100     emit OwnershipTransferred(owner, newOwner);
101     owner = newOwner;
102   }
103 
104 }
105 
106 
107 
108 
109 
110 
111 
112 
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 
127 
128 /**
129  * @title Crowdsale
130  * @dev Crowdsale is a base contract for managing a token crowdsale,
131  * allowing investors to purchase tokens with ether. This contract implements
132  * such functionality in its most fundamental form and can be extended to provide additional
133  * functionality and/or custom behavior.
134  * The external interface represents the basic interface for purchasing tokens, and conform
135  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
136  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
137  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
138  * behavior.
139  */
140 contract Crowdsale {
141   using SafeMath for uint256;
142 
143   // The token being sold
144   ERC20 public token;
145 
146   // Address where funds are collected
147   address public wallet;
148 
149   // How many token units a buyer gets per wei
150   uint256 public rate;
151 
152   // Amount of wei raised
153   uint256 public weiRaised;
154 
155   /**
156    * Event for token purchase logging
157    * @param purchaser who paid for the tokens
158    * @param beneficiary who got the tokens
159    * @param value weis paid for purchase
160    * @param amount amount of tokens purchased
161    */
162   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
163 
164   /**
165    * @param _rate Number of token units a buyer gets per wei
166    * @param _wallet Address where collected funds will be forwarded to
167    * @param _token Address of the token being sold
168    */
169   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
170     require(_rate > 0);
171     require(_wallet != address(0));
172     require(_token != address(0));
173 
174     rate = _rate;
175     wallet = _wallet;
176     token = _token;
177   }
178 
179   // -----------------------------------------
180   // Crowdsale external interface
181   // -----------------------------------------
182 
183   /**
184    * @dev fallback function ***DO NOT OVERRIDE***
185    */
186   function () external payable {
187     buyTokens(msg.sender);
188   }
189 
190   /**
191    * @dev low level token purchase ***DO NOT OVERRIDE***
192    * @param _beneficiary Address performing the token purchase
193    */
194   function buyTokens(address _beneficiary) public payable {
195 
196     uint256 weiAmount = msg.value;
197     _preValidatePurchase(_beneficiary, weiAmount);
198 
199     // calculate token amount to be created
200     uint256 tokens = _getTokenAmount(weiAmount);
201 
202     // update state
203     weiRaised = weiRaised.add(weiAmount);
204 
205     _processPurchase(_beneficiary, tokens);
206     emit TokenPurchase(
207       msg.sender,
208       _beneficiary,
209       weiAmount,
210       tokens
211     );
212 
213     _updatePurchasingState(_beneficiary, weiAmount);
214 
215     _forwardFunds();
216     _postValidatePurchase(_beneficiary, weiAmount);
217   }
218 
219   // -----------------------------------------
220   // Internal interface (extensible)
221   // -----------------------------------------
222 
223   /**
224    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
225    * @param _beneficiary Address performing the token purchase
226    * @param _weiAmount Value in wei involved in the purchase
227    */
228   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
229     require(_beneficiary != address(0));
230     require(_weiAmount != 0);
231   }
232 
233   /**
234    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
235    * @param _beneficiary Address performing the token purchase
236    * @param _weiAmount Value in wei involved in the purchase
237    */
238   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
239     // optional override
240   }
241 
242   /**
243    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
244    * @param _beneficiary Address performing the token purchase
245    * @param _tokenAmount Number of tokens to be emitted
246    */
247   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
248     token.transfer(_beneficiary, _tokenAmount);
249   }
250 
251   /**
252    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
253    * @param _beneficiary Address receiving the tokens
254    * @param _tokenAmount Number of tokens to be purchased
255    */
256   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
257     _deliverTokens(_beneficiary, _tokenAmount);
258   }
259 
260   /**
261    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
262    * @param _beneficiary Address receiving the tokens
263    * @param _weiAmount Value in wei involved in the purchase
264    */
265   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
266     // optional override
267   }
268 
269   /**
270    * @dev Override to extend the way in which ether is converted to tokens.
271    * @param _weiAmount Value in wei to be converted into tokens
272    * @return Number of tokens that can be purchased with the specified _weiAmount
273    */
274   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
275     return _weiAmount.mul(rate);
276   }
277 
278   /**
279    * @dev Determines how ETH is stored/forwarded on purchases.
280    */
281   function _forwardFunds() internal {
282     wallet.transfer(msg.value);
283   }
284 }
285 
286 
287 
288 
289 
290 
291 
292 
293 
294 
295 
296 /**
297  * @title TimedCrowdsale
298  * @dev Crowdsale accepting contributions only within a time frame.
299  */
300 contract TimedCrowdsale is Crowdsale {
301   using SafeMath for uint256;
302 
303   uint256 public openingTime;
304   uint256 public closingTime;
305 
306   /**
307    * @dev Reverts if not in crowdsale time range.
308    */
309   modifier onlyWhileOpen {
310     // solium-disable-next-line security/no-block-members
311     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
312     _;
313   }
314 
315   /**
316    * @dev Constructor, takes crowdsale opening and closing times.
317    * @param _openingTime Crowdsale opening time
318    * @param _closingTime Crowdsale closing time
319    */
320   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
321     // solium-disable-next-line security/no-block-members
322     require(_openingTime >= block.timestamp);
323     require(_closingTime >= _openingTime);
324 
325     openingTime = _openingTime;
326     closingTime = _closingTime;
327   }
328 
329   /**
330    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
331    * @return Whether crowdsale period has elapsed
332    */
333   function hasClosed() public view returns (bool) {
334     // solium-disable-next-line security/no-block-members
335     return block.timestamp > closingTime;
336   }
337 
338   /**
339    * @dev Extend parent behavior requiring to be within contributing period
340    * @param _beneficiary Token purchaser
341    * @param _weiAmount Amount of wei contributed
342    */
343   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
344     super._preValidatePurchase(_beneficiary, _weiAmount);
345   }
346 
347 }
348 
349 
350 
351 /**
352  * @title FinalizableCrowdsale
353  * @dev Extension of Crowdsale where an owner can do extra work
354  * after finishing.
355  */
356 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
357   using SafeMath for uint256;
358 
359   bool public isFinalized = false;
360 
361   event Finalized();
362 
363   /**
364    * @dev Must be called after crowdsale ends, to do some extra finalization
365    * work. Calls the contract's finalization function.
366    */
367   function finalize() onlyOwner public {
368     require(!isFinalized);
369     require(hasClosed());
370 
371     finalization();
372     emit Finalized();
373 
374     isFinalized = true;
375   }
376 
377   /**
378    * @dev Can be overridden to add finalization logic. The overriding function
379    * should call super.finalization() to ensure the chain of finalization is
380    * executed entirely.
381    */
382   function finalization() internal {
383   }
384 
385 }
386 
387 
388 
389 
390 
391 
392 
393 /**
394  * @title CappedCrowdsale
395  * @dev Crowdsale with a limit for total contributions.
396  */
397 contract CappedCrowdsale is Crowdsale {
398   using SafeMath for uint256;
399 
400   uint256 public cap;
401 
402   /**
403    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
404    * @param _cap Max amount of wei to be contributed
405    */
406   function CappedCrowdsale(uint256 _cap) public {
407     require(_cap > 0);
408     cap = _cap;
409   }
410 
411   /**
412    * @dev Checks whether the cap has been reached. 
413    * @return Whether the cap was reached
414    */
415   function capReached() public view returns (bool) {
416     return weiRaised >= cap;
417   }
418 
419   /**
420    * @dev Extend parent behavior requiring purchase to respect the funding cap.
421    * @param _beneficiary Token purchaser
422    * @param _weiAmount Amount of wei contributed
423    */
424   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
425     super._preValidatePurchase(_beneficiary, _weiAmount);
426     require(weiRaised.add(_weiAmount) <= cap);
427   }
428 
429 }
430 
431 
432 
433 
434 
435 
436 
437 
438 /**
439  * @title IndividuallyCappedCrowdsale
440  * @dev Crowdsale with per-user caps.
441  */
442 contract IndividuallyCappedCrowdsale is Crowdsale, Ownable {
443   using SafeMath for uint256;
444 
445   mapping(address => uint256) public contributions;
446   mapping(address => uint256) public caps;
447 
448   /**
449    * @dev Sets a specific user's maximum contribution.
450    * @param _beneficiary Address to be capped
451    * @param _cap Wei limit for individual contribution
452    */
453   function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner {
454     caps[_beneficiary] = _cap;
455   }
456 
457   /**
458    * @dev Sets a group of users' maximum contribution.
459    * @param _beneficiaries List of addresses to be capped
460    * @param _cap Wei limit for individual contribution
461    */
462   function setGroupCap(address[] _beneficiaries, uint256 _cap) external onlyOwner {
463     for (uint256 i = 0; i < _beneficiaries.length; i++) {
464       caps[_beneficiaries[i]] = _cap;
465     }
466   }
467 
468   /**
469    * @dev Returns the cap of a specific user.
470    * @param _beneficiary Address whose cap is to be checked
471    * @return Current cap for individual user
472    */
473   function getUserCap(address _beneficiary) public view returns (uint256) {
474     return caps[_beneficiary];
475   }
476 
477   /**
478    * @dev Returns the amount contributed so far by a sepecific user.
479    * @param _beneficiary Address of contributor
480    * @return User contribution so far
481    */
482   function getUserContribution(address _beneficiary) public view returns (uint256) {
483     return contributions[_beneficiary];
484   }
485 
486   /**
487    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
488    * @param _beneficiary Token purchaser
489    * @param _weiAmount Amount of wei contributed
490    */
491   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
492     super._preValidatePurchase(_beneficiary, _weiAmount);
493     require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);
494   }
495 
496   /**
497    * @dev Extend parent behavior to update user contributions
498    * @param _beneficiary Token purchaser
499    * @param _weiAmount Amount of wei contributed
500    */
501   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
502     super._updatePurchasingState(_beneficiary, _weiAmount);
503     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
504   }
505 
506 }
507 
508 
509 
510 
511 
512 
513 
514 /**
515  * @title WhitelistedCrowdsale
516  * @dev Crowdsale in which only whitelisted users can contribute.
517  */
518 contract WhitelistedCrowdsale is Crowdsale, Ownable {
519 
520   mapping(address => bool) public whitelist;
521 
522   /**
523    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
524    */
525   modifier isWhitelisted(address _beneficiary) {
526     require(whitelist[_beneficiary]);
527     _;
528   }
529 
530   /**
531    * @dev Adds single address to whitelist.
532    * @param _beneficiary Address to be added to the whitelist
533    */
534   function addToWhitelist(address _beneficiary) external onlyOwner {
535     whitelist[_beneficiary] = true;
536   }
537 
538   /**
539    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
540    * @param _beneficiaries Addresses to be added to the whitelist
541    */
542   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
543     for (uint256 i = 0; i < _beneficiaries.length; i++) {
544       whitelist[_beneficiaries[i]] = true;
545     }
546   }
547 
548   /**
549    * @dev Removes single address from whitelist.
550    * @param _beneficiary Address to be removed to the whitelist
551    */
552   function removeFromWhitelist(address _beneficiary) external onlyOwner {
553     whitelist[_beneficiary] = false;
554   }
555 
556   /**
557    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
558    * @param _beneficiary Token beneficiary
559    * @param _weiAmount Amount of wei contributed
560    */
561   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
562     super._preValidatePurchase(_beneficiary, _weiAmount);
563   }
564 
565 }
566 
567 
568 
569 
570 
571 
572 
573 /**
574  * @title Destructible
575  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
576  */
577 contract Destructible is Ownable {
578 
579   function Destructible() public payable { }
580 
581   /**
582    * @dev Transfers the current balance to the owner and terminates the contract.
583    */
584   function destroy() onlyOwner public {
585     selfdestruct(owner);
586   }
587 
588   function destroyAndSend(address _recipient) onlyOwner public {
589     selfdestruct(_recipient);
590   }
591 }
592 
593 
594 
595 
596 
597 
598 
599 /**
600  * @title Pausable
601  * @dev Base contract which allows children to implement an emergency stop mechanism.
602  */
603 contract Pausable is Ownable {
604   event Pause();
605   event Unpause();
606 
607   bool public paused = false;
608 
609 
610   /**
611    * @dev Modifier to make a function callable only when the contract is not paused.
612    */
613   modifier whenNotPaused() {
614     require(!paused);
615     _;
616   }
617 
618   /**
619    * @dev Modifier to make a function callable only when the contract is paused.
620    */
621   modifier whenPaused() {
622     require(paused);
623     _;
624   }
625 
626   /**
627    * @dev called by the owner to pause, triggers stopped state
628    */
629   function pause() onlyOwner whenNotPaused public {
630     paused = true;
631     emit Pause();
632   }
633 
634   /**
635    * @dev called by the owner to unpause, returns to normal state
636    */
637   function unpause() onlyOwner whenPaused public {
638     paused = false;
639     emit Unpause();
640   }
641 }
642 
643 
644 
645 
646 
647 
648 
649 
650 
651 
652 
653 
654 
655 
656 /**
657  * @title Basic token
658  * @dev Basic version of StandardToken, with no allowances.
659  */
660 contract BasicToken is ERC20Basic {
661   using SafeMath for uint256;
662 
663   mapping(address => uint256) balances;
664 
665   uint256 totalSupply_;
666 
667   /**
668   * @dev total number of tokens in existence
669   */
670   function totalSupply() public view returns (uint256) {
671     return totalSupply_;
672   }
673 
674   /**
675   * @dev transfer token for a specified address
676   * @param _to The address to transfer to.
677   * @param _value The amount to be transferred.
678   */
679   function transfer(address _to, uint256 _value) public returns (bool) {
680     require(_to != address(0));
681     require(_value <= balances[msg.sender]);
682 
683     balances[msg.sender] = balances[msg.sender].sub(_value);
684     balances[_to] = balances[_to].add(_value);
685     emit Transfer(msg.sender, _to, _value);
686     return true;
687   }
688 
689   /**
690   * @dev Gets the balance of the specified address.
691   * @param _owner The address to query the the balance of.
692   * @return An uint256 representing the amount owned by the passed address.
693   */
694   function balanceOf(address _owner) public view returns (uint256) {
695     return balances[_owner];
696   }
697 
698 }
699 
700 
701 
702 
703 /**
704  * @title Standard ERC20 token
705  *
706  * @dev Implementation of the basic standard token.
707  * @dev https://github.com/ethereum/EIPs/issues/20
708  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
709  */
710 contract StandardToken is ERC20, BasicToken {
711 
712   mapping (address => mapping (address => uint256)) internal allowed;
713 
714 
715   /**
716    * @dev Transfer tokens from one address to another
717    * @param _from address The address which you want to send tokens from
718    * @param _to address The address which you want to transfer to
719    * @param _value uint256 the amount of tokens to be transferred
720    */
721   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
722     require(_to != address(0));
723     require(_value <= balances[_from]);
724     require(_value <= allowed[_from][msg.sender]);
725 
726     balances[_from] = balances[_from].sub(_value);
727     balances[_to] = balances[_to].add(_value);
728     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
729     emit Transfer(_from, _to, _value);
730     return true;
731   }
732 
733   /**
734    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
735    *
736    * Beware that changing an allowance with this method brings the risk that someone may use both the old
737    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
738    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
739    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
740    * @param _spender The address which will spend the funds.
741    * @param _value The amount of tokens to be spent.
742    */
743   function approve(address _spender, uint256 _value) public returns (bool) {
744     allowed[msg.sender][_spender] = _value;
745     emit Approval(msg.sender, _spender, _value);
746     return true;
747   }
748 
749   /**
750    * @dev Function to check the amount of tokens that an owner allowed to a spender.
751    * @param _owner address The address which owns the funds.
752    * @param _spender address The address which will spend the funds.
753    * @return A uint256 specifying the amount of tokens still available for the spender.
754    */
755   function allowance(address _owner, address _spender) public view returns (uint256) {
756     return allowed[_owner][_spender];
757   }
758 
759   /**
760    * @dev Increase the amount of tokens that an owner allowed to a spender.
761    *
762    * approve should be called when allowed[_spender] == 0. To increment
763    * allowed value is better to use this function to avoid 2 calls (and wait until
764    * the first transaction is mined)
765    * From MonolithDAO Token.sol
766    * @param _spender The address which will spend the funds.
767    * @param _addedValue The amount of tokens to increase the allowance by.
768    */
769   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
770     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
771     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
772     return true;
773   }
774 
775   /**
776    * @dev Decrease the amount of tokens that an owner allowed to a spender.
777    *
778    * approve should be called when allowed[_spender] == 0. To decrement
779    * allowed value is better to use this function to avoid 2 calls (and wait until
780    * the first transaction is mined)
781    * From MonolithDAO Token.sol
782    * @param _spender The address which will spend the funds.
783    * @param _subtractedValue The amount of tokens to decrease the allowance by.
784    */
785   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
786     uint oldValue = allowed[msg.sender][_spender];
787     if (_subtractedValue > oldValue) {
788       allowed[msg.sender][_spender] = 0;
789     } else {
790       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
791     }
792     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
793     return true;
794   }
795 
796 }
797 
798 
799 
800 
801 /**
802  * @title Mintable token
803  * @dev Simple ERC20 Token example, with mintable token creation
804  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
805  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
806  */
807 contract MintableToken is StandardToken, Ownable {
808   event Mint(address indexed to, uint256 amount);
809   event MintFinished();
810 
811   bool public mintingFinished = false;
812 
813 
814   modifier canMint() {
815     require(!mintingFinished);
816     _;
817   }
818 
819   /**
820    * @dev Function to mint tokens
821    * @param _to The address that will receive the minted tokens.
822    * @param _amount The amount of tokens to mint.
823    * @return A boolean that indicates if the operation was successful.
824    */
825   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
826     totalSupply_ = totalSupply_.add(_amount);
827     balances[_to] = balances[_to].add(_amount);
828     emit Mint(_to, _amount);
829     emit Transfer(address(0), _to, _amount);
830     return true;
831   }
832 
833   /**
834    * @dev Function to stop minting new tokens.
835    * @return True if the operation was successful.
836    */
837   function finishMinting() onlyOwner canMint public returns (bool) {
838     mintingFinished = true;
839     emit MintFinished();
840     return true;
841   }
842 }
843 
844 
845 contract AAToken is MintableToken{
846     string public constant name = "AAToken";
847     string public constant symbol = "AAT";
848     uint8 public constant decimals = 18;
849 }
850 
851 
852 contract AATokenPrivatesale is FinalizableCrowdsale, CappedCrowdsale, IndividuallyCappedCrowdsale, WhitelistedCrowdsale, Destructible, Pausable {
853     function AATokenPrivatesale
854         (
855             uint256 _cap,
856             uint256 _openingTime,
857             uint256 _closingTime,
858             uint256 _rate,
859             address _wallet,
860             MintableToken _token
861         )
862         public
863         Crowdsale(_rate, _wallet, _token)
864         TimedCrowdsale(_openingTime, _closingTime)
865         CappedCrowdsale(_cap) {
866 
867         }
868 
869     function returnRemainingTokens() onlyOwner public {
870         require(paused);
871         uint256 remaining = token.balanceOf(this);
872         token.transfer(owner, remaining);
873     }
874 }