1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
31 
32 /**
33  * @title SafeERC20
34  * @dev Wrappers around ERC20 operations that throw on failure.
35  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
36  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
37  */
38 library SafeERC20 {
39   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
40     assert(token.transfer(to, value));
41   }
42 
43   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
44     assert(token.transferFrom(from, to, value));
45   }
46 
47   function safeApprove(ERC20 token, address spender, uint256 value) internal {
48     assert(token.approve(spender, value));
49   }
50 }
51 
52 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 // File: zeppelin-solidity/contracts/ownership/CanReclaimToken.sol
95 
96 /**
97  * @title Contracts that should be able to recover tokens
98  * @author SylTi
99  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
100  * This will prevent any accidental loss of tokens.
101  */
102 contract CanReclaimToken is Ownable {
103   using SafeERC20 for ERC20Basic;
104 
105   /**
106    * @dev Reclaim all ERC20Basic compatible tokens
107    * @param token ERC20Basic The address of the token contract
108    */
109   function reclaimToken(ERC20Basic token) external onlyOwner {
110     uint256 balance = token.balanceOf(this);
111     token.safeTransfer(owner, balance);
112   }
113 
114 }
115 
116 // File: zeppelin-solidity/contracts/math/SafeMath.sol
117 
118 /**
119  * @title SafeMath
120  * @dev Math operations with safety checks that throw on error
121  */
122 library SafeMath {
123 
124   /**
125   * @dev Multiplies two numbers, throws on overflow.
126   */
127   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128     if (a == 0) {
129       return 0;
130     }
131     uint256 c = a * b;
132     assert(c / a == b);
133     return c;
134   }
135 
136   /**
137   * @dev Integer division of two numbers, truncating the quotient.
138   */
139   function div(uint256 a, uint256 b) internal pure returns (uint256) {
140     // assert(b > 0); // Solidity automatically throws when dividing by 0
141     uint256 c = a / b;
142     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143     return c;
144   }
145 
146   /**
147   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
148   */
149   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150     assert(b <= a);
151     return a - b;
152   }
153 
154   /**
155   * @dev Adds two numbers, throws on overflow.
156   */
157   function add(uint256 a, uint256 b) internal pure returns (uint256) {
158     uint256 c = a + b;
159     assert(c >= a);
160     return c;
161   }
162 }
163 
164 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
165 
166 /**
167  * @title Basic token
168  * @dev Basic version of StandardToken, with no allowances.
169  */
170 contract BasicToken is ERC20Basic {
171   using SafeMath for uint256;
172 
173   mapping(address => uint256) balances;
174 
175   uint256 totalSupply_;
176 
177   /**
178   * @dev total number of tokens in existence
179   */
180   function totalSupply() public view returns (uint256) {
181     return totalSupply_;
182   }
183 
184   /**
185   * @dev transfer token for a specified address
186   * @param _to The address to transfer to.
187   * @param _value The amount to be transferred.
188   */
189   function transfer(address _to, uint256 _value) public returns (bool) {
190     require(_to != address(0));
191     require(_value <= balances[msg.sender]);
192 
193     // SafeMath.sub will throw if there is not enough balance.
194     balances[msg.sender] = balances[msg.sender].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     Transfer(msg.sender, _to, _value);
197     return true;
198   }
199 
200   /**
201   * @dev Gets the balance of the specified address.
202   * @param _owner The address to query the the balance of.
203   * @return An uint256 representing the amount owned by the passed address.
204   */
205   function balanceOf(address _owner) public view returns (uint256 balance) {
206     return balances[_owner];
207   }
208 
209 }
210 
211 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * @dev https://github.com/ethereum/EIPs/issues/20
218  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract StandardToken is ERC20, BasicToken {
221 
222   mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
232     require(_to != address(0));
233     require(_value <= balances[_from]);
234     require(_value <= allowed[_from][msg.sender]);
235 
236     balances[_from] = balances[_from].sub(_value);
237     balances[_to] = balances[_to].add(_value);
238     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
239     Transfer(_from, _to, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
245    *
246    * Beware that changing an allowance with this method brings the risk that someone may use both the old
247    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250    * @param _spender The address which will spend the funds.
251    * @param _value The amount of tokens to be spent.
252    */
253   function approve(address _spender, uint256 _value) public returns (bool) {
254     allowed[msg.sender][_spender] = _value;
255     Approval(msg.sender, _spender, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Function to check the amount of tokens that an owner allowed to a spender.
261    * @param _owner address The address which owns the funds.
262    * @param _spender address The address which will spend the funds.
263    * @return A uint256 specifying the amount of tokens still available for the spender.
264    */
265   function allowance(address _owner, address _spender) public view returns (uint256) {
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
279   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
280     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
281     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285   /**
286    * @dev Decrease the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To decrement
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _subtractedValue The amount of tokens to decrease the allowance by.
294    */
295   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
296     uint oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue > oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306 }
307 
308 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
309 
310 /**
311  * @title Mintable token
312  * @dev Simple ERC20 Token example, with mintable token creation
313  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
314  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
315  */
316 contract MintableToken is StandardToken, Ownable {
317   event Mint(address indexed to, uint256 amount);
318   event MintFinished();
319 
320   bool public mintingFinished = false;
321 
322 
323   modifier canMint() {
324     require(!mintingFinished);
325     _;
326   }
327 
328   /**
329    * @dev Function to mint tokens
330    * @param _to The address that will receive the minted tokens.
331    * @param _amount The amount of tokens to mint.
332    * @return A boolean that indicates if the operation was successful.
333    */
334   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
335     totalSupply_ = totalSupply_.add(_amount);
336     balances[_to] = balances[_to].add(_amount);
337     Mint(_to, _amount);
338     Transfer(address(0), _to, _amount);
339     return true;
340   }
341 
342   /**
343    * @dev Function to stop minting new tokens.
344    * @return True if the operation was successful.
345    */
346   function finishMinting() onlyOwner canMint public returns (bool) {
347     mintingFinished = true;
348     MintFinished();
349     return true;
350   }
351 }
352 
353 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
354 
355 /**
356  * @title Pausable
357  * @dev Base contract which allows children to implement an emergency stop mechanism.
358  */
359 contract Pausable is Ownable {
360   event Pause();
361   event Unpause();
362 
363   bool public paused = false;
364 
365 
366   /**
367    * @dev Modifier to make a function callable only when the contract is not paused.
368    */
369   modifier whenNotPaused() {
370     require(!paused);
371     _;
372   }
373 
374   /**
375    * @dev Modifier to make a function callable only when the contract is paused.
376    */
377   modifier whenPaused() {
378     require(paused);
379     _;
380   }
381 
382   /**
383    * @dev called by the owner to pause, triggers stopped state
384    */
385   function pause() onlyOwner whenNotPaused public {
386     paused = true;
387     Pause();
388   }
389 
390   /**
391    * @dev called by the owner to unpause, returns to normal state
392    */
393   function unpause() onlyOwner whenPaused public {
394     paused = false;
395     Unpause();
396   }
397 }
398 
399 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
400 
401 /**
402  * @title Pausable token
403  * @dev StandardToken modified with pausable transfers.
404  **/
405 contract PausableToken is StandardToken, Pausable {
406 
407   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
408     return super.transfer(_to, _value);
409   }
410 
411   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
412     return super.transferFrom(_from, _to, _value);
413   }
414 
415   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
416     return super.approve(_spender, _value);
417   }
418 
419   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
420     return super.increaseApproval(_spender, _addedValue);
421   }
422 
423   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
424     return super.decreaseApproval(_spender, _subtractedValue);
425   }
426 }
427 
428 // File: zeppelin-solidity/contracts/token/ERC827/ERC827.sol
429 
430 /**
431    @title ERC827 interface, an extension of ERC20 token standard
432 
433    Interface of a ERC827 token, following the ERC20 standard with extra
434    methods to transfer value and data and execute calls in transfers and
435    approvals.
436  */
437 contract ERC827 is ERC20 {
438 
439   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
440   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
441   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
442 
443 }
444 
445 // File: zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol
446 
447 /**
448    @title ERC827, an extension of ERC20 token standard
449 
450    Implementation the ERC827, following the ERC20 standard with extra
451    methods to transfer value and data and execute calls in transfers and
452    approvals.
453    Uses OpenZeppelin StandardToken.
454  */
455 contract ERC827Token is ERC827, StandardToken {
456 
457   /**
458      @dev Addition to ERC20 token methods. It allows to
459      approve the transfer of value and execute a call with the sent data.
460 
461      Beware that changing an allowance with this method brings the risk that
462      someone may use both the old and the new allowance by unfortunate
463      transaction ordering. One possible solution to mitigate this race condition
464      is to first reduce the spender's allowance to 0 and set the desired value
465      afterwards:
466      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
467 
468      @param _spender The address that will spend the funds.
469      @param _value The amount of tokens to be spent.
470      @param _data ABI-encoded contract call to call `_to` address.
471 
472      @return true if the call function was executed successfully
473    */
474   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
475     require(_spender != address(this));
476 
477     super.approve(_spender, _value);
478 
479     require(_spender.call(_data));
480 
481     return true;
482   }
483 
484   /**
485      @dev Addition to ERC20 token methods. Transfer tokens to a specified
486      address and execute a call with the sent data on the same transaction
487 
488      @param _to address The address which you want to transfer to
489      @param _value uint256 the amout of tokens to be transfered
490      @param _data ABI-encoded contract call to call `_to` address.
491 
492      @return true if the call function was executed successfully
493    */
494   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
495     require(_to != address(this));
496 
497     super.transfer(_to, _value);
498 
499     require(_to.call(_data));
500     return true;
501   }
502 
503   /**
504      @dev Addition to ERC20 token methods. Transfer tokens from one address to
505      another and make a contract call on the same transaction
506 
507      @param _from The address which you want to send tokens from
508      @param _to The address which you want to transfer to
509      @param _value The amout of tokens to be transferred
510      @param _data ABI-encoded contract call to call `_to` address.
511 
512      @return true if the call function was executed successfully
513    */
514   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
515     require(_to != address(this));
516 
517     super.transferFrom(_from, _to, _value);
518 
519     require(_to.call(_data));
520     return true;
521   }
522 
523   /**
524    * @dev Addition to StandardToken methods. Increase the amount of tokens that
525    * an owner allowed to a spender and execute a call with the sent data.
526    *
527    * approve should be called when allowed[_spender] == 0. To increment
528    * allowed value is better to use this function to avoid 2 calls (and wait until
529    * the first transaction is mined)
530    * From MonolithDAO Token.sol
531    * @param _spender The address which will spend the funds.
532    * @param _addedValue The amount of tokens to increase the allowance by.
533    * @param _data ABI-encoded contract call to call `_spender` address.
534    */
535   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
536     require(_spender != address(this));
537 
538     super.increaseApproval(_spender, _addedValue);
539 
540     require(_spender.call(_data));
541 
542     return true;
543   }
544 
545   /**
546    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
547    * an owner allowed to a spender and execute a call with the sent data.
548    *
549    * approve should be called when allowed[_spender] == 0. To decrement
550    * allowed value is better to use this function to avoid 2 calls (and wait until
551    * the first transaction is mined)
552    * From MonolithDAO Token.sol
553    * @param _spender The address which will spend the funds.
554    * @param _subtractedValue The amount of tokens to decrease the allowance by.
555    * @param _data ABI-encoded contract call to call `_spender` address.
556    */
557   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
558     require(_spender != address(this));
559 
560     super.decreaseApproval(_spender, _subtractedValue);
561 
562     require(_spender.call(_data));
563 
564     return true;
565   }
566 
567 }
568 
569 // File: contracts/PalliumToken.sol
570 
571 contract PalliumToken is MintableToken, PausableToken, ERC827Token, CanReclaimToken {
572     string public constant name = 'PalliumToken';
573     string public constant symbol = 'PLMT';
574     uint8  public constant decimals = 18;
575 
576     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
577         require (totalSupply_ + _amount <= 250 * 10**6 * 10**18);
578         return super.mint(_to, _amount);
579     }
580 }
581 
582 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
583 
584 /**
585  * @title Crowdsale
586  * @dev Crowdsale is a base contract for managing a token crowdsale,
587  * allowing investors to purchase tokens with ether. This contract implements
588  * such functionality in its most fundamental form and can be extended to provide additional
589  * functionality and/or custom behavior.
590  * The external interface represents the basic interface for purchasing tokens, and conform
591  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
592  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
593  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
594  * behavior.
595  */
596 
597 contract Crowdsale {
598   using SafeMath for uint256;
599 
600   // The token being sold
601   ERC20 public token;
602 
603   // Address where funds are collected
604   address public wallet;
605 
606   // How many token units a buyer gets per wei
607   uint256 public rate;
608 
609   // Amount of wei raised
610   uint256 public weiRaised;
611 
612   /**
613    * Event for token purchase logging
614    * @param purchaser who paid for the tokens
615    * @param beneficiary who got the tokens
616    * @param value weis paid for purchase
617    * @param amount amount of tokens purchased
618    */
619   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
620 
621   /**
622    * @param _rate Number of token units a buyer gets per wei
623    * @param _wallet Address where collected funds will be forwarded to
624    * @param _token Address of the token being sold
625    */
626   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
627     require(_rate > 0);
628     require(_wallet != address(0));
629     require(_token != address(0));
630 
631     rate = _rate;
632     wallet = _wallet;
633     token = _token;
634   }
635 
636   // -----------------------------------------
637   // Crowdsale external interface
638   // -----------------------------------------
639 
640   /**
641    * @dev fallback function ***DO NOT OVERRIDE***
642    */
643   function () external payable {
644     buyTokens(msg.sender);
645   }
646 
647   /**
648    * @dev low level token purchase ***DO NOT OVERRIDE***
649    * @param _beneficiary Address performing the token purchase
650    */
651   function buyTokens(address _beneficiary) public payable {
652 
653     uint256 weiAmount = msg.value;
654     _preValidatePurchase(_beneficiary, weiAmount);
655 
656     // calculate token amount to be created
657     uint256 tokens = _getTokenAmount(weiAmount);
658 
659     // update state
660     weiRaised = weiRaised.add(weiAmount);
661 
662     _processPurchase(_beneficiary, tokens);
663     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
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
676    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
677    * @param _beneficiary Address performing the token purchase
678    * @param _weiAmount Value in wei involved in the purchase
679    */
680   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
681     require(_beneficiary != address(0));
682     require(_weiAmount != 0);
683     token = token;
684   }
685 
686   function _postValidatePurchase(address, uint256) internal {
687     // optional override
688     token = token;
689   }
690 
691   /**
692    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
693    * @param _beneficiary Address performing the token purchase
694    * @param _tokenAmount Number of tokens to be emitted
695    */
696   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
697     token.transfer(_beneficiary, _tokenAmount);
698   }
699 
700   /**
701    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
702    * @param _beneficiary Address receiving the tokens
703    * @param _tokenAmount Number of tokens to be purchased
704    */
705   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
706     _deliverTokens(_beneficiary, _tokenAmount);
707   }
708 
709   function _updatePurchasingState(address, uint256) internal {
710     // optional override
711     token = token;
712   }
713 
714   /**
715    * @dev Override to extend the way in which ether is converted to tokens.
716    * @param _weiAmount Value in wei to be converted into tokens
717    * @return Number of tokens that can be purchased with the specified _weiAmount
718    */
719   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
720     return _weiAmount.mul(rate);
721   }
722 
723   /**
724    * @dev Determines how ETH is stored/forwarded on purchases.
725    */
726   function _forwardFunds() internal {
727     wallet.transfer(msg.value);
728   }
729 }
730 
731 // File: contracts/StagedCrowdsale.sol
732 
733 /**
734  * @title StagedCrowdsale
735  */
736 
737 contract StagedCrowdsale is Crowdsale {
738     struct Stage {
739         uint    index;
740         uint256 hardCap;
741         uint256 softCap;
742         uint256 currentMinted;
743         uint256 bonusMultiplier;
744         uint256 startTime;
745         uint256 endTime;
746     }
747 
748     mapping (uint => Stage) public stages;
749     uint256 public currentStage;
750 
751     enum State { Created, Paused, Running, Finished }
752     State public currentState = State.Created;
753 
754     function StagedCrowdsale() public {
755         currentStage = 0;
756     }
757 
758     function setStage(uint _nextStage) internal {
759         currentStage = _nextStage;
760     }
761 
762     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
763         require(currentState == State.Running);
764         require((now >= stages[currentStage].startTime) && (now <= stages[currentStage].endTime));
765         require(_beneficiary != address(0));
766         require(_weiAmount >= 200 szabo);
767     } 
768 
769     function computeTokensWithBonus(uint256 _weiAmount) public view returns(uint256) {
770         uint256 tokenAmount = super._getTokenAmount(_weiAmount);
771         uint256 bonusAmount = tokenAmount.mul(stages[currentStage].bonusMultiplier).div(100); 
772         return tokenAmount.add(bonusAmount);
773     }
774 
775     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
776         uint256 tokenAmount = computeTokensWithBonus(_weiAmount);
777 
778         uint256 currentHardCap = stages[currentStage].hardCap;
779         uint256 currentMinted = stages[currentStage].currentMinted;
780         if (currentMinted.add(tokenAmount) > currentHardCap) {
781             return currentHardCap.sub(currentMinted);
782         } 
783         return tokenAmount;
784     } 
785 
786     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
787         require(_tokenAmount > 0);
788 
789         super._processPurchase(_beneficiary, _tokenAmount);
790 
791         uint256 surrender = computeTokensWithBonus(msg.value) - _tokenAmount;
792         if (msg.value > 0 && surrender > 0)
793         {   
794             uint256 currentRate = computeTokensWithBonus(msg.value) / msg.value;
795             uint256 surrenderEth = surrender.div(currentRate);
796             _beneficiary.transfer(surrenderEth);
797         }
798     }
799 
800     function _getTokenRaised(uint256 _weiAmount) internal view returns (uint256) {
801         return stages[currentStage].currentMinted.add(_getTokenAmount(_weiAmount));
802     }
803 
804     function _updatePurchasingState(address, uint256 _weiAmount) internal {
805         stages[currentStage].currentMinted = stages[currentStage].currentMinted.add(computeTokensWithBonus(_weiAmount));
806     }
807 }
808 
809 // File: zeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
810 
811 /**
812  * @title RefundVault
813  * @dev This contract is used for storing funds while a crowdsale
814  * is in progress. Supports refunding the money if crowdsale fails,
815  * and forwarding it if crowdsale is successful.
816  */
817 contract RefundVault is Ownable {
818   using SafeMath for uint256;
819 
820   enum State { Active, Refunding, Closed }
821 
822   mapping (address => uint256) public deposited;
823   address public wallet;
824   State public state;
825 
826   event Closed();
827   event RefundsEnabled();
828   event Refunded(address indexed beneficiary, uint256 weiAmount);
829 
830   /**
831    * @param _wallet Vault address
832    */
833   function RefundVault(address _wallet) public {
834     require(_wallet != address(0));
835     wallet = _wallet;
836     state = State.Active;
837   }
838 
839   /**
840    * @param investor Investor address
841    */
842   function deposit(address investor) onlyOwner public payable {
843     require(state == State.Active);
844     deposited[investor] = deposited[investor].add(msg.value);
845   }
846 
847   function close() onlyOwner public {
848     require(state == State.Active);
849     state = State.Closed;
850     Closed();
851     wallet.transfer(this.balance);
852   }
853 
854   function enableRefunds() onlyOwner public {
855     require(state == State.Active);
856     state = State.Refunding;
857     RefundsEnabled();
858   }
859 
860   /**
861    * @param investor Investor address
862    */
863   function refund(address investor) public {
864     require(state == State.Refunding);
865     uint256 depositedValue = deposited[investor];
866     deposited[investor] = 0;
867     investor.transfer(depositedValue);
868     Refunded(investor, depositedValue);
869   }
870 }
871 
872 // File: contracts/StagedRefundVault.sol
873 
874 contract StagedRefundVault is RefundVault {
875 
876     event ClosedStage();
877     event Active();
878     function StagedRefundVault (address _wallet) public
879         RefundVault(_wallet) {
880     }
881     
882     function stageClose() onlyOwner public {
883         ClosedStage();
884         wallet.transfer(this.balance);
885     }
886 
887     function activate() onlyOwner public {
888         require(state == State.Refunding);
889         state = State.Active;
890         Active();
891     }
892 }
893 
894 // File: zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
895 
896 /**
897  * @title MintedCrowdsale
898  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
899  * Token ownership should be transferred to MintedCrowdsale for minting. 
900  */
901 contract MintedCrowdsale is Crowdsale {
902 
903   /**
904   * @dev Overrides delivery by minting tokens upon purchase.
905   * @param _beneficiary Token purchaser
906   * @param _tokenAmount Number of tokens to be minted
907   */
908   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
909     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
910   }
911 }
912 
913 // File: contracts/PalliumCrowdsale.sol
914 
915 contract PalliumCrowdsale is StagedCrowdsale, MintedCrowdsale, Pausable {
916     StagedRefundVault public vault;
917 
918     function PalliumCrowdsale(uint256 _rate, address _wallet) public
919         Crowdsale(_rate, _wallet, new PalliumToken())
920         StagedCrowdsale(){  
921             // 25.000.000 PLMT for team token pool
922             _processPurchase(_wallet, 25*(10**24));
923             vault = new StagedRefundVault(_wallet);
924 
925             stages[0] = Stage(0, 5*(10**24), 33*(10**23), 0, 100, 1522540800, 1525132800);
926             stages[1] = Stage(1, 375*(10**23), 2475*(10**22),  0, 50, 1533081600, 1535760000);
927             stages[2] = Stage(2, 75*(10**24), 495*(10**23), 0, 25, 1543622400, 1546300800);
928             stages[3] = Stage(3, 1075*(10**23), 7095*(10**22), 0, 15, 1554076800, 1556668800);
929     }   
930 
931     function goalReached() internal view returns (bool) {
932         return stages[currentStage].currentMinted >= stages[currentStage].softCap;
933     }
934 
935     function hardCapReached() internal view returns (bool) {
936         return stages[currentStage].currentMinted >= stages[currentStage].hardCap;
937     }
938 
939     function claimRefund() public {
940       require(!goalReached());
941       require(currentState == State.Running);
942 
943       vault.refund(msg.sender);
944     }
945 
946     // this is used if previous stage did not reach the softCap, 
947     // the refaund is available before the next stage begins
948     function toggleVaultStateToAcive() public onlyOwner {
949         require(now >= stages[currentStage].startTime - 1 days);
950         vault.activate();
951     }
952 
953     function finalizeCurrentStage() public onlyOwner {
954         require(now > stages[currentStage].endTime || hardCapReached());
955         require(currentState == State.Running);
956 
957         if (goalReached()) {
958             vault.stageClose();
959         } else {
960             vault.enableRefunds();
961         }
962 
963         if (stages[currentStage].index < 3) {
964             setStage(currentStage + 1);
965         } else
966         {
967             finalizationCrowdsale();
968         }
969     }
970 
971     function finalizationCrowdsale() internal {
972         vault.close();
973         setState(StagedCrowdsale.State.Finished);
974         PalliumToken(token).finishMinting();
975         PalliumToken(token).transferOwnership(owner);
976     } 
977 
978     function migrateCrowdsale(address _newOwner) public onlyOwner {
979         require(currentState == State.Paused);
980 
981         PalliumToken(token).transferOwnership(_newOwner);
982         StagedRefundVault(vault).transferOwnership(_newOwner);
983     }
984 
985     function setState(State _nextState) public onlyOwner {
986         bool canToggleState
987             =  (currentState == State.Created && _nextState == State.Running)
988             || (currentState == State.Running && _nextState == State.Paused)
989             || (currentState == State.Paused  && _nextState == State.Running)
990             || (currentState == State.Running && _nextState == State.Finished);
991 
992         require(canToggleState);
993         currentState = _nextState;
994     }
995 
996     function manualPurchaseTokens (address _beneficiary, uint256 _weiAmount) public onlyOwner {
997        
998         _preValidatePurchase(_beneficiary, _weiAmount);
999 
1000         uint256 tokens = _getTokenAmount(_weiAmount);
1001 
1002         _processPurchase(_beneficiary, tokens);
1003         TokenPurchase(msg.sender, _beneficiary, _weiAmount, tokens);
1004         _updatePurchasingState(_beneficiary, _weiAmount);
1005     }
1006 
1007     function _forwardFunds() internal {
1008         vault.deposit.value(this.balance)(msg.sender);
1009     }
1010 
1011 }