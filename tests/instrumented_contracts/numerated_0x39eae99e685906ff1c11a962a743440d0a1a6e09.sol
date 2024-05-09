1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @title SafeERC20
81  * @dev Wrappers around ERC20 operations that throw on failure (when the token
82  * contract returns false). Tokens that return no value (and instead revert or
83  * throw on failure) are also supported, non-reverting calls are assumed to be
84  * successful.
85  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
86  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
87  */
88 library SafeERC20 {
89     using SafeMath for uint256;
90     using Address for address;
91 
92     function safeTransfer(IERC20 token, address to, uint256 value) internal {
93         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
94     }
95 
96     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
97         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
98     }
99 
100     /**
101      * @dev Deprecated. This function has issues similar to the ones found in
102      * {IERC20-approve}, and its usage is discouraged.
103      *
104      * Whenever possible, use {safeIncreaseAllowance} and
105      * {safeDecreaseAllowance} instead.
106      */
107     function safeApprove(IERC20 token, address spender, uint256 value) internal {
108         // safeApprove should only be called when setting an initial allowance,
109         // or when resetting it to zero. To increase and decrease it, use
110         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
111         // solhint-disable-next-line max-line-length
112         require((value == 0) || (token.allowance(address(this), spender) == 0),
113             "SafeERC20: approve from non-zero to non-zero allowance"
114         );
115         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
116     }
117 
118     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
119         uint256 newAllowance = token.allowance(address(this), spender).add(value);
120         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
121     }
122 
123     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
124         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
125         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
126     }
127 
128     /**
129      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
130      * on the return value: the return value is optional (but if data is returned, it must not be false).
131      * @param token The token targeted by the call.
132      * @param data The call data (encoded using abi.encode or one of its variants).
133      */
134     function _callOptionalReturn(IERC20 token, bytes memory data) private {
135         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
136         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
137         // the target address contains contract code and also asserts for success in the low-level call.
138 
139         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
140         if (returndata.length > 0) { // Return data is optional
141             // solhint-disable-next-line max-line-length
142             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
143         }
144     }
145 }
146 
147 
148 /**
149  * @dev Wrappers over Solidity's arithmetic operations with added overflow
150  * checks.
151  *
152  * Arithmetic operations in Solidity wrap on overflow. This can easily result
153  * in bugs, because programmers usually assume that an overflow raises an
154  * error, which is the standard behavior in high level programming languages.
155  * `SafeMath` restores this intuition by reverting the transaction when an
156  * operation overflows.
157  *
158  * Using this library instead of the unchecked operations eliminates an entire
159  * class of bugs, so it's recommended to use it always.
160  */
161 library SafeMath {
162     /**
163      * @dev Returns the addition of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `+` operator.
167      *
168      * Requirements:
169      *
170      * - Addition cannot overflow.
171      */
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         uint256 c = a + b;
174         require(c >= a, "SafeMath: addition overflow");
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the subtraction of two unsigned integers, reverting on
181      * overflow (when the result is negative).
182      *
183      * Counterpart to Solidity's `-` operator.
184      *
185      * Requirements:
186      *
187      * - Subtraction cannot overflow.
188      */
189     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190         return sub(a, b, "SafeMath: subtraction overflow");
191     }
192 
193     /**
194      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
195      * overflow (when the result is negative).
196      *
197      * Counterpart to Solidity's `-` operator.
198      *
199      * Requirements:
200      *
201      * - Subtraction cannot overflow.
202      */
203     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         require(b <= a, errorMessage);
205         uint256 c = a - b;
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the multiplication of two unsigned integers, reverting on
212      * overflow.
213      *
214      * Counterpart to Solidity's `*` operator.
215      *
216      * Requirements:
217      *
218      * - Multiplication cannot overflow.
219      */
220     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
221         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
222         // benefit is lost if 'b' is also tested.
223         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
224         if (a == 0) {
225             return 0;
226         }
227 
228         uint256 c = a * b;
229         require(c / a == b, "SafeMath: multiplication overflow");
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the integer division of two unsigned integers. Reverts on
236      * division by zero. The result is rounded towards zero.
237      *
238      * Counterpart to Solidity's `/` operator. Note: this function uses a
239      * `revert` opcode (which leaves remaining gas untouched) while Solidity
240      * uses an invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function div(uint256 a, uint256 b) internal pure returns (uint256) {
247         return div(a, b, "SafeMath: division by zero");
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator. Note: this function uses a
255      * `revert` opcode (which leaves remaining gas untouched) while Solidity
256      * uses an invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b > 0, errorMessage);
264         uint256 c = a / b;
265         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * Reverts when dividing by zero.
273      *
274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
275      * opcode (which leaves remaining gas untouched) while Solidity uses an
276      * invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
283         return mod(a, b, "SafeMath: modulo by zero");
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
288      * Reverts with custom message when dividing by zero.
289      *
290      * Counterpart to Solidity's `%` operator. This function uses a `revert`
291      * opcode (which leaves remaining gas untouched) while Solidity uses an
292      * invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         require(b != 0, errorMessage);
300         return a % b;
301     }
302 }
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies in extcodesize, which returns 0 for contracts in
327         // construction, since the code is only stored at the end of the
328         // constructor execution.
329 
330         uint256 size;
331         // solhint-disable-next-line no-inline-assembly
332         assembly { size := extcodesize(account) }
333         return size > 0;
334     }
335 
336     /**
337      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
338      * `recipient`, forwarding all available gas and reverting on errors.
339      *
340      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
341      * of certain opcodes, possibly making contracts go over the 2300 gas limit
342      * imposed by `transfer`, making them unable to receive funds via
343      * `transfer`. {sendValue} removes this limitation.
344      *
345      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
346      *
347      * IMPORTANT: because control is transferred to `recipient`, care must be
348      * taken to not create reentrancy vulnerabilities. Consider using
349      * {ReentrancyGuard} or the
350      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
351      */
352     function sendValue(address payable recipient, uint256 amount) internal {
353         require(address(this).balance >= amount, "Address: insufficient balance");
354 
355         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
356         (bool success, ) = recipient.call{ value: amount }("");
357         require(success, "Address: unable to send value, recipient may have reverted");
358     }
359 
360     /**
361      * @dev Performs a Solidity function call using a low level `call`. A
362      * plain`call` is an unsafe replacement for a function call: use this
363      * function instead.
364      *
365      * If `target` reverts with a revert reason, it is bubbled up by this
366      * function (like regular Solidity function calls).
367      *
368      * Returns the raw returned data. To convert to the expected return value,
369      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370      *
371      * Requirements:
372      *
373      * - `target` must be a contract.
374      * - calling `target` with `data` must not revert.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
379       return functionCall(target, data, "Address: low-level call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
384      * `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
389         return _functionCallWithValue(target, data, 0, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but also transferring `value` wei to `target`.
395      *
396      * Requirements:
397      *
398      * - the calling contract must have an ETH balance of at least `value`.
399      * - the called Solidity function must be `payable`.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
414         require(address(this).balance >= value, "Address: insufficient balance for call");
415         return _functionCallWithValue(target, data, value, errorMessage);
416     }
417 
418     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
419         require(isContract(target), "Address: call to non-contract");
420 
421         // solhint-disable-next-line avoid-low-level-calls
422         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
423         if (success) {
424             return returndata;
425         } else {
426             // Look for revert reason and bubble it up if present
427             if (returndata.length > 0) {
428                 // The easiest way to bubble the revert reason is using memory via assembly
429 
430                 // solhint-disable-next-line no-inline-assembly
431                 assembly {
432                     let returndata_size := mload(returndata)
433                     revert(add(32, returndata), returndata_size)
434                 }
435             } else {
436                 revert(errorMessage);
437             }
438         }
439     }
440 }
441 
442 /*
443  * @dev Provides information about the current execution context, including the
444  * sender of the transaction and its data. While these are generally available
445  * via msg.sender and msg.data, they should not be accessed in such a direct
446  * manner, since when dealing with GSN meta-transactions the account sending and
447  * paying for execution may not be the actual sender (as far as an application
448  * is concerned).
449  *
450  * This contract is only required for intermediate, library-like contracts.
451  */
452 abstract contract Context {
453     function _msgSender() internal view virtual returns (address payable) {
454         return msg.sender;
455     }
456 
457     function _msgData() internal view virtual returns (bytes memory) {
458         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
459         return msg.data;
460     }
461 }
462 
463 /**
464  * @dev Contract module which provides a basic access control mechanism, where
465  * there is an account (an owner) that can be granted exclusive access to
466  * specific functions.
467  *
468  * By default, the owner account will be the one that deploys the contract. This
469  * can later be changed with {transferOwnership}.
470  *
471  * This module is used through inheritance. It will make available the modifier
472  * `onlyOwner`, which can be applied to your functions to restrict their use to
473  * the owner.
474  */
475 contract Ownable is Context {
476     address private _owner;
477 
478     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
479 
480     /**
481      * @dev Initializes the contract setting the deployer as the initial owner.
482      */
483     constructor () internal {
484         address msgSender = _msgSender();
485         _owner = msgSender;
486         emit OwnershipTransferred(address(0), msgSender);
487     }
488 
489     /**
490      * @dev Returns the address of the current owner.
491      */
492     function owner() public view returns (address) {
493         return _owner;
494     }
495 
496     /**
497      * @dev Throws if called by any account other than the owner.
498      */
499     modifier onlyOwner() {
500         require(_owner == _msgSender(), "Ownable: caller is not the owner");
501         _;
502     }
503 
504     /**
505      * @dev Leaves the contract without owner. It will not be possible to call
506      * `onlyOwner` functions anymore. Can only be called by the current owner.
507      *
508      * NOTE: Renouncing ownership will leave the contract without an owner,
509      * thereby removing any functionality that is only available to the owner.
510      */
511     function renounceOwnership() public virtual onlyOwner {
512         emit OwnershipTransferred(_owner, address(0));
513         _owner = address(0);
514     }
515 
516     /**
517      * @dev Transfers ownership of the contract to a new account (`newOwner`).
518      * Can only be called by the current owner.
519      */
520     function transferOwnership(address newOwner) public virtual onlyOwner {
521         require(newOwner != address(0), "Ownable: new owner is the zero address");
522         emit OwnershipTransferred(_owner, newOwner);
523         _owner = newOwner;
524     }
525 }
526 
527 /**
528  * @dev A token holder contract that will allow a beneficiary to extract the
529  * tokens after a given release time.
530  *
531  * Useful for simple vesting schedules like "advisors get all of their tokens
532  * after 1 year".
533  */
534 contract TokenTimelock {
535     using SafeERC20 for IERC20;
536 
537     // ERC20 basic token contract being held
538     IERC20 private _token;
539 
540     // beneficiary of tokens after they are released
541     address private _beneficiary;
542 
543     // timestamp when token release is enabled
544     uint256 private _releaseTime;
545 
546     constructor (IERC20 token, address beneficiary, uint256 releaseTime) public {
547         // solhint-disable-next-line not-rely-on-time
548         require(releaseTime > block.timestamp, "TokenTimelock: release time is before current time");
549         _token = token;
550         _beneficiary = beneficiary;
551         _releaseTime = releaseTime;
552     }
553 
554     /**
555      * @return the token being held.
556      */
557     function token() public view returns (IERC20) {
558         return _token;
559     }
560 
561     /**
562      * @return the beneficiary of the tokens.
563      */
564     function beneficiary() public view returns (address) {
565         return _beneficiary;
566     }
567 
568     /**
569      * @return the time when the tokens are released.
570      */
571     function releaseTime() public view returns (uint256) {
572         return _releaseTime;
573     }
574 
575     /**
576      * @notice Transfers tokens held by timelock to beneficiary.
577      */
578     function release() public virtual {
579         // solhint-disable-next-line not-rely-on-time
580         require(block.timestamp >= _releaseTime, "TokenTimelock: current time is before release time");
581 
582         uint256 amount = _token.balanceOf(address(this));
583         require(amount > 0, "TokenTimelock: no tokens to release");
584 
585         _token.safeTransfer(_beneficiary, amount);
586     }
587 }
588 
589 
590 /**
591  * @dev A token holder contract that will allow a beneficiary to extract the
592  * tokens by portions based on a metric (TVL)
593  *
594  * This is ported from openzeppelin-ethereum-package
595  *
596  * Currently the holder contract is Ownable (while the owner is current beneficiary)
597  * still, this allows to check the method calls in blockchain to verify fair play.
598  * In the future it will be possible to use automated calculation, e.g. using
599  * https://github.com/ConcourseOpen/DeFi-Pulse-Adapters TVL calculation, then
600  * ownership would be transferred to the managing contract.
601  */
602 contract HolderTVLLock is Ownable {
603     using SafeMath for uint256;
604     using SafeERC20 for IERC20;
605 
606     uint256 private constant RELEASE_PERCENT = 2;
607     uint256 private constant RELEASE_INTERVAL = 1 weeks;
608 
609     // ERC20 basic token contract being held
610     IERC20 private _token;
611 
612     // beneficiary of tokens after they are released
613     address private _beneficiary;
614 
615     // timestamp when token release was made last time
616     uint256 private _lastReleaseTime;
617 
618     // timestamp of first possible release time
619     uint256 private _firstReleaseTime;
620 
621     // TVL metric for last release time
622     uint256 private _lastReleaseTVL;
623 
624     // amount that already was released
625     uint256 private _released;
626 
627     event TVLReleasePerformed(uint256 newTVL);
628 
629     constructor (IERC20 token, address beneficiary, uint256 firstReleaseTime) public {
630         //as contract is deployed by Holyheld token, transfer ownership to dev
631         transferOwnership(beneficiary);
632 
633         // solhint-disable-next-line not-rely-on-time
634         require(firstReleaseTime > block.timestamp, "release time before current time");
635         _token = token;
636         _beneficiary = beneficiary;
637         _firstReleaseTime = firstReleaseTime;
638     }
639 
640     /**
641      * @return the token being held.
642      */
643     function token() public view returns (IERC20) {
644         return _token;
645     }
646 
647     /**
648      * @return the beneficiary of the tokens.
649      */
650     function beneficiary() public view returns (address) {
651         return _beneficiary;
652     }
653 
654     /**
655      * @return the time when the tokens were released last time.
656      */
657     function lastReleaseTime() public view returns (uint256) {
658         return _lastReleaseTime;
659     }
660 
661     /**
662      * @return the TVL marked when the tokens were released last time.
663      */
664     function lastReleaseTVL() public view returns (uint256) {
665         return _lastReleaseTVL;
666     }
667 
668     /**
669      * @notice Transfers tokens held by timelock to beneficiary.
670      * only owner can call this method as it will write new TVL metric value
671      * into the holder contract
672      */
673     function release(uint256 _newTVL) public onlyOwner {
674         // solhint-disable-next-line not-rely-on-time
675         require(block.timestamp >= _firstReleaseTime, "current time before release time");
676         require(block.timestamp > _lastReleaseTime + RELEASE_INTERVAL, "release interval is not passed");
677         require(_newTVL > _lastReleaseTVL, "only release if TVL is higher");
678 
679         // calculate amount that is possible to release
680         uint256 balance = _token.balanceOf(address(this));
681         uint256 totalBalance = balance.add(_released);
682 
683         uint256 amount = totalBalance.mul(RELEASE_PERCENT).div(100);
684         require(balance > amount, "available balance depleted");
685 
686         _token.safeTransfer(_beneficiary, amount);
687 	    _lastReleaseTime = block.timestamp;
688 	    _lastReleaseTVL = _newTVL;
689 	    _released = _released.add(amount);
690 
691         emit TVLReleasePerformed(_newTVL);
692     }
693 }
694 
695 
696 
697 
698 
699 
700 
701 
702 /**
703  * @title TokenVesting
704  * @dev A token holder contract that can release its token balance gradually like a
705  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
706  * owner.
707  */
708 contract HolderVesting is Ownable {
709     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
710     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
711     // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a
712     // cliff period of a year and a duration of four years, are safe to use.
713     // solhint-disable not-rely-on-time
714 
715     using SafeMath for uint256;
716     using SafeERC20 for IERC20;
717 
718     uint256 private constant RELEASE_INTERVAL = 1 weeks;
719 
720     event TokensReleased(address token, uint256 amount);
721     event TokenVestingRevoked(address token);
722 
723     // beneficiary of tokens after they are released
724     address private _beneficiary;
725 
726     // ERC20 basic token contract being held
727     IERC20 private _token;
728 
729     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
730     uint256 private _start;
731     uint256 private _duration;
732 
733     // timestamp when token release was made last time
734     uint256 private _lastReleaseTime;
735 
736     bool private _revocable;
737 
738     uint256 private _released;
739     bool private _revoked;
740 
741     /**
742      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
743      * beneficiary, gradually in a linear fashion until start + duration. By then all
744      * of the balance will have vested.
745      * @param beneficiary address of the beneficiary to whom vested tokens are transferred
746      * @param start the time (as Unix time) at which point vesting starts
747      * @param duration duration in seconds of the period in which the tokens will vest
748      * @param revocable whether the vesting is revocable or not
749      */
750     constructor(IERC20 token, address beneficiary, uint256 start, uint256 duration, bool revocable) public {
751 
752         require(beneficiary != address(0), "beneficiary is zero address");
753         require(duration > 0, "duration is 0");
754         // solhint-disable-next-line max-line-length
755         require(start.add(duration) > block.timestamp, "final time before current time");
756 
757         _token = token;
758         
759         _beneficiary = beneficiary;
760         //as contract is deployed by Holyheld token, transfer ownership to dev
761         transferOwnership(beneficiary);
762 
763         _revocable = revocable;
764         _duration = duration;
765         _start = start;
766     }
767 
768     /**
769      * @return the beneficiary of the tokens.
770      */
771     function beneficiary() public view returns (address) {
772         return _beneficiary;
773     }
774 
775     /**
776      * @return the start time of the token vesting.
777      */
778     function start() public view returns (uint256) {
779         return _start;
780     }
781 
782     /**
783      * @return the duration of the token vesting.
784      */
785     function duration() public view returns (uint256) {
786         return _duration;
787     }
788 
789     /**
790      * @return true if the vesting is revocable.
791      */
792     function revocable() public view returns (bool) {
793         return _revocable;
794     }
795 
796     /**
797      * @return the amount of the token released.
798      */
799     function released() public view returns (uint256) {
800         return _released;
801     }
802 
803     /**
804      * @return true if the token is revoked.
805      */
806     function revoked() public view returns (bool) {
807         return _revoked;
808     }
809 
810     /**
811      * @return the time when the tokens were released last time.
812      */
813     function lastReleaseTime() public view returns (uint256) {
814         return _lastReleaseTime;
815     }
816 
817     /**
818      * @notice Transfers vested tokens to beneficiary.
819      */
820     function release() public {
821         uint256 unreleased = _releasableAmount();
822 
823         require(unreleased > 0, "no tokens are due");
824         require(block.timestamp > _lastReleaseTime + RELEASE_INTERVAL, "release interval is not passed");
825 
826         _released = _released.add(unreleased);
827 
828         _token.safeTransfer(_beneficiary, unreleased);
829         _lastReleaseTime = block.timestamp;
830 
831         emit TokensReleased(address(_token), unreleased);
832     }
833 
834     /**
835      * @notice Allows the owner to revoke the vesting. Tokens already vested
836      * remain in the contract, the rest are returned to the owner.
837      */
838     function revoke() public onlyOwner {
839         require(_revocable, "cannot revoke");
840         require(!_revoked, "vesting already revoked");
841 
842         uint256 balance = _token.balanceOf(address(this));
843 
844         uint256 unreleased = _releasableAmount();
845         uint256 refund = balance.sub(unreleased);
846 
847         _revoked = true;
848 
849         _token.safeTransfer(owner(), refund);
850 
851         emit TokenVestingRevoked(address(_token));
852     }
853 
854     /**
855      * @dev Calculates the amount that has already vested but hasn't been released yet.
856      */
857     function _releasableAmount() private view returns (uint256) {
858         return _vestedAmount().sub(_released);
859     }
860 
861     /**
862      * @dev Calculates the amount that has already vested.
863      */
864     function _vestedAmount() private view returns (uint256) {
865         uint256 currentBalance = _token.balanceOf(address(this));
866         uint256 totalBalance = currentBalance.add(_released);
867 
868         if (block.timestamp < _start) {
869             return 0;
870         } else if (block.timestamp >= _start.add(_duration) || _revoked) {
871             return totalBalance;
872         } else {
873             return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
874         }
875     }
876 }
877 
878 
879 
880 
881 
882 
883 
884 
885 
886 
887 
888 
889 
890 
891 // Interface to represent a contract in pools that requires additional
892 // deposit and withdraw of LP tokens. One of the examples at the time of writing
893 // is Yearn vault, which takes yCRV which is already LP token and returns yyCRV 
894 interface Stakeable {
895     function deposit(uint) external;
896     function withdraw(uint) external;
897 }
898 
899 
900 
901 
902 
903 
904 
905 
906 
907 
908 
909 
910 
911 /**
912  * @dev Implementation of the {IERC20} interface.
913  *
914  * This implementation is agnostic to the way tokens are created. This means
915  * that a supply mechanism has to be added in a derived contract using {_mint}.
916  * For a generic mechanism see {ERC20PresetMinterPauser}.
917  *
918  * TIP: For a detailed writeup see our guide
919  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
920  * to implement supply mechanisms].
921  *
922  * We have followed general OpenZeppelin guidelines: functions revert instead
923  * of returning `false` on failure. This behavior is nonetheless conventional
924  * and does not conflict with the expectations of ERC20 applications.
925  *
926  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
927  * This allows applications to reconstruct the allowance for all accounts just
928  * by listening to said events. Other implementations of the EIP may not emit
929  * these events, as it isn't required by the specification.
930  *
931  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
932  * functions have been added to mitigate the well-known issues around setting
933  * allowances. See {IERC20-approve}.
934  */
935 contract ERC20 is Context, IERC20 {
936     using SafeMath for uint256;
937     using Address for address;
938 
939     mapping (address => uint256) private _balances;
940 
941     mapping (address => mapping (address => uint256)) private _allowances;
942 
943     uint256 private _totalSupply;
944 
945     string private _name;
946     string private _symbol;
947     uint8 private _decimals;
948 
949     /**
950      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
951      * a default value of 18.
952      *
953      * To select a different value for {decimals}, use {_setupDecimals}.
954      *
955      * All three of these values are immutable: they can only be set once during
956      * construction.
957      */
958     constructor (string memory name, string memory symbol) public {
959         _name = name;
960         _symbol = symbol;
961         _decimals = 18;
962     }
963 
964     /**
965      * @dev Returns the name of the token.
966      */
967     function name() public view returns (string memory) {
968         return _name;
969     }
970 
971     /**
972      * @dev Returns the symbol of the token, usually a shorter version of the
973      * name.
974      */
975     function symbol() public view returns (string memory) {
976         return _symbol;
977     }
978 
979     /**
980      * @dev Returns the number of decimals used to get its user representation.
981      * For example, if `decimals` equals `2`, a balance of `505` tokens should
982      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
983      *
984      * Tokens usually opt for a value of 18, imitating the relationship between
985      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
986      * called.
987      *
988      * NOTE: This information is only used for _display_ purposes: it in
989      * no way affects any of the arithmetic of the contract, including
990      * {IERC20-balanceOf} and {IERC20-transfer}.
991      */
992     function decimals() public view returns (uint8) {
993         return _decimals;
994     }
995 
996     /**
997      * @dev See {IERC20-totalSupply}.
998      */
999     function totalSupply() public view override returns (uint256) {
1000         return _totalSupply;
1001     }
1002 
1003     /**
1004      * @dev See {IERC20-balanceOf}.
1005      */
1006     function balanceOf(address account) public view override returns (uint256) {
1007         return _balances[account];
1008     }
1009 
1010     /**
1011      * @dev See {IERC20-transfer}.
1012      *
1013      * Requirements:
1014      *
1015      * - `recipient` cannot be the zero address.
1016      * - the caller must have a balance of at least `amount`.
1017      */
1018     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1019         _transfer(_msgSender(), recipient, amount);
1020         return true;
1021     }
1022 
1023     /**
1024      * @dev See {IERC20-allowance}.
1025      */
1026     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1027         return _allowances[owner][spender];
1028     }
1029 
1030     /**
1031      * @dev See {IERC20-approve}.
1032      *
1033      * Requirements:
1034      *
1035      * - `spender` cannot be the zero address.
1036      */
1037     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1038         _approve(_msgSender(), spender, amount);
1039         return true;
1040     }
1041 
1042     /**
1043      * @dev See {IERC20-transferFrom}.
1044      *
1045      * Emits an {Approval} event indicating the updated allowance. This is not
1046      * required by the EIP. See the note at the beginning of {ERC20};
1047      *
1048      * Requirements:
1049      * - `sender` and `recipient` cannot be the zero address.
1050      * - `sender` must have a balance of at least `amount`.
1051      * - the caller must have allowance for ``sender``'s tokens of at least
1052      * `amount`.
1053      */
1054     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1055         _transfer(sender, recipient, amount);
1056         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1057         return true;
1058     }
1059 
1060     /**
1061      * @dev Atomically increases the allowance granted to `spender` by the caller.
1062      *
1063      * This is an alternative to {approve} that can be used as a mitigation for
1064      * problems described in {IERC20-approve}.
1065      *
1066      * Emits an {Approval} event indicating the updated allowance.
1067      *
1068      * Requirements:
1069      *
1070      * - `spender` cannot be the zero address.
1071      */
1072     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1073         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1074         return true;
1075     }
1076 
1077     /**
1078      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1079      *
1080      * This is an alternative to {approve} that can be used as a mitigation for
1081      * problems described in {IERC20-approve}.
1082      *
1083      * Emits an {Approval} event indicating the updated allowance.
1084      *
1085      * Requirements:
1086      *
1087      * - `spender` cannot be the zero address.
1088      * - `spender` must have allowance for the caller of at least
1089      * `subtractedValue`.
1090      */
1091     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1092         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1093         return true;
1094     }
1095 
1096     /**
1097      * @dev Moves tokens `amount` from `sender` to `recipient`.
1098      *
1099      * This is internal function is equivalent to {transfer}, and can be used to
1100      * e.g. implement automatic token fees, slashing mechanisms, etc.
1101      *
1102      * Emits a {Transfer} event.
1103      *
1104      * Requirements:
1105      *
1106      * - `sender` cannot be the zero address.
1107      * - `recipient` cannot be the zero address.
1108      * - `sender` must have a balance of at least `amount`.
1109      */
1110     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1111         require(sender != address(0), "ERC20: transfer from the zero address");
1112         require(recipient != address(0), "ERC20: transfer to the zero address");
1113 
1114         _beforeTokenTransfer(sender, recipient, amount);
1115 
1116         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1117         _balances[recipient] = _balances[recipient].add(amount);
1118         emit Transfer(sender, recipient, amount);
1119     }
1120 
1121     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1122      * the total supply.
1123      *
1124      * Emits a {Transfer} event with `from` set to the zero address.
1125      *
1126      * Requirements
1127      *
1128      * - `to` cannot be the zero address.
1129      */
1130     function _mint(address account, uint256 amount) internal virtual {
1131         require(account != address(0), "ERC20: mint to the zero address");
1132 
1133         _beforeTokenTransfer(address(0), account, amount);
1134 
1135         _totalSupply = _totalSupply.add(amount);
1136         _balances[account] = _balances[account].add(amount);
1137         emit Transfer(address(0), account, amount);
1138     }
1139 
1140     /**
1141      * @dev Destroys `amount` tokens from `account`, reducing the
1142      * total supply.
1143      *
1144      * Emits a {Transfer} event with `to` set to the zero address.
1145      *
1146      * Requirements
1147      *
1148      * - `account` cannot be the zero address.
1149      * - `account` must have at least `amount` tokens.
1150      */
1151     function _burn(address account, uint256 amount) internal virtual {
1152         require(account != address(0), "ERC20: burn from the zero address");
1153 
1154         _beforeTokenTransfer(account, address(0), amount);
1155 
1156         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1157         _totalSupply = _totalSupply.sub(amount);
1158         emit Transfer(account, address(0), amount);
1159     }
1160 
1161     /**
1162      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1163      *
1164      * This internal function is equivalent to `approve`, and can be used to
1165      * e.g. set automatic allowances for certain subsystems, etc.
1166      *
1167      * Emits an {Approval} event.
1168      *
1169      * Requirements:
1170      *
1171      * - `owner` cannot be the zero address.
1172      * - `spender` cannot be the zero address.
1173      */
1174     function _approve(address owner, address spender, uint256 amount) internal virtual {
1175         require(owner != address(0), "ERC20: approve from the zero address");
1176         require(spender != address(0), "ERC20: approve to the zero address");
1177 
1178         _allowances[owner][spender] = amount;
1179         emit Approval(owner, spender, amount);
1180     }
1181 
1182     /**
1183      * @dev Sets {decimals} to a value other than the default one of 18.
1184      *
1185      * WARNING: This function should only be called from the constructor. Most
1186      * applications that interact with token contracts will not expect
1187      * {decimals} to ever change, and may work incorrectly if it does.
1188      */
1189     function _setupDecimals(uint8 decimals_) internal {
1190         _decimals = decimals_;
1191     }
1192 
1193     /**
1194      * @dev Hook that is called before any transfer of tokens. This includes
1195      * minting and burning.
1196      *
1197      * Calling conditions:
1198      *
1199      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1200      * will be to transferred to `to`.
1201      * - when `from` is zero, `amount` tokens will be minted for `to`.
1202      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1203      * - `from` and `to` are never both zero.
1204      *
1205      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1206      */
1207     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1208 }
1209 
1210 /**
1211  * @dev // Holyheld token is a ERC20 token for Holyheld.
1212  *
1213  * total amount is fixed at 100M HOLY tokens.
1214  * HOLY token does not have mint functions.
1215  * It will allocate upon creation the initial transfers
1216  * of tokens. It is not ownable or having any other
1217  * means of distribution other than transfers in its constructor. 
1218  */
1219 // HolyToken. Ownable, fixed-amount (non-mintable) with governance to be added
1220 contract HolyToken is ERC20("Holyheld", "HOLY") {
1221 
1222     // main developers (founders) multi-sig wallet
1223     // 1 mln tokens
1224     address public founder;
1225 
1226     // Treasury
1227     // accumulates LP yield
1228     address public treasury;
1229 
1230     // weekly vested supply, reclaimable by 2% in a week by founder (WeeklyVested contract)
1231     // 9 mln
1232     address public timeVestedSupply;
1233 
1234     // TVL-growth vested supply, reclaimable by 2% in a week if TVL is a new ATH (TVLVested contract)
1235     // 10 mln
1236     address public growthVestedSupply;
1237 
1238     // main supply, locked for 4 months (TimeVested contract)
1239     // 56 mln
1240     address public mainSupply;
1241     
1242     // Pool supply (ruled by HolyKnight contract)
1243     // 24 mln
1244     address public poolSupply;
1245 
1246     uint public constant AMOUNT_INITLIQUIDITY = 1000000 * 1e18;
1247     uint public constant AMOUNT_OPERATIONS = 9000000 * 1e18;
1248     uint public constant AMOUNT_TEAM = 10000000 * 1e18;
1249     uint public constant DISTRIBUTION_SUPPLY = 24000000 * 1e18;
1250     uint public constant DISTRIBUTION_RESERVE_PERCENT = 20;
1251     uint public constant MAIN_SUPPLY = 56000000 * 1e18;
1252 
1253     uint public constant MAIN_SUPPLY_VESTING_PERIOD = 127 days;
1254     uint public constant VESTING_START = 1602115200; //8 Oct 2020
1255     uint public constant VESTING_START_GROWTH = 1604188800; //1 Nov 2020
1256 
1257     // parameters for HolyKnight construction
1258     uint public constant START_LP_BLOCK = 10950946;
1259     // used for tokens per block calculation to distribute in about 4 months
1260     uint public constant END_LP_BLOCK = 11669960;
1261 
1262     // Constructor code is only run when the contract
1263     // is created
1264     constructor(address _founder, address _treasuryaddr) public {
1265         founder = _founder;	  //address that deployed contract becomes initial founder
1266         treasury = _treasuryaddr; //treasury address is created beforehand
1267 
1268         // Timelock contract will hold main supply for 4 months till Jan 2021
1269 	    mainSupply = address(new HolderTimelock(this, founder, block.timestamp + MAIN_SUPPLY_VESTING_PERIOD));
1270 
1271         // TVL metric based vesting
1272 	    growthVestedSupply = address(new HolderTVLLock(this, founder, VESTING_START_GROWTH));
1273 
1274         // Standard continuous vesting contract
1275 	    timeVestedSupply = address(new HolderVesting(this, founder, VESTING_START, 365 days, false));
1276 
1277         // HOLY token distribution though liquidity mining
1278 	    poolSupply = address(new HolyKnight(this, founder, treasury, DISTRIBUTION_SUPPLY, DISTRIBUTION_RESERVE_PERCENT, START_LP_BLOCK, END_LP_BLOCK));
1279 
1280         //allocate tokens to addresses upon creation, no further minting possible
1281 	    _mint(founder, AMOUNT_INITLIQUIDITY);
1282 	    _mint(timeVestedSupply, AMOUNT_OPERATIONS);
1283 	    _mint(growthVestedSupply, AMOUNT_TEAM);
1284 	    _mint(poolSupply, DISTRIBUTION_SUPPLY);
1285 	    _mint(mainSupply, MAIN_SUPPLY); 
1286     }
1287 }
1288 
1289 
1290 /**
1291  * @dev // HolyKnight is using LP to distribute Holyheld token
1292  *
1293  * it does not mint any HOLY tokens, they must be present on the
1294  * contract's token balance. Balance is not intended to be refillable.
1295  *
1296  * Note that it's ownable and the owner wields tremendous power. The ownership
1297  * will be transferred to a governance smart contract once HOLY is sufficiently
1298  * distributed and the community can show to govern itself.
1299  *
1300  * Have fun reading it. Hopefully it's bug-free. God bless.
1301  */
1302 contract HolyKnight is Ownable {
1303     using SafeMath for uint256;
1304     using SafeERC20 for IERC20;
1305 
1306     // Info of each user
1307     struct UserInfo {
1308         uint256 amount;     // How many LP tokens the user has provided.
1309         uint256 rewardDebt; // Reward debt. See explanation below.
1310         //
1311         // We do some fancy math here. Basically, any point in time, the amount of HOLYs
1312         // entitled to a user but is pending to be distributed is:
1313         //
1314         //   pending reward = (user.amount * pool.accHolyPerShare) - user.rewardDebt
1315         //
1316         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1317         //   1. The pool's `accHolyPerShare` (and `lastRewardCalcBlock`) gets updated.
1318         //   2. User receives the pending reward sent to his/her address.
1319         //   3. User's `amount` gets updated.
1320         //   4. User's `rewardDebt` gets updated.
1321         // Thus every change in pool or allocation will result in recalculation of values
1322         // (otherwise distribution remains constant btwn blocks and will be properly calculated)
1323         uint256 stakedLPAmount;
1324     }
1325 
1326     // Info of each pool
1327     struct PoolInfo {
1328         IERC20 lpToken;              // Address of LP token contract
1329         uint256 allocPoint;          // How many allocation points assigned to this pool. HOLYs to distribute per block
1330         uint256 lastRewardCalcBlock; // Last block number for which HOLYs distribution is already calculated for the pool
1331         uint256 accHolyPerShare;     // Accumulated HOLYs per share, times 1e12. See below
1332         bool    stakeable;         // we should call deposit method on the LP tokens provided (used for e.g. vault staking)
1333         address stakeableContract;     // location where to deposit LP tokens if pool is stakeable
1334         IERC20  stakedHoldableToken;
1335     }
1336 
1337     // The Holyheld token
1338     HolyToken public holytoken;
1339     // Dev address
1340     address public devaddr;
1341     // Treasury address
1342     address public treasuryaddr;
1343 
1344     // The block number when HOLY mining starts
1345     uint256 public startBlock;
1346     // The block number when HOLY mining targeted to end (if full allocation).
1347     // used only for token distribution calculation, this is not a hard limit
1348     uint256 public targetEndBlock;
1349 
1350     // Total amount of tokens to distribute
1351     uint256 public totalSupply;
1352     // Reserved percent of HOLY tokens for current distribution (e.g. when pool allocation is intentionally not full)
1353     uint256 public reservedPercent;
1354     // HOLY tokens created per block, calculatable through updateHolyPerBlock()
1355     // updated once in the constructor and owner calling setReserve (if needed)
1356     uint256 public holyPerBlock;
1357 
1358     // Info of each pool
1359     PoolInfo[] public poolInfo;
1360     // Total allocation points. Must be the sum of all allocation points in all pools
1361     uint256 public totalAllocPoint = 0;
1362     
1363     // Info of each user that stakes LP tokens
1364     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1365     // Info of total amount of staked LP tokens by all users
1366     mapping (address => uint256) public totalStaked;
1367 
1368 
1369 
1370     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1371     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1372     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1373     event Treasury(address indexed token, address treasury, uint256 amount);
1374 
1375     constructor(
1376         HolyToken _token,
1377         address _devaddr,
1378         address _treasuryaddr,
1379         uint256 _totalsupply,
1380         uint256 _reservedPercent,
1381         uint256 _startBlock,
1382         uint256 _targetEndBlock
1383     ) public {
1384         holytoken = _token;
1385 
1386         devaddr = _devaddr;
1387         treasuryaddr = _treasuryaddr;
1388 
1389         // as knight is deployed by Holyheld token, transfer ownership to dev
1390         transferOwnership(_devaddr);
1391 
1392         totalSupply = _totalsupply;
1393         reservedPercent = _reservedPercent;
1394 
1395         startBlock = _startBlock;
1396         targetEndBlock = _targetEndBlock;
1397 
1398         // calculate initial token number per block
1399         updateHolyPerBlock();
1400     }
1401 
1402     // Reserve some percentage of HOLY token distribution
1403     // (e.g. initially, 10% of tokens are reserved for future pools to be added)
1404     function setReserve(uint256 _reservedPercent) public onlyOwner {
1405         reservedPercent = _reservedPercent;
1406         updateHolyPerBlock();
1407     }
1408 
1409     function updateHolyPerBlock() internal {
1410         // safemath substraction cannot overflow
1411         holyPerBlock = totalSupply.sub(totalSupply.mul(reservedPercent).div(100)).div(targetEndBlock.sub(startBlock));
1412         massUpdatePools();
1413     }
1414 
1415     function poolLength() external view returns (uint256) {
1416         return poolInfo.length;
1417     }
1418 
1419     // Add a new lp to the pool. Can only be called by the owner.
1420     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1421     function add(uint256 _allocPoint, IERC20 _lpToken, bool _stakeable, address _stakeableContract, IERC20 _stakedHoldableToken, bool _withUpdate) public onlyOwner {
1422         if (_withUpdate) {
1423             massUpdatePools();
1424         }
1425         uint256 lastRewardCalcBlock = block.number > startBlock ? block.number : startBlock;
1426         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1427         poolInfo.push(PoolInfo({
1428             lpToken: _lpToken,
1429             allocPoint: _allocPoint,
1430             lastRewardCalcBlock: lastRewardCalcBlock,
1431             accHolyPerShare: 0,
1432             stakeable: _stakeable,
1433             stakeableContract: _stakeableContract,
1434             stakedHoldableToken: IERC20(_stakedHoldableToken)
1435         }));
1436 
1437         if(_stakeable)
1438         {
1439             _lpToken.approve(_stakeableContract, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1440         }
1441     }
1442 
1443     // Update the given pool's HOLY allocation point. Can only be called by the owner.
1444     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1445         if (_withUpdate) {
1446             massUpdatePools();
1447         }
1448         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1449         poolInfo[_pid].allocPoint = _allocPoint;
1450     }
1451 
1452     // View function to see pending HOLYs on frontend.
1453     function pendingHoly(uint256 _pid, address _user) external view returns (uint256) {
1454         PoolInfo storage pool = poolInfo[_pid];
1455         UserInfo storage user = userInfo[_pid][_user];
1456         uint256 accHolyPerShare = pool.accHolyPerShare;
1457         uint256 lpSupply = totalStaked[address(pool.lpToken)];
1458         if (block.number > pool.lastRewardCalcBlock && lpSupply != 0) {
1459             uint256 multiplier = block.number.sub(pool.lastRewardCalcBlock);
1460             uint256 tokenReward = multiplier.mul(holyPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1461             accHolyPerShare = accHolyPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1462         }
1463         return user.amount.mul(accHolyPerShare).div(1e12).sub(user.rewardDebt);
1464     }
1465 
1466     // Update reward vairables for all pools. Be careful of gas spending!
1467     function massUpdatePools() public {
1468         uint256 length = poolInfo.length;
1469         for (uint256 pid = 0; pid < length; ++pid) {
1470             updatePool(pid);
1471         }
1472     }
1473 
1474     // Update reward variables of the given pool to be up-to-date when lpSupply changes
1475     // For every deposit/withdraw/harvest pool recalculates accumulated token value
1476     function updatePool(uint256 _pid) public {
1477         PoolInfo storage pool = poolInfo[_pid];
1478         if (block.number <= pool.lastRewardCalcBlock) {
1479             return;
1480         }
1481         uint256 lpSupply = totalStaked[address(pool.lpToken)];
1482         if (lpSupply == 0) {
1483             pool.lastRewardCalcBlock = block.number;
1484             return;
1485         }
1486         uint256 multiplier = block.number.sub(pool.lastRewardCalcBlock);
1487         uint256 tokenRewardAccumulated = multiplier.mul(holyPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1488         // no minting is required, the contract already has token balance pre-allocated
1489         // accumulated HOLY per share is stored multiplied by 10^12 to allow small 'fractional' values
1490         pool.accHolyPerShare = pool.accHolyPerShare.add(tokenRewardAccumulated.mul(1e12).div(lpSupply));
1491         pool.lastRewardCalcBlock = block.number;
1492     }
1493 
1494     // Deposit LP tokens to HolyKnight for HOLY allocation.
1495     function deposit(uint256 _pid, uint256 _amount) public {
1496         PoolInfo storage pool = poolInfo[_pid];
1497         UserInfo storage user = userInfo[_pid][msg.sender];
1498         updatePool(_pid);
1499         if (user.amount > 0) {
1500             uint256 pending = user.amount.mul(pool.accHolyPerShare).div(1e12).sub(user.rewardDebt);
1501             if(pending > 0) {
1502                 safeTokenTransfer(msg.sender, pending); //pay the earned tokens when user deposits
1503             }
1504         }
1505         // this condition would save some gas on harvest calls
1506         if (_amount > 0) {
1507             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1508             user.amount = user.amount.add(_amount);
1509         }
1510         user.rewardDebt = user.amount.mul(pool.accHolyPerShare).div(1e12);
1511 
1512         totalStaked[address(pool.lpToken)] = totalStaked[address(pool.lpToken)].add(_amount);
1513         if (pool.stakeable) {
1514             uint256 prevbalance = pool.stakedHoldableToken.balanceOf(address(this));
1515             Stakeable(pool.stakeableContract).deposit(_amount);
1516             uint256 balancetoadd = pool.stakedHoldableToken.balanceOf(address(this)).sub(prevbalance);
1517             user.stakedLPAmount = user.stakedLPAmount.add(balancetoadd);
1518             // protect received tokens from moving to treasury
1519             totalStaked[address(pool.stakedHoldableToken)] = totalStaked[address(pool.stakedHoldableToken)].add(balancetoadd);
1520         }
1521 
1522         emit Deposit(msg.sender, _pid, _amount);
1523     }
1524 
1525     // Withdraw LP tokens from HolyKnight.
1526     function withdraw(uint256 _pid, uint256 _amount) public {
1527         PoolInfo storage pool = poolInfo[_pid];
1528         UserInfo storage user = userInfo[_pid][msg.sender];
1529         updatePool(_pid);
1530 
1531         uint256 pending = user.amount.mul(pool.accHolyPerShare).div(1e12).sub(user.rewardDebt);
1532         safeTokenTransfer(msg.sender, pending);
1533         
1534         if (pool.stakeable) {
1535             // reclaim back original LP tokens and withdraw all of them, regardless of amount
1536             Stakeable(pool.stakeableContract).withdraw(user.stakedLPAmount);
1537             totalStaked[address(pool.stakedHoldableToken)] = totalStaked[address(pool.stakedHoldableToken)].sub(user.stakedLPAmount);
1538             user.stakedLPAmount = 0;
1539             // even if returned amount is less (fees, etc.), return all that is available
1540             // (can be impacting treasury rewards if abused, but is not viable due to gas costs
1541             // and treasury yields can be claimed periodically)
1542             uint256 balance = pool.lpToken.balanceOf(address(this));
1543             if (user.amount < balance) {
1544                 pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1545             } else {
1546                 pool.lpToken.safeTransfer(address(msg.sender), balance);
1547             }
1548             totalStaked[address(pool.lpToken)] = totalStaked[address(pool.lpToken)].sub(user.amount);
1549             user.amount = 0;
1550             user.rewardDebt = 0;
1551         } else {
1552             require(user.amount >= _amount, "withdraw: not good");
1553             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1554             totalStaked[address(pool.lpToken)] = totalStaked[address(pool.lpToken)].sub(_amount);
1555             user.amount = user.amount.sub(_amount);
1556             user.rewardDebt = user.amount.mul(pool.accHolyPerShare).div(1e12);
1557         }
1558         
1559         emit Withdraw(msg.sender, _pid, _amount);
1560     }
1561 
1562     // Withdraw LP tokens without caring about rewards. EMERGENCY ONLY.
1563     function emergencyWithdraw(uint256 _pid) public {
1564         PoolInfo storage pool = poolInfo[_pid];
1565         UserInfo storage user = userInfo[_pid][msg.sender];
1566 
1567         if (pool.stakeable) {
1568             // reclaim back original LP tokens and withdraw all of them, regardless of amount
1569             Stakeable(pool.stakeableContract).withdraw(user.stakedLPAmount);
1570             totalStaked[address(pool.stakedHoldableToken)] = totalStaked[address(pool.stakedHoldableToken)].sub(user.stakedLPAmount);
1571             user.stakedLPAmount = 0;
1572             uint256 balance = pool.lpToken.balanceOf(address(this));
1573             if (user.amount < balance) {
1574                 pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1575             } else {
1576                 pool.lpToken.safeTransfer(address(msg.sender), balance);
1577             }
1578         } else {
1579             pool.lpToken.safeTransfer(address(msg.sender), user.amount);    
1580         }
1581 
1582         totalStaked[address(pool.lpToken)] = totalStaked[address(pool.lpToken)].sub(user.amount);
1583         user.amount = 0;
1584         user.rewardDebt = 0;
1585         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1586     }
1587 
1588     // Safe holyheld token transfer function, just in case if rounding error causes pool to not have enough HOLYs.
1589     function safeTokenTransfer(address _to, uint256 _amount) internal {
1590         uint256 balance = holytoken.balanceOf(address(this));
1591         if (_amount > balance) {
1592             holytoken.transfer(_to, balance);
1593         } else {
1594             holytoken.transfer(_to, _amount);
1595         }
1596     }
1597 
1598     // Update dev address by the previous dev.
1599     function dev(address _devaddr) public {
1600         require(msg.sender == devaddr, "forbidden");
1601         devaddr = _devaddr;
1602     }
1603 
1604     // Update treasury address by the previous treasury.
1605     function treasury(address _treasuryaddr) public {
1606         require(msg.sender == treasuryaddr, "forbidden");
1607         treasuryaddr = _treasuryaddr;
1608     }
1609 
1610     // Send yield on an LP token to the treasury
1611     // have just address (and not pid) as agrument to be able to recover
1612     // tokens that could be directly transferred and not present in pools
1613     function putToTreasury(address _token) public onlyOwner {
1614         uint256 availablebalance = getAvailableBalance(_token);
1615         require(availablebalance > 0, "not enough tokens");
1616         putToTreasuryAmount(_token, availablebalance);
1617     }
1618 
1619     // Send yield amount realized from holding LP tokens to the treasury
1620     function putToTreasuryAmount(address _token, uint256 _amount) public onlyOwner {
1621         require(_token != address(holytoken), "cannot transfer holy tokens");
1622         uint256 availablebalance = getAvailableBalance(_token);
1623         require(_amount <= availablebalance, "not enough tokens");
1624         IERC20(_token).safeTransfer(treasuryaddr, _amount);
1625         emit Treasury(_token, treasuryaddr, _amount);
1626     }
1627 
1628     // Get available token balance that can be put to treasury
1629     // For pools with internal staking, all lpToken balance is contract's
1630     // (bacause user tokens are converted to pool.stakedHoldableToken when depositing)
1631     // HOLY tokens themselves and user lpTokens are protected by this check
1632     function getAvailableBalance(address _token) internal view returns (uint256) {
1633         uint256 availablebalance = IERC20(_token).balanceOf(address(this)) - totalStaked[_token];
1634         uint256 length = poolInfo.length;
1635         for (uint256 pid = 0; pid < length; ++pid) {
1636             PoolInfo storage pool = poolInfo[pid]; //storage pointer used read-only
1637             if (pool.stakeable && address(pool.lpToken) == _token)
1638             {
1639                 availablebalance = IERC20(_token).balanceOf(address(this));
1640                 break;
1641             }
1642         }
1643         return availablebalance;
1644     }
1645 }
1646 
1647 contract HolderTimelock is TokenTimelock {
1648   constructor(
1649     IERC20 _token, 
1650     address _beneficiary,
1651     uint256 _releaseTime
1652   )
1653     public
1654     TokenTimelock(_token, _beneficiary, _releaseTime)
1655   //solhint-disable-next-line
1656   {}
1657 }