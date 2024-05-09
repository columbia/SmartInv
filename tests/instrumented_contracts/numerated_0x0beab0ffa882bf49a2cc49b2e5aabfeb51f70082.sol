1 pragma solidity ^0.4.21;
2 
3 // File: contracts/math/SafeMath.sol
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
51 // File: contracts/token/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   uint256 public totalSupply;
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: contracts/token/BasicToken.sol
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
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84 
85     // SafeMath.sub will throw if there is not enough balance.
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     emit Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of.
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) public view returns (uint256 balance) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 // File: contracts/token/BurnableToken.sol
104 
105 /**
106  * @title Burnable Token
107  * @dev Token that can be irreversibly burned (destroyed).
108  */
109 contract BurnableToken is BasicToken {
110 
111     event Burn(address indexed burner, uint256 value);
112 
113     /**
114      * @dev Burns a specific amount of tokens.
115      * @param _value The amount of token to be burned.
116      */
117     function burn(uint256 _value) public {
118         require(_value <= balances[msg.sender]);
119         // no need to require value <= totalSupply, since that would imply the
120         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
121 
122         address burner = msg.sender;
123         balances[burner] = balances[burner].sub(_value);
124         totalSupply = totalSupply.sub(_value);
125         emit Burn(burner, _value);
126     }
127 }
128 
129 // File: contracts/ownership/Ownable.sol
130 
131 /**
132  * @title Ownable
133  * @dev The Ownable contract has an owner address, and provides basic authorization control
134  * functions, this simplifies the implementation of "user permissions".
135  */
136 contract Ownable {
137   address public owner;
138 
139 
140   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142 
143   /**
144    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
145    * account.
146    */
147   function Ownable() public {
148     owner = msg.sender;
149   }
150 
151 
152   /**
153    * @dev Throws if called by any account other than the owner.
154    */
155   modifier onlyOwner() {
156     require(msg.sender == owner);
157     _;
158   }
159 
160 
161   /**
162    * @dev Allows the current owner to transfer control of the contract to a newOwner.
163    * @param newOwner The address to transfer ownership to.
164    */
165   function transferOwnership(address newOwner) public onlyOwner {
166     require(newOwner != address(0));
167     emit OwnershipTransferred(owner, newOwner);
168     owner = newOwner;
169   }
170 
171 }
172 
173 // File: contracts/token/ERC20.sol
174 
175 /**
176  * @title ERC20 interface
177  * @dev see https://github.com/ethereum/EIPs/issues/20
178  */
179 contract ERC20 is ERC20Basic {
180   function allowance(address owner, address spender) public view returns (uint256);
181   function transferFrom(address from, address to, uint256 value) public returns (bool);
182   function approve(address spender, uint256 value) public returns (bool);
183   event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 // File: contracts/token/StandardToken.sol
187 
188 /**
189  * @title Standard ERC20 token
190  *
191  * @dev Implementation of the basic standard token.
192  * @dev https://github.com/ethereum/EIPs/issues/20
193  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
194  */
195 contract StandardToken is ERC20, BasicToken {
196 
197   mapping (address => mapping (address => uint256)) internal allowed;
198 
199 
200   /**
201    * @dev Transfer tokens from one address to another
202    * @param _from address The address which you want to send tokens from
203    * @param _to address The address which you want to transfer to
204    * @param _value uint256 the amount of tokens to be transferred
205    */
206   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208     require(_value <= balances[_from]);
209     require(_value <= allowed[_from][msg.sender]);
210 
211     balances[_from] = balances[_from].sub(_value);
212     balances[_to] = balances[_to].add(_value);
213     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
214     emit Transfer(_from, _to, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220    *
221    * Beware that changing an allowance with this method brings the risk that someone may use both the old
222    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    * @param _spender The address which will spend the funds.
226    * @param _value The amount of tokens to be spent.
227    */
228   function approve(address _spender, uint256 _value) public returns (bool) {
229     allowed[msg.sender][_spender] = _value;
230     emit Approval(msg.sender, _spender, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Function to check the amount of tokens that an owner allowed to a spender.
236    * @param _owner address The address which owns the funds.
237    * @param _spender address The address which will spend the funds.
238    * @return A uint256 specifying the amount of tokens still available for the spender.
239    */
240   function allowance(address _owner, address _spender) public view returns (uint256) {
241     return allowed[_owner][_spender];
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    *
247    * approve should be called when allowed[_spender] == 0. To increment
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _addedValue The amount of tokens to increase the allowance by.
253    */
254   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
255     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260   /**
261    * @dev Decrease the amount of tokens that an owner allowed to a spender.
262    *
263    * approve should be called when allowed[_spender] == 0. To decrement
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _subtractedValue The amount of tokens to decrease the allowance by.
269    */
270   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
271     uint oldValue = allowed[msg.sender][_spender];
272     if (_subtractedValue > oldValue) {
273       allowed[msg.sender][_spender] = 0;
274     } else {
275       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
276     }
277     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281 }
282 
283 // File: contracts/token/MintableToken.sol
284 
285 /**
286  * @title Mintable token
287  * @dev Simple ERC20 Token example, with mintable token creation
288  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
289  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
290  */
291 
292 contract MintableToken is StandardToken, Ownable {
293   event Mint(address indexed to, uint256 amount);
294   event MintFinished();
295 
296   bool public mintingFinished = false;
297 
298 
299   modifier canMint() {
300     require(!mintingFinished);
301     _;
302   }
303 
304   /**
305    * @dev Function to mint tokens
306    * @param _to The address that will receive the minted tokens.
307    * @param _amount The amount of tokens to mint.
308    * @return A boolean that indicates if the operation was successful.
309    *
310    */
311   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
312     totalSupply = totalSupply.add(_amount);
313     balances[_to] = balances[_to].add(_amount);
314     emit Mint(_to, _amount);
315     emit Transfer(address(0), _to, _amount);
316     return true;
317   }
318 
319   /**
320    * @dev Function to stop minting new tokens.
321    * @return True if the operation was successful.
322    */
323   function finishMinting() onlyOwner canMint public returns (bool) {
324     mintingFinished = true;
325     emit MintFinished();
326     return true;
327   }
328 }
329 
330 // File: contracts/token/SafeERC20.sol
331 
332 /**
333  * @title SafeERC20
334  * @dev Wrappers around ERC20 operations that throw on failure.
335  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
336  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
337  */
338 library SafeERC20 {
339   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
340     assert(token.transfer(to, value));
341   }
342 
343   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
344     assert(token.transferFrom(from, to, value));
345   }
346 
347   function safeApprove(ERC20 token, address spender, uint256 value) internal {
348     assert(token.approve(spender, value));
349   }
350 }
351 
352 // File: contracts/BitexToken.sol
353 
354 contract BitexToken is MintableToken, BurnableToken {
355     using SafeERC20 for ERC20;
356 
357     string public constant name = "Bitex Coin";
358 
359     string public constant symbol = "XBX";
360 
361     uint8 public decimals = 18;
362 
363     bool public tradingStarted = false;
364 
365     // allow exceptional transfer fro sender address - this mapping  can be modified only before the starting rounds
366     mapping (address => bool) public transferable;
367 
368     /**
369      * @dev modifier that throws if spender address is not allowed to transfer
370      * and the trading is not enabled
371      */
372     modifier allowTransfer(address _spender) {
373 
374         require(tradingStarted || transferable[_spender]);
375         _;
376     }
377     /**
378     *
379     * Only the owner of the token smart contract can add allow token to be transfer before the trading has started
380     *
381     */
382 
383     function modifyTransferableHash(address _spender, bool value) onlyOwner public {
384         transferable[_spender] = value;
385     }
386 
387     /**
388      * @dev Allows the owner to enable the trading.
389      */
390     function startTrading() onlyOwner public {
391         tradingStarted = true;
392     }
393 
394     /**
395      * @dev Allows anyone to transfer the tokens once trading has started
396      * @param _to the recipient address of the tokens.
397      * @param _value number of tokens to be transfered.
398      */
399     function transfer(address _to, uint _value) allowTransfer(msg.sender) public returns (bool){
400         return super.transfer(_to, _value);
401     }
402 
403     /**
404      * @dev Allows anyone to transfer the  tokens once trading has started or if the spender is part of the mapping
405 
406      * @param _from address The address which you want to send tokens from
407      * @param _to address The address which you want to transfer to
408      * @param _value uint the amout of tokens to be transfered
409      */
410     function transferFrom(address _from, address _to, uint _value) allowTransfer(_from) public returns (bool){
411         return super.transferFrom(_from, _to, _value);
412     }
413 
414     /**
415    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
416    * @param _spender The address which will spend the funds.
417    * @param _value The amount of tokens to be spent.
418    */
419     function approve(address _spender, uint256 _value) public allowTransfer(_spender) returns (bool) {
420         return super.approve(_spender, _value);
421     }
422 
423     /**
424      * Adding whenNotPaused
425      */
426     function increaseApproval(address _spender, uint _addedValue) public allowTransfer(_spender) returns (bool success) {
427         return super.increaseApproval(_spender, _addedValue);
428     }
429 
430     /**
431      * Adding whenNotPaused
432      */
433     function decreaseApproval(address _spender, uint _subtractedValue) public allowTransfer(_spender) returns (bool success) {
434         return super.decreaseApproval(_spender, _subtractedValue);
435     }
436 
437 }
438 
439 // File: contracts/KnowYourCustomer.sol
440 
441 contract KnowYourCustomer is Ownable
442 {
443     //
444     // with this structure
445     //
446     struct Contributor {
447         // kyc cleared or not
448         bool cleared;
449 
450         // % more for the contributor bring on board in 1/100 of %
451         // 2.51 % --> 251
452         // 100% --> 10000
453         uint16 contributor_get;
454 
455         // eth address of the referer if any - the contributor address is the key of the hash
456         address ref;
457 
458         // % more for the referrer
459         uint16 affiliate_get;
460     }
461 
462 
463     mapping (address => Contributor) public whitelist;
464     //address[] public whitelistArray;
465 
466     /**
467     *    @dev Populate the whitelist, only executed by whiteListingAdmin
468     *  whiteListingAdmin /
469     */
470 
471     function setContributor(address _address, bool cleared, uint16 contributor_get, uint16 affiliate_get, address ref) onlyOwner public{
472 
473         // not possible to give an exorbitant bonus to be more than 100% (100x100 = 10000)
474         require(contributor_get<10000);
475         require(affiliate_get<10000);
476 
477         Contributor storage contributor = whitelist[_address];
478 
479         contributor.cleared = cleared;
480         contributor.contributor_get = contributor_get;
481 
482         contributor.ref = ref;
483         contributor.affiliate_get = affiliate_get;
484 
485     }
486 
487     function getContributor(address _address) view public returns (bool, uint16, address, uint16 ) {
488         return (whitelist[_address].cleared, whitelist[_address].contributor_get, whitelist[_address].ref, whitelist[_address].affiliate_get);
489     }
490 
491     function getClearance(address _address) view public returns (bool) {
492         return whitelist[_address].cleared;
493     }
494 }
495 
496 // File: contracts/crowdsale/Crowdsale.sol
497 
498 /**
499  * @title Crowdsale
500  * @dev Crowdsale is a base contract for managing a token crowdsale.
501  * Crowdsales have a start and end timestamps, where investors can make
502  * token purchases and the crowdsale will assign them tokens based
503  * on a token per ETH rate. Funds collected are forwarded to a wallet
504  * as they arrive.
505  */
506 contract Crowdsale {
507   using SafeMath for uint256;
508 
509   // The token being sold
510   MintableToken public token;
511 
512   // start and end timestamps where investments are allowed (both inclusive)
513   uint256 public startTime;
514   uint256 public endTime;
515 
516   // address where funds are collected
517   address public wallet;
518 
519   // how many token units a buyer gets per wei
520   uint256 public rate;
521 
522   // amount of raised money in wei
523   uint256 public weiRaised;
524 
525   /**
526    * event for token purchase logging
527    * @param purchaser who paid for the tokens
528    * @param beneficiary who got the tokens
529    * @param value weis paid for purchase
530    * @param amount amount of tokens purchased
531    */
532   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
533 
534 
535   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
536     require(_startTime >= now);
537     require(_endTime >= _startTime);
538     require(_rate > 0);
539     require(_wallet != address(0));
540 
541     token = createTokenContract();
542     startTime = _startTime;
543     endTime = _endTime;
544     rate = _rate;
545     wallet = _wallet;
546   }
547 
548   // creates the token to be sold.
549   // override this method to have crowdsale of a specific mintable token.
550   function createTokenContract() internal returns (MintableToken) {
551     return new MintableToken();
552   }
553 
554 
555   // fallback function can be used to buy tokens
556   function () external payable {
557     buyTokens(msg.sender);
558   }
559 
560   // low level token purchase function
561   // overrided to create custom buy
562   function buyTokens(address beneficiary) public payable {
563     require(beneficiary != address(0));
564     require(validPurchase());
565 
566     uint256 weiAmount = msg.value;
567 
568     // calculate token amount to be created
569     uint256 tokens = weiAmount.mul(rate);
570 
571     // update state
572     weiRaised = weiRaised.add(weiAmount);
573 
574     token.mint(beneficiary, tokens);
575     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
576 
577     forwardFunds();
578   }
579 
580   // send ether to the fund collection wallet
581   // overrided to create custom fund forwarding mechanisms
582   function forwardFunds() internal {
583     wallet.transfer(msg.value);
584   }
585 
586   // @return true if the transaction can buy tokens
587   function validPurchase() internal view returns (bool) {
588     bool withinPeriod = now >= startTime && now <= endTime ;
589     bool nonZeroPurchase = msg.value != 0 ;
590     return withinPeriod && nonZeroPurchase;
591   }
592 
593   // @return true if crowdsale event has ended
594   function hasEnded() public view returns (bool) {
595     return now > endTime;
596   }
597 
598 
599 }
600 
601 // File: contracts/crowdsale/FinalizableCrowdsale.sol
602 
603 /**
604  * @title FinalizableCrowdsale
605  * @dev Extension of Crowdsale where an owner can do extra work
606  * after finishing.
607  */
608 contract FinalizableCrowdsale is Crowdsale, Ownable {
609   using SafeMath for uint256;
610 
611   bool public isFinalized = false;
612 
613   event Finalized();
614 
615   /**
616    * @dev Must be called after crowdsale ends, to do some extra finalization
617    * work. Calls the contract's finalization function.
618    */
619   function finalize() onlyOwner public {
620     require(!isFinalized);
621     require(hasEnded());
622 
623     finalization();
624     emit Finalized();
625 
626     isFinalized = true;
627   }
628 
629   /**
630    * @dev Can be overridden to add finalization logic. The overriding function
631    * should call super.finalization() to ensure the chain of finalization is
632    * executed entirely.
633    */
634   function finalization() internal{
635   }
636 }
637 
638 // File: contracts/crowdsale/RefundVault.sol
639 
640 /**
641  * @title RefundVault
642  * @dev This contract is used for storing funds while a crowdsale
643  * is in progress. Supports refunding the money if crowdsale fails,
644  * and forwarding it if crowdsale is successful.
645  */
646 contract RefundVault is Ownable {
647   using SafeMath for uint256;
648 
649   enum State { Active, Refunding, Closed }
650 
651   mapping (address => uint256) public deposited;
652   address public wallet;
653   State public state;
654 
655   event Closed();
656   event RefundsEnabled();
657   event Refunded(address indexed beneficiary, uint256 weiAmount);
658 
659   function RefundVault(address _wallet) public {
660     require(_wallet != address(0));
661     wallet = _wallet;
662     state = State.Active;
663   }
664 
665   function deposit(address investor) onlyOwner public payable {
666     require(state == State.Active);
667     deposited[investor] = deposited[investor].add(msg.value);
668   }
669 
670   function close() onlyOwner public {
671     // this is this part that shall be removed, that way if called later it run the wallet transfer in any case
672     // require(state == State.Active);
673     state = State.Closed;
674     emit Closed();
675     wallet.transfer(address(this).balance);
676   }
677 
678   function enableRefunds() onlyOwner public {
679     require(state == State.Active);
680     state = State.Refunding;
681     emit RefundsEnabled();
682   }
683 
684   function refund(address investor) public {
685     require(state == State.Refunding);
686     uint256 depositedValue = deposited[investor];
687     deposited[investor] = 0;
688     investor.transfer(depositedValue);
689     emit Refunded(investor, depositedValue);
690   }
691 }
692 
693 // File: contracts/crowdsale/RefundableCrowdsale.sol
694 
695 /**
696  * @title RefundableCrowdsale
697  * @dev Extension of Crowdsale contract that adds a funding goal, and
698  * the possibility of users getting a refund if goal is not met.
699  * Uses a RefundVault as the crowdsale's vault.
700  */
701 contract RefundableCrowdsale is FinalizableCrowdsale {
702   using SafeMath for uint256;
703 
704   // minimum amount of funds to be raised in weis
705   uint256 public goal;
706 
707   // refund vault used to hold funds while crowdsale is running
708   RefundVault public vault;
709 
710   function RefundableCrowdsale(uint256 _goal) public {
711     require(_goal > 0);
712     vault = new RefundVault(wallet);
713     goal = _goal;
714   }
715 
716   // We're overriding the fund forwarding from Crowdsale.
717   // In addition to sending the funds, we want to call
718   // the RefundVault deposit function
719   function forwardFunds() internal {
720     vault.deposit.value(msg.value)(msg.sender);
721   }
722 
723   // if crowdsale is unsuccessful, investors can claim refunds here
724   function claimRefund() public {
725     require(isFinalized);
726     require(!goalReached());
727 
728     vault.refund(msg.sender);
729   }
730 
731   // vault finalization task, called when owner calls finalize()
732   function finalization() internal {
733     if (goalReached()) {
734       vault.close();
735     } else {
736       vault.enableRefunds();
737     }
738 
739     super.finalization();
740   }
741 
742   function goalReached() public view returns (bool) {
743     return weiRaised >= goal;
744   }
745 
746 }
747 
748 // File: contracts/BitexTokenCrowdSale.sol
749 
750 contract BitexTokenCrowdSale is Crowdsale, RefundableCrowdsale {
751     using SafeMath for uint256;
752 
753     // number of participants
754     uint256 public numberOfPurchasers = 0;
755 
756     // maximum tokens that can be minted in this crowd sale - initialised later by the constructor
757     uint256 public maxTokenSupply = 0;
758 
759     // amounts of tokens already minted at the begining of this crowd sale - initialised later by the constructor
760     uint256 public initialTokenAmount = 0;
761 
762     // Minimum amount to been able to contribute - initialised later by the constructor
763     uint256 public minimumAmount = 0;
764 
765     // to compute the bonus
766     bool public preICO;
767 
768     // the token
769     BitexToken public token;
770 
771     // the kyc and affiliation management
772     KnowYourCustomer public kyc;
773 
774     // remaining token are sent to this address
775     address public walletRemaining;
776 
777     // this is the owner of the token, when the finalize function is called
778     address public pendingOwner;
779 
780 
781     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint256 rate, address indexed referral, uint256 referredBonus );
782     event TokenPurchaseAffiliate(address indexed ref, uint256 amount );
783 
784     function BitexTokenCrowdSale(
785         uint256 _startTime,
786         uint256 _endTime,
787         uint256 _rate,
788         uint256 _goal,
789         uint256 _minimumAmount,
790         uint256 _maxTokenSupply,
791         address _wallet,
792         BitexToken _token,
793         KnowYourCustomer _kyc,
794         bool _preICO,
795         address _walletRemaining,
796         address _pendingOwner
797     )
798     FinalizableCrowdsale()
799     RefundableCrowdsale(_goal)
800     Crowdsale(_startTime, _endTime, _rate, _wallet) public
801     { 
802         require(_minimumAmount >= 0);
803         require(_maxTokenSupply > 0);
804         require(_walletRemaining != address(0));
805 
806         minimumAmount = _minimumAmount;
807         maxTokenSupply = _maxTokenSupply;
808 
809         preICO = _preICO;
810 
811         walletRemaining = _walletRemaining;
812         pendingOwner = _pendingOwner;
813 
814         kyc = _kyc;
815         token = _token;
816 
817         //
818         // record the amount of already minted token to been able to compute the delta with the tokens
819         // minted during the pre sale, this is useful only for the pre - ico
820         //
821         if (preICO)
822         {
823             initialTokenAmount = token.totalSupply();
824         }
825     }
826 
827     /**
828     *
829     * Create the token on the fly, owner is the contract, not the contract owner yet
830     *
831     **/
832     function createTokenContract() internal returns (MintableToken) {
833         return token;
834     }
835 
836 
837     /**
838     * @dev Calculates the amount of  coins the buyer gets
839     * @param weiAmount uint the amount of wei send to the contract
840     * @return uint the amount of tokens the buyer gets
841     */
842     function computeTokenWithBonus(uint256 weiAmount) public view returns(uint256) {
843         uint256 tokens_ = 0;
844         if (preICO)
845         {
846             if (weiAmount >= 50000 ether  ) {
847 
848                 tokens_ = weiAmount.mul(34).div(100);
849 
850             }
851             else if (weiAmount<50000 ether && weiAmount >= 10000 ether) {
852 
853                 tokens_ = weiAmount.mul(26).div(100);
854 
855             } else if (weiAmount<10000 ether && weiAmount >= 5000 ether) {
856 
857                 tokens_ = weiAmount.mul(20).div(100);
858 
859             } else if (weiAmount<5000 ether && weiAmount >= 1000 ether) {
860 
861                 tokens_ = weiAmount.mul(16).div(100);
862             }
863 
864         }else{
865             if (weiAmount >= 50000 ether  ) {
866 
867                 tokens_ = weiAmount.mul(17).div(100);
868 
869             }
870             else if (weiAmount<50000 ether && weiAmount >= 10000 ether) {
871 
872                 tokens_ = weiAmount.mul(13).div(100);
873 
874             } else if (weiAmount<10000 ether && weiAmount >= 5000 ether) {
875 
876                 tokens_ = weiAmount.mul(10).div(100);
877 
878             } else if (weiAmount<5000 ether && weiAmount >= 1000 ether) {
879 
880                 tokens_ = weiAmount.mul(8).div(100);
881             }
882 
883         }
884 
885         return tokens_;
886     }
887     //
888     // override the claimRefund, so only user that have burn their token can claim for a refund
889     //
890     function claimRefund() public {
891 
892         // get the number of token from this sender
893         uint256 tokenBalance = token.balanceOf(msg.sender);
894 
895         // the refund can be run  only if the tokens has been burn
896         require(tokenBalance == 0);
897 
898         // run the refund
899         super.claimRefund();
900 
901     }
902 
903      // transfer the token owner ship to the crowdsale contract
904     //        token.transferOwnership(currentIco);
905     function finalization() internal {
906 
907         if (!preICO)
908         {
909             uint256 remainingTokens = maxTokenSupply.sub(token.totalSupply());
910 
911             // mint the remaining amount and assign them to the beneficiary
912             // --> here we can manage the vesting of the remaining tokens
913             //
914             token.mint(walletRemaining, remainingTokens);
915 
916         }
917 
918          // finalize the refundable inherited contract
919         super.finalization();
920 
921         if (!preICO)
922         {
923             // no more minting allowed - immutable
924             token.finishMinting();
925         }
926 
927         // transfer the token owner ship from the contract address to the pendingOwner icoController
928         token.transferOwnership(pendingOwner);
929 
930     }
931 
932 
933 
934     // low level token purchase function
935     function buyTokens(address beneficiary) public payable {
936         require(beneficiary != address(0));
937         require(validPurchase());
938 
939         // validate KYC here
940         // if not part of kyc then throw
941         bool cleared;
942         uint16 contributor_get;
943         address ref;
944         uint16 affiliate_get;
945 
946         (cleared,contributor_get,ref,affiliate_get) = kyc.getContributor(beneficiary);
947 
948         // Transaction do not happen if the contributor is not KYC cleared
949         require(cleared);
950 
951         // how much the contributor sent in wei
952         uint256 weiAmount = msg.value;
953 
954         // Compute the number of tokens per wei using the rate
955         uint256 tokens = weiAmount.mul(rate);
956 
957          // compute the amount of bonus, from the contribution amount
958         uint256 bonus = computeTokenWithBonus(tokens);
959 
960         // compute the amount of token bonus for the contributor thank to his referral
961         uint256 contributorGet = tokens.mul(contributor_get).div(100*100);
962 
963         // Sum it all
964         tokens = tokens.add(bonus);
965         tokens = tokens.add(contributorGet);
966 
967         // capped to a maxTokenSupply
968         // make sure we can not mint more token than expected
969         // require(((token.totalSupply()-initialTokenAmount) + tokens) <= maxTokenSupply);
970         require((minted().add(tokens)) <= maxTokenSupply);
971 
972 
973         // Mint the token
974         token.mint(beneficiary, tokens);
975 
976         // log the event
977         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, rate, ref, contributorGet);
978 
979         // update wei raised and number of purchasers
980         weiRaised = weiRaised.add(weiAmount);
981         numberOfPurchasers = numberOfPurchasers + 1;
982 
983         forwardFunds();
984 
985         // ------------------------------------------------------------------
986         // compute the amount of token bonus that the referral get :
987         // only if KYC cleared, only if enough tokens still available
988         // ------------------------------------------------------------------
989         bool refCleared;
990         (refCleared) = kyc.getClearance(ref);
991         if (refCleared && ref != beneficiary)
992         {
993             // recompute the tokens amount using only the rate
994             tokens = weiAmount.mul(rate);
995 
996             // compute the amount of token for the affiliate
997             uint256 affiliateGet = tokens.mul(affiliate_get).div(100*100);
998 
999             // capped to a maxTokenSupply
1000             // make sure we can not mint more token than expected
1001             // we do not throw here as if this edge case happens it can be dealt with of chain
1002             // if ( (token.totalSupply()-initialTokenAmount) + affiliateGet <= maxTokenSupply)
1003             if ( minted().add(affiliateGet) <= maxTokenSupply)
1004 
1005             {
1006                 // Mint the token
1007                 token.mint(ref, affiliateGet);
1008                 emit TokenPurchaseAffiliate(ref, tokens );
1009             }
1010 
1011         }
1012     }
1013 
1014     // overriding Crowdsale#validPurchase to add extra cap logic
1015     // @return true if investors can buy at the moment
1016     function validPurchase() internal view returns (bool) {
1017 
1018         // make sure we accept only the minimum contribution
1019         bool minAmount = (msg.value >= minimumAmount);
1020 
1021         // make sure that the purchase follow each rules to be valid
1022         return super.validPurchase() && minAmount;
1023     }
1024 
1025     function minted() public view returns(uint256)
1026     {
1027         return token.totalSupply().sub(initialTokenAmount); 
1028     }
1029 
1030     // overriding Crowdsale#hasEnded to add cap logic
1031     // @return true if crowdsale event has ended
1032     function hasEnded() public view returns (bool) {
1033         // bool capReached = (token.totalSupply() - initialTokenAmount) >= maxTokenSupply;
1034         // bool capReached = minted() >= maxTokenSupply;
1035         return super.hasEnded() || (minted() >= maxTokenSupply);
1036     }
1037 
1038     /**
1039       *
1040       * Admin functions only executed by owner:
1041       * Can change minimum amount
1042       *
1043       */
1044     function changeMinimumAmount(uint256 _minimumAmount) onlyOwner public {
1045         require(_minimumAmount > 0);
1046 
1047         minimumAmount = _minimumAmount;
1048     }
1049 
1050      /**
1051       *
1052       * Admin functions only executed by owner:
1053       * Can change rate
1054       *
1055       * We do not use an oracle here as oracle need to be paid each time, and if the oracle is not responding
1056       * or hacked the rate could be detrimentally modified from an contributor perspective.
1057       *
1058       */
1059     function changeRate(uint256 _rate) onlyOwner public {
1060         require(_rate > 0);
1061         
1062         rate = _rate;
1063     }
1064 
1065     /**
1066       *
1067       * Admin functions only called by owner:
1068       * Can change events dates
1069       *
1070       */
1071     function changeDates(uint256 _startTime, uint256 _endTime) onlyOwner public {
1072         require(_startTime >= now);
1073         require(_endTime >= _startTime);
1074         startTime = _startTime;
1075         endTime = _endTime;
1076     }
1077 
1078     function modifyTransferableHash(address _spender, bool value) onlyOwner public {
1079         token.modifyTransferableHash(_spender,value);
1080     }
1081 
1082     /**
1083       *
1084       * Admin functions only called by owner:
1085       * Can transfer the owner ship of the vault, so a close can be called
1086       * only by the owner ....
1087       *
1088       */
1089     function transferVault(address newOwner) onlyOwner public {
1090         vault.transferOwnership(newOwner);
1091 
1092     }
1093    
1094 }
1095 
1096 // File: contracts/IcoController.sol
1097 
1098 contract IcoController is Ownable {
1099     // ico phase : prepare / rounds
1100     //enum State {CHANGEOWNER, PRESALE, PRE_ICO, ICO, TRADING}
1101 
1102     // 0 - CHANGEOWNER
1103     // 1 - PRESALE
1104     // 2 - PRE_ICO
1105 
1106     //State public state = 0;
1107     uint8 public statePhase = 0;
1108 
1109     // Pending owner
1110     address public pendingOwner;
1111 
1112     // white list admin
1113     address public whiteListingAdmin;
1114 
1115     // The token being sold
1116     BitexToken public token;
1117 
1118     // The pre ICO
1119     BitexTokenCrowdSale public preICO;
1120 
1121     // the main ICO
1122     BitexTokenCrowdSale public currentIco;
1123 
1124     // Kyc and affiliate management
1125     KnowYourCustomer public kyc;
1126 
1127     // last round
1128     bool public lastRound = false;
1129 
1130     address public walletRemaining;
1131 
1132     // maximum tokens that can be minted in all the crowd sales 
1133     uint256 public maxTokenSupply = 0;
1134 
1135     uint256 public finalizePreIcoDate;
1136     uint256 public finalizeIcoDate;
1137 
1138     // first function to be called
1139     function InitIcoController(address _pendingOwner) onlyOwner public{
1140         // require(_pendingOwner != address(0));
1141         pendingOwner = _pendingOwner;
1142 
1143         token = new BitexToken();
1144         kyc = new KnowYourCustomer();
1145     }
1146 
1147     /**
1148       *
1149       * Prepare the events
1150       * - set the max_supply
1151       * - set the wallet for the remaining amount
1152       * - move to phase 1
1153       *
1154       * -->  only if the pendingOwner has been set
1155       */
1156     function prepare(uint256 _maxTokenSupply,address _walletRemaining,address _whiteListingAdmin) onlyOwner public{
1157         // only during the prepare phase
1158         require(statePhase == 0);
1159 
1160         // transfer of Owner ship need to have been done
1161         require(owner == pendingOwner);
1162 
1163         // avoid mistake
1164         // require(_maxTokenSupply>0);
1165 
1166         // avoid mistake
1167         // require(_walletRemaining != address(0));
1168 
1169         maxTokenSupply = _maxTokenSupply;
1170         walletRemaining = _walletRemaining;
1171 
1172         whiteListingAdmin = _whiteListingAdmin;
1173 
1174         statePhase = 1;
1175     }
1176 
1177     /**
1178        Allow minting during the PRE SALE  ico phase
1179      */
1180     function mint(uint256 tokens,address beneficiary) onlyOwner public{
1181         // only during the prepare phase, can not mint after
1182         require(statePhase == 1);
1183         // avoid mistake
1184         // require(tokens > 0);
1185         // require(beneficiary != address(0));
1186 
1187         // cap crowdsaled to a maxTokenSupply
1188         // make sure we can not mint more token than expected
1189         bool lessThanMaxSupply = (token.totalSupply() + tokens) <= maxTokenSupply;
1190         require(lessThanMaxSupply);
1191 
1192         // mint the tokens
1193         token.mint(beneficiary, tokens);
1194     }
1195 
1196     /**
1197 
1198         Simplify creation for Bitex team
1199 
1200     */
1201     function mintAndCreatePreIcoBitex(address _walletRemaining,address _teamWallet) onlyOwner public
1202     {
1203         prepare(300000000000000000000000000,_walletRemaining, 0xd68cE8BF133297C3C27cc582A9E5452F64F76E4b);
1204 
1205         // mint 63M reserved
1206         mint(63000000000000000000000000,0xB52c45b43B5c2dC6928149C54A05bA3A91542060);
1207 
1208         // mint 27M team
1209         mint(27000000000000000000000000,_teamWallet);
1210 
1211         // create the pre ico
1212         createPreIco(1525791600,
1213                      1527606000,
1214                      1000,
1215                      1000000000000000000000,
1216                      100000000000000000,
1217                      30000000000000000000000000,
1218                      0x1eF0cAD0E9A12cf39494e7D40643985538E7e963);
1219 
1220         // enable transfer from, for the following wallets
1221         modifyTransferableHash(_walletRemaining,true);
1222         modifyTransferableHash(_teamWallet,true);
1223         modifyTransferableHash(0xB52c45b43B5c2dC6928149C54A05bA3A91542060,true);
1224 
1225     }
1226     /**
1227     *
1228     * Setup a new ICO event
1229     *
1230     */
1231     function createPreIco(
1232         uint256 _startTime,
1233         uint256 _endTime,
1234         uint256 _rate,
1235         uint256 _goal,
1236         uint256 _minimumAmount,
1237         uint256 _maxTokenForThisRound,
1238         address _wallet
1239         ) onlyOwner public
1240     {
1241         // only before rounds
1242         require(statePhase<=1); 
1243 
1244         // need to check that the max token supply constraint is respected
1245         currentIco = new BitexTokenCrowdSale(
1246             _startTime,
1247             _endTime,
1248             _rate,
1249             _goal,
1250             _minimumAmount,
1251             _maxTokenForThisRound,
1252             _wallet,
1253             token,
1254             kyc,
1255             true,
1256             walletRemaining,
1257             address(this)
1258         );
1259 
1260         // // keep track of the preICO
1261         preICO = currentIco;
1262 
1263         // transfer the token owner ship to the crowdsale contract
1264         token.transferOwnership(currentIco);
1265 
1266         // only at the end in case of not enough gas
1267         statePhase = 2;
1268     }
1269 
1270     /**
1271     *
1272     * Setup a new ICO event
1273     *
1274     */
1275     function createIco(
1276         uint256 _startTime,
1277         uint256 _endTime,
1278         uint256 _rate,
1279         uint256 _goal,
1280         uint256 _minimumAmount,
1281         address _wallet) onlyOwner public
1282     {
1283         require(statePhase==2); // only after pre ico
1284 
1285         // need to check that the max token supply constraint is respected
1286         currentIco = new BitexTokenCrowdSale(
1287             _startTime,
1288             _endTime,
1289             _rate,
1290             _goal,
1291             _minimumAmount,
1292             maxTokenSupply,
1293             _wallet,
1294             token,
1295             kyc,
1296             false,
1297             walletRemaining,
1298             pendingOwner // transfer the ownership to the actual pending owner
1299         );
1300 
1301         // transfer the token owner ship to the crowdsale contract
1302         token.transferOwnership(currentIco);
1303 
1304         // only if successful until that point
1305         statePhase = 3;
1306     }
1307 
1308 
1309     function finalizeIco() onlyOwner public
1310     {
1311         if (statePhase==2)
1312         {
1313             finalizePreIcoDate = now;
1314         }else{
1315             finalizeIcoDate = now;
1316         }
1317         currentIco.finalize();
1318     }
1319      /**
1320       *
1321       * Token functions
1322       * can be called only during the prepare phase, because the owner change after this to be own by the crowdsale,
1323       * so nobody can do anything on the token at all from the controller perpective once rounds are started
1324       */
1325     function modifyTransferableHash(address _spender, bool value) onlyOwner public
1326     {
1327         // require(statePhase <=1 ); // only before rounds  - not for bitex
1328         // owner is the icoController
1329 
1330         // during the presale the token is own by 'this' so we can call it directly
1331         if (statePhase<=1)
1332         {
1333             token.modifyTransferableHash(_spender,value);
1334        }else{
1335            // during the crowdsale, it shall not be allowed 
1336            // but if it is needed by the project owner it can by calling the crowdsale object
1337            // own by 'this'
1338            currentIco.modifyTransferableHash(_spender, value);
1339         }
1340 
1341     }
1342 
1343     /**
1344       *
1345       * Admin functions only executed by owner:
1346       * Can change minimum amount
1347       *
1348       */
1349     function changeMinimumAmount(uint256 _minimumAmount) onlyOwner public {
1350         // avoid mistake
1351         // require(statePhase >=2 );
1352         // require(_minimumAmount > 0);
1353 
1354         currentIco.changeMinimumAmount(_minimumAmount);
1355     }
1356 
1357      /**
1358       *
1359       * Admin functions only executed by owner:
1360       * Can change rate
1361       *
1362       * We do not use an oracle here as oracle need to be paid each time, and if the oracle is not responding
1363       * or hacked the rate could be detrimentally modified from an contributor perspective.
1364       *
1365       */
1366     function changeRate(uint256 _rate) onlyOwner public {
1367         // avoid mistake
1368         // require(statePhase >=2 );
1369         currentIco.changeRate(_rate);
1370     }
1371 
1372     /**
1373       *
1374       * Admin functions only called by owner:
1375       * Can change events dates
1376       *
1377       */
1378     function changeDates(uint256 _startTime, uint256 _endTime) onlyOwner public {
1379         // avoid mistake
1380         // require(statePhase >=2 );
1381         currentIco.changeDates(_startTime, _endTime);
1382     }
1383 
1384     /**
1385       *
1386       * Admin functions only executed by pendingOwner
1387       * Change the owner of the crowdsale
1388       * --> thiscall shall be possible 15 days after the end of each of the event, and each of them would need to be finalized
1389       *     that way contributor have the time to get their refunds if needed.
1390       */
1391     function transferCrowdSale(bool preIco) onlyOwner public {
1392         if (preIco)
1393         {
1394             require(finalizePreIcoDate!=0);
1395             require(now>=(finalizePreIcoDate+30 days));
1396             preICO.transferOwnership(owner);
1397             kyc.transferOwnership(owner);
1398         }else{
1399             require(finalizeIcoDate!=0);
1400             require(now>=finalizeIcoDate+30 days);
1401             currentIco.transferOwnership(owner);
1402         }
1403     }
1404 
1405     /**
1406     *
1407     * Only by the whitelist admin
1408     *
1409     */
1410     function setContributor(address _address, bool cleared, uint16 contributor_get, uint16 affiliate_get, address ref) public{
1411         require(msg.sender == whiteListingAdmin);
1412         // this call is done under the icoController address the real owner of the kyc. It ensure that only the icoController can call the kyc smart contract
1413         // until the end of the event, where the ownership is transfered back to the pendingOwner
1414         kyc.setContributor(_address, cleared, contributor_get, affiliate_get, ref);
1415     }
1416     /**
1417     *
1418     * in case the whitelisting admin need to be changed
1419     *
1420     */
1421     function setWhiteListAdmin(address _address) onlyOwner public{
1422         whiteListingAdmin=_address;
1423     }
1424 
1425    /**
1426       *
1427       * Admin functions only executed by pendingOwner
1428       * Change the owner
1429       *
1430       */
1431     function transferOwnerShipToPendingOwner() public {
1432 
1433         // only the pending owner can change the ownership
1434         require(msg.sender == pendingOwner);
1435 
1436         // // can only be changed one time - no impact removed
1437         // require(owner != pendingOwner);
1438 
1439         // raise the event
1440         emit OwnershipTransferred(owner, pendingOwner);
1441 
1442         // change the ownership
1443         owner = pendingOwner;
1444 
1445     }
1446 
1447 
1448 }