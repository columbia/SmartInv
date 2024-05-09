1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-01
3 */
4 
5 // SPDX-License-Identifier: UNLICENSED
6 
7 pragma solidity ^0.8.0;
8 
9 /**
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
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _setOwner(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _setOwner(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      * We are removing the non zero address require to burn the contract by
86      * sending it to the zero address.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         /*require(
90             newOwner != address(0),
91             "Ownable: new owner is the zero address"
92         );*/
93         _setOwner(newOwner);
94     }
95 
96     function _setOwner(address newOwner) private {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 /**
104  * @dev Interface of the ERC20 standard as defined in the EIP.
105  */
106 interface IERC20 {
107     /**
108      * @dev Returns the amount of tokens in existence.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     /**
113      * @dev Returns the amount of tokens owned by `account`.
114      */
115     function balanceOf(address account) external view returns (uint256);
116 
117     /**
118      * @dev Moves `amount` tokens from the caller's account to `recipient`.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transfer(address recipient, uint256 amount)
125         external
126         returns (bool);
127 
128     /**
129      * @dev Returns the remaining number of tokens that `spender` will be
130      * allowed to spend on behalf of `owner` through {transferFrom}. This is
131      * zero by default.
132      *
133      * This value changes when {approve} or {transferFrom} are called.
134      */
135     function allowance(address owner, address spender)
136         external
137         view
138         returns (uint256);
139 
140     /**
141      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * IMPORTANT: Beware that changing an allowance with this method brings the risk
146      * that someone may use both the old and the new allowance by unfortunate
147      * transaction ordering. One possible solution to mitigate this race
148      * condition is to first reduce the spender's allowance to 0 and set the
149      * desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address spender, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Moves `amount` tokens from `sender` to `recipient` using the
158      * allowance mechanism. `amount` is then deducted from the caller's
159      * allowance.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) external returns (bool);
170 
171     /**
172      * @dev Emitted when `value` tokens are moved from one account (`from`) to
173      * another (`to`).
174      *
175      * Note that `value` may be zero.
176      */
177     event Transfer(address indexed from, address indexed to, uint256 value);
178 
179     /**
180      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
181      * a call to {approve}. `value` is the new allowance.
182      */
183     event Approval(
184         address indexed owner,
185         address indexed spender,
186         uint256 value
187     );
188 }
189 
190 /**
191  * @dev Interface for the optional metadata functions from the ERC20 standard.
192  *
193  * _Available since v4.1._
194  */
195 interface IERC20Metadata is IERC20 {
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the symbol of the token.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the decimals places of the token.
208      */
209     function decimals() external view returns (uint8);
210 }
211 
212 /**
213  * @dev Implementation of the {IERC20} interface.
214  *
215  * This implementation is agnostic to the way tokens are created. This means
216  * that a supply mechanism has to be added in a derived contract using {_mint}.
217  * For a generic mechanism see {ERC20PresetMinterPauser}.
218  *
219  * TIP: For a detailed writeup see our guide
220  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
221  * to implement supply mechanisms].
222  *
223  * We have followed general OpenZeppelin Contracts guidelines: functions revert
224  * instead returning `false` on failure. This behavior is nonetheless
225  * conventional and does not conflict with the expectations of ERC20
226  * applications.
227  *
228  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
229  * This allows applications to reconstruct the allowance for all accounts just
230  * by listening to said events. Other implementations of the EIP may not emit
231  * these events, as it isn't required by the specification.
232  *
233  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
234  * functions have been added to mitigate the well-known issues around setting
235  * allowances. See {IERC20-approve}.
236  */
237 contract ERC20 is Context, IERC20, IERC20Metadata {
238     mapping(address => uint256) private _balances;
239 
240     mapping(address => mapping(address => uint256)) private _allowances;
241 
242     uint256 private _totalSupply;
243 
244     string private _name;
245     string private _symbol;
246 
247     /**
248      * @dev Sets the values for {name} and {symbol}.
249      *
250      * The default value of {decimals} is 18. To select a different value for
251      * {decimals} you should overload it.
252      *
253      * All two of these values are immutable: they can only be set once during
254      * construction.
255      */
256     constructor(string memory name_, string memory symbol_) {
257         _name = name_;
258         _symbol = symbol_;
259     }
260 
261     /**
262      * @dev Returns the name of the token.
263      */
264     function name() public view virtual override returns (string memory) {
265         return _name;
266     }
267 
268     /**
269      * @dev Returns the symbol of the token, usually a shorter version of the
270      * name.
271      */
272     function symbol() public view virtual override returns (string memory) {
273         return _symbol;
274     }
275 
276     /**
277      * @dev Returns the number of decimals used to get its user representation.
278      * For example, if `decimals` equals `2`, a balance of `505` tokens should
279      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
280      *
281      * Tokens usually opt for a value of 18, imitating the relationship between
282      * Ether and Wei. This is the value {ERC20} uses, unless this function is
283      * overridden;
284      *
285      * NOTE: This information is only used for _display_ purposes: it in
286      * no way affects any of the arithmetic of the contract, including
287      * {IERC20-balanceOf} and {IERC20-transfer}.
288      */
289     function decimals() public view virtual override returns (uint8) {
290         return 18;
291     }
292 
293     /**
294      * @dev See {IERC20-totalSupply}.
295      */
296     function totalSupply() public view virtual override returns (uint256) {
297         return _totalSupply;
298     }
299 
300     /**
301      * @dev See {IERC20-balanceOf}.
302      */
303     function balanceOf(address account)
304         public
305         view
306         virtual
307         override
308         returns (uint256)
309     {
310         return _balances[account];
311     }
312 
313     /**
314      * @dev See {IERC20-transfer}.
315      *
316      * Requirements:
317      *
318      * - `recipient` cannot be the zero address.
319      * - the caller must have a balance of at least `amount`.
320      */
321     function transfer(address recipient, uint256 amount)
322         public
323         virtual
324         override
325         returns (bool)
326     {
327         _transfer(_msgSender(), recipient, amount);
328         return true;
329     }
330 
331     /**
332      * @dev See {IERC20-allowance}.
333      */
334     function allowance(address owner, address spender)
335         public
336         view
337         virtual
338         override
339         returns (uint256)
340     {
341         return _allowances[owner][spender];
342     }
343 
344     /**
345      * @dev See {IERC20-approve}.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function approve(address spender, uint256 amount)
352         public
353         virtual
354         override
355         returns (bool)
356     {
357         _approve(_msgSender(), spender, amount);
358         return true;
359     }
360 
361     /**
362      * @dev See {IERC20-transferFrom}.
363      *
364      * Emits an {Approval} event indicating the updated allowance. This is not
365      * required by the EIP. See the note at the beginning of {ERC20}.
366      *
367      * Requirements:
368      *
369      * - `sender` and `recipient` cannot be the zero address.
370      * - `sender` must have a balance of at least `amount`.
371      * - the caller must have allowance for ``sender``'s tokens of at least
372      * `amount`.
373      */
374     function transferFrom(
375         address sender,
376         address recipient,
377         uint256 amount
378     ) public virtual override returns (bool) {
379         _transfer(sender, recipient, amount);
380 
381         uint256 currentAllowance = _allowances[sender][_msgSender()];
382         require(
383             currentAllowance >= amount,
384             "ERC20: transfer amount exceeds allowance"
385         );
386         unchecked {
387             _approve(sender, _msgSender(), currentAllowance - amount);
388         }
389 
390         return true;
391     }
392 
393     /**
394      * @dev Atomically increases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      */
405     function increaseAllowance(address spender, uint256 addedValue)
406         public
407         virtual
408         returns (bool)
409     {
410         _approve(
411             _msgSender(),
412             spender,
413             _allowances[_msgSender()][spender] + addedValue
414         );
415         return true;
416     }
417 
418     /**
419      * @dev Atomically decreases the allowance granted to `spender` by the caller.
420      *
421      * This is an alternative to {approve} that can be used as a mitigation for
422      * problems described in {IERC20-approve}.
423      *
424      * Emits an {Approval} event indicating the updated allowance.
425      *
426      * Requirements:
427      *
428      * - `spender` cannot be the zero address.
429      * - `spender` must have allowance for the caller of at least
430      * `subtractedValue`.
431      */
432     function decreaseAllowance(address spender, uint256 subtractedValue)
433         public
434         virtual
435         returns (bool)
436     {
437         uint256 currentAllowance = _allowances[_msgSender()][spender];
438         require(
439             currentAllowance >= subtractedValue,
440             "ERC20: decreased allowance below zero"
441         );
442         unchecked {
443             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
444         }
445 
446         return true;
447     }
448 
449     /**
450      * @dev Moves `amount` of tokens from `sender` to `recipient`.
451      *
452      * This internal function is equivalent to {transfer}, and can be used to
453      * e.g. implement automatic token fees, slashing mechanisms, etc.
454      *
455      * Emits a {Transfer} event.
456      *
457      * Requirements:
458      *
459      * - `sender` cannot be the zero address.
460      * - `recipient` cannot be the zero address.
461      * - `sender` must have a balance of at least `amount`.
462      */
463     function _transfer(
464         address sender,
465         address recipient,
466         uint256 amount
467     ) internal virtual {
468         require(sender != address(0), "ERC20: transfer from the zero address");
469         require(recipient != address(0), "ERC20: transfer to the zero address");
470 
471         _beforeTokenTransfer(sender, recipient, amount);
472 
473         uint256 senderBalance = _balances[sender];
474         require(
475             senderBalance >= amount,
476             "ERC20: transfer amount exceeds balance"
477         );
478         unchecked {
479             _balances[sender] = senderBalance - amount;
480         }
481         _balances[recipient] += amount;
482 
483         emit Transfer(sender, recipient, amount);
484 
485         _afterTokenTransfer(sender, recipient, amount);
486     }
487 
488     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
489      * the total supply.
490      *
491      * Emits a {Transfer} event with `from` set to the zero address.
492      *
493      * Requirements:
494      *
495      * - `account` cannot be the zero address.
496      */
497     function _mint(address account, uint256 amount) internal virtual {
498         require(account != address(0), "ERC20: mint to the zero address");
499 
500         _beforeTokenTransfer(address(0), account, amount);
501 
502         _totalSupply += amount;
503         _balances[account] += amount;
504         emit Transfer(address(0), account, amount);
505 
506         _afterTokenTransfer(address(0), account, amount);
507     }
508 
509     /**
510      * @dev Destroys `amount` tokens from `account`, reducing the
511      * total supply.
512      *
513      * Emits a {Transfer} event with `to` set to the zero address.
514      *
515      * Requirements:
516      *
517      * - `account` cannot be the zero address.
518      * - `account` must have at least `amount` tokens.
519      */
520     function _burn(address account, uint256 amount) internal virtual {
521         require(account != address(0), "ERC20: burn from the zero address");
522 
523         _beforeTokenTransfer(account, address(0), amount);
524 
525         uint256 accountBalance = _balances[account];
526         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
527         unchecked {
528             _balances[account] = accountBalance - amount;
529         }
530         _totalSupply -= amount;
531 
532         emit Transfer(account, address(0), amount);
533 
534         _afterTokenTransfer(account, address(0), amount);
535     }
536 
537     /**
538      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
539      *
540      * This internal function is equivalent to `approve`, and can be used to
541      * e.g. set automatic allowances for certain subsystems, etc.
542      *
543      * Emits an {Approval} event.
544      *
545      * Requirements:
546      *
547      * - `owner` cannot be the zero address.
548      * - `spender` cannot be the zero address.
549      */
550     function _approve(
551         address owner,
552         address spender,
553         uint256 amount
554     ) internal virtual {
555         require(owner != address(0), "ERC20: approve from the zero address");
556         require(spender != address(0), "ERC20: approve to the zero address");
557 
558         _allowances[owner][spender] = amount;
559         emit Approval(owner, spender, amount);
560     }
561 
562     /**
563      * @dev Hook that is called before any transfer of tokens. This includes
564      * minting and burning.
565      *
566      * Calling conditions:
567      *
568      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
569      * will be transferred to `to`.
570      * - when `from` is zero, `amount` tokens will be minted for `to`.
571      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
572      * - `from` and `to` are never both zero.
573      *
574      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
575      */
576     function _beforeTokenTransfer(
577         address from,
578         address to,
579         uint256 amount
580     ) internal virtual {}
581 
582     /**
583      * @dev Hook that is called after any transfer of tokens. This includes
584      * minting and burning.
585      *
586      * Calling conditions:
587      *
588      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
589      * has been transferred to `to`.
590      * - when `from` is zero, `amount` tokens have been minted for `to`.
591      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
592      * - `from` and `to` are never both zero.
593      *
594      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
595      */
596     function _afterTokenTransfer(
597         address from,
598         address to,
599         uint256 amount
600     ) internal virtual {}
601 }
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Interface of the ERC165 standard, as defined in the
607  * https://eips.ethereum.org/EIPS/eip-165[EIP].
608  *
609  * Implementers can declare support of contract interfaces, which can then be
610  * queried by others ({ERC165Checker}).
611  *
612  * For an implementation, see {ERC165}.
613  */
614 interface IERC165 {
615     /**
616      * @dev Returns true if this contract implements the interface defined by
617      * `interfaceId`. See the corresponding
618      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
619      * to learn more about how these ids are created.
620      *
621      * This function call must use less than 30 000 gas.
622      */
623     function supportsInterface(bytes4 interfaceId) external view returns (bool);
624 }
625 
626 /**
627  * @dev Implementation of the {IERC165} interface.
628  *
629  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
630  * for the additional interface id that will be supported. For example:
631  *
632  * ```solidity
633  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
634  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
635  * }
636  * ```
637  *
638  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
639  */
640 abstract contract ERC165 is IERC165 {
641     /**
642      * @dev See {IERC165-supportsInterface}.
643      */
644     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
645         return interfaceId == type(IERC165).interfaceId;
646     }
647 }
648 
649 /**
650  * @dev Required interface of an ERC721 compliant contract.
651  */
652 interface IERC721 is IERC165 {
653     /**
654      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
655      */
656     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
657 
658     /**
659      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
660      */
661     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
662 
663     /**
664      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
665      */
666     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
667 
668     /**
669      * @dev Returns the number of tokens in ``owner``'s account.
670      */
671     function balanceOf(address owner) external view returns (uint256 balance);
672 
673     /**
674      * @dev Returns the owner of the `tokenId` token.
675      *
676      * Requirements:
677      *
678      * - `tokenId` must exist.
679      */
680     function ownerOf(uint256 tokenId) external view returns (address owner);
681 
682     /**
683      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
684      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
685      *
686      * Requirements:
687      *
688      * - `from` cannot be the zero address.
689      * - `to` cannot be the zero address.
690      * - `tokenId` token must exist and be owned by `from`.
691      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
692      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
693      *
694      * Emits a {Transfer} event.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) external;
701 
702     /**
703      * @dev Transfers `tokenId` token from `from` to `to`.
704      *
705      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
706      *
707      * Requirements:
708      *
709      * - `from` cannot be the zero address.
710      * - `to` cannot be the zero address.
711      * - `tokenId` token must be owned by `from`.
712      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
713      *
714      * Emits a {Transfer} event.
715      */
716     function transferFrom(
717         address from,
718         address to,
719         uint256 tokenId
720     ) external;
721 
722     /**
723      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
724      * The approval is cleared when the token is transferred.
725      *
726      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
727      *
728      * Requirements:
729      *
730      * - The caller must own the token or be an approved operator.
731      * - `tokenId` must exist.
732      *
733      * Emits an {Approval} event.
734      */
735     function approve(address to, uint256 tokenId) external;
736 
737     /**
738      * @dev Returns the account approved for `tokenId` token.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function getApproved(uint256 tokenId) external view returns (address operator);
745 
746     /**
747      * @dev Approve or remove `operator` as an operator for the caller.
748      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
749      *
750      * Requirements:
751      *
752      * - The `operator` cannot be the caller.
753      *
754      * Emits an {ApprovalForAll} event.
755      */
756     function setApprovalForAll(address operator, bool _approved) external;
757 
758     /**
759      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
760      *
761      * See {setApprovalForAll}
762      */
763     function isApprovedForAll(address owner, address operator) external view returns (bool);
764 
765     /**
766      * @dev Safely transfers `tokenId` token from `from` to `to`.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must exist and be owned by `from`.
773      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes calldata data
783     ) external;
784 }
785 
786 
787 /**
788  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
789  * @dev See https://eips.ethereum.org/EIPS/eip-721
790  */
791 interface IERC721Enumerable is IERC721 {
792     /**
793      * @dev Returns the total amount of tokens stored by the contract.
794      */
795     function totalSupply() external view returns (uint256);
796 
797     /**
798      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
799      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
800      */
801     function tokenOfOwnerByIndex(address owner, uint256 index)
802         external
803         view
804         returns (uint256 tokenId);
805 
806     /**
807      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
808      * Use along with {totalSupply} to enumerate all tokens.
809      */
810     function tokenByIndex(uint256 index) external view returns (uint256);
811 }
812 
813 /// @title Scammer Gold for sLoot holders!
814 /// @notice This contract mints Scammer Gold for sLoot holders and provides
815 /// administrative functions to the sLoot DAO. It allows:
816 /// * sLoot holders to claim Scammer Gold
817 /// * A DAO to set seasons for new opportunities to claim Scammer Gold
818 /// * A DAO to mint Scammer Gold for use within the sLoot ecosystem
819 /// @custom:unaudited This contract has not been audited. Use at your own risk.
820 contract ScammerGold is Context, Ownable, ERC20 {
821     // sLoot contract is available at https://etherscan.io/address/0xb12F78434AE7D12Ae548c51A5cb734Ecc4536594
822     address public slootContractAddress =
823         0xb12F78434AE7D12Ae548c51A5cb734Ecc4536594;
824     IERC721Enumerable public slootContract;
825 
826     // Give out 10,000 Scammer Gold for every sLoot Bag that a user holds
827     uint256 public scammerGoldPerTokenId = 10000 * (10**decimals());
828 
829     // tokenIdStart of 1 is based on the following lines in the sLoot contract:
830     /** 
831     function claim(uint256 tokenId) public nonReentrant {
832         require(tokenId > 0 && tokenId < 7778, "Token ID invalid");
833         _safeMint(_msgSender(), tokenId);
834     }
835     */
836     uint256 public tokenIdStart = 1;
837 
838     // tokenIdEnd of 8000 is based on the following lines in the sLoot contract:
839     /**
840         function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
841         require(tokenId > 7777 && tokenId < 8001, "Token ID invalid");
842         _safeMint(owner(), tokenId);
843     }
844     */
845     uint256 public tokenIdEnd = 8000;
846 
847     // Seasons are used to allow users to claim tokens regularly. Seasons are
848     // decided by the DAO for Scammer Silver, but there will only be 1 season
849     // for Scammer Gold
850     uint256 public season = 0;
851 
852     // Track claimed tokens within a season
853     // IMPORTANT: The format of the mapping is:
854     // claimedForSeason[season][tokenId][claimed]
855     // There will only be one SGLD season but
856     // keeping this function here shows how it will
857     // work with SSLV (Scammer Silver)
858     mapping(uint256 => mapping(uint256 => bool)) public seasonClaimedByTokenId;
859 
860     constructor() Ownable() ERC20("Scammer Gold", "SGLD") {
861         // Transfer ownership to the sLoot DAO
862         // Ownable by OpenZeppelin automatically sets owner to msg.sender, but
863         // we're going to burn the contract guaranteeing a finite amount of SGLD
864         // Technically this means seasonality is not needed for this conetract, 
865         // but to allow function parity with the upcoming Scammer Silver contract  
866         // we are leaving these functions
867         transferOwnership(0x0000000000000000000000000000000000000000);
868         slootContract = IERC721Enumerable(slootContractAddress);
869     }
870 
871     /// @notice Claim Scammer Gold for a given sLoot ID
872     /// @param tokenId The tokenId of the sLoot NFT
873     function claimById(uint256 tokenId) external {
874         // Follow the Checks-Effects-Interactions pattern to prevent reentrancy
875         // attacks
876 
877         // Checks
878 
879         // Check that the msgSender owns the token that is being claimed
880         require(
881             _msgSender() == slootContract.ownerOf(tokenId),
882             "MUST_OWN_TOKEN_ID"
883         );
884 
885         // Further Checks, Effects, and Interactions are contained within the
886         // _claim() function
887         _claim(tokenId, _msgSender());
888     }
889 
890     /// @notice Claim Scammer Gold for all tokens owned by the sender
891     /// @notice This function will run out of gas if you have too much sLoot! If
892     /// this is a concern, you should use claimRangeForOwner and claim Scammer
893     /// Gold in batches.
894     function claimAllForOwner() external {
895         uint256 tokenBalanceOwner = slootContract.balanceOf(_msgSender());
896 
897         // Checks
898         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
899 
900         // i < tokenBalanceOwner because tokenBalanceOwner is 1-indexed
901         for (uint256 i = 0; i < tokenBalanceOwner; i++) {
902             // Further Checks, Effects, and Interactions are contained within
903             // the _claim() function
904             _claim(
905                 slootContract.tokenOfOwnerByIndex(_msgSender(), i),
906                 _msgSender()
907             );
908         }
909     }
910 
911     /// @notice Claim Scammer Gold for all tokens owned by the sender within a
912     /// given range
913     /// @notice This function is useful if you own too much sLoot to claim all at
914     /// once or if you want to leave some sLoot unclaimed. If you leave sLoot
915     /// unclaimed, however, you cannot claim it once the next season starts.
916     function claimRangeForOwner(uint256 ownerIndexStart, uint256 ownerIndexEnd)
917         external
918     {
919         uint256 tokenBalanceOwner = slootContract.balanceOf(_msgSender());
920 
921         // Checks
922         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
923 
924         // We use < for ownerIndexEnd and tokenBalanceOwner because
925         // tokenOfOwnerByIndex is 0-indexed while the token balance is 1-indexed
926         require(
927             ownerIndexStart >= 0 && ownerIndexEnd < tokenBalanceOwner,
928             "INDEX_OUT_OF_RANGE"
929         );
930 
931         // i <= ownerIndexEnd because ownerIndexEnd is 0-indexed
932         for (uint256 i = ownerIndexStart; i <= ownerIndexEnd; i++) {
933             // Further Checks, Effects, and Interactions are contained within
934             // the _claim() function
935             _claim(
936                 slootContract.tokenOfOwnerByIndex(_msgSender(), i),
937                 _msgSender()
938             );
939         }
940     }
941 
942     /// @dev Internal function to mint sLoot upon claiming
943     function _claim(uint256 tokenId, address tokenOwner) internal {
944         // Checks
945         // Check that the token ID is in range
946         // We use >= and <= to here because all of the token IDs are 0-indexed
947         require(
948             tokenId >= tokenIdStart && tokenId <= tokenIdEnd,
949             "TOKEN_ID_OUT_OF_RANGE"
950         );
951 
952         // Check that Scammer Gold have not already been claimed this season
953         // for a given tokenId
954         require(
955             !seasonClaimedByTokenId[season][tokenId],
956             "GOLD_CLAIMED_FOR_TOKEN_ID"
957         );
958 
959         // Effects
960 
961         // Mark that Scammer Gold has been claimed for this season for the
962         // given tokenId
963         // Since the contract owner will be sent to the null address on
964         // creation there will only be 1 season, but we are keeping this
965         // here so Scammer Silver can follow the model in the future
966         seasonClaimedByTokenId[season][tokenId] = true;
967 
968         // Interactions
969 
970         // Send Scammer Gold to the owner of the token ID
971         _mint(tokenOwner, scammerGoldPerTokenId);
972     }
973 
974 
975     //************************IMPORTANT*********************************/
976     // All functions after this point will be nonfunctioning due to the
977     // contract being sent to the null address and not having an owner
978     // they are only here to show how the future DAO will interact 
979     // with Scammer Silver at a later date
980     //************************IMPORTANT*********************************/
981     
982 
983     /// @notice Allows the DAO to mint new tokens for use within the sLoot
984     /// Ecosystem
985     /// @param amountDisplayValue The amount of sLoot to mint. This should be
986     /// input as the display value, not in raw decimals. If you want to mint
987     /// 100 sLoot, you should enter "100" rather than the value of 100 * 10^18.
988     function daoMint(uint256 amountDisplayValue) external onlyOwner {
989         _mint(owner(), amountDisplayValue * (10**decimals()));
990     }
991 
992     /// @notice Allows the DAO to set a new contract address for sLoot. This is
993     /// relevant in the event that sLoot migrates to a new contract.
994     /// @param slootContractAddress_ The new contract address for sLoot
995     function daoSetLootContractAddress(address slootContractAddress_)
996         external
997         onlyOwner
998     {
999         slootContractAddress = slootContractAddress_;
1000         slootContract = IERC721Enumerable(slootContractAddress);
1001     }
1002 
1003     /// @notice Allows the DAO to set the token IDs that are eligible to claim
1004     /// sLoot
1005     /// @param tokenIdStart_ The start of the eligible token range
1006     /// @param tokenIdEnd_ The end of the eligible token range
1007     /// @dev This is relevant in case a future sLoot contract has a different
1008     /// total supply of sLoot
1009     function daoSetTokenIdRange(uint256 tokenIdStart_, uint256 tokenIdEnd_)
1010         external
1011         onlyOwner
1012     {
1013         tokenIdStart = tokenIdStart_;
1014         tokenIdEnd = tokenIdEnd_;
1015     }
1016 
1017     /// @notice Allows the DAO to set a season for new Scammer Gold claims
1018     /// @param season_ The season to use for claiming sLoot
1019     function daoSetSeason(uint256 season_) public onlyOwner {
1020         season = season_;
1021     }
1022 
1023     /// @notice Allows the DAO to set the amount of Scammer Gold that is
1024     /// claimed per token ID
1025     /// @param scammerGoldDisplayValue The amount of sLoot a user can claim.
1026     /// This should be input as the display value, not in raw decimals. If you
1027     /// want to mint 100 sLoot, you should enter "100" rather than the value of
1028     /// 100 * 10^18.
1029     function daoSetScammerGoldPerTokenId(uint256 scammerGoldDisplayValue)
1030         public
1031         onlyOwner
1032     {
1033         scammerGoldPerTokenId = scammerGoldDisplayValue * (10**decimals());
1034     }
1035 
1036     /// @notice Allows the DAO to set the season and Scammer Gold per token ID
1037     /// in one transaction. This ensures that there is not a gap where a user
1038     /// can claim more Scammer Gold than others
1039     /// @param season_ The season to use for claiming sloot
1040     /// @param scammerGoldDisplayValue The amount of sLoot a user can claim.
1041     /// This should be input as the display value, not in raw decimals. If you
1042     /// want to mint 100 sLoot, you should enter "100" rather than the value of
1043     /// 100 * 10^18.
1044     /// @dev We would save a tiny amount of gas by modifying the season and
1045     /// scammerGold variables directly. It is better practice for security,
1046     /// however, to avoid repeating code. This function is so rarely used that
1047     /// it's not worth moving these values into their own internal function to
1048     /// skip the gas used on the modifier check.
1049     function daoSetSeasonAndScammerGoldPerTokenID(
1050         uint256 season_,
1051         uint256 scammerGoldDisplayValue
1052     ) external onlyOwner {
1053         daoSetSeason(season_);
1054         daoSetScammerGoldPerTokenId(scammerGoldDisplayValue);
1055     }
1056 }