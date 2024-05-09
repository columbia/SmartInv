1 pragma solidity ^0.5.0;
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
106 contract PauserRole {
107     using Roles for Roles.Role;
108 
109     event PauserAdded(address indexed account);
110     event PauserRemoved(address indexed account);
111 
112     Roles.Role private _pausers;
113 
114     constructor () internal {
115         _addPauser(msg.sender);
116     }
117 
118     modifier onlyPauser() {
119         require(isPauser(msg.sender));
120         _;
121     }
122 
123     function isPauser(address account) public view returns (bool) {
124         return _pausers.has(account);
125     }
126 
127     function addPauser(address account) public onlyPauser {
128         _addPauser(account);
129     }
130 
131     function renouncePauser() public {
132         _removePauser(msg.sender);
133     }
134 
135     function _addPauser(address account) internal {
136         _pausers.add(account);
137         emit PauserAdded(account);
138     }
139 
140     function _removePauser(address account) internal {
141         _pausers.remove(account);
142         emit PauserRemoved(account);
143     }
144 }
145 
146 /**
147  * @title Pausable
148  * @dev Base contract which allows children to implement an emergency stop mechanism.
149  */
150 contract Pausable is PauserRole {
151     event Paused(address account);
152     event Unpaused(address account);
153 
154     bool private _paused;
155 
156     constructor () internal {
157         _paused = false;
158     }
159 
160     /**
161      * @return true if the contract is paused, false otherwise.
162      */
163     function paused() public view returns (bool) {
164         return _paused;
165     }
166 
167     /**
168      * @dev Modifier to make a function callable only when the contract is not paused.
169      */
170     modifier whenNotPaused() {
171         require(!_paused);
172         _;
173     }
174 
175     /**
176      * @dev Modifier to make a function callable only when the contract is paused.
177      */
178     modifier whenPaused() {
179         require(_paused);
180         _;
181     }
182 
183     /**
184      * @dev called by the owner to pause, triggers stopped state
185      */
186     function pause() public onlyPauser whenNotPaused {
187         _paused = true;
188         emit Paused(msg.sender);
189     }
190 
191     /**
192      * @dev called by the owner to unpause, returns to normal state
193      */
194     function unpause() public onlyPauser whenPaused {
195         _paused = false;
196         emit Unpaused(msg.sender);
197     }
198 }
199 
200 /**
201  * @title Ownable
202  * @dev The Ownable contract has an owner address, and provides basic authorization control
203  * functions, this simplifies the implementation of "user permissions".
204  */
205 contract Ownable {
206     address private _owner;
207 
208     event OwnershipTransferred(address previousOwner, address newOwner);
209 
210     /**
211      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
212      * account.
213      */
214     constructor () internal {
215         _owner = msg.sender;
216         emit OwnershipTransferred(address(0), _owner);
217     }
218 
219     /**
220      * @return the address of the owner.
221      */
222     function owner() public view returns (address) {
223         return _owner;
224     }
225 
226     /**
227      * @dev Throws if called by any account other than the owner.
228      */
229     modifier onlyOwner() {
230         require(isOwner());
231         _;
232     }
233 
234     /**
235      * @return true if `msg.sender` is the owner of the contract.
236      */
237     function isOwner() public view returns (bool) {
238         return msg.sender == _owner;
239     }
240 
241     /**
242      * @dev Allows the current owner to relinquish control of the contract.
243      * @notice Renouncing to ownership will leave the contract without an owner.
244      * It will not be possible to call the functions with the `onlyOwner`
245      * modifier anymore.
246      */
247     function renounceOwnership() public onlyOwner {
248         emit OwnershipTransferred(_owner, address(0));
249         _owner = address(0);
250     }
251 
252     /**
253      * @dev Allows the current owner to transfer control of the contract to a newOwner.
254      * @param newOwner The address to transfer ownership to.
255      */
256     function transferOwnership(address newOwner) public onlyOwner {
257         _transferOwnership(newOwner);
258     }
259 
260     /**
261      * @dev Transfers control of the contract to a newOwner.
262      * @param newOwner The address to transfer ownership to.
263      */
264     function _transferOwnership(address newOwner) internal {
265         require(newOwner != address(0));
266         emit OwnershipTransferred(_owner, newOwner);
267         _owner = newOwner;
268     }
269 }
270 
271 /// @title Admin contract for KittyBounties. Holds owner-only functions to adjust contract-wide fees, change owners, etc.
272 /// @dev The owner is not capable of changing the address of the CryptoKitties Core contract once the contract has been deployed.
273 ///  This prevents an attack vector where the owner could change the kittyCore contract once users had already deposited funds.
274 contract KittyBountiesAdmin is Ownable, Pausable {
275 
276     /* ****** */
277     /* EVENTS */
278     /* ****** */
279 
280     /// @dev This event is fired whenever the owner changes the successfulBountyFeeInBasisPoints.
281     /// @param newSuccessfulBountyFeeInBasisPoints  The SuccessfulFee is expressed in basis points (hundredths of a percantage), 
282     ///  and is charged when a bounty is successfully completed.
283     event SuccessfulBountyFeeInBasisPointsUpdated(uint256 newSuccessfulBountyFeeInBasisPoints);
284 
285     /// @dev This event is fired whenever the owner changes the unsuccessfulBountyFeeInWei. 
286     /// @param newUnsuccessfulBountyFeeInWei  The UnsuccessfulBountyFee is paid by the original bounty creator if the bounty expires 
287     ///  without being completed. When a bounty is created, the bounty creator specifies how long the bounty is valid for. If the 
288     ///  bounty is not fulfilled by this expiration date, the original creator can then freely withdraw their funds, minus the 
289     ///  UnsuccessfulBountyFee, although the bounty is still fulfillable until the bounty creator withdraws their funds.
290     event UnsuccessfulBountyFeeInWeiUpdated(uint256 newUnsuccessfulBountyFeeInWei);
291 
292     /// @dev This event is fired whenever the owner changes the maximumLockupDurationInBlocks. 
293     /// @param newMaximumLockoutDurationInBlocks  To prevent users from accidentally locking up ether for an eternity, the lockout 
294     ///  period of all bounties is capped using this variable, which is inially set to 4 weeks. This is measured in blocks, which 
295     ///  are created roughly once every 15 seconds. If the community expresses that they would like a longer maximumLockoutDuration,
296     ///  the creator will adjust this variable.
297     event MaximumLockoutDurationInBlocksUpdated(uint256 newMaximumLockoutDurationInBlocks);
298 
299     /* ******* */
300     /* STORAGE */
301     /* ******* */
302 
303     /// @dev The total amount that the contract creator has earned from fees since they last withdrew. Storing the owner's earnings
304     ///  saves gas rather than performing an additional transfer() call on every successful bounty.
305     uint256 public totalOwnerEarningsInWei = 0;
306 
307     /// @dev If a bounty is successfully fulfilled, this fee applies before the remaining funds are sent to the successful bounty
308     ///  hunter. This fee is measured in basis points (hundredths of a percent), and is taken out of the total value that the bounty
309     ///  creator locked up in the contract when they created the bounty.
310     uint256 public successfulBountyFeeInBasisPoints = 375;
311 
312     /// @dev If a bounty is not fulfilled after the lockup period has completed, a bounty creator can withdraw their funds and
313     ///  invalidate the bounty, but they are charged this flat fee to do so. This fee is measured in wei.
314     uint256 public unsuccessfulBountyFeeInWei = 0.008 ether;
315 
316     /// @dev To prevent users from accidentally locking up ether for an eternity, the lockout period of all bounties is capped
317     ///  using this variable, which is inially set to 4 weeks. This is measured in blocks, which are created roughly once every 15 seconds. 
318     ///  If the community expresses that they would like a longer maximumLockoutDuration, the creator will adjust this variable.
319     /// @notice This is initalized to 4 weeks in blocks (161280 = 4 (weeks) * 7 (days) * 24 (hours) * 60 (minutes) * 4 (blocks per minute))
320     ///  Note that this rests on the assumption that each block takes 15 seconds to propagate. This maximum lockout can be changed by the owner
321     ///  if this assumption is invalidated.
322     uint256 public maximumLockoutDurationInBlocks = 161280; 
323 
324     /* ********* */
325     /* CONSTANTS */
326     /* ********* */
327 
328     /// @dev The owner is not capable of changing the address of the CryptoKitties Core contract once the contract has been deployed.
329     ///  This prevents an attack vector where the owner could change the kittyCore contract once users had already deposited funds.
330     ///  Since the CryptoKitties Core contract has the ability to migrate to a new contract, if Dapper Labs Inc. ever chooses to migrate
331     ///  contract, this contract will have to be frozen, and users will be allowed to withdraw their funds without paying any fees.
332     address public kittyCoreAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
333     KittyCore kittyCore;
334 
335     /* ********* */
336     /* FUNCTIONS */
337     /* ********* */
338 
339     /// @dev The owner is not capable of changing the address of the CryptoKitties Core contract once the contract has been deployed.
340     ///  This prevents an attack vector where the owner could change the kittyCore contract once users had already deposited funds.
341     constructor() internal {
342         kittyCore = KittyCore(kittyCoreAddress);
343     }
344 
345     /// @notice Sets the successfulBountyFeeInBasisPoints value (in basis points). Any bounties that are successfully fulfilled 
346     ///  will have this fee deducted from amount sent to the bounty hunter.
347     /// @notice Only callable by the owner.
348     /// @dev As this configuration is a basis point, the value to set must be less than or equal to 10000.
349     /// @param _newSuccessfulBountyFeeInBasisPoints  The successfulBountyFeeInBasisPoints value to set (measured in basis points).
350     function setSuccessfulBountyFeeInBasisPoints(uint256 _newSuccessfulBountyFeeInBasisPoints) external onlyOwner {
351         require(_newSuccessfulBountyFeeInBasisPoints <= 10000, 'new successful bounty fee must be in basis points (hundredths of a percent), not wei');
352         successfulBountyFeeInBasisPoints = _newSuccessfulBountyFeeInBasisPoints;
353         emit SuccessfulBountyFeeInBasisPointsUpdated(_newSuccessfulBountyFeeInBasisPoints);
354     }
355 
356     /// @notice Sets the unsuccessfulBountyFeeInWei value. If a bounty is still unfulfilled once the minimum number of blocks has passed,
357     ///  an owner can withdraw the locked ETH. If they do so, this fee is deducted from the amount that they withdraw.
358     /// @notice Only callable by the owner.
359     /// @param _newUnsuccessfulBountyFeeInWei  The unsuccessfulBountyFeeInWei value to set (measured in wei).
360     function setUnsuccessfulBountyFeeInWei(uint256 _newUnsuccessfulBountyFeeInWei) external onlyOwner {
361         unsuccessfulBountyFeeInWei = _newUnsuccessfulBountyFeeInWei;
362         emit UnsuccessfulBountyFeeInWeiUpdated(_newUnsuccessfulBountyFeeInWei);
363     }
364 
365     /// @notice Sets the maximumLockoutDurationInBlocks value. To prevent users from accidentally locking up ether for an eternity, the 
366     ///  lockout period of all bounties is capped using this variable, which is inially set to 4 weeks. This is measured in blocks, which 
367     ///  are created roughly once every 15 seconds. If the assumption of 1 block every 15 seconds is ever invalidated, the owner is able
368     ///  to change the maximumLockoutDurationInBlocks using this function.
369     /// @notice Only callable by the owner.
370     /// @param _newMaximumLockoutDurationInBlocks  The maximumLockoutDurationInBlocks value to set (measured in blocks).
371     function setMaximumLockoutDurationInBlocks(uint256 _newMaximumLockoutDurationInBlocks) external onlyOwner {
372         maximumLockoutDurationInBlocks = _newMaximumLockoutDurationInBlocks;
373         emit MaximumLockoutDurationInBlocksUpdated(_newMaximumLockoutDurationInBlocks);
374     }
375 
376     /// @notice Withdraws the fees that have been earned by the contract owner.
377     /// @notice Only callable by the owner.
378     function withdrawOwnerEarnings() external onlyOwner {
379         uint256 balance = totalOwnerEarningsInWei;
380         totalOwnerEarningsInWei = 0;
381         msg.sender.transfer(balance);
382     }
383 
384     /// @dev By calling 'revert' in the fallback function, we prevent anyone from accidentally sending funds directly to this contract.
385     function() external payable {
386         revert();
387     }
388 }
389 
390 /// @title Interface for interacting with the CryptoKitties Core contract created by Dapper Labs Inc.
391 contract KittyCore {
392     function getKitty(uint _id) public returns (
393         bool isGestating,
394         bool isReady,
395         uint256 cooldownIndex,
396         uint256 nextActionAt,
397         uint256 siringWithId,
398         uint256 birthTime,
399         uint256 matronId,
400         uint256 sireId,
401         uint256 generation,
402         uint256 genes
403     );
404     function ownerOf(uint256 _tokenId) public view returns (address owner);
405     function transferFrom(address _from, address _to, uint256 _tokenId) external;
406     mapping (uint256 => address) public kittyIndexToApproved;
407 }
408 
409 /// @title Main contract for KittyBounties. This contract manages funds from creation to fulfillment for bounties.
410 /// @notice Once created, a bounty locks up ether. Optionally, the bounty creator may specify a number of blocks to "lock" their bounty, thus preventing
411 ///  them from being able to cancel their bounty or withdraw their ether until that number of blocks have passed. This guarantees a time period for 
412 ///  bounty hunters to attempt to breed for a cat with the specified cattributes, generation, and/or cooldown. This option is included since perhaps many 
413 ///  breeders will not chase a bounty without this guarantee. After that point, the bounty creator can withdraw their funds if they wish and invalidate 
414 ///  the bounty, or they can continue to leave the bounty active.
415 /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract before calling fulfillBountyAndClaimFunds(). There
416 ///  is no danger of this contract overreaching its approval, since the CryptoKitties Core contract's approve() function only approves this
417 ///  contract for a single Cryptokitty. Calling approve() allows this contract to transfer the specified kitty in the fulfillOfferAndClaimFunds() 
418 ///  function.
419 contract KittyBounties is KittyBountiesAdmin {
420 
421     // OpenZeppelin's SafeMath library is used for all arithmetic operations to avoid overflows/underflows.
422     using SafeMath for uint256;
423 
424 	/* ********** */
425     /* DATA TYPES */
426     /* ********** */
427 
428     /// @dev The main Bounty struct. The struct fits in four 256-bits words due to Solidity's rules for struct packing.
429 	struct Bounty {
430 		// A bounty creator specifies which portion of the CryptoKitties genome is relevant to this bounty.
431 		// This is a bitwise mask, that zeroes out all other portions of the Cryptokitties genome besides those
432 		// that the bounty creator is interested in. If a bounty creator does not wish to specify genes (perhaps 
433         // they want to specify generation, but don't have a preference for genes), they can submit a geneMask of 
434         // uint256(0) and genes of uint256(0).
435 		uint256 geneMask;
436         // A bounty creator specifies which cattributes they are seeking. If a user possesses a cat that has
437         // both the specified cattributes, the specified generation, and the specified cooldown, then they can 
438         // trade that cat for the bounty. If a bounty creator does not wish to specify genes (perhaps they want to specify
439         // generation, but don't have a preference for genes), they can submit a geneMask of uint256(0) and genes of uint256(0).
440         uint256 genes;
441 		// The price (in wei) that a user will receive if they successfully fulfill this bounty.
442 		uint128 bountyPrice;
443 		// The total value (in wei) that the bounty creator originally sent to the contract to create this bounty. 
444         // This includes the potential fees to be paid to the contract creator.
445 		uint128 totalValueIncludingFees;
446 		// The fee that is paid if the bounty is not fulfilled and the owner withdraws their funds. This is 
447         // stored in the Bounty struct to ensure that users are charged the fee that existed at the time of a 
448         // bounty's creation, in case the contract owner changes the fees between when the bounty is created and 
449         // when the bounty creator withdraws their funds.
450 		uint128 unsuccessfulBountyFeeInWei;
451 		// Optionally, a bounty creator can set a minimum number of blocks that must pass before they can cancel 
452         // a bounty and withdraw their funds (in order to guarantee a time period for bounty hunters to attempt to 
453         // breed for the specified cat). After the time period has passed, the owner can withdraw their funds if 
454 		// they wish, but the bounty stays valid until they do so. This allows for the possiblity of leaving 
455 		// a bounty open indefinitely until it is filled if the bounty creator wishes to do so.
456 		uint64 minBlockBountyValidUntil;
457         // A bounty creator can specify the exact generation that they are seeking. If they are willing to 
458         // accept cats of any generation that have the cattributes specified above, they may submit UINT16_MAX for 
459         // this variable for it to be ignored.
460         uint16 generation;
461 		// A bounty creator can specify the highest cooldownIndex that they are seeking, allowing users to place bounties
462 		// on virgin cats or cats with a sufficient cooldown to be useful in a fancy chase. If they are willing to 
463         // accept cats of any cooldown, they may submit a cooldownIndex of 13 (which is the highest cooldown index that
464        	// the Cryptokitties Core contract allows) for this variable to be ignored.
465         uint16 highestCooldownIndexAccepted;
466         // The creator of the bounty. This address receives the specified cat if the bounty is fulfilled, or receives 
467         // their money back (minus unsuccessfulBountyFee) if the bounty is not fulfilled.
468 		address bidder;
469     }
470 
471     /* ****** */
472     /* EVENTS */
473     /* ****** */
474 
475     /// @dev This event is fired whenever a user creates a new bounty for a cat with a particular set of cattributes, generation, 
476     ///  and/or cooldown that they are seeking.
477     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the bountyIdToBounty mapping.
478     /// @param bidder  The creator of the bounty. This address receives the specified cat if the bounty is fulfilled, or receives 
479     ///  their money back (minus unsuccessfulBountyFee) if the bounty is not fulfilled.
480     /// @param bountyPrice  The price (in wei) that a user will receive if they successfully fulfill this bounty.
481     /// @param minBlockBountyValidUntil  Every bounty is valid until at least a specified block. Before that point, the owner cannot
482 	///  withdraw their funds (in order to guarantee a time period for bounty hunters to attempt to breed 
483 	///  for the specified cat). After the time period has passed, the owner can withdraw their funds if 
484 	///  they wish, but the bounty stays valid until they do so. This allows for the possiblity of leaving 
485 	///  a bounty open indefinitely until it is filled if the bounty creator wishes to do so.
486     /// @param geneMask  A bounty creator specifies which portion of the CryptoKitties genome is relevant to this bounty.
487 	///  This is a bitwise mask, that zeroes out all other portions of the Cryptokitties genome besides those
488 	///  that the bounty creator is interested in. 
489     /// @param genes  A bounty creator specifies which cattributes they are seeking. If a user possesses a cat that has
490     ///  both the specified cattributes and the specified generation, then they can trade that cat for the bounty.
491     /// @param generation  A bounty creator can specify the exact generation that they are seeking. If they are willing to 
492     ///  accept cats of any generation that have the cattributes specified above, they may submit UINT16_MAX for this variable for it to 
493     ///  be ignored.
494     /// @param highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex that they are seeking, allowing users to place bounties
495 	///  on virgin cats or cats with a sufficient cooldown to be useful in a fancy chase. If they are willing to 
496     ///  accept cats of any cooldown, they may submit a cooldownIndex of 13 (which is the highest cooldown index that
497     ///  the Cryptokitties Core contract allows) for this variable to be ignored.
498     /// @param unsuccessfulBountyFeeInWei  The fee that is paid if the bounty is not fulfilled and the owner withdraws their funds. This is 
499     ///  stored in the Bounty struct to ensure that users are charged the fee that existed at the time of a bounty's creation, in case the 
500     ///  contract owner changes the fees between when the bounty is created and when the bounty creator withdraws their funds.
501     event CreateBountyAndLockFunds(
502     	uint256 bountyId,
503         address bidder,
504 		uint256 bountyPrice,
505 		uint256 minBlockBountyValidUntil,
506         uint256 geneMask,
507         uint256 genes,
508         uint256 generation,
509         uint256 highestCooldownIndexAccepted,
510         uint256 unsuccessfulBountyFeeInWei
511     );
512 
513     /// @dev This event is fired if a bounty hunter trades in a cat with the specified cattributes/generation/cooldown and claims the funds
514     ///  locked within the bounty.
515     /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract before calling fulfillBountyAndClaimFunds(). There
516     ///  is no danger of this contract overreaching its approval, since the CryptoKitties Core contract's approve() function only approves this
517     ///  contract for a single Cryptokitty. Calling approve() allows this contract to transfer the specified kitty in the fulfillOfferAndClaimFunds()
518     ///  function.
519     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the bountyIdToBounty mapping.
520     /// @param kittyId  The id of the CryptoKitty that fulfills the bounty requirements. 
521     /// @param bidder  The creator of the bounty. This address receives the specified cat if the bounty is fulfilled, or receives 
522     ///  their money back (minus unsuccessfulBountyFee) if the bounty is not fulfilled.
523     /// @param bountyPrice  The price (in wei) that a user will receive if they successfully fulfill this bounty.
524     /// @param geneMask  A bounty creator specifies which portion of the CryptoKitties genome is relevant to this bounty.
525 	///  This is a bitwise mask, that zeroes out all other portions of the Cryptokitties genome besides those
526 	///  that the bounty creator is interested in. 
527     /// @param genes  A bounty creator specifies which cattributes they are seeking. If a user possesses a cat that has
528     ///  both the specified cattributes and the specified generation, then they can trade that cat for the bounty.
529     /// @param generation  A bounty creator can specify the exact generation that they are seeking. If they are willing to 
530     ///  accept cats of any generation that have the cattributes specified above, they may submit UINT16_MAX for 
531     ///  this variable for it to be ignored.
532     /// @param highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex that they are seeking, allowing users to place bounties
533 	///  on virgin cats or cats with a sufficient cooldown to be useful in a fancy chase. If they are willing to 
534     ///  accept cats of any cooldown, they may submit a cooldownIndex of 13 (which is the highest cooldown index that
535     ///  the Cryptokitties Core contract allows) for this variable to be ignored.
536     /// @param successfulBountyFeeInWei  The fee that is paid when the bounty is fulfilled. This fee is calculated from totalValueIncludingFees 
537     ///  and bountyPrice, which are both stored in the Bounty struct to ensure that users are charged the fee that existed at the time of a bounty's 
538     ///  creation, in case the owner changes the fees between when the bounty is created and when the bounty is fulfilled.
539     event FulfillBountyAndClaimFunds(
540         uint256 bountyId,
541         uint256 kittyId,
542         address bidder,
543 		uint256 bountyPrice,
544         uint256 geneMask,
545         uint256 genes,
546         uint256 generation,
547         uint256 highestCooldownIndexAccepted,
548         uint256 successfulBountyFeeInWei
549     );
550 
551     /// @dev This event is fired when a bounty creator wishes to invalidate a bounty. The bounty creator withdraws the funds and cancels the bounty,
552     ///  preventing anybody from fulfilling that particular bounty.
553     /// @notice If a bounty creator specified a lock time, a bounty creator cannot withdraw funds or invalidate a bounty until at least the originally 
554     ///  specified number of blocks have passed. This guarantees a time period for bounty hunters to attempt to breed for a cat with the specified 
555     ///  cattributes/generation/cooldown. However, if the contract is frozen, a bounty creator may withdraw their funds immediately with no fees taken by 
556     ///  the contract owner, since the bounty creator would only freeze the contract if a vulnerability was found.
557     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the bountyIdToBounty mapping.
558     /// @param bidder  The creator of the bounty. This address receives the specified cat if the bounty is fulfilled, or receives 
559     ///  their money back (minus unsuccessfulBountyFee) if the bounty is not fulfilled.
560     /// @param withdrawnAmount  The amount returned to the bounty creator (in wei). If the contract is not frozen, then this is the total value
561     ///  originally sent to the contract minus unsuccessfulBountyFeeInWei. However, if the contract is frozen, no fees are taken, and the entire
562     ///  amount is returned to the bounty creator.
563     event WithdrawBounty(
564         uint256 bountyId,
565         address bidder,
566 		uint256 withdrawnAmount
567     );
568 
569     /* ******* */
570     /* STORAGE */
571     /* ******* */
572 
573     /// @dev A mapping that tracks bounties that have been created, regardless of whether they have been cancelled or claimed thereafter. See the activeBounties
574     ///  mapping to determine whether a particular bounty is still active.
575     mapping (uint256 => Bounty) public bountyIdToBounty;
576 
577     /// @dev An index that increments with each Bounty created. Allows the ability to jump directly to a specified bounty.
578     uint256 public bountyId = 0;
579 
580     /// @dev A flag indicating that the contract still contains funds for this particular bounty. This flag is set to false if the bounty is fulfilled,
581     ///  if the funds are withdrawn by the original owner, or if this bounty has not yet been created. In all of these cases, the contract no longer 
582     ///  holds funds for this specific bounty. Solidity initializes variables to zero, so there is no concern that the mapping will have been erroneously 
583     ///  initialized with any values set to true.
584     mapping (uint256 => bool) public activeBounties;
585 
586     /* ********* */
587     /* FUNCTIONS */
588     /* ********* */
589 
590     /// @notice Allows a user to create a new bounty for a cat with a particular set of cattributes, generation, and/or cooldown. This optionally involves 
591     ///  locking up a specified amount of eth for at least a specified number of blocks, in order to guarantee a time period for bounty hunters to attempt 
592     ///  to breed for a cat with the specified cattributes and generation. 
593 	/// @param _geneMask  A bounty creator specifies which portion of the CryptoKitties genome is relevant to this bounty.
594 	///  This is a bitwise mask, that zeroes out all other portions of the Cryptokitties genome besides those that the bounty 
595     ///  creator is interested in. If a bounty creator does not wish to specify genes (perhaps they want to specify
596     ///  generation, but don't have a preference for genes), they can submit a geneMask of uint256(0).
597     /// @param _genes  A bounty creator specifies which cattributes they are seeking. If a user possesses a cat that has
598     ///  the specified cattributes, the specified generation, and the specified cooldown, then they can trade that cat for the bounty.
599     /// @param _generation  A bounty creator can specify the exact generation that they are seeking. If they are willing to 
600     ///  accept cats of any generation that have the cattributes specified above, they may submit UINT16_MAX for 
601     ///  this variable for it to be ignored.
602     /// @param _highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex that they are seeking, allowing users to place bounties
603     ///  on virgin cats or cats with a sufficient cooldown to be useful in a fancy chase. If they are willing to accept cats of any cooldown, they may submit 
604     ///  a cooldownIndex of 13 (which is the highest cooldown index that the Cryptokitties Core contract allows) for this variable to be ignored.
605     /// @param _minNumBlocksBountyIsValidFor  The bounty creator specifies the minimum number of blocks that this bounty is valid for. Every bounty is 
606     ///  valid until at least a specified block. Before that point, the owner cannot withdraw their funds (in order to guarantee a time period for bounty 
607     ///  hunters to attempt to breed for the specified cat). After the time period has passed, the owner can withdraw their funds if they wish, but the 
608 	///  bounty stays valid until they do so. This allows for the possiblity of leaving a bounty open indefinitely until it is filled if the bounty creator 
609 	///  wishes to do so.
610     /// @notice This function is payable, and any eth sent to this function is interpreted as the value that the user wishes to lock up for this bounty.
611     function createBountyAndLockFunds(uint256 _geneMask, uint256 _genes, uint256 _generation, uint256 _highestCooldownIndexAccepted, uint256 _minNumBlocksBountyIsValidFor) external payable whenNotPaused {
612     	require(msg.value >= unsuccessfulBountyFeeInWei.mul(uint256(2)), 'the value of your bounty must be at least twice as large as the unsuccessful bounty fee');
613     	require(_minNumBlocksBountyIsValidFor <= maximumLockoutDurationInBlocks, 'you cannot lock eth into a bounty for longer than the maximumLockoutDuration');
614     	require(_highestCooldownIndexAccepted <= uint256(13), 'you cannot specify an invalid cooldown index');
615     	require(_generation <= uint256(~uint16(0)), 'you cannot specify an invalid generation');
616 
617     	uint256 bountyPrice = _computeBountyPrice(msg.value, successfulBountyFeeInBasisPoints);
618     	uint256 minBlockBountyValidUntil = uint256(block.number).add(_minNumBlocksBountyIsValidFor);
619 
620     	Bounty memory bounty = Bounty({
621             geneMask: _geneMask,
622             genes: _genes,
623             bountyPrice: uint128(bountyPrice),
624             totalValueIncludingFees: uint128(msg.value),
625             unsuccessfulBountyFeeInWei: uint128(unsuccessfulBountyFeeInWei),
626             minBlockBountyValidUntil: uint64(minBlockBountyValidUntil),
627             generation: uint16(_generation),
628             highestCooldownIndexAccepted: uint16(_highestCooldownIndexAccepted),
629             bidder: msg.sender
630         });
631 
632         bountyIdToBounty[bountyId] = bounty;
633         activeBounties[bountyId] = true;
634         
635         emit CreateBountyAndLockFunds(
636             bountyId,
637 	        msg.sender,
638 			bountyPrice,
639 			minBlockBountyValidUntil,
640 	        bounty.geneMask,
641 	        bounty.genes,
642 	        _generation,
643 	        _highestCooldownIndexAccepted,
644 	        unsuccessfulBountyFeeInWei
645         );
646 
647         bountyId = bountyId.add(uint256(1));
648     }
649 
650     /// @notice After calling approve() in the CryptoKitties Core contract, a bounty hunter can submit the id of a kitty that they own and a bounty
651     ///  that they would like to fulfill. If the kitty fits the requirements of the bounty, and if the bounty hunter owns the kitty, then this function
652     ///  transfers the kitty to the original bounty creator and transfers the locked eth to the bounty hunter.
653     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found in the bountyIdToBounty mapping.
654     /// @param _kittyId  The id of the CryptoKitty that fulfills the bounty requirements.
655     /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract before calling fulfillBountyAndClaimFunds(). There
656 	///  is no danger of this contract overreaching its approval, since the CryptoKitties Core contract's approve() function only approves this
657 	///  contract for a single Cryptokitty. Calling approve() allows this contract to transfer the specified kitty in the fulfillOfferAndClaimFunds() function.
658     function fulfillBountyAndClaimFunds(uint256 _bountyId, uint256 _kittyId) external whenNotPaused {
659     	require(activeBounties[_bountyId], 'this bounty has either already completed or has not yet begun');
660     	require(msg.sender == kittyCore.ownerOf(_kittyId), 'you do not own the cat that you are trying to use to fulfill this bounty');
661     	require(kittyCore.kittyIndexToApproved(_kittyId) == address(this), 'you must approve the bounties contract for this cat before you can fulfill a bounty');
662 
663     	Bounty storage bounty = bountyIdToBounty[_bountyId];
664     	uint256 cooldownIndex;
665     	uint256 generation;
666     	uint256 genes;
667         ( , , cooldownIndex, , , , , , generation, genes) = kittyCore.getKitty(_kittyId);
668 
669         // By submitting ~uint16(0) as the target generation (which is uint16_MAX), a bounty creator can specify that they do not have a preference for generation.
670     	require((uint16(bounty.generation) == ~uint16(0) || uint16(generation) == uint16(bounty.generation)), 'your cat is not the correct generation to fulfill this bounty');
671     	// By submitting uint256(0) as the target genemask and submitting uint256(0) for the target genes, a bounty creator can specify that they do not have 
672     	// a preference for genes.
673     	require(genes & bounty.geneMask == bounty.genes, 'your cat does not have the correct genes to fulfill this bounty');
674     	// By submitting 13 as the target highestCooldownIndexAccepted, a bounty creator can specify that they do not have a preference for cooldown (since
675     	// all Cryptokitties have a cooldown index less than or equal to 13).
676     	require(uint16(cooldownIndex) <= uint16(bounty.highestCooldownIndexAccepted), 'your cat does not have a low enough cooldown index to fulfill this bounty');
677 
678     	activeBounties[_bountyId] = false;
679     	kittyCore.transferFrom(msg.sender, bounty.bidder, _kittyId);
680     	uint256 successfulBountyFeeInWei = uint256(bounty.totalValueIncludingFees).sub(uint256(bounty.bountyPrice));
681     	totalOwnerEarningsInWei = totalOwnerEarningsInWei.add(successfulBountyFeeInWei);
682     	msg.sender.transfer(uint256(bounty.bountyPrice));
683 
684     	emit FulfillBountyAndClaimFunds(
685             _bountyId,
686             _kittyId,
687 	        msg.sender,
688 			uint256(bounty.bountyPrice),
689 	        bounty.geneMask,
690 	        bounty.genes,
691 	        uint256(bounty.generation),
692 	        uint256(bounty.highestCooldownIndexAccepted),
693 	        successfulBountyFeeInWei
694         );
695     }
696 
697     /// @notice Allows a bounty creator to withdraw the funds locked within a bounty, but only once a specified time period 
698     ///  (measured in blocks) has passed. Prohibiting the bounty creator from withdrawing their funds until this point
699     ///  guarantees a time period for bounty hunters to attempt to breed for a cat with the specified cattributes and generation.
700     ///  If a bounty creator withdraws their funds, then the bounty is invalidated and bounty hunters can no longer try to fulfill it.
701     ///  A flat fee is taken from the bounty creator's original deposit, specified by unsuccessfulBountyFeeInWei.
702     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found in the bountyIdToBounty mapping.
703     function withdrawUnsuccessfulBounty(uint256 _bountyId) external whenNotPaused {
704     	require(activeBounties[_bountyId], 'this bounty has either already completed or has not yet begun');
705     	Bounty storage bounty = bountyIdToBounty[_bountyId];
706     	require(msg.sender == bounty.bidder, 'you cannot withdraw the funds for someone elses bounty');
707     	require(block.number >= uint256(bounty.minBlockBountyValidUntil), 'this bounty is not withdrawable until the minimum number of blocks that were originally specified have passed');
708     	activeBounties[_bountyId] = false;
709     	totalOwnerEarningsInWei = totalOwnerEarningsInWei.add(uint256(bounty.unsuccessfulBountyFeeInWei));
710     	uint256 amountToReturn = uint256(bounty.totalValueIncludingFees).sub(uint256(bounty.unsuccessfulBountyFeeInWei));
711     	msg.sender.transfer(amountToReturn);
712 
713     	emit WithdrawBounty(
714             _bountyId,
715             bounty.bidder,
716             amountToReturn
717         );
718     }
719 
720     /// @notice Allows a bounty creator to withdraw the funds locked within a bounty, even if the time period that
721     ///  the bounty was guaranteed to be locked for has not passed. This function can only be called when the contract
722     ///  is frozen, and would be used as an emergency measure to allow users to withdraw their funds immediately. No
723     ///  fees are taken when this function is called.
724     /// @notice Only callable when the contract is frozen.
725     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found in the bountyIdToBounty mapping.
726     function withdrawBountyWithNoFeesTakenIfContractIsFrozen(uint256 _bountyId) external whenPaused {
727     	require(activeBounties[_bountyId], 'this bounty has either already completed or has not yet begun');
728     	Bounty storage bounty = bountyIdToBounty[_bountyId];
729     	require(msg.sender == bounty.bidder, 'you cannot withdraw the funds for someone elses bounty');
730     	activeBounties[_bountyId] = false;
731     	msg.sender.transfer(uint256(bounty.totalValueIncludingFees));
732 
733     	emit WithdrawBounty(
734             _bountyId,
735             bounty.bidder,
736             uint256(bounty.totalValueIncludingFees)
737         );
738     }
739 
740     /// @notice Computes the bounty price given a total value sent when creating a bounty, and the current
741     ///  successfulBountyFee in percentage basis points. 
742     /// @dev 10000 is not a magic number, but is the maximum number of basis points that can exist (with basis
743    	///  points being hundredths of a percent).
744     /// @param _totalValueIncludingFees The amount of ether (in wei) that was sent to create a bounty
745     /// @param _successfulBountyFeeInBasisPoints The percentage (in basis points) of that total amount that will
746     ///  be taken as a fee if the bounty is successfully completed.
747     /// @return The amount of ether (in wei) that will be rewarded if the bounty is successfully fulfilled
748     function _computeBountyPrice(uint256 _totalValueIncludingFees, uint256 _successfulBountyFeeInBasisPoints) internal pure returns (uint256) {
749     	return (_totalValueIncludingFees.mul(uint256(10000).sub(_successfulBountyFeeInBasisPoints))).div(uint256(10000));
750     }
751 
752     /// @dev By calling 'revert' in the fallback function, we prevent anyone from accidentally sending funds directly to this contract.
753     function() external payable {
754         revert();
755     }
756 }