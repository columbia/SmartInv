1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.0.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/utils/Context.sol@v4.0.0
85 
86 
87 
88 pragma solidity ^0.8.0;
89 
90 /*
91  * @dev Provides information about the current execution context, including the
92  * sender of the transaction and its data. While these are generally available
93  * via msg.sender and msg.data, they should not be accessed in such a direct
94  * manner, since when dealing with meta-transactions the account sending and
95  * paying for execution may not be the actual sender (as far as an application
96  * is concerned).
97  *
98  * This contract is only required for intermediate, library-like contracts.
99  */
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
107         return msg.data;
108     }
109 }
110 
111 
112 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.0.0
113 
114 
115 
116 pragma solidity ^0.8.0;
117 
118 
119 /**
120  * @dev Implementation of the {IERC20} interface.
121  *
122  * This implementation is agnostic to the way tokens are created. This means
123  * that a supply mechanism has to be added in a derived contract using {_mint}.
124  * For a generic mechanism see {ERC20PresetMinterPauser}.
125  *
126  * TIP: For a detailed writeup see our guide
127  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
128  * to implement supply mechanisms].
129  *
130  * We have followed general OpenZeppelin guidelines: functions revert instead
131  * of returning `false` on failure. This behavior is nonetheless conventional
132  * and does not conflict with the expectations of ERC20 applications.
133  *
134  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
135  * This allows applications to reconstruct the allowance for all accounts just
136  * by listening to said events. Other implementations of the EIP may not emit
137  * these events, as it isn't required by the specification.
138  *
139  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
140  * functions have been added to mitigate the well-known issues around setting
141  * allowances. See {IERC20-approve}.
142  */
143 contract ERC20 is Context, IERC20 {
144     mapping (address => uint256) private _balances;
145 
146     mapping (address => mapping (address => uint256)) private _allowances;
147 
148     uint256 private _totalSupply;
149 
150     string private _name;
151     string private _symbol;
152 
153     /**
154      * @dev Sets the values for {name} and {symbol}.
155      *
156      * The defaut value of {decimals} is 18. To select a different value for
157      * {decimals} you should overload it.
158      *
159      * All three of these values are immutable: they can only be set once during
160      * construction.
161      */
162     constructor (string memory name_, string memory symbol_) {
163         _name = name_;
164         _symbol = symbol_;
165     }
166 
167     /**
168      * @dev Returns the name of the token.
169      */
170     function name() public view virtual returns (string memory) {
171         return _name;
172     }
173 
174     /**
175      * @dev Returns the symbol of the token, usually a shorter version of the
176      * name.
177      */
178     function symbol() public view virtual returns (string memory) {
179         return _symbol;
180     }
181 
182     /**
183      * @dev Returns the number of decimals used to get its user representation.
184      * For example, if `decimals` equals `2`, a balance of `505` tokens should
185      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
186      *
187      * Tokens usually opt for a value of 18, imitating the relationship between
188      * Ether and Wei. This is the value {ERC20} uses, unless this function is
189      * overloaded;
190      *
191      * NOTE: This information is only used for _display_ purposes: it in
192      * no way affects any of the arithmetic of the contract, including
193      * {IERC20-balanceOf} and {IERC20-transfer}.
194      */
195     function decimals() public view virtual returns (uint8) {
196         return 18;
197     }
198 
199     /**
200      * @dev See {IERC20-totalSupply}.
201      */
202     function totalSupply() public view virtual override returns (uint256) {
203         return _totalSupply;
204     }
205 
206     /**
207      * @dev See {IERC20-balanceOf}.
208      */
209     function balanceOf(address account) public view virtual override returns (uint256) {
210         return _balances[account];
211     }
212 
213     /**
214      * @dev See {IERC20-transfer}.
215      *
216      * Requirements:
217      *
218      * - `recipient` cannot be the zero address.
219      * - the caller must have a balance of at least `amount`.
220      */
221     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
222         _transfer(_msgSender(), recipient, amount);
223         return true;
224     }
225 
226     /**
227      * @dev See {IERC20-allowance}.
228      */
229     function allowance(address owner, address spender) public view virtual override returns (uint256) {
230         return _allowances[owner][spender];
231     }
232 
233     /**
234      * @dev See {IERC20-approve}.
235      *
236      * Requirements:
237      *
238      * - `spender` cannot be the zero address.
239      */
240     function approve(address spender, uint256 amount) public virtual override returns (bool) {
241         _approve(_msgSender(), spender, amount);
242         return true;
243     }
244 
245     /**
246      * @dev See {IERC20-transferFrom}.
247      *
248      * Emits an {Approval} event indicating the updated allowance. This is not
249      * required by the EIP. See the note at the beginning of {ERC20}.
250      *
251      * Requirements:
252      *
253      * - `sender` and `recipient` cannot be the zero address.
254      * - `sender` must have a balance of at least `amount`.
255      * - the caller must have allowance for ``sender``'s tokens of at least
256      * `amount`.
257      */
258     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
259         _transfer(sender, recipient, amount);
260 
261         uint256 currentAllowance = _allowances[sender][_msgSender()];
262         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
263         _approve(sender, _msgSender(), currentAllowance - amount);
264 
265         return true;
266     }
267 
268     /**
269      * @dev Atomically increases the allowance granted to `spender` by the caller.
270      *
271      * This is an alternative to {approve} that can be used as a mitigation for
272      * problems described in {IERC20-approve}.
273      *
274      * Emits an {Approval} event indicating the updated allowance.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
281         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
282         return true;
283     }
284 
285     /**
286      * @dev Atomically decreases the allowance granted to `spender` by the caller.
287      *
288      * This is an alternative to {approve} that can be used as a mitigation for
289      * problems described in {IERC20-approve}.
290      *
291      * Emits an {Approval} event indicating the updated allowance.
292      *
293      * Requirements:
294      *
295      * - `spender` cannot be the zero address.
296      * - `spender` must have allowance for the caller of at least
297      * `subtractedValue`.
298      */
299     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
300         uint256 currentAllowance = _allowances[_msgSender()][spender];
301         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
302         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
303 
304         return true;
305     }
306 
307     /**
308      * @dev Moves tokens `amount` from `sender` to `recipient`.
309      *
310      * This is internal function is equivalent to {transfer}, and can be used to
311      * e.g. implement automatic token fees, slashing mechanisms, etc.
312      *
313      * Emits a {Transfer} event.
314      *
315      * Requirements:
316      *
317      * - `sender` cannot be the zero address.
318      * - `recipient` cannot be the zero address.
319      * - `sender` must have a balance of at least `amount`.
320      */
321     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
322         require(sender != address(0), "ERC20: transfer from the zero address");
323         require(recipient != address(0), "ERC20: transfer to the zero address");
324 
325         _beforeTokenTransfer(sender, recipient, amount);
326 
327         uint256 senderBalance = _balances[sender];
328         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
329         _balances[sender] = senderBalance - amount;
330         _balances[recipient] += amount;
331 
332         emit Transfer(sender, recipient, amount);
333     }
334 
335     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
336      * the total supply.
337      *
338      * Emits a {Transfer} event with `from` set to the zero address.
339      *
340      * Requirements:
341      *
342      * - `to` cannot be the zero address.
343      */
344     function _mint(address account, uint256 amount) internal virtual {
345         require(account != address(0), "ERC20: mint to the zero address");
346 
347         _beforeTokenTransfer(address(0), account, amount);
348 
349         _totalSupply += amount;
350         _balances[account] += amount;
351         emit Transfer(address(0), account, amount);
352     }
353 
354     /**
355      * @dev Destroys `amount` tokens from `account`, reducing the
356      * total supply.
357      *
358      * Emits a {Transfer} event with `to` set to the zero address.
359      *
360      * Requirements:
361      *
362      * - `account` cannot be the zero address.
363      * - `account` must have at least `amount` tokens.
364      */
365     function _burn(address account, uint256 amount) internal virtual {
366         require(account != address(0), "ERC20: burn from the zero address");
367 
368         _beforeTokenTransfer(account, address(0), amount);
369 
370         uint256 accountBalance = _balances[account];
371         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
372         _balances[account] = accountBalance - amount;
373         _totalSupply -= amount;
374 
375         emit Transfer(account, address(0), amount);
376     }
377 
378     /**
379      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
380      *
381      * This internal function is equivalent to `approve`, and can be used to
382      * e.g. set automatic allowances for certain subsystems, etc.
383      *
384      * Emits an {Approval} event.
385      *
386      * Requirements:
387      *
388      * - `owner` cannot be the zero address.
389      * - `spender` cannot be the zero address.
390      */
391     function _approve(address owner, address spender, uint256 amount) internal virtual {
392         require(owner != address(0), "ERC20: approve from the zero address");
393         require(spender != address(0), "ERC20: approve to the zero address");
394 
395         _allowances[owner][spender] = amount;
396         emit Approval(owner, spender, amount);
397     }
398 
399     /**
400      * @dev Hook that is called before any transfer of tokens. This includes
401      * minting and burning.
402      *
403      * Calling conditions:
404      *
405      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
406      * will be to transferred to `to`.
407      * - when `from` is zero, `amount` tokens will be minted for `to`.
408      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
409      * - `from` and `to` are never both zero.
410      *
411      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
412      */
413     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
414 }
415 
416 
417 // File @openzeppelin/contracts/utils/math/Math.sol@v4.0.0
418 
419 
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev Standard math utilities missing in the Solidity language.
425  */
426 library Math {
427     /**
428      * @dev Returns the largest of two numbers.
429      */
430     function max(uint256 a, uint256 b) internal pure returns (uint256) {
431         return a >= b ? a : b;
432     }
433 
434     /**
435      * @dev Returns the smallest of two numbers.
436      */
437     function min(uint256 a, uint256 b) internal pure returns (uint256) {
438         return a < b ? a : b;
439     }
440 
441     /**
442      * @dev Returns the average of two numbers. The result is rounded towards
443      * zero.
444      */
445     function average(uint256 a, uint256 b) internal pure returns (uint256) {
446         // (a + b) / 2 can overflow, so we distribute
447         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
448     }
449 }
450 
451 
452 // File @openzeppelin/contracts/utils/Arrays.sol@v4.0.0
453 
454 
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev Collection of functions related to array types.
460  */
461 library Arrays {
462    /**
463      * @dev Searches a sorted `array` and returns the first index that contains
464      * a value greater or equal to `element`. If no such index exists (i.e. all
465      * values in the array are strictly less than `element`), the array length is
466      * returned. Time complexity O(log n).
467      *
468      * `array` is expected to be sorted in ascending order, and to contain no
469      * repeated elements.
470      */
471     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
472         if (array.length == 0) {
473             return 0;
474         }
475 
476         uint256 low = 0;
477         uint256 high = array.length;
478 
479         while (low < high) {
480             uint256 mid = Math.average(low, high);
481 
482             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
483             // because Math.average rounds down (it does integer division with truncation).
484             if (array[mid] > element) {
485                 high = mid;
486             } else {
487                 low = mid + 1;
488             }
489         }
490 
491         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
492         if (low > 0 && array[low - 1] == element) {
493             return low - 1;
494         } else {
495             return low;
496         }
497     }
498 }
499 
500 
501 // File @openzeppelin/contracts/utils/Counters.sol@v4.0.0
502 
503 
504 
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @title Counters
509  * @author Matt Condon (@shrugs)
510  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
511  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
512  *
513  * Include with `using Counters for Counters.Counter;`
514  */
515 library Counters {
516     struct Counter {
517         // This variable should never be directly accessed by users of the library: interactions must be restricted to
518         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
519         // this feature: see https://github.com/ethereum/solidity/issues/4637
520         uint256 _value; // default: 0
521     }
522 
523     function current(Counter storage counter) internal view returns (uint256) {
524         return counter._value;
525     }
526 
527     function increment(Counter storage counter) internal {
528         unchecked {
529             counter._value += 1;
530         }
531     }
532 
533     function decrement(Counter storage counter) internal {
534         uint256 value = counter._value;
535         require(value > 0, "Counter: decrement overflow");
536         unchecked {
537             counter._value = value - 1;
538         }
539     }
540 }
541 
542 
543 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol@v4.0.0
544 
545 
546 
547 pragma solidity ^0.8.0;
548 
549 
550 
551 /**
552  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
553  * total supply at the time are recorded for later access.
554  *
555  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
556  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
557  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
558  * used to create an efficient ERC20 forking mechanism.
559  *
560  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
561  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
562  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
563  * and the account address.
564  *
565  * ==== Gas Costs
566  *
567  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
568  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
569  * smaller since identical balances in subsequent snapshots are stored as a single entry.
570  *
571  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
572  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
573  * transfers will have normal cost until the next snapshot, and so on.
574  */
575 abstract contract ERC20Snapshot is ERC20 {
576     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
577     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
578 
579     using Arrays for uint256[];
580     using Counters for Counters.Counter;
581 
582     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
583     // Snapshot struct, but that would impede usage of functions that work on an array.
584     struct Snapshots {
585         uint256[] ids;
586         uint256[] values;
587     }
588 
589     mapping (address => Snapshots) private _accountBalanceSnapshots;
590     Snapshots private _totalSupplySnapshots;
591 
592     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
593     Counters.Counter private _currentSnapshotId;
594 
595     /**
596      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
597      */
598     event Snapshot(uint256 id);
599 
600     /**
601      * @dev Creates a new snapshot and returns its snapshot id.
602      *
603      * Emits a {Snapshot} event that contains the same id.
604      *
605      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
606      * set of accounts, for example using {AccessControl}, or it may be open to the public.
607      *
608      * [WARNING]
609      * ====
610      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
611      * you must consider that it can potentially be used by attackers in two ways.
612      *
613      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
614      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
615      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
616      * section above.
617      *
618      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
619      * ====
620      */
621     function _snapshot() internal virtual returns (uint256) {
622         _currentSnapshotId.increment();
623 
624         uint256 currentId = _currentSnapshotId.current();
625         emit Snapshot(currentId);
626         return currentId;
627     }
628 
629     /**
630      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
631      */
632     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
633         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
634 
635         return snapshotted ? value : balanceOf(account);
636     }
637 
638     /**
639      * @dev Retrieves the total supply at the time `snapshotId` was created.
640      */
641     function totalSupplyAt(uint256 snapshotId) public view virtual returns(uint256) {
642         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
643 
644         return snapshotted ? value : totalSupply();
645     }
646 
647 
648     // Update balance and/or total supply snapshots before the values are modified. This is implemented
649     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
650     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
651       super._beforeTokenTransfer(from, to, amount);
652 
653       if (from == address(0)) {
654         // mint
655         _updateAccountSnapshot(to);
656         _updateTotalSupplySnapshot();
657       } else if (to == address(0)) {
658         // burn
659         _updateAccountSnapshot(from);
660         _updateTotalSupplySnapshot();
661       } else {
662         // transfer
663         _updateAccountSnapshot(from);
664         _updateAccountSnapshot(to);
665       }
666     }
667 
668     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
669         private view returns (bool, uint256)
670     {
671         require(snapshotId > 0, "ERC20Snapshot: id is 0");
672         // solhint-disable-next-line max-line-length
673         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
674 
675         // When a valid snapshot is queried, there are three possibilities:
676         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
677         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
678         //  to this id is the current one.
679         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
680         //  requested id, and its value is the one to return.
681         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
682         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
683         //  larger than the requested one.
684         //
685         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
686         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
687         // exactly this.
688 
689         uint256 index = snapshots.ids.findUpperBound(snapshotId);
690 
691         if (index == snapshots.ids.length) {
692             return (false, 0);
693         } else {
694             return (true, snapshots.values[index]);
695         }
696     }
697 
698     function _updateAccountSnapshot(address account) private {
699         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
700     }
701 
702     function _updateTotalSupplySnapshot() private {
703         _updateSnapshot(_totalSupplySnapshots, totalSupply());
704     }
705 
706     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
707         uint256 currentId = _currentSnapshotId.current();
708         if (_lastSnapshotId(snapshots.ids) < currentId) {
709             snapshots.ids.push(currentId);
710             snapshots.values.push(currentValue);
711         }
712     }
713 
714     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
715         if (ids.length == 0) {
716             return 0;
717         } else {
718             return ids[ids.length - 1];
719         }
720     }
721 }
722 
723 
724 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.0.0
725 
726 
727 
728 pragma solidity ^0.8.0;
729 
730 
731 /**
732  * @dev Extension of {ERC20} that allows token holders to destroy both their own
733  * tokens and those that they have an allowance for, in a way that can be
734  * recognized off-chain (via event analysis).
735  */
736 abstract contract ERC20Burnable is Context, ERC20 {
737     /**
738      * @dev Destroys `amount` tokens from the caller.
739      *
740      * See {ERC20-_burn}.
741      */
742     function burn(uint256 amount) public virtual {
743         _burn(_msgSender(), amount);
744     }
745 
746     /**
747      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
748      * allowance.
749      *
750      * See {ERC20-_burn} and {ERC20-allowance}.
751      *
752      * Requirements:
753      *
754      * - the caller must have allowance for ``accounts``'s tokens of at least
755      * `amount`.
756      */
757     function burnFrom(address account, uint256 amount) public virtual {
758         uint256 currentAllowance = allowance(account, _msgSender());
759         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
760         _approve(account, _msgSender(), currentAllowance - amount);
761         _burn(account, amount);
762     }
763 }
764 
765 
766 // File @openzeppelin/contracts/security/Pausable.sol@v4.0.0
767 
768 
769 
770 pragma solidity ^0.8.0;
771 
772 /**
773  * @dev Contract module which allows children to implement an emergency stop
774  * mechanism that can be triggered by an authorized account.
775  *
776  * This module is used through inheritance. It will make available the
777  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
778  * the functions of your contract. Note that they will not be pausable by
779  * simply including this module, only once the modifiers are put in place.
780  */
781 abstract contract Pausable is Context {
782     /**
783      * @dev Emitted when the pause is triggered by `account`.
784      */
785     event Paused(address account);
786 
787     /**
788      * @dev Emitted when the pause is lifted by `account`.
789      */
790     event Unpaused(address account);
791 
792     bool private _paused;
793 
794     /**
795      * @dev Initializes the contract in unpaused state.
796      */
797     constructor () {
798         _paused = false;
799     }
800 
801     /**
802      * @dev Returns true if the contract is paused, and false otherwise.
803      */
804     function paused() public view virtual returns (bool) {
805         return _paused;
806     }
807 
808     /**
809      * @dev Modifier to make a function callable only when the contract is not paused.
810      *
811      * Requirements:
812      *
813      * - The contract must not be paused.
814      */
815     modifier whenNotPaused() {
816         require(!paused(), "Pausable: paused");
817         _;
818     }
819 
820     /**
821      * @dev Modifier to make a function callable only when the contract is paused.
822      *
823      * Requirements:
824      *
825      * - The contract must be paused.
826      */
827     modifier whenPaused() {
828         require(paused(), "Pausable: not paused");
829         _;
830     }
831 
832     /**
833      * @dev Triggers stopped state.
834      *
835      * Requirements:
836      *
837      * - The contract must not be paused.
838      */
839     function _pause() internal virtual whenNotPaused {
840         _paused = true;
841         emit Paused(_msgSender());
842     }
843 
844     /**
845      * @dev Returns to normal state.
846      *
847      * Requirements:
848      *
849      * - The contract must be paused.
850      */
851     function _unpause() internal virtual whenPaused {
852         _paused = false;
853         emit Unpaused(_msgSender());
854     }
855 }
856 
857 
858 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol@v4.0.0
859 
860 
861 
862 pragma solidity ^0.8.0;
863 
864 
865 /**
866  * @dev ERC20 token with pausable token transfers, minting and burning.
867  *
868  * Useful for scenarios such as preventing trades until the end of an evaluation
869  * period, or having an emergency switch for freezing all token transfers in the
870  * event of a large bug.
871  */
872 abstract contract ERC20Pausable is ERC20, Pausable {
873     /**
874      * @dev See {ERC20-_beforeTokenTransfer}.
875      *
876      * Requirements:
877      *
878      * - the contract must not be paused.
879      */
880     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
881         super._beforeTokenTransfer(from, to, amount);
882 
883         require(!paused(), "ERC20Pausable: token transfer while paused");
884     }
885 }
886 
887 
888 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.0.0
889 
890 
891 
892 pragma solidity ^0.8.0;
893 
894 /**
895  * @dev Interface of the ERC165 standard, as defined in the
896  * https://eips.ethereum.org/EIPS/eip-165[EIP].
897  *
898  * Implementers can declare support of contract interfaces, which can then be
899  * queried by others ({ERC165Checker}).
900  *
901  * For an implementation, see {ERC165}.
902  */
903 interface IERC165 {
904     /**
905      * @dev Returns true if this contract implements the interface defined by
906      * `interfaceId`. See the corresponding
907      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
908      * to learn more about how these ids are created.
909      *
910      * This function call must use less than 30 000 gas.
911      */
912     function supportsInterface(bytes4 interfaceId) external view returns (bool);
913 }
914 
915 
916 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.0.0
917 
918 
919 
920 pragma solidity ^0.8.0;
921 
922 /**
923  * @dev Implementation of the {IERC165} interface.
924  *
925  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
926  * for the additional interface id that will be supported. For example:
927  *
928  * ```solidity
929  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
930  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
931  * }
932  * ```
933  *
934  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
935  */
936 abstract contract ERC165 is IERC165 {
937     /**
938      * @dev See {IERC165-supportsInterface}.
939      */
940     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
941         return interfaceId == type(IERC165).interfaceId;
942     }
943 }
944 
945 
946 // File @openzeppelin/contracts/access/AccessControl.sol@v4.0.0
947 
948 
949 
950 pragma solidity ^0.8.0;
951 
952 
953 /**
954  * @dev External interface of AccessControl declared to support ERC165 detection.
955  */
956 interface IAccessControl {
957     function hasRole(bytes32 role, address account) external view returns (bool);
958     function getRoleAdmin(bytes32 role) external view returns (bytes32);
959     function grantRole(bytes32 role, address account) external;
960     function revokeRole(bytes32 role, address account) external;
961     function renounceRole(bytes32 role, address account) external;
962 }
963 
964 /**
965  * @dev Contract module that allows children to implement role-based access
966  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
967  * members except through off-chain means by accessing the contract event logs. Some
968  * applications may benefit from on-chain enumerability, for those cases see
969  * {AccessControlEnumerable}.
970  *
971  * Roles are referred to by their `bytes32` identifier. These should be exposed
972  * in the external API and be unique. The best way to achieve this is by
973  * using `public constant` hash digests:
974  *
975  * ```
976  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
977  * ```
978  *
979  * Roles can be used to represent a set of permissions. To restrict access to a
980  * function call, use {hasRole}:
981  *
982  * ```
983  * function foo() public {
984  *     require(hasRole(MY_ROLE, msg.sender));
985  *     ...
986  * }
987  * ```
988  *
989  * Roles can be granted and revoked dynamically via the {grantRole} and
990  * {revokeRole} functions. Each role has an associated admin role, and only
991  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
992  *
993  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
994  * that only accounts with this role will be able to grant or revoke other
995  * roles. More complex role relationships can be created by using
996  * {_setRoleAdmin}.
997  *
998  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
999  * grant and revoke this role. Extra precautions should be taken to secure
1000  * accounts that have been granted it.
1001  */
1002 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1003     struct RoleData {
1004         mapping (address => bool) members;
1005         bytes32 adminRole;
1006     }
1007 
1008     mapping (bytes32 => RoleData) private _roles;
1009 
1010     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1011 
1012     /**
1013      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1014      *
1015      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1016      * {RoleAdminChanged} not being emitted signaling this.
1017      *
1018      * _Available since v3.1._
1019      */
1020     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1021 
1022     /**
1023      * @dev Emitted when `account` is granted `role`.
1024      *
1025      * `sender` is the account that originated the contract call, an admin role
1026      * bearer except when using {_setupRole}.
1027      */
1028     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1029 
1030     /**
1031      * @dev Emitted when `account` is revoked `role`.
1032      *
1033      * `sender` is the account that originated the contract call:
1034      *   - if using `revokeRole`, it is the admin role bearer
1035      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1036      */
1037     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1038 
1039     /**
1040      * @dev See {IERC165-supportsInterface}.
1041      */
1042     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1043         return interfaceId == type(IAccessControl).interfaceId
1044             || super.supportsInterface(interfaceId);
1045     }
1046 
1047     /**
1048      * @dev Returns `true` if `account` has been granted `role`.
1049      */
1050     function hasRole(bytes32 role, address account) public view override returns (bool) {
1051         return _roles[role].members[account];
1052     }
1053 
1054     /**
1055      * @dev Returns the admin role that controls `role`. See {grantRole} and
1056      * {revokeRole}.
1057      *
1058      * To change a role's admin, use {_setRoleAdmin}.
1059      */
1060     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1061         return _roles[role].adminRole;
1062     }
1063 
1064     /**
1065      * @dev Grants `role` to `account`.
1066      *
1067      * If `account` had not been already granted `role`, emits a {RoleGranted}
1068      * event.
1069      *
1070      * Requirements:
1071      *
1072      * - the caller must have ``role``'s admin role.
1073      */
1074     function grantRole(bytes32 role, address account) public virtual override {
1075         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
1076 
1077         _grantRole(role, account);
1078     }
1079 
1080     /**
1081      * @dev Revokes `role` from `account`.
1082      *
1083      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1084      *
1085      * Requirements:
1086      *
1087      * - the caller must have ``role``'s admin role.
1088      */
1089     function revokeRole(bytes32 role, address account) public virtual override {
1090         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
1091 
1092         _revokeRole(role, account);
1093     }
1094 
1095     /**
1096      * @dev Revokes `role` from the calling account.
1097      *
1098      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1099      * purpose is to provide a mechanism for accounts to lose their privileges
1100      * if they are compromised (such as when a trusted device is misplaced).
1101      *
1102      * If the calling account had been granted `role`, emits a {RoleRevoked}
1103      * event.
1104      *
1105      * Requirements:
1106      *
1107      * - the caller must be `account`.
1108      */
1109     function renounceRole(bytes32 role, address account) public virtual override {
1110         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1111 
1112         _revokeRole(role, account);
1113     }
1114 
1115     /**
1116      * @dev Grants `role` to `account`.
1117      *
1118      * If `account` had not been already granted `role`, emits a {RoleGranted}
1119      * event. Note that unlike {grantRole}, this function doesn't perform any
1120      * checks on the calling account.
1121      *
1122      * [WARNING]
1123      * ====
1124      * This function should only be called from the constructor when setting
1125      * up the initial roles for the system.
1126      *
1127      * Using this function in any other way is effectively circumventing the admin
1128      * system imposed by {AccessControl}.
1129      * ====
1130      */
1131     function _setupRole(bytes32 role, address account) internal virtual {
1132         _grantRole(role, account);
1133     }
1134 
1135     /**
1136      * @dev Sets `adminRole` as ``role``'s admin role.
1137      *
1138      * Emits a {RoleAdminChanged} event.
1139      */
1140     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1141         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1142         _roles[role].adminRole = adminRole;
1143     }
1144 
1145     function _grantRole(bytes32 role, address account) private {
1146         if (!hasRole(role, account)) {
1147             _roles[role].members[account] = true;
1148             emit RoleGranted(role, account, _msgSender());
1149         }
1150     }
1151 
1152     function _revokeRole(bytes32 role, address account) private {
1153         if (hasRole(role, account)) {
1154             _roles[role].members[account] = false;
1155             emit RoleRevoked(role, account, _msgSender());
1156         }
1157     }
1158 }
1159 
1160 
1161 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.0.0
1162 
1163 
1164 
1165 pragma solidity ^0.8.0;
1166 
1167 /**
1168  * @dev Library for managing
1169  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1170  * types.
1171  *
1172  * Sets have the following properties:
1173  *
1174  * - Elements are added, removed, and checked for existence in constant time
1175  * (O(1)).
1176  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1177  *
1178  * ```
1179  * contract Example {
1180  *     // Add the library methods
1181  *     using EnumerableSet for EnumerableSet.AddressSet;
1182  *
1183  *     // Declare a set state variable
1184  *     EnumerableSet.AddressSet private mySet;
1185  * }
1186  * ```
1187  *
1188  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1189  * and `uint256` (`UintSet`) are supported.
1190  */
1191 library EnumerableSet {
1192     // To implement this library for multiple types with as little code
1193     // repetition as possible, we write it in terms of a generic Set type with
1194     // bytes32 values.
1195     // The Set implementation uses private functions, and user-facing
1196     // implementations (such as AddressSet) are just wrappers around the
1197     // underlying Set.
1198     // This means that we can only create new EnumerableSets for types that fit
1199     // in bytes32.
1200 
1201     struct Set {
1202         // Storage of set values
1203         bytes32[] _values;
1204 
1205         // Position of the value in the `values` array, plus 1 because index 0
1206         // means a value is not in the set.
1207         mapping (bytes32 => uint256) _indexes;
1208     }
1209 
1210     /**
1211      * @dev Add a value to a set. O(1).
1212      *
1213      * Returns true if the value was added to the set, that is if it was not
1214      * already present.
1215      */
1216     function _add(Set storage set, bytes32 value) private returns (bool) {
1217         if (!_contains(set, value)) {
1218             set._values.push(value);
1219             // The value is stored at length-1, but we add 1 to all indexes
1220             // and use 0 as a sentinel value
1221             set._indexes[value] = set._values.length;
1222             return true;
1223         } else {
1224             return false;
1225         }
1226     }
1227 
1228     /**
1229      * @dev Removes a value from a set. O(1).
1230      *
1231      * Returns true if the value was removed from the set, that is if it was
1232      * present.
1233      */
1234     function _remove(Set storage set, bytes32 value) private returns (bool) {
1235         // We read and store the value's index to prevent multiple reads from the same storage slot
1236         uint256 valueIndex = set._indexes[value];
1237 
1238         if (valueIndex != 0) { // Equivalent to contains(set, value)
1239             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1240             // the array, and then remove the last element (sometimes called as 'swap and pop').
1241             // This modifies the order of the array, as noted in {at}.
1242 
1243             uint256 toDeleteIndex = valueIndex - 1;
1244             uint256 lastIndex = set._values.length - 1;
1245 
1246             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1247             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1248 
1249             bytes32 lastvalue = set._values[lastIndex];
1250 
1251             // Move the last value to the index where the value to delete is
1252             set._values[toDeleteIndex] = lastvalue;
1253             // Update the index for the moved value
1254             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1255 
1256             // Delete the slot where the moved value was stored
1257             set._values.pop();
1258 
1259             // Delete the index for the deleted slot
1260             delete set._indexes[value];
1261 
1262             return true;
1263         } else {
1264             return false;
1265         }
1266     }
1267 
1268     /**
1269      * @dev Returns true if the value is in the set. O(1).
1270      */
1271     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1272         return set._indexes[value] != 0;
1273     }
1274 
1275     /**
1276      * @dev Returns the number of values on the set. O(1).
1277      */
1278     function _length(Set storage set) private view returns (uint256) {
1279         return set._values.length;
1280     }
1281 
1282    /**
1283     * @dev Returns the value stored at position `index` in the set. O(1).
1284     *
1285     * Note that there are no guarantees on the ordering of values inside the
1286     * array, and it may change when more values are added or removed.
1287     *
1288     * Requirements:
1289     *
1290     * - `index` must be strictly less than {length}.
1291     */
1292     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1293         require(set._values.length > index, "EnumerableSet: index out of bounds");
1294         return set._values[index];
1295     }
1296 
1297     // Bytes32Set
1298 
1299     struct Bytes32Set {
1300         Set _inner;
1301     }
1302 
1303     /**
1304      * @dev Add a value to a set. O(1).
1305      *
1306      * Returns true if the value was added to the set, that is if it was not
1307      * already present.
1308      */
1309     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1310         return _add(set._inner, value);
1311     }
1312 
1313     /**
1314      * @dev Removes a value from a set. O(1).
1315      *
1316      * Returns true if the value was removed from the set, that is if it was
1317      * present.
1318      */
1319     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1320         return _remove(set._inner, value);
1321     }
1322 
1323     /**
1324      * @dev Returns true if the value is in the set. O(1).
1325      */
1326     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1327         return _contains(set._inner, value);
1328     }
1329 
1330     /**
1331      * @dev Returns the number of values in the set. O(1).
1332      */
1333     function length(Bytes32Set storage set) internal view returns (uint256) {
1334         return _length(set._inner);
1335     }
1336 
1337    /**
1338     * @dev Returns the value stored at position `index` in the set. O(1).
1339     *
1340     * Note that there are no guarantees on the ordering of values inside the
1341     * array, and it may change when more values are added or removed.
1342     *
1343     * Requirements:
1344     *
1345     * - `index` must be strictly less than {length}.
1346     */
1347     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1348         return _at(set._inner, index);
1349     }
1350 
1351     // AddressSet
1352 
1353     struct AddressSet {
1354         Set _inner;
1355     }
1356 
1357     /**
1358      * @dev Add a value to a set. O(1).
1359      *
1360      * Returns true if the value was added to the set, that is if it was not
1361      * already present.
1362      */
1363     function add(AddressSet storage set, address value) internal returns (bool) {
1364         return _add(set._inner, bytes32(uint256(uint160(value))));
1365     }
1366 
1367     /**
1368      * @dev Removes a value from a set. O(1).
1369      *
1370      * Returns true if the value was removed from the set, that is if it was
1371      * present.
1372      */
1373     function remove(AddressSet storage set, address value) internal returns (bool) {
1374         return _remove(set._inner, bytes32(uint256(uint160(value))));
1375     }
1376 
1377     /**
1378      * @dev Returns true if the value is in the set. O(1).
1379      */
1380     function contains(AddressSet storage set, address value) internal view returns (bool) {
1381         return _contains(set._inner, bytes32(uint256(uint160(value))));
1382     }
1383 
1384     /**
1385      * @dev Returns the number of values in the set. O(1).
1386      */
1387     function length(AddressSet storage set) internal view returns (uint256) {
1388         return _length(set._inner);
1389     }
1390 
1391    /**
1392     * @dev Returns the value stored at position `index` in the set. O(1).
1393     *
1394     * Note that there are no guarantees on the ordering of values inside the
1395     * array, and it may change when more values are added or removed.
1396     *
1397     * Requirements:
1398     *
1399     * - `index` must be strictly less than {length}.
1400     */
1401     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1402         return address(uint160(uint256(_at(set._inner, index))));
1403     }
1404 
1405 
1406     // UintSet
1407 
1408     struct UintSet {
1409         Set _inner;
1410     }
1411 
1412     /**
1413      * @dev Add a value to a set. O(1).
1414      *
1415      * Returns true if the value was added to the set, that is if it was not
1416      * already present.
1417      */
1418     function add(UintSet storage set, uint256 value) internal returns (bool) {
1419         return _add(set._inner, bytes32(value));
1420     }
1421 
1422     /**
1423      * @dev Removes a value from a set. O(1).
1424      *
1425      * Returns true if the value was removed from the set, that is if it was
1426      * present.
1427      */
1428     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1429         return _remove(set._inner, bytes32(value));
1430     }
1431 
1432     /**
1433      * @dev Returns true if the value is in the set. O(1).
1434      */
1435     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1436         return _contains(set._inner, bytes32(value));
1437     }
1438 
1439     /**
1440      * @dev Returns the number of values on the set. O(1).
1441      */
1442     function length(UintSet storage set) internal view returns (uint256) {
1443         return _length(set._inner);
1444     }
1445 
1446    /**
1447     * @dev Returns the value stored at position `index` in the set. O(1).
1448     *
1449     * Note that there are no guarantees on the ordering of values inside the
1450     * array, and it may change when more values are added or removed.
1451     *
1452     * Requirements:
1453     *
1454     * - `index` must be strictly less than {length}.
1455     */
1456     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1457         return uint256(_at(set._inner, index));
1458     }
1459 }
1460 
1461 
1462 // File @openzeppelin/contracts/access/AccessControlEnumerable.sol@v4.0.0
1463 
1464 
1465 
1466 pragma solidity ^0.8.0;
1467 
1468 
1469 /**
1470  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1471  */
1472 interface IAccessControlEnumerable {
1473     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1474     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1475 }
1476 
1477 /**
1478  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1479  */
1480 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1481     using EnumerableSet for EnumerableSet.AddressSet;
1482 
1483     mapping (bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1484 
1485     /**
1486      * @dev See {IERC165-supportsInterface}.
1487      */
1488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1489         return interfaceId == type(IAccessControlEnumerable).interfaceId
1490             || super.supportsInterface(interfaceId);
1491     }
1492 
1493     /**
1494      * @dev Returns one of the accounts that have `role`. `index` must be a
1495      * value between 0 and {getRoleMemberCount}, non-inclusive.
1496      *
1497      * Role bearers are not sorted in any particular way, and their ordering may
1498      * change at any point.
1499      *
1500      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1501      * you perform all queries on the same block. See the following
1502      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1503      * for more information.
1504      */
1505     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1506         return _roleMembers[role].at(index);
1507     }
1508 
1509     /**
1510      * @dev Returns the number of accounts that have `role`. Can be used
1511      * together with {getRoleMember} to enumerate all bearers of a role.
1512      */
1513     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1514         return _roleMembers[role].length();
1515     }
1516 
1517     /**
1518      * @dev Overload {grantRole} to track enumerable memberships
1519      */
1520     function grantRole(bytes32 role, address account) public virtual override {
1521         super.grantRole(role, account);
1522         _roleMembers[role].add(account);
1523     }
1524 
1525     /**
1526      * @dev Overload {revokeRole} to track enumerable memberships
1527      */
1528     function revokeRole(bytes32 role, address account) public virtual override {
1529         super.revokeRole(role, account);
1530         _roleMembers[role].remove(account);
1531     }
1532 
1533     /**
1534      * @dev Overload {renounceRole} to track enumerable memberships
1535      */
1536     function renounceRole(bytes32 role, address account) public virtual override {
1537         super.renounceRole(role, account);
1538         _roleMembers[role].remove(account);
1539     }
1540 
1541     /**
1542      * @dev Overload {_setupRole} to track enumerable memberships
1543      */
1544     function _setupRole(bytes32 role, address account) internal virtual override {
1545         super._setupRole(role, account);
1546         _roleMembers[role].add(account);
1547     }
1548 }
1549 
1550 
1551 // File contracts/tsx/TSX.sol
1552 
1553 
1554 
1555 pragma solidity ^0.8.0;
1556 
1557 
1558 
1559 
1560 
1561 /**
1562  * @dev {TSX}:
1563  *  - mint/burn/pause capabilities
1564  *  - a minter role that allows for token minting (creation)
1565  *  - a pauser role that allows to stop all token transfers
1566  *
1567  * The account that deploys the contract will be granted the minter and pauser
1568  * roles, as well as the default admin role, which will let it grant both minter
1569  * and pauser roles to other accounts.
1570  */
1571 
1572 contract TSX is Context, AccessControlEnumerable, ERC20Snapshot, ERC20Burnable, ERC20Pausable {
1573     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1574     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1575     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1576 
1577     // Token details
1578     string public constant NAME = "TradeStars TSX";
1579     string public constant SYMBOL = "TSX";
1580 
1581     constructor() ERC20(NAME, SYMBOL) {
1582         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1583 
1584         _setupRole(MINTER_ROLE, _msgSender());
1585         _setupRole(PAUSER_ROLE, _msgSender());
1586         _setupRole(SNAPSHOT_ROLE, _msgSender());
1587     }
1588     
1589     /**
1590      * @dev Takes a snapshop of the token at the current block. The caller must have the `SNAPSHOT_ROLE`.
1591      */
1592     function snapshot() public virtual {
1593         require(hasRole(SNAPSHOT_ROLE, _msgSender()), "TSX: must have snapshot role");
1594         _snapshot();
1595     }
1596 
1597     /**
1598      * @dev Mints a specific amount of tokens. The caller must have the `MINTER_ROLE`.
1599      * @param _to The amount of token to be minted.
1600      * @param _value The amount of token to be minted.
1601      */
1602     function mint(address _to, uint256 _value) public virtual {
1603         require(hasRole(MINTER_ROLE, _msgSender()), "TSX: must have minter role");
1604         _mint(_to, _value);
1605     }
1606 
1607     /**
1608      * @dev Pauses all token transfers. The caller must have the `PAUSER_ROLE`.
1609      */
1610     function pause() public virtual {
1611         require(hasRole(PAUSER_ROLE, _msgSender()), "TSX: must have pauser role");
1612         _pause();
1613     }
1614 
1615     /**
1616      * @dev Unpauses all token transfers. the caller must have the `PAUSER_ROLE`.
1617      */
1618     function unpause() public virtual {
1619         require(hasRole(PAUSER_ROLE, _msgSender()), "TSX: must have pauser role");
1620         _unpause();
1621     }
1622 
1623     function _beforeTokenTransfer(
1624         address from, 
1625         address to, 
1626         uint256 amount
1627     ) 
1628         internal virtual override(ERC20, ERC20Snapshot, ERC20Pausable) 
1629     {
1630         super._beforeTokenTransfer(from, to, amount);
1631     }
1632 }