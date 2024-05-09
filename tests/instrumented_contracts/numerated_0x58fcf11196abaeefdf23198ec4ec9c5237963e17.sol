1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 
112 
113 
114 
115 
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender) public view returns (uint256);
123   function transferFrom(address from, address to, uint256 value) public returns (bool);
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) internal allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amount of tokens to be transferred
147    */
148   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149     require(_to != address(0));
150     require(_value <= balances[_from]);
151     require(_value <= allowed[_from][msg.sender]);
152 
153     balances[_from] = balances[_from].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    *
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param _spender The address which will spend the funds.
168    * @param _value The amount of tokens to be spent.
169    */
170   function approve(address _spender, uint256 _value) public returns (bool) {
171     allowed[msg.sender][_spender] = _value;
172     Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182   function allowance(address _owner, address _spender) public view returns (uint256) {
183     return allowed[_owner][_spender];
184   }
185 
186   /**
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    */
192   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 
212 /**
213  * @title Burnable Token
214  * @dev Token that can be irreversibly burned (destroyed).
215  */
216 contract BurnableToken is StandardToken {
217 
218     event Burn(address indexed burner, uint256 value);
219 
220     /**
221      * @dev Burns a specific amount of tokens.
222      * @param _value The amount of token to be burned.
223      */
224     function burn(uint256 _value) public {
225         require(_value > 0);
226         require(_value <= balances[msg.sender]);
227         // no need to require value <= totalSupply, since that would imply the
228         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
229 
230         address burner = msg.sender;
231         balances[burner] = balances[burner].sub(_value);
232         totalSupply = totalSupply.sub(_value);
233         Burn(burner, _value);
234     }
235 }
236 
237 
238 
239 
240 
241 
242 
243 
244 
245 
246 /**
247  * @title Pausable
248  * @dev Base contract which allows children to implement an emergency stop mechanism.
249  */
250 contract Pausable is Ownable {
251   event Pause();
252   event Unpause();
253 
254   bool public paused = false;
255 
256 
257   /**
258    * @dev Modifier to make a function callable only when the contract is not paused.
259    */
260   modifier whenNotPaused() {
261     require(!paused);
262     _;
263   }
264 
265   /**
266    * @dev Modifier to make a function callable only when the contract is paused.
267    */
268   modifier whenPaused() {
269     require(paused);
270     _;
271   }
272 
273   /**
274    * @dev called by the owner to pause, triggers stopped state
275    */
276   function pause() onlyOwner whenNotPaused public {
277     paused = true;
278     Pause();
279   }
280 
281   /**
282    * @dev called by the owner to unpause, returns to normal state
283    */
284   function unpause() onlyOwner whenPaused public {
285     paused = false;
286     Unpause();
287   }
288 }
289 
290 
291 /**
292  * @title Pausable token
293  *
294  * @dev StandardToken modified with pausable transfers.
295  **/
296 
297 contract PausableToken is StandardToken, Pausable {
298 
299   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
300     return super.transfer(_to, _value);
301   }
302 
303   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
304     return super.transferFrom(_from, _to, _value);
305   }
306 
307   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
308     return super.approve(_spender, _value);
309   }
310 
311   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
312     return super.increaseApproval(_spender, _addedValue);
313   }
314 
315   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
316     return super.decreaseApproval(_spender, _subtractedValue);
317   }
318 }
319 
320 
321 contract BullToken is BurnableToken, PausableToken {
322 
323   string public constant name = "BullToken";
324   string public constant symbol = "BULL";
325   uint256 public constant decimals = 18;
326   uint256 public constant INITIAL_SUPPLY = 55000000;
327   bool public transferEnabled;
328 
329   mapping (address => bool) public isHolder;
330   address [] public holders;
331 
332   function BullToken() public {
333     totalSupply = INITIAL_SUPPLY * 10 ** uint256(decimals);
334     balances[msg.sender] = totalSupply;
335     transferEnabled = false;
336   }
337 
338   function enableTransfers() onlyOwner public {
339     transferEnabled = true;
340     TransferEnabled();
341   }
342 
343   function disableTransfers() onlyOwner public {
344     transferEnabled = false;
345     TransferDisabled();
346   }
347 
348   /**
349  * @dev transfer token for a specified address
350  * @param to The address to transfer to.
351  * @param value The amount to be transferred.
352  */
353   function transfer(address to, uint256 value) public returns (bool) {
354     require(transferEnabled || msg.sender == owner);
355 
356     // Update the list of holders for new address
357     if (!isHolder[to]) {
358       holders.push(to);
359       isHolder[to] = true;
360     }
361 
362     return super.transfer(to, value);
363   }
364 
365   /**
366   * @dev Transfer tokens from one address to another
367   * @param from address The address which you want to send tokens from
368   * @param to address The address which you want to transfer to
369   * @param value uint256 the amount of tokens to be transferred
370   */
371   function transferFrom(address from, address to, uint256 value) public returns (bool) {
372     require(transferEnabled || from == owner);
373 
374     // Update the list of holders for new address
375     if (!isHolder[to]) {
376       holders.push(to);
377       isHolder[to] = true;
378     }
379 
380     return super.transferFrom(from, to, value);
381   }
382 
383   event TransferEnabled();
384   event TransferDisabled();
385 
386 }
387 
388 
389 
390 
391 
392 /**
393  * @title Curatable
394  * @dev The Curatable contract has an curator address, and provides basic authorization control
395  * functions, this simplifies the implementation of "user permissions". This is heavily based on
396  * the Ownable contract
397  */
398 contract Curatable is Ownable {
399   address public curator;
400 
401 
402   event CurationRightsTransferred(address indexed previousCurator, address indexed newCurator);
403 
404 
405   /**
406    * @dev The Curatable constructor sets the original `curator` of the contract to the sender
407    * account.
408    */
409   function Curatable() public {
410     owner = msg.sender;
411     curator = owner;
412   }
413 
414 
415   /**
416    * @dev Throws if called by any account other than the curator.
417    */
418   modifier onlyCurator() {
419     require(msg.sender == curator);
420     _;
421   }
422 
423 
424   /**
425    * @dev Allows the current owner to transfer control of the contract to a newOwner.
426    * @param newCurator The address to transfer ownership to.
427    */
428   function transferCurationRights(address newCurator) public onlyOwner {
429     require(newCurator != address(0));
430     CurationRightsTransferred(curator, newCurator);
431     curator = newCurator;
432   }
433 
434 }
435 
436 
437 contract Whitelist is Curatable {
438     mapping (address => bool) public whitelist;
439 
440 
441     function Whitelist() public {
442     }
443 
444 
445     function addInvestor(address investor) external onlyCurator {
446         require(investor != 0x0 && !whitelist[investor]);
447         whitelist[investor] = true;
448     }
449 
450 
451     function removeInvestor(address investor) external onlyCurator {
452         require(investor != 0x0 && whitelist[investor]);
453         whitelist[investor] = false;
454     }
455 
456 
457     function isWhitelisted(address investor) constant external returns (bool result) {
458         return whitelist[investor];
459     }
460 
461 }
462 
463 
464 
465 
466 
467 /**
468  * @title SafeMath
469  * @dev Math operations with safety checks that throw on error
470  */
471 library SafeMath {
472   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
473     if (a == 0) {
474       return 0;
475     }
476     uint256 c = a * b;
477     assert(c / a == b);
478     return c;
479   }
480 
481   function div(uint256 a, uint256 b) internal pure returns (uint256) {
482     // assert(b > 0); // Solidity automatically throws when dividing by 0
483     uint256 c = a / b;
484     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
485     return c;
486   }
487 
488   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
489     assert(b <= a);
490     return a - b;
491   }
492 
493   function add(uint256 a, uint256 b) internal pure returns (uint256) {
494     uint256 c = a + b;
495     assert(c >= a);
496     return c;
497   }
498 }
499 
500 
501 
502 
503 
504 
505 /**
506  * @title BurnableCrowdsale
507  * @dev BurnableCrowdsale is based on zeppelin's Crowdsale contract.
508  * The difference is that we're using BurnableToken instead of MintableToken.
509  */
510 contract BurnableCrowdsale {
511   using SafeMath for uint256;
512 
513   // The token being sold
514   BurnableToken public token;
515 
516   // start and end timestamps where investments are allowed (both inclusive)
517   uint256 public startTime;
518   uint256 public endTime;
519 
520   // address where funds are collected
521   address public wallet;
522 
523   // how many token units a buyer gets per wei
524   uint256 public rate;
525 
526   // amount of raised money in wei
527   uint256 public weiRaised;
528 
529   // address to the token to use in the crowdsale
530   address public tokenAddress;
531 
532   /**
533    * event for token purchase logging
534    * @param purchaser who paid for the tokens
535    * @param beneficiary who got the tokens
536    * @param value weis paid for purchase
537    * @param amount amount of tokens purchased
538    */
539   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
540 
541   function BurnableCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _tokenAddress) public {
542     require(_startTime >= now);
543     require(_endTime >= _startTime);
544     require(_rate > 0);
545     require(_wallet != address(0));
546 
547     tokenAddress = _tokenAddress;
548     token = createTokenContract();
549     startTime = _startTime;
550     endTime = _endTime;
551     rate = _rate;
552     wallet = _wallet;
553   }
554 
555   // creates the token to be sold.
556   // override this method to have crowdsale of a specific mintable token.
557   // Rubynor override: change type to BurnableToken
558   function createTokenContract() internal returns (BurnableToken) {
559     return new BurnableToken();
560   }
561 
562   // fallback function can be used to buy tokens
563   function () external payable {
564     buyTokens(msg.sender);
565   }
566 
567   // low level token purchase function
568   function buyTokens(address beneficiary) public payable {
569     // We implement/override this function in BullTokenCrowdsale.sol
570   }
571 
572   // send ether to the fund collection wallet
573   // override to create custom fund forwarding mechanisms
574   function forwardFunds() internal {
575     // We implement/override this function in BullTokenCrowdsale.sol
576   }
577 
578   // @return true if the transaction can buy tokens
579   function validPurchase() internal view returns (bool) {
580     bool withinPeriod = now >= startTime && now <= endTime;
581     bool nonZeroPurchase = msg.value != 0;
582     return withinPeriod && nonZeroPurchase;
583   }
584 
585   // @return true if crowdsale event has ended
586   function hasEnded() public view returns (bool) {
587     return now > endTime;
588   }
589 
590 }
591 
592 
593 /**
594  * @title CappedCrowdsale
595  * @dev Extension of Crowdsale with a max amount of funds raised
596  */
597 contract CappedCrowdsale is BurnableCrowdsale {
598   using SafeMath for uint256;
599 
600   uint256 public cap;
601 
602   function CappedCrowdsale(uint256 _cap) public {
603     require(_cap > 0);
604     cap = _cap;
605   }
606 
607   // overriding Crowdsale#validPurchase to add extra cap logic
608   // @return true if investors can buy at the moment
609   function validPurchase() internal view returns (bool) {
610     bool withinCap = weiRaised.add(msg.value) <= cap;
611     return super.validPurchase() && withinCap;
612   }
613 
614   // overriding Crowdsale#hasEnded to add cap logic
615   // @return true if crowdsale event has ended
616   function hasEnded() public view returns (bool) {
617     bool capReached = weiRaised >= cap;
618     return super.hasEnded() || capReached;
619   }
620 
621 }
622 
623 
624 
625 
626 
627 
628 
629 
630 
631 
632 
633 
634 /**
635  * @title RefundVault
636  * @dev This contract is used for storing funds while a crowdsale
637  * is in progress. Supports refunding the money if crowdsale fails,
638  * and forwarding it if crowdsale is successful.
639  */
640 contract RefundVault is Ownable {
641   using SafeMath for uint256;
642 
643   enum State { Active, Refunding, Closed }
644 
645   mapping (address => uint256) public deposited;
646   address public wallet;
647   State public state;
648 
649   event Closed();
650   event RefundsEnabled();
651   event Refunded(address indexed beneficiary, uint256 weiAmount);
652 
653   function RefundVault(address _wallet) public {
654     require(_wallet != address(0));
655     wallet = _wallet;
656     state = State.Active;
657   }
658 
659   function deposit(address investor) onlyOwner public payable {
660     require(state == State.Active);
661     deposited[investor] = deposited[investor].add(msg.value);
662   }
663 
664   function close() onlyOwner public {
665     require(state == State.Active);
666     state = State.Closed;
667     Closed();
668     wallet.transfer(this.balance);
669   }
670 
671   function enableRefunds() onlyOwner public {
672     require(state == State.Active);
673     state = State.Refunding;
674     RefundsEnabled();
675   }
676 
677   function refund(address investor) public {
678     require(state == State.Refunding);
679     uint256 depositedValue = deposited[investor];
680     deposited[investor] = 0;
681     investor.transfer(depositedValue);
682     Refunded(investor, depositedValue);
683   }
684 }
685 
686 
687 contract BullTokenRefundVault is RefundVault {
688 
689   function BullTokenRefundVault(address _wallet) public RefundVault(_wallet) {}
690 
691   // We override the close function from zeppelin
692   function close() onlyOwner public {
693     require(state == State.Active);
694     state = State.Closed;
695     Closed();
696     // Instead of transfer we use call to include more gas
697     // in the transaction
698     wallet.call.value(this.balance)();
699   }
700 
701   function forwardFunds() onlyOwner public {
702     require(this.balance > 0);
703     wallet.call.value(this.balance)();
704   }
705 }
706 
707 
708 
709 
710 
711 
712 
713 /**
714  * @title FinalizableCrowdsale
715  * @dev Extension of Crowdsale where an owner can do extra work
716  * after finishing.
717  */
718 contract FinalizableCrowdsale is BurnableCrowdsale, Ownable {
719   using SafeMath for uint256;
720 
721   bool public isFinalized = false;
722 
723   event Finalized();
724 
725   /**
726    * @dev Must be called after crowdsale ends, to do some extra finalization
727    * work. Calls the contract's finalization function.
728    */
729   function finalize() onlyOwner public {
730     require(!isFinalized);
731     require(hasEnded());
732 
733     finalization();
734     Finalized();
735 
736     isFinalized = true;
737   }
738 
739   /**
740    * @dev Can be overridden to add finalization logic. The overriding function
741    * should call super.finalization() to ensure the chain of finalization is
742    * executed entirely.
743    */
744   function finalization() internal {
745   }
746 }
747 
748 
749 
750 /**
751  * @title RefundableCrowdsale
752  * @dev Extension of Crowdsale contract that adds a funding goal, and
753  * the possibility of users getting a refund if goal is not met.
754  * Uses a RefundVault as the crowdsale's vault.
755  */
756 contract RefundableCrowdsale is FinalizableCrowdsale {
757   using SafeMath for uint256;
758 
759   // minimum amount of funds to be raised in weis
760   uint256 public goal;
761 
762   // refund vault used to hold funds while crowdsale is running
763   BullTokenRefundVault public vault;
764 
765   function RefundableCrowdsale(uint256 _goal) public {
766     require(_goal > 0);
767     vault = new BullTokenRefundVault(wallet);
768     goal = _goal;
769   }
770 
771   // We're overriding the fund forwarding from Crowdsale.
772   // In addition to sending the funds, we want to call
773   // the RefundVault deposit function
774   function forwardFunds() internal {
775     vault.deposit.value(msg.value)(msg.sender);
776   }
777 
778   // if crowdsale is unsuccessful, investors can claim refunds here
779   function claimRefund() public {
780     require(isFinalized);
781     require(!goalReached());
782 
783     vault.refund(msg.sender);
784   }
785 
786   // vault finalization task, called when owner calls finalize()
787   function finalization() internal {
788     if (goalReached()) {
789       vault.close();
790     } else {
791       vault.enableRefunds();
792     }
793 
794     super.finalization();
795   }
796 
797   function goalReached() public view returns (bool) {
798     return weiRaised >= goal;
799   }
800 
801 }
802 
803 
804 contract BullTokenCrowdsale is CappedCrowdsale, RefundableCrowdsale {
805   using SafeMath for uint256;
806 
807   Whitelist public whitelist;
808   uint256 public minimumInvestment;
809 
810   function BullTokenCrowdsale(
811     uint256 _startTime,
812     uint256 _endTime,
813     uint256 _rate,
814     uint256 _goal,
815     uint256 _cap,
816     uint256 _minimumInvestment,
817     address _tokenAddress,
818     address _wallet,
819     address _whitelistAddress
820   ) public
821     CappedCrowdsale(_cap)
822     FinalizableCrowdsale()
823     RefundableCrowdsale(_goal)
824     BurnableCrowdsale(_startTime, _endTime, _rate, _wallet, _tokenAddress)
825   {
826     //As goal needs to be met for a successful crowdsale
827     //the value needs to less or equal than a cap which is limit for accepted funds
828     require(_goal <= _cap);
829 
830     whitelist = Whitelist(_whitelistAddress);
831     minimumInvestment = _minimumInvestment;
832   }
833 
834   function createTokenContract() internal returns (BurnableToken) {
835     return BullToken(tokenAddress);
836   }
837 
838   // fallback function can be used to buy tokens
839   function () external payable {
840     buyTokens(msg.sender);
841   }
842 
843   // low level token purchase function
844   function buyTokens(address beneficiary) public payable {
845     require(beneficiary != address(0));
846     require(whitelist.isWhitelisted(beneficiary));
847 
848     uint256 weiAmount = msg.value;
849     uint256 raisedIncludingThis = weiRaised.add(weiAmount);
850 
851     if (raisedIncludingThis > cap) {
852       require(hasStarted() && !hasEnded());
853       uint256 toBeRefunded = raisedIncludingThis.sub(cap);
854       weiAmount = cap.sub(weiRaised);
855       beneficiary.transfer(toBeRefunded);
856     } else {
857       require(validPurchase());
858     }
859 
860     // calculate token amount to be created
861     uint256 tokens = weiAmount.mul(rate);
862 
863     // update state
864     weiRaised = weiRaised.add(weiAmount);
865 
866     token.transferFrom(owner, beneficiary, tokens);
867 
868     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
869     forwardFundsToWallet(weiAmount);
870   }
871 
872   // overriding CappedCrowdsale#validPurchase to add minimum investment logic
873   // @return true if investors can buy at the moment
874   function validPurchase() internal view returns (bool) {
875     return super.validPurchase() && aboveMinimumInvestment();
876   }
877 
878   // overriding CappedCrowdsale#hasEnded to add minimum investment logic
879   // @return true if crowdsale event has ended
880   function hasEnded() public view returns (bool) {
881     bool capReached = weiRaised.add(minimumInvestment) > cap;
882     return super.hasEnded() || capReached;
883   }
884 
885   // @return true if crowdsale event has ended
886   function hasStarted() public constant returns (bool) {
887     return now >= startTime;
888   }
889 
890   function aboveMinimumInvestment() internal view returns (bool) {
891     return msg.value >= minimumInvestment;
892   }
893 
894   function forwardFundsToWallet(uint256 amount) internal {
895     if (goalReached() && vault.balance > 0) {
896       vault.forwardFunds();
897     }
898 
899     if (goalReached()) {
900       wallet.call.value(amount)();
901     } else {
902       vault.deposit.value(amount)(msg.sender);
903     }
904   }
905 
906 }