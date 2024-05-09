1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/crowdsale/RefundVault.sol
83 
84 /**
85  * @title RefundVault
86  * @dev This contract is used for storing funds while a crowdsale
87  * is in progress. Supports refunding the money if crowdsale fails,
88  * and forwarding it if crowdsale is successful.
89  */
90 contract RefundVault is Ownable {
91   using SafeMath for uint256;
92 
93   enum State { Active, Refunding, Closed }
94 
95   mapping (address => uint256) public deposited;
96   address public wallet;
97   State public state;
98 
99   event Closed();
100   event RefundsEnabled();
101   event Refunded(address indexed beneficiary, uint256 weiAmount);
102 
103   function RefundVault(address _wallet) public {
104     require(_wallet != address(0));
105     wallet = _wallet;
106     state = State.Active;
107   }
108 
109   function deposit(address investor) onlyOwner public payable {
110     require(state == State.Active);
111     deposited[investor] = deposited[investor].add(msg.value);
112   }
113 
114   function close() onlyOwner public {
115     require(state == State.Active);
116     state = State.Closed;
117     Closed();
118     wallet.transfer(this.balance);
119   }
120 
121   function enableRefunds() onlyOwner public {
122     require(state == State.Active);
123     state = State.Refunding;
124     RefundsEnabled();
125   }
126 
127   function refund(address investor) public {
128     require(state == State.Refunding);
129     uint256 depositedValue = deposited[investor];
130     deposited[investor] = 0;
131     investor.transfer(depositedValue);
132     Refunded(investor, depositedValue);
133   }
134 }
135 
136 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
137 
138 /**
139  * @title Pausable
140  * @dev Base contract which allows children to implement an emergency stop mechanism.
141  */
142 contract Pausable is Ownable {
143   event Pause();
144   event Unpause();
145 
146   bool public paused = false;
147 
148 
149   /**
150    * @dev Modifier to make a function callable only when the contract is not paused.
151    */
152   modifier whenNotPaused() {
153     require(!paused);
154     _;
155   }
156 
157   /**
158    * @dev Modifier to make a function callable only when the contract is paused.
159    */
160   modifier whenPaused() {
161     require(paused);
162     _;
163   }
164 
165   /**
166    * @dev called by the owner to pause, triggers stopped state
167    */
168   function pause() onlyOwner whenNotPaused public {
169     paused = true;
170     Pause();
171   }
172 
173   /**
174    * @dev called by the owner to unpause, returns to normal state
175    */
176   function unpause() onlyOwner whenPaused public {
177     paused = false;
178     Unpause();
179   }
180 }
181 
182 // File: contracts/MyRefundVault.sol
183 
184 contract MyRefundVault is RefundVault, Pausable {
185 
186   function MyRefundVault(address _wallet) RefundVault(_wallet) 
187   {
188   }
189 
190   function getDeposit(address contributor) public view returns(uint256 depositedValue)
191   {
192     return deposited[contributor];    
193   }
194 
195   function refundWhenNotClosed(address contributor) public onlyOwner whenNotPaused returns(uint256 weiRefunded) {
196     require(state != State.Closed);
197     uint256 depositedValue = deposited[contributor];
198     deposited[contributor] = 0;
199     uint256 refundFees = depositedValue.div(100);
200     uint256 refundValue = depositedValue.sub(refundFees);
201     if(refundFees > 0)
202       wallet.transfer(refundFees);
203     if(refundValue > 0)
204       contributor.transfer(refundValue);
205     Refunded(contributor, depositedValue);
206     return depositedValue;
207   }
208 
209   function isRefundPaused() public view returns(bool) {
210     return paused;
211   }
212 
213   function myRefund(address investor) public onlyOwner whenNotPaused returns(uint256 refunedValue) {
214     require(state == State.Refunding);
215     uint256 depositedValue = deposited[investor];
216     deposited[investor] = 0;
217     investor.transfer(depositedValue);
218     Refunded(investor, depositedValue);
219     return depositedValue;
220   }
221 
222 }
223 
224 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
225 
226 /**
227  * @title ERC20Basic
228  * @dev Simpler version of ERC20 interface
229  * @dev see https://github.com/ethereum/EIPs/issues/179
230  */
231 contract ERC20Basic {
232   uint256 public totalSupply;
233   function balanceOf(address who) public view returns (uint256);
234   function transfer(address to, uint256 value) public returns (bool);
235   event Transfer(address indexed from, address indexed to, uint256 value);
236 }
237 
238 // File: zeppelin-solidity/contracts/token/BasicToken.sol
239 
240 /**
241  * @title Basic token
242  * @dev Basic version of StandardToken, with no allowances.
243  */
244 contract BasicToken is ERC20Basic {
245   using SafeMath for uint256;
246 
247   mapping(address => uint256) balances;
248 
249   /**
250   * @dev transfer token for a specified address
251   * @param _to The address to transfer to.
252   * @param _value The amount to be transferred.
253   */
254   function transfer(address _to, uint256 _value) public returns (bool) {
255     require(_to != address(0));
256     require(_value <= balances[msg.sender]);
257 
258     // SafeMath.sub will throw if there is not enough balance.
259     balances[msg.sender] = balances[msg.sender].sub(_value);
260     balances[_to] = balances[_to].add(_value);
261     Transfer(msg.sender, _to, _value);
262     return true;
263   }
264 
265   /**
266   * @dev Gets the balance of the specified address.
267   * @param _owner The address to query the the balance of.
268   * @return An uint256 representing the amount owned by the passed address.
269   */
270   function balanceOf(address _owner) public view returns (uint256 balance) {
271     return balances[_owner];
272   }
273 
274 }
275 
276 // File: zeppelin-solidity/contracts/token/ERC20.sol
277 
278 /**
279  * @title ERC20 interface
280  * @dev see https://github.com/ethereum/EIPs/issues/20
281  */
282 contract ERC20 is ERC20Basic {
283   function allowance(address owner, address spender) public view returns (uint256);
284   function transferFrom(address from, address to, uint256 value) public returns (bool);
285   function approve(address spender, uint256 value) public returns (bool);
286   event Approval(address indexed owner, address indexed spender, uint256 value);
287 }
288 
289 // File: zeppelin-solidity/contracts/token/StandardToken.sol
290 
291 /**
292  * @title Standard ERC20 token
293  *
294  * @dev Implementation of the basic standard token.
295  * @dev https://github.com/ethereum/EIPs/issues/20
296  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
297  */
298 contract StandardToken is ERC20, BasicToken {
299 
300   mapping (address => mapping (address => uint256)) internal allowed;
301 
302 
303   /**
304    * @dev Transfer tokens from one address to another
305    * @param _from address The address which you want to send tokens from
306    * @param _to address The address which you want to transfer to
307    * @param _value uint256 the amount of tokens to be transferred
308    */
309   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
310     require(_to != address(0));
311     require(_value <= balances[_from]);
312     require(_value <= allowed[_from][msg.sender]);
313 
314     balances[_from] = balances[_from].sub(_value);
315     balances[_to] = balances[_to].add(_value);
316     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
317     Transfer(_from, _to, _value);
318     return true;
319   }
320 
321   /**
322    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
323    *
324    * Beware that changing an allowance with this method brings the risk that someone may use both the old
325    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
326    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
327    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
328    * @param _spender The address which will spend the funds.
329    * @param _value The amount of tokens to be spent.
330    */
331   function approve(address _spender, uint256 _value) public returns (bool) {
332     allowed[msg.sender][_spender] = _value;
333     Approval(msg.sender, _spender, _value);
334     return true;
335   }
336 
337   /**
338    * @dev Function to check the amount of tokens that an owner allowed to a spender.
339    * @param _owner address The address which owns the funds.
340    * @param _spender address The address which will spend the funds.
341    * @return A uint256 specifying the amount of tokens still available for the spender.
342    */
343   function allowance(address _owner, address _spender) public view returns (uint256) {
344     return allowed[_owner][_spender];
345   }
346 
347   /**
348    * @dev Increase the amount of tokens that an owner allowed to a spender.
349    *
350    * approve should be called when allowed[_spender] == 0. To increment
351    * allowed value is better to use this function to avoid 2 calls (and wait until
352    * the first transaction is mined)
353    * From MonolithDAO Token.sol
354    * @param _spender The address which will spend the funds.
355    * @param _addedValue The amount of tokens to increase the allowance by.
356    */
357   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
358     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
359     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
360     return true;
361   }
362 
363   /**
364    * @dev Decrease the amount of tokens that an owner allowed to a spender.
365    *
366    * approve should be called when allowed[_spender] == 0. To decrement
367    * allowed value is better to use this function to avoid 2 calls (and wait until
368    * the first transaction is mined)
369    * From MonolithDAO Token.sol
370    * @param _spender The address which will spend the funds.
371    * @param _subtractedValue The amount of tokens to decrease the allowance by.
372    */
373   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
374     uint oldValue = allowed[msg.sender][_spender];
375     if (_subtractedValue > oldValue) {
376       allowed[msg.sender][_spender] = 0;
377     } else {
378       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
379     }
380     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
381     return true;
382   }
383 
384 }
385 
386 // File: zeppelin-solidity/contracts/token/MintableToken.sol
387 
388 /**
389  * @title Mintable token
390  * @dev Simple ERC20 Token example, with mintable token creation
391  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
392  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
393  */
394 
395 contract MintableToken is StandardToken, Ownable {
396   event Mint(address indexed to, uint256 amount);
397   event MintFinished();
398 
399   bool public mintingFinished = false;
400 
401 
402   modifier canMint() {
403     require(!mintingFinished);
404     _;
405   }
406 
407   /**
408    * @dev Function to mint tokens
409    * @param _to The address that will receive the minted tokens.
410    * @param _amount The amount of tokens to mint.
411    * @return A boolean that indicates if the operation was successful.
412    */
413   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
414     totalSupply = totalSupply.add(_amount);
415     balances[_to] = balances[_to].add(_amount);
416     Mint(_to, _amount);
417     Transfer(address(0), _to, _amount);
418     return true;
419   }
420 
421   /**
422    * @dev Function to stop minting new tokens.
423    * @return True if the operation was successful.
424    */
425   function finishMinting() onlyOwner canMint public returns (bool) {
426     mintingFinished = true;
427     MintFinished();
428     return true;
429   }
430 }
431 
432 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
433 
434 /**
435  * @title Crowdsale
436  * @dev Crowdsale is a base contract for managing a token crowdsale.
437  * Crowdsales have a start and end timestamps, where investors can make
438  * token purchases and the crowdsale will assign them tokens based
439  * on a token per ETH rate. Funds collected are forwarded to a wallet
440  * as they arrive.
441  */
442 contract Crowdsale {
443   using SafeMath for uint256;
444 
445   // The token being sold
446   MintableToken public token;
447 
448   // start and end timestamps where investments are allowed (both inclusive)
449   uint256 public startTime;
450   uint256 public endTime;
451 
452   // address where funds are collected
453   address public wallet;
454 
455   // how many token units a buyer gets per wei
456   uint256 public rate;
457 
458   // amount of raised money in wei
459   uint256 public weiRaised;
460 
461   /**
462    * event for token purchase logging
463    * @param purchaser who paid for the tokens
464    * @param beneficiary who got the tokens
465    * @param value weis paid for purchase
466    * @param amount amount of tokens purchased
467    */
468   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
469 
470 
471   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
472     //require(_startTime >= now);
473     require(_endTime >= _startTime);
474     require(_rate > 0);
475     require(_wallet != address(0));
476 
477     token = createTokenContract();
478     startTime = _startTime;
479     endTime = _endTime;
480     rate = _rate;
481     wallet = _wallet;
482   }
483 
484   // creates the token to be sold.
485   // override this method to have crowdsale of a specific mintable token.
486   function createTokenContract() internal returns (MintableToken) {
487     return new MintableToken();
488   }
489 
490 
491   // fallback function can be used to buy tokens
492   function () external payable {
493     buyTokens(msg.sender);
494   }
495 
496   // low level token purchase function
497   function buyTokens(address beneficiary) public payable {
498     require(beneficiary != address(0));
499     require(validPurchase());
500 
501     uint256 weiAmount = msg.value;
502 
503     // calculate token amount to be created
504     uint256 tokens = weiAmount.mul(rate);
505 
506     // update state
507     weiRaised = weiRaised.add(weiAmount);
508 
509     token.mint(beneficiary, tokens);
510     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
511 
512     forwardFunds();
513   }
514 
515   // send ether to the fund collection wallet
516   // override to create custom fund forwarding mechanisms
517   function forwardFunds() internal {
518     wallet.transfer(msg.value);
519   }
520 
521   // @return true if the transaction can buy tokens
522   function validPurchase() internal view returns (bool) {
523     bool withinPeriod = now >= startTime && now <= endTime;
524     bool nonZeroPurchase = msg.value != 0;
525     return withinPeriod && nonZeroPurchase;
526   }
527 
528   // @return true if crowdsale event has ended
529   function hasEnded() public view returns (bool) {
530     return now > endTime;
531   }
532 
533 
534 }
535 
536 // File: zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
537 
538 /**
539  * @title FinalizableCrowdsale
540  * @dev Extension of Crowdsale where an owner can do extra work
541  * after finishing.
542  */
543 contract FinalizableCrowdsale is Crowdsale, Ownable {
544   using SafeMath for uint256;
545 
546   bool public isFinalized = false;
547 
548   event Finalized();
549 
550   /**
551    * @dev Must be called after crowdsale ends, to do some extra finalization
552    * work. Calls the contract's finalization function.
553    */
554   function finalize() onlyOwner public {
555     require(!isFinalized);
556     require(hasEnded());
557 
558     finalization();
559     Finalized();
560 
561     isFinalized = true;
562   }
563 
564   /**
565    * @dev Can be overridden to add finalization logic. The overriding function
566    * should call super.finalization() to ensure the chain of finalization is
567    * executed entirely.
568    */
569   function finalization() internal {
570   }
571 }
572 
573 // File: contracts/MyRefundableCrowdsale.sol
574 
575 contract MyRefundableCrowdsale is FinalizableCrowdsale {
576   using SafeMath for uint256;
577 
578   // minimum amount of funds to be raised in weis
579   uint256 public goal;
580 
581   // refund vault used to hold funds while crowdsale is running
582   MyRefundVault public vault;
583 
584   function MyRefundableCrowdsale(uint256 _goal) public {
585     require(_goal > 0);
586     vault = new MyRefundVault(wallet);
587     goal = _goal;
588   }
589 
590   // We're overriding the fund forwarding from Crowdsale.
591   // In addition to sending the funds, we want to call
592   // the RefundVault deposit function
593   function forwardFunds() internal {
594     vault.deposit.value(msg.value)(msg.sender);
595   }
596 
597   // if crowdsale is unsuccessful, investors can claim refunds here
598   function claimRefundOnUnsuccessfulEvent() public {
599     require(isFinalized);
600     require(!goalReached());
601     uint256 refundedValue = vault.myRefund(msg.sender);
602     weiRaised = weiRaised.sub(refundedValue);
603   }
604 
605   // vault finalization task, called when owner calls finalize()
606   function finalization() internal {
607     if (goalReached()) {
608       vault.close();
609     } else {
610       vault.enableRefunds();
611     }
612 
613     super.finalization();
614   }
615 
616   function goalReached() public view returns (bool) {
617     return weiRaised >= goal;
618   }
619 
620   function getDeposit(address contributor) public view returns(uint256 depositedValue) {
621     return vault.getDeposit(contributor);
622   }
623 
624   function pauseRefund() public onlyOwner {
625   	vault.pause();
626   }
627 
628   function unpauseRefund() public onlyOwner {
629     vault.unpause();
630   }
631 
632   function isRefundPaused() public view returns(bool) {
633     return vault.isRefundPaused();
634   }
635 }
636 
637 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
638 
639 /**
640  * @title Burnable Token
641  * @dev Token that can be irreversibly burned (destroyed).
642  */
643 contract BurnableToken is BasicToken {
644 
645     event Burn(address indexed burner, uint256 value);
646 
647     /**
648      * @dev Burns a specific amount of tokens.
649      * @param _value The amount of token to be burned.
650      */
651     function burn(uint256 _value) public {
652         require(_value <= balances[msg.sender]);
653         // no need to require value <= totalSupply, since that would imply the
654         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
655 
656         address burner = msg.sender;
657         balances[burner] = balances[burner].sub(_value);
658         totalSupply = totalSupply.sub(_value);
659         Burn(burner, _value);
660     }
661 }
662 
663 // File: contracts/SilcToken.sol
664 
665 contract SilcToken is MintableToken, BurnableToken {
666 	string public name = "SILC";
667 	string public symbol = "SILC";
668 	uint8 public decimals = 18;
669 
670 	function burn(address burner, uint256 _value) public onlyOwner {
671 	    require(_value <= balances[burner]);
672 	    // no need to require value <= totalSupply, since that would imply the
673 	    // sender's balance is greater than the totalSupply, which *should* be an assertion failure
674 
675 	    balances[burner] = balances[burner].sub(_value);
676 	    totalSupply = totalSupply.sub(_value);
677 	    Burn(burner, _value);
678 	}
679 
680 }
681 
682 // File: zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol
683 
684 /**
685  * @title CappedCrowdsale
686  * @dev Extension of Crowdsale with a max amount of funds raised
687  */
688 contract CappedCrowdsale is Crowdsale {
689   using SafeMath for uint256;
690 
691   uint256 public cap;
692 
693   function CappedCrowdsale(uint256 _cap) public {
694     require(_cap > 0);
695     cap = _cap;
696   }
697 
698   // overriding Crowdsale#validPurchase to add extra cap logic
699   // @return true if investors can buy at the moment
700   function validPurchase() internal view returns (bool) {
701     bool withinCap = weiRaised.add(msg.value) <= cap;
702     return super.validPurchase() && withinCap;
703   }
704 
705   // overriding Crowdsale#hasEnded to add cap logic
706   // @return true if crowdsale event has ended
707   function hasEnded() public view returns (bool) {
708     bool capReached = weiRaised >= cap;
709     return super.hasEnded() || capReached;
710   }
711 
712 }
713 
714 // File: contracts/SilcCrowdsale.sol
715 
716 contract SilcCrowdsale is CappedCrowdsale, MyRefundableCrowdsale {
717 
718   // Sale Stage
719   // ============
720   enum CrowdsaleStage { phase1, phase2, phase3 }
721   CrowdsaleStage public stage = CrowdsaleStage.phase1; // By default it's Pre Sale
722   // =============
723 
724   // Token Distribution
725   // =============================
726   uint256 public maxTokens = 20000000000000000000000000000;          // 20,000,000,000
727   uint256 public tokensForEcosystem = 3500000000000000000000000000;  //  3,500,000,000
728   uint256 public tokensForTeam = 2500000000000000000000000000;       //  2,500,000,000
729   uint256 public tokensForAdvisory = 1000000000000000000000000000;   //  1,000,000,000
730 
731   uint256 public totalTokensForSale = 3000000000000000000000000000;  // 3,000,000,000 SILC = 30,000 ETH
732   // ==============================
733 
734   // Rate
735   uint256 public rateForPhase1 = 110000;
736   uint256 public rateForPhase2 = 105000;
737   uint256 public rateForPhase3 = 100000;
738 
739   // can be negative, because of refund.
740   // ==================
741   int256 public totalWeiRaisedDuringPhase1;
742   int256 public totalWeiRaisedDuringPhase2;
743   int256 public totalWeiRaisedDuringPhase3;
744   // ===================
745 
746   uint256 public totalTokenSupply;
747 
748   // Events
749   event EthTransferred(string text);
750   event EthRefunded(string text);
751 
752 
753   // Constructor
754   // ============
755   function SilcCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap) 
756     CappedCrowdsale(_cap) 
757     FinalizableCrowdsale() 
758     MyRefundableCrowdsale(_goal) 
759     Crowdsale(_startTime, _endTime, _rate, _wallet) public {
760       require(_goal <= _cap);
761   }
762   // =============
763 
764   // Token Deployment
765   // =================
766   function createTokenContract() internal returns (MintableToken) {
767     return new SilcToken(); // Deploys the ERC20 token. Automatically called when crowdsale contract is deployed
768   }
769   // ==================
770 
771   // Crowdsale Stage Management
772   // =========================================================
773 
774   // Change Crowdsale Stage. Available Options: phase1, phase2
775   function setCrowdsaleStage(uint value) public onlyOwner {
776 
777       CrowdsaleStage _stage;
778 
779       if (uint(CrowdsaleStage.phase1) == value) {
780         _stage = CrowdsaleStage.phase1;
781       } else if (uint(CrowdsaleStage.phase2) == value) {
782         _stage = CrowdsaleStage.phase2;
783       } else if (uint(CrowdsaleStage.phase3) == value) {
784         _stage = CrowdsaleStage.phase3;
785       }
786 
787 
788       stage = _stage;
789 
790       if (stage == CrowdsaleStage.phase1) {
791         setCurrentRate(rateForPhase1);
792       } else if (stage == CrowdsaleStage.phase2) {
793         setCurrentRate(rateForPhase2);
794       } else if (stage == CrowdsaleStage.phase3) {
795         setCurrentRate(rateForPhase3);
796       }
797   }
798 
799   // Change the current rate
800   function setCurrentRate(uint256 _rate) private {
801       rate = _rate;
802   }
803 
804   function calculateWeiForStage(int256 value) {
805       if (stage == CrowdsaleStage.phase1) {
806         totalWeiRaisedDuringPhase1 = totalWeiRaisedDuringPhase1 + value;
807       } else if (stage == CrowdsaleStage.phase2) {
808         totalWeiRaisedDuringPhase2 = totalWeiRaisedDuringPhase2 + value;
809       } else if (stage == CrowdsaleStage.phase3) {
810         totalWeiRaisedDuringPhase3 = totalWeiRaisedDuringPhase3 + value;
811       }
812   }
813 
814   // ================ Stage Management Over =====================
815 
816   // Token Purchase
817   // =========================
818   function () external payable {
819       //uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
820       //if ((stage == CrowdsaleStage.phase1) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringpreSale)) {
821       //  msg.sender.transfer(msg.value); // Refund them
822       //  EthRefunded("phase1 Limit Hit");
823       //  return;
824       //}
825       require(msg.value >= 0.1 ether); // 0.1 ETH
826       buyTokens(msg.sender);
827       totalTokenSupply = token.totalSupply();
828       calculateWeiForStage(int256(msg.value));
829   }
830 
831   mapping (address => uint256) tokenIssued;
832 
833   function buyTokens(address beneficiary) public payable {
834     require(beneficiary != address(0));
835     require(validPurchase());
836 
837     uint256 weiAmount = msg.value;
838 
839     // calculate token amount to be created
840     uint256 tokens = weiAmount.mul(rate);
841 
842     // update state
843     weiRaised = weiRaised.add(weiAmount);
844 
845     token.mint(beneficiary, tokens);
846     tokenIssued[beneficiary] = tokenIssued[beneficiary].add(tokens);
847 
848     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
849 
850     forwardFunds();
851   }
852 
853   function getTokenIssued(address contributor) public view returns (uint256 token) {
854     return tokenIssued[contributor];
855   }
856 
857   function forwardFunds() internal {
858       if (stage == CrowdsaleStage.phase1) {
859           //wallet.transfer(msg.value);
860           //EthTransferred("forwarding funds to wallet");
861           EthTransferred("forwarding funds to refundable vault");
862           super.forwardFunds();
863       } else if (stage == CrowdsaleStage.phase2) {
864           EthTransferred("forwarding funds to refundable vault");
865           super.forwardFunds();
866       } else if (stage == CrowdsaleStage.phase3) {
867           EthTransferred("forwarding funds to refundable vault");
868           super.forwardFunds();
869       }
870   }
871   // ===========================
872 
873   // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
874   // ====================================================================
875 
876   function finish(address _teamFund, address _ecosystemFund, address _advisoryFund) public onlyOwner {
877 
878     require(!isFinalized);
879     uint256 alreadyMinted = token.totalSupply();
880     require(alreadyMinted < maxTokens);
881 
882     uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
883     if (unsoldTokens > 0) {
884       tokensForEcosystem = tokensForEcosystem + unsoldTokens;
885     }
886 
887     token.mint(_teamFund,tokensForTeam);
888     token.mint(_ecosystemFund,tokensForEcosystem);
889     token.mint(_advisoryFund,tokensForAdvisory);
890     finalize();
891   }
892   // ===============================
893 
894   // token functions
895   function mintSilcToken(address _to, uint256 _amount) public onlyOwner {
896     token.mint(_to, _amount);
897   }
898 
899   function transferTokenOwnership(address newOwner) public onlyOwner {
900     token.transferOwnership(newOwner);
901   }
902 
903   function transferVaultOwnership(address newOwner) public onlyOwner {
904     vault.transferOwnership(newOwner);
905   }
906   // ===============================
907 
908   event LogEvent(bytes32 message, uint256 value);
909   event RefundRequestCompleted(address contributor, uint256 weiRefunded, uint256 burnedToken);
910   function refundRequest() public {
911     address contributor = msg.sender;
912     SilcToken silcToken = SilcToken(address(token));
913     uint256 tokenValance = token.balanceOf(contributor);
914     require(tokenValance != 0);
915     require(tokenValance >= tokenIssued[contributor]);
916     //LogEvent("StartBurn", tokenValance);
917     silcToken.burn(contributor, tokenIssued[contributor]);  // burn issued tokens
918     tokenIssued[contributor] = 0;
919     //LogEvent("StartRefund", token.balanceOf(contributor));
920     uint256 weiRefunded = vault.refundWhenNotClosed(contributor);
921     weiRaised = weiRaised.sub(weiRefunded);
922 
923     calculateWeiForStage(int256(weiRefunded) * -1);
924 
925     RefundRequestCompleted(contributor, weiRefunded, tokenValance);
926   }
927 
928   // for testing `finish()` FUNCTION
929   function hasEnded() public view returns (bool) {
930     return true;
931   }
932 }