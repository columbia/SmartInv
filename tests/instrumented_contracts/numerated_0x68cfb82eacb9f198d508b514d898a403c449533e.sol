1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 
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
103 
104 
105 
106 /**
107  * @title Counters
108  * @author Matt Condon (@shrugs)
109  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
110  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
111  *
112  * Include with `using Counters for Counters.Counter;`
113  */
114 library Counters {
115     struct Counter {
116         // This variable should never be directly accessed by users of the library: interactions must be restricted to
117         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
118         // this feature: see https://github.com/ethereum/solidity/issues/4637
119         uint256 _value; // default: 0
120     }
121 
122     function current(Counter storage counter) internal view returns (uint256) {
123         return counter._value;
124     }
125 
126     function increment(Counter storage counter) internal {
127         unchecked {
128             counter._value += 1;
129         }
130     }
131 
132     function decrement(Counter storage counter) internal {
133         uint256 value = counter._value;
134         require(value > 0, "Counter: decrement overflow");
135         unchecked {
136             counter._value = value - 1;
137         }
138     }
139 }
140 
141 
142 
143 
144 /*
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
161         return msg.data;
162     }
163 }
164 
165 
166 
167 
168 /**
169  * @dev String operations.
170  */
171 library Strings {
172     bytes16 private constant alphabet = "0123456789abcdef";
173 
174     /**
175      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
176      */
177     function toString(uint256 value) internal pure returns (string memory) {
178         // Inspired by OraclizeAPI's implementation - MIT licence
179         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
180 
181         if (value == 0) {
182             return "0";
183         }
184         uint256 temp = value;
185         uint256 digits;
186         while (temp != 0) {
187             digits++;
188             temp /= 10;
189         }
190         bytes memory buffer = new bytes(digits);
191         while (value != 0) {
192             digits -= 1;
193             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
194             value /= 10;
195         }
196         return string(buffer);
197     }
198 
199     /**
200      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
201      */
202     function toHexString(uint256 value) internal pure returns (string memory) {
203         if (value == 0) {
204             return "0x00";
205         }
206         uint256 temp = value;
207         uint256 length = 0;
208         while (temp != 0) {
209             length++;
210             temp >>= 8;
211         }
212         return toHexString(value, length);
213     }
214 
215     /**
216      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
217      */
218     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
219         bytes memory buffer = new bytes(2 * length + 2);
220         buffer[0] = "0";
221         buffer[1] = "x";
222         for (uint256 i = 2 * length + 1; i > 1; --i) {
223             buffer[i] = alphabet[value & 0xf];
224             value >>= 4;
225         }
226         require(value == 0, "Strings: hex length insufficient");
227         return string(buffer);
228     }
229 
230 }
231 
232 
233 
234 
235 
236 
237 
238 
239 
240 
241 
242 
243 
244 
245 /**
246  * @dev Interface for the optional metadata functions from the ERC20 standard.
247  *
248  * _Available since v4.1._
249  */
250 interface IERC20Metadata is IERC20 {
251     /**
252      * @dev Returns the name of the token.
253      */
254     function name() external view returns (string memory);
255 
256     /**
257      * @dev Returns the symbol of the token.
258      */
259     function symbol() external view returns (string memory);
260 
261     /**
262      * @dev Returns the decimals places of the token.
263      */
264     function decimals() external view returns (uint8);
265 }
266 
267 
268 
269 /**
270  * @dev Implementation of the {IERC20} interface.
271  *
272  * This implementation is agnostic to the way tokens are created. This means
273  * that a supply mechanism has to be added in a derived contract using {_mint}.
274  * For a generic mechanism see {ERC20PresetMinterPauser}.
275  *
276  * TIP: For a detailed writeup see our guide
277  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
278  * to implement supply mechanisms].
279  *
280  * We have followed general OpenZeppelin guidelines: functions revert instead
281  * of returning `false` on failure. This behavior is nonetheless conventional
282  * and does not conflict with the expectations of ERC20 applications.
283  *
284  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
285  * This allows applications to reconstruct the allowance for all accounts just
286  * by listening to said events. Other implementations of the EIP may not emit
287  * these events, as it isn't required by the specification.
288  *
289  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
290  * functions have been added to mitigate the well-known issues around setting
291  * allowances. See {IERC20-approve}.
292  */
293 contract ERC20 is Context, IERC20, IERC20Metadata {
294     mapping (address => uint256) private _balances;
295 
296     mapping (address => mapping (address => uint256)) private _allowances;
297 
298     uint256 private _totalSupply;
299 
300     string private _name;
301     string private _symbol;
302 
303     /**
304      * @dev Sets the values for {name} and {symbol}.
305      *
306      * The defaut value of {decimals} is 18. To select a different value for
307      * {decimals} you should overload it.
308      *
309      * All two of these values are immutable: they can only be set once during
310      * construction.
311      */
312     constructor (string memory name_, string memory symbol_) {
313         _name = name_;
314         _symbol = symbol_;
315     }
316 
317     /**
318      * @dev Returns the name of the token.
319      */
320     function name() public view virtual override returns (string memory) {
321         return _name;
322     }
323 
324     /**
325      * @dev Returns the symbol of the token, usually a shorter version of the
326      * name.
327      */
328     function symbol() public view virtual override returns (string memory) {
329         return _symbol;
330     }
331 
332     /**
333      * @dev Returns the number of decimals used to get its user representation.
334      * For example, if `decimals` equals `2`, a balance of `505` tokens should
335      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
336      *
337      * Tokens usually opt for a value of 18, imitating the relationship between
338      * Ether and Wei. This is the value {ERC20} uses, unless this function is
339      * overridden;
340      *
341      * NOTE: This information is only used for _display_ purposes: it in
342      * no way affects any of the arithmetic of the contract, including
343      * {IERC20-balanceOf} and {IERC20-transfer}.
344      */
345     function decimals() public view virtual override returns (uint8) {
346         return 18;
347     }
348 
349     /**
350      * @dev See {IERC20-totalSupply}.
351      */
352     function totalSupply() public view virtual override returns (uint256) {
353         return _totalSupply;
354     }
355 
356     /**
357      * @dev See {IERC20-balanceOf}.
358      */
359     function balanceOf(address account) public view virtual override returns (uint256) {
360         return _balances[account];
361     }
362 
363     /**
364      * @dev See {IERC20-transfer}.
365      *
366      * Requirements:
367      *
368      * - `recipient` cannot be the zero address.
369      * - the caller must have a balance of at least `amount`.
370      */
371     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
372         _transfer(_msgSender(), recipient, amount);
373         return true;
374     }
375 
376     /**
377      * @dev See {IERC20-allowance}.
378      */
379     function allowance(address owner, address spender) public view virtual override returns (uint256) {
380         return _allowances[owner][spender];
381     }
382 
383     /**
384      * @dev See {IERC20-approve}.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      */
390     function approve(address spender, uint256 amount) public virtual override returns (bool) {
391         _approve(_msgSender(), spender, amount);
392         return true;
393     }
394 
395     /**
396      * @dev See {IERC20-transferFrom}.
397      *
398      * Emits an {Approval} event indicating the updated allowance. This is not
399      * required by the EIP. See the note at the beginning of {ERC20}.
400      *
401      * Requirements:
402      *
403      * - `sender` and `recipient` cannot be the zero address.
404      * - `sender` must have a balance of at least `amount`.
405      * - the caller must have allowance for ``sender``'s tokens of at least
406      * `amount`.
407      */
408     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
409         _transfer(sender, recipient, amount);
410 
411         uint256 currentAllowance = _allowances[sender][_msgSender()];
412         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
413         _approve(sender, _msgSender(), currentAllowance - amount);
414 
415         return true;
416     }
417 
418     /**
419      * @dev Atomically increases the allowance granted to `spender` by the caller.
420      *
421      * This is an alternative to {approve} that can be used as a mitigation for
422      * problems described in {IERC20-approve}.
423      *
424      * Emits an {Approval} event indicating the updated allowance.
425      *
426      * Requirements:
427      *
428      * - `spender` cannot be the zero address.
429      */
430     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
431         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
432         return true;
433     }
434 
435     /**
436      * @dev Atomically decreases the allowance granted to `spender` by the caller.
437      *
438      * This is an alternative to {approve} that can be used as a mitigation for
439      * problems described in {IERC20-approve}.
440      *
441      * Emits an {Approval} event indicating the updated allowance.
442      *
443      * Requirements:
444      *
445      * - `spender` cannot be the zero address.
446      * - `spender` must have allowance for the caller of at least
447      * `subtractedValue`.
448      */
449     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
450         uint256 currentAllowance = _allowances[_msgSender()][spender];
451         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
452         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
453 
454         return true;
455     }
456 
457     /**
458      * @dev Moves tokens `amount` from `sender` to `recipient`.
459      *
460      * This is internal function is equivalent to {transfer}, and can be used to
461      * e.g. implement automatic token fees, slashing mechanisms, etc.
462      *
463      * Emits a {Transfer} event.
464      *
465      * Requirements:
466      *
467      * - `sender` cannot be the zero address.
468      * - `recipient` cannot be the zero address.
469      * - `sender` must have a balance of at least `amount`.
470      */
471     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
472         require(sender != address(0), "ERC20: transfer from the zero address");
473         require(recipient != address(0), "ERC20: transfer to the zero address");
474 
475         _beforeTokenTransfer(sender, recipient, amount);
476 
477         uint256 senderBalance = _balances[sender];
478         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
479         _balances[sender] = senderBalance - amount;
480         _balances[recipient] += amount;
481 
482         emit Transfer(sender, recipient, amount);
483     }
484 
485     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
486      * the total supply.
487      *
488      * Emits a {Transfer} event with `from` set to the zero address.
489      *
490      * Requirements:
491      *
492      * - `to` cannot be the zero address.
493      */
494     function _mint(address account, uint256 amount) internal virtual {
495         require(account != address(0), "ERC20: mint to the zero address");
496 
497         _beforeTokenTransfer(address(0), account, amount);
498 
499         _totalSupply += amount;
500         _balances[account] += amount;
501         emit Transfer(address(0), account, amount);
502     }
503 
504     /**
505      * @dev Destroys `amount` tokens from `account`, reducing the
506      * total supply.
507      *
508      * Emits a {Transfer} event with `to` set to the zero address.
509      *
510      * Requirements:
511      *
512      * - `account` cannot be the zero address.
513      * - `account` must have at least `amount` tokens.
514      */
515     function _burn(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: burn from the zero address");
517 
518         _beforeTokenTransfer(account, address(0), amount);
519 
520         uint256 accountBalance = _balances[account];
521         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
522         _balances[account] = accountBalance - amount;
523         _totalSupply -= amount;
524 
525         emit Transfer(account, address(0), amount);
526     }
527 
528     /**
529      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
530      *
531      * This internal function is equivalent to `approve`, and can be used to
532      * e.g. set automatic allowances for certain subsystems, etc.
533      *
534      * Emits an {Approval} event.
535      *
536      * Requirements:
537      *
538      * - `owner` cannot be the zero address.
539      * - `spender` cannot be the zero address.
540      */
541     function _approve(address owner, address spender, uint256 amount) internal virtual {
542         require(owner != address(0), "ERC20: approve from the zero address");
543         require(spender != address(0), "ERC20: approve to the zero address");
544 
545         _allowances[owner][spender] = amount;
546         emit Approval(owner, spender, amount);
547     }
548 
549     /**
550      * @dev Hook that is called before any transfer of tokens. This includes
551      * minting and burning.
552      *
553      * Calling conditions:
554      *
555      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
556      * will be to transferred to `to`.
557      * - when `from` is zero, `amount` tokens will be minted for `to`.
558      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
559      * - `from` and `to` are never both zero.
560      *
561      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
562      */
563     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
564 }
565 
566 
567 
568 
569 
570 
571 
572 
573 /**
574  * @dev Extension of {ERC20} that allows token holders to destroy both their own
575  * tokens and those that they have an allowance for, in a way that can be
576  * recognized off-chain (via event analysis).
577  */
578 abstract contract ERC20Burnable is Context, ERC20 {
579     /**
580      * @dev Destroys `amount` tokens from the caller.
581      *
582      * See {ERC20-_burn}.
583      */
584     function burn(uint256 amount) public virtual {
585         _burn(_msgSender(), amount);
586     }
587 
588     /**
589      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
590      * allowance.
591      *
592      * See {ERC20-_burn} and {ERC20-allowance}.
593      *
594      * Requirements:
595      *
596      * - the caller must have allowance for ``accounts``'s tokens of at least
597      * `amount`.
598      */
599     function burnFrom(address account, uint256 amount) public virtual {
600         uint256 currentAllowance = allowance(account, _msgSender());
601         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
602         _approve(account, _msgSender(), currentAllowance - amount);
603         _burn(account, amount);
604     }
605 }
606 
607 
608 
609 
610 
611 
612 
613 
614 
615 
616 
617 
618 
619 
620 /**
621  * @dev Standard math utilities missing in the Solidity language.
622  */
623 library Math {
624     /**
625      * @dev Returns the largest of two numbers.
626      */
627     function max(uint256 a, uint256 b) internal pure returns (uint256) {
628         return a >= b ? a : b;
629     }
630 
631     /**
632      * @dev Returns the smallest of two numbers.
633      */
634     function min(uint256 a, uint256 b) internal pure returns (uint256) {
635         return a < b ? a : b;
636     }
637 
638     /**
639      * @dev Returns the average of two numbers. The result is rounded towards
640      * zero.
641      */
642     function average(uint256 a, uint256 b) internal pure returns (uint256) {
643         // (a + b) / 2 can overflow, so we distribute
644         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
645     }
646 }
647 
648 
649 /**
650  * @dev Collection of functions related to array types.
651  */
652 library Arrays {
653    /**
654      * @dev Searches a sorted `array` and returns the first index that contains
655      * a value greater or equal to `element`. If no such index exists (i.e. all
656      * values in the array are strictly less than `element`), the array length is
657      * returned. Time complexity O(log n).
658      *
659      * `array` is expected to be sorted in ascending order, and to contain no
660      * repeated elements.
661      */
662     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
663         if (array.length == 0) {
664             return 0;
665         }
666 
667         uint256 low = 0;
668         uint256 high = array.length;
669 
670         while (low < high) {
671             uint256 mid = Math.average(low, high);
672 
673             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
674             // because Math.average rounds down (it does integer division with truncation).
675             if (array[mid] > element) {
676                 high = mid;
677             } else {
678                 low = mid + 1;
679             }
680         }
681 
682         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
683         if (low > 0 && array[low - 1] == element) {
684             return low - 1;
685         } else {
686             return low;
687         }
688     }
689 }
690 
691 
692 
693 /**
694  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
695  * total supply at the time are recorded for later access.
696  *
697  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
698  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
699  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
700  * used to create an efficient ERC20 forking mechanism.
701  *
702  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
703  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
704  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
705  * and the account address.
706  *
707  * ==== Gas Costs
708  *
709  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
710  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
711  * smaller since identical balances in subsequent snapshots are stored as a single entry.
712  *
713  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
714  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
715  * transfers will have normal cost until the next snapshot, and so on.
716  */
717 abstract contract ERC20Snapshot is ERC20 {
718     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
719     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
720 
721     using Arrays for uint256[];
722     using Counters for Counters.Counter;
723 
724     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
725     // Snapshot struct, but that would impede usage of functions that work on an array.
726     struct Snapshots {
727         uint256[] ids;
728         uint256[] values;
729     }
730 
731     mapping (address => Snapshots) private _accountBalanceSnapshots;
732     Snapshots private _totalSupplySnapshots;
733 
734     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
735     Counters.Counter private _currentSnapshotId;
736 
737     /**
738      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
739      */
740     event Snapshot(uint256 id);
741 
742     /**
743      * @dev Creates a new snapshot and returns its snapshot id.
744      *
745      * Emits a {Snapshot} event that contains the same id.
746      *
747      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
748      * set of accounts, for example using {AccessControl}, or it may be open to the public.
749      *
750      * [WARNING]
751      * ====
752      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
753      * you must consider that it can potentially be used by attackers in two ways.
754      *
755      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
756      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
757      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
758      * section above.
759      *
760      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
761      * ====
762      */
763     function _snapshot() internal virtual returns (uint256) {
764         _currentSnapshotId.increment();
765 
766         uint256 currentId = _currentSnapshotId.current();
767         emit Snapshot(currentId);
768         return currentId;
769     }
770 
771     /**
772      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
773      */
774     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
775         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
776 
777         return snapshotted ? value : balanceOf(account);
778     }
779 
780     /**
781      * @dev Retrieves the total supply at the time `snapshotId` was created.
782      */
783     function totalSupplyAt(uint256 snapshotId) public view virtual returns(uint256) {
784         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
785 
786         return snapshotted ? value : totalSupply();
787     }
788 
789 
790     // Update balance and/or total supply snapshots before the values are modified. This is implemented
791     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
792     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
793       super._beforeTokenTransfer(from, to, amount);
794 
795       if (from == address(0)) {
796         // mint
797         _updateAccountSnapshot(to);
798         _updateTotalSupplySnapshot();
799       } else if (to == address(0)) {
800         // burn
801         _updateAccountSnapshot(from);
802         _updateTotalSupplySnapshot();
803       } else {
804         // transfer
805         _updateAccountSnapshot(from);
806         _updateAccountSnapshot(to);
807       }
808     }
809 
810     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
811         private view returns (bool, uint256)
812     {
813         require(snapshotId > 0, "ERC20Snapshot: id is 0");
814         // solhint-disable-next-line max-line-length
815         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
816 
817         // When a valid snapshot is queried, there are three possibilities:
818         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
819         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
820         //  to this id is the current one.
821         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
822         //  requested id, and its value is the one to return.
823         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
824         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
825         //  larger than the requested one.
826         //
827         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
828         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
829         // exactly this.
830 
831         uint256 index = snapshots.ids.findUpperBound(snapshotId);
832 
833         if (index == snapshots.ids.length) {
834             return (false, 0);
835         } else {
836             return (true, snapshots.values[index]);
837         }
838     }
839 
840     function _updateAccountSnapshot(address account) private {
841         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
842     }
843 
844     function _updateTotalSupplySnapshot() private {
845         _updateSnapshot(_totalSupplySnapshots, totalSupply());
846     }
847 
848     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
849         uint256 currentId = _currentSnapshotId.current();
850         if (_lastSnapshotId(snapshots.ids) < currentId) {
851             snapshots.ids.push(currentId);
852             snapshots.values.push(currentValue);
853         }
854     }
855 
856     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
857         if (ids.length == 0) {
858             return 0;
859         } else {
860             return ids[ids.length - 1];
861         }
862     }
863 }
864 
865 
866 
867 
868 
869 
870 
871 
872 
873 
874 
875 
876 
877 /**
878  * @dev Implementation of the {IERC165} interface.
879  *
880  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
881  * for the additional interface id that will be supported. For example:
882  *
883  * ```solidity
884  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
885  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
886  * }
887  * ```
888  *
889  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
890  */
891 abstract contract ERC165 is IERC165 {
892     /**
893      * @dev See {IERC165-supportsInterface}.
894      */
895     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
896         return interfaceId == type(IERC165).interfaceId;
897     }
898 }
899 
900 
901 /**
902  * @dev External interface of AccessControl declared to support ERC165 detection.
903  */
904 interface IAccessControl {
905     function hasRole(bytes32 role, address account) external view returns (bool);
906     function getRoleAdmin(bytes32 role) external view returns (bytes32);
907     function grantRole(bytes32 role, address account) external;
908     function revokeRole(bytes32 role, address account) external;
909     function renounceRole(bytes32 role, address account) external;
910 }
911 
912 /**
913  * @dev Contract module that allows children to implement role-based access
914  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
915  * members except through off-chain means by accessing the contract event logs. Some
916  * applications may benefit from on-chain enumerability, for those cases see
917  * {AccessControlEnumerable}.
918  *
919  * Roles are referred to by their `bytes32` identifier. These should be exposed
920  * in the external API and be unique. The best way to achieve this is by
921  * using `public constant` hash digests:
922  *
923  * ```
924  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
925  * ```
926  *
927  * Roles can be used to represent a set of permissions. To restrict access to a
928  * function call, use {hasRole}:
929  *
930  * ```
931  * function foo() public {
932  *     require(hasRole(MY_ROLE, msg.sender));
933  *     ...
934  * }
935  * ```
936  *
937  * Roles can be granted and revoked dynamically via the {grantRole} and
938  * {revokeRole} functions. Each role has an associated admin role, and only
939  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
940  *
941  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
942  * that only accounts with this role will be able to grant or revoke other
943  * roles. More complex role relationships can be created by using
944  * {_setRoleAdmin}.
945  *
946  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
947  * grant and revoke this role. Extra precautions should be taken to secure
948  * accounts that have been granted it.
949  */
950 abstract contract AccessControl is Context, IAccessControl, ERC165 {
951     struct RoleData {
952         mapping (address => bool) members;
953         bytes32 adminRole;
954     }
955 
956     mapping (bytes32 => RoleData) private _roles;
957 
958     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
959 
960     /**
961      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
962      *
963      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
964      * {RoleAdminChanged} not being emitted signaling this.
965      *
966      * _Available since v3.1._
967      */
968     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
969 
970     /**
971      * @dev Emitted when `account` is granted `role`.
972      *
973      * `sender` is the account that originated the contract call, an admin role
974      * bearer except when using {_setupRole}.
975      */
976     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
977 
978     /**
979      * @dev Emitted when `account` is revoked `role`.
980      *
981      * `sender` is the account that originated the contract call:
982      *   - if using `revokeRole`, it is the admin role bearer
983      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
984      */
985     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
986 
987     /**
988      * @dev Modifier that checks that an account has a specific role. Reverts
989      * with a standardized message including the required role.
990      *
991      * The format of the revert reason is given by the following regular expression:
992      *
993      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
994      *
995      * _Available since v4.1._
996      */
997     modifier onlyRole(bytes32 role) {
998         _checkRole(role, _msgSender());
999         _;
1000     }
1001 
1002     /**
1003      * @dev See {IERC165-supportsInterface}.
1004      */
1005     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1006         return interfaceId == type(IAccessControl).interfaceId
1007             || super.supportsInterface(interfaceId);
1008     }
1009 
1010     /**
1011      * @dev Returns `true` if `account` has been granted `role`.
1012      */
1013     function hasRole(bytes32 role, address account) public view override returns (bool) {
1014         return _roles[role].members[account];
1015     }
1016 
1017     /**
1018      * @dev Revert with a standard message if `account` is missing `role`.
1019      *
1020      * The format of the revert reason is given by the following regular expression:
1021      *
1022      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1023      */
1024     function _checkRole(bytes32 role, address account) internal view {
1025         if(!hasRole(role, account)) {
1026             revert(string(abi.encodePacked(
1027                 "AccessControl: account ",
1028                 Strings.toHexString(uint160(account), 20),
1029                 " is missing role ",
1030                 Strings.toHexString(uint256(role), 32)
1031             )));
1032         }
1033     }
1034 
1035     /**
1036      * @dev Returns the admin role that controls `role`. See {grantRole} and
1037      * {revokeRole}.
1038      *
1039      * To change a role's admin, use {_setRoleAdmin}.
1040      */
1041     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1042         return _roles[role].adminRole;
1043     }
1044 
1045     /**
1046      * @dev Grants `role` to `account`.
1047      *
1048      * If `account` had not been already granted `role`, emits a {RoleGranted}
1049      * event.
1050      *
1051      * Requirements:
1052      *
1053      * - the caller must have ``role``'s admin role.
1054      */
1055     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1056         _grantRole(role, account);
1057     }
1058 
1059     /**
1060      * @dev Revokes `role` from `account`.
1061      *
1062      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1063      *
1064      * Requirements:
1065      *
1066      * - the caller must have ``role``'s admin role.
1067      */
1068     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1069         _revokeRole(role, account);
1070     }
1071 
1072     /**
1073      * @dev Revokes `role` from the calling account.
1074      *
1075      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1076      * purpose is to provide a mechanism for accounts to lose their privileges
1077      * if they are compromised (such as when a trusted device is misplaced).
1078      *
1079      * If the calling account had been granted `role`, emits a {RoleRevoked}
1080      * event.
1081      *
1082      * Requirements:
1083      *
1084      * - the caller must be `account`.
1085      */
1086     function renounceRole(bytes32 role, address account) public virtual override {
1087         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1088 
1089         _revokeRole(role, account);
1090     }
1091 
1092     /**
1093      * @dev Grants `role` to `account`.
1094      *
1095      * If `account` had not been already granted `role`, emits a {RoleGranted}
1096      * event. Note that unlike {grantRole}, this function doesn't perform any
1097      * checks on the calling account.
1098      *
1099      * [WARNING]
1100      * ====
1101      * This function should only be called from the constructor when setting
1102      * up the initial roles for the system.
1103      *
1104      * Using this function in any other way is effectively circumventing the admin
1105      * system imposed by {AccessControl}.
1106      * ====
1107      */
1108     function _setupRole(bytes32 role, address account) internal virtual {
1109         _grantRole(role, account);
1110     }
1111 
1112     /**
1113      * @dev Sets `adminRole` as ``role``'s admin role.
1114      *
1115      * Emits a {RoleAdminChanged} event.
1116      */
1117     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1118         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1119         _roles[role].adminRole = adminRole;
1120     }
1121 
1122     function _grantRole(bytes32 role, address account) private {
1123         if (!hasRole(role, account)) {
1124             _roles[role].members[account] = true;
1125             emit RoleGranted(role, account, _msgSender());
1126         }
1127     }
1128 
1129     function _revokeRole(bytes32 role, address account) private {
1130         if (hasRole(role, account)) {
1131             _roles[role].members[account] = false;
1132             emit RoleRevoked(role, account, _msgSender());
1133         }
1134     }
1135 }
1136 
1137 
1138 
1139 
1140 
1141 
1142 
1143 /**
1144  * @dev Contract module which allows children to implement an emergency stop
1145  * mechanism that can be triggered by an authorized account.
1146  *
1147  * This module is used through inheritance. It will make available the
1148  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1149  * the functions of your contract. Note that they will not be pausable by
1150  * simply including this module, only once the modifiers are put in place.
1151  */
1152 abstract contract Pausable is Context {
1153     /**
1154      * @dev Emitted when the pause is triggered by `account`.
1155      */
1156     event Paused(address account);
1157 
1158     /**
1159      * @dev Emitted when the pause is lifted by `account`.
1160      */
1161     event Unpaused(address account);
1162 
1163     bool private _paused;
1164 
1165     /**
1166      * @dev Initializes the contract in unpaused state.
1167      */
1168     constructor () {
1169         _paused = false;
1170     }
1171 
1172     /**
1173      * @dev Returns true if the contract is paused, and false otherwise.
1174      */
1175     function paused() public view virtual returns (bool) {
1176         return _paused;
1177     }
1178 
1179     /**
1180      * @dev Modifier to make a function callable only when the contract is not paused.
1181      *
1182      * Requirements:
1183      *
1184      * - The contract must not be paused.
1185      */
1186     modifier whenNotPaused() {
1187         require(!paused(), "Pausable: paused");
1188         _;
1189     }
1190 
1191     /**
1192      * @dev Modifier to make a function callable only when the contract is paused.
1193      *
1194      * Requirements:
1195      *
1196      * - The contract must be paused.
1197      */
1198     modifier whenPaused() {
1199         require(paused(), "Pausable: not paused");
1200         _;
1201     }
1202 
1203     /**
1204      * @dev Triggers stopped state.
1205      *
1206      * Requirements:
1207      *
1208      * - The contract must not be paused.
1209      */
1210     function _pause() internal virtual whenNotPaused {
1211         _paused = true;
1212         emit Paused(_msgSender());
1213     }
1214 
1215     /**
1216      * @dev Returns to normal state.
1217      *
1218      * Requirements:
1219      *
1220      * - The contract must be paused.
1221      */
1222     function _unpause() internal virtual whenPaused {
1223         _paused = false;
1224         emit Unpaused(_msgSender());
1225     }
1226 }
1227 
1228 
1229 
1230 
1231 
1232 
1233 
1234 
1235 
1236 /**
1237  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1238  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1239  *
1240  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1241  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1242  * need to send a transaction, and thus is not required to hold Ether at all.
1243  */
1244 interface IERC20Permit {
1245     /**
1246      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1247      * given ``owner``'s signed approval.
1248      *
1249      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1250      * ordering also apply here.
1251      *
1252      * Emits an {Approval} event.
1253      *
1254      * Requirements:
1255      *
1256      * - `spender` cannot be the zero address.
1257      * - `deadline` must be a timestamp in the future.
1258      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1259      * over the EIP712-formatted function arguments.
1260      * - the signature must use ``owner``'s current nonce (see {nonces}).
1261      *
1262      * For more information on the signature format, see the
1263      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1264      * section].
1265      */
1266     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
1267 
1268     /**
1269      * @dev Returns the current nonce for `owner`. This value must be
1270      * included whenever a signature is generated for {permit}.
1271      *
1272      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1273      * prevents a signature from being used multiple times.
1274      */
1275     function nonces(address owner) external view returns (uint256);
1276 
1277     /**
1278      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1279      */
1280     // solhint-disable-next-line func-name-mixedcase
1281     function DOMAIN_SEPARATOR() external view returns (bytes32);
1282 }
1283 
1284 
1285 
1286 
1287 
1288 
1289 
1290 
1291 /**
1292  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1293  *
1294  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1295  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1296  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1297  *
1298  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1299  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1300  * ({_hashTypedDataV4}).
1301  *
1302  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1303  * the chain id to protect against replay attacks on an eventual fork of the chain.
1304  *
1305  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1306  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1307  *
1308  * _Available since v3.4._
1309  */
1310 abstract contract EIP712 {
1311     /* solhint-disable var-name-mixedcase */
1312     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1313     // invalidate the cached domain separator if the chain id changes.
1314     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1315     uint256 private immutable _CACHED_CHAIN_ID;
1316 
1317     bytes32 private immutable _HASHED_NAME;
1318     bytes32 private immutable _HASHED_VERSION;
1319     bytes32 private immutable _TYPE_HASH;
1320     /* solhint-enable var-name-mixedcase */
1321 
1322     /**
1323      * @dev Initializes the domain separator and parameter caches.
1324      *
1325      * The meaning of `name` and `version` is specified in
1326      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1327      *
1328      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1329      * - `version`: the current major version of the signing domain.
1330      *
1331      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1332      * contract upgrade].
1333      */
1334     constructor(string memory name, string memory version) {
1335         bytes32 hashedName = keccak256(bytes(name));
1336         bytes32 hashedVersion = keccak256(bytes(version));
1337         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1338         _HASHED_NAME = hashedName;
1339         _HASHED_VERSION = hashedVersion;
1340         _CACHED_CHAIN_ID = block.chainid;
1341         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1342         _TYPE_HASH = typeHash;
1343     }
1344 
1345     /**
1346      * @dev Returns the domain separator for the current chain.
1347      */
1348     function _domainSeparatorV4() internal view returns (bytes32) {
1349         if (block.chainid == _CACHED_CHAIN_ID) {
1350             return _CACHED_DOMAIN_SEPARATOR;
1351         } else {
1352             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1353         }
1354     }
1355 
1356     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
1357         return keccak256(
1358             abi.encode(
1359                 typeHash,
1360                 name,
1361                 version,
1362                 block.chainid,
1363                 address(this)
1364             )
1365         );
1366     }
1367 
1368     /**
1369      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1370      * function returns the hash of the fully encoded EIP712 message for this domain.
1371      *
1372      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1373      *
1374      * ```solidity
1375      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1376      *     keccak256("Mail(address to,string contents)"),
1377      *     mailTo,
1378      *     keccak256(bytes(mailContents))
1379      * )));
1380      * address signer = ECDSA.recover(digest, signature);
1381      * ```
1382      */
1383     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1384         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1385     }
1386 }
1387 
1388 
1389 
1390 
1391 
1392 /**
1393  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1394  *
1395  * These functions can be used to verify that a message was signed by the holder
1396  * of the private keys of a given address.
1397  */
1398 library ECDSA {
1399     /**
1400      * @dev Returns the address that signed a hashed message (`hash`) with
1401      * `signature`. This address can then be used for verification purposes.
1402      *
1403      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1404      * this function rejects them by requiring the `s` value to be in the lower
1405      * half order, and the `v` value to be either 27 or 28.
1406      *
1407      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1408      * verification to be secure: it is possible to craft signatures that
1409      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1410      * this is by receiving a hash of the original message (which may otherwise
1411      * be too long), and then calling {toEthSignedMessageHash} on it.
1412      */
1413     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1414         // Divide the signature in r, s and v variables
1415         bytes32 r;
1416         bytes32 s;
1417         uint8 v;
1418 
1419         // Check the signature length
1420         // - case 65: r,s,v signature (standard)
1421         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1422         if (signature.length == 65) {
1423             // ecrecover takes the signature parameters, and the only way to get them
1424             // currently is to use assembly.
1425             // solhint-disable-next-line no-inline-assembly
1426             assembly {
1427                 r := mload(add(signature, 0x20))
1428                 s := mload(add(signature, 0x40))
1429                 v := byte(0, mload(add(signature, 0x60)))
1430             }
1431         } else if (signature.length == 64) {
1432             // ecrecover takes the signature parameters, and the only way to get them
1433             // currently is to use assembly.
1434             // solhint-disable-next-line no-inline-assembly
1435             assembly {
1436                 let vs := mload(add(signature, 0x40))
1437                 r := mload(add(signature, 0x20))
1438                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1439                 v := add(shr(255, vs), 27)
1440             }
1441         } else {
1442             revert("ECDSA: invalid signature length");
1443         }
1444 
1445         return recover(hash, v, r, s);
1446     }
1447 
1448     /**
1449      * @dev Overload of {ECDSA-recover} that receives the `v`,
1450      * `r` and `s` signature fields separately.
1451      */
1452     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1453         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1454         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1455         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1456         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1457         //
1458         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1459         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1460         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1461         // these malleable signatures as well.
1462         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
1463         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
1464 
1465         // If the signature is valid (and not malleable), return the signer address
1466         address signer = ecrecover(hash, v, r, s);
1467         require(signer != address(0), "ECDSA: invalid signature");
1468 
1469         return signer;
1470     }
1471 
1472     /**
1473      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1474      * produces hash corresponding to the one signed with the
1475      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1476      * JSON-RPC method as part of EIP-191.
1477      *
1478      * See {recover}.
1479      */
1480     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1481         // 32 is the length in bytes of hash,
1482         // enforced by the type signature above
1483         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1484     }
1485 
1486     /**
1487      * @dev Returns an Ethereum Signed Typed Data, created from a
1488      * `domainSeparator` and a `structHash`. This produces hash corresponding
1489      * to the one signed with the
1490      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1491      * JSON-RPC method as part of EIP-712.
1492      *
1493      * See {recover}.
1494      */
1495     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1496         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1497     }
1498 }
1499 
1500 
1501 
1502 /**
1503  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1504  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1505  *
1506  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1507  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1508  * need to send a transaction, and thus is not required to hold Ether at all.
1509  *
1510  * _Available since v3.4._
1511  */
1512 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1513     using Counters for Counters.Counter;
1514 
1515     mapping (address => Counters.Counter) private _nonces;
1516 
1517     // solhint-disable-next-line var-name-mixedcase
1518     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1519 
1520     /**
1521      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1522      *
1523      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1524      */
1525     constructor(string memory name) EIP712(name, "1") {
1526     }
1527 
1528     /**
1529      * @dev See {IERC20Permit-permit}.
1530      */
1531     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
1532         // solhint-disable-next-line not-rely-on-time
1533         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1534 
1535         bytes32 structHash = keccak256(
1536             abi.encode(
1537                 _PERMIT_TYPEHASH,
1538                 owner,
1539                 spender,
1540                 value,
1541                 _useNonce(owner),
1542                 deadline
1543             )
1544         );
1545 
1546         bytes32 hash = _hashTypedDataV4(structHash);
1547 
1548         address signer = ECDSA.recover(hash, v, r, s);
1549         require(signer == owner, "ERC20Permit: invalid signature");
1550 
1551         _approve(owner, spender, value);
1552     }
1553 
1554     /**
1555      * @dev See {IERC20Permit-nonces}.
1556      */
1557     function nonces(address owner) public view virtual override returns (uint256) {
1558         return _nonces[owner].current();
1559     }
1560 
1561     /**
1562      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1563      */
1564     // solhint-disable-next-line func-name-mixedcase
1565     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1566         return _domainSeparatorV4();
1567     }
1568 
1569     /**
1570      * @dev "Consume a nonce": return the current value and increment.
1571      *
1572      * _Available since v4.1._
1573      */
1574     function _useNonce(address owner) internal virtual returns (uint256 current) {
1575         Counters.Counter storage nonce = _nonces[owner];
1576         current = nonce.current();
1577         nonce.increment();
1578     }
1579 }
1580 
1581 
1582 contract CMKToken is ERC20, ERC20Burnable, ERC20Snapshot, AccessControl, Pausable, ERC20Permit {
1583     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1584     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1585 
1586     constructor() ERC20("Credmark", "CMK") ERC20Permit("Credmark") {
1587         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1588         _setupRole(SNAPSHOT_ROLE, msg.sender);
1589         _setupRole(PAUSER_ROLE, msg.sender);
1590         _mint(msg.sender, 100000000 * 10 ** decimals());
1591     }
1592 
1593     function snapshot() public {
1594         require(hasRole(SNAPSHOT_ROLE, msg.sender));
1595         _snapshot();
1596     }
1597 
1598     function pause() public {
1599         require(hasRole(PAUSER_ROLE, msg.sender));
1600         _pause();
1601     }
1602 
1603     function unpause() public {
1604         require(hasRole(PAUSER_ROLE, msg.sender));
1605         _unpause();
1606     }
1607 
1608     function _beforeTokenTransfer(address from, address to, uint256 amount)
1609         internal
1610         whenNotPaused
1611         override(ERC20, ERC20Snapshot)
1612     {
1613         super._beforeTokenTransfer(from, to, amount);
1614     }
1615 }