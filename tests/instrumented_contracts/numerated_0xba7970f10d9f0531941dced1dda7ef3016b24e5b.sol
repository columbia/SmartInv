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
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(
88             newOwner != address(0),
89             "Ownable: new owner is the zero address"
90         );
91         _setOwner(newOwner);
92     }
93 
94     function _setOwner(address newOwner) private {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 /**
102  * @dev Interface of the ERC20 standard as defined in the EIP.
103  */
104 interface IERC20 {
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     /**
111      * @dev Returns the amount of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114 
115     /**
116      * @dev Moves `amount` tokens from the caller's account to `recipient`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transfer(address recipient, uint256 amount)
123         external
124         returns (bool);
125 
126     /**
127      * @dev Returns the remaining number of tokens that `spender` will be
128      * allowed to spend on behalf of `owner` through {transferFrom}. This is
129      * zero by default.
130      *
131      * This value changes when {approve} or {transferFrom} are called.
132      */
133     function allowance(address owner, address spender)
134         external
135         view
136         returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to {approve}. `value` is the new allowance.
180      */
181     event Approval(
182         address indexed owner,
183         address indexed spender,
184         uint256 value
185     );
186 }
187 
188 /**
189  * @dev Interface for the optional metadata functions from the ERC20 standard.
190  *
191  * _Available since v4.1._
192  */
193 interface IERC20Metadata is IERC20 {
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() external view returns (string memory);
198 
199     /**
200      * @dev Returns the symbol of the token.
201      */
202     function symbol() external view returns (string memory);
203 
204     /**
205      * @dev Returns the decimals places of the token.
206      */
207     function decimals() external view returns (uint8);
208 }
209 
210 /**
211  * @dev Implementation of the {IERC20} interface.
212  *
213  * This implementation is agnostic to the way tokens are created. This means
214  * that a supply mechanism has to be added in a derived contract using {_mint}.
215  * For a generic mechanism see {ERC20PresetMinterPauser}.
216  *
217  * TIP: For a detailed writeup see our guide
218  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
219  * to implement supply mechanisms].
220  *
221  * We have followed general OpenZeppelin Contracts guidelines: functions revert
222  * instead returning `false` on failure. This behavior is nonetheless
223  * conventional and does not conflict with the expectations of ERC20
224  * applications.
225  *
226  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
227  * This allows applications to reconstruct the allowance for all accounts just
228  * by listening to said events. Other implementations of the EIP may not emit
229  * these events, as it isn't required by the specification.
230  *
231  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
232  * functions have been added to mitigate the well-known issues around setting
233  * allowances. See {IERC20-approve}.
234  */
235 contract ERC20 is Context, IERC20, IERC20Metadata {
236     mapping(address => uint256) private _balances;
237 
238     mapping(address => mapping(address => uint256)) private _allowances;
239 
240     uint256 private _totalSupply;
241 
242     string private _name;
243     string private _symbol;
244 
245     /**
246      * @dev Sets the values for {name} and {symbol}.
247      *
248      * The default value of {decimals} is 18. To select a different value for
249      * {decimals} you should overload it.
250      *
251      * All two of these values are immutable: they can only be set once during
252      * construction.
253      */
254     constructor(string memory name_, string memory symbol_) {
255         _name = name_;
256         _symbol = symbol_;
257     }
258 
259     /**
260      * @dev Returns the name of the token.
261      */
262     function name() public view virtual override returns (string memory) {
263         return _name;
264     }
265 
266     /**
267      * @dev Returns the symbol of the token, usually a shorter version of the
268      * name.
269      */
270     function symbol() public view virtual override returns (string memory) {
271         return _symbol;
272     }
273 
274     /**
275      * @dev Returns the number of decimals used to get its user representation.
276      * For example, if `decimals` equals `2`, a balance of `505` tokens should
277      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
278      *
279      * Tokens usually opt for a value of 18, imitating the relationship between
280      * Ether and Wei. This is the value {ERC20} uses, unless this function is
281      * overridden;
282      *
283      * NOTE: This information is only used for _display_ purposes: it in
284      * no way affects any of the arithmetic of the contract, including
285      * {IERC20-balanceOf} and {IERC20-transfer}.
286      */
287     function decimals() public view virtual override returns (uint8) {
288         return 18;
289     }
290 
291     /**
292      * @dev See {IERC20-totalSupply}.
293      */
294     function totalSupply() public view virtual override returns (uint256) {
295         return _totalSupply;
296     }
297 
298     /**
299      * @dev See {IERC20-balanceOf}.
300      */
301     function balanceOf(address account)
302         public
303         view
304         virtual
305         override
306         returns (uint256)
307     {
308         return _balances[account];
309     }
310 
311     /**
312      * @dev See {IERC20-transfer}.
313      *
314      * Requirements:
315      *
316      * - `recipient` cannot be the zero address.
317      * - the caller must have a balance of at least `amount`.
318      */
319     function transfer(address recipient, uint256 amount)
320         public
321         virtual
322         override
323         returns (bool)
324     {
325         _transfer(_msgSender(), recipient, amount);
326         return true;
327     }
328 
329     /**
330      * @dev See {IERC20-allowance}.
331      */
332     function allowance(address owner, address spender)
333         public
334         view
335         virtual
336         override
337         returns (uint256)
338     {
339         return _allowances[owner][spender];
340     }
341 
342     /**
343      * @dev See {IERC20-approve}.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      */
349     function approve(address spender, uint256 amount)
350         public
351         virtual
352         override
353         returns (bool)
354     {
355         _approve(_msgSender(), spender, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-transferFrom}.
361      *
362      * Emits an {Approval} event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of {ERC20}.
364      *
365      * Requirements:
366      *
367      * - `sender` and `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      * - the caller must have allowance for ``sender``'s tokens of at least
370      * `amount`.
371      */
372     function transferFrom(
373         address sender,
374         address recipient,
375         uint256 amount
376     ) public virtual override returns (bool) {
377         _transfer(sender, recipient, amount);
378 
379         uint256 currentAllowance = _allowances[sender][_msgSender()];
380         require(
381             currentAllowance >= amount,
382             "ERC20: transfer amount exceeds allowance"
383         );
384         unchecked {
385             _approve(sender, _msgSender(), currentAllowance - amount);
386         }
387 
388         return true;
389     }
390 
391     /**
392      * @dev Atomically increases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to {approve} that can be used as a mitigation for
395      * problems described in {IERC20-approve}.
396      *
397      * Emits an {Approval} event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      */
403     function increaseAllowance(address spender, uint256 addedValue)
404         public
405         virtual
406         returns (bool)
407     {
408         _approve(
409             _msgSender(),
410             spender,
411             _allowances[_msgSender()][spender] + addedValue
412         );
413         return true;
414     }
415 
416     /**
417      * @dev Atomically decreases the allowance granted to `spender` by the caller.
418      *
419      * This is an alternative to {approve} that can be used as a mitigation for
420      * problems described in {IERC20-approve}.
421      *
422      * Emits an {Approval} event indicating the updated allowance.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      * - `spender` must have allowance for the caller of at least
428      * `subtractedValue`.
429      */
430     function decreaseAllowance(address spender, uint256 subtractedValue)
431         public
432         virtual
433         returns (bool)
434     {
435         uint256 currentAllowance = _allowances[_msgSender()][spender];
436         require(
437             currentAllowance >= subtractedValue,
438             "ERC20: decreased allowance below zero"
439         );
440         unchecked {
441             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
442         }
443 
444         return true;
445     }
446 
447     /**
448      * @dev Moves `amount` of tokens from `sender` to `recipient`.
449      *
450      * This internal function is equivalent to {transfer}, and can be used to
451      * e.g. implement automatic token fees, slashing mechanisms, etc.
452      *
453      * Emits a {Transfer} event.
454      *
455      * Requirements:
456      *
457      * - `sender` cannot be the zero address.
458      * - `recipient` cannot be the zero address.
459      * - `sender` must have a balance of at least `amount`.
460      */
461     function _transfer(
462         address sender,
463         address recipient,
464         uint256 amount
465     ) internal virtual {
466         require(sender != address(0), "ERC20: transfer from the zero address");
467         require(recipient != address(0), "ERC20: transfer to the zero address");
468 
469         _beforeTokenTransfer(sender, recipient, amount);
470 
471         uint256 senderBalance = _balances[sender];
472         require(
473             senderBalance >= amount,
474             "ERC20: transfer amount exceeds balance"
475         );
476         unchecked {
477             _balances[sender] = senderBalance - amount;
478         }
479         _balances[recipient] += amount;
480 
481         emit Transfer(sender, recipient, amount);
482 
483         _afterTokenTransfer(sender, recipient, amount);
484     }
485 
486     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
487      * the total supply.
488      *
489      * Emits a {Transfer} event with `from` set to the zero address.
490      *
491      * Requirements:
492      *
493      * - `account` cannot be the zero address.
494      */
495     function _mint(address account, uint256 amount) internal virtual {
496         require(account != address(0), "ERC20: mint to the zero address");
497 
498         _beforeTokenTransfer(address(0), account, amount);
499 
500         _totalSupply += amount;
501         _balances[account] += amount;
502         emit Transfer(address(0), account, amount);
503 
504         _afterTokenTransfer(address(0), account, amount);
505     }
506 
507     /**
508      * @dev Destroys `amount` tokens from `account`, reducing the
509      * total supply.
510      *
511      * Emits a {Transfer} event with `to` set to the zero address.
512      *
513      * Requirements:
514      *
515      * - `account` cannot be the zero address.
516      * - `account` must have at least `amount` tokens.
517      */
518     function _burn(address account, uint256 amount) internal virtual {
519         require(account != address(0), "ERC20: burn from the zero address");
520 
521         _beforeTokenTransfer(account, address(0), amount);
522 
523         uint256 accountBalance = _balances[account];
524         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
525         unchecked {
526             _balances[account] = accountBalance - amount;
527         }
528         _totalSupply -= amount;
529 
530         emit Transfer(account, address(0), amount);
531 
532         _afterTokenTransfer(account, address(0), amount);
533     }
534 
535     /**
536      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
537      *
538      * This internal function is equivalent to `approve`, and can be used to
539      * e.g. set automatic allowances for certain subsystems, etc.
540      *
541      * Emits an {Approval} event.
542      *
543      * Requirements:
544      *
545      * - `owner` cannot be the zero address.
546      * - `spender` cannot be the zero address.
547      */
548     function _approve(
549         address owner,
550         address spender,
551         uint256 amount
552     ) internal virtual {
553         require(owner != address(0), "ERC20: approve from the zero address");
554         require(spender != address(0), "ERC20: approve to the zero address");
555 
556         _allowances[owner][spender] = amount;
557         emit Approval(owner, spender, amount);
558     }
559 
560     /**
561      * @dev Hook that is called before any transfer of tokens. This includes
562      * minting and burning.
563      *
564      * Calling conditions:
565      *
566      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
567      * will be transferred to `to`.
568      * - when `from` is zero, `amount` tokens will be minted for `to`.
569      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
570      * - `from` and `to` are never both zero.
571      *
572      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
573      */
574     function _beforeTokenTransfer(
575         address from,
576         address to,
577         uint256 amount
578     ) internal virtual {}
579 
580     /**
581      * @dev Hook that is called after any transfer of tokens. This includes
582      * minting and burning.
583      *
584      * Calling conditions:
585      *
586      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
587      * has been transferred to `to`.
588      * - when `from` is zero, `amount` tokens have been minted for `to`.
589      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
590      * - `from` and `to` are never both zero.
591      *
592      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
593      */
594     function _afterTokenTransfer(
595         address from,
596         address to,
597         uint256 amount
598     ) internal virtual {}
599 }
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @dev Interface of the ERC165 standard, as defined in the
605  * https://eips.ethereum.org/EIPS/eip-165[EIP].
606  *
607  * Implementers can declare support of contract interfaces, which can then be
608  * queried by others ({ERC165Checker}).
609  *
610  * For an implementation, see {ERC165}.
611  */
612 interface IERC165 {
613     /**
614      * @dev Returns true if this contract implements the interface defined by
615      * `interfaceId`. See the corresponding
616      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
617      * to learn more about how these ids are created.
618      *
619      * This function call must use less than 30 000 gas.
620      */
621     function supportsInterface(bytes4 interfaceId) external view returns (bool);
622 }
623 
624 /**
625  * @dev Implementation of the {IERC165} interface.
626  *
627  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
628  * for the additional interface id that will be supported. For example:
629  *
630  * ```solidity
631  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
632  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
633  * }
634  * ```
635  *
636  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
637  */
638 abstract contract ERC165 is IERC165 {
639     /**
640      * @dev See {IERC165-supportsInterface}.
641      */
642     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
643         return interfaceId == type(IERC165).interfaceId;
644     }
645 }
646 
647 /**
648  * @dev Required interface of an ERC721 compliant contract.
649  */
650 interface IERC721 is IERC165 {
651     /**
652      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
653      */
654     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
655 
656     /**
657      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
658      */
659     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
660 
661     /**
662      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
663      */
664     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
665 
666     /**
667      * @dev Returns the number of tokens in ``owner``'s account.
668      */
669     function balanceOf(address owner) external view returns (uint256 balance);
670 
671     /**
672      * @dev Returns the owner of the `tokenId` token.
673      *
674      * Requirements:
675      *
676      * - `tokenId` must exist.
677      */
678     function ownerOf(uint256 tokenId) external view returns (address owner);
679 
680     /**
681      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
682      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must exist and be owned by `from`.
689      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
690      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
691      *
692      * Emits a {Transfer} event.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) external;
699 
700     /**
701      * @dev Transfers `tokenId` token from `from` to `to`.
702      *
703      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must be owned by `from`.
710      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
711      *
712      * Emits a {Transfer} event.
713      */
714     function transferFrom(
715         address from,
716         address to,
717         uint256 tokenId
718     ) external;
719 
720     /**
721      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
722      * The approval is cleared when the token is transferred.
723      *
724      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
725      *
726      * Requirements:
727      *
728      * - The caller must own the token or be an approved operator.
729      * - `tokenId` must exist.
730      *
731      * Emits an {Approval} event.
732      */
733     function approve(address to, uint256 tokenId) external;
734 
735     /**
736      * @dev Returns the account approved for `tokenId` token.
737      *
738      * Requirements:
739      *
740      * - `tokenId` must exist.
741      */
742     function getApproved(uint256 tokenId) external view returns (address operator);
743 
744     /**
745      * @dev Approve or remove `operator` as an operator for the caller.
746      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
747      *
748      * Requirements:
749      *
750      * - The `operator` cannot be the caller.
751      *
752      * Emits an {ApprovalForAll} event.
753      */
754     function setApprovalForAll(address operator, bool _approved) external;
755 
756     /**
757      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
758      *
759      * See {setApprovalForAll}
760      */
761     function isApprovedForAll(address owner, address operator) external view returns (bool);
762 
763     /**
764      * @dev Safely transfers `tokenId` token from `from` to `to`.
765      *
766      * Requirements:
767      *
768      * - `from` cannot be the zero address.
769      * - `to` cannot be the zero address.
770      * - `tokenId` token must exist and be owned by `from`.
771      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
772      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
773      *
774      * Emits a {Transfer} event.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId,
780         bytes calldata data
781     ) external;
782 }
783 
784 
785 /**
786  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
787  * @dev See https://eips.ethereum.org/EIPS/eip-721
788  */
789 interface IERC721Enumerable is IERC721 {
790     /**
791      * @dev Returns the total amount of tokens stored by the contract.
792      */
793     function totalSupply() external view returns (uint256);
794 
795     /**
796      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
797      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
798      */
799     function tokenOfOwnerByIndex(address owner, uint256 index)
800         external
801         view
802         returns (uint256 tokenId);
803 
804     /**
805      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
806      * Use along with {totalSupply} to enumerate all tokens.
807      */
808     function tokenByIndex(uint256 index) external view returns (uint256);
809 }
810 
811 /// @title Based Gold for bloot holders!
812 /// Original author: Will Papper <https://twitter.com/WillPapper>
813 /// @notice This contract mints Based Gold for bloot holders and provides
814 /// administrative functions to the bloot DAO. It allows:
815 /// * bloot holders to claim Based Gold
816 /// * A DAO to set seasons for new opportunities to claim Based Gold
817 /// * A DAO to mint Based Gold for use within the bloot ecosystem
818 /// @custom:unaudited This contract has not been audited. Use at your own risk.
819 contract BasedGold is Context, Ownable, ERC20 {
820     // bloot contract is available at https://etherscan.io/address/0xff9c1b15b16263c61d017ee9f65c50e4ae0113d7
821     address public blootContractAddress =
822         0x4F8730E0b32B04beaa5757e5aea3aeF970E5B613;
823     IERC721Enumerable public blootContract;
824 
825     // Give out 10,000 Based Gold for every bloot Bag that a user holds
826     uint256 public BasedGoldPerTokenId = 10000 * (10**decimals());
827 
828     // tokenIdStart of 1 is based on the following lines in the bloot contract:
829     /** 
830     function claim(uint256 tokenId) public nonReentrant {
831         require(tokenId > 0 && tokenId < 7778, "Token ID invalid");
832         _safeMint(_msgSender(), tokenId);
833     }
834     */
835     uint256 public tokenIdStart = 1;
836 
837     // tokenIdEnd of 8000 is based on the following lines in the bloot contract:
838     /**
839         function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
840         require(tokenId > 7777 && tokenId < 8001, "Token ID invalid");
841         _safeMint(owner(), tokenId);
842     }
843     */
844     uint256 public tokenIdEnd = 8000;
845 
846     // Seasons are used to allow users to claim tokens regularly. Seasons are
847     // decided by the DAO.
848     uint256 public season = 0;
849 
850     // Track claimed tokens within a season
851     // IMPORTANT: The format of the mapping is:
852     // claimedForSeason[season][tokenId][claimed]
853     mapping(uint256 => mapping(uint256 => bool)) public seasonClaimedByTokenId;
854 
855     constructor() Ownable() ERC20("Based Gold", "BGLD") {
856         // Transfer ownership to the bloot DAO
857         // Ownable by OpenZeppelin automatically sets owner to msg.sender, but
858         // we're going to be using a separate wallet for deployment
859         transferOwnership(_msgSender());
860         blootContract = IERC721Enumerable(blootContractAddress);
861     }
862 
863     /// @notice Claim Based Gold for a given bloot ID
864     /// @param tokenId The tokenId of the bloot NFT
865     function claimById(uint256 tokenId) external {
866         // Follow the Checks-Effects-Interactions pattern to prevent reentrancy
867         // attacks
868 
869         // Checks
870 
871         // Check that the msgSender owns the token that is being claimed
872         require(
873             _msgSender() == blootContract.ownerOf(tokenId),
874             "MUST_OWN_TOKEN_ID"
875         );
876 
877         // Further Checks, Effects, and Interactions are contained within the
878         // _claim() function
879         _claim(tokenId, _msgSender());
880     }
881 
882     /// @notice Claim Based Gold for all tokens owned by the sender
883     /// @notice This function will run out of gas if you have too much bloot! If
884     /// this is a concern, you should use claimRangeForOwner and claim Based
885     /// Gold in batches.
886     function claimAllForOwner() external {
887         uint256 tokenBalanceOwner = blootContract.balanceOf(_msgSender());
888 
889         // Checks
890         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
891 
892         // i < tokenBalanceOwner because tokenBalanceOwner is 1-indexed
893         for (uint256 i = 0; i < tokenBalanceOwner; i++) {
894             // Further Checks, Effects, and Interactions are contained within
895             // the _claim() function
896             _claim(
897                 blootContract.tokenOfOwnerByIndex(_msgSender(), i),
898                 _msgSender()
899             );
900         }
901     }
902 
903     /// @notice Claim Based Gold for all tokens owned by the sender within a
904     /// given range
905     /// @notice This function is useful if you own too much bloot to claim all at
906     /// once or if you want to leave some bloot unclaimed. If you leave bloot
907     /// unclaimed, however, you cannot claim it once the next season starts.
908     function claimRangeForOwner(uint256 ownerIndexStart, uint256 ownerIndexEnd)
909         external
910     {
911         uint256 tokenBalanceOwner = blootContract.balanceOf(_msgSender());
912 
913         // Checks
914         require(tokenBalanceOwner > 0, "NO_TOKENS_OWNED");
915 
916         // We use < for ownerIndexEnd and tokenBalanceOwner because
917         // tokenOfOwnerByIndex is 0-indexed while the token balance is 1-indexed
918         require(
919             ownerIndexStart >= 0 && ownerIndexEnd < tokenBalanceOwner,
920             "INDEX_OUT_OF_RANGE"
921         );
922 
923         // i <= ownerIndexEnd because ownerIndexEnd is 0-indexed
924         for (uint256 i = ownerIndexStart; i <= ownerIndexEnd; i++) {
925             // Further Checks, Effects, and Interactions are contained within
926             // the _claim() function
927             _claim(
928                 blootContract.tokenOfOwnerByIndex(_msgSender(), i),
929                 _msgSender()
930             );
931         }
932     }
933 
934     /// @dev Internal function to mint bloot upon claiming
935     function _claim(uint256 tokenId, address tokenOwner) internal {
936         // Checks
937         // Check that the token ID is in range
938         // We use >= and <= to here because all of the token IDs are 0-indexed
939         require(
940             tokenId >= tokenIdStart && tokenId <= tokenIdEnd,
941             "TOKEN_ID_OUT_OF_RANGE"
942         );
943 
944         // Check that Based Gold have not already been claimed this season
945         // for a given tokenId
946         require(
947             !seasonClaimedByTokenId[season][tokenId],
948             "GOLD_CLAIMED_FOR_TOKEN_ID"
949         );
950 
951         // Effects
952 
953         // Mark that Based Gold has been claimed for this season for the
954         // given tokenId
955         seasonClaimedByTokenId[season][tokenId] = true;
956 
957         // Interactions
958 
959         // Send Based Gold to the owner of the token ID
960         _mint(tokenOwner, BasedGoldPerTokenId);
961     }
962 
963     /// @notice Allows the DAO to mint new tokens for use within the bloot
964     /// Ecosystem
965     /// @param amountDisplayValue The amount of bloot to mint. This should be
966     /// input as the display value, not in raw decimals. If you want to mint
967     /// 100 bloot, you should enter "100" rather than the value of 100 * 10^18.
968     function daoMint(uint256 amountDisplayValue) external onlyOwner {
969         _mint(owner(), amountDisplayValue * (10**decimals()));
970     }
971 
972     /// @notice Allows the DAO to set a new contract address for bloot. This is
973     /// relevant in the event that bloot migrates to a new contract.
974     /// @param blootContractAddress_ The new contract address for bloot
975     function daoSetblootContractAddress(address blootContractAddress_)
976         external
977         onlyOwner
978     {
979         blootContractAddress = blootContractAddress_;
980         blootContract = IERC721Enumerable(blootContractAddress);
981     }
982 
983     /// @notice Allows the DAO to set the token IDs that are eligible to claim
984     /// bloot
985     /// @param tokenIdStart_ The start of the eligible token range
986     /// @param tokenIdEnd_ The end of the eligible token range
987     /// @dev This is relevant in case a future bloot contract has a different
988     /// total supply of bloot
989     function daoSetTokenIdRange(uint256 tokenIdStart_, uint256 tokenIdEnd_)
990         external
991         onlyOwner
992     {
993         tokenIdStart = tokenIdStart_;
994         tokenIdEnd = tokenIdEnd_;
995     }
996 
997     /// @notice Allows the DAO to set a season for new Based Gold claims
998     /// @param season_ The season to use for claiming bloot
999     function daoSetSeason(uint256 season_) public onlyOwner {
1000         season = season_;
1001     }
1002 
1003     /// @notice Allows the DAO to set the amount of Based Gold that is
1004     /// claimed per token ID
1005     /// @param BasedGoldDisplayValue The amount of bloot a user can claim.
1006     /// This should be input as the display value, not in raw decimals. If you
1007     /// want to mint 100 bloot, you should enter "100" rather than the value of
1008     /// 100 * 10^18.
1009     function daoSetBasedGoldPerTokenId(uint256 BasedGoldDisplayValue)
1010         public
1011         onlyOwner
1012     {
1013         BasedGoldPerTokenId = BasedGoldDisplayValue * (10**decimals());
1014     }
1015 
1016     /// @notice Allows the DAO to set the season and Based Gold per token ID
1017     /// in one transaction. This ensures that there is not a gap where a user
1018     /// can claim more Based Gold than others
1019     /// @param season_ The season to use for claiming bloot
1020     /// @param BasedGoldDisplayValue The amount of bloot a user can claim.
1021     /// This should be input as the display value, not in raw decimals. If you
1022     /// want to mint 100 bloot, you should enter "100" rather than the value of
1023     /// 100 * 10^18.
1024     /// @dev We would save a tiny amount of gas by modifying the season and
1025     /// BasedGold variables directly. It is better practice for security,
1026     /// however, to avoid repeating code. This function is so rarely used that
1027     /// it's not worth moving these values into their own internal function to
1028     /// skip the gas used on the modifier check.
1029     function daoSetSeasonAndBasedGoldPerTokenID(
1030         uint256 season_,
1031         uint256 BasedGoldDisplayValue
1032     ) external onlyOwner {
1033         daoSetSeason(season_);
1034         daoSetBasedGoldPerTokenId(BasedGoldDisplayValue);
1035     }
1036 }