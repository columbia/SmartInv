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
527 // File: contracts\CoinolixToken.sol
528 
529 /**
530  * @title Coinolix icoToken
531  * @dev Coinolix icoToken - Token code for the Coinolix icoProject
532  * This is a standard ERC20 token with:
533  * - a cap
534  * - ability to pause transfers
535  */
536 contract CoinolixToken is CappedToken, PausableToken {
537 
538     string public constant name                 = "Coinolix token";
539     string public constant symbol               = "CLX";
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
659   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called CLX
660   // 1 wei will give you 1 unit, or 0.001 CLX.
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
751   }
752 
753   /**
754    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
755    * @param _beneficiary Address performing the token purchase
756    * @param _weiAmount Value in wei involved in the purchase
757    */
758   function _postValidatePurchase(
759     address _beneficiary,
760     uint256 _weiAmount
761   )
762     internal
763   {
764     // optional override
765   }
766 
767   /**
768    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
769    * @param _beneficiary Address performing the token purchase
770    * @param _tokenAmount Number of tokens to be emitted
771    */
772   function _deliverTokens(
773     address _beneficiary,
774     uint256 _tokenAmount
775   )
776     internal
777   {
778     token.transfer(_beneficiary, _tokenAmount);
779   }
780 
781   /**
782    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
783    * @param _beneficiary Address receiving the tokens
784    * @param _tokenAmount Number of tokens to be purchased
785    */
786   function _processPurchase(
787     address _beneficiary,
788     uint256 _tokenAmount
789   )
790     internal
791   {
792     _deliverTokens(_beneficiary, _tokenAmount);
793   }
794 
795   /**
796    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
797    * @param _beneficiary Address receiving the tokens
798    * @param _weiAmount Value in wei involved in the purchase
799    */
800   function _updatePurchasingState(
801     address _beneficiary,
802     uint256 _weiAmount
803   )
804     internal
805   {
806     // optional override
807   }
808 
809   /**
810    * @dev Override to extend the way in which ether is converted to tokens.
811    * @param _weiAmount Value in wei to be converted into tokens
812    * @return Number of tokens that can be purchased with the specified _weiAmount
813    */
814   function _getTokenAmount(uint256 _weiAmount)
815     internal view returns (uint256)
816   {
817     return _weiAmount.mul(rate);
818   }
819 
820   /**
821    * @dev Determines how ETH is stored/forwarded on purchases.
822    */
823   function _forwardFunds() internal {
824     wallet.transfer(msg.value);
825   }
826 }
827 
828 // File: contracts\zeppelin\crowdsale\validation\TimedCrowdsale.sol
829 /**
830  * @title TimedCrowdsale
831  * @dev Crowdsale accepting contributions only within a time frame.
832  */
833 contract TimedCrowdsale is Crowdsale {
834   using SafeMath for uint256;
835 
836   uint256 public openingTime;
837   uint256 public closingTime;
838 
839   /**
840    * @dev Reverts if not in crowdsale time range.
841    */
842   modifier onlyWhileOpen {
843     // solium-disable-next-line security/no-block-members
844     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
845     _;
846   }
847 
848   /**
849    * @dev Constructor, takes crowdsale opening and closing times.
850    * @param _openingTime Crowdsale opening time
851    * @param _closingTime Crowdsale closing time
852    */
853   constructor(uint256 _openingTime, uint256 _closingTime) public {
854     // solium-disable-next-line security/no-block-members
855     require(_openingTime >= block.timestamp);
856     require(_closingTime >= _openingTime);
857 
858     openingTime = _openingTime;
859     closingTime = _closingTime;
860   }
861 
862   /**
863    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
864    * @return Whether crowdsale period has elapsed
865    */
866   function hasClosed() public view returns (bool) {
867     // solium-disable-next-line security/no-block-members
868     return block.timestamp > closingTime;
869   }
870 
871   /**
872    * @dev Extend parent behavior requiring to be within contributing period
873    * @param _beneficiary Token purchaser
874    * @param _weiAmount Amount of wei contributed
875    */
876   function _preValidatePurchase(
877     address _beneficiary,
878     uint256 _weiAmount
879   )
880     internal
881     onlyWhileOpen
882   {
883     super._preValidatePurchase(_beneficiary, _weiAmount);
884   }
885 
886 }
887 
888 // File: contracts\zeppelin\crowdsale\distribution\FinalizableCrowdsale.sol
889 
890 /**
891  * @title FinalizableCrowdsale
892  * @dev Extension of Crowdsale where an owner can do extra work
893  * after finishing.
894  */
895 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
896   using SafeMath for uint256;
897 
898   bool public isFinalized = false;
899 
900   event Finalized();
901 
902   /**
903    * @dev Must be called after crowdsale ends, to do some extra finalization
904    * work. Calls the contract's finalization function.
905    */
906   function finalize() onlyOwner public {
907     require(!isFinalized);
908     require(hasClosed());
909 
910     finalization();
911     emit Finalized();
912 
913     isFinalized = true;
914   }
915 
916   /**
917    * @dev Can be overridden to add finalization logic. The overriding function
918    * should call super.finalization() to ensure the chain of finalization is
919    * executed entirely.
920    */
921   function finalization() internal {
922   }
923 
924 }
925 
926 // File: contracts\zeppelin\crowdsale\distribution\utils\RefundVault.sol
927 
928 /**
929  * @title RefundVault
930  * @dev This contract is used for storing funds while a crowdsale
931  * is in progress. Supports refunding the money if crowdsale fails,
932  * and forwarding it if crowdsale is successful.
933  */
934 contract RefundVault is Ownable {
935   using SafeMath for uint256;
936 
937   enum State { Active, Refunding, Closed }
938 
939   mapping (address => uint256) public deposited;
940   address public wallet;
941   State public state;
942 
943   event Closed();
944   event RefundsEnabled();
945   event Refunded(address indexed beneficiary, uint256 weiAmount);
946 
947   /**
948    * @param _wallet Vault address
949    */
950   constructor(address _wallet) public {
951     require(_wallet != address(0));
952     wallet = _wallet;
953     state = State.Active;
954   }
955 
956   /**
957    * @param investor Investor address
958    */
959   function deposit(address investor) onlyOwner public payable {
960     require(state == State.Active);
961     deposited[investor] = deposited[investor].add(msg.value);
962   }
963 
964   function close() onlyOwner public {
965     require(state == State.Active);
966     state = State.Closed;
967     emit Closed();
968     wallet.transfer(address(this).balance);
969   }
970 
971   function enableRefunds() onlyOwner public {
972     require(state == State.Active);
973     state = State.Refunding;
974     emit RefundsEnabled();
975   }
976 
977   /**
978    * @param investor Investor address
979    */
980   function refund(address investor) public {
981     require(state == State.Refunding);
982     uint256 depositedValue = deposited[investor];
983     deposited[investor] = 0;
984     investor.transfer(depositedValue);
985     emit Refunded(investor, depositedValue);
986   }
987 }
988 
989 // File: contracts\zeppelin\crowdsale\distribution\RefundableCrowdsale.sol
990 
991 /**
992  * @title RefundableCrowdsale
993  * @dev Extension of Crowdsale contract that adds a funding goal, and
994  * the possibility of users getting a refund if goal is not met.
995  * Uses a RefundVault as the crowdsale's vault.
996  */
997 contract RefundableCrowdsale is FinalizableCrowdsale {
998   using SafeMath for uint256;
999 
1000   // minimum amount of funds to be raised in weis
1001   uint256 public goal;
1002 
1003   // refund vault used to hold funds while crowdsale is running
1004   RefundVault public vault;
1005 
1006   /**
1007    * @dev Constructor, creates RefundVault.
1008    * @param _goal Funding goal
1009    */
1010   constructor(uint256 _goal) public {
1011     require(_goal > 0);
1012     vault = new RefundVault(wallet);
1013     goal = _goal;
1014   }
1015 
1016   /**
1017    * @dev Investors can claim refunds here if crowdsale is unsuccessful
1018    */
1019   function claimRefund() public {
1020     require(isFinalized);
1021     require(!goalReached());
1022 
1023     vault.refund(msg.sender);
1024   }
1025 
1026   /**
1027    * @dev Checks whether funding goal was reached.
1028    * @return Whether funding goal was reached
1029    */
1030   function goalReached() public view returns (bool) {
1031     return weiRaised >= goal;
1032   }
1033 
1034   /**
1035    * @dev vault finalization task, called when owner calls finalize()
1036    */
1037   function finalization() internal {
1038     if (goalReached()) {
1039       vault.close();
1040     } else {
1041       vault.enableRefunds();
1042     }
1043 
1044     super.finalization();
1045   }
1046 
1047   /**
1048    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
1049    */
1050   function _forwardFunds() internal {
1051     vault.deposit.value(msg.value)(msg.sender);
1052   }
1053 
1054 }
1055 
1056 // File: contracts\zeppelin\crowdsale\emission\MintedCrowdsale.sol
1057 
1058 /**
1059  * @title MintedCrowdsale
1060  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1061  * Token ownership should be transferred to MintedCrowdsale for minting.
1062  */
1063 contract MintedCrowdsale is Crowdsale {
1064 
1065   /**
1066    * @dev Overrides delivery by minting tokens upon purchase.
1067    * @param _beneficiary Token purchaser
1068    * @param _tokenAmount Number of tokens to be minted
1069    */
1070   function _deliverTokens(
1071     address _beneficiary,
1072     uint256 _tokenAmount
1073   )
1074     internal
1075   {
1076     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
1077   }
1078 }
1079 
1080 /**
1081  * @title AirdropAndAffiliateCrowdsale
1082  * @dev Extension of AirdropAndAffiliateCrowdsale contract
1083  */
1084 contract AirdropAndAffiliateCrowdsale is MintedCrowdsale {
1085   uint256 public valueAirDrop;
1086   uint256 public referrerBonus1;
1087   uint256 public referrerBonus2;
1088   mapping (address => uint8) public payedAddress;
1089   mapping (address => address) public referrers;
1090   constructor(uint256 _valueAirDrop, uint256 _referrerBonus1, uint256 _referrerBonus2) public {
1091     valueAirDrop = _valueAirDrop;
1092 	referrerBonus1 = _referrerBonus1;
1093 	referrerBonus2 = _referrerBonus2;
1094   }
1095   function bytesToAddress(bytes source) internal pure returns(address) {
1096     uint result;
1097     uint mul = 1;
1098     for(uint i = 20; i > 0; i--) {
1099       result += uint8(source[i-1])*mul;
1100       mul = mul*256;
1101     }
1102     return address(result);
1103   }  
1104   /**
1105    * @dev Overrides delivery by minting tokens upon purchase.
1106    * @param _beneficiary Token purchaser
1107    * @param _tokenAmount Number of tokens to be minted
1108    */
1109   function _deliverTokens(
1110     address _beneficiary,
1111     uint256 _tokenAmount
1112   )
1113     internal
1114   {
1115     address referer1;
1116     uint256 refererTokens1;
1117     address referer2;
1118     uint256 refererTokens2;	
1119     if (_tokenAmount != 0){ 
1120 	  super._deliverTokens(_beneficiary, _tokenAmount);
1121       //require(MintableToken(token).mint(_beneficiary, _tokenAmount));
1122     }
1123 	else{
1124 	  require(payedAddress[_beneficiary] == 0);
1125       payedAddress[_beneficiary] = 1;  	  
1126 	  super._deliverTokens(_beneficiary, valueAirDrop);
1127 	  _tokenAmount = valueAirDrop;
1128 	}
1129     //referral system
1130 	if(msg.data.length == 20) {	  
1131       referer1 = bytesToAddress(bytes(msg.data));
1132 	  referrers[_beneficiary] = referer1;
1133       if(referer1 != _beneficiary){
1134 	    //add tokens to the referrer1
1135         refererTokens1 = _tokenAmount.mul(referrerBonus1).div(100);
1136 	    super._deliverTokens(referer1, refererTokens1);
1137 	    referer2 = referrers[referer1];
1138 	    if(referer2 != address(0)){
1139 	      refererTokens2 = _tokenAmount.mul(referrerBonus2).div(100);
1140 	      super._deliverTokens(referer2, refererTokens2);
1141 	    }
1142 	  }
1143     }	
1144   }
1145 }
1146 
1147 // File: contracts\zeppelin\crowdsale\validation\CappedCrowdsale.sol
1148 
1149 /**
1150  * @title CappedCrowdsale
1151  * @dev Crowdsale with a limit for total contributions.
1152  */
1153 contract CappedCrowdsale is Crowdsale {
1154   using SafeMath for uint256;
1155 
1156   uint256 public cap;
1157 
1158   /**
1159    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
1160    * @param _cap Max amount of wei to be contributed
1161    */
1162   constructor(uint256 _cap) public {
1163     require(_cap > 0);
1164     cap = _cap;
1165   }
1166 
1167   /**
1168    * @dev Checks whether the cap has been reached.
1169    * @return Whether the cap was reached
1170    */
1171   function capReached() public view returns (bool) {
1172     return weiRaised >= cap;
1173   }
1174 
1175   /**
1176    * @dev Extend parent behavior requiring purchase to respect the funding cap.
1177    * @param _beneficiary Token purchaser
1178    * @param _weiAmount Amount of wei contributed
1179    */
1180   function _preValidatePurchase(
1181     address _beneficiary,
1182     uint256 _weiAmount
1183   )
1184     internal
1185   {
1186     super._preValidatePurchase(_beneficiary, _weiAmount);
1187     require(weiRaised.add(_weiAmount) <= cap);
1188   }
1189 
1190 }
1191 
1192 // File: contracts\zeppelin\crowdsale\validation\WhitelistedCrowdsale.sol
1193 
1194 /**
1195  * @title WhitelistedCrowdsale
1196  * @dev Crowdsale in which only whitelisted users can contribute.
1197  */
1198 contract WhitelistedCrowdsale is Crowdsale, Ownable {
1199 
1200   mapping(address => bool) public whitelist;
1201 
1202   /**
1203    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
1204    */
1205   modifier isWhitelisted(address _beneficiary) {
1206     require(whitelist[_beneficiary]);
1207     _;
1208   }
1209 
1210   /**
1211    * @dev Adds single address to whitelist.
1212    * @param _beneficiary Address to be added to the whitelist
1213    */
1214   function addToWhitelist(address _beneficiary) external onlyOwner {
1215     whitelist[_beneficiary] = true;
1216   }
1217 
1218   /**
1219    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
1220    * @param _beneficiaries Addresses to be added to the whitelist
1221    */
1222   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
1223     for (uint256 i = 0; i < _beneficiaries.length; i++) {
1224       whitelist[_beneficiaries[i]] = true;
1225     }
1226   }
1227 
1228   /**
1229    * @dev Removes single address from whitelist.
1230    * @param _beneficiary Address to be removed to the whitelist
1231    */
1232   function removeFromWhitelist(address _beneficiary) external onlyOwner {
1233     whitelist[_beneficiary] = false;
1234   }
1235 
1236   /**
1237    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
1238    * @param _beneficiary Token beneficiary
1239    * @param _weiAmount Amount of wei contributed
1240    */
1241   function _preValidatePurchase(
1242     address _beneficiary,
1243     uint256 _weiAmount
1244   )
1245     internal
1246     isWhitelisted(_beneficiary)
1247   {
1248     super._preValidatePurchase(_beneficiary, _weiAmount);
1249   }
1250 
1251 }
1252 
1253 // File: contracts\zeppelin\token\ERC20\TokenTimelock.sol
1254 
1255 /**
1256  * @title TokenTimelock
1257  * @dev TokenTimelock is a token holder contract that will allow a
1258  * beneficiary to extract the tokens after a given release time
1259  */
1260 contract TokenTimelock {
1261   using SafeERC20 for ERC20Basic;
1262 
1263   // ERC20 basic token contract being held
1264   ERC20Basic public token;
1265 
1266   // beneficiary of tokens after they are released
1267   address public beneficiary;
1268 
1269   // timestamp when token release is enabled
1270   uint256 public releaseTime;
1271 
1272   constructor(
1273     ERC20Basic _token,
1274     address _beneficiary,
1275     uint256 _releaseTime
1276   )
1277     public
1278   {
1279     // solium-disable-next-line security/no-block-members
1280     require(_releaseTime > block.timestamp);
1281     token = _token;
1282     beneficiary = _beneficiary;
1283     releaseTime = _releaseTime;
1284   }
1285 
1286   /**
1287    * @notice Transfers tokens held by timelock to beneficiary.
1288    */
1289   function release() public {
1290     // solium-disable-next-line security/no-block-members
1291     require(block.timestamp >= releaseTime);
1292 
1293     uint256 amount = token.balanceOf(this);
1294     require(amount > 0);
1295 
1296     token.safeTransfer(beneficiary, amount);
1297   }
1298 }
1299 
1300 // File: contracts\CoinolixCrowdsale.sol
1301 
1302 /**
1303  * @title Coinolix ico Crowdsale Contract
1304  * @dev Coinolix ico Crowdsale Contract
1305  * The contract is for the crowdsale of the Coinolix icotoken. It is:
1306  * - With a hard cap in ETH
1307  * - With a soft cap in ETH
1308  * - Limited in time (start/end date)
1309  * - Only for whitelisted participants to purchase tokens
1310  * - Ether is securely stored in RefundVault until the end of the crowdsale
1311  * - At the end of the crowdsale if the goal is reached funds can be used
1312  * ...otherwise the participants can refund their investments
1313  * - Tokens are minted on each purchase
1314  * - Sale can be paused if needed by the admin
1315  */
1316 contract CoinolixCrowdsale is 
1317     AirdropAndAffiliateCrowdsale,
1318 	//MintedCrowdsale,
1319     CappedCrowdsale,
1320     TimedCrowdsale,
1321     FinalizableCrowdsale,
1322     WhitelistedCrowdsale, 
1323     RefundableCrowdsale,
1324     Pausable {
1325     using SafeMath for uint256;
1326 
1327     // Initial distribution
1328     uint256 public constant PUBLIC_TOKENS  = 50; // 50% from totalSupply CROWDSALE + PRESALE
1329     uint256 public constant PVT_INV_TOKENS = 15; // 15% from totalSupply PRIVATE SALE INVESTOR
1330 
1331 
1332     uint256 public constant TEAM_TOKENS    = 20; // 20% from totalSupply FOUNDERS
1333     uint256 public constant ADV_TEAM_TOKENS = 10;  // 10% from totalSupply ADVISORS
1334 
1335     uint256 public constant BOUNTY_TOKENS   = 2; // 2% from totalSupply BOUNTY
1336     uint256 public constant REFF_TOKENS     = 3;  // 3% from totalSupply REFFERALS
1337 
1338     uint256 public constant TEAM_LOCK_TIME    = 31540000; // 1 year in seconds
1339     uint256 public constant ADV_TEAM_LOCK_TIME = 15770000; // 6 months in seconds
1340 
1341     // Rate bonuses
1342     uint256 public initialRate;
1343     uint256[4] public bonuses = [20,10,5,0];
1344     uint256[4] public stages = [
1345     1541635200, // 1st two week of crowdsale -> 20% Bonus
1346     1542844800, // 3rd week of crowdsale -> 10% Bonus
1347     1543449600, // 4th week of crowdsale -> 5% Bonus
1348     1544054400  // 5th week of crowdsale -> 0% Bonus
1349     ];
1350     
1351     // Min investment
1352     uint256 public minInvestmentInWei;
1353     // Max individual investment
1354     uint256 public maxInvestmentInWei;
1355     
1356     mapping (address => uint256) internal invested;
1357 
1358     TokenTimelock public teamWallet;
1359     TokenTimelock public advteamPool;
1360     TokenPool public reffalPool;
1361     TokenPool public pvt_inv_Pool;
1362 
1363     // Events for this contract
1364 
1365     /**
1366      * Event triggered when changing the current rate on different stages
1367      * @param rate new rate
1368      */
1369     event CurrentRateChange(uint256 rate);
1370 
1371     /**
1372      * @dev Contract constructor
1373      * @param _cap uint256 hard cap of the crowdsale
1374      * @param _goal uint256 soft cap of the crowdsale
1375      * @param _openingTime uint256 crowdsale start date/time
1376      * @param _closingTime uint256 crowdsale end date/time
1377      * @param _rate uint256 initial rate CLX for 1 ETH
1378      * @param _minInvestmentInWei uint256 minimum investment amount
1379      * @param _maxInvestmentInWei uint256 maximum individual investment amount
1380      * @param _wallet address address where the collected funds will be transferred
1381      * @param _token CoinolixToken our token
1382      */
1383     constructor(
1384         uint256 _cap, 
1385         uint256 _goal, 
1386         uint256 _openingTime, 
1387         uint256 _closingTime, 
1388         uint256 _rate, 
1389         uint256 _minInvestmentInWei,
1390         uint256 _maxInvestmentInWei,
1391         address _wallet,
1392         CoinolixToken _token,
1393         uint256 _valueAirDrop, 
1394         uint256 _referrerBonus1, 
1395         uint256 _referrerBonus2) 
1396         Crowdsale(_rate, _wallet, _token)
1397         CappedCrowdsale(_cap)
1398         AirdropAndAffiliateCrowdsale(_valueAirDrop, _referrerBonus1, _referrerBonus2)
1399         TimedCrowdsale(_openingTime, _closingTime)
1400         RefundableCrowdsale(_goal) public {
1401         require(_goal <= _cap);
1402         initialRate = _rate;
1403         minInvestmentInWei = _minInvestmentInWei;
1404         maxInvestmentInWei = _maxInvestmentInWei;
1405     }
1406 
1407     /**
1408      * @dev Perform the initial token distribution according to the Coinolix icocrowdsale rules
1409      * @param _teamAddress address address for the team tokens
1410      * @param _bountyPoolAddress address address for the prize pool
1411      * @param _advisorPoolAdddress address address for the reserve pool
1412      */
1413     function doInitialDistribution(
1414         address _teamAddress,
1415         address _bountyPoolAddress,
1416         address _advisorPoolAdddress) external onlyOwner {
1417 
1418         // Create locks for team and visor pools        
1419         teamWallet = new TokenTimelock(token, _teamAddress, closingTime.add(TEAM_LOCK_TIME));
1420         advteamPool = new TokenTimelock(token, _advisorPoolAdddress, closingTime.add(ADV_TEAM_LOCK_TIME));
1421         
1422         // Perform initial distribution
1423         uint256 tokenCap = CappedToken(token).cap();
1424 
1425         //private investor pool
1426         pvt_inv_Pool= new TokenPool(token, tokenCap.mul(PVT_INV_TOKENS).div(100));
1427         //airdrop,bounty and reffalPool
1428         reffalPool = new TokenPool(token, tokenCap.mul(REFF_TOKENS).div(100));
1429 
1430         // Distribute tokens to pools
1431         MintableToken(token).mint(teamWallet, tokenCap.mul(TEAM_TOKENS).div(100));
1432         MintableToken(token).mint(_bountyPoolAddress, tokenCap.mul(BOUNTY_TOKENS).div(100));
1433         MintableToken(token).mint(pvt_inv_Pool, tokenCap.mul(PVT_INV_TOKENS).div(100));
1434         MintableToken(token).mint(reffalPool, tokenCap.mul(REFF_TOKENS).div(100));
1435         MintableToken(token).mint(advteamPool, tokenCap.mul(ADV_TEAM_TOKENS).div(100));
1436 
1437         // Ensure that only sale tokens left
1438         assert(tokenCap.sub(token.totalSupply()) == tokenCap.mul(PUBLIC_TOKENS).div(100));
1439     }
1440 
1441     /**
1442     * @dev Update the current rate based on the scheme
1443     * 1st of Sep - 30rd of Sep -> 30% Bonus
1444     * 1st of Oct - 31st of Oct -> 20% Bonus
1445     * 1st of Nov - 30rd of Oct -> 10% Bonus
1446     * 1st of Dec - 31st of Dec -> 0% Bonus
1447     */
1448     function updateRate() external onlyOwner {
1449         uint256 i = stages.length;
1450         while (i-- > 0) {
1451             if (block.timestamp >= stages[i]) {
1452                 rate = initialRate.add(initialRate.mul(bonuses[i]).div(100));
1453                 emit CurrentRateChange(rate);
1454                 break;
1455             }
1456         }
1457     }
1458 
1459         //update rate function by owner to keep stable rate in USD
1460 
1461     function updateInitialRate(uint256 _rate) external onlyOwner {
1462         initialRate = _rate;
1463         uint256 i = stages.length;
1464         while (i-- > 0) {
1465             if (block.timestamp >= stages[i]) {
1466                 rate = initialRate.add(initialRate.mul(bonuses[i]).div(100));
1467                 emit CurrentRateChange(rate);
1468                 break;
1469             }
1470         }
1471     }
1472 
1473     /**
1474     * @dev Perform an airdrop from the airdrop pool to multiple beneficiaries
1475     * @param _beneficiaries address[] list of beneficiaries
1476     * @param _amount uint256 amount to airdrop
1477     */
1478     function airdropTokens(address[] _beneficiaries, uint256 _amount) external onlyOwner {
1479         PausableToken(token).unpause();
1480         reffalPool.allocateEqual(_beneficiaries, _amount);
1481         PausableToken(token).pause();
1482     }
1483 
1484     /**
1485     * @dev Transfer tokens to advisors and private investor from the  pool
1486     * @param _beneficiaries address[] list of beneficiaries
1487     * @param _amounts uint256[] amounts 
1488     */
1489     function allocatePVT_InvTokens(address[] _beneficiaries, uint256[] _amounts) external onlyOwner {
1490         PausableToken(token).unpause();
1491         pvt_inv_Pool.allocate(_beneficiaries, _amounts);
1492         PausableToken(token).pause();
1493     }
1494 
1495     /**
1496     * @dev Transfer the ownership of the token conctract 
1497     * @param _newOwner address the new owner of the token
1498     */
1499     function transferTokenOwnership(address _newOwner) onlyOwner public { 
1500         Ownable(token).transferOwnership(_newOwner);
1501     }
1502 
1503     /**
1504     * @dev Validate min and max amounts and other purchase conditions
1505     * @param _beneficiary address token purchaser
1506     * @param _weiAmount uint256 amount of wei contributed
1507     */
1508     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1509         super._preValidatePurchase(_beneficiary, _weiAmount);
1510         require(_weiAmount >= minInvestmentInWei);
1511         require(invested[_beneficiary].add(_weiAmount) <= maxInvestmentInWei);
1512         require(!paused);
1513     }
1514 
1515     /**
1516     * @dev Update invested amount
1517     * @param _beneficiary address receiving the tokens
1518     * @param _weiAmount uint256 value in wei involved in the purchase
1519     */
1520     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
1521         super._updatePurchasingState(_beneficiary, _weiAmount);
1522         invested[_beneficiary] = invested[_beneficiary].add(_weiAmount);
1523     }
1524 
1525      /**
1526     * @dev Perform crowdsale finalization. 
1527     * - Finish token minting
1528     * - Enable transfers
1529     * - Give back the token ownership to the admin
1530     */
1531     function finalization() internal {
1532         CoinolixToken clxToken = CoinolixToken(token);
1533         clxToken.finishMinting();
1534         clxToken.unpause();
1535         super.finalization();
1536         transferTokenOwnership(owner);
1537         reffalPool.transferOwnership(owner);
1538         pvt_inv_Pool.transferOwnership(owner);
1539     }
1540 }
1541 
1542 // File: contracts\CoinolixPresale.sol
1543 
1544 /**
1545  * @title Coinolix icoPresale Contract
1546  * @dev Coinolix icoPresale Contract
1547  * The contract is for the private sale of the Coinolix icotoken. It is:
1548  * - With a hard cap in ETH
1549  * - Limited in time (start/end date)
1550  * - Only for whitelisted participants to purchase tokens
1551  * - Tokens are minted on each purchase
1552  */
1553 contract CoinolixPresale is 
1554     AirdropAndAffiliateCrowdsale,
1555     //MintedCrowdsale,
1556     CappedCrowdsale,
1557     TimedCrowdsale,
1558     WhitelistedCrowdsale {
1559     using SafeMath for uint256;
1560 
1561     // Min investment
1562             uint256 public presaleRate;
1563     uint256 public minInvestmentInWei;
1564         event CurrentRateChange(uint256 rate);
1565 
1566     // Investments
1567     mapping (address => uint256) internal invested;
1568 
1569     /**
1570      * @dev Contract constructor
1571      * @param _cap uint256 hard cap of the crowdsale
1572      * @param _openingTime uint256 crowdsale start date/time
1573      * @param _closingTime uint256 crowdsale end date/time
1574      * @param _rate uint256 initial rate CLX for 1 ETH
1575      * @param _wallet address address where the collected funds will be transferred
1576      * @param _token CoinolixToken our token
1577      */
1578     constructor(
1579         uint256 _cap, 
1580         uint256 _openingTime, 
1581         uint256 _closingTime, 
1582         uint256 _rate, 
1583         uint256 _minInvestmentInWei,
1584         address _wallet, 
1585         CoinolixToken _token,
1586         uint256 _valueAirDrop, 
1587         uint256 _referrerBonus1, 
1588         uint256 _referrerBonus2) 
1589         Crowdsale(_rate, _wallet, _token)
1590         AirdropAndAffiliateCrowdsale(_valueAirDrop, _referrerBonus1, _referrerBonus2)
1591         CappedCrowdsale(_cap)
1592         TimedCrowdsale(_openingTime, _closingTime) public {
1593         minInvestmentInWei = _minInvestmentInWei;
1594         presaleRate = _rate;
1595 
1596      }
1597         //update rate function by owner to keep stable rate in USD
1598       function updatepresaleRate(uint256 _rate) external onlyOwner {
1599     presaleRate = _rate;
1600     rate = presaleRate;
1601       }
1602   
1603     /**
1604     * @dev Validate min investment amount
1605     * @param _beneficiary address token purchaser
1606     * @param _weiAmount uint256 amount of wei contributed
1607     */
1608     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1609         super._preValidatePurchase(_beneficiary, _weiAmount);
1610         require(_weiAmount >= minInvestmentInWei);
1611     }
1612 
1613     /**
1614     * @dev Transfer the ownership of the token conctract 
1615     * @param _newOwner address the new owner of the token
1616     */
1617     function transferTokenOwnership(address _newOwner) onlyOwner public { 
1618         Ownable(token).transferOwnership(_newOwner);
1619     }
1620 }