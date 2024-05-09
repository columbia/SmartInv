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
47 contract Controlled {
48     /// @notice The address of the controller is the only address that can call
49     ///  a function with this modifier
50     modifier onlyController { require(msg.sender == controller); _; }
51     address public controller;
52     function Controlled() public { controller = msg.sender;}
53     /// @notice Changes the controller of the contract
54     /// @param _newController The new controller of the contract
55     function changeController(address _newController) public onlyController {
56         controller = _newController;
57     }
58 }
59 /**
60  * @title MiniMe interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20MiniMe is ERC20, Controlled {
64     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool);
65     function totalSupply() public view returns (uint);
66     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint);
67     function totalSupplyAt(uint _blockNumber) public view returns(uint);
68     function createCloneToken(string _cloneTokenName, uint8 _cloneDecimalUnits, string _cloneTokenSymbol, uint _snapshotBlock, bool _transfersEnabled) public returns(address);
69     function generateTokens(address _owner, uint _amount) public returns (bool);
70     function destroyTokens(address _owner, uint _amount)  public returns (bool);
71     function enableTransfers(bool _transfersEnabled) public;
72     function isContract(address _addr) internal view returns(bool);
73     function claimTokens(address _token) public;
74     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
75     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
76 }
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that throw on error
80  */
81 library SafeMath {
82   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a * b;
84     assert(a == 0 || c / a == b);
85     return c;
86   }
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     assert(c >= a);
100     return c;
101   }
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
187 /**
188  * @title CappedCrowdsale
189  * @dev Extension of Crowdsale with a max amount of funds raised
190  */
191 contract CappedCrowdsale is Crowdsale {
192   using SafeMath for uint256;
193   uint256 public cap;
194   function CappedCrowdsale(uint256 _cap) {
195     require(_cap > 0);
196     cap = _cap;
197   }
198   // overriding Crowdsale#validPurchase to add extra cap logic
199   // @return true if investors can buy at the moment
200   function validPurchase(uint256 weiAmount) internal view returns (bool) {
201     return super.validPurchase(weiAmount) && !capReached();
202   }
203   // overriding Crowdsale#hasEnded to add cap logic
204   // @return true if crowdsale event has ended
205   function hasEnded() public view returns (bool) {
206     return super.hasEnded() || capReached();
207   }
208   // @return true if cap has been reached
209   function capReached() internal view returns (bool) {
210    return weiRaised >= cap;
211   }
212   // overriding Crowdsale#buyTokens to add partial refund logic
213   function buyTokens(address beneficiary) public payable {
214      uint256 weiToCap = cap.sub(weiRaised);
215      uint256 weiAmount = weiToCap < msg.value ? weiToCap : msg.value;
216      buyTokens(beneficiary, weiAmount);
217      uint256 refund = msg.value.sub(weiAmount);
218      if (refund > 0) {
219        msg.sender.transfer(refund);
220      }
221    }
222 }
223 /**
224  * @title FinalizableCrowdsale
225  * @dev Extension of Crowdsale where an owner can do extra work
226  * after finishing.
227  */
228 contract FinalizableCrowdsale is Crowdsale, Ownable {
229   using SafeMath for uint256;
230   bool public isFinalized = false;
231   event Finalized();
232   /**
233    * @dev Must be called after crowdsale ends, to do some extra finalization
234    * work. Calls the contract's finalization function.
235    */
236   function finalize() onlyOwner public {
237     require(!isFinalized);
238     require(hasEnded());
239     finalization();
240     Finalized();
241     isFinalized = true;
242   }
243   /**
244    * @dev Can be overridden to add finalization logic. The overriding function
245    * should call super.finalization() to ensure the chain of finalization is
246    * executed entirely.
247    */
248   function finalization() internal {
249   }
250 }
251 /**
252  * @title claim accidentally sent tokens
253  */
254 contract HasNoTokens is Ownable {
255     event ExtractedTokens(address indexed _token, address indexed _claimer, uint _amount);
256     /// @notice This method can be used to extract mistakenly
257     ///  sent tokens to this contract.
258     /// @param _token The address of the token contract that you want to recover
259     ///  set to 0 in case you want to extract ether.
260     /// @param _claimer Address that tokens will be send to
261     function extractTokens(address _token, address _claimer) onlyOwner public {
262         if (_token == 0x0) {
263             _claimer.transfer(this.balance);
264             return;
265         }
266         ERC20 token = ERC20(_token);
267         uint balance = token.balanceOf(this);
268         token.transfer(_claimer, balance);
269         ExtractedTokens(_token, _claimer, balance);
270     }
271 }
272 /**
273  * @title RefundVault
274  * @dev This contract is used for storing funds while a crowdsale
275  * is in progress. Supports refunding the money if crowdsale fails,
276  * and forwarding it if crowdsale is successful.
277  */
278 contract RefundVault is Ownable, HasNoTokens {
279   using SafeMath for uint256;
280   enum State { Active, Refunding, Closed }
281   mapping (address => uint256) public deposited;
282   address public wallet;
283   State public state;
284   event Closed();
285   event RefundsEnabled();
286   event Refunded(address indexed beneficiary, uint256 weiAmount);
287   function RefundVault(address _wallet) {
288     require(_wallet != 0x0);
289     wallet = _wallet;
290     state = State.Active;
291   }
292   function deposit(address investor) onlyOwner public payable {
293     require(state == State.Active);
294     deposited[investor] = deposited[investor].add(msg.value);
295   }
296   function close() onlyOwner public {
297     require(state == State.Active);
298     state = State.Closed;
299     Closed();
300     wallet.transfer(this.balance);
301   }
302   function enableRefunds() onlyOwner public {
303     require(state == State.Active);
304     state = State.Refunding;
305     RefundsEnabled();
306   }
307   function refund(address investor) public {
308     require(state == State.Refunding);
309     uint256 depositedValue = deposited[investor];
310     deposited[investor] = 0;
311     investor.transfer(depositedValue);
312     Refunded(investor, depositedValue);
313   }
314 }
315 /**
316  * @title RefundableCrowdsale
317  * @dev Extension of Crowdsale contract that adds a funding goal, and
318  * the possibility of users getting a refund if goal is not met.
319  * Uses a RefundVault as the crowdsale's vault.
320  */
321 contract RefundableCrowdsale is FinalizableCrowdsale {
322   using SafeMath for uint256;
323   // minimum amount of funds to be raised in weis
324   uint256 public goal;
325   // refund vault used to hold funds while crowdsale is running
326   RefundVault public vault;
327   function RefundableCrowdsale(uint256 _goal) {
328     require(_goal > 0);
329     vault = new RefundVault(wallet);
330     goal = _goal;
331   }
332   // We're overriding the fund forwarding from Crowdsale.
333   // If the goal is reached forward the fund to the wallet, 
334   // otherwise in addition to sending the funds, we want to
335   // call the RefundVault deposit function
336   function forwardFunds(uint256 weiAmount) internal {
337     if (goalReached())
338       wallet.transfer(weiAmount);
339     else
340       vault.deposit.value(weiAmount)(msg.sender);
341   }
342   // if crowdsale is unsuccessful, investors can claim refunds here
343   function claimRefund() public {
344     require(isFinalized);
345     require(!goalReached());
346     vault.refund(msg.sender);
347   }
348   // vault finalization task, called when owner calls finalize()
349   function finalization() internal {
350     if (goalReached()) {
351       vault.close();
352     } else {
353       vault.enableRefunds();
354     }
355     super.finalization();
356   }
357   function goalReached() public view returns (bool) {
358     return weiRaised >= goal;
359   }
360 }
361 /// @dev The token controller contract must implement these functions
362 contract TokenController {
363     ERC20MiniMe public ethealToken;
364     address public SALE; // address where sale tokens are located
365     /// @notice needed for hodler handling
366     function addHodlerStake(address _beneficiary, uint _stake) public;
367     function setHodlerStake(address _beneficiary, uint256 _stake) public;
368     function setHodlerTime(uint256 _time) public;
369     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
370     /// @param _owner The address that sent the ether to create tokens
371     /// @return True if the ether is accepted, false if it throws
372     function proxyPayment(address _owner) public payable returns(bool);
373     /// @notice Notifies the controller about a token transfer allowing the
374     ///  controller to react if desired
375     /// @param _from The origin of the transfer
376     /// @param _to The destination of the transfer
377     /// @param _amount The amount of the transfer
378     /// @return False if the controller does not authorize the transfer
379     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
380     /// @notice Notifies the controller about an approval allowing the
381     ///  controller to react if desired
382     /// @param _owner The address that calls `approve()`
383     /// @param _spender The spender in the `approve()` call
384     /// @param _amount The amount in the `approve()` call
385     /// @return False if the controller does not authorize the approval
386     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
387 }
388 /**
389  * @title Pausable
390  * @dev Base contract which allows children to implement an emergency stop mechanism.
391  */
392 contract Pausable is Ownable {
393   event Pause();
394   event Unpause();
395   bool public paused = false;
396   /**
397    * @dev Modifier to make a function callable only when the contract is not paused.
398    */
399   modifier whenNotPaused() {
400     require(!paused);
401     _;
402   }
403   /**
404    * @dev Modifier to make a function callable only when the contract is paused.
405    */
406   modifier whenPaused() {
407     require(paused);
408     _;
409   }
410   /**
411    * @dev called by the owner to pause, triggers stopped state
412    */
413   function pause() onlyOwner whenNotPaused public {
414     paused = true;
415     Pause();
416   }
417   /**
418    * @dev called by the owner to unpause, returns to normal state
419    */
420   function unpause() onlyOwner whenPaused public {
421     paused = false;
422     Unpause();
423   }
424 }
425 /**
426  * @title EthealPreSale
427  * @author thesved
428  * @notice Etheal Token Sale round one presale contract, with mincap (goal), softcap and hardcap (cap)
429  * @dev This contract has to be finalized before refund or token claims are enabled
430  */
431 contract EthealPreSale is Pausable, CappedCrowdsale, RefundableCrowdsale {
432     // the token is here
433     TokenController public ethealController;
434     // after reaching {weiRaised} >= {softCap}, there is {softCapTime} seconds until the sale closes
435     // {softCapClose} contains the closing time
436     uint256 public rate = 1250;
437     uint256 public goal = 333 ether;
438     uint256 public softCap = 3600 ether;
439     uint256 public softCapTime = 120 hours;
440     uint256 public softCapClose;
441     uint256 public cap = 7200 ether;
442     // how many token is sold and not claimed, used for refunding to token controller
443     uint256 public tokenBalance;
444     // total token sold
445     uint256 public tokenSold;
446     // contributing above {maxGasPrice} results in 
447     // calculating stakes on {maxGasPricePenalty} / 100
448     // eg. 80 {maxGasPricePenalty} means 80%, sending 5 ETH with more than 100gwei gas price will be calculated as 4 ETH
449     uint256 public maxGasPrice = 100 * 10**9;
450     uint256 public maxGasPricePenalty = 80;
451     // minimum contribution, 0.1ETH
452     uint256 public minContribution = 0.1 ether;
453     // first {whitelistDayCount} days of token sale is exclusive for whitelisted addresses
454     // {whitelistDayMaxStake} contains the max stake limits per address for each whitelist sales day
455     // {whitelist} contains who can contribute during whitelist period
456     uint8 public whitelistDayCount;
457     mapping (address => bool) public whitelist;
458     mapping (uint8 => uint256) public whitelistDayMaxStake;
459     
460     // stakes contains contribution stake in wei
461     // contributed ETH is calculated on 80% when sending funds with gasprice above maxGasPrice
462     mapping (address => uint256) public stakes;
463     // addresses of contributors to handle finalization after token sale end (refunds or token claims)
464     address[] public contributorsKeys; 
465     // events for token purchase during sale and claiming tokens after sale
466     event TokenClaimed(address indexed _claimer, address indexed _beneficiary, uint256 _stake, uint256 _amount);
467     event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _stake, uint256 _amount, uint256 _participants, uint256 _weiRaised);
468     event TokenGoalReached();
469     event TokenSoftCapReached(uint256 _closeTime);
470     // whitelist events for adding days with maximum stakes and addresses
471     event WhitelistAddressAdded(address indexed _whitelister, address indexed _beneficiary);
472     event WhitelistAddressRemoved(address indexed _whitelister, address indexed _beneficiary);
473     event WhitelistSetDay(address indexed _whitelister, uint8 _day, uint256 _maxStake);
474     ////////////////
475     // Constructor and inherited function overrides
476     ////////////////
477     /// @notice Constructor to create PreSale contract
478     /// @param _ethealController Address of ethealController
479     /// @param _startTime The start time of token sale in seconds.
480     /// @param _endTime The end time of token sale in seconds.
481     /// @param _minContribution The minimum contribution per transaction in wei (0.1 ETH)
482     /// @param _rate Number of HEAL tokens per 1 ETH
483     /// @param _goal Minimum funding in wei, below that EVERYONE gets back ALL their
484     ///  contributions regardless of maxGasPrice penalty. 
485     ///  Eg. someone contributes with 5 ETH, but gets only 4 ETH stakes because
486     ///  sending funds with gasprice over 100Gwei, he will still get back >>5 ETH<<
487     ///  in case of unsuccessful token sale
488     /// @param _softCap Softcap in wei, reaching it ends the sale in _softCapTime seconds
489     /// @param _softCapTime Seconds until the sale remains open after reaching _softCap
490     /// @param _cap Maximum cap in wei, we can't raise more funds
491     /// @param _gasPrice Maximum gas price
492     /// @param _gasPenalty Penalty in percentage points for calculating stakes, eg. 80 means calculating 
493     ///  stakes on 80% if gasprice was higher than _gasPrice
494     /// @param _wallet Address of multisig wallet, which will get all the funds after successful sale
495     function EthealPreSale(
496         address _ethealController,
497         uint256 _startTime, 
498         uint256 _endTime, 
499         uint256 _minContribution, 
500         uint256 _rate, 
501         uint256 _goal, 
502         uint256 _softCap, 
503         uint256 _softCapTime, 
504         uint256 _cap, 
505         uint256 _gasPrice, 
506         uint256 _gasPenalty, 
507         address _wallet
508     )
509         CappedCrowdsale(_cap)
510         FinalizableCrowdsale()
511         RefundableCrowdsale(_goal)
512         Crowdsale(_startTime, _endTime, _rate, _wallet)
513     {
514         // ethealController must be valid
515         require(_ethealController != address(0));
516         ethealController = TokenController(_ethealController);
517         // caps have to be consistent with each other
518         require(_goal <= _softCap && _softCap <= _cap);
519         softCap = _softCap;
520         softCapTime = _softCapTime;
521         // this is needed since super constructor wont overwite overriden variables
522         cap = _cap;
523         goal = _goal;
524         rate = _rate;
525         maxGasPrice = _gasPrice;
526         maxGasPricePenalty = _gasPenalty;
527         minContribution = _minContribution;
528     }
529     /// @dev Overriding Crowdsale#buyTokens to add partial refund and softcap logic 
530     /// @param _beneficiary Beneficiary of the token purchase
531     function buyTokens(address _beneficiary) public payable whenNotPaused {
532         require(_beneficiary != address(0));
533         uint256 weiToCap = howMuchCanXContributeNow(_beneficiary);
534         uint256 weiAmount = uint256Min(weiToCap, msg.value);
535         // goal is reached
536         if (weiRaised < goal && weiRaised.add(weiAmount) >= goal) {
537             TokenGoalReached();
538         }
539         // call the Crowdsale#buyTokens internal function
540         buyTokens(_beneficiary, weiAmount);
541         // close sale in softCapTime seconds after reaching softCap
542         if (weiRaised >= softCap && softCapClose == 0) {
543             softCapClose = now.add(softCapTime);
544             TokenSoftCapReached(uint256Min(softCapClose, endTime));
545         }
546         // handle refund
547         uint256 refund = msg.value.sub(weiAmount);
548         if (refund > 0) {
549             msg.sender.transfer(refund);
550         }
551     }
552     /// @dev Overriding Crowdsale#transferToken, which keeps track of contributions DURING token sale
553     /// @param _beneficiary Address of the recepient of the tokens
554     /// @param _weiAmount Contribution in wei
555     function transferToken(address _beneficiary, uint256 _weiAmount) internal {
556         require(_beneficiary != address(0));
557         uint256 weiAmount = _weiAmount;
558         // check maxGasPricePenalty
559         if (maxGasPrice > 0 && tx.gasprice > maxGasPrice) {
560             weiAmount = weiAmount.mul(maxGasPricePenalty).div(100);
561         }
562         // calculate tokens, so we can refund excess tokens to EthealController after token sale
563         uint256 tokens = weiAmount.mul(rate);
564         tokenBalance = tokenBalance.add(tokens);
565         if (stakes[_beneficiary] == 0) {
566             contributorsKeys.push(_beneficiary);
567         }
568         stakes[_beneficiary] = stakes[_beneficiary].add(weiAmount);
569         TokenPurchase(msg.sender, _beneficiary, _weiAmount, weiAmount, tokens, contributorsKeys.length, weiRaised);
570     }
571     /// @dev Overriding Crowdsale#validPurchase to add min contribution logic
572     /// @param _weiAmount Contribution amount in wei
573     /// @return true if contribution is okay
574     function validPurchase(uint256 _weiAmount) internal view returns (bool) {
575         return super.validPurchase(_weiAmount) && _weiAmount >= minContribution;
576     }
577     /// @dev Overriding Crowdsale#hasEnded to add soft cap logic
578     /// @return true if crowdsale event has ended or a softCapClose time is set and passed
579     function hasEnded() public view returns (bool) {
580         return super.hasEnded() || softCapClose > 0 && now > softCapClose;
581     }
582     /// @dev Overriding RefundableCrowdsale#claimRefund to enable anyone to call for any address
583     ///  which enables us to refund anyone and also anyone can refund themselves
584     function claimRefund() public {
585         claimRefundFor(msg.sender);
586     }
587     /// @dev Extending RefundableCrowdsale#finalization sending back excess tokens to ethealController
588     function finalization() internal {
589         uint256 _balance = getHealBalance();
590         // if token sale was successful send back excess funds
591         if (goalReached()) {
592             // saving token balance for future reference
593             tokenSold = tokenBalance; 
594             // send back the excess token to ethealController
595             if (_balance > tokenBalance) {
596                 ethealController.ethealToken().transfer(ethealController.SALE(), _balance.sub(tokenBalance));
597             }
598         } else if (!goalReached() && _balance > 0) {
599             // if token sale is failed, then send back all tokens to ethealController's sale address
600             tokenBalance = 0;
601             ethealController.ethealToken().transfer(ethealController.SALE(), _balance);
602         }
603         super.finalization();
604     }
605     ////////////////
606     // BEFORE token sale
607     ////////////////
608     /// @notice Modifier for before sale cases
609     modifier beforeSale() {
610         require(!hasStarted());
611         _;
612     }
613     /// @notice Sets whitelist
614     /// @dev The length of _whitelistLimits says that the first X days of token sale is 
615     ///  closed, meaning only for whitelisted addresses.
616     /// @param _add Array of addresses to add to whitelisted ethereum accounts
617     /// @param _remove Array of addresses to remove to whitelisted ethereum accounts
618     /// @param _whitelistLimits Array of limits in wei, where _whitelistLimits[0] = 10 ETH means
619     ///  whitelisted addresses can contribute maximum 10 ETH stakes on the first day
620     ///  After _whitelistLimits.length days, there will be no limits per address (besides hard cap)
621     function setWhitelist(address[] _add, address[] _remove, uint256[] _whitelistLimits) public onlyOwner beforeSale {
622         uint256 i = 0;
623         uint8 j = 0; // access max daily stakes
624         // we override whiteListLimits only if it was supplied as an argument
625         if (_whitelistLimits.length > 0) {
626             // saving whitelist max stake limits for each day -> uint256 maxStakeLimit
627             whitelistDayCount = uint8(_whitelistLimits.length);
628             for (i = 0; i < _whitelistLimits.length; i++) {
629                 j = uint8(i.add(1));
630                 if (whitelistDayMaxStake[j] != _whitelistLimits[i]) {
631                     whitelistDayMaxStake[j] = _whitelistLimits[i];
632                     WhitelistSetDay(msg.sender, j, _whitelistLimits[i]);
633                 }
634             }
635         }
636         // adding whitelist addresses
637         for (i = 0; i < _add.length; i++) {
638             require(_add[i] != address(0));
639             
640             if (!whitelist[_add[i]]) {
641                 whitelist[_add[i]] = true;
642                 WhitelistAddressAdded(msg.sender, _add[i]);
643             }
644         }
645         // removing whitelist addresses
646         for (i = 0; i < _remove.length; i++) {
647             require(_remove[i] != address(0));
648             
649             if (whitelist[_remove[i]]) {
650                 whitelist[_remove[i]] = false;
651                 WhitelistAddressRemoved(msg.sender, _remove[i]);
652             }
653         }
654     }
655     /// @notice Sets max gas price and penalty before sale
656     function setMaxGas(uint256 _maxGas, uint256 _penalty) public onlyOwner beforeSale {
657         maxGasPrice = _maxGas;
658         maxGasPricePenalty = _penalty;
659     }
660     /// @notice Sets min contribution before sale
661     function setMinContribution(uint256 _minContribution) public onlyOwner beforeSale {
662         minContribution = _minContribution;
663     }
664     /// @notice Sets minimum goal, soft cap and max cap
665     function setCaps(uint256 _goal, uint256 _softCap, uint256 _softCapTime, uint256 _cap) public onlyOwner beforeSale {
666         require(0 < _goal && _goal <= _softCap && _softCap <= _cap);
667         goal = _goal;
668         softCap = _softCap;
669         softCapTime = _softCapTime;
670         cap = _cap;
671     }
672     /// @notice Sets crowdsale start and end time
673     function setTimes(uint256 _startTime, uint256 _endTime) public onlyOwner beforeSale {
674         require(_startTime > now && _startTime < _endTime);
675         startTime = _startTime;
676         endTime = _endTime;
677     }
678     /// @notice Set rate
679     function setRate(uint256 _rate) public onlyOwner beforeSale {
680         require(_rate > 0);
681         rate = _rate;
682     }
683     ////////////////
684     // AFTER token sale
685     ////////////////
686     /// @notice Modifier for cases where sale is failed
687     /// @dev It checks whether we haven't reach the minimum goal AND whether the contract is finalized
688     modifier afterSaleFail() {
689         require(!goalReached() && isFinalized);
690         _;
691     }
692     /// @notice Modifier for cases where sale is closed and was successful.
693     /// @dev It checks whether
694     ///  the sale has ended 
695     ///  and we have reached our goal
696     ///  AND whether the contract is finalized
697     modifier afterSaleSuccess() {
698         require(goalReached() && isFinalized);
699         _;
700     }
701     /// @notice Modifier for after sale finalization
702     modifier afterSale() {
703         require(isFinalized);
704         _;
705     }
706     
707     /// @notice Refund an ethereum address
708     /// @param _beneficiary Address we want to refund
709     function claimRefundFor(address _beneficiary) public afterSaleFail whenNotPaused {
710         require(_beneficiary != address(0));
711         vault.refund(_beneficiary);
712     }
713     /// @notice Refund several addresses with one call
714     /// @param _beneficiaries Array of addresses we want to refund
715     function claimRefundsFor(address[] _beneficiaries) external afterSaleFail {
716         for (uint256 i = 0; i < _beneficiaries.length; i++) {
717             claimRefundFor(_beneficiaries[i]);
718         }
719     }
720     /// @notice Claim token for msg.sender after token sale based on stake.
721     function claimToken() public afterSaleSuccess {
722         claimTokenFor(msg.sender);
723     }
724     /// @notice Claim token after token sale based on stake.
725     /// @dev Anyone can call this function and distribute tokens after successful token sale
726     /// @param _beneficiary Address of the beneficiary who gets the token
727     function claimTokenFor(address _beneficiary) public afterSaleSuccess whenNotPaused {
728         uint256 stake = stakes[_beneficiary];
729         require(stake > 0);
730         // set the stake 0 for beneficiary
731         stakes[_beneficiary] = 0;
732         // calculate token count
733         uint256 tokens = stake.mul(rate);
734         // decrease tokenBalance, to make it possible to withdraw excess HEAL funds
735         tokenBalance = tokenBalance.sub(tokens);
736         // distribute hodlr stake
737         ethealController.addHodlerStake(_beneficiary, tokens.mul(2));
738         // distribute token
739         require(ethealController.ethealToken().transfer(_beneficiary, tokens));
740         TokenClaimed(msg.sender, _beneficiary, stake, tokens);
741     }
742     /// @notice claimToken() for multiple addresses
743     /// @dev Anyone can call this function and distribute tokens after successful token sale
744     /// @param _beneficiaries Array of addresses for which we want to claim tokens
745     function claimTokensFor(address[] _beneficiaries) external afterSaleSuccess {
746         for (uint256 i = 0; i < _beneficiaries.length; i++) {
747             claimTokenFor(_beneficiaries[i]);
748         }
749     }
750     /// @notice Get back accidentally sent token from the vault
751     function extractVaultTokens(address _token, address _claimer) public onlyOwner afterSale {
752         // it has to have a valid claimer, and either the goal has to be reached or the token can be 0 which means we can't extract ether if the goal is not reached
753         require(_claimer != address(0));
754         require(goalReached() || _token != address(0));
755         vault.extractTokens(_token, _claimer);
756     }
757     ////////////////
758     // Constant, helper functions
759     ////////////////
760     /// @notice How many wei can the msg.sender contribute now.
761     function howMuchCanIContributeNow() view public returns (uint256) {
762         return howMuchCanXContributeNow(msg.sender);
763     }
764     /// @notice How many wei can an ethereum address contribute now.
765     /// @dev This function can return 0 when the crowdsale is stopped
766     ///  or the address has maxed the current day's whitelist cap,
767     ///  it is possible, that next day he can contribute
768     /// @param _beneficiary Ethereum address
769     /// @return Number of wei the _beneficiary can contribute now.
770     function howMuchCanXContributeNow(address _beneficiary) view public returns (uint256) {
771         require(_beneficiary != address(0));
772         if (!hasStarted() || hasEnded()) {
773             return 0;
774         }
775         // wei to hard cap
776         uint256 weiToCap = cap.sub(weiRaised);
777         // if this is a whitelist limited period
778         uint8 _saleDay = getSaleDayNow();
779         if (_saleDay <= whitelistDayCount) {
780             // address can't contribute if
781             //  it is not whitelisted
782             if (!whitelist[_beneficiary]) {
783                 return 0;
784             }
785             // personal cap is the daily whitelist limit minus the stakes the address already has
786             uint256 weiToPersonalCap = whitelistDayMaxStake[_saleDay].sub(stakes[_beneficiary]);
787             // calculate for maxGasPrice penalty
788             if (msg.value > 0 && maxGasPrice > 0 && tx.gasprice > maxGasPrice) {
789                 weiToPersonalCap = weiToPersonalCap.mul(100).div(maxGasPricePenalty);
790             }
791             weiToCap = uint256Min(weiToCap, weiToPersonalCap);
792         }
793         return weiToCap;
794     }
795     /// @notice For a give date how many 24 hour blocks have ellapsed since token sale start
796     /// @dev _time has to be bigger than the startTime of token sale, otherwise SafeMath's div will throw.
797     ///  Within 24 hours of token sale it will return 1, 
798     ///  between 24 and 48 hours it will return 2, etc.
799     /// @param _time Date in seconds for which we want to know which sale day it is
800     /// @return Number of 24 hour blocks ellapsing since token sale start starting from 1
801     function getSaleDay(uint256 _time) view public returns (uint8) {
802         return uint8(_time.sub(startTime).div(60*60*24).add(1));
803     }
804     /// @notice How many 24 hour blocks have ellapsed since token sale start
805     /// @return Number of 24 hour blocks ellapsing since token sale start starting from 1
806     function getSaleDayNow() view public returns (uint8) {
807         return getSaleDay(now);
808     }
809     /// @notice Minimum between two uint8 numbers
810     function uint8Min(uint8 a, uint8 b) pure internal returns (uint8) {
811         return a > b ? b : a;
812     }
813     /// @notice Minimum between two uint256 numbers
814     function uint256Min(uint256 a, uint256 b) pure internal returns (uint256) {
815         return a > b ? b : a;
816     }
817     ////////////////
818     // Test and contribution web app, NO audit is needed
819     ////////////////
820     /// @notice Was this token sale successful?
821     /// @return true if the sale is over and we have reached the minimum goal
822     function wasSuccess() view public returns (bool) {
823         return hasEnded() && goalReached();
824     }
825     /// @notice How many contributors we have.
826     /// @return Number of different contributor ethereum addresses
827     function getContributorsCount() view public returns (uint256) {
828         return contributorsKeys.length;
829     }
830     /// @notice Get contributor addresses to manage refunds or token claims.
831     /// @dev If the sale is not yet successful, then it searches in the RefundVault.
832     ///  If the sale is successful, it searches in contributors.
833     /// @param _pending If true, then returns addresses which didn't get refunded or their tokens distributed to them
834     /// @param _claimed If true, then returns already refunded or token distributed addresses
835     /// @return Array of addresses of contributors
836     function getContributors(bool _pending, bool _claimed) view public returns (address[] contributors) {
837         uint256 i = 0;
838         uint256 results = 0;
839         address[] memory _contributors = new address[](contributorsKeys.length);
840         // if we have reached our goal, then search in contributors, since this is what we want to monitor
841         if (goalReached()) {
842             for (i = 0; i < contributorsKeys.length; i++) {
843                 if (_pending && stakes[contributorsKeys[i]] > 0 || _claimed && stakes[contributorsKeys[i]] == 0) {
844                     _contributors[results] = contributorsKeys[i];
845                     results++;
846                 }
847             }
848         } else {
849             // otherwise search in the refund vault
850             for (i = 0; i < contributorsKeys.length; i++) {
851                 if (_pending && vault.deposited(contributorsKeys[i]) > 0 || _claimed && vault.deposited(contributorsKeys[i]) == 0) {
852                     _contributors[results] = contributorsKeys[i];
853                     results++;
854                 }
855             }
856         }
857         contributors = new address[](results);
858         for (i = 0; i < results; i++) {
859             contributors[i] = _contributors[i];
860         }
861         return contributors;
862     }
863     /// @notice How many HEAL tokens do this contract have
864     function getHealBalance() view public returns (uint256) {
865         return ethealController.ethealToken().balanceOf(address(this));
866     }
867     
868     
869     /// @notice Get current date for web3
870     function getNow() view public returns (uint256) {
871         return now;
872     }
873 }