1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   uint256 totalSupply_;
58 
59   /**
60   * @dev total number of tokens in existence
61   */
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     emit Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender) public view returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 contract HasManager {
101   address public manager;
102 
103   modifier onlyManager {
104     require(msg.sender == manager);
105     _;
106   }
107 
108   function transferManager(address _newManager) public onlyManager() {
109     require(_newManager != address(0));
110     manager = _newManager;
111   }
112 }
113 
114 contract Ownable {
115   address public owner;
116 
117 
118   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120 
121   /**
122    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
123    * account.
124    */
125   function Ownable() public {
126     owner = msg.sender;
127   }
128 
129   /**
130    * @dev Throws if called by any account other than the owner.
131    */
132   modifier onlyOwner() {
133     require(msg.sender == owner);
134     _;
135   }
136 
137   /**
138    * @dev Allows the current owner to transfer control of the contract to a newOwner.
139    * @param newOwner The address to transfer ownership to.
140    */
141   function transferOwnership(address newOwner) public onlyOwner {
142     require(newOwner != address(0));
143     emit OwnershipTransferred(owner, newOwner);
144     owner = newOwner;
145   }
146 
147 }
148 
149 contract Whitelist is Ownable {
150   mapping(address => bool) public whitelist;
151   address public whitelistManager;
152   function AddToWhiteList(address _addr) public {
153       require(msg.sender == whitelistManager || msg.sender == owner);
154       whitelist[_addr] = true;
155   }
156 
157   function AssignWhitelistManager(address _addr) public onlyOwner {
158       whitelistManager = _addr;
159   }
160 
161   modifier whitelistedOnly {
162     require(whitelist[msg.sender]);
163     _;
164   }
165 }
166 
167 contract WithBonusPeriods is Ownable {
168   uint256 constant INVALID_FROM_TIMESTAMP = 1000000000000;
169   uint256 constant INFINITY_TO_TIMESTAMP= 1000000000000;
170   struct BonusPeriod {
171     uint256 fromTimestamp;
172     uint256 toTimestamp;
173     uint256 bonusNumerator;
174     uint256 bonusDenominator;
175   }
176 
177   BonusPeriod[] public bonusPeriods;
178   BonusPeriod currentBonusPeriod;
179 
180   function WithBonusPeriods() public {
181       initBonuses();
182   }
183 
184   function BonusPeriodsCount() public view returns (uint8) {
185     return uint8(bonusPeriods.length);
186   }
187 
188   //find out bonus for specific timestamp
189   function BonusPeriodFor(uint256 timestamp) public view returns (bool ongoing, uint256 from, uint256 to, uint256 num, uint256 den) {
190     for(uint i = 0; i < bonusPeriods.length; i++)
191       if (bonusPeriods[i].fromTimestamp <= timestamp && bonusPeriods[i].toTimestamp >= timestamp)
192         return (true, bonusPeriods[i].fromTimestamp, bonusPeriods[i].toTimestamp, bonusPeriods[i].bonusNumerator,
193           bonusPeriods[i].bonusDenominator);
194     return (false, 0, 0, 0, 0);
195   }
196 
197   function initBonusPeriod(uint256 from, uint256 to, uint256 num, uint256 den) internal  {
198     bonusPeriods.push(BonusPeriod(from, to, num, den));
199   }
200 
201   function initBonuses() internal {
202       //1-7 May, 20%
203       initBonusPeriod(1525132800, 1525737599, 20, 100);
204       //8-14 May, 15%
205       initBonusPeriod(1525737600, 1526342399, 15, 100);
206       //15 -21 May, 10%
207       initBonusPeriod(1526342400, 1526947199, 10, 100);
208       //22 -28 May, 5%
209       initBonusPeriod(1526947200, 1527551999, 5, 100);
210   }
211 
212   function updateCurrentBonusPeriod() internal  {
213     if (currentBonusPeriod.fromTimestamp <= block.timestamp
214       && currentBonusPeriod.toTimestamp >= block.timestamp)
215       return;
216 
217     currentBonusPeriod.fromTimestamp = INVALID_FROM_TIMESTAMP;
218 
219     for(uint i = 0; i < bonusPeriods.length; i++)
220       if (bonusPeriods[i].fromTimestamp <= block.timestamp && bonusPeriods[i].toTimestamp >= block.timestamp) {
221         currentBonusPeriod = bonusPeriods[i];
222         return;
223       }
224   }
225 }
226 
227 contract ICrowdsaleProcessor is Ownable, HasManager {
228   modifier whenCrowdsaleAlive() {
229     require(isActive());
230     _;
231   }
232 
233   modifier whenCrowdsaleFailed() {
234     require(isFailed());
235     _;
236   }
237 
238   modifier whenCrowdsaleSuccessful() {
239     require(isSuccessful());
240     _;
241   }
242 
243   modifier hasntStopped() {
244     require(!stopped);
245     _;
246   }
247 
248   modifier hasBeenStopped() {
249     require(stopped);
250     _;
251   }
252 
253   modifier hasntStarted() {
254     require(!started);
255     _;
256   }
257 
258   modifier hasBeenStarted() {
259     require(started);
260     _;
261   }
262 
263   // Minimal acceptable hard cap
264   uint256 constant public MIN_HARD_CAP = 1 ether;
265 
266   // Minimal acceptable duration of crowdsale
267   uint256 constant public MIN_CROWDSALE_TIME = 3 days;
268 
269   // Maximal acceptable duration of crowdsale
270   uint256 constant public MAX_CROWDSALE_TIME = 50 days;
271 
272   // Becomes true when timeframe is assigned
273   bool public started;
274 
275   // Becomes true if cancelled by owner
276   bool public stopped;
277 
278   // Total collected Ethereum: must be updated every time tokens has been sold
279   uint256 public totalCollected;
280 
281   // Total amount of project's token sold: must be updated every time tokens has been sold
282   uint256 public totalSold;
283 
284   // Crowdsale minimal goal, must be greater or equal to Forecasting min amount
285   uint256 public minimalGoal;
286 
287   // Crowdsale hard cap, must be less or equal to Forecasting max amount
288   uint256 public hardCap;
289 
290   // Crowdsale duration in seconds.
291   // Accepted range is MIN_CROWDSALE_TIME..MAX_CROWDSALE_TIME.
292   uint256 public duration;
293 
294   // Start timestamp of crowdsale, absolute UTC time
295   uint256 public startTimestamp;
296 
297   // End timestamp of crowdsale, absolute UTC time
298   uint256 public endTimestamp;
299 
300   // Allows to transfer some ETH into the contract without selling tokens
301   function deposit() public payable {}
302 
303   // Returns address of crowdsale token, must be ERC20 compilant
304   function getToken() public returns(address);
305 
306   // Transfers ETH rewards amount (if ETH rewards is configured) to Forecasting contract
307   function mintETHRewards(address _contract, uint256 _amount) public onlyManager();
308 
309   // Mints token Rewards to Forecasting contract
310   function mintTokenRewards(address _contract, uint256 _amount) public onlyManager();
311 
312   // Releases tokens (transfers crowdsale token from mintable to transferrable state)
313   function releaseTokens() public onlyManager() hasntStopped() whenCrowdsaleSuccessful();
314 
315   // Stops crowdsale. Called by CrowdsaleController, the latter is called by owner.
316   // Crowdsale may be stopped any time before it finishes.
317   function stop() public onlyManager() hasntStopped();
318 
319   // Validates parameters and starts crowdsale
320   function start(uint256 _startTimestamp, uint256 _endTimestamp, address _fundingAddress)
321     public onlyManager() hasntStarted() hasntStopped();
322 
323   // Is crowdsale failed (completed, but minimal goal wasn't reached)
324   function isFailed() public constant returns (bool);
325 
326   // Is crowdsale active (i.e. the token can be sold)
327   function isActive() public constant returns (bool);
328 
329   // Is crowdsale completed successfully
330   function isSuccessful() public constant returns (bool);
331 }
332 
333 contract StandardToken is ERC20, BasicToken {
334 
335   mapping (address => mapping (address => uint256)) internal allowed;
336 
337 
338   /**
339    * @dev Transfer tokens from one address to another
340    * @param _from address The address which you want to send tokens from
341    * @param _to address The address which you want to transfer to
342    * @param _value uint256 the amount of tokens to be transferred
343    */
344   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
345     require(_to != address(0));
346     require(_value <= balances[_from]);
347     require(_value <= allowed[_from][msg.sender]);
348 
349     balances[_from] = balances[_from].sub(_value);
350     balances[_to] = balances[_to].add(_value);
351     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
352     emit Transfer(_from, _to, _value);
353     return true;
354   }
355 
356   /**
357    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
358    *
359    * Beware that changing an allowance with this method brings the risk that someone may use both the old
360    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
361    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
362    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
363    * @param _spender The address which will spend the funds.
364    * @param _value The amount of tokens to be spent.
365    */
366   function approve(address _spender, uint256 _value) public returns (bool) {
367     allowed[msg.sender][_spender] = _value;
368     emit Approval(msg.sender, _spender, _value);
369     return true;
370   }
371 
372   /**
373    * @dev Function to check the amount of tokens that an owner allowed to a spender.
374    * @param _owner address The address which owns the funds.
375    * @param _spender address The address which will spend the funds.
376    * @return A uint256 specifying the amount of tokens still available for the spender.
377    */
378   function allowance(address _owner, address _spender) public view returns (uint256) {
379     return allowed[_owner][_spender];
380   }
381 
382   /**
383    * @dev Increase the amount of tokens that an owner allowed to a spender.
384    *
385    * approve should be called when allowed[_spender] == 0. To increment
386    * allowed value is better to use this function to avoid 2 calls (and wait until
387    * the first transaction is mined)
388    * From MonolithDAO Token.sol
389    * @param _spender The address which will spend the funds.
390    * @param _addedValue The amount of tokens to increase the allowance by.
391    */
392   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
393     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
394     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
395     return true;
396   }
397 
398   /**
399    * @dev Decrease the amount of tokens that an owner allowed to a spender.
400    *
401    * approve should be called when allowed[_spender] == 0. To decrement
402    * allowed value is better to use this function to avoid 2 calls (and wait until
403    * the first transaction is mined)
404    * From MonolithDAO Token.sol
405    * @param _spender The address which will spend the funds.
406    * @param _subtractedValue The amount of tokens to decrease the allowance by.
407    */
408   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
409     uint oldValue = allowed[msg.sender][_spender];
410     if (_subtractedValue > oldValue) {
411       allowed[msg.sender][_spender] = 0;
412     } else {
413       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
414     }
415     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
416     return true;
417   }
418 
419 }
420 
421 contract Crowdsaled is Ownable {
422         address public crowdsaleContract = address(0);
423         function Crowdsaled() public {
424         }
425 
426         modifier onlyCrowdsale{
427           require(msg.sender == crowdsaleContract);
428           _;
429         }
430 
431         modifier onlyCrowdsaleOrOwner {
432           require((msg.sender == crowdsaleContract) || (msg.sender == owner));
433           _;
434         }
435 
436         function setCrowdsale(address crowdsale) public onlyOwner() {
437                 crowdsaleContract = crowdsale;
438         }
439 }
440 
441 contract LetItPlayToken is Crowdsaled, StandardToken {
442         uint256 public totalSupply;
443         string public name;
444         string public symbol;
445         uint8 public decimals;
446 
447         address public forSale;
448         address public preSale;
449         address public ecoSystemFund;
450         address public founders;
451         address public team;
452         address public advisers;
453         address public bounty;
454         address public eosShareDrop;
455 
456         bool releasedForTransfer;
457 
458         uint256 private shift;
459 
460         //initial coin distribution
461         function LetItPlayToken(
462             address _forSale,
463             address _ecoSystemFund,
464             address _founders,
465             address _team,
466             address _advisers,
467             address _bounty,
468             address _preSale,
469             address _eosShareDrop
470           ) public {
471           name = "LetItPlay Token";
472           symbol = "PLAY";
473           decimals = 8;
474           shift = uint256(10)**decimals;
475           totalSupply = 1000000000 * shift;
476           forSale = _forSale;
477           ecoSystemFund = _ecoSystemFund;
478           founders = _founders;
479           team = _team;
480           advisers = _advisers;
481           bounty = _bounty;
482           eosShareDrop = _eosShareDrop;
483           preSale = _preSale;
484 
485           balances[forSale] = totalSupply * 59 / 100;
486           balances[ecoSystemFund] = totalSupply * 15 / 100;
487           balances[founders] = totalSupply * 15 / 100;
488           balances[team] = totalSupply * 5 / 100;
489           balances[advisers] = totalSupply * 3 / 100;
490           balances[bounty] = totalSupply * 1 / 100;
491           balances[preSale] = totalSupply * 1 / 100;
492           balances[eosShareDrop] = totalSupply * 1 / 100;
493         }
494 
495         function transferByOwner(address from, address to, uint256 value) public onlyOwner {
496           require(balances[from] >= value);
497           balances[from] = balances[from].sub(value);
498           balances[to] = balances[to].add(value);
499           emit Transfer(from, to, value);
500         }
501 
502         //can be called by crowdsale before token release, control over forSale portion of token supply
503         function transferByCrowdsale(address to, uint256 value) public onlyCrowdsale {
504           require(balances[forSale] >= value);
505           balances[forSale] = balances[forSale].sub(value);
506           balances[to] = balances[to].add(value);
507           emit Transfer(forSale, to, value);
508         }
509 
510         //can be called by crowdsale before token release, allowences is respected here
511         function transferFromByCrowdsale(address _from, address _to, uint256 _value) public onlyCrowdsale returns (bool) {
512             return super.transferFrom(_from, _to, _value);
513         }
514 
515         //after the call token is available for exchange
516         function releaseForTransfer() public onlyCrowdsaleOrOwner {
517           require(!releasedForTransfer);
518           releasedForTransfer = true;
519         }
520 
521         //forbid transfer before release
522         function transfer(address _to, uint256 _value) public returns (bool) {
523           require(releasedForTransfer);
524           return super.transfer(_to, _value);
525         }
526 
527         //forbid transfer before release
528         function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
529            require(releasedForTransfer);
530            return super.transferFrom(_from, _to, _value);
531         }
532 
533         function burn(uint256 value) public  onlyOwner {
534             require(value <= balances[msg.sender]);
535             balances[msg.sender] = balances[msg.sender].sub(value);
536             balances[address(0)] = balances[address(0)].add(value);
537             emit Transfer(msg.sender, address(0), value);
538         }
539 }
540 
541 contract BasicCrowdsale is ICrowdsaleProcessor {
542   event CROWDSALE_START(uint256 startTimestamp, uint256 endTimestamp, address fundingAddress);
543 
544   // Where to transfer collected ETH
545   address public fundingAddress;
546 
547   // Ctor.
548   function BasicCrowdsale(
549     address _owner,
550     address _manager
551   )
552     public
553   {
554     owner = _owner;
555     manager = _manager;
556   }
557 
558   // called by CrowdsaleController to transfer reward part of ETH
559   // collected by successful crowdsale to Forecasting contract.
560   // This call is made upon closing successful crowdfunding process
561   // iff agreed ETH reward part is not zero
562   function mintETHRewards(
563     address _contract,  // Forecasting contract
564     uint256 _amount     // agreed part of totalCollected which is intended for rewards
565   )
566     public
567     onlyManager() // manager is CrowdsaleController instance
568   {
569     require(_contract.call.value(_amount)());
570   }
571 
572   // cancels crowdsale
573   function stop() public onlyManager() hasntStopped()  {
574     // we can stop only not started and not completed crowdsale
575     if (started) {
576       require(!isFailed());
577       require(!isSuccessful());
578     }
579     stopped = true;
580   }
581 
582   // called by CrowdsaleController to setup start and end time of crowdfunding process
583   // as well as funding address (where to transfer ETH upon successful crowdsale)
584   function start(
585     uint256 _startTimestamp,
586     uint256 _endTimestamp,
587     address _fundingAddress
588   )
589     public
590     onlyManager()   // manager is CrowdsaleController instance
591     hasntStarted()  // not yet started
592     hasntStopped()  // crowdsale wasn't cancelled
593   {
594     require(_fundingAddress != address(0));
595 
596     // start time must not be earlier than current time
597     require(_startTimestamp >= block.timestamp);
598 
599     // range must be sane
600     require(_endTimestamp > _startTimestamp);
601     duration = _endTimestamp - _startTimestamp;
602 
603     // duration must fit constraints
604     require(duration >= MIN_CROWDSALE_TIME && duration <= MAX_CROWDSALE_TIME);
605 
606     startTimestamp = _startTimestamp;
607     endTimestamp = _endTimestamp;
608     fundingAddress = _fundingAddress;
609 
610     // now crowdsale is considered started, even if the current time is before startTimestamp
611     started = true;
612 
613     emit CROWDSALE_START(_startTimestamp, _endTimestamp, _fundingAddress);
614   }
615 
616   // must return true if crowdsale is over, but it failed
617   function isFailed()
618     public
619     constant
620     returns(bool)
621   {
622     return (
623       // it was started
624       started &&
625 
626       // crowdsale period has finished
627       block.timestamp >= endTimestamp &&
628 
629       // but collected ETH is below the required minimum
630       totalCollected < minimalGoal
631     );
632   }
633 
634   // must return true if crowdsale is active (i.e. the token can be bought)
635   function isActive()
636     public
637     constant
638     returns(bool)
639   {
640     return (
641       // it was started
642       started &&
643 
644       // hard cap wasn't reached yet
645       totalCollected < hardCap &&
646 
647       // and current time is within the crowdfunding period
648       block.timestamp >= startTimestamp &&
649       block.timestamp < endTimestamp
650     );
651   }
652 
653   // must return true if crowdsale completed successfully
654   function isSuccessful()
655     public
656     constant
657     returns(bool)
658   {
659     return (
660       // either the hard cap is collected
661       totalCollected >= hardCap ||
662 
663       // ...or the crowdfunding period is over, but the minimum has been reached
664       (block.timestamp >= endTimestamp && totalCollected >= minimalGoal)
665     );
666   }
667 }
668 
669 contract Crowdsale is BasicCrowdsale, Whitelist, WithBonusPeriods {
670 
671   struct Investor {
672     uint256 weiDonated;
673     uint256 tokensGiven;
674   }
675 
676   mapping(address => Investor) participants;
677 
678   uint256 public tokenRateWei;
679   LetItPlayToken public token;
680 
681   // Ctor. MinimalGoal, hardCap, and price are not changeable.
682   function Crowdsale(
683     uint256 _minimalGoal,
684     uint256 _hardCap,
685     uint256 _tokenRateWei,
686     address _token
687   )
688     public
689     // simplest case where manager==owner. See onlyOwner() and onlyManager() modifiers
690     // before functions to figure out the cases in which those addresses should differ
691     BasicCrowdsale(msg.sender, msg.sender)
692   {
693     // just setup them once...
694     minimalGoal = _minimalGoal;
695     hardCap = _hardCap;
696     tokenRateWei = _tokenRateWei;
697     token = LetItPlayToken(_token);
698   }
699 
700   // Here goes ICrowdsaleProcessor implementation
701 
702   // returns address of crowdsale token. The token must be ERC20-compliant
703   function getToken()
704     public
705     returns(address)
706   {
707     return address(token);
708   }
709 
710   // called by CrowdsaleController to transfer reward part of
711   // tokens sold by successful crowdsale to Forecasting contract.
712   // This call is made upon closing successful crowdfunding process.
713   function mintTokenRewards(
714     address _contract,  // Forecasting contract
715     uint256 _amount     // agreed part of totalSold which is intended for rewards
716   )
717     public
718     onlyManager() // manager is CrowdsaleController instance
719   {
720     // crowdsale token is mintable in this example, tokens are created here
721     token.transferByCrowdsale(_contract, _amount);
722   }
723 
724   // transfers crowdsale token from mintable to transferrable state
725   function releaseTokens()
726     public
727     onlyManager()             // manager is CrowdsaleController instance
728     hasntStopped()            // crowdsale wasn't cancelled
729     whenCrowdsaleSuccessful() // crowdsale was successful
730   {
731     // see token example
732     token.releaseForTransfer();
733   }
734 
735   function () payable public {
736     require(msg.value > 0);
737     sellTokens(msg.sender, msg.value);
738   }
739 
740   function sellTokens(address _recepient, uint256 _value)
741     internal
742     hasBeenStarted()
743     hasntStopped()
744     whenCrowdsaleAlive()
745     whitelistedOnly()
746   {
747     uint256 newTotalCollected = totalCollected + _value;
748 
749     if (hardCap < newTotalCollected) {
750       uint256 refund = newTotalCollected - hardCap;
751       uint256 diff = _value - refund;
752       _recepient.transfer(refund);
753       _value = diff;
754     }
755 
756     uint256 tokensSold = _value * uint256(10)**token.decimals() / tokenRateWei;
757 
758     //apply bonus period
759     updateCurrentBonusPeriod();
760     if (currentBonusPeriod.fromTimestamp != INVALID_FROM_TIMESTAMP)
761       tokensSold += tokensSold * currentBonusPeriod.bonusNumerator / currentBonusPeriod.bonusDenominator;
762 
763     token.transferByCrowdsale(_recepient, tokensSold);
764     participants[_recepient].weiDonated += _value;
765     participants[_recepient].tokensGiven += tokensSold;
766     totalCollected += _value;
767     totalSold += tokensSold;
768   }
769 
770   // project's owner withdraws ETH funds to the funding address upon successful crowdsale
771   function withdraw(uint256 _amount) public // can be done partially
772     onlyOwner() // project's owner
773     hasntStopped()  // crowdsale wasn't cancelled
774     whenCrowdsaleSuccessful() // crowdsale completed successfully
775   {
776     require(_amount <= address(this).balance);
777     fundingAddress.transfer(_amount);
778   }
779 
780   // backers refund their ETH if the crowdsale was cancelled or has failed
781   function refund() public
782   {
783     // either cancelled or failed
784     require(stopped || isFailed());
785 
786     uint256 weiDonated = participants[msg.sender].weiDonated;
787     uint256 tokens = participants[msg.sender].tokensGiven;
788 
789     // prevent from doing it twice
790     require(weiDonated > 0);
791     participants[msg.sender].weiDonated = 0;
792     participants[msg.sender].tokensGiven = 0;
793 
794     msg.sender.transfer(weiDonated);
795 
796     //this must be approved by investor
797     token.transferFromByCrowdsale(msg.sender, token.forSale(), tokens);
798   }
799 }