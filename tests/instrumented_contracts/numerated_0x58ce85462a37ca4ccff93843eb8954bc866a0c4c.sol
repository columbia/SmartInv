1 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.1
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
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
86 
87 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.1
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Interface for the optional metadata functions from the ERC20 standard.
93  *
94  * _Available since v4.1._
95  */
96 interface IERC20Metadata is IERC20 {
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() external view returns (string memory);
101 
102     /**
103      * @dev Returns the symbol of the token.
104      */
105     function symbol() external view returns (string memory);
106 
107     /**
108      * @dev Returns the decimals places of the token.
109      */
110     function decimals() external view returns (uint8);
111 }
112 
113 
114 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Provides information about the current execution context, including the
120  * sender of the transaction and its data. While these are generally available
121  * via msg.sender and msg.data, they should not be accessed in such a direct
122  * manner, since when dealing with meta-transactions the account sending and
123  * paying for execution may not be the actual sender (as far as an application
124  * is concerned).
125  *
126  * This contract is only required for intermediate, library-like contracts.
127  */
128 abstract contract Context {
129     function _msgSender() internal view virtual returns (address) {
130         return msg.sender;
131     }
132 
133     function _msgData() internal view virtual returns (bytes calldata) {
134         return msg.data;
135     }
136 }
137 
138 
139 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.1
140 
141 pragma solidity ^0.8.0;
142 
143 
144 
145 /**
146  * @dev Implementation of the {IERC20} interface.
147  *
148  * This implementation is agnostic to the way tokens are created. This means
149  * that a supply mechanism has to be added in a derived contract using {_mint}.
150  * For a generic mechanism see {ERC20PresetMinterPauser}.
151  *
152  * TIP: For a detailed writeup see our guide
153  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
154  * to implement supply mechanisms].
155  *
156  * We have followed general OpenZeppelin Contracts guidelines: functions revert
157  * instead returning `false` on failure. This behavior is nonetheless
158  * conventional and does not conflict with the expectations of ERC20
159  * applications.
160  *
161  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
162  * This allows applications to reconstruct the allowance for all accounts just
163  * by listening to said events. Other implementations of the EIP may not emit
164  * these events, as it isn't required by the specification.
165  *
166  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
167  * functions have been added to mitigate the well-known issues around setting
168  * allowances. See {IERC20-approve}.
169  */
170 contract ERC20 is Context, IERC20, IERC20Metadata {
171     mapping(address => uint256) private _balances;
172 
173     mapping(address => mapping(address => uint256)) private _allowances;
174 
175     uint256 private _totalSupply;
176 
177     string private _name;
178     string private _symbol;
179 
180     /**
181      * @dev Sets the values for {name} and {symbol}.
182      *
183      * The default value of {decimals} is 18. To select a different value for
184      * {decimals} you should overload it.
185      *
186      * All two of these values are immutable: they can only be set once during
187      * construction.
188      */
189     constructor(string memory name_, string memory symbol_) {
190         _name = name_;
191         _symbol = symbol_;
192     }
193 
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() public view virtual override returns (string memory) {
198         return _name;
199     }
200 
201     /**
202      * @dev Returns the symbol of the token, usually a shorter version of the
203      * name.
204      */
205     function symbol() public view virtual override returns (string memory) {
206         return _symbol;
207     }
208 
209     /**
210      * @dev Returns the number of decimals used to get its user representation.
211      * For example, if `decimals` equals `2`, a balance of `505` tokens should
212      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
213      *
214      * Tokens usually opt for a value of 18, imitating the relationship between
215      * Ether and Wei. This is the value {ERC20} uses, unless this function is
216      * overridden;
217      *
218      * NOTE: This information is only used for _display_ purposes: it in
219      * no way affects any of the arithmetic of the contract, including
220      * {IERC20-balanceOf} and {IERC20-transfer}.
221      */
222     function decimals() public view virtual override returns (uint8) {
223         return 18;
224     }
225 
226     /**
227      * @dev See {IERC20-totalSupply}.
228      */
229     function totalSupply() public view virtual override returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234      * @dev See {IERC20-balanceOf}.
235      */
236     function balanceOf(address account) public view virtual override returns (uint256) {
237         return _balances[account];
238     }
239 
240     /**
241      * @dev See {IERC20-transfer}.
242      *
243      * Requirements:
244      *
245      * - `recipient` cannot be the zero address.
246      * - the caller must have a balance of at least `amount`.
247      */
248     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender) public view virtual override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See {IERC20-approve}.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function approve(address spender, uint256 amount) public virtual override returns (bool) {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     /**
273      * @dev See {IERC20-transferFrom}.
274      *
275      * Emits an {Approval} event indicating the updated allowance. This is not
276      * required by the EIP. See the note at the beginning of {ERC20}.
277      *
278      * Requirements:
279      *
280      * - `sender` and `recipient` cannot be the zero address.
281      * - `sender` must have a balance of at least `amount`.
282      * - the caller must have allowance for ``sender``'s tokens of at least
283      * `amount`.
284      */
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) public virtual override returns (bool) {
290         _transfer(sender, recipient, amount);
291 
292         uint256 currentAllowance = _allowances[sender][_msgSender()];
293         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
294         unchecked {
295             _approve(sender, _msgSender(), currentAllowance - amount);
296         }
297 
298         return true;
299     }
300 
301     /**
302      * @dev Atomically increases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
314         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
315         return true;
316     }
317 
318     /**
319      * @dev Atomically decreases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      * - `spender` must have allowance for the caller of at least
330      * `subtractedValue`.
331      */
332     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
333         uint256 currentAllowance = _allowances[_msgSender()][spender];
334         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
335         unchecked {
336             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
337         }
338 
339         return true;
340     }
341 
342     /**
343      * @dev Moves `amount` of tokens from `sender` to `recipient`.
344      *
345      * This internal function is equivalent to {transfer}, and can be used to
346      * e.g. implement automatic token fees, slashing mechanisms, etc.
347      *
348      * Emits a {Transfer} event.
349      *
350      * Requirements:
351      *
352      * - `sender` cannot be the zero address.
353      * - `recipient` cannot be the zero address.
354      * - `sender` must have a balance of at least `amount`.
355      */
356     function _transfer(
357         address sender,
358         address recipient,
359         uint256 amount
360     ) internal virtual {
361         require(sender != address(0), "ERC20: transfer from the zero address");
362         require(recipient != address(0), "ERC20: transfer to the zero address");
363 
364         _beforeTokenTransfer(sender, recipient, amount);
365 
366         uint256 senderBalance = _balances[sender];
367         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
368         unchecked {
369             _balances[sender] = senderBalance - amount;
370         }
371         _balances[recipient] += amount;
372 
373         emit Transfer(sender, recipient, amount);
374 
375         _afterTokenTransfer(sender, recipient, amount);
376     }
377 
378     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
379      * the total supply.
380      *
381      * Emits a {Transfer} event with `from` set to the zero address.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      */
387     function _mint(address account, uint256 amount) internal virtual {
388         require(account != address(0), "ERC20: mint to the zero address");
389 
390         _beforeTokenTransfer(address(0), account, amount);
391 
392         _totalSupply += amount;
393         _balances[account] += amount;
394         emit Transfer(address(0), account, amount);
395 
396         _afterTokenTransfer(address(0), account, amount);
397     }
398 
399     /**
400      * @dev Destroys `amount` tokens from `account`, reducing the
401      * total supply.
402      *
403      * Emits a {Transfer} event with `to` set to the zero address.
404      *
405      * Requirements:
406      *
407      * - `account` cannot be the zero address.
408      * - `account` must have at least `amount` tokens.
409      */
410     function _burn(address account, uint256 amount) internal virtual {
411         require(account != address(0), "ERC20: burn from the zero address");
412 
413         _beforeTokenTransfer(account, address(0), amount);
414 
415         uint256 accountBalance = _balances[account];
416         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
417         unchecked {
418             _balances[account] = accountBalance - amount;
419         }
420         _totalSupply -= amount;
421 
422         emit Transfer(account, address(0), amount);
423 
424         _afterTokenTransfer(account, address(0), amount);
425     }
426 
427     /**
428      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
429      *
430      * This internal function is equivalent to `approve`, and can be used to
431      * e.g. set automatic allowances for certain subsystems, etc.
432      *
433      * Emits an {Approval} event.
434      *
435      * Requirements:
436      *
437      * - `owner` cannot be the zero address.
438      * - `spender` cannot be the zero address.
439      */
440     function _approve(
441         address owner,
442         address spender,
443         uint256 amount
444     ) internal virtual {
445         require(owner != address(0), "ERC20: approve from the zero address");
446         require(spender != address(0), "ERC20: approve to the zero address");
447 
448         _allowances[owner][spender] = amount;
449         emit Approval(owner, spender, amount);
450     }
451 
452     /**
453      * @dev Hook that is called before any transfer of tokens. This includes
454      * minting and burning.
455      *
456      * Calling conditions:
457      *
458      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
459      * will be transferred to `to`.
460      * - when `from` is zero, `amount` tokens will be minted for `to`.
461      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
462      * - `from` and `to` are never both zero.
463      *
464      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
465      */
466     function _beforeTokenTransfer(
467         address from,
468         address to,
469         uint256 amount
470     ) internal virtual {}
471 
472     /**
473      * @dev Hook that is called after any transfer of tokens. This includes
474      * minting and burning.
475      *
476      * Calling conditions:
477      *
478      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
479      * has been transferred to `to`.
480      * - when `from` is zero, `amount` tokens have been minted for `to`.
481      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
482      * - `from` and `to` are never both zero.
483      *
484      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
485      */
486     function _afterTokenTransfer(
487         address from,
488         address to,
489         uint256 amount
490     ) internal virtual {}
491 }
492 
493 
494 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev Interface of the ERC165 standard, as defined in the
500  * https://eips.ethereum.org/EIPS/eip-165[EIP].
501  *
502  * Implementers can declare support of contract interfaces, which can then be
503  * queried by others ({ERC165Checker}).
504  *
505  * For an implementation, see {ERC165}.
506  */
507 interface IERC165 {
508     /**
509      * @dev Returns true if this contract implements the interface defined by
510      * `interfaceId`. See the corresponding
511      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
512      * to learn more about how these ids are created.
513      *
514      * This function call must use less than 30 000 gas.
515      */
516     function supportsInterface(bytes4 interfaceId) external view returns (bool);
517 }
518 
519 
520 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @dev Required interface of an ERC721 compliant contract.
526  */
527 interface IERC721 is IERC165 {
528     /**
529      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
530      */
531     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
532 
533     /**
534      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
535      */
536     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
537 
538     /**
539      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
540      */
541     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
542 
543     /**
544      * @dev Returns the number of tokens in ``owner``'s account.
545      */
546     function balanceOf(address owner) external view returns (uint256 balance);
547 
548     /**
549      * @dev Returns the owner of the `tokenId` token.
550      *
551      * Requirements:
552      *
553      * - `tokenId` must exist.
554      */
555     function ownerOf(uint256 tokenId) external view returns (address owner);
556 
557     /**
558      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
559      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
560      *
561      * Requirements:
562      *
563      * - `from` cannot be the zero address.
564      * - `to` cannot be the zero address.
565      * - `tokenId` token must exist and be owned by `from`.
566      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
567      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
568      *
569      * Emits a {Transfer} event.
570      */
571     function safeTransferFrom(
572         address from,
573         address to,
574         uint256 tokenId
575     ) external;
576 
577     /**
578      * @dev Transfers `tokenId` token from `from` to `to`.
579      *
580      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
581      *
582      * Requirements:
583      *
584      * - `from` cannot be the zero address.
585      * - `to` cannot be the zero address.
586      * - `tokenId` token must be owned by `from`.
587      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
588      *
589      * Emits a {Transfer} event.
590      */
591     function transferFrom(
592         address from,
593         address to,
594         uint256 tokenId
595     ) external;
596 
597     /**
598      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
599      * The approval is cleared when the token is transferred.
600      *
601      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
602      *
603      * Requirements:
604      *
605      * - The caller must own the token or be an approved operator.
606      * - `tokenId` must exist.
607      *
608      * Emits an {Approval} event.
609      */
610     function approve(address to, uint256 tokenId) external;
611 
612     /**
613      * @dev Returns the account approved for `tokenId` token.
614      *
615      * Requirements:
616      *
617      * - `tokenId` must exist.
618      */
619     function getApproved(uint256 tokenId) external view returns (address operator);
620 
621     /**
622      * @dev Approve or remove `operator` as an operator for the caller.
623      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
624      *
625      * Requirements:
626      *
627      * - The `operator` cannot be the caller.
628      *
629      * Emits an {ApprovalForAll} event.
630      */
631     function setApprovalForAll(address operator, bool _approved) external;
632 
633     /**
634      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
635      *
636      * See {setApprovalForAll}
637      */
638     function isApprovedForAll(address owner, address operator) external view returns (bool);
639 
640     /**
641      * @dev Safely transfers `tokenId` token from `from` to `to`.
642      *
643      * Requirements:
644      *
645      * - `from` cannot be the zero address.
646      * - `to` cannot be the zero address.
647      * - `tokenId` token must exist and be owned by `from`.
648      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
649      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
650      *
651      * Emits a {Transfer} event.
652      */
653     function safeTransferFrom(
654         address from,
655         address to,
656         uint256 tokenId,
657         bytes calldata data
658     ) external;
659 }
660 
661 
662 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
663 
664 pragma solidity ^0.8.0;
665 
666 /**
667  * @title ERC721 token receiver interface
668  * @dev Interface for any contract that wants to support safeTransfers
669  * from ERC721 asset contracts.
670  */
671 interface IERC721Receiver {
672     /**
673      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
674      * by `operator` from `from`, this function is called.
675      *
676      * It must return its Solidity selector to confirm the token transfer.
677      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
678      *
679      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
680      */
681     function onERC721Received(
682         address operator,
683         address from,
684         uint256 tokenId,
685         bytes calldata data
686     ) external returns (bytes4);
687 }
688 
689 
690 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
696  * @dev See https://eips.ethereum.org/EIPS/eip-721
697  */
698 interface IERC721Metadata is IERC721 {
699     /**
700      * @dev Returns the token collection name.
701      */
702     function name() external view returns (string memory);
703 
704     /**
705      * @dev Returns the token collection symbol.
706      */
707     function symbol() external view returns (string memory);
708 
709     /**
710      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
711      */
712     function tokenURI(uint256 tokenId) external view returns (string memory);
713 }
714 
715 
716 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
717 
718 pragma solidity ^0.8.0;
719 
720 /**
721  * @dev Collection of functions related to the address type
722  */
723 library Address {
724     /**
725      * @dev Returns true if `account` is a contract.
726      *
727      * [IMPORTANT]
728      * ====
729      * It is unsafe to assume that an address for which this function returns
730      * false is an externally-owned account (EOA) and not a contract.
731      *
732      * Among others, `isContract` will return false for the following
733      * types of addresses:
734      *
735      *  - an externally-owned account
736      *  - a contract in construction
737      *  - an address where a contract will be created
738      *  - an address where a contract lived, but was destroyed
739      * ====
740      */
741     function isContract(address account) internal view returns (bool) {
742         // This method relies on extcodesize, which returns 0 for contracts in
743         // construction, since the code is only stored at the end of the
744         // constructor execution.
745 
746         uint256 size;
747         assembly {
748             size := extcodesize(account)
749         }
750         return size > 0;
751     }
752 
753     /**
754      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
755      * `recipient`, forwarding all available gas and reverting on errors.
756      *
757      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
758      * of certain opcodes, possibly making contracts go over the 2300 gas limit
759      * imposed by `transfer`, making them unable to receive funds via
760      * `transfer`. {sendValue} removes this limitation.
761      *
762      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
763      *
764      * IMPORTANT: because control is transferred to `recipient`, care must be
765      * taken to not create reentrancy vulnerabilities. Consider using
766      * {ReentrancyGuard} or the
767      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
768      */
769     function sendValue(address payable recipient, uint256 amount) internal {
770         require(address(this).balance >= amount, "Address: insufficient balance");
771 
772         (bool success, ) = recipient.call{value: amount}("");
773         require(success, "Address: unable to send value, recipient may have reverted");
774     }
775 
776     /**
777      * @dev Performs a Solidity function call using a low level `call`. A
778      * plain `call` is an unsafe replacement for a function call: use this
779      * function instead.
780      *
781      * If `target` reverts with a revert reason, it is bubbled up by this
782      * function (like regular Solidity function calls).
783      *
784      * Returns the raw returned data. To convert to the expected return value,
785      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
786      *
787      * Requirements:
788      *
789      * - `target` must be a contract.
790      * - calling `target` with `data` must not revert.
791      *
792      * _Available since v3.1._
793      */
794     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
795         return functionCall(target, data, "Address: low-level call failed");
796     }
797 
798     /**
799      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
800      * `errorMessage` as a fallback revert reason when `target` reverts.
801      *
802      * _Available since v3.1._
803      */
804     function functionCall(
805         address target,
806         bytes memory data,
807         string memory errorMessage
808     ) internal returns (bytes memory) {
809         return functionCallWithValue(target, data, 0, errorMessage);
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
814      * but also transferring `value` wei to `target`.
815      *
816      * Requirements:
817      *
818      * - the calling contract must have an ETH balance of at least `value`.
819      * - the called Solidity function must be `payable`.
820      *
821      * _Available since v3.1._
822      */
823     function functionCallWithValue(
824         address target,
825         bytes memory data,
826         uint256 value
827     ) internal returns (bytes memory) {
828         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
829     }
830 
831     /**
832      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
833      * with `errorMessage` as a fallback revert reason when `target` reverts.
834      *
835      * _Available since v3.1._
836      */
837     function functionCallWithValue(
838         address target,
839         bytes memory data,
840         uint256 value,
841         string memory errorMessage
842     ) internal returns (bytes memory) {
843         require(address(this).balance >= value, "Address: insufficient balance for call");
844         require(isContract(target), "Address: call to non-contract");
845 
846         (bool success, bytes memory returndata) = target.call{value: value}(data);
847         return verifyCallResult(success, returndata, errorMessage);
848     }
849 
850     /**
851      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
852      * but performing a static call.
853      *
854      * _Available since v3.3._
855      */
856     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
857         return functionStaticCall(target, data, "Address: low-level static call failed");
858     }
859 
860     /**
861      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
862      * but performing a static call.
863      *
864      * _Available since v3.3._
865      */
866     function functionStaticCall(
867         address target,
868         bytes memory data,
869         string memory errorMessage
870     ) internal view returns (bytes memory) {
871         require(isContract(target), "Address: static call to non-contract");
872 
873         (bool success, bytes memory returndata) = target.staticcall(data);
874         return verifyCallResult(success, returndata, errorMessage);
875     }
876 
877     /**
878      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
879      * but performing a delegate call.
880      *
881      * _Available since v3.4._
882      */
883     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
884         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
885     }
886 
887     /**
888      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
889      * but performing a delegate call.
890      *
891      * _Available since v3.4._
892      */
893     function functionDelegateCall(
894         address target,
895         bytes memory data,
896         string memory errorMessage
897     ) internal returns (bytes memory) {
898         require(isContract(target), "Address: delegate call to non-contract");
899 
900         (bool success, bytes memory returndata) = target.delegatecall(data);
901         return verifyCallResult(success, returndata, errorMessage);
902     }
903 
904     /**
905      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
906      * revert reason using the provided one.
907      *
908      * _Available since v4.3._
909      */
910     function verifyCallResult(
911         bool success,
912         bytes memory returndata,
913         string memory errorMessage
914     ) internal pure returns (bytes memory) {
915         if (success) {
916             return returndata;
917         } else {
918             // Look for revert reason and bubble it up if present
919             if (returndata.length > 0) {
920                 // The easiest way to bubble the revert reason is using memory via assembly
921 
922                 assembly {
923                     let returndata_size := mload(returndata)
924                     revert(add(32, returndata), returndata_size)
925                 }
926             } else {
927                 revert(errorMessage);
928             }
929         }
930     }
931 }
932 
933 
934 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
935 
936 pragma solidity ^0.8.0;
937 
938 /**
939  * @dev String operations.
940  */
941 library Strings {
942     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
943 
944     /**
945      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
946      */
947     function toString(uint256 value) internal pure returns (string memory) {
948         // Inspired by OraclizeAPI's implementation - MIT licence
949         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
950 
951         if (value == 0) {
952             return "0";
953         }
954         uint256 temp = value;
955         uint256 digits;
956         while (temp != 0) {
957             digits++;
958             temp /= 10;
959         }
960         bytes memory buffer = new bytes(digits);
961         while (value != 0) {
962             digits -= 1;
963             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
964             value /= 10;
965         }
966         return string(buffer);
967     }
968 
969     /**
970      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
971      */
972     function toHexString(uint256 value) internal pure returns (string memory) {
973         if (value == 0) {
974             return "0x00";
975         }
976         uint256 temp = value;
977         uint256 length = 0;
978         while (temp != 0) {
979             length++;
980             temp >>= 8;
981         }
982         return toHexString(value, length);
983     }
984 
985     /**
986      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
987      */
988     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
989         bytes memory buffer = new bytes(2 * length + 2);
990         buffer[0] = "0";
991         buffer[1] = "x";
992         for (uint256 i = 2 * length + 1; i > 1; --i) {
993             buffer[i] = _HEX_SYMBOLS[value & 0xf];
994             value >>= 4;
995         }
996         require(value == 0, "Strings: hex length insufficient");
997         return string(buffer);
998     }
999 }
1000 
1001 
1002 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
1003 
1004 pragma solidity ^0.8.0;
1005 
1006 /**
1007  * @dev Implementation of the {IERC165} interface.
1008  *
1009  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1010  * for the additional interface id that will be supported. For example:
1011  *
1012  * ```solidity
1013  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1014  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1015  * }
1016  * ```
1017  *
1018  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1019  */
1020 abstract contract ERC165 is IERC165 {
1021     /**
1022      * @dev See {IERC165-supportsInterface}.
1023      */
1024     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1025         return interfaceId == type(IERC165).interfaceId;
1026     }
1027 }
1028 
1029 
1030 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
1031 
1032 pragma solidity ^0.8.0;
1033 
1034 
1035 
1036 
1037 
1038 
1039 
1040 /**
1041  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1042  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1043  * {ERC721Enumerable}.
1044  */
1045 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1046     using Address for address;
1047     using Strings for uint256;
1048 
1049     // Token name
1050     string private _name;
1051 
1052     // Token symbol
1053     string private _symbol;
1054 
1055     // Mapping from token ID to owner address
1056     mapping(uint256 => address) private _owners;
1057 
1058     // Mapping owner address to token count
1059     mapping(address => uint256) private _balances;
1060 
1061     // Mapping from token ID to approved address
1062     mapping(uint256 => address) private _tokenApprovals;
1063 
1064     // Mapping from owner to operator approvals
1065     mapping(address => mapping(address => bool)) private _operatorApprovals;
1066 
1067     /**
1068      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1069      */
1070     constructor(string memory name_, string memory symbol_) {
1071         _name = name_;
1072         _symbol = symbol_;
1073     }
1074 
1075     /**
1076      * @dev See {IERC165-supportsInterface}.
1077      */
1078     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1079         return
1080             interfaceId == type(IERC721).interfaceId ||
1081             interfaceId == type(IERC721Metadata).interfaceId ||
1082             super.supportsInterface(interfaceId);
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-balanceOf}.
1087      */
1088     function balanceOf(address owner) public view virtual override returns (uint256) {
1089         require(owner != address(0), "ERC721: balance query for the zero address");
1090         return _balances[owner];
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-ownerOf}.
1095      */
1096     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1097         address owner = _owners[tokenId];
1098         require(owner != address(0), "ERC721: owner query for nonexistent token");
1099         return owner;
1100     }
1101 
1102     /**
1103      * @dev See {IERC721Metadata-name}.
1104      */
1105     function name() public view virtual override returns (string memory) {
1106         return _name;
1107     }
1108 
1109     /**
1110      * @dev See {IERC721Metadata-symbol}.
1111      */
1112     function symbol() public view virtual override returns (string memory) {
1113         return _symbol;
1114     }
1115 
1116     /**
1117      * @dev See {IERC721Metadata-tokenURI}.
1118      */
1119     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1120         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1121 
1122         string memory baseURI = _baseURI();
1123         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1124     }
1125 
1126     /**
1127      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1128      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1129      * by default, can be overriden in child contracts.
1130      */
1131     function _baseURI() internal view virtual returns (string memory) {
1132         return "";
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-approve}.
1137      */
1138     function approve(address to, uint256 tokenId) public virtual override {
1139         address owner = ERC721.ownerOf(tokenId);
1140         require(to != owner, "ERC721: approval to current owner");
1141 
1142         require(
1143             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1144             "ERC721: approve caller is not owner nor approved for all"
1145         );
1146 
1147         _approve(to, tokenId);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-getApproved}.
1152      */
1153     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1154         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1155 
1156         return _tokenApprovals[tokenId];
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-setApprovalForAll}.
1161      */
1162     function setApprovalForAll(address operator, bool approved) public virtual override {
1163         require(operator != _msgSender(), "ERC721: approve to caller");
1164 
1165         _operatorApprovals[_msgSender()][operator] = approved;
1166         emit ApprovalForAll(_msgSender(), operator, approved);
1167     }
1168 
1169     /**
1170      * @dev See {IERC721-isApprovedForAll}.
1171      */
1172     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1173         return _operatorApprovals[owner][operator];
1174     }
1175 
1176     /**
1177      * @dev See {IERC721-transferFrom}.
1178      */
1179     function transferFrom(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) public virtual override {
1184         //solhint-disable-next-line max-line-length
1185         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1186 
1187         _transfer(from, to, tokenId);
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-safeTransferFrom}.
1192      */
1193     function safeTransferFrom(
1194         address from,
1195         address to,
1196         uint256 tokenId
1197     ) public virtual override {
1198         safeTransferFrom(from, to, tokenId, "");
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-safeTransferFrom}.
1203      */
1204     function safeTransferFrom(
1205         address from,
1206         address to,
1207         uint256 tokenId,
1208         bytes memory _data
1209     ) public virtual override {
1210         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1211         _safeTransfer(from, to, tokenId, _data);
1212     }
1213 
1214     /**
1215      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1216      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1217      *
1218      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1219      *
1220      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1221      * implement alternative mechanisms to perform token transfer, such as signature-based.
1222      *
1223      * Requirements:
1224      *
1225      * - `from` cannot be the zero address.
1226      * - `to` cannot be the zero address.
1227      * - `tokenId` token must exist and be owned by `from`.
1228      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _safeTransfer(
1233         address from,
1234         address to,
1235         uint256 tokenId,
1236         bytes memory _data
1237     ) internal virtual {
1238         _transfer(from, to, tokenId);
1239         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1240     }
1241 
1242     /**
1243      * @dev Returns whether `tokenId` exists.
1244      *
1245      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1246      *
1247      * Tokens start existing when they are minted (`_mint`),
1248      * and stop existing when they are burned (`_burn`).
1249      */
1250     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1251         return _owners[tokenId] != address(0);
1252     }
1253 
1254     /**
1255      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1256      *
1257      * Requirements:
1258      *
1259      * - `tokenId` must exist.
1260      */
1261     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1262         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1263         address owner = ERC721.ownerOf(tokenId);
1264         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1265     }
1266 
1267     /**
1268      * @dev Safely mints `tokenId` and transfers it to `to`.
1269      *
1270      * Requirements:
1271      *
1272      * - `tokenId` must not exist.
1273      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1274      *
1275      * Emits a {Transfer} event.
1276      */
1277     function _safeMint(address to, uint256 tokenId) internal virtual {
1278         _safeMint(to, tokenId, "");
1279     }
1280 
1281     /**
1282      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1283      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1284      */
1285     function _safeMint(
1286         address to,
1287         uint256 tokenId,
1288         bytes memory _data
1289     ) internal virtual {
1290         _mint(to, tokenId);
1291         require(
1292             _checkOnERC721Received(address(0), to, tokenId, _data),
1293             "ERC721: transfer to non ERC721Receiver implementer"
1294         );
1295     }
1296 
1297     /**
1298      * @dev Mints `tokenId` and transfers it to `to`.
1299      *
1300      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1301      *
1302      * Requirements:
1303      *
1304      * - `tokenId` must not exist.
1305      * - `to` cannot be the zero address.
1306      *
1307      * Emits a {Transfer} event.
1308      */
1309     function _mint(address to, uint256 tokenId) internal virtual {
1310         require(to != address(0), "ERC721: mint to the zero address");
1311         require(!_exists(tokenId), "ERC721: token already minted");
1312 
1313         _beforeTokenTransfer(address(0), to, tokenId);
1314 
1315         _balances[to] += 1;
1316         _owners[tokenId] = to;
1317 
1318         emit Transfer(address(0), to, tokenId);
1319     }
1320 
1321     /**
1322      * @dev Destroys `tokenId`.
1323      * The approval is cleared when the token is burned.
1324      *
1325      * Requirements:
1326      *
1327      * - `tokenId` must exist.
1328      *
1329      * Emits a {Transfer} event.
1330      */
1331     function _burn(uint256 tokenId) internal virtual {
1332         address owner = ERC721.ownerOf(tokenId);
1333 
1334         _beforeTokenTransfer(owner, address(0), tokenId);
1335 
1336         // Clear approvals
1337         _approve(address(0), tokenId);
1338 
1339         _balances[owner] -= 1;
1340         delete _owners[tokenId];
1341 
1342         emit Transfer(owner, address(0), tokenId);
1343     }
1344 
1345     /**
1346      * @dev Transfers `tokenId` from `from` to `to`.
1347      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1348      *
1349      * Requirements:
1350      *
1351      * - `to` cannot be the zero address.
1352      * - `tokenId` token must be owned by `from`.
1353      *
1354      * Emits a {Transfer} event.
1355      */
1356     function _transfer(
1357         address from,
1358         address to,
1359         uint256 tokenId
1360     ) internal virtual {
1361         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1362         require(to != address(0), "ERC721: transfer to the zero address");
1363 
1364         _beforeTokenTransfer(from, to, tokenId);
1365 
1366         // Clear approvals from the previous owner
1367         _approve(address(0), tokenId);
1368 
1369         _balances[from] -= 1;
1370         _balances[to] += 1;
1371         _owners[tokenId] = to;
1372 
1373         emit Transfer(from, to, tokenId);
1374     }
1375 
1376     /**
1377      * @dev Approve `to` to operate on `tokenId`
1378      *
1379      * Emits a {Approval} event.
1380      */
1381     function _approve(address to, uint256 tokenId) internal virtual {
1382         _tokenApprovals[tokenId] = to;
1383         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1384     }
1385 
1386     /**
1387      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1388      * The call is not executed if the target address is not a contract.
1389      *
1390      * @param from address representing the previous owner of the given token ID
1391      * @param to target address that will receive the tokens
1392      * @param tokenId uint256 ID of the token to be transferred
1393      * @param _data bytes optional data to send along with the call
1394      * @return bool whether the call correctly returned the expected magic value
1395      */
1396     function _checkOnERC721Received(
1397         address from,
1398         address to,
1399         uint256 tokenId,
1400         bytes memory _data
1401     ) private returns (bool) {
1402         if (to.isContract()) {
1403             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1404                 return retval == IERC721Receiver.onERC721Received.selector;
1405             } catch (bytes memory reason) {
1406                 if (reason.length == 0) {
1407                     revert("ERC721: transfer to non ERC721Receiver implementer");
1408                 } else {
1409                     assembly {
1410                         revert(add(32, reason), mload(reason))
1411                     }
1412                 }
1413             }
1414         } else {
1415             return true;
1416         }
1417     }
1418 
1419     /**
1420      * @dev Hook that is called before any token transfer. This includes minting
1421      * and burning.
1422      *
1423      * Calling conditions:
1424      *
1425      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1426      * transferred to `to`.
1427      * - When `from` is zero, `tokenId` will be minted for `to`.
1428      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1429      * - `from` and `to` are never both zero.
1430      *
1431      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1432      */
1433     function _beforeTokenTransfer(
1434         address from,
1435         address to,
1436         uint256 tokenId
1437     ) internal virtual {}
1438 }
1439 
1440 
1441 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
1442 
1443 pragma solidity ^0.8.0;
1444 
1445 /**
1446  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1447  * @dev See https://eips.ethereum.org/EIPS/eip-721
1448  */
1449 interface IERC721Enumerable is IERC721 {
1450     /**
1451      * @dev Returns the total amount of tokens stored by the contract.
1452      */
1453     function totalSupply() external view returns (uint256);
1454 
1455     /**
1456      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1457      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1458      */
1459     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1460 
1461     /**
1462      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1463      * Use along with {totalSupply} to enumerate all tokens.
1464      */
1465     function tokenByIndex(uint256 index) external view returns (uint256);
1466 }
1467 
1468 
1469 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
1470 
1471 pragma solidity ^0.8.0;
1472 
1473 
1474 /**
1475  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1476  * enumerability of all the token ids in the contract as well as all token ids owned by each
1477  * account.
1478  */
1479 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1480     // Mapping from owner to list of owned token IDs
1481     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1482 
1483     // Mapping from token ID to index of the owner tokens list
1484     mapping(uint256 => uint256) private _ownedTokensIndex;
1485 
1486     // Array with all token ids, used for enumeration
1487     uint256[] private _allTokens;
1488 
1489     // Mapping from token id to position in the allTokens array
1490     mapping(uint256 => uint256) private _allTokensIndex;
1491 
1492     /**
1493      * @dev See {IERC165-supportsInterface}.
1494      */
1495     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1496         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1497     }
1498 
1499     /**
1500      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1501      */
1502     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1503         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1504         return _ownedTokens[owner][index];
1505     }
1506 
1507     /**
1508      * @dev See {IERC721Enumerable-totalSupply}.
1509      */
1510     function totalSupply() public view virtual override returns (uint256) {
1511         return _allTokens.length;
1512     }
1513 
1514     /**
1515      * @dev See {IERC721Enumerable-tokenByIndex}.
1516      */
1517     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1518         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1519         return _allTokens[index];
1520     }
1521 
1522     /**
1523      * @dev Hook that is called before any token transfer. This includes minting
1524      * and burning.
1525      *
1526      * Calling conditions:
1527      *
1528      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1529      * transferred to `to`.
1530      * - When `from` is zero, `tokenId` will be minted for `to`.
1531      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1532      * - `from` cannot be the zero address.
1533      * - `to` cannot be the zero address.
1534      *
1535      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1536      */
1537     function _beforeTokenTransfer(
1538         address from,
1539         address to,
1540         uint256 tokenId
1541     ) internal virtual override {
1542         super._beforeTokenTransfer(from, to, tokenId);
1543 
1544         if (from == address(0)) {
1545             _addTokenToAllTokensEnumeration(tokenId);
1546         } else if (from != to) {
1547             _removeTokenFromOwnerEnumeration(from, tokenId);
1548         }
1549         if (to == address(0)) {
1550             _removeTokenFromAllTokensEnumeration(tokenId);
1551         } else if (to != from) {
1552             _addTokenToOwnerEnumeration(to, tokenId);
1553         }
1554     }
1555 
1556     /**
1557      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1558      * @param to address representing the new owner of the given token ID
1559      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1560      */
1561     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1562         uint256 length = ERC721.balanceOf(to);
1563         _ownedTokens[to][length] = tokenId;
1564         _ownedTokensIndex[tokenId] = length;
1565     }
1566 
1567     /**
1568      * @dev Private function to add a token to this extension's token tracking data structures.
1569      * @param tokenId uint256 ID of the token to be added to the tokens list
1570      */
1571     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1572         _allTokensIndex[tokenId] = _allTokens.length;
1573         _allTokens.push(tokenId);
1574     }
1575 
1576     /**
1577      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1578      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1579      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1580      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1581      * @param from address representing the previous owner of the given token ID
1582      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1583      */
1584     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1585         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1586         // then delete the last slot (swap and pop).
1587 
1588         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1589         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1590 
1591         // When the token to delete is the last token, the swap operation is unnecessary
1592         if (tokenIndex != lastTokenIndex) {
1593             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1594 
1595             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1596             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1597         }
1598 
1599         // This also deletes the contents at the last position of the array
1600         delete _ownedTokensIndex[tokenId];
1601         delete _ownedTokens[from][lastTokenIndex];
1602     }
1603 
1604     /**
1605      * @dev Private function to remove a token from this extension's token tracking data structures.
1606      * This has O(1) time complexity, but alters the order of the _allTokens array.
1607      * @param tokenId uint256 ID of the token to be removed from the tokens list
1608      */
1609     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1610         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1611         // then delete the last slot (swap and pop).
1612 
1613         uint256 lastTokenIndex = _allTokens.length - 1;
1614         uint256 tokenIndex = _allTokensIndex[tokenId];
1615 
1616         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1617         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1618         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1619         uint256 lastTokenId = _allTokens[lastTokenIndex];
1620 
1621         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1622         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1623 
1624         // This also deletes the contents at the last position of the array
1625         delete _allTokensIndex[tokenId];
1626         _allTokens.pop();
1627     }
1628 }
1629 
1630 
1631 // File @openzeppelin/contracts/utils/math/Math.sol@v4.3.1
1632 
1633 pragma solidity ^0.8.0;
1634 
1635 /**
1636  * @dev Standard math utilities missing in the Solidity language.
1637  */
1638 library Math {
1639     /**
1640      * @dev Returns the largest of two numbers.
1641      */
1642     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1643         return a >= b ? a : b;
1644     }
1645 
1646     /**
1647      * @dev Returns the smallest of two numbers.
1648      */
1649     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1650         return a < b ? a : b;
1651     }
1652 
1653     /**
1654      * @dev Returns the average of two numbers. The result is rounded towards
1655      * zero.
1656      */
1657     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1658         // (a + b) / 2 can overflow.
1659         return (a & b) + (a ^ b) / 2;
1660     }
1661 
1662     /**
1663      * @dev Returns the ceiling of the division of two numbers.
1664      *
1665      * This differs from standard division with `/` in that it rounds up instead
1666      * of rounding down.
1667      */
1668     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1669         // (a + b - 1) / b can overflow on addition, so we distribute.
1670         return a / b + (a % b == 0 ? 0 : 1);
1671     }
1672 }
1673 
1674 
1675 
1676 
1677 /**
1678  * @dev Contract module which provides a basic access control mechanism, where
1679  * there is an account (an owner) that can be granted exclusive access to
1680  * specific functions.
1681  *
1682  * By default, the owner account will be the one that deploys the contract. This
1683  * can later be changed with {transferOwnership}.
1684  *
1685  * This module is used through inheritance. It will make available the modifier
1686  * `onlyOwner`, which can be applied to your functions to restrict their use to
1687  * the owner.
1688  */
1689 abstract contract Ownable is Context {
1690     address private _owner;
1691 
1692     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1693 
1694     /**
1695      * @dev Initializes the contract setting the deployer as the initial owner.
1696      */
1697     constructor () {
1698         address msgSender = _msgSender();
1699         _owner = msgSender;
1700         emit OwnershipTransferred(address(0), msgSender);
1701     }
1702 
1703     /**
1704      * @dev Returns the address of the current owner.
1705      */
1706     function owner() public view virtual returns (address) {
1707         return _owner;
1708     }
1709 
1710     /**
1711      * @dev Throws if called by any account other than the owner.
1712      */
1713     modifier onlyOwner() {
1714         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1715         _;
1716     }
1717 
1718     /**
1719      * @dev Leaves the contract without owner. It will not be possible to call
1720      * `onlyOwner` functions anymore. Can only be called by the current owner.
1721      *
1722      * NOTE: Renouncing ownership will leave the contract without an owner,
1723      * thereby removing any functionality that is only available to the owner.
1724      */
1725     function renounceOwnership() public virtual onlyOwner {
1726         emit OwnershipTransferred(_owner, address(0));
1727         _owner = address(0);
1728     }
1729 
1730     /**
1731      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1732      * Can only be called by the current owner.
1733      */
1734     function transferOwnership(address newOwner) public virtual onlyOwner {
1735         require(newOwner != address(0), "Ownable: new owner is the zero address");
1736         emit OwnershipTransferred(_owner, newOwner);
1737         _owner = newOwner;
1738     }
1739 }
1740 
1741 
1742 
1743 
1744 // File contracts/AmberToken.sol
1745 pragma solidity ^0.8.0;
1746 
1747 
1748 contract AmberToken is ERC20, Ownable {
1749     uint256 public immutable AMBER_PER_SECOND_PER_DRAGON = 11574 gwei;
1750     // 19 November 2021 20:00:00 - 1637352000
1751     uint256 public immutable GENESIS = 1637352000;
1752 
1753 	// 30 October 2027 20:00:00 - 1824926400 (2171 days)
1754 	uint256 public immutable END = 1824926400;
1755 
1756     IERC721Enumerable public immutable DRAGONS;
1757     IERC721Enumerable public immutable GONS;
1758     IERC721Enumerable public immutable BBS;
1759     IERC721Enumerable public burnContract;
1760 
1761     mapping(uint256 => uint256) public last;
1762 
1763     constructor(address dragons, address gons, address bbs ) ERC20("Amber", "AMBER") {
1764         DRAGONS = IERC721Enumerable(dragons);
1765         GONS = IERC721Enumerable(gons);
1766         BBS = IERC721Enumerable(bbs);
1767     }
1768 
1769     function setBurnContract(address _contract) external onlyOwner {
1770         burnContract = IERC721Enumerable(_contract);
1771     }
1772 
1773     function getTotalAmberPerSecondPerDragon(address user) internal view returns(uint256) {
1774 
1775         uint256 total_GONS = GONS.balanceOf(user);
1776         uint256 total_BBS = BBS.balanceOf(user);
1777 
1778         if (total_GONS > 50) { total_GONS = 50; }
1779         if (total_BBS > 50) { total_BBS = 50; }
1780         uint256 GONS_BOOST = (total_GONS * AMBER_PER_SECOND_PER_DRAGON)/100; 
1781         uint256 BBS_BOOST = (total_BBS * AMBER_PER_SECOND_PER_DRAGON)/100;
1782         
1783         uint256 totalAmber_PerSecond_PerDragon = AMBER_PER_SECOND_PER_DRAGON + GONS_BOOST + BBS_BOOST;
1784 
1785 		return totalAmber_PerSecond_PerDragon;
1786 	}
1787 
1788     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1789 		return a < b ? a : b;
1790 	}
1791 
1792     function mintForUser(address user) external {
1793 
1794         uint256 totalAmber_PerSecond_PerDragon = getTotalAmberPerSecondPerDragon(user);
1795         uint256 total = DRAGONS.balanceOf(user);
1796         uint256 owed = 0;
1797         uint256 time = min(block.timestamp, END);
1798         uint256 id;
1799         uint256 claimed;
1800 
1801         for (uint256 i = 0; i < total; i++) {
1802             id = DRAGONS.tokenOfOwnerByIndex(user, i);
1803             claimed = lastClaim(id);
1804             owed += ((time - claimed) * totalAmber_PerSecond_PerDragon);
1805             last[id] = time;
1806         }
1807         _mint(user, owed);
1808     }
1809 
1810     function mintForIds(uint256[] calldata ids) external {
1811 
1812         uint256 id;
1813         address owner;
1814         uint256 totalAmber_PerSecond_PerDragon;
1815         uint256 claimed;
1816         uint256 owed = 0;
1817         uint256 time = min(block.timestamp, END);
1818 
1819         for (uint256 i = 0; i < ids.length; i++) {
1820             id = ids[i];
1821             owner = DRAGONS.ownerOf(id);
1822             totalAmber_PerSecond_PerDragon = getTotalAmberPerSecondPerDragon(owner);
1823             claimed = lastClaim(id);
1824             owed = (time - claimed) * totalAmber_PerSecond_PerDragon;
1825             _mint(owner, owed);
1826             last[id] = time;
1827         }
1828     }
1829 
1830     function lastClaim(uint256 id) public view returns (uint256) {
1831         return Math.max(last[id], GENESIS);
1832     }
1833 
1834     function burn(address _from, uint256 _amount) external {
1835 		require(msg.sender == address(burnContract));
1836 		_burn(_from, _amount);
1837 	}
1838 
1839     function getTotalClaimable(address user) external view returns(uint256) {
1840 
1841         uint256 totalAmber_PerSecond_PerDragon = getTotalAmberPerSecondPerDragon(user);
1842         uint256 id;
1843         uint256 total = DRAGONS.balanceOf(user);
1844         uint256 owed = 0;
1845         uint256 claimed;
1846         uint256 time = min(block.timestamp, END);
1847 
1848         for (uint256 i = 0; i < total; i++) {
1849             id = DRAGONS.tokenOfOwnerByIndex(user, i);
1850             claimed = lastClaim(id);
1851             owed += ((time - claimed) * totalAmber_PerSecond_PerDragon);
1852         }
1853 
1854 		return owed;
1855 	}
1856 }