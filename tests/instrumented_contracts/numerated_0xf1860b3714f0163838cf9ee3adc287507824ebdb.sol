1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMathUpgradeable {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         uint256 c = a + b;
26         if (c < a) return (false, 0);
27         return (true, c);
28     }
29 
30     /**
31      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         if (b > a) return (false, 0);
37         return (true, a - b);
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49         if (a == 0) return (true, 0);
50         uint256 c = a * b;
51         if (c / a != b) return (false, 0);
52         return (true, c);
53     }
54 
55     /**
56      * @dev Returns the division of two unsigned integers, with a division by zero flag.
57      *
58      * _Available since v3.4._
59      */
60     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         if (b == 0) return (false, 0);
62         return (true, a / b);
63     }
64 
65     /**
66      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         if (b == 0) return (false, 0);
72         return (true, a % b);
73     }
74 
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      *
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b <= a, "SafeMath: subtraction overflow");
103         return a - b;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      *
114      * - Multiplication cannot overflow.
115      */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) return 0;
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers, reverting on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b > 0, "SafeMath: division by zero");
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b > 0, "SafeMath: modulo by zero");
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         return a - b;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * CAUTION: This function is deprecated because it requires allocating memory for the error
180      * message unnecessarily. For custom revert reasons use {tryDiv}.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         return a / b;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * reverting with custom message when dividing by zero.
198      *
199      * CAUTION: This function is deprecated because it requires allocating memory for the error
200      * message unnecessarily. For custom revert reasons use {tryMod}.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         return a % b;
213     }
214 }
215 
216 /**
217  * @dev Collection of functions related to the address type
218  */
219 library AddressUpgradeable {
220     /**
221      * @dev Returns true if `account` is a contract.
222      *
223      * [IMPORTANT]
224      * ====
225      * It is unsafe to assume that an address for which this function returns
226      * false is an externally-owned account (EOA) and not a contract.
227      *
228      * Among others, `isContract` will return false for the following
229      * types of addresses:
230      *
231      *  - an externally-owned account
232      *  - a contract in construction
233      *  - an address where a contract will be created
234      *  - an address where a contract lived, but was destroyed
235      * ====
236      */
237     function isContract(address account) internal view returns (bool) {
238         // This method relies on extcodesize, which returns 0 for contracts in
239         // construction, since the code is only stored at the end of the
240         // constructor execution.
241 
242         uint256 size;
243         // solhint-disable-next-line no-inline-assembly
244         assembly { size := extcodesize(account) }
245         return size > 0;
246     }
247 
248     /**
249      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
250      * `recipient`, forwarding all available gas and reverting on errors.
251      *
252      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
253      * of certain opcodes, possibly making contracts go over the 2300 gas limit
254      * imposed by `transfer`, making them unable to receive funds via
255      * `transfer`. {sendValue} removes this limitation.
256      *
257      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
258      *
259      * IMPORTANT: because control is transferred to `recipient`, care must be
260      * taken to not create reentrancy vulnerabilities. Consider using
261      * {ReentrancyGuard} or the
262      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
263      */
264     function sendValue(address payable recipient, uint256 amount) internal {
265         require(address(this).balance >= amount, "Address: insufficient balance");
266 
267         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
268         (bool success, ) = recipient.call{ value: amount }("");
269         require(success, "Address: unable to send value, recipient may have reverted");
270     }
271 
272     /**
273      * @dev Performs a Solidity function call using a low level `call`. A
274      * plain`call` is an unsafe replacement for a function call: use this
275      * function instead.
276      *
277      * If `target` reverts with a revert reason, it is bubbled up by this
278      * function (like regular Solidity function calls).
279      *
280      * Returns the raw returned data. To convert to the expected return value,
281      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
282      *
283      * Requirements:
284      *
285      * - `target` must be a contract.
286      * - calling `target` with `data` must not revert.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
291       return functionCall(target, data, "Address: low-level call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
296      * `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
301         return functionCallWithValue(target, data, 0, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but also transferring `value` wei to `target`.
307      *
308      * Requirements:
309      *
310      * - the calling contract must have an ETH balance of at least `value`.
311      * - the called Solidity function must be `payable`.
312      *
313      * _Available since v3.1._
314      */
315     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
321      * with `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
326         require(address(this).balance >= value, "Address: insufficient balance for call");
327         require(isContract(target), "Address: call to non-contract");
328 
329         // solhint-disable-next-line avoid-low-level-calls
330         (bool success, bytes memory returndata) = target.call{ value: value }(data);
331         return _verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
341         return functionStaticCall(target, data, "Address: low-level static call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
351         require(isContract(target), "Address: static call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = target.staticcall(data);
355         return _verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
359         if (success) {
360             return returndata;
361         } else {
362             // Look for revert reason and bubble it up if present
363             if (returndata.length > 0) {
364                 // The easiest way to bubble the revert reason is using memory via assembly
365 
366                 // solhint-disable-next-line no-inline-assembly
367                 assembly {
368                     let returndata_size := mload(returndata)
369                     revert(add(32, returndata), returndata_size)
370                 }
371             } else {
372                 revert(errorMessage);
373             }
374         }
375     }
376 }
377 
378 /**
379  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
380  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
381  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
382  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
383  *
384  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
385  * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
386  *
387  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
388  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
389  */
390 abstract contract Initializable {
391 
392     /**
393      * @dev Indicates that the contract has been initialized.
394      */
395     bool private _initialized;
396 
397     /**
398      * @dev Indicates that the contract is in the process of being initialized.
399      */
400     bool private _initializing;
401 
402     /**
403      * @dev Modifier to protect an initializer function from being invoked twice.
404      */
405     modifier initializer() {
406         require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");
407 
408         bool isTopLevelCall = !_initializing;
409         if (isTopLevelCall) {
410             _initializing = true;
411             _initialized = true;
412         }
413 
414         _;
415 
416         if (isTopLevelCall) {
417             _initializing = false;
418         }
419     }
420 
421     /// @dev Returns true if and only if the function is running in the constructor
422     function _isConstructor() private view returns (bool) {
423         return !AddressUpgradeable.isContract(address(this));
424     }
425 }
426 
427 /*
428  * @dev Provides information about the current execution context, including the
429  * sender of the transaction and its data. While these are generally available
430  * via msg.sender and msg.data, they should not be accessed in such a direct
431  * manner, since when dealing with GSN meta-transactions the account sending and
432  * paying for execution may not be the actual sender (as far as an application
433  * is concerned).
434  *
435  * This contract is only required for intermediate, library-like contracts.
436  */
437 abstract contract ContextUpgradeable is Initializable {
438     function __Context_init() internal initializer {
439         __Context_init_unchained();
440     }
441 
442     function __Context_init_unchained() internal initializer {
443     }
444     function _msgSender() internal view virtual returns (address payable) {
445         return msg.sender;
446     }
447 
448     function _msgData() internal view virtual returns (bytes memory) {
449         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
450         return msg.data;
451     }
452     uint256[50] private __gap;
453 }
454 
455 /**
456  * @dev Interface of the ERC20 standard as defined in the EIP.
457  */
458 interface IERC20Upgradeable {
459     /**
460      * @dev Returns the amount of tokens in existence.
461      */
462     function totalSupply() external view returns (uint256);
463 
464     /**
465      * @dev Returns the amount of tokens owned by `account`.
466      */
467     function balanceOf(address account) external view returns (uint256);
468 
469     /**
470      * @dev Moves `amount` tokens from the caller's account to `recipient`.
471      *
472      * Returns a boolean value indicating whether the operation succeeded.
473      *
474      * Emits a {Transfer} event.
475      */
476     function transfer(address recipient, uint256 amount) external returns (bool);
477 
478     /**
479      * @dev Returns the remaining number of tokens that `spender` will be
480      * allowed to spend on behalf of `owner` through {transferFrom}. This is
481      * zero by default.
482      *
483      * This value changes when {approve} or {transferFrom} are called.
484      */
485     function allowance(address owner, address spender) external view returns (uint256);
486 
487     /**
488      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
489      *
490      * Returns a boolean value indicating whether the operation succeeded.
491      *
492      * IMPORTANT: Beware that changing an allowance with this method brings the risk
493      * that someone may use both the old and the new allowance by unfortunate
494      * transaction ordering. One possible solution to mitigate this race
495      * condition is to first reduce the spender's allowance to 0 and set the
496      * desired value afterwards:
497      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
498      *
499      * Emits an {Approval} event.
500      */
501     function approve(address spender, uint256 amount) external returns (bool);
502 
503     /**
504      * @dev Moves `amount` tokens from `sender` to `recipient` using the
505      * allowance mechanism. `amount` is then deducted from the caller's
506      * allowance.
507      *
508      * Returns a boolean value indicating whether the operation succeeded.
509      *
510      * Emits a {Transfer} event.
511      */
512     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
513 
514     /**
515      * @dev Emitted when `value` tokens are moved from one account (`from`) to
516      * another (`to`).
517      *
518      * Note that `value` may be zero.
519      */
520     event Transfer(address indexed from, address indexed to, uint256 value);
521 
522     /**
523      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
524      * a call to {approve}. `value` is the new allowance.
525      */
526     event Approval(address indexed owner, address indexed spender, uint256 value);
527 }
528 
529 /**
530  * @dev Implementation of the {IERC20} interface.
531  *
532  * This implementation is agnostic to the way tokens are created. This means
533  * that a supply mechanism has to be added in a derived contract using {_mint}.
534  * For a generic mechanism see {ERC20PresetMinterPauser}.
535  *
536  * TIP: For a detailed writeup see our guide
537  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
538  * to implement supply mechanisms].
539  *
540  * We have followed general OpenZeppelin guidelines: functions revert instead
541  * of returning `false` on failure. This behavior is nonetheless conventional
542  * and does not conflict with the expectations of ERC20 applications.
543  *
544  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
545  * This allows applications to reconstruct the allowance for all accounts just
546  * by listening to said events. Other implementations of the EIP may not emit
547  * these events, as it isn't required by the specification.
548  *
549  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
550  * functions have been added to mitigate the well-known issues around setting
551  * allowances. See {IERC20-approve}.
552  */
553 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable {
554     using SafeMathUpgradeable for uint256;
555 
556     mapping (address => uint256) private _balances;
557 
558     mapping (address => mapping (address => uint256)) private _allowances;
559 
560     uint256 private _totalSupply;
561 
562     string private _name;
563     string private _symbol;
564     uint8 private _decimals;
565 
566     /**
567      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
568      * a default value of 18.
569      *
570      * To select a different value for {decimals}, use {_setupDecimals}.
571      *
572      * All three of these values are immutable: they can only be set once during
573      * construction.
574      */
575     function __ERC20_init(string memory name_, string memory symbol_) internal initializer {
576         __Context_init_unchained();
577         __ERC20_init_unchained(name_, symbol_);
578     }
579 
580     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal initializer {
581         _name = name_;
582         _symbol = symbol_;
583         _decimals = 18;
584     }
585 
586     /**
587      * @dev Returns the name of the token.
588      */
589     function name() public view virtual returns (string memory) {
590         return _name;
591     }
592 
593     /**
594      * @dev Returns the symbol of the token, usually a shorter version of the
595      * name.
596      */
597     function symbol() public view virtual returns (string memory) {
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
614     function decimals() public view virtual returns (uint8) {
615         return _decimals;
616     }
617 
618     /**
619      * @dev See {IERC20-totalSupply}.
620      */
621     function totalSupply() public view virtual override returns (uint256) {
622         return _totalSupply;
623     }
624 
625     /**
626      * @dev See {IERC20-balanceOf}.
627      */
628     function balanceOf(address account) public view virtual override returns (uint256) {
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
668      * required by the EIP. See the note at the beginning of {ERC20}.
669      *
670      * Requirements:
671      *
672      * - `sender` and `recipient` cannot be the zero address.
673      * - `sender` must have a balance of at least `amount`.
674      * - the caller must have allowance for ``sender``'s tokens of at least
675      * `amount`.
676      */
677     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
678         _transfer(sender, recipient, amount);
679         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
680         return true;
681     }
682 
683     /**
684      * @dev Atomically increases the allowance granted to `spender` by the caller.
685      *
686      * This is an alternative to {approve} that can be used as a mitigation for
687      * problems described in {IERC20-approve}.
688      *
689      * Emits an {Approval} event indicating the updated allowance.
690      *
691      * Requirements:
692      *
693      * - `spender` cannot be the zero address.
694      */
695     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
696         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
697         return true;
698     }
699 
700     /**
701      * @dev Atomically decreases the allowance granted to `spender` by the caller.
702      *
703      * This is an alternative to {approve} that can be used as a mitigation for
704      * problems described in {IERC20-approve}.
705      *
706      * Emits an {Approval} event indicating the updated allowance.
707      *
708      * Requirements:
709      *
710      * - `spender` cannot be the zero address.
711      * - `spender` must have allowance for the caller of at least
712      * `subtractedValue`.
713      */
714     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
715         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
716         return true;
717     }
718 
719     /**
720      * @dev Moves tokens `amount` from `sender` to `recipient`.
721      *
722      * This is internal function is equivalent to {transfer}, and can be used to
723      * e.g. implement automatic token fees, slashing mechanisms, etc.
724      *
725      * Emits a {Transfer} event.
726      *
727      * Requirements:
728      *
729      * - `sender` cannot be the zero address.
730      * - `recipient` cannot be the zero address.
731      * - `sender` must have a balance of at least `amount`.
732      */
733     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
734         require(sender != address(0), "ERC20: transfer from the zero address");
735         require(recipient != address(0), "ERC20: transfer to the zero address");
736 
737         _beforeTokenTransfer(sender, recipient, amount);
738 
739         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
740         _balances[recipient] = _balances[recipient].add(amount);
741         emit Transfer(sender, recipient, amount);
742     }
743 
744     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
745      * the total supply.
746      *
747      * Emits a {Transfer} event with `from` set to the zero address.
748      *
749      * Requirements:
750      *
751      * - `to` cannot be the zero address.
752      */
753     function _mint(address account, uint256 amount) internal virtual {
754         require(account != address(0), "ERC20: mint to the zero address");
755 
756         _beforeTokenTransfer(address(0), account, amount);
757 
758         _totalSupply = _totalSupply.add(amount);
759         _balances[account] = _balances[account].add(amount);
760         emit Transfer(address(0), account, amount);
761     }
762 
763     /**
764      * @dev Destroys `amount` tokens from `account`, reducing the
765      * total supply.
766      *
767      * Emits a {Transfer} event with `to` set to the zero address.
768      *
769      * Requirements:
770      *
771      * - `account` cannot be the zero address.
772      * - `account` must have at least `amount` tokens.
773      */
774     function _burn(address account, uint256 amount) internal virtual {
775         require(account != address(0), "ERC20: burn from the zero address");
776 
777         _beforeTokenTransfer(account, address(0), amount);
778 
779         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
780         _totalSupply = _totalSupply.sub(amount);
781         emit Transfer(account, address(0), amount);
782     }
783 
784     /**
785      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
786      *
787      * This internal function is equivalent to `approve`, and can be used to
788      * e.g. set automatic allowances for certain subsystems, etc.
789      *
790      * Emits an {Approval} event.
791      *
792      * Requirements:
793      *
794      * - `owner` cannot be the zero address.
795      * - `spender` cannot be the zero address.
796      */
797     function _approve(address owner, address spender, uint256 amount) internal virtual {
798         require(owner != address(0), "ERC20: approve from the zero address");
799         require(spender != address(0), "ERC20: approve to the zero address");
800 
801         _allowances[owner][spender] = amount;
802         emit Approval(owner, spender, amount);
803     }
804 
805     /**
806      * @dev Sets {decimals} to a value other than the default one of 18.
807      *
808      * WARNING: This function should only be called from the constructor. Most
809      * applications that interact with token contracts will not expect
810      * {decimals} to ever change, and may work incorrectly if it does.
811      */
812     function _setupDecimals(uint8 decimals_) internal virtual {
813         _decimals = decimals_;
814     }
815 
816     /**
817      * @dev Hook that is called before any transfer of tokens. This includes
818      * minting and burning.
819      *
820      * Calling conditions:
821      *
822      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
823      * will be to transferred to `to`.
824      * - when `from` is zero, `amount` tokens will be minted for `to`.
825      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
826      * - `from` and `to` are never both zero.
827      *
828      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
829      */
830     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
831     uint256[44] private __gap;
832 }
833 
834 interface IUniswapV2Pair {
835     event Approval(address indexed owner, address indexed spender, uint value);
836     event Transfer(address indexed from, address indexed to, uint value);
837 
838     function name() external pure returns (string memory);
839     function symbol() external pure returns (string memory);
840     function decimals() external pure returns (uint8);
841     function totalSupply() external view returns (uint);
842     function balanceOf(address owner) external view returns (uint);
843     function allowance(address owner, address spender) external view returns (uint);
844 
845     function approve(address spender, uint value) external returns (bool);
846     function transfer(address to, uint value) external returns (bool);
847     function transferFrom(address from, address to, uint value) external returns (bool);
848 
849     function DOMAIN_SEPARATOR() external view returns (bytes32);
850     function PERMIT_TYPEHASH() external pure returns (bytes32);
851     function nonces(address owner) external view returns (uint);
852 
853     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
854 
855     event Mint(address indexed sender, uint amount0, uint amount1);
856     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
857     event Swap(
858         address indexed sender,
859         uint amount0In,
860         uint amount1In,
861         uint amount0Out,
862         uint amount1Out,
863         address indexed to
864     );
865     event Sync(uint112 reserve0, uint112 reserve1);
866 
867     function MINIMUM_LIQUIDITY() external pure returns (uint);
868     function factory() external view returns (address);
869     function token0() external view returns (address);
870     function token1() external view returns (address);
871     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
872     function price0CumulativeLast() external view returns (uint);
873     function price1CumulativeLast() external view returns (uint);
874     function kLast() external view returns (uint);
875 
876     function mint(address to) external returns (uint liquidity);
877     function burn(address to) external returns (uint amount0, uint amount1);
878     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
879     function skim(address to) external;
880     function sync() external;
881 
882     function initialize(address, address) external;
883 }
884 
885 interface IUniswapV2Factory {
886     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
887 
888     function feeTo() external view returns (address);
889     function feeToSetter() external view returns (address);
890 
891     function getPair(address tokenA, address tokenB) external view returns (address pair);
892     function allPairs(uint) external view returns (address pair);
893     function allPairsLength() external view returns (uint);
894 
895     function createPair(address tokenA, address tokenB) external returns (address pair);
896 
897     function setFeeTo(address) external;
898     function setFeeToSetter(address) external;
899 }
900 
901 /**
902  * @title UniswapTwapPriceOracleV2Root
903  * @notice Stores cumulative prices and returns TWAPs for assets on Uniswap V2 pairs.
904  * @author David Lucid <david@rari.capital> (https://github.com/davidlucid)
905  */
906 contract UniswapTwapPriceOracleV2Root {
907     using SafeMathUpgradeable for uint256;
908 
909     /**
910      * @dev WETH token contract address.
911      */
912     address constant public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
913 
914     /**
915      * @dev Minimum TWAP interval.
916      */
917     uint256 public constant MIN_TWAP_TIME = 15 minutes;
918 
919     /**
920      * @dev Return the TWAP value price0. Revert if TWAP time range is not within the threshold.
921      * Copied from: https://github.com/AlphaFinanceLab/homora-v2/blob/master/contracts/oracle/BaseKP3ROracle.sol
922      * @param pair The pair to query for price0.
923      */
924     function price0TWAP(address pair) internal view returns (uint) {
925         uint length = observationCount[pair];
926         require(length > 0, 'No length-1 TWAP observation.');
927         Observation memory lastObservation = observations[pair][(length - 1) % OBSERVATION_BUFFER];
928         if (lastObservation.timestamp > now - MIN_TWAP_TIME) {
929             require(length > 1, 'No length-2 TWAP observation.');
930             lastObservation = observations[pair][(length - 2) % OBSERVATION_BUFFER];
931         }
932         uint elapsedTime = now - lastObservation.timestamp;
933         require(elapsedTime >= MIN_TWAP_TIME, 'Bad TWAP time.');
934         uint currPx0Cumu = currentPx0Cumu(pair);
935         return (currPx0Cumu - lastObservation.price0Cumulative) / (now - lastObservation.timestamp); // overflow is desired
936     }
937 
938     /**
939      * @dev Return the TWAP value price1. Revert if TWAP time range is not within the threshold.
940      * Copied from: https://github.com/AlphaFinanceLab/homora-v2/blob/master/contracts/oracle/BaseKP3ROracle.sol
941      * @param pair The pair to query for price1.
942      */
943     function price1TWAP(address pair) internal view returns (uint) {
944         uint length = observationCount[pair];
945         require(length > 0, 'No length-1 TWAP observation.');
946         Observation memory lastObservation = observations[pair][(length - 1) % OBSERVATION_BUFFER];
947         if (lastObservation.timestamp > now - MIN_TWAP_TIME) {
948             require(length > 1, 'No length-2 TWAP observation.');
949             lastObservation = observations[pair][(length - 2) % OBSERVATION_BUFFER];
950         }
951         uint elapsedTime = now - lastObservation.timestamp;
952         require(elapsedTime >= MIN_TWAP_TIME, 'Bad TWAP time.');
953         uint currPx1Cumu = currentPx1Cumu(pair);
954         return (currPx1Cumu - lastObservation.price1Cumulative) / (now - lastObservation.timestamp); // overflow is desired
955     }
956 
957     /**
958      * @dev Return the current price0 cumulative value on Uniswap.
959      * Copied from: https://github.com/AlphaFinanceLab/homora-v2/blob/master/contracts/oracle/BaseKP3ROracle.sol
960      * @param pair The uniswap pair to query for price0 cumulative value.
961      */
962     function currentPx0Cumu(address pair) internal view returns (uint px0Cumu) {
963         uint32 currTime = uint32(now);
964         px0Cumu = IUniswapV2Pair(pair).price0CumulativeLast();
965         (uint reserve0, uint reserve1, uint32 lastTime) = IUniswapV2Pair(pair).getReserves();
966         if (lastTime != now) {
967             uint32 timeElapsed = currTime - lastTime; // overflow is desired
968             px0Cumu += uint((reserve1 << 112) / reserve0) * timeElapsed; // overflow is desired
969         }
970     }
971 
972     /**
973      * @dev Return the current price1 cumulative value on Uniswap.
974      * Copied from: https://github.com/AlphaFinanceLab/homora-v2/blob/master/contracts/oracle/BaseKP3ROracle.sol
975      * @param pair The uniswap pair to query for price1 cumulative value.
976      */
977     function currentPx1Cumu(address pair) internal view returns (uint px1Cumu) {
978         uint32 currTime = uint32(now);
979         px1Cumu = IUniswapV2Pair(pair).price1CumulativeLast();
980         (uint reserve0, uint reserve1, uint32 lastTime) = IUniswapV2Pair(pair).getReserves();
981         if (lastTime != currTime) {
982             uint32 timeElapsed = currTime - lastTime; // overflow is desired
983             px1Cumu += uint((reserve0 << 112) / reserve1) * timeElapsed; // overflow is desired
984         }
985     }
986     
987     /**
988      * @dev Returns the price of `underlying` in terms of `baseToken` given `factory`.
989      */
990     function price(address underlying, address baseToken, address factory) external view returns (uint) {
991         // Return ERC20/ETH TWAP
992         address pair = IUniswapV2Factory(factory).getPair(underlying, baseToken);
993         uint256 baseUnit = 10 ** uint256(ERC20Upgradeable(underlying).decimals());
994         return (underlying < baseToken ? price0TWAP(pair) : price1TWAP(pair)).div(2 ** 56).mul(baseUnit).div(2 ** 56); // Scaled by 1e18, not 2 ** 112
995     }
996 
997     /**
998      * @dev Struct for cumulative price observations.
999      */
1000     struct Observation {
1001         uint32 timestamp;
1002         uint256 price0Cumulative;
1003         uint256 price1Cumulative;
1004     }
1005 
1006     /**
1007      * @dev Length after which observations roll over to index 0.
1008      */
1009     uint8 public constant OBSERVATION_BUFFER = 4;
1010 
1011     /**
1012      * @dev Total observation count for each pair.
1013      */
1014     mapping(address => uint256) public observationCount;
1015 
1016     /**
1017      * @dev Array of cumulative price observations for each pair.
1018      */
1019     mapping(address => Observation[OBSERVATION_BUFFER]) public observations;
1020     
1021     /// @notice Get pairs for token combinations.
1022     function pairsFor(address[] calldata tokenA, address[] calldata tokenB, address factory) external view returns (address[] memory) {
1023         require(tokenA.length > 0 && tokenA.length == tokenB.length, "Token array lengths must be equal and greater than 0.");
1024         address[] memory pairs = new address[](tokenA.length);
1025         for (uint256 i = 0; i < tokenA.length; i++) pairs[i] = IUniswapV2Factory(factory).getPair(tokenA[i], tokenB[i]);
1026         return pairs;
1027     }
1028 
1029     /// @notice Check which of multiple pairs are workable/updatable.
1030     function workable(address[] calldata pairs, address[] calldata baseTokens, uint256[] calldata minPeriods, uint256[] calldata deviationThresholds) external view returns (bool[] memory) {
1031         require(pairs.length > 0 && pairs.length == baseTokens.length && pairs.length == minPeriods.length && pairs.length == deviationThresholds.length, "Array lengths must be equal and greater than 0.");
1032         bool[] memory answers = new bool[](pairs.length);
1033         for (uint256 i = 0; i < pairs.length; i++) answers[i] = _workable(pairs[i], baseTokens[i], minPeriods[i], deviationThresholds[i]);
1034         return answers;
1035     }
1036     
1037     /// @dev Internal function to check if a pair is workable (updateable AND reserves have changed AND deviation threshold is satisfied).
1038     function _workable(address pair, address baseToken, uint256 minPeriod, uint256 deviationThreshold) internal view returns (bool) {
1039         // Workable if:
1040         // 1) We have no observations
1041         // 2) The elapsed time since the last observation is > minPeriod AND reserves have changed AND deviation threshold is satisfied 
1042         // Note that we loop observationCount[pair] around OBSERVATION_BUFFER so we don't waste gas on new storage slots
1043         if (observationCount[pair] <= 0) return true;
1044         (, , uint32 lastTime) = IUniswapV2Pair(pair).getReserves();
1045         return (block.timestamp - observations[pair][(observationCount[pair] - 1) % OBSERVATION_BUFFER].timestamp) > (minPeriod >= MIN_TWAP_TIME ? minPeriod : MIN_TWAP_TIME) &&
1046             lastTime != observations[pair][(observationCount[pair] - 1) % OBSERVATION_BUFFER].timestamp &&
1047             _deviation(pair, baseToken) >= deviationThreshold;
1048     }
1049 
1050     /// @dev Internal function to check if a pair's spot price's deviation from its TWAP price as a ratio scaled by 1e18
1051     function _deviation(address pair, address baseToken) internal view returns (uint256) {
1052         // Get token base unit
1053         address token0 = IUniswapV2Pair(pair).token0();
1054         bool useToken0Price = token0 != baseToken;
1055         address underlying = useToken0Price ? token0 : IUniswapV2Pair(pair).token1();
1056         uint256 baseUnit = 10 ** uint256(ERC20Upgradeable(underlying).decimals());
1057 
1058         // Get TWAP price
1059         uint256 twapPrice = (useToken0Price ? price0TWAP(pair) : price1TWAP(pair)).div(2 ** 56).mul(baseUnit).div(2 ** 56); // Scaled by 1e18, not 2 ** 112
1060     
1061         // Get spot price
1062         (uint reserve0, uint reserve1, ) = IUniswapV2Pair(pair).getReserves();
1063         uint256 spotPrice = useToken0Price ? reserve1.mul(baseUnit).div(reserve0) : reserve0.mul(baseUnit).div(reserve1);
1064 
1065         // Get ratio and return deviation
1066         uint256 ratio = spotPrice.mul(1e18).div(twapPrice);
1067         return ratio >= 1e18 ? ratio - 1e18 : 1e18 - ratio;
1068     }
1069     
1070     /// @dev Internal function to check if a pair is updatable at all.
1071     function _updateable(address pair) internal view returns (bool) {
1072         // Updateable if:
1073         // 1) We have no observations
1074         // 2) The elapsed time since the last observation is > MIN_TWAP_TIME
1075         // Note that we loop observationCount[pair] around OBSERVATION_BUFFER so we don't waste gas on new storage slots
1076         return observationCount[pair] <= 0 || (block.timestamp - observations[pair][(observationCount[pair] - 1) % OBSERVATION_BUFFER].timestamp) > MIN_TWAP_TIME;
1077     }
1078 
1079     /// @notice Update one pair.
1080     function update(address pair) external {
1081         require(_update(pair), "Failed to update pair.");
1082     }
1083 
1084     /// @notice Update multiple pairs at once.
1085     function update(address[] calldata pairs) external {
1086         bool worked = false;
1087         for (uint256 i = 0; i < pairs.length; i++) if (_update(pairs[i])) worked = true;
1088         require(worked, "No pairs can be updated (yet).");
1089     }
1090 
1091     /// @dev Internal function to update a single pair.
1092     function _update(address pair) internal returns (bool) {
1093         // Check if workable
1094         if (!_updateable(pair)) return false;
1095 
1096         // Get cumulative price(s)
1097         uint256 price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
1098         uint256 price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
1099         
1100         // Loop observationCount[pair] around OBSERVATION_BUFFER so we don't waste gas on new storage slots
1101         (, , uint32 lastTime) = IUniswapV2Pair(pair).getReserves();
1102         observations[pair][observationCount[pair] % OBSERVATION_BUFFER] = Observation(lastTime, price0Cumulative, price1Cumulative);
1103         observationCount[pair]++;
1104         return true;
1105     }
1106 }