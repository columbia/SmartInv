1 pragma solidity ^0.4.17;
2 /**
3  * @title ERC20
4  * @dev ERC20 interface
5  */
6 contract ERC20 {
7     function balanceOf(address who) public view returns (uint256);
8     function transfer(address to, uint256 value) public returns (bool);
9     function allowance(address owner, address spender) public view returns (uint256);
10     function transferFrom(address from, address to, uint256 value) public returns (bool);
11     function approve(address spender, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   function Ownable() {
28     owner = msg.sender;
29   }
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) onlyOwner public {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 }
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 contract Controlled {
74     /// @notice The address of the controller is the only address that can call
75     ///  a function with this modifier
76     modifier onlyController { require(msg.sender == controller); _; }
77     address public controller;
78     function Controlled() public { controller = msg.sender;}
79     /// @notice Changes the controller of the contract
80     /// @param _newController The new controller of the contract
81     function changeController(address _newController) public onlyController {
82         controller = _newController;
83     }
84 }
85 /**
86  * @title MiniMe interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20MiniMe is ERC20, Controlled {
90     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool);
91     function totalSupply() public view returns (uint);
92     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint);
93     function totalSupplyAt(uint _blockNumber) public view returns(uint);
94     function createCloneToken(string _cloneTokenName, uint8 _cloneDecimalUnits, string _cloneTokenSymbol, uint _snapshotBlock, bool _transfersEnabled) public returns(address);
95     function generateTokens(address _owner, uint _amount) public returns (bool);
96     function destroyTokens(address _owner, uint _amount)  public returns (bool);
97     function enableTransfers(bool _transfersEnabled) public;
98     function isContract(address _addr) internal view returns(bool);
99     function claimTokens(address _token) public;
100     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
101     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
102 }
103 /**
104  * @title Crowdsale
105  * @dev Crowdsale is a base contract for managing a token crowdsale.
106  * Crowdsales have a start and end timestamps, where investors can make
107  * token purchases and the crowdsale will assign them tokens based
108  * on a token per ETH rate. Funds collected are forwarded to a wallet
109  * as they arrive.
110  */
111 contract Crowdsale {
112   using SafeMath for uint256;
113   // The token being sold
114   ERC20MiniMe public token;
115   // start and end timestamps where investments are allowed (both inclusive)
116   uint256 public startTime;
117   uint256 public endTime;
118   // address where funds are collected
119   address public wallet;
120   // how many token units a buyer gets per wei
121   uint256 public rate;
122   // amount of raised money in wei
123   uint256 public weiRaised;
124   /**
125    * event for token purchase logging
126    * @param purchaser who paid for the tokens
127    * @param beneficiary who got the tokens
128    * @param value weis paid for purchase
129    * @param amount amount of tokens purchased
130    */
131   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
132   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
133     require(_startTime >= now);
134     require(_endTime >= _startTime);
135     require(_rate > 0);
136     require(_wallet != 0x0);
137     startTime = _startTime;
138     endTime = _endTime;
139     rate = _rate;
140     wallet = _wallet;
141   }
142   // fallback function can be used to buy tokens
143   function () payable {
144     buyTokens(msg.sender);
145   }
146   // low level token purchase function
147   function buyTokens(address beneficiary) public payable {
148     buyTokens(beneficiary, msg.value);
149   }
150   // implementation of low level token purchase function
151   function buyTokens(address beneficiary, uint256 weiAmount) internal {
152     require(beneficiary != 0x0);
153     require(validPurchase(weiAmount));
154     // update state
155     weiRaised = weiRaised.add(weiAmount);
156     transferToken(beneficiary, weiAmount);
157     forwardFunds(weiAmount);
158   }
159   // low level transfer token
160   // override to create custom token transfer mechanism, eg. pull pattern
161   function transferToken(address beneficiary, uint256 weiAmount) internal {
162     // calculate token amount to be created
163     uint256 tokens = weiAmount.mul(rate);
164     token.generateTokens(beneficiary, tokens);
165     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
166   }
167   // send ether to the fund collection wallet
168   // override to create custom fund forwarding mechanisms
169   function forwardFunds(uint256 weiAmount) internal {
170     wallet.transfer(weiAmount);
171   }
172   // @return true if the transaction can buy tokens
173   function validPurchase(uint256 weiAmount) internal view returns (bool) {
174     bool withinPeriod = now >= startTime && now <= endTime;
175     bool nonZeroPurchase = weiAmount != 0;
176     return withinPeriod && nonZeroPurchase;
177   }
178   // @return true if crowdsale event has ended
179   function hasEnded() public view returns (bool) {
180     return now > endTime;
181   }
182   // @return true if crowdsale has started
183   function hasStarted() public view returns (bool) {
184     return now >= startTime;
185   }
186 }
187 /// @dev The token controller contract must implement these functions
188 contract TokenController {
189     ERC20MiniMe public ethealToken;
190     address public SALE; // address where sale tokens are located
191     /// @notice needed for hodler handling
192     function addHodlerStake(address _beneficiary, uint _stake) public;
193     function setHodlerStake(address _beneficiary, uint256 _stake) public;
194     function setHodlerTime(uint256 _time) public;
195     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
196     /// @param _owner The address that sent the ether to create tokens
197     /// @return True if the ether is accepted, false if it throws
198     function proxyPayment(address _owner) public payable returns(bool);
199     /// @notice Notifies the controller about a token transfer allowing the
200     ///  controller to react if desired
201     /// @param _from The origin of the transfer
202     /// @param _to The destination of the transfer
203     /// @param _amount The amount of the transfer
204     /// @return False if the controller does not authorize the transfer
205     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
206     /// @notice Notifies the controller about an approval allowing the
207     ///  controller to react if desired
208     /// @param _owner The address that calls `approve()`
209     /// @param _spender The spender in the `approve()` call
210     /// @param _amount The amount in the `approve()` call
211     /// @return False if the controller does not authorize the approval
212     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
213 }
214 /**
215  * @title Pausable
216  * @dev Base contract which allows children to implement an emergency stop mechanism.
217  */
218 contract Pausable is Ownable {
219   event Pause();
220   event Unpause();
221   bool public paused = false;
222   /**
223    * @dev Modifier to make a function callable only when the contract is not paused.
224    */
225   modifier whenNotPaused() {
226     require(!paused);
227     _;
228   }
229   /**
230    * @dev Modifier to make a function callable only when the contract is paused.
231    */
232   modifier whenPaused() {
233     require(paused);
234     _;
235   }
236   /**
237    * @dev called by the owner to pause, triggers stopped state
238    */
239   function pause() onlyOwner whenNotPaused public {
240     paused = true;
241     Pause();
242   }
243   /**
244    * @dev called by the owner to unpause, returns to normal state
245    */
246   function unpause() onlyOwner whenPaused public {
247     paused = false;
248     Unpause();
249   }
250 }
251 /**
252  * @title Hodler
253  * @dev Handles hodler reward, TokenController should create and own it.
254  */
255 contract Hodler is Ownable {
256     using SafeMath for uint;
257     // HODLER reward tracker
258     // stake amount per address
259     struct HODL {
260         uint256 stake;
261         // moving ANY funds invalidates hodling of the address
262         bool invalid;
263         bool claimed3M;
264         bool claimed6M;
265         bool claimed9M;
266     }
267     mapping (address => HODL) public hodlerStakes;
268     // total current staking value and hodler addresses
269     uint256 public hodlerTotalValue;
270     uint256 public hodlerTotalCount;
271     // store dates and total stake values for 3 - 6 - 9 months after normal sale
272     uint256 public hodlerTotalValue3M;
273     uint256 public hodlerTotalValue6M;
274     uint256 public hodlerTotalValue9M;
275     uint256 public hodlerTimeStart;
276     uint256 public hodlerTime3M;
277     uint256 public hodlerTime6M;
278     uint256 public hodlerTime9M;
279     // reward HEAL token amount
280     uint256 public TOKEN_HODL_3M;
281     uint256 public TOKEN_HODL_6M;
282     uint256 public TOKEN_HODL_9M;
283     // total amount of tokens claimed so far
284     uint256 public claimedTokens;
285     
286     event LogHodlSetStake(address indexed _setter, address indexed _beneficiary, uint256 _value);
287     event LogHodlClaimed(address indexed _setter, address indexed _beneficiary, uint256 _value);
288     event LogHodlStartSet(address indexed _setter, uint256 _time);
289     /// @dev Only before hodl is started
290     modifier beforeHodlStart() {
291         if (hodlerTimeStart == 0 || now <= hodlerTimeStart)
292             _;
293     }
294     /// @dev Contructor, it should be created by a TokenController
295     function Hodler(uint256 _stake3m, uint256 _stake6m, uint256 _stake9m) {
296         TOKEN_HODL_3M = _stake3m;
297         TOKEN_HODL_6M = _stake6m;
298         TOKEN_HODL_9M = _stake9m;
299     }
300     /// @notice Adding hodler stake to an account
301     /// @dev Only owner contract can call it and before hodling period starts
302     /// @param _beneficiary Recepient address of hodler stake
303     /// @param _stake Amount of additional hodler stake
304     function addHodlerStake(address _beneficiary, uint256 _stake) public onlyOwner beforeHodlStart {
305         // real change and valid _beneficiary is needed
306         if (_stake == 0 || _beneficiary == address(0))
307             return;
308         
309         // add stake and maintain count
310         if (hodlerStakes[_beneficiary].stake == 0)
311             hodlerTotalCount = hodlerTotalCount.add(1);
312         hodlerStakes[_beneficiary].stake = hodlerStakes[_beneficiary].stake.add(_stake);
313         hodlerTotalValue = hodlerTotalValue.add(_stake);
314         LogHodlSetStake(msg.sender, _beneficiary, hodlerStakes[_beneficiary].stake);
315     }
316     /// @notice Setting hodler stake of an account
317     /// @dev Only owner contract can call it and before hodling period starts
318     /// @param _beneficiary Recepient address of hodler stake
319     /// @param _stake Amount to set the hodler stake
320     function setHodlerStake(address _beneficiary, uint256 _stake) public onlyOwner beforeHodlStart {
321         // real change and valid _beneficiary is needed
322         if (hodlerStakes[_beneficiary].stake == _stake || _beneficiary == address(0))
323             return;
324         
325         // add stake and maintain count
326         if (hodlerStakes[_beneficiary].stake == 0 && _stake > 0) {
327             hodlerTotalCount = hodlerTotalCount.add(1);
328         } else if (hodlerStakes[_beneficiary].stake > 0 && _stake == 0) {
329             hodlerTotalCount = hodlerTotalCount.sub(1);
330         }
331         uint256 _diff = _stake > hodlerStakes[_beneficiary].stake ? _stake.sub(hodlerStakes[_beneficiary].stake) : hodlerStakes[_beneficiary].stake.sub(_stake);
332         if (_stake > hodlerStakes[_beneficiary].stake) {
333             hodlerTotalValue = hodlerTotalValue.add(_diff);
334         } else {
335             hodlerTotalValue = hodlerTotalValue.sub(_diff);
336         }
337         hodlerStakes[_beneficiary].stake = _stake;
338         LogHodlSetStake(msg.sender, _beneficiary, _stake);
339     }
340     /// @notice Setting hodler start period.
341     /// @param _time The time when hodler reward starts counting
342     function setHodlerTime(uint256 _time) public onlyOwner beforeHodlStart {
343         require(_time >= now);
344         hodlerTimeStart = _time;
345         hodlerTime3M = _time.add(90 days);
346         hodlerTime6M = _time.add(180 days);
347         hodlerTime9M = _time.add(270 days);
348         LogHodlStartSet(msg.sender, _time);
349     }
350     /// @notice Invalidates hodler account 
351     /// @dev Gets called by EthealController#onTransfer before every transaction
352     function invalidate(address _account) public onlyOwner {
353         if (hodlerStakes[_account].stake > 0 && !hodlerStakes[_account].invalid) {
354             hodlerStakes[_account].invalid = true;
355             hodlerTotalValue = hodlerTotalValue.sub(hodlerStakes[_account].stake);
356             hodlerTotalCount = hodlerTotalCount.sub(1);
357         }
358         // update hodl total values "automatically" - whenever someone sends funds thus
359         updateAndGetHodlTotalValue();
360     }
361     /// @notice Claiming HODL reward for msg.sender
362     function claimHodlReward() public {
363         claimHodlRewardFor(msg.sender);
364     }
365     /// @notice Claiming HODL reward for an address
366     function claimHodlRewardFor(address _beneficiary) public {
367         // only when the address has a valid stake
368         require(hodlerStakes[_beneficiary].stake > 0 && !hodlerStakes[_beneficiary].invalid);
369         uint256 _stake = 0;
370         
371         // update hodl total values
372         updateAndGetHodlTotalValue();
373         // claim hodl if not claimed
374         if (!hodlerStakes[_beneficiary].claimed3M && now >= hodlerTime3M) {
375             _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_3M).div(hodlerTotalValue3M));
376             hodlerStakes[_beneficiary].claimed3M = true;
377         }
378         if (!hodlerStakes[_beneficiary].claimed6M && now >= hodlerTime6M) {
379             _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_6M).div(hodlerTotalValue6M));
380             hodlerStakes[_beneficiary].claimed6M = true;
381         }
382         if (!hodlerStakes[_beneficiary].claimed9M && now >= hodlerTime9M) {
383             _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_9M).div(hodlerTotalValue9M));
384             hodlerStakes[_beneficiary].claimed9M = true;
385         }
386         if (_stake > 0) {
387             // increasing claimed tokens
388             claimedTokens = claimedTokens.add(_stake);
389             // transferring tokens
390             require(TokenController(owner).ethealToken().transfer(_beneficiary, _stake));
391             // log
392             LogHodlClaimed(msg.sender, _beneficiary, _stake);
393         }
394     }
395     /// @notice claimHodlRewardFor() for multiple addresses
396     /// @dev Anyone can call this function and distribute hodl rewards
397     /// @param _beneficiaries Array of addresses for which we want to claim hodl rewards
398     function claimHodlRewardsFor(address[] _beneficiaries) external {
399         for (uint256 i = 0; i < _beneficiaries.length; i++)
400             claimHodlRewardFor(_beneficiaries[i]);
401     }
402     /// @notice Setting 3 - 6 - 9 months total staking hodl value if time is come
403     function updateAndGetHodlTotalValue() public returns (uint) {
404         if (now >= hodlerTime3M && hodlerTotalValue3M == 0) {
405             hodlerTotalValue3M = hodlerTotalValue;
406         }
407         if (now >= hodlerTime6M && hodlerTotalValue6M == 0) {
408             hodlerTotalValue6M = hodlerTotalValue;
409         }
410         if (now >= hodlerTime9M && hodlerTotalValue9M == 0) {
411             hodlerTotalValue9M = hodlerTotalValue;
412             // since we can transfer more tokens to this contract, make it possible to retain more than the predefined limit
413             TOKEN_HODL_9M = TokenController(owner).ethealToken().balanceOf(this).sub(TOKEN_HODL_3M).sub(TOKEN_HODL_6M).add(claimedTokens);
414         }
415         return hodlerTotalValue;
416     }
417 }
418 /**
419  * @title TokenVesting
420  * @dev A token holder contract that can release its token balance gradually like a
421  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
422  * owner.
423  */
424 contract TokenVesting is Ownable {
425   using SafeMath for uint256;
426   event Released(uint256 amount);
427   event Revoked();
428   // beneficiary of tokens after they are released
429   address public beneficiary;
430   uint256 public cliff;
431   uint256 public start;
432   uint256 public duration;
433   bool public revocable;
434   mapping (address => uint256) public released;
435   mapping (address => bool) public revoked;
436   /**
437    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
438    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
439    * of the balance will have vested.
440    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
441    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
442    * @param _duration duration in seconds of the period in which the tokens will vest
443    * @param _revocable whether the vesting is revocable or not
444    */
445   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) {
446     require(_beneficiary != address(0));
447     require(_cliff <= _duration);
448     beneficiary = _beneficiary;
449     revocable = _revocable;
450     duration = _duration;
451     cliff = _start.add(_cliff);
452     start = _start;
453   }
454   /**
455    * @notice Transfers vested tokens to beneficiary.
456    * @param token ERC20 token which is being vested
457    */
458   function release(ERC20MiniMe token) public {
459     uint256 unreleased = releasableAmount(token);
460     require(unreleased > 0);
461     released[token] = released[token].add(unreleased);
462     require(token.transfer(beneficiary, unreleased));
463     Released(unreleased);
464   }
465   /**
466    * @notice Allows the owner to revoke the vesting. Tokens already vested
467    * remain in the contract, the rest are returned to the owner.
468    * @param token ERC20MiniMe token which is being vested
469    */
470   function revoke(ERC20MiniMe token) public onlyOwner {
471     require(revocable);
472     require(!revoked[token]);
473     uint256 balance = token.balanceOf(this);
474     uint256 unreleased = releasableAmount(token);
475     uint256 refund = balance.sub(unreleased);
476     revoked[token] = true;
477     require(token.transfer(owner, refund));
478     Revoked();
479   }
480   /**
481    * @dev Calculates the amount that has already vested but hasn't been released yet.
482    * @param token ERC20MiniMe token which is being vested
483    */
484   function releasableAmount(ERC20MiniMe token) public view returns (uint256) {
485     return vestedAmount(token).sub(released[token]);
486   }
487   /**
488    * @dev Calculates the amount that has already vested.
489    * @param token ERC20MiniMe token which is being vested
490    */
491   function vestedAmount(ERC20MiniMe token) public view returns (uint256) {
492     uint256 currentBalance = token.balanceOf(this);
493     uint256 totalBalance = currentBalance.add(released[token]);
494     if (now < cliff) {
495       return 0;
496     } else if (now >= start.add(duration) || revoked[token]) {
497       return totalBalance;
498     } else {
499       return totalBalance.mul(now.sub(start)).div(duration);
500     }
501   }
502 }
503 /**
504  * @title claim accidentally sent tokens
505  */
506 contract HasNoTokens is Ownable {
507     event ExtractedTokens(address indexed _token, address indexed _claimer, uint _amount);
508     /// @notice This method can be used to extract mistakenly
509     ///  sent tokens to this contract.
510     /// @param _token The address of the token contract that you want to recover
511     ///  set to 0 in case you want to extract ether.
512     /// @param _claimer Address that tokens will be send to
513     function extractTokens(address _token, address _claimer) onlyOwner public {
514         if (_token == 0x0) {
515             _claimer.transfer(this.balance);
516             return;
517         }
518         ERC20 token = ERC20(_token);
519         uint balance = token.balanceOf(this);
520         token.transfer(_claimer, balance);
521         ExtractedTokens(_token, _claimer, balance);
522     }
523 }
524 /**
525  * @title EthealController
526  * @author thesved
527  * @notice Controller of the Etheal Token
528  * @dev Crowdsale can be only replaced when no active crowdsale is running.
529  *  The contract is paused by default. It has to be unpaused to enable token transfer.
530  */
531 contract EthealController is Pausable, HasNoTokens, TokenController {
532     using SafeMath for uint;
533     // when migrating this contains the address of the new controller
534     TokenController public newController;
535     // token contract
536     ERC20MiniMe public ethealToken;
537     // distribution of tokens
538     uint256 public constant ETHEAL_UNIT = 10**18;
539     uint256 public constant THOUSAND = 10**3;
540     uint256 public constant MILLION = 10**6;
541     uint256 public constant TOKEN_SALE1_PRE = 9 * MILLION * ETHEAL_UNIT;
542     uint256 public constant TOKEN_SALE1_NORMAL = 20 * MILLION * ETHEAL_UNIT;
543     uint256 public constant TOKEN_SALE2 = 9 * MILLION * ETHEAL_UNIT;
544     uint256 public constant TOKEN_SALE3 = 5 * MILLION * ETHEAL_UNIT;
545     uint256 public constant TOKEN_HODL_3M = 1 * MILLION * ETHEAL_UNIT;
546     uint256 public constant TOKEN_HODL_6M = 2 * MILLION * ETHEAL_UNIT;
547     uint256 public constant TOKEN_HODL_9M = 7 * MILLION * ETHEAL_UNIT;
548     uint256 public constant TOKEN_REFERRAL = 2 * MILLION * ETHEAL_UNIT;
549     uint256 public constant TOKEN_BOUNTY = 1500 * THOUSAND * ETHEAL_UNIT;
550     uint256 public constant TOKEN_COMMUNITY = 20 * MILLION * ETHEAL_UNIT;
551     uint256 public constant TOKEN_TEAM = 14 * MILLION * ETHEAL_UNIT;
552     uint256 public constant TOKEN_FOUNDERS = 6500 * THOUSAND * ETHEAL_UNIT;
553     uint256 public constant TOKEN_INVESTORS = 3 * MILLION * ETHEAL_UNIT;
554     // addresses only SALE will remain, the others will be real eth addresses
555     address public SALE = 0X1;
556     address public FOUNDER1 = 0x296dD2A2879fEBe2dF65f413999B28C053397fC5;
557     address public FOUNDER2 = 0x0E2feF8e4125ed0f49eD43C94b2B001C373F74Bf;
558     address public INVESTOR1 = 0xAAd27eD6c93d91aa60Dc827bE647e672d15e761A;
559     address public INVESTOR2 = 0xb906665f4ef609189A31CE55e01C267EC6293Aa5;
560     // addresses for multisig and crowdsale
561     address public ethealMultisigWallet;
562     Crowdsale public crowdsale;
563     // hodler reward contract
564     Hodler public hodlerReward;
565     // token grants
566     TokenVesting[] public tokenGrants;
567     uint256 public constant VESTING_TEAM_CLIFF = 365 days;
568     uint256 public constant VESTING_TEAM_DURATION = 4 * 365 days;
569     uint256 public constant VESTING_ADVISOR_CLIFF = 3 * 30 days;
570     uint256 public constant VESTING_ADVISOR_DURATION = 6 * 30 days;
571     /// @dev only the crowdsale can call it
572     modifier onlyCrowdsale() {
573         require(msg.sender == address(crowdsale));
574         _;
575     }
576     /// @dev only the crowdsale can call it
577     modifier onlyEthealMultisig() {
578         require(msg.sender == address(ethealMultisigWallet));
579         _;
580     }
581     ////////////////
582     // Constructor, overrides
583     ////////////////
584     /// @notice Constructor for Etheal Controller
585     function EthealController(address _wallet) {
586         require(_wallet != address(0));
587         paused = true;
588         ethealMultisigWallet = _wallet;
589     }
590     /// @dev overrides HasNoTokens#extractTokens to make it possible to extract any tokens after migration or before that any tokens except etheal
591     function extractTokens(address _token, address _claimer) onlyOwner public {
592         require(newController != address(0) || _token != address(ethealToken));
593         super.extractTokens(_token, _claimer);
594     }
595     ////////////////
596     // Manage crowdsale
597     ////////////////
598     /// @notice Set crowdsale address and transfer HEAL tokens from ethealController's SALE address
599     /// @dev Crowdsale can be only set when the current crowdsale is not active and ethealToken is set
600     function setCrowdsaleTransfer(address _sale, uint256 _amount) public onlyOwner {
601         require (_sale != address(0) && !isCrowdsaleOpen() && address(ethealToken) != address(0));
602         crowdsale = Crowdsale(_sale);
603         // transfer HEAL tokens to crowdsale account from the account of controller
604         require(ethealToken.transferFrom(SALE, _sale, _amount));
605     }
606     /// @notice Is there a not ended crowdsale?
607     /// @return true if there is no crowdsale or the current crowdsale is not yet ended but started
608     function isCrowdsaleOpen() public view returns (bool) {
609         return address(crowdsale) != address(0) && !crowdsale.hasEnded() && crowdsale.hasStarted();
610     }
611     ////////////////
612     // Manage grants
613     ////////////////
614     /// @notice Grant vesting token to an address
615     function createGrant(address _beneficiary, uint256 _start, uint256 _amount, bool _revocable, bool _advisor) public onlyOwner {
616         require(_beneficiary != address(0) && _amount > 0 && _start >= now);
617         // create token grant
618         if (_advisor) {
619             tokenGrants.push(new TokenVesting(_beneficiary, _start, VESTING_ADVISOR_CLIFF, VESTING_ADVISOR_DURATION, _revocable));
620         } else {
621             tokenGrants.push(new TokenVesting(_beneficiary, _start, VESTING_TEAM_CLIFF, VESTING_TEAM_DURATION, _revocable));
622         }
623         // transfer funds to the grant
624         transferToGrant(tokenGrants.length.sub(1), _amount);
625     }
626     /// @notice Transfer tokens to a grant until it is starting
627     function transferToGrant(uint256 _id, uint256 _amount) public onlyOwner {
628         require(_id < tokenGrants.length && _amount > 0 && now <= tokenGrants[_id].start());
629         // transfer funds to the grant
630         require(ethealToken.transfer(address(tokenGrants[_id]), _amount));
631     }
632     /// @dev Revoking grant
633     function revokeGrant(uint256 _id) public onlyOwner {
634         require(_id < tokenGrants.length);
635         tokenGrants[_id].revoke(ethealToken);
636     }
637     /// @notice Returns the token grant count
638     function getGrantCount() view public returns (uint) {
639         return tokenGrants.length;
640     }
641     ////////////////
642     // BURN, handle ownership - only multsig can call these functions!
643     ////////////////
644     /// @notice contract can burn its own or its sale tokens
645     function burn(address _where, uint256 _amount) public onlyEthealMultisig {
646         require(_where == address(this) || _where == SALE);
647         require(ethealToken.destroyTokens(_where, _amount));
648     }
649     /// @notice replaces controller when it was not yet replaced, only multisig can do it
650     function setNewController(address _controller) public onlyEthealMultisig {
651         require(_controller != address(0) && newController == address(0));
652         newController = TokenController(_controller);
653         ethealToken.changeController(_controller);
654         hodlerReward.transferOwnership(_controller);
655         // send eth
656         uint256 _stake = this.balance;
657         if (_stake > 0) {
658             _controller.transfer(_stake);
659         }
660         // send tokens
661         _stake = ethealToken.balanceOf(this);
662         if (_stake > 0) {
663             ethealToken.transfer(_controller, _stake);
664         }
665     }
666     /// @notice Set new multisig wallet, to make it upgradable.
667     function setNewMultisig(address _wallet) public onlyEthealMultisig {
668         require(_wallet != address(0));
669         ethealMultisigWallet = _wallet;
670     }
671     ////////////////
672     // When PAUSED
673     ////////////////
674     /// @notice set the token, if no hodler provided then creates a hodler reward contract
675     function setEthealToken(address _token, address _hodler) public onlyOwner whenPaused {
676         require(_token != address(0));
677         ethealToken = ERC20MiniMe(_token);
678         
679         if (_hodler != address(0)) {
680             // set hodler reward contract if provided
681             hodlerReward = Hodler(_hodler);
682         } else if (hodlerReward == address(0)) {
683             // create hodler reward contract if not yet created
684             hodlerReward = new Hodler(TOKEN_HODL_3M, TOKEN_HODL_6M, TOKEN_HODL_9M);
685         }
686         // MINT tokens if not minted yet
687         if (ethealToken.totalSupply() == 0) {
688             // sale
689             ethealToken.generateTokens(SALE, TOKEN_SALE1_PRE.add(TOKEN_SALE1_NORMAL).add(TOKEN_SALE2).add(TOKEN_SALE3));
690             // hodler reward
691             ethealToken.generateTokens(address(hodlerReward), TOKEN_HODL_3M.add(TOKEN_HODL_6M).add(TOKEN_HODL_9M));
692             // bounty + referral
693             ethealToken.generateTokens(owner, TOKEN_BOUNTY.add(TOKEN_REFERRAL));
694             // community fund
695             ethealToken.generateTokens(address(ethealMultisigWallet), TOKEN_COMMUNITY);
696             // team -> grantable
697             ethealToken.generateTokens(address(this), TOKEN_FOUNDERS.add(TOKEN_TEAM));
698             // investors
699             ethealToken.generateTokens(INVESTOR1, TOKEN_INVESTORS.div(3).mul(2));
700             ethealToken.generateTokens(INVESTOR2, TOKEN_INVESTORS.div(3));
701         }
702     }
703     ////////////////
704     // Proxy for Hodler contract
705     ////////////////
706     
707     /// @notice Proxy call for setting hodler start time
708     function setHodlerTime(uint256 _time) public onlyCrowdsale {
709         hodlerReward.setHodlerTime(_time);
710     }
711     /// @notice Proxy call for adding hodler stake
712     function addHodlerStake(address _beneficiary, uint256 _stake) public onlyCrowdsale {
713         hodlerReward.addHodlerStake(_beneficiary, _stake);
714     }
715     /// @notice Proxy call for setting hodler stake
716     function setHodlerStake(address _beneficiary, uint256 _stake) public onlyCrowdsale {
717         hodlerReward.setHodlerStake(_beneficiary, _stake);
718     }
719     ////////////////
720     // MiniMe Controller functions
721     ////////////////
722     /// @notice No eth payment to the token contract
723     function proxyPayment(address _owner) payable public returns (bool) {
724         revert();
725     }
726     /// @notice Before transfers are enabled for everyone, only this and the crowdsale contract is allowed to distribute HEAL
727     function onTransfer(address _from, address _to, uint256 _amount) public returns (bool) {
728         // moving any funds makes hodl participation invalid
729         hodlerReward.invalidate(_from);
730         return !paused || _from == address(this) || _to == address(this) || _from == address(crowdsale) || _to == address(crowdsale);
731     }
732     function onApprove(address _owner, address _spender, uint256 _amount) public returns (bool) {
733         return !paused;
734     }
735     /// @notice Retrieve mistakenly sent tokens (other than the etheal token) from the token contract 
736     function claimTokenTokens(address _token) public onlyOwner {
737         require(_token != address(ethealToken));
738         ethealToken.claimTokens(_token);
739     }
740 }