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
252    * @dev Increase the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To increment
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _addedValue The amount of tokens to increase the allowance by.
260    */
261   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
262     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
263     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Decrease the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
278     uint oldValue = allowed[msg.sender][_spender];
279     if (_subtractedValue > oldValue) {
280       allowed[msg.sender][_spender] = 0;
281     } else {
282       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
283     }
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288 }
289 
290 // File: zeppelin-solidity/contracts/token/PausableToken.sol
291 
292 /**
293  * @title Pausable token
294  *
295  * @dev StandardToken modified with pausable transfers.
296  **/
297 
298 contract PausableToken is StandardToken, Pausable {
299 
300   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
301     return super.transfer(_to, _value);
302   }
303 
304   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
305     return super.transferFrom(_from, _to, _value);
306   }
307 
308   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
309     return super.approve(_spender, _value);
310   }
311 
312   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
313     return super.increaseApproval(_spender, _addedValue);
314   }
315 
316   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
317     return super.decreaseApproval(_spender, _subtractedValue);
318   }
319 }
320 
321 // File: contracts/CustomPOAToken.sol
322 
323 contract CustomPOAToken is PausableToken {
324 
325   string public name;
326   string public symbol;
327 
328   uint8 public constant decimals = 18;
329 
330   address public owner;
331   address public broker;
332   address public custodian;
333 
334   uint256 public creationBlock;
335   uint256 public timeoutBlock;
336   // the total per token payout rate: accumulates as payouts are received
337   uint256 public totalPerTokenPayout;
338   uint256 public tokenSaleRate;
339   uint256 public fundedAmount;
340   uint256 public fundingGoal;
341   uint256 public initialSupply;
342   // ‰ permille NOT percent
343   uint256 public constant feeRate = 5;
344 
345   // self contained whitelist on contract, must be whitelisted to buy
346   mapping (address => bool) public whitelisted;
347   // used to deduct already claimed payouts on a per token basis
348   mapping(address => uint256) public claimedPerTokenPayouts;
349   // fallback for when a transfer happens with payouts remaining
350   mapping(address => uint256) public unclaimedPayoutTotals;
351 
352   enum Stages {
353     Funding,
354     Pending,
355     Failed,
356     Active,
357     Terminated
358   }
359 
360   Stages public stage = Stages.Funding;
361 
362   event StageEvent(Stages stage);
363   event BuyEvent(address indexed buyer, uint256 amount);
364   event PayoutEvent(uint256 amount);
365   event ClaimEvent(uint256 payout);
366   event TerminatedEvent();
367   event WhitelistedEvent(address indexed account, bool isWhitelisted);
368 
369   modifier isWhitelisted() {
370     require(whitelisted[msg.sender]);
371     _;
372   }
373 
374   modifier onlyCustodian() {
375     require(msg.sender == custodian);
376     _;
377   }
378 
379   // start stage related modifiers
380   modifier atStage(Stages _stage) {
381     require(stage == _stage);
382     _;
383   }
384 
385   modifier atEitherStage(Stages _stage, Stages _orStage) {
386     require(stage == _stage || stage == _orStage);
387     _;
388   }
389 
390   modifier checkTimeout() {
391     if (stage == Stages.Funding && block.number >= creationBlock.add(timeoutBlock)) {
392       uint256 _unsoldBalance = balances[this];
393       balances[this] = 0;
394       totalSupply = totalSupply.sub(_unsoldBalance);
395       Transfer(this, address(0), balances[this]);
396       enterStage(Stages.Failed);
397     }
398     _;
399   }
400   // end stage related modifiers
401 
402   // token totalSupply must be more than fundingGoal!
403   function CustomPOAToken
404   (
405     string _name,
406     string _symbol,
407     address _broker,
408     address _custodian,
409     uint256 _timeoutBlock,
410     uint256 _totalSupply,
411     uint256 _fundingGoal
412   )
413     public
414   {
415     require(_fundingGoal > 0);
416     require(_totalSupply > _fundingGoal);
417     owner = msg.sender;
418     name = _name;
419     symbol = _symbol;
420     broker = _broker;
421     custodian = _custodian;
422     timeoutBlock = _timeoutBlock;
423     creationBlock = block.number;
424     // essentially sqm unit of building...
425     totalSupply = _totalSupply;
426     initialSupply = _totalSupply;
427     fundingGoal = _fundingGoal;
428     balances[this] = _totalSupply;
429     paused = true;
430   }
431 
432   // start token conversion functions
433 
434   /*******************
435   * TKN      supply  *
436   * ---  =  -------  *
437   * ETH     funding  *
438   *******************/
439 
440   // util function to convert wei to tokens. can be used publicly to see
441   // what the balance would be for a given Ξ amount.
442   // will drop miniscule amounts of wei due to integer division
443   function weiToTokens(uint256 _weiAmount)
444     public
445     view
446     returns (uint256)
447   {
448     return _weiAmount
449       .mul(1e18)
450       .mul(initialSupply)
451       .div(fundingGoal)
452       .div(1e18);
453   }
454 
455   // util function to convert tokens to wei. can be used publicly to see how
456   // much Ξ would be received for token reclaim amount
457   // will typically lose 1 wei unit of Ξ due to integer division
458   function tokensToWei(uint256 _tokenAmount)
459     public
460     view
461     returns (uint256)
462   {
463     return _tokenAmount
464       .mul(1e18)
465       .mul(fundingGoal)
466       .div(initialSupply)
467       .div(1e18);
468   }
469 
470   // end token conversion functions
471 
472   // pause override
473   function unpause()
474     public
475     onlyOwner
476     whenPaused
477   {
478     // only allow unpausing when in Active stage
479     require(stage == Stages.Active);
480     return super.unpause();
481   }
482 
483   // stage related functions
484   function enterStage(Stages _stage)
485     private
486   {
487     stage = _stage;
488     StageEvent(_stage);
489   }
490 
491   // start whitelist related functions
492 
493   // allow address to buy tokens
494   function whitelistAddress(address _address)
495     external
496     onlyOwner
497     atStage(Stages.Funding)
498   {
499     require(whitelisted[_address] != true);
500     whitelisted[_address] = true;
501     WhitelistedEvent(_address, true);
502   }
503 
504   // disallow address to buy tokens.
505   function blacklistAddress(address _address)
506     external
507     onlyOwner
508     atStage(Stages.Funding)
509   {
510     require(whitelisted[_address] != false);
511     whitelisted[_address] = false;
512     WhitelistedEvent(_address, false);
513   }
514 
515   // check to see if contract whitelist has approved address to buy
516   function whitelisted(address _address)
517     public
518     view
519     returns (bool)
520   {
521     return whitelisted[_address];
522   }
523 
524   // end whitelist related functions
525 
526   // start fee handling functions
527 
528   // public utility function to allow checking of required fee for a given amount
529   function calculateFee(uint256 _value)
530     public
531     view
532     returns (uint256)
533   {
534     return feeRate.mul(_value).div(1000);
535   }
536 
537   // end fee handling functions
538 
539   // start lifecycle functions
540 
541   function buy()
542     public
543     payable
544     checkTimeout
545     atStage(Stages.Funding)
546     isWhitelisted
547     returns (bool)
548   {
549     uint256 _payAmount;
550     uint256 _buyAmount;
551     // check if balance has met funding goal to move on to Pending
552     if (fundedAmount.add(msg.value) < fundingGoal) {
553       // _payAmount is just value sent
554       _payAmount = msg.value;
555       // get token amount from wei... drops remainders (keeps wei dust in contract)
556       _buyAmount = weiToTokens(_payAmount);
557       // check that buyer will indeed receive something after integer division
558       // this check cannot be done in other case because it could prevent
559       // contract from moving to next stage
560       require(_buyAmount > 0);
561     } else {
562       // let the world know that the token is in Pending Stage
563       enterStage(Stages.Pending);
564       // set refund amount (overpaid amount)
565       uint256 _refundAmount = fundedAmount.add(msg.value).sub(fundingGoal);
566       // get actual Ξ amount to buy
567       _payAmount = msg.value.sub(_refundAmount);
568       // get token amount from wei... drops remainders (keeps wei dust in contract)
569       _buyAmount = weiToTokens(_payAmount);
570       // assign remaining dust
571       uint256 _dust = balances[this].sub(_buyAmount);
572       // sub dust from contract
573       balances[this] = balances[this].sub(_dust);
574       // give dust to owner
575       balances[owner] = balances[owner].add(_dust);
576       Transfer(this, owner, _dust);
577       // SHOULD be ok even with reentrancy because of enterStage(Stages.Pending)
578       msg.sender.transfer(_refundAmount);
579     }
580     // deduct token buy amount balance from contract balance
581     balances[this] = balances[this].sub(_buyAmount);
582     // add token buy amount to sender's balance
583     balances[msg.sender] = balances[msg.sender].add(_buyAmount);
584     // increment the funded amount
585     fundedAmount = fundedAmount.add(_payAmount);
586     // send out event giving info on amount bought as well as claimable dust
587     Transfer(this, msg.sender, _buyAmount);
588     BuyEvent(msg.sender, _buyAmount);
589     return true;
590   }
591 
592   function activate()
593     external
594     checkTimeout
595     onlyCustodian
596     payable
597     atStage(Stages.Pending)
598     returns (bool)
599   {
600     // calculate company fee charged for activation
601     uint256 _fee = calculateFee(fundingGoal);
602     // value must exactly match fee
603     require(msg.value == _fee);
604     // if activated and fee paid: put in Active stage
605     enterStage(Stages.Active);
606     // owner (company) fee set in unclaimedPayoutTotals to be claimed by owner
607     unclaimedPayoutTotals[owner] = unclaimedPayoutTotals[owner].add(_fee);
608     // custodian value set to claimable. can now be claimed via claim function
609     // set all eth in contract other than fee as claimable.
610     // should only be buy()s. this ensures buy() dust is cleared
611     unclaimedPayoutTotals[custodian] = unclaimedPayoutTotals[custodian]
612       .add(this.balance.sub(_fee));
613     // allow trading of tokens
614     paused = false;
615     // let world know that this token can now be traded.
616     Unpause();
617     return true;
618   }
619 
620   // used when property no longer exists etc. allows for winding down via payouts
621   // can no longer be traded after function is run
622   function terminate()
623     external
624     onlyCustodian
625     atStage(Stages.Active)
626     returns (bool)
627   {
628     // set Stage to terminated
629     enterStage(Stages.Terminated);
630     // pause. Cannot be unpaused now that in Stages.Terminated
631     paused = true;
632     // let the world know this token is in Terminated Stage
633     TerminatedEvent();
634   }
635 
636   // emergency temporary function used only in case of emergency to return
637   // Ξ to contributors in case of catastrophic contract failure.
638   function kill()
639     external
640     onlyOwner
641   {
642     // stop trading
643     paused = true;
644     // enter stage which will no longer allow unpausing
645     enterStage(Stages.Terminated);
646     // transfer funds to company in order to redistribute manually
647     owner.transfer(this.balance);
648     // let the world know that this token is in Terminated Stage
649     TerminatedEvent();
650   }
651 
652   // end lifecycle functions
653 
654   // start payout related functions
655 
656   // get current payout for perTokenPayout and unclaimed
657   function currentPayout(address _address, bool _includeUnclaimed)
658     public
659     view
660     returns (uint256)
661   {
662     /*
663       need to check if there have been no payouts
664       safe math will throw otherwise due to dividing 0
665 
666       The below variable represents the total payout from the per token rate pattern
667       it uses this funky naming pattern in order to differentiate from the unclaimedPayoutTotals
668       which means something very different.
669     */
670     uint256 _totalPerTokenUnclaimedConverted = totalPerTokenPayout == 0
671       ? 0
672       : balances[_address]
673       .mul(totalPerTokenPayout.sub(claimedPerTokenPayouts[_address]))
674       .div(1e18);
675 
676     /*
677     balances may be bumped into unclaimedPayoutTotals in order to
678     maintain balance tracking accross token transfers
679 
680     perToken payout rates are stored * 1e18 in order to be kept accurate
681     perToken payout is / 1e18 at time of usage for actual Ξ balances
682     unclaimedPayoutTotals are stored as actual Ξ value
683       no need for rate * balance
684     */
685     return _includeUnclaimed
686       ? _totalPerTokenUnclaimedConverted.add(unclaimedPayoutTotals[_address])
687       : _totalPerTokenUnclaimedConverted;
688 
689   }
690 
691   // settle up perToken balances and move into unclaimedPayoutTotals in order
692   // to ensure that token transfers will not result in inaccurate balances
693   function settleUnclaimedPerTokenPayouts(address _from, address _to)
694     private
695     returns (bool)
696   {
697     // add perToken balance to unclaimedPayoutTotals which will not be affected by transfers
698     unclaimedPayoutTotals[_from] = unclaimedPayoutTotals[_from].add(currentPayout(_from, false));
699     // max out claimedPerTokenPayouts in order to effectively make perToken balance 0
700     claimedPerTokenPayouts[_from] = totalPerTokenPayout;
701     // same as above for to
702     unclaimedPayoutTotals[_to] = unclaimedPayoutTotals[_to].add(currentPayout(_to, false));
703     // same as above for to
704     claimedPerTokenPayouts[_to] = totalPerTokenPayout;
705     return true;
706   }
707 
708   // used to manually set Stage to Failed when no users have bought any tokens
709   // if no buy()s occurred before timeoutBlock token would be stuck in Funding
710   function setFailed()
711     external
712     atStage(Stages.Funding)
713     checkTimeout
714     returns (bool)
715   {
716     if (stage == Stages.Funding) {
717       revert();
718     }
719     return true;
720   }
721 
722   // reclaim Ξ for sender if fundingGoal is not met within timeoutBlock
723   function reclaim()
724     external
725     checkTimeout
726     atStage(Stages.Failed)
727     returns (bool)
728   {
729     // get token balance of user
730     uint256 _tokenBalance = balances[msg.sender];
731     // ensure that token balance is over 0
732     require(_tokenBalance > 0);
733     // set token balance to 0 so re reclaims are not possible
734     balances[msg.sender] = 0;
735     // decrement totalSupply by token amount being reclaimed
736     totalSupply = totalSupply.sub(_tokenBalance);
737     Transfer(msg.sender, address(0), _tokenBalance);
738     // decrement fundedAmount by eth amount converted from token amount being reclaimed
739     fundedAmount = fundedAmount.sub(tokensToWei(_tokenBalance));
740     // set reclaim total as token value
741     uint256 _reclaimTotal = tokensToWei(_tokenBalance);
742     // send Ξ back to sender
743     msg.sender.transfer(_reclaimTotal);
744     return true;
745   }
746 
747   // send Ξ to contract to be claimed by token holders
748   function payout()
749     external
750     payable
751     atEitherStage(Stages.Active, Stages.Terminated)
752     onlyCustodian
753     returns (bool)
754   {
755     // calculate fee based on feeRate
756     uint256 _fee = calculateFee(msg.value);
757     // ensure the value is high enough for a fee to be claimed
758     require(_fee > 0);
759     // deduct fee from payout
760     uint256 _payoutAmount = msg.value.sub(_fee);
761     /*
762     totalPerTokenPayout is a rate at which to payout based on token balance
763     it is stored as * 1e18 in order to keep accuracy
764     it is / 1e18 when used relating to actual Ξ values
765     */
766     totalPerTokenPayout = totalPerTokenPayout
767       .add(_payoutAmount
768         .mul(1e18)
769         .div(totalSupply)
770       );
771 
772     // take remaining dust and send to owner rather than leave stuck in contract
773     // should not be more than a few wei
774     uint256 _delta = (_payoutAmount.mul(1e18) % totalSupply).div(1e18);
775     unclaimedPayoutTotals[owner] = unclaimedPayoutTotals[owner].add(_fee).add(_delta);
776     // let the world know that a payout has happened for this token
777     PayoutEvent(_payoutAmount);
778     return true;
779   }
780 
781   // claim total Ξ claimable for sender based on token holdings at time of each payout
782   function claim()
783     external
784     atEitherStage(Stages.Active, Stages.Terminated)
785     returns (uint256)
786   {
787     /*
788     pass true to currentPayout in order to get both:
789       perToken payouts
790       unclaimedPayoutTotals
791     */
792     uint256 _payoutAmount = currentPayout(msg.sender, true);
793     // check that there indeed is a pending payout for sender
794     require(_payoutAmount > 0);
795     // max out per token payout for sender in order to make payouts effectively
796     // 0 for sender
797     claimedPerTokenPayouts[msg.sender] = totalPerTokenPayout;
798     // 0 out unclaimedPayoutTotals for user
799     unclaimedPayoutTotals[msg.sender] = 0;
800     // let the world know that a payout for sender has been claimed
801     ClaimEvent(_payoutAmount);
802     // transfer Ξ payable amount to sender
803     msg.sender.transfer(_payoutAmount);
804     return _payoutAmount;
805   }
806 
807   // end payout related functions
808 
809   // start ERC20 overrides
810 
811   // same as ERC20 transfer other than settling unclaimed payouts
812   function transfer
813   (
814     address _to,
815     uint256 _value
816   )
817     public
818     whenNotPaused
819     returns (bool)
820   {
821     // move perToken payout balance to unclaimedPayoutTotals
822     require(settleUnclaimedPerTokenPayouts(msg.sender, _to));
823     return super.transfer(_to, _value);
824   }
825 
826   // same as ERC20 transfer other than settling unclaimed payouts
827   function transferFrom
828   (
829     address _from,
830     address _to,
831     uint256 _value
832   )
833     public
834     whenNotPaused
835     returns (bool)
836   {
837     // move perToken payout balance to unclaimedPayoutTotals
838     require(settleUnclaimedPerTokenPayouts(_from, _to));
839     return super.transferFrom(_from, _to, _value);
840   }
841 
842   // end ERC20 overrides
843 
844   // check if there is a way to get around gas issue when no gas limit calculated...
845   // fallback function defaulting to buy
846   function()
847     public
848     payable
849   {
850     buy();
851   }
852 }