1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Interface of the ERC165 standard, as defined in the
76  * https://eips.ethereum.org/EIPS/eip-165[EIP].
77  *
78  * Implementers can declare support of contract interfaces, which can then be
79  * queried by others ({ERC165Checker}).
80  *
81  * For an implementation, see {ERC165}.
82  */
83 interface IERC165 {
84     /**
85      * @dev Returns true if this contract implements the interface defined by
86      * `interfaceId`. See the corresponding
87      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
88      * to learn more about how these ids are created.
89      *
90      * This function call must use less than 30 000 gas.
91      */
92     function supportsInterface(bytes4 interfaceId) external view returns (bool);
93 }
94 
95 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Required interface of an ERC721 compliant contract.
105  */
106 interface IERC721 is IERC165 {
107     /**
108      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
111 
112     /**
113      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
114      */
115     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
119      */
120     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
121 
122     /**
123      * @dev Returns the number of tokens in ``owner``'s account.
124      */
125     function balanceOf(address owner) external view returns (uint256 balance);
126 
127     /**
128      * @dev Returns the owner of the `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function ownerOf(uint256 tokenId) external view returns (address owner);
135 
136     /**
137      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
138      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
139      *
140      * Requirements:
141      *
142      * - `from` cannot be the zero address.
143      * - `to` cannot be the zero address.
144      * - `tokenId` token must exist and be owned by `from`.
145      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
146      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
147      *
148      * Emits a {Transfer} event.
149      */
150     function safeTransferFrom(
151         address from,
152         address to,
153         uint256 tokenId
154     ) external;
155 
156     /**
157      * @dev Transfers `tokenId` token from `from` to `to`.
158      *
159      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must be owned by `from`.
166      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address from,
172         address to,
173         uint256 tokenId
174     ) external;
175 
176     /**
177      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
178      * The approval is cleared when the token is transferred.
179      *
180      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
181      *
182      * Requirements:
183      *
184      * - The caller must own the token or be an approved operator.
185      * - `tokenId` must exist.
186      *
187      * Emits an {Approval} event.
188      */
189     function approve(address to, uint256 tokenId) external;
190 
191     /**
192      * @dev Returns the account approved for `tokenId` token.
193      *
194      * Requirements:
195      *
196      * - `tokenId` must exist.
197      */
198     function getApproved(uint256 tokenId) external view returns (address operator);
199 
200     /**
201      * @dev Approve or remove `operator` as an operator for the caller.
202      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
203      *
204      * Requirements:
205      *
206      * - The `operator` cannot be the caller.
207      *
208      * Emits an {ApprovalForAll} event.
209      */
210     function setApprovalForAll(address operator, bool _approved) external;
211 
212     /**
213      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
214      *
215      * See {setApprovalForAll}
216      */
217     function isApprovedForAll(address owner, address operator) external view returns (bool);
218 
219     /**
220      * @dev Safely transfers `tokenId` token from `from` to `to`.
221      *
222      * Requirements:
223      *
224      * - `from` cannot be the zero address.
225      * - `to` cannot be the zero address.
226      * - `tokenId` token must exist and be owned by `from`.
227      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
228      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
229      *
230      * Emits a {Transfer} event.
231      */
232     function safeTransferFrom(
233         address from,
234         address to,
235         uint256 tokenId,
236         bytes calldata data
237     ) external;
238 }
239 
240 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
241 
242 
243 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev Interface of the ERC20 standard as defined in the EIP.
249  */
250 interface IERC20 {
251     /**
252      * @dev Returns the amount of tokens in existence.
253      */
254     function totalSupply() external view returns (uint256);
255 
256     /**
257      * @dev Returns the amount of tokens owned by `account`.
258      */
259     function balanceOf(address account) external view returns (uint256);
260 
261     /**
262      * @dev Moves `amount` tokens from the caller's account to `recipient`.
263      *
264      * Returns a boolean value indicating whether the operation succeeded.
265      *
266      * Emits a {Transfer} event.
267      */
268     function transfer(address recipient, uint256 amount) external returns (bool);
269 
270     /**
271      * @dev Returns the remaining number of tokens that `spender` will be
272      * allowed to spend on behalf of `owner` through {transferFrom}. This is
273      * zero by default.
274      *
275      * This value changes when {approve} or {transferFrom} are called.
276      */
277     function allowance(address owner, address spender) external view returns (uint256);
278 
279     /**
280      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
281      *
282      * Returns a boolean value indicating whether the operation succeeded.
283      *
284      * IMPORTANT: Beware that changing an allowance with this method brings the risk
285      * that someone may use both the old and the new allowance by unfortunate
286      * transaction ordering. One possible solution to mitigate this race
287      * condition is to first reduce the spender's allowance to 0 and set the
288      * desired value afterwards:
289      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290      *
291      * Emits an {Approval} event.
292      */
293     function approve(address spender, uint256 amount) external returns (bool);
294 
295     /**
296      * @dev Moves `amount` tokens from `sender` to `recipient` using the
297      * allowance mechanism. `amount` is then deducted from the caller's
298      * allowance.
299      *
300      * Returns a boolean value indicating whether the operation succeeded.
301      *
302      * Emits a {Transfer} event.
303      */
304     function transferFrom(
305         address sender,
306         address recipient,
307         uint256 amount
308     ) external returns (bool);
309 
310     /**
311      * @dev Emitted when `value` tokens are moved from one account (`from`) to
312      * another (`to`).
313      *
314      * Note that `value` may be zero.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 value);
317 
318     /**
319      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
320      * a call to {approve}. `value` is the new allowance.
321      */
322     event Approval(address indexed owner, address indexed spender, uint256 value);
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 
333 /**
334  * @dev Interface for the optional metadata functions from the ERC20 standard.
335  *
336  * _Available since v4.1._
337  */
338 interface IERC20Metadata is IERC20 {
339     /**
340      * @dev Returns the name of the token.
341      */
342     function name() external view returns (string memory);
343 
344     /**
345      * @dev Returns the symbol of the token.
346      */
347     function symbol() external view returns (string memory);
348 
349     /**
350      * @dev Returns the decimals places of the token.
351      */
352     function decimals() external view returns (uint8);
353 }
354 
355 // File: @openzeppelin/contracts/utils/Context.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Provides information about the current execution context, including the
364  * sender of the transaction and its data. While these are generally available
365  * via msg.sender and msg.data, they should not be accessed in such a direct
366  * manner, since when dealing with meta-transactions the account sending and
367  * paying for execution may not be the actual sender (as far as an application
368  * is concerned).
369  *
370  * This contract is only required for intermediate, library-like contracts.
371  */
372 abstract contract Context {
373     function _msgSender() internal view virtual returns (address) {
374         return msg.sender;
375     }
376 
377     function _msgData() internal view virtual returns (bytes calldata) {
378         return msg.data;
379     }
380 }
381 
382 // File: @openzeppelin/contracts/security/Pausable.sol
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Contract module which allows children to implement an emergency stop
392  * mechanism that can be triggered by an authorized account.
393  *
394  * This module is used through inheritance. It will make available the
395  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
396  * the functions of your contract. Note that they will not be pausable by
397  * simply including this module, only once the modifiers are put in place.
398  */
399 abstract contract Pausable is Context {
400     /**
401      * @dev Emitted when the pause is triggered by `account`.
402      */
403     event Paused(address account);
404 
405     /**
406      * @dev Emitted when the pause is lifted by `account`.
407      */
408     event Unpaused(address account);
409 
410     bool private _paused;
411 
412     /**
413      * @dev Initializes the contract in unpaused state.
414      */
415     constructor() {
416         _paused = false;
417     }
418 
419     /**
420      * @dev Returns true if the contract is paused, and false otherwise.
421      */
422     function paused() public view virtual returns (bool) {
423         return _paused;
424     }
425 
426     /**
427      * @dev Modifier to make a function callable only when the contract is not paused.
428      *
429      * Requirements:
430      *
431      * - The contract must not be paused.
432      */
433     modifier whenNotPaused() {
434         require(!paused(), "Pausable: paused");
435         _;
436     }
437 
438     /**
439      * @dev Modifier to make a function callable only when the contract is paused.
440      *
441      * Requirements:
442      *
443      * - The contract must be paused.
444      */
445     modifier whenPaused() {
446         require(paused(), "Pausable: not paused");
447         _;
448     }
449 
450     /**
451      * @dev Triggers stopped state.
452      *
453      * Requirements:
454      *
455      * - The contract must not be paused.
456      */
457     function _pause() internal virtual whenNotPaused {
458         _paused = true;
459         emit Paused(_msgSender());
460     }
461 
462     /**
463      * @dev Returns to normal state.
464      *
465      * Requirements:
466      *
467      * - The contract must be paused.
468      */
469     function _unpause() internal virtual whenPaused {
470         _paused = false;
471         emit Unpaused(_msgSender());
472     }
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 
483 
484 
485 /**
486  * @dev Implementation of the {IERC20} interface.
487  *
488  * This implementation is agnostic to the way tokens are created. This means
489  * that a supply mechanism has to be added in a derived contract using {_mint}.
490  * For a generic mechanism see {ERC20PresetMinterPauser}.
491  *
492  * TIP: For a detailed writeup see our guide
493  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
494  * to implement supply mechanisms].
495  *
496  * We have followed general OpenZeppelin Contracts guidelines: functions revert
497  * instead returning `false` on failure. This behavior is nonetheless
498  * conventional and does not conflict with the expectations of ERC20
499  * applications.
500  *
501  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
502  * This allows applications to reconstruct the allowance for all accounts just
503  * by listening to said events. Other implementations of the EIP may not emit
504  * these events, as it isn't required by the specification.
505  *
506  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
507  * functions have been added to mitigate the well-known issues around setting
508  * allowances. See {IERC20-approve}.
509  */
510 contract ERC20 is Context, IERC20, IERC20Metadata {
511     mapping(address => uint256) private _balances;
512 
513     mapping(address => mapping(address => uint256)) private _allowances;
514 
515     uint256 private _totalSupply;
516 
517     string private _name;
518     string private _symbol;
519 
520     /**
521      * @dev Sets the values for {name} and {symbol}.
522      *
523      * The default value of {decimals} is 18. To select a different value for
524      * {decimals} you should overload it.
525      *
526      * All two of these values are immutable: they can only be set once during
527      * construction.
528      */
529     constructor(string memory name_, string memory symbol_) {
530         _name = name_;
531         _symbol = symbol_;
532     }
533 
534     /**
535      * @dev Returns the name of the token.
536      */
537     function name() public view virtual override returns (string memory) {
538         return _name;
539     }
540 
541     /**
542      * @dev Returns the symbol of the token, usually a shorter version of the
543      * name.
544      */
545     function symbol() public view virtual override returns (string memory) {
546         return _symbol;
547     }
548 
549     /**
550      * @dev Returns the number of decimals used to get its user representation.
551      * For example, if `decimals` equals `2`, a balance of `505` tokens should
552      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
553      *
554      * Tokens usually opt for a value of 18, imitating the relationship between
555      * Ether and Wei. This is the value {ERC20} uses, unless this function is
556      * overridden;
557      *
558      * NOTE: This information is only used for _display_ purposes: it in
559      * no way affects any of the arithmetic of the contract, including
560      * {IERC20-balanceOf} and {IERC20-transfer}.
561      */
562     function decimals() public view virtual override returns (uint8) {
563         return 18;
564     }
565 
566     /**
567      * @dev See {IERC20-totalSupply}.
568      */
569     function totalSupply() public view virtual override returns (uint256) {
570         return _totalSupply;
571     }
572 
573     /**
574      * @dev See {IERC20-balanceOf}.
575      */
576     function balanceOf(address account) public view virtual override returns (uint256) {
577         return _balances[account];
578     }
579 
580     /**
581      * @dev See {IERC20-transfer}.
582      *
583      * Requirements:
584      *
585      * - `recipient` cannot be the zero address.
586      * - the caller must have a balance of at least `amount`.
587      */
588     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
589         _transfer(_msgSender(), recipient, amount);
590         return true;
591     }
592 
593     /**
594      * @dev See {IERC20-allowance}.
595      */
596     function allowance(address owner, address spender) public view virtual override returns (uint256) {
597         return _allowances[owner][spender];
598     }
599 
600     /**
601      * @dev See {IERC20-approve}.
602      *
603      * Requirements:
604      *
605      * - `spender` cannot be the zero address.
606      */
607     function approve(address spender, uint256 amount) public virtual override returns (bool) {
608         _approve(_msgSender(), spender, amount);
609         return true;
610     }
611 
612     /**
613      * @dev See {IERC20-transferFrom}.
614      *
615      * Emits an {Approval} event indicating the updated allowance. This is not
616      * required by the EIP. See the note at the beginning of {ERC20}.
617      *
618      * Requirements:
619      *
620      * - `sender` and `recipient` cannot be the zero address.
621      * - `sender` must have a balance of at least `amount`.
622      * - the caller must have allowance for ``sender``'s tokens of at least
623      * `amount`.
624      */
625     function transferFrom(
626         address sender,
627         address recipient,
628         uint256 amount
629     ) public virtual override returns (bool) {
630         _transfer(sender, recipient, amount);
631 
632         uint256 currentAllowance = _allowances[sender][_msgSender()];
633         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
634         unchecked {
635             _approve(sender, _msgSender(), currentAllowance - amount);
636         }
637 
638         return true;
639     }
640 
641     /**
642      * @dev Atomically increases the allowance granted to `spender` by the caller.
643      *
644      * This is an alternative to {approve} that can be used as a mitigation for
645      * problems described in {IERC20-approve}.
646      *
647      * Emits an {Approval} event indicating the updated allowance.
648      *
649      * Requirements:
650      *
651      * - `spender` cannot be the zero address.
652      */
653     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
654         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
655         return true;
656     }
657 
658     /**
659      * @dev Atomically decreases the allowance granted to `spender` by the caller.
660      *
661      * This is an alternative to {approve} that can be used as a mitigation for
662      * problems described in {IERC20-approve}.
663      *
664      * Emits an {Approval} event indicating the updated allowance.
665      *
666      * Requirements:
667      *
668      * - `spender` cannot be the zero address.
669      * - `spender` must have allowance for the caller of at least
670      * `subtractedValue`.
671      */
672     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
673         uint256 currentAllowance = _allowances[_msgSender()][spender];
674         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
675         unchecked {
676             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
677         }
678 
679         return true;
680     }
681 
682     /**
683      * @dev Moves `amount` of tokens from `sender` to `recipient`.
684      *
685      * This internal function is equivalent to {transfer}, and can be used to
686      * e.g. implement automatic token fees, slashing mechanisms, etc.
687      *
688      * Emits a {Transfer} event.
689      *
690      * Requirements:
691      *
692      * - `sender` cannot be the zero address.
693      * - `recipient` cannot be the zero address.
694      * - `sender` must have a balance of at least `amount`.
695      */
696     function _transfer(
697         address sender,
698         address recipient,
699         uint256 amount
700     ) internal virtual {
701         require(sender != address(0), "ERC20: transfer from the zero address");
702         require(recipient != address(0), "ERC20: transfer to the zero address");
703 
704         _beforeTokenTransfer(sender, recipient, amount);
705 
706         uint256 senderBalance = _balances[sender];
707         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
708         unchecked {
709             _balances[sender] = senderBalance - amount;
710         }
711         _balances[recipient] += amount;
712 
713         emit Transfer(sender, recipient, amount);
714 
715         _afterTokenTransfer(sender, recipient, amount);
716     }
717 
718     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
719      * the total supply.
720      *
721      * Emits a {Transfer} event with `from` set to the zero address.
722      *
723      * Requirements:
724      *
725      * - `account` cannot be the zero address.
726      */
727     function _mint(address account, uint256 amount) internal virtual {
728         require(account != address(0), "ERC20: mint to the zero address");
729 
730         _beforeTokenTransfer(address(0), account, amount);
731 
732         _totalSupply += amount;
733         _balances[account] += amount;
734         emit Transfer(address(0), account, amount);
735 
736         _afterTokenTransfer(address(0), account, amount);
737     }
738 
739     /**
740      * @dev Destroys `amount` tokens from `account`, reducing the
741      * total supply.
742      *
743      * Emits a {Transfer} event with `to` set to the zero address.
744      *
745      * Requirements:
746      *
747      * - `account` cannot be the zero address.
748      * - `account` must have at least `amount` tokens.
749      */
750     function _burn(address account, uint256 amount) internal virtual {
751         require(account != address(0), "ERC20: burn from the zero address");
752 
753         _beforeTokenTransfer(account, address(0), amount);
754 
755         uint256 accountBalance = _balances[account];
756         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
757         unchecked {
758             _balances[account] = accountBalance - amount;
759         }
760         _totalSupply -= amount;
761 
762         emit Transfer(account, address(0), amount);
763 
764         _afterTokenTransfer(account, address(0), amount);
765     }
766 
767     /**
768      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
769      *
770      * This internal function is equivalent to `approve`, and can be used to
771      * e.g. set automatic allowances for certain subsystems, etc.
772      *
773      * Emits an {Approval} event.
774      *
775      * Requirements:
776      *
777      * - `owner` cannot be the zero address.
778      * - `spender` cannot be the zero address.
779      */
780     function _approve(
781         address owner,
782         address spender,
783         uint256 amount
784     ) internal virtual {
785         require(owner != address(0), "ERC20: approve from the zero address");
786         require(spender != address(0), "ERC20: approve to the zero address");
787 
788         _allowances[owner][spender] = amount;
789         emit Approval(owner, spender, amount);
790     }
791 
792     /**
793      * @dev Hook that is called before any transfer of tokens. This includes
794      * minting and burning.
795      *
796      * Calling conditions:
797      *
798      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
799      * will be transferred to `to`.
800      * - when `from` is zero, `amount` tokens will be minted for `to`.
801      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
802      * - `from` and `to` are never both zero.
803      *
804      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
805      */
806     function _beforeTokenTransfer(
807         address from,
808         address to,
809         uint256 amount
810     ) internal virtual {}
811 
812     /**
813      * @dev Hook that is called after any transfer of tokens. This includes
814      * minting and burning.
815      *
816      * Calling conditions:
817      *
818      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
819      * has been transferred to `to`.
820      * - when `from` is zero, `amount` tokens have been minted for `to`.
821      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
822      * - `from` and `to` are never both zero.
823      *
824      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
825      */
826     function _afterTokenTransfer(
827         address from,
828         address to,
829         uint256 amount
830     ) internal virtual {}
831 }
832 
833 // File: @openzeppelin/contracts/access/Ownable.sol
834 
835 
836 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
837 
838 pragma solidity ^0.8.0;
839 
840 
841 /**
842  * @dev Contract module which provides a basic access control mechanism, where
843  * there is an account (an owner) that can be granted exclusive access to
844  * specific functions.
845  *
846  * By default, the owner account will be the one that deploys the contract. This
847  * can later be changed with {transferOwnership}.
848  *
849  * This module is used through inheritance. It will make available the modifier
850  * `onlyOwner`, which can be applied to your functions to restrict their use to
851  * the owner.
852  */
853 abstract contract Ownable is Context {
854     address private _owner;
855 
856     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
857 
858     /**
859      * @dev Initializes the contract setting the deployer as the initial owner.
860      */
861     constructor() {
862         _transferOwnership(_msgSender());
863     }
864 
865     /**
866      * @dev Returns the address of the current owner.
867      */
868     function owner() public view virtual returns (address) {
869         return _owner;
870     }
871 
872     /**
873      * @dev Throws if called by any account other than the owner.
874      */
875     modifier onlyOwner() {
876         require(owner() == _msgSender(), "Ownable: caller is not the owner");
877         _;
878     }
879 
880     /**
881      * @dev Leaves the contract without owner. It will not be possible to call
882      * `onlyOwner` functions anymore. Can only be called by the current owner.
883      *
884      * NOTE: Renouncing ownership will leave the contract without an owner,
885      * thereby removing any functionality that is only available to the owner.
886      */
887     function renounceOwnership() public virtual onlyOwner {
888         _transferOwnership(address(0));
889     }
890 
891     /**
892      * @dev Transfers ownership of the contract to a new account (`newOwner`).
893      * Can only be called by the current owner.
894      */
895     function transferOwnership(address newOwner) public virtual onlyOwner {
896         require(newOwner != address(0), "Ownable: new owner is the zero address");
897         _transferOwnership(newOwner);
898     }
899 
900     /**
901      * @dev Transfers ownership of the contract to a new account (`newOwner`).
902      * Internal function without access restriction.
903      */
904     function _transferOwnership(address newOwner) internal virtual {
905         address oldOwner = _owner;
906         _owner = newOwner;
907         emit OwnershipTransferred(oldOwner, newOwner);
908     }
909 }
910 
911 // File: contracts/WastelandStaking.sol
912 
913 //SPDX-License-Identifier: Unlicense
914 
915 pragma solidity ^0.8.0;
916 
917 
918 
919 
920 
921 
922 contract Dino is ERC20, Ownable, Pausable, ReentrancyGuard {
923     IERC721 public AngryDinos;
924 
925     uint256 constant public MAX_SUPPLY = type(uint256).max;
926     uint256 constant public MAX_PER_TX = 25;
927     uint256 constant public BASE_RATE = 10 ether;
928 
929     uint256 public totalStaked;
930     uint256 public totalClaimed;
931     mapping(address => uint256) public stash;
932     mapping(address => uint256) public lastUpdate;
933     mapping(uint256 => address) public tokenOwners;
934     mapping(address => mapping(uint256 => uint256)) public ownedTokens;
935     mapping(address => uint256) public stakedTokens;
936     mapping(address => uint256) public specialStakedTokens;
937     mapping (uint256 => bool) public specialTokens;
938     mapping(uint256 => uint256) public tokenIndex;
939     mapping(address => bool) public allowed;
940 
941     constructor(address angryDinos)
942         ERC20("DINO", "DINO")
943     {
944         AngryDinos = IERC721(angryDinos);
945         AngryDinos.setApprovalForAll(msg.sender, true);
946     }
947 
948     modifier onlyAllowed() {
949         require(allowed[msg.sender], "Caller not allowed");
950         _;
951     }
952 
953     modifier isApprovedForAll() {
954         require(
955             AngryDinos.isApprovedForAll(msg.sender, address(this)),
956             "Contract not approved"
957         );
958         _;
959     }
960 
961     function setSpecialTokens(uint256[] calldata tokenIds, bool state) public onlyOwner {
962         require(tokenIds.length > 0, "No tokens selected");
963 
964         for(uint256 i = 0; i < tokenIds.length; i++) {
965             specialTokens[tokenIds[i]] = state;
966         }
967     }
968 
969     /// @notice Get AngryDinos token ID by account and index
970     /// @param account The address of the token owner
971     /// @param index Index of the owned token
972     /// @return The token ID of the owned token at that index
973     function getOwnedByIndex(address account, uint256 index) public view returns (uint256) {
974         require(index < stakedTokens[account], "Nonexistent token");
975 
976         return ownedTokens[account][index];
977     }
978 
979     /// @notice Get amount of claimable DINO tokens
980     /// @param account The address to return claimable token amount for
981     /// @return The amount of claimable tokens
982     function getClaimable(address account) public view returns (uint256) {
983         return stash[account] + _getPending(account);
984     }
985 
986     function _getPending(address account) internal view returns (uint256) {
987         return (stakedTokens[account] + specialStakedTokens[account])
988         * BASE_RATE
989         * (block.timestamp - lastUpdate[account])
990         / 1 days;
991     }
992 
993     function _update(address account) internal {
994         stash[account] += _getPending(account);
995         lastUpdate[account] = block.timestamp;
996     }
997 
998     /// @notice Claim available DINO tokens
999     /// @param account The address to claim tokens for
1000     function claim(address account) public nonReentrant {
1001         _claim(account);
1002     }
1003 
1004     function _claim(address account) internal whenNotPaused {
1005         require(msg.sender == account || allowed[msg.sender], "Caller not allowed");
1006         require(totalClaimed < MAX_SUPPLY,                    "Max supply has been claimed");
1007 
1008         uint256 claimable = getClaimable(account);
1009         uint256 claimAmount = totalClaimed + claimable > MAX_SUPPLY
1010             ? MAX_SUPPLY - totalClaimed
1011             : claimable;
1012 
1013         _mint(account, claimAmount);
1014         stash[account] = 0;
1015         lastUpdate[account] = block.timestamp;
1016         totalClaimed += claimAmount;
1017     }
1018 
1019     /// @notice Remove AngryDinos tokens from staking contract and optionally collect DINO tokens
1020     /// @param account The address to change permissions for
1021     /// @param isAllowed Whether the address is allowed to use privileged functionality
1022     function setAllowed(address account, bool isAllowed) external onlyOwner {
1023         allowed[account] = isAllowed;
1024     }
1025 
1026     /// @notice Stake AngryDinos tokens
1027     /// @param tokenIds The tokens IDs to stake
1028     function stake(uint256[] calldata tokenIds) external isApprovedForAll whenNotPaused {
1029         require(tokenIds.length <= MAX_PER_TX, "Exceeds max tokens per transaction");
1030 
1031         _update(msg.sender);
1032 
1033         for (uint256 i = 0; i < tokenIds.length; i++) {
1034             require(AngryDinos.ownerOf(tokenIds[i]) == msg.sender, "Caller is not token owner");
1035 
1036             uint256 current = tokenIds[i];
1037 
1038             if(specialTokens[current]) {
1039                 specialStakedTokens[msg.sender] += 1;
1040             }
1041 
1042             tokenOwners[current] = msg.sender;
1043             tokenIndex[current] = stakedTokens[msg.sender];
1044             ownedTokens[msg.sender][tokenIndex[current]] = current;
1045             stakedTokens[msg.sender] += 1;
1046 
1047             AngryDinos.transferFrom(msg.sender, address(this), tokenIds[i]);
1048         }
1049 
1050         totalStaked += tokenIds.length;
1051     }
1052 
1053     /// @notice Remove AngryDinos tokens and optionally collect DINO tokens
1054     /// @param tokenIds The tokens IDs to unstake
1055     /// @param claimTokens Whether DINO tokens should be claimed
1056     function unstake(uint256[] calldata tokenIds, bool claimTokens) external nonReentrant {
1057         require(tokenIds.length <= MAX_PER_TX, "Exceeds max tokens per transaction");
1058 
1059         if (claimTokens) _claim(msg.sender);
1060         else _update(msg.sender);
1061 
1062         for (uint256 i = 0; i < tokenIds.length; i++) {
1063             require(tokenOwners[tokenIds[i]] == msg.sender, "Caller is not token owner");
1064 
1065             uint256 last = ownedTokens[msg.sender][stakedTokens[msg.sender] - 1];
1066 
1067             if(specialTokens[tokenIds[i]]) {
1068                 specialStakedTokens[msg.sender] -= 1;
1069             }
1070 
1071             tokenOwners[tokenIds[i]] = address(0);
1072             tokenIndex[last] = tokenIndex[tokenIds[i]];
1073             ownedTokens[msg.sender][tokenIndex[tokenIds[i]]] = last;
1074             stakedTokens[msg.sender] -= 1;
1075 
1076             AngryDinos.transferFrom(address(this), msg.sender, tokenIds[i]);
1077         }
1078 
1079         totalStaked -= tokenIds.length;
1080     }
1081 
1082     /// @notice Burn a specified amount of DINO tokens
1083     /// @dev Used only by contracts for extending token utility
1084     /// @param from The account to burn tokens from
1085     /// @param amount The amount of tokens to burn
1086     function burn(address from, uint256 amount) external onlyAllowed {
1087         _burn(from, amount);
1088     }
1089 
1090     /// @notice Mint a specified amount of DINO tokens
1091     /// @dev Used only by owner for creating treasury
1092     /// @param to The account to mint tokens to
1093     /// @param amount The amount of tokens to mint
1094     function mint(address to, uint256 amount) external onlyOwner {
1095         _mint(to, amount);
1096         totalClaimed += amount;
1097     }
1098 }