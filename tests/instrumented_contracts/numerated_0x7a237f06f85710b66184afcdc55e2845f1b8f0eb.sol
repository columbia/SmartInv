1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ownership/OwnableUpdated.sol
4 
5 /**
6  * @title Ownable
7  * @notice Implementation by OpenZeppelin
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
11  */
12 contract OwnableUpdated {
13     address private _owner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19      * account.
20      */
21     constructor () internal {
22         _owner = msg.sender;
23         emit OwnershipTransferred(address(0), _owner);
24     }
25 
26     /**
27      * @return the address of the owner.
28      */
29     function owner() public view returns (address) {
30         return _owner;
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(isOwner());
38         _;
39     }
40 
41     /**
42      * @return true if `msg.sender` is the owner of the contract.
43      */
44     function isOwner() public view returns (bool) {
45         return msg.sender == _owner;
46     }
47 
48     /**
49      * @dev Allows the current owner to relinquish control of the contract.
50      * @notice Renouncing to ownership will leave the contract without an owner.
51      * It will not be possible to call the functions with the `onlyOwner`
52      * modifier anymore.
53      */
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(_owner, address(0));
56         _owner = address(0);
57     }
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function _transferOwnership(address newOwner) internal {
72         require(newOwner != address(0));
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 // File: contracts/token/TalaoToken.sol
79 
80 /**
81  * @title SafeMath
82  * @dev Math operations with safety checks that throw on error
83  */
84 library SafeMath {
85   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86     if (a == 0) {
87       return 0;
88     }
89     uint256 c = a * b;
90     assert(c / a == b);
91     return c;
92   }
93 
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a / b;
96     return c;
97   }
98 
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   function add(uint256 a, uint256 b) internal pure returns (uint256) {
105     uint256 c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 /**
112  * @title Ownable
113  * @dev The Ownable contract has an owner address, and provides basic authorization control
114  * functions, this simplifies the implementation of "user permissions".
115  */
116 contract Ownable {
117   address public owner;
118 
119 
120   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122 
123   /**
124    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
125    * account.
126    */
127   function Ownable() public {
128     owner = msg.sender;
129   }
130 
131 
132   /**
133    * @dev Throws if called by any account other than the owner.
134    */
135   modifier onlyOwner() {
136     require(msg.sender == owner);
137     _;
138   }
139 
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address newOwner) public onlyOwner {
146     require(newOwner != address(0));
147     OwnershipTransferred(owner, newOwner);
148     owner = newOwner;
149   }
150 
151 }
152 
153 /**
154  * @title TalaoMarketplace
155  * @dev This contract is allowing users to buy or sell Talao tokens at a price set by the owner
156  * @author Blockchain Partner
157  */
158 contract TalaoMarketplace is Ownable {
159   using SafeMath for uint256;
160 
161   TalaoToken public token;
162 
163   struct MarketplaceData {
164     uint buyPrice;
165     uint sellPrice;
166     uint unitPrice;
167   }
168 
169   MarketplaceData public marketplace;
170 
171   event SellingPrice(uint sellingPrice);
172   event TalaoBought(address buyer, uint amount, uint price, uint unitPrice);
173   event TalaoSold(address seller, uint amount, uint price, uint unitPrice);
174 
175   /**
176   * @dev Constructor of the marketplace pointing to the TALAO token address
177   * @param talao the talao token address
178   **/
179   constructor(address talao)
180       public
181   {
182       token = TalaoToken(talao);
183   }
184 
185   /**
186   * @dev Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
187   * @param newSellPrice price the users can sell to the contract
188   * @param newBuyPrice price users can buy from the contract
189   * @param newUnitPrice to manage decimal issue 0,35 = 35 /100 (100 is unit)
190   */
191   function setPrices(uint256 newSellPrice, uint256 newBuyPrice, uint256 newUnitPrice)
192       public
193       onlyOwner
194   {
195       require (newSellPrice > 0 && newBuyPrice > 0 && newUnitPrice > 0, "wrong inputs");
196       marketplace.sellPrice = newSellPrice;
197       marketplace.buyPrice = newBuyPrice;
198       marketplace.unitPrice = newUnitPrice;
199   }
200 
201   /**
202   * @dev Allow anyone to buy tokens against ether, depending on the buyPrice set by the contract owner.
203   * @return amount the amount of tokens bought
204   **/
205   function buy()
206       public
207       payable
208       returns (uint amount)
209   {
210       amount = msg.value.mul(marketplace.unitPrice).div(marketplace.buyPrice);
211       token.transfer(msg.sender, amount);
212       emit TalaoBought(msg.sender, amount, marketplace.buyPrice, marketplace.unitPrice);
213       return amount;
214   }
215 
216   /**
217   * @dev Allow anyone to sell tokens for ether, depending on the sellPrice set by the contract owner.
218   * @param amount the number of tokens to be sold
219   * @return revenue ethers sent in return
220   **/
221   function sell(uint amount)
222       public
223       returns (uint revenue)
224   {
225       require(token.balanceOf(msg.sender) >= amount, "sender has not enough tokens");
226       token.transferFrom(msg.sender, this, amount);
227       revenue = amount.mul(marketplace.sellPrice).div(marketplace.unitPrice);
228       msg.sender.transfer(revenue);
229       emit TalaoSold(msg.sender, amount, marketplace.sellPrice, marketplace.unitPrice);
230       return revenue;
231   }
232 
233   /**
234    * @dev Allows the owner to withdraw ethers from the contract.
235    * @param ethers quantity of ethers to be withdrawn
236    * @return true if withdrawal successful ; false otherwise
237    */
238   function withdrawEther(uint256 ethers)
239       public
240       onlyOwner
241   {
242       if (this.balance >= ethers) {
243           msg.sender.transfer(ethers);
244       }
245   }
246 
247   /**
248    * @dev Allow the owner to withdraw tokens from the contract.
249    * @param tokens quantity of tokens to be withdrawn
250    */
251   function withdrawTalao(uint256 tokens)
252       public
253       onlyOwner
254   {
255       token.transfer(msg.sender, tokens);
256   }
257 
258 
259   /**
260   * @dev Fallback function ; only owner can send ether.
261   **/
262   function ()
263       public
264       payable
265       onlyOwner
266   {
267 
268   }
269 
270 }
271 
272 /**
273  * @title ERC20Basic
274  * @dev Simpler version of ERC20 interface
275  * @dev see https://github.com/ethereum/EIPs/issues/179
276  */
277 contract ERC20Basic {
278   uint256 public totalSupply;
279   function balanceOf(address who) public view returns (uint256);
280   function transfer(address to, uint256 value) public returns (bool);
281   event Transfer(address indexed from, address indexed to, uint256 value);
282 }
283 
284 /**
285  * @title ERC20 interface
286  * @dev see https://github.com/ethereum/EIPs/issues/20
287  */
288 contract ERC20 is ERC20Basic {
289   function allowance(address owner, address spender) public view returns (uint256);
290   function transferFrom(address from, address to, uint256 value) public returns (bool);
291   function approve(address spender, uint256 value) public returns (bool);
292   event Approval(address indexed owner, address indexed spender, uint256 value);
293 }
294 
295 /**
296  * @title SafeERC20
297  * @dev Wrappers around ERC20 operations that throw on failure.
298  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
299  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
300  */
301 library SafeERC20 {
302   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
303     assert(token.transfer(to, value));
304   }
305 
306   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
307     assert(token.transferFrom(from, to, value));
308   }
309 
310   function safeApprove(ERC20 token, address spender, uint256 value) internal {
311     assert(token.approve(spender, value));
312   }
313 }
314 
315 
316 /**
317  * @title TokenTimelock
318  * @dev TokenTimelock is a token holder contract that will allow a
319  * beneficiary to extract the tokens after a given release time
320  */
321 contract TokenTimelock {
322   using SafeERC20 for ERC20Basic;
323 
324   // ERC20 basic token contract being held
325   ERC20Basic public token;
326 
327   // beneficiary of tokens after they are released
328   address public beneficiary;
329 
330   // timestamp when token release is enabled
331   uint256 public releaseTime;
332 
333   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
334     require(_releaseTime > now);
335     token = _token;
336     beneficiary = _beneficiary;
337     releaseTime = _releaseTime;
338   }
339 
340   /**
341    * @notice Transfers tokens held by timelock to beneficiary.
342    * @dev Removed original require that amount released was > 0 ; releasing 0 is fine
343    */
344   function release() public {
345     require(now >= releaseTime);
346 
347     uint256 amount = token.balanceOf(this);
348 
349     token.safeTransfer(beneficiary, amount);
350   }
351 }
352 
353 
354 /**
355  * @title TokenVesting
356  * @dev A token holder contract that can release its token balance gradually like a
357  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
358  * owner.
359  * @notice Talao token transfer function cannot fail thus there's no need for revocation.
360  */
361 contract TokenVesting is Ownable {
362   using SafeMath for uint256;
363   using SafeERC20 for ERC20Basic;
364 
365   event Released(uint256 amount);
366   event Revoked();
367 
368   // beneficiary of tokens after they are released
369   address public beneficiary;
370 
371   uint256 public cliff;
372   uint256 public start;
373   uint256 public duration;
374 
375   bool public revocable;
376 
377   mapping (address => uint256) public released;
378   mapping (address => bool) public revoked;
379 
380   /**
381    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
382    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
383    * of the balance will have vested.
384    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
385    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
386    * @param _duration duration in seconds of the period in which the tokens will vest
387    * @param _revocable whether the vesting is revocable or not
388    */
389   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
390     require(_beneficiary != address(0));
391     require(_cliff <= _duration);
392 
393     beneficiary = _beneficiary;
394     revocable = _revocable;
395     duration = _duration;
396     cliff = _start.add(_cliff);
397     start = _start;
398   }
399 
400   /**
401    * @notice Transfers vested tokens to beneficiary.
402    * @dev Removed original require that amount released was > 0 ; releasing 0 is fine
403    * @param token ERC20 token which is being vested
404    */
405   function release(ERC20Basic token) public {
406     uint256 unreleased = releasableAmount(token);
407 
408     released[token] = released[token].add(unreleased);
409 
410     token.safeTransfer(beneficiary, unreleased);
411 
412     Released(unreleased);
413   }
414 
415   /**
416    * @notice Allows the owner to revoke the vesting. Tokens already vested
417    * remain in the contract, the rest are returned to the owner.
418    * @param token ERC20 token which is being vested
419    */
420   function revoke(ERC20Basic token) public onlyOwner {
421     require(revocable);
422     require(!revoked[token]);
423 
424     uint256 balance = token.balanceOf(this);
425 
426     uint256 unreleased = releasableAmount(token);
427     uint256 refund = balance.sub(unreleased);
428 
429     revoked[token] = true;
430 
431     token.safeTransfer(owner, refund);
432 
433     Revoked();
434   }
435 
436   /**
437    * @dev Calculates the amount that has already vested but hasn't been released yet.
438    * @param token ERC20 token which is being vested
439    */
440   function releasableAmount(ERC20Basic token) public view returns (uint256) {
441     return vestedAmount(token).sub(released[token]);
442   }
443 
444   /**
445    * @dev Calculates the amount that has already vested.
446    * @param token ERC20 token which is being vested
447    */
448   function vestedAmount(ERC20Basic token) public view returns (uint256) {
449     uint256 currentBalance = token.balanceOf(this);
450     uint256 totalBalance = currentBalance.add(released[token]);
451 
452     if (now < cliff) {
453       return 0;
454     } else if (now >= start.add(duration) || revoked[token]) {
455       return totalBalance;
456     } else {
457       return totalBalance.mul(now.sub(start)).div(duration);
458     }
459   }
460 }
461 
462 /**
463  * @title Crowdsale
464  * @dev Crowdsale is a base contract for managing a token crowdsale.
465  * Crowdsales have a start and end timestamps, where investors can make
466  * token purchases and the crowdsale will assign them tokens based
467  * on a token per ETH rate. Funds collected are forwarded to a wallet
468  * as they arrive.
469  */
470 contract Crowdsale {
471   using SafeMath for uint256;
472 
473   // The token being sold
474   MintableToken public token;
475 
476   // start and end timestamps where investments are allowed (both inclusive)
477   uint256 public startTime;
478   uint256 public endTime;
479 
480   // address where funds are collected
481   address public wallet;
482 
483   // how many token units a buyer gets per wei
484   uint256 public rate;
485 
486   // amount of raised money in wei
487   uint256 public weiRaised;
488 
489   /**
490    * event for token purchase logging
491    * @param purchaser who paid for the tokens
492    * @param beneficiary who got the tokens
493    * @param value weis paid for purchase
494    * @param amount amount of tokens purchased
495    */
496   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
497 
498   function Crowdsale(uint256 _rate, uint256 _startTime, uint256 _endTime, address _wallet) public {
499     require(_rate > 0);
500     require(_startTime >= now);
501     require(_endTime >= _startTime);
502     require(_wallet != address(0));
503 
504     token = createTokenContract();
505     startTime = _startTime;
506     endTime = _endTime;
507     wallet = _wallet;
508   }
509 
510   // creates the token to be sold.
511   // override this method to have crowdsale of a specific mintable token.
512   function createTokenContract() internal returns (MintableToken) {
513     return new MintableToken();
514   }
515 
516 
517   // fallback function can be used to buy tokens
518   function () external payable {
519     buyTokens(msg.sender);
520   }
521 
522   // low level token purchase function
523   function buyTokens(address beneficiary) public payable {
524     require(beneficiary != address(0));
525     require(validPurchase());
526 
527     uint256 weiAmount = msg.value;
528 
529     // calculate token amount to be created
530     uint256 tokens = weiAmount.mul(rate);
531 
532     // update state
533     weiRaised = weiRaised.add(weiAmount);
534 
535     token.mint(beneficiary, tokens);
536     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
537 
538     forwardFunds();
539   }
540 
541   // send ether to the fund collection wallet
542   // override to create custom fund forwarding mechanisms
543   function forwardFunds() internal {
544     wallet.transfer(msg.value);
545   }
546 
547   // @return true if the transaction can buy tokens
548   // removed view to be overriden
549   function validPurchase() internal returns (bool) {
550     bool withinPeriod = now >= startTime && now <= endTime;
551     bool nonZeroPurchase = msg.value != 0;
552     return withinPeriod && nonZeroPurchase;
553   }
554 
555   // @return true if crowdsale event has ended
556   function hasEnded() public view returns (bool) {
557     return now > endTime;
558   }
559 
560 
561 }
562 
563 
564 /**
565  * @title FinalizableCrowdsale
566  * @dev Extension of Crowdsale where an owner can do extra work
567  * after finishing.
568  */
569 contract FinalizableCrowdsale is Crowdsale, Ownable {
570   using SafeMath for uint256;
571 
572   bool public isFinalized = false;
573 
574   event Finalized();
575 
576   /**
577    * @dev Must be called after crowdsale ends, to do some extra finalization
578    * work. Calls the contract's finalization function.
579    */
580   function finalize() public {
581     require(!isFinalized);
582     require(hasEnded());
583 
584     finalization();
585     Finalized();
586 
587     isFinalized = true;
588   }
589 
590   /**
591    * @dev Can be overridden to add finalization logic. The overriding function
592    * should call super.finalization() to ensure the chain of finalization is
593    * executed entirely.
594    */
595   function finalization() internal {
596   }
597 }
598 
599 
600 /**
601  * @title RefundVault
602  * @dev This contract is used for storing funds while a crowdsale
603  * is in progress. Supports refunding the money if crowdsale fails,
604  * and forwarding it if crowdsale is successful.
605  */
606 contract RefundVault is Ownable {
607   using SafeMath for uint256;
608 
609   enum State { Active, Refunding, Closed }
610 
611   mapping (address => uint256) public deposited;
612   address public wallet;
613   State public state;
614 
615   event Closed();
616   event RefundsEnabled();
617   event Refunded(address indexed beneficiary, uint256 weiAmount);
618 
619   function RefundVault(address _wallet) public {
620     require(_wallet != address(0));
621     wallet = _wallet;
622     state = State.Active;
623   }
624 
625   function deposit(address investor) onlyOwner public payable {
626     require(state == State.Active);
627     deposited[investor] = deposited[investor].add(msg.value);
628   }
629 
630   function close() onlyOwner public {
631     require(state == State.Active);
632     state = State.Closed;
633     Closed();
634     wallet.transfer(this.balance);
635   }
636 
637   function enableRefunds() onlyOwner public {
638     require(state == State.Active);
639     state = State.Refunding;
640     RefundsEnabled();
641   }
642 
643   function refund(address investor) public {
644     require(state == State.Refunding);
645     uint256 depositedValue = deposited[investor];
646     deposited[investor] = 0;
647     investor.transfer(depositedValue);
648     Refunded(investor, depositedValue);
649   }
650 }
651 
652 
653 
654 /**
655  * @title RefundableCrowdsale
656  * @dev Extension of Crowdsale contract that adds a funding goal, and
657  * the possibility of users getting a refund if goal is not met.
658  * Uses a RefundVault as the crowdsale's vault.
659  */
660 contract RefundableCrowdsale is FinalizableCrowdsale {
661   using SafeMath for uint256;
662 
663   // minimum amount of funds to be raised in weis
664   uint256 public goal;
665 
666   // refund vault used to hold funds while crowdsale is running
667   RefundVault public vault;
668 
669   function RefundableCrowdsale(uint256 _goal) public {
670     require(_goal > 0);
671     vault = new RefundVault(wallet);
672     goal = _goal;
673   }
674 
675   // We're overriding the fund forwarding from Crowdsale.
676   // In addition to sending the funds, we want to call
677   // the RefundVault deposit function
678   function forwardFunds() internal {
679     vault.deposit.value(msg.value)(msg.sender);
680   }
681 
682   // if crowdsale is unsuccessful, investors can claim refunds here
683   function claimRefund() public {
684     require(isFinalized);
685     require(!goalReached());
686 
687     vault.refund(msg.sender);
688   }
689 
690   // vault finalization task, called when owner calls finalize()
691   function finalization() internal {
692     if (goalReached()) {
693       vault.close();
694     } else {
695       vault.enableRefunds();
696     }
697 
698     super.finalization();
699   }
700 
701   function goalReached() public view returns (bool) {
702     return weiRaised >= goal;
703   }
704 
705 }
706 
707 
708 /**
709  * @title CappedCrowdsale
710  * @dev Extension of Crowdsale with a max amount of funds raised
711  */
712 contract CappedCrowdsale is Crowdsale {
713   using SafeMath for uint256;
714 
715   uint256 public cap;
716 
717   function CappedCrowdsale(uint256 _cap) public {
718     require(_cap > 0);
719     cap = _cap;
720   }
721 
722   // overriding Crowdsale#validPurchase to add extra cap logic
723   // @return true if investors can buy at the moment
724   // removed view to be overriden
725   function validPurchase() internal returns (bool) {
726     bool withinCap = weiRaised.add(msg.value) <= cap;
727     return super.validPurchase() && withinCap;
728   }
729 
730   // overriding Crowdsale#hasEnded to add cap logic
731   // @return true if crowdsale event has ended
732   function hasEnded() public view returns (bool) {
733     bool capReached = weiRaised >= cap;
734     return super.hasEnded() || capReached;
735   }
736 
737 }
738 
739 /**
740  * @title ProgressiveIndividualCappedCrowdsale
741  * @dev Extension of Crowdsale with a progressive individual cap
742  * @dev This contract is not made for crowdsale superior to 256 * TIME_PERIOD_IN_SEC
743  * @author Request.network ; some modifications by Blockchain Partner
744  */
745 contract ProgressiveIndividualCappedCrowdsale is RefundableCrowdsale, CappedCrowdsale {
746 
747     uint public startGeneralSale;
748     uint public constant TIME_PERIOD_IN_SEC = 1 days;
749     uint public constant minimumParticipation = 10 finney;
750     uint public constant GAS_LIMIT_IN_WEI = 5E10 wei; // limit gas price -50 Gwei wales stopper
751     uint256 public baseEthCapPerAddress;
752 
753     mapping(address=>uint) public participated;
754 
755     function ProgressiveIndividualCappedCrowdsale(uint _baseEthCapPerAddress, uint _startGeneralSale)
756         public
757     {
758         baseEthCapPerAddress = _baseEthCapPerAddress;
759         startGeneralSale = _startGeneralSale;
760     }
761 
762     /**
763      * @dev setting cap before the general sale starts
764      * @param _newBaseCap the new cap
765      */
766     function setBaseCap(uint _newBaseCap)
767         public
768         onlyOwner
769     {
770         require(now < startGeneralSale);
771         baseEthCapPerAddress = _newBaseCap;
772     }
773 
774     /**
775      * @dev overriding CappedCrowdsale#validPurchase to add an individual cap
776      * @return true if investors can buy at the moment
777      */
778     function validPurchase()
779         internal
780         returns(bool)
781     {
782         bool gasCheck = tx.gasprice <= GAS_LIMIT_IN_WEI;
783         uint ethCapPerAddress = getCurrentEthCapPerAddress();
784         participated[msg.sender] = participated[msg.sender].add(msg.value);
785         bool enough = participated[msg.sender] >= minimumParticipation;
786         return participated[msg.sender] <= ethCapPerAddress && enough && gasCheck;
787     }
788 
789     /**
790      * @dev Get the current individual cap.
791      * @dev This amount increase everyday in an exponential way. Day 1: base cap, Day 2: 2 * base cap, Day 3: 4 * base cap ...
792      * @return individual cap in wei
793      */
794     function getCurrentEthCapPerAddress()
795         public
796         constant
797         returns(uint)
798     {
799         if (block.timestamp < startGeneralSale) return 0;
800         uint timeSinceStartInSec = block.timestamp.sub(startGeneralSale);
801         uint currentPeriod = timeSinceStartInSec.div(TIME_PERIOD_IN_SEC).add(1);
802 
803         // for currentPeriod > 256 will always return 0
804         return (2 ** currentPeriod.sub(1)).mul(baseEthCapPerAddress);
805     }
806 }
807 
808 /**
809  * @title Basic token
810  * @dev Basic version of StandardToken, with no allowances.
811  */
812 contract BasicToken is ERC20Basic {
813   using SafeMath for uint256;
814 
815   mapping(address => uint256) balances;
816 
817   /**
818   * @dev transfer token for a specified address
819   * @param _to The address to transfer to.
820   * @param _value The amount to be transferred.
821   */
822   function transfer(address _to, uint256 _value) public returns (bool) {
823     require(_to != address(0));
824     require(_value <= balances[msg.sender]);
825 
826     // SafeMath.sub will throw if there is not enough balance.
827     balances[msg.sender] = balances[msg.sender].sub(_value);
828     balances[_to] = balances[_to].add(_value);
829     Transfer(msg.sender, _to, _value);
830     return true;
831   }
832 
833   /**
834   * @dev Gets the balance of the specified address.
835   * @param _owner The address to query the the balance of.
836   * @return An uint256 representing the amount owned by the passed address.
837   */
838   function balanceOf(address _owner) public view returns (uint256 balance) {
839     return balances[_owner];
840   }
841 
842 }
843 
844 
845 /**
846  * @title Standard ERC20 token
847  *
848  * @dev Implementation of the basic standard token.
849  * @dev https://github.com/ethereum/EIPs/issues/20
850  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
851  */
852 contract StandardToken is ERC20, BasicToken {
853 
854   mapping (address => mapping (address => uint256)) internal allowed;
855 
856 
857   /**
858    * @dev Transfer tokens from one address to another
859    * @param _from address The address which you want to send tokens from
860    * @param _to address The address which you want to transfer to
861    * @param _value uint256 the amount of tokens to be transferred
862    */
863   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
864     require(_to != address(0));
865     require(_value <= balances[_from]);
866     require(_value <= allowed[_from][msg.sender]);
867 
868     balances[_from] = balances[_from].sub(_value);
869     balances[_to] = balances[_to].add(_value);
870     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
871     Transfer(_from, _to, _value);
872     return true;
873   }
874 
875   /**
876    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
877    *
878    * Beware that changing an allowance with this method brings the risk that someone may use both the old
879    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
880    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
881    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
882    * @param _spender The address which will spend the funds.
883    * @param _value The amount of tokens to be spent.
884    */
885   function approve(address _spender, uint256 _value) public returns (bool) {
886     allowed[msg.sender][_spender] = _value;
887     Approval(msg.sender, _spender, _value);
888     return true;
889   }
890 
891   /**
892    * @dev Function to check the amount of tokens that an owner allowed to a spender.
893    * @param _owner address The address which owns the funds.
894    * @param _spender address The address which will spend the funds.
895    * @return A uint256 specifying the amount of tokens still available for the spender.
896    */
897   function allowance(address _owner, address _spender) public view returns (uint256) {
898     return allowed[_owner][_spender];
899   }
900 
901   /**
902    * @dev Increase the amount of tokens that an owner allowed to a spender.
903    *
904    * approve should be called when allowed[_spender] == 0. To increment
905    * allowed value is better to use this function to avoid 2 calls (and wait until
906    * the first transaction is mined)
907    * From MonolithDAO Token.sol
908    * @param _spender The address which will spend the funds.
909    * @param _addedValue The amount of tokens to increase the allowance by.
910    */
911   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
912     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
913     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
914     return true;
915   }
916 
917   /**
918    * @dev Decrease the amount of tokens that an owner allowed to a spender.
919    *
920    * approve should be called when allowed[_spender] == 0. To decrement
921    * allowed value is better to use this function to avoid 2 calls (and wait until
922    * the first transaction is mined)
923    * From MonolithDAO Token.sol
924    * @param _spender The address which will spend the funds.
925    * @param _subtractedValue The amount of tokens to decrease the allowance by.
926    */
927   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
928     uint oldValue = allowed[msg.sender][_spender];
929     if (_subtractedValue > oldValue) {
930       allowed[msg.sender][_spender] = 0;
931     } else {
932       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
933     }
934     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
935     return true;
936   }
937 
938 }
939 
940 /**
941  * @title Mintable token
942  * @dev Simple ERC20 Token example, with mintable token creation
943  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
944  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
945  */
946 
947 contract MintableToken is StandardToken, Ownable {
948   event Mint(address indexed to, uint256 amount);
949   event MintFinished();
950 
951   bool public mintingFinished = false;
952 
953 
954   modifier canMint() {
955     require(!mintingFinished);
956     _;
957   }
958 
959   /**
960    * @dev Function to mint tokens
961    * @param _to The address that will receive the minted tokens.
962    * @param _amount The amount of tokens to mint.
963    * @return A boolean that indicates if the operation was successful.
964    */
965   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
966     totalSupply = totalSupply.add(_amount);
967     balances[_to] = balances[_to].add(_amount);
968     Mint(_to, _amount);
969     Transfer(address(0), _to, _amount);
970     return true;
971   }
972 
973   /**
974    * @dev Function to stop minting new tokens.
975    * @return True if the operation was successful.
976    */
977   function finishMinting() onlyOwner canMint public returns (bool) {
978     mintingFinished = true;
979     MintFinished();
980     return true;
981   }
982 }
983 
984 
985 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
986 
987 /**
988  * @title TalaoToken
989  * @dev This contract details the TALAO token and allows freelancers to create/revoke vault access, appoint agents.
990  * @author Blockchain Partner
991  */
992 contract TalaoToken is MintableToken {
993   using SafeMath for uint256;
994 
995   // token details
996   string public constant name = "Talao";
997   string public constant symbol = "TALAO";
998   uint8 public constant decimals = 18;
999 
1000   // the talao marketplace address
1001   address public marketplace;
1002 
1003   // talao tokens needed to create a vault
1004   uint256 public vaultDeposit;
1005   // sum of all talao tokens desposited
1006   uint256 public totalDeposit;
1007 
1008   struct FreelanceData {
1009       // access price to the talent vault
1010       uint256 accessPrice;
1011       // address of appointed talent agent
1012       address appointedAgent;
1013       // how much the talent is sharing with its agent
1014       uint sharingPlan;
1015       // how much is the talent deposit
1016       uint256 userDeposit;
1017   }
1018 
1019   // structure that defines a client access to a vault
1020   struct ClientAccess {
1021       // is he allowed to access the vault
1022       bool clientAgreement;
1023       // the block number when access was granted
1024       uint clientDate;
1025   }
1026 
1027   // Vault allowance client x freelancer
1028   mapping (address => mapping (address => ClientAccess)) public accessAllowance;
1029 
1030   // Freelance data is public
1031   mapping (address=>FreelanceData) public data;
1032 
1033   enum VaultStatus {Closed, Created, PriceTooHigh, NotEnoughTokensDeposited, AgentRemoved, NewAgent, NewAccess, WrongAccessPrice}
1034 
1035   // Those event notifies UI about vaults action with vault status
1036   // Closed Vault access closed
1037   // Created Vault access created
1038   // PriceTooHigh Vault access price too high
1039   // NotEnoughTokensDeposited not enough tokens to pay deposit
1040   // AgentRemoved agent removed
1041   // NewAgent new agent appointed
1042   // NewAccess vault access granted to client
1043   // WrongAccessPrice client not enough token to pay vault access
1044   event Vault(address indexed client, address indexed freelance, VaultStatus status);
1045 
1046   modifier onlyMintingFinished()
1047   {
1048       require(mintingFinished == true, "minting has not finished");
1049       _;
1050   }
1051 
1052   /**
1053   * @dev Let the owner set the marketplace address once minting is over
1054   *      Possible to do it more than once to ensure maintainability
1055   * @param theMarketplace the marketplace address
1056   **/
1057   function setMarketplace(address theMarketplace)
1058       public
1059       onlyMintingFinished
1060       onlyOwner
1061   {
1062       marketplace = theMarketplace;
1063   }
1064 
1065   /**
1066   * @dev Same ERC20 behavior, but require the token to be unlocked
1067   * @param _spender address The address that will spend the funds.
1068   * @param _value uint256 The amount of tokens to be spent.
1069   **/
1070   function approve(address _spender, uint256 _value)
1071       public
1072       onlyMintingFinished
1073       returns (bool)
1074   {
1075       return super.approve(_spender, _value);
1076   }
1077 
1078   /**
1079   * @dev Same ERC20 behavior, but require the token to be unlocked and sells some tokens to refill ether balance up to minBalanceForAccounts
1080   * @param _to address The address to transfer to.
1081   * @param _value uint256 The amount to be transferred.
1082   **/
1083   function transfer(address _to, uint256 _value)
1084       public
1085       onlyMintingFinished
1086       returns (bool result)
1087   {
1088       return super.transfer(_to, _value);
1089   }
1090 
1091   /**
1092   * @dev Same ERC20 behavior, but require the token to be unlocked
1093   * @param _from address The address which you want to send tokens from.
1094   * @param _to address The address which you want to transfer to.
1095   * @param _value uint256 the amount of tokens to be transferred.
1096   **/
1097   function transferFrom(address _from, address _to, uint256 _value)
1098       public
1099       onlyMintingFinished
1100       returns (bool)
1101   {
1102       return super.transferFrom(_from, _to, _value);
1103   }
1104 
1105   /**
1106    * @dev Set allowance for other address and notify
1107    *      Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
1108    * @param _spender The address authorized to spend
1109    * @param _value the max amount they can spend
1110    * @param _extraData some extra information to send to the approved contract
1111    */
1112   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
1113       public
1114       onlyMintingFinished
1115       returns (bool)
1116   {
1117       tokenRecipient spender = tokenRecipient(_spender);
1118       if (approve(_spender, _value)) {
1119           spender.receiveApproval(msg.sender, _value, this, _extraData);
1120           return true;
1121       }
1122   }
1123 
1124   /**
1125    * @dev Allows the owner to withdraw ethers from the contract.
1126    * @param ethers quantity in weis of ethers to be withdrawn
1127    * @return true if withdrawal successful ; false otherwise
1128    */
1129   function withdrawEther(uint256 ethers)
1130       public
1131       onlyOwner
1132   {
1133       msg.sender.transfer(ethers);
1134   }
1135 
1136   /**
1137    * @dev Allow the owner to withdraw tokens from the contract without taking tokens from deposits.
1138    * @param tokens quantity of tokens to be withdrawn
1139    */
1140   function withdrawTalao(uint256 tokens)
1141       public
1142       onlyOwner
1143   {
1144       require(balanceOf(this).sub(totalDeposit) >= tokens, "too much tokens asked");
1145       _transfer(this, msg.sender, tokens);
1146   }
1147 
1148   /******************************************/
1149   /*      vault functions start here        */
1150   /******************************************/
1151 
1152   /**
1153   * @dev Allows anyone to create a vault access.
1154   *      Vault deposit is transferred to token contract and sum is stored in totalDeposit
1155   *      Price must be lower than Vault deposit
1156   * @param price to pay to access certificate vault
1157   */
1158   function createVaultAccess (uint256 price)
1159       public
1160       onlyMintingFinished
1161   {
1162       require(accessAllowance[msg.sender][msg.sender].clientAgreement==false, "vault already created");
1163       require(price<=vaultDeposit, "price asked is too high");
1164       require(balanceOf(msg.sender)>vaultDeposit, "user has not enough tokens to send deposit");
1165       data[msg.sender].accessPrice=price;
1166       super.transfer(this, vaultDeposit);
1167       totalDeposit = totalDeposit.add(vaultDeposit);
1168       data[msg.sender].userDeposit=vaultDeposit;
1169       data[msg.sender].sharingPlan=100;
1170       accessAllowance[msg.sender][msg.sender].clientAgreement=true;
1171       emit Vault(msg.sender, msg.sender, VaultStatus.Created);
1172   }
1173 
1174   /**
1175   * @dev Closes a vault access, deposit is sent back to freelance wallet
1176   *      Total deposit in token contract is reduced by user deposit
1177   */
1178   function closeVaultAccess()
1179       public
1180       onlyMintingFinished
1181   {
1182       require(accessAllowance[msg.sender][msg.sender].clientAgreement==true, "vault has not been created");
1183       require(_transfer(this, msg.sender, data[msg.sender].userDeposit), "token deposit transfer failed");
1184       accessAllowance[msg.sender][msg.sender].clientAgreement=false;
1185       totalDeposit=totalDeposit.sub(data[msg.sender].userDeposit);
1186       data[msg.sender].sharingPlan=0;
1187       emit Vault(msg.sender, msg.sender, VaultStatus.Closed);
1188   }
1189 
1190   /**
1191   * @dev Internal transfer function used to transfer tokens from an address to another without prior authorization.
1192   *      Only used in these situations:
1193   *           * Send tokens from the contract to a token buyer (buy() function)
1194   *           * Send tokens from the contract to the owner in order to withdraw tokens (withdrawTalao(tokens) function)
1195   *           * Send tokens from the contract to a user closing its vault thus claiming its deposit back (closeVaultAccess() function)
1196   * @param _from address The address which you want to send tokens from.
1197   * @param _to address The address which you want to transfer to.
1198   * @param _value uint256 the amount of tokens to be transferred.
1199   * @return true if transfer is successful ; should throw otherwise
1200   */
1201   function _transfer(address _from, address _to, uint _value)
1202       internal
1203       returns (bool)
1204   {
1205       require(_to != 0x0, "destination cannot be 0x0");
1206       require(balances[_from] >= _value, "not enough tokens in sender wallet");
1207 
1208       balances[_from] = balances[_from].sub(_value);
1209       balances[_to] = balances[_to].add(_value);
1210       emit Transfer(_from, _to, _value);
1211       return true;
1212   }
1213 
1214   /**
1215   * @dev Appoint an agent or a new agent
1216   *      Former agent is replaced by new agent
1217   *      Agent will receive token on behalf of the freelance talent
1218   * @param newagent agent to appoint
1219   * @param newplan sharing plan is %, 100 means 100% for freelance
1220   */
1221   function agentApproval (address newagent, uint newplan)
1222       public
1223       onlyMintingFinished
1224   {
1225       require(newplan>=0&&newplan<=100, "plan must be between 0 and 100");
1226       require(accessAllowance[msg.sender][msg.sender].clientAgreement==true, "vault has not been created");
1227       emit Vault(data[msg.sender].appointedAgent, msg.sender, VaultStatus.AgentRemoved);
1228       data[msg.sender].appointedAgent=newagent;
1229       data[msg.sender].sharingPlan=newplan;
1230       emit Vault(newagent, msg.sender, VaultStatus.NewAgent);
1231   }
1232 
1233   /**
1234    * @dev Set the quantity of tokens necessary for vault access creation
1235    * @param newdeposit deposit (in tokens) for vault access creation
1236    */
1237   function setVaultDeposit (uint newdeposit)
1238       public
1239       onlyOwner
1240   {
1241       vaultDeposit = newdeposit;
1242   }
1243 
1244   /**
1245   * @dev Buy unlimited access to a freelancer vault
1246   *      Vault access price is transfered from client to agent or freelance depending on the sharing plan
1247   *      Allowance is given to client and one stores block.number for future use
1248   * @param freelance the address of the talent
1249   * @return true if access is granted ; false if not
1250   */
1251   function getVaultAccess (address freelance)
1252       public
1253       onlyMintingFinished
1254       returns (bool)
1255   {
1256       require(accessAllowance[freelance][freelance].clientAgreement==true, "vault does not exist");
1257       require(accessAllowance[msg.sender][freelance].clientAgreement!=true, "access was already granted");
1258       require(balanceOf(msg.sender)>data[freelance].accessPrice, "user has not enough tokens to get access to vault");
1259 
1260       uint256 freelance_share = data[freelance].accessPrice.mul(data[freelance].sharingPlan).div(100);
1261       uint256 agent_share = data[freelance].accessPrice.sub(freelance_share);
1262       if(freelance_share>0) super.transfer(freelance, freelance_share);
1263       if(agent_share>0) super.transfer(data[freelance].appointedAgent, agent_share);
1264       accessAllowance[msg.sender][freelance].clientAgreement=true;
1265       accessAllowance[msg.sender][freelance].clientDate=block.number;
1266       emit Vault(msg.sender, freelance, VaultStatus.NewAccess);
1267       return true;
1268   }
1269 
1270   /**
1271   * @dev Simple getter to retrieve talent agent
1272   * @param freelance talent address
1273   * @return address of the agent
1274   **/
1275   function getFreelanceAgent(address freelance)
1276       public
1277       view
1278       returns (address)
1279   {
1280       return data[freelance].appointedAgent;
1281   }
1282 
1283   /**
1284   * @dev Simple getter to check if user has access to a freelance vault
1285   * @param freelance talent address
1286   * @param user user address
1287   * @return true if access granted or false if not
1288   **/
1289   function hasVaultAccess(address freelance, address user)
1290       public
1291       view
1292       returns (bool)
1293   {
1294       return ((accessAllowance[user][freelance].clientAgreement) || (data[freelance].appointedAgent == user));
1295   }
1296 
1297 }
1298 
1299 // File: contracts/Foundation.sol
1300 
1301 /**
1302  * @title Foundation contract.
1303  * @author Talao, Polynomial.
1304  */
1305 contract Foundation is OwnableUpdated {
1306 
1307     // Registered foundation factories.
1308     mapping(address => bool) public factories;
1309 
1310     // Owners (EOA) to contract addresses relationships.
1311     mapping(address => address) public ownersToContracts;
1312 
1313     // Contract addresses to owners relationships.
1314     mapping(address => address) public contractsToOwners;
1315 
1316     // Index of known contract addresses.
1317     address[] private contractsIndex;
1318 
1319     // Members (EOA) to contract addresses relationships.
1320     // In a Partnership.sol inherited contract, this allows us to create a
1321     // modifier for most read functions in this contract that will authorize
1322     // any account associated with an authorized Partnership contract.
1323     mapping(address => address) public membersToContracts;
1324 
1325     // Index of known members for each contract.
1326     // These are EOAs that were added once, even if removed now.
1327     mapping(address => address[]) public contractsToKnownMembersIndexes;
1328 
1329     // Events for factories.
1330     event FactoryAdded(address _factory);
1331     event FactoryRemoved(address _factory);
1332 
1333     /**
1334      * @dev Add a factory.
1335      */
1336     function addFactory(address _factory) external onlyOwner {
1337         factories[_factory] = true;
1338         emit FactoryAdded(_factory);
1339     }
1340 
1341     /**
1342      * @dev Remove a factory.
1343      */
1344     function removeFactory(address _factory) external onlyOwner {
1345         factories[_factory] = false;
1346         emit FactoryRemoved(_factory);
1347     }
1348 
1349     /**
1350      * @dev Modifier for factories.
1351      */
1352     modifier onlyFactory() {
1353         require(
1354             factories[msg.sender],
1355             "You are not a factory"
1356         );
1357         _;
1358     }
1359 
1360     /**
1361      * @dev Set initial owner of a contract.
1362      */
1363     function setInitialOwnerInFoundation(
1364         address _contract,
1365         address _account
1366     )
1367         external
1368         onlyFactory
1369     {
1370         require(
1371             contractsToOwners[_contract] == address(0),
1372             "Contract already has owner"
1373         );
1374         require(
1375             ownersToContracts[_account] == address(0),
1376             "Account already has contract"
1377         );
1378         contractsToOwners[_contract] = _account;
1379         contractsIndex.push(_contract);
1380         ownersToContracts[_account] = _contract;
1381         membersToContracts[_account] = _contract;
1382     }
1383 
1384     /**
1385      * @dev Transfer a contract to another account.
1386      */
1387     function transferOwnershipInFoundation(
1388         address _contract,
1389         address _newAccount
1390     )
1391         external
1392     {
1393         require(
1394             (
1395                 ownersToContracts[msg.sender] == _contract &&
1396                 contractsToOwners[_contract] == msg.sender
1397             ),
1398             "You are not the owner"
1399         );
1400         ownersToContracts[msg.sender] = address(0);
1401         membersToContracts[msg.sender] = address(0);
1402         ownersToContracts[_newAccount] = _contract;
1403         membersToContracts[_newAccount] = _contract;
1404         contractsToOwners[_contract] = _newAccount;
1405         // Remark: we do not update the contracts members.
1406         // It's the new owner's responsability to remove members, if needed.
1407     }
1408 
1409     /**
1410      * @dev Allows the current owner to relinquish control of the contract.
1411      * This is called through the contract.
1412      */
1413     function renounceOwnershipInFoundation() external returns (bool success) {
1414         // Remove members.
1415         delete(contractsToKnownMembersIndexes[msg.sender]);
1416         // Free the EOA, so he can become owner of a new contract.
1417         delete(ownersToContracts[contractsToOwners[msg.sender]]);
1418         // Assign the contract to no one.
1419         delete(contractsToOwners[msg.sender]);
1420         // Return.
1421         success = true;
1422     }
1423 
1424     /**
1425      * @dev Add a member EOA to a contract.
1426      */
1427     function addMember(address _member) external {
1428         require(
1429             ownersToContracts[msg.sender] != address(0),
1430             "You own no contract"
1431         );
1432         require(
1433             membersToContracts[_member] == address(0),
1434             "Address is already member of a contract"
1435         );
1436         membersToContracts[_member] = ownersToContracts[msg.sender];
1437         contractsToKnownMembersIndexes[ownersToContracts[msg.sender]].push(_member);
1438     }
1439 
1440     /**
1441      * @dev Remove a member EOA to a contract.
1442      */
1443     function removeMember(address _member) external {
1444         require(
1445             ownersToContracts[msg.sender] != address(0),
1446             "You own no contract"
1447         );
1448         require(
1449             membersToContracts[_member] == ownersToContracts[msg.sender],
1450             "Address is not member of this contract"
1451         );
1452         membersToContracts[_member] = address(0);
1453         contractsToKnownMembersIndexes[ownersToContracts[msg.sender]].push(_member);
1454     }
1455 
1456     /**
1457      * @dev Getter for contractsIndex.
1458      * The automatic getter can not return array.
1459      */
1460     function getContractsIndex()
1461         external
1462         onlyOwner
1463         view
1464         returns (address[])
1465     {
1466         return contractsIndex;
1467     }
1468 
1469     /**
1470      * @dev Prevents accidental sending of ether.
1471      */
1472     function() public {
1473         revert("Prevent accidental sending of ether");
1474     }
1475 }
1476 
1477 // File: contracts/identity/ERC735.sol
1478 
1479 /**
1480  * @title ERC735 Claim Holder
1481  * @notice Implementation by Origin Protocol
1482  * @dev https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/ERC735.sol
1483  */
1484 contract ERC735 {
1485 
1486     event ClaimRequested(
1487         uint256 indexed claimRequestId,
1488         uint256 indexed topic,
1489         uint256 scheme,
1490         address indexed issuer,
1491         bytes signature,
1492         bytes data,
1493         string uri
1494     );
1495     event ClaimAdded(
1496         bytes32 indexed claimId,
1497         uint256 indexed topic,
1498         uint256 scheme,
1499         address indexed issuer,
1500         bytes signature,
1501         bytes data,
1502         string uri
1503     );
1504     event ClaimRemoved(
1505         bytes32 indexed claimId,
1506         uint256 indexed topic,
1507         uint256 scheme,
1508         address indexed issuer,
1509         bytes signature,
1510         bytes data,
1511         string uri
1512     );
1513     event ClaimChanged(
1514         bytes32 indexed claimId,
1515         uint256 indexed topic,
1516         uint256 scheme,
1517         address indexed issuer,
1518         bytes signature,
1519         bytes data,
1520         string uri
1521     );
1522 
1523     struct Claim {
1524         uint256 topic;
1525         uint256 scheme;
1526         address issuer; // msg.sender
1527         bytes signature; // this.address + topic + data
1528         bytes data;
1529         string uri;
1530     }
1531 
1532     function getClaim(bytes32 _claimId)
1533         public view returns(uint256 topic, uint256 scheme, address issuer, bytes signature, bytes data, string uri);
1534     function getClaimIdsByTopic(uint256 _topic)
1535         public view returns(bytes32[] claimIds);
1536     function addClaim(uint256 _topic, uint256 _scheme, address issuer, bytes _signature, bytes _data, string _uri)
1537         public returns (bytes32 claimRequestId);
1538     function removeClaim(bytes32 _claimId)
1539         public returns (bool success);
1540 }
1541 
1542 // File: contracts/identity/ERC725.sol
1543 
1544 /**
1545  * @title ERC725 Proxy Identity
1546  * @notice Implementation by Origin Protocol
1547  * @dev https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/ERC725.sol
1548  */
1549 contract ERC725 {
1550 
1551     uint256 constant MANAGEMENT_KEY = 1;
1552     uint256 constant ACTION_KEY = 2;
1553     uint256 constant CLAIM_SIGNER_KEY = 3;
1554     uint256 constant ENCRYPTION_KEY = 4;
1555 
1556     event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
1557     event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
1558     event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
1559     event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
1560     event Approved(uint256 indexed executionId, bool approved);
1561 
1562     function getKey(bytes32 _key) public view returns(uint256[] purposes, uint256 keyType, bytes32 key);
1563     function keyHasPurpose(bytes32 _key, uint256 _purpose) public view returns (bool exists);
1564     function getKeysByPurpose(uint256 _purpose) public view returns(bytes32[] keys);
1565     function addKey(bytes32 _key, uint256 _purpose, uint256 _keyType) public returns (bool success);
1566     function removeKey(bytes32 _key, uint256 _purpose) public returns (bool success);
1567     function execute(address _to, uint256 _value, bytes _data) public returns (uint256 executionId);
1568     function approve(uint256 _id, bool _approve) public returns (bool success);
1569 }
1570 
1571 // File: contracts/identity/KeyHolderLibrary.sol
1572 
1573 /**
1574  * @title Library for KeyHolder.
1575  * @notice Fork of Origin Protocol's implementation at
1576  * https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/KeyHolderLibrary.sol
1577  * We want to add purpose to already existing key.
1578  * We do not want to have purpose J if you have purpose I and I < J
1579  * Exception: we want a key of purpose 1 to have all purposes.
1580  * @author Talao, Polynomial.
1581  */
1582 library KeyHolderLibrary {
1583     event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
1584     event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
1585     event PurposeAdded(bytes32 indexed key, uint256 indexed purpose);
1586     event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
1587     event ExecutionFailed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
1588     event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
1589     event Approved(uint256 indexed executionId, bool approved);
1590 
1591     struct Key {
1592         uint256[] purposes; //e.g., MANAGEMENT_KEY = 1, ACTION_KEY = 2, etc.
1593         uint256 keyType; // e.g. 1 = ECDSA, 2 = RSA, etc.
1594         bytes32 key;
1595     }
1596 
1597     struct KeyHolderData {
1598         uint256 executionNonce;
1599         mapping (bytes32 => Key) keys;
1600         mapping (uint256 => bytes32[]) keysByPurpose;
1601         mapping (uint256 => Execution) executions;
1602     }
1603 
1604     struct Execution {
1605         address to;
1606         uint256 value;
1607         bytes data;
1608         bool approved;
1609         bool executed;
1610     }
1611 
1612     function init(KeyHolderData storage _keyHolderData)
1613         public
1614     {
1615         bytes32 _key = keccak256(abi.encodePacked(msg.sender));
1616         _keyHolderData.keys[_key].key = _key;
1617         _keyHolderData.keys[_key].purposes.push(1);
1618         _keyHolderData.keys[_key].keyType = 1;
1619         _keyHolderData.keysByPurpose[1].push(_key);
1620         emit KeyAdded(_key, 1, 1);
1621     }
1622 
1623     function getKey(KeyHolderData storage _keyHolderData, bytes32 _key)
1624         public
1625         view
1626         returns(uint256[] purposes, uint256 keyType, bytes32 key)
1627     {
1628         return (
1629             _keyHolderData.keys[_key].purposes,
1630             _keyHolderData.keys[_key].keyType,
1631             _keyHolderData.keys[_key].key
1632         );
1633     }
1634 
1635     function getKeyPurposes(KeyHolderData storage _keyHolderData, bytes32 _key)
1636         public
1637         view
1638         returns(uint256[] purposes)
1639     {
1640         return (_keyHolderData.keys[_key].purposes);
1641     }
1642 
1643     function getKeysByPurpose(KeyHolderData storage _keyHolderData, uint256 _purpose)
1644         public
1645         view
1646         returns(bytes32[] _keys)
1647     {
1648         return _keyHolderData.keysByPurpose[_purpose];
1649     }
1650 
1651     function addKey(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose, uint256 _type)
1652         public
1653         returns (bool success)
1654     {
1655         require(_keyHolderData.keys[_key].key != _key, "Key already exists"); // Key should not already exist
1656         if (msg.sender != address(this)) {
1657             require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key"); // Sender has MANAGEMENT_KEY
1658         }
1659 
1660         _keyHolderData.keys[_key].key = _key;
1661         _keyHolderData.keys[_key].purposes.push(_purpose);
1662         _keyHolderData.keys[_key].keyType = _type;
1663 
1664         _keyHolderData.keysByPurpose[_purpose].push(_key);
1665 
1666         emit KeyAdded(_key, _purpose, _type);
1667 
1668         return true;
1669     }
1670 
1671     // We want to be able to add purpose to an existing key.
1672     function addPurpose(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose)
1673         public
1674         returns (bool)
1675     {
1676         require(_keyHolderData.keys[_key].key == _key, "Key does not exist"); // Key should already exist
1677         if (msg.sender != address(this)) {
1678             require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key"); // Sender has MANAGEMENT_KEY
1679         }
1680 
1681         _keyHolderData.keys[_key].purposes.push(_purpose);
1682 
1683         _keyHolderData.keysByPurpose[_purpose].push(_key);
1684 
1685         emit PurposeAdded(_key, _purpose);
1686 
1687         return true;
1688     }
1689 
1690     function approve(KeyHolderData storage _keyHolderData, uint256 _id, bool _approve)
1691         public
1692         returns (bool success)
1693     {
1694         require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 2), "Sender does not have action key");
1695         require(!_keyHolderData.executions[_id].executed, "Already executed");
1696 
1697         emit Approved(_id, _approve);
1698 
1699         if (_approve == true) {
1700             _keyHolderData.executions[_id].approved = true;
1701             success = _keyHolderData.executions[_id].to.call(_keyHolderData.executions[_id].data, 0);
1702             if (success) {
1703                 _keyHolderData.executions[_id].executed = true;
1704                 emit Executed(
1705                     _id,
1706                     _keyHolderData.executions[_id].to,
1707                     _keyHolderData.executions[_id].value,
1708                     _keyHolderData.executions[_id].data
1709                 );
1710                 return;
1711             } else {
1712                 emit ExecutionFailed(
1713                     _id,
1714                     _keyHolderData.executions[_id].to,
1715                     _keyHolderData.executions[_id].value,
1716                     _keyHolderData.executions[_id].data
1717                 );
1718                 return;
1719             }
1720         } else {
1721             _keyHolderData.executions[_id].approved = false;
1722         }
1723         return true;
1724     }
1725 
1726     function execute(KeyHolderData storage _keyHolderData, address _to, uint256 _value, bytes _data)
1727         public
1728         returns (uint256 executionId)
1729     {
1730         require(!_keyHolderData.executions[_keyHolderData.executionNonce].executed, "Already executed");
1731         _keyHolderData.executions[_keyHolderData.executionNonce].to = _to;
1732         _keyHolderData.executions[_keyHolderData.executionNonce].value = _value;
1733         _keyHolderData.executions[_keyHolderData.executionNonce].data = _data;
1734 
1735         emit ExecutionRequested(_keyHolderData.executionNonce, _to, _value, _data);
1736 
1737         if (
1738             keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)),1) ||
1739             keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)),2)
1740         ) {
1741             approve(_keyHolderData, _keyHolderData.executionNonce, true);
1742         }
1743 
1744         _keyHolderData.executionNonce++;
1745         return _keyHolderData.executionNonce-1;
1746     }
1747 
1748     function removeKey(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose)
1749         public
1750         returns (bool success)
1751     {
1752         if (msg.sender != address(this)) {
1753             require(keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key"); // Sender has MANAGEMENT_KEY
1754         }
1755 
1756         require(_keyHolderData.keys[_key].key == _key, "No such key");
1757         emit KeyRemoved(_key, _purpose, _keyHolderData.keys[_key].keyType);
1758 
1759         // Remove purpose from key
1760         uint256[] storage purposes = _keyHolderData.keys[_key].purposes;
1761         for (uint i = 0; i < purposes.length; i++) {
1762             if (purposes[i] == _purpose) {
1763                 purposes[i] = purposes[purposes.length - 1];
1764                 delete purposes[purposes.length - 1];
1765                 purposes.length--;
1766                 break;
1767             }
1768         }
1769 
1770         // If no more purposes, delete key
1771         if (purposes.length == 0) {
1772             delete _keyHolderData.keys[_key];
1773         }
1774 
1775         // Remove key from keysByPurpose
1776         bytes32[] storage keys = _keyHolderData.keysByPurpose[_purpose];
1777         for (uint j = 0; j < keys.length; j++) {
1778             if (keys[j] == _key) {
1779                 keys[j] = keys[keys.length - 1];
1780                 delete keys[keys.length - 1];
1781                 keys.length--;
1782                 break;
1783             }
1784         }
1785 
1786         return true;
1787     }
1788 
1789     function keyHasPurpose(KeyHolderData storage _keyHolderData, bytes32 _key, uint256 _purpose)
1790         public
1791         view
1792         returns(bool isThere)
1793     {
1794         if (_keyHolderData.keys[_key].key == 0) {
1795             isThere = false;
1796         }
1797 
1798         uint256[] storage purposes = _keyHolderData.keys[_key].purposes;
1799         for (uint i = 0; i < purposes.length; i++) {
1800             // We do not want to have purpose J if you have purpose I and I < J
1801             // Exception: we want purpose 1 to have all purposes.
1802             if (purposes[i] == _purpose || purposes[i] == 1) {
1803                 isThere = true;
1804                 break;
1805             }
1806         }
1807     }
1808 }
1809 
1810 // File: contracts/identity/KeyHolder.sol
1811 
1812 /**
1813  * @title Manages an ERC 725 identity keys.
1814  * @notice Fork of Origin Protocol's implementation at
1815  * https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/KeyHolder.sol
1816  *
1817  * We defined our own set of "sub-ACTION" keys:
1818  * - 20001 = read private profile & documents (grants isReader()).
1819  *  Usefull for contracts, for instance to add import contracts.
1820  * - 20002 = write "Private profile" & Documents (except issueDocument)
1821  * - 20003 = read Partnerships
1822  * - 20004 = blacklist / unblacklist for identityboxSendtext/identityboxSendfile
1823  * We also use:
1824  * - 3 = CLAIM = to issueDocument
1825  *
1826  * Moreover we can add purpose to already existing key.
1827  */
1828 contract KeyHolder is ERC725 {
1829     KeyHolderLibrary.KeyHolderData keyHolderData;
1830 
1831     constructor() public {
1832         KeyHolderLibrary.init(keyHolderData);
1833     }
1834 
1835     function getKey(bytes32 _key)
1836         public
1837         view
1838         returns(uint256[] purposes, uint256 keyType, bytes32 key)
1839     {
1840         return KeyHolderLibrary.getKey(keyHolderData, _key);
1841     }
1842 
1843     function getKeyPurposes(bytes32 _key)
1844         public
1845         view
1846         returns(uint256[] purposes)
1847     {
1848         return KeyHolderLibrary.getKeyPurposes(keyHolderData, _key);
1849     }
1850 
1851     function getKeysByPurpose(uint256 _purpose)
1852         public
1853         view
1854         returns(bytes32[] _keys)
1855     {
1856         return KeyHolderLibrary.getKeysByPurpose(keyHolderData, _purpose);
1857     }
1858 
1859     function addKey(bytes32 _key, uint256 _purpose, uint256 _type)
1860         public
1861         returns (bool success)
1862     {
1863         return KeyHolderLibrary.addKey(keyHolderData, _key, _purpose, _type);
1864     }
1865 
1866     function addPurpose(bytes32 _key, uint256 _purpose)
1867         public
1868         returns (bool)
1869     {
1870         return KeyHolderLibrary.addPurpose(keyHolderData, _key, _purpose);
1871     }
1872 
1873     function approve(uint256 _id, bool _approve)
1874         public
1875         returns (bool success)
1876     {
1877         return KeyHolderLibrary.approve(keyHolderData, _id, _approve);
1878     }
1879 
1880     function execute(address _to, uint256 _value, bytes _data)
1881         public
1882         returns (uint256 executionId)
1883     {
1884         return KeyHolderLibrary.execute(keyHolderData, _to, _value, _data);
1885     }
1886 
1887     function removeKey(bytes32 _key, uint256 _purpose)
1888         public
1889         returns (bool success)
1890     {
1891         return KeyHolderLibrary.removeKey(keyHolderData, _key, _purpose);
1892     }
1893 
1894     function keyHasPurpose(bytes32 _key, uint256 _purpose)
1895         public
1896         view
1897         returns(bool exists)
1898     {
1899         return KeyHolderLibrary.keyHasPurpose(keyHolderData, _key, _purpose);
1900     }
1901 
1902 }
1903 
1904 // File: contracts/identity/ClaimHolderLibrary.sol
1905 
1906 /**
1907  * @title Library for ClaimHolder.
1908  * @notice Fork of Origin Protocol's implementation at
1909  * https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/ClaimHolderLibrary.sol
1910  * @author Talao, Polynomial.
1911  */
1912 library ClaimHolderLibrary {
1913     event ClaimAdded(
1914         bytes32 indexed claimId,
1915         uint256 indexed topic,
1916         uint256 scheme,
1917         address indexed issuer,
1918         bytes signature,
1919         bytes data,
1920         string uri
1921     );
1922     event ClaimRemoved(
1923         bytes32 indexed claimId,
1924         uint256 indexed topic,
1925         uint256 scheme,
1926         address indexed issuer,
1927         bytes signature,
1928         bytes data,
1929         string uri
1930     );
1931 
1932     struct Claim {
1933         uint256 topic;
1934         uint256 scheme;
1935         address issuer; // msg.sender
1936         bytes signature; // this.address + topic + data
1937         bytes data;
1938         string uri;
1939     }
1940 
1941     struct Claims {
1942         mapping (bytes32 => Claim) byId;
1943         mapping (uint256 => bytes32[]) byTopic;
1944     }
1945 
1946     function addClaim(
1947         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
1948         Claims storage _claims,
1949         uint256 _topic,
1950         uint256 _scheme,
1951         address _issuer,
1952         bytes _signature,
1953         bytes _data,
1954         string _uri
1955     )
1956         public
1957         returns (bytes32 claimRequestId)
1958     {
1959         if (msg.sender != address(this)) {
1960             require(KeyHolderLibrary.keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 3), "Sender does not have claim signer key");
1961         }
1962 
1963         bytes32 claimId = keccak256(abi.encodePacked(_issuer, _topic));
1964 
1965         if (_claims.byId[claimId].issuer != _issuer) {
1966             _claims.byTopic[_topic].push(claimId);
1967         }
1968 
1969         _claims.byId[claimId].topic = _topic;
1970         _claims.byId[claimId].scheme = _scheme;
1971         _claims.byId[claimId].issuer = _issuer;
1972         _claims.byId[claimId].signature = _signature;
1973         _claims.byId[claimId].data = _data;
1974         _claims.byId[claimId].uri = _uri;
1975 
1976         emit ClaimAdded(
1977             claimId,
1978             _topic,
1979             _scheme,
1980             _issuer,
1981             _signature,
1982             _data,
1983             _uri
1984         );
1985 
1986         return claimId;
1987     }
1988 
1989     /**
1990      * @dev Slightly modified version of Origin Protocol's implementation.
1991      * getBytes for signature was originally getBytes(_signature, (i * 65), 65)
1992      * and now isgetBytes(_signature, (i * 32), 32)
1993      * and if signature is empty, just return empty.
1994      */
1995     function addClaims(
1996         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
1997         Claims storage _claims,
1998         uint256[] _topic,
1999         address[] _issuer,
2000         bytes _signature,
2001         bytes _data,
2002         uint256[] _offsets
2003     )
2004         public
2005     {
2006         uint offset = 0;
2007         for (uint16 i = 0; i < _topic.length; i++) {
2008             if (_signature.length > 0) {
2009                 addClaim(
2010                     _keyHolderData,
2011                     _claims,
2012                     _topic[i],
2013                     1,
2014                     _issuer[i],
2015                     getBytes(_signature, (i * 32), 32),
2016                     getBytes(_data, offset, _offsets[i]),
2017                     ""
2018                 );
2019             } else {
2020                 addClaim(
2021                     _keyHolderData,
2022                     _claims,
2023                     _topic[i],
2024                     1,
2025                     _issuer[i],
2026                     "",
2027                     getBytes(_data, offset, _offsets[i]),
2028                     ""
2029                 );
2030             }
2031             offset += _offsets[i];
2032         }
2033     }
2034 
2035     function removeClaim(
2036         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
2037         Claims storage _claims,
2038         bytes32 _claimId
2039     )
2040         public
2041         returns (bool success)
2042     {
2043         if (msg.sender != address(this)) {
2044             require(KeyHolderLibrary.keyHasPurpose(_keyHolderData, keccak256(abi.encodePacked(msg.sender)), 1), "Sender does not have management key");
2045         }
2046 
2047         emit ClaimRemoved(
2048             _claimId,
2049             _claims.byId[_claimId].topic,
2050             _claims.byId[_claimId].scheme,
2051             _claims.byId[_claimId].issuer,
2052             _claims.byId[_claimId].signature,
2053             _claims.byId[_claimId].data,
2054             _claims.byId[_claimId].uri
2055         );
2056 
2057         delete _claims.byId[_claimId];
2058         return true;
2059     }
2060 
2061     /**
2062      * @dev "Update" self-claims.
2063      */
2064     function updateSelfClaims(
2065         KeyHolderLibrary.KeyHolderData storage _keyHolderData,
2066         Claims storage _claims,
2067         uint256[] _topic,
2068         bytes _data,
2069         uint256[] _offsets
2070     )
2071         public
2072     {
2073         uint offset = 0;
2074         for (uint16 i = 0; i < _topic.length; i++) {
2075             removeClaim(
2076                 _keyHolderData,
2077                 _claims,
2078                 keccak256(abi.encodePacked(msg.sender, _topic[i]))
2079             );
2080             addClaim(
2081                 _keyHolderData,
2082                 _claims,
2083                 _topic[i],
2084                 1,
2085                 msg.sender,
2086                 "",
2087                 getBytes(_data, offset, _offsets[i]),
2088                 ""
2089             );
2090             offset += _offsets[i];
2091         }
2092     }
2093 
2094     function getClaim(Claims storage _claims, bytes32 _claimId)
2095         public
2096         view
2097         returns(
2098           uint256 topic,
2099           uint256 scheme,
2100           address issuer,
2101           bytes signature,
2102           bytes data,
2103           string uri
2104         )
2105     {
2106         return (
2107             _claims.byId[_claimId].topic,
2108             _claims.byId[_claimId].scheme,
2109             _claims.byId[_claimId].issuer,
2110             _claims.byId[_claimId].signature,
2111             _claims.byId[_claimId].data,
2112             _claims.byId[_claimId].uri
2113         );
2114     }
2115 
2116     function getBytes(bytes _str, uint256 _offset, uint256 _length)
2117         internal
2118         pure
2119         returns (bytes)
2120     {
2121         bytes memory sig = new bytes(_length);
2122         uint256 j = 0;
2123         for (uint256 k = _offset; k < _offset + _length; k++) {
2124             sig[j] = _str[k];
2125             j++;
2126         }
2127         return sig;
2128     }
2129 }
2130 
2131 // File: contracts/identity/ClaimHolder.sol
2132 
2133 /**
2134  * @title Manages ERC 735 claims.
2135  * @notice Fork of Origin Protocol's implementation at
2136  * https://github.com/OriginProtocol/origin/blob/master/origin-contracts/contracts/identity/ClaimHolder.sol
2137  * @author Talao, Polynomial.
2138  */
2139 contract ClaimHolder is KeyHolder, ERC735 {
2140 
2141     ClaimHolderLibrary.Claims claims;
2142 
2143     function addClaim(
2144         uint256 _topic,
2145         uint256 _scheme,
2146         address _issuer,
2147         bytes _signature,
2148         bytes _data,
2149         string _uri
2150     )
2151         public
2152         returns (bytes32 claimRequestId)
2153     {
2154         return ClaimHolderLibrary.addClaim(
2155             keyHolderData,
2156             claims,
2157             _topic,
2158             _scheme,
2159             _issuer,
2160             _signature,
2161             _data,
2162             _uri
2163         );
2164     }
2165 
2166     function addClaims(
2167         uint256[] _topic,
2168         address[] _issuer,
2169         bytes _signature,
2170         bytes _data,
2171         uint256[] _offsets
2172     )
2173         public
2174     {
2175         ClaimHolderLibrary.addClaims(
2176             keyHolderData,
2177             claims,
2178             _topic,
2179             _issuer,
2180             _signature,
2181             _data,
2182             _offsets
2183         );
2184     }
2185 
2186     function removeClaim(bytes32 _claimId) public returns (bool success) {
2187         return ClaimHolderLibrary.removeClaim(keyHolderData, claims, _claimId);
2188     }
2189 
2190     function updateSelfClaims(
2191         uint256[] _topic,
2192         bytes _data,
2193         uint256[] _offsets
2194     )
2195         public
2196     {
2197         ClaimHolderLibrary.updateSelfClaims(
2198             keyHolderData,
2199             claims,
2200             _topic,
2201             _data,
2202             _offsets
2203         );
2204     }
2205 
2206     function getClaim(bytes32 _claimId)
2207         public
2208         view
2209         returns(
2210             uint256 topic,
2211             uint256 scheme,
2212             address issuer,
2213             bytes signature,
2214             bytes data,
2215             string uri
2216         )
2217     {
2218         return ClaimHolderLibrary.getClaim(claims, _claimId);
2219     }
2220 
2221     function getClaimIdsByTopic(uint256 _topic)
2222         public
2223         view
2224         returns(bytes32[] claimIds)
2225     {
2226         return claims.byTopic[_topic];
2227     }
2228 }
2229 
2230 // File: contracts/identity/Identity.sol
2231 
2232 /**
2233  * @title The Identity is where ERC 725/735 and our custom code meet.
2234  * @author Talao, Polynomial.
2235  * @notice Mixes ERC 725/735, foundation, token,
2236  * constructor values that never change (creator, category, encryption keys)
2237  * and provides a box to receive decentralized files and texts.
2238  */
2239 contract Identity is ClaimHolder {
2240 
2241     // Foundation contract.
2242     Foundation foundation;
2243 
2244     // Talao token contract.
2245     TalaoToken public token;
2246 
2247     // Identity information struct.
2248     struct IdentityInformation {
2249         // Address of this contract creator (factory).
2250         // bytes16 left on SSTORAGE 1 after this.
2251         address creator;
2252 
2253         // Identity category.
2254         // 1001 => 1999: Freelancer.
2255         // 2001 => 2999: Freelancer team.
2256         // 3001 => 3999: Corporate marketplace.
2257         // 4001 => 4999: Public marketplace.
2258         // 5001 => 5999: Service provider.
2259         // ..
2260         // 64001 => 64999: ?
2261         // bytes14 left after this on SSTORAGE 1.
2262         uint16 category;
2263 
2264         // Asymetric encryption key algorithm.
2265         // We use an integer to store algo with offchain references.
2266         // 1 => RSA 2048
2267         // bytes12 left after this on SSTORAGE 1.
2268         uint16 asymetricEncryptionAlgorithm;
2269 
2270         // Symetric encryption key algorithm.
2271         // We use an integer to store algo with offchain references.
2272         // 1 => AES 128
2273         // bytes10 left after this on SSTORAGE 1.
2274         uint16 symetricEncryptionAlgorithm;
2275 
2276         // Asymetric encryption public key.
2277         // This one can be used to encrypt content especially for this
2278         // contract owner, which is the only one to have the private key,
2279         // offchain of course.
2280         bytes asymetricEncryptionPublicKey;
2281 
2282         // Encrypted symetric encryption key (in Hex).
2283         // When decrypted, this passphrase can regenerate
2284         // the symetric encryption key.
2285         // This key encrypts and decrypts data to be shared with many people.
2286         // Uses 0.5 SSTORAGE for AES 128.
2287         bytes symetricEncryptionEncryptedKey;
2288 
2289         // Other encrypted secret we might use.
2290         bytes encryptedSecret;
2291     }
2292     // This contract Identity information.
2293     IdentityInformation public identityInformation;
2294 
2295     // Identity box: blacklisted addresses.
2296     mapping(address => bool) public identityboxBlacklisted;
2297 
2298     // Identity box: event when someone sent us a text.
2299     event TextReceived (
2300         address indexed sender,
2301         uint indexed category,
2302         bytes text
2303     );
2304 
2305     // Identity box: event when someone sent us an decentralized file.
2306     event FileReceived (
2307         address indexed sender,
2308         uint indexed fileType,
2309         uint fileEngine,
2310         bytes fileHash
2311     );
2312 
2313     /**
2314      * @dev Constructor.
2315      */
2316     constructor(
2317         address _foundation,
2318         address _token,
2319         uint16 _category,
2320         uint16 _asymetricEncryptionAlgorithm,
2321         uint16 _symetricEncryptionAlgorithm,
2322         bytes _asymetricEncryptionPublicKey,
2323         bytes _symetricEncryptionEncryptedKey,
2324         bytes _encryptedSecret
2325     )
2326         public
2327     {
2328         foundation = Foundation(_foundation);
2329         token = TalaoToken(_token);
2330         identityInformation.creator = msg.sender;
2331         identityInformation.category = _category;
2332         identityInformation.asymetricEncryptionAlgorithm = _asymetricEncryptionAlgorithm;
2333         identityInformation.symetricEncryptionAlgorithm = _symetricEncryptionAlgorithm;
2334         identityInformation.asymetricEncryptionPublicKey = _asymetricEncryptionPublicKey;
2335         identityInformation.symetricEncryptionEncryptedKey = _symetricEncryptionEncryptedKey;
2336         identityInformation.encryptedSecret = _encryptedSecret;
2337     }
2338 
2339     /**
2340      * @dev Owner of this contract, in the Foundation sense.
2341      * We do not allow this to be used externally,
2342      * since a contract could fake ownership.
2343      * In other contracts, you have to call the Foundation to
2344      * know the real owner of this contract.
2345      */
2346     function identityOwner() internal view returns (address) {
2347         return foundation.contractsToOwners(address(this));
2348     }
2349 
2350     /**
2351      * @dev Check in Foundation if msg.sender is the owner of this contract.
2352      * Same remark.
2353      */
2354     function isIdentityOwner() internal view returns (bool) {
2355         return msg.sender == identityOwner();
2356     }
2357 
2358     /**
2359      * @dev Modifier version of isIdentityOwner.
2360      */
2361     modifier onlyIdentityOwner() {
2362         require(isIdentityOwner(), "Access denied");
2363         _;
2364     }
2365 
2366     /**
2367      * @dev Owner functions require open Vault in token.
2368      */
2369     function isActiveIdentityOwner() public view returns (bool) {
2370         return isIdentityOwner() && token.hasVaultAccess(msg.sender, msg.sender);
2371     }
2372 
2373     /**
2374      * @dev Modifier version of isActiveOwner.
2375      */
2376     modifier onlyActiveIdentityOwner() {
2377         require(isActiveIdentityOwner(), "Access denied");
2378         _;
2379     }
2380 
2381     /**
2382      * @dev Does this contract owner have an open Vault in the token?
2383      */
2384     function isActiveIdentity() public view returns (bool) {
2385         return token.hasVaultAccess(identityOwner(), identityOwner());
2386     }
2387 
2388     /**
2389      * @dev Does msg.sender have an ERC 725 key with certain purpose,
2390      * and does the contract owner have an open Vault in the token?
2391      */
2392     function hasIdentityPurpose(uint256 _purpose) public view returns (bool) {
2393         return (
2394             keyHasPurpose(keccak256(abi.encodePacked(msg.sender)), _purpose) &&
2395             isActiveIdentity()
2396         );
2397     }
2398 
2399     /**
2400      * @dev Modifier version of hasKeyForPurpose
2401      */
2402     modifier onlyIdentityPurpose(uint256 _purpose) {
2403         require(hasIdentityPurpose(_purpose), "Access denied");
2404         _;
2405     }
2406 
2407     /**
2408      * @dev "Send" a text to this contract.
2409      * Text can be encrypted on this contract asymetricEncryptionPublicKey,
2410      * before submitting a TX here.
2411      */
2412     function identityboxSendtext(uint _category, bytes _text) external {
2413         require(!identityboxBlacklisted[msg.sender], "You are blacklisted");
2414         emit TextReceived(msg.sender, _category, _text);
2415     }
2416 
2417     /**
2418      * @dev "Send" a "file" to this contract.
2419      * File should be encrypted on this contract asymetricEncryptionPublicKey,
2420      * before upload on decentralized file storage,
2421      * before submitting a TX here.
2422      */
2423     function identityboxSendfile(
2424         uint _fileType, uint _fileEngine, bytes _fileHash
2425     )
2426         external
2427     {
2428         require(!identityboxBlacklisted[msg.sender], "You are blacklisted");
2429         emit FileReceived(msg.sender, _fileType, _fileEngine, _fileHash);
2430     }
2431 
2432     /**
2433      * @dev Blacklist an address in this Identity box.
2434      */
2435     function identityboxBlacklist(address _address)
2436         external
2437         onlyIdentityPurpose(20004)
2438     {
2439         identityboxBlacklisted[_address] = true;
2440     }
2441 
2442     /**
2443      * @dev Unblacklist.
2444      */
2445     function identityboxUnblacklist(address _address)
2446         external
2447         onlyIdentityPurpose(20004)
2448     {
2449         identityboxBlacklisted[_address] = false;
2450     }
2451 }
2452 
2453 /**
2454  * @title Interface with clones or inherited contracts.
2455  */
2456 interface IdentityInterface {
2457     function identityInformation()
2458         external
2459         view
2460         returns (address, uint16, uint16, uint16, bytes, bytes, bytes);
2461     function identityboxSendtext(uint, bytes) external;
2462 }
2463 
2464 // File: contracts/math/SafeMathUpdated.sol
2465 
2466 /**
2467  * @title SafeMath
2468  * @dev Math operations with safety checks that throw on error
2469  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
2470  */
2471 library SafeMathUpdated {
2472     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2473         if (a == 0) {
2474             return 0;
2475         }
2476         uint256 c = a * b;
2477         assert(c / a == b);
2478         return c;
2479     }
2480 
2481     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2482         uint256 c = a / b;
2483         return c;
2484     }
2485 
2486     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2487         assert(b <= a);
2488         return a - b;
2489     }
2490 
2491     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2492         uint256 c = a + b;
2493         assert(c >= a);
2494         return c;
2495     }
2496 }
2497 
2498 // File: contracts/access/Partnership.sol
2499 
2500 /**
2501  * @title Provides partnership features between contracts.
2502  * @notice If msg.sender is the owner, in the Foundation sense
2503  * (see Foundation.sol, of another partnership contract that is
2504  * authorized in this partnership contract,
2505  * then he passes isPartnershipMember().
2506  * Obviously this function is meant to be used in modifiers
2507  * in contrats that inherit of this one and provide "restricted" content.
2508  * Partnerships are symetrical: when you request a partnership,
2509  * you automatically authorize the requested partnership contract.
2510  * Same thing when you remove a partnership.
2511  * This is done through symetrical functions,
2512  * where the user submits a tx on his own Partnership contract to ask partnership
2513  * to another and not on the other contract.
2514  * Convention here: _function = to be called by another partnership contract.
2515  * @author Talao, Polynomial.
2516  */
2517 contract Partnership is Identity {
2518 
2519     using SafeMathUpdated for uint;
2520 
2521     // Foundation contract.
2522     Foundation foundation;
2523 
2524     // Authorization status.
2525     enum PartnershipAuthorization { Unknown, Authorized, Pending, Rejected, Removed }
2526 
2527     // Other Partnership contract information.
2528     struct PartnershipContract {
2529         // Authorization of this contract.
2530         // bytes31 left after this on SSTORAGE 1.
2531         PartnershipAuthorization authorization;
2532         // Date of partnership creation.
2533         // Let's avoid the 2038 year bug, even if this contract will be dead
2534         // a lot sooner! It costs nothing, so...
2535         // bytes26 left after this on SSTORAGE 1.
2536         uint40 created;
2537         // His symetric encryption key,
2538         // encrypted on our asymetric encryption public key.
2539         bytes symetricEncryptionEncryptedKey;
2540     }
2541     // Our main registry of Partnership contracts.
2542     mapping(address => PartnershipContract) internal partnershipContracts;
2543 
2544     // Index of known partnerships (contracts which interacted at least once).
2545     address[] internal knownPartnershipContracts;
2546 
2547     // Total of authorized Partnerships contracts.
2548     uint public partnershipsNumber;
2549 
2550     // Event when another Partnership contract has asked partnership.
2551     event PartnershipRequested();
2552 
2553     // Event when another Partnership contract has authorized our request.
2554     event PartnershipAccepted();
2555 
2556     /**
2557      * @dev Constructor.
2558      */
2559     constructor(
2560         address _foundation,
2561         address _token,
2562         uint16 _category,
2563         uint16 _asymetricEncryptionAlgorithm,
2564         uint16 _symetricEncryptionAlgorithm,
2565         bytes _asymetricEncryptionPublicKey,
2566         bytes _symetricEncryptionEncryptedKey,
2567         bytes _encryptedSecret
2568     )
2569         Identity(
2570             _foundation,
2571             _token,
2572             _category,
2573             _asymetricEncryptionAlgorithm,
2574             _symetricEncryptionAlgorithm,
2575             _asymetricEncryptionPublicKey,
2576             _symetricEncryptionEncryptedKey,
2577             _encryptedSecret
2578         )
2579         public
2580     {
2581         foundation = Foundation(_foundation);
2582         token = TalaoToken(_token);
2583         identityInformation.creator = msg.sender;
2584         identityInformation.category = _category;
2585         identityInformation.asymetricEncryptionAlgorithm = _asymetricEncryptionAlgorithm;
2586         identityInformation.symetricEncryptionAlgorithm = _symetricEncryptionAlgorithm;
2587         identityInformation.asymetricEncryptionPublicKey = _asymetricEncryptionPublicKey;
2588         identityInformation.symetricEncryptionEncryptedKey = _symetricEncryptionEncryptedKey;
2589         identityInformation.encryptedSecret = _encryptedSecret;
2590     }
2591 
2592     /**
2593      * @dev This function will be used in inherited contracts,
2594      * to restrict read access to members of Partnership contracts
2595      * which are authorized in this contract.
2596      */
2597     function isPartnershipMember() public view returns (bool) {
2598         return partnershipContracts[foundation.membersToContracts(msg.sender)].authorization == PartnershipAuthorization.Authorized;
2599     }
2600 
2601     /**
2602      * @dev Modifier version of isPartnershipMember.
2603      * Not used for now, but could be useful.
2604      */
2605     modifier onlyPartnershipMember() {
2606         require(isPartnershipMember());
2607         _;
2608     }
2609 
2610     /**
2611      * @dev Get partnership status in this contract for a user.
2612      */
2613     function getMyPartnershipStatus()
2614         external
2615         view
2616         returns (uint authorization)
2617     {
2618         // If msg.sender has no Partnership contract, return Unknown (0).
2619         if (foundation.membersToContracts(msg.sender) == address(0)) {
2620             return uint(PartnershipAuthorization.Unknown);
2621         } else {
2622             return uint(partnershipContracts[foundation.membersToContracts(msg.sender)].authorization);
2623         }
2624     }
2625 
2626     /**
2627      * @dev Get the list of all known Partnership contracts.
2628      */
2629     function getKnownPartnershipsContracts()
2630         external
2631         view
2632         onlyIdentityPurpose(20003)
2633         returns (address[])
2634     {
2635         return knownPartnershipContracts;
2636     }
2637 
2638     /**
2639      * @dev Get a Partnership contract information.
2640      */
2641     function getPartnership(address _hisContract)
2642         external
2643         view
2644         onlyIdentityPurpose(20003)
2645         returns (uint, uint, uint40, bytes, bytes)
2646     {
2647         (
2648             ,
2649             uint16 hisCategory,
2650             ,
2651             ,
2652             bytes memory hisAsymetricEncryptionPublicKey,
2653             ,
2654         ) = IdentityInterface(_hisContract).identityInformation();
2655         return (
2656             hisCategory,
2657             uint(partnershipContracts[_hisContract].authorization),
2658             partnershipContracts[_hisContract].created,
2659             hisAsymetricEncryptionPublicKey,
2660             partnershipContracts[_hisContract].symetricEncryptionEncryptedKey
2661         );
2662     }
2663 
2664     /**
2665      * @dev Request partnership.
2666      * The owner of this contract requests a partnership
2667      * with another Partnership contract
2668      * through THIS contract.
2669      * We send him our symetric encryption key as well,
2670      * encrypted on his symetric encryption public key.
2671      * Encryption done offchain before submitting this TX.
2672      */
2673     function requestPartnership(address _hisContract, bytes _ourSymetricKey)
2674         external
2675         onlyIdentityPurpose(1)
2676     {
2677         // We can only request partnership with a contract
2678         // if he's not already Known or Removed in our registry.
2679         // If he is, we symetrically are already in his partnerships.
2680         // Indeed when he asked a partnership with us,
2681         // he added us in authorized partnerships.
2682         require(
2683             partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Unknown ||
2684             partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Removed
2685         );
2686         // Request partnership in the other contract.
2687         // Open interface on his contract.
2688         PartnershipInterface hisInterface = PartnershipInterface(_hisContract);
2689         bool success = hisInterface._requestPartnership(_ourSymetricKey);
2690         // If partnership request was a success,
2691         if (success) {
2692             // If we do not know the Partnership contract yet,
2693             if (partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Unknown) {
2694                 // Then add it to our partnerships index.
2695                 knownPartnershipContracts.push(_hisContract);
2696             }
2697             // Authorize Partnership contract in our contract.
2698             partnershipContracts[_hisContract].authorization = PartnershipAuthorization.Authorized;
2699             // Record date of partnership creation.
2700             partnershipContracts[_hisContract].created = uint40(now);
2701             // Give the Partnership contrat's owner an ERC 725 "Claim" key.
2702             addKey(keccak256(abi.encodePacked(foundation.contractsToOwners(_hisContract))), 3, 1);
2703             // Give the Partnership contract an ERC 725 "Claim" key.
2704             addKey(keccak256(abi.encodePacked(_hisContract)), 3, 1);
2705             // Increment our number of partnerships.
2706             partnershipsNumber = partnershipsNumber.add(1);
2707         }
2708     }
2709 
2710     /**
2711      * @dev Symetry of requestPartnership.
2712      * Called by Partnership contract wanting to partnership.
2713      * He sends us his symetric encryption key as well,
2714      * encrypted on our symetric encryption public key.
2715      * So we can decipher all his content.
2716      */
2717     function _requestPartnership(bytes _hisSymetricKey)
2718         external
2719         returns (bool success)
2720     {
2721         require(
2722             partnershipContracts[msg.sender].authorization == PartnershipAuthorization.Unknown ||
2723             partnershipContracts[msg.sender].authorization == PartnershipAuthorization.Removed
2724         );
2725         // If this Partnership contract is Unknown,
2726         if (partnershipContracts[msg.sender].authorization == PartnershipAuthorization.Unknown) {
2727             // Add the new partnership to our partnerships index.
2728             knownPartnershipContracts.push(msg.sender);
2729             // Record date of partnership creation.
2730             partnershipContracts[msg.sender].created = uint40(now);
2731         }
2732         // Write Pending to our partnerships contract registry.
2733         partnershipContracts[msg.sender].authorization = PartnershipAuthorization.Pending;
2734         // Record his symetric encryption key,
2735         // encrypted on our asymetric encryption public key.
2736         partnershipContracts[msg.sender].symetricEncryptionEncryptedKey = _hisSymetricKey;
2737         // Event for this contrat owner's UI.
2738         emit PartnershipRequested();
2739         // Return success.
2740         success = true;
2741     }
2742 
2743     /**
2744      * @dev Authorize Partnership.
2745      * Before submitting this TX, we must have encrypted our
2746      * symetric encryption key on his asymetric encryption public key.
2747      */
2748     function authorizePartnership(address _hisContract, bytes _ourSymetricKey)
2749         external
2750         onlyIdentityPurpose(1)
2751     {
2752         require(
2753             partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Pending,
2754             "Partnership must be Pending"
2755         );
2756         // Authorize the Partnership contract in our contract.
2757         partnershipContracts[_hisContract].authorization = PartnershipAuthorization.Authorized;
2758         // Record the date of partnership creation.
2759         partnershipContracts[_hisContract].created = uint40(now);
2760         // Give the Partnership contrat's owner an ERC 725 "Claim" key.
2761         addKey(keccak256(abi.encodePacked(foundation.contractsToOwners(_hisContract))), 3, 1);
2762         // Give the Partnership contract an ERC 725 "Claim" key.
2763         addKey(keccak256(abi.encodePacked(_hisContract)), 3, 1);
2764         // Increment our number of partnerships.
2765         partnershipsNumber = partnershipsNumber.add(1);
2766         // Log an event in the new authorized partner contract.
2767         PartnershipInterface hisInterface = PartnershipInterface(_hisContract);
2768         hisInterface._authorizePartnership(_ourSymetricKey);
2769     }
2770 
2771     /**
2772      * @dev Allows other Partnership contract to send an event when authorizing.
2773      * He sends us also his symetric encryption key,
2774      * encrypted on our asymetric encryption public key.
2775      */
2776     function _authorizePartnership(bytes _hisSymetricKey) external {
2777         require(
2778             partnershipContracts[msg.sender].authorization == PartnershipAuthorization.Authorized,
2779             "You have no authorized partnership"
2780         );
2781         partnershipContracts[msg.sender].symetricEncryptionEncryptedKey = _hisSymetricKey;
2782         emit PartnershipAccepted();
2783     }
2784 
2785     /**
2786      * @dev Reject Partnership.
2787      */
2788     function rejectPartnership(address _hisContract)
2789         external
2790         onlyIdentityPurpose(1)
2791     {
2792         require(
2793             partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Pending,
2794             "Partner must be Pending"
2795         );
2796         partnershipContracts[_hisContract].authorization = PartnershipAuthorization.Rejected;
2797     }
2798 
2799     /**
2800      * @dev Remove Partnership.
2801      */
2802     function removePartnership(address _hisContract)
2803         external
2804         onlyIdentityPurpose(1)
2805     {
2806         require(
2807             (
2808                 partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Authorized ||
2809                 partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Rejected
2810             ),
2811             "Partnership must be Authorized or Rejected"
2812         );
2813         // Remove ourselves in the other Partnership contract.
2814         PartnershipInterface hisInterface = PartnershipInterface(_hisContract);
2815         bool success = hisInterface._removePartnership();
2816         // If success,
2817         if (success) {
2818             // If it was an authorized partnership,
2819             if (partnershipContracts[_hisContract].authorization == PartnershipAuthorization.Authorized) {
2820                 // Remove the partnership creation date.
2821                 delete partnershipContracts[_hisContract].created;
2822                 // Remove his symetric encryption key.
2823                 delete partnershipContracts[_hisContract].symetricEncryptionEncryptedKey;
2824                 // Decrement our number of partnerships.
2825                 partnershipsNumber = partnershipsNumber.sub(1);
2826             }
2827             // If there is one, remove ERC 725 "Claim" key for Partnership contract owner.
2828             if (keyHasPurpose(keccak256(abi.encodePacked(foundation.contractsToOwners(_hisContract))), 3)) {
2829                 removeKey(keccak256(abi.encodePacked(foundation.contractsToOwners(_hisContract))), 3);
2830             }
2831             // If there is one, remove ERC 725 "Claim" key for Partnership contract.
2832             if (keyHasPurpose(keccak256(abi.encodePacked(_hisContract)), 3)) {
2833                 removeKey(keccak256(abi.encodePacked(_hisContract)), 3);
2834             }
2835             // Change his partnership to Removed in our contract.
2836             // We want to have Removed instead of resetting to Unknown,
2837             // otherwise if partnership is initiated again with him,
2838             // our knownPartnershipContracts would have a duplicate entry.
2839             partnershipContracts[_hisContract].authorization = PartnershipAuthorization.Removed;
2840         }
2841     }
2842 
2843     /**
2844      * @dev Symetry of removePartnership.
2845      * Called by the Partnership contract breaking partnership with us.
2846      */
2847     function _removePartnership() external returns (bool success) {
2848         // He wants to break partnership with us, so we break too.
2849         // If it was an authorized partnership,
2850         if (partnershipContracts[msg.sender].authorization == PartnershipAuthorization.Authorized) {
2851             // Remove date of partnership creation.
2852             delete partnershipContracts[msg.sender].created;
2853             // Remove his symetric encryption key.
2854             delete partnershipContracts[msg.sender].symetricEncryptionEncryptedKey;
2855             // Decrement our number of partnerships.
2856             partnershipsNumber = partnershipsNumber.sub(1);
2857         }
2858         // Would have liked to remove ERC 725 "Claim" keys here.
2859         // Unfortunately we can not automate this. Indeed it would require
2860         // the Partnership contract to have an ERC 725 Management key.
2861 
2862         // Remove his authorization.
2863         partnershipContracts[msg.sender].authorization = PartnershipAuthorization.Removed;
2864         // We return to the calling contract that it's done.
2865         success = true;
2866     }
2867 
2868     /**
2869      * @dev Internal function to remove partnerships before selfdestruct.
2870      */
2871     function cleanupPartnership() internal returns (bool success) {
2872         // For each known Partnership contract
2873         for (uint i = 0; i < knownPartnershipContracts.length; i++) {
2874             // If it was an authorized partnership,
2875             if (partnershipContracts[knownPartnershipContracts[i]].authorization == PartnershipAuthorization.Authorized) {
2876                 // Remove ourselves in the other Partnership contract.
2877                 PartnershipInterface hisInterface = PartnershipInterface(knownPartnershipContracts[i]);
2878                 hisInterface._removePartnership();
2879             }
2880         }
2881         success = true;
2882     }
2883 }
2884 
2885 
2886 /**
2887  * @title Interface with clones, inherited contracts or services.
2888  */
2889 interface PartnershipInterface {
2890     function _requestPartnership(bytes) external view returns (bool);
2891     function _authorizePartnership(bytes) external;
2892     function _removePartnership() external returns (bool success);
2893     function getKnownPartnershipsContracts() external returns (address[]);
2894     function getPartnership(address)
2895         external
2896         returns (uint, uint, uint40, bytes, bytes);
2897 }
2898 
2899 // File: contracts/access/Permissions.sol
2900 
2901 /**
2902  * @title Permissions contract.
2903  * @author Talao, Polynomial.
2904  * @notice See ../identity/KeyHolder.sol as well.
2905  */
2906 contract Permissions is Partnership {
2907 
2908     // Foundation contract.
2909     Foundation foundation;
2910 
2911     // Talao token contract.
2912     TalaoToken public token;
2913 
2914     /**
2915      * @dev Constructor.
2916      */
2917     constructor(
2918         address _foundation,
2919         address _token,
2920         uint16 _category,
2921         uint16 _asymetricEncryptionAlgorithm,
2922         uint16 _symetricEncryptionAlgorithm,
2923         bytes _asymetricEncryptionPublicKey,
2924         bytes _symetricEncryptionEncryptedKey,
2925         bytes _encryptedSecret
2926     )
2927         Partnership(
2928             _foundation,
2929             _token,
2930             _category,
2931             _asymetricEncryptionAlgorithm,
2932             _symetricEncryptionAlgorithm,
2933             _asymetricEncryptionPublicKey,
2934             _symetricEncryptionEncryptedKey,
2935             _encryptedSecret
2936         )
2937         public
2938     {
2939         foundation = Foundation(_foundation);
2940         token = TalaoToken(_token);
2941         identityInformation.creator = msg.sender;
2942         identityInformation.category = _category;
2943         identityInformation.asymetricEncryptionAlgorithm = _asymetricEncryptionAlgorithm;
2944         identityInformation.symetricEncryptionAlgorithm = _symetricEncryptionAlgorithm;
2945         identityInformation.asymetricEncryptionPublicKey = _asymetricEncryptionPublicKey;
2946         identityInformation.symetricEncryptionEncryptedKey = _symetricEncryptionEncryptedKey;
2947         identityInformation.encryptedSecret = _encryptedSecret;
2948     }
2949 
2950     /**
2951      * @dev Is msg.sender a "member" of this contract, in the Foundation sense?
2952      */
2953     function isMember() public view returns (bool) {
2954         return foundation.membersToContracts(msg.sender) == address(this);
2955     }
2956 
2957     /**
2958      * @dev Read authorization for inherited contracts "private" data.
2959      */
2960     function isReader() public view returns (bool) {
2961         // Get Vault access price in the token for this contract owner,
2962         // in the Foundation sense.
2963         (uint accessPrice,,,) = token.data(identityOwner());
2964         // OR conditions for Reader:
2965         // 1) Same code for
2966         // 1.1) Sender is this contract owner and has an open Vault in the token.
2967         // 1.2) Sender has vaultAccess to this contract owner in the token.
2968         // 2) Owner has open Vault in the token and:
2969         // 2.1) Sender is a member of this contract,
2970         // 2.2) Sender is a member of an authorized Partner contract
2971         // 2.3) Sender has an ERC 725 20001 key "Reader"
2972         // 2.4) Owner has a free vaultAccess in the token
2973         return(
2974             token.hasVaultAccess(identityOwner(), msg.sender) ||
2975             (
2976                 token.hasVaultAccess(identityOwner(), identityOwner()) &&
2977                 (
2978                     isMember() ||
2979                     isPartnershipMember() ||
2980                     hasIdentityPurpose(20001) ||
2981                     (accessPrice == 0 && msg.sender != address(0))
2982                 )
2983             )
2984         );
2985     }
2986 
2987     /**
2988      * @dev Modifier version of isReader.
2989      */
2990     modifier onlyReader() {
2991         require(isReader(), "Access denied");
2992         _;
2993     }
2994 }
2995 
2996 // File: contracts/content/Profile.sol
2997 
2998 /**
2999  * @title Profile contract.
3000  * @author Talao, Polynomial, Slowsense, Blockchain Partner.
3001  */
3002 contract Profile is Permissions {
3003 
3004     // "Private" profile.
3005     // Access controlled by Permissions.sol.
3006     // Nothing is really private on the blockchain,
3007     // so data should be encrypted on symetric key.
3008     struct PrivateProfile {
3009         // Private email.
3010         bytes email;
3011 
3012         // Mobile number.
3013         bytes mobile;
3014     }
3015     PrivateProfile internal privateProfile;
3016 
3017     /**
3018      * @dev Get private profile.
3019      */
3020     function getPrivateProfile()
3021         external
3022         view
3023         onlyReader
3024         returns (bytes, bytes)
3025     {
3026         return (
3027             privateProfile.email,
3028             privateProfile.mobile
3029         );
3030     }
3031 
3032     /**
3033      * @dev Set private profile.
3034      */
3035     function setPrivateProfile(
3036         bytes _privateEmail,
3037         bytes _mobile
3038     )
3039         external
3040         onlyIdentityPurpose(20002)
3041     {
3042         privateProfile.email = _privateEmail;
3043         privateProfile.mobile = _mobile;
3044     }
3045 }
3046 
3047 // File: contracts/content/Documents.sol
3048 
3049 /**
3050  * @title A Documents contract allows to manage documents and share them.
3051  * @notice Also contracts that have an ERC 725 Claim key (3)
3052  * can add certified documents.
3053  * @author Talao, Polynomial, SlowSense, Blockchain Partners.
3054  */
3055 contract Documents is Permissions {
3056 
3057     using SafeMathUpdated for uint;
3058 
3059     // Document struct.
3060     struct Document {
3061 
3062         // True if "published", false if "unpublished".
3063         // 31 bytes remaining in SSTORAGE 1 after this.
3064         bool published;
3065 
3066         // True if doc is encrypted.
3067         // 30 bytes remaining in SSTORAGE 1 after this.
3068         bool encrypted;
3069 
3070         // Position in index.
3071         // 28 bytes remaining in SSTORAGE 1 after this.
3072         uint16 index;
3073 
3074         // Type of document:
3075         // ...
3076         // 50000 => 59999: experiences
3077         // 60000 => max: certificates
3078         // 26 bytes remaining in SSTORAGE 1 after this.
3079         uint16 docType;
3080 
3081         // Version of document type: 1 = "work experience version 1" document, if type_doc = 1
3082         // 24 bytes remaining in SSTORAGE 1 after this.
3083         uint16 docTypeVersion;
3084 
3085         // ID of related experience, for certificates.
3086         // 22 bytes remaining in SSTORAGE 1 after this.
3087         uint16 related;
3088 
3089         // ID of the file location engine.
3090         // 1 = IPFS, 2 = Swarm, 3 = Filecoin, ...
3091         // 20 bytes remaining in SSTORAGE 1 after this.
3092         uint16 fileLocationEngine;
3093 
3094         // Issuer of the document.
3095         // SSTORAGE 1 full after this.
3096         address issuer;
3097 
3098         // Checksum of the file (SHA-256 offchain).
3099         // SSTORAGE 2 filled after this.
3100         bytes32 fileChecksum;
3101 
3102         // Expiration date.
3103         uint40 expires;
3104 
3105         // Hash of the file location in a decentralized engine.
3106         // Example: IPFS hash, Swarm hash, Filecoin hash...
3107         // Uses 1 SSTORAGE for IPFS.
3108         bytes fileLocationHash;
3109     }
3110 
3111     // Documents registry.
3112     mapping(uint => Document) internal documents;
3113 
3114     // Documents index.
3115     uint[] internal documentsIndex;
3116 
3117     // Documents counter.
3118     uint internal documentsCounter;
3119 
3120     // Event: new document added.
3121     event DocumentAdded (uint id);
3122 
3123     // Event: document removed.
3124     event DocumentRemoved (uint id);
3125 
3126     // Event: certificate issued.
3127     event CertificateIssued (bytes32 indexed checksum, address indexed issuer, uint id);
3128 
3129     // Event: certificate accepted.
3130     event CertificateAccepted (bytes32 indexed checksum, address indexed issuer, uint id);
3131 
3132     /**
3133      * @dev Document getter.
3134      * @param _id uint Document ID.
3135      */
3136     function getDocument(uint _id)
3137         external
3138         view
3139         onlyReader
3140         returns (
3141             uint16,
3142             uint16,
3143             uint40,
3144             address,
3145             bytes32,
3146             uint16,
3147             bytes,
3148             bool,
3149             uint16
3150         )
3151     {
3152         Document memory doc = documents[_id];
3153         require(doc.published);
3154         return(
3155             doc.docType,
3156             doc.docTypeVersion,
3157             doc.expires,
3158             doc.issuer,
3159             doc.fileChecksum,
3160             doc.fileLocationEngine,
3161             doc.fileLocationHash,
3162             doc.encrypted,
3163             doc.related
3164         );
3165     }
3166 
3167     /**
3168      * @dev Get all published documents.
3169      */
3170     function getDocuments() external view onlyReader returns (uint[]) {
3171         return documentsIndex;
3172     }
3173 
3174     /**
3175      * @dev Create a document.
3176      */
3177     function createDocument(
3178         uint16 _docType,
3179         uint16 _docTypeVersion,
3180         uint40 _expires,
3181         bytes32 _fileChecksum,
3182         uint16 _fileLocationEngine,
3183         bytes _fileLocationHash,
3184         bool _encrypted
3185     )
3186         external
3187         onlyIdentityPurpose(20002)
3188         returns(uint)
3189     {
3190         require(_docType < 60000);
3191         _createDocument(
3192             _docType,
3193             _docTypeVersion,
3194             _expires,
3195             msg.sender,
3196             _fileChecksum,
3197             _fileLocationEngine,
3198             _fileLocationHash,
3199             _encrypted,
3200             0
3201         );
3202         return documentsCounter;
3203     }
3204 
3205     /**
3206      * @dev Issue a certificate.
3207      */
3208     function issueCertificate(
3209         uint16 _docType,
3210         uint16 _docTypeVersion,
3211         bytes32 _fileChecksum,
3212         uint16 _fileLocationEngine,
3213         bytes _fileLocationHash,
3214         bool _encrypted,
3215         uint16 _related
3216     )
3217         external
3218         returns(uint)
3219     {
3220         require(
3221             keyHasPurpose(keccak256(abi.encodePacked(foundation.membersToContracts(msg.sender))), 3) &&
3222             isActiveIdentity() &&
3223             _docType >= 60000
3224         );
3225         uint id = _createDocument(
3226             _docType,
3227             _docTypeVersion,
3228             0,
3229             foundation.membersToContracts(msg.sender),
3230             _fileChecksum,
3231             _fileLocationEngine,
3232             _fileLocationHash,
3233             _encrypted,
3234             _related
3235         );
3236         emit CertificateIssued(_fileChecksum, foundation.membersToContracts(msg.sender), id);
3237         return id;
3238     }
3239 
3240     /**
3241      * @dev Accept a certificate.
3242      */
3243     function acceptCertificate(uint _id) external onlyIdentityPurpose(20002) {
3244         Document storage doc = documents[_id];
3245         require(!doc.published && doc.docType >= 60000);
3246         // Add to index.
3247         doc.index = uint16(documentsIndex.push(_id).sub(1));
3248         // Publish.
3249         doc.published = true;
3250         // Unpublish related experience, if published.
3251         if (documents[doc.related].published) {
3252             _deleteDocument(doc.related);
3253         }
3254         // Emit event.
3255         emit CertificateAccepted(doc.fileChecksum, doc.issuer, _id);
3256     }
3257 
3258     /**
3259      * @dev Create a document.
3260      */
3261     function _createDocument(
3262         uint16 _docType,
3263         uint16 _docTypeVersion,
3264         uint40 _expires,
3265         address _issuer,
3266         bytes32 _fileChecksum,
3267         uint16 _fileLocationEngine,
3268         bytes _fileLocationHash,
3269         bool _encrypted,
3270         uint16 _related
3271     )
3272         internal
3273         returns(uint)
3274     {
3275         // Increment documents counter.
3276         documentsCounter = documentsCounter.add(1);
3277         // Storage pointer.
3278         Document storage doc = documents[documentsCounter];
3279         // For certificates:
3280         // - add the related experience
3281         // - do not add to index
3282         // - do not publish.
3283         if (_docType >= 60000) {
3284             doc.related = _related;
3285         } else {
3286             // Add to index.
3287             doc.index = uint16(documentsIndex.push(documentsCounter).sub(1));
3288             // Publish.
3289             doc.published = true;
3290         }
3291         // Common data.
3292         doc.encrypted = _encrypted;
3293         doc.docType = _docType;
3294         doc.docTypeVersion = _docTypeVersion;
3295         doc.expires = _expires;
3296         doc.fileLocationEngine = _fileLocationEngine;
3297         doc.issuer = _issuer;
3298         doc.fileChecksum = _fileChecksum;
3299         doc.fileLocationHash = _fileLocationHash;
3300         // Emit event.
3301         emit DocumentAdded(documentsCounter);
3302         // Return document ID.
3303         return documentsCounter;
3304     }
3305 
3306     /**
3307      * @dev Remove a document.
3308      */
3309     function deleteDocument (uint _id) external onlyIdentityPurpose(20002) {
3310         _deleteDocument(_id);
3311     }
3312 
3313     /**
3314      * @dev Remove a document.
3315      */
3316     function _deleteDocument (uint _id) internal {
3317         Document storage docToDelete = documents[_id];
3318         require (_id > 0);
3319         require(docToDelete.published);
3320         // If the removed document is not the last in the index,
3321         if (docToDelete.index < (documentsIndex.length).sub(1)) {
3322             // Find the last document of the index.
3323             uint lastDocId = documentsIndex[(documentsIndex.length).sub(1)];
3324             Document storage lastDoc = documents[lastDocId];
3325             // Move it in the index in place of the document to delete.
3326             documentsIndex[docToDelete.index] = lastDocId;
3327             // Update this document that was moved from last position.
3328             lastDoc.index = docToDelete.index;
3329         }
3330         // Remove last element from index.
3331         documentsIndex.length --;
3332         // Unpublish document.
3333         docToDelete.published = false;
3334         // Emit event.
3335         emit DocumentRemoved(_id);
3336     }
3337 
3338     /**
3339      * @dev "Update" a document.
3340      * Updating a document makes no sense technically.
3341      * Here we provide a function that deletes a doc & create a new one.
3342      * But for UX it's very important to have this in 1 transaction.
3343      */
3344     function updateDocument(
3345         uint _id,
3346         uint16 _docType,
3347         uint16 _docTypeVersion,
3348         uint40 _expires,
3349         bytes32 _fileChecksum,
3350         uint16 _fileLocationEngine,
3351         bytes _fileLocationHash,
3352         bool _encrypted
3353     )
3354         external
3355         onlyIdentityPurpose(20002)
3356         returns (uint)
3357     {
3358         require(_docType < 60000);
3359         _deleteDocument(_id);
3360         _createDocument(
3361             _docType,
3362             _docTypeVersion,
3363             _expires,
3364             msg.sender,
3365             _fileChecksum,
3366             _fileLocationEngine,
3367             _fileLocationHash,
3368             _encrypted,
3369             0
3370         );
3371         return documentsCounter;
3372     }
3373 }
3374 
3375 
3376 /**
3377  * @title Interface with clones, inherited contracts or services.
3378  */
3379 interface DocumentsInterface {
3380     function getDocuments() external returns(uint[]);
3381     function getDocument(uint)
3382         external
3383         returns (
3384             uint16,
3385             uint16,
3386             uint40,
3387             address,
3388             bytes32,
3389             uint16,
3390             bytes,
3391             bool,
3392             uint16
3393         );
3394 }
3395 
3396 // File: contracts/Workspace.sol
3397 
3398 /**
3399  * @title A Workspace contract.
3400  * @author Talao, Polynomial, SlowSense, Blockchain Partners.
3401  */
3402 contract Workspace is Permissions, Profile, Documents {
3403 
3404     /**
3405      * @dev Constructor.
3406      */
3407     constructor(
3408         address _foundation,
3409         address _token,
3410         uint16 _category,
3411         uint16 _asymetricEncryptionAlgorithm,
3412         uint16 _symetricEncryptionAlgorithm,
3413         bytes _asymetricEncryptionPublicKey,
3414         bytes _symetricEncryptionEncryptedKey,
3415         bytes _encryptedSecret
3416     )
3417         Permissions(
3418             _foundation,
3419             _token,
3420             _category,
3421             _asymetricEncryptionAlgorithm,
3422             _symetricEncryptionAlgorithm,
3423             _asymetricEncryptionPublicKey,
3424             _symetricEncryptionEncryptedKey,
3425             _encryptedSecret
3426         )
3427         public
3428     {
3429         foundation = Foundation(_foundation);
3430         token = TalaoToken(_token);
3431         identityInformation.creator = msg.sender;
3432         identityInformation.category = _category;
3433         identityInformation.asymetricEncryptionAlgorithm = _asymetricEncryptionAlgorithm;
3434         identityInformation.symetricEncryptionAlgorithm = _symetricEncryptionAlgorithm;
3435         identityInformation.asymetricEncryptionPublicKey = _asymetricEncryptionPublicKey;
3436         identityInformation.symetricEncryptionEncryptedKey = _symetricEncryptionEncryptedKey;
3437         identityInformation.encryptedSecret = _encryptedSecret;
3438     }
3439 
3440     /**
3441      * @dev Destroy contract.
3442      */
3443     function destroyWorkspace() external onlyIdentityOwner {
3444         if (cleanupPartnership() && foundation.renounceOwnershipInFoundation()) {
3445             selfdestruct(msg.sender);
3446         }
3447     }
3448 
3449     /**
3450      * @dev Prevents accidental sending of ether.
3451      */
3452     function() public {
3453         revert();
3454     }
3455 }
3456 
3457 // File: contracts/WorkspaceFactory.sol
3458 
3459 /**
3460  * @title WorkspaceFactory contract.
3461  * @notice This contract can generate Workspaces and connect them with Foundation.
3462  * @author Talao, Polynomial, Slowsense, Blockchain Partner.
3463  */
3464 
3465 contract WorkspaceFactory is OwnableUpdated {
3466 
3467     // Foundation contract.
3468     Foundation foundation;
3469 
3470     // Talao token contract.
3471     TalaoToken public token;
3472 
3473     /**
3474      * @dev Constructor.
3475      */
3476     constructor(address _foundation, address _token) public {
3477         foundation = Foundation(_foundation);
3478         token = TalaoToken(_token);
3479     }
3480 
3481     /**
3482      * @dev Create a Workspace contract.
3483      */
3484     function createWorkspace (
3485         uint16 _category,
3486         uint16 _asymetricEncryptionAlgorithm,
3487         uint16 _symetricEncryptionAlgorithm,
3488         bytes _asymetricEncryptionPublicKey,
3489         bytes _symetricEncryptionEncryptedKey,
3490         bytes _encryptedSecret,
3491         bytes _email
3492     )
3493         external
3494         returns (address)
3495     {
3496         // Sender must have access to his Vault in the Token.
3497         require(
3498             token.hasVaultAccess(msg.sender, msg.sender),
3499             "Sender has no access to Vault"
3500         );
3501         require(
3502             (
3503                 _category == 1001 ||
3504                 _category == 2001 ||
3505                 _category == 3001 ||
3506                 _category == 4001 ||
3507                 _category == 5001
3508             ),
3509             "Invalid category"
3510         );
3511         // Create contract.
3512         Workspace newWorkspace = new Workspace(
3513             address(foundation),
3514             address(token),
3515             _category,
3516             _asymetricEncryptionAlgorithm,
3517             _symetricEncryptionAlgorithm,
3518             _asymetricEncryptionPublicKey,
3519             _symetricEncryptionEncryptedKey,
3520             _encryptedSecret
3521         );
3522         // Add the email.
3523         // @see https://github.com/ethereum/EIPs/issues/735#issuecomment-450647097
3524         newWorkspace.addClaim(101109097105108, 1, msg.sender, "", _email, "");
3525         // Add an ECDSA ERC 725 key for initial owner with MANAGER purpose
3526         newWorkspace.addKey(keccak256(abi.encodePacked(msg.sender)), 1, 1);
3527         // Remove this factory ERC 725 MANAGER key.
3528         newWorkspace.removeKey(keccak256(abi.encodePacked(address(this))), 1);
3529         // Set initial owner in Foundation to msg.sender.
3530         foundation.setInitialOwnerInFoundation(address(newWorkspace), msg.sender);
3531         // Return new contract address.
3532         return address(newWorkspace);
3533     }
3534 
3535     /**
3536      * @dev Prevents accidental sending of ether.
3537      */
3538     function() public {
3539         revert("Prevent accidental sending of ether");
3540     }
3541 }