1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------
4 // Based on code by OpenZeppelin
5 // ----------------------------------------------------------------------
6 // Copyright (c) 2016 Smart Contract Solutions, Inc.
7 // Released under the MIT license
8 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/LICENSE
9 // ----------------------------------------------------------------------
10 
11 
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 
50 }
51 
52 /**
53  * @title Pausable
54  * @dev Base contract which allows children to implement an emergency stop mechanism.
55  */
56 contract Pausable is Ownable {
57   event Pause();
58   event Unpause();
59 
60   bool public paused = false;
61 
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is not paused.
65    */
66   modifier whenNotPaused() {
67     require(!paused);
68     _;
69   }
70 
71   /**
72    * @dev Modifier to make a function callable only when the contract is paused.
73    */
74   modifier whenPaused() {
75     require(paused);
76     _;
77   }
78 
79   /**
80    * @dev called by the owner to pause, triggers stopped state
81    */
82   function pause() onlyOwner whenNotPaused public {
83     paused = true;
84     Pause();
85   }
86 
87   /**
88    * @dev called by the owner to unpause, returns to normal state
89    */
90   function unpause() onlyOwner whenPaused public {
91     paused = false;
92     Unpause();
93   }
94 }
95 
96 
97 /**
98  * @title SafeMath
99  * @dev Math operations with safety checks that throw on error
100  */
101 library SafeMath {
102 
103   /**
104   * @dev Multiplies two numbers, throws on overflow.
105   */
106   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107     if (a == 0) {
108       return 0;
109     }
110     uint256 c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return c;
123   }
124 
125   /**
126   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129     assert(b <= a);
130     return a - b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 a, uint256 b) internal pure returns (uint256) {
137     uint256 c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 /**
144  * @title ERC20Basic
145  * @dev Simpler version of ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/179
147  */
148 contract ERC20Basic {
149   function totalSupply() public view returns (uint256);
150   function balanceOf(address who) public view returns (uint256);
151   function transfer(address to, uint256 value) public returns (bool);
152   event Transfer(address indexed from, address indexed to, uint256 value);
153 }
154 
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 
168 /**
169  * @title Crowdsale
170  * @dev Crowdsale is a base contract for managing a token crowdsale,
171  * allowing investors to purchase tokens with ether. This contract implements
172  * such functionality in its most fundamental form and can be extended to provide additional
173  * functionality and/or custom behavior.
174  * The external interface represents the basic interface for purchasing tokens, and conform
175  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
176  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
177  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
178  * behavior.
179  */
180 
181 contract Crowdsale {
182   using SafeMath for uint256;
183 
184   // The token being sold
185   ERC20 public token;
186 
187   // Address where funds are collected
188   address public wallet;
189 
190   // How many token units a buyer gets per wei
191   uint256 public rate;
192 
193   // Amount of wei raised
194   uint256 public weiRaised;
195 
196   /**
197    * Event for token purchase logging
198    * @param purchaser who paid for the tokens
199    * @param beneficiary who got the tokens
200    * @param value weis paid for purchase
201    * @param amount amount of tokens purchased
202    */
203   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
204 
205   /**
206    * @param _rate Number of token units a buyer gets per wei
207    * @param _wallet Address where collected funds will be forwarded to
208    * @param _token Address of the token being sold
209    */
210   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
211     require(_rate > 0);
212     require(_wallet != address(0));
213     require(_token != address(0));
214 
215     rate = _rate;
216     wallet = _wallet;
217     token = _token;
218   }
219 
220   // -----------------------------------------
221   // Crowdsale external interface
222   // -----------------------------------------
223 
224   /**
225    * @dev fallback function ***DO NOT OVERRIDE***
226    */
227   function () external payable {
228     buyTokens(msg.sender);
229   }
230 
231   /**
232    * @dev low level token purchase ***DO NOT OVERRIDE***
233    * @param _beneficiary Address performing the token purchase
234    */
235   function buyTokens(address _beneficiary) public payable {
236 
237     uint256 weiAmount = msg.value;
238     _preValidatePurchase(_beneficiary, weiAmount);
239 
240     // calculate token amount to be created
241     uint256 tokens = _getTokenAmount(weiAmount);
242 
243     // update state
244     weiRaised = weiRaised.add(weiAmount);
245 
246     _processPurchase(_beneficiary, tokens);
247     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
248 
249     _updatePurchasingState(_beneficiary, weiAmount);
250 
251     _forwardFunds();
252     _postValidatePurchase(_beneficiary, weiAmount);
253   }
254 
255   // -----------------------------------------
256   // Internal interface (extensible)
257   // -----------------------------------------
258 
259   /**
260    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
261    * @param _beneficiary Address performing the token purchase
262    * @param _weiAmount Value in wei involved in the purchase
263    */
264   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
265     require(_beneficiary != address(0));
266     require(_weiAmount != 0);
267   }
268 
269   /**
270    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
271    * @param _beneficiary Address performing the token purchase
272    * @param _weiAmount Value in wei involved in the purchase
273    */
274   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
275     // optional override
276   }
277 
278   /**
279    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
280    * @param _beneficiary Address performing the token purchase
281    * @param _tokenAmount Number of tokens to be emitted
282    */
283   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
284     token.transfer(_beneficiary, _tokenAmount);
285   }
286 
287   /**
288    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
289    * @param _beneficiary Address receiving the tokens
290    * @param _tokenAmount Number of tokens to be purchased
291    */
292   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
293     _deliverTokens(_beneficiary, _tokenAmount);
294   }
295 
296   /**
297    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
298    * @param _beneficiary Address receiving the tokens
299    * @param _weiAmount Value in wei involved in the purchase
300    */
301   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
302     // optional override
303   }
304 
305   /**
306    * @dev Override to extend the way in which ether is converted to tokens.
307    * @param _weiAmount Value in wei to be converted into tokens
308    * @return Number of tokens that can be purchased with the specified _weiAmount
309    */
310   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
311     return _weiAmount.mul(rate);
312   }
313 
314   /**
315    * @dev Determines how ETH is stored/forwarded on purchases.
316    */
317   function _forwardFunds() internal {
318     wallet.transfer(msg.value);
319   }
320 }
321 
322 /**
323  * @title TimedCrowdsale
324  * @dev Crowdsale accepting contributions only within a time frame.
325  */
326 contract TimedCrowdsale is Crowdsale {
327   using SafeMath for uint256;
328 
329   uint256 public openingTime;
330   uint256 public closingTime;
331 
332   /**
333    * @dev Reverts if not in crowdsale time range. 
334    */
335   modifier onlyWhileOpen {
336     require(now >= openingTime && now <= closingTime);
337     _;
338   }
339 
340   /**
341    * @dev Constructor, takes crowdsale opening and closing times.
342    * @param _openingTime Crowdsale opening time
343    * @param _closingTime Crowdsale closing time
344    */
345   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
346     require(_openingTime >= now);
347     require(_closingTime >= _openingTime);
348 
349     openingTime = _openingTime;
350     closingTime = _closingTime;
351   }
352 
353   /**
354    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
355    * @return Whether crowdsale period has elapsed
356    */
357   function hasClosed() public view returns (bool) {
358     return now > closingTime;
359   }
360   
361   /**
362    * @dev Extend parent behavior requiring to be within contributing period
363    * @param _beneficiary Token purchaser
364    * @param _weiAmount Amount of wei contributed
365    */
366   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
367     super._preValidatePurchase(_beneficiary, _weiAmount);
368   }
369 
370 }
371 
372 
373 /**
374  * @title FinalizableCrowdsale
375  * @dev Extension of Crowdsale where an owner can do extra work
376  * after finishing.
377  */
378 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
379   using SafeMath for uint256;
380 
381   bool public isFinalized = false;
382 
383   event Finalized();
384 
385   /**
386    * @dev Must be called after crowdsale ends, to do some extra finalization
387    * work. Calls the contract's finalization function.
388    */
389   function finalize() onlyOwner public {
390     require(!isFinalized);
391     require(hasClosed());
392 
393     finalization();
394     Finalized();
395 
396     isFinalized = true;
397   }
398 
399   /**
400    * @dev Can be overridden to add finalization logic. The overriding function
401    * should call super.finalization() to ensure the chain of finalization is
402    * executed entirely.
403    */
404   function finalization() internal {
405   }
406 }
407 
408 
409 /**
410  * @title Basic token
411  * @dev Basic version of StandardToken, with no allowances.
412  */
413 contract BasicToken is ERC20Basic {
414   using SafeMath for uint256;
415 
416   mapping(address => uint256) balances;
417 
418   uint256 totalSupply_;
419 
420   /**
421   * @dev total number of tokens in existence
422   */
423   function totalSupply() public view returns (uint256) {
424     return totalSupply_;
425   }
426 
427   /**
428   * @dev transfer token for a specified address
429   * @param _to The address to transfer to.
430   * @param _value The amount to be transferred.
431   */
432   function transfer(address _to, uint256 _value) public returns (bool) {
433     require(_to != address(0));
434     require(_value <= balances[msg.sender]);
435 
436     // SafeMath.sub will throw if there is not enough balance.
437     balances[msg.sender] = balances[msg.sender].sub(_value);
438     balances[_to] = balances[_to].add(_value);
439     Transfer(msg.sender, _to, _value);
440     return true;
441   }
442 
443   /**
444   * @dev Gets the balance of the specified address.
445   * @param _owner The address to query the the balance of.
446   * @return An uint256 representing the amount owned by the passed address.
447   */
448   function balanceOf(address _owner) public view returns (uint256 balance) {
449     return balances[_owner];
450   }
451 
452 }
453 
454 /**
455  * @title Standard ERC20 token
456  *
457  * @dev Implementation of the basic standard token.
458  * @dev https://github.com/ethereum/EIPs/issues/20
459  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
460  */
461 contract StandardToken is ERC20, BasicToken {
462 
463   mapping (address => mapping (address => uint256)) internal allowed;
464 
465 
466   /**
467    * @dev Transfer tokens from one address to another
468    * @param _from address The address which you want to send tokens from
469    * @param _to address The address which you want to transfer to
470    * @param _value uint256 the amount of tokens to be transferred
471    */
472   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
473     require(_to != address(0));
474     require(_value <= balances[_from]);
475     require(_value <= allowed[_from][msg.sender]);
476 
477     balances[_from] = balances[_from].sub(_value);
478     balances[_to] = balances[_to].add(_value);
479     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
480     Transfer(_from, _to, _value);
481     return true;
482   }
483 
484   /**
485    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
486    *
487    * Beware that changing an allowance with this method brings the risk that someone may use both the old
488    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
489    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
490    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
491    * @param _spender The address which will spend the funds.
492    * @param _value The amount of tokens to be spent.
493    */
494   function approve(address _spender, uint256 _value) public returns (bool) {
495     allowed[msg.sender][_spender] = _value;
496     Approval(msg.sender, _spender, _value);
497     return true;
498   }
499 
500   /**
501    * @dev Function to check the amount of tokens that an owner allowed to a spender.
502    * @param _owner address The address which owns the funds.
503    * @param _spender address The address which will spend the funds.
504    * @return A uint256 specifying the amount of tokens still available for the spender.
505    */
506   function allowance(address _owner, address _spender) public view returns (uint256) {
507     return allowed[_owner][_spender];
508   }
509 
510   /**
511    * @dev Increase the amount of tokens that an owner allowed to a spender.
512    *
513    * approve should be called when allowed[_spender] == 0. To increment
514    * allowed value is better to use this function to avoid 2 calls (and wait until
515    * the first transaction is mined)
516    * From MonolithDAO Token.sol
517    * @param _spender The address which will spend the funds.
518    * @param _addedValue The amount of tokens to increase the allowance by.
519    */
520   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
521     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
522     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
523     return true;
524   }
525 
526   /**
527    * @dev Decrease the amount of tokens that an owner allowed to a spender.
528    *
529    * approve should be called when allowed[_spender] == 0. To decrement
530    * allowed value is better to use this function to avoid 2 calls (and wait until
531    * the first transaction is mined)
532    * From MonolithDAO Token.sol
533    * @param _spender The address which will spend the funds.
534    * @param _subtractedValue The amount of tokens to decrease the allowance by.
535    */
536   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
537     uint oldValue = allowed[msg.sender][_spender];
538     if (_subtractedValue > oldValue) {
539       allowed[msg.sender][_spender] = 0;
540     } else {
541       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
542     }
543     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
544     return true;
545   }
546 
547 }
548 
549 /**
550  * @title Mintable token
551  * @dev Simple ERC20 Token example, with mintable token creation
552  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
553  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
554  */
555 contract MintableToken is StandardToken, Ownable {
556   event Mint(address indexed to, uint256 amount);
557   event MintFinished();
558 
559   bool public mintingFinished = false;
560 
561 
562   modifier canMint() {
563     require(!mintingFinished);
564     _;
565   }
566 
567   /**
568    * @dev Function to mint tokens
569    * @param _to The address that will receive the minted tokens.
570    * @param _amount The amount of tokens to mint.
571    * @return A boolean that indicates if the operation was successful.
572    */
573   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
574     totalSupply_ = totalSupply_.add(_amount);
575     balances[_to] = balances[_to].add(_amount);
576     Mint(_to, _amount);
577     Transfer(address(0), _to, _amount);
578     return true;
579   }
580 
581   /**
582    * @dev Function to stop minting new tokens.
583    * @return True if the operation was successful.
584    */
585   function finishMinting() onlyOwner canMint public returns (bool) {
586     mintingFinished = true;
587     MintFinished();
588     return true;
589   }
590 }
591 
592 /**
593  * @title Pausable token
594  * @dev StandardToken modified with pausable transfers.
595  **/
596 contract PausableToken is StandardToken, Pausable {
597 
598   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
599     return super.transfer(_to, _value);
600   }
601 
602   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
603     return super.transferFrom(_from, _to, _value);
604   }
605 
606   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
607     return super.approve(_spender, _value);
608   }
609 
610   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
611     return super.increaseApproval(_spender, _addedValue);
612   }
613 
614   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
615     return super.decreaseApproval(_spender, _subtractedValue);
616   }
617 }
618 
619 
620 /**
621  * @title Burnable Token
622  * @dev Token that can be irreversibly burned (destroyed).
623  */
624 contract BurnableToken is BasicToken {
625 
626   event Burn(address indexed burner, uint256 value);
627 
628   /**
629    * @dev Burns a specific amount of tokens.
630    * @param _value The amount of token to be burned.
631    */
632   function burn(uint256 _value) public {
633     require(_value <= balances[msg.sender]);
634     // no need to require value <= totalSupply, since that would imply the
635     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
636 
637     address burner = msg.sender;
638     balances[burner] = balances[burner].sub(_value);
639     totalSupply_ = totalSupply_.sub(_value);
640     Burn(burner, _value);
641   }
642 }
643 
644 contract TkoToken is MintableToken, BurnableToken, PausableToken {
645 
646     string public constant name = 'TkoToken';
647 
648     string public constant symbol = 'TKO';
649 
650     uint public constant decimals = 18;
651 
652 }
653 
654 
655 
656 /// @title Whitelist for TKO token sale.
657 /// @author Takeoff Technology OU - <info@takeoff.ws>
658 /// @dev Based on code by OpenZeppelin's WhitelistedCrowdsale.sol
659 contract TkoWhitelist is Ownable{
660 
661     using SafeMath for uint256;
662 
663     // Manage whitelist account address.
664     address public admin;
665 
666     mapping(address => uint256) internal totalIndividualWeiAmount;
667     mapping(address => bool) internal whitelist;
668 
669     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
670 
671 
672     /**
673      * TkoWhitelist
674      * @dev TkoWhitelist is the storage for whitelist and total amount by contributor's address.
675      * @param _admin Address of managing whitelist.
676      */
677     function TkoWhitelist (address _admin) public {
678         require(_admin != address(0));
679         admin = _admin;
680     }
681 
682     /**
683      * @dev Throws if called by any account other than the owner or the admin.
684      */
685     modifier onlyOwnerOrAdmin() {
686         require(msg.sender == owner || msg.sender == admin);
687         _;
688     }
689 
690  /**
691   * @dev Throws if called by any account other than the admin.
692   */
693  modifier onlyAdmin() {
694    require(msg.sender == admin);
695    _;
696   }
697 
698     /**
699      * @dev Allows the current owner to change administrator account of the contract to a newAdmin.
700      * @param newAdmin The address to transfer ownership to.
701      */
702     function changeAdmin(address newAdmin) public onlyOwner {
703         AdminChanged(admin, newAdmin);
704         admin = newAdmin;
705     }
706 
707 
708     /**
709       * @dev Returen whether the beneficiary is whitelisted.
710       */
711     function isWhitelisted(address _beneficiary) external view onlyOwnerOrAdmin returns (bool) {
712         return whitelist[_beneficiary];
713     }
714 
715     /**
716      * @dev Adds single address to whitelist.
717      * @param _beneficiary Address to be added to the whitelist
718      */
719     function addToWhitelist(address _beneficiary) external onlyOwnerOrAdmin {
720         whitelist[_beneficiary] = true;
721     }
722 
723     /**
724      * @dev Adds list of addresses to whitelist.
725      * @param _beneficiaries Addresses to be added to the whitelist
726      */
727     function addManyToWhitelist(address[] _beneficiaries) external onlyOwnerOrAdmin {
728         for (uint256 i = 0; i < _beneficiaries.length; i++) {
729             whitelist[_beneficiaries[i]] = true;
730         }
731     }
732 
733     /**
734      * @dev Removes single address from whitelist.
735      * @param _beneficiary Address to be removed to the whitelist
736      */
737     function removeFromWhitelist(address _beneficiary) external onlyOwnerOrAdmin {
738         whitelist[_beneficiary] = false;
739     }
740 
741     /**
742      * @dev Return total individual wei amount.
743      * @param _beneficiary Addresses to get total wei amount .
744      * @return Total wei amount for the address.
745      */
746     function getTotalIndividualWeiAmount(address _beneficiary) external view onlyOwnerOrAdmin returns (uint256) {
747         return totalIndividualWeiAmount[_beneficiary];
748     }
749 
750     /**
751      * @dev Set total individual wei amount.
752      * @param _beneficiary Addresses to set total wei amount.
753      * @param _totalWeiAmount Total wei amount for the address.
754      */
755     function setTotalIndividualWeiAmount(address _beneficiary,uint256 _totalWeiAmount) external onlyOwner {
756         totalIndividualWeiAmount[_beneficiary] = _totalWeiAmount;
757     }
758 
759     /**
760      * @dev Add total individual wei amount.
761      * @param _beneficiary Addresses to add total wei amount.
762      * @param _weiAmount Total wei amount to be added for the address.
763      */
764     function addTotalIndividualWeiAmount(address _beneficiary,uint256 _weiAmount) external onlyOwner {
765         totalIndividualWeiAmount[_beneficiary] = totalIndividualWeiAmount[_beneficiary].add(_weiAmount);
766     }
767 
768 }
769 
770 /// @title TKO Token presale contract.
771 /// @author Takeoff Technology OU - <info@takeoff.ws>
772 contract TkoTokenPreSale is FinalizableCrowdsale, Pausable {
773 
774     using SafeMath for uint256;
775 
776     uint256 public initialRate;
777     uint256 public finalRate;
778 
779     uint256 public limitEther;
780     uint256 public largeContribThreshold;
781     uint256 public largeContribPercentage;
782 
783     TkoWhitelist internal whitelist;
784 
785     /**
786      * TkoTokenPreSale
787      * @dev TkoTokenPresale sells tokens at a set rate for the specified period.
788      * Tokens that can be purchased per 1 Ether will decrease linearly over the period.
789      * Bonus tokens are issued for large contributor at the rate specified.
790      * If you wish to purchase above the specified amount, you need to be registered in the whitelist.
791      * @param _openingTime Opening unix timestamp for TKO token pre-sale.
792      * @param _closingTime Closing unix timestamp for TKO token pre-sale.
793      * @param _initialRate Number of tokens issued at start (minimum unit) per 1wei.
794      * @param _finalRate   Number of tokens issued at end (minimum unit) per 1wei.
795      * @param _limitEther  Threshold value of purchase amount not required to register in whitelist (unit Ether).
796      * @param _largeContribThreshold Threshold value of purchase amount in which bonus occurs (unit Ether)
797      * @param _largeContribPercentage Percentage of added bonus
798      * @param _wallet Wallet address to store Ether.
799      * @param _token The address of the token to be sold in the pre-sale. TkoTokenPreSale must have ownership for mint.
800      * @param _whitelist The address of the whitelist.
801      */
802     function TkoTokenPreSale (
803         uint256 _openingTime,
804         uint256 _closingTime,
805         uint256 _initialRate,
806         uint256 _finalRate,
807         uint256 _limitEther,
808         uint256 _largeContribThreshold,
809         uint256 _largeContribPercentage,
810         address _wallet,
811         TkoToken _token,
812         TkoWhitelist _whitelist
813     )
814     public
815     Crowdsale(_initialRate, _wallet, _token)
816     TimedCrowdsale(_openingTime, _closingTime)
817     {
818         initialRate = _initialRate;
819         finalRate   = _finalRate;
820 
821         limitEther = _limitEther;
822         largeContribThreshold  = _largeContribThreshold;
823         largeContribPercentage = _largeContribPercentage;
824 
825         whitelist = _whitelist;
826     }
827 
828     /**
829      * @dev Extend parent behavior to confirm purchase amount and whitelist.
830      * @param _beneficiary Token purchaser
831      * @param _weiAmount Amount of wei contributed
832      */
833     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen whenNotPaused {
834 
835         uint256 limitWeiAmount = limitEther.mul(1 ether);
836         require( whitelist.isWhitelisted(_beneficiary) ||
837                     whitelist.getTotalIndividualWeiAmount(_beneficiary).add(_weiAmount) < limitWeiAmount);
838         super._preValidatePurchase(_beneficiary, _weiAmount);
839     }
840 
841     /**
842      * @dev Returns the rate of tokens per wei at the present time.
843      * Note that, as price _increases_ with time, the rate _decreases_.
844      * @return The number of tokens a buyer gets per wei at a given time
845      */
846     function getCurrentRate() public view returns (uint256) {
847         uint256 elapsedTime = now.sub(openingTime);
848         uint256 timeRange = closingTime.sub(openingTime);
849         uint256 rateRange = initialRate.sub(finalRate);
850         return initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
851     }
852 
853 
854     /**
855      * @dev Overrides parent method taking into account variable rate and add bonus for large contributor.
856      * @param _weiAmount The value in wei to be converted into tokens
857      * @return The number of tokens _weiAmount wei will buy at present time
858      */
859     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
860 
861         uint256 currentRate = getCurrentRate();
862         uint256 tokenAmount = currentRate.mul(_weiAmount);
863 
864         uint256 largeContribThresholdWeiAmount = largeContribThreshold.mul(1 ether);
865         if ( _weiAmount >= largeContribThresholdWeiAmount ) {
866             tokenAmount = tokenAmount.mul(largeContribPercentage).div(100);
867         }
868 
869         return tokenAmount;
870     }
871 
872     /**
873      * @dev Add wei amount to the address's amount on the whitelist contract.
874      * @param _beneficiary Address receiving the tokens
875      * @param _weiAmount Value in wei involved in the purchase
876      */
877     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
878         whitelist.addTotalIndividualWeiAmount(_beneficiary, _weiAmount);
879         super._updatePurchasingState(_beneficiary, _weiAmount);
880     }
881 
882     /**
883     * @dev Overrides delivery by minting tokens upon purchase.
884     * @param _beneficiary Token purchaser
885     * @param _tokenAmount Number of tokens to be minted
886     */
887     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal onlyWhileOpen whenNotPaused {
888         // Don't call super._deliverTokens() to transfer token.
889         // Following call will mint FOR _beneficiary, So need not to call transfer token .
890         require(TkoToken(token).mint(_beneficiary, _tokenAmount));
891     }
892 
893     /**
894      * @dev called by the owner to pause, triggers stopped state
895      */
896     function pauseCrowdsale() public onlyOwner whenNotPaused {
897         TkoToken(token).pause();
898         super.pause();
899     }
900 
901     /**
902      * @dev called by the owner to unpause, returns to normal state
903     */
904     function unpauseCrowdsale() public onlyOwner whenPaused {
905         TkoToken(token).unpause();
906         super.unpause();
907     }
908 
909     /**
910      * @dev called by the owner to change owner of token and whitelist.
911     */
912     function evacuate() public onlyOwner {
913         TkoToken(token).transferOwnership(wallet);
914         whitelist.transferOwnership(wallet);
915     }
916 
917     /**
918      * @dev Can be overridden to add finalization logic. The overriding function
919      * should call super.finalization() to ensure the chain of finalization is
920      * executed entirely.
921      */
922     function finalization() internal {
923         TkoToken(token).transferOwnership(wallet);
924         whitelist.transferOwnership(wallet);
925         super.finalization();
926     }
927 
928 }