1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      *
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
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      *
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      *
118      * - The divisor cannot be zero.
119      */
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * Reverts with custom message when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 /**
163  * @dev Collection of functions related to the address type
164  */
165 library Address {
166     /**
167      * @dev Returns true if `account` is a contract.
168      *
169      * [IMPORTANT]
170      * ====
171      * It is unsafe to assume that an address for which this function returns
172      * false is an externally-owned account (EOA) and not a contract.
173      *
174      * Among others, `isContract` will return false for the following
175      * types of addresses:
176      *
177      *  - an externally-owned account
178      *  - a contract in construction
179      *  - an address where a contract will be created
180      *  - an address where a contract lived, but was destroyed
181      * ====
182      */
183     function isContract(address account) internal view returns (bool) {
184         // This method relies in extcodesize, which returns 0 for contracts in
185         // construction, since the code is only stored at the end of the
186         // constructor execution.
187 
188         uint256 size;
189         // solhint-disable-next-line no-inline-assembly
190         assembly { size := extcodesize(account) }
191         return size > 0;
192     }
193 
194     /**
195      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
196      * `recipient`, forwarding all available gas and reverting on errors.
197      *
198      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
199      * of certain opcodes, possibly making contracts go over the 2300 gas limit
200      * imposed by `transfer`, making them unable to receive funds via
201      * `transfer`. {sendValue} removes this limitation.
202      *
203      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
204      *
205      * IMPORTANT: because control is transferred to `recipient`, care must be
206      * taken to not create reentrancy vulnerabilities. Consider using
207      * {ReentrancyGuard} or the
208      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
209      */
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
214         (bool success, ) = recipient.call{ value: amount }("");
215         require(success, "Address: unable to send value, recipient may have reverted");
216     }
217 
218     /**
219      * @dev Performs a Solidity function call using a low level `call`. A
220      * plain`call` is an unsafe replacement for a function call: use this
221      * function instead.
222      *
223      * If `target` reverts with a revert reason, it is bubbled up by this
224      * function (like regular Solidity function calls).
225      *
226      * Returns the raw returned data. To convert to the expected return value,
227      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
228      *
229      * Requirements:
230      *
231      * - `target` must be a contract.
232      * - calling `target` with `data` must not revert.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
237       return functionCall(target, data, "Address: low-level call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
242      * `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
247         return _functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but also transferring `value` wei to `target`.
253      *
254      * Requirements:
255      *
256      * - the calling contract must have an ETH balance of at least `value`.
257      * - the called Solidity function must be `payable`.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
267      * with `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
272         require(address(this).balance >= value, "Address: insufficient balance for call");
273         return _functionCallWithValue(target, data, value, errorMessage);
274     }
275 
276     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
277         require(isContract(target), "Address: call to non-contract");
278 
279         // solhint-disable-next-line avoid-low-level-calls
280         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
281         if (success) {
282             return returndata;
283         } else {
284             // Look for revert reason and bubble it up if present
285             if (returndata.length > 0) {
286                 // The easiest way to bubble the revert reason is using memory via assembly
287 
288                 // solhint-disable-next-line no-inline-assembly
289                 assembly {
290                     let returndata_size := mload(returndata)
291                     revert(add(32, returndata), returndata_size)
292                 }
293             } else {
294                 revert(errorMessage);
295             }
296         }
297     }
298 }
299 
300 /**
301  * @dev Interface of the ERC20 standard as defined in the EIP.
302  */
303 interface IERC20 {
304     /**
305      * @dev Returns the amount of tokens in existence.
306      */
307     function totalSupply() external view returns (uint256);
308 
309     /**
310      * @dev Returns the amount of tokens owned by `account`.
311      */
312     function balanceOf(address account) external view returns (uint256);
313 
314     /**
315      * @dev Moves `amount` tokens from the caller's account to `recipient`.
316      *
317      * Returns a boolean value indicating whether the operation succeeded.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transfer(address recipient, uint256 amount) external returns (bool);
322 
323     /**
324      * @dev Returns the remaining number of tokens that `spender` will be
325      * allowed to spend on behalf of `owner` through {transferFrom}. This is
326      * zero by default.
327      *
328      * This value changes when {approve} or {transferFrom} are called.
329      */
330     function allowance(address owner, address spender) external view returns (uint256);
331 
332     /**
333      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
334      *
335      * Returns a boolean value indicating whether the operation succeeded.
336      *
337      * IMPORTANT: Beware that changing an allowance with this method brings the risk
338      * that someone may use both the old and the new allowance by unfortunate
339      * transaction ordering. One possible solution to mitigate this race
340      * condition is to first reduce the spender's allowance to 0 and set the
341      * desired value afterwards:
342      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
343      *
344      * Emits an {Approval} event.
345      */
346     function approve(address spender, uint256 amount) external returns (bool);
347 
348     /**
349      * @dev Moves `amount` tokens from `sender` to `recipient` using the
350      * allowance mechanism. `amount` is then deducted from the caller's
351      * allowance.
352      *
353      * Returns a boolean value indicating whether the operation succeeded.
354      *
355      * Emits a {Transfer} event.
356      */
357     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
358 
359     /**
360      * @dev Emitted when `value` tokens are moved from one account (`from`) to
361      * another (`to`).
362      *
363      * Note that `value` may be zero.
364      */
365     event Transfer(address indexed from, address indexed to, uint256 value);
366 
367     /**
368      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
369      * a call to {approve}. `value` is the new allowance.
370      */
371     event Approval(address indexed owner, address indexed spender, uint256 value);
372 }
373 
374 /*
375  * @dev Provides information about the current execution context, including the
376  * sender of the transaction and its data. While these are generally available
377  * via msg.sender and msg.data, they should not be accessed in such a direct
378  * manner, since when dealing with GSN meta-transactions the account sending and
379  * paying for execution may not be the actual sender (as far as an application
380  * is concerned).
381  *
382  * This contract is only required for intermediate, library-like contracts.
383  */
384 abstract contract Context {
385     function _msgSender() internal view virtual returns (address payable) {
386         return msg.sender;
387     }
388 
389     function _msgData() internal view virtual returns (bytes memory) {
390         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
391         return msg.data;
392     }
393 }
394 
395 /**
396  * @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 contract Ownable is Context {
408     address private _owner;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor () internal {
416         address msgSender = _msgSender();
417         _owner = msgSender;
418         emit OwnershipTransferred(address(0), msgSender);
419     }
420 
421     /**
422      * @dev Returns the address of the current owner.
423      */
424     function owner() public view returns (address) {
425         return _owner;
426     }
427 
428     /**
429      * @dev Throws if called by any account other than the owner.
430      */
431     modifier onlyOwner() {
432         require(_owner == _msgSender(), "Ownable: caller is not the owner");
433         _;
434     }
435 
436     /**
437      * @dev Leaves the contract without owner. It will not be possible to call
438      * `onlyOwner` functions anymore. Can only be called by the current owner.
439      *
440      * NOTE: Renouncing ownership will leave the contract without an owner,
441      * thereby removing any functionality that is only available to the owner.
442      */
443     function renounceOwnership() public virtual onlyOwner {
444         emit OwnershipTransferred(_owner, address(0));
445         _owner = address(0);
446     }
447 
448     /**
449      * @dev Transfers ownership of the contract to a new account (`newOwner`).
450      * Can only be called by the current owner.
451      */
452     function transferOwnership(address newOwner) public virtual onlyOwner {
453         require(newOwner != address(0), "Ownable: new owner is the zero address");
454         emit OwnershipTransferred(_owner, newOwner);
455         _owner = newOwner;
456     }
457 }
458 
459 /**
460  * @title SafeERC20
461  * @dev Wrappers around ERC20 operations that throw on failure (when the token
462  * contract returns false). Tokens that return no value (and instead revert or
463  * throw on failure) are also supported, non-reverting calls are assumed to be
464  * successful.
465  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
466  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
467  */
468 library SafeERC20 {
469     using SafeMath for uint256;
470     using Address for address;
471 
472     function safeTransfer(IERC20 token, address to, uint256 value) internal {
473         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
474     }
475 
476     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
477         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
478     }
479 
480     /**
481      * @dev Deprecated. This function has issues similar to the ones found in
482      * {IERC20-approve}, and its usage is discouraged.
483      *
484      * Whenever possible, use {safeIncreaseAllowance} and
485      * {safeDecreaseAllowance} instead.
486      */
487     function safeApprove(IERC20 token, address spender, uint256 value) internal {
488         // safeApprove should only be called when setting an initial allowance,
489         // or when resetting it to zero. To increase and decrease it, use
490         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
491         // solhint-disable-next-line max-line-length
492         require((value == 0) || (token.allowance(address(this), spender) == 0),
493             "SafeERC20: approve from non-zero to non-zero allowance"
494         );
495         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
496     }
497 
498     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
499         uint256 newAllowance = token.allowance(address(this), spender).add(value);
500         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
501     }
502 
503     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
504         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
505         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
506     }
507 
508     /**
509      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
510      * on the return value: the return value is optional (but if data is returned, it must not be false).
511      * @param token The token targeted by the call.
512      * @param data The call data (encoded using abi.encode or one of its variants).
513      */
514     function _callOptionalReturn(IERC20 token, bytes memory data) private {
515         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
516         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
517         // the target address contains contract code and also asserts for success in the low-level call.
518 
519         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
520         if (returndata.length > 0) { // Return data is optional
521             // solhint-disable-next-line max-line-length
522             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
523         }
524     }
525 }
526 
527 
528 // Interface to represent a contract in pools that requires additional
529 // deposit and withdraw of LP tokens. One of the examples at the time of writing
530 // is Yearn vault, which takes yCRV which is already LP token and returns yyCRV 
531 interface Stakeable {
532     function deposit(uint) external;
533     function withdraw(uint) external;
534 }
535 
536 /**
537  * @dev A token holder contract that will allow a beneficiary to extract the
538  * tokens after a given release time.
539  *
540  * Useful for simple vesting schedules like "advisors get all of their tokens
541  * after 1 year".
542  */
543 contract TokenTimelock {
544     using SafeERC20 for IERC20;
545 
546     // ERC20 basic token contract being held
547     IERC20 private _token;
548 
549     // beneficiary of tokens after they are released
550     address private _beneficiary;
551 
552     // timestamp when token release is enabled
553     uint256 private _releaseTime;
554 
555     constructor (IERC20 token, address beneficiary, uint256 releaseTime) public {
556         // solhint-disable-next-line not-rely-on-time
557         require(releaseTime > block.timestamp, "TokenTimelock: release time is before current time");
558         _token = token;
559         _beneficiary = beneficiary;
560         _releaseTime = releaseTime;
561     }
562 
563     /**
564      * @return the token being held.
565      */
566     function token() public view returns (IERC20) {
567         return _token;
568     }
569 
570     /**
571      * @return the beneficiary of the tokens.
572      */
573     function beneficiary() public view returns (address) {
574         return _beneficiary;
575     }
576 
577     /**
578      * @return the time when the tokens are released.
579      */
580     function releaseTime() public view returns (uint256) {
581         return _releaseTime;
582     }
583 
584     /**
585      * @notice Transfers tokens held by timelock to beneficiary.
586      */
587     function release() public virtual {
588         // solhint-disable-next-line not-rely-on-time
589         require(block.timestamp >= _releaseTime, "TokenTimelock: current time is before release time");
590 
591         uint256 amount = _token.balanceOf(address(this));
592         require(amount > 0, "TokenTimelock: no tokens to release");
593 
594         _token.safeTransfer(_beneficiary, amount);
595     }
596 }
597 
598 contract HolderTimelock is TokenTimelock {
599   constructor(
600     IERC20 _token, 
601     address _beneficiary,
602     uint256 _releaseTime
603   )
604     public
605     TokenTimelock(_token, _beneficiary, _releaseTime)
606   //solhint-disable-next-line
607   {}
608 }
609 
610 /**
611  * @dev A token holder contract that will allow a beneficiary to extract the
612  * tokens by portions based on a metric (TVL)
613  *
614  * This is ported from openzeppelin-ethereum-package
615  *
616  * Currently the holder contract is Ownable (while the owner is current beneficiary)
617  * still, this allows to check the method calls in blockchain to verify fair play.
618  * In the future it will be possible to use automated calculation, e.g. using
619  * https://github.com/ConcourseOpen/DeFi-Pulse-Adapters TVL calculation, then
620  * ownership would be transferred to the managing contract.
621  */
622 contract HolderTVLLock is Ownable {
623     using SafeMath for uint256;
624     using SafeERC20 for IERC20;
625 
626     uint256 private constant RELEASE_PERCENT = 2;
627     uint256 private constant RELEASE_INTERVAL = 1 weeks;
628 
629     // ERC20 basic token contract being held
630     IERC20 private _token;
631 
632     // beneficiary of tokens after they are released
633     address private _beneficiary;
634 
635     // timestamp when token release was made last time
636     uint256 private _lastReleaseTime;
637 
638     // timestamp of first possible release time
639     uint256 private _firstReleaseTime;
640 
641     // TVL metric for last release time
642     uint256 private _lastReleaseTVL;
643 
644     // amount that already was released
645     uint256 private _released;
646 
647     event TVLReleasePerformed(uint256 newTVL);
648 
649     constructor (IERC20 token, address beneficiary, uint256 firstReleaseTime) public {
650         //as contract is deployed by Holyheld token, transfer ownership to dev
651         transferOwnership(beneficiary);
652 
653         // solhint-disable-next-line not-rely-on-time
654         require(firstReleaseTime > block.timestamp, "release time before current time");
655         _token = token;
656         _beneficiary = beneficiary;
657         _firstReleaseTime = firstReleaseTime;
658     }
659 
660     /**
661      * @return the token being held.
662      */
663     function token() public view returns (IERC20) {
664         return _token;
665     }
666 
667     /**
668      * @return the beneficiary of the tokens.
669      */
670     function beneficiary() public view returns (address) {
671         return _beneficiary;
672     }
673 
674     /**
675      * @return the time when the tokens were released last time.
676      */
677     function lastReleaseTime() public view returns (uint256) {
678         return _lastReleaseTime;
679     }
680 
681     /**
682      * @return the TVL marked when the tokens were released last time.
683      */
684     function lastReleaseTVL() public view returns (uint256) {
685         return _lastReleaseTVL;
686     }
687 
688     /**
689      * @notice Transfers tokens held by timelock to beneficiary.
690      * only owner can call this method as it will write new TVL metric value
691      * into the holder contract
692      */
693     function release(uint256 _newTVL) public onlyOwner {
694         // solhint-disable-next-line not-rely-on-time
695         require(block.timestamp >= _firstReleaseTime, "current time before release time");
696         require(block.timestamp > _lastReleaseTime + RELEASE_INTERVAL, "release interval is not passed");
697         require(_newTVL > _lastReleaseTVL, "only release if TVL is higher");
698 
699         // calculate amount that is possible to release
700         uint256 balance = _token.balanceOf(address(this));
701         uint256 totalBalance = balance.add(_released);
702 
703         uint256 amount = totalBalance.mul(RELEASE_PERCENT).div(100);
704         require(balance > amount, "available balance depleted");
705 
706         _token.safeTransfer(_beneficiary, amount);
707 	    _lastReleaseTime = block.timestamp;
708 	    _lastReleaseTVL = _newTVL;
709 	    _released = _released.add(amount);
710 
711         emit TVLReleasePerformed(_newTVL);
712     }
713 }
714 
715 /**
716  * @title TokenVesting
717  * @dev A token holder contract that can release its token balance gradually like a
718  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
719  * owner.
720  */
721 contract HolderVesting is Ownable {
722     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
723     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
724     // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a
725     // cliff period of a year and a duration of four years, are safe to use.
726     // solhint-disable not-rely-on-time
727 
728     using SafeMath for uint256;
729     using SafeERC20 for IERC20;
730 
731     uint256 private constant RELEASE_INTERVAL = 1 weeks;
732 
733     event TokensReleased(address token, uint256 amount);
734     event TokenVestingRevoked(address token);
735 
736     // beneficiary of tokens after they are released
737     address private _beneficiary;
738 
739     // ERC20 basic token contract being held
740     IERC20 private _token;
741 
742     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
743     uint256 private _start;
744     uint256 private _duration;
745 
746     // timestamp when token release was made last time
747     uint256 private _lastReleaseTime;
748 
749     bool private _revocable;
750 
751     uint256 private _released;
752     bool private _revoked;
753 
754     /**
755      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
756      * beneficiary, gradually in a linear fashion until start + duration. By then all
757      * of the balance will have vested.
758      * @param beneficiary address of the beneficiary to whom vested tokens are transferred
759      * @param start the time (as Unix time) at which point vesting starts
760      * @param duration duration in seconds of the period in which the tokens will vest
761      * @param revocable whether the vesting is revocable or not
762      */
763     constructor(IERC20 token, address beneficiary, uint256 start, uint256 duration, bool revocable) public {
764 
765         require(beneficiary != address(0), "beneficiary is zero address");
766         require(duration > 0, "duration is 0");
767         // solhint-disable-next-line max-line-length
768         require(start.add(duration) > block.timestamp, "final time before current time");
769 
770         _token = token;
771         
772         _beneficiary = beneficiary;
773         //as contract is deployed by Holyheld token, transfer ownership to dev
774         transferOwnership(beneficiary);
775 
776         _revocable = revocable;
777         _duration = duration;
778         _start = start;
779     }
780 
781     /**
782      * @return the beneficiary of the tokens.
783      */
784     function beneficiary() public view returns (address) {
785         return _beneficiary;
786     }
787 
788     /**
789      * @return the start time of the token vesting.
790      */
791     function start() public view returns (uint256) {
792         return _start;
793     }
794 
795     /**
796      * @return the duration of the token vesting.
797      */
798     function duration() public view returns (uint256) {
799         return _duration;
800     }
801 
802     /**
803      * @return true if the vesting is revocable.
804      */
805     function revocable() public view returns (bool) {
806         return _revocable;
807     }
808 
809     /**
810      * @return the amount of the token released.
811      */
812     function released() public view returns (uint256) {
813         return _released;
814     }
815 
816     /**
817      * @return true if the token is revoked.
818      */
819     function revoked() public view returns (bool) {
820         return _revoked;
821     }
822 
823     /**
824      * @return the time when the tokens were released last time.
825      */
826     function lastReleaseTime() public view returns (uint256) {
827         return _lastReleaseTime;
828     }
829 
830     /**
831      * @notice Transfers vested tokens to beneficiary.
832      */
833     function release() public {
834         uint256 unreleased = _releasableAmount();
835 
836         require(unreleased > 0, "no tokens are due");
837         require(block.timestamp > _lastReleaseTime + RELEASE_INTERVAL, "release interval is not passed");
838 
839         _released = _released.add(unreleased);
840 
841         _token.safeTransfer(_beneficiary, unreleased);
842         _lastReleaseTime = block.timestamp;
843 
844         emit TokensReleased(address(_token), unreleased);
845     }
846 
847     /**
848      * @notice Allows the owner to revoke the vesting. Tokens already vested
849      * remain in the contract, the rest are returned to the owner.
850      */
851     function revoke() public onlyOwner {
852         require(_revocable, "cannot revoke");
853         require(!_revoked, "vesting already revoked");
854 
855         uint256 balance = _token.balanceOf(address(this));
856 
857         uint256 unreleased = _releasableAmount();
858         uint256 refund = balance.sub(unreleased);
859 
860         _revoked = true;
861 
862         _token.safeTransfer(owner(), refund);
863 
864         emit TokenVestingRevoked(address(_token));
865     }
866 
867     /**
868      * @dev Calculates the amount that has already vested but hasn't been released yet.
869      */
870     function _releasableAmount() private view returns (uint256) {
871         return _vestedAmount().sub(_released);
872     }
873 
874     /**
875      * @dev Calculates the amount that has already vested.
876      */
877     function _vestedAmount() private view returns (uint256) {
878         uint256 currentBalance = _token.balanceOf(address(this));
879         uint256 totalBalance = currentBalance.add(_released);
880 
881         if (block.timestamp < _start) {
882             return 0;
883         } else if (block.timestamp >= _start.add(_duration) || _revoked) {
884             return totalBalance;
885         } else {
886             return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
887         }
888     }
889 }
890 
891 /**
892  * @dev // HolyKnight is using LP to distribute Holyheld token
893  *
894  * it does not mint any HOLY tokens, they must be present on the
895  * contract's token balance. Balance is not intended to be refillable.
896  *
897  * Note that it's ownable and the owner wields tremendous power. The ownership
898  * will be transferred to a governance smart contract once HOLY is sufficiently
899  * distributed and the community can show to govern itself.
900  *
901  * Have fun reading it. Hopefully it's bug-free. God bless.
902  */
903 contract HolyKnight is Ownable {
904     using SafeMath for uint256;
905     using SafeERC20 for IERC20;
906 
907     // Info of each user
908     struct UserInfo {
909         uint256 amount;     // How many LP tokens the user has provided.
910         uint256 rewardDebt; // Reward debt. See explanation below.
911         //
912         // We do some fancy math here. Basically, any point in time, the amount of HOLYs
913         // entitled to a user but is pending to be distributed is:
914         //
915         //   pending reward = (user.amount * pool.accHolyPerShare) - user.rewardDebt
916         //
917         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
918         //   1. The pool's `accHolyPerShare` (and `lastRewardCalcBlock`) gets updated.
919         //   2. User receives the pending reward sent to his/her address.
920         //   3. User's `amount` gets updated.
921         //   4. User's `rewardDebt` gets updated.
922         // Thus every change in pool or allocation will result in recalculation of values
923         // (otherwise distribution remains constant btwn blocks and will be properly calculated)
924         uint256 stakedLPAmount;
925     }
926 
927     // Info of each pool
928     struct PoolInfo {
929         IERC20 lpToken;              // Address of LP token contract
930         uint256 allocPoint;          // How many allocation points assigned to this pool. HOLYs to distribute per block
931         uint256 lastRewardCalcBlock; // Last block number for which HOLYs distribution is already calculated for the pool
932         uint256 accHolyPerShare;     // Accumulated HOLYs per share, times 1e12. See below
933         bool    stakeable;         // we should call deposit method on the LP tokens provided (used for e.g. vault staking)
934         address stakeableContract;     // location where to deposit LP tokens if pool is stakeable
935         IERC20  stakedHoldableToken;
936     }
937 
938     // The Holyheld token
939     HolyToken public holytoken;
940     // Dev address
941     address public devaddr;
942     // Treasury address
943     address public treasuryaddr;
944 
945     // The block number when HOLY mining starts
946     uint256 public startBlock;
947     // The block number when HOLY mining targeted to end (if full allocation).
948     // used only for token distribution calculation, this is not a hard limit
949     uint256 public targetEndBlock;
950 
951     // Total amount of tokens to distribute
952     uint256 public totalSupply;
953     // Reserved percent of HOLY tokens for current distribution (e.g. when pool allocation is intentionally not full)
954     uint256 public reservedPercent;
955     // HOLY tokens created per block, calculatable through updateHolyPerBlock()
956     // updated once in the constructor and owner calling setReserve (if needed)
957     uint256 public holyPerBlock;
958 
959     // Info of each pool
960     PoolInfo[] public poolInfo;
961     // Total allocation points. Must be the sum of all allocation points in all pools
962     uint256 public totalAllocPoint = 0;
963     
964     // Info of each user that stakes LP tokens
965     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
966     // Info of total amount of staked LP tokens by all users
967     mapping (address => uint256) public totalStaked;
968 
969 
970 
971     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
972     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
973     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
974     event Treasury(address indexed token, address treasury, uint256 amount);
975 
976     constructor(
977         HolyToken _token,
978         address _devaddr,
979         address _treasuryaddr,
980         uint256 _totalsupply,
981         uint256 _reservedPercent,
982         uint256 _startBlock,
983         uint256 _targetEndBlock
984     ) public {
985         holytoken = _token;
986 
987         devaddr = _devaddr;
988         treasuryaddr = _treasuryaddr;
989 
990         // as knight is deployed by Holyheld token, transfer ownership to dev
991         transferOwnership(_devaddr);
992 
993         totalSupply = _totalsupply;
994         reservedPercent = _reservedPercent;
995 
996         startBlock = _startBlock;
997         targetEndBlock = _targetEndBlock;
998 
999         // calculate initial token number per block
1000         updateHolyPerBlock();
1001     }
1002 
1003     // Reserve some percentage of HOLY token distribution
1004     // (e.g. initially, 10% of tokens are reserved for future pools to be added)
1005     function setReserve(uint256 _reservedPercent) public onlyOwner {
1006         reservedPercent = _reservedPercent;
1007         updateHolyPerBlock();
1008     }
1009 
1010     function updateHolyPerBlock() internal {
1011         // safemath substraction cannot overflow
1012         holyPerBlock = totalSupply.sub(totalSupply.mul(reservedPercent).div(100)).div(targetEndBlock.sub(startBlock));
1013         massUpdatePools();
1014     }
1015 
1016     function poolLength() external view returns (uint256) {
1017         return poolInfo.length;
1018     }
1019 
1020     // Add a new lp to the pool. Can only be called by the owner.
1021     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1022     function add(uint256 _allocPoint, IERC20 _lpToken, bool _stakeable, address _stakeableContract, IERC20 _stakedHoldableToken, bool _withUpdate) public onlyOwner {
1023         if (_withUpdate) {
1024             massUpdatePools();
1025         }
1026         uint256 lastRewardCalcBlock = block.number > startBlock ? block.number : startBlock;
1027         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1028         poolInfo.push(PoolInfo({
1029             lpToken: _lpToken,
1030             allocPoint: _allocPoint,
1031             lastRewardCalcBlock: lastRewardCalcBlock,
1032             accHolyPerShare: 0,
1033             stakeable: _stakeable,
1034             stakeableContract: _stakeableContract,
1035             stakedHoldableToken: IERC20(_stakedHoldableToken)
1036         }));
1037 
1038         if(_stakeable)
1039         {
1040             _lpToken.approve(_stakeableContract, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1041         }
1042     }
1043 
1044     // Update the given pool's HOLY allocation point. Can only be called by the owner.
1045     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1046         if (_withUpdate) {
1047             massUpdatePools();
1048         }
1049         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1050         poolInfo[_pid].allocPoint = _allocPoint;
1051     }
1052 
1053     // View function to see pending HOLYs on frontend.
1054     function pendingHoly(uint256 _pid, address _user) external view returns (uint256) {
1055         PoolInfo storage pool = poolInfo[_pid];
1056         UserInfo storage user = userInfo[_pid][_user];
1057         uint256 accHolyPerShare = pool.accHolyPerShare;
1058         uint256 lpSupply = totalStaked[address(pool.lpToken)];
1059         if (block.number > pool.lastRewardCalcBlock && lpSupply != 0) {
1060             uint256 multiplier = block.number.sub(pool.lastRewardCalcBlock);
1061             uint256 tokenReward = multiplier.mul(holyPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1062             accHolyPerShare = accHolyPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1063         }
1064         return user.amount.mul(accHolyPerShare).div(1e12).sub(user.rewardDebt);
1065     }
1066 
1067     // Update reward vairables for all pools. Be careful of gas spending!
1068     function massUpdatePools() public {
1069         uint256 length = poolInfo.length;
1070         for (uint256 pid = 0; pid < length; ++pid) {
1071             updatePool(pid);
1072         }
1073     }
1074 
1075     // Update reward variables of the given pool to be up-to-date when lpSupply changes
1076     // For every deposit/withdraw/harvest pool recalculates accumulated token value
1077     function updatePool(uint256 _pid) public {
1078         PoolInfo storage pool = poolInfo[_pid];
1079         if (block.number <= pool.lastRewardCalcBlock) {
1080             return;
1081         }
1082         uint256 lpSupply = totalStaked[address(pool.lpToken)];
1083         if (lpSupply == 0) {
1084             pool.lastRewardCalcBlock = block.number;
1085             return;
1086         }
1087         uint256 multiplier = block.number.sub(pool.lastRewardCalcBlock);
1088         uint256 tokenRewardAccumulated = multiplier.mul(holyPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1089         // no minting is required, the contract already has token balance pre-allocated
1090         // accumulated HOLY per share is stored multiplied by 10^12 to allow small 'fractional' values
1091         pool.accHolyPerShare = pool.accHolyPerShare.add(tokenRewardAccumulated.mul(1e12).div(lpSupply));
1092         pool.lastRewardCalcBlock = block.number;
1093     }
1094 
1095     // Deposit LP tokens to HolyKnight for HOLY allocation.
1096     function deposit(uint256 _pid, uint256 _amount) public {
1097         PoolInfo storage pool = poolInfo[_pid];
1098         UserInfo storage user = userInfo[_pid][msg.sender];
1099         updatePool(_pid);
1100         if (user.amount > 0) {
1101             uint256 pending = user.amount.mul(pool.accHolyPerShare).div(1e12).sub(user.rewardDebt);
1102             if(pending > 0) {
1103                 safeTokenTransfer(msg.sender, pending); //pay the earned tokens when user deposits
1104             }
1105         }
1106         // this condition would save some gas on harvest calls
1107         if (_amount > 0) {
1108             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1109             user.amount = user.amount.add(_amount);
1110         }
1111         user.rewardDebt = user.amount.mul(pool.accHolyPerShare).div(1e12);
1112 
1113         totalStaked[address(pool.lpToken)] = totalStaked[address(pool.lpToken)].add(_amount);
1114         if (pool.stakeable) {
1115             uint256 prevbalance = pool.stakedHoldableToken.balanceOf(address(this));
1116             Stakeable(pool.stakeableContract).deposit(_amount);
1117             uint256 balancetoadd = pool.stakedHoldableToken.balanceOf(address(this)).sub(prevbalance);
1118             user.stakedLPAmount = user.stakedLPAmount.add(balancetoadd);
1119             // protect received tokens from moving to treasury
1120             totalStaked[address(pool.stakedHoldableToken)] = totalStaked[address(pool.stakedHoldableToken)].add(balancetoadd);
1121         }
1122 
1123         emit Deposit(msg.sender, _pid, _amount);
1124     }
1125 
1126     // Withdraw LP tokens from HolyKnight.
1127     function withdraw(uint256 _pid, uint256 _amount) public {
1128         PoolInfo storage pool = poolInfo[_pid];
1129         UserInfo storage user = userInfo[_pid][msg.sender];
1130         updatePool(_pid);
1131 
1132         uint256 pending = user.amount.mul(pool.accHolyPerShare).div(1e12).sub(user.rewardDebt);
1133         safeTokenTransfer(msg.sender, pending);
1134         
1135         if (pool.stakeable) {
1136             // reclaim back original LP tokens and withdraw all of them, regardless of amount
1137             Stakeable(pool.stakeableContract).withdraw(user.stakedLPAmount);
1138             totalStaked[address(pool.stakedHoldableToken)] = totalStaked[address(pool.stakedHoldableToken)].sub(user.stakedLPAmount);
1139             user.stakedLPAmount = 0;
1140             // even if returned amount is less (fees, etc.), return all that is available
1141             // (can be impacting treasury rewards if abused, but is not viable due to gas costs
1142             // and treasury yields can be claimed periodically)
1143             uint256 balance = pool.lpToken.balanceOf(address(this));
1144             if (user.amount < balance) {
1145                 pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1146             } else {
1147                 pool.lpToken.safeTransfer(address(msg.sender), balance);
1148             }
1149             totalStaked[address(pool.lpToken)] = totalStaked[address(pool.lpToken)].sub(user.amount);
1150             user.amount = 0;
1151             user.rewardDebt = 0;
1152         } else {
1153             require(user.amount >= _amount, "withdraw: not good");
1154             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1155             totalStaked[address(pool.lpToken)] = totalStaked[address(pool.lpToken)].sub(_amount);
1156             user.amount = user.amount.sub(_amount);
1157             user.rewardDebt = user.amount.mul(pool.accHolyPerShare).div(1e12);
1158         }
1159         
1160         emit Withdraw(msg.sender, _pid, _amount);
1161     }
1162 
1163     // Withdraw LP tokens without caring about rewards. EMERGENCY ONLY.
1164     function emergencyWithdraw(uint256 _pid) public {
1165         PoolInfo storage pool = poolInfo[_pid];
1166         UserInfo storage user = userInfo[_pid][msg.sender];
1167 
1168         if (pool.stakeable) {
1169             // reclaim back original LP tokens and withdraw all of them, regardless of amount
1170             Stakeable(pool.stakeableContract).withdraw(user.stakedLPAmount);
1171             totalStaked[address(pool.stakedHoldableToken)] = totalStaked[address(pool.stakedHoldableToken)].sub(user.stakedLPAmount);
1172             user.stakedLPAmount = 0;
1173             uint256 balance = pool.lpToken.balanceOf(address(this));
1174             if (user.amount < balance) {
1175                 pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1176             } else {
1177                 pool.lpToken.safeTransfer(address(msg.sender), balance);
1178             }
1179         } else {
1180             pool.lpToken.safeTransfer(address(msg.sender), user.amount);    
1181         }
1182 
1183         totalStaked[address(pool.lpToken)] = totalStaked[address(pool.lpToken)].sub(user.amount);
1184         user.amount = 0;
1185         user.rewardDebt = 0;
1186         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1187     }
1188 
1189     // Safe holyheld token transfer function, just in case if rounding error causes pool to not have enough HOLYs.
1190     function safeTokenTransfer(address _to, uint256 _amount) internal {
1191         uint256 balance = holytoken.balanceOf(address(this));
1192         if (_amount > balance) {
1193             holytoken.transfer(_to, balance);
1194         } else {
1195             holytoken.transfer(_to, _amount);
1196         }
1197     }
1198 
1199     // Update dev address by the previous dev.
1200     function dev(address _devaddr) public {
1201         require(msg.sender == devaddr, "forbidden");
1202         devaddr = _devaddr;
1203     }
1204 
1205     // Update treasury address by the previous treasury.
1206     function treasury(address _treasuryaddr) public {
1207         require(msg.sender == treasuryaddr, "forbidden");
1208         treasuryaddr = _treasuryaddr;
1209     }
1210 
1211     // Send yield on an LP token to the treasury
1212     // have just address (and not pid) as agrument to be able to recover
1213     // tokens that could be directly transferred and not present in pools
1214     function putToTreasury(address _token) public onlyOwner {
1215         uint256 availablebalance = getAvailableBalance(_token);
1216         require(availablebalance > 0, "not enough tokens");
1217         putToTreasuryAmount(_token, availablebalance);
1218     }
1219 
1220     // Send yield amount realized from holding LP tokens to the treasury
1221     function putToTreasuryAmount(address _token, uint256 _amount) public onlyOwner {
1222         require(_token != address(holytoken), "cannot transfer holy tokens");
1223         uint256 availablebalance = getAvailableBalance(_token);
1224         require(_amount <= availablebalance, "not enough tokens");
1225         IERC20(_token).safeTransfer(treasuryaddr, _amount);
1226         emit Treasury(_token, treasuryaddr, _amount);
1227     }
1228 
1229     // Get available token balance that can be put to treasury
1230     // For pools with internal staking, all lpToken balance is contract's
1231     // (bacause user tokens are converted to pool.stakedHoldableToken when depositing)
1232     // HOLY tokens themselves and user lpTokens are protected by this check
1233     function getAvailableBalance(address _token) internal view returns (uint256) {
1234         uint256 availablebalance = IERC20(_token).balanceOf(address(this)) - totalStaked[_token];
1235         uint256 length = poolInfo.length;
1236         for (uint256 pid = 0; pid < length; ++pid) {
1237             PoolInfo storage pool = poolInfo[pid]; //storage pointer used read-only
1238             if (pool.stakeable && address(pool.lpToken) == _token)
1239             {
1240                 availablebalance = IERC20(_token).balanceOf(address(this));
1241                 break;
1242             }
1243         }
1244         return availablebalance;
1245     }
1246 }
1247 
1248 /**
1249  * @dev Implementation of the {IERC20} interface.
1250  *
1251  * This implementation is agnostic to the way tokens are created. This means
1252  * that a supply mechanism has to be added in a derived contract using {_mint}.
1253  * For a generic mechanism see {ERC20PresetMinterPauser}.
1254  *
1255  * TIP: For a detailed writeup see our guide
1256  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1257  * to implement supply mechanisms].
1258  *
1259  * We have followed general OpenZeppelin guidelines: functions revert instead
1260  * of returning `false` on failure. This behavior is nonetheless conventional
1261  * and does not conflict with the expectations of ERC20 applications.
1262  *
1263  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1264  * This allows applications to reconstruct the allowance for all accounts just
1265  * by listening to said events. Other implementations of the EIP may not emit
1266  * these events, as it isn't required by the specification.
1267  *
1268  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1269  * functions have been added to mitigate the well-known issues around setting
1270  * allowances. See {IERC20-approve}.
1271  */
1272 contract ERC20 is Context, IERC20 {
1273     using SafeMath for uint256;
1274     using Address for address;
1275 
1276     mapping (address => uint256) private _balances;
1277 
1278     mapping (address => mapping (address => uint256)) private _allowances;
1279 
1280     uint256 private _totalSupply;
1281 
1282     string private _name;
1283     string private _symbol;
1284     uint8 private _decimals;
1285 
1286     /**
1287      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1288      * a default value of 18.
1289      *
1290      * To select a different value for {decimals}, use {_setupDecimals}.
1291      *
1292      * All three of these values are immutable: they can only be set once during
1293      * construction.
1294      */
1295     constructor (string memory name, string memory symbol) public {
1296         _name = name;
1297         _symbol = symbol;
1298         _decimals = 18;
1299     }
1300 
1301     /**
1302      * @dev Returns the name of the token.
1303      */
1304     function name() public view returns (string memory) {
1305         return _name;
1306     }
1307 
1308     /**
1309      * @dev Returns the symbol of the token, usually a shorter version of the
1310      * name.
1311      */
1312     function symbol() public view returns (string memory) {
1313         return _symbol;
1314     }
1315 
1316     /**
1317      * @dev Returns the number of decimals used to get its user representation.
1318      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1319      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1320      *
1321      * Tokens usually opt for a value of 18, imitating the relationship between
1322      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1323      * called.
1324      *
1325      * NOTE: This information is only used for _display_ purposes: it in
1326      * no way affects any of the arithmetic of the contract, including
1327      * {IERC20-balanceOf} and {IERC20-transfer}.
1328      */
1329     function decimals() public view returns (uint8) {
1330         return _decimals;
1331     }
1332 
1333     /**
1334      * @dev See {IERC20-totalSupply}.
1335      */
1336     function totalSupply() public view override returns (uint256) {
1337         return _totalSupply;
1338     }
1339 
1340     /**
1341      * @dev See {IERC20-balanceOf}.
1342      */
1343     function balanceOf(address account) public view override returns (uint256) {
1344         return _balances[account];
1345     }
1346 
1347     /**
1348      * @dev See {IERC20-transfer}.
1349      *
1350      * Requirements:
1351      *
1352      * - `recipient` cannot be the zero address.
1353      * - the caller must have a balance of at least `amount`.
1354      */
1355     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1356         _transfer(_msgSender(), recipient, amount);
1357         return true;
1358     }
1359 
1360     /**
1361      * @dev See {IERC20-allowance}.
1362      */
1363     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1364         return _allowances[owner][spender];
1365     }
1366 
1367     /**
1368      * @dev See {IERC20-approve}.
1369      *
1370      * Requirements:
1371      *
1372      * - `spender` cannot be the zero address.
1373      */
1374     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1375         _approve(_msgSender(), spender, amount);
1376         return true;
1377     }
1378 
1379     /**
1380      * @dev See {IERC20-transferFrom}.
1381      *
1382      * Emits an {Approval} event indicating the updated allowance. This is not
1383      * required by the EIP. See the note at the beginning of {ERC20};
1384      *
1385      * Requirements:
1386      * - `sender` and `recipient` cannot be the zero address.
1387      * - `sender` must have a balance of at least `amount`.
1388      * - the caller must have allowance for ``sender``'s tokens of at least
1389      * `amount`.
1390      */
1391     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1392         _transfer(sender, recipient, amount);
1393         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1394         return true;
1395     }
1396 
1397     /**
1398      * @dev Atomically increases the allowance granted to `spender` by the caller.
1399      *
1400      * This is an alternative to {approve} that can be used as a mitigation for
1401      * problems described in {IERC20-approve}.
1402      *
1403      * Emits an {Approval} event indicating the updated allowance.
1404      *
1405      * Requirements:
1406      *
1407      * - `spender` cannot be the zero address.
1408      */
1409     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1410         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1411         return true;
1412     }
1413 
1414     /**
1415      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1416      *
1417      * This is an alternative to {approve} that can be used as a mitigation for
1418      * problems described in {IERC20-approve}.
1419      *
1420      * Emits an {Approval} event indicating the updated allowance.
1421      *
1422      * Requirements:
1423      *
1424      * - `spender` cannot be the zero address.
1425      * - `spender` must have allowance for the caller of at least
1426      * `subtractedValue`.
1427      */
1428     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1429         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1430         return true;
1431     }
1432 
1433     /**
1434      * @dev Moves tokens `amount` from `sender` to `recipient`.
1435      *
1436      * This is internal function is equivalent to {transfer}, and can be used to
1437      * e.g. implement automatic token fees, slashing mechanisms, etc.
1438      *
1439      * Emits a {Transfer} event.
1440      *
1441      * Requirements:
1442      *
1443      * - `sender` cannot be the zero address.
1444      * - `recipient` cannot be the zero address.
1445      * - `sender` must have a balance of at least `amount`.
1446      */
1447     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1448         require(sender != address(0), "ERC20: transfer from the zero address");
1449         require(recipient != address(0), "ERC20: transfer to the zero address");
1450 
1451         _beforeTokenTransfer(sender, recipient, amount);
1452 
1453         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1454         _balances[recipient] = _balances[recipient].add(amount);
1455         emit Transfer(sender, recipient, amount);
1456     }
1457 
1458     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1459      * the total supply.
1460      *
1461      * Emits a {Transfer} event with `from` set to the zero address.
1462      *
1463      * Requirements
1464      *
1465      * - `to` cannot be the zero address.
1466      */
1467     function _mint(address account, uint256 amount) internal virtual {
1468         require(account != address(0), "ERC20: mint to the zero address");
1469 
1470         _beforeTokenTransfer(address(0), account, amount);
1471 
1472         _totalSupply = _totalSupply.add(amount);
1473         _balances[account] = _balances[account].add(amount);
1474         emit Transfer(address(0), account, amount);
1475     }
1476 
1477     /**
1478      * @dev Destroys `amount` tokens from `account`, reducing the
1479      * total supply.
1480      *
1481      * Emits a {Transfer} event with `to` set to the zero address.
1482      *
1483      * Requirements
1484      *
1485      * - `account` cannot be the zero address.
1486      * - `account` must have at least `amount` tokens.
1487      */
1488     function _burn(address account, uint256 amount) internal virtual {
1489         require(account != address(0), "ERC20: burn from the zero address");
1490 
1491         _beforeTokenTransfer(account, address(0), amount);
1492 
1493         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1494         _totalSupply = _totalSupply.sub(amount);
1495         emit Transfer(account, address(0), amount);
1496     }
1497 
1498     /**
1499      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1500      *
1501      * This internal function is equivalent to `approve`, and can be used to
1502      * e.g. set automatic allowances for certain subsystems, etc.
1503      *
1504      * Emits an {Approval} event.
1505      *
1506      * Requirements:
1507      *
1508      * - `owner` cannot be the zero address.
1509      * - `spender` cannot be the zero address.
1510      */
1511     function _approve(address owner, address spender, uint256 amount) internal virtual {
1512         require(owner != address(0), "ERC20: approve from the zero address");
1513         require(spender != address(0), "ERC20: approve to the zero address");
1514 
1515         _allowances[owner][spender] = amount;
1516         emit Approval(owner, spender, amount);
1517     }
1518 
1519     /**
1520      * @dev Sets {decimals} to a value other than the default one of 18.
1521      *
1522      * WARNING: This function should only be called from the constructor. Most
1523      * applications that interact with token contracts will not expect
1524      * {decimals} to ever change, and may work incorrectly if it does.
1525      */
1526     function _setupDecimals(uint8 decimals_) internal {
1527         _decimals = decimals_;
1528     }
1529 
1530     /**
1531      * @dev Hook that is called before any transfer of tokens. This includes
1532      * minting and burning.
1533      *
1534      * Calling conditions:
1535      *
1536      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1537      * will be to transferred to `to`.
1538      * - when `from` is zero, `amount` tokens will be minted for `to`.
1539      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1540      * - `from` and `to` are never both zero.
1541      *
1542      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1543      */
1544     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1545 }
1546 
1547 /**
1548  * @dev // Holyheld token is a ERC20 token for Holyheld.
1549  *
1550  * total amount is fixed at 100M HOLY tokens.
1551  * HOLY token does not have mint functions.
1552  * It will allocate upon creation the initial transfers
1553  * of tokens. It is not ownable or having any other
1554  * means of distribution other than transfers in its constructor. 
1555  */
1556 // HolyToken. Ownable, fixed-amount (non-mintable) with governance to be added
1557 contract HolyToken is ERC20("Holyheld", "HOLY") {
1558 
1559     // main developers (founders) multi-sig wallet
1560     // 1 mln tokens
1561     address public founder;
1562 
1563     // Treasury
1564     // accumulates LP yield
1565     address public treasury;
1566 
1567     // weekly vested supply, reclaimable by 2% in a week by founder (WeeklyVested contract)
1568     // 9 mln
1569     address public timeVestedSupply;
1570 
1571     // TVL-growth vested supply, reclaimable by 2% in a week if TVL is a new ATH (TVLVested contract)
1572     // 10 mln
1573     address public growthVestedSupply;
1574 
1575     // main supply, locked for 4 months (TimeVested contract)
1576     // 56 mln
1577     address public mainSupply;
1578     
1579     // Pool supply (ruled by HolyKnight contract)
1580     // 24 mln
1581     address public poolSupply;
1582 
1583     uint public constant AMOUNT_INITLIQUIDITY = 1000000 * 1e18;
1584     uint public constant AMOUNT_OPERATIONS = 9000000 * 1e18;
1585     uint public constant AMOUNT_TEAM = 10000000 * 1e18;
1586     uint public constant DISTRIBUTION_SUPPLY = 24000000 * 1e18;
1587     uint public constant DISTRIBUTION_RESERVE_PERCENT = 20;
1588     uint public constant MAIN_SUPPLY = 56000000 * 1e18;
1589 
1590     uint public constant MAIN_SUPPLY_VESTING_PERIOD = 127 days;
1591     uint public constant VESTING_START = 1602115200; //8 Oct 2020
1592     uint public constant VESTING_START_GROWTH = 1604188800; //1 Nov 2020
1593 
1594     // parameters for HolyKnight construction
1595     uint public constant START_LP_BLOCK = 10950946;
1596     // used for tokens per block calculation to distribute in about 4 months
1597     uint public constant END_LP_BLOCK = 11669960;
1598 
1599     // Constructor code is only run when the contract
1600     // is created
1601     constructor(address _founder, address _treasuryaddr) public {
1602         founder = _founder;	  //address that deployed contract becomes initial founder
1603         treasury = _treasuryaddr; //treasury address is created beforehand
1604 
1605         // Timelock contract will hold main supply for 4 months till Jan 2021
1606 	    mainSupply = address(new HolderTimelock(this, founder, block.timestamp + MAIN_SUPPLY_VESTING_PERIOD));
1607 
1608         // TVL metric based vesting
1609 	    growthVestedSupply = address(new HolderTVLLock(this, founder, VESTING_START_GROWTH));
1610 
1611         // Standard continuous vesting contract
1612 	    timeVestedSupply = address(new HolderVesting(this, founder, VESTING_START, 365 days, false));
1613 
1614         // HOLY token distribution though liquidity mining
1615 	    poolSupply = address(new HolyKnight(this, founder, treasury, DISTRIBUTION_SUPPLY, DISTRIBUTION_RESERVE_PERCENT, START_LP_BLOCK, END_LP_BLOCK));
1616 
1617         //allocate tokens to addresses upon creation, no further minting possible
1618 	    _mint(founder, AMOUNT_INITLIQUIDITY);
1619 	    _mint(timeVestedSupply, AMOUNT_OPERATIONS);
1620 	    _mint(growthVestedSupply, AMOUNT_TEAM);
1621 	    _mint(poolSupply, DISTRIBUTION_SUPPLY);
1622 	    _mint(mainSupply, MAIN_SUPPLY); 
1623     }
1624 }