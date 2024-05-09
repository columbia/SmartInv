1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.1
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
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.1
89 
90 pragma solidity ^0.8.0;
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
114 
115 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Provides information about the current execution context, including the
121  * sender of the transaction and its data. While these are generally available
122  * via msg.sender and msg.data, they should not be accessed in such a direct
123  * manner, since when dealing with meta-transactions the account sending and
124  * paying for execution may not be the actual sender (as far as an application
125  * is concerned).
126  *
127  * This contract is only required for intermediate, library-like contracts.
128  */
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view virtual returns (bytes calldata) {
135         return msg.data;
136     }
137 }
138 
139 
140 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.1
141 
142 pragma solidity ^0.8.0;
143 
144 
145 
146 /**
147  * @dev Implementation of the {IERC20} interface.
148  *
149  * This implementation is agnostic to the way tokens are created. This means
150  * that a supply mechanism has to be added in a derived contract using {_mint}.
151  * For a generic mechanism see {ERC20PresetMinterPauser}.
152  *
153  * TIP: For a detailed writeup see our guide
154  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
155  * to implement supply mechanisms].
156  *
157  * We have followed general OpenZeppelin Contracts guidelines: functions revert
158  * instead returning `false` on failure. This behavior is nonetheless
159  * conventional and does not conflict with the expectations of ERC20
160  * applications.
161  *
162  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
163  * This allows applications to reconstruct the allowance for all accounts just
164  * by listening to said events. Other implementations of the EIP may not emit
165  * these events, as it isn't required by the specification.
166  *
167  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
168  * functions have been added to mitigate the well-known issues around setting
169  * allowances. See {IERC20-approve}.
170  */
171 contract ERC20 is Context, IERC20, IERC20Metadata {
172     mapping(address => uint256) private _balances;
173 
174     mapping(address => mapping(address => uint256)) private _allowances;
175 
176     uint256 private _totalSupply;
177 
178     string private _name;
179     string private _symbol;
180 
181     /**
182      * @dev Sets the values for {name} and {symbol}.
183      *
184      * The default value of {decimals} is 18. To select a different value for
185      * {decimals} you should overload it.
186      *
187      * All two of these values are immutable: they can only be set once during
188      * construction.
189      */
190     constructor(string memory name_, string memory symbol_) {
191         _name = name_;
192         _symbol = symbol_;
193     }
194 
195     /**
196      * @dev Returns the name of the token.
197      */
198     function name() public view virtual override returns (string memory) {
199         return _name;
200     }
201 
202     /**
203      * @dev Returns the symbol of the token, usually a shorter version of the
204      * name.
205      */
206     function symbol() public view virtual override returns (string memory) {
207         return _symbol;
208     }
209 
210     /**
211      * @dev Returns the number of decimals used to get its user representation.
212      * For example, if `decimals` equals `2`, a balance of `505` tokens should
213      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
214      *
215      * Tokens usually opt for a value of 18, imitating the relationship between
216      * Ether and Wei. This is the value {ERC20} uses, unless this function is
217      * overridden;
218      *
219      * NOTE: This information is only used for _display_ purposes: it in
220      * no way affects any of the arithmetic of the contract, including
221      * {IERC20-balanceOf} and {IERC20-transfer}.
222      */
223     function decimals() public view virtual override returns (uint8) {
224         return 18;
225     }
226 
227     /**
228      * @dev See {IERC20-totalSupply}.
229      */
230     function totalSupply() public view virtual override returns (uint256) {
231         return _totalSupply;
232     }
233 
234     /**
235      * @dev See {IERC20-balanceOf}.
236      */
237     function balanceOf(address account) public view virtual override returns (uint256) {
238         return _balances[account];
239     }
240 
241     /**
242      * @dev See {IERC20-transfer}.
243      *
244      * Requirements:
245      *
246      * - `recipient` cannot be the zero address.
247      * - the caller must have a balance of at least `amount`.
248      */
249     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
250         _transfer(_msgSender(), recipient, amount);
251         return true;
252     }
253 
254     /**
255      * @dev See {IERC20-allowance}.
256      */
257     function allowance(address owner, address spender) public view virtual override returns (uint256) {
258         return _allowances[owner][spender];
259     }
260 
261     /**
262      * @dev See {IERC20-approve}.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      */
268     function approve(address spender, uint256 amount) public virtual override returns (bool) {
269         _approve(_msgSender(), spender, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See {IERC20-transferFrom}.
275      *
276      * Emits an {Approval} event indicating the updated allowance. This is not
277      * required by the EIP. See the note at the beginning of {ERC20}.
278      *
279      * Requirements:
280      *
281      * - `sender` and `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `amount`.
283      * - the caller must have allowance for ``sender``'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) public virtual override returns (bool) {
291         _transfer(sender, recipient, amount);
292 
293         uint256 currentAllowance = _allowances[sender][_msgSender()];
294         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
295         unchecked {
296             _approve(sender, _msgSender(), currentAllowance - amount);
297         }
298 
299         return true;
300     }
301 
302     /**
303      * @dev Atomically increases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to {approve} that can be used as a mitigation for
306      * problems described in {IERC20-approve}.
307      *
308      * Emits an {Approval} event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      */
314     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
315         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
316         return true;
317     }
318 
319     /**
320      * @dev Atomically decreases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      * - `spender` must have allowance for the caller of at least
331      * `subtractedValue`.
332      */
333     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
334         uint256 currentAllowance = _allowances[_msgSender()][spender];
335         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
336         unchecked {
337             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
338         }
339 
340         return true;
341     }
342 
343     /**
344      * @dev Moves `amount` of tokens from `sender` to `recipient`.
345      *
346      * This internal function is equivalent to {transfer}, and can be used to
347      * e.g. implement automatic token fees, slashing mechanisms, etc.
348      *
349      * Emits a {Transfer} event.
350      *
351      * Requirements:
352      *
353      * - `sender` cannot be the zero address.
354      * - `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      */
357     function _transfer(
358         address sender,
359         address recipient,
360         uint256 amount
361     ) internal virtual {
362         require(sender != address(0), "ERC20: transfer from the zero address");
363         require(recipient != address(0), "ERC20: transfer to the zero address");
364 
365         _beforeTokenTransfer(sender, recipient, amount);
366 
367         uint256 senderBalance = _balances[sender];
368         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
369         unchecked {
370             _balances[sender] = senderBalance - amount;
371         }
372         _balances[recipient] += amount;
373 
374         emit Transfer(sender, recipient, amount);
375 
376         _afterTokenTransfer(sender, recipient, amount);
377     }
378 
379     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
380      * the total supply.
381      *
382      * Emits a {Transfer} event with `from` set to the zero address.
383      *
384      * Requirements:
385      *
386      * - `account` cannot be the zero address.
387      */
388     function _mint(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: mint to the zero address");
390 
391         _beforeTokenTransfer(address(0), account, amount);
392 
393         _totalSupply += amount;
394         _balances[account] += amount;
395         emit Transfer(address(0), account, amount);
396 
397         _afterTokenTransfer(address(0), account, amount);
398     }
399 
400     /**
401      * @dev Destroys `amount` tokens from `account`, reducing the
402      * total supply.
403      *
404      * Emits a {Transfer} event with `to` set to the zero address.
405      *
406      * Requirements:
407      *
408      * - `account` cannot be the zero address.
409      * - `account` must have at least `amount` tokens.
410      */
411     function _burn(address account, uint256 amount) internal virtual {
412         require(account != address(0), "ERC20: burn from the zero address");
413 
414         _beforeTokenTransfer(account, address(0), amount);
415 
416         uint256 accountBalance = _balances[account];
417         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
418         unchecked {
419             _balances[account] = accountBalance - amount;
420         }
421         _totalSupply -= amount;
422 
423         emit Transfer(account, address(0), amount);
424 
425         _afterTokenTransfer(account, address(0), amount);
426     }
427 
428     /**
429      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
430      *
431      * This internal function is equivalent to `approve`, and can be used to
432      * e.g. set automatic allowances for certain subsystems, etc.
433      *
434      * Emits an {Approval} event.
435      *
436      * Requirements:
437      *
438      * - `owner` cannot be the zero address.
439      * - `spender` cannot be the zero address.
440      */
441     function _approve(
442         address owner,
443         address spender,
444         uint256 amount
445     ) internal virtual {
446         require(owner != address(0), "ERC20: approve from the zero address");
447         require(spender != address(0), "ERC20: approve to the zero address");
448 
449         _allowances[owner][spender] = amount;
450         emit Approval(owner, spender, amount);
451     }
452 
453     /**
454      * @dev Hook that is called before any transfer of tokens. This includes
455      * minting and burning.
456      *
457      * Calling conditions:
458      *
459      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
460      * will be transferred to `to`.
461      * - when `from` is zero, `amount` tokens will be minted for `to`.
462      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
463      * - `from` and `to` are never both zero.
464      *
465      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
466      */
467     function _beforeTokenTransfer(
468         address from,
469         address to,
470         uint256 amount
471     ) internal virtual {}
472 
473     /**
474      * @dev Hook that is called after any transfer of tokens. This includes
475      * minting and burning.
476      *
477      * Calling conditions:
478      *
479      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
480      * has been transferred to `to`.
481      * - when `from` is zero, `amount` tokens have been minted for `to`.
482      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
483      * - `from` and `to` are never both zero.
484      *
485      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
486      */
487     function _afterTokenTransfer(
488         address from,
489         address to,
490         uint256 amount
491     ) internal virtual {}
492 }
493 
494 
495 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev Interface of the ERC165 standard, as defined in the
501  * https://eips.ethereum.org/EIPS/eip-165[EIP].
502  *
503  * Implementers can declare support of contract interfaces, which can then be
504  * queried by others ({ERC165Checker}).
505  *
506  * For an implementation, see {ERC165}.
507  */
508 interface IERC165 {
509     /**
510      * @dev Returns true if this contract implements the interface defined by
511      * `interfaceId`. See the corresponding
512      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
513      * to learn more about how these ids are created.
514      *
515      * This function call must use less than 30 000 gas.
516      */
517     function supportsInterface(bytes4 interfaceId) external view returns (bool);
518 }
519 
520 
521 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @dev Required interface of an ERC721 compliant contract.
527  */
528 interface IERC721 is IERC165 {
529     /**
530      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
531      */
532     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
533 
534     /**
535      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
536      */
537     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
538 
539     /**
540      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
541      */
542     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
543 
544     /**
545      * @dev Returns the number of tokens in ``owner``'s account.
546      */
547     function balanceOf(address owner) external view returns (uint256 balance);
548 
549     /**
550      * @dev Returns the owner of the `tokenId` token.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must exist.
555      */
556     function ownerOf(uint256 tokenId) external view returns (address owner);
557 
558     /**
559      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
560      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
561      *
562      * Requirements:
563      *
564      * - `from` cannot be the zero address.
565      * - `to` cannot be the zero address.
566      * - `tokenId` token must exist and be owned by `from`.
567      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
568      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
569      *
570      * Emits a {Transfer} event.
571      */
572     function safeTransferFrom(
573         address from,
574         address to,
575         uint256 tokenId
576     ) external;
577 
578     /**
579      * @dev Transfers `tokenId` token from `from` to `to`.
580      *
581      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
582      *
583      * Requirements:
584      *
585      * - `from` cannot be the zero address.
586      * - `to` cannot be the zero address.
587      * - `tokenId` token must be owned by `from`.
588      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
589      *
590      * Emits a {Transfer} event.
591      */
592     function transferFrom(
593         address from,
594         address to,
595         uint256 tokenId
596     ) external;
597 
598     /**
599      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
600      * The approval is cleared when the token is transferred.
601      *
602      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
603      *
604      * Requirements:
605      *
606      * - The caller must own the token or be an approved operator.
607      * - `tokenId` must exist.
608      *
609      * Emits an {Approval} event.
610      */
611     function approve(address to, uint256 tokenId) external;
612 
613     /**
614      * @dev Returns the account approved for `tokenId` token.
615      *
616      * Requirements:
617      *
618      * - `tokenId` must exist.
619      */
620     function getApproved(uint256 tokenId) external view returns (address operator);
621 
622     /**
623      * @dev Approve or remove `operator` as an operator for the caller.
624      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
625      *
626      * Requirements:
627      *
628      * - The `operator` cannot be the caller.
629      *
630      * Emits an {ApprovalForAll} event.
631      */
632     function setApprovalForAll(address operator, bool _approved) external;
633 
634     /**
635      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
636      *
637      * See {setApprovalForAll}
638      */
639     function isApprovedForAll(address owner, address operator) external view returns (bool);
640 
641     /**
642      * @dev Safely transfers `tokenId` token from `from` to `to`.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must exist and be owned by `from`.
649      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
651      *
652      * Emits a {Transfer} event.
653      */
654     function safeTransferFrom(
655         address from,
656         address to,
657         uint256 tokenId,
658         bytes calldata data
659     ) external;
660 }
661 
662 
663 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
664 
665 pragma solidity ^0.8.0;
666 
667 /**
668  * @title ERC721 token receiver interface
669  * @dev Interface for any contract that wants to support safeTransfers
670  * from ERC721 asset contracts.
671  */
672 interface IERC721Receiver {
673     /**
674      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
675      * by `operator` from `from`, this function is called.
676      *
677      * It must return its Solidity selector to confirm the token transfer.
678      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
679      *
680      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
681      */
682     function onERC721Received(
683         address operator,
684         address from,
685         uint256 tokenId,
686         bytes calldata data
687     ) external returns (bytes4);
688 }
689 
690 
691 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
692 
693 pragma solidity ^0.8.0;
694 
695 /**
696  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
697  * @dev See https://eips.ethereum.org/EIPS/eip-721
698  */
699 interface IERC721Metadata is IERC721 {
700     /**
701      * @dev Returns the token collection name.
702      */
703     function name() external view returns (string memory);
704 
705     /**
706      * @dev Returns the token collection symbol.
707      */
708     function symbol() external view returns (string memory);
709 
710     /**
711      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
712      */
713     function tokenURI(uint256 tokenId) external view returns (string memory);
714 }
715 
716 
717 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
718 
719 pragma solidity ^0.8.0;
720 
721 /**
722  * @dev Collection of functions related to the address type
723  */
724 library Address {
725     /**
726      * @dev Returns true if `account` is a contract.
727      *
728      * [IMPORTANT]
729      * ====
730      * It is unsafe to assume that an address for which this function returns
731      * false is an externally-owned account (EOA) and not a contract.
732      *
733      * Among others, `isContract` will return false for the following
734      * types of addresses:
735      *
736      *  - an externally-owned account
737      *  - a contract in construction
738      *  - an address where a contract will be created
739      *  - an address where a contract lived, but was destroyed
740      * ====
741      */
742     function isContract(address account) internal view returns (bool) {
743         // This method relies on extcodesize, which returns 0 for contracts in
744         // construction, since the code is only stored at the end of the
745         // constructor execution.
746 
747         uint256 size;
748         assembly {
749             size := extcodesize(account)
750         }
751         return size > 0;
752     }
753 
754     /**
755      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
756      * `recipient`, forwarding all available gas and reverting on errors.
757      *
758      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
759      * of certain opcodes, possibly making contracts go over the 2300 gas limit
760      * imposed by `transfer`, making them unable to receive funds via
761      * `transfer`. {sendValue} removes this limitation.
762      *
763      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
764      *
765      * IMPORTANT: because control is transferred to `recipient`, care must be
766      * taken to not create reentrancy vulnerabilities. Consider using
767      * {ReentrancyGuard} or the
768      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
769      */
770     function sendValue(address payable recipient, uint256 amount) internal {
771         require(address(this).balance >= amount, "Address: insufficient balance");
772 
773         (bool success, ) = recipient.call{value: amount}("");
774         require(success, "Address: unable to send value, recipient may have reverted");
775     }
776 
777     /**
778      * @dev Performs a Solidity function call using a low level `call`. A
779      * plain `call` is an unsafe replacement for a function call: use this
780      * function instead.
781      *
782      * If `target` reverts with a revert reason, it is bubbled up by this
783      * function (like regular Solidity function calls).
784      *
785      * Returns the raw returned data. To convert to the expected return value,
786      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
787      *
788      * Requirements:
789      *
790      * - `target` must be a contract.
791      * - calling `target` with `data` must not revert.
792      *
793      * _Available since v3.1._
794      */
795     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
796         return functionCall(target, data, "Address: low-level call failed");
797     }
798 
799     /**
800      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
801      * `errorMessage` as a fallback revert reason when `target` reverts.
802      *
803      * _Available since v3.1._
804      */
805     function functionCall(
806         address target,
807         bytes memory data,
808         string memory errorMessage
809     ) internal returns (bytes memory) {
810         return functionCallWithValue(target, data, 0, errorMessage);
811     }
812 
813     /**
814      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
815      * but also transferring `value` wei to `target`.
816      *
817      * Requirements:
818      *
819      * - the calling contract must have an ETH balance of at least `value`.
820      * - the called Solidity function must be `payable`.
821      *
822      * _Available since v3.1._
823      */
824     function functionCallWithValue(
825         address target,
826         bytes memory data,
827         uint256 value
828     ) internal returns (bytes memory) {
829         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
830     }
831 
832     /**
833      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
834      * with `errorMessage` as a fallback revert reason when `target` reverts.
835      *
836      * _Available since v3.1._
837      */
838     function functionCallWithValue(
839         address target,
840         bytes memory data,
841         uint256 value,
842         string memory errorMessage
843     ) internal returns (bytes memory) {
844         require(address(this).balance >= value, "Address: insufficient balance for call");
845         require(isContract(target), "Address: call to non-contract");
846 
847         (bool success, bytes memory returndata) = target.call{value: value}(data);
848         return verifyCallResult(success, returndata, errorMessage);
849     }
850 
851     /**
852      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
853      * but performing a static call.
854      *
855      * _Available since v3.3._
856      */
857     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
858         return functionStaticCall(target, data, "Address: low-level static call failed");
859     }
860 
861     /**
862      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
863      * but performing a static call.
864      *
865      * _Available since v3.3._
866      */
867     function functionStaticCall(
868         address target,
869         bytes memory data,
870         string memory errorMessage
871     ) internal view returns (bytes memory) {
872         require(isContract(target), "Address: static call to non-contract");
873 
874         (bool success, bytes memory returndata) = target.staticcall(data);
875         return verifyCallResult(success, returndata, errorMessage);
876     }
877 
878     /**
879      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
880      * but performing a delegate call.
881      *
882      * _Available since v3.4._
883      */
884     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
885         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
886     }
887 
888     /**
889      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
890      * but performing a delegate call.
891      *
892      * _Available since v3.4._
893      */
894     function functionDelegateCall(
895         address target,
896         bytes memory data,
897         string memory errorMessage
898     ) internal returns (bytes memory) {
899         require(isContract(target), "Address: delegate call to non-contract");
900 
901         (bool success, bytes memory returndata) = target.delegatecall(data);
902         return verifyCallResult(success, returndata, errorMessage);
903     }
904 
905     /**
906      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
907      * revert reason using the provided one.
908      *
909      * _Available since v4.3._
910      */
911     function verifyCallResult(
912         bool success,
913         bytes memory returndata,
914         string memory errorMessage
915     ) internal pure returns (bytes memory) {
916         if (success) {
917             return returndata;
918         } else {
919             // Look for revert reason and bubble it up if present
920             if (returndata.length > 0) {
921                 // The easiest way to bubble the revert reason is using memory via assembly
922 
923                 assembly {
924                     let returndata_size := mload(returndata)
925                     revert(add(32, returndata), returndata_size)
926                 }
927             } else {
928                 revert(errorMessage);
929             }
930         }
931     }
932 }
933 
934 
935 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
936 
937 pragma solidity ^0.8.0;
938 
939 /**
940  * @dev String operations.
941  */
942 library Strings {
943     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
944 
945     /**
946      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
947      */
948     function toString(uint256 value) internal pure returns (string memory) {
949         // Inspired by OraclizeAPI's implementation - MIT licence
950         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
951 
952         if (value == 0) {
953             return "0";
954         }
955         uint256 temp = value;
956         uint256 digits;
957         while (temp != 0) {
958             digits++;
959             temp /= 10;
960         }
961         bytes memory buffer = new bytes(digits);
962         while (value != 0) {
963             digits -= 1;
964             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
965             value /= 10;
966         }
967         return string(buffer);
968     }
969 
970     /**
971      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
972      */
973     function toHexString(uint256 value) internal pure returns (string memory) {
974         if (value == 0) {
975             return "0x00";
976         }
977         uint256 temp = value;
978         uint256 length = 0;
979         while (temp != 0) {
980             length++;
981             temp >>= 8;
982         }
983         return toHexString(value, length);
984     }
985 
986     /**
987      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
988      */
989     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
990         bytes memory buffer = new bytes(2 * length + 2);
991         buffer[0] = "0";
992         buffer[1] = "x";
993         for (uint256 i = 2 * length + 1; i > 1; --i) {
994             buffer[i] = _HEX_SYMBOLS[value & 0xf];
995             value >>= 4;
996         }
997         require(value == 0, "Strings: hex length insufficient");
998         return string(buffer);
999     }
1000 }
1001 
1002 
1003 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 /**
1008  * @dev Implementation of the {IERC165} interface.
1009  *
1010  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1011  * for the additional interface id that will be supported. For example:
1012  *
1013  * ```solidity
1014  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1015  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1016  * }
1017  * ```
1018  *
1019  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1020  */
1021 abstract contract ERC165 is IERC165 {
1022     /**
1023      * @dev See {IERC165-supportsInterface}.
1024      */
1025     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1026         return interfaceId == type(IERC165).interfaceId;
1027     }
1028 }
1029 
1030 
1031 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
1032 
1033 pragma solidity ^0.8.0;
1034 
1035 
1036 
1037 
1038 
1039 
1040 
1041 /**
1042  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1043  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1044  * {ERC721Enumerable}.
1045  */
1046 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1047     using Address for address;
1048     using Strings for uint256;
1049 
1050     // Token name
1051     string private _name;
1052 
1053     // Token symbol
1054     string private _symbol;
1055 
1056     // Mapping from token ID to owner address
1057     mapping(uint256 => address) private _owners;
1058 
1059     // Mapping owner address to token count
1060     mapping(address => uint256) private _balances;
1061 
1062     // Mapping from token ID to approved address
1063     mapping(uint256 => address) private _tokenApprovals;
1064 
1065     // Mapping from owner to operator approvals
1066     mapping(address => mapping(address => bool)) private _operatorApprovals;
1067 
1068     /**
1069      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1070      */
1071     constructor(string memory name_, string memory symbol_) {
1072         _name = name_;
1073         _symbol = symbol_;
1074     }
1075 
1076     /**
1077      * @dev See {IERC165-supportsInterface}.
1078      */
1079     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1080         return
1081             interfaceId == type(IERC721).interfaceId ||
1082             interfaceId == type(IERC721Metadata).interfaceId ||
1083             super.supportsInterface(interfaceId);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-balanceOf}.
1088      */
1089     function balanceOf(address owner) public view virtual override returns (uint256) {
1090         require(owner != address(0), "ERC721: balance query for the zero address");
1091         return _balances[owner];
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-ownerOf}.
1096      */
1097     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1098         address owner = _owners[tokenId];
1099         require(owner != address(0), "ERC721: owner query for nonexistent token");
1100         return owner;
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Metadata-name}.
1105      */
1106     function name() public view virtual override returns (string memory) {
1107         return _name;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Metadata-symbol}.
1112      */
1113     function symbol() public view virtual override returns (string memory) {
1114         return _symbol;
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Metadata-tokenURI}.
1119      */
1120     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1121         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1122 
1123         string memory baseURI = _baseURI();
1124         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1125     }
1126 
1127     /**
1128      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1129      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1130      * by default, can be overriden in child contracts.
1131      */
1132     function _baseURI() internal view virtual returns (string memory) {
1133         return "";
1134     }
1135 
1136     /**
1137      * @dev See {IERC721-approve}.
1138      */
1139     function approve(address to, uint256 tokenId) public virtual override {
1140         address owner = ERC721.ownerOf(tokenId);
1141         require(to != owner, "ERC721: approval to current owner");
1142 
1143         require(
1144             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1145             "ERC721: approve caller is not owner nor approved for all"
1146         );
1147 
1148         _approve(to, tokenId);
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-getApproved}.
1153      */
1154     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1155         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1156 
1157         return _tokenApprovals[tokenId];
1158     }
1159 
1160     /**
1161      * @dev See {IERC721-setApprovalForAll}.
1162      */
1163     function setApprovalForAll(address operator, bool approved) public virtual override {
1164         require(operator != _msgSender(), "ERC721: approve to caller");
1165 
1166         _operatorApprovals[_msgSender()][operator] = approved;
1167         emit ApprovalForAll(_msgSender(), operator, approved);
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-isApprovedForAll}.
1172      */
1173     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1174         return _operatorApprovals[owner][operator];
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-transferFrom}.
1179      */
1180     function transferFrom(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) public virtual override {
1185         //solhint-disable-next-line max-line-length
1186         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1187 
1188         _transfer(from, to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-safeTransferFrom}.
1193      */
1194     function safeTransferFrom(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) public virtual override {
1199         safeTransferFrom(from, to, tokenId, "");
1200     }
1201 
1202     /**
1203      * @dev See {IERC721-safeTransferFrom}.
1204      */
1205     function safeTransferFrom(
1206         address from,
1207         address to,
1208         uint256 tokenId,
1209         bytes memory _data
1210     ) public virtual override {
1211         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1212         _safeTransfer(from, to, tokenId, _data);
1213     }
1214 
1215     /**
1216      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1217      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1218      *
1219      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1220      *
1221      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1222      * implement alternative mechanisms to perform token transfer, such as signature-based.
1223      *
1224      * Requirements:
1225      *
1226      * - `from` cannot be the zero address.
1227      * - `to` cannot be the zero address.
1228      * - `tokenId` token must exist and be owned by `from`.
1229      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function _safeTransfer(
1234         address from,
1235         address to,
1236         uint256 tokenId,
1237         bytes memory _data
1238     ) internal virtual {
1239         _transfer(from, to, tokenId);
1240         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1241     }
1242 
1243     /**
1244      * @dev Returns whether `tokenId` exists.
1245      *
1246      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1247      *
1248      * Tokens start existing when they are minted (`_mint`),
1249      * and stop existing when they are burned (`_burn`).
1250      */
1251     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1252         return _owners[tokenId] != address(0);
1253     }
1254 
1255     /**
1256      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1257      *
1258      * Requirements:
1259      *
1260      * - `tokenId` must exist.
1261      */
1262     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1263         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1264         address owner = ERC721.ownerOf(tokenId);
1265         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1266     }
1267 
1268     /**
1269      * @dev Safely mints `tokenId` and transfers it to `to`.
1270      *
1271      * Requirements:
1272      *
1273      * - `tokenId` must not exist.
1274      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1275      *
1276      * Emits a {Transfer} event.
1277      */
1278     function _safeMint(address to, uint256 tokenId) internal virtual {
1279         _safeMint(to, tokenId, "");
1280     }
1281 
1282     /**
1283      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1284      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1285      */
1286     function _safeMint(
1287         address to,
1288         uint256 tokenId,
1289         bytes memory _data
1290     ) internal virtual {
1291         _mint(to, tokenId);
1292         require(
1293             _checkOnERC721Received(address(0), to, tokenId, _data),
1294             "ERC721: transfer to non ERC721Receiver implementer"
1295         );
1296     }
1297 
1298     /**
1299      * @dev Mints `tokenId` and transfers it to `to`.
1300      *
1301      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1302      *
1303      * Requirements:
1304      *
1305      * - `tokenId` must not exist.
1306      * - `to` cannot be the zero address.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function _mint(address to, uint256 tokenId) internal virtual {
1311         require(to != address(0), "ERC721: mint to the zero address");
1312         require(!_exists(tokenId), "ERC721: token already minted");
1313 
1314         _beforeTokenTransfer(address(0), to, tokenId);
1315 
1316         _balances[to] += 1;
1317         _owners[tokenId] = to;
1318 
1319         emit Transfer(address(0), to, tokenId);
1320     }
1321 
1322     /**
1323      * @dev Destroys `tokenId`.
1324      * The approval is cleared when the token is burned.
1325      *
1326      * Requirements:
1327      *
1328      * - `tokenId` must exist.
1329      *
1330      * Emits a {Transfer} event.
1331      */
1332     function _burn(uint256 tokenId) internal virtual {
1333         address owner = ERC721.ownerOf(tokenId);
1334 
1335         _beforeTokenTransfer(owner, address(0), tokenId);
1336 
1337         // Clear approvals
1338         _approve(address(0), tokenId);
1339 
1340         _balances[owner] -= 1;
1341         delete _owners[tokenId];
1342 
1343         emit Transfer(owner, address(0), tokenId);
1344     }
1345 
1346     /**
1347      * @dev Transfers `tokenId` from `from` to `to`.
1348      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1349      *
1350      * Requirements:
1351      *
1352      * - `to` cannot be the zero address.
1353      * - `tokenId` token must be owned by `from`.
1354      *
1355      * Emits a {Transfer} event.
1356      */
1357     function _transfer(
1358         address from,
1359         address to,
1360         uint256 tokenId
1361     ) internal virtual {
1362         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1363         require(to != address(0), "ERC721: transfer to the zero address");
1364 
1365         _beforeTokenTransfer(from, to, tokenId);
1366 
1367         // Clear approvals from the previous owner
1368         _approve(address(0), tokenId);
1369 
1370         _balances[from] -= 1;
1371         _balances[to] += 1;
1372         _owners[tokenId] = to;
1373 
1374         emit Transfer(from, to, tokenId);
1375     }
1376 
1377     /**
1378      * @dev Approve `to` to operate on `tokenId`
1379      *
1380      * Emits a {Approval} event.
1381      */
1382     function _approve(address to, uint256 tokenId) internal virtual {
1383         _tokenApprovals[tokenId] = to;
1384         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1385     }
1386 
1387     /**
1388      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1389      * The call is not executed if the target address is not a contract.
1390      *
1391      * @param from address representing the previous owner of the given token ID
1392      * @param to target address that will receive the tokens
1393      * @param tokenId uint256 ID of the token to be transferred
1394      * @param _data bytes optional data to send along with the call
1395      * @return bool whether the call correctly returned the expected magic value
1396      */
1397     function _checkOnERC721Received(
1398         address from,
1399         address to,
1400         uint256 tokenId,
1401         bytes memory _data
1402     ) private returns (bool) {
1403         if (to.isContract()) {
1404             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1405                 return retval == IERC721Receiver.onERC721Received.selector;
1406             } catch (bytes memory reason) {
1407                 if (reason.length == 0) {
1408                     revert("ERC721: transfer to non ERC721Receiver implementer");
1409                 } else {
1410                     assembly {
1411                         revert(add(32, reason), mload(reason))
1412                     }
1413                 }
1414             }
1415         } else {
1416             return true;
1417         }
1418     }
1419 
1420     /**
1421      * @dev Hook that is called before any token transfer. This includes minting
1422      * and burning.
1423      *
1424      * Calling conditions:
1425      *
1426      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1427      * transferred to `to`.
1428      * - When `from` is zero, `tokenId` will be minted for `to`.
1429      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1430      * - `from` and `to` are never both zero.
1431      *
1432      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1433      */
1434     function _beforeTokenTransfer(
1435         address from,
1436         address to,
1437         uint256 tokenId
1438     ) internal virtual {}
1439 }
1440 
1441 
1442 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
1443 
1444 pragma solidity ^0.8.0;
1445 
1446 /**
1447  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1448  * @dev See https://eips.ethereum.org/EIPS/eip-721
1449  */
1450 interface IERC721Enumerable is IERC721 {
1451     /**
1452      * @dev Returns the total amount of tokens stored by the contract.
1453      */
1454     function totalSupply() external view returns (uint256);
1455 
1456     /**
1457      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1458      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1459      */
1460     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1461 
1462     /**
1463      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1464      * Use along with {totalSupply} to enumerate all tokens.
1465      */
1466     function tokenByIndex(uint256 index) external view returns (uint256);
1467 }
1468 
1469 
1470 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
1471 
1472 pragma solidity ^0.8.0;
1473 
1474 
1475 /**
1476  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1477  * enumerability of all the token ids in the contract as well as all token ids owned by each
1478  * account.
1479  */
1480 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1481     // Mapping from owner to list of owned token IDs
1482     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1483 
1484     // Mapping from token ID to index of the owner tokens list
1485     mapping(uint256 => uint256) private _ownedTokensIndex;
1486 
1487     // Array with all token ids, used for enumeration
1488     uint256[] private _allTokens;
1489 
1490     // Mapping from token id to position in the allTokens array
1491     mapping(uint256 => uint256) private _allTokensIndex;
1492 
1493     /**
1494      * @dev See {IERC165-supportsInterface}.
1495      */
1496     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1497         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1498     }
1499 
1500     /**
1501      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1502      */
1503     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1504         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1505         return _ownedTokens[owner][index];
1506     }
1507 
1508     /**
1509      * @dev See {IERC721Enumerable-totalSupply}.
1510      */
1511     function totalSupply() public view virtual override returns (uint256) {
1512         return _allTokens.length;
1513     }
1514 
1515     /**
1516      * @dev See {IERC721Enumerable-tokenByIndex}.
1517      */
1518     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1519         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1520         return _allTokens[index];
1521     }
1522 
1523     /**
1524      * @dev Hook that is called before any token transfer. This includes minting
1525      * and burning.
1526      *
1527      * Calling conditions:
1528      *
1529      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1530      * transferred to `to`.
1531      * - When `from` is zero, `tokenId` will be minted for `to`.
1532      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1533      * - `from` cannot be the zero address.
1534      * - `to` cannot be the zero address.
1535      *
1536      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1537      */
1538     function _beforeTokenTransfer(
1539         address from,
1540         address to,
1541         uint256 tokenId
1542     ) internal virtual override {
1543         super._beforeTokenTransfer(from, to, tokenId);
1544 
1545         if (from == address(0)) {
1546             _addTokenToAllTokensEnumeration(tokenId);
1547         } else if (from != to) {
1548             _removeTokenFromOwnerEnumeration(from, tokenId);
1549         }
1550         if (to == address(0)) {
1551             _removeTokenFromAllTokensEnumeration(tokenId);
1552         } else if (to != from) {
1553             _addTokenToOwnerEnumeration(to, tokenId);
1554         }
1555     }
1556 
1557     /**
1558      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1559      * @param to address representing the new owner of the given token ID
1560      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1561      */
1562     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1563         uint256 length = ERC721.balanceOf(to);
1564         _ownedTokens[to][length] = tokenId;
1565         _ownedTokensIndex[tokenId] = length;
1566     }
1567 
1568     /**
1569      * @dev Private function to add a token to this extension's token tracking data structures.
1570      * @param tokenId uint256 ID of the token to be added to the tokens list
1571      */
1572     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1573         _allTokensIndex[tokenId] = _allTokens.length;
1574         _allTokens.push(tokenId);
1575     }
1576 
1577     /**
1578      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1579      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1580      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1581      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1582      * @param from address representing the previous owner of the given token ID
1583      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1584      */
1585     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1586         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1587         // then delete the last slot (swap and pop).
1588 
1589         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1590         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1591 
1592         // When the token to delete is the last token, the swap operation is unnecessary
1593         if (tokenIndex != lastTokenIndex) {
1594             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1595 
1596             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1597             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1598         }
1599 
1600         // This also deletes the contents at the last position of the array
1601         delete _ownedTokensIndex[tokenId];
1602         delete _ownedTokens[from][lastTokenIndex];
1603     }
1604 
1605     /**
1606      * @dev Private function to remove a token from this extension's token tracking data structures.
1607      * This has O(1) time complexity, but alters the order of the _allTokens array.
1608      * @param tokenId uint256 ID of the token to be removed from the tokens list
1609      */
1610     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1611         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1612         // then delete the last slot (swap and pop).
1613 
1614         uint256 lastTokenIndex = _allTokens.length - 1;
1615         uint256 tokenIndex = _allTokensIndex[tokenId];
1616 
1617         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1618         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1619         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1620         uint256 lastTokenId = _allTokens[lastTokenIndex];
1621 
1622         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1623         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1624 
1625         // This also deletes the contents at the last position of the array
1626         delete _allTokensIndex[tokenId];
1627         _allTokens.pop();
1628     }
1629 }
1630 
1631 
1632 // File @openzeppelin/contracts/utils/math/Math.sol@v4.3.1
1633 
1634 pragma solidity ^0.8.0;
1635 
1636 /**
1637  * @dev Standard math utilities missing in the Solidity language.
1638  */
1639 library Math {
1640     /**
1641      * @dev Returns the largest of two numbers.
1642      */
1643     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1644         return a >= b ? a : b;
1645     }
1646 
1647     /**
1648      * @dev Returns the smallest of two numbers.
1649      */
1650     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1651         return a < b ? a : b;
1652     }
1653 
1654     /**
1655      * @dev Returns the average of two numbers. The result is rounded towards
1656      * zero.
1657      */
1658     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1659         // (a + b) / 2 can overflow.
1660         return (a & b) + (a ^ b) / 2;
1661     }
1662 
1663     /**
1664      * @dev Returns the ceiling of the division of two numbers.
1665      *
1666      * This differs from standard division with `/` in that it rounds up instead
1667      * of rounding down.
1668      */
1669     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1670         // (a + b - 1) / b can overflow on addition, so we distribute.
1671         return a / b + (a % b == 0 ? 0 : 1);
1672     }
1673 }
1674 
1675 
1676 // File contracts/WickedToken.sol
1677 pragma solidity ^0.8.0;
1678 
1679 
1680 
1681 contract WickedToken is ERC20 {
1682     uint256 public immutable WICKED_PER_SECOND_PER_APE = 115740 gwei;
1683     uint256 public immutable GENESIS = 1631905200;
1684     IERC721Enumerable public immutable APE;
1685 
1686     mapping(uint256 => uint256) public last;
1687 
1688     constructor(address ape) ERC20("Wicked", "WCKD") {
1689         APE = IERC721Enumerable(ape);
1690     }
1691 
1692     function mintForUser(address user) external {
1693         uint256 total = APE.balanceOf(user);
1694         uint256 owed = 0;
1695         for (uint256 i = 0; i < total; i++) {
1696             uint256 id = APE.tokenOfOwnerByIndex(user, i);
1697             uint256 claimed = lastClaim(id);
1698             owed += ((block.timestamp - claimed) * WICKED_PER_SECOND_PER_APE);
1699             last[id] = block.timestamp;
1700         }
1701         _mint(user, owed);
1702     }
1703 
1704     function mintForIds(uint256[] calldata ids) external {
1705         for (uint256 i = 0; i < ids.length; i++) {
1706             uint256 id = ids[i];
1707             address owner = APE.ownerOf(id);
1708             uint256 claimed = lastClaim(id);
1709             uint256 owed = (block.timestamp - claimed) * WICKED_PER_SECOND_PER_APE;
1710             _mint(owner, owed);
1711             last[id] = block.timestamp;
1712         }
1713     }
1714 
1715     function lastClaim(uint256 id) public view returns (uint256) {
1716         return Math.max(last[id], GENESIS);
1717     }
1718 }