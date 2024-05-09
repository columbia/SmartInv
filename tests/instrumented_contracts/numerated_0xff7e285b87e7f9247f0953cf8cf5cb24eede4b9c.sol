1 //            __      ______   ________  ______  __       __  __       __  __      __ 
2 //          _/  |_   /      \ /        |/      |/  \     /  |/  \     /  |/  \    /  |
3 //         / $$   \ /$$$$$$  |$$$$$$$$/ $$$$$$/ $$  \   /$$ |$$  \   /$$ |$$  \  /$$/ 
4 //        /$$$$$$  |$$ \__$$/    $$ |     $$ |  $$$  \ /$$$ |$$$  \ /$$$ | $$  \/$$/  
5 //        $$ \__$$/ $$      \    $$ |     $$ |  $$$$  /$$$$ |$$$$  /$$$$ |  $$  $$/   
6 //        $$      \  $$$$$$  |   $$ |     $$ |  $$ $$ $$/$$ |$$ $$ $$/$$ |   $$$$/    
7 //         $$$$$$  |/  \__$$ |   $$ |    _$$ |_ $$ |$$$/ $$ |$$ |$$$/ $$ |    $$ |    
8 //        /  \__$$ |$$    $$/    $$ |   / $$   |$$ | $/  $$ |$$ | $/  $$ |    $$ |    
9 //        $$    $$/  $$$$$$/     $$/    $$$$$$/ $$/      $$/ $$/      $$/     $$/     
10 //         $$$$$$/                                                                    
11 //           $$/                    
12 
13 
14 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.1
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(
78         address sender,
79         address recipient,
80         uint256 amount
81     ) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.1
100 
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Interface for the optional metadata functions from the ERC20 standard.
106  *
107  * _Available since v4.1._
108  */
109 interface IERC20Metadata is IERC20 {
110     /**
111      * @dev Returns the name of the token.
112      */
113     function name() external view returns (string memory);
114 
115     /**
116      * @dev Returns the symbol of the token.
117      */
118     function symbol() external view returns (string memory);
119 
120     /**
121      * @dev Returns the decimals places of the token.
122      */
123     function decimals() external view returns (uint8);
124 }
125 
126 
127 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
128 
129 
130 pragma solidity ^0.8.0;
131 
132 /**
133  * @dev Provides information about the current execution context, including the
134  * sender of the transaction and its data. While these are generally available
135  * via msg.sender and msg.data, they should not be accessed in such a direct
136  * manner, since when dealing with meta-transactions the account sending and
137  * paying for execution may not be the actual sender (as far as an application
138  * is concerned).
139  *
140  * This contract is only required for intermediate, library-like contracts.
141  */
142 abstract contract Context {
143     function _msgSender() internal view virtual returns (address) {
144         return msg.sender;
145     }
146 
147     function _msgData() internal view virtual returns (bytes calldata) {
148         return msg.data;
149     }
150 }
151 
152 
153 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.1
154 
155 
156 pragma solidity ^0.8.0;
157 
158 
159 
160 /**
161  * @dev Implementation of the {IERC20} interface.
162  *
163  * This implementation is agnostic to the way tokens are created. This means
164  * that a supply mechanism has to be added in a derived contract using {_mint}.
165  * For a generic mechanism see {ERC20PresetMinterPauser}.
166  *
167  * TIP: For a detailed writeup see our guide
168  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
169  * to implement supply mechanisms].
170  *
171  * We have followed general OpenZeppelin Contracts guidelines: functions revert
172  * instead returning `false` on failure. This behavior is nonetheless
173  * conventional and does not conflict with the expectations of ERC20
174  * applications.
175  *
176  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
177  * This allows applications to reconstruct the allowance for all accounts just
178  * by listening to said events. Other implementations of the EIP may not emit
179  * these events, as it isn't required by the specification.
180  *
181  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
182  * functions have been added to mitigate the well-known issues around setting
183  * allowances. See {IERC20-approve}.
184  */
185 contract ERC20 is Context, IERC20, IERC20Metadata {
186     mapping(address => uint256) private _balances;
187 
188     mapping(address => mapping(address => uint256)) private _allowances;
189 
190     uint256 private _totalSupply;
191 
192     string private _name;
193     string private _symbol;
194 
195     /**
196      * @dev Sets the values for {name} and {symbol}.
197      *
198      * The default value of {decimals} is 18. To select a different value for
199      * {decimals} you should overload it.
200      *
201      * All two of these values are immutable: they can only be set once during
202      * construction.
203      */
204     constructor(string memory name_, string memory symbol_) {
205         _name = name_;
206         _symbol = symbol_;
207     }
208 
209     /**
210      * @dev Returns the name of the token.
211      */
212     function name() public view virtual override returns (string memory) {
213         return _name;
214     }
215 
216     /**
217      * @dev Returns the symbol of the token, usually a shorter version of the
218      * name.
219      */
220     function symbol() public view virtual override returns (string memory) {
221         return _symbol;
222     }
223 
224     /**
225      * @dev Returns the number of decimals used to get its user representation.
226      * For example, if `decimals` equals `2`, a balance of `505` tokens should
227      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
228      *
229      * Tokens usually opt for a value of 18, imitating the relationship between
230      * Ether and Wei. This is the value {ERC20} uses, unless this function is
231      * overridden;
232      *
233      * NOTE: This information is only used for _display_ purposes: it in
234      * no way affects any of the arithmetic of the contract, including
235      * {IERC20-balanceOf} and {IERC20-transfer}.
236      */
237     function decimals() public view virtual override returns (uint8) {
238         return 18;
239     }
240 
241     /**
242      * @dev See {IERC20-totalSupply}.
243      */
244     function totalSupply() public view virtual override returns (uint256) {
245         return _totalSupply;
246     }
247 
248     /**
249      * @dev See {IERC20-balanceOf}.
250      */
251     function balanceOf(address account) public view virtual override returns (uint256) {
252         return _balances[account];
253     }
254 
255     /**
256      * @dev See {IERC20-transfer}.
257      *
258      * Requirements:
259      *
260      * - `recipient` cannot be the zero address.
261      * - the caller must have a balance of at least `amount`.
262      */
263     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267 
268     /**
269      * @dev See {IERC20-allowance}.
270      */
271     function allowance(address owner, address spender) public view virtual override returns (uint256) {
272         return _allowances[owner][spender];
273     }
274 
275     /**
276      * @dev See {IERC20-approve}.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function approve(address spender, uint256 amount) public virtual override returns (bool) {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286 
287     /**
288      * @dev See {IERC20-transferFrom}.
289      *
290      * Emits an {Approval} event indicating the updated allowance. This is not
291      * required by the EIP. See the note at the beginning of {ERC20}.
292      *
293      * Requirements:
294      *
295      * - `sender` and `recipient` cannot be the zero address.
296      * - `sender` must have a balance of at least `amount`.
297      * - the caller must have allowance for ``sender``'s tokens of at least
298      * `amount`.
299      */
300     function transferFrom(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) public virtual override returns (bool) {
305         _transfer(sender, recipient, amount);
306 
307         uint256 currentAllowance = _allowances[sender][_msgSender()];
308         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
309         unchecked {
310             _approve(sender, _msgSender(), currentAllowance - amount);
311         }
312 
313         return true;
314     }
315 
316     /**
317      * @dev Atomically increases the allowance granted to `spender` by the caller.
318      *
319      * This is an alternative to {approve} that can be used as a mitigation for
320      * problems described in {IERC20-approve}.
321      *
322      * Emits an {Approval} event indicating the updated allowance.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      */
328     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
329         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
330         return true;
331     }
332 
333     /**
334      * @dev Atomically decreases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      * - `spender` must have allowance for the caller of at least
345      * `subtractedValue`.
346      */
347     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
348         uint256 currentAllowance = _allowances[_msgSender()][spender];
349         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
350         unchecked {
351             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
352         }
353 
354         return true;
355     }
356 
357     /**
358      * @dev Moves `amount` of tokens from `sender` to `recipient`.
359      *
360      * This internal function is equivalent to {transfer}, and can be used to
361      * e.g. implement automatic token fees, slashing mechanisms, etc.
362      *
363      * Emits a {Transfer} event.
364      *
365      * Requirements:
366      *
367      * - `sender` cannot be the zero address.
368      * - `recipient` cannot be the zero address.
369      * - `sender` must have a balance of at least `amount`.
370      */
371     function _transfer(
372         address sender,
373         address recipient,
374         uint256 amount
375     ) internal virtual {
376         require(sender != address(0), "ERC20: transfer from the zero address");
377         require(recipient != address(0), "ERC20: transfer to the zero address");
378 
379         _beforeTokenTransfer(sender, recipient, amount);
380 
381         uint256 senderBalance = _balances[sender];
382         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
383         unchecked {
384             _balances[sender] = senderBalance - amount;
385         }
386         _balances[recipient] += amount;
387 
388         emit Transfer(sender, recipient, amount);
389 
390         _afterTokenTransfer(sender, recipient, amount);
391     }
392 
393     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
394      * the total supply.
395      *
396      * Emits a {Transfer} event with `from` set to the zero address.
397      *
398      * Requirements:
399      *
400      * - `account` cannot be the zero address.
401      */
402     function _mint(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: mint to the zero address");
404 
405         _beforeTokenTransfer(address(0), account, amount);
406 
407         _totalSupply += amount;
408         _balances[account] += amount;
409         emit Transfer(address(0), account, amount);
410 
411         _afterTokenTransfer(address(0), account, amount);
412     }
413 
414     /**
415      * @dev Destroys `amount` tokens from `account`, reducing the
416      * total supply.
417      *
418      * Emits a {Transfer} event with `to` set to the zero address.
419      *
420      * Requirements:
421      *
422      * - `account` cannot be the zero address.
423      * - `account` must have at least `amount` tokens.
424      */
425     function _burn(address account, uint256 amount) internal virtual {
426         require(account != address(0), "ERC20: burn from the zero address");
427 
428         _beforeTokenTransfer(account, address(0), amount);
429 
430         uint256 accountBalance = _balances[account];
431         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
432         unchecked {
433             _balances[account] = accountBalance - amount;
434         }
435         _totalSupply -= amount;
436 
437         emit Transfer(account, address(0), amount);
438 
439         _afterTokenTransfer(account, address(0), amount);
440     }
441 
442     /**
443      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
444      *
445      * This internal function is equivalent to `approve`, and can be used to
446      * e.g. set automatic allowances for certain subsystems, etc.
447      *
448      * Emits an {Approval} event.
449      *
450      * Requirements:
451      *
452      * - `owner` cannot be the zero address.
453      * - `spender` cannot be the zero address.
454      */
455     function _approve(
456         address owner,
457         address spender,
458         uint256 amount
459     ) internal virtual {
460         require(owner != address(0), "ERC20: approve from the zero address");
461         require(spender != address(0), "ERC20: approve to the zero address");
462 
463         _allowances[owner][spender] = amount;
464         emit Approval(owner, spender, amount);
465     }
466 
467     /**
468      * @dev Hook that is called before any transfer of tokens. This includes
469      * minting and burning.
470      *
471      * Calling conditions:
472      *
473      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
474      * will be transferred to `to`.
475      * - when `from` is zero, `amount` tokens will be minted for `to`.
476      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
477      * - `from` and `to` are never both zero.
478      *
479      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
480      */
481     function _beforeTokenTransfer(
482         address from,
483         address to,
484         uint256 amount
485     ) internal virtual {}
486 
487     /**
488      * @dev Hook that is called after any transfer of tokens. This includes
489      * minting and burning.
490      *
491      * Calling conditions:
492      *
493      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
494      * has been transferred to `to`.
495      * - when `from` is zero, `amount` tokens have been minted for `to`.
496      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
497      * - `from` and `to` are never both zero.
498      *
499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
500      */
501     function _afterTokenTransfer(
502         address from,
503         address to,
504         uint256 amount
505     ) internal virtual {}
506 }
507 
508 
509 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
510 
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Interface of the ERC165 standard, as defined in the
516  * https://eips.ethereum.org/EIPS/eip-165[EIP].
517  *
518  * Implementers can declare support of contract interfaces, which can then be
519  * queried by others ({ERC165Checker}).
520  *
521  * For an implementation, see {ERC165}.
522  */
523 interface IERC165 {
524     /**
525      * @dev Returns true if this contract implements the interface defined by
526      * `interfaceId`. See the corresponding
527      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
528      * to learn more about how these ids are created.
529      *
530      * This function call must use less than 30 000 gas.
531      */
532     function supportsInterface(bytes4 interfaceId) external view returns (bool);
533 }
534 
535 
536 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
537 
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev Required interface of an ERC721 compliant contract.
543  */
544 interface IERC721 is IERC165 {
545     /**
546      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
547      */
548     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
549 
550     /**
551      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
552      */
553     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
554 
555     /**
556      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
557      */
558     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
559 
560     /**
561      * @dev Returns the number of tokens in ``owner``'s account.
562      */
563     function balanceOf(address owner) external view returns (uint256 balance);
564 
565     /**
566      * @dev Returns the owner of the `tokenId` token.
567      *
568      * Requirements:
569      *
570      * - `tokenId` must exist.
571      */
572     function ownerOf(uint256 tokenId) external view returns (address owner);
573 
574     /**
575      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
576      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must exist and be owned by `from`.
583      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
585      *
586      * Emits a {Transfer} event.
587      */
588     function safeTransferFrom(
589         address from,
590         address to,
591         uint256 tokenId
592     ) external;
593 
594     /**
595      * @dev Transfers `tokenId` token from `from` to `to`.
596      *
597      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must be owned by `from`.
604      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
605      *
606      * Emits a {Transfer} event.
607      */
608     function transferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) external;
613 
614     /**
615      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
616      * The approval is cleared when the token is transferred.
617      *
618      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
619      *
620      * Requirements:
621      *
622      * - The caller must own the token or be an approved operator.
623      * - `tokenId` must exist.
624      *
625      * Emits an {Approval} event.
626      */
627     function approve(address to, uint256 tokenId) external;
628 
629     /**
630      * @dev Returns the account approved for `tokenId` token.
631      *
632      * Requirements:
633      *
634      * - `tokenId` must exist.
635      */
636     function getApproved(uint256 tokenId) external view returns (address operator);
637 
638     /**
639      * @dev Approve or remove `operator` as an operator for the caller.
640      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
641      *
642      * Requirements:
643      *
644      * - The `operator` cannot be the caller.
645      *
646      * Emits an {ApprovalForAll} event.
647      */
648     function setApprovalForAll(address operator, bool _approved) external;
649 
650     /**
651      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
652      *
653      * See {setApprovalForAll}
654      */
655     function isApprovedForAll(address owner, address operator) external view returns (bool);
656 
657     /**
658      * @dev Safely transfers `tokenId` token from `from` to `to`.
659      *
660      * Requirements:
661      *
662      * - `from` cannot be the zero address.
663      * - `to` cannot be the zero address.
664      * - `tokenId` token must exist and be owned by `from`.
665      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
666      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
667      *
668      * Emits a {Transfer} event.
669      */
670     function safeTransferFrom(
671         address from,
672         address to,
673         uint256 tokenId,
674         bytes calldata data
675     ) external;
676 }
677 
678 
679 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
680 
681 
682 pragma solidity ^0.8.0;
683 
684 /**
685  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
686  * @dev See https://eips.ethereum.org/EIPS/eip-721
687  */
688 interface IERC721Enumerable is IERC721 {
689     /**
690      * @dev Returns the total amount of tokens stored by the contract.
691      */
692     function totalSupply() external view returns (uint256);
693 
694     /**
695      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
696      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
697      */
698     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
699 
700     /**
701      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
702      * Use along with {totalSupply} to enumerate all tokens.
703      */
704     function tokenByIndex(uint256 index) external view returns (uint256);
705 }
706 
707 
708 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
709 
710 
711 pragma solidity ^0.8.0;
712 
713 /**
714  * @dev Contract module which provides a basic access control mechanism, where
715  * there is an account (an owner) that can be granted exclusive access to
716  * specific functions.
717  *
718  * By default, the owner account will be the one that deploys the contract. This
719  * can later be changed with {transferOwnership}.
720  *
721  * This module is used through inheritance. It will make available the modifier
722  * `onlyOwner`, which can be applied to your functions to restrict their use to
723  * the owner.
724  */
725 abstract contract Ownable is Context {
726     address private _owner;
727 
728     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
729 
730     /**
731      * @dev Initializes the contract setting the deployer as the initial owner.
732      */
733     constructor() {
734         _setOwner(_msgSender());
735     }
736 
737     /**
738      * @dev Returns the address of the current owner.
739      */
740     function owner() public view virtual returns (address) {
741         return _owner;
742     }
743 
744     /**
745      * @dev Throws if called by any account other than the owner.
746      */
747     modifier onlyOwner() {
748         require(owner() == _msgSender(), "Ownable: caller is not the owner");
749         _;
750     }
751 
752     /**
753      * @dev Leaves the contract without owner. It will not be possible to call
754      * `onlyOwner` functions anymore. Can only be called by the current owner.
755      *
756      * NOTE: Renouncing ownership will leave the contract without an owner,
757      * thereby removing any functionality that is only available to the owner.
758      */
759     function renounceOwnership() public virtual onlyOwner {
760         _setOwner(address(0));
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      * Can only be called by the current owner.
766      */
767     function transferOwnership(address newOwner) public virtual onlyOwner {
768         require(newOwner != address(0), "Ownable: new owner is the zero address");
769         _setOwner(newOwner);
770     }
771 
772     function _setOwner(address newOwner) private {
773         address oldOwner = _owner;
774         _owner = newOwner;
775         emit OwnershipTransferred(oldOwner, newOwner);
776     }
777 }
778 
779                                                   
780 
781 
782 pragma solidity ^0.8.0;
783 contract STIMMY is ERC20, Ownable {
784     // token
785     string token_name   = "STIMMY";
786     string token_symbol = "STIMMY";
787     
788     // supply
789     uint supply_initial  = (100 * 10**12) * 10**decimals();
790     uint supply_burn     = ( 99 * 10**12) * 10**decimals();
791     uint supply_official = (  1 * 10**12) * 10**decimals();
792     
793     uint supply_lp       = (400 * 10**9)  * 10**decimals();
794     
795     uint supply_punks    = (100 * 10**9)  * 10**decimals();
796     uint supply_apes     = (100 * 10**9)  * 10**decimals();
797     uint supply_coolCats = (100 * 10**9)  * 10**decimals();
798     uint supply_doodles  = (100 * 10**9)  * 10**decimals();
799     uint supply_beasts   = (100 * 10**9)  * 10**decimals();
800     
801     uint supply_green    = (100 * 10**9)  * 10**decimals();
802     
803     // transactions
804     uint256 txn_max      = ( 15 * 10**9)  * 10**decimals();
805     
806     // rewards
807     uint reward_punks    = supply_punks    / 10000;
808     uint reward_apes     = supply_apes     / 10000;
809     uint reward_coolCats = supply_coolCats / 10000;
810     uint reward_doodles  = supply_doodles  / 10000;
811     uint reward_beasts   = supply_beasts   / 10000;
812     
813     uint reward_green    = supply_green    / 10000;
814     
815     // claimed
816     uint claimed_official = 0;
817     
818     uint claimed_lp       = 0;
819     
820     uint claimed_punks    = 0;
821     uint claimed_apes     = 0;
822     uint claimed_coolCats = 0;
823     uint claimed_doodles  = 0;
824     uint claimed_beasts   = 0;
825     
826     uint claimed_green    = 0;
827     
828     mapping(uint256 => bool) public claimedByTokenId_punks;
829     mapping(uint256 => bool) public claimedByTokenId_apes;
830     mapping(uint256 => bool) public claimedByTokenId_coolCats;
831     mapping(uint256 => bool) public claimedByTokenId_doodles;
832     mapping(uint256 => bool) public claimedByTokenId_beasts;
833     
834     mapping(uint256 => bool) public claimedBySlotId_green;
835     
836     // contracts
837     address contract_punks    = address(0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB);
838     address contract_apes     = address(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
839     address contract_coolCats = address(0x1A92f7381B9F03921564a437210bB9396471050C);
840     address contract_doodles  = address(0x8a90CAb2b38dba80c64b7734e58Ee1dB38B8992e);
841     address contract_beasts   = address(0xA74E199990FF572A320508547Ab7f44EA51e6F28);
842     
843     address address_uniswap   = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
844     
845     using ECDSA for bytes32;
846     
847     constructor() ERC20(token_name, token_symbol) {
848         _mint(address(this), supply_initial);
849         _burn(address(this), supply_burn);
850         _safeTransfer_lp(supply_lp);
851     }
852     
853     function claim_punks(uint[] memory nfts) public {
854         address user = msg.sender;
855         
856         CryptoPunks _contract = CryptoPunks(contract_punks);
857         
858         uint owned = nfts.length;
859         uint rewards = 0;
860         for (uint256 i = 0; i < owned; ++i) {
861             uint256 nft = nfts[i];
862             
863             if(_contract.punkIndexToAddress(nft) == user && !claimedByTokenId_punks[nft]){
864                 rewards++;
865                 claimedByTokenId_punks[nft] = true;
866             }
867             
868         }
869         _safeTransfer_punks(reward_punks * rewards);
870     }
871     
872     function claim_apes() public {
873         address user = msg.sender;
874         
875         IERC721Enumerable _contract = IERC721Enumerable(contract_apes);
876         
877         uint owned = _contract.balanceOf(user);
878         uint rewards = 0;
879         
880         for (uint256 i = 0; i < owned; ++i) {
881             uint nft = _contract.tokenOfOwnerByIndex(user, i);
882             if(!claimedByTokenId_apes[nft]){
883                 rewards++;
884                 claimedByTokenId_apes[nft] = true;
885             }
886         }
887         _safeTransfer_apes(reward_apes * rewards);
888     }
889     
890     function claim_coolCats() public {
891         address user = msg.sender;
892         
893         IERC721Enumerable _contract = IERC721Enumerable(contract_coolCats);
894         
895         uint owned = _contract.balanceOf(user);
896         uint rewards = 0;
897         
898         for (uint256 i = 0; i < owned; ++i) {
899             uint nft = _contract.tokenOfOwnerByIndex(user, i);
900             if (!claimedByTokenId_coolCats[nft]){
901                 rewards++;
902                 claimedByTokenId_coolCats[nft] = true;
903             }
904             claimedByTokenId_coolCats[nft] = true;
905         }
906         _safeTransfer_coolCats(reward_coolCats * rewards);
907     }
908     
909     function claim_doodles() public {
910         address user = msg.sender;
911         
912         IERC721Enumerable _contract = IERC721Enumerable(contract_doodles);
913         
914         uint owned = _contract.balanceOf(user);
915         uint rewards = 0;
916         
917         for (uint256 i = 0; i < owned; ++i) {
918             uint nft = _contract.tokenOfOwnerByIndex(user, i);
919             if (!claimedByTokenId_doodles[nft]){
920                 rewards++;
921                 claimedByTokenId_doodles[nft] = true;
922             }
923             
924         }
925         _safeTransfer_doodles(reward_doodles * rewards);
926     }
927     
928     function claim_beasts() public {
929         address user = msg.sender;
930         
931         IERC721Enumerable _contract = IERC721Enumerable(contract_beasts);
932         
933         uint owned = _contract.balanceOf(user);
934         uint rewards = 0;
935         
936         for (uint256 i = 0; i < owned; ++i) {
937             uint nft = _contract.tokenOfOwnerByIndex(user, i);
938             if (!claimedByTokenId_beasts[nft]){
939                 rewards++;
940                 claimedByTokenId_beasts[nft] = true;   
941             }
942         }
943         _safeTransfer_beasts(reward_beasts * rewards);
944     }
945     
946     function claim_green(uint slotId, bytes memory sig) public {
947         require(_verifySignature(slotId, sig), "Invalid signature.");
948         require(slotId >= 0 && slotId <= 9999, "Invalid slot number.");
949         require(!claimedBySlotId_green[slotId], "Slot already claimed.");
950         claimedBySlotId_green[slotId] = true;
951         
952         _safeTransfer_green(reward_green);
953     }
954     
955     function _expire_green() public onlyOwner {
956         uint remaining_green = supply_green - claimed_green;
957         _safeTransfer_green(remaining_green);
958     }
959     
960     function _verifySignature(uint256 slotId, bytes memory sig) internal view returns (bool) {
961         bytes32 message = keccak256(abi.encodePacked(slotId, msg.sender)).toHash();
962         address signer = message.recover(sig);
963         return signer == owner();
964     }
965     
966     function claim_1() public{
967         claim_apes();
968         claim_coolCats();
969         claim_doodles();
970         claim_beasts();
971     }
972     
973     function claim_2(uint[] memory punks) public{
974         claim_punks(punks);
975         claim_apes();
976         claim_coolCats();
977         claim_doodles();
978         claim_beasts();
979     }
980     
981     function claim_3(uint256 slotId, bytes memory sig) public{
982         claim_apes();
983         claim_coolCats();
984         claim_doodles();
985         claim_beasts();
986         claim_green(slotId, sig);
987     }
988     
989     function claim_4(uint[] memory punks, uint256 slotId, bytes memory sig) public{
990         claim_punks(punks);
991         claim_apes();
992         claim_coolCats();
993         claim_doodles();
994         claim_beasts();
995         claim_green(slotId, sig);
996     }
997     
998     function _safeTransfer_punks(uint amount) internal {
999         claimed_punks += amount;
1000         require(supply_punks >= claimed_punks, "CryptoPunks fund fully claimed.");
1001         
1002         _safeTransfer(amount);
1003     }
1004     
1005     function _safeTransfer_apes(uint amount) internal {
1006         claimed_apes += amount;
1007         require(supply_apes >= claimed_apes, "Apes fund fully claimed.");
1008         
1009         _safeTransfer(amount);
1010     }
1011     
1012     function _safeTransfer_coolCats(uint amount) internal {
1013         claimed_coolCats += amount;
1014         require(supply_coolCats >= claimed_coolCats, "Cool Cats fund fully claimed.");
1015         
1016         _safeTransfer(amount);
1017     }
1018     
1019     function _safeTransfer_doodles(uint amount) internal {
1020         claimed_doodles += amount;
1021         require(supply_doodles >= claimed_doodles, "Doodles fund fully claimed.");
1022         
1023         _safeTransfer(amount);
1024     }
1025     
1026     function _safeTransfer_beasts(uint amount) internal {
1027         claimed_beasts += amount;
1028         require(supply_beasts >= claimed_beasts, "CryptoBeasts fund fully claimed.");
1029         
1030         _safeTransfer(amount);
1031     }
1032     
1033     function _safeTransfer_green(uint amount) internal {
1034         claimed_green += amount;
1035         require(supply_green >= claimed_green, "Green fund fully claimed.");
1036         
1037         _safeTransfer(amount);
1038     }
1039     
1040     function _safeTransfer_lp(uint amount) internal {
1041         claimed_lp += amount;
1042         require(supply_lp >= claimed_lp, "LP fund fully claimed.");
1043         
1044         _safeTransfer(amount);
1045     }
1046     
1047     function _safeTransfer(uint amount) internal {
1048         claimed_official += amount;
1049         require(supply_official >= claimed_official, "Official fund fully claimed.");
1050         
1051         _transfer(address(this), msg.sender, amount);
1052     }
1053     
1054     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override virtual {
1055         if(from != owner() && to != owner() && from != address(this) && to != address(this) && from != address_uniswap && to != address_uniswap)
1056             require(amount <= txn_max, "Transfer amount exceeds the maximum transaction amount.");
1057     }
1058     
1059     function _setTxnMax(uint _txn_max) public onlyOwner {
1060         txn_max = _txn_max;
1061     }
1062 
1063 }
1064 
1065 library ECDSA {
1066     function recover(bytes32 hash, bytes memory sig) internal pure returns (address) {
1067         uint8 v;
1068         bytes32 r;
1069         bytes32 s;
1070 
1071         assembly {
1072             r := mload(add(sig, 32))
1073             s := mload(add(sig, 64))
1074             v := byte(0, mload(add(sig, 96)))
1075         }
1076 
1077         return ecrecover(hash, v, r, s);
1078     }
1079 
1080     function toHash(bytes32 hash) internal pure returns (bytes32) {
1081         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1082     }
1083 }
1084 
1085 interface CryptoPunks {
1086     function punkIndexToAddress(uint index) external view returns(address);
1087 }