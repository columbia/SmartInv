1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title Crowdsale
91  * @dev Crowdsale is a base contract for managing a token crowdsale,
92  * allowing investors to purchase tokens with ether. This contract implements
93  * such functionality in its most fundamental form and can be extended to provide additional
94  * functionality and/or custom behavior.
95  * The external interface represents the basic interface for purchasing tokens, and conform
96  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
97  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
98  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
99  * behavior.
100  */
101 
102 contract Crowdsale {
103   using SafeMath for uint256;
104 
105   // The token being sold
106   ERC20 public token;
107 
108   // Address where funds are collected
109   address public wallet;
110 
111   // How many token units a buyer gets per wei
112   uint256 public rate;
113 
114   // Amount of wei raised
115   uint256 public weiRaised;
116 
117   /**
118    * Event for token purchase logging
119    * @param purchaser who paid for the tokens
120    * @param beneficiary who got the tokens
121    * @param value weis paid for purchase
122    * @param amount amount of tokens purchased
123    */
124   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
125 
126   /**
127    * @param _rate Number of token units a buyer gets per wei
128    * @param _wallet Address where collected funds will be forwarded to
129    * @param _token Address of the token being sold
130    */
131   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
132     require(_rate > 0);
133     require(_wallet != address(0));
134     require(_token != address(0));
135 
136     rate = _rate;
137     wallet = _wallet;
138     token = _token;
139   }
140 
141   // -----------------------------------------
142   // Crowdsale external interface
143   // -----------------------------------------
144 
145   /**
146    * @dev fallback function ***DO NOT OVERRIDE***
147    */
148   function () external payable {
149     buyTokens(msg.sender);
150   }
151 
152   /**
153    * @dev low level token purchase ***DO NOT OVERRIDE***
154    * @param _beneficiary Address performing the token purchase
155    */
156   function buyTokens(address _beneficiary) public payable {
157 
158     uint256 weiAmount = msg.value;
159     _preValidatePurchase(_beneficiary, weiAmount);
160 
161     // calculate token amount to be created
162     uint256 tokens = _getTokenAmount(weiAmount);
163 
164     // update state
165     weiRaised = weiRaised.add(weiAmount);
166 
167     _processPurchase(_beneficiary, tokens);
168     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
169 
170     _updatePurchasingState(_beneficiary, weiAmount);
171 
172     _forwardFunds();
173     _postValidatePurchase(_beneficiary, weiAmount);
174   }
175 
176   // -----------------------------------------
177   // Internal interface (extensible)
178   // -----------------------------------------
179 
180   /**
181    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
182    * @param _beneficiary Address performing the token purchase
183    * @param _weiAmount Value in wei involved in the purchase
184    */
185   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
186     require(_beneficiary != address(0));
187     require(_weiAmount != 0);
188   }
189 
190   /**
191    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
192    * @param _beneficiary Address performing the token purchase
193    * @param _weiAmount Value in wei involved in the purchase
194    */
195   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
196     // optional override
197   }
198 
199   /**
200    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
201    * @param _beneficiary Address performing the token purchase
202    * @param _tokenAmount Number of tokens to be emitted
203    */
204   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
205     token.transfer(_beneficiary, _tokenAmount);
206   }
207 
208   /**
209    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
210    * @param _beneficiary Address receiving the tokens
211    * @param _tokenAmount Number of tokens to be purchased
212    */
213   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
214     _deliverTokens(_beneficiary, _tokenAmount);
215   }
216 
217   /**
218    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
219    * @param _beneficiary Address receiving the tokens
220    * @param _weiAmount Value in wei involved in the purchase
221    */
222   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
223     // optional override
224   }
225 
226   /**
227    * @dev Override to extend the way in which ether is converted to tokens.
228    * @param _weiAmount Value in wei to be converted into tokens
229    * @return Number of tokens that can be purchased with the specified _weiAmount
230    */
231   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
232     return _weiAmount.mul(rate);
233   }
234 
235   /**
236    * @dev Determines how ETH is stored/forwarded on purchases.
237    */
238   function _forwardFunds() internal {
239     wallet.transfer(msg.value);
240   }
241 }
242 
243 /**
244  * @title AllowanceCrowdsale
245  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
246  */
247 contract AllowanceCrowdsale is Crowdsale {
248   using SafeMath for uint256;
249 
250   address public tokenWallet;
251 
252   /**
253    * @dev Constructor, takes token wallet address. 
254    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
255    */
256   function AllowanceCrowdsale(address _tokenWallet) public {
257     require(_tokenWallet != address(0));
258     tokenWallet = _tokenWallet;
259   }
260 
261   /**
262    * @dev Checks the amount of tokens left in the allowance.
263    * @return Amount of tokens left in the allowance
264    */
265   function remainingTokens() public view returns (uint256) {
266     return token.allowance(tokenWallet, this);
267   }
268 
269   /**
270    * @dev Overrides parent behavior by transferring tokens from wallet.
271    * @param _beneficiary Token purchaser
272    * @param _tokenAmount Amount of tokens purchased
273    */
274   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
275     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
276   }
277 }
278 
279 /**
280  * @title WhitelistedCrowdsale
281  * @dev Crowdsale in which only whitelisted users can contribute.
282  */
283 contract WhitelistedCrowdsale is Crowdsale, Ownable {
284 
285   mapping(address => bool) public whitelist;
286 
287   /**
288    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
289    */
290   modifier isWhitelisted(address _beneficiary) {
291     require(whitelist[_beneficiary]);
292     _;
293   }
294 
295   /**
296    * @dev Adds single address to whitelist.
297    * @param _beneficiary Address to be added to the whitelist
298    */
299   function addToWhitelist(address _beneficiary) external onlyOwner {
300     whitelist[_beneficiary] = true;
301   }
302   
303   /**
304    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing. 
305    * @param _beneficiaries Addresses to be added to the whitelist
306    */
307   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
308     for (uint256 i = 0; i < _beneficiaries.length; i++) {
309       whitelist[_beneficiaries[i]] = true;
310     }
311   }
312 
313   /**
314    * @dev Removes single address from whitelist. 
315    * @param _beneficiary Address to be removed to the whitelist
316    */
317   function removeFromWhitelist(address _beneficiary) external onlyOwner {
318     whitelist[_beneficiary] = false;
319   }
320 
321   /**
322    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
323    * @param _beneficiary Token beneficiary
324    * @param _weiAmount Amount of wei contributed
325    */
326   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
327     super._preValidatePurchase(_beneficiary, _weiAmount);
328   }
329 
330 }
331 
332 /**
333  * @title TimedCrowdsale
334  * @dev Crowdsale accepting contributions only within a time frame.
335  */
336 contract TimedCrowdsale is Crowdsale {
337   using SafeMath for uint256;
338 
339   uint256 public openingTime;
340   uint256 public closingTime;
341 
342   /**
343    * @dev Reverts if not in crowdsale time range. 
344    */
345   modifier onlyWhileOpen {
346     require(now >= openingTime && now <= closingTime);
347     _;
348   }
349 
350   /**
351    * @dev Constructor, takes crowdsale opening and closing times.
352    * @param _openingTime Crowdsale opening time
353    * @param _closingTime Crowdsale closing time
354    */
355   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
356     require(_openingTime >= now);
357     require(_closingTime >= _openingTime);
358 
359     openingTime = _openingTime;
360     closingTime = _closingTime;
361   }
362 
363   /**
364    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
365    * @return Whether crowdsale period has elapsed
366    */
367   function hasClosed() public view returns (bool) {
368     return now > closingTime;
369   }
370   
371   /**
372    * @dev Extend parent behavior requiring to be within contributing period
373    * @param _beneficiary Token purchaser
374    * @param _weiAmount Amount of wei contributed
375    */
376   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
377     super._preValidatePurchase(_beneficiary, _weiAmount);
378   }
379 
380 }
381 
382 /**
383  * @title FinalizableCrowdsale
384  * @dev Extension of Crowdsale where an owner can do extra work
385  * after finishing.
386  */
387 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
388   using SafeMath for uint256;
389 
390   bool public isFinalized = false;
391 
392   event Finalized();
393 
394   /**
395    * @dev Must be called after crowdsale ends, to do some extra finalization
396    * work. Calls the contract's finalization function.
397    */
398   function finalize() onlyOwner public {
399     require(!isFinalized);
400     require(hasClosed());
401 
402     finalization();
403     Finalized();
404 
405     isFinalized = true;
406   }
407 
408   /**
409    * @dev Can be overridden to add finalization logic. The overriding function
410    * should call super.finalization() to ensure the chain of finalization is
411    * executed entirely.
412    */
413   function finalization() internal {
414   }
415 }
416 
417 
418 /**
419  * @title ERC20Basic
420  * @dev Simpler version of ERC20 interface
421  * @dev see https://github.com/ethereum/EIPs/issues/179
422  */
423 contract ERC20Basic {
424   function totalSupply() public view returns (uint256);
425   function balanceOf(address who) public view returns (uint256);
426   function transfer(address to, uint256 value) public returns (bool);
427   event Transfer(address indexed from, address indexed to, uint256 value);
428 }
429 
430 /**
431  * @title ERC20 interface
432  * @dev see https://github.com/ethereum/EIPs/issues/20
433  */
434 contract ERC20 is ERC20Basic {
435   function allowance(address owner, address spender) public view returns (uint256);
436   function transferFrom(address from, address to, uint256 value) public returns (bool);
437   function approve(address spender, uint256 value) public returns (bool);
438   event Approval(address indexed owner, address indexed spender, uint256 value);
439 }
440 
441 
442 /**
443  * @title SafeERC20
444  * @dev Wrappers around ERC20 operations that throw on failure.
445  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
446  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
447  */
448 library SafeERC20 {
449   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
450     assert(token.transfer(to, value));
451   }
452 
453   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
454     assert(token.transferFrom(from, to, value));
455   }
456 
457   function safeApprove(ERC20 token, address spender, uint256 value) internal {
458     assert(token.approve(spender, value));
459   }
460 }
461 
462 /**
463  * @title RTEBonusTokenVault
464  * @dev Token holder contract that releases tokens to the respective addresses
465  * and _lockedReleaseTime
466  */
467 contract RTEBonusTokenVault is Ownable {
468   using SafeERC20 for ERC20Basic;
469   using SafeMath for uint256;
470 
471   // ERC20 basic token contract being held
472   ERC20Basic public token;
473 
474   bool public vaultUnlocked;
475 
476   bool public vaultSecondaryUnlocked;
477 
478   // How much we have allocated to the investors invested
479   mapping(address => uint256) public balances;
480 
481   mapping(address => uint256) public lockedBalances;
482 
483   /**
484    * @dev Allocation event
485    * @param _investor Investor address
486    * @param _value Tokens allocated
487    */
488   event Allocated(address _investor, uint256 _value);
489 
490   /**
491    * @dev Distribution event
492    * @param _investor Investor address
493    * @param _value Tokens distributed
494    */
495   event Distributed(address _investor, uint256 _value);
496 
497   function RTEBonusTokenVault(
498     ERC20Basic _token
499   )
500     public
501   {
502     token = _token;
503     vaultUnlocked = false;
504     vaultSecondaryUnlocked = false;
505   }
506 
507   /**
508    * @dev Unlocks vault
509    */
510   function unlock() public onlyOwner {
511     require(!vaultUnlocked);
512     vaultUnlocked = true;
513   }
514 
515   /**
516    * @dev Unlocks secondary vault
517    */
518   function unlockSecondary() public onlyOwner {
519     require(vaultUnlocked);
520     require(!vaultSecondaryUnlocked);
521     vaultSecondaryUnlocked = true;
522   }
523 
524   /**
525    * @dev Add allocation amount to investor addresses
526    * Only the owner of this contract - the crowdsale can call this function
527    * Split half to be locked by timelock in vault, the other half to be released on vault unlock
528    * @param _investor Investor address
529    * @param _amount Amount of tokens to add
530    */
531   function allocateInvestorBonusToken(address _investor, uint256 _amount) public onlyOwner {
532     require(!vaultUnlocked);
533     require(!vaultSecondaryUnlocked);
534 
535     uint256 bonusTokenAmount = _amount.div(2);
536     uint256 bonusLockedTokenAmount = _amount.sub(bonusTokenAmount);
537 
538     balances[_investor] = balances[_investor].add(bonusTokenAmount);
539     lockedBalances[_investor] = lockedBalances[_investor].add(bonusLockedTokenAmount);
540 
541     Allocated(_investor, _amount);
542   }
543 
544   /**
545    * @dev Transfers bonus tokens held to investor
546    * @param _investor Investor address making the claim
547    */
548   function claim(address _investor) public onlyOwner {
549     // _investor is the original initiator
550     // msg.sender is the contract that called this.
551     require(vaultUnlocked);
552 
553     uint256 claimAmount = balances[_investor];
554     require(claimAmount > 0);
555 
556     uint256 tokenAmount = token.balanceOf(this);
557     require(tokenAmount > 0);
558 
559     // Empty token balance
560     balances[_investor] = 0;
561 
562     token.safeTransfer(_investor, claimAmount);
563 
564     Distributed(_investor, claimAmount);
565   }
566 
567   /**
568    * @dev Transfers secondary bonus tokens held to investor
569    * @param _investor Investor address making the claim
570    */
571   function claimLocked(address _investor) public onlyOwner {
572     // _investor is the original initiator
573     // msg.sender is the contract that called this.
574     require(vaultUnlocked);
575     require(vaultSecondaryUnlocked);
576 
577     uint256 claimAmount = lockedBalances[_investor];
578     require(claimAmount > 0);
579 
580     uint256 tokenAmount = token.balanceOf(this);
581     require(tokenAmount > 0);
582 
583     // Empty token balance
584     lockedBalances[_investor] = 0;
585 
586     token.safeTransfer(_investor, claimAmount);
587 
588     Distributed(_investor, claimAmount);
589   }
590 }
591 
592 /**
593  * @title Basic token
594  * @dev Basic version of StandardToken, with no allowances.
595  */
596 contract BasicToken is ERC20Basic {
597   using SafeMath for uint256;
598 
599   mapping(address => uint256) balances;
600 
601   uint256 totalSupply_;
602 
603   /**
604   * @dev total number of tokens in existence
605   */
606   function totalSupply() public view returns (uint256) {
607     return totalSupply_;
608   }
609 
610   /**
611   * @dev transfer token for a specified address
612   * @param _to The address to transfer to.
613   * @param _value The amount to be transferred.
614   */
615   function transfer(address _to, uint256 _value) public returns (bool) {
616     require(_to != address(0));
617     require(_value <= balances[msg.sender]);
618 
619     // SafeMath.sub will throw if there is not enough balance.
620     balances[msg.sender] = balances[msg.sender].sub(_value);
621     balances[_to] = balances[_to].add(_value);
622     Transfer(msg.sender, _to, _value);
623     return true;
624   }
625 
626   /**
627   * @dev Gets the balance of the specified address.
628   * @param _owner The address to query the the balance of.
629   * @return An uint256 representing the amount owned by the passed address.
630   */
631   function balanceOf(address _owner) public view returns (uint256 balance) {
632     return balances[_owner];
633   }
634 
635 }
636 
637 /**
638  * @title Standard ERC20 token
639  *
640  * @dev Implementation of the basic standard token.
641  * @dev https://github.com/ethereum/EIPs/issues/20
642  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
643  */
644 contract StandardToken is ERC20, BasicToken {
645 
646   mapping (address => mapping (address => uint256)) internal allowed;
647 
648 
649   /**
650    * @dev Transfer tokens from one address to another
651    * @param _from address The address which you want to send tokens from
652    * @param _to address The address which you want to transfer to
653    * @param _value uint256 the amount of tokens to be transferred
654    */
655   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
656     require(_to != address(0));
657     require(_value <= balances[_from]);
658     require(_value <= allowed[_from][msg.sender]);
659 
660     balances[_from] = balances[_from].sub(_value);
661     balances[_to] = balances[_to].add(_value);
662     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
663     Transfer(_from, _to, _value);
664     return true;
665   }
666 
667   /**
668    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
669    *
670    * Beware that changing an allowance with this method brings the risk that someone may use both the old
671    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
672    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
673    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
674    * @param _spender The address which will spend the funds.
675    * @param _value The amount of tokens to be spent.
676    */
677   function approve(address _spender, uint256 _value) public returns (bool) {
678     allowed[msg.sender][_spender] = _value;
679     Approval(msg.sender, _spender, _value);
680     return true;
681   }
682 
683   /**
684    * @dev Function to check the amount of tokens that an owner allowed to a spender.
685    * @param _owner address The address which owns the funds.
686    * @param _spender address The address which will spend the funds.
687    * @return A uint256 specifying the amount of tokens still available for the spender.
688    */
689   function allowance(address _owner, address _spender) public view returns (uint256) {
690     return allowed[_owner][_spender];
691   }
692 
693   /**
694    * @dev Increase the amount of tokens that an owner allowed to a spender.
695    *
696    * approve should be called when allowed[_spender] == 0. To increment
697    * allowed value is better to use this function to avoid 2 calls (and wait until
698    * the first transaction is mined)
699    * From MonolithDAO Token.sol
700    * @param _spender The address which will spend the funds.
701    * @param _addedValue The amount of tokens to increase the allowance by.
702    */
703   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
704     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
705     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
706     return true;
707   }
708 
709   /**
710    * @dev Decrease the amount of tokens that an owner allowed to a spender.
711    *
712    * approve should be called when allowed[_spender] == 0. To decrement
713    * allowed value is better to use this function to avoid 2 calls (and wait until
714    * the first transaction is mined)
715    * From MonolithDAO Token.sol
716    * @param _spender The address which will spend the funds.
717    * @param _subtractedValue The amount of tokens to decrease the allowance by.
718    */
719   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
720     uint oldValue = allowed[msg.sender][_spender];
721     if (_subtractedValue > oldValue) {
722       allowed[msg.sender][_spender] = 0;
723     } else {
724       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
725     }
726     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
727     return true;
728   }
729 
730 }
731 
732 /**
733  * @title Pausable
734  * @dev Base contract which allows children to implement an emergency stop mechanism.
735  */
736 contract Pausable is Ownable {
737   event Pause();
738   event Unpause();
739 
740   bool public paused = false;
741 
742 
743   /**
744    * @dev Modifier to make a function callable only when the contract is not paused.
745    */
746   modifier whenNotPaused() {
747     require(!paused);
748     _;
749   }
750 
751   /**
752    * @dev Modifier to make a function callable only when the contract is paused.
753    */
754   modifier whenPaused() {
755     require(paused);
756     _;
757   }
758 
759   /**
760    * @dev called by the owner to pause, triggers stopped state
761    */
762   function pause() onlyOwner whenNotPaused public {
763     paused = true;
764     Pause();
765   }
766 
767   /**
768    * @dev called by the owner to unpause, returns to normal state
769    */
770   function unpause() onlyOwner whenPaused public {
771     paused = false;
772     Unpause();
773   }
774 }
775 
776 /**
777  * @title Whitelisted Pausable token
778  * @dev StandardToken modified with pausable transfers. Enables a whitelist to enable transfers
779  * only for certain addresses such as crowdsale contract, issuing account etc.
780  **/
781 contract WhitelistedPausableToken is StandardToken, Pausable {
782 
783   mapping(address => bool) public whitelist;
784 
785   /**
786    * @dev Reverts if the message sender requesting for transfer is not whitelisted when token
787    * transfers are paused
788    * @param _sender check transaction sender address
789    */
790   modifier whenNotPausedOrWhitelisted(address _sender) {
791     require(whitelist[_sender] || !paused);
792     _;
793   }
794 
795   /**
796    * @dev Adds single address to whitelist.
797    * @param _whitelistAddress Address to be added to the whitelist
798    */
799   function addToWhitelist(address _whitelistAddress) external onlyOwner {
800     whitelist[_whitelistAddress] = true;
801   }
802 
803   /**
804    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
805    * @param _whitelistAddresses Addresses to be added to the whitelist
806    */
807   function addManyToWhitelist(address[] _whitelistAddresses) external onlyOwner {
808     for (uint256 i = 0; i < _whitelistAddresses.length; i++) {
809       whitelist[_whitelistAddresses[i]] = true;
810     }
811   }
812 
813   /**
814    * @dev Removes single address from whitelist.
815    * @param _whitelistAddress Address to be removed to the whitelist
816    */
817   function removeFromWhitelist(address _whitelistAddress) external onlyOwner {
818     whitelist[_whitelistAddress] = false;
819   }
820 
821   // Adding modifier to transfer/approval functions
822   function transfer(address _to, uint256 _value) public whenNotPausedOrWhitelisted(msg.sender) returns (bool) {
823     return super.transfer(_to, _value);
824   }
825 
826   function transferFrom(address _from, address _to, uint256 _value) public whenNotPausedOrWhitelisted(msg.sender) returns (bool) {
827     return super.transferFrom(_from, _to, _value);
828   }
829 
830   function approve(address _spender, uint256 _value) public whenNotPausedOrWhitelisted(msg.sender) returns (bool) {
831     return super.approve(_spender, _value);
832   }
833 
834   function increaseApproval(address _spender, uint _addedValue) public whenNotPausedOrWhitelisted(msg.sender) returns (bool success) {
835     return super.increaseApproval(_spender, _addedValue);
836   }
837 
838   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPausedOrWhitelisted(msg.sender) returns (bool success) {
839     return super.decreaseApproval(_spender, _subtractedValue);
840   }
841 }
842 
843 /**
844  * @title RTEToken
845  * @dev ERC20 token implementation
846  * Pausable
847  */
848 contract RTEToken is WhitelistedPausableToken {
849   string public constant name = "Rate3";
850   string public constant symbol = "RTE";
851   uint8 public constant decimals = 18;
852 
853   // 1 billion initial supply of RTE tokens
854   // Taking into account 18 decimals
855   uint256 public constant INITIAL_SUPPLY = (10 ** 9) * (10 ** 18);
856 
857   /**
858    * @dev RTEToken Constructor
859    * Mints the initial supply of tokens, this is the hard cap, no more tokens will be minted.
860    * Allocate the tokens to the foundation wallet, issuing wallet etc.
861    */
862   function RTEToken() public {
863     // Mint initial supply of tokens. All further minting of tokens is disabled
864     totalSupply_ = INITIAL_SUPPLY;
865 
866     // Transfer all initial tokens to msg.sender
867     balances[msg.sender] = INITIAL_SUPPLY;
868     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
869   }
870 }
871 
872 /**
873  * @title RTECrowdsale
874  * @dev test
875  */
876 contract RTECrowdsale is AllowanceCrowdsale, WhitelistedCrowdsale, FinalizableCrowdsale {
877   using SafeERC20 for ERC20;
878 
879   uint256 public constant minimumInvestmentInWei = 0.5 ether;
880 
881   uint256 public allTokensSold;
882 
883   uint256 public bonusTokensSold;
884 
885   uint256 public cap;
886 
887   mapping (address => uint256) public tokenInvestments;
888 
889   mapping (address => uint256) public bonusTokenInvestments;
890 
891   RTEBonusTokenVault public bonusTokenVault;
892 
893   /**
894    * @dev Contract initialization parameters
895    * @param _openingTime Public crowdsale opening time
896    * @param _closingTime Public crowdsale closing time
897    * @param _rate Initial rate (Maybe remove, put as constant)
898    * @param _cap RTE token issue cap (Should be the same amount as approved allowance from issueWallet)
899    * @param _wallet Multisig wallet to send ether raised to
900    * @param _issueWallet Wallet that approves allowance of tokens to be issued
901    * @param _token RTE token address deployed seperately
902    */
903   function RTECrowdsale(
904     uint256 _openingTime,
905     uint256 _closingTime,
906     uint256 _rate,
907     uint256 _cap,
908     address _wallet,
909     address _issueWallet,
910     RTEToken _token
911   )
912     AllowanceCrowdsale(_issueWallet)
913     TimedCrowdsale(_openingTime, _closingTime)
914     Crowdsale(_rate, _wallet, _token)
915     public
916   {
917     require(_cap > 0);
918 
919     cap = _cap;
920     bonusTokenVault = new RTEBonusTokenVault(_token);
921   }
922 
923   /**
924    * @dev Checks whether the cap for RTE has been reached.
925    * @return Whether the cap was reached
926    */
927   function capReached() public view returns (bool) {
928     return allTokensSold >= cap;
929   }
930 
931   /**
932    * @dev Calculate bonus RTE percentage to be allocated based on time rules
933    * time is calculated by now = block.timestamp, will be consistent across transaction if called
934    * multiple times in same transaction
935    * @return Bonus percentage in percent value
936    */
937   function _calculateBonusPercentage() internal view returns (uint256) {
938     return 20;
939   }
940 
941   /**
942    * @dev Get current RTE balance of bonus token vault
943    */
944   function getRTEBonusTokenVaultBalance() public view returns (uint256) {
945     return token.balanceOf(address(bonusTokenVault));
946   }
947 
948   /**
949    * @dev Extend parent behavior requiring purchase to respect minimum investment per transaction.
950    * @param _beneficiary Token purchaser
951    * @param _weiAmount Amount of wei contributed
952    */
953   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
954     super._preValidatePurchase(_beneficiary, _weiAmount);
955     require(msg.value >= minimumInvestmentInWei);
956   }
957 
958   /**
959    * @dev Keep track of tokens purchased extension functionality
960    * @param _beneficiary Address performing the token purchase
961    * @param _tokenAmount Value in amount of token purchased
962    */
963   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
964     uint256 bonusPercentage = _calculateBonusPercentage();
965     uint256 additionalBonusTokens = _tokenAmount.mul(bonusPercentage).div(100);
966     uint256 tokensSold = _tokenAmount;
967 
968     // Check if exceed token sale cap
969     uint256 newAllTokensSold = allTokensSold.add(tokensSold).add(additionalBonusTokens);
970     require(newAllTokensSold <= cap);
971 
972     // Process purchase
973     super._processPurchase(_beneficiary, tokensSold);
974     allTokensSold = allTokensSold.add(tokensSold);
975     tokenInvestments[_beneficiary] = tokenInvestments[_beneficiary].add(tokensSold);
976 
977     if (additionalBonusTokens > 0) {
978       // Record bonus tokens allocated and transfer it to RTEBonusTokenVault
979       allTokensSold = allTokensSold.add(additionalBonusTokens);
980       bonusTokensSold = bonusTokensSold.add(additionalBonusTokens);
981       bonusTokenVault.allocateInvestorBonusToken(_beneficiary, additionalBonusTokens);
982       bonusTokenInvestments[_beneficiary] = bonusTokenInvestments[_beneficiary].add(additionalBonusTokens);
983     }
984   }
985 
986   /**
987    * @dev Unlock secondary tokens, can only be done by owner of contract
988    */
989   function unlockSecondaryTokens() public onlyOwner {
990     require(isFinalized);
991     bonusTokenVault.unlockSecondary();
992   }
993 
994   /**
995    * @dev Claim bonus tokens from vault after bonus tokens are released
996    * @param _beneficiary Address receiving the tokens
997    */
998   function claimBonusTokens(address _beneficiary) public {
999     require(isFinalized);
1000     bonusTokenVault.claim(_beneficiary);
1001   }
1002 
1003   /**
1004    * @dev Claim timelocked bonus tokens from vault after bonus tokens are released
1005    * @param _beneficiary Address receiving the tokens
1006    */
1007   function claimLockedBonusTokens(address _beneficiary) public {
1008     require(isFinalized);
1009     bonusTokenVault.claimLocked(_beneficiary);
1010   }
1011 
1012   /**
1013    * @dev Called manually when token sale has ended with finalize()
1014    */
1015   function finalization() internal {
1016     // Credit bonus tokens sold to bonusTokenVault
1017     token.transferFrom(tokenWallet, bonusTokenVault, bonusTokensSold);
1018 
1019     // Unlock bonusTokenVault for non-timelocked tokens to be claimed
1020     bonusTokenVault.unlock();
1021 
1022     super.finalization();
1023   }
1024 }