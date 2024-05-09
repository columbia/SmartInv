1 // SPDX-License-Identifier: AGPL-3.0-or-later\
2 pragma solidity 0.7.5;
3 
4 /**
5  * @title SafeERC20
6  * @dev Wrappers around ERC20 operations that throw on failure (when the token
7  * contract returns false). Tokens that return no value (and instead revert or
8  * throw on failure) are also supported, non-reverting calls are assumed to be
9  * successful.
10  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
11  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
12  */
13 library SafeERC20 {
14     using SafeMath for uint256;
15     using Address for address;
16 
17     function safeTransfer(IERC20 token, address to, uint256 value) internal {
18         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
19     }
20 
21     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
22         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
23     }
24 
25     /**
26      * @dev Deprecated. This function has issues similar to the ones found in
27      * {IERC20-approve}, and its usage is discouraged.
28      *
29      * Whenever possible, use {safeIncreaseAllowance} and
30      * {safeDecreaseAllowance} instead.
31      */
32     function safeApprove(IERC20 token, address spender, uint256 value) internal {
33         // safeApprove should only be called when setting an initial allowance,
34         // or when resetting it to zero. To increase and decrease it, use
35         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
36         // solhint-disable-next-line max-line-length
37         require((value == 0) || (token.allowance(address(this), spender) == 0),
38             "SafeERC20: approve from non-zero to non-zero allowance"
39         );
40         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
41     }
42 
43     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
44         uint256 newAllowance = token.allowance(address(this), spender).add(value);
45         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
46     }
47 
48     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
49         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
50         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
51     }
52 
53     /**
54      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
55      * on the return value: the return value is optional (but if data is returned, it must not be false).
56      * @param token The token targeted by the call.
57      * @param data The call data (encoded using abi.encode or one of its variants).
58      */
59     function _callOptionalReturn(IERC20 token, bytes memory data) private {
60         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
61         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
62         // the target address contains contract code and also asserts for success in the low-level call.
63 
64         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
65         if (returndata.length > 0) { // Return data is optional
66             // solhint-disable-next-line max-line-length
67             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
68         }
69     }
70 }
71 
72 /**
73  * @dev Wrappers over Solidity's arithmetic operations with added overflow
74  * checks.
75  *
76  * Arithmetic operations in Solidity wrap on overflow. This can easily result
77  * in bugs, because programmers usually assume that an overflow raises an
78  * error, which is the standard behavior in high level programming languages.
79  * `SafeMath` restores this intuition by reverting the transaction when an
80  * operation overflows.
81  *
82  * Using this library instead of the unchecked operations eliminates an entire
83  * class of bugs, so it's recommended to use it always.
84  */
85 library SafeMath {
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the subtraction of two unsigned integers, reverting on
105      * overflow (when the result is negative).
106      *
107      * Counterpart to Solidity's `-` operator.
108      *
109      * Requirements:
110      *
111      * - Subtraction cannot overflow.
112      */
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         return sub(a, b, "SafeMath: subtraction overflow");
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
128         require(b <= a, errorMessage);
129         uint256 c = a - b;
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `*` operator.
139      *
140      * Requirements:
141      *
142      * - Multiplication cannot overflow.
143      */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers. Reverts on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         return div(a, b, "SafeMath: division by zero");
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b > 0, errorMessage);
188         uint256 c = a / b;
189         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * Reverts when dividing by zero.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
207         return mod(a, b, "SafeMath: modulo by zero");
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts with custom message when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b != 0, errorMessage);
224         return a % b;
225     }
226 
227     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
228     function sqrrt(uint256 a) internal pure returns (uint c) {
229         if (a > 3) {
230             c = a;
231             uint b = add( div( a, 2), 1 );
232             while (b < c) {
233                 c = b;
234                 b = div( add( div( a, b ), b), 2 );
235             }
236         } else if (a != 0) {
237             c = 1;
238         }
239     }
240 
241     /*
242      * Expects percentage to be trailed by 00,
243     */
244     function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {
245         return div( mul( total_, percentage_ ), 1000 );
246     }
247 
248     /*
249      * Expects percentage to be trailed by 00,
250     */
251     function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {
252         return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );
253     }
254 
255     function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {
256         return div( mul(part_, 100) , total_ );
257     }
258 
259     /**
260      * Taken from Hypersonic https://github.com/M2629/HyperSonic/blob/main/Math.sol
261      * @dev Returns the average of two numbers. The result is rounded towards
262      * zero.
263      */
264     function average(uint256 a, uint256 b) internal pure returns (uint256) {
265         // (a + b) / 2 can overflow, so we distribute
266         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
267     }
268 
269     function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {
270         return sqrrt( mul( multiplier_, payment_ ) );
271     }
272 
273   function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {
274       return mul( multiplier_, supply_ );
275   }
276 }
277 
278 /**
279  * @dev Collection of functions related to the address type
280  */
281 library Address {
282     /**
283      * @dev Returns true if `account` is a contract.
284      *
285      * [IMPORTANT]
286      * ====
287      * It is unsafe to assume that an address for which this function returns
288      * false is an externally-owned account (EOA) and not a contract.
289      *
290      * Among others, `isContract` will return false for the following
291      * types of addresses:
292      *
293      *  - an externally-owned account
294      *  - a contract in construction
295      *  - an address where a contract will be created
296      *  - an address where a contract lived, but was destroyed
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // This method relies in extcodesize, which returns 0 for contracts in
301         // construction, since the code is only stored at the end of the
302         // constructor execution.
303 
304         uint256 size;
305         // solhint-disable-next-line no-inline-assembly
306         assembly { size := extcodesize(account) }
307         return size > 0;
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
330         (bool success, ) = recipient.call{ value: amount }("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain`call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353       return functionCall(target, data, "Address: low-level call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
363         return _functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     // function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
388     //     require(address(this).balance >= value, "Address: insufficient balance for call");
389     //     return _functionCallWithValue(target, data, value, errorMessage);
390     // }
391     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         require(isContract(target), "Address: call to non-contract");
394 
395         // solhint-disable-next-line avoid-low-level-calls
396         (bool success, bytes memory returndata) = target.call{ value: value }(data);
397         return _verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
401         require(isContract(target), "Address: call to non-contract");
402 
403         // solhint-disable-next-line avoid-low-level-calls
404         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
405         if (success) {
406             return returndata;
407         } else {
408             // Look for revert reason and bubble it up if present
409             if (returndata.length > 0) {
410                 // The easiest way to bubble the revert reason is using memory via assembly
411 
412                 // solhint-disable-next-line no-inline-assembly
413                 assembly {
414                     let returndata_size := mload(returndata)
415                     revert(add(32, returndata), returndata_size)
416                 }
417             } else {
418                 revert(errorMessage);
419             }
420         }
421     }
422 
423   /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
430         return functionStaticCall(target, data, "Address: low-level static call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
440         require(isContract(target), "Address: static call to non-contract");
441 
442         // solhint-disable-next-line avoid-low-level-calls
443         (bool success, bytes memory returndata) = target.staticcall(data);
444         return _verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.3._
452      */
453     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
454         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a delegate call.
460      *
461      * _Available since v3.3._
462      */
463     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
464         require(isContract(target), "Address: delegate call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = target.delegatecall(data);
468         return _verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 // solhint-disable-next-line no-inline-assembly
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 
490     function addressToString(address _address) internal pure returns(string memory) {
491         bytes32 _bytes = bytes32(uint256(_address));
492         bytes memory HEX = "0123456789abcdef";
493         bytes memory _addr = new bytes(42);
494 
495         _addr[0] = '0';
496         _addr[1] = 'x';
497 
498         for(uint256 i = 0; i < 20; i++) {
499             _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
500             _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
501         }
502 
503         return string(_addr);
504 
505     }
506 }
507 
508 /**
509  * @dev Interface of the ERC20 standard as defined in the EIP.
510  */
511 interface IERC20 {
512     /**
513      * @dev Returns the amount of tokens in existence.
514      */
515     function totalSupply() external view returns (uint256);
516 
517     /**
518      * @dev Returns the amount of tokens owned by `account`.
519      */
520     function balanceOf(address account) external view returns (uint256);
521 
522     /**
523      * @dev Moves `amount` tokens from the caller's account to `recipient`.
524      *
525      * Returns a boolean value indicating whether the operation succeeded.
526      *
527      * Emits a {Transfer} event.
528      */
529     function transfer(address recipient, uint256 amount) external returns (bool);
530 
531     /**
532      * @dev Returns the remaining number of tokens that `spender` will be
533      * allowed to spend on behalf of `owner` through {transferFrom}. This is
534      * zero by default.
535      *
536      * This value changes when {approve} or {transferFrom} are called.
537      */
538     function allowance(address owner, address spender) external view returns (uint256);
539 
540     /**
541      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
542      *
543      * Returns a boolean value indicating whether the operation succeeded.
544      *
545      * IMPORTANT: Beware that changing an allowance with this method brings the risk
546      * that someone may use both the old and the new allowance by unfortunate
547      * transaction ordering. One possible solution to mitigate this race
548      * condition is to first reduce the spender's allowance to 0 and set the
549      * desired value afterwards:
550      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
551      *
552      * Emits an {Approval} event.
553      */
554     function approve(address spender, uint256 amount) external returns (bool);
555 
556     /**
557      * @dev Moves `amount` tokens from `sender` to `recipient` using the
558      * allowance mechanism. `amount` is then deducted from the caller's
559      * allowance.
560      *
561      * Returns a boolean value indicating whether the operation succeeded.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
566 
567     /**
568      * @dev Emitted when `value` tokens are moved from one account (`from`) to
569      * another (`to`).
570      *
571      * Note that `value` may be zero.
572      */
573     event Transfer(address indexed from, address indexed to, uint256 value);
574 
575     /**
576      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
577      * a call to {approve}. `value` is the new allowance.
578      */
579     event Approval(address indexed owner, address indexed spender, uint256 value);
580 }
581 
582 contract OlympusLPStaking {
583     using SafeMath for uint256;
584     using SafeERC20 for IERC20;
585 
586     modifier onlyOwner() {
587         require(msg.sender == owner, "Owner only");
588         _;
589     }
590 
591     struct User {
592         uint256 _LPDeposited;
593         uint256 _rewardDebt;
594     }
595 
596     event StakeCompleted(address _staker, uint256 _amount, uint256 _totalStaked, uint256 _time);
597     event PoolUpdated(uint256 _blocksRewarded, uint256 _amountRewarded, uint256 _time);
598     event RewardsClaimed(address _staker, uint256 _rewardsClaimed, uint256 _time);    
599     event WithdrawCompleted(address _staker, uint256 _amount, uint256 _time);
600     event TransferredOwnership(address _previous, address _next, uint256 _time);
601 
602     IERC20 public LPToken;
603     IERC20 public OHMToken;
604 
605     address public rewardPool;
606     address public owner;
607 
608     uint256 public rewardPerBlock;
609     uint256 public accOHMPerShare;
610     uint256 public lastRewardBlock;
611     uint256 public totalStaked;
612 
613     mapping(address => User) public userDetails;
614 
615     // Constructor will set the address of OHM/ETH LP token
616     constructor(address _LPToken, address _OHMToken, address _rewardPool, uint256 _rewardPerBlock, uint _blocksToWait) {
617         LPToken = IERC20(_LPToken);
618         OHMToken = IERC20(_OHMToken);
619         rewardPool = _rewardPool;
620         lastRewardBlock = block.number.add( _blocksToWait );
621         rewardPerBlock = _rewardPerBlock;
622         accOHMPerShare;
623         owner = msg.sender;
624     }
625 
626     function transferOwnership(address _owner) external onlyOwner() returns ( bool ) {
627         address previousOwner = owner;
628         owner = _owner;
629         emit TransferredOwnership(previousOwner, owner, block.timestamp);
630 
631         return true;
632     }
633 
634     // Sets OHM reward for each block
635     function setRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner() returns ( bool ) {
636         rewardPerBlock = _rewardPerBlock;
637 
638         return true;
639     }
640 
641     // Function that will get balance of a certain stake
642     function getUserBalance(address _staker) external view returns(uint256 _amountStaked) {
643         return userDetails[_staker]._LPDeposited;
644     }
645 
646     // Function that returns User's pending rewards
647     function pendingRewards(address _staker) external view returns(uint256) {
648         User storage user = userDetails[_staker];
649 
650         uint256 _accOHMPerShare = accOHMPerShare;
651 
652         if (block.number > lastRewardBlock && totalStaked != 0) {
653             uint256 blocksToReward = block.number.sub(lastRewardBlock);
654             uint256 ohmReward = blocksToReward.mul(rewardPerBlock);
655             _accOHMPerShare = _accOHMPerShare.add(ohmReward.mul(1e18).div(totalStaked));
656         }
657 
658         return user._LPDeposited.mul(_accOHMPerShare).div(1e18).sub(user._rewardDebt);
659     }
660 
661     // Function that updates OHM/DAI LP pool
662     function updatePool() public returns ( bool ) {
663         if (block.number <= lastRewardBlock) {
664             return true;
665         }
666 
667         if (totalStaked == 0) {
668             lastRewardBlock = block.number;
669             return true;
670         }
671 
672         uint256 blocksToReward = block.number.sub(lastRewardBlock);
673         lastRewardBlock = block.number;
674 
675         uint256 ohmReward = blocksToReward.mul(rewardPerBlock);
676         accOHMPerShare = accOHMPerShare.add(ohmReward.mul(1e18).div(totalStaked));
677 
678         OHMToken.safeTransferFrom(rewardPool, address(this), ohmReward);
679 
680         emit PoolUpdated(blocksToReward, ohmReward, block.timestamp);
681 
682         return true;
683     }
684 
685     // Function that lets user stake OHM/DAI LP
686     function stakeLP(uint256 _amount) external returns ( bool ) {
687         require(_amount > 0, "Can not stake 0 LP tokens");
688 
689         updatePool();
690 
691         User storage user = userDetails[msg.sender];
692 
693         if(user._LPDeposited > 0) {
694             uint256 _pendingRewards = user._LPDeposited.mul(accOHMPerShare).div(1e18).sub(user._rewardDebt);
695 
696             if(_pendingRewards > 0) {
697                 OHMToken.safeTransfer(msg.sender, _pendingRewards);
698                 emit RewardsClaimed(msg.sender, _pendingRewards, block.timestamp);
699             }
700         }
701 
702         LPToken.safeTransferFrom(msg.sender, address(this), _amount);
703         user._LPDeposited = user._LPDeposited.add(_amount);
704         totalStaked = totalStaked.add(_amount);
705 
706         user._rewardDebt = user._LPDeposited.mul(accOHMPerShare).div(1e18);
707 
708         emit StakeCompleted(msg.sender, _amount, user._LPDeposited, block.timestamp);
709 
710         return true;
711 
712     }
713 
714     // Function that will allow user to claim rewards
715     function claimRewards() external returns ( bool ) {
716         updatePool();
717 
718         User storage user = userDetails[msg.sender];
719 
720         uint256 _pendingRewards = user._LPDeposited.mul(accOHMPerShare).div(1e18).sub(user._rewardDebt);
721         user._rewardDebt = user._LPDeposited.mul(accOHMPerShare).div(1e18);
722         
723         require(_pendingRewards > 0, "No rewards to claim!");
724 
725         OHMToken.safeTransfer(msg.sender, _pendingRewards);
726 
727         emit RewardsClaimed(msg.sender, _pendingRewards, block.timestamp);
728 
729         return true;
730     }
731 
732     // Function that lets user unstake OHM/DAI LP in system
733     function unstakeLP() external returns ( bool ) {        
734 
735         updatePool();
736 
737         User storage user = userDetails[msg.sender];
738         require(user._LPDeposited > 0, "User has no stake");
739 
740         uint256 _pendingRewards = user._LPDeposited.mul(accOHMPerShare).div(1e18).sub(user._rewardDebt);
741 
742         uint256 beingWithdrawn = user._LPDeposited;
743 
744         user._LPDeposited = 0;
745         user._rewardDebt = 0;
746 
747         totalStaked = totalStaked.sub(beingWithdrawn);
748 
749         LPToken.safeTransfer(msg.sender, beingWithdrawn);
750         OHMToken.safeTransfer(msg.sender, _pendingRewards);
751 
752         emit WithdrawCompleted(msg.sender, beingWithdrawn, block.timestamp);
753         emit RewardsClaimed(msg.sender, _pendingRewards, block.timestamp);
754 
755         return true;
756     }
757 
758 }