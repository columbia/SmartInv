1 pragma solidity ^0.4.18;
2 
3 // File: contracts/zeppelin-solidity-1.4/Ownable.sol
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
47 // File: contracts/BRDCrowdsaleAuthorizer.sol
48 
49 /**
50  * Contract BRDCrowdsaleAuthorizer is used by the crowdsale website
51  * to autorize wallets to participate in the crowdsale. Because all
52  * participants must go through the KYC/AML phase, only accounts
53  * listed in this contract may contribute to the crowdsale
54  */
55 contract BRDCrowdsaleAuthorizer is Ownable {
56   // these accounts are authorized to participate in the crowdsale
57   mapping (address => bool) internal authorizedAccounts;
58   // these accounts are authorized to authorize accounts
59   mapping (address => bool) internal authorizers;
60 
61   // emitted when a new account is authorized
62   event Authorized(address indexed _to);
63 
64   // add an authorizer to the authorizers mapping. the _newAuthorizer will
65   // be able to add other authorizers and authorize crowdsale participants
66   function addAuthorizer(address _newAuthorizer) onlyOwnerOrAuthorizer public {
67     // allow the provided address to authorize accounts
68     authorizers[_newAuthorizer] = true;
69   }
70 
71   // remove an authorizer from the authorizers mapping. the _bannedAuthorizer will
72   // no longer have permission to do anything on this contract
73   function removeAuthorizer(address _bannedAuthorizer) onlyOwnerOrAuthorizer public {
74     // only attempt to remove the authorizer if they are currently authorized
75     require(authorizers[_bannedAuthorizer]);
76     // remove the authorizer
77     delete authorizers[_bannedAuthorizer];
78   }
79 
80   // allow an account to participate in the crowdsale
81   function authorizeAccount(address _newAccount) onlyOwnerOrAuthorizer public {
82     if (!authorizedAccounts[_newAccount]) {
83       // allow the provided account to participate in the crowdsale
84       authorizedAccounts[_newAccount] = true;
85       // emit the Authorized event
86       Authorized(_newAccount);
87     }
88   }
89 
90   // returns whether or not the provided _account is an authorizer
91   function isAuthorizer(address _account) constant public returns (bool _isAuthorizer) {
92     return msg.sender == owner || authorizers[_account] == true;
93   }
94 
95   // returns whether or not the provided _account is authorized to participate in the crowdsale
96   function isAuthorized(address _account) constant public returns (bool _authorized) {
97     return authorizedAccounts[_account] == true;
98   }
99 
100   // allow only the contract creator or one of the authorizers to do this
101   modifier onlyOwnerOrAuthorizer() {
102     require(msg.sender == owner || authorizers[msg.sender]);
103     _;
104   }
105 }
106 
107 // File: contracts/zeppelin-solidity-1.4/SafeMath.sol
108 
109 /**
110  * @title SafeMath
111  * @dev Math operations with safety checks that throw on error
112  */
113 library SafeMath {
114   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115     if (a == 0) {
116       return 0;
117     }
118     uint256 c = a * b;
119     assert(c / a == b);
120     return c;
121   }
122 
123   function div(uint256 a, uint256 b) internal pure returns (uint256) {
124     // assert(b > 0); // Solidity automatically throws when dividing by 0
125     uint256 c = a / b;
126     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127     return c;
128   }
129 
130   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131     assert(b <= a);
132     return a - b;
133   }
134 
135   function add(uint256 a, uint256 b) internal pure returns (uint256) {
136     uint256 c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 }
141 
142 // File: contracts/BRDLockup.sol
143 
144 /**
145  * Contract BRDLockup keeps track of a vesting schedule for pre-sold tokens.
146  * Pre-sold tokens are rewarded up to `numIntervals` times separated by an
147  * `interval` of time. An equal amount of tokens (`allocation` divided by `numIntervals`)
148  * is marked for reward each `interval`.
149  *
150  * The owner of the contract will call processInterval() which will
151  * update the allocation state. The owner of the contract should then
152  * read the allocation data and reward the beneficiaries.
153  */
154 contract BRDLockup is Ownable {
155   using SafeMath for uint256;
156 
157   // Allocation stores info about how many tokens to reward a beneficiary account
158   struct Allocation {
159     address beneficiary;      // account to receive rewards
160     uint256 allocation;       // total allocated tokens
161     uint256 remainingBalance; // remaining balance after the current interval
162     uint256 currentInterval;  // the current interval for the given reward
163     uint256 currentReward;    // amount to be rewarded during the current interval
164   }
165 
166   // the allocation state
167   Allocation[] public allocations;
168 
169   // the date at which allocations begin unlocking
170   uint256 public unlockDate;
171 
172   // the current unlock interval
173   uint256 public currentInterval;
174 
175   // the interval at which allocations will be rewarded
176   uint256 public intervalDuration;
177 
178   // the number of total reward intervals, zero indexed
179   uint256 public numIntervals;
180 
181   event Lock(address indexed _to, uint256 _amount);
182 
183   event Unlock(address indexed _to, uint256 _amount);
184 
185   // constructor
186   // @param _crowdsaleEndDate - the date the crowdsale ends
187   function BRDLockup(uint256 _crowdsaleEndDate, uint256 _numIntervals, uint256 _intervalDuration)  public {
188     unlockDate = _crowdsaleEndDate;
189     numIntervals = _numIntervals;
190     intervalDuration = _intervalDuration;
191     currentInterval = 0;
192   }
193 
194   // update the allocation storage remaining balances
195   function processInterval() onlyOwner public returns (bool _shouldProcessRewards) {
196     // ensure the time interval is correct
197     bool _correctInterval = now >= unlockDate && now.sub(unlockDate) > currentInterval.mul(intervalDuration);
198     bool _validInterval = currentInterval < numIntervals;
199     if (!_correctInterval || !_validInterval)
200       return false;
201 
202     // advance the current interval
203     currentInterval = currentInterval.add(1);
204 
205     // number of iterations to read all allocations
206     uint _allocationsIndex = allocations.length;
207 
208     // loop through every allocation
209     for (uint _i = 0; _i < _allocationsIndex; _i++) {
210       // the current reward for the allocation at index `i`
211       uint256 _amountToReward;
212 
213       // if we are at the last interval, the reward amount is the entire remaining balance
214       if (currentInterval == numIntervals) {
215         _amountToReward = allocations[_i].remainingBalance;
216       } else {
217         // otherwise the reward amount is the total allocation divided by the number of intervals
218         _amountToReward = allocations[_i].allocation.div(numIntervals);
219       }
220       // update the allocation storage
221       allocations[_i].currentReward = _amountToReward;
222     }
223 
224     return true;
225   }
226 
227   // the total number of allocations
228   function numAllocations() constant public returns (uint) {
229     return allocations.length;
230   }
231 
232   // the amount allocated for beneficiary at `_index`
233   function allocationAmount(uint _index) constant public returns (uint256) {
234     return allocations[_index].allocation;
235   }
236 
237   // reward the beneficiary at `_index`
238   function unlock(uint _index) onlyOwner public returns (bool _shouldReward, address _beneficiary, uint256 _rewardAmount) {
239     // ensure the beneficiary is not rewarded twice during the same interval
240     if (allocations[_index].currentInterval < currentInterval) {
241       // record the currentInterval so the above check is useful
242       allocations[_index].currentInterval = currentInterval;
243       // subtract the reward from their remaining balance
244       allocations[_index].remainingBalance = allocations[_index].remainingBalance.sub(allocations[_index].currentReward);
245       // emit event
246       Unlock(allocations[_index].beneficiary, allocations[_index].currentReward);
247       // return value
248       _shouldReward = true;
249     } else {
250       // return value
251       _shouldReward = false;
252     }
253 
254     // return values
255     _rewardAmount = allocations[_index].currentReward;
256     _beneficiary = allocations[_index].beneficiary;
257   }
258 
259   // add a new allocation to the lockup
260   function pushAllocation(address _beneficiary, uint256 _numTokens) onlyOwner public {
261     require(now < unlockDate);
262     allocations.push(
263       Allocation(
264         _beneficiary,
265         _numTokens,
266         _numTokens,
267         0,
268         0
269       )
270     );
271     Lock(_beneficiary, _numTokens);
272   }
273 }
274 
275 // File: contracts/zeppelin-solidity-1.4/ERC20Basic.sol
276 
277 /**
278  * @title ERC20Basic
279  * @dev Simpler version of ERC20 interface
280  * @dev see https://github.com/ethereum/EIPs/issues/179
281  */
282 contract ERC20Basic {
283   uint256 public totalSupply;
284   function balanceOf(address who) public view returns (uint256);
285   function transfer(address to, uint256 value) public returns (bool);
286   event Transfer(address indexed from, address indexed to, uint256 value);
287 }
288 
289 // File: contracts/zeppelin-solidity-1.4/BasicToken.sol
290 
291 /**
292  * @title Basic token
293  * @dev Basic version of StandardToken, with no allowances.
294  */
295 contract BasicToken is ERC20Basic {
296   using SafeMath for uint256;
297 
298   mapping(address => uint256) balances;
299 
300   /**
301   * @dev transfer token for a specified address
302   * @param _to The address to transfer to.
303   * @param _value The amount to be transferred.
304   */
305   function transfer(address _to, uint256 _value) public returns (bool) {
306     require(_to != address(0));
307     require(_value <= balances[msg.sender]);
308 
309     // SafeMath.sub will throw if there is not enough balance.
310     balances[msg.sender] = balances[msg.sender].sub(_value);
311     balances[_to] = balances[_to].add(_value);
312     Transfer(msg.sender, _to, _value);
313     return true;
314   }
315 
316   /**
317   * @dev Gets the balance of the specified address.
318   * @param _owner The address to query the the balance of.
319   * @return An uint256 representing the amount owned by the passed address.
320   */
321   function balanceOf(address _owner) public view returns (uint256 balance) {
322     return balances[_owner];
323   }
324 
325 }
326 
327 // File: contracts/zeppelin-solidity-1.4/ERC20.sol
328 
329 /**
330  * @title ERC20 interface
331  * @dev see https://github.com/ethereum/EIPs/issues/20
332  */
333 contract ERC20 is ERC20Basic {
334   function allowance(address owner, address spender) public view returns (uint256);
335   function transferFrom(address from, address to, uint256 value) public returns (bool);
336   function approve(address spender, uint256 value) public returns (bool);
337   event Approval(address indexed owner, address indexed spender, uint256 value);
338 }
339 
340 // File: contracts/zeppelin-solidity-1.4/StandardToken.sol
341 
342 /**
343  * @title Standard ERC20 token
344  *
345  * @dev Implementation of the basic standard token.
346  * @dev https://github.com/ethereum/EIPs/issues/20
347  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
348  */
349 contract StandardToken is ERC20, BasicToken {
350 
351   mapping (address => mapping (address => uint256)) internal allowed;
352 
353 
354   /**
355    * @dev Transfer tokens from one address to another
356    * @param _from address The address which you want to send tokens from
357    * @param _to address The address which you want to transfer to
358    * @param _value uint256 the amount of tokens to be transferred
359    */
360   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
361     require(_to != address(0));
362     require(_value <= balances[_from]);
363     require(_value <= allowed[_from][msg.sender]);
364 
365     balances[_from] = balances[_from].sub(_value);
366     balances[_to] = balances[_to].add(_value);
367     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
368     Transfer(_from, _to, _value);
369     return true;
370   }
371 
372   /**
373    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
374    *
375    * Beware that changing an allowance with this method brings the risk that someone may use both the old
376    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
377    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
378    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
379    * @param _spender The address which will spend the funds.
380    * @param _value The amount of tokens to be spent.
381    */
382   function approve(address _spender, uint256 _value) public returns (bool) {
383     allowed[msg.sender][_spender] = _value;
384     Approval(msg.sender, _spender, _value);
385     return true;
386   }
387 
388   /**
389    * @dev Function to check the amount of tokens that an owner allowed to a spender.
390    * @param _owner address The address which owns the funds.
391    * @param _spender address The address which will spend the funds.
392    * @return A uint256 specifying the amount of tokens still available for the spender.
393    */
394   function allowance(address _owner, address _spender) public view returns (uint256) {
395     return allowed[_owner][_spender];
396   }
397 
398   /**
399    * approve should be called when allowed[_spender] == 0. To increment
400    * allowed value is better to use this function to avoid 2 calls (and wait until
401    * the first transaction is mined)
402    * From MonolithDAO Token.sol
403    */
404   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
405     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
406     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
407     return true;
408   }
409 
410   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
411     uint oldValue = allowed[msg.sender][_spender];
412     if (_subtractedValue > oldValue) {
413       allowed[msg.sender][_spender] = 0;
414     } else {
415       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
416     }
417     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
418     return true;
419   }
420 
421 }
422 
423 // File: contracts/zeppelin-solidity-1.4/MintableToken.sol
424 
425 /**
426  * @title Mintable token
427  * @dev Simple ERC20 Token example, with mintable token creation
428  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
429  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
430  */
431 
432 contract MintableToken is StandardToken, Ownable {
433   event Mint(address indexed to, uint256 amount);
434   event MintFinished();
435 
436   bool public mintingFinished = false;
437 
438 
439   modifier canMint() {
440     require(!mintingFinished);
441     _;
442   }
443 
444   /**
445    * @dev Function to mint tokens
446    * @param _to The address that will receive the minted tokens.
447    * @param _amount The amount of tokens to mint.
448    * @return A boolean that indicates if the operation was successful.
449    */
450   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
451     totalSupply = totalSupply.add(_amount);
452     balances[_to] = balances[_to].add(_amount);
453     Mint(_to, _amount);
454     Transfer(address(0), _to, _amount);
455     return true;
456   }
457 
458   /**
459    * @dev Function to stop minting new tokens.
460    * @return True if the operation was successful.
461    */
462   function finishMinting() onlyOwner canMint public returns (bool) {
463     mintingFinished = true;
464     MintFinished();
465     return true;
466   }
467 }
468 
469 // File: contracts/BRDToken.sol
470 
471 contract BRDToken is MintableToken {
472   using SafeMath for uint256;
473 
474   string public name = "Bread Token";
475   string public symbol = "BRD";
476   uint256 public decimals = 18;
477 
478   // override StandardToken#transferFrom
479   // ensures that minting has finished or the message sender is the token owner
480   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
481     require(mintingFinished || msg.sender == owner);
482     return super.transferFrom(_from, _to, _value);
483   }
484 
485   // override StandardToken#transfer
486   // ensures the minting has finished or the message sender is the token owner
487   function transfer(address _to, uint256 _value) public returns (bool) {
488     require(mintingFinished || msg.sender == owner);
489     return super.transfer(_to, _value);
490   }
491 }
492 
493 // File: contracts/zeppelin-solidity-1.4/Crowdsale.sol
494 
495 /**
496  * @title Crowdsale
497  * @dev Crowdsale is a base contract for managing a token crowdsale.
498  * Crowdsales have a start and end timestamps, where investors can make
499  * token purchases and the crowdsale will assign them tokens based
500  * on a token per ETH rate. Funds collected are forwarded to a wallet
501  * as they arrive.
502  */
503 contract Crowdsale {
504   using SafeMath for uint256;
505 
506   // The token being sold
507   MintableToken public token;
508 
509   // start and end timestamps where investments are allowed (both inclusive)
510   uint256 public startTime;
511   uint256 public endTime;
512 
513   // address where funds are collected
514   address public wallet;
515 
516   // how many token units a buyer gets per wei
517   uint256 public rate;
518 
519   // amount of raised money in wei
520   uint256 public weiRaised;
521 
522   /**
523    * event for token purchase logging
524    * @param purchaser who paid for the tokens
525    * @param beneficiary who got the tokens
526    * @param value weis paid for purchase
527    * @param amount amount of tokens purchased
528    */
529   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
530 
531 
532   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
533     require(_startTime >= now);
534     require(_endTime >= _startTime);
535     require(_rate > 0);
536     require(_wallet != address(0));
537 
538     token = createTokenContract();
539     startTime = _startTime;
540     endTime = _endTime;
541     rate = _rate;
542     wallet = _wallet;
543   }
544 
545   // creates the token to be sold.
546   // override this method to have crowdsale of a specific mintable token.
547   function createTokenContract() internal returns (MintableToken) {
548     return new MintableToken();
549   }
550 
551 
552   // fallback function can be used to buy tokens
553   function () external payable {
554     buyTokens(msg.sender);
555   }
556 
557   // low level token purchase function
558   function buyTokens(address beneficiary) public payable {
559     require(beneficiary != address(0));
560     require(validPurchase());
561 
562     uint256 weiAmount = msg.value;
563 
564     // calculate token amount to be created
565     uint256 tokens = weiAmount.mul(rate);
566 
567     // update state
568     weiRaised = weiRaised.add(weiAmount);
569 
570     token.mint(beneficiary, tokens);
571     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
572 
573     forwardFunds();
574   }
575 
576   // send ether to the fund collection wallet
577   // override to create custom fund forwarding mechanisms
578   function forwardFunds() internal {
579     wallet.transfer(msg.value);
580   }
581 
582   // @return true if the transaction can buy tokens
583   function validPurchase() internal view returns (bool) {
584     bool withinPeriod = now >= startTime && now <= endTime;
585     bool nonZeroPurchase = msg.value != 0;
586     return withinPeriod && nonZeroPurchase;
587   }
588 
589   // @return true if crowdsale event has ended
590   function hasEnded() public view returns (bool) {
591     return now > endTime;
592   }
593 
594 
595 }
596 
597 // File: contracts/zeppelin-solidity-1.4/FinalizableCrowdsale.sol
598 
599 /**
600  * @title FinalizableCrowdsale
601  * @dev Extension of Crowdsale where an owner can do extra work
602  * after finishing.
603  */
604 contract FinalizableCrowdsale is Crowdsale, Ownable {
605   using SafeMath for uint256;
606 
607   bool public isFinalized = false;
608 
609   event Finalized();
610 
611   /**
612    * @dev Must be called after crowdsale ends, to do some extra finalization
613    * work. Calls the contract's finalization function.
614    */
615   function finalize() onlyOwner public {
616     require(!isFinalized);
617     require(hasEnded());
618 
619     finalization();
620     Finalized();
621 
622     isFinalized = true;
623   }
624 
625   /**
626    * @dev Can be overridden to add finalization logic. The overriding function
627    * should call super.finalization() to ensure the chain of finalization is
628    * executed entirely.
629    */
630   function finalization() internal {
631   }
632 }
633 
634 // File: contracts/BRDCrowdsale.sol
635 
636 contract BRDCrowdsale is FinalizableCrowdsale {
637   using SafeMath for uint256;
638 
639   // maximum amount of wei raised during this crowdsale
640   uint256 public cap;
641 
642   // minimum per-participant wei contribution
643   uint256 public minContribution;
644 
645   // maximum per-participant wei contribution
646   uint256 public maxContribution;
647 
648   // how many token unites the owner gets per buyer wei
649   uint256 public ownerRate;
650 
651   // number of tokens per 100 to lock up in lockupTokens()
652   uint256 public bonusRate;
653 
654   // the address to which the owner share of tokens are sent
655   address public tokenWallet;
656 
657   // crowdsale authorizer contract determines who can participate
658   BRDCrowdsaleAuthorizer public authorizer;
659 
660   // the lockup contract holds presale authorization amounts
661   BRDLockup public lockup;
662 
663   // constructor
664   function BRDCrowdsale(
665     uint256 _cap,         // maximum wei raised
666     uint256 _minWei,      // minimum per-contributor wei
667     uint256 _maxWei,      // maximum per-contributor wei
668     uint256 _startTime,   // crowdsale start time
669     uint256 _endTime,     // crowdsale end time
670     uint256 _rate,        // tokens per wei
671     uint256 _ownerRate,   // owner tokens per buyer wei
672     uint256 _bonusRate,   // percentage of tokens to lockup
673     address _wallet,      // target eth wallet
674     address _tokenWallet) // target token wallet
675     Crowdsale(_startTime, _endTime, _rate, _wallet)
676    public
677   {
678     require(_cap > 0);
679     require(_tokenWallet != 0x0);
680     cap = _cap;
681     minContribution = _minWei;
682     maxContribution = _maxWei;
683     ownerRate = _ownerRate;
684     bonusRate = _bonusRate;
685     tokenWallet = _tokenWallet;
686   }
687 
688   // overriding Crowdsale#hasEnded to add cap logic
689   // @return true if crowdsale event has ended
690   function hasEnded() public constant returns (bool) {
691     bool _capReached = weiRaised >= cap;
692     return super.hasEnded() || _capReached;
693   }
694 
695   // @return true if the crowdsale has started
696   function hasStarted() public constant returns (bool) {
697     return now > startTime;
698   }
699 
700   // overriding Crowdsale#buyTokens
701   // mints the ownerRate of tokens in addition to calling the super method
702   function buyTokens(address _beneficiary) public payable {
703     // call the parent method to mint tokens to the beneficiary
704     super.buyTokens(_beneficiary);
705     // calculate the owner share of tokens
706     uint256 _ownerTokens = msg.value.mul(ownerRate);
707     // mint the owner share and send to the owner toke wallet
708     token.mint(tokenWallet, _ownerTokens);
709   }
710 
711   // immediately mint _amount tokens to the _beneficiary. this is used for OOB token purchases. 
712   function allocateTokens(address _beneficiary, uint256 _amount) onlyOwner public {
713     require(!isFinalized);
714 
715     // update state
716     uint256 _weiAmount = _amount.div(rate);
717     weiRaised = weiRaised.add(_weiAmount);
718 
719     // mint the tokens to the beneficiary
720     token.mint(_beneficiary, _amount);
721 
722     // mint the owner share tokens 
723     uint256 _ownerTokens = _weiAmount.mul(ownerRate);
724     token.mint(tokenWallet, _ownerTokens);
725     
726     TokenPurchase(msg.sender, _beneficiary, _weiAmount, _amount);
727   }
728 
729   // mints _amount tokens to the _beneficiary minus the bonusRate
730   // tokens to be locked up via the lockup contract. locked up tokens
731   // are sent to the contract and may be unlocked according to
732   // the lockup configuration after the sale ends
733   function lockupTokens(address _beneficiary, uint256 _amount) onlyOwner public {
734     require(!isFinalized);
735 
736     // calculate the owner share of tokens
737     uint256 _ownerTokens = ownerRate.mul(_amount).div(rate);
738     // mint the owner share and send to the owner wallet
739     token.mint(tokenWallet, _ownerTokens);
740 
741     // calculate the amount of tokens to be locked up
742     uint256 _lockupTokens = bonusRate.mul(_amount).div(100);
743     // create the locked allocation in the lockup contract
744     lockup.pushAllocation(_beneficiary, _lockupTokens);
745     // mint locked tokens to the crowdsale contract to later be unlocked
746     token.mint(this, _lockupTokens);
747 
748     // the non-bonus tokens are immediately rewarded
749     uint256 _remainder = _amount.sub(_lockupTokens);
750     token.mint(_beneficiary, _remainder);
751   }
752 
753   // unlocks tokens from the token lockup contract. no tokens are held by
754   // the lockup contract, just the amounts and times that tokens should be rewarded.
755   // the tokens are held by the crowdsale contract
756   function unlockTokens() onlyOwner public returns (bool _didIssueRewards) {
757     // attempt to process the interval. it update the allocation bookkeeping
758     // and will only return true when the interval should be processed
759     if (!lockup.processInterval())
760       return false;
761 
762     // the total number of allocations
763     uint _numAllocations = lockup.numAllocations();
764 
765     // for every allocation, attempt to unlock the reward
766     for (uint _i = 0; _i < _numAllocations; _i++) {
767       // attempt to unlock the reward
768       var (_shouldReward, _to, _amount) = lockup.unlock(_i);
769       // if the beneficiary should be rewarded, send them tokens
770       if (_shouldReward) {
771         token.transfer(_to, _amount);
772       }
773     }
774 
775     return true;
776   }
777 
778   // sets the authorizer contract if the crowdsale hasn't started
779   function setAuthorizer(BRDCrowdsaleAuthorizer _authorizer) onlyOwner public {
780     require(!hasStarted());
781     authorizer = _authorizer;
782   }
783 
784   // sets the lockup contract if the crowdsale hasn't started
785   function setLockup(BRDLockup _lockup) onlyOwner public {
786     require(!hasStarted());
787     lockup = _lockup;
788   }
789 
790   // sets the token contract if the crowdsale hasn't started
791   function setToken(BRDToken _token) onlyOwner public {
792     require(!hasStarted());
793     token = _token;
794   }
795 
796   // set the cap on the contract if the crowdsale hasn't started
797   function setCap(uint256 _newCap) onlyOwner public {
798     require(_newCap > 0);
799     require(!hasStarted());
800     cap = _newCap;
801   }
802 
803   // allows maxContribution to be modified
804   function setMaxContribution(uint256 _newMaxContribution) onlyOwner public {
805     maxContribution = _newMaxContribution;
806   }
807 
808   // allows endTime to be modified
809   function setEndTime(uint256 _newEndTime) onlyOwner public {
810     endTime = _newEndTime;
811   }
812 
813   // overriding Crowdsale#createTokenContract
814   function createTokenContract() internal returns (MintableToken) {
815     // set the token to null initially
816     // call setToken() above to set the actual token address
817     return BRDToken(address(0));
818   }
819 
820   // overriding FinalizableCrowdsale#finalization
821   // finalizes minting for the token contract, disabling further minting
822   function finalization() internal {
823     // end minting
824     token.finishMinting();
825 
826     // issue the first lockup reward
827     unlockTokens();
828 
829     super.finalization();
830   }
831 
832   // overriding Crowdsale#validPurchase to add extra cap logic
833   // @return true if crowdsale participants can buy at the moment
834   // checks whether the cap has not been reached, the purchaser has
835   // been authorized, and their contribution is within the min/max
836   // thresholds
837   function validPurchase() internal constant returns (bool) {
838     bool _withinCap = weiRaised.add(msg.value) <= cap;
839     bool _isAuthorized = authorizer.isAuthorized(msg.sender);
840     bool _isMin = msg.value >= minContribution;
841     uint256 _alreadyContributed = token.balanceOf(msg.sender).div(rate);
842     bool _withinMax = msg.value.add(_alreadyContributed) <= maxContribution;
843     return super.validPurchase() && _withinCap && _isAuthorized && _isMin && _withinMax;
844   }
845 }