1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 
92 /**
93  * @title Pausable
94  * @dev Base contract which allows children to implement an emergency stop mechanism.
95  */
96 contract Pausable is Ownable {
97   event Pause();
98   event Unpause();
99 
100   bool public paused = false;
101 
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is not paused.
105    */
106   modifier whenNotPaused() {
107     require(!paused);
108     _;
109   }
110 
111   /**
112    * @dev Modifier to make a function callable only when the contract is paused.
113    */
114   modifier whenPaused() {
115     require(paused);
116     _;
117   }
118 
119   /**
120    * @dev called by the owner to pause, triggers stopped state
121    */
122   function pause() onlyOwner whenNotPaused public {
123     paused = true;
124     Pause();
125   }
126 
127   /**
128    * @dev called by the owner to unpause, returns to normal state
129    */
130   function unpause() onlyOwner whenPaused public {
131     paused = false;
132     Unpause();
133   }
134 }
135 
136 /**
137  * @title ERC20Basic
138  * @dev Simpler version of ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/179
140  */
141 contract ERC20Basic {
142   function totalSupply() public view returns (uint256);
143   function balanceOf(address who) public view returns (uint256);
144   function transfer(address to, uint256 value) public returns (bool);
145   event Transfer(address indexed from, address indexed to, uint256 value);
146 }
147 
148 /**
149  * @title ERC20 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/20
151  */
152 contract ERC20 is ERC20Basic {
153   function allowance(address owner, address spender) public view returns (uint256);
154   function transferFrom(address from, address to, uint256 value) public returns (bool);
155   function approve(address spender, uint256 value) public returns (bool);
156   event Approval(address indexed owner, address indexed spender, uint256 value);
157 }
158 
159 
160 /**
161  * @title Basic token
162  * @dev Basic version of StandardToken, with no allowances.
163  */
164 contract BasicToken is ERC20Basic {
165   using SafeMath for uint256;
166 
167   mapping(address => uint256) balances;
168 
169   uint256 totalSupply_;
170 
171   /**
172   * @dev total number of tokens in existence
173   */
174   function totalSupply() public view returns (uint256) {
175     return totalSupply_;
176   }
177 
178   /**
179   * @dev transfer token for a specified address
180   * @param _to The address to transfer to.
181   * @param _value The amount to be transferred.
182   */
183   function transfer(address _to, uint256 _value) public returns (bool) {
184     require(_to != address(0));
185     require(_value <= balances[msg.sender]);
186 
187     // SafeMath.sub will throw if there is not enough balance.
188     balances[msg.sender] = balances[msg.sender].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     Transfer(msg.sender, _to, _value);
191     return true;
192   }
193 
194   /**
195   * @dev Gets the balance of the specified address.
196   * @param _owner The address to query the the balance of.
197   * @return An uint256 representing the amount owned by the passed address.
198   */
199   function balanceOf(address _owner) public view returns (uint256 balance) {
200     return balances[_owner];
201   }
202 
203 }
204 
205 /**
206  * @title Standard ERC20 token
207  *
208  * @dev Implementation of the basic standard token.
209  * @dev https://github.com/ethereum/EIPs/issues/20
210  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
211  */
212 contract StandardToken is ERC20, BasicToken {
213 
214   mapping (address => mapping (address => uint256)) internal allowed;
215 
216 
217   /**
218    * @dev Transfer tokens from one address to another
219    * @param _from address The address which you want to send tokens from
220    * @param _to address The address which you want to transfer to
221    * @param _value uint256 the amount of tokens to be transferred
222    */
223   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
224     require(_to != address(0));
225     require(_value <= balances[_from]);
226     require(_value <= allowed[_from][msg.sender]);
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    *
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) public returns (bool) {
246     allowed[msg.sender][_spender] = _value;
247     Approval(msg.sender, _spender, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Function to check the amount of tokens that an owner allowed to a spender.
253    * @param _owner address The address which owns the funds.
254    * @param _spender address The address which will spend the funds.
255    * @return A uint256 specifying the amount of tokens still available for the spender.
256    */
257   function allowance(address _owner, address _spender) public view returns (uint256) {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
272     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    *
280    * approve should be called when allowed[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
288     uint oldValue = allowed[msg.sender][_spender];
289     if (_subtractedValue > oldValue) {
290       allowed[msg.sender][_spender] = 0;
291     } else {
292       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293     }
294     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298 }
299 
300 
301 /**
302  * @title Pausable token
303  * @dev StandardToken modified with pausable transfers.
304  **/
305 contract PausableToken is StandardToken, Pausable {
306 
307   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
308     return super.transfer(_to, _value);
309   }
310 
311   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
312     return super.transferFrom(_from, _to, _value);
313   }
314 
315   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
316     return super.approve(_spender, _value);
317   }
318 
319   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
320     return super.increaseApproval(_spender, _addedValue);
321   }
322 
323   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
324     return super.decreaseApproval(_spender, _subtractedValue);
325   }
326 }
327 
328 
329 /**
330  * @title Mintable token
331  * @dev Simple ERC20 Token example, with mintable token creation
332  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
333  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
334  */
335 contract MintableToken is StandardToken, Ownable {
336   event Mint(address indexed to, uint256 amount);
337   event MintFinished();
338 
339   bool public mintingFinished = false;
340 
341 
342   modifier canMint() {
343     require(!mintingFinished);
344     _;
345   }
346 
347   /**
348    * @dev Function to mint tokens
349    * @param _to The address that will receive the minted tokens.
350    * @param _amount The amount of tokens to mint.
351    * @return A boolean that indicates if the operation was successful.
352    */
353   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
354     totalSupply_ = totalSupply_.add(_amount);
355     balances[_to] = balances[_to].add(_amount);
356     Mint(_to, _amount);
357     Transfer(address(0), _to, _amount);
358     return true;
359   }
360 
361   /**
362    * @dev Function to stop minting new tokens.
363    * @return True if the operation was successful.
364    */
365   function finishMinting() onlyOwner canMint public returns (bool) {
366     mintingFinished = true;
367     MintFinished();
368     return true;
369   }
370 }
371 
372 
373 
374 
375 
376 
377 /**
378  * @title SafeERC20
379  * @dev Wrappers around ERC20 operations that throw on failure.
380  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
381  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
382  */
383 library SafeERC20 {
384   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
385     assert(token.transfer(to, value));
386   }
387 
388   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
389     assert(token.transferFrom(from, to, value));
390   }
391 
392   function safeApprove(ERC20 token, address spender, uint256 value) internal {
393     assert(token.approve(spender, value));
394   }
395 }
396 
397 
398 /**
399  * @title TokenVesting
400  * @dev A token holder contract that can release its token balance gradually like a
401  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
402  * owner.
403  */
404 contract TokenVesting is Ownable {
405   using SafeMath for uint256;
406   using SafeERC20 for ERC20Basic;
407 
408   event Released(uint256 amount);
409   event Revoked();
410 
411   // beneficiary of tokens after they are released
412   address public beneficiary;
413 
414   uint256 public cliff;
415   uint256 public start;
416   uint256 public duration;
417 
418   bool public revocable;
419 
420   mapping (address => uint256) public released;
421   mapping (address => bool) public revoked;
422 
423   /**
424    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
425    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
426    * of the balance will have vested.
427    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
428    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
429    * @param _duration duration in seconds of the period in which the tokens will vest
430    * @param _revocable whether the vesting is revocable or not
431    */
432   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
433     require(_beneficiary != address(0));
434     require(_cliff <= _duration);
435 
436     beneficiary = _beneficiary;
437     revocable = _revocable;
438     duration = _duration;
439     cliff = _start.add(_cliff);
440     start = _start;
441   }
442 
443   /**
444    * @notice Transfers vested tokens to beneficiary.
445    * @param token ERC20 token which is being vested
446    */
447   function release(ERC20Basic token) public {
448     uint256 unreleased = releasableAmount(token);
449 
450     require(unreleased > 0);
451 
452     released[token] = released[token].add(unreleased);
453 
454     token.safeTransfer(beneficiary, unreleased);
455 
456     Released(unreleased);
457   }
458 
459   /**
460    * @notice Allows the owner to revoke the vesting. Tokens already vested
461    * remain in the contract, the rest are returned to the owner.
462    * @param token ERC20 token which is being vested
463    */
464   function revoke(ERC20Basic token) public onlyOwner {
465     require(revocable);
466     require(!revoked[token]);
467 
468     uint256 balance = token.balanceOf(this);
469 
470     uint256 unreleased = releasableAmount(token);
471     uint256 refund = balance.sub(unreleased);
472 
473     revoked[token] = true;
474 
475     token.safeTransfer(owner, refund);
476 
477     Revoked();
478   }
479 
480   /**
481    * @dev Calculates the amount that has already vested but hasn't been released yet.
482    * @param token ERC20 token which is being vested
483    */
484   function releasableAmount(ERC20Basic token) public view returns (uint256) {
485     return vestedAmount(token).sub(released[token]);
486   }
487 
488   /**
489    * @dev Calculates the amount that has already vested.
490    * @param token ERC20 token which is being vested
491    */
492   function vestedAmount(ERC20Basic token) public view returns (uint256) {
493     uint256 currentBalance = token.balanceOf(this);
494     uint256 totalBalance = currentBalance.add(released[token]);
495 
496     if (now < cliff) {
497       return 0;
498     } else if (now >= start.add(duration) || revoked[token]) {
499       return totalBalance;
500     } else {
501       return totalBalance.mul(now.sub(start)).div(duration);
502     }
503   }
504 }
505 
506 
507 contract SimplePreTGE is Ownable {
508 
509   bool public allocationsLocked;
510 
511   struct Contribution {
512     bool hasVested;
513     uint256 weiContributed;
514   }
515   mapping (address => Contribution)  public contributions;
516 
517   function disableAllocationModificationsForEver() external onlyOwner returns(bool) {
518     allocationsLocked = true;
519   }
520 
521   function bulkReserveTokensForAddresses(address[] addrs, uint256[] weiContributions, bool[] _vestingDecisions) onlyOwner external returns(bool) {
522     require(!allocationsLocked);
523     require((addrs.length == weiContributions.length) && (addrs.length == _vestingDecisions.length));
524     for (uint i=0; i<addrs.length; i++) {
525       contributions[addrs[i]].weiContributed = weiContributions[i];
526       contributions[addrs[i]].hasVested = _vestingDecisions[i];
527     }
528     return true;
529   }
530 
531 }
532 
533 
534 contract SimpleTGE is Ownable {
535   using SafeMath for uint256;
536 
537   // start and end timestamps (both inclusive) when sale is open
538   uint256 public publicTGEStartBlockTimeStamp;
539 
540   uint256 public publicTGEEndBlockTimeStamp;
541 
542   // address where funds are collected
543   address public fundsWallet;
544 
545   // amount of raised money in wei
546   uint256 public weiRaised;
547 
548   // sale cap in wei
549   uint256 public totalCapInWei;
550 
551   // individual cap in wei
552   uint256 public individualCapInWei;
553 
554   // how long the TRS subscription is open after the TGE.
555   uint256 public TRSOffset = 5 days;
556 
557   mapping (address => bool) public whitelist;
558 
559   address[] public contributors;
560   struct Contribution {
561     bool hasVested;
562     uint256 weiContributed;
563   }
564 
565   mapping (address => Contribution)  public contributions;
566 
567   modifier whilePublicTGEIsActive() {
568     require(block.timestamp >= publicTGEStartBlockTimeStamp && block.timestamp <= publicTGEEndBlockTimeStamp);
569     _;
570   }
571 
572   modifier isWhitelisted() {
573     require(whitelist[msg.sender]);
574     _;
575   }
576 
577   function blacklistAddresses(address[] addrs) external onlyOwner returns(bool) {
578     require(addrs.length <= 100);
579     for (uint i = 0; i < addrs.length; i++) {
580       require(addrs[i] != address(0));
581       whitelist[addrs[i]] = false;
582     }
583     return true;
584   }
585 
586   function whitelistAddresses(address[] addrs) external onlyOwner returns(bool) {
587     require(addrs.length <= 100);
588     for (uint i = 0; i < addrs.length; i++) {
589       require(addrs[i] != address(0));
590       whitelist[addrs[i]] = true;
591     }
592     return true;
593   }
594 
595   /**
596    * @dev Transfer all Ether held by the contract to the address specified by owner.
597    */
598   function reclaimEther(address _beneficiary) external onlyOwner {
599     _beneficiary.transfer(this.balance);
600   }
601 
602   function SimpleTGE (
603     address _fundsWallet,
604     uint256 _publicTGEStartBlockTimeStamp,
605     uint256 _publicTGEEndBlockTimeStamp,
606     uint256 _individualCapInWei,
607     uint256 _totalCapInWei
608   ) public
609   {
610     require(_publicTGEStartBlockTimeStamp >= block.timestamp);
611     require(_publicTGEEndBlockTimeStamp > _publicTGEStartBlockTimeStamp);
612     require(_fundsWallet != address(0));
613     require(_individualCapInWei > 0);
614     require(_individualCapInWei <= _totalCapInWei);
615     require(_totalCapInWei > 0);
616 
617     fundsWallet = _fundsWallet;
618     publicTGEStartBlockTimeStamp = _publicTGEStartBlockTimeStamp;
619     publicTGEEndBlockTimeStamp = _publicTGEEndBlockTimeStamp;
620     individualCapInWei = _individualCapInWei;
621     totalCapInWei = _totalCapInWei;
622   }
623 
624   // allows changing the individual cap.
625   function changeIndividualCapInWei(uint256 _individualCapInWei) onlyOwner external returns(bool) {
626       require(_individualCapInWei > 0);
627       require(_individualCapInWei < totalCapInWei);
628       individualCapInWei = _individualCapInWei;
629       return true;
630   }
631 
632   // low level token purchase function
633   function contribute(bool _vestingDecision) internal {
634     // validations
635     require(msg.sender != address(0));
636     require(msg.value != 0);
637     require(weiRaised.add(msg.value) <= totalCapInWei);
638     require(contributions[msg.sender].weiContributed.add(msg.value) <= individualCapInWei);
639     // if we have not received any WEI from this address until now, then we add this address to contributors list.
640     if (contributions[msg.sender].weiContributed == 0) {
641       contributors.push(msg.sender);
642     }
643     contributions[msg.sender].weiContributed = contributions[msg.sender].weiContributed.add(msg.value);
644     weiRaised = weiRaised.add(msg.value);
645     contributions[msg.sender].hasVested = _vestingDecision;
646     fundsWallet.transfer(msg.value);
647   }
648 
649   function contributeAndVest() external whilePublicTGEIsActive isWhitelisted payable {
650     contribute(true);
651   }
652 
653   function contributeWithoutVesting() public whilePublicTGEIsActive isWhitelisted payable {
654     contribute(false);
655   }
656 
657   // fallback function can be used to buy tokens
658   function () external payable {
659     contributeWithoutVesting();
660   }
661 
662   // Vesting logic
663   // The following cases are checked for _beneficiary's actions:
664   function vest(bool _vestingDecision) external isWhitelisted returns(bool) {
665     bool existingDecision = contributions[msg.sender].hasVested;
666     require(existingDecision != _vestingDecision);
667     require(block.timestamp >= publicTGEStartBlockTimeStamp);
668     require(contributions[msg.sender].weiContributed > 0);
669     // Ensure vesting cannot be done once TRS starts
670     if (block.timestamp > publicTGEEndBlockTimeStamp) {
671       require(block.timestamp.sub(publicTGEEndBlockTimeStamp) <= TRSOffset);
672     }
673     contributions[msg.sender].hasVested = _vestingDecision;
674     return true;
675   }
676 }
677 
678 contract LendroidSupportToken is MintableToken, PausableToken {
679 
680   string public constant name = "Lendroid Support Token";
681   string public constant symbol = "LST";
682   uint256 public constant decimals = 18;
683   uint256 public constant MAX_SUPPLY = 12000000000 * (10 ** uint256(decimals));// 12 billion tokens, 18 decimal places
684 
685   /**
686    * @dev Constructor that pauses tradability of tokens.
687    */
688   function LendroidSupportToken() public {
689     paused = true;
690   }
691 
692 
693   /**
694    * @dev totalSupply is set via the minting process
695    */
696 
697   function mint(address to, uint256 amount) onlyOwner public returns (bool) {
698     require(totalSupply_ + amount <= MAX_SUPPLY);
699     return super.mint(to, amount);
700   }
701 
702 }
703 
704 /**
705  * @title SimpleLSTDistribution
706  * @dev SimpleLSTDistribution contract provides interface for the contributor to withdraw their allocations / initiate the vesting contract
707  */
708 contract SimpleLSTDistribution is Ownable {
709   using SafeMath for uint256;
710 
711   SimplePreTGE public SimplePreTGEContract;
712   SimpleTGE public SimpleTGEContract;
713   LendroidSupportToken public token;
714   uint256 public LSTRatePerWEI = 48000;
715   //vesting related params
716   // bonus multiplied to every vesting contributor's allocation
717   uint256 public vestingBonusMultiplier;
718   uint256 public vestingBonusMultiplierPrecision = 1000000;
719   uint256 public vestingDuration;
720   uint256 public vestingStartTime;
721 
722   struct allocation {
723     bool shouldVest;
724     uint256 weiContributed;
725     uint256 LSTAllocated;
726     bool hasWithdrawn;
727   }
728   // maps all allocations claimed by contributors
729   mapping (address => allocation)  public allocations;
730 
731   // map of address to token vesting contract
732   mapping (address => TokenVesting) public vesting;
733 
734   /**
735    * event for token transfer logging
736    * @param beneficiary who is receiving the tokens
737    * @param tokens amount of tokens given to the beneficiary
738    */
739   event LogLSTsWithdrawn(address beneficiary, uint256 tokens);
740 
741   /**
742    * event for time vested token transfer logging
743    * @param beneficiary who is receiving the time vested tokens
744    * @param tokens amount of tokens that will be vested to the beneficiary
745    * @param start unix timestamp at which the tokens will start vesting
746    * @param cliff duration in seconds after start time at which vesting will start
747    * @param duration total duration in seconds in which the tokens will be vested
748    */
749   event LogTimeVestingLSTsWithdrawn(address beneficiary, uint256 tokens, uint256 start, uint256 cliff, uint256 duration);
750 
751   function SimpleLSTDistribution(
752       address _SimplePreTGEAddress,
753       address _SimpleTGEAddress,
754       uint256 _vestingBonusMultiplier,
755       uint256 _vestingDuration,
756       uint256 _vestingStartTime,
757       address _LSTAddress
758     ) public {
759 
760     require(_SimplePreTGEAddress != address(0));
761     require(_SimpleTGEAddress != address(0));
762     require(_vestingBonusMultiplier >= 1000000);
763     require(_vestingBonusMultiplier <= 10000000);
764     require(_vestingDuration > 0);
765     require(_vestingStartTime > block.timestamp);
766 
767     token = LendroidSupportToken(_LSTAddress);
768     // token = new LendroidSupportToken();
769 
770     SimplePreTGEContract = SimplePreTGE(_SimplePreTGEAddress);
771     SimpleTGEContract = SimpleTGE(_SimpleTGEAddress);
772     vestingBonusMultiplier = _vestingBonusMultiplier;
773     vestingDuration = _vestingDuration;
774     vestingStartTime = _vestingStartTime;
775   }
776 
777   // member function to mint tokens to a beneficiary
778   function mintTokens(address beneficiary, uint256 tokens) public onlyOwner {
779     require(beneficiary != 0x0);
780     require(tokens > 0);
781     require(token.mint(beneficiary, tokens));
782     LogLSTsWithdrawn(beneficiary, tokens);
783   }
784 
785   function withdraw() external {
786     require(!allocations[msg.sender].hasWithdrawn);
787     // make sure simpleTGE is over and the TRS subscription has ended
788     require(block.timestamp > SimpleTGEContract.publicTGEEndBlockTimeStamp().add(SimpleTGEContract.TRSOffset()));
789     // allocations should be locked in the pre-TGE
790     require(SimplePreTGEContract.allocationsLocked());
791     // should have participated in the TGE or the pre-TGE
792     bool _preTGEHasVested;
793     uint256 _preTGEWeiContributed;
794     bool _publicTGEHasVested;
795     uint256 _publicTGEWeiContributed;
796     (_publicTGEHasVested, _publicTGEWeiContributed) = SimpleTGEContract.contributions(msg.sender);
797     (_preTGEHasVested, _preTGEWeiContributed) = SimplePreTGEContract.contributions(msg.sender);
798     uint256 _totalWeiContribution = _preTGEWeiContributed.add(_publicTGEWeiContributed);
799     require(_totalWeiContribution > 0);
800     // the same contributor could have contributed in the pre-tge and the tge, so we add the contributions.
801     bool _shouldVest = _preTGEHasVested || _publicTGEHasVested;
802     allocations[msg.sender].hasWithdrawn = true;
803     allocations[msg.sender].shouldVest = _shouldVest;
804     allocations[msg.sender].weiContributed = _totalWeiContribution;
805     uint256 _lstAllocated;
806     if (!_shouldVest) {
807       _lstAllocated = LSTRatePerWEI.mul(_totalWeiContribution);
808       allocations[msg.sender].LSTAllocated = _lstAllocated;
809       require(token.mint(msg.sender, _lstAllocated));
810       LogLSTsWithdrawn(msg.sender, _lstAllocated);
811     }
812     else {
813       _lstAllocated = LSTRatePerWEI.mul(_totalWeiContribution).mul(vestingBonusMultiplier).div(vestingBonusMultiplierPrecision);
814       allocations[msg.sender].LSTAllocated = _lstAllocated;
815       uint256 _withdrawNow = _lstAllocated.div(10);
816       uint256 _vestedPortion = _lstAllocated.sub(_withdrawNow);
817       vesting[msg.sender] = new TokenVesting(msg.sender, vestingStartTime, 0, vestingDuration, false);
818       require(token.mint(msg.sender, _withdrawNow));
819       LogLSTsWithdrawn(msg.sender, _withdrawNow);
820       require(token.mint(address(vesting[msg.sender]), _vestedPortion));
821       LogTimeVestingLSTsWithdrawn(address(vesting[msg.sender]), _vestedPortion, vestingStartTime, 0, vestingDuration);
822     }
823   }
824 
825   // member function that can be called to release vested tokens periodically
826   function releaseVestedTokens(address beneficiary) public {
827     require(beneficiary != 0x0);
828 
829     TokenVesting tokenVesting = vesting[beneficiary];
830     tokenVesting.release(token);
831   }
832 
833   // unpauseToken token for transfers
834   function unpauseToken() public onlyOwner {
835     token.unpause();
836   }
837 
838 }