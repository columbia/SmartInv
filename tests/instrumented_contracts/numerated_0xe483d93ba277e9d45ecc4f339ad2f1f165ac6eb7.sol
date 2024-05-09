1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId,
87         bytes calldata data
88     ) external;
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 }
173 
174 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @title ERC721 token receiver interface
183  * @dev Interface for any contract that wants to support safeTransfers
184  * from ERC721 asset contracts.
185  */
186 interface IERC721Receiver {
187     /**
188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
189      * by `operator` from `from`, this function is called.
190      *
191      * It must return its Solidity selector to confirm the token transfer.
192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
193      *
194      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
195      */
196     function onERC721Received(
197         address operator,
198         address from,
199         uint256 tokenId,
200         bytes calldata data
201     ) external returns (bytes4);
202 }
203 
204 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
205 
206 
207 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 
212 /**
213  * @dev Implementation of the {IERC721Receiver} interface.
214  *
215  * Accepts all token transfers.
216  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
217  */
218 contract ERC721Holder is IERC721Receiver {
219     /**
220      * @dev See {IERC721Receiver-onERC721Received}.
221      *
222      * Always returns `IERC721Receiver.onERC721Received.selector`.
223      */
224     function onERC721Received(
225         address,
226         address,
227         uint256,
228         bytes memory
229     ) public virtual override returns (bytes4) {
230         return this.onERC721Received.selector;
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Context.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Provides information about the current execution context, including the
243  * sender of the transaction and its data. While these are generally available
244  * via msg.sender and msg.data, they should not be accessed in such a direct
245  * manner, since when dealing with meta-transactions the account sending and
246  * paying for execution may not be the actual sender (as far as an application
247  * is concerned).
248  *
249  * This contract is only required for intermediate, library-like contracts.
250  */
251 abstract contract Context {
252     function _msgSender() internal view virtual returns (address) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view virtual returns (bytes calldata) {
257         return msg.data;
258     }
259 }
260 
261 // File: @openzeppelin/contracts/access/Ownable.sol
262 
263 
264 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
265 
266 pragma solidity ^0.8.0;
267 
268 
269 /**
270  * @dev Contract module which provides a basic access control mechanism, where
271  * there is an account (an owner) that can be granted exclusive access to
272  * specific functions.
273  *
274  * By default, the owner account will be the one that deploys the contract. This
275  * can later be changed with {transferOwnership}.
276  *
277  * This module is used through inheritance. It will make available the modifier
278  * `onlyOwner`, which can be applied to your functions to restrict their use to
279  * the owner.
280  */
281 abstract contract Ownable is Context {
282     address private _owner;
283 
284     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286     /**
287      * @dev Initializes the contract setting the deployer as the initial owner.
288      */
289     constructor() {
290         _transferOwnership(_msgSender());
291     }
292 
293     /**
294      * @dev Throws if called by any account other than the owner.
295      */
296     modifier onlyOwner() {
297         _checkOwner();
298         _;
299     }
300 
301     /**
302      * @dev Returns the address of the current owner.
303      */
304     function owner() public view virtual returns (address) {
305         return _owner;
306     }
307 
308     /**
309      * @dev Throws if the sender is not the owner.
310      */
311     function _checkOwner() internal view virtual {
312         require(owner() == _msgSender(), "Ownable: caller is not the owner");
313     }
314 
315     /**
316      * @dev Leaves the contract without owner. It will not be possible to call
317      * `onlyOwner` functions anymore. Can only be called by the current owner.
318      *
319      * NOTE: Renouncing ownership will leave the contract without an owner,
320      * thereby removing any functionality that is only available to the owner.
321      */
322     function renounceOwnership() public virtual onlyOwner {
323         _transferOwnership(address(0));
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Can only be called by the current owner.
329      */
330     function transferOwnership(address newOwner) public virtual onlyOwner {
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332         _transferOwnership(newOwner);
333     }
334 
335     /**
336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
337      * Internal function without access restriction.
338      */
339     function _transferOwnership(address newOwner) internal virtual {
340         address oldOwner = _owner;
341         _owner = newOwner;
342         emit OwnershipTransferred(oldOwner, newOwner);
343     }
344 }
345 
346 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
347 
348 
349 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @dev Interface of the ERC20 standard as defined in the EIP.
355  */
356 interface IERC20 {
357     /**
358      * @dev Emitted when `value` tokens are moved from one account (`from`) to
359      * another (`to`).
360      *
361      * Note that `value` may be zero.
362      */
363     event Transfer(address indexed from, address indexed to, uint256 value);
364 
365     /**
366      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
367      * a call to {approve}. `value` is the new allowance.
368      */
369     event Approval(address indexed owner, address indexed spender, uint256 value);
370 
371     /**
372      * @dev Returns the amount of tokens in existence.
373      */
374     function totalSupply() external view returns (uint256);
375 
376     /**
377      * @dev Returns the amount of tokens owned by `account`.
378      */
379     function balanceOf(address account) external view returns (uint256);
380 
381     /**
382      * @dev Moves `amount` tokens from the caller's account to `to`.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transfer(address to, uint256 amount) external returns (bool);
389 
390     /**
391      * @dev Returns the remaining number of tokens that `spender` will be
392      * allowed to spend on behalf of `owner` through {transferFrom}. This is
393      * zero by default.
394      *
395      * This value changes when {approve} or {transferFrom} are called.
396      */
397     function allowance(address owner, address spender) external view returns (uint256);
398 
399     /**
400      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * IMPORTANT: Beware that changing an allowance with this method brings the risk
405      * that someone may use both the old and the new allowance by unfortunate
406      * transaction ordering. One possible solution to mitigate this race
407      * condition is to first reduce the spender's allowance to 0 and set the
408      * desired value afterwards:
409      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
410      *
411      * Emits an {Approval} event.
412      */
413     function approve(address spender, uint256 amount) external returns (bool);
414 
415     /**
416      * @dev Moves `amount` tokens from `from` to `to` using the
417      * allowance mechanism. `amount` is then deducted from the caller's
418      * allowance.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * Emits a {Transfer} event.
423      */
424     function transferFrom(
425         address from,
426         address to,
427         uint256 amount
428     ) external returns (bool);
429 }
430 
431 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 
439 /**
440  * @dev Interface for the optional metadata functions from the ERC20 standard.
441  *
442  * _Available since v4.1._
443  */
444 interface IERC20Metadata is IERC20 {
445     /**
446      * @dev Returns the name of the token.
447      */
448     function name() external view returns (string memory);
449 
450     /**
451      * @dev Returns the symbol of the token.
452      */
453     function symbol() external view returns (string memory);
454 
455     /**
456      * @dev Returns the decimals places of the token.
457      */
458     function decimals() external view returns (uint8);
459 }
460 
461 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
462 
463 
464 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 
470 
471 /**
472  * @dev Implementation of the {IERC20} interface.
473  *
474  * This implementation is agnostic to the way tokens are created. This means
475  * that a supply mechanism has to be added in a derived contract using {_mint}.
476  * For a generic mechanism see {ERC20PresetMinterPauser}.
477  *
478  * TIP: For a detailed writeup see our guide
479  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
480  * to implement supply mechanisms].
481  *
482  * We have followed general OpenZeppelin Contracts guidelines: functions revert
483  * instead returning `false` on failure. This behavior is nonetheless
484  * conventional and does not conflict with the expectations of ERC20
485  * applications.
486  *
487  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
488  * This allows applications to reconstruct the allowance for all accounts just
489  * by listening to said events. Other implementations of the EIP may not emit
490  * these events, as it isn't required by the specification.
491  *
492  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
493  * functions have been added to mitigate the well-known issues around setting
494  * allowances. See {IERC20-approve}.
495  */
496 contract ERC20 is Context, IERC20, IERC20Metadata {
497     mapping(address => uint256) private _balances;
498 
499     mapping(address => mapping(address => uint256)) private _allowances;
500 
501     uint256 private _totalSupply;
502 
503     string private _name;
504     string private _symbol;
505 
506     /**
507      * @dev Sets the values for {name} and {symbol}.
508      *
509      * The default value of {decimals} is 18. To select a different value for
510      * {decimals} you should overload it.
511      *
512      * All two of these values are immutable: they can only be set once during
513      * construction.
514      */
515     constructor(string memory name_, string memory symbol_) {
516         _name = name_;
517         _symbol = symbol_;
518     }
519 
520     /**
521      * @dev Returns the name of the token.
522      */
523     function name() public view virtual override returns (string memory) {
524         return _name;
525     }
526 
527     /**
528      * @dev Returns the symbol of the token, usually a shorter version of the
529      * name.
530      */
531     function symbol() public view virtual override returns (string memory) {
532         return _symbol;
533     }
534 
535     /**
536      * @dev Returns the number of decimals used to get its user representation.
537      * For example, if `decimals` equals `2`, a balance of `505` tokens should
538      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
539      *
540      * Tokens usually opt for a value of 18, imitating the relationship between
541      * Ether and Wei. This is the value {ERC20} uses, unless this function is
542      * overridden;
543      *
544      * NOTE: This information is only used for _display_ purposes: it in
545      * no way affects any of the arithmetic of the contract, including
546      * {IERC20-balanceOf} and {IERC20-transfer}.
547      */
548     function decimals() public view virtual override returns (uint8) {
549         return 18;
550     }
551 
552     /**
553      * @dev See {IERC20-totalSupply}.
554      */
555     function totalSupply() public view virtual override returns (uint256) {
556         return _totalSupply;
557     }
558 
559     /**
560      * @dev See {IERC20-balanceOf}.
561      */
562     function balanceOf(address account) public view virtual override returns (uint256) {
563         return _balances[account];
564     }
565 
566     /**
567      * @dev See {IERC20-transfer}.
568      *
569      * Requirements:
570      *
571      * - `to` cannot be the zero address.
572      * - the caller must have a balance of at least `amount`.
573      */
574     function transfer(address to, uint256 amount) public virtual override returns (bool) {
575         address owner = _msgSender();
576         _transfer(owner, to, amount);
577         return true;
578     }
579 
580     /**
581      * @dev See {IERC20-allowance}.
582      */
583     function allowance(address owner, address spender) public view virtual override returns (uint256) {
584         return _allowances[owner][spender];
585     }
586 
587     /**
588      * @dev See {IERC20-approve}.
589      *
590      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
591      * `transferFrom`. This is semantically equivalent to an infinite approval.
592      *
593      * Requirements:
594      *
595      * - `spender` cannot be the zero address.
596      */
597     function approve(address spender, uint256 amount) public virtual override returns (bool) {
598         address owner = _msgSender();
599         _approve(owner, spender, amount);
600         return true;
601     }
602 
603     /**
604      * @dev See {IERC20-transferFrom}.
605      *
606      * Emits an {Approval} event indicating the updated allowance. This is not
607      * required by the EIP. See the note at the beginning of {ERC20}.
608      *
609      * NOTE: Does not update the allowance if the current allowance
610      * is the maximum `uint256`.
611      *
612      * Requirements:
613      *
614      * - `from` and `to` cannot be the zero address.
615      * - `from` must have a balance of at least `amount`.
616      * - the caller must have allowance for ``from``'s tokens of at least
617      * `amount`.
618      */
619     function transferFrom(
620         address from,
621         address to,
622         uint256 amount
623     ) public virtual override returns (bool) {
624         address spender = _msgSender();
625         _spendAllowance(from, spender, amount);
626         _transfer(from, to, amount);
627         return true;
628     }
629 
630     /**
631      * @dev Atomically increases the allowance granted to `spender` by the caller.
632      *
633      * This is an alternative to {approve} that can be used as a mitigation for
634      * problems described in {IERC20-approve}.
635      *
636      * Emits an {Approval} event indicating the updated allowance.
637      *
638      * Requirements:
639      *
640      * - `spender` cannot be the zero address.
641      */
642     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
643         address owner = _msgSender();
644         _approve(owner, spender, allowance(owner, spender) + addedValue);
645         return true;
646     }
647 
648     /**
649      * @dev Atomically decreases the allowance granted to `spender` by the caller.
650      *
651      * This is an alternative to {approve} that can be used as a mitigation for
652      * problems described in {IERC20-approve}.
653      *
654      * Emits an {Approval} event indicating the updated allowance.
655      *
656      * Requirements:
657      *
658      * - `spender` cannot be the zero address.
659      * - `spender` must have allowance for the caller of at least
660      * `subtractedValue`.
661      */
662     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
663         address owner = _msgSender();
664         uint256 currentAllowance = allowance(owner, spender);
665         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
666         unchecked {
667             _approve(owner, spender, currentAllowance - subtractedValue);
668         }
669 
670         return true;
671     }
672 
673     /**
674      * @dev Moves `amount` of tokens from `from` to `to`.
675      *
676      * This internal function is equivalent to {transfer}, and can be used to
677      * e.g. implement automatic token fees, slashing mechanisms, etc.
678      *
679      * Emits a {Transfer} event.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `from` must have a balance of at least `amount`.
686      */
687     function _transfer(
688         address from,
689         address to,
690         uint256 amount
691     ) internal virtual {
692         require(from != address(0), "ERC20: transfer from the zero address");
693         require(to != address(0), "ERC20: transfer to the zero address");
694 
695         _beforeTokenTransfer(from, to, amount);
696 
697         uint256 fromBalance = _balances[from];
698         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
699         unchecked {
700             _balances[from] = fromBalance - amount;
701         }
702         _balances[to] += amount;
703 
704         emit Transfer(from, to, amount);
705 
706         _afterTokenTransfer(from, to, amount);
707     }
708 
709     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
710      * the total supply.
711      *
712      * Emits a {Transfer} event with `from` set to the zero address.
713      *
714      * Requirements:
715      *
716      * - `account` cannot be the zero address.
717      */
718     function _mint(address account, uint256 amount) internal virtual {
719         require(account != address(0), "ERC20: mint to the zero address");
720 
721         _beforeTokenTransfer(address(0), account, amount);
722 
723         _totalSupply += amount;
724         _balances[account] += amount;
725         emit Transfer(address(0), account, amount);
726 
727         _afterTokenTransfer(address(0), account, amount);
728     }
729 
730     /**
731      * @dev Destroys `amount` tokens from `account`, reducing the
732      * total supply.
733      *
734      * Emits a {Transfer} event with `to` set to the zero address.
735      *
736      * Requirements:
737      *
738      * - `account` cannot be the zero address.
739      * - `account` must have at least `amount` tokens.
740      */
741     function _burn(address account, uint256 amount) internal virtual {
742         require(account != address(0), "ERC20: burn from the zero address");
743 
744         _beforeTokenTransfer(account, address(0), amount);
745 
746         uint256 accountBalance = _balances[account];
747         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
748         unchecked {
749             _balances[account] = accountBalance - amount;
750         }
751         _totalSupply -= amount;
752 
753         emit Transfer(account, address(0), amount);
754 
755         _afterTokenTransfer(account, address(0), amount);
756     }
757 
758     /**
759      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
760      *
761      * This internal function is equivalent to `approve`, and can be used to
762      * e.g. set automatic allowances for certain subsystems, etc.
763      *
764      * Emits an {Approval} event.
765      *
766      * Requirements:
767      *
768      * - `owner` cannot be the zero address.
769      * - `spender` cannot be the zero address.
770      */
771     function _approve(
772         address owner,
773         address spender,
774         uint256 amount
775     ) internal virtual {
776         require(owner != address(0), "ERC20: approve from the zero address");
777         require(spender != address(0), "ERC20: approve to the zero address");
778 
779         _allowances[owner][spender] = amount;
780         emit Approval(owner, spender, amount);
781     }
782 
783     /**
784      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
785      *
786      * Does not update the allowance amount in case of infinite allowance.
787      * Revert if not enough allowance is available.
788      *
789      * Might emit an {Approval} event.
790      */
791     function _spendAllowance(
792         address owner,
793         address spender,
794         uint256 amount
795     ) internal virtual {
796         uint256 currentAllowance = allowance(owner, spender);
797         if (currentAllowance != type(uint256).max) {
798             require(currentAllowance >= amount, "ERC20: insufficient allowance");
799             unchecked {
800                 _approve(owner, spender, currentAllowance - amount);
801             }
802         }
803     }
804 
805     /**
806      * @dev Hook that is called before any transfer of tokens. This includes
807      * minting and burning.
808      *
809      * Calling conditions:
810      *
811      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
812      * will be transferred to `to`.
813      * - when `from` is zero, `amount` tokens will be minted for `to`.
814      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
815      * - `from` and `to` are never both zero.
816      *
817      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
818      */
819     function _beforeTokenTransfer(
820         address from,
821         address to,
822         uint256 amount
823     ) internal virtual {}
824 
825     /**
826      * @dev Hook that is called after any transfer of tokens. This includes
827      * minting and burning.
828      *
829      * Calling conditions:
830      *
831      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
832      * has been transferred to `to`.
833      * - when `from` is zero, `amount` tokens have been minted for `to`.
834      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
835      * - `from` and `to` are never both zero.
836      *
837      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
838      */
839     function _afterTokenTransfer(
840         address from,
841         address to,
842         uint256 amount
843     ) internal virtual {}
844 }
845 
846 // File: contracts/LIANA.sol
847 
848 
849 pragma solidity ^0.8.4;
850 
851 
852 
853 
854 
855 contract LIANA is ERC20, ERC721Holder, Ownable {
856     IERC721[] private nft;
857 
858     //uint32[] private tokensForWinners ;
859     address[] private NFTholders;
860 
861     uint256 private lockPeriod;
862     uint32 private a;
863     address private ZERO; // to delete collection from stake system
864 
865     mapping(address => uint256) private arrayUserID; // ID of user in array
866     mapping(address => mapping(uint32 => uint256)) private arrayIDToken; // ID of token in array
867     mapping(address => mapping(address => uint32[])) private arrayOfNftID; // user => collection => id
868     mapping(address => uint256) public tokensAmountForWinner;
869     mapping(address => uint256) public amountOfStakedNFT;
870     mapping(address => mapping(uint256 => address)) public tokenOwnerOf;
871     mapping(address => mapping(uint256 => uint256)) public tokenStakedAt;
872     mapping(address => uint256) private NFTID;
873     mapping(address => uint256) private emissionRate;
874 
875     constructor(
876         address _nft,
877         uint32 _emissionRate,
878         uint256 _lockPeriod
879     ) ERC20("LIANA", "LIANA") {
880         nft.push(IERC721(_nft));
881         NFTID[_nft] = 0;
882         emissionRate[_nft] = _emissionRate * 10**decimals();
883         lockPeriod = _lockPeriod * 24 * 60 * 60;
884     }
885 
886     function decimals() public view virtual override returns (uint8) {
887         return 4;
888     }
889 
890     function addCollectionToStake(address newCollection, uint32 _emissionRate)
891         public
892         onlyOwner
893     {
894         if (nft[NFTID[newCollection]] == IERC721(ZERO)) {
895             nft[NFTID[newCollection]] = IERC721(newCollection);
896         } else {
897             nft.push(IERC721(newCollection));
898             NFTID[newCollection] = nft.length - 1;
899         }
900 
901         emissionRate[newCollection] = _emissionRate * 10**decimals();
902     }
903 
904     function deleteCollectionFromStake(address NFTcollection) public onlyOwner {
905         nft[NFTID[NFTcollection]] = IERC721(ZERO);
906     }
907 
908     function changeEmissionForCollection(
909         address NFTcollection,
910         uint256 _emissionRatePerDay
911     ) public onlyOwner {
912         emissionRate[NFTcollection] = _emissionRatePerDay * 10**decimals();
913     }
914 
915     function calculateRewards(address NFTcollection, uint32 tokenId)
916         public
917         view
918         returns (uint256)
919     {
920         require(
921             tokenStakedAt[NFTcollection][tokenId] != 0,
922             "token not in stake"
923         );
924         return
925             ((block.timestamp - tokenStakedAt[NFTcollection][tokenId]) /
926                 (24 * 60 * 60)) * emissionRate[NFTcollection];
927     }
928 
929     function setLockPeriod(uint256 daysToLock) public onlyOwner {
930         lockPeriod = daysToLock * 24 * 60 * 60;
931     }
932 
933     function stakeNFT(address NFTcollection, uint32 tokenId) external {
934         nft[NFTID[NFTcollection]].safeTransferFrom(
935             msg.sender,
936             address(this),
937             tokenId
938         );
939 
940         tokenOwnerOf[NFTcollection][tokenId] = msg.sender;
941         tokenStakedAt[NFTcollection][tokenId] = block.timestamp;
942 
943         amountOfStakedNFT[msg.sender]++;
944 
945         arrayOfNftID[msg.sender][NFTcollection].push(tokenId);
946         arrayIDToken[NFTcollection][tokenId] =
947             arrayOfNftID[msg.sender][NFTcollection].length -
948             1;
949 
950         if (amountOfStakedNFT[msg.sender] == 1) {
951             NFTholders.push(msg.sender);
952             arrayUserID[msg.sender] = NFTholders.length - 1;
953         }
954     }
955 
956     function unstakeNFT(address NFTcollection, uint32 tokenId) external {
957         require(
958             tokenOwnerOf[NFTcollection][tokenId] == msg.sender,
959             "You aren't owner of NFT"
960         );
961         require(
962             block.timestamp >=
963                 tokenStakedAt[NFTcollection][tokenId] + lockPeriod,
964             "You can't unstake locked NFT"
965         );
966 
967         _mint(msg.sender, calculateRewards(NFTcollection, tokenId));
968         nft[NFTID[NFTcollection]].transferFrom(
969             address(this),
970             msg.sender,
971             tokenId
972         );
973 
974         uint32 tempId = arrayOfNftID[msg.sender][NFTcollection][
975             arrayOfNftID[msg.sender][NFTcollection].length - 1
976         ];
977         arrayOfNftID[msg.sender][NFTcollection][
978             arrayIDToken[NFTcollection][tokenId]
979         ] = tempId;
980         arrayIDToken[NFTcollection][tempId] = arrayIDToken[NFTcollection][
981             tokenId
982         ];
983         arrayOfNftID[msg.sender][NFTcollection].pop();
984 
985         delete arrayIDToken[NFTcollection][tokenId];
986         delete tokenOwnerOf[NFTcollection][tokenId];
987         delete tokenStakedAt[NFTcollection][tokenId];
988 
989         amountOfStakedNFT[msg.sender]--;
990 
991         if (amountOfStakedNFT[msg.sender] < 1) {
992             address tempAdress = NFTholders[NFTholders.length - 1];
993             NFTholders[arrayUserID[msg.sender]] = tempAdress;
994             arrayUserID[tempAdress] = arrayUserID[msg.sender];
995             NFTholders.pop();
996             delete arrayUserID[msg.sender];
997         }
998     }
999 
1000     function arrayOfNftsID(address NFTcollection, address user)
1001         public
1002         view
1003         returns (uint32[] memory)
1004     {
1005         return arrayOfNftID[user][NFTcollection];
1006     }
1007 
1008     function arrayOfNftHolders(uint8 number)
1009         public
1010         view
1011         returns (address[] memory)
1012     {
1013         return NFTholders;
1014     }
1015 
1016     function getTimeUntilUnstake(address NFTcollection, uint256 tokenId)
1017         public
1018         view
1019         returns (uint256)
1020     {
1021         if (
1022             block.timestamp >=
1023             tokenStakedAt[NFTcollection][tokenId] + lockPeriod
1024         ) return 0;
1025         else
1026             return
1027                 ((tokenStakedAt[NFTcollection][tokenId] + lockPeriod) -
1028                     block.timestamp) / 60;
1029     }
1030 
1031     function claimRewards(address NFTcollection, uint32 tokenId) external {
1032         require(
1033             tokenOwnerOf[NFTcollection][tokenId] == msg.sender,
1034             "You aren't owner of NFT or it's not in stake"
1035         );
1036         require(
1037             calculateRewards(NFTcollection, tokenId) > 0,
1038             "nothing to claim"
1039         );
1040         _mint(msg.sender, calculateRewards(NFTcollection, tokenId));
1041         tokenStakedAt[NFTcollection][tokenId] = block.timestamp;
1042     }
1043 
1044     function rewardsForCollectoin(address NFTcollection)
1045         public
1046         view
1047         returns (uint256)
1048     {
1049         return emissionRate[NFTcollection] / (10**decimals());
1050     }
1051 
1052     // WINNERS-ARRAY//
1053 
1054     function addAdressToArray(
1055         address[] memory _winners,
1056         uint32[] memory _tokensForWinners
1057     ) public onlyOwner {
1058         if (_winners.length <= _tokensForWinners.length) {
1059             for (uint256 i = 0; i < _winners.length; i++) {
1060                 tokensAmountForWinner[_winners[i]] +=
1061                     _tokensForWinners[i] *
1062                     10**decimals();
1063             }
1064         } else
1065             for (uint256 i = 0; i < _tokensForWinners.length; i++) {
1066                 tokensAmountForWinner[_winners[i]] +=
1067                     _tokensForWinners[i] *
1068                     10**decimals();
1069             }
1070     }
1071 
1072     function deleteAmountForWinner(address user, uint32 amount)
1073         public
1074         onlyOwner
1075     {
1076         tokensAmountForWinner[user] -= amount;
1077     }
1078 
1079     function claimRewardsForWinners(address winner) external {
1080         require(winner == msg.sender, "you aren't owner");
1081         require(tokensAmountForWinner[winner] > 0, "nothing to claim");
1082         _mint(msg.sender, tokensAmountForWinner[winner]);
1083         delete tokensAmountForWinner[winner];
1084     }
1085 }