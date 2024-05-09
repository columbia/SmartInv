1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 
48 
49 
50 
51 /**
52  * @title Pausable
53  * @dev Base contract which allows children to implement an emergency stop mechanism.
54  */
55 contract Pausable is Ownable {
56   event Pause();
57   event Unpause();
58 
59   bool public paused = false;
60 
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is not paused.
64    */
65   modifier whenNotPaused() {
66     require(!paused);
67     _;
68   }
69 
70   /**
71    * @dev Modifier to make a function callable only when the contract is paused.
72    */
73   modifier whenPaused() {
74     require(paused);
75     _;
76   }
77 
78   /**
79    * @dev called by the owner to pause, triggers stopped state
80    */
81   function pause() onlyOwner whenNotPaused public {
82     paused = true;
83     Pause();
84   }
85 
86   /**
87    * @dev called by the owner to unpause, returns to normal state
88    */
89   function unpause() onlyOwner whenPaused public {
90     paused = false;
91     Unpause();
92   }
93 }
94 
95 
96 /**
97  * @title ERC20Basic
98  * @dev Simpler version of ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/179
100  */
101 contract ERC20Basic {
102   uint256 public totalSupply;
103   function balanceOf(address who) public view returns (uint256);
104   function transfer(address to, uint256 value) public returns (bool);
105   event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances.
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     // SafeMath.sub will throw if there is not enough balance.
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153   }
154 
155 }
156 
157 
158 
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * @dev https://github.com/ethereum/EIPs/issues/20
165  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
166  */
167 contract StandardToken is ERC20, BasicToken {
168 
169   mapping (address => mapping (address => uint256)) internal allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint256 the amount of tokens to be transferred
177    */
178   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[_from]);
181     require(_value <= allowed[_from][msg.sender]);
182 
183     balances[_from] = balances[_from].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186     Transfer(_from, _to, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    *
193    * Beware that changing an allowance with this method brings the risk that someone may use both the old
194    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public returns (bool) {
201     allowed[msg.sender][_spender] = _value;
202     Approval(msg.sender, _spender, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(address _owner, address _spender) public view returns (uint256) {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    */
222   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
229     uint oldValue = allowed[msg.sender][_spender];
230     if (_subtractedValue > oldValue) {
231       allowed[msg.sender][_spender] = 0;
232     } else {
233       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234     }
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239 }
240 
241 
242 /**
243  * @title Pausable token
244  *
245  * @dev StandardToken modified with pausable transfers.
246  **/
247 
248 contract PausableToken is StandardToken, Pausable {
249 
250   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
251     return super.transfer(_to, _value);
252   }
253 
254   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
255     return super.transferFrom(_from, _to, _value);
256   }
257 
258   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
259     return super.approve(_spender, _value);
260   }
261 
262   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
263     return super.increaseApproval(_spender, _addedValue);
264   }
265 
266   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
267     return super.decreaseApproval(_spender, _subtractedValue);
268   }
269 }
270 
271 contract EthixToken is PausableToken {
272   string public constant name = "EthixToken";
273   string public constant symbol = "ETHIX";
274   uint8 public constant decimals = 18;
275 
276   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
277   uint256 public totalSupply;
278 
279   /**
280    * @dev Constructor that gives msg.sender all of existing tokens.
281    */
282   function EthixToken() public {
283     totalSupply = INITIAL_SUPPLY;
284     balances[owner] = totalSupply;
285     Transfer(0x0, owner, INITIAL_SUPPLY);
286   }
287 
288 }
289 
290 
291 /**
292  * @title TokenDistributionStrategy
293  * @dev Base abstract contract defining methods that control token distribution
294  */
295 contract TokenDistributionStrategy {
296   using SafeMath for uint256;
297 
298   CompositeCrowdsale crowdsale;
299   uint256 rate;
300 
301   modifier onlyCrowdsale() {
302     require(msg.sender == address(crowdsale));
303     _;
304   }
305 
306   function TokenDistributionStrategy(uint256 _rate) {
307     require(_rate > 0);
308     rate = _rate;
309   }
310 
311   function initializeDistribution(CompositeCrowdsale _crowdsale) {
312     require(crowdsale == address(0));
313     require(_crowdsale != address(0));
314     crowdsale = _crowdsale;
315   }
316 
317   function returnUnsoldTokens(address _wallet) onlyCrowdsale {
318     
319   }
320 
321   function whitelistRegisteredAmount(address beneficiary) view returns (uint256 amount) {
322   }
323 
324   function distributeTokens(address beneficiary, uint amount);
325 
326   function calculateTokenAmount(uint256 _weiAmount, address beneficiary) view returns (uint256 amount);
327 
328   function getToken() view returns(ERC20);
329 
330   
331 
332 }
333 
334 
335 /**
336  * @title FixedPoolWithBonusTokenDistributionStrategy 
337  * @dev Strategy that distributes a fixed number of tokens among the contributors,
338  * with a percentage depending in when the contribution is made, defined by periods.
339  * It's done in two steps. First, it registers all of the contributions while the sale is active.
340  * After the crowdsale has ended the contract compensate buyers proportionally to their contributions.
341  * This class is abstract, the intervals have to be defined by subclassing
342  */
343 contract FixedPoolWithBonusTokenDistributionStrategy is TokenDistributionStrategy {
344   using SafeMath for uint256;
345   uint256 constant MAX_DISCOUNT = 100;
346 
347   // Definition of the interval when the bonus is applicable
348   struct BonusInterval {
349     //end timestamp
350     uint256 endPeriod;
351     // percentage
352     uint256 bonus;
353   }
354   BonusInterval[] bonusIntervals;
355   bool intervalsConfigured = false;
356 
357   // The token being sold
358   ERC20 token;
359   mapping(address => uint256) contributions;
360   uint256 totalContributed;
361   //mapping(uint256 => BonusInterval) bonusIntervals;
362 
363   function FixedPoolWithBonusTokenDistributionStrategy(ERC20 _token, uint256 _rate)
364            TokenDistributionStrategy(_rate) public
365   {
366     token = _token;
367   }
368 
369 
370   // First period will go from crowdsale.start_date to bonusIntervals[0].end
371   // Next intervals have to end after the previous ones
372   // Last interval must end when the crowdsale ends
373   // All intervals must have a positive bonus (penalizations are not contemplated)
374   modifier validateIntervals {
375     _;
376     require(intervalsConfigured == false);
377     intervalsConfigured = true;
378     require(bonusIntervals.length > 0);
379     for(uint i = 0; i < bonusIntervals.length; ++i) {
380       require(bonusIntervals[i].bonus <= MAX_DISCOUNT);
381       require(bonusIntervals[i].bonus >= 0);
382       require(crowdsale.startTime() < bonusIntervals[i].endPeriod);
383       require(bonusIntervals[i].endPeriod <= crowdsale.endTime());
384       if (i != 0) {
385         require(bonusIntervals[i-1].endPeriod < bonusIntervals[i].endPeriod);
386       }
387     }
388   }
389 
390   // Init intervals
391   function initIntervals() validateIntervals {
392   }
393 
394   function calculateTokenAmount(uint256 _weiAmount, address beneficiary) view returns (uint256 tokens) {
395     // calculate bonus in function of the time
396     for (uint i = 0; i < bonusIntervals.length; i++) {
397       if (now <= bonusIntervals[i].endPeriod) {
398         // calculate token amount to be created
399         tokens = _weiAmount.mul(rate);
400         // OP : tokens + ((tokens * bonusIntervals[i].bonus) / 100)
401         // BE CAREFULLY with decimals
402         return tokens.add(tokens.mul(bonusIntervals[i].bonus).div(100));
403       }
404     }
405     return _weiAmount.mul(rate);
406   }
407 
408   function distributeTokens(address _beneficiary, uint256 _tokenAmount) onlyCrowdsale {
409     contributions[_beneficiary] = contributions[_beneficiary].add(_tokenAmount);
410     totalContributed = totalContributed.add(_tokenAmount);
411     require(totalContributed <= token.balanceOf(this));
412   }
413 
414   function compensate(address _beneficiary) {
415     require(crowdsale.hasEnded());
416     if (token.transfer(_beneficiary, contributions[_beneficiary])) {
417       contributions[_beneficiary] = 0;
418     }
419   }
420 
421   function getTokenContribution(address _beneficiary) view returns(uint256){
422     return contributions[_beneficiary];
423   }
424 
425   function getToken() view returns(ERC20) {
426     return token;
427   }
428 
429   function getIntervals() view returns (uint256[] _endPeriods, uint256[] _bonuss) {
430     uint256[] memory endPeriods = new uint256[](bonusIntervals.length);
431     uint256[] memory bonuss = new uint256[](bonusIntervals.length);
432     for (uint256 i=0; i<bonusIntervals.length; i++) {
433       endPeriods[i] = bonusIntervals[i].endPeriod;
434       bonuss[i] = bonusIntervals[i].bonus;
435     }
436     return (endPeriods, bonuss);
437   }
438 
439 }
440 
441 
442 /**
443  * @title VestedTokenDistributionStrategy
444  * @dev Strategy that distributes a fixed number of tokens among the contributors.
445  * It's done in two steps. First, it registers all of the contributions while the sale is active.
446  * After the crowdsale has ended the contract compensate buyers proportionally to their contributions.
447  */
448 contract VestedTokenDistributionStrategy is Ownable, FixedPoolWithBonusTokenDistributionStrategy {
449 
450 
451   event Released(address indexed beneficiary, uint256 indexed amount);
452 
453   //Time after which is allowed to compensates
454   uint256 public vestingStart;
455   bool public vestingConfigured = false;
456   uint256 public vestingDuration;
457 
458   mapping (address => uint256) public released;
459 
460   modifier vestingPeriodStarted {
461     require(crowdsale.hasEnded());
462     require(vestingConfigured == true);
463     require(now > vestingStart);
464     _;
465   }
466 
467   function VestedTokenDistributionStrategy(ERC20 _token, uint256 _rate)
468             Ownable()
469             FixedPoolWithBonusTokenDistributionStrategy(_token, _rate) {
470 
471   }
472 
473   /**
474    * set the parameters for the compensation. Required to call before compensation
475    * @dev WARNING, ONE TIME OPERATION
476    * @param _vestingStart we start allowing  the return of tokens after this
477    * @param _vestingDuration percent each day (1 is 1% each day, 2 is % each 2 days, max 100)
478    */
479   function configureVesting(uint256 _vestingStart, uint256 _vestingDuration) onlyOwner {
480     require(vestingConfigured == false);
481     require(_vestingStart > crowdsale.endTime());
482     require(_vestingDuration > 0);
483     vestingStart = _vestingStart;
484     vestingDuration = _vestingDuration;
485     vestingConfigured = true;
486   }
487 
488   /**
489    * Will transfer the tokens vested until now to the beneficiary, if the vestingPeriodStarted
490    * and there is an amount left to transfer
491    * @param  _beneficiary crowdsale contributor
492    */
493    function compensate(address _beneficiary) public onlyOwner vestingPeriodStarted {
494      uint256 unreleased = releasableAmount(_beneficiary);
495 
496      require(unreleased > 0);
497 
498      released[_beneficiary] = released[_beneficiary].add(unreleased);
499 
500      require(token.transfer(_beneficiary, unreleased));
501      Released(_beneficiary,unreleased);
502 
503    }
504 
505   /**
506    * Calculates how many tokens the beneficiary should get taking in account already
507    * released
508    * @param  _beneficiary the contributor
509    * @return token number
510    */
511    function releasableAmount(address _beneficiary) public view returns (uint256) {
512      return vestedAmount(_beneficiary).sub(released[_beneficiary]);
513    }
514 
515   /**
516    * Calculates how many tokens the beneficiary have vested
517    * vested = how many does she have according to the time
518    * @param  _beneficiary address of the contributor that needs the tokens
519    * @return amount of tokens
520    */
521   function vestedAmount(address _beneficiary) public view returns (uint256) {
522     uint256 totalBalance = contributions[_beneficiary];
523     //Duration("after",vestingStart.add(vestingDuration));
524     if (now < vestingStart || vestingConfigured == false) {
525       return 0;
526     } else if (now >= vestingStart.add(vestingDuration)) {
527       return totalBalance;
528     } else {
529       return totalBalance.mul(now.sub(vestingStart)).div(vestingDuration);
530     }
531   }
532 
533   function getReleased(address _beneficiary) public view returns (uint256) {
534     return released[_beneficiary];
535   }
536 
537 }
538 
539 
540 /**
541  * @title WhitelistedDistributionStrategy
542  * @dev This is an extension to add whitelist to a token distributionStrategy
543  *
544  */
545 contract WhitelistedDistributionStrategy is Ownable, VestedTokenDistributionStrategy {
546     uint256 public constant maximumBidAllowed = 500 ether;
547 
548     uint256 rate_for_investor;
549     mapping(address=>uint) public registeredAmount;
550 
551     event RegistrationStatusChanged(address target, bool isRegistered);
552 
553     function WhitelistedDistributionStrategy(ERC20 _token, uint256 _rate, uint256 _whitelisted_rate)
554               VestedTokenDistributionStrategy(_token,_rate){
555         rate_for_investor = _whitelisted_rate;
556     }
557 
558     /**
559      * @dev Changes registration status of an address for participation.
560      * @param target Address that will be registered/deregistered.
561      * @param amount the amount of eht to invest for a investor bonus.
562      */
563     function changeRegistrationStatus(address target, uint256 amount)
564         public
565         onlyOwner
566     {
567         require(amount <= maximumBidAllowed);
568         registeredAmount[target] = amount;
569         if (amount > 0){
570             RegistrationStatusChanged(target, true);
571         }else{
572             RegistrationStatusChanged(target, false);
573         }
574     }
575 
576     /**
577      * @dev Changes registration statuses of addresses for participation.
578      * @param targets Addresses that will be registered/deregistered.
579      * @param amounts the list of amounts of eth for every investor to invest for a investor bonus.
580      */
581     function changeRegistrationStatuses(address[] targets, uint256[] amounts)
582         public
583         onlyOwner
584     {
585         require(targets.length == amounts.length);
586         for (uint i = 0; i < targets.length; i++) {
587             changeRegistrationStatus(targets[i], amounts[i]);
588         }
589     }
590 
591     /**
592      * @dev overriding calculateTokenAmount for whilelist investors
593      * @return bonus rate if it applies for the investor,
594      * otherwise, return token amount according to super class
595      */
596 
597     function calculateTokenAmount(uint256 _weiAmount, address beneficiary) view returns (uint256 tokens) {
598         if (_weiAmount >= registeredAmount[beneficiary] && registeredAmount[beneficiary] > 0 ){
599             tokens = _weiAmount.mul(rate_for_investor);
600         } else{
601             tokens = super.calculateTokenAmount(_weiAmount, beneficiary);
602         }
603     }
604 
605     /**
606      * @dev getRegisteredAmount for whilelist investors
607      * @return registered amount if it applies for the investor,
608      * otherwise, return 0 
609      */
610 
611     function whitelistRegisteredAmount(address beneficiary) view returns (uint256 amount) {
612         amount = registeredAmount[beneficiary];
613     }
614 }
615 
616 
617 /**
618  * @title EthicHubTokenDistributionStrategy
619  * @dev Strategy that distributes a fixed number of tokens among the contributors,
620  * with a percentage deppending in when the contribution is made, defined by periods.
621  * It's done in two steps. First, it registers all of the contributions while the sale is active.
622  * After the crowdsale has ended the contract compensate buyers proportionally to their contributions.
623  * Contributors registered to the whitelist will have better rates
624  */
625 contract EthicHubTokenDistributionStrategy is Ownable, WhitelistedDistributionStrategy {
626   
627   event UnsoldTokensReturned(address indexed destination, uint256 amount);
628 
629 
630   function EthicHubTokenDistributionStrategy(EthixToken _token, uint256 _rate, uint256 _rateForWhitelisted)
631            WhitelistedDistributionStrategy(_token, _rate, _rateForWhitelisted)
632            public
633   {
634 
635   }
636 
637 
638   // Init intervals
639   function initIntervals() onlyOwner validateIntervals  {
640 
641     //For extra security, we check the owner of the crowdsale is the same of the owner of the distribution
642     require(owner == crowdsale.owner());
643 
644     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 1 days,10));
645     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 2 days,10));
646     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 3 days,8));
647     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 4 days,6));
648     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 5 days,4));
649     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 6 days,2));
650   }
651 
652   function returnUnsoldTokens(address _wallet) onlyCrowdsale {
653     //require(crowdsale.endTime() <= now); //this made no sense
654     if (token.balanceOf(this) == 0) {
655       UnsoldTokensReturned(_wallet,0);
656       return;
657     }
658     
659     uint256 balance = token.balanceOf(this).sub(totalContributed);
660     require(balance > 0);
661 
662     if(token.transfer(_wallet, balance)) {
663       UnsoldTokensReturned(_wallet, balance);
664     }
665     
666   } 
667 }
668 
669 
670 
671 /**
672  * @title SafeMath
673  * @dev Math operations with safety checks that throw on error
674  */
675 library SafeMath {
676   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
677     if (a == 0) {
678       return 0;
679     }
680     uint256 c = a * b;
681     assert(c / a == b);
682     return c;
683   }
684 
685   function div(uint256 a, uint256 b) internal pure returns (uint256) {
686     // assert(b > 0); // Solidity automatically throws when dividing by 0
687     uint256 c = a / b;
688     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
689     return c;
690   }
691 
692   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
693     assert(b <= a);
694     return a - b;
695   }
696 
697   function add(uint256 a, uint256 b) internal pure returns (uint256) {
698     uint256 c = a + b;
699     assert(c >= a);
700     return c;
701   }
702 }
703 
704 
705 
706 
707 
708 /**
709  * @title CompositeCrowdsale
710  * @dev CompositeCrowdsale is a base contract for managing a token crowdsale.
711  * Contrary to a classic crowdsale, it favours composition over inheritance.
712  *
713  * Crowdsale behaviour can be modified by specifying TokenDistributionStrategy
714  * which is a dedicated smart contract that delegates all of the logic managing
715  * token distribution.
716  *
717  */
718 contract CompositeCrowdsale is Ownable {
719   using SafeMath for uint256;
720 
721   // The token being sold
722   TokenDistributionStrategy public tokenDistribution;
723 
724   // start and end timestamps where investments are allowed (both inclusive)
725   uint256 public startTime;
726   uint256 public endTime;
727 
728   // address where funds are collected
729   address public wallet;
730 
731   // amount of raised money in wei
732   uint256 public weiRaised;
733 
734   /**
735    * event for token purchase logging
736    * @param purchaser who paid for the tokens
737    * @param beneficiary who got the tokens
738    * @param value weis paid for purchase
739    * @param amount amount of tokens purchased
740    */
741   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
742 
743 
744   function CompositeCrowdsale(uint256 _startTime, uint256 _endTime, address _wallet, TokenDistributionStrategy _tokenDistribution) public {
745     require(_startTime >= now);
746     require(_endTime >= _startTime);
747     require(_wallet != 0x0);
748     require(address(_tokenDistribution) != address(0));
749 
750     startTime = _startTime;
751     endTime = _endTime;
752 
753     tokenDistribution = _tokenDistribution;
754     tokenDistribution.initializeDistribution(this);
755 
756     wallet = _wallet;
757   }
758 
759 
760   // fallback function can be used to buy tokens
761   function () payable {
762     buyTokens(msg.sender);
763   }
764 
765   // low level token purchase function
766   function buyTokens(address beneficiary) payable {
767     require(beneficiary != 0x0);
768     require(validPurchase());
769 
770     uint256 weiAmount = msg.value;
771 
772     // calculate token amount to be created
773     uint256 tokens = tokenDistribution.calculateTokenAmount(weiAmount, beneficiary);
774     // update state
775     weiRaised = weiRaised.add(weiAmount);
776 
777     tokenDistribution.distributeTokens(beneficiary, tokens);
778     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
779 
780     forwardFunds();
781   }
782 
783   // send ether to the fund collection wallet
784   // override to create custom fund forwarding mechanisms
785   function forwardFunds() internal {
786     wallet.transfer(msg.value);
787   }
788 
789   // @return true if the transaction can buy tokens
790   function validPurchase() internal view returns (bool) {
791     bool withinPeriod = now >= startTime && now <= endTime;
792     bool nonZeroPurchase = msg.value != 0;
793     return withinPeriod && nonZeroPurchase;
794   }
795 
796   // @return true if crowdsale event has ended
797   function hasEnded() public view returns (bool) {
798     return now > endTime;
799   }
800 
801 
802 }
803 
804 
805 
806 /**
807  * @title CappedCompositeCrowdsale
808  * @dev Extension of CompositeCrowdsale with a max amount of funds raised
809  */
810 contract CappedCompositeCrowdsale is CompositeCrowdsale {
811   using SafeMath for uint256;
812 
813   uint256 public cap;
814 
815   function CappedCompositeCrowdsale(uint256 _cap) public {
816     require(_cap > 0);
817     cap = _cap;
818   }
819 
820   // overriding Crowdsale#validPurchase to add extra cap logic
821   // @return true if investors can buy at the moment
822   function validPurchase() internal view returns (bool) {
823     bool withinCap = weiRaised.add(msg.value) <= cap;
824     return withinCap && super.validPurchase();
825   }
826 
827   // overriding Crowdsale#hasEnded to add cap logic
828   // @return true if crowdsale event has ended
829   function hasEnded() public view returns (bool) {
830     bool capReached = weiRaised >= cap;
831     return super.hasEnded() || capReached;
832   }
833 
834 }
835 
836 /**
837  * @title FinalizableCompositeCrowdsale
838  * @dev Extension of CompositeCrowdsale where an owner can do extra work
839  * after finishing.
840  */
841 contract FinalizableCompositeCrowdsale is CompositeCrowdsale {
842   using SafeMath for uint256;
843 
844   bool public isFinalized = false;
845 
846   event Finalized();
847 
848   /**
849    * @dev Must be called after crowdsale ends, to do some extra finalization
850    * work. Calls the contract's finalization function.
851    */
852   function finalize() onlyOwner public {
853     require(!isFinalized);
854     require(hasEnded());
855 
856     finalization();
857     Finalized();
858 
859     isFinalized = true;
860   }
861 
862   /**
863    * @dev Can be overridden to add finalization logic. The overriding function
864    * should call super.finalization() to ensure the chain of finalization is
865    * executed entirely.
866    */
867   function finalization() internal {
868   }
869 }
870 
871 
872 /**
873  * @title RefundVault
874  * @dev This contract is used for storing funds while a crowdsale
875  * is in progress. Supports refunding the money if crowdsale fails,
876  * and forwarding it if crowdsale is successful.
877  */
878 contract RefundVault is Ownable {
879   using SafeMath for uint256;
880 
881   enum State { Active, Refunding, Closed }
882 
883   mapping (address => uint256) public deposited;
884   address public wallet;
885   State public state;
886 
887   event Closed();
888   event RefundsEnabled();
889   event Refunded(address indexed beneficiary, uint256 weiAmount);
890 
891   function RefundVault(address _wallet) public {
892     require(_wallet != address(0));
893     wallet = _wallet;
894     state = State.Active;
895   }
896 
897   function deposit(address investor) onlyOwner public payable {
898     require(state == State.Active);
899     deposited[investor] = deposited[investor].add(msg.value);
900   }
901 
902   function close() onlyOwner public {
903     require(state == State.Active);
904     state = State.Closed;
905     Closed();
906     wallet.transfer(this.balance);
907   }
908 
909   function enableRefunds() onlyOwner public {
910     require(state == State.Active);
911     state = State.Refunding;
912     RefundsEnabled();
913   }
914 
915   function refund(address investor) public {
916     require(state == State.Refunding);
917     uint256 depositedValue = deposited[investor];
918     deposited[investor] = 0;
919     investor.transfer(depositedValue);
920     Refunded(investor, depositedValue);
921   }
922 }
923 
924 
925 
926 /**
927  * @title RefundableCompositeCrowdsale
928  * @dev Extension of CompositeCrowdsale contract that adds a funding goal, and
929  * the possibility of users getting a refund if goal is not met.
930  * Uses a RefundVault as the crowdsale's vault.
931  */
932 contract RefundableCompositeCrowdsale is FinalizableCompositeCrowdsale {
933   using SafeMath for uint256;
934 
935   // minimum amount of funds to be raised in weis
936   uint256 public goal;
937 
938   // refund vault used to hold funds while crowdsale is running
939   RefundVault public vault;
940 
941   function RefundableCompositeCrowdsale(uint256 _goal) {
942     require(_goal > 0);
943     vault = new RefundVault(wallet);
944     goal = _goal;
945   }
946 
947   // We're overriding the fund forwarding from Crowdsale.
948   // In addition to sending the funds, we want to call
949   // the RefundVault deposit function
950   function forwardFunds() internal {
951     vault.deposit.value(msg.value)(msg.sender);
952   }
953 
954   // if crowdsale is unsuccessful, investors can claim refunds here
955   function claimRefund() public {
956     require(isFinalized);
957     require(!goalReached());
958 
959     vault.refund(msg.sender);
960   }
961 
962   // vault finalization task, called when owner calls finalize()
963   function finalization() internal {
964     if (goalReached()) {
965       vault.close();
966     } else {
967       vault.enableRefunds();
968     }
969 
970     super.finalization();
971   }
972 
973   function goalReached() public view returns (bool) {
974     return weiRaised >= goal;
975   }
976 
977 }
978 
979 contract EthicHubPresale is Ownable, Pausable, CappedCompositeCrowdsale, RefundableCompositeCrowdsale {
980 
981   uint256 public constant minimumBidAllowed = 0.1 ether;
982   uint256 public constant maximumBidAllowed = 100 ether;
983   uint256 public constant WHITELISTED_PREMIUM_TIME = 1 days;
984 
985 
986   mapping(address=>uint) public participated;
987 
988   /**
989    * @dev since our wei/token conversion rate is different, we implement it separatedly
990    *      from Crowdsale
991    * [EthicHubPresale description]
992    * @param       _startTime start time in unix timestamp format
993    * @param       _endTime time in unix timestamp format
994    * @param       _goal minimum wei amount to consider the project funded.
995    * @param       _cap maximum amount the crowdsale will accept.
996    * @param       _wallet where funds are collected.
997    * @param       _tokenDistribution Strategy to distributed tokens.
998    */
999   function EthicHubPresale(uint256 _startTime, uint256 _endTime, uint256 _goal, uint256 _cap, address _wallet, EthicHubTokenDistributionStrategy _tokenDistribution)
1000     CompositeCrowdsale(_startTime, _endTime, _wallet, _tokenDistribution)
1001     CappedCompositeCrowdsale(_cap)
1002     RefundableCompositeCrowdsale(_goal)
1003   {
1004 
1005     //As goal needs to be met for a successful crowdsale
1006     //the value needs to less or equal than a cap which is limit for accepted funds
1007     require(_goal <= _cap);
1008   }
1009 
1010   function claimRefund() public {
1011     super.claimRefund();
1012   }
1013 
1014   /**
1015    * We enforce a minimum purchase price and a maximum investemnt per wallet
1016    * @return valid
1017    */
1018   function buyTokens(address beneficiary) whenNotPaused payable {
1019     require(msg.value >= minimumBidAllowed);
1020     require(participated[msg.sender].add(msg.value) <= maximumBidAllowed);
1021     participated[msg.sender] = participated[msg.sender].add(msg.value);
1022 
1023     super.buyTokens(beneficiary);
1024   }
1025 
1026   /**
1027   * Get user invested amount by his address, used to calculate user referral contribution
1028   * @return total invested amount
1029   */
1030   function getInvestedAmount(address investor) view public returns(uint investedAmount){
1031     investedAmount = participated[investor];
1032   }
1033 
1034   // overriding Crowdsale#validPurchase to add extra cap logic
1035   // whitelisted user can purchase tokens one day before the ico stated
1036   // @return true if investors can buy at the moment
1037   function validPurchase() internal view returns (bool) {
1038     // whitelist exclusive purchasing time
1039     if ((now >= startTime.sub(WHITELISTED_PREMIUM_TIME)) && (now <= startTime)){
1040         uint256 registeredAmount = tokenDistribution.whitelistRegisteredAmount(msg.sender);
1041         bool isWhitelisted = registeredAmount > 0;
1042         bool withinCap = weiRaised.add(msg.value) <= cap;
1043         bool nonZeroPurchase = msg.value != 0;
1044         return isWhitelisted && withinCap && nonZeroPurchase;
1045     } else {
1046         return super.validPurchase();
1047     }
1048   }
1049 
1050   /**
1051   * When the crowdsale is finished, we send the remaining tokens back to the wallet
1052   */
1053   function finalization() internal {
1054     super.finalization();
1055     tokenDistribution.returnUnsoldTokens(wallet);
1056   }
1057 }