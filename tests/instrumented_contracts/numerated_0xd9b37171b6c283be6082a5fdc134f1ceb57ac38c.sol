1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 pragma solidity 0.8.7;
6 
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the token decimals.
15      */
16     function decimals() external view returns (uint8);
17 
18     /**
19      * @dev Returns the token symbol.
20      */
21     function symbol() external view returns (string memory);
22 
23     /**
24      * @dev Returns the token name.
25      */
26     function name() external view returns (string memory);
27 
28     /**
29      * @dev Returns the bep token owner.
30      */
31     function getOwner() external view returns (address);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address _owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 // File: @openzeppelin/contracts/math/SafeMath.sol
104 
105 pragma solidity 0.8.7;
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      *
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      *
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, "SafeMath: division by zero");
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242         return mod(a, b, "SafeMath: modulo by zero");
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts with custom message when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/Address.sol
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
288         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
289         // for accounts without code, i.e. `keccak256('')`
290         bytes32 codehash;
291         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { codehash := extcodehash(account) }
294         return (codehash != accountHash && codehash != 0x0);
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
317         (bool success, ) = recipient.call{ value: amount }("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 
321     /**
322      * @dev Performs a Solidity function call using a low level `call`. A
323      * plain`call` is an unsafe replacement for a function call: use this
324      * function instead.
325      *
326      * If `target` reverts with a revert reason, it is bubbled up by this
327      * function (like regular Solidity function calls).
328      *
329      * Returns the raw returned data. To convert to the expected return value,
330      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
331      *
332      * Requirements:
333      *
334      * - `target` must be a contract.
335      * - calling `target` with `data` must not revert.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
340       return functionCall(target, data, "Address: low-level call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
345      * `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
350         return _functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
370      * with `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         return _functionCallWithValue(target, data, value, errorMessage);
377     }
378 
379     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
380         require(isContract(target), "Address: call to non-contract");
381 
382         // solhint-disable-next-line avoid-low-level-calls
383         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391                 // solhint-disable-next-line no-inline-assembly
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
404 
405 /**
406  * @title SafeERC20
407  * @dev Wrappers around ERC20 operations that throw on failure (when the token
408  * contract returns false). Tokens that return no value (and instead revert or
409  * throw on failure) are also supported, non-reverting calls are assumed to be
410  * successful.
411  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
412  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
413  */
414 library SafeERC20 {
415     using SafeMath for uint256;
416     using Address for address;
417 
418     function safeTransfer(
419         IERC20 token,
420         address to,
421         uint256 value
422     ) internal {
423         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
424     }
425 
426     function safeTransferFrom(
427         IERC20 token,
428         address from,
429         address to,
430         uint256 value
431     ) internal {
432         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
433     }
434 
435     /**
436      * @dev Deprecated. This function has issues similar to the ones found in
437      * {IERC20-approve}, and its usage is discouraged.
438      *
439      * Whenever possible, use {safeIncreaseAllowance} and
440      * {safeDecreaseAllowance} instead.
441      */
442     function safeApprove(
443         IERC20 token,
444         address spender,
445         uint256 value
446     ) internal {
447         // safeApprove should only be called when setting an initial allowance,
448         // or when resetting it to zero. To increase and decrease it, use
449         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
450         // solhint-disable-next-line max-line-length
451         require(
452             (value == 0) || (token.allowance(address(this), spender) == 0),
453             'SafeERC20: approve from non-zero to non-zero allowance'
454         );
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
456     }
457 
458     function safeIncreaseAllowance(
459         IERC20 token,
460         address spender,
461         uint256 value
462     ) internal {
463         uint256 newAllowance = token.allowance(address(this), spender).add(value);
464         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
465     }
466 
467     function safeDecreaseAllowance(
468         IERC20 token,
469         address spender,
470         uint256 value
471     ) internal {
472         uint256 newAllowance = token.allowance(address(this), spender).sub(
473             value,
474             'SafeERC20: decreased allowance below zero'
475         );
476         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
477     }
478 
479     /**
480      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
481      * on the return value: the return value is optional (but if data is returned, it must not be false).
482      * @param token The token targeted by the call.
483      * @param data The call data (encoded using abi.encode or one of its variants).
484      */
485     function _callOptionalReturn(IERC20 token, bytes memory data) private {
486         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
487         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
488         // the target address contains contract code and also asserts for success in the low-level call.
489 
490         bytes memory returndata = address(token).functionCall(data, 'SafeERC20: low-level call failed');
491         if (returndata.length > 0) {
492             // Return data is optional
493             // solhint-disable-next-line max-line-length
494             require(abi.decode(returndata, (bool)), 'SafeERC20: ERC20 operation did not succeed');
495         }
496     }
497 }
498 
499 
500 abstract contract Context {
501     function _msgSender() internal view virtual returns (address payable) {
502         return payable(msg.sender);
503     }
504 
505     function _msgData() internal view virtual returns (bytes memory) {
506         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
507         return msg.data;
508     }
509 }
510 
511 abstract contract Ownable is Context {
512     address private _owner;
513 
514     event OwnershipTransferred(
515         address indexed previousOwner,
516         address indexed newOwner
517     );
518 
519     /**
520      * @dev Initializes the contract setting the deployer as the initial owner.
521      */
522     constructor() {
523         address msgSender = _msgSender();
524         _owner = msgSender;
525         emit OwnershipTransferred(address(0), msgSender);
526     }
527 
528     /**
529      * @dev Returns the address of the current owner.
530      */
531     function owner() public view returns (address) {
532         return _owner;
533     }
534 
535     /**
536      * @dev Throws if called by any account other than the owner.
537      */
538     modifier onlyOwner() {
539         require(_owner == _msgSender(), "Ownable: caller is not the owner");
540         _;
541     }
542 
543     /**
544      * @dev Leaves the contract without owner. It will not be possible to call
545      * `onlyOwner` functions anymore. Can only be called by the current owner.
546      *
547      * NOTE: Renouncing ownership will leave the contract without an owner,
548      * thereby removing any functionality that is only available to the owner.
549      */
550     function renounceOwnership() public virtual onlyOwner {
551         emit OwnershipTransferred(_owner, address(0));
552         _owner = address(0);
553     }
554 
555     /**
556      * @dev Transfers ownership of the contract to a new account (`newOwner`).
557      * Can only be called by the current owner.
558      */
559     function transferOwnership(address newOwner) public virtual onlyOwner {
560         require(
561             newOwner != address(0),
562             "Ownable: new owner is the zero address"
563         );
564         emit OwnershipTransferred(_owner, newOwner);
565         _owner = newOwner;
566     }
567 }
568 
569 pragma solidity >=0.4.0;
570 
571 /**
572  * @dev Implementation of the {IERC20} interface.
573  *
574  * This implementation is agnostic to the way tokens are created. This means
575  * that a supply mechanism has to be added in a derived contract using {_mint}.
576  * For a generic mechanism see {ERC20PresetMinterPauser}.
577  *
578  * TIP: For a detailed writeup see our guide
579  * https://forum.zeppelin.solutions/t/how-to-implement-ERC20-supply-mechanisms/226[How
580  * to implement supply mechanisms].
581  *
582  * We have followed general OpenZeppelin guidelines: functions revert instead
583  * of returning `false` on failure. This behavior is nonetheless conventional
584  * and does not conflict with the expectations of ERC20 applications.
585  *
586  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
587  * This allows applications to reconstruct the allowance for all accounts just
588  * by listening to said events. Other implementations of the EIP may not emit
589  * these events, as it isn't required by the specification.
590  *
591  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
592  * functions have been added to mitigate the well-known issues around setting
593  * allowances. See {IERC20-approve}.
594  */
595 contract ERC20 is Context, IERC20, Ownable {
596     using SafeMath for uint256;
597     using Address for address;
598 
599     mapping(address => uint256) private _balances;
600 
601     mapping(address => mapping(address => uint256)) private _allowances;
602 
603     uint256 private _totalSupply;
604 
605     string private _name;
606     string private _symbol;
607     uint8 private _decimals;
608 
609     /**
610      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
611      * a default value of 18.
612      *
613      * To select a different value for {decimals}, use {_setupDecimals}.
614      *
615      * All three of these values are immutable: they can only be set once during
616      * construction.
617      */
618     constructor(string memory name, string memory symbol) {
619         _name = name;
620         _symbol = symbol;
621         _decimals = 18;
622     }
623 
624     /**
625      * @dev Returns the bep token owner.
626      */
627     function getOwner() external override view returns (address) {
628         return owner();
629     }
630 
631     /**
632      * @dev Returns the token name.
633      */
634     function name() public override view returns (string memory) {
635         return _name;
636     }
637 
638     /**
639      * @dev Returns the token decimals.
640      */
641     function decimals() public override view returns (uint8) {
642         return _decimals;
643     }
644 
645     /**
646      * @dev Returns the token symbol.
647      */
648     function symbol() public override view returns (string memory) {
649         return _symbol;
650     }
651 
652     /**
653      * @dev See {ERC20-totalSupply}.
654      */
655     function totalSupply() public override view returns (uint256) {
656         return _totalSupply;
657     }
658 
659     /**
660      * @dev See {ERC20-balanceOf}.
661      */
662     function balanceOf(address account) public override view returns (uint256) {
663         return _balances[account];
664     }
665 
666     /**
667      * @dev See {ERC20-transfer}.
668      *
669      * Requirements:
670      *
671      * - `recipient` cannot be the zero address.
672      * - the caller must have a balance of at least `amount`.
673      */
674     function transfer(address recipient, uint256 amount) public override returns (bool) {
675         _transfer(_msgSender(), recipient, amount);
676         return true;
677     }
678 
679     /**
680      * @dev See {ERC20-allowance}.
681      */
682     function allowance(address owner, address spender) public override view returns (uint256) {
683         return _allowances[owner][spender];
684     }
685 
686     /**
687      * @dev See {ERC20-approve}.
688      *
689      * Requirements:
690      *
691      * - `spender` cannot be the zero address.
692      */
693     function approve(address spender, uint256 amount) public override returns (bool) {
694         _approve(_msgSender(), spender, amount);
695         return true;
696     }
697 
698     /**
699      * @dev See {ERC20-transferFrom}.
700      *
701      * Emits an {Approval} event indicating the updated allowance. This is not
702      * required by the EIP. See the note at the beginning of {ERC20};
703      *
704      * Requirements:
705      * - `sender` and `recipient` cannot be the zero address.
706      * - `sender` must have a balance of at least `amount`.
707      * - the caller must have allowance for `sender`'s tokens of at least
708      * `amount`.
709      */
710     function transferFrom(
711         address sender,
712         address recipient,
713         uint256 amount
714     ) public override returns (bool) {
715         _transfer(sender, recipient, amount);
716         _approve(
717             sender,
718             _msgSender(),
719             _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
720         );
721         return true;
722     }
723 
724     /**
725      * @dev Atomically increases the allowance granted to `spender` by the caller.
726      *
727      * This is an alternative to {approve} that can be used as a mitigation for
728      * problems described in {ERC20-approve}.
729      *
730      * Emits an {Approval} event indicating the updated allowance.
731      *
732      * Requirements:
733      *
734      * - `spender` cannot be the zero address.
735      */
736     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
737         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
738         return true;
739     }
740 
741     /**
742      * @dev Atomically decreases the allowance granted to `spender` by the caller.
743      *
744      * This is an alternative to {approve} that can be used as a mitigation for
745      * problems described in {ERC20-approve}.
746      *
747      * Emits an {Approval} event indicating the updated allowance.
748      *
749      * Requirements:
750      *
751      * - `spender` cannot be the zero address.
752      * - `spender` must have allowance for the caller of at least
753      * `subtractedValue`.
754      */
755     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
756         _approve(
757             _msgSender(),
758             spender,
759             _allowances[_msgSender()][spender].sub(subtractedValue, 'ERC20: decreased allowance below zero')
760         );
761         return true;
762     }
763 
764     /**
765      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
766      * the total supply.
767      *
768      * Requirements
769      *
770      * - `msg.sender` must be the token owner
771      */
772     function mint(uint256 amount) public onlyOwner returns (bool) {
773         _mint(_msgSender(), amount);
774         return true;
775     }
776 
777     /**
778      * @dev Moves tokens `amount` from `sender` to `recipient`.
779      *
780      * This is internal function is equivalent to {transfer}, and can be used to
781      * e.g. implement automatic token fees, slashing mechanisms, etc.
782      *
783      * Emits a {Transfer} event.
784      *
785      * Requirements:
786      *
787      * - `sender` cannot be the zero address.
788      * - `recipient` cannot be the zero address.
789      * - `sender` must have a balance of at least `amount`.
790      */
791     function _transfer(
792         address sender,
793         address recipient,
794         uint256 amount
795     ) internal {
796         require(sender != address(0), 'ERC20: transfer from the zero address');
797         require(recipient != address(0), 'ERC20: transfer to the zero address');
798 
799         _balances[sender] = _balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');
800         _balances[recipient] = _balances[recipient].add(amount);
801         emit Transfer(sender, recipient, amount);
802     }
803 
804     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
805      * the total supply.
806      *
807      * Emits a {Transfer} event with `from` set to the zero address.
808      *
809      * Requirements
810      *
811      * - `to` cannot be the zero address.
812      */
813     function _mint(address account, uint256 amount) internal {
814         require(account != address(0), 'ERC20: mint to the zero address');
815 
816         _totalSupply = _totalSupply.add(amount);
817         _balances[account] = _balances[account].add(amount);
818         emit Transfer(address(0), account, amount);
819     }
820 
821     /**
822      * @dev Destroys `amount` tokens from `account`, reducing the
823      * total supply.
824      *
825      * Emits a {Transfer} event with `to` set to the zero address.
826      *
827      * Requirements
828      *
829      * - `account` cannot be the zero address.
830      * - `account` must have at least `amount` tokens.
831      */
832     function _burn(address account, uint256 amount) internal {
833         require(account != address(0), 'ERC20: burn from the zero address');
834 
835         _balances[account] = _balances[account].sub(amount, 'ERC20: burn amount exceeds balance');
836         _totalSupply = _totalSupply.sub(amount);
837         emit Transfer(account, address(0), amount);
838     }
839 
840     /**
841      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
842      *
843      * This is internal function is equivalent to `approve`, and can be used to
844      * e.g. set automatic allowances for certain subsystems, etc.
845      *
846      * Emits an {Approval} event.
847      *
848      * Requirements:
849      *
850      * - `owner` cannot be the zero address.
851      * - `spender` cannot be the zero address.
852      */
853     function _approve(
854         address owner,
855         address spender,
856         uint256 amount
857     ) internal {
858         require(owner != address(0), 'ERC20: approve from the zero address');
859         require(spender != address(0), 'ERC20: approve to the zero address');
860 
861         _allowances[owner][spender] = amount;
862         emit Approval(owner, spender, amount);
863     }
864 
865     /**
866      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
867      * from the caller's allowance.
868      *
869      * See {_burn} and {_approve}.
870      */
871     function _burnFrom(address account, uint256 amount) internal {
872         _burn(account, amount);
873         _approve(
874             account,
875             _msgSender(),
876             _allowances[account][_msgSender()].sub(amount, 'ERC20: burn amount exceeds allowance')
877         );
878     }
879 }
880 
881 
882 pragma solidity 0.8.7;
883 
884 // Suteku Rewards Token
885 contract Suteku is ERC20('Suteku SOKU Reward Token', 'SUTEKU') {
886     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
887     function mint(address _to, uint256 _amount) public onlyOwner {
888         _mint(_to, _amount);
889     }
890 
891     /// @notice The EIP-712 typehash for the contract's domain
892     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
893 
894     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
895         require(n < 2**32, errorMessage);
896         return uint32(n);
897     }
898 
899     function getChainId() internal view returns (uint) {
900         uint256 chainId;
901         assembly { chainId := chainid() }
902         return chainId;
903     }
904 }
905 
906 
907 interface IMigratorChef {
908     // Take the current LP token address and return the new LP token address.
909     // Migrator should have full access to the caller's LP token.
910     function migrate(IERC20 token) external returns (IERC20);
911 }
912 
913 // MasterChef is the master of SUTEKU. He can make SUTEKU and he is a fair guy.
914 //
915 // Note that it's ownable and the owner wields tremendous power. The ownership
916 // will be transferred to a governance smart contract once SUTEKU is sufficiently
917 // distributed and the community can show to govern itself.
918 //
919 // Have fun reading it. Hopefully it's bug-free. God bless.
920 contract MasterChef is Ownable {
921     using SafeMath for uint256;
922     using SafeERC20 for IERC20;
923 
924     // Info of each user.
925     struct UserInfo {
926         uint256 amount;     // How many LP tokens the user has provided.
927         uint256 rewardDebt; // Reward debt. See explanation below.
928         //
929         // We do some fancy math here. Basically, any point in time, the amount of SUTEKUs
930         // entitled to a user but is pending to be distributed is:
931         //
932         //   pending reward = (user.amount * pool.accSUTEKUPerShare) - user.rewardDebt
933         //
934         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
935         //   1. The pool's `accSUTEKUPerShare` (and `lastRewardBlock`) gets updated.
936         //   2. User receives the pending reward sent to his/her address.
937         //   3. User's `amount` gets updated.
938         //   4. User's `rewardDebt` gets updated.
939     }
940 
941     // Info of each pool.
942     struct PoolInfo {
943         IERC20 lpToken;           // Address of LP token contract.
944         uint256 allocPoint;       // How many allocation points assigned to this pool. SUTEKUs to distribute per block.
945         uint256 lastRewardBlock;  // Last block number that SUTEKUs distribution occurs.
946         uint256 accSUTEKUPerShare; // Accumulated SUTEKUs per share, times 1e12. See below.
947     }
948 
949 
950     // The SUTEKU REWARD TOKEN!
951     Suteku public SUTEKU;
952 
953     //The migrator contract. It has a lot of power. Can only be set through governance (owner).
954     IMigratorChef public migrator;
955     //source of SUTEKU tokens to pull from
956     address public fundSource;
957     // SUTEKU tokens created per block.
958     uint256 public SUTEKUPerBlock;
959     // Pool lptokens info
960     mapping (IERC20 => bool) public lpTokenStatus;
961     // Info of each pool.
962     PoolInfo[] public poolInfo;
963     // Info of each user that stakes LP tokens.
964     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
965     // Total allocation poitns. Must be the sum of all allocation points in all pools.
966     uint256 public totalAllocPoint = 0;
967     // The block number when SUTEKU distribution starts.
968     uint256 public startBlock;
969 
970     uint256 migratorTimelock = 7 days;
971     bool migratorStarted = false;
972     uint256 migratorStartDate = block.timestamp + migratorTimelock;
973 
974     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
975     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
976     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
977 
978     constructor(
979         Suteku _SUTEKU,
980         uint256 _SUTEKUPerBlock,
981         uint256 _startBlock
982     ) {
983         SUTEKU = _SUTEKU;
984         SUTEKUPerBlock = _SUTEKUPerBlock;
985         startBlock = _startBlock;
986         
987         // staking pool
988         poolInfo.push(PoolInfo({
989             lpToken: _SUTEKU,
990             allocPoint: 1000,
991             lastRewardBlock: startBlock,
992             accSUTEKUPerShare: 0
993         }));
994 
995         totalAllocPoint = 1000;
996     }
997 
998     function poolLength() external view returns (uint256) {
999         return poolInfo.length;
1000     }
1001 
1002     // Add a new lp to the pool. Can only be called by the owner.
1003     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1004         require(lpTokenStatus[_lpToken] != true, "LP token already added");
1005         if (_withUpdate) {
1006             massUpdatePools();
1007         }
1008         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1009         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1010         poolInfo.push(PoolInfo({
1011             lpToken: _lpToken,
1012             allocPoint: _allocPoint,
1013             lastRewardBlock: lastRewardBlock,
1014             accSUTEKUPerShare: 0
1015         }));
1016         lpTokenStatus[_lpToken] = true;
1017         updateStakingPool();
1018     }
1019 
1020     // Update the given pool's SUTEKU allocation point. Can only be called by the owner.
1021     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1022         if (_withUpdate) {
1023             massUpdatePools();
1024         }
1025         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1026         uint256 prevAllocPoint = poolInfo[_pid].allocPoint;
1027         poolInfo[_pid].allocPoint = _allocPoint;
1028         if (prevAllocPoint != _allocPoint) {
1029             updateStakingPool();
1030         }
1031     }
1032 
1033     function updateStakingPool() internal {
1034         uint256 length = poolInfo.length;
1035         uint256 points = 0;
1036         for (uint256 pid = 1; pid < length; ++pid) {
1037             points = points.add(poolInfo[pid].allocPoint);
1038         }
1039         if (points != 0) {
1040             // (May need to change)
1041             points = points.div(3);
1042             totalAllocPoint = totalAllocPoint.sub(poolInfo[0].allocPoint).add(points);
1043             poolInfo[0].allocPoint = points;
1044         }
1045     }
1046 
1047     // Return reward multiplier over the given _from to _to block.
1048     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
1049         return _to.sub(_from);
1050     }
1051 
1052     // View function to see pending SUTEKUs on frontend.
1053     function pendingSUTEKU(uint256 _pid, address _user) public view returns (uint256) {
1054         PoolInfo storage pool = poolInfo[_pid];
1055         UserInfo storage user = userInfo[_pid][_user];
1056         uint256 accSUTEKUPerShare = pool.accSUTEKUPerShare;
1057         uint256 PoolEndBlock =  block.number;
1058         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1059         if (PoolEndBlock > pool.lastRewardBlock && lpSupply != 0) {
1060             uint256 multiplier = getMultiplier(pool.lastRewardBlock, PoolEndBlock);
1061             uint256 SUTEKUReward = multiplier.mul(SUTEKUPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1062             accSUTEKUPerShare = accSUTEKUPerShare.add(SUTEKUReward.mul(1e12).div(lpSupply));
1063         }
1064         return user.amount.mul(accSUTEKUPerShare).div(1e12).sub(user.rewardDebt);
1065     }
1066 
1067     function totalPending(address _user) external view returns (uint256) {
1068         uint256 total = 0;
1069         uint256 length = poolInfo.length;
1070         for (uint256 pid = 0; pid < length; ++pid) {
1071             total = total + pendingSUTEKU(pid, _user);
1072         }
1073         return(total);
1074     }
1075 
1076     // Update reward vairables for all pools. Be careful of gas spending!
1077     function massUpdatePools() public {
1078         uint256 length = poolInfo.length;
1079         for (uint256 pid = 0; pid < length; ++pid) {
1080             updatePool(pid);
1081         }
1082     }
1083 
1084     // Update reward variables of the given pool to be up-to-date.
1085     function updatePool(uint256 _pid) public {
1086         PoolInfo storage pool = poolInfo[_pid];
1087         if (block.number <= pool.lastRewardBlock) {
1088             return;
1089         }
1090         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1091         if (lpSupply == 0) {
1092             pool.lastRewardBlock = block.number;
1093             return;
1094         }
1095         
1096         uint256 PoolEndBlock =  block.number;
1097         uint256 multiplier = getMultiplier(pool.lastRewardBlock, PoolEndBlock);
1098         uint256 SUTEKUReward = multiplier.mul(SUTEKUPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1099         getSUTEKU(SUTEKUReward);
1100         pool.accSUTEKUPerShare = pool.accSUTEKUPerShare.add(SUTEKUReward.mul(1e12).div(lpSupply));
1101         pool.lastRewardBlock = PoolEndBlock;
1102     }
1103 
1104     // Deposit LP tokens to MasterChef for SUTEKU allocation.
1105     function deposit(uint256 _pid, uint256 _amount) public {
1106 
1107         require (_pid != 0, 'Make sure PID is != 0');
1108 
1109         PoolInfo storage pool = poolInfo[_pid];
1110         UserInfo storage user = userInfo[_pid][msg.sender];
1111         updatePool(_pid);
1112         if (user.amount > 0) {
1113             uint256 pending = user.amount.mul(pool.accSUTEKUPerShare).div(1e12).sub(user.rewardDebt);
1114             if(pending > 0) {
1115                 SUTEKU.transfer(msg.sender, pending);
1116             }
1117         }
1118         if(_amount > 0) {
1119             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1120             user.amount = user.amount.add(_amount);
1121         }
1122         user.rewardDebt = user.amount.mul(pool.accSUTEKUPerShare).div(1e12);
1123         emit Deposit(msg.sender, _pid, _amount);
1124     }
1125 
1126     // Withdraw LP tokens from MasterChef.
1127     function withdraw(uint256 _pid, uint256 _amount) public {
1128 
1129         require (_pid != 0, 'Make sure PID != 0');
1130 
1131         PoolInfo storage pool = poolInfo[_pid];
1132         UserInfo storage user = userInfo[_pid][msg.sender];
1133         require(user.amount >= _amount, "withdraw: not good");
1134         updatePool(_pid);
1135         uint256 pending = user.amount.mul(pool.accSUTEKUPerShare).div(1e12).sub(user.rewardDebt);
1136         if(pending > 0) {
1137             SUTEKU.transfer(msg.sender, pending);
1138         }
1139         if(_amount > 0) {
1140             user.amount = user.amount.sub(_amount);
1141             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1142         }
1143         user.rewardDebt = user.amount.mul(pool.accSUTEKUPerShare).div(1e12);
1144         emit Withdraw(msg.sender, _pid, _amount);
1145     }
1146 
1147     // Stake SUTEKU tokens to MasterChef
1148     function enterStaking(uint256 _amount) public {
1149         PoolInfo storage pool = poolInfo[0];
1150         UserInfo storage user = userInfo[0][msg.sender];
1151         updatePool(0);
1152         if (user.amount > 0) {
1153             uint256 pending = user.amount.mul(pool.accSUTEKUPerShare).div(1e12).sub(user.rewardDebt);
1154             if(pending > 0) {
1155                 SUTEKU.transfer(msg.sender, pending);
1156             }
1157         }
1158         if(_amount > 0) {
1159             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1160             user.amount = user.amount.add(_amount);
1161         }
1162         user.rewardDebt = user.amount.mul(pool.accSUTEKUPerShare).div(1e12);
1163 
1164         SUTEKU.mint(msg.sender, _amount);
1165         emit Deposit(msg.sender, 0, _amount);
1166     }
1167 
1168     // Withdraw SUTEKU tokens from STAKING.
1169     function leaveStaking(uint256 _amount) public {
1170         PoolInfo storage pool = poolInfo[0];
1171         UserInfo storage user = userInfo[0][msg.sender];
1172         require(user.amount >= _amount, "withdraw: not good");
1173         updatePool(0);
1174         uint256 pending = user.amount.mul(pool.accSUTEKUPerShare).div(1e12).sub(user.rewardDebt);
1175         if(pending > 0) {
1176             SUTEKU.transfer(msg.sender, pending);
1177         }
1178         if(_amount > 0) {
1179             user.amount = user.amount.sub(_amount);
1180             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1181         }
1182         user.rewardDebt = user.amount.mul(pool.accSUTEKUPerShare).div(1e12);
1183 
1184         emit Withdraw(msg.sender, 0, _amount);
1185     }
1186 
1187     // Withdraw without caring about rewards. EMERGENCY ONLY.
1188     function emergencyWithdraw(uint256 _pid) public {
1189         PoolInfo storage pool = poolInfo[_pid];
1190         UserInfo storage user = userInfo[_pid][msg.sender];
1191         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1192         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1193         user.amount = 0;
1194         user.rewardDebt = 0;
1195     }
1196 
1197 
1198     function updateSUTEKUPerBlock(uint256 newAmountPerBlock) external onlyOwner {
1199         SUTEKUPerBlock = newAmountPerBlock;
1200     }
1201 
1202     function setFundSource(address _fundSource) external onlyOwner {
1203         fundSource = _fundSource;
1204     }
1205 
1206     // Sending X amount of SUTEKU to THIS contract address from the fundSource
1207     function getSUTEKU(uint256 _SUTEKUAmt) internal {
1208         IERC20(SUTEKU).transferFrom(fundSource, address(this), _SUTEKUAmt);
1209     }
1210 
1211     /// @notice Set the `migrator` contract. Can only be called by the owner.
1212     /// @param _migrator The contract address to set.
1213     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1214         migrator = _migrator;
1215     }
1216 
1217 /// @notice Migrate LP token to another LP contract through the migrator contract.
1218     /// @param _pid The index of the pool. See poolInfo.
1219     function migrate(uint256 _pid) public {
1220         if(!migratorStarted) {
1221             migratorStarted = true;
1222             migratorStartDate = block.timestamp + migratorTimelock;
1223         } 
1224         
1225         require(block.timestamp >= migratorStartDate, "Migrator on timelock");
1226         require(address(migrator) != address(0), "MasterChef: no migrator set");
1227         IERC20 _lpToken = poolInfo[_pid].lpToken;
1228         uint256 bal = _lpToken.balanceOf(address(this));
1229         _lpToken.approve(address(migrator), bal);
1230         IERC20 newLpToken = migrator.migrate(_lpToken);
1231         require(bal == newLpToken.balanceOf(address(this)), "MasterChef: migrated balance must match");
1232         poolInfo[_pid].lpToken = newLpToken;
1233     }
1234 }