1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-22
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-01-22
7 */
8 
9 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
10 
11 
12 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Contract module that helps prevent reentrant calls to a function.
18  *
19  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
20  * available, which can be applied to functions to make sure there are no nested
21  * (reentrant) calls to them.
22  *
23  * Note that because there is a single `nonReentrant` guard, functions marked as
24  * `nonReentrant` may not call one another. This can be worked around by making
25  * those functions `private`, and then adding `external` `nonReentrant` entry
26  * points to them.
27  *
28  * TIP: If you would like to learn more about reentrancy and alternative ways
29  * to protect against it, check out our blog post
30  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
31  */
32 abstract contract ReentrancyGuard {
33     // Booleans are more expensive than uint256 or any type that takes up a full
34     // word because each write operation emits an extra SLOAD to first read the
35     // slot's contents, replace the bits taken up by the boolean, and then write
36     // back. This is the compiler's defense against contract upgrades and
37     // pointer aliasing, and it cannot be disabled.
38 
39     // The values being non-zero value makes deployment a bit more expensive,
40     // but in exchange the refund on every call to nonReentrant will be lower in
41     // amount. Since refunds are capped to a percentage of the total
42     // transaction's gas, it is best to keep them low in cases like this one, to
43     // increase the likelihood of the full refund coming into effect.
44     uint256 private constant _NOT_ENTERED = 1;
45     uint256 private constant _ENTERED = 2;
46 
47     uint256 private _status;
48 
49     constructor() {
50         _status = _NOT_ENTERED;
51     }
52 
53     /**
54      * @dev Prevents a contract from calling itself, directly or indirectly.
55      * Calling a `nonReentrant` function from another `nonReentrant`
56      * function is not supported. It is possible to prevent this from happening
57      * by making the `nonReentrant` function external, and making it call a
58      * `private` function that does the actual work.
59      */
60     modifier nonReentrant() {
61         // On the first call to nonReentrant, _notEntered will be true
62         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
63 
64         // Any calls to nonReentrant after this point will fail
65         _status = _ENTERED;
66 
67         _;
68 
69         // By storing the original value once again, a refund is triggered (see
70         // https://eips.ethereum.org/EIPS/eip-2200)
71         _status = _NOT_ENTERED;
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Interface of the ERC165 standard, as defined in the
84  * https://eips.ethereum.org/EIPS/eip-165[EIP].
85  *
86  * Implementers can declare support of contract interfaces, which can then be
87  * queried by others ({ERC165Checker}).
88  *
89  * For an implementation, see {ERC165}.
90  */
91 interface IERC165 {
92     /**
93      * @dev Returns true if this contract implements the interface defined by
94      * `interfaceId`. See the corresponding
95      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
96      * to learn more about how these ids are created.
97      *
98      * This function call must use less than 30 000 gas.
99      */
100     function supportsInterface(bytes4 interfaceId) external view returns (bool);
101 }
102 
103 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 
111 /**
112  * @dev Required interface of an ERC721 compliant contract.
113  */
114 interface IERC721 is IERC165 {
115     /**
116      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
117      */
118     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
119 
120     /**
121      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
122      */
123     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
124 
125     /**
126      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
127      */
128     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
129 
130     /**
131      * @dev Returns the number of tokens in ``owner``'s account.
132      */
133     function balanceOf(address owner) external view returns (uint256 balance);
134 
135     /**
136      * @dev Returns the owner of the `tokenId` token.
137      *
138      * Requirements:
139      *
140      * - `tokenId` must exist.
141      */
142     function ownerOf(uint256 tokenId) external view returns (address owner);
143 
144     /**
145      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
146      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId
162     ) external;
163 
164     /**
165      * @dev Transfers `tokenId` token from `from` to `to`.
166      *
167      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must be owned by `from`.
174      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transferFrom(
179         address from,
180         address to,
181         uint256 tokenId
182     ) external;
183 
184     /**
185      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
186      * The approval is cleared when the token is transferred.
187      *
188      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
189      *
190      * Requirements:
191      *
192      * - The caller must own the token or be an approved operator.
193      * - `tokenId` must exist.
194      *
195      * Emits an {Approval} event.
196      */
197     function approve(address to, uint256 tokenId) external;
198 
199     /**
200      * @dev Returns the account approved for `tokenId` token.
201      *
202      * Requirements:
203      *
204      * - `tokenId` must exist.
205      */
206     function getApproved(uint256 tokenId) external view returns (address operator);
207 
208     /**
209      * @dev Approve or remove `operator` as an operator for the caller.
210      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
211      *
212      * Requirements:
213      *
214      * - The `operator` cannot be the caller.
215      *
216      * Emits an {ApprovalForAll} event.
217      */
218     function setApprovalForAll(address operator, bool _approved) external;
219 
220     /**
221      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
222      *
223      * See {setApprovalForAll}
224      */
225     function isApprovedForAll(address owner, address operator) external view returns (bool);
226 
227     /**
228      * @dev Safely transfers `tokenId` token from `from` to `to`.
229      *
230      * Requirements:
231      *
232      * - `from` cannot be the zero address.
233      * - `to` cannot be the zero address.
234      * - `tokenId` token must exist and be owned by `from`.
235      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
236      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
237      *
238      * Emits a {Transfer} event.
239      */
240     function safeTransferFrom(
241         address from,
242         address to,
243         uint256 tokenId,
244         bytes calldata data
245     ) external;
246 }
247 
248 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
249 
250 
251 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @dev Interface of the ERC20 standard as defined in the EIP.
257  */
258 interface IERC20 {
259     /**
260      * @dev Returns the amount of tokens in existence.
261      */
262     function totalSupply() external view returns (uint256);
263 
264     /**
265      * @dev Returns the amount of tokens owned by `account`.
266      */
267     function balanceOf(address account) external view returns (uint256);
268 
269     /**
270      * @dev Moves `amount` tokens from the caller's account to `recipient`.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * Emits a {Transfer} event.
275      */
276     function transfer(address recipient, uint256 amount) external returns (bool);
277 
278     /**
279      * @dev Returns the remaining number of tokens that `spender` will be
280      * allowed to spend on behalf of `owner` through {transferFrom}. This is
281      * zero by default.
282      *
283      * This value changes when {approve} or {transferFrom} are called.
284      */
285     function allowance(address owner, address spender) external view returns (uint256);
286 
287     /**
288      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * IMPORTANT: Beware that changing an allowance with this method brings the risk
293      * that someone may use both the old and the new allowance by unfortunate
294      * transaction ordering. One possible solution to mitigate this race
295      * condition is to first reduce the spender's allowance to 0 and set the
296      * desired value afterwards:
297      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
298      *
299      * Emits an {Approval} event.
300      */
301     function approve(address spender, uint256 amount) external returns (bool);
302 
303     /**
304      * @dev Moves `amount` tokens from `sender` to `recipient` using the
305      * allowance mechanism. `amount` is then deducted from the caller's
306      * allowance.
307      *
308      * Returns a boolean value indicating whether the operation succeeded.
309      *
310      * Emits a {Transfer} event.
311      */
312     function transferFrom(
313         address sender,
314         address recipient,
315         uint256 amount
316     ) external returns (bool);
317 
318     /**
319      * @dev Emitted when `value` tokens are moved from one account (`from`) to
320      * another (`to`).
321      *
322      * Note that `value` may be zero.
323      */
324     event Transfer(address indexed from, address indexed to, uint256 value);
325 
326     /**
327      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
328      * a call to {approve}. `value` is the new allowance.
329      */
330     event Approval(address indexed owner, address indexed spender, uint256 value);
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @dev Interface for the optional metadata functions from the ERC20 standard.
343  *
344  * _Available since v4.1._
345  */
346 interface IERC20Metadata is IERC20 {
347     /**
348      * @dev Returns the name of the token.
349      */
350     function name() external view returns (string memory);
351 
352     /**
353      * @dev Returns the symbol of the token.
354      */
355     function symbol() external view returns (string memory);
356 
357     /**
358      * @dev Returns the decimals places of the token.
359      */
360     function decimals() external view returns (uint8);
361 }
362 
363 // File: @openzeppelin/contracts/utils/Context.sol
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev Provides information about the current execution context, including the
372  * sender of the transaction and its data. While these are generally available
373  * via msg.sender and msg.data, they should not be accessed in such a direct
374  * manner, since when dealing with meta-transactions the account sending and
375  * paying for execution may not be the actual sender (as far as an application
376  * is concerned).
377  *
378  * This contract is only required for intermediate, library-like contracts.
379  */
380 abstract contract Context {
381     function _msgSender() internal view virtual returns (address) {
382         return msg.sender;
383     }
384 
385     function _msgData() internal view virtual returns (bytes calldata) {
386         return msg.data;
387     }
388 }
389 
390 // File: @openzeppelin/contracts/security/Pausable.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 /**
399  * @dev Contract module which allows children to implement an emergency stop
400  * mechanism that can be triggered by an authorized account.
401  *
402  * This module is used through inheritance. It will make available the
403  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
404  * the functions of your contract. Note that they will not be pausable by
405  * simply including this module, only once the modifiers are put in place.
406  */
407 abstract contract Pausable is Context {
408     /**
409      * @dev Emitted when the pause is triggered by `account`.
410      */
411     event Paused(address account);
412 
413     /**
414      * @dev Emitted when the pause is lifted by `account`.
415      */
416     event Unpaused(address account);
417 
418     bool private _paused;
419 
420     /**
421      * @dev Initializes the contract in unpaused state.
422      */
423     constructor() {
424         _paused = false;
425     }
426 
427     /**
428      * @dev Returns true if the contract is paused, and false otherwise.
429      */
430     function paused() public view virtual returns (bool) {
431         return _paused;
432     }
433 
434     /**
435      * @dev Modifier to make a function callable only when the contract is not paused.
436      *
437      * Requirements:
438      *
439      * - The contract must not be paused.
440      */
441     modifier whenNotPaused() {
442         require(!paused(), "Pausable: paused");
443         _;
444     }
445 
446     /**
447      * @dev Modifier to make a function callable only when the contract is paused.
448      *
449      * Requirements:
450      *
451      * - The contract must be paused.
452      */
453     modifier whenPaused() {
454         require(paused(), "Pausable: not paused");
455         _;
456     }
457 
458     /**
459      * @dev Triggers stopped state.
460      *
461      * Requirements:
462      *
463      * - The contract must not be paused.
464      */
465     function _pause() internal virtual whenNotPaused {
466         _paused = true;
467         emit Paused(_msgSender());
468     }
469 
470     /**
471      * @dev Returns to normal state.
472      *
473      * Requirements:
474      *
475      * - The contract must be paused.
476      */
477     function _unpause() internal virtual whenPaused {
478         _paused = false;
479         emit Unpaused(_msgSender());
480     }
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 
491 
492 
493 /**
494  * @dev Implementation of the {IERC20} interface.
495  *
496  * This implementation is agnostic to the way tokens are created. This means
497  * that a supply mechanism has to be added in a derived contract using {_mint}.
498  * For a generic mechanism see {ERC20PresetMinterPauser}.
499  *
500  * TIP: For a detailed writeup see our guide
501  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
502  * to implement supply mechanisms].
503  *
504  * We have followed general OpenZeppelin Contracts guidelines: functions revert
505  * instead returning `false` on failure. This behavior is nonetheless
506  * conventional and does not conflict with the expectations of ERC20
507  * applications.
508  *
509  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
510  * This allows applications to reconstruct the allowance for all accounts just
511  * by listening to said events. Other implementations of the EIP may not emit
512  * these events, as it isn't required by the specification.
513  *
514  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
515  * functions have been added to mitigate the well-known issues around setting
516  * allowances. See {IERC20-approve}.
517  */
518 contract ERC20 is Context, IERC20, IERC20Metadata {
519     mapping(address => uint256) private _balances;
520 
521     mapping(address => mapping(address => uint256)) private _allowances;
522 
523     uint256 private _totalSupply;
524 
525     string private _name;
526     string private _symbol;
527 
528     /**
529      * @dev Sets the values for {name} and {symbol}.
530      *
531      * The default value of {decimals} is 18. To select a different value for
532      * {decimals} you should overload it.
533      *
534      * All two of these values are immutable: they can only be set once during
535      * construction.
536      */
537     constructor(string memory name_, string memory symbol_) {
538         _name = name_;
539         _symbol = symbol_;
540     }
541 
542     /**
543      * @dev Returns the name of the token.
544      */
545     function name() public view virtual override returns (string memory) {
546         return _name;
547     }
548 
549     /**
550      * @dev Returns the symbol of the token, usually a shorter version of the
551      * name.
552      */
553     function symbol() public view virtual override returns (string memory) {
554         return _symbol;
555     }
556 
557     /**
558      * @dev Returns the number of decimals used to get its user representation.
559      * For example, if `decimals` equals `2`, a balance of `505` tokens should
560      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
561      *
562      * Tokens usually opt for a value of 18, imitating the relationship between
563      * Ether and Wei. This is the value {ERC20} uses, unless this function is
564      * overridden;
565      *
566      * NOTE: This information is only used for _display_ purposes: it in
567      * no way affects any of the arithmetic of the contract, including
568      * {IERC20-balanceOf} and {IERC20-transfer}.
569      */
570     function decimals() public view virtual override returns (uint8) {
571         return 18;
572     }
573 
574     /**
575      * @dev See {IERC20-totalSupply}.
576      */
577     function totalSupply() public view virtual override returns (uint256) {
578         return _totalSupply;
579     }
580 
581     /**
582      * @dev See {IERC20-balanceOf}.
583      */
584     function balanceOf(address account) public view virtual override returns (uint256) {
585         return _balances[account];
586     }
587 
588     /**
589      * @dev See {IERC20-transfer}.
590      *
591      * Requirements:
592      *
593      * - `recipient` cannot be the zero address.
594      * - the caller must have a balance of at least `amount`.
595      */
596     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
597         _transfer(_msgSender(), recipient, amount);
598         return true;
599     }
600 
601     /**
602      * @dev See {IERC20-allowance}.
603      */
604     function allowance(address owner, address spender) public view virtual override returns (uint256) {
605         return _allowances[owner][spender];
606     }
607 
608     /**
609      * @dev See {IERC20-approve}.
610      *
611      * Requirements:
612      *
613      * - `spender` cannot be the zero address.
614      */
615     function approve(address spender, uint256 amount) public virtual override returns (bool) {
616         _approve(_msgSender(), spender, amount);
617         return true;
618     }
619 
620     /**
621      * @dev See {IERC20-transferFrom}.
622      *
623      * Emits an {Approval} event indicating the updated allowance. This is not
624      * required by the EIP. See the note at the beginning of {ERC20}.
625      *
626      * Requirements:
627      *
628      * - `sender` and `recipient` cannot be the zero address.
629      * - `sender` must have a balance of at least `amount`.
630      * - the caller must have allowance for ``sender``'s tokens of at least
631      * `amount`.
632      */
633     function transferFrom(
634         address sender,
635         address recipient,
636         uint256 amount
637     ) public virtual override returns (bool) {
638         _transfer(sender, recipient, amount);
639 
640         uint256 currentAllowance = _allowances[sender][_msgSender()];
641         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
642         unchecked {
643             _approve(sender, _msgSender(), currentAllowance - amount);
644         }
645 
646         return true;
647     }
648 
649     /**
650      * @dev Atomically increases the allowance granted to `spender` by the caller.
651      *
652      * This is an alternative to {approve} that can be used as a mitigation for
653      * problems described in {IERC20-approve}.
654      *
655      * Emits an {Approval} event indicating the updated allowance.
656      *
657      * Requirements:
658      *
659      * - `spender` cannot be the zero address.
660      */
661     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
662         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
663         return true;
664     }
665 
666     /**
667      * @dev Atomically decreases the allowance granted to `spender` by the caller.
668      *
669      * This is an alternative to {approve} that can be used as a mitigation for
670      * problems described in {IERC20-approve}.
671      *
672      * Emits an {Approval} event indicating the updated allowance.
673      *
674      * Requirements:
675      *
676      * - `spender` cannot be the zero address.
677      * - `spender` must have allowance for the caller of at least
678      * `subtractedValue`.
679      */
680     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
681         uint256 currentAllowance = _allowances[_msgSender()][spender];
682         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
683         unchecked {
684             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
685         }
686 
687         return true;
688     }
689 
690     /**
691      * @dev Moves `amount` of tokens from `sender` to `recipient`.
692      *
693      * This internal function is equivalent to {transfer}, and can be used to
694      * e.g. implement automatic token fees, slashing mechanisms, etc.
695      *
696      * Emits a {Transfer} event.
697      *
698      * Requirements:
699      *
700      * - `sender` cannot be the zero address.
701      * - `recipient` cannot be the zero address.
702      * - `sender` must have a balance of at least `amount`.
703      */
704     function _transfer(
705         address sender,
706         address recipient,
707         uint256 amount
708     ) internal virtual {
709         require(sender != address(0), "ERC20: transfer from the zero address");
710         require(recipient != address(0), "ERC20: transfer to the zero address");
711 
712         _beforeTokenTransfer(sender, recipient, amount);
713 
714         uint256 senderBalance = _balances[sender];
715         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
716         unchecked {
717             _balances[sender] = senderBalance - amount;
718         }
719         _balances[recipient] += amount;
720 
721         emit Transfer(sender, recipient, amount);
722 
723         _afterTokenTransfer(sender, recipient, amount);
724     }
725 
726     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
727      * the total supply.
728      *
729      * Emits a {Transfer} event with `from` set to the zero address.
730      *
731      * Requirements:
732      *
733      * - `account` cannot be the zero address.
734      */
735     function _mint(address account, uint256 amount) internal virtual {
736         require(account != address(0), "ERC20: mint to the zero address");
737 
738         _beforeTokenTransfer(address(0), account, amount);
739 
740         _totalSupply += amount;
741         _balances[account] += amount;
742         emit Transfer(address(0), account, amount);
743 
744         _afterTokenTransfer(address(0), account, amount);
745     }
746 
747     /**
748      * @dev Destroys `amount` tokens from `account`, reducing the
749      * total supply.
750      *
751      * Emits a {Transfer} event with `to` set to the zero address.
752      *
753      * Requirements:
754      *
755      * - `account` cannot be the zero address.
756      * - `account` must have at least `amount` tokens.
757      */
758     function _burn(address account, uint256 amount) internal virtual {
759         require(account != address(0), "ERC20: burn from the zero address");
760 
761         _beforeTokenTransfer(account, address(0), amount);
762 
763         uint256 accountBalance = _balances[account];
764         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
765         unchecked {
766             _balances[account] = accountBalance - amount;
767         }
768         _totalSupply -= amount;
769 
770         emit Transfer(account, address(0), amount);
771 
772         _afterTokenTransfer(account, address(0), amount);
773     }
774 
775     /**
776      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
777      *
778      * This internal function is equivalent to `approve`, and can be used to
779      * e.g. set automatic allowances for certain subsystems, etc.
780      *
781      * Emits an {Approval} event.
782      *
783      * Requirements:
784      *
785      * - `owner` cannot be the zero address.
786      * - `spender` cannot be the zero address.
787      */
788     function _approve(
789         address owner,
790         address spender,
791         uint256 amount
792     ) internal virtual {
793         require(owner != address(0), "ERC20: approve from the zero address");
794         require(spender != address(0), "ERC20: approve to the zero address");
795 
796         _allowances[owner][spender] = amount;
797         emit Approval(owner, spender, amount);
798     }
799 
800     /**
801      * @dev Hook that is called before any transfer of tokens. This includes
802      * minting and burning.
803      *
804      * Calling conditions:
805      *
806      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
807      * will be transferred to `to`.
808      * - when `from` is zero, `amount` tokens will be minted for `to`.
809      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
810      * - `from` and `to` are never both zero.
811      *
812      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
813      */
814     function _beforeTokenTransfer(
815         address from,
816         address to,
817         uint256 amount
818     ) internal virtual {}
819 
820     /**
821      * @dev Hook that is called after any transfer of tokens. This includes
822      * minting and burning.
823      *
824      * Calling conditions:
825      *
826      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
827      * has been transferred to `to`.
828      * - when `from` is zero, `amount` tokens have been minted for `to`.
829      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
830      * - `from` and `to` are never both zero.
831      *
832      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
833      */
834     function _afterTokenTransfer(
835         address from,
836         address to,
837         uint256 amount
838     ) internal virtual {}
839 }
840 
841 // File: @openzeppelin/contracts/access/Ownable.sol
842 
843 
844 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
845 
846 pragma solidity ^0.8.0;
847 
848 
849 /**
850  * @dev Contract module which provides a basic access control mechanism, where
851  * there is an account (an owner) that can be granted exclusive access to
852  * specific functions.
853  *
854  * By default, the owner account will be the one that deploys the contract. This
855  * can later be changed with {transferOwnership}.
856  *
857  * This module is used through inheritance. It will make available the modifier
858  * `onlyOwner`, which can be applied to your functions to restrict their use to
859  * the owner.
860  */
861 abstract contract Ownable is Context {
862     address private _owner;
863 
864     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
865 
866     /**
867      * @dev Initializes the contract setting the deployer as the initial owner.
868      */
869     constructor() {
870         _transferOwnership(_msgSender());
871     }
872 
873     /**
874      * @dev Returns the address of the current owner.
875      */
876     function owner() public view virtual returns (address) {
877         return _owner;
878     }
879 
880     /**
881      * @dev Throws if called by any account other than the owner.
882      */
883     modifier onlyOwner() {
884         require(owner() == _msgSender(), "Ownable: caller is not the owner");
885         _;
886     }
887 
888     /**
889      * @dev Leaves the contract without owner. It will not be possible to call
890      * `onlyOwner` functions anymore. Can only be called by the current owner.
891      *
892      * NOTE: Renouncing ownership will leave the contract without an owner,
893      * thereby removing any functionality that is only available to the owner.
894      */
895     function renounceOwnership() public virtual onlyOwner {
896         _transferOwnership(address(0));
897     }
898 
899     /**
900      * @dev Transfers ownership of the contract to a new account (`newOwner`).
901      * Can only be called by the current owner.
902      */
903     function transferOwnership(address newOwner) public virtual onlyOwner {
904         require(newOwner != address(0), "Ownable: new owner is the zero address");
905         _transferOwnership(newOwner);
906     }
907 
908     /**
909      * @dev Transfers ownership of the contract to a new account (`newOwner`).
910      * Internal function without access restriction.
911      */
912     function _transferOwnership(address newOwner) internal virtual {
913         address oldOwner = _owner;
914         _owner = newOwner;
915         emit OwnershipTransferred(oldOwner, newOwner);
916     }
917 }
918 
919 // File: contracts/WastelandStaking.sol
920 
921 //SPDX-License-Identifier: Unlicense
922 
923 pragma solidity ^0.8.0;
924 
925 
926 
927 
928 
929 
930 contract NftNinjasStaking is ERC20, Ownable, Pausable, ReentrancyGuard {
931     IERC721 public NftNinjas;
932 
933     uint256 constant public MAX_SUPPLY = type(uint256).max;
934     uint256 constant public MAX_PER_TX = 25;
935     uint256 constant public BASE_RATE = 100 ether;
936 
937     uint256 public totalStaked;
938     uint256 public totalClaimed;
939     mapping(address => uint256) public stash;
940     mapping(address => uint256) public lastUpdate;
941     mapping(uint256 => address) public tokenOwners;
942     mapping(address => mapping(uint256 => uint256)) public ownedTokens;
943     mapping(address => uint256) public stakedTokens;
944     mapping(address => uint256) public specialStakedTokens;
945     mapping (uint256 => bool) public specialTokens;
946     mapping(uint256 => uint256) public tokenIndex;
947     mapping(address => bool) public allowed;
948 
949     constructor(address nftNinjas)
950         ERC20("STEALTH", "STEALTH")
951     {
952         NftNinjas = IERC721(nftNinjas);
953         NftNinjas.setApprovalForAll(msg.sender, true);
954     }
955 
956     modifier onlyAllowed() {
957         require(allowed[msg.sender], "Caller not allowed");
958         _;
959     }
960 
961     modifier isApprovedForAll() {
962         require(
963             NftNinjas.isApprovedForAll(msg.sender, address(this)),
964             "Contract not approved"
965         );
966         _;
967     }
968 
969     function setSpecialTokens(uint256[] calldata tokenIds, bool state) public onlyOwner {
970         require(tokenIds.length > 0, "No tokens selected");
971 
972         for(uint256 i = 0; i < tokenIds.length; i++) {
973             specialTokens[tokenIds[i]] = state;
974         }
975     }
976 
977     /// @notice Get NFTNINJAS token ID by account and index
978     /// @param account The address of the token owner
979     /// @param index Index of the owned token
980     /// @return The token ID of the owned token at that index
981     function getOwnedByIndex(address account, uint256 index) public view returns (uint256) {
982         require(index < stakedTokens[account], "Nonexistent token");
983 
984         return ownedTokens[account][index];
985     }
986 
987     /// @notice Get amount of claimable STEALTH tokens
988     /// @param account The address to return claimable token amount for
989     /// @return The amount of claimable tokens
990     function getClaimable(address account) public view returns (uint256) {
991         return stash[account] + _getPending(account);
992     }
993 
994     function _getPending(address account) internal view returns (uint256) {
995         return (stakedTokens[account] + specialStakedTokens[account])
996         * BASE_RATE
997         * (block.timestamp - lastUpdate[account])
998         / 1 days;
999     }
1000 
1001     function _update(address account) internal {
1002         stash[account] += _getPending(account);
1003         lastUpdate[account] = block.timestamp;
1004     }
1005 
1006     /// @notice Claim available STEALTH tokens
1007     /// @param account The address to claim tokens for
1008     function claim(address account) public nonReentrant {
1009         _claim(account);
1010     }
1011 
1012     function _claim(address account) internal whenNotPaused {
1013         require(msg.sender == account || allowed[msg.sender], "Caller not allowed");
1014         require(totalClaimed < MAX_SUPPLY,                    "Max supply has been claimed");
1015 
1016         uint256 claimable = getClaimable(account);
1017         uint256 claimAmount = totalClaimed + claimable > MAX_SUPPLY
1018             ? MAX_SUPPLY - totalClaimed
1019             : claimable;
1020 
1021         _mint(account, claimAmount);
1022         stash[account] = 0;
1023         lastUpdate[account] = block.timestamp;
1024         totalClaimed += claimAmount;
1025     }
1026 
1027     /// @notice Remove NFTNINJAS tokens from staking contract and optionally collect STEALTH tokens
1028     /// @param account The address to change permissions for
1029     /// @param isAllowed Whether the address is allowed to use privileged functionality
1030     function setAllowed(address account, bool isAllowed) external onlyOwner {
1031         allowed[account] = isAllowed;
1032     }
1033 
1034     /// @notice Stake NFTNINJAS tokens
1035     /// @param tokenIds The tokens IDs to stake
1036     function stake(uint256[] calldata tokenIds) external isApprovedForAll whenNotPaused {
1037         require(tokenIds.length <= MAX_PER_TX, "Exceeds max tokens per transaction");
1038 
1039         _update(msg.sender);
1040 
1041         for (uint256 i = 0; i < tokenIds.length; i++) {
1042             require(NftNinjas.ownerOf(tokenIds[i]) == msg.sender, "Caller is not token owner");
1043 
1044             uint256 current = tokenIds[i];
1045 
1046             if(specialTokens[current]) {
1047                 specialStakedTokens[msg.sender] += 1;
1048             }
1049 
1050             tokenOwners[current] = msg.sender;
1051             tokenIndex[current] = stakedTokens[msg.sender];
1052             ownedTokens[msg.sender][tokenIndex[current]] = current;
1053             stakedTokens[msg.sender] += 1;
1054 
1055             NftNinjas.transferFrom(msg.sender, address(this), tokenIds[i]);
1056         }
1057 
1058         totalStaked += tokenIds.length;
1059     }
1060 
1061     /// @notice Remove NFTNINJAS tokens and optionally collect STEALTH tokens
1062     /// @param tokenIds The tokens IDs to unstake
1063     /// @param claimTokens Whether STEALTH tokens should be claimed
1064     function unstake(uint256[] calldata tokenIds, bool claimTokens) external nonReentrant {
1065         require(tokenIds.length <= MAX_PER_TX, "Exceeds max tokens per transaction");
1066 
1067         if (claimTokens) _claim(msg.sender);
1068         else _update(msg.sender);
1069 
1070         for (uint256 i = 0; i < tokenIds.length; i++) {
1071             require(tokenOwners[tokenIds[i]] == msg.sender, "Caller is not token owner");
1072 
1073             uint256 last = ownedTokens[msg.sender][stakedTokens[msg.sender] - 1];
1074 
1075             if(specialTokens[tokenIds[i]]) {
1076                 specialStakedTokens[msg.sender] -= 1;
1077             }
1078 
1079             tokenOwners[tokenIds[i]] = address(0);
1080             tokenIndex[last] = tokenIndex[tokenIds[i]];
1081             ownedTokens[msg.sender][tokenIndex[tokenIds[i]]] = last;
1082             stakedTokens[msg.sender] -= 1;
1083 
1084             NftNinjas.transferFrom(address(this), msg.sender, tokenIds[i]);
1085         }
1086 
1087         totalStaked -= tokenIds.length;
1088     }
1089 
1090     /// @notice Burn a specified amount of STEALTH tokens
1091     /// @dev Used only by contracts for extending token utility
1092     /// @param from The account to burn tokens from
1093     /// @param amount The amount of tokens to burn
1094     function burn(address from, uint256 amount) external onlyAllowed {
1095         _burn(from, amount);
1096     }
1097 
1098     /// @notice Mint a specified amount of STEALTH tokens
1099     /// @dev Used only by owner for creating treasury
1100     /// @param to The account to mint tokens to
1101     /// @param amount The amount of tokens to mint
1102     function mint(address to, uint256 amount) external onlyOwner {
1103         _mint(to, amount);
1104         totalClaimed += amount;
1105     }
1106 }