1 pragma solidity ^0.4.18;
2 
3 // File: src/Token/FallbackToken.sol
4 
5 /**
6  * @title FallbackToken token
7  *
8  * @dev add ERC223 standard ability
9  **/
10 contract FallbackToken {
11 
12   function isContract(address _addr) internal constant returns (bool) {
13     uint length;
14     _addr = _addr;
15     assembly {length := extcodesize(_addr)}
16     return (length > 0);
17   }
18 }
19 
20 
21 contract Receiver {
22   function tokenFallback(address from, uint value) public;
23 }
24 
25 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 // File: zeppelin-solidity/contracts/math/SafeMath.sol
70 
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that throw on error
74  */
75 library SafeMath {
76   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77     if (a == 0) {
78       return 0;
79     }
80     uint256 c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return c;
90   }
91 
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112   uint256 public totalSupply;
113   function balanceOf(address who) public view returns (uint256);
114   function transfer(address to, uint256 value) public returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 // File: zeppelin-solidity/contracts/token/BasicToken.sol
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances.
123  */
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint256;
126 
127   mapping(address => uint256) balances;
128 
129   /**
130   * @dev transfer token for a specified address
131   * @param _to The address to transfer to.
132   * @param _value The amount to be transferred.
133   */
134   function transfer(address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[msg.sender]);
137 
138     // SafeMath.sub will throw if there is not enough balance.
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256 balance) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 // File: zeppelin-solidity/contracts/token/ERC20.sol
157 
158 /**
159  * @title ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/20
161  */
162 contract ERC20 is ERC20Basic {
163   function allowance(address owner, address spender) public view returns (uint256);
164   function transferFrom(address from, address to, uint256 value) public returns (bool);
165   function approve(address spender, uint256 value) public returns (bool);
166   event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 // File: zeppelin-solidity/contracts/token/StandardToken.sol
170 
171 /**
172  * @title Standard ERC20 token
173  *
174  * @dev Implementation of the basic standard token.
175  * @dev https://github.com/ethereum/EIPs/issues/20
176  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
177  */
178 contract StandardToken is ERC20, BasicToken {
179 
180   mapping (address => mapping (address => uint256)) internal allowed;
181 
182 
183   /**
184    * @dev Transfer tokens from one address to another
185    * @param _from address The address which you want to send tokens from
186    * @param _to address The address which you want to transfer to
187    * @param _value uint256 the amount of tokens to be transferred
188    */
189   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
190     require(_to != address(0));
191     require(_value <= balances[_from]);
192     require(_value <= allowed[_from][msg.sender]);
193 
194     balances[_from] = balances[_from].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
197     Transfer(_from, _to, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203    *
204    * Beware that changing an allowance with this method brings the risk that someone may use both the old
205    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208    * @param _spender The address which will spend the funds.
209    * @param _value The amount of tokens to be spent.
210    */
211   function approve(address _spender, uint256 _value) public returns (bool) {
212     allowed[msg.sender][_spender] = _value;
213     Approval(msg.sender, _spender, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Function to check the amount of tokens that an owner allowed to a spender.
219    * @param _owner address The address which owns the funds.
220    * @param _spender address The address which will spend the funds.
221    * @return A uint256 specifying the amount of tokens still available for the spender.
222    */
223   function allowance(address _owner, address _spender) public view returns (uint256) {
224     return allowed[_owner][_spender];
225   }
226 
227   /**
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    */
233   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
234     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 // File: zeppelin-solidity/contracts/token/MintableToken.sol
253 
254 /**
255  * @title Mintable token
256  * @dev Simple ERC20 Token example, with mintable token creation
257  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
258  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
259  */
260 
261 contract MintableToken is StandardToken, Ownable {
262   event Mint(address indexed to, uint256 amount);
263   event MintFinished();
264 
265   bool public mintingFinished = false;
266 
267 
268   modifier canMint() {
269     require(!mintingFinished);
270     _;
271   }
272 
273   /**
274    * @dev Function to mint tokens
275    * @param _to The address that will receive the minted tokens.
276    * @param _amount The amount of tokens to mint.
277    * @return A boolean that indicates if the operation was successful.
278    */
279   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
280     totalSupply = totalSupply.add(_amount);
281     balances[_to] = balances[_to].add(_amount);
282     Mint(_to, _amount);
283     Transfer(address(0), _to, _amount);
284     return true;
285   }
286 
287   /**
288    * @dev Function to stop minting new tokens.
289    * @return True if the operation was successful.
290    */
291   function finishMinting() onlyOwner canMint public returns (bool) {
292     mintingFinished = true;
293     MintFinished();
294     return true;
295   }
296 }
297 
298 // File: src/Token/TrustaBitToken.sol
299 
300 /**
301  * @title SimpleToken
302  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
303  * Note they can later distribute these tokens as they wish using `transfer` and other
304  * `StandardToken` functions.
305  */
306 contract TrustaBitToken is MintableToken, FallbackToken {
307 
308   string public constant name = "TrustaBits";
309 
310   string public constant symbol = "TAB";
311 
312   uint256 public constant decimals = 18;
313 
314   bool public released = false;
315 
316   event Release();
317 
318   modifier isReleased () {
319     require(mintingFinished);
320     require(released);
321     _;
322   }
323 
324   /**
325     * Fix for the ERC20 short address attack
326     * http://vessenes.com/the-erc20-short-address-attack-explained/
327     */
328   modifier onlyPayloadSize(uint size) {
329     if (msg.data.length != size + 4) {
330       revert();
331     }
332     _;
333   }
334 
335   /**
336    * @dev Constructor that gives msg.sender all of existing tokens.K
337    */
338   /// function TrustaBitsToken() public {}
339 
340   /**
341    * @dev Fallback method will buyout tokens
342    */
343   function() public payable {
344     revert();
345   }
346 
347   function release() onlyOwner public returns (bool) {
348     require(mintingFinished);
349     require(!released);
350     released = true;
351     Release();
352 
353     return true;
354   }
355 
356   function transfer(address _to, uint256 _value) public isReleased onlyPayloadSize(2 * 32) returns (bool) {
357     require(super.transfer(_to, _value));
358 
359     if (isContract(_to)) {
360       Receiver(_to).tokenFallback(msg.sender, _value);
361     }
362 
363     return true;
364   }
365 
366   function transferFrom(address _from, address _to, uint256 _value) public isReleased returns (bool) {
367     return super.transferFrom(_from, _to, _value);
368   }
369 
370   function approve(address _spender, uint256 _value) public isReleased returns (bool) {
371     return super.approve(_spender, _value);
372   }
373 
374   function increaseApproval(address _spender, uint _addedValue) public isReleased onlyPayloadSize(2 * 32) returns (bool success) {
375     return super.increaseApproval(_spender, _addedValue);
376   }
377 
378   function decreaseApproval(address _spender, uint _subtractedValue) public isReleased returns (bool success) {
379     return super.decreaseApproval(_spender, _subtractedValue);
380   }
381 
382 }
383 
384 // File: src/Crowdsale/MilestoneCrowdsale.sol
385 
386 contract MilestoneCrowdsale {
387 
388   using SafeMath for uint256;
389 
390   /* Number of available tokens */
391   uint256 public constant AVAILABLE_TOKENS = 1e9; //1 billion
392 
393   /* Total Tokens available in PreSale */
394   uint256 public constant AVAILABLE_IN_PRE_SALE = 40e6; // 40,000,000
395 
396   /* Total Tokens available in Main ICO */
397   uint256 public constant AVAILABLE_IN_MAIN = 610e6; // 610,000,000;
398 
399   /* Early Investors token available */
400   uint256 public constant AVAILABLE_FOR_EARLY_INVESTORS = 100e6; // 100,000,000;
401 
402   /* Pre-Sale Start Date */
403   uint public preSaleStartDate;
404 
405   /* Pre-Sale End Date */
406   uint public preSaleEndDate;
407 
408   /* Main Token Sale Date */
409   uint public mainSaleStartDate;
410 
411   /* Main Token Sale End */
412   uint public mainSaleEndDate;
413 
414   struct Milestone {
415     uint start; // UNIX timestamp
416     uint end; // UNIX timestamp
417     uint256 bonus;
418     uint256 price;
419   }
420 
421   Milestone[] public milestones;
422 
423   uint256 public rateUSD; // (cents)
424 
425   uint256 public earlyInvestorTokenRaised;
426   uint256 public preSaleTokenRaised;
427   uint256 public mainSaleTokenRaised;
428 
429 
430   function initMilestones(uint _rate, uint _preSaleStartDate, uint _preSaleEndDate, uint _mainSaleStartDate, uint _mainSaleEndDate) internal {
431     rateUSD = _rate;
432     preSaleStartDate = _preSaleStartDate;
433     preSaleEndDate = _preSaleEndDate;
434     mainSaleStartDate = _mainSaleStartDate;
435     mainSaleEndDate = _mainSaleEndDate;
436 
437     /**
438      * Early investor Milestone
439      * Prise: $0.025 USD (2.5 cent)
440      * No bonuses
441      */
442     uint256 earlyInvestorPrice = ((25 * 1 ether) / (rateUSD * 10));
443     milestones.push(Milestone(now, preSaleStartDate, 0, earlyInvestorPrice));
444 
445     /**
446      * Pre-Sale Milestone
447      * Prise: $0.05 USD (5 cent)
448      * Bonus: 20%
449      */
450     uint256 preSalePrice = usdToEther(5);
451     milestones.push(Milestone(preSaleStartDate, preSaleEndDate, 20, preSalePrice));
452 
453     /**
454      * Main Milestones
455      * Prise: $0.10 USD (10 cent)
456      * Week 1 Bonus: 15%
457      * Week 2 Main Token Sale Bonus: 10%
458      * Week 3 Main Token Sale Bonus: 5%
459      */
460     uint256 mainSalePrice = usdToEther(10);
461     uint mainSaleStartDateWeek1 = mainSaleStartDate + 1 weeks;
462     uint mainSaleStartDateWeek3 = mainSaleStartDate + 3 * 1 weeks;
463     uint mainSaleStartDateWeek2 = mainSaleStartDate + 2 * 1 weeks;
464 
465     milestones.push(Milestone(mainSaleStartDate, mainSaleStartDateWeek1, 15, mainSalePrice));
466     milestones.push(Milestone(mainSaleStartDateWeek1, mainSaleStartDateWeek2, 10, mainSalePrice));
467     milestones.push(Milestone(mainSaleStartDateWeek2, mainSaleStartDateWeek3, 5, mainSalePrice));
468     milestones.push(Milestone(mainSaleStartDateWeek3, _mainSaleEndDate, 0, mainSalePrice));
469   }
470 
471   function usdToEther(uint256 usdValue) public view returns (uint256) {
472     // (usdValue * 1 ether / rateUSD)
473     return usdValue.mul(1 ether).div(rateUSD);
474   }
475 
476   function getCurrentMilestone() internal view returns (uint256, uint256) {
477     for (uint i = 0; i < milestones.length; i++) {
478       if (now >= milestones[i].start && now < milestones[i].end) {
479         var milestone = milestones[i];
480         return (milestone.bonus, milestone.price);
481       }
482     }
483 
484     return (0, 0);
485   }
486 
487   function getCurrentPrice() public view returns (uint256) {
488     var (, price) = getCurrentMilestone();
489 
490     return price;
491   }
492 
493   function getTokenRaised() public view returns (uint256) {
494     return mainSaleTokenRaised.add(preSaleTokenRaised.add(earlyInvestorTokenRaised));
495   }
496 
497   function isEarlyInvestors() public view returns (bool) {
498     return now < preSaleStartDate;
499   }
500 
501   function isPreSale() public view returns (bool) {
502     return now >= preSaleStartDate && now < preSaleEndDate;
503   }
504 
505   function isMainSale() public view returns (bool) {
506     return now >= mainSaleStartDate && now < mainSaleEndDate;
507   }
508 
509   function isEnded() public view returns (bool) {
510     return now >= mainSaleEndDate;
511   }
512 
513 }
514 
515 // File: zeppelin-solidity/contracts/crowdsale/RefundVault.sol
516 
517 /**
518  * @title RefundVault
519  * @dev This contract is used for storing funds while a crowdsale
520  * is in progress. Supports refunding the money if crowdsale fails,
521  * and forwarding it if crowdsale is successful.
522  */
523 contract RefundVault is Ownable {
524   using SafeMath for uint256;
525 
526   enum State { Active, Refunding, Closed }
527 
528   mapping (address => uint256) public deposited;
529   address public wallet;
530   State public state;
531 
532   event Closed();
533   event RefundsEnabled();
534   event Refunded(address indexed beneficiary, uint256 weiAmount);
535 
536   function RefundVault(address _wallet) public {
537     require(_wallet != address(0));
538     wallet = _wallet;
539     state = State.Active;
540   }
541 
542   function deposit(address investor) onlyOwner public payable {
543     require(state == State.Active);
544     deposited[investor] = deposited[investor].add(msg.value);
545   }
546 
547   function close() onlyOwner public {
548     require(state == State.Active);
549     state = State.Closed;
550     Closed();
551     wallet.transfer(this.balance);
552   }
553 
554   function enableRefunds() onlyOwner public {
555     require(state == State.Active);
556     state = State.Refunding;
557     RefundsEnabled();
558   }
559 
560   function refund(address investor) public {
561     require(state == State.Refunding);
562     uint256 depositedValue = deposited[investor];
563     deposited[investor] = 0;
564     investor.transfer(depositedValue);
565     Refunded(investor, depositedValue);
566   }
567 }
568 
569 // File: src/Crowdsale/TrustaBitCrowdsale.sol
570 
571 contract TrustaBitCrowdsale is MilestoneCrowdsale, Ownable {
572 
573   using SafeMath for uint256;
574 
575   /* Minimum contribution */
576   uint public constant MINIMUM_CONTRIBUTION = 3 ether;
577 
578   /* Soft cap */
579   uint public constant softCapUSD = 3e6; //$3 Million USD
580   uint public softCap; //$3 Million USD in ETH
581 
582   /* Hard Cap */
583   uint public constant hardCapUSD = 49e6; //$49 Million USD
584   uint public hardCap; //$49 Million USD in ETH
585 
586   /* Advisory Bounty Team */
587   address public addressAdvisoryBountyTeam;
588   uint256 public constant tokenAdvisoryBountyTeam = 250e6;
589 
590   address[] public investors;
591 
592   TrustaBitToken public token;
593 
594   address public wallet;
595 
596   uint256 public weiRaised;
597 
598   RefundVault public vault;
599 
600   bool public isFinalized = false;
601 
602   event Finalized();
603 
604   /**
605    * event for token purchase logging
606    * @param investor who got the tokens
607    * @param value weis paid for purchase
608    * @param amount amount of tokens purchased
609    */
610   event TokenPurchase(address indexed investor, uint256 value, uint256 amount);
611 
612   modifier hasMinimumContribution() {
613     require(msg.value >= MINIMUM_CONTRIBUTION);
614     _;
615   }
616 
617   function TrustaBitCrowdsale(address _wallet, address _token, uint _rate, uint _preSaleStartDate, uint _preSaleEndDate, uint _mainSaleStartDate, uint _mainSaleEndDate, address _AdvisoryBountyTeam) public {
618     require(_token != address(0));
619     require(_AdvisoryBountyTeam != address(0));
620     require(_rate > 0);
621     require(_preSaleStartDate > 0);
622     require(_preSaleEndDate > 0);
623     require(_preSaleEndDate > _preSaleStartDate);
624     require(_mainSaleStartDate > 0);
625     require(_mainSaleStartDate >= _preSaleEndDate);
626     require(_mainSaleEndDate > 0);
627     require(_mainSaleEndDate > _mainSaleStartDate);
628 
629     wallet = _wallet;
630     token = TrustaBitToken(_token);
631     addressAdvisoryBountyTeam = _AdvisoryBountyTeam;
632 
633     initMilestones(_rate, _preSaleStartDate, _preSaleEndDate, _mainSaleStartDate, _mainSaleEndDate);
634 
635     softCap = usdToEther(softCapUSD.mul(100));
636     hardCap = usdToEther(hardCapUSD.mul(100));
637 
638     vault = new RefundVault(wallet);
639   }
640 
641   function investorsCount() public constant returns (uint) {
642     return investors.length;
643   }
644 
645   // fallback function can be used to buy tokens
646   function() external payable {
647     buyTokens(msg.sender);
648   }
649 
650   // low level token purchase function
651   function buyTokens(address investor) public hasMinimumContribution payable {
652     require(investor != address(0));
653     require(!isEnded());
654 
655     uint256 weiAmount = msg.value;
656 
657     require(getCurrentPrice() > 0);
658 
659     uint256 tokensAmount = calculateTokens(weiAmount);
660     require(tokensAmount > 0);
661 
662     mintTokens(investor, weiAmount, tokensAmount);
663     increaseRaised(weiAmount, tokensAmount);
664 
665     if (vault.deposited(investor) == 0) {
666       investors.push(investor);
667     }
668     // send ether to the fund collection wallet
669     vault.deposit.value(weiAmount)(investor);
670   }
671 
672   function calculateTokens(uint256 weiAmount) internal view returns (uint256) {
673     if ((weiRaised.add(weiAmount)) > hardCap) return 0;
674 
675     var (bonus, price) = getCurrentMilestone();
676 
677     uint256 tokensAmount = weiAmount.div(price).mul(10 ** token.decimals());
678     tokensAmount = tokensAmount.add(tokensAmount.mul(bonus).div(100));
679 
680     if (isEarlyInvestorsTokenRaised(tokensAmount)) return 0;
681     if (isPreSaleTokenRaised(tokensAmount)) return 0;
682     if (isMainSaleTokenRaised(tokensAmount)) return 0;
683     if (isTokenAvailable(tokensAmount)) return 0;
684 
685     return tokensAmount;
686   }
687 
688   function isEarlyInvestorsTokenRaised(uint256 tokensAmount) public view returns (bool) {
689     return isEarlyInvestors() && (earlyInvestorTokenRaised.add(tokensAmount) > AVAILABLE_FOR_EARLY_INVESTORS.mul(10 ** token.decimals()));
690   }
691 
692   function isPreSaleTokenRaised(uint256 tokensAmount) public view returns (bool) {
693     return isPreSale() && (preSaleTokenRaised.add(tokensAmount) > AVAILABLE_IN_PRE_SALE.mul(10 ** token.decimals()));
694   }
695 
696   function isMainSaleTokenRaised(uint256 tokensAmount) public view returns (bool) {
697     return isMainSale() && (mainSaleTokenRaised.add(tokensAmount) > AVAILABLE_IN_MAIN.mul(10 ** token.decimals()));
698   }
699 
700   function isTokenAvailable(uint256 tokensAmount) public view returns (bool) {
701     return getTokenRaised().add(tokensAmount) > AVAILABLE_TOKENS.mul(10 ** token.decimals());
702   }
703 
704   function increaseRaised(uint256 weiAmount, uint256 tokensAmount) internal {
705     weiRaised = weiRaised.add(weiAmount);
706 
707     if (isEarlyInvestors()) {
708       earlyInvestorTokenRaised = earlyInvestorTokenRaised.add(tokensAmount);
709     }
710 
711     if (isPreSale()) {
712       preSaleTokenRaised = preSaleTokenRaised.add(tokensAmount);
713     }
714 
715     if (isMainSale()) {
716       mainSaleTokenRaised = mainSaleTokenRaised.add(tokensAmount);
717     }
718   }
719 
720   function mintTokens(address investor, uint256 weiAmount, uint256 tokens) internal {
721     token.mint(investor, tokens);
722     TokenPurchase(investor, weiAmount, tokens);
723   }
724 
725   function finalize() onlyOwner public {
726     require(!isFinalized);
727     require(isEnded());
728 
729     if (softCapReached()) {
730       vault.close();
731       mintAdvisoryBountyTeam();
732       token.finishMinting();
733     }
734     else {
735       vault.enableRefunds();
736       token.finishMinting();
737     }
738 
739     token.transferOwnership(owner);
740 
741     isFinalized = true;
742     Finalized();
743   }
744 
745   function mintAdvisoryBountyTeam() internal {
746     mintTokens(addressAdvisoryBountyTeam, 0, tokenAdvisoryBountyTeam.mul(10 ** token.decimals()));
747   }
748 
749   // if crowdsale is unsuccessful, investors can claim refunds here
750   function claimRefund() public {
751     require(isFinalized);
752     require(!softCapReached());
753 
754     vault.refund(msg.sender);
755   }
756 
757   function refund() onlyOwner public {
758     require(isFinalized);
759     require(!softCapReached());
760 
761     for (uint i = 0; i < investors.length; i++) {
762       address investor = investors[i];
763       if (vault.deposited(investor) != 0) {
764         vault.refund(investor);
765       }
766     }
767   }
768 
769   function softCapReached() public view returns (bool) {
770     return weiRaised >= softCap;
771   }
772 
773   function hardCapReached() public view returns (bool) {
774     return weiRaised >= hardCap;
775   }
776 
777   function destroy() onlyOwner public {
778     selfdestruct(owner);
779   }
780 }