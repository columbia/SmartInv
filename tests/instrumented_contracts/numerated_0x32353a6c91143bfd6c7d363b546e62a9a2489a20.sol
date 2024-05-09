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
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(
41         address indexed previousOwner,
42         address indexed newOwner
43     );
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _setOwner(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _setOwner(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(
84             newOwner != address(0),
85             "Ownable: new owner is the zero address"
86         );
87         _setOwner(newOwner);
88     }
89 
90     function _setOwner(address newOwner) private {
91         address oldOwner = _owner;
92         _owner = newOwner;
93         emit OwnershipTransferred(oldOwner, newOwner);
94     }
95 }
96 
97 /**
98  * @dev Interface of the ERC20 standard as defined in the EIP.
99  */
100 interface IERC20 {
101     /**
102      * @dev Returns the amount of tokens in existence.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     /**
107      * @dev Returns the amount of tokens owned by `account`.
108      */
109     function balanceOf(address account) external view returns (uint256);
110 
111     /**
112      * @dev Moves `amount` tokens from the caller's account to `recipient`.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transfer(address recipient, uint256 amount)
119         external
120         returns (bool);
121 
122     /**
123      * @dev Returns the remaining number of tokens that `spender` will be
124      * allowed to spend on behalf of `owner` through {transferFrom}. This is
125      * zero by default.
126      *
127      * This value changes when {approve} or {transferFrom} are called.
128      */
129     function allowance(address owner, address spender)
130         external
131         view
132         returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) external returns (bool);
164 
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172 
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(
178         address indexed owner,
179         address indexed spender,
180         uint256 value
181     );
182 }
183 
184 /**
185  * @dev Interface for the optional metadata functions from the ERC20 standard.
186  *
187  * _Available since v4.1._
188  */
189 interface IERC20Metadata is IERC20 {
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() external view returns (string memory);
194 
195     /**
196      * @dev Returns the symbol of the token.
197      */
198     function symbol() external view returns (string memory);
199 
200     /**
201      * @dev Returns the decimals places of the token.
202      */
203     function decimals() external view returns (uint8);
204 }
205 
206 /**
207  * @dev Implementation of the {IERC20} interface.
208  *
209  * This implementation is agnostic to the way tokens are created. This means
210  * that a supply mechanism has to be added in a derived contract using {_mint}.
211  * For a generic mechanism see {ERC20PresetMinterPauser}.
212  *
213  * TIP: For a detailed writeup see our guide
214  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
215  * to implement supply mechanisms].
216  *
217  * We have followed general OpenZeppelin Contracts guidelines: functions revert
218  * instead returning `false` on failure. This behavior is nonetheless
219  * conventional and does not conflict with the expectations of ERC20
220  * applications.
221  *
222  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
223  * This allows applications to reconstruct the allowance for all accounts just
224  * by listening to said events. Other implementations of the EIP may not emit
225  * these events, as it isn't required by the specification.
226  *
227  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
228  * functions have been added to mitigate the well-known issues around setting
229  * allowances. See {IERC20-approve}.
230  */
231 contract ERC20 is Context, IERC20, IERC20Metadata {
232     mapping(address => uint256) private _balances;
233 
234     mapping(address => mapping(address => uint256)) private _allowances;
235 
236     uint256 private _totalSupply;
237 
238     string private _name;
239     string private _symbol;
240 
241     /**
242      * @dev Sets the values for {name} and {symbol}.
243      *
244      * The default value of {decimals} is 18. To select a different value for
245      * {decimals} you should overload it.
246      *
247      * All two of these values are immutable: they can only be set once during
248      * construction.
249      */
250     constructor(string memory name_, string memory symbol_) {
251         _name = name_;
252         _symbol = symbol_;
253     }
254 
255     /**
256      * @dev Returns the name of the token.
257      */
258     function name() public view virtual override returns (string memory) {
259         return _name;
260     }
261 
262     /**
263      * @dev Returns the symbol of the token, usually a shorter version of the
264      * name.
265      */
266     function symbol() public view virtual override returns (string memory) {
267         return _symbol;
268     }
269 
270     /**
271      * @dev Returns the number of decimals used to get its user representation.
272      * For example, if `decimals` equals `2`, a balance of `505` tokens should
273      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
274      *
275      * Tokens usually opt for a value of 18, imitating the relationship between
276      * Ether and Wei. This is the value {ERC20} uses, unless this function is
277      * overridden;
278      *
279      * NOTE: This information is only used for _display_ purposes: it in
280      * no way affects any of the arithmetic of the contract, including
281      * {IERC20-balanceOf} and {IERC20-transfer}.
282      */
283     function decimals() public view virtual override returns (uint8) {
284         return 18;
285     }
286 
287     /**
288      * @dev See {IERC20-totalSupply}.
289      */
290     function totalSupply() public view virtual override returns (uint256) {
291         return _totalSupply;
292     }
293 
294     /**
295      * @dev See {IERC20-balanceOf}.
296      */
297     function balanceOf(address account)
298         public
299         view
300         virtual
301         override
302         returns (uint256)
303     {
304         return _balances[account];
305     }
306 
307     /**
308      * @dev See {IERC20-transfer}.
309      *
310      * Requirements:
311      *
312      * - `recipient` cannot be the zero address.
313      * - the caller must have a balance of at least `amount`.
314      */
315     function transfer(address recipient, uint256 amount)
316         public
317         virtual
318         override
319         returns (bool)
320     {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-allowance}.
327      */
328     function allowance(address owner, address spender)
329         public
330         view
331         virtual
332         override
333         returns (uint256)
334     {
335         return _allowances[owner][spender];
336     }
337 
338     /**
339      * @dev See {IERC20-approve}.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function approve(address spender, uint256 amount)
346         public
347         virtual
348         override
349         returns (bool)
350     {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20}.
360      *
361      * Requirements:
362      *
363      * - `sender` and `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      * - the caller must have allowance for ``sender``'s tokens of at least
366      * `amount`.
367      */
368     function transferFrom(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) public virtual override returns (bool) {
373         _transfer(sender, recipient, amount);
374 
375         uint256 currentAllowance = _allowances[sender][_msgSender()];
376         require(
377             currentAllowance >= amount,
378             "ERC20: transfer amount exceeds allowance"
379         );
380         unchecked {
381             _approve(sender, _msgSender(), currentAllowance - amount);
382         }
383 
384         return true;
385     }
386 
387     /**
388      * @dev Atomically increases the allowance granted to `spender` by the caller.
389      *
390      * This is an alternative to {approve} that can be used as a mitigation for
391      * problems described in {IERC20-approve}.
392      *
393      * Emits an {Approval} event indicating the updated allowance.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      */
399     function increaseAllowance(address spender, uint256 addedValue)
400         public
401         virtual
402         returns (bool)
403     {
404         _approve(
405             _msgSender(),
406             spender,
407             _allowances[_msgSender()][spender] + addedValue
408         );
409         return true;
410     }
411 
412     /**
413      * @dev Atomically decreases the allowance granted to `spender` by the caller.
414      *
415      * This is an alternative to {approve} that can be used as a mitigation for
416      * problems described in {IERC20-approve}.
417      *
418      * Emits an {Approval} event indicating the updated allowance.
419      *
420      * Requirements:
421      *
422      * - `spender` cannot be the zero address.
423      * - `spender` must have allowance for the caller of at least
424      * `subtractedValue`.
425      */
426     function decreaseAllowance(address spender, uint256 subtractedValue)
427         public
428         virtual
429         returns (bool)
430     {
431         uint256 currentAllowance = _allowances[_msgSender()][spender];
432         require(
433             currentAllowance >= subtractedValue,
434             "ERC20: decreased allowance below zero"
435         );
436         unchecked {
437             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
438         }
439 
440         return true;
441     }
442 
443     /**
444      * @dev Moves `amount` of tokens from `sender` to `recipient`.
445      *
446      * This internal function is equivalent to {transfer}, and can be used to
447      * e.g. implement automatic token fees, slashing mechanisms, etc.
448      *
449      * Emits a {Transfer} event.
450      *
451      * Requirements:
452      *
453      * - `sender` cannot be the zero address.
454      * - `recipient` cannot be the zero address.
455      * - `sender` must have a balance of at least `amount`.
456      */
457     function _transfer(
458         address sender,
459         address recipient,
460         uint256 amount
461     ) internal virtual {
462         require(sender != address(0), "ERC20: transfer from the zero address");
463         require(recipient != address(0), "ERC20: transfer to the zero address");
464 
465         _beforeTokenTransfer(sender, recipient, amount);
466 
467         uint256 senderBalance = _balances[sender];
468         require(
469             senderBalance >= amount,
470             "ERC20: transfer amount exceeds balance"
471         );
472         unchecked {
473             _balances[sender] = senderBalance - amount;
474         }
475         _balances[recipient] += amount;
476 
477         emit Transfer(sender, recipient, amount);
478 
479         _afterTokenTransfer(sender, recipient, amount);
480     }
481 
482     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
483      * the total supply.
484      *
485      * Emits a {Transfer} event with `from` set to the zero address.
486      *
487      * Requirements:
488      *
489      * - `account` cannot be the zero address.
490      */
491     function _mint(address account, uint256 amount) internal virtual {
492         require(account != address(0), "ERC20: mint to the zero address");
493 
494         _beforeTokenTransfer(address(0), account, amount);
495 
496         _totalSupply += amount;
497         _balances[account] += amount;
498         emit Transfer(address(0), account, amount);
499 
500         _afterTokenTransfer(address(0), account, amount);
501     }
502 
503     /**
504      * @dev Destroys `amount` tokens from `account`, reducing the
505      * total supply.
506      *
507      * Emits a {Transfer} event with `to` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      * - `account` must have at least `amount` tokens.
513      */
514     function _burn(address account, uint256 amount) internal virtual {
515         require(account != address(0), "ERC20: burn from the zero address");
516 
517         _beforeTokenTransfer(account, address(0), amount);
518 
519         uint256 accountBalance = _balances[account];
520         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
521         unchecked {
522             _balances[account] = accountBalance - amount;
523         }
524         _totalSupply -= amount;
525 
526         emit Transfer(account, address(0), amount);
527 
528         _afterTokenTransfer(account, address(0), amount);
529     }
530 
531     /**
532      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
533      *
534      * This internal function is equivalent to `approve`, and can be used to
535      * e.g. set automatic allowances for certain subsystems, etc.
536      *
537      * Emits an {Approval} event.
538      *
539      * Requirements:
540      *
541      * - `owner` cannot be the zero address.
542      * - `spender` cannot be the zero address.
543      */
544     function _approve(
545         address owner,
546         address spender,
547         uint256 amount
548     ) internal virtual {
549         require(owner != address(0), "ERC20: approve from the zero address");
550         require(spender != address(0), "ERC20: approve to the zero address");
551 
552         _allowances[owner][spender] = amount;
553         emit Approval(owner, spender, amount);
554     }
555 
556     /**
557      * @dev Hook that is called before any transfer of tokens. This includes
558      * minting and burning.
559      *
560      * Calling conditions:
561      *
562      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
563      * will be transferred to `to`.
564      * - when `from` is zero, `amount` tokens will be minted for `to`.
565      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
566      * - `from` and `to` are never both zero.
567      *
568      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
569      */
570     function _beforeTokenTransfer(
571         address from,
572         address to,
573         uint256 amount
574     ) internal virtual {}
575 
576     /**
577      * @dev Hook that is called after any transfer of tokens. This includes
578      * minting and burning.
579      *
580      * Calling conditions:
581      *
582      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
583      * has been transferred to `to`.
584      * - when `from` is zero, `amount` tokens have been minted for `to`.
585      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
586      * - `from` and `to` are never both zero.
587      *
588      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
589      */
590     function _afterTokenTransfer(
591         address from,
592         address to,
593         uint256 amount
594     ) internal virtual {}
595 }
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @dev Interface of the ERC165 standard, as defined in the
601  * https://eips.ethereum.org/EIPS/eip-165[EIP].
602  *
603  * Implementers can declare support of contract interfaces, which can then be
604  * queried by others ({ERC165Checker}).
605  *
606  * For an implementation, see {ERC165}.
607  */
608 interface IERC165 {
609     /**
610      * @dev Returns true if this contract implements the interface defined by
611      * `interfaceId`. See the corresponding
612      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
613      * to learn more about how these ids are created.
614      *
615      * This function call must use less than 30 000 gas.
616      */
617     function supportsInterface(bytes4 interfaceId) external view returns (bool);
618 }
619 
620 /**
621  * @dev Implementation of the {IERC165} interface.
622  *
623  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
624  * for the additional interface id that will be supported. For example:
625  *
626  * ```solidity
627  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
628  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
629  * }
630  * ```
631  *
632  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
633  */
634 abstract contract ERC165 is IERC165 {
635     /**
636      * @dev See {IERC165-supportsInterface}.
637      */
638     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
639         return interfaceId == type(IERC165).interfaceId;
640     }
641 }
642 
643 /**
644  * @dev Required interface of an ERC721 compliant contract.
645  */
646 interface IERC721 is IERC165 {
647     /**
648      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
649      */
650     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
651 
652     /**
653      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
654      */
655     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
656 
657     /**
658      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
659      */
660     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
661 
662     /**
663      * @dev Returns the number of tokens in ``owner``'s account.
664      */
665     function balanceOf(address owner) external view returns (uint256 balance);
666 
667     /**
668      * @dev Returns the owner of the `tokenId` token.
669      *
670      * Requirements:
671      *
672      * - `tokenId` must exist.
673      */
674     function ownerOf(uint256 tokenId) external view returns (address owner);
675 
676     /**
677      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
678      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must exist and be owned by `from`.
685      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
686      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
687      *
688      * Emits a {Transfer} event.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) external;
695 
696     /**
697      * @dev Transfers `tokenId` token from `from` to `to`.
698      *
699      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
700      *
701      * Requirements:
702      *
703      * - `from` cannot be the zero address.
704      * - `to` cannot be the zero address.
705      * - `tokenId` token must be owned by `from`.
706      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
707      *
708      * Emits a {Transfer} event.
709      */
710     function transferFrom(
711         address from,
712         address to,
713         uint256 tokenId
714     ) external;
715 
716     /**
717      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
718      * The approval is cleared when the token is transferred.
719      *
720      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
721      *
722      * Requirements:
723      *
724      * - The caller must own the token or be an approved operator.
725      * - `tokenId` must exist.
726      *
727      * Emits an {Approval} event.
728      */
729     function approve(address to, uint256 tokenId) external;
730 
731     /**
732      * @dev Returns the account approved for `tokenId` token.
733      *
734      * Requirements:
735      *
736      * - `tokenId` must exist.
737      */
738     function getApproved(uint256 tokenId) external view returns (address operator);
739 
740     /**
741      * @dev Approve or remove `operator` as an operator for the caller.
742      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
743      *
744      * Requirements:
745      *
746      * - The `operator` cannot be the caller.
747      *
748      * Emits an {ApprovalForAll} event.
749      */
750     function setApprovalForAll(address operator, bool _approved) external;
751 
752     /**
753      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
754      *
755      * See {setApprovalForAll}
756      */
757     function isApprovedForAll(address owner, address operator) external view returns (bool);
758 
759     /**
760      * @dev Safely transfers `tokenId` token from `from` to `to`.
761      *
762      * Requirements:
763      *
764      * - `from` cannot be the zero address.
765      * - `to` cannot be the zero address.
766      * - `tokenId` token must exist and be owned by `from`.
767      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId,
776         bytes calldata data
777     ) external;
778 }
779 
780 
781 /**
782  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
783  * @dev See https://eips.ethereum.org/EIPS/eip-721
784  */
785 interface IERC721Enumerable is IERC721 {
786     /**
787      * @dev Returns the total amount of tokens stored by the contract.
788      */
789     function totalSupply() external view returns (uint256);
790 
791     /**
792      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
793      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
794      */
795     function tokenOfOwnerByIndex(address owner, uint256 index)
796         external
797         view
798         returns (uint256 tokenId);
799 
800     /**
801      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
802      * Use along with {totalSupply} to enumerate all tokens.
803      */
804     function tokenByIndex(uint256 index) external view returns (uint256);
805 }
806 
807 /// @title Adventure Gold for Loot holders!
808 /// @author Will Papper <https://twitter.com/WillPapper>
809 /// @notice This contract mints Adventure Gold for Loot holders and provides
810 /// administrative functions to the Loot DAO. It allows:
811 /// * Loot holders to claim Adventure Gold
812 /// * A DAO to set seasons for new opportunities to claim Adventure Gold
813 /// * A DAO to mint Adventure Gold for use within the Loot ecosystem
814 /// @custom:unaudited This contract has not been audited. Use at your own risk.
815 contract AdventureGold is Context, Ownable, ERC20 {
816     // Loot contract is available at https://etherscan.io/address/0xff9c1b15b16263c61d017ee9f65c50e4ae0113d7
817     address public lootContractAddress =
818         0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7;
819     IERC721Enumerable public lootContract;
820 
821     // Give out 10,000 Adventure Gold for every Loot Bag that a user holds
822     uint256 public adventureGoldPerTokenId = 10000 * (10**decimals());
823 
824     // tokenIdStart of 1 is based on the following lines in the Loot contract:
825     /** 
826     function claim(uint256 tokenId) public nonReentrant {
827         require(tokenId > 0 && tokenId < 7778, "Token ID invalid");
828         _safeMint(_msgSender(), tokenId);
829     }
830     */
831     uint256 public tokenIdStart = 1;
832 
833     // tokenIdEnd of 8000 is based on the following lines in the Loot contract:
834     /**
835         function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
836         require(tokenId > 7777 && tokenId < 8001, "Token ID invalid");
837         _safeMint(owner(), tokenId);
838     }
839     */
840     uint256 public tokenIdEnd = 8000;
841 
842     // Seasons are used to allow users to claim tokens regularly. Seasons are
843     // decided by the DAO.
844     uint256 public season = 0;
845 
846     // Track claimed tokens within a season
847     // IMPORTANT: The format of the mapping is:
848     // claimedForSeason[season][tokenId][claimed]
849     mapping(uint256 => mapping(uint256 => bool)) public seasonClaimedByTokenId;
850 
851     constructor() Ownable() ERC20("Adventure Gold", "AGLD") {
852         // Transfer ownership to the Loot DAO
853         // Ownable by OpenZeppelin automatically sets owner to msg.sender, but
854         // we're going to be using a separate wallet for deployment
855         transferOwnership(0xcD814C83198C15A542F9A13FAf84D518d1744ED1);
856         lootContract = IERC721Enumerable(lootContractAddress);
857     }
858 
859     /// @notice Claim Adventure Gold for a given Loot ID
860     /// @param tokenId The tokenId of the Loot NFT
861     function claimById(uint256 tokenId) external {
862         // Follow the Checks-Effects-Interactions pattern to prevent reentrancy
863         // attacks
864 
865         // Checks
866 
867         // Check that the msgSender owns the token that is being claimed
868         require(
869             _msgSender() == lootContract.ownerOf(tokenId),
870             "MUST_OWN_TOKEN_ID"
871         );
872 
873         // Further Checks, Effects, and Interactions are contained within the
874         // _claim() function
875         _claim(tokenId, _msgSender());
876     }
877 
878     /// @notice Claim Adventure Gold for all tokens owned by the sender
879     /// @notice This function will run out of gas if you have too much loot! If
880     /// this is a concern, you should use claimRangeForOwner and claim Adventure
881     /// Gold in batches.
882     function claimAllForOwner() external {
883         uint256 tokenBalanceOwner = lootContract.balanceOf(_msgSender());
884 
885         // Checks
886         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
887 
888         // i < tokenBalanceOwner because tokenBalanceOwner is 1-indexed
889         for (uint256 i = 0; i < tokenBalanceOwner; i++) {
890             // Further Checks, Effects, and Interactions are contained within
891             // the _claim() function
892             _claim(
893                 lootContract.tokenOfOwnerByIndex(_msgSender(), i),
894                 _msgSender()
895             );
896         }
897     }
898 
899     /// @notice Claim Adventure Gold for all tokens owned by the sender within a
900     /// given range
901     /// @notice This function is useful if you own too much Loot to claim all at
902     /// once or if you want to leave some Loot unclaimed. If you leave Loot
903     /// unclaimed, however, you cannot claim it once the next season starts.
904     function claimRangeForOwner(uint256 ownerIndexStart, uint256 ownerIndexEnd)
905         external
906     {
907         uint256 tokenBalanceOwner = lootContract.balanceOf(_msgSender());
908 
909         // Checks
910         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
911 
912         // We use < for ownerIndexEnd and tokenBalanceOwner because
913         // tokenOfOwnerByIndex is 0-indexed while the token balance is 1-indexed
914         require(
915             ownerIndexStart >= 0 && ownerIndexEnd < tokenBalanceOwner,
916             "INDEX_OUT_OF_RANGE"
917         );
918 
919         // i <= ownerIndexEnd because ownerIndexEnd is 0-indexed
920         for (uint256 i = ownerIndexStart; i <= ownerIndexEnd; i++) {
921             // Further Checks, Effects, and Interactions are contained within
922             // the _claim() function
923             _claim(
924                 lootContract.tokenOfOwnerByIndex(_msgSender(), i),
925                 _msgSender()
926             );
927         }
928     }
929 
930     /// @dev Internal function to mint Loot upon claiming
931     function _claim(uint256 tokenId, address tokenOwner) internal {
932         // Checks
933         // Check that the token ID is in range
934         // We use >= and <= to here because all of the token IDs are 0-indexed
935         require(
936             tokenId >= tokenIdStart && tokenId <= tokenIdEnd,
937             "TOKEN_ID_OUT_OF_RANGE"
938         );
939 
940         // Check that Adventure Gold have not already been claimed this season
941         // for a given tokenId
942         require(
943             !seasonClaimedByTokenId[season][tokenId],
944             "GOLD_CLAIMED_FOR_TOKEN_ID"
945         );
946 
947         // Effects
948 
949         // Mark that Adventure Gold has been claimed for this season for the
950         // given tokenId
951         seasonClaimedByTokenId[season][tokenId] = true;
952 
953         // Interactions
954 
955         // Send Adventure Gold to the owner of the token ID
956         _mint(tokenOwner, adventureGoldPerTokenId);
957     }
958 
959     /// @notice Allows the DAO to mint new tokens for use within the Loot
960     /// Ecosystem
961     /// @param amountDisplayValue The amount of Loot to mint. This should be
962     /// input as the display value, not in raw decimals. If you want to mint
963     /// 100 Loot, you should enter "100" rather than the value of 100 * 10^18.
964     function daoMint(uint256 amountDisplayValue) external onlyOwner {
965         _mint(owner(), amountDisplayValue * (10**decimals()));
966     }
967 
968     /// @notice Allows the DAO to set a new contract address for Loot. This is
969     /// relevant in the event that Loot migrates to a new contract.
970     /// @param lootContractAddress_ The new contract address for Loot
971     function daoSetLootContractAddress(address lootContractAddress_)
972         external
973         onlyOwner
974     {
975         lootContractAddress = lootContractAddress_;
976         lootContract = IERC721Enumerable(lootContractAddress);
977     }
978 
979     /// @notice Allows the DAO to set the token IDs that are eligible to claim
980     /// Loot
981     /// @param tokenIdStart_ The start of the eligible token range
982     /// @param tokenIdEnd_ The end of the eligible token range
983     /// @dev This is relevant in case a future Loot contract has a different
984     /// total supply of Loot
985     function daoSetTokenIdRange(uint256 tokenIdStart_, uint256 tokenIdEnd_)
986         external
987         onlyOwner
988     {
989         tokenIdStart = tokenIdStart_;
990         tokenIdEnd = tokenIdEnd_;
991     }
992 
993     /// @notice Allows the DAO to set a season for new Adventure Gold claims
994     /// @param season_ The season to use for claiming Loot
995     function daoSetSeason(uint256 season_) public onlyOwner {
996         season = season_;
997     }
998 
999     /// @notice Allows the DAO to set the amount of Adventure Gold that is
1000     /// claimed per token ID
1001     /// @param adventureGoldDisplayValue The amount of Loot a user can claim.
1002     /// This should be input as the display value, not in raw decimals. If you
1003     /// want to mint 100 Loot, you should enter "100" rather than the value of
1004     /// 100 * 10^18.
1005     function daoSetAdventureGoldPerTokenId(uint256 adventureGoldDisplayValue)
1006         public
1007         onlyOwner
1008     {
1009         adventureGoldPerTokenId = adventureGoldDisplayValue * (10**decimals());
1010     }
1011 
1012     /// @notice Allows the DAO to set the season and Adventure Gold per token ID
1013     /// in one transaction. This ensures that there is not a gap where a user
1014     /// can claim more Adventure Gold than others
1015     /// @param season_ The season to use for claiming loot
1016     /// @param adventureGoldDisplayValue The amount of Loot a user can claim.
1017     /// This should be input as the display value, not in raw decimals. If you
1018     /// want to mint 100 Loot, you should enter "100" rather than the value of
1019     /// 100 * 10^18.
1020     /// @dev We would save a tiny amount of gas by modifying the season and
1021     /// adventureGold variables directly. It is better practice for security,
1022     /// however, to avoid repeating code. This function is so rarely used that
1023     /// it's not worth moving these values into their own internal function to
1024     /// skip the gas used on the modifier check.
1025     function daoSetSeasonAndAdventureGoldPerTokenID(
1026         uint256 season_,
1027         uint256 adventureGoldDisplayValue
1028     ) external onlyOwner {
1029         daoSetSeason(season_);
1030         daoSetAdventureGoldPerTokenId(adventureGoldDisplayValue);
1031     }
1032 }