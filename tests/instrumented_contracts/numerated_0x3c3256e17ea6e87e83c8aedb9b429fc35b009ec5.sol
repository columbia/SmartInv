1 /*
2 
3 website: FoboFomo.finance
4 
5 This project was forked from SUSHI and YUNO projects.
6 
7 Unless those projects have severe vulnerabilities, this contract will be fine
8 
9 SPDX-License-Identifier: MIT
10 */
11 
12 pragma solidity ^0.6.12;
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
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
403 /**
404  * @title SafeERC20
405  * @dev Wrappers around ERC20 operations that throw on failure (when the token
406  * contract returns false). Tokens that return no value (and instead revert or
407  * throw on failure) are also supported, non-reverting calls are assumed to be
408  * successful.
409  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
410  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
411  */
412 library SafeERC20 {
413     using SafeMath for uint256;
414     using Address for address;
415 
416     function safeTransfer(IERC20 token, address to, uint256 value) internal {
417         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
418     }
419 
420     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
421         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
422     }
423 
424     /**
425      * @dev Deprecated. This function has issues similar to the ones found in
426      * {IERC20-approve}, and its usage is discouraged.
427      *
428      * Whenever possible, use {safeIncreaseAllowance} and
429      * {safeDecreaseAllowance} instead.
430      */
431     function safeApprove(IERC20 token, address spender, uint256 value) internal {
432         // safeApprove should only be called when setting an initial allowance,
433         // or when resetting it to zero. To increase and decrease it, use
434         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
435         // solhint-disable-next-line max-line-length
436         require((value == 0) || (token.allowance(address(this), spender) == 0),
437             "SafeERC20: approve from non-zero to non-zero allowance"
438         );
439         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
440     }
441 
442     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
443         uint256 newAllowance = token.allowance(address(this), spender).add(value);
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
445     }
446 
447     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
448         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
449         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
450     }
451 
452     /**
453      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
454      * on the return value: the return value is optional (but if data is returned, it must not be false).
455      * @param token The token targeted by the call.
456      * @param data The call data (encoded using abi.encode or one of its variants).
457      */
458     function _callOptionalReturn(IERC20 token, bytes memory data) private {
459         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
460         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
461         // the target address contains contract code and also asserts for success in the low-level call.
462 
463         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
464         if (returndata.length > 0) { // Return data is optional
465             // solhint-disable-next-line max-line-length
466             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
467         }
468     }
469 }
470 
471 
472 
473 /**
474  * @dev Contract module which provides a basic access control mechanism, where
475  * there is an account (an owner) that can be granted exclusive access to
476  * specific functions.
477  *
478  * By default, the owner account will be the one that deploys the contract. This
479  * can later be changed with {transferOwnership}.
480  *
481  * This module is used through inheritance. It will make available the modifier
482  * `onlyOwner`, which can be applied to your functions to restrict their use to
483  * the owner.
484  */
485 contract Ownable is Context {
486     address private _owner;
487 
488     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
489 
490     /**
491      * @dev Initializes the contract setting the deployer as the initial owner.
492      */
493     constructor () internal {
494         address msgSender = _msgSender();
495         _owner = msgSender;
496         emit OwnershipTransferred(address(0), msgSender);
497     }
498 
499     /**
500      * @dev Returns the address of the current owner.
501      */
502     function owner() public view returns (address) {
503         return _owner;
504     }
505 
506     /**
507      * @dev Throws if called by any account other than the owner.
508      */
509     modifier onlyOwner() {
510         require(_owner == _msgSender(), "Ownable: caller is not the owner");
511         _;
512     }
513 
514     /**
515      * @dev Leaves the contract without owner. It will not be possible to call
516      * `onlyOwner` functions anymore. Can only be called by the current owner.
517      *
518      * NOTE: Renouncing ownership will leave the contract without an owner,
519      * thereby removing any functionality that is only available to the owner.
520      */
521     function renounceOwnership() public virtual onlyOwner {
522         emit OwnershipTransferred(_owner, address(0));
523         _owner = address(0);
524     }
525 
526     /**
527      * @dev Transfers ownership of the contract to a new account (`newOwner`).
528      * Can only be called by the current owner.
529      */
530     function transferOwnership(address newOwner) public virtual onlyOwner {
531         require(newOwner != address(0), "Ownable: new owner is the zero address");
532         emit OwnershipTransferred(_owner, newOwner);
533         _owner = newOwner;
534     }
535 }
536 
537 
538 /**
539  * @dev Implementation of the {IERC20} interface.
540  *
541  * This implementation is agnostic to the way tokens are created. This means
542  * that a supply mechanism has to be added in a derived contract using {_mint}.
543  * For a generic mechanism see {ERC20PresetMinterPauser}.
544  *
545  * TIP: For a detailed writeup see our guide
546  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
547  * to implement supply mechanisms].
548  *
549  * We have followed general OpenZeppelin guidelines: functions revert instead
550  * of returning `false` on failure. This behavior is nonetheless conventional
551  * and does not conflict with the expectations of ERC20 applications.
552  *
553  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
554  * This allows applications to reconstruct the allowance for all accounts just
555  * by listening to said events. Other implementations of the EIP may not emit
556  * these events, as it isn't required by the specification.
557  *
558  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
559  * functions have been added to mitigate the well-known issues around setting
560  * allowances. See {IERC20-approve}.
561  */
562 contract ERC20 is Context, IERC20 {
563     using SafeMath for uint256;
564     using Address for address;
565 
566     mapping (address => uint256) private _balances;
567 
568     mapping (address => mapping (address => uint256)) private _allowances;
569 
570     uint256 private _totalSupply;
571 
572     string private _name;
573     string private _symbol;
574     uint8 private _decimals;
575 
576     /**
577      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
578      * a default value of 18.
579      *
580      * To select a different value for {decimals}, use {_setupDecimals}.
581      *
582      * All three of these values are immutable: they can only be set once during
583      * construction.
584      */
585     constructor (string memory name, string memory symbol) public {
586         _name = name;
587         _symbol = symbol;
588         _decimals = 18;
589     }
590 
591     /**
592      * @dev Returns the name of the token.
593      */
594     function name() public view returns (string memory) {
595         return _name;
596     }
597 
598     /**
599      * @dev Returns the symbol of the token, usually a shorter version of the
600      * name.
601      */
602     function symbol() public view returns (string memory) {
603         return _symbol;
604     }
605 
606     /**
607      * @dev Returns the number of decimals used to get its user representation.
608      * For example, if `decimals` equals `2`, a balance of `505` tokens should
609      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
610      *
611      * Tokens usually opt for a value of 18, imitating the relationship between
612      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
613      * called.
614      *
615      * NOTE: This information is only used for _display_ purposes: it in
616      * no way affects any of the arithmetic of the contract, including
617      * {IERC20-balanceOf} and {IERC20-transfer}.
618      */
619     function decimals() public view returns (uint8) {
620         return _decimals;
621     }
622 
623     /**
624      * @dev See {IERC20-totalSupply}.
625      */
626     function totalSupply() public view override returns (uint256) {
627         return _totalSupply;
628     }
629 
630     /**
631      * @dev See {IERC20-balanceOf}.
632      */
633     function balanceOf(address account) public view override returns (uint256) {
634         return _balances[account];
635     }
636 
637     /**
638      * @dev See {IERC20-transfer}.
639      *
640      * Requirements:
641      *
642      * - `recipient` cannot be the zero address.
643      * - the caller must have a balance of at least `amount`.
644      */
645     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
646         _transfer(_msgSender(), recipient, amount);
647         return true;
648     }
649 
650     /**
651      * @dev See {IERC20-allowance}.
652      */
653     function allowance(address owner, address spender) public view virtual override returns (uint256) {
654         return _allowances[owner][spender];
655     }
656 
657     /**
658      * @dev See {IERC20-approve}.
659      *
660      * Requirements:
661      *
662      * - `spender` cannot be the zero address.
663      */
664     function approve(address spender, uint256 amount) public virtual override returns (bool) {
665         _approve(_msgSender(), spender, amount);
666         return true;
667     }
668 
669     /**
670      * @dev See {IERC20-transferFrom}.
671      *
672      * Emits an {Approval} event indicating the updated allowance. This is not
673      * required by the EIP. See the note at the beginning of {ERC20};
674      *
675      * Requirements:
676      * - `sender` and `recipient` cannot be the zero address.
677      * - `sender` must have a balance of at least `amount`.
678      * - the caller must have allowance for ``sender``'s tokens of at least
679      * `amount`.
680      */
681     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
682         _transfer(sender, recipient, amount);
683         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
684         return true;
685     }
686 
687     /**
688      * @dev Atomically increases the allowance granted to `spender` by the caller.
689      *
690      * This is an alternative to {approve} that can be used as a mitigation for
691      * problems described in {IERC20-approve}.
692      *
693      * Emits an {Approval} event indicating the updated allowance.
694      *
695      * Requirements:
696      *
697      * - `spender` cannot be the zero address.
698      */
699     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
700         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
701         return true;
702     }
703 
704     /**
705      * @dev Atomically decreases the allowance granted to `spender` by the caller.
706      *
707      * This is an alternative to {approve} that can be used as a mitigation for
708      * problems described in {IERC20-approve}.
709      *
710      * Emits an {Approval} event indicating the updated allowance.
711      *
712      * Requirements:
713      *
714      * - `spender` cannot be the zero address.
715      * - `spender` must have allowance for the caller of at least
716      * `subtractedValue`.
717      */
718     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
719         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
720         return true;
721     }
722 
723     /**
724      * @dev Moves tokens `amount` from `sender` to `recipient`.
725      *
726      * This is internal function is equivalent to {transfer}, and can be used to
727      * e.g. implement automatic token fees, slashing mechanisms, etc.
728      *
729      * Emits a {Transfer} event.
730      *
731      * Requirements:
732      *
733      * - `sender` cannot be the zero address.
734      * - `recipient` cannot be the zero address.
735      * - `sender` must have a balance of at least `amount`.
736      */
737     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
738         require(sender != address(0), "ERC20: transfer from the zero address");
739         require(recipient != address(0), "ERC20: transfer to the zero address");
740 
741         _beforeTokenTransfer(sender, recipient, amount);
742 
743         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
744         _balances[recipient] = _balances[recipient].add(amount);
745         emit Transfer(sender, recipient, amount);
746     }
747 
748     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
749      * the total supply.
750      *
751      * Emits a {Transfer} event with `from` set to the zero address.
752      *
753      * Requirements
754      *
755      * - `to` cannot be the zero address.
756      */
757     function _mint(address account, uint256 amount) internal virtual {
758         require(account != address(0), "ERC20: mint to the zero address");
759 
760         _beforeTokenTransfer(address(0), account, amount);
761 
762         _totalSupply = _totalSupply.add(amount);
763         _balances[account] = _balances[account].add(amount);
764         emit Transfer(address(0), account, amount);
765     }
766 
767     /**
768      * @dev Destroys `amount` tokens from `account`, reducing the
769      * total supply.
770      *
771      * Emits a {Transfer} event with `to` set to the zero address.
772      *
773      * Requirements
774      *
775      * - `account` cannot be the zero address.
776      * - `account` must have at least `amount` tokens.
777      */
778     function _burn(address account, uint256 amount) internal virtual {
779         require(account != address(0), "ERC20: burn from the zero address");
780 
781         _beforeTokenTransfer(account, address(0), amount);
782 
783         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
784         _totalSupply = _totalSupply.sub(amount);
785         emit Transfer(account, address(0), amount);
786     }
787 
788     /**
789      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
790      *
791      * This is internal function is equivalent to `approve`, and can be used to
792      * e.g. set automatic allowances for certain subsystems, etc.
793      *
794      * Emits an {Approval} event.
795      *
796      * Requirements:
797      *
798      * - `owner` cannot be the zero address.
799      * - `spender` cannot be the zero address.
800      */
801     function _approve(address owner, address spender, uint256 amount) internal virtual {
802         require(owner != address(0), "ERC20: approve from the zero address");
803         require(spender != address(0), "ERC20: approve to the zero address");
804 
805         _allowances[owner][spender] = amount;
806         emit Approval(owner, spender, amount);
807     }
808 
809     /**
810      * @dev Sets {decimals} to a value other than the default one of 18.
811      *
812      * WARNING: This function should only be called from the constructor. Most
813      * applications that interact with token contracts will not expect
814      * {decimals} to ever change, and may work incorrectly if it does.
815      */
816     function _setupDecimals(uint8 decimals_) internal {
817         _decimals = decimals_;
818     }
819 
820     /**
821      * @dev Hook that is called before any transfer of tokens. This includes
822      * minting and burning.
823      *
824      * Calling conditions:
825      *
826      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
827      * will be to transferred to `to`.
828      * - when `from` is zero, `amount` tokens will be minted for `to`.
829      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
830      * - `from` and `to` are never both zero.
831      *
832      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
833      */
834     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
835 }
836 
837 contract FoboERC20 is ERC20("FOBOFOMO", "FOBOFOMO"), Ownable {
838     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner.
839     function mint(address _to, uint256 _amount) public onlyOwner {
840         _mint(_to, _amount);
841     }
842 }
843 
844 contract FoboMaster is Ownable {
845     using SafeMath for uint256;
846     using SafeERC20 for IERC20;
847 
848     // Info of each user.
849     struct UserInfo {
850         uint256 amount;     // How many LP tokens the user has provided.
851         uint256 rewardDebt; // Reward debt. See explanation below.
852         //
853         // We do some fancy math here. Basically, any point in time, the amount of FOBOs
854         // entitled to a user but is pending to be distributed is:
855         //
856         //   pending reward = (user.amount * pool.accFoboPerShare) - user.rewardDebt
857         //
858         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
859         //   1. The pool's `accFoboPerShare` (and `lastRewardBlock`) gets updated.
860         //   2. User receives the pending reward sent to his/her address.
861         //   3. User's `amount` gets updated.
862         //   4. User's `rewardDebt` gets updated.
863     }
864 
865     // Info of each pool.
866     struct PoolInfo {
867         IERC20 lpToken;           // Address of LP token contract.
868         uint256 allocPoint;       // How many allocation points assigned to this pool. POBs to distribute per block.
869         uint256 lastRewardBlock;  // Last block number that POBs distribution occurs.
870         uint256 accFoboPerShare; // Accumulated Fobos per share, times 1e12. See below.
871     }
872 
873     // The FOBO TOKEN!
874     FoboERC20 public fobo;
875     // Dev address.
876     address public devaddr;
877     // Block number when bonus FOBO period ends.
878     uint256 public bonusEndBlock;
879     // FOBO tokens created per block.
880     uint256 public foboPerBlock;
881     // Bonus muliplier for early FOBO makers.
882     uint256 public constant BONUS_MULTIPLIER = 10;
883 
884     // Info of each pool.
885     PoolInfo[] public poolInfo;
886     // Info of each user that stakes LP tokens.
887     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
888     // Total allocation poitns. Must be the sum of all allocation points in all pools.
889     uint256 public totalAllocPoint = 0;
890     // The block number when FOBO mining starts.
891     uint256 public startBlock;
892 
893     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
894     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
895     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
896 
897     constructor(
898         FoboERC20 _fobo,
899         address _devaddr,
900         uint256 _foboPerBlock,
901         uint256 _startBlock,
902         uint256 _bonusEndBlock
903     ) public {
904         fobo = _fobo;
905         devaddr = _devaddr;
906         foboPerBlock = _foboPerBlock;
907         bonusEndBlock = _bonusEndBlock;
908         startBlock = _startBlock;
909     }
910 
911     function poolLength() external view returns (uint256) {
912         return poolInfo.length;
913     }
914 
915     // Add a new lp to the pool. Can only be called by the owner.
916     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
917     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
918         if (_withUpdate) {
919             massUpdatePools();
920         }
921         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
922         totalAllocPoint = totalAllocPoint.add(_allocPoint);
923         poolInfo.push(PoolInfo({
924             lpToken: _lpToken,
925             allocPoint: _allocPoint,
926             lastRewardBlock: lastRewardBlock,
927             accFoboPerShare: 0
928         }));
929     }
930 
931     // Update the given pool's FOBO allocation point. Can only be called by the owner.
932     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
933         if (_withUpdate) {
934             massUpdatePools();
935         }
936         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
937         poolInfo[_pid].allocPoint = _allocPoint;
938     }
939 
940 
941 
942     // Return reward multiplier over the given _from to _to block.
943     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
944         if (_to <= bonusEndBlock) {
945             return _to.sub(_from).mul(BONUS_MULTIPLIER);
946         } else if (_from >= bonusEndBlock) {
947             return _to.sub(_from);
948         } else {
949             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
950                 _to.sub(bonusEndBlock)
951             );
952         }
953     }
954 
955     // View function to see pending FOBOs on frontend.
956     function pendingFobo(uint256 _pid, address _user) external view returns (uint256) {
957         PoolInfo storage pool = poolInfo[_pid];
958         UserInfo storage user = userInfo[_pid][_user];
959         uint256 accFoboPerShare = pool.accFoboPerShare;
960         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
961         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
962             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
963             uint256 foboReward = multiplier.mul(foboPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
964             accFoboPerShare = accFoboPerShare.add(foboReward.mul(1e12).div(lpSupply));
965         }
966         return user.amount.mul(accFoboPerShare).div(1e12).sub(user.rewardDebt);
967     }
968 
969     // Update reward vairables for all pools. Be careful of gas spending!
970     function massUpdatePools() public {
971         uint256 length = poolInfo.length;
972         for (uint256 pid = 0; pid < length; ++pid) {
973             updatePool(pid);
974         }
975     }
976     // Update reward variables of the given pool to be up-to-date.
977     function mint(uint256 amount) public onlyOwner{
978         fobo.mint(devaddr, amount);
979     }
980     // Update reward variables of the given pool to be up-to-date.
981     function updatePool(uint256 _pid) public {
982         PoolInfo storage pool = poolInfo[_pid];
983         if (block.number <= pool.lastRewardBlock) {
984             return;
985         }
986         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
987         if (lpSupply == 0) {
988             pool.lastRewardBlock = block.number;
989             return;
990         }
991         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
992         uint256 foboReward = multiplier.mul(foboPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
993         fobo.mint(address(this), foboReward);
994         pool.accFoboPerShare = pool.accFoboPerShare.add(foboReward.mul(1e12).div(lpSupply));
995         pool.lastRewardBlock = block.number;
996     }
997 
998     // Deposit LP tokens to MasterChef for FOBO allocation.
999     function deposit(uint256 _pid, uint256 _amount) public {
1000         PoolInfo storage pool = poolInfo[_pid];
1001         UserInfo storage user = userInfo[_pid][msg.sender];
1002         updatePool(_pid);
1003         if (user.amount > 0) {
1004             uint256 pending = user.amount.mul(pool.accFoboPerShare).div(1e12).sub(user.rewardDebt);
1005             safeFoboTransfer(msg.sender, pending);
1006         }
1007         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1008         user.amount = user.amount.add(_amount);
1009         user.rewardDebt = user.amount.mul(pool.accFoboPerShare).div(1e12);
1010         emit Deposit(msg.sender, _pid, _amount);
1011     }
1012 
1013     // Withdraw LP tokens from MasterChef.
1014     function withdraw(uint256 _pid, uint256 _amount) public {
1015         PoolInfo storage pool = poolInfo[_pid];
1016         UserInfo storage user = userInfo[_pid][msg.sender];
1017         require(user.amount >= _amount, "withdraw: not good");
1018         updatePool(_pid);
1019         uint256 pending = user.amount.mul(pool.accFoboPerShare).div(1e12).sub(user.rewardDebt);
1020         safeFoboTransfer(msg.sender, pending);
1021         user.amount = user.amount.sub(_amount);
1022         user.rewardDebt = user.amount.mul(pool.accFoboPerShare).div(1e12);
1023         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1024         emit Withdraw(msg.sender, _pid, _amount);
1025     }
1026 
1027     // Withdraw without caring about rewards. EMERGENCY ONLY.
1028     function emergencyWithdraw(uint256 _pid) public {
1029         PoolInfo storage pool = poolInfo[_pid];
1030         UserInfo storage user = userInfo[_pid][msg.sender];
1031         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1032         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1033         user.amount = 0;
1034         user.rewardDebt = 0;
1035     }
1036 
1037     // Safe FOBO transfer function, just in case if rounding error causes pool to not have enough FOBOs.
1038     function safeFoboTransfer(address _to, uint256 _amount) internal {
1039         uint256 foboBal = fobo.balanceOf(address(this));
1040         if (_amount > foboBal) {
1041             fobo.transfer(_to, foboBal);
1042         } else {
1043             fobo.transfer(_to, _amount);
1044         }
1045     }
1046 
1047     // Update dev address by the previous dev.
1048     function dev(address _devaddr) public {
1049         require(msg.sender == devaddr, "dev: wut?");
1050         devaddr = _devaddr;
1051     }
1052 }