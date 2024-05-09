1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Emitted when `value` tokens are moved from one account (`from`) to
37      * another (`to`).
38      *
39      * Note that `value` may be zero.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     /**
44      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
45      * a call to {approve}. `value` is the new allowance.
46      */
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 
49     /**
50      * @dev Returns the amount of tokens in existence.
51      */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55      * @dev Returns the amount of tokens owned by `account`.
56      */
57     function balanceOf(address account) external view returns (uint256);
58 
59     /**
60      * @dev Moves `amount` tokens from the caller's account to `to`.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transfer(address to, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Returns the remaining number of tokens that `spender` will be
70      * allowed to spend on behalf of `owner` through {transferFrom}. This is
71      * zero by default.
72      *
73      * This value changes when {approve} or {transferFrom} are called.
74      */
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     /**
78      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * IMPORTANT: Beware that changing an allowance with this method brings the risk
83      * that someone may use both the old and the new allowance by unfortunate
84      * transaction ordering. One possible solution to mitigate this race
85      * condition is to first reduce the spender's allowance to 0 and set the
86      * desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      *
89      * Emits an {Approval} event.
90      */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Moves `amount` tokens from `from` to `to` using the
95      * allowance mechanism. `amount` is then deducted from the caller's
96      * allowance.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 amount
106     ) external returns (bool);
107 }
108 
109 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev String operations.
115  */
116 library Strings {
117     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
118     uint8 private constant _ADDRESS_LENGTH = 20;
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
122      */
123     function toString(uint256 value) internal pure returns (string memory) {
124         // Inspired by OraclizeAPI's implementation - MIT licence
125         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
126 
127         if (value == 0) {
128             return "0";
129         }
130         uint256 temp = value;
131         uint256 digits;
132         while (temp != 0) {
133             digits++;
134             temp /= 10;
135         }
136         bytes memory buffer = new bytes(digits);
137         while (value != 0) {
138             digits -= 1;
139             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
140             value /= 10;
141         }
142         return string(buffer);
143     }
144 
145     /**
146      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
147      */
148     function toHexString(uint256 value) internal pure returns (string memory) {
149         if (value == 0) {
150             return "0x00";
151         }
152         uint256 temp = value;
153         uint256 length = 0;
154         while (temp != 0) {
155             length++;
156             temp >>= 8;
157         }
158         return toHexString(value, length);
159     }
160 
161     /**
162      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
163      */
164     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
165         bytes memory buffer = new bytes(2 * length + 2);
166         buffer[0] = "0";
167         buffer[1] = "x";
168         for (uint256 i = 2 * length + 1; i > 1; --i) {
169             buffer[i] = _HEX_SYMBOLS[value & 0xf];
170             value >>= 4;
171         }
172         require(value == 0, "Strings: hex length insufficient");
173         return string(buffer);
174     }
175 
176     /**
177      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
178      */
179     function toHexString(address addr) internal pure returns (string memory) {
180         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
181     }
182 }
183 
184 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev Provides information about the current execution context, including the
190  * sender of the transaction and its data. While these are generally available
191  * via msg.sender and msg.data, they should not be accessed in such a direct
192  * manner, since when dealing with meta-transactions the account sending and
193  * paying for execution may not be the actual sender (as far as an application
194  * is concerned).
195  *
196  * This contract is only required for intermediate, library-like contracts.
197  */
198 abstract contract Context {
199     function _msgSender() internal view virtual returns (address) {
200         return msg.sender;
201     }
202 
203     function _msgData() internal view virtual returns (bytes calldata) {
204         return msg.data;
205     }
206 }
207 
208 pragma solidity ^0.8.4;
209 
210 
211 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 
216 
217 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
218 
219 pragma solidity ^0.8.0;
220 
221 
222 
223 /**
224  * @dev Interface for the optional metadata functions from the ERC20 standard.
225  *
226  * _Available since v4.1._
227  */
228 interface IERC20Metadata is IERC20 {
229     /**
230      * @dev Returns the name of the token.
231      */
232     function name() external view returns (string memory);
233 
234     /**
235      * @dev Returns the symbol of the token.
236      */
237     function symbol() external view returns (string memory);
238 
239     /**
240      * @dev Returns the decimals places of the token.
241      */
242     function decimals() external view returns (uint8);
243 }
244 
245 
246 
247 /**
248  * @dev Implementation of the {IERC20} interface.
249  *
250  * This implementation is agnostic to the way tokens are created. This means
251  * that a supply mechanism has to be added in a derived contract using {_mint}.
252  * For a generic mechanism see {ERC20PresetMinterPauser}.
253  *
254  * TIP: For a detailed writeup see our guide
255  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
256  * to implement supply mechanisms].
257  *
258  * We have followed general OpenZeppelin Contracts guidelines: functions revert
259  * instead returning `false` on failure. This behavior is nonetheless
260  * conventional and does not conflict with the expectations of ERC20
261  * applications.
262  *
263  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
264  * This allows applications to reconstruct the allowance for all accounts just
265  * by listening to said events. Other implementations of the EIP may not emit
266  * these events, as it isn't required by the specification.
267  *
268  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
269  * functions have been added to mitigate the well-known issues around setting
270  * allowances. See {IERC20-approve}.
271  */
272 contract ERC20 is Context, IERC20, IERC20Metadata {
273     mapping(address => uint256) private _balances;
274 
275     mapping(address => mapping(address => uint256)) private _allowances;
276 
277     uint256 private _totalSupply;
278 
279     string private _name;
280     string private _symbol;
281 
282     /**
283      * @dev Sets the values for {name} and {symbol}.
284      *
285      * The default value of {decimals} is 18. To select a different value for
286      * {decimals} you should overload it.
287      *
288      * All two of these values are immutable: they can only be set once during
289      * construction.
290      */
291     constructor(string memory name_, string memory symbol_) {
292         _name = name_;
293         _symbol = symbol_;
294     }
295 
296     /**
297      * @dev Returns the name of the token.
298      */
299     function name() public view virtual override returns (string memory) {
300         return _name;
301     }
302 
303     /**
304      * @dev Returns the symbol of the token, usually a shorter version of the
305      * name.
306      */
307     function symbol() public view virtual override returns (string memory) {
308         return _symbol;
309     }
310 
311     /**
312      * @dev Returns the number of decimals used to get its user representation.
313      * For example, if `decimals` equals `2`, a balance of `505` tokens should
314      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
315      *
316      * Tokens usually opt for a value of 18, imitating the relationship between
317      * Ether and Wei. This is the value {ERC20} uses, unless this function is
318      * overridden;
319      *
320      * NOTE: This information is only used for _display_ purposes: it in
321      * no way affects any of the arithmetic of the contract, including
322      * {IERC20-balanceOf} and {IERC20-transfer}.
323      */
324     function decimals() public view virtual override returns (uint8) {
325         return 18;
326     }
327 
328     /**
329      * @dev See {IERC20-totalSupply}.
330      */
331     function totalSupply() public view virtual override returns (uint256) {
332         return _totalSupply;
333     }
334 
335     /**
336      * @dev See {IERC20-balanceOf}.
337      */
338     function balanceOf(address account) public view virtual override returns (uint256) {
339         return _balances[account];
340     }
341 
342     /**
343      * @dev See {IERC20-transfer}.
344      *
345      * Requirements:
346      *
347      * - `to` cannot be the zero address.
348      * - the caller must have a balance of at least `amount`.
349      */
350     function transfer(address to, uint256 amount) public virtual override returns (bool) {
351         address owner = _msgSender();
352         _transfer(owner, to, amount);
353         return true;
354     }
355 
356     /**
357      * @dev See {IERC20-allowance}.
358      */
359     function allowance(address owner, address spender) public view virtual override returns (uint256) {
360         return _allowances[owner][spender];
361     }
362 
363     /**
364      * @dev See {IERC20-approve}.
365      *
366      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
367      * `transferFrom`. This is semantically equivalent to an infinite approval.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      */
373     function approve(address spender, uint256 amount) public virtual override returns (bool) {
374         address owner = _msgSender();
375         _approve(owner, spender, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-transferFrom}.
381      *
382      * Emits an {Approval} event indicating the updated allowance. This is not
383      * required by the EIP. See the note at the beginning of {ERC20}.
384      *
385      * NOTE: Does not update the allowance if the current allowance
386      * is the maximum `uint256`.
387      *
388      * Requirements:
389      *
390      * - `from` and `to` cannot be the zero address.
391      * - `from` must have a balance of at least `amount`.
392      * - the caller must have allowance for ``from``'s tokens of at least
393      * `amount`.
394      */
395     function transferFrom(
396         address from,
397         address to,
398         uint256 amount
399     ) public virtual override returns (bool) {
400         address spender = _msgSender();
401         _spendAllowance(from, spender, amount);
402         _transfer(from, to, amount);
403         return true;
404     }
405 
406     /**
407      * @dev Atomically increases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      */
418     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
419         address owner = _msgSender();
420         _approve(owner, spender, allowance(owner, spender) + addedValue);
421         return true;
422     }
423 
424     /**
425      * @dev Atomically decreases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      * - `spender` must have allowance for the caller of at least
436      * `subtractedValue`.
437      */
438     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
439         address owner = _msgSender();
440         uint256 currentAllowance = allowance(owner, spender);
441         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
442         unchecked {
443             _approve(owner, spender, currentAllowance - subtractedValue);
444         }
445 
446         return true;
447     }
448 
449     /**
450      * @dev Moves `amount` of tokens from `from` to `to`.
451      *
452      * This internal function is equivalent to {transfer}, and can be used to
453      * e.g. implement automatic token fees, slashing mechanisms, etc.
454      *
455      * Emits a {Transfer} event.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `from` must have a balance of at least `amount`.
462      */
463     function _transfer(
464         address from,
465         address to,
466         uint256 amount
467     ) internal virtual {
468         require(from != address(0), "ERC20: transfer from the zero address");
469         require(to != address(0), "ERC20: transfer to the zero address");
470 
471         _beforeTokenTransfer(from, to, amount);
472 
473         uint256 fromBalance = _balances[from];
474         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
475         unchecked {
476             _balances[from] = fromBalance - amount;
477         }
478         _balances[to] += amount;
479 
480         emit Transfer(from, to, amount);
481 
482         _afterTokenTransfer(from, to, amount);
483     }
484 
485     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
486      * the total supply.
487      *
488      * Emits a {Transfer} event with `from` set to the zero address.
489      *
490      * Requirements:
491      *
492      * - `account` cannot be the zero address.
493      */
494     function _mint(address account, uint256 amount) internal virtual {
495         require(account != address(0), "ERC20: mint to the zero address");
496 
497         _beforeTokenTransfer(address(0), account, amount);
498 
499         _totalSupply += amount;
500         _balances[account] += amount;
501         emit Transfer(address(0), account, amount);
502 
503         _afterTokenTransfer(address(0), account, amount);
504     }
505 
506     /**
507      * @dev Destroys `amount` tokens from `account`, reducing the
508      * total supply.
509      *
510      * Emits a {Transfer} event with `to` set to the zero address.
511      *
512      * Requirements:
513      *
514      * - `account` cannot be the zero address.
515      * - `account` must have at least `amount` tokens.
516      */
517     function _burn(address account, uint256 amount) internal virtual {
518         require(account != address(0), "ERC20: burn from the zero address");
519 
520         _beforeTokenTransfer(account, address(0), amount);
521 
522         uint256 accountBalance = _balances[account];
523         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
524         unchecked {
525             _balances[account] = accountBalance - amount;
526         }
527         _totalSupply -= amount;
528 
529         emit Transfer(account, address(0), amount);
530 
531         _afterTokenTransfer(account, address(0), amount);
532     }
533 
534     /**
535      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
536      *
537      * This internal function is equivalent to `approve`, and can be used to
538      * e.g. set automatic allowances for certain subsystems, etc.
539      *
540      * Emits an {Approval} event.
541      *
542      * Requirements:
543      *
544      * - `owner` cannot be the zero address.
545      * - `spender` cannot be the zero address.
546      */
547     function _approve(
548         address owner,
549         address spender,
550         uint256 amount
551     ) internal virtual {
552         require(owner != address(0), "ERC20: approve from the zero address");
553         require(spender != address(0), "ERC20: approve to the zero address");
554 
555         _allowances[owner][spender] = amount;
556         emit Approval(owner, spender, amount);
557     }
558 
559     /**
560      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
561      *
562      * Does not update the allowance amount in case of infinite allowance.
563      * Revert if not enough allowance is available.
564      *
565      * Might emit an {Approval} event.
566      */
567     function _spendAllowance(
568         address owner,
569         address spender,
570         uint256 amount
571     ) internal virtual {
572         uint256 currentAllowance = allowance(owner, spender);
573         if (currentAllowance != type(uint256).max) {
574             require(currentAllowance >= amount, "ERC20: insufficient allowance");
575             unchecked {
576                 _approve(owner, spender, currentAllowance - amount);
577             }
578         }
579     }
580 
581     /**
582      * @dev Hook that is called before any transfer of tokens. This includes
583      * minting and burning.
584      *
585      * Calling conditions:
586      *
587      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
588      * will be transferred to `to`.
589      * - when `from` is zero, `amount` tokens will be minted for `to`.
590      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
591      * - `from` and `to` are never both zero.
592      *
593      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
594      */
595     function _beforeTokenTransfer(
596         address from,
597         address to,
598         uint256 amount
599     ) internal virtual {}
600 
601     /**
602      * @dev Hook that is called after any transfer of tokens. This includes
603      * minting and burning.
604      *
605      * Calling conditions:
606      *
607      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
608      * has been transferred to `to`.
609      * - when `from` is zero, `amount` tokens have been minted for `to`.
610      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
611      * - `from` and `to` are never both zero.
612      *
613      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
614      */
615     function _afterTokenTransfer(
616         address from,
617         address to,
618         uint256 amount
619     ) internal virtual {}
620 }
621 
622 
623 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 
628 
629 
630 /**
631  * @dev Extension of {ERC20} that allows token holders to destroy both their own
632  * tokens and those that they have an allowance for, in a way that can be
633  * recognized off-chain (via event analysis).
634  */
635 abstract contract ERC20Burnable is Context, ERC20 {
636     /**
637      * @dev Destroys `amount` tokens from the caller.
638      *
639      * See {ERC20-_burn}.
640      */
641     function burn(uint256 amount) public virtual {
642         _burn(_msgSender(), amount);
643     }
644 
645     /**
646      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
647      * allowance.
648      *
649      * See {ERC20-_burn} and {ERC20-allowance}.
650      *
651      * Requirements:
652      *
653      * - the caller must have allowance for ``accounts``'s tokens of at least
654      * `amount`.
655      */
656     function burnFrom(address account, uint256 amount) public virtual {
657         _spendAllowance(account, _msgSender(), amount);
658         _burn(account, amount);
659     }
660 }
661 
662 
663 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 
669 /**
670  * @dev Contract module which allows children to implement an emergency stop
671  * mechanism that can be triggered by an authorized account.
672  *
673  * This module is used through inheritance. It will make available the
674  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
675  * the functions of your contract. Note that they will not be pausable by
676  * simply including this module, only once the modifiers are put in place.
677  */
678 abstract contract Pausable is Context {
679     /**
680      * @dev Emitted when the pause is triggered by `account`.
681      */
682     event Paused(address account);
683 
684     /**
685      * @dev Emitted when the pause is lifted by `account`.
686      */
687     event Unpaused(address account);
688 
689     bool private _paused;
690 
691     /**
692      * @dev Initializes the contract in unpaused state.
693      */
694     constructor() {
695         _paused = false;
696     }
697 
698     /**
699      * @dev Modifier to make a function callable only when the contract is not paused.
700      *
701      * Requirements:
702      *
703      * - The contract must not be paused.
704      */
705     modifier whenNotPaused() {
706         _requireNotPaused();
707         _;
708     }
709 
710     /**
711      * @dev Modifier to make a function callable only when the contract is paused.
712      *
713      * Requirements:
714      *
715      * - The contract must be paused.
716      */
717     modifier whenPaused() {
718         _requirePaused();
719         _;
720     }
721 
722     /**
723      * @dev Returns true if the contract is paused, and false otherwise.
724      */
725     function paused() public view virtual returns (bool) {
726         return _paused;
727     }
728 
729     /**
730      * @dev Throws if the contract is paused.
731      */
732     function _requireNotPaused() internal view virtual {
733         require(!paused(), "Pausable: paused");
734     }
735 
736     /**
737      * @dev Throws if the contract is not paused.
738      */
739     function _requirePaused() internal view virtual {
740         require(paused(), "Pausable: not paused");
741     }
742 
743     /**
744      * @dev Triggers stopped state.
745      *
746      * Requirements:
747      *
748      * - The contract must not be paused.
749      */
750     function _pause() internal virtual whenNotPaused {
751         _paused = true;
752         emit Paused(_msgSender());
753     }
754 
755     /**
756      * @dev Returns to normal state.
757      *
758      * Requirements:
759      *
760      * - The contract must be paused.
761      */
762     function _unpause() internal virtual whenPaused {
763         _paused = false;
764         emit Unpaused(_msgSender());
765     }
766 }
767 
768 
769 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 
774 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
775 
776 pragma solidity ^0.8.0;
777 
778 /**
779  * @dev External interface of AccessControl declared to support ERC165 detection.
780  */
781 interface IAccessControl {
782     /**
783      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
784      *
785      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
786      * {RoleAdminChanged} not being emitted signaling this.
787      *
788      * _Available since v3.1._
789      */
790     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
791 
792     /**
793      * @dev Emitted when `account` is granted `role`.
794      *
795      * `sender` is the account that originated the contract call, an admin role
796      * bearer except when using {AccessControl-_setupRole}.
797      */
798     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
799 
800     /**
801      * @dev Emitted when `account` is revoked `role`.
802      *
803      * `sender` is the account that originated the contract call:
804      *   - if using `revokeRole`, it is the admin role bearer
805      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
806      */
807     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
808 
809     /**
810      * @dev Returns `true` if `account` has been granted `role`.
811      */
812     function hasRole(bytes32 role, address account) external view returns (bool);
813 
814     /**
815      * @dev Returns the admin role that controls `role`. See {grantRole} and
816      * {revokeRole}.
817      *
818      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
819      */
820     function getRoleAdmin(bytes32 role) external view returns (bytes32);
821 
822     /**
823      * @dev Grants `role` to `account`.
824      *
825      * If `account` had not been already granted `role`, emits a {RoleGranted}
826      * event.
827      *
828      * Requirements:
829      *
830      * - the caller must have ``role``'s admin role.
831      */
832     function grantRole(bytes32 role, address account) external;
833 
834     /**
835      * @dev Revokes `role` from `account`.
836      *
837      * If `account` had been granted `role`, emits a {RoleRevoked} event.
838      *
839      * Requirements:
840      *
841      * - the caller must have ``role``'s admin role.
842      */
843     function revokeRole(bytes32 role, address account) external;
844 
845     /**
846      * @dev Revokes `role` from the calling account.
847      *
848      * Roles are often managed via {grantRole} and {revokeRole}: this function's
849      * purpose is to provide a mechanism for accounts to lose their privileges
850      * if they are compromised (such as when a trusted device is misplaced).
851      *
852      * If the calling account had been granted `role`, emits a {RoleRevoked}
853      * event.
854      *
855      * Requirements:
856      *
857      * - the caller must be `account`.
858      */
859     function renounceRole(bytes32 role, address account) external;
860 }
861 
862 
863 
864 
865 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 
870 
871 /**
872  * @dev Implementation of the {IERC165} interface.
873  *
874  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
875  * for the additional interface id that will be supported. For example:
876  *
877  * ```solidity
878  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
879  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
880  * }
881  * ```
882  *
883  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
884  */
885 abstract contract ERC165 is IERC165 {
886     /**
887      * @dev See {IERC165-supportsInterface}.
888      */
889     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
890         return interfaceId == type(IERC165).interfaceId;
891     }
892 }
893 
894 
895 /**
896  * @dev Contract module that allows children to implement role-based access
897  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
898  * members except through off-chain means by accessing the contract event logs. Some
899  * applications may benefit from on-chain enumerability, for those cases see
900  * {AccessControlEnumerable}.
901  *
902  * Roles are referred to by their `bytes32` identifier. These should be exposed
903  * in the external API and be unique. The best way to achieve this is by
904  * using `public constant` hash digests:
905  *
906  * ```
907  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
908  * ```
909  *
910  * Roles can be used to represent a set of permissions. To restrict access to a
911  * function call, use {hasRole}:
912  *
913  * ```
914  * function foo() public {
915  *     require(hasRole(MY_ROLE, msg.sender));
916  *     ...
917  * }
918  * ```
919  *
920  * Roles can be granted and revoked dynamically via the {grantRole} and
921  * {revokeRole} functions. Each role has an associated admin role, and only
922  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
923  *
924  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
925  * that only accounts with this role will be able to grant or revoke other
926  * roles. More complex role relationships can be created by using
927  * {_setRoleAdmin}.
928  *
929  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
930  * grant and revoke this role. Extra precautions should be taken to secure
931  * accounts that have been granted it.
932  */
933 abstract contract AccessControl is Context, IAccessControl, ERC165 {
934     struct RoleData {
935         mapping(address => bool) members;
936         bytes32 adminRole;
937     }
938 
939     mapping(bytes32 => RoleData) private _roles;
940 
941     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
942 
943     /**
944      * @dev Modifier that checks that an account has a specific role. Reverts
945      * with a standardized message including the required role.
946      *
947      * The format of the revert reason is given by the following regular expression:
948      *
949      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
950      *
951      * _Available since v4.1._
952      */
953     modifier onlyRole(bytes32 role) {
954         _checkRole(role);
955         _;
956     }
957 
958     /**
959      * @dev See {IERC165-supportsInterface}.
960      */
961     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
962         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
963     }
964 
965     /**
966      * @dev Returns `true` if `account` has been granted `role`.
967      */
968     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
969         return _roles[role].members[account];
970     }
971 
972     /**
973      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
974      * Overriding this function changes the behavior of the {onlyRole} modifier.
975      *
976      * Format of the revert message is described in {_checkRole}.
977      *
978      * _Available since v4.6._
979      */
980     function _checkRole(bytes32 role) internal view virtual {
981         _checkRole(role, _msgSender());
982     }
983 
984     /**
985      * @dev Revert with a standard message if `account` is missing `role`.
986      *
987      * The format of the revert reason is given by the following regular expression:
988      *
989      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
990      */
991     function _checkRole(bytes32 role, address account) internal view virtual {
992         if (!hasRole(role, account)) {
993             revert(
994                 string(
995                     abi.encodePacked(
996                         "AccessControl: account ",
997                         Strings.toHexString(uint160(account), 20),
998                         " is missing role ",
999                         Strings.toHexString(uint256(role), 32)
1000                     )
1001                 )
1002             );
1003         }
1004     }
1005 
1006     /**
1007      * @dev Returns the admin role that controls `role`. See {grantRole} and
1008      * {revokeRole}.
1009      *
1010      * To change a role's admin, use {_setRoleAdmin}.
1011      */
1012     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1013         return _roles[role].adminRole;
1014     }
1015 
1016     /**
1017      * @dev Grants `role` to `account`.
1018      *
1019      * If `account` had not been already granted `role`, emits a {RoleGranted}
1020      * event.
1021      *
1022      * Requirements:
1023      *
1024      * - the caller must have ``role``'s admin role.
1025      *
1026      * May emit a {RoleGranted} event.
1027      */
1028     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1029         _grantRole(role, account);
1030     }
1031 
1032     /**
1033      * @dev Revokes `role` from `account`.
1034      *
1035      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1036      *
1037      * Requirements:
1038      *
1039      * - the caller must have ``role``'s admin role.
1040      *
1041      * May emit a {RoleRevoked} event.
1042      */
1043     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1044         _revokeRole(role, account);
1045     }
1046 
1047     /**
1048      * @dev Revokes `role` from the calling account.
1049      *
1050      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1051      * purpose is to provide a mechanism for accounts to lose their privileges
1052      * if they are compromised (such as when a trusted device is misplaced).
1053      *
1054      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1055      * event.
1056      *
1057      * Requirements:
1058      *
1059      * - the caller must be `account`.
1060      *
1061      * May emit a {RoleRevoked} event.
1062      */
1063     function renounceRole(bytes32 role, address account) public virtual override {
1064         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1065 
1066         _revokeRole(role, account);
1067     }
1068 
1069     /**
1070      * @dev Grants `role` to `account`.
1071      *
1072      * If `account` had not been already granted `role`, emits a {RoleGranted}
1073      * event. Note that unlike {grantRole}, this function doesn't perform any
1074      * checks on the calling account.
1075      *
1076      * May emit a {RoleGranted} event.
1077      *
1078      * [WARNING]
1079      * ====
1080      * This function should only be called from the constructor when setting
1081      * up the initial roles for the system.
1082      *
1083      * Using this function in any other way is effectively circumventing the admin
1084      * system imposed by {AccessControl}.
1085      * ====
1086      *
1087      * NOTE: This function is deprecated in favor of {_grantRole}.
1088      */
1089     function _setupRole(bytes32 role, address account) internal virtual {
1090         _grantRole(role, account);
1091     }
1092 
1093     /**
1094      * @dev Sets `adminRole` as ``role``'s admin role.
1095      *
1096      * Emits a {RoleAdminChanged} event.
1097      */
1098     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1099         bytes32 previousAdminRole = getRoleAdmin(role);
1100         _roles[role].adminRole = adminRole;
1101         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1102     }
1103 
1104     /**
1105      * @dev Grants `role` to `account`.
1106      *
1107      * Internal function without access restriction.
1108      *
1109      * May emit a {RoleGranted} event.
1110      */
1111     function _grantRole(bytes32 role, address account) internal virtual {
1112         if (!hasRole(role, account)) {
1113             _roles[role].members[account] = true;
1114             emit RoleGranted(role, account, _msgSender());
1115         }
1116     }
1117 
1118     /**
1119      * @dev Revokes `role` from `account`.
1120      *
1121      * Internal function without access restriction.
1122      *
1123      * May emit a {RoleRevoked} event.
1124      */
1125     function _revokeRole(bytes32 role, address account) internal virtual {
1126         if (hasRole(role, account)) {
1127             _roles[role].members[account] = false;
1128             emit RoleRevoked(role, account, _msgSender());
1129         }
1130     }
1131 }
1132 
1133 
1134 contract ForTheDog is ERC20, ERC20Burnable, Pausable, AccessControl {
1135     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1136     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1137     bytes32 public constant LOCK_TRANSFER_ROLE = keccak256("LOCK_TRANSFER_ROLE");
1138 
1139     uint256 private _limitMint;
1140 
1141     mapping(address => bool) internal _fullLockList;
1142 
1143     constructor() ERC20("ForTheDog", "FTD") {
1144         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1145         _grantRole(PAUSER_ROLE, msg.sender);
1146         _mint(msg.sender, 16* 10 ** 8 * 10 ** decimals());
1147         _limitMint = 16* 10 ** 8 * 10 ** decimals();
1148         _grantRole(MINTER_ROLE, msg.sender);
1149         _grantRole(LOCK_TRANSFER_ROLE, msg.sender);
1150     }
1151 
1152     function pause() public onlyRole(PAUSER_ROLE) {
1153         _pause();
1154     }
1155 
1156     function unpause() public onlyRole(PAUSER_ROLE) {
1157         _unpause();
1158     }
1159 
1160     function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
1161         require(totalSupply() + amount <= _limitMint, "The number of additional issuance has been exceeded.");
1162         _mint(to, amount);
1163     }
1164 
1165     function fullLockAddress(address account) external onlyRole(LOCK_TRANSFER_ROLE) returns (bool) {
1166         _fullLockList[account] = true;
1167         return true;
1168     }
1169 
1170     function unFullLockAddress(address account) external onlyRole(LOCK_TRANSFER_ROLE) returns (bool) {
1171         delete _fullLockList[account];
1172         return true;
1173     }
1174 
1175     function fullLockedAddressList(address account) external view virtual returns (bool) {
1176         return _fullLockList[account];
1177     }
1178 
1179     function _beforeTokenTransfer(address from, address to, uint256 amount)
1180         internal
1181         whenNotPaused
1182         override
1183     {
1184         require(!_fullLockList[from], "Token transfer from LockedAddressList");
1185         super._beforeTokenTransfer(from, to, amount);
1186     }
1187 }