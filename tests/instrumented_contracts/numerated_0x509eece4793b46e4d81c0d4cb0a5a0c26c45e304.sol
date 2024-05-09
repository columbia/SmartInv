1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
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
46     function transfer(address recipient, uint256 amount)
47         external
48         returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender)
58         external
59         view
60         returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(
106         address indexed owner,
107         address indexed spender,
108         uint256 value
109     );
110 }
111 
112 /**
113  * @dev Interface for the optional metadata functions from the ERC20 standard.
114  *
115  * _Available since v4.1._
116  */
117 interface IERC20Metadata is IERC20 {
118     /**
119      * @dev Returns the name of the token.
120      */
121     function name() external view returns (string memory);
122 
123     /**
124      * @dev Returns the symbol of the token.
125      */
126     function symbol() external view returns (string memory);
127 
128     /**
129      * @dev Returns the decimals places of the token.
130      */
131     function decimals() external view returns (uint8);
132 }
133 
134 /**
135  * @dev Implementation of the {IERC20} interface.
136  *
137  * This implementation is agnostic to the way tokens are created. This means
138  * that a supply mechanism has to be added in a derived contract using {_mint}.
139  * For a generic mechanism see {ERC20PresetMinterPauser}.
140  *
141  * TIP: For a detailed writeup see our guide
142  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
143  * to implement supply mechanisms].
144  *
145  * We have followed general OpenZeppelin Contracts guidelines: functions revert
146  * instead returning `false` on failure. This behavior is nonetheless
147  * conventional and does not conflict with the expectations of ERC20
148  * applications.
149  *
150  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
151  * This allows applications to reconstruct the allowance for all accounts just
152  * by listening to said events. Other implementations of the EIP may not emit
153  * these events, as it isn't required by the specification.
154  *
155  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
156  * functions have been added to mitigate the well-known issues around setting
157  * allowances. See {IERC20-approve}.
158  */
159 contract ERC20 is Context, IERC20, IERC20Metadata {
160     mapping(address => uint256) private _balances;
161 
162     mapping(address => mapping(address => uint256)) private _allowances;
163 
164     uint256 private _totalSupply;
165 
166     string private _name;
167     string private _symbol;
168 
169     /**
170      * @dev Sets the values for {name} and {symbol}.
171      *
172      * The default value of {decimals} is 18. To select a different value for
173      * {decimals} you should overload it.
174      *
175      * All two of these values are immutable: they can only be set once during
176      * construction.
177      */
178     constructor(string memory name_, string memory symbol_) {
179         _name = name_;
180         _symbol = symbol_;
181     }
182 
183     /**
184      * @dev Returns the name of the token.
185      */
186     function name() public view virtual override returns (string memory) {
187         return _name;
188     }
189 
190     /**
191      * @dev Returns the symbol of the token, usually a shorter version of the
192      * name.
193      */
194     function symbol() public view virtual override returns (string memory) {
195         return _symbol;
196     }
197 
198     /**
199      * @dev Returns the number of decimals used to get its user representation.
200      * For example, if `decimals` equals `2`, a balance of `505` tokens should
201      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
202      *
203      * Tokens usually opt for a value of 18, imitating the relationship between
204      * Ether and Wei. This is the value {ERC20} uses, unless this function is
205      * overridden;
206      *
207      * NOTE: This information is only used for _display_ purposes: it in
208      * no way affects any of the arithmetic of the contract, including
209      * {IERC20-balanceOf} and {IERC20-transfer}.
210      */
211     function decimals() public view virtual override returns (uint8) {
212         return 18;
213     }
214 
215     /**
216      * @dev See {IERC20-totalSupply}.
217      */
218     function totalSupply() public view virtual override returns (uint256) {
219         return _totalSupply;
220     }
221 
222     /**
223      * @dev See {IERC20-balanceOf}.
224      */
225     function balanceOf(address account)
226         public
227         view
228         virtual
229         override
230         returns (uint256)
231     {
232         return _balances[account];
233     }
234 
235     /**
236      * @dev See {IERC20-transfer}.
237      *
238      * Requirements:
239      *
240      * - `recipient` cannot be the zero address.
241      * - the caller must have a balance of at least `amount`.
242      */
243     function transfer(address recipient, uint256 amount)
244         public
245         virtual
246         override
247         returns (bool)
248     {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender)
257         public
258         view
259         virtual
260         override
261         returns (uint256)
262     {
263         return _allowances[owner][spender];
264     }
265 
266     /**
267      * @dev See {IERC20-approve}.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 amount)
274         public
275         virtual
276         override
277         returns (bool)
278     {
279         _approve(_msgSender(), spender, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-transferFrom}.
285      *
286      * Emits an {Approval} event indicating the updated allowance. This is not
287      * required by the EIP. See the note at the beginning of {ERC20}.
288      *
289      * Requirements:
290      *
291      * - `sender` and `recipient` cannot be the zero address.
292      * - `sender` must have a balance of at least `amount`.
293      * - the caller must have allowance for ``sender``'s tokens of at least
294      * `amount`.
295      */
296     function transferFrom(
297         address sender,
298         address recipient,
299         uint256 amount
300     ) public virtual override returns (bool) {
301         _transfer(sender, recipient, amount);
302 
303         uint256 currentAllowance = _allowances[sender][_msgSender()];
304         require(
305             currentAllowance >= amount,
306             "ERC20: transfer amount exceeds allowance"
307         );
308         unchecked {
309             _approve(sender, _msgSender(), currentAllowance - amount);
310         }
311 
312         return true;
313     }
314 
315     /**
316      * @dev Atomically increases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function increaseAllowance(address spender, uint256 addedValue)
328         public
329         virtual
330         returns (bool)
331     {
332         _approve(
333             _msgSender(),
334             spender,
335             _allowances[_msgSender()][spender] + addedValue
336         );
337         return true;
338     }
339 
340     /**
341      * @dev Atomically decreases the allowance granted to `spender` by the caller.
342      *
343      * This is an alternative to {approve} that can be used as a mitigation for
344      * problems described in {IERC20-approve}.
345      *
346      * Emits an {Approval} event indicating the updated allowance.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      * - `spender` must have allowance for the caller of at least
352      * `subtractedValue`.
353      */
354     function decreaseAllowance(address spender, uint256 subtractedValue)
355         public
356         virtual
357         returns (bool)
358     {
359         uint256 currentAllowance = _allowances[_msgSender()][spender];
360         require(
361             currentAllowance >= subtractedValue,
362             "ERC20: decreased allowance below zero"
363         );
364         unchecked {
365             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
366         }
367 
368         return true;
369     }
370 
371     /**
372      * @dev Moves `amount` of tokens from `sender` to `recipient`.
373      *
374      * This internal function is equivalent to {transfer}, and can be used to
375      * e.g. implement automatic token fees, slashing mechanisms, etc.
376      *
377      * Emits a {Transfer} event.
378      *
379      * Requirements:
380      *
381      * - `sender` cannot be the zero address.
382      * - `recipient` cannot be the zero address.
383      * - `sender` must have a balance of at least `amount`.
384      */
385     function _transfer(
386         address sender,
387         address recipient,
388         uint256 amount
389     ) internal virtual {
390         require(sender != address(0), "ERC20: transfer from the zero address");
391         require(recipient != address(0), "ERC20: transfer to the zero address");
392 
393         _beforeTokenTransfer(sender, recipient, amount);
394 
395         uint256 senderBalance = _balances[sender];
396         require(
397             senderBalance >= amount,
398             "ERC20: transfer amount exceeds balance"
399         );
400         unchecked {
401             _balances[sender] = senderBalance - amount;
402         }
403         _balances[recipient] += amount;
404 
405         emit Transfer(sender, recipient, amount);
406 
407         _afterTokenTransfer(sender, recipient, amount);
408     }
409 
410     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
411      * the total supply.
412      *
413      * Emits a {Transfer} event with `from` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      */
419     function _mint(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: mint to the zero address");
421 
422         _beforeTokenTransfer(address(0), account, amount);
423 
424         _totalSupply += amount;
425         _balances[account] += amount;
426         emit Transfer(address(0), account, amount);
427 
428         _afterTokenTransfer(address(0), account, amount);
429     }
430 
431     /**
432      * @dev Destroys `amount` tokens from `account`, reducing the
433      * total supply.
434      *
435      * Emits a {Transfer} event with `to` set to the zero address.
436      *
437      * Requirements:
438      *
439      * - `account` cannot be the zero address.
440      * - `account` must have at least `amount` tokens.
441      */
442     function _burn(address account, uint256 amount) internal virtual {
443         require(account != address(0), "ERC20: burn from the zero address");
444 
445         _beforeTokenTransfer(account, address(0), amount);
446 
447         uint256 accountBalance = _balances[account];
448         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
449         unchecked {
450             _balances[account] = accountBalance - amount;
451         }
452         _totalSupply -= amount;
453 
454         emit Transfer(account, address(0), amount);
455 
456         _afterTokenTransfer(account, address(0), amount);
457     }
458 
459     /**
460      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
461      *
462      * This internal function is equivalent to `approve`, and can be used to
463      * e.g. set automatic allowances for certain subsystems, etc.
464      *
465      * Emits an {Approval} event.
466      *
467      * Requirements:
468      *
469      * - `owner` cannot be the zero address.
470      * - `spender` cannot be the zero address.
471      */
472     function _approve(
473         address owner,
474         address spender,
475         uint256 amount
476     ) internal virtual {
477         require(owner != address(0), "ERC20: approve from the zero address");
478         require(spender != address(0), "ERC20: approve to the zero address");
479 
480         _allowances[owner][spender] = amount;
481         emit Approval(owner, spender, amount);
482     }
483 
484     /**
485      * @dev Hook that is called before any transfer of tokens. This includes
486      * minting and burning.
487      *
488      * Calling conditions:
489      *
490      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
491      * will be transferred to `to`.
492      * - when `from` is zero, `amount` tokens will be minted for `to`.
493      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
494      * - `from` and `to` are never both zero.
495      *
496      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
497      */
498     function _beforeTokenTransfer(
499         address from,
500         address to,
501         uint256 amount
502     ) internal virtual {}
503 
504     /**
505      * @dev Hook that is called after any transfer of tokens. This includes
506      * minting and burning.
507      *
508      * Calling conditions:
509      *
510      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
511      * has been transferred to `to`.
512      * - when `from` is zero, `amount` tokens have been minted for `to`.
513      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
514      * - `from` and `to` are never both zero.
515      *
516      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
517      */
518     function _afterTokenTransfer(
519         address from,
520         address to,
521         uint256 amount
522     ) internal virtual {}
523 }
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Interface of the ERC165 standard, as defined in the
529  * https://eips.ethereum.org/EIPS/eip-165[EIP].
530  *
531  * Implementers can declare support of contract interfaces, which can then be
532  * queried by others ({ERC165Checker}).
533  *
534  * For an implementation, see {ERC165}.
535  */
536 interface IERC165 {
537     /**
538      * @dev Returns true if this contract implements the interface defined by
539      * `interfaceId`. See the corresponding
540      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
541      * to learn more about how these ids are created.
542      *
543      * This function call must use less than 30 000 gas.
544      */
545     function supportsInterface(bytes4 interfaceId) external view returns (bool);
546 }
547 
548 /**
549  * @dev Implementation of the {IERC165} interface.
550  *
551  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
552  * for the additional interface id that will be supported. For example:
553  *
554  * ```solidity
555  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
557  * }
558  * ```
559  *
560  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
561  */
562 abstract contract ERC165 is IERC165 {
563     /**
564      * @dev See {IERC165-supportsInterface}.
565      */
566     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
567         return interfaceId == type(IERC165).interfaceId;
568     }
569 }
570 
571 /**
572  * @dev Required interface of an ERC721 compliant contract.
573  */
574 interface IERC721 is IERC165 {
575     /**
576      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
577      */
578     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
579 
580     /**
581      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
582      */
583     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
584 
585     /**
586      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
587      */
588     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
589 
590     /**
591      * @dev Returns the number of tokens in ``owner``'s account.
592      */
593     function balanceOf(address owner) external view returns (uint256 balance);
594 
595     /**
596      * @dev Returns the owner of the `tokenId` token.
597      *
598      * Requirements:
599      *
600      * - `tokenId` must exist.
601      */
602     function ownerOf(uint256 tokenId) external view returns (address owner);
603 
604     /**
605      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
606      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must exist and be owned by `from`.
613      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
614      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
615      *
616      * Emits a {Transfer} event.
617      */
618     function safeTransferFrom(
619         address from,
620         address to,
621         uint256 tokenId
622     ) external;
623 
624     /**
625      * @dev Transfers `tokenId` token from `from` to `to`.
626      *
627      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
628      *
629      * Requirements:
630      *
631      * - `from` cannot be the zero address.
632      * - `to` cannot be the zero address.
633      * - `tokenId` token must be owned by `from`.
634      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
635      *
636      * Emits a {Transfer} event.
637      */
638     function transferFrom(
639         address from,
640         address to,
641         uint256 tokenId
642     ) external;
643 
644     /**
645      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
646      * The approval is cleared when the token is transferred.
647      *
648      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
649      *
650      * Requirements:
651      *
652      * - The caller must own the token or be an approved operator.
653      * - `tokenId` must exist.
654      *
655      * Emits an {Approval} event.
656      */
657     function approve(address to, uint256 tokenId) external;
658 
659     /**
660      * @dev Returns the account approved for `tokenId` token.
661      *
662      * Requirements:
663      *
664      * - `tokenId` must exist.
665      */
666     function getApproved(uint256 tokenId) external view returns (address operator);
667 
668     /**
669      * @dev Approve or remove `operator` as an operator for the caller.
670      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
671      *
672      * Requirements:
673      *
674      * - The `operator` cannot be the caller.
675      *
676      * Emits an {ApprovalForAll} event.
677      */
678     function setApprovalForAll(address operator, bool _approved) external;
679 
680     /**
681      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
682      *
683      * See {setApprovalForAll}
684      */
685     function isApprovedForAll(address owner, address operator) external view returns (bool);
686 
687     /**
688      * @dev Safely transfers `tokenId` token from `from` to `to`.
689      *
690      * Requirements:
691      *
692      * - `from` cannot be the zero address.
693      * - `to` cannot be the zero address.
694      * - `tokenId` token must exist and be owned by `from`.
695      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
696      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
697      *
698      * Emits a {Transfer} event.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId,
704         bytes calldata data
705     ) external;
706 }
707 
708 
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
711  * @dev See https://eips.ethereum.org/EIPS/eip-721
712  */
713 interface IERC721Enumerable is IERC721 {
714     /**
715      * @dev Returns the total amount of tokens stored by the contract.
716      */
717     function totalSupply() external view returns (uint256);
718 
719     /**
720      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
721      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
722      */
723     function tokenOfOwnerByIndex(address owner, uint256 index)
724         external
725         view
726         returns (uint256 tokenId);
727 
728     /**
729      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
730      * Use along with {totalSupply} to enumerate all tokens.
731      */
732     function tokenByIndex(uint256 index) external view returns (uint256);
733 }
734 
735 contract FirstGold is Context, ERC20 {
736     address public firstContractAddress = 0xc9Cb0FEe73f060Db66D2693D92d75c825B1afdbF;
737     IERC721Enumerable public firstContract;
738 
739     uint256 public firstGoldPerTokenId = 10000 * (10**decimals());
740 
741     mapping(uint256 => bool) public hasClaimed;
742 
743     constructor() ERC20("First Gold", "FGLD") {
744         firstContract = IERC721Enumerable(firstContractAddress);
745     }
746 
747     function claimById(uint256 tokenId) external {
748         require(
749             _msgSender() == firstContract.ownerOf(tokenId),
750             "MUST_OWN_TOKEN_ID"
751         );
752 
753         _claim(tokenId, _msgSender());
754     }
755 
756     function claimAllForOwner() external {
757         uint256 tokenBalanceOwner = firstContract.balanceOf(_msgSender());
758 
759         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
760 
761         for (uint256 i = 0; i < tokenBalanceOwner; i++) {
762             _claim(
763                 firstContract.tokenOfOwnerByIndex(_msgSender(), i),
764                 _msgSender()
765             );
766         }
767     }
768 
769     function claimRangeForOwner(uint256 ownerIndexStart, uint256 ownerIndexEnd)
770         external
771     {
772         uint256 tokenBalanceOwner = firstContract.balanceOf(_msgSender());
773 
774         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
775 
776         require(
777             ownerIndexStart >= 0 && ownerIndexEnd < tokenBalanceOwner,
778             "INDEX_OUT_OF_RANGE"
779         );
780 
781         for (uint256 i = ownerIndexStart; i <= ownerIndexEnd; i++) {
782             _claim(
783                 firstContract.tokenOfOwnerByIndex(_msgSender(), i),
784                 _msgSender()
785             );
786         }
787     }
788 
789     function _claim(uint256 tokenId,address tokenOwner) internal {
790         require(
791             !hasClaimed[tokenId],
792             "GOLD_CLAIMED_FOR_TOKEN_ID"
793         );
794 
795         hasClaimed[tokenId] = true;
796 
797         _mint(tokenOwner, firstGoldPerTokenId);
798     }
799 }