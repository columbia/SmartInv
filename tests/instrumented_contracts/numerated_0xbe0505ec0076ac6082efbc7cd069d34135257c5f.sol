1 pragma solidity ^0.4.23;
2 
3 
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
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender) public view returns (uint256);
74   function transferFrom(address from, address to, uint256 value) public returns (bool);
75   function approve(address spender, uint256 value) public returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 /**
81  * @title Crowdsale
82  * @dev Crowdsale is a base contract for managing a token crowdsale,
83  * allowing investors to purchase tokens with ether. This contract implements
84  * such functionality in its most fundamental form and can be extended to provide additional
85  * functionality and/or custom behavior.
86  * The external interface represents the basic interface for purchasing tokens, and conform
87  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
88  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
89  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
90  * behavior.
91  */
92 contract Crowdsale {
93   using SafeMath for uint256;
94 
95   // The token being sold
96   ERC20 public token;
97 
98   // Address where funds are collected
99   address public wallet;
100 
101   // How many token units a buyer gets per wei
102   uint256 public rate;
103 
104   // Amount of wei raised
105   uint256 public weiRaised;
106 
107   /**
108    * Event for token purchase logging
109    * @param purchaser who paid for the tokens
110    * @param beneficiary who got the tokens
111    * @param value weis paid for purchase
112    * @param amount amount of tokens purchased
113    */
114   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
115 
116   /**
117    * @param _rate Number of token units a buyer gets per wei
118    * @param _wallet Address where collected funds will be forwarded to
119    * @param _token Address of the token being sold
120    */
121   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
122     require(_rate > 0);
123     require(_wallet != address(0));
124     require(_token != address(0));
125 
126     rate = _rate;
127     wallet = _wallet;
128     token = _token;
129   }
130 
131   // -----------------------------------------
132   // Crowdsale external interface
133   // -----------------------------------------
134 
135   /**
136    * @dev fallback function ***DO NOT OVERRIDE***
137    */
138   function () external payable {
139     buyTokens(msg.sender);
140   }
141 
142   /**
143    * @dev low level token purchase ***DO NOT OVERRIDE***
144    * @param _beneficiary Address performing the token purchase
145    */
146   function buyTokens(address _beneficiary) public payable {
147 
148     uint256 weiAmount = msg.value;
149     _preValidatePurchase(_beneficiary, weiAmount);
150 
151     // calculate token amount to be created
152     uint256 tokens = _getTokenAmount(weiAmount);
153 
154     // update state
155     weiRaised = weiRaised.add(weiAmount);
156 
157     _processPurchase(_beneficiary, tokens);
158     emit TokenPurchase(
159       msg.sender,
160       _beneficiary,
161       weiAmount,
162       tokens
163     );
164 
165     _updatePurchasingState(_beneficiary, weiAmount);
166 
167     _forwardFunds();
168     _postValidatePurchase(_beneficiary, weiAmount);
169   }
170 
171   // -----------------------------------------
172   // Internal interface (extensible)
173   // -----------------------------------------
174 
175   /**
176    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
177    * @param _beneficiary Address performing the token purchase
178    * @param _weiAmount Value in wei involved in the purchase
179    */
180   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
181     require(_beneficiary != address(0));
182     require(_weiAmount != 0);
183   }
184 
185   /**
186    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
187    * @param _beneficiary Address performing the token purchase
188    * @param _weiAmount Value in wei involved in the purchase
189    */
190   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
191     // optional override
192   }
193 
194   /**
195    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
196    * @param _beneficiary Address performing the token purchase
197    * @param _tokenAmount Number of tokens to be emitted
198    */
199   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
200     token.transfer(_beneficiary, _tokenAmount);
201   }
202 
203   /**
204    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
205    * @param _beneficiary Address receiving the tokens
206    * @param _tokenAmount Number of tokens to be purchased
207    */
208   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
209     _deliverTokens(_beneficiary, _tokenAmount);
210   }
211 
212   /**
213    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
214    * @param _beneficiary Address receiving the tokens
215    * @param _weiAmount Value in wei involved in the purchase
216    */
217   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
218     // optional override
219   }
220 
221   /**
222    * @dev Override to extend the way in which ether is converted to tokens.
223    * @param _weiAmount Value in wei to be converted into tokens
224    * @return Number of tokens that can be purchased with the specified _weiAmount
225    */
226   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
227     return _weiAmount.mul(rate);
228   }
229 
230   /**
231    * @dev Determines how ETH is stored/forwarded on purchases.
232    */
233   function _forwardFunds() internal {
234     wallet.transfer(msg.value);
235   }
236 }
237 
238 
239 /**
240  * @title CappedCrowdsale
241  * @dev Crowdsale with a limit for total contributions.
242  */
243 contract CappedCrowdsale is Crowdsale {
244   using SafeMath for uint256;
245 
246   uint256 public cap;
247 
248   /**
249    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
250    * @param _cap Max amount of wei to be contributed
251    */
252   constructor(uint256 _cap) public {
253     require(_cap > 0);
254     cap = _cap;
255   }
256 
257   /**
258    * @dev Checks whether the cap has been reached.
259    * @return Whether the cap was reached
260    */
261   function capReached() public view returns (bool) {
262     return weiRaised >= cap;
263   }
264 
265   /**
266    * @dev Extend parent behavior requiring purchase to respect the funding cap.
267    * @param _beneficiary Token purchaser
268    * @param _weiAmount Amount of wei contributed
269    */
270   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
271     super._preValidatePurchase(_beneficiary, _weiAmount);
272     require(weiRaised.add(_weiAmount) <= cap);
273   }
274 
275 }
276 
277 
278 
279 
280 
281 
282 
283 /**
284  * @title Basic token
285  * @dev Basic version of StandardToken, with no allowances.
286  */
287 contract BasicToken is ERC20Basic {
288   using SafeMath for uint256;
289 
290   mapping(address => uint256) balances;
291 
292   uint256 totalSupply_;
293 
294   /**
295   * @dev total number of tokens in existence
296   */
297   function totalSupply() public view returns (uint256) {
298     return totalSupply_;
299   }
300 
301   /**
302   * @dev transfer token for a specified address
303   * @param _to The address to transfer to.
304   * @param _value The amount to be transferred.
305   */
306   function transfer(address _to, uint256 _value) public returns (bool) {
307     require(_to != address(0));
308     require(_value <= balances[msg.sender]);
309 
310     balances[msg.sender] = balances[msg.sender].sub(_value);
311     balances[_to] = balances[_to].add(_value);
312     emit Transfer(msg.sender, _to, _value);
313     return true;
314   }
315 
316   /**
317   * @dev Gets the balance of the specified address.
318   * @param _owner The address to query the the balance of.
319   * @return An uint256 representing the amount owned by the passed address.
320   */
321   function balanceOf(address _owner) public view returns (uint256) {
322     return balances[_owner];
323   }
324 
325 }
326 
327 
328 /**
329  * @title Standard ERC20 token
330  *
331  * @dev Implementation of the basic standard token.
332  * @dev https://github.com/ethereum/EIPs/issues/20
333  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
334  */
335 contract StandardToken is ERC20, BasicToken {
336 
337   mapping (address => mapping (address => uint256)) internal allowed;
338 
339 
340   /**
341    * @dev Transfer tokens from one address to another
342    * @param _from address The address which you want to send tokens from
343    * @param _to address The address which you want to transfer to
344    * @param _value uint256 the amount of tokens to be transferred
345    */
346   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
347     require(_to != address(0));
348     require(_value <= balances[_from]);
349     require(_value <= allowed[_from][msg.sender]);
350 
351     balances[_from] = balances[_from].sub(_value);
352     balances[_to] = balances[_to].add(_value);
353     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
354     emit Transfer(_from, _to, _value);
355     return true;
356   }
357 
358   /**
359    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
360    *
361    * Beware that changing an allowance with this method brings the risk that someone may use both the old
362    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
363    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
364    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
365    * @param _spender The address which will spend the funds.
366    * @param _value The amount of tokens to be spent.
367    */
368   function approve(address _spender, uint256 _value) public returns (bool) {
369     allowed[msg.sender][_spender] = _value;
370     emit Approval(msg.sender, _spender, _value);
371     return true;
372   }
373 
374   /**
375    * @dev Function to check the amount of tokens that an owner allowed to a spender.
376    * @param _owner address The address which owns the funds.
377    * @param _spender address The address which will spend the funds.
378    * @return A uint256 specifying the amount of tokens still available for the spender.
379    */
380   function allowance(address _owner, address _spender) public view returns (uint256) {
381     return allowed[_owner][_spender];
382   }
383 
384   /**
385    * @dev Increase the amount of tokens that an owner allowed to a spender.
386    *
387    * approve should be called when allowed[_spender] == 0. To increment
388    * allowed value is better to use this function to avoid 2 calls (and wait until
389    * the first transaction is mined)
390    * From MonolithDAO Token.sol
391    * @param _spender The address which will spend the funds.
392    * @param _addedValue The amount of tokens to increase the allowance by.
393    */
394   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
395     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
396     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
397     return true;
398   }
399 
400   /**
401    * @dev Decrease the amount of tokens that an owner allowed to a spender.
402    *
403    * approve should be called when allowed[_spender] == 0. To decrement
404    * allowed value is better to use this function to avoid 2 calls (and wait until
405    * the first transaction is mined)
406    * From MonolithDAO Token.sol
407    * @param _spender The address which will spend the funds.
408    * @param _subtractedValue The amount of tokens to decrease the allowance by.
409    */
410   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
411     uint oldValue = allowed[msg.sender][_spender];
412     if (_subtractedValue > oldValue) {
413       allowed[msg.sender][_spender] = 0;
414     } else {
415       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
416     }
417     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
418     return true;
419   }
420 
421 }
422 
423 
424 /**
425  * @title Ownable
426  * @dev The Ownable contract has an owner address, and provides basic authorization control
427  * functions, this simplifies the implementation of "user permissions".
428  */
429 contract Ownable {
430   address public owner;
431 
432 
433   event OwnershipRenounced(address indexed previousOwner);
434   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
435 
436 
437   /**
438    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
439    * account.
440    */
441   constructor() public {
442     owner = msg.sender;
443   }
444 
445   /**
446    * @dev Throws if called by any account other than the owner.
447    */
448   modifier onlyOwner() {
449     require(msg.sender == owner);
450     _;
451   }
452 
453   /**
454    * @dev Allows the current owner to transfer control of the contract to a newOwner.
455    * @param newOwner The address to transfer ownership to.
456    */
457   function transferOwnership(address newOwner) public onlyOwner {
458     require(newOwner != address(0));
459     emit OwnershipTransferred(owner, newOwner);
460     owner = newOwner;
461   }
462 
463   /**
464    * @dev Allows the current owner to relinquish control of the contract.
465    */
466   function renounceOwnership() public onlyOwner {
467     emit OwnershipRenounced(owner);
468     owner = address(0);
469   }
470 }
471 
472 
473 /**
474  * @title Mintable token
475  * @dev Simple ERC20 Token example, with mintable token creation
476  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
477  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
478  */
479 contract MintableToken is StandardToken, Ownable {
480   event Mint(address indexed to, uint256 amount);
481   event MintFinished();
482 
483   bool public mintingFinished = false;
484 
485 
486   modifier canMint() {
487     require(!mintingFinished);
488     _;
489   }
490 
491   modifier hasMintPermission() {
492     require(msg.sender == owner);
493     _;
494   }
495 
496   /**
497    * @dev Function to mint tokens
498    * @param _to The address that will receive the minted tokens.
499    * @param _amount The amount of tokens to mint.
500    * @return A boolean that indicates if the operation was successful.
501    */
502   function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
503     totalSupply_ = totalSupply_.add(_amount);
504     balances[_to] = balances[_to].add(_amount);
505     emit Mint(_to, _amount);
506     emit Transfer(address(0), _to, _amount);
507     return true;
508   }
509 
510   /**
511    * @dev Function to stop minting new tokens.
512    * @return True if the operation was successful.
513    */
514   function finishMinting() onlyOwner canMint public returns (bool) {
515     mintingFinished = true;
516     emit MintFinished();
517     return true;
518   }
519 }
520 
521 
522 /**
523  * @title MintedCrowdsale
524  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
525  * Token ownership should be transferred to MintedCrowdsale for minting.
526  */
527 contract MintedCrowdsale is Crowdsale {
528 
529   /**
530    * @dev Overrides delivery by minting tokens upon purchase.
531    * @param _beneficiary Token purchaser
532    * @param _tokenAmount Number of tokens to be minted
533    */
534   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
535     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
536   }
537 }
538 
539 
540 
541 
542 /**
543  * @title TimedCrowdsale
544  * @dev Crowdsale accepting contributions only within a time frame.
545  */
546 contract TimedCrowdsale is Crowdsale {
547   using SafeMath for uint256;
548 
549   uint256 public openingTime;
550   uint256 public closingTime;
551 
552   /**
553    * @dev Reverts if not in crowdsale time range.
554    */
555   modifier onlyWhileOpen {
556     // solium-disable-next-line security/no-block-members
557     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
558     _;
559   }
560 
561   /**
562    * @dev Constructor, takes crowdsale opening and closing times.
563    * @param _openingTime Crowdsale opening time
564    * @param _closingTime Crowdsale closing time
565    */
566   constructor(uint256 _openingTime, uint256 _closingTime) public {
567     // solium-disable-next-line security/no-block-members
568     require(_openingTime >= block.timestamp);
569     require(_closingTime >= _openingTime);
570 
571     openingTime = _openingTime;
572     closingTime = _closingTime;
573   }
574 
575   /**
576    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
577    * @return Whether crowdsale period has elapsed
578    */
579   function hasClosed() public view returns (bool) {
580     // solium-disable-next-line security/no-block-members
581     return block.timestamp > closingTime;
582   }
583 
584   /**
585    * @dev Extend parent behavior requiring to be within contributing period
586    * @param _beneficiary Token purchaser
587    * @param _weiAmount Amount of wei contributed
588    */
589   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
590     super._preValidatePurchase(_beneficiary, _weiAmount);
591   }
592 
593 }
594 
595 /**
596  * @title FTICrowdsale
597  * @dev This is FTICrowdsale contract.
598  * In this crowdsale we are providing following extensions:
599  * CappedCrowdsale - sets a max boundary for raised funds
600  * MintedCrowdsale - set a min goal to be reached and returns funds if it's not met
601  *
602  * After adding multiple features it's good practice to run integration tests
603  * to ensure that subcontracts works together as intended.
604  */
605 contract ClosedPeriod is TimedCrowdsale {
606     uint256 startClosePeriod;
607     uint256 stopClosePeriod;
608   
609     modifier onlyWhileOpen {
610         require(block.timestamp >= openingTime && block.timestamp <= closingTime);
611         require(block.timestamp < startClosePeriod || block.timestamp > stopClosePeriod);
612         _;
613     }
614 
615     constructor(
616         uint256 _openingTime,
617         uint256 _closingTime,
618         uint256 _openClosePeriod,
619         uint256 _endClosePeriod
620     ) public
621         TimedCrowdsale(_openingTime, _closingTime)
622     {
623         require(_openClosePeriod > 0);
624         require(_endClosePeriod > _openClosePeriod);
625         startClosePeriod = _openClosePeriod;
626         stopClosePeriod = _endClosePeriod;
627     }
628 }
629 
630 
631 
632 
633 
634 /**
635  * @title ContractableToken
636  * @dev The Ownable contract has an ownerncontract address, and provides basic authorization control
637  * functions, this simplifies the implementation of "user permissions".
638  */
639 contract OptionsToken is StandardToken, Ownable {
640     using SafeMath for uint256;
641     bool revertable = true;
642     mapping (address => uint256) public optionsOwner;
643     
644     modifier hasOptionPermision() {
645         require(msg.sender == owner);
646         _;
647     }  
648 
649     function storeOptions(address recipient, uint256 amount) public hasOptionPermision() {
650         optionsOwner[recipient] += amount;
651     }
652 
653     function refundOptions(address discharged) public onlyOwner() returns (bool) {
654         require(revertable);
655         require(optionsOwner[discharged] > 0);
656         require(optionsOwner[discharged] <= balances[discharged]);
657 
658         uint256 revertTokens = optionsOwner[discharged];
659         optionsOwner[discharged] = 0;
660 
661         balances[discharged] = balances[discharged].sub(revertTokens);
662         balances[owner] = balances[owner].add(revertTokens);
663         emit Transfer(discharged, owner, revertTokens);
664         return true;
665     }
666 
667     function doneOptions() public onlyOwner() {
668         require(revertable);
669         revertable = false;
670     }
671 }
672 
673 
674 
675 /**
676  * @title ContractableToken
677  * @dev The Contractable contract has an ownerncontract address, and provides basic authorization control
678  * functions, this simplifies the implementation of "user permissions".
679  */
680 contract ContractableToken is MintableToken, OptionsToken {
681     address[5] public contract_addr;
682     uint8 public contract_num = 0;
683 
684     function existsContract(address sender) public view returns(bool) {
685         bool found = false;
686         for (uint8 i = 0; i < contract_num; i++) {
687             if (sender == contract_addr[i]) {
688                 found = true;
689             }
690         }
691         return found;
692     }
693 
694     modifier onlyContract() {
695         require(existsContract(msg.sender));
696         _;
697     }
698 
699     modifier hasMintPermission() {
700         require(existsContract(msg.sender));
701         _;
702     }
703     
704     modifier hasOptionPermision() {
705         require(existsContract(msg.sender));
706         _;
707     }  
708   
709     event ContractRenounced();
710     event ContractTransferred(address indexed newContract);
711   
712     /**
713      * @dev Allows the current owner to transfer control of the contract to a newContract.
714      * @param newContract The address to transfer ownership to.
715      */
716     function setContract(address newContract) public onlyOwner() {
717         require(newContract != address(0));
718         contract_num++;
719         require(contract_num <= 5);
720         emit ContractTransferred(newContract);
721         contract_addr[contract_num-1] = newContract;
722     }
723   
724     function renounceContract() public onlyOwner() {
725         emit ContractRenounced();
726         contract_num = 0;
727     }
728   
729 }
730 
731 
732 
733 /**
734  * @title FTIToken
735  * @dev Very simple ERC20 Token that can be minted.
736  * It is meant to be used in a crowdsale contract.
737  */
738 contract FTIToken is ContractableToken {
739 
740     string public constant name = "GlobalCarService Token";
741     string public constant symbol = "FTI";
742     uint8 public constant decimals = 18;
743 
744     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
745         require(msg.sender == owner || mintingFinished);
746         super.transferFrom(_from, _to, _value);
747         return true;
748     }
749   
750     function transfer(address _to, uint256 _value) public returns (bool) {
751         require(msg.sender == owner || mintingFinished);
752         super.transfer(_to, _value);
753         return true;
754     }
755 }
756 
757 
758 /**
759  * @title FTICrowdsale
760  * @dev This is FTICrowdsale contract.
761  * In this crowdsale we are providing following extensions:
762  * CappedCrowdsale - sets a max boundary for raised funds
763  * MintedCrowdsale - set a min goal to be reached and returns funds if it's not met
764  *
765  * After adding multiple features it's good practice to run integration tests
766  * to ensure that subcontracts works together as intended.
767  */
768 contract FTICrowdsale is CappedCrowdsale, MintedCrowdsale, ClosedPeriod, Ownable {
769     using SafeMath for uint256;
770     uint256 public referralMinimum;
771     uint8 public additionalTokenRate; 
772     uint8 public referralPercent;
773     uint8 public referralOwnerPercent;
774     bool public openingManualyMining = true;
775   
776     modifier onlyOpeningManualyMinig() {
777         require(openingManualyMining);
778         _;
779     }
780    
781     struct Pay {
782         address payer;
783         uint256 amount;
784     }
785     
786     struct ReferalUser {
787         uint256 fundsTotal;
788         uint32 numReferrals;
789         uint256 amountWEI;
790         uint32 paysCount;
791         mapping (uint32 => Pay) pays;
792         mapping (uint32 => address) paysUniq;
793         mapping (address => uint256) referral;
794     }
795     mapping (address => ReferalUser) public referralAddresses;
796 
797     uint8 constant maxGlobInvestor = 5;
798     struct BonusPeriod {
799         uint64 from;
800         uint64 to;
801         uint256 min_amount;
802         uint256 max_amount;
803         uint8 bonus;
804         uint8 index_global_investor;
805     }
806     BonusPeriod[] public bonus_periods;
807 
808     mapping (uint8 => address[]) public globalInvestor;
809 
810     constructor(
811         uint256 _openingTime,
812         uint256 _closingTime,
813         uint256 _openClosePeriod,
814         uint256 _endClosePeriod,
815         uint256 _rate,
816         address _wallet,
817         uint256 _cap,
818         FTIToken _token,
819         uint8 _additionalTokenRate,
820         uint8 _referralPercent,
821         uint256 _referralMinimum,
822         uint8 _referralOwnerPercent
823     ) public
824         Crowdsale(_rate, _wallet, _token)
825         CappedCrowdsale(_cap)
826         ClosedPeriod(_openingTime, _closingTime, _openClosePeriod, _endClosePeriod)
827     {
828         require(_additionalTokenRate > 0);
829         require(_referralPercent > 0);
830         require(_referralMinimum > 0);
831         require(_referralOwnerPercent > 0);
832         additionalTokenRate = _additionalTokenRate;
833         referralPercent = _referralPercent;
834         referralMinimum = _referralMinimum;
835         referralOwnerPercent = _referralOwnerPercent;
836     }
837 
838     function bytesToAddress(bytes source) internal constant returns(address parsedReferer) {
839         assembly {
840             parsedReferer := mload(add(source,0x14))
841         }
842         require(parsedReferer != msg.sender);
843         return parsedReferer;
844     }
845 
846     function processReferral(address owner, address _beneficiary, uint256 _weiAmount) internal {
847         require(owner != address(0));
848         require(_beneficiary != address(0));
849         require(_weiAmount != 0);
850         ReferalUser storage rr = referralAddresses[owner];
851         if (rr.amountWEI > 0) {
852             uint mintTokens = _weiAmount.mul(rate);
853             uint256 ownerToken = mintTokens.mul(referralOwnerPercent).div(100);
854             rr.fundsTotal += ownerToken;
855             if (rr.referral[_beneficiary] == 0){
856                 rr.paysUniq[rr.numReferrals] = _beneficiary;
857                 rr.numReferrals += 1;
858             }
859             rr.referral[_beneficiary] += _weiAmount;
860             rr.pays[rr.paysCount] = Pay(_beneficiary, _weiAmount);
861             rr.paysCount += 1;
862             FTIToken(token).mint(owner, ownerToken);
863             FTIToken(token).mint(_beneficiary, mintTokens.mul(referralPercent).div(100));
864         }
865     }
866 
867     function addReferral(address _beneficiary, uint256 _weiAmount) internal {
868         if (_weiAmount > referralMinimum) {
869             ReferalUser storage r = referralAddresses[_beneficiary];
870             if (r.amountWEI > 0 ) {
871                 r.amountWEI += _weiAmount;
872             }
873             else {
874                 referralAddresses[_beneficiary] = ReferalUser(0, 0, _weiAmount, 0);
875             }
876         }
877     }
878 
879     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
880         if (msg.data.length == 20) {
881             address ref = bytesToAddress(msg.data);
882             processReferral(ref, _beneficiary, _weiAmount);
883         }
884 
885         addReferral(_beneficiary, _weiAmount);
886 
887         uint8 index = indexSuperInvestor(_weiAmount);
888         if (index > 0 && globalInvestor[index].length < maxGlobInvestor) {
889             bool found = false;
890             for (uint8 iter = 0; iter < globalInvestor[index].length; iter++) {
891                 if (globalInvestor[index][iter] == _beneficiary) {
892                     found = true;
893                 }
894             }
895             if (!found) { 
896                 globalInvestor[index].push(_beneficiary);
897             }
898         }
899     }
900 
901     function referalCount (address addr) public view returns(uint64 len) {
902         len = referralAddresses[addr].numReferrals;
903     } 
904 
905     function referalAddrByNum (address ref_owner, uint32 num) public view returns(address addr) {
906         addr = referralAddresses[ref_owner].paysUniq[num];
907     } 
908 
909     function referalPayCount (address addr) public view returns(uint64 len) {
910         len = referralAddresses[addr].paysCount;
911     } 
912 
913     function referalPayByNum (address ref_owner, uint32 num) public view returns(address addr, uint256 amount) {
914         addr = referralAddresses[ref_owner].pays[num].payer;
915         amount = referralAddresses[ref_owner].pays[num].amount;
916     } 
917 
918     function addBonusPeriod (uint64 from, uint64 to, uint256 min_amount, uint8 bonus, uint256 max_amount, uint8 index_glob_inv) public onlyOwner {
919         bonus_periods.push(BonusPeriod(from, to, min_amount, max_amount, bonus, index_glob_inv));
920     }
921 
922     function getBonusRate (uint256 amount) public constant returns(uint8) {
923         for (uint i = 0; i < bonus_periods.length; i++) {
924             BonusPeriod storage bonus_period = bonus_periods[i];
925             if (bonus_period.from <= now && bonus_period.to > now && bonus_period.min_amount <= amount && bonus_period.max_amount > amount) {
926                 return bonus_period.bonus;
927             } 
928         }
929         return 0;
930     }
931 
932     function indexSuperInvestor (uint256 amount) public view returns(uint8) {
933         for (uint8 i = 0; i < bonus_periods.length; i++) {
934             BonusPeriod storage bonus_period = bonus_periods[i];
935             if (bonus_period.from <= now && bonus_period.to > now && bonus_period.min_amount <= amount && bonus_period.max_amount > amount) {
936                 return bonus_period.index_global_investor;
937             } 
938         }
939         return 0;
940     }
941 
942     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
943         uint8 bonusPercent = 100 + getBonusRate(_weiAmount);
944         uint256 amountTokens = _weiAmount.mul(rate).mul(bonusPercent).div(100);
945         return amountTokens;
946     }
947 
948     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
949         super._processPurchase(_beneficiary, _tokenAmount);
950         FTIToken(token).mint(wallet, _tokenAmount.mul(additionalTokenRate).div(100));
951     }
952 
953     function closeManualyMining() public onlyOwner() {
954         openingManualyMining = false;
955     }
956 
957     function manualyMintTokens(uint256 _weiAmount, address _beneficiary, uint256 mintTokens) public onlyOwner() onlyOpeningManualyMinig() {
958         require(_beneficiary != address(0));
959         require(_weiAmount != 0);
960         require(mintTokens != 0);
961         weiRaised = weiRaised.add(_weiAmount);
962         _processPurchase(_beneficiary, mintTokens);
963         emit TokenPurchase(
964             msg.sender,
965             _beneficiary,
966             _weiAmount,
967             mintTokens
968         );
969         addReferral(_beneficiary, _weiAmount);
970     }
971 
972     function makeOptions(uint256 _weiAmount, address _recipient, uint256 optionTokens) public onlyOwner() {
973         require(!hasClosed());
974         require(_recipient != address(0));
975         require(_weiAmount != 0);
976         require(optionTokens != 0);
977         weiRaised = weiRaised.add(_weiAmount);
978         _processPurchase(_recipient, optionTokens);
979         emit TokenPurchase(
980             msg.sender,
981             _recipient,
982             _weiAmount,
983             optionTokens
984         );
985         FTIToken(token).storeOptions(_recipient, _weiAmount);
986         addReferral(_recipient, _weiAmount);
987     }
988 
989 
990 }