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
12   function isContract(address _addr) internal view returns (bool) {
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
329     require(msg.data.length != size + 4);
330     _;
331   }
332 
333   function release() onlyOwner public returns (bool) {
334     require(mintingFinished);
335     require(!released);
336     released = true;
337     Release();
338 
339     return true;
340   }
341 
342   function transfer(address _to, uint256 _value) public isReleased onlyPayloadSize(2 * 32) returns (bool) {
343     require(super.transfer(_to, _value));
344 
345     if (isContract(_to)) {
346       Receiver(_to).tokenFallback(msg.sender, _value);
347     }
348 
349     return true;
350   }
351 
352   function transferFrom(address _from, address _to, uint256 _value) public isReleased returns (bool) {
353     return super.transferFrom(_from, _to, _value);
354   }
355 
356   function approve(address _spender, uint256 _value) public isReleased returns (bool) {
357     return super.approve(_spender, _value);
358   }
359 
360   function increaseApproval(address _spender, uint _addedValue) public isReleased onlyPayloadSize(2 * 32) returns (bool success) {
361     return super.increaseApproval(_spender, _addedValue);
362   }
363 
364   function decreaseApproval(address _spender, uint _subtractedValue) public isReleased returns (bool success) {
365     return super.decreaseApproval(_spender, _subtractedValue);
366   }
367 
368 }
369 
370 // File: src/Crowdsale/MilestoneCrowdsale.sol
371 
372 contract MilestoneCrowdsale {
373 
374   using SafeMath for uint256;
375 
376   /* Number of available tokens */
377   uint256 public constant AVAILABLE_TOKENS = 1e9; //1 billion
378 
379   /* Total Tokens available in PreSale */
380   uint256 public constant AVAILABLE_IN_PRE_SALE = 40e6; // 40,000,000
381 
382   /* Total Tokens available in Main ICO */
383   uint256 public constant AVAILABLE_IN_MAIN = 610e6; // 610,000,000;
384 
385   /* Early Investors token available */
386   uint256 public constant AVAILABLE_FOR_EARLY_INVESTORS = 100e6; // 100,000,000;
387 
388   /* Pre-Sale Start Date */
389   uint public preSaleStartDate;
390 
391   /* Pre-Sale End Date */
392   uint public preSaleEndDate;
393 
394   /* Main Token Sale Date */
395   uint public mainSaleStartDate;
396 
397   /* Main Token Sale End */
398   uint public mainSaleEndDate;
399 
400   struct Milestone {
401     uint start; // UNIX timestamp
402     uint end; // UNIX timestamp
403     uint256 bonus;
404     uint256 price;
405   }
406 
407   Milestone[] public milestones;
408 
409   uint256 public rateUSD; // (cents)
410 
411   uint256 public earlyInvestorTokenRaised;
412   uint256 public preSaleTokenRaised;
413   uint256 public mainSaleTokenRaised;
414 
415 
416   function initMilestones(uint _rate, uint _preSaleStartDate, uint _preSaleEndDate, uint _mainSaleStartDate, uint _mainSaleEndDate) internal {
417     rateUSD = _rate;
418     preSaleStartDate = _preSaleStartDate;
419     preSaleEndDate = _preSaleEndDate;
420     mainSaleStartDate = _mainSaleStartDate;
421     mainSaleEndDate = _mainSaleEndDate;
422 
423     /**
424      * Early investor Milestone
425      * Prise: $0.025 USD (2.5 cent)
426      * No bonuses
427      */
428     uint256 earlyInvestorPrice = uint(25 ether).div(rateUSD.mul(10));
429     milestones.push(Milestone(0, preSaleStartDate, 0, earlyInvestorPrice));
430 
431     /**
432      * Pre-Sale Milestone
433      * Prise: $0.05 USD (5 cent)
434      * Bonus: 20%
435      */
436     uint256 preSalePrice = usdToEther(5);
437     milestones.push(Milestone(preSaleStartDate, preSaleEndDate, 20, preSalePrice));
438 
439     /**
440      * Main Milestones
441      * Prise: $0.10 USD (10 cent)
442      * Week 1 Bonus: 15%
443      * Week 2 Main Token Sale Bonus: 10%
444      * Week 3 Main Token Sale Bonus: 5%
445      */
446     uint256 mainSalePrice = usdToEther(10);
447     uint mainSaleStartDateWeek1 = mainSaleStartDate.add(1 weeks);
448     uint mainSaleStartDateWeek3 = mainSaleStartDate.add(3 weeks);
449     uint mainSaleStartDateWeek2 = mainSaleStartDate.add(2 weeks);
450 
451     milestones.push(Milestone(mainSaleStartDate, mainSaleStartDateWeek1, 15, mainSalePrice));
452     milestones.push(Milestone(mainSaleStartDateWeek1, mainSaleStartDateWeek2, 10, mainSalePrice));
453     milestones.push(Milestone(mainSaleStartDateWeek2, mainSaleStartDateWeek3, 5, mainSalePrice));
454     milestones.push(Milestone(mainSaleStartDateWeek3, _mainSaleEndDate, 0, mainSalePrice));
455   }
456 
457   function usdToEther(uint256 usdValue) public view returns (uint256) {
458     // (usdValue * 1 ether / rateUSD)
459     return usdValue.mul(1 ether).div(rateUSD);
460   }
461 
462   function getCurrentMilestone() internal view returns (uint256, uint256) {
463     for (uint i = 0; i < milestones.length; i++) {
464       if (now >= milestones[i].start && now < milestones[i].end) {
465         var milestone = milestones[i];
466         return (milestone.bonus, milestone.price);
467       }
468     }
469 
470     return (0, 0);
471   }
472 
473   function getCurrentPrice() public view returns (uint256) {
474     var (, price) = getCurrentMilestone();
475 
476     return price;
477   }
478 
479   function getTokenRaised() public view returns (uint256) {
480     return mainSaleTokenRaised.add(preSaleTokenRaised.add(earlyInvestorTokenRaised));
481   }
482 
483   function isEarlyInvestors() public view returns (bool) {
484     return now < preSaleStartDate;
485   }
486 
487   function isPreSale() public view returns (bool) {
488     return now >= preSaleStartDate && now < preSaleEndDate;
489   }
490 
491   function isMainSale() public view returns (bool) {
492     return now >= mainSaleStartDate && now < mainSaleEndDate;
493   }
494 
495   function isEnded() public view returns (bool) {
496     return now >= mainSaleEndDate;
497   }
498 
499 }
500 
501 // File: zeppelin-solidity/contracts/crowdsale/RefundVault.sol
502 
503 /**
504  * @title RefundVault
505  * @dev This contract is used for storing funds while a crowdsale
506  * is in progress. Supports refunding the money if crowdsale fails,
507  * and forwarding it if crowdsale is successful.
508  */
509 contract RefundVault is Ownable {
510   using SafeMath for uint256;
511 
512   enum State { Active, Refunding, Closed }
513 
514   mapping (address => uint256) public deposited;
515   address public wallet;
516   State public state;
517 
518   event Closed();
519   event RefundsEnabled();
520   event Refunded(address indexed beneficiary, uint256 weiAmount);
521 
522   function RefundVault(address _wallet) public {
523     require(_wallet != address(0));
524     wallet = _wallet;
525     state = State.Active;
526   }
527 
528   function deposit(address investor) onlyOwner public payable {
529     require(state == State.Active);
530     deposited[investor] = deposited[investor].add(msg.value);
531   }
532 
533   function close() onlyOwner public {
534     require(state == State.Active);
535     state = State.Closed;
536     Closed();
537     wallet.transfer(this.balance);
538   }
539 
540   function enableRefunds() onlyOwner public {
541     require(state == State.Active);
542     state = State.Refunding;
543     RefundsEnabled();
544   }
545 
546   function refund(address investor) public {
547     require(state == State.Refunding);
548     uint256 depositedValue = deposited[investor];
549     deposited[investor] = 0;
550     investor.transfer(depositedValue);
551     Refunded(investor, depositedValue);
552   }
553 }
554 
555 // File: src/Crowdsale/TrustaBitCrowdsale.sol
556 
557 contract TrustaBitCrowdsale is MilestoneCrowdsale, Ownable {
558 
559   using SafeMath for uint256;
560 
561   /* Minimum contribution */
562   uint public constant MINIMUM_CONTRIBUTION = 15e16;
563 
564   /* Soft cap */
565   uint public constant softCapUSD = 3e6; //$3 Million USD
566   uint public softCap; //$3 Million USD in ETH
567 
568   /* Hard Cap */
569   uint public constant hardCapUSD = 49e6; //$49 Million USD
570   uint public hardCap; //$49 Million USD in ETH
571 
572   /* Advisory Bounty Team */
573   address public addressAdvisoryBountyTeam;
574   uint256 public constant tokenAdvisoryBountyTeam = 250e6;
575 
576   address[] public investors;
577 
578   TrustaBitToken public token;
579 
580   address public wallet;
581 
582   uint256 public weiRaised;
583 
584   RefundVault public vault;
585 
586   bool public isFinalized = false;
587 
588   event Finalized();
589 
590   /**
591    * event for token purchase logging
592    * @param investor who got the tokens
593    * @param value weis paid for purchase
594    * @param amount amount of tokens purchased
595    */
596   event TokenPurchase(address indexed investor, uint256 value, uint256 amount);
597 
598   modifier hasMinimumContribution() {
599     require(msg.value >= MINIMUM_CONTRIBUTION);
600     _;
601   }
602 
603   function TrustaBitCrowdsale(address _wallet, address _token, uint _rate, uint _preSaleStartDate, uint _preSaleEndDate, uint _mainSaleStartDate, uint _mainSaleEndDate, address _AdvisoryBountyTeam) public {
604     require(_token != address(0));
605     require(_AdvisoryBountyTeam != address(0));
606     require(_rate > 0);
607     require(_preSaleStartDate > 0);
608     require(_preSaleEndDate > 0);
609     require(_preSaleEndDate > _preSaleStartDate);
610     require(_mainSaleStartDate > 0);
611     require(_mainSaleStartDate >= _preSaleEndDate);
612     require(_mainSaleEndDate > 0);
613     require(_mainSaleEndDate > _mainSaleStartDate);
614 
615     wallet = _wallet;
616     token = TrustaBitToken(_token);
617     addressAdvisoryBountyTeam = _AdvisoryBountyTeam;
618 
619     initMilestones(_rate, _preSaleStartDate, _preSaleEndDate, _mainSaleStartDate, _mainSaleEndDate);
620 
621     softCap = usdToEther(softCapUSD.mul(100));
622     hardCap = usdToEther(hardCapUSD.mul(100));
623 
624     vault = new RefundVault(wallet);
625   }
626 
627   function investorsCount() public view returns (uint) {
628     return investors.length;
629   }
630 
631   // fallback function can be used to buy tokens
632   function() external payable {
633     buyTokens(msg.sender);
634   }
635 
636   // low level token purchase function
637   function buyTokens(address investor) public hasMinimumContribution payable {
638     require(investor != address(0));
639     require(!isEnded());
640 
641     uint256 weiAmount = msg.value;
642 
643     require(getCurrentPrice() > 0);
644 
645     uint256 tokensAmount = calculateTokens(weiAmount);
646     require(tokensAmount > 0);
647 
648     mintTokens(investor, weiAmount, tokensAmount);
649     increaseRaised(weiAmount, tokensAmount);
650 
651     if (vault.deposited(investor) == 0) {
652       investors.push(investor);
653     }
654     // send ether to the fund collection wallet
655     vault.deposit.value(weiAmount)(investor);
656   }
657 
658   function calculateTokens(uint256 weiAmount) internal view returns (uint256) {
659     if ((weiRaised.add(weiAmount)) > hardCap) return 0;
660 
661     var (bonus, price) = getCurrentMilestone();
662 
663     uint256 tokensAmount = weiAmount.div(price).mul(10 ** token.decimals());
664     tokensAmount = tokensAmount.add(tokensAmount.mul(bonus).div(100));
665 
666     if (isEarlyInvestorsTokenRaised(tokensAmount)) return 0;
667     if (isPreSaleTokenRaised(tokensAmount)) return 0;
668     if (isMainSaleTokenRaised(tokensAmount)) return 0;
669     if (isTokenAvailable(tokensAmount)) return 0;
670 
671     return tokensAmount;
672   }
673 
674   function isEarlyInvestorsTokenRaised(uint256 tokensAmount) public view returns (bool) {
675     return isEarlyInvestors() && (earlyInvestorTokenRaised.add(tokensAmount) > AVAILABLE_FOR_EARLY_INVESTORS.mul(10 ** token.decimals()));
676   }
677 
678   function isPreSaleTokenRaised(uint256 tokensAmount) public view returns (bool) {
679     return isPreSale() && (preSaleTokenRaised.add(tokensAmount) > AVAILABLE_IN_PRE_SALE.mul(10 ** token.decimals()));
680   }
681 
682   function isMainSaleTokenRaised(uint256 tokensAmount) public view returns (bool) {
683     return isMainSale() && (mainSaleTokenRaised.add(tokensAmount) > AVAILABLE_IN_MAIN.mul(10 ** token.decimals()));
684   }
685 
686   function isTokenAvailable(uint256 tokensAmount) public view returns (bool) {
687     return getTokenRaised().add(tokensAmount) > AVAILABLE_TOKENS.mul(10 ** token.decimals());
688   }
689 
690   function increaseRaised(uint256 weiAmount, uint256 tokensAmount) internal {
691     weiRaised = weiRaised.add(weiAmount);
692 
693     if (isEarlyInvestors()) {
694       earlyInvestorTokenRaised = earlyInvestorTokenRaised.add(tokensAmount);
695     }
696 
697     if (isPreSale()) {
698       preSaleTokenRaised = preSaleTokenRaised.add(tokensAmount);
699     }
700 
701     if (isMainSale()) {
702       mainSaleTokenRaised = mainSaleTokenRaised.add(tokensAmount);
703     }
704   }
705 
706   function mintTokens(address investor, uint256 weiAmount, uint256 tokens) internal {
707     token.mint(investor, tokens);
708     TokenPurchase(investor, weiAmount, tokens);
709   }
710 
711   function finalize() onlyOwner public {
712     require(!isFinalized);
713     require(isEnded());
714 
715     if (softCapReached()) {
716       vault.close();
717       mintAdvisoryBountyTeam();
718       token.finishMinting();
719     }
720     else {
721       vault.enableRefunds();
722       token.finishMinting();
723     }
724 
725     token.transferOwnership(owner);
726 
727     isFinalized = true;
728     Finalized();
729   }
730 
731   function mintAdvisoryBountyTeam() internal {
732     mintTokens(addressAdvisoryBountyTeam, 0, tokenAdvisoryBountyTeam.mul(10 ** token.decimals()));
733   }
734 
735   // if crowdsale is unsuccessful, investors can claim refunds here
736   function claimRefund() public {
737     require(isFinalized);
738     require(!softCapReached());
739 
740     vault.refund(msg.sender);
741   }
742 
743   function refund() onlyOwner public {
744     require(isFinalized);
745     require(!softCapReached());
746 
747     for (uint i = 0; i < investors.length; i++) {
748       address investor = investors[i];
749       if (vault.deposited(investor) != 0) {
750         vault.refund(investor);
751       }
752     }
753   }
754 
755   function softCapReached() public view returns (bool) {
756     return weiRaised >= softCap;
757   }
758 
759   function hardCapReached() public view returns (bool) {
760     return weiRaised >= hardCap;
761   }
762 
763   function destroy() onlyOwner public {
764     selfdestruct(owner);
765   }
766 }