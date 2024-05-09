1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title SafeERC20
47  * @dev Wrappers around ERC20 operations that throw on failure.
48  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
49  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
50  */
51 library SafeERC20 {
52   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
53     assert(token.transfer(to, value));
54   }
55 
56   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
57     assert(token.transferFrom(from, to, value));
58   }
59 
60   function safeApprove(ERC20 token, address spender, uint256 value) internal {
61     assert(token.approve(spender, value));
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
72   mapping(address => uint256) balances;
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81 
82     // SafeMath.sub will throw if there is not enough balance.
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of.
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) public constant returns (uint256 balance) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public constant returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * @dev https://github.com/ethereum/EIPs/issues/20
117  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract StandardToken is ERC20, BasicToken {
120 
121   mapping (address => mapping (address => uint256)) allowed;
122 
123 
124   /**
125    * @dev Transfer tokens from one address to another
126    * @param _from address The address which you want to send tokens from
127    * @param _to address The address which you want to transfer to
128    * @param _value uint256 the amount of tokens to be transferred
129    */
130   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
131     require(_to != address(0));
132 
133     uint256 _allowance = allowed[_from][msg.sender];
134 
135     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
136     // require (_value <= _allowance);
137 
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = _allowance.sub(_value);
141     Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    *
148    * Beware that changing an allowance with this method brings the risk that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifying the amount of tokens still available for the spender.
166    */
167   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
168     return allowed[_owner][_spender];
169   }
170 
171   /**
172    * approve should be called when allowed[_spender] == 0. To increment
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    */
177   function increaseApproval (address _spender, uint _addedValue)
178     returns (bool success) {
179     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 
184   function decreaseApproval (address _spender, uint _subtractedValue)
185     returns (bool success) {
186     uint oldValue = allowed[msg.sender][_spender];
187     if (_subtractedValue > oldValue) {
188       allowed[msg.sender][_spender] = 0;
189     } else {
190       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191     }
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196 }
197 
198 /**
199  * @title Ownable
200  * @dev The Ownable contract has an owner address, and provides basic authorization control
201  * functions, this simplifies the implementation of "user permissions".
202  */
203 contract Ownable {
204   address public owner;
205 
206 
207   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208 
209 
210   /**
211    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
212    * account.
213    */
214   function Ownable() {
215     owner = msg.sender;
216   }
217 
218 
219   /**
220    * @dev Throws if called by any account other than the owner.
221    */
222   modifier onlyOwner() {
223     require(msg.sender == owner);
224     _;
225   }
226 
227 
228   /**
229    * @dev Allows the current owner to transfer control of the contract to a newOwner.
230    * @param newOwner The address to transfer ownership to.
231    */
232   function transferOwnership(address newOwner) onlyOwner public {
233     require(newOwner != address(0));
234     OwnershipTransferred(owner, newOwner);
235     owner = newOwner;
236   }
237 
238 }
239 
240 /**
241  * @title Mintable token
242  * @dev Simple ERC20 Token example, with mintable token creation
243  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
244  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
245  */
246 
247 contract MintableToken is StandardToken, Ownable {
248   event Mint(address indexed to, uint256 amount);
249   event MintFinished();
250 
251   bool public mintingFinished = false;
252 
253 
254   modifier canMint() {
255     require(!mintingFinished);
256     _;
257   }
258 
259   /**
260    * @dev Function to mint tokens
261    * @param _to The address that will receive the minted tokens.
262    * @param _amount The amount of tokens to mint.
263    * @return A boolean that indicates if the operation was successful.
264    */
265   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
266     totalSupply = totalSupply.add(_amount);
267     balances[_to] = balances[_to].add(_amount);
268     Mint(_to, _amount);
269     Transfer(0x0, _to, _amount);
270     return true;
271   }
272 
273   /**
274    * @dev Function to stop minting new tokens.
275    * @return True if the operation was successful.
276    */
277   function finishMinting() onlyOwner public returns (bool) {
278     mintingFinished = true;
279     MintFinished();
280     return true;
281   }
282 }
283 
284 /**
285  * @title Pausable
286  * @dev Base contract which allows children to implement an emergency stop mechanism.
287  */
288 contract Pausable is Ownable {
289   event Pause();
290   event Unpause();
291 
292   bool public paused = false;
293 
294 
295   /**
296    * @dev Modifier to make a function callable only when the contract is not paused.
297    */
298   modifier whenNotPaused() {
299     require(!paused);
300     _;
301   }
302 
303   /**
304    * @dev Modifier to make a function callable only when the contract is paused.
305    */
306   modifier whenPaused() {
307     require(paused);
308     _;
309   }
310 
311   /**
312    * @dev called by the owner to pause, triggers stopped state
313    */
314   function pause() onlyOwner whenNotPaused public {
315     paused = true;
316     Pause();
317   }
318 
319   /**
320    * @dev called by the owner to unpause, returns to normal state
321    */
322   function unpause() onlyOwner whenPaused public {
323     paused = false;
324     Unpause();
325   }
326 }
327 
328 /**
329  * @title Pausable token
330  *
331  * @dev StandardToken modified with pausable transfers.
332  **/
333 
334 contract PausableToken is StandardToken, Pausable {
335 
336   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
337     return super.transfer(_to, _value);
338   }
339 
340   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
341     return super.transferFrom(_from, _to, _value);
342   }
343 
344   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
345     return super.approve(_spender, _value);
346   }
347 
348   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
349     return super.increaseApproval(_spender, _addedValue);
350   }
351 
352   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
353     return super.decreaseApproval(_spender, _subtractedValue);
354   }
355 }
356 
357 /**
358  * @title Burnable Token
359  * @dev Token that can be irreversibly burned (destroyed).
360  */
361 contract BurnableToken is StandardToken {
362 
363     event Burn(address indexed burner, uint256 value);
364 
365     /**
366      * @dev Burns a specific amount of tokens.
367      * @param _value The amount of token to be burned.
368      */
369     function burn(uint256 _value) public {
370         require(_value > 0);
371 
372         address burner = msg.sender;
373         balances[burner] = balances[burner].sub(_value);
374         totalSupply = totalSupply.sub(_value);
375         Burn(burner, _value);
376     }
377 }
378 
379 /**
380  * @title ModulumToken
381  * @dev ModulumToken is ERC20-compilant, mintable, pausable and burnable.
382  */
383 contract ModulumToken is MintableToken, PausableToken, BurnableToken {
384 
385   // Token information
386   string public name = "Modulum Token";
387   string public symbol = "MDL";
388   uint256 public decimals = 18;
389 
390   /**
391    * @dev Contructor
392    */
393   function ModulumToken() {
394   }
395 }
396 
397 contract Crowdsale {
398   using SafeMath for uint256;
399 
400   // The token being sold
401   MintableToken public token;
402 
403   // start and end timestamps where investments are allowed (both inclusive)
404   uint256 public startTime;
405   uint256 public endTime;
406 
407   // address where funds are collected
408   address public wallet;
409 
410   // how many token units a buyer gets per wei
411   uint256 public rate;
412 
413   // amount of raised money in wei
414   uint256 public weiRaised;
415 
416   /**
417    * event for token purchase logging
418    * @param purchaser who paid for the tokens
419    * @param beneficiary who got the tokens
420    * @param value weis paid for purchase
421    * @param amount amount of tokens purchased
422    */
423   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
424 
425 
426   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
427     require(_startTime >= now);
428     require(_endTime >= _startTime);
429     require(_rate > 0);
430     require(_wallet != 0x0);
431 
432     token = createTokenContract();
433     startTime = _startTime;
434     endTime = _endTime;
435     rate = _rate;
436     wallet = _wallet;
437   }
438 
439   // creates the token to be sold.
440   // override this method to have crowdsale of a specific mintable token.
441   function createTokenContract() internal returns (MintableToken) {
442     return new MintableToken();
443   }
444 
445 
446   // fallback function can be used to buy tokens
447   function () payable {
448     buyTokens(msg.sender);
449   }
450 
451   // low level token purchase function
452   function buyTokens(address beneficiary) public payable {
453     require(beneficiary != 0x0);
454     require(validPurchase());
455 
456     uint256 weiAmount = msg.value;
457 
458     // calculate token amount to be created
459     uint256 tokens = weiAmount.mul(rate);
460 
461     // update state
462     weiRaised = weiRaised.add(weiAmount);
463 
464     token.mint(beneficiary, tokens);
465     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
466 
467     forwardFunds();
468   }
469 
470   // send ether to the fund collection wallet
471   // override to create custom fund forwarding mechanisms
472   function forwardFunds() internal {
473     wallet.transfer(msg.value);
474   }
475 
476   // @return true if the transaction can buy tokens
477   function validPurchase() internal constant returns (bool) {
478     bool withinPeriod = now >= startTime && now <= endTime;
479     bool nonZeroPurchase = msg.value != 0;
480     return withinPeriod && nonZeroPurchase;
481   }
482 
483   // @return true if crowdsale event has ended
484   function hasEnded() public constant returns (bool) {
485     return now > endTime;
486   }
487 
488 
489 }
490 
491 /**
492  * @title FinalizableCrowdsale
493  * @dev Extension of Crowdsale where an owner can do extra work
494  * after finishing.
495  */
496 contract FinalizableCrowdsale is Crowdsale, Ownable {
497   using SafeMath for uint256;
498 
499   bool public isFinalized = false;
500 
501   event Finalized();
502 
503   /**
504    * @dev Must be called after crowdsale ends, to do some extra finalization
505    * work. Calls the contract's finalization function.
506    */
507   function finalize() onlyOwner public {
508     require(!isFinalized);
509     require(hasEnded());
510 
511     finalization();
512     Finalized();
513 
514     isFinalized = true;
515   }
516 
517   /**
518    * @dev Can be overridden to add finalization logic. The overriding function
519    * should call super.finalization() to ensure the chain of finalization is
520    * executed entirely.
521    */
522   function finalization() internal {
523   }
524 }
525 
526 /**
527  * @title RefundVault
528  * @dev This contract is used for storing funds while a crowdsale
529  * is in progress. Supports refunding the money if crowdsale fails,
530  * and forwarding it if crowdsale is successful.
531  */
532 contract RefundVault is Ownable {
533   using SafeMath for uint256;
534 
535   enum State { Active, Refunding, Closed }
536 
537   mapping (address => uint256) public deposited;
538   address public wallet;
539   State public state;
540 
541   event Closed();
542   event RefundsEnabled();
543   event Refunded(address indexed beneficiary, uint256 weiAmount);
544 
545   function RefundVault(address _wallet) {
546     require(_wallet != 0x0);
547     wallet = _wallet;
548     state = State.Active;
549   }
550 
551   function deposit(address investor) onlyOwner public payable {
552     require(state == State.Active);
553     deposited[investor] = deposited[investor].add(msg.value);
554   }
555 
556   function close() onlyOwner public {
557     require(state == State.Active);
558     state = State.Closed;
559     Closed();
560     wallet.transfer(this.balance);
561   }
562 
563   function enableRefunds() onlyOwner public {
564     require(state == State.Active);
565     state = State.Refunding;
566     RefundsEnabled();
567   }
568 
569   function refund(address investor) public {
570     require(state == State.Refunding);
571     uint256 depositedValue = deposited[investor];
572     deposited[investor] = 0;
573     investor.transfer(depositedValue);
574     Refunded(investor, depositedValue);
575   }
576 }
577 
578 /**
579  * @title RefundableCrowdsale
580  * @dev Extension of Crowdsale contract that adds a funding goal, and
581  * the possibility of users getting a refund if goal is not met.
582  * Uses a RefundVault as the crowdsale's vault.
583  */
584 contract RefundableCrowdsale is FinalizableCrowdsale {
585   using SafeMath for uint256;
586 
587   // minimum amount of funds to be raised in weis
588   uint256 public goal;
589 
590   // refund vault used to hold funds while crowdsale is running
591   RefundVault public vault;
592 
593   function RefundableCrowdsale(uint256 _goal) {
594     require(_goal > 0);
595     vault = new RefundVault(wallet);
596     goal = _goal;
597   }
598 
599   // We're overriding the fund forwarding from Crowdsale.
600   // In addition to sending the funds, we want to call
601   // the RefundVault deposit function
602   function forwardFunds() internal {
603     vault.deposit.value(msg.value)(msg.sender);
604   }
605 
606   // if crowdsale is unsuccessful, investors can claim refunds here
607   function claimRefund() public {
608     require(isFinalized);
609     require(!goalReached());
610 
611     vault.refund(msg.sender);
612   }
613 
614   // vault finalization task, called when owner calls finalize()
615   function finalization() internal {
616     if (goalReached()) {
617       vault.close();
618     } else {
619       vault.enableRefunds();
620     }
621 
622     super.finalization();
623   }
624 
625   function goalReached() public constant returns (bool) {
626     return weiRaised >= goal;
627   }
628 
629 }
630 
631 /**
632  * @title CappedCrowdsale
633  * @dev Extension of Crowdsale with a max amount of funds raised
634  */
635 contract CappedCrowdsale is Crowdsale {
636   using SafeMath for uint256;
637 
638   uint256 public cap;
639 
640   function CappedCrowdsale(uint256 _cap) {
641     require(_cap > 0);
642     cap = _cap;
643   }
644 
645   // overriding Crowdsale#validPurchase to add extra cap logic
646   // @return true if investors can buy at the moment
647   function validPurchase() internal constant returns (bool) {
648     bool withinCap = weiRaised.add(msg.value) <= cap;
649     return super.validPurchase() && withinCap;
650   }
651 
652   // overriding Crowdsale#hasEnded to add cap logic
653   // @return true if crowdsale event has ended
654   function hasEnded() public constant returns (bool) {
655     bool capReached = weiRaised >= cap;
656     return super.hasEnded() || capReached;
657   }
658 
659 }
660 
661 /**
662  * @title ModulumInvestorsWhitelist
663  * @dev ModulumInvestorsWhitelist is a smart contract which holds and manages
664  * a list whitelist of investors allowed to participate in Modulum ICO.
665  * 
666 */
667 contract ModulumInvestorsWhitelist is Ownable {
668 
669   mapping (address => bool) public isWhitelisted;
670 
671   /**
672    * @dev Contructor
673    */
674   function ModulumInvestorsWhitelist() {
675   }
676 
677   /**
678    * @dev Add a new investor to the whitelist
679    */
680   function addInvestorToWhitelist(address _address) public onlyOwner {
681     require(_address != 0x0);
682     require(!isWhitelisted[_address]);
683     isWhitelisted[_address] = true;
684   }
685 
686   /**
687    * @dev Remove an investor from the whitelist
688    */
689   function removeInvestorFromWhiteList(address _address) public onlyOwner {
690     require(_address != 0x0);
691     require(isWhitelisted[_address]);
692     isWhitelisted[_address] = false;
693   }
694 
695   /**
696    * @dev Test whether an investor
697    */
698   function isInvestorInWhitelist(address _address) constant public returns (bool result) {
699     return isWhitelisted[_address];
700   }
701 }
702 
703 /**
704  * @title ModulumTokenHolder
705  * @dev ModulumTokenHolder is a smart contract which purpose is to hold and lock
706  * HTO's token supply for 1.5years following Modulum ICO
707  * 
708 */
709 contract ModulumTokenHolder is Ownable {
710   using SafeMath for uint256;
711   using SafeERC20 for ERC20Basic;
712 
713   event Released(uint256 amount);
714 
715   // beneficiary of tokens after they are released
716   address public beneficiary;
717 
718   // Lock start date
719   uint256 public start;
720   // Lock period
721   uint256 constant public DURATION = 547 days;
722 
723   /**
724    * @dev Contructor
725    */
726   function ModulumTokenHolder(address _beneficiary, uint256 _start) {
727     require(_beneficiary != address(0));
728 
729     beneficiary = _beneficiary;
730     start = _start;
731   }
732 
733   /**
734    * @dev Release MDL tokens held by this smart contract only after the timelock period
735    */
736   function releaseHTOSupply(ERC20Basic token) onlyOwner public {
737     require(now >= start.add(DURATION));
738     require(token.balanceOf(this) > 0);
739     uint256 releasable = token.balanceOf(this);
740 
741     token.safeTransfer(beneficiary, releasable);
742 
743     Released(releasable);
744   }
745 }
746 
747 /**
748  * @title ModulumTokenICO
749  * @dev ModulumTokenICO is the crowdsale smart contract for Modulum ICO, it is capped and refundable.
750  * 
751 */
752 contract ModulumTokenICO is CappedCrowdsale, RefundableCrowdsale {
753   using SafeMath for uint256;
754 
755   ModulumTokenHolder public tokenHolder;
756   ModulumInvestorsWhitelist public whitelist;
757   
758   /**
759    * @dev Contructor
760    */
761   function ModulumTokenICO(
762     uint256 _startTime, 
763     uint256 _endTime, 
764     uint256 _rate, 
765     uint256 _goal, 
766     uint256 _cap, 
767     address _wallet, 
768     ModulumTokenHolder _tokenHolder, 
769     ModulumInvestorsWhitelist _whitelist)
770       CappedCrowdsale(_cap)
771       FinalizableCrowdsale()
772       RefundableCrowdsale(_goal)
773       Crowdsale(_startTime, _endTime, _rate, _wallet)
774   {
775     //As goal needs to be met for a successful crowdsale
776     //the value needs to be less or equal than a cap which is limit for accepted funds
777     require(_goal <= _cap);    
778 
779     //Store other smart contract addresses related to this ICO 
780     tokenHolder = _tokenHolder;
781     whitelist = _whitelist;
782 
783     //Mint HTO's tokens supply to the timelocked smart contract (1.5years)
784     token.mint(address(tokenHolder), 8775000 ether);
785     //Mint the stakeholders tokens supply immediately available for
786     //the HTO to distribute as rewards
787     token.mint(_wallet, 3510000 ether);
788   }
789 
790   function createTokenContract() internal returns (MintableToken) {
791     return new ModulumToken();
792   }
793 
794   // overriding Crowdsale#validPurchase to add extra logic
795   // @return true if investors can buy at the moment
796   function validPurchase() internal constant returns (bool) {
797     // Only accept transfers above 0.2 ETH
798     bool aboveMinTransfer = msg.value >= (20 ether / 100);
799     // Only accept transfers from inverstor in the whitelist
800     bool inWhitelist = whitelist.isInvestorInWhitelist(msg.sender);
801     return super.validPurchase() && aboveMinTransfer && inWhitelist;
802   }
803 
804   // overriding Crowdsale#buyTokens to add a dynamic rate 
805   // that will match bonus token rewards
806   function buyTokens(address beneficiary) public payable {
807     if (weiRaised < 7000 ether) {
808       rate = 450;
809     } else if (weiRaised < 17000 ether) {
810       rate = 360;
811     } else if (weiRaised < 34000 ether) {
812       rate = 330;
813     } else if (weiRaised < 51000 ether) {
814       rate = 315;
815     } else {
816       rate = 300;
817     }
818     return super.buyTokens(beneficiary);
819   }
820 
821   // overriding FinalizableCrowdsale#finalization to prevent further  
822   // minting after ICO end
823   function finalization() internal {
824     token.finishMinting();
825     super.finalization();
826   }
827 }