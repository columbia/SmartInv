1 pragma solidity ^0.5.10;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Roles
69  * @dev Library for managing addresses assigned to a Role.
70  */
71 library Roles {
72     struct Role {
73         mapping (address => bool) bearer;
74     }
75 
76     /**
77      * @dev give an account access to this role
78      */
79     function add(Role storage role, address account) internal {
80         require(account != address(0));
81         require(!has(role, account));
82 
83         role.bearer[account] = true;
84     }
85 
86     /**
87      * @dev remove an account's access to this role
88      */
89     function remove(Role storage role, address account) internal {
90         require(account != address(0));
91         require(has(role, account));
92 
93         role.bearer[account] = false;
94     }
95 
96     /**
97      * @dev check if an account has this role
98      * @return bool
99      */
100     function has(Role storage role, address account) internal view returns (bool) {
101         require(account != address(0));
102         return role.bearer[account];
103     }
104 }
105 
106 contract COORole {
107     using Roles for Roles.Role;
108 
109     event COOAdded(address indexed account);
110     event COORemoved(address indexed account);
111 
112     Roles.Role private _COOs;
113 
114     constructor () internal {
115         _addCOO(msg.sender);
116     }
117 
118     modifier onlyCOO() {
119         require(isCOO(msg.sender));
120         _;
121     }
122 
123     function isCOO(address account) public view returns (bool) {
124         return _COOs.has(account);
125     }
126 
127     function addCOO(address account) public onlyCOO {
128         _addCOO(account);
129     }
130 
131     function renounceCOO() public {
132         _removeCOO(msg.sender);
133     }
134 
135     function _addCOO(address account) internal {
136         _COOs.add(account);
137         emit COOAdded(account);
138     }
139 
140     function _removeCOO(address account) internal {
141         _COOs.remove(account);
142         emit COORemoved(account);
143     }
144 }
145 
146 contract PauserRole {
147     using Roles for Roles.Role;
148 
149     event PauserAdded(address indexed account);
150     event PauserRemoved(address indexed account);
151 
152     Roles.Role private _pausers;
153 
154     constructor () internal {
155         _addPauser(msg.sender);
156     }
157 
158     modifier onlyPauser() {
159         require(isPauser(msg.sender));
160         _;
161     }
162 
163     function isPauser(address account) public view returns (bool) {
164         return _pausers.has(account);
165     }
166 
167     function addPauser(address account) public onlyPauser {
168         _addPauser(account);
169     }
170 
171     function renouncePauser() public {
172         _removePauser(msg.sender);
173     }
174 
175     function _addPauser(address account) internal {
176         _pausers.add(account);
177         emit PauserAdded(account);
178     }
179 
180     function _removePauser(address account) internal {
181         _pausers.remove(account);
182         emit PauserRemoved(account);
183     }
184 }
185 
186 /**
187  * @title Pausable
188  * @dev Base contract which allows children to implement an emergency stop mechanism.
189  */
190 contract Pausable is PauserRole {
191     event Paused(address account);
192     event Unpaused(address account);
193 
194     bool private _paused;
195 
196     constructor () internal {
197         _paused = false;
198     }
199 
200     /**
201      * @return true if the contract is paused, false otherwise.
202      */
203     function paused() public view returns (bool) {
204         return _paused;
205     }
206 
207     /**
208      * @dev Modifier to make a function callable only when the contract is not paused.
209      */
210     modifier whenNotPaused() {
211         require(!_paused);
212         _;
213     }
214 
215     /**
216      * @dev Modifier to make a function callable only when the contract is paused.
217      */
218     modifier whenPaused() {
219         require(_paused);
220         _;
221     }
222 
223     /**
224      * @dev called by the owner to pause, triggers stopped state
225      */
226     function pause() public onlyPauser whenNotPaused {
227         _paused = true;
228         emit Paused(msg.sender);
229     }
230 
231     /**
232      * @dev called by the owner to unpause, returns to normal state
233      */
234     function unpause() public onlyPauser whenPaused {
235         _paused = false;
236         emit Unpaused(msg.sender);
237     }
238 }
239 
240 /**
241  * @title Ownable
242  * @dev The Ownable contract has an owner address, and provides basic authorization control
243  * functions, this simplifies the implementation of "user permissions".
244  */
245 contract Ownable {
246     address private _owner;
247 
248     event OwnershipTransferred(address previousOwner, address newOwner);
249 
250     /**
251      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
252      * account.
253      */
254     constructor () internal {
255         _owner = msg.sender;
256         emit OwnershipTransferred(address(0), _owner);
257     }
258 
259     /**
260      * @return the address of the owner.
261      */
262     function owner() public view returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(isOwner());
271         _;
272     }
273 
274     /**
275      * @return true if `msg.sender` is the owner of the contract.
276      */
277     function isOwner() public view returns (bool) {
278         return msg.sender == _owner;
279     }
280 
281     /**
282      * @dev Allows the current owner to relinquish control of the contract.
283      * @notice Renouncing to ownership will leave the contract without an owner.
284      * It will not be possible to call the functions with the `onlyOwner`
285      * modifier anymore.
286      */
287     function renounceOwnership() public onlyOwner {
288         emit OwnershipTransferred(_owner, address(0));
289         _owner = address(0);
290     }
291 
292     /**
293      * @dev Allows the current owner to transfer control of the contract to a newOwner.
294      * @param newOwner The address to transfer ownership to.
295      */
296     function transferOwnership(address newOwner) public onlyOwner {
297         _transferOwnership(newOwner);
298     }
299 
300     /**
301      * @dev Transfers control of the contract to a newOwner.
302      * @param newOwner The address to transfer ownership to.
303      */
304     function _transferOwnership(address newOwner) internal {
305         require(newOwner != address(0));
306         emit OwnershipTransferred(_owner, newOwner);
307         _owner = newOwner;
308     }
309 }
310 
311 /**
312  * @title Helps contracts guard against reentrancy attacks.
313  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
314  * @dev If you mark a function `nonReentrant`, you should also
315  * mark it `external`.
316  */
317 contract ReentrancyGuard {
318     /// @dev counter to allow mutex lock with only one SSTORE operation
319     uint256 private _guardCounter;
320 
321     constructor () internal {
322         // The counter starts at one to prevent changing it from zero to a non-zero
323         // value, which is a more expensive operation.
324         _guardCounter = 1;
325     }
326 
327     /**
328      * @dev Prevents a contract from calling itself, directly or indirectly.
329      * Calling a `nonReentrant` function from another `nonReentrant`
330      * function is not supported. It is possible to prevent this from happening
331      * by making the `nonReentrant` function external, and make it call a
332      * `private` function that does the actual work.
333      */
334     modifier nonReentrant() {
335         _guardCounter += 1;
336         uint256 localCounter = _guardCounter;
337         _;
338         require(localCounter == _guardCounter);
339     }
340 }
341 
342 /// @title Admin contract for KittyBounties. Holds owner-only functions to adjust contract-wide fees, change owners, etc.
343 /// @dev The owner is not capable of changing the address of the CryptoKitties Core contract once the contract has been deployed.
344 ///  This prevents an attack vector where the owner could change the kittyCore contract once users had already deposited funds.
345 contract KittyBountiesAdmin is Ownable, Pausable, ReentrancyGuard, COORole {
346 
347     /* ****** */
348     /* EVENTS */
349     /* ****** */
350 
351     /// @dev This event is fired whenever the owner changes the successfulBountyFeeInBasisPoints.
352     /// @param newSuccessfulBountyFeeInBasisPoints  The SuccessfulFee is expressed in basis points (hundredths of a percantage),
353     ///  and is charged when a bounty is successfully completed.
354     event SuccessfulBountyFeeInBasisPointsUpdated(uint256 newSuccessfulBountyFeeInBasisPoints);
355 
356     /// @dev This event is fired whenever the owner changes the unsuccessfulBountyFeeInWCKWei.
357     /// @param newUnsuccessfulBountyFeeInWCKWei  The UnsuccessfulBountyFee is paid by the original bounty creator if the bounty expires
358     ///  without being completed. When a bounty is created, the bounty creator specifies how long the bounty is valid for. If the
359     ///  bounty is not fulfilled by this expiration date, the original creator can then freely withdraw their funds, minus the
360     ///  UnsuccessfulBountyFee, although the bounty is still fulfillable until the bounty creator withdraws their funds.
361     event UnsuccessfulBountyFeeInWCKWeiUpdated(uint256 newUnsuccessfulBountyFeeInWCKWei);
362 
363     /* ******* */
364     /* STORAGE */
365     /* ******* */
366 
367     /// @dev The amount of fees collected (in wck_wei). This includes both fees to the contract owner and fees to any bounty referrers.
368     ///  Storing earnings saves gas rather than performing an additional transfer() call on every successful bounty.
369     mapping (address => uint256) public addressToFeeEarnings;
370 
371     /// @dev If a bounty is successfully fulfilled, this fee applies before the remaining funds are sent to the successful bounty
372     ///  hunter. This fee is measured in basis points (hundredths of a percent), and is taken out of the total value that the bounty
373     ///  creator locked up in the contract when they created the bounty.
374     uint256 public successfulBountyFeeInBasisPoints = 375;
375 
376     /// @dev If a bounty is not fulfilled after the lockup period has completed, a bounty creator can withdraw their funds and
377     ///  invalidate the bounty, but they are charged this flat fee to do so. This fee is measured in WCK_wei.
378     uint256 public unsuccessfulBountyFeeInWCKWei = 1000000000000000000;
379 
380     /* ********* */
381     /* CONSTANTS */
382     /* ********* */
383 
384     /// @dev The owner is not capable of changing the address of the CryptoKitties Core contract once the contract has been deployed.
385     ///  This prevents an attack vector where the owner could change the kittyCore contract once users had already deposited funds.
386     ///  Since the CryptoKitties Core contract has the ability to migrate to a new contract, if Dapper Labs Inc. ever chooses to migrate
387     ///  contract, this contract will have to be frozen, and users will be allowed to withdraw their funds without paying any fees.
388     address public kittyCoreAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
389     KittyCore kittyCore;
390 
391     /// @dev The owner is not capable of changing the address of the WrappedKitties contract once the contract has been deployed.
392     ///  This prevents an attack vector where the owner could change the payout ERC20 address to a worthless ERC20 contract, once
393     ///  bounties were already locked in.
394     address public wrappedKittiesAddress = 0x09fE5f0236F0Ea5D930197DCE254d77B04128075;
395 
396     /* ********* */
397     /* FUNCTIONS */
398     /* ********* */
399 
400     /// @dev The owner is not capable of changing the address of the CryptoKitties Core contract once the contract has been deployed.
401     ///  This prevents an attack vector where the owner could change the kittyCore contract once users had already deposited funds.
402     constructor() internal {
403         kittyCore = KittyCore(kittyCoreAddress);
404     }
405 
406     /// @notice Sets the successfulBountyFeeInBasisPoints value (in basis points). Any bounties that are successfully fulfilled
407     ///  will have this fee deducted from amount sent to the bounty hunter.
408     /// @notice Only callable by the owner.
409     /// @dev As this configuration is a basis point, the value to set must be less than or equal to 10000.
410     /// @param _newSuccessfulBountyFeeInBasisPoints  The successfulBountyFeeInBasisPoints value to set (measured in basis points).
411     function setSuccessfulBountyFeeInBasisPoints(uint256 _newSuccessfulBountyFeeInBasisPoints) external onlyOwner {
412         require(_newSuccessfulBountyFeeInBasisPoints <= 10000, 'new successful bounty fee must be in basis points (hundredths of a percent), not wei');
413         successfulBountyFeeInBasisPoints = _newSuccessfulBountyFeeInBasisPoints;
414         emit SuccessfulBountyFeeInBasisPointsUpdated(_newSuccessfulBountyFeeInBasisPoints);
415     }
416 
417     /// @notice Sets the unsuccessfulBountyFeeInWCKWei value. If a bounty is still unfulfilled once the minimum number of blocks has passed,
418     ///  an owner can withdraw the locked ETH. If they do so, this fee is deducted from the amount that they withdraw.
419     /// @notice Only callable by the owner.
420     /// @param _newUnsuccessfulBountyFeeInWCKWei  The unsuccessfulBountyFeeInWCKWei value to set (measured in WCK_wei).
421     function setUnsuccessfulBountyFeeInWCKWei(uint256 _newUnsuccessfulBountyFeeInWCKWei) external onlyOwner {
422         unsuccessfulBountyFeeInWCKWei = _newUnsuccessfulBountyFeeInWCKWei;
423         emit UnsuccessfulBountyFeeInWCKWeiUpdated(_newUnsuccessfulBountyFeeInWCKWei);
424     }
425 
426     /// @notice Withdraws the fees that have been earned by either the contract owner or referrers.
427     /// @notice Only callable by the address that had earned the fees.
428     function withdrawFeeEarningsForAddress() external nonReentrant {
429         uint256 balance = addressToFeeEarnings[msg.sender];
430         require(balance > 0, 'there are no fees to withdraw for this address');
431         addressToFeeEarnings[msg.sender] = 0;
432         require(ERC20(wrappedKittiesAddress).transfer(msg.sender, balance) == true, 'failed to transfer WCK');
433     }
434 
435     /// @notice Gives the authority for the contract owner to remove any additional accounts that have been granted the ability to
436     ///  pause the contract
437     /// @notice Only callable by the owner.
438     /// @param _account  The account to have the ability to pause the contract revoked
439     function removePauser(address _account) external onlyOwner {
440         _removePauser(_account);
441     }
442 
443     /// @notice Gives the authority for the contract owner to remove any additional accounts that have been granted the COO authority
444     /// @notice Only callable by the owner.
445     /// @param _account  The account to have COO authority revoked
446     function removeCOO(address _account) external onlyOwner {
447         _removeCOO(_account);
448     }
449 
450     /// @dev By calling 'revert' in the fallback function, we prevent anyone from accidentally sending funds directly to this contract.
451     function() external payable {
452         revert();
453     }
454 }
455 
456 contract ERC20 {
457     function transfer(address to, uint256 value) public returns (bool);
458     function transferFrom(address from, address to, uint256 value) public returns (bool);
459 }
460 
461 /// @title Interface for interacting with the CryptoKitties Core contract created by Dapper Labs Inc.
462 contract KittyCore {
463     function getKitty(uint _id) public returns (
464         bool isGestating,
465         bool isReady,
466         uint256 cooldownIndex,
467         uint256 nextActionAt,
468         uint256 siringWithId,
469         uint256 birthTime,
470         uint256 matronId,
471         uint256 sireId,
472         uint256 generation,
473         uint256 genes
474     );
475     function ownerOf(uint256 _tokenId) public view returns (address owner);
476     function transferFrom(address _from, address _to, uint256 _tokenId) external;
477     mapping (uint256 => address) public kittyIndexToApproved;
478 }
479 
480 /// @title Main contract for KittyBounties. This contract manages funds from creation to fulfillment for bounties.
481 /// @notice Once created, a bounty locks up WCK (wrapped-cryptokitties, the currency of CryptoKitties). Optionally,
482 /// the bounty creator may specify a number of blocks to "lock" their bounty, thus preventing them from being able
483 ///  to cancel their bounty or withdraw their WCK until that number of blocks have passed. This guarantees a time
484 ///  period for bounty hunters to attempt to breed for a cat with the specified cattributes, generation, and/or
485 ///  cooldown. This option is included since perhaps many breeders will not chase a bounty without this guarantee.
486 ///  After that point, the bounty creator can withdraw their funds if they wish and invalidate the bounty, or they
487 ///  can continue to leave the bounty active.
488 /// @notice The bounty creator must first call approve() in the WrappedCryptoKitties contract before they
489 ///  can create a bounty. This enables this contract to withdraw WCK from their account when the bounty is created,
490 ///  and lock that WCK until the bounty is fulfilled or cancelled.
491 /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract before
492 ///  calling fulfillBountyAndClaimFunds(). For better UX, fulfillBountyAndClaimFunds() can also
493 ///  be called by an account with the COO role, making it so that the user only has to send one
494 ///  transaction (the approve() transaction), and the frontend creator can send the followup
495 ///  fulfillBountyAndClaimFunds() transaction. There is no danger of this contract overreaching
496 ///  its approval, since the CryptoKitties Core contract's approve() function only approves this
497 ///  contract for a single Cryptokitty. Calling approve() allows this contract to transfer the
498 ///  specified kitty in the fulfillOfferAndClaimFunds() function.
499 contract KittyBounties is KittyBountiesAdmin {
500 
501     // OpenZeppelin's SafeMath library is used for all arithmetic operations to avoid overflows/underflows.
502     using SafeMath for uint256;
503 
504 	/* ********** */
505     /* DATA TYPES */
506     /* ********** */
507 
508     /// @dev The main Bounty struct. The struct fits in four 256-bits words due to Solidity's rules for struct
509     ///  packing.
510 	struct Bounty {
511 		// A bounty creator specifies which portion of the CryptoKitties genome is relevant to this bounty.
512 		// This is a bitwise mask, that zeroes out all other portions of the Cryptokitties genome besides
513         // those that the bounty creator is interested in. If a bounty creator does not wish to specify
514         // genes (perhaps they want to specify generation, but don't have a preference for genes), they can
515         // submit a geneMask of uint256(0) and genes of uint256(0).
516 		uint256 geneMask;
517         // A bounty creator specifies which cattributes they are seeking. If a user possesses a cat that
518         // has both the specified cattributes, the specified generation, and the specified cooldown, then
519         // they can trade that cat for the bounty. If a bounty creator does not wish to specify genes
520         // (perhaps they want to specify generation, but don't have a preference for genes), they can
521         // submit a geneMask of uint256(0) and genes of uint256(0).
522         uint256 genes;
523         // A bounty creator specifies the earliest kittyID that they are willing to accept for this bounty.
524         // When combined with a bounty creator specifying genes, this would enable a bounty creator to set
525         // up a bounty for a particular fancy, even though fancy data is not stored on-chain. ID-range plus
526         // genes is sufficient to determine that a kitty is a fancy, when the first and last ID's of a capped
527         // fancy are known.
528         uint128 earliestAcceptableIdInclusive;
529         // A bounty creator specifies the latest kittyID that they are willing to accept for this bounty.
530         // When combined with a bounty creator specifying genes, this would enable a bounty creator to set
531         // up a bounty for a particular fancy, even though fancy data is not stored on-chain. ID-range plus
532         // genes is sufficient to determine that a kitty is a fancy, when the first and last ID's of a capped
533         // fancy are known.
534         uint128 latestAcceptableIdInclusive;
535 		// The price (in WCK_wei) that a user will receive if they successfully fulfill this bounty.
536 		uint128 bountyPricePerCat;
537 		// The total value (in WCK_wei) that the bounty creator originally sent to the contract to create this
538         // bounty. This includes the potential fees to be paid to the contract creator.
539 		uint128 totalValueIncludingFees;
540 		// The fee that is paid if the bounty is not fulfilled and the owner withdraws their funds. This
541         // is stored in the Bounty struct to ensure that users are charged the fee that existed at the
542         // time of a bounty's creation, in case the contract owner changes the fees between when the bounty
543         // is created and when the bounty creator withdraws their funds.
544 		uint128 unsuccessfulBountyFeeInWCKWei;
545 		// Optionally, a bounty creator can set a minimum number of blocks that must pass before they can
546         // cancel a bounty and withdraw their funds (in order to guarantee a time period for bounty hunters
547         // to attempt to breed for the specified cat). After the time period has passed, the owner can
548         // withdraw their funds if they wish, but the bounty stays valid until they do so. This allows for
549         // the possiblity of leaving a bounty open indefinitely until it is filled if the bounty creator
550         // wishes to do so.
551 		uint32 minBlockBountyValidUntil;
552         /// A bounty creator specifies how many cats they would like to acquire with these characteristics.
553         /// This allows a bounty creator to create bulk bounties (e.g. 100 Gen 0's for 0.25 ETH each, etc.)
554         uint32 quantity;
555         // A bounty creator can specify the exact generation that they are seeking. If they are willing to
556         // accept cats of any generation that have the cattributes specified above, they may submit
557         // UINT16_MAX for this variable for it to be ignored.
558         uint16 generation;
559 		// A bounty creator can specify the highest cooldownIndex that they are seeking, allowing users to
560         // place bounties on virgin cats or cats with a sufficient cooldown to be useful in a fancy chase.
561         // If they are willing to accept cats of any cooldown, they may submit a cooldownIndex of 13 (which
562         // is the highest cooldown index that the Cryptokitties Core contract allows) for this variable to
563         // be ignored.
564         uint16 highestCooldownIndexAccepted;
565         // The creator of the bounty. This address receives the specified cat if the bounty is fulfilled,
566         // or receives their money back (minus unsuccessfulBountyFee) if the bounty is not fulfilled.
567 		address bidder;
568     }
569 
570     /* ****** */
571     /* EVENTS */
572     /* ****** */
573 
574     /// @dev This event is fired whenever a user creates a new bounty for a cat with a particular set of
575     ///  cattributes, generation, and/or cooldown that they are seeking.
576     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the
577     ///  bountyIdToBounty mapping.
578     /// @param bidder  The creator of the bounty. This address receives the specified cat if the bounty
579     ///  is fulfilled, or receives their money back (minus unsuccessfulBountyFee) if the bounty is not
580     ///  fulfilled.
581     /// @param bountyPricePerCat  The price (in WCK_wei) that a user will receive if they successfully fulfill
582     ///  this bounty.
583     /// @param minBlockBountyValidUntil  Every bounty is valid until at least a specified block. Before
584     ///  that point, the owner cannot withdraw their funds (in order to guarantee a time period for bounty
585     ///  hunters to attempt to breed for the specified cat). After the time period has passed, the owner
586     ///  can withdraw their funds if they wish, but the bounty stays valid until they do so. This allows
587     ///  for the possiblity of leaving a bounty open indefinitely until it is filled if the bounty creator
588     ///  wishes to do so.
589     /// @param quantity  A bounty creator specifies how many cats they would like to acquire with the
590     ///  specified characteristics. This allows a bounty creator to create bulk bounties (e.g. 100
591     ///  Gen 0's, etc.)
592     /// @param geneMask  A bounty creator specifies which portion of the CryptoKitties genome is relevant
593     ///  to this bounty. This is a bitwise mask, that zeroes out all other portions of the Cryptokitties
594     ///  genome besides those that the bounty creator is interested in.
595     /// @param genes  A bounty creator specifies which cattributes they are seeking. If a user possesses
596     ///  a cat that has both the specified cattributes and the specified generation, then they can trade
597     ///  that cat for the bounty.
598     /// @param earliestAcceptableIdInclusive  A bounty creator specifies the earliest ID that they
599     ///  would accept. They can submit 0 for this variable to be ignored.
600     /// @param latestAcceptableIdInclusive  A bounty creator specifies the latest ID that they
601     ///  would accept. They can submit uint128_max for this variable to be ignored.
602     /// @param generation  A bounty creator can specify the exact generation that they are seeking. If
603     ///  they are willing to accept cats of any generation that have the cattributes specified above,
604     ///  they may submit UINT16_MAX for this variable for it to be ignored.
605     /// @param highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex that
606     ///  they are seeking, allowing users to place bounties on virgin cats or cats with a sufficient
607     ///  cooldown to be useful in a fancy chase. If they are willing to accept cats of any cooldown, they
608     ///  may submit a cooldownIndex of 13 (which is the highest cooldown index that the Cryptokitties
609     ///  Core contract allows) for this variable to be ignored.
610     /// @param unsuccessfulBountyFeeInWCKWei  The fee that is paid if the bounty is not fulfilled and the
611     ///  owner withdraws their funds. This is stored in the Bounty struct to ensure that users are charged
612     ///  the fee that existed at the time of a bounty's creation, in case the contract owner changes the
613     ///  fees between when the bounty is created and when the bounty creator withdraws their funds.
614     event CreateBountyAndLockFunds(
615     	uint256 bountyId,
616         address bidder,
617 		uint256 bountyPricePerCat,
618 		uint256 minBlockBountyValidUntil,
619         uint256 quantity,
620         uint256 geneMask,
621         uint256 genes,
622         uint256 earliestAcceptableIdInclusive,
623         uint256 latestAcceptableIdInclusive,
624         uint256 generation,
625         uint256 highestCooldownIndexAccepted,
626         uint256 unsuccessfulBountyFeeInWCKWei
627     );
628 
629     /// @dev This event is fired if a bounty hunter trades in a cat with the specified
630     ///  cattributes/generation/cooldown and claims the funds locked within the bounty.
631     /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract before
632     ///  calling fulfillBountyAndClaimFunds(). For better UX, fulfillBountyAndClaimFunds() can also
633     ///  be called by an account with the COO role, making it so that the user only has to send one
634     ///  transaction (the approve() transaction), and the frontend creator can send the followup
635     ///  fulfillBountyAndClaimFunds() transaction. There is no danger of this contract overreaching
636     ///  its approval, since the CryptoKitties Core contract's approve() function only approves this
637     ///  contract for a single Cryptokitty. Calling approve() allows this contract to transfer the
638     ///  specified kitty in the fulfillOfferAndClaimFunds() function.
639     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the
640     ///  bountyIdToBounty mapping.
641     /// @param kittyId  The id of the CryptoKitty that fulfills the bounty requirements.
642     /// @param bountyHunter  The address of the person who is fulfilling the bounty.
643     /// @param bountyPricePerCat  The price (in WCK_wei) that a user will receive if they successfully
644     ///  fulfill this bounty.
645     /// @param geneMask  A bounty creator specifies which portion of the CryptoKitties genome is
646     ///  relevant to this bounty. This is a bitwise mask, that zeroes out all other portions of the
647     ///  Cryptokitties genome besides those that the bounty creator is interested in.
648     /// @param genes  A bounty creator specifies which cattributes they are seeking. If a user
649     ///  possesses a cat that has both the specified cattributes and the specified generation, then
650     ///  they can trade that cat for the bounty.
651     /// @param earliestAcceptableIdInclusive  A bounty creator specifies the earliest ID that they
652     ///  would accept. They can submit 0 for this variable to be ignored.
653     /// @param latestAcceptableIdInclusive  A bounty creator specifies the latest ID that they
654     ///  would accept. They can submit uint128_max for this variable to be ignored.
655     /// @param generation  A bounty creator can specify the exact generation that they are seeking.
656     ///  If they are willing to accept cats of any generation that have the cattributes specified
657     ///  above, they may submit UINT16_MAX for this variable for it to be ignored.
658     /// @param highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex
659     ///  that they are seeking, allowing users to place bounties on virgin cats or cats with a
660     ///  sufficient cooldown to be useful in a fancy chase. If they are willing to accept cats of
661     ///  any cooldown, they may submit a cooldownIndex of 13 (which is the highest cooldown index
662     ///  that the Cryptokitties Core contract allows) for this variable to be ignored.
663     /// @param successfulBountyFeeInWCKWei  The fee that is paid when the bounty is fulfilled. This
664     ///  fee is calculated from totalValueIncludingFees and bountyPricePerCat, which are both stored in
665     ///  the Bounty struct to ensure that users are charged the fee that existed at the time of a
666     ///  bounty's creation, in case the owner changes the fees between when the bounty is created
667     ///  and when the bounty is fulfilled.
668     event FulfillBountyAndClaimFunds(
669         uint256 bountyId,
670         uint256 kittyId,
671         address bountyHunter,
672 		uint256 bountyPricePerCat,
673         uint256 geneMask,
674         uint256 genes,
675         uint256 earliestAcceptableIdInclusive,
676         uint256 latestAcceptableIdInclusive,
677         uint256 generation,
678         uint256 highestCooldownIndexAccepted,
679         uint256 successfulBountyFeeInWCKWei
680     );
681 
682     /// @dev This event is fired when a bounty creator wishes to invalidate a bounty. The bounty
683     ///  creator withdraws the funds and cancels the bounty, preventing anybody from fulfilling
684     ///  that particular bounty.
685     /// @notice If a bounty creator specified a lock time, a bounty creator cannot withdraw funds
686     ///  or invalidate a bounty until at least the originally specified number of blocks have
687     ///  passed. This guarantees a time period for bounty hunters to attempt to breed for a cat
688     ///  with the specified cattributes/generation/cooldown. However, if the contract is frozen,
689     ///  a bounty creator may withdraw their funds immediately with no fees taken by the contract
690     ///  owner, since the bounty creator would only freeze the contract if a vulnerability was found.
691     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the
692     ///  bountyIdToBounty mapping.
693     /// @param bidder  The creator of the bounty. This address receives the specified cat if the
694     ///  bounty is fulfilled, or receives their money back (minus unsuccessfulBountyFee) if the
695     ///  bounty is not fulfilled.
696     /// @param withdrawnAmount  The amount returned to the bounty creator (in WCK_wei). If the contract
697     ///  is not frozen, then this is the total value originally sent to the contract minus
698     ///  unsuccessfulBountyFeeInWCKWei. However, if the contract is frozen, no fees are taken, and the
699     ///  entire amount is returned to the bounty creator.
700     event WithdrawBounty(
701         uint256 bountyId,
702         address bidder,
703 		uint256 withdrawnAmount
704     );
705 
706     /* ******* */
707     /* STORAGE */
708     /* ******* */
709 
710     /// @dev An index that increments with each Bounty created. Allows the ability to jump directly
711     ///  to a specified bounty.
712     uint256 public bountyId = 0;
713 
714     /// @dev A mapping that tracks bounties that have been created, regardless of whether they have
715     ///  been cancelled or claimed thereafter. See the numCatsRemainingForBountyId mapping to determine
716     ///  whether a particular bounty is still active.
717     mapping (uint256 => Bounty) public bountyIdToBounty;
718 
719     /// @dev A mapping that tracks how many cats remain to be sent for a particular bounty. This is
720     ///  needed because people can create bulk bounties (e.g. 100 Gen 0's for 0.25 ETH each, etc.)
721     mapping (uint256 => uint256) public numCatsRemainingForBountyId;
722 
723     /* ********* */
724     /* FUNCTIONS */
725     /* ********* */
726 
727     /// @notice Allows a user to create a new bounty for a cat with a particular set of cattributes,
728     ///  generation, and/or cooldown. This optionally involves locking up a specified amount of eth
729     ///  for at least a specified number of blocks, in order to guarantee a time period for bounty
730     ///  hunters to attempt to breed for a cat with the specified cattributes and generation.
731     /// @param _geneMask  A bounty creator specifies which portion of the CryptoKitties genome is
732     ///  relevant to this bounty. This is a bitwise mask, that zeroes out all other portions of the
733     ///  Cryptokitties genome besides those that the bounty creator is interested in. If a bounty
734     ///  creator does not wish to specify genes (perhaps they want to specify generation, but don't
735     ///  have a preference for genes), they can submit a geneMask of uint256(0).
736     /// @param _genes  A bounty creator specifies which cattributes they are seeking. If a user
737     ///  possesses a cat that has the specified cattributes, the specified generation, and the
738     ///  specified cooldown, then they can trade that cat for the bounty.
739     /// @param _earliestAcceptableIdInclusive  A bounty creator specifies the earliest ID that they
740     ///  would accept. They can submit 0 for this variable to be ignored.
741     /// @param _latestAcceptableIdInclusive  A bounty creator specifies the latest ID that they
742     ///  would accept. They can submit uint128_max for this variable to be ignored.
743     /// @param _generation  A bounty creator can specify the exact generation that they are seeking.
744     ///  If they are willing to accept cats of any generation that have the cattributes specified
745     ///  above, they may submit UINT16_MAX for this variable for it to be ignored.
746     /// @param _highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex
747     ///  that they are seeking, allowing users to place bounties on virgin cats or cats with a
748     ///  sufficient cooldown to be useful in a fancy chase. If they are willing to accept cats of
749     ///  any cooldown, they may submit  a cooldownIndex of 13 (which is the highest cooldown index
750     ///  that the Cryptokitties Core contract allows) for this variable to be ignored.
751     /// @param _minNumBlocksBountyIsValidFor  The bounty creator specifies the minimum number of
752     ///  blocks that this bounty is valid for. Every bounty is valid until at least a specified
753     ///  block. Before that point, the owner cannot withdraw their funds (in order to guarantee a
754     ///  time period for bounty hunters to attempt to breed for the specified cat). After the time
755     ///  period has passed, the owner can withdraw their funds if they wish, but the bounty stays
756     ///  valid until they do so. This allows for the possiblity of leaving a bounty open indefinitely
757     ///  until it is filled if the bounty creator wishes to do so.
758     /// @param _quantity  A bounty creator specifies how many cats they would like to acquire with the
759     ///  specified characteristics. This allows a bounty creator to create bulk bounties (e.g. 100
760     ///  Gen 0's for 0.25 ETH each, etc.)
761     /// @param _totalAmountOfWCKToLock  A bounty creator specifies the total amount of WCK that they would like to
762     ///  lock up for this bundle of bounties. If the quantity that they specified is greater than one,
763     ///  then the totalValueIncludingFees per cat will be _totalAmountOfWCKToLock / _quantity
764     function createBountyAndLockFunds(uint256 _geneMask, uint256 _genes, uint256 _earliestAcceptableIdInclusive, uint256 _latestAcceptableIdInclusive, uint256 _generation, uint256 _highestCooldownIndexAccepted, uint256 _minNumBlocksBountyIsValidFor, uint256 _quantity, uint256 _totalAmountOfWCKToLock) external whenNotPaused {
765         require(_totalAmountOfWCKToLock >= unsuccessfulBountyFeeInWCKWei.mul(uint256(2)), 'the value of your bounty must be at least twice as large as the unsuccessful bounty fee');
766         require(_highestCooldownIndexAccepted <= uint256(13), 'you cannot specify an invalid cooldown index');
767         require(_generation <= uint256(~uint16(0)), 'you cannot specify an invalid generation');
768         require(_genes & ~_geneMask == uint256(0), 'your geneMask must fully cover any genes that you are seeking');
769         require(_quantity > 0, 'your bounty must be for at least one cat');
770         require(_quantity <= uint256(~uint32(0)), 'you cannot specify quantity greater than uint32_max');
771         require(_earliestAcceptableIdInclusive <= _latestAcceptableIdInclusive, 'you cannot specify a negative range');
772         require(_earliestAcceptableIdInclusive <= uint256(~uint128(0)), 'you cannot specify an earliestID greater than uint128_max');
773         require(_latestAcceptableIdInclusive <= uint256(~uint128(0)), 'you cannot specify a latestID greater than uint128_max');
774 
775         require(ERC20(wrappedKittiesAddress).transferFrom(msg.sender, address(this), _totalAmountOfWCKToLock) == true, 'failed to transfer WCK from account of sender');
776 
777         uint256 totalValueIncludingFeesPerCat = _totalAmountOfWCKToLock.div(_quantity);
778         uint256 bountyPricePerCat = _computeBountyPrice(totalValueIncludingFeesPerCat, successfulBountyFeeInBasisPoints);
779         uint256 minBlockBountyValidUntil = uint256(block.number).add(_minNumBlocksBountyIsValidFor);
780 
781         Bounty memory bounty = Bounty({
782             geneMask: _geneMask,
783             genes: _genes,
784             earliestAcceptableIdInclusive: uint128(_earliestAcceptableIdInclusive),
785             latestAcceptableIdInclusive: uint128(_latestAcceptableIdInclusive),
786             bountyPricePerCat: uint128(bountyPricePerCat),
787             totalValueIncludingFees: uint128(_totalAmountOfWCKToLock),
788             unsuccessfulBountyFeeInWCKWei: uint128(unsuccessfulBountyFeeInWCKWei),
789             minBlockBountyValidUntil: uint32(minBlockBountyValidUntil),
790             quantity: uint32(_quantity),
791             generation: uint16(_generation),
792             highestCooldownIndexAccepted: uint16(_highestCooldownIndexAccepted),
793             bidder: msg.sender
794         });
795 
796         bountyIdToBounty[bountyId] = bounty;
797         numCatsRemainingForBountyId[bountyId] = _quantity;
798 
799         emit CreateBountyAndLockFunds(
800             bountyId,
801             msg.sender,
802             bountyPricePerCat,
803             minBlockBountyValidUntil,
804             _quantity,
805             bounty.geneMask,
806             bounty.genes,
807             uint256(bounty.earliestAcceptableIdInclusive),
808             uint256(bounty.latestAcceptableIdInclusive),
809             uint256(bounty.generation),
810             uint256(bounty.highestCooldownIndexAccepted),
811             uint256(bounty.unsuccessfulBountyFeeInWCKWei)
812         );
813 
814         bountyId = bountyId.add(uint256(1));
815     }
816 
817     /// @notice After calling approve() in the CryptoKitties Core contract, a bounty hunter can
818     ///  submit the id of a kitty that they own and a bounty that they would like to fulfill. If
819     ///  the kitty fits the requirements of the bounty, and if the bounty hunter owns the kitty,
820     ///  then this function transfers the kitty to the original bounty creator and transfers the
821     ///  locked eth to the bounty hunter.
822     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found in
823     ///  the bountyIdToBounty mapping.
824     /// @param _kittyId  The id of the CryptoKitty that fulfills the bounty requirements.
825     /// @param _referrer  This address gets half of the successful bounty fees. This encourages
826     ///  third party developers to develop their own front-end UI's for the KittyBounties contract
827     ///  in order to receive half of the rewards.
828     /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract before
829     ///  calling fulfillBountyAndClaimFunds(). For better UX, fulfillBountyAndClaimFunds() can also
830     ///  be called by an account with the COO role, making it so that the user only has to send one
831     ///  transaction (the approve() transaction), and the frontend creator can send the followup
832     ///  fulfillBountyAndClaimFunds() transaction. There is no danger of this contract overreaching
833     ///  its approval, since the CryptoKitties Core contract's approve() function only approves this
834     ///  contract for a single Cryptokitty. Calling approve() allows this contract to transfer the
835     ///  specified kitty in the fulfillOfferAndClaimFunds() function.
836     function fulfillBountyAndClaimFunds(uint256 _bountyId, uint256 _kittyId, address _referrer) external whenNotPaused nonReentrant {
837     	address ownerOfCatBeingUsedToFulfillBounty = kittyCore.ownerOf(_kittyId);
838         require(numCatsRemainingForBountyId[_bountyId] > 0, 'this bounty has either already completed or has not yet begun');
839     	require(msg.sender == ownerOfCatBeingUsedToFulfillBounty || isCOO(msg.sender), 'you either do not own the cat or are not authorized to fulfill on behalf of others');
840     	require(kittyCore.kittyIndexToApproved(_kittyId) == address(this), 'you must approve() the bounties contract to give it permission to withdraw this cat before you can fulfill the bounty');
841 
842     	Bounty storage bounty = bountyIdToBounty[_bountyId];
843     	uint256 cooldownIndex;
844     	uint256 generation;
845     	uint256 genes;
846         ( , , cooldownIndex, , , , , , generation, genes) = kittyCore.getKitty(_kittyId);
847 
848         // By submitting 0 as the earliestAcceptableIdInclusive, a bounty creator can specify that they do not have
849     	// a preference for earliestAcceptableIdInclusive.
850         require(uint128(_kittyId) >= uint128(bounty.earliestAcceptableIdInclusive), 'your cat has an id that is too low to fulfill this bounty');
851         // By submitting uint128_max as the latestAcceptableIdInclusive, a bounty creator can specify that they do not have
852     	// a preference for latestAcceptableIdInclusive.
853         require(uint128(_kittyId) <= uint128(bounty.latestAcceptableIdInclusive), 'your cat has an id that is too high to fulfill this bounty');
854         // By submitting ~uint16(0) as the target generation (which is uint16_MAX), a bounty creator can specify that they do not have a preference for generation.
855     	require((uint16(bounty.generation) == ~uint16(0) || uint16(generation) == uint16(bounty.generation)), 'your cat is not the correct generation to fulfill this bounty');
856     	// By submitting uint256(0) as the target genemask and submitting uint256(0) for the target genes, a bounty creator can specify that they do not have
857     	// a preference for genes.
858     	require((genes & bounty.geneMask) == (bounty.genes & bounty.geneMask), 'your cat does not have the correct genes to fulfill this bounty');
859     	// By submitting 13 as the target highestCooldownIndexAccepted, a bounty creator can specify that they do not have a preference for cooldown (since
860     	// all Cryptokitties have a cooldown index less than or equal to 13).
861     	require(uint16(cooldownIndex) <= uint16(bounty.highestCooldownIndexAccepted), 'your cat does not have a low enough cooldown index to fulfill this bounty');
862 
863     	numCatsRemainingForBountyId[_bountyId] = numCatsRemainingForBountyId[_bountyId].sub(uint256(1));
864 
865     	kittyCore.transferFrom(ownerOfCatBeingUsedToFulfillBounty, bounty.bidder, _kittyId);
866 
867         uint256 totalValueIncludingFeesPerCat = uint256(bounty.totalValueIncludingFees).div(uint256(bounty.quantity));
868         uint256 successfulBountyFeeInWCKWei = totalValueIncludingFeesPerCat.sub(uint256(bounty.bountyPricePerCat));
869         if(_referrer != address(0)){
870             uint256 halfOfFees = successfulBountyFeeInWCKWei.div(uint256(2));
871             addressToFeeEarnings[_referrer] = addressToFeeEarnings[_referrer].add(halfOfFees);
872             addressToFeeEarnings[owner()] = addressToFeeEarnings[owner()].add(halfOfFees);
873         } else {
874             addressToFeeEarnings[owner()] = addressToFeeEarnings[owner()].add(successfulBountyFeeInWCKWei);
875         }
876 
877         require(ERC20(wrappedKittiesAddress).transfer(ownerOfCatBeingUsedToFulfillBounty, uint256(bounty.bountyPricePerCat)) == true, 'failed to transfer WCK');
878 
879     	emit FulfillBountyAndClaimFunds(
880             _bountyId,
881             _kittyId,
882 	        ownerOfCatBeingUsedToFulfillBounty,
883 			uint256(bounty.bountyPricePerCat),
884 	        bounty.geneMask,
885 	        bounty.genes,
886             uint256(bounty.earliestAcceptableIdInclusive),
887             uint256(bounty.latestAcceptableIdInclusive),
888 	        uint256(bounty.generation),
889 	        uint256(bounty.highestCooldownIndexAccepted),
890 	        successfulBountyFeeInWCKWei
891         );
892     }
893 
894     /// @notice Allows a bounty creator to withdraw the funds locked within a bounty, but only
895     ///  once a specified time period (measured in blocks) has passed. Prohibiting the bounty
896     ///  creator from withdrawing their funds until this point guarantees a time period for
897     ///  bounty hunters to attempt to breed for a cat with the specified cattributes and
898     ///  generation. If a bounty creator withdraws their funds, then the bounty is invalidated
899     ///  and bounty hunters can no longer try to fulfill it. A flat fee is taken from the bounty
900     ///  creator's original deposit, specified by unsuccessfulBountyFeeInWCKWei.
901     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found in
902     ///  the bountyIdToBounty mapping.
903     /// @param _referrer  This address gets half of the unsuccessful bounty fees. This encourages
904     ///  third party developers to develop their own frontends for the KittyBounties contract and
905     ///  get half of the rewards.
906     function withdrawUnsuccessfulBounty(uint256 _bountyId, address _referrer) external whenNotPaused nonReentrant {
907     	require(numCatsRemainingForBountyId[_bountyId] > 0, 'this bounty has either already completed or has not yet begun');
908     	Bounty storage bounty = bountyIdToBounty[_bountyId];
909     	require(msg.sender == bounty.bidder, 'you cannot withdraw the funds for someone elses bounty');
910     	require(block.number >= uint256(bounty.minBlockBountyValidUntil), 'this bounty is not withdrawable until the minimum number of blocks that were originally specified have passed');
911 
912         uint256 totalValueIncludingFeesPerCat = uint256(bounty.totalValueIncludingFees).div(uint256(bounty.quantity));
913         uint256 totalValueRemainingForBountyId = totalValueIncludingFeesPerCat.mul(numCatsRemainingForBountyId[_bountyId]);
914 
915         numCatsRemainingForBountyId[_bountyId] = 0;
916 
917         uint256 amountToReturnToBountyCreator;
918         uint256 amountToTakeAsFees;
919 
920         if(totalValueRemainingForBountyId < bounty.unsuccessfulBountyFeeInWCKWei){
921             amountToTakeAsFees = totalValueRemainingForBountyId;
922             amountToReturnToBountyCreator = 0;
923         } else {
924             amountToTakeAsFees = bounty.unsuccessfulBountyFeeInWCKWei;
925             amountToReturnToBountyCreator = totalValueRemainingForBountyId.sub(uint256(amountToTakeAsFees));
926         }
927 
928         if(_referrer != address(0)){
929             uint256 halfOfFees = uint256(amountToTakeAsFees).div(uint256(2));
930             addressToFeeEarnings[_referrer] = addressToFeeEarnings[_referrer].add(uint256(halfOfFees));
931             addressToFeeEarnings[owner()] = addressToFeeEarnings[owner()].add(uint256(halfOfFees));
932         } else {
933             addressToFeeEarnings[owner()] = addressToFeeEarnings[owner()].add(uint256(amountToTakeAsFees));
934         }
935 
936         if(amountToReturnToBountyCreator > 0){
937             require(ERC20(wrappedKittiesAddress).transfer(bounty.bidder, amountToReturnToBountyCreator) == true, 'failed to transfer WCK');
938         }
939 
940     	emit WithdrawBounty(
941             _bountyId,
942             bounty.bidder,
943             amountToReturnToBountyCreator
944         );
945     }
946 
947     /// @notice Allows a bounty creator to withdraw the funds locked within a bounty, even if
948     ///  the time period that the bounty was guaranteed to be locked for has not passed. This
949     ///  function can only be called when the contract is frozen, and would be used as an
950     ///  emergency measure to allow users to withdraw their funds immediately. No fees are
951     ///  taken when this function is called.
952     /// @notice Only callable when the contract is frozen.
953     /// @notice It is safe for the owner of the contract to call this function because the
954     ///  funds are still returned to the original bidder, and this function can only be called
955     ///  when the contract is frozen.
956     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found
957     ///  in the bountyIdToBounty mapping.
958     function withdrawBountyWithNoFeesTakenIfContractIsFrozen(uint256 _bountyId) external whenPaused nonReentrant {
959     	require(numCatsRemainingForBountyId[_bountyId] > 0, 'this bounty has either already completed or has not yet begun');
960     	Bounty storage bounty = bountyIdToBounty[_bountyId];
961     	require(msg.sender == bounty.bidder || isOwner(), 'you are not the bounty creator or the contract owner');
962 
963         uint256 totalValueIncludingFeesPerCat = uint256(bounty.totalValueIncludingFees).div(uint256(bounty.quantity));
964         uint256 totalValueRemainingForBountyId = totalValueIncludingFeesPerCat.mul(numCatsRemainingForBountyId[_bountyId]);
965 
966         numCatsRemainingForBountyId[_bountyId] = 0;
967 
968         require(ERC20(wrappedKittiesAddress).transfer(bounty.bidder, totalValueRemainingForBountyId) == true, 'failed to transfer WCK');
969 
970     	emit WithdrawBounty(
971             _bountyId,
972             bounty.bidder,
973             totalValueRemainingForBountyId
974         );
975     }
976 
977     /// @notice Computes the bounty price given a total value sent when creating a bounty,
978     ///  and the current successfulBountyFee in percentage basis points.
979     /// @dev 10000 is not a magic number, but is the maximum number of basis points that
980     ///  can exist (with basis points being hundredths of a percent).
981     /// @param _totalValueIncludingFees The amount of ether (in wei) that was sent to
982     ///  create a bounty
983     /// @param _successfulBountyFeeInBasisPoints The percentage (in basis points) of that
984     ///  total amount that will be taken as a fee if the bounty is successfully completed.
985     /// @return The amount of ether (in wei) that will be rewarded if the bounty is
986     ///  successfully fulfilled
987     function _computeBountyPrice(uint256 _totalValueIncludingFees, uint256 _successfulBountyFeeInBasisPoints) internal pure returns (uint256) {
988     	return (_totalValueIncludingFees.mul(uint256(10000).sub(_successfulBountyFeeInBasisPoints))).div(uint256(10000));
989     }
990 
991     /// @dev By calling 'revert' in the fallback function, we prevent anyone from
992     ///  accidentally sending funds directly to this contract.
993     function() external payable {
994         revert();
995     }
996 }