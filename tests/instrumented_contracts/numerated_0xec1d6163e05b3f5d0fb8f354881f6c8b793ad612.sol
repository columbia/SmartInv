1 //  =====================================================================================
2 //
3 //   ___ __ __    ________  ___   __   _________   ______  ______   ______  ______
4 //  /__//_//_/\  /_______/\/__/\ /__/\/________/\ /_____/\/_____/\ /_____/\/_____/\
5 //  \::\| \| \ \ \__.::._\/\::\_\\  \ \__.::.__\/ \:::_ \ \:::_ \ \\:::_ \ \:::_ \ \
6 //   \:.      \ \   \::\ \  \:. `-\  \ \ \::\ \    \:\ \ \ \:(_) ) )\:\ \ \ \:(_) \ \
7 //    \:.\-/\  \ \  _\::\ \__\:. _    \ \ \::\ \    \:\ \ \ \: __ `\ \:\ \ \ \: ___\/
8 //     \. \  \  \ \/__\::\__/\\. \`-\  \ \ \::\ \    \:\/.:| \ \ `\ \ \:\_\ \ \ \ \
9 //      \__\/ \__\/\________\/ \__\/ \__\/  \__\/     \____/_/\_\/ \_\/\_____\/\_\/
10 //
11 //  =====================================================================================
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity 0.6.11;
16 
17 /**
18  * @dev Standard math utilities missing in the Solidity language.
19  */
20 library Math {
21     /**
22      * @dev Returns the largest of two numbers.
23      */
24     function max(uint256 a, uint256 b) internal pure returns (uint256) {
25         return a >= b ? a : b;
26     }
27 
28     /**
29      * @dev Returns the smallest of two numbers.
30      */
31     function min(uint256 a, uint256 b) internal pure returns (uint256) {
32         return a < b ? a : b;
33     }
34 
35     /**
36      * @dev Returns the average of two numbers. The result is rounded towards
37      * zero.
38      */
39     function average(uint256 a, uint256 b) internal pure returns (uint256) {
40         // (a + b) / 2 can overflow, so we distribute
41         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
42     }
43 }
44 
45 pragma solidity 0.6.11;
46 
47 /**
48  * @dev Wrappers over Solidity's arithmetic operations with added overflow
49  * checks.
50  *
51  * Arithmetic operations in Solidity wrap on overflow. This can easily result
52  * in bugs, because programmers usually assume that an overflow raises an
53  * error, which is the standard behavior in high level programming languages.
54  * `SafeMath` restores this intuition by reverting the transaction when an
55  * operation overflows.
56  *
57  * Using this library instead of the unchecked operations eliminates an entire
58  * class of bugs, so it's recommended to use it always.
59  */
60 library SafeMath {
61     /**
62      * @dev Returns the addition of two unsigned integers, reverting on
63      * overflow.
64      *
65      * Counterpart to Solidity's `+` operator.
66      *
67      * Requirements:
68      *
69      * - Addition cannot overflow.
70      */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the subtraction of two unsigned integers, reverting on
80      * overflow (when the result is negative).
81      *
82      * Counterpart to Solidity's `-` operator.
83      *
84      * Requirements:
85      *
86      * - Subtraction cannot overflow.
87      */
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         return sub(a, b, "SafeMath: subtraction overflow");
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
94      * overflow (when the result is negative).
95      *
96      * Counterpart to Solidity's `-` operator.
97      *
98      * Requirements:
99      *
100      * - Subtraction cannot overflow.
101      */
102     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         require(b <= a, errorMessage);
104         uint256 c = a - b;
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the multiplication of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `*` operator.
114      *
115      * Requirements:
116      *
117      * - Multiplication cannot overflow.
118      */
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
121         // benefit is lost if 'b' is also tested.
122         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
123         if (a == 0) {
124             return 0;
125         }
126 
127         uint256 c = a * b;
128         require(c / a == b, "SafeMath: multiplication overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers. Reverts on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator. Note: this function uses a
138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
139      * uses an invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function div(uint256 a, uint256 b) internal pure returns (uint256) {
146         return div(a, b, "SafeMath: division by zero");
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b > 0, errorMessage);
163         uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
182         return mod(a, b, "SafeMath: modulo by zero");
183     }
184 
185     /**
186      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
187      * Reverts with custom message when dividing by zero.
188      *
189      * Counterpart to Solidity's `%` operator. This function uses a `revert`
190      * opcode (which leaves remaining gas untouched) while Solidity uses an
191      * invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b != 0, errorMessage);
199         return a % b;
200     }
201 }
202 
203 pragma solidity 0.6.11;
204 
205 /**
206  * @dev Interface of the ERC20 standard as defined in the EIP.
207  */
208 interface IERC20 {
209     /**
210      * @dev Returns the amount of tokens in existence.
211      */
212     function totalSupply() external view returns (uint256);
213 
214     /**
215      * @dev Returns the amount of tokens owned by `account`.
216      */
217     function balanceOf(address account) external view returns (uint256);
218 
219     /**
220      * @dev Moves `amount` tokens from the caller's account to `recipient`.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transfer(address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Returns the remaining number of tokens that `spender` will be
230      * allowed to spend on behalf of `owner` through {transferFrom}. This is
231      * zero by default.
232      *
233      * This value changes when {approve} or {transferFrom} are called.
234      */
235     function allowance(address owner, address spender) external view returns (uint256);
236 
237     /**
238      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * IMPORTANT: Beware that changing an allowance with this method brings the risk
243      * that someone may use both the old and the new allowance by unfortunate
244      * transaction ordering. One possible solution to mitigate this race
245      * condition is to first reduce the spender's allowance to 0 and set the
246      * desired value afterwards:
247      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248      *
249      * Emits an {Approval} event.
250      */
251     function approve(address spender, uint256 amount) external returns (bool);
252 
253     /**
254      * @dev Moves `amount` tokens from `sender` to `recipient` using the
255      * allowance mechanism. `amount` is then deducted from the caller's
256      * allowance.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * Emits a {Transfer} event.
261      */
262     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Emitted when `value` tokens are moved from one account (`from`) to
266      * another (`to`).
267      *
268      * Note that `value` may be zero.
269      */
270     event Transfer(address indexed from, address indexed to, uint256 value);
271 
272     /**
273      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
274      * a call to {approve}. `value` is the new allowance.
275      */
276     event Approval(address indexed owner, address indexed spender, uint256 value);
277 }
278 
279 
280 pragma solidity 0.6.11;
281 
282 /*
283  * @dev Provides information about the current execution context, including the
284  * sender of the transaction and its data. While these are generally available
285  * via msg.sender and msg.data, they should not be accessed in such a direct
286  * manner, since when dealing with GSN meta-transactions the account sending and
287  * paying for execution may not be the actual sender (as far as an application
288  * is concerned).
289  *
290  * This contract is only required for intermediate, library-like contracts.
291  */
292 abstract contract Context {
293     function _msgSender() internal view virtual returns (address payable) {
294         return msg.sender;
295     }
296 
297     function _msgData() internal view virtual returns (bytes memory) {
298         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
299         return msg.data;
300     }
301 }
302 
303 pragma solidity 0.6.11;
304 
305 /**
306  * @dev Contract module which provides a basic access control mechanism, where
307  * there is an account (an owner) that can be granted exclusive access to
308  * specific functions.
309  *
310  * By default, the owner account will be the one that deploys the contract. This
311  * can later be changed with {transferOwnership}.
312  *
313  * This module is used through inheritance. It will make available the modifier
314  * `onlyOwner`, which can be applied to your functions to restrict their use to
315  * the owner.
316  */
317 contract Ownable is Context {
318     address private _owner;
319 
320     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
321 
322     /**
323      * @dev Initializes the contract setting the deployer as the initial owner.
324      */
325     constructor () internal {
326         address msgSender = _msgSender();
327         _owner = msgSender;
328         emit OwnershipTransferred(address(0), msgSender);
329     }
330 
331     /**
332      * @dev Returns the address of the current owner.
333      */
334     function owner() public view returns (address) {
335         return _owner;
336     }
337 
338     /**
339      * @dev Throws if called by any account other than the owner.
340      */
341     modifier onlyOwner() {
342         require(_owner == _msgSender(), "Ownable: caller is not the owner");
343         _;
344     }
345 
346     /**
347      * @dev Leaves the contract without owner. It will not be possible to call
348      * `onlyOwner` functions anymore. Can only be called by the current owner.
349      *
350      * NOTE: Renouncing ownership will leave the contract without an owner,
351      * thereby removing any functionality that is only available to the owner.
352      */
353     function renounceOwnership() public virtual onlyOwner {
354         emit OwnershipTransferred(_owner, address(0));
355         _owner = address(0);
356     }
357 
358     /**
359      * @dev Transfers ownership of the contract to a new account (`newOwner`).
360      * Can only be called by the current owner.
361      */
362     function transferOwnership(address newOwner) public virtual onlyOwner {
363         require(newOwner != address(0), "Ownable: new owner is the zero address");
364         emit OwnershipTransferred(_owner, newOwner);
365         _owner = newOwner;
366     }
367 }
368 
369 pragma solidity 0.6.11;
370 
371 // This interface is designed to be compatible with the Vyper version.
372 /// @notice This is the Ethereum 2.0 deposit contract interface.
373 /// For more information see the Phase 0 specification under https://github.com/ethereum/eth2.0-specs
374 interface IDepositContract {
375     /// @notice A processed deposit event.
376     event DepositEvent(
377         bytes pubkey,
378         bytes withdrawal_credentials,
379         bytes amount,
380         bytes signature,
381         bytes index
382     );
383 
384     /// @notice Submit a Phase 0 DepositData object.
385     /// @param pubkey A BLS12-381 public key.
386     /// @param withdrawal_credentials Commitment to a public key for withdrawals.
387     /// @param signature A BLS12-381 signature.
388     /// @param deposit_data_root The SHA-256 hash of the SSZ-encoded DepositData object.
389     /// Used as a protection against malformed input.
390     function deposit(
391         bytes calldata pubkey,
392         bytes calldata withdrawal_credentials,
393         bytes calldata signature,
394         bytes32 deposit_data_root
395     ) external payable;
396 
397     /// @notice Query the current deposit root hash.
398     /// @return The deposit root hash.
399     function get_deposit_root() external view returns (bytes32);
400 
401     /// @notice Query the current deposit count.
402     /// @return The deposit count encoded as a little endian 64-bit number.
403     function get_deposit_count() external view returns (bytes memory);
404 }
405 
406 pragma solidity 0.6.11;
407 
408 interface IVETH {
409     function mint(address account, uint amount) external;
410     function burn(address account, uint amount) external;
411     function unpause() external;
412     function paused() external view returns (bool);
413 }
414 
415 pragma solidity 0.6.11;
416 
417 contract MintDrop is Ownable {
418     using SafeMath for uint;
419 
420     /* ========== CONSTANTS ========== */
421 
422     uint constant public BONUS_DURATION = 32 days;
423     uint constant public MAX_CLAIM_DURATION = 8 days;
424     uint constant public TOTAL_BNC_REWARDS = 100000 ether;
425 
426     /* ========== STATE VARIABLES ========== */
427 
428     // address of vETH
429     address public immutable vETHAddress;
430     // address of Ethereum 2.0 Deposit Contract
431     address public immutable depositAddress;
432     // a timestamp when the bonus activity initialized
433     uint public immutable bonusStartAt;
434     // a flag to control whether the withdraw function is locked
435     bool public withdrawLocked;
436     // total amount of ETH deposited to Ethereum 2.0 Deposit Contract
437     uint public totalLocked;
438     // total amount of ETH deposited in this contract
439     uint public totalDeposit;
440     // total claimed amount of BNC rewards
441     uint public claimedRewards;
442     // user address => amount of ETH deposited by this user in this contract
443     mapping(address => uint) public myDeposit;
444     // user address => amount of BNC rewards that will rewarded to this user
445     mapping(address => uint) public myRewards;
446     // user address => a timestamp that this user claimed rewards
447     mapping(address => uint) public myLastClaimedAt;
448     // user address => the address of this user which in ss58 format on Bifrost Network
449     mapping(address => string) public bifrostAddress;
450 
451     /* ========== EVENTS ========== */
452 
453     event Deposit(address indexed sender, uint amount);
454     event Withdrawal(address indexed sender, uint amount);
455     event Claimed(address indexed sender, uint amount, uint claimed);
456     event NewValidator(bytes little_endian_deposit_count);
457     event BindAddress(address indexed sender, string bifrostAddress);
458 
459     /* ========== CONSTRUCTOR ========== */
460 
461     constructor(address vETHAddress_, address depositAddress_, uint bonusStartAt_) public Ownable() {
462         vETHAddress = vETHAddress_;
463         depositAddress = depositAddress_;
464         bonusStartAt = bonusStartAt_;
465     }
466 
467     /* ========== MUTATIVE FUNCTIONS ========== */
468 
469     function deposit() external payable {
470         claimRewards();
471         myDeposit[msg.sender] = myDeposit[msg.sender].add(msg.value);
472         totalDeposit = totalDeposit.add(msg.value);
473         // mint vETH, MintDrop should have ownership of vETH contract
474         IVETH(vETHAddress).mint(msg.sender, msg.value);
475         emit Deposit(msg.sender, msg.value);
476     }
477 
478     function withdraw(uint amount) external isWithdrawNotLocked {
479         claimRewards();
480         myDeposit[msg.sender] = myDeposit[msg.sender].sub(amount);
481         totalDeposit = totalDeposit.sub(amount);
482         // burn vETH, MintDrop should have ownership of vETH contract
483         IVETH(vETHAddress).burn(msg.sender, amount);
484         msg.sender.transfer(amount);
485         emit Withdrawal(msg.sender, amount);
486     }
487 
488     function claimRewards() public {
489         // claim must start from bonusStartAt
490         if (now < bonusStartAt) {
491             if (myLastClaimedAt[msg.sender] < bonusStartAt) {
492                 myLastClaimedAt[msg.sender] = bonusStartAt;
493             }
494             return;
495         }
496         if (myLastClaimedAt[msg.sender] >= bonusStartAt) {
497             uint rewards = getIncrementalRewards(msg.sender);
498             myRewards[msg.sender] = myRewards[msg.sender].add(rewards);
499             claimedRewards = claimedRewards.add(rewards);
500             emit Claimed(msg.sender, myRewards[msg.sender], claimedRewards);
501         }
502         myLastClaimedAt[msg.sender] = now > bonusStartAt.add(BONUS_DURATION)
503         ? bonusStartAt.add(BONUS_DURATION)
504         : now;
505     }
506 
507     function lockForValidator(
508         bytes calldata pubkey,
509         bytes calldata withdrawal_credentials,
510         bytes calldata signature,
511         bytes32 deposit_data_root
512     ) external onlyOwner isWithdrawLocked {
513         uint amount = 32 ether;
514         require(address(this).balance >= amount, "insufficient balance");
515         totalLocked = totalLocked.add(amount);
516         IDepositContract(depositAddress).deposit{value: amount}(
517             pubkey,
518             withdrawal_credentials,
519             signature,
520             deposit_data_root
521         );
522         emit NewValidator(IDepositContract(depositAddress).get_deposit_count());
523     }
524 
525     function bindBifrostAddress(string memory bifrostAddress_) external {
526         bifrostAddress[msg.sender] = bifrostAddress_;
527         emit BindAddress(msg.sender, bifrostAddress_);
528     }
529 
530     function lockWithdraw() external onlyOwner isWithdrawNotLocked {
531         withdrawLocked = true;
532         // enable vETH transfer, MintDrop should have ownership of vETH contract
533         if (IVETH(vETHAddress).paused()) {
534             IVETH(vETHAddress).unpause();
535         }
536     }
537 
538     function unlockWithdraw() external onlyOwner isWithdrawLocked {
539         withdrawLocked = false;
540     }
541 
542     /* ========== VIEWS ========== */
543 
544     function getTotalRewards() public view returns (uint) {
545         if (now < bonusStartAt) {
546             return 0;
547         }
548         uint duration = now.sub(bonusStartAt);
549         if (duration > BONUS_DURATION) {
550             return TOTAL_BNC_REWARDS;
551         }
552         return TOTAL_BNC_REWARDS.mul(duration).div(BONUS_DURATION);
553     }
554 
555     function getIncrementalRewards(address target) public view returns (uint) {
556         uint totalRewards = getTotalRewards();
557         if (
558             myLastClaimedAt[target] < bonusStartAt ||
559             totalDeposit == 0 ||
560             totalRewards == 0
561         ) {
562             return 0;
563         }
564         uint remainingRewards = totalRewards.sub(claimedRewards);
565         uint myDuration = now > bonusStartAt.add(BONUS_DURATION)
566         ? bonusStartAt.add(BONUS_DURATION).sub(myLastClaimedAt[target])
567         : now.sub(myLastClaimedAt[target]);
568         if (myDuration > MAX_CLAIM_DURATION) {
569             myDuration = MAX_CLAIM_DURATION;
570         }
571         uint rewards = remainingRewards
572         .mul(myDeposit[target])
573         .div(totalDeposit)
574         .mul(myDuration)
575         .div(MAX_CLAIM_DURATION);
576         return rewards;
577     }
578 
579     function getRewards(address target) external view returns (uint) {
580         return myRewards[target].add(getIncrementalRewards(target));
581     }
582 
583     modifier isWithdrawLocked() {
584         require(withdrawLocked, "withdrawal not locked");
585         _;
586     }
587 
588     modifier isWithdrawNotLocked() {
589         require(!withdrawLocked, "withdrawal locked");
590         _;
591     }
592 }