1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.12;
3 
4 interface IERC721A {
5     /**
6      * The caller must own the token or be an approved operator.
7      */
8     error ApprovalCallerNotOwnerNorApproved();
9 
10     /**
11      * The token does not exist.
12      */
13     error ApprovalQueryForNonexistentToken();
14 
15     /**
16      * The caller cannot approve to their own address.
17      */
18     error ApproveToCaller();
19 
20     /**
21      * Cannot query the balance for the zero address.
22      */
23     error BalanceQueryForZeroAddress();
24 
25     /**
26      * Cannot mint to the zero address.
27      */
28     error MintToZeroAddress();
29 
30     /**
31      * The quantity of tokens minted must be more than zero.
32      */
33     error MintZeroQuantity();
34 
35     /**
36      * The token does not exist.
37      */
38     error OwnerQueryForNonexistentToken();
39 
40     /**
41      * The caller must own the token or be an approved operator.
42      */
43     error TransferCallerNotOwnerNorApproved();
44 
45     /**
46      * The token must be owned by `from`.
47      */
48     error TransferFromIncorrectOwner();
49 
50     /**
51      * Cannot safely transfer to a contract that does not implement the
52      * ERC721Receiver interface.
53      */
54     error TransferToNonERC721ReceiverImplementer();
55 
56     /**
57      * Cannot transfer to the zero address.
58      */
59     error TransferToZeroAddress();
60 
61     /**
62      * The token does not exist.
63      */
64     error URIQueryForNonexistentToken();
65 
66     /**
67      * The `quantity` minted with ERC2309 exceeds the safety limit.
68      */
69     error MintERC2309QuantityExceedsLimit();
70 
71     /**
72      * The `extraData` cannot be set on an unintialized ownership slot.
73      */
74     error OwnershipNotInitializedForExtraData();
75 
76     // =============================================================
77     //                            STRUCTS
78     // =============================================================
79 
80     struct TokenOwnership {
81         // The address of the owner.
82         address addr;
83         // Stores the start time of ownership with minimal overhead for tokenomics.
84         uint64 startTimestamp;
85         // Whether the token has been burned.
86         bool burned;
87         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
88         uint24 extraData;
89     }
90 
91     // =============================================================
92     //                         TOKEN COUNTERS
93     // =============================================================
94 
95     /**
96      * @dev Returns the total number of tokens in existence.
97      * Burned tokens will reduce the count.
98      * To get the total number of tokens minted, please see {_totalMinted}.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     // =============================================================
103     //                            IERC165
104     // =============================================================
105 
106     /**
107      * @dev Returns true if this contract implements the interface defined by
108      * `interfaceId`. See the corresponding
109      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
110      * to learn more about how these ids are created.
111      *
112      * This function call must use less than 30000 gas.
113      */
114     function supportsInterface(bytes4 interfaceId) external view returns (bool);
115 
116     // =============================================================
117     //                            IERC721
118     // =============================================================
119 
120     /**
121      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
124 
125     /**
126      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
127      */
128     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables or disables
132      * (`approved`) `operator` to manage all of its assets.
133      */
134     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
135 
136     /**
137      * @dev Returns the number of tokens in `owner`'s account.
138      */
139     function balanceOf(address owner) external view returns (uint256 balance);
140 
141     /**
142      * @dev Returns the owner of the `tokenId` token.
143      *
144      * Requirements:
145      *
146      * - `tokenId` must exist.
147      */
148     function ownerOf(uint256 tokenId) external view returns (address owner);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`,
152      * checking first that contract recipients are aware of the ERC721 protocol
153      * to prevent tokens from being forever locked.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be have been allowed to move
161      * this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement
163      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 
174     /**
175      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId
181     ) external;
182 
183     /**
184      * @dev Transfers `tokenId` from `from` to `to`.
185      *
186      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
187      * whenever possible.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must be owned by `from`.
194      * - If the caller is not `from`, it must be approved to move this token
195      * by either {approve} or {setApprovalForAll}.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transferFrom(
200         address from,
201         address to,
202         uint256 tokenId
203     ) external;
204 
205     /**
206      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
207      * The approval is cleared when the token is transferred.
208      *
209      * Only a single account can be approved at a time, so approving the
210      * zero address clears previous approvals.
211      *
212      * Requirements:
213      *
214      * - The caller must own the token or be an approved operator.
215      * - `tokenId` must exist.
216      *
217      * Emits an {Approval} event.
218      */
219     function approve(address to, uint256 tokenId) external;
220 
221     /**
222      * @dev Approve or remove `operator` as an operator for the caller.
223      * Operators can call {transferFrom} or {safeTransferFrom}
224      * for any token owned by the caller.
225      *
226      * Requirements:
227      *
228      * - The `operator` cannot be the caller.
229      *
230      * Emits an {ApprovalForAll} event.
231      */
232     function setApprovalForAll(address operator, bool _approved) external;
233 
234     /**
235      * @dev Returns the account approved for `tokenId` token.
236      *
237      * Requirements:
238      *
239      * - `tokenId` must exist.
240      */
241     function getApproved(uint256 tokenId) external view returns (address operator);
242 
243     /**
244      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
245      *
246      * See {setApprovalForAll}.
247      */
248     function isApprovedForAll(address owner, address operator) external view returns (bool);
249 
250     // =============================================================
251     //                        IERC721Metadata
252     // =============================================================
253 
254     /**
255      * @dev Returns the token collection name.
256      */
257     function name() external view returns (string memory);
258 
259     /**
260      * @dev Returns the token collection symbol.
261      */
262     function symbol() external view returns (string memory);
263 
264     /**
265      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
266      */
267     function tokenURI(uint256 tokenId) external view returns (string memory);
268 
269     // =============================================================
270     //                           IERC2309
271     // =============================================================
272 
273     /**
274      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
275      * (inclusive) is transferred from `from` to `to`, as defined in the
276      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
277      *
278      * See {_mintERC2309} for more details.
279      */
280     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
281 }
282 
283 // File: @openzeppelin/contracts@4.7.2/utils/Context.sol
284 
285 
286 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev Provides information about the current execution context, including the
292  * sender of the transaction and its data. While these are generally available
293  * via msg.sender and msg.data, they should not be accessed in such a direct
294  * manner, since when dealing with meta-transactions the account sending and
295  * paying for execution may not be the actual sender (as far as an application
296  * is concerned).
297  *
298  * This contract is only required for intermediate, library-like contracts.
299  */
300 abstract contract Context {
301     function _msgSender() internal view virtual returns (address) {
302         return msg.sender;
303     }
304 
305     function _msgData() internal view virtual returns (bytes calldata) {
306         return msg.data;
307     }
308 }
309 
310 // File: @openzeppelin/contracts@4.7.2/access/Ownable.sol
311 
312 
313 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 
318 /**
319  * @dev Contract module which provides a basic access control mechanism, where
320  * there is an account (an owner) that can be granted exclusive access to
321  * specific functions.
322  *
323  * By default, the owner account will be the one that deploys the contract. This
324  * can later be changed with {transferOwnership}.
325  *
326  * This module is used through inheritance. It will make available the modifier
327  * `onlyOwner`, which can be applied to your functions to restrict their use to
328  * the owner.
329  */
330 abstract contract Ownable is Context {
331     address private _owner;
332 
333     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
334 
335     /**
336      * @dev Initializes the contract setting the deployer as the initial owner.
337      */
338     constructor() {
339         _transferOwnership(_msgSender());
340     }
341 
342     /**
343      * @dev Throws if called by any account other than the owner.
344      */
345     modifier onlyOwner() {
346         _checkOwner();
347         _;
348     }
349 
350     /**
351      * @dev Returns the address of the current owner.
352      */
353     function owner() public view virtual returns (address) {
354         return _owner;
355     }
356 
357     /**
358      * @dev Throws if the sender is not the owner.
359      */
360     function _checkOwner() internal view virtual {
361         require(owner() == _msgSender(), "Ownable: caller is not the owner");
362     }
363 
364     /**
365      * @dev Leaves the contract without owner. It will not be possible to call
366      * `onlyOwner` functions anymore. Can only be called by the current owner.
367      *
368      * NOTE: Renouncing ownership will leave the contract without an owner,
369      * thereby removing any functionality that is only available to the owner.
370      */
371     function renounceOwnership() public virtual onlyOwner {
372         _transferOwnership(address(0));
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Can only be called by the current owner.
378      */
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(newOwner != address(0), "Ownable: new owner is the zero address");
381         _transferOwnership(newOwner);
382     }
383 
384     /**
385      * @dev Transfers ownership of the contract to a new account (`newOwner`).
386      * Internal function without access restriction.
387      */
388     function _transferOwnership(address newOwner) internal virtual {
389         address oldOwner = _owner;
390         _owner = newOwner;
391         emit OwnershipTransferred(oldOwner, newOwner);
392     }
393 }
394 
395 // File: @openzeppelin/contracts@4.7.2/token/ERC20/IERC20.sol
396 
397 
398 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @dev Interface of the ERC20 standard as defined in the EIP.
404  */
405 interface IERC20 {
406     /**
407      * @dev Emitted when `value` tokens are moved from one account (`from`) to
408      * another (`to`).
409      *
410      * Note that `value` may be zero.
411      */
412     event Transfer(address indexed from, address indexed to, uint256 value);
413 
414     /**
415      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
416      * a call to {approve}. `value` is the new allowance.
417      */
418     event Approval(address indexed owner, address indexed spender, uint256 value);
419 
420     /**
421      * @dev Returns the amount of tokens in existence.
422      */
423     function totalSupply() external view returns (uint256);
424 
425     /**
426      * @dev Returns the amount of tokens owned by `account`.
427      */
428     function balanceOf(address account) external view returns (uint256);
429 
430     /**
431      * @dev Moves `amount` tokens from the caller's account to `to`.
432      *
433      * Returns a boolean value indicating whether the operation succeeded.
434      *
435      * Emits a {Transfer} event.
436      */
437     function transfer(address to, uint256 amount) external returns (bool);
438 
439     /**
440      * @dev Returns the remaining number of tokens that `spender` will be
441      * allowed to spend on behalf of `owner` through {transferFrom}. This is
442      * zero by default.
443      *
444      * This value changes when {approve} or {transferFrom} are called.
445      */
446     function allowance(address owner, address spender) external view returns (uint256);
447 
448     /**
449      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
450      *
451      * Returns a boolean value indicating whether the operation succeeded.
452      *
453      * IMPORTANT: Beware that changing an allowance with this method brings the risk
454      * that someone may use both the old and the new allowance by unfortunate
455      * transaction ordering. One possible solution to mitigate this race
456      * condition is to first reduce the spender's allowance to 0 and set the
457      * desired value afterwards:
458      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
459      *
460      * Emits an {Approval} event.
461      */
462     function approve(address spender, uint256 amount) external returns (bool);
463 
464     /**
465      * @dev Moves `amount` tokens from `from` to `to` using the
466      * allowance mechanism. `amount` is then deducted from the caller's
467      * allowance.
468      *
469      * Returns a boolean value indicating whether the operation succeeded.
470      *
471      * Emits a {Transfer} event.
472      */
473     function transferFrom(
474         address from,
475         address to,
476         uint256 amount
477     ) external returns (bool);
478 }
479 
480 // File: @openzeppelin/contracts@4.7.2/token/ERC20/extensions/IERC20Metadata.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 
488 /**
489  * @dev Interface for the optional metadata functions from the ERC20 standard.
490  *
491  * _Available since v4.1._
492  */
493 interface IERC20Metadata is IERC20 {
494     /**
495      * @dev Returns the name of the token.
496      */
497     function name() external view returns (string memory);
498 
499     /**
500      * @dev Returns the symbol of the token.
501      */
502     function symbol() external view returns (string memory);
503 
504     /**
505      * @dev Returns the decimals places of the token.
506      */
507     function decimals() external view returns (uint8);
508 }
509 
510 // File: @openzeppelin/contracts@4.7.2/token/ERC20/ERC20.sol
511 
512 
513 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 
519 
520 /**
521  * @dev Implementation of the {IERC20} interface.
522  *
523  * This implementation is agnostic to the way tokens are created. This means
524  * that a supply mechanism has to be added in a derived contract using {_mint}.
525  * For a generic mechanism see {ERC20PresetMinterPauser}.
526  *
527  * TIP: For a detailed writeup see our guide
528  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
529  * to implement supply mechanisms].
530  *
531  * We have followed general OpenZeppelin Contracts guidelines: functions revert
532  * instead returning `false` on failure. This behavior is nonetheless
533  * conventional and does not conflict with the expectations of ERC20
534  * applications.
535  *
536  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
537  * This allows applications to reconstruct the allowance for all accounts just
538  * by listening to said events. Other implementations of the EIP may not emit
539  * these events, as it isn't required by the specification.
540  *
541  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
542  * functions have been added to mitigate the well-known issues around setting
543  * allowances. See {IERC20-approve}.
544  */
545 contract ERC20 is Context, IERC20, IERC20Metadata {
546     mapping(address => uint256) private _balances;
547 
548     mapping(address => mapping(address => uint256)) private _allowances;
549 
550     uint256 private _totalSupply;
551 
552     string private _name;
553     string private _symbol;
554 
555     /**
556      * @dev Sets the values for {name} and {symbol}.
557      *
558      * The default value of {decimals} is 18. To select a different value for
559      * {decimals} you should overload it.
560      *
561      * All two of these values are immutable: they can only be set once during
562      * construction.
563      */
564     constructor(string memory name_, string memory symbol_) {
565         _name = name_;
566         _symbol = symbol_;
567     }
568 
569     /**
570      * @dev Returns the name of the token.
571      */
572     function name() public view virtual override returns (string memory) {
573         return _name;
574     }
575 
576     /**
577      * @dev Returns the symbol of the token, usually a shorter version of the
578      * name.
579      */
580     function symbol() public view virtual override returns (string memory) {
581         return _symbol;
582     }
583 
584     /**
585      * @dev Returns the number of decimals used to get its user representation.
586      * For example, if `decimals` equals `2`, a balance of `505` tokens should
587      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
588      *
589      * Tokens usually opt for a value of 18, imitating the relationship between
590      * Ether and Wei. This is the value {ERC20} uses, unless this function is
591      * overridden;
592      *
593      * NOTE: This information is only used for _display_ purposes: it in
594      * no way affects any of the arithmetic of the contract, including
595      * {IERC20-balanceOf} and {IERC20-transfer}.
596      */
597     function decimals() public view virtual override returns (uint8) {
598         return 18;
599     }
600 
601     /**
602      * @dev See {IERC20-totalSupply}.
603      */
604     function totalSupply() public view virtual override returns (uint256) {
605         return _totalSupply;
606     }
607 
608     /**
609      * @dev See {IERC20-balanceOf}.
610      */
611     function balanceOf(address account) public view virtual override returns (uint256) {
612         return _balances[account];
613     }
614 
615     /**
616      * @dev See {IERC20-transfer}.
617      *
618      * Requirements:
619      *
620      * - `to` cannot be the zero address.
621      * - the caller must have a balance of at least `amount`.
622      */
623     function transfer(address to, uint256 amount) public virtual override returns (bool) {
624         address owner = _msgSender();
625         _transfer(owner, to, amount);
626         return true;
627     }
628 
629     /**
630      * @dev See {IERC20-allowance}.
631      */
632     function allowance(address owner, address spender) public view virtual override returns (uint256) {
633         return _allowances[owner][spender];
634     }
635 
636     /**
637      * @dev See {IERC20-approve}.
638      *
639      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
640      * `transferFrom`. This is semantically equivalent to an infinite approval.
641      *
642      * Requirements:
643      *
644      * - `spender` cannot be the zero address.
645      */
646     function approve(address spender, uint256 amount) public virtual override returns (bool) {
647         address owner = _msgSender();
648         _approve(owner, spender, amount);
649         return true;
650     }
651 
652     /**
653      * @dev See {IERC20-transferFrom}.
654      *
655      * Emits an {Approval} event indicating the updated allowance. This is not
656      * required by the EIP. See the note at the beginning of {ERC20}.
657      *
658      * NOTE: Does not update the allowance if the current allowance
659      * is the maximum `uint256`.
660      *
661      * Requirements:
662      *
663      * - `from` and `to` cannot be the zero address.
664      * - `from` must have a balance of at least `amount`.
665      * - the caller must have allowance for ``from``'s tokens of at least
666      * `amount`.
667      */
668     function transferFrom(
669         address from,
670         address to,
671         uint256 amount
672     ) public virtual override returns (bool) {
673         address spender = _msgSender();
674         _spendAllowance(from, spender, amount);
675         _transfer(from, to, amount);
676         return true;
677     }
678 
679     /**
680      * @dev Atomically increases the allowance granted to `spender` by the caller.
681      *
682      * This is an alternative to {approve} that can be used as a mitigation for
683      * problems described in {IERC20-approve}.
684      *
685      * Emits an {Approval} event indicating the updated allowance.
686      *
687      * Requirements:
688      *
689      * - `spender` cannot be the zero address.
690      */
691     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
692         address owner = _msgSender();
693         _approve(owner, spender, allowance(owner, spender) + addedValue);
694         return true;
695     }
696 
697     /**
698      * @dev Atomically decreases the allowance granted to `spender` by the caller.
699      *
700      * This is an alternative to {approve} that can be used as a mitigation for
701      * problems described in {IERC20-approve}.
702      *
703      * Emits an {Approval} event indicating the updated allowance.
704      *
705      * Requirements:
706      *
707      * - `spender` cannot be the zero address.
708      * - `spender` must have allowance for the caller of at least
709      * `subtractedValue`.
710      */
711     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
712         address owner = _msgSender();
713         uint256 currentAllowance = allowance(owner, spender);
714         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
715         unchecked {
716             _approve(owner, spender, currentAllowance - subtractedValue);
717         }
718 
719         return true;
720     }
721 
722     /**
723      * @dev Moves `amount` of tokens from `from` to `to`.
724      *
725      * This internal function is equivalent to {transfer}, and can be used to
726      * e.g. implement automatic token fees, slashing mechanisms, etc.
727      *
728      * Emits a {Transfer} event.
729      *
730      * Requirements:
731      *
732      * - `from` cannot be the zero address.
733      * - `to` cannot be the zero address.
734      * - `from` must have a balance of at least `amount`.
735      */
736     function _transfer(
737         address from,
738         address to,
739         uint256 amount
740     ) internal virtual {
741         require(from != address(0), "ERC20: transfer from the zero address");
742         require(to != address(0), "ERC20: transfer to the zero address");
743 
744         _beforeTokenTransfer(from, to, amount);
745 
746         uint256 fromBalance = _balances[from];
747         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
748         unchecked {
749             _balances[from] = fromBalance - amount;
750         }
751         _balances[to] += amount;
752 
753         emit Transfer(from, to, amount);
754 
755         _afterTokenTransfer(from, to, amount);
756     }
757 
758     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
759      * the total supply.
760      *
761      * Emits a {Transfer} event with `from` set to the zero address.
762      *
763      * Requirements:
764      *
765      * - `account` cannot be the zero address.
766      */
767     function _mint(address account, uint256 amount) internal virtual {
768         require(account != address(0), "ERC20: mint to the zero address");
769 
770         _beforeTokenTransfer(address(0), account, amount);
771 
772         _totalSupply += amount;
773         _balances[account] += amount;
774         emit Transfer(address(0), account, amount);
775 
776         _afterTokenTransfer(address(0), account, amount);
777     }
778 
779     /**
780      * @dev Destroys `amount` tokens from `account`, reducing the
781      * total supply.
782      *
783      * Emits a {Transfer} event with `to` set to the zero address.
784      *
785      * Requirements:
786      *
787      * - `account` cannot be the zero address.
788      * - `account` must have at least `amount` tokens.
789      */
790     function _burn(address account, uint256 amount) internal virtual {
791         require(account != address(0), "ERC20: burn from the zero address");
792 
793         _beforeTokenTransfer(account, address(0), amount);
794 
795         uint256 accountBalance = _balances[account];
796         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
797         unchecked {
798             _balances[account] = accountBalance - amount;
799         }
800         _totalSupply -= amount;
801 
802         emit Transfer(account, address(0), amount);
803 
804         _afterTokenTransfer(account, address(0), amount);
805     }
806 
807     /**
808      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
809      *
810      * This internal function is equivalent to `approve`, and can be used to
811      * e.g. set automatic allowances for certain subsystems, etc.
812      *
813      * Emits an {Approval} event.
814      *
815      * Requirements:
816      *
817      * - `owner` cannot be the zero address.
818      * - `spender` cannot be the zero address.
819      */
820     function _approve(
821         address owner,
822         address spender,
823         uint256 amount
824     ) internal virtual {
825         require(owner != address(0), "ERC20: approve from the zero address");
826         require(spender != address(0), "ERC20: approve to the zero address");
827 
828         _allowances[owner][spender] = amount;
829         emit Approval(owner, spender, amount);
830     }
831 
832     /**
833      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
834      *
835      * Does not update the allowance amount in case of infinite allowance.
836      * Revert if not enough allowance is available.
837      *
838      * Might emit an {Approval} event.
839      */
840     function _spendAllowance(
841         address owner,
842         address spender,
843         uint256 amount
844     ) internal virtual {
845         uint256 currentAllowance = allowance(owner, spender);
846         if (currentAllowance != type(uint256).max) {
847             require(currentAllowance >= amount, "ERC20: insufficient allowance");
848             unchecked {
849                 _approve(owner, spender, currentAllowance - amount);
850             }
851         }
852     }
853 
854     /**
855      * @dev Hook that is called before any transfer of tokens. This includes
856      * minting and burning.
857      *
858      * Calling conditions:
859      *
860      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
861      * will be transferred to `to`.
862      * - when `from` is zero, `amount` tokens will be minted for `to`.
863      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
864      * - `from` and `to` are never both zero.
865      *
866      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
867      */
868     function _beforeTokenTransfer(
869         address from,
870         address to,
871         uint256 amount
872     ) internal virtual {}
873 
874     /**
875      * @dev Hook that is called after any transfer of tokens. This includes
876      * minting and burning.
877      *
878      * Calling conditions:
879      *
880      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
881      * has been transferred to `to`.
882      * - when `from` is zero, `amount` tokens have been minted for `to`.
883      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
884      * - `from` and `to` are never both zero.
885      *
886      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
887      */
888     function _afterTokenTransfer(
889         address from,
890         address to,
891         uint256 amount
892     ) internal virtual {}
893 }
894 
895 // File: @openzeppelin/contracts@4.7.2/token/ERC20/extensions/ERC20Burnable.sol
896 
897 
898 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
899 
900 pragma solidity ^0.8.0;
901 
902 
903 
904 /**
905  * @dev Extension of {ERC20} that allows token holders to destroy both their own
906  * tokens and those that they have an allowance for, in a way that can be
907  * recognized off-chain (via event analysis).
908  */
909 abstract contract ERC20Burnable is Context, ERC20 {
910     /**
911      * @dev Destroys `amount` tokens from the caller.
912      *
913      * See {ERC20-_burn}.
914      */
915     function burn(uint256 amount) public virtual {
916         _burn(_msgSender(), amount);
917     }
918 
919     /**
920      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
921      * allowance.
922      *
923      * See {ERC20-_burn} and {ERC20-allowance}.
924      *
925      * Requirements:
926      *
927      * - the caller must have allowance for ``accounts``'s tokens of at least
928      * `amount`.
929      */
930     function burnFrom(address account, uint256 amount) public virtual {
931         _spendAllowance(account, _msgSender(), amount);
932         _burn(account, amount);
933     }
934 }
935 
936 // File: flattt.sol
937 
938 
939 pragma solidity ^0.8.12;
940 
941 
942 
943 
944 
945 contract DOOP is ERC20, ERC20Burnable, Ownable {
946     IERC721A public token;
947     uint initialTime= 1656028800; //june ,2022
948  
949 mapping(address=>uint) public totalClaimed;
950 mapping(address=>uint) public prevTime;
951     event Claimed(
952         address indexed claim,
953         uint indexed time,
954         uint indexed amount
955     );
956     constructor(address _token) ERC20("DOOP", "$DOOP") {
957     
958         token=IERC721A(_token);
959     
960     }
961 
962     function mint(address to, uint256 amount) external onlyOwner{
963         _mint(to, amount * 10 ** decimals());
964     }
965     function claim() public {
966         require(token.balanceOf(msg.sender)>0,"You dont have any NFT in our collection");
967         uint temp;
968         uint pTime= prevTime[msg.sender];
969         if(pTime!=0){
970             require(pTime+1 days< block.timestamp,"Atleast pass one day");
971             temp= ((block.timestamp - pTime) / 1 days)*5;
972         }else{
973             temp= ((block.timestamp - initialTime) / 1 days)* 5;
974         }
975         prevTime[msg.sender]=block.timestamp;
976         
977         uint temp1= temp* token.balanceOf(msg.sender);
978         totalClaimed[msg.sender]+=temp1;
979          _mint(msg.sender, temp1 * 10 ** decimals());
980         emit Claimed(msg.sender,block.timestamp,temp1);
981     }
982     function canClaim(address _addr)public view returns(uint){
983         require(token.balanceOf(_addr)>0,"You dont have any NFT in our collection");
984         uint temp = 0;
985         uint pTime = prevTime[_addr];
986         if(pTime!=0){
987             temp= ((block.timestamp - pTime) / 1 days)*5;
988         }else{
989             temp= ((block.timestamp - initialTime) / 1 days)* 5;
990         }
991         uint result = temp* token.balanceOf(_addr);
992         return result;
993     }
994     
995 }