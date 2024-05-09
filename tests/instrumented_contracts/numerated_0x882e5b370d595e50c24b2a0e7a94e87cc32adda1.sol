1 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
87 
88 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
116 
117 
118 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
143 
144 
145 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 
150 
151 
152 /**
153  * @dev Implementation of the {IERC20} interface.
154  *
155  * This implementation is agnostic to the way tokens are created. This means
156  * that a supply mechanism has to be added in a derived contract using {_mint}.
157  * For a generic mechanism see {ERC20PresetMinterPauser}.
158  *
159  * TIP: For a detailed writeup see our guide
160  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
161  * to implement supply mechanisms].
162  *
163  * We have followed general OpenZeppelin Contracts guidelines: functions revert
164  * instead returning `false` on failure. This behavior is nonetheless
165  * conventional and does not conflict with the expectations of ERC20
166  * applications.
167  *
168  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
169  * This allows applications to reconstruct the allowance for all accounts just
170  * by listening to said events. Other implementations of the EIP may not emit
171  * these events, as it isn't required by the specification.
172  *
173  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
174  * functions have been added to mitigate the well-known issues around setting
175  * allowances. See {IERC20-approve}.
176  */
177 contract ERC20 is Context, IERC20, IERC20Metadata {
178     mapping(address => uint256) private _balances;
179 
180     mapping(address => mapping(address => uint256)) private _allowances;
181 
182     uint256 private _totalSupply;
183 
184     string private _name;
185     string private _symbol;
186 
187     /**
188      * @dev Sets the values for {name} and {symbol}.
189      *
190      * The default value of {decimals} is 18. To select a different value for
191      * {decimals} you should overload it.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200 
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207 
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215 
216     /**
217      * @dev Returns the number of decimals used to get its user representation.
218      * For example, if `decimals` equals `2`, a balance of `505` tokens should
219      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
220      *
221      * Tokens usually opt for a value of 18, imitating the relationship between
222      * Ether and Wei. This is the value {ERC20} uses, unless this function is
223      * overridden;
224      *
225      * NOTE: This information is only used for _display_ purposes: it in
226      * no way affects any of the arithmetic of the contract, including
227      * {IERC20-balanceOf} and {IERC20-transfer}.
228      */
229     function decimals() public view virtual override returns (uint8) {
230         return 18;
231     }
232 
233     /**
234      * @dev See {IERC20-totalSupply}.
235      */
236     function totalSupply() public view virtual override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241      * @dev See {IERC20-balanceOf}.
242      */
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     /**
248      * @dev See {IERC20-transfer}.
249      *
250      * Requirements:
251      *
252      * - `recipient` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     /**
280      * @dev See {IERC20-transferFrom}.
281      *
282      * Emits an {Approval} event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of {ERC20}.
284      *
285      * Requirements:
286      *
287      * - `sender` and `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      * - the caller must have allowance for ``sender``'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public virtual override returns (bool) {
297         _transfer(sender, recipient, amount);
298 
299         uint256 currentAllowance = _allowances[sender][_msgSender()];
300         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
301         unchecked {
302             _approve(sender, _msgSender(), currentAllowance - amount);
303         }
304 
305         return true;
306     }
307 
308     /**
309      * @dev Atomically increases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         uint256 currentAllowance = _allowances[_msgSender()][spender];
341         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
342         unchecked {
343             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
344         }
345 
346         return true;
347     }
348 
349     /**
350      * @dev Moves `amount` of tokens from `sender` to `recipient`.
351      *
352      * This internal function is equivalent to {transfer}, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a {Transfer} event.
356      *
357      * Requirements:
358      *
359      * - `sender` cannot be the zero address.
360      * - `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      */
363     function _transfer(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) internal virtual {
368         require(sender != address(0), "ERC20: transfer from the zero address");
369         require(recipient != address(0), "ERC20: transfer to the zero address");
370 
371         _beforeTokenTransfer(sender, recipient, amount);
372 
373         uint256 senderBalance = _balances[sender];
374         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
375         unchecked {
376             _balances[sender] = senderBalance - amount;
377         }
378         _balances[recipient] += amount;
379 
380         emit Transfer(sender, recipient, amount);
381 
382         _afterTokenTransfer(sender, recipient, amount);
383     }
384 
385     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
386      * the total supply.
387      *
388      * Emits a {Transfer} event with `from` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      */
394     function _mint(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: mint to the zero address");
396 
397         _beforeTokenTransfer(address(0), account, amount);
398 
399         _totalSupply += amount;
400         _balances[account] += amount;
401         emit Transfer(address(0), account, amount);
402 
403         _afterTokenTransfer(address(0), account, amount);
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
422         uint256 accountBalance = _balances[account];
423         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
424         unchecked {
425             _balances[account] = accountBalance - amount;
426         }
427         _totalSupply -= amount;
428 
429         emit Transfer(account, address(0), amount);
430 
431         _afterTokenTransfer(account, address(0), amount);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(
448         address owner,
449         address spender,
450         uint256 amount
451     ) internal virtual {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454 
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458 
459     /**
460      * @dev Hook that is called before any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * will be transferred to `to`.
467      * - when `from` is zero, `amount` tokens will be minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _beforeTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 
479     /**
480      * @dev Hook that is called after any transfer of tokens. This includes
481      * minting and burning.
482      *
483      * Calling conditions:
484      *
485      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
486      * has been transferred to `to`.
487      * - when `from` is zero, `amount` tokens have been minted for `to`.
488      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
489      * - `from` and `to` are never both zero.
490      *
491      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
492      */
493     function _afterTokenTransfer(
494         address from,
495         address to,
496         uint256 amount
497     ) internal virtual {}
498 }
499 
500 // File: @openzeppelin\contracts\access\Ownable.sol
501 
502 
503 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @dev Contract module which provides a basic access control mechanism, where
510  * there is an account (an owner) that can be granted exclusive access to
511  * specific functions.
512  *
513  * By default, the owner account will be the one that deploys the contract. This
514  * can later be changed with {transferOwnership}.
515  *
516  * This module is used through inheritance. It will make available the modifier
517  * `onlyOwner`, which can be applied to your functions to restrict their use to
518  * the owner.
519  */
520 abstract contract Ownable is Context {
521     address private _owner;
522 
523     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
524 
525     /**
526      * @dev Initializes the contract setting the deployer as the initial owner.
527      */
528     constructor() {
529         _transferOwnership(_msgSender());
530     }
531 
532     /**
533      * @dev Returns the address of the current owner.
534      */
535     function owner() public view virtual returns (address) {
536         return _owner;
537     }
538 
539     /**
540      * @dev Throws if called by any account other than the owner.
541      */
542     modifier onlyOwner() {
543         require(owner() == _msgSender(), "Ownable: caller is not the owner");
544         _;
545     }
546 
547     /**
548      * @dev Leaves the contract without owner. It will not be possible to call
549      * `onlyOwner` functions anymore. Can only be called by the current owner.
550      *
551      * NOTE: Renouncing ownership will leave the contract without an owner,
552      * thereby removing any functionality that is only available to the owner.
553      */
554     function renounceOwnership() public virtual onlyOwner {
555         _transferOwnership(address(0));
556     }
557 
558     /**
559      * @dev Transfers ownership of the contract to a new account (`newOwner`).
560      * Can only be called by the current owner.
561      */
562     function transferOwnership(address newOwner) public virtual onlyOwner {
563         require(newOwner != address(0), "Ownable: new owner is the zero address");
564         _transferOwnership(newOwner);
565     }
566 
567     /**
568      * @dev Transfers ownership of the contract to a new account (`newOwner`).
569      * Internal function without access restriction.
570      */
571     function _transferOwnership(address newOwner) internal virtual {
572         address oldOwner = _owner;
573         _owner = newOwner;
574         emit OwnershipTransferred(oldOwner, newOwner);
575     }
576 }
577 
578 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @dev Interface of the ERC165 standard, as defined in the
587  * https://eips.ethereum.org/EIPS/eip-165[EIP].
588  *
589  * Implementers can declare support of contract interfaces, which can then be
590  * queried by others ({ERC165Checker}).
591  *
592  * For an implementation, see {ERC165}.
593  */
594 interface IERC165 {
595     /**
596      * @dev Returns true if this contract implements the interface defined by
597      * `interfaceId`. See the corresponding
598      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
599      * to learn more about how these ids are created.
600      *
601      * This function call must use less than 30 000 gas.
602      */
603     function supportsInterface(bytes4 interfaceId) external view returns (bool);
604 }
605 
606 // File: @openzeppelin\contracts\token\ERC721\IERC721.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @dev Required interface of an ERC721 compliant contract.
616  */
617 interface IERC721 is IERC165 {
618     /**
619      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
620      */
621     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
622 
623     /**
624      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
625      */
626     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
627 
628     /**
629      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
630      */
631     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
632 
633     /**
634      * @dev Returns the number of tokens in ``owner``'s account.
635      */
636     function balanceOf(address owner) external view returns (uint256 balance);
637 
638     /**
639      * @dev Returns the owner of the `tokenId` token.
640      *
641      * Requirements:
642      *
643      * - `tokenId` must exist.
644      */
645     function ownerOf(uint256 tokenId) external view returns (address owner);
646 
647     /**
648      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
649      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
650      *
651      * Requirements:
652      *
653      * - `from` cannot be the zero address.
654      * - `to` cannot be the zero address.
655      * - `tokenId` token must exist and be owned by `from`.
656      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
657      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
658      *
659      * Emits a {Transfer} event.
660      */
661     function safeTransferFrom(
662         address from,
663         address to,
664         uint256 tokenId
665     ) external;
666 
667     /**
668      * @dev Transfers `tokenId` token from `from` to `to`.
669      *
670      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
671      *
672      * Requirements:
673      *
674      * - `from` cannot be the zero address.
675      * - `to` cannot be the zero address.
676      * - `tokenId` token must be owned by `from`.
677      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
678      *
679      * Emits a {Transfer} event.
680      */
681     function transferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) external;
686 
687     /**
688      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
689      * The approval is cleared when the token is transferred.
690      *
691      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
692      *
693      * Requirements:
694      *
695      * - The caller must own the token or be an approved operator.
696      * - `tokenId` must exist.
697      *
698      * Emits an {Approval} event.
699      */
700     function approve(address to, uint256 tokenId) external;
701 
702     /**
703      * @dev Returns the account approved for `tokenId` token.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must exist.
708      */
709     function getApproved(uint256 tokenId) external view returns (address operator);
710 
711     /**
712      * @dev Approve or remove `operator` as an operator for the caller.
713      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
714      *
715      * Requirements:
716      *
717      * - The `operator` cannot be the caller.
718      *
719      * Emits an {ApprovalForAll} event.
720      */
721     function setApprovalForAll(address operator, bool _approved) external;
722 
723     /**
724      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
725      *
726      * See {setApprovalForAll}
727      */
728     function isApprovedForAll(address owner, address operator) external view returns (bool);
729 
730     /**
731      * @dev Safely transfers `tokenId` token from `from` to `to`.
732      *
733      * Requirements:
734      *
735      * - `from` cannot be the zero address.
736      * - `to` cannot be the zero address.
737      * - `tokenId` token must exist and be owned by `from`.
738      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
739      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
740      *
741      * Emits a {Transfer} event.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId,
747         bytes calldata data
748     ) external;
749 }
750 
751 // File: @openzeppelin\contracts\utils\math\SafeMath.sol
752 
753 
754 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
755 
756 pragma solidity ^0.8.0;
757 
758 // CAUTION
759 // This version of SafeMath should only be used with Solidity 0.8 or later,
760 // because it relies on the compiler's built in overflow checks.
761 
762 /**
763  * @dev Wrappers over Solidity's arithmetic operations.
764  *
765  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
766  * now has built in overflow checking.
767  */
768 library SafeMath {
769     /**
770      * @dev Returns the addition of two unsigned integers, with an overflow flag.
771      *
772      * _Available since v3.4._
773      */
774     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
775         unchecked {
776             uint256 c = a + b;
777             if (c < a) return (false, 0);
778             return (true, c);
779         }
780     }
781 
782     /**
783      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
784      *
785      * _Available since v3.4._
786      */
787     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
788         unchecked {
789             if (b > a) return (false, 0);
790             return (true, a - b);
791         }
792     }
793 
794     /**
795      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
796      *
797      * _Available since v3.4._
798      */
799     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
800         unchecked {
801             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
802             // benefit is lost if 'b' is also tested.
803             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
804             if (a == 0) return (true, 0);
805             uint256 c = a * b;
806             if (c / a != b) return (false, 0);
807             return (true, c);
808         }
809     }
810 
811     /**
812      * @dev Returns the division of two unsigned integers, with a division by zero flag.
813      *
814      * _Available since v3.4._
815      */
816     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
817         unchecked {
818             if (b == 0) return (false, 0);
819             return (true, a / b);
820         }
821     }
822 
823     /**
824      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
825      *
826      * _Available since v3.4._
827      */
828     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
829         unchecked {
830             if (b == 0) return (false, 0);
831             return (true, a % b);
832         }
833     }
834 
835     /**
836      * @dev Returns the addition of two unsigned integers, reverting on
837      * overflow.
838      *
839      * Counterpart to Solidity's `+` operator.
840      *
841      * Requirements:
842      *
843      * - Addition cannot overflow.
844      */
845     function add(uint256 a, uint256 b) internal pure returns (uint256) {
846         return a + b;
847     }
848 
849     /**
850      * @dev Returns the subtraction of two unsigned integers, reverting on
851      * overflow (when the result is negative).
852      *
853      * Counterpart to Solidity's `-` operator.
854      *
855      * Requirements:
856      *
857      * - Subtraction cannot overflow.
858      */
859     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
860         return a - b;
861     }
862 
863     /**
864      * @dev Returns the multiplication of two unsigned integers, reverting on
865      * overflow.
866      *
867      * Counterpart to Solidity's `*` operator.
868      *
869      * Requirements:
870      *
871      * - Multiplication cannot overflow.
872      */
873     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
874         return a * b;
875     }
876 
877     /**
878      * @dev Returns the integer division of two unsigned integers, reverting on
879      * division by zero. The result is rounded towards zero.
880      *
881      * Counterpart to Solidity's `/` operator.
882      *
883      * Requirements:
884      *
885      * - The divisor cannot be zero.
886      */
887     function div(uint256 a, uint256 b) internal pure returns (uint256) {
888         return a / b;
889     }
890 
891     /**
892      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
893      * reverting when dividing by zero.
894      *
895      * Counterpart to Solidity's `%` operator. This function uses a `revert`
896      * opcode (which leaves remaining gas untouched) while Solidity uses an
897      * invalid opcode to revert (consuming all remaining gas).
898      *
899      * Requirements:
900      *
901      * - The divisor cannot be zero.
902      */
903     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
904         return a % b;
905     }
906 
907     /**
908      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
909      * overflow (when the result is negative).
910      *
911      * CAUTION: This function is deprecated because it requires allocating memory for the error
912      * message unnecessarily. For custom revert reasons use {trySub}.
913      *
914      * Counterpart to Solidity's `-` operator.
915      *
916      * Requirements:
917      *
918      * - Subtraction cannot overflow.
919      */
920     function sub(
921         uint256 a,
922         uint256 b,
923         string memory errorMessage
924     ) internal pure returns (uint256) {
925         unchecked {
926             require(b <= a, errorMessage);
927             return a - b;
928         }
929     }
930 
931     /**
932      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
933      * division by zero. The result is rounded towards zero.
934      *
935      * Counterpart to Solidity's `/` operator. Note: this function uses a
936      * `revert` opcode (which leaves remaining gas untouched) while Solidity
937      * uses an invalid opcode to revert (consuming all remaining gas).
938      *
939      * Requirements:
940      *
941      * - The divisor cannot be zero.
942      */
943     function div(
944         uint256 a,
945         uint256 b,
946         string memory errorMessage
947     ) internal pure returns (uint256) {
948         unchecked {
949             require(b > 0, errorMessage);
950             return a / b;
951         }
952     }
953 
954     /**
955      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
956      * reverting with custom message when dividing by zero.
957      *
958      * CAUTION: This function is deprecated because it requires allocating memory for the error
959      * message unnecessarily. For custom revert reasons use {tryMod}.
960      *
961      * Counterpart to Solidity's `%` operator. This function uses a `revert`
962      * opcode (which leaves remaining gas untouched) while Solidity uses an
963      * invalid opcode to revert (consuming all remaining gas).
964      *
965      * Requirements:
966      *
967      * - The divisor cannot be zero.
968      */
969     function mod(
970         uint256 a,
971         uint256 b,
972         string memory errorMessage
973     ) internal pure returns (uint256) {
974         unchecked {
975             require(b > 0, errorMessage);
976             return a % b;
977         }
978     }
979 }
980 
981 // File: contracts\GameToken.sol
982 
983 
984 
985 pragma solidity ^0.8.0;
986 
987 
988 
989 
990 
991 contract Game is ERC20, Ownable {
992   using SafeMath for uint256;
993 
994   address public DEV_WALLET;
995   address public CONSOLE_STAKING;
996 
997   IERC721 public CONSOLE;
998 
999   uint256 public constant DAILY_DEV_EMISSION = 450 ether;
1000   uint256 public constant CLAIM_TIME = 1639497600; // 15/12/2021 00:00:00 UTC
1001   uint256 public constant SECINDAY = 86400;
1002   uint256 public lastDevClaim;
1003 
1004   mapping(uint256 => bool) public claimed; // mapping for state of initial reward for each console NFT
1005   
1006   event INITIAL_CLAIM(address indexed claimer, uint256 tokenId);
1007 
1008   constructor(
1009     address _dev_wallet,
1010     IERC721 _CONSOLE
1011   ) ERC20("Game", "Game") {
1012     DEV_WALLET = _dev_wallet;
1013     CONSOLE = _CONSOLE;
1014 
1015     lastDevClaim = block.timestamp;
1016   }
1017 
1018   function claim(uint256 _id) external{
1019     require(block.timestamp > CLAIM_TIME, 'not_yet');
1020     require(claimed[_id] == false, 'already_claimed');
1021     require(CONSOLE.ownerOf(_id) == msg.sender, 'only_console_owner');
1022 
1023     claimed[_id] = true;
1024     _mint(msg.sender, 10 ether);
1025 
1026     emit INITIAL_CLAIM(msg.sender, _id);
1027   }
1028 
1029   function claimDailyDev() external onlyOwner {
1030     uint256 delayed = block.timestamp.sub(lastDevClaim).div(SECINDAY);
1031 
1032     if (delayed > 0) {
1033       _mint(DEV_WALLET, DAILY_DEV_EMISSION.mul(delayed));
1034       lastDevClaim = lastDevClaim.add(SECINDAY.mul(delayed));
1035     }
1036   }
1037   
1038   function updateConsoleStaking(address _consoleStaking) external onlyOwner {
1039     CONSOLE_STAKING = _consoleStaking;
1040   }
1041 
1042   function mint(address _receiver, uint256 _amount) external{
1043     require(msg.sender == CONSOLE_STAKING, "only_staking_callable");
1044     _mint(_receiver, _amount);
1045   }
1046 
1047 }