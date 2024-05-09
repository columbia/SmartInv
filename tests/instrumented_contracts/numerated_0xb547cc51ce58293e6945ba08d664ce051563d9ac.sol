1 pragma solidity ^0.4.13;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   function Ownable() {
59     owner = msg.sender;
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) onlyOwner public {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract Pausable is Ownable {
85   event Pause();
86   event Unpause();
87 
88   bool public paused = false;
89 
90 
91   /**
92    * @dev Modifier to make a function callable only when the contract is not paused.
93    */
94   modifier whenNotPaused() {
95     require(!paused);
96     _;
97   }
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is paused.
101    */
102   modifier whenPaused() {
103     require(paused);
104     _;
105   }
106 
107   /**
108    * @dev called by the owner to pause, triggers stopped state
109    */
110   function pause() onlyOwner whenNotPaused public {
111     paused = true;
112     Pause();
113   }
114 
115   /**
116    * @dev called by the owner to unpause, returns to normal state
117    */
118   function unpause() onlyOwner whenPaused public {
119     paused = false;
120     Unpause();
121   }
122 }
123 
124 contract Configurable is Ownable {
125   // Event triggered when the contract has been configured by the owner
126   event Configured();
127 
128   bool public configured = false;
129 
130   // @dev Finalize configuration, prohibiting further configuration
131   function finishConfiguration() public configuration returns (bool) {
132     configured = true;
133     Configured();
134     return true;
135   }
136 
137   // @dev Enforce that a function is an owner-only configuration method.
138   //   Intentionally duplicates the `onlyOwner` check so that we can't
139   //   accidentally create a configuration option that without the owner modifier.
140   //   This modifier will not let a function be called if the `finalizeConfiguration`
141   //   has been called.
142   modifier configuration() {
143     require(msg.sender == owner);
144     require(!configured);
145     _;
146   }
147 
148   modifier onlyAfterConfiguration() {
149     require(configured);
150     _;
151   }
152 }
153 
154 contract Crowdsale {
155   using SafeMath for uint256;
156 
157   // start and end timestamps where investments are allowed (both inclusive)
158   uint256 public startTime;
159   uint256 public endTime;
160 
161   // address where funds are collected
162   address public wallet;
163 
164   // how many token units a buyer gets per wei
165   uint256 public rate;
166 
167   // amount of raised money in wei
168   uint256 public weiRaised;
169 
170   /**
171    * event for token purchase logging
172    * @param purchaser who paid for the tokens
173    * @param beneficiary who got the tokens
174    * @param value weis paid for purchase
175    * @param amount amount of tokens purchased
176    */
177   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
178 
179   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
180     require(_startTime >= now); // solhint-disable not-rely-on-time
181     require(_endTime >= _startTime);
182     require(_rate > 0);
183     require(_wallet != 0x0);
184 
185     startTime = _startTime;
186     endTime = _endTime;
187     rate = _rate;
188     wallet = _wallet;
189   }
190 
191   // fallback function can be used to buy tokens
192   function () public payable {
193     proxyPayment(msg.sender);
194   }
195 
196   // Make a payment for the provided address
197   //
198   // @param _owner address that will own the purchased tokens
199   function proxyPayment(address _owner) public payable returns(bool);
200 
201   // @return true if crowdsale event has ended
202   function hasEnded() public constant returns (bool) {
203     return now > endTime;
204   }
205 
206   // send ether to the fund collection wallet
207   // override to create custom fund forwarding mechanisms
208   function forwardFunds() internal {
209     wallet.transfer(msg.value);
210   }
211 
212   // @return true if the transaction can buy tokens
213   function validPurchase() internal constant returns (bool) {
214     bool withinPeriod = now >= startTime && now <= endTime;
215     bool nonZeroPurchase = msg.value != 0;
216     return withinPeriod && nonZeroPurchase;
217   }
218 }
219 
220 contract CappedCrowdsale is Crowdsale {
221   using SafeMath for uint256;
222 
223   uint256 public cap;
224 
225   function CappedCrowdsale(uint256 _cap) public {
226     require(_cap > 0);
227     cap = _cap;
228   }
229 
230   // overriding Crowdsale#hasEnded to add cap logic
231   // @return true if crowdsale event has ended
232   function hasEnded() public constant returns (bool) {
233     bool capReached = weiRaised >= cap;
234     return super.hasEnded() || capReached;
235   }
236 
237   // overriding Crowdsale#validPurchase to add extra cap logic
238   // @return true if investors can buy at the moment
239   function validPurchase() internal constant returns (bool) {
240     bool withinCap = weiRaised.add(msg.value) <= cap;
241     return super.validPurchase() && withinCap;
242   }
243 
244 }
245 
246 contract FinalizableCrowdsale is Crowdsale, Ownable {
247   using SafeMath for uint256;
248 
249   bool public isFinalized = false;
250 
251   event Finalized();
252 
253   /**
254    * @dev Must be called after crowdsale ends, to do some extra finalization
255    * work. Calls the contract's finalization function.
256    */
257   function finalize() public onlyOwner {
258     require(!isFinalized);
259     require(hasEnded());
260 
261     finalization();
262     Finalized();
263 
264     isFinalized = true;
265   }
266 
267   /**
268    * @dev Can be overridden to add finalization logic. The overriding function
269    * should call super.finalization() to ensure the chain of finalization is
270    * executed entirely.
271    */
272   function finalization() internal { } // solhint-disable no-empty-blocks
273 }
274 
275 contract TokenController {
276     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
277     /// @param _owner The address that sent the ether to create tokens
278     /// @return True if the ether is accepted, false if it throws
279     function proxyPayment(address _owner) payable returns(bool);
280 
281     /// @notice Notifies the controller about a token transfer allowing the
282     ///  controller to react if desired
283     /// @param _from The origin of the transfer
284     /// @param _to The destination of the transfer
285     /// @param _amount The amount of the transfer
286     /// @return False if the controller does not authorize the transfer
287     function onTransfer(address _from, address _to, uint _amount) returns(bool);
288 
289     /// @notice Notifies the controller about an approval allowing the
290     ///  controller to react if desired
291     /// @param _owner The address that calls `approve()`
292     /// @param _spender The spender in the `approve()` call
293     /// @param _amount The amount in the `approve()` call
294     /// @return False if the controller does not authorize the approval
295     function onApprove(address _owner, address _spender, uint _amount)
296         returns(bool);
297 }
298 
299 contract BloomTokenSale is CappedCrowdsale, Ownable, TokenController, Pausable, Configurable, FinalizableCrowdsale {
300   using SafeMath for uint256;
301 
302   BLT public token;
303 
304   // Solhint breaks on combination of scientific notation and `ether` keyword so disable next line
305   // solhint-disable-next-line
306   uint256 public constant TOTAL_SUPPLY = 1.5e8 ether; // 150 million BLT with 18 decimals
307   uint256 internal constant FOUNDATION_SUPPLY = (TOTAL_SUPPLY * 4) / 10; // 40% supply
308   uint256 internal constant ADVISOR_SUPPLY = TOTAL_SUPPLY / 20; // 5% supply
309   uint256 internal constant PARTNERSHIP_SUPPLY = TOTAL_SUPPLY / 20; // 5% supply
310   uint256 internal constant CONTROLLER_ALLOCATION =
311     TOTAL_SUPPLY - FOUNDATION_SUPPLY - PARTNERSHIP_SUPPLY; // 55%
312   uint256 internal constant WALLET_ALLOCATION = TOTAL_SUPPLY - CONTROLLER_ALLOCATION; // 45%
313   uint256 internal constant MAX_RAISE_IN_USD = 5e7; // Maximum raise of $50M
314 
315   // Wei ether with two extra decimal places. Useful for conversion when we set the ether price
316   uint256 internal constant WEI_PER_ETHER_TWO_DECIMALS = 1e20;
317   uint256 internal constant TOKEN_UNITS_PER_TOKEN = 1e18; // Decimal units per BLT
318 
319   uint256 public advisorPool = ADVISOR_SUPPLY;
320 
321   uint256 internal constant DUST = 1 finney; // Minimum payment
322 
323   event NewPresaleAllocation(address indexed holder, uint256 bltAmount);
324 
325   function BloomTokenSale(
326     uint256 _startTime,
327     uint256 _endTime,
328     uint256 _rate,
329     address _wallet,
330     uint256 _cap
331   ) public
332     Crowdsale(_startTime, _endTime, _rate, _wallet)
333     CappedCrowdsale(_cap) { } // solhint-disable-line no-empty-blocks
334 
335   // @dev Link the token to the Crowdsale
336   // @param _token address of the deployed token
337   function setToken(address _token) public presaleOnly {
338     token = BLT(_token);
339   }
340 
341   // @dev Allocate our initial token supply
342   function allocateSupply() public presaleOnly {
343     require(token.totalSupply() == 0);
344     token.generateTokens(address(this), CONTROLLER_ALLOCATION);
345     token.generateTokens(wallet, WALLET_ALLOCATION);
346   }
347 
348   // @dev Explicitly allocate tokens from the advisor pool, updating how much is left in the pool.
349   //
350   // @param _receiver Recipient of grant
351   // @param _amount Total BLT units allocated
352   // @param _cliffDate Vesting cliff
353   // @param _vestingDate Date that the vesting finishes
354   function allocateAdvisorTokens(address _receiver, uint256 _amount, uint64 _cliffDate, uint64 _vestingDate)
355            public
356            presaleOnly {
357     require(_amount <= advisorPool);
358     advisorPool = advisorPool.sub(_amount);
359     allocatePresaleTokens(_receiver, _amount, _cliffDate, _vestingDate);
360   }
361 
362   // @dev Allocate a normal presale grant. Does not necessarily come from a limited pool like the advisor tokens.
363   //
364   // @param _receiver Recipient of grant
365   // @param _amount Total BLT units allocated
366   // @param _cliffDate Vesting cliff
367   // @param _vestingDate Date that the vesting finishes
368   function allocatePresaleTokens(address _receiver, uint256 _amount, uint64 cliffDate, uint64 vestingDate)
369            public
370            presaleOnly {
371 
372     require(_amount <= 10 ** 25); // 10 million BLT. No presale partner will have more than this allocated. Prevent overflows.
373 
374     // solhint-disable-next-line not-rely-on-time
375     token.grantVestedTokens(_receiver, _amount, uint64(now), cliffDate, vestingDate, true, false);
376 
377     NewPresaleAllocation(_receiver, _amount);
378   }
379 
380   // @dev Set the stage for the sale:
381   //   1. Sets the `cap` controller variable based on the USD/ETH price
382   //   2. Updates the `weiRaised` to the balance of our wallet
383   //   3. Takes the unallocated portion of the advisor pool and transfers to the wallet
384   //   4. Sets the `rate` for the sale now based on the remaining tokens and cap
385   //
386   // @param _cents The number of cents in USD to purchase 1 ETH
387   // @param _weiRaisedOffChain Total amount of wei raised (at specified conversion rate) outside of wallet
388   function finishPresale(uint256 _cents, uint256 _weiRaisedOffChain) public presaleOnly returns (bool) {
389     setCapFromEtherPrice(_cents);
390     syncPresaleWeiRaised(_weiRaisedOffChain);
391     transferUnallocatedAdvisorTokens();
392     updateRateBasedOnFundsAndSupply();
393     finishConfiguration();
394   }
395 
396   // @dev Revoke a token grant, transfering the unvested tokens to our sale wallet
397   //
398   // @param _holder Owner of the vesting grant that is being revoked
399   // @param _grantId ID of the grant being revoked
400   function revokeGrant(address _holder, uint256 _grantId) public onlyOwner {
401     token.revokeTokenGrant(_holder, wallet, _grantId);
402   }
403 
404   // @dev low level token purchase function
405   // @param _beneficiary address the tokens will be credited to
406   function proxyPayment(address _beneficiary)
407     public
408     payable
409     whenNotPaused
410     onlyAfterConfiguration
411     returns (bool) {
412     require(_beneficiary != 0x0);
413     require(validPurchase());
414 
415     uint256 weiAmount = msg.value;
416 
417     // Update the total wei raised
418     weiRaised = weiRaised.add(weiAmount);
419 
420     // Transfer tokens from the controller to the _beneficiary
421     allocateTokens(_beneficiary, weiAmount);
422 
423     // Send the transfered wei to our wallet
424     forwardFunds();
425 
426     return true;
427   }
428 
429   // @dev controller callback for approving token transfers. Only supports
430   //   transfers from the controller for now.
431   //
432   // @param _from address that wants to transfer their tokens
433   function onTransfer(address _from, address _to, uint) public returns (bool) {
434     return _from == address(this) || _to == address(wallet);
435   }
436 
437   // @dev controller callback for approving token transfers. This feature
438   //   is disabled during the crowdsale for the sake of simplicity
439   function onApprove(address, address, uint) public returns (bool) {
440     return false;
441   }
442 
443   // @dev Change the token controller once the sale is over
444   //
445   // @param _newController Address of new token controller
446   function changeTokenController(address _newController) public onlyOwner whenFinalized {
447     token.changeController(_newController);
448   }
449 
450   // @dev Set the crowdsale cap based on the ether price
451   // @param _cents The number of cents in USD to purchase 1 ETH
452   function setCapFromEtherPrice(uint256 _cents) internal {
453     require(_cents > 10000 && _cents < 100000);
454     uint256 weiPerDollar = WEI_PER_ETHER_TWO_DECIMALS.div(_cents);
455     cap = MAX_RAISE_IN_USD.mul(weiPerDollar);
456   }
457 
458   // @dev Set the `weiRaised` for this contract to the balance of the sale wallet
459   function syncPresaleWeiRaised(uint256 _weiRaisedOffChain) internal {
460     require(weiRaised == 0);
461     weiRaised = wallet.balance.add(_weiRaisedOffChain);
462   }
463 
464   // @dev Transfer unallocated advisor tokens to our wallet. Lets us sell any leftovers
465   function transferUnallocatedAdvisorTokens() internal {
466     uint256 _unallocatedTokens = advisorPool;
467     // Advisor pool will not be used again but we zero it out anyways for the sake of book keeping
468     advisorPool = 0;
469     token.transferFrom(address(this), wallet, _unallocatedTokens);
470   }
471 
472   // @dev Set the `rate` based on our remaining token supply and how much we still need to raise
473   function updateRateBasedOnFundsAndSupply() internal {
474     uint256 _unraisedWei = cap - weiRaised;
475     uint256 _tokensForSale = token.balanceOf(address(this));
476     rate = _tokensForSale.mul(1e18).div(_unraisedWei);
477   }
478 
479   // @dev Transfer funds from the controller's address to the _beneficiary. Uses
480   //   _weiAmount to compute the number of tokens purchased.
481   // @param _beneficiary recipient of tokens
482   // @param _weiAmount wei transfered to crowdsale
483   function allocateTokens(address _beneficiary, uint256 _weiAmount) internal {
484     token.transferFrom(address(this), _beneficiary, tokensFor(_weiAmount));
485   }
486 
487   // @dev Compute number of token units a given amount of wei gets
488   //
489   // @param _weiAmount Amount of wei to convert
490   function tokensFor(uint256 _weiAmount) internal constant returns (uint256) {
491     return _weiAmount.mul(rate).div(1e18);
492   }
493 
494   // @dev validate purchases. Delegates to super method and also requires that
495   //   the initial configuration phase is finished.
496   function validPurchase() internal constant returns (bool) {
497     return super.validPurchase() && msg.value >= DUST && configured;
498   }
499 
500   // @dev transfer leftover tokens to our wallet
501   function finalization() internal {
502     token.transferFrom(address(this), wallet, token.balanceOf(address(this)));
503   }
504 
505   function inPresalePhase() internal constant beforeSale configuration returns (bool) {
506     return true;
507   }
508 
509   modifier presaleOnly() {
510     require(inPresalePhase());
511     _;
512   }
513 
514   modifier beforeSale {
515     require(now < startTime); // solhint-disable-line not-rely-on-time
516     _;
517   }
518 
519   modifier whenFinalized {
520     require(isFinalized);
521     _;
522   }
523 }
524 
525 contract Controlled {
526     /// @notice The address of the controller is the only address that can call
527     ///  a function with this modifier
528     modifier onlyController { require(msg.sender == controller); _; }
529 
530     address public controller;
531 
532     function Controlled() { controller = msg.sender;}
533 
534     /// @notice Changes the controller of the contract
535     /// @param _newController The new controller of the contract
536     function changeController(address _newController) onlyController {
537         controller = _newController;
538     }
539 }
540 
541 contract ApproveAndCallFallBack {
542     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
543 }
544 
545 contract MiniMeToken is Controlled {
546 
547     string public name;                //The Token's name: e.g. DigixDAO Tokens
548     uint8 public decimals;             //Number of decimals of the smallest unit
549     string public symbol;              //An identifier: e.g. REP
550     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
551 
552 
553     /// @dev `Checkpoint` is the structure that attaches a block number to a
554     ///  given value, the block number attached is the one that last changed the
555     ///  value
556     struct  Checkpoint {
557 
558         // `fromBlock` is the block number that the value was generated from
559         uint128 fromBlock;
560 
561         // `value` is the amount of tokens at a specific block number
562         uint128 value;
563     }
564 
565     // `parentToken` is the Token address that was cloned to produce this token;
566     //  it will be 0x0 for a token that was not cloned
567     MiniMeToken public parentToken;
568 
569     // `parentSnapShotBlock` is the block number from the Parent Token that was
570     //  used to determine the initial distribution of the Clone Token
571     uint public parentSnapShotBlock;
572 
573     // `creationBlock` is the block number that the Clone Token was created
574     uint public creationBlock;
575 
576     // `balances` is the map that tracks the balance of each address, in this
577     //  contract when the balance changes the block number that the change
578     //  occurred is also included in the map
579     mapping (address => Checkpoint[]) balances;
580 
581     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
582     mapping (address => mapping (address => uint256)) allowed;
583 
584     // Tracks the history of the `totalSupply` of the token
585     Checkpoint[] totalSupplyHistory;
586 
587     // Flag that determines if the token is transferable or not.
588     bool public transfersEnabled;
589 
590     // The factory used to create new clone tokens
591     MiniMeTokenFactory public tokenFactory;
592 
593 ////////////////
594 // Constructor
595 ////////////////
596 
597     /// @notice Constructor to create a MiniMeToken
598     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
599     ///  will create the Clone token contracts, the token factory needs to be
600     ///  deployed first
601     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
602     ///  new token
603     /// @param _parentSnapShotBlock Block of the parent token that will
604     ///  determine the initial distribution of the clone token, set to 0 if it
605     ///  is a new token
606     /// @param _tokenName Name of the new token
607     /// @param _decimalUnits Number of decimals of the new token
608     /// @param _tokenSymbol Token Symbol for the new token
609     /// @param _transfersEnabled If true, tokens will be able to be transferred
610     function MiniMeToken(
611         address _tokenFactory,
612         address _parentToken,
613         uint _parentSnapShotBlock,
614         string _tokenName,
615         uint8 _decimalUnits,
616         string _tokenSymbol,
617         bool _transfersEnabled
618     ) {
619         tokenFactory = MiniMeTokenFactory(_tokenFactory);
620         name = _tokenName;                                 // Set the name
621         decimals = _decimalUnits;                          // Set the decimals
622         symbol = _tokenSymbol;                             // Set the symbol
623         parentToken = MiniMeToken(_parentToken);
624         parentSnapShotBlock = _parentSnapShotBlock;
625         transfersEnabled = _transfersEnabled;
626         creationBlock = block.number;
627     }
628 
629 
630 ///////////////////
631 // ERC20 Methods
632 ///////////////////
633 
634     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
635     /// @param _to The address of the recipient
636     /// @param _amount The amount of tokens to be transferred
637     /// @return Whether the transfer was successful or not
638     function transfer(address _to, uint256 _amount) returns (bool success) {
639         require(transfersEnabled);
640         return doTransfer(msg.sender, _to, _amount);
641     }
642 
643     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
644     ///  is approved by `_from`
645     /// @param _from The address holding the tokens being transferred
646     /// @param _to The address of the recipient
647     /// @param _amount The amount of tokens to be transferred
648     /// @return True if the transfer was successful
649     function transferFrom(address _from, address _to, uint256 _amount
650     ) returns (bool success) {
651 
652         // The controller of this contract can move tokens around at will,
653         //  this is important to recognize! Confirm that you trust the
654         //  controller of this contract, which in most situations should be
655         //  another open source smart contract or 0x0
656         if (msg.sender != controller) {
657             require(transfersEnabled);
658 
659             // The standard ERC 20 transferFrom functionality
660             if (allowed[_from][msg.sender] < _amount) return false;
661             allowed[_from][msg.sender] -= _amount;
662         }
663         return doTransfer(_from, _to, _amount);
664     }
665 
666     /// @dev This is the actual transfer function in the token contract, it can
667     ///  only be called by other functions in this contract.
668     /// @param _from The address holding the tokens being transferred
669     /// @param _to The address of the recipient
670     /// @param _amount The amount of tokens to be transferred
671     /// @return True if the transfer was successful
672     function doTransfer(address _from, address _to, uint _amount
673     ) internal returns(bool) {
674 
675            if (_amount == 0) {
676                return true;
677            }
678 
679            require(parentSnapShotBlock < block.number);
680 
681            // Do not allow transfer to 0x0 or the token contract itself
682            require((_to != 0) && (_to != address(this)));
683 
684            // If the amount being transfered is more than the balance of the
685            //  account the transfer returns false
686            var previousBalanceFrom = balanceOfAt(_from, block.number);
687            if (previousBalanceFrom < _amount) {
688                return false;
689            }
690 
691            // Alerts the token controller of the transfer
692            if (isContract(controller)) {
693                require(TokenController(controller).onTransfer(_from, _to, _amount));
694            }
695 
696            // First update the balance array with the new value for the address
697            //  sending the tokens
698            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
699 
700            // Then update the balance array with the new value for the address
701            //  receiving the tokens
702            var previousBalanceTo = balanceOfAt(_to, block.number);
703            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
704            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
705 
706            // An event to make the transfer easy to find on the blockchain
707            Transfer(_from, _to, _amount);
708 
709            return true;
710     }
711 
712     /// @param _owner The address that's balance is being requested
713     /// @return The balance of `_owner` at the current block
714     function balanceOf(address _owner) constant returns (uint256 balance) {
715         return balanceOfAt(_owner, block.number);
716     }
717 
718     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
719     ///  its behalf. This is a modified version of the ERC20 approve function
720     ///  to be a little bit safer
721     /// @param _spender The address of the account able to transfer the tokens
722     /// @param _amount The amount of tokens to be approved for transfer
723     /// @return True if the approval was successful
724     function approve(address _spender, uint256 _amount) returns (bool success) {
725         require(transfersEnabled);
726 
727         // To change the approve amount you first have to reduce the addresses`
728         //  allowance to zero by calling `approve(_spender,0)` if it is not
729         //  already 0 to mitigate the race condition described here:
730         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
731         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
732 
733         // Alerts the token controller of the approve function call
734         if (isContract(controller)) {
735             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
736         }
737 
738         allowed[msg.sender][_spender] = _amount;
739         Approval(msg.sender, _spender, _amount);
740         return true;
741     }
742 
743     /// @dev This function makes it easy to read the `allowed[]` map
744     /// @param _owner The address of the account that owns the token
745     /// @param _spender The address of the account able to transfer the tokens
746     /// @return Amount of remaining tokens of _owner that _spender is allowed
747     ///  to spend
748     function allowance(address _owner, address _spender
749     ) constant returns (uint256 remaining) {
750         return allowed[_owner][_spender];
751     }
752 
753     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
754     ///  its behalf, and then a function is triggered in the contract that is
755     ///  being approved, `_spender`. This allows users to use their tokens to
756     ///  interact with contracts in one function call instead of two
757     /// @param _spender The address of the contract able to transfer the tokens
758     /// @param _amount The amount of tokens to be approved for transfer
759     /// @return True if the function call was successful
760     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
761     ) returns (bool success) {
762         require(approve(_spender, _amount));
763 
764         ApproveAndCallFallBack(_spender).receiveApproval(
765             msg.sender,
766             _amount,
767             this,
768             _extraData
769         );
770 
771         return true;
772     }
773 
774     /// @dev This function makes it easy to get the total number of tokens
775     /// @return The total number of tokens
776     function totalSupply() constant returns (uint) {
777         return totalSupplyAt(block.number);
778     }
779 
780 
781 ////////////////
782 // Query balance and totalSupply in History
783 ////////////////
784 
785     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
786     /// @param _owner The address from which the balance will be retrieved
787     /// @param _blockNumber The block number when the balance is queried
788     /// @return The balance at `_blockNumber`
789     function balanceOfAt(address _owner, uint _blockNumber) constant
790         returns (uint) {
791 
792         // These next few lines are used when the balance of the token is
793         //  requested before a check point was ever created for this token, it
794         //  requires that the `parentToken.balanceOfAt` be queried at the
795         //  genesis block for that token as this contains initial balance of
796         //  this token
797         if ((balances[_owner].length == 0)
798             || (balances[_owner][0].fromBlock > _blockNumber)) {
799             if (address(parentToken) != 0) {
800                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
801             } else {
802                 // Has no parent
803                 return 0;
804             }
805 
806         // This will return the expected balance during normal situations
807         } else {
808             return getValueAt(balances[_owner], _blockNumber);
809         }
810     }
811 
812     /// @notice Total amount of tokens at a specific `_blockNumber`.
813     /// @param _blockNumber The block number when the totalSupply is queried
814     /// @return The total amount of tokens at `_blockNumber`
815     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
816 
817         // These next few lines are used when the totalSupply of the token is
818         //  requested before a check point was ever created for this token, it
819         //  requires that the `parentToken.totalSupplyAt` be queried at the
820         //  genesis block for this token as that contains totalSupply of this
821         //  token at this block number.
822         if ((totalSupplyHistory.length == 0)
823             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
824             if (address(parentToken) != 0) {
825                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
826             } else {
827                 return 0;
828             }
829 
830         // This will return the expected totalSupply during normal situations
831         } else {
832             return getValueAt(totalSupplyHistory, _blockNumber);
833         }
834     }
835 
836 ////////////////
837 // Clone Token Method
838 ////////////////
839 
840     /// @notice Creates a new clone token with the initial distribution being
841     ///  this token at `_snapshotBlock`
842     /// @param _cloneTokenName Name of the clone token
843     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
844     /// @param _cloneTokenSymbol Symbol of the clone token
845     /// @param _snapshotBlock Block when the distribution of the parent token is
846     ///  copied to set the initial distribution of the new clone token;
847     ///  if the block is zero than the actual block, the current block is used
848     /// @param _transfersEnabled True if transfers are allowed in the clone
849     /// @return The address of the new MiniMeToken Contract
850     function createCloneToken(
851         string _cloneTokenName,
852         uint8 _cloneDecimalUnits,
853         string _cloneTokenSymbol,
854         uint _snapshotBlock,
855         bool _transfersEnabled
856         ) returns(address) {
857         if (_snapshotBlock == 0) _snapshotBlock = block.number;
858         MiniMeToken cloneToken = tokenFactory.createCloneToken(
859             this,
860             _snapshotBlock,
861             _cloneTokenName,
862             _cloneDecimalUnits,
863             _cloneTokenSymbol,
864             _transfersEnabled
865             );
866 
867         cloneToken.changeController(msg.sender);
868 
869         // An event to make the token easy to find on the blockchain
870         NewCloneToken(address(cloneToken), _snapshotBlock);
871         return address(cloneToken);
872     }
873 
874 ////////////////
875 // Generate and destroy tokens
876 ////////////////
877 
878     /// @notice Generates `_amount` tokens that are assigned to `_owner`
879     /// @param _owner The address that will be assigned the new tokens
880     /// @param _amount The quantity of tokens generated
881     /// @return True if the tokens are generated correctly
882     function generateTokens(address _owner, uint _amount
883     ) onlyController returns (bool) {
884         uint curTotalSupply = totalSupply();
885         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
886         uint previousBalanceTo = balanceOf(_owner);
887         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
888         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
889         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
890         Transfer(0, _owner, _amount);
891         return true;
892     }
893 
894 
895     /// @notice Burns `_amount` tokens from `_owner`
896     /// @param _owner The address that will lose the tokens
897     /// @param _amount The quantity of tokens to burn
898     /// @return True if the tokens are burned correctly
899     function destroyTokens(address _owner, uint _amount
900     ) onlyController returns (bool) {
901         uint curTotalSupply = totalSupply();
902         require(curTotalSupply >= _amount);
903         uint previousBalanceFrom = balanceOf(_owner);
904         require(previousBalanceFrom >= _amount);
905         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
906         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
907         Transfer(_owner, 0, _amount);
908         return true;
909     }
910 
911 ////////////////
912 // Enable tokens transfers
913 ////////////////
914 
915 
916     /// @notice Enables token holders to transfer their tokens freely if true
917     /// @param _transfersEnabled True if transfers are allowed in the clone
918     function enableTransfers(bool _transfersEnabled) onlyController {
919         transfersEnabled = _transfersEnabled;
920     }
921 
922 ////////////////
923 // Internal helper functions to query and set a value in a snapshot array
924 ////////////////
925 
926     /// @dev `getValueAt` retrieves the number of tokens at a given block number
927     /// @param checkpoints The history of values being queried
928     /// @param _block The block number to retrieve the value at
929     /// @return The number of tokens being queried
930     function getValueAt(Checkpoint[] storage checkpoints, uint _block
931     ) constant internal returns (uint) {
932         if (checkpoints.length == 0) return 0;
933 
934         // Shortcut for the actual value
935         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
936             return checkpoints[checkpoints.length-1].value;
937         if (_block < checkpoints[0].fromBlock) return 0;
938 
939         // Binary search of the value in the array
940         uint min = 0;
941         uint max = checkpoints.length-1;
942         while (max > min) {
943             uint mid = (max + min + 1)/ 2;
944             if (checkpoints[mid].fromBlock<=_block) {
945                 min = mid;
946             } else {
947                 max = mid-1;
948             }
949         }
950         return checkpoints[min].value;
951     }
952 
953     /// @dev `updateValueAtNow` used to update the `balances` map and the
954     ///  `totalSupplyHistory`
955     /// @param checkpoints The history of data being updated
956     /// @param _value The new number of tokens
957     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
958     ) internal  {
959         if ((checkpoints.length == 0)
960         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
961                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
962                newCheckPoint.fromBlock =  uint128(block.number);
963                newCheckPoint.value = uint128(_value);
964            } else {
965                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
966                oldCheckPoint.value = uint128(_value);
967            }
968     }
969 
970     /// @dev Internal function to determine if an address is a contract
971     /// @param _addr The address being queried
972     /// @return True if `_addr` is a contract
973     function isContract(address _addr) constant internal returns(bool) {
974         uint size;
975         if (_addr == 0) return false;
976         assembly {
977             size := extcodesize(_addr)
978         }
979         return size>0;
980     }
981 
982     /// @dev Helper function to return a min betwen the two uints
983     function min(uint a, uint b) internal returns (uint) {
984         return a < b ? a : b;
985     }
986 
987     /// @notice The fallback function: If the contract's controller has not been
988     ///  set to 0, then the `proxyPayment` method is called which relays the
989     ///  ether and creates tokens as described in the token controller contract
990     function ()  payable {
991         require(isContract(controller));
992         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
993     }
994 
995 //////////
996 // Safety Methods
997 //////////
998 
999     /// @notice This method can be used by the controller to extract mistakenly
1000     ///  sent tokens to this contract.
1001     /// @param _token The address of the token contract that you want to recover
1002     ///  set to 0 in case you want to extract ether.
1003     function claimTokens(address _token) onlyController {
1004         if (_token == 0x0) {
1005             controller.transfer(this.balance);
1006             return;
1007         }
1008 
1009         MiniMeToken token = MiniMeToken(_token);
1010         uint balance = token.balanceOf(this);
1011         token.transfer(controller, balance);
1012         ClaimedTokens(_token, controller, balance);
1013     }
1014 
1015 ////////////////
1016 // Events
1017 ////////////////
1018     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1019     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
1020     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
1021     event Approval(
1022         address indexed _owner,
1023         address indexed _spender,
1024         uint256 _amount
1025         );
1026 
1027 }
1028 
1029 contract MiniMeTokenFactory {
1030 
1031     /// @notice Update the DApp by creating a new token with new functionalities
1032     ///  the msg.sender becomes the controller of this clone token
1033     /// @param _parentToken Address of the token being cloned
1034     /// @param _snapshotBlock Block of the parent token that will
1035     ///  determine the initial distribution of the clone token
1036     /// @param _tokenName Name of the new token
1037     /// @param _decimalUnits Number of decimals of the new token
1038     /// @param _tokenSymbol Token Symbol for the new token
1039     /// @param _transfersEnabled If true, tokens will be able to be transferred
1040     /// @return The address of the new token contract
1041     function createCloneToken(
1042         address _parentToken,
1043         uint _snapshotBlock,
1044         string _tokenName,
1045         uint8 _decimalUnits,
1046         string _tokenSymbol,
1047         bool _transfersEnabled
1048     ) returns (MiniMeToken) {
1049         MiniMeToken newToken = new MiniMeToken(
1050             this,
1051             _parentToken,
1052             _snapshotBlock,
1053             _tokenName,
1054             _decimalUnits,
1055             _tokenSymbol,
1056             _transfersEnabled
1057             );
1058 
1059         newToken.changeController(msg.sender);
1060         return newToken;
1061     }
1062 }
1063 
1064 contract MiniMeVestedToken is MiniMeToken {
1065   using SafeMath for uint256;
1066   using Math for uint64;
1067 
1068   struct TokenGrant {
1069     address granter;     // 20 bytes
1070     uint256 value;       // 32 bytes
1071     uint64 cliff;
1072     uint64 vesting;
1073     uint64 start;        // 3 * 8 = 24 bytes
1074     bool revokable;
1075     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
1076   } // total 78 bytes = 3 sstore per operation (32 per sstore)
1077 
1078   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
1079 
1080   mapping (address => TokenGrant[]) public grants;
1081 
1082   mapping (address => bool) public canCreateGrants;
1083   address public vestingWhitelister;
1084 
1085   modifier canTransfer(address _sender, uint _value) {
1086     require(spendableBalanceOf(_sender) >= _value);
1087     _;
1088   }
1089 
1090   modifier onlyVestingWhitelister {
1091     require(msg.sender == vestingWhitelister);
1092     _;
1093   }
1094 
1095   function MiniMeVestedToken (
1096       address _tokenFactory,
1097       address _parentToken,
1098       uint _parentSnapShotBlock,
1099       string _tokenName,
1100       uint8 _decimalUnits,
1101       string _tokenSymbol,
1102       bool _transfersEnabled
1103   ) public
1104     MiniMeToken(_tokenFactory, _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {
1105     vestingWhitelister = msg.sender;
1106     doSetCanCreateGrants(vestingWhitelister, true);
1107   }
1108 
1109   // @dev Add canTransfer modifier before allowing transfer and transferFrom to go through
1110   function transfer(address _to, uint _value)
1111            public
1112            canTransfer(msg.sender, _value)
1113            returns (bool success) {
1114     return super.transfer(_to, _value);
1115   }
1116 
1117   function transferFrom(address _from, address _to, uint _value)
1118            public
1119            canTransfer(_from, _value)
1120            returns (bool success) {
1121     return super.transferFrom(_from, _to, _value);
1122   }
1123 
1124   function spendableBalanceOf(address _holder) public constant returns (uint) {
1125     return transferableTokens(_holder, uint64(now)); // solhint-disable not-rely-on-time
1126   }
1127 
1128   /**
1129    * @dev Grant tokens to a specified address
1130    * @param _to address The address which the tokens will be granted to.
1131    * @param _value uint256 The amount of tokens to be granted.
1132    * @param _start uint64 Time of the beginning of the grant.
1133    * @param _cliff uint64 Time of the cliff period.
1134    * @param _vesting uint64 The vesting period.
1135    */
1136   function grantVestedTokens(
1137     address _to,
1138     uint256 _value,
1139     uint64 _start,
1140     uint64 _cliff,
1141     uint64 _vesting,
1142     bool _revokable,
1143     bool _burnsOnRevoke
1144   ) public {
1145     // Check start, cliff and vesting are properly order to ensure correct functionality of the formula.
1146     require(_cliff >= _start);
1147     require(_vesting >= _cliff);
1148 
1149     require(canCreateGrants[msg.sender]);
1150     require(tokenGrantsCount(_to) < 20);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
1151 
1152     TokenGrant memory grant = TokenGrant(
1153       _revokable ? msg.sender : 0,
1154       _value,
1155       _cliff,
1156       _vesting,
1157       _start,
1158       _revokable,
1159       _burnsOnRevoke
1160     );
1161 
1162     uint256 count = grants[_to].push(grant);
1163 
1164     assert(transfer(_to, _value));
1165 
1166     NewTokenGrant(msg.sender, _to, _value, count - 1);
1167   }
1168 
1169   function setCanCreateGrants(address _addr, bool _allowed)
1170            public onlyVestingWhitelister {
1171     doSetCanCreateGrants(_addr, _allowed);
1172   }
1173 
1174   function changeVestingWhitelister(address _newWhitelister) public onlyVestingWhitelister {
1175     require(_newWhitelister != 0);
1176     doSetCanCreateGrants(vestingWhitelister, false);
1177     vestingWhitelister = _newWhitelister;
1178     doSetCanCreateGrants(vestingWhitelister, true);
1179   }
1180 
1181   /**
1182    * @dev Revoke the grant of tokens of a specifed address.
1183    * @param _holder The address which will have its tokens revoked.
1184    * @param _receiver Recipient of revoked tokens.
1185    * @param _grantId The id of the token grant.
1186    */
1187   function revokeTokenGrant(address _holder, address _receiver, uint256 _grantId) public onlyVestingWhitelister {
1188     require(_receiver != 0);
1189 
1190     TokenGrant storage grant = grants[_holder][_grantId];
1191 
1192     require(grant.revokable);
1193     require(grant.granter == msg.sender); // Only granter can revoke it
1194 
1195     address receiver = grant.burnsOnRevoke ? 0xdead : _receiver;
1196 
1197     uint256 nonVested = nonVestedTokens(grant, uint64(now));
1198 
1199     // remove grant from array
1200     delete grants[_holder][_grantId];
1201     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
1202     grants[_holder].length -= 1;
1203 
1204     doTransfer(_holder, receiver, nonVested);
1205   }
1206 
1207   /**
1208    * @dev Check the amount of grants that an address has.
1209    * @param _holder The holder of the grants.
1210    * @return A uint256 representing the total amount of grants.
1211    */
1212   function tokenGrantsCount(address _holder) public constant returns (uint index) {
1213     return grants[_holder].length;
1214   }
1215 
1216   /**
1217    * @dev Get all information about a specific grant.
1218    * @param _holder The address which will have its tokens revoked.
1219    * @param _grantId The id of the token grant.
1220    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
1221    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
1222    */
1223   function tokenGrant(address _holder, uint256 _grantId) public constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
1224     TokenGrant storage grant = grants[_holder][_grantId];
1225 
1226     granter = grant.granter;
1227     value = grant.value;
1228     start = grant.start;
1229     cliff = grant.cliff;
1230     vesting = grant.vesting;
1231     revokable = grant.revokable;
1232     burnsOnRevoke = grant.burnsOnRevoke;
1233 
1234     vested = vestedTokens(grant, uint64(now));
1235   }
1236 
1237   // @dev The date in which all tokens are transferable for the holder
1238   // Useful for displaying purposes (not used in any logic calculations)
1239   function lastTokenIsTransferableDate(address holder) public constant returns (uint64 date) {
1240     date = uint64(now);
1241     uint256 grantIndex = tokenGrantsCount(holder);
1242     for (uint256 i = 0; i < grantIndex; i++) {
1243       date = grants[holder][i].vesting.max64(date);
1244     }
1245     return date;
1246   }
1247 
1248   // @dev How many tokens can a holder transfer at a point in time
1249   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
1250     uint256 grantIndex = tokenGrantsCount(holder);
1251 
1252     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
1253 
1254     // Iterate through all the grants the holder has, and add all non-vested tokens
1255     uint256 nonVested = 0;
1256     for (uint256 i = 0; i < grantIndex; i++) {
1257       nonVested = nonVested.add(nonVestedTokens(grants[holder][i], time));
1258     }
1259 
1260     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
1261     return balanceOf(holder).sub(nonVested);
1262   }
1263 
1264   function doSetCanCreateGrants(address _addr, bool _allowed)
1265            internal {
1266     canCreateGrants[_addr] = _allowed;
1267   }
1268 
1269   /**
1270    * @dev Calculate amount of vested tokens at a specific time
1271    * @param tokens uint256 The amount of tokens granted
1272    * @param time uint64 The time to be checked
1273    * @param start uint64 The time representing the beginning of the grant
1274    * @param cliff uint64  The cliff period, the period before nothing can be paid out
1275    * @param vesting uint64 The vesting period
1276    * @return An uint256 representing the amount of vested tokens of a specific grant
1277    *  transferableTokens
1278    *   |                         _/--------   vestedTokens rect
1279    *   |                       _/
1280    *   |                     _/
1281    *   |                   _/
1282    *   |                 _/
1283    *   |                /
1284    *   |              .|
1285    *   |            .  |
1286    *   |          .    |
1287    *   |        .      |
1288    *   |      .        |
1289    *   |    .          |
1290    *   +===+===========+---------+----------> time
1291    *      Start       Cliff    Vesting
1292    */
1293   function calculateVestedTokens(
1294     uint256 tokens,
1295     uint256 time,
1296     uint256 start,
1297     uint256 cliff,
1298     uint256 vesting) internal constant returns (uint256)
1299     {
1300 
1301     // Shortcuts for before cliff and after vesting cases.
1302     if (time < cliff) return 0;
1303     if (time >= vesting) return tokens;
1304 
1305     // Interpolate all vested tokens.
1306     // As before cliff the shortcut returns 0, we can use just this function to
1307     // calculate it.
1308 
1309     // vested = tokens * (time - start) / (vesting - start)
1310     uint256 vested = tokens.mul(
1311                              time.sub(start)
1312                            ).div(vesting.sub(start));
1313 
1314     return vested;
1315   }
1316 
1317   /**
1318    * @dev Calculate the amount of non vested tokens at a specific time.
1319    * @param grant TokenGrant The grant to be checked.
1320    * @param time uint64 The time to be checked
1321    * @return An uint256 representing the amount of non vested tokens of a specific grant on the
1322    * passed time frame.
1323    */
1324   function nonVestedTokens(TokenGrant storage grant, uint64 time) internal constant returns (uint256) {
1325     // Of all the tokens of the grant, how many of them are not vested?
1326     // grantValue - vestedTokens
1327     return grant.value.sub(vestedTokens(grant, time));
1328   }
1329 
1330   /**
1331    * @dev Get the amount of vested tokens at a specific time.
1332    * @param grant TokenGrant The grant to be checked.
1333    * @param time The time to be checked
1334    * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
1335    */
1336   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
1337     return calculateVestedTokens(
1338       grant.value,
1339       uint256(time),
1340       uint256(grant.start),
1341       uint256(grant.cliff),
1342       uint256(grant.vesting)
1343     );
1344   }
1345 }
1346 
1347 contract BLT is MiniMeVestedToken {
1348   function BLT(address _tokenFactory) public MiniMeVestedToken(
1349     _tokenFactory,
1350     0x0,           // no parent token
1351     0,             // no snapshot block number from parent
1352     "Bloom Token", // Token name
1353     18,            // Decimals
1354     "BLT",         // Symbol
1355     true           // Enable transfers
1356   ) {} // solhint-disable-line no-empty-blocks
1357 }