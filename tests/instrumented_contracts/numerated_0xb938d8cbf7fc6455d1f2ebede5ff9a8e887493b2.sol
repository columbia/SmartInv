1 // Sources flattened with hardhat v2.1.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
85 
86 pragma solidity >=0.6.0 <0.8.0;
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, with an overflow flag.
104      *
105      * _Available since v3.4._
106      */
107     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         uint256 c = a + b;
109         if (c < a) return (false, 0);
110         return (true, c);
111     }
112 
113     /**
114      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
115      *
116      * _Available since v3.4._
117      */
118     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         if (b > a) return (false, 0);
120         return (true, a - b);
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
125      *
126      * _Available since v3.4._
127      */
128     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130         // benefit is lost if 'b' is also tested.
131         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
132         if (a == 0) return (true, 0);
133         uint256 c = a * b;
134         if (c / a != b) return (false, 0);
135         return (true, c);
136     }
137 
138     /**
139      * @dev Returns the division of two unsigned integers, with a division by zero flag.
140      *
141      * _Available since v3.4._
142      */
143     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         if (b == 0) return (false, 0);
145         return (true, a / b);
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         if (b == 0) return (false, 0);
155         return (true, a % b);
156     }
157 
158     /**
159      * @dev Returns the addition of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `+` operator.
163      *
164      * Requirements:
165      *
166      * - Addition cannot overflow.
167      */
168     function add(uint256 a, uint256 b) internal pure returns (uint256) {
169         uint256 c = a + b;
170         require(c >= a, "SafeMath: addition overflow");
171         return c;
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting on
176      * overflow (when the result is negative).
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b <= a, "SafeMath: subtraction overflow");
186         return a - b;
187     }
188 
189     /**
190      * @dev Returns the multiplication of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `*` operator.
194      *
195      * Requirements:
196      *
197      * - Multiplication cannot overflow.
198      */
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         if (a == 0) return 0;
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203         return c;
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers, reverting on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         require(b > 0, "SafeMath: division by zero");
220         return a / b;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * reverting when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         require(b > 0, "SafeMath: modulo by zero");
237         return a % b;
238     }
239 
240     /**
241      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
242      * overflow (when the result is negative).
243      *
244      * CAUTION: This function is deprecated because it requires allocating memory for the error
245      * message unnecessarily. For custom revert reasons use {trySub}.
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      *
251      * - Subtraction cannot overflow.
252      */
253     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b <= a, errorMessage);
255         return a - b;
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
260      * division by zero. The result is rounded towards zero.
261      *
262      * CAUTION: This function is deprecated because it requires allocating memory for the error
263      * message unnecessarily. For custom revert reasons use {tryDiv}.
264      *
265      * Counterpart to Solidity's `/` operator. Note: this function uses a
266      * `revert` opcode (which leaves remaining gas untouched) while Solidity
267      * uses an invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b > 0, errorMessage);
275         return a / b;
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * reverting with custom message when dividing by zero.
281      *
282      * CAUTION: This function is deprecated because it requires allocating memory for the error
283      * message unnecessarily. For custom revert reasons use {tryMod}.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b > 0, errorMessage);
295         return a % b;
296     }
297 }
298 
299 
300 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
301 
302 pragma solidity >=0.6.2 <0.8.0;
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
326         // This method relies on extcodesize, which returns 0 for contracts in
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
389         return functionCallWithValue(target, data, 0, errorMessage);
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
415         require(isContract(target), "Address: call to non-contract");
416 
417         // solhint-disable-next-line avoid-low-level-calls
418         (bool success, bytes memory returndata) = target.call{ value: value }(data);
419         return _verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
429         return functionStaticCall(target, data, "Address: low-level static call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
439         require(isContract(target), "Address: static call to non-contract");
440 
441         // solhint-disable-next-line avoid-low-level-calls
442         (bool success, bytes memory returndata) = target.staticcall(data);
443         return _verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
453         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
463         require(isContract(target), "Address: delegate call to non-contract");
464 
465         // solhint-disable-next-line avoid-low-level-calls
466         (bool success, bytes memory returndata) = target.delegatecall(data);
467         return _verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
471         if (success) {
472             return returndata;
473         } else {
474             // Look for revert reason and bubble it up if present
475             if (returndata.length > 0) {
476                 // The easiest way to bubble the revert reason is using memory via assembly
477 
478                 // solhint-disable-next-line no-inline-assembly
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 
491 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
492 
493 pragma solidity >=0.6.0 <0.8.0;
494 
495 
496 
497 /**
498  * @title SafeERC20
499  * @dev Wrappers around ERC20 operations that throw on failure (when the token
500  * contract returns false). Tokens that return no value (and instead revert or
501  * throw on failure) are also supported, non-reverting calls are assumed to be
502  * successful.
503  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
504  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
505  */
506 library SafeERC20 {
507     using SafeMath for uint256;
508     using Address for address;
509 
510     function safeTransfer(IERC20 token, address to, uint256 value) internal {
511         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
512     }
513 
514     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
515         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
516     }
517 
518     /**
519      * @dev Deprecated. This function has issues similar to the ones found in
520      * {IERC20-approve}, and its usage is discouraged.
521      *
522      * Whenever possible, use {safeIncreaseAllowance} and
523      * {safeDecreaseAllowance} instead.
524      */
525     function safeApprove(IERC20 token, address spender, uint256 value) internal {
526         // safeApprove should only be called when setting an initial allowance,
527         // or when resetting it to zero. To increase and decrease it, use
528         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
529         // solhint-disable-next-line max-line-length
530         require((value == 0) || (token.allowance(address(this), spender) == 0),
531             "SafeERC20: approve from non-zero to non-zero allowance"
532         );
533         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
534     }
535 
536     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
537         uint256 newAllowance = token.allowance(address(this), spender).add(value);
538         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
539     }
540 
541     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
542         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
543         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
544     }
545 
546     /**
547      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
548      * on the return value: the return value is optional (but if data is returned, it must not be false).
549      * @param token The token targeted by the call.
550      * @param data The call data (encoded using abi.encode or one of its variants).
551      */
552     function _callOptionalReturn(IERC20 token, bytes memory data) private {
553         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
554         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
555         // the target address contains contract code and also asserts for success in the low-level call.
556 
557         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
558         if (returndata.length > 0) { // Return data is optional
559             // solhint-disable-next-line max-line-length
560             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
561         }
562     }
563 }
564 
565 
566 // File contracts/interfaces/IDetailedERC20.sol
567 
568 pragma solidity ^0.6.12;
569 
570 interface IDetailedERC20 is IERC20 {
571   function name() external returns (string memory);
572   function symbol() external returns (string memory);
573   function decimals() external returns (uint8);
574 }
575 
576 
577 // File contracts/interfaces/IMintableERC20.sol
578 
579 pragma solidity ^0.6.12;
580 
581 interface IMintableERC20 is IDetailedERC20{
582   function mint(address _recipient, uint256 _amount) external;
583   function burnFrom(address account, uint256 amount) external;
584   function lowerHasMinted(uint256 amount)external;
585 }
586 
587 
588 // File contracts/interfaces/IRewardVesting.sol
589 
590 pragma solidity ^0.6.12;
591 
592 interface IRewardVesting  {
593     function addEarning(address user, uint256 amount) external;
594     function userBalances(address user) external view returns (uint256 bal);
595 }
596 
597 
598 // File hardhat/console.sol@v2.1.1
599 
600 pragma solidity >= 0.4.22 <0.9.0;
601 
602 library console {
603 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
604 
605 	function _sendLogPayload(bytes memory payload) private view {
606 		uint256 payloadLength = payload.length;
607 		address consoleAddress = CONSOLE_ADDRESS;
608 		assembly {
609 			let payloadStart := add(payload, 32)
610 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
611 		}
612 	}
613 
614 	function log() internal view {
615 		_sendLogPayload(abi.encodeWithSignature("log()"));
616 	}
617 
618 	function logInt(int p0) internal view {
619 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
620 	}
621 
622 	function logUint(uint p0) internal view {
623 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
624 	}
625 
626 	function logString(string memory p0) internal view {
627 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
628 	}
629 
630 	function logBool(bool p0) internal view {
631 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
632 	}
633 
634 	function logAddress(address p0) internal view {
635 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
636 	}
637 
638 	function logBytes(bytes memory p0) internal view {
639 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
640 	}
641 
642 	function logBytes1(bytes1 p0) internal view {
643 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
644 	}
645 
646 	function logBytes2(bytes2 p0) internal view {
647 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
648 	}
649 
650 	function logBytes3(bytes3 p0) internal view {
651 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
652 	}
653 
654 	function logBytes4(bytes4 p0) internal view {
655 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
656 	}
657 
658 	function logBytes5(bytes5 p0) internal view {
659 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
660 	}
661 
662 	function logBytes6(bytes6 p0) internal view {
663 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
664 	}
665 
666 	function logBytes7(bytes7 p0) internal view {
667 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
668 	}
669 
670 	function logBytes8(bytes8 p0) internal view {
671 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
672 	}
673 
674 	function logBytes9(bytes9 p0) internal view {
675 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
676 	}
677 
678 	function logBytes10(bytes10 p0) internal view {
679 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
680 	}
681 
682 	function logBytes11(bytes11 p0) internal view {
683 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
684 	}
685 
686 	function logBytes12(bytes12 p0) internal view {
687 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
688 	}
689 
690 	function logBytes13(bytes13 p0) internal view {
691 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
692 	}
693 
694 	function logBytes14(bytes14 p0) internal view {
695 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
696 	}
697 
698 	function logBytes15(bytes15 p0) internal view {
699 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
700 	}
701 
702 	function logBytes16(bytes16 p0) internal view {
703 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
704 	}
705 
706 	function logBytes17(bytes17 p0) internal view {
707 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
708 	}
709 
710 	function logBytes18(bytes18 p0) internal view {
711 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
712 	}
713 
714 	function logBytes19(bytes19 p0) internal view {
715 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
716 	}
717 
718 	function logBytes20(bytes20 p0) internal view {
719 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
720 	}
721 
722 	function logBytes21(bytes21 p0) internal view {
723 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
724 	}
725 
726 	function logBytes22(bytes22 p0) internal view {
727 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
728 	}
729 
730 	function logBytes23(bytes23 p0) internal view {
731 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
732 	}
733 
734 	function logBytes24(bytes24 p0) internal view {
735 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
736 	}
737 
738 	function logBytes25(bytes25 p0) internal view {
739 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
740 	}
741 
742 	function logBytes26(bytes26 p0) internal view {
743 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
744 	}
745 
746 	function logBytes27(bytes27 p0) internal view {
747 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
748 	}
749 
750 	function logBytes28(bytes28 p0) internal view {
751 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
752 	}
753 
754 	function logBytes29(bytes29 p0) internal view {
755 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
756 	}
757 
758 	function logBytes30(bytes30 p0) internal view {
759 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
760 	}
761 
762 	function logBytes31(bytes31 p0) internal view {
763 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
764 	}
765 
766 	function logBytes32(bytes32 p0) internal view {
767 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
768 	}
769 
770 	function log(uint p0) internal view {
771 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
772 	}
773 
774 	function log(string memory p0) internal view {
775 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
776 	}
777 
778 	function log(bool p0) internal view {
779 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
780 	}
781 
782 	function log(address p0) internal view {
783 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
784 	}
785 
786 	function log(uint p0, uint p1) internal view {
787 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
788 	}
789 
790 	function log(uint p0, string memory p1) internal view {
791 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
792 	}
793 
794 	function log(uint p0, bool p1) internal view {
795 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
796 	}
797 
798 	function log(uint p0, address p1) internal view {
799 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
800 	}
801 
802 	function log(string memory p0, uint p1) internal view {
803 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
804 	}
805 
806 	function log(string memory p0, string memory p1) internal view {
807 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
808 	}
809 
810 	function log(string memory p0, bool p1) internal view {
811 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
812 	}
813 
814 	function log(string memory p0, address p1) internal view {
815 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
816 	}
817 
818 	function log(bool p0, uint p1) internal view {
819 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
820 	}
821 
822 	function log(bool p0, string memory p1) internal view {
823 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
824 	}
825 
826 	function log(bool p0, bool p1) internal view {
827 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
828 	}
829 
830 	function log(bool p0, address p1) internal view {
831 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
832 	}
833 
834 	function log(address p0, uint p1) internal view {
835 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
836 	}
837 
838 	function log(address p0, string memory p1) internal view {
839 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
840 	}
841 
842 	function log(address p0, bool p1) internal view {
843 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
844 	}
845 
846 	function log(address p0, address p1) internal view {
847 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
848 	}
849 
850 	function log(uint p0, uint p1, uint p2) internal view {
851 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
852 	}
853 
854 	function log(uint p0, uint p1, string memory p2) internal view {
855 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
856 	}
857 
858 	function log(uint p0, uint p1, bool p2) internal view {
859 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
860 	}
861 
862 	function log(uint p0, uint p1, address p2) internal view {
863 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
864 	}
865 
866 	function log(uint p0, string memory p1, uint p2) internal view {
867 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
868 	}
869 
870 	function log(uint p0, string memory p1, string memory p2) internal view {
871 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
872 	}
873 
874 	function log(uint p0, string memory p1, bool p2) internal view {
875 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
876 	}
877 
878 	function log(uint p0, string memory p1, address p2) internal view {
879 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
880 	}
881 
882 	function log(uint p0, bool p1, uint p2) internal view {
883 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
884 	}
885 
886 	function log(uint p0, bool p1, string memory p2) internal view {
887 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
888 	}
889 
890 	function log(uint p0, bool p1, bool p2) internal view {
891 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
892 	}
893 
894 	function log(uint p0, bool p1, address p2) internal view {
895 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
896 	}
897 
898 	function log(uint p0, address p1, uint p2) internal view {
899 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
900 	}
901 
902 	function log(uint p0, address p1, string memory p2) internal view {
903 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
904 	}
905 
906 	function log(uint p0, address p1, bool p2) internal view {
907 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
908 	}
909 
910 	function log(uint p0, address p1, address p2) internal view {
911 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
912 	}
913 
914 	function log(string memory p0, uint p1, uint p2) internal view {
915 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
916 	}
917 
918 	function log(string memory p0, uint p1, string memory p2) internal view {
919 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
920 	}
921 
922 	function log(string memory p0, uint p1, bool p2) internal view {
923 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
924 	}
925 
926 	function log(string memory p0, uint p1, address p2) internal view {
927 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
928 	}
929 
930 	function log(string memory p0, string memory p1, uint p2) internal view {
931 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
932 	}
933 
934 	function log(string memory p0, string memory p1, string memory p2) internal view {
935 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
936 	}
937 
938 	function log(string memory p0, string memory p1, bool p2) internal view {
939 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
940 	}
941 
942 	function log(string memory p0, string memory p1, address p2) internal view {
943 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
944 	}
945 
946 	function log(string memory p0, bool p1, uint p2) internal view {
947 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
948 	}
949 
950 	function log(string memory p0, bool p1, string memory p2) internal view {
951 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
952 	}
953 
954 	function log(string memory p0, bool p1, bool p2) internal view {
955 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
956 	}
957 
958 	function log(string memory p0, bool p1, address p2) internal view {
959 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
960 	}
961 
962 	function log(string memory p0, address p1, uint p2) internal view {
963 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
964 	}
965 
966 	function log(string memory p0, address p1, string memory p2) internal view {
967 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
968 	}
969 
970 	function log(string memory p0, address p1, bool p2) internal view {
971 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
972 	}
973 
974 	function log(string memory p0, address p1, address p2) internal view {
975 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
976 	}
977 
978 	function log(bool p0, uint p1, uint p2) internal view {
979 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
980 	}
981 
982 	function log(bool p0, uint p1, string memory p2) internal view {
983 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
984 	}
985 
986 	function log(bool p0, uint p1, bool p2) internal view {
987 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
988 	}
989 
990 	function log(bool p0, uint p1, address p2) internal view {
991 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
992 	}
993 
994 	function log(bool p0, string memory p1, uint p2) internal view {
995 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
996 	}
997 
998 	function log(bool p0, string memory p1, string memory p2) internal view {
999 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1000 	}
1001 
1002 	function log(bool p0, string memory p1, bool p2) internal view {
1003 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1004 	}
1005 
1006 	function log(bool p0, string memory p1, address p2) internal view {
1007 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1008 	}
1009 
1010 	function log(bool p0, bool p1, uint p2) internal view {
1011 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1012 	}
1013 
1014 	function log(bool p0, bool p1, string memory p2) internal view {
1015 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1016 	}
1017 
1018 	function log(bool p0, bool p1, bool p2) internal view {
1019 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1020 	}
1021 
1022 	function log(bool p0, bool p1, address p2) internal view {
1023 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1024 	}
1025 
1026 	function log(bool p0, address p1, uint p2) internal view {
1027 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1028 	}
1029 
1030 	function log(bool p0, address p1, string memory p2) internal view {
1031 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1032 	}
1033 
1034 	function log(bool p0, address p1, bool p2) internal view {
1035 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1036 	}
1037 
1038 	function log(bool p0, address p1, address p2) internal view {
1039 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1040 	}
1041 
1042 	function log(address p0, uint p1, uint p2) internal view {
1043 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1044 	}
1045 
1046 	function log(address p0, uint p1, string memory p2) internal view {
1047 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1048 	}
1049 
1050 	function log(address p0, uint p1, bool p2) internal view {
1051 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1052 	}
1053 
1054 	function log(address p0, uint p1, address p2) internal view {
1055 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1056 	}
1057 
1058 	function log(address p0, string memory p1, uint p2) internal view {
1059 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1060 	}
1061 
1062 	function log(address p0, string memory p1, string memory p2) internal view {
1063 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1064 	}
1065 
1066 	function log(address p0, string memory p1, bool p2) internal view {
1067 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1068 	}
1069 
1070 	function log(address p0, string memory p1, address p2) internal view {
1071 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1072 	}
1073 
1074 	function log(address p0, bool p1, uint p2) internal view {
1075 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1076 	}
1077 
1078 	function log(address p0, bool p1, string memory p2) internal view {
1079 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1080 	}
1081 
1082 	function log(address p0, bool p1, bool p2) internal view {
1083 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1084 	}
1085 
1086 	function log(address p0, bool p1, address p2) internal view {
1087 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1088 	}
1089 
1090 	function log(address p0, address p1, uint p2) internal view {
1091 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1092 	}
1093 
1094 	function log(address p0, address p1, string memory p2) internal view {
1095 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1096 	}
1097 
1098 	function log(address p0, address p1, bool p2) internal view {
1099 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1100 	}
1101 
1102 	function log(address p0, address p1, address p2) internal view {
1103 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1104 	}
1105 
1106 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1107 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1108 	}
1109 
1110 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1111 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1112 	}
1113 
1114 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1115 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1116 	}
1117 
1118 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1119 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1120 	}
1121 
1122 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1123 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1124 	}
1125 
1126 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1127 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1128 	}
1129 
1130 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1131 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1132 	}
1133 
1134 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1135 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1136 	}
1137 
1138 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1139 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1140 	}
1141 
1142 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1143 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1144 	}
1145 
1146 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1147 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1148 	}
1149 
1150 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1151 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1152 	}
1153 
1154 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1155 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1156 	}
1157 
1158 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1159 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1160 	}
1161 
1162 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1163 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1164 	}
1165 
1166 	function log(uint p0, uint p1, address p2, address p3) internal view {
1167 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1168 	}
1169 
1170 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1171 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1172 	}
1173 
1174 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1175 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1176 	}
1177 
1178 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1179 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1180 	}
1181 
1182 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1183 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1184 	}
1185 
1186 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1187 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1188 	}
1189 
1190 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1191 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1192 	}
1193 
1194 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1195 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1196 	}
1197 
1198 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1199 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1200 	}
1201 
1202 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1203 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1204 	}
1205 
1206 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1207 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1208 	}
1209 
1210 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1211 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1212 	}
1213 
1214 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1215 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1216 	}
1217 
1218 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1219 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1220 	}
1221 
1222 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1223 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1224 	}
1225 
1226 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1227 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1228 	}
1229 
1230 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1231 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1232 	}
1233 
1234 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1235 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1236 	}
1237 
1238 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1239 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1240 	}
1241 
1242 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1243 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1244 	}
1245 
1246 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1247 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1248 	}
1249 
1250 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1251 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1252 	}
1253 
1254 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1255 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1256 	}
1257 
1258 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1259 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1260 	}
1261 
1262 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1263 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1264 	}
1265 
1266 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1267 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1268 	}
1269 
1270 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1271 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1272 	}
1273 
1274 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1275 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1276 	}
1277 
1278 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1279 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1280 	}
1281 
1282 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1283 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1284 	}
1285 
1286 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1287 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1288 	}
1289 
1290 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1291 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1292 	}
1293 
1294 	function log(uint p0, bool p1, address p2, address p3) internal view {
1295 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1296 	}
1297 
1298 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1299 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1300 	}
1301 
1302 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1303 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1304 	}
1305 
1306 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1307 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1308 	}
1309 
1310 	function log(uint p0, address p1, uint p2, address p3) internal view {
1311 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1312 	}
1313 
1314 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1315 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1316 	}
1317 
1318 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1319 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1320 	}
1321 
1322 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1323 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1324 	}
1325 
1326 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1327 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1328 	}
1329 
1330 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1331 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1332 	}
1333 
1334 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1335 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1336 	}
1337 
1338 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1339 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1340 	}
1341 
1342 	function log(uint p0, address p1, bool p2, address p3) internal view {
1343 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1344 	}
1345 
1346 	function log(uint p0, address p1, address p2, uint p3) internal view {
1347 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1348 	}
1349 
1350 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1351 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1352 	}
1353 
1354 	function log(uint p0, address p1, address p2, bool p3) internal view {
1355 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1356 	}
1357 
1358 	function log(uint p0, address p1, address p2, address p3) internal view {
1359 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1360 	}
1361 
1362 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1363 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1364 	}
1365 
1366 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1367 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1368 	}
1369 
1370 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1371 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1372 	}
1373 
1374 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1375 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1376 	}
1377 
1378 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1379 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1380 	}
1381 
1382 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1383 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1384 	}
1385 
1386 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1387 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1388 	}
1389 
1390 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1391 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1392 	}
1393 
1394 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1395 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1396 	}
1397 
1398 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1399 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1400 	}
1401 
1402 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1403 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1404 	}
1405 
1406 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1407 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1408 	}
1409 
1410 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1411 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1412 	}
1413 
1414 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1415 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1416 	}
1417 
1418 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1419 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1420 	}
1421 
1422 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1423 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1424 	}
1425 
1426 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1427 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1428 	}
1429 
1430 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1431 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1432 	}
1433 
1434 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1435 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1436 	}
1437 
1438 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1439 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1440 	}
1441 
1442 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1443 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1444 	}
1445 
1446 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1447 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1448 	}
1449 
1450 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1451 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1452 	}
1453 
1454 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1455 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1456 	}
1457 
1458 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1459 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1460 	}
1461 
1462 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1463 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1464 	}
1465 
1466 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1467 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1468 	}
1469 
1470 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1471 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1472 	}
1473 
1474 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1475 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1476 	}
1477 
1478 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1479 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1480 	}
1481 
1482 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1483 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1484 	}
1485 
1486 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1487 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1488 	}
1489 
1490 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1491 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1492 	}
1493 
1494 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1495 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1496 	}
1497 
1498 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1499 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1500 	}
1501 
1502 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1503 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1504 	}
1505 
1506 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1507 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1508 	}
1509 
1510 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1511 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1512 	}
1513 
1514 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1515 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1516 	}
1517 
1518 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1519 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1520 	}
1521 
1522 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1523 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1524 	}
1525 
1526 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1527 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1528 	}
1529 
1530 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1531 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1532 	}
1533 
1534 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1535 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1536 	}
1537 
1538 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1539 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1540 	}
1541 
1542 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1543 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1544 	}
1545 
1546 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1547 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1548 	}
1549 
1550 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1551 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1552 	}
1553 
1554 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1555 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1556 	}
1557 
1558 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1559 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1560 	}
1561 
1562 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1563 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1564 	}
1565 
1566 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1567 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1568 	}
1569 
1570 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1571 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1572 	}
1573 
1574 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1575 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1576 	}
1577 
1578 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1579 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1580 	}
1581 
1582 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1583 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1584 	}
1585 
1586 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1587 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1588 	}
1589 
1590 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1591 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1592 	}
1593 
1594 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1595 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1596 	}
1597 
1598 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1599 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1600 	}
1601 
1602 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1603 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1604 	}
1605 
1606 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1607 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1608 	}
1609 
1610 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1611 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1612 	}
1613 
1614 	function log(string memory p0, address p1, address p2, address p3) internal view {
1615 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1616 	}
1617 
1618 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1619 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1620 	}
1621 
1622 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1623 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1624 	}
1625 
1626 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1627 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1628 	}
1629 
1630 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1631 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1632 	}
1633 
1634 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1635 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1636 	}
1637 
1638 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1639 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1640 	}
1641 
1642 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1643 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1644 	}
1645 
1646 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1647 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1648 	}
1649 
1650 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1651 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1652 	}
1653 
1654 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1655 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1656 	}
1657 
1658 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1659 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1660 	}
1661 
1662 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1663 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1664 	}
1665 
1666 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1667 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1668 	}
1669 
1670 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1671 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1672 	}
1673 
1674 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1675 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1676 	}
1677 
1678 	function log(bool p0, uint p1, address p2, address p3) internal view {
1679 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1680 	}
1681 
1682 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1683 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1684 	}
1685 
1686 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1687 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1688 	}
1689 
1690 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1691 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1692 	}
1693 
1694 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1695 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1696 	}
1697 
1698 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1699 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1700 	}
1701 
1702 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1703 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1704 	}
1705 
1706 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1707 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1708 	}
1709 
1710 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1711 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1712 	}
1713 
1714 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1715 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1716 	}
1717 
1718 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1719 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1720 	}
1721 
1722 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1723 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1724 	}
1725 
1726 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1727 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1728 	}
1729 
1730 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1731 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1732 	}
1733 
1734 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1735 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1736 	}
1737 
1738 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1739 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1740 	}
1741 
1742 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1743 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1744 	}
1745 
1746 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1747 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1748 	}
1749 
1750 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1751 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1752 	}
1753 
1754 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1755 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1756 	}
1757 
1758 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1759 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1760 	}
1761 
1762 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1763 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1764 	}
1765 
1766 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1767 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1768 	}
1769 
1770 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1771 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1772 	}
1773 
1774 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1775 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1776 	}
1777 
1778 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1779 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1780 	}
1781 
1782 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1783 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1784 	}
1785 
1786 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1787 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1788 	}
1789 
1790 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1791 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1792 	}
1793 
1794 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1795 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1796 	}
1797 
1798 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1799 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1800 	}
1801 
1802 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1803 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1804 	}
1805 
1806 	function log(bool p0, bool p1, address p2, address p3) internal view {
1807 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1808 	}
1809 
1810 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1811 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1812 	}
1813 
1814 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1815 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1816 	}
1817 
1818 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1819 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1820 	}
1821 
1822 	function log(bool p0, address p1, uint p2, address p3) internal view {
1823 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1824 	}
1825 
1826 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1827 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1828 	}
1829 
1830 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1831 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1832 	}
1833 
1834 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1835 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1836 	}
1837 
1838 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1839 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1840 	}
1841 
1842 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1843 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1844 	}
1845 
1846 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1847 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1848 	}
1849 
1850 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1851 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1852 	}
1853 
1854 	function log(bool p0, address p1, bool p2, address p3) internal view {
1855 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1856 	}
1857 
1858 	function log(bool p0, address p1, address p2, uint p3) internal view {
1859 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1860 	}
1861 
1862 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1863 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1864 	}
1865 
1866 	function log(bool p0, address p1, address p2, bool p3) internal view {
1867 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1868 	}
1869 
1870 	function log(bool p0, address p1, address p2, address p3) internal view {
1871 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1872 	}
1873 
1874 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1875 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1876 	}
1877 
1878 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1879 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1880 	}
1881 
1882 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1883 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1884 	}
1885 
1886 	function log(address p0, uint p1, uint p2, address p3) internal view {
1887 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1888 	}
1889 
1890 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1891 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1892 	}
1893 
1894 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1895 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1896 	}
1897 
1898 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1899 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1900 	}
1901 
1902 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1903 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1904 	}
1905 
1906 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1907 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1908 	}
1909 
1910 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1911 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1912 	}
1913 
1914 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1915 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1916 	}
1917 
1918 	function log(address p0, uint p1, bool p2, address p3) internal view {
1919 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1920 	}
1921 
1922 	function log(address p0, uint p1, address p2, uint p3) internal view {
1923 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1924 	}
1925 
1926 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1927 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1928 	}
1929 
1930 	function log(address p0, uint p1, address p2, bool p3) internal view {
1931 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1932 	}
1933 
1934 	function log(address p0, uint p1, address p2, address p3) internal view {
1935 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1936 	}
1937 
1938 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1939 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1940 	}
1941 
1942 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1943 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1944 	}
1945 
1946 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1947 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1948 	}
1949 
1950 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1951 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1952 	}
1953 
1954 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1955 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1956 	}
1957 
1958 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1959 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1960 	}
1961 
1962 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1963 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1964 	}
1965 
1966 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1967 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1968 	}
1969 
1970 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1971 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1972 	}
1973 
1974 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1975 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1976 	}
1977 
1978 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1979 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1980 	}
1981 
1982 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1983 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1984 	}
1985 
1986 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1987 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1988 	}
1989 
1990 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1991 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1992 	}
1993 
1994 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1995 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1996 	}
1997 
1998 	function log(address p0, string memory p1, address p2, address p3) internal view {
1999 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2000 	}
2001 
2002 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2003 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2004 	}
2005 
2006 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2007 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2008 	}
2009 
2010 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2011 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2012 	}
2013 
2014 	function log(address p0, bool p1, uint p2, address p3) internal view {
2015 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2016 	}
2017 
2018 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2019 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2020 	}
2021 
2022 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2023 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2024 	}
2025 
2026 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2027 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2028 	}
2029 
2030 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2031 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2032 	}
2033 
2034 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2035 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2036 	}
2037 
2038 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2039 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2040 	}
2041 
2042 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2043 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2044 	}
2045 
2046 	function log(address p0, bool p1, bool p2, address p3) internal view {
2047 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2048 	}
2049 
2050 	function log(address p0, bool p1, address p2, uint p3) internal view {
2051 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2052 	}
2053 
2054 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2055 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2056 	}
2057 
2058 	function log(address p0, bool p1, address p2, bool p3) internal view {
2059 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2060 	}
2061 
2062 	function log(address p0, bool p1, address p2, address p3) internal view {
2063 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2064 	}
2065 
2066 	function log(address p0, address p1, uint p2, uint p3) internal view {
2067 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2068 	}
2069 
2070 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2071 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2072 	}
2073 
2074 	function log(address p0, address p1, uint p2, bool p3) internal view {
2075 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2076 	}
2077 
2078 	function log(address p0, address p1, uint p2, address p3) internal view {
2079 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2080 	}
2081 
2082 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2083 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2084 	}
2085 
2086 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2087 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2088 	}
2089 
2090 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2091 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2092 	}
2093 
2094 	function log(address p0, address p1, string memory p2, address p3) internal view {
2095 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2096 	}
2097 
2098 	function log(address p0, address p1, bool p2, uint p3) internal view {
2099 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2100 	}
2101 
2102 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2103 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2104 	}
2105 
2106 	function log(address p0, address p1, bool p2, bool p3) internal view {
2107 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2108 	}
2109 
2110 	function log(address p0, address p1, bool p2, address p3) internal view {
2111 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2112 	}
2113 
2114 	function log(address p0, address p1, address p2, uint p3) internal view {
2115 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2116 	}
2117 
2118 	function log(address p0, address p1, address p2, string memory p3) internal view {
2119 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2120 	}
2121 
2122 	function log(address p0, address p1, address p2, bool p3) internal view {
2123 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2124 	}
2125 
2126 	function log(address p0, address p1, address p2, address p3) internal view {
2127 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2128 	}
2129 
2130 }
2131 
2132 
2133 // File contracts/VotingEscrow.sol
2134 
2135 pragma solidity 0.6.12;
2136 
2137 
2138 
2139 
2140 
2141 
2142 
2143 contract VotingEscrow is IERC20 {
2144 
2145     using SafeMath for uint256;
2146     using SafeERC20 for IERC20;
2147 
2148     IMintableERC20 public wasabi;
2149 
2150     address[] public rewardTokens;
2151     /// @dev A mapping of all added reward tokens.
2152     mapping(address => bool) public rewardTokensList;
2153     /// @dev A mapping of the need vesting boolean mapped by reward token.
2154     mapping(address => bool) public rewardsNeedVesting;
2155     /// @dev A mapping of the vesting contract mapped by reward token.
2156     mapping(address => address) public rewardVestingsList;
2157 
2158     address public collector;
2159 
2160     /// @dev The address of the account which currently has administrative capabilities over this contract.
2161     address public governance;
2162     address public pendingGovernance;
2163     /// @dev A flag indicating if the contract has been initialized yet.
2164     bool public initialized;
2165 
2166     uint256 private _totalSupply;
2167     mapping (address => uint256) private _balances;
2168     string private _name;
2169     string private _symbol;
2170     uint8 private _decimals;
2171 
2172     uint256 public constant MAX_TIME = 1440 days;
2173 
2174     enum LockDays { ONEWEEK,ONEMONTH,THREEMONTH,SIXMONTH,ONEYEAR,FOURYEAR}
2175     enum ExtendDays { ONEWEEK,ONEMONTH,THREEMONTH,SIXMONTH,ONEYEAR,FOURYEAR }
2176     mapping (LockDays => uint256) private _lockDays;
2177     mapping (ExtendDays => uint256) private _extendDays;
2178 
2179     struct LockData {
2180         uint256 amount;
2181         uint256 start;
2182         uint256 end;
2183     }
2184     mapping (address => LockData) private _locks;
2185     uint256 public totalLockedWASABI;
2186 
2187     uint256 public wasabiRewardRate;
2188     bool public wasabiNeedVesting;
2189     address public wasabiVestingAddress;
2190     uint256 lastRewardBlock; //Last block number that Wasabi distribution occurs.
2191     uint256 private _accWasabiRewardPerBalance;
2192     mapping (address => uint256) private _wasabiRewardDebts;
2193 
2194 
2195     mapping (address => uint256) private _accRewardPerBalance;
2196     /// @dev A mapping of all of the user reward debt mapped first by reward token and then by address.
2197     mapping(address => mapping(address => uint256)) private _rewardDebt;
2198 
2199     event LockCreate(address indexed user, uint256 amount, uint256 veAmount, uint256 lockStart, uint256 lockEnd);
2200     event LockExtend(address indexed user, uint256 amount, uint256 veAmount, uint256 lockStart, uint256 lockEnd);
2201     event LockIncreaseAmount(address indexed user, uint256 amount, uint256 veAmount, uint256 lockStart, uint256 lockEnd);
2202     event Withdraw(address indexed user, uint256 amount);
2203     event PendingGovernanceUpdated(address pendingGovernance);
2204     event GovernanceUpdated(address governance);
2205     event RewardTokenAdded(address rewardToken, address rewardVesting, bool needVesting);
2206     event RewardTokenUpdated(address rewardToken, address rewardVesting, bool needVesting);
2207     event CollectorUpdated(address collector);
2208     event WasabiRewardRateUpdated(uint256 wasabiRewardRate);
2209     event WasabiVestingUpdated(bool needVesting, address vestingAddress);
2210 
2211     // solium-disable-next-line
2212     constructor(address _governance) public {
2213         require(_governance != address(0), "VotingEscrow: governance address cannot be 0x0");
2214         governance = _governance;
2215     }
2216 
2217     /*
2218      * Owner methods
2219      */
2220     function initialize(IMintableERC20 _wasabi,
2221                         uint256 _wasabiRewardRate, bool _wasabiNeedVesting, address _wasabiVestingAddress,
2222                         address[] memory _rewardTokens, address[] memory _rewardVestings, bool[] memory _needVestings,
2223                         address _collector) external onlyGovernance {
2224         require(!initialized, "VotingEscrow: already initialized");
2225         require(_rewardTokens.length == _rewardVestings.length, "VotingEscrow: reward token and reward vesting length mismatch");
2226         require(_rewardTokens.length == _needVestings.length, "VotingEscrow: reward token and need vesting length mismatch");
2227         require(_collector != address(0), "VotingEscrow: collector address cannot be 0x0");
2228 
2229         if (_wasabiNeedVesting) {
2230             require(_wasabiVestingAddress != address(0), "VotingEscrow: wasabi vesting contract address cannot be 0x0 if wasabi requires vesting");
2231         }
2232 
2233         _name = "Voting Escrow Wasabi Token";
2234         _symbol = "veWasabi";
2235         _decimals = 18;
2236         wasabi = _wasabi;
2237         wasabiRewardRate = _wasabiRewardRate;
2238         wasabiNeedVesting = _wasabiNeedVesting;
2239         wasabiVestingAddress = _wasabiVestingAddress;
2240 
2241         for (uint i=0; i<_rewardTokens.length; i++) {
2242             address rewardToken = _rewardTokens[i];
2243             bool needVesting = _needVestings[i];
2244             address rewardVesting = _rewardVestings[i];
2245             if (!rewardTokensList[rewardToken]) {
2246                 rewardTokensList[rewardToken] = true;
2247                 rewardTokens.push(rewardToken);
2248                 rewardsNeedVesting[rewardToken] = needVesting;
2249                 if (needVesting) {
2250                     require(rewardVesting != address(0), "VotingEscrow: reward vesting contract address cannot be 0x0");
2251                 }
2252                 rewardVestingsList[rewardToken] = rewardVesting;
2253             }
2254         }
2255 
2256         collector = _collector;
2257         initialized = true;
2258         lastRewardBlock = block.number;
2259 
2260         _lockDays[LockDays.ONEWEEK] = 7 days;
2261         _lockDays[LockDays.ONEMONTH] = 30 days;
2262         _lockDays[LockDays.THREEMONTH] = 90 days;
2263         _lockDays[LockDays.SIXMONTH] = 180 days;
2264         _lockDays[LockDays.ONEYEAR] = 360 days;
2265         _lockDays[LockDays.FOURYEAR] = 1440 days;
2266 
2267         _extendDays[ExtendDays.ONEWEEK] = 7 days;
2268         _extendDays[ExtendDays.ONEMONTH] = 30 days;
2269         _extendDays[ExtendDays.THREEMONTH] = 90 days;
2270         _extendDays[ExtendDays.SIXMONTH] = 180 days;
2271         _extendDays[ExtendDays.ONEYEAR] = 360 days;
2272         _extendDays[ExtendDays.FOURYEAR] = 1440 days;
2273     }
2274 
2275     /// @dev Checks that the contract is in an initialized state.
2276     ///
2277     /// This is used over a modifier to reduce the size of the contract
2278     modifier expectInitialized() {
2279         require(initialized, "VotingEscrow: not initialized.");
2280         _;
2281     }
2282 
2283     modifier onlyGovernance() {
2284         require(msg.sender == governance, "VotingEscrow: only governance");
2285         _;
2286     }
2287 
2288     /// @dev Sets the governance.
2289     ///
2290     /// This function can only called by the current governance.
2291     ///
2292     /// @param _pendingGovernance the new pending governance.
2293     function setPendingGovernance(address _pendingGovernance) external onlyGovernance {
2294         require(_pendingGovernance != address(0), "VotingEscrow: pending governance address cannot be 0x0");
2295         pendingGovernance = _pendingGovernance;
2296 
2297         emit PendingGovernanceUpdated(_pendingGovernance);
2298     }
2299 
2300     function acceptGovernance() external {
2301         require(msg.sender == pendingGovernance, "VotingEscrow: only pending governance");
2302 
2303         address _pendingGovernance = pendingGovernance;
2304         governance = _pendingGovernance;
2305 
2306         emit GovernanceUpdated(_pendingGovernance);
2307     }
2308 
2309     /// @dev Sets the address of the collector
2310     ///
2311     /// @param _collector address of the new collector
2312     function setCollector(address _collector) external onlyGovernance {
2313         require(_collector != address(0), "VotingEscrow: collector address cannot be 0x0.");
2314         collector = _collector;
2315         emit CollectorUpdated(_collector);
2316     }
2317 
2318     function setRewardToken(address _rewardToken, address _rewardVesting, bool _needVesting) external onlyGovernance expectInitialized {
2319         require(_rewardToken != address(0), "VotingEscrow: new reward token address cannot be 0x0");
2320 
2321         if (_needVesting) {
2322             require(_rewardVesting != address(0), "VotingEscrow: new reward vesting address cannot be 0x0");
2323         }
2324 
2325         if (!rewardTokensList[_rewardToken]) {
2326             rewardTokens.push(_rewardToken);
2327             rewardTokensList[_rewardToken] = true;
2328             rewardsNeedVesting[_rewardToken] = _needVesting;
2329             rewardVestingsList[_rewardToken] = _rewardVesting;
2330             emit RewardTokenAdded(_rewardToken, _rewardVesting, _needVesting);
2331         } else {
2332             rewardsNeedVesting[_rewardToken] = _needVesting;
2333             rewardVestingsList[_rewardToken] = _rewardVesting;
2334             emit RewardTokenUpdated(_rewardToken, _rewardVesting, _needVesting);
2335         }
2336     }
2337 
2338     function setWasabiRewardRate(uint256 _wasabiRewardRate) external onlyGovernance {
2339         collectReward();
2340         wasabiRewardRate = _wasabiRewardRate;
2341         emit WasabiRewardRateUpdated(_wasabiRewardRate);
2342     }
2343 
2344     function setWasabiVesting(bool _needVesting, address _vestingAddress) external onlyGovernance {
2345         if (_needVesting) {
2346             require(_vestingAddress != address(0), "VotingEscrow: new wasabi reward vesting address cannot be 0x0");
2347         }
2348 
2349         wasabiNeedVesting = _needVesting;
2350         wasabiVestingAddress = _vestingAddress;
2351         emit WasabiVestingUpdated(_needVesting, _vestingAddress);
2352     }
2353 
2354     // veWasabi ERC20 interface
2355     function name() public view virtual returns (string memory) {
2356         return _name;
2357     }
2358 
2359     function symbol() public view virtual returns (string memory) {
2360         return _symbol;
2361     }
2362 
2363     function decimals() public view virtual returns (uint8) {
2364         return _decimals;
2365     }
2366 
2367     function totalSupply() public view virtual override returns (uint256) {
2368         return _totalSupply;
2369     }
2370 
2371     function balanceOf(address account) public view virtual override returns (uint256) {
2372         return _balances[account];
2373     }
2374 
2375     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
2376         return false;
2377     }
2378 
2379     function allowance(
2380         address owner,
2381         address spender
2382     )
2383         public view virtual override returns (uint256)
2384     {
2385         return 0;
2386     }
2387 
2388     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2389         return false;
2390     }
2391 
2392     function transferFrom(
2393         address sender,
2394         address recipient,
2395         uint256 amount
2396     )
2397         public virtual override returns (bool)
2398     {
2399         return false;
2400     }
2401 
2402     function amountOf(address account) public view returns (uint256) {
2403         return _locks[account].amount;
2404     }
2405 
2406     function endOf(address account) public view returns (uint256) {
2407         return _locks[account].end;
2408     }
2409 
2410     function startOf(address account) public view returns (uint256) {
2411         return _locks[account].start;
2412     }
2413 
2414     function maxEnd() public view returns (uint256) {
2415         return block.timestamp + MAX_TIME;
2416     }
2417 
2418     function rewardTokensLength() public view returns (uint256) {
2419         return rewardTokens.length;
2420     }
2421 
2422     function balanceAt(address account, uint256 timestamp) public view returns (uint256) {
2423         uint256 veBal = _balances[account];
2424         uint256 timeElapse = timestamp - startOf(account);
2425         uint256 lockPeriod = endOf(account) - startOf(account);
2426 
2427         uint256 veBalAt = veBal - veBal.mul(timeElapse).div(lockPeriod);
2428         return veBalAt;
2429     }
2430 
2431     function createLock(uint256 amount, LockDays lockDays) external expectInitialized {
2432         _createLock(amount, lockDays, block.timestamp);
2433     }
2434 
2435     function _createLock(uint256 amount, LockDays lockDays, uint256 timestamp) internal claimReward {
2436         LockData storage lock = _locks[msg.sender];
2437 
2438         require(lock.amount == 0, "must no locked");
2439         require(amount != 0, "amount must be non-zero");
2440 
2441         wasabi.transferFrom(msg.sender, address(this), amount);
2442         totalLockedWASABI = totalLockedWASABI + amount;
2443 
2444         uint256 end = timestamp + _lockDays[lockDays];
2445         lock.amount = amount;
2446         lock.end = end;
2447         lock.start = timestamp;
2448 
2449         _updateBalance(msg.sender, (end - timestamp).mul(amount).div(MAX_TIME));
2450 
2451         emit LockCreate(msg.sender, lock.amount, _balances[msg.sender], lock.start, lock.end);
2452     }
2453 
2454     function addAmount(uint256 amount) external expectInitialized {
2455         _addAmount(amount, block.timestamp);
2456     }
2457 
2458     function _addAmount(uint256 amount, uint256 timestamp) internal claimReward {
2459         LockData storage lock = _locks[msg.sender];
2460 
2461         require(lock.amount != 0, "must locked");
2462         require(lock.end > timestamp, "must not expired");
2463         require(amount != 0, "amount must be nonzero");
2464 
2465         wasabi.transferFrom(msg.sender, address(this), amount);
2466         totalLockedWASABI = totalLockedWASABI + amount;
2467 
2468         lock.amount = lock.amount.add(amount);
2469         _updateBalance(
2470             msg.sender,
2471             _balances[msg.sender].add((lock.end - timestamp).mul(amount).div(MAX_TIME))
2472         );
2473 
2474         emit LockIncreaseAmount(msg.sender, lock.amount, _balances[msg.sender], lock.start, lock.end);
2475     }
2476 
2477     function extendLock(ExtendDays extendDays) external expectInitialized {
2478         _extendLock(extendDays, block.timestamp);
2479     }
2480 
2481     function _extendLock(ExtendDays extendDays, uint256 timestamp) internal claimReward {
2482         LockData storage lock = _locks[msg.sender];
2483         require(lock.amount != 0, "must locked");
2484 
2485         uint256 end = lock.end + _extendDays[extendDays];
2486         // calculate equivalent lock duration
2487         uint256 duration = _balances[msg.sender].mul(MAX_TIME).div(lock.amount);
2488         duration += (end - lock.end);
2489         require(duration <= MAX_TIME, "end too long");
2490 
2491         lock.end = end;
2492         _updateBalance(msg.sender, duration.mul(lock.amount).div(MAX_TIME));
2493 
2494         emit LockExtend(msg.sender, lock.amount, _balances[msg.sender], lock.start, lock.end);
2495     }
2496 
2497     function withdraw() external expectInitialized {
2498         _withdraw(block.timestamp);
2499     }
2500 
2501     function _withdraw(uint256 timestamp) internal claimReward {
2502         LockData storage lock = _locks[msg.sender];
2503 
2504         require(lock.amount != 0, "must locked");
2505         require(lock.end <= timestamp, "must expired");
2506 
2507         uint256 amount = lock.amount;
2508         wasabi.transfer(msg.sender, amount);
2509         totalLockedWASABI = totalLockedWASABI - amount;
2510 
2511         lock.amount = 0;
2512         _updateBalance(msg.sender, 0);
2513 
2514         emit Withdraw(msg.sender, amount);
2515     }
2516 
2517     // solium-disable-next-line no-empty-blocks
2518     function vestEarning() external expectInitialized claimReward {
2519     }
2520 
2521     function _updateBalance(address account, uint256 newBalance) internal {
2522         _totalSupply = _totalSupply.sub(_balances[account]).add(newBalance);
2523         _balances[account] = newBalance;
2524     }
2525 
2526      // Return block rewards over the given _from (inclusive) to _to (inclusive) block.
2527     function getBlockReward(uint256 _from, uint256 _to) public view returns (uint256) {
2528         uint256 to = _to;
2529         uint256 from = _from;
2530 
2531         if (from > to) {
2532             return 0;
2533         }
2534 
2535         uint256 rewardPerBlock = wasabiRewardRate;
2536         uint256 totalRewards = (to.sub(from)).mul(rewardPerBlock);
2537 
2538         return totalRewards;
2539     }
2540 
2541     function collectReward() public expectInitialized {
2542         if (block.number <= lastRewardBlock) {
2543             return;
2544         }
2545 
2546         if (_totalSupply == 0) {
2547             lastRewardBlock = block.number;
2548             return;
2549         }
2550 
2551         uint256 wasabiReward = getBlockReward(lastRewardBlock, block.number);
2552         wasabi.mint(address(this), wasabiReward);
2553         _accWasabiRewardPerBalance = _accWasabiRewardPerBalance.add(wasabiReward.mul(1e18).div(_totalSupply));
2554         lastRewardBlock = block.number;
2555 
2556         for (uint i=0; i<rewardTokens.length; i++) {
2557             address tokenAddress = rewardTokens[i];
2558             if (tokenAddress != address(0)) {
2559                 IERC20 token = IERC20(tokenAddress);
2560                 uint256 newReward = token.balanceOf(collector);
2561                 if (newReward == 0) {
2562                     return;
2563                 }
2564                 token.transferFrom(collector, address(this), newReward);
2565                 _accRewardPerBalance[tokenAddress] = _accRewardPerBalance[tokenAddress].add(newReward.mul(1e18).div(_totalSupply));
2566            }
2567         }
2568     }
2569 
2570     function pendingReward(address account, address tokenAddress) public view returns (uint256) {
2571         require(tokenAddress != address(0), "VotingEscrow: reward token address cannot be 0x0.");
2572         IERC20 token = IERC20(tokenAddress);
2573         uint256 pending;
2574 
2575         if (_balances[account] > 0) {
2576             uint256 newReward = token.balanceOf(collector);
2577             uint256 newAccRewardPerBalance = _accRewardPerBalance[tokenAddress].add(newReward.mul(1e18).div(_totalSupply));
2578             pending = _balances[account].mul(newAccRewardPerBalance).div(1e18).sub(_rewardDebt[account][tokenAddress]);
2579         }
2580         return pending;
2581     }
2582 
2583     function pendingWasabi(address account) public view returns (uint256) {
2584         uint256 pending;
2585 
2586         if (_balances[account] > 0) {
2587             uint256 accRewardPerBalance = _accWasabiRewardPerBalance;
2588             if (block.number > lastRewardBlock) {
2589                 uint256 wasabiReward = getBlockReward(lastRewardBlock, block.number);
2590                 accRewardPerBalance = _accWasabiRewardPerBalance.add(wasabiReward.mul(1e18).div(_totalSupply));
2591             }
2592             pending = _balances[account].mul(accRewardPerBalance).div(1e18).sub(_wasabiRewardDebts[account]);
2593         }
2594         return pending;
2595     }
2596 
2597     modifier claimReward() {
2598         collectReward();
2599         uint256 veBal = _balances[msg.sender];
2600         if (veBal > 0) {
2601             uint256 wasabiPending = veBal.mul(_accWasabiRewardPerBalance).div(1e18).sub(_wasabiRewardDebts[msg.sender]);
2602             if (wasabiPending > 0) {
2603                 if (wasabiNeedVesting) {
2604                     IRewardVesting wasabiVesting = IRewardVesting(wasabiVestingAddress);
2605                     wasabi.approve(address(wasabiVesting), wasabiPending);
2606                     wasabiVesting.addEarning(msg.sender, wasabiPending);
2607                 } else {
2608                     _safeWasabiTransfer(msg.sender, wasabiPending);
2609                 }
2610             }
2611             for (uint i=0; i<rewardTokens.length; i++) {
2612                 address tokenAddress = rewardTokens[i];
2613                 if (tokenAddress != address(0)) {
2614                     IERC20 token = IERC20(tokenAddress);
2615                     uint256 pending = veBal.mul(_accRewardPerBalance[tokenAddress]).div(1e18).sub(_rewardDebt[msg.sender][tokenAddress]);
2616                     if (pending > 0) {
2617                         bool needVesting = rewardsNeedVesting[tokenAddress];
2618                         if (needVesting) {
2619                             address rewardVestingAddress = rewardVestingsList[tokenAddress];
2620                             if (rewardVestingAddress != address(0)) {
2621                                 IRewardVesting rewardVesting = IRewardVesting(rewardVestingAddress);
2622                                 token.approve(address(rewardVesting),pending);
2623                                 rewardVesting.addEarning(msg.sender,pending);
2624                             }
2625                         } else {
2626                             token.transfer(msg.sender, pending);
2627                         }
2628                     }
2629                 }
2630             }
2631         }
2632         _; // _balances[msg.sender] may changed.
2633         veBal = _balances[msg.sender];
2634         for (uint i=0; i<rewardTokens.length; i++) {
2635             address tokenAddress = rewardTokens[i];
2636             if (tokenAddress != address(0)) {
2637                 _rewardDebt[msg.sender][tokenAddress] = veBal.mul(_accRewardPerBalance[tokenAddress]).div(1e18);
2638             }
2639         }
2640         _wasabiRewardDebts[msg.sender] = veBal.mul(_accWasabiRewardPerBalance).div(1e18);
2641     }
2642 
2643     function _safeWasabiTransfer(address _to, uint256 _amount) internal {
2644         if (_amount > 0) {
2645             uint256 wasabiBal = wasabi.balanceOf(address(this));
2646             if (_amount > wasabiBal) {
2647                 wasabi.transfer(_to, wasabiBal);
2648             } else {
2649                 wasabi.transfer(_to, _amount);
2650             }
2651         }
2652     }
2653 }