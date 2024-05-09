1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.9;
4 
5 /* Hedron is a collection of Ethereum / PulseChain smart contracts that  *
6  * build upon the HEX smart contract to provide additional functionality */
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
86 /**
87  * @dev Interface for the optional metadata functions from the ERC20 standard.
88  *
89  * _Available since v4.1._
90  */
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 /**
109  * @dev Provides information about the current execution context, including the
110  * sender of the transaction and its data. While these are generally available
111  * via msg.sender and msg.data, they should not be accessed in such a direct
112  * manner, since when dealing with meta-transactions the account sending and
113  * paying for execution may not be the actual sender (as far as an application
114  * is concerned).
115  *
116  * This contract is only required for intermediate, library-like contracts.
117  */
118 abstract contract Context {
119     function _msgSender() internal view virtual returns (address) {
120         return msg.sender;
121     }
122 
123     function _msgData() internal view virtual returns (bytes calldata) {
124         return msg.data;
125     }
126 }
127 
128 /**
129  * @dev Implementation of the {IERC20} interface.
130  *
131  * This implementation is agnostic to the way tokens are created. This means
132  * that a supply mechanism has to be added in a derived contract using {_mint}.
133  * For a generic mechanism see {ERC20PresetMinterPauser}.
134  *
135  * TIP: For a detailed writeup see our guide
136  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
137  * to implement supply mechanisms].
138  *
139  * We have followed general OpenZeppelin Contracts guidelines: functions revert
140  * instead returning `false` on failure. This behavior is nonetheless
141  * conventional and does not conflict with the expectations of ERC20
142  * applications.
143  *
144  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
145  * This allows applications to reconstruct the allowance for all accounts just
146  * by listening to said events. Other implementations of the EIP may not emit
147  * these events, as it isn't required by the specification.
148  *
149  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
150  * functions have been added to mitigate the well-known issues around setting
151  * allowances. See {IERC20-approve}.
152  */
153 contract ERC20 is Context, IERC20, IERC20Metadata {
154     mapping(address => uint256) private _balances;
155 
156     mapping(address => mapping(address => uint256)) private _allowances;
157 
158     uint256 private _totalSupply;
159 
160     string private _name;
161     string private _symbol;
162 
163     /**
164      * @dev Sets the values for {name} and {symbol}.
165      *
166      * The default value of {decimals} is 18. To select a different value for
167      * {decimals} you should overload it.
168      *
169      * All two of these values are immutable: they can only be set once during
170      * construction.
171      */
172     constructor(string memory name_, string memory symbol_) {
173         _name = name_;
174         _symbol = symbol_;
175     }
176 
177     /**
178      * @dev Returns the name of the token.
179      */
180     function name() public view virtual override returns (string memory) {
181         return _name;
182     }
183 
184     /**
185      * @dev Returns the symbol of the token, usually a shorter version of the
186      * name.
187      */
188     function symbol() public view virtual override returns (string memory) {
189         return _symbol;
190     }
191 
192     /**
193      * @dev Returns the number of decimals used to get its user representation.
194      * For example, if `decimals` equals `2`, a balance of `505` tokens should
195      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
196      *
197      * Tokens usually opt for a value of 18, imitating the relationship between
198      * Ether and Wei. This is the value {ERC20} uses, unless this function is
199      * overridden;
200      *
201      * NOTE: This information is only used for _display_ purposes: it in
202      * no way affects any of the arithmetic of the contract, including
203      * {IERC20-balanceOf} and {IERC20-transfer}.
204      */
205     function decimals() public view virtual override returns (uint8) {
206         return 18;
207     }
208 
209     /**
210      * @dev See {IERC20-totalSupply}.
211      */
212     function totalSupply() public view virtual override returns (uint256) {
213         return _totalSupply;
214     }
215 
216     /**
217      * @dev See {IERC20-balanceOf}.
218      */
219     function balanceOf(address account) public view virtual override returns (uint256) {
220         return _balances[account];
221     }
222 
223     /**
224      * @dev See {IERC20-transfer}.
225      *
226      * Requirements:
227      *
228      * - `recipient` cannot be the zero address.
229      * - the caller must have a balance of at least `amount`.
230      */
231     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
232         _transfer(_msgSender(), recipient, amount);
233         return true;
234     }
235 
236     /**
237      * @dev See {IERC20-allowance}.
238      */
239     function allowance(address owner, address spender) public view virtual override returns (uint256) {
240         return _allowances[owner][spender];
241     }
242 
243     /**
244      * @dev See {IERC20-approve}.
245      *
246      * Requirements:
247      *
248      * - `spender` cannot be the zero address.
249      */
250     function approve(address spender, uint256 amount) public virtual override returns (bool) {
251         _approve(_msgSender(), spender, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See {IERC20-transferFrom}.
257      *
258      * Emits an {Approval} event indicating the updated allowance. This is not
259      * required by the EIP. See the note at the beginning of {ERC20}.
260      *
261      * Requirements:
262      *
263      * - `sender` and `recipient` cannot be the zero address.
264      * - `sender` must have a balance of at least `amount`.
265      * - the caller must have allowance for ``sender``'s tokens of at least
266      * `amount`.
267      */
268     function transferFrom(
269         address sender,
270         address recipient,
271         uint256 amount
272     ) public virtual override returns (bool) {
273         _transfer(sender, recipient, amount);
274 
275         uint256 currentAllowance = _allowances[sender][_msgSender()];
276         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
277         unchecked {
278             _approve(sender, _msgSender(), currentAllowance - amount);
279         }
280 
281         return true;
282     }
283 
284     /**
285      * @dev Atomically increases the allowance granted to `spender` by the caller.
286      *
287      * This is an alternative to {approve} that can be used as a mitigation for
288      * problems described in {IERC20-approve}.
289      *
290      * Emits an {Approval} event indicating the updated allowance.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      */
296     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
297         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
298         return true;
299     }
300 
301     /**
302      * @dev Atomically decreases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      * - `spender` must have allowance for the caller of at least
313      * `subtractedValue`.
314      */
315     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
316         uint256 currentAllowance = _allowances[_msgSender()][spender];
317         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
318         unchecked {
319             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
320         }
321 
322         return true;
323     }
324 
325     /**
326      * @dev Moves `amount` of tokens from `sender` to `recipient`.
327      *
328      * This internal function is equivalent to {transfer}, and can be used to
329      * e.g. implement automatic token fees, slashing mechanisms, etc.
330      *
331      * Emits a {Transfer} event.
332      *
333      * Requirements:
334      *
335      * - `sender` cannot be the zero address.
336      * - `recipient` cannot be the zero address.
337      * - `sender` must have a balance of at least `amount`.
338      */
339     function _transfer(
340         address sender,
341         address recipient,
342         uint256 amount
343     ) internal virtual {
344         require(sender != address(0), "ERC20: transfer from the zero address");
345         require(recipient != address(0), "ERC20: transfer to the zero address");
346 
347         _beforeTokenTransfer(sender, recipient, amount);
348 
349         uint256 senderBalance = _balances[sender];
350         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
351         unchecked {
352             _balances[sender] = senderBalance - amount;
353         }
354         _balances[recipient] += amount;
355 
356         emit Transfer(sender, recipient, amount);
357 
358         _afterTokenTransfer(sender, recipient, amount);
359     }
360 
361     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
362      * the total supply.
363      *
364      * Emits a {Transfer} event with `from` set to the zero address.
365      *
366      * Requirements:
367      *
368      * - `account` cannot be the zero address.
369      */
370     function _mint(address account, uint256 amount) internal virtual {
371         require(account != address(0), "ERC20: mint to the zero address");
372 
373         _beforeTokenTransfer(address(0), account, amount);
374 
375         _totalSupply += amount;
376         _balances[account] += amount;
377         emit Transfer(address(0), account, amount);
378 
379         _afterTokenTransfer(address(0), account, amount);
380     }
381 
382     /**
383      * @dev Destroys `amount` tokens from `account`, reducing the
384      * total supply.
385      *
386      * Emits a {Transfer} event with `to` set to the zero address.
387      *
388      * Requirements:
389      *
390      * - `account` cannot be the zero address.
391      * - `account` must have at least `amount` tokens.
392      */
393     function _burn(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: burn from the zero address");
395 
396         _beforeTokenTransfer(account, address(0), amount);
397 
398         uint256 accountBalance = _balances[account];
399         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
400         unchecked {
401             _balances[account] = accountBalance - amount;
402         }
403         _totalSupply -= amount;
404 
405         emit Transfer(account, address(0), amount);
406 
407         _afterTokenTransfer(account, address(0), amount);
408     }
409 
410     /**
411      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
412      *
413      * This internal function is equivalent to `approve`, and can be used to
414      * e.g. set automatic allowances for certain subsystems, etc.
415      *
416      * Emits an {Approval} event.
417      *
418      * Requirements:
419      *
420      * - `owner` cannot be the zero address.
421      * - `spender` cannot be the zero address.
422      */
423     function _approve(
424         address owner,
425         address spender,
426         uint256 amount
427     ) internal virtual {
428         require(owner != address(0), "ERC20: approve from the zero address");
429         require(spender != address(0), "ERC20: approve to the zero address");
430 
431         _allowances[owner][spender] = amount;
432         emit Approval(owner, spender, amount);
433     }
434 
435     /**
436      * @dev Hook that is called before any transfer of tokens. This includes
437      * minting and burning.
438      *
439      * Calling conditions:
440      *
441      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
442      * will be transferred to `to`.
443      * - when `from` is zero, `amount` tokens will be minted for `to`.
444      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
445      * - `from` and `to` are never both zero.
446      *
447      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
448      */
449     function _beforeTokenTransfer(
450         address from,
451         address to,
452         uint256 amount
453     ) internal virtual {}
454 
455     /**
456      * @dev Hook that is called after any transfer of tokens. This includes
457      * minting and burning.
458      *
459      * Calling conditions:
460      *
461      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
462      * has been transferred to `to`.
463      * - when `from` is zero, `amount` tokens have been minted for `to`.
464      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
465      * - `from` and `to` are never both zero.
466      *
467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
468      */
469     function _afterTokenTransfer(
470         address from,
471         address to,
472         uint256 amount
473     ) internal virtual {}
474 }
475 
476 /**
477  * @dev Interface of the ERC165 standard, as defined in the
478  * https://eips.ethereum.org/EIPS/eip-165[EIP].
479  *
480  * Implementers can declare support of contract interfaces, which can then be
481  * queried by others ({ERC165Checker}).
482  *
483  * For an implementation, see {ERC165}.
484  */
485 interface IERC165 {
486     /**
487      * @dev Returns true if this contract implements the interface defined by
488      * `interfaceId`. See the corresponding
489      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
490      * to learn more about how these ids are created.
491      *
492      * This function call must use less than 30 000 gas.
493      */
494     function supportsInterface(bytes4 interfaceId) external view returns (bool);
495 }
496 
497 /**
498  * @dev Required interface of an ERC721 compliant contract.
499  */
500 interface IERC721 is IERC165 {
501     /**
502      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
503      */
504     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
505 
506     /**
507      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
508      */
509     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
510 
511     /**
512      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
513      */
514     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
515 
516     /**
517      * @dev Returns the number of tokens in ``owner``'s account.
518      */
519     function balanceOf(address owner) external view returns (uint256 balance);
520 
521     /**
522      * @dev Returns the owner of the `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function ownerOf(uint256 tokenId) external view returns (address owner);
529 
530     /**
531      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
532      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must exist and be owned by `from`.
539      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541      *
542      * Emits a {Transfer} event.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId
548     ) external;
549 
550     /**
551      * @dev Transfers `tokenId` token from `from` to `to`.
552      *
553      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
554      *
555      * Requirements:
556      *
557      * - `from` cannot be the zero address.
558      * - `to` cannot be the zero address.
559      * - `tokenId` token must be owned by `from`.
560      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
561      *
562      * Emits a {Transfer} event.
563      */
564     function transferFrom(
565         address from,
566         address to,
567         uint256 tokenId
568     ) external;
569 
570     /**
571      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
572      * The approval is cleared when the token is transferred.
573      *
574      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
575      *
576      * Requirements:
577      *
578      * - The caller must own the token or be an approved operator.
579      * - `tokenId` must exist.
580      *
581      * Emits an {Approval} event.
582      */
583     function approve(address to, uint256 tokenId) external;
584 
585     /**
586      * @dev Returns the account approved for `tokenId` token.
587      *
588      * Requirements:
589      *
590      * - `tokenId` must exist.
591      */
592     function getApproved(uint256 tokenId) external view returns (address operator);
593 
594     /**
595      * @dev Approve or remove `operator` as an operator for the caller.
596      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
597      *
598      * Requirements:
599      *
600      * - The `operator` cannot be the caller.
601      *
602      * Emits an {ApprovalForAll} event.
603      */
604     function setApprovalForAll(address operator, bool _approved) external;
605 
606     /**
607      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
608      *
609      * See {setApprovalForAll}
610      */
611     function isApprovedForAll(address owner, address operator) external view returns (bool);
612 
613     /**
614      * @dev Safely transfers `tokenId` token from `from` to `to`.
615      *
616      * Requirements:
617      *
618      * - `from` cannot be the zero address.
619      * - `to` cannot be the zero address.
620      * - `tokenId` token must exist and be owned by `from`.
621      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
623      *
624      * Emits a {Transfer} event.
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId,
630         bytes calldata data
631     ) external;
632 }
633 
634 /**
635  * @title ERC721 token receiver interface
636  * @dev Interface for any contract that wants to support safeTransfers
637  * from ERC721 asset contracts.
638  */
639 interface IERC721Receiver {
640     /**
641      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
642      * by `operator` from `from`, this function is called.
643      *
644      * It must return its Solidity selector to confirm the token transfer.
645      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
646      *
647      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
648      */
649     function onERC721Received(
650         address operator,
651         address from,
652         uint256 tokenId,
653         bytes calldata data
654     ) external returns (bytes4);
655 }
656 
657 /**
658  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
659  * @dev See https://eips.ethereum.org/EIPS/eip-721
660  */
661 interface IERC721Metadata is IERC721 {
662     /**
663      * @dev Returns the token collection name.
664      */
665     function name() external view returns (string memory);
666 
667     /**
668      * @dev Returns the token collection symbol.
669      */
670     function symbol() external view returns (string memory);
671 
672     /**
673      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
674      */
675     function tokenURI(uint256 tokenId) external view returns (string memory);
676 }
677 
678 /**
679  * @dev Collection of functions related to the address type
680  */
681 library Address {
682     /**
683      * @dev Returns true if `account` is a contract.
684      *
685      * [IMPORTANT]
686      * ====
687      * It is unsafe to assume that an address for which this function returns
688      * false is an externally-owned account (EOA) and not a contract.
689      *
690      * Among others, `isContract` will return false for the following
691      * types of addresses:
692      *
693      *  - an externally-owned account
694      *  - a contract in construction
695      *  - an address where a contract will be created
696      *  - an address where a contract lived, but was destroyed
697      * ====
698      */
699     function isContract(address account) internal view returns (bool) {
700         // This method relies on extcodesize, which returns 0 for contracts in
701         // construction, since the code is only stored at the end of the
702         // constructor execution.
703 
704         uint256 size;
705         assembly {
706             size := extcodesize(account)
707         }
708         return size > 0;
709     }
710 
711     /**
712      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
713      * `recipient`, forwarding all available gas and reverting on errors.
714      *
715      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
716      * of certain opcodes, possibly making contracts go over the 2300 gas limit
717      * imposed by `transfer`, making them unable to receive funds via
718      * `transfer`. {sendValue} removes this limitation.
719      *
720      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
721      *
722      * IMPORTANT: because control is transferred to `recipient`, care must be
723      * taken to not create reentrancy vulnerabilities. Consider using
724      * {ReentrancyGuard} or the
725      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
726      */
727     function sendValue(address payable recipient, uint256 amount) internal {
728         require(address(this).balance >= amount, "Address: insufficient balance");
729 
730         (bool success, ) = recipient.call{value: amount}("");
731         require(success, "Address: unable to send value, recipient may have reverted");
732     }
733 
734     /**
735      * @dev Performs a Solidity function call using a low level `call`. A
736      * plain `call` is an unsafe replacement for a function call: use this
737      * function instead.
738      *
739      * If `target` reverts with a revert reason, it is bubbled up by this
740      * function (like regular Solidity function calls).
741      *
742      * Returns the raw returned data. To convert to the expected return value,
743      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
744      *
745      * Requirements:
746      *
747      * - `target` must be a contract.
748      * - calling `target` with `data` must not revert.
749      *
750      * _Available since v3.1._
751      */
752     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
753         return functionCall(target, data, "Address: low-level call failed");
754     }
755 
756     /**
757      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
758      * `errorMessage` as a fallback revert reason when `target` reverts.
759      *
760      * _Available since v3.1._
761      */
762     function functionCall(
763         address target,
764         bytes memory data,
765         string memory errorMessage
766     ) internal returns (bytes memory) {
767         return functionCallWithValue(target, data, 0, errorMessage);
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
772      * but also transferring `value` wei to `target`.
773      *
774      * Requirements:
775      *
776      * - the calling contract must have an ETH balance of at least `value`.
777      * - the called Solidity function must be `payable`.
778      *
779      * _Available since v3.1._
780      */
781     function functionCallWithValue(
782         address target,
783         bytes memory data,
784         uint256 value
785     ) internal returns (bytes memory) {
786         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
791      * with `errorMessage` as a fallback revert reason when `target` reverts.
792      *
793      * _Available since v3.1._
794      */
795     function functionCallWithValue(
796         address target,
797         bytes memory data,
798         uint256 value,
799         string memory errorMessage
800     ) internal returns (bytes memory) {
801         require(address(this).balance >= value, "Address: insufficient balance for call");
802         require(isContract(target), "Address: call to non-contract");
803 
804         (bool success, bytes memory returndata) = target.call{value: value}(data);
805         return verifyCallResult(success, returndata, errorMessage);
806     }
807 
808     /**
809      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
810      * but performing a static call.
811      *
812      * _Available since v3.3._
813      */
814     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
815         return functionStaticCall(target, data, "Address: low-level static call failed");
816     }
817 
818     /**
819      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
820      * but performing a static call.
821      *
822      * _Available since v3.3._
823      */
824     function functionStaticCall(
825         address target,
826         bytes memory data,
827         string memory errorMessage
828     ) internal view returns (bytes memory) {
829         require(isContract(target), "Address: static call to non-contract");
830 
831         (bool success, bytes memory returndata) = target.staticcall(data);
832         return verifyCallResult(success, returndata, errorMessage);
833     }
834 
835     /**
836      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
837      * but performing a delegate call.
838      *
839      * _Available since v3.4._
840      */
841     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
842         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
843     }
844 
845     /**
846      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
847      * but performing a delegate call.
848      *
849      * _Available since v3.4._
850      */
851     function functionDelegateCall(
852         address target,
853         bytes memory data,
854         string memory errorMessage
855     ) internal returns (bytes memory) {
856         require(isContract(target), "Address: delegate call to non-contract");
857 
858         (bool success, bytes memory returndata) = target.delegatecall(data);
859         return verifyCallResult(success, returndata, errorMessage);
860     }
861 
862     /**
863      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
864      * revert reason using the provided one.
865      *
866      * _Available since v4.3._
867      */
868     function verifyCallResult(
869         bool success,
870         bytes memory returndata,
871         string memory errorMessage
872     ) internal pure returns (bytes memory) {
873         if (success) {
874             return returndata;
875         } else {
876             // Look for revert reason and bubble it up if present
877             if (returndata.length > 0) {
878                 // The easiest way to bubble the revert reason is using memory via assembly
879 
880                 assembly {
881                     let returndata_size := mload(returndata)
882                     revert(add(32, returndata), returndata_size)
883                 }
884             } else {
885                 revert(errorMessage);
886             }
887         }
888     }
889 }
890 
891 /**
892  * @dev String operations.
893  */
894 library Strings {
895     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
896 
897     /**
898      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
899      */
900     function toString(uint256 value) internal pure returns (string memory) {
901         // Inspired by OraclizeAPI's implementation - MIT licence
902         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
903 
904         if (value == 0) {
905             return "0";
906         }
907         uint256 temp = value;
908         uint256 digits;
909         while (temp != 0) {
910             digits++;
911             temp /= 10;
912         }
913         bytes memory buffer = new bytes(digits);
914         while (value != 0) {
915             digits -= 1;
916             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
917             value /= 10;
918         }
919         return string(buffer);
920     }
921 
922     /**
923      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
924      */
925     function toHexString(uint256 value) internal pure returns (string memory) {
926         if (value == 0) {
927             return "0x00";
928         }
929         uint256 temp = value;
930         uint256 length = 0;
931         while (temp != 0) {
932             length++;
933             temp >>= 8;
934         }
935         return toHexString(value, length);
936     }
937 
938     /**
939      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
940      */
941     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
942         bytes memory buffer = new bytes(2 * length + 2);
943         buffer[0] = "0";
944         buffer[1] = "x";
945         for (uint256 i = 2 * length + 1; i > 1; --i) {
946             buffer[i] = _HEX_SYMBOLS[value & 0xf];
947             value >>= 4;
948         }
949         require(value == 0, "Strings: hex length insufficient");
950         return string(buffer);
951     }
952 }
953 
954 /**
955  * @dev Implementation of the {IERC165} interface.
956  *
957  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
958  * for the additional interface id that will be supported. For example:
959  *
960  * ```solidity
961  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
962  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
963  * }
964  * ```
965  *
966  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
967  */
968 abstract contract ERC165 is IERC165 {
969     /**
970      * @dev See {IERC165-supportsInterface}.
971      */
972     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
973         return interfaceId == type(IERC165).interfaceId;
974     }
975 }
976 
977 /**
978  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
979  * the Metadata extension, but not including the Enumerable extension, which is available separately as
980  * {ERC721Enumerable}.
981  */
982 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
983     using Address for address;
984     using Strings for uint256;
985 
986     // Token name
987     string private _name;
988 
989     // Token symbol
990     string private _symbol;
991 
992     // Mapping from token ID to owner address
993     mapping(uint256 => address) private _owners;
994 
995     // Mapping owner address to token count
996     mapping(address => uint256) private _balances;
997 
998     // Mapping from token ID to approved address
999     mapping(uint256 => address) private _tokenApprovals;
1000 
1001     // Mapping from owner to operator approvals
1002     mapping(address => mapping(address => bool)) private _operatorApprovals;
1003 
1004     /**
1005      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1006      */
1007     constructor(string memory name_, string memory symbol_) {
1008         _name = name_;
1009         _symbol = symbol_;
1010     }
1011 
1012     /**
1013      * @dev See {IERC165-supportsInterface}.
1014      */
1015     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1016         return
1017             interfaceId == type(IERC721).interfaceId ||
1018             interfaceId == type(IERC721Metadata).interfaceId ||
1019             super.supportsInterface(interfaceId);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-balanceOf}.
1024      */
1025     function balanceOf(address owner) public view virtual override returns (uint256) {
1026         require(owner != address(0), "ERC721: balance query for the zero address");
1027         return _balances[owner];
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-ownerOf}.
1032      */
1033     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1034         address owner = _owners[tokenId];
1035         require(owner != address(0), "ERC721: owner query for nonexistent token");
1036         return owner;
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Metadata-name}.
1041      */
1042     function name() public view virtual override returns (string memory) {
1043         return _name;
1044     }
1045 
1046     /**
1047      * @dev See {IERC721Metadata-symbol}.
1048      */
1049     function symbol() public view virtual override returns (string memory) {
1050         return _symbol;
1051     }
1052 
1053     /**
1054      * @dev See {IERC721Metadata-tokenURI}.
1055      */
1056     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1057         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1058 
1059         string memory baseURI = _baseURI();
1060         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1061     }
1062 
1063     /**
1064      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1065      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1066      * by default, can be overriden in child contracts.
1067      */
1068     function _baseURI() internal view virtual returns (string memory) {
1069         return "";
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-approve}.
1074      */
1075     function approve(address to, uint256 tokenId) public virtual override {
1076         address owner = ERC721.ownerOf(tokenId);
1077         require(to != owner, "ERC721: approval to current owner");
1078 
1079         require(
1080             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1081             "ERC721: approve caller is not owner nor approved for all"
1082         );
1083 
1084         _approve(to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-getApproved}.
1089      */
1090     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1091         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1092 
1093         return _tokenApprovals[tokenId];
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-setApprovalForAll}.
1098      */
1099     function setApprovalForAll(address operator, bool approved) public virtual override {
1100         _setApprovalForAll(_msgSender(), operator, approved);
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-isApprovedForAll}.
1105      */
1106     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1107         return _operatorApprovals[owner][operator];
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-transferFrom}.
1112      */
1113     function transferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) public virtual override {
1118         //solhint-disable-next-line max-line-length
1119         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1120 
1121         _transfer(from, to, tokenId);
1122     }
1123 
1124     /**
1125      * @dev See {IERC721-safeTransferFrom}.
1126      */
1127     function safeTransferFrom(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) public virtual override {
1132         safeTransferFrom(from, to, tokenId, "");
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-safeTransferFrom}.
1137      */
1138     function safeTransferFrom(
1139         address from,
1140         address to,
1141         uint256 tokenId,
1142         bytes memory _data
1143     ) public virtual override {
1144         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1145         _safeTransfer(from, to, tokenId, _data);
1146     }
1147 
1148     /**
1149      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1150      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1151      *
1152      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1153      *
1154      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1155      * implement alternative mechanisms to perform token transfer, such as signature-based.
1156      *
1157      * Requirements:
1158      *
1159      * - `from` cannot be the zero address.
1160      * - `to` cannot be the zero address.
1161      * - `tokenId` token must exist and be owned by `from`.
1162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function _safeTransfer(
1167         address from,
1168         address to,
1169         uint256 tokenId,
1170         bytes memory _data
1171     ) internal virtual {
1172         _transfer(from, to, tokenId);
1173         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1174     }
1175 
1176     /**
1177      * @dev Returns whether `tokenId` exists.
1178      *
1179      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1180      *
1181      * Tokens start existing when they are minted (`_mint`),
1182      * and stop existing when they are burned (`_burn`).
1183      */
1184     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1185         return _owners[tokenId] != address(0);
1186     }
1187 
1188     /**
1189      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1190      *
1191      * Requirements:
1192      *
1193      * - `tokenId` must exist.
1194      */
1195     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1196         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1197         address owner = ERC721.ownerOf(tokenId);
1198         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1199     }
1200 
1201     /**
1202      * @dev Safely mints `tokenId` and transfers it to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - `tokenId` must not exist.
1207      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _safeMint(address to, uint256 tokenId) internal virtual {
1212         _safeMint(to, tokenId, "");
1213     }
1214 
1215     /**
1216      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1217      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1218      */
1219     function _safeMint(
1220         address to,
1221         uint256 tokenId,
1222         bytes memory _data
1223     ) internal virtual {
1224         _mint(to, tokenId);
1225         require(
1226             _checkOnERC721Received(address(0), to, tokenId, _data),
1227             "ERC721: transfer to non ERC721Receiver implementer"
1228         );
1229     }
1230 
1231     /**
1232      * @dev Mints `tokenId` and transfers it to `to`.
1233      *
1234      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1235      *
1236      * Requirements:
1237      *
1238      * - `tokenId` must not exist.
1239      * - `to` cannot be the zero address.
1240      *
1241      * Emits a {Transfer} event.
1242      */
1243     function _mint(address to, uint256 tokenId) internal virtual {
1244         require(to != address(0), "ERC721: mint to the zero address");
1245         require(!_exists(tokenId), "ERC721: token already minted");
1246 
1247         _beforeTokenTransfer(address(0), to, tokenId);
1248 
1249         _balances[to] += 1;
1250         _owners[tokenId] = to;
1251 
1252         emit Transfer(address(0), to, tokenId);
1253     }
1254 
1255     /**
1256      * @dev Destroys `tokenId`.
1257      * The approval is cleared when the token is burned.
1258      *
1259      * Requirements:
1260      *
1261      * - `tokenId` must exist.
1262      *
1263      * Emits a {Transfer} event.
1264      */
1265     function _burn(uint256 tokenId) internal virtual {
1266         address owner = ERC721.ownerOf(tokenId);
1267 
1268         _beforeTokenTransfer(owner, address(0), tokenId);
1269 
1270         // Clear approvals
1271         _approve(address(0), tokenId);
1272 
1273         _balances[owner] -= 1;
1274         delete _owners[tokenId];
1275 
1276         emit Transfer(owner, address(0), tokenId);
1277     }
1278 
1279     /**
1280      * @dev Transfers `tokenId` from `from` to `to`.
1281      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1282      *
1283      * Requirements:
1284      *
1285      * - `to` cannot be the zero address.
1286      * - `tokenId` token must be owned by `from`.
1287      *
1288      * Emits a {Transfer} event.
1289      */
1290     function _transfer(
1291         address from,
1292         address to,
1293         uint256 tokenId
1294     ) internal virtual {
1295         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1296         require(to != address(0), "ERC721: transfer to the zero address");
1297 
1298         _beforeTokenTransfer(from, to, tokenId);
1299 
1300         // Clear approvals from the previous owner
1301         _approve(address(0), tokenId);
1302 
1303         _balances[from] -= 1;
1304         _balances[to] += 1;
1305         _owners[tokenId] = to;
1306 
1307         emit Transfer(from, to, tokenId);
1308     }
1309 
1310     /**
1311      * @dev Approve `to` to operate on `tokenId`
1312      *
1313      * Emits a {Approval} event.
1314      */
1315     function _approve(address to, uint256 tokenId) internal virtual {
1316         _tokenApprovals[tokenId] = to;
1317         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1318     }
1319 
1320     /**
1321      * @dev Approve `operator` to operate on all of `owner` tokens
1322      *
1323      * Emits a {ApprovalForAll} event.
1324      */
1325     function _setApprovalForAll(
1326         address owner,
1327         address operator,
1328         bool approved
1329     ) internal virtual {
1330         require(owner != operator, "ERC721: approve to caller");
1331         _operatorApprovals[owner][operator] = approved;
1332         emit ApprovalForAll(owner, operator, approved);
1333     }
1334 
1335     /**
1336      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1337      * The call is not executed if the target address is not a contract.
1338      *
1339      * @param from address representing the previous owner of the given token ID
1340      * @param to target address that will receive the tokens
1341      * @param tokenId uint256 ID of the token to be transferred
1342      * @param _data bytes optional data to send along with the call
1343      * @return bool whether the call correctly returned the expected magic value
1344      */
1345     function _checkOnERC721Received(
1346         address from,
1347         address to,
1348         uint256 tokenId,
1349         bytes memory _data
1350     ) private returns (bool) {
1351         if (to.isContract()) {
1352             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1353                 return retval == IERC721Receiver.onERC721Received.selector;
1354             } catch (bytes memory reason) {
1355                 if (reason.length == 0) {
1356                     revert("ERC721: transfer to non ERC721Receiver implementer");
1357                 } else {
1358                     assembly {
1359                         revert(add(32, reason), mload(reason))
1360                     }
1361                 }
1362             }
1363         } else {
1364             return true;
1365         }
1366     }
1367 
1368     /**
1369      * @dev Hook that is called before any token transfer. This includes minting
1370      * and burning.
1371      *
1372      * Calling conditions:
1373      *
1374      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1375      * transferred to `to`.
1376      * - When `from` is zero, `tokenId` will be minted for `to`.
1377      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1378      * - `from` and `to` are never both zero.
1379      *
1380      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1381      */
1382     function _beforeTokenTransfer(
1383         address from,
1384         address to,
1385         uint256 tokenId
1386     ) internal virtual {}
1387 }
1388 
1389 /**
1390  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1391  * @dev See https://eips.ethereum.org/EIPS/eip-721
1392  */
1393 interface IERC721Enumerable is IERC721 {
1394     /**
1395      * @dev Returns the total amount of tokens stored by the contract.
1396      */
1397     function totalSupply() external view returns (uint256);
1398 
1399     /**
1400      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1401      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1402      */
1403     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1404 
1405     /**
1406      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1407      * Use along with {totalSupply} to enumerate all tokens.
1408      */
1409     function tokenByIndex(uint256 index) external view returns (uint256);
1410 }
1411 
1412 /**
1413  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1414  * enumerability of all the token ids in the contract as well as all token ids owned by each
1415  * account.
1416  */
1417 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1418     // Mapping from owner to list of owned token IDs
1419     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1420 
1421     // Mapping from token ID to index of the owner tokens list
1422     mapping(uint256 => uint256) private _ownedTokensIndex;
1423 
1424     // Array with all token ids, used for enumeration
1425     uint256[] private _allTokens;
1426 
1427     // Mapping from token id to position in the allTokens array
1428     mapping(uint256 => uint256) private _allTokensIndex;
1429 
1430     /**
1431      * @dev See {IERC165-supportsInterface}.
1432      */
1433     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1434         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1435     }
1436 
1437     /**
1438      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1439      */
1440     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1441         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1442         return _ownedTokens[owner][index];
1443     }
1444 
1445     /**
1446      * @dev See {IERC721Enumerable-totalSupply}.
1447      */
1448     function totalSupply() public view virtual override returns (uint256) {
1449         return _allTokens.length;
1450     }
1451 
1452     /**
1453      * @dev See {IERC721Enumerable-tokenByIndex}.
1454      */
1455     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1456         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1457         return _allTokens[index];
1458     }
1459 
1460     /**
1461      * @dev Hook that is called before any token transfer. This includes minting
1462      * and burning.
1463      *
1464      * Calling conditions:
1465      *
1466      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1467      * transferred to `to`.
1468      * - When `from` is zero, `tokenId` will be minted for `to`.
1469      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1470      * - `from` cannot be the zero address.
1471      * - `to` cannot be the zero address.
1472      *
1473      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1474      */
1475     function _beforeTokenTransfer(
1476         address from,
1477         address to,
1478         uint256 tokenId
1479     ) internal virtual override {
1480         super._beforeTokenTransfer(from, to, tokenId);
1481 
1482         if (from == address(0)) {
1483             _addTokenToAllTokensEnumeration(tokenId);
1484         } else if (from != to) {
1485             _removeTokenFromOwnerEnumeration(from, tokenId);
1486         }
1487         if (to == address(0)) {
1488             _removeTokenFromAllTokensEnumeration(tokenId);
1489         } else if (to != from) {
1490             _addTokenToOwnerEnumeration(to, tokenId);
1491         }
1492     }
1493 
1494     /**
1495      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1496      * @param to address representing the new owner of the given token ID
1497      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1498      */
1499     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1500         uint256 length = ERC721.balanceOf(to);
1501         _ownedTokens[to][length] = tokenId;
1502         _ownedTokensIndex[tokenId] = length;
1503     }
1504 
1505     /**
1506      * @dev Private function to add a token to this extension's token tracking data structures.
1507      * @param tokenId uint256 ID of the token to be added to the tokens list
1508      */
1509     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1510         _allTokensIndex[tokenId] = _allTokens.length;
1511         _allTokens.push(tokenId);
1512     }
1513 
1514     /**
1515      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1516      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1517      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1518      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1519      * @param from address representing the previous owner of the given token ID
1520      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1521      */
1522     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1523         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1524         // then delete the last slot (swap and pop).
1525 
1526         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1527         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1528 
1529         // When the token to delete is the last token, the swap operation is unnecessary
1530         if (tokenIndex != lastTokenIndex) {
1531             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1532 
1533             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1534             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1535         }
1536 
1537         // This also deletes the contents at the last position of the array
1538         delete _ownedTokensIndex[tokenId];
1539         delete _ownedTokens[from][lastTokenIndex];
1540     }
1541 
1542     /**
1543      * @dev Private function to remove a token from this extension's token tracking data structures.
1544      * This has O(1) time complexity, but alters the order of the _allTokens array.
1545      * @param tokenId uint256 ID of the token to be removed from the tokens list
1546      */
1547     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1548         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1549         // then delete the last slot (swap and pop).
1550 
1551         uint256 lastTokenIndex = _allTokens.length - 1;
1552         uint256 tokenIndex = _allTokensIndex[tokenId];
1553 
1554         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1555         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1556         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1557         uint256 lastTokenId = _allTokens[lastTokenIndex];
1558 
1559         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1560         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1561 
1562         // This also deletes the contents at the last position of the array
1563         delete _allTokensIndex[tokenId];
1564         _allTokens.pop();
1565     }
1566 }
1567 
1568 /**
1569  * @title Counters
1570  * @author Matt Condon (@shrugs)
1571  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1572  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1573  *
1574  * Include with `using Counters for Counters.Counter;`
1575  */
1576 library Counters {
1577     struct Counter {
1578         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1579         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1580         // this feature: see https://github.com/ethereum/solidity/issues/4637
1581         uint256 _value; // default: 0
1582     }
1583 
1584     function current(Counter storage counter) internal view returns (uint256) {
1585         return counter._value;
1586     }
1587 
1588     function increment(Counter storage counter) internal {
1589         unchecked {
1590             counter._value += 1;
1591         }
1592     }
1593 
1594     function decrement(Counter storage counter) internal {
1595         uint256 value = counter._value;
1596         require(value > 0, "Counter: decrement overflow");
1597         unchecked {
1598             counter._value = value - 1;
1599         }
1600     }
1601 
1602     function reset(Counter storage counter) internal {
1603         counter._value = 0;
1604     }
1605 }
1606 
1607 /**
1608  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
1609  * deploying minimal proxy contracts, also known as "clones".
1610  *
1611  * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
1612  * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
1613  *
1614  * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
1615  * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
1616  * deterministic method.
1617  *
1618  * _Available since v3.4._
1619  */
1620 library Clones {
1621     /**
1622      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
1623      *
1624      * This function uses the create opcode, which should never revert.
1625      */
1626     function clone(address implementation) internal returns (address instance) {
1627         assembly {
1628             let ptr := mload(0x40)
1629             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1630             mstore(add(ptr, 0x14), shl(0x60, implementation))
1631             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1632             instance := create(0, ptr, 0x37)
1633         }
1634         require(instance != address(0), "ERC1167: create failed");
1635     }
1636 
1637     /**
1638      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
1639      *
1640      * This function uses the create2 opcode and a `salt` to deterministically deploy
1641      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
1642      * the clones cannot be deployed twice at the same address.
1643      */
1644     function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
1645         assembly {
1646             let ptr := mload(0x40)
1647             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1648             mstore(add(ptr, 0x14), shl(0x60, implementation))
1649             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
1650             instance := create2(0, ptr, 0x37, salt)
1651         }
1652         require(instance != address(0), "ERC1167: create2 failed");
1653     }
1654 
1655     /**
1656      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
1657      */
1658     function predictDeterministicAddress(
1659         address implementation,
1660         bytes32 salt,
1661         address deployer
1662     ) internal pure returns (address predicted) {
1663         assembly {
1664             let ptr := mload(0x40)
1665             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
1666             mstore(add(ptr, 0x14), shl(0x60, implementation))
1667             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
1668             mstore(add(ptr, 0x38), shl(0x60, deployer))
1669             mstore(add(ptr, 0x4c), salt)
1670             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
1671             predicted := keccak256(add(ptr, 0x37), 0x55)
1672         }
1673     }
1674 
1675     /**
1676      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
1677      */
1678     function predictDeterministicAddress(address implementation, bytes32 salt)
1679         internal
1680         view
1681         returns (address predicted)
1682     {
1683         return predictDeterministicAddress(implementation, salt, address(this));
1684     }
1685 }
1686 
1687 interface IHEX {
1688     event Approval(
1689         address indexed owner,
1690         address indexed spender,
1691         uint256 value
1692     );
1693     event Claim(
1694         uint256 data0,
1695         uint256 data1,
1696         bytes20 indexed btcAddr,
1697         address indexed claimToAddr,
1698         address indexed referrerAddr
1699     );
1700     event ClaimAssist(
1701         uint256 data0,
1702         uint256 data1,
1703         uint256 data2,
1704         address indexed senderAddr
1705     );
1706     event DailyDataUpdate(uint256 data0, address indexed updaterAddr);
1707     event ShareRateChange(uint256 data0, uint40 indexed stakeId);
1708     event StakeEnd(
1709         uint256 data0,
1710         uint256 data1,
1711         address indexed stakerAddr,
1712         uint40 indexed stakeId
1713     );
1714     event StakeGoodAccounting(
1715         uint256 data0,
1716         uint256 data1,
1717         address indexed stakerAddr,
1718         uint40 indexed stakeId,
1719         address indexed senderAddr
1720     );
1721     event StakeStart(
1722         uint256 data0,
1723         address indexed stakerAddr,
1724         uint40 indexed stakeId
1725     );
1726     event Transfer(address indexed from, address indexed to, uint256 value);
1727     event XfLobbyEnter(
1728         uint256 data0,
1729         address indexed memberAddr,
1730         uint256 indexed entryId,
1731         address indexed referrerAddr
1732     );
1733     event XfLobbyExit(
1734         uint256 data0,
1735         address indexed memberAddr,
1736         uint256 indexed entryId,
1737         address indexed referrerAddr
1738     );
1739 
1740     fallback() external payable;
1741 
1742     function allocatedSupply() external view returns (uint256);
1743 
1744     function allowance(address owner, address spender)
1745         external
1746         view
1747         returns (uint256);
1748 
1749     function approve(address spender, uint256 amount) external returns (bool);
1750 
1751     function balanceOf(address account) external view returns (uint256);
1752 
1753     function btcAddressClaim(
1754         uint256 rawSatoshis,
1755         bytes32[] memory proof,
1756         address claimToAddr,
1757         bytes32 pubKeyX,
1758         bytes32 pubKeyY,
1759         uint8 claimFlags,
1760         uint8 v,
1761         bytes32 r,
1762         bytes32 s,
1763         uint256 autoStakeDays,
1764         address referrerAddr
1765     ) external returns (uint256);
1766 
1767     function btcAddressClaims(bytes20) external view returns (bool);
1768 
1769     function btcAddressIsClaimable(
1770         bytes20 btcAddr,
1771         uint256 rawSatoshis,
1772         bytes32[] memory proof
1773     ) external view returns (bool);
1774 
1775     function btcAddressIsValid(
1776         bytes20 btcAddr,
1777         uint256 rawSatoshis,
1778         bytes32[] memory proof
1779     ) external pure returns (bool);
1780 
1781     function claimMessageMatchesSignature(
1782         address claimToAddr,
1783         bytes32 claimParamHash,
1784         bytes32 pubKeyX,
1785         bytes32 pubKeyY,
1786         uint8 claimFlags,
1787         uint8 v,
1788         bytes32 r,
1789         bytes32 s
1790     ) external pure returns (bool);
1791 
1792     function currentDay() external view returns (uint256);
1793 
1794     function dailyData(uint256)
1795         external
1796         view
1797         returns (
1798             uint72 dayPayoutTotal,
1799             uint72 dayStakeSharesTotal,
1800             uint56 dayUnclaimedSatoshisTotal
1801         );
1802 
1803     function dailyDataRange(uint256 beginDay, uint256 endDay)
1804         external
1805         view
1806         returns (uint256[] memory list);
1807 
1808     function dailyDataUpdate(uint256 beforeDay) external;
1809 
1810     function decimals() external view returns (uint8);
1811 
1812     function decreaseAllowance(address spender, uint256 subtractedValue)
1813         external
1814         returns (bool);
1815 
1816     function globalInfo() external view returns (uint256[13] memory);
1817 
1818     function globals()
1819         external
1820         view
1821         returns (
1822             uint72 lockedHeartsTotal,
1823             uint72 nextStakeSharesTotal,
1824             uint40 shareRate,
1825             uint72 stakePenaltyTotal,
1826             uint16 dailyDataCount,
1827             uint72 stakeSharesTotal,
1828             uint40 latestStakeId,
1829             uint128 claimStats
1830         );
1831 
1832     function increaseAllowance(address spender, uint256 addedValue)
1833         external
1834         returns (bool);
1835 
1836     function merkleProofIsValid(bytes32 merkleLeaf, bytes32[] memory proof)
1837         external
1838         pure
1839         returns (bool);
1840 
1841     function name() external view returns (string memory);
1842 
1843     function pubKeyToBtcAddress(
1844         bytes32 pubKeyX,
1845         bytes32 pubKeyY,
1846         uint8 claimFlags
1847     ) external pure returns (bytes20);
1848 
1849     function pubKeyToEthAddress(bytes32 pubKeyX, bytes32 pubKeyY)
1850         external
1851         pure
1852         returns (address);
1853 
1854     function stakeCount(address stakerAddr) external view returns (uint256);
1855 
1856     function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) external;
1857 
1858     function stakeGoodAccounting(
1859         address stakerAddr,
1860         uint256 stakeIndex,
1861         uint40 stakeIdParam
1862     ) external;
1863 
1864     function stakeLists(address, uint256)
1865         external
1866         view
1867         returns (
1868             uint40 stakeId,
1869             uint72 stakedHearts,
1870             uint72 stakeShares,
1871             uint16 lockedDay,
1872             uint16 stakedDays,
1873             uint16 unlockedDay,
1874             bool isAutoStake
1875         );
1876 
1877     function stakeStart(uint256 newStakedHearts, uint256 newStakedDays)
1878         external;
1879 
1880     function symbol() external view returns (string memory);
1881 
1882     function totalSupply() external view returns (uint256);
1883 
1884     function transfer(address recipient, uint256 amount)
1885         external
1886         returns (bool);
1887 
1888     function transferFrom(
1889         address sender,
1890         address recipient,
1891         uint256 amount
1892     ) external returns (bool);
1893 
1894     function xfLobby(uint256) external view returns (uint256);
1895 
1896     function xfLobbyEnter(address referrerAddr) external payable;
1897 
1898     function xfLobbyEntry(address memberAddr, uint256 entryId)
1899         external
1900         view
1901         returns (uint256 rawAmount, address referrerAddr);
1902 
1903     function xfLobbyExit(uint256 enterDay, uint256 count) external;
1904 
1905     function xfLobbyFlush() external;
1906 
1907     function xfLobbyMembers(uint256, address)
1908         external
1909         view
1910         returns (uint40 headIndex, uint40 tailIndex);
1911 
1912     function xfLobbyPendingDays(address memberAddr)
1913         external
1914         view
1915         returns (uint256[2] memory words);
1916 
1917     function xfLobbyRange(uint256 beginDay, uint256 endDay)
1918         external
1919         view
1920         returns (uint256[] memory list);
1921 }
1922 
1923 struct HEXDailyData {
1924     uint72 dayPayoutTotal;
1925     uint72 dayStakeSharesTotal;
1926     uint56 dayUnclaimedSatoshisTotal;
1927 }
1928 
1929 struct HEXGlobals {
1930     uint72 lockedHeartsTotal;
1931     uint72 nextStakeSharesTotal;
1932     uint40 shareRate;
1933     uint72 stakePenaltyTotal;
1934     uint16 dailyDataCount;
1935     uint72 stakeSharesTotal;
1936     uint40 latestStakeId;
1937     uint128 claimStats;
1938 }
1939 
1940 struct HEXStake {
1941     uint40 stakeId;
1942     uint72 stakedHearts;
1943     uint72 stakeShares;
1944     uint16 lockedDay;
1945     uint16 stakedDays;
1946     uint16 unlockedDay;
1947     bool   isAutoStake;
1948 }
1949 
1950 struct HEXStakeMinimal {
1951     uint40 stakeId;
1952     uint72 stakeShares;
1953     uint16 lockedDay;
1954     uint16 stakedDays;
1955 }
1956 
1957 struct ShareStore {
1958     HEXStakeMinimal stake;
1959     uint16          mintedDays;
1960     uint8           launchBonus;
1961     uint16          loanStart;
1962     uint16          loanedDays;
1963     uint32          interestRate;
1964     uint8           paymentsMade;
1965     bool            isLoaned;
1966 }
1967 
1968 struct ShareCache {
1969     HEXStakeMinimal _stake;
1970     uint256         _mintedDays;
1971     uint256         _launchBonus;
1972     uint256         _loanStart;
1973     uint256         _loanedDays;
1974     uint256         _interestRate;
1975     uint256         _paymentsMade;
1976     bool            _isLoaned;
1977 }
1978 
1979 address constant _hdrnSourceAddress = address(0x9d73Ced2e36C89E5d167151809eeE218a189f801);
1980 address constant _hdrnFlowAddress   = address(0xF447BE386164dADfB5d1e7622613f289F17024D8);
1981 uint256 constant _hdrnLaunch        = 1645833600;
1982 
1983 contract HEXStakeInstance {
1984     
1985     IHEX       private _hx;
1986     address    private _creator;
1987     ShareStore public  share;
1988 
1989     /**
1990      * @dev Updates the HSI's internal HEX stake data.
1991      */
1992     function _stakeDataUpdate(
1993     )
1994         internal
1995     {
1996         uint40 stakeId;
1997         uint72 stakedHearts;
1998         uint72 stakeShares;
1999         uint16 lockedDay;
2000         uint16 stakedDays;
2001         uint16 unlockedDay;
2002         bool   isAutoStake;
2003         
2004         (stakeId,
2005          stakedHearts,
2006          stakeShares,
2007          lockedDay,
2008          stakedDays,
2009          unlockedDay,
2010          isAutoStake
2011         ) = _hx.stakeLists(address(this), 0);
2012 
2013         share.stake.stakeId = stakeId;
2014         share.stake.stakeShares = stakeShares;
2015         share.stake.lockedDay = lockedDay;
2016         share.stake.stakedDays = stakedDays;
2017     }
2018 
2019     function initialize(
2020         address hexAddress
2021     ) 
2022         external 
2023     {
2024         require(_creator == address(0),
2025             "HSI: Initialization already performed");
2026 
2027         /* _creator is not an admin key. It is set at contsruction to be a link
2028            to the parent contract. In this case HSIM */
2029         _creator = msg.sender;
2030 
2031         // set HEX contract address
2032         _hx = IHEX(payable(hexAddress));
2033     }
2034 
2035     /**
2036      * @dev Creates a new HEX stake using all HEX ERC20 tokens assigned
2037      *      to the HSI's contract address. This is a privileged operation only
2038      *      HEXStakeInstanceManager.sol can call.
2039      * @param stakeLength Number of days the HEX ERC20 tokens will be staked.
2040      */
2041     function create(
2042         uint256 stakeLength
2043     )
2044         external
2045     {
2046         uint256 hexBalance = _hx.balanceOf(address(this));
2047 
2048         require(msg.sender == _creator,
2049             "HSI: Caller must be contract creator");
2050         require(share.stake.stakedDays == 0,
2051             "HSI: Creation already performed");
2052         require(hexBalance > 0,
2053             "HSI: Creation requires a non-zero HEX balance");
2054 
2055         _hx.stakeStart(
2056             hexBalance,
2057             stakeLength
2058         );
2059 
2060         _stakeDataUpdate();
2061     }
2062 
2063     /**
2064      * @dev Calls the HEX function "stakeGoodAccounting" against the
2065      *      HEX stake held within the HSI.
2066      */
2067     function goodAccounting(
2068     )
2069         external
2070     {
2071         require(share.stake.stakedDays > 0,
2072             "HSI: Creation not yet performed");
2073 
2074         _hx.stakeGoodAccounting(address(this), 0, share.stake.stakeId);
2075 
2076         _stakeDataUpdate();
2077     }
2078 
2079     /**
2080      * @dev Ends the HEX stake, approves the "_creator" address to transfer
2081      *      all HEX ERC20 tokens, and self-destructs the HSI. This is a 
2082      *      privileged operation only HEXStakeInstanceManager.sol can call.
2083      */
2084     function destroy(
2085     )
2086         external
2087     {
2088         require(msg.sender == _creator,
2089             "HSI: Caller must be contract creator");
2090         require(share.stake.stakedDays > 0,
2091             "HSI: Creation not yet performed");
2092 
2093         _hx.stakeEnd(0, share.stake.stakeId);
2094         
2095         uint256 hexBalance = _hx.balanceOf(address(this));
2096 
2097         if (_hx.approve(_creator, hexBalance)) {
2098             selfdestruct(payable(_creator));
2099         }
2100         else {
2101             revert();
2102         }
2103     }
2104 
2105     /**
2106      * @dev Updates the HSI's internal share data. This is a privileged 
2107      *      operation only HEXStakeInstanceManager.sol can call.
2108      * @param _share "ShareCache" object containing updated share data.
2109      */
2110     function update(
2111         ShareCache memory _share
2112     )
2113         external 
2114     {
2115         require(msg.sender == _creator,
2116             "HSI: Caller must be contract creator");
2117 
2118         share.mintedDays   = uint16(_share._mintedDays);
2119         share.launchBonus  = uint8 (_share._launchBonus);
2120         share.loanStart    = uint16(_share._loanStart);
2121         share.loanedDays   = uint16(_share._loanedDays);
2122         share.interestRate = uint32(_share._interestRate);
2123         share.paymentsMade = uint8 (_share._paymentsMade);
2124         share.isLoaned     = _share._isLoaned;
2125     }
2126 
2127     /**
2128      * @dev Fetches stake data from the HEX contract.
2129      * @return A "HEXStake" object containg the HEX stake data. 
2130      */
2131     function stakeDataFetch(
2132     ) 
2133         external
2134         view
2135         returns(HEXStake memory)
2136     {
2137         uint40 stakeId;
2138         uint72 stakedHearts;
2139         uint72 stakeShares;
2140         uint16 lockedDay;
2141         uint16 stakedDays;
2142         uint16 unlockedDay;
2143         bool   isAutoStake;
2144         
2145         (stakeId,
2146          stakedHearts,
2147          stakeShares,
2148          lockedDay,
2149          stakedDays,
2150          unlockedDay,
2151          isAutoStake
2152         ) = _hx.stakeLists(address(this), 0);
2153 
2154         return HEXStake(
2155             stakeId,
2156             stakedHearts,
2157             stakeShares,
2158             lockedDay,
2159             stakedDays,
2160             unlockedDay,
2161             isAutoStake
2162         );
2163     }
2164 }
2165 
2166 interface IHedron {
2167     event Approval(
2168         address indexed owner,
2169         address indexed spender,
2170         uint256 value
2171     );
2172     event Claim(uint256 data, address indexed claimant, uint40 indexed stakeId);
2173     event LoanEnd(
2174         uint256 data,
2175         address indexed borrower,
2176         uint40 indexed stakeId
2177     );
2178     event LoanLiquidateBid(
2179         uint256 data,
2180         address indexed bidder,
2181         uint40 indexed stakeId,
2182         uint40 indexed liquidationId
2183     );
2184     event LoanLiquidateExit(
2185         uint256 data,
2186         address indexed liquidator,
2187         uint40 indexed stakeId,
2188         uint40 indexed liquidationId
2189     );
2190     event LoanLiquidateStart(
2191         uint256 data,
2192         address indexed borrower,
2193         uint40 indexed stakeId,
2194         uint40 indexed liquidationId
2195     );
2196     event LoanPayment(
2197         uint256 data,
2198         address indexed borrower,
2199         uint40 indexed stakeId
2200     );
2201     event LoanStart(
2202         uint256 data,
2203         address indexed borrower,
2204         uint40 indexed stakeId
2205     );
2206     event Mint(uint256 data, address indexed minter, uint40 indexed stakeId);
2207     event Transfer(address indexed from, address indexed to, uint256 value);
2208 
2209     function allowance(address owner, address spender)
2210         external
2211         view
2212         returns (uint256);
2213 
2214     function approve(address spender, uint256 amount) external returns (bool);
2215 
2216     function balanceOf(address account) external view returns (uint256);
2217 
2218     function calcLoanPayment(
2219         address borrower,
2220         uint256 hsiIndex,
2221         address hsiAddress
2222     ) external view returns (uint256, uint256);
2223 
2224     function calcLoanPayoff(
2225         address borrower,
2226         uint256 hsiIndex,
2227         address hsiAddress
2228     ) external view returns (uint256, uint256);
2229 
2230     function claimInstanced(
2231         uint256 hsiIndex,
2232         address hsiAddress,
2233         address hsiStarterAddress
2234     ) external;
2235 
2236     function claimNative(uint256 stakeIndex, uint40 stakeId)
2237         external
2238         returns (uint256);
2239 
2240     function currentDay() external view returns (uint256);
2241 
2242     function dailyDataList(uint256)
2243         external
2244         view
2245         returns (
2246             uint72 dayMintedTotal,
2247             uint72 dayLoanedTotal,
2248             uint72 dayBurntTotal,
2249             uint32 dayInterestRate,
2250             uint8 dayMintMultiplier
2251         );
2252 
2253     function decimals() external view returns (uint8);
2254 
2255     function decreaseAllowance(address spender, uint256 subtractedValue)
2256         external
2257         returns (bool);
2258 
2259     function hsim() external view returns (address);
2260 
2261     function increaseAllowance(address spender, uint256 addedValue)
2262         external
2263         returns (bool);
2264 
2265     function liquidationList(uint256)
2266         external
2267         view
2268         returns (
2269             uint256 liquidationStart,
2270             address hsiAddress,
2271             uint96 bidAmount,
2272             address liquidator,
2273             uint88 endOffset,
2274             bool isActive
2275         );
2276 
2277     function loanInstanced(uint256 hsiIndex, address hsiAddress)
2278         external
2279         returns (uint256);
2280 
2281     function loanLiquidate(
2282         address owner,
2283         uint256 hsiIndex,
2284         address hsiAddress
2285     ) external returns (uint256);
2286 
2287     function loanLiquidateBid(uint256 liquidationId, uint256 liquidationBid)
2288         external
2289         returns (uint256);
2290 
2291     function loanLiquidateExit(uint256 hsiIndex, uint256 liquidationId)
2292         external
2293         returns (address);
2294 
2295     function loanPayment(uint256 hsiIndex, address hsiAddress)
2296         external
2297         returns (uint256);
2298 
2299     function loanPayoff(uint256 hsiIndex, address hsiAddress)
2300         external
2301         returns (uint256);
2302 
2303     function loanedSupply() external view returns (uint256);
2304 
2305     function mintInstanced(uint256 hsiIndex, address hsiAddress)
2306         external
2307         returns (uint256);
2308 
2309     function mintNative(uint256 stakeIndex, uint40 stakeId)
2310         external
2311         returns (uint256);
2312 
2313     function name() external view returns (string memory);
2314 
2315     function proofOfBenevolence(uint256 amount) external;
2316 
2317     function shareList(uint256)
2318         external
2319         view
2320         returns (
2321             HEXStakeMinimal memory stake,
2322             uint16 mintedDays,
2323             uint8 launchBonus,
2324             uint16 loanStart,
2325             uint16 loanedDays,
2326             uint32 interestRate,
2327             uint8 paymentsMade,
2328             bool isLoaned
2329         );
2330 
2331     function symbol() external view returns (string memory);
2332 
2333     function totalSupply() external view returns (uint256);
2334 
2335     function transfer(address recipient, uint256 amount)
2336         external
2337         returns (bool);
2338 
2339     function transferFrom(
2340         address sender,
2341         address recipient,
2342         uint256 amount
2343     ) external returns (bool);
2344 }
2345 
2346 library LibPart {
2347     bytes32 public constant TYPE_HASH = keccak256("Part(address account,uint96 value)");
2348 
2349     struct Part {
2350         address payable account;
2351         uint96 value;
2352     }
2353 
2354     function hash(Part memory part) internal pure returns (bytes32) {
2355         return keccak256(abi.encode(TYPE_HASH, part.account, part.value));
2356     }
2357 }
2358 
2359 abstract contract AbstractRoyalties {
2360     mapping (uint256 => LibPart.Part[]) internal royalties;
2361 
2362     function _saveRoyalties(uint256 id, LibPart.Part[] memory _royalties) internal {
2363         uint256 totalValue;
2364         for (uint i = 0; i < _royalties.length; i++) {
2365             require(_royalties[i].account != address(0x0), "Recipient should be present");
2366             require(_royalties[i].value != 0, "Royalty value should be positive");
2367             totalValue += _royalties[i].value;
2368             royalties[id].push(_royalties[i]);
2369         }
2370         require(totalValue < 10000, "Royalty total value should be < 10000");
2371         _onRoyaltiesSet(id, _royalties);
2372     }
2373 
2374     function _updateAccount(uint256 _id, address _from, address _to) internal {
2375         uint length = royalties[_id].length;
2376         for(uint i = 0; i < length; i++) {
2377             if (royalties[_id][i].account == _from) {
2378                 royalties[_id][i].account = payable(address(uint160(_to)));
2379             }
2380         }
2381     }
2382 
2383     function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) virtual internal;
2384 }
2385 
2386 interface RoyaltiesV2 {
2387     event RoyaltiesSet(uint256 tokenId, LibPart.Part[] royalties);
2388 
2389     function getRaribleV2Royalties(uint256 id) external view returns (LibPart.Part[] memory);
2390 }
2391 
2392 contract RoyaltiesV2Impl is AbstractRoyalties, RoyaltiesV2 {
2393 
2394     function getRaribleV2Royalties(uint256 id) override external view returns (LibPart.Part[] memory) {
2395         return royalties[id];
2396     }
2397 
2398     function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) override internal {
2399         emit RoyaltiesSet(id, _royalties);
2400     }
2401 }
2402 
2403 library LibRoyaltiesV2 {
2404     /*
2405      * bytes4(keccak256('getRaribleV2Royalties(uint256)')) == 0xcad96cca
2406      */
2407     bytes4 constant _INTERFACE_ID_ROYALTIES = 0xcad96cca;
2408 }
2409 
2410 contract HEXStakeInstanceManager is ERC721, ERC721Enumerable, RoyaltiesV2Impl {
2411 
2412     using Counters for Counters.Counter;
2413 
2414     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
2415     uint96 private constant _hsimRoyaltyBasis = 15; // Rarible V2 royalty basis
2416     string private constant _hostname = "https://api.hedron.pro/";
2417     string private constant _endpoint = "/hsi/";
2418     
2419     Counters.Counter private _tokenIds;
2420     address          private _creator;
2421     IHEX             private _hx;
2422     address          private _hxAddress;
2423     address          private _hsiImplementation;
2424 
2425     mapping(address => address[]) public  hsiLists;
2426     mapping(uint256 => address)   public  hsiToken;
2427  
2428     constructor(
2429         address hexAddress
2430     )
2431         ERC721("HEX Stake Instance", "HSI")
2432     {
2433         /* _creator is not an admin key. It is set at contsruction to be a link
2434            to the parent contract. In this case Hedron */
2435         _creator = msg.sender;
2436 
2437         // set HEX contract address
2438         _hx = IHEX(payable(hexAddress));
2439         _hxAddress = hexAddress;
2440 
2441         // create HSI implementation
2442         _hsiImplementation = address(new HEXStakeInstance());
2443         
2444         // initialize the HSI just in case
2445         HEXStakeInstance hsi = HEXStakeInstance(_hsiImplementation);
2446         hsi.initialize(hexAddress);
2447     }
2448 
2449     function _baseURI(
2450     )
2451         internal
2452         view
2453         virtual
2454         override
2455         returns (string memory)
2456     {
2457         string memory chainid = Strings.toString(block.chainid);
2458         return string(abi.encodePacked(_hostname, chainid, _endpoint));
2459     }
2460 
2461     function _beforeTokenTransfer(
2462         address from,
2463         address to,
2464         uint256 tokenId
2465     )
2466         internal
2467         override(ERC721, ERC721Enumerable) 
2468     {
2469         super._beforeTokenTransfer(from, to, tokenId);
2470     }
2471 
2472     event HSIStart(
2473         uint256         timestamp,
2474         address indexed hsiAddress,
2475         address indexed staker
2476     );
2477 
2478     event HSIEnd(
2479         uint256         timestamp,
2480         address indexed hsiAddress,
2481         address indexed staker
2482     );
2483 
2484     event HSITransfer(
2485         uint256         timestamp,
2486         address indexed hsiAddress,
2487         address indexed oldStaker,
2488         address indexed newStaker
2489     );
2490 
2491     event HSITokenize(
2492         uint256         timestamp,
2493         uint256 indexed hsiTokenId,
2494         address indexed hsiAddress,
2495         address indexed staker
2496     );
2497 
2498     event HSIDetokenize(
2499         uint256         timestamp,
2500         uint256 indexed hsiTokenId,
2501         address indexed hsiAddress,
2502         address indexed staker
2503     );
2504 
2505     /**
2506      * @dev Removes a HEX stake instance (HSI) contract address from an address mapping.
2507      * @param hsiList A mapped list of HSI contract addresses.
2508      * @param hsiIndex The index of the HSI contract address which will be removed.
2509      */
2510     function _pruneHSI(
2511         address[] storage hsiList,
2512         uint256 hsiIndex
2513     )
2514         internal
2515     {
2516         uint256 lastIndex = hsiList.length - 1;
2517 
2518         if (hsiIndex != lastIndex) {
2519             hsiList[hsiIndex] = hsiList[lastIndex];
2520         }
2521 
2522         hsiList.pop();
2523     }
2524 
2525     /**
2526      * @dev Loads share data from a HEX stake instance (HSI) into a "ShareCache" object.
2527      * @param hsi A HSI contract object from which share data will be loaded.
2528      * @return "ShareCache" object containing the loaded share data.
2529      */
2530     function _hsiLoad(
2531         HEXStakeInstance hsi
2532     ) 
2533         internal
2534         view
2535         returns (ShareCache memory)
2536     {
2537         HEXStakeMinimal memory stake;
2538         uint16                 mintedDays;
2539         uint8                  launchBonus;
2540         uint16                 loanStart;
2541         uint16                 loanedDays;
2542         uint32                 interestRate;
2543         uint8                  paymentsMade;
2544         bool                   isLoaned;
2545 
2546         (stake,
2547          mintedDays,
2548          launchBonus,
2549          loanStart,
2550          loanedDays,
2551          interestRate,
2552          paymentsMade,
2553          isLoaned) = hsi.share();
2554 
2555         return ShareCache(
2556             stake,
2557             mintedDays,
2558             launchBonus,
2559             loanStart,
2560             loanedDays,
2561             interestRate,
2562             paymentsMade,
2563             isLoaned
2564         );
2565     }
2566 
2567     // Internal NFT Marketplace Glue
2568 
2569     /** @dev Sets the Rarible V2 royalties on a specific token
2570      *  @param tokenId Unique ID of the HSI NFT token.
2571      */
2572     function _setRoyalties(
2573         uint256 tokenId
2574     )
2575         internal
2576     {
2577         LibPart.Part[] memory _royalties = new LibPart.Part[](1);
2578         _royalties[0].value = _hsimRoyaltyBasis;
2579         _royalties[0].account = payable(_hdrnFlowAddress);
2580         _saveRoyalties(tokenId, _royalties);
2581     }
2582 
2583     /**
2584      * @dev Retreives the number of HSI elements in an addresses HSI list.
2585      * @param user Address to retrieve the HSI list for.
2586      * @return Number of HSI elements found within the HSI list.
2587      */
2588     function hsiCount(
2589         address user
2590     )
2591         public
2592         view
2593         returns (uint256)
2594     {
2595         return hsiLists[user].length;
2596     }
2597 
2598     /**
2599      * @dev Wrapper function for hsiCount to allow HEX based applications to pull stake data.
2600      * @param user Address to retrieve the HSI list for.
2601      * @return Number of HSI elements found within the HSI list. 
2602      */
2603     function stakeCount(
2604         address user
2605     )
2606         external
2607         view
2608         returns (uint256)
2609     {
2610         return hsiCount(user);
2611     }
2612 
2613     /**
2614      * @dev Wrapper function for hsiLists to allow HEX based applications to pull stake data.
2615      * @param user Address to retrieve the HSI list for.
2616      * @param hsiIndex The index of the HSI contract address which will returned. 
2617      * @return "HEXStake" object containing HEX stake data. 
2618      */
2619     function stakeLists(
2620         address user,
2621         uint256 hsiIndex
2622     )
2623         external
2624         view
2625         returns (HEXStake memory)
2626     {
2627         address[] storage hsiList = hsiLists[user];
2628 
2629         HEXStakeInstance hsi = HEXStakeInstance(hsiList[hsiIndex]);
2630 
2631         return hsi.stakeDataFetch();
2632     }
2633 
2634     /**
2635      * @dev Creates a new HEX stake instance (HSI), transfers HEX ERC20 tokens to the
2636      *      HSI's contract address, and calls the "initialize" function.
2637      * @param amount Number of HEX ERC20 tokens to be staked.
2638      * @param length Number of days the HEX ERC20 tokens will be staked.
2639      * @return Address of the newly created HSI contract.
2640      */
2641     function hexStakeStart (
2642         uint256 amount,
2643         uint256 length
2644     )
2645         external
2646         returns (address)
2647     {
2648         require(amount <= _hx.balanceOf(msg.sender),
2649             "HSIM: Insufficient HEX to facilitate stake");
2650 
2651         address[] storage hsiList = hsiLists[msg.sender];
2652 
2653         address hsiAddress = Clones.clone(_hsiImplementation);
2654         HEXStakeInstance hsi = HEXStakeInstance(hsiAddress);
2655         hsi.initialize(_hxAddress);
2656 
2657         hsiList.push(hsiAddress);
2658         uint256 hsiIndex = hsiList.length - 1;
2659 
2660         require(_hx.transferFrom(msg.sender, hsiAddress, amount),
2661             "HSIM: HEX transfer from message sender to HSIM failed");
2662 
2663         hsi.create(length);
2664 
2665         IHedron hedron = IHedron(_creator);
2666         hedron.claimInstanced(hsiIndex, hsiAddress, msg.sender);
2667 
2668         emit HSIStart(block.timestamp, hsiAddress, msg.sender);
2669 
2670         return hsiAddress;
2671     }
2672 
2673     /**
2674      * @dev Calls the HEX stake instance (HSI) function "destroy", transfers HEX ERC20 tokens
2675      *      from the HSI's contract address to the senders address.
2676      * @param hsiIndex Index of the HSI contract's address in the caller's HSI list.
2677      * @param hsiAddress Address of the HSI contract in which to call the "destroy" function.
2678      * @return Amount of HEX ERC20 tokens awarded via ending the HEX stake.
2679      */
2680     function hexStakeEnd (
2681         uint256 hsiIndex,
2682         address hsiAddress
2683     )
2684         external
2685         returns (uint256)
2686     {
2687         address[] storage hsiList = hsiLists[msg.sender];
2688 
2689         require(hsiAddress == hsiList[hsiIndex],
2690             "HSIM: HSI index address mismatch");
2691 
2692         HEXStakeInstance hsi = HEXStakeInstance(hsiAddress);
2693         ShareCache memory share = _hsiLoad(hsi);
2694 
2695         require (share._isLoaned == false,
2696             "HSIM: Cannot call stakeEnd against a loaned stake");
2697 
2698         hsi.destroy();
2699 
2700         emit HSIEnd(block.timestamp, hsiAddress, msg.sender);
2701 
2702         uint256 hsiBalance = _hx.balanceOf(hsiAddress);
2703 
2704         if (hsiBalance > 0) {
2705             require(_hx.transferFrom(hsiAddress, msg.sender, hsiBalance),
2706                 "HSIM: HEX transfer from HSI failed");
2707         }
2708 
2709         _pruneHSI(hsiList, hsiIndex);
2710 
2711         return hsiBalance;
2712     }
2713 
2714     /**
2715      * @dev Converts a HEX stake instance (HSI) contract address mapping into a
2716      *      HSI ERC721 token.
2717      * @param hsiIndex Index of the HSI contract's address in the caller's HSI list.
2718      * @param hsiAddress Address of the HSI contract to be converted.
2719      * @return Token ID of the newly minted HSI ERC721 token.
2720      */
2721     function hexStakeTokenize (
2722         uint256 hsiIndex,
2723         address hsiAddress
2724     )
2725         external
2726         returns (uint256)
2727     {
2728         address[] storage hsiList = hsiLists[msg.sender];
2729 
2730         require(hsiAddress == hsiList[hsiIndex],
2731             "HSIM: HSI index address mismatch");
2732 
2733         HEXStakeInstance hsi = HEXStakeInstance(hsiAddress);
2734         ShareCache memory share = _hsiLoad(hsi);
2735 
2736         require (share._isLoaned == false,
2737             "HSIM: Cannot tokenize a loaned stake");
2738 
2739         _tokenIds.increment();
2740 
2741         uint256 newTokenId = _tokenIds.current();
2742 
2743         _mint(msg.sender, newTokenId);
2744          hsiToken[newTokenId] = hsiAddress;
2745 
2746         _setRoyalties(newTokenId);
2747 
2748         _pruneHSI(hsiList, hsiIndex);
2749 
2750         emit HSITokenize(
2751             block.timestamp,
2752             newTokenId,
2753             hsiAddress,
2754             msg.sender
2755         );
2756 
2757         return newTokenId;
2758     }
2759 
2760     /**
2761      * @dev Converts a HEX stake instance (HSI) ERC721 token into an address mapping.
2762      * @param tokenId ID of the HSI ERC721 token to be converted.
2763      * @return Address of the detokenized HSI contract.
2764      */
2765     function hexStakeDetokenize (
2766         uint256 tokenId
2767     )
2768         external
2769         returns (address)
2770     {
2771         require(ownerOf(tokenId) == msg.sender,
2772             "HSIM: Detokenization requires token ownership");
2773 
2774         address hsiAddress = hsiToken[tokenId];
2775         address[] storage hsiList = hsiLists[msg.sender];
2776 
2777         hsiList.push(hsiAddress);
2778         hsiToken[tokenId] = address(0);
2779 
2780         _burn(tokenId);
2781 
2782         emit HSIDetokenize(
2783             block.timestamp,
2784             tokenId, 
2785             hsiAddress,
2786             msg.sender
2787         );
2788 
2789         return hsiAddress;
2790     }
2791 
2792     /**
2793      * @dev Updates the share data of a HEX stake instance (HSI) contract.
2794      *      This is a pivileged operation only Hedron.sol can call.
2795      * @param holder Address of the HSI contract owner.
2796      * @param hsiIndex Index of the HSI contract's address in the holder's HSI list.
2797      * @param hsiAddress Address of the HSI contract to be updated.
2798      * @param share "ShareCache" object containing updated share data.
2799      */
2800     function hsiUpdate (
2801         address holder,
2802         uint256 hsiIndex,
2803         address hsiAddress,
2804         ShareCache memory share
2805     )
2806         external
2807     {
2808         require(msg.sender == _creator,
2809             "HSIM: Caller must be contract creator");
2810 
2811         address[] storage hsiList = hsiLists[holder];
2812 
2813         require(hsiAddress == hsiList[hsiIndex],
2814             "HSIM: HSI index address mismatch");
2815 
2816         HEXStakeInstance hsi = HEXStakeInstance(hsiAddress);
2817         hsi.update(share);
2818     }
2819 
2820     /**
2821      * @dev Transfers ownership of a HEX stake instance (HSI) contract to a new address.
2822      *      This is a pivileged operation only Hedron.sol can call. End users can use
2823      *      the NFT tokenize / detokenize to handle HSI transfers.
2824      * @param currentHolder Address to transfer the HSI contract from.
2825      * @param hsiIndex Index of the HSI contract's address in the currentHolder's HSI list.
2826      * @param hsiAddress Address of the HSI contract to be transfered.
2827      * @param newHolder Address to transfer to HSI contract to.
2828      */
2829     function hsiTransfer (
2830         address currentHolder,
2831         uint256 hsiIndex,
2832         address hsiAddress,
2833         address newHolder
2834     )
2835         external
2836     {
2837         require(msg.sender == _creator,
2838             "HSIM: Caller must be contract creator");
2839 
2840         address[] storage hsiListCurrent = hsiLists[currentHolder];
2841         address[] storage hsiListNew = hsiLists[newHolder];
2842 
2843         require(hsiAddress == hsiListCurrent[hsiIndex],
2844             "HSIM: HSI index address mismatch");
2845 
2846         hsiListNew.push(hsiAddress);
2847         _pruneHSI(hsiListCurrent, hsiIndex);
2848 
2849         emit HSITransfer(
2850                     block.timestamp,
2851                     hsiAddress,
2852                     currentHolder,
2853                     newHolder
2854                 );
2855     }
2856 
2857     // External NFT Marketplace Glue
2858 
2859     /**
2860      * @dev Implements ERC2981 royalty functionality. We just read the royalty data from
2861      *      the Rarible V2 implementation. 
2862      * @param tokenId Unique ID of the HSI NFT token.
2863      * @param salePrice Price the HSI NFT token was sold for.
2864      * @return receiver address to send the royalties to as well as the royalty amount.
2865      */
2866     function royaltyInfo(
2867         uint256 tokenId,
2868         uint256 salePrice
2869     )
2870         external
2871         view
2872         returns (address receiver, uint256 royaltyAmount)
2873     {
2874         LibPart.Part[] memory _royalties = royalties[tokenId];
2875         
2876         if (_royalties.length > 0) {
2877             return (_royalties[0].account, (salePrice * _royalties[0].value) / 10000);
2878         }
2879 
2880         return (address(0), 0);
2881     }
2882 
2883     /**
2884      * @dev returns _hdrnFlowAddress, needed for some NFT marketplaces. This is not
2885      *       an admin key.
2886      * @return _hdrnFlowAddress
2887      */
2888     function owner(
2889     )
2890         external
2891         pure
2892         returns (address) 
2893     {
2894         return _hdrnFlowAddress;
2895     }
2896 
2897     /**
2898      * @dev Adds Rarible V2 and ERC2981 interface support.
2899      * @param interfaceId Unique contract interface identifier.
2900      * @return True if the interface is supported, false if not.
2901      */
2902     function supportsInterface(
2903         bytes4 interfaceId
2904     )
2905         public
2906         view
2907         virtual
2908         override(ERC721, ERC721Enumerable)
2909         returns (bool)
2910     {
2911         if (interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
2912             return true;
2913         }
2914 
2915         if (interfaceId == _INTERFACE_ID_ERC2981) {
2916             return true;
2917         }
2918 
2919         return super.supportsInterface(interfaceId);
2920     }
2921 }
2922 
2923 contract Hedron is ERC20 {
2924 
2925     using Counters for Counters.Counter;
2926 
2927     struct DailyDataStore {
2928         uint72 dayMintedTotal;
2929         uint72 dayLoanedTotal;
2930         uint72 dayBurntTotal;
2931         uint32 dayInterestRate;
2932         uint8  dayMintMultiplier;
2933     }
2934 
2935     struct DailyDataCache {
2936         uint256 _dayMintedTotal;
2937         uint256 _dayLoanedTotal;
2938         uint256 _dayBurntTotal;
2939         uint256 _dayInterestRate;
2940         uint256 _dayMintMultiplier;
2941     }
2942 
2943     struct LiquidationStore{
2944         uint256 liquidationStart;
2945         address hsiAddress;
2946         uint96  bidAmount;
2947         address liquidator;
2948         uint88  endOffset;
2949         bool    isActive;
2950     }
2951 
2952     struct LiquidationCache {
2953         uint256 _liquidationStart;
2954         address _hsiAddress;
2955         uint256 _bidAmount;
2956         address _liquidator;
2957         uint256 _endOffset;
2958         bool    _isActive;
2959     }
2960 
2961     uint256 constant private _hdrnLaunchDays             = 100;     // length of the launch phase bonus in Hedron days
2962     uint256 constant private _hdrnLoanInterestResolution = 1000000; // loan interest decimal resolution
2963     uint256 constant private _hdrnLoanInterestDivisor    = 2;       // relation of Hedron's interest rate to HEX's interest rate
2964     uint256 constant private _hdrnLoanPaymentWindow      = 30;      // how many Hedron days to roll into a single payment
2965     uint256 constant private _hdrnLoanDefaultThreshold   = 90;      // how many Hedron days before loan liquidation is allowed
2966    
2967     IHEX                                   private _hx;
2968     uint256                                private _hxLaunch;
2969     HEXStakeInstanceManager                private _hsim;
2970     Counters.Counter                       private _liquidationIds;
2971     address                                public  hsim;
2972     mapping(uint256 => ShareStore)         public  shareList;
2973     mapping(uint256 => DailyDataStore)     public  dailyDataList;
2974     mapping(uint256 => LiquidationStore)   public  liquidationList;
2975     uint256                                public  loanedSupply;
2976 
2977     constructor(
2978         address hexAddress,
2979         uint256 hexLaunch
2980     )
2981         ERC20("Hedron", "HDRN")
2982     {
2983         // set HEX contract address and launch time
2984         _hx = IHEX(payable(hexAddress));
2985         _hxLaunch = hexLaunch;
2986 
2987         // initialize HEX stake instance manager
2988         hsim = address(new HEXStakeInstanceManager(hexAddress));
2989         _hsim = HEXStakeInstanceManager(hsim);
2990     }
2991 
2992     function decimals()
2993         public
2994         view
2995         virtual
2996         override
2997         returns (uint8) 
2998     {
2999         return 9;
3000     }
3001     
3002     // Hedron Events
3003 
3004     event Claim(
3005         uint256         data,
3006         address indexed claimant,
3007         uint40  indexed stakeId
3008     );
3009 
3010     event Mint(
3011         uint256         data,
3012         address indexed minter,
3013         uint40  indexed stakeId
3014     );
3015 
3016     event LoanStart(
3017         uint256         data,
3018         address indexed borrower,
3019         uint40  indexed stakeId
3020     );
3021 
3022     event LoanPayment(
3023         uint256         data,
3024         address indexed borrower,
3025         uint40  indexed stakeId
3026     );
3027 
3028     event LoanEnd(
3029         uint256         data,
3030         address indexed borrower,
3031         uint40  indexed stakeId
3032     );
3033 
3034     event LoanLiquidateStart(
3035         uint256         data,
3036         address indexed borrower,
3037         uint40  indexed stakeId,
3038         uint40  indexed liquidationId
3039     );
3040 
3041     event LoanLiquidateBid(
3042         uint256         data,
3043         address indexed bidder,
3044         uint40  indexed stakeId,
3045         uint40  indexed liquidationId
3046     );
3047 
3048     event LoanLiquidateExit(
3049         uint256         data,
3050         address indexed liquidator,
3051         uint40  indexed stakeId,
3052         uint40  indexed liquidationId
3053     );
3054 
3055     // Hedron Private Functions
3056 
3057     function _emitClaim(
3058         uint40  stakeId,
3059         uint256 stakeShares,
3060         uint256 launchBonus
3061     )
3062         private
3063     {
3064         emit Claim(
3065             uint256(uint40 (block.timestamp))
3066                 |  (uint256(uint72 (stakeShares)) << 40)
3067                 |  (uint256(uint144(launchBonus)) << 112),
3068             msg.sender,
3069             stakeId
3070         );
3071     }
3072 
3073     function _emitMint(
3074         ShareCache memory share,
3075         uint256 payout
3076     )
3077         private
3078     {
3079         emit Mint(
3080             uint256(uint40 (block.timestamp))
3081                 |  (uint256(uint72 (share._stake.stakeShares)) << 40)
3082                 |  (uint256(uint16 (share._mintedDays))        << 112)
3083                 |  (uint256(uint8  (share._launchBonus))       << 128)
3084                 |  (uint256(uint120(payout))                   << 136),
3085             msg.sender,
3086             share._stake.stakeId
3087         );
3088     }
3089 
3090     function _emitLoanStart(
3091         ShareCache memory share,
3092         uint256 borrowed
3093     )
3094         private
3095     {
3096         emit LoanStart(
3097             uint256(uint40 (block.timestamp))
3098                 |  (uint256(uint72(share._stake.stakeShares)) << 40)
3099                 |  (uint256(uint16(share._loanedDays))        << 112)
3100                 |  (uint256(uint32(share._interestRate))      << 128)
3101                 |  (uint256(uint96(borrowed))                 << 160),
3102             msg.sender,
3103             share._stake.stakeId
3104         );
3105     }
3106 
3107     function _emitLoanPayment(
3108         ShareCache memory share,
3109         uint256 payment
3110     )
3111         private
3112     {
3113         emit LoanPayment(
3114             uint256(uint40 (block.timestamp))
3115                 |  (uint256(uint72(share._stake.stakeShares)) << 40)
3116                 |  (uint256(uint16(share._loanedDays))        << 112)
3117                 |  (uint256(uint32(share._interestRate))      << 128)
3118                 |  (uint256(uint8 (share._paymentsMade))      << 160)
3119                 |  (uint256(uint88(payment))                  << 168),
3120             msg.sender,
3121             share._stake.stakeId
3122         );
3123     }
3124 
3125     function _emitLoanEnd(
3126         ShareCache memory share,
3127         uint256 payoff
3128     )
3129         private
3130     {
3131         emit LoanEnd(
3132             uint256(uint40 (block.timestamp))
3133                 |  (uint256(uint72(share._stake.stakeShares)) << 40)
3134                 |  (uint256(uint16(share._loanedDays))        << 112)
3135                 |  (uint256(uint32(share._interestRate))      << 128)
3136                 |  (uint256(uint8 (share._paymentsMade))      << 160)
3137                 |  (uint256(uint88(payoff))                   << 168),
3138             msg.sender,
3139             share._stake.stakeId
3140         );
3141     }
3142 
3143     function _emitLoanLiquidateStart(
3144         ShareCache memory share,
3145         uint40  liquidationId,
3146         address borrower,
3147         uint256 startingBid
3148     )
3149         private
3150     {
3151         emit LoanLiquidateStart(
3152             uint256(uint40 (block.timestamp))
3153                 |  (uint256(uint72(share._stake.stakeShares)) << 40)
3154                 |  (uint256(uint16(share._loanedDays))        << 112)
3155                 |  (uint256(uint32(share._interestRate))      << 128)
3156                 |  (uint256(uint8 (share._paymentsMade))      << 160)
3157                 |  (uint256(uint88(startingBid))              << 168),
3158             borrower,
3159             share._stake.stakeId,
3160             liquidationId
3161         );
3162     }
3163 
3164     function _emitLoanLiquidateBid(
3165         uint40  stakeId,
3166         uint40  liquidationId,
3167         uint256 bidAmount
3168     )
3169         private
3170     {
3171         emit LoanLiquidateBid(
3172             uint256(uint40 (block.timestamp))
3173                 |  (uint256(uint216(bidAmount)) << 40),
3174             msg.sender,
3175             stakeId,
3176             liquidationId
3177         );
3178     }
3179 
3180     function _emitLoanLiquidateExit(
3181         uint40  stakeId,
3182         uint40  liquidationId,
3183         address liquidator,
3184         uint256 finalBid
3185     )
3186         private
3187     {
3188         emit LoanLiquidateExit(
3189             uint256(uint40 (block.timestamp))
3190                 |  (uint256(uint216(finalBid)) << 40),
3191             liquidator,
3192             stakeId,
3193             liquidationId
3194         );
3195     }
3196 
3197     // HEX Internal Functions
3198 
3199     /**
3200      * @dev Calculates the current HEX day.
3201      * @return Number representing the current HEX day.
3202      */
3203     function _hexCurrentDay()
3204         internal
3205         view
3206         returns (uint256)
3207     {
3208         return (block.timestamp - _hxLaunch) / 1 days;
3209     }
3210     
3211     /**
3212      * @dev Loads HEX daily data values from the HEX contract into a "HEXDailyData" object.
3213      * @param hexDay The HEX day to obtain daily data for.
3214      * @return "HEXDailyData" object containing the daily data values returned by the HEX contract.
3215      */
3216     function _hexDailyDataLoad(
3217         uint256 hexDay
3218     )
3219         internal
3220         view
3221         returns (HEXDailyData memory)
3222     {
3223         uint72 dayPayoutTotal;
3224         uint72 dayStakeSharesTotal;
3225         uint56 dayUnclaimedSatoshisTotal;
3226 
3227         (dayPayoutTotal,
3228          dayStakeSharesTotal,
3229          dayUnclaimedSatoshisTotal) = _hx.dailyData(hexDay);
3230 
3231         return HEXDailyData(
3232             dayPayoutTotal,
3233             dayStakeSharesTotal,
3234             dayUnclaimedSatoshisTotal
3235         );
3236 
3237     }
3238 
3239     /**
3240      * @dev Loads HEX global values from the HEX contract into a "HEXGlobals" object.
3241      * @return "HEXGlobals" object containing the global values returned by the HEX contract.
3242      */
3243     function _hexGlobalsLoad()
3244         internal
3245         view
3246         returns (HEXGlobals memory)
3247     {
3248         uint72  lockedHeartsTotal;
3249         uint72  nextStakeSharesTotal;
3250         uint40  shareRate;
3251         uint72  stakePenaltyTotal;
3252         uint16  dailyDataCount;
3253         uint72  stakeSharesTotal;
3254         uint40  latestStakeId;
3255         uint128 claimStats;
3256 
3257         (lockedHeartsTotal,
3258          nextStakeSharesTotal,
3259          shareRate,
3260          stakePenaltyTotal,
3261          dailyDataCount,
3262          stakeSharesTotal,
3263          latestStakeId,
3264          claimStats) = _hx.globals();
3265 
3266         return HEXGlobals(
3267             lockedHeartsTotal,
3268             nextStakeSharesTotal,
3269             shareRate,
3270             stakePenaltyTotal,
3271             dailyDataCount,
3272             stakeSharesTotal,
3273             latestStakeId,
3274             claimStats
3275         );
3276     }
3277 
3278     /**
3279      * @dev Loads HEX stake values from the HEX contract into a "HEXStake" object.
3280      * @param stakeIndex The index of the desired HEX stake within the sender's HEX stake list.
3281      * @return "HEXStake" object containing the stake values returned by the HEX contract.
3282      */
3283     function _hexStakeLoad(
3284         uint256 stakeIndex
3285     )
3286         internal
3287         view
3288         returns (HEXStake memory)
3289     {
3290         uint40 stakeId;
3291         uint72 stakedHearts;
3292         uint72 stakeShares;
3293         uint16 lockedDay;
3294         uint16 stakedDays;
3295         uint16 unlockedDay;
3296         bool   isAutoStake;
3297         
3298         (stakeId,
3299          stakedHearts,
3300          stakeShares,
3301          lockedDay,
3302          stakedDays,
3303          unlockedDay,
3304          isAutoStake) = _hx.stakeLists(msg.sender, stakeIndex);
3305          
3306          return HEXStake(
3307             stakeId,
3308             stakedHearts,
3309             stakeShares,
3310             lockedDay,
3311             stakedDays,
3312             unlockedDay,
3313             isAutoStake
3314         );
3315     }
3316     
3317     // Hedron Internal Functions
3318 
3319     /**
3320      * @dev Calculates the current Hedron day.
3321      * @return Number representing the current Hedron day.
3322      */
3323     function _currentDay()
3324         internal
3325         view
3326         returns (uint256)
3327     {
3328         return (block.timestamp - _hdrnLaunch) / 1 days;
3329     }
3330 
3331     /**
3332      * @dev Calculates the multiplier to be used for the Launch Phase Bonus.
3333      * @param launchDay The current day of the Hedron launch phase.
3334      * @return Multiplier to use for the given launch day.
3335      */
3336     function _calcLPBMultiplier (
3337         uint256 launchDay
3338     )
3339         internal
3340         pure
3341         returns (uint256)
3342     {
3343         if (launchDay > 90) {
3344             return 100;
3345         }
3346         else if (launchDay > 80) {
3347             return 90;
3348         }
3349         else if (launchDay > 70) {
3350             return 80;
3351         }
3352         else if (launchDay > 60) {
3353             return 70;
3354         }
3355         else if (launchDay > 50) {
3356             return 60;
3357         }
3358         else if (launchDay > 40) {
3359             return 50;
3360         }
3361         else if (launchDay > 30) {
3362             return 40;
3363         }
3364         else if (launchDay > 20) {
3365             return 30;
3366         }
3367         else if (launchDay > 10) {
3368             return 20;
3369         }
3370         else if (launchDay > 0) {
3371             return 10;
3372         }
3373 
3374         return 0;
3375     }
3376 
3377     /**
3378      * @dev Calculates the number of bonus HDRN tokens to be minted in regards to minting bonuses.
3379      * @param multiplier The multiplier to use, increased by a factor of 10.
3380      * @param payout Payout to apply the multiplier towards.
3381      * @return Number of tokens to mint as a bonus.
3382      */
3383     function _calcBonus(
3384         uint256 multiplier, 
3385         uint256 payout
3386     )
3387         internal
3388         pure
3389         returns (uint256)
3390     {   
3391         return uint256((payout * multiplier) / 10);
3392     }
3393 
3394     /**
3395      * @dev Loads values from a "DailyDataStore" object into a "DailyDataCache" object.
3396      * @param dayStore "DailyDataStore" object to be loaded.
3397      * @param day "DailyDataCache" object to be populated with storage data.
3398      */
3399     function _dailyDataLoad(
3400         DailyDataStore storage dayStore,
3401         DailyDataCache memory  day
3402     )
3403         internal
3404         view
3405     {
3406         day._dayMintedTotal    = dayStore.dayMintedTotal;
3407         day._dayLoanedTotal    = dayStore.dayLoanedTotal;
3408         day._dayBurntTotal     = dayStore.dayBurntTotal;
3409         day._dayInterestRate   = dayStore.dayInterestRate;
3410         day._dayMintMultiplier = dayStore.dayMintMultiplier;
3411 
3412         if (day._dayInterestRate == 0) {
3413             uint256 hexCurrentDay = _hexCurrentDay();
3414 
3415             /* There is a very small window of time where it would be technically possible to pull
3416                HEX dailyData that is not yet defined. While unlikely to happen, we should prevent
3417                the possibility by pulling data from two days prior. This means our interest rate
3418                will slightly lag behind HEX's interest rate. */
3419             HEXDailyData memory hexDailyData         = _hexDailyDataLoad(hexCurrentDay - 2);
3420             HEXGlobals   memory hexGlobals           = _hexGlobalsLoad();
3421             uint256             hexDailyInterestRate = (hexDailyData.dayPayoutTotal * _hdrnLoanInterestResolution) / hexGlobals.lockedHeartsTotal;
3422 
3423             day._dayInterestRate = hexDailyInterestRate / _hdrnLoanInterestDivisor;
3424 
3425             /* Ideally we want a 50/50 split between loaned and minted Hedron. If less than 50% of the total supply is minted, allocate a bonus
3426                multiplier and scale it from 0 to 10. This is to attempt to prevent a situation where there is not enough available minted supply
3427                to cover loan interest. */
3428             if (loanedSupply > 0 && totalSupply() > 0) {
3429                 uint256 loanedToMinted = (loanedSupply * 100) / totalSupply();
3430                 if (loanedToMinted > 50) {
3431                     day._dayMintMultiplier = (loanedToMinted - 50) * 2;
3432                 }
3433             }
3434         }
3435     }
3436 
3437     /**
3438      * @dev Updates a "DailyDataStore" object with values stored in a "DailyDataCache" object.
3439      * @param dayStore "DailyDataStore" object to be updated.
3440      * @param day "DailyDataCache" object with updated values.
3441      */
3442     function _dailyDataUpdate(
3443         DailyDataStore storage dayStore,
3444         DailyDataCache memory  day
3445     )
3446         internal
3447     {
3448         dayStore.dayMintedTotal    = uint72(day._dayMintedTotal);
3449         dayStore.dayLoanedTotal    = uint72(day._dayLoanedTotal);
3450         dayStore.dayBurntTotal     = uint72(day._dayBurntTotal);
3451         dayStore.dayInterestRate   = uint32(day._dayInterestRate);
3452         dayStore.dayMintMultiplier = uint8(day._dayMintMultiplier);
3453     }
3454 
3455     /**
3456      * @dev Loads share data from a HEX stake instance (HSI) into a "ShareCache" object.
3457      * @param hsi The HSI to load share data from.
3458      * @return "ShareCache" object containing the share data of the HSI.
3459      */
3460     function _hsiLoad(
3461         HEXStakeInstance hsi
3462     ) 
3463         internal
3464         view
3465         returns (ShareCache memory)
3466     {
3467         HEXStakeMinimal memory stake;
3468 
3469         uint16 mintedDays;
3470         uint8  launchBonus;
3471         uint16 loanStart;
3472         uint16 loanedDays;
3473         uint32 interestRate;
3474         uint8  paymentsMade;
3475         bool   isLoaned;
3476 
3477         (stake,
3478          mintedDays,
3479          launchBonus,
3480          loanStart,
3481          loanedDays,
3482          interestRate,
3483          paymentsMade,
3484          isLoaned) = hsi.share();
3485 
3486         return ShareCache(
3487             stake,
3488             mintedDays,
3489             launchBonus,
3490             loanStart,
3491             loanedDays,
3492             interestRate,
3493             paymentsMade,
3494             isLoaned
3495         );
3496     }
3497 
3498     /**
3499      * @dev Creates (or overwrites) a new share element in the share list.
3500      * @param stake "HEXStakeMinimal" object with which the share element is tied to.
3501      * @param mintedDays Amount of Hedron days the HEX stake has been minted against.
3502      * @param launchBonus The launch bonus multiplier of the share element.
3503      * @param loanStart The Hedron day the loan was started
3504      * @param loanedDays Amount of Hedron days the HEX stake has been borrowed against.
3505      * @param interestRate The interest rate of the loan.
3506      * @param paymentsMade Amount of payments made towards the loan.
3507      * @param isLoaned Flag used to determine if the HEX stake is currently borrowed against..
3508      */
3509     function _shareAdd(
3510         HEXStakeMinimal memory stake,
3511         uint256 mintedDays,
3512         uint256 launchBonus,
3513         uint256 loanStart,
3514         uint256 loanedDays,
3515         uint256 interestRate,
3516         uint256 paymentsMade,
3517         bool    isLoaned
3518     )
3519         internal
3520     {
3521         shareList[stake.stakeId] =
3522             ShareStore(
3523                 stake,
3524                 uint16(mintedDays),
3525                 uint8(launchBonus),
3526                 uint16(loanStart),
3527                 uint16(loanedDays),
3528                 uint32(interestRate),
3529                 uint8(paymentsMade),
3530                 isLoaned
3531             );
3532     }
3533 
3534     /**
3535      * @dev Creates a new liquidation element in the liquidation list.
3536      * @param hsiAddress Address of the HEX Stake Instance (HSI) being liquidated.
3537      * @param liquidator Address of the user starting the liquidation process.
3538      * @param liquidatorBid Bid amount (in HDRN) the user is starting the liquidation process with.
3539      * @return ID of the liquidation element.
3540      */
3541     function _liquidationAdd(
3542         address hsiAddress,
3543         address liquidator,
3544         uint256 liquidatorBid
3545     )
3546         internal
3547         returns (uint256)
3548     {
3549         _liquidationIds.increment();
3550 
3551         liquidationList[_liquidationIds.current()] =
3552             LiquidationStore (
3553                 block.timestamp,
3554                 hsiAddress,
3555                 uint96(liquidatorBid),
3556                 liquidator,
3557                 uint88(0),
3558                 true
3559             );
3560 
3561         return _liquidationIds.current();
3562     }
3563     
3564     /**
3565      * @dev Loads values from a "ShareStore" object into a "ShareCache" object.
3566      * @param shareStore "ShareStore" object to be loaded.
3567      * @param share "ShareCache" object to be populated with storage data.
3568      */
3569     function _shareLoad(
3570         ShareStore storage shareStore,
3571         ShareCache memory  share
3572     )
3573         internal
3574         view
3575     {
3576         share._stake        = shareStore.stake;
3577         share._mintedDays   = shareStore.mintedDays;
3578         share._launchBonus  = shareStore.launchBonus;
3579         share._loanStart    = shareStore.loanStart;
3580         share._loanedDays   = shareStore.loanedDays;
3581         share._interestRate = shareStore.interestRate;
3582         share._paymentsMade = shareStore.paymentsMade;
3583         share._isLoaned     = shareStore.isLoaned;
3584     }
3585 
3586     /**
3587      * @dev Loads values from a "LiquidationStore" object into a "LiquidationCache" object.
3588      * @param liquidationStore "LiquidationStore" object to be loaded.
3589      * @param liquidation "LiquidationCache" object to be populated with storage data.
3590      */
3591     function _liquidationLoad(
3592         LiquidationStore storage liquidationStore,
3593         LiquidationCache memory  liquidation
3594     ) 
3595         internal
3596         view
3597     {
3598         liquidation._liquidationStart = liquidationStore.liquidationStart;
3599         liquidation._endOffset        = liquidationStore.endOffset;
3600         liquidation._hsiAddress       = liquidationStore.hsiAddress;
3601         liquidation._liquidator       = liquidationStore.liquidator;
3602         liquidation._bidAmount        = liquidationStore.bidAmount;
3603         liquidation._isActive         = liquidationStore.isActive;
3604     }
3605     
3606     /**
3607      * @dev Updates a "ShareStore" object with values stored in a "ShareCache" object.
3608      * @param shareStore "ShareStore" object to be updated.
3609      * @param share "ShareCache object with updated values.
3610      */
3611     function _shareUpdate(
3612         ShareStore storage shareStore,
3613         ShareCache memory  share
3614     )
3615         internal
3616     {
3617         shareStore.stake        = share._stake;
3618         shareStore.mintedDays   = uint16(share._mintedDays);
3619         shareStore.launchBonus  = uint8(share._launchBonus);
3620         shareStore.loanStart    = uint16(share._loanStart);
3621         shareStore.loanedDays   = uint16(share._loanedDays);
3622         shareStore.interestRate = uint32(share._interestRate);
3623         shareStore.paymentsMade = uint8(share._paymentsMade);
3624         shareStore.isLoaned     = share._isLoaned;
3625     }
3626 
3627     /**
3628      * @dev Updates a "LiquidationStore" object with values stored in a "LiquidationCache" object.
3629      * @param liquidationStore "LiquidationStore" object to be updated.
3630      * @param liquidation "LiquidationCache" object with updated values.
3631      */
3632     function _liquidationUpdate(
3633         LiquidationStore storage liquidationStore,
3634         LiquidationCache memory  liquidation
3635     ) 
3636         internal
3637     {
3638         liquidationStore.endOffset  = uint48(liquidation._endOffset);
3639         liquidationStore.hsiAddress = liquidation._hsiAddress;
3640         liquidationStore.liquidator = liquidation._liquidator;
3641         liquidationStore.bidAmount  = uint96(liquidation._bidAmount);
3642         liquidationStore.isActive   = liquidation._isActive;
3643     }
3644 
3645     /**
3646      * @dev Attempts to match a "HEXStake" object to an existing share element within the share list.
3647      * @param stake "HEXStake" object to be matched.
3648      * @return Boolean indicating if the HEX stake was matched and it's index within the stake list as separate values.
3649      */
3650     function _shareSearch(
3651         HEXStake memory stake
3652     ) 
3653         internal
3654         view
3655         returns (bool, uint256)
3656     {
3657         bool stakeInShareList = false;
3658         uint256 shareIndex = 0;
3659         
3660         ShareCache memory share;
3661 
3662         _shareLoad(shareList[stake.stakeId], share);
3663             
3664         // stake matches an existing share element
3665         if (share._stake.stakeId     == stake.stakeId &&
3666             share._stake.stakeShares == stake.stakeShares &&
3667             share._stake.lockedDay   == stake.lockedDay &&
3668             share._stake.stakedDays  == stake.stakedDays)
3669         {
3670             stakeInShareList = true;
3671             shareIndex = stake.stakeId;
3672         }
3673             
3674         return(stakeInShareList, shareIndex);
3675     }
3676 
3677     // Hedron External Functions
3678 
3679     /**
3680      * @dev Returns the current Hedron day.
3681      * @return Current Hedron day
3682      */
3683     function currentDay()
3684         external
3685         view
3686         returns (uint256)
3687     {
3688         return _currentDay();
3689     }
3690 
3691     /**
3692      * @dev Claims the launch phase bonus for a HEX stake instance (HSI). It also injects
3693      *      the HSI share data into into the shareList. This is a privileged  operation 
3694      *      only HEXStakeInstanceManager.sol can call.
3695      * @param hsiIndex Index of the HSI contract address in the sender's HSI list.
3696      *                 (see hsiLists -> HEXStakeInstanceManager.sol)
3697      * @param hsiAddress Address of the HSI contract which coinsides with the index.
3698      * @param hsiStarterAddress Address of the user creating the HSI.
3699      */
3700     function claimInstanced(
3701         uint256 hsiIndex,
3702         address hsiAddress,
3703         address hsiStarterAddress
3704     )
3705         external
3706     {
3707         require(msg.sender == hsim,
3708             "HSIM: Caller must be HSIM");
3709 
3710         address _hsiAddress = _hsim.hsiLists(hsiStarterAddress, hsiIndex);
3711         require(hsiAddress == _hsiAddress,
3712             "HDRN: HSI index address mismatch");
3713 
3714         ShareCache memory share = _hsiLoad(HEXStakeInstance(hsiAddress));
3715 
3716         if (_currentDay() < _hdrnLaunchDays) {
3717             share._launchBonus = _calcLPBMultiplier(_hdrnLaunchDays - _currentDay());
3718             _emitClaim(share._stake.stakeId, share._stake.stakeShares, share._launchBonus);
3719         }
3720 
3721         _hsim.hsiUpdate(hsiStarterAddress, hsiIndex, hsiAddress, share);
3722 
3723         _shareAdd(
3724             share._stake,
3725             share._mintedDays,
3726             share._launchBonus,
3727             share._loanStart,
3728             share._loanedDays,
3729             share._interestRate,
3730             share._paymentsMade,
3731             share._isLoaned
3732         );
3733     }
3734     
3735     /**
3736      * @dev Mints Hedron ERC20 (HDRN) tokens to the sender using a HEX stake instance (HSI) backing.
3737      *      HDRN Minted = HEX Stake B-Shares * (Days Served - Days Already Minted)
3738      * @param hsiIndex Index of the HSI contract address in the sender's HSI list.
3739      *                 (see hsiLists -> HEXStakeInstanceManager.sol)
3740      * @param hsiAddress Address of the HSI contract which coinsides with the index.
3741      * @return Amount of HDRN ERC20 tokens minted.
3742      */
3743     function mintInstanced(
3744         uint256 hsiIndex,
3745         address hsiAddress
3746     ) 
3747         external
3748         returns (uint256)
3749     {
3750         require(block.timestamp >= _hdrnLaunch,
3751             "HDRN: Contract not yet active");
3752 
3753         DailyDataCache memory  day;
3754         DailyDataStore storage dayStore = dailyDataList[_currentDay()];
3755 
3756         _dailyDataLoad(dayStore, day);
3757 
3758         address _hsiAddress = _hsim.hsiLists(msg.sender, hsiIndex);
3759         require(hsiAddress == _hsiAddress,
3760             "HDRN: HSI index address mismatch");
3761 
3762         ShareCache memory share = _hsiLoad(HEXStakeInstance(hsiAddress));
3763         require(_hexCurrentDay() >= share._stake.lockedDay,
3764             "HDRN: cannot mint against a pending HEX stake");
3765         require(share._isLoaned == false,
3766             "HDRN: cannot mint against a loaned HEX stake");
3767 
3768         uint256 servedDays = 0;
3769         uint256 mintDays   = 0;
3770         uint256 payout     = 0;
3771 
3772         servedDays = _hexCurrentDay() - share._stake.lockedDay;
3773         
3774         // served days should never exceed staked days
3775         if (servedDays > share._stake.stakedDays) {
3776             servedDays = share._stake.stakedDays;
3777         }
3778         
3779         // remove days already minted from the payout
3780         mintDays = servedDays - share._mintedDays;
3781 
3782         // base payout
3783         payout = share._stake.stakeShares * mintDays;
3784                
3785         // launch phase bonus
3786         if (share._launchBonus > 0) {
3787             uint256 bonus = _calcBonus(share._launchBonus, payout);
3788             if (bonus > 0) {
3789                 // send bonus copy to the source address
3790                 _mint(_hdrnSourceAddress, bonus);
3791                 day._dayMintedTotal += bonus;
3792                 payout += bonus;
3793             }
3794         }
3795         else if (_currentDay() < _hdrnLaunchDays) {
3796             share._launchBonus = _calcLPBMultiplier(_hdrnLaunchDays - _currentDay());
3797             uint256 bonus = _calcBonus(share._launchBonus, payout);
3798             if (bonus > 0) {
3799                 // send bonus copy to the source address
3800                 _mint(_hdrnSourceAddress, bonus);
3801                 day._dayMintedTotal += bonus;
3802                 payout += bonus;
3803             }
3804         }
3805 
3806         // loan to mint ratio bonus
3807         if (day._dayMintMultiplier > 0) {
3808             uint256 bonus = _calcBonus(day._dayMintMultiplier, payout);
3809             if (bonus > 0) {
3810                 // send bonus copy to the source address
3811                 _mint(_hdrnSourceAddress, bonus);
3812                 day._dayMintedTotal += bonus;
3813                 payout += bonus;
3814             }
3815         }
3816         
3817         share._mintedDays += mintDays;
3818 
3819         // mint final payout to the sender
3820         if (payout > 0) {
3821             _mint(msg.sender, payout);
3822 
3823             _emitMint(
3824                 share,
3825                 payout
3826             );
3827         }
3828 
3829         day._dayMintedTotal += payout;
3830 
3831         // update HEX stake instance
3832         _hsim.hsiUpdate(msg.sender, hsiIndex, hsiAddress, share);
3833         _shareUpdate(shareList[share._stake.stakeId], share);
3834 
3835         _dailyDataUpdate(dayStore, day);
3836 
3837         return payout;
3838     }
3839     
3840     /**
3841      * @dev Claims the launch phase bonus for a naitve HEX stake.
3842      * @param stakeIndex Index of the HEX stake in sender's HEX stake list.
3843      *                   (see stakeLists -> HEX.sol)
3844      * @param stakeId ID of the HEX stake which coinsides with the index.
3845      * @return Number representing the launch bonus of the claimed HEX stake
3846      *         increased by a factor of 10 for decimal resolution.
3847      */
3848     function claimNative(
3849         uint256 stakeIndex,
3850         uint40  stakeId
3851     )
3852         external
3853         returns (uint256)
3854     {
3855         require(block.timestamp >= _hdrnLaunch,
3856             "HDRN: Contract not yet active");
3857 
3858         HEXStake memory stake = _hexStakeLoad(stakeIndex);
3859 
3860         require(stake.stakeId == stakeId,
3861             "HDRN: HEX stake index id mismatch");
3862 
3863         bool stakeInShareList = false;
3864         uint256 shareIndex    = 0;
3865         uint256 launchBonus   = 0;
3866         
3867         // check if share element already exists in the sender's mapping
3868         (stakeInShareList,
3869          shareIndex) = _shareSearch(stake);
3870 
3871         require(stakeInShareList == false,
3872             "HDRN: HEX Stake already claimed");
3873 
3874         if (_currentDay() < _hdrnLaunchDays) {
3875             launchBonus = _calcLPBMultiplier(_hdrnLaunchDays - _currentDay());
3876             _emitClaim(stake.stakeId, stake.stakeShares, launchBonus);
3877         }
3878 
3879         _shareAdd(
3880             HEXStakeMinimal(
3881                 stake.stakeId,
3882                 stake.stakeShares,
3883                 stake.lockedDay,
3884                 stake.stakedDays
3885             ),
3886             0,
3887             launchBonus,
3888             0,
3889             0,
3890             0,
3891             0,
3892             false
3893         );
3894 
3895         return launchBonus;
3896     }
3897 
3898     /**
3899      * @dev Mints Hedron ERC20 (HDRN) tokens to the sender using a native HEX stake backing.
3900      *      HDRN Minted = HEX Stake B-Shares * (Days Served - Days Already Minted)
3901      * @param stakeIndex Index of the HEX stake in sender's HEX stake list (see stakeLists -> HEX.sol).
3902      * @param stakeId ID of the HEX stake which coinsides with the index.
3903      * @return Amount of HDRN ERC20 tokens minted.
3904      */
3905     function mintNative(
3906         uint256 stakeIndex,
3907         uint40 stakeId
3908     )
3909         external
3910         returns (uint256)
3911     {
3912         require(block.timestamp >= _hdrnLaunch,
3913             "HDRN: Contract not yet active");
3914 
3915         DailyDataCache memory  day;
3916         DailyDataStore storage dayStore = dailyDataList[_currentDay()];
3917 
3918         _dailyDataLoad(dayStore, day);
3919         
3920         HEXStake memory stake = _hexStakeLoad(stakeIndex);
3921     
3922         require(stake.stakeId == stakeId,
3923             "HDRN: HEX stake index id mismatch");
3924         require(_hexCurrentDay() >= stake.lockedDay,
3925             "HDRN: cannot mint against a pending HEX stake");
3926         
3927         bool stakeInShareList = false;
3928         uint256 shareIndex    = 0;
3929         uint256 servedDays    = 0;
3930         uint256 mintDays      = 0;
3931         uint256 payout        = 0;
3932         uint256 launchBonus   = 0;
3933 
3934         ShareCache memory share;
3935         
3936         // check if share element already exists in the sender's mapping
3937         (stakeInShareList,
3938          shareIndex) = _shareSearch(stake);
3939         
3940         // stake matches an existing share element
3941         if (stakeInShareList) {
3942             _shareLoad(shareList[shareIndex], share);
3943             
3944             servedDays = _hexCurrentDay() - share._stake.lockedDay;
3945             
3946             // served days should never exceed staked days
3947             if (servedDays > share._stake.stakedDays) {
3948                 servedDays = share._stake.stakedDays;
3949             }
3950             
3951             // remove days already minted from the payout
3952             mintDays = servedDays - share._mintedDays;
3953             
3954             // base payout
3955             payout = share._stake.stakeShares * mintDays;
3956             
3957             // launch phase bonus
3958             if (share._launchBonus > 0) {
3959                 uint256 bonus = _calcBonus(share._launchBonus, payout);
3960                 if (bonus > 0) {
3961                     // send bonus copy to the source address
3962                     _mint(_hdrnSourceAddress, bonus);
3963                     day._dayMintedTotal += bonus;
3964                     payout += bonus;
3965                 }
3966             }
3967 
3968             // loan to mint ratio bonus
3969             if (day._dayMintMultiplier > 0) {
3970                 uint256 bonus = _calcBonus(day._dayMintMultiplier, payout);
3971                 if (bonus > 0) {
3972                     // send bonus copy to the source address
3973                     _mint(_hdrnSourceAddress, bonus);
3974                     day._dayMintedTotal += bonus;
3975                     payout += bonus;
3976                 }
3977             }
3978             
3979             share._mintedDays += mintDays;
3980 
3981             // mint final payout to the sender
3982             if (payout > 0) {
3983                 _mint(msg.sender, payout);
3984 
3985                 _emitMint(
3986                     share,
3987                     payout
3988                 );
3989             }
3990             
3991             // update existing share mapping
3992             _shareUpdate(shareList[shareIndex], share);
3993         }
3994         
3995         // stake does not match an existing share element
3996         else {
3997             servedDays = _hexCurrentDay() - stake.lockedDay;
3998  
3999             // served days should never exceed staked days
4000             if (servedDays > stake.stakedDays) {
4001                 servedDays = stake.stakedDays;
4002             }
4003 
4004             // base payout
4005             payout = stake.stakeShares * servedDays;
4006                
4007             // launch phase bonus
4008             if (_currentDay() < _hdrnLaunchDays) {
4009                 launchBonus = _calcLPBMultiplier(_hdrnLaunchDays - _currentDay());
4010                 uint256 bonus = _calcBonus(launchBonus, payout);
4011                 if (bonus > 0) {
4012                     // send bonus copy to the source address
4013                     _mint(_hdrnSourceAddress, bonus);
4014                     day._dayMintedTotal += bonus;
4015                     payout += bonus;
4016                 }
4017             }
4018 
4019             // loan to mint ratio bonus
4020             if (day._dayMintMultiplier > 0) {
4021                 uint256 bonus = _calcBonus(day._dayMintMultiplier, payout);
4022                 if (bonus > 0) {
4023                     // send bonus copy to the source address
4024                     _mint(_hdrnSourceAddress, bonus);
4025                     day._dayMintedTotal += bonus;
4026                     payout += bonus;
4027                 }
4028             }
4029 
4030             // create a new share element for the sender
4031             _shareAdd(
4032                 HEXStakeMinimal(
4033                     stake.stakeId,
4034                     stake.stakeShares, 
4035                     stake.lockedDay,
4036                     stake.stakedDays
4037                 ),
4038                 servedDays,
4039                 launchBonus,
4040                 0,
4041                 0,
4042                 0,
4043                 0,
4044                 false
4045             );
4046 
4047             _shareLoad(shareList[stake.stakeId], share);
4048             
4049             // mint final payout to the sender
4050             if (payout > 0) {
4051                 _mint(msg.sender, payout);
4052 
4053                 _emitMint(
4054                     share,
4055                     payout
4056                 );
4057             }
4058         }
4059 
4060         day._dayMintedTotal += payout;
4061         
4062         _dailyDataUpdate(dayStore, day);
4063 
4064         return payout;
4065     }
4066 
4067     /**
4068      * @dev Calculates the payment for existing and non-existing HEX stake instance (HSI) loans.
4069      * @param borrower Address which has mapped ownership the HSI contract.
4070      * @param hsiIndex Index of the HSI contract address in the sender's HSI list.
4071      *                 (see hsiLists -> HEXStakeInstanceManager.sol)
4072      * @param hsiAddress Address of the HSI contract which coinsides with the index.
4073      * @return Payment amount with principal and interest as serparate values.
4074      */
4075     function calcLoanPayment (
4076         address borrower,
4077         uint256 hsiIndex,
4078         address hsiAddress
4079     ) 
4080         external
4081         view
4082         returns (uint256, uint256)
4083     {
4084         require(block.timestamp >= _hdrnLaunch,
4085             "HDRN: Contract not yet active");
4086 
4087         DailyDataCache memory  day;
4088         DailyDataStore storage dayStore = dailyDataList[_currentDay()];
4089 
4090         _dailyDataLoad(dayStore, day);
4091         
4092         address _hsiAddress = _hsim.hsiLists(borrower, hsiIndex);
4093         require(hsiAddress == _hsiAddress,
4094             "HDRN: HSI index address mismatch");
4095 
4096         ShareCache memory share = _hsiLoad(HEXStakeInstance(hsiAddress));
4097 
4098         uint256 loanTermPaid      = share._paymentsMade * _hdrnLoanPaymentWindow;
4099         uint256 loanTermRemaining = share._loanedDays - loanTermPaid;
4100         uint256 principal         = 0;
4101         uint256 interest          = 0;
4102 
4103         // loan already exists
4104         if (share._interestRate > 0) {
4105 
4106             // remaining term is greater than a single payment window
4107             if (loanTermRemaining > _hdrnLoanPaymentWindow) {
4108                 principal = share._stake.stakeShares * _hdrnLoanPaymentWindow;
4109                 interest  = (principal * (share._interestRate * _hdrnLoanPaymentWindow)) / _hdrnLoanInterestResolution;
4110             }
4111             // remaing term is less than or equal to a single payment window
4112             else {
4113                 principal = share._stake.stakeShares * loanTermRemaining;
4114                 interest  = (principal * (share._interestRate * loanTermRemaining)) / _hdrnLoanInterestResolution;
4115             }
4116         }
4117 
4118         // loan does not exist
4119         else {
4120 
4121             // remaining term is greater than a single payment window
4122             if (share._stake.stakedDays > _hdrnLoanPaymentWindow) {
4123                 principal = share._stake.stakeShares * _hdrnLoanPaymentWindow;
4124                 interest  = (principal * (day._dayInterestRate * _hdrnLoanPaymentWindow)) / _hdrnLoanInterestResolution;
4125             }
4126             // remaing term is less than or equal to a single payment window
4127             else {
4128                 principal = share._stake.stakeShares * share._stake.stakedDays;
4129                 interest  = (principal * (day._dayInterestRate * share._stake.stakedDays)) / _hdrnLoanInterestResolution;
4130             }
4131         }
4132 
4133         return(principal, interest);
4134     }
4135 
4136     /**
4137      * @dev Calculates the full payoff for an existing HEX stake instance (HSI) loan calculating interest only up to the current Hedron day.
4138      * @param borrower Address which has mapped ownership the HSI contract.
4139      * @param hsiIndex Index of the HSI contract address in the sender's HSI list.
4140      *                 (see hsiLists -> HEXStakeInstanceManager.sol)
4141      * @param hsiAddress Address of the HSI contract which coinsides with the index.
4142      * @return Payoff amount with principal and interest as separate values.
4143      */
4144     function calcLoanPayoff (
4145         address borrower,
4146         uint256 hsiIndex,
4147         address hsiAddress
4148     ) 
4149         external
4150         view
4151         returns (uint256, uint256)
4152     {
4153         require(block.timestamp >= _hdrnLaunch,
4154             "HDRN: Contract not yet active");
4155 
4156         DailyDataCache memory  day;
4157         DailyDataStore storage dayStore = dailyDataList[_currentDay()];
4158 
4159         _dailyDataLoad(dayStore, day);
4160 
4161         address _hsiAddress = _hsim.hsiLists(borrower, hsiIndex);
4162 
4163         require(hsiAddress == _hsiAddress,
4164             "HDRN: HSI index address mismatch");
4165 
4166         ShareCache memory share = _hsiLoad(HEXStakeInstance(hsiAddress));
4167 
4168         require (share._isLoaned == true,
4169             "HDRN: Cannot payoff non-existant loan");
4170 
4171         uint256 loanTermPaid      = share._paymentsMade * _hdrnLoanPaymentWindow;
4172         uint256 loanTermRemaining = share._loanedDays - loanTermPaid;
4173         uint256 outstandingDays   = 0;
4174         uint256 principal         = 0;
4175         uint256 interest          = 0;
4176         
4177         // user has made payments ahead of _currentDay(), no interest
4178         if (_currentDay() - share._loanStart < loanTermPaid) {
4179             principal = share._stake.stakeShares * loanTermRemaining;
4180         }
4181 
4182         // only calculate interest to the current Hedron day
4183         else {
4184             outstandingDays = _currentDay() - share._loanStart - loanTermPaid;
4185 
4186             if (outstandingDays > loanTermRemaining) {
4187                 outstandingDays = loanTermRemaining;
4188             }
4189 
4190             principal = share._stake.stakeShares * loanTermRemaining;
4191             interest  = ((share._stake.stakeShares * outstandingDays) * (share._interestRate * outstandingDays)) / _hdrnLoanInterestResolution;
4192         }
4193 
4194         return(principal, interest);
4195     }
4196 
4197     /**
4198      * @dev Loans all unminted Hedron ERC20 (HDRN) tokens against a HEX stake instance (HSI).
4199      *      HDRN Loaned = HEX Stake B-Shares * (Days Staked - Days Already Minted)
4200      * @param hsiIndex Index of the HSI contract address in the sender's HSI list.
4201      *                 (see hsiLists -> HEXStakeInstanceManager.sol)
4202      * @param hsiAddress Address of the HSI contract which coinsides the index.
4203      * @return Amount of HDRN ERC20 tokens borrowed.
4204      */
4205     function loanInstanced (
4206         uint256 hsiIndex,
4207         address hsiAddress
4208     )
4209         external
4210         returns (uint256)
4211     {
4212         require(block.timestamp >= _hdrnLaunch,
4213             "HDRN: Contract not yet active");
4214 
4215         DailyDataCache memory  day;
4216         DailyDataStore storage dayStore = dailyDataList[_currentDay()];
4217 
4218         _dailyDataLoad(dayStore, day);
4219 
4220         address _hsiAddress = _hsim.hsiLists(msg.sender, hsiIndex);
4221 
4222         require(hsiAddress == _hsiAddress,
4223             "HDRN: HSI index address mismatch");
4224 
4225         ShareCache memory share = _hsiLoad(HEXStakeInstance(hsiAddress));
4226 
4227         require (share._isLoaned == false,
4228             "HDRN: HSI loan already exists");
4229 
4230         // only unminted days can be loaned upon
4231         uint256 loanDays = share._stake.stakedDays - share._mintedDays;
4232 
4233         require (loanDays > 0,
4234             "HDRN: No loanable days remaining");
4235 
4236         uint256 payout = share._stake.stakeShares * loanDays;
4237 
4238         // mint loaned tokens to the sender
4239         if (payout > 0) {
4240             share._loanStart    = _currentDay();
4241             share._loanedDays   = loanDays;
4242             share._interestRate = day._dayInterestRate;
4243             share._isLoaned     = true;
4244 
4245             _emitLoanStart(
4246                 share,
4247                 payout
4248             );
4249 
4250             day._dayLoanedTotal += payout;
4251             loanedSupply += payout;
4252 
4253             // update HEX stake instance
4254             _hsim.hsiUpdate(msg.sender, hsiIndex, hsiAddress, share);
4255             _shareUpdate(shareList[share._stake.stakeId], share);
4256 
4257             _dailyDataUpdate(dayStore, day);
4258 
4259             _mint(msg.sender, payout);
4260         }
4261 
4262         return payout;
4263     }
4264 
4265     /**
4266      * @dev Makes a single payment towards a HEX stake instance (HSI) loan.
4267      * @param hsiIndex Index of the HSI contract address in the sender's HSI list.
4268      *                 (see hsiLists -> HEXStakeInstanceManager.sol)
4269      * @param hsiAddress Address of the HSI contract which coinsides with the index.
4270      * @return Amount of HDRN ERC20 burnt to facilitate the payment.
4271      */
4272     function loanPayment (
4273         uint256 hsiIndex,
4274         address hsiAddress
4275     )
4276         external
4277         returns (uint256)
4278     {
4279         require(block.timestamp >= _hdrnLaunch,
4280             "HDRN: Contract not yet active");
4281 
4282         DailyDataCache memory  day;
4283         DailyDataStore storage dayStore = dailyDataList[_currentDay()];
4284 
4285         _dailyDataLoad(dayStore, day);
4286 
4287         address _hsiAddress = _hsim.hsiLists(msg.sender, hsiIndex);
4288 
4289         require(hsiAddress == _hsiAddress,
4290             "HDRN: HSI index address mismatch");
4291 
4292         ShareCache memory share = _hsiLoad(HEXStakeInstance(hsiAddress));
4293 
4294         require (share._isLoaned == true,
4295             "HDRN: Cannot pay non-existant loan");
4296 
4297         uint256 loanTermPaid      = share._paymentsMade * _hdrnLoanPaymentWindow;
4298         uint256 loanTermRemaining = share._loanedDays - loanTermPaid;
4299         uint256 principal         = 0;
4300         uint256 interest          = 0;
4301         bool    lastPayment       = false;
4302 
4303         // remaining term is greater than a single payment window
4304         if (loanTermRemaining > _hdrnLoanPaymentWindow) {
4305             principal = share._stake.stakeShares * _hdrnLoanPaymentWindow;
4306             interest  = (principal * (share._interestRate * _hdrnLoanPaymentWindow)) / _hdrnLoanInterestResolution;
4307         }
4308         // remaing term is less than or equal to a single payment window
4309         else {
4310             principal   = share._stake.stakeShares * loanTermRemaining;
4311             interest    = (principal * (share._interestRate * loanTermRemaining)) / _hdrnLoanInterestResolution;
4312             lastPayment = true;
4313         }
4314 
4315         require (balanceOf(msg.sender) >= (principal + interest),
4316             "HDRN: Insufficient balance to facilitate payment");
4317 
4318         // increment payment counter
4319         share._paymentsMade++;
4320 
4321         _emitLoanPayment(
4322             share,
4323             (principal + interest)
4324         );
4325 
4326         if (lastPayment == true) {
4327             share._loanStart    = 0;
4328             share._loanedDays   = 0;
4329             share._interestRate = 0;
4330             share._paymentsMade = 0;
4331             share._isLoaned     = false;
4332         }
4333 
4334         // update HEX stake instance
4335         _hsim.hsiUpdate(msg.sender, hsiIndex, hsiAddress, share);
4336         _shareUpdate(shareList[share._stake.stakeId], share);
4337 
4338         // update daily data
4339         day._dayBurntTotal += (principal + interest);
4340         _dailyDataUpdate(dayStore, day);
4341 
4342         // remove pricipal from global loaned supply
4343         loanedSupply -= principal;
4344 
4345         // burn payment from the sender
4346         _burn(msg.sender, (principal + interest));
4347 
4348         return(principal + interest);
4349     }
4350 
4351     /**
4352      * @dev Pays off a HEX stake instance (HSI) loan calculating interest only up to the current Hedron day.
4353      * @param hsiIndex Index of the HSI contract address in the sender's HSI list.
4354      *                 (see hsiLists -> HEXStakeInstanceManager.sol)
4355      * @param hsiAddress Address of the HSI contract which coinsides with the index.
4356      * @return Amount of HDRN ERC20 burnt to facilitate the payoff.
4357      */
4358     function loanPayoff (
4359         uint256 hsiIndex,
4360         address hsiAddress
4361     )
4362         external
4363         returns (uint256)
4364     {
4365         require(block.timestamp >= _hdrnLaunch,
4366             "HDRN: Contract not yet active");
4367 
4368         DailyDataCache memory  day;
4369         DailyDataStore storage dayStore = dailyDataList[_currentDay()];
4370 
4371         _dailyDataLoad(dayStore, day);
4372 
4373         address _hsiAddress = _hsim.hsiLists(msg.sender, hsiIndex);
4374 
4375         require(hsiAddress == _hsiAddress,
4376             "HDRN: HSI index address mismatch");
4377 
4378         ShareCache memory share = _hsiLoad(HEXStakeInstance(hsiAddress));
4379 
4380         require (share._isLoaned == true,
4381             "HDRN: Cannot payoff non-existant loan");
4382 
4383         uint256 loanTermPaid      = share._paymentsMade * _hdrnLoanPaymentWindow;
4384         uint256 loanTermRemaining = share._loanedDays - loanTermPaid;
4385         uint256 outstandingDays   = 0;
4386         uint256 principal         = 0;
4387         uint256 interest          = 0;
4388 
4389         // user has made payments ahead of _currentDay(), no interest
4390         if (_currentDay() - share._loanStart < loanTermPaid) {
4391             principal = share._stake.stakeShares * loanTermRemaining;
4392         }
4393 
4394         // only calculate interest to the current Hedron day
4395         else {
4396             outstandingDays = _currentDay() - share._loanStart - loanTermPaid;
4397 
4398             if (outstandingDays > loanTermRemaining) {
4399                 outstandingDays = loanTermRemaining;
4400             }
4401 
4402             principal = share._stake.stakeShares * loanTermRemaining;
4403             interest  = ((share._stake.stakeShares * outstandingDays) * (share._interestRate * outstandingDays)) / _hdrnLoanInterestResolution;
4404         }
4405 
4406         require (balanceOf(msg.sender) >= (principal + interest),
4407             "HDRN: Insufficient balance to facilitate payoff");
4408 
4409         _emitLoanEnd(
4410             share,
4411             (principal + interest)
4412         );
4413 
4414         share._loanStart    = 0;
4415         share._loanedDays   = 0;
4416         share._interestRate = 0;
4417         share._paymentsMade = 0;
4418         share._isLoaned     = false;
4419 
4420         // update HEX stake instance
4421         _hsim.hsiUpdate(msg.sender, hsiIndex, hsiAddress, share);
4422         _shareUpdate(shareList[share._stake.stakeId], share);
4423 
4424         // update daily data 
4425         day._dayBurntTotal += (principal + interest);
4426         _dailyDataUpdate(dayStore, day);
4427 
4428         // remove pricipal from global loaned supply
4429         loanedSupply -= principal;
4430 
4431         // burn payment from the sender
4432         _burn(msg.sender, (principal + interest));
4433 
4434         return(principal + interest);
4435     }
4436 
4437     /**
4438      * @dev Allows any address to liquidate a defaulted HEX stake instace (HSI) loan and start the liquidation process.
4439      * @param owner Address of the current HSI contract owner.
4440      * @param hsiIndex Index of the HSI contract address in the owner's HSI list.
4441      *                 (see hsiLists -> HEXStakeInstanceManager.sol)
4442      * @param hsiAddress Address of the HSI contract which coinsides with the index.
4443      * @return Amount of HDRN ERC20 tokens burnt as the initial liquidation bid.
4444      */
4445     function loanLiquidate (
4446         address owner,
4447         uint256 hsiIndex,
4448         address hsiAddress
4449     )
4450         external
4451         returns (uint256)
4452     {
4453         require(block.timestamp >= _hdrnLaunch,
4454             "HDRN: Contract not yet active");
4455 
4456         address _hsiAddress = _hsim.hsiLists(owner, hsiIndex);
4457 
4458         require(hsiAddress == _hsiAddress,
4459             "HDRN: HSI index address mismatch");
4460 
4461         ShareCache memory share = _hsiLoad(HEXStakeInstance(hsiAddress));
4462 
4463         require (share._isLoaned == true,
4464             "HDRN: Cannot liquidate a non-existant loan");
4465 
4466         uint256 loanTermPaid      = share._paymentsMade * _hdrnLoanPaymentWindow;
4467         uint256 loanTermRemaining = share._loanedDays - loanTermPaid;
4468         uint256 outstandingDays   = _currentDay() - share._loanStart - loanTermPaid;
4469         uint256 principal         = share._stake.stakeShares * loanTermRemaining;
4470 
4471         require (outstandingDays >= _hdrnLoanDefaultThreshold,
4472             "HDRN: Cannot liquidate a loan not in default");
4473 
4474         if (outstandingDays > loanTermRemaining) {
4475             outstandingDays = loanTermRemaining;
4476         }
4477 
4478         // only calculate interest to the current Hedron day
4479         uint256 interest = ((share._stake.stakeShares * outstandingDays) * (share._interestRate * outstandingDays)) / _hdrnLoanInterestResolution;
4480 
4481         require (balanceOf(msg.sender) >= (principal + interest),
4482             "HDRN: Insufficient balance to facilitate liquidation");
4483 
4484         // zero out loan data
4485         share._loanStart    = 0;
4486         share._loanedDays   = 0;
4487         share._interestRate = 0;
4488         share._paymentsMade = 0;
4489         share._isLoaned     = false;
4490 
4491         // update HEX stake instance
4492         _hsim.hsiUpdate(owner, hsiIndex, hsiAddress, share);
4493         _shareUpdate(shareList[share._stake.stakeId], share);
4494 
4495         // transfer ownership of the HEX stake instance to a temporary holding address
4496         _hsim.hsiTransfer(owner, hsiIndex, hsiAddress, address(0));
4497 
4498         // create a new liquidation element
4499         _liquidationAdd(hsiAddress, msg.sender, (principal + interest));
4500 
4501         _emitLoanLiquidateStart(
4502             share,
4503             uint40(_liquidationIds.current()),
4504             owner,
4505             (principal + interest)
4506         );
4507 
4508         // remove pricipal from global loaned supply
4509         loanedSupply -= principal;
4510 
4511         // burn payment from the sender
4512         _burn(msg.sender, (principal + interest));
4513 
4514         return(principal + interest);
4515     }
4516 
4517     /**
4518      * @dev Allows any address to enter a bid into an active liquidation.
4519      * @param liquidationId ID number of the liquidation to place the bid in.
4520      * @param liquidationBid Amount of HDRN to bid.
4521      * @return Block timestamp of when the liquidation is currently scheduled to end.
4522      */
4523     function loanLiquidateBid (
4524         uint256 liquidationId,
4525         uint256 liquidationBid
4526     )
4527         external
4528         returns (uint256)
4529     {
4530         require(block.timestamp >= _hdrnLaunch,
4531             "HDRN: Contract not yet active");
4532 
4533         LiquidationCache memory  liquidation;
4534         LiquidationStore storage liquidationStore = liquidationList[liquidationId];
4535         
4536         _liquidationLoad(liquidationStore, liquidation);
4537 
4538         require(liquidation._isActive == true,
4539             "HDRN: Cannot bid on invalid liquidation");
4540 
4541         require (balanceOf(msg.sender) >= liquidationBid,
4542             "HDRN: Insufficient balance to facilitate liquidation");
4543 
4544         require (liquidationBid > liquidation._bidAmount,
4545             "HDRN: Liquidation bid must be greater than current bid");
4546 
4547         require((block.timestamp - (liquidation._liquidationStart + liquidation._endOffset)) <= 86400,
4548             "HDRN: Cannot bid on expired liquidation");
4549 
4550         // if the bid is being placed in the last five minutes
4551         uint256 timestampModified = ((block.timestamp + 300) - (liquidation._liquidationStart + liquidation._endOffset));
4552         if (timestampModified > 86400) {
4553             liquidation._endOffset += (timestampModified - 86400);
4554         }
4555 
4556         // give the previous bidder back their HDRN
4557         _mint(liquidation._liquidator, liquidation._bidAmount);
4558 
4559         // new bidder takes the liquidation position
4560         liquidation._liquidator = msg.sender;
4561         liquidation._bidAmount  = liquidationBid;
4562 
4563         _liquidationUpdate(liquidationStore, liquidation);
4564 
4565         ShareCache memory share = _hsiLoad(HEXStakeInstance(liquidation._hsiAddress));
4566 
4567         _emitLoanLiquidateBid(
4568             share._stake.stakeId,
4569             uint40(liquidationId),
4570             liquidationBid
4571         );
4572 
4573         // burn the new bidders bid amount
4574         _burn(msg.sender, liquidationBid);
4575 
4576         return(
4577             liquidation._liquidationStart +
4578             liquidation._endOffset +
4579             86400
4580         );
4581     }
4582 
4583     /**
4584      * @dev Allows any address to exit a completed liquidation, granting control of the
4585             HSI to the highest bidder.
4586      * @param hsiIndex Index of the HSI contract address in the zero address's HSI list.
4587      *                 (see hsiLists -> HEXStakeInstanceManager.sol)
4588      * @param liquidationId ID number of the liquidation to exit.
4589      * @return Address of the HEX Stake Instance (HSI) contract granted to the liquidator.
4590      */
4591     function loanLiquidateExit (
4592         uint256 hsiIndex,
4593         uint256 liquidationId
4594     )
4595         external
4596         returns (address)
4597     {
4598         require(block.timestamp >= _hdrnLaunch,
4599             "HDRN: Contract not yet active");
4600 
4601         DailyDataCache memory  day;
4602         DailyDataStore storage dayStore = dailyDataList[_currentDay()];
4603 
4604         _dailyDataLoad(dayStore, day);
4605 
4606         LiquidationStore storage liquidationStore = liquidationList[liquidationId];
4607         LiquidationCache memory  liquidation;
4608 
4609         _liquidationLoad(liquidationStore, liquidation);
4610         
4611         require(liquidation._isActive == true,
4612             "HDRN: Cannot exit on invalid liquidation");
4613 
4614         require((block.timestamp - (liquidation._liquidationStart + liquidation._endOffset)) >= 86400,
4615             "HDRN: Cannot exit on active liquidation");
4616 
4617         // transfer the held HSI to the liquidator
4618         _hsim.hsiTransfer(address(0), hsiIndex, liquidation._hsiAddress, liquidation._liquidator);
4619 
4620         // update the daily burnt total
4621         day._dayBurntTotal += liquidation._bidAmount;
4622 
4623         // deactivate liquidation, but keep data around for historical reasons.
4624         liquidation._isActive == false;
4625 
4626         ShareCache memory share = _hsiLoad(HEXStakeInstance(liquidation._hsiAddress));
4627 
4628         _emitLoanLiquidateExit(
4629             share._stake.stakeId,
4630             uint40(liquidationId),
4631             liquidation._liquidator,
4632             liquidation._bidAmount
4633         );
4634 
4635         _dailyDataUpdate(dayStore, day);
4636         _liquidationUpdate(liquidationStore, liquidation);
4637 
4638         return liquidation._hsiAddress;
4639     }
4640 
4641     /**
4642      * @dev Burns HDRN tokens from the caller's address.
4643      * @param amount Amount of HDRN to burn.
4644      */
4645     function proofOfBenevolence (
4646         uint256 amount
4647     )
4648         external
4649     {
4650         require(block.timestamp >= _hdrnLaunch,
4651             "HDRN: Contract not yet active");
4652 
4653         DailyDataCache memory  day;
4654         DailyDataStore storage dayStore = dailyDataList[_currentDay()];
4655 
4656         _dailyDataLoad(dayStore, day);
4657 
4658         require (balanceOf(msg.sender) >= amount,
4659             "HDRN: Insufficient balance to facilitate PoB");
4660 
4661         uint256 currentAllowance = allowance(msg.sender, address(this));
4662 
4663         require(currentAllowance >= amount,
4664             "HDRN: Burn amount exceeds allowance");
4665         
4666         day._dayBurntTotal += amount;
4667         _dailyDataUpdate(dayStore, day);
4668 
4669         unchecked {
4670             _approve(msg.sender, address(this), currentAllowance - amount);
4671         }
4672 
4673         _burn(msg.sender, amount);
4674     }
4675 }