1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 /*
5 
6 */
7 
8 
9 
10 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16  */
17 interface IERC20 {
18     /**
19      * @dev Emitted when `value` tokens are moved from one account (`from`) to
20      * another (`to`).
21      *
22      * Note that `value` may be zero.
23      */
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     /**
27      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
28      * a call to {approve}. `value` is the new allowance.
29      */
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 
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
43      * @dev Moves `amount` tokens from the caller's account to `to`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address to, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `from` to `to` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address from,
87         address to,
88         uint256 amount
89     ) external returns (bool);
90 }
91 
92 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 
97 /**
98  * @dev Implementation of the {IERC20} interface.
99  *
100  * This implementation is agnostic to the way tokens are created. This means
101  * that a supply mechanism has to be added in a derived contract using {_mint}.
102  * For a generic mechanism see {ERC20PresetMinterPauser}.
103  *
104  * TIP: For a detailed writeup see our guide
105  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
106  * to implement supply mechanisms].
107  *
108  * We have followed general OpenZeppelin Contracts guidelines: functions revert
109  * instead returning `false` on failure. This behavior is nonetheless
110  * conventional and does not conflict with the expectations of ERC20
111  * applications.
112  *
113  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
114  * This allows applications to reconstruct the allowance for all accounts just
115  * by listening to said events. Other implementations of the EIP may not emit
116  * these events, as it isn't required by the specification.
117  *
118  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
119  * functions have been added to mitigate the well-known issues around setting
120  * allowances. See {IERC20-approve}.
121  */
122  // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 
127 
128 /**
129  * @dev Interface for the optional metadata functions from the ERC20 standard.
130  *
131  * _Available since v4.1._
132  */
133 interface IERC20Metadata is IERC20 {
134     /**
135      * @dev Returns the name of the token.
136      */
137     function name() external view returns (string memory);
138 
139     /**
140      * @dev Returns the symbol of the token.
141      */
142     function symbol() external view returns (string memory);
143 
144     /**
145      * @dev Returns the decimals places of the token.
146      */
147     function decimals() external view returns (uint8);
148 }
149 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Provides information about the current execution context, including the
155  * sender of the transaction and its data. While these are generally available
156  * via msg.sender and msg.data, they should not be accessed in such a direct
157  * manner, since when dealing with meta-transactions the account sending and
158  * paying for execution may not be the actual sender (as far as an application
159  * is concerned).
160  *
161  * This contract is only required for intermediate, library-like contracts.
162  */
163 abstract contract Context {
164     function _msgSender() internal view virtual returns (address) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view virtual returns (bytes calldata) {
169         return msg.data;
170     }
171 }
172 
173 contract ERC20 is Context, IERC20, IERC20Metadata {
174     mapping(address => uint256) private _balances;
175 
176     mapping(address => mapping(address => uint256)) private _allowances;
177 
178     uint256 private _totalSupply;
179 
180     string private _name;
181     string private _symbol;
182 
183     /**
184      * @dev Sets the values for {name} and {symbol}.
185      *
186      * The default value of {decimals} is 18. To select a different value for
187      * {decimals} you should overload it.
188      *
189      * All two of these values are immutable: they can only be set once during
190      * construction.
191      */
192     constructor(string memory name_, string memory symbol_) {
193         _name = name_;
194         _symbol = symbol_;
195     }
196 
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() public view virtual override returns (string memory) {
201         return _name;
202     }
203 
204     /**
205      * @dev Returns the symbol of the token, usually a shorter version of the
206      * name.
207      */
208     function symbol() public view virtual override returns (string memory) {
209         return _symbol;
210     }
211 
212     /**
213      * @dev Returns the number of decimals used to get its user representation.
214      * For example, if `decimals` equals `2`, a balance of `505` tokens should
215      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
216      *
217      * Tokens usually opt for a value of 18, imitating the relationship between
218      * Ether and Wei. This is the value {ERC20} uses, unless this function is
219      * overridden;
220      *
221      * NOTE: This information is only used for _display_ purposes: it in
222      * no way affects any of the arithmetic of the contract, including
223      * {IERC20-balanceOf} and {IERC20-transfer}.
224      */
225     function decimals() public view virtual override returns (uint8) {
226         return 18;
227     }
228 
229     /**
230      * @dev See {IERC20-totalSupply}.
231      */
232     function totalSupply() public view virtual override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev See {IERC20-balanceOf}.
238      */
239     function balanceOf(address account) public view virtual override returns (uint256) {
240         return _balances[account];
241     }
242 
243     /**
244      * @dev See {IERC20-transfer}.
245      *
246      * Requirements:
247      *
248      * - `to` cannot be the zero address.
249      * - the caller must have a balance of at least `amount`.
250      */
251     function transfer(address to, uint256 amount) public virtual override returns (bool) {
252         address owner = _msgSender();
253         _transfer(owner, to, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See {IERC20-allowance}.
259      */
260     function allowance(address owner, address spender) public view virtual override returns (uint256) {
261         return _allowances[owner][spender];
262     }
263 
264     /**
265      * @dev See {IERC20-approve}.
266      *
267      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
268      * `transferFrom`. This is semantically equivalent to an infinite approval.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         address owner = _msgSender();
276         _approve(owner, spender, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-transferFrom}.
282      *
283      * Emits an {Approval} event indicating the updated allowance. This is not
284      * required by the EIP. See the note at the beginning of {ERC20}.
285      *
286      * NOTE: Does not update the allowance if the current allowance
287      * is the maximum `uint256`.
288      *
289      * Requirements:
290      *
291      * - `from` and `to` cannot be the zero address.
292      * - `from` must have a balance of at least `amount`.
293      * - the caller must have allowance for ``from``'s tokens of at least
294      * `amount`.
295      */
296     function transferFrom(
297         address from,
298         address to,
299         uint256 amount
300     ) public virtual override returns (bool) {
301         address spender = _msgSender();
302         _spendAllowance(from, spender, amount);
303         _transfer(from, to, amount);
304         return true;
305     }
306 
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         address owner = _msgSender();
321         _approve(owner, spender, allowance(owner, spender) + addedValue);
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
340         address owner = _msgSender();
341         uint256 currentAllowance = allowance(owner, spender);
342         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
343         unchecked {
344             _approve(owner, spender, currentAllowance - subtractedValue);
345         }
346 
347         return true;
348     }
349 
350     /**
351      * @dev Moves `amount` of tokens from `from` to `to`.
352      *
353      * This internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `from` cannot be the zero address.
361      * - `to` cannot be the zero address.
362      * - `from` must have a balance of at least `amount`.
363      */
364     function _transfer(
365         address from,
366         address to,
367         uint256 amount
368     ) internal virtual {
369         require(from != address(0), "ERC20: transfer from the zero address");
370         require(to != address(0), "ERC20: transfer to the zero address");
371 
372         _beforeTokenTransfer(from, to, amount);
373 
374         uint256 fromBalance = _balances[from];
375         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
376         unchecked {
377             _balances[from] = fromBalance - amount;
378         }
379         _balances[to] += amount;
380 
381         emit Transfer(from, to, amount);
382 
383         _afterTokenTransfer(from, to, amount);
384     }
385 
386     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
387      * the total supply.
388      *
389      * Emits a {Transfer} event with `from` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      */
395     function _mint(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: mint to the zero address");
397 
398         _beforeTokenTransfer(address(0), account, amount);
399 
400         _totalSupply += amount;
401         _balances[account] += amount;
402         emit Transfer(address(0), account, amount);
403 
404         _afterTokenTransfer(address(0), account, amount);
405     }
406 
407     /**
408      * @dev Destroys `amount` tokens from `account`, reducing the
409      * total supply.
410      *
411      * Emits a {Transfer} event with `to` set to the zero address.
412      *
413      * Requirements:
414      *
415      * - `account` cannot be the zero address.
416      * - `account` must have at least `amount` tokens.
417      */
418     function _burn(address account, uint256 amount) internal virtual {
419         require(account != address(0), "ERC20: burn from the zero address");
420 
421         _beforeTokenTransfer(account, address(0), amount);
422 
423         uint256 accountBalance = _balances[account];
424         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
425         unchecked {
426             _balances[account] = accountBalance - amount;
427         }
428         _totalSupply -= amount;
429 
430         emit Transfer(account, address(0), amount);
431 
432         _afterTokenTransfer(account, address(0), amount);
433     }
434 
435     /**
436      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
437      *
438      * This internal function is equivalent to `approve`, and can be used to
439      * e.g. set automatic allowances for certain subsystems, etc.
440      *
441      * Emits an {Approval} event.
442      *
443      * Requirements:
444      *
445      * - `owner` cannot be the zero address.
446      * - `spender` cannot be the zero address.
447      */
448     function _approve(
449         address owner,
450         address spender,
451         uint256 amount
452     ) internal virtual {
453         require(owner != address(0), "ERC20: approve from the zero address");
454         require(spender != address(0), "ERC20: approve to the zero address");
455 
456         _allowances[owner][spender] = amount;
457         emit Approval(owner, spender, amount);
458     }
459 
460     /**
461      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
462      *
463      * Does not update the allowance amount in case of infinite allowance.
464      * Revert if not enough allowance is available.
465      *
466      * Might emit an {Approval} event.
467      */
468     function _spendAllowance(
469         address owner,
470         address spender,
471         uint256 amount
472     ) internal virtual {
473         uint256 currentAllowance = allowance(owner, spender);
474         if (currentAllowance != type(uint256).max) {
475             require(currentAllowance >= amount, "ERC20: insufficient allowance");
476             unchecked {
477                 _approve(owner, spender, currentAllowance - amount);
478             }
479         }
480     }
481 
482     /**
483      * @dev Hook that is called before any transfer of tokens. This includes
484      * minting and burning.
485      *
486      * Calling conditions:
487      *
488      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
489      * will be transferred to `to`.
490      * - when `from` is zero, `amount` tokens will be minted for `to`.
491      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
492      * - `from` and `to` are never both zero.
493      *
494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
495      */
496     function _beforeTokenTransfer(
497         address from,
498         address to,
499         uint256 amount
500     ) internal virtual {}
501 
502     /**
503      * @dev Hook that is called after any transfer of tokens. This includes
504      * minting and burning.
505      *
506      * Calling conditions:
507      *
508      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
509      * has been transferred to `to`.
510      * - when `from` is zero, `amount` tokens have been minted for `to`.
511      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
512      * - `from` and `to` are never both zero.
513      *
514      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
515      */
516     function _afterTokenTransfer(
517         address from,
518         address to,
519         uint256 amount
520     ) internal virtual {}
521 }
522 
523 
524 
525 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev Extension of {ERC20} that allows token holders to destroy both their own
532  * tokens and those that they have an allowance for, in a way that can be
533  * recognized off-chain (via event analysis).
534  */
535 abstract contract ERC20Burnable is Context, ERC20 {
536     /**
537      * @dev Destroys `amount` tokens from the caller.
538      *
539      * See {ERC20-_burn}.
540      */
541     function burn(uint256 amount) public virtual {
542         _burn(_msgSender(), amount);
543     }
544 
545     /**
546      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
547      * allowance.
548      *
549      * See {ERC20-_burn} and {ERC20-allowance}.
550      *
551      * Requirements:
552      *
553      * - the caller must have allowance for ``accounts``'s tokens of at least
554      * `amount`.
555      */
556     function burnFrom(address account, uint256 amount) public virtual {
557         _spendAllowance(account, _msgSender(), amount);
558         _burn(account, amount);
559     }
560 }
561 
562 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 
568 /**
569  * @dev Contract module which provides a basic access control mechanism, where
570  * there is an account (an owner) that can be granted exclusive access to
571  * specific functions.
572  *
573  * By default, the owner account will be the one that deploys the contract. This
574  * can later be changed with {transferOwnership}.
575  *
576  * This module is used through inheritance. It will make available the modifier
577  * `onlyOwner`, which can be applied to your functions to restrict their use to
578  * the owner.
579  */
580 abstract contract Ownable is Context {
581     address private _owner;
582 
583     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
584 
585     /**
586      * @dev Initializes the contract setting the deployer as the initial owner.
587      */
588     constructor() {
589         _transferOwnership(_msgSender());
590     }
591 
592     /**
593      * @dev Throws if called by any account other than the owner.
594      */
595     modifier onlyOwner() {
596         _checkOwner();
597         _;
598     }
599 
600     /**
601      * @dev Returns the address of the current owner.
602      */
603     function owner() public view virtual returns (address) {
604         return _owner;
605     }
606 
607     /**
608      * @dev Throws if the sender is not the owner.
609      */
610     function _checkOwner() internal view virtual {
611         require(owner() == _msgSender(), "Ownable: caller is not the owner");
612     }
613 
614     /**
615      * @dev Leaves the contract without owner. It will not be possible to call
616      * `onlyOwner` functions anymore. Can only be called by the current owner.
617      *
618      * NOTE: Renouncing ownership will leave the contract without an owner,
619      * thereby removing any functionality that is only available to the owner.
620      */
621     function renounceOwnership() public virtual onlyOwner {
622         _transferOwnership(address(0));
623     }
624 
625     /**
626      * @dev Transfers ownership of the contract to a new account (`newOwner`).
627      * Can only be called by the current owner.
628      */
629     function transferOwnership(address newOwner) public virtual onlyOwner {
630         require(newOwner != address(0), "Ownable: new owner is the zero address");
631         _transferOwnership(newOwner);
632     }
633 
634     /**
635      * @dev Transfers ownership of the contract to a new account (`newOwner`).
636      * Internal function without access restriction.
637      */
638     function _transferOwnership(address newOwner) internal virtual {
639         address oldOwner = _owner;
640         _owner = newOwner;
641         emit OwnershipTransferred(oldOwner, newOwner);
642     }
643 }
644 
645 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 /**
650  * @dev Interface of the ERC165 standard, as defined in the
651  * https://eips.ethereum.org/EIPS/eip-165[EIP].
652  *
653  * Implementers can declare support of contract interfaces, which can then be
654  * queried by others ({ERC165Checker}).
655  *
656  * For an implementation, see {ERC165}.
657  */
658 interface IERC165 {
659     /**
660      * @dev Returns true if this contract implements the interface defined by
661      * `interfaceId`. See the corresponding
662      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
663      * to learn more about how these ids are created.
664      *
665      * This function call must use less than 30 000 gas.
666      */
667     function supportsInterface(bytes4 interfaceId) external view returns (bool);
668 }
669 
670 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 
675 /**
676  * @dev Required interface of an ERC721 compliant contract.
677  */
678 interface IERC721 is IERC165 {
679     /**
680      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
681      */
682     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
683 
684     /**
685      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
686      */
687     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
688 
689     /**
690      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
691      */
692     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
693 
694     /**
695      * @dev Returns the number of tokens in ``owner``'s account.
696      */
697     function balanceOf(address owner) external view returns (uint256 balance);
698 
699     /**
700      * @dev Returns the owner of the `tokenId` token.
701      *
702      * Requirements:
703      *
704      * - `tokenId` must exist.
705      */
706     function ownerOf(uint256 tokenId) external view returns (address owner);
707 
708     /**
709      * @dev Safely transfers `tokenId` token from `from` to `to`.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must exist and be owned by `from`.
716      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
718      *
719      * Emits a {Transfer} event.
720      */
721     function safeTransferFrom(
722         address from,
723         address to,
724         uint256 tokenId,
725         bytes calldata data
726     ) external;
727 
728     /**
729      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
730      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
731      *
732      * Requirements:
733      *
734      * - `from` cannot be the zero address.
735      * - `to` cannot be the zero address.
736      * - `tokenId` token must exist and be owned by `from`.
737      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
738      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
739      *
740      * Emits a {Transfer} event.
741      */
742     function safeTransferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) external;
747 
748     /**
749      * @dev Transfers `tokenId` token from `from` to `to`.
750      *
751      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
752      *
753      * Requirements:
754      *
755      * - `from` cannot be the zero address.
756      * - `to` cannot be the zero address.
757      * - `tokenId` token must be owned by `from`.
758      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
759      *
760      * Emits a {Transfer} event.
761      */
762     function transferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) external;
767 
768     /**
769      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
770      * The approval is cleared when the token is transferred.
771      *
772      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
773      *
774      * Requirements:
775      *
776      * - The caller must own the token or be an approved operator.
777      * - `tokenId` must exist.
778      *
779      * Emits an {Approval} event.
780      */
781     function approve(address to, uint256 tokenId) external;
782 
783     /**
784      * @dev Approve or remove `operator` as an operator for the caller.
785      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
786      *
787      * Requirements:
788      *
789      * - The `operator` cannot be the caller.
790      *
791      * Emits an {ApprovalForAll} event.
792      */
793     function setApprovalForAll(address operator, bool _approved) external;
794 
795     /**
796      * @dev Returns the account approved for `tokenId` token.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      */
802     function getApproved(uint256 tokenId) external view returns (address operator);
803 
804     /**
805      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
806      *
807      * See {setApprovalForAll}
808      */
809     function isApprovedForAll(address owner, address operator) external view returns (bool);
810 }
811 
812 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
813 
814 pragma solidity ^0.8.0;
815 
816 
817 /**
818  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
819  * @dev See https://eips.ethereum.org/EIPS/eip-721
820  */
821 interface IERC721Enumerable is IERC721 {
822     /**
823      * @dev Returns the total amount of tokens stored by the contract.
824      */
825     function totalSupply() external view returns (uint256);
826 
827     /**
828      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
829      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
830      */
831     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
832 
833     /**
834      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
835      * Use along with {totalSupply} to enumerate all tokens.
836      */
837     function tokenByIndex(uint256 index) external view returns (uint256);
838 }
839 
840 /*
841                     __________   _____     ______       ____     __________
842                    |___    ___| |     \   |   ___|     /    \   |___    ___|
843                        |  |     |  |_| |  |  |___     /  /\  \      |  |
844                        |  |     |     <   |   ___|   /  ___   \     |  | 
845                        |  |     |  |\  \  |  |___   /  /    \  \    |  |
846                        |__|     |__| \__\ |______| /__/      \__\   |__|
847 
848        _______   __________     ____        __    __    __________   ______   __      ______
849      /  ______/ |___    ___|   /    \      |   | /  /  |___    ___| |      \ |  |   /   __   \
850     |  /            |  |      /  /\  \     |   |/  /       |  |     |   __  \|  |  /  /    \__|
851     |  \___         |  |     /  ___   \    |      <        |  |     |  |  \     | |  |     ____
852      \_____  \      |  |    /  /    \  \   |   _   \       |  |     |  |   \    | |  |    |    |
853     _______|  |     |  |   /  /      \  \  |  | \   \   ___|  |___  |  |    \   |  \  \ __ /  /
854     \________/      |__|  /__/        \__\ |__|   \__\ |__________| |__|     \__|   \ ______ /
855 
856 
857 
858                             Contract provided By B.A.S.S Studios 
859                             (Blockchain and Software Solutions)
860 */
861 
862 pragma solidity ^0.8.7;
863 
864 //Tasties NFT Staking 
865 
866 interface INFTContract {
867     function balanceOf(address _user) external view returns (uint256);
868   
869 }
870 
871 contract stakingTastiesNFT is ERC20Burnable, Ownable {
872 
873     uint256 public constant NFT_BASE_RATE = 10000000000000000000; // 10 per Day
874     address public constant NFT_ADDRESS = 0xd4d1f32c280056f107AD4ADf8e16BC02f2C5B339;//TastiesNFT Collection
875 
876     bool public stakingLive = false;
877     bool public airdropToAll=true;
878     bool public returnLock=false;
879 
880     mapping(uint256 => uint256) internal NftTokenIdTimeStaked;
881     mapping(uint256 => address) internal NftTokenIdToStaker;
882     mapping(address => uint256[]) internal stakerToNftTokenIds;
883     //map token id to bool for if staked //fb
884     mapping(uint256=>bool) public nftStaked;
885 
886     //trait type mapping token id to traid type   //fb
887     //Trait types 1,2,3,4,5,6
888     mapping(uint256 => uint256) private _traitType;
889 
890     //uint type multipliers to implement different payouts for different trait rarities (value must be 10x percentage desired)
891     uint256 type1Multiplier=10;
892     uint256 type2Multiplier=12;
893     uint256 type3Multiplier=14;
894     uint256 type4Multiplier=20;
895     uint256 type5Multiplier=30;
896     uint256 type6Multiplier=200;
897     
898     IERC721Enumerable private constant _NftIERC721 = IERC721Enumerable(NFT_ADDRESS);
899 
900 
901     constructor() ERC20("Treat Token", "TREAT") {
902     }
903 
904     function getTokenIDsStaked(address staker) public view returns (uint256[] memory) {
905         return stakerToNftTokenIds[staker];
906     }
907     
908     function getStakedCount(address staker) public view returns (uint256) {
909         return stakerToNftTokenIds[staker].length;
910     }
911 
912     function removeSpecificTokenIdFromArray(uint256[] storage array, uint256 tokenId) internal {
913         uint256 length = array.length;
914         for (uint256 i = 0; i < length; i++) {
915             if (array[i] == tokenId) {
916                 length--;
917                 if (i < length) {
918                     array[i] = array[length];
919                 }
920                 array.pop();
921                 break;
922             }
923         }
924     }
925 // covers single staking and multiple
926     function stakeNftsByTokenIds(uint256[] memory tokenIds) public  {
927      require(stakingLive, "STAKING NOT LIVE");
928 
929         for (uint256 i = 0; i < tokenIds.length; i++) {
930             uint256 id = tokenIds[i];
931             require(_NftIERC721.ownerOf(id) == msg.sender && NftTokenIdToStaker[id] == address(0), "TOKEN NOT YOURS");
932             //NFT transfer 
933             _NftIERC721.transferFrom(msg.sender, address(this), id);
934             //Track data
935             stakerToNftTokenIds[msg.sender].push(id);
936             NftTokenIdTimeStaked[id] = block.timestamp;
937             NftTokenIdToStaker[id] = msg.sender;
938             nftStaked[id]=true;
939         }
940        
941     }
942 // unstake and claims for tokens
943 
944     function unstakeAll() public {
945         require(getStakedCount(msg.sender) > 0, "Need at least 1 staked to unstake");
946         uint256 totalRewards = 0;
947 
948         for (uint256 i = stakerToNftTokenIds[msg.sender].length; i > 0; i--) {
949             uint256 tokenId = stakerToNftTokenIds[msg.sender][i - 1];
950 
951             _NftIERC721.transferFrom(address(this), msg.sender, tokenId);
952             //add calculated value of the token id by its type //fb
953             totalRewards += calculateRewardsByTokenId(tokenId);
954             //pop used to save more gas and counting from end of the stored ids to index 0 //fb
955             stakerToNftTokenIds[msg.sender].pop();
956             NftTokenIdToStaker[tokenId] = address(0);
957             nftStaked[tokenId]=false;
958             //after gathering total rewards set token token id time staked to 0 //fb
959             NftTokenIdTimeStaked[tokenId] = 0;
960         }
961         _mint(msg.sender, totalRewards);
962     }
963 
964     function unstakeNftsByTokenIds(uint256[] memory tokenIds) public {
965         uint256 totalRewards = 0;
966 
967         for (uint256 i = 0; i < tokenIds.length; i++) {
968             uint256 id = tokenIds[i];
969             require(NftTokenIdToStaker[id] == msg.sender, "NOT the staker");
970 
971             _NftIERC721.transferFrom(address(this), msg.sender, id);
972              //add calculated value of the token id by its type //fb
973             totalRewards += calculateRewardsByTokenId(id);
974             //remove specific id from stored ids (less gas efficient than unstake all   //fb
975             removeSpecificTokenIdFromArray(stakerToNftTokenIds[msg.sender], id);
976             NftTokenIdToStaker[id] = address(0);
977              nftStaked[id]=false;
978              //after gathering total rewards set token id time staked to 0 //fb
979             NftTokenIdTimeStaked[id] = 0;
980         }
981 
982         _mint(msg.sender, totalRewards);
983       
984     }
985     
986 
987     function claimTokensByTokenId(uint256 tokenId) public {
988         require(NftTokenIdToStaker[tokenId] == msg.sender, "NOT the staker");
989           //add calculated value of the token id by its type //fb
990         _mint(msg.sender, (calculateRewardsByTokenId(tokenId)));
991         NftTokenIdTimeStaked[tokenId] = block.timestamp;
992     }
993     
994    
995     function claimAllTokens() public {
996         uint256 totalRewards = 0;
997 
998         uint256[] memory TokenIds = stakerToNftTokenIds[msg.sender];
999         for (uint256 i = 0; i < TokenIds.length; i++) {
1000             uint256 id = TokenIds[i];
1001             require(NftTokenIdToStaker[id] == msg.sender, "NOT_STAKED_BY_YOU");
1002              //add calculated value of the token id by its type //fb
1003             totalRewards += calculateRewardsByTokenId(id);
1004             NftTokenIdTimeStaked[id] = block.timestamp;
1005         }
1006         
1007         
1008         _mint(msg.sender, totalRewards);
1009     }
1010 //returning the total reward payout per address
1011     function getAllRewards(address staker) public view returns (uint256) {
1012         uint256 totalRewards = 0;
1013         uint256[] memory tokenIds = stakerToNftTokenIds[staker];
1014         for (uint256 i = 0; i < tokenIds.length; i++) {
1015              //add calculated value of the token id by its type //fb
1016             totalRewards += (calculateRewardsByTokenId(tokenIds[i]));
1017         } 
1018       
1019 
1020         return totalRewards;
1021     }
1022 
1023     function getRewardsByNftTokenId(uint256 tokenId) public view returns (uint256) {
1024         require(NftTokenIdToStaker[tokenId] != address(0), "TOKEN_NOT_STAKED");
1025 
1026           //add calculated value of the token id by its type //fb
1027         return calculateRewardsByTokenId(tokenId);
1028     }
1029     
1030 
1031     function getNftStaker(uint256 tokenId) public view returns (address) {
1032         return NftTokenIdToStaker[tokenId];
1033     }
1034     
1035     //return public is token id staked in contract
1036     function isStaked(uint256 tokenId) public view returns (bool) {
1037         return(nftStaked[tokenId]);
1038     }
1039 
1040     function toggle() external onlyOwner {
1041         stakingLive = !stakingLive;
1042     }
1043 
1044   //trait rarity list fuctions
1045   //set single token id type for multiplier fixes or possible future rewarding of specific tokens
1046   function setTypeList(uint256 tokenIdTemp, uint256 typeNumber) external onlyOwner {
1047        
1048             _traitType[tokenIdTemp] = typeNumber;
1049            
1050     }
1051   //set a full tokenId to type list can only map to one type at a time (maps all in list to the same trait number)
1052   function setFullTypeList(uint[] calldata idList, uint256 traitNum) external onlyOwner {
1053     for (uint256 i = 0; i < idList.length; i++) {
1054         _traitType[idList[i]] = traitNum;
1055     
1056     }
1057     
1058  }
1059 //reward calculation multiplier applied before reaking down to a a daily value
1060   function calculateRewardsByTokenId(uint256 givenId) public view returns (uint256 _rewards){
1061 
1062        uint256 totalRewards = 0; 
1063        uint256 tempRewards=(block.timestamp -NftTokenIdTimeStaked[givenId]);
1064             if(_traitType[givenId]==1){
1065                 tempRewards = (tempRewards* type1Multiplier)/10;
1066             }
1067              if(_traitType[givenId]==2){
1068                 tempRewards = (tempRewards* type2Multiplier)/10;
1069             }
1070              if(_traitType[givenId]==3){
1071                 tempRewards = (tempRewards* type3Multiplier)/10;
1072             }
1073              if(_traitType[givenId]==4){
1074                 tempRewards = (tempRewards* type4Multiplier)/10;
1075             }
1076              if(_traitType[givenId]==5){
1077                 tempRewards = (tempRewards* type5Multiplier)/10;
1078             }
1079                 if(_traitType[givenId]==6){
1080                 tempRewards = (tempRewards* type6Multiplier)/10;
1081             }
1082       totalRewards += ((tempRewards* NFT_BASE_RATE/86400));
1083       return(totalRewards);
1084 
1085   }
1086 //return the trait type of the token id (returned value must be divided by 10 with 1 decimal place to get correct value)
1087  function getTypeByTokenId(uint256 givenId) public view returns (uint256 _rewards){
1088 
1089             if(_traitType[givenId]==1){
1090                return type1Multiplier;
1091             }
1092              if(_traitType[givenId]==2){
1093                 return type2Multiplier;
1094             }
1095              if(_traitType[givenId]==3){
1096                return type3Multiplier;
1097             }
1098              if(_traitType[givenId]==4){
1099                return type4Multiplier;
1100             }
1101              if(_traitType[givenId]==5){
1102                 return type5Multiplier;
1103             }
1104                 if(_traitType[givenId]==6){
1105                 return type6Multiplier;
1106             }
1107 
1108   }
1109 //type multipliers access functions
1110     function setType1Multiplier(uint256 _newMultiplier) external onlyOwner{
1111         type1Multiplier=_newMultiplier;
1112     }
1113         function setType2Multiplier(uint256 _newMultiplier) external onlyOwner{
1114         type2Multiplier=_newMultiplier;
1115     }
1116         function setType3Multiplier(uint256 _newMultiplier) external onlyOwner{
1117         type3Multiplier=_newMultiplier;
1118     }
1119         function setType4Multiplier(uint256 _newMultiplier) external onlyOwner{
1120         type4Multiplier=_newMultiplier;
1121     }
1122         function setType5Multiplier(uint256 _newMultiplier) external onlyOwner{
1123         type5Multiplier=_newMultiplier;
1124     }
1125         function setType6Multiplier(uint256 _newMultiplier) external onlyOwner{
1126         type6Multiplier=_newMultiplier;
1127     }
1128 
1129 //Return All Staked (emergency use to return all holders assets) use of this function may require redeployment
1130 //NOTE this function does not remove token ids from the stakers array of staked tokens
1131 //NOTE block time stamp is also not reset
1132 //NOTE token id staker address not reset to address 0
1133 //NOTE nft staked bool not reset to false
1134     function ReturnAllStakedNFTs() external payable onlyOwner{
1135     require(returnLock==true,"lock is on");
1136     uint256 currSupply=_NftIERC721.totalSupply();
1137         for(uint256 i=0;i<currSupply;i++){
1138             if(nftStaked[i]==true){
1139                  address sendAddress= NftTokenIdToStaker[i];
1140                 _NftIERC721.transferFrom(address(this), sendAddress, i);
1141           
1142             }
1143         }
1144     }
1145 
1146 //return lock change
1147     function returnLockToggle() public onlyOwner{
1148         returnLock=!returnLock;
1149     }
1150 //only owner mint 
1151  function MintTokensOwner(address[] memory holders, uint256 amount) public onlyOwner {
1152   
1153         uint256 totalRewards=amount;
1154         for(uint256 i=0;i<holders.length;i++){
1155          _mint(holders[i], totalRewards);
1156 
1157         }
1158     }
1159 
1160 //airdrop toggle
1161     function airdropToggle(bool choice)public onlyOwner{
1162         airdropToAll=choice;
1163     }
1164 //airdrop to all holders
1165     function AirdropToHolders(uint256 tokenAmount) public payable onlyOwner{
1166         uint256 totalAmount= _NftIERC721.totalSupply();
1167         if(airdropToAll==true){
1168         for(uint256 j=0;j<totalAmount;j++){
1169             address ownerCurr =_NftIERC721.ownerOf(j);
1170             _mint(ownerCurr,tokenAmount);
1171         }
1172         }
1173         //airdrop to staked holders only
1174         if(airdropToAll==false){
1175         for(uint256 k=0; k<totalAmount;k++){
1176             if(nftStaked[k]==true){
1177                 address ownerCurrent =_NftIERC721.ownerOf(k);
1178                 _mint(ownerCurrent,tokenAmount);
1179             }
1180         }
1181         }
1182     }
1183 
1184 
1185 
1186 }