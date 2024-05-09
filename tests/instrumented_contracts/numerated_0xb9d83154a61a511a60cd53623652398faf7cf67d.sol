1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Interface of the ERC165 standard, as defined in the
240  * https://eips.ethereum.org/EIPS/eip-165[EIP].
241  *
242  * Implementers can declare support of contract interfaces, which can then be
243  * queried by others ({ERC165Checker}).
244  *
245  * For an implementation, see {ERC165}.
246  */
247 interface IERC165 {
248     /**
249      * @dev Returns true if this contract implements the interface defined by
250      * `interfaceId`. See the corresponding
251      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
252      * to learn more about how these ids are created.
253      *
254      * This function call must use less than 30 000 gas.
255      */
256     function supportsInterface(bytes4 interfaceId) external view returns (bool);
257 }
258 
259 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
260 
261 
262 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 
267 /**
268  * @dev Required interface of an ERC721 compliant contract.
269  */
270 interface IERC721 is IERC165 {
271     /**
272      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
273      */
274     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
275 
276     /**
277      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
278      */
279     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
280 
281     /**
282      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
283      */
284     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
285 
286     /**
287      * @dev Returns the number of tokens in ``owner``'s account.
288      */
289     function balanceOf(address owner) external view returns (uint256 balance);
290 
291     /**
292      * @dev Returns the owner of the `tokenId` token.
293      *
294      * Requirements:
295      *
296      * - `tokenId` must exist.
297      */
298     function ownerOf(uint256 tokenId) external view returns (address owner);
299 
300     /**
301      * @dev Safely transfers `tokenId` token from `from` to `to`.
302      *
303      * Requirements:
304      *
305      * - `from` cannot be the zero address.
306      * - `to` cannot be the zero address.
307      * - `tokenId` token must exist and be owned by `from`.
308      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
309      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
310      *
311      * Emits a {Transfer} event.
312      */
313     function safeTransferFrom(
314         address from,
315         address to,
316         uint256 tokenId,
317         bytes calldata data
318     ) external;
319 
320     /**
321      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
322      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
323      *
324      * Requirements:
325      *
326      * - `from` cannot be the zero address.
327      * - `to` cannot be the zero address.
328      * - `tokenId` token must exist and be owned by `from`.
329      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
330      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
331      *
332      * Emits a {Transfer} event.
333      */
334     function safeTransferFrom(
335         address from,
336         address to,
337         uint256 tokenId
338     ) external;
339 
340     /**
341      * @dev Transfers `tokenId` token from `from` to `to`.
342      *
343      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
344      *
345      * Requirements:
346      *
347      * - `from` cannot be the zero address.
348      * - `to` cannot be the zero address.
349      * - `tokenId` token must be owned by `from`.
350      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
351      *
352      * Emits a {Transfer} event.
353      */
354     function transferFrom(
355         address from,
356         address to,
357         uint256 tokenId
358     ) external;
359 
360     /**
361      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
362      * The approval is cleared when the token is transferred.
363      *
364      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
365      *
366      * Requirements:
367      *
368      * - The caller must own the token or be an approved operator.
369      * - `tokenId` must exist.
370      *
371      * Emits an {Approval} event.
372      */
373     function approve(address to, uint256 tokenId) external;
374 
375     /**
376      * @dev Approve or remove `operator` as an operator for the caller.
377      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
378      *
379      * Requirements:
380      *
381      * - The `operator` cannot be the caller.
382      *
383      * Emits an {ApprovalForAll} event.
384      */
385     function setApprovalForAll(address operator, bool _approved) external;
386 
387     /**
388      * @dev Returns the account approved for `tokenId` token.
389      *
390      * Requirements:
391      *
392      * - `tokenId` must exist.
393      */
394     function getApproved(uint256 tokenId) external view returns (address operator);
395 
396     /**
397      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
398      *
399      * See {setApprovalForAll}
400      */
401     function isApprovedForAll(address owner, address operator) external view returns (bool);
402 }
403 
404 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
405 
406 
407 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
408 
409 pragma solidity ^0.8.0;
410 
411 
412 /**
413  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
414  * @dev See https://eips.ethereum.org/EIPS/eip-721
415  */
416 interface IERC721Enumerable is IERC721 {
417     /**
418      * @dev Returns the total amount of tokens stored by the contract.
419      */
420     function totalSupply() external view returns (uint256);
421 
422     /**
423      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
424      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
425      */
426     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
427 
428     /**
429      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
430      * Use along with {totalSupply} to enumerate all tokens.
431      */
432     function tokenByIndex(uint256 index) external view returns (uint256);
433 }
434 
435 // File: @openzeppelin/contracts/utils/Context.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Provides information about the current execution context, including the
444  * sender of the transaction and its data. While these are generally available
445  * via msg.sender and msg.data, they should not be accessed in such a direct
446  * manner, since when dealing with meta-transactions the account sending and
447  * paying for execution may not be the actual sender (as far as an application
448  * is concerned).
449  *
450  * This contract is only required for intermediate, library-like contracts.
451  */
452 abstract contract Context {
453     function _msgSender() internal view virtual returns (address) {
454         return msg.sender;
455     }
456 
457     function _msgData() internal view virtual returns (bytes calldata) {
458         return msg.data;
459     }
460 }
461 
462 // File: @openzeppelin/contracts/access/Ownable.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev Contract module which provides a basic access control mechanism, where
472  * there is an account (an owner) that can be granted exclusive access to
473  * specific functions.
474  *
475  * By default, the owner account will be the one that deploys the contract. This
476  * can later be changed with {transferOwnership}.
477  *
478  * This module is used through inheritance. It will make available the modifier
479  * `onlyOwner`, which can be applied to your functions to restrict their use to
480  * the owner.
481  */
482 abstract contract Ownable is Context {
483     address private _owner;
484 
485     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
486 
487     /**
488      * @dev Initializes the contract setting the deployer as the initial owner.
489      */
490     constructor() {
491         _transferOwnership(_msgSender());
492     }
493 
494     /**
495      * @dev Returns the address of the current owner.
496      */
497     function owner() public view virtual returns (address) {
498         return _owner;
499     }
500 
501     /**
502      * @dev Throws if called by any account other than the owner.
503      */
504     modifier onlyOwner() {
505         require(owner() == _msgSender(), "Ownable: caller is not the owner");
506         _;
507     }
508 
509     /**
510      * @dev Leaves the contract without owner. It will not be possible to call
511      * `onlyOwner` functions anymore. Can only be called by the current owner.
512      *
513      * NOTE: Renouncing ownership will leave the contract without an owner,
514      * thereby removing any functionality that is only available to the owner.
515      */
516     function renounceOwnership() public virtual onlyOwner {
517         _transferOwnership(address(0));
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Can only be called by the current owner.
523      */
524     function transferOwnership(address newOwner) public virtual onlyOwner {
525         require(newOwner != address(0), "Ownable: new owner is the zero address");
526         _transferOwnership(newOwner);
527     }
528 
529     /**
530      * @dev Transfers ownership of the contract to a new account (`newOwner`).
531      * Internal function without access restriction.
532      */
533     function _transferOwnership(address newOwner) internal virtual {
534         address oldOwner = _owner;
535         _owner = newOwner;
536         emit OwnershipTransferred(oldOwner, newOwner);
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
541 
542 
543 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev Interface of the ERC20 standard as defined in the EIP.
549  */
550 interface IERC20 {
551     /**
552      * @dev Emitted when `value` tokens are moved from one account (`from`) to
553      * another (`to`).
554      *
555      * Note that `value` may be zero.
556      */
557     event Transfer(address indexed from, address indexed to, uint256 value);
558 
559     /**
560      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
561      * a call to {approve}. `value` is the new allowance.
562      */
563     event Approval(address indexed owner, address indexed spender, uint256 value);
564 
565     /**
566      * @dev Returns the amount of tokens in existence.
567      */
568     function totalSupply() external view returns (uint256);
569 
570     /**
571      * @dev Returns the amount of tokens owned by `account`.
572      */
573     function balanceOf(address account) external view returns (uint256);
574 
575     /**
576      * @dev Moves `amount` tokens from the caller's account to `to`.
577      *
578      * Returns a boolean value indicating whether the operation succeeded.
579      *
580      * Emits a {Transfer} event.
581      */
582     function transfer(address to, uint256 amount) external returns (bool);
583 
584     /**
585      * @dev Returns the remaining number of tokens that `spender` will be
586      * allowed to spend on behalf of `owner` through {transferFrom}. This is
587      * zero by default.
588      *
589      * This value changes when {approve} or {transferFrom} are called.
590      */
591     function allowance(address owner, address spender) external view returns (uint256);
592 
593     /**
594      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
595      *
596      * Returns a boolean value indicating whether the operation succeeded.
597      *
598      * IMPORTANT: Beware that changing an allowance with this method brings the risk
599      * that someone may use both the old and the new allowance by unfortunate
600      * transaction ordering. One possible solution to mitigate this race
601      * condition is to first reduce the spender's allowance to 0 and set the
602      * desired value afterwards:
603      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
604      *
605      * Emits an {Approval} event.
606      */
607     function approve(address spender, uint256 amount) external returns (bool);
608 
609     /**
610      * @dev Moves `amount` tokens from `from` to `to` using the
611      * allowance mechanism. `amount` is then deducted from the caller's
612      * allowance.
613      *
614      * Returns a boolean value indicating whether the operation succeeded.
615      *
616      * Emits a {Transfer} event.
617      */
618     function transferFrom(
619         address from,
620         address to,
621         uint256 amount
622     ) external returns (bool);
623 }
624 
625 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
626 
627 
628 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 
633 /**
634  * @dev Interface for the optional metadata functions from the ERC20 standard.
635  *
636  * _Available since v4.1._
637  */
638 interface IERC20Metadata is IERC20 {
639     /**
640      * @dev Returns the name of the token.
641      */
642     function name() external view returns (string memory);
643 
644     /**
645      * @dev Returns the symbol of the token.
646      */
647     function symbol() external view returns (string memory);
648 
649     /**
650      * @dev Returns the decimals places of the token.
651      */
652     function decimals() external view returns (uint8);
653 }
654 
655 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
656 
657 
658 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 
663 
664 
665 /**
666  * @dev Implementation of the {IERC20} interface.
667  *
668  * This implementation is agnostic to the way tokens are created. This means
669  * that a supply mechanism has to be added in a derived contract using {_mint}.
670  * For a generic mechanism see {ERC20PresetMinterPauser}.
671  *
672  * TIP: For a detailed writeup see our guide
673  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
674  * to implement supply mechanisms].
675  *
676  * We have followed general OpenZeppelin Contracts guidelines: functions revert
677  * instead returning `false` on failure. This behavior is nonetheless
678  * conventional and does not conflict with the expectations of ERC20
679  * applications.
680  *
681  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
682  * This allows applications to reconstruct the allowance for all accounts just
683  * by listening to said events. Other implementations of the EIP may not emit
684  * these events, as it isn't required by the specification.
685  *
686  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
687  * functions have been added to mitigate the well-known issues around setting
688  * allowances. See {IERC20-approve}.
689  */
690 contract ERC20 is Context, IERC20, IERC20Metadata {
691     mapping(address => uint256) private _balances;
692 
693     mapping(address => mapping(address => uint256)) private _allowances;
694 
695     uint256 private _totalSupply;
696 
697     string private _name;
698     string private _symbol;
699 
700     /**
701      * @dev Sets the values for {name} and {symbol}.
702      *
703      * The default value of {decimals} is 18. To select a different value for
704      * {decimals} you should overload it.
705      *
706      * All two of these values are immutable: they can only be set once during
707      * construction.
708      */
709     constructor(string memory name_, string memory symbol_) {
710         _name = name_;
711         _symbol = symbol_;
712     }
713 
714     /**
715      * @dev Returns the name of the token.
716      */
717     function name() public view virtual override returns (string memory) {
718         return _name;
719     }
720 
721     /**
722      * @dev Returns the symbol of the token, usually a shorter version of the
723      * name.
724      */
725     function symbol() public view virtual override returns (string memory) {
726         return _symbol;
727     }
728 
729     /**
730      * @dev Returns the number of decimals used to get its user representation.
731      * For example, if `decimals` equals `2`, a balance of `505` tokens should
732      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
733      *
734      * Tokens usually opt for a value of 18, imitating the relationship between
735      * Ether and Wei. This is the value {ERC20} uses, unless this function is
736      * overridden;
737      *
738      * NOTE: This information is only used for _display_ purposes: it in
739      * no way affects any of the arithmetic of the contract, including
740      * {IERC20-balanceOf} and {IERC20-transfer}.
741      */
742     function decimals() public view virtual override returns (uint8) {
743         return 18;
744     }
745 
746     /**
747      * @dev See {IERC20-totalSupply}.
748      */
749     function totalSupply() public view virtual override returns (uint256) {
750         return _totalSupply;
751     }
752 
753     /**
754      * @dev See {IERC20-balanceOf}.
755      */
756     function balanceOf(address account) public view virtual override returns (uint256) {
757         return _balances[account];
758     }
759 
760     /**
761      * @dev See {IERC20-transfer}.
762      *
763      * Requirements:
764      *
765      * - `to` cannot be the zero address.
766      * - the caller must have a balance of at least `amount`.
767      */
768     function transfer(address to, uint256 amount) public virtual override returns (bool) {
769         address owner = _msgSender();
770         _transfer(owner, to, amount);
771         return true;
772     }
773 
774     /**
775      * @dev See {IERC20-allowance}.
776      */
777     function allowance(address owner, address spender) public view virtual override returns (uint256) {
778         return _allowances[owner][spender];
779     }
780 
781     /**
782      * @dev See {IERC20-approve}.
783      *
784      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
785      * `transferFrom`. This is semantically equivalent to an infinite approval.
786      *
787      * Requirements:
788      *
789      * - `spender` cannot be the zero address.
790      */
791     function approve(address spender, uint256 amount) public virtual override returns (bool) {
792         address owner = _msgSender();
793         _approve(owner, spender, amount);
794         return true;
795     }
796 
797     /**
798      * @dev See {IERC20-transferFrom}.
799      *
800      * Emits an {Approval} event indicating the updated allowance. This is not
801      * required by the EIP. See the note at the beginning of {ERC20}.
802      *
803      * NOTE: Does not update the allowance if the current allowance
804      * is the maximum `uint256`.
805      *
806      * Requirements:
807      *
808      * - `from` and `to` cannot be the zero address.
809      * - `from` must have a balance of at least `amount`.
810      * - the caller must have allowance for ``from``'s tokens of at least
811      * `amount`.
812      */
813     function transferFrom(
814         address from,
815         address to,
816         uint256 amount
817     ) public virtual override returns (bool) {
818         address spender = _msgSender();
819         _spendAllowance(from, spender, amount);
820         _transfer(from, to, amount);
821         return true;
822     }
823 
824     /**
825      * @dev Atomically increases the allowance granted to `spender` by the caller.
826      *
827      * This is an alternative to {approve} that can be used as a mitigation for
828      * problems described in {IERC20-approve}.
829      *
830      * Emits an {Approval} event indicating the updated allowance.
831      *
832      * Requirements:
833      *
834      * - `spender` cannot be the zero address.
835      */
836     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
837         address owner = _msgSender();
838         _approve(owner, spender, allowance(owner, spender) + addedValue);
839         return true;
840     }
841 
842     /**
843      * @dev Atomically decreases the allowance granted to `spender` by the caller.
844      *
845      * This is an alternative to {approve} that can be used as a mitigation for
846      * problems described in {IERC20-approve}.
847      *
848      * Emits an {Approval} event indicating the updated allowance.
849      *
850      * Requirements:
851      *
852      * - `spender` cannot be the zero address.
853      * - `spender` must have allowance for the caller of at least
854      * `subtractedValue`.
855      */
856     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
857         address owner = _msgSender();
858         uint256 currentAllowance = allowance(owner, spender);
859         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
860         unchecked {
861             _approve(owner, spender, currentAllowance - subtractedValue);
862         }
863 
864         return true;
865     }
866 
867     /**
868      * @dev Moves `amount` of tokens from `sender` to `recipient`.
869      *
870      * This internal function is equivalent to {transfer}, and can be used to
871      * e.g. implement automatic token fees, slashing mechanisms, etc.
872      *
873      * Emits a {Transfer} event.
874      *
875      * Requirements:
876      *
877      * - `from` cannot be the zero address.
878      * - `to` cannot be the zero address.
879      * - `from` must have a balance of at least `amount`.
880      */
881     function _transfer(
882         address from,
883         address to,
884         uint256 amount
885     ) internal virtual {
886         require(from != address(0), "ERC20: transfer from the zero address");
887         require(to != address(0), "ERC20: transfer to the zero address");
888 
889         _beforeTokenTransfer(from, to, amount);
890 
891         uint256 fromBalance = _balances[from];
892         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
893         unchecked {
894             _balances[from] = fromBalance - amount;
895         }
896         _balances[to] += amount;
897 
898         emit Transfer(from, to, amount);
899 
900         _afterTokenTransfer(from, to, amount);
901     }
902 
903     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
904      * the total supply.
905      *
906      * Emits a {Transfer} event with `from` set to the zero address.
907      *
908      * Requirements:
909      *
910      * - `account` cannot be the zero address.
911      */
912     function _mint(address account, uint256 amount) internal virtual {
913         require(account != address(0), "ERC20: mint to the zero address");
914 
915         _beforeTokenTransfer(address(0), account, amount);
916 
917         _totalSupply += amount;
918         _balances[account] += amount;
919         emit Transfer(address(0), account, amount);
920 
921         _afterTokenTransfer(address(0), account, amount);
922     }
923 
924     /**
925      * @dev Destroys `amount` tokens from `account`, reducing the
926      * total supply.
927      *
928      * Emits a {Transfer} event with `to` set to the zero address.
929      *
930      * Requirements:
931      *
932      * - `account` cannot be the zero address.
933      * - `account` must have at least `amount` tokens.
934      */
935     function _burn(address account, uint256 amount) internal virtual {
936         require(account != address(0), "ERC20: burn from the zero address");
937 
938         _beforeTokenTransfer(account, address(0), amount);
939 
940         uint256 accountBalance = _balances[account];
941         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
942         unchecked {
943             _balances[account] = accountBalance - amount;
944         }
945         _totalSupply -= amount;
946 
947         emit Transfer(account, address(0), amount);
948 
949         _afterTokenTransfer(account, address(0), amount);
950     }
951 
952     /**
953      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
954      *
955      * This internal function is equivalent to `approve`, and can be used to
956      * e.g. set automatic allowances for certain subsystems, etc.
957      *
958      * Emits an {Approval} event.
959      *
960      * Requirements:
961      *
962      * - `owner` cannot be the zero address.
963      * - `spender` cannot be the zero address.
964      */
965     function _approve(
966         address owner,
967         address spender,
968         uint256 amount
969     ) internal virtual {
970         require(owner != address(0), "ERC20: approve from the zero address");
971         require(spender != address(0), "ERC20: approve to the zero address");
972 
973         _allowances[owner][spender] = amount;
974         emit Approval(owner, spender, amount);
975     }
976 
977     /**
978      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
979      *
980      * Does not update the allowance amount in case of infinite allowance.
981      * Revert if not enough allowance is available.
982      *
983      * Might emit an {Approval} event.
984      */
985     function _spendAllowance(
986         address owner,
987         address spender,
988         uint256 amount
989     ) internal virtual {
990         uint256 currentAllowance = allowance(owner, spender);
991         if (currentAllowance != type(uint256).max) {
992             require(currentAllowance >= amount, "ERC20: insufficient allowance");
993             unchecked {
994                 _approve(owner, spender, currentAllowance - amount);
995             }
996         }
997     }
998 
999     /**
1000      * @dev Hook that is called before any transfer of tokens. This includes
1001      * minting and burning.
1002      *
1003      * Calling conditions:
1004      *
1005      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1006      * will be transferred to `to`.
1007      * - when `from` is zero, `amount` tokens will be minted for `to`.
1008      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1009      * - `from` and `to` are never both zero.
1010      *
1011      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1012      */
1013     function _beforeTokenTransfer(
1014         address from,
1015         address to,
1016         uint256 amount
1017     ) internal virtual {}
1018 
1019     /**
1020      * @dev Hook that is called after any transfer of tokens. This includes
1021      * minting and burning.
1022      *
1023      * Calling conditions:
1024      *
1025      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1026      * has been transferred to `to`.
1027      * - when `from` is zero, `amount` tokens have been minted for `to`.
1028      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1029      * - `from` and `to` are never both zero.
1030      *
1031      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1032      */
1033     function _afterTokenTransfer(
1034         address from,
1035         address to,
1036         uint256 amount
1037     ) internal virtual {}
1038 }
1039 
1040 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1041 
1042 
1043 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1044 
1045 pragma solidity ^0.8.0;
1046 
1047 
1048 
1049 /**
1050  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1051  * tokens and those that they have an allowance for, in a way that can be
1052  * recognized off-chain (via event analysis).
1053  */
1054 abstract contract ERC20Burnable is Context, ERC20 {
1055     /**
1056      * @dev Destroys `amount` tokens from the caller.
1057      *
1058      * See {ERC20-_burn}.
1059      */
1060     function burn(uint256 amount) public virtual {
1061         _burn(_msgSender(), amount);
1062     }
1063 
1064     /**
1065      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1066      * allowance.
1067      *
1068      * See {ERC20-_burn} and {ERC20-allowance}.
1069      *
1070      * Requirements:
1071      *
1072      * - the caller must have allowance for ``accounts``'s tokens of at least
1073      * `amount`.
1074      */
1075     function burnFrom(address account, uint256 amount) public virtual {
1076         _spendAllowance(account, _msgSender(), amount);
1077         _burn(account, amount);
1078     }
1079 }
1080 
1081 // File: contracts/WCARestake.sol
1082 
1083 //SPDX-License-Identifier: MIT
1084 pragma solidity ^0.8.13;
1085 
1086 
1087 
1088 
1089 
1090 
1091 contract WorldCupApesRestake is Ownable {
1092     using SafeMath for uint256;
1093 
1094     uint256 public startUnstakeTimestamp = 1669849200;
1095     uint256 public emissionRate = 66;
1096     uint256 public divider = 10000;
1097     mapping(address => uint256) internal stakerToTokens;
1098     mapping(address => uint256) internal stakerToInitialTokens;
1099     mapping(address => uint256) internal stakerToLastClaim;
1100     bool public restakingLive = false;
1101 
1102     IERC721Enumerable private WCANFT;
1103     IERC20 private WCAToken;
1104 
1105     modifier canUnstake {
1106         require(block.timestamp >= startUnstakeTimestamp, "You can't already unstake tokens");
1107         _;
1108     }
1109 
1110     modifier restakingEnabled {
1111       require(restakingLive && block.timestamp < startUnstakeTimestamp, "Restaking not live");
1112       _;
1113     }
1114 
1115     constructor(address _WCANFT, address _WCAToken) {
1116       WCANFT = IERC721Enumerable(_WCANFT);
1117       WCAToken = IERC20(_WCAToken);
1118     }
1119 
1120     function setStartUnstakeTimestamp(uint256 timestamp) external onlyOwner {
1121       startUnstakeTimestamp = timestamp;
1122     }
1123 
1124     function setEmissionRate(uint256 _emissionRate) external onlyOwner {
1125       emissionRate = _emissionRate;
1126     }
1127 
1128     function setDivider(uint256 _divider) external onlyOwner {
1129       divider = _divider;
1130     }
1131 
1132     function toggleRestakingLive() external onlyOwner {
1133       restakingLive = !restakingLive;
1134     }
1135 
1136     function bonus(address _address, uint256 value) external onlyOwner {
1137       stakerToTokens[_address] = stakerToTokens[_address].add(value);
1138       stakerToInitialTokens[_address] = stakerToInitialTokens[_address].add(value);
1139     }
1140 
1141     function reduce(address _address, uint256 value) external onlyOwner {
1142       stakerToTokens[_address] = stakerToTokens[_address].sub(value);
1143       stakerToInitialTokens[_address] = stakerToInitialTokens[_address].sub(value);
1144     }
1145 
1146     function restake(address _address) external restakingEnabled {
1147       uint256 balance = WCAToken.balanceOf(_address);
1148 
1149       require(balance > 0, "You have no $WCA");
1150 
1151       require(WCAToken.allowance(_address, address(this)) >= balance, "First approve to restake");
1152 
1153       WCAToken.transferFrom(_address, owner(), balance);
1154 
1155       stakerToTokens[_address] = balance.mul(2);
1156       stakerToInitialTokens[_address] = balance.mul(2);
1157     }
1158 
1159     function claim(address _address) external canUnstake {
1160       require(stakerToTokens[_address] > 0 && stakerToInitialTokens[_address] > 0, "You have no tokens staked");
1161 
1162       uint256 fromTimestamp = startUnstakeTimestamp;
1163       if(stakerToLastClaim[_address] > startUnstakeTimestamp){
1164         fromTimestamp = stakerToLastClaim[_address];
1165       }
1166 
1167       uint256 rewards = block.timestamp.sub(fromTimestamp).mul(stakerToInitialTokens[_address]).mul(emissionRate).div(divider).div(86400);
1168 
1169       if(rewards > stakerToTokens[_address]){
1170         rewards = stakerToTokens[_address];
1171         stakerToTokens[_address] = 0;
1172       } else {
1173         stakerToTokens[_address] = stakerToTokens[_address].sub(rewards);
1174       }
1175 
1176       stakerToLastClaim[_address] = block.timestamp;
1177 
1178       WCAToken.transferFrom(owner(), _address, rewards);
1179     }
1180 
1181     function getTotalClaimable(address _address) external view returns (uint256) {
1182       return stakerToInitialTokens[_address];
1183     }
1184 
1185     function getRemainingClaimable(address _address) external view returns (uint256) {
1186       return stakerToTokens[_address];
1187     }
1188 
1189     function getClaimable(address _address) external view returns (uint256) {
1190       if(stakerToTokens[_address] <= 0 || stakerToInitialTokens[_address] <= 0 || block.timestamp < startUnstakeTimestamp) {
1191         return 0;
1192       }
1193 
1194       uint256 fromTimestamp = startUnstakeTimestamp;
1195       if(stakerToLastClaim[_address] > startUnstakeTimestamp){
1196         fromTimestamp = stakerToLastClaim[_address];
1197       }
1198 
1199       uint256 rewards = block.timestamp.sub(fromTimestamp).mul(stakerToInitialTokens[_address]).mul(emissionRate).div(divider).div(86400);
1200       if(rewards > stakerToTokens[_address]){
1201         rewards = stakerToTokens[_address];
1202       }
1203 
1204       return rewards;
1205     }
1206 }