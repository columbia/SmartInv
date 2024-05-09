1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
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
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP.
115  */
116 interface IERC20 {
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
130 
131     /**
132      * @dev Returns the amount of tokens in existence.
133      */
134     function totalSupply() external view returns (uint256);
135 
136     /**
137      * @dev Returns the amount of tokens owned by `account`.
138      */
139     function balanceOf(address account) external view returns (uint256);
140 
141     /**
142      * @dev Moves `amount` tokens from the caller's account to `to`.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transfer(address to, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Returns the remaining number of tokens that `spender` will be
152      * allowed to spend on behalf of `owner` through {transferFrom}. This is
153      * zero by default.
154      *
155      * This value changes when {approve} or {transferFrom} are called.
156      */
157     function allowance(address owner, address spender) external view returns (uint256);
158 
159     /**
160      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * IMPORTANT: Beware that changing an allowance with this method brings the risk
165      * that someone may use both the old and the new allowance by unfortunate
166      * transaction ordering. One possible solution to mitigate this race
167      * condition is to first reduce the spender's allowance to 0 and set the
168      * desired value afterwards:
169      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170      *
171      * Emits an {Approval} event.
172      */
173     function approve(address spender, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Moves `amount` tokens from `from` to `to` using the
177      * allowance mechanism. `amount` is then deducted from the caller's
178      * allowance.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(
185         address from,
186         address to,
187         uint256 amount
188     ) external returns (bool);
189 }
190 
191 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
192 
193 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 
199 /**
200  * @dev Interface for the optional metadata functions from the ERC20 standard.
201  *
202  * _Available since v4.1._
203  */
204 interface IERC20Metadata is IERC20 {
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the symbol of the token.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the decimals places of the token.
217      */
218     function decimals() external view returns (uint8);
219 }
220 
221 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
222 
223 
224 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 
229 
230 
231 /**
232  * @dev Implementation of the {IERC20} interface.
233  *
234  * This implementation is agnostic to the way tokens are created. This means
235  * that a supply mechanism has to be added in a derived contract using {_mint}.
236  * For a generic mechanism see {ERC20PresetMinterPauser}.
237  *
238  * TIP: For a detailed writeup see our guide
239  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
240  * to implement supply mechanisms].
241  *
242  * We have followed general OpenZeppelin Contracts guidelines: functions revert
243  * instead returning `false` on failure. This behavior is nonetheless
244  * conventional and does not conflict with the expectations of ERC20
245  * applications.
246  *
247  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
248  * This allows applications to reconstruct the allowance for all accounts just
249  * by listening to said events. Other implementations of the EIP may not emit
250  * these events, as it isn't required by the specification.
251  *
252  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
253  * functions have been added to mitigate the well-known issues around setting
254  * allowances. See {IERC20-approve}.
255  */
256 contract ERC20 is Context, IERC20, IERC20Metadata {
257     mapping(address => uint256) private _balances;
258 
259     mapping(address => mapping(address => uint256)) private _allowances;
260 
261     uint256 private _totalSupply;
262 
263     string private _name;
264     string private _symbol;
265 
266     /**
267      * @dev Sets the values for {name} and {symbol}.
268      *
269      * The default value of {decimals} is 18. To select a different value for
270      * {decimals} you should overload it.
271      *
272      * All two of these values are immutable: they can only be set once during
273      * construction.
274      */
275     constructor(string memory name_, string memory symbol_) {
276         _name = name_;
277         _symbol = symbol_;
278     }
279 
280     /**
281      * @dev Returns the name of the token.
282      */
283     function name() public view virtual override returns (string memory) {
284         return _name;
285     }
286 
287     /**
288      * @dev Returns the symbol of the token, usually a shorter version of the
289      * name.
290      */
291     function symbol() public view virtual override returns (string memory) {
292         return _symbol;
293     }
294 
295     /**
296      * @dev Returns the number of decimals used to get its user representation.
297      * For example, if `decimals` equals `2`, a balance of `505` tokens should
298      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
299      *
300      * Tokens usually opt for a value of 18, imitating the relationship between
301      * Ether and Wei. This is the value {ERC20} uses, unless this function is
302      * overridden;
303      *
304      * NOTE: This information is only used for _display_ purposes: it in
305      * no way affects any of the arithmetic of the contract, including
306      * {IERC20-balanceOf} and {IERC20-transfer}.
307      */
308     function decimals() public view virtual override returns (uint8) {
309         return 18;
310     }
311 
312     /**
313      * @dev See {IERC20-totalSupply}.
314      */
315     function totalSupply() public view virtual override returns (uint256) {
316         return _totalSupply;
317     }
318 
319     /**
320      * @dev See {IERC20-balanceOf}.
321      */
322     function balanceOf(address account) public view virtual override returns (uint256) {
323         return _balances[account];
324     }
325 
326     /**
327      * @dev See {IERC20-transfer}.
328      *
329      * Requirements:
330      *
331      * - `to` cannot be the zero address.
332      * - the caller must have a balance of at least `amount`.
333      */
334     function transfer(address to, uint256 amount) public virtual override returns (bool) {
335         address owner = _msgSender();
336         _transfer(owner, to, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(address owner, address spender) public view virtual override returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {IERC20-approve}.
349      *
350      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
351      * `transferFrom`. This is semantically equivalent to an infinite approval.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      */
357     function approve(address spender, uint256 amount) public virtual override returns (bool) {
358         address owner = _msgSender();
359         _approve(owner, spender, amount);
360         return true;
361     }
362 
363     /**
364      * @dev See {IERC20-transferFrom}.
365      *
366      * Emits an {Approval} event indicating the updated allowance. This is not
367      * required by the EIP. See the note at the beginning of {ERC20}.
368      *
369      * NOTE: Does not update the allowance if the current allowance
370      * is the maximum `uint256`.
371      *
372      * Requirements:
373      *
374      * - `from` and `to` cannot be the zero address.
375      * - `from` must have a balance of at least `amount`.
376      * - the caller must have allowance for ``from``'s tokens of at least
377      * `amount`.
378      */
379     function transferFrom(
380         address from,
381         address to,
382         uint256 amount
383     ) public virtual override returns (bool) {
384         address spender = _msgSender();
385         _spendAllowance(from, spender, amount);
386         _transfer(from, to, amount);
387         return true;
388     }
389 
390     /**
391      * @dev Atomically increases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      */
402     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
403         address owner = _msgSender();
404         _approve(owner, spender, allowance(owner, spender) + addedValue);
405         return true;
406     }
407 
408     /**
409      * @dev Atomically decreases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      * - `spender` must have allowance for the caller of at least
420      * `subtractedValue`.
421      */
422     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
423         address owner = _msgSender();
424         uint256 currentAllowance = allowance(owner, spender);
425         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
426         unchecked {
427             _approve(owner, spender, currentAllowance - subtractedValue);
428         }
429 
430         return true;
431     }
432 
433     /**
434      * @dev Moves `amount` of tokens from `sender` to `recipient`.
435      *
436      * This internal function is equivalent to {transfer}, and can be used to
437      * e.g. implement automatic token fees, slashing mechanisms, etc.
438      *
439      * Emits a {Transfer} event.
440      *
441      * Requirements:
442      *
443      * - `from` cannot be the zero address.
444      * - `to` cannot be the zero address.
445      * - `from` must have a balance of at least `amount`.
446      */
447     function _transfer(
448         address from,
449         address to,
450         uint256 amount
451     ) internal virtual {
452         require(from != address(0), "ERC20: transfer from the zero address");
453         require(to != address(0), "ERC20: transfer to the zero address");
454 
455         _beforeTokenTransfer(from, to, amount);
456 
457         uint256 fromBalance = _balances[from];
458         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
459         unchecked {
460             _balances[from] = fromBalance - amount;
461         }
462         _balances[to] += amount;
463 
464         emit Transfer(from, to, amount);
465 
466         _afterTokenTransfer(from, to, amount);
467     }
468 
469     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
470      * the total supply.
471      *
472      * Emits a {Transfer} event with `from` set to the zero address.
473      *
474      * Requirements:
475      *
476      * - `account` cannot be the zero address.
477      */
478     function _mint(address account, uint256 amount) internal virtual {
479         require(account != address(0), "ERC20: mint to the zero address");
480 
481         _beforeTokenTransfer(address(0), account, amount);
482 
483         _totalSupply += amount;
484         _balances[account] += amount;
485         emit Transfer(address(0), account, amount);
486 
487         _afterTokenTransfer(address(0), account, amount);
488     }
489 
490     /**
491      * @dev Destroys `amount` tokens from `account`, reducing the
492      * total supply.
493      *
494      * Emits a {Transfer} event with `to` set to the zero address.
495      *
496      * Requirements:
497      *
498      * - `account` cannot be the zero address.
499      * - `account` must have at least `amount` tokens.
500      */
501     function _burn(address account, uint256 amount) internal virtual {
502         require(account != address(0), "ERC20: burn from the zero address");
503 
504         _beforeTokenTransfer(account, address(0), amount);
505 
506         uint256 accountBalance = _balances[account];
507         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
508         unchecked {
509             _balances[account] = accountBalance - amount;
510         }
511         _totalSupply -= amount;
512 
513         emit Transfer(account, address(0), amount);
514 
515         _afterTokenTransfer(account, address(0), amount);
516     }
517 
518     /**
519      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
520      *
521      * This internal function is equivalent to `approve`, and can be used to
522      * e.g. set automatic allowances for certain subsystems, etc.
523      *
524      * Emits an {Approval} event.
525      *
526      * Requirements:
527      *
528      * - `owner` cannot be the zero address.
529      * - `spender` cannot be the zero address.
530      */
531     function _approve(
532         address owner,
533         address spender,
534         uint256 amount
535     ) internal virtual {
536         require(owner != address(0), "ERC20: approve from the zero address");
537         require(spender != address(0), "ERC20: approve to the zero address");
538 
539         _allowances[owner][spender] = amount;
540         emit Approval(owner, spender, amount);
541     }
542 
543     /**
544      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
545      *
546      * Does not update the allowance amount in case of infinite allowance.
547      * Revert if not enough allowance is available.
548      *
549      * Might emit an {Approval} event.
550      */
551     function _spendAllowance(
552         address owner,
553         address spender,
554         uint256 amount
555     ) internal virtual {
556         uint256 currentAllowance = allowance(owner, spender);
557         if (currentAllowance != type(uint256).max) {
558             require(currentAllowance >= amount, "ERC20: insufficient allowance");
559             unchecked {
560                 _approve(owner, spender, currentAllowance - amount);
561             }
562         }
563     }
564 
565     /**
566      * @dev Hook that is called before any transfer of tokens. This includes
567      * minting and burning.
568      *
569      * Calling conditions:
570      *
571      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
572      * will be transferred to `to`.
573      * - when `from` is zero, `amount` tokens will be minted for `to`.
574      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
575      * - `from` and `to` are never both zero.
576      *
577      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
578      */
579     function _beforeTokenTransfer(
580         address from,
581         address to,
582         uint256 amount
583     ) internal virtual {}
584 
585     /**
586      * @dev Hook that is called after any transfer of tokens. This includes
587      * minting and burning.
588      *
589      * Calling conditions:
590      *
591      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
592      * has been transferred to `to`.
593      * - when `from` is zero, `amount` tokens have been minted for `to`.
594      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
595      * - `from` and `to` are never both zero.
596      *
597      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
598      */
599     function _afterTokenTransfer(
600         address from,
601         address to,
602         uint256 amount
603     ) internal virtual {}
604 }
605 
606 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
607 
608 
609 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 
615 /**
616  * @dev Extension of {ERC20} that allows token holders to destroy both their own
617  * tokens and those that they have an allowance for, in a way that can be
618  * recognized off-chain (via event analysis).
619  */
620 abstract contract ERC20Burnable is Context, ERC20 {
621     /**
622      * @dev Destroys `amount` tokens from the caller.
623      *
624      * See {ERC20-_burn}.
625      */
626     function burn(uint256 amount) public virtual {
627         _burn(_msgSender(), amount);
628     }
629 
630     /**
631      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
632      * allowance.
633      *
634      * See {ERC20-_burn} and {ERC20-allowance}.
635      *
636      * Requirements:
637      *
638      * - the caller must have allowance for ``accounts``'s tokens of at least
639      * `amount`.
640      */
641     function burnFrom(address account, uint256 amount) public virtual {
642         _spendAllowance(account, _msgSender(), amount);
643         _burn(account, amount);
644     }
645 }
646 
647 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 /**
655  * @dev Interface of the ERC165 standard, as defined in the
656  * https://eips.ethereum.org/EIPS/eip-165[EIP].
657  *
658  * Implementers can declare support of contract interfaces, which can then be
659  * queried by others ({ERC165Checker}).
660  *
661  * For an implementation, see {ERC165}.
662  */
663 interface IERC165 {
664     /**
665      * @dev Returns true if this contract implements the interface defined by
666      * `interfaceId`. See the corresponding
667      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
668      * to learn more about how these ids are created.
669      *
670      * This function call must use less than 30 000 gas.
671      */
672     function supportsInterface(bytes4 interfaceId) external view returns (bool);
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
676 
677 
678 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 
683 /**
684  * @dev Required interface of an ERC721 compliant contract.
685  */
686 interface IERC721 is IERC165 {
687     /**
688      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
689      */
690     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
691 
692     /**
693      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
694      */
695     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
696 
697     /**
698      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
699      */
700     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
701 
702     /**
703      * @dev Returns the number of tokens in ``owner``'s account.
704      */
705     function balanceOf(address owner) external view returns (uint256 balance);
706 
707     /**
708      * @dev Returns the owner of the `tokenId` token.
709      *
710      * Requirements:
711      *
712      * - `tokenId` must exist.
713      */
714     function ownerOf(uint256 tokenId) external view returns (address owner);
715 
716     /**
717      * @dev Safely transfers `tokenId` token from `from` to `to`.
718      *
719      * Requirements:
720      *
721      * - `from` cannot be the zero address.
722      * - `to` cannot be the zero address.
723      * - `tokenId` token must exist and be owned by `from`.
724      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
725      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
726      *
727      * Emits a {Transfer} event.
728      */
729     function safeTransferFrom(
730         address from,
731         address to,
732         uint256 tokenId,
733         bytes calldata data
734     ) external;
735 
736     /**
737      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
738      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
739      *
740      * Requirements:
741      *
742      * - `from` cannot be the zero address.
743      * - `to` cannot be the zero address.
744      * - `tokenId` token must exist and be owned by `from`.
745      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
746      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
747      *
748      * Emits a {Transfer} event.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId
754     ) external;
755 
756     /**
757      * @dev Transfers `tokenId` token from `from` to `to`.
758      *
759      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
760      *
761      * Requirements:
762      *
763      * - `from` cannot be the zero address.
764      * - `to` cannot be the zero address.
765      * - `tokenId` token must be owned by `from`.
766      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
767      *
768      * Emits a {Transfer} event.
769      */
770     function transferFrom(
771         address from,
772         address to,
773         uint256 tokenId
774     ) external;
775 
776     /**
777      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
778      * The approval is cleared when the token is transferred.
779      *
780      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
781      *
782      * Requirements:
783      *
784      * - The caller must own the token or be an approved operator.
785      * - `tokenId` must exist.
786      *
787      * Emits an {Approval} event.
788      */
789     function approve(address to, uint256 tokenId) external;
790 
791     /**
792      * @dev Approve or remove `operator` as an operator for the caller.
793      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
794      *
795      * Requirements:
796      *
797      * - The `operator` cannot be the caller.
798      *
799      * Emits an {ApprovalForAll} event.
800      */
801     function setApprovalForAll(address operator, bool _approved) external;
802 
803     /**
804      * @dev Returns the account approved for `tokenId` token.
805      *
806      * Requirements:
807      *
808      * - `tokenId` must exist.
809      */
810     function getApproved(uint256 tokenId) external view returns (address operator);
811 
812     /**
813      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
814      *
815      * See {setApprovalForAll}
816      */
817     function isApprovedForAll(address owner, address operator) external view returns (bool);
818 }
819 
820 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
821 
822 
823 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
824 
825 pragma solidity ^0.8.0;
826 
827 
828 /**
829  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
830  * @dev See https://eips.ethereum.org/EIPS/eip-721
831  */
832 interface IERC721Metadata is IERC721 {
833     /**
834      * @dev Returns the token collection name.
835      */
836     function name() external view returns (string memory);
837 
838     /**
839      * @dev Returns the token collection symbol.
840      */
841     function symbol() external view returns (string memory);
842 
843     /**
844      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
845      */
846     function tokenURI(uint256 tokenId) external view returns (string memory);
847 }
848 
849 // File: contracts/Optix.sol
850 
851 
852 pragma solidity ^0.8.4;
853 
854 
855 
856 
857 
858 
859 
860 /****************************************************************
861 * OPTIX by The Blinkless: The Official Currency of New Cornea
862 * "Soft" stake your favorite NFTs
863 * code by @digitalkemical
864 *****************************************************************/
865 
866 contract Optix is ERC20, ERC20Burnable, Ownable {
867     //define a stake structure
868     struct Stake{
869         address contractAddress;
870         address ownerAddress;
871         uint startTime;
872         uint tokenId;
873     }
874 
875     //define a collection structure
876     struct Collection{
877         address contractAddress;
878         uint hourlyReward;
879     }
880 
881     //define variables
882     mapping( address => mapping(uint => Stake ) ) public openStakes; //mapping of all open stakes by collection address
883     mapping( address => mapping( address => uint[] ) ) public myActiveCollections; //mapping of wallet address to all active collections
884     mapping( address => bool ) public hasMigrated; //bool tracker of who has migrated from v1
885     Collection[] public collections; //array of NFT collections that can be staked
886     address[] public freeCollections; //array of contract addresses for collections with no fee
887     address v1ContractAddress = 0xcEE33d20845038Df71B88041B28c3654CF05ae2f; //address to v1 Optix contract (for migration)
888     address payoutWallet = 0xeD2faa60373eC70E57B39152aeE5Ce4ed7C333c7; //wallet for payouts
889     uint migrationMode = 1; //turn on/off migrations
890     uint public thirdPartyFee = 0.001 ether; //fee to charge for 3rd party stakes
891 
892     //run on deploy
893     constructor() ERC20("Optix", "OPTIX") {}
894 
895     /**
896     * Owner can mint more tokens
897     */
898     function mint(address to, uint256 amount) public onlyOwner {
899         _mint(to, amount);
900     }
901 
902     /**
903     * Migrate balance from v1 contract
904     */
905     function migrateFromv1() public{
906         require(migrationMode == 1, "Migration period has closed.");
907         require(hasMigrated[msg.sender] == false, "You have already migrated.");
908 
909          uint oldBalance = IERC20(v1ContractAddress).balanceOf(msg.sender);
910        
911         hasMigrated[msg.sender] = true;
912         _mint(msg.sender, oldBalance + 100000 ether);
913         
914         
915     }
916 
917 
918     /**
919     * Add a collection to the staking options
920     */
921     function addCollection(address _contractAddress, uint _hourlyReward) public onlyOwner{
922         collections.push(
923             Collection(
924                 _contractAddress,
925                 _hourlyReward
926             )
927             );
928     }
929 
930     /**
931     * Update the third party fee
932     */
933     function updateThirdPartyFee(uint _fee) public onlyOwner{
934         thirdPartyFee = _fee;
935     }
936 
937     /**
938     * Update the migration mode
939     */
940     function updateMigrationMode(uint _migrationMode) public onlyOwner{
941         migrationMode = _migrationMode;
942     }
943 
944     /**
945     * Add a collection to free collection list
946     */
947     function addToFreeCollections(address _contractAddress) public onlyOwner{
948         freeCollections.push(_contractAddress);
949 
950     }
951 
952     /**
953     * Update the v1 contract address
954     */
955     function updateV1Contract(address _v1ContractAddress) public onlyOwner{
956         v1ContractAddress = _v1ContractAddress;
957     }
958 
959     /**
960     * Update the payout wallet address
961     */
962     function updatePayoutWallet(address _payoutWallet) public onlyOwner{
963         payoutWallet = _payoutWallet;
964     }
965 
966     /**
967     * Remove a collection from the free collection list
968     */
969     function removeFreeCollection(address _contractAddress) public onlyOwner{
970         uint i = 0;
971         while(i < freeCollections.length){
972             if(freeCollections[i] == _contractAddress){
973                 freeCollections[i] = freeCollections[freeCollections.length-1];
974                 freeCollections.pop();
975             }
976             i++;
977         }
978     }
979 
980     /**
981     * Remove a collection from the staking options
982     */
983     function removeCollection(address _contractAddress) public onlyOwner{
984         uint i = 0;
985         while(i < collections.length){
986             if(collections[i].contractAddress == _contractAddress){
987                 collections[i] = collections[collections.length-1];
988                 collections.pop();
989             }
990             i++;
991         }
992     }
993 
994     /**
995     * Get all available collections
996     */
997     function getAllCollections() public view returns(Collection[] memory _collections){
998         return collections;
999     }
1000 
1001     /**
1002     * Get all free collections
1003     */
1004     function getAllFreeCollections() public view returns(address[] memory _collections){
1005         return freeCollections;
1006     }
1007 
1008     /**
1009     * Get a collection
1010     */
1011     function getCollection(address _contractAddress) public view returns(Collection memory _collections){
1012         uint i = 0;
1013         while(i < collections.length){
1014             if(collections[i].contractAddress == _contractAddress){
1015                 return collections[i];
1016             }
1017             i++;
1018         }
1019     }
1020 
1021     /**
1022     * Open a new soft stake (tokens are never locked)
1023     */
1024     function openStake(address _contractAddress, uint[] memory _tokenIds) public payable {
1025         //check if collection is approved
1026         require(collectionIsApproved(_contractAddress),"This collection has not been approved.");
1027 
1028         bool isFree = false;
1029         uint i = 0;
1030         while(i < freeCollections.length){
1031             if(freeCollections[i] == _contractAddress){
1032                 isFree = true;
1033             }
1034             i++;
1035         }
1036 
1037         //charge a withdrawal fee for 3rd party collections 
1038         if(!isFree){
1039             require(msg.value >= thirdPartyFee * _tokenIds.length, "Insufficient funds to open 3rd-party stake.");
1040         }
1041 
1042         uint counter = 0;
1043         while(counter < _tokenIds.length){
1044             uint _tokenId = _tokenIds[counter];
1045             //ensure sender is owner of token and collection is approved
1046             
1047             require(IERC721(_contractAddress).ownerOf(_tokenId) == msg.sender,"Could not verify ownership!");
1048 
1049             //if trying to open a stake previously owned, update the stake owner
1050             if(checkForStake(_contractAddress,_tokenId) && openStakes[_contractAddress][_tokenId].ownerAddress != msg.sender){
1051                 updateOwnership( _contractAddress, _tokenId );
1052             }
1053             //make sure stake doesn't already exist
1054             if(!checkForStake(_contractAddress,_tokenId)){
1055              
1056 
1057                 //create a new stake
1058                 openStakes[_contractAddress][_tokenId]=
1059                     Stake(
1060                         _contractAddress,
1061                         msg.sender,
1062                         block.timestamp,
1063                         _tokenId
1064                     )
1065                 ;
1066                     
1067                 //add collection to active list
1068                 addToActiveList(_contractAddress, _tokenId);
1069             }
1070 
1071             counter++;
1072         }
1073         
1074     }
1075 
1076     /**
1077     * Add an active collection to a wallet
1078     */
1079     function addToActiveList(address _contractAddress, uint _tokenId) internal {
1080         uint i = 0;
1081         bool exists = false;
1082         while(i < myActiveCollections[msg.sender][_contractAddress].length){
1083             if(myActiveCollections[msg.sender][_contractAddress][i] == _tokenId){
1084                 exists = true;
1085             }
1086             i++;
1087         }
1088         //if it doesnt already exist, add it
1089         if(!exists){
1090             myActiveCollections[msg.sender][_contractAddress].push(_tokenId);
1091         }
1092     }
1093 
1094     /**
1095     * Get the active list for the wallet by collection contract address
1096     */
1097     function getActiveList(address _contractAddress) external view returns(uint[] memory _activeList){
1098         //get list of active collections for sender
1099         return myActiveCollections[msg.sender][_contractAddress];
1100         
1101     }
1102 
1103     /**
1104     * Verify that a collection being staked has been approved
1105     */
1106     function collectionIsApproved(address _contractAddress) public view returns(bool _approved){
1107         uint i = 0;
1108         while(i < collections.length){
1109             if(collections[i].contractAddress == _contractAddress){
1110                 return true;
1111             }
1112             i++;
1113         }
1114 
1115         return false;
1116     }
1117 
1118     /**
1119     * Check if a stake exists already
1120     */
1121     function checkForStake(address _contractAddress, uint _tokenId) public view returns(bool _exists){
1122  
1123             if(openStakes[_contractAddress][_tokenId].startTime > 0){
1124                 return true;
1125             }
1126 
1127         return false;
1128     }
1129 
1130     /**
1131     * Get a stake
1132     */
1133     function getStake(address _contractAddress, uint _tokenId) public view returns(Stake memory _exists){
1134         return openStakes[_contractAddress][_tokenId];
1135     }
1136 
1137     /**
1138     * Calculate stake reward for a token
1139     */
1140     function calculateStakeReward(address _contractAddress, uint _tokenId) public view returns(uint _totalReward){
1141         //get the stake
1142         Stake memory closingStake = getStake( _contractAddress, _tokenId );
1143         //get collection data
1144         Collection memory stakedCollection = getCollection(_contractAddress);
1145         //calc hours in between start and now
1146         uint hoursDiff = (block.timestamp - closingStake.startTime) / 60 / 60;
1147         //calc total reward
1148         uint totalReward = hoursDiff * stakedCollection.hourlyReward;
1149 
1150         return totalReward;
1151     }
1152 
1153     /**
1154     * Close a stake and claim reward
1155     */
1156     function closeStake(address _contractAddress, uint[] memory _tokenIds) public payable returns(uint _totalReward){
1157         
1158         uint totalReward = 0;
1159         
1160         uint counter = 0;
1161         while(counter < _tokenIds.length){
1162             uint _tokenId = _tokenIds[counter];
1163 
1164                 bool isFree = false;
1165                 uint i2 = 0;
1166                 while(i2 < freeCollections.length){
1167                     if(freeCollections[i2] == _contractAddress){
1168                         isFree = true;
1169                     }
1170                     i2++;
1171                 }
1172 
1173                 //charge a withdrawal fee for 3rd party collections - Blinkless NFTs will be zero
1174                 if(!isFree){
1175                     require(msg.value >= thirdPartyFee * _tokenIds.length, "Insufficient funds to open 3rd-party stake.");
1176                 }
1177 
1178                 if(checkForStake(_contractAddress,_tokenId) && IERC721(_contractAddress).ownerOf(_tokenId) == msg.sender){
1179 
1180                         //calculate end of stake reward
1181                         totalReward += calculateStakeReward(_contractAddress, _tokenId);
1182 
1183                         //stake has been identified, remove stake
1184                         delete(openStakes[_contractAddress][_tokenId]);
1185 
1186                         //remove from active list
1187                         uint i = 0;
1188                         while(i < myActiveCollections[msg.sender][_contractAddress].length){
1189                             if(myActiveCollections[msg.sender][_contractAddress][i] == _tokenId){
1190                                 myActiveCollections[msg.sender][_contractAddress][i] = myActiveCollections[msg.sender][_contractAddress][myActiveCollections[msg.sender][_contractAddress].length-1];
1191                                 myActiveCollections[msg.sender][_contractAddress].pop();
1192                             }
1193                             i++;
1194                         }
1195 
1196                 }
1197 
1198                 counter++;
1199         }
1200 
1201         //award tokens
1202         if(totalReward > 0){
1203             _mint(msg.sender, totalReward);
1204         }
1205 
1206         return totalReward;
1207       
1208 
1209     }
1210 
1211     /**
1212     * Claim rewards from multiple stakes at once without closing 
1213     */
1214     function claimWithoutClosing(address _contractAddress, uint[] memory _tokenIds) public returns(uint _totalReward){
1215         
1216         uint totalReward = 0;
1217 
1218             uint counter = 0;
1219             while(counter < _tokenIds.length){
1220                 uint _tokenId = _tokenIds[counter];
1221 
1222                     if(checkForStake(_contractAddress,_tokenId) && IERC721(_contractAddress).ownerOf(_tokenId) == msg.sender){
1223 
1224                             //calculate end of stake reward
1225                             totalReward += calculateStakeReward(_contractAddress, _tokenId);
1226 
1227                             //stake has been identified, update the timestamp
1228                             openStakes[_contractAddress][_tokenId].startTime = block.timestamp;
1229 
1230                     }
1231 
1232                 counter++;
1233             }
1234 
1235            
1236 
1237         //award tokens
1238         if(totalReward > 0){
1239             _mint(msg.sender, totalReward);
1240         }
1241 
1242         return totalReward;
1243       
1244 
1245     }
1246 
1247 
1248     /**
1249     * Claim rewards from all stakes without closing
1250     */
1251     function claimAllWithoutClosing() public returns(uint _totalReward){
1252         
1253         uint totalReward = 0;
1254         uint collectionCounter = 0;
1255         while(collectionCounter < collections.length){
1256             address _contractAddress = collections[collectionCounter].contractAddress;
1257             uint[] memory _tokenIds = myActiveCollections[msg.sender][_contractAddress];
1258 
1259             uint counter = 0;
1260             while(counter < _tokenIds.length){
1261                 uint _tokenId = _tokenIds[counter];
1262 
1263                     if(checkForStake(_contractAddress,_tokenId) && IERC721(_contractAddress).ownerOf(_tokenId) == msg.sender){
1264 
1265                             //calculate end of stake reward
1266                             totalReward += calculateStakeReward(_contractAddress, _tokenId);
1267 
1268                             //stake has been identified, update the timestamp
1269                             openStakes[_contractAddress][_tokenId].startTime = block.timestamp;
1270 
1271                     }
1272 
1273                 counter++;
1274             }
1275 
1276             collectionCounter++;
1277 
1278         }
1279 
1280         //award tokens
1281         if(totalReward > 0){
1282             _mint(msg.sender, totalReward);
1283         }
1284 
1285         return totalReward;
1286       
1287 
1288     }
1289 
1290     /**
1291     * Update the ownership of a stake to match the NFT owner
1292     */
1293     function updateOwnership(address _contractAddress, uint _tokenId) public{
1294         //get the NFT owner
1295         address tokenOwner = IERC721(_contractAddress).ownerOf(_tokenId);
1296         if(openStakes[_contractAddress][_tokenId].ownerAddress != address(0) &&
1297             openStakes[_contractAddress][_tokenId].ownerAddress != tokenOwner
1298         ){
1299             //stake exists, update owner
1300             uint i = 0;
1301             while(i < myActiveCollections[openStakes[_contractAddress][_tokenId].ownerAddress][_contractAddress].length){
1302                 if(myActiveCollections[openStakes[_contractAddress][_tokenId].ownerAddress][_contractAddress][i] == _tokenId){
1303                     //delete active collection
1304                     myActiveCollections[openStakes[_contractAddress][_tokenId].ownerAddress][_contractAddress][i] = myActiveCollections[openStakes[_contractAddress][_tokenId].ownerAddress][_contractAddress][myActiveCollections[openStakes[_contractAddress][_tokenId].ownerAddress][_contractAddress].length-1];
1305                     myActiveCollections[openStakes[_contractAddress][_tokenId].ownerAddress][_contractAddress].pop();
1306                 }
1307                 i++;
1308             }
1309             //update stake ownership
1310             myActiveCollections[tokenOwner][_contractAddress].push(_tokenId);
1311             openStakes[_contractAddress][_tokenId].ownerAddress = tokenOwner;
1312         }
1313         
1314     }
1315 
1316 
1317 
1318     /*
1319     * Withdraw by owner
1320     */
1321     function withdraw() external onlyOwner {
1322         (bool success, ) = payable(payoutWallet).call{value: address(this).balance}("");
1323         require(success, "Transfer failed.");
1324     }
1325 
1326 
1327     /*
1328     * These are here to receive ETH sent to the contract address
1329     */
1330     receive() external payable {}
1331 
1332     fallback() external payable {}
1333 
1334 }