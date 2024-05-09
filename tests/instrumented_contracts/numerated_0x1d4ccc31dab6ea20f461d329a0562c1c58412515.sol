1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 /**
77  * @title TalaoMarketplace
78  * @dev This contract is allowing users to buy or sell Talao tokens at a price set by the owner
79  * @author Blockchain Partner
80  */
81 contract TalaoMarketplace is Ownable {
82   using SafeMath for uint256;
83 
84   TalaoToken public token;
85 
86   struct MarketplaceData {
87     uint buyPrice;
88     uint sellPrice;
89     uint unitPrice;
90   }
91 
92   MarketplaceData public marketplace;
93 
94   event SellingPrice(uint sellingPrice);
95   event TalaoBought(address buyer, uint amount, uint price, uint unitPrice);
96   event TalaoSold(address seller, uint amount, uint price, uint unitPrice);
97 
98   /**
99   * @dev Constructor of the marketplace pointing to the TALAO token address
100   * @param talao the talao token address
101   **/
102   constructor(address talao)
103       public
104   {
105       token = TalaoToken(talao);
106   }
107 
108   /**
109   * @dev Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
110   * @param newSellPrice price the users can sell to the contract
111   * @param newBuyPrice price users can buy from the contract
112   * @param newUnitPrice to manage decimal issue 0,35 = 35 /100 (100 is unit)
113   */
114   function setPrices(uint256 newSellPrice, uint256 newBuyPrice, uint256 newUnitPrice)
115       public
116       onlyOwner
117   {
118       require (newSellPrice > 0 && newBuyPrice > 0 && newUnitPrice > 0, "wrong inputs");
119       marketplace.sellPrice = newSellPrice;
120       marketplace.buyPrice = newBuyPrice;
121       marketplace.unitPrice = newUnitPrice;
122   }
123 
124   /**
125   * @dev Allow anyone to buy tokens against ether, depending on the buyPrice set by the contract owner.
126   * @return amount the amount of tokens bought
127   **/
128   function buy()
129       public
130       payable
131       returns (uint amount)
132   {
133       amount = msg.value.mul(marketplace.unitPrice).div(marketplace.buyPrice);
134       token.transfer(msg.sender, amount);
135       emit TalaoBought(msg.sender, amount, marketplace.buyPrice, marketplace.unitPrice);
136       return amount;
137   }
138 
139   /**
140   * @dev Allow anyone to sell tokens for ether, depending on the sellPrice set by the contract owner.
141   * @param amount the number of tokens to be sold
142   * @return revenue ethers sent in return
143   **/
144   function sell(uint amount)
145       public
146       returns (uint revenue)
147   {
148       require(token.balanceOf(msg.sender) >= amount, "sender has not enough tokens");
149       token.transferFrom(msg.sender, this, amount);
150       revenue = amount.mul(marketplace.sellPrice).div(marketplace.unitPrice);
151       msg.sender.transfer(revenue);
152       emit TalaoSold(msg.sender, amount, marketplace.sellPrice, marketplace.unitPrice);
153       return revenue;
154   }
155 
156   /**
157    * @dev Allows the owner to withdraw ethers from the contract.
158    * @param ethers quantity of ethers to be withdrawn
159    * @return true if withdrawal successful ; false otherwise
160    */
161   function withdrawEther(uint256 ethers)
162       public
163       onlyOwner
164   {
165       if (this.balance >= ethers) {
166           msg.sender.transfer(ethers);
167       }
168   }
169 
170   /**
171    * @dev Allow the owner to withdraw tokens from the contract.
172    * @param tokens quantity of tokens to be withdrawn
173    */
174   function withdrawTalao(uint256 tokens)
175       public
176       onlyOwner
177   {
178       token.transfer(msg.sender, tokens);
179   }
180 
181 
182   /**
183   * @dev Fallback function ; only owner can send ether.
184   **/
185   function ()
186       public
187       payable
188       onlyOwner
189   {
190 
191   }
192 
193 }
194 
195 /**
196  * @title ERC20Basic
197  * @dev Simpler version of ERC20 interface
198  * @dev see https://github.com/ethereum/EIPs/issues/179
199  */
200 contract ERC20Basic {
201   uint256 public totalSupply;
202   function balanceOf(address who) public view returns (uint256);
203   function transfer(address to, uint256 value) public returns (bool);
204   event Transfer(address indexed from, address indexed to, uint256 value);
205 }
206 
207 /**
208  * @title ERC20 interface
209  * @dev see https://github.com/ethereum/EIPs/issues/20
210  */
211 contract ERC20 is ERC20Basic {
212   function allowance(address owner, address spender) public view returns (uint256);
213   function transferFrom(address from, address to, uint256 value) public returns (bool);
214   function approve(address spender, uint256 value) public returns (bool);
215   event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217 
218 /**
219  * @title SafeERC20
220  * @dev Wrappers around ERC20 operations that throw on failure.
221  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
222  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
223  */
224 library SafeERC20 {
225   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
226     assert(token.transfer(to, value));
227   }
228 
229   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
230     assert(token.transferFrom(from, to, value));
231   }
232 
233   function safeApprove(ERC20 token, address spender, uint256 value) internal {
234     assert(token.approve(spender, value));
235   }
236 }
237 
238 
239 /**
240  * @title TokenTimelock
241  * @dev TokenTimelock is a token holder contract that will allow a
242  * beneficiary to extract the tokens after a given release time
243  */
244 contract TokenTimelock {
245   using SafeERC20 for ERC20Basic;
246 
247   // ERC20 basic token contract being held
248   ERC20Basic public token;
249 
250   // beneficiary of tokens after they are released
251   address public beneficiary;
252 
253   // timestamp when token release is enabled
254   uint256 public releaseTime;
255 
256   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
257     require(_releaseTime > now);
258     token = _token;
259     beneficiary = _beneficiary;
260     releaseTime = _releaseTime;
261   }
262 
263   /**
264    * @notice Transfers tokens held by timelock to beneficiary.
265    * @dev Removed original require that amount released was > 0 ; releasing 0 is fine
266    */
267   function release() public {
268     require(now >= releaseTime);
269 
270     uint256 amount = token.balanceOf(this);
271 
272     token.safeTransfer(beneficiary, amount);
273   }
274 }
275 
276 
277 /**
278  * @title TokenVesting
279  * @dev A token holder contract that can release its token balance gradually like a
280  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
281  * owner.
282  * @notice Talao token transfer function cannot fail thus there's no need for revocation.
283  */
284 contract TokenVesting is Ownable {
285   using SafeMath for uint256;
286   using SafeERC20 for ERC20Basic;
287 
288   event Released(uint256 amount);
289   event Revoked();
290 
291   // beneficiary of tokens after they are released
292   address public beneficiary;
293 
294   uint256 public cliff;
295   uint256 public start;
296   uint256 public duration;
297 
298   bool public revocable;
299 
300   mapping (address => uint256) public released;
301   mapping (address => bool) public revoked;
302 
303   /**
304    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
305    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
306    * of the balance will have vested.
307    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
308    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
309    * @param _duration duration in seconds of the period in which the tokens will vest
310    * @param _revocable whether the vesting is revocable or not
311    */
312   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
313     require(_beneficiary != address(0));
314     require(_cliff <= _duration);
315 
316     beneficiary = _beneficiary;
317     revocable = _revocable;
318     duration = _duration;
319     cliff = _start.add(_cliff);
320     start = _start;
321   }
322 
323   /**
324    * @notice Transfers vested tokens to beneficiary.
325    * @dev Removed original require that amount released was > 0 ; releasing 0 is fine
326    * @param token ERC20 token which is being vested
327    */
328   function release(ERC20Basic token) public {
329     uint256 unreleased = releasableAmount(token);
330 
331     released[token] = released[token].add(unreleased);
332 
333     token.safeTransfer(beneficiary, unreleased);
334 
335     Released(unreleased);
336   }
337 
338   /**
339    * @notice Allows the owner to revoke the vesting. Tokens already vested
340    * remain in the contract, the rest are returned to the owner.
341    * @param token ERC20 token which is being vested
342    */
343   function revoke(ERC20Basic token) public onlyOwner {
344     require(revocable);
345     require(!revoked[token]);
346 
347     uint256 balance = token.balanceOf(this);
348 
349     uint256 unreleased = releasableAmount(token);
350     uint256 refund = balance.sub(unreleased);
351 
352     revoked[token] = true;
353 
354     token.safeTransfer(owner, refund);
355 
356     Revoked();
357   }
358 
359   /**
360    * @dev Calculates the amount that has already vested but hasn't been released yet.
361    * @param token ERC20 token which is being vested
362    */
363   function releasableAmount(ERC20Basic token) public view returns (uint256) {
364     return vestedAmount(token).sub(released[token]);
365   }
366 
367   /**
368    * @dev Calculates the amount that has already vested.
369    * @param token ERC20 token which is being vested
370    */
371   function vestedAmount(ERC20Basic token) public view returns (uint256) {
372     uint256 currentBalance = token.balanceOf(this);
373     uint256 totalBalance = currentBalance.add(released[token]);
374 
375     if (now < cliff) {
376       return 0;
377     } else if (now >= start.add(duration) || revoked[token]) {
378       return totalBalance;
379     } else {
380       return totalBalance.mul(now.sub(start)).div(duration);
381     }
382   }
383 }
384 
385 /**
386  * @title Crowdsale
387  * @dev Crowdsale is a base contract for managing a token crowdsale.
388  * Crowdsales have a start and end timestamps, where investors can make
389  * token purchases and the crowdsale will assign them tokens based
390  * on a token per ETH rate. Funds collected are forwarded to a wallet
391  * as they arrive.
392  */
393 contract Crowdsale {
394   using SafeMath for uint256;
395 
396   // The token being sold
397   MintableToken public token;
398 
399   // start and end timestamps where investments are allowed (both inclusive)
400   uint256 public startTime;
401   uint256 public endTime;
402 
403   // address where funds are collected
404   address public wallet;
405 
406   // how many token units a buyer gets per wei
407   uint256 public rate;
408 
409   // amount of raised money in wei
410   uint256 public weiRaised;
411 
412   /**
413    * event for token purchase logging
414    * @param purchaser who paid for the tokens
415    * @param beneficiary who got the tokens
416    * @param value weis paid for purchase
417    * @param amount amount of tokens purchased
418    */
419   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
420 
421   function Crowdsale(uint256 _rate, uint256 _startTime, uint256 _endTime, address _wallet) public {
422     require(_rate > 0);
423     require(_startTime >= now);
424     require(_endTime >= _startTime);
425     require(_wallet != address(0));
426 
427     token = createTokenContract();
428     startTime = _startTime;
429     endTime = _endTime;
430     wallet = _wallet;
431   }
432 
433   // creates the token to be sold.
434   // override this method to have crowdsale of a specific mintable token.
435   function createTokenContract() internal returns (MintableToken) {
436     return new MintableToken();
437   }
438 
439 
440   // fallback function can be used to buy tokens
441   function () external payable {
442     buyTokens(msg.sender);
443   }
444 
445   // low level token purchase function
446   function buyTokens(address beneficiary) public payable {
447     require(beneficiary != address(0));
448     require(validPurchase());
449 
450     uint256 weiAmount = msg.value;
451 
452     // calculate token amount to be created
453     uint256 tokens = weiAmount.mul(rate);
454 
455     // update state
456     weiRaised = weiRaised.add(weiAmount);
457 
458     token.mint(beneficiary, tokens);
459     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
460 
461     forwardFunds();
462   }
463 
464   // send ether to the fund collection wallet
465   // override to create custom fund forwarding mechanisms
466   function forwardFunds() internal {
467     wallet.transfer(msg.value);
468   }
469 
470   // @return true if the transaction can buy tokens
471   // removed view to be overriden
472   function validPurchase() internal returns (bool) {
473     bool withinPeriod = now >= startTime && now <= endTime;
474     bool nonZeroPurchase = msg.value != 0;
475     return withinPeriod && nonZeroPurchase;
476   }
477 
478   // @return true if crowdsale event has ended
479   function hasEnded() public view returns (bool) {
480     return now > endTime;
481   }
482 
483 
484 }
485 
486 
487 /**
488  * @title FinalizableCrowdsale
489  * @dev Extension of Crowdsale where an owner can do extra work
490  * after finishing.
491  */
492 contract FinalizableCrowdsale is Crowdsale, Ownable {
493   using SafeMath for uint256;
494 
495   bool public isFinalized = false;
496 
497   event Finalized();
498 
499   /**
500    * @dev Must be called after crowdsale ends, to do some extra finalization
501    * work. Calls the contract's finalization function.
502    */
503   function finalize() public {
504     require(!isFinalized);
505     require(hasEnded());
506 
507     finalization();
508     Finalized();
509 
510     isFinalized = true;
511   }
512 
513   /**
514    * @dev Can be overridden to add finalization logic. The overriding function
515    * should call super.finalization() to ensure the chain of finalization is
516    * executed entirely.
517    */
518   function finalization() internal {
519   }
520 }
521 
522 
523 /**
524  * @title RefundVault
525  * @dev This contract is used for storing funds while a crowdsale
526  * is in progress. Supports refunding the money if crowdsale fails,
527  * and forwarding it if crowdsale is successful.
528  */
529 contract RefundVault is Ownable {
530   using SafeMath for uint256;
531 
532   enum State { Active, Refunding, Closed }
533 
534   mapping (address => uint256) public deposited;
535   address public wallet;
536   State public state;
537 
538   event Closed();
539   event RefundsEnabled();
540   event Refunded(address indexed beneficiary, uint256 weiAmount);
541 
542   function RefundVault(address _wallet) public {
543     require(_wallet != address(0));
544     wallet = _wallet;
545     state = State.Active;
546   }
547 
548   function deposit(address investor) onlyOwner public payable {
549     require(state == State.Active);
550     deposited[investor] = deposited[investor].add(msg.value);
551   }
552 
553   function close() onlyOwner public {
554     require(state == State.Active);
555     state = State.Closed;
556     Closed();
557     wallet.transfer(this.balance);
558   }
559 
560   function enableRefunds() onlyOwner public {
561     require(state == State.Active);
562     state = State.Refunding;
563     RefundsEnabled();
564   }
565 
566   function refund(address investor) public {
567     require(state == State.Refunding);
568     uint256 depositedValue = deposited[investor];
569     deposited[investor] = 0;
570     investor.transfer(depositedValue);
571     Refunded(investor, depositedValue);
572   }
573 }
574 
575 
576 
577 /**
578  * @title RefundableCrowdsale
579  * @dev Extension of Crowdsale contract that adds a funding goal, and
580  * the possibility of users getting a refund if goal is not met.
581  * Uses a RefundVault as the crowdsale's vault.
582  */
583 contract RefundableCrowdsale is FinalizableCrowdsale {
584   using SafeMath for uint256;
585 
586   // minimum amount of funds to be raised in weis
587   uint256 public goal;
588 
589   // refund vault used to hold funds while crowdsale is running
590   RefundVault public vault;
591 
592   function RefundableCrowdsale(uint256 _goal) public {
593     require(_goal > 0);
594     vault = new RefundVault(wallet);
595     goal = _goal;
596   }
597 
598   // We're overriding the fund forwarding from Crowdsale.
599   // In addition to sending the funds, we want to call
600   // the RefundVault deposit function
601   function forwardFunds() internal {
602     vault.deposit.value(msg.value)(msg.sender);
603   }
604 
605   // if crowdsale is unsuccessful, investors can claim refunds here
606   function claimRefund() public {
607     require(isFinalized);
608     require(!goalReached());
609 
610     vault.refund(msg.sender);
611   }
612 
613   // vault finalization task, called when owner calls finalize()
614   function finalization() internal {
615     if (goalReached()) {
616       vault.close();
617     } else {
618       vault.enableRefunds();
619     }
620 
621     super.finalization();
622   }
623 
624   function goalReached() public view returns (bool) {
625     return weiRaised >= goal;
626   }
627 
628 }
629 
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
640   function CappedCrowdsale(uint256 _cap) public {
641     require(_cap > 0);
642     cap = _cap;
643   }
644 
645   // overriding Crowdsale#validPurchase to add extra cap logic
646   // @return true if investors can buy at the moment
647   // removed view to be overriden
648   function validPurchase() internal returns (bool) {
649     bool withinCap = weiRaised.add(msg.value) <= cap;
650     return super.validPurchase() && withinCap;
651   }
652 
653   // overriding Crowdsale#hasEnded to add cap logic
654   // @return true if crowdsale event has ended
655   function hasEnded() public view returns (bool) {
656     bool capReached = weiRaised >= cap;
657     return super.hasEnded() || capReached;
658   }
659 
660 }
661 
662 /**
663  * @title ProgressiveIndividualCappedCrowdsale
664  * @dev Extension of Crowdsale with a progressive individual cap
665  * @dev This contract is not made for crowdsale superior to 256 * TIME_PERIOD_IN_SEC
666  * @author Request.network ; some modifications by Blockchain Partner
667  */
668 contract ProgressiveIndividualCappedCrowdsale is RefundableCrowdsale, CappedCrowdsale {
669 
670     uint public startGeneralSale;
671     uint public constant TIME_PERIOD_IN_SEC = 1 days;
672     uint public constant minimumParticipation = 10 finney;
673     uint public constant GAS_LIMIT_IN_WEI = 5E10 wei; // limit gas price -50 Gwei wales stopper
674     uint256 public baseEthCapPerAddress;
675 
676     mapping(address=>uint) public participated;
677 
678     function ProgressiveIndividualCappedCrowdsale(uint _baseEthCapPerAddress, uint _startGeneralSale)
679         public
680     {
681         baseEthCapPerAddress = _baseEthCapPerAddress;
682         startGeneralSale = _startGeneralSale;
683     }
684 
685     /**
686      * @dev setting cap before the general sale starts
687      * @param _newBaseCap the new cap
688      */
689     function setBaseCap(uint _newBaseCap)
690         public
691         onlyOwner
692     {
693         require(now < startGeneralSale);
694         baseEthCapPerAddress = _newBaseCap;
695     }
696 
697     /**
698      * @dev overriding CappedCrowdsale#validPurchase to add an individual cap
699      * @return true if investors can buy at the moment
700      */
701     function validPurchase()
702         internal
703         returns(bool)
704     {
705         bool gasCheck = tx.gasprice <= GAS_LIMIT_IN_WEI;
706         uint ethCapPerAddress = getCurrentEthCapPerAddress();
707         participated[msg.sender] = participated[msg.sender].add(msg.value);
708         bool enough = participated[msg.sender] >= minimumParticipation;
709         return participated[msg.sender] <= ethCapPerAddress && enough && gasCheck;
710     }
711 
712     /**
713      * @dev Get the current individual cap.
714      * @dev This amount increase everyday in an exponential way. Day 1: base cap, Day 2: 2 * base cap, Day 3: 4 * base cap ...
715      * @return individual cap in wei
716      */
717     function getCurrentEthCapPerAddress()
718         public
719         constant
720         returns(uint)
721     {
722         if (block.timestamp < startGeneralSale) return 0;
723         uint timeSinceStartInSec = block.timestamp.sub(startGeneralSale);
724         uint currentPeriod = timeSinceStartInSec.div(TIME_PERIOD_IN_SEC).add(1);
725 
726         // for currentPeriod > 256 will always return 0
727         return (2 ** currentPeriod.sub(1)).mul(baseEthCapPerAddress);
728     }
729 }
730 
731 /**
732  * @title Basic token
733  * @dev Basic version of StandardToken, with no allowances.
734  */
735 contract BasicToken is ERC20Basic {
736   using SafeMath for uint256;
737 
738   mapping(address => uint256) balances;
739 
740   /**
741   * @dev transfer token for a specified address
742   * @param _to The address to transfer to.
743   * @param _value The amount to be transferred.
744   */
745   function transfer(address _to, uint256 _value) public returns (bool) {
746     require(_to != address(0));
747     require(_value <= balances[msg.sender]);
748 
749     // SafeMath.sub will throw if there is not enough balance.
750     balances[msg.sender] = balances[msg.sender].sub(_value);
751     balances[_to] = balances[_to].add(_value);
752     Transfer(msg.sender, _to, _value);
753     return true;
754   }
755 
756   /**
757   * @dev Gets the balance of the specified address.
758   * @param _owner The address to query the the balance of.
759   * @return An uint256 representing the amount owned by the passed address.
760   */
761   function balanceOf(address _owner) public view returns (uint256 balance) {
762     return balances[_owner];
763   }
764 
765 }
766 
767 
768 /**
769  * @title Standard ERC20 token
770  *
771  * @dev Implementation of the basic standard token.
772  * @dev https://github.com/ethereum/EIPs/issues/20
773  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
774  */
775 contract StandardToken is ERC20, BasicToken {
776 
777   mapping (address => mapping (address => uint256)) internal allowed;
778 
779 
780   /**
781    * @dev Transfer tokens from one address to another
782    * @param _from address The address which you want to send tokens from
783    * @param _to address The address which you want to transfer to
784    * @param _value uint256 the amount of tokens to be transferred
785    */
786   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
787     require(_to != address(0));
788     require(_value <= balances[_from]);
789     require(_value <= allowed[_from][msg.sender]);
790 
791     balances[_from] = balances[_from].sub(_value);
792     balances[_to] = balances[_to].add(_value);
793     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
794     Transfer(_from, _to, _value);
795     return true;
796   }
797 
798   /**
799    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
800    *
801    * Beware that changing an allowance with this method brings the risk that someone may use both the old
802    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
803    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
804    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
805    * @param _spender The address which will spend the funds.
806    * @param _value The amount of tokens to be spent.
807    */
808   function approve(address _spender, uint256 _value) public returns (bool) {
809     allowed[msg.sender][_spender] = _value;
810     Approval(msg.sender, _spender, _value);
811     return true;
812   }
813 
814   /**
815    * @dev Function to check the amount of tokens that an owner allowed to a spender.
816    * @param _owner address The address which owns the funds.
817    * @param _spender address The address which will spend the funds.
818    * @return A uint256 specifying the amount of tokens still available for the spender.
819    */
820   function allowance(address _owner, address _spender) public view returns (uint256) {
821     return allowed[_owner][_spender];
822   }
823 
824   /**
825    * @dev Increase the amount of tokens that an owner allowed to a spender.
826    *
827    * approve should be called when allowed[_spender] == 0. To increment
828    * allowed value is better to use this function to avoid 2 calls (and wait until
829    * the first transaction is mined)
830    * From MonolithDAO Token.sol
831    * @param _spender The address which will spend the funds.
832    * @param _addedValue The amount of tokens to increase the allowance by.
833    */
834   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
835     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
836     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
837     return true;
838   }
839 
840   /**
841    * @dev Decrease the amount of tokens that an owner allowed to a spender.
842    *
843    * approve should be called when allowed[_spender] == 0. To decrement
844    * allowed value is better to use this function to avoid 2 calls (and wait until
845    * the first transaction is mined)
846    * From MonolithDAO Token.sol
847    * @param _spender The address which will spend the funds.
848    * @param _subtractedValue The amount of tokens to decrease the allowance by.
849    */
850   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
851     uint oldValue = allowed[msg.sender][_spender];
852     if (_subtractedValue > oldValue) {
853       allowed[msg.sender][_spender] = 0;
854     } else {
855       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
856     }
857     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
858     return true;
859   }
860 
861 }
862 
863 /**
864  * @title Mintable token
865  * @dev Simple ERC20 Token example, with mintable token creation
866  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
867  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
868  */
869 
870 contract MintableToken is StandardToken, Ownable {
871   event Mint(address indexed to, uint256 amount);
872   event MintFinished();
873 
874   bool public mintingFinished = false;
875 
876 
877   modifier canMint() {
878     require(!mintingFinished);
879     _;
880   }
881 
882   /**
883    * @dev Function to mint tokens
884    * @param _to The address that will receive the minted tokens.
885    * @param _amount The amount of tokens to mint.
886    * @return A boolean that indicates if the operation was successful.
887    */
888   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
889     totalSupply = totalSupply.add(_amount);
890     balances[_to] = balances[_to].add(_amount);
891     Mint(_to, _amount);
892     Transfer(address(0), _to, _amount);
893     return true;
894   }
895 
896   /**
897    * @dev Function to stop minting new tokens.
898    * @return True if the operation was successful.
899    */
900   function finishMinting() onlyOwner canMint public returns (bool) {
901     mintingFinished = true;
902     MintFinished();
903     return true;
904   }
905 }
906 
907 
908 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
909 
910 /**
911  * @title TalaoToken
912  * @dev This contract details the TALAO token and allows freelancers to create/revoke vault access, appoint agents.
913  * @author Blockchain Partner
914  */
915 contract TalaoToken is MintableToken {
916   using SafeMath for uint256;
917 
918   // token details
919   string public constant name = "Talao";
920   string public constant symbol = "TALAO";
921   uint8 public constant decimals = 18;
922 
923   // the talao marketplace address
924   address public marketplace;
925 
926   // talao tokens needed to create a vault
927   uint256 public vaultDeposit;
928   // sum of all talao tokens desposited
929   uint256 public totalDeposit;
930 
931   struct FreelanceData {
932       // access price to the talent vault
933       uint256 accessPrice;
934       // address of appointed talent agent
935       address appointedAgent;
936       // how much the talent is sharing with its agent
937       uint sharingPlan;
938       // how much is the talent deposit
939       uint256 userDeposit;
940   }
941 
942   // structure that defines a client access to a vault
943   struct ClientAccess {
944       // is he allowed to access the vault
945       bool clientAgreement;
946       // the block number when access was granted
947       uint clientDate;
948   }
949 
950   // Vault allowance client x freelancer
951   mapping (address => mapping (address => ClientAccess)) public accessAllowance;
952 
953   // Freelance data is public
954   mapping (address=>FreelanceData) public data;
955 
956   enum VaultStatus {Closed, Created, PriceTooHigh, NotEnoughTokensDeposited, AgentRemoved, NewAgent, NewAccess, WrongAccessPrice}
957 
958   // Those event notifies UI about vaults action with vault status
959   // Closed Vault access closed
960   // Created Vault access created
961   // PriceTooHigh Vault access price too high
962   // NotEnoughTokensDeposited not enough tokens to pay deposit
963   // AgentRemoved agent removed
964   // NewAgent new agent appointed
965   // NewAccess vault access granted to client
966   // WrongAccessPrice client not enough token to pay vault access
967   event Vault(address indexed client, address indexed freelance, VaultStatus status);
968 
969   modifier onlyMintingFinished()
970   {
971       require(mintingFinished == true, "minting has not finished");
972       _;
973   }
974 
975   /**
976   * @dev Let the owner set the marketplace address once minting is over
977   *      Possible to do it more than once to ensure maintainability
978   * @param theMarketplace the marketplace address
979   **/
980   function setMarketplace(address theMarketplace)
981       public
982       onlyMintingFinished
983       onlyOwner
984   {
985       marketplace = theMarketplace;
986   }
987 
988   /**
989   * @dev Same ERC20 behavior, but require the token to be unlocked
990   * @param _spender address The address that will spend the funds.
991   * @param _value uint256 The amount of tokens to be spent.
992   **/
993   function approve(address _spender, uint256 _value)
994       public
995       onlyMintingFinished
996       returns (bool)
997   {
998       return super.approve(_spender, _value);
999   }
1000 
1001   /**
1002   * @dev Same ERC20 behavior, but require the token to be unlocked and sells some tokens to refill ether balance up to minBalanceForAccounts
1003   * @param _to address The address to transfer to.
1004   * @param _value uint256 The amount to be transferred.
1005   **/
1006   function transfer(address _to, uint256 _value)
1007       public
1008       onlyMintingFinished
1009       returns (bool result)
1010   {
1011       return super.transfer(_to, _value);
1012   }
1013 
1014   /**
1015   * @dev Same ERC20 behavior, but require the token to be unlocked
1016   * @param _from address The address which you want to send tokens from.
1017   * @param _to address The address which you want to transfer to.
1018   * @param _value uint256 the amount of tokens to be transferred.
1019   **/
1020   function transferFrom(address _from, address _to, uint256 _value)
1021       public
1022       onlyMintingFinished
1023       returns (bool)
1024   {
1025       return super.transferFrom(_from, _to, _value);
1026   }
1027 
1028   /**
1029    * @dev Set allowance for other address and notify
1030    *      Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
1031    * @param _spender The address authorized to spend
1032    * @param _value the max amount they can spend
1033    * @param _extraData some extra information to send to the approved contract
1034    */
1035   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
1036       public
1037       onlyMintingFinished
1038       returns (bool)
1039   {
1040       tokenRecipient spender = tokenRecipient(_spender);
1041       if (approve(_spender, _value)) {
1042           spender.receiveApproval(msg.sender, _value, this, _extraData);
1043           return true;
1044       }
1045   }
1046 
1047   /**
1048    * @dev Allows the owner to withdraw ethers from the contract.
1049    * @param ethers quantity in weis of ethers to be withdrawn
1050    * @return true if withdrawal successful ; false otherwise
1051    */
1052   function withdrawEther(uint256 ethers)
1053       public
1054       onlyOwner
1055   {
1056       msg.sender.transfer(ethers);
1057   }
1058 
1059   /**
1060    * @dev Allow the owner to withdraw tokens from the contract without taking tokens from deposits.
1061    * @param tokens quantity of tokens to be withdrawn
1062    */
1063   function withdrawTalao(uint256 tokens)
1064       public
1065       onlyOwner
1066   {
1067       require(balanceOf(this).sub(totalDeposit) >= tokens, "too much tokens asked");
1068       _transfer(this, msg.sender, tokens);
1069   }
1070 
1071   /******************************************/
1072   /*      vault functions start here        */
1073   /******************************************/
1074 
1075   /**
1076   * @dev Allows anyone to create a vault access.
1077   *      Vault deposit is transferred to token contract and sum is stored in totalDeposit
1078   *      Price must be lower than Vault deposit
1079   * @param price to pay to access certificate vault
1080   */
1081   function createVaultAccess (uint256 price)
1082       public
1083       onlyMintingFinished
1084   {
1085       require(accessAllowance[msg.sender][msg.sender].clientAgreement==false, "vault already created");
1086       require(price<=vaultDeposit, "price asked is too high");
1087       require(balanceOf(msg.sender)>vaultDeposit, "user has not enough tokens to send deposit");
1088       data[msg.sender].accessPrice=price;
1089       super.transfer(this, vaultDeposit);
1090       totalDeposit = totalDeposit.add(vaultDeposit);
1091       data[msg.sender].userDeposit=vaultDeposit;
1092       data[msg.sender].sharingPlan=100;
1093       accessAllowance[msg.sender][msg.sender].clientAgreement=true;
1094       emit Vault(msg.sender, msg.sender, VaultStatus.Created);
1095   }
1096 
1097   /**
1098   * @dev Closes a vault access, deposit is sent back to freelance wallet
1099   *      Total deposit in token contract is reduced by user deposit
1100   */
1101   function closeVaultAccess()
1102       public
1103       onlyMintingFinished
1104   {
1105       require(accessAllowance[msg.sender][msg.sender].clientAgreement==true, "vault has not been created");
1106       require(_transfer(this, msg.sender, data[msg.sender].userDeposit), "token deposit transfer failed");
1107       accessAllowance[msg.sender][msg.sender].clientAgreement=false;
1108       totalDeposit=totalDeposit.sub(data[msg.sender].userDeposit);
1109       data[msg.sender].sharingPlan=0;
1110       emit Vault(msg.sender, msg.sender, VaultStatus.Closed);
1111   }
1112 
1113   /**
1114   * @dev Internal transfer function used to transfer tokens from an address to another without prior authorization.
1115   *      Only used in these situations:
1116   *           * Send tokens from the contract to a token buyer (buy() function)
1117   *           * Send tokens from the contract to the owner in order to withdraw tokens (withdrawTalao(tokens) function)
1118   *           * Send tokens from the contract to a user closing its vault thus claiming its deposit back (closeVaultAccess() function)
1119   * @param _from address The address which you want to send tokens from.
1120   * @param _to address The address which you want to transfer to.
1121   * @param _value uint256 the amount of tokens to be transferred.
1122   * @return true if transfer is successful ; should throw otherwise
1123   */
1124   function _transfer(address _from, address _to, uint _value)
1125       internal
1126       returns (bool)
1127   {
1128       require(_to != 0x0, "destination cannot be 0x0");
1129       require(balances[_from] >= _value, "not enough tokens in sender wallet");
1130 
1131       balances[_from] = balances[_from].sub(_value);
1132       balances[_to] = balances[_to].add(_value);
1133       emit Transfer(_from, _to, _value);
1134       return true;
1135   }
1136 
1137   /**
1138   * @dev Appoint an agent or a new agent
1139   *      Former agent is replaced by new agent
1140   *      Agent will receive token on behalf of the freelance talent
1141   * @param newagent agent to appoint
1142   * @param newplan sharing plan is %, 100 means 100% for freelance
1143   */
1144   function agentApproval (address newagent, uint newplan)
1145       public
1146       onlyMintingFinished
1147   {
1148       require(newplan>=0&&newplan<=100, "plan must be between 0 and 100");
1149       require(accessAllowance[msg.sender][msg.sender].clientAgreement==true, "vault has not been created");
1150       emit Vault(data[msg.sender].appointedAgent, msg.sender, VaultStatus.AgentRemoved);
1151       data[msg.sender].appointedAgent=newagent;
1152       data[msg.sender].sharingPlan=newplan;
1153       emit Vault(newagent, msg.sender, VaultStatus.NewAgent);
1154   }
1155 
1156   /**
1157    * @dev Set the quantity of tokens necessary for vault access creation
1158    * @param newdeposit deposit (in tokens) for vault access creation
1159    */
1160   function setVaultDeposit (uint newdeposit)
1161       public
1162       onlyOwner
1163   {
1164       vaultDeposit = newdeposit;
1165   }
1166 
1167   /**
1168   * @dev Buy unlimited access to a freelancer vault
1169   *      Vault access price is transfered from client to agent or freelance depending on the sharing plan
1170   *      Allowance is given to client and one stores block.number for future use
1171   * @param freelance the address of the talent
1172   * @return true if access is granted ; false if not
1173   */
1174   function getVaultAccess (address freelance)
1175       public
1176       onlyMintingFinished
1177       returns (bool)
1178   {
1179       require(accessAllowance[freelance][freelance].clientAgreement==true, "vault does not exist");
1180       require(accessAllowance[msg.sender][freelance].clientAgreement!=true, "access was already granted");
1181       require(balanceOf(msg.sender)>data[freelance].accessPrice, "user has not enough tokens to get access to vault");
1182 
1183       uint256 freelance_share = data[freelance].accessPrice.mul(data[freelance].sharingPlan).div(100);
1184       uint256 agent_share = data[freelance].accessPrice.sub(freelance_share);
1185       if(freelance_share>0) super.transfer(freelance, freelance_share);
1186       if(agent_share>0) super.transfer(data[freelance].appointedAgent, agent_share);
1187       accessAllowance[msg.sender][freelance].clientAgreement=true;
1188       accessAllowance[msg.sender][freelance].clientDate=block.number;
1189       emit Vault(msg.sender, freelance, VaultStatus.NewAccess);
1190       return true;
1191   }
1192 
1193   /**
1194   * @dev Simple getter to retrieve talent agent
1195   * @param freelance talent address
1196   * @return address of the agent
1197   **/
1198   function getFreelanceAgent(address freelance)
1199       public
1200       view
1201       returns (address)
1202   {
1203       return data[freelance].appointedAgent;
1204   }
1205 
1206   /**
1207   * @dev Simple getter to check if user has access to a freelance vault
1208   * @param freelance talent address
1209   * @param user user address
1210   * @return true if access granted or false if not
1211   **/
1212   function hasVaultAccess(address freelance, address user)
1213       public
1214       view
1215       returns (bool)
1216   {
1217       return ((accessAllowance[user][freelance].clientAgreement) || (data[freelance].appointedAgent == user));
1218   }
1219 
1220 }