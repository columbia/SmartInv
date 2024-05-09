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
38 
39 /**
40  * @title ERC20Basic
41  * @dev Simpler version of ERC20 interface
42  * @dev see https://github.com/ethereum/EIPs/issues/179
43  */
44 contract ERC20Basic {
45   uint256 public totalSupply;
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) public onlyOwner {
88     require(newOwner != address(0));
89     OwnershipTransferred(owner, newOwner);
90     owner = newOwner;
91   }
92 
93 }
94 
95 
96 
97 
98 
99 
100 
101 
102 
103 
104 
105 
106 
107 
108 
109 
110 
111 /**
112  * @title Basic token
113  * @dev Basic version of StandardToken, with no allowances.
114  */
115 contract BasicToken is ERC20Basic {
116   using SafeMath for uint256;
117 
118   mapping(address => uint256) balances;
119 
120   /**
121   * @dev transfer token for a specified address
122   * @param _to The address to transfer to.
123   * @param _value The amount to be transferred.
124   */
125   function transfer(address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 
148 
149 
150 
151 
152 
153 /**
154  * @title ERC20 interface
155  * @dev see https://github.com/ethereum/EIPs/issues/20
156  */
157 contract ERC20 is ERC20Basic {
158   function allowance(address owner, address spender) public view returns (uint256);
159   function transferFrom(address from, address to, uint256 value) public returns (bool);
160   function approve(address spender, uint256 value) public returns (bool);
161   event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * @dev https://github.com/ethereum/EIPs/issues/20
171  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198    *
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(address _owner, address _spender) public view returns (uint256) {
219     return allowed[_owner][_spender];
220   }
221 
222   /**
223    * @dev Increase the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238   /**
239    * @dev Decrease the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
249     uint oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue > oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 }
260 
261 
262 
263 
264 
265 /**
266  * @title Mintable token
267  * @dev Simple ERC20 Token example, with mintable token creation
268  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
269  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
270  */
271 
272 contract MintableToken is StandardToken, Ownable {
273   event Mint(address indexed to, uint256 amount);
274   event MintFinished();
275 
276   bool public mintingFinished = false;
277 
278 
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     totalSupply = totalSupply.add(_amount);
292     balances[_to] = balances[_to].add(_amount);
293     Mint(_to, _amount);
294     Transfer(address(0), _to, _amount);
295     return true;
296   }
297 
298   /**
299    * @dev Function to stop minting new tokens.
300    * @return True if the operation was successful.
301    */
302   function finishMinting() onlyOwner canMint public returns (bool) {
303     mintingFinished = true;
304     MintFinished();
305     return true;
306   }
307 }
308 
309 
310 contract CNIFToken is MintableToken {
311   string public name = "CryptoNote Index Fund Token";
312   string public symbol = "CNIF";
313   uint8 public decimals = 18;
314 }
315 
316 
317 
318 
319 
320 
321 
322 
323 /**
324  * @title Crowdsale
325  * @dev Crowdsale is a base contract for managing a token crowdsale.
326  * Crowdsales have a start and end timestamps, where investors can make
327  * token purchases and the crowdsale will assign them tokens based
328  * on a token per ETH rate. Funds collected are forwarded to a wallet
329  * as they arrive.
330  */
331 contract Crowdsale {
332   using SafeMath for uint256;
333 
334   // The token being sold
335   MintableToken public token;
336 
337   // start and end timestamps where investments are allowed (both inclusive)
338   uint256 public startTime;
339   uint256 public endTime;
340 
341   // address where funds are collected
342   address public wallet;
343 
344   // how many token units a buyer gets per wei
345   uint256 public rate;
346 
347   // amount of raised money in wei
348   uint256 public weiRaised;
349 
350   /**
351    * event for token purchase logging
352    * @param purchaser who paid for the tokens
353    * @param beneficiary who got the tokens
354    * @param value weis paid for purchase
355    * @param amount amount of tokens purchased
356    */
357   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
358 
359 
360   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
361     require(_startTime >= now);
362     require(_endTime >= _startTime);
363     require(_rate > 0);
364     require(_wallet != address(0));
365 
366     token = createTokenContract();
367     startTime = _startTime;
368     endTime = _endTime;
369     rate = _rate;
370     wallet = _wallet;
371   }
372 
373   // creates the token to be sold.
374   // override this method to have crowdsale of a specific mintable token.
375   function createTokenContract() internal returns (MintableToken) {
376     return new MintableToken();
377   }
378 
379 
380   // fallback function can be used to buy tokens
381   function () external payable {
382     buyTokens(msg.sender);
383   }
384 
385   // low level token purchase function
386   function buyTokens(address beneficiary) public payable {
387     require(beneficiary != address(0));
388     require(validPurchase());
389 
390     uint256 weiAmount = msg.value;
391 
392     // calculate token amount to be created
393     uint256 tokens = weiAmount.mul(rate);
394 
395     // update state
396     weiRaised = weiRaised.add(weiAmount);
397 
398     token.mint(beneficiary, tokens);
399     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
400 
401     forwardFunds();
402   }
403 
404   // send ether to the fund collection wallet
405   // override to create custom fund forwarding mechanisms
406   function forwardFunds() internal {
407     wallet.transfer(msg.value);
408   }
409 
410   // @return true if the transaction can buy tokens
411   function validPurchase() internal view returns (bool) {
412     bool withinPeriod = now >= startTime && now <= endTime;
413     bool nonZeroPurchase = msg.value != 0;
414     return withinPeriod && nonZeroPurchase;
415   }
416 
417   // @return true if crowdsale event has ended
418   function hasEnded() public view returns (bool) {
419     return now > endTime;
420   }
421 
422 
423 }
424 
425 
426 /**
427  * @title CappedCrowdsale
428  * @dev Extension of Crowdsale with a max amount of funds raised
429  */
430 contract CappedCrowdsale is Crowdsale {
431   using SafeMath for uint256;
432 
433   uint256 public cap;
434 
435   function CappedCrowdsale(uint256 _cap) public {
436     require(_cap > 0);
437     cap = _cap;
438   }
439 
440   // overriding Crowdsale#validPurchase to add extra cap logic
441   // @return true if investors can buy at the moment
442   function validPurchase() internal view returns (bool) {
443     bool withinCap = weiRaised.add(msg.value) <= cap;
444     return super.validPurchase() && withinCap;
445   }
446 
447   // overriding Crowdsale#hasEnded to add cap logic
448   // @return true if crowdsale event has ended
449   function hasEnded() public view returns (bool) {
450     bool capReached = weiRaised >= cap;
451     return super.hasEnded() || capReached;
452   }
453 
454 }
455 
456 
457 
458 
459 
460 
461 
462 
463 
464 
465 
466 /**
467  * @title FinalizableCrowdsale
468  * @dev Extension of Crowdsale where an owner can do extra work
469  * after finishing.
470  */
471 contract FinalizableCrowdsale is Crowdsale, Ownable {
472   using SafeMath for uint256;
473 
474   bool public isFinalized = false;
475 
476   event Finalized();
477 
478   /**
479    * @dev Must be called after crowdsale ends, to do some extra finalization
480    * work. Calls the contract's finalization function.
481    */
482   function finalize() onlyOwner public {
483     require(!isFinalized);
484     require(hasEnded());
485 
486     finalization();
487     Finalized();
488 
489     isFinalized = true;
490   }
491 
492   /**
493    * @dev Can be overridden to add finalization logic. The overriding function
494    * should call super.finalization() to ensure the chain of finalization is
495    * executed entirely.
496    */
497   function finalization() internal {
498   }
499 }
500 
501 
502 
503 
504 
505 
506 /**
507  * @title RefundVault
508  * @dev This contract is used for storing funds while a crowdsale
509  * is in progress. Supports refunding the money if crowdsale fails,
510  * and forwarding it if crowdsale is successful.
511  */
512 contract RefundVault is Ownable {
513   using SafeMath for uint256;
514 
515   enum State { Active, Refunding, Closed }
516 
517   mapping (address => uint256) public deposited;
518   address public wallet;
519   State public state;
520 
521   event Closed();
522   event RefundsEnabled();
523   event Refunded(address indexed beneficiary, uint256 weiAmount);
524 
525   function RefundVault(address _wallet) public {
526     require(_wallet != address(0));
527     wallet = _wallet;
528     state = State.Active;
529   }
530 
531   function deposit(address investor) onlyOwner public payable {
532     require(state == State.Active);
533     deposited[investor] = deposited[investor].add(msg.value);
534   }
535 
536   function close() onlyOwner public {
537     require(state == State.Active);
538     state = State.Closed;
539     Closed();
540     wallet.transfer(this.balance);
541   }
542 
543   function enableRefunds() onlyOwner public {
544     require(state == State.Active);
545     state = State.Refunding;
546     RefundsEnabled();
547   }
548 
549   function refund(address investor) public {
550     require(state == State.Refunding);
551     uint256 depositedValue = deposited[investor];
552     deposited[investor] = 0;
553     investor.transfer(depositedValue);
554     Refunded(investor, depositedValue);
555   }
556 }
557 
558 
559 
560 /**
561  * @title RefundableCrowdsale
562  * @dev Extension of Crowdsale contract that adds a funding goal, and
563  * the possibility of users getting a refund if goal is not met.
564  * Uses a RefundVault as the crowdsale's vault.
565  */
566 contract RefundableCrowdsale is FinalizableCrowdsale {
567   using SafeMath for uint256;
568 
569   // minimum amount of funds to be raised in weis
570   uint256 public goal;
571 
572   // refund vault used to hold funds while crowdsale is running
573   RefundVault public vault;
574 
575   function RefundableCrowdsale(uint256 _goal) public {
576     require(_goal > 0);
577     vault = new RefundVault(wallet);
578     goal = _goal;
579   }
580 
581   // We're overriding the fund forwarding from Crowdsale.
582   // In addition to sending the funds, we want to call
583   // the RefundVault deposit function
584   function forwardFunds() internal {
585     vault.deposit.value(msg.value)(msg.sender);
586   }
587 
588   // if crowdsale is unsuccessful, investors can claim refunds here
589   function claimRefund() public {
590     require(isFinalized);
591     require(!goalReached());
592 
593     vault.refund(msg.sender);
594   }
595 
596   // vault finalization task, called when owner calls finalize()
597   function finalization() internal {
598     if (goalReached()) {
599       vault.close();
600     } else {
601       vault.enableRefunds();
602     }
603 
604     super.finalization();
605   }
606 
607   function goalReached() public view returns (bool) {
608     return weiRaised >= goal;
609   }
610 
611 }
612 
613 
614 contract CNIFCrowdsale is CappedCrowdsale, RefundableCrowdsale {
615 
616   // ICO Stage
617   // ============
618   enum CrowdsaleStage { PreICO, ICO }
619   CrowdsaleStage public stage = CrowdsaleStage.PreICO;
620   // =============
621 
622   // Token Distribution
623   // =============================
624   uint256 public maxTokens = 1000000000000000000000000; // Total supply 1000 000 CNIF Tokens
625   uint256 public tokensForEcosystem = 100000000000000000000000;
626   uint256 public tokensForTeam = 100000000000000000000000;
627   uint256 public tokensForBounty = 50000000000000000000000;
628   uint256 public totalTokensForSale = 750000000000000000000000; // 750 000 CNIFs will be sold in Crowdsale
629   uint256 public totalTokensForSaleDuringPreICO = 250000000000000000000000; // 250 000 out of 750 000 CNIFs will be sold during PreICO
630   // ==============================
631 
632   // Amount raised in PreICO
633   // ==================
634   uint256 public totalWeiRaisedDuringPreICO;
635   // ===================
636 
637 
638   // Events
639   event EthTransferred(string text);
640   event EthRefunded(string text);
641 
642 
643   // Constructor
644   // ============
645   function CNIFCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap) CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startTime, _endTime, _rate, _wallet) public {
646       require(_goal <= _cap);
647   }
648   // =============
649 
650   // Token Deployment
651   // =================
652   function createTokenContract() internal returns (MintableToken) {
653     return new CNIFToken(); // Deploys the ERC20 token. Automatically called when crowdsale contract is deployed
654   }
655   // ==================
656 
657   // Crowdsale Stage Management
658   // =========================================================
659 
660   // Change Crowdsale Stage. Available Options: PreICO, ICO
661   function setCrowdsaleStage(uint value) public onlyOwner {
662 
663       CrowdsaleStage _stage;
664 
665       if (uint(CrowdsaleStage.PreICO) == value) {
666         _stage = CrowdsaleStage.PreICO;
667       } else if (uint(CrowdsaleStage.ICO) == value) {
668         _stage = CrowdsaleStage.ICO;
669       }
670 
671       stage = _stage;
672 
673       if (stage == CrowdsaleStage.PreICO) {
674         setCurrentRate(1000);
675       } else if (stage == CrowdsaleStage.ICO) {
676         setCurrentRate(800);
677       }
678   }
679 
680   // Change the current rate
681   function setCurrentRate(uint256 _rate) private {
682       rate = _rate;
683   }
684 
685   // ================ Stage Management Over =====================
686 
687   // Token Purchase
688   // =========================
689   function () external payable {
690       uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
691       if ((stage == CrowdsaleStage.PreICO) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO)) {
692         msg.sender.transfer(msg.value); // Refund them
693         EthRefunded("PreICO Limit Hit");
694         return;
695       }
696 
697       buyTokens(msg.sender);
698 
699       if (stage == CrowdsaleStage.PreICO) {
700           totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
701       }
702   }
703 
704   function forwardFunds() internal {
705           EthTransferred("forwarding funds to refundable vault");
706           super.forwardFunds();
707   }
708   // ===========================
709 
710   // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
711   // ====================================================================
712 
713   function finish(address _teamFund, address _ecosystemFund, address _bountyFund) public onlyOwner {
714       require(!isFinalized);
715       uint256 alreadyMinted = token.totalSupply();
716       require(alreadyMinted < maxTokens);
717 
718       uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
719       if (unsoldTokens > 0) {
720         tokensForEcosystem = tokensForEcosystem + unsoldTokens;
721       }
722 
723       token.mint(_teamFund,tokensForTeam);
724       token.mint(_ecosystemFund,tokensForEcosystem);
725       token.mint(_bountyFund,tokensForBounty);
726       finalize();
727   }
728 }