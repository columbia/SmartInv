1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-18
3 */
4 
5 pragma solidity ^0.7.5;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a, "SafeMath: subtraction overflow");
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      * - Multiplication cannot overflow.
61      */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the integer division of two unsigned integers. Reverts on
78      * division by zero. The result is rounded towards zero.
79      *
80      * Counterpart to Solidity's `/` operator. Note: this function uses a
81      * `revert` opcode (which leaves remaining gas untouched) while Solidity
82      * uses an invalid opcode to revert (consuming all remaining gas).
83      *
84      * Requirements:
85      * - The divisor cannot be zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0, "SafeMath: division by zero");
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
98      * Reverts when dividing by zero.
99      *
100      * Counterpart to Solidity's `%` operator. This function uses a `revert`
101      * opcode (which leaves remaining gas untouched) while Solidity uses an
102      * invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      * - The divisor cannot be zero.
106      */
107     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b != 0, "SafeMath: modulo by zero");
109         return a % b;
110     }
111 }
112 // ┏━━━┓━┏┓━┏┓━━┏━━━┓━━┏━━━┓━━━━┏━━━┓━━━━━━━━━━━━━━━━━━━┏┓━━━━━┏━━━┓━━━━━━━━━┏┓━━━━━━━━━━━━━━┏┓━
113 // ┃┏━━┛┏┛┗┓┃┃━━┃┏━┓┃━━┃┏━┓┃━━━━┗┓┏┓┃━━━━━━━━━━━━━━━━━━┏┛┗┓━━━━┃┏━┓┃━━━━━━━━┏┛┗┓━━━━━━━━━━━━┏┛┗┓
114 // ┃┗━━┓┗┓┏┛┃┗━┓┗┛┏┛┃━━┃┃━┃┃━━━━━┃┃┃┃┏━━┓┏━━┓┏━━┓┏━━┓┏┓┗┓┏┛━━━━┃┃━┗┛┏━━┓┏━┓━┗┓┏┛┏━┓┏━━┓━┏━━┓┗┓┏┛
115 // ┃┏━━┛━┃┃━┃┏┓┃┏━┛┏┛━━┃┃━┃┃━━━━━┃┃┃┃┃┏┓┃┃┏┓┃┃┏┓┃┃━━┫┣┫━┃┃━━━━━┃┃━┏┓┃┏┓┃┃┏┓┓━┃┃━┃┏┛┗━┓┃━┃┏━┛━┃┃━
116 // ┃┗━━┓━┃┗┓┃┃┃┃┃┃┗━┓┏┓┃┗━┛┃━━━━┏┛┗┛┃┃┃━┫┃┗┛┃┃┗┛┃┣━━┃┃┃━┃┗┓━━━━┃┗━┛┃┃┗┛┃┃┃┃┃━┃┗┓┃┃━┃┗┛┗┓┃┗━┓━┃┗┓
117 // ┗━━━┛━┗━┛┗┛┗┛┗━━━┛┗┛┗━━━┛━━━━┗━━━┛┗━━┛┃┏━┛┗━━┛┗━━┛┗┛━┗━┛━━━━┗━━━┛┗━━┛┗┛┗┛━┗━┛┗┛━┗━━━┛┗━━┛━┗━┛
118 // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┃┃━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
119 // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┗┛━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
120 
121 // SPDX-License-Identifier: CC0-1.0
122 
123 // This interface is designed to be compatible with the Vyper version.
124 /// @notice This is the Ethereum 2.0 deposit contract interface.
125 /// For more information see the Phase 0 specification under https://github.com/ethereum/eth2.0-specs
126 interface IDepositContract {
127     /// @notice A processed deposit event.
128     event DepositEvent(
129         bytes pubkey,
130         bytes withdrawal_credentials,
131         bytes amount,
132         bytes signature,
133         bytes index
134     );
135 
136     /// @notice Submit a Phase 0 DepositData object.
137     /// @param pubkey A BLS12-381 public key.
138     /// @param withdrawal_credentials Commitment to a public key for withdrawals.
139     /// @param signature A BLS12-381 signature.
140     /// @param deposit_data_root The SHA-256 hash of the SSZ-encoded DepositData object.
141     /// Used as a protection against malformed input.
142     function deposit(
143         bytes calldata pubkey,
144         bytes calldata withdrawal_credentials,
145         bytes calldata signature,
146         bytes32 deposit_data_root
147     ) external payable;
148 
149     /// @notice Query the current deposit root hash.
150     /// @return The deposit root hash.
151     function get_deposit_root() external view returns (bytes32);
152 
153     /// @notice Query the current deposit count.
154     /// @return The deposit count encoded as a little endian 64-bit number.
155     function get_deposit_count() external view returns (bytes memory);
156 }
157 
158 /**
159  * @dev Contract module which provides a basic access control mechanism, where
160  * there is an account (an owner) that can be granted exclusive access to
161  * specific functions.
162  *
163  * This module is used through inheritance. It will make available the modifier
164  * `onlyOwner`, which can be aplied to your functions to restrict their use to
165  * the owner.
166  */
167 contract Ownable {
168     address private _owner;
169 
170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172     /**
173      * @dev Initializes the contract setting the deployer as the initial owner.
174      */
175     constructor () {
176         _owner = msg.sender;
177         emit OwnershipTransferred(address(0), _owner);
178     }
179 
180     /**
181      * @dev Returns the address of the current owner.
182      */
183     function owner() public view returns (address) {
184         return _owner;
185     }
186 
187     /**
188      * @dev Throws if called by any account other than the owner.
189      */
190     modifier onlyOwner() {
191         require(isOwner(), "Ownable: caller is not the owner");
192         _;
193     }
194 
195     /**
196      * @dev Returns true if the caller is the current owner.
197      */
198     function isOwner() public view returns (bool) {
199         return msg.sender == _owner;
200     }
201 
202     /**
203      * @dev Leaves the contract without owner. It will not be possible to call
204      * `onlyOwner` functions anymore. Can only be called by the current owner.
205      *
206      * > Note: Renouncing ownership will leave the contract without an owner,
207      * thereby removing any functionality that is only available to the owner.
208      */
209     function renounceOwnership() public onlyOwner {
210         emit OwnershipTransferred(_owner, address(0));
211         _owner = address(0);
212     }
213 
214     /**
215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
216      * Can only be called by the current owner.
217      */
218     function transferOwnership(address newOwner) public onlyOwner {
219         _transferOwnership(newOwner);
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      */
225     function _transferOwnership(address newOwner) internal {
226         require(newOwner != address(0), "Ownable: new owner is the zero address");
227         emit OwnershipTransferred(_owner, newOwner);
228         _owner = newOwner;
229     }
230 }
231 
232 /**
233  * @title Pausable
234  * @dev Base contract which allows children to implement an emergency stop mechanism.
235  * from https://github.com/FriendlyUser/solidity-smart-contracts//blob/v0.2.0/contracts/other/CredVert/Pausable.sol
236  */
237 contract Pausable is Ownable {
238     event Pause();
239     event Unpause();
240 
241     bool public paused = false;
242 
243 
244     /**
245     * @dev Modifier to make a function callable only when the contract is not paused.
246     */
247     modifier whenNotPaused() {
248         require(!paused, "Pausable: Contract is paused and requires !paused");
249         _;
250     }
251 
252     /**
253      * @dev Modifier to make a function callable only when the contract is paused.
254      */
255     modifier whenPaused() {
256         require(paused, "Pausable: Contract is not paused but requires paused");
257         _;
258     }
259 
260     /**
261      * @dev called by the owner to pause, triggers stopped state
262      */
263     function pause() public onlyOwner whenNotPaused {
264         paused = true;
265         emit Pause();
266     }
267 
268     /**
269      * @dev called by the owner to unpause, returns to normal state
270      */
271     function unpause() public onlyOwner whenPaused {
272         paused = false;
273         emit Unpause();
274     }
275 }
276 
277 interface ISharedDeposit {
278     function donate(uint shares) payable external;
279 }
280 
281 interface IBETH {
282     function setMinter(address minter_) external;
283 
284     /**
285      * @notice Mint new tokens
286      * @param dst The address of the destination account
287      * @param rawAmount The number of tokens to be minted
288      */
289     function mint(address dst, uint rawAmount) external;
290     
291     function burn(address src, uint rawAmount) external;
292     
293     function mintingAllowedAfter() external view returns (uint);
294 
295     /**
296      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
297      * @param account The address of the account holding the funds
298      * @param spender The address of the account spending the funds
299      * @return The number of tokens approved
300      */
301     function allowance(address account, address spender) external view returns (uint);
302 
303     /**
304      * @notice Approve `spender` to transfer up to `amount` from `src`
305      * @dev This will overwrite the approval amount for `spender`
306      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
307      * @param spender The address of the account which may transfer tokens
308      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
309      * @return Whether or not the approval succeeded
310      */
311     function approve(address spender, uint rawAmount) external returns (bool);
312 
313     /**
314      * @notice Triggers an approval from owner to spends
315      * @param owner The address to approve from
316      * @param spender The address to be approved
317      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
318      * @param deadline The time at which to expire the signature
319      * @param v The recovery byte of the signature
320      * @param r Half of the ECDSA signature pair
321      * @param s Half of the ECDSA signature pair
322      */
323     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
324 
325     /**
326      * @notice Get the number of tokens held by the `account`
327      * @param account The address of the account to get the balance of
328      * @return The number of tokens held
329      */
330     function balanceOf(address account) external view returns (uint);
331 
332     /**
333      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
334      * @param dst The address of the destination account
335      * @param rawAmount The number of tokens to transfer
336      * @return Whether or not the transfer succeeded
337      */
338     function transfer(address dst, uint rawAmount) external returns (bool);
339     /**
340      * @notice Transfer `amount` tokens from `src` to `dst`
341      * @param src The address of the source account
342      * @param dst The address of the destination account
343      * @param rawAmount The number of tokens to transfer
344      * @return Whether or not the transfer succeeded
345      */
346     function transferFrom(address src, address dst, uint rawAmount) external returns (bool);
347 }
348 
349 
350 /**
351  * @dev Contract module that helps prevent reentrant calls to a function.
352  *
353  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
354  * available, which can be aplied to functions to make sure there are no nested
355  * (reentrant) calls to them.
356  *
357  * Note that because there is a single `nonReentrant` guard, functions marked as
358  * `nonReentrant` may not call one another. This can be worked around by making
359  * those functions `private`, and then adding `external` `nonReentrant` entry
360  * points to them.
361  */
362 contract ReentrancyGuard {
363     /// @dev counter to allow mutex lock with only one SSTORE operation
364     uint256 private _guardCounter;
365 
366     constructor () {
367         // The counter starts at one to prevent changing it from zero to a non-zero
368         // value, which is a more expensive operation.
369         _guardCounter = 1;
370     }
371 
372     /**
373      * @dev Prevents a contract from calling itself, directly or indirectly.
374      * Calling a `nonReentrant` function from another `nonReentrant`
375      * function is not supported. It is possible to prevent this from happening
376      * by making the `nonReentrant` function external, and make it call a
377      * `private` function that does the actual work.
378      */
379     modifier nonReentrant() {
380         _guardCounter += 1;
381         uint256 localCounter = _guardCounter;
382         _;
383         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
384     }
385 }
386 
387 
388 contract SharedDeposit is Pausable, ReentrancyGuard {
389     using SafeMath for uint256;
390     using SafeMath for uint;
391      /* ========== STATE VARIABLES ========== */
392     address public mainnetDepositContractAddress = 0x00000000219ab540356cBB839Cbe05303d7705Fa;
393 
394     IDepositContract depositContract;
395 
396     uint256 public adminFee;
397     uint256 public numValidators; 
398     uint256 public costPerValidator;
399     uint256 public curValidatorShares;
400     uint256 public validatorsCreated;
401     uint256 public adminFeeTotal;
402     bool public disableWithdrawRefund;
403     // Its hard to exactly hit the max deposit amount with small shares. this allows a small bit of overflow room
404     // Eth in the buffer cannot be withdrawn by an admin, only by burning the underlying token via a user withdraw
405     uint256 public buffer; 
406     address public BETHTokenAddress;
407     IBETH BETHToken;
408 
409     constructor(uint256 _numValidators, uint256 _adminFee, address _BETHTokenAddress) public {
410         depositContract = IDepositContract(mainnetDepositContractAddress);
411 
412         adminFee = _adminFee; // Admin and infra fees
413         numValidators = _numValidators; // The number of validators to create in this lot. Enough ETH for this many are needed before transfer to eth2
414 
415         // Eth in the buffer cannot be withdrawn by an admin, only by burning the underlying token
416         buffer = uint(10).mul(1e18); // roughly equal to 10 eth. 
417 
418         curValidatorShares = 0; // The validator shares created by this shared stake contract. 1 share costs >= 1 eth
419         validatorsCreated = 0; // The number of times the deposit to eth2 contract has been called to create validators
420         adminFeeTotal = 0; // Total accrued admin fee
421         disableWithdrawRefund = false; // Flash loan tokenomic protection in case of changes in admin fee with future lots
422     
423         BETHTokenAddress = _BETHTokenAddress;
424         BETHToken = IBETH(BETHTokenAddress);
425 
426         costPerValidator = uint(32).mul(1e18).add(adminFee);
427     }
428     
429     // VIEW FUNCTIONS
430     function mintingAllowedAfter() external view returns (uint256) {
431         return BETHToken.mintingAllowedAfter();
432     }
433 
434     function workable() public view returns (bool) {
435         // similiar to workable on KP3R contracts
436         // used to check if we can call deposit to eth2
437         uint256 amount = 32 ether;
438         bool validatorLimitReached = (curValidatorShares >= maxValidatorShares());
439         bool balanceEnough = (address(this).balance >= amount);
440         return validatorLimitReached && balanceEnough;
441     }
442 
443     function maxValidatorShares() public view returns (uint256) {
444         return uint(32).mul(1e18).mul(numValidators);
445     }
446 
447     function remainingSpaceInEpoch() external view returns (uint256) {
448         // Helpful view function to gauge how much the user can send to the contract when it is near full
449         uint remainingShares = (maxValidatorShares()).sub(curValidatorShares);
450         uint valBeforeAdmin = remainingShares.mul(1e18).div(uint(1).mul(1e18).sub(adminFee.mul(1e18).div(costPerValidator)));
451         return valBeforeAdmin;
452     }
453 
454     // USER INTERACTIONS
455     /*
456     Shares minted = Z
457     Principal deposit input = P
458     AdminFee = a
459     AdminFee as percent in 1e18 = a% =  a / 32
460     AdminFee on tx in 1e18 = (P * a% / 1e18)
461 
462     on deposit:
463     P - (P * a%) = Z
464 
465     on withdraw with admin fee refund:
466     P = Z / (1 - a%)
467     */
468 
469     function deposit() public payable nonReentrant whenNotPaused {
470         // input is whole, not / 1e18 , i.e. in 1 = 1 eth send when from etherscan
471         uint value = uint(msg.value);
472 
473         uint myAdminFee = adminFee.mul(value).mul(1e18).div(costPerValidator).div(1e18);        
474         uint valMinusAdmin = value.sub(myAdminFee);
475         uint newShareTotal = curValidatorShares.add(valMinusAdmin);
476         
477         require(newShareTotal <= buffer.add(maxValidatorShares()), "Eth2Staker:deposit:Amount too large, not enough validators left");
478         curValidatorShares = newShareTotal;
479         adminFeeTotal = adminFeeTotal.add(myAdminFee);
480         BETHToken.mint(msg.sender, valMinusAdmin);
481     }
482 
483     function withdraw(uint256 amount) public nonReentrant whenNotPaused {
484         uint valBeforeAdmin = amount.mul(1e18).div(uint(1).mul(1e18).sub(adminFee.mul(1e18).div(costPerValidator)));
485         if (disableWithdrawRefund == true) {
486             valBeforeAdmin = amount;
487         }
488         uint newShareTotal = curValidatorShares.sub(amount);
489 
490         require(newShareTotal <= buffer.add(maxValidatorShares()), "Eth2Staker:withdraw:Amount too large, not enough validators supplied");
491 
492         require(newShareTotal >= 0, "Eth2Staker:withdraw:Amount too small, not enough validators left");
493         require(address(this).balance > amount, "Eth2Staker:withdraw:not enough balancce in contract");
494         require(BETHToken.balanceOf(msg.sender) >= amount, "Eth2Staker: Sender balance not enough");
495 
496         curValidatorShares = newShareTotal;
497         adminFeeTotal = adminFeeTotal.sub(valBeforeAdmin.sub(amount));
498         BETHToken.burn(msg.sender, amount);
499         address payable sender = msg.sender;
500         sender.transfer(valBeforeAdmin);
501     }
502 
503     // migration function to accept old monies and copy over state
504     // users should not use this as it just donates the money without minting veth or tracking donations
505     function donate(uint shares) external payable nonReentrant {
506         curValidatorShares = shares;
507     }
508 
509     // OWNER ONLY FUNCTIONS
510 
511     // This needs to be called once per validator
512     function depositToEth2(bytes calldata pubkey,
513         bytes calldata withdrawal_credentials,
514         bytes calldata signature,
515         bytes32 deposit_data_root) external onlyOwner nonReentrant {
516             uint256 amount = 32 ether;
517             require(address(this).balance >= amount, "Eth2Staker:depositToEth2: Not enough balance"); //need at least 32 ETH
518 
519             depositContract.deposit{value: amount}(pubkey, withdrawal_credentials, signature, deposit_data_root);
520             validatorsCreated = validatorsCreated.add(1);
521     }
522 
523     function setNumValidators(uint256 _numValidators) external onlyOwner {
524         numValidators = _numValidators;
525     }
526 
527     function toggleWithdrawAdminFeeRefund() external onlyOwner {
528         // in case the pool of tokens gets too large it will attract flash loans if the price of the pool token dips below x-admin fee
529         // in that case or if the admin fee changes in cases of 1k+ validators
530         // we may need to disable the withdraw refund
531 
532         // We also need to toggle this on if post migration we want to allow users to withdraw funds
533         disableWithdrawRefund = !disableWithdrawRefund;
534     }
535 
536     // Recover ownership of token supply and mint for upgrading the contract
537     // When we want to upgrade this contract the plan is to:
538     // - Limit the num validators. This disables deposits when the limit is reached
539     // - Create the set of validators trasfering contract value to eth2
540     // - Migrate the minter to a new contract
541     // - migrate dust in the buffer to the new contract
542     function setMinter(address payable minter_) external onlyOwner nonReentrant {
543         BETHToken.setMinter(minter_);
544 
545         uint amount = address(this).balance;
546         ISharedDeposit newContract = ISharedDeposit(minter_);
547         if (amount > 0) {
548             newContract.donate{value: amount}(curValidatorShares);
549         }
550     }
551 
552     function setAdminFee(uint256 amount) external onlyOwner {
553         adminFee = amount;
554         costPerValidator = uint(32).mul(1e18).add(adminFee);
555     }
556 
557     function withdrawAdminFee(uint amount) external onlyOwner nonReentrant {
558         require(validatorsCreated >= 0, "Eth2Staker:withdrawAdminFee: No validators created. Admins cannot withdraw without creation");
559         address payable sender = msg.sender;
560         if (amount == 0) {
561             amount = adminFeeTotal;
562         }
563         require(amount <= adminFeeTotal, "Eth2Staker:withdrawAdminFee: More than adminFeeTotal cannot be withdrawn");
564         sender.transfer(amount);
565         adminFeeTotal = adminFeeTotal.sub(amount);
566     }
567 }
