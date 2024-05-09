1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.7.3;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor () internal {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 /**
90  * @dev Collection of functions related to the address type
91  */
92 library Address {
93     /**
94      * @dev Returns true if `account` is a contract.
95      *
96      * [IMPORTANT]
97      * ====
98      * It is unsafe to assume that an address for which this function returns
99      * false is an externally-owned account (EOA) and not a contract.
100      *
101      * Among others, `isContract` will return false for the following
102      * types of addresses:
103      *
104      *  - an externally-owned account
105      *  - a contract in construction
106      *  - an address where a contract will be created
107      *  - an address where a contract lived, but was destroyed
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize, which returns 0 for contracts in
112         // construction, since the code is only stored at the end of the
113         // constructor execution.
114 
115         uint256 size;
116         // solhint-disable-next-line no-inline-assembly
117         assembly { size := extcodesize(account) }
118         return size > 0;
119     }
120 
121     /**
122      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
123      * `recipient`, forwarding all available gas and reverting on errors.
124      *
125      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
126      * of certain opcodes, possibly making contracts go over the 2300 gas limit
127      * imposed by `transfer`, making them unable to receive funds via
128      * `transfer`. {sendValue} removes this limitation.
129      *
130      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
131      *
132      * IMPORTANT: because control is transferred to `recipient`, care must be
133      * taken to not create reentrancy vulnerabilities. Consider using
134      * {ReentrancyGuard} or the
135      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
136      */
137     function sendValue(address payable recipient, uint256 amount) internal {
138         require(address(this).balance >= amount, "Address: insufficient balance");
139 
140         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
141         (bool success, ) = recipient.call{ value: amount }("");
142         require(success, "Address: unable to send value, recipient may have reverted");
143     }
144 
145     /**
146      * @dev Performs a Solidity function call using a low level `call`. A
147      * plain`call` is an unsafe replacement for a function call: use this
148      * function instead.
149      *
150      * If `target` reverts with a revert reason, it is bubbled up by this
151      * function (like regular Solidity function calls).
152      *
153      * Returns the raw returned data. To convert to the expected return value,
154      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
155      *
156      * Requirements:
157      *
158      * - `target` must be a contract.
159      * - calling `target` with `data` must not revert.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
164         return functionCall(target, data, "Address: low-level call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
169      * `errorMessage` as a fallback revert reason when `target` reverts.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, 0, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but also transferring `value` wei to `target`.
180      *
181      * Requirements:
182      *
183      * - the calling contract must have an ETH balance of at least `value`.
184      * - the called Solidity function must be `payable`.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
194      * with `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
199         require(address(this).balance >= value, "Address: insufficient balance for call");
200         require(isContract(target), "Address: call to non-contract");
201 
202         // solhint-disable-next-line avoid-low-level-calls
203         (bool success, bytes memory returndata) = target.call{ value: value }(data);
204         return _verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
214         return functionStaticCall(target, data, "Address: low-level static call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
224         require(isContract(target), "Address: static call to non-contract");
225 
226         // solhint-disable-next-line avoid-low-level-calls
227         (bool success, bytes memory returndata) = target.staticcall(data);
228         return _verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but performing a delegate call.
234      *
235      * _Available since v3.4._
236      */
237     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
238         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
248         require(isContract(target), "Address: delegate call to non-contract");
249 
250         // solhint-disable-next-line avoid-low-level-calls
251         (bool success, bytes memory returndata) = target.delegatecall(data);
252         return _verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
256         if (success) {
257             return returndata;
258         } else {
259             // Look for revert reason and bubble it up if present
260             if (returndata.length > 0) {
261                 // The easiest way to bubble the revert reason is using memory via assembly
262 
263                 // solhint-disable-next-line no-inline-assembly
264                 assembly {
265                     let returndata_size := mload(returndata)
266                     revert(add(32, returndata), returndata_size)
267                 }
268             } else {
269                 revert(errorMessage);
270             }
271         }
272     }
273 }
274 
275 /**
276  * @dev Wrappers over Solidity's arithmetic operations with added overflow
277  * checks.
278  *
279  * Arithmetic operations in Solidity wrap on overflow. This can easily result
280  * in bugs, because programmers usually assume that an overflow raises an
281  * error, which is the standard behavior in high level programming languages.
282  * `SafeMath` restores this intuition by reverting the transaction when an
283  * operation overflows.
284  *
285  * Using this library instead of the unchecked operations eliminates an entire
286  * class of bugs, so it's recommended to use it always.
287  */
288 library SafeMath {
289     /**
290      * @dev Returns the addition of two unsigned integers, with an overflow flag.
291      *
292      * _Available since v3.4._
293      */
294     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
295         uint256 c = a + b;
296         if (c < a) return (false, 0);
297         return (true, c);
298     }
299 
300     /**
301      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
302      *
303      * _Available since v3.4._
304      */
305     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
306         if (b > a) return (false, 0);
307         return (true, a - b);
308     }
309 
310     /**
311      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
312      *
313      * _Available since v3.4._
314      */
315     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
316         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
317         // benefit is lost if 'b' is also tested.
318         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
319         if (a == 0) return (true, 0);
320         uint256 c = a * b;
321         if (c / a != b) return (false, 0);
322         return (true, c);
323     }
324 
325     /**
326      * @dev Returns the division of two unsigned integers, with a division by zero flag.
327      *
328      * _Available since v3.4._
329      */
330     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
331         if (b == 0) return (false, 0);
332         return (true, a / b);
333     }
334 
335     /**
336      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
337      *
338      * _Available since v3.4._
339      */
340     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
341         if (b == 0) return (false, 0);
342         return (true, a % b);
343     }
344 
345     /**
346      * @dev Returns the addition of two unsigned integers, reverting on
347      * overflow.
348      *
349      * Counterpart to Solidity's `+` operator.
350      *
351      * Requirements:
352      *
353      * - Addition cannot overflow.
354      */
355     function add(uint256 a, uint256 b) internal pure returns (uint256) {
356         uint256 c = a + b;
357         require(c >= a, "SafeMath: addition overflow");
358         return c;
359     }
360 
361     /**
362      * @dev Returns the subtraction of two unsigned integers, reverting on
363      * overflow (when the result is negative).
364      *
365      * Counterpart to Solidity's `-` operator.
366      *
367      * Requirements:
368      *
369      * - Subtraction cannot overflow.
370      */
371     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
372         require(b <= a, "SafeMath: subtraction overflow");
373         return a - b;
374     }
375 
376     /**
377      * @dev Returns the multiplication of two unsigned integers, reverting on
378      * overflow.
379      *
380      * Counterpart to Solidity's `*` operator.
381      *
382      * Requirements:
383      *
384      * - Multiplication cannot overflow.
385      */
386     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
387         if (a == 0) return 0;
388         uint256 c = a * b;
389         require(c / a == b, "SafeMath: multiplication overflow");
390         return c;
391     }
392 
393     /**
394      * @dev Returns the integer division of two unsigned integers, reverting on
395      * division by zero. The result is rounded towards zero.
396      *
397      * Counterpart to Solidity's `/` operator. Note: this function uses a
398      * `revert` opcode (which leaves remaining gas untouched) while Solidity
399      * uses an invalid opcode to revert (consuming all remaining gas).
400      *
401      * Requirements:
402      *
403      * - The divisor cannot be zero.
404      */
405     function div(uint256 a, uint256 b) internal pure returns (uint256) {
406         require(b > 0, "SafeMath: division by zero");
407         return a / b;
408     }
409 
410     /**
411      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
412      * reverting when dividing by zero.
413      *
414      * Counterpart to Solidity's `%` operator. This function uses a `revert`
415      * opcode (which leaves remaining gas untouched) while Solidity uses an
416      * invalid opcode to revert (consuming all remaining gas).
417      *
418      * Requirements:
419      *
420      * - The divisor cannot be zero.
421      */
422     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
423         require(b > 0, "SafeMath: modulo by zero");
424         return a % b;
425     }
426 
427     /**
428      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
429      * overflow (when the result is negative).
430      *
431      * CAUTION: This function is deprecated because it requires allocating memory for the error
432      * message unnecessarily. For custom revert reasons use {trySub}.
433      *
434      * Counterpart to Solidity's `-` operator.
435      *
436      * Requirements:
437      *
438      * - Subtraction cannot overflow.
439      */
440     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
441         require(b <= a, errorMessage);
442         return a - b;
443     }
444 
445     /**
446      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
447      * division by zero. The result is rounded towards zero.
448      *
449      * CAUTION: This function is deprecated because it requires allocating memory for the error
450      * message unnecessarily. For custom revert reasons use {tryDiv}.
451      *
452      * Counterpart to Solidity's `/` operator. Note: this function uses a
453      * `revert` opcode (which leaves remaining gas untouched) while Solidity
454      * uses an invalid opcode to revert (consuming all remaining gas).
455      *
456      * Requirements:
457      *
458      * - The divisor cannot be zero.
459      */
460     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
461         require(b > 0, errorMessage);
462         return a / b;
463     }
464 
465     /**
466      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
467      * reverting with custom message when dividing by zero.
468      *
469      * CAUTION: This function is deprecated because it requires allocating memory for the error
470      * message unnecessarily. For custom revert reasons use {tryMod}.
471      *
472      * Counterpart to Solidity's `%` operator. This function uses a `revert`
473      * opcode (which leaves remaining gas untouched) while Solidity uses an
474      * invalid opcode to revert (consuming all remaining gas).
475      *
476      * Requirements:
477      *
478      * - The divisor cannot be zero.
479      */
480     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
481         require(b > 0, errorMessage);
482         return a % b;
483     }
484 }
485 
486 /**
487  * @dev Interface of the ERC20 standard as defined in the EIP.
488  */
489 interface IERC20 {
490     /**
491      * @dev Returns the amount of tokens in existence.
492      */
493     function totalSupply() external view returns (uint256);
494 
495     /**
496      * @dev Returns the amount of tokens owned by `account`.
497      */
498     function balanceOf(address account) external view returns (uint256);
499 
500     /**
501      * @dev Moves `amount` tokens from the caller's account to `recipient`.
502      *
503      * Returns a boolean value indicating whether the operation succeeded.
504      *
505      * Emits a {Transfer} event.
506      */
507     function transfer(address recipient, uint256 amount) external returns (bool);
508 
509     /**
510      * @dev Returns the remaining number of tokens that `spender` will be
511      * allowed to spend on behalf of `owner` through {transferFrom}. This is
512      * zero by default.
513      *
514      * This value changes when {approve} or {transferFrom} are called.
515      */
516     function allowance(address owner, address spender) external view returns (uint256);
517 
518     /**
519      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
520      *
521      * Returns a boolean value indicating whether the operation succeeded.
522      *
523      * IMPORTANT: Beware that changing an allowance with this method brings the risk
524      * that someone may use both the old and the new allowance by unfortunate
525      * transaction ordering. One possible solution to mitigate this race
526      * condition is to first reduce the spender's allowance to 0 and set the
527      * desired value afterwards:
528      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
529      *
530      * Emits an {Approval} event.
531      */
532     function approve(address spender, uint256 amount) external returns (bool);
533 
534     /**
535      * @dev Moves `amount` tokens from `sender` to `recipient` using the
536      * allowance mechanism. `amount` is then deducted from the caller's
537      * allowance.
538      *
539      * Returns a boolean value indicating whether the operation succeeded.
540      *
541      * Emits a {Transfer} event.
542      */
543     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
544 
545     /**
546      * @dev Emitted when `value` tokens are moved from one account (`from`) to
547      * another (`to`).
548      *
549      * Note that `value` may be zero.
550      */
551     event Transfer(address indexed from, address indexed to, uint256 value);
552 
553     /**
554      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
555      * a call to {approve}. `value` is the new allowance.
556      */
557     event Approval(address indexed owner, address indexed spender, uint256 value);
558 }
559 
560 /**
561  * @title SafeERC20
562  * @dev Wrappers around ERC20 operations that throw on failure (when the token
563  * contract returns false). Tokens that return no value (and instead revert or
564  * throw on failure) are also supported, non-reverting calls are assumed to be
565  * successful.
566  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
567  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
568  */
569 library SafeERC20 {
570     using SafeMath for uint256;
571     using Address for address;
572 
573     function safeTransfer(IERC20 token, address to, uint256 value) internal {
574         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
575     }
576 
577     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
578         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
579     }
580 
581     /**
582      * @dev Deprecated. This function has issues similar to the ones found in
583      * {IERC20-approve}, and its usage is discouraged.
584      *
585      * Whenever possible, use {safeIncreaseAllowance} and
586      * {safeDecreaseAllowance} instead.
587      */
588     function safeApprove(IERC20 token, address spender, uint256 value) internal {
589         // safeApprove should only be called when setting an initial allowance,
590         // or when resetting it to zero. To increase and decrease it, use
591         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
592         // solhint-disable-next-line max-line-length
593         require((value == 0) || (token.allowance(address(this), spender) == 0),
594             "SafeERC20: approve from non-zero to non-zero allowance"
595         );
596         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
597     }
598 
599     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
600         uint256 newAllowance = token.allowance(address(this), spender).add(value);
601         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
602     }
603 
604     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
605         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
606         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
607     }
608 
609     /**
610      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
611      * on the return value: the return value is optional (but if data is returned, it must not be false).
612      * @param token The token targeted by the call.
613      * @param data The call data (encoded using abi.encode or one of its variants).
614      */
615     function _callOptionalReturn(IERC20 token, bytes memory data) private {
616         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
617         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
618         // the target address contains contract code and also asserts for success in the low-level call.
619 
620         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
621         if (returndata.length > 0) { // Return data is optional
622             // solhint-disable-next-line max-line-length
623             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
624         }
625     }
626 }
627 
628 /**
629  * @dev Implementation of the {IERC20} interface.
630  *
631  * This implementation is agnostic to the way tokens are created. This means
632  * that a supply mechanism has to be added in a derived contract using {_mint}.
633  * For a generic mechanism see {ERC20PresetMinterPauser}.
634  *
635  * TIP: For a detailed writeup see our guide
636  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
637  * to implement supply mechanisms].
638  *
639  * We have followed general OpenZeppelin guidelines: functions revert instead
640  * of returning `false` on failure. This behavior is nonetheless conventional
641  * and does not conflict with the expectations of ERC20 applications.
642  *
643  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
644  * This allows applications to reconstruct the allowance for all accounts just
645  * by listening to said events. Other implementations of the EIP may not emit
646  * these events, as it isn't required by the specification.
647  *
648  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
649  * functions have been added to mitigate the well-known issues around setting
650  * allowances. See {IERC20-approve}.
651  */
652 contract ERC20 is Context, IERC20 {
653     using SafeMath for uint256;
654 
655     mapping (address => uint256) private _balances;
656 
657     mapping (address => mapping (address => uint256)) private _allowances;
658 
659     uint256 private _totalSupply;
660 
661     string private _name;
662     string private _symbol;
663     uint8 private _decimals;
664 
665     /**
666      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
667      * a default value of 18.
668      *
669      * To select a different value for {decimals}, use {_setupDecimals}.
670      *
671      * All three of these values are immutable: they can only be set once during
672      * construction.
673      */
674     constructor (string memory name_, string memory symbol_) public {
675         _name = name_;
676         _symbol = symbol_;
677         _decimals = 18;
678     }
679 
680     /**
681      * @dev Returns the name of the token.
682      */
683     function name() public view virtual returns (string memory) {
684         return _name;
685     }
686 
687     /**
688      * @dev Returns the symbol of the token, usually a shorter version of the
689      * name.
690      */
691     function symbol() public view virtual returns (string memory) {
692         return _symbol;
693     }
694 
695     /**
696      * @dev Returns the number of decimals used to get its user representation.
697      * For example, if `decimals` equals `2`, a balance of `505` tokens should
698      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
699      *
700      * Tokens usually opt for a value of 18, imitating the relationship between
701      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
702      * called.
703      *
704      * NOTE: This information is only used for _display_ purposes: it in
705      * no way affects any of the arithmetic of the contract, including
706      * {IERC20-balanceOf} and {IERC20-transfer}.
707      */
708     function decimals() public view virtual returns (uint8) {
709         return _decimals;
710     }
711 
712     /**
713      * @dev See {IERC20-totalSupply}.
714      */
715     function totalSupply() public view virtual override returns (uint256) {
716         return _totalSupply;
717     }
718 
719     /**
720      * @dev See {IERC20-balanceOf}.
721      */
722     function balanceOf(address account) public view virtual override returns (uint256) {
723         return _balances[account];
724     }
725 
726     /**
727      * @dev See {IERC20-transfer}.
728      *
729      * Requirements:
730      *
731      * - `recipient` cannot be the zero address.
732      * - the caller must have a balance of at least `amount`.
733      */
734     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
735         _transfer(_msgSender(), recipient, amount);
736         return true;
737     }
738 
739     /**
740      * @dev See {IERC20-allowance}.
741      */
742     function allowance(address owner, address spender) public view virtual override returns (uint256) {
743         return _allowances[owner][spender];
744     }
745 
746     /**
747      * @dev See {IERC20-approve}.
748      *
749      * Requirements:
750      *
751      * - `spender` cannot be the zero address.
752      */
753     function approve(address spender, uint256 amount) public virtual override returns (bool) {
754         _approve(_msgSender(), spender, amount);
755         return true;
756     }
757 
758     /**
759      * @dev See {IERC20-transferFrom}.
760      *
761      * Emits an {Approval} event indicating the updated allowance. This is not
762      * required by the EIP. See the note at the beginning of {ERC20}.
763      *
764      * Requirements:
765      *
766      * - `sender` and `recipient` cannot be the zero address.
767      * - `sender` must have a balance of at least `amount`.
768      * - the caller must have allowance for ``sender``'s tokens of at least
769      * `amount`.
770      */
771     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
772         _transfer(sender, recipient, amount);
773         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
774         return true;
775     }
776 
777     /**
778      * @dev Atomically increases the allowance granted to `spender` by the caller.
779      *
780      * This is an alternative to {approve} that can be used as a mitigation for
781      * problems described in {IERC20-approve}.
782      *
783      * Emits an {Approval} event indicating the updated allowance.
784      *
785      * Requirements:
786      *
787      * - `spender` cannot be the zero address.
788      */
789     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
790         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
791         return true;
792     }
793 
794     /**
795      * @dev Atomically decreases the allowance granted to `spender` by the caller.
796      *
797      * This is an alternative to {approve} that can be used as a mitigation for
798      * problems described in {IERC20-approve}.
799      *
800      * Emits an {Approval} event indicating the updated allowance.
801      *
802      * Requirements:
803      *
804      * - `spender` cannot be the zero address.
805      * - `spender` must have allowance for the caller of at least
806      * `subtractedValue`.
807      */
808     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
809         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
810         return true;
811     }
812 
813     /**
814      * @dev Moves tokens `amount` from `sender` to `recipient`.
815      *
816      * This is internal function is equivalent to {transfer}, and can be used to
817      * e.g. implement automatic token fees, slashing mechanisms, etc.
818      *
819      * Emits a {Transfer} event.
820      *
821      * Requirements:
822      *
823      * - `sender` cannot be the zero address.
824      * - `recipient` cannot be the zero address.
825      * - `sender` must have a balance of at least `amount`.
826      */
827     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
828         require(sender != address(0), "ERC20: transfer from the zero address");
829         require(recipient != address(0), "ERC20: transfer to the zero address");
830 
831         _beforeTokenTransfer(sender, recipient, amount);
832 
833         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
834         _balances[recipient] = _balances[recipient].add(amount);
835         emit Transfer(sender, recipient, amount);
836     }
837 
838     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
839      * the total supply.
840      *
841      * Emits a {Transfer} event with `from` set to the zero address.
842      *
843      * Requirements:
844      *
845      * - `to` cannot be the zero address.
846      */
847     function _mint(address account, uint256 amount) internal virtual {
848         require(account != address(0), "ERC20: mint to the zero address");
849 
850         _beforeTokenTransfer(address(0), account, amount);
851 
852         _totalSupply = _totalSupply.add(amount);
853         _balances[account] = _balances[account].add(amount);
854         emit Transfer(address(0), account, amount);
855     }
856 
857     /**
858      * @dev Destroys `amount` tokens from `account`, reducing the
859      * total supply.
860      *
861      * Emits a {Transfer} event with `to` set to the zero address.
862      *
863      * Requirements:
864      *
865      * - `account` cannot be the zero address.
866      * - `account` must have at least `amount` tokens.
867      */
868     function _burn(address account, uint256 amount) internal virtual {
869         require(account != address(0), "ERC20: burn from the zero address");
870 
871         _beforeTokenTransfer(account, address(0), amount);
872 
873         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
874         _totalSupply = _totalSupply.sub(amount);
875         emit Transfer(account, address(0), amount);
876     }
877 
878     /**
879      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
880      *
881      * This internal function is equivalent to `approve`, and can be used to
882      * e.g. set automatic allowances for certain subsystems, etc.
883      *
884      * Emits an {Approval} event.
885      *
886      * Requirements:
887      *
888      * - `owner` cannot be the zero address.
889      * - `spender` cannot be the zero address.
890      */
891     function _approve(address owner, address spender, uint256 amount) internal virtual {
892         require(owner != address(0), "ERC20: approve from the zero address");
893         require(spender != address(0), "ERC20: approve to the zero address");
894 
895         _allowances[owner][spender] = amount;
896         emit Approval(owner, spender, amount);
897     }
898 
899     /**
900      * @dev Sets {decimals} to a value other than the default one of 18.
901      *
902      * WARNING: This function should only be called from the constructor. Most
903      * applications that interact with token contracts will not expect
904      * {decimals} to ever change, and may work incorrectly if it does.
905      */
906     function _setupDecimals(uint8 decimals_) internal virtual {
907         _decimals = decimals_;
908     }
909 
910     /**
911      * @dev Hook that is called before any transfer of tokens. This includes
912      * minting and burning.
913      *
914      * Calling conditions:
915      *
916      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
917      * will be to transferred to `to`.
918      * - when `from` is zero, `amount` tokens will be minted for `to`.
919      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
920      * - `from` and `to` are never both zero.
921      *
922      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
923      */
924     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
925 }
926 
927 // MonfterToken with Governance.
928 contract MonfterToken is ERC20("MonfterToken", "MON"), Ownable {
929     using SafeMath for uint256;
930     using SafeERC20 for IERC20;
931 
932     // @notice Copied and modified from YAM code:
933     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
934     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
935     // Which is copied and modified from COMPOUND:
936     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
937 
938     /// @dev A record of each accounts delegate
939     mapping (address => address) internal _delegates;
940 
941     /// @notice A checkpoint for marking number of votes from a given block
942     struct Checkpoint {
943         uint32 fromBlock;
944         uint256 votes;
945     }
946 
947     /// @notice A record of votes checkpoints for each account, by index
948     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
949 
950     /// @notice The number of checkpoints for each account
951     mapping (address => uint32) public numCheckpoints;
952 
953     /// @notice The EIP-712 typehash for the contract's domain
954     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
955 
956     /// @notice The EIP-712 typehash for the delegation struct used by the contract
957     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
958 
959     /// @notice A record of states for signing / validating signatures
960     mapping (address => uint) public nonces;
961 
962     /// @notice An event thats emitted when an account changes its delegate
963     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
964 
965     /// @notice An event thats emitted when a delegate account's vote balance changes
966     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
967 
968     /**
969     * @notice MonfterToken constructor
970     */
971     constructor() {
972         uint256 totalSupply = 15 * 1e8 * 1e18;
973         _mint(0xD9d13237e9DA35D98eEB2187cD99b3FD205d3465, totalSupply);
974     }
975 
976     /**
977      * @dev Hook that is called before any transfer of tokens. This includes
978      * minting and burning.
979      *
980      * Calling conditions:
981      *
982      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
983      * will be to transferred to `to`.
984      * - when `from` is zero, `amount` tokens will be minted for `to`.
985      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
986      * - `from` and `to` are never both zero.
987      *
988      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
989      */
990     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
991         _moveDelegates(_delegates[from], _delegates[to], amount);
992     }
993 
994     /**
995      * @notice Delegate votes from `msg.sender` to `delegatee`
996      * @param delegator The address to get delegatee for
997      */
998     function delegates(address delegator)
999     external
1000     view
1001     returns (address)
1002     {
1003         return _delegates[delegator];
1004     }
1005 
1006     /**
1007      * @notice Delegate votes from `msg.sender` to `delegatee`
1008      * @param delegatee The address to delegate votes to
1009      */
1010     function delegate(address delegatee) external {
1011         return _delegate(msg.sender, delegatee);
1012     }
1013 
1014     /**
1015      * @notice Delegates votes from signatory to `delegatee`
1016      * @param delegatee The address to delegate votes to
1017      * @param nonce The contract state required to match the signature
1018      * @param expiry The time at which to expire the signature
1019      * @param v The recovery byte of the signature
1020      * @param r Half of the ECDSA signature pair
1021      * @param s Half of the ECDSA signature pair
1022      */
1023     function delegateBySig(
1024         address delegatee,
1025         uint nonce,
1026         uint expiry,
1027         uint8 v,
1028         bytes32 r,
1029         bytes32 s
1030     )
1031     external
1032     {
1033         bytes32 domainSeparator = keccak256(
1034             abi.encode(
1035                 DOMAIN_TYPEHASH,
1036                 keccak256(bytes(name())),
1037                 getChainId(),
1038                 address(this)
1039             )
1040         );
1041 
1042         bytes32 structHash = keccak256(
1043             abi.encode(
1044                 DELEGATION_TYPEHASH,
1045                 delegatee,
1046                 nonce,
1047                 expiry
1048             )
1049         );
1050 
1051         bytes32 digest = keccak256(
1052             abi.encodePacked(
1053                 "\x19\x01",
1054                 domainSeparator,
1055                 structHash
1056             )
1057         );
1058 
1059         address signatory = ecrecover(digest, v, r, s);
1060         require(signatory != address(0), "delegateBySig: invalid signature");
1061         require(nonce == nonces[signatory]++, "delegateBySig: invalid nonce");
1062         require(block.timestamp <= expiry, "delegateBySig: signature expired");
1063         return _delegate(signatory, delegatee);
1064     }
1065 
1066     /**
1067      * @notice Gets the current votes balance for `account`
1068      * @param account The address to get votes balance
1069      * @return The number of current votes for `account`
1070      */
1071     function getCurrentVotes(address account)
1072     external
1073     view
1074     returns (uint256)
1075     {
1076         uint32 nCheckpoints = numCheckpoints[account];
1077         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1078     }
1079 
1080     /**
1081      * @notice Determine the prior number of votes for an account as of a block number
1082      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1083      * @param account The address of the account to check
1084      * @param blockNumber The block number to get the vote balance at
1085      * @return The number of votes the account had as of the given block
1086      */
1087     function getPriorVotes(address account, uint blockNumber)
1088     external
1089     view
1090     returns (uint256)
1091     {
1092         require(blockNumber < block.number, "getPriorVotes: not yet determined");
1093 
1094         uint32 nCheckpoints = numCheckpoints[account];
1095         if (nCheckpoints == 0) {
1096             return 0;
1097         }
1098 
1099         // First check most recent balance
1100         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1101             return checkpoints[account][nCheckpoints - 1].votes;
1102         }
1103 
1104         // Next check implicit zero balance
1105         if (checkpoints[account][0].fromBlock > blockNumber) {
1106             return 0;
1107         }
1108 
1109         uint32 lower = 0;
1110         uint32 upper = nCheckpoints - 1;
1111         while (upper > lower) {
1112             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1113             Checkpoint memory cp = checkpoints[account][center];
1114             if (cp.fromBlock == blockNumber) {
1115                 return cp.votes;
1116             } else if (cp.fromBlock < blockNumber) {
1117                 lower = center;
1118             } else {
1119                 upper = center - 1;
1120             }
1121         }
1122         return checkpoints[account][lower].votes;
1123     }
1124 
1125     function _delegate(address delegator, address delegatee)
1126     internal
1127     {
1128         address currentDelegate = _delegates[delegator];
1129         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying Leek (not scaled);
1130         _delegates[delegator] = delegatee;
1131 
1132         emit DelegateChanged(delegator, currentDelegate, delegatee);
1133 
1134         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1135     }
1136 
1137     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1138         if (srcRep != dstRep && amount > 0) {
1139             if (srcRep != address(0)) {
1140                 // decrease old representative
1141                 uint32 srcRepNum = numCheckpoints[srcRep];
1142                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1143                 uint256 srcRepNew = srcRepOld.sub(amount);
1144                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1145             }
1146 
1147             if (dstRep != address(0)) {
1148                 // increase new representative
1149                 uint32 dstRepNum = numCheckpoints[dstRep];
1150                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1151                 uint256 dstRepNew = dstRepOld.add(amount);
1152                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1153             }
1154         }
1155     }
1156 
1157     function _writeCheckpoint(
1158         address delegatee,
1159         uint32 nCheckpoints,
1160         uint256 oldVotes,
1161         uint256 newVotes
1162     )
1163     internal
1164     {
1165         uint32 blockNumber = safe32(block.number, "_writeCheckpoint: block number exceeds 32 bits");
1166 
1167         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1168             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1169         } else {
1170             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1171             numCheckpoints[delegatee] = nCheckpoints + 1;
1172         }
1173 
1174         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1175     }
1176 
1177     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1178         require(n < 2**32, errorMessage);
1179         return uint32(n);
1180     }
1181 
1182     function getChainId() internal pure returns (uint) {
1183         uint256 chainId;
1184         assembly { chainId := chainid() }
1185         return chainId;
1186     }
1187 }