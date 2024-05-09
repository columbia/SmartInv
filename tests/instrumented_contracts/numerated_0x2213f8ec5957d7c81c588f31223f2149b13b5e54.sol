1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     emit Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     emit Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 // File: contracts/DisableSelfTransfer.sol
222 
223 contract DisableSelfTransfer is StandardToken {
224     
225   function transfer(address _to, uint256 _value) public returns (bool) {
226     require(_to != address(this));
227     return super.transfer(_to, _value);
228   }
229 
230   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
231     require(_to != address(this));
232     return super.transferFrom(_from, _to, _value);
233   }
234 
235 }
236 
237 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
238 
239 /**
240  * @title Ownable
241  * @dev The Ownable contract has an owner address, and provides basic authorization control
242  * functions, this simplifies the implementation of "user permissions".
243  */
244 contract Ownable {
245   address public owner;
246 
247 
248   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249 
250 
251   /**
252    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
253    * account.
254    */
255   function Ownable() public {
256     owner = msg.sender;
257   }
258 
259   /**
260    * @dev Throws if called by any account other than the owner.
261    */
262   modifier onlyOwner() {
263     require(msg.sender == owner);
264     _;
265   }
266 
267   /**
268    * @dev Allows the current owner to transfer control of the contract to a newOwner.
269    * @param newOwner The address to transfer ownership to.
270    */
271   function transferOwnership(address newOwner) public onlyOwner {
272     require(newOwner != address(0));
273     emit OwnershipTransferred(owner, newOwner);
274     owner = newOwner;
275   }
276 
277 }
278 
279 // File: contracts/OwnerContract.sol
280 
281 contract OwnerContract is Ownable {
282 
283   event ContractControllerAdded(address contractAddress);
284   event ContractControllerRemoved(address contractAddress);
285 
286 
287   mapping (address => bool) internal contracts;
288 
289   // New modifier to be used in place of OWNER ONLY activity
290   // Eventually this will be owned by a controller contract and not a private wallet
291   // (Voting needs to be implemented)
292   modifier justOwner() {
293     require(msg.sender == owner);
294     _;
295   }
296   
297   // Allow contracts to have ownership without taking full custody of the token
298   // (Until voting is fully implemented)
299   modifier onlyOwner() {
300     if (msg.sender == address(0) || (msg.sender != owner && !contracts[msg.sender])) {
301       revert(); // error for uncontrolled request
302     }
303     _;
304   }
305 
306   // Stops owner from gaining access to all functionality
307   modifier onlyContract() {
308     require(msg.sender != address(0));
309     require(contracts[msg.sender]); 
310     _;
311   }
312 
313   // new owner only activity. 
314   // (Voting to be implemented for owner replacement)
315   function removeController(address controllerToRemove) public justOwner {
316     require(contracts[controllerToRemove]);
317     contracts[controllerToRemove] = false;
318     emit ContractControllerRemoved(controllerToRemove);
319   }
320   // new owner only activity.
321   // (Voting to be implemented for owner replacement)
322   function addController(address newController) public justOwner {
323     require(contracts[newController] != true);
324     contracts[newController] = true;
325     emit ContractControllerAdded(newController);
326   }
327 
328   function isController(address _address) public view returns(bool) {
329     return contracts[_address];
330   }
331 
332 }
333 
334 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
335 
336 /**
337  * @title Burnable Token
338  * @dev Token that can be irreversibly burned (destroyed).
339  */
340 contract BurnableToken is BasicToken {
341 
342   event Burn(address indexed burner, uint256 value);
343 
344   /**
345    * @dev Burns a specific amount of tokens.
346    * @param _value The amount of token to be burned.
347    */
348   function burn(uint256 _value) public {
349     _burn(msg.sender, _value);
350   }
351 
352   function _burn(address _who, uint256 _value) internal {
353     require(_value <= balances[_who]);
354     // no need to require value <= totalSupply, since that would imply the
355     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
356 
357     balances[_who] = balances[_who].sub(_value);
358     totalSupply_ = totalSupply_.sub(_value);
359     emit Burn(_who, _value);
360     emit Transfer(_who, address(0), _value);
361   }
362 }
363 
364 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
365 
366 /**
367  * @title Mintable token
368  * @dev Simple ERC20 Token example, with mintable token creation
369  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
370  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
371  */
372 contract MintableToken is StandardToken, Ownable {
373   event Mint(address indexed to, uint256 amount);
374   event MintFinished();
375 
376   bool public mintingFinished = false;
377 
378 
379   modifier canMint() {
380     require(!mintingFinished);
381     _;
382   }
383 
384   /**
385    * @dev Function to mint tokens
386    * @param _to The address that will receive the minted tokens.
387    * @param _amount The amount of tokens to mint.
388    * @return A boolean that indicates if the operation was successful.
389    */
390   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
391     totalSupply_ = totalSupply_.add(_amount);
392     balances[_to] = balances[_to].add(_amount);
393     emit Mint(_to, _amount);
394     emit Transfer(address(0), _to, _amount);
395     return true;
396   }
397 
398   /**
399    * @dev Function to stop minting new tokens.
400    * @return True if the operation was successful.
401    */
402   function finishMinting() onlyOwner canMint public returns (bool) {
403     mintingFinished = true;
404     emit MintFinished();
405     return true;
406   }
407 }
408 
409 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
410 
411 /**
412  * @title Pausable
413  * @dev Base contract which allows children to implement an emergency stop mechanism.
414  */
415 contract Pausable is Ownable {
416   event Pause();
417   event Unpause();
418 
419   bool public paused = false;
420 
421 
422   /**
423    * @dev Modifier to make a function callable only when the contract is not paused.
424    */
425   modifier whenNotPaused() {
426     require(!paused);
427     _;
428   }
429 
430   /**
431    * @dev Modifier to make a function callable only when the contract is paused.
432    */
433   modifier whenPaused() {
434     require(paused);
435     _;
436   }
437 
438   /**
439    * @dev called by the owner to pause, triggers stopped state
440    */
441   function pause() onlyOwner whenNotPaused public {
442     paused = true;
443     emit Pause();
444   }
445 
446   /**
447    * @dev called by the owner to unpause, returns to normal state
448    */
449   function unpause() onlyOwner whenPaused public {
450     paused = false;
451     emit Unpause();
452   }
453 }
454 
455 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
456 
457 /**
458  * @title Pausable token
459  * @dev StandardToken modified with pausable transfers.
460  **/
461 contract PausableToken is StandardToken, Pausable {
462 
463   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
464     return super.transfer(_to, _value);
465   }
466 
467   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
468     return super.transferFrom(_from, _to, _value);
469   }
470 
471   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
472     return super.approve(_spender, _value);
473   }
474 
475   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
476     return super.increaseApproval(_spender, _addedValue);
477   }
478 
479   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
480     return super.decreaseApproval(_spender, _subtractedValue);
481   }
482 }
483 
484 // File: contracts/MintableContractOwnerToken.sol
485 
486 contract MintableContractOwnerToken is PausableToken, MintableToken, BurnableToken, OwnerContract, DisableSelfTransfer {
487 
488   bool burnAllowed = false;
489 
490   // Fired when an approved contract calls restartMint
491   event MintRestarted(); 
492   // Fired when a transfer is initiated from the contract rather than the owning wallet.
493   event ContractTransfer(address from, address to, uint value);
494 
495   // Fired when burning status changes
496   event BurningStateChange(bool canBurn);
497 
498   // opposite of canMint used for restarting the mint
499   modifier cantMint() {
500     require(mintingFinished);
501     _;
502   }
503 
504   // Require Burn to be turned on
505   modifier canBurn() {
506     require(burnAllowed);
507     _;
508   }
509 
510   // Require that burning is turned off
511   modifier cantBurn() {
512     require(!burnAllowed);
513     _;
514   }
515 
516   // Enable Burning Only if Burning is Off
517   function enableBurning() public onlyContract cantBurn {
518     burnAllowed = true;
519     BurningStateChange(burnAllowed);
520   }
521 
522   // Disable Burning Only if Burning is On
523   function disableBurning() public onlyContract canBurn {
524     burnAllowed = false;
525     BurningStateChange(burnAllowed);
526   }
527 
528   // Override parent burn function to provide canBurn limitation
529   function burn(uint256 _value) public canBurn {
530     super.burn(_value);
531   }
532 
533 
534   // Allow the contract to approve the mint restart 
535   // (Voting will be essential in these actions)
536   function restartMinting() onlyContract cantMint public returns (bool) {
537     mintingFinished = false;
538     MintRestarted(); // Notify the blockchain that the coin minting was restarted
539     return true;
540   }
541 
542   // Allow owner or contract to finish minting.
543   function finishMinting() onlyOwner canMint public returns (bool) {
544     return super.finishMinting();
545   }
546 
547   // Allow the system to create transactions for transfers when appropriate.
548   // (e.g. upgrading the token for everyone, voting to recover accounts for lost private keys, 
549   //    allowing the system to pay for transactions on someones behalf, allowing transaction automations)
550   // (Must be voted for on an approved contract to gain access to this function)
551   function contractTransfer(address _from, address _to, uint256 _value) public onlyContract returns (bool) {
552     require(_from != address(0));
553     require(_to != address(0));
554     require(_value > 0);
555     require(_value <= balances[_from]);
556 
557     balances[_from] = balances[_from].sub(_value);
558     balances[_to] = balances[_to].add(_value);
559     ContractTransfer(_from, _to, _value); // Notify blockchain the following transaction was contract initiated
560     Transfer(_from, _to, _value); // Call original transfer event to maintain compatibility with stardard transaction systems
561     return true;
562   }
563 
564 }
565 
566 // File: contracts/MensariiCoin.sol
567 
568 contract MensariiCoin is MintableContractOwnerToken {
569   string public name = "Mensarii Coin";
570   string public symbol = "MII";
571   uint8 public decimals = 18;
572 
573   function MensariiCoin() public {
574   }
575 
576 }
577 
578 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
579 
580 /**
581  * @title Crowdsale
582  * @dev Crowdsale is a base contract for managing a token crowdsale,
583  * allowing investors to purchase tokens with ether. This contract implements
584  * such functionality in its most fundamental form and can be extended to provide additional
585  * functionality and/or custom behavior.
586  * The external interface represents the basic interface for purchasing tokens, and conform
587  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
588  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
589  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
590  * behavior.
591  */
592 contract Crowdsale {
593   using SafeMath for uint256;
594 
595   // The token being sold
596   ERC20 public token;
597 
598   // Address where funds are collected
599   address public wallet;
600 
601   // How many token units a buyer gets per wei
602   uint256 public rate;
603 
604   // Amount of wei raised
605   uint256 public weiRaised;
606 
607   /**
608    * Event for token purchase logging
609    * @param purchaser who paid for the tokens
610    * @param beneficiary who got the tokens
611    * @param value weis paid for purchase
612    * @param amount amount of tokens purchased
613    */
614   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
615 
616   /**
617    * @param _rate Number of token units a buyer gets per wei
618    * @param _wallet Address where collected funds will be forwarded to
619    * @param _token Address of the token being sold
620    */
621   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
622     require(_rate > 0);
623     require(_wallet != address(0));
624     require(_token != address(0));
625 
626     rate = _rate;
627     wallet = _wallet;
628     token = _token;
629   }
630 
631   // -----------------------------------------
632   // Crowdsale external interface
633   // -----------------------------------------
634 
635   /**
636    * @dev fallback function ***DO NOT OVERRIDE***
637    */
638   function () external payable {
639     buyTokens(msg.sender);
640   }
641 
642   /**
643    * @dev low level token purchase ***DO NOT OVERRIDE***
644    * @param _beneficiary Address performing the token purchase
645    */
646   function buyTokens(address _beneficiary) public payable {
647 
648     uint256 weiAmount = msg.value;
649     _preValidatePurchase(_beneficiary, weiAmount);
650 
651     // calculate token amount to be created
652     uint256 tokens = _getTokenAmount(weiAmount);
653 
654     // update state
655     weiRaised = weiRaised.add(weiAmount);
656 
657     _processPurchase(_beneficiary, tokens);
658     emit TokenPurchase(
659       msg.sender,
660       _beneficiary,
661       weiAmount,
662       tokens
663     );
664 
665     _updatePurchasingState(_beneficiary, weiAmount);
666 
667     _forwardFunds();
668     _postValidatePurchase(_beneficiary, weiAmount);
669   }
670 
671   // -----------------------------------------
672   // Internal interface (extensible)
673   // -----------------------------------------
674 
675   /**
676    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
677    * @param _beneficiary Address performing the token purchase
678    * @param _weiAmount Value in wei involved in the purchase
679    */
680   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
681     require(_beneficiary != address(0));
682     require(_weiAmount != 0);
683   }
684 
685   /**
686    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
687    * @param _beneficiary Address performing the token purchase
688    * @param _weiAmount Value in wei involved in the purchase
689    */
690   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
691     // optional override
692   }
693 
694   /**
695    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
696    * @param _beneficiary Address performing the token purchase
697    * @param _tokenAmount Number of tokens to be emitted
698    */
699   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
700     token.transfer(_beneficiary, _tokenAmount);
701   }
702 
703   /**
704    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
705    * @param _beneficiary Address receiving the tokens
706    * @param _tokenAmount Number of tokens to be purchased
707    */
708   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
709     _deliverTokens(_beneficiary, _tokenAmount);
710   }
711 
712   /**
713    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
714    * @param _beneficiary Address receiving the tokens
715    * @param _weiAmount Value in wei involved in the purchase
716    */
717   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
718     // optional override
719   }
720 
721   /**
722    * @dev Override to extend the way in which ether is converted to tokens.
723    * @param _weiAmount Value in wei to be converted into tokens
724    * @return Number of tokens that can be purchased with the specified _weiAmount
725    */
726   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
727     return _weiAmount.mul(rate);
728   }
729 
730   /**
731    * @dev Determines how ETH is stored/forwarded on purchases.
732    */
733   function _forwardFunds() internal {
734     wallet.transfer(msg.value);
735   }
736 }
737 
738 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
739 
740 /**
741  * @title TimedCrowdsale
742  * @dev Crowdsale accepting contributions only within a time frame.
743  */
744 contract TimedCrowdsale is Crowdsale {
745   using SafeMath for uint256;
746 
747   uint256 public openingTime;
748   uint256 public closingTime;
749 
750   /**
751    * @dev Reverts if not in crowdsale time range.
752    */
753   modifier onlyWhileOpen {
754     // solium-disable-next-line security/no-block-members
755     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
756     _;
757   }
758 
759   /**
760    * @dev Constructor, takes crowdsale opening and closing times.
761    * @param _openingTime Crowdsale opening time
762    * @param _closingTime Crowdsale closing time
763    */
764   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
765     // solium-disable-next-line security/no-block-members
766     require(_openingTime >= block.timestamp);
767     require(_closingTime >= _openingTime);
768 
769     openingTime = _openingTime;
770     closingTime = _closingTime;
771   }
772 
773   /**
774    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
775    * @return Whether crowdsale period has elapsed
776    */
777   function hasClosed() public view returns (bool) {
778     // solium-disable-next-line security/no-block-members
779     return block.timestamp > closingTime;
780   }
781 
782   /**
783    * @dev Extend parent behavior requiring to be within contributing period
784    * @param _beneficiary Token purchaser
785    * @param _weiAmount Amount of wei contributed
786    */
787   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
788     super._preValidatePurchase(_beneficiary, _weiAmount);
789   }
790 
791 }
792 
793 // File: zeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
794 
795 /**
796  * @title FinalizableCrowdsale
797  * @dev Extension of Crowdsale where an owner can do extra work
798  * after finishing.
799  */
800 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
801   using SafeMath for uint256;
802 
803   bool public isFinalized = false;
804 
805   event Finalized();
806 
807   /**
808    * @dev Must be called after crowdsale ends, to do some extra finalization
809    * work. Calls the contract's finalization function.
810    */
811   function finalize() onlyOwner public {
812     require(!isFinalized);
813     require(hasClosed());
814 
815     finalization();
816     emit Finalized();
817 
818     isFinalized = true;
819   }
820 
821   /**
822    * @dev Can be overridden to add finalization logic. The overriding function
823    * should call super.finalization() to ensure the chain of finalization is
824    * executed entirely.
825    */
826   function finalization() internal {
827   }
828 
829 }
830 
831 // File: zeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
832 
833 /**
834  * @title RefundVault
835  * @dev This contract is used for storing funds while a crowdsale
836  * is in progress. Supports refunding the money if crowdsale fails,
837  * and forwarding it if crowdsale is successful.
838  */
839 contract RefundVault is Ownable {
840   using SafeMath for uint256;
841 
842   enum State { Active, Refunding, Closed }
843 
844   mapping (address => uint256) public deposited;
845   address public wallet;
846   State public state;
847 
848   event Closed();
849   event RefundsEnabled();
850   event Refunded(address indexed beneficiary, uint256 weiAmount);
851 
852   /**
853    * @param _wallet Vault address
854    */
855   function RefundVault(address _wallet) public {
856     require(_wallet != address(0));
857     wallet = _wallet;
858     state = State.Active;
859   }
860 
861   /**
862    * @param investor Investor address
863    */
864   function deposit(address investor) onlyOwner public payable {
865     require(state == State.Active);
866     deposited[investor] = deposited[investor].add(msg.value);
867   }
868 
869   function close() onlyOwner public {
870     require(state == State.Active);
871     state = State.Closed;
872     emit Closed();
873     wallet.transfer(address(this).balance);
874   }
875 
876   function enableRefunds() onlyOwner public {
877     require(state == State.Active);
878     state = State.Refunding;
879     emit RefundsEnabled();
880   }
881 
882   /**
883    * @param investor Investor address
884    */
885   function refund(address investor) public {
886     require(state == State.Refunding);
887     uint256 depositedValue = deposited[investor];
888     deposited[investor] = 0;
889     investor.transfer(depositedValue);
890     emit Refunded(investor, depositedValue);
891   }
892 }
893 
894 // File: zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
895 
896 /**
897  * @title RefundableCrowdsale
898  * @dev Extension of Crowdsale contract that adds a funding goal, and
899  * the possibility of users getting a refund if goal is not met.
900  * Uses a RefundVault as the crowdsale's vault.
901  */
902 contract RefundableCrowdsale is FinalizableCrowdsale {
903   using SafeMath for uint256;
904 
905   // minimum amount of funds to be raised in weis
906   uint256 public goal;
907 
908   // refund vault used to hold funds while crowdsale is running
909   RefundVault public vault;
910 
911   /**
912    * @dev Constructor, creates RefundVault.
913    * @param _goal Funding goal
914    */
915   function RefundableCrowdsale(uint256 _goal) public {
916     require(_goal > 0);
917     vault = new RefundVault(wallet);
918     goal = _goal;
919   }
920 
921   /**
922    * @dev Investors can claim refunds here if crowdsale is unsuccessful
923    */
924   function claimRefund() public {
925     require(isFinalized);
926     require(!goalReached());
927 
928     vault.refund(msg.sender);
929   }
930 
931   /**
932    * @dev Checks whether funding goal was reached.
933    * @return Whether funding goal was reached
934    */
935   function goalReached() public view returns (bool) {
936     return weiRaised >= goal;
937   }
938 
939   /**
940    * @dev vault finalization task, called when owner calls finalize()
941    */
942   function finalization() internal {
943     if (goalReached()) {
944       vault.close();
945     } else {
946       vault.enableRefunds();
947     }
948 
949     super.finalization();
950   }
951 
952   /**
953    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
954    */
955   function _forwardFunds() internal {
956     vault.deposit.value(msg.value)(msg.sender);
957   }
958 
959 }
960 
961 // File: zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
962 
963 /**
964  * @title MintedCrowdsale
965  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
966  * Token ownership should be transferred to MintedCrowdsale for minting. 
967  */
968 contract MintedCrowdsale is Crowdsale {
969 
970   /**
971    * @dev Overrides delivery by minting tokens upon purchase.
972    * @param _beneficiary Token purchaser
973    * @param _tokenAmount Number of tokens to be minted
974    */
975   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
976     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
977   }
978 }
979 
980 // File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
981 
982 /**
983  * @title CappedCrowdsale
984  * @dev Crowdsale with a limit for total contributions.
985  */
986 contract CappedCrowdsale is Crowdsale {
987   using SafeMath for uint256;
988 
989   uint256 public cap;
990 
991   /**
992    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
993    * @param _cap Max amount of wei to be contributed
994    */
995   function CappedCrowdsale(uint256 _cap) public {
996     require(_cap > 0);
997     cap = _cap;
998   }
999 
1000   /**
1001    * @dev Checks whether the cap has been reached. 
1002    * @return Whether the cap was reached
1003    */
1004   function capReached() public view returns (bool) {
1005     return weiRaised >= cap;
1006   }
1007 
1008   /**
1009    * @dev Extend parent behavior requiring purchase to respect the funding cap.
1010    * @param _beneficiary Token purchaser
1011    * @param _weiAmount Amount of wei contributed
1012    */
1013   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1014     super._preValidatePurchase(_beneficiary, _weiAmount);
1015     require(weiRaised.add(_weiAmount) <= cap);
1016   }
1017 
1018 }
1019 
1020 // File: contracts/MensariiCrowdsale.sol
1021 
1022 contract MensariiCrowdsale is CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale, MintedCrowdsale {
1023 
1024   function MensariiCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet, MintableToken _token) public
1025     CappedCrowdsale(_cap)
1026     FinalizableCrowdsale()
1027     RefundableCrowdsale(_goal)
1028     TimedCrowdsale(_startTime, _endTime)
1029     Crowdsale(_rate, _wallet, _token)
1030   {
1031     //As goal needs to be met for a successful crowdsale
1032     //the value needs to less or equal than a cap which is limit for accepted funds
1033     require(_goal <= _cap);
1034   }
1035 
1036   function isOpen() view public returns (bool){
1037     return now >= openingTime && now <= closingTime;
1038   }
1039 
1040 }