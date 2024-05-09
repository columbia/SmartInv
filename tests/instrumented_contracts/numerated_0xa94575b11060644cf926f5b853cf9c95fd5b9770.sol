1 pragma solidity 0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
47 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   uint256 public totalSupply;
137   function balanceOf(address who) public view returns (uint256);
138   function transfer(address to, uint256 value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 // File: zeppelin-solidity/contracts/token/BasicToken.sol
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   /**
154   * @dev transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     // SafeMath.sub will throw if there is not enough balance.
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public view returns (uint256 balance) {
175     return balances[_owner];
176   }
177 
178 }
179 
180 // File: zeppelin-solidity/contracts/token/ERC20.sol
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 contract ERC20 is ERC20Basic {
187   function allowance(address owner, address spender) public view returns (uint256);
188   function transferFrom(address from, address to, uint256 value) public returns (bool);
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 // File: zeppelin-solidity/contracts/token/StandardToken.sol
194 
195 /**
196  * @title Standard ERC20 token
197  *
198  * @dev Implementation of the basic standard token.
199  * @dev https://github.com/ethereum/EIPs/issues/20
200  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
201  */
202 contract StandardToken is ERC20, BasicToken {
203 
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217 
218     balances[_from] = balances[_from].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221     Transfer(_from, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    *
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     Approval(msg.sender, _spender, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Function to check the amount of tokens that an owner allowed to a spender.
243    * @param _owner address The address which owns the funds.
244    * @param _spender address The address which will spend the funds.
245    * @return A uint256 specifying the amount of tokens still available for the spender.
246    */
247   function allowance(address _owner, address _spender) public view returns (uint256) {
248     return allowed[_owner][_spender];
249   }
250 
251   /**
252    * approve should be called when allowed[_spender] == 0. To increment
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    */
257   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
258     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
264     uint oldValue = allowed[msg.sender][_spender];
265     if (_subtractedValue > oldValue) {
266       allowed[msg.sender][_spender] = 0;
267     } else {
268       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
269     }
270     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274 }
275 
276 // File: zeppelin-solidity/contracts/token/PausableToken.sol
277 
278 /**
279  * @title Pausable token
280  *
281  * @dev StandardToken modified with pausable transfers.
282  **/
283 
284 contract PausableToken is StandardToken, Pausable {
285 
286   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
287     return super.transfer(_to, _value);
288   }
289 
290   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
291     return super.transferFrom(_from, _to, _value);
292   }
293 
294   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
295     return super.approve(_spender, _value);
296   }
297 
298   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
299     return super.increaseApproval(_spender, _addedValue);
300   }
301 
302   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
303     return super.decreaseApproval(_spender, _subtractedValue);
304   }
305 }
306 
307 // File: contracts/EthixToken.sol
308 
309 contract EthixToken is PausableToken {
310   string public constant name = "EthixToken";
311   string public constant symbol = "ETHIX";
312   uint8 public constant decimals = 18;
313 
314   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
315   uint256 public totalSupply;
316 
317   /**
318    * @dev Constructor that gives msg.sender all of existing tokens.
319    */
320   function EthixToken() public {
321     totalSupply = INITIAL_SUPPLY;
322     balances[owner] = totalSupply;
323     Transfer(0x0, owner, INITIAL_SUPPLY);
324   }
325 
326 }
327 
328 // File: contracts/crowdsale/CompositeCrowdsale.sol
329 
330 /**
331  * @title CompositeCrowdsale
332  * @dev CompositeCrowdsale is a base contract for managing a token crowdsale.
333  * Contrary to a classic crowdsale, it favours composition over inheritance.
334  *
335  * Crowdsale behaviour can be modified by specifying TokenDistributionStrategy
336  * which is a dedicated smart contract that delegates all of the logic managing
337  * token distribution.
338  *
339  */
340 contract CompositeCrowdsale is Ownable {
341   using SafeMath for uint256;
342 
343   // The token being sold
344   TokenDistributionStrategy public tokenDistribution;
345 
346   // start and end timestamps where investments are allowed (both inclusive)
347   uint256 public startTime;
348   uint256 public endTime;
349 
350   // address where funds are collected
351   address public wallet;
352 
353   // amount of raised money in wei
354   uint256 public weiRaised;
355 
356   /**
357    * event for token purchase logging
358    * @param purchaser who paid for the tokens
359    * @param beneficiary who got the tokens
360    * @param value weis paid for purchase
361    * @param amount amount of tokens purchased
362    */
363   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
364 
365 
366   function CompositeCrowdsale(uint256 _startTime, uint256 _endTime, address _wallet, TokenDistributionStrategy _tokenDistribution) public {
367     require(_startTime >= now);
368     require(_endTime >= _startTime);
369     require(_wallet != 0x0);
370     require(address(_tokenDistribution) != address(0));
371 
372     startTime = _startTime;
373     endTime = _endTime;
374 
375     tokenDistribution = _tokenDistribution;
376     tokenDistribution.initializeDistribution(this);
377 
378     wallet = _wallet;
379   }
380 
381 
382   // fallback function can be used to buy tokens
383   function () payable {
384     buyTokens(msg.sender);
385   }
386 
387   // low level token purchase function
388   function buyTokens(address beneficiary) payable {
389     require(beneficiary != 0x0);
390     require(validPurchase());
391 
392     uint256 weiAmount = msg.value;
393 
394     // calculate token amount to be created
395     uint256 tokens = tokenDistribution.calculateTokenAmount(weiAmount, beneficiary);
396     // update state
397     weiRaised = weiRaised.add(weiAmount);
398 
399     tokenDistribution.distributeTokens(beneficiary, tokens);
400     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
401 
402     forwardFunds();
403   }
404 
405   // send ether to the fund collection wallet
406   // override to create custom fund forwarding mechanisms
407   function forwardFunds() internal {
408     wallet.transfer(msg.value);
409   }
410 
411   // @return true if the transaction can buy tokens
412   function validPurchase() internal view returns (bool) {
413     bool withinPeriod = now >= startTime && now <= endTime;
414     bool nonZeroPurchase = msg.value != 0;
415     return withinPeriod && nonZeroPurchase;
416   }
417 
418   // @return true if crowdsale event has ended
419   function hasEnded() public view returns (bool) {
420     return now > endTime;
421   }
422 
423 
424 }
425 
426 // File: contracts/crowdsale/TokenDistributionStrategy.sol
427 
428 /**
429  * @title TokenDistributionStrategy
430  * @dev Base abstract contract defining methods that control token distribution
431  */
432 contract TokenDistributionStrategy {
433   using SafeMath for uint256;
434 
435   CompositeCrowdsale crowdsale;
436   uint256 rate;
437 
438   modifier onlyCrowdsale() {
439     require(msg.sender == address(crowdsale));
440     _;
441   }
442 
443   function TokenDistributionStrategy(uint256 _rate) {
444     require(_rate > 0);
445     rate = _rate;
446   }
447 
448   function initializeDistribution(CompositeCrowdsale _crowdsale) {
449     require(crowdsale == address(0));
450     require(_crowdsale != address(0));
451     crowdsale = _crowdsale;
452   }
453 
454   function returnUnsoldTokens(address _wallet) onlyCrowdsale {
455     
456   }
457 
458   function whitelistRegisteredAmount(address beneficiary) view returns (uint256 amount) {
459   }
460 
461   function distributeTokens(address beneficiary, uint amount);
462 
463   function calculateTokenAmount(uint256 _weiAmount, address beneficiary) view returns (uint256 amount);
464 
465   function getToken() view returns(ERC20);
466 
467   
468 
469 }
470 
471 // File: contracts/crowdsale/FixedPoolWithBonusTokenDistributionStrategy.sol
472 
473 /**
474  * @title FixedPoolWithBonusTokenDistributionStrategy 
475  * @dev Strategy that distributes a fixed number of tokens among the contributors,
476  * with a percentage depending in when the contribution is made, defined by periods.
477  * It's done in two steps. First, it registers all of the contributions while the sale is active.
478  * After the crowdsale has ended the contract compensate buyers proportionally to their contributions.
479  * This class is abstract, the intervals have to be defined by subclassing
480  */
481 contract FixedPoolWithBonusTokenDistributionStrategy is TokenDistributionStrategy {
482   using SafeMath for uint256;
483   uint256 constant MAX_DISCOUNT = 100;
484 
485   // Definition of the interval when the bonus is applicable
486   struct BonusInterval {
487     //end timestamp
488     uint256 endPeriod;
489     // percentage
490     uint256 bonus;
491   }
492   BonusInterval[] bonusIntervals;
493   bool intervalsConfigured = false;
494 
495   // The token being sold
496   ERC20 token;
497   mapping(address => uint256) contributions;
498   uint256 totalContributed;
499   //mapping(uint256 => BonusInterval) bonusIntervals;
500 
501   function FixedPoolWithBonusTokenDistributionStrategy(ERC20 _token, uint256 _rate)
502            TokenDistributionStrategy(_rate) public
503   {
504     token = _token;
505   }
506 
507 
508   // First period will go from crowdsale.start_date to bonusIntervals[0].end
509   // Next intervals have to end after the previous ones
510   // Last interval must end when the crowdsale ends
511   // All intervals must have a positive bonus (penalizations are not contemplated)
512   modifier validateIntervals {
513     _;
514     require(intervalsConfigured == false);
515     intervalsConfigured = true;
516     require(bonusIntervals.length > 0);
517     for(uint i = 0; i < bonusIntervals.length; ++i) {
518       require(bonusIntervals[i].bonus <= MAX_DISCOUNT);
519       require(bonusIntervals[i].bonus >= 0);
520       require(crowdsale.startTime() < bonusIntervals[i].endPeriod);
521       require(bonusIntervals[i].endPeriod <= crowdsale.endTime());
522       if (i != 0) {
523         require(bonusIntervals[i-1].endPeriod < bonusIntervals[i].endPeriod);
524       }
525     }
526   }
527 
528   // Init intervals
529   function initIntervals() validateIntervals {
530   }
531 
532   function calculateTokenAmount(uint256 _weiAmount, address beneficiary) view returns (uint256 tokens) {
533     // calculate bonus in function of the time
534     for (uint i = 0; i < bonusIntervals.length; i++) {
535       if (now <= bonusIntervals[i].endPeriod) {
536         // calculate token amount to be created
537         tokens = _weiAmount.mul(rate);
538         // OP : tokens + ((tokens * bonusIntervals[i].bonus) / 100)
539         // BE CAREFULLY with decimals
540         return tokens.add(tokens.mul(bonusIntervals[i].bonus).div(100));
541       }
542     }
543     return _weiAmount.mul(rate);
544   }
545 
546   function distributeTokens(address _beneficiary, uint256 _tokenAmount) onlyCrowdsale {
547     contributions[_beneficiary] = contributions[_beneficiary].add(_tokenAmount);
548     totalContributed = totalContributed.add(_tokenAmount);
549     require(totalContributed <= token.balanceOf(this));
550   }
551 
552   function compensate(address _beneficiary) {
553     require(crowdsale.hasEnded());
554     if (token.transfer(_beneficiary, contributions[_beneficiary])) {
555       contributions[_beneficiary] = 0;
556     }
557   }
558 
559   function getTokenContribution(address _beneficiary) view returns(uint256){
560     return contributions[_beneficiary];
561   }
562 
563   function getToken() view returns(ERC20) {
564     return token;
565   }
566 
567   function getIntervals() view returns (uint256[] _endPeriods, uint256[] _bonuss) {
568     uint256[] memory endPeriods = new uint256[](bonusIntervals.length);
569     uint256[] memory bonuss = new uint256[](bonusIntervals.length);
570     for (uint256 i=0; i<bonusIntervals.length; i++) {
571       endPeriods[i] = bonusIntervals[i].endPeriod;
572       bonuss[i] = bonusIntervals[i].bonus;
573     }
574     return (endPeriods, bonuss);
575   }
576 
577 }
578 
579 // File: contracts/crowdsale/VestedTokenDistributionStrategy.sol
580 
581 /**
582  * @title VestedTokenDistributionStrategy
583  * @dev Strategy that distributes a fixed number of tokens among the contributors.
584  * It's done in two steps. First, it registers all of the contributions while the sale is active.
585  * After the crowdsale has ended the contract compensate buyers proportionally to their contributions.
586  */
587 contract VestedTokenDistributionStrategy is Ownable, FixedPoolWithBonusTokenDistributionStrategy {
588 
589 
590   event Released(address indexed beneficiary, uint256 indexed amount);
591 
592   //Time after which is allowed to compensates
593   uint256 public vestingStart;
594   bool public vestingConfigured = false;
595   uint256 public vestingDuration;
596 
597   mapping (address => uint256) public released;
598 
599   modifier vestingPeriodStarted {
600     require(crowdsale.hasEnded());
601     require(vestingConfigured == true);
602     require(now > vestingStart);
603     _;
604   }
605 
606   function VestedTokenDistributionStrategy(ERC20 _token, uint256 _rate)
607             Ownable()
608             FixedPoolWithBonusTokenDistributionStrategy(_token, _rate) {
609 
610   }
611 
612   /**
613    * set the parameters for the compensation. Required to call before compensation
614    * @dev WARNING, ONE TIME OPERATION
615    * @param _vestingStart we start allowing  the return of tokens after this
616    * @param _vestingDuration percent each day (1 is 1% each day, 2 is % each 2 days, max 100)
617    */
618   function configureVesting(uint256 _vestingStart, uint256 _vestingDuration) onlyOwner {
619     require(vestingConfigured == false);
620     require(_vestingStart > crowdsale.endTime());
621     require(_vestingDuration > 0);
622     vestingStart = _vestingStart;
623     vestingDuration = _vestingDuration;
624     vestingConfigured = true;
625   }
626 
627   /**
628    * Will transfer the tokens vested until now to the beneficiary, if the vestingPeriodStarted
629    * and there is an amount left to transfer
630    * @param  _beneficiary crowdsale contributor
631    */
632    function compensate(address _beneficiary) public onlyOwner vestingPeriodStarted {
633      uint256 unreleased = releasableAmount(_beneficiary);
634 
635      require(unreleased > 0);
636 
637      released[_beneficiary] = released[_beneficiary].add(unreleased);
638 
639      require(token.transfer(_beneficiary, unreleased));
640      Released(_beneficiary,unreleased);
641 
642    }
643 
644   /**
645    * Calculates how many tokens the beneficiary should get taking in account already
646    * released
647    * @param  _beneficiary the contributor
648    * @return token number
649    */
650    function releasableAmount(address _beneficiary) public view returns (uint256) {
651      return vestedAmount(_beneficiary).sub(released[_beneficiary]);
652    }
653 
654   /**
655    * Calculates how many tokens the beneficiary have vested
656    * vested = how many does she have according to the time
657    * @param  _beneficiary address of the contributor that needs the tokens
658    * @return amount of tokens
659    */
660   function vestedAmount(address _beneficiary) public view returns (uint256) {
661     uint256 totalBalance = contributions[_beneficiary];
662     //Duration("after",vestingStart.add(vestingDuration));
663     if (now < vestingStart || vestingConfigured == false) {
664       return 0;
665     } else if (now >= vestingStart.add(vestingDuration)) {
666       return totalBalance;
667     } else {
668       return totalBalance.mul(now.sub(vestingStart)).div(vestingDuration);
669     }
670   }
671 
672   function getReleased(address _beneficiary) public view returns (uint256) {
673     return released[_beneficiary];
674   }
675 
676 }
677 
678 // File: contracts/crowdsale/WhitelistedDistributionStrategy.sol
679 
680 /**
681  * @title WhitelistedDistributionStrategy
682  * @dev This is an extension to add whitelist to a token distributionStrategy
683  *
684  */
685 contract WhitelistedDistributionStrategy is Ownable, VestedTokenDistributionStrategy {
686     uint256 public constant maximumBidAllowed = 500 ether;
687 
688     uint256 rate_for_investor;
689     mapping(address=>uint) public registeredAmount;
690 
691     event RegistrationStatusChanged(address target, bool isRegistered);
692 
693     function WhitelistedDistributionStrategy(ERC20 _token, uint256 _rate, uint256 _whitelisted_rate)
694               VestedTokenDistributionStrategy(_token,_rate){
695         rate_for_investor = _whitelisted_rate;
696     }
697 
698     /**
699      * @dev Changes registration status of an address for participation.
700      * @param target Address that will be registered/deregistered.
701      * @param amount the amount of eht to invest for a investor bonus.
702      */
703     function changeRegistrationStatus(address target, uint256 amount)
704         public
705         onlyOwner
706     {
707         require(amount <= maximumBidAllowed);
708         registeredAmount[target] = amount;
709         if (amount > 0){
710             RegistrationStatusChanged(target, true);
711         }else{
712             RegistrationStatusChanged(target, false);
713         }
714     }
715 
716     /**
717      * @dev Changes registration statuses of addresses for participation.
718      * @param targets Addresses that will be registered/deregistered.
719      * @param amounts the list of amounts of eth for every investor to invest for a investor bonus.
720      */
721     function changeRegistrationStatuses(address[] targets, uint256[] amounts)
722         public
723         onlyOwner
724     {
725         require(targets.length == amounts.length);
726         for (uint i = 0; i < targets.length; i++) {
727             changeRegistrationStatus(targets[i], amounts[i]);
728         }
729     }
730 
731     /**
732      * @dev overriding calculateTokenAmount for whilelist investors
733      * @return bonus rate if it applies for the investor,
734      * otherwise, return token amount according to super class
735      */
736 
737     function calculateTokenAmount(uint256 _weiAmount, address beneficiary) view returns (uint256 tokens) {
738         if (_weiAmount >= registeredAmount[beneficiary] && registeredAmount[beneficiary] > 0 ){
739             tokens = _weiAmount.mul(rate_for_investor);
740         } else{
741             tokens = super.calculateTokenAmount(_weiAmount, beneficiary);
742         }
743     }
744 
745     /**
746      * @dev getRegisteredAmount for whilelist investors
747      * @return registered amount if it applies for the investor,
748      * otherwise, return 0 
749      */
750 
751     function whitelistRegisteredAmount(address beneficiary) view returns (uint256 amount) {
752         amount = registeredAmount[beneficiary];
753     }
754 }
755 
756 // File: contracts/EthicHubTokenDistributionStrategy.sol
757 
758 /**
759  * @title EthicHubTokenDistributionStrategy
760  * @dev Strategy that distributes a fixed number of tokens among the contributors,
761  * with a percentage deppending in when the contribution is made, defined by periods.
762  * It's done in two steps. First, it registers all of the contributions while the sale is active.
763  * After the crowdsale has ended the contract compensate buyers proportionally to their contributions.
764  * Contributors registered to the whitelist will have better rates
765  */
766 contract EthicHubTokenDistributionStrategy is Ownable, WhitelistedDistributionStrategy {
767   
768   event UnsoldTokensReturned(address indexed destination, uint256 amount);
769 
770 
771   function EthicHubTokenDistributionStrategy(EthixToken _token, uint256 _rate, uint256 _rateForWhitelisted)
772            WhitelistedDistributionStrategy(_token, _rate, _rateForWhitelisted)
773            public
774   {
775 
776   }
777 
778 
779   // Init intervals
780   function initIntervals() onlyOwner validateIntervals  {
781 
782     //For extra security, we check the owner of the crowdsale is the same of the owner of the distribution
783     require(owner == crowdsale.owner());
784 
785     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 1 days,10));
786     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 2 days,10));
787     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 3 days,8));
788     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 4 days,6));
789     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 5 days,4));
790     bonusIntervals.push(BonusInterval(crowdsale.startTime() + 6 days,2));
791   }
792 
793   function returnUnsoldTokens(address _wallet) onlyCrowdsale {
794     //require(crowdsale.endTime() <= now); //this made no sense
795     if (token.balanceOf(this) == 0) {
796       UnsoldTokensReturned(_wallet,0);
797       return;
798     }
799     
800     uint256 balance = token.balanceOf(this).sub(totalContributed);
801     require(balance > 0);
802 
803     if(token.transfer(_wallet, balance)) {
804       UnsoldTokensReturned(_wallet, balance);
805     }
806     
807   } 
808 }