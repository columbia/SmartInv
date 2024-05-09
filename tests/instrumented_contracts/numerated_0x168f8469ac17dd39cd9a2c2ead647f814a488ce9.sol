1 /**
2 OnX.finance
3 >
4 farming contract inspired from the great sushi chefs
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity >=0.6.0 <0.8.0;
9 
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations with added overflow
12  * checks.
13  *
14  * Arithmetic operations in Solidity wrap on overflow. This can easily result
15  * in bugs, because programmers usually assume that an overflow raises an
16  * error, which is the standard behavior in high level programming languages.
17  * `SafeMath` restores this intuition by reverting the transaction when an
18  * operation overflows.
19  *
20  * Using this library instead of the unchecked operations eliminates an entire
21  * class of bugs, so it's recommended to use it always.
22  */
23 library SafeMath {
24     /**
25      * @dev Returns the addition of two unsigned integers, reverting on
26      * overflow.
27      *
28      * Counterpart to Solidity's `+` operator.
29      *
30      * Requirements:
31      *
32      * - Addition cannot overflow.
33      */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, reverting on
43      * overflow (when the result is negative).
44      *
45      * Counterpart to Solidity's `-` operator.
46      *
47      * Requirements:
48      *
49      * - Subtraction cannot overflow.
50      */
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
57      * overflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      *
63      * - Subtraction cannot overflow.
64      */
65     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the multiplication of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `*` operator.
77      *
78      * Requirements:
79      *
80      * - Multiplication cannot overflow.
81      */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the integer division of two unsigned integers. Reverts on
98      * division by zero. The result is rounded towards zero.
99      *
100      * Counterpart to Solidity's `/` operator. Note: this function uses a
101      * `revert` opcode (which leaves remaining gas untouched) while Solidity
102      * uses an invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      *
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
134      * Reverts when dividing by zero.
135      *
136      * Counterpart to Solidity's `%` operator. This function uses a `revert`
137      * opcode (which leaves remaining gas untouched) while Solidity uses an
138      * invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      *
142      * - The divisor cannot be zero.
143      */
144     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145         return mod(a, b, "SafeMath: modulo by zero");
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts with custom message when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b != 0, errorMessage);
162         return a % b;
163     }
164 }
165 
166 /**
167  * @dev Interface of the ERC20 standard as defined in the EIP.
168  */
169 interface IERC20 {
170     /**
171      * @dev Returns the amount of tokens in existence.
172      */
173     function totalSupply() external view returns (uint256);
174 
175     /**
176      * @dev Returns the amount of tokens owned by `account`.
177      */
178     function balanceOf(address account) external view returns (uint256);
179 
180     /**
181      * @dev Moves `amount` tokens from the caller's account to `recipient`.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transfer(address recipient, uint256 amount) external returns (bool);
188 
189     /**
190      * @dev Returns the remaining number of tokens that `spender` will be
191      * allowed to spend on behalf of `owner` through {transferFrom}. This is
192      * zero by default.
193      *
194      * This value changes when {approve} or {transferFrom} are called.
195      */
196     function allowance(address owner, address spender) external view returns (uint256);
197 
198     /**
199      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * IMPORTANT: Beware that changing an allowance with this method brings the risk
204      * that someone may use both the old and the new allowance by unfortunate
205      * transaction ordering. One possible solution to mitigate this race
206      * condition is to first reduce the spender's allowance to 0 and set the
207      * desired value afterwards:
208      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209      *
210      * Emits an {Approval} event.
211      */
212     function approve(address spender, uint256 amount) external returns (bool);
213 
214     /**
215      * @dev Moves `amount` tokens from `sender` to `recipient` using the
216      * allowance mechanism. `amount` is then deducted from the caller's
217      * allowance.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Emitted when `value` tokens are moved from one account (`from`) to
227      * another (`to`).
228      *
229      * Note that `value` may be zero.
230      */
231     event Transfer(address indexed from, address indexed to, uint256 value);
232 
233     /**
234      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
235      * a call to {approve}. `value` is the new allowance.
236      */
237     event Approval(address indexed owner, address indexed spender, uint256 value);
238 }
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize, which returns 0 for contracts in
263         // construction, since the code is only stored at the end of the
264         // constructor execution.
265 
266         uint256 size;
267         // solhint-disable-next-line no-inline-assembly
268         assembly { size := extcodesize(account) }
269         return size > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
292         (bool success, ) = recipient.call{ value: amount }("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain`call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315       return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345      * with `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
350         require(address(this).balance >= value, "Address: insufficient balance for call");
351         require(isContract(target), "Address: call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = target.call{ value: value }(data);
355         return _verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
365         return functionStaticCall(target, data, "Address: low-level static call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
375         require(isContract(target), "Address: static call to non-contract");
376 
377         // solhint-disable-next-line avoid-low-level-calls
378         (bool success, bytes memory returndata) = target.staticcall(data);
379         return _verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a delegate call.
385      *
386      * _Available since v3.3._
387      */
388     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
389         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.3._
397      */
398     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
399         require(isContract(target), "Address: delegate call to non-contract");
400 
401         // solhint-disable-next-line avoid-low-level-calls
402         (bool success, bytes memory returndata) = target.delegatecall(data);
403         return _verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
407         if (success) {
408             return returndata;
409         } else {
410             // Look for revert reason and bubble it up if present
411             if (returndata.length > 0) {
412                 // The easiest way to bubble the revert reason is using memory via assembly
413 
414                 // solhint-disable-next-line no-inline-assembly
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 
427 /**
428  * @title SafeERC20
429  * @dev Wrappers around ERC20 operations that throw on failure (when the token
430  * contract returns false). Tokens that return no value (and instead revert or
431  * throw on failure) are also supported, non-reverting calls are assumed to be
432  * successful.
433  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
434  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
435  */
436 library SafeERC20 {
437     using SafeMath for uint256;
438     using Address for address;
439 
440     function safeTransfer(IERC20 token, address to, uint256 value) internal {
441         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
442     }
443 
444     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
445         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
446     }
447 
448     /**
449      * @dev Deprecated. This function has issues similar to the ones found in
450      * {IERC20-approve}, and its usage is discouraged.
451      *
452      * Whenever possible, use {safeIncreaseAllowance} and
453      * {safeDecreaseAllowance} instead.
454      */
455     function safeApprove(IERC20 token, address spender, uint256 value) internal {
456         // safeApprove should only be called when setting an initial allowance,
457         // or when resetting it to zero. To increase and decrease it, use
458         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
459         // solhint-disable-next-line max-line-length
460         require((value == 0) || (token.allowance(address(this), spender) == 0),
461             "SafeERC20: approve from non-zero to non-zero allowance"
462         );
463         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
464     }
465 
466     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
467         uint256 newAllowance = token.allowance(address(this), spender).add(value);
468         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
469     }
470 
471     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
472         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
473         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
474     }
475 
476     /**
477      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
478      * on the return value: the return value is optional (but if data is returned, it must not be false).
479      * @param token The token targeted by the call.
480      * @param data The call data (encoded using abi.encode or one of its variants).
481      */
482     function _callOptionalReturn(IERC20 token, bytes memory data) private {
483         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
484         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
485         // the target address contains contract code and also asserts for success in the low-level call.
486 
487         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
488         if (returndata.length > 0) { // Return data is optional
489             // solhint-disable-next-line max-line-length
490             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
491         }
492     }
493 }
494 
495 /*
496  * @dev Provides information about the current execution context, including the
497  * sender of the transaction and its data. While these are generally available
498  * via msg.sender and msg.data, they should not be accessed in such a direct
499  * manner, since when dealing with GSN meta-transactions the account sending and
500  * paying for execution may not be the actual sender (as far as an application
501  * is concerned).
502  *
503  * This contract is only required for intermediate, library-like contracts.
504  */
505 abstract contract Context {
506     function _msgSender() internal view virtual returns (address payable) {
507         return msg.sender;
508     }
509 
510     function _msgData() internal view virtual returns (bytes memory) {
511         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
512         return msg.data;
513     }
514 }
515 
516 /**
517  * @dev Contract module which provides a basic access control mechanism, where
518  * there is an account (an owner) that can be granted exclusive access to
519  * specific functions.
520  *
521  * By default, the owner account will be the one that deploys the contract. This
522  * can later be changed with {transferOwnership}.
523  *
524  * This module is used through inheritance. It will make available the modifier
525  * `onlyOwner`, which can be applied to your functions to restrict their use to
526  * the owner.
527  */
528 abstract contract Ownable is Context {
529     address private _owner;
530 
531     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
532 
533     /**
534      * @dev Initializes the contract setting the deployer as the initial owner.
535      */
536     constructor () internal {
537         address msgSender = _msgSender();
538         _owner = msgSender;
539         emit OwnershipTransferred(address(0), msgSender);
540     }
541 
542     /**
543      * @dev Returns the address of the current owner.
544      */
545     function owner() public view returns (address) {
546         return _owner;
547     }
548 
549     /**
550      * @dev Throws if called by any account other than the owner.
551      */
552     modifier onlyOwner() {
553         require(_owner == _msgSender(), "Ownable: caller is not the owner");
554         _;
555     }
556 
557     /**
558      * @dev Leaves the contract without owner. It will not be possible to call
559      * `onlyOwner` functions anymore. Can only be called by the current owner.
560      *
561      * NOTE: Renouncing ownership will leave the contract without an owner,
562      * thereby removing any functionality that is only available to the owner.
563      */
564     function renounceOwnership() public virtual onlyOwner {
565         emit OwnershipTransferred(_owner, address(0));
566         _owner = address(0);
567     }
568 
569     /**
570      * @dev Transfers ownership of the contract to a new account (`newOwner`).
571      * Can only be called by the current owner.
572      */
573     function transferOwnership(address newOwner) public virtual onlyOwner {
574         require(newOwner != address(0), "Ownable: new owner is the zero address");
575         emit OwnershipTransferred(_owner, newOwner);
576         _owner = newOwner;
577     }
578 }
579 
580 
581 /**
582  * @dev Implementation of the {IERC20} interface.
583  *
584  * This implementation is agnostic to the way tokens are created. This means
585  * that a supply mechanism has to be added in a derived contract using {_mint}.
586  * For a generic mechanism see {ERC20PresetMinterPauser}.
587  *
588  * TIP: For a detailed writeup see our guide
589  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
590  * to implement supply mechanisms].
591  *
592  * We have followed general OpenZeppelin guidelines: functions revert instead
593  * of returning `false` on failure. This behavior is nonetheless conventional
594  * and does not conflict with the expectations of ERC20 applications.
595  *
596  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
597  * This allows applications to reconstruct the allowance for all accounts just
598  * by listening to said events. Other implementations of the EIP may not emit
599  * these events, as it isn't required by the specification.
600  *
601  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
602  * functions have been added to mitigate the well-known issues around setting
603  * allowances. See {IERC20-approve}.
604  */
605 contract ERC20 is Context, IERC20, Ownable {
606     using SafeMath for uint256;
607 
608     mapping (address => uint256) private _balances;
609 
610     mapping (address => mapping (address => uint256)) private _allowances;
611 
612     uint256 private _totalSupply;
613 
614     string private _name;
615     string private _symbol;
616     uint8 private _decimals;
617 
618     /**
619      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
620      * a default value of 18.
621      *
622      * To select a different value for {decimals}, use {_setupDecimals}.
623      *
624      * All three of these values are immutable: they can only be set once during
625      * construction.
626      */
627     constructor (string memory name_, string memory symbol_) public {
628         _name = name_;
629         _symbol = symbol_;
630         _decimals = 18;
631     }
632 
633     /**
634      * @dev Returns the name of the token.
635      */
636     function name() public view returns (string memory) {
637         return _name;
638     }
639 
640     /**
641      * @dev Returns the symbol of the token, usually a shorter version of the
642      * name.
643      */
644     function symbol() public view returns (string memory) {
645         return _symbol;
646     }
647 
648     /**
649      * @dev Returns the number of decimals used to get its user representation.
650      * For example, if `decimals` equals `2`, a balance of `505` tokens should
651      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
652      *
653      * Tokens usually opt for a value of 18, imitating the relationship between
654      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
655      * called.
656      *
657      * NOTE: This information is only used for _display_ purposes: it in
658      * no way affects any of the arithmetic of the contract, including
659      * {IERC20-balanceOf} and {IERC20-transfer}.
660      */
661     function decimals() public view returns (uint8) {
662         return _decimals;
663     }
664 
665     /**
666      * @dev See {IERC20-totalSupply}.
667      */
668     function totalSupply() public view override returns (uint256) {
669         return _totalSupply;
670     }
671 
672     /**
673      * @dev See {IERC20-balanceOf}.
674      */
675     function balanceOf(address account) public view override returns (uint256) {
676         return _balances[account];
677     }
678 
679     /**
680      * @dev See {IERC20-transfer}.
681      *
682      * Requirements:
683      *
684      * - `recipient` cannot be the zero address.
685      * - the caller must have a balance of at least `amount`.
686      */
687     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
688         _transfer(_msgSender(), recipient, amount);
689         return true;
690     }
691 
692     /**
693      * @dev See {IERC20-allowance}.
694      */
695     function allowance(address owner, address spender) public view virtual override returns (uint256) {
696         return _allowances[owner][spender];
697     }
698 
699     /**
700      * @dev See {IERC20-approve}.
701      *
702      * Requirements:
703      *
704      * - `spender` cannot be the zero address.
705      */
706     function approve(address spender, uint256 amount) public virtual override returns (bool) {
707         _approve(_msgSender(), spender, amount);
708         return true;
709     }
710 
711     /**
712      * @dev See {IERC20-transferFrom}.
713      *
714      * Emits an {Approval} event indicating the updated allowance. This is not
715      * required by the EIP. See the note at the beginning of {ERC20}.
716      *
717      * Requirements:
718      *
719      * - `sender` and `recipient` cannot be the zero address.
720      * - `sender` must have a balance of at least `amount`.
721      * - the caller must have allowance for ``sender``'s tokens of at least
722      * `amount`.
723      */
724     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
725         _transfer(sender, recipient, amount);
726         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
727         return true;
728     }
729 
730     /**
731      * @dev Atomically increases the allowance granted to `spender` by the caller.
732      *
733      * This is an alternative to {approve} that can be used as a mitigation for
734      * problems described in {IERC20-approve}.
735      *
736      * Emits an {Approval} event indicating the updated allowance.
737      *
738      * Requirements:
739      *
740      * - `spender` cannot be the zero address.
741      */
742     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
743         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
744         return true;
745     }
746 
747     /**
748      * @dev Atomically decreases the allowance granted to `spender` by the caller.
749      *
750      * This is an alternative to {approve} that can be used as a mitigation for
751      * problems described in {IERC20-approve}.
752      *
753      * Emits an {Approval} event indicating the updated allowance.
754      *
755      * Requirements:
756      *
757      * - `spender` cannot be the zero address.
758      * - `spender` must have allowance for the caller of at least
759      * `subtractedValue`.
760      */
761     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
762         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
763         return true;
764     }
765 
766     /**
767      * @dev Moves tokens `amount` from `sender` to `recipient`.
768      *
769      * This is internal function is equivalent to {transfer}, and can be used to
770      * e.g. implement automatic token fees, slashing mechanisms, etc.
771      *
772      * Emits a {Transfer} event.
773      *
774      * Requirements:
775      *
776      * - `sender` cannot be the zero address.
777      * - `recipient` cannot be the zero address.
778      * - `sender` must have a balance of at least `amount`.
779      */
780     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
781         require(sender != address(0), "ERC20: transfer from the zero address");
782         require(recipient != address(0), "ERC20: transfer to the zero address");
783 
784         _beforeTokenTransfer(sender, recipient, amount);
785 
786         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
787         _balances[recipient] = _balances[recipient].add(amount);
788         emit Transfer(sender, recipient, amount);
789     }
790 
791     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
792      * the total supply.
793      *
794      * Emits a {Transfer} event with `from` set to the zero address.
795      *
796      * Requirements:
797      *
798      * - `to` cannot be the zero address.
799      */
800     function _mint(address account, uint256 amount) internal virtual {
801         require(account != address(0), "ERC20: mint to the zero address");
802 
803         _beforeTokenTransfer(address(0), account, amount);
804 
805         _totalSupply = _totalSupply.add(amount);
806         _balances[account] = _balances[account].add(amount);
807         emit Transfer(address(0), account, amount);
808     }
809 
810     /**
811      * @dev Destroys `amount` tokens from `account`, reducing the
812      * total supply.
813      *
814      * Emits a {Transfer} event with `to` set to the zero address.
815      *
816      * Requirements:
817      *
818      * - `account` cannot be the zero address.
819      * - `account` must have at least `amount` tokens.
820      */
821     function _burn(address account, uint256 amount) internal virtual {
822         require(account != address(0), "ERC20: burn from the zero address");
823 
824         _beforeTokenTransfer(account, address(0), amount);
825 
826         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
827         _totalSupply = _totalSupply.sub(amount);
828         emit Transfer(account, address(0), amount);
829     }
830 
831     /**
832      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
833      *
834      * This internal function is equivalent to `approve`, and can be used to
835      * e.g. set automatic allowances for certain subsystems, etc.
836      *
837      * Emits an {Approval} event.
838      *
839      * Requirements:
840      *
841      * - `owner` cannot be the zero address.
842      * - `spender` cannot be the zero address.
843      */
844     function _approve(address owner, address spender, uint256 amount) internal virtual {
845         require(owner != address(0), "ERC20: approve from the zero address");
846         require(spender != address(0), "ERC20: approve to the zero address");
847 
848         _allowances[owner][spender] = amount;
849         emit Approval(owner, spender, amount);
850     }
851 
852     /**
853      * @dev Sets {decimals} to a value other than the default one of 18.
854      *
855      * WARNING: This function should only be called from the constructor. Most
856      * applications that interact with token contracts will not expect
857      * {decimals} to ever change, and may work incorrectly if it does.
858      */
859     function _setupDecimals(uint8 decimals_) internal {
860         _decimals = decimals_;
861     }
862 
863     /**
864      * @dev Hook that is called before any transfer of tokens. This includes
865      * minting and burning.
866      *
867      * Calling conditions:
868      *
869      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
870      * will be to transferred to `to`.
871      * - when `from` is zero, `amount` tokens will be minted for `to`.
872      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
873      * - `from` and `to` are never both zero.
874      *
875      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
876      */
877     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
878 }
879 
880 contract ONXToken is ERC20('OnX.finance', 'ONX') {
881 
882     address public exchangeAirdropCampaign;
883     address public treasuryAddress;
884 
885     // mints 400,000 OnX for Exchange airdrop & 275,685 for Development Fund >
886     constructor (address _exchange, address _treasury) public {
887 
888         exchangeAirdropCampaign = _exchange;
889         treasuryAddress = _treasury;
890 
891         mintTo(exchangeAirdropCampaign, 400000000000000000000000);
892         mintTo(treasuryAddress, 275685000000000000000000);
893     }
894 
895     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner.
896     function mintTo(address _to, uint256 _amount) public onlyOwner {
897         _mint(_to, _amount);
898     }
899 
900 }
901 contract ONXFarm is Ownable {
902 
903     using SafeMath for uint256;
904     using SafeERC20 for IERC20;
905 
906     // Info of each user.
907     struct UserInfo {
908         uint256 amount; // How many LP tokens the user has provided.
909         uint256 rewardDebt; // Reward debt. See explanation below.
910         //
911         // We do some fancy math here. Basically, any point in time, the amount of OnX
912         // entitled to a user but is pending to be distributed is:
913         //
914         //   pending reward = (userInfo.amount * pool.accOnXPerShare) - userInfo.rewardDebt
915         //
916         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
917         //   1. The pool's `accOnXPerShare` (and `lastRewardBlock`) gets updated.
918         //   2. User receives the pending reward sent to his/her address.
919         //   3. User's `amount` gets updated.
920         //   4. User's `rewardDebt` gets updated.
921     }
922 
923     // Info of each pool.
924     struct PoolInfo {
925         IERC20 token; // Address of token or LP contract
926         uint256 allocPoint; // How many allocation points assigned to this pool. OnX to distribute per block.
927         uint256 lastRewardBlock; // Last block number that OnX distribution occurs.
928         uint256 accOnXPerShare; // Accumulated OnX per share, times 1e12. See below.
929     }
930 
931     // OnX tokens created first block. -> x OnX per block to start
932     uint256 public onxStartBlock;
933     // Total allocation points. Must be the sum of all allocation points in all pools.
934     uint256 public totalAllocPoint = 0;
935     // The block number when OnX mining starts ->
936     uint256 public startBlock;
937     // Block number when bonus OnX period ends.
938     uint256 public bonusEndBlock;
939     // how many block size will change the common difference before bonus end.
940     uint256 public bonusBeforeBulkBlockSize;
941     // how many block size will change the common difference after bonus end.
942     uint256 public bonusEndBulkBlockSize;
943     // OnX tokens created at bonus end block. ->
944     uint256 public onxBonusEndBlock;
945     // max reward block
946     uint256 public maxRewardBlockNumber;
947     // bonus before the common difference
948     uint256 public bonusBeforeCommonDifference;
949     // bonus after the common difference
950     uint256 public bonusEndCommonDifference;
951     // Accumulated OnX per share, times 1e12.
952     uint256 public accOnXPerShareMultiple = 1E12;
953     // The OnX.finance token!
954     ONXToken public onx;
955     // Dev address.
956     address public devAddr;
957     // Insurance fund address.
958     address public insAddr;
959     // Info on each pool added
960     PoolInfo[] public poolInfo;
961     // Info of each user that stakes tokens.
962     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
963 
964     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
965     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
966     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
967 
968     constructor(
969         ONXToken _onx,
970         address _devAddr,
971         address _insAddr,
972         uint256 _onxStartBlock,
973         uint256 _startBlock,
974         uint256 _bonusEndBlock,
975         uint256 _bonusBeforeBulkBlockSize,
976         uint256 _bonusBeforeCommonDifference,
977         uint256 _bonusEndCommonDifference
978     ) public {
979         onx = _onx;
980         devAddr = _devAddr;
981         insAddr = _insAddr;
982         onxStartBlock = _onxStartBlock;
983         startBlock = _startBlock;
984         bonusEndBlock = _bonusEndBlock;
985         bonusBeforeBulkBlockSize = _bonusBeforeBulkBlockSize;
986         bonusBeforeCommonDifference = _bonusBeforeCommonDifference;
987         bonusEndCommonDifference = _bonusEndCommonDifference;
988         bonusEndBulkBlockSize = bonusEndBlock.sub(startBlock);
989         // onx created when bonus end first block
990         // (onxStartBlock - bonusBeforeCommonDifference * ((bonusEndBlock-startBlock)/bonusBeforeBulkBlockSize - 1)) * bonusBeforeBulkBlockSize*(bonusEndBulkBlockSize/bonusBeforeBulkBlockSize) * bonusEndBulkBlockSize
991         onxBonusEndBlock = onxStartBlock
992         .sub(bonusEndBlock.sub(startBlock).div(bonusBeforeBulkBlockSize).sub(1).mul(bonusBeforeCommonDifference))
993         .mul(bonusBeforeBulkBlockSize)
994         .mul(bonusEndBulkBlockSize.div(bonusBeforeBulkBlockSize))
995         .div(bonusEndBulkBlockSize);
996         // max mint block number, _onxInitBlock - (MAX-1)*_commonDifference = 0
997         // MAX = startBlock + bonusEndBulkBlockSize * (_onxInitBlock/_commonDifference + 1)
998         maxRewardBlockNumber = startBlock.add(
999             bonusEndBulkBlockSize.mul(onxBonusEndBlock.div(bonusEndCommonDifference).add(1))
1000         );
1001     }
1002 
1003     // Pool Length
1004     function poolLength() external view returns (uint256) {
1005         return poolInfo.length;
1006     }
1007 
1008     // Add a new token or LP to the pool. Can only be called by the owner.
1009     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do!
1010     function add(
1011         uint256 _allocPoint,
1012         IERC20 _token,
1013         bool _withUpdate
1014     ) public onlyOwner {
1015         if (_withUpdate) {
1016             massUpdatePools();
1017         }
1018         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1019         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1020         poolInfo.push(PoolInfo({
1021           token: _token,
1022           allocPoint: _allocPoint,
1023           lastRewardBlock: lastRewardBlock,
1024           accOnXPerShare: 0
1025         }));
1026     }
1027 
1028     // Update the given pool's OnX allocation point. Can only be called by the owner.
1029     function set(
1030         uint256 _pid,
1031         uint256 _allocPoint,
1032         bool _withUpdate
1033     ) public onlyOwner {
1034         if (_withUpdate) {
1035             massUpdatePools();
1036         }
1037         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1038         poolInfo[_pid].allocPoint = _allocPoint;
1039     }
1040 
1041     // (_from,_to]
1042     function getTotalRewardInfoInSameCommonDifference(
1043         uint256 _from,
1044         uint256 _to,
1045         uint256 _onxInitBlock,
1046         uint256 _bulkBlockSize,
1047         uint256 _commonDifference
1048     ) public view returns (uint256 totalReward) {
1049         if (_to <= startBlock || maxRewardBlockNumber <= _from) {
1050             return 0;
1051         }
1052         if (_from < startBlock) {
1053             _from = startBlock;
1054         }
1055         if (maxRewardBlockNumber < _to) {
1056             _to = maxRewardBlockNumber;
1057         }
1058         uint256 currentBulkNumber = _to.sub(startBlock).div(_bulkBlockSize).add(
1059             _to.sub(startBlock).mod(_bulkBlockSize) > 0 ? 1 : 0
1060         );
1061         if (currentBulkNumber < 1) {
1062             currentBulkNumber = 1;
1063         }
1064         uint256 fromBulkNumber = _from.sub(startBlock).div(_bulkBlockSize).add(
1065             _from.sub(startBlock).mod(_bulkBlockSize) > 0 ? 1 : 0
1066         );
1067         if (fromBulkNumber < 1) {
1068             fromBulkNumber = 1;
1069         }
1070         if (fromBulkNumber == currentBulkNumber) {
1071             return _to.sub(_from).mul(_onxInitBlock.sub(currentBulkNumber.sub(1).mul(_commonDifference)));
1072         }
1073         uint256 lastRewardBulkLastBlock = startBlock.add(_bulkBlockSize.mul(fromBulkNumber));
1074         uint256 currentPreviousBulkLastBlock = startBlock.add(_bulkBlockSize.mul(currentBulkNumber.sub(1)));
1075         {
1076             uint256 tempFrom = _from;
1077             uint256 tempTo = _to;
1078             totalReward = tempTo
1079             .sub(tempFrom > currentPreviousBulkLastBlock ? tempFrom : currentPreviousBulkLastBlock)
1080             .mul(_onxInitBlock.sub(currentBulkNumber.sub(1).mul(_commonDifference)));
1081             if (lastRewardBulkLastBlock > tempFrom && lastRewardBulkLastBlock <= tempTo) {
1082                 totalReward = totalReward.add(
1083                     lastRewardBulkLastBlock.sub(tempFrom).mul(
1084                         _onxInitBlock.sub(fromBulkNumber > 0 ? fromBulkNumber.sub(1).mul(_commonDifference) : 0)
1085                     )
1086                 );
1087             }
1088         }
1089         {
1090             // avoids stack too deep errors
1091             uint256 tempOnXInitBlock = _onxInitBlock;
1092             uint256 tempBulkBlockSize = _bulkBlockSize;
1093             uint256 tempCommonDifference = _commonDifference;
1094             if (currentPreviousBulkLastBlock > lastRewardBulkLastBlock) {
1095                 uint256 tempCurrentPreviousBulkLastBlock = currentPreviousBulkLastBlock;
1096                 // sum( [fromBulkNumber+1, currentBulkNumber] )
1097                 // 1/2 * N *( a1 + aN)
1098                 uint256 N = tempCurrentPreviousBulkLastBlock.sub(lastRewardBulkLastBlock).div(tempBulkBlockSize);
1099                 if (N > 1) {
1100                     uint256 a1 = tempBulkBlockSize.mul(
1101                         tempOnXInitBlock.sub(
1102                             lastRewardBulkLastBlock.sub(startBlock).mul(tempCommonDifference).div(tempBulkBlockSize)
1103                         )
1104                     );
1105                     uint256 aN = tempBulkBlockSize.mul(
1106                         tempOnXInitBlock.sub(
1107                             tempCurrentPreviousBulkLastBlock.sub(startBlock).div(tempBulkBlockSize).sub(1).mul(
1108                                 tempCommonDifference
1109                             )
1110                         )
1111                     );
1112                     totalReward = totalReward.add(N.mul(a1.add(aN)).div(2));
1113                 } else {
1114                     totalReward = totalReward.add(
1115                         tempBulkBlockSize.mul(tempOnXInitBlock.sub(currentBulkNumber.sub(2).mul(tempCommonDifference)))
1116                     );
1117                 }
1118             }
1119         }
1120     }
1121 
1122     // Return total reward over the given _from to _to block.
1123     function getTotalRewardInfo(uint256 _from, uint256 _to) public view returns (uint256 totalReward) {
1124         if (_to <= bonusEndBlock) {
1125             totalReward = getTotalRewardInfoInSameCommonDifference(
1126                 _from,
1127                 _to,
1128                 onxStartBlock,
1129                 bonusBeforeBulkBlockSize,
1130                 bonusBeforeCommonDifference
1131             );
1132         } else if (_from >= bonusEndBlock) {
1133             totalReward = getTotalRewardInfoInSameCommonDifference(
1134                 _from,
1135                 _to,
1136                 onxBonusEndBlock,
1137                 bonusEndBulkBlockSize,
1138                 bonusEndCommonDifference
1139             );
1140         } else {
1141             totalReward = getTotalRewardInfoInSameCommonDifference(
1142                 _from,
1143                 bonusEndBlock,
1144                 onxStartBlock,
1145                 bonusBeforeBulkBlockSize,
1146                 bonusBeforeCommonDifference
1147             )
1148             .add(
1149                 getTotalRewardInfoInSameCommonDifference(
1150                     bonusEndBlock,
1151                     _to,
1152                     onxBonusEndBlock,
1153                     bonusEndBulkBlockSize,
1154                     bonusEndCommonDifference
1155                 )
1156             );
1157         }
1158     }
1159 
1160     // View function to see pending OnX on frontend.
1161     function pendingOnX(uint256 _pid, address _user) external view returns (uint256) {
1162         PoolInfo storage pool = poolInfo[_pid];
1163         UserInfo storage user = userInfo[_pid][_user];
1164         uint256 accOnXPerShare = pool.accOnXPerShare;
1165         uint256 lpSupply = pool.token.balanceOf(address(this));
1166         if (block.number > pool.lastRewardBlock && lpSupply != 0 && pool.lastRewardBlock < maxRewardBlockNumber) {
1167             uint256 totalReward = getTotalRewardInfo(pool.lastRewardBlock, block.number);
1168             uint256 onxReward = totalReward.mul(pool.allocPoint).div(totalAllocPoint);
1169             accOnXPerShare = accOnXPerShare.add(onxReward.mul(accOnXPerShareMultiple).div(lpSupply));
1170         }
1171         return user.amount.mul(accOnXPerShare).div(accOnXPerShareMultiple).sub(user.rewardDebt);
1172     }
1173 
1174     // Update reward vairables for all pools. Be careful of gas spending!
1175     function massUpdatePools() public {
1176         uint256 length = poolInfo.length;
1177         for (uint256 pid = 0; pid < length; ++pid) {
1178             updatePool(pid);
1179         }
1180     }
1181 
1182     // Update reward variables of the given pool to be up-to-date.
1183     function updatePool(uint256 _pid) public {
1184         PoolInfo storage pool = poolInfo[_pid];
1185         if (block.number <= pool.lastRewardBlock) {
1186             return;
1187         }
1188         uint256 lpSupply = pool.token.balanceOf(address(this));
1189         if (lpSupply == 0) {
1190             pool.lastRewardBlock = block.number;
1191             return;
1192         }
1193         if (pool.lastRewardBlock >= maxRewardBlockNumber) {
1194             return;
1195         }
1196         uint256 totalReward = getTotalRewardInfo(pool.lastRewardBlock, block.number);
1197         uint256 onxReward = totalReward.mul(pool.allocPoint).div(totalAllocPoint);
1198         onx.mintTo(devAddr, onxReward.div(20)); // 5% OnX sent to dev addr every harvest
1199         onx.mintTo(insAddr, onxReward.div(50)); // 2% OnX sent to insurance fund addr every harvest
1200         onx.mintTo(address(this), onxReward);
1201         pool.accOnXPerShare = pool.accOnXPerShare.add(onxReward.mul(accOnXPerShareMultiple).div(lpSupply));
1202         pool.lastRewardBlock = block.number;
1203     }
1204 
1205     // Deposit tokens to OnXFarmTest for OnX allocation.
1206     function deposit(uint256 _pid, uint256 _amount) public {
1207         PoolInfo storage pool = poolInfo[_pid];
1208         UserInfo storage user = userInfo[_pid][msg.sender];
1209         updatePool(_pid);
1210         if (user.amount > 0) {
1211             uint256 pending = user.amount.mul(pool.accOnXPerShare).div(accOnXPerShareMultiple).sub(
1212                 user.rewardDebt
1213             );
1214             if (pending > 0) {
1215                 safeOnXTransfer(msg.sender, pending);
1216             }
1217         }
1218         pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
1219         user.amount = user.amount.add(_amount);
1220         user.rewardDebt = user.amount.mul(pool.accOnXPerShare).div(accOnXPerShareMultiple);
1221         emit Deposit(msg.sender, _pid, _amount);
1222     }
1223 
1224     // Withdraw tokens from OnXFarmTest
1225     function withdraw(uint256 _pid, uint256 _amount) public {
1226         PoolInfo storage pool = poolInfo[_pid];
1227         UserInfo storage user = userInfo[_pid][msg.sender];
1228         require(user.amount >= _amount, 'withdraw: not good');
1229         updatePool(_pid);
1230         uint256 pending = user.amount.mul(pool.accOnXPerShare).div(accOnXPerShareMultiple).sub(
1231             user.rewardDebt
1232         );
1233         if (pending > 0) {
1234             safeOnXTransfer(msg.sender, pending);
1235         }
1236         if (_amount > 0) {
1237             user.amount = user.amount.sub(_amount);
1238             pool.token.safeTransfer(address(msg.sender), _amount);
1239         }
1240         user.rewardDebt = user.amount.mul(pool.accOnXPerShare).div(accOnXPerShareMultiple);
1241         emit Withdraw(msg.sender, _pid, _amount);
1242     }
1243 
1244     // Withdraw without caring about rewards. EMERGENCY ONLY.
1245     function emergencyWithdraw(uint256 _pid) public {
1246         PoolInfo storage pool = poolInfo[_pid];
1247         UserInfo storage user = userInfo[_pid][msg.sender];
1248         pool.token.safeTransfer(address(msg.sender), user.amount);
1249         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1250         user.amount = 0;
1251         user.rewardDebt = 0;
1252     }
1253 
1254     // Safe onx transfer function, just in case if rounding error causes pool to not have enough $OnX
1255     function safeOnXTransfer(address _to, uint256 _amount) internal {
1256         uint256 onxBal = onx.balanceOf(address(this));
1257         if (_amount > onxBal) {
1258             onx.transfer(_to, onxBal);
1259         } else {
1260             onx.transfer(_to, _amount);
1261         }
1262     }
1263 
1264     // Update dev address by the previous dev or governance
1265     function changeDevAddr(address _devAddr) public {
1266         require(msg.sender == devAddr, 'bruh');
1267         devAddr = _devAddr;
1268     }
1269 
1270     // Update insurance address by previous dev or governance
1271     function changeInsuranceAddr(address _insAddr) public {
1272         require(msg.sender == insAddr, 'nah');
1273         insAddr = _insAddr;
1274     }
1275 }