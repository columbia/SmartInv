1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.0;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Context
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC165
30 
31 /**
32  * @dev Interface of the ERC165 standard, as defined in the
33  * https://eips.ethereum.org/EIPS/eip-165[EIP].
34  *
35  * Implementers can declare support of contract interfaces, which can then be
36  * queried by others ({ERC165Checker}).
37  *
38  * For an implementation, see {ERC165}.
39  */
40 interface IERC165 {
41     /**
42      * @dev Returns true if this contract implements the interface defined by
43      * `interfaceId`. See the corresponding
44      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
45      * to learn more about how these ids are created.
46      *
47      * This function call must use less than 30 000 gas.
48      */
49     function supportsInterface(bytes4 interfaceId) external view returns (bool);
50 }
51 
52 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20
53 
54 /**
55  * @dev Interface of the ERC20 standard as defined in the EIP.
56  */
57 interface IERC20 {
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `recipient`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Returns the remaining number of tokens that `spender` will be
79      * allowed to spend on behalf of `owner` through {transferFrom}. This is
80      * zero by default.
81      *
82      * This value changes when {approve} or {transferFrom} are called.
83      */
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     /**
87      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * IMPORTANT: Beware that changing an allowance with this method brings the risk
92      * that someone may use both the old and the new allowance by unfortunate
93      * transaction ordering. One possible solution to mitigate this race
94      * condition is to first reduce the spender's allowance to 0 and set the
95      * desired value afterwards:
96      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97      *
98      * Emits an {Approval} event.
99      */
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Moves `amount` tokens from `sender` to `recipient` using the
104      * allowance mechanism. `amount` is then deducted from the caller's
105      * allowance.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(
112         address sender,
113         address recipient,
114         uint256 amount
115     ) external returns (bool);
116 
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20Metadata
133 
134 /**
135  * @dev Interface for the optional metadata functions from the ERC20 standard.
136  *
137  * _Available since v4.1._
138  */
139 interface IERC20Metadata is IERC20 {
140     /**
141      * @dev Returns the name of the token.
142      */
143     function name() external view returns (string memory);
144 
145     /**
146      * @dev Returns the symbol of the token.
147      */
148     function symbol() external view returns (string memory);
149 
150     /**
151      * @dev Returns the decimals places of the token.
152      */
153     function decimals() external view returns (uint8);
154 }
155 
156 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC721
157 
158 /**
159  * @dev Required interface of an ERC721 compliant contract.
160  */
161 interface IERC721 is IERC165 {
162     /**
163      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
164      */
165     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
166 
167     /**
168      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
169      */
170     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
171 
172     /**
173      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
174      */
175     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
176 
177     /**
178      * @dev Returns the number of tokens in ``owner``'s account.
179      */
180     function balanceOf(address owner) external view returns (uint256 balance);
181 
182     /**
183      * @dev Returns the owner of the `tokenId` token.
184      *
185      * Requirements:
186      *
187      * - `tokenId` must exist.
188      */
189     function ownerOf(uint256 tokenId) external view returns (address owner);
190 
191     /**
192      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
193      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must exist and be owned by `from`.
200      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
201      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
202      *
203      * Emits a {Transfer} event.
204      */
205     function safeTransferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Transfers `tokenId` token from `from` to `to`.
213      *
214      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
215      *
216      * Requirements:
217      *
218      * - `from` cannot be the zero address.
219      * - `to` cannot be the zero address.
220      * - `tokenId` token must be owned by `from`.
221      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
222      *
223      * Emits a {Transfer} event.
224      */
225     function transferFrom(
226         address from,
227         address to,
228         uint256 tokenId
229     ) external;
230 
231     /**
232      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
233      * The approval is cleared when the token is transferred.
234      *
235      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
236      *
237      * Requirements:
238      *
239      * - The caller must own the token or be an approved operator.
240      * - `tokenId` must exist.
241      *
242      * Emits an {Approval} event.
243      */
244     function approve(address to, uint256 tokenId) external;
245 
246     /**
247      * @dev Returns the account approved for `tokenId` token.
248      *
249      * Requirements:
250      *
251      * - `tokenId` must exist.
252      */
253     function getApproved(uint256 tokenId) external view returns (address operator);
254 
255     /**
256      * @dev Approve or remove `operator` as an operator for the caller.
257      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
258      *
259      * Requirements:
260      *
261      * - The `operator` cannot be the caller.
262      *
263      * Emits an {ApprovalForAll} event.
264      */
265     function setApprovalForAll(address operator, bool _approved) external;
266 
267     /**
268      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
269      *
270      * See {setApprovalForAll}
271      */
272     function isApprovedForAll(address owner, address operator) external view returns (bool);
273 
274     /**
275      * @dev Safely transfers `tokenId` token from `from` to `to`.
276      *
277      * Requirements:
278      *
279      * - `from` cannot be the zero address.
280      * - `to` cannot be the zero address.
281      * - `tokenId` token must exist and be owned by `from`.
282      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
283      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
284      *
285      * Emits a {Transfer} event.
286      */
287     function safeTransferFrom(
288         address from,
289         address to,
290         uint256 tokenId,
291         bytes calldata data
292     ) external;
293 }
294 
295 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Ownable
296 
297 /**
298  * @dev Contract module which provides a basic access control mechanism, where
299  * there is an account (an owner) that can be granted exclusive access to
300  * specific functions.
301  *
302  * By default, the owner account will be the one that deploys the contract. This
303  * can later be changed with {transferOwnership}.
304  *
305  * This module is used through inheritance. It will make available the modifier
306  * `onlyOwner`, which can be applied to your functions to restrict their use to
307  * the owner.
308  */
309 abstract contract Ownable is Context {
310     address private _owner;
311 
312     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
313 
314     /**
315      * @dev Initializes the contract setting the deployer as the initial owner.
316      */
317     constructor() {
318         _setOwner(_msgSender());
319     }
320 
321     /**
322      * @dev Returns the address of the current owner.
323      */
324     function owner() public view virtual returns (address) {
325         return _owner;
326     }
327 
328     /**
329      * @dev Throws if called by any account other than the owner.
330      */
331     modifier onlyOwner() {
332         require(owner() == _msgSender(), "Ownable: caller is not the owner");
333         _;
334     }
335 
336     /**
337      * @dev Leaves the contract without owner. It will not be possible to call
338      * `onlyOwner` functions anymore. Can only be called by the current owner.
339      *
340      * NOTE: Renouncing ownership will leave the contract without an owner,
341      * thereby removing any functionality that is only available to the owner.
342      */
343     function renounceOwnership() public virtual onlyOwner {
344         _setOwner(address(0));
345     }
346 
347     /**
348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
349      * Can only be called by the current owner.
350      */
351     function transferOwnership(address newOwner) public virtual onlyOwner {
352         require(newOwner != address(0), "Ownable: new owner is the zero address");
353         _setOwner(newOwner);
354     }
355 
356     function _setOwner(address newOwner) private {
357         address oldOwner = _owner;
358         _owner = newOwner;
359         emit OwnershipTransferred(oldOwner, newOwner);
360     }
361 }
362 
363 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ERC20
364 
365 /**
366  * @dev Implementation of the {IERC20} interface.
367  *
368  * This implementation is agnostic to the way tokens are created. This means
369  * that a supply mechanism has to be added in a derived contract using {_mint}.
370  * For a generic mechanism see {ERC20PresetMinterPauser}.
371  *
372  * TIP: For a detailed writeup see our guide
373  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
374  * to implement supply mechanisms].
375  *
376  * We have followed general OpenZeppelin guidelines: functions revert instead
377  * of returning `false` on failure. This behavior is nonetheless conventional
378  * and does not conflict with the expectations of ERC20 applications.
379  *
380  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
381  * This allows applications to reconstruct the allowance for all accounts just
382  * by listening to said events. Other implementations of the EIP may not emit
383  * these events, as it isn't required by the specification.
384  *
385  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
386  * functions have been added to mitigate the well-known issues around setting
387  * allowances. See {IERC20-approve}.
388  */
389 contract ERC20 is Context, IERC20, IERC20Metadata {
390     mapping(address => uint256) private _balances;
391 
392     mapping(address => mapping(address => uint256)) private _allowances;
393 
394     uint256 private _totalSupply;
395 
396     string private _name;
397     string private _symbol;
398 
399     /**
400      * @dev Sets the values for {name} and {symbol}.
401      *
402      * The default value of {decimals} is 18. To select a different value for
403      * {decimals} you should overload it.
404      *
405      * All two of these values are immutable: they can only be set once during
406      * construction.
407      */
408     constructor(string memory name_, string memory symbol_) {
409         _name = name_;
410         _symbol = symbol_;
411     }
412 
413     /**
414      * @dev Returns the name of the token.
415      */
416     function name() public view virtual override returns (string memory) {
417         return _name;
418     }
419 
420     /**
421      * @dev Returns the symbol of the token, usually a shorter version of the
422      * name.
423      */
424     function symbol() public view virtual override returns (string memory) {
425         return _symbol;
426     }
427 
428     /**
429      * @dev Returns the number of decimals used to get its user representation.
430      * For example, if `decimals` equals `2`, a balance of `505` tokens should
431      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
432      *
433      * Tokens usually opt for a value of 18, imitating the relationship between
434      * Ether and Wei. This is the value {ERC20} uses, unless this function is
435      * overridden;
436      *
437      * NOTE: This information is only used for _display_ purposes: it in
438      * no way affects any of the arithmetic of the contract, including
439      * {IERC20-balanceOf} and {IERC20-transfer}.
440      */
441     function decimals() public view virtual override returns (uint8) {
442         return 18;
443     }
444 
445     /**
446      * @dev See {IERC20-totalSupply}.
447      */
448     function totalSupply() public view virtual override returns (uint256) {
449         return _totalSupply;
450     }
451 
452     /**
453      * @dev See {IERC20-balanceOf}.
454      */
455     function balanceOf(address account) public view virtual override returns (uint256) {
456         return _balances[account];
457     }
458 
459     /**
460      * @dev See {IERC20-transfer}.
461      *
462      * Requirements:
463      *
464      * - `recipient` cannot be the zero address.
465      * - the caller must have a balance of at least `amount`.
466      */
467     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
468         _transfer(_msgSender(), recipient, amount);
469         return true;
470     }
471 
472     /**
473      * @dev See {IERC20-allowance}.
474      */
475     function allowance(address owner, address spender) public view virtual override returns (uint256) {
476         return _allowances[owner][spender];
477     }
478 
479     /**
480      * @dev See {IERC20-approve}.
481      *
482      * Requirements:
483      *
484      * - `spender` cannot be the zero address.
485      */
486     function approve(address spender, uint256 amount) public virtual override returns (bool) {
487         _approve(_msgSender(), spender, amount);
488         return true;
489     }
490 
491     /**
492      * @dev See {IERC20-transferFrom}.
493      *
494      * Emits an {Approval} event indicating the updated allowance. This is not
495      * required by the EIP. See the note at the beginning of {ERC20}.
496      *
497      * Requirements:
498      *
499      * - `sender` and `recipient` cannot be the zero address.
500      * - `sender` must have a balance of at least `amount`.
501      * - the caller must have allowance for ``sender``'s tokens of at least
502      * `amount`.
503      */
504     function transferFrom(
505         address sender,
506         address recipient,
507         uint256 amount
508     ) public virtual override returns (bool) {
509         _transfer(sender, recipient, amount);
510 
511         uint256 currentAllowance = _allowances[sender][_msgSender()];
512         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
513         unchecked {
514             _approve(sender, _msgSender(), currentAllowance - amount);
515         }
516 
517         return true;
518     }
519 
520     /**
521      * @dev Atomically increases the allowance granted to `spender` by the caller.
522      *
523      * This is an alternative to {approve} that can be used as a mitigation for
524      * problems described in {IERC20-approve}.
525      *
526      * Emits an {Approval} event indicating the updated allowance.
527      *
528      * Requirements:
529      *
530      * - `spender` cannot be the zero address.
531      */
532     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
533         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
534         return true;
535     }
536 
537     /**
538      * @dev Atomically decreases the allowance granted to `spender` by the caller.
539      *
540      * This is an alternative to {approve} that can be used as a mitigation for
541      * problems described in {IERC20-approve}.
542      *
543      * Emits an {Approval} event indicating the updated allowance.
544      *
545      * Requirements:
546      *
547      * - `spender` cannot be the zero address.
548      * - `spender` must have allowance for the caller of at least
549      * `subtractedValue`.
550      */
551     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
552         uint256 currentAllowance = _allowances[_msgSender()][spender];
553         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
554         unchecked {
555             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
556         }
557 
558         return true;
559     }
560 
561     /**
562      * @dev Moves `amount` of tokens from `sender` to `recipient`.
563      *
564      * This internal function is equivalent to {transfer}, and can be used to
565      * e.g. implement automatic token fees, slashing mechanisms, etc.
566      *
567      * Emits a {Transfer} event.
568      *
569      * Requirements:
570      *
571      * - `sender` cannot be the zero address.
572      * - `recipient` cannot be the zero address.
573      * - `sender` must have a balance of at least `amount`.
574      */
575     function _transfer(
576         address sender,
577         address recipient,
578         uint256 amount
579     ) internal virtual {
580         require(sender != address(0), "ERC20: transfer from the zero address");
581         require(recipient != address(0), "ERC20: transfer to the zero address");
582 
583         _beforeTokenTransfer(sender, recipient, amount);
584 
585         uint256 senderBalance = _balances[sender];
586         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
587         unchecked {
588             _balances[sender] = senderBalance - amount;
589         }
590         _balances[recipient] += amount;
591 
592         emit Transfer(sender, recipient, amount);
593 
594         _afterTokenTransfer(sender, recipient, amount);
595     }
596 
597     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
598      * the total supply.
599      *
600      * Emits a {Transfer} event with `from` set to the zero address.
601      *
602      * Requirements:
603      *
604      * - `account` cannot be the zero address.
605      */
606     function _mint(address account, uint256 amount) internal virtual {
607         require(account != address(0), "ERC20: mint to the zero address");
608 
609         _beforeTokenTransfer(address(0), account, amount);
610 
611         _totalSupply += amount;
612         _balances[account] += amount;
613         emit Transfer(address(0), account, amount);
614 
615         _afterTokenTransfer(address(0), account, amount);
616     }
617 
618     /**
619      * @dev Destroys `amount` tokens from `account`, reducing the
620      * total supply.
621      *
622      * Emits a {Transfer} event with `to` set to the zero address.
623      *
624      * Requirements:
625      *
626      * - `account` cannot be the zero address.
627      * - `account` must have at least `amount` tokens.
628      */
629     function _burn(address account, uint256 amount) internal virtual {
630         require(account != address(0), "ERC20: burn from the zero address");
631 
632         _beforeTokenTransfer(account, address(0), amount);
633 
634         uint256 accountBalance = _balances[account];
635         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
636         unchecked {
637             _balances[account] = accountBalance - amount;
638         }
639         _totalSupply -= amount;
640 
641         emit Transfer(account, address(0), amount);
642 
643         _afterTokenTransfer(account, address(0), amount);
644     }
645 
646     /**
647      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
648      *
649      * This internal function is equivalent to `approve`, and can be used to
650      * e.g. set automatic allowances for certain subsystems, etc.
651      *
652      * Emits an {Approval} event.
653      *
654      * Requirements:
655      *
656      * - `owner` cannot be the zero address.
657      * - `spender` cannot be the zero address.
658      */
659     function _approve(
660         address owner,
661         address spender,
662         uint256 amount
663     ) internal virtual {
664         require(owner != address(0), "ERC20: approve from the zero address");
665         require(spender != address(0), "ERC20: approve to the zero address");
666 
667         _allowances[owner][spender] = amount;
668         emit Approval(owner, spender, amount);
669     }
670 
671     /**
672      * @dev Hook that is called before any transfer of tokens. This includes
673      * minting and burning.
674      *
675      * Calling conditions:
676      *
677      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
678      * will be transferred to `to`.
679      * - when `from` is zero, `amount` tokens will be minted for `to`.
680      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
681      * - `from` and `to` are never both zero.
682      *
683      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
684      */
685     function _beforeTokenTransfer(
686         address from,
687         address to,
688         uint256 amount
689     ) internal virtual {}
690 
691     /**
692      * @dev Hook that is called after any transfer of tokens. This includes
693      * minting and burning.
694      *
695      * Calling conditions:
696      *
697      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
698      * has been transferred to `to`.
699      * - when `from` is zero, `amount` tokens have been minted for `to`.
700      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
701      * - `from` and `to` are never both zero.
702      *
703      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
704      */
705     function _afterTokenTransfer(
706         address from,
707         address to,
708         uint256 amount
709     ) internal virtual {}
710 }
711 
712 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC721Enumerable
713 
714 /**
715  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
716  * @dev See https://eips.ethereum.org/EIPS/eip-721
717  */
718 interface IERC721Enumerable is IERC721 {
719     /**
720      * @dev Returns the total amount of tokens stored by the contract.
721      */
722     function totalSupply() external view returns (uint256);
723 
724     /**
725      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
726      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
727      */
728     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
729 
730     /**
731      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
732      * Use along with {totalSupply} to enumerate all tokens.
733      */
734     function tokenByIndex(uint256 index) external view returns (uint256);
735 }
736 
737 // Part: ISheetFighterToken
738 
739 interface ISheetFighterToken is IERC721Enumerable {
740 
741     /// @notice Update the address of the CellToken contract
742     /// @param _contractAddress Address of the CellToken contract
743     function setCellTokenAddress(address _contractAddress) external;
744 
745     /// @notice Update the address which signs the mint transactions
746     /// @dev    Used for ensuring GPT-3 values have not been altered
747     /// @param  _mintSigner New address for the mintSigner
748     function setMintSigner(address _mintSigner) external;
749 
750     /// @notice Update the address of the bridge
751     /// @dev Used for authorization
752     /// @param  _bridge New address for the bridge
753     function setBridge(address _bridge) external;
754 
755     /// @dev Withdraw funds as owner
756     function withdraw() external;
757 
758     /// @notice Set the sale state: options are 0 (closed), 1 (presale), 2 (public sale) -- only owner can call
759     /// @dev    Implicitly converts int argument to TokenSaleState type -- only owner can call
760     /// @param  saleStateId The id for the sale state: 0 (closed), 1 (presale), 2 (public sale)
761     function setSaleState(uint256 saleStateId) external;
762 
763     /// @notice Mint up to 20 Sheet Fighters
764     /// @param  numTokens Number of Sheet Fighter tokens to mint (1 to 20)
765     function mint(uint256 numTokens) external payable;
766 
767     /// @notice "Print" a Sheet. Adds GPT-3 flavor text and attributes
768     /// @dev    This function requires signature verification
769     /// @param  _tokenIds Array of tokenIds to print
770     /// @param  _flavorTexts Array of strings with flavor texts concatonated with a pipe character
771     /// @param  _signature Signature verifying _flavorTexts are unmodified
772     function print(
773         uint256[] memory _tokenIds,
774         string[] memory _flavorTexts,
775         bytes memory _signature
776     ) external;
777 
778     /// @notice Bridge the Sheets
779     /// @dev Transfers Sheets to bridge
780     /// @param tokenOwner Address of the tokenOwner who is bridging their tokens
781     /// @param tokenIds Array of tokenIds that tokenOwner is bridging
782     function bridgeSheets(address tokenOwner, uint256[] calldata tokenIds) external;
783 
784     /// @notice Update the sheet to sync with actions that occured on otherside of bridge
785     /// @param tokenId Id of the SheetFighter
786     /// @param HP New HP value
787     /// @param luck New luck value
788     /// @param heal New heal value
789     /// @param defense New defense value
790     /// @param attack New attack value
791     function syncBridgedSheet(
792         uint256 tokenId,
793         uint8 HP,
794         uint8 luck,
795         uint8 heal,
796         uint8 defense,
797         uint8 attack
798     ) external;
799 
800     /// @notice Return true if token is printed, false otherwise
801     /// @param _tokenId Id of the SheetFighter NFT
802     /// @return bool indicating whether or not sheet is printed
803     function isPrinted(uint256 _tokenId) external view returns(bool);
804 
805     /// @notice Returns the token metadata and SVG artwork
806     /// @dev    This generates a data URI, which contains the metadata json, encoded in base64
807     /// @param _tokenId The tokenId of the token whos metadata and SVG we want
808     function tokenURI(uint256 _tokenId) external view returns (string memory);
809 }
810 
811 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/ERC20Burnable
812 
813 /**
814  * @dev Extension of {ERC20} that allows token holders to destroy both their own
815  * tokens and those that they have an allowance for, in a way that can be
816  * recognized off-chain (via event analysis).
817  */
818 abstract contract ERC20Burnable is Context, ERC20 {
819     /**
820      * @dev Destroys `amount` tokens from the caller.
821      *
822      * See {ERC20-_burn}.
823      */
824     function burn(uint256 amount) public virtual {
825         _burn(_msgSender(), amount);
826     }
827 
828     /**
829      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
830      * allowance.
831      *
832      * See {ERC20-_burn} and {ERC20-allowance}.
833      *
834      * Requirements:
835      *
836      * - the caller must have allowance for ``accounts``'s tokens of at least
837      * `amount`.
838      */
839     function burnFrom(address account, uint256 amount) public virtual {
840         uint256 currentAllowance = allowance(account, _msgSender());
841         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
842         unchecked {
843             _approve(account, _msgSender(), currentAllowance - amount);
844         }
845         _burn(account, amount);
846     }
847 }
848 
849 // File: CellToken.sol
850 
851 /// @title  Contract creating fungible in-game utility tokens for the Sheet Fighter game
852 /// @author Overlord Paper Co
853 /// @notice This defines in-game utility tokens that are used for the Sheet Fighter game
854 /// @notice This contract is HIGHLY adapted from the Anonymice $CHEETH contract
855 /// @notice Thank you MouseDev for writing the original $CHEETH contract!
856 contract CellToken is ERC20Burnable, Ownable {
857 
858     uint256 public constant MAX_WALLET_STAKED = 10;
859     uint256 public constant EMISSIONS_RATE = 115_740_740_740_741; // 10 $CELL per day = (10*1e18)/(60*60*24)
860     uint256 public constant MAX_CELL = 1e26;
861 
862     /// @notice Address of SheetFighterToken contract
863     address public sheetFighterTokenAddress;
864 
865     /// @notice Map SheetFighter id to timestamp staked
866     mapping(uint256 => uint256) public tokenIdToTimeStamp;
867 
868     /// @notice Map SheetFighter id to staker's address
869     mapping(uint256 => address) public tokenIdToStaker;
870 
871     /// @notice Map staker's address to array the ids of all the SheetFighters they're staking
872     mapping(address => uint256[]) public stakerToTokenIds;
873 
874     /// @notice Address of the Polygon bridge
875     address public bridge;
876 
877     /// @notice Construct CellToken contract for the in-game utility token for the Sheet Fighter game
878     /// @dev    Set sheetFighterTokenAddress, ERC20 name and symbol, and implicitly execute Ownable contructor
879     constructor(address _sheetFighterTokenAddress) ERC20('Cell', 'CELL') Ownable() {
880         sheetFighterTokenAddress = _sheetFighterTokenAddress;
881     }
882 
883     /// @notice Update the address of the SheetFighterToken contract
884     /// @param _contractAddress Address of the SheetFighterToken contract
885     function setSheetFighterTokenAddress(address _contractAddress) external onlyOwner {
886         sheetFighterTokenAddress = _contractAddress;
887     }
888 
889     /// @notice Update the address of the bridge
890     /// @dev Used for authorization
891     /// @param  _bridge New address for the bridge
892     function setBridge(address _bridge) external onlyOwner {
893         bridge = _bridge;
894     }
895 
896     /// @notice Stake multiple Sheets by providing their Ids
897     /// @param tokenIds Array of SheetFighterToken ids to stake
898     function stakeByIds(uint256[] calldata tokenIds) external {
899         require(
900             stakerToTokenIds[msg.sender].length + tokenIds.length <= MAX_WALLET_STAKED,
901             "Must have less than 10 Sheets staked!"
902         );
903 
904         for (uint256 i = 0; i < tokenIds.length; i++) {
905             require(
906                 ISheetFighterToken(sheetFighterTokenAddress).ownerOf(tokenIds[i]) == msg.sender, 
907                 "You don't own this Sheet!"
908             );
909             require(tokenIdToStaker[tokenIds[i]] == address(0), "Token is already being staked!");
910 
911             // Transfer SheetFighterToken to this (CellToken) contract
912             ISheetFighterToken(sheetFighterTokenAddress).transferFrom(
913                 msg.sender,
914                 address(this),
915                 tokenIds[i]
916             );
917 
918             // Update staking variables in storage
919             stakerToTokenIds[msg.sender].push(tokenIds[i]);
920             tokenIdToTimeStamp[tokenIds[i]] = block.timestamp;
921             tokenIdToStaker[tokenIds[i]] = msg.sender;
922         }
923     }
924 
925     /// @notice Unstake all of your SheetFighterTokens and get your rewards
926     /// @notice This function is more gas efficient than calling unstakeByIds(...) for all ids
927     /// @dev Tokens are iterated over in REVERSE order, due to the implementation of _remove(...)
928     function unstakeAll() external {
929         require(
930             stakerToTokenIds[msg.sender].length > 0,
931             "You have no tokens staked!"
932         );
933         uint256 totalRewards = 0;
934 
935         // Iterate over staked tokens from the BACK of the array, because
936         // the _remove() function, which is called by _removeTokenIdFromStaker(),
937         // is far more gas efficient when called on elements further back
938         for (uint256 i = stakerToTokenIds[msg.sender].length; i > 0; i--) {
939             
940             uint256 tokenId = stakerToTokenIds[msg.sender][i - 1];
941 
942             // Transfer SheetFighterToken back to staker
943             ISheetFighterToken(sheetFighterTokenAddress).transferFrom(
944                 address(this),
945                 msg.sender,
946                 tokenId
947             );
948 
949             // Add rewards for the current token
950             totalRewards =
951                 totalRewards + (
952                     (block.timestamp - tokenIdToTimeStamp[tokenId]) *
953                     EMISSIONS_RATE
954                 );
955 
956             // Remove the token from the staker in storage variables
957             _removeTokenIdFromStaker(msg.sender, tokenId);
958             delete tokenIdToStaker[tokenId];
959         }
960 
961         // Mint CellTokens to reward staker
962         _mint(msg.sender, _getMaximumRewards(totalRewards));
963     }
964 
965     /// @notice Unstake SheetFighterTokens, given by ids, and get your rewards
966     /// @notice Use unstakeAll(...) instead if unstaking all tokens for gas efficiency
967     /// @param tokenIds Array of SheetFighterToken ids to unstake
968     function unstakeByIds(uint256[] memory tokenIds) external {
969         uint256 totalRewards = 0;
970 
971         for (uint256 i = 0; i < tokenIds.length; i++) {
972             require(
973                 tokenIdToStaker[tokenIds[i]] == msg.sender,
974                 "You're not staking this Sheet!"
975             );
976 
977             // Transfer SheetFighterToken back to staker
978             ISheetFighterToken(sheetFighterTokenAddress).transferFrom(
979                 address(this),
980                 msg.sender,
981                 tokenIds[i]
982             );
983 
984             // Add rewards for the current token
985             totalRewards =
986                 totalRewards + (
987                     (block.timestamp - tokenIdToTimeStamp[tokenIds[i]]) *
988                     EMISSIONS_RATE
989                 );
990 
991             // Remove the token from the staker in storage variables
992             _removeTokenIdFromStaker(msg.sender, tokenIds[i]);
993             delete tokenIdToStaker[tokenIds[i]];
994         }
995 
996         // Mint CellTokens to reward staker
997         _mint(msg.sender, _getMaximumRewards(totalRewards));
998     }
999 
1000     /// @notice Claim $CELL tokens as reward for staking a SheetFighterTokens, given by an id
1001     /// @notice This function does not unstake your Sheets
1002     /// @param tokenId SheetFighterToken id
1003     function claimByTokenId(uint256 tokenId) external {
1004         require(
1005             tokenIdToStaker[tokenId] == msg.sender,
1006             "You're not staking this Sheet!"
1007         );
1008 
1009         _mint(
1010             msg.sender,
1011             _getMaximumRewards((block.timestamp - tokenIdToTimeStamp[tokenId]) * EMISSIONS_RATE)
1012         );
1013 
1014         tokenIdToTimeStamp[tokenId] = block.timestamp;
1015     }
1016 
1017     /// @notice Claim $CELL tokens as reward for all SheetFighterTokens staked
1018     /// @notice This function does not unstake your Sheets
1019     function claimAll() external {
1020         uint256[] memory tokenIds = stakerToTokenIds[msg.sender];
1021         uint256 totalRewards = 0;
1022 
1023         for (uint256 i = 0; i < tokenIds.length; i++) {
1024             require(
1025                 tokenIdToStaker[tokenIds[i]] == msg.sender,
1026                 "Token is not claimable by you!"
1027             );
1028 
1029             totalRewards =
1030                 totalRewards +
1031                 ((block.timestamp - tokenIdToTimeStamp[tokenIds[i]]) *
1032                     EMISSIONS_RATE);
1033 
1034             tokenIdToTimeStamp[tokenIds[i]] = block.timestamp;
1035         }
1036 
1037         _mint(msg.sender, _getMaximumRewards(totalRewards));
1038     }
1039 
1040     /// @notice Mint tokens when bridging
1041     /// @dev This function is only used for bridging to mint tokens on one end
1042     /// @param to Address to send new tokens to
1043     /// @param value Number of new tokens to mint
1044     function bridgeMint(address to, uint256 value) external {
1045         require(bridge != address(0), "Bridge is not set");
1046         require(msg.sender == bridge, "Only bridge can do this");
1047         _mint(to, _getMaximumRewards(value));
1048     }
1049 
1050     /// @notice Burn tokens when bridging
1051     /// @dev This function is only used for bridging to burn tokens on one end
1052     /// @param from Address to burn tokens from
1053     /// @param value Number of tokens to burn
1054     function bridgeBurn(address from, uint256 value) external {
1055         require(bridge != address(0), "Bridge is not set");
1056         require(msg.sender == bridge, "Only bridge can do this");
1057         _burn(from, value);
1058     }
1059 
1060     /// @notice View all rewards claimable by a staker
1061     /// @param staker Address of the staker
1062     /// @return Number of $CELL claimable by the staker
1063     function getAllRewards(address staker) external view returns (uint256) {
1064         uint256[] memory tokenIds = stakerToTokenIds[staker];
1065         uint256 totalRewards = 0;
1066 
1067         for (uint256 i = 0; i < tokenIds.length; i++) {
1068             totalRewards =
1069                 totalRewards +
1070                 ((block.timestamp - tokenIdToTimeStamp[tokenIds[i]]) *
1071                     EMISSIONS_RATE);
1072         }
1073 
1074         return _getMaximumRewards(totalRewards);
1075     }
1076 
1077     /// @notice View rewards claimable for a specific SheetFighterToken
1078     /// @param tokenId Id of the SheetFightToken
1079     /// @return Number of $CELL claimable by the staker for this Sheet
1080     function getRewardsByTokenId(uint256 tokenId) external view returns (uint256) {
1081         require(tokenIdToStaker[tokenId] != address(0), "Sheet is not staked!");
1082 
1083         uint256 rewards = (block.timestamp - tokenIdToTimeStamp[tokenId]) * EMISSIONS_RATE;
1084 
1085         return _getMaximumRewards(rewards);
1086     }
1087 
1088     /// @notice Get all the token Ids staked by a staker
1089     /// @param staker Address of the staker
1090     /// @return Array of tokens staked
1091     function getTokensStaked(address staker) external view returns (uint256[] memory) {
1092         return stakerToTokenIds[staker];
1093     }
1094 
1095     /// @notice Remove a token, given by an index, from a staker in staking storage variables
1096     /// @dev This function is significantly more gas efficient the greater the index is
1097     /// @param staker Address of the staker
1098     /// @param index Index of the SheetFighterToken in stakeToTokenIds[staker] being removed
1099     function _remove(address staker, uint256 index) internal {
1100         if (index >= stakerToTokenIds[staker].length) return;
1101 
1102         // Reset all 
1103         for (uint256 i = index; i < stakerToTokenIds[staker].length - 1; i++) {
1104             stakerToTokenIds[staker][i] = stakerToTokenIds[staker][i + 1];
1105         }
1106         stakerToTokenIds[staker].pop();
1107     }
1108 
1109     /// @notice Remove a token, given by an id, from a staker in staking storage variables
1110     /// @param staker Address of the staker
1111     /// @param tokenId SheetFighterToken id
1112     function _removeTokenIdFromStaker(address staker, uint256 tokenId) internal {
1113 
1114         // Find index of SheetFighterToken in stakerToTokenIds[staker] array
1115         for (uint256 i = 0; i < stakerToTokenIds[staker].length; i++) {
1116             if (stakerToTokenIds[staker][i] == tokenId) {
1117                 // This is the tokenId to remove
1118                 // Now, remove it
1119                 _remove(staker, i);
1120             }
1121         }
1122     }
1123 
1124     /// @dev Returns the maximum amount of rewards the user can get, when considering the max token cap
1125     /// @param calculatedRewards The rewards the user would receive, if there were no token cap
1126     /// @return How much the owner can claim
1127     function _getMaximumRewards(uint256 calculatedRewards) internal view returns(uint256) {
1128         uint256 totalCellAvailable = MAX_CELL - totalSupply();
1129         return totalCellAvailable > calculatedRewards ? calculatedRewards : totalCellAvailable;
1130     }
1131 }
