1 pragma solidity ^0.4.24;
2 
3 // File: contracts\zeppelin\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
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
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: contracts\zeppelin\math\SafeMath.sol
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (a == 0) {
80       return 0;
81     }
82 
83     c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return a / b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 
116 // File: contracts\zeppelin\token\ERC20\ERC20Basic.sol
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: contracts\zeppelin\token\ERC20\BasicToken.sol
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   uint256 totalSupply_;
142 
143   /**
144   * @dev total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 // File: contracts\zeppelin\token\ERC20\ERC20.sol
177 
178 /**
179  * @title ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/20
181  */
182 contract ERC20 is ERC20Basic {
183   function allowance(address owner, address spender)
184     public view returns (uint256);
185 
186   function transferFrom(address from, address to, uint256 value)
187     public returns (bool);
188 
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(
191     address indexed owner,
192     address indexed spender,
193     uint256 value
194   );
195 }
196 
197 // File: contracts\zeppelin\token\ERC20\StandardToken.sol
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(
218     address _from,
219     address _to,
220     uint256 _value
221   )
222     public
223     returns (bool)
224   {
225     require(_to != address(0));
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228 
229     balances[_from] = balances[_from].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232     emit Transfer(_from, _to, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238    *
239    * Beware that changing an allowance with this method brings the risk that someone may use both the old
240    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243    * @param _spender The address which will spend the funds.
244    * @param _value The amount of tokens to be spent.
245    */
246   function approve(address _spender, uint256 _value) public returns (bool) {
247     allowed[msg.sender][_spender] = _value;
248     emit Approval(msg.sender, _spender, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Function to check the amount of tokens that an owner allowed to a spender.
254    * @param _owner address The address which owns the funds.
255    * @param _spender address The address which will spend the funds.
256    * @return A uint256 specifying the amount of tokens still available for the spender.
257    */
258   function allowance(
259     address _owner,
260     address _spender
261    )
262     public
263     view
264     returns (uint256)
265   {
266     return allowed[_owner][_spender];
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _addedValue The amount of tokens to increase the allowance by.
278    */
279   function increaseApproval(
280     address _spender,
281     uint _addedValue
282   )
283     public
284     returns (bool)
285   {
286     allowed[msg.sender][_spender] = (
287       allowed[msg.sender][_spender].add(_addedValue));
288     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Decrease the amount of tokens that an owner allowed to a spender.
294    *
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue > oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: contracts\zeppelin\token\ERC20\MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
327  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
328  */
329 contract MintableToken is StandardToken, Ownable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   modifier hasMintPermission() {
342     require(msg.sender == owner);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(
353     address _to,
354     uint256 _amount
355   )
356     hasMintPermission
357     canMint
358     public
359     returns (bool)
360   {
361     totalSupply_ = totalSupply_.add(_amount);
362     balances[_to] = balances[_to].add(_amount);
363     emit Mint(_to, _amount);
364     emit Transfer(address(0), _to, _amount);
365     return true;
366   }
367 
368   /**
369    * @dev Function to stop minting new tokens.
370    * @return True if the operation was successful.
371    */
372   function finishMinting() onlyOwner canMint public returns (bool) {
373     mintingFinished = true;
374     emit MintFinished();
375     return true;
376   }
377 }
378 
379 // File: contracts\zeppelin\token\ERC20\CappedToken.sol
380 
381 /**
382  * @title Capped token
383  * @dev Mintable token with a token cap.
384  */
385 contract CappedToken is MintableToken {
386 
387   uint256 public cap;
388 
389   constructor(uint256 _cap) public {
390     require(_cap > 0);
391     cap = _cap;
392   }
393 
394   /**
395    * @dev Function to mint tokens
396    * @param _to The address that will receive the minted tokens.
397    * @param _amount The amount of tokens to mint.
398    * @return A boolean that indicates if the operation was successful.
399    */
400   function mint(
401     address _to,
402     uint256 _amount
403   )
404     onlyOwner
405     canMint
406     public
407     returns (bool)
408   {
409     require(totalSupply_.add(_amount) <= cap);
410 
411     return super.mint(_to, _amount);
412   }
413 
414 }
415 
416 // File: contracts\zeppelin\lifecycle\Pausable.sol
417 
418 /**
419  * @title Pausable
420  * @dev Base contract which allows children to implement an emergency stop mechanism.
421  */
422 contract Pausable is Ownable {
423   event Pause();
424   event Unpause();
425 
426   bool public paused = false;
427 
428 
429   /**
430    * @dev Modifier to make a function callable only when the contract is not paused.
431    */
432   modifier whenNotPaused() {
433     require(!paused);
434     _;
435   }
436 
437   /**
438    * @dev Modifier to make a function callable only when the contract is paused.
439    */
440   modifier whenPaused() {
441     require(paused);
442     _;
443   }
444 
445   /**
446    * @dev called by the owner to pause, triggers stopped state
447    */
448   function pause() onlyOwner whenNotPaused public {
449     paused = true;
450     emit Pause();
451   }
452 
453   /**
454    * @dev called by the owner to unpause, returns to normal state
455    */
456   function unpause() onlyOwner whenPaused public {
457     paused = false;
458     emit Unpause();
459   }
460 }
461 
462 // File: contracts\zeppelin\token\ERC20\PausableToken.sol
463 
464 /**
465  * @title Pausable token
466  * @dev StandardToken modified with pausable transfers.
467  **/
468 contract PausableToken is StandardToken, Pausable {
469 
470   function transfer(
471     address _to,
472     uint256 _value
473   )
474     public
475     whenNotPaused
476     returns (bool)
477   {
478     return super.transfer(_to, _value);
479   }
480 
481   function transferFrom(
482     address _from,
483     address _to,
484     uint256 _value
485   )
486     public
487     whenNotPaused
488     returns (bool)
489   {
490     return super.transferFrom(_from, _to, _value);
491   }
492 
493   function approve(
494     address _spender,
495     uint256 _value
496   )
497     public
498     whenNotPaused
499     returns (bool)
500   {
501     return super.approve(_spender, _value);
502   }
503 
504   function increaseApproval(
505     address _spender,
506     uint _addedValue
507   )
508     public
509     whenNotPaused
510     returns (bool success)
511   {
512     return super.increaseApproval(_spender, _addedValue);
513   }
514 
515   function decreaseApproval(
516     address _spender,
517     uint _subtractedValue
518   )
519     public
520     whenNotPaused
521     returns (bool success)
522   {
523     return super.decreaseApproval(_spender, _subtractedValue);
524   }
525 }
526 
527 // File: contracts\DroneMadnessToken.sol
528 
529 /**
530  * @title Drone Madness Token
531  * @dev Drone Madness Token - Token code for the Drone Madness Project
532  * This is a standard ERC20 token with:
533  * - a cap
534  * - ability to pause transfers
535  */
536 contract DroneMadnessToken is CappedToken, PausableToken {
537 
538     string public constant name                 = "Drone Madness Token";
539     string public constant symbol               = "DRNMD";
540     uint public constant decimals               = 18;
541 
542     constructor(uint256 _totalSupply) 
543         CappedToken(_totalSupply) public {
544         paused = true;
545     }
546 }
547 
548 // File: contracts\zeppelin\token\ERC20\SafeERC20.sol
549 
550 /**
551  * @title SafeERC20
552  * @dev Wrappers around ERC20 operations that throw on failure.
553  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
554  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
555  */
556 library SafeERC20 {
557   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
558     require(token.transfer(to, value));
559   }
560 
561   function safeTransferFrom(
562     ERC20 token,
563     address from,
564     address to,
565     uint256 value
566   )
567     internal
568   {
569     require(token.transferFrom(from, to, value));
570   }
571 
572   function safeApprove(ERC20 token, address spender, uint256 value) internal {
573     require(token.approve(spender, value));
574   }
575 }
576 
577 // File: contracts\TokenPool.sol
578 
579 /**
580  * @title TokenPool 
581  * @dev Token Pool contract used to store tokens for special purposes
582  * The pool can receive tokens and can transfer tokens to multiple beneficiaries.
583  * It can be used for airdrops or similar cases.
584  */
585 contract TokenPool is Ownable {
586     using SafeMath for uint256;
587     using SafeERC20 for ERC20Basic;
588 
589     ERC20Basic public token;
590     uint256 public cap;
591     uint256 public totalAllocated;
592 
593     /**
594      * @dev Contract constructor
595      * @param _token address token that will be stored in the pool
596      * @param _cap uint256 predefined cap of the pool
597      */
598     constructor(address _token, uint256 _cap) public {
599         token = ERC20Basic(_token);
600         cap = _cap;
601         totalAllocated = 0;
602     }
603 
604     /**
605      * @dev Transfer different amounts of tokens to multiple beneficiaries 
606      * @param _beneficiaries addresses of the beneficiaries
607      * @param _amounts uint256[] amounts for each beneficiary
608      */
609     function allocate(address[] _beneficiaries, uint256[] _amounts) public onlyOwner {
610         for (uint256 i = 0; i < _beneficiaries.length; i ++) {
611             require(totalAllocated.add(_amounts[i]) <= cap);
612             token.safeTransfer(_beneficiaries[i], _amounts[i]);
613             totalAllocated.add(_amounts[i]);
614         }
615     }
616 
617     /**
618      * @dev Transfer the same amount of tokens to multiple beneficiaries 
619      * @param _beneficiaries addresses of the beneficiaries
620      * @param _amounts uint256[] amounts for each beneficiary
621      */
622     function allocateEqual(address[] _beneficiaries, uint256 _amounts) public onlyOwner {
623         uint256 totalAmount = _amounts.mul(_beneficiaries.length);
624         require(totalAllocated.add(totalAmount) <= cap);
625         require(token.balanceOf(this) >= totalAmount);
626 
627         for (uint256 i = 0; i < _beneficiaries.length; i ++) {
628             token.safeTransfer(_beneficiaries[i], _amounts);
629             totalAllocated.add(_amounts);
630         }
631     }
632 }
633 
634 // File: contracts\zeppelin\crowdsale\Crowdsale.sol
635 
636 /**
637  * @title Crowdsale
638  * @dev Crowdsale is a base contract for managing a token crowdsale,
639  * allowing investors to purchase tokens with ether. This contract implements
640  * such functionality in its most fundamental form and can be extended to provide additional
641  * functionality and/or custom behavior.
642  * The external interface represents the basic interface for purchasing tokens, and conform
643  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
644  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
645  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
646  * behavior.
647  */
648 contract Crowdsale {
649   using SafeMath for uint256;
650 
651   // The token being sold
652   ERC20 public token;
653 
654   // Address where funds are collected
655   address public wallet;
656 
657   // How many token units a buyer gets per wei.
658   // The rate is the conversion between wei and the smallest and indivisible token unit.
659   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
660   // 1 wei will give you 1 unit, or 0.001 TOK.
661   uint256 public rate;
662 
663   // Amount of wei raised
664   uint256 public weiRaised;
665 
666   /**
667    * Event for token purchase logging
668    * @param purchaser who paid for the tokens
669    * @param beneficiary who got the tokens
670    * @param value weis paid for purchase
671    * @param amount amount of tokens purchased
672    */
673   event TokenPurchase(
674     address indexed purchaser,
675     address indexed beneficiary,
676     uint256 value,
677     uint256 amount
678   );
679 
680   /**
681    * @param _rate Number of token units a buyer gets per wei
682    * @param _wallet Address where collected funds will be forwarded to
683    * @param _token Address of the token being sold
684    */
685   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
686     require(_rate > 0);
687     require(_wallet != address(0));
688     require(_token != address(0));
689 
690     rate = _rate;
691     wallet = _wallet;
692     token = _token;
693   }
694 
695   // -----------------------------------------
696   // Crowdsale external interface
697   // -----------------------------------------
698 
699   /**
700    * @dev fallback function ***DO NOT OVERRIDE***
701    */
702   function () external payable {
703     buyTokens(msg.sender);
704   }
705 
706   /**
707    * @dev low level token purchase ***DO NOT OVERRIDE***
708    * @param _beneficiary Address performing the token purchase
709    */
710   function buyTokens(address _beneficiary) public payable {
711 
712     uint256 weiAmount = msg.value;
713     _preValidatePurchase(_beneficiary, weiAmount);
714 
715     // calculate token amount to be created
716     uint256 tokens = _getTokenAmount(weiAmount);
717 
718     // update state
719     weiRaised = weiRaised.add(weiAmount);
720 
721     _processPurchase(_beneficiary, tokens);
722     emit TokenPurchase(
723       msg.sender,
724       _beneficiary,
725       weiAmount,
726       tokens
727     );
728 
729     _updatePurchasingState(_beneficiary, weiAmount);
730 
731     _forwardFunds();
732     _postValidatePurchase(_beneficiary, weiAmount);
733   }
734 
735   // -----------------------------------------
736   // Internal interface (extensible)
737   // -----------------------------------------
738 
739   /**
740    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
741    * @param _beneficiary Address performing the token purchase
742    * @param _weiAmount Value in wei involved in the purchase
743    */
744   function _preValidatePurchase(
745     address _beneficiary,
746     uint256 _weiAmount
747   )
748     internal
749   {
750     require(_beneficiary != address(0));
751     require(_weiAmount != 0);
752   }
753 
754   /**
755    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
756    * @param _beneficiary Address performing the token purchase
757    * @param _weiAmount Value in wei involved in the purchase
758    */
759   function _postValidatePurchase(
760     address _beneficiary,
761     uint256 _weiAmount
762   )
763     internal
764   {
765     // optional override
766   }
767 
768   /**
769    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
770    * @param _beneficiary Address performing the token purchase
771    * @param _tokenAmount Number of tokens to be emitted
772    */
773   function _deliverTokens(
774     address _beneficiary,
775     uint256 _tokenAmount
776   )
777     internal
778   {
779     token.transfer(_beneficiary, _tokenAmount);
780   }
781 
782   /**
783    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
784    * @param _beneficiary Address receiving the tokens
785    * @param _tokenAmount Number of tokens to be purchased
786    */
787   function _processPurchase(
788     address _beneficiary,
789     uint256 _tokenAmount
790   )
791     internal
792   {
793     _deliverTokens(_beneficiary, _tokenAmount);
794   }
795 
796   /**
797    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
798    * @param _beneficiary Address receiving the tokens
799    * @param _weiAmount Value in wei involved in the purchase
800    */
801   function _updatePurchasingState(
802     address _beneficiary,
803     uint256 _weiAmount
804   )
805     internal
806   {
807     // optional override
808   }
809 
810   /**
811    * @dev Override to extend the way in which ether is converted to tokens.
812    * @param _weiAmount Value in wei to be converted into tokens
813    * @return Number of tokens that can be purchased with the specified _weiAmount
814    */
815   function _getTokenAmount(uint256 _weiAmount)
816     internal view returns (uint256)
817   {
818     return _weiAmount.mul(rate);
819   }
820 
821   /**
822    * @dev Determines how ETH is stored/forwarded on purchases.
823    */
824   function _forwardFunds() internal {
825     wallet.transfer(msg.value);
826   }
827 }
828 
829 // File: contracts\zeppelin\crowdsale\validation\TimedCrowdsale.sol
830 
831 /**
832  * @title TimedCrowdsale
833  * @dev Crowdsale accepting contributions only within a time frame.
834  */
835 contract TimedCrowdsale is Crowdsale {
836   using SafeMath for uint256;
837 
838   uint256 public openingTime;
839   uint256 public closingTime;
840 
841   /**
842    * @dev Reverts if not in crowdsale time range.
843    */
844   modifier onlyWhileOpen {
845     // solium-disable-next-line security/no-block-members
846     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
847     _;
848   }
849 
850   /**
851    * @dev Constructor, takes crowdsale opening and closing times.
852    * @param _openingTime Crowdsale opening time
853    * @param _closingTime Crowdsale closing time
854    */
855   constructor(uint256 _openingTime, uint256 _closingTime) public {
856     // solium-disable-next-line security/no-block-members
857     require(_openingTime >= block.timestamp);
858     require(_closingTime >= _openingTime);
859 
860     openingTime = _openingTime;
861     closingTime = _closingTime;
862   }
863 
864   /**
865    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
866    * @return Whether crowdsale period has elapsed
867    */
868   function hasClosed() public view returns (bool) {
869     // solium-disable-next-line security/no-block-members
870     return block.timestamp > closingTime;
871   }
872 
873   /**
874    * @dev Extend parent behavior requiring to be within contributing period
875    * @param _beneficiary Token purchaser
876    * @param _weiAmount Amount of wei contributed
877    */
878   function _preValidatePurchase(
879     address _beneficiary,
880     uint256 _weiAmount
881   )
882     internal
883     onlyWhileOpen
884   {
885     super._preValidatePurchase(_beneficiary, _weiAmount);
886   }
887 
888 }
889 
890 // File: contracts\zeppelin\crowdsale\distribution\FinalizableCrowdsale.sol
891 
892 /**
893  * @title FinalizableCrowdsale
894  * @dev Extension of Crowdsale where an owner can do extra work
895  * after finishing.
896  */
897 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
898   using SafeMath for uint256;
899 
900   bool public isFinalized = false;
901 
902   event Finalized();
903 
904   /**
905    * @dev Must be called after crowdsale ends, to do some extra finalization
906    * work. Calls the contract's finalization function.
907    */
908   function finalize() onlyOwner public {
909     require(!isFinalized);
910     require(hasClosed());
911 
912     finalization();
913     emit Finalized();
914 
915     isFinalized = true;
916   }
917 
918   /**
919    * @dev Can be overridden to add finalization logic. The overriding function
920    * should call super.finalization() to ensure the chain of finalization is
921    * executed entirely.
922    */
923   function finalization() internal {
924   }
925 
926 }
927 
928 // File: contracts\zeppelin\crowdsale\distribution\utils\RefundVault.sol
929 
930 /**
931  * @title RefundVault
932  * @dev This contract is used for storing funds while a crowdsale
933  * is in progress. Supports refunding the money if crowdsale fails,
934  * and forwarding it if crowdsale is successful.
935  */
936 contract RefundVault is Ownable {
937   using SafeMath for uint256;
938 
939   enum State { Active, Refunding, Closed }
940 
941   mapping (address => uint256) public deposited;
942   address public wallet;
943   State public state;
944 
945   event Closed();
946   event RefundsEnabled();
947   event Refunded(address indexed beneficiary, uint256 weiAmount);
948 
949   /**
950    * @param _wallet Vault address
951    */
952   constructor(address _wallet) public {
953     require(_wallet != address(0));
954     wallet = _wallet;
955     state = State.Active;
956   }
957 
958   /**
959    * @param investor Investor address
960    */
961   function deposit(address investor) onlyOwner public payable {
962     require(state == State.Active);
963     deposited[investor] = deposited[investor].add(msg.value);
964   }
965 
966   function close() onlyOwner public {
967     require(state == State.Active);
968     state = State.Closed;
969     emit Closed();
970     wallet.transfer(address(this).balance);
971   }
972 
973   function enableRefunds() onlyOwner public {
974     require(state == State.Active);
975     state = State.Refunding;
976     emit RefundsEnabled();
977   }
978 
979   /**
980    * @param investor Investor address
981    */
982   function refund(address investor) public {
983     require(state == State.Refunding);
984     uint256 depositedValue = deposited[investor];
985     deposited[investor] = 0;
986     investor.transfer(depositedValue);
987     emit Refunded(investor, depositedValue);
988   }
989 }
990 
991 // File: contracts\zeppelin\crowdsale\distribution\RefundableCrowdsale.sol
992 
993 /**
994  * @title RefundableCrowdsale
995  * @dev Extension of Crowdsale contract that adds a funding goal, and
996  * the possibility of users getting a refund if goal is not met.
997  * Uses a RefundVault as the crowdsale's vault.
998  */
999 contract RefundableCrowdsale is FinalizableCrowdsale {
1000   using SafeMath for uint256;
1001 
1002   // minimum amount of funds to be raised in weis
1003   uint256 public goal;
1004 
1005   // refund vault used to hold funds while crowdsale is running
1006   RefundVault public vault;
1007 
1008   /**
1009    * @dev Constructor, creates RefundVault.
1010    * @param _goal Funding goal
1011    */
1012   constructor(uint256 _goal) public {
1013     require(_goal > 0);
1014     vault = new RefundVault(wallet);
1015     goal = _goal;
1016   }
1017 
1018   /**
1019    * @dev Investors can claim refunds here if crowdsale is unsuccessful
1020    */
1021   function claimRefund() public {
1022     require(isFinalized);
1023     require(!goalReached());
1024 
1025     vault.refund(msg.sender);
1026   }
1027 
1028   /**
1029    * @dev Checks whether funding goal was reached.
1030    * @return Whether funding goal was reached
1031    */
1032   function goalReached() public view returns (bool) {
1033     return weiRaised >= goal;
1034   }
1035 
1036   /**
1037    * @dev vault finalization task, called when owner calls finalize()
1038    */
1039   function finalization() internal {
1040     if (goalReached()) {
1041       vault.close();
1042     } else {
1043       vault.enableRefunds();
1044     }
1045 
1046     super.finalization();
1047   }
1048 
1049   /**
1050    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
1051    */
1052   function _forwardFunds() internal {
1053     vault.deposit.value(msg.value)(msg.sender);
1054   }
1055 
1056 }
1057 
1058 // File: contracts\zeppelin\crowdsale\emission\MintedCrowdsale.sol
1059 
1060 /**
1061  * @title MintedCrowdsale
1062  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1063  * Token ownership should be transferred to MintedCrowdsale for minting.
1064  */
1065 contract MintedCrowdsale is Crowdsale {
1066 
1067   /**
1068    * @dev Overrides delivery by minting tokens upon purchase.
1069    * @param _beneficiary Token purchaser
1070    * @param _tokenAmount Number of tokens to be minted
1071    */
1072   function _deliverTokens(
1073     address _beneficiary,
1074     uint256 _tokenAmount
1075   )
1076     internal
1077   {
1078     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
1079   }
1080 }
1081 
1082 // File: contracts\zeppelin\crowdsale\validation\CappedCrowdsale.sol
1083 
1084 /**
1085  * @title CappedCrowdsale
1086  * @dev Crowdsale with a limit for total contributions.
1087  */
1088 contract CappedCrowdsale is Crowdsale {
1089   using SafeMath for uint256;
1090 
1091   uint256 public cap;
1092 
1093   /**
1094    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
1095    * @param _cap Max amount of wei to be contributed
1096    */
1097   constructor(uint256 _cap) public {
1098     require(_cap > 0);
1099     cap = _cap;
1100   }
1101 
1102   /**
1103    * @dev Checks whether the cap has been reached.
1104    * @return Whether the cap was reached
1105    */
1106   function capReached() public view returns (bool) {
1107     return weiRaised >= cap;
1108   }
1109 
1110   /**
1111    * @dev Extend parent behavior requiring purchase to respect the funding cap.
1112    * @param _beneficiary Token purchaser
1113    * @param _weiAmount Amount of wei contributed
1114    */
1115   function _preValidatePurchase(
1116     address _beneficiary,
1117     uint256 _weiAmount
1118   )
1119     internal
1120   {
1121     super._preValidatePurchase(_beneficiary, _weiAmount);
1122     require(weiRaised.add(_weiAmount) <= cap);
1123   }
1124 
1125 }
1126 
1127 // File: contracts\zeppelin\crowdsale\validation\WhitelistedCrowdsale.sol
1128 
1129 /**
1130  * @title WhitelistedCrowdsale
1131  * @dev Crowdsale in which only whitelisted users can contribute.
1132  */
1133 contract WhitelistedCrowdsale is Crowdsale, Ownable {
1134 
1135   mapping(address => bool) public whitelist;
1136 
1137   /**
1138    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
1139    */
1140   modifier isWhitelisted(address _beneficiary) {
1141     require(whitelist[_beneficiary]);
1142     _;
1143   }
1144 
1145   /**
1146    * @dev Adds single address to whitelist.
1147    * @param _beneficiary Address to be added to the whitelist
1148    */
1149   function addToWhitelist(address _beneficiary) external onlyOwner {
1150     whitelist[_beneficiary] = true;
1151   }
1152 
1153   /**
1154    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
1155    * @param _beneficiaries Addresses to be added to the whitelist
1156    */
1157   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
1158     for (uint256 i = 0; i < _beneficiaries.length; i++) {
1159       whitelist[_beneficiaries[i]] = true;
1160     }
1161   }
1162 
1163   /**
1164    * @dev Removes single address from whitelist.
1165    * @param _beneficiary Address to be removed to the whitelist
1166    */
1167   function removeFromWhitelist(address _beneficiary) external onlyOwner {
1168     whitelist[_beneficiary] = false;
1169   }
1170 
1171   /**
1172    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
1173    * @param _beneficiary Token beneficiary
1174    * @param _weiAmount Amount of wei contributed
1175    */
1176   function _preValidatePurchase(
1177     address _beneficiary,
1178     uint256 _weiAmount
1179   )
1180     internal
1181     isWhitelisted(_beneficiary)
1182   {
1183     super._preValidatePurchase(_beneficiary, _weiAmount);
1184   }
1185 
1186 }
1187 
1188 // File: contracts\zeppelin\token\ERC20\TokenTimelock.sol
1189 
1190 /**
1191  * @title TokenTimelock
1192  * @dev TokenTimelock is a token holder contract that will allow a
1193  * beneficiary to extract the tokens after a given release time
1194  */
1195 contract TokenTimelock {
1196   using SafeERC20 for ERC20Basic;
1197 
1198   // ERC20 basic token contract being held
1199   ERC20Basic public token;
1200 
1201   // beneficiary of tokens after they are released
1202   address public beneficiary;
1203 
1204   // timestamp when token release is enabled
1205   uint256 public releaseTime;
1206 
1207   constructor(
1208     ERC20Basic _token,
1209     address _beneficiary,
1210     uint256 _releaseTime
1211   )
1212     public
1213   {
1214     // solium-disable-next-line security/no-block-members
1215     require(_releaseTime > block.timestamp);
1216     token = _token;
1217     beneficiary = _beneficiary;
1218     releaseTime = _releaseTime;
1219   }
1220 
1221   /**
1222    * @notice Transfers tokens held by timelock to beneficiary.
1223    */
1224   function release() public {
1225     // solium-disable-next-line security/no-block-members
1226     require(block.timestamp >= releaseTime);
1227 
1228     uint256 amount = token.balanceOf(this);
1229     require(amount > 0);
1230 
1231     token.safeTransfer(beneficiary, amount);
1232   }
1233 }
1234 
1235 // File: contracts\DroneMadnessCrowdsale.sol
1236 
1237 /**
1238  * @title Drone Madness Crowdsale Contract
1239  * @dev Drone Madness Crowdsale Contract
1240  * The contract is for the crowdsale of the Drone Madness token. It is:
1241  * - With a hard cap in ETH
1242  * - With a soft cap in ETH
1243  * - Limited in time (start/end date)
1244  * - Only for whitelisted participants to purchase tokens
1245  * - Ether is securely stored in RefundVault until the end of the crowdsale
1246  * - At the end of the crowdsale if the goal is reached funds can be used
1247  * ...otherwise the participants can refund their investments
1248  * - Tokens are minted on each purchase
1249  * - Sale can be paused if needed by the admin
1250  */
1251 contract DroneMadnessCrowdsale is 
1252     MintedCrowdsale,
1253     CappedCrowdsale,
1254     TimedCrowdsale,
1255     FinalizableCrowdsale,
1256     WhitelistedCrowdsale, 
1257     RefundableCrowdsale,
1258     Pausable {
1259     using SafeMath for uint256;
1260 
1261     // Initial distribution
1262     uint256 public constant SALE_TOKENS    = 60; // 60% from totalSupply
1263     uint256 public constant TEAM_TOKENS    = 10; // 10% from totalSupply
1264     uint256 public constant PRIZE_TOKENS   = 10; // 10% from totalSupply
1265     uint256 public constant ADVISOR_TOKENS = 10; // 10% from totalSupply
1266     uint256 public constant AIRDROP_TOKENS = 5;  // 5% from totalSupply
1267     uint256 public constant RESERVE_TOKENS = 5;  // 5% from totalSupply
1268 
1269     uint256 public constant TEAM_LOCK_TIME    = 15770000; // 6 months in seconds
1270     uint256 public constant RESERVE_LOCK_TIME = 31540000; // 1 year in seconds
1271 
1272     // Rate bonuses
1273     uint256 public initialRate;
1274     uint256[4] public bonuses = [30,20,10,0];
1275     uint256[4] public stages = [
1276         1535792400, // 1st of Sep - 30rd of Sep -> 30% Bonus
1277         1538384400, // 1st of Oct - 31st of Oct -> 20% Bonus
1278         1541066400, // 1st of Nov - 30rd of Oct -> 10% Bonus
1279         1543658400  // 1st of Dec - 31st of Dec -> 0% Bonus
1280     ];
1281     
1282     // Min investment
1283     uint256 public minInvestmentInWei;
1284     // Max individual investment
1285     uint256 public maxInvestmentInWei;
1286     
1287     mapping (address => uint256) internal invested;
1288 
1289     TokenTimelock public teamWallet;
1290     TokenTimelock public reservePool;
1291     TokenPool public advisorPool;
1292     TokenPool public airdropPool;
1293 
1294     // Events for this contract
1295 
1296     /**
1297      * Event triggered when changing the current rate on different stages
1298      * @param rate new rate
1299      */
1300     event CurrentRateChange(uint256 rate);
1301 
1302     /**
1303      * @dev Contract constructor
1304      * @param _cap uint256 hard cap of the crowdsale
1305      * @param _goal uint256 soft cap of the crowdsale
1306      * @param _openingTime uint256 crowdsale start date/time
1307      * @param _closingTime uint256 crowdsale end date/time
1308      * @param _rate uint256 initial rate DRNMD for 1 ETH
1309      * @param _minInvestmentInWei uint256 minimum investment amount
1310      * @param _maxInvestmentInWei uint256 maximum individual investment amount
1311      * @param _wallet address address where the collected funds will be transferred
1312      * @param _token DroneMadnessToken our token
1313      */
1314     constructor(
1315         uint256 _cap, 
1316         uint256 _goal, 
1317         uint256 _openingTime, 
1318         uint256 _closingTime, 
1319         uint256 _rate, 
1320         uint256 _minInvestmentInWei,
1321         uint256 _maxInvestmentInWei,
1322         address _wallet,
1323         DroneMadnessToken _token) 
1324         Crowdsale(_rate, _wallet, _token)
1325         CappedCrowdsale(_cap)
1326         TimedCrowdsale(_openingTime, _closingTime)
1327         RefundableCrowdsale(_goal) public {
1328         require(_goal <= _cap);
1329         initialRate = _rate;
1330         minInvestmentInWei = _minInvestmentInWei;
1331         maxInvestmentInWei = _maxInvestmentInWei;
1332     }
1333 
1334     /**
1335      * @dev Perform the initial token distribution according to the Drone Madness crowdsale rules
1336      * @param _teamAddress address address for the team tokens
1337      * @param _prizePoolAddress address address for the prize pool
1338      * @param _reservePoolAdddress address address for the reserve pool
1339      */
1340     function doInitialDistribution(
1341         address _teamAddress,
1342         address _prizePoolAddress,
1343         address _reservePoolAdddress) external onlyOwner {
1344 
1345         // Create locks for team and reserve pools        
1346         teamWallet = new TokenTimelock(token, _teamAddress, closingTime.add(TEAM_LOCK_TIME));
1347         reservePool = new TokenTimelock(token, _reservePoolAdddress, closingTime.add(RESERVE_LOCK_TIME));
1348         
1349         // Perform initial distribution
1350         uint256 tokenCap = CappedToken(token).cap();
1351 
1352         // Create airdrop and advisor pools
1353         advisorPool = new TokenPool(token, tokenCap.mul(ADVISOR_TOKENS).div(100));
1354         airdropPool = new TokenPool(token, tokenCap.mul(AIRDROP_TOKENS).div(100));
1355 
1356         // Distribute tokens to pools
1357         MintableToken(token).mint(teamWallet, tokenCap.mul(TEAM_TOKENS).div(100));
1358         MintableToken(token).mint(_prizePoolAddress, tokenCap.mul(PRIZE_TOKENS).div(100));
1359         MintableToken(token).mint(advisorPool, tokenCap.mul(ADVISOR_TOKENS).div(100));
1360         MintableToken(token).mint(airdropPool, tokenCap.mul(AIRDROP_TOKENS).div(100));
1361         MintableToken(token).mint(reservePool, tokenCap.mul(RESERVE_TOKENS).div(100));
1362 
1363         // Ensure that only sale tokens left
1364         assert(tokenCap.sub(token.totalSupply()) == tokenCap.mul(SALE_TOKENS).div(100));
1365     }
1366 
1367     /**
1368     * @dev Update the current rate based on the scheme
1369     * 1st of Sep - 30rd of Sep -> 30% Bonus
1370     * 1st of Oct - 31st of Oct -> 20% Bonus
1371     * 1st of Nov - 30rd of Oct -> 10% Bonus
1372     * 1st of Dec - 31st of Dec -> 0% Bonus
1373     */
1374     function updateRate() external onlyOwner {
1375         uint256 i = stages.length;
1376         while (i-- > 0) {
1377             if (block.timestamp >= stages[i]) {
1378                 rate = initialRate.add(initialRate.mul(bonuses[i]).div(100));
1379                 emit CurrentRateChange(rate);
1380                 break;
1381             }
1382         }
1383     }
1384 
1385     /**
1386     * @dev Perform an airdrop from the airdrop pool to multiple beneficiaries
1387     * @param _beneficiaries address[] list of beneficiaries
1388     * @param _amount uint256 amount to airdrop
1389     */
1390     function airdropTokens(address[] _beneficiaries, uint256 _amount) external onlyOwner {
1391         PausableToken(token).unpause();
1392         airdropPool.allocateEqual(_beneficiaries, _amount);
1393         PausableToken(token).pause();
1394     }
1395 
1396     /**
1397     * @dev Transfer tokens to advisors from the advisor's pool
1398     * @param _beneficiaries address[] list of beneficiaries
1399     * @param _amounts uint256[] amounts to airdrop
1400     */
1401     function allocateAdvisorTokens(address[] _beneficiaries, uint256[] _amounts) external onlyOwner {
1402         PausableToken(token).unpause();
1403         advisorPool.allocate(_beneficiaries, _amounts);
1404         PausableToken(token).pause();
1405     }
1406 
1407     /**
1408     * @dev Transfer the ownership of the token conctract 
1409     * @param _newOwner address the new owner of the token
1410     */
1411     function transferTokenOwnership(address _newOwner) onlyOwner public { 
1412         Ownable(token).transferOwnership(_newOwner);
1413     }
1414 
1415     /**
1416     * @dev Validate min and max amounts and other purchase conditions
1417     * @param _beneficiary address token purchaser
1418     * @param _weiAmount uint256 amount of wei contributed
1419     */
1420     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1421         super._preValidatePurchase(_beneficiary, _weiAmount);
1422         require(_weiAmount >= minInvestmentInWei);
1423         require(invested[_beneficiary].add(_weiAmount) <= maxInvestmentInWei);
1424         require(!paused);
1425     }
1426 
1427     /**
1428     * @dev Update invested amount
1429     * @param _beneficiary address receiving the tokens
1430     * @param _weiAmount uint256 value in wei involved in the purchase
1431     */
1432     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
1433         super._updatePurchasingState(_beneficiary, _weiAmount);
1434         invested[_beneficiary] = invested[_beneficiary].add(_weiAmount);
1435     }
1436 
1437      /**
1438     * @dev Perform crowdsale finalization. 
1439     * - Finish token minting
1440     * - Enable transfers
1441     * - Give back the token ownership to the admin
1442     */
1443     function finalization() internal {
1444         DroneMadnessToken dmToken = DroneMadnessToken(token);
1445         dmToken.finishMinting();
1446         dmToken.unpause();
1447         super.finalization();
1448         transferTokenOwnership(owner);
1449         airdropPool.transferOwnership(owner);
1450         advisorPool.transferOwnership(owner);
1451     }
1452 }
1453 
1454 // File: contracts\DroneMadnessPresale.sol
1455 
1456 /**
1457  * @title Drone Madness Presale Contract
1458  * @dev Drone Madness Presale Contract
1459  * The contract is for the private sale of the Drone Madness token. It is:
1460  * - With a hard cap in ETH
1461  * - Limited in time (start/end date)
1462  * - Only for whitelisted participants to purchase tokens
1463  * - Tokens are minted on each purchase
1464  */
1465 contract DroneMadnessPresale is 
1466     MintedCrowdsale,
1467     CappedCrowdsale,
1468     TimedCrowdsale,
1469     WhitelistedCrowdsale {
1470     using SafeMath for uint256;
1471 
1472     // Min investment
1473     uint256 public minInvestmentInWei;
1474     
1475     // Investments
1476     mapping (address => uint256) internal invested;
1477 
1478     /**
1479      * @dev Contract constructor
1480      * @param _cap uint256 hard cap of the crowdsale
1481      * @param _openingTime uint256 crowdsale start date/time
1482      * @param _closingTime uint256 crowdsale end date/time
1483      * @param _rate uint256 initial rate DRNMD for 1 ETH
1484      * @param _wallet address address where the collected funds will be transferred
1485      * @param _token DroneMadnessToken our token
1486      */
1487     constructor(
1488         uint256 _cap, 
1489         uint256 _openingTime, 
1490         uint256 _closingTime, 
1491         uint256 _rate, 
1492         uint256 _minInvestmentInWei,
1493         address _wallet, 
1494         DroneMadnessToken _token) 
1495         Crowdsale(_rate, _wallet, _token)
1496         CappedCrowdsale(_cap)
1497         TimedCrowdsale(_openingTime, _closingTime) public {
1498         minInvestmentInWei = _minInvestmentInWei;
1499     }
1500 
1501     /**
1502     * @dev Validate min investment amount
1503     * @param _beneficiary address token purchaser
1504     * @param _weiAmount uint256 amount of wei contributed
1505     */
1506     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1507         super._preValidatePurchase(_beneficiary, _weiAmount);
1508         require(_weiAmount >= minInvestmentInWei);
1509     }
1510 
1511     /**
1512     * @dev Transfer the ownership of the token conctract 
1513     * @param _newOwner address the new owner of the token
1514     */
1515     function transferTokenOwnership(address _newOwner) onlyOwner public { 
1516         Ownable(token).transferOwnership(_newOwner);
1517     }
1518 }