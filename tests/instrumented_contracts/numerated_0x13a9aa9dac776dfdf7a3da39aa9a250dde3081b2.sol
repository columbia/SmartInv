1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 
81 
82 /**
83  * @title ERC20Basic
84  * @dev Simpler version of ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/179
86  */
87 contract ERC20Basic {
88   uint256 public totalSupply;
89   function balanceOf(address who) public view returns (uint256);
90   function transfer(address to, uint256 value) public returns (bool);
91   event Transfer(address indexed from, address indexed to, uint256 value);
92 }
93 
94 
95 
96 
97 
98 
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender) public view returns (uint256);
105   function transferFrom(address from, address to, uint256 value) public returns (bool);
106   function approve(address spender, uint256 value) public returns (bool);
107   event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 
112 
113 
114 
115 
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances.
119  */
120 contract BasicToken is ERC20Basic {
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124 
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value) public returns (bool) {
131     require(_to != address(0));
132     require(_value <= balances[msg.sender]);
133 
134     // SafeMath.sub will throw if there is not enough balance.
135     balances[msg.sender] = balances[msg.sender].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     Transfer(msg.sender, _to, _value);
138     return true;
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param _owner The address to query the the balance of.
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address _owner) public view returns (uint256 balance) {
147     return balances[_owner];
148   }
149 
150 }
151 
152 
153 
154 
155 
156 
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    *
191    * Beware that changing an allowance with this method brings the risk that someone may use both the old
192    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195    * @param _spender The address which will spend the funds.
196    * @param _value The amount of tokens to be spent.
197    */
198   function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210   function allowance(address _owner, address _spender) public view returns (uint256) {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * @dev Increase the amount of tokens that an owner allowed to a spender.
216    *
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    *
233    * approve should be called when allowed[_spender] == 0. To decrement
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _subtractedValue The amount of tokens to decrease the allowance by.
239    */
240   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241     uint oldValue = allowed[msg.sender][_spender];
242     if (_subtractedValue > oldValue) {
243       allowed[msg.sender][_spender] = 0;
244     } else {
245       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246     }
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251 }
252 
253 
254 
255 
256 
257 
258 /**
259  * @title Mintable token
260  * @dev Simple ERC20 Token example, with mintable token creation
261  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
262  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
263  */
264 
265 contract MintableToken is StandardToken, Ownable {
266   event Mint(address indexed to, uint256 amount);
267   event MintFinished();
268 
269   bool public mintingFinished = false;
270 
271 
272   modifier canMint() {
273     require(!mintingFinished);
274     _;
275   }
276 
277   /**
278    * @dev Function to mint tokens
279    * @param _to The address that will receive the minted tokens.
280    * @param _amount The amount of tokens to mint.
281    * @return A boolean that indicates if the operation was successful.
282    */
283   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
284     totalSupply = totalSupply.add(_amount);
285     balances[_to] = balances[_to].add(_amount);
286     Mint(_to, _amount);
287     Transfer(address(0), _to, _amount);
288     return true;
289   }
290 
291   /**
292    * @dev Function to stop minting new tokens.
293    * @return True if the operation was successful.
294    */
295   function finishMinting() onlyOwner canMint public returns (bool) {
296     mintingFinished = true;
297     MintFinished();
298     return true;
299   }
300 }
301 
302 
303 /**
304  * @title Capped token
305  * @dev Mintable token with a token cap.
306  */
307 
308 contract CappedToken is MintableToken {
309 
310   uint256 public cap;
311 
312   function CappedToken(uint256 _cap) public {
313     require(_cap > 0);
314     cap = _cap;
315   }
316 
317   /**
318    * @dev Function to mint tokens
319    * @param _to The address that will receive the minted tokens.
320    * @param _amount The amount of tokens to mint.
321    * @return A boolean that indicates if the operation was successful.
322    */
323   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
324     require(totalSupply.add(_amount) <= cap);
325 
326     return super.mint(_to, _amount);
327   }
328 
329 }
330 
331 
332 
333 
334 
335 /**
336  * @title Burnable Token
337  * @dev Token that can be irreversibly burned (destroyed).
338  */
339 contract BurnableToken is BasicToken {
340 
341     event Burn(address indexed burner, uint256 value);
342 
343     /**
344      * @dev Burns a specific amount of tokens.
345      * @param _value The amount of token to be burned.
346      */
347     function burn(uint256 _value) public {
348         require(_value <= balances[msg.sender]);
349         // no need to require value <= totalSupply, since that would imply the
350         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
351 
352         address burner = msg.sender;
353         balances[burner] = balances[burner].sub(_value);
354         totalSupply = totalSupply.sub(_value);
355         Burn(burner, _value);
356     }
357 }
358 
359 /**
360  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
361  *
362  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
363  */
364 
365 
366 
367 
368 
369 
370 
371 /**
372  * Define interface for releasing the token transfer after a successful crowdsale.
373  */
374 contract ReleasableToken is ERC20, Ownable {
375 
376   /* The finalizer contract that allows unlift the transfer limits on this token */
377   address public releaseAgent;
378 
379   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
380   bool public released = false;
381 
382   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
383   mapping (address => bool) public transferAgents;
384 
385   /**
386    * Limit token transfer until the crowdsale is over.
387    *
388    */
389   modifier canTransfer(address _sender) {
390     if (!released) {
391       require(transferAgents[_sender]);
392     }
393 
394     _;
395   }
396 
397   /**
398    * Set the contract that can call release and make the token transferable.
399    *
400    * Design choice. Allow reset the release agent to fix fat finger mistakes.
401    */
402   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
403 
404     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
405     releaseAgent = addr;
406   }
407 
408   /**
409    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
410    */
411   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
412     transferAgents[addr] = state;
413   }
414 
415   /**
416    * One way function to release the tokens to the wild.
417    *
418    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
419    */
420   function releaseTokenTransfer() public onlyReleaseAgent {
421     released = true;
422   }
423 
424   /** The function can be called only before or after the tokens have been released */
425   modifier inReleaseState(bool releaseState) {
426     require(releaseState == released);
427     _;
428   }
429 
430   /** The function can be called only by a whitelisted release agent. */
431   modifier onlyReleaseAgent() {
432     require(msg.sender == releaseAgent);
433     _;
434   }
435 
436   function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
437     // Call StandardToken.transfer()
438     return super.transfer(_to, _value);
439   }
440 
441   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
442     // Call StandardToken.transferForm()
443     return super.transferFrom(_from, _to, _value);
444   }
445 
446 }
447 
448 
449 contract BDXCoin is BurnableToken, CappedToken, ReleasableToken {
450   string public constant name = "BDXCoin";
451   string public constant symbol = "BDX";
452   uint8 public constant decimals = 18;
453 
454   function BDXCoin() public
455     CappedToken(200000000 * (10 ** uint256(decimals)))
456   {
457     // Allocate For ICO
458     mint(msg.sender, 90000000 * (10 ** uint256(decimals)));
459     setReleaseAgent(msg.sender);
460     setTransferAgent(msg.sender, true);
461   }
462 }
463 
464 
465 
466 contract RateOracle {
467 
468   address public owner;
469   uint public rate;
470   uint256 public lastUpdateTime;
471 
472   function RateOracle() public {
473     owner = msg.sender;
474   }
475 
476   function setRate(uint _rateCents) public {
477     require(msg.sender == owner);
478     require(_rateCents > 100);
479     rate = _rateCents;
480     lastUpdateTime = now;
481   }
482 
483 }
484 
485 
486 
487 
488 
489 
490 
491 
492 
493 
494 
495 
496 /**
497  * @title Crowdsale
498  * @dev Crowdsale is a base contract for managing a token crowdsale.
499  * Crowdsales have a start and end timestamps, where investors can make
500  * token purchases and the crowdsale will assign them tokens based
501  * on a token per ETH rate. Funds collected are forwarded to a wallet
502  * as they arrive.
503  */
504 contract Crowdsale {
505   using SafeMath for uint256;
506 
507   // The token being sold
508   StandardToken public token;
509 
510   // start and end timestamps where investments are allowed (both inclusive)
511   uint256 public startTime;
512   uint256 public endTime;
513 
514   // address where funds are collected
515   address public wallet;
516 
517   // how many token units a buyer gets per wei
518   uint256 public rate;
519 
520   //Total Sales
521   uint256 public totalSalesEurCents;
522 
523   /**
524    * event for token purchase logging
525    * @param purchaser who paid for the tokens
526    * @param beneficiary who got the tokens
527    * @param value weis paid for purchase
528    * @param amount amount of tokens purchased
529    */
530   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
531 
532 
533   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, StandardToken _token) public {
534     require(_endTime >= _startTime);
535     require(_rate > 0);
536     require(_wallet != address(0));
537     require(_token != address(0));
538 
539     token = _token;
540     startTime = _startTime;
541     endTime = _endTime;
542     rate = _rate;
543     wallet = _wallet;
544   }
545 
546 
547   // fallback function can be used to buy tokens
548   function () external payable {
549     buyTokens(msg.sender);
550   }
551 
552   // abstract token purchase function
553   function buyTokens(address beneficiary) public payable;
554 
555   // send ether to the fund collection wallet
556   // override to create custom fund forwarding mechanisms
557   function forwardFunds() internal {
558     wallet.transfer(msg.value);
559   }
560 
561   // @return true if the transaction can buy tokens
562   function validPurchase() internal view returns (bool) {
563     bool withinPeriod = now >= startTime && now <= endTime;
564     bool nonZeroPurchase = msg.value != 0;
565     return withinPeriod && nonZeroPurchase;
566   }
567 
568   // @return true if crowdsale event has ended
569   function hasEnded() public view returns (bool) {
570     return now > endTime;
571   }
572 
573 
574 }
575 
576 
577 
578 
579 
580 
581 
582 
583 
584 
585 
586 
587 
588 /**
589  * @title FinalizableCrowdsale
590  * @dev Extension of Crowdsale where an owner can do extra work
591  * after finishing.
592  */
593 
594 
595 contract FinalizableCrowdsale is Crowdsale, Ownable {
596   using SafeMath for uint256;
597 
598   bool public isFinalized = false;
599 
600   event Finalized();
601 
602   /**
603    * @dev Must be called after crowdsale ends, to do some extra finalization
604    * work. Calls the contract's finalization function.
605    */
606   function finalize() onlyOwner public {
607     require(!isFinalized);
608     require(hasEnded());
609 
610     finalization();
611     Finalized();
612 
613     isFinalized = true;
614   }
615 
616   /**
617    * @dev Can be overridden to add finalization logic. The overriding function
618    * should call super.finalization() to ensure the chain of finalization is
619    * executed entirely.
620    */
621   function finalization() internal {
622   }
623 }
624 
625 
626 
627 
628 
629 
630 /**
631  * @title RefundVault
632  * @dev This contract is used for storing funds while a crowdsale
633  * is in progress. Supports refunding the money if crowdsale fails,
634  * and forwarding it if crowdsale is successful.
635  */
636 
637 
638 contract RefundVault is Ownable {
639   using SafeMath for uint256;
640 
641   enum State { Active, Refunding, Closed }
642 
643   mapping (address => uint256) public deposited;
644   address public wallet;
645   State public state;
646 
647   event Closed();
648   event RefundsEnabled();
649   event Refunded(address indexed beneficiary, uint256 weiAmount);
650 
651   function RefundVault(address _wallet) public {
652     require(_wallet != address(0));
653     wallet = _wallet;
654     state = State.Active;
655   }
656 
657   function deposit(address investor) onlyOwner public payable {
658     require(state == State.Active);
659     deposited[investor] = deposited[investor].add(msg.value);
660   }
661 
662   function close() onlyOwner public {
663     require(state == State.Active);
664     state = State.Closed;
665     Closed();
666     wallet.transfer(this.balance);
667   }
668 
669   function enableRefunds() onlyOwner public {
670     require(state == State.Active);
671     state = State.Refunding;
672     RefundsEnabled();
673   }
674 
675   function refund(address investor) public {
676     require(state == State.Refunding);
677     uint256 depositedValue = deposited[investor];
678     deposited[investor] = 0;
679     investor.transfer(depositedValue);
680     Refunded(investor, depositedValue);
681   }
682 }
683 
684 
685 
686 /**
687  * @title RefundableCrowdsale
688  * @dev Extension of Crowdsale contract that adds a funding goal, and
689  * the possibility of users getting a refund if goal is not met.
690  * Uses a RefundVault as the crowdsale's vault.
691  */
692 
693 
694 contract RefundableCrowdsale is FinalizableCrowdsale {
695   using SafeMath for uint256;
696 
697   // minimum amount of funds to be raised in weis
698   uint256 public goal;
699 
700   // refund vault used to hold funds while crowdsale is running
701   RefundVault public vault;
702 
703   function RefundableCrowdsale(uint256 _goal) public {
704     require(_goal > 0);
705     vault = new RefundVault(wallet);
706     goal = _goal;
707   }
708 
709   // We're overriding the fund forwarding from Crowdsale.
710   // In addition to sending the funds, we want to call
711   // the RefundVault deposit function
712   function forwardFunds() internal {
713     vault.deposit.value(msg.value)(msg.sender);
714   }
715 
716   // if crowdsale is unsuccessful, investors can claim refunds here
717   function claimRefund() public {
718     require(isFinalized);
719     require(!goalReached());
720 
721     vault.refund(msg.sender);
722   }
723 
724   // vault finalization task, called when owner calls finalize()
725   function finalization() internal {
726     if (goalReached()) {
727       vault.close();
728     } else {
729       vault.enableRefunds();
730     }
731 
732     super.finalization();
733   }
734 
735   function goalReached() public view returns (bool) {
736     return totalSalesEurCents >= goal;
737   }
738 
739 }
740 
741 
742 
743 
744 
745 
746 
747 /**
748  * @title BDXVault For holding Tokens Distribution To Pre-Investors
749  */
750 
751 
752 contract BDXVault is Ownable {
753   using SafeMath for uint256;
754 
755   address public tokenAddress;
756   mapping (address => uint256) public creditedList;
757   event Credited(address indexed investor, uint256 tokens);
758 
759   function BDXVault(address _tokenAddress) public {
760     tokenAddress = _tokenAddress;
761   }
762 
763   function credit(address investor, uint256 tokens) onlyOwner public {
764     require(creditedList[investor] == 0);
765     creditedList[investor] = creditedList[investor].add(tokens);
766     BDXCoin token = BDXCoin(tokenAddress);
767     token.transfer(investor, tokens);
768     Credited(investor, tokens);
769   }
770 
771 }
772 
773 
774 
775 contract BDXCrowdsale is RefundableCrowdsale {
776 
777   uint256[3] public icoStartTimes;
778   uint256[3] public icoEndTimes;
779   uint256[3] public icoRates;
780   uint256[3] public icoCaps;
781   uint256[2] public icoVestingTimes;
782   uint256[2] public icoVestingTokens;
783   uint256 public nextVestingStage = 0;
784   uint256 public bizDevTokenAllocation;
785   address public bizDevWalletAddress;
786   uint256 public marketingTokenAllocation;
787   address public marketingWalletAddress;
788   bool public contractInitialized = false;
789   uint public constant MINIMUM_PURCHASE_EUR_CENT = 1900;
790   mapping(uint256 => uint256) public totalTokensByStage;
791   mapping(address => uint256) public unsoldTokensBeneficiaries;
792   bool public refundingComplete = false;
793   uint256 public refundingIndex = 0;
794   mapping(address => uint256) public directInvestors;
795   address[] private directInvestorsCollection;
796   address public rateOracleAddress;
797   address public preInvestorsTokenVaultAddress;
798   uint256 public preInvestorsTokenAllocation;
799 
800   function BDXCrowdsale(
801     uint256[3] _icoStartTimes,
802     uint256[3] _icoEndTimes,
803     uint256[3] _icoRates,
804     uint256[3] _icoCaps,
805     uint256[2] _icoVestingTimes,
806     uint256[2] _icoVestingTokens,
807     address _wallet,
808     uint256 _goal,
809     uint256 _bizDevTokenAllocation,
810     address _bizDevWalletAddress,
811     uint256 _marketingTokenAllocation,
812     address _marketingWalletAddress,
813     address _rateOracleAddress,
814     uint256 _preInvestorsTokenAllocation
815     ) public
816     Crowdsale(_icoStartTimes[0], _icoEndTimes[2], _icoRates[0], _wallet, new BDXCoin())
817     RefundableCrowdsale(_goal)
818   {
819     require((_icoCaps[0] > 0) && (_icoCaps[1] > 0) && (_icoCaps[2] > 0));
820     require((_icoRates[0] > 0) && (_icoRates[1] > 0) && (_icoRates[2] > 0));
821     require((_icoEndTimes[0] > _icoStartTimes[0]) && (_icoEndTimes[1] > _icoStartTimes[1]) && (_icoEndTimes[2] > _icoStartTimes[2]));
822     require((_icoStartTimes[1] >= _icoEndTimes[0]) && (_icoStartTimes[2] >= _icoEndTimes[1]));
823     require(_bizDevWalletAddress != owner && _wallet != _bizDevWalletAddress);
824     require(_marketingWalletAddress != owner && _wallet != _marketingWalletAddress);
825     icoStartTimes = _icoStartTimes;
826     icoEndTimes = _icoEndTimes;
827     icoRates = _icoRates;
828     icoCaps = _icoCaps;
829     icoVestingTimes = _icoVestingTimes;
830     icoVestingTokens = _icoVestingTokens;
831     bizDevTokenAllocation = _bizDevTokenAllocation;
832     bizDevWalletAddress = _bizDevWalletAddress;
833     marketingTokenAllocation = _marketingTokenAllocation;
834     marketingWalletAddress = _marketingWalletAddress;
835     rateOracleAddress = _rateOracleAddress;
836     preInvestorsTokenAllocation = _preInvestorsTokenAllocation;
837   }
838 
839   // fallback function can be used to buy tokens
840   function () external payable {
841     require(contractInitialized);
842     buyTokens(msg.sender);
843   }
844 
845   function initializeContract() public onlyOwner {
846     require(!contractInitialized);
847     preInvestorsTokenVaultAddress = new BDXVault(token);
848     BDXCoin bdxcoin = BDXCoin(token);
849     bdxcoin.mint(bizDevWalletAddress, toBDXWEI(bizDevTokenAllocation));
850     bdxcoin.mint(marketingWalletAddress, toBDXWEI(marketingTokenAllocation));
851     bdxcoin.mint(preInvestorsTokenVaultAddress, toBDXWEI(preInvestorsTokenAllocation));
852     bdxcoin.setTransferAgent(bizDevWalletAddress, true);
853     bdxcoin.setTransferAgent(marketingWalletAddress, true);
854     bdxcoin.setTransferAgent(preInvestorsTokenVaultAddress, true);
855     contractInitialized = true;
856   }
857 
858 
859   function vestTokens() public onlyOwner {
860     require(isFinalized);
861     require(goalReached());
862     require(nextVestingStage <= 1);
863     require(now > icoVestingTimes[nextVestingStage]);
864     BDXCoin bdxcoin = BDXCoin(token);
865     bdxcoin.mint(bizDevWalletAddress, toBDXWEI(icoVestingTokens[nextVestingStage]));
866     nextVestingStage = nextVestingStage + 1;
867   }
868 
869   // For Allocating Presold and Sale Via Fiat Deposits
870   function allocateTokens(address beneficiary, uint256 tokensWithDecimals, uint256 stage, uint256 rateEurCents, bool isPreSold) public onlyOwner {
871     require(stage <= 2);
872     uint256 saleAmountEurCents = (tokensWithDecimals.mul(rateEurCents)).div(10**18);
873     totalSalesEurCents = totalSalesEurCents.add(saleAmountEurCents);
874     if (!isPreSold && saleAmountEurCents > 0) {
875       totalTokensByStage[stage] = totalTokensByStage[stage].add(tokensWithDecimals);
876     }
877     if (isPreSold) {
878       BDXVault preInvestorsTokenVault = BDXVault(preInvestorsTokenVaultAddress);
879       preInvestorsTokenVault.credit(beneficiary, tokensWithDecimals);
880     } else {
881       token.transfer(beneficiary, tokensWithDecimals);
882     }
883   }
884 
885   function allocateUnsoldTokens(address beneficiary, uint256 tokensWithDecimals) public onlyOwner {
886     require(isFinalized);
887     require(goalReached());
888     require(unsoldTokensBeneficiaries[beneficiary] == 0);
889     unsoldTokensBeneficiaries[beneficiary] = unsoldTokensBeneficiaries[beneficiary].add(tokensWithDecimals);
890     token.transfer(beneficiary, tokensWithDecimals);
891   }
892 
893   //Override
894   function buyTokens(address beneficiary) public payable {
895     require(contractInitialized);
896     require(beneficiary != address(0));
897     require(validPurchase());
898     RateOracle rateOracle = RateOracle(rateOracleAddress);
899     uint ethEurXRate = rateOracle.rate();
900     require(ethEurXRate > 0);
901     uint256 currTime = now;
902     uint256 stageCap = getStageCap(currTime);
903     rate = getTokenRate(currTime);
904     uint256 stage = getStage(currTime);
905     uint256 weiAmount = msg.value;
906     uint256 eurCentAmount = (weiAmount.mul(ethEurXRate)).div(10**18);
907 
908     require(eurCentAmount > MINIMUM_PURCHASE_EUR_CENT);
909 
910     uint256 tokenToGet = (weiAmount.mul(ethEurXRate)).div(rate);
911 
912     if (totalTokensByStage[stage].add(tokenToGet) > stageCap) {
913       stage = stage + 1;
914       rate = getRateByStage(stage);
915       tokenToGet = (weiAmount.mul(ethEurXRate)).div(rate);
916     }
917 
918     totalTokensByStage[stage] = totalTokensByStage[stage].add(tokenToGet);
919 
920     if (directInvestors[beneficiary] == 0) {
921       directInvestorsCollection.push(beneficiary);
922     }
923 
924     directInvestors[beneficiary] = directInvestors[beneficiary].add(tokenToGet);
925     totalSalesEurCents = totalSalesEurCents.add(eurCentAmount);
926     token.transfer(beneficiary, tokenToGet);
927     TokenPurchase(msg.sender, beneficiary, weiAmount, tokenToGet);
928     forwardFunds();
929   }
930 
931   function ethToEurXRate() public view returns (uint) {
932     RateOracle rateOracle = RateOracle(rateOracleAddress);
933     return rateOracle.rate();
934   }
935 
936   //Override
937   function goalReached() public view returns (bool) {
938     return totalSalesEurCents >= goal;
939   }
940 
941   function refundInvestors() public onlyOwner {
942     require(isFinalized);
943     require(!goalReached());
944     require(!refundingComplete);
945     for (uint256 i = 0; i < 20; i++) {
946       if (refundingIndex >= directInvestorsCollection.length) {
947         refundingComplete = true;
948         break;
949       }
950       vault.refund(directInvestorsCollection[refundingIndex]);
951       refundingIndex = refundingIndex.add(1);
952     }
953   }
954 
955   function advanceEndTime(uint256 newEndTime) public onlyOwner {
956     require(!isFinalized);
957     require(newEndTime > endTime);
958     endTime = newEndTime;
959   }
960 
961   function getTokenRate(uint256 currTime) public view returns (uint256) {
962     return getRateByStage(getStage(currTime));
963   }
964 
965   function getStageCap(uint256 currTime) public view returns (uint256) {
966     uint256 additionalTokensFromPreviousStage = 0;
967     if (getStage(currTime) == 2) {
968       additionalTokensFromPreviousStage = additionalTokensFromPreviousStage.add(getCapByStage(1) - totalTokensByStage[1]);
969       additionalTokensFromPreviousStage = additionalTokensFromPreviousStage.add(getCapByStage(0) - totalTokensByStage[0]);
970     } else if (getStage(currTime) == 1) {
971       additionalTokensFromPreviousStage = additionalTokensFromPreviousStage.add(getCapByStage(0) - totalTokensByStage[0]);
972     }
973     return additionalTokensFromPreviousStage.add(getCapByStage(getStage(currTime)));
974   }
975 
976   function getStage(uint256 currTime) public view returns (uint256) {
977     if (currTime < icoEndTimes[0]) {
978       return 0;
979     } else if ((currTime > icoEndTimes[0]) && (currTime <= icoEndTimes[1])) {
980       return 1;
981     } else {
982       return 2;
983     }
984   }
985 
986   function getCapByStage(uint256 stage) public view returns (uint256) {
987     return icoCaps[stage];
988   }
989 
990   function getRateByStage(uint256 stage) public view returns (uint256) {
991     return icoRates[stage];
992   }
993 
994 
995   function toBDXWEI(uint256 value) internal view returns (uint256) {
996     BDXCoin bdxcoin = BDXCoin(token);
997     return (value * (10 ** uint256(bdxcoin.decimals())));
998   }
999 
1000   function finalization() internal {
1001     super.finalization();
1002     if (goalReached()) {
1003       BDXCoin bdxcoin = BDXCoin(token);
1004       bdxcoin.releaseTokenTransfer();
1005     }
1006   }
1007 
1008 }