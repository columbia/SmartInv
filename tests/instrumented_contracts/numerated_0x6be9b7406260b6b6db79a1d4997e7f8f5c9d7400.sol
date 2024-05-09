1 /**
2  * Copyright 2017-2021, bZxDao. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 
6 // SPDX-License-Identifier: Apache License, Version 2.0.
7 
8 pragma solidity 0.6.12;
9 
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations with added overflow
13  * checks.
14  *
15  * Arithmetic operations in Solidity wrap on overflow. This can easily result
16  * in bugs, because programmers usually assume that an overflow raises an
17  * error, which is the standard behavior in high level programming languages.
18  * `SafeMath` restores this intuition by reverting the transaction when an
19  * operation overflows.
20  *
21  * Using this library instead of the unchecked operations eliminates an entire
22  * class of bugs, so it's recommended to use it always.
23  */
24 library SafeMath {
25     /**
26      * @dev Returns the addition of two unsigned integers, with an overflow flag.
27      *
28      * _Available since v3.4._
29      */
30     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         uint256 c = a + b;
32         if (c < a) return (false, 0);
33         return (true, c);
34     }
35 
36     /**
37      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
38      *
39      * _Available since v3.4._
40      */
41     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         if (b > a) return (false, 0);
43         return (true, a - b);
44     }
45 
46     /**
47      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53         // benefit is lost if 'b' is also tested.
54         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55         if (a == 0) return (true, 0);
56         uint256 c = a * b;
57         if (c / a != b) return (false, 0);
58         return (true, c);
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         if (b == 0) return (false, 0);
68         return (true, a / b);
69     }
70 
71     /**
72      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         if (b == 0) return (false, 0);
78         return (true, a % b);
79     }
80 
81     /**
82      * @dev Returns the addition of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `+` operator.
86      *
87      * Requirements:
88      *
89      * - Addition cannot overflow.
90      */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a, "SafeMath: addition overflow");
94         return c;
95     }
96 
97     /**
98      * @dev Returns the subtraction of two unsigned integers, reverting on
99      * overflow (when the result is negative).
100      *
101      * Counterpart to Solidity's `-` operator.
102      *
103      * Requirements:
104      *
105      * - Subtraction cannot overflow.
106      */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b <= a, "SafeMath: subtraction overflow");
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         if (a == 0) return 0;
124         uint256 c = a * b;
125         require(c / a == b, "SafeMath: multiplication overflow");
126         return c;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers, reverting on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function div(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b > 0, "SafeMath: division by zero");
143         return a / b;
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * reverting when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         require(b > 0, "SafeMath: modulo by zero");
160         return a % b;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * CAUTION: This function is deprecated because it requires allocating memory for the error
168      * message unnecessarily. For custom revert reasons use {trySub}.
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b <= a, errorMessage);
178         return a - b;
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * CAUTION: This function is deprecated because it requires allocating memory for the error
186      * message unnecessarily. For custom revert reasons use {tryDiv}.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b > 0, errorMessage);
198         return a / b;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * reverting with custom message when dividing by zero.
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {tryMod}.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         return a % b;
219     }
220 }
221 
222 /**
223  * @dev Interface of the ERC20 standard as defined in the EIP.
224  */
225 interface IERC20 {
226     /**
227      * @dev Returns the amount of tokens in existence.
228      */
229     function totalSupply() external view returns (uint256);
230 
231     /**
232      * @dev Returns the amount of tokens owned by `account`.
233      */
234     function balanceOf(address account) external view returns (uint256);
235 
236     /**
237      * @dev Moves `amount` tokens from the caller's account to `recipient`.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transfer(address recipient, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Returns the remaining number of tokens that `spender` will be
247      * allowed to spend on behalf of `owner` through {transferFrom}. This is
248      * zero by default.
249      *
250      * This value changes when {approve} or {transferFrom} are called.
251      */
252     function allowance(address owner, address spender) external view returns (uint256);
253 
254     /**
255      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
256      *
257      * Returns a boolean value indicating whether the operation succeeded.
258      *
259      * IMPORTANT: Beware that changing an allowance with this method brings the risk
260      * that someone may use both the old and the new allowance by unfortunate
261      * transaction ordering. One possible solution to mitigate this race
262      * condition is to first reduce the spender's allowance to 0 and set the
263      * desired value afterwards:
264      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265      *
266      * Emits an {Approval} event.
267      */
268     function approve(address spender, uint256 amount) external returns (bool);
269 
270     /**
271      * @dev Moves `amount` tokens from `sender` to `recipient` using the
272      * allowance mechanism. `amount` is then deducted from the caller's
273      * allowance.
274      *
275      * Returns a boolean value indicating whether the operation succeeded.
276      *
277      * Emits a {Transfer} event.
278      */
279     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
280 
281     /**
282      * @dev Emitted when `value` tokens are moved from one account (`from`) to
283      * another (`to`).
284      *
285      * Note that `value` may be zero.
286      */
287     event Transfer(address indexed from, address indexed to, uint256 value);
288 
289     /**
290      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
291      * a call to {approve}. `value` is the new allowance.
292      */
293     event Approval(address indexed owner, address indexed spender, uint256 value);
294 }
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      */
317     function isContract(address account) internal view returns (bool) {
318         // This method relies on extcodesize, which returns 0 for contracts in
319         // construction, since the code is only stored at the end of the
320         // constructor execution.
321 
322         uint256 size;
323         // solhint-disable-next-line no-inline-assembly
324         assembly { size := extcodesize(account) }
325         return size > 0;
326     }
327 
328     /**
329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330      * `recipient`, forwarding all available gas and reverting on errors.
331      *
332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
334      * imposed by `transfer`, making them unable to receive funds via
335      * `transfer`. {sendValue} removes this limitation.
336      *
337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338      *
339      * IMPORTANT: because control is transferred to `recipient`, care must be
340      * taken to not create reentrancy vulnerabilities. Consider using
341      * {ReentrancyGuard} or the
342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343      */
344     function sendValue(address payable recipient, uint256 amount) internal {
345         require(address(this).balance >= amount, "Address: insufficient balance");
346 
347         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
348         (bool success, ) = recipient.call{ value: amount }("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 
352     /**
353      * @dev Performs a Solidity function call using a low level `call`. A
354      * plain`call` is an unsafe replacement for a function call: use this
355      * function instead.
356      *
357      * If `target` reverts with a revert reason, it is bubbled up by this
358      * function (like regular Solidity function calls).
359      *
360      * Returns the raw returned data. To convert to the expected return value,
361      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
362      *
363      * Requirements:
364      *
365      * - `target` must be a contract.
366      * - calling `target` with `data` must not revert.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
371       return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, 0, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but also transferring `value` wei to `target`.
387      *
388      * Requirements:
389      *
390      * - the calling contract must have an ETH balance of at least `value`.
391      * - the called Solidity function must be `payable`.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
401      * with `errorMessage` as a fallback revert reason when `target` reverts.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
406         require(address(this).balance >= value, "Address: insufficient balance for call");
407         require(isContract(target), "Address: call to non-contract");
408 
409         // solhint-disable-next-line avoid-low-level-calls
410         (bool success, bytes memory returndata) = target.call{ value: value }(data);
411         return _verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but performing a static call.
417      *
418      * _Available since v3.3._
419      */
420     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
421         return functionStaticCall(target, data, "Address: low-level static call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
426      * but performing a static call.
427      *
428      * _Available since v3.3._
429      */
430     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
431         require(isContract(target), "Address: static call to non-contract");
432 
433         // solhint-disable-next-line avoid-low-level-calls
434         (bool success, bytes memory returndata) = target.staticcall(data);
435         return _verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
445         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
455         require(isContract(target), "Address: delegate call to non-contract");
456 
457         // solhint-disable-next-line avoid-low-level-calls
458         (bool success, bytes memory returndata) = target.delegatecall(data);
459         return _verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
463         if (success) {
464             return returndata;
465         } else {
466             // Look for revert reason and bubble it up if present
467             if (returndata.length > 0) {
468                 // The easiest way to bubble the revert reason is using memory via assembly
469 
470                 // solhint-disable-next-line no-inline-assembly
471                 assembly {
472                     let returndata_size := mload(returndata)
473                     revert(add(32, returndata), returndata_size)
474                 }
475             } else {
476                 revert(errorMessage);
477             }
478         }
479     }
480 }
481 
482 /**
483  * @title SafeERC20
484  * @dev Wrappers around ERC20 operations that throw on failure (when the token
485  * contract returns false). Tokens that return no value (and instead revert or
486  * throw on failure) are also supported, non-reverting calls are assumed to be
487  * successful.
488  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
489  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
490  */
491 library SafeERC20 {
492     using SafeMath for uint256;
493     using Address for address;
494 
495     function safeTransfer(IERC20 token, address to, uint256 value) internal {
496         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
497     }
498 
499     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
500         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
501     }
502 
503     /**
504      * @dev Deprecated. This function has issues similar to the ones found in
505      * {IERC20-approve}, and its usage is discouraged.
506      *
507      * Whenever possible, use {safeIncreaseAllowance} and
508      * {safeDecreaseAllowance} instead.
509      */
510     function safeApprove(IERC20 token, address spender, uint256 value) internal {
511         // safeApprove should only be called when setting an initial allowance,
512         // or when resetting it to zero. To increase and decrease it, use
513         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
514         // solhint-disable-next-line max-line-length
515         require((value == 0) || (token.allowance(address(this), spender) == 0),
516             "SafeERC20: approve from non-zero to non-zero allowance"
517         );
518         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
519     }
520 
521     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
522         uint256 newAllowance = token.allowance(address(this), spender).add(value);
523         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
524     }
525 
526     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
527         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
528         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
529     }
530 
531     /**
532      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
533      * on the return value: the return value is optional (but if data is returned, it must not be false).
534      * @param token The token targeted by the call.
535      * @param data The call data (encoded using abi.encode or one of its variants).
536      */
537     function _callOptionalReturn(IERC20 token, bytes memory data) private {
538         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
539         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
540         // the target address contains contract code and also asserts for success in the low-level call.
541 
542         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
543         if (returndata.length > 0) { // Return data is optional
544             // solhint-disable-next-line max-line-length
545             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
546         }
547     }
548 }
549 
550 /*
551  * @dev Provides information about the current execution context, including the
552  * sender of the transaction and its data. While these are generally available
553  * via msg.sender and msg.data, they should not be accessed in such a direct
554  * manner, since when dealing with GSN meta-transactions the account sending and
555  * paying for execution may not be the actual sender (as far as an application
556  * is concerned).
557  *
558  * This contract is only required for intermediate, library-like contracts.
559  */
560 abstract contract Context {
561     function _msgSender() internal view virtual returns (address payable) {
562         return msg.sender;
563     }
564 
565     function _msgData() internal view virtual returns (bytes memory) {
566         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
567         return msg.data;
568     }
569 }
570 
571 /**
572  * @dev Contract module which provides a basic access control mechanism, where
573  * there is an account (an owner) that can be granted exclusive access to
574  * specific functions.
575  *
576  * By default, the owner account will be the one that deploys the contract. This
577  * can later be changed with {transferOwnership}.
578  *
579  * This module is used through inheritance. It will make available the modifier
580  * `onlyOwner`, which can be applied to your functions to restrict their use to
581  * the owner.
582  */
583 abstract contract Ownable is Context {
584     address private _owner;
585 
586     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
587 
588     /**
589      * @dev Initializes the contract setting the deployer as the initial owner.
590      */
591     constructor () internal {
592         address msgSender = _msgSender();
593         _owner = msgSender;
594         emit OwnershipTransferred(address(0), msgSender);
595     }
596 
597     /**
598      * @dev Returns the address of the current owner.
599      */
600     function owner() public view virtual returns (address) {
601         return _owner;
602     }
603 
604     /**
605      * @dev Throws if called by any account other than the owner.
606      */
607     modifier onlyOwner() {
608         require(owner() == _msgSender(), "Ownable: caller is not the owner");
609         _;
610     }
611 
612     /**
613      * @dev Leaves the contract without owner. It will not be possible to call
614      * `onlyOwner` functions anymore. Can only be called by the current owner.
615      *
616      * NOTE: Renouncing ownership will leave the contract without an owner,
617      * thereby removing any functionality that is only available to the owner.
618      */
619     function renounceOwnership() public virtual onlyOwner {
620         emit OwnershipTransferred(_owner, address(0));
621         _owner = address(0);
622     }
623 
624     /**
625      * @dev Transfers ownership of the contract to a new account (`newOwner`).
626      * Can only be called by the current owner.
627      */
628     function transferOwnership(address newOwner) public virtual onlyOwner {
629         require(newOwner != address(0), "Ownable: new owner is the zero address");
630         emit OwnershipTransferred(_owner, newOwner);
631         _owner = newOwner;
632     }
633 }
634 
635 /**
636  * @dev Implementation of the {IERC20} interface.
637  *
638  * This implementation is agnostic to the way tokens are created. This means
639  * that a supply mechanism has to be added in a derived contract using {_mint}.
640  * For a generic mechanism see {ERC20PresetMinterPauser}.
641  *
642  * TIP: For a detailed writeup see our guide
643  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
644  * to implement supply mechanisms].
645  *
646  * We have followed general OpenZeppelin guidelines: functions revert instead
647  * of returning `false` on failure. This behavior is nonetheless conventional
648  * and does not conflict with the expectations of ERC20 applications.
649  *
650  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
651  * This allows applications to reconstruct the allowance for all accounts just
652  * by listening to said events. Other implementations of the EIP may not emit
653  * these events, as it isn't required by the specification.
654  *
655  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
656  * functions have been added to mitigate the well-known issues around setting
657  * allowances. See {IERC20-approve}.
658  */
659 contract ERC20 is Context, IERC20 {
660     using SafeMath for uint256;
661 
662     mapping (address => uint256) private _balances;
663 
664     mapping (address => mapping (address => uint256)) private _allowances;
665 
666     uint256 private _totalSupply;
667 
668     string private _name;
669     string private _symbol;
670     uint8 private _decimals;
671 
672     /**
673      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
674      * a default value of 18.
675      *
676      * To select a different value for {decimals}, use {_setupDecimals}.
677      *
678      * All three of these values are immutable: they can only be set once during
679      * construction.
680      */
681     constructor (string memory name_, string memory symbol_) public {
682         _name = name_;
683         _symbol = symbol_;
684         _decimals = 18;
685     }
686 
687     /**
688      * @dev Returns the name of the token.
689      */
690     function name() public view virtual returns (string memory) {
691         return _name;
692     }
693 
694     /**
695      * @dev Returns the symbol of the token, usually a shorter version of the
696      * name.
697      */
698     function symbol() public view virtual returns (string memory) {
699         return _symbol;
700     }
701 
702     /**
703      * @dev Returns the number of decimals used to get its user representation.
704      * For example, if `decimals` equals `2`, a balance of `505` tokens should
705      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
706      *
707      * Tokens usually opt for a value of 18, imitating the relationship between
708      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
709      * called.
710      *
711      * NOTE: This information is only used for _display_ purposes: it in
712      * no way affects any of the arithmetic of the contract, including
713      * {IERC20-balanceOf} and {IERC20-transfer}.
714      */
715     function decimals() public view virtual returns (uint8) {
716         return _decimals;
717     }
718 
719     /**
720      * @dev See {IERC20-totalSupply}.
721      */
722     function totalSupply() public view virtual override returns (uint256) {
723         return _totalSupply;
724     }
725 
726     /**
727      * @dev See {IERC20-balanceOf}.
728      */
729     function balanceOf(address account) public view virtual override returns (uint256) {
730         return _balances[account];
731     }
732 
733     /**
734      * @dev See {IERC20-transfer}.
735      *
736      * Requirements:
737      *
738      * - `recipient` cannot be the zero address.
739      * - the caller must have a balance of at least `amount`.
740      */
741     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
742         _transfer(_msgSender(), recipient, amount);
743         return true;
744     }
745 
746     /**
747      * @dev See {IERC20-allowance}.
748      */
749     function allowance(address owner, address spender) public view virtual override returns (uint256) {
750         return _allowances[owner][spender];
751     }
752 
753     /**
754      * @dev See {IERC20-approve}.
755      *
756      * Requirements:
757      *
758      * - `spender` cannot be the zero address.
759      */
760     function approve(address spender, uint256 amount) public virtual override returns (bool) {
761         _approve(_msgSender(), spender, amount);
762         return true;
763     }
764 
765     /**
766      * @dev See {IERC20-transferFrom}.
767      *
768      * Emits an {Approval} event indicating the updated allowance. This is not
769      * required by the EIP. See the note at the beginning of {ERC20}.
770      *
771      * Requirements:
772      *
773      * - `sender` and `recipient` cannot be the zero address.
774      * - `sender` must have a balance of at least `amount`.
775      * - the caller must have allowance for ``sender``'s tokens of at least
776      * `amount`.
777      */
778     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
779         _transfer(sender, recipient, amount);
780         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
781         return true;
782     }
783 
784     /**
785      * @dev Atomically increases the allowance granted to `spender` by the caller.
786      *
787      * This is an alternative to {approve} that can be used as a mitigation for
788      * problems described in {IERC20-approve}.
789      *
790      * Emits an {Approval} event indicating the updated allowance.
791      *
792      * Requirements:
793      *
794      * - `spender` cannot be the zero address.
795      */
796     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
797         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
798         return true;
799     }
800 
801     /**
802      * @dev Atomically decreases the allowance granted to `spender` by the caller.
803      *
804      * This is an alternative to {approve} that can be used as a mitigation for
805      * problems described in {IERC20-approve}.
806      *
807      * Emits an {Approval} event indicating the updated allowance.
808      *
809      * Requirements:
810      *
811      * - `spender` cannot be the zero address.
812      * - `spender` must have allowance for the caller of at least
813      * `subtractedValue`.
814      */
815     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
816         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
817         return true;
818     }
819 
820     /**
821      * @dev Moves tokens `amount` from `sender` to `recipient`.
822      *
823      * This is internal function is equivalent to {transfer}, and can be used to
824      * e.g. implement automatic token fees, slashing mechanisms, etc.
825      *
826      * Emits a {Transfer} event.
827      *
828      * Requirements:
829      *
830      * - `sender` cannot be the zero address.
831      * - `recipient` cannot be the zero address.
832      * - `sender` must have a balance of at least `amount`.
833      */
834     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
835         require(sender != address(0), "ERC20: transfer from the zero address");
836         require(recipient != address(0), "ERC20: transfer to the zero address");
837 
838         _beforeTokenTransfer(sender, recipient, amount);
839 
840         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
841         _balances[recipient] = _balances[recipient].add(amount);
842         emit Transfer(sender, recipient, amount);
843     }
844 
845     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
846      * the total supply.
847      *
848      * Emits a {Transfer} event with `from` set to the zero address.
849      *
850      * Requirements:
851      *
852      * - `to` cannot be the zero address.
853      */
854     function _mint(address account, uint256 amount) internal virtual {
855         require(account != address(0), "ERC20: mint to the zero address");
856 
857         _beforeTokenTransfer(address(0), account, amount);
858 
859         _totalSupply = _totalSupply.add(amount);
860         _balances[account] = _balances[account].add(amount);
861         emit Transfer(address(0), account, amount);
862     }
863 
864     /**
865      * @dev Destroys `amount` tokens from `account`, reducing the
866      * total supply.
867      *
868      * Emits a {Transfer} event with `to` set to the zero address.
869      *
870      * Requirements:
871      *
872      * - `account` cannot be the zero address.
873      * - `account` must have at least `amount` tokens.
874      */
875     function _burn(address account, uint256 amount) internal virtual {
876         require(account != address(0), "ERC20: burn from the zero address");
877 
878         _beforeTokenTransfer(account, address(0), amount);
879 
880         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
881         _totalSupply = _totalSupply.sub(amount);
882         emit Transfer(account, address(0), amount);
883     }
884 
885     /**
886      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
887      *
888      * This internal function is equivalent to `approve`, and can be used to
889      * e.g. set automatic allowances for certain subsystems, etc.
890      *
891      * Emits an {Approval} event.
892      *
893      * Requirements:
894      *
895      * - `owner` cannot be the zero address.
896      * - `spender` cannot be the zero address.
897      */
898     function _approve(address owner, address spender, uint256 amount) internal virtual {
899         require(owner != address(0), "ERC20: approve from the zero address");
900         require(spender != address(0), "ERC20: approve to the zero address");
901 
902         _allowances[owner][spender] = amount;
903         emit Approval(owner, spender, amount);
904     }
905 
906     /**
907      * @dev Sets {decimals} to a value other than the default one of 18.
908      *
909      * WARNING: This function should only be called from the constructor. Most
910      * applications that interact with token contracts will not expect
911      * {decimals} to ever change, and may work incorrectly if it does.
912      */
913     function _setupDecimals(uint8 decimals_) internal virtual {
914         _decimals = decimals_;
915     }
916 
917     /**
918      * @dev Hook that is called before any transfer of tokens. This includes
919      * minting and burning.
920      *
921      * Calling conditions:
922      *
923      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
924      * will be to transferred to `to`.
925      * - when `from` is zero, `amount` tokens will be minted for `to`.
926      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
927      * - `from` and `to` are never both zero.
928      *
929      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
930      */
931     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
932 }
933 
934 contract OokiToken is ERC20, Ownable {
935     constructor() ERC20("Ooki Token", "OOKI") public {}
936 
937     uint256 public totalMinted;
938     uint256 public totalBurned;
939 
940     function mint(address _to, uint256 _amount) public onlyOwner {
941         _mint(_to, _amount);
942         totalMinted = totalMinted.add(_amount);
943     }
944 
945     function burn(uint256 _amount) public onlyOwner {
946         _burn(msg.sender, _amount);
947         totalBurned = totalBurned.add(_amount);
948     }
949 
950     function rescue(IERC20 _token) public onlyOwner {
951         SafeERC20.safeTransfer(_token, msg.sender, _token.balanceOf(address(this)));
952     }
953 }
954 
955 contract MintCoordinator is Ownable {
956 
957     OokiToken public constant OOKI = OokiToken(0xC5c66f91fE2e395078E0b872232A20981bc03B15);
958     mapping (address => bool) public minters;
959     mapping (address => bool) public burners;
960     
961 
962     constructor() public {
963         // minters[TODO] = true;
964     }
965 
966     function mint(address _to, uint256 _amount) public {
967         require(minters[msg.sender], "unauthorized");
968         OOKI.mint(_to, _amount);
969     }
970 
971     function burn(uint256 _amount) public {
972         require(burners[msg.sender], "unauthorized");
973         OOKI.transferFrom(msg.sender, address(this), _amount);
974         OOKI.burn(_amount);
975     }
976 
977     function transferTokenOwnership(address newOwner) public onlyOwner {
978         OOKI.transferOwnership(newOwner);
979     }
980 
981     function addMinter(address addr) public onlyOwner {
982         minters[addr] = true;
983     }
984 
985     function removeMinter(address addr) public onlyOwner {
986         minters[addr] = false;
987     }
988 
989     function addBurner(address addr) public onlyOwner {
990         burners[addr] = true;
991     }
992 
993     function removeBurner(address addr) public onlyOwner {
994         burners[addr] = false;
995     }
996 
997 
998     function rescue(IERC20 _token) public onlyOwner {
999         SafeERC20.safeTransfer(_token, msg.sender, _token.balanceOf(address(this)));
1000     }
1001 
1002     function rescueToken(IERC20 _token) public onlyOwner {
1003         OOKI.rescue(_token);
1004         rescue(_token);
1005     }
1006 }
1007 
1008 contract BZRXv2Converter is Ownable {
1009 
1010     event ConvertBZRX(
1011         address indexed sender,
1012         uint256 amount
1013     );
1014 
1015     IERC20 public constant BZRXv1 = IERC20(0x56d811088235F11C8920698a204A5010a788f4b3);
1016     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
1017 
1018     MintCoordinator public MINT_COORDINATOR;
1019     uint256 public totalConverted;
1020 
1021     function convert(
1022         address receiver,
1023         uint256 _tokenAmount)
1024         external
1025     {
1026         BZRXv1.transferFrom(
1027             msg.sender,
1028             DEAD, // burn address, since transfers to address(0) are not allowed by the token
1029             _tokenAmount
1030         );
1031 
1032         // we mint burned amount
1033         MINT_COORDINATOR.mint(receiver, _tokenAmount * 10); // we do a 10x split
1034 
1035         // overflow condition cannot be reached since the above will throw for bad amounts
1036         totalConverted += _tokenAmount;
1037 
1038         emit ConvertBZRX(
1039             receiver,
1040             _tokenAmount
1041         );
1042     }
1043 
1044     // open convert tool to the public
1045     function initialize(
1046         MintCoordinator _MINT_COORDINATOR)
1047         external
1048         onlyOwner
1049     {
1050         require(address(MINT_COORDINATOR) == address(0), "already initialized");
1051         MINT_COORDINATOR = _MINT_COORDINATOR;
1052     }
1053 
1054     // allows the DAO to rescue tokens accidently sent to the contract
1055     function rescue(
1056         IERC20 _token)
1057         external
1058         onlyOwner
1059     {
1060         SafeERC20.safeTransfer(_token, msg.sender, _token.balanceOf(address(this)));
1061     }
1062 }