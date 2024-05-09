1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
86 
87 
88 
89 pragma solidity ^0.8.0;
90 
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
115 
116 
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC165 standard, as defined in the
122  * https://eips.ethereum.org/EIPS/eip-165[EIP].
123  *
124  * Implementers can declare support of contract interfaces, which can then be
125  * queried by others ({ERC165Checker}).
126  *
127  * For an implementation, see {ERC165}.
128  */
129 interface IERC165 {
130     /**
131      * @dev Returns true if this contract implements the interface defined by
132      * `interfaceId`. See the corresponding
133      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
134      * to learn more about how these ids are created.
135      *
136      * This function call must use less than 30 000 gas.
137      */
138     function supportsInterface(bytes4 interfaceId) external view returns (bool);
139 }
140 
141 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
142 
143 
144 
145 pragma solidity ^0.8.0;
146 
147 
148 /**
149  * @dev Implementation of the {IERC165} interface.
150  *
151  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
152  * for the additional interface id that will be supported. For example:
153  *
154  * ```solidity
155  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
156  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
157  * }
158  * ```
159  *
160  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
161  */
162 abstract contract ERC165 is IERC165 {
163     /**
164      * @dev See {IERC165-supportsInterface}.
165      */
166     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
167         return interfaceId == type(IERC165).interfaceId;
168     }
169 }
170 
171 // File: @openzeppelin/contracts/utils/Strings.sol
172 
173 
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @dev String operations.
179  */
180 library Strings {
181     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
182 
183     /**
184      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
185      */
186     function toString(uint256 value) internal pure returns (string memory) {
187         // Inspired by OraclizeAPI's implementation - MIT licence
188         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
189 
190         if (value == 0) {
191             return "0";
192         }
193         uint256 temp = value;
194         uint256 digits;
195         while (temp != 0) {
196             digits++;
197             temp /= 10;
198         }
199         bytes memory buffer = new bytes(digits);
200         while (value != 0) {
201             digits -= 1;
202             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
203             value /= 10;
204         }
205         return string(buffer);
206     }
207 
208     /**
209      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
210      */
211     function toHexString(uint256 value) internal pure returns (string memory) {
212         if (value == 0) {
213             return "0x00";
214         }
215         uint256 temp = value;
216         uint256 length = 0;
217         while (temp != 0) {
218             length++;
219             temp >>= 8;
220         }
221         return toHexString(value, length);
222     }
223 
224     /**
225      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
226      */
227     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
228         bytes memory buffer = new bytes(2 * length + 2);
229         buffer[0] = "0";
230         buffer[1] = "x";
231         for (uint256 i = 2 * length + 1; i > 1; --i) {
232             buffer[i] = _HEX_SYMBOLS[value & 0xf];
233             value >>= 4;
234         }
235         require(value == 0, "Strings: hex length insufficient");
236         return string(buffer);
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Context.sol
241 
242 
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev Provides information about the current execution context, including the
248  * sender of the transaction and its data. While these are generally available
249  * via msg.sender and msg.data, they should not be accessed in such a direct
250  * manner, since when dealing with meta-transactions the account sending and
251  * paying for execution may not be the actual sender (as far as an application
252  * is concerned).
253  *
254  * This contract is only required for intermediate, library-like contracts.
255  */
256 abstract contract Context {
257     function _msgSender() internal view virtual returns (address) {
258         return msg.sender;
259     }
260 
261     function _msgData() internal view virtual returns (bytes calldata) {
262         return msg.data;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/security/Pausable.sol
267 
268 
269 
270 pragma solidity ^0.8.0;
271 
272 
273 /**
274  * @dev Contract module which allows children to implement an emergency stop
275  * mechanism that can be triggered by an authorized account.
276  *
277  * This module is used through inheritance. It will make available the
278  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
279  * the functions of your contract. Note that they will not be pausable by
280  * simply including this module, only once the modifiers are put in place.
281  */
282 abstract contract Pausable is Context {
283     /**
284      * @dev Emitted when the pause is triggered by `account`.
285      */
286     event Paused(address account);
287 
288     /**
289      * @dev Emitted when the pause is lifted by `account`.
290      */
291     event Unpaused(address account);
292 
293     bool private _paused;
294 
295     /**
296      * @dev Initializes the contract in unpaused state.
297      */
298     constructor() {
299         _paused = false;
300     }
301 
302     /**
303      * @dev Returns true if the contract is paused, and false otherwise.
304      */
305     function paused() public view virtual returns (bool) {
306         return _paused;
307     }
308 
309     /**
310      * @dev Modifier to make a function callable only when the contract is not paused.
311      *
312      * Requirements:
313      *
314      * - The contract must not be paused.
315      */
316     modifier whenNotPaused() {
317         require(!paused(), "Pausable: paused");
318         _;
319     }
320 
321     /**
322      * @dev Modifier to make a function callable only when the contract is paused.
323      *
324      * Requirements:
325      *
326      * - The contract must be paused.
327      */
328     modifier whenPaused() {
329         require(paused(), "Pausable: not paused");
330         _;
331     }
332 
333     /**
334      * @dev Triggers stopped state.
335      *
336      * Requirements:
337      *
338      * - The contract must not be paused.
339      */
340     function _pause() internal virtual whenNotPaused {
341         _paused = true;
342         emit Paused(_msgSender());
343     }
344 
345     /**
346      * @dev Returns to normal state.
347      *
348      * Requirements:
349      *
350      * - The contract must be paused.
351      */
352     function _unpause() internal virtual whenPaused {
353         _paused = false;
354         emit Unpaused(_msgSender());
355     }
356 }
357 
358 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
359 
360 
361 
362 pragma solidity ^0.8.0;
363 
364 
365 
366 
367 /**
368  * @dev Implementation of the {IERC20} interface.
369  *
370  * This implementation is agnostic to the way tokens are created. This means
371  * that a supply mechanism has to be added in a derived contract using {_mint}.
372  * For a generic mechanism see {ERC20PresetMinterPauser}.
373  *
374  * TIP: For a detailed writeup see our guide
375  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
376  * to implement supply mechanisms].
377  *
378  * We have followed general OpenZeppelin Contracts guidelines: functions revert
379  * instead returning `false` on failure. This behavior is nonetheless
380  * conventional and does not conflict with the expectations of ERC20
381  * applications.
382  *
383  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
384  * This allows applications to reconstruct the allowance for all accounts just
385  * by listening to said events. Other implementations of the EIP may not emit
386  * these events, as it isn't required by the specification.
387  *
388  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
389  * functions have been added to mitigate the well-known issues around setting
390  * allowances. See {IERC20-approve}.
391  */
392 contract ERC20 is Context, IERC20, IERC20Metadata {
393     mapping(address => uint256) private _balances;
394 
395     mapping(address => mapping(address => uint256)) private _allowances;
396 
397     uint256 private _totalSupply;
398 
399     string private _name;
400     string private _symbol;
401 
402     /**
403      * @dev Sets the values for {name} and {symbol}.
404      *
405      * The default value of {decimals} is 18. To select a different value for
406      * {decimals} you should overload it.
407      *
408      * All two of these values are immutable: they can only be set once during
409      * construction.
410      */
411     constructor(string memory name_, string memory symbol_) {
412         _name = name_;
413         _symbol = symbol_;
414     }
415 
416     /**
417      * @dev Returns the name of the token.
418      */
419     function name() public view virtual override returns (string memory) {
420         return _name;
421     }
422 
423     /**
424      * @dev Returns the symbol of the token, usually a shorter version of the
425      * name.
426      */
427     function symbol() public view virtual override returns (string memory) {
428         return _symbol;
429     }
430 
431     /**
432      * @dev Returns the number of decimals used to get its user representation.
433      * For example, if `decimals` equals `2`, a balance of `505` tokens should
434      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
435      *
436      * Tokens usually opt for a value of 18, imitating the relationship between
437      * Ether and Wei. This is the value {ERC20} uses, unless this function is
438      * overridden;
439      *
440      * NOTE: This information is only used for _display_ purposes: it in
441      * no way affects any of the arithmetic of the contract, including
442      * {IERC20-balanceOf} and {IERC20-transfer}.
443      */
444     function decimals() public view virtual override returns (uint8) {
445         return 18;
446     }
447 
448     /**
449      * @dev See {IERC20-totalSupply}.
450      */
451     function totalSupply() public view virtual override returns (uint256) {
452         return _totalSupply;
453     }
454 
455     /**
456      * @dev See {IERC20-balanceOf}.
457      */
458     function balanceOf(address account) public view virtual override returns (uint256) {
459         return _balances[account];
460     }
461 
462     /**
463      * @dev See {IERC20-transfer}.
464      *
465      * Requirements:
466      *
467      * - `recipient` cannot be the zero address.
468      * - the caller must have a balance of at least `amount`.
469      */
470     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
471         _transfer(_msgSender(), recipient, amount);
472         return true;
473     }
474 
475     /**
476      * @dev See {IERC20-allowance}.
477      */
478     function allowance(address owner, address spender) public view virtual override returns (uint256) {
479         return _allowances[owner][spender];
480     }
481 
482     /**
483      * @dev See {IERC20-approve}.
484      *
485      * Requirements:
486      *
487      * - `spender` cannot be the zero address.
488      */
489     function approve(address spender, uint256 amount) public virtual override returns (bool) {
490         _approve(_msgSender(), spender, amount);
491         return true;
492     }
493 
494     /**
495      * @dev See {IERC20-transferFrom}.
496      *
497      * Emits an {Approval} event indicating the updated allowance. This is not
498      * required by the EIP. See the note at the beginning of {ERC20}.
499      *
500      * Requirements:
501      *
502      * - `sender` and `recipient` cannot be the zero address.
503      * - `sender` must have a balance of at least `amount`.
504      * - the caller must have allowance for ``sender``'s tokens of at least
505      * `amount`.
506      */
507     function transferFrom(
508         address sender,
509         address recipient,
510         uint256 amount
511     ) public virtual override returns (bool) {
512         _transfer(sender, recipient, amount);
513 
514         uint256 currentAllowance = _allowances[sender][_msgSender()];
515         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
516         unchecked {
517             _approve(sender, _msgSender(), currentAllowance - amount);
518         }
519 
520         return true;
521     }
522 
523     /**
524      * @dev Atomically increases the allowance granted to `spender` by the caller.
525      *
526      * This is an alternative to {approve} that can be used as a mitigation for
527      * problems described in {IERC20-approve}.
528      *
529      * Emits an {Approval} event indicating the updated allowance.
530      *
531      * Requirements:
532      *
533      * - `spender` cannot be the zero address.
534      */
535     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
536         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
537         return true;
538     }
539 
540     /**
541      * @dev Atomically decreases the allowance granted to `spender` by the caller.
542      *
543      * This is an alternative to {approve} that can be used as a mitigation for
544      * problems described in {IERC20-approve}.
545      *
546      * Emits an {Approval} event indicating the updated allowance.
547      *
548      * Requirements:
549      *
550      * - `spender` cannot be the zero address.
551      * - `spender` must have allowance for the caller of at least
552      * `subtractedValue`.
553      */
554     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
555         uint256 currentAllowance = _allowances[_msgSender()][spender];
556         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
557         unchecked {
558             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
559         }
560 
561         return true;
562     }
563 
564     /**
565      * @dev Moves `amount` of tokens from `sender` to `recipient`.
566      *
567      * This internal function is equivalent to {transfer}, and can be used to
568      * e.g. implement automatic token fees, slashing mechanisms, etc.
569      *
570      * Emits a {Transfer} event.
571      *
572      * Requirements:
573      *
574      * - `sender` cannot be the zero address.
575      * - `recipient` cannot be the zero address.
576      * - `sender` must have a balance of at least `amount`.
577      */
578     function _transfer(
579         address sender,
580         address recipient,
581         uint256 amount
582     ) internal virtual {
583         require(sender != address(0), "ERC20: transfer from the zero address");
584         require(recipient != address(0), "ERC20: transfer to the zero address");
585 
586         _beforeTokenTransfer(sender, recipient, amount);
587 
588         uint256 senderBalance = _balances[sender];
589         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
590         unchecked {
591             _balances[sender] = senderBalance - amount;
592         }
593         _balances[recipient] += amount;
594 
595         emit Transfer(sender, recipient, amount);
596 
597         _afterTokenTransfer(sender, recipient, amount);
598     }
599 
600     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
601      * the total supply.
602      *
603      * Emits a {Transfer} event with `from` set to the zero address.
604      *
605      * Requirements:
606      *
607      * - `account` cannot be the zero address.
608      */
609     function _mint(address account, uint256 amount) internal virtual {
610         require(account != address(0), "ERC20: mint to the zero address");
611 
612         _beforeTokenTransfer(address(0), account, amount);
613 
614         _totalSupply += amount;
615         _balances[account] += amount;
616         emit Transfer(address(0), account, amount);
617 
618         _afterTokenTransfer(address(0), account, amount);
619     }
620 
621     /**
622      * @dev Destroys `amount` tokens from `account`, reducing the
623      * total supply.
624      *
625      * Emits a {Transfer} event with `to` set to the zero address.
626      *
627      * Requirements:
628      *
629      * - `account` cannot be the zero address.
630      * - `account` must have at least `amount` tokens.
631      */
632     function _burn(address account, uint256 amount) internal virtual {
633         require(account != address(0), "ERC20: burn from the zero address");
634 
635         _beforeTokenTransfer(account, address(0), amount);
636 
637         uint256 accountBalance = _balances[account];
638         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
639         unchecked {
640             _balances[account] = accountBalance - amount;
641         }
642         _totalSupply -= amount;
643 
644         emit Transfer(account, address(0), amount);
645 
646         _afterTokenTransfer(account, address(0), amount);
647     }
648 
649     /**
650      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
651      *
652      * This internal function is equivalent to `approve`, and can be used to
653      * e.g. set automatic allowances for certain subsystems, etc.
654      *
655      * Emits an {Approval} event.
656      *
657      * Requirements:
658      *
659      * - `owner` cannot be the zero address.
660      * - `spender` cannot be the zero address.
661      */
662     function _approve(
663         address owner,
664         address spender,
665         uint256 amount
666     ) internal virtual {
667         require(owner != address(0), "ERC20: approve from the zero address");
668         require(spender != address(0), "ERC20: approve to the zero address");
669 
670         _allowances[owner][spender] = amount;
671         emit Approval(owner, spender, amount);
672     }
673 
674     /**
675      * @dev Hook that is called before any transfer of tokens. This includes
676      * minting and burning.
677      *
678      * Calling conditions:
679      *
680      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
681      * will be transferred to `to`.
682      * - when `from` is zero, `amount` tokens will be minted for `to`.
683      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
684      * - `from` and `to` are never both zero.
685      *
686      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
687      */
688     function _beforeTokenTransfer(
689         address from,
690         address to,
691         uint256 amount
692     ) internal virtual {}
693 
694     /**
695      * @dev Hook that is called after any transfer of tokens. This includes
696      * minting and burning.
697      *
698      * Calling conditions:
699      *
700      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
701      * has been transferred to `to`.
702      * - when `from` is zero, `amount` tokens have been minted for `to`.
703      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
704      * - `from` and `to` are never both zero.
705      *
706      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
707      */
708     function _afterTokenTransfer(
709         address from,
710         address to,
711         uint256 amount
712     ) internal virtual {}
713 }
714 
715 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
716 
717 
718 
719 pragma solidity ^0.8.0;
720 
721 
722 
723 /**
724  * @dev Extension of {ERC20} that allows token holders to destroy both their own
725  * tokens and those that they have an allowance for, in a way that can be
726  * recognized off-chain (via event analysis).
727  */
728 abstract contract ERC20Burnable is Context, ERC20 {
729     /**
730      * @dev Destroys `amount` tokens from the caller.
731      *
732      * See {ERC20-_burn}.
733      */
734     function burn(uint256 amount) public virtual {
735         _burn(_msgSender(), amount);
736     }
737 
738     /**
739      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
740      * allowance.
741      *
742      * See {ERC20-_burn} and {ERC20-allowance}.
743      *
744      * Requirements:
745      *
746      * - the caller must have allowance for ``accounts``'s tokens of at least
747      * `amount`.
748      */
749     function burnFrom(address account, uint256 amount) public virtual {
750         uint256 currentAllowance = allowance(account, _msgSender());
751         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
752         unchecked {
753             _approve(account, _msgSender(), currentAllowance - amount);
754         }
755         _burn(account, amount);
756     }
757 }
758 
759 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol
760 
761 
762 
763 pragma solidity ^0.8.0;
764 
765 
766 
767 /**
768  * @dev ERC20 token with pausable token transfers, minting and burning.
769  *
770  * Useful for scenarios such as preventing trades until the end of an evaluation
771  * period, or having an emergency switch for freezing all token transfers in the
772  * event of a large bug.
773  */
774 abstract contract ERC20Pausable is ERC20, Pausable {
775     /**
776      * @dev See {ERC20-_beforeTokenTransfer}.
777      *
778      * Requirements:
779      *
780      * - the contract must not be paused.
781      */
782     function _beforeTokenTransfer(
783         address from,
784         address to,
785         uint256 amount
786     ) internal virtual override {
787         super._beforeTokenTransfer(from, to, amount);
788 
789         require(!paused(), "ERC20Pausable: token transfer while paused");
790     }
791 }
792 
793 // File: @openzeppelin/contracts/access/Ownable.sol
794 
795 
796 
797 pragma solidity ^0.8.0;
798 
799 
800 /**
801  * @dev Contract module which provides a basic access control mechanism, where
802  * there is an account (an owner) that can be granted exclusive access to
803  * specific functions.
804  *
805  * By default, the owner account will be the one that deploys the contract. This
806  * can later be changed with {transferOwnership}.
807  *
808  * This module is used through inheritance. It will make available the modifier
809  * `onlyOwner`, which can be applied to your functions to restrict their use to
810  * the owner.
811  */
812 abstract contract Ownable is Context {
813     address private _owner;
814 
815     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
816 
817     /**
818      * @dev Initializes the contract setting the deployer as the initial owner.
819      */
820     constructor() {
821         _setOwner(_msgSender());
822     }
823 
824     /**
825      * @dev Returns the address of the current owner.
826      */
827     function owner() public view virtual returns (address) {
828         return _owner;
829     }
830 
831     /**
832      * @dev Throws if called by any account other than the owner.
833      */
834     modifier onlyOwner() {
835         require(owner() == _msgSender(), "Ownable: caller is not the owner");
836         _;
837     }
838 
839     /**
840      * @dev Leaves the contract without owner. It will not be possible to call
841      * `onlyOwner` functions anymore. Can only be called by the current owner.
842      *
843      * NOTE: Renouncing ownership will leave the contract without an owner,
844      * thereby removing any functionality that is only available to the owner.
845      */
846     function renounceOwnership() public virtual onlyOwner {
847         _setOwner(address(0));
848     }
849 
850     /**
851      * @dev Transfers ownership of the contract to a new account (`newOwner`).
852      * Can only be called by the current owner.
853      */
854     function transferOwnership(address newOwner) public virtual onlyOwner {
855         require(newOwner != address(0), "Ownable: new owner is the zero address");
856         _setOwner(newOwner);
857     }
858 
859     function _setOwner(address newOwner) private {
860         address oldOwner = _owner;
861         _owner = newOwner;
862         emit OwnershipTransferred(oldOwner, newOwner);
863     }
864 }
865 
866 // File: @openzeppelin/contracts/access/IAccessControl.sol
867 
868 
869 
870 pragma solidity ^0.8.0;
871 
872 /**
873  * @dev External interface of AccessControl declared to support ERC165 detection.
874  */
875 interface IAccessControl {
876     /**
877      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
878      *
879      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
880      * {RoleAdminChanged} not being emitted signaling this.
881      *
882      * _Available since v3.1._
883      */
884     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
885 
886     /**
887      * @dev Emitted when `account` is granted `role`.
888      *
889      * `sender` is the account that originated the contract call, an admin role
890      * bearer except when using {AccessControl-_setupRole}.
891      */
892     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
893 
894     /**
895      * @dev Emitted when `account` is revoked `role`.
896      *
897      * `sender` is the account that originated the contract call:
898      *   - if using `revokeRole`, it is the admin role bearer
899      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
900      */
901     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
902 
903     /**
904      * @dev Returns `true` if `account` has been granted `role`.
905      */
906     function hasRole(bytes32 role, address account) external view returns (bool);
907 
908     /**
909      * @dev Returns the admin role that controls `role`. See {grantRole} and
910      * {revokeRole}.
911      *
912      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
913      */
914     function getRoleAdmin(bytes32 role) external view returns (bytes32);
915 
916     /**
917      * @dev Grants `role` to `account`.
918      *
919      * If `account` had not been already granted `role`, emits a {RoleGranted}
920      * event.
921      *
922      * Requirements:
923      *
924      * - the caller must have ``role``'s admin role.
925      */
926     function grantRole(bytes32 role, address account) external;
927 
928     /**
929      * @dev Revokes `role` from `account`.
930      *
931      * If `account` had been granted `role`, emits a {RoleRevoked} event.
932      *
933      * Requirements:
934      *
935      * - the caller must have ``role``'s admin role.
936      */
937     function revokeRole(bytes32 role, address account) external;
938 
939     /**
940      * @dev Revokes `role` from the calling account.
941      *
942      * Roles are often managed via {grantRole} and {revokeRole}: this function's
943      * purpose is to provide a mechanism for accounts to lose their privileges
944      * if they are compromised (such as when a trusted device is misplaced).
945      *
946      * If the calling account had been granted `role`, emits a {RoleRevoked}
947      * event.
948      *
949      * Requirements:
950      *
951      * - the caller must be `account`.
952      */
953     function renounceRole(bytes32 role, address account) external;
954 }
955 
956 // File: @openzeppelin/contracts/access/AccessControl.sol
957 
958 
959 
960 pragma solidity ^0.8.0;
961 
962 
963 
964 
965 
966 /**
967  * @dev Contract module that allows children to implement role-based access
968  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
969  * members except through off-chain means by accessing the contract event logs. Some
970  * applications may benefit from on-chain enumerability, for those cases see
971  * {AccessControlEnumerable}.
972  *
973  * Roles are referred to by their `bytes32` identifier. These should be exposed
974  * in the external API and be unique. The best way to achieve this is by
975  * using `public constant` hash digests:
976  *
977  * ```
978  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
979  * ```
980  *
981  * Roles can be used to represent a set of permissions. To restrict access to a
982  * function call, use {hasRole}:
983  *
984  * ```
985  * function foo() public {
986  *     require(hasRole(MY_ROLE, msg.sender));
987  *     ...
988  * }
989  * ```
990  *
991  * Roles can be granted and revoked dynamically via the {grantRole} and
992  * {revokeRole} functions. Each role has an associated admin role, and only
993  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
994  *
995  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
996  * that only accounts with this role will be able to grant or revoke other
997  * roles. More complex role relationships can be created by using
998  * {_setRoleAdmin}.
999  *
1000  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1001  * grant and revoke this role. Extra precautions should be taken to secure
1002  * accounts that have been granted it.
1003  */
1004 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1005     struct RoleData {
1006         mapping(address => bool) members;
1007         bytes32 adminRole;
1008     }
1009 
1010     mapping(bytes32 => RoleData) private _roles;
1011 
1012     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1013 
1014     /**
1015      * @dev Modifier that checks that an account has a specific role. Reverts
1016      * with a standardized message including the required role.
1017      *
1018      * The format of the revert reason is given by the following regular expression:
1019      *
1020      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1021      *
1022      * _Available since v4.1._
1023      */
1024     modifier onlyRole(bytes32 role) {
1025         _checkRole(role, _msgSender());
1026         _;
1027     }
1028 
1029     /**
1030      * @dev See {IERC165-supportsInterface}.
1031      */
1032     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1033         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1034     }
1035 
1036     /**
1037      * @dev Returns `true` if `account` has been granted `role`.
1038      */
1039     function hasRole(bytes32 role, address account) public view override returns (bool) {
1040         return _roles[role].members[account];
1041     }
1042 
1043     /**
1044      * @dev Revert with a standard message if `account` is missing `role`.
1045      *
1046      * The format of the revert reason is given by the following regular expression:
1047      *
1048      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1049      */
1050     function _checkRole(bytes32 role, address account) internal view {
1051         if (!hasRole(role, account)) {
1052             revert(
1053                 string(
1054                     abi.encodePacked(
1055                         "AccessControl: account ",
1056                         Strings.toHexString(uint160(account), 20),
1057                         " is missing role ",
1058                         Strings.toHexString(uint256(role), 32)
1059                     )
1060                 )
1061             );
1062         }
1063     }
1064 
1065     /**
1066      * @dev Returns the admin role that controls `role`. See {grantRole} and
1067      * {revokeRole}.
1068      *
1069      * To change a role's admin, use {_setRoleAdmin}.
1070      */
1071     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1072         return _roles[role].adminRole;
1073     }
1074 
1075     /**
1076      * @dev Grants `role` to `account`.
1077      *
1078      * If `account` had not been already granted `role`, emits a {RoleGranted}
1079      * event.
1080      *
1081      * Requirements:
1082      *
1083      * - the caller must have ``role``'s admin role.
1084      */
1085     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1086         _grantRole(role, account);
1087     }
1088 
1089     /**
1090      * @dev Revokes `role` from `account`.
1091      *
1092      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1093      *
1094      * Requirements:
1095      *
1096      * - the caller must have ``role``'s admin role.
1097      */
1098     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1099         _revokeRole(role, account);
1100     }
1101 
1102     /**
1103      * @dev Revokes `role` from the calling account.
1104      *
1105      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1106      * purpose is to provide a mechanism for accounts to lose their privileges
1107      * if they are compromised (such as when a trusted device is misplaced).
1108      *
1109      * If the calling account had been granted `role`, emits a {RoleRevoked}
1110      * event.
1111      *
1112      * Requirements:
1113      *
1114      * - the caller must be `account`.
1115      */
1116     function renounceRole(bytes32 role, address account) public virtual override {
1117         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1118 
1119         _revokeRole(role, account);
1120     }
1121 
1122     /**
1123      * @dev Grants `role` to `account`.
1124      *
1125      * If `account` had not been already granted `role`, emits a {RoleGranted}
1126      * event. Note that unlike {grantRole}, this function doesn't perform any
1127      * checks on the calling account.
1128      *
1129      * [WARNING]
1130      * ====
1131      * This function should only be called from the constructor when setting
1132      * up the initial roles for the system.
1133      *
1134      * Using this function in any other way is effectively circumventing the admin
1135      * system imposed by {AccessControl}.
1136      * ====
1137      */
1138     function _setupRole(bytes32 role, address account) internal virtual {
1139         _grantRole(role, account);
1140     }
1141 
1142     /**
1143      * @dev Sets `adminRole` as ``role``'s admin role.
1144      *
1145      * Emits a {RoleAdminChanged} event.
1146      */
1147     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1148         bytes32 previousAdminRole = getRoleAdmin(role);
1149         _roles[role].adminRole = adminRole;
1150         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1151     }
1152 
1153     function _grantRole(bytes32 role, address account) private {
1154         if (!hasRole(role, account)) {
1155             _roles[role].members[account] = true;
1156             emit RoleGranted(role, account, _msgSender());
1157         }
1158     }
1159 
1160     function _revokeRole(bytes32 role, address account) private {
1161         if (hasRole(role, account)) {
1162             _roles[role].members[account] = false;
1163             emit RoleRevoked(role, account, _msgSender());
1164         }
1165     }
1166 }
1167 
1168 // File: contracts/1_Storage.sol
1169 
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 
1174 
1175 
1176 
1177 
1178 contract ReltimeContract is Context, AccessControl, Ownable, ERC20, ERC20Pausable, ERC20Burnable {
1179     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1180     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1181 
1182     uint8 private decimal;
1183     
1184     constructor(string memory tokenName, string memory tokenSymbol, uint256 initialSupply, uint8 decimal_) ERC20(tokenName, tokenSymbol) {
1185         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1186         _setupRole(MINTER_ROLE, _msgSender());
1187         _setupRole(PAUSER_ROLE, _msgSender());
1188         
1189         decimal = decimal_;
1190         initialSupply = initialSupply  * (10 ** uint8(decimal));  //1000000000
1191         
1192         _mint(msg.sender, initialSupply);   
1193     }
1194     
1195     function decimals() public view virtual override returns (uint8) {
1196         return decimal;
1197     }
1198     
1199     function mint(address to, uint256 amount) public virtual {
1200         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1201         _mint(to, amount);
1202     }
1203    
1204     function pause() public virtual {
1205         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1206         _pause();
1207     }
1208 
1209     
1210     function unpause() public virtual {
1211         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1212         _unpause();
1213     }
1214 
1215     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1216         super._beforeTokenTransfer(from, to, amount);
1217     }
1218 }