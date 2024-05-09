1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address previousOwner, address newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 
75 /**
76  * @title Roles
77  * @dev Library for managing addresses assigned to a Role.
78  */
79 library Roles {
80     struct Role {
81         mapping (address => bool) bearer;
82     }
83 
84     /**
85      * @dev give an account access to this role
86      */
87     function add(Role storage role, address account) internal {
88         require(account != address(0));
89         require(!has(role, account));
90 
91         role.bearer[account] = true;
92     }
93 
94     /**
95      * @dev remove an account's access to this role
96      */
97     function remove(Role storage role, address account) internal {
98         require(account != address(0));
99         require(has(role, account));
100 
101         role.bearer[account] = false;
102     }
103 
104     /**
105      * @dev check if an account has this role
106      * @return bool
107      */
108     function has(Role storage role, address account) internal view returns (bool) {
109         require(account != address(0));
110         return role.bearer[account];
111     }
112 }
113 
114 
115 contract PauserRole {
116     using Roles for Roles.Role;
117 
118     event PauserAdded(address indexed account);
119     event PauserRemoved(address indexed account);
120 
121     Roles.Role private _pausers;
122 
123     constructor () internal {
124         _addPauser(msg.sender);
125     }
126 
127     modifier onlyPauser() {
128         require(isPauser(msg.sender));
129         _;
130     }
131 
132     function isPauser(address account) public view returns (bool) {
133         return _pausers.has(account);
134     }
135 
136     function addPauser(address account) public onlyPauser {
137         _addPauser(account);
138     }
139 
140     function renouncePauser() public {
141         _removePauser(msg.sender);
142     }
143 
144     function _addPauser(address account) internal {
145         _pausers.add(account);
146         emit PauserAdded(account);
147     }
148 
149     function _removePauser(address account) internal {
150         _pausers.remove(account);
151         emit PauserRemoved(account);
152     }
153 }
154 
155 
156 /**
157  * @title Pausable
158  * @dev Base contract which allows children to implement an emergency stop mechanism.
159  */
160 contract Pausable is PauserRole {
161     event Paused(address account);
162     event Unpaused(address account);
163 
164     bool private _paused;
165 
166     constructor () internal {
167         _paused = false;
168     }
169 
170     /**
171      * @return true if the contract is paused, false otherwise.
172      */
173     function paused() public view returns (bool) {
174         return _paused;
175     }
176 
177     /**
178      * @dev Modifier to make a function callable only when the contract is not paused.
179      */
180     modifier whenNotPaused() {
181         require(!_paused);
182         _;
183     }
184 
185     /**
186      * @dev Modifier to make a function callable only when the contract is paused.
187      */
188     modifier whenPaused() {
189         require(_paused);
190         _;
191     }
192 
193     /**
194      * @dev called by the owner to pause, triggers stopped state
195      */
196     function pause() public onlyPauser whenNotPaused {
197         _paused = true;
198         emit Paused(msg.sender);
199     }
200 
201     /**
202      * @dev called by the owner to unpause, returns to normal state
203      */
204     function unpause() public onlyPauser whenPaused {
205         _paused = false;
206         emit Unpaused(msg.sender);
207     }
208 }
209 
210 
211 contract COORole {
212     using Roles for Roles.Role;
213 
214     event COOAdded(address indexed account);
215     event COORemoved(address indexed account);
216 
217     Roles.Role private _COOs;
218 
219     constructor () internal {
220         _addCOO(msg.sender);
221     }
222 
223     modifier onlyCOO() {
224         require(isCOO(msg.sender));
225         _;
226     }
227 
228     function isCOO(address account) public view returns (bool) {
229         return _COOs.has(account);
230     }
231 
232     function addCOO(address account) public onlyCOO {
233         _addCOO(account);
234     }
235 
236     function renounceCOO() public {
237         _removeCOO(msg.sender);
238     }
239 
240     function _addCOO(address account) internal {
241         _COOs.add(account);
242         emit COOAdded(account);
243     }
244 
245     function _removeCOO(address account) internal {
246         _COOs.remove(account);
247         emit COORemoved(account);
248     }
249 }
250 
251 
252 /**
253  * @title Helps contracts guard against reentrancy attacks.
254  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
255  * @dev If you mark a function `nonReentrant`, you should also
256  * mark it `external`.
257  */
258 contract ReentrancyGuard {
259     /// @dev counter to allow mutex lock with only one SSTORE operation
260     uint256 private _guardCounter;
261 
262     constructor () internal {
263         // The counter starts at one to prevent changing it from zero to a non-zero
264         // value, which is a more expensive operation.
265         _guardCounter = 1;
266     }
267 
268     /**
269      * @dev Prevents a contract from calling itself, directly or indirectly.
270      * Calling a `nonReentrant` function from another `nonReentrant`
271      * function is not supported. It is possible to prevent this from happening
272      * by making the `nonReentrant` function external, and make it call a
273      * `private` function that does the actual work.
274      */
275     modifier nonReentrant() {
276         _guardCounter += 1;
277         uint256 localCounter = _guardCounter;
278         _;
279         require(localCounter == _guardCounter);
280     }
281 }
282 
283 
284 /**
285  * @title SafeMath
286  * @dev Unsigned math operations with safety checks that revert on error
287  */
288 library SafeMath {
289     /**
290     * @dev Multiplies two unsigned integers, reverts on overflow.
291     */
292     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
293         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
294         // benefit is lost if 'b' is also tested.
295         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
296         if (a == 0) {
297             return 0;
298         }
299 
300         uint256 c = a * b;
301         require(c / a == b);
302 
303         return c;
304     }
305 
306     /**
307     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
308     */
309     function div(uint256 a, uint256 b) internal pure returns (uint256) {
310         // Solidity only automatically asserts when dividing by 0
311         require(b > 0);
312         uint256 c = a / b;
313         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
314 
315         return c;
316     }
317 
318     /**
319     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
320     */
321     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
322         require(b <= a);
323         uint256 c = a - b;
324 
325         return c;
326     }
327 
328     /**
329     * @dev Adds two unsigned integers, reverts on overflow.
330     */
331     function add(uint256 a, uint256 b) internal pure returns (uint256) {
332         uint256 c = a + b;
333         require(c >= a);
334 
335         return c;
336     }
337 
338     /**
339     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
340     * reverts when dividing by zero.
341     */
342     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
343         require(b != 0);
344         return a % b;
345     }
346 }
347 
348 
349 /// @title Admin contract for KittyBounties. Holds owner-only functions to adjust contract-wide fees, change owners, etc.
350 /// @dev The owner is not capable of changing the address of the CryptoKitties Core contract once the contract has been deployed.
351 ///  This prevents an attack vector where the owner could change the kittyCore contract once users had already deposited funds.
352 contract KittyBountiesAdmin is Ownable, Pausable, ReentrancyGuard, COORole {
353 
354     /* ****** */
355     /* EVENTS */
356     /* ****** */
357 
358     /// @dev This event is fired whenever the owner changes the successfulBountyFeeInBasisPoints.
359     /// @param newSuccessfulBountyFeeInBasisPoints  The SuccessfulFee is expressed in basis points (hundredths of a percantage), 
360     ///  and is charged when a bounty is successfully completed.
361     event SuccessfulBountyFeeInBasisPointsUpdated(uint256 newSuccessfulBountyFeeInBasisPoints);
362 
363     /// @dev This event is fired whenever the owner changes the unsuccessfulBountyFeeInWei. 
364     /// @param newUnsuccessfulBountyFeeInWei  The UnsuccessfulBountyFee is paid by the original bounty creator if the bounty expires 
365     ///  without being completed. When a bounty is created, the bounty creator specifies how long the bounty is valid for. If the 
366     ///  bounty is not fulfilled by this expiration date, the original creator can then freely withdraw their funds, minus the 
367     ///  UnsuccessfulBountyFee, although the bounty is still fulfillable until the bounty creator withdraws their funds.
368     event UnsuccessfulBountyFeeInWeiUpdated(uint256 newUnsuccessfulBountyFeeInWei);
369 
370     /* ******* */
371     /* STORAGE */
372     /* ******* */
373 
374     /// @dev The amount of fees collected (in wei). This includes both fees to the contract owner and fees to any bounty referrers. 
375     ///  Storing earnings saves gas rather than performing an additional transfer() call on every successful bounty.
376     mapping (address => uint256) public addressToFeeEarnings;
377 
378     /// @dev If a bounty is successfully fulfilled, this fee applies before the remaining funds are sent to the successful bounty
379     ///  hunter. This fee is measured in basis points (hundredths of a percent), and is taken out of the total value that the bounty
380     ///  creator locked up in the contract when they created the bounty.
381     uint256 public successfulBountyFeeInBasisPoints = 375;
382 
383     /// @dev If a bounty is not fulfilled after the lockup period has completed, a bounty creator can withdraw their funds and
384     ///  invalidate the bounty, but they are charged this flat fee to do so. This fee is measured in wei.
385     uint256 public unsuccessfulBountyFeeInWei = 0.008 ether;
386 
387     /* ********* */
388     /* CONSTANTS */
389     /* ********* */
390 
391     /// @dev The owner is not capable of changing the address of the CryptoKitties Core contract once the contract has been deployed.
392     ///  This prevents an attack vector where the owner could change the kittyCore contract once users had already deposited funds.
393     ///  Since the CryptoKitties Core contract has the ability to migrate to a new contract, if Dapper Labs Inc. ever chooses to migrate
394     ///  contract, this contract will have to be frozen, and users will be allowed to withdraw their funds without paying any fees.
395     address public kittyCoreAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
396     KittyCore kittyCore;
397 
398     /* ********* */
399     /* FUNCTIONS */
400     /* ********* */
401 
402     /// @dev The owner is not capable of changing the address of the CryptoKitties Core contract once the contract has been deployed.
403     ///  This prevents an attack vector where the owner could change the kittyCore contract once users had already deposited funds.
404     constructor() internal {
405         kittyCore = KittyCore(kittyCoreAddress);
406     }
407 
408     /// @notice Sets the successfulBountyFeeInBasisPoints value (in basis points). Any bounties that are successfully fulfilled 
409     ///  will have this fee deducted from amount sent to the bounty hunter.
410     /// @notice Only callable by the owner.
411     /// @dev As this configuration is a basis point, the value to set must be less than or equal to 10000.
412     /// @param _newSuccessfulBountyFeeInBasisPoints  The successfulBountyFeeInBasisPoints value to set (measured in basis points).
413     function setSuccessfulBountyFeeInBasisPoints(uint256 _newSuccessfulBountyFeeInBasisPoints) external onlyOwner {
414         require(_newSuccessfulBountyFeeInBasisPoints <= 10000, 'new successful bounty fee must be in basis points (hundredths of a percent), not wei');
415         successfulBountyFeeInBasisPoints = _newSuccessfulBountyFeeInBasisPoints;
416         emit SuccessfulBountyFeeInBasisPointsUpdated(_newSuccessfulBountyFeeInBasisPoints);
417     }
418 
419     /// @notice Sets the unsuccessfulBountyFeeInWei value. If a bounty is still unfulfilled once the minimum number of blocks has passed,
420     ///  an owner can withdraw the locked ETH. If they do so, this fee is deducted from the amount that they withdraw.
421     /// @notice Only callable by the owner.
422     /// @param _newUnsuccessfulBountyFeeInWei  The unsuccessfulBountyFeeInWei value to set (measured in wei).
423     function setUnsuccessfulBountyFeeInWei(uint256 _newUnsuccessfulBountyFeeInWei) external onlyOwner {
424         unsuccessfulBountyFeeInWei = _newUnsuccessfulBountyFeeInWei;
425         emit UnsuccessfulBountyFeeInWeiUpdated(_newUnsuccessfulBountyFeeInWei);
426     }
427 
428     /// @notice Withdraws the fees that have been earned by either the contract owner or referrers.
429     /// @notice Only callable by the address that had earned the fees.
430     function withdrawFeeEarningsForAddress() external nonReentrant {
431         uint256 balance = addressToFeeEarnings[msg.sender];
432         require(balance > 0, 'there are no fees to withdraw for this address');
433         addressToFeeEarnings[msg.sender] = 0;
434         msg.sender.transfer(balance);
435     }
436 
437     /// @notice Gives the authority for the contract owner to remove any additional accounts that have been granted the ability to 
438     ///  pause the contract
439     /// @notice Only callable by the owner.
440     /// @param _account  The account to have the ability to pause the contract revoked
441     function removePauser(address _account) external onlyOwner {
442         _removePauser(_account);
443     }
444 
445     /// @notice Gives the authority for the contract owner to remove any additional accounts that have been granted the COO authority
446     /// @notice Only callable by the owner.
447     /// @param _account  The account to have COO authority revoked
448     function removeCOO(address _account) external onlyOwner {
449         _removeCOO(_account);
450     }
451 
452     /// @dev By calling 'revert' in the fallback function, we prevent anyone from accidentally sending funds directly to this contract.
453     function() external payable {
454         revert();
455     }
456 }
457 
458 /// @title Interface for interacting with the CryptoKitties Core contract created by Dapper Labs Inc.
459 contract KittyCore {
460     function getKitty(uint _id) public returns (
461         bool isGestating,
462         bool isReady,
463         uint256 cooldownIndex,
464         uint256 nextActionAt,
465         uint256 siringWithId,
466         uint256 birthTime,
467         uint256 matronId,
468         uint256 sireId,
469         uint256 generation,
470         uint256 genes
471     );
472     function ownerOf(uint256 _tokenId) public view returns (address owner);
473     function transferFrom(address _from, address _to, uint256 _tokenId) external;
474     mapping (uint256 => address) public kittyIndexToApproved;
475 }
476 
477 
478 /// @title Main contract for KittyBounties. This contract manages funds from creation to fulfillment for bounties.
479 /// @notice Once created, a bounty locks up ether. Optionally, the bounty creator may specify a number of blocks 
480 ///  to "lock" their bounty, thus preventing them from being able to cancel their bounty or withdraw their ether 
481 ///  until that number of blocks have passed. This guarantees a time period for bounty hunters to attempt to 
482 ///  breed for a cat with the specified cattributes, generation, and/or cooldown. This option is included since 
483 ///  perhaps many breeders will not chase a bounty without this guarantee. After that point, the bounty creator 
484 ///  can withdraw their funds if they wish and invalidate the bounty, or they can continue to leave the bounty 
485 ///  active.
486 /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract before 
487 ///  calling fulfillBountyAndClaimFunds(). For better UX, fulfillBountyAndClaimFunds() can also
488 ///  be called by an account with the COO role, making it so that the user only has to send one 
489 ///  transaction (the approve() transaction), and the frontend creator can send the followup 
490 ///  fulfillBountyAndClaimFunds() transaction. There is no danger of this contract overreaching 
491 ///  its approval, since the CryptoKitties Core contract's approve() function only approves this 
492 ///  contract for a single Cryptokitty. Calling approve() allows this contract to transfer the 
493 ///  specified kitty in the fulfillOfferAndClaimFunds() function.
494 contract KittyBounties is KittyBountiesAdmin {
495 
496     // OpenZeppelin's SafeMath library is used for all arithmetic operations to avoid overflows/underflows.
497     using SafeMath for uint256;
498 
499 	/* ********** */
500     /* DATA TYPES */
501     /* ********** */
502 
503     /// @dev The main Bounty struct. The struct fits in four 256-bits words due to Solidity's rules for struct 
504     ///  packing.
505 	struct Bounty {
506 		// A bounty creator specifies which portion of the CryptoKitties genome is relevant to this bounty.
507 		// This is a bitwise mask, that zeroes out all other portions of the Cryptokitties genome besides
508         // those that the bounty creator is interested in. If a bounty creator does not wish to specify 
509         // genes (perhaps they want to specify generation, but don't have a preference for genes), they can 
510         // submit a geneMask of uint256(0) and genes of uint256(0).
511 		uint256 geneMask;
512         // A bounty creator specifies which cattributes they are seeking. If a user possesses a cat that 
513         // has both the specified cattributes, the specified generation, and the specified cooldown, then 
514         // they can trade that cat for the bounty. If a bounty creator does not wish to specify genes 
515         // (perhaps they want to specify generation, but don't have a preference for genes), they can 
516         // submit a geneMask of uint256(0) and genes of uint256(0).
517         uint256 genes;
518 		// The price (in wei) that a user will receive if they successfully fulfill this bounty.
519 		uint128 bountyPricePerCat;
520 		// The total value (in wei) that the bounty creator originally sent to the contract to create this 
521         // bounty. This includes the potential fees to be paid to the contract creator.
522 		uint128 totalValueIncludingFees;
523 		// The fee that is paid if the bounty is not fulfilled and the owner withdraws their funds. This 
524         // is stored in the Bounty struct to ensure that users are charged the fee that existed at the 
525         // time of a bounty's creation, in case the contract owner changes the fees between when the bounty 
526         // is created and when the bounty creator withdraws their funds.
527 		uint128 unsuccessfulBountyFeeInWei;
528 		// Optionally, a bounty creator can set a minimum number of blocks that must pass before they can 
529         // cancel a bounty and withdraw their funds (in order to guarantee a time period for bounty hunters 
530         // to attempt to breed for the specified cat). After the time period has passed, the owner can 
531         // withdraw their funds if they wish, but the bounty stays valid until they do so. This allows for 
532         // the possiblity of leaving a bounty open indefinitely until it is filled if the bounty creator 
533         // wishes to do so.
534 		uint32 minBlockBountyValidUntil;
535         /// A bounty creator specifies how many cats they would like to acquire with these characteristics. 
536         /// This allows a bounty creator to create bulk bounties (e.g. 100 Gen 0's for 0.25 ETH each, etc.)
537         uint32 quantity;
538         // A bounty creator can specify the exact generation that they are seeking. If they are willing to 
539         // accept cats of any generation that have the cattributes specified above, they may submit 
540         // UINT16_MAX for this variable for it to be ignored.
541         uint16 generation;
542 		// A bounty creator can specify the highest cooldownIndex that they are seeking, allowing users to 
543         // place bounties on virgin cats or cats with a sufficient cooldown to be useful in a fancy chase. 
544         // If they are willing to accept cats of any cooldown, they may submit a cooldownIndex of 13 (which 
545         // is the highest cooldown index that the Cryptokitties Core contract allows) for this variable to 
546         // be ignored.
547         uint16 highestCooldownIndexAccepted;
548         // The creator of the bounty. This address receives the specified cat if the bounty is fulfilled, 
549         // or receives their money back (minus unsuccessfulBountyFee) if the bounty is not fulfilled.
550 		address bidder;
551     }
552 
553     /* ****** */
554     /* EVENTS */
555     /* ****** */
556 
557     /// @dev This event is fired whenever a user creates a new bounty for a cat with a particular set of 
558     ///  cattributes, generation, and/or cooldown that they are seeking.
559     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the 
560     ///  bountyIdToBounty mapping.
561     /// @param bidder  The creator of the bounty. This address receives the specified cat if the bounty 
562     ///  is fulfilled, or receives their money back (minus unsuccessfulBountyFee) if the bounty is not 
563     ///  fulfilled.
564     /// @param bountyPricePerCat  The price (in wei) that a user will receive if they successfully fulfill 
565     ///  this bounty.
566     /// @param minBlockBountyValidUntil  Every bounty is valid until at least a specified block. Before 
567     ///  that point, the owner cannot withdraw their funds (in order to guarantee a time period for bounty 
568     ///  hunters to attempt to breed for the specified cat). After the time period has passed, the owner 
569     ///  can withdraw their funds if they wish, but the bounty stays valid until they do so. This allows 
570     ///  for the possiblity of leaving a bounty open indefinitely until it is filled if the bounty creator 
571     ///  wishes to do so.
572     /// @param quantity  A bounty creator specifies how many cats they would like to acquire with the 
573     ///  specified characteristics. This allows a bounty creator to create bulk bounties (e.g. 100 
574     ///  Gen 0's, etc.)
575     /// @param geneMask  A bounty creator specifies which portion of the CryptoKitties genome is relevant 
576     ///  to this bounty. This is a bitwise mask, that zeroes out all other portions of the Cryptokitties 
577     ///  genome besides those that the bounty creator is interested in. 
578     /// @param genes  A bounty creator specifies which cattributes they are seeking. If a user possesses 
579     ///  a cat that has both the specified cattributes and the specified generation, then they can trade 
580     ///  that cat for the bounty.
581     /// @param generation  A bounty creator can specify the exact generation that they are seeking. If 
582     ///  they are willing to accept cats of any generation that have the cattributes specified above, 
583     ///  they may submit UINT16_MAX for this variable for it to be ignored.
584     /// @param highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex that 
585     ///  they are seeking, allowing users to place bounties on virgin cats or cats with a sufficient 
586     ///  cooldown to be useful in a fancy chase. If they are willing to accept cats of any cooldown, they 
587     ///  may submit a cooldownIndex of 13 (which is the highest cooldown index that the Cryptokitties 
588     ///  Core contract allows) for this variable to be ignored.
589     /// @param unsuccessfulBountyFeeInWei  The fee that is paid if the bounty is not fulfilled and the 
590     ///  owner withdraws their funds. This is stored in the Bounty struct to ensure that users are charged 
591     ///  the fee that existed at the time of a bounty's creation, in case the contract owner changes the 
592     ///  fees between when the bounty is created and when the bounty creator withdraws their funds.
593     event CreateBountyAndLockFunds(
594     	uint256 bountyId,
595         address bidder,
596 		uint256 bountyPricePerCat,
597 		uint256 minBlockBountyValidUntil,
598         uint256 quantity,
599         uint256 geneMask,
600         uint256 genes,
601         uint256 generation,
602         uint256 highestCooldownIndexAccepted,
603         uint256 unsuccessfulBountyFeeInWei
604     );
605 
606     /// @dev This event is fired if a bounty hunter trades in a cat with the specified 
607     ///  cattributes/generation/cooldown and claims the funds locked within the bounty.
608     /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract before 
609     ///  calling fulfillBountyAndClaimFunds(). For better UX, fulfillBountyAndClaimFunds() can also
610     ///  be called by an account with the COO role, making it so that the user only has to send one 
611     ///  transaction (the approve() transaction), and the frontend creator can send the followup 
612     ///  fulfillBountyAndClaimFunds() transaction. There is no danger of this contract overreaching 
613     ///  its approval, since the CryptoKitties Core contract's approve() function only approves this 
614     ///  contract for a single Cryptokitty. Calling approve() allows this contract to transfer the 
615     ///  specified kitty in the fulfillOfferAndClaimFunds() function.
616     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the 
617     ///  bountyIdToBounty mapping.
618     /// @param kittyId  The id of the CryptoKitty that fulfills the bounty requirements. 
619     /// @param bidder  The creator of the bounty. This address receives the specified cat if the 
620     ///  bounty is fulfilled, or receives their money back (minus unsuccessfulBountyFee) if the 
621     ///  bounty is not fulfilled.
622     /// @param bountyPricePerCat  The price (in wei) that a user will receive if they successfully 
623     ///  fulfill this bounty.
624     /// @param geneMask  A bounty creator specifies which portion of the CryptoKitties genome is 
625     ///  relevant to this bounty. This is a bitwise mask, that zeroes out all other portions of the 
626     ///  Cryptokitties genome besides those that the bounty creator is interested in. 
627     /// @param genes  A bounty creator specifies which cattributes they are seeking. If a user 
628     ///  possesses a cat that has both the specified cattributes and the specified generation, then 
629     ///  they can trade that cat for the bounty.
630     /// @param generation  A bounty creator can specify the exact generation that they are seeking. 
631     ///  If they are willing to accept cats of any generation that have the cattributes specified 
632     ///  above, they may submit UINT16_MAX for this variable for it to be ignored.
633     /// @param highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex 
634     ///  that they are seeking, allowing users to place bounties on virgin cats or cats with a 
635     ///  sufficient cooldown to be useful in a fancy chase. If they are willing to accept cats of 
636     ///  any cooldown, they may submit a cooldownIndex of 13 (which is the highest cooldown index 
637     ///  that the Cryptokitties Core contract allows) for this variable to be ignored.
638     /// @param successfulBountyFeeInWei  The fee that is paid when the bounty is fulfilled. This 
639     ///  fee is calculated from totalValueIncludingFees and bountyPricePerCat, which are both stored in 
640     ///  the Bounty struct to ensure that users are charged the fee that existed at the time of a 
641     ///  bounty's creation, in case the owner changes the fees between when the bounty is created 
642     ///  and when the bounty is fulfilled.
643     event FulfillBountyAndClaimFunds(
644         uint256 bountyId,
645         uint256 kittyId,
646         address bidder,
647 		uint256 bountyPricePerCat,
648         uint256 geneMask,
649         uint256 genes,
650         uint256 generation,
651         uint256 highestCooldownIndexAccepted,
652         uint256 successfulBountyFeeInWei
653     );
654 
655     /// @dev This event is fired when a bounty creator wishes to invalidate a bounty. The bounty 
656     ///  creator withdraws the funds and cancels the bounty, preventing anybody from fulfilling 
657     ///  that particular bounty.
658     /// @notice If a bounty creator specified a lock time, a bounty creator cannot withdraw funds 
659     ///  or invalidate a bounty until at least the originally specified number of blocks have 
660     ///  passed. This guarantees a time period for bounty hunters to attempt to breed for a cat 
661     ///  with the specified cattributes/generation/cooldown. However, if the contract is frozen, 
662     ///  a bounty creator may withdraw their funds immediately with no fees taken by the contract 
663     ///  owner, since the bounty creator would only freeze the contract if a vulnerability was found.
664     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the 
665     ///  bountyIdToBounty mapping.
666     /// @param bidder  The creator of the bounty. This address receives the specified cat if the 
667     ///  bounty is fulfilled, or receives their money back (minus unsuccessfulBountyFee) if the 
668     ///  bounty is not fulfilled.
669     /// @param withdrawnAmount  The amount returned to the bounty creator (in wei). If the contract
670     ///  is not frozen, then this is the total value originally sent to the contract minus 
671     ///  unsuccessfulBountyFeeInWei. However, if the contract is frozen, no fees are taken, and the 
672     ///  entire amount is returned to the bounty creator.
673     event WithdrawBounty(
674         uint256 bountyId,
675         address bidder,
676 		uint256 withdrawnAmount
677     );
678 
679     /* ******* */
680     /* STORAGE */
681     /* ******* */
682 
683     /// @dev An index that increments with each Bounty created. Allows the ability to jump directly 
684     ///  to a specified bounty.
685     uint256 public bountyId = 0;
686 
687     /// @dev A mapping that tracks bounties that have been created, regardless of whether they have 
688     ///  been cancelled or claimed thereafter. See the numCatsRemainingForBountyId mapping to determine 
689     ///  whether a particular bounty is still active.
690     mapping (uint256 => Bounty) public bountyIdToBounty;
691 
692     /// @dev A mapping that tracks how many cats remain to be sent for a particular bounty. This is 
693     ///  needed because people can create bulk bounties (e.g. 100 Gen 0's for 0.25 ETH each, etc.)
694     mapping (uint256 => uint256) public numCatsRemainingForBountyId;
695 
696     /* ********* */
697     /* FUNCTIONS */
698     /* ********* */
699 
700     /// @notice Allows a user to create a new bounty for a cat with a particular set of cattributes, 
701     ///  generation, and/or cooldown. This optionally involves locking up a specified amount of eth 
702     ///  for at least a specified number of blocks, in order to guarantee a time period for bounty 
703     ///  hunters to attempt to breed for a cat with the specified cattributes and generation. 
704 	/// @param _geneMask  A bounty creator specifies which portion of the CryptoKitties genome is 
705     ///  relevant to this bounty. This is a bitwise mask, that zeroes out all other portions of the 
706     ///  Cryptokitties genome besides those that the bounty creator is interested in. If a bounty 
707     ///  creator does not wish to specify genes (perhaps they want to specify generation, but don't 
708     ///  have a preference for genes), they can submit a geneMask of uint256(0).
709     /// @param _genes  A bounty creator specifies which cattributes they are seeking. If a user 
710     ///  possesses a cat that has the specified cattributes, the specified generation, and the 
711     ///  specified cooldown, then they can trade that cat for the bounty.
712     /// @param _generation  A bounty creator can specify the exact generation that they are seeking. 
713     ///  If they are willing to accept cats of any generation that have the cattributes specified 
714     ///  above, they may submit UINT16_MAX for this variable for it to be ignored.
715     /// @param _highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex 
716     ///  that they are seeking, allowing users to place bounties on virgin cats or cats with a 
717     ///  sufficient cooldown to be useful in a fancy chase. If they are willing to accept cats of 
718     ///  any cooldown, they may submit  a cooldownIndex of 13 (which is the highest cooldown index 
719     ///  that the Cryptokitties Core contract allows) for this variable to be ignored.
720     /// @param _minNumBlocksBountyIsValidFor  The bounty creator specifies the minimum number of 
721     ///  blocks that this bounty is valid for. Every bounty is valid until at least a specified 
722     ///  block. Before that point, the owner cannot withdraw their funds (in order to guarantee a 
723     ///  time period for bounty hunters to attempt to breed for the specified cat). After the time 
724     ///  period has passed, the owner can withdraw their funds if they wish, but the bounty stays 
725     ///  valid until they do so. This allows for the possiblity of leaving a bounty open indefinitely 
726     ///  until it is filled if the bounty creator wishes to do so.
727     /// @param _quantity  A bounty creator specifies how many cats they would like to acquire with the 
728     ///  specified characteristics. This allows a bounty creator to create bulk bounties (e.g. 100 
729     ///  Gen 0's for 0.25 ETH each, etc.)
730     /// @notice This function is payable, and any eth sent to this function is interpreted as the 
731     ///  value that the user wishes to lock up for this bounty.
732     function createBountyAndLockFunds(uint256 _geneMask, uint256 _genes, uint256 _generation, uint256 _highestCooldownIndexAccepted, uint256 _minNumBlocksBountyIsValidFor, uint256 _quantity) external payable whenNotPaused {
733     	require(msg.value >= unsuccessfulBountyFeeInWei.mul(uint256(2)), 'the value of your bounty must be at least twice as large as the unsuccessful bounty fee');
734     	require(_highestCooldownIndexAccepted <= uint256(13), 'you cannot specify an invalid cooldown index');
735     	require(_generation <= uint256(~uint16(0)), 'you cannot specify an invalid generation');
736         require(_genes & ~_geneMask == uint256(0), 'your geneMask must fully cover any genes that you are seeking');
737         require(_quantity > 0, 'your bounty must be for at least one cat');
738         require(_quantity <= uint256(~uint32(0)), 'you cannot specify an invalid quantity');
739 
740         uint256 totalValueIncludingFeesPerCat = msg.value.div(_quantity);
741     	uint256 bountyPricePerCat = _computeBountyPrice(totalValueIncludingFeesPerCat, successfulBountyFeeInBasisPoints);
742         uint256 minBlockBountyValidUntil = uint256(block.number).add(_minNumBlocksBountyIsValidFor);
743 
744     	Bounty memory bounty = Bounty({
745             geneMask: _geneMask,
746             genes: _genes,
747             bountyPricePerCat: uint128(bountyPricePerCat),
748             totalValueIncludingFees: uint128(msg.value),
749             unsuccessfulBountyFeeInWei: uint128(unsuccessfulBountyFeeInWei),
750             minBlockBountyValidUntil: uint32(minBlockBountyValidUntil),
751             quantity: uint32(_quantity),
752             generation: uint16(_generation),
753             highestCooldownIndexAccepted: uint16(_highestCooldownIndexAccepted),
754             bidder: msg.sender
755         });
756 
757         bountyIdToBounty[bountyId] = bounty;
758         numCatsRemainingForBountyId[bountyId] = _quantity;
759         
760         emit CreateBountyAndLockFunds(
761             bountyId,
762 	        msg.sender,
763 			bountyPricePerCat,
764 			minBlockBountyValidUntil,
765             _quantity,
766 	        bounty.geneMask,
767 	        bounty.genes,
768 	        _generation,
769 	        _highestCooldownIndexAccepted,
770 	        unsuccessfulBountyFeeInWei
771         );
772 
773         bountyId = bountyId.add(uint256(1));
774     }
775 
776     /// @notice After calling approve() in the CryptoKitties Core contract, a bounty hunter can 
777     ///  submit the id of a kitty that they own and a bounty that they would like to fulfill. If
778     ///  the kitty fits the requirements of the bounty, and if the bounty hunter owns the kitty,
779     ///  then this function transfers the kitty to the original bounty creator and transfers the 
780     ///  locked eth to the bounty hunter.
781     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found in 
782     ///  the bountyIdToBounty mapping.
783     /// @param _kittyId  The id of the CryptoKitty that fulfills the bounty requirements.
784     /// @param _referrer  This address gets half of the successful bounty fees. This encourages
785     ///  third party developers to develop their own front-end UI's for the KittyBounties contract 
786     ///  in order to receive half of the rewards.
787     /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract before 
788     ///  calling fulfillBountyAndClaimFunds(). For better UX, fulfillBountyAndClaimFunds() can also
789     ///  be called by an account with the COO role, making it so that the user only has to send one 
790     ///  transaction (the approve() transaction), and the frontend creator can send the followup 
791     ///  fulfillBountyAndClaimFunds() transaction. There is no danger of this contract overreaching 
792     ///  its approval, since the CryptoKitties Core contract's approve() function only approves this 
793     ///  contract for a single Cryptokitty. Calling approve() allows this contract to transfer the 
794     ///  specified kitty in the fulfillOfferAndClaimFunds() function.
795     function fulfillBountyAndClaimFunds(uint256 _bountyId, uint256 _kittyId, address _referrer) external whenNotPaused nonReentrant {
796     	address payable ownerOfCatBeingUsedToFulfillBounty = address(uint160(kittyCore.ownerOf(_kittyId)));
797         require(numCatsRemainingForBountyId[_bountyId] > 0, 'this bounty has either already completed or has not yet begun');
798     	require(msg.sender == ownerOfCatBeingUsedToFulfillBounty || isCOO(msg.sender), 'you either do not own the cat or are not authorized to fulfill on behalf of others');
799     	require(kittyCore.kittyIndexToApproved(_kittyId) == address(this), 'you must approve() the bounties contract to give it permission to withdraw this cat before you can fulfill the bounty');
800 
801     	Bounty storage bounty = bountyIdToBounty[_bountyId];
802     	uint256 cooldownIndex;
803     	uint256 generation;
804     	uint256 genes;
805         ( , , cooldownIndex, , , , , , generation, genes) = kittyCore.getKitty(_kittyId);
806 
807         // By submitting ~uint16(0) as the target generation (which is uint16_MAX), a bounty creator can specify that they do not have a preference for generation.
808     	require((uint16(bounty.generation) == ~uint16(0) || uint16(generation) == uint16(bounty.generation)), 'your cat is not the correct generation to fulfill this bounty');
809     	// By submitting uint256(0) as the target genemask and submitting uint256(0) for the target genes, a bounty creator can specify that they do not have 
810     	// a preference for genes.
811     	require((genes & bounty.geneMask) == (bounty.genes & bounty.geneMask), 'your cat does not have the correct genes to fulfill this bounty');
812     	// By submitting 13 as the target highestCooldownIndexAccepted, a bounty creator can specify that they do not have a preference for cooldown (since
813     	// all Cryptokitties have a cooldown index less than or equal to 13).
814     	require(uint16(cooldownIndex) <= uint16(bounty.highestCooldownIndexAccepted), 'your cat does not have a low enough cooldown index to fulfill this bounty');
815 
816     	numCatsRemainingForBountyId[_bountyId] = numCatsRemainingForBountyId[_bountyId].sub(uint256(1));
817 
818     	kittyCore.transferFrom(ownerOfCatBeingUsedToFulfillBounty, bounty.bidder, _kittyId);
819 
820         uint256 totalValueIncludingFeesPerCat = uint256(bounty.totalValueIncludingFees).div(uint256(bounty.quantity));
821         uint256 successfulBountyFeeInWei = totalValueIncludingFeesPerCat.sub(uint256(bounty.bountyPricePerCat));
822         if(_referrer != address(0)){
823             uint256 halfOfFees = successfulBountyFeeInWei.div(uint256(2));
824             addressToFeeEarnings[_referrer] = addressToFeeEarnings[_referrer].add(halfOfFees);
825             addressToFeeEarnings[owner()] = addressToFeeEarnings[owner()].add(halfOfFees);
826         } else {
827             addressToFeeEarnings[owner()] = addressToFeeEarnings[owner()].add(successfulBountyFeeInWei);
828         }
829 
830         ownerOfCatBeingUsedToFulfillBounty.transfer(uint256(bounty.bountyPricePerCat));
831 
832     	emit FulfillBountyAndClaimFunds(
833             _bountyId,
834             _kittyId,
835 	        ownerOfCatBeingUsedToFulfillBounty,
836 			uint256(bounty.bountyPricePerCat),
837 	        bounty.geneMask,
838 	        bounty.genes,
839 	        uint256(bounty.generation),
840 	        uint256(bounty.highestCooldownIndexAccepted),
841 	        successfulBountyFeeInWei
842         );
843     }
844 
845     /// @notice Allows a bounty creator to withdraw the funds locked within a bounty, but only 
846     ///  once a specified time period (measured in blocks) has passed. Prohibiting the bounty 
847     ///  creator from withdrawing their funds until this point guarantees a time period for 
848     ///  bounty hunters to attempt to breed for a cat with the specified cattributes and 
849     ///  generation. If a bounty creator withdraws their funds, then the bounty is invalidated 
850     ///  and bounty hunters can no longer try to fulfill it. A flat fee is taken from the bounty 
851     ///  creator's original deposit, specified by unsuccessfulBountyFeeInWei.
852     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found in 
853     ///  the bountyIdToBounty mapping.
854     /// @param _referrer  This address gets half of the unsuccessful bounty fees. This encourages
855     ///  third party developers to develop their own frontends for the KittyBounties contract and
856     ///  get half of the rewards.
857     function withdrawUnsuccessfulBounty(uint256 _bountyId, address _referrer) external whenNotPaused nonReentrant {
858     	require(numCatsRemainingForBountyId[_bountyId] > 0, 'this bounty has either already completed or has not yet begun');
859     	Bounty storage bounty = bountyIdToBounty[_bountyId];
860     	require(msg.sender == bounty.bidder, 'you cannot withdraw the funds for someone elses bounty');
861     	require(block.number >= uint256(bounty.minBlockBountyValidUntil), 'this bounty is not withdrawable until the minimum number of blocks that were originally specified have passed');
862 
863         uint256 totalValueIncludingFeesPerCat = uint256(bounty.totalValueIncludingFees).div(uint256(bounty.quantity));
864         uint256 totalValueRemainingForBountyId = totalValueIncludingFeesPerCat.mul(numCatsRemainingForBountyId[_bountyId]);
865 
866         numCatsRemainingForBountyId[_bountyId] = 0;
867 
868         uint256 amountToReturnToBountyCreator;
869         uint256 amountToTakeAsFees;
870 
871         if(totalValueRemainingForBountyId < bounty.unsuccessfulBountyFeeInWei){
872             amountToTakeAsFees = totalValueRemainingForBountyId;
873             amountToReturnToBountyCreator = 0;
874         } else {
875             amountToTakeAsFees = bounty.unsuccessfulBountyFeeInWei;
876             amountToReturnToBountyCreator = totalValueRemainingForBountyId.sub(uint256(amountToTakeAsFees));
877         }
878 
879         if(_referrer != address(0)){
880             uint256 halfOfFees = uint256(amountToTakeAsFees).div(uint256(2));
881             addressToFeeEarnings[_referrer] = addressToFeeEarnings[_referrer].add(uint256(halfOfFees));
882             addressToFeeEarnings[owner()] = addressToFeeEarnings[owner()].add(uint256(halfOfFees));
883         } else {
884             addressToFeeEarnings[owner()] = addressToFeeEarnings[owner()].add(uint256(amountToTakeAsFees));
885         }
886 
887         if(amountToReturnToBountyCreator > 0){
888             address payable bountyCreator = address(uint160(bounty.bidder));
889             bountyCreator.transfer(amountToReturnToBountyCreator);
890         }
891 
892     	emit WithdrawBounty(
893             _bountyId,
894             bounty.bidder,
895             amountToReturnToBountyCreator
896         );
897     }
898 
899     /// @notice Allows a bounty creator to withdraw the funds locked within a bounty, even if 
900     ///  the time period that the bounty was guaranteed to be locked for has not passed. This 
901     ///  function can only be called when the contract is frozen, and would be used as an 
902     ///  emergency measure to allow users to withdraw their funds immediately. No fees are 
903     ///  taken when this function is called.
904     /// @notice Only callable when the contract is frozen.
905     /// @notice It is safe for the owner of the contract to call this function because the
906     ///  funds are still returned to the original bidder, and this function can only be called
907     ///  when the contract is frozen.
908     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found 
909     ///  in the bountyIdToBounty mapping.
910     function withdrawBountyWithNoFeesTakenIfContractIsFrozen(uint256 _bountyId) external whenPaused nonReentrant {
911     	require(numCatsRemainingForBountyId[_bountyId] > 0, 'this bounty has either already completed or has not yet begun');
912     	Bounty storage bounty = bountyIdToBounty[_bountyId];
913     	require(msg.sender == bounty.bidder || isOwner(), 'you are not the bounty creator or the contract owner');
914 
915         uint256 totalValueIncludingFeesPerCat = uint256(bounty.totalValueIncludingFees).div(uint256(bounty.quantity));
916         uint256 totalValueRemainingForBountyId = totalValueIncludingFeesPerCat.mul(numCatsRemainingForBountyId[_bountyId]);
917 
918         numCatsRemainingForBountyId[_bountyId] = 0;
919     	
920         address payable bountyCreator = address(uint160(bounty.bidder));
921         bountyCreator.transfer(totalValueRemainingForBountyId);
922 
923     	emit WithdrawBounty(
924             _bountyId,
925             bounty.bidder,
926             totalValueRemainingForBountyId
927         );
928     }
929 
930     /// @notice Computes the bounty price given a total value sent when creating a bounty, 
931     ///  and the current successfulBountyFee in percentage basis points. 
932     /// @dev 10000 is not a magic number, but is the maximum number of basis points that 
933     ///  can exist (with basis points being hundredths of a percent).
934     /// @param _totalValueIncludingFees The amount of ether (in wei) that was sent to 
935     ///  create a bounty
936     /// @param _successfulBountyFeeInBasisPoints The percentage (in basis points) of that 
937     ///  total amount that will be taken as a fee if the bounty is successfully completed.
938     /// @return The amount of ether (in wei) that will be rewarded if the bounty is 
939     ///  successfully fulfilled
940     function _computeBountyPrice(uint256 _totalValueIncludingFees, uint256 _successfulBountyFeeInBasisPoints) internal pure returns (uint256) {
941     	return (_totalValueIncludingFees.mul(uint256(10000).sub(_successfulBountyFeeInBasisPoints))).div(uint256(10000));
942     }
943 
944     /// @dev By calling 'revert' in the fallback function, we prevent anyone from 
945     ///  accidentally sending funds directly to this contract.
946     function() external payable {
947         revert();
948     }
949 }