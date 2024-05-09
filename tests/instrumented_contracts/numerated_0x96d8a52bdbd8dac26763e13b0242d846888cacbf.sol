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
410 /// @notice Once created, a bounty locks up ether. Optionally, the bounty creator may specify a number of blocks 
411 ///  to "lock" their bounty, thus preventing them from being able to cancel their bounty or withdraw their ether 
412 ///  until that number of blocks have passed. This guarantees a time period for bounty hunters to attempt to 
413 ///  breed for a cat with the specified cattributes, generation, and/or cooldown. This option is included since 
414 ///  perhaps many breeders will not chase a bounty without this guarantee. After that point, the bounty creator 
415 ///  can withdraw their funds if they wish and invalidate the bounty, or they can continue to leave the bounty 
416 ///  active.
417 /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract before calling 
418 ///  fulfillBountyAndClaimFunds(). There is no danger of this contract overreaching its approval, since the 
419 ///  CryptoKitties Core contract's approve() function only approves this contract for a single Cryptokitty. 
420 ///  Calling approve() allows this contract to transfer the specified kitty in the fulfillOfferAndClaimFunds() 
421 ///  function.
422 contract KittyBounties is KittyBountiesAdmin {
423 
424     // OpenZeppelin's SafeMath library is used for all arithmetic operations to avoid overflows/underflows.
425     using SafeMath for uint256;
426 
427 	/* ********** */
428     /* DATA TYPES */
429     /* ********** */
430 
431     /// @dev The main Bounty struct. The struct fits in four 256-bits words due to Solidity's rules for struct 
432     ///  packing.
433 	struct Bounty {
434 		// A bounty creator specifies which portion of the CryptoKitties genome is relevant to this bounty.
435 		// This is a bitwise mask, that zeroes out all other portions of the Cryptokitties genome besides
436         // those that the bounty creator is interested in. If a bounty creator does not wish to specify 
437         // genes (perhaps they want to specify generation, but don't have a preference for genes), they can 
438         // submit a geneMask of uint256(0) and genes of uint256(0).
439 		uint256 geneMask;
440         // A bounty creator specifies which cattributes they are seeking. If a user possesses a cat that 
441         // has both the specified cattributes, the specified generation, and the specified cooldown, then 
442         // they can trade that cat for the bounty. If a bounty creator does not wish to specify genes 
443         // (perhaps they want to specify generation, but don't have a preference for genes), they can 
444         // submit a geneMask of uint256(0) and genes of uint256(0).
445         uint256 genes;
446 		// The price (in wei) that a user will receive if they successfully fulfill this bounty.
447 		uint128 bountyPrice;
448 		// The total value (in wei) that the bounty creator originally sent to the contract to create this 
449         // bounty. This includes the potential fees to be paid to the contract creator.
450 		uint128 totalValueIncludingFees;
451 		// The fee that is paid if the bounty is not fulfilled and the owner withdraws their funds. This 
452         // is stored in the Bounty struct to ensure that users are charged the fee that existed at the 
453         // time of a bounty's creation, in case the contract owner changes the fees between when the bounty 
454         // is created and when the bounty creator withdraws their funds.
455 		uint128 unsuccessfulBountyFeeInWei;
456 		// Optionally, a bounty creator can set a minimum number of blocks that must pass before they can 
457         // cancel a bounty and withdraw their funds (in order to guarantee a time period for bounty hunters 
458         // to attempt to breed for the specified cat). After the time period has passed, the owner can 
459         // withdraw their funds if they wish, but the bounty stays valid until they do so. This allows for 
460         // the possiblity of leaving a bounty open indefinitely until it is filled if the bounty creator 
461         // wishes to do so.
462 		uint64 minBlockBountyValidUntil;
463         // A bounty creator can specify the exact generation that they are seeking. If they are willing to 
464         // accept cats of any generation that have the cattributes specified above, they may submit 
465         // UINT16_MAX for this variable for it to be ignored.
466         uint16 generation;
467 		// A bounty creator can specify the highest cooldownIndex that they are seeking, allowing users to 
468         // place bounties on virgin cats or cats with a sufficient cooldown to be useful in a fancy chase. 
469         // If they are willing to accept cats of any cooldown, they may submit a cooldownIndex of 13 (which 
470         // is the highest cooldown index that the Cryptokitties Core contract allows) for this variable to 
471         // be ignored.
472         uint16 highestCooldownIndexAccepted;
473         // The creator of the bounty. This address receives the specified cat if the bounty is fulfilled, 
474         // or receives their money back (minus unsuccessfulBountyFee) if the bounty is not fulfilled.
475 		address bidder;
476     }
477 
478     /* ****** */
479     /* EVENTS */
480     /* ****** */
481 
482     /// @dev This event is fired whenever a user creates a new bounty for a cat with a particular set of 
483     ///  cattributes, generation, and/or cooldown that they are seeking.
484     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the 
485     ///  bountyIdToBounty mapping.
486     /// @param bidder  The creator of the bounty. This address receives the specified cat if the bounty 
487     ///  is fulfilled, or receives their money back (minus unsuccessfulBountyFee) if the bounty is not 
488     ///  fulfilled.
489     /// @param bountyPrice  The price (in wei) that a user will receive if they successfully fulfill 
490     ///  this bounty.
491     /// @param minBlockBountyValidUntil  Every bounty is valid until at least a specified block. Before 
492     ///  that point, the owner cannot withdraw their funds (in order to guarantee a time period for bounty 
493     ///  hunters to attempt to breed for the specified cat). After the time period has passed, the owner 
494     ///  can withdraw their funds if they wish, but the bounty stays valid until they do so. This allows 
495     ///  for the possiblity of leaving a bounty open indefinitely until it is filled if the bounty creator 
496     ///  wishes to do so.
497     /// @param geneMask  A bounty creator specifies which portion of the CryptoKitties genome is relevant 
498     ///  to this bounty. This is a bitwise mask, that zeroes out all other portions of the Cryptokitties 
499     ///  genome besides those that the bounty creator is interested in. 
500     /// @param genes  A bounty creator specifies which cattributes they are seeking. If a user possesses 
501     ///  a cat that has both the specified cattributes and the specified generation, then they can trade 
502     ///  that cat for the bounty.
503     /// @param generation  A bounty creator can specify the exact generation that they are seeking. If 
504     ///  they are willing to accept cats of any generation that have the cattributes specified above, 
505     ///  they may submit UINT16_MAX for this variable for it to be ignored.
506     /// @param highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex that 
507     ///  they are seeking, allowing users to place bounties on virgin cats or cats with a sufficient 
508     ///  cooldown to be useful in a fancy chase. If they are willing to accept cats of any cooldown, they 
509     ///  may submit a cooldownIndex of 13 (which is the highest cooldown index that the Cryptokitties 
510     ///  Core contract allows) for this variable to be ignored.
511     /// @param unsuccessfulBountyFeeInWei  The fee that is paid if the bounty is not fulfilled and the 
512     ///  owner withdraws their funds. This is stored in the Bounty struct to ensure that users are charged 
513     ///  the fee that existed at the time of a bounty's creation, in case the contract owner changes the 
514     ///  fees between when the bounty is created and when the bounty creator withdraws their funds.
515     event CreateBountyAndLockFunds(
516     	uint256 bountyId,
517         address bidder,
518 		uint256 bountyPrice,
519 		uint256 minBlockBountyValidUntil,
520         uint256 geneMask,
521         uint256 genes,
522         uint256 generation,
523         uint256 highestCooldownIndexAccepted,
524         uint256 unsuccessfulBountyFeeInWei
525     );
526 
527     /// @dev This event is fired if a bounty hunter trades in a cat with the specified 
528     ///  cattributes/generation/cooldown and claims the funds locked within the bounty.
529     /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract before 
530     ///  calling fulfillBountyAndClaimFunds(). There is no danger of this contract overreaching its 
531     ///  approval, since the CryptoKitties Core contract's approve() function only approves this 
532     ///  contract for a single Cryptokitty. Calling approve() allows this contract to transfer the 
533     ///  specified kitty in the fulfillOfferAndClaimFunds() function.
534     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the 
535     ///  bountyIdToBounty mapping.
536     /// @param kittyId  The id of the CryptoKitty that fulfills the bounty requirements. 
537     /// @param bidder  The creator of the bounty. This address receives the specified cat if the 
538     ///  bounty is fulfilled, or receives their money back (minus unsuccessfulBountyFee) if the 
539     ///  bounty is not fulfilled.
540     /// @param bountyPrice  The price (in wei) that a user will receive if they successfully 
541     ///  fulfill this bounty.
542     /// @param geneMask  A bounty creator specifies which portion of the CryptoKitties genome is 
543     ///  relevant to this bounty. This is a bitwise mask, that zeroes out all other portions of the 
544     ///  Cryptokitties genome besides those that the bounty creator is interested in. 
545     /// @param genes  A bounty creator specifies which cattributes they are seeking. If a user 
546     ///  possesses a cat that has both the specified cattributes and the specified generation, then 
547     ///  they can trade that cat for the bounty.
548     /// @param generation  A bounty creator can specify the exact generation that they are seeking. 
549     ///  If they are willing to accept cats of any generation that have the cattributes specified 
550     ///  above, they may submit UINT16_MAX for this variable for it to be ignored.
551     /// @param highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex 
552     ///  that they are seeking, allowing users to place bounties on virgin cats or cats with a 
553     ///  sufficient cooldown to be useful in a fancy chase. If they are willing to accept cats of 
554     ///  any cooldown, they may submit a cooldownIndex of 13 (which is the highest cooldown index 
555     ///  that the Cryptokitties Core contract allows) for this variable to be ignored.
556     /// @param successfulBountyFeeInWei  The fee that is paid when the bounty is fulfilled. This 
557     ///  fee is calculated from totalValueIncludingFees and bountyPrice, which are both stored in 
558     ///  the Bounty struct to ensure that users are charged the fee that existed at the time of a 
559     ///  bounty's creation, in case the owner changes the fees between when the bounty is created 
560     ///  and when the bounty is fulfilled.
561     event FulfillBountyAndClaimFunds(
562         uint256 bountyId,
563         uint256 kittyId,
564         address bidder,
565 		uint256 bountyPrice,
566         uint256 geneMask,
567         uint256 genes,
568         uint256 generation,
569         uint256 highestCooldownIndexAccepted,
570         uint256 successfulBountyFeeInWei
571     );
572 
573     /// @dev This event is fired when a bounty creator wishes to invalidate a bounty. The bounty 
574     ///  creator withdraws the funds and cancels the bounty, preventing anybody from fulfilling 
575     ///  that particular bounty.
576     /// @notice If a bounty creator specified a lock time, a bounty creator cannot withdraw funds 
577     ///  or invalidate a bounty until at least the originally specified number of blocks have 
578     ///  passed. This guarantees a time period for bounty hunters to attempt to breed for a cat 
579     ///  with the specified cattributes/generation/cooldown. However, if the contract is frozen, 
580     ///  a bounty creator may withdraw their funds immediately with no fees taken by the contract 
581     ///  owner, since the bounty creator would only freeze the contract if a vulnerability was found.
582     /// @param bountyId  A unique identifier for the Bounty Struct for this bounty, found in the 
583     ///  bountyIdToBounty mapping.
584     /// @param bidder  The creator of the bounty. This address receives the specified cat if the 
585     ///  bounty is fulfilled, or receives their money back (minus unsuccessfulBountyFee) if the 
586     ///  bounty is not fulfilled.
587     /// @param withdrawnAmount  The amount returned to the bounty creator (in wei). If the contract
588     ///  is not frozen, then this is the total value originally sent to the contract minus 
589     ///  unsuccessfulBountyFeeInWei. However, if the contract is frozen, no fees are taken, and the 
590     ///  entire amount is returned to the bounty creator.
591     event WithdrawBounty(
592         uint256 bountyId,
593         address bidder,
594 		uint256 withdrawnAmount
595     );
596 
597     /* ******* */
598     /* STORAGE */
599     /* ******* */
600 
601     /// @dev A mapping that tracks bounties that have been created, regardless of whether they have 
602     ///  been cancelled or claimed thereafter. See the activeBounties mapping to determine whether 
603     ///  a particular bounty is still active.
604     mapping (uint256 => Bounty) public bountyIdToBounty;
605 
606     /// @dev An index that increments with each Bounty created. Allows the ability to jump directly 
607     ///  to a specified bounty.
608     uint256 public bountyId = 0;
609 
610     /// @dev A flag indicating that the contract still contains funds for this particular bounty. 
611     ///  This flag is set to false if the bounty is fulfilled, if the funds are withdrawn by the 
612     ///  original owner, or if this bounty has not yet been created. In all of these cases, the 
613     ///  contract no longer holds funds for this specific bounty. Solidity initializes variables 
614     ///  to zero, so there is no concern that the mapping will have been erroneously initialized 
615     ///  with any values set to true.
616     mapping (uint256 => bool) public activeBounties;
617 
618     /* ********* */
619     /* FUNCTIONS */
620     /* ********* */
621 
622     /// @notice Allows a user to create a new bounty for a cat with a particular set of cattributes, 
623     ///  generation, and/or cooldown. This optionally involves locking up a specified amount of eth 
624     ///  for at least a specified number of blocks, in order to guarantee a time period for bounty 
625     ///  hunters to attempt to breed for a cat with the specified cattributes and generation. 
626 	/// @param _geneMask  A bounty creator specifies which portion of the CryptoKitties genome is 
627     ///  relevant to this bounty. This is a bitwise mask, that zeroes out all other portions of the 
628     ///  Cryptokitties genome besides those that the bounty creator is interested in. If a bounty 
629     ///  creator does not wish to specify genes (perhaps they want to specify generation, but don't 
630     ///  have a preference for genes), they can submit a geneMask of uint256(0).
631     /// @param _genes  A bounty creator specifies which cattributes they are seeking. If a user 
632     ///  possesses a cat that has the specified cattributes, the specified generation, and the 
633     ///  specified cooldown, then they can trade that cat for the bounty.
634     /// @param _generation  A bounty creator can specify the exact generation that they are seeking. 
635     ///  If they are willing to accept cats of any generation that have the cattributes specified 
636     ///  above, they may submit UINT16_MAX for this variable for it to be ignored.
637     /// @param _highestCooldownIndexAccepted  A bounty creator can specify the highest cooldownIndex 
638     ///  that they are seeking, allowing users to place bounties on virgin cats or cats with a 
639     ///  sufficient cooldown to be useful in a fancy chase. If they are willing to accept cats of 
640     ///  any cooldown, they may submit  a cooldownIndex of 13 (which is the highest cooldown index 
641     ///  that the Cryptokitties Core contract allows) for this variable to be ignored.
642     /// @param _minNumBlocksBountyIsValidFor  The bounty creator specifies the minimum number of 
643     ///  blocks that this bounty is valid for. Every bounty is valid until at least a specified 
644     ///  block. Before that point, the owner cannot withdraw their funds (in order to guarantee a 
645     ///  time period for bounty hunters to attempt to breed for the specified cat). After the time 
646     ///  period has passed, the owner can withdraw their funds if they wish, but the bounty stays 
647     ///  valid until they do so. This allows for the possiblity of leaving a bounty open indefinitely 
648     ///  until it is filled if the bounty creator wishes to do so.
649     /// @notice This function is payable, and any eth sent to this function is interpreted as the 
650     ///  value that the user wishes to lock up for this bounty.
651     function createBountyAndLockFunds(uint256 _geneMask, uint256 _genes, uint256 _generation, uint256 _highestCooldownIndexAccepted, uint256 _minNumBlocksBountyIsValidFor) external payable whenNotPaused {
652     	require(msg.value >= unsuccessfulBountyFeeInWei.mul(uint256(2)), 'the value of your bounty must be at least twice as large as the unsuccessful bounty fee');
653     	require(_minNumBlocksBountyIsValidFor <= maximumLockoutDurationInBlocks, 'you cannot lock eth into a bounty for longer than the maximumLockoutDuration');
654     	require(_highestCooldownIndexAccepted <= uint256(13), 'you cannot specify an invalid cooldown index');
655     	require(_generation <= uint256(~uint16(0)), 'you cannot specify an invalid generation');
656         require(_genes & ~_geneMask == uint256(0), 'your geneMask must fully cover any genes that you are seeeking');
657 
658     	uint256 bountyPrice = _computeBountyPrice(msg.value, successfulBountyFeeInBasisPoints);
659     	uint256 minBlockBountyValidUntil = uint256(block.number).add(_minNumBlocksBountyIsValidFor);
660 
661     	Bounty memory bounty = Bounty({
662             geneMask: _geneMask,
663             genes: _genes,
664             bountyPrice: uint128(bountyPrice),
665             totalValueIncludingFees: uint128(msg.value),
666             unsuccessfulBountyFeeInWei: uint128(unsuccessfulBountyFeeInWei),
667             minBlockBountyValidUntil: uint64(minBlockBountyValidUntil),
668             generation: uint16(_generation),
669             highestCooldownIndexAccepted: uint16(_highestCooldownIndexAccepted),
670             bidder: msg.sender
671         });
672 
673         bountyIdToBounty[bountyId] = bounty;
674         activeBounties[bountyId] = true;
675         
676         emit CreateBountyAndLockFunds(
677             bountyId,
678 	        msg.sender,
679 			bountyPrice,
680 			minBlockBountyValidUntil,
681 	        bounty.geneMask,
682 	        bounty.genes,
683 	        _generation,
684 	        _highestCooldownIndexAccepted,
685 	        unsuccessfulBountyFeeInWei
686         );
687 
688         bountyId = bountyId.add(uint256(1));
689     }
690 
691     /// @notice After calling approve() in the CryptoKitties Core contract, a bounty hunter can 
692     ///  submit the id of a kitty that they own and a bounty that they would like to fulfill. If
693     ///  the kitty fits the requirements of the bounty, and if the bounty hunter owns the kitty,
694     ///  then this function transfers the kitty to the original bounty creator and transfers the 
695     ///  locked eth to the bounty hunter.
696     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found in 
697     ///  the bountyIdToBounty mapping.
698     /// @param _kittyId  The id of the CryptoKitty that fulfills the bounty requirements.
699     /// @notice The bounty hunter must first call approve() in the Cryptokitties Core contract 
700     ///  before calling fulfillBountyAndClaimFunds(). There is no danger of this contract 
701     ///  overreaching its approval, since the CryptoKitties Core contract's approve() function 
702     /// only approves this contract for a single Cryptokitty. Calling approve() allows this 
703     /// contract to transfer the specified kitty in the fulfillOfferAndClaimFunds() function.
704     function fulfillBountyAndClaimFunds(uint256 _bountyId, uint256 _kittyId) external whenNotPaused {
705     	require(activeBounties[_bountyId], 'this bounty has either already completed or has not yet begun');
706     	require(msg.sender == kittyCore.ownerOf(_kittyId), 'you do not own the cat that you are trying to use to fulfill this bounty');
707     	require(kittyCore.kittyIndexToApproved(_kittyId) == address(this), 'you must approve the bounties contract for this cat before you can fulfill a bounty');
708 
709     	Bounty storage bounty = bountyIdToBounty[_bountyId];
710     	uint256 cooldownIndex;
711     	uint256 generation;
712     	uint256 genes;
713         ( , , cooldownIndex, , , , , , generation, genes) = kittyCore.getKitty(_kittyId);
714 
715         // By submitting ~uint16(0) as the target generation (which is uint16_MAX), a bounty creator can specify that they do not have a preference for generation.
716     	require((uint16(bounty.generation) == ~uint16(0) || uint16(generation) == uint16(bounty.generation)), 'your cat is not the correct generation to fulfill this bounty');
717     	// By submitting uint256(0) as the target genemask and submitting uint256(0) for the target genes, a bounty creator can specify that they do not have 
718     	// a preference for genes.
719     	require((genes & bounty.geneMask) == (bounty.genes & bounty.geneMask), 'your cat does not have the correct genes to fulfill this bounty');
720     	// By submitting 13 as the target highestCooldownIndexAccepted, a bounty creator can specify that they do not have a preference for cooldown (since
721     	// all Cryptokitties have a cooldown index less than or equal to 13).
722     	require(uint16(cooldownIndex) <= uint16(bounty.highestCooldownIndexAccepted), 'your cat does not have a low enough cooldown index to fulfill this bounty');
723 
724     	activeBounties[_bountyId] = false;
725     	kittyCore.transferFrom(msg.sender, bounty.bidder, _kittyId);
726     	uint256 successfulBountyFeeInWei = uint256(bounty.totalValueIncludingFees).sub(uint256(bounty.bountyPrice));
727     	totalOwnerEarningsInWei = totalOwnerEarningsInWei.add(successfulBountyFeeInWei);
728     	msg.sender.transfer(uint256(bounty.bountyPrice));
729 
730     	emit FulfillBountyAndClaimFunds(
731             _bountyId,
732             _kittyId,
733 	        msg.sender,
734 			uint256(bounty.bountyPrice),
735 	        bounty.geneMask,
736 	        bounty.genes,
737 	        uint256(bounty.generation),
738 	        uint256(bounty.highestCooldownIndexAccepted),
739 	        successfulBountyFeeInWei
740         );
741     }
742 
743     /// @notice Allows a bounty creator to withdraw the funds locked within a bounty, but only 
744     ///  once a specified time period (measured in blocks) has passed. Prohibiting the bounty 
745     ///  creator from withdrawing their funds until this point guarantees a time period for 
746     ///  bounty hunters to attempt to breed for a cat with the specified cattributes and 
747     ///  generation. If a bounty creator withdraws their funds, then the bounty is invalidated 
748     ///  and bounty hunters can no longer try to fulfill it. A flat fee is taken from the bounty 
749     ///  creator's original deposit, specified by unsuccessfulBountyFeeInWei.
750     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found in 
751     ///  the bountyIdToBounty mapping.
752     function withdrawUnsuccessfulBounty(uint256 _bountyId) external whenNotPaused {
753     	require(activeBounties[_bountyId], 'this bounty has either already completed or has not yet begun');
754     	Bounty storage bounty = bountyIdToBounty[_bountyId];
755     	require(msg.sender == bounty.bidder, 'you cannot withdraw the funds for someone elses bounty');
756     	require(block.number >= uint256(bounty.minBlockBountyValidUntil), 'this bounty is not withdrawable until the minimum number of blocks that were originally specified have passed');
757     	activeBounties[_bountyId] = false;
758     	totalOwnerEarningsInWei = totalOwnerEarningsInWei.add(uint256(bounty.unsuccessfulBountyFeeInWei));
759     	uint256 amountToReturn = uint256(bounty.totalValueIncludingFees).sub(uint256(bounty.unsuccessfulBountyFeeInWei));
760     	msg.sender.transfer(amountToReturn);
761 
762     	emit WithdrawBounty(
763             _bountyId,
764             bounty.bidder,
765             amountToReturn
766         );
767     }
768 
769     /// @notice Allows a bounty creator to withdraw the funds locked within a bounty, even if 
770     ///  the time period that the bounty was guaranteed to be locked for has not passed. This 
771     ///  function can only be called when the contract is frozen, and would be used as an 
772     ///  emergency measure to allow users to withdraw their funds immediately. No fees are 
773     ///  taken when this function is called.
774     /// @notice Only callable when the contract is frozen.
775     /// @param _bountyId  A unique identifier for the Bounty Struct for this bounty, found 
776     ///  in the bountyIdToBounty mapping.
777     function withdrawBountyWithNoFeesTakenIfContractIsFrozen(uint256 _bountyId) external whenPaused {
778     	require(activeBounties[_bountyId], 'this bounty has either already completed or has not yet begun');
779     	Bounty storage bounty = bountyIdToBounty[_bountyId];
780     	require(msg.sender == bounty.bidder, 'you cannot withdraw the funds for someone elses bounty');
781     	activeBounties[_bountyId] = false;
782     	msg.sender.transfer(uint256(bounty.totalValueIncludingFees));
783 
784     	emit WithdrawBounty(
785             _bountyId,
786             bounty.bidder,
787             uint256(bounty.totalValueIncludingFees)
788         );
789     }
790 
791     /// @notice Computes the bounty price given a total value sent when creating a bounty, 
792     ///  and the current successfulBountyFee in percentage basis points. 
793     /// @dev 10000 is not a magic number, but is the maximum number of basis points that 
794     ///  can exist (with basis points being hundredths of a percent).
795     /// @param _totalValueIncludingFees The amount of ether (in wei) that was sent to 
796     ///  create a bounty
797     /// @param _successfulBountyFeeInBasisPoints The percentage (in basis points) of that 
798     ///  total amount that will be taken as a fee if the bounty is successfully completed.
799     /// @return The amount of ether (in wei) that will be rewarded if the bounty is 
800     ///  successfully fulfilled
801     function _computeBountyPrice(uint256 _totalValueIncludingFees, uint256 _successfulBountyFeeInBasisPoints) internal pure returns (uint256) {
802     	return (_totalValueIncludingFees.mul(uint256(10000).sub(_successfulBountyFeeInBasisPoints))).div(uint256(10000));
803     }
804 
805     /// @dev By calling 'revert' in the fallback function, we prevent anyone from 
806     ///  accidentally sending funds directly to this contract.
807     function() external payable {
808         revert();
809     }
810 }