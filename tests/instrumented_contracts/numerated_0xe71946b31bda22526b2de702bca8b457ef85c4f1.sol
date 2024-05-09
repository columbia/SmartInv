1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-04
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-09-01
7 */
8 
9 // SPDX-License-Identifier: UNLICENSED
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(
49         address indexed previousOwner,
50         address indexed newOwner
51     );
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _setOwner(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _setOwner(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(
92             newOwner != address(0),
93             "Ownable: new owner is the zero address"
94         );
95         _setOwner(newOwner);
96     }
97 
98     function _setOwner(address newOwner) private {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 /**
106  * @dev Interface of the ERC20 standard as defined in the EIP.
107  */
108 interface IERC20 {
109     /**
110      * @dev Returns the amount of tokens in existence.
111      */
112     function totalSupply() external view returns (uint256);
113 
114     /**
115      * @dev Returns the amount of tokens owned by `account`.
116      */
117     function balanceOf(address account) external view returns (uint256);
118 
119     /**
120      * @dev Moves `amount` tokens from the caller's account to `recipient`.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transfer(address recipient, uint256 amount)
127         external
128         returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender)
138         external
139         view
140         returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * IMPORTANT: Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to {approve}. `value` is the new allowance.
184      */
185     event Approval(
186         address indexed owner,
187         address indexed spender,
188         uint256 value
189     );
190 }
191 
192 /**
193  * @dev Interface for the optional metadata functions from the ERC20 standard.
194  *
195  * _Available since v4.1._
196  */
197 interface IERC20Metadata is IERC20 {
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() external view returns (string memory);
202 
203     /**
204      * @dev Returns the symbol of the token.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the decimals places of the token.
210      */
211     function decimals() external view returns (uint8);
212 }
213 
214 /**
215  * @dev Implementation of the {IERC20} interface.
216  *
217  * This implementation is agnostic to the way tokens are created. This means
218  * that a supply mechanism has to be added in a derived contract using {_mint}.
219  * For a generic mechanism see {ERC20PresetMinterPauser}.
220  *
221  * TIP: For a detailed writeup see our guide
222  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
223  * to implement supply mechanisms].
224  *
225  * We have followed general OpenZeppelin Contracts guidelines: functions revert
226  * instead returning `false` on failure. This behavior is nonetheless
227  * conventional and does not conflict with the expectations of ERC20
228  * applications.
229  *
230  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
231  * This allows applications to reconstruct the allowance for all accounts just
232  * by listening to said events. Other implementations of the EIP may not emit
233  * these events, as it isn't required by the specification.
234  *
235  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
236  * functions have been added to mitigate the well-known issues around setting
237  * allowances. See {IERC20-approve}.
238  */
239 contract ERC20 is Context, IERC20, IERC20Metadata {
240     mapping(address => uint256) private _balances;
241 
242     mapping(address => mapping(address => uint256)) private _allowances;
243 
244     uint256 private _totalSupply;
245 
246     string private _name;
247     string private _symbol;
248 
249     /**
250      * @dev Sets the values for {name} and {symbol}.
251      *
252      * The default value of {decimals} is 18. To select a different value for
253      * {decimals} you should overload it.
254      *
255      * All two of these values are immutable: they can only be set once during
256      * construction.
257      */
258     constructor(string memory name_, string memory symbol_) {
259         _name = name_;
260         _symbol = symbol_;
261     }
262 
263     /**
264      * @dev Returns the name of the token.
265      */
266     function name() public view virtual override returns (string memory) {
267         return _name;
268     }
269 
270     /**
271      * @dev Returns the symbol of the token, usually a shorter version of the
272      * name.
273      */
274     function symbol() public view virtual override returns (string memory) {
275         return _symbol;
276     }
277 
278     /**
279      * @dev Returns the number of decimals used to get its user representation.
280      * For example, if `decimals` equals `2`, a balance of `505` tokens should
281      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
282      *
283      * Tokens usually opt for a value of 18, imitating the relationship between
284      * Ether and Wei. This is the value {ERC20} uses, unless this function is
285      * overridden;
286      *
287      * NOTE: This information is only used for _display_ purposes: it in
288      * no way affects any of the arithmetic of the contract, including
289      * {IERC20-balanceOf} and {IERC20-transfer}.
290      */
291     function decimals() public view virtual override returns (uint8) {
292         return 18;
293     }
294 
295     /**
296      * @dev See {IERC20-totalSupply}.
297      */
298     function totalSupply() public view virtual override returns (uint256) {
299         return _totalSupply;
300     }
301 
302     /**
303      * @dev See {IERC20-balanceOf}.
304      */
305     function balanceOf(address account)
306         public
307         view
308         virtual
309         override
310         returns (uint256)
311     {
312         return _balances[account];
313     }
314 
315     /**
316      * @dev See {IERC20-transfer}.
317      *
318      * Requirements:
319      *
320      * - `recipient` cannot be the zero address.
321      * - the caller must have a balance of at least `amount`.
322      */
323     function transfer(address recipient, uint256 amount)
324         public
325         virtual
326         override
327         returns (bool)
328     {
329         _transfer(_msgSender(), recipient, amount);
330         return true;
331     }
332 
333     /**
334      * @dev See {IERC20-allowance}.
335      */
336     function allowance(address owner, address spender)
337         public
338         view
339         virtual
340         override
341         returns (uint256)
342     {
343         return _allowances[owner][spender];
344     }
345 
346     /**
347      * @dev See {IERC20-approve}.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      */
353     function approve(address spender, uint256 amount)
354         public
355         virtual
356         override
357         returns (bool)
358     {
359         _approve(_msgSender(), spender, amount);
360         return true;
361     }
362 
363     /**
364      * @dev See {IERC20-transferFrom}.
365      *
366      * Emits an {Approval} event indicating the updated allowance. This is not
367      * required by the EIP. See the note at the beginning of {ERC20}.
368      *
369      * Requirements:
370      *
371      * - `sender` and `recipient` cannot be the zero address.
372      * - `sender` must have a balance of at least `amount`.
373      * - the caller must have allowance for ``sender``'s tokens of at least
374      * `amount`.
375      */
376     function transferFrom(
377         address sender,
378         address recipient,
379         uint256 amount
380     ) public virtual override returns (bool) {
381         _transfer(sender, recipient, amount);
382 
383         uint256 currentAllowance = _allowances[sender][_msgSender()];
384         require(
385             currentAllowance >= amount,
386             "ERC20: transfer amount exceeds allowance"
387         );
388         unchecked {
389             _approve(sender, _msgSender(), currentAllowance - amount);
390         }
391 
392         return true;
393     }
394 
395     /**
396      * @dev Atomically increases the allowance granted to `spender` by the caller.
397      *
398      * This is an alternative to {approve} that can be used as a mitigation for
399      * problems described in {IERC20-approve}.
400      *
401      * Emits an {Approval} event indicating the updated allowance.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      */
407     function increaseAllowance(address spender, uint256 addedValue)
408         public
409         virtual
410         returns (bool)
411     {
412         _approve(
413             _msgSender(),
414             spender,
415             _allowances[_msgSender()][spender] + addedValue
416         );
417         return true;
418     }
419 
420     /**
421      * @dev Atomically decreases the allowance granted to `spender` by the caller.
422      *
423      * This is an alternative to {approve} that can be used as a mitigation for
424      * problems described in {IERC20-approve}.
425      *
426      * Emits an {Approval} event indicating the updated allowance.
427      *
428      * Requirements:
429      *
430      * - `spender` cannot be the zero address.
431      * - `spender` must have allowance for the caller of at least
432      * `subtractedValue`.
433      */
434     function decreaseAllowance(address spender, uint256 subtractedValue)
435         public
436         virtual
437         returns (bool)
438     {
439         uint256 currentAllowance = _allowances[_msgSender()][spender];
440         require(
441             currentAllowance >= subtractedValue,
442             "ERC20: decreased allowance below zero"
443         );
444         unchecked {
445             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
446         }
447 
448         return true;
449     }
450 
451     /**
452      * @dev Moves `amount` of tokens from `sender` to `recipient`.
453      *
454      * This internal function is equivalent to {transfer}, and can be used to
455      * e.g. implement automatic token fees, slashing mechanisms, etc.
456      *
457      * Emits a {Transfer} event.
458      *
459      * Requirements:
460      *
461      * - `sender` cannot be the zero address.
462      * - `recipient` cannot be the zero address.
463      * - `sender` must have a balance of at least `amount`.
464      */
465     function _transfer(
466         address sender,
467         address recipient,
468         uint256 amount
469     ) internal virtual {
470         require(sender != address(0), "ERC20: transfer from the zero address");
471         require(recipient != address(0), "ERC20: transfer to the zero address");
472 
473         _beforeTokenTransfer(sender, recipient, amount);
474 
475         uint256 senderBalance = _balances[sender];
476         require(
477             senderBalance >= amount,
478             "ERC20: transfer amount exceeds balance"
479         );
480         unchecked {
481             _balances[sender] = senderBalance - amount;
482         }
483         _balances[recipient] += amount;
484 
485         emit Transfer(sender, recipient, amount);
486 
487         _afterTokenTransfer(sender, recipient, amount);
488     }
489 
490     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
491      * the total supply.
492      *
493      * Emits a {Transfer} event with `from` set to the zero address.
494      *
495      * Requirements:
496      *
497      * - `account` cannot be the zero address.
498      */
499     function _mint(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: mint to the zero address");
501 
502         _beforeTokenTransfer(address(0), account, amount);
503 
504         _totalSupply += amount;
505         _balances[account] += amount;
506         emit Transfer(address(0), account, amount);
507 
508         _afterTokenTransfer(address(0), account, amount);
509     }
510 
511     /**
512      * @dev Destroys `amount` tokens from `account`, reducing the
513      * total supply.
514      *
515      * Emits a {Transfer} event with `to` set to the zero address.
516      *
517      * Requirements:
518      *
519      * - `account` cannot be the zero address.
520      * - `account` must have at least `amount` tokens.
521      */
522     function _burn(address account, uint256 amount) internal virtual {
523         require(account != address(0), "ERC20: burn from the zero address");
524 
525         _beforeTokenTransfer(account, address(0), amount);
526 
527         uint256 accountBalance = _balances[account];
528         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
529         unchecked {
530             _balances[account] = accountBalance - amount;
531         }
532         _totalSupply -= amount;
533 
534         emit Transfer(account, address(0), amount);
535 
536         _afterTokenTransfer(account, address(0), amount);
537     }
538 
539     /**
540      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
541      *
542      * This internal function is equivalent to `approve`, and can be used to
543      * e.g. set automatic allowances for certain subsystems, etc.
544      *
545      * Emits an {Approval} event.
546      *
547      * Requirements:
548      *
549      * - `owner` cannot be the zero address.
550      * - `spender` cannot be the zero address.
551      */
552     function _approve(
553         address owner,
554         address spender,
555         uint256 amount
556     ) internal virtual {
557         require(owner != address(0), "ERC20: approve from the zero address");
558         require(spender != address(0), "ERC20: approve to the zero address");
559 
560         _allowances[owner][spender] = amount;
561         emit Approval(owner, spender, amount);
562     }
563 
564     /**
565      * @dev Hook that is called before any transfer of tokens. This includes
566      * minting and burning.
567      *
568      * Calling conditions:
569      *
570      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
571      * will be transferred to `to`.
572      * - when `from` is zero, `amount` tokens will be minted for `to`.
573      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
574      * - `from` and `to` are never both zero.
575      *
576      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
577      */
578     function _beforeTokenTransfer(
579         address from,
580         address to,
581         uint256 amount
582     ) internal virtual {}
583 
584     /**
585      * @dev Hook that is called after any transfer of tokens. This includes
586      * minting and burning.
587      *
588      * Calling conditions:
589      *
590      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
591      * has been transferred to `to`.
592      * - when `from` is zero, `amount` tokens have been minted for `to`.
593      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
594      * - `from` and `to` are never both zero.
595      *
596      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
597      */
598     function _afterTokenTransfer(
599         address from,
600         address to,
601         uint256 amount
602     ) internal virtual {}
603 }
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Interface of the ERC165 standard, as defined in the
609  * https://eips.ethereum.org/EIPS/eip-165[EIP].
610  *
611  * Implementers can declare support of contract interfaces, which can then be
612  * queried by others ({ERC165Checker}).
613  *
614  * For an implementation, see {ERC165}.
615  */
616 interface IERC165 {
617     /**
618      * @dev Returns true if this contract implements the interface defined by
619      * `interfaceId`. See the corresponding
620      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
621      * to learn more about how these ids are created.
622      *
623      * This function call must use less than 30 000 gas.
624      */
625     function supportsInterface(bytes4 interfaceId) external view returns (bool);
626 }
627 
628 /**
629  * @dev Implementation of the {IERC165} interface.
630  *
631  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
632  * for the additional interface id that will be supported. For example:
633  *
634  * ```solidity
635  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
636  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
637  * }
638  * ```
639  *
640  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
641  */
642 abstract contract ERC165 is IERC165 {
643     /**
644      * @dev See {IERC165-supportsInterface}.
645      */
646     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
647         return interfaceId == type(IERC165).interfaceId;
648     }
649 }
650 
651 /**
652  * @dev Required interface of an ERC721 compliant contract.
653  */
654 interface IERC721 is IERC165 {
655     /**
656      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
657      */
658     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
659 
660     /**
661      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
662      */
663     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
664 
665     /**
666      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
667      */
668     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
669 
670     /**
671      * @dev Returns the number of tokens in ``owner``'s account.
672      */
673     function balanceOf(address owner) external view returns (uint256 balance);
674 
675     /**
676      * @dev Returns the owner of the `tokenId` token.
677      *
678      * Requirements:
679      *
680      * - `tokenId` must exist.
681      */
682     function ownerOf(uint256 tokenId) external view returns (address owner);
683 
684     /**
685      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
686      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
687      *
688      * Requirements:
689      *
690      * - `from` cannot be the zero address.
691      * - `to` cannot be the zero address.
692      * - `tokenId` token must exist and be owned by `from`.
693      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
694      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
695      *
696      * Emits a {Transfer} event.
697      */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 tokenId
702     ) external;
703 
704     /**
705      * @dev Transfers `tokenId` token from `from` to `to`.
706      *
707      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
708      *
709      * Requirements:
710      *
711      * - `from` cannot be the zero address.
712      * - `to` cannot be the zero address.
713      * - `tokenId` token must be owned by `from`.
714      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
715      *
716      * Emits a {Transfer} event.
717      */
718     function transferFrom(
719         address from,
720         address to,
721         uint256 tokenId
722     ) external;
723 
724     /**
725      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
726      * The approval is cleared when the token is transferred.
727      *
728      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
729      *
730      * Requirements:
731      *
732      * - The caller must own the token or be an approved operator.
733      * - `tokenId` must exist.
734      *
735      * Emits an {Approval} event.
736      */
737     function approve(address to, uint256 tokenId) external;
738 
739     /**
740      * @dev Returns the account approved for `tokenId` token.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must exist.
745      */
746     function getApproved(uint256 tokenId) external view returns (address operator);
747 
748     /**
749      * @dev Approve or remove `operator` as an operator for the caller.
750      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
751      *
752      * Requirements:
753      *
754      * - The `operator` cannot be the caller.
755      *
756      * Emits an {ApprovalForAll} event.
757      */
758     function setApprovalForAll(address operator, bool _approved) external;
759 
760     /**
761      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
762      *
763      * See {setApprovalForAll}
764      */
765     function isApprovedForAll(address owner, address operator) external view returns (bool);
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`.
769      *
770      * Requirements:
771      *
772      * - `from` cannot be the zero address.
773      * - `to` cannot be the zero address.
774      * - `tokenId` token must exist and be owned by `from`.
775      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes calldata data
785     ) external;
786 }
787 
788 
789 /**
790  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
791  * @dev See https://eips.ethereum.org/EIPS/eip-721
792  */
793 interface IERC721Enumerable is IERC721 {
794     /**
795      * @dev Returns the total amount of tokens stored by the contract.
796      */
797     function totalSupply() external view returns (uint256);
798 
799     /**
800      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
801      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
802      */
803     function tokenOfOwnerByIndex(address owner, uint256 index)
804         external
805         view
806         returns (uint256 tokenId);
807 
808     /**
809      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
810      * Use along with {totalSupply} to enumerate all tokens.
811      */
812     function tokenByIndex(uint256 index) external view returns (uint256);
813 }
814 
815 /// @title Neuro Credits for gear holders!
816 /// Original author: Will Papper <https://twitter.com/WillPapper>
817 /// @notice This contract mints Neuro Credits for gear holders and provides
818 /// administrative functions to the gear DAO. It allows:
819 /// * gear holders to claim Neuro Credits
820 /// * A DAO to set seasons for new opportunities to claim Neuro Credits
821 /// * A DAO to mint Neuro Credits for use within the gear ecosystem
822 /// @custom:unaudited This contract has not been audited. Use at your own risk.
823 contract NeuroCredit is Context, Ownable, ERC20 {
824     // gear contract is available at https://etherscan.io/address/0xff796cbbe32b2150a4585a3791cadb213d0f35a3
825     address public gearContractAddress =
826         0xFf796cbbe32B2150A4585a3791CADb213D0F35A3;
827     IERC721Enumerable public gearContract;
828 
829     // Give out 25,000 Neuro Credit for every gear Bag that a user holds
830     uint256 public NeuroCreditPerTokenId = 25000 * (10**decimals());
831 
832     // tokenIdStart of 1 is based on the following lines in the gear contract:
833     /** 
834     function claim(uint256 tokenId) public nonReentrant {
835         require(tokenId > 0 && tokenId < 7778, "Token ID invalid");
836         _safeMint(_msgSender(), tokenId);
837     }
838     */
839     uint256 public tokenIdStart = 1;
840 
841     // tokenIdEnd of 7777 is based on the following lines in the gear contract:
842     /**
843         function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
844         require(tokenId > 7777 && tokenId < 8001, "Token ID invalid");
845         _safeMint(owner(), tokenId);
846     }
847     */
848     uint256 public tokenIdEnd = 7777;
849 
850     // Seasons are used to allow users to claim tokens regularly. Seasons are
851     // decided by the DAO.
852     uint256 public season = 0;
853 
854     // Track claimed tokens within a season
855     // IMPORTANT: The format of the mapping is:
856     // claimedForSeason[season][tokenId][claimed]
857     mapping(uint256 => mapping(uint256 => bool)) public seasonClaimedByTokenId;
858 
859     constructor() Ownable() ERC20("Neuro Credits", "NEURO") {
860         // Transfer ownership to the gear DAO
861         // Ownable by OpenZeppelin automatically sets owner to msg.sender, but
862         // we're going to be using a separate wallet for deployment
863         transferOwnership(_msgSender());
864         gearContract = IERC721Enumerable(gearContractAddress);
865     }
866 
867     /// @notice Claim Neuro Credits for a given gear ID
868     /// @param tokenId The tokenId of the gear NFT
869     function claimById(uint256 tokenId) external {
870         // Follow the Checks-Effects-Interactions pattern to prevent reentrancy
871         // attacks
872 
873         // Checks
874 
875         // Check that the msgSender owns the token that is being claimed
876         require(
877             _msgSender() == gearContract.ownerOf(tokenId),
878             "MUST_OWN_TOKEN_ID"
879         );
880 
881         // Further Checks, Effects, and Interactions are contained within the
882         // _claim() function
883         _claim(tokenId, _msgSender());
884     }
885 
886     /// @notice Claim Neuro Credits for all tokens owned by the sender
887     /// @notice This function will run out of gas if you have too much gear! If
888     /// this is a concern, you should use claimRangeForOwner and claim Neuro
889     /// Credits in batches.
890     function claimAllForOwner() external {
891         uint256 tokenBalanceOwner = gearContract.balanceOf(_msgSender());
892 
893         // Checks
894         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
895 
896         // i < tokenBalanceOwner because tokenBalanceOwner is 1-indexed
897         for (uint256 i = 0; i < tokenBalanceOwner; i++) {
898             // Further Checks, Effects, and Interactions are contained within
899             // the _claim() function
900             _claim(
901                 gearContract.tokenOfOwnerByIndex(_msgSender(), i),
902                 _msgSender()
903             );
904         }
905     }
906 
907     /// @notice Claim Neuro Credits for all tokens owned by the sender within a
908     /// given range
909     /// @notice This function is useful if you own too much gear to claim all at
910     /// once or if you want to leave some gear unclaimed. If you leave gear
911     /// unclaimed, however, you cannot claim it once the next season starts.
912     function claimRangeForOwner(uint256 ownerIndexStart, uint256 ownerIndexEnd)
913         external
914     {
915         uint256 tokenBalanceOwner = gearContract.balanceOf(_msgSender());
916 
917         // Checks
918         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
919 
920         // We use < for ownerIndexEnd and tokenBalanceOwner because
921         // tokenOfOwnerByIndex is 0-indexed while the token balance is 1-indexed
922         require(
923             ownerIndexStart >= 0 && ownerIndexEnd < tokenBalanceOwner,
924             "INDEX_OUT_OF_RANGE"
925         );
926 
927         // i <= ownerIndexEnd because ownerIndexEnd is 0-indexed
928         for (uint256 i = ownerIndexStart; i <= ownerIndexEnd; i++) {
929             // Further Checks, Effects, and Interactions are contained within
930             // the _claim() function
931             _claim(
932                 gearContract.tokenOfOwnerByIndex(_msgSender(), i),
933                 _msgSender()
934             );
935         }
936     }
937 
938     /// @dev Internal function to mint gear upon claiming
939     function _claim(uint256 tokenId, address tokenOwner) internal {
940         // Checks
941         // Check that the token ID is in range
942         // We use >= and <= to here because all of the token IDs are 0-indexed
943         require(
944             tokenId >= tokenIdStart && tokenId <= tokenIdEnd,
945             "TOKEN_ID_OUT_OF_RANGE"
946         );
947 
948         // Check that Neuro Credits have not already been claimed this season
949         // for a given tokenId
950         require(
951             !seasonClaimedByTokenId[season][tokenId],
952             "CREDIT_CLAIMED_FOR_TOKEN_ID"
953         );
954 
955         // Effects
956 
957         // Mark that Neuro Credits has been claimed for this season for the
958         // given tokenId
959         seasonClaimedByTokenId[season][tokenId] = true;
960 
961         // Interactions
962 
963         // Send Neuro Credits to the owner of the token ID
964         _mint(tokenOwner, NeuroCreditPerTokenId);
965     }
966 
967     /// @notice Allows the DAO to mint new tokens for use within the gear
968     /// Ecosystem
969     /// @param amountDisplayValue The amount of gear to mint. This should be
970     /// input as the display value, not in raw decimals. If you want to mint
971     /// 100 gear, you should enter "100" rather than the value of 100 * 10^18.
972     function daoMint(uint256 amountDisplayValue) external onlyOwner {
973         _mint(owner(), amountDisplayValue * (10**decimals()));
974     }
975 
976     /// @notice Allows the DAO to set a new contract address for gear. This is
977     /// relevant in the event that gear migrates to a new contract.
978     /// @param gearContractAddress_ The new contract address for gear
979     function daoSetgearContractAddress(address gearContractAddress_)
980         external
981         onlyOwner
982     {
983         gearContractAddress = gearContractAddress_;
984         gearContract = IERC721Enumerable(gearContractAddress);
985     }
986 
987     /// @notice Allows the DAO to set the token IDs that are eligible to claim
988     /// gear
989     /// @param tokenIdStart_ The start of the eligible token range
990     /// @param tokenIdEnd_ The end of the eligible token range
991     /// @dev This is relevant in case a future gear contract has a different
992     /// total supply of gear
993     function daoSetTokenIdRange(uint256 tokenIdStart_, uint256 tokenIdEnd_)
994         external
995         onlyOwner
996     {
997         tokenIdStart = tokenIdStart_;
998         tokenIdEnd = tokenIdEnd_;
999     }
1000 
1001     /// @notice Allows the DAO to set a season for new Neuro Credits claims
1002     /// @param season_ The season to use for claiming gear
1003     function daoSetSeason(uint256 season_) public onlyOwner {
1004         season = season_;
1005     }
1006 
1007     /// @notice Allows the DAO to set the amount of Neuro Credits that is
1008     /// claimed per token ID
1009     /// @param NeuroCreditDisplayValue The amount of gear a user can claim.
1010     /// This should be input as the display value, not in raw decimals. If you
1011     /// want to mint 100 gear, you should enter "100" rather than the value of
1012     /// 100 * 10^18.
1013     function daoSetNeuroCreditPerTokenId(uint256 NeuroCreditDisplayValue)
1014         public
1015         onlyOwner
1016     {
1017         NeuroCreditPerTokenId = NeuroCreditDisplayValue * (10**decimals());
1018     }
1019 
1020     /// @notice Allows the DAO to set the season and Neuro Credits per token ID
1021     /// in one transaction. This ensures that there is not a gap where a user
1022     /// can claim more Neuro Credits than others
1023     /// @param season_ The season to use for claiming gear
1024     /// @param NeuroCreditDisplayValue The amount of gear a user can claim.
1025     /// This should be input as the display value, not in raw decimals. If you
1026     /// want to mint 100 gear, you should enter "100" rather than the value of
1027     /// 100 * 10^18.
1028     /// @dev We would save a tiny amount of gas by modifying the season and
1029     /// NeuroCredit variables directly. It is better practice for security,
1030     /// however, to avoid repeating code. This function is so rarely used that
1031     /// it's not worth moving these values into their own internal function to
1032     /// skip the gas used on the modifier check.
1033     function daoSetSeasonAndNeuroCreditPerTokenID(
1034         uint256 season_,
1035         uint256 NeuroCreditDisplayValue
1036     ) external onlyOwner {
1037         daoSetSeason(season_);
1038         daoSetNeuroCreditPerTokenId(NeuroCreditDisplayValue);
1039     }
1040 }