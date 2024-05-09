1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract Pausable is Ownable {
107   event Pause();
108   event Unpause();
109 
110   bool public paused = false;
111 
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is not paused.
115    */
116   modifier whenNotPaused() {
117     require(!paused);
118     _;
119   }
120 
121   /**
122    * @dev Modifier to make a function callable only when the contract is paused.
123    */
124   modifier whenPaused() {
125     require(paused);
126     _;
127   }
128 
129   /**
130    * @dev called by the owner to pause, triggers stopped state
131    */
132   function pause() public onlyOwner whenNotPaused {
133     paused = true;
134     emit Pause();
135   }
136 
137   /**
138    * @dev called by the owner to unpause, returns to normal state
139    */
140   function unpause() public onlyOwner whenPaused {
141     paused = false;
142     emit Unpause();
143   }
144 }
145 
146 contract CanReclaimToken is Ownable {
147   using SafeERC20 for ERC20Basic;
148 
149   /**
150    * @dev Reclaim all ERC20Basic compatible tokens
151    * @param _token ERC20Basic The address of the token contract
152    */
153   function reclaimToken(ERC20Basic _token) external onlyOwner {
154     uint256 balance = _token.balanceOf(this);
155     _token.safeTransfer(owner, balance);
156   }
157 
158 }
159 
160 contract ERC20Basic {
161   function totalSupply() public view returns (uint256);
162   function balanceOf(address _who) public view returns (uint256);
163   function transfer(address _to, uint256 _value) public returns (bool);
164   event Transfer(address indexed from, address indexed to, uint256 value);
165 }
166 
167 contract BasicToken is ERC20Basic {
168   using SafeMath for uint256;
169 
170   mapping(address => uint256) internal balances;
171 
172   uint256 internal totalSupply_;
173 
174   /**
175   * @dev Total number of tokens in existence
176   */
177   function totalSupply() public view returns (uint256) {
178     return totalSupply_;
179   }
180 
181   /**
182   * @dev Transfer token for a specified address
183   * @param _to The address to transfer to.
184   * @param _value The amount to be transferred.
185   */
186   function transfer(address _to, uint256 _value) public returns (bool) {
187     require(_value <= balances[msg.sender]);
188     require(_to != address(0));
189 
190     balances[msg.sender] = balances[msg.sender].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     emit Transfer(msg.sender, _to, _value);
193     return true;
194   }
195 
196   /**
197   * @dev Gets the balance of the specified address.
198   * @param _owner The address to query the the balance of.
199   * @return An uint256 representing the amount owned by the passed address.
200   */
201   function balanceOf(address _owner) public view returns (uint256) {
202     return balances[_owner];
203   }
204 
205 }
206 
207 contract BurnableToken is BasicToken {
208 
209   event Burn(address indexed burner, uint256 value);
210 
211   /**
212    * @dev Burns a specific amount of tokens.
213    * @param _value The amount of token to be burned.
214    */
215   function burn(uint256 _value) public {
216     _burn(msg.sender, _value);
217   }
218 
219   function _burn(address _who, uint256 _value) internal {
220     require(_value <= balances[_who]);
221     // no need to require value <= totalSupply, since that would imply the
222     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
223 
224     balances[_who] = balances[_who].sub(_value);
225     totalSupply_ = totalSupply_.sub(_value);
226     emit Burn(_who, _value);
227     emit Transfer(_who, address(0), _value);
228   }
229 }
230 
231 contract ERC20 is ERC20Basic {
232   function allowance(address _owner, address _spender)
233     public view returns (uint256);
234 
235   function transferFrom(address _from, address _to, uint256 _value)
236     public returns (bool);
237 
238   function approve(address _spender, uint256 _value) public returns (bool);
239   event Approval(
240     address indexed owner,
241     address indexed spender,
242     uint256 value
243   );
244 }
245 
246 library SafeERC20 {
247   function safeTransfer(
248     ERC20Basic _token,
249     address _to,
250     uint256 _value
251   )
252     internal
253   {
254     require(_token.transfer(_to, _value));
255   }
256 
257   function safeTransferFrom(
258     ERC20 _token,
259     address _from,
260     address _to,
261     uint256 _value
262   )
263     internal
264   {
265     require(_token.transferFrom(_from, _to, _value));
266   }
267 
268   function safeApprove(
269     ERC20 _token,
270     address _spender,
271     uint256 _value
272   )
273     internal
274   {
275     require(_token.approve(_spender, _value));
276   }
277 }
278 
279 contract StandardToken is ERC20, BasicToken {
280 
281   mapping (address => mapping (address => uint256)) internal allowed;
282 
283 
284   /**
285    * @dev Transfer tokens from one address to another
286    * @param _from address The address which you want to send tokens from
287    * @param _to address The address which you want to transfer to
288    * @param _value uint256 the amount of tokens to be transferred
289    */
290   function transferFrom(
291     address _from,
292     address _to,
293     uint256 _value
294   )
295     public
296     returns (bool)
297   {
298     require(_value <= balances[_from]);
299     require(_value <= allowed[_from][msg.sender]);
300     require(_to != address(0));
301 
302     balances[_from] = balances[_from].sub(_value);
303     balances[_to] = balances[_to].add(_value);
304     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
305     emit Transfer(_from, _to, _value);
306     return true;
307   }
308 
309   /**
310    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
311    * Beware that changing an allowance with this method brings the risk that someone may use both the old
312    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
313    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
314    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
315    * @param _spender The address which will spend the funds.
316    * @param _value The amount of tokens to be spent.
317    */
318   function approve(address _spender, uint256 _value) public returns (bool) {
319     allowed[msg.sender][_spender] = _value;
320     emit Approval(msg.sender, _spender, _value);
321     return true;
322   }
323 
324   /**
325    * @dev Function to check the amount of tokens that an owner allowed to a spender.
326    * @param _owner address The address which owns the funds.
327    * @param _spender address The address which will spend the funds.
328    * @return A uint256 specifying the amount of tokens still available for the spender.
329    */
330   function allowance(
331     address _owner,
332     address _spender
333    )
334     public
335     view
336     returns (uint256)
337   {
338     return allowed[_owner][_spender];
339   }
340 
341   /**
342    * @dev Increase the amount of tokens that an owner allowed to a spender.
343    * approve should be called when allowed[_spender] == 0. To increment
344    * allowed value is better to use this function to avoid 2 calls (and wait until
345    * the first transaction is mined)
346    * From MonolithDAO Token.sol
347    * @param _spender The address which will spend the funds.
348    * @param _addedValue The amount of tokens to increase the allowance by.
349    */
350   function increaseApproval(
351     address _spender,
352     uint256 _addedValue
353   )
354     public
355     returns (bool)
356   {
357     allowed[msg.sender][_spender] = (
358       allowed[msg.sender][_spender].add(_addedValue));
359     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
360     return true;
361   }
362 
363   /**
364    * @dev Decrease the amount of tokens that an owner allowed to a spender.
365    * approve should be called when allowed[_spender] == 0. To decrement
366    * allowed value is better to use this function to avoid 2 calls (and wait until
367    * the first transaction is mined)
368    * From MonolithDAO Token.sol
369    * @param _spender The address which will spend the funds.
370    * @param _subtractedValue The amount of tokens to decrease the allowance by.
371    */
372   function decreaseApproval(
373     address _spender,
374     uint256 _subtractedValue
375   )
376     public
377     returns (bool)
378   {
379     uint256 oldValue = allowed[msg.sender][_spender];
380     if (_subtractedValue >= oldValue) {
381       allowed[msg.sender][_spender] = 0;
382     } else {
383       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
384     }
385     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
386     return true;
387   }
388 
389 }
390 
391 contract PausableToken is StandardToken, Pausable {
392 
393   function transfer(
394     address _to,
395     uint256 _value
396   )
397     public
398     whenNotPaused
399     returns (bool)
400   {
401     return super.transfer(_to, _value);
402   }
403 
404   function transferFrom(
405     address _from,
406     address _to,
407     uint256 _value
408   )
409     public
410     whenNotPaused
411     returns (bool)
412   {
413     return super.transferFrom(_from, _to, _value);
414   }
415 
416   function approve(
417     address _spender,
418     uint256 _value
419   )
420     public
421     whenNotPaused
422     returns (bool)
423   {
424     return super.approve(_spender, _value);
425   }
426 
427   function increaseApproval(
428     address _spender,
429     uint _addedValue
430   )
431     public
432     whenNotPaused
433     returns (bool success)
434   {
435     return super.increaseApproval(_spender, _addedValue);
436   }
437 
438   function decreaseApproval(
439     address _spender,
440     uint _subtractedValue
441   )
442     public
443     whenNotPaused
444     returns (bool success)
445   {
446     return super.decreaseApproval(_spender, _subtractedValue);
447   }
448 }
449 
450 contract MenloSaleBase is Ownable {
451   using SafeMath for uint256;
452 
453   // Whitelisted investors
454   mapping (address => bool) public whitelist;
455 
456   // Special role used exclusively for managing the whitelist
457   address public whitelister;
458 
459   // manual early close flag
460   bool public isFinalized;
461 
462   // cap for crowdsale in wei
463   uint256 public cap;
464 
465   // The token being sold
466   MenloToken public token;
467 
468   // start and end timestamps where contributions are allowed (both inclusive)
469   uint256 public startTime;
470   uint256 public endTime;
471 
472   // address where funds are collected
473   address public wallet;
474 
475   // amount of raised money in wei
476   uint256 public weiRaised;
477 
478   /**
479    * @dev Throws if called by any account other than the whitelister.
480    */
481   modifier onlyWhitelister() {
482     require(msg.sender == whitelister, "Sender should be whitelister");
483     _;
484   }
485 
486   /**
487    * event for token purchase logging
488    * @param purchaser who bought the tokens
489    * @param value weis paid for purchase
490    * @param amount amount of tokens purchased
491    */
492   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
493 
494   /**
495    * event for token redemption logging
496    * @param purchaser who bought the tokens
497    * @param amount amount of tokens redeemed
498    */
499   event TokenRedeem(address indexed purchaser, uint256 amount);
500 
501   // termination early or otherwise
502   event Finalized();
503 
504   event TokensRefund(uint256 amount);
505 
506   /**
507    * event refund of excess ETH if purchase is above the cap
508    * @param amount amount of ETH (in wei) refunded
509    */
510   event Refund(address indexed purchaser, uint256 amount);
511 
512   constructor(
513       MenloToken _token,
514       uint256 _startTime,
515       uint256 _endTime,
516       uint256 _cap,
517       address _wallet
518   ) public {
519     require(_startTime >= getBlockTimestamp(), "Start time should be in the future");
520     require(_endTime >= _startTime, "End time should be after start time");
521     require(_wallet != address(0), "Wallet address should be non-zero");
522     require(_token != address(0), "Token address should be non-zero");
523     require(_cap > 0, "Cap should be greater than zero");
524 
525     token = _token;
526 
527     startTime = _startTime;
528     endTime = _endTime;
529     cap = _cap;
530     wallet = _wallet;
531   }
532 
533   // fallback function can be used to buy tokens
534   function () public payable {
535     buyTokens();
536   }
537 
538   // Abstract methods
539   function calculateBonusRate() public view returns (uint256);
540   function buyTokensHook(uint256 _tokens) internal;
541 
542   function buyTokens() public payable returns (uint256) {
543     require(whitelist[msg.sender], "Expected msg.sender to be whitelisted");
544     checkFinalize();
545     require(!isFinalized, "Should not be finalized when purchasing");
546     require(getBlockTimestamp() >= startTime && getBlockTimestamp() <= endTime, "Should be during sale");
547     require(msg.value != 0, "Value should not be zero");
548     require(token.balanceOf(this) > 0, "This contract must have tokens");
549 
550     uint256 _weiAmount = msg.value;
551 
552     uint256 _remainingToFund = cap.sub(weiRaised);
553     if (_weiAmount > _remainingToFund) {
554       _weiAmount = _remainingToFund;
555     }
556 
557     uint256 _totalTokens = _weiAmount.mul(calculateBonusRate());
558     if (_totalTokens > token.balanceOf(this)) {
559       // Change _wei to buy rest of remaining tokens
560       _weiAmount = token.balanceOf(this).div(calculateBonusRate());
561     }
562 
563     token.unpause();
564     weiRaised = weiRaised.add(_weiAmount);
565 
566     forwardFunds(_weiAmount);
567     uint256 _weiToReturn = msg.value.sub(_weiAmount);
568     if (_weiToReturn > 0) {
569       msg.sender.transfer(_weiToReturn);
570       emit Refund(msg.sender, _weiToReturn);
571     }
572 
573     uint256 _tokens = ethToTokens(_weiAmount);
574     emit TokenPurchase(msg.sender, _weiAmount, _tokens);
575     buyTokensHook(_tokens);
576     token.pause();
577 
578     checkFinalize();
579 
580     return _tokens;
581   }
582 
583   // Allows the owner to take back the tokens that are assigned to the sale contract.
584   function refund() external onlyOwner returns (bool) {
585     require(hasEnded(), "Sale should have ended when refunding");
586     uint256 _tokens = token.balanceOf(address(this));
587 
588     if (_tokens == 0) {
589       return false;
590     }
591 
592     require(token.transfer(owner, _tokens), "Expected token transfer to succeed");
593 
594     emit TokensRefund(_tokens);
595 
596     return true;
597   }
598 
599   /// @notice interface for founders to whitelist investors
600   /// @param _addresses array of investors
601   /// @param _status enable or disable
602   function whitelistAddresses(address[] _addresses, bool _status) public onlyWhitelister {
603     for (uint256 i = 0; i < _addresses.length; i++) {
604       address _investorAddress = _addresses[i];
605       if (whitelist[_investorAddress] != _status) {
606         whitelist[_investorAddress] = _status;
607       }
608     }
609   }
610 
611   function setWhitelister(address _whitelister) public onlyOwner {
612     whitelister = _whitelister;
613   }
614 
615   function checkFinalize() public {
616     if (hasEnded()) {
617       finalize();
618     }
619   }
620 
621   function emergencyFinalize() public onlyOwner {
622     finalize();
623   }
624 
625   function withdraw() public onlyOwner {
626     owner.transfer(address(this).balance);
627   }
628 
629   function hasEnded() public constant returns (bool) {
630     if (isFinalized) {
631       return true;
632     }
633     bool _capReached = weiRaised >= cap;
634     bool _passedEndTime = getBlockTimestamp() > endTime;
635     return _passedEndTime || _capReached;
636   }
637 
638   // @dev does not require that crowdsale `hasEnded()` to leave safegaurd
639   // in place if ETH rises in price too much during crowdsale.
640   // Allows team to close early if cap is exceeded in USD in this event.
641   function finalize() internal {
642     require(!isFinalized, "Should not be finalized when finalizing");
643     emit Finalized();
644     isFinalized = true;
645     token.transferOwnership(owner);
646   }
647 
648   // send ether to the fund collection wallet
649   // override to create custom fund forwarding mechanisms
650   function forwardFunds(uint256 _amount) internal {
651     wallet.transfer(_amount);
652   }
653 
654   function ethToTokens(uint256 _ethAmount) internal view returns (uint256) {
655     return _ethAmount.mul(calculateBonusRate());
656   }
657 
658   function getBlockTimestamp() internal view returns (uint256) {
659     return block.timestamp;
660   }
661 }
662 
663 contract MenloToken is PausableToken, BurnableToken, CanReclaimToken {
664 
665   // Token properties
666   string public constant name = 'Menlo One';
667   string public constant symbol = 'ONE';
668 
669   uint8 public constant decimals = 18;
670   uint256 private constant token_factor = 10**uint256(decimals);
671 
672   // 1 billion ONE tokens in units divisible up to 18 decimals
673   uint256 public constant INITIAL_SUPPLY    = 1000000000 * token_factor;
674 
675   uint256 public constant PUBLICSALE_SUPPLY = 354000000 * token_factor;
676   uint256 public constant GROWTH_SUPPLY     = 246000000 * token_factor;
677   uint256 public constant TEAM_SUPPLY       = 200000000 * token_factor;
678   uint256 public constant ADVISOR_SUPPLY    = 100000000 * token_factor;
679   uint256 public constant PARTNER_SUPPLY    = 100000000 * token_factor;
680 
681   /**
682    * @dev Magic value to be returned upon successful reception of Menlo Tokens
683    */
684   bytes4 internal constant ONE_RECEIVED = 0x150b7a03;
685 
686   address public crowdsale;
687   address public teamTimelock;
688   address public advisorTimelock;
689 
690   modifier notInitialized(address saleAddress) {
691     require(address(saleAddress) == address(0), "Expected address to be null");
692     _;
693   }
694 
695   constructor(address _growth, address _teamTimelock, address _advisorTimelock, address _partner) public {
696     assert(INITIAL_SUPPLY > 0);
697     assert((PUBLICSALE_SUPPLY + GROWTH_SUPPLY + TEAM_SUPPLY + ADVISOR_SUPPLY + PARTNER_SUPPLY) == INITIAL_SUPPLY);
698 
699     uint256 _poolTotal = GROWTH_SUPPLY + TEAM_SUPPLY + ADVISOR_SUPPLY + PARTNER_SUPPLY;
700     uint256 _availableForSales = INITIAL_SUPPLY - _poolTotal;
701 
702     assert(_availableForSales == PUBLICSALE_SUPPLY);
703 
704     teamTimelock = _teamTimelock;
705     advisorTimelock = _advisorTimelock;
706 
707     mint(msg.sender, _availableForSales);
708     mint(_growth, GROWTH_SUPPLY);
709     mint(_teamTimelock, TEAM_SUPPLY);
710     mint(_advisorTimelock, ADVISOR_SUPPLY);
711     mint(_partner, PARTNER_SUPPLY);
712 
713     assert(totalSupply_ == INITIAL_SUPPLY);
714     pause();
715   }
716 
717   function initializeCrowdsale(address _crowdsale) public onlyOwner notInitialized(crowdsale) {
718     unpause();
719     transfer(_crowdsale, balances[msg.sender]);  // Transfer left over balance after private presale allocations
720     crowdsale = _crowdsale;
721     pause();
722     transferOwnership(_crowdsale);
723   }
724 
725   function mint(address _to, uint256 _amount) internal {
726     balances[_to] = _amount;
727     totalSupply_ = totalSupply_.add(_amount);
728     emit Transfer(address(0), _to, _amount);
729   }
730 
731   /**
732    * @dev Safely transfers the ownership of a given token ID to another address
733    * If the target address is a contract, it must implement `onERC721Received`,
734    * which is called upon a safe transfer, and return the magic value `bytes4(0x150b7a03)`;
735    * otherwise, the transfer is reverted.
736    * Requires the msg sender to be the owner, approved, or operator
737    * @param _to address to receive the tokens.  Must be a MenloTokenReceiver based contract
738    * @param _value uint256 number of tokens to transfer
739    * @param _action uint256 action to perform in target _to contract
740    * @param _data bytes data to send along with a safe transfer check
741    **/
742   function transferAndCall(address _to, uint256 _value, uint256 _action, bytes _data) public returns (bool) {
743     if (transfer(_to, _value)) {
744       require (MenloTokenReceiver(_to).onTokenReceived(msg.sender, _value, _action, _data) == ONE_RECEIVED, "Target contract onTokenReceived failed");
745       return true;
746     }
747 
748     return false;
749   }
750 }
751 
752 contract MenloTokenReceiver {
753 
754     /*
755      * @dev Address of the MenloToken contract
756      */
757     MenloToken token;
758 
759     constructor(MenloToken _tokenContract) public {
760         token = _tokenContract;
761     }
762 
763     /**
764      * @dev Magic value to be returned upon successful reception of Menlo Tokens
765      */
766     bytes4 internal constant ONE_RECEIVED = 0x150b7a03;
767 
768     /**
769      * @dev Throws if called by any account other than the Menlo Token contract.
770      */
771     modifier onlyTokenContract() {
772         require(msg.sender == address(token));
773         _;
774     }
775 
776     /**
777      * @notice Handle the receipt of Menlo Tokens
778      * @dev The MenloToken contract calls this function on the recipient
779      * after a `transferAndCall`. This function MAY throw to revert and reject the
780      * transfer. Return of other than the magic value MUST result in the
781      * transaction being reverted.
782      * Warning: this function must call the onlyTokenContract modifier to trust
783      * the transfer took place
784      * @param _from The address which previously owned the token
785      * @param _value Number of tokens that were transfered
786      * @param _action Used to define enumeration of possible functions to call
787      * @param _data Additional data with no specified format
788      * @return `bytes4(0x150b7a03)`
789      */
790     function onTokenReceived(
791         address _from,
792         uint256 _value,
793         uint256 _action,
794         bytes _data
795     ) public /* onlyTokenContract */ returns(bytes4);
796 }
797 
798 contract MenloTokenSale is MenloSaleBase {
799 
800   // Timestamps for the bonus periods, set in the constructor
801   uint256 public HOUR1;
802   uint256 public WEEK1;
803   uint256 public WEEK2;
804   uint256 public WEEK3;
805   uint256 public WEEK4;
806 
807   constructor(
808     MenloToken _token,
809     uint256 _startTime,
810     uint256 _endTime,
811     uint256 _cap,
812     address _wallet
813   ) MenloSaleBase(
814     _token,
815     _startTime,
816     _endTime,
817     _cap,
818     _wallet
819   ) public {
820     HOUR1 = startTime + 1 hours;
821     WEEK1 = startTime + 1 weeks;
822     WEEK2 = startTime + 2 weeks;
823     WEEK3 = startTime + 3 weeks;
824   }
825 
826   // Hour 1: 30% Bonus
827   // Week 1: 15% Bonus
828   // Week 2: 10% Bonus
829   // Week 3: 5% Bonus
830   // Week 4: 0% Bonus
831   function calculateBonusRate() public view returns (uint256) {
832     uint256 _bonusRate = 12000;
833 
834     uint256 _currentTime = getBlockTimestamp();
835     if (_currentTime > startTime && _currentTime <= HOUR1) {
836       _bonusRate =  15600;
837     } else if (_currentTime <= WEEK1) {
838       _bonusRate =  13800; // week 1
839     } else if (_currentTime <= WEEK2) {
840       _bonusRate =  13200; // week 2
841     } else if (_currentTime <= WEEK3) {
842       _bonusRate =  12600; // week 3
843     }
844     return _bonusRate;
845   }
846 
847   function buyTokensHook(uint256 _tokens) internal {
848     token.transfer(msg.sender, _tokens);
849     emit TokenRedeem(msg.sender, _tokens);
850   }
851 }