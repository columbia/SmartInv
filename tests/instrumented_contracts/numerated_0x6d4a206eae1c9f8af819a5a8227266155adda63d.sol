1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 pragma solidity ^0.6.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
98 
99 
100 pragma solidity ^0.6.0;
101 
102 /**
103  * @dev Interface of the ERC20 standard as defined in the EIP.
104  */
105 interface IERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `recipient`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address recipient, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 // File: @openzeppelin/contracts/math/SafeMath.sol
177 
178 
179 pragma solidity ^0.6.0;
180 
181 /**
182  * @dev Wrappers over Solidity's arithmetic operations with added overflow
183  * checks.
184  *
185  * Arithmetic operations in Solidity wrap on overflow. This can easily result
186  * in bugs, because programmers usually assume that an overflow raises an
187  * error, which is the standard behavior in high level programming languages.
188  * `SafeMath` restores this intuition by reverting the transaction when an
189  * operation overflows.
190  *
191  * Using this library instead of the unchecked operations eliminates an entire
192  * class of bugs, so it's recommended to use it always.
193  */
194 library SafeMath {
195     /**
196      * @dev Returns the addition of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `+` operator.
200      *
201      * Requirements:
202      *
203      * - Addition cannot overflow.
204      */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         uint256 c = a + b;
207         require(c >= a, "SafeMath: addition overflow");
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting on
214      * overflow (when the result is negative).
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      *
220      * - Subtraction cannot overflow.
221      */
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         return sub(a, b, "SafeMath: subtraction overflow");
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
228      * overflow (when the result is negative).
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      *
234      * - Subtraction cannot overflow.
235      */
236     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b <= a, errorMessage);
238         uint256 c = a - b;
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the multiplication of two unsigned integers, reverting on
245      * overflow.
246      *
247      * Counterpart to Solidity's `*` operator.
248      *
249      * Requirements:
250      *
251      * - Multiplication cannot overflow.
252      */
253     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
254         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
255         // benefit is lost if 'b' is also tested.
256         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
257         if (a == 0) {
258             return 0;
259         }
260 
261         uint256 c = a * b;
262         require(c / a == b, "SafeMath: multiplication overflow");
263 
264         return c;
265     }
266 
267     /**
268      * @dev Returns the integer division of two unsigned integers. Reverts on
269      * division by zero. The result is rounded towards zero.
270      *
271      * Counterpart to Solidity's `/` operator. Note: this function uses a
272      * `revert` opcode (which leaves remaining gas untouched) while Solidity
273      * uses an invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function div(uint256 a, uint256 b) internal pure returns (uint256) {
280         return div(a, b, "SafeMath: division by zero");
281     }
282 
283     /**
284      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
285      * division by zero. The result is rounded towards zero.
286      *
287      * Counterpart to Solidity's `/` operator. Note: this function uses a
288      * `revert` opcode (which leaves remaining gas untouched) while Solidity
289      * uses an invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b > 0, errorMessage);
297         uint256 c = a / b;
298         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * Reverts when dividing by zero.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
316         return mod(a, b, "SafeMath: modulo by zero");
317     }
318 
319     /**
320      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
321      * Reverts with custom message when dividing by zero.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         require(b != 0, errorMessage);
333         return a % b;
334     }
335 }
336 
337 // File: @openzeppelin/contracts/utils/Address.sol
338 
339 
340 pragma solidity ^0.6.2;
341 
342 /**
343  * @dev Collection of functions related to the address type
344  */
345 library Address {
346     /**
347      * @dev Returns true if `account` is a contract.
348      *
349      * [IMPORTANT]
350      * ====
351      * It is unsafe to assume that an address for which this function returns
352      * false is an externally-owned account (EOA) and not a contract.
353      *
354      * Among others, `isContract` will return false for the following
355      * types of addresses:
356      *
357      *  - an externally-owned account
358      *  - a contract in construction
359      *  - an address where a contract will be created
360      *  - an address where a contract lived, but was destroyed
361      * ====
362      */
363     function isContract(address account) internal view returns (bool) {
364         // This method relies in extcodesize, which returns 0 for contracts in
365         // construction, since the code is only stored at the end of the
366         // constructor execution.
367 
368         uint256 size;
369         // solhint-disable-next-line no-inline-assembly
370         assembly { size := extcodesize(account) }
371         return size > 0;
372     }
373 
374     /**
375      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
376      * `recipient`, forwarding all available gas and reverting on errors.
377      *
378      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
379      * of certain opcodes, possibly making contracts go over the 2300 gas limit
380      * imposed by `transfer`, making them unable to receive funds via
381      * `transfer`. {sendValue} removes this limitation.
382      *
383      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
384      *
385      * IMPORTANT: because control is transferred to `recipient`, care must be
386      * taken to not create reentrancy vulnerabilities. Consider using
387      * {ReentrancyGuard} or the
388      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
389      */
390     function sendValue(address payable recipient, uint256 amount) internal {
391         require(address(this).balance >= amount, "Address: insufficient balance");
392 
393         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
394         (bool success, ) = recipient.call{ value: amount }("");
395         require(success, "Address: unable to send value, recipient may have reverted");
396     }
397 
398     /**
399      * @dev Performs a Solidity function call using a low level `call`. A
400      * plain`call` is an unsafe replacement for a function call: use this
401      * function instead.
402      *
403      * If `target` reverts with a revert reason, it is bubbled up by this
404      * function (like regular Solidity function calls).
405      *
406      * Returns the raw returned data. To convert to the expected return value,
407      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
408      *
409      * Requirements:
410      *
411      * - `target` must be a contract.
412      * - calling `target` with `data` must not revert.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
417       return functionCall(target, data, "Address: low-level call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
422      * `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
427         return _functionCallWithValue(target, data, 0, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but also transferring `value` wei to `target`.
433      *
434      * Requirements:
435      *
436      * - the calling contract must have an ETH balance of at least `value`.
437      * - the called Solidity function must be `payable`.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
447      * with `errorMessage` as a fallback revert reason when `target` reverts.
448      *
449      * _Available since v3.1._
450      */
451     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
452         require(address(this).balance >= value, "Address: insufficient balance for call");
453         return _functionCallWithValue(target, data, value, errorMessage);
454     }
455 
456     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
457         require(isContract(target), "Address: call to non-contract");
458 
459         // solhint-disable-next-line avoid-low-level-calls
460         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 // solhint-disable-next-line no-inline-assembly
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
481 
482 
483 pragma solidity ^0.6.0;
484 
485 
486 
487 
488 /**
489  * @title SafeERC20
490  * @dev Wrappers around ERC20 operations that throw on failure (when the token
491  * contract returns false). Tokens that return no value (and instead revert or
492  * throw on failure) are also supported, non-reverting calls are assumed to be
493  * successful.
494  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
495  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
496  */
497 library SafeERC20 {
498     using SafeMath for uint256;
499     using Address for address;
500 
501     function safeTransfer(IERC20 token, address to, uint256 value) internal {
502         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
503     }
504 
505     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
506         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
507     }
508 
509     /**
510      * @dev Deprecated. This function has issues similar to the ones found in
511      * {IERC20-approve}, and its usage is discouraged.
512      *
513      * Whenever possible, use {safeIncreaseAllowance} and
514      * {safeDecreaseAllowance} instead.
515      */
516     function safeApprove(IERC20 token, address spender, uint256 value) internal {
517         // safeApprove should only be called when setting an initial allowance,
518         // or when resetting it to zero. To increase and decrease it, use
519         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
520         // solhint-disable-next-line max-line-length
521         require((value == 0) || (token.allowance(address(this), spender) == 0),
522             "SafeERC20: approve from non-zero to non-zero allowance"
523         );
524         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
525     }
526 
527     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
528         uint256 newAllowance = token.allowance(address(this), spender).add(value);
529         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
530     }
531 
532     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
533         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
534         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
535     }
536 
537     /**
538      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
539      * on the return value: the return value is optional (but if data is returned, it must not be false).
540      * @param token The token targeted by the call.
541      * @param data The call data (encoded using abi.encode or one of its variants).
542      */
543     function _callOptionalReturn(IERC20 token, bytes memory data) private {
544         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
545         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
546         // the target address contains contract code and also asserts for success in the low-level call.
547 
548         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
549         if (returndata.length > 0) { // Return data is optional
550             // solhint-disable-next-line max-line-length
551             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
552         }
553     }
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
557 
558 
559 pragma solidity ^0.6.0;
560 
561 
562 
563 
564 
565 /**
566  * @dev Implementation of the {IERC20} interface.
567  *
568  * This implementation is agnostic to the way tokens are created. This means
569  * that a supply mechanism has to be added in a derived contract using {_mint}.
570  * For a generic mechanism see {ERC20PresetMinterPauser}.
571  *
572  * TIP: For a detailed writeup see our guide
573  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
574  * to implement supply mechanisms].
575  *
576  * We have followed general OpenZeppelin guidelines: functions revert instead
577  * of returning `false` on failure. This behavior is nonetheless conventional
578  * and does not conflict with the expectations of ERC20 applications.
579  *
580  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
581  * This allows applications to reconstruct the allowance for all accounts just
582  * by listening to said events. Other implementations of the EIP may not emit
583  * these events, as it isn't required by the specification.
584  *
585  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
586  * functions have been added to mitigate the well-known issues around setting
587  * allowances. See {IERC20-approve}.
588  */
589 contract ERC20 is Context, IERC20 {
590     using SafeMath for uint256;
591     using Address for address;
592 
593     mapping (address => uint256) private _balances;
594 
595     mapping (address => mapping (address => uint256)) private _allowances;
596 
597     uint256 private _totalSupply;
598 
599     string private _name;
600     string private _symbol;
601     uint8 private _decimals;
602 
603     /**
604      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
605      * a default value of 18.
606      *
607      * To select a different value for {decimals}, use {_setupDecimals}.
608      *
609      * All three of these values are immutable: they can only be set once during
610      * construction.
611      */
612     constructor (string memory name, string memory symbol) public {
613         _name = name;
614         _symbol = symbol;
615         _decimals = 18;
616     }
617 
618     /**
619      * @dev Returns the name of the token.
620      */
621     function name() public view returns (string memory) {
622         return _name;
623     }
624 
625     /**
626      * @dev Returns the symbol of the token, usually a shorter version of the
627      * name.
628      */
629     function symbol() public view returns (string memory) {
630         return _symbol;
631     }
632 
633     /**
634      * @dev Returns the number of decimals used to get its user representation.
635      * For example, if `decimals` equals `2`, a balance of `505` tokens should
636      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
637      *
638      * Tokens usually opt for a value of 18, imitating the relationship between
639      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
640      * called.
641      *
642      * NOTE: This information is only used for _display_ purposes: it in
643      * no way affects any of the arithmetic of the contract, including
644      * {IERC20-balanceOf} and {IERC20-transfer}.
645      */
646     function decimals() public view returns (uint8) {
647         return _decimals;
648     }
649 
650     /**
651      * @dev See {IERC20-totalSupply}.
652      */
653     function totalSupply() public view override returns (uint256) {
654         return _totalSupply;
655     }
656 
657     /**
658      * @dev See {IERC20-balanceOf}.
659      */
660     function balanceOf(address account) public view override returns (uint256) {
661         return _balances[account];
662     }
663 
664     /**
665      * @dev See {IERC20-transfer}.
666      *
667      * Requirements:
668      *
669      * - `recipient` cannot be the zero address.
670      * - the caller must have a balance of at least `amount`.
671      */
672     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
673         _transfer(_msgSender(), recipient, amount);
674         return true;
675     }
676 
677     /**
678      * @dev See {IERC20-allowance}.
679      */
680     function allowance(address owner, address spender) public view virtual override returns (uint256) {
681         return _allowances[owner][spender];
682     }
683 
684     /**
685      * @dev See {IERC20-approve}.
686      *
687      * Requirements:
688      *
689      * - `spender` cannot be the zero address.
690      */
691     function approve(address spender, uint256 amount) public virtual override returns (bool) {
692         _approve(_msgSender(), spender, amount);
693         return true;
694     }
695 
696     /**
697      * @dev See {IERC20-transferFrom}.
698      *
699      * Emits an {Approval} event indicating the updated allowance. This is not
700      * required by the EIP. See the note at the beginning of {ERC20};
701      *
702      * Requirements:
703      * - `sender` and `recipient` cannot be the zero address.
704      * - `sender` must have a balance of at least `amount`.
705      * - the caller must have allowance for ``sender``'s tokens of at least
706      * `amount`.
707      */
708     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
709         _transfer(sender, recipient, amount);
710         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
711         return true;
712     }
713 
714     /**
715      * @dev Atomically increases the allowance granted to `spender` by the caller.
716      *
717      * This is an alternative to {approve} that can be used as a mitigation for
718      * problems described in {IERC20-approve}.
719      *
720      * Emits an {Approval} event indicating the updated allowance.
721      *
722      * Requirements:
723      *
724      * - `spender` cannot be the zero address.
725      */
726     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
727         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
728         return true;
729     }
730 
731     /**
732      * @dev Atomically decreases the allowance granted to `spender` by the caller.
733      *
734      * This is an alternative to {approve} that can be used as a mitigation for
735      * problems described in {IERC20-approve}.
736      *
737      * Emits an {Approval} event indicating the updated allowance.
738      *
739      * Requirements:
740      *
741      * - `spender` cannot be the zero address.
742      * - `spender` must have allowance for the caller of at least
743      * `subtractedValue`.
744      */
745     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
746         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
747         return true;
748     }
749 
750     /**
751      * @dev Moves tokens `amount` from `sender` to `recipient`.
752      *
753      * This is internal function is equivalent to {transfer}, and can be used to
754      * e.g. implement automatic token fees, slashing mechanisms, etc.
755      *
756      * Emits a {Transfer} event.
757      *
758      * Requirements:
759      *
760      * - `sender` cannot be the zero address.
761      * - `recipient` cannot be the zero address.
762      * - `sender` must have a balance of at least `amount`.
763      */
764     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
765         require(sender != address(0), "ERC20: transfer from the zero address");
766         require(recipient != address(0), "ERC20: transfer to the zero address");
767 
768         _beforeTokenTransfer(sender, recipient, amount);
769 
770         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
771         _balances[recipient] = _balances[recipient].add(amount);
772         emit Transfer(sender, recipient, amount);
773     }
774 
775     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
776      * the total supply.
777      *
778      * Emits a {Transfer} event with `from` set to the zero address.
779      *
780      * Requirements
781      *
782      * - `to` cannot be the zero address.
783      */
784     function _mint(address account, uint256 amount) internal virtual {
785         require(account != address(0), "ERC20: mint to the zero address");
786 
787         _beforeTokenTransfer(address(0), account, amount);
788 
789         _totalSupply = _totalSupply.add(amount);
790         _balances[account] = _balances[account].add(amount);
791         emit Transfer(address(0), account, amount);
792     }
793 
794     /**
795      * @dev Destroys `amount` tokens from `account`, reducing the
796      * total supply.
797      *
798      * Emits a {Transfer} event with `to` set to the zero address.
799      *
800      * Requirements
801      *
802      * - `account` cannot be the zero address.
803      * - `account` must have at least `amount` tokens.
804      */
805     function _burn(address account, uint256 amount) internal virtual {
806         require(account != address(0), "ERC20: burn from the zero address");
807 
808         _beforeTokenTransfer(account, address(0), amount);
809 
810         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
811         _totalSupply = _totalSupply.sub(amount);
812         emit Transfer(account, address(0), amount);
813     }
814 
815     /**
816      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
817      *
818      * This internal function is equivalent to `approve`, and can be used to
819      * e.g. set automatic allowances for certain subsystems, etc.
820      *
821      * Emits an {Approval} event.
822      *
823      * Requirements:
824      *
825      * - `owner` cannot be the zero address.
826      * - `spender` cannot be the zero address.
827      */
828     function _approve(address owner, address spender, uint256 amount) internal virtual {
829         require(owner != address(0), "ERC20: approve from the zero address");
830         require(spender != address(0), "ERC20: approve to the zero address");
831 
832         _allowances[owner][spender] = amount;
833         emit Approval(owner, spender, amount);
834     }
835 
836     /**
837      * @dev Sets {decimals} to a value other than the default one of 18.
838      *
839      * WARNING: This function should only be called from the constructor. Most
840      * applications that interact with token contracts will not expect
841      * {decimals} to ever change, and may work incorrectly if it does.
842      */
843     function _setupDecimals(uint8 decimals_) internal {
844         _decimals = decimals_;
845     }
846 
847     /**
848      * @dev Hook that is called before any transfer of tokens. This includes
849      * minting and burning.
850      *
851      * Calling conditions:
852      *
853      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
854      * will be to transferred to `to`.
855      * - when `from` is zero, `amount` tokens will be minted for `to`.
856      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
857      * - `from` and `to` are never both zero.
858      *
859      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
860      */
861     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
862 }
863 
864 // File: contracts/token/STSToken.sol
865 
866 pragma solidity ^0.6.0;
867 
868 
869 // sts 代币合约
870 contract STSToken is ERC20("StarSwap", "STS") {
871     constructor() public {
872         _mint(msg.sender, 21000000 * 10 ** 18);
873     }
874 }
875 
876 // File: contracts/mining/LPMining.sol
877 
878 pragma solidity ^0.6.12;
879 
880 
881 
882 
883 contract LPMining is Ownable {
884     using SafeMath for uint256;
885     using SafeERC20 for IERC20;
886 
887     struct UserInfo {
888         uint256 amount;     // 用户抵押的 LP 数量
889         uint256 rewardDebt; // 用户奖励的债务
890         uint256 lastBlock; // 用户抵押 提现 领取后更新的操作
891 
892         // 用户应得挖矿奖励计算:
893         //
894         //   pending reward = (user.amount * pool.accTokenPerShare) - user.rewardDebt
895         //
896         // 用户抵押，提现时进行的操作:
897         //   1. The pool's `accTokenPerShare` (and `lastRewardBlock`) gets updated.
898         //   2. User receives the pending reward sent to his/her address.
899         //   3. User's `amount` gets updated.
900         //   4. User's `rewardDebt` gets updated.
901     }
902 
903     // 池子的信息
904     struct PoolInfo {
905         IERC20 lpToken;           // LP 地址
906         uint256 allocPoint;       // 池子的权重
907         uint256 lastRewardBlock;  // 最新的奖励区块
908         uint256 accTokenPerShare; // 根据区块计算平均每个块挖到的 token
909         uint256 totalDeposit;     // 有效抵押数
910     }
911 
912     // 奖励代币
913     STSToken public stsToken;
914     // 分红截止区块
915     uint256 public bonusEndBlock;
916     // 每个块产的奖励代币
917     uint256 public stsTokenPerBlock;
918     // 每个周期多少个块
919     uint256 public blockPerPeriod;
920     // 分红奖励倍数 1 是 1倍 即不奖励 2 是奖励2倍 以此类推
921     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
922 
923     // 池子数组信息
924     PoolInfo[] public poolInfo;
925     // 用户信息映射
926     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
927     // 所有池子的总权重
928     uint256 public totalAllocPoint = 0;
929     // 挖矿开始区块
930     uint256 public startBlock;
931 
932     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
933     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
934     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
935 
936     // 构造函数
937     // stsToken: 奖励代币
938     // startBlock: 挖矿起始区块
939     // stsTokenPerBlock: 每个区块产矿数
940     // blockPerPeriod: 每个周期多少个区块
941     constructor(
942         STSToken _stsToken,
943         uint256 _startBlock,
944         uint256 _initSTSTokenBase,
945         uint256 _blockPerPeriod
946     ) public {
947         stsToken = _stsToken;
948         stsTokenPerBlock = _initSTSTokenBase;
949         blockPerPeriod = _blockPerPeriod;
950         bonusEndBlock = _startBlock.add(_blockPerPeriod);
951         startBlock = _startBlock;
952     }
953 
954     function setBonusEndBlock(uint256 _startBlock) public onlyOwner {
955         bonusEndBlock = _startBlock.add(blockPerPeriod);
956     }
957 
958     function setStartBlock(uint256 _startBlock) public onlyOwner {
959         startBlock = _startBlock;
960     }
961 
962     function poolLength() external view returns (uint256) {
963         return poolInfo.length;
964     }
965 
966     // 新增 LP 池子
967     // 不要添加相同 LP token 的池子，会引起计算混乱
968     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
969         if (_withUpdate) {
970             massUpdatePools();
971         }
972         checkDuplicateLp(_lpToken);
973         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
974         totalAllocPoint = totalAllocPoint.add(_allocPoint);
975         poolInfo.push(PoolInfo({
976             lpToken : _lpToken,
977             allocPoint : _allocPoint,
978             lastRewardBlock : lastRewardBlock,
979             accTokenPerShare : 0,
980             totalDeposit: 0
981             }));
982     }
983 
984     // 检查是否存在重复LP
985     function checkDuplicateLp(IERC20 _lpToken) internal view {
986         PoolInfo storage pool;
987         for(uint256 i = 0; i < poolInfo.length; i++) {
988             pool = poolInfo[i];
989             require(pool.lpToken != _lpToken, "lptoken is exist");
990         }
991     }
992 
993     // 更新池子的权重
994     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
995         if (_withUpdate) {
996             massUpdatePools();
997         }
998         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
999         poolInfo[_pid].allocPoint = _allocPoint;
1000     }
1001 
1002     // 返回区块奖励因数
1003     // 避免 衰减后 uint div 取整的问题，故传入了一个 baseRatio
1004     function getMultiplier(uint256 _from, uint256 _to, uint baseRatio) public view returns (uint256) {
1005         uint base = baseRatio;
1006         uint canAwardBlockNum;
1007         if (_to <= bonusEndBlock) {
1008             return _to.sub(_from).mul(BONUS_MULTIPLIER).mul(base);
1009         } else if (_from >= bonusEndBlock) {
1010             {
1011                 for (uint i = bonusEndBlock; i < _to; i = i + blockPerPeriod) {
1012                     // 超过12个周期不再进行挖矿奖励
1013                     if (i >= bonusEndBlock.add(blockPerPeriod.mul(11))) {
1014                         break;
1015                     }
1016                     // 12个周期内才进行奖励衰减
1017                     if (i < bonusEndBlock.add(blockPerPeriod.mul(11))) {
1018                         base = base.mul(4).div(5);
1019                     }
1020                     // 循环进行衰减计算
1021                     if (i.add(blockPerPeriod) < _from) {
1022                         continue;
1023                     }
1024 
1025                     if (i < _from && i.add(blockPerPeriod) >= _from) {
1026                         // _from _to 同周期
1027                         if (i.add(blockPerPeriod) > _to) {
1028                             canAwardBlockNum = canAwardBlockNum.add(base.mul(_to.sub(_from)));
1029                         } else {
1030                             //  _from _to 跨周期
1031                             canAwardBlockNum = canAwardBlockNum.add(base.mul(i.add(blockPerPeriod).sub(_from)));
1032                         }
1033                         continue;
1034                     }
1035                     //
1036                     if (i.add(blockPerPeriod) > _to) {
1037                         // 同周期 is (_to - i)
1038                         canAwardBlockNum = canAwardBlockNum.add(_to.sub(i).mul(base));
1039                         continue;
1040                     }
1041                     // 用户区块 逻辑可领取区块数
1042                     canAwardBlockNum = canAwardBlockNum.add(blockPerPeriod.mul(base));
1043                 }
1044             }
1045             return canAwardBlockNum;
1046 
1047         } else {
1048             uint first = bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).mul(base);
1049             {
1050                 for (uint j = bonusEndBlock; j < _to; j = j + blockPerPeriod) {
1051                     // after 24 period do not mint award
1052                     if (j >= bonusEndBlock.add(blockPerPeriod.mul(11))) {
1053                         break;
1054                     }
1055                     // after 13 period do not decay
1056                     if (j < bonusEndBlock.add(blockPerPeriod.mul(11))) {
1057                         base = base.mul(4).div(5);
1058                     }
1059                     if (j.add(blockPerPeriod) > _to) {
1060                         // cross the blocks is (_to - j)
1061                         canAwardBlockNum = canAwardBlockNum.add(_to.sub(j).mul(base));
1062                         continue;
1063                     }
1064                     // 用户区块 逻辑可领取区块数
1065                     canAwardBlockNum = canAwardBlockNum.add(blockPerPeriod.mul(base));
1066                 }
1067             }
1068             return first.add(canAwardBlockNum);
1069         }
1070     }
1071 
1072     // 前端渲染挖矿奖励数值
1073     function pendingToken(uint256 _pid, address _user) external view returns (uint256) {
1074         PoolInfo storage pool = poolInfo[_pid];
1075         UserInfo storage user = userInfo[_pid][_user];
1076         uint256 accTokenPerShare = pool.accTokenPerShare;
1077         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1078         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1079             uint baseRatio = 1e12;
1080             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number, baseRatio);
1081             uint256 stsTokenReward = multiplier.mul(stsTokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint).div(baseRatio);
1082             accTokenPerShare = accTokenPerShare.add(stsTokenReward.mul(1e12).div(lpSupply));
1083         }
1084         return user.amount.mul(accTokenPerShare).div(1e12).sub(user.rewardDebt);
1085     }
1086 
1087     // 强制更新池子信息
1088     function massUpdatePools() public {
1089         uint256 length = poolInfo.length;
1090         for (uint256 pid = 0; pid < length; ++pid) {
1091             updatePool(pid);
1092         }
1093     }
1094 
1095     // 更新池子信息
1096     function updatePool(uint256 _pid) public {
1097         PoolInfo storage pool = poolInfo[_pid];
1098         if (block.number <= pool.lastRewardBlock) {
1099             return;
1100         }
1101         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1102         if (lpSupply == 0) {
1103             pool.lastRewardBlock = block.number;
1104             return;
1105         }
1106         uint baseRatio = 1e12;
1107         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number, baseRatio);
1108         uint256 stsTokenReward = multiplier.mul(stsTokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint).div(baseRatio);
1109 
1110         pool.accTokenPerShare = pool.accTokenPerShare.add(stsTokenReward.mul(1e12).div(lpSupply));
1111         pool.lastRewardBlock = block.number;
1112     }
1113 
1114     // 抵押 LP token 当 amount 为 0 时、领取挖矿奖励
1115     function deposit(uint256 _pid, uint256 _amount) public {
1116         PoolInfo storage pool = poolInfo[_pid];
1117         UserInfo storage user = userInfo[_pid][msg.sender];
1118         // 如果是抵押令牌
1119         if (_amount > 0) {
1120             // 如果是初次新增抵押，则有效抵押数量 +1
1121             if (user.amount == 0) {
1122                 pool.totalDeposit = pool.totalDeposit.add(1);
1123             }
1124         }
1125         updatePool(_pid);
1126         if (user.amount > 0) {
1127             uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1128             safeTokenTransfer(msg.sender, pending);
1129         }
1130         if (_amount > 0) {
1131             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1132         }
1133         user.amount = user.amount.add(_amount);
1134         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1135         emit Deposit(msg.sender, _pid, _amount);
1136     }
1137 
1138     // 提取 LP token
1139     function withdraw(uint256 _pid, uint256 _amount) public {
1140         PoolInfo storage pool = poolInfo[_pid];
1141         UserInfo storage user = userInfo[_pid][msg.sender];
1142         require(user.amount >= _amount, "withdraw: not good");
1143         updatePool(_pid);
1144         uint256 pending = user.amount.mul(pool.accTokenPerShare).div(1e12).sub(user.rewardDebt);
1145         safeTokenTransfer(msg.sender, pending);
1146         user.amount = user.amount.sub(_amount);
1147         if (user.amount == 0) {
1148             pool.totalDeposit = pool.totalDeposit.sub(1);
1149         }
1150         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e12);
1151         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1152         emit Withdraw(msg.sender, _pid, _amount);
1153     }
1154 
1155     // 不要奖励，直接提取 LP token
1156     function emergencyWithdraw(uint256 _pid) public {
1157         PoolInfo storage pool = poolInfo[_pid];
1158         UserInfo storage user = userInfo[_pid][msg.sender];
1159         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1160         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1161         user.amount = 0;
1162         user.rewardDebt = 0;
1163     }
1164 
1165     // 从合约发送奖励代币 如果合约账户代币不足，则直接 return
1166     function safeTokenTransfer(address _to, uint256 _amount) internal {
1167         uint256 stsTokenBal = stsToken.balanceOf(address(this));
1168         if (_amount == 0 || stsTokenBal == 0) {
1169             return;
1170         }
1171         if (_amount > stsTokenBal) {
1172             stsToken.transfer(_to, stsTokenBal);
1173         } else {
1174             stsToken.transfer(_to, _amount);
1175         }
1176     }
1177 
1178     // 转移合约上的代币到指定地址，可由部署者操作
1179     function forceTransfer(address _addr, uint256 _amount) public onlyOwner {
1180         require(_addr != address(0), "address can not be 0");
1181         safeTokenTransfer(_addr, _amount);
1182     }
1183 
1184     function getTotalDeposit(uint256 _pid) public view returns(uint256) {
1185         PoolInfo storage pool = poolInfo[_pid];
1186         return pool.totalDeposit;
1187     }
1188 
1189 }