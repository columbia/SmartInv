1 pragma solidity ^0.6.12;
2 /*
3  * @dev Provides information about the current execution context, including the
4  * sender of the transaction and its data. While these are generally available
5  * via msg.sender and msg.data, they should not be accessed in such a direct
6  * manner, since when dealing with GSN meta-transactions the account sending and
7  * paying for execution may not be the actual sender (as far as an application
8  * is concerned).
9  *
10  * This contract is only required for intermediate, library-like contracts.
11  */
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address payable) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes memory) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 /**
24  * @dev Interface of the ERC20 standard as defined in the EIP.
25  */
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 /**
98  * @dev Wrappers over Solidity's arithmetic operations with added overflow
99  * checks.
100  *
101  * Arithmetic operations in Solidity wrap on overflow. This can easily result
102  * in bugs, because programmers usually assume that an overflow raises an
103  * error, which is the standard behavior in high level programming languages.
104  * `SafeMath` restores this intuition by reverting the transaction when an
105  * operation overflows.
106  *
107  * Using this library instead of the unchecked operations eliminates an entire
108  * class of bugs, so it's recommended to use it always.
109  */
110 library SafeMath {
111     /**
112      * @dev Returns the addition of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `+` operator.
116      *
117      * Requirements:
118      *
119      * - Addition cannot overflow.
120      */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a, "SafeMath: addition overflow");
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         return sub(a, b, "SafeMath: subtraction overflow");
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b <= a, errorMessage);
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the multiplication of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `*` operator.
164      *
165      * Requirements:
166      *
167      * - Multiplication cannot overflow.
168      */
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
171         // benefit is lost if 'b' is also tested.
172         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
173         if (a == 0) {
174             return 0;
175         }
176 
177         uint256 c = a * b;
178         require(c / a == b, "SafeMath: multiplication overflow");
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         return div(a, b, "SafeMath: division by zero");
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         uint256 c = a / b;
214         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return mod(a, b, "SafeMath: modulo by zero");
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts with custom message when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b != 0, errorMessage);
249         return a % b;
250     }
251 }
252 
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
277         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
278         // for accounts without code, i.e. `keccak256('')`
279         bytes32 codehash;
280         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
281         // solhint-disable-next-line no-inline-assembly
282         assembly { codehash := extcodehash(account) }
283         return (codehash != accountHash && codehash != 0x0);
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
306         (bool success, ) = recipient.call{ value: amount }("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain`call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329       return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
339         return _functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         return _functionCallWithValue(target, data, value, errorMessage);
366     }
367 
368     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
369         require(isContract(target), "Address: call to non-contract");
370 
371         // solhint-disable-next-line avoid-low-level-calls
372         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
373         if (success) {
374             return returndata;
375         } else {
376             // Look for revert reason and bubble it up if present
377             if (returndata.length > 0) {
378                 // The easiest way to bubble the revert reason is using memory via assembly
379 
380                 // solhint-disable-next-line no-inline-assembly
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 }
391 
392 /**
393  * @title SafeERC20
394  * @dev Wrappers around ERC20 operations that throw on failure (when the token
395  * contract returns false). Tokens that return no value (and instead revert or
396  * throw on failure) are also supported, non-reverting calls are assumed to be
397  * successful.
398  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
399  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
400  */
401 library SafeERC20 {
402     using SafeMath for uint256;
403     using Address for address;
404 
405     function safeTransfer(IERC20 token, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
407     }
408 
409     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
411     }
412 
413     /**
414      * @dev Deprecated. This function has issues similar to the ones found in
415      * {IERC20-approve}, and its usage is discouraged.
416      *
417      * Whenever possible, use {safeIncreaseAllowance} and
418      * {safeDecreaseAllowance} instead.
419      */
420     function safeApprove(IERC20 token, address spender, uint256 value) internal {
421         // safeApprove should only be called when setting an initial allowance,
422         // or when resetting it to zero. To increase and decrease it, use
423         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
424         // solhint-disable-next-line max-line-length
425         require((value == 0) || (token.allowance(address(this), spender) == 0),
426             "SafeERC20: approve from non-zero to non-zero allowance"
427         );
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
429     }
430 
431     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
432         uint256 newAllowance = token.allowance(address(this), spender).add(value);
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
434     }
435 
436     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
437         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
439     }
440 
441     /**
442      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
443      * on the return value: the return value is optional (but if data is returned, it must not be false).
444      * @param token The token targeted by the call.
445      * @param data The call data (encoded using abi.encode or one of its variants).
446      */
447     function _callOptionalReturn(IERC20 token, bytes memory data) private {
448         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
449         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
450         // the target address contains contract code and also asserts for success in the low-level call.
451 
452         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
453         if (returndata.length > 0) { // Return data is optional
454             // solhint-disable-next-line max-line-length
455             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
456         }
457     }
458 }
459 
460 
461 
462 /**
463  * @dev Contract module which provides a basic access control mechanism, where
464  * there is an account (an owner) that can be granted exclusive access to
465  * specific functions.
466  *
467  * By default, the owner account will be the one that deploys the contract. This
468  * can later be changed with {transferOwnership}.
469  *
470  * This module is used through inheritance. It will make available the modifier
471  * `onlyOwner`, which can be applied to your functions to restrict their use to
472  * the owner.
473  */
474 contract Ownable is Context {
475     address private _owner;
476 
477     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
478 
479     /**
480      * @dev Initializes the contract setting the deployer as the initial owner.
481      */
482     constructor () internal {
483         address msgSender = _msgSender();
484         _owner = msgSender;
485         emit OwnershipTransferred(address(0), msgSender);
486     }
487 
488     /**
489      * @dev Returns the address of the current owner.
490      */
491     function owner() public view returns (address) {
492         return _owner;
493     }
494 
495     /**
496      * @dev Throws if called by any account other than the owner.
497      */
498     modifier onlyOwner() {
499         require(_owner == _msgSender(), "Ownable: caller is not the owner");
500         _;
501     }
502 
503     /**
504      * @dev Leaves the contract without owner. It will not be possible to call
505      * `onlyOwner` functions anymore. Can only be called by the current owner.
506      *
507      * NOTE: Renouncing ownership will leave the contract without an owner,
508      * thereby removing any functionality that is only available to the owner.
509      */
510     function renounceOwnership() public virtual onlyOwner {
511         emit OwnershipTransferred(_owner, address(0));
512         _owner = address(0);
513     }
514 
515     /**
516      * @dev Transfers ownership of the contract to a new account (`newOwner`).
517      * Can only be called by the current owner.
518      */
519     function transferOwnership(address newOwner) public virtual onlyOwner {
520         require(newOwner != address(0), "Ownable: new owner is the zero address");
521         emit OwnershipTransferred(_owner, newOwner);
522         _owner = newOwner;
523     }
524 }
525 
526 
527 /**
528  * @dev Implementation of the {IERC20} interface.
529  *
530  * This implementation is agnostic to the way tokens are created. This means
531  * that a supply mechanism has to be added in a derived contract using {_mint}.
532  * For a generic mechanism see {ERC20PresetMinterPauser}.
533  *
534  * TIP: For a detailed writeup see our guide
535  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
536  * to implement supply mechanisms].
537  *
538  * We have followed general OpenZeppelin guidelines: functions revert instead
539  * of returning `false` on failure. This behavior is nonetheless conventional
540  * and does not conflict with the expectations of ERC20 applications.
541  *
542  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
543  * This allows applications to reconstruct the allowance for all accounts just
544  * by listening to said events. Other implementations of the EIP may not emit
545  * these events, as it isn't required by the specification.
546  *
547  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
548  * functions have been added to mitigate the well-known issues around setting
549  * allowances. See {IERC20-approve}.
550  */
551 contract ERC20 is Context, IERC20 {
552     using SafeMath for uint256;
553     using Address for address;
554 
555     mapping (address => uint256) private _balances;
556 
557     mapping (address => mapping (address => uint256)) private _allowances;
558 
559     uint256 private _totalSupply;
560 
561     string private _name;
562     string private _symbol;
563     uint8 private _decimals;
564 
565     /**
566      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
567      * a default value of 18.
568      *
569      * To select a different value for {decimals}, use {_setupDecimals}.
570      *
571      * All three of these values are immutable: they can only be set once during
572      * construction.
573      */
574     constructor (string memory name, string memory symbol) public {
575         _name = name;
576         _symbol = symbol;
577         _decimals = 18;
578     }
579 
580     /**
581      * @dev Returns the name of the token.
582      */
583     function name() public view returns (string memory) {
584         return _name;
585     }
586 
587     /**
588      * @dev Returns the symbol of the token, usually a shorter version of the
589      * name.
590      */
591     function symbol() public view returns (string memory) {
592         return _symbol;
593     }
594 
595     /**
596      * @dev Returns the number of decimals used to get its user representation.
597      * For example, if `decimals` equals `2`, a balance of `505` tokens should
598      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
599      *
600      * Tokens usually opt for a value of 18, imitating the relationship between
601      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
602      * called.
603      *
604      * NOTE: This information is only used for _display_ purposes: it in
605      * no way affects any of the arithmetic of the contract, including
606      * {IERC20-balanceOf} and {IERC20-transfer}.
607      */
608     function decimals() public view returns (uint8) {
609         return _decimals;
610     }
611 
612     /**
613      * @dev See {IERC20-totalSupply}.
614      */
615     function totalSupply() public view override returns (uint256) {
616         return _totalSupply;
617     }
618 
619     /**
620      * @dev See {IERC20-balanceOf}.
621      */
622     function balanceOf(address account) public view override returns (uint256) {
623         return _balances[account];
624     }
625 
626     /**
627      * @dev See {IERC20-transfer}.
628      *
629      * Requirements:
630      *
631      * - `recipient` cannot be the zero address.
632      * - the caller must have a balance of at least `amount`.
633      */
634     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
635         _transfer(_msgSender(), recipient, amount);
636         return true;
637     }
638 
639     /**
640      * @dev See {IERC20-allowance}.
641      */
642     function allowance(address owner, address spender) public view virtual override returns (uint256) {
643         return _allowances[owner][spender];
644     }
645 
646     /**
647      * @dev See {IERC20-approve}.
648      *
649      * Requirements:
650      *
651      * - `spender` cannot be the zero address.
652      */
653     function approve(address spender, uint256 amount) public virtual override returns (bool) {
654         _approve(_msgSender(), spender, amount);
655         return true;
656     }
657 
658     /**
659      * @dev See {IERC20-transferFrom}.
660      *
661      * Emits an {Approval} event indicating the updated allowance. This is not
662      * required by the EIP. See the note at the beginning of {ERC20};
663      *
664      * Requirements:
665      * - `sender` and `recipient` cannot be the zero address.
666      * - `sender` must have a balance of at least `amount`.
667      * - the caller must have allowance for ``sender``'s tokens of at least
668      * `amount`.
669      */
670     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
671         _transfer(sender, recipient, amount);
672         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
673         return true;
674     }
675 
676     /**
677      * @dev Atomically increases the allowance granted to `spender` by the caller.
678      *
679      * This is an alternative to {approve} that can be used as a mitigation for
680      * problems described in {IERC20-approve}.
681      *
682      * Emits an {Approval} event indicating the updated allowance.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      */
688     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
689         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
690         return true;
691     }
692 
693     /**
694      * @dev Atomically decreases the allowance granted to `spender` by the caller.
695      *
696      * This is an alternative to {approve} that can be used as a mitigation for
697      * problems described in {IERC20-approve}.
698      *
699      * Emits an {Approval} event indicating the updated allowance.
700      *
701      * Requirements:
702      *
703      * - `spender` cannot be the zero address.
704      * - `spender` must have allowance for the caller of at least
705      * `subtractedValue`.
706      */
707     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
708         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
709         return true;
710     }
711 
712     /**
713      * @dev Moves tokens `amount` from `sender` to `recipient`.
714      *
715      * This is internal function is equivalent to {transfer}, and can be used to
716      * e.g. implement automatic token fees, slashing mechanisms, etc.
717      *
718      * Emits a {Transfer} event.
719      *
720      * Requirements:
721      *
722      * - `sender` cannot be the zero address.
723      * - `recipient` cannot be the zero address.
724      * - `sender` must have a balance of at least `amount`.
725      */
726     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
727         require(sender != address(0), "ERC20: transfer from the zero address");
728         require(recipient != address(0), "ERC20: transfer to the zero address");
729 
730         _beforeTokenTransfer(sender, recipient, amount);
731 
732         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
733         _balances[recipient] = _balances[recipient].add(amount);
734         emit Transfer(sender, recipient, amount);
735     }
736 
737     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
738      * the total supply.
739      *
740      * Emits a {Transfer} event with `from` set to the zero address.
741      *
742      * Requirements
743      *
744      * - `to` cannot be the zero address.
745      */
746     function _mint(address account, uint256 amount) internal virtual {
747         require(account != address(0), "ERC20: mint to the zero address");
748 
749         _beforeTokenTransfer(address(0), account, amount);
750 
751         _totalSupply = _totalSupply.add(amount);
752         _balances[account] = _balances[account].add(amount);
753         emit Transfer(address(0), account, amount);
754     }
755 
756     /**
757      * @dev Destroys `amount` tokens from `account`, reducing the
758      * total supply.
759      *
760      * Emits a {Transfer} event with `to` set to the zero address.
761      *
762      * Requirements
763      *
764      * - `account` cannot be the zero address.
765      * - `account` must have at least `amount` tokens.
766      */
767     function _burn(address account, uint256 amount) internal virtual {
768         require(account != address(0), "ERC20: burn from the zero address");
769 
770         _beforeTokenTransfer(account, address(0), amount);
771 
772         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
773         _totalSupply = _totalSupply.sub(amount);
774         emit Transfer(account, address(0), amount);
775     }
776 
777     /**
778      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
779      *
780      * This is internal function is equivalent to `approve`, and can be used to
781      * e.g. set automatic allowances for certain subsystems, etc.
782      *
783      * Emits an {Approval} event.
784      *
785      * Requirements:
786      *
787      * - `owner` cannot be the zero address.
788      * - `spender` cannot be the zero address.
789      */
790     function _approve(address owner, address spender, uint256 amount) internal virtual {
791         require(owner != address(0), "ERC20: approve from the zero address");
792         require(spender != address(0), "ERC20: approve to the zero address");
793 
794         _allowances[owner][spender] = amount;
795         emit Approval(owner, spender, amount);
796     }
797 
798     /**
799      * @dev Sets {decimals} to a value other than the default one of 18.
800      *
801      * WARNING: This function should only be called from the constructor. Most
802      * applications that interact with token contracts will not expect
803      * {decimals} to ever change, and may work incorrectly if it does.
804      */
805     function _setupDecimals(uint8 decimals_) internal {
806         _decimals = decimals_;
807     }
808 
809     /**
810      * @dev Hook that is called before any transfer of tokens. This includes
811      * minting and burning.
812      *
813      * Calling conditions:
814      *
815      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
816      * will be to transferred to `to`.
817      * - when `from` is zero, `amount` tokens will be minted for `to`.
818      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
819      * - `from` and `to` are never both zero.
820      *
821      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
822      */
823     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
824 }
825 
826 // GodKimchiToken with Governance.
827 contract GodKimchiToken is ERC20("GOD KIMCHI", "gKIMCHI"), Ownable {
828     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
829     function mint(address _to, uint256 _amount) public onlyOwner {
830         _mint(_to, _amount);
831     }
832 }
833 
834 contract GodKimchiChef is Ownable {
835     using SafeMath for uint256;
836     using SafeERC20 for IERC20;
837 
838     // original KIMCHI token address
839     IERC20 public originalKimchi = IERC20(0x1E18821E69B9FAA8e6e75DFFe54E7E25754beDa0);
840 
841     // Info of each user.
842     struct UserInfo {
843         uint256 amount;     // How many LP tokens the user has provided.
844         uint256 rewardDebt; // Reward debt. See explanation below.
845         //
846         // We do some fancy math here. Basically, any point in time, the amount of KIMCHIs
847         // entitled to a user but is pending to be distributed is:
848         //
849         //   pending reward = (user.amount * pool.accGodKimchiPerShare) - user.rewardDebt
850         //
851         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
852         //   1. The pool's `accGodKimchiPerShare` (and `lastRewardBlock`) gets updated.
853         //   2. User receives the pending reward sent to his/her address.
854         //   3. User's `amount` gets updated.
855         //   4. User's `rewardDebt` gets updated.
856     }
857 
858     // Info of each pool.
859     struct PoolInfo {
860         IERC20 lpToken;           // Address of LP token contract.
861         uint256 allocPoint;       // How many allocation points assigned to this pool. KIMCHIs to distribute per block.
862         uint256 lastRewardBlock;  // Last block number that KIMCHIs distribution occurs.
863         uint256 accGodKimchiPerShare; // Accumulated KIMCHIs per share, times 1e12. See below.
864     }
865 
866     // The KIMCHI TOKEN!
867     GodKimchiToken public godkimchi;
868     // Dev address.
869     address public devaddr;
870     // Block number when bonus KIMCHI period ends.
871     uint256 public bonusEndBlock;
872     // KIMCHI tokens created per block.
873     uint256 public InitGodKimchiPerBlock;
874     // Bonus muliplier for early godkimchi makers.
875     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
876     // halving period (blocks)
877     uint256 public halvingPeriod = 46000;
878     uint256 public maxSwapGodKimchi = 20000000;
879 
880     // Info of each pool.
881     PoolInfo[] public poolInfo;
882     // Info of each user that stakes LP tokens.
883     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
884     // Total allocation poitns. Must be the sum of all allocation points in all pools.
885     uint256 public totalAllocPoint = 0;
886     // The block number when KIMCHI mining starts.
887     uint256 public startBlock;
888     uint256 public startSwapBlock;
889 
890     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
891     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
892     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
893     event InitSwapKimchi(address indexed user, uint256 amount, uint256 amount2);
894 
895     constructor(
896         GodKimchiToken _godkimchi,
897         address _devaddr,
898         uint256 _godkimchiPerBlock,
899         uint256 _startBlock,
900         uint256 _bonusEndBlock,
901         uint256 _startSwapBlock
902     ) public {
903         godkimchi = _godkimchi;
904         devaddr = _devaddr;
905         InitGodKimchiPerBlock = _godkimchiPerBlock;
906         bonusEndBlock = _bonusEndBlock;
907         startBlock = _startBlock;
908         startSwapBlock = _startSwapBlock;
909     }
910 
911     // 1:10 swap kimchi to GodKimchi
912     function initSwapKimchiToGodkimchi(uint256 amountToSwap) public {
913         require(originalKimchi.balanceOf(msg.sender) >= amountToSwap, 'Not enough KIMCHI to swap');
914         require(block.number <= startBlock, 'end of swap period');
915         require(block.number >= startSwapBlock, 'before swap period');
916         require(godkimchi.totalSupply() <= maxSwapGodKimchi*10**18, 'no more swap is available' );
917 
918         uint256 amountGod = amountToSwap.mul(10);
919         
920         godkimchi.mint(msg.sender, amountGod);
921         
922         // allow in the front end to execute the following transaction
923         // by swapping KIMCHI to gKIMCHI, KIMCHI will be send to YFI contract.
924         // KIMCHI respects Andre. Thanks you sir.
925         originalKimchi.safeTransferFrom(address(msg.sender),0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e, amountToSwap);
926 
927         emit InitSwapKimchi(msg.sender,amountToSwap,amountGod);
928     }
929 
930     function poolLength() external view returns (uint256) {
931         return poolInfo.length;
932     }
933 
934     // Add a new lp to the pool. Can only be called by the owner.
935     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
936     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
937         if (_withUpdate) {
938             massUpdatePools();
939         }
940         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
941         totalAllocPoint = totalAllocPoint.add(_allocPoint);
942         poolInfo.push(PoolInfo({
943             lpToken: _lpToken,
944             allocPoint: _allocPoint,
945             lastRewardBlock: lastRewardBlock,
946             accGodKimchiPerShare: 0
947         }));
948     }
949 
950     // Update the given pool's KIMCHI allocation point. Can only be called by the owner.
951     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
952         if (_withUpdate) {
953             massUpdatePools();
954         }
955         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
956         poolInfo[_pid].allocPoint = _allocPoint;
957     }
958 
959     // check halving factor at a specific block
960     function getHalvFactor(uint blockNumber) public view returns (uint256) {
961         return 2**( ( blockNumber.sub(startBlock) ).div(halvingPeriod) );
962     }
963 
964     // halving factor of current block
965     function getCurrentHalvFactor() public view returns (uint256) {
966         return 2**( ( block.number.sub(startBlock) ).div(halvingPeriod) );
967     }
968 
969     // reward prediction at specific block
970     function getRewardPerBlock(uint blockNumber) public view returns (uint256) {
971         if (block.number > startBlock){
972             return InitGodKimchiPerBlock/( 2**( ( blockNumber.sub(startBlock) ).div(halvingPeriod) ) )/10**18;
973         } else {
974             return 0;
975         }
976     }
977 
978     // current reward per block
979     function getCurrentRewardPerBlock() public view returns (uint256) {
980         if (block.number > startBlock){
981             return InitGodKimchiPerBlock/( 2**( ( block.number.sub(startBlock) ).div(halvingPeriod) ) )/10**18;
982         } else {
983             return 0;
984         }
985     }
986 
987     // Return reward multiplier over the given _from to _to block.
988     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
989         if (_to <= bonusEndBlock) {
990             return _to.sub(_from).mul(BONUS_MULTIPLIER);
991         } else if (_from >= bonusEndBlock) {
992             return _to.sub(_from);
993         } else {
994             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
995                 _to.sub(bonusEndBlock)
996             );
997         }
998     }
999 
1000 
1001     // View function to see pending KIMCHIs on frontend.
1002     function pendingGodKimchi(uint256 _pid, address _user) external view returns (uint256) {
1003         PoolInfo storage pool = poolInfo[_pid];
1004         UserInfo storage user = userInfo[_pid][_user];
1005         uint256 accGodKimchiPerShare = pool.accGodKimchiPerShare;
1006         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1007         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1008             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1009             
1010             uint256 halvFactor = 2**( ( block.number.sub(startBlock) ).div(halvingPeriod) );
1011 
1012             uint256 GodKimchiReward = multiplier.mul(InitGodKimchiPerBlock).mul(pool.allocPoint).div(totalAllocPoint).div(halvFactor);
1013             
1014             accGodKimchiPerShare = accGodKimchiPerShare.add(GodKimchiReward.mul(1e12).div(lpSupply));
1015 
1016         }
1017         return user.amount.mul(accGodKimchiPerShare).div(1e12).sub(user.rewardDebt);
1018     }
1019 
1020     // Update reward vairables for all pools. Be careful of gas spending!
1021     function massUpdatePools() public {
1022         uint256 length = poolInfo.length;
1023         for (uint256 pid = 0; pid < length; ++pid) {
1024             updatePool(pid);
1025         }
1026     }
1027 
1028     // Update reward variables of the given pool to be up-to-date.
1029     function updatePool(uint256 _pid) public {
1030         PoolInfo storage pool = poolInfo[_pid];
1031         if (block.number <= pool.lastRewardBlock) {
1032             return;
1033         }
1034         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1035         if (lpSupply == 0) {
1036             pool.lastRewardBlock = block.number;
1037             return;
1038         }
1039         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1040         
1041         uint256 halvFactor = 2**( ( block.number.sub(startBlock) ).div(halvingPeriod) );
1042         
1043         uint256 GodKimchiReward = multiplier.mul(InitGodKimchiPerBlock).mul(pool.allocPoint).div(totalAllocPoint).div(halvFactor);
1044 
1045         godkimchi.mint(devaddr, GodKimchiReward.div(40)); // 2.5%
1046         godkimchi.mint(address(this), GodKimchiReward);
1047 
1048         pool.accGodKimchiPerShare = pool.accGodKimchiPerShare.add(GodKimchiReward.mul(1e12).div(lpSupply));
1049         pool.lastRewardBlock = block.number;
1050 
1051     }
1052 
1053     // Deposit LP tokens to MasterChef for KIMCHI allocation.
1054     function deposit(uint256 _pid, uint256 _amount) public {
1055         PoolInfo storage pool = poolInfo[_pid];
1056         UserInfo storage user = userInfo[_pid][msg.sender];
1057         updatePool(_pid);
1058         if (user.amount > 0) {
1059             uint256 pending = user.amount.mul(pool.accGodKimchiPerShare).div(1e12).sub(user.rewardDebt);
1060             safeGodKimchiTransfer(msg.sender, pending);
1061         }
1062         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1063         user.amount = user.amount.add(_amount);
1064         user.rewardDebt = user.amount.mul(pool.accGodKimchiPerShare).div(1e12);
1065         emit Deposit(msg.sender, _pid, _amount);
1066     }
1067 
1068     // Withdraw LP tokens from MasterChef.
1069     function withdraw(uint256 _pid, uint256 _amount) public {
1070         PoolInfo storage pool = poolInfo[_pid];
1071         UserInfo storage user = userInfo[_pid][msg.sender];
1072         require(user.amount >= _amount, "withdraw: not good");
1073         updatePool(_pid);
1074         uint256 pending = user.amount.mul(pool.accGodKimchiPerShare).div(1e12).sub(user.rewardDebt);
1075         safeGodKimchiTransfer(msg.sender, pending);
1076         user.amount = user.amount.sub(_amount);
1077         user.rewardDebt = user.amount.mul(pool.accGodKimchiPerShare).div(1e12);
1078         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1079         emit Withdraw(msg.sender, _pid, _amount);
1080     }
1081 
1082     // Withdraw without caring about rewards. EMERGENCY ONLY.
1083     function emergencyWithdraw(uint256 _pid) public {
1084         PoolInfo storage pool = poolInfo[_pid];
1085         UserInfo storage user = userInfo[_pid][msg.sender];
1086         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1087         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1088         user.amount = 0;
1089         user.rewardDebt = 0;
1090     }
1091 
1092     // Safe godkimchi transfer function, just in case if rounding error causes pool to not have enough KIMCHIs.
1093     function safeGodKimchiTransfer(address _to, uint256 _amount) internal {
1094         uint256 kimchiBal = godkimchi.balanceOf(address(this));
1095         if (_amount > kimchiBal) {
1096             godkimchi.transfer(_to, kimchiBal);
1097         } else {
1098             godkimchi.transfer(_to, _amount);
1099         }
1100     }
1101 
1102     // Update dev address by the previous dev.
1103     function dev(address _devaddr) public {
1104         require(msg.sender == devaddr, "dev: wut?");
1105         devaddr = _devaddr;
1106     }
1107 }