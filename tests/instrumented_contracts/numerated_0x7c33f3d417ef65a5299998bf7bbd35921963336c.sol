1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.18;
7 
8 
9 /*************************************************************************
10  * import "zeppelin-solidity/contracts/token/TokenTimelock.sol" : start
11  *************************************************************************/
12 
13 
14 /*************************************************************************
15  * import "./ERC20Basic.sol" : start
16  *************************************************************************/
17 
18 
19 /**
20  * @title ERC20Basic
21  * @dev Simpler version of ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/179
23  */
24 contract ERC20Basic {
25   uint256 public totalSupply;
26   function balanceOf(address who) public view returns (uint256);
27   function transfer(address to, uint256 value) public returns (bool);
28   event Transfer(address indexed from, address indexed to, uint256 value);
29 }
30 /*************************************************************************
31  * import "./ERC20Basic.sol" : end
32  *************************************************************************/
33 /*************************************************************************
34  * import "../token/SafeERC20.sol" : start
35  *************************************************************************/
36 
37 
38 /*************************************************************************
39  * import "./ERC20.sol" : start
40  *************************************************************************/
41 
42 
43 
44 
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public view returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 /*************************************************************************
57  * import "./ERC20.sol" : end
58  *************************************************************************/
59 
60 /**
61  * @title SafeERC20
62  * @dev Wrappers around ERC20 operations that throw on failure.
63  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
64  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
65  */
66 library SafeERC20 {
67   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
68     assert(token.transfer(to, value));
69   }
70 
71   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
72     assert(token.transferFrom(from, to, value));
73   }
74 
75   function safeApprove(ERC20 token, address spender, uint256 value) internal {
76     assert(token.approve(spender, value));
77   }
78 }
79 /*************************************************************************
80  * import "../token/SafeERC20.sol" : end
81  *************************************************************************/
82 
83 /**
84  * @title TokenTimelock
85  * @dev TokenTimelock is a token holder contract that will allow a
86  * beneficiary to extract the tokens after a given release time
87  */
88 contract TokenTimelock {
89   using SafeERC20 for ERC20Basic;
90 
91   // ERC20 basic token contract being held
92   ERC20Basic public token;
93 
94   // beneficiary of tokens after they are released
95   address public beneficiary;
96 
97   // timestamp when token release is enabled
98   uint256 public releaseTime;
99 
100   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
101     require(_releaseTime > now);
102     token = _token;
103     beneficiary = _beneficiary;
104     releaseTime = _releaseTime;
105   }
106 
107   /**
108    * @notice Transfers tokens held by timelock to beneficiary.
109    */
110   function release() public {
111     require(now >= releaseTime);
112 
113     uint256 amount = token.balanceOf(this);
114     require(amount > 0);
115 
116     token.safeTransfer(beneficiary, amount);
117   }
118 }
119 /*************************************************************************
120  * import "zeppelin-solidity/contracts/token/TokenTimelock.sol" : end
121  *************************************************************************/
122 /*************************************************************************
123  * import "./FNTRefundableCrowdsale.sol" : start
124  *************************************************************************/
125 
126 /*************************************************************************
127  * import "zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol" : start
128  *************************************************************************/
129 
130 
131 /*************************************************************************
132  * import "../math/SafeMath.sol" : start
133  *************************************************************************/
134 
135 
136 /**
137  * @title SafeMath
138  * @dev Math operations with safety checks that throw on error
139  */
140 library SafeMath {
141   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142     if (a == 0) {
143       return 0;
144     }
145     uint256 c = a * b;
146     assert(c / a == b);
147     return c;
148   }
149 
150   function div(uint256 a, uint256 b) internal pure returns (uint256) {
151     // assert(b > 0); // Solidity automatically throws when dividing by 0
152     uint256 c = a / b;
153     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154     return c;
155   }
156 
157   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158     assert(b <= a);
159     return a - b;
160   }
161 
162   function add(uint256 a, uint256 b) internal pure returns (uint256) {
163     uint256 c = a + b;
164     assert(c >= a);
165     return c;
166   }
167 }
168 /*************************************************************************
169  * import "../math/SafeMath.sol" : end
170  *************************************************************************/
171 /*************************************************************************
172  * import "./FinalizableCrowdsale.sol" : start
173  *************************************************************************/
174 
175 
176 /*************************************************************************
177  * import "../ownership/Ownable.sol" : start
178  *************************************************************************/
179 
180 
181 /**
182  * @title Ownable
183  * @dev The Ownable contract has an owner address, and provides basic authorization control
184  * functions, this simplifies the implementation of "user permissions".
185  */
186 contract Ownable {
187   address public owner;
188 
189 
190   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191 
192 
193   /**
194    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
195    * account.
196    */
197   function Ownable() public {
198     owner = msg.sender;
199   }
200 
201 
202   /**
203    * @dev Throws if called by any account other than the owner.
204    */
205   modifier onlyOwner() {
206     require(msg.sender == owner);
207     _;
208   }
209 
210 
211   /**
212    * @dev Allows the current owner to transfer control of the contract to a newOwner.
213    * @param newOwner The address to transfer ownership to.
214    */
215   function transferOwnership(address newOwner) public onlyOwner {
216     require(newOwner != address(0));
217     OwnershipTransferred(owner, newOwner);
218     owner = newOwner;
219   }
220 
221 }
222 /*************************************************************************
223  * import "../ownership/Ownable.sol" : end
224  *************************************************************************/
225 /*************************************************************************
226  * import "./Crowdsale.sol" : start
227  *************************************************************************/
228 
229 /*************************************************************************
230  * import "../token/MintableToken.sol" : start
231  *************************************************************************/
232 
233 
234 /*************************************************************************
235  * import "./StandardToken.sol" : start
236  *************************************************************************/
237 
238 
239 /*************************************************************************
240  * import "./BasicToken.sol" : start
241  *************************************************************************/
242 
243 
244 
245 
246 
247 
248 /**
249  * @title Basic token
250  * @dev Basic version of StandardToken, with no allowances.
251  */
252 contract BasicToken is ERC20Basic {
253   using SafeMath for uint256;
254 
255   mapping(address => uint256) balances;
256 
257   /**
258   * @dev transfer token for a specified address
259   * @param _to The address to transfer to.
260   * @param _value The amount to be transferred.
261   */
262   function transfer(address _to, uint256 _value) public returns (bool) {
263     require(_to != address(0));
264     require(_value <= balances[msg.sender]);
265 
266     // SafeMath.sub will throw if there is not enough balance.
267     balances[msg.sender] = balances[msg.sender].sub(_value);
268     balances[_to] = balances[_to].add(_value);
269     Transfer(msg.sender, _to, _value);
270     return true;
271   }
272 
273   /**
274   * @dev Gets the balance of the specified address.
275   * @param _owner The address to query the the balance of.
276   * @return An uint256 representing the amount owned by the passed address.
277   */
278   function balanceOf(address _owner) public view returns (uint256 balance) {
279     return balances[_owner];
280   }
281 
282 }
283 /*************************************************************************
284  * import "./BasicToken.sol" : end
285  *************************************************************************/
286 
287 
288 
289 /**
290  * @title Standard ERC20 token
291  *
292  * @dev Implementation of the basic standard token.
293  * @dev https://github.com/ethereum/EIPs/issues/20
294  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
295  */
296 contract StandardToken is ERC20, BasicToken {
297 
298   mapping (address => mapping (address => uint256)) internal allowed;
299 
300 
301   /**
302    * @dev Transfer tokens from one address to another
303    * @param _from address The address which you want to send tokens from
304    * @param _to address The address which you want to transfer to
305    * @param _value uint256 the amount of tokens to be transferred
306    */
307   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
308     require(_to != address(0));
309     require(_value <= balances[_from]);
310     require(_value <= allowed[_from][msg.sender]);
311 
312     balances[_from] = balances[_from].sub(_value);
313     balances[_to] = balances[_to].add(_value);
314     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
315     Transfer(_from, _to, _value);
316     return true;
317   }
318 
319   /**
320    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
321    *
322    * Beware that changing an allowance with this method brings the risk that someone may use both the old
323    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
324    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
325    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
326    * @param _spender The address which will spend the funds.
327    * @param _value The amount of tokens to be spent.
328    */
329   function approve(address _spender, uint256 _value) public returns (bool) {
330     allowed[msg.sender][_spender] = _value;
331     Approval(msg.sender, _spender, _value);
332     return true;
333   }
334 
335   /**
336    * @dev Function to check the amount of tokens that an owner allowed to a spender.
337    * @param _owner address The address which owns the funds.
338    * @param _spender address The address which will spend the funds.
339    * @return A uint256 specifying the amount of tokens still available for the spender.
340    */
341   function allowance(address _owner, address _spender) public view returns (uint256) {
342     return allowed[_owner][_spender];
343   }
344 
345   /**
346    * @dev Increase the amount of tokens that an owner allowed to a spender.
347    *
348    * approve should be called when allowed[_spender] == 0. To increment
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _addedValue The amount of tokens to increase the allowance by.
354    */
355   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
356     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
357     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358     return true;
359   }
360 
361   /**
362    * @dev Decrease the amount of tokens that an owner allowed to a spender.
363    *
364    * approve should be called when allowed[_spender] == 0. To decrement
365    * allowed value is better to use this function to avoid 2 calls (and wait until
366    * the first transaction is mined)
367    * From MonolithDAO Token.sol
368    * @param _spender The address which will spend the funds.
369    * @param _subtractedValue The amount of tokens to decrease the allowance by.
370    */
371   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
372     uint oldValue = allowed[msg.sender][_spender];
373     if (_subtractedValue > oldValue) {
374       allowed[msg.sender][_spender] = 0;
375     } else {
376       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
377     }
378     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
379     return true;
380   }
381 
382 }
383 /*************************************************************************
384  * import "./StandardToken.sol" : end
385  *************************************************************************/
386 
387 
388 
389 
390 /**
391  * @title Mintable token
392  * @dev Simple ERC20 Token example, with mintable token creation
393  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
394  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
395  */
396 
397 contract MintableToken is StandardToken, Ownable {
398   event Mint(address indexed to, uint256 amount);
399   event MintFinished();
400 
401   bool public mintingFinished = false;
402 
403 
404   modifier canMint() {
405     require(!mintingFinished);
406     _;
407   }
408 
409   /**
410    * @dev Function to mint tokens
411    * @param _to The address that will receive the minted tokens.
412    * @param _amount The amount of tokens to mint.
413    * @return A boolean that indicates if the operation was successful.
414    */
415   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
416     totalSupply = totalSupply.add(_amount);
417     balances[_to] = balances[_to].add(_amount);
418     Mint(_to, _amount);
419     Transfer(address(0), _to, _amount);
420     return true;
421   }
422 
423   /**
424    * @dev Function to stop minting new tokens.
425    * @return True if the operation was successful.
426    */
427   function finishMinting() onlyOwner canMint public returns (bool) {
428     mintingFinished = true;
429     MintFinished();
430     return true;
431   }
432 }
433 /*************************************************************************
434  * import "../token/MintableToken.sol" : end
435  *************************************************************************/
436 
437 
438 /**
439  * @title Crowdsale
440  * @dev Crowdsale is a base contract for managing a token crowdsale.
441  * Crowdsales have a start and end timestamps, where investors can make
442  * token purchases and the crowdsale will assign them tokens based
443  * on a token per ETH rate. Funds collected are forwarded to a wallet
444  * as they arrive.
445  */
446 contract Crowdsale {
447   using SafeMath for uint256;
448 
449   // The token being sold
450   MintableToken public token;
451 
452   // start and end timestamps where investments are allowed (both inclusive)
453   uint256 public startTime;
454   uint256 public endTime;
455 
456   // address where funds are collected
457   address public wallet;
458 
459   // how many token units a buyer gets per wei
460   uint256 public rate;
461 
462   // amount of raised money in wei
463   uint256 public weiRaised;
464 
465   /**
466    * event for token purchase logging
467    * @param purchaser who paid for the tokens
468    * @param beneficiary who got the tokens
469    * @param value weis paid for purchase
470    * @param amount amount of tokens purchased
471    */
472   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
473 
474 
475   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
476     require(_startTime >= now);
477     require(_endTime >= _startTime);
478     require(_rate > 0);
479     require(_wallet != address(0));
480 
481     token = createTokenContract();
482     startTime = _startTime;
483     endTime = _endTime;
484     rate = _rate;
485     wallet = _wallet;
486   }
487 
488   // creates the token to be sold.
489   // override this method to have crowdsale of a specific mintable token.
490   function createTokenContract() internal returns (MintableToken) {
491     return new MintableToken();
492   }
493 
494 
495   // fallback function can be used to buy tokens
496   function () external payable {
497     buyTokens(msg.sender);
498   }
499 
500   // low level token purchase function
501   function buyTokens(address beneficiary) public payable {
502     require(beneficiary != address(0));
503     require(validPurchase());
504 
505     uint256 weiAmount = msg.value;
506 
507     // calculate token amount to be created
508     uint256 tokens = weiAmount.mul(rate);
509 
510     // update state
511     weiRaised = weiRaised.add(weiAmount);
512 
513     token.mint(beneficiary, tokens);
514     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
515 
516     forwardFunds();
517   }
518 
519   // send ether to the fund collection wallet
520   // override to create custom fund forwarding mechanisms
521   function forwardFunds() internal {
522     wallet.transfer(msg.value);
523   }
524 
525   // @return true if the transaction can buy tokens
526   function validPurchase() internal view returns (bool) {
527     bool withinPeriod = now >= startTime && now <= endTime;
528     bool nonZeroPurchase = msg.value != 0;
529     return withinPeriod && nonZeroPurchase;
530   }
531 
532   // @return true if crowdsale event has ended
533   function hasEnded() public view returns (bool) {
534     return now > endTime;
535   }
536 
537 
538 }
539 /*************************************************************************
540  * import "./Crowdsale.sol" : end
541  *************************************************************************/
542 
543 /**
544  * @title FinalizableCrowdsale
545  * @dev Extension of Crowdsale where an owner can do extra work
546  * after finishing.
547  */
548 contract FinalizableCrowdsale is Crowdsale, Ownable {
549   using SafeMath for uint256;
550 
551   bool public isFinalized = false;
552 
553   event Finalized();
554 
555   /**
556    * @dev Must be called after crowdsale ends, to do some extra finalization
557    * work. Calls the contract's finalization function.
558    */
559   function finalize() onlyOwner public {
560     require(!isFinalized);
561     require(hasEnded());
562 
563     finalization();
564     Finalized();
565 
566     isFinalized = true;
567   }
568 
569   /**
570    * @dev Can be overridden to add finalization logic. The overriding function
571    * should call super.finalization() to ensure the chain of finalization is
572    * executed entirely.
573    */
574   function finalization() internal {
575   }
576 }
577 /*************************************************************************
578  * import "./FinalizableCrowdsale.sol" : end
579  *************************************************************************/
580 /*************************************************************************
581  * import "./RefundVault.sol" : start
582  *************************************************************************/
583 
584 
585 
586 
587 /**
588  * @title RefundVault
589  * @dev This contract is used for storing funds while a crowdsale
590  * is in progress. Supports refunding the money if crowdsale fails,
591  * and forwarding it if crowdsale is successful.
592  */
593 contract RefundVault is Ownable {
594   using SafeMath for uint256;
595 
596   enum State { Active, Refunding, Closed }
597 
598   mapping (address => uint256) public deposited;
599   address public wallet;
600   State public state;
601 
602   event Closed();
603   event RefundsEnabled();
604   event Refunded(address indexed beneficiary, uint256 weiAmount);
605 
606   function RefundVault(address _wallet) public {
607     require(_wallet != address(0));
608     wallet = _wallet;
609     state = State.Active;
610   }
611 
612   function deposit(address investor) onlyOwner public payable {
613     require(state == State.Active);
614     deposited[investor] = deposited[investor].add(msg.value);
615   }
616 
617   function close() onlyOwner public {
618     require(state == State.Active);
619     state = State.Closed;
620     Closed();
621     wallet.transfer(this.balance);
622   }
623 
624   function enableRefunds() onlyOwner public {
625     require(state == State.Active);
626     state = State.Refunding;
627     RefundsEnabled();
628   }
629 
630   function refund(address investor) public {
631     require(state == State.Refunding);
632     uint256 depositedValue = deposited[investor];
633     deposited[investor] = 0;
634     investor.transfer(depositedValue);
635     Refunded(investor, depositedValue);
636   }
637 }
638 /*************************************************************************
639  * import "./RefundVault.sol" : end
640  *************************************************************************/
641 
642 
643 /**
644  * @title RefundableCrowdsale
645  * @dev Extension of Crowdsale contract that adds a funding goal, and
646  * the possibility of users getting a refund if goal is not met.
647  * Uses a RefundVault as the crowdsale's vault.
648  */
649 contract RefundableCrowdsale is FinalizableCrowdsale {
650   using SafeMath for uint256;
651 
652   // minimum amount of funds to be raised in weis
653   uint256 public goal;
654 
655   // refund vault used to hold funds while crowdsale is running
656   RefundVault public vault;
657 
658   function RefundableCrowdsale(uint256 _goal) public {
659     require(_goal > 0);
660     vault = new RefundVault(wallet);
661     goal = _goal;
662   }
663 
664   // We're overriding the fund forwarding from Crowdsale.
665   // In addition to sending the funds, we want to call
666   // the RefundVault deposit function
667   function forwardFunds() internal {
668     vault.deposit.value(msg.value)(msg.sender);
669   }
670 
671   // if crowdsale is unsuccessful, investors can claim refunds here
672   function claimRefund() public {
673     require(isFinalized);
674     require(!goalReached());
675 
676     vault.refund(msg.sender);
677   }
678 
679   // vault finalization task, called when owner calls finalize()
680   function finalization() internal {
681     if (goalReached()) {
682       vault.close();
683     } else {
684       vault.enableRefunds();
685     }
686 
687     super.finalization();
688   }
689 
690   function goalReached() public view returns (bool) {
691     return weiRaised >= goal;
692   }
693 
694 }
695 /*************************************************************************
696  * import "zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol" : end
697  *************************************************************************/
698 
699 
700 /**
701  * @title FNTRefundableCrowdsale
702  * @dev Extension of teh RefundableCrowdsale form zeppelin to allow vault to be
703  * closed once soft cap is reached
704  */
705 contract FNTRefundableCrowdsale is RefundableCrowdsale {
706 
707   // if the vault was closed before finalization
708   bool public vaultClosed = false;
709 
710   // close vault call
711   function closeVault() public onlyOwner {
712     require(!vaultClosed);
713     require(goalReached());
714     vault.close();
715     vaultClosed = true;
716   }
717 
718   // We're overriding the fund forwarding from Crowdsale.
719   // In addition to sending the funds, we want to call
720   // the RefundVault deposit function if the vault is not closed,
721   // if it is closed we forward teh funds to the wallet
722   function forwardFunds() internal {
723     if (!vaultClosed) {
724       vault.deposit.value(msg.value)(msg.sender);
725     } else {
726       wallet.transfer(msg.value);
727     }
728   }
729 
730   // vault finalization task, called when owner calls finalize()
731   function finalization() internal {
732     if (!vaultClosed && goalReached()) {
733       vault.close();
734       vaultClosed = true;
735     } else if (!goalReached()) {
736       vault.enableRefunds();
737     }
738   }
739 }
740 /*************************************************************************
741  * import "./FNTRefundableCrowdsale.sol" : end
742  *************************************************************************/
743 /*************************************************************************
744  * import "./FNTToken.sol" : start
745  *************************************************************************/
746 
747 
748 /*************************************************************************
749  * import "zeppelin-solidity/contracts/token/BurnableToken.sol" : start
750  *************************************************************************/
751 
752 
753 
754 /**
755  * @title Burnable Token
756  * @dev Token that can be irreversibly burned (destroyed).
757  */
758 contract BurnableToken is BasicToken {
759 
760     event Burn(address indexed burner, uint256 value);
761 
762     /**
763      * @dev Burns a specific amount of tokens.
764      * @param _value The amount of token to be burned.
765      */
766     function burn(uint256 _value) public {
767         require(_value <= balances[msg.sender]);
768         // no need to require value <= totalSupply, since that would imply the
769         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
770 
771         address burner = msg.sender;
772         balances[burner] = balances[burner].sub(_value);
773         totalSupply = totalSupply.sub(_value);
774         Burn(burner, _value);
775     }
776 }
777 /*************************************************************************
778  * import "zeppelin-solidity/contracts/token/BurnableToken.sol" : end
779  *************************************************************************/
780 /*************************************************************************
781  * import "zeppelin-solidity/contracts/token/PausableToken.sol" : start
782  *************************************************************************/
783 
784 
785 /*************************************************************************
786  * import "../lifecycle/Pausable.sol" : start
787  *************************************************************************/
788 
789 
790 
791 
792 
793 /**
794  * @title Pausable
795  * @dev Base contract which allows children to implement an emergency stop mechanism.
796  */
797 contract Pausable is Ownable {
798   event Pause();
799   event Unpause();
800 
801   bool public paused = false;
802 
803 
804   /**
805    * @dev Modifier to make a function callable only when the contract is not paused.
806    */
807   modifier whenNotPaused() {
808     require(!paused);
809     _;
810   }
811 
812   /**
813    * @dev Modifier to make a function callable only when the contract is paused.
814    */
815   modifier whenPaused() {
816     require(paused);
817     _;
818   }
819 
820   /**
821    * @dev called by the owner to pause, triggers stopped state
822    */
823   function pause() onlyOwner whenNotPaused public {
824     paused = true;
825     Pause();
826   }
827 
828   /**
829    * @dev called by the owner to unpause, returns to normal state
830    */
831   function unpause() onlyOwner whenPaused public {
832     paused = false;
833     Unpause();
834   }
835 }
836 /*************************************************************************
837  * import "../lifecycle/Pausable.sol" : end
838  *************************************************************************/
839 
840 /**
841  * @title Pausable token
842  *
843  * @dev StandardToken modified with pausable transfers.
844  **/
845 
846 contract PausableToken is StandardToken, Pausable {
847 
848   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
849     return super.transfer(_to, _value);
850   }
851 
852   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
853     return super.transferFrom(_from, _to, _value);
854   }
855 
856   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
857     return super.approve(_spender, _value);
858   }
859 
860   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
861     return super.increaseApproval(_spender, _addedValue);
862   }
863 
864   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
865     return super.decreaseApproval(_spender, _subtractedValue);
866   }
867 }
868 /*************************************************************************
869  * import "zeppelin-solidity/contracts/token/PausableToken.sol" : end
870  *************************************************************************/
871 
872 /**
873    @title FNTToken, the Friend token
874 
875    Implementation of FRND, the ERC20 token for Friend, with extra methods
876    to transfer value and data to execute a call on transfer.
877    Uses OpenZeppelin BurnableToken, MintableToken and PausableToken.
878  */
879 contract FNTToken is BurnableToken, MintableToken, PausableToken {
880   // Token Name
881   string public constant NAME = "Friend Network Token";
882 
883   // Token Symbol
884   string public constant SYMBOL = "FRND";
885 
886   // Token decimals
887   uint8 public constant DECIMALS = 18;
888 
889 }
890 /*************************************************************************
891  * import "./FNTToken.sol" : end
892  *************************************************************************/
893 
894 /**
895  * @title FNTCrowdsale
896  * @dev The crowdsale of the Firend Token network
897  * The Friend token network will have a max total supply of 2000000000
898  * The minimun cap for the sale is 25000 ETH
899  * The crowdsale is capped in tokens total supply
900  * If the minimun cap is not reached the ETH raised is returned
901  */
902 contract FNTCrowdsale is FNTRefundableCrowdsale {
903 
904   uint256 public maxICOSupply;
905 
906   uint256 public maxTotalSupply;
907 
908   uint256 public minFunding;
909 
910   uint256 public mediumFunding;
911 
912   uint256 public highFunding;
913 
914   uint256 public presaleWei;
915 
916   address public teamAddress;
917 
918   address public FSNASAddress;
919 
920   mapping(address => bool) public whitelist;
921 
922   event WhitelistedAddressAdded(address addr);
923   event WhitelistedAddressRemoved(address addr);
924   event VestedTeamTokens(address first, address second, address thrid, address fourth);
925 
926   /**
927    * @dev Throws if called by any account that's not whitelisted.
928    */
929   modifier onlyWhitelisted() {
930     require(whitelist[msg.sender]);
931     _;
932   }
933 
934   /**
935    * @dev Constructor
936    * Creates a Refundable Crowdsale and set the funding, max supply and addresses
937    * to distribute tokens at the end of the crowdsale.
938    * @param _startTime address, when the crowdsale starts
939    * @param _endTime address, when the crowdsale ends
940    * @param _rate address, crowdsale rate without bonus
941    * @param _minFunding address, soft cap
942    * @param _mediumFunding address, medium funding stage
943    * @param _highFunding address, high funding stage
944    * @param _wallet address, wallet to receive ETH raised
945    * @param _maxTotalSupply address, maximun token supply
946    * @param _teamAddress address, team's address
947    * @param _FSNASAddress address, fsnas address
948    */
949   function FNTCrowdsale(
950     uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _minFunding,
951     uint256 _mediumFunding, uint256 _highFunding, address _wallet,
952     uint256 _maxTotalSupply, address _teamAddress, address _FSNASAddress
953   ) public
954     RefundableCrowdsale(_minFunding)
955     Crowdsale(_startTime, _endTime, _rate, _wallet)
956   {
957     require(_maxTotalSupply > 0);
958     require(_minFunding > 0);
959     require(_mediumFunding > _minFunding);
960     require(_highFunding > _mediumFunding);
961     require(_teamAddress != address(0));
962     require(_FSNASAddress != address(0));
963     minFunding = _minFunding;
964     mediumFunding = _mediumFunding;
965     highFunding = _highFunding;
966     maxTotalSupply = _maxTotalSupply;
967     maxICOSupply = maxTotalSupply.mul(82).div(100);
968     teamAddress = _teamAddress;
969     FSNASAddress = _FSNASAddress;
970     FNTToken(token).pause();
971   }
972 
973   // Internal function that returns a MintableToken, FNTToken is mintable
974   function createTokenContract() internal returns (MintableToken) {
975     return new FNTToken();
976   }
977 
978   /**
979    * @dev Buy tokens fallback function, overrides zeppelin buyTokens function
980    * @param beneficiary address, the address that will receive the tokens
981    *
982    * ONLY send from a ERC20 compatible wallet like myetherwallet.com
983    *
984    */
985   function buyTokens(address beneficiary) public onlyWhitelisted payable {
986     require(beneficiary != address(0));
987     require(validPurchase());
988 
989     uint256 weiAmount = msg.value;
990 
991     // calculate token amount to be created
992     uint256 tokens = 0;
993     if (weiRaised < minFunding) {
994 
995       // If the weiRaised go from less than min funding to more than high funding
996       if (weiRaised.add(weiAmount) > highFunding) {
997         tokens = minFunding.sub(weiRaised)
998           .mul(rate).mul(115).div(100);
999         tokens = tokens.add(
1000           mediumFunding.sub(minFunding).mul(rate).mul(110).div(100)
1001         );
1002         tokens = tokens.add(
1003           highFunding.sub(mediumFunding).mul(rate).mul(105).div(100)
1004         );
1005         tokens = tokens.add(
1006           weiRaised.add(weiAmount).sub(highFunding).mul(rate)
1007         );
1008 
1009       // If the weiRaised go from less than min funding to more than medium funding
1010       } else if (weiRaised.add(weiAmount) > mediumFunding) {
1011         tokens = minFunding.sub(weiRaised)
1012           .mul(rate).mul(115).div(100);
1013         tokens = tokens.add(
1014           mediumFunding.sub(minFunding).mul(rate).mul(110).div(100)
1015         );
1016         tokens = tokens.add(
1017           weiRaised.add(weiAmount).sub(mediumFunding).mul(rate).mul(105).div(100)
1018         );
1019 
1020       // If the weiRaised go from less than min funding to more than min funding
1021       // but less than medium
1022       } else if (weiRaised.add(weiAmount) > minFunding) {
1023         tokens = minFunding.sub(weiRaised)
1024           .mul(rate).mul(115).div(100);
1025         tokens = tokens.add(
1026           weiRaised.add(weiAmount).sub(minFunding).mul(rate).mul(110).div(100)
1027         );
1028 
1029       // If the weiRaised still continues being less than min funding
1030       } else {
1031         tokens = weiAmount.mul(rate).mul(115).div(100);
1032       }
1033 
1034     } else if ((weiRaised >= minFunding) && (weiRaised < mediumFunding)) {
1035 
1036       // If the weiRaised go from more than min funding and less than min funding
1037       // to more than high funding
1038       if (weiRaised.add(weiAmount) > highFunding) {
1039         tokens = mediumFunding.sub(weiRaised)
1040           .mul(rate).mul(110).div(100);
1041         tokens = tokens.add(
1042           highFunding.sub(mediumFunding).mul(rate).mul(105).div(100)
1043         );
1044         tokens = tokens.add(
1045           weiRaised.add(weiAmount).sub(highFunding).mul(rate)
1046         );
1047 
1048       // If the weiRaised go from more than min funding and less than min funding
1049       // to more than medium funding
1050       } else if (weiRaised.add(weiAmount) > mediumFunding) {
1051         tokens = mediumFunding.sub(weiRaised)
1052           .mul(rate).mul(110).div(100);
1053         tokens = tokens.add(
1054           weiRaised.add(weiAmount).sub(mediumFunding).mul(rate).mul(105).div(100)
1055         );
1056 
1057       // If the weiRaised still continues being less than medium funding
1058       } else {
1059         tokens = weiAmount.mul(rate).mul(110).div(100);
1060       }
1061 
1062     } else if ((weiRaised >= mediumFunding) && (weiRaised < highFunding)) {
1063 
1064       // If the weiRaised go from more than medium funding and less than high funding
1065       // to more than high funding
1066       if (weiRaised.add(weiAmount) > highFunding) {
1067         tokens = highFunding.sub(weiRaised)
1068           .mul(rate).mul(105).div(100);
1069         tokens = tokens.add(
1070           weiRaised.add(weiAmount).sub(highFunding).mul(rate)
1071         );
1072 
1073       // If the weiRaised still continues being less than high funding
1074       } else {
1075         tokens = weiAmount.mul(rate).mul(105).div(100);
1076       }
1077 
1078     // If the weiRaised still continues being more than high funding
1079     } else {
1080       tokens = weiAmount.mul(rate);
1081     }
1082 
1083     // Check not to sold more than maxICOSupply
1084     require(token.totalSupply().add(tokens) <= maxICOSupply);
1085 
1086     // Take in count wei received
1087     weiRaised = weiRaised.add(weiAmount);
1088 
1089     // Mint the token to the buyer
1090     token.mint(beneficiary, tokens);
1091     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
1092 
1093     // Forward funds to vault
1094     forwardFunds();
1095   }
1096 
1097   /**
1098    * @dev Distribute tokens to a batch of addresses, called only by owner
1099    * @param addrs address[], the addresses where tokens will be issued
1100    * @param values uint256[], the value in wei to be added
1101    * @param rate uint256, the rate of tokens per ETH used
1102    */
1103   function addPresaleTokens(
1104     address[] addrs, uint256[] values, uint256 rate
1105   ) onlyOwner external {
1106     require(now < endTime);
1107     require(addrs.length == values.length);
1108     require(rate > 0);
1109 
1110     uint256 totalTokens = 0;
1111 
1112     for(uint256 i = 0; i < addrs.length; i ++) {
1113       token.mint(addrs[i], values[i].mul(rate));
1114       totalTokens = totalTokens.add(values[i].mul(rate));
1115 
1116       // Take in count wei received
1117       weiRaised = weiRaised.add(values[i]);
1118       presaleWei = presaleWei.add(values[i]);
1119     }
1120 
1121     // Check not to issue more than maxICOSupply
1122     require(token.totalSupply() <= maxICOSupply);
1123   }
1124 
1125   /**
1126    * @dev add an address to the whitelist
1127    * @param addrs address[] addresses to be added in whitelist
1128    */
1129   function addToWhitelist(address[] addrs) onlyOwner external {
1130     for(uint256 i = 0; i < addrs.length; i ++) {
1131       require(!whitelist[addrs[i]]);
1132       whitelist[addrs[i]] = true;
1133       WhitelistedAddressAdded(addrs[i]);
1134     }
1135   }
1136 
1137   /**
1138    * @dev remove an address from the whitelist
1139    * @param addrs address[] addresses to be removed from whitelist
1140    */
1141   function removeFromWhitelist(address[] addrs) onlyOwner public {
1142     for(uint256 i = 0; i < addrs.length; i ++) {
1143       require(whitelist[addrs[i]]);
1144       whitelist[addrs[i]] = false;
1145       WhitelistedAddressRemoved(addrs[i]);
1146     }
1147   }
1148 
1149 
1150   /**
1151    * @dev Must be called after crowdsale ends, to do some extra finalization
1152    * work. Calls the contract's finalization function.
1153    */
1154   function finalize() onlyOwner public {
1155     require(!isFinalized);
1156     
1157     if( goalReached() )
1158     {
1159 	    finalization();
1160 	    Finalized();
1161 	
1162 	    isFinalized = true;
1163     }
1164 	else
1165 	{
1166 		if( hasEnded() )
1167 		{
1168 		    vault.enableRefunds();
1169 		    
1170 		    Finalized();
1171 		    isFinalized = true;
1172 		}
1173 	}    
1174   }
1175 
1176   /**
1177    * @dev Finalize the crowdsale and token minting, and transfer ownership of
1178    * the token, can be called only by owner
1179    */
1180   function finalization() internal {
1181     super.finalization();
1182 
1183     // Multiplying tokens sold by 0,219512195122
1184     // 18 / 82 = 0,219512195122 , which means that for every token sold in ICO
1185     // 0,219512195122 extra tokens will be issued.
1186     uint256 extraTokens = token.totalSupply().mul(219512195122).div(1000000000000);
1187     uint256 teamTokens = extraTokens.div(3);
1188     uint256 FSNASTokens = extraTokens.div(3).mul(2);
1189 
1190     // Mint toke time locks to team
1191     TokenTimelock firstBatch = new TokenTimelock(token, teamAddress, now.add(30 days));
1192     token.mint(firstBatch, teamTokens.div(2));
1193 
1194     TokenTimelock secondBatch = new TokenTimelock(token, teamAddress, now.add(1 years));
1195     token.mint(secondBatch, teamTokens.div(2).div(3));
1196 
1197     TokenTimelock thirdBatch = new TokenTimelock(token, teamAddress, now.add(2 years));
1198     token.mint(thirdBatch, teamTokens.div(2).div(3));
1199 
1200     TokenTimelock fourthBatch = new TokenTimelock(token, teamAddress, now.add(3 years));
1201     token.mint(fourthBatch, teamTokens.div(2).div(3));
1202 
1203     VestedTeamTokens(firstBatch, secondBatch, thirdBatch, fourthBatch);
1204 
1205     // Mint FSNAS tokens
1206     token.mint(FSNASAddress, FSNASTokens);
1207 
1208     // Finsih the minting
1209     token.finishMinting();
1210 
1211     // Transfer ownership of token to company wallet
1212     token.transferOwnership(wallet);
1213 
1214   }
1215 
1216 }