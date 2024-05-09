1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b <= a, errorMessage);
132         uint256 c = a - b;
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         return div(a, b, "SafeMath: division by zero");
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
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
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
206         return mod(a, b, "SafeMath: modulo by zero");
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts with custom message when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b != 0, errorMessage);
222         return a % b;
223     }
224 }
225 
226 /**
227  * @dev Collection of functions related to the address type
228  */
229 library Address {
230     /**
231      * @dev Returns true if `account` is a contract.
232      *
233      * [IMPORTANT]
234      * ====
235      * It is unsafe to assume that an address for which this function returns
236      * false is an externally-owned account (EOA) and not a contract.
237      *
238      * Among others, `isContract` will return false for the following
239      * types of addresses:
240      *
241      *  - an externally-owned account
242      *  - a contract in construction
243      *  - an address where a contract will be created
244      *  - an address where a contract lived, but was destroyed
245      * ====
246      */
247     function isContract(address account) internal view returns (bool) {
248         // This method relies in extcodesize, which returns 0 for contracts in
249         // construction, since the code is only stored at the end of the
250         // constructor execution.
251 
252         uint256 size;
253         // solhint-disable-next-line no-inline-assembly
254         assembly { size := extcodesize(account) }
255         return size > 0;
256     }
257 
258     /**
259      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
260      * `recipient`, forwarding all available gas and reverting on errors.
261      *
262      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
263      * of certain opcodes, possibly making contracts go over the 2300 gas limit
264      * imposed by `transfer`, making them unable to receive funds via
265      * `transfer`. {sendValue} removes this limitation.
266      *
267      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
268      *
269      * IMPORTANT: because control is transferred to `recipient`, care must be
270      * taken to not create reentrancy vulnerabilities. Consider using
271      * {ReentrancyGuard} or the
272      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
273      */
274     function sendValue(address payable recipient, uint256 amount) internal {
275         require(address(this).balance >= amount, "Address: insufficient balance");
276 
277         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
278         (bool success, ) = recipient.call{ value: amount }("");
279         require(success, "Address: unable to send value, recipient may have reverted");
280     }
281 
282     /**
283      * @dev Performs a Solidity function call using a low level `call`. A
284      * plain`call` is an unsafe replacement for a function call: use this
285      * function instead.
286      *
287      * If `target` reverts with a revert reason, it is bubbled up by this
288      * function (like regular Solidity function calls).
289      *
290      * Returns the raw returned data. To convert to the expected return value,
291      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
292      *
293      * Requirements:
294      *
295      * - `target` must be a contract.
296      * - calling `target` with `data` must not revert.
297      *
298      * _Available since v3.1._
299      */
300     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
301       return functionCall(target, data, "Address: low-level call failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
306      * `errorMessage` as a fallback revert reason when `target` reverts.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
311         return _functionCallWithValue(target, data, 0, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but also transferring `value` wei to `target`.
317      *
318      * Requirements:
319      *
320      * - the calling contract must have an ETH balance of at least `value`.
321      * - the called Solidity function must be `payable`.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331      * with `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         return _functionCallWithValue(target, data, value, errorMessage);
338     }
339 
340     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
341         require(isContract(target), "Address: call to non-contract");
342 
343         // solhint-disable-next-line avoid-low-level-calls
344         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
345         if (success) {
346             return returndata;
347         } else {
348             // Look for revert reason and bubble it up if present
349             if (returndata.length > 0) {
350                 // The easiest way to bubble the revert reason is using memory via assembly
351 
352                 // solhint-disable-next-line no-inline-assembly
353                 assembly {
354                     let returndata_size := mload(returndata)
355                     revert(add(32, returndata), returndata_size)
356                 }
357             } else {
358                 revert(errorMessage);
359             }
360         }
361     }
362 }
363 
364 /**
365  * @title SafeERC20
366  * @dev Wrappers around ERC20 operations that throw on failure (when the token
367  * contract returns false). Tokens that return no value (and instead revert or
368  * throw on failure) are also supported, non-reverting calls are assumed to be
369  * successful.
370  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
371  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
372  */
373 library SafeERC20 {
374     using SafeMath for uint256;
375     using Address for address;
376 
377     function safeTransfer(IERC20 token, address to, uint256 value) internal {
378         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
379     }
380 
381     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
382         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
383     }
384 
385     /**
386      * @dev Deprecated. This function has issues similar to the ones found in
387      * {IERC20-approve}, and its usage is discouraged.
388      *
389      * Whenever possible, use {safeIncreaseAllowance} and
390      * {safeDecreaseAllowance} instead.
391      */
392     function safeApprove(IERC20 token, address spender, uint256 value) internal {
393         // safeApprove should only be called when setting an initial allowance,
394         // or when resetting it to zero. To increase and decrease it, use
395         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
396         // solhint-disable-next-line max-line-length
397         require((value == 0) || (token.allowance(address(this), spender) == 0),
398             "SafeERC20: approve from non-zero to non-zero allowance"
399         );
400         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
401     }
402 
403     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
404         uint256 newAllowance = token.allowance(address(this), spender).add(value);
405         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
406     }
407 
408     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
409         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
410         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
411     }
412 
413     /**
414      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
415      * on the return value: the return value is optional (but if data is returned, it must not be false).
416      * @param token The token targeted by the call.
417      * @param data The call data (encoded using abi.encode or one of its variants).
418      */
419     function _callOptionalReturn(IERC20 token, bytes memory data) private {
420         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
421         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
422         // the target address contains contract code and also asserts for success in the low-level call.
423 
424         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
425         if (returndata.length > 0) { // Return data is optional
426             // solhint-disable-next-line max-line-length
427             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
428         }
429     }
430 }
431 
432 contract Context {
433     function _msgSender() internal view returns (address payable) {
434         return msg.sender;
435     }
436 
437     function _msgData() internal view returns (bytes memory) {
438         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
439         return msg.data;
440     }
441 }
442 
443 /**
444  * @dev Contract module which provides a basic access control mechanism, where
445  * there is an account (an owner) that can be granted exclusive access to
446  * specific functions.
447  *
448  * By default, the owner account will be the one that deploys the contract. This
449  * can later be changed with {transferOwnership}.
450  *
451  * This module is used through inheritance. It will make available the modifier
452  * `onlyOwner`, which can be applied to your functions to restrict their use to
453  * the owner.
454  */
455 contract Ownable is Context {
456     address private _owner;
457 
458     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
459 
460     /**
461      * @dev Initializes the contract setting the deployer as the initial owner.
462      */
463     constructor () internal {
464         address msgSender = _msgSender();
465         _owner = msgSender;
466         emit OwnershipTransferred(address(0), msgSender);
467     }
468 
469     /**
470      * @dev Returns the address of the current owner.
471      */
472     function owner() public view returns (address) {
473         return _owner;
474     }
475 
476     /**
477      * @dev Throws if called by any account other than the owner.
478      */
479     modifier onlyOwner() {
480         require(_owner == _msgSender(), "Ownable: caller is not the owner");
481         _;
482     }
483 
484     /**
485      * @dev Leaves the contract without owner. It will not be possible to call
486      * `onlyOwner` functions anymore. Can only be called by the current owner.
487      *
488      * NOTE: Renouncing ownership will leave the contract without an owner,
489      * thereby removing any functionality that is only available to the owner.
490      */
491     function renounceOwnership() public onlyOwner {
492         emit OwnershipTransferred(_owner, address(0));
493         _owner = address(0);
494     }
495 
496     /**
497      * @dev Transfers ownership of the contract to a new account (`newOwner`).
498      * Can only be called by the current owner.
499      */
500     function transferOwnership(address newOwner) public onlyOwner {
501         require(newOwner != address(0), "Ownable: new owner is the zero address");
502         emit OwnershipTransferred(_owner, newOwner);
503         _owner = newOwner;
504     }
505 }
506 
507 /**
508  * @dev Implementation of the {IERC20} interface.
509  *
510  * This implementation is agnostic to the way tokens are created. This means
511  * that a supply mechanism has to be added in a derived contract using {_mint}.
512  * For a generic mechanism see {ERC20PresetMinterPauser}.
513  *
514  * TIP: For a detailed writeup see our guide
515  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
516  * to implement supply mechanisms].
517  *
518  * We have followed general OpenZeppelin guidelines: functions revert instead
519  * of returning `false` on failure. This behavior is nonetheless conventional
520  * and does not conflict with the expectations of ERC20 applications.
521  *
522  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
523  * This allows applications to reconstruct the allowance for all accounts just
524  * by listening to said events. Other implementations of the EIP may not emit
525  * these events, as it isn't required by the specification.
526  *
527  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
528  * functions have been added to mitigate the well-known issues around setting
529  * allowances. See {IERC20-approve}.
530  */
531 contract ERC20 is Context, IERC20 {
532     using SafeMath for uint256;
533     using Address for address;
534 
535     mapping (address => uint256) public _balances;
536 
537     mapping (address => mapping (address => uint256)) private _allowances;
538 
539     uint256 private _totalSupply;
540 
541     string private _name;
542     string private _symbol;
543     uint8 private _decimals;
544 
545     event  Deposit(address indexed dst, uint wad);
546     event  Withdrawal(address indexed src, uint wad);
547 
548     /**
549      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
550      * a default value of 18.
551      *
552      * To select a different value for {decimals}, use {_setupDecimals}.
553      *
554      * All three of these values are immutable: they can only be set once during
555      * construction.
556      */
557     constructor (string memory name, string memory symbol) public {
558         _name = name;
559         _symbol = symbol;
560         _decimals = 18;
561     }
562 
563     /**
564      * @dev Returns the name of the token.
565      */
566     function name() public view returns (string memory) {
567         return _name;
568     }
569 
570     /**
571      * @dev Returns the symbol of the token, usually a shorter version of the
572      * name.
573      */
574     function symbol() public view returns (string memory) {
575         return _symbol;
576     }
577 
578     /**
579      * @dev Returns the number of decimals used to get its user representation.
580      * For example, if `decimals` equals `2`, a balance of `505` tokens should
581      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
582      *
583      * Tokens usually opt for a value of 18, imitating the relationship between
584      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
585      * called.
586      *
587      * NOTE: This information is only used for _display_ purposes: it in
588      * no way affects any of the arithmetic of the contract, including
589      * {IERC20-balanceOf} and {IERC20-transfer}.
590      */
591     function decimals() public view returns (uint8) {
592         return _decimals;
593     }
594 
595     /**
596      * @dev See {IERC20-totalSupply}.
597      */
598     function totalSupply() public view override returns (uint256) {
599         return _totalSupply;
600     }
601 
602     /**
603      * @dev See {IERC20-balanceOf}.
604      */
605     function balanceOf(address account) public view override returns (uint256) {
606         return _balances[account];
607     }
608 
609     /**
610      * @dev See {IERC20-transfer}.
611      *
612      * Requirements:
613      *
614      * - `recipient` cannot be the zero address.
615      * - the caller must have a balance of at least `amount`.
616      */
617     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
618         _transfer(_msgSender(), recipient, amount);
619         return true;
620     }
621 
622     /**
623      * @dev See {IERC20-allowance}.
624      */
625     function allowance(address owner, address spender) public view virtual override returns (uint256) {
626         return _allowances[owner][spender];
627     }
628 
629     /**
630      * @dev See {IERC20-approve}.
631      *
632      * Requirements:
633      *
634      * - `spender` cannot be the zero address.
635      */
636     function approve(address spender, uint256 amount) public virtual override returns (bool) {
637         _approve(_msgSender(), spender, amount);
638         return true;
639     }
640 
641     /**
642      * @dev See {IERC20-transferFrom}.
643      *
644      * Emits an {Approval} event indicating the updated allowance. This is not
645      * required by the EIP. See the note at the beginning of {ERC20};
646      *
647      * Requirements:
648      * - `sender` and `recipient` cannot be the zero address.
649      * - `sender` must have a balance of at least `amount`.
650      * - the caller must have allowance for ``sender``'s tokens of at least
651      * `amount`.
652      */
653     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
654         _transfer(sender, recipient, amount);
655         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
656         return true;
657     }
658 
659     /**
660      * @dev Atomically increases the allowance granted to `spender` by the caller.
661      *
662      * This is an alternative to {approve} that can be used as a mitigation for
663      * problems described in {IERC20-approve}.
664      *
665      * Emits an {Approval} event indicating the updated allowance.
666      *
667      * Requirements:
668      *
669      * - `spender` cannot be the zero address.
670      */
671     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
672         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
673         return true;
674     }
675 
676     /**
677      * @dev Atomically decreases the allowance granted to `spender` by the caller.
678      *
679      * This is an alternative to {approve} that can be used as a mitigation for
680      * problems described in {IERC20-approve}.
681      *
682      * Emits an {Approval} event indicating the updated allowance.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      * - `spender` must have allowance for the caller of at least
688      * `subtractedValue`.
689      */
690     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
691         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
692         return true;
693     }
694 
695     /**
696      * @dev Moves tokens `amount` from `sender` to `recipient`.
697      *
698      * This is internal function is equivalent to {transfer}, and can be used to
699      * e.g. implement automatic token fees, slashing mechanisms, etc.
700      *
701      * Emits a {Transfer} event.
702      *
703      * Requirements:
704      *
705      * - `sender` cannot be the zero address.
706      * - `recipient` cannot be the zero address.
707      * - `sender` must have a balance of at least `amount`.
708      */
709     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
710         require(sender != address(0), "ERC20: transfer from the zero address");
711         require(recipient != address(0), "ERC20: transfer to the zero address");
712 
713         _beforeTokenTransfer(sender, recipient, amount);
714         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
715         _balances[recipient] = _balances[recipient].add(amount);
716         emit Transfer(sender, recipient, amount);
717     }
718 
719     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
720      * the total supply.
721      *
722      * Emits a {Transfer} event with `from` set to the zero address.
723      *
724      * Requirements
725      *
726      * - `to` cannot be the zero address.
727      */
728     function _mint(address account, uint256 amount) internal virtual {
729         require(account != address(0), "ERC20: mint to the zero address");
730 
731         _beforeTokenTransfer(address(0), account, amount);
732 
733         _totalSupply = _totalSupply.add(amount);
734         _balances[account] = _balances[account].add(amount);
735         emit Transfer(address(0), account, amount);
736     }
737 
738     /**
739      * @dev Destroys `amount` tokens from `account`, reducing the
740      * total supply.
741      *
742      * Emits a {Transfer} event with `to` set to the zero address.
743      *
744      * Requirements
745      *
746      * - `account` cannot be the zero address.
747      * - `account` must have at least `amount` tokens.
748      */
749     function _burn(address account, uint256 amount) internal virtual {
750         require(account != address(0), "ERC20: burn from the zero address");
751 
752         _beforeTokenTransfer(account, address(0), amount);
753 
754         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
755         _totalSupply = _totalSupply.sub(amount);
756         emit Transfer(account, address(0), amount);
757     }
758 
759     /**
760      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
761      *
762      * This is internal function is equivalent to `approve`, and can be used to
763      * e.g. set automatic allowances for certain subsystems, etc.
764      *
765      * Emits an {Approval} event.
766      *
767      * Requirements:
768      *
769      * - `owner` cannot be the zero address.
770      * - `spender` cannot be the zero address.
771      */
772     function _approve(address owner, address spender, uint256 amount) internal virtual {
773         require(owner != address(0), "ERC20: approve from the zero address");
774         require(spender != address(0), "ERC20: approve to the zero address");
775 
776         _allowances[owner][spender] = amount;
777         emit Approval(owner, spender, amount);
778     }
779 
780     /**
781      * @dev Sets {decimals} to a value other than the default one of 18.
782      *
783      * WARNING: This function should only be called from the constructor. Most
784      * applications that interact with token contracts will not expect
785      * {decimals} to ever change, and may work incorrectly if it does.
786      */
787     function _setupDecimals(uint8 decimals_) internal {
788         _decimals = decimals_;
789     }
790 
791     // fallback() external payable {
792     //     deposit();
793     // }
794 
795     // function deposit() public payable {
796     //     _balances[msg.sender] += msg.value;
797     //     Deposit(msg.sender, msg.value);
798     // }
799 
800     // function withdraw(uint wad) public {
801     //     require(_balances[msg.sender] >= wad);
802     //     _balances[msg.sender] -= wad;
803     //     msg.sender.transfer(wad);
804     //     Withdrawal(msg.sender, wad);
805     // }
806 
807     /**
808      * @dev Hook that is called before any transfer of tokens. This includes
809      * minting and burning.
810      *
811      * Calling conditions:
812      *
813      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
814      * will be to transferred to `to`.
815      * - when `from` is zero, `amount` tokens will be minted for `to`.
816      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
817      * - `from` and `to` are never both zero.
818      *
819      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
820      */
821     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
822 }
823 
824 interface IUniswapV2Factory {
825     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
826 
827     function feeTo() external view returns (address);
828     function feeToSetter() external view returns (address);
829     function migrator() external view returns (address);
830 
831     function getPair(address tokenA, address tokenB) external view returns (address pair);
832     function allPairs(uint) external view returns (address pair);
833     function allPairsLength() external view returns (uint);
834 
835     function createPair(address tokenA, address tokenB) external returns (address pair);
836 
837     function setFeeTo(address) external;
838     function setFeeToSetter(address) external;
839     function setMigrator(address) external;
840 }
841 
842 interface IUniswapV2Router01 {
843     function factory() external pure returns (address);
844     function WETH() external pure returns (address);
845 
846     function addLiquidity(
847         address tokenA,
848         address tokenB,
849         uint amountADesired,
850         uint amountBDesired,
851         uint amountAMin,
852         uint amountBMin,
853         address to,
854         uint deadline
855     ) external returns (uint amountA, uint amountB, uint liquidity);
856     function addLiquidityETH(
857         address token,
858         uint amountTokenDesired,
859         uint amountTokenMin,
860         uint amountETHMin,
861         address to,
862         uint deadline
863     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
864     function removeLiquidity(
865         address tokenA,
866         address tokenB,
867         uint liquidity,
868         uint amountAMin,
869         uint amountBMin,
870         address to,
871         uint deadline
872     ) external returns (uint amountA, uint amountB);
873     function removeLiquidityETH(
874         address token,
875         uint liquidity,
876         uint amountTokenMin,
877         uint amountETHMin,
878         address to,
879         uint deadline
880     ) external returns (uint amountToken, uint amountETH);
881     function removeLiquidityWithPermit(
882         address tokenA,
883         address tokenB,
884         uint liquidity,
885         uint amountAMin,
886         uint amountBMin,
887         address to,
888         uint deadline,
889         bool approveMax, uint8 v, bytes32 r, bytes32 s
890     ) external returns (uint amountA, uint amountB);
891     function removeLiquidityETHWithPermit(
892         address token,
893         uint liquidity,
894         uint amountTokenMin,
895         uint amountETHMin,
896         address to,
897         uint deadline,
898         bool approveMax, uint8 v, bytes32 r, bytes32 s
899     ) external returns (uint amountToken, uint amountETH);
900     function swapExactTokensForTokens(
901         uint amountIn,
902         uint amountOutMin,
903         address[] calldata path,
904         address to,
905         uint deadline
906     ) external returns (uint[] memory amounts);
907     function swapTokensForExactTokens(
908         uint amountOut,
909         uint amountInMax,
910         address[] calldata path,
911         address to,
912         uint deadline
913     ) external returns (uint[] memory amounts);
914     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
915         external
916         payable
917         returns (uint[] memory amounts);
918     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
919         external
920         returns (uint[] memory amounts);
921     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
922         external
923         returns (uint[] memory amounts);
924     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
925         external
926         payable
927         returns (uint[] memory amounts);
928 
929     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
930     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
931     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
932     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
933     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
934 }
935 
936 interface IUniswapV2Router02 is IUniswapV2Router01 {
937     function removeLiquidityETHSupportingFeeOnTransferTokens(
938         address token,
939         uint liquidity,
940         uint amountTokenMin,
941         uint amountETHMin,
942         address to,
943         uint deadline
944     ) external returns (uint amountETH);
945     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
946         address token,
947         uint liquidity,
948         uint amountTokenMin,
949         uint amountETHMin,
950         address to,
951         uint deadline,
952         bool approveMax, uint8 v, bytes32 r, bytes32 s
953     ) external returns (uint amountETH);
954 
955     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
956         uint amountIn,
957         uint amountOutMin,
958         address[] calldata path,
959         address to,
960         uint deadline
961     ) external;
962     function swapExactETHForTokensSupportingFeeOnTransferTokens(
963         uint amountOutMin,
964         address[] calldata path,
965         address to,
966         uint deadline
967     ) external payable;
968     function swapExactTokensForETHSupportingFeeOnTransferTokens(
969         uint amountIn,
970         uint amountOutMin,
971         address[] calldata path,
972         address to,
973         uint deadline
974     ) external;
975 }
976 
977 interface IWETH {
978     function deposit() external payable;
979     function transfer(address to, uint value) external returns (bool);
980     function withdraw(uint) external;
981 }
982 
983 // CHILL with Governance.
984 contract ChillToken is ERC20("CHILLSWAP", "CHILL"), Ownable {
985 
986     IUniswapV2Router02 public iUniswapV2Router02;
987     IUniswapV2Factory public iUniswapV2Factory;
988     IWETH public iWeth;
989     IERC20 public tokenA;
990     IERC20 public tokenB;
991     
992     /// @notice A record of each accounts delegate
993     mapping (address => address) internal _delegates;
994 
995     /// @notice A checkpoint for marking number of votes from a given block
996     struct Checkpoint {
997         uint32 fromBlock;
998         uint256 votes;
999     }
1000 
1001     /// @notice A record of votes checkpoints for each account, by index
1002     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1003 
1004     /// @notice The number of checkpoints for each account
1005     mapping (address => uint32) public numCheckpoints;
1006 
1007     /// @notice The EIP-712 typehash for the contract's domain
1008     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1009 
1010     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1011     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1012 
1013     /// @notice A record of states for signing / validating signatures
1014     mapping (address => uint) public nonces;
1015     
1016       /// @notice An event thats emitted when an account changes its delegate
1017     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1018 
1019     /// @notice An event thats emitted when a delegate account's vote balance changes
1020     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1021 
1022     // fallback() external payable {
1023     // }
1024 
1025     constructor(
1026         address _uniswapRouter, 
1027         address _uniswapFactory, 
1028         address _wethAddress
1029     ) public  {
1030         iUniswapV2Factory = IUniswapV2Factory(_uniswapFactory);
1031         iUniswapV2Router02 = IUniswapV2Router02(_uniswapRouter);
1032         iWeth = IWETH(_wethAddress);
1033         mint(msg.sender, 40000e18);
1034     }
1035 
1036     function createPair(address tokenA, address tokenB) public {
1037         iUniswapV2Factory.createPair(tokenA, tokenB);
1038     }
1039 
1040     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1041     function mint(address _to, uint256 _amount) public onlyOwner {
1042         _mint(_to, _amount);
1043         _moveDelegates(address(0), _delegates[_to], _amount);
1044     }
1045 
1046     /// @notice Burn `_amount` token to `_to`. 
1047     function burn(address _to, uint256 _amount) public onlyOwner {
1048         _burn(_to, _amount);
1049     }
1050 
1051     /**
1052      * @notice Delegate votes from `msg.sender` to `delegatee`
1053      * @param delegator The address to get delegatee for
1054      */
1055     function delegates(address delegator)
1056         external
1057         view
1058         returns (address)
1059     {
1060         return _delegates[delegator];
1061     }
1062 
1063    /**
1064     * @notice Delegate votes from `msg.sender` to `delegatee`
1065     * @param delegatee The address to delegate votes to
1066     */
1067     function delegate(address delegatee) external {
1068         return _delegate(msg.sender, delegatee);
1069     }
1070 
1071     /**
1072      * @notice Delegates votes from signatory to `delegatee`
1073      * @param delegatee The address to delegate votes to
1074      * @param nonce The contract state required to match the signature
1075      * @param expiry The time at which to expire the signature
1076      * @param v The recovery byte of the signature
1077      * @param r Half of the ECDSA signature pair
1078      * @param s Half of the ECDSA signature pair
1079      */
1080     function delegateBySig(
1081         address delegatee,
1082         uint nonce,
1083         uint expiry,
1084         uint8 v,
1085         bytes32 r,
1086         bytes32 s
1087     )
1088         external
1089     {
1090         bytes32 domainSeparator = keccak256(
1091             abi.encode(
1092                 DOMAIN_TYPEHASH,
1093                 keccak256(bytes(name())),
1094                 getChainId(),
1095                 address(this)
1096             )
1097         );
1098 
1099         bytes32 structHash = keccak256(
1100             abi.encode(
1101                 DELEGATION_TYPEHASH,
1102                 delegatee,
1103                 nonce,
1104                 expiry
1105             )
1106         );
1107 
1108         bytes32 digest = keccak256(
1109             abi.encodePacked(
1110                 "\x19\x01",
1111                 domainSeparator,
1112                 structHash
1113             )
1114         );
1115 
1116         address signatory = ecrecover(digest, v, r, s);
1117         require(signatory != address(0), "CHILL::delegateBySig: invalid signature");
1118         require(nonce == nonces[signatory]++, "CHILL::delegateBySig: invalid nonce");
1119         require(now <= expiry, "CHILL::delegateBySig: signature expired");
1120         return _delegate(signatory, delegatee);
1121     }
1122 
1123     /**
1124      * @notice Gets the current votes balance for `account`
1125      * @param account The address to get votes balance
1126      * @return The number of current votes for `account`
1127      */
1128     function getCurrentVotes(address account)
1129         external
1130         view
1131         returns (uint256)
1132     {
1133         uint32 nCheckpoints = numCheckpoints[account];
1134         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1135     }
1136 
1137     /**
1138      * @notice Determine the prior number of votes for an account as of a block number
1139      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1140      * @param account The address of the account to check
1141      * @param blockNumber The block number to get the vote balance at
1142      * @return The number of votes the account had as of the given block
1143      */
1144     function getPriorVotes(address account, uint blockNumber)
1145         external
1146         view
1147         returns (uint256)
1148     {
1149         require(blockNumber < block.number, "CHILL::getPriorVotes: not yet determined");
1150 
1151         uint32 nCheckpoints = numCheckpoints[account];
1152         if (nCheckpoints == 0) {
1153             return 0;
1154         }
1155 
1156         // First check most recent balance
1157         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1158             return checkpoints[account][nCheckpoints - 1].votes;
1159         }
1160 
1161         // Next check implicit zero balance
1162         if (checkpoints[account][0].fromBlock > blockNumber) {
1163             return 0;
1164         }
1165 
1166         uint32 lower = 0;
1167         uint32 upper = nCheckpoints - 1;
1168         while (upper > lower) {
1169             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1170             Checkpoint memory cp = checkpoints[account][center];
1171             if (cp.fromBlock == blockNumber) {
1172                 return cp.votes;
1173             } else if (cp.fromBlock < blockNumber) {
1174                 lower = center;
1175             } else {
1176                 upper = center - 1;
1177             }
1178         }
1179         return checkpoints[account][lower].votes;
1180     }
1181 
1182     function _delegate(address delegator, address delegatee)
1183         internal
1184     {
1185         address currentDelegate = _delegates[delegator];
1186         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying CHILLs (not scaled);
1187         _delegates[delegator] = delegatee;
1188 
1189         emit DelegateChanged(delegator, currentDelegate, delegatee);
1190 
1191         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1192     }
1193 
1194     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1195         if (srcRep != dstRep && amount > 0) {
1196             if (srcRep != address(0)) {
1197                 // decrease old representative
1198                 uint32 srcRepNum = numCheckpoints[srcRep];
1199                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1200                 uint256 srcRepNew = srcRepOld.sub(amount);
1201                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1202             }
1203 
1204             if (dstRep != address(0)) {
1205                 // increase new representative
1206                 uint32 dstRepNum = numCheckpoints[dstRep];
1207                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1208                 uint256 dstRepNew = dstRepOld.add(amount);
1209                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1210             }
1211         }
1212     }
1213 
1214     function _writeCheckpoint(
1215         address delegatee,
1216         uint32 nCheckpoints,
1217         uint256 oldVotes,
1218         uint256 newVotes
1219     )
1220         internal
1221     {
1222         uint32 blockNumber = safe32(block.number, "CHILL::_writeCheckpoint: block number exceeds 32 bits");
1223 
1224         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1225             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1226         } else {
1227             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1228             numCheckpoints[delegatee] = nCheckpoints + 1;
1229         }
1230 
1231         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1232     }
1233 
1234     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1235         require(n < 2**32, errorMessage);
1236         return uint32(n);
1237     }
1238 
1239     function getChainId() internal pure returns (uint) {
1240         uint256 chainId;
1241         assembly { chainId := chainid() }
1242         return chainId;
1243     }
1244 }
1245 
1246 interface IUniswapV2Pair {
1247     event Approval(address indexed owner, address indexed spender, uint value);
1248     event Transfer(address indexed from, address indexed to, uint value);
1249 
1250     function name() external pure returns (string memory);
1251     function symbol() external pure returns (string memory);
1252     function decimals() external pure returns (uint8);
1253     function totalSupply() external view returns (uint);
1254     function balanceOf(address owner) external view returns (uint);
1255     function allowance(address owner, address spender) external view returns (uint);
1256 
1257     function approve(address spender, uint value) external returns (bool);
1258     function transfer(address to, uint value) external returns (bool);
1259     function transferFrom(address from, address to, uint value) external returns (bool);
1260 
1261     function DOMAIN_SEPARATOR() external view returns (bytes32);
1262     function PERMIT_TYPEHASH() external pure returns (bytes32);
1263     function nonces(address owner) external view returns (uint);
1264 
1265     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1266 
1267     event Mint(address indexed sender, uint amount0, uint amount1);
1268     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1269     event Swap(
1270         address indexed sender,
1271         uint amount0In,
1272         uint amount1In,
1273         uint amount0Out,
1274         uint amount1Out,
1275         address indexed to
1276     );
1277     event Sync(uint112 reserve0, uint112 reserve1);
1278 
1279     function MINIMUM_LIQUIDITY() external pure returns (uint);
1280     function factory() external view returns (address);
1281     function token0() external view returns (address);
1282     function token1() external view returns (address);
1283     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1284     function price0CumulativeLast() external view returns (uint);
1285     function price1CumulativeLast() external view returns (uint);
1286     function kLast() external view returns (uint);
1287 
1288     function mint(address to) external returns (uint liquidity);
1289     function burn(address to) external returns (uint amount0, uint amount1);
1290     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1291     function skim(address to) external;
1292     function sync() external;
1293 
1294     function initialize(address, address) external;
1295 }
1296 
1297 library UniswapV2Library {
1298     using SafeMath for uint;
1299 
1300     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1301     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1302         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1303         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1304         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1305     }
1306 
1307     // calculates the CREATE2 address for a pair without making any external calls
1308     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1309         (address token0, address token1) = sortTokens(tokenA, tokenB);
1310         pair = address(uint(keccak256(abi.encodePacked(
1311                 hex'ff',
1312                 factory,
1313                 keccak256(abi.encodePacked(token0, token1)),
1314                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1315             ))));
1316     }
1317 
1318     // fetches and sorts the reserves for a pair
1319     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1320         (address token0,) = sortTokens(tokenA, tokenB);
1321         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1322         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1323     }
1324 
1325     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1326     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1327         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1328         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1329         amountB = amountA.mul(reserveB) / reserveA;
1330     }
1331 
1332     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
1333     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
1334         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
1335         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1336         uint amountInWithFee = amountIn.mul(997);
1337         uint numerator = amountInWithFee.mul(reserveOut);
1338         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
1339         amountOut = numerator / denominator;
1340     }
1341 
1342     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
1343     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
1344         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
1345         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1346         uint numerator = reserveIn.mul(amountOut).mul(1000);
1347         uint denominator = reserveOut.sub(amountOut).mul(997);
1348         amountIn = (numerator / denominator).add(1);
1349     }
1350 
1351     // performs chained getAmountOut calculations on any number of pairs
1352     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
1353         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1354         amounts = new uint[](path.length);
1355         amounts[0] = amountIn;
1356         for (uint i; i < path.length - 1; i++) {
1357             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
1358             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
1359         }
1360     }
1361 
1362     // performs chained getAmountIn calculations on any number of pairs
1363     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
1364         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1365         amounts = new uint[](path.length);
1366         amounts[amounts.length - 1] = amountOut;
1367         for (uint i = path.length - 1; i > 0; i--) {
1368             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
1369             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
1370         }
1371     }
1372 }
1373 
1374 interface IUniStakingRewards {
1375     function stake(uint256 amount) external;
1376     function withdraw(uint256 amount) external;
1377     function getReward() external;
1378     function exit() external;
1379     function balanceOf(address account) external view returns (uint256);
1380 }
1381 
1382 library PairValue {
1383     using SafeMath for uint;
1384     using SafeERC20 for IERC20;
1385 
1386     function countEthAmount(address _countPair, uint256 _liquiditybalance) internal view returns(uint256) {
1387         address countToken0 = IUniswapV2Pair(_countPair).token0();
1388         (uint112 countReserves0, uint112 countReserves1, ) = IUniswapV2Pair(_countPair).getReserves();
1389         uint256 countTotalSupply = IERC20(_countPair).totalSupply();
1390         uint256 ethAmount;
1391         uint256 tokenbalance;
1392 
1393         if(countTotalSupply > 0) {
1394             if(countToken0 != 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2) {
1395                 tokenbalance = _liquiditybalance.mul(countReserves0).div(countTotalSupply);
1396                 ethAmount = UniswapV2Library.getAmountOut(tokenbalance, countReserves0, countReserves1);
1397             } else {
1398                 tokenbalance = _liquiditybalance.mul(countReserves1).div(countTotalSupply);
1399                 ethAmount = UniswapV2Library.getAmountOut(tokenbalance, countReserves1, countReserves0);
1400             }
1401         } else {
1402             return 0;
1403         }
1404         return countUsdtAmount(ethAmount);
1405     }
1406 
1407     function countUsdtAmount(uint256 ethAmount) internal view returns(uint256) {
1408         address _stablePair = 0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852;
1409         address usdttoken0 = IUniswapV2Pair(_stablePair).token0();
1410         (uint112 stableReserves0, uint112 stableReserves1, ) = IUniswapV2Pair(_stablePair).getReserves();
1411 
1412         uint256 stableOutAmount;
1413         if (usdttoken0 == 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2) { // WETH Mainnet
1414             stableOutAmount = UniswapV2Library.getAmountOut(1e18, stableReserves0, stableReserves1);
1415         } else {
1416             stableOutAmount = UniswapV2Library.getAmountOut(1e18, stableReserves1, stableReserves0);
1417         }
1418         uint256 totalAmount = ((ethAmount.div(1e18)).mul(stableOutAmount.div(1e6))).mul(2);
1419         return totalAmount;
1420     }
1421 }
1422 
1423 interface IMigratorChef {
1424     function migrate(IERC20 token) external returns (IERC20);
1425 }
1426 
1427 contract ChillFinance is Ownable {
1428     
1429     using SafeMath for uint256;
1430     using SafeERC20 for IERC20;
1431 
1432     struct UserInfo {
1433         uint256 amount;
1434         uint256 rewardDebt;
1435         uint256 startedBlock;
1436     }
1437     
1438     struct PoolInfo {
1439         IERC20 lpToken;
1440         uint256 allocPoint;
1441         uint256 lastRewardBlock;
1442         uint256 accChillPerShare;
1443         uint256 totalPoolBalance;
1444         address nirvanaRewardAddress;
1445         uint256 nirvanaFee;
1446     }
1447 
1448     ChillToken public chill;
1449     address public devaddr;
1450     uint256 public DEV_FEE = 0;
1451     uint256 public DEV_TAX_FEE = 20;
1452     PoolInfo[] public poolInfo;
1453     uint256 public bonusEndBlock;
1454     uint256 public constant BONUS_MULTIPLIER = 10;
1455     uint256 public totalAllocPoint = 0;
1456     uint256 public startBlockOfChill;
1457     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1458     mapping (uint256 => address[]) public poolUsers;
1459     mapping (uint256 => mapping(address => bool)) public isUserExist;
1460     mapping (address => bool) public stakingUniPools;
1461     mapping (address => address) public uniRewardAddresses;
1462     mapping (uint256 => bool) public isCheckInitialPeriod;
1463     mapping (address => bool) private distributors;
1464     IMigratorChef public migrator;
1465 
1466     uint256 initialPeriod;
1467     uint256 public initialAmt = 20000;
1468     uint256[] public blockPerPhase;
1469     uint256[] public blockMilestone;
1470 
1471     uint256 public phase1time;
1472     uint256 public phase2time;
1473     uint256 public phase3time;
1474     uint256 public phase4time;
1475     uint256 public phase5time;
1476 
1477     uint256 burnFlag = 0;
1478     uint256 lastBurnedPhase1 = 0;
1479     uint256 lastBurnedPhase2 = 0;
1480     uint256 lastTimeOfBurn;
1481     uint256 totalBurnedAmount;
1482 
1483     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1484     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1485     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1486 
1487     modifier isDistributor(address _isDistributor) {
1488         require(distributors[_isDistributor]);
1489         _;
1490     }
1491 
1492     constructor(
1493         ChillToken _chill,
1494         address _devaddr, 
1495         uint256 _startBlockOfChill
1496     ) public {
1497         chill = _chill;
1498         devaddr = _devaddr;
1499         
1500         startBlockOfChill = block.number.add(_startBlockOfChill);
1501         bonusEndBlock = block.number;
1502         initialPeriod = block.number.add(99999); 
1503         
1504         blockPerPhase.push(75e18);
1505         blockPerPhase.push(100e18);
1506         blockPerPhase.push(50e18);
1507         blockPerPhase.push(25e18);
1508         blockPerPhase.push(0);
1509 
1510         blockMilestone.push(2201); // 2201
1511         blockMilestone.push(4401); // 4401
1512         blockMilestone.push(6600); // 6600
1513         blockMilestone.push(8798); // 8798
1514         blockMilestone.push(10997); // 10997
1515 
1516         phase1time = block.number.add(92338); // 14 days (14*24*60*60)/15 92338
1517         phase2time = block.number.add(290201); // 44 - 14 = 30 days (44*24*60*60)/15 290201
1518         phase3time = block.number.add(488069); // 74 - 44 = 30 days (74*24*60*60)/15 488069
1519         phase4time = block.number.add(883804); // 134 - 74 = 60 days (134*24*60*60)/15 883804
1520         phase5time = block.number.add(0); // 134 - 74 = 60 days (134*24*60*60)/15
1521         lastTimeOfBurn = block.timestamp.add(1 days);
1522     }
1523 
1524     function poolLength() external view returns (uint256) {
1525         return poolInfo.length;
1526     }
1527     
1528     function userPoollength(uint256 _pid) external view returns (uint256) {
1529         return poolUsers[_pid].length;
1530     }
1531 
1532     // get a participant users in a specific pool
1533     function getPoolUsers(uint256 _pid) public view returns(address[] memory) {
1534         return poolUsers[_pid];
1535     }
1536 
1537     // Add Function to give support new uniswap lp pool by only owner
1538     // for allocpoint will be 100 and if you want to generate more chill for specific pool then you need to increase allocpoint
1539     // like for, 1x=>100, 2x=>200, 3x=>300 etc.
1540     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1541         if (_withUpdate) {
1542             massUpdatePools();
1543         }
1544         uint256 _lastRewardBlock = block.number > startBlockOfChill ? block.number : startBlockOfChill;
1545         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1546         poolInfo.push(PoolInfo({
1547             lpToken: _lpToken,
1548             allocPoint: _allocPoint,
1549             lastRewardBlock: _lastRewardBlock,
1550             accChillPerShare: 0,
1551             totalPoolBalance: 0,
1552             nirvanaRewardAddress: address(0),
1553             nirvanaFee: 0
1554         }));
1555     }
1556     
1557     // increase alloc point for specific pool
1558     function set(uint256 _pid, uint256 _allocPoint, uint256 _nirvanaFee, address _nirvanaRewardAddress, bool _withUpdate) public onlyOwner {
1559         if (_withUpdate) {
1560             massUpdatePools();
1561         }
1562         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1563         poolInfo[_pid].allocPoint = _allocPoint;
1564         poolInfo[_pid].nirvanaRewardAddress = _nirvanaRewardAddress;
1565         poolInfo[_pid].nirvanaFee = _nirvanaFee;
1566     }
1567     
1568     // Set the migrator contract. Can only be called by the owner.
1569     function setMigrator(address _migrator) public onlyOwner {
1570         migrator = IMigratorChef(_migrator);
1571     }
1572 
1573     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1574     function migrate(uint256 _pid) public {
1575         require(address(migrator) != address(0), "migrate: no migrator");
1576         PoolInfo storage pool = poolInfo[_pid];
1577         IERC20 lpToken = pool.lpToken;
1578         uint256 bal = lpToken.balanceOf(address(this));
1579         lpToken.safeApprove(address(migrator), bal);
1580         IERC20 newLpToken = migrator.migrate(lpToken);
1581         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1582         pool.lpToken = newLpToken;
1583     }
1584     
1585     function massUpdatePools() public {
1586         uint256 length = poolInfo.length;
1587         for (uint256 pid = 0; pid < length; ++pid) {
1588             updatePool(pid);
1589         }
1590     }
1591     
1592     // user can deposit lp for specific pool
1593     function deposit(uint256 _pid, uint256 _amount) public {
1594         PoolInfo storage pool = poolInfo[_pid];
1595         UserInfo storage user = userInfo[_pid][msg.sender];
1596 
1597         if (isCheckInitialPeriod[_pid]) {
1598             if (block.number <= initialPeriod) {
1599                 // calculate id lp token amount less than $20000 and only applicable to eth pair
1600                 require(PairValue.countEthAmount(address(pool.lpToken), _amount) <= initialAmt, "Amount must be less than or equal to 20000 dollars.");
1601             } else {
1602                 isCheckInitialPeriod[_pid] = false;
1603             }
1604         }
1605         
1606         if (user.startedBlock <= 0) {
1607             user.startedBlock = block.number;
1608         }
1609         
1610         updatePool(_pid);
1611         if (user.amount > 0) {
1612             userRewardAndTaxes(pool, user);
1613         }
1614 
1615         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1616         pool.totalPoolBalance = pool.totalPoolBalance.add(_amount);
1617         user.amount = user.amount.add(_amount);
1618         user.rewardDebt = user.amount.mul(pool.accChillPerShare).div(1e12);
1619         user.startedBlock = block.number;
1620 
1621         if (stakingUniPools[address(pool.lpToken)] && _amount > 0) {
1622             stakeInUni(_amount, address(pool.lpToken), uniRewardAddresses[address(pool.lpToken)]);
1623         }
1624 
1625         if (!isUserExist[_pid][msg.sender]) {
1626             isUserExist[_pid][msg.sender] = true;
1627             poolUsers[_pid].push(msg.sender);
1628         }
1629         emit Deposit(msg.sender, _pid, _amount);
1630     }
1631     
1632     // it will be call if spicific pool uniswap uni pool supported in chill finance
1633     // and if you want to support uniswap pool then you need to add in addStakeUniPool
1634     function stakeInUni(uint256 amount, address v2address, address _stakeAddress) private {
1635         IERC20(v2address).approve(address(_stakeAddress), amount);
1636         IUniStakingRewards(_stakeAddress).stake(amount);
1637     }
1638 
1639     // user can withdraw their lp token from specific pool 
1640     function withdraw(uint256 _pid, uint256 _amount) public {
1641         PoolInfo storage pool = poolInfo[_pid];
1642         UserInfo storage user = userInfo[_pid][msg.sender];
1643         require(user.amount >= _amount, "withdraw is not valid");
1644         
1645         if (user.startedBlock <= 0) {
1646             user.startedBlock = block.number;
1647         }
1648         
1649         if (stakingUniPools[address(pool.lpToken)]  && _amount > 0) {
1650             withdrawUni(uniRewardAddresses[address(pool.lpToken)], _amount);
1651         }
1652 
1653         updatePool(_pid);
1654         userRewardAndTaxes(pool, user);
1655 
1656         user.amount = user.amount.sub(_amount);
1657         user.rewardDebt = user.amount.mul(pool.accChillPerShare).div(1e12);
1658         user.startedBlock = block.number;
1659         pool.totalPoolBalance = pool.totalPoolBalance.sub(_amount);
1660         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1661         emit Withdraw(msg.sender, _pid, _amount);
1662     }
1663 
1664     // withdraw lp token from uniswap uni farm pool  
1665     function withdrawUni(address _stakeAddress, uint256 _amount) private {
1666         IUniStakingRewards(_stakeAddress).withdraw(_amount);
1667     }
1668     
1669     // Reward will genrate in update pool function and call will be happen internally by deposit and withdraw function
1670     function updatePool(uint256 _pid) public {
1671         PoolInfo storage pool = poolInfo[_pid];
1672 
1673         if (block.number <= pool.lastRewardBlock) {
1674             return;
1675         }
1676 
1677         if (pool.totalPoolBalance == 0) {
1678             pool.lastRewardBlock = block.number;
1679             return;
1680         }
1681         
1682         uint256 chillReward;
1683         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1684         if (block.number <= phase1time) {
1685             chillReward = multiplier.mul(blockPerPhase[0]).mul(pool.allocPoint).div(totalAllocPoint);
1686         } else if (block.number <= phase2time) {
1687             chillReward = multiplier.mul(blockPerPhase[1]).mul(pool.allocPoint).div(totalAllocPoint);
1688         } else if (block.number <= phase3time) {
1689             chillReward = multiplier.mul(blockPerPhase[2]).mul(pool.allocPoint).div(totalAllocPoint);
1690         } else if (block.number <= phase4time) {
1691             chillReward = multiplier.mul(blockPerPhase[3]).mul(pool.allocPoint).div(totalAllocPoint);
1692         } else {
1693             chillReward = multiplier.mul(blockPerPhase[4]).mul(pool.allocPoint).div(totalAllocPoint);
1694         }
1695         
1696         if (chillReward > 0) {
1697             if (DEV_FEE > 0) {
1698                 chill.mint(devaddr, chillReward.mul(DEV_FEE).div(100));
1699             }
1700             chill.mint(address(this), chillReward);
1701         }
1702         pool.accChillPerShare = pool.accChillPerShare.add(chillReward.mul(1e12).div(pool.totalPoolBalance));
1703         pool.lastRewardBlock = block.number;
1704     }
1705     
1706     // User's extra reward and taxes will be handle in this internal funation
1707     function userRewardAndTaxes(PoolInfo storage pool, UserInfo storage user) internal {
1708         uint256 pending =  user.amount.mul(pool.accChillPerShare).div(1e12).sub(user.rewardDebt);
1709         uint256 tax = deductTaxByBlock(getCrossMultiplier(user.startedBlock, block.number));
1710         if (tax > 0) {
1711             uint256 pendingTax = pending.mul(tax).div(100);
1712             uint256 devReward = pendingTax.mul(DEV_TAX_FEE).div(100);
1713             safeChillTransfer(devaddr, devReward);
1714             if (pool.nirvanaFee > 0) {
1715                 uint256 nirvanaReward = pendingTax.mul(pool.nirvanaFee).div(100);
1716                 safeChillTransfer(pool.nirvanaRewardAddress, nirvanaReward);
1717                 safeChillTransfer(msg.sender, pending.sub(devReward).sub(nirvanaReward));
1718                 chill.burn(msg.sender, pendingTax.sub(devReward).sub(nirvanaReward));
1719                 lastDayBurned(pendingTax.sub(devReward).sub(nirvanaReward));
1720             } else {
1721                 safeChillTransfer(msg.sender, pending.sub(devReward));
1722                 chill.burn(msg.sender, pendingTax.sub(devReward));
1723                 lastDayBurned(pendingTax.sub(devReward));
1724             }
1725         } else {
1726             safeChillTransfer(msg.sender, pending);
1727             lastDayBurned(0);
1728         }
1729     }
1730     
1731     function lastDayBurned(uint256 burnedAmount) internal {
1732         if (block.timestamp >= lastTimeOfBurn) {
1733             if (burnFlag == 0) {
1734                 burnFlag = 1;
1735                 lastBurnedPhase1 = 0;
1736             } else {
1737                 burnFlag = 0;
1738                 lastBurnedPhase2 = 0;
1739             }
1740             lastTimeOfBurn = block.timestamp.add(1 days);
1741         }
1742         totalBurnedAmount = totalBurnedAmount.add(burnedAmount);
1743         if (burnFlag == 0) {
1744             lastBurnedPhase2 = lastBurnedPhase2.add(burnedAmount);
1745             // return lastBurnedPhase1;
1746         } else {
1747             lastBurnedPhase1 = lastBurnedPhase1.add(burnedAmount);
1748             // return lastBurnedPhase2;
1749         }
1750     }
1751     
1752     function getBurnedDetails() public view returns (uint256, uint256, uint256, uint256) {
1753         return (burnFlag, lastBurnedPhase1, lastBurnedPhase2, totalBurnedAmount);
1754     }
1755 
1756     // For user interface to claimable token
1757     function pendingChill(uint256 _pid, address _user) external view returns (uint256) {
1758         PoolInfo storage pool = poolInfo[_pid];
1759         UserInfo storage user = userInfo[_pid][_user];
1760         uint256 pending;
1761         uint256 accChillPerShare = pool.accChillPerShare;
1762         uint256 lpSupply = pool.totalPoolBalance;
1763         if (lpSupply != 0) {
1764             uint256 chillReward;
1765             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1766             if (block.number <= phase1time) {
1767                 chillReward = multiplier.mul(blockPerPhase[0]).mul(pool.allocPoint).div(totalAllocPoint);
1768             } else if (block.number <= phase2time) {
1769                 chillReward = multiplier.mul(blockPerPhase[1]).mul(pool.allocPoint).div(totalAllocPoint);
1770             } else if (block.number <= phase3time) {
1771                 chillReward = multiplier.mul(blockPerPhase[2]).mul(pool.allocPoint).div(totalAllocPoint);
1772             } else if (block.number <= phase4time) {
1773                 chillReward = multiplier.mul(blockPerPhase[3]).mul(pool.allocPoint).div(totalAllocPoint);
1774             } else {
1775                 chillReward = multiplier.mul(blockPerPhase[4]).mul(pool.allocPoint).div(totalAllocPoint);
1776             }
1777             accChillPerShare = accChillPerShare.add(chillReward.mul(1e12).div(pool.totalPoolBalance));
1778             pending =  user.amount.mul(accChillPerShare).div(1e12).sub(user.rewardDebt);
1779             uint256 tax = deductTaxByBlock(getCrossMultiplier(user.startedBlock, block.number));
1780             if (tax > 0) {
1781                 uint256 pendingTax = pending.mul(tax).div(100);
1782                 pending = pending.sub(pendingTax);
1783             }
1784         }
1785         return pending;
1786     }
1787 
1788     // Return reward multiplier over the given _from to _to block.
1789     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1790         if (_to <= bonusEndBlock) {
1791             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1792         } else if (_from >= bonusEndBlock) {
1793             return _to.sub(_from);
1794         } else {
1795             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1796                 _to.sub(bonusEndBlock)
1797             );
1798         }
1799     }
1800 
1801     // Return reward multiplier over the given _from to _to block.
1802     function getCrossMultiplier(uint256 _from, uint256 currentblock) public view returns (uint256) {
1803         uint256 multiplier;
1804         if (currentblock > _from) {
1805             multiplier = currentblock.sub(_from);
1806         } else {
1807             multiplier = _from.sub(currentblock);
1808         }
1809         return multiplier;
1810     }
1811     
1812     // get if nirvana
1813     function getNirvanaStatus(uint256 _from) public view returns (uint256) {
1814         uint256 multiplier = getCrossMultiplier(_from, block.number);
1815         uint256 isNirvana = getTotalBlocksCovered(multiplier);
1816         return isNirvana;
1817     }
1818     
1819     // Set extra reward after each 8 hours(1920 block)
1820     function getTotalBlocksCovered(uint256 _block) internal view returns(uint256) {
1821         if (_block >= blockMilestone[4]) { // 9600
1822             return 50;
1823         } else if (_block >= blockMilestone[3]) { // 7680
1824             return 40;
1825         } else if (_block >= blockMilestone[2]) { // 5760
1826             return 30;
1827         } else if (_block >= blockMilestone[1]) { // 3840
1828             return 20;
1829         } else if (_block >= blockMilestone[0]) { // 1920
1830             return 10;
1831         } else {
1832             return 0;
1833         }
1834     }
1835     
1836     // Deduct tax if user withdraw before nirvana at different stage
1837     function deductTaxByBlock(uint256 _block) internal view returns(uint256) {
1838         if (_block <= blockMilestone[0]) { // 1920
1839             return 50;
1840         } else if (_block <= blockMilestone[1]) { // 3840
1841             return 40;
1842         } else if (_block <= blockMilestone[2]) { // 5760
1843             return 30;
1844         } else if (_block <= blockMilestone[3]) { // 7680
1845             return 20;
1846         } else if (_block <= blockMilestone[4]) { // 9600
1847             return 10;
1848         }  else {
1849             return 0;
1850         }
1851     }
1852 
1853     // Safe chill transfer function, just in case if rounding error causes pool to not have enough CHILLs.
1854     function safeChillTransfer(address _to, uint256 _amount) internal {
1855         uint256 chillBal = chill.balanceOf(address(this));
1856         if (_amount > chillBal) {
1857             chill.transfer(_to, chillBal);
1858         } else {
1859             chill.transfer(_to, _amount);
1860         }
1861     }
1862     
1863     // if specific lp pool is supported in uniswap uni pool the deposited lp token in chill finance will again deposit in uni pool and earn double reward in uni token
1864     // and owner can withdraw extra reward from uni pool
1865     function getUniReward(address _stakeAddress) public onlyOwner {
1866         IUniStakingRewards(_stakeAddress).getReward();
1867     }
1868     
1869     // extra uni reward only access by distributor
1870     // distributor can be single user or any other contracts as well 
1871     function accessReward(address _uniAddress, address _to, uint256 _amount) public isDistributor(msg.sender) {
1872         require(_amount <= IERC20(_uniAddress).balanceOf(address(this)), "Not Enough Uni Token Balance");
1873         require(_to != address(0), "Not Vaild Address");
1874         IERC20(_uniAddress).safeTransfer(_to, _amount);
1875     }
1876     
1877     // withdraw extra uni reward and lp token as well from uni pool
1878     // function getUniRewardAndExit(address _stakeAddress) public onlyOwner {
1879     //     IUniStakingRewards(_stakeAddress).exit();
1880     // }
1881     
1882     // to give support to specific pool to deposit again in uni pool to generate extra reward in uni token 
1883     function addStakeUniPool(address _uniV2Pool, address _stakingRewardAddress) public onlyOwner {
1884         require(!stakingUniPools[_uniV2Pool], "This pool is already exist.");
1885         uint256 _amount = IERC20(_uniV2Pool).balanceOf(address(this));
1886         if(_amount > 0) {
1887             stakeInUni(_amount, address(_uniV2Pool), address(_stakingRewardAddress));
1888         }
1889         stakingUniPools[_uniV2Pool] = true;
1890         uniRewardAddresses[_uniV2Pool] = _stakingRewardAddress;
1891     }
1892 
1893     // to remove support of uni pool for specific pool
1894     function removeStakeUniPool(address _uniV2Pool) public onlyOwner {
1895         require(stakingUniPools[_uniV2Pool], "This pool is not exist.");
1896         uint256 _amount = IUniStakingRewards(uniRewardAddresses[address(_uniV2Pool)]).balanceOf(address(this));
1897         if (_amount > 0) {
1898             IUniStakingRewards(uniRewardAddresses[address(_uniV2Pool)]).withdraw(_amount);
1899         }
1900         stakingUniPools[_uniV2Pool] = false;
1901         uniRewardAddresses[_uniV2Pool] = address(0);
1902     }
1903     
1904     // dev adderess can only change by dev
1905     function dev(address _devaddr, uint256 _devFee, uint256 _devTaxFee) public {
1906         require(msg.sender == devaddr, "dev adddress is not valid");
1907         devaddr = _devaddr;
1908         DEV_FEE = _devFee;
1909         DEV_TAX_FEE = _devTaxFee;
1910     }
1911 
1912     // to set flag for count $20000 worth asset for specific pool
1913     function setCheckInitialPeriodAndAmount(uint256 _pid, bool _isCheck, uint256 _amount) public onlyOwner {
1914         isCheckInitialPeriod[_pid] = _isCheck;
1915         initialAmt = _amount;
1916     }
1917 
1918     // set block milestone
1919     function setBlockMilestoneByIndex(uint256 _index, uint256 _blockMilestone) public onlyOwner {
1920         blockMilestone[_index] = _blockMilestone;
1921     }
1922 
1923     // increase any phase time and chill per block by its index
1924     function setAndEditPhaseTime(uint256 _index, uint256 _time, uint256 _chillPerBlock) public onlyOwner {
1925         blockPerPhase[_index] = _chillPerBlock;
1926         if(_index == 0) {
1927             phase1time = phase1time.add(_time);
1928         } else if(_index == 1) {
1929             phase2time = phase2time.add(_time);
1930         } else if(_index == 2) {
1931             phase3time = phase3time.add(_time);
1932         } else if(_index == 3) {
1933             phase4time = phase4time.add(_time);
1934         } else if(_index == 4) {
1935             phase5time = phase5time.add(_time);
1936         }
1937     }
1938 
1939     // get current phase with its chill per block
1940     function getPhaseTimeAndBlocks() public view returns(uint256, uint256) {
1941         if (block.number <= phase1time) {
1942             return ( phase1time, blockPerPhase[0] );
1943         } else if (block.number <= phase2time) {
1944             return ( phase2time, blockPerPhase[1] );
1945         } else if (block.number <= phase3time) {
1946             return ( phase3time, blockPerPhase[2] );
1947         } else if (block.number <= phase4time) {
1948             return ( phase4time, blockPerPhase[3] );
1949         } else {
1950             return ( phase5time, blockPerPhase[4] );
1951         }
1952     }
1953 
1954     // to set reward distibutor for extra uni token
1955     function setRewardDistributor(address _distributor, bool _isdistributor) public onlyOwner {
1956         distributors[_distributor] = _isdistributor;
1957     }
1958 }