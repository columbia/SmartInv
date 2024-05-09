1 // SPDX-License-Identifier: UNLICENSED
2 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
232 
233 
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Interface of the ERC20 standard as defined in the EIP.
239  */
240 interface IERC20 {
241     /**
242      * @dev Returns the amount of tokens in existence.
243      */
244     function totalSupply() external view returns (uint256);
245 
246     /**
247      * @dev Returns the amount of tokens owned by `account`.
248      */
249     function balanceOf(address account) external view returns (uint256);
250 
251     /**
252      * @dev Moves `amount` tokens from the caller's account to `recipient`.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transfer(address recipient, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Returns the remaining number of tokens that `spender` will be
262      * allowed to spend on behalf of `owner` through {transferFrom}. This is
263      * zero by default.
264      *
265      * This value changes when {approve} or {transferFrom} are called.
266      */
267     function allowance(address owner, address spender) external view returns (uint256);
268 
269     /**
270      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * IMPORTANT: Beware that changing an allowance with this method brings the risk
275      * that someone may use both the old and the new allowance by unfortunate
276      * transaction ordering. One possible solution to mitigate this race
277      * condition is to first reduce the spender's allowance to 0 and set the
278      * desired value afterwards:
279      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280      *
281      * Emits an {Approval} event.
282      */
283     function approve(address spender, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Moves `amount` tokens from `sender` to `recipient` using the
287      * allowance mechanism. `amount` is then deducted from the caller's
288      * allowance.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transferFrom(
295         address sender,
296         address recipient,
297         uint256 amount
298     ) external returns (bool);
299 
300     /**
301      * @dev Emitted when `value` tokens are moved from one account (`from`) to
302      * another (`to`).
303      *
304      * Note that `value` may be zero.
305      */
306     event Transfer(address indexed from, address indexed to, uint256 value);
307 
308     /**
309      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
310      * a call to {approve}. `value` is the new allowance.
311      */
312     event Approval(address indexed owner, address indexed spender, uint256 value);
313 }
314 
315 // File: @openzeppelin/contracts/utils/Context.sol
316 
317 
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Provides information about the current execution context, including the
323  * sender of the transaction and its data. While these are generally available
324  * via msg.sender and msg.data, they should not be accessed in such a direct
325  * manner, since when dealing with meta-transactions the account sending and
326  * paying for execution may not be the actual sender (as far as an application
327  * is concerned).
328  *
329  * This contract is only required for intermediate, library-like contracts.
330  */
331 abstract contract Context {
332     function _msgSender() internal view virtual returns (address) {
333         return msg.sender;
334     }
335 
336     function _msgData() internal view virtual returns (bytes calldata) {
337         return msg.data;
338     }
339 }
340 
341 // File: @openzeppelin/contracts/access/Ownable.sol
342 
343 
344 
345 pragma solidity ^0.8.0;
346 
347 
348 /**
349  * @dev Contract module which provides a basic access control mechanism, where
350  * there is an account (an owner) that can be granted exclusive access to
351  * specific functions.
352  *
353  * By default, the owner account will be the one that deploys the contract. This
354  * can later be changed with {transferOwnership}.
355  *
356  * This module is used through inheritance. It will make available the modifier
357  * `onlyOwner`, which can be applied to your functions to restrict their use to
358  * the owner.
359  */
360 abstract contract Ownable is Context {
361     address private _owner;
362 
363     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
364 
365     /**
366      * @dev Initializes the contract setting the deployer as the initial owner.
367      */
368     constructor() {
369         _setOwner(_msgSender());
370     }
371 
372     /**
373      * @dev Returns the address of the current owner.
374      */
375     function owner() public view virtual returns (address) {
376         return _owner;
377     }
378 
379     /**
380      * @dev Throws if called by any account other than the owner.
381      */
382     modifier onlyOwner() {
383         require(owner() == _msgSender(), "Ownable: caller is not the owner");
384         _;
385     }
386 
387     /**
388      * @dev Leaves the contract without owner. It will not be possible to call
389      * `onlyOwner` functions anymore. Can only be called by the current owner.
390      *
391      * NOTE: Renouncing ownership will leave the contract without an owner,
392      * thereby removing any functionality that is only available to the owner.
393      */
394     function renounceOwnership() public virtual onlyOwner {
395         _setOwner(address(0));
396     }
397 
398     /**
399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
400      * Can only be called by the current owner.
401      */
402     function transferOwnership(address newOwner) public virtual onlyOwner {
403         require(newOwner != address(0), "Ownable: new owner is the zero address");
404         _setOwner(newOwner);
405     }
406 
407     function _setOwner(address newOwner) private {
408         address oldOwner = _owner;
409         _owner = newOwner;
410         emit OwnershipTransferred(oldOwner, newOwner);
411     }
412 }
413 
414 // File: gist-314004e0d4de055bd488390866f8ac4a/TokenVesting.sol
415 
416 
417 
418 pragma solidity 0.8.0;
419 
420 
421 
422 
423 /**
424  * @title Select Token Vesting smart contract
425  * @author Michal Wojcik
426  * @notice Contract for distribute bought SELECT tokens
427  * @dev WARNING!
428  *      Released Tokens - all tokens allowed to CLAIM.
429  *      Claimed tokens - all tokens already transferred to address account from vesting contract.
430 */
431 contract TokenVesting is Ownable {
432     using SafeMath for uint256;
433 
434     uint256 private constant RELEASE_TIMEFRAME = 604_800; // 1 week
435     uint256 private constant SINGLE_RELEASE_PERCENTAGE = 3;
436     uint256 private constant INITIAL_PERCENTAGE = 10;
437     uint256 private _vestingStartTime;
438     IERC20  private _erc20Token;
439 
440     event TokensClaimed(address recipient, uint256 claimedAmount, bool isInitialClaim);
441 
442     /**
443      * @notice Struct defining vesting user input data
444      * @param userAddress - vesting user address
445      * @param salesStagesBalance - all bought and earned user tokens during pre listing period (WEI)
446      */
447     struct VestingUserInput {
448         address userAddress;
449         uint256 salesStagesBalance;
450     }
451 
452     /**
453      * @notice Struct defining vesting user state
454      * @param userAddress - vesting user address
455      * @param salesStagesBalance - all bought and earned user tokens during pre listing period (WEI)
456      * @param claimedTokens - already claimed tokens (WEI)
457      */
458     struct VestingUser {
459         address userAddress;
460         uint256 salesStagesBalance;
461         uint256 claimedTokens;
462     }
463 
464     mapping(address => VestingUser) private _vestingUsers;
465 
466     /**
467      * @notice Initialization of contract
468      * @param erc20TokenAddress - address of ERC-20 token contract
469      * @param vestingStartTime - timestamp first day of vesting
470      * @param vestingUsers - list of users who bought the tokens
471      */
472     constructor(address erc20TokenAddress, uint256 vestingStartTime, VestingUserInput[] memory vestingUsers) {
473         _erc20Token = IERC20(erc20TokenAddress);
474         _vestingStartTime = vestingStartTime;
475 
476 
477         for (uint256 i = 0; i < vestingUsers.length; i++) {
478             VestingUserInput memory vestingUser = vestingUsers[i];
479             _vestingUsers[vestingUser.userAddress] = VestingUser(vestingUser.userAddress, vestingUser.salesStagesBalance, 0);
480         }
481     }
482 
483     /**
484      * @notice Update vesting users - for fixing porpoises
485      * @param vestingUsers - list of users who bought the tokens
486      * @dev Warning! If you pass existing user his values can be reset.
487      */
488     function updateVestingUsers(VestingUserInput[] memory vestingUsers) external onlyOwner() {
489         for (uint256 i = 0; i < vestingUsers.length; i++) {
490             VestingUserInput memory vestingUser = vestingUsers[i];
491             _vestingUsers[vestingUser.userAddress] = VestingUser(vestingUser.userAddress, vestingUser.salesStagesBalance, 0);
492         }
493     }
494 
495     /**
496      * @notice Transfer released ERC-20 tokens to caller's address.
497      * @dev Emits {TokensClaimed} event on success
498      */
499     function claimTokens() external {
500         VestingUser memory vestingUserSummary = _vestingUsers[msg.sender];
501         uint256 timeNow = block.timestamp;
502         uint256 vestingStartTime = _vestingStartTime;
503         bool isInitialClaim = _getTimeframesCount(timeNow, vestingStartTime) == 0;
504 
505         require(timeNow > vestingStartTime, "Vesting not started yet.");
506 
507         require(vestingUserSummary.salesStagesBalance > 0, "You don't have any tokens.");
508 
509         uint256 tokensToClaim = _getReleasedTokensAmount(timeNow, vestingStartTime, vestingUserSummary.salesStagesBalance)
510         .sub(vestingUserSummary.claimedTokens);
511 
512         require(tokensToClaim > 0, "You don't have tokens to claim.");
513 
514         _vestingUsers[msg.sender].claimedTokens += tokensToClaim;
515 
516         require(_erc20Token.transfer(msg.sender, tokensToClaim), "ERC20Token: Transfer failed");
517 
518         emit TokensClaimed(msg.sender, tokensToClaim, isInitialClaim);
519     }
520 
521     /**
522      * @notice Returns information about current account vesting state
523      * @return releasedTokens - sum of all tokens allowed to be released (already claimed founds included)
524      * @return salesStageBalance - all bought and earned tokens during sale stages
525      * @return claimedTokensAmount - already withdrawn amount of tokens
526      * @dev To get actual tokensToClaim you need to do operation: {tokensToRelease} - {withdrawnTokensAmount}
527      */
528     function getAddressVestingInfo() external view returns (uint256 releasedTokens, uint256 salesStageBalance, uint256 claimedTokensAmount, uint256 filledTimeframesCount) {
529         VestingUser memory vestingUserSummary = _vestingUsers[msg.sender];
530         uint256 timeNow = block.timestamp;
531         uint256 vestingStartTime = _vestingStartTime;
532 
533         filledTimeframesCount = _getTimeframesCount(timeNow, vestingStartTime);
534         releasedTokens = _getReleasedTokensAmount(block.timestamp, _vestingStartTime, vestingUserSummary.salesStagesBalance);
535         salesStageBalance = vestingUserSummary.salesStagesBalance;
536         claimedTokensAmount = vestingUserSummary.claimedTokens;
537     }
538 
539     /**
540      * @notice Returns amount of released tokens for given account address
541      * @param timeNow - actual timestamp
542      * @param vestingStartTime - timestamp when vesting program starts
543      * @param accountBalance - sum of all bought and earned tokens during sale stages
544      */
545     function _getReleasedTokensAmount(uint256 timeNow, uint256 vestingStartTime, uint256 accountBalance) private pure returns (uint256) {
546 
547         if (timeNow < vestingStartTime) {
548             return 0;
549         }
550 
551         uint256 timeframesCount = _getTimeframesCount(timeNow, vestingStartTime);
552         uint256 numberOfPercentToRelease = timeframesCount.mul(SINGLE_RELEASE_PERCENTAGE).add(INITIAL_PERCENTAGE);
553 
554         return (accountBalance * numberOfPercentToRelease) / 100;
555     }
556 
557     /**
558      * @notice Returns amount of timeframes from vesting program start till now
559      * @param timeNow - actual timestamp
560      * @param vestingStartTime - timestamp when vesting program starts
561      */
562     function _getTimeframesCount(uint256 timeNow, uint256 vestingStartTime) private pure returns (uint256) {
563 
564         if (timeNow < vestingStartTime) {
565             return 0;
566         }
567 
568         uint256 maxTimeframes = (100 - INITIAL_PERCENTAGE) / SINGLE_RELEASE_PERCENTAGE;
569 
570         uint256 timeframesCount = (timeNow.sub(vestingStartTime)) / RELEASE_TIMEFRAME;
571 
572         return (timeframesCount <= maxTimeframes) ? timeframesCount : maxTimeframes;
573     }
574 }