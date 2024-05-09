1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts@3.4.0/utils/Address.sol
3 
4 
5 
6 pragma solidity >=0.6.0 <0.8.0;
7 
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
29 
30 // File: @openzeppelin/contracts@3.4.0/token/ERC20/IERC20.sol
31 
32 
33 
34 pragma solidity >=0.6.0 <0.8.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 // File: @openzeppelin/contracts@3.4.0/token/ERC20/ERC20.sol
112 
113 
114 
115 pragma solidity >=0.6.0 <0.8.0;
116 
117 
118 
119 
120 /**
121  * @dev Implementation of the {IERC20} interface.
122  *
123  * This implementation is agnostic to the way tokens are created. This means
124  * that a supply mechanism has to be added in a derived contract using {_mint}.
125  * For a generic mechanism see {ERC20PresetMinterPauser}.
126  *
127  * TIP: For a detailed writeup see our guide
128  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
129  * to implement supply mechanisms].
130  *
131  * We have followed general OpenZeppelin guidelines: functions revert instead
132  * of returning `false` on failure. This behavior is nonetheless conventional
133  * and does not conflict with the expectations of ERC20 applications.
134  *
135  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
136  * This allows applications to reconstruct the allowance for all accounts just
137  * by listening to said events. Other implementations of the EIP may not emit
138  * these events, as it isn't required by the specification.
139  *
140  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
141  * functions have been added to mitigate the well-known issues around setting
142  * allowances. See {IERC20-approve}.
143  */
144 contract ERC20 is Context, IERC20 {
145     using SafeMath for uint256;
146 
147     mapping (address => uint256) private _balances;
148 
149     mapping (address => mapping (address => uint256)) private _allowances;
150 
151     uint256 private _totalSupply;
152 
153     string private _name;
154     string private _symbol;
155     uint8 private _decimals;
156 
157     /**
158      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
159      * a default value of 18.
160      *
161      * To select a different value for {decimals}, use {_setupDecimals}.
162      *
163      * All three of these values are immutable: they can only be set once during
164      * construction.
165      */
166     constructor (string memory name_, string memory symbol_) public {
167         _name = name_;
168         _symbol = symbol_;
169         _decimals = 18;
170     }
171 
172     /**
173      * @dev Returns the name of the token.
174      */
175     function name() public view virtual returns (string memory) {
176         return _name;
177     }
178 
179     /**
180      * @dev Returns the symbol of the token, usually a shorter version of the
181      * name.
182      */
183     function symbol() public view virtual returns (string memory) {
184         return _symbol;
185     }
186 
187     /**
188      * @dev Returns the number of decimals used to get its user representation.
189      * For example, if `decimals` equals `2`, a balance of `505` tokens should
190      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
191      *
192      * Tokens usually opt for a value of 18, imitating the relationship between
193      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
194      * called.
195      *
196      * NOTE: This information is only used for _display_ purposes: it in
197      * no way affects any of the arithmetic of the contract, including
198      * {IERC20-balanceOf} and {IERC20-transfer}.
199      */
200     function decimals() public view virtual returns (uint8) {
201         return _decimals;
202     }
203 
204     /**
205      * @dev See {IERC20-totalSupply}.
206      */
207     function totalSupply() public view virtual override returns (uint256) {
208         return _totalSupply;
209     }
210 
211     /**
212      * @dev See {IERC20-balanceOf}.
213      */
214     function balanceOf(address account) public view virtual override returns (uint256) {
215         return _balances[account];
216     }
217 
218     /**
219      * @dev See {IERC20-transfer}.
220      *
221      * Requirements:
222      *
223      * - `recipient` cannot be the zero address.
224      * - the caller must have a balance of at least `amount`.
225      */
226     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
227         _transfer(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     /**
232      * @dev See {IERC20-allowance}.
233      */
234     function allowance(address owner, address spender) public view virtual override returns (uint256) {
235         return _allowances[owner][spender];
236     }
237 
238     /**
239      * @dev See {IERC20-approve}.
240      *
241      * Requirements:
242      *
243      * - `spender` cannot be the zero address.
244      */
245     function approve(address spender, uint256 amount) public virtual override returns (bool) {
246         _approve(_msgSender(), spender, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See {IERC20-transferFrom}.
252      *
253      * Emits an {Approval} event indicating the updated allowance. This is not
254      * required by the EIP. See the note at the beginning of {ERC20}.
255      *
256      * Requirements:
257      *
258      * - `sender` and `recipient` cannot be the zero address.
259      * - `sender` must have a balance of at least `amount`.
260      * - the caller must have allowance for ``sender``'s tokens of at least
261      * `amount`.
262      */
263     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
264         _transfer(sender, recipient, amount);
265         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
266         return true;
267     }
268 
269     /**
270      * @dev Atomically increases the allowance granted to `spender` by the caller.
271      *
272      * This is an alternative to {approve} that can be used as a mitigation for
273      * problems described in {IERC20-approve}.
274      *
275      * Emits an {Approval} event indicating the updated allowance.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
282         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
283         return true;
284     }
285 
286     /**
287      * @dev Atomically decreases the allowance granted to `spender` by the caller.
288      *
289      * This is an alternative to {approve} that can be used as a mitigation for
290      * problems described in {IERC20-approve}.
291      *
292      * Emits an {Approval} event indicating the updated allowance.
293      *
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      * - `spender` must have allowance for the caller of at least
298      * `subtractedValue`.
299      */
300     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
301         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
302         return true;
303     }
304 
305     /**
306      * @dev Moves tokens `amount` from `sender` to `recipient`.
307      *
308      * This is internal function is equivalent to {transfer}, and can be used to
309      * e.g. implement automatic token fees, slashing mechanisms, etc.
310      *
311      * Emits a {Transfer} event.
312      *
313      * Requirements:
314      *
315      * - `sender` cannot be the zero address.
316      * - `recipient` cannot be the zero address.
317      * - `sender` must have a balance of at least `amount`.
318      */
319     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
320         require(sender != address(0), "ERC20: transfer from the zero address");
321         require(recipient != address(0), "ERC20: transfer to the zero address");
322 
323         _beforeTokenTransfer(sender, recipient, amount);
324 
325         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
326         _balances[recipient] = _balances[recipient].add(amount);
327         emit Transfer(sender, recipient, amount);
328     }
329 
330     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
331      * the total supply.
332      *
333      * Emits a {Transfer} event with `from` set to the zero address.
334      *
335      * Requirements:
336      *
337      * - `to` cannot be the zero address.
338      */
339     function _mint(address account, uint256 amount) internal virtual {
340         require(account != address(0), "ERC20: mint to the zero address");
341 
342         _beforeTokenTransfer(address(0), account, amount);
343 
344         _totalSupply = _totalSupply.add(amount);
345         _balances[account] = _balances[account].add(amount);
346         emit Transfer(address(0), account, amount);
347     }
348 
349     /**
350      * @dev Destroys `amount` tokens from `account`, reducing the
351      * total supply.
352      *
353      * Emits a {Transfer} event with `to` set to the zero address.
354      *
355      * Requirements:
356      *
357      * - `account` cannot be the zero address.
358      * - `account` must have at least `amount` tokens.
359      */
360     function _burn(address account, uint256 amount) internal virtual {
361         require(account != address(0), "ERC20: burn from the zero address");
362 
363         _beforeTokenTransfer(account, address(0), amount);
364 
365         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
366         _totalSupply = _totalSupply.sub(amount);
367         emit Transfer(account, address(0), amount);
368     }
369 
370     /**
371      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
372      *
373      * This internal function is equivalent to `approve`, and can be used to
374      * e.g. set automatic allowances for certain subsystems, etc.
375      *
376      * Emits an {Approval} event.
377      *
378      * Requirements:
379      *
380      * - `owner` cannot be the zero address.
381      * - `spender` cannot be the zero address.
382      */
383     function _approve(address owner, address spender, uint256 amount) internal virtual {
384         require(owner != address(0), "ERC20: approve from the zero address");
385         require(spender != address(0), "ERC20: approve to the zero address");
386 
387         _allowances[owner][spender] = amount;
388         emit Approval(owner, spender, amount);
389     }
390 
391     /**
392      * @dev Sets {decimals} to a value other than the default one of 18.
393      *
394      * WARNING: This function should only be called from the constructor. Most
395      * applications that interact with token contracts will not expect
396      * {decimals} to ever change, and may work incorrectly if it does.
397      */
398     function _setupDecimals(uint8 decimals_) internal virtual {
399         _decimals = decimals_;
400     }
401 
402     /**
403      * @dev Hook that is called before any transfer of tokens. This includes
404      * minting and burning.
405      *
406      * Calling conditions:
407      *
408      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
409      * will be to transferred to `to`.
410      * - when `from` is zero, `amount` tokens will be minted for `to`.
411      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
412      * - `from` and `to` are never both zero.
413      *
414      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
415      */
416     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
417 }
418 
419 
420 pragma solidity >=0.6.2 <0.8.0;
421 
422 /**
423  * @dev Collection of functions related to the address type
424  */
425 library Address {
426     /**
427      * @dev Returns true if `account` is a contract.
428      *
429      * [IMPORTANT]
430      * ====
431      * It is unsafe to assume that an address for which this function returns
432      * false is an externally-owned account (EOA) and not a contract.
433      *
434      * Among others, `isContract` will return false for the following
435      * types of addresses:
436      *
437      *  - an externally-owned account
438      *  - a contract in construction
439      *  - an address where a contract will be created
440      *  - an address where a contract lived, but was destroyed
441      * ====
442      */
443     function isContract(address account) internal view returns (bool) {
444         // This method relies on extcodesize, which returns 0 for contracts in
445         // construction, since the code is only stored at the end of the
446         // constructor execution.
447 
448         uint256 size;
449         // solhint-disable-next-line no-inline-assembly
450         assembly { size := extcodesize(account) }
451         return size > 0;
452     }
453 
454     /**
455      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
456      * `recipient`, forwarding all available gas and reverting on errors.
457      *
458      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
459      * of certain opcodes, possibly making contracts go over the 2300 gas limit
460      * imposed by `transfer`, making them unable to receive funds via
461      * `transfer`. {sendValue} removes this limitation.
462      *
463      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
464      *
465      * IMPORTANT: because control is transferred to `recipient`, care must be
466      * taken to not create reentrancy vulnerabilities. Consider using
467      * {ReentrancyGuard} or the
468      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
469      */
470     function sendValue(address payable recipient, uint256 amount) internal {
471         require(address(this).balance >= amount, "Address: insufficient balance");
472 
473         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
474         (bool success, ) = recipient.call{ value: amount }("");
475         require(success, "Address: unable to send value, recipient may have reverted");
476     }
477 
478     /**
479      * @dev Performs a Solidity function call using a low level `call`. A
480      * plain`call` is an unsafe replacement for a function call: use this
481      * function instead.
482      *
483      * If `target` reverts with a revert reason, it is bubbled up by this
484      * function (like regular Solidity function calls).
485      *
486      * Returns the raw returned data. To convert to the expected return value,
487      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
488      *
489      * Requirements:
490      *
491      * - `target` must be a contract.
492      * - calling `target` with `data` must not revert.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
497       return functionCall(target, data, "Address: low-level call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
502      * `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, 0, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but also transferring `value` wei to `target`.
513      *
514      * Requirements:
515      *
516      * - the calling contract must have an ETH balance of at least `value`.
517      * - the called Solidity function must be `payable`.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
522         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
527      * with `errorMessage` as a fallback revert reason when `target` reverts.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
532         require(address(this).balance >= value, "Address: insufficient balance for call");
533         require(isContract(target), "Address: call to non-contract");
534 
535         // solhint-disable-next-line avoid-low-level-calls
536         (bool success, bytes memory returndata) = target.call{ value: value }(data);
537         return _verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
547         return functionStaticCall(target, data, "Address: low-level static call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
552      * but performing a static call.
553      *
554      * _Available since v3.3._
555      */
556     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
557         require(isContract(target), "Address: static call to non-contract");
558 
559         // solhint-disable-next-line avoid-low-level-calls
560         (bool success, bytes memory returndata) = target.staticcall(data);
561         return _verifyCallResult(success, returndata, errorMessage);
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
566      * but performing a delegate call.
567      *
568      * _Available since v3.4._
569      */
570     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
571         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
576      * but performing a delegate call.
577      *
578      * _Available since v3.4._
579      */
580     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
581         require(isContract(target), "Address: delegate call to non-contract");
582 
583         // solhint-disable-next-line avoid-low-level-calls
584         (bool success, bytes memory returndata) = target.delegatecall(data);
585         return _verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
589         if (success) {
590             return returndata;
591         } else {
592             // Look for revert reason and bubble it up if present
593             if (returndata.length > 0) {
594                 // The easiest way to bubble the revert reason is using memory via assembly
595 
596                 // solhint-disable-next-line no-inline-assembly
597                 assembly {
598                     let returndata_size := mload(returndata)
599                     revert(add(32, returndata), returndata_size)
600                 }
601             } else {
602                 revert(errorMessage);
603             }
604         }
605     }
606 }
607 
608 // File: @openzeppelin/contracts@3.4.0/utils/EnumerableSet.sol
609 
610 pragma solidity >=0.6.0 <0.8.0;
611 
612 /**
613  * @dev Library for managing
614  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
615  * types.
616  *
617  * Sets have the following properties:
618  *
619  * - Elements are added, removed, and checked for existence in constant time
620  * (O(1)).
621  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
622  *
623  * ```
624  * contract Example {
625  *     // Add the library methods
626  *     using EnumerableSet for EnumerableSet.AddressSet;
627  *
628  *     // Declare a set state variable
629  *     EnumerableSet.AddressSet private mySet;
630  * }
631  * ```
632  *
633  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
634  * and `uint256` (`UintSet`) are supported.
635  */
636 library EnumerableSet {
637     // To implement this library for multiple types with as little code
638     // repetition as possible, we write it in terms of a generic Set type with
639     // bytes32 values.
640     // The Set implementation uses private functions, and user-facing
641     // implementations (such as AddressSet) are just wrappers around the
642     // underlying Set.
643     // This means that we can only create new EnumerableSets for types that fit
644     // in bytes32.
645 
646     struct Set {
647         // Storage of set values
648         bytes32[] _values;
649 
650         // Position of the value in the `values` array, plus 1 because index 0
651         // means a value is not in the set.
652         mapping (bytes32 => uint256) _indexes;
653     }
654 
655     /**
656      * @dev Add a value to a set. O(1).
657      *
658      * Returns true if the value was added to the set, that is if it was not
659      * already present.
660      */
661     function _add(Set storage set, bytes32 value) private returns (bool) {
662         if (!_contains(set, value)) {
663             set._values.push(value);
664             // The value is stored at length-1, but we add 1 to all indexes
665             // and use 0 as a sentinel value
666             set._indexes[value] = set._values.length;
667             return true;
668         } else {
669             return false;
670         }
671     }
672 
673     /**
674      * @dev Removes a value from a set. O(1).
675      *
676      * Returns true if the value was removed from the set, that is if it was
677      * present.
678      */
679     function _remove(Set storage set, bytes32 value) private returns (bool) {
680         // We read and store the value's index to prevent multiple reads from the same storage slot
681         uint256 valueIndex = set._indexes[value];
682 
683         if (valueIndex != 0) { // Equivalent to contains(set, value)
684             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
685             // the array, and then remove the last element (sometimes called as 'swap and pop').
686             // This modifies the order of the array, as noted in {at}.
687 
688             uint256 toDeleteIndex = valueIndex - 1;
689             uint256 lastIndex = set._values.length - 1;
690 
691             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
692             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
693 
694             bytes32 lastvalue = set._values[lastIndex];
695 
696             // Move the last value to the index where the value to delete is
697             set._values[toDeleteIndex] = lastvalue;
698             // Update the index for the moved value
699             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
700 
701             // Delete the slot where the moved value was stored
702             set._values.pop();
703 
704             // Delete the index for the deleted slot
705             delete set._indexes[value];
706 
707             return true;
708         } else {
709             return false;
710         }
711     }
712 
713     /**
714      * @dev Returns true if the value is in the set. O(1).
715      */
716     function _contains(Set storage set, bytes32 value) private view returns (bool) {
717         return set._indexes[value] != 0;
718     }
719 
720     /**
721      * @dev Returns the number of values on the set. O(1).
722      */
723     function _length(Set storage set) private view returns (uint256) {
724         return set._values.length;
725     }
726 
727    /**
728     * @dev Returns the value stored at position `index` in the set. O(1).
729     *
730     * Note that there are no guarantees on the ordering of values inside the
731     * array, and it may change when more values are added or removed.
732     *
733     * Requirements:
734     *
735     * - `index` must be strictly less than {length}.
736     */
737     function _at(Set storage set, uint256 index) private view returns (bytes32) {
738         require(set._values.length > index, "EnumerableSet: index out of bounds");
739         return set._values[index];
740     }
741 
742     // Bytes32Set
743 
744     struct Bytes32Set {
745         Set _inner;
746     }
747 
748     /**
749      * @dev Add a value to a set. O(1).
750      *
751      * Returns true if the value was added to the set, that is if it was not
752      * already present.
753      */
754     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
755         return _add(set._inner, value);
756     }
757 
758     /**
759      * @dev Removes a value from a set. O(1).
760      *
761      * Returns true if the value was removed from the set, that is if it was
762      * present.
763      */
764     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
765         return _remove(set._inner, value);
766     }
767 
768     /**
769      * @dev Returns true if the value is in the set. O(1).
770      */
771     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
772         return _contains(set._inner, value);
773     }
774 
775     /**
776      * @dev Returns the number of values in the set. O(1).
777      */
778     function length(Bytes32Set storage set) internal view returns (uint256) {
779         return _length(set._inner);
780     }
781 
782    /**
783     * @dev Returns the value stored at position `index` in the set. O(1).
784     *
785     * Note that there are no guarantees on the ordering of values inside the
786     * array, and it may change when more values are added or removed.
787     *
788     * Requirements:
789     *
790     * - `index` must be strictly less than {length}.
791     */
792     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
793         return _at(set._inner, index);
794     }
795 
796     // AddressSet
797 
798     struct AddressSet {
799         Set _inner;
800     }
801 
802     /**
803      * @dev Add a value to a set. O(1).
804      *
805      * Returns true if the value was added to the set, that is if it was not
806      * already present.
807      */
808     function add(AddressSet storage set, address value) internal returns (bool) {
809         return _add(set._inner, bytes32(uint256(uint160(value))));
810     }
811 
812     /**
813      * @dev Removes a value from a set. O(1).
814      *
815      * Returns true if the value was removed from the set, that is if it was
816      * present.
817      */
818     function remove(AddressSet storage set, address value) internal returns (bool) {
819         return _remove(set._inner, bytes32(uint256(uint160(value))));
820     }
821 
822     /**
823      * @dev Returns true if the value is in the set. O(1).
824      */
825     function contains(AddressSet storage set, address value) internal view returns (bool) {
826         return _contains(set._inner, bytes32(uint256(uint160(value))));
827     }
828 
829     /**
830      * @dev Returns the number of values in the set. O(1).
831      */
832     function length(AddressSet storage set) internal view returns (uint256) {
833         return _length(set._inner);
834     }
835 
836    /**
837     * @dev Returns the value stored at position `index` in the set. O(1).
838     *
839     * Note that there are no guarantees on the ordering of values inside the
840     * array, and it may change when more values are added or removed.
841     *
842     * Requirements:
843     *
844     * - `index` must be strictly less than {length}.
845     */
846     function at(AddressSet storage set, uint256 index) internal view returns (address) {
847         return address(uint160(uint256(_at(set._inner, index))));
848     }
849 
850 
851     // UintSet
852 
853     struct UintSet {
854         Set _inner;
855     }
856 
857     /**
858      * @dev Add a value to a set. O(1).
859      *
860      * Returns true if the value was added to the set, that is if it was not
861      * already present.
862      */
863     function add(UintSet storage set, uint256 value) internal returns (bool) {
864         return _add(set._inner, bytes32(value));
865     }
866 
867     /**
868      * @dev Removes a value from a set. O(1).
869      *
870      * Returns true if the value was removed from the set, that is if it was
871      * present.
872      */
873     function remove(UintSet storage set, uint256 value) internal returns (bool) {
874         return _remove(set._inner, bytes32(value));
875     }
876 
877     /**
878      * @dev Returns true if the value is in the set. O(1).
879      */
880     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
881         return _contains(set._inner, bytes32(value));
882     }
883 
884     /**
885      * @dev Returns the number of values on the set. O(1).
886      */
887     function length(UintSet storage set) internal view returns (uint256) {
888         return _length(set._inner);
889     }
890 
891    /**
892     * @dev Returns the value stored at position `index` in the set. O(1).
893     *
894     * Note that there are no guarantees on the ordering of values inside the
895     * array, and it may change when more values are added or removed.
896     *
897     * Requirements:
898     *
899     * - `index` must be strictly less than {length}.
900     */
901     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
902         return uint256(_at(set._inner, index));
903     }
904 }
905 
906 // File: @openzeppelin/contracts@3.4.0/access/AccessControl.sol
907 
908 
909 pragma solidity >=0.6.0 <0.8.0;
910 
911 
912 
913 
914 /**
915  * @dev Contract module that allows children to implement role-based access
916  * control mechanisms.
917  *
918  * Roles are referred to by their `bytes32` identifier. These should be exposed
919  * in the external API and be unique. The best way to achieve this is by
920  * using `public constant` hash digests:
921  *
922  * ```
923  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
924  * ```
925  *
926  * Roles can be used to represent a set of permissions. To restrict access to a
927  * function call, use {hasRole}:
928  *
929  * ```
930  * function foo() public {
931  *     require(hasRole(MY_ROLE, msg.sender));
932  *     ...
933  * }
934  * ```
935  *
936  * Roles can be granted and revoked dynamically via the {grantRole} and
937  * {revokeRole} functions. Each role has an associated admin role, and only
938  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
939  *
940  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
941  * that only accounts with this role will be able to grant or revoke other
942  * roles. More complex role relationships can be created by using
943  * {_setRoleAdmin}.
944  *
945  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
946  * grant and revoke this role. Extra precautions should be taken to secure
947  * accounts that have been granted it.
948  */
949 abstract contract AccessControl is Context {
950     using EnumerableSet for EnumerableSet.AddressSet;
951     using Address for address;
952 
953     struct RoleData {
954         EnumerableSet.AddressSet members;
955         bytes32 adminRole;
956     }
957 
958     mapping (bytes32 => RoleData) private _roles;
959 
960     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
961 
962     /**
963      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
964      *
965      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
966      * {RoleAdminChanged} not being emitted signaling this.
967      *
968      * _Available since v3.1._
969      */
970     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
971 
972     /**
973      * @dev Emitted when `account` is granted `role`.
974      *
975      * `sender` is the account that originated the contract call, an admin role
976      * bearer except when using {_setupRole}.
977      */
978     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
979 
980     /**
981      * @dev Emitted when `account` is revoked `role`.
982      *
983      * `sender` is the account that originated the contract call:
984      *   - if using `revokeRole`, it is the admin role bearer
985      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
986      */
987     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
988 
989     /**
990      * @dev Returns `true` if `account` has been granted `role`.
991      */
992     function hasRole(bytes32 role, address account) public view returns (bool) {
993         return _roles[role].members.contains(account);
994     }
995 
996     /**
997      * @dev Returns the number of accounts that have `role`. Can be used
998      * together with {getRoleMember} to enumerate all bearers of a role.
999      */
1000     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1001         return _roles[role].members.length();
1002     }
1003 
1004     /**
1005      * @dev Returns one of the accounts that have `role`. `index` must be a
1006      * value between 0 and {getRoleMemberCount}, non-inclusive.
1007      *
1008      * Role bearers are not sorted in any particular way, and their ordering may
1009      * change at any point.
1010      *
1011      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1012      * you perform all queries on the same block. See the following
1013      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1014      * for more information.
1015      */
1016     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1017         return _roles[role].members.at(index);
1018     }
1019 
1020     /**
1021      * @dev Returns the admin role that controls `role`. See {grantRole} and
1022      * {revokeRole}.
1023      *
1024      * To change a role's admin, use {_setRoleAdmin}.
1025      */
1026     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1027         return _roles[role].adminRole;
1028     }
1029 
1030     /**
1031      * @dev Grants `role` to `account`.
1032      *
1033      * If `account` had not been already granted `role`, emits a {RoleGranted}
1034      * event.
1035      *
1036      * Requirements:
1037      *
1038      * - the caller must have ``role``'s admin role.
1039      */
1040     function grantRole(bytes32 role, address account) public virtual {
1041         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1042 
1043         _grantRole(role, account);
1044     }
1045 
1046     /**
1047      * @dev Revokes `role` from `account`.
1048      *
1049      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1050      *
1051      * Requirements:
1052      *
1053      * - the caller must have ``role``'s admin role.
1054      */
1055     function revokeRole(bytes32 role, address account) public virtual {
1056         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1057 
1058         _revokeRole(role, account);
1059     }
1060 
1061     /**
1062      * @dev Revokes `role` from the calling account.
1063      *
1064      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1065      * purpose is to provide a mechanism for accounts to lose their privileges
1066      * if they are compromised (such as when a trusted device is misplaced).
1067      *
1068      * If the calling account had been granted `role`, emits a {RoleRevoked}
1069      * event.
1070      *
1071      * Requirements:
1072      *
1073      * - the caller must be `account`.
1074      */
1075     function renounceRole(bytes32 role, address account) public virtual {
1076         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1077 
1078         _revokeRole(role, account);
1079     }
1080 
1081     /**
1082      * @dev Grants `role` to `account`.
1083      *
1084      * If `account` had not been already granted `role`, emits a {RoleGranted}
1085      * event. Note that unlike {grantRole}, this function doesn't perform any
1086      * checks on the calling account.
1087      *
1088      * [WARNING]
1089      * ====
1090      * This function should only be called from the constructor when setting
1091      * up the initial roles for the system.
1092      *
1093      * Using this function in any other way is effectively circumventing the admin
1094      * system imposed by {AccessControl}.
1095      * ====
1096      */
1097     function _setupRole(bytes32 role, address account) internal virtual {
1098         _grantRole(role, account);
1099     }
1100 
1101     /**
1102      * @dev Sets `adminRole` as ``role``'s admin role.
1103      *
1104      * Emits a {RoleAdminChanged} event.
1105      */
1106     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1107         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1108         _roles[role].adminRole = adminRole;
1109     }
1110 
1111     function _grantRole(bytes32 role, address account) private {
1112         if (_roles[role].members.add(account)) {
1113             emit RoleGranted(role, account, _msgSender());
1114         }
1115     }
1116 
1117     function _revokeRole(bytes32 role, address account) private {
1118         if (_roles[role].members.remove(account)) {
1119             emit RoleRevoked(role, account, _msgSender());
1120         }
1121     }
1122 }
1123 
1124 // File: @openzeppelin/contracts@3.4.0/utils/Pausable.sol
1125 
1126 
1127 
1128 pragma solidity >=0.6.0 <0.8.0;
1129 
1130 
1131 /**
1132  * @dev Contract module which allows children to implement an emergency stop
1133  * mechanism that can be triggered by an authorized account.
1134  *
1135  * This module is used through inheritance. It will make available the
1136  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1137  * the functions of your contract. Note that they will not be pausable by
1138  * simply including this module, only once the modifiers are put in place.
1139  */
1140 abstract contract Pausable is Context {
1141     /**
1142      * @dev Emitted when the pause is triggered by `account`.
1143      */
1144     event Paused(address account);
1145 
1146     /**
1147      * @dev Emitted when the pause is lifted by `account`.
1148      */
1149     event Unpaused(address account);
1150 
1151     bool private _paused;
1152 
1153     /**
1154      * @dev Initializes the contract in unpaused state.
1155      */
1156     constructor () internal {
1157         _paused = false;
1158     }
1159 
1160     /**
1161      * @dev Returns true if the contract is paused, and false otherwise.
1162      */
1163     function paused() public view virtual returns (bool) {
1164         return _paused;
1165     }
1166 
1167     /**
1168      * @dev Modifier to make a function callable only when the contract is not paused.
1169      *
1170      * Requirements:
1171      *
1172      * - The contract must not be paused.
1173      */
1174     modifier whenNotPaused() {
1175         require(!paused(), "Pausable: paused");
1176         _;
1177     }
1178 
1179     /**
1180      * @dev Modifier to make a function callable only when the contract is paused.
1181      *
1182      * Requirements:
1183      *
1184      * - The contract must be paused.
1185      */
1186     modifier whenPaused() {
1187         require(paused(), "Pausable: not paused");
1188         _;
1189     }
1190 
1191     /**
1192      * @dev Triggers stopped state.
1193      *
1194      * Requirements:
1195      *
1196      * - The contract must not be paused.
1197      */
1198     function _pause() internal virtual whenNotPaused {
1199         _paused = true;
1200         emit Paused(_msgSender());
1201     }
1202 
1203     /**
1204      * @dev Returns to normal state.
1205      *
1206      * Requirements:
1207      *
1208      * - The contract must be paused.
1209      */
1210     function _unpause() internal virtual whenPaused {
1211         _paused = false;
1212         emit Unpaused(_msgSender());
1213     }
1214 }
1215 
1216 // File: @openzeppelin/contracts@3.4.0/token/ERC20/ERC20Pausable.sol
1217 
1218 
1219 
1220 pragma solidity >=0.6.0 <0.8.0;
1221 
1222 
1223 
1224 /**
1225  * @dev ERC20 token with pausable token transfers, minting and burning.
1226  *
1227  * Useful for scenarios such as preventing trades until the end of an evaluation
1228  * period, or having an emergency switch for freezing all token transfers in the
1229  * event of a large bug.
1230  */
1231 abstract contract ERC20Pausable is ERC20, Pausable {
1232     /**
1233      * @dev See {ERC20-_beforeTokenTransfer}.
1234      *
1235      * Requirements:
1236      *
1237      * - the contract must not be paused.
1238      */
1239     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1240         super._beforeTokenTransfer(from, to, amount);
1241 
1242         require(!paused(), "ERC20Pausable: token transfer while paused");
1243     }
1244 }
1245 
1246 // File: @openzeppelin/contracts@3.4.0/token/ERC20/ERC20Capped.sol
1247 
1248 
1249 
1250 pragma solidity >=0.6.0 <0.8.0;
1251 
1252 
1253 /**
1254  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1255  */
1256 abstract contract ERC20Capped is ERC20 {
1257     using SafeMath for uint256;
1258 
1259     uint256 private _cap;
1260 
1261     /**
1262      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1263      * set once during construction.
1264      */
1265     constructor (uint256 cap_) internal {
1266         require(cap_ > 0, "ERC20Capped: cap is 0");
1267         _cap = cap_;
1268     }
1269 
1270     /**
1271      * @dev Returns the cap on the token's total supply.
1272      */
1273     function cap() public view virtual returns (uint256) {
1274         return _cap;
1275     }
1276 
1277     /**
1278      * @dev See {ERC20-_beforeTokenTransfer}.
1279      *
1280      * Requirements:
1281      *
1282      * - minted tokens must not cause the total supply to go over the cap.
1283      */
1284     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1285         super._beforeTokenTransfer(from, to, amount);
1286 
1287         if (from == address(0)) { // When minting tokens
1288             require(totalSupply().add(amount) <= cap(), "ERC20Capped: cap exceeded");
1289         }
1290     }
1291 }
1292 
1293 // File: @openzeppelin/contracts@3.4.0/token/ERC20/ERC20Burnable.sol
1294 
1295 
1296 
1297 pragma solidity >=0.6.0 <0.8.0;
1298 
1299 
1300 
1301 /**
1302  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1303  * tokens and those that they have an allowance for, in a way that can be
1304  * recognized off-chain (via event analysis).
1305  */
1306 abstract contract ERC20Burnable is Context, ERC20 {
1307     using SafeMath for uint256;
1308 
1309     /**
1310      * @dev Destroys `amount` tokens from the caller.
1311      *
1312      * See {ERC20-_burn}.
1313      */
1314     function burn(uint256 amount) public virtual {
1315         _burn(_msgSender(), amount);
1316     }
1317 
1318     /**
1319      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1320      * allowance.
1321      *
1322      * See {ERC20-_burn} and {ERC20-allowance}.
1323      *
1324      * Requirements:
1325      *
1326      * - the caller must have allowance for ``accounts``'s tokens of at least
1327      * `amount`.
1328      */
1329     function burnFrom(address account, uint256 amount) public virtual {
1330         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1331 
1332         _approve(account, _msgSender(), decreasedAllowance);
1333         _burn(account, amount);
1334     }
1335 }
1336 
1337 // File: @openzeppelin/contracts@3.4.0/math/SafeMath.sol
1338 
1339 
1340 
1341 pragma solidity >=0.6.0 <0.8.0;
1342 
1343 /**
1344  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1345  * checks.
1346  *
1347  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1348  * in bugs, because programmers usually assume that an overflow raises an
1349  * error, which is the standard behavior in high level programming languages.
1350  * `SafeMath` restores this intuition by reverting the transaction when an
1351  * operation overflows.
1352  *
1353  * Using this library instead of the unchecked operations eliminates an entire
1354  * class of bugs, so it's recommended to use it always.
1355  */
1356 library SafeMath {
1357     /**
1358      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1359      *
1360      * _Available since v3.4._
1361      */
1362     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1363         uint256 c = a + b;
1364         if (c < a) return (false, 0);
1365         return (true, c);
1366     }
1367 
1368     /**
1369      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1370      *
1371      * _Available since v3.4._
1372      */
1373     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1374         if (b > a) return (false, 0);
1375         return (true, a - b);
1376     }
1377 
1378     /**
1379      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1380      *
1381      * _Available since v3.4._
1382      */
1383     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1384         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1385         // benefit is lost if 'b' is also tested.
1386         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1387         if (a == 0) return (true, 0);
1388         uint256 c = a * b;
1389         if (c / a != b) return (false, 0);
1390         return (true, c);
1391     }
1392 
1393     /**
1394      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1395      *
1396      * _Available since v3.4._
1397      */
1398     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1399         if (b == 0) return (false, 0);
1400         return (true, a / b);
1401     }
1402 
1403     /**
1404      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1405      *
1406      * _Available since v3.4._
1407      */
1408     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1409         if (b == 0) return (false, 0);
1410         return (true, a % b);
1411     }
1412 
1413     /**
1414      * @dev Returns the addition of two unsigned integers, reverting on
1415      * overflow.
1416      *
1417      * Counterpart to Solidity's `+` operator.
1418      *
1419      * Requirements:
1420      *
1421      * - Addition cannot overflow.
1422      */
1423     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1424         uint256 c = a + b;
1425         require(c >= a, "SafeMath: addition overflow");
1426         return c;
1427     }
1428 
1429     /**
1430      * @dev Returns the subtraction of two unsigned integers, reverting on
1431      * overflow (when the result is negative).
1432      *
1433      * Counterpart to Solidity's `-` operator.
1434      *
1435      * Requirements:
1436      *
1437      * - Subtraction cannot overflow.
1438      */
1439     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1440         require(b <= a, "SafeMath: subtraction overflow");
1441         return a - b;
1442     }
1443 
1444     /**
1445      * @dev Returns the multiplication of two unsigned integers, reverting on
1446      * overflow.
1447      *
1448      * Counterpart to Solidity's `*` operator.
1449      *
1450      * Requirements:
1451      *
1452      * - Multiplication cannot overflow.
1453      */
1454     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1455         if (a == 0) return 0;
1456         uint256 c = a * b;
1457         require(c / a == b, "SafeMath: multiplication overflow");
1458         return c;
1459     }
1460 
1461     /**
1462      * @dev Returns the integer division of two unsigned integers, reverting on
1463      * division by zero. The result is rounded towards zero.
1464      *
1465      * Counterpart to Solidity's `/` operator. Note: this function uses a
1466      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1467      * uses an invalid opcode to revert (consuming all remaining gas).
1468      *
1469      * Requirements:
1470      *
1471      * - The divisor cannot be zero.
1472      */
1473     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1474         require(b > 0, "SafeMath: division by zero");
1475         return a / b;
1476     }
1477 
1478     /**
1479      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1480      * reverting when dividing by zero.
1481      *
1482      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1483      * opcode (which leaves remaining gas untouched) while Solidity uses an
1484      * invalid opcode to revert (consuming all remaining gas).
1485      *
1486      * Requirements:
1487      *
1488      * - The divisor cannot be zero.
1489      */
1490     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1491         require(b > 0, "SafeMath: modulo by zero");
1492         return a % b;
1493     }
1494 
1495     /**
1496      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1497      * overflow (when the result is negative).
1498      *
1499      * CAUTION: This function is deprecated because it requires allocating memory for the error
1500      * message unnecessarily. For custom revert reasons use {trySub}.
1501      *
1502      * Counterpart to Solidity's `-` operator.
1503      *
1504      * Requirements:
1505      *
1506      * - Subtraction cannot overflow.
1507      */
1508     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1509         require(b <= a, errorMessage);
1510         return a - b;
1511     }
1512 
1513     /**
1514      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1515      * division by zero. The result is rounded towards zero.
1516      *
1517      * CAUTION: This function is deprecated because it requires allocating memory for the error
1518      * message unnecessarily. For custom revert reasons use {tryDiv}.
1519      *
1520      * Counterpart to Solidity's `/` operator. Note: this function uses a
1521      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1522      * uses an invalid opcode to revert (consuming all remaining gas).
1523      *
1524      * Requirements:
1525      *
1526      * - The divisor cannot be zero.
1527      */
1528     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1529         require(b > 0, errorMessage);
1530         return a / b;
1531     }
1532 
1533     /**
1534      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1535      * reverting with custom message when dividing by zero.
1536      *
1537      * CAUTION: This function is deprecated because it requires allocating memory for the error
1538      * message unnecessarily. For custom revert reasons use {tryMod}.
1539      *
1540      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1541      * opcode (which leaves remaining gas untouched) while Solidity uses an
1542      * invalid opcode to revert (consuming all remaining gas).
1543      *
1544      * Requirements:
1545      *
1546      * - The divisor cannot be zero.
1547      */
1548     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1549         require(b > 0, errorMessage);
1550         return a % b;
1551     }
1552 }
1553 
1554 // File: BXR-Token.sol
1555 
1556 
1557 pragma solidity 0.6.12;
1558 
1559 
1560 
1561 
1562 
1563 
1564 contract BXRToken is ERC20Burnable, ERC20Capped, ERC20Pausable, AccessControl {
1565     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1566     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1567 
1568     constructor() public ERC20Capped(100 * 10**6 * 10**18) ERC20("Blockster", "BXR") {
1569         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1570         _setupRole(PAUSER_ROLE, msg.sender);
1571         _setupRole(MINTER_ROLE, msg.sender);
1572     }
1573 
1574     function pause() public {
1575         require(hasRole(PAUSER_ROLE, msg.sender));
1576         _pause();
1577     }
1578 
1579     function unpause() public {
1580         require(hasRole(PAUSER_ROLE, msg.sender));
1581         _unpause();
1582     }
1583 
1584     function mint(address to, uint256 amount) public {
1585         require(hasRole(MINTER_ROLE, msg.sender));
1586         _mint(to, amount);
1587     }
1588 
1589     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable, ERC20Capped) {
1590         super._beforeTokenTransfer(from, to, amount);
1591     }
1592 }