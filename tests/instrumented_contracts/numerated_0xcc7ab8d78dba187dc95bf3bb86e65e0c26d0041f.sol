1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-03
3 */
4 
5 // File: node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\IERC20Upgradeable.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 /**
10 *This is the official contract of Spacelens and its SPACE token https://spacelens.com
11 
12 *The world of shopping and commerce must be managed and governed by its participants.
13 
14 *You must possess your data, privacy and control over your funds.
15 
16 *Sellers must control their listings, products, services, inventions, creations, designs, stories, stores.
17  
18 *Consumers must be able shop with privacy, freedom and trustworthy information. 
19 
20 *You’re not a product anymore. We are developing advanced solutions to improve commerce and the economy at large.
21  */
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20Upgradeable {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // File: node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\IERC20MetadataUpgradeable.sol
100 
101 
102 
103 /**
104  * @dev Interface for the optional metadata functions from the ERC20 standard.
105  *
106  * _Available since v4.1._
107  */
108 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
109     /**
110      * @dev Returns the name of the token.
111      */
112     function name() external view returns (string memory);
113 
114     /**
115      * @dev Returns the symbol of the token.
116      */
117     function symbol() external view returns (string memory);
118 
119     /**
120      * @dev Returns the decimals places of the token.
121      */
122     function decimals() external view returns (uint8);
123 }
124 
125 // File: node_modules\@openzeppelin\contracts-upgradeable\proxy\utils\Initializable.sol
126 
127 
128 /**
129  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
130  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
131  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
132  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
133  *
134  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
135  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
136  *
137  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
138  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
139  */
140 abstract contract Initializable {
141 
142     /**
143      * @dev Indicates that the contract has been initialized.
144      */
145     bool private _initialized;
146 
147     /**
148      * @dev Indicates that the contract is in the process of being initialized.
149      */
150     bool private _initializing;
151 
152     /**
153      * @dev Modifier to protect an initializer function from being invoked twice.
154      */
155     modifier initializer() {
156         require(_initializing || !_initialized, "Initializable: contract is already initialized");
157 
158         bool isTopLevelCall = !_initializing;
159         if (isTopLevelCall) {
160             _initializing = true;
161             _initialized = true;
162         }
163 
164         _;
165 
166         if (isTopLevelCall) {
167             _initializing = false;
168         }
169     }
170 }
171 
172 // File: node_modules\@openzeppelin\contracts-upgradeable\utils\ContextUpgradeable.sol
173 
174 
175 
176 /*
177  * @dev Provides information about the current execution context, including the
178  * sender of the transaction and its data. While these are generally available
179  * via msg.sender and msg.data, they should not be accessed in such a direct
180  * manner, since when dealing with meta-transactions the account sending and
181  * paying for execution may not be the actual sender (as far as an application
182  * is concerned).
183  *
184  * This contract is only required for intermediate, library-like contracts.
185  */
186 abstract contract ContextUpgradeable is Initializable {
187     function __Context_init() internal initializer {
188         __Context_init_unchained();
189     }
190 
191     function __Context_init_unchained() internal initializer {
192     }
193     function _msgSender() internal view virtual returns (address) {
194         return msg.sender;
195     }
196 
197     function _msgData() internal view virtual returns (bytes calldata) {
198         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
199         return msg.data;
200     }
201     uint256[50] private __gap;
202 }
203 
204 
205 
206 // File: node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\ERC20Upgradeable.sol
207 
208 
209 
210 /**
211  * @dev Implementation of the {IERC20} interface.
212  *
213  * This implementation is agnostic to the way tokens are created. This means
214  * that a supply mechanism has to be added in a derived contract using {_mint}.
215  * For a generic mechanism see {ERC20PresetMinterPauser}.
216  *
217  * TIP: For a detailed writeup see our guide
218  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
219  * to implement supply mechanisms].
220  *
221  * We have followed general OpenZeppelin guidelines: functions revert instead
222  * of returning `false` on failure. This behavior is nonetheless conventional
223  * and does not conflict with the expectations of ERC20 applications.
224  *
225  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
226  * This allows applications to reconstruct the allowance for all accounts just
227  * by listening to said events. Other implementations of the EIP may not emit
228  * these events, as it isn't required by the specification.
229  *
230  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
231  * functions have been added to mitigate the well-known issues around setting
232  * allowances. See {IERC20-approve}.
233  */
234 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
235     mapping (address => uint256) private _balances;
236 
237     mapping (address => mapping (address => uint256)) private _allowances;
238 
239     uint256 private _totalSupply;
240 
241     string private _name;
242     string private _symbol;
243 
244     /**
245      * @dev Sets the values for {name} and {symbol}.
246      *
247      * The defaut value of {decimals} is 18. To select a different value for
248      * {decimals} you should overload it.
249      *
250      * All two of these values are immutable: they can only be set once during
251      * construction.
252      */
253     function __ERC20_init(string memory name_, string memory symbol_) internal initializer {
254         __Context_init_unchained();
255         __ERC20_init_unchained(name_, symbol_);
256     }
257 
258     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal initializer {
259         _name = name_;
260         _symbol = symbol_;
261     }
262 
263     /**
264      * @dev Returns the name of the token.
265      */
266     function name() public view virtual override returns (string memory) {
267         return _name;
268     }
269 
270     /**
271      * @dev Returns the symbol of the token, usually a shorter version of the
272      * name.
273      */
274     function symbol() public view virtual override returns (string memory) {
275         return _symbol;
276     }
277 
278     /**
279      * @dev Returns the number of decimals used to get its user representation.
280      * For example, if `decimals` equals `2`, a balance of `505` tokens should
281      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
282      *
283      * Tokens usually opt for a value of 18, imitating the relationship between
284      * Ether and Wei. This is the value {ERC20} uses, unless this function is
285      * overridden;
286      *
287      * NOTE: This information is only used for _display_ purposes: it in
288      * no way affects any of the arithmetic of the contract, including
289      * {IERC20-balanceOf} and {IERC20-transfer}.
290      */
291     function decimals() public view virtual override returns (uint8) {
292         return 18;
293     }
294 
295     /**
296      * @dev See {IERC20-totalSupply}.
297      */
298     function totalSupply() public view virtual override returns (uint256) {
299         return _totalSupply;
300     }
301 
302     /**
303      * @dev See {IERC20-balanceOf}.
304      */
305     function balanceOf(address account) public view virtual override returns (uint256) {
306         return _balances[account];
307     }
308 
309     /**
310      * @dev See {IERC20-transfer}.
311      *
312      * Requirements:
313      *
314      * - `recipient` cannot be the zero address.
315      * - the caller must have a balance of at least `amount`.
316      */
317     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
318         _transfer(_msgSender(), recipient, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-allowance}.
324      */
325     function allowance(address owner, address spender) public view virtual override returns (uint256) {
326         return _allowances[owner][spender];
327     }
328 
329     /**
330      * @dev See {IERC20-approve}.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      */
336     function approve(address spender, uint256 amount) public virtual override returns (bool) {
337         _approve(_msgSender(), spender, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-transferFrom}.
343      *
344      * Emits an {Approval} event indicating the updated allowance. This is not
345      * required by the EIP. See the note at the beginning of {ERC20}.
346      *
347      * Requirements:
348      *
349      * - `sender` and `recipient` cannot be the zero address.
350      * - `sender` must have a balance of at least `amount`.
351      * - the caller must have allowance for ``sender``'s tokens of at least
352      * `amount`.
353      */
354     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
355         _transfer(sender, recipient, amount);
356 
357         uint256 currentAllowance = _allowances[sender][_msgSender()];
358         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
359         _approve(sender, _msgSender(), currentAllowance - amount);
360 
361         return true;
362     }
363 
364     /**
365      * @dev Atomically increases the allowance granted to `spender` by the caller.
366      *
367      * This is an alternative to {approve} that can be used as a mitigation for
368      * problems described in {IERC20-approve}.
369      *
370      * Emits an {Approval} event indicating the updated allowance.
371      *
372      * Requirements:
373      *
374      * - `spender` cannot be the zero address.
375      */
376     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
377         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
378         return true;
379     }
380 
381     /**
382      * @dev Atomically decreases the allowance granted to `spender` by the caller.
383      *
384      * This is an alternative to {approve} that can be used as a mitigation for
385      * problems described in {IERC20-approve}.
386      *
387      * Emits an {Approval} event indicating the updated allowance.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      * - `spender` must have allowance for the caller of at least
393      * `subtractedValue`.
394      */
395     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
396         uint256 currentAllowance = _allowances[_msgSender()][spender];
397         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
398         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
399 
400         return true;
401     }
402 
403     /**
404      * @dev Moves tokens `amount` from `sender` to `recipient`.
405      *
406      * This is internal function is equivalent to {transfer}, and can be used to
407      * e.g. implement automatic token fees, slashing mechanisms, etc.
408      *
409      * Emits a {Transfer} event.
410      *
411      * Requirements:
412      *
413      * - `sender` cannot be the zero address.
414      * - `recipient` cannot be the zero address.
415      * - `sender` must have a balance of at least `amount`.
416      */
417     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
418         require(sender != address(0), "ERC20: transfer from the zero address");
419         require(recipient != address(0), "ERC20: transfer to the zero address");
420 
421         _beforeTokenTransfer(sender, recipient, amount);
422 
423         uint256 senderBalance = _balances[sender];
424         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
425         _balances[sender] = senderBalance - amount;
426         _balances[recipient] += amount;
427 
428         emit Transfer(sender, recipient, amount);
429     }
430 
431     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
432      * the total supply.
433      *
434      * Emits a {Transfer} event with `from` set to the zero address.
435      *
436      * Requirements:
437      *
438      * - `to` cannot be the zero address.
439      */
440     function _mint(address account, uint256 amount) internal virtual {
441         require(account != address(0), "ERC20: mint to the zero address");
442 
443         _beforeTokenTransfer(address(0), account, amount);
444 
445         _totalSupply += amount;
446         _balances[account] += amount;
447         emit Transfer(address(0), account, amount);
448     }
449 
450     /**
451      * @dev Destroys `amount` tokens from `account`, reducing the
452      * total supply.
453      *
454      * Emits a {Transfer} event with `to` set to the zero address.
455      *
456      * Requirements:
457      *
458      * - `account` cannot be the zero address.
459      * - `account` must have at least `amount` tokens.
460      */
461     function _burn(address account, uint256 amount) internal virtual {
462         require(account != address(0), "ERC20: burn from the zero address");
463 
464         _beforeTokenTransfer(account, address(0), amount);
465 
466         uint256 accountBalance = _balances[account];
467         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
468         _balances[account] = accountBalance - amount;
469         _totalSupply -= amount;
470 
471         emit Transfer(account, address(0), amount);
472     }
473 
474     /**
475      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
476      *
477      * This internal function is equivalent to `approve`, and can be used to
478      * e.g. set automatic allowances for certain subsystems, etc.
479      *
480      * Emits an {Approval} event.
481      *
482      * Requirements:
483      *
484      * - `owner` cannot be the zero address.
485      * - `spender` cannot be the zero address.
486      */
487     function _approve(address owner, address spender, uint256 amount) internal virtual {
488         require(owner != address(0), "ERC20: approve from the zero address");
489         require(spender != address(0), "ERC20: approve to the zero address");
490 
491         _allowances[owner][spender] = amount;
492         emit Approval(owner, spender, amount);
493     }
494 
495     /**
496      * @dev Hook that is called before any transfer of tokens. This includes
497      * minting and burning.
498      *
499      * Calling conditions:
500      *
501      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
502      * will be to transferred to `to`.
503      * - when `from` is zero, `amount` tokens will be minted for `to`.
504      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
505      * - `from` and `to` are never both zero.
506      *
507      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
508      */
509     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
510     uint256[45] private __gap;
511 }
512 
513 // File: @openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20BurnableUpgradeable.sol
514 
515 
516 
517 /**
518  * @dev Extension of {ERC20} that allows token holders to destroy both their own
519  * tokens and those that they have an allowance for, in a way that can be
520  * recognized off-chain (via event analysis).
521  */
522 abstract contract ERC20BurnableUpgradeable is Initializable, ContextUpgradeable, ERC20Upgradeable {
523     function __ERC20Burnable_init() internal initializer {
524         __Context_init_unchained();
525         __ERC20Burnable_init_unchained();
526     }
527 
528     function __ERC20Burnable_init_unchained() internal initializer {
529     }
530     /**
531      * @dev Destroys `amount` tokens from the caller.
532      *
533      * See {ERC20-_burn}.
534      */
535     function burn(uint256 amount) public virtual {
536         _burn(_msgSender(), amount);
537     }
538 
539     /**
540      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
541      * allowance.
542      *
543      * See {ERC20-_burn} and {ERC20-allowance}.
544      *
545      * Requirements:
546      *
547      * - the caller must have allowance for ``accounts``'s tokens of at least
548      * `amount`.
549      */
550     function burnFrom(address account, uint256 amount) public virtual {
551         uint256 currentAllowance = allowance(account, _msgSender());
552         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
553         _approve(account, _msgSender(), currentAllowance - amount);
554         _burn(account, amount);
555     }
556     uint256[50] private __gap;
557 }
558 
559 // File: node_modules\@openzeppelin\contracts-upgradeable\utils\math\MathUpgradeable.sol
560 
561 
562 
563 /**
564  * @dev Standard math utilities missing in the Solidity language.
565  */
566 library MathUpgradeable {
567     /**
568      * @dev Returns the largest of two numbers.
569      */
570     function max(uint256 a, uint256 b) internal pure returns (uint256) {
571         return a >= b ? a : b;
572     }
573 
574     /**
575      * @dev Returns the smallest of two numbers.
576      */
577     function min(uint256 a, uint256 b) internal pure returns (uint256) {
578         return a < b ? a : b;
579     }
580 
581     /**
582      * @dev Returns the average of two numbers. The result is rounded towards
583      * zero.
584      */
585     function average(uint256 a, uint256 b) internal pure returns (uint256) {
586         // (a + b) / 2 can overflow, so we distribute
587         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
588     }
589 }
590 
591 // File: node_modules\@openzeppelin\contracts-upgradeable\utils\ArraysUpgradeable.sol
592 
593 
594 /**
595  * @dev Collection of functions related to array types.
596  */
597 library ArraysUpgradeable {
598    /**
599      * @dev Searches a sorted `array` and returns the first index that contains
600      * a value greater or equal to `element`. If no such index exists (i.e. all
601      * values in the array are strictly less than `element`), the array length is
602      * returned. Time complexity O(log n).
603      *
604      * `array` is expected to be sorted in ascending order, and to contain no
605      * repeated elements.
606      */
607     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
608         if (array.length == 0) {
609             return 0;
610         }
611 
612         uint256 low = 0;
613         uint256 high = array.length;
614 
615         while (low < high) {
616             uint256 mid = MathUpgradeable.average(low, high);
617 
618             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
619             // because Math.average rounds down (it does integer division with truncation).
620             if (array[mid] > element) {
621                 high = mid;
622             } else {
623                 low = mid + 1;
624             }
625         }
626 
627         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
628         if (low > 0 && array[low - 1] == element) {
629             return low - 1;
630         } else {
631             return low;
632         }
633     }
634 }
635 
636 // File: node_modules\@openzeppelin\contracts-upgradeable\utils\CountersUpgradeable.sol
637 
638 
639 /**
640  * @title Counters
641  * @author Matt Condon (@shrugs)
642  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
643  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
644  *
645  * Include with `using Counters for Counters.Counter;`
646  */
647 library CountersUpgradeable {
648     struct Counter {
649         // This variable should never be directly accessed by users of the library: interactions must be restricted to
650         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
651         // this feature: see https://github.com/ethereum/solidity/issues/4637
652         uint256 _value; // default: 0
653     }
654 
655     function current(Counter storage counter) internal view returns (uint256) {
656         return counter._value;
657     }
658 
659     function increment(Counter storage counter) internal {unchecked {counter._value += 1;}}
660 
661     function decrement(Counter storage counter) internal {
662         uint256 value = counter._value;
663         require(value > 0, "Counter: decrement overflow");
664         unchecked {
665             counter._value = value - 1;
666         }
667     }
668 }
669 
670 // File: @openzeppelin\contracts-upgradeable\token\ERC20\extensions\ERC20SnapshotUpgradeable.sol
671 
672 
673 
674 
675 /**
676  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
677  * total supply at the time are recorded for later access.
678  *
679  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
680  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
681  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
682  * used to create an efficient ERC20 forking mechanism.
683  *
684  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
685  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
686  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
687  * and the account address.
688  *
689  * ==== Gas Costs
690  *
691  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
692  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
693  * smaller since identical balances in subsequent snapshots are stored as a single entry.
694  *
695  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
696  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
697  * transfers will have normal cost until the next snapshot, and so on.
698  */
699 abstract contract ERC20SnapshotUpgradeable is Initializable, ERC20Upgradeable {
700     function __ERC20Snapshot_init() internal initializer {
701         __Context_init_unchained();
702         __ERC20Snapshot_init_unchained();
703     }
704 
705     function __ERC20Snapshot_init_unchained() internal initializer {
706     }
707     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
708     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
709 
710     using ArraysUpgradeable for uint256[];
711     using CountersUpgradeable for CountersUpgradeable.Counter;
712 
713     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
714     // Snapshot struct, but that would impede usage of functions that work on an array.
715     struct Snapshots {
716         uint256[] ids;
717         uint256[] values;
718     }
719 
720     mapping (address => Snapshots) private _accountBalanceSnapshots;
721     Snapshots private _totalSupplySnapshots;
722 
723     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
724     CountersUpgradeable.Counter private _currentSnapshotId;
725 
726     /**
727      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
728      */
729     event Snapshot(uint256 id);
730 
731     /**
732      * @dev Creates a new snapshot and returns its snapshot id.
733      *
734      * Emits a {Snapshot} event that contains the same id.
735      *
736      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
737      * set of accounts, for example using {AccessControl}, or it may be open to the public.
738      *
739      * [WARNING]
740      * ====
741      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
742      * you must consider that it can potentially be used by attackers in two ways.
743      *
744      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
745      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
746      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
747      * section above.
748      *
749      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
750      * ====
751      */
752     function _snapshot() internal virtual returns (uint256) {
753         _currentSnapshotId.increment();
754 
755         uint256 currentId = _currentSnapshotId.current();
756         emit Snapshot(currentId);
757         return currentId;
758     }
759 
760     /**
761      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
762      */
763     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
764         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
765 
766         return snapshotted ? value : balanceOf(account);
767     }
768 
769     /**
770      * @dev Retrieves the total supply at the time `snapshotId` was created.
771      */
772     function totalSupplyAt(uint256 snapshotId) public view virtual returns(uint256) {
773         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
774 
775         return snapshotted ? value : totalSupply();
776     }
777 
778 
779     // Update balance and/or total supply snapshots before the values are modified. This is implemented
780     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
781     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
782       super._beforeTokenTransfer(from, to, amount);
783 
784       if (from == address(0)) {
785         // mint
786         _updateAccountSnapshot(to);
787         _updateTotalSupplySnapshot();
788       } else if (to == address(0)) {
789         // burn
790         _updateAccountSnapshot(from);
791         _updateTotalSupplySnapshot();
792       } else {
793         // transfer
794         _updateAccountSnapshot(from);
795         _updateAccountSnapshot(to);
796       }
797     }
798 
799     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
800         private view returns (bool, uint256)
801     {
802         require(snapshotId > 0, "ERC20Snapshot: id is 0");
803         // solhint-disable-next-line max-line-length
804         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
805 
806         // When a valid snapshot is queried, there are three possibilities:
807         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
808         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
809         //  to this id is the current one.
810         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
811         //  requested id, and its value is the one to return.
812         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
813         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
814         //  larger than the requested one.
815         //
816         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
817         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
818         // exactly this.
819 
820         uint256 index = snapshots.ids.findUpperBound(snapshotId);
821 
822         if (index == snapshots.ids.length) {
823             return (false, 0);
824         } else {
825             return (true, snapshots.values[index]);
826         }
827     }
828 
829     function _updateAccountSnapshot(address account) private {
830         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
831     }
832 
833     function _updateTotalSupplySnapshot() private {
834         _updateSnapshot(_totalSupplySnapshots, totalSupply());
835     }
836 
837     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
838         uint256 currentId = _currentSnapshotId.current();
839         if (_lastSnapshotId(snapshots.ids) < currentId) {
840             snapshots.ids.push(currentId);
841             snapshots.values.push(currentValue);
842         }
843     }
844 
845     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
846         if (ids.length == 0) {
847             return 0;
848         } else {
849             return ids[ids.length - 1];
850         }
851     }
852     uint256[46] private __gap;
853 }
854 
855 // File: node_modules\@openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-IERC20PermitUpgradeable.sol
856 
857 
858 /**
859  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
860  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
861  *
862  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
863  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
864  * need to send a transaction, and thus is not required to hold Ether at all.
865  */
866 interface IERC20PermitUpgradeable {
867     /**
868      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
869      * given ``owner``'s signed approval.
870      *
871      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
872      * ordering also apply here.
873      *
874      * Emits an {Approval} event.
875      *
876      * Requirements:
877      *
878      * - `spender` cannot be the zero address.
879      * - `deadline` must be a timestamp in the future.
880      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
881      * over the EIP712-formatted function arguments.
882      * - the signature must use ``owner``'s current nonce (see {nonces}).
883      *
884      * For more information on the signature format, see the
885      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
886      * section].
887      */
888     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
889 
890     /**
891      * @dev Returns the current nonce for `owner`. This value must be
892      * included whenever a signature is generated for {permit}.
893      *
894      * Every successful call to {permit} increases ``owner``'s nonce by one. This
895      * prevents a signature from being used multiple times.
896      */
897     function nonces(address owner) external view returns (uint256);
898 
899     /**
900      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
901      */
902     // solhint-disable-next-line func-name-mixedcase
903     function DOMAIN_SEPARATOR() external view returns (bytes32);
904 }
905 
906 // File: node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\ECDSAUpgradeable.sol
907 
908 
909 
910 /**
911  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
912  *
913  * These functions can be used to verify that a message was signed by the holder
914  * of the private keys of a given address.
915  */
916 library ECDSAUpgradeable {
917     /**
918      * @dev Returns the address that signed a hashed message (`hash`) with
919      * `signature`. This address can then be used for verification purposes.
920      *
921      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
922      * this function rejects them by requiring the `s` value to be in the lower
923      * half order, and the `v` value to be either 27 or 28.
924      *
925      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
926      * verification to be secure: it is possible to craft signatures that
927      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
928      * this is by receiving a hash of the original message (which may otherwise
929      * be too long), and then calling {toEthSignedMessageHash} on it.
930      */
931     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
932         // Divide the signature in r, s and v variables
933         bytes32 r;
934         bytes32 s;
935         uint8 v;
936 
937         // Check the signature length
938         // - case 65: r,s,v signature (standard)
939         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
940         if (signature.length == 65) {
941             // ecrecover takes the signature parameters, and the only way to get them
942             // currently is to use assembly.
943             // solhint-disable-next-line no-inline-assembly
944             assembly {
945                 r := mload(add(signature, 0x20))
946                 s := mload(add(signature, 0x40))
947                 v := byte(0, mload(add(signature, 0x60)))
948             }
949         } else if (signature.length == 64) {
950             // ecrecover takes the signature parameters, and the only way to get them
951             // currently is to use assembly.
952             // solhint-disable-next-line no-inline-assembly
953             assembly {
954                 let vs := mload(add(signature, 0x40))
955                 r := mload(add(signature, 0x20))
956                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
957                 v := add(shr(255, vs), 27)
958             }
959         } else {
960             revert("ECDSA: invalid signature length");
961         }
962 
963         return recover(hash, v, r, s);
964     }
965 
966     /**
967      * @dev Overload of {ECDSA-recover} that receives the `v`,
968      * `r` and `s` signature fields separately.
969      */
970     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
971         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
972         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
973         // the valid range for s in (281): 0 < s < secp256k1n ├╖ 2 + 1, and for v in (282): v Γêê {27, 28}. Most
974         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
975         //
976         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
977         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
978         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
979         // these malleable signatures as well.
980         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
981         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
982 
983         // If the signature is valid (and not malleable), return the signer address
984         address signer = ecrecover(hash, v, r, s);
985         require(signer != address(0), "ECDSA: invalid signature");
986 
987         return signer;
988     }
989 
990     /**
991      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
992      * produces hash corresponding to the one signed with the
993      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
994      * JSON-RPC method as part of EIP-191.
995      *
996      * See {recover}.
997      */
998     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
999         // 32 is the length in bytes of hash,
1000         // enforced by the type signature above
1001         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1002     }
1003 
1004     /**
1005      * @dev Returns an Ethereum Signed Typed Data, created from a
1006      * `domainSeparator` and a `structHash`. This produces hash corresponding
1007      * to the one signed with the
1008      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1009      * JSON-RPC method as part of EIP-712.
1010      *
1011      * See {recover}.
1012      */
1013     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1014         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1015     }
1016 }
1017 
1018 // File: node_modules\@openzeppelin\contracts-upgradeable\utils\cryptography\draft-EIP712Upgradeable.sol
1019 
1020 
1021 
1022 /**
1023  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1024  *
1025  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1026  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1027  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1028  *
1029  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1030  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1031  * ({_hashTypedDataV4}).
1032  *
1033  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1034  * the chain id to protect against replay attacks on an eventual fork of the chain.
1035  *
1036  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1037  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1038  *
1039  * _Available since v3.4._
1040  */
1041 abstract contract EIP712Upgradeable is Initializable {
1042     /* solhint-disable var-name-mixedcase */
1043     bytes32 private _HASHED_NAME;
1044     bytes32 private _HASHED_VERSION;
1045     bytes32 private constant _TYPE_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1046     /* solhint-enable var-name-mixedcase */
1047 
1048     /**
1049      * @dev Initializes the domain separator and parameter caches.
1050      *
1051      * The meaning of `name` and `version` is specified in
1052      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1053      *
1054      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1055      * - `version`: the current major version of the signing domain.
1056      *
1057      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1058      * contract upgrade].
1059      */
1060     function __EIP712_init(string memory name, string memory version) internal initializer {
1061         __EIP712_init_unchained(name, version);
1062     }
1063 
1064     function __EIP712_init_unchained(string memory name, string memory version) internal initializer {
1065         bytes32 hashedName = keccak256(bytes(name));
1066         bytes32 hashedVersion = keccak256(bytes(version));
1067         _HASHED_NAME = hashedName;
1068         _HASHED_VERSION = hashedVersion;
1069     }
1070 
1071     /**
1072      * @dev Returns the domain separator for the current chain.
1073      */
1074     function _domainSeparatorV4() internal view returns (bytes32) {
1075         return _buildDomainSeparator(_TYPE_HASH, _EIP712NameHash(), _EIP712VersionHash());
1076     }
1077 
1078     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
1079         return keccak256(
1080             abi.encode(
1081                 typeHash,
1082                 name,
1083                 version,
1084                 block.chainid,
1085                 address(this)
1086             )
1087         );
1088     }
1089 
1090     /**
1091      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1092      * function returns the hash of the fully encoded EIP712 message for this domain.
1093      *
1094      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1095      *
1096      * ```solidity
1097      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1098      *     keccak256("Mail(address to,string contents)"),
1099      *     mailTo,
1100      *     keccak256(bytes(mailContents))
1101      * )));
1102      * address signer = ECDSA.recover(digest, signature);
1103      * ```
1104      */
1105     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1106         return ECDSAUpgradeable.toTypedDataHash(_domainSeparatorV4(), structHash);
1107     }
1108 
1109     /**
1110      * @dev The hash of the name parameter for the EIP712 domain.
1111      *
1112      * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
1113      * are a concern.
1114      */
1115     function _EIP712NameHash() internal virtual view returns (bytes32) {
1116         return _HASHED_NAME;
1117     }
1118 
1119     /**
1120      * @dev The hash of the version parameter for the EIP712 domain.
1121      *
1122      * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
1123      * are a concern.
1124      */
1125     function _EIP712VersionHash() internal virtual view returns (bytes32) {
1126         return _HASHED_VERSION;
1127     }
1128     uint256[50] private __gap;
1129 }
1130 
1131 // File: @openzeppelin\contracts-upgradeable\token\ERC20\extensions\draft-ERC20PermitUpgradeable.sol
1132 
1133 
1134 
1135 
1136 /**
1137  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1138  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1139  *
1140  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1141  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1142  * need to send a transaction, and thus is not required to hold Ether at all.
1143  *
1144  * _Available since v3.4._
1145  */
1146 abstract contract ERC20PermitUpgradeable is Initializable, ERC20Upgradeable, IERC20PermitUpgradeable, EIP712Upgradeable {
1147     using CountersUpgradeable for CountersUpgradeable.Counter;
1148 
1149     mapping (address => CountersUpgradeable.Counter) private _nonces;
1150 
1151     // solhint-disable-next-line var-name-mixedcase
1152     bytes32 private _PERMIT_TYPEHASH;
1153 
1154     /**
1155      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1156      *
1157      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1158      */
1159     function __ERC20Permit_init(string memory name) internal initializer {
1160         __Context_init_unchained();
1161         __EIP712_init_unchained(name, "1");
1162         __ERC20Permit_init_unchained(name);
1163     }
1164 
1165     function __ERC20Permit_init_unchained(string memory name) internal initializer {
1166         _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1167     }
1168 
1169     /**
1170      * @dev See {IERC20Permit-permit}.
1171      */
1172     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
1173         // solhint-disable-next-line not-rely-on-time
1174         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1175 
1176         bytes32 structHash = keccak256(
1177             abi.encode(
1178                 _PERMIT_TYPEHASH,
1179                 owner,
1180                 spender,
1181                 value,
1182                 _useNonce(owner),
1183                 deadline
1184             )
1185         );
1186 
1187         bytes32 hash = _hashTypedDataV4(structHash);
1188 
1189         address signer = ECDSAUpgradeable.recover(hash, v, r, s);
1190         require(signer == owner, "ERC20Permit: invalid signature");
1191 
1192         _approve(owner, spender, value);
1193     }
1194 
1195     /**
1196      * @dev See {IERC20Permit-nonces}.
1197      */
1198     function nonces(address owner) public view virtual override returns (uint256) {
1199         return _nonces[owner].current();
1200     }
1201 
1202     /**
1203      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1204      */
1205     // solhint-disable-next-line func-name-mixedcase
1206     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1207         return _domainSeparatorV4();
1208     }
1209 
1210     /**
1211      * @dev "Consume a nonce": return the current value and increment.
1212      *
1213      * _Available since v4.1._
1214      */
1215     function _useNonce(address owner) internal virtual returns (uint256 current) {
1216         CountersUpgradeable.Counter storage nonce = _nonces[owner];
1217         current = nonce.current();
1218         nonce.increment();
1219     }
1220     uint256[49] private __gap;
1221 }
1222 
1223 // File: node_modules\@openzeppelin\contracts-upgradeable\utils\StringsUpgradeable.sol
1224 
1225 
1226 
1227 /**
1228  * @dev String operations.
1229  */
1230 library StringsUpgradeable {
1231     bytes16 private constant alphabet = "0123456789abcdef";
1232 
1233     /**
1234      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1235      */
1236     function toString(uint256 value) internal pure returns (string memory) {
1237         // Inspired by OraclizeAPI's implementation - MIT licence
1238         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1239 
1240         if (value == 0) {
1241             return "0";
1242         }
1243         uint256 temp = value;
1244         uint256 digits;
1245         while (temp != 0) {
1246             digits++;
1247             temp /= 10;
1248         }
1249         bytes memory buffer = new bytes(digits);
1250         while (value != 0) {
1251             digits -= 1;
1252             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1253             value /= 10;
1254         }
1255         return string(buffer);
1256     }
1257 
1258     /**
1259      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1260      */
1261     function toHexString(uint256 value) internal pure returns (string memory) {
1262         if (value == 0) {
1263             return "0x00";
1264         }
1265         uint256 temp = value;
1266         uint256 length = 0;
1267         while (temp != 0) {
1268             length++;
1269             temp >>= 8;
1270         }
1271         return toHexString(value, length);
1272     }
1273 
1274     /**
1275      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1276      */
1277     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1278         bytes memory buffer = new bytes(2 * length + 2);
1279         buffer[0] = "0";
1280         buffer[1] = "x";
1281         for (uint256 i = 2 * length + 1; i > 1; --i) {
1282             buffer[i] = alphabet[value & 0xf];
1283             value >>= 4;
1284         }
1285         require(value == 0, "Strings: hex length insufficient");
1286         return string(buffer);
1287     }
1288 
1289 }
1290 
1291 // File: node_modules\@openzeppelin\contracts-upgradeable\utils\introspection\IERC165Upgradeable.sol
1292 
1293 
1294 
1295 /**
1296  * @dev Interface of the ERC165 standard, as defined in the
1297  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1298  *
1299  * Implementers can declare support of contract interfaces, which can then be
1300  * queried by others ({ERC165Checker}).
1301  *
1302  * For an implementation, see {ERC165}.
1303  */
1304 interface IERC165Upgradeable {
1305     /**
1306      * @dev Returns true if this contract implements the interface defined by
1307      * `interfaceId`. See the corresponding
1308      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1309      * to learn more about how these ids are created.
1310      *
1311      * This function call must use less than 30 000 gas.
1312      */
1313     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1314 }
1315 
1316 // File: node_modules\@openzeppelin\contracts-upgradeable\utils\introspection\ERC165Upgradeable.sol
1317 
1318 
1319 
1320 
1321 
1322 /**
1323  * @dev Implementation of the {IERC165} interface.
1324  *
1325  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1326  * for the additional interface id that will be supported. For example:
1327  *
1328  * ```solidity
1329  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1330  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1331  * }
1332  * ```
1333  *
1334  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1335  */
1336 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
1337     function __ERC165_init() internal initializer {
1338         __ERC165_init_unchained();
1339     }
1340 
1341     function __ERC165_init_unchained() internal initializer {
1342     }
1343     /**
1344      * @dev See {IERC165-supportsInterface}.
1345      */
1346     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1347         return interfaceId == type(IERC165Upgradeable).interfaceId;
1348     }
1349     uint256[50] private __gap;
1350 }
1351 
1352 // File: @openzeppelin\contracts-upgradeable\access\AccessControlUpgradeable.sol
1353 
1354 
1355 
1356 
1357 
1358 
1359 /**
1360  * @dev External interface of AccessControl declared to support ERC165 detection.
1361  */
1362 interface IAccessControlUpgradeable {
1363     function hasRole(bytes32 role, address account) external view returns (bool);
1364     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1365     function grantRole(bytes32 role, address account) external;
1366     function revokeRole(bytes32 role, address account) external;
1367     function renounceRole(bytes32 role, address account) external;
1368 }
1369 
1370 /**
1371  * @dev Contract module that allows children to implement role-based access
1372  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1373  * members except through off-chain means by accessing the contract event logs. Some
1374  * applications may benefit from on-chain enumerability, for those cases see
1375  * {AccessControlEnumerable}.
1376  *
1377  * Roles are referred to by their `bytes32` identifier. These should be exposed
1378  * in the external API and be unique. The best way to achieve this is by
1379  * using `public constant` hash digests:
1380  *
1381  * ```
1382  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1383  * ```
1384  *
1385  * Roles can be used to represent a set of permissions. To restrict access to a
1386  * function call, use {hasRole}:
1387  *
1388  * ```
1389  * function foo() public {
1390  *     require(hasRole(MY_ROLE, msg.sender));
1391  *     ...
1392  * }
1393  * ```
1394  *
1395  * Roles can be granted and revoked dynamically via the {grantRole} and
1396  * {revokeRole} functions. Each role has an associated admin role, and only
1397  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1398  *
1399  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1400  * that only accounts with this role will be able to grant or revoke other
1401  * roles. More complex role relationships can be created by using
1402  * {_setRoleAdmin}.
1403  *
1404  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1405  * grant and revoke this role. Extra precautions should be taken to secure
1406  * accounts that have been granted it.
1407  */
1408 abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable, IAccessControlUpgradeable, ERC165Upgradeable {
1409     function __AccessControl_init() internal initializer {
1410         __Context_init_unchained();
1411         __ERC165_init_unchained();
1412         __AccessControl_init_unchained();
1413     }
1414 
1415     function __AccessControl_init_unchained() internal initializer {
1416     }
1417     struct RoleData {
1418         mapping (address => bool) members;
1419         bytes32 adminRole;
1420     }
1421 
1422     mapping (bytes32 => RoleData) private _roles;
1423 
1424     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1425 
1426     /**
1427      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1428      *
1429      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1430      * {RoleAdminChanged} not being emitted signaling this.
1431      *
1432      * _Available since v3.1._
1433      */
1434     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1435 
1436     /**
1437      * @dev Emitted when `account` is granted `role`.
1438      *
1439      * `sender` is the account that originated the contract call, an admin role
1440      * bearer except when using {_setupRole}.
1441      */
1442     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1443 
1444     /**
1445      * @dev Emitted when `account` is revoked `role`.
1446      *
1447      * `sender` is the account that originated the contract call:
1448      *   - if using `revokeRole`, it is the admin role bearer
1449      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1450      */
1451     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1452 
1453     /**
1454      * @dev Modifier that checks that an account has a specific role. Reverts
1455      * with a standardized message including the required role.
1456      *
1457      * The format of the revert reason is given by the following regular expression:
1458      *
1459      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1460      *
1461      * _Available since v4.1._
1462      */
1463     modifier onlyRole(bytes32 role) {
1464         _checkRole(role, _msgSender());
1465         _;
1466     }
1467 
1468     /**
1469      * @dev See {IERC165-supportsInterface}.
1470      */
1471     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1472         return interfaceId == type(IAccessControlUpgradeable).interfaceId
1473             || super.supportsInterface(interfaceId);
1474     }
1475 
1476     /**
1477      * @dev Returns `true` if `account` has been granted `role`.
1478      */
1479     function hasRole(bytes32 role, address account) public view override returns (bool) {
1480         return _roles[role].members[account];
1481     }
1482 
1483     /**
1484      * @dev Revert with a standard message if `account` is missing `role`.
1485      *
1486      * The format of the revert reason is given by the following regular expression:
1487      *
1488      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1489      */
1490     function _checkRole(bytes32 role, address account) internal view {
1491         if(!hasRole(role, account)) {
1492             revert(string(abi.encodePacked(
1493                 "AccessControl: account ",
1494                 StringsUpgradeable.toHexString(uint160(account), 20),
1495                 " is missing role ",
1496                 StringsUpgradeable.toHexString(uint256(role), 32)
1497             )));
1498         }
1499     }
1500 
1501     /**
1502      * @dev Returns the admin role that controls `role`. See {grantRole} and
1503      * {revokeRole}.
1504      *
1505      * To change a role's admin, use {_setRoleAdmin}.
1506      */
1507     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1508         return _roles[role].adminRole;
1509     }
1510 
1511     /**
1512      * @dev Grants `role` to `account`.
1513      *
1514      * If `account` had not been already granted `role`, emits a {RoleGranted}
1515      * event.
1516      *
1517      * Requirements:
1518      *
1519      * - the caller must have ``role``'s admin role.
1520      */
1521     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1522         _grantRole(role, account);
1523     }
1524 
1525     /**
1526      * @dev Revokes `role` from `account`.
1527      *
1528      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1529      *
1530      * Requirements:
1531      *
1532      * - the caller must have ``role``'s admin role.
1533      */
1534     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1535         _revokeRole(role, account);
1536     }
1537 
1538     /**
1539      * @dev Revokes `role` from the calling account.
1540      *
1541      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1542      * purpose is to provide a mechanism for accounts to lose their privileges
1543      * if they are compromised (such as when a trusted device is misplaced).
1544      *
1545      * If the calling account had been granted `role`, emits a {RoleRevoked}
1546      * event.
1547      *
1548      * Requirements:
1549      *
1550      * - the caller must be `account`.
1551      */
1552     function renounceRole(bytes32 role, address account) public virtual override {
1553         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1554 
1555         _revokeRole(role, account);
1556     }
1557 
1558     /**
1559      * @dev Grants `role` to `account`.
1560      *
1561      * If `account` had not been already granted `role`, emits a {RoleGranted}
1562      * event. Note that unlike {grantRole}, this function doesn't perform any
1563      * checks on the calling account.
1564      *
1565      * [WARNING]
1566      * ====
1567      * This function should only be called from the constructor when setting
1568      * up the initial roles for the system.
1569      *
1570      * Using this function in any other way is effectively circumventing the admin
1571      * system imposed by {AccessControl}.
1572      * ====
1573      */
1574     function _setupRole(bytes32 role, address account) internal virtual {
1575         _grantRole(role, account);
1576     }
1577 
1578     /**
1579      * @dev Sets `adminRole` as ``role``'s admin role.
1580      *
1581      * Emits a {RoleAdminChanged} event.
1582      */
1583     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1584         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1585         _roles[role].adminRole = adminRole;
1586     }
1587 
1588     function _grantRole(bytes32 role, address account) private {
1589         if (!hasRole(role, account)) {
1590             _roles[role].members[account] = true;
1591             emit RoleGranted(role, account, _msgSender());
1592         }
1593     }
1594 
1595     function _revokeRole(bytes32 role, address account) private {
1596         if (hasRole(role, account)) {
1597             _roles[role].members[account] = false;
1598             emit RoleRevoked(role, account, _msgSender());
1599         }
1600     }
1601     uint256[49] private __gap;
1602 }
1603 
1604 // File: @openzeppelin\contracts-upgradeable\security\PausableUpgradeable.sol
1605 
1606 
1607 
1608 
1609 
1610 /**
1611  * @dev Contract module which allows children to implement an emergency stop
1612  * mechanism that can be triggered by an authorized account.
1613  *
1614  * This module is used through inheritance. It will make available the
1615  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1616  * the functions of your contract. Note that they will not be pausable by
1617  * simply including this module, only once the modifiers are put in place.
1618  */
1619 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
1620     /**
1621      * @dev Emitted when the pause is triggered by `account`.
1622      */
1623     event Paused(address account);
1624 
1625     /**
1626      * @dev Emitted when the pause is lifted by `account`.
1627      */
1628     event Unpaused(address account);
1629 
1630     bool private _paused;
1631 
1632     /**
1633      * @dev Initializes the contract in unpaused state.
1634      */
1635     function __Pausable_init() internal initializer {
1636         __Context_init_unchained();
1637         __Pausable_init_unchained();
1638     }
1639 
1640     function __Pausable_init_unchained() internal initializer {
1641         _paused = false;
1642     }
1643 
1644     /**
1645      * @dev Returns true if the contract is paused, and false otherwise.
1646      */
1647     function paused() public view virtual returns (bool) {
1648         return _paused;
1649     }
1650 
1651     /**
1652      * @dev Modifier to make a function callable only when the contract is not paused.
1653      *
1654      * Requirements:
1655      *
1656      * - The contract must not be paused.
1657      */
1658     modifier whenNotPaused() {
1659         require(!paused(), "Pausable: paused");
1660         _;
1661     }
1662 
1663     /**
1664      * @dev Modifier to make a function callable only when the contract is paused.
1665      *
1666      * Requirements:
1667      *
1668      * - The contract must be paused.
1669      */
1670     modifier whenPaused() {
1671         require(paused(), "Pausable: not paused");
1672         _;
1673     }
1674 
1675     /**
1676      * @dev Triggers stopped state.
1677      *
1678      * Requirements:
1679      *
1680      * - The contract must not be paused.
1681      */
1682     function _pause() internal virtual whenNotPaused {
1683         _paused = true;
1684         emit Paused(_msgSender());
1685     }
1686 
1687     /**
1688      * @dev Returns to normal state.
1689      *
1690      * Requirements:
1691      *
1692      * - The contract must be paused.
1693      */
1694     function _unpause() internal virtual whenPaused {
1695         _paused = false;
1696         emit Unpaused(_msgSender());
1697     }
1698     uint256[49] private __gap;
1699 }
1700 
1701 // File: contracts\space.sol
1702 
1703 pragma solidity ^0.8.0;
1704 
1705 
1706 
1707 
1708 
1709 
1710 
1711 
1712 contract SPACE is ERC20Upgradeable, ERC20BurnableUpgradeable, ERC20SnapshotUpgradeable, AccessControlUpgradeable, PausableUpgradeable, ERC20PermitUpgradeable {
1713     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1714     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1715     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1716     
1717     
1718     function initialize() initializer public {
1719         __ERC20_init_unchained("Spacelens", "SPACE");
1720         __ERC20Permit_init_unchained("Spacelens");
1721         
1722         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1723         _setupRole(SNAPSHOT_ROLE, msg.sender);
1724         _setupRole(PAUSER_ROLE, msg.sender);
1725         _setupRole(MINTER_ROLE, msg.sender);
1726     }
1727 
1728 
1729     function snapshot() public {
1730         require(hasRole(SNAPSHOT_ROLE, msg.sender));
1731         _snapshot();
1732     }
1733 
1734     function pause() public {
1735         require(hasRole(PAUSER_ROLE, msg.sender));
1736         _pause();
1737     }
1738 
1739     function unpause() public {
1740         require(hasRole(PAUSER_ROLE, msg.sender));
1741         _unpause();
1742     }
1743 
1744     function mint(address to, uint256 amount) public {
1745         require(hasRole(MINTER_ROLE, msg.sender));
1746         _mint(to, amount);
1747     }
1748 
1749     function _beforeTokenTransfer(address from, address to, uint256 amount)
1750         internal
1751         whenNotPaused
1752         override(ERC20Upgradeable, ERC20SnapshotUpgradeable)
1753     {
1754         super._beforeTokenTransfer(from, to, amount);
1755     }
1756 }