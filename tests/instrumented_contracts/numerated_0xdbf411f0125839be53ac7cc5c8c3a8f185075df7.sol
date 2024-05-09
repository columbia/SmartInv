1 /**
2  *  PERSONO.ID is WEB 3.0 cornerstone.
3  *  Human first. UBI out of the box. Inevitable.
4  *  This contract is a crowdsale of transitional GUT tokens for ETH.
5  *  Join early. Don't miss the rise of the great, and impressive bounties.
6  *  Open site() at GUT token address 0xbA01AfF9EF5198B5e691D2ac61E3cC126F25491d
7 **/
8 
9 pragma solidity ^0.4.24;
10 
11 /**
12  * @title ERC20 interface
13  */
14 interface IERC20 {
15   function totalSupply() external view returns (uint256);
16 
17   function balanceOf(address who) external view returns (uint256);
18 
19   function allowance(address owner, address spender)
20     external view returns (uint256);
21 
22   function transfer(address to, uint256 value) external returns (bool);
23 
24   function approve(address spender, uint256 value)
25     external returns (bool);
26 
27   function transferFrom(address from, address to, uint256 value)
28     external returns (bool);
29 
30   event Transfer(
31     address indexed from,
32     address indexed to,
33     uint256 value
34   );
35 
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that revert on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, reverts on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54     // benefit is lost if 'b' is also tested.
55     if (a == 0) {
56       return 0;
57     }
58 
59     uint256 c = a * b;
60     require(c / a == b);
61 
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b > 0); // Solidity only automatically asserts when dividing by 0
70     uint256 c = a / b;
71 
72     return c;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     require(b <= a);
80     uint256 c = a - b;
81 
82     return c;
83   }
84 
85   /**
86   * @dev Adds two numbers, reverts on overflow.
87   */
88   function add(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a + b;
90     require(c >= a);
91 
92     return c;
93   }
94 
95   /**
96   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
97   * reverts when dividing by zero.
98   */
99   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100     require(b != 0);
101     return a % b;
102   }
103 }
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @notice The full implementation is in the token. Here it is just for correct compilation. 
109  */
110 contract ERC20 is IERC20 {
111   /**
112    * @dev Internal ERC20 token function that mints an amount of the token and assigns it to
113    * an account. This encapsulates the modification of balances such that the
114    * proper events are emitted.
115    * @param account The account that will receive the created tokens.
116    * @param value The amount that will be created.
117    */
118   function _mint(address account, uint256 value) internal;
119 }
120 
121 /**
122  * @title Roles
123  * @dev Library for managing addresses assigned to a Role.
124  */
125 library Roles {
126   struct Role {
127     mapping (address => bool) bearer;
128   }
129 
130   /**
131    * @dev give an account access to this role
132    */
133   function add(Role storage role, address account) internal {
134     require(account != address(0));
135     require(!has(role, account));
136 
137     role.bearer[account] = true;
138   }
139 
140   /**
141    * @dev remove an account's access to this role
142    */
143   function remove(Role storage role, address account) internal {
144     require(account != address(0));
145     require(has(role, account));
146 
147     role.bearer[account] = false;
148   }
149 
150   /**
151    * @dev check if an account has this role
152    * @return bool
153    */
154   function has(Role storage role, address account)
155     internal
156     view
157     returns (bool)
158   {
159     require(account != address(0));
160     return role.bearer[account];
161   }
162 }
163 
164 contract MinterRole {
165   using Roles for Roles.Role;
166 
167   event MinterAdded(address indexed account);
168   event MinterRemoved(address indexed account);
169 
170   Roles.Role private minters;
171 
172   constructor() internal {
173     _addMinter(msg.sender);
174   }
175 
176   modifier onlyMinter() {
177     require(isMinter(msg.sender));
178     _;
179   }
180 
181   function isMinter(address account) public view returns (bool) {
182     return minters.has(account);
183   }
184 
185   function addMinter(address account) public onlyMinter {
186     _addMinter(account);
187   }
188 
189   function renounceMinter() public {
190     _removeMinter(msg.sender);
191   }
192 
193   function _addMinter(address account) internal {
194     minters.add(account);
195     emit MinterAdded(account);
196   }
197 
198   function _removeMinter(address account) internal {
199     minters.remove(account);
200     emit MinterRemoved(account);
201   }
202 }
203 
204 /**
205  * @title ERC20Mintable
206  * @dev ERC20 minting logic. Shortened. Full contract is in the GutTCO.token() contract.
207  */
208 contract ERC20Mintable is ERC20, MinterRole {
209   
210   /**
211    * @dev Function to mint tokens
212    * @param to The address that will receive the minted tokens.
213    * @param value The amount of tokens to mint.
214    * @return A boolean that indicates if the operation was successful.
215    */
216   function mint(
217     address to,
218     uint256 value
219   )
220     public
221     onlyMinter
222     returns (bool)
223   {
224     _mint(to, value);
225     return true;
226   }
227 }
228 
229 /**
230  * @title SafeERC20
231  * @notice Shortened Wrappers around ERC20 operations that throw on failure.
232  */
233 library SafeERC20 {
234 
235   using SafeMath for uint256;
236 
237   function safeTransfer(
238     IERC20 token,
239     address to,
240     uint256 value
241   )
242     internal
243   {
244     require(token.transfer(to, value));
245   }
246 }
247 
248 /**
249  * @title Helps contracts guard against reentrancy attacks.
250  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
251  * @dev If you mark a function `nonReentrant`, you should also
252  * mark it `external`.
253  */
254 contract ReentrancyGuard {
255 
256   /// @dev counter to allow mutex lock with only one SSTORE operation
257   uint256 private _guardCounter;
258 
259   constructor() internal {
260     // The counter starts at one to prevent changing it from zero to a non-zero
261     // value, which is a more expensive operation.
262     _guardCounter = 1;
263   }
264 
265   /**
266    * @notice Prevents a contract from calling itself, directly or indirectly.
267    */
268   modifier nonReentrant() {
269     _guardCounter += 1;
270     uint256 localCounter = _guardCounter;
271     _;
272     require(localCounter == _guardCounter);
273   }
274 
275 }
276 
277 /**
278  * @title Crowdsale
279  * @notice Crowdsale is a base contract for managing a token crowdsale,
280  * allowing investors to purchase tokens with ether. This contract implements
281  * such functionality in its most fundamental form and is extended by other contracts here to provide additional
282  * functionality and custom behavior.
283  */
284 contract Crowdsale is ReentrancyGuard {
285   using SafeMath for uint256;
286   using SafeERC20 for IERC20;
287 
288   // The token being sold
289   IERC20 private _token;
290 
291   // Address where funds are collected
292   address private _wallet;
293 
294   // How many token units a buyer would get per wei. 
295   // Usually is the conversion between wei and the smallest and indivisible token unit.
296   // Overridden by IcreasingPriceTCO contract logic.
297   uint256 private _rate;
298 
299   // Amount of wei raised
300   uint256 private _weiRaised;
301 
302   /**
303    * Event for token purchase logging
304    * @param purchaser who paid for the tokens
305    * @param beneficiary who got the tokens
306    * @param value weis paid for purchase
307    * @param amount amount of tokens purchased
308    */
309   event TokensPurchased(
310     address indexed purchaser,
311     address indexed beneficiary,
312     uint256 value,
313     uint256 amount
314   );
315 
316   /**
317    * @param rate Number of token units a buyer gets per wei
318    * @dev The rate is the conversion between wei and the smallest and indivisible
319    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
320    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
321    * @param wallet Address where collected funds will be forwarded to
322    * @param token Address of the token being sold
323    */
324   constructor(uint256 rate, address wallet, IERC20 token) internal {
325     require(rate > 0);
326     require(wallet != address(0));
327     require(token != address(0));
328 
329     _rate = rate;
330     _wallet = wallet;
331     _token = token;
332   }
333 
334   // -----------------------------------------
335   // Crowdsale external interface
336   // -----------------------------------------
337 
338   /**
339    * @dev fallback function ***DO NOT OVERRIDE***
340    * Note that other contracts will transfer fund with a base gas stipend
341    * of 2300, which is not enough to call buyTokens. Consider calling
342    * buyTokens directly when purchasing tokens from a contract.
343    */
344   function () external payable {
345     buyTokens(msg.sender);
346   }
347 
348   /**
349    * @return the token being sold.
350    */
351   function token() public view returns(IERC20) {
352     return _token;
353   }
354 
355   /**
356    * @return the address where funds are collected.
357    */
358   function wallet() public view returns(address) {
359     return _wallet;
360   }
361 
362   /**
363    * @return the number of token units a buyer gets per wei.
364    */
365   function rate() public view returns(uint256) {
366     return _rate;
367   }
368 
369   /**
370    * @return the amount of wei raised.
371    */
372   function weiRaised() public view returns (uint256) {
373     return _weiRaised;
374   }
375 
376   /**
377    * @dev low level token purchase ***DO NOT OVERRIDE***
378    * This function has a non-reentrancy guard, so it shouldn't be called by
379    * another `nonReentrant` function.
380    * @param beneficiary Recipient of the token purchase
381    */
382   function buyTokens(address beneficiary) public nonReentrant payable {
383 
384     uint256 weiAmount = msg.value;
385     _preValidatePurchase(beneficiary, weiAmount);
386 
387     // calculate token amount to be created
388     uint256 tokens = _getTokenAmount(weiAmount);
389 
390     // update state
391     _weiRaised = _weiRaised.add(weiAmount);
392 
393     _processPurchase(beneficiary, tokens);
394     emit TokensPurchased(
395       msg.sender,
396       beneficiary,
397       weiAmount,
398       tokens
399     );
400 
401     _updatePurchasingState(beneficiary, weiAmount); //check and manage current exchange rate and hard cap
402     _forwardFunds(); //save funds to a Persono.id Foundation address
403     _postValidatePurchase(beneficiary, weiAmount); 
404   }
405 
406   // -----------------------------------------
407   // Internal interface (extensible)
408   // -----------------------------------------
409 
410   /**
411    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
412    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
413    *   super._preValidatePurchase(beneficiary, weiAmount);
414    *   require(weiRaised().add(weiAmount) <= cap);
415    * @param beneficiary Address performing the token purchase
416    * @param weiAmount Value in wei involved in the purchase
417    */
418   function _preValidatePurchase(
419     address beneficiary,
420     uint256 weiAmount
421   )
422     internal
423     view
424   {
425     require(beneficiary != address(0));
426     require(weiAmount != 0);
427   }
428 
429   /**
430    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
431    * @param beneficiary Address performing the token purchase
432    * @param weiAmount Value in wei involved in the purchase
433    */
434   function _postValidatePurchase(
435     address beneficiary,
436     uint256 weiAmount
437   )
438     internal
439     view
440   {
441     // optional override
442   }
443 
444   /**
445    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
446    * @param beneficiary Address performing the token purchase
447    * @param tokenAmount Number of tokens to be emitted
448    */
449   function _deliverTokens(
450     address beneficiary,
451     uint256 tokenAmount
452   )
453     internal
454   {
455     _token.safeTransfer(beneficiary, tokenAmount);
456   }
457 
458   /**
459    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
460    * @param beneficiary Address receiving the tokens
461    * @param tokenAmount Number of tokens to be purchased
462    */
463   function _processPurchase(
464     address beneficiary,
465     uint256 tokenAmount
466   )
467     internal
468   {
469     _deliverTokens(beneficiary, tokenAmount);
470   }
471 
472   /**
473    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
474    * @param beneficiary Address receiving the tokens
475    * @param weiAmount Value in wei involved in the purchase
476    */
477   function _updatePurchasingState(
478     address beneficiary,
479     uint256 weiAmount
480   )
481     internal
482   {
483     // optional override
484   }
485 
486   /**
487    * @dev Override to extend the way in which ether is converted to tokens.
488    * @param weiAmount Value in wei to be converted into tokens
489    * @return Number of tokens that can be purchased with the specified _weiAmount
490    */
491   function _getTokenAmount(uint256 weiAmount)
492     internal view returns (uint256)
493   {
494     return weiAmount.mul(_rate);
495   }
496 
497   /**
498    * @dev Determines how ETH is stored/forwarded on purchases.
499    */
500   function _forwardFunds() internal {
501     _wallet.transfer(msg.value);
502   }
503 }
504 
505 /**
506  * @title IncreasingPriceTCO
507  * @notice Extension of Crowdsale contract that increases the price of tokens according to price ranges. 
508  * Early adopters get up to 24 times more benefits.
509  */
510 contract IncreasingPriceTCO is Crowdsale {
511     using SafeMath for uint256;
512 
513     uint256[2][] private _rates; //_rates[i][0] - upper limit of total weiRaised to apply _rates[i][1] exchange rate at the 
514     uint8 private _currentRateIndex; // Index of the current rate: _rates[_currentIndex][1] is the current rate index
515 
516     event NewRateIsSet(
517     uint8 rateIndex,
518     uint256 exRate,
519     uint256 weiRaisedRange,
520     uint256 weiRaised
521   );
522   /**
523    * @param initRates Is an array of pairs [weiRaised, exchangeRate]. Deteremine the exchange rate depending on the total wei raised before the transaction. 
524   */
525   constructor(uint256[2][] memory initRates) internal {
526     require(initRates.length > 1, 'Rates array should contain more then one value');
527     _rates = initRates;
528     _currentRateIndex = 0;
529   }
530  
531   function getCurrentRate() public view returns(uint256) {
532     return _rates[_currentRateIndex][1];
533   }
534 
535   modifier ifExRateNeedsUpdate {
536     if(weiRaised() >= _rates[_currentRateIndex][0] && _currentRateIndex < _rates.length - 1)
537       _;
538   }
539 
540   /**
541    * @notice The new exchange rate is set if total weiRased() exceeds the current exchange rate range 
542    */
543   function _updateCurrentRate() internal ifExRateNeedsUpdate {
544     uint256 _weiRaised = weiRaised();
545     _currentRateIndex++; //the modifier ifExRateNeedsUpdate means the exchange rate is changed, so we move to the next range right away
546     while(_currentRateIndex < _rates.length - 1 && _rates[_currentRateIndex][0] <= _weiRaised) {
547       _currentRateIndex++;
548     }
549     emit NewRateIsSet(_currentRateIndex, //new exchange rate index
550                       _rates[_currentRateIndex][1], //new exchange rate 
551                       _rates[_currentRateIndex][0], //new exchange rate _weiRaised limit
552                       _weiRaised); //amount of _weiRaised by the moment the new exchange rate is applied
553   }
554 
555   /**
556    * @notice The base rate function is overridden to revert, since this crowdsale doens't use it, and
557    * all calls to it are a mistake.
558    */
559   function rate() public view returns(uint256) {
560     revert();
561   }
562   
563   /**
564    * @notice Overrides function applying multiple increasing price exchange rates concept
565    */
566   function _getTokenAmount(uint256 weiAmount)
567     internal view returns (uint256)
568   {
569     return getCurrentRate().mul(weiAmount);
570   }
571 
572   /**
573    * @notice Overrides a "hook" from the base Crowdsale contract. Checks and updates the current exchange rate. 
574    */
575   function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal
576   {
577     _updateCurrentRate();
578   }
579 }
580 
581 contract KeeperRole {
582   using Roles for Roles.Role;
583 
584   event KeeperAdded(address indexed account);
585   event KeeperRemoved(address indexed account);
586 
587   Roles.Role private keepers;
588 
589   constructor() internal {
590     _addKeeper(msg.sender);
591   }
592 
593   modifier onlyKeeper() {
594     require(isKeeper(msg.sender), 'Only Keeper is allowed');
595     _;
596   }
597 
598   function isKeeper(address account) public view returns (bool) {
599     return keepers.has(account);
600   }
601 
602   function addKeeper(address account) public onlyKeeper {
603     _addKeeper(account);
604   }
605 
606   function renounceKeeper() public {
607     _removeKeeper(msg.sender);
608   }
609 
610   function _addKeeper(address account) internal {
611     keepers.add(account);
612     emit KeeperAdded(account);
613   }
614 
615   function _removeKeeper(address account) internal {
616     keepers.remove(account);
617     emit KeeperRemoved(account);
618   }
619 }
620 
621 contract PauserRole {
622   using Roles for Roles.Role;
623 
624   event PauserAdded(address indexed account);
625   event PauserRemoved(address indexed account);
626 
627   Roles.Role private pausers;
628 
629   constructor() internal {
630     _addPauser(msg.sender);
631   }
632 
633   modifier onlyPauser() {
634     require(isPauser(msg.sender));
635     _;
636   }
637 
638   function isPauser(address account) public view returns (bool) {
639     return pausers.has(account);
640   }
641 
642   function addPauser(address account) public onlyPauser {
643     _addPauser(account);
644   }
645 
646   function renouncePauser() public {
647     _removePauser(msg.sender);
648   }
649 
650   function _addPauser(address account) internal {
651     pausers.add(account);
652     emit PauserAdded(account);
653   }
654 
655   function _removePauser(address account) internal {
656     pausers.remove(account);
657     emit PauserRemoved(account);
658   }
659 }
660 
661 /**
662  * @title Haltable
663  * @dev Base contract which allows children to implement an emergency pause mechanism 
664  * and close irreversibly
665  */
666 contract Haltable is KeeperRole, PauserRole {
667   event Paused(address account);
668   event Unpaused(address account);
669   event Closed(address account);
670 
671   bool private _paused;
672   bool private _closed;
673 
674   constructor() internal {
675     _paused = false;
676     _closed = false;
677   }
678 
679   /**
680    * @return true if the contract is paused, false otherwise.
681    */
682   function paused() public view returns(bool) {
683     return _paused;
684   }
685 
686   /**
687    * @return true if the contract is closed, false otherwise.
688    */
689   function isClosed() public view returns(bool) {
690     return _closed;
691   }
692 
693   /**
694    * @return true if the contract is not closed, false otherwise.
695    */
696   function notClosed() public view returns(bool) {
697     return !_closed;
698   }
699 
700   /**
701    * @notice Modifier to make a function callable only when the contract is not paused.
702    */
703   modifier whenNotPaused() {
704     require(!_paused, 'The contract is paused');
705     _;
706   }
707 
708   /**
709    * @notice Modifier to make a function callable only when the contract is paused.
710    */
711   modifier whenPaused() {
712     require(_paused, 'The contract is not paused');
713     _;
714   }
715 
716   /**
717    * @dev Modifier to make a function callable only when the contract is closed.
718    */
719   modifier whenClosed(bool orCondition) {
720     require(_closed, 'The contract is not closed');
721     _;
722   }
723 
724   /**
725    * @dev Modifier to make a function callable only when the contract is closed or an external condition is met.
726    */
727   modifier whenClosedOr(bool orCondition) {
728     require(_closed || orCondition, "It must be closed or what is set in 'orCondition'");
729     _;
730   }
731 
732   /**
733    * @dev Modifier to make a function callable only when the contract is not closed.
734    */
735   modifier whenNotClosed() {
736     require(!_closed, "Reverted because it is closed");
737     _;
738   }
739 
740   /**
741    * @dev called by the owner to pause, triggers stopped state
742    */
743   function pause() public onlyPauser whenNotPaused {
744     _paused = true;
745     emit Paused(msg.sender);
746   }
747 
748   /**
749    * @dev called by the owner to unpause, returns to normal state
750    */
751   function unpause() public onlyPauser whenPaused {
752     _paused = false;
753     emit Unpaused(msg.sender);
754   }
755 
756   /**
757    * @dev Called by a Keeper to close a contract. This is irreversible.
758    */
759   function close() internal whenNotClosed {
760     _closed = true;
761     emit Closed(msg.sender);
762   }
763 }
764 
765 /**
766  * @title CappedCrowdsale
767  * @dev Crowdsale with a limit for total contributions.
768  */
769 contract CappedTCO is Crowdsale {
770   using SafeMath for uint256;
771   uint256 private _cap;
772   
773   /**
774    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
775    * @param cap Max amount of wei to be contributed
776    */
777   constructor(uint256 cap) internal {
778       require(cap > 0, 'Hard cap must be > 0');
779       _cap = cap;
780   }
781   
782   /**
783    * @return the cap of the crowdsale.
784    */
785   function cap() public view returns(uint256) {
786       return _cap;
787   }
788   
789   /**
790    * @dev Checks whether the cap has been reached.
791    * @return Whether the cap was not reached
792    */
793   function capNotReached() public view returns (bool) {
794       return weiRaised() < _cap;
795   }
796   
797   /**
798    * @dev Checks whether the cap has been reached.
799    * @return Whether the cap was reached
800    */
801   function capReached() public view returns (bool) {
802       return weiRaised() >= _cap;
803   }
804 }
805 
806 /**
807  * @title PostDeliveryCappedCrowdsale
808  * @notice Hardcapped crowdsale with the gained tokens locked from withdrawal until the crowdsale ends.
809  */
810 contract PostDeliveryCappedTCO is CappedTCO, Haltable {
811   using SafeMath for uint256;
812 
813   mapping(address => uint256) private _balances; //token balances storage until the crowdsale ends
814 
815   uint256 private _totalSupply; //total GUT distributed amount
816 
817   event TokensWithdrawn(
818     address indexed beneficiary,
819     uint256 amount
820   );
821 
822   constructor() internal {}
823 
824   /**
825    * @notice Withdraw tokens only after the crowdsale ends (closed).
826    * @param beneficiary is an address whose tokens will be withdrawn. Allows to use a separate address 
827    * @notice Withdrawal is suspended in case the crowdsale is paused.
828    */
829   function withdrawTokensFrom(address beneficiary) public whenNotPaused whenClosedOr(capReached()) {
830     uint256 amount = _balances[beneficiary];
831     require(amount > 0, 'The balance should be positive for withdrawal. Please check the balance in the token contract.');
832     _balances[beneficiary] = 0;
833     _deliverTokens(beneficiary, amount);
834     emit TokensWithdrawn(beneficiary, amount);
835   }
836 
837   /**
838    * @notice If calling this function (wothdrawing) from a contract, use withdrawTokensFrom(address beneficiary)
839    * Check that crowdsale is finished: GutTCO.isClosed() == true before running this function (withdrawing tokens).
840    */
841   function withdrawTokens() public {
842     withdrawTokensFrom(address(msg.sender));
843   }
844 
845   /**
846    * @notice Total amount of tokens supplied
847    */
848   function totalSupply() public view returns (uint256) {
849     return _totalSupply;
850   }
851 
852   /**
853    * @return the balance of an account.
854    */
855   function balanceOf(address account) public view returns(uint256) {
856     return _balances[account];
857   }
858 
859   /**
860    * @dev Extend parent behavior requiring purchase to respect the funding cap.
861    * @param beneficiary Token purchaser
862    * @param weiAmount Amount of wei contributed
863    */
864   function _preValidatePurchase(
865       address beneficiary,
866       uint256 weiAmount
867   )
868       internal
869       view
870   {
871       require(capNotReached(),"Hardcap is reached.");
872       require(notClosed(), "TCO is finished, sorry.");
873       super._preValidatePurchase(beneficiary, weiAmount);
874   }
875 
876   /**
877    * @dev Overrides parent by storing balances instead of issuing tokens right away
878    * @param beneficiary Token purchaser
879    * @param tokenAmount Amount of tokens purchased
880    */
881   function _processPurchase(
882     address beneficiary,
883     uint256 tokenAmount
884   )
885     internal
886   {
887     _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
888     _totalSupply = _totalSupply.add(tokenAmount);
889   }
890 }
891 
892 /**
893  * @notice If you transfer funds (ETH) from a contract, the default gas stipend 2300 will not be enough 
894  * to complete transaction to your contract address. Please, consider calling buyTokens() directly when
895  * purchasing tokens from a contract.
896 */
897 contract GutTCO is 
898 PostDeliveryCappedTCO, 
899 IncreasingPriceTCO, 
900 MinterRole
901 {
902     bool private _finalized;
903 
904     event CrowdsaleFinalized();
905 
906     constructor(
907     uint256 _rate,
908     address _wallet,
909     uint256 _cap,
910     ERC20Mintable _token
911   ) public 
912   Crowdsale(_rate, _wallet, _token)
913   CappedTCO(_cap)
914   IncreasingPriceTCO(initRates())
915   {
916     _finalized = false;
917   }
918 
919   /**
920    * @notice Initializes exchange rates ranges.
921    */
922   function initRates() internal pure returns(uint256[2][] memory ratesArray) {
923      ratesArray = new uint256[2][](4);
924      ratesArray[0] = [uint256(100000 ether), 3000]; //first 100000 ether are given 3000 GUT each
925      ratesArray[1] = [uint256(300000 ether), 1500]; //next 200000 (up to 300000) ether are exchanged at 1500 GUT/ether 
926      ratesArray[2] = [uint256(700000 ether), 500];  //next 400000 ether will go to Persono.id Foundation at 500 GUT/ether
927      ratesArray[3] = [uint256(1500000 ether), 125]; //the rest 800000 ether are exchanged at 125 GUT/ether
928   }
929 
930   function closeTCO() public onlyMinter {
931      if(notFinalized()) _finalize();
932   }
933 
934   /**
935    * @return true if the crowdsale is finalized, false otherwise.
936    */
937   function finalized() public view returns (bool) {
938     return _finalized;
939   }
940 
941   /**
942    * @return true if the crowdsale is finalized, false otherwise.
943    */
944   function notFinalized() public view returns (bool) {
945     return !finalized();
946   }
947 
948   /**
949    * @notice Is called after TCO finished to close() TCO and transfer (mint) supplied tokens to the token's contract.
950    */
951   function _finalize() private {
952     require(notFinalized(), 'TCO already finalized');
953     if(notClosed()) close();
954     _finalization();
955     emit CrowdsaleFinalized();
956   }
957 
958   function _finalization() private {
959      if(totalSupply() > 0)
960         require(ERC20Mintable(address(token())).mint(address(this), totalSupply()), 'Error when being finalized at minting totalSupply() to the token');
961      _finalized = true;
962   }
963 
964   /**
965    * @notice Overrides IncreasingPriceTCO. Auto finalize TCO when the cap is reached.
966    */
967   function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal 
968   {
969     super._updatePurchasingState(beneficiary, weiAmount);
970     if(capReached()) _finalize();
971   }
972 }