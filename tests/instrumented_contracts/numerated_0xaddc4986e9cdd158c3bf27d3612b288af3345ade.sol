1 pragma solidity ^0.5.12;
2 
3 /**
4  * @title Helps contracts guard against reentrancy attacks.
5  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
6  * @dev If you mark a function `nonReentrant`, you should also
7  * mark it `external`.
8  */
9 contract ReentrancyGuard {
10     /// @dev counter to allow mutex lock with only one SSTORE operation
11     uint256 private _guardCounter;
12 
13     constructor () internal {
14         // The counter starts at one to prevent changing it from zero to a non-zero
15         // value, which is a more expensive operation.
16         _guardCounter = 1;
17     }
18 
19     /**
20      * @dev Prevents a contract from calling itself, directly or indirectly.
21      * Calling a `nonReentrant` function from another `nonReentrant`
22      * function is not supported. It is possible to prevent this from happening
23      * by making the `nonReentrant` function external, and make it call a
24      * `private` function that does the actual work.
25      */
26     modifier nonReentrant() {
27         _guardCounter += 1;
28         uint256 localCounter = _guardCounter;
29         _;
30         require(localCounter == _guardCounter);
31     }
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Unsigned math operations with safety checks that revert on error
37  */
38 library SafeMath {
39     /**
40     * @dev Multiplies two unsigned integers, reverts on overflow.
41     */
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
44         // benefit is lost if 'b' is also tested.
45         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
46         if (a == 0) {
47             return 0;
48         }
49 
50         uint256 c = a * b;
51         require(c / a == b);
52 
53         return c;
54     }
55 
56     /**
57     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
58     */
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Solidity only automatically asserts when dividing by 0
61         require(b > 0);
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64 
65         return c;
66     }
67 
68     /**
69     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
70     */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b <= a);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79     * @dev Adds two unsigned integers, reverts on overflow.
80     */
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a);
84 
85         return c;
86     }
87 
88     /**
89     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
90     * reverts when dividing by zero.
91     */
92     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
93         require(b != 0);
94         return a % b;
95     }
96 }
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable {
104     address private _owner;
105 
106     event OwnershipTransferred(address previousOwner, address newOwner);
107 
108     /**
109      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
110      * account.
111      */
112     constructor () internal {
113         _owner = msg.sender;
114         emit OwnershipTransferred(address(0), _owner);
115     }
116 
117     /**
118      * @return the address of the owner.
119      */
120     function owner() public view returns (address) {
121         return _owner;
122     }
123 
124     /**
125      * @dev Throws if called by any account other than the owner.
126      */
127     modifier onlyOwner() {
128         require(isOwner());
129         _;
130     }
131 
132     /**
133      * @return true if `msg.sender` is the owner of the contract.
134      */
135     function isOwner() public view returns (bool) {
136         return msg.sender == _owner;
137     }
138 
139     /**
140      * @dev Allows the current owner to relinquish control of the contract.
141      * @notice Renouncing to ownership will leave the contract without an owner.
142      * It will not be possible to call the functions with the `onlyOwner`
143      * modifier anymore.
144      */
145     function renounceOwnership() public onlyOwner {
146         emit OwnershipTransferred(_owner, address(0));
147         _owner = address(0);
148     }
149 
150     /**
151      * @dev Allows the current owner to transfer control of the contract to a newOwner.
152      * @param newOwner The address to transfer ownership to.
153      */
154     function transferOwnership(address newOwner) public onlyOwner {
155         _transferOwnership(newOwner);
156     }
157 
158     /**
159      * @dev Transfers control of the contract to a newOwner.
160      * @param newOwner The address to transfer ownership to.
161      */
162     function _transferOwnership(address newOwner) internal {
163         require(newOwner != address(0));
164         emit OwnershipTransferred(_owner, newOwner);
165         _owner = newOwner;
166     }
167 }
168 
169 /**
170  * @title Roles
171  * @dev Library for managing addresses assigned to a Role.
172  */
173 library Roles {
174     struct Role {
175         mapping (address => bool) bearer;
176     }
177 
178     /**
179      * @dev give an account access to this role
180      */
181     function add(Role storage role, address account) internal {
182         require(account != address(0));
183         require(!has(role, account));
184 
185         role.bearer[account] = true;
186     }
187 
188     /**
189      * @dev remove an account's access to this role
190      */
191     function remove(Role storage role, address account) internal {
192         require(account != address(0));
193         require(has(role, account));
194 
195         role.bearer[account] = false;
196     }
197 
198     /**
199      * @dev check if an account has this role
200      * @return bool
201      */
202     function has(Role storage role, address account) internal view returns (bool) {
203         require(account != address(0));
204         return role.bearer[account];
205     }
206 }
207 
208 contract PauserRole {
209     using Roles for Roles.Role;
210 
211     event PauserAdded(address indexed account);
212     event PauserRemoved(address indexed account);
213 
214     Roles.Role private _pausers;
215 
216     constructor () internal {
217         _addPauser(msg.sender);
218     }
219 
220     modifier onlyPauser() {
221         require(isPauser(msg.sender));
222         _;
223     }
224 
225     function isPauser(address account) public view returns (bool) {
226         return _pausers.has(account);
227     }
228 
229     function addPauser(address account) public onlyPauser {
230         _addPauser(account);
231     }
232 
233     function renouncePauser() public {
234         _removePauser(msg.sender);
235     }
236 
237     function _addPauser(address account) internal {
238         _pausers.add(account);
239         emit PauserAdded(account);
240     }
241 
242     function _removePauser(address account) internal {
243         _pausers.remove(account);
244         emit PauserRemoved(account);
245     }
246 }
247 
248 /**
249  * @title Pausable
250  * @dev Base contract which allows children to implement an emergency stop mechanism.
251  */
252 contract Pausable is PauserRole {
253     event Paused(address account);
254     event Unpaused(address account);
255 
256     bool private _paused;
257 
258     constructor () internal {
259         _paused = false;
260     }
261 
262     /**
263      * @return true if the contract is paused, false otherwise.
264      */
265     function paused() public view returns (bool) {
266         return _paused;
267     }
268 
269     /**
270      * @dev Modifier to make a function callable only when the contract is not paused.
271      */
272     modifier whenNotPaused() {
273         require(!_paused);
274         _;
275     }
276 
277     /**
278      * @dev Modifier to make a function callable only when the contract is paused.
279      */
280     modifier whenPaused() {
281         require(_paused);
282         _;
283     }
284 
285     /**
286      * @dev called by the owner to pause, triggers stopped state
287      */
288     function pause() public onlyPauser whenNotPaused {
289         _paused = true;
290         emit Paused(msg.sender);
291     }
292 
293     /**
294      * @dev called by the owner to unpause, returns to normal state
295      */
296     function unpause() public onlyPauser whenPaused {
297         _paused = false;
298         emit Unpaused(msg.sender);
299     }
300 }
301 
302 /// @title Admin contract for CheezyExchange. This contract manages fees and
303 ///  imports administrative functions.
304 contract CheezyExchangeAdmin is Ownable, Pausable, ReentrancyGuard {
305 
306     /* ****** */
307     /* EVENTS */
308     /* ****** */
309 
310     /// @notice This event is fired when the developer changes the fee applied
311     ///  to successful trades. The fee is measured in basis points (hundredths
312     ///  of a percent).
313     /// @param newSuccessfulTradeFeeInBasisPoints  The new fee applying to
314     ///  successful trades (measured in basis points/hundredths of a percent).
315     event SuccessfulTradeFeeInBasisPointsUpdated(uint256 newSuccessfulTradeFeeInBasisPoints);
316 
317     /* ******* */
318     /* STORAGE */
319     /* ******* */
320 
321     /// @notice The amount of fees collected (in wei). This includes both fees to
322     ///  the contract owner and fees to any referrers. Storing earnings saves
323     ///  gas rather than performing an additional transfer() call on every
324     ///  successful trade.
325     mapping (address => uint256) public addressToFeeEarnings;
326 
327     /// @notice If a trade is successfully fulfilled, this fee applies before
328     ///  the remaining funds are sent to the seller. This fee is measured in
329     ///  basis points (hundredths of a percent), and is taken out of the total
330     ///  value that the seller asked for when creating their order.
331     uint256 public successfulTradeFeeInBasisPoints = 375;
332 
333     /* ********* */
334     /* CONSTANTS */
335     /* ********* */
336 
337     /// @notice The address of Core CheezeWizards contract, handling the ownership
338     ///  and approval logic for any particular wizard.
339     address public wizardGuildAddress = 0x0d8c864DA1985525e0af0acBEEF6562881827bd5;
340 
341     /* ********* */
342     /* FUNCTIONS */
343     /* ********* */
344 
345     /// @dev The owner is not capable of changing the address of the
346     ///  CheezeWizards Core contract once the contract has been deployed.
347     constructor() internal {
348 
349     }
350 
351     /// @notice Sets the successfulTradeFeeInBasisPoints value (in basis
352     ///  points). Any trades that are successfully fulfilled will have this fee
353     ///  deducted from amount sent to the seller.
354     /// @dev Only callable by the owner.
355     /// @dev As this configuration is a basis point, the value to set must be
356     ///  less than or equal to 10000.
357     /// @param _newSuccessfulTradeFeeInBasisPoints  The
358     ///  successfulTradeFeeInBasisPoints value to set (measured in basis
359     ///  points).
360     function setSuccessfulTradeFeeInBasisPoints(uint256 _newSuccessfulTradeFeeInBasisPoints) external onlyOwner {
361         require(_newSuccessfulTradeFeeInBasisPoints <= 10000, 'new successful trade fee must be in basis points (hundredths of a percent), not wei');
362         successfulTradeFeeInBasisPoints = _newSuccessfulTradeFeeInBasisPoints;
363         emit SuccessfulTradeFeeInBasisPointsUpdated(_newSuccessfulTradeFeeInBasisPoints);
364     }
365 
366     /// @notice Withdraws the fees that have been earned by either the contract
367     ///  owner or referrers.
368     /// @notice Only callable by the address that had earned the fees.
369     function withdrawFeeEarningsForAddress() external nonReentrant {
370         uint256 balance = addressToFeeEarnings[msg.sender];
371         require(balance > 0, 'there are no fees to withdraw for this address');
372         addressToFeeEarnings[msg.sender] = 0;
373         msg.sender.transfer(balance);
374     }
375 
376     /// @notice Gives the authority for the contract owner to remove any
377     ///  additional accounts that have been granted the ability to pause the
378     ///  contract
379     /// @dev Only callable by the owner.
380     /// @param _account  The account to have the ability to pause the contract
381     ///  revoked
382     function removePauser(address _account) external onlyOwner {
383         _removePauser(_account);
384     }
385 
386     /// @dev By calling 'revert' in the fallback function, we prevent anyone
387     ///  from accidentally sending funds directly to this contract.
388     function() external payable {
389         revert();
390     }
391 }
392 
393 /// @title Interface for interacting with the CheezeWizards Core contract
394 ///  created by Dapper Labs Inc.
395 contract WizardGuild {
396     function ownerOf(uint256 tokenId) public view returns (address owner);
397     function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
398 }
399 
400 /// @title Interface for interacting with the BasicTournament contract created
401 ///  by Dapper Labs Inc.
402 contract BasicTournament {
403     function getWizard(uint256 wizardId) public view returns(
404         uint256 affinity,
405         uint256 power,
406         uint256 maxPower,
407         uint256 nonce,
408         bytes32 currentDuel,
409         bool ascending,
410         uint256 ascensionOpponent,
411         bool molded,
412         bool ready
413     );
414     function giftPower(uint256 sendingWizardId, uint256 receivingWizardId) external;
415 }
416 
417 /// @title Convenience contract for CheezyExchange to retrieve Tournament Times
418 ///  from a basic tournament contract.
419 /// @notice Unfortunately, the CheezeWizard's official contracts do not have a
420 ///  getter function for checking whether we are in a fight window, etc. Since
421 ///  CheezyExchange power transfers can only occur duringFightWindow, we had to
422 ///  re-write all of the CheezeWizards TournamentTime logic simply to get a
423 ///  getter function for checking whether we are duringFightWindow.
424 contract CheezyExchangeTournamentTime {
425 
426     /// @notice The following struct was copied directly from CheezeWizards
427     ///  TournamentTimeAbstract contract in order to replicate much of its
428     ///  functionality.
429     // The data needed to check if we are in a given Window
430     struct WindowParameters {
431         // The block number that the first window of this type begins
432         uint48 firstWindowStartBlock;
433 
434         // A copy of the pause ending block, copied into this storage slot to
435         // save gas
436         uint48 pauseEndedBlock;
437 
438         // The length of an entire "session" (see above for definitions), ALL
439         // windows repeat with a period of one session.
440         uint32 sessionDuration;
441 
442         // The duration of this window
443         uint32 windowDuration;
444     }
445 
446     /// @notice The following function was copied directly from CheezeWizards
447     ///  TournamentTimeAbstract contract in order to replicate much of its
448     ///  functionality.
449     // An internal convenience function that checks to see if we are currently
450     // in the Window defined by the WindowParameters struct passed as an
451     // argument.
452     function _isInWindow(WindowParameters memory localParams) internal view returns (bool) {
453         // We are never "in a window" if the contract is paused
454         if (block.number < localParams.pauseEndedBlock) {
455             return false;
456         }
457 
458         // If we are before the first window of this type, we are obviously NOT
459         // in this window!
460         if (block.number < localParams.firstWindowStartBlock) {
461             return false;
462         }
463 
464         // Use modulus to figure out how far we are past the beginning of the
465         // most recent window
466         // of this type
467         uint256 windowOffset = (block.number - localParams.firstWindowStartBlock) % localParams.sessionDuration;
468 
469         // If we are in the window, we will be within duration of the start of
470         // the most recent window
471         return windowOffset < localParams.windowDuration;
472     }
473 
474     /// @notice A getter function for determining whether we are currently in a
475     ///  fightWindow for a given tournament
476     /// @param _basicTournamentAddress  The address of the tournament in
477     ///  question
478     /// @return  Whether or not we are in a fightWindow for this tournament
479     function _isInFightWindowForTournament(address _basicTournamentAddress) internal view returns (bool){
480         uint256 tournamentStartBlock;
481         uint256 pauseEndedBlock;
482         uint256 admissionDuration;
483         uint256 duelTimeoutDuration;
484         uint256 ascensionWindowDuration;
485         uint256 fightWindowDuration;
486         uint256 cullingWindowDuration;
487         (
488             tournamentStartBlock,
489             pauseEndedBlock,
490             admissionDuration,
491             ,
492             duelTimeoutDuration,
493             ,
494             ascensionWindowDuration,
495             ,
496             fightWindowDuration,
497             ,
498             ,
499             ,
500             cullingWindowDuration
501         ) = IBasicTournamentTimeParams(_basicTournamentAddress).getTimeParameters();
502         uint256 firstSessionStartBlock = uint256(tournamentStartBlock) + uint256(admissionDuration);
503         uint256 sessionDuration = uint256(ascensionWindowDuration) + uint256(fightWindowDuration) + uint256(duelTimeoutDuration) + uint256(cullingWindowDuration);
504 
505         return _isInWindow(WindowParameters({
506             firstWindowStartBlock: uint48(uint256(firstSessionStartBlock) + uint256(ascensionWindowDuration)),
507             pauseEndedBlock: uint48(pauseEndedBlock),
508             sessionDuration: uint32(sessionDuration),
509             windowDuration: uint32(fightWindowDuration)
510         }));
511     }
512 }
513 
514 contract IBasicTournamentTimeParams{
515     function getTimeParameters() external view returns (
516         uint256 tournamentStartBlock,
517         uint256 pauseEndedBlock,
518         uint256 admissionDuration,
519         uint256 revivalDuration,
520         uint256 duelTimeoutDuration,
521         uint256 ascensionWindowStart,
522         uint256 ascensionWindowDuration,
523         uint256 fightWindowStart,
524         uint256 fightWindowDuration,
525         uint256 resolutionWindowStart,
526         uint256 resolutionWindowDuration,
527         uint256 cullingWindowStart,
528         uint256 cullingWindowDuration
529     );
530 }
531 
532 /// @title Main contract for CheezyExchange. This contract manages the creation,
533 ///  editing, and fulfillment of trades of CheezeWizard power only, not the NFT
534 ///  itself.
535 /// @notice Consider each CheezeWizard NFT as a vessel that holds power. This
536 ///  contract allows a seller to list their Wizard's power for a specified
537 ///  price. If a buyer accepts their order, then they pay the specified price
538 ///  multiplied by the amount of power that the Wizard has, and all of the
539 ///  wizard's power is transferred from the seller's wizard to the buyer's
540 ///  wizard. This leaves the seller's wizard with no power, but the seller
541 ///  still possesses the wizard NFT.
542 /// @notice Power is tournament-specific. Multiple CheezeWizard tournaments can
543 ///  exist, even at the same time. A single wizard can be entered into
544 ///  multiple tournaments at once, and can have different power levels in each
545 ///  tournament. This contract contains a different orderbook for each
546 ///  tournament. This means that this contract can simultaneously accept orders
547 ///  for multiple tournaments at the same time, even for the same wizard.
548 contract CheezyExchange is CheezyExchangeAdmin, CheezyExchangeTournamentTime {
549 
550     // OpenZeppelin's SafeMath library is used for all arithmetic operations to
551     // avoid overflows/underflows.
552     using SafeMath for uint256;
553 
554 	/* ********** */
555     /* DATA TYPES */
556     /* ********** */
557 
558     /// @notice The main Order struct. The struct fits into two 256-bit words
559     ///  due to Solidity's rules for struct packing, saving gas.
560     struct Order {
561         // The tokenId for the seller's wizard. This is the wizard that will
562         // relinquish its power if an order is fulfilled.
563         uint256 wizardId;
564         // An order creator specifies how much wei they are willing to sell
565         // their wizard's power for. Note that this price is per-power, so
566         // the buyer will actually have to pay this price multiplied by the
567         // amount of power that the wizard has.
568         uint128 pricePerPower;
569         // The address of the creator of the order, the seller, the owner
570         // of the wizard whose power will be relinquished.
571 		address makerAddress;
572         // The address of the tournament that this order pertains to. Note that
573         // each Wizard has an independent power value for each tournament, and
574         // call sell each one separately, so orders can exist simultaneously
575         // for the same wizard for different tournaments.
576 		address basicTournamentAddress;
577         // We save the dev fee at the time of order creation. This prevents an
578         // attack where the dev could frontrun an order acceptance with a
579         // change to the dev fee.
580         uint16 savedSuccessfulTradeFeeInBasisPoints;
581     }
582 
583     /* ****** */
584     /* EVENTS */
585     /* ****** */
586 
587     /// @notice This event is fired a user creates an order selling their wizard's
588     ///  power, but not the NFT itself.
589     /// @param wizardId  The tokenId for the seller's wizard. This is the
590     ///  wizard that will relinquish its power if an order is fulfilled.
591     /// @param pricePerPower  An order creator specifies how much wei they are
592     ///  willing to sell their wizard's power for. Note that this price is
593     ///  per-power, so the buyer will actually have to pay this price
594     ///  multiplied by the amount of power that the wizard has.
595     /// @param makerAddress  The address of the creator of the order, the
596     ///  seller, the owner of the wizard whose power will be relinquished.
597     /// @param basicTournamentAddress  The address of the tournament that this
598     ///  order pertains to. Note that each Wizard has an independent power
599     ///  value for each tournament, and call sell each one separately, so
600     ///  orders can exist simultaneously for the same wizard for different
601     ///  tournaments.
602     /// @param savedSuccessfulTradeFeeInBasisPoints  We save the dev fee at the
603     ///  time of order creation. This prevents an attack where the dev could
604     ///  frontrun an order acceptance with a change to the dev fee.
605     event CreateSellOrder(
606     	uint256 wizardId,
607         uint256 pricePerPower,
608 		address makerAddress,
609         address basicTournamentAddress,
610         uint256 savedSuccessfulTradeFeeInBasisPoints
611     );
612 
613     /// @notice This event is fired a user updates an existing order to have a
614     ///  different pricePerPower. It saves a small amount of gas to only change
615     ///  that one part of the oder.
616     /// @param wizardId  The tokenId for the seller's wizard. This is the
617     ///  wizard that will relinquish its power if an order is fulfilled.
618     /// @param oldPricePerPower  This is the old pricePerPower, the price that
619     ///  is being replaced in this update() call. An order creator specifies
620     ///  how much wei they are willing to sell their wizard's power for. Note
621     ///  that this price is per-power, so the buyer will actually have to pay
622     ///  this price multiplied by the amount of power that the wizard has.
623     /// @param newPricePerPower  This is the new pricePerPower, the price that
624     ///  will now be valid after this update() call. An order creator specifies
625     ///  how much wei they are willing to sell their wizard's power for. Note
626     ///  that this price is per-power, so the buyer will actually have to pay
627     ///  this price multiplied by the amount of power that the wizard has.
628     /// @param makerAddress  The address of the creator of the order, the
629     ///  seller, the owner of the wizard whose power will be relinquished.
630     /// @param basicTournamentAddress  The address of the tournament that this
631     ///  order pertains to. Note that each Wizard has an independent power
632     ///  value for each tournament, and call sell each one separately, so
633     ///  orders can exist simultaneously for the same wizard for different
634     ///  tournaments.
635     /// @param savedSuccessfulTradeFeeInBasisPoints  We save the dev fee at the
636     ///  time of order creation. This prevents an attack where the dev could
637     ///  frontrun an order acceptance with a change to the dev fee.
638     event UpdateSellOrder(
639     	uint256 wizardId,
640         uint256 oldPricePerPower,
641         uint256 newPricePerPower,
642 		address makerAddress,
643         address basicTournamentAddress,
644         uint256 savedSuccessfulTradeFeeInBasisPoints
645     );
646 
647     /// @notice This event is fired a user cancels an existing order. It is also
648     ///  fired when a user calls createSellOrder() for a wizard that already
649     ///  has a (potentially invalid) order on the books.
650     /// @dev The reason that this contract emits the CancelSellOrder event
651     ///  when a user calls createSellOrder() for a wizard that already
652     ///  has a (potentially invalid) order on the books is illustrated by the
653     ///  following scenario: if Alice creates an order for Wizard1 on this
654     ///  contract, but then sells Wizard1 to Bob, then this contract will still
655     ///  have an order on the books for Wizard1. However, this contract will
656     ///  not allow that order to be fulfilled, since the owner of Wizard1 has
657     ///  changed, and this contract will only view an order as valid if the
658     ///  wizard is still owned by the original order creator. Thus, if Bob is
659     ///  now trying to create a sell order for Wizard1, we need to delete
660     ///  Alice's old order.
661     /// @param wizardId  The tokenId for the seller's wizard. This is the
662     ///  wizard that will relinquish its power if an order is fulfilled.
663     /// @param pricePerPower  An order creator specifies how much wei they are
664     ///  willing to sell their wizard's power for. Note that this price is
665     ///  per-power, so the buyer will actually have to pay this price
666     ///  multiplied by the amount of power that the wizard has.
667     /// @param makerAddress  The address of the creator of the order, the
668     ///  seller, the owner of the wizard whose power will be relinquished.
669     /// @param basicTournamentAddress  The address of the tournament that this
670     ///  order pertains to. Note that each Wizard has an independent power
671     ///  value for each tournament, and call sell each one separately, so
672     ///  orders can exist simultaneously for the same wizard for different
673     ///  tournaments.
674     /// @param savedSuccessfulTradeFeeInBasisPoints  We save the dev fee at the
675     ///  time of order creation. This prevents an attack where the dev could
676     ///  frontrun an order acceptance with a change to the dev fee.
677     event CancelSellOrder(
678     	uint256 wizardId,
679         uint256 pricePerPower,
680 		address makerAddress,
681         address basicTournamentAddress,
682         uint256 savedSuccessfulTradeFeeInBasisPoints
683     );
684 
685     /// @notice This event is fired a buyer successfully fills a seller's order.
686     /// @param makerWizardId  The tokenId for the seller's wizard. This is the
687     ///  wizard that will relinquish its power if an order is fulfilled.
688     /// @param takerWizardId  The tokenId for the buyer's wizard. This is the
689     ///  wizard that will receive its power if an order is fulfilled.
690     /// @param pricePerPower  An order creator specifies how much wei they are
691     ///  willing to sell their wizard's power for. Note that this price is
692     ///  per-power, so the buyer will actually have to pay this price
693     ///  multiplied by the amount of power that the wizard has.
694     /// @param makerAddress  The address of the creator of the order, the
695     ///  seller, the owner of the wizard whose power will be relinquished.
696     /// @param takerAddress  The address of the fulfiller of the order, the
697     ///  buyer, the owner of the wizard who will receive power.
698     /// @param basicTournamentAddress  The address of the tournament that this
699     ///  order pertains to. Note that each Wizard has an independent power
700     ///  value for each tournament, and call sell each one separately, so
701     ///  orders can exist simultaneously for the same wizard for different
702     ///  tournaments.
703     /// @param savedSuccessfulTradeFeeInBasisPoints  We save the dev fee at the
704     ///  time of order creation. This prevents an attack where the dev could
705     ///  frontrun an order acceptance with a change to the dev fee.
706     event FillSellOrder(
707     	uint256 makerWizardId,
708         uint256 takerWizardId,
709         uint256 pricePerPower,
710 		address makerAddress,
711         address takerAddress,
712         address basicTournamentAddress,
713         uint256 savedSuccessfulTradeFeeInBasisPoints
714     );
715 
716     /* ******* */
717     /* STORAGE */
718     /* ******* */
719 
720     /// @notice A mapping that tracks current order structs, indexed first by
721     ///  tournament address and then by wizardId.
722     /// @dev This contract is generalized to accept orders for multiple
723     ///  cheezewizard tournaments, potentially simultaneously, potentially even
724     ///  for the same wizard. This is because power is tournament-specific, so
725     ///  the same wizard can have different amounts of power in different
726     ///  tournaments.
727     mapping(address => mapping(uint256 => Order)) internal orderForWizardIdAndTournamentAddress;
728 
729     /// @notice A simple ticker keeping track of the pricePerPower of the last
730     ///  successful sale for this particular tournament. This could be useful
731     ///  for displaying on a frontend UI as a guide for new orders, or the
732     ///  current state of the market.
733     mapping(address => uint256) public lastSuccessfulPricePerPowerForTournamentAddress;
734 
735     /* ********* */
736     /* FUNCTIONS */
737     /* ********* */
738 
739     /// @notice After calling approve() in the CheezeWizards Core contract
740     ///  (called WizardGuild.sol), a seller can post an order to sell the power
741     ///  of one of their wizards for a particular tournament (found in the
742     ///  contract BasicTournament.sol). Note that this only sells the wizard's
743     ///  power, but the seller will retain the NFT itself.
744     /// @dev The reason that this contract emits the CancelSellOrder event
745     ///  when a user calls createSellOrder() for a wizard that already
746     ///  has a (potentially invalid) order on the books is illustrated by the
747     ///  following scenario: if Alice creates an order for Wizard1 on this
748     ///  contract, but then sells Wizard1 to Bob, then this contract will still
749     ///  have an order on the books for Wizard1. However, this contract will
750     ///  not allow that order to be fulfilled, since the owner of Wizard1 has
751     ///  changed, and this contract will only view an order as valid if the
752     ///  wizard is still owned by the original order creator. Thus, if Bob is
753     ///  now trying to create a sell order for Wizard1, we need to delete
754     ///  Alice's old order.
755     /// @param _wizardId  The tokenId for the seller's wizard. This is the
756     ///  wizard that will relinquish its power if an order is fulfilled.
757     /// @param _pricePerPower  An order creator specifies how much wei they are
758     ///  willing to sell their wizard's power for. Note that this price is
759     ///  per-power, so the buyer will actually have to pay this price
760     ///  multiplied by the amount of power that the wizard has.
761     /// @param _basicTournamentAddress  The address of the tournament that this
762     ///  order pertains to. Note that each Wizard has an independent power
763     ///  value for each tournament, and call sell each one separately, so
764     ///  orders can exist simultaneously for the same wizard for different
765     ///  tournaments.
766     function createSellOrder(uint256 _wizardId, uint256 _pricePerPower, address _basicTournamentAddress) external whenNotPaused nonReentrant {
767         require(WizardGuild(wizardGuildAddress).ownerOf(_wizardId) == msg.sender, 'only the owner of the wizard can create a sell order');
768         require(WizardGuild(wizardGuildAddress).isApprovedOrOwner(address(this), _wizardId), 'you must call the approve() function on WizardGuild before you can create a sell order');
769         require(_pricePerPower <= uint256(~uint128(0)), 'you cannot specify a _pricePerPower greater than uint128_max');
770 
771         // Fetch wizard's stats from BasicTournament contract
772         bool molded;
773         bool ready;
774         ( , , , , , , , molded, ready) = BasicTournament(_basicTournamentAddress).getWizard(_wizardId);
775         require(molded == false, 'you cannot sell the power from a molded wizard');
776         require(ready == true, 'you cannot sell the power from a wizard that is not ready');
777 
778         Order memory previousOrder = orderForWizardIdAndTournamentAddress[_basicTournamentAddress][_wizardId];
779 
780         // Check if an order already exists for this wizard within this
781         // tournament
782         if(previousOrder.makerAddress != address(0)){
783             // If an order already exists, delete it before we create a new one
784             emit CancelSellOrder(
785                 uint256(previousOrder.wizardId),
786                 uint256(previousOrder.pricePerPower),
787                 previousOrder.makerAddress,
788                 previousOrder.basicTournamentAddress,
789                 uint256(previousOrder.savedSuccessfulTradeFeeInBasisPoints)
790             );
791             delete orderForWizardIdAndTournamentAddress[_basicTournamentAddress][_wizardId];
792         }
793 
794         // Save the new order to storage
795         Order memory order = Order({
796             wizardId: uint256(_wizardId),
797             pricePerPower: uint128(_pricePerPower),
798             makerAddress: msg.sender,
799             basicTournamentAddress: _basicTournamentAddress,
800             savedSuccessfulTradeFeeInBasisPoints: uint16(successfulTradeFeeInBasisPoints)
801         });
802         orderForWizardIdAndTournamentAddress[_basicTournamentAddress][_wizardId] = order;
803         emit CreateSellOrder(
804             _wizardId,
805             _pricePerPower,
806             msg.sender,
807             _basicTournamentAddress,
808             successfulTradeFeeInBasisPoints
809         );
810     }
811 
812     /// @notice A seller/maker calls this function to update the pricePerPower
813     ///  of an order that they already have stored in this contract. This saves
814     ///  some gas for the seller by allowing them to just update the
815     ///  pricePerPower parameter of their order.
816     /// @param _wizardId  The tokenId for the seller's wizard. This is the
817     ///  wizard that will relinquish its power if an order is fulfilled.
818     /// @param _newPricePerPower  An order creator specifies how much wei they
819     ///  are willing to sell their wizard's power for. Note that this price is
820     ///  per-power, so the buyer will actually have to pay this price
821     ///  multiplied by the amount of power that the wizard has.
822     /// @param _basicTournamentAddress  The address of the tournament that this
823     ///  order pertains to. Note that each Wizard has an independent power
824     ///  value for each tournament, and call sell each one separately, so
825     ///  orders can exist simultaneously for the same wizard for different
826     ///  tournaments.
827     function updateSellOrder(uint256 _wizardId, uint256 _newPricePerPower, address _basicTournamentAddress) external whenNotPaused nonReentrant {
828         require(WizardGuild(wizardGuildAddress).ownerOf(_wizardId) == msg.sender, 'only the owner of the wizard can update a sell order');
829         require(WizardGuild(wizardGuildAddress).isApprovedOrOwner(address(this), _wizardId), 'you must call the approve() function on WizardGuild before you can update a sell order');
830         require(_newPricePerPower <= uint256(~uint128(0)), 'you cannot specify a _newPricePerPower greater than uint128_max');
831 
832         // Fetch order
833         Order storage order = orderForWizardIdAndTournamentAddress[_basicTournamentAddress][_wizardId];
834 
835         // Check that order is not from a previous owner
836         require(msg.sender == order.makerAddress, 'you can only update a sell order that you created');
837 
838         // Emit event
839         emit UpdateSellOrder(
840             _wizardId,
841             uint256(order.pricePerPower),
842             _newPricePerPower,
843             msg.sender,
844             _basicTournamentAddress,
845             uint256(order.savedSuccessfulTradeFeeInBasisPoints)
846         );
847 
848         // Update price
849         order.pricePerPower = uint128(_newPricePerPower);
850     }
851 
852     /// @notice A seller/maker calls this function to cancel an existing order
853     ///  that they have posted to this contract.
854     /// @dev Unlike the other Order functions, this function can be called even
855     ///  if the contract is paused, so that users can clear out their orderbook
856     ///  if they would like.
857     /// @param _wizardId  The tokenId for the seller's wizard. This is the
858     ///  wizard that will relinquish its power if an order is fulfilled.
859     /// @param _basicTournamentAddress  The address of the tournament that this
860     ///  order pertains to. Note that each Wizard has an independent power
861     ///  value for each tournament, and call sell each one separately, so
862     ///  orders can exist simultaneously for the same wizard for different
863     ///  tournaments.
864     function cancelSellOrder(uint256 _wizardId, address _basicTournamentAddress) external nonReentrant {
865         require(WizardGuild(wizardGuildAddress).ownerOf(_wizardId) == msg.sender, 'only the owner of the wizard can cancel a sell order');
866 
867         // Wait until after emitting event to delete order so that event data
868         // can be pulled from soon-to-be-deleted order
869         Order memory order = orderForWizardIdAndTournamentAddress[_basicTournamentAddress][_wizardId];
870         emit CancelSellOrder(
871             uint256(order.wizardId),
872             uint256(order.pricePerPower),
873             msg.sender,
874             _basicTournamentAddress,
875             uint256(order.savedSuccessfulTradeFeeInBasisPoints)
876         );
877 
878         // Delete order
879         delete orderForWizardIdAndTournamentAddress[_basicTournamentAddress][_wizardId];
880     }
881 
882     /// @notice A buyer/taker calls this function to complete an order, paying
883     ///  pricePerPower multiplied by the makerWizard's current power in order
884     ///  to transfer the makerWizard's power to the takerWizard.
885     /// @dev The buyer/taker must send enough wei along with this function call
886     ///  to cover pricePerPower multiplied by the makerWizard's current power.
887     /// @param _makerWizardId  The tokenId for the seller's wizard. This is the
888     ///  wizard that will relinquish its power if an order is fulfilled.
889     /// @param _takerWizardId  The tokenId for the buyer's wizard. This is the
890     ///  wizard that will receive its power if an order is fulfilled.
891     /// @param _basicTournamentAddress  The address of the tournament that this
892     ///  order pertains to. Note that each Wizard has an independent power
893     ///  value for each tournament, and call sell each one separately, so
894     ///  orders can exist simultaneously for the same wizard for different
895     ///  tournaments.
896     /// @param _referrer  This address gets half of the successful trade fees.
897     ///  This encourages third party developers to develop their own front-end
898     ///  UI's for this contract in order to receive half of the rewards.
899     function fillSellOrder(uint256 _makerWizardId, uint256 _takerWizardId, address _basicTournamentAddress, address _referrer) external payable whenNotPaused nonReentrant {
900         require(WizardGuild(wizardGuildAddress).ownerOf(_takerWizardId) == msg.sender, 'you can only purchase power for a wizard that you own');
901         Order memory order = orderForWizardIdAndTournamentAddress[_basicTournamentAddress][_makerWizardId];
902         require(WizardGuild(wizardGuildAddress).ownerOf(_makerWizardId) == order.makerAddress, 'an order is only valid while the order creator owns the wizard');
903 
904         // Fetch wizard's stats from BasicTournament contract
905         uint256 power;
906         bool molded;
907         bool ready;
908         ( , power, , , , , , molded, ready) = BasicTournament(_basicTournamentAddress).getWizard(_makerWizardId);
909         require(molded == false, 'you cannot sell the power from a molded wizard');
910         require(ready == true, 'you cannot sell the power from a wizard that is not ready');
911 
912         // Update the global ticker for the last successful pricePerPower sale
913         // price
914         lastSuccessfulPricePerPowerForTournamentAddress[_basicTournamentAddress] = uint256(order.pricePerPower);
915 
916         // Calculate seller proceeds and contractCreator fees
917         uint256 priceToFillOrder = (uint256(order.pricePerPower)).mul(power.div(10**12));
918         require(msg.value >= priceToFillOrder, 'you did not send enough wei to fulfill this order');
919         uint256 sellerProceeds = _computeSellerProceeds(priceToFillOrder, uint256(order.savedSuccessfulTradeFeeInBasisPoints));
920         uint256 fees = priceToFillOrder.sub(sellerProceeds);
921         uint256 excess = (msg.value).sub(priceToFillOrder);
922 
923         // Save the seller's address before we delete the order
924         address payable orderMakerAddress = address(uint160(order.makerAddress));
925 
926         // Emit event
927         emit FillSellOrder(
928             uint256(order.wizardId),
929             _takerWizardId,
930             uint256(order.pricePerPower),
931             address(order.makerAddress),
932             msg.sender,
933             order.basicTournamentAddress,
934             uint256(order.savedSuccessfulTradeFeeInBasisPoints)
935         );
936 
937         // Delete the order prior to sending any funds
938         delete orderForWizardIdAndTournamentAddress[_basicTournamentAddress][_makerWizardId];
939 
940         // Transfer Power from maker wizard to taker wizard
941         BasicTournament(_basicTournamentAddress).giftPower(_makerWizardId, _takerWizardId);
942 
943         // Send proceeds to seller/maker
944         orderMakerAddress.transfer(sellerProceeds);
945 
946         // Store fees earned by contract creator in contract until creator calls
947         // withdrawsEarnings()
948         // This prevents a halting condition that would occur if one of the fee
949         // earners rejects incoming transfers
950         if(_referrer != address(0)){
951             uint256 halfOfFees = fees.div(uint256(2));
952             addressToFeeEarnings[_referrer] = addressToFeeEarnings[_referrer].add(halfOfFees);
953             addressToFeeEarnings[owner()] = addressToFeeEarnings[owner()].add(halfOfFees);
954         } else {
955             addressToFeeEarnings[owner()] = addressToFeeEarnings[owner()].add(fees);
956         }
957 
958         // Send any excess wei back to buyer/taker
959         if(excess > 0){
960             msg.sender.transfer(excess);
961         }
962     }
963 
964     /// @notice A simple getter function to return an order for a given wizard
965     ///  and tournament address.
966     /// @dev The reason that we cannot simply use Solidity's automatically
967     ///  created getter functions is that the orders are stored in a nested
968     ///  mapping, which messes with Solidity's automatically created getters.
969     /// @param _wizardId The id of the wizard NFT whose order we would like to
970     ///  see the details of.
971     /// @param _basicTournamentAddress The address of the tournament that this
972     ///  order pertains to. Note that each Wizard has an independent power
973     ///  value for each tournament, and call sell each one separately.
974     /// @return The values from the Order struct, returned in tuple-form.
975     function getOrder(uint256 _wizardId, address _basicTournamentAddress) external view returns (uint256 wizardId, uint256 pricePerPower, address makerAddress, address basicTournamentAddress, uint256 savedSuccessfulTradeFeeInBasisPoints){
976         Order memory order = orderForWizardIdAndTournamentAddress[_basicTournamentAddress][_wizardId];
977         return (uint256(order.wizardId), uint256(order.pricePerPower), address(order.makerAddress), address(order.basicTournamentAddress), uint256(order.savedSuccessfulTradeFeeInBasisPoints));
978     }
979 
980     /// @notice A convenience function providing the caller with the current
981     ///  amount needed (in wei) to fulfill this order.
982     /// @param _wizardId The id of the wizard NFT whose order we would like to
983     ///  see the details of.
984     /// @param _basicTournamentAddress The address of the tournament that this
985     ///  order pertains to. Note that each Wizard has an independent power
986     ///  value for each tournament, and call sell each one separately.
987     /// @return The amount needed (in wei) to fulfill this order
988     function getCurrentPriceForOrder(uint256 _wizardId, address _basicTournamentAddress) external view returns (uint256){
989         Order memory order = orderForWizardIdAndTournamentAddress[_basicTournamentAddress][_wizardId];
990         uint256 power;
991         ( , power, , , , , , , ) = BasicTournament(_basicTournamentAddress).getWizard(_wizardId);
992         uint256 price = (power.div(10**12)).mul(uint256(order.pricePerPower));
993         return price;
994     }
995 
996     /// @notice A convenience function checking whether the order is currently
997     ///  valid. Note that an order can become invalid for a period of time, but
998     ///  then become valid again (for example, during the time that a wizard
999     ///  is dueling).
1000     /// @param _wizardId The id of the wizard NFT whose order we would like to
1001     ///  see the details of.
1002     /// @param _basicTournamentAddress The address of the tournament that this
1003     ///  order pertains to. Note that each Wizard has an independent power
1004     ///  value for each tournament, and call sell each one separately.
1005     /// @return Whether the order is currently valid or not.
1006     function getIsOrderCurrentlyValid(uint256 _wizardId, address _basicTournamentAddress) external view returns (bool){
1007         Order memory order = orderForWizardIdAndTournamentAddress[_basicTournamentAddress][_wizardId];
1008         if(order.makerAddress == address(0)){
1009             // Order is not valid if order does not exist
1010             return false;
1011         } else {
1012 
1013             if(WizardGuild(wizardGuildAddress).ownerOf(_wizardId) != order.makerAddress){
1014                 // Order is not valid if order's creator no longer owns wizard
1015                 return false;
1016             }
1017             bool molded;
1018             bool ready;
1019             ( , , , , , , , molded, ready) = BasicTournament(_basicTournamentAddress).getWizard(_wizardId);
1020             if(molded == true || ready == false){
1021                 // Order is not valid if makerWizard is molded or is dueling
1022                 return false;
1023             } else {
1024                 return true;
1025             }
1026         }
1027     }
1028 
1029     /// @notice A getter function for determining whether we are currently in a
1030     ///  fightWindow for a given tournament
1031     /// @param _basicTournamentAddress  The address of the tournament in
1032     ///  question
1033     /// @return  Whether or not we are in a fightWindow for this tournament
1034     function getIsInFightWindow(address _basicTournamentAddress) external view returns (bool){
1035         return _isInFightWindowForTournament(_basicTournamentAddress);
1036     }
1037 
1038     /// @notice Computes the seller proceeds given a total value sent,
1039     ///  and the successfulTradeFee in percentage basis points that was saved
1040     ///  at the time of the order's creation.
1041     /// @dev 10000 is not a magic number, but is the maximum number of basis
1042     ///  points that can exist (with basis points being hundredths of a
1043     ///  percent).
1044     /// @param _totalValueIncludingFees The amount of ether (in wei) that was
1045     ///  sent to complete the trade
1046     /// @param _successfulTradeFeeInBasisPoints The percentage (in basis points)
1047     ///  of that total amount that will be taken as a fee if the trade is
1048     ///  successfully completed.
1049     /// @return The amount of ether (in wei) that will be sent to the seller if
1050     ///  the trade is successfully completed
1051     function _computeSellerProceeds(uint256 _totalValueIncludingFees, uint256 _successfulTradeFeeInBasisPoints) internal pure returns (uint256) {
1052     	return (_totalValueIncludingFees.mul(uint256(10000).sub(_successfulTradeFeeInBasisPoints))).div(uint256(10000));
1053     }
1054 
1055     /// @dev By calling 'revert' in the fallback function, we prevent anyone from
1056     ///  accidentally sending funds directly to this contract.
1057     function() external payable {
1058         revert();
1059     }
1060 }