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
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 
113 
114 
115 
116 
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender) public view returns (uint256);
124   function transferFrom(address from, address to, uint256 value) public returns (bool);
125   function approve(address spender, uint256 value) public returns (bool);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) internal allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[_from]);
152     require(_value <= allowed[_from][msg.sender]);
153 
154     balances[_from] = balances[_from].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157     Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    *
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param _spender The address which will spend the funds.
169    * @param _value The amount of tokens to be spent.
170    */
171   function approve(address _spender, uint256 _value) public returns (bool) {
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(address _owner, address _spender) public view returns (uint256) {
184     return allowed[_owner][_spender];
185   }
186 
187   /**
188    * @dev Increase the amount of tokens that an owner allowed to a spender.
189    *
190    * approve should be called when allowed[_spender] == 0. To increment
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _addedValue The amount of tokens to increase the allowance by.
196    */
197   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
198     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203   /**
204    * @dev Decrease the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To decrement
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _subtractedValue The amount of tokens to decrease the allowance by.
212    */
213   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
214     uint oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue > oldValue) {
216       allowed[msg.sender][_spender] = 0;
217     } else {
218       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219     }
220     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224 }
225 
226 
227 
228 
229 
230 /**
231  * @title Mintable token
232  * @dev Simple ERC20 Token example, with mintable token creation
233  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
234  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
235  */
236 
237 contract MintableToken is StandardToken, Ownable {
238   event Mint(address indexed to, uint256 amount);
239   event MintFinished();
240 
241   bool public mintingFinished = false;
242 
243 
244   modifier canMint() {
245     require(!mintingFinished);
246     _;
247   }
248 
249   /**
250    * @dev Function to mint tokens
251    * @param _to The address that will receive the minted tokens.
252    * @param _amount The amount of tokens to mint.
253    * @return A boolean that indicates if the operation was successful.
254    */
255   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
256     totalSupply = totalSupply.add(_amount);
257     balances[_to] = balances[_to].add(_amount);
258     Mint(_to, _amount);
259     Transfer(address(0), _to, _amount);
260     return true;
261   }
262 
263   /**
264    * @dev Function to stop minting new tokens.
265    * @return True if the operation was successful.
266    */
267   function finishMinting() onlyOwner canMint public returns (bool) {
268     mintingFinished = true;
269     MintFinished();
270     return true;
271   }
272 }
273 
274 
275 contract BeteventToken is MintableToken {
276   string public name = "Betevent Token";
277   string public symbol = "BETEC";
278   uint8 public decimals = 18;
279 }
280 
281 
282 
283 
284 
285 /**
286  * @title SafeMath
287  * @dev Math operations with safety checks that throw on error
288  */
289 library SafeMath {
290   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
291     if (a == 0) {
292       return 0;
293     }
294     uint256 c = a * b;
295     assert(c / a == b);
296     return c;
297   }
298 
299   function div(uint256 a, uint256 b) internal pure returns (uint256) {
300     // assert(b > 0); // Solidity automatically throws when dividing by 0
301     uint256 c = a / b;
302     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
303     return c;
304   }
305 
306   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
307     assert(b <= a);
308     return a - b;
309   }
310 
311   function add(uint256 a, uint256 b) internal pure returns (uint256) {
312     uint256 c = a + b;
313     assert(c >= a);
314     return c;
315   }
316 }
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
614 contract BeteventCrowdsale is CappedCrowdsale, RefundableCrowdsale {
615 
616 
617   enum CrowdsaleStage { PreICO, ICO, ICO2, ICO3 }
618   CrowdsaleStage public stage = CrowdsaleStage.PreICO;
619 
620   uint256 public maxTokens = 75000000000000000000000000; 
621   uint256 public tokensForEcosystem = 3750000000000000000000000; 
622   uint256 public tokensForTeam = 7500000000000000000000000;  
623   uint256 public tokensForDevelopment = 7500000000000000000000000; 
624   uint256 public totalTokensForSale = 56250000000000000000000000; 
625   uint256 public totalTokensForSaleDuringPreICO = 11250000000000000000000000; 
626 
627   uint256 public totalWeiRaisedDuringPreICO;
628 
629 
630 
631   event EthTransferred(string text);
632   event EthRefunded(string text);
633 
634 
635 
636   function BeteventCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap) CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startTime, _endTime, _rate, _wallet) public {
637       require(_goal <= _cap);
638   }
639 
640   function createTokenContract() internal returns (MintableToken) {
641     return new BeteventToken(); 
642   }
643 
644   function setCrowdsaleStage(uint value) public onlyOwner {
645 
646       CrowdsaleStage _stage;
647 
648       if (uint(CrowdsaleStage.PreICO) == value) {
649         _stage = CrowdsaleStage.PreICO;
650       } else if (uint(CrowdsaleStage.ICO) == value) {
651         _stage = CrowdsaleStage.ICO;
652       } else if (uint(CrowdsaleStage.ICO2) == value) {
653         _stage = CrowdsaleStage.ICO2;
654       } else if (uint(CrowdsaleStage.ICO3) == value) {
655         _stage = CrowdsaleStage.ICO3;
656       }
657 
658       stage = _stage;
659 
660 if (stage == CrowdsaleStage.PreICO) {
661         setCurrentRate(7117);
662       } else if (stage == CrowdsaleStage.ICO) {
663         setCurrentRate(3558);
664       }else if (stage == CrowdsaleStage.ICO2) {
665         setCurrentRate(2768);
666       }else if (stage == CrowdsaleStage.ICO3) {
667         setCurrentRate(2264);
668       }
669   }
670 
671 
672   function setCurrentRate(uint256 _rate) private {
673       rate = _rate;
674   }
675 
676 
677   function () external payable {
678       uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
679       if ((stage == CrowdsaleStage.PreICO) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO)) {
680         msg.sender.transfer(msg.value);
681         EthRefunded("PreICO Limit Hit");
682         return;
683       }
684 
685       buyTokens(msg.sender);
686 
687       if (stage == CrowdsaleStage.PreICO) {
688           totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
689       }
690   }
691 
692   function forwardFunds() internal {
693       if (stage == CrowdsaleStage.PreICO) {
694           wallet.transfer(msg.value);
695           EthTransferred("forwarding funds to wallet");
696       } else if (stage == CrowdsaleStage.ICO) {
697           EthTransferred("forwarding funds to refundable vault");
698           super.forwardFunds();
699       }else if (stage == CrowdsaleStage.ICO2) {
700           EthTransferred("forwarding funds to refundable vault");
701           super.forwardFunds();
702       }else if (stage == CrowdsaleStage.ICO3) {
703           EthTransferred("forwarding funds to refundable vault");
704           super.forwardFunds();
705       }
706   }
707 
708 
709   function finish(address _teamFund, address _ecosystemFund, address _developmentFunds) public onlyOwner {
710 
711       require(!isFinalized);
712       uint256 alreadyMinted = token.totalSupply();
713       require(alreadyMinted < maxTokens);
714 
715       uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
716       if (unsoldTokens > 0) {
717         tokensForEcosystem = tokensForEcosystem + unsoldTokens;
718       }
719 
720       token.mint(_teamFund,tokensForTeam);
721       token.mint(_developmentFunds,tokensForDevelopment);
722       token.mint(_ecosystemFund,tokensForEcosystem);      
723       finalize();
724   }
725 
726 
727   
728 
729 }