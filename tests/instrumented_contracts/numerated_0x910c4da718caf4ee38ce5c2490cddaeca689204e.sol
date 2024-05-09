1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-09
3 */
4 
5 pragma solidity ^0.8.0;
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
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount)
50         external
51         returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender)
61         external
62         view
63         returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(
91         address sender,
92         address recipient,
93         uint256 amount
94     ) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(
109         address indexed owner,
110         address indexed spender,
111         uint256 value
112     );
113 }
114 
115 /**
116  * @dev Implementation of the {IERC20} interface.
117  *
118  * This implementation is agnostic to the way tokens are created. This means
119  * that a supply mechanism has to be added in a derived contract using {_mint}.
120  * For a generic mechanism see {ERC20PresetMinterPauser}.
121  *
122  * TIP: For a detailed writeup see our guide
123  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
124  * to implement supply mechanisms].
125  *
126  * We have followed general OpenZeppelin guidelines: functions revert instead
127  * of returning `false` on failure. This behavior is nonetheless conventional
128  * and does not conflict with the expectations of ERC20 applications.
129  *
130  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
131  * This allows applications to reconstruct the allowance for all accounts just
132  * by listening to said events. Other implementations of the EIP may not emit
133  * these events, as it isn't required by the specification.
134  *
135  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
136  * functions have been added to mitigate the well-known issues around setting
137  * allowances. See {IERC20-approve}.
138  */
139 contract ERC20 is Context, IERC20 {
140     mapping(address => uint256) private _balances;
141 
142     mapping(address => mapping(address => uint256)) private _allowances;
143 
144     uint256 private _totalSupply;
145 
146     string private _name;
147     string private _symbol;
148 
149     /**
150      * @dev Sets the values for {name} and {symbol}.
151      *
152      * The defaut value of {decimals} is 18. To select a different value for
153      * {decimals} you should overload it.
154      *
155      * All three of these values are immutable: they can only be set once during
156      * construction.
157      */
158     constructor(string memory name_, string memory symbol_) {
159         _name = name_;
160         _symbol = symbol_;
161     }
162 
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() public view virtual returns (string memory) {
167         return _name;
168     }
169 
170     /**
171      * @dev Returns the symbol of the token, usually a shorter version of the
172      * name.
173      */
174     function symbol() public view virtual returns (string memory) {
175         return _symbol;
176     }
177 
178     /**
179      * @dev Returns the number of decimals used to get its user representation.
180      * For example, if `decimals` equals `2`, a balance of `505` tokens should
181      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
182      *
183      * Tokens usually opt for a value of 18, imitating the relationship between
184      * Ether and Wei. This is the value {ERC20} uses, unless this function is
185      * overloaded;
186      *
187      * NOTE: This information is only used for _display_ purposes: it in
188      * no way affects any of the arithmetic of the contract, including
189      * {IERC20-balanceOf} and {IERC20-transfer}.
190      */
191     function decimals() public view virtual returns (uint8) {
192         return 18;
193     }
194 
195     /**
196      * @dev See {IERC20-totalSupply}.
197      */
198     function totalSupply() public view virtual override returns (uint256) {
199         return _totalSupply;
200     }
201 
202     /**
203      * @dev See {IERC20-balanceOf}.
204      */
205     function balanceOf(address account)
206         public
207         view
208         virtual
209         override
210         returns (uint256)
211     {
212         return _balances[account];
213     }
214 
215     /**
216      * @dev See {IERC20-transfer}.
217      *
218      * Requirements:
219      *
220      * - `recipient` cannot be the zero address.
221      * - the caller must have a balance of at least `amount`.
222      */
223     function transfer(address recipient, uint256 amount)
224         public
225         virtual
226         override
227         returns (bool)
228     {
229         _transfer(_msgSender(), recipient, amount);
230         return true;
231     }
232 
233     /**
234      * @dev See {IERC20-allowance}.
235      */
236     function allowance(address owner, address spender)
237         public
238         view
239         virtual
240         override
241         returns (uint256)
242     {
243         return _allowances[owner][spender];
244     }
245 
246     /**
247      * @dev See {IERC20-approve}.
248      *
249      * Requirements:
250      *
251      * - `spender` cannot be the zero address.
252      */
253     function approve(address spender, uint256 amount)
254         public
255         virtual
256         override
257         returns (bool)
258     {
259         _approve(_msgSender(), spender, amount);
260         return true;
261     }
262 
263     /**
264      * @dev See {IERC20-transferFrom}.
265      *
266      * Emits an {Approval} event indicating the updated allowance. This is not
267      * required by the EIP. See the note at the beginning of {ERC20}.
268      *
269      * Requirements:
270      *
271      * - `sender` and `recipient` cannot be the zero address.
272      * - `sender` must have a balance of at least `amount`.
273      * - the caller must have allowance for ``sender``'s tokens of at least
274      * `amount`.
275      */
276     function transferFrom(
277         address sender,
278         address recipient,
279         uint256 amount
280     ) public virtual override returns (bool) {
281         _transfer(sender, recipient, amount);
282 
283         require(
284             _allowances[sender][_msgSender()] >= amount,
285             "ERC20: transfer amount exceeds allowance"
286         );
287         _approve(
288             sender,
289             _msgSender(),
290             _allowances[sender][_msgSender()] - amount
291         );
292 
293         return true;
294     }
295 
296     /**
297      * @dev Atomically increases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to {approve} that can be used as a mitigation for
300      * problems described in {IERC20-approve}.
301      *
302      * Emits an {Approval} event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      */
308     function increaseAllowance(address spender, uint256 addedValue)
309         public
310         virtual
311         returns (bool)
312     {
313         _approve(
314             _msgSender(),
315             spender,
316             _allowances[_msgSender()][spender] + addedValue
317         );
318         return true;
319     }
320 
321     /**
322      * @dev Atomically decreases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      * - `spender` must have allowance for the caller of at least
333      * `subtractedValue`.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue)
336         public
337         virtual
338         returns (bool)
339     {
340         require(
341             _allowances[_msgSender()][spender] >= subtractedValue,
342             "ERC20: decreased allowance below zero"
343         );
344         _approve(
345             _msgSender(),
346             spender,
347             _allowances[_msgSender()][spender] - subtractedValue
348         );
349 
350         return true;
351     }
352 
353     /**
354      * @dev Moves tokens `amount` from `sender` to `recipient`.
355      *
356      * This is internal function is equivalent to {transfer}, and can be used to
357      * e.g. implement automatic token fees, slashing mechanisms, etc.
358      *
359      * Emits a {Transfer} event.
360      *
361      * Requirements:
362      *
363      * - `sender` cannot be the zero address.
364      * - `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `amount`.
366      */
367     function _transfer(
368         address sender,
369         address recipient,
370         uint256 amount
371     ) internal virtual {
372         require(sender != address(0), "ERC20: transfer from the zero address");
373         require(recipient != address(0), "ERC20: transfer to the zero address");
374 
375         _beforeTokenTransfer(sender, recipient, amount);
376 
377         require(
378             _balances[sender] >= amount,
379             "ERC20: transfer amount exceeds balance"
380         );
381         _balances[sender] -= amount;
382         _balances[recipient] += amount;
383 
384         emit Transfer(sender, recipient, amount);
385     }
386 
387     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
388      * the total supply.
389      *
390      * Emits a {Transfer} event with `from` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `to` cannot be the zero address.
395      */
396     function _mint(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: mint to the zero address");
398 
399         _beforeTokenTransfer(address(0), account, amount);
400 
401         _totalSupply += amount;
402         _balances[account] += amount;
403         emit Transfer(address(0), account, amount);
404     }
405 
406     /**
407      * @dev Destroys `amount` tokens from `account`, reducing the
408      * total supply.
409      *
410      * Emits a {Transfer} event with `to` set to the zero address.
411      *
412      * Requirements:
413      *
414      * - `account` cannot be the zero address.
415      * - `account` must have at least `amount` tokens.
416      */
417     function _burn(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: burn from the zero address");
419 
420         _beforeTokenTransfer(account, address(0), amount);
421 
422         require(
423             _balances[account] >= amount,
424             "ERC20: burn amount exceeds balance"
425         );
426         _balances[account] -= amount;
427         _totalSupply -= amount;
428 
429         emit Transfer(account, address(0), amount);
430     }
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
434      *
435      * This internal function is equivalent to `approve`, and can be used to
436      * e.g. set automatic allowances for certain subsystems, etc.
437      *
438      * Emits an {Approval} event.
439      *
440      * Requirements:
441      *
442      * - `owner` cannot be the zero address.
443      * - `spender` cannot be the zero address.
444      */
445     function _approve(
446         address owner,
447         address spender,
448         uint256 amount
449     ) internal virtual {
450         require(owner != address(0), "ERC20: approve from the zero address");
451         require(spender != address(0), "ERC20: approve to the zero address");
452 
453         _allowances[owner][spender] = amount;
454         emit Approval(owner, spender, amount);
455     }
456 
457     /**
458      * @dev Hook that is called before any transfer of tokens. This includes
459      * minting and burning.
460      *
461      * Calling conditions:
462      *
463      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
464      * will be to transferred to `to`.
465      * - when `from` is zero, `amount` tokens will be minted for `to`.
466      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
467      * - `from` and `to` are never both zero.
468      *
469      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
470      */
471     function _beforeTokenTransfer(
472         address from,
473         address to,
474         uint256 amount
475     ) internal virtual {}
476 }
477 
478 /**
479  * @dev Contract module which provides a basic access control mechanism, where
480  * there is an account (an owner) that can be granted exclusive access to
481  * specific functions.
482  *
483  * By default, the owner account will be the one that deploys the contract. This
484  * can later be changed with {transferOwnership}.
485  *
486  * This module is used through inheritance. It will make available the modifier
487  * `onlyOwner`, which can be applied to your functions to restrict their use to
488  * the owner.
489  */
490 abstract contract Ownable is Context {
491     address private _owner;
492 
493     event OwnershipTransferred(
494         address indexed previousOwner,
495         address indexed newOwner
496     );
497 
498     /**
499      * @dev Initializes the contract setting the deployer as the initial owner.
500      */
501     constructor() {
502         address msgSender = _msgSender();
503         _owner = msgSender;
504         emit OwnershipTransferred(address(0), msgSender);
505     }
506 
507     /**
508      * @dev Returns the address of the current owner.
509      */
510     function owner() public view virtual returns (address) {
511         return _owner;
512     }
513 
514     /**
515      * @dev Throws if called by any account other than the owner.
516      */
517     modifier onlyOwner() {
518         require(owner() == _msgSender(), "Ownable: caller is not the owner");
519         _;
520     }
521 
522     /**
523      * @dev Leaves the contract without owner. It will not be possible to call
524      * `onlyOwner` functions anymore. Can only be called by the current owner.
525      *
526      * NOTE: Renouncing ownership will leave the contract without an owner,
527      * thereby removing any functionality that is only available to the owner.
528      */
529     function renounceOwnership() public virtual onlyOwner {
530         emit OwnershipTransferred(_owner, address(0));
531         _owner = address(0);
532     }
533 
534     /**
535      * @dev Transfers ownership of the contract to a new account (`newOwner`).
536      * Can only be called by the current owner.
537      */
538     function transferOwnership(address newOwner) public virtual onlyOwner {
539         require(
540             newOwner != address(0),
541             "Ownable: new owner is the zero address"
542         );
543         emit OwnershipTransferred(_owner, newOwner);
544         _owner = newOwner;
545     }
546 }
547 
548 /**
549  * @dev Library for managing
550  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
551  * types.
552  *
553  * Sets have the following properties:
554  *
555  * - Elements are added, removed, and checked for existence in constant time
556  * (O(1)).
557  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
558  *
559  * ```
560  * contract Example {
561  *     // Add the library methods
562  *     using EnumerableSet for EnumerableSet.AddressSet;
563  *
564  *     // Declare a set state variable
565  *     EnumerableSet.AddressSet private mySet;
566  * }
567  * ```
568  *
569  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
570  * and `uint256` (`UintSet`) are supported.
571  */
572  
573 // SPDX-License-Identifier: MIT
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev Collection of functions related to the address type
579  */
580 library Address {
581     /**
582      * @dev Returns true if `account` is a contract.
583      *
584      * [IMPORTANT]
585      * ====
586      * It is unsafe to assume that an address for which this function returns
587      * false is an externally-owned account (EOA) and not a contract.
588      *
589      * Among others, `isContract` will return false for the following
590      * types of addresses:
591      *
592      *  - an externally-owned account
593      *  - a contract in construction
594      *  - an address where a contract will be created
595      *  - an address where a contract lived, but was destroyed
596      * ====
597      */
598     function isContract(address account) internal view returns (bool) {
599         // This method relies on extcodesize, which returns 0 for contracts in
600         // construction, since the code is only stored at the end of the
601         // constructor execution.
602 
603         uint256 size;
604         // solhint-disable-next-line no-inline-assembly
605         assembly { size := extcodesize(account) }
606         return size > 0;
607     }
608 
609     /**
610      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
611      * `recipient`, forwarding all available gas and reverting on errors.
612      *
613      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
614      * of certain opcodes, possibly making contracts go over the 2300 gas limit
615      * imposed by `transfer`, making them unable to receive funds via
616      * `transfer`. {sendValue} removes this limitation.
617      *
618      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
619      *
620      * IMPORTANT: because control is transferred to `recipient`, care must be
621      * taken to not create reentrancy vulnerabilities. Consider using
622      * {ReentrancyGuard} or the
623      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
624      */
625     function sendValue(address payable recipient, uint256 amount) internal {
626         require(address(this).balance >= amount, "Address: insufficient balance");
627 
628         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
629         (bool success, ) = recipient.call{ value: amount }("");
630         require(success, "Address: unable to send value, recipient may have reverted");
631     }
632 
633     /**
634      * @dev Performs a Solidity function call using a low level `call`. A
635      * plain`call` is an unsafe replacement for a function call: use this
636      * function instead.
637      *
638      * If `target` reverts with a revert reason, it is bubbled up by this
639      * function (like regular Solidity function calls).
640      *
641      * Returns the raw returned data. To convert to the expected return value,
642      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
643      *
644      * Requirements:
645      *
646      * - `target` must be a contract.
647      * - calling `target` with `data` must not revert.
648      *
649      * _Available since v3.1._
650      */
651     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
652       return functionCall(target, data, "Address: low-level call failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
657      * `errorMessage` as a fallback revert reason when `target` reverts.
658      *
659      * _Available since v3.1._
660      */
661     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
662         return functionCallWithValue(target, data, 0, errorMessage);
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
667      * but also transferring `value` wei to `target`.
668      *
669      * Requirements:
670      *
671      * - the calling contract must have an ETH balance of at least `value`.
672      * - the called Solidity function must be `payable`.
673      *
674      * _Available since v3.1._
675      */
676     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
677         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
678     }
679 
680     /**
681      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
682      * with `errorMessage` as a fallback revert reason when `target` reverts.
683      *
684      * _Available since v3.1._
685      */
686     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
687         require(address(this).balance >= value, "Address: insufficient balance for call");
688         require(isContract(target), "Address: call to non-contract");
689 
690         // solhint-disable-next-line avoid-low-level-calls
691         (bool success, bytes memory returndata) = target.call{ value: value }(data);
692         return _verifyCallResult(success, returndata, errorMessage);
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
697      * but performing a static call.
698      *
699      * _Available since v3.3._
700      */
701     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
702         return functionStaticCall(target, data, "Address: low-level static call failed");
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
707      * but performing a static call.
708      *
709      * _Available since v3.3._
710      */
711     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
712         require(isContract(target), "Address: static call to non-contract");
713 
714         // solhint-disable-next-line avoid-low-level-calls
715         (bool success, bytes memory returndata) = target.staticcall(data);
716         return _verifyCallResult(success, returndata, errorMessage);
717     }
718 
719     /**
720      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
721      * but performing a delegate call.
722      *
723      * _Available since v3.4._
724      */
725     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
726         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
727     }
728 
729     /**
730      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
731      * but performing a delegate call.
732      *
733      * _Available since v3.4._
734      */
735     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
736         require(isContract(target), "Address: delegate call to non-contract");
737 
738         // solhint-disable-next-line avoid-low-level-calls
739         (bool success, bytes memory returndata) = target.delegatecall(data);
740         return _verifyCallResult(success, returndata, errorMessage);
741     }
742 
743     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
744         if (success) {
745             return returndata;
746         } else {
747             // Look for revert reason and bubble it up if present
748             if (returndata.length > 0) {
749                 // The easiest way to bubble the revert reason is using memory via assembly
750 
751                 // solhint-disable-next-line no-inline-assembly
752                 assembly {
753                     let returndata_size := mload(returndata)
754                     revert(add(32, returndata), returndata_size)
755                 }
756             } else {
757                 revert(errorMessage);
758             }
759         }
760     }
761 }
762  
763  
764 library EnumerableSet {
765     // To implement this library for multiple types with as little code
766     // repetition as possible, we write it in terms of a generic Set type with
767     // bytes32 values.
768     // The Set implementation uses private functions, and user-facing
769     // implementations (such as AddressSet) are just wrappers around the
770     // underlying Set.
771     // This means that we can only create new EnumerableSets for types that fit
772     // in bytes32.
773 
774     struct Set {
775         // Storage of set values
776         bytes32[] _values;
777         // Position of the value in the `values` array, plus 1 because index 0
778         // means a value is not in the set.
779         mapping(bytes32 => uint256) _indexes;
780     }
781 
782     /**
783      * @dev Add a value to a set. O(1).
784      *
785      * Returns true if the value was added to the set, that is if it was not
786      * already present.
787      */
788     function _add(Set storage set, bytes32 value) private returns (bool) {
789         if (!_contains(set, value)) {
790             set._values.push(value);
791             // The value is stored at length-1, but we add 1 to all indexes
792             // and use 0 as a sentinel value
793             set._indexes[value] = set._values.length;
794             return true;
795         } else {
796             return false;
797         }
798     }
799 
800     /**
801      * @dev Removes a value from a set. O(1).
802      *
803      * Returns true if the value was removed from the set, that is if it was
804      * present.
805      */
806     function _remove(Set storage set, bytes32 value) private returns (bool) {
807         // We read and store the value's index to prevent multiple reads from the same storage slot
808         uint256 valueIndex = set._indexes[value];
809 
810         if (valueIndex != 0) {
811             // Equivalent to contains(set, value)
812             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
813             // the array, and then remove the last element (sometimes called as 'swap and pop').
814             // This modifies the order of the array, as noted in {at}.
815 
816             uint256 toDeleteIndex = valueIndex - 1;
817             uint256 lastIndex = set._values.length - 1;
818 
819             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
820             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
821 
822             bytes32 lastvalue = set._values[lastIndex];
823 
824             // Move the last value to the index where the value to delete is
825             set._values[toDeleteIndex] = lastvalue;
826             // Update the index for the moved value
827             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
828 
829             // Delete the slot where the moved value was stored
830             set._values.pop();
831 
832             // Delete the index for the deleted slot
833             delete set._indexes[value];
834 
835             return true;
836         } else {
837             return false;
838         }
839     }
840 
841     /**
842      * @dev Returns true if the value is in the set. O(1).
843      */
844     function _contains(Set storage set, bytes32 value)
845         private
846         view
847         returns (bool)
848     {
849         return set._indexes[value] != 0;
850     }
851 
852     /**
853      * @dev Returns the number of values on the set. O(1).
854      */
855     function _length(Set storage set) private view returns (uint256) {
856         return set._values.length;
857     }
858 
859     /**
860      * @dev Returns the value stored at position `index` in the set. O(1).
861      *
862      * Note that there are no guarantees on the ordering of values inside the
863      * array, and it may change when more values are added or removed.
864      *
865      * Requirements:
866      *
867      * - `index` must be strictly less than {length}.
868      */
869     function _at(Set storage set, uint256 index)
870         private
871         view
872         returns (bytes32)
873     {
874         require(
875             set._values.length > index,
876             "EnumerableSet: index out of bounds"
877         );
878         return set._values[index];
879     }
880 
881     // Bytes32Set
882 
883     struct Bytes32Set {
884         Set _inner;
885     }
886 
887     /**
888      * @dev Add a value to a set. O(1).
889      *
890      * Returns true if the value was added to the set, that is if it was not
891      * already present.
892      */
893     function add(Bytes32Set storage set, bytes32 value)
894         internal
895         returns (bool)
896     {
897         return _add(set._inner, value);
898     }
899 
900     /**
901      * @dev Removes a value from a set. O(1).
902      *
903      * Returns true if the value was removed from the set, that is if it was
904      * present.
905      */
906     function remove(Bytes32Set storage set, bytes32 value)
907         internal
908         returns (bool)
909     {
910         return _remove(set._inner, value);
911     }
912 
913     /**
914      * @dev Returns true if the value is in the set. O(1).
915      */
916     function contains(Bytes32Set storage set, bytes32 value)
917         internal
918         view
919         returns (bool)
920     {
921         return _contains(set._inner, value);
922     }
923 
924     /**
925      * @dev Returns the number of values in the set. O(1).
926      */
927     function length(Bytes32Set storage set) internal view returns (uint256) {
928         return _length(set._inner);
929     }
930 
931     /**
932      * @dev Returns the value stored at position `index` in the set. O(1).
933      *
934      * Note that there are no guarantees on the ordering of values inside the
935      * array, and it may change when more values are added or removed.
936      *
937      * Requirements:
938      *
939      * - `index` must be strictly less than {length}.
940      */
941     function at(Bytes32Set storage set, uint256 index)
942         internal
943         view
944         returns (bytes32)
945     {
946         return _at(set._inner, index);
947     }
948 
949     // AddressSet
950 
951     struct AddressSet {
952         Set _inner;
953     }
954 
955     /**
956      * @dev Add a value to a set. O(1).
957      *
958      * Returns true if the value was added to the set, that is if it was not
959      * already present.
960      */
961     function add(AddressSet storage set, address value)
962         internal
963         returns (bool)
964     {
965         return _add(set._inner, bytes32(uint256(uint160(value))));
966     }
967 
968     /**
969      * @dev Removes a value from a set. O(1).
970      *
971      * Returns true if the value was removed from the set, that is if it was
972      * present.
973      */
974     function remove(AddressSet storage set, address value)
975         internal
976         returns (bool)
977     {
978         return _remove(set._inner, bytes32(uint256(uint160(value))));
979     }
980 
981     /**
982      * @dev Returns true if the value is in the set. O(1).
983      */
984     function contains(AddressSet storage set, address value)
985         internal
986         view
987         returns (bool)
988     {
989         return _contains(set._inner, bytes32(uint256(uint160(value))));
990     }
991 
992     /**
993      * @dev Returns the number of values in the set. O(1).
994      */
995     function length(AddressSet storage set) internal view returns (uint256) {
996         return _length(set._inner);
997     }
998 
999     /**
1000      * @dev Returns the value stored at position `index` in the set. O(1).
1001      *
1002      * Note that there are no guarantees on the ordering of values inside the
1003      * array, and it may change when more values are added or removed.
1004      *
1005      * Requirements:
1006      *
1007      * - `index` must be strictly less than {length}.
1008      */
1009     function at(AddressSet storage set, uint256 index)
1010         internal
1011         view
1012         returns (address)
1013     {
1014         return address(uint160(uint256(_at(set._inner, index))));
1015     }
1016 
1017     // UintSet
1018 
1019     struct UintSet {
1020         Set _inner;
1021     }
1022 
1023     /**
1024      * @dev Add a value to a set. O(1).
1025      *
1026      * Returns true if the value was added to the set, that is if it was not
1027      * already present.
1028      */
1029     function add(UintSet storage set, uint256 value) internal returns (bool) {
1030         return _add(set._inner, bytes32(value));
1031     }
1032 
1033     /**
1034      * @dev Removes a value from a set. O(1).
1035      *
1036      * Returns true if the value was removed from the set, that is if it was
1037      * present.
1038      */
1039     function remove(UintSet storage set, uint256 value)
1040         internal
1041         returns (bool)
1042     {
1043         return _remove(set._inner, bytes32(value));
1044     }
1045 
1046     /**
1047      * @dev Returns true if the value is in the set. O(1).
1048      */
1049     function contains(UintSet storage set, uint256 value)
1050         internal
1051         view
1052         returns (bool)
1053     {
1054         return _contains(set._inner, bytes32(value));
1055     }
1056 
1057     /**
1058      * @dev Returns the number of values on the set. O(1).
1059      */
1060     function length(UintSet storage set) internal view returns (uint256) {
1061         return _length(set._inner);
1062     }
1063 
1064     /**
1065      * @dev Returns the value stored at position `index` in the set. O(1).
1066      *
1067      * Note that there are no guarantees on the ordering of values inside the
1068      * array, and it may change when more values are added or removed.
1069      *
1070      * Requirements:
1071      *
1072      * - `index` must be strictly less than {length}.
1073      */
1074     function at(UintSet storage set, uint256 index)
1075         internal
1076         view
1077         returns (uint256)
1078     {
1079         return uint256(_at(set._inner, index));
1080     }
1081 }
1082 
1083 contract WaCoToken is ERC20, Ownable {
1084     using EnumerableSet for EnumerableSet.AddressSet;
1085     using Address for address;
1086 
1087     struct RoleData {
1088         EnumerableSet.AddressSet members;
1089     }
1090 
1091     mapping(bytes32 => RoleData) private _roles;
1092     bytes32 public constant BLACKLISTED_ADDRESSES =
1093         keccak256("BLACKLISTED_ADDRESSES");
1094 
1095     event RoleGranted(
1096         bytes32 indexed role,
1097         address indexed account,
1098         address indexed sender
1099     );
1100 
1101     event RoleRevoked(
1102         bytes32 indexed role,
1103         address indexed account,
1104         address indexed sender
1105     );
1106 
1107     constructor(address owner) public ERC20("Waste Coin", "WaCo") {
1108         _mint(owner, 20000000 * 10 ** 18);
1109         transferOwnership(owner);
1110     }
1111 
1112     function blacklist(address account) onlyOwner public returns (bool) {
1113         _setupRole(BLACKLISTED_ADDRESSES, account);
1114         return true;
1115     }
1116 
1117     function unblacklist(address account) onlyOwner public returns (bool) {
1118         _revokeRole(BLACKLISTED_ADDRESSES, account);
1119         return true;
1120     }
1121 
1122     function isBlacklisted(address account) public view returns (bool) {
1123         return _roles[BLACKLISTED_ADDRESSES].members.contains(account);
1124     }
1125 
1126     function getBlacklistedCount() public view returns (uint256) {
1127         return _roles[BLACKLISTED_ADDRESSES].members.length();
1128     }
1129     
1130     function hasRole(bytes32 role, address account) public view returns (bool) {
1131         return _roles[role].members.contains(account);
1132     }
1133 
1134     function _setupRole(bytes32 role, address account) internal virtual {
1135         _grantRole(role, account);
1136     }
1137 
1138     function _grantRole(bytes32 role, address account) private {
1139         if (_roles[role].members.add(account)) {
1140             emit RoleGranted(role, account, _msgSender());
1141         }
1142     }
1143 
1144     function _revokeRole(bytes32 role, address account) private {
1145         if (_roles[role].members.remove(account)) {
1146             emit RoleRevoked(role, account, _msgSender());
1147         }
1148     }
1149 
1150     function transfer(address recipient, uint256 amount) public override returns (bool) {
1151         require(
1152             !hasRole(BLACKLISTED_ADDRESSES, msg.sender),
1153             "Caller is blacklisted!"
1154         );
1155         super.transfer(recipient, amount);
1156         return true;
1157     }
1158 
1159     function mint(address recipient, uint256 amount) onlyOwner public returns (bool) {
1160         _mint(recipient, amount);
1161         return true;
1162     }
1163 }