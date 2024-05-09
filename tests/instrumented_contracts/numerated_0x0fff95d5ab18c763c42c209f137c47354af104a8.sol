1 pragma solidity ^0.6.2;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19 
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // SPDX-License-Identifier: MIT
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 // SPDX-License-Identifier: MIT
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
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
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         // Solidity only automatically asserts when dividing by 0
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 // SPDX-License-Identifier: MIT
256 /**
257  * @dev Collection of functions related to the address type
258  */
259 library Address {
260     /**
261      * @dev Returns true if `account` is a contract.
262      *
263      * [IMPORTANT]
264      * ====
265      * It is unsafe to assume that an address for which this function returns
266      * false is an externally-owned account (EOA) and not a contract.
267      *
268      * Among others, `isContract` will return false for the following
269      * types of addresses:
270      *
271      *  - an externally-owned account
272      *  - a contract in construction
273      *  - an address where a contract will be created
274      *  - an address where a contract lived, but was destroyed
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
279         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
280         // for accounts without code, i.e. `keccak256('')`
281         bytes32 codehash;
282         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
283         // solhint-disable-next-line no-inline-assembly
284         assembly { codehash := extcodehash(account) }
285         return (codehash != accountHash && codehash != 0x0);
286     }
287 
288     /**
289      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290      * `recipient`, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by `transfer`, making them unable to receive funds via
295      * `transfer`. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to `recipient`, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
308         (bool success, ) = recipient.call{ value: amount }("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 }
312 
313 /**
314  * @dev Implementation of the {IERC20} interface.
315  *
316  * This implementation is agnostic to the way tokens are created. This means
317  * that a supply mechanism has to be added in a derived contract using {_mint}.
318  * For a generic mechanism see {ERC20MinterPauser}.
319  *
320  * TIP: For a detailed writeup see our guide
321  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
322  * to implement supply mechanisms].
323  *
324  * We have followed general OpenZeppelin guidelines: functions revert instead
325  * of returning `false` on failure. This behavior is nonetheless conventional
326  * and does not conflict with the expectations of ERC20 applications.
327  *
328  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
329  * This allows applications to reconstruct the allowance for all accounts just
330  * by listening to said events. Other implementations of the EIP may not emit
331  * these events, as it isn't required by the specification.
332  *
333  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
334  * functions have been added to mitigate the well-known issues around setting
335  * allowances. See {IERC20-approve}.
336  */
337 contract ERC20 is Context, IERC20 {
338     using SafeMath for uint256;
339     using Address for address;
340 
341     mapping (address => uint256) internal _balances;
342 
343     mapping (address => mapping (address => uint256)) private _allowances;
344 
345     uint256 internal _totalSupply;
346 
347     string private _name;
348     string private _symbol;
349     uint8 private _decimals;
350 
351     uint256 private _cap;
352 
353     /**
354      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
355      * a default value of 18.
356      *
357      * To select a different value for {decimals}, use {_setupDecimals}.
358      *
359      * All three of these values are immutable: they can only be set once during
360      * construction.
361      */
362     constructor (string memory name, string memory symbol) public {
363         _name = name;
364         _symbol = symbol;
365         _decimals = 18;
366     }
367 
368     /**
369      * @dev Returns the name of the token.
370      */
371     function name() public view returns (string memory) {
372         return _name;
373     }
374 
375     /**
376      * @dev Returns the symbol of the token, usually a shorter version of the
377      * name.
378      */
379     function symbol() public view returns (string memory) {
380         return _symbol;
381     }
382 
383     /**
384      * @dev Returns the number of decimals used to get its user representation.
385      * For example, if `decimals` equals `2`, a balance of `505` tokens should
386      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
387      *
388      * Tokens usually opt for a value of 18, imitating the relationship between
389      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
390      * called.
391      *
392      * NOTE: This information is only used for _display_ purposes: it in
393      * no way affects any of the arithmetic of the contract, including
394      * {IERC20-balanceOf} and {IERC20-transfer}.
395      */
396     function decimals() public view returns (uint8) {
397         return _decimals;
398     }
399 
400     /**
401      * @dev See {IERC20-totalSupply}.
402      */
403     function totalSupply() public view override returns (uint256) {
404         return _totalSupply;
405     }
406 
407     /**
408      * @dev See {IERC20-balanceOf}.
409      */
410     function balanceOf(address account) public view virtual override returns (uint256) {
411         return _balances[account];
412     }
413 
414     /**
415      * @dev See {IERC20-transfer}.
416      *
417      * Requirements:
418      *
419      * - `recipient` cannot be the zero address.
420      * - the caller must have a balance of at least `amount`.
421      */
422     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
423         require(recipient != address(this), "ERC20: Cannot transfer to self");
424         _transfer(_msgSender(), recipient, amount);
425         return true;
426     }
427 
428     /**
429      * @dev See {IERC20-allowance}.
430      */
431     function allowance(address owner, address spender) public view virtual override returns (uint256) {
432         return _allowances[owner][spender];
433     }
434 
435     /**
436      * @dev See {IERC20-approve}.
437      *
438      * Requirements:
439      *
440      * - `spender` cannot be the zero address.
441      */
442     function approve(address spender, uint256 amount) public virtual override returns (bool) {
443         _approve(_msgSender(), spender, amount);
444         return true;
445     }
446 
447     /**
448      * @dev See {IERC20-transferFrom}.
449      *
450      * Emits an {Approval} event indicating the updated allowance. This is not
451      * required by the EIP. See the note at the beginning of {ERC20};
452      *
453      * Requirements:
454      * - `sender` and `recipient` cannot be the zero address.
455      * - `sender` must have a balance of at least `amount`.
456      * - the caller must have allowance for ``sender``'s tokens of at least
457      * `amount`.
458      */
459     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
460         _transfer(sender, recipient, amount);
461         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
462         return true;
463     }
464 
465     /**
466      * @dev Atomically increases the allowance granted to `spender` by the caller.
467      *
468      * This is an alternative to {approve} that can be used as a mitigation for
469      * problems described in {IERC20-approve}.
470      *
471      * Emits an {Approval} event indicating the updated allowance.
472      *
473      * Requirements:
474      *
475      * - `spender` cannot be the zero address.
476      */
477     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
478         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
479         return true;
480     }
481 
482     /**
483      * @dev Atomically decreases the allowance granted to `spender` by the caller.
484      *
485      * This is an alternative to {approve} that can be used as a mitigation for
486      * problems described in {IERC20-approve}.
487      *
488      * Emits an {Approval} event indicating the updated allowance.
489      *
490      * Requirements:
491      *
492      * - `spender` cannot be the zero address.
493      * - `spender` must have allowance for the caller of at least
494      * `subtractedValue`.
495      */
496     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
497         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
498         return true;
499     }
500 
501     /**
502      * @dev Moves tokens `amount` from `sender` to `recipient`.
503      *
504      * This is internal function is equivalent to {transfer}, and can be used to
505      * e.g. implement automatic token fees, slashing mechanisms, etc.S
506      *
507      * Emits a {Transfer} event.
508      *
509      * Requirements:
510      *
511      * - `sender` cannot be the zero address.
512      * - `recipient` cannot be the zero address.
513      * - `sender` must have a balance of at least `amount`.
514      */
515     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
516         require(sender != address(0), "ERC20: transfer from the zero address");
517         require(recipient != address(0), "ERC20: transfer to the zero address");
518 
519         _beforeTokenTransfer(sender, recipient, amount);
520 
521         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
522         _balances[recipient] = _balances[recipient].add(amount);
523         emit Transfer(sender, recipient, amount);
524     }
525 
526     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
527      * the total supply.
528      *
529      * Emits a {Transfer} event with `from` set to the zero address.
530      *
531      * Requirements
532      *
533      * - `to` cannot be the zero address.
534      */
535     function _mint(address account, uint256 amount) internal virtual {
536         require(account != address(0), "ERC20: mint to the zero address");
537 
538         _beforeTokenTransfer(address(0), account, amount);
539 
540         _totalSupply = _totalSupply.add(amount);
541         _balances[account] = _balances[account].add(amount);
542         emit Transfer(address(0), account, amount);
543     }
544 
545     /**
546      * @dev Destroys `amount` tokens from `account`, reducing the
547      * total supply.
548      *
549      * Emits a {Transfer} event with `to` set to the zero address.
550      *
551      * Requirements
552      *
553      * - `account` cannot be the zero address.
554      * - `account` must have at least `amount` tokens.
555      */
556     function _burn(address account, uint256 amount) internal virtual {
557         require(account != address(0), "ERC20: burn from the zero address");
558 
559         _beforeTokenTransfer(account, address(0), amount);
560 
561         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
562         _totalSupply = _totalSupply.sub(amount);
563         emit Transfer(account, address(0), amount);
564     }
565 
566     /**
567      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
568      *
569      * This is internal function is equivalent to `approve`, and can be used to
570      * e.g. set automatic allowances for certain subsystems, etc.
571      *
572      * Emits an {Approval} event.
573      *
574      * Requirements:
575      *
576      * - `owner` cannot be the zero address.
577      * - `spender` cannot be the zero address.
578      */
579     function _approve(address owner, address spender, uint256 amount) internal virtual {
580         require(owner != address(0), "ERC20: approve from the zero address");
581         require(spender != address(0), "ERC20: approve to the zero address");
582 
583         _allowances[owner][spender] = amount;
584         emit Approval(owner, spender, amount);
585     }
586 
587     /**
588      * @dev Sets {decimals} to a value other than the default one of 18.
589      *
590      * WARNING: This function should only be called from the constructor. Most
591      * applications that interact with token contracts will not expect
592      * {decimals} to ever change, and may work incorrectly if it does.
593      */
594     function _setupDecimals(uint8 decimals_) internal {
595         _decimals = decimals_;
596     }
597 
598     /**
599      * @dev Hook that is called before any transfer of tokens. This includes
600      * minting and burning.
601      *
602      * Calling conditions:
603      *
604      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
605      * will be to transferred to `to`.
606      * - when `from` is zero, `amount` tokens will be minted for `to`.
607      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
608      * - `from` and `to` are never both zero.
609      *
610      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
611      */
612     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
613 }
614 
615 // SPDX-License-Identifier: MIT
616 /**
617  * @dev Library for managing
618  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
619  * types.
620  *
621  * Sets have the following properties:
622  *
623  * - Elements are added, removed, and checked for existence in constant time
624  * (O(1)).
625  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
626  *
627  * ```
628  * contract Example {
629  *     // Add the library methods
630  *     using EnumerableSet for EnumerableSet.AddressSet;
631  *
632  *     // Declare a set state variable
633  *     EnumerableSet.AddressSet private mySet;
634  * }
635  * ```
636  *
637  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
638  * (`UintSet`) are supported.
639  */
640 library EnumerableSet {
641     // To implement this library for multiple types with as little code
642     // repetition as possible, we write it in terms of a generic Set type with
643     // bytes32 values.
644     // The Set implementation uses private functions, and user-facing
645     // implementations (such as AddressSet) are just wrappers around the
646     // underlying Set.
647     // This means that we can only create new EnumerableSets for types that fit
648     // in bytes32.
649 
650     struct Set {
651         // Storage of set values
652         bytes32[] _values;
653 
654         // Position of the value in the `values` array, plus 1 because index 0
655         // means a value is not in the set.
656         mapping (bytes32 => uint256) _indexes;
657     }
658 
659     /**
660      * @dev Add a value to a set. O(1).
661      *
662      * Returns true if the value was added to the set, that is if it was not
663      * already present.
664      */
665     function _add(Set storage set, bytes32 value) private returns (bool) {
666         if (!_contains(set, value)) {
667             set._values.push(value);
668             // The value is stored at length-1, but we add 1 to all indexes
669             // and use 0 as a sentinel value
670             set._indexes[value] = set._values.length;
671             return true;
672         } else {
673             return false;
674         }
675     }
676 
677     /**
678      * @dev Removes a value from a set. O(1).
679      *
680      * Returns true if the value was removed from the set, that is if it was
681      * present.
682      */
683     function _remove(Set storage set, bytes32 value) private returns (bool) {
684         // We read and store the value's index to prevent multiple reads from the same storage slot
685         uint256 valueIndex = set._indexes[value];
686 
687         if (valueIndex != 0) { // Equivalent to contains(set, value)
688             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
689             // the array, and then remove the last element (sometimes called as 'swap and pop').
690             // This modifies the order of the array, as noted in {at}.
691 
692             uint256 toDeleteIndex = valueIndex - 1;
693             uint256 lastIndex = set._values.length - 1;
694 
695             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
696             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
697 
698             bytes32 lastvalue = set._values[lastIndex];
699 
700             // Move the last value to the index where the value to delete is
701             set._values[toDeleteIndex] = lastvalue;
702             // Update the index for the moved value
703             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
704 
705             // Delete the slot where the moved value was stored
706             set._values.pop();
707 
708             // Delete the index for the deleted slot
709             delete set._indexes[value];
710 
711             return true;
712         } else {
713             return false;
714         }
715     }
716 
717     /**
718      * @dev Returns true if the value is in the set. O(1).
719      */
720     function _contains(Set storage set, bytes32 value) private view returns (bool) {
721         return set._indexes[value] != 0;
722     }
723 
724     /**
725      * @dev Returns the number of values on the set. O(1).
726      */
727     function _length(Set storage set) private view returns (uint256) {
728         return set._values.length;
729     }
730 
731    /**
732     * @dev Returns the value stored at position `index` in the set. O(1).
733     *
734     * Note that there are no guarantees on the ordering of values inside the
735     * array, and it may change when more values are added or removed.
736     *
737     * Requirements:
738     *
739     * - `index` must be strictly less than {length}.
740     */
741     function _at(Set storage set, uint256 index) private view returns (bytes32) {
742         require(set._values.length > index, "EnumerableSet: index out of bounds");
743         return set._values[index];
744     }
745 
746     // AddressSet
747 
748     struct AddressSet {
749         Set _inner;
750     }
751 
752     /**
753      * @dev Add a value to a set. O(1).
754      *
755      * Returns true if the value was added to the set, that is if it was not
756      * already present.
757      */
758     function add(AddressSet storage set, address value) internal returns (bool) {
759         return _add(set._inner, bytes32(uint256(value)));
760     }
761 
762     /**
763      * @dev Removes a value from a set. O(1).
764      *
765      * Returns true if the value was removed from the set, that is if it was
766      * present.
767      */
768     function remove(AddressSet storage set, address value) internal returns (bool) {
769         return _remove(set._inner, bytes32(uint256(value)));
770     }
771 
772     /**
773      * @dev Returns true if the value is in the set. O(1).
774      */
775     function contains(AddressSet storage set, address value) internal view returns (bool) {
776         return _contains(set._inner, bytes32(uint256(value)));
777     }
778 
779     /**
780      * @dev Returns the number of values in the set. O(1).
781      */
782     function length(AddressSet storage set) internal view returns (uint256) {
783         return _length(set._inner);
784     }
785 
786    /**
787     * @dev Returns the value stored at position `index` in the set. O(1).
788     *
789     * Note that there are no guarantees on the ordering of values inside the
790     * array, and it may change when more values are added or removed.
791     *
792     * Requirements:
793     *
794     * - `index` must be strictly less than {length}.
795     */
796     function at(AddressSet storage set, uint256 index) internal view returns (address) {
797         return address(uint256(_at(set._inner, index)));
798     }
799 
800 
801     // UintSet
802 
803     struct UintSet {
804         Set _inner;
805     }
806 
807     /**
808      * @dev Add a value to a set. O(1).
809      *
810      * Returns true if the value was added to the set, that is if it was not
811      * already present.
812      */
813     function add(UintSet storage set, uint256 value) internal returns (bool) {
814         return _add(set._inner, bytes32(value));
815     }
816 
817     /**
818      * @dev Removes a value from a set. O(1).
819      *
820      * Returns true if the value was removed from the set, that is if it was
821      * present.
822      */
823     function remove(UintSet storage set, uint256 value) internal returns (bool) {
824         return _remove(set._inner, bytes32(value));
825     }
826 
827     /**
828      * @dev Returns true if the value is in the set. O(1).
829      */
830     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
831         return _contains(set._inner, bytes32(value));
832     }
833 
834     /**
835      * @dev Returns the number of values on the set. O(1).
836      */
837     function length(UintSet storage set) internal view returns (uint256) {
838         return _length(set._inner);
839     }
840 
841    /**
842     * @dev Returns the value stored at position `index` in the set. O(1).
843     *
844     * Note that there are no guarantees on the ordering of values inside the
845     * array, and it may change when more values are added or removed.
846     *
847     * Requirements:
848     *
849     * - `index` must be strictly less than {length}.
850     */
851     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
852         return uint256(_at(set._inner, index));
853     }
854 }
855 
856 // SPDX-License-Identifier: MIT
857 /**
858  * @dev Contract module that allows children to implement role-based access
859  * control mechanisms.
860  *
861  * Roles are referred to by their `bytes32` identifier. These should be exposed
862  * in the external API and be unique. The best way to achieve this is by
863  * using `public constant` hash digests:
864  *
865  * ```
866  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
867  * ```
868  *
869  * Roles can be used to represent a set of permissions. To restrict access to a
870  * function call, use {hasRole}:
871  *
872  * ```
873  * function foo() public {
874  *     require(hasRole(MY_ROLE, msg.sender));
875  *     ...
876  * }
877  * ```
878  *
879  * Roles can be granted and revoked dynamically via the {grantRole} and
880  * {revokeRole} functions. Each role has an associated admin role, and only
881  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
882  *
883  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
884  * that only accounts with this role will be able to grant or revoke other
885  * roles. More complex role relationships can be created by using
886  * {_setRoleAdmin}.
887  *
888  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
889  * grant and revoke this role. Extra precautions should be taken to secure
890  * accounts that have been granted it.
891  */
892 abstract contract AccessControl is Context {
893     using EnumerableSet for EnumerableSet.AddressSet;
894     using Address for address;
895 
896     struct RoleData {
897         EnumerableSet.AddressSet members;
898         bytes32 adminRole;
899     }
900 
901     mapping (bytes32 => RoleData) private _roles;
902 
903     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
904 
905     /**
906      * @dev Emitted when `account` is granted `role`.
907      *
908      * `sender` is the account that originated the contract call, an admin role
909      * bearer except when using {_setupRole}.
910      */
911     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
912 
913     /**
914      * @dev Emitted when `account` is revoked `role`.
915      *
916      * `sender` is the account that originated the contract call:
917      *   - if using `revokeRole`, it is the admin role bearer
918      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
919      */
920     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
921 
922     /**
923      * @dev Returns `true` if `account` has been granted `role`.
924      */
925     function hasRole(bytes32 role, address account) public view returns (bool) {
926         return _roles[role].members.contains(account);
927     }
928 
929     /**
930      * @dev Returns the number of accounts that have `role`. Can be used
931      * together with {getRoleMember} to enumerate all bearers of a role.
932      */
933     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
934         return _roles[role].members.length();
935     }
936 
937     /**
938      * @dev Returns one of the accounts that have `role`. `index` must be a
939      * value between 0 and {getRoleMemberCount}, non-inclusive.
940      *
941      * Role bearers are not sorted in any particular way, and their ordering may
942      * change at any point.
943      *
944      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
945      * you perform all queries on the same block. See the following
946      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
947      * for more information.
948      */
949     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
950         return _roles[role].members.at(index);
951     }
952 
953     /**
954      * @dev Returns the admin role that controls `role`. See {grantRole} and
955      * {revokeRole}.
956      *
957      * To change a role's admin, use {_setRoleAdmin}.
958      */
959     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
960         return _roles[role].adminRole;
961     }
962 
963     /**
964      * @dev Grants `role` to `account`.
965      *
966      * If `account` had not been already granted `role`, emits a {RoleGranted}
967      * event.
968      *
969      * Requirements:
970      *
971      * - the caller must have ``role``'s admin role.
972      */
973     function grantRole(bytes32 role, address account) public virtual {
974         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
975 
976         _grantRole(role, account);
977     }
978 
979     /**
980      * @dev Revokes `role` from `account`.
981      *
982      * If `account` had been granted `role`, emits a {RoleRevoked} event.
983      *
984      * Requirements:
985      *
986      * - the caller must have ``role``'s admin role.
987      */
988     function revokeRole(bytes32 role, address account) public virtual {
989         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
990 
991         _revokeRole(role, account);
992     }
993 
994     /**
995      * @dev Revokes `role` from the calling account.
996      *
997      * Roles are often managed via {grantRole} and {revokeRole}: this function's
998      * purpose is to provide a mechanism for accounts to lose their privileges
999      * if they are compromised (such as when a trusted device is misplaced).
1000      *
1001      * If the calling account had been granted `role`, emits a {RoleRevoked}
1002      * event.
1003      *
1004      * Requirements:
1005      *
1006      * - the caller must be `account`.
1007      */
1008     function renounceRole(bytes32 role, address account) public virtual {
1009         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1010 
1011         _revokeRole(role, account);
1012     }
1013 
1014     /**
1015      * @dev Grants `role` to `account`.
1016      *
1017      * If `account` had not been already granted `role`, emits a {RoleGranted}
1018      * event. Note that unlike {grantRole}, this function doesn't perform any
1019      * checks on the calling account.
1020      *
1021      * [WARNING]
1022      * ====
1023      * This function should only be called from the constructor when setting
1024      * up the initial roles for the system.
1025      *
1026      * Using this function in any other way is effectively circumventing the admin
1027      * system imposed by {AccessControl}.
1028      * ====
1029      */
1030     function _setupRole(bytes32 role, address account) internal virtual {
1031         _grantRole(role, account);
1032     }
1033 
1034     /**
1035      * @dev Sets `adminRole` as ``role``'s admin role.
1036      */
1037     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1038         _roles[role].adminRole = adminRole;
1039     }
1040 
1041     function _grantRole(bytes32 role, address account) private {
1042         if (_roles[role].members.add(account)) {
1043             emit RoleGranted(role, account, _msgSender());
1044         }
1045     }
1046 
1047     function _revokeRole(bytes32 role, address account) private {
1048         if (_roles[role].members.remove(account)) {
1049             emit RoleRevoked(role, account, _msgSender());
1050         }
1051     }
1052 }
1053 
1054 // SPDX-License-Identifier: MIT
1055 /**
1056  * @dev Contract module that helps prevent reentrant calls to a function.
1057  *
1058  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1059  * available, which can be applied to functions to make sure there are no nested
1060  * (reentrant) calls to them.
1061  *
1062  * Note that because there is a single `nonReentrant` guard, functions marked as
1063  * `nonReentrant` may not call one another. This can be worked around by making
1064  * those functions `private`, and then adding `external` `nonReentrant` entry
1065  * points to them.
1066  *
1067  * TIP: If you would like to learn more about reentrancy and alternative ways
1068  * to protect against it, check out our blog post
1069  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1070  */
1071 contract ReentrancyGuard {
1072     bool private _notEntered;
1073 
1074     constructor () internal {
1075         // Storing an initial non-zero value makes deployment a bit more
1076         // expensive, but in exchange the refund on every call to nonReentrant
1077         // will be lower in amount. Since refunds are capped to a percetange of
1078         // the total transaction's gas, it is best to keep them low in cases
1079         // like this one, to increase the likelihood of the full refund coming
1080         // into effect.
1081         _notEntered = true;
1082     }
1083 
1084     /**
1085      * @dev Prevents a contract from calling itself, directly or indirectly.
1086      * Calling a `nonReentrant` function from another `nonReentrant`
1087      * function is not supported. It is possible to prevent this from happening
1088      * by making the `nonReentrant` function external, and make it call a
1089      * `private` function that does the actual work.
1090      */
1091     modifier nonReentrant() {
1092         // On the first call to nonReentrant, _notEntered will be true
1093         require(_notEntered, "ReentrancyGuard: reentrant call");
1094 
1095         // Any calls to nonReentrant after this point will fail
1096         _notEntered = false;
1097 
1098         _;
1099 
1100         // By storing the original value once again, a refund is triggered (see
1101         // https://eips.ethereum.org/EIPS/eip-2200)
1102         _notEntered = true;
1103     }
1104 }
1105 
1106 library WhitelistLib {
1107     struct AllowedAddress {
1108         bool tradeable;
1109         uint256 lockPeriod;
1110         uint256 dailyLimit;
1111         uint256 dailyLimitToday;
1112         uint256 addedAt;
1113         uint256 recordTime;
1114     }
1115 }
1116 
1117 contract HexWhitelist is AccessControl, ReentrancyGuard {
1118     bytes32 public constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");
1119 
1120     uint256 public constant SECONDS_IN_DAY = 86400;
1121 
1122     using WhitelistLib for WhitelistLib.AllowedAddress;
1123 
1124     mapping(address => WhitelistLib.AllowedAddress) internal exchanges;
1125     mapping(address => WhitelistLib.AllowedAddress) internal dapps;
1126     mapping(address => WhitelistLib.AllowedAddress) internal referrals;
1127 
1128     uint256 internal whitelistRecordTime;
1129 
1130     modifier onlyAdminOrDeployerRole() {
1131         bool hasAdminRole = hasRole(DEFAULT_ADMIN_ROLE, _msgSender());
1132         bool hasDeployerRole = hasRole(DEPLOYER_ROLE, _msgSender());
1133         require(hasAdminRole || hasDeployerRole, "Must have admin or deployer role");
1134         _;
1135     }
1136 
1137     constructor (address _adminAddress) public {
1138         _setupRole(DEPLOYER_ROLE, _msgSender());
1139         _setupRole(DEFAULT_ADMIN_ROLE, _adminAddress);
1140 
1141         whitelistRecordTime = SafeMath.add(block.timestamp, SafeMath.mul(1, SECONDS_IN_DAY));
1142     }
1143     function registerExchangeTradeable(address _address, uint256 dailyLimit) public onlyAdminOrDeployerRole {
1144         _registerExchange(_address, true, 0, dailyLimit);
1145     }
1146 
1147     function registerDappTradeable(address _address, uint256 dailyLimit) public onlyAdminOrDeployerRole {
1148         _registerDapp(_address, true, 0, dailyLimit);
1149     }
1150 
1151     function registerReferralTradeable(address _address, uint256 dailyLimit) public onlyAdminOrDeployerRole {
1152         _registerReferral(_address, true, 0, dailyLimit);
1153     }
1154 
1155     function registerExchangeNonTradeable(address _address, uint256 dailyLimit, uint256 lockPeriod) public onlyAdminOrDeployerRole {
1156         _registerExchange(_address, false, lockPeriod, dailyLimit);
1157     }
1158 
1159     function registerDappNonTradeable(address _address, uint256 dailyLimit, uint256 lockPeriod) public onlyAdminOrDeployerRole {
1160         _registerDapp(_address, false, lockPeriod, dailyLimit);
1161     }
1162 
1163     function registerReferralNonTradeable(address _address, uint256 dailyLimit, uint256 lockPeriod) public onlyAdminOrDeployerRole {
1164         _registerReferral(_address, false, lockPeriod, dailyLimit);
1165     }
1166 
1167 
1168     function unregisterExchange(address _address) public onlyAdminOrDeployerRole {
1169         delete exchanges[_address];
1170     }
1171 
1172     function unregisterDapp(address _address) public onlyAdminOrDeployerRole {
1173         delete dapps[_address];
1174     }
1175 
1176     function unregisterReferral(address _address) public onlyAdminOrDeployerRole {
1177         delete referrals[_address];
1178     }
1179 
1180     function setExchangepDailyLimit(address _address, uint256 _dailyLimit) public onlyAdminOrDeployerRole {
1181         exchanges[_address].dailyLimit = _dailyLimit;
1182     }
1183 
1184     function setDappDailyLimit(address _address, uint256 _dailyLimit) public onlyAdminOrDeployerRole {
1185         dapps[_address].dailyLimit = _dailyLimit;
1186     }
1187 
1188     function setReferralDailyLimit(address _address, uint256 _dailyLimit) public onlyAdminOrDeployerRole {
1189         referrals[_address].dailyLimit = _dailyLimit;
1190     }
1191 
1192     function setExchangeLockPeriod(address _address, uint256 _lockPeriod) public onlyAdminOrDeployerRole {
1193         require(!getExchangeTradeable(_address), "cannot set lock period to tradeable address");
1194         exchanges[_address].lockPeriod = _lockPeriod;
1195     }
1196 
1197     function setDappLockPeriod(address _address, uint256 _lockPeriod) public onlyAdminOrDeployerRole {
1198         require(!getExchangeTradeable(_address), "cannot set lock period to tradeable address");
1199         dapps[_address].lockPeriod = _lockPeriod;
1200     }
1201 
1202     function setReferralLockPeriod(address _address, uint256 _lockPeriod) public onlyAdminOrDeployerRole {
1203         require(!getExchangeTradeable(_address), "cannot set lock period to tradeable address");
1204         dapps[_address].lockPeriod = _lockPeriod;
1205     }
1206 
1207     function addToExchangeDailyLimit(address _address, uint256 amount) public {
1208         if (exchanges[_address].dailyLimit > 0) {
1209             if (isNewDayStarted(exchanges[_address].recordTime)) {
1210                 exchanges[_address].dailyLimitToday = 0;
1211                 exchanges[_address].recordTime = getNewRecordTime();
1212             }
1213 
1214             uint256 limitToday = dapps[_address].dailyLimitToday;
1215             require(SafeMath.add(limitToday, amount) < exchanges[_address].dailyLimit, "daily limit exceeded");
1216 
1217             exchanges[_address].dailyLimitToday = SafeMath.add(limitToday, amount);
1218         }
1219     }
1220 
1221     function addToDappDailyLimit(address _address, uint256 amount) public {
1222         if (dapps[_address].dailyLimit > 0) {
1223             if (isNewDayStarted(dapps[_address].recordTime)) {
1224                 dapps[_address].dailyLimitToday = 0;
1225                 dapps[_address].recordTime = getNewRecordTime();
1226             }
1227 
1228             uint256 limitToday = dapps[_address].dailyLimitToday;
1229             require(SafeMath.add(limitToday, amount) < dapps[_address].dailyLimit, "daily limit exceeded");
1230 
1231             dapps[_address].dailyLimitToday = SafeMath.add(limitToday, amount);
1232         }
1233     }
1234 
1235     function addToReferralDailyLimit(address _address, uint256 amount) public {
1236         if (referrals[_address].dailyLimit > 0) {
1237             if (isNewDayStarted(referrals[_address].recordTime)) {
1238                 referrals[_address].dailyLimitToday = 0;
1239                 referrals[_address].recordTime = getNewRecordTime();
1240             }
1241 
1242             uint256 limitToday = referrals[_address].dailyLimitToday;
1243             require(SafeMath.add(limitToday, amount) < referrals[_address].dailyLimit, "daily limit exceeded");
1244 
1245             referrals[_address].dailyLimitToday = SafeMath.add(limitToday, amount);
1246         }
1247     }
1248 
1249 
1250     function isRegisteredDapp(address _address) public view returns (bool) {
1251         return (dapps[_address].addedAt != 0) ? true : false;
1252     }
1253 
1254     function isRegisteredReferral(address _address) public view returns (bool) {
1255         if (dapps[_address].addedAt != 0) {
1256             return true;
1257         } else {
1258             return false;
1259         }
1260     }
1261 
1262     function isRegisteredDappOrReferral(address executionAddress) public view returns (bool) {
1263         if (isRegisteredDapp(executionAddress) || isRegisteredReferral(executionAddress)) {
1264             return true;
1265         } else {
1266             return false;
1267         }
1268     }
1269 
1270     function isRegisteredExchange(address _address) public view returns (bool) {
1271         if (exchanges[_address].addedAt != 0) {
1272             return true;
1273         } else {
1274             return false;
1275         }
1276     }
1277 
1278     function getExchangeTradeable(address _address) public view returns (bool) {
1279         return exchanges[_address].tradeable;
1280     }
1281 
1282     function getDappTradeable(address _address) public view returns (bool) {
1283         return dapps[_address].tradeable;
1284     }
1285 
1286     function getReferralTradeable(address _address) public view returns (bool) {
1287         return referrals[_address].tradeable;
1288     }
1289 
1290     function getDappOrReferralTradeable(address _address) public view returns (bool) {
1291         if (isRegisteredDapp(_address)) {
1292             return dapps[_address].tradeable;
1293         } else {
1294             return referrals[_address].tradeable;
1295         }
1296     }
1297 
1298     function getExchangeLockPeriod(address _address) public view returns (uint256) {
1299         return exchanges[_address].lockPeriod;
1300     }
1301 
1302     function getDappLockPeriod(address _address) public view returns (uint256) {
1303         return dapps[_address].lockPeriod;
1304     }
1305 
1306     function getReferralLockPeriod(address _address) public view returns (uint256) {
1307         return referrals[_address].lockPeriod;
1308     }
1309 
1310     function getDappOrReferralLockPeriod(address _address) public view returns (uint256) {
1311         if (isRegisteredDapp(_address)) {
1312             return dapps[_address].lockPeriod;
1313         } else {
1314             return referrals[_address].lockPeriod;
1315         }
1316     }
1317 
1318     function getDappDailyLimit(address _address) public view returns (uint256) {
1319         return dapps[_address].dailyLimit;
1320     }
1321 
1322     function getReferralDailyLimit(address _address) public view returns (uint256) {
1323         return referrals[_address].dailyLimit;
1324     }
1325 
1326     function getDappOrReferralDailyLimit(address _address) public view returns (uint256) {
1327         if (isRegisteredDapp(_address)) {
1328             return dapps[_address].dailyLimit;
1329         } else {
1330             return referrals[_address].dailyLimit;
1331         }
1332     }
1333     function getExchangeTodayMinted(address _address) public view returns (uint256) {
1334         return exchanges[_address].dailyLimitToday;
1335     }
1336 
1337     function getDappTodayMinted(address _address) public view returns (uint256) {
1338         return dapps[_address].dailyLimitToday;
1339     }
1340 
1341     function getReferralTodayMinted(address _address) public view returns (uint256) {
1342         return referrals[_address].dailyLimitToday;
1343     }
1344 
1345     function getExchangeRecordTimed(address _address) public view returns (uint256) {
1346         return exchanges[_address].recordTime;
1347     }
1348 
1349     function getDappRecordTimed(address _address) public view returns (uint256) {
1350         return dapps[_address].recordTime;
1351     }
1352 
1353     function getReferralRecordTimed(address _address) public view returns (uint256) {
1354         return referrals[_address].recordTime;
1355     }
1356 
1357     function getNewRecordTime() internal view returns (uint256) {
1358         return SafeMath.add(block.timestamp, SafeMath.mul(1, SECONDS_IN_DAY));
1359     }
1360 
1361     function isNewDayStarted(uint256 oldRecordTime) internal view returns (bool) {
1362         return block.timestamp > oldRecordTime ? true : false;
1363     }
1364 
1365     function _registerExchange(address _address, bool tradeable, uint256 lockPeriod, uint256 dailyLimit) internal
1366     {
1367         require(!isRegisteredDappOrReferral(_address), "address already registered as dapp or referral");
1368         require(!isRegisteredExchange(_address), "exchange already registered");
1369         exchanges[_address] = WhitelistLib.AllowedAddress({
1370             tradeable: tradeable,
1371             lockPeriod: lockPeriod,
1372             dailyLimit: dailyLimit,
1373             dailyLimitToday: 0,
1374             addedAt: block.timestamp,
1375             recordTime: getNewRecordTime()
1376             });
1377     }
1378 
1379     function _registerDapp(address _address, bool tradeable, uint256 lockPeriod, uint256 dailyLimit) internal
1380     {
1381         require(!isRegisteredExchange(_address) && !isRegisteredReferral(_address), "address already registered as exchange or referral");
1382         require(!isRegisteredDapp(_address), "address already registered");
1383         dapps[_address] = WhitelistLib.AllowedAddress({
1384             tradeable: tradeable,
1385             lockPeriod: lockPeriod,
1386             dailyLimit: dailyLimit,
1387             dailyLimitToday: 0,
1388             addedAt: block.timestamp,
1389             recordTime: getNewRecordTime()
1390             });
1391     }
1392 
1393     function _registerReferral(address _address, bool tradeable, uint256 lockPeriod, uint256 dailyLimit) internal
1394     {
1395         require(!isRegisteredExchange(_address) && !isRegisteredDapp(_address), "address already registered as exchange or referral");
1396         require(!isRegisteredReferral(_address), "address already registered");
1397         referrals[_address] = WhitelistLib.AllowedAddress({
1398             tradeable: tradeable,
1399             lockPeriod: lockPeriod,
1400             dailyLimit: dailyLimit,
1401             dailyLimitToday: 0,
1402             addedAt: block.timestamp,
1403             recordTime: getNewRecordTime()
1404             });
1405     }
1406 }
1407 
1408 contract HexMoneyInternal is AccessControl, ReentrancyGuard {
1409     bytes32 public constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");
1410 
1411     // production
1412     uint256 public constant SECONDS_IN_DAY = 86400;
1413 
1414     HexWhitelist internal whitelist;
1415 
1416     modifier onlyAdminOrDeployerRole() {
1417         bool hasAdminRole = hasRole(DEFAULT_ADMIN_ROLE, _msgSender());
1418         bool hasDeployerRole = hasRole(DEPLOYER_ROLE, _msgSender());
1419         require(hasAdminRole || hasDeployerRole, "Must have admin or deployer role");
1420         _;
1421     }
1422 
1423     function getWhitelistAddress() public view returns (address) {
1424         return address(whitelist);
1425     }
1426 
1427 }
1428 
1429 /**
1430  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1431  */
1432 abstract contract ERC20FreezableCapped is ERC20, HexMoneyInternal {
1433     uint256 public constant MINIMAL_FREEZE_PERIOD = 7;    // 7 days
1434 
1435     // freezing chains
1436     mapping (bytes32 => uint256) internal chains;
1437     // freezing amounts for each chain
1438     //mapping (bytes32 => uint) internal freezings;
1439     mapping(bytes32 => Freezing) internal freezings;
1440     // total freezing balance per address
1441     mapping (address => uint) internal freezingBalance;
1442 
1443     mapping(address => bytes32[]) internal freezingsByUser;
1444 
1445     mapping (address => uint256) internal latestFreezingTime;
1446 
1447     struct Freezing {
1448         address user;
1449         uint256 startDate;
1450         uint256 freezeDays;
1451         uint256 freezeAmount;
1452         bool capitalized;
1453     }
1454 
1455 
1456 
1457     event Freezed(address indexed to, uint256 release, uint amount);
1458     event Released(address indexed owner, uint amount);
1459 
1460     uint256 private _cap;
1461 
1462     /**
1463      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1464      * set once during construction.
1465      */
1466     constructor (uint256 cap) public {
1467         require(cap > 0, "ERC20Capped: cap is 0");
1468         _cap = cap;
1469     }
1470 
1471     /**
1472      * @dev Gets the balance of the specified address include freezing tokens.
1473      * @param account The address to query the the balance of.
1474      * @return balance An uint256 representing the amount owned by the passed address.
1475      */
1476     function balanceOf(address account) public view virtual override returns (uint256) {
1477         return super.balanceOf(account) + freezingBalance[account];
1478     }
1479 
1480     /**
1481      * @dev Gets the balance of the specified address without freezing tokens.
1482      * @param account The address to query the the balance of.
1483      * @return balance An uint256 representing the amount owned by the passed address.
1484      */
1485     function actualBalanceOf(address account) public view returns (uint256 balance) {
1486         return super.balanceOf(account);
1487     }
1488 
1489     function freezingBalanceOf(address account) public view returns (uint256 balance) {
1490         return freezingBalance[account];
1491     }
1492 
1493     function latestFreezeTimeOf(address account) public view returns (uint256) {
1494         return latestFreezingTime[account];
1495     }
1496 
1497     /**
1498      * @dev Returns the cap on the token's total supply.
1499      */
1500     function cap() public view returns (uint256) {
1501         return _cap;
1502     }
1503     
1504     function getUserFreezings(address _user) public view returns (bytes32[] memory userFreezings) {
1505         return freezingsByUser[_user];
1506     }
1507 
1508     function getFreezingById(bytes32 freezingId)
1509         public
1510         view
1511         returns (address user, uint256 startDate, uint256 freezeDays, uint256 freezeAmount, bool capitalized)
1512     {
1513         Freezing memory userFreeze = freezings[freezingId];
1514         user = userFreeze.user;
1515         startDate = userFreeze.startDate;
1516         freezeDays = userFreeze.freezeDays;
1517         freezeAmount = userFreeze.freezeAmount;
1518         capitalized = userFreeze.capitalized;
1519     }
1520 
1521 
1522     function freeze(address _to, uint256 _start, uint256 _freezeDays, uint256 _amount) internal {
1523         require(_to != address(0x0), "FreezeContract: address cannot be zero");
1524         require(_start >= block.timestamp, "FreezeContract: start date cannot be in past");
1525         require(_freezeDays >= 0, "FreezeContract: amount of freeze days cannot be zero");
1526         require(_amount <= _balances[_msgSender()], "FreezeContract: freeze amount exceeds unfrozen balance");
1527 
1528         Freezing memory userFreeze = Freezing({
1529             user: _to,
1530             startDate: _start,
1531             freezeDays: _freezeDays,
1532             freezeAmount: _amount,
1533             capitalized: false
1534         });
1535 
1536         bytes32 freezeId = _toFreezeKey(_to, _start);
1537 
1538         _balances[_msgSender()] = _balances[_msgSender()].sub(_amount);
1539         freezingBalance[_to] = freezingBalance[_to].add(_amount);
1540 
1541         freezings[freezeId] = userFreeze;
1542         freezingsByUser[_to].push(freezeId);
1543         latestFreezingTime[_to] = _start;
1544 
1545         emit Transfer(_msgSender(), _to, _amount);
1546         emit Freezed(_to, _start, _amount);
1547     }
1548 
1549     function mintAndFreeze(address _to, uint256 _start, uint256 _freezeDays, uint256 _amount) internal {
1550         require(_to != address(0x0), "FreezeContract: address cannot be zero");
1551         require(_start >= block.timestamp, "FreezeContract: start date cannot be in past");
1552         require(_freezeDays >= 0, "FreezeContract: amount of freeze days cannot be zero");
1553 
1554         Freezing memory userFreeze = Freezing({
1555             user: _to,
1556             startDate: _start,
1557             freezeDays: _freezeDays,
1558             freezeAmount: _amount,
1559             capitalized: false
1560         });
1561 
1562         bytes32 freezeId = _toFreezeKey(_to, _start);
1563 
1564         freezingBalance[_to] = freezingBalance[_to].add(_amount);
1565 
1566         freezings[freezeId] = userFreeze;
1567         freezingsByUser[_to].push(freezeId);
1568         latestFreezingTime[_to] = _start;
1569 
1570         _totalSupply = _totalSupply.add(_amount);
1571 
1572         emit Transfer(_msgSender(), _to, _amount);
1573         emit Freezed(_to, _start, _amount);
1574     }
1575 
1576     function _toFreezeKey(address _user, uint256 _startDate) internal pure returns (bytes32) {
1577         return keccak256(abi.encodePacked(_user, _startDate));
1578     }
1579 
1580     function release(uint256 _startTime) internal {
1581         bytes32 freezeId = _toFreezeKey(_msgSender(), _startTime);
1582         Freezing memory userFreeze = freezings[freezeId];
1583 
1584         uint256 lockUntil = _daysToTimestampFrom(userFreeze.startDate, userFreeze.freezeDays);
1585         require(block.timestamp >= lockUntil, "cannot release before lock");
1586 
1587         uint256 amount = userFreeze.freezeAmount;
1588 
1589         _balances[_msgSender()] = _balances[_msgSender()].add(amount);
1590         freezingBalance[_msgSender()] = freezingBalance[_msgSender()].sub(amount);
1591 
1592         _deleteFreezing(freezeId, freezingsByUser[_msgSender()]);
1593 
1594         emit Released(_msgSender(), amount);
1595     }
1596 
1597     function refreeze(uint256 _startTime, uint256 addAmount) internal {
1598         bytes32 freezeId = _toFreezeKey(_msgSender(), _startTime);
1599         Freezing storage userFreeze = freezings[freezeId];
1600 
1601         uint256 lockUntil;
1602         if (!userFreeze.capitalized) {
1603             lockUntil = _daysToTimestampFrom(userFreeze.startDate, userFreeze.freezeDays);
1604         } else {
1605             lockUntil = _daysToTimestampFrom(userFreeze.startDate, 1);
1606         }
1607 
1608         require(block.timestamp >= lockUntil, "cannot refreeze before lock");
1609 
1610         bytes32 newFreezeId = _toFreezeKey(userFreeze.user, block.timestamp);
1611         uint256 oldFreezeAmount = userFreeze.freezeAmount;
1612         uint256 newFreezeAmount = SafeMath.add(userFreeze.freezeAmount, addAmount);
1613 
1614         Freezing memory newFreeze = Freezing({
1615             user: userFreeze.user,
1616             startDate: block.timestamp,
1617             freezeDays: userFreeze.freezeDays,
1618             freezeAmount: newFreezeAmount,
1619             capitalized: true
1620         });
1621 
1622         freezingBalance[_msgSender()] = freezingBalance[_msgSender()].add(addAmount);
1623 
1624         freezings[newFreezeId] = newFreeze;
1625         freezingsByUser[userFreeze.user].push(newFreezeId);
1626         latestFreezingTime[userFreeze.user] = block.timestamp;
1627 
1628         _deleteFreezing(freezeId, freezingsByUser[_msgSender()]);
1629         delete freezings[freezeId];
1630 
1631         emit Released(_msgSender(), oldFreezeAmount);
1632         emit Transfer(_msgSender(), _msgSender(), addAmount);
1633         emit Freezed(_msgSender(), block.timestamp, newFreezeAmount);
1634     }
1635 
1636     function _deleteFreezing(bytes32 freezingId, bytes32[] storage userFreezings) internal {
1637         uint256 freezingIndex;
1638         bool freezingFound;
1639         for (uint256 i; i < userFreezings.length; i++) {
1640             if (userFreezings[i] == freezingId) {
1641                 freezingIndex = i;
1642                 freezingFound = true;
1643             }
1644         }
1645 
1646         if (freezingFound) {
1647             userFreezings[freezingIndex] = userFreezings[userFreezings.length - 1];
1648             delete userFreezings[userFreezings.length - 1];
1649             userFreezings.pop();
1650         }
1651     }
1652 
1653     function _daysToTimestampFrom(uint256 from, uint256 lockDays) internal pure returns(uint256) {
1654         return SafeMath.add(from, SafeMath.mul(lockDays, SECONDS_IN_DAY));
1655     }
1656 
1657     function _daysToTimestamp(uint256 lockDays) internal view returns(uint256) {
1658         return _daysToTimestampFrom(block.timestamp, lockDays);
1659     }
1660 
1661     function _getBaseLockDays() internal view returns (uint256) {
1662         return _daysToTimestamp(MINIMAL_FREEZE_PERIOD);
1663     }
1664 
1665     function _getBaseLockDaysFrom(uint256 from) internal pure returns (uint256) {
1666         return _daysToTimestampFrom(from, MINIMAL_FREEZE_PERIOD);
1667     }
1668 
1669 
1670     /**
1671      * @dev See {ERC20-_beforeTokenTransfer}.
1672      *
1673      * Requirements:
1674      *
1675      * - minted tokens must not cause the total supply to go over the cap.
1676      */
1677     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1678         super._beforeTokenTransfer(from, to, amount);
1679 
1680         if (from == address(0)) { // When minting tokens
1681             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1682         }
1683     }
1684 }
1685 
1686 abstract contract HexMoneyTeam is AccessControl {
1687     bytes32 public constant TEAM_ROLE = keccak256("TEAM_ROLE");
1688 
1689     address payable internal teamAddress;
1690 
1691     modifier onlyTeamRole() {
1692         require(hasRole(TEAM_ROLE, _msgSender()), "Must have admin role to setup");
1693         _;
1694     }
1695 
1696     function getTeamAddress() public view returns (address) {
1697         return teamAddress;
1698     }
1699 }
1700 
1701 contract HXY is ERC20FreezableCapped, HexMoneyTeam {
1702     using WhitelistLib for WhitelistLib.AllowedAddress;
1703 
1704     uint256 internal liquidSupply = 694866350105876;
1705     uint256 internal lockedSupply = SafeMath.mul(6, 10 ** 14);
1706 
1707     uint256 internal lockedSupplyFreezingStarted;
1708 
1709     address internal lockedSupplyAddress;
1710     address internal liquidSupplyAddress;
1711 
1712     struct LockedSupplyAddresses {
1713         address firstAddress;
1714         address secondAddress;
1715         address thirdAddress;
1716         address fourthAddress;
1717         address fifthAddress;
1718         address sixthAddress;
1719     }
1720 
1721     LockedSupplyAddresses internal lockedSupplyAddresses;
1722     bool internal lockedSupplyPreminted;
1723 
1724     // total amounts variables
1725     uint256 internal totalMinted;
1726     uint256 internal totalFrozen;
1727     uint256 internal totalCirculating;
1728     uint256 internal totalPayedInterest;
1729 
1730     // round logic structures
1731     uint256 internal hxyMintedMultiplier = 10 ** 6;
1732     uint256[] internal hxyRoundMintAmount = [3, 6, 9, 12, 15, 18, 21, 24, 27];
1733     uint256 internal baseHexToHxyRate = 10 ** 3;
1734     uint256[] internal hxyRoundBaseRate = [2, 3, 4, 5, 6, 7, 8, 9, 10];
1735 
1736     uint256 internal maxHxyRounds = 9;
1737 
1738     // initial round
1739     uint256 internal currentHxyRound;
1740     uint256 internal currentHxyRoundRate = SafeMath.mul(hxyRoundBaseRate[0], baseHexToHxyRate);
1741 
1742 
1743 
1744     //constructor(address payable _teamAddress,  address _liqSupAddress, address _lockSupAddress, address _migratedSupplyAddress)
1745     constructor(address _whitelistAddress,  address _liqSupAddress, uint256 _liqSupAmount)
1746     public
1747     ERC20FreezableCapped(SafeMath.mul(60,  10 ** 14))        // cap = 60,000,000
1748     ERC20("HEX Money", "HXY")
1749     {
1750         require(address(_whitelistAddress) != address(0x0), "whitelist address should not be empty");
1751         require(address(_liqSupAddress) != address(0x0), "liquid supply address should not be empty");
1752         _setupDecimals(8);
1753 
1754         _setupRole(DEPLOYER_ROLE, _msgSender());
1755 
1756 
1757         whitelist = HexWhitelist(_whitelistAddress);
1758         _premintLiquidSupply(_liqSupAddress, _liqSupAmount);
1759     }
1760 
1761     function getRemainingHxyInRound() public view returns (uint256) {
1762         return _getRemainingHxyInRound(currentHxyRound);
1763     }
1764 
1765     function getTotalHxyInRound() public view returns (uint256) {
1766         return _getTotalHxyInRound(currentHxyRound);
1767     }
1768 
1769     function getTotalHxyMinted() public view returns (uint256) {
1770         return totalMinted;
1771     }
1772 
1773     function getCirculatingSupply() public view returns (uint256) {
1774         return totalCirculating;
1775     }
1776 
1777     function getCurrentHxyRound() public view returns (uint256) {
1778         return currentHxyRound;
1779     }
1780 
1781     function getCurrentHxyRate() public view returns (uint256) {
1782         return currentHxyRoundRate;
1783     }
1784 
1785     function getTotalFrozen() public view returns (uint256) {
1786         return totalFrozen;
1787     }
1788 
1789     function getTotalPayedInterest() public view returns (uint256) {
1790         return totalPayedInterest;
1791     }
1792 
1793 
1794     function getCurrentInterestAmount(address _addr, uint256 _freezeStartDate) public view returns (uint256) {
1795         bytes32 freezeId = _toFreezeKey(_addr, _freezeStartDate);
1796         Freezing memory userFreeze = freezings[freezeId];
1797 
1798         uint256 frozenTokens = userFreeze.freezeAmount;
1799         if (frozenTokens != 0) {
1800             uint256 startFreezeDate = userFreeze.startDate;
1801             uint256 interestDays = SafeMath.div(SafeMath.sub(block.timestamp, startFreezeDate), SECONDS_IN_DAY);
1802             return SafeMath.mul(SafeMath.div(frozenTokens, 1000), interestDays);
1803         } else {
1804             return 0;
1805         }
1806     }
1807 
1808     function mintFromExchange(address account, uint256 amount) public {
1809         address executionAddress = _msgSender();
1810         require(whitelist.isRegisteredExchange(executionAddress), "must be executed from whitelisted dapp");
1811         whitelist.addToExchangeDailyLimit(executionAddress, amount);
1812 
1813         if (whitelist.getExchangeTradeable(executionAddress)) {
1814             mint(account, amount);
1815         } else {
1816             uint256 lockPeriod = whitelist.getExchangeLockPeriod(executionAddress);
1817             mintAndFreezeTo(account, amount, lockPeriod);
1818         }
1819     }
1820 
1821     function mintFromDappOrReferral(address account, uint256 amount) public {
1822         address executionAddress = _msgSender();
1823         require(whitelist.isRegisteredDappOrReferral(executionAddress), "must be executed from whitelisted address");
1824         if (whitelist.isRegisteredDapp(executionAddress)) {
1825             whitelist.addToDappDailyLimit(executionAddress, amount);
1826         } else {
1827             whitelist.addToReferralDailyLimit(executionAddress, amount);
1828         }
1829 
1830         if (whitelist.getDappTradeable(executionAddress)) {
1831             _mintDirectly(account, amount);
1832         } else {
1833             uint256 lockPeriod = whitelist.getDappOrReferralLockPeriod(executionAddress);
1834             _mintAndFreezeDirectly(account, amount, lockPeriod);
1835         }
1836     }
1837 
1838     function freezeHxy(uint256 lockAmount) public {
1839         freeze(_msgSender(), block.timestamp, MINIMAL_FREEZE_PERIOD, lockAmount);
1840         totalFrozen = SafeMath.add(totalFrozen, lockAmount);
1841         totalCirculating = SafeMath.sub(totalCirculating, lockAmount);
1842     }
1843 
1844     function refreezeHxy(uint256 startDate) public {
1845         bytes32 freezeId = _toFreezeKey(_msgSender(), startDate);
1846         Freezing memory userFreezing = freezings[freezeId];
1847 
1848         uint256 frozenTokens = userFreezing.freezeAmount;
1849         uint256 interestDays = SafeMath.div(SafeMath.sub(block.timestamp, userFreezing.startDate), SECONDS_IN_DAY);
1850         uint256 interestAmount = SafeMath.mul(SafeMath.div(frozenTokens, 1000), interestDays);
1851 
1852         refreeze(startDate, interestAmount);
1853         totalFrozen = SafeMath.add(totalFrozen, interestAmount);
1854     }
1855 
1856     function releaseFrozen(uint256 _startDate) public {
1857         bytes32 freezeId = _toFreezeKey(_msgSender(), _startDate);
1858         Freezing memory userFreezing = freezings[freezeId];
1859 
1860         uint256 frozenTokens = userFreezing.freezeAmount;
1861 
1862         release(_startDate);
1863 
1864         if (!_isLockedAddress()) {
1865             uint256 interestDays = SafeMath.div(SafeMath.sub(block.timestamp, userFreezing.startDate), SECONDS_IN_DAY);
1866             uint256 interestAmount = SafeMath.mul(SafeMath.div(frozenTokens, 1000), interestDays);
1867             _mint(_msgSender(), interestAmount);
1868 
1869             totalFrozen = SafeMath.sub(totalFrozen, frozenTokens);
1870             totalCirculating = SafeMath.add(totalCirculating, frozenTokens);
1871             totalPayedInterest = SafeMath.add(totalPayedInterest, interestAmount);
1872         }
1873     }
1874 
1875     function mint(address _to, uint256 _amount) internal {
1876         _preprocessMint(_to, _amount);
1877     }
1878 
1879     function mintAndFreezeTo(address _to, uint _amount, uint256 _lockDays) internal {
1880         _preprocessMintWithFreeze(_to, _amount, _lockDays);
1881     }
1882 
1883     function _premintLiquidSupply(address _liqSupAddress, uint256 _liqSupAmount) internal {
1884         require(_liqSupAddress != address(0x0), "liquid supply address cannot be zero");
1885         require(_liqSupAmount != 0, "liquid supply amount cannot be zero");
1886         liquidSupplyAddress = _liqSupAddress;
1887         liquidSupply = _liqSupAmount;
1888         _mint(_liqSupAddress, _liqSupAmount);
1889     }
1890 
1891     function premintLocked(address[6] memory _lockSupAddresses,  uint256[10] memory _unlockDates) public {
1892         require(hasRole(DEPLOYER_ROLE, _msgSender()), "Must have deployer role");
1893         require(!lockedSupplyPreminted, "cannot premint locked twice");
1894         _premintLockedSupply(_lockSupAddresses, _unlockDates);
1895     }
1896 
1897     function _premintLockedSupply(address[6] memory _lockSupAddresses, uint256[10] memory _unlockDates) internal {
1898 
1899         lockedSupplyAddresses.firstAddress = _lockSupAddresses[0];
1900         lockedSupplyAddresses.secondAddress = _lockSupAddresses[1];
1901         lockedSupplyAddresses.thirdAddress = _lockSupAddresses[2];
1902         lockedSupplyAddresses.fourthAddress = _lockSupAddresses[3];
1903         lockedSupplyAddresses.fifthAddress = _lockSupAddresses[4];
1904         lockedSupplyAddresses.sixthAddress = _lockSupAddresses[4];
1905 
1906         for (uint256 i = 0; i < 10; i++) {
1907             uint256 startDate = SafeMath.add(block.timestamp, SafeMath.add(i, 5));
1908 
1909             uint256 endFreezeDate = _unlockDates[i];
1910             uint256 lockSeconds = SafeMath.sub(endFreezeDate, startDate);
1911             uint256 lockDays = SafeMath.div(lockSeconds, SECONDS_IN_DAY);
1912 
1913 
1914             uint256 firstSecondAmount = SafeMath.mul(180000, 10 ** uint256(decimals()));
1915             uint256 thirdAmount = SafeMath.mul(120000, 10 ** uint256(decimals()));
1916             uint256 fourthAmount = SafeMath.mul(90000, 10 ** uint256(decimals()));
1917             uint256 fifthSixthAmount = SafeMath.mul(15000, 10 ** uint256(decimals()));
1918 
1919             mintAndFreeze(lockedSupplyAddresses.firstAddress, startDate, lockDays, firstSecondAmount);
1920             mintAndFreeze(lockedSupplyAddresses.secondAddress, startDate, lockDays, firstSecondAmount);
1921             mintAndFreeze(lockedSupplyAddresses.thirdAddress, startDate, lockDays, thirdAmount);
1922             mintAndFreeze(lockedSupplyAddresses.fourthAddress, startDate, lockDays, fourthAmount);
1923             mintAndFreeze(lockedSupplyAddresses.fifthAddress, startDate, lockDays, fifthSixthAmount);
1924             mintAndFreeze(lockedSupplyAddresses.sixthAddress, startDate, lockDays, fifthSixthAmount);
1925         }
1926 
1927         lockedSupplyPreminted = true;
1928     }
1929 
1930 
1931     function _preprocessMint(address _account, uint256 _hexAmount) internal {
1932         uint256 currentRoundHxyAmount = SafeMath.div(_hexAmount, currentHxyRoundRate);
1933         if (currentRoundHxyAmount < getRemainingHxyInRound()) {
1934             uint256 hxyAmount = currentRoundHxyAmount;
1935             _mint(_account, hxyAmount);
1936 
1937             totalMinted = SafeMath.add(totalMinted, hxyAmount);
1938             totalCirculating = SafeMath.add(totalCirculating, hxyAmount);
1939         } else if (currentRoundHxyAmount == getRemainingHxyInRound()) {
1940             uint256 hxyAmount = currentRoundHxyAmount;
1941             _mint(_account, hxyAmount);
1942 
1943             _incrementHxyRateRound();
1944 
1945             totalMinted = SafeMath.add(totalMinted, hxyAmount);
1946             totalCirculating = SafeMath.add(totalCirculating, hxyAmount);
1947         } else {
1948             uint256 hxyAmount;
1949             uint256 hexPaymentAmount;
1950             while (hexPaymentAmount < _hexAmount) {
1951                 uint256 hxyRoundTotal = SafeMath.mul(_toDecimals(hxyRoundMintAmount[currentHxyRound]), hxyMintedMultiplier);
1952 
1953                 uint256 hxyInCurrentRoundMax = SafeMath.sub(hxyRoundTotal, totalMinted);
1954                 uint256 hexInCurrentRoundMax = SafeMath.mul(hxyInCurrentRoundMax, currentHxyRoundRate);
1955 
1956                 uint256 hexInCurrentRound;
1957                 uint256 hxyInCurrentRound;
1958                 if (SafeMath.sub(_hexAmount, hexPaymentAmount) < hexInCurrentRoundMax) {
1959                     hexInCurrentRound = SafeMath.sub(_hexAmount, hexPaymentAmount);
1960                     hxyInCurrentRound = SafeMath.div(hexInCurrentRound, currentHxyRoundRate);
1961                 } else {
1962                     hexInCurrentRound = hexInCurrentRoundMax;
1963                     hxyInCurrentRound = hxyInCurrentRoundMax;
1964 
1965                     _incrementHxyRateRound();
1966                 }
1967 
1968                 hxyAmount = SafeMath.add(hxyAmount, hxyInCurrentRound);
1969                 hexPaymentAmount = SafeMath.add(hexPaymentAmount, hexInCurrentRound);
1970 
1971                 totalMinted = SafeMath.add(totalMinted, hxyInCurrentRound);
1972                 totalCirculating = SafeMath.add(totalCirculating, hxyAmount);
1973             }
1974             _mint(_account, hxyAmount);
1975         }
1976     }
1977 
1978     function _preprocessMintWithFreeze(address _account, uint256 _hexAmount, uint256 _freezeDays) internal {
1979         uint256 currentRoundHxyAmount = SafeMath.div(_hexAmount, currentHxyRoundRate);
1980         if (currentRoundHxyAmount < getRemainingHxyInRound()) {
1981             uint256 hxyAmount = currentRoundHxyAmount;
1982             totalMinted = SafeMath.add(totalMinted, hxyAmount);
1983             mintAndFreeze(_account, block.timestamp, _freezeDays, hxyAmount);
1984         } else if (currentRoundHxyAmount == getRemainingHxyInRound()) {
1985             uint256 hxyAmount = currentRoundHxyAmount;
1986             mintAndFreeze(_account, block.timestamp, _freezeDays, hxyAmount);
1987 
1988             totalMinted = SafeMath.add(totalMinted, hxyAmount);
1989 
1990             _incrementHxyRateRound();
1991         } else {
1992             uint256 hxyAmount;
1993             uint256 hexPaymentAmount;
1994             while (hexPaymentAmount < _hexAmount) {
1995                 uint256 hxyRoundTotal = SafeMath.mul(_toDecimals(hxyRoundMintAmount[currentHxyRound]), hxyMintedMultiplier);
1996 
1997                 uint256 hxyInCurrentRoundMax = SafeMath.sub(hxyRoundTotal, totalMinted);
1998                 uint256 hexInCurrentRoundMax = SafeMath.mul(hxyInCurrentRoundMax, currentHxyRoundRate);
1999 
2000                 uint256 hexInCurrentRound;
2001                 uint256 hxyInCurrentRound;
2002                 if (SafeMath.sub(_hexAmount, hexPaymentAmount) < hexInCurrentRoundMax) {
2003                     hexInCurrentRound = SafeMath.sub(_hexAmount, hexPaymentAmount);
2004                     hxyInCurrentRound = SafeMath.div(hexInCurrentRound, currentHxyRoundRate);
2005                 } else {
2006                     hexInCurrentRound = hexInCurrentRoundMax;
2007                     hxyInCurrentRound = hxyInCurrentRoundMax;
2008 
2009                     _incrementHxyRateRound();
2010                 }
2011 
2012                 hxyAmount = SafeMath.add(hxyAmount, hxyInCurrentRound);
2013                 hexPaymentAmount = SafeMath.add(hexPaymentAmount, hexInCurrentRound);
2014 
2015                 totalMinted = SafeMath.add(totalMinted, hxyInCurrentRound);
2016             }
2017             mintAndFreeze(_account, block.timestamp, _freezeDays, hxyAmount);
2018         }
2019     }
2020 
2021     function _mintDirectly(address _account, uint256 _hxyAmount) internal {
2022         _mint(_account, _hxyAmount);
2023     }
2024 
2025     function _mintAndFreezeDirectly(address _account, uint256 _hxyAmount, uint256 _freezeDays) internal {
2026         mintAndFreeze(_account, block.timestamp, _freezeDays, _hxyAmount);
2027     }
2028 
2029     function _isLockedAddress() internal view returns (bool) {
2030         if (_msgSender() == lockedSupplyAddresses.firstAddress) {
2031             return true;
2032         } else if (_msgSender() == lockedSupplyAddresses.secondAddress) {
2033             return true;
2034         } else if (_msgSender() == lockedSupplyAddresses.thirdAddress) {
2035             return true;
2036         } else if (_msgSender() == lockedSupplyAddresses.fourthAddress) {
2037             return true;
2038         } else if (_msgSender() == lockedSupplyAddresses.fifthAddress) {
2039             return true;
2040         } else if (_msgSender() == lockedSupplyAddresses.sixthAddress) {
2041             return true;
2042         } else {
2043             return false;
2044         }
2045     }
2046 
2047     function _getTotalHxyInRound(uint256 _round) public view returns (uint256) {
2048         return SafeMath.mul(_toDecimals(hxyRoundMintAmount[_round]),hxyMintedMultiplier);
2049     }
2050 
2051     function _getRemainingHxyInRound(uint256 _round) public view returns (uint256) {
2052         return SafeMath.sub(SafeMath.mul(_toDecimals(hxyRoundMintAmount[_round]), hxyMintedMultiplier), totalMinted);
2053     }
2054 
2055     function _incrementHxyRateRound() internal {
2056         currentHxyRound = SafeMath.add(currentHxyRound, 1);
2057         currentHxyRoundRate = SafeMath.mul(hxyRoundBaseRate[currentHxyRound], baseHexToHxyRate);
2058     }
2059 
2060     function _toDecimals(uint256 amount) internal view returns (uint256) {
2061         return SafeMath.mul(amount, 10 ** uint256(decimals()));
2062     }
2063 }