1 /*
2 
3 SO YAMMY
4 
5 */
6 
7 pragma solidity ^0.6.12;
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 /**
104  * @dev Wrappers over Solidity's arithmetic operations with added overflow
105  * checks.
106  *
107  * Arithmetic operations in Solidity wrap on overflow. This can easily result
108  * in bugs, because programmers usually assume that an overflow raises an
109  * error, which is the standard behavior in high level programming languages.
110  * `SafeMath` restores this intuition by reverting the transaction when an
111  * operation overflows.
112  *
113  * Using this library instead of the unchecked operations eliminates an entire
114  * class of bugs, so it's recommended to use it always.
115  */
116 library SafeMath {
117     /**
118      * @dev Returns the addition of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `+` operator.
122      *
123      * Requirements:
124      *
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      *
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts with custom message when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
283         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
284         // for accounts without code, i.e. `keccak256('')`
285         bytes32 codehash;
286         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
287         // solhint-disable-next-line no-inline-assembly
288         assembly { codehash := extcodehash(account) }
289         return (codehash != accountHash && codehash != 0x0);
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(address(this).balance >= amount, "Address: insufficient balance");
310 
311         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
312         (bool success, ) = recipient.call{ value: amount }("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain`call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335       return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
345         return _functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
370         require(address(this).balance >= value, "Address: insufficient balance for call");
371         return _functionCallWithValue(target, data, value, errorMessage);
372     }
373 
374     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
375         require(isContract(target), "Address: call to non-contract");
376 
377         // solhint-disable-next-line avoid-low-level-calls
378         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 // solhint-disable-next-line no-inline-assembly
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 /**
399  * @title SafeERC20
400  * @dev Wrappers around ERC20 operations that throw on failure (when the token
401  * contract returns false). Tokens that return no value (and instead revert or
402  * throw on failure) are also supported, non-reverting calls are assumed to be
403  * successful.
404  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
405  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
406  */
407 library SafeERC20 {
408     using SafeMath for uint256;
409     using Address for address;
410 
411     function safeTransfer(IERC20 token, address to, uint256 value) internal {
412         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
413     }
414 
415     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
416         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
417     }
418 
419     /**
420      * @dev Deprecated. This function has issues similar to the ones found in
421      * {IERC20-approve}, and its usage is discouraged.
422      *
423      * Whenever possible, use {safeIncreaseAllowance} and
424      * {safeDecreaseAllowance} instead.
425      */
426     function safeApprove(IERC20 token, address spender, uint256 value) internal {
427         // safeApprove should only be called when setting an initial allowance,
428         // or when resetting it to zero. To increase and decrease it, use
429         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
430         // solhint-disable-next-line max-line-length
431         require((value == 0) || (token.allowance(address(this), spender) == 0),
432             "SafeERC20: approve from non-zero to non-zero allowance"
433         );
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
435     }
436 
437     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
438         uint256 newAllowance = token.allowance(address(this), spender).add(value);
439         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
440     }
441 
442     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
443         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
445     }
446 
447     /**
448      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
449      * on the return value: the return value is optional (but if data is returned, it must not be false).
450      * @param token The token targeted by the call.
451      * @param data The call data (encoded using abi.encode or one of its variants).
452      */
453     function _callOptionalReturn(IERC20 token, bytes memory data) private {
454         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
455         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
456         // the target address contains contract code and also asserts for success in the low-level call.
457 
458         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
459         if (returndata.length > 0) { // Return data is optional
460             // solhint-disable-next-line max-line-length
461             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
462         }
463     }
464 }
465 
466 
467 
468 /**
469  * @dev Contract module which provides a basic access control mechanism, where
470  * there is an account (an owner) that can be granted exclusive access to
471  * specific functions.
472  *
473  * By default, the owner account will be the one that deploys the contract. This
474  * can later be changed with {transferOwnership}.
475  *
476  * This module is used through inheritance. It will make available the modifier
477  * `onlyOwner`, which can be applied to your functions to restrict their use to
478  * the owner.
479  */
480 contract Ownable is Context {
481     address private _owner;
482 
483     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
484 
485     /**
486      * @dev Initializes the contract setting the deployer as the initial owner.
487      */
488     constructor () internal {
489         address msgSender = _msgSender();
490         _owner = msgSender;
491         emit OwnershipTransferred(address(0), msgSender);
492     }
493 
494     /**
495      * @dev Returns the address of the current owner.
496      */
497     function owner() public view returns (address) {
498         return _owner;
499     }
500 
501     /**
502      * @dev Throws if called by any account other than the owner.
503      */
504     modifier onlyOwner() {
505         require(_owner == _msgSender(), "Ownable: caller is not the owner");
506         _;
507     }
508 
509     /**
510      * @dev Leaves the contract without owner. It will not be possible to call
511      * `onlyOwner` functions anymore. Can only be called by the current owner.
512      *
513      * NOTE: Renouncing ownership will leave the contract without an owner,
514      * thereby removing any functionality that is only available to the owner.
515      */
516     function renounceOwnership() public virtual onlyOwner {
517         emit OwnershipTransferred(_owner, address(0));
518         _owner = address(0);
519     }
520 
521     /**
522      * @dev Transfers ownership of the contract to a new account (`newOwner`).
523      * Can only be called by the current owner.
524      */
525     function transferOwnership(address newOwner) public virtual onlyOwner {
526         require(newOwner != address(0), "Ownable: new owner is the zero address");
527         emit OwnershipTransferred(_owner, newOwner);
528         _owner = newOwner;
529     }
530 }
531 
532 
533 /**
534  * @dev Implementation of the {IERC20} interface.
535  *
536  * This implementation is agnostic to the way tokens are created. This means
537  * that a supply mechanism has to be added in a derived contract using {_mint}.
538  * For a generic mechanism see {ERC20PresetMinterPauser}.
539  *
540  * TIP: For a detailed writeup see our guide
541  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
542  * to implement supply mechanisms].
543  *
544  * We have followed general OpenZeppelin guidelines: functions revert instead
545  * of returning `false` on failure. This behavior is nonetheless conventional
546  * and does not conflict with the expectations of ERC20 applications.
547  *
548  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
549  * This allows applications to reconstruct the allowance for all accounts just
550  * by listening to said events. Other implementations of the EIP may not emit
551  * these events, as it isn't required by the specification.
552  *
553  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
554  * functions have been added to mitigate the well-known issues around setting
555  * allowances. See {IERC20-approve}.
556  */
557 contract ERC20 is Context, IERC20 {
558     using SafeMath for uint256;
559     using Address for address;
560 
561     mapping (address => uint256) private _balances;
562 
563     mapping (address => mapping (address => uint256)) private _allowances;
564 
565     uint256 private _totalSupply;
566 
567     string private _name;
568     string private _symbol;
569     uint8 private _decimals;
570 
571     /**
572      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
573      * a default value of 18.
574      *
575      * To select a different value for {decimals}, use {_setupDecimals}.
576      *
577      * All three of these values are immutable: they can only be set once during
578      * construction.
579      */
580     constructor (string memory name, string memory symbol) public {
581         _name = name;
582         _symbol = symbol;
583         _decimals = 18;
584     }
585 
586     /**
587      * @dev Returns the name of the token.
588      */
589     function name() public view returns (string memory) {
590         return _name;
591     }
592 
593     /**
594      * @dev Returns the symbol of the token, usually a shorter version of the
595      * name.
596      */
597     function symbol() public view returns (string memory) {
598         return _symbol;
599     }
600 
601     /**
602      * @dev Returns the number of decimals used to get its user representation.
603      * For example, if `decimals` equals `2`, a balance of `505` tokens should
604      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
605      *
606      * Tokens usually opt for a value of 18, imitating the relationship between
607      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
608      * called.
609      *
610      * NOTE: This information is only used for _display_ purposes: it in
611      * no way affects any of the arithmetic of the contract, including
612      * {IERC20-balanceOf} and {IERC20-transfer}.
613      */
614     function decimals() public view returns (uint8) {
615         return _decimals;
616     }
617 
618     /**
619      * @dev See {IERC20-totalSupply}.
620      */
621     function totalSupply() public view override returns (uint256) {
622         return _totalSupply;
623     }
624 
625     /**
626      * @dev See {IERC20-balanceOf}.
627      */
628     function balanceOf(address account) public view override returns (uint256) {
629         return _balances[account];
630     }
631 
632     /**
633      * @dev See {IERC20-transfer}.
634      *
635      * Requirements:
636      *
637      * - `recipient` cannot be the zero address.
638      * - the caller must have a balance of at least `amount`.
639      */
640     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
641         _transfer(_msgSender(), recipient, amount);
642         return true;
643     }
644 
645     /**
646      * @dev See {IERC20-allowance}.
647      */
648     function allowance(address owner, address spender) public view virtual override returns (uint256) {
649         return _allowances[owner][spender];
650     }
651 
652     /**
653      * @dev See {IERC20-approve}.
654      *
655      * Requirements:
656      *
657      * - `spender` cannot be the zero address.
658      */
659     function approve(address spender, uint256 amount) public virtual override returns (bool) {
660         _approve(_msgSender(), spender, amount);
661         return true;
662     }
663 
664     /**
665      * @dev See {IERC20-transferFrom}.
666      *
667      * Emits an {Approval} event indicating the updated allowance. This is not
668      * required by the EIP. See the note at the beginning of {ERC20};
669      *
670      * Requirements:
671      * - `sender` and `recipient` cannot be the zero address.
672      * - `sender` must have a balance of at least `amount`.
673      * - the caller must have allowance for ``sender``'s tokens of at least
674      * `amount`.
675      */
676     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
677         _transfer(sender, recipient, amount);
678         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
679         return true;
680     }
681 
682     /**
683      * @dev Atomically increases the allowance granted to `spender` by the caller.
684      *
685      * This is an alternative to {approve} that can be used as a mitigation for
686      * problems described in {IERC20-approve}.
687      *
688      * Emits an {Approval} event indicating the updated allowance.
689      *
690      * Requirements:
691      *
692      * - `spender` cannot be the zero address.
693      */
694     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
695         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
696         return true;
697     }
698 
699     /**
700      * @dev Atomically decreases the allowance granted to `spender` by the caller.
701      *
702      * This is an alternative to {approve} that can be used as a mitigation for
703      * problems described in {IERC20-approve}.
704      *
705      * Emits an {Approval} event indicating the updated allowance.
706      *
707      * Requirements:
708      *
709      * - `spender` cannot be the zero address.
710      * - `spender` must have allowance for the caller of at least
711      * `subtractedValue`.
712      */
713     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
714         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
715         return true;
716     }
717 
718     /**
719      * @dev Moves tokens `amount` from `sender` to `recipient`.
720      *
721      * This is internal function is equivalent to {transfer}, and can be used to
722      * e.g. implement automatic token fees, slashing mechanisms, etc.
723      *
724      * Emits a {Transfer} event.
725      *
726      * Requirements:
727      *
728      * - `sender` cannot be the zero address.
729      * - `recipient` cannot be the zero address.
730      * - `sender` must have a balance of at least `amount`.
731      */
732     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
733         require(sender != address(0), "ERC20: transfer from the zero address");
734         require(recipient != address(0), "ERC20: transfer to the zero address");
735 
736         _beforeTokenTransfer(sender, recipient, amount);
737 
738         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
739         _balances[recipient] = _balances[recipient].add(amount);
740         emit Transfer(sender, recipient, amount);
741     }
742 
743     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
744      * the total supply.
745      *
746      * Emits a {Transfer} event with `from` set to the zero address.
747      *
748      * Requirements
749      *
750      * - `to` cannot be the zero address.
751      */
752     function _mint(address account, uint256 amount) internal virtual {
753         require(account != address(0), "ERC20: mint to the zero address");
754 
755         _beforeTokenTransfer(address(0), account, amount);
756 
757         _totalSupply = _totalSupply.add(amount);
758         _balances[account] = _balances[account].add(amount);
759         emit Transfer(address(0), account, amount);
760     }
761 
762     /**
763      * @dev Destroys `amount` tokens from `account`, reducing the
764      * total supply.
765      *
766      * Emits a {Transfer} event with `to` set to the zero address.
767      *
768      * Requirements
769      *
770      * - `account` cannot be the zero address.
771      * - `account` must have at least `amount` tokens.
772      */
773     function _burn(address account, uint256 amount) internal virtual {
774         require(account != address(0), "ERC20: burn from the zero address");
775 
776         _beforeTokenTransfer(account, address(0), amount);
777 
778         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
779         _totalSupply = _totalSupply.sub(amount);
780         emit Transfer(account, address(0), amount);
781     }
782 
783     /**
784      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
785      *
786      * This is internal function is equivalent to `approve`, and can be used to
787      * e.g. set automatic allowances for certain subsystems, etc.
788      *
789      * Emits an {Approval} event.
790      *
791      * Requirements:
792      *
793      * - `owner` cannot be the zero address.
794      * - `spender` cannot be the zero address.
795      */
796     function _approve(address owner, address spender, uint256 amount) internal virtual {
797         require(owner != address(0), "ERC20: approve from the zero address");
798         require(spender != address(0), "ERC20: approve to the zero address");
799 
800         _allowances[owner][spender] = amount;
801         emit Approval(owner, spender, amount);
802     }
803 
804     /**
805      * @dev Sets {decimals} to a value other than the default one of 18.
806      *
807      * WARNING: This function should only be called from the constructor. Most
808      * applications that interact with token contracts will not expect
809      * {decimals} to ever change, and may work incorrectly if it does.
810      */
811     function _setupDecimals(uint8 decimals_) internal {
812         _decimals = decimals_;
813     }
814 
815     /**
816      * @dev Hook that is called before any transfer of tokens. This includes
817      * minting and burning.
818      *
819      * Calling conditions:
820      *
821      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
822      * will be to transferred to `to`.
823      * - when `from` is zero, `amount` tokens will be minted for `to`.
824      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
825      * - `from` and `to` are never both zero.
826      *
827      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
828      */
829     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
830 }
831 
832 // KimchiToken with Governance.
833 contract GODKimchiToken is ERC20("GOD KIMCHI", "gKIMCHI"), Ownable {
834     /// @notice Creates `_amount` token to `_to`. Must only be called by GodKimchiChef.
835     function mint(address _to, uint256 _amount) public onlyOwner {
836         _mint(_to, _amount);
837     }
838 }