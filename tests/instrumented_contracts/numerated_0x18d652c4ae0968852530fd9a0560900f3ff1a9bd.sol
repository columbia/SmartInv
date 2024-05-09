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
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
99      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
174 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 // CAUTION
182 // This version of SafeMath should only be used with Solidity 0.8 or later,
183 // because it relies on the compiler's built in overflow checks.
184 
185 /**
186  * @dev Wrappers over Solidity's arithmetic operations.
187  *
188  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
189  * now has built in overflow checking.
190  */
191 library SafeMath {
192     /**
193      * @dev Returns the addition of two unsigned integers, with an overflow flag.
194      *
195      * _Available since v3.4._
196      */
197     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
198         unchecked {
199             uint256 c = a + b;
200             if (c < a) return (false, 0);
201             return (true, c);
202         }
203     }
204 
205     /**
206      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
207      *
208      * _Available since v3.4._
209      */
210     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
211         unchecked {
212             if (b > a) return (false, 0);
213             return (true, a - b);
214         }
215     }
216 
217     /**
218      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
219      *
220      * _Available since v3.4._
221      */
222     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
223         unchecked {
224             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
225             // benefit is lost if 'b' is also tested.
226             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
227             if (a == 0) return (true, 0);
228             uint256 c = a * b;
229             if (c / a != b) return (false, 0);
230             return (true, c);
231         }
232     }
233 
234     /**
235      * @dev Returns the division of two unsigned integers, with a division by zero flag.
236      *
237      * _Available since v3.4._
238      */
239     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241             if (b == 0) return (false, 0);
242             return (true, a / b);
243         }
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
248      *
249      * _Available since v3.4._
250      */
251     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         unchecked {
253             if (b == 0) return (false, 0);
254             return (true, a % b);
255         }
256     }
257 
258     /**
259      * @dev Returns the addition of two unsigned integers, reverting on
260      * overflow.
261      *
262      * Counterpart to Solidity's `+` operator.
263      *
264      * Requirements:
265      *
266      * - Addition cannot overflow.
267      */
268     function add(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a + b;
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting on
274      * overflow (when the result is negative).
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      *
280      * - Subtraction cannot overflow.
281      */
282     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a - b;
284     }
285 
286     /**
287      * @dev Returns the multiplication of two unsigned integers, reverting on
288      * overflow.
289      *
290      * Counterpart to Solidity's `*` operator.
291      *
292      * Requirements:
293      *
294      * - Multiplication cannot overflow.
295      */
296     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a * b;
298     }
299 
300     /**
301      * @dev Returns the integer division of two unsigned integers, reverting on
302      * division by zero. The result is rounded towards zero.
303      *
304      * Counterpart to Solidity's `/` operator.
305      *
306      * Requirements:
307      *
308      * - The divisor cannot be zero.
309      */
310     function div(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a / b;
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * reverting when dividing by zero.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      *
324      * - The divisor cannot be zero.
325      */
326     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
327         return a % b;
328     }
329 
330     /**
331      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
332      * overflow (when the result is negative).
333      *
334      * CAUTION: This function is deprecated because it requires allocating memory for the error
335      * message unnecessarily. For custom revert reasons use {trySub}.
336      *
337      * Counterpart to Solidity's `-` operator.
338      *
339      * Requirements:
340      *
341      * - Subtraction cannot overflow.
342      */
343     function sub(
344         uint256 a,
345         uint256 b,
346         string memory errorMessage
347     ) internal pure returns (uint256) {
348         unchecked {
349             require(b <= a, errorMessage);
350             return a - b;
351         }
352     }
353 
354     /**
355      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
356      * division by zero. The result is rounded towards zero.
357      *
358      * Counterpart to Solidity's `/` operator. Note: this function uses a
359      * `revert` opcode (which leaves remaining gas untouched) while Solidity
360      * uses an invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      *
364      * - The divisor cannot be zero.
365      */
366     function div(
367         uint256 a,
368         uint256 b,
369         string memory errorMessage
370     ) internal pure returns (uint256) {
371         unchecked {
372             require(b > 0, errorMessage);
373             return a / b;
374         }
375     }
376 
377     /**
378      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
379      * reverting with custom message when dividing by zero.
380      *
381      * CAUTION: This function is deprecated because it requires allocating memory for the error
382      * message unnecessarily. For custom revert reasons use {tryMod}.
383      *
384      * Counterpart to Solidity's `%` operator. This function uses a `revert`
385      * opcode (which leaves remaining gas untouched) while Solidity uses an
386      * invalid opcode to revert (consuming all remaining gas).
387      *
388      * Requirements:
389      *
390      * - The divisor cannot be zero.
391      */
392     function mod(
393         uint256 a,
394         uint256 b,
395         string memory errorMessage
396     ) internal pure returns (uint256) {
397         unchecked {
398             require(b > 0, errorMessage);
399             return a % b;
400         }
401     }
402 }
403 
404 // File: @openzeppelin/contracts/utils/Context.sol
405 
406 
407 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
408 
409 pragma solidity ^0.8.0;
410 
411 /**
412  * @dev Provides information about the current execution context, including the
413  * sender of the transaction and its data. While these are generally available
414  * via msg.sender and msg.data, they should not be accessed in such a direct
415  * manner, since when dealing with meta-transactions the account sending and
416  * paying for execution may not be the actual sender (as far as an application
417  * is concerned).
418  *
419  * This contract is only required for intermediate, library-like contracts.
420  */
421 abstract contract Context {
422     function _msgSender() internal view virtual returns (address) {
423         return msg.sender;
424     }
425 
426     function _msgData() internal view virtual returns (bytes calldata) {
427         return msg.data;
428     }
429 }
430 
431 // File: @openzeppelin/contracts/access/Ownable.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 
439 /**
440  * @dev Contract module which provides a basic access control mechanism, where
441  * there is an account (an owner) that can be granted exclusive access to
442  * specific functions.
443  *
444  * By default, the owner account will be the one that deploys the contract. This
445  * can later be changed with {transferOwnership}.
446  *
447  * This module is used through inheritance. It will make available the modifier
448  * `onlyOwner`, which can be applied to your functions to restrict their use to
449  * the owner.
450  */
451 abstract contract Ownable is Context {
452     address private _owner;
453 
454     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
455 
456     /**
457      * @dev Initializes the contract setting the deployer as the initial owner.
458      */
459     constructor() {
460         _transferOwnership(_msgSender());
461     }
462 
463     /**
464      * @dev Returns the address of the current owner.
465      */
466     function owner() public view virtual returns (address) {
467         return _owner;
468     }
469 
470     /**
471      * @dev Throws if called by any account other than the owner.
472      */
473     modifier onlyOwner() {
474         require(owner() == _msgSender(), "Ownable: caller is not the owner");
475         _;
476     }
477 
478     /**
479      * @dev Leaves the contract without owner. It will not be possible to call
480      * `onlyOwner` functions anymore. Can only be called by the current owner.
481      *
482      * NOTE: Renouncing ownership will leave the contract without an owner,
483      * thereby removing any functionality that is only available to the owner.
484      */
485     function renounceOwnership() public virtual onlyOwner {
486         _transferOwnership(address(0));
487     }
488 
489     /**
490      * @dev Transfers ownership of the contract to a new account (`newOwner`).
491      * Can only be called by the current owner.
492      */
493     function transferOwnership(address newOwner) public virtual onlyOwner {
494         require(newOwner != address(0), "Ownable: new owner is the zero address");
495         _transferOwnership(newOwner);
496     }
497 
498     /**
499      * @dev Transfers ownership of the contract to a new account (`newOwner`).
500      * Internal function without access restriction.
501      */
502     function _transferOwnership(address newOwner) internal virtual {
503         address oldOwner = _owner;
504         _owner = newOwner;
505         emit OwnershipTransferred(oldOwner, newOwner);
506     }
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
510 
511 
512 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Interface of the ERC20 standard as defined in the EIP.
518  */
519 interface IERC20 {
520     /**
521      * @dev Emitted when `value` tokens are moved from one account (`from`) to
522      * another (`to`).
523      *
524      * Note that `value` may be zero.
525      */
526     event Transfer(address indexed from, address indexed to, uint256 value);
527 
528     /**
529      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
530      * a call to {approve}. `value` is the new allowance.
531      */
532     event Approval(address indexed owner, address indexed spender, uint256 value);
533 
534     /**
535      * @dev Returns the amount of tokens in existence.
536      */
537     function totalSupply() external view returns (uint256);
538 
539     /**
540      * @dev Returns the amount of tokens owned by `account`.
541      */
542     function balanceOf(address account) external view returns (uint256);
543 
544     /**
545      * @dev Moves `amount` tokens from the caller's account to `to`.
546      *
547      * Returns a boolean value indicating whether the operation succeeded.
548      *
549      * Emits a {Transfer} event.
550      */
551     function transfer(address to, uint256 amount) external returns (bool);
552 
553     /**
554      * @dev Returns the remaining number of tokens that `spender` will be
555      * allowed to spend on behalf of `owner` through {transferFrom}. This is
556      * zero by default.
557      *
558      * This value changes when {approve} or {transferFrom} are called.
559      */
560     function allowance(address owner, address spender) external view returns (uint256);
561 
562     /**
563      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
564      *
565      * Returns a boolean value indicating whether the operation succeeded.
566      *
567      * IMPORTANT: Beware that changing an allowance with this method brings the risk
568      * that someone may use both the old and the new allowance by unfortunate
569      * transaction ordering. One possible solution to mitigate this race
570      * condition is to first reduce the spender's allowance to 0 and set the
571      * desired value afterwards:
572      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
573      *
574      * Emits an {Approval} event.
575      */
576     function approve(address spender, uint256 amount) external returns (bool);
577 
578     /**
579      * @dev Moves `amount` tokens from `from` to `to` using the
580      * allowance mechanism. `amount` is then deducted from the caller's
581      * allowance.
582      *
583      * Returns a boolean value indicating whether the operation succeeded.
584      *
585      * Emits a {Transfer} event.
586      */
587     function transferFrom(
588         address from,
589         address to,
590         uint256 amount
591     ) external returns (bool);
592 }
593 
594 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 
602 /**
603  * @dev Interface for the optional metadata functions from the ERC20 standard.
604  *
605  * _Available since v4.1._
606  */
607 interface IERC20Metadata is IERC20 {
608     /**
609      * @dev Returns the name of the token.
610      */
611     function name() external view returns (string memory);
612 
613     /**
614      * @dev Returns the symbol of the token.
615      */
616     function symbol() external view returns (string memory);
617 
618     /**
619      * @dev Returns the decimals places of the token.
620      */
621     function decimals() external view returns (uint8);
622 }
623 
624 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
625 
626 
627 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 
632 
633 
634 /**
635  * @dev Implementation of the {IERC20} interface.
636  *
637  * This implementation is agnostic to the way tokens are created. This means
638  * that a supply mechanism has to be added in a derived contract using {_mint}.
639  * For a generic mechanism see {ERC20PresetMinterPauser}.
640  *
641  * TIP: For a detailed writeup see our guide
642  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
643  * to implement supply mechanisms].
644  *
645  * We have followed general OpenZeppelin Contracts guidelines: functions revert
646  * instead returning `false` on failure. This behavior is nonetheless
647  * conventional and does not conflict with the expectations of ERC20
648  * applications.
649  *
650  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
651  * This allows applications to reconstruct the allowance for all accounts just
652  * by listening to said events. Other implementations of the EIP may not emit
653  * these events, as it isn't required by the specification.
654  *
655  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
656  * functions have been added to mitigate the well-known issues around setting
657  * allowances. See {IERC20-approve}.
658  */
659 contract ERC20 is Context, IERC20, IERC20Metadata {
660     mapping(address => uint256) private _balances;
661 
662     mapping(address => mapping(address => uint256)) private _allowances;
663 
664     uint256 private _totalSupply;
665 
666     string private _name;
667     string private _symbol;
668 
669     /**
670      * @dev Sets the values for {name} and {symbol}.
671      *
672      * The default value of {decimals} is 18. To select a different value for
673      * {decimals} you should overload it.
674      *
675      * All two of these values are immutable: they can only be set once during
676      * construction.
677      */
678     constructor(string memory name_, string memory symbol_) {
679         _name = name_;
680         _symbol = symbol_;
681     }
682 
683     /**
684      * @dev Returns the name of the token.
685      */
686     function name() public view virtual override returns (string memory) {
687         return _name;
688     }
689 
690     /**
691      * @dev Returns the symbol of the token, usually a shorter version of the
692      * name.
693      */
694     function symbol() public view virtual override returns (string memory) {
695         return _symbol;
696     }
697 
698     /**
699      * @dev Returns the number of decimals used to get its user representation.
700      * For example, if `decimals` equals `2`, a balance of `505` tokens should
701      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
702      *
703      * Tokens usually opt for a value of 18, imitating the relationship between
704      * Ether and Wei. This is the value {ERC20} uses, unless this function is
705      * overridden;
706      *
707      * NOTE: This information is only used for _display_ purposes: it in
708      * no way affects any of the arithmetic of the contract, including
709      * {IERC20-balanceOf} and {IERC20-transfer}.
710      */
711     function decimals() public view virtual override returns (uint8) {
712         return 18;
713     }
714 
715     /**
716      * @dev See {IERC20-totalSupply}.
717      */
718     function totalSupply() public view virtual override returns (uint256) {
719         return _totalSupply;
720     }
721 
722     /**
723      * @dev See {IERC20-balanceOf}.
724      */
725     function balanceOf(address account) public view virtual override returns (uint256) {
726         return _balances[account];
727     }
728 
729     /**
730      * @dev See {IERC20-transfer}.
731      *
732      * Requirements:
733      *
734      * - `to` cannot be the zero address.
735      * - the caller must have a balance of at least `amount`.
736      */
737     function transfer(address to, uint256 amount) public virtual override returns (bool) {
738         address owner = _msgSender();
739         _transfer(owner, to, amount);
740         return true;
741     }
742 
743     /**
744      * @dev See {IERC20-allowance}.
745      */
746     function allowance(address owner, address spender) public view virtual override returns (uint256) {
747         return _allowances[owner][spender];
748     }
749 
750     /**
751      * @dev See {IERC20-approve}.
752      *
753      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
754      * `transferFrom`. This is semantically equivalent to an infinite approval.
755      *
756      * Requirements:
757      *
758      * - `spender` cannot be the zero address.
759      */
760     function approve(address spender, uint256 amount) public virtual override returns (bool) {
761         address owner = _msgSender();
762         _approve(owner, spender, amount);
763         return true;
764     }
765 
766     /**
767      * @dev See {IERC20-transferFrom}.
768      *
769      * Emits an {Approval} event indicating the updated allowance. This is not
770      * required by the EIP. See the note at the beginning of {ERC20}.
771      *
772      * NOTE: Does not update the allowance if the current allowance
773      * is the maximum `uint256`.
774      *
775      * Requirements:
776      *
777      * - `from` and `to` cannot be the zero address.
778      * - `from` must have a balance of at least `amount`.
779      * - the caller must have allowance for ``from``'s tokens of at least
780      * `amount`.
781      */
782     function transferFrom(
783         address from,
784         address to,
785         uint256 amount
786     ) public virtual override returns (bool) {
787         address spender = _msgSender();
788         _spendAllowance(from, spender, amount);
789         _transfer(from, to, amount);
790         return true;
791     }
792 
793     /**
794      * @dev Atomically increases the allowance granted to `spender` by the caller.
795      *
796      * This is an alternative to {approve} that can be used as a mitigation for
797      * problems described in {IERC20-approve}.
798      *
799      * Emits an {Approval} event indicating the updated allowance.
800      *
801      * Requirements:
802      *
803      * - `spender` cannot be the zero address.
804      */
805     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
806         address owner = _msgSender();
807         _approve(owner, spender, allowance(owner, spender) + addedValue);
808         return true;
809     }
810 
811     /**
812      * @dev Atomically decreases the allowance granted to `spender` by the caller.
813      *
814      * This is an alternative to {approve} that can be used as a mitigation for
815      * problems described in {IERC20-approve}.
816      *
817      * Emits an {Approval} event indicating the updated allowance.
818      *
819      * Requirements:
820      *
821      * - `spender` cannot be the zero address.
822      * - `spender` must have allowance for the caller of at least
823      * `subtractedValue`.
824      */
825     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
826         address owner = _msgSender();
827         uint256 currentAllowance = allowance(owner, spender);
828         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
829         unchecked {
830             _approve(owner, spender, currentAllowance - subtractedValue);
831         }
832 
833         return true;
834     }
835 
836     /**
837      * @dev Moves `amount` of tokens from `sender` to `recipient`.
838      *
839      * This internal function is equivalent to {transfer}, and can be used to
840      * e.g. implement automatic token fees, slashing mechanisms, etc.
841      *
842      * Emits a {Transfer} event.
843      *
844      * Requirements:
845      *
846      * - `from` cannot be the zero address.
847      * - `to` cannot be the zero address.
848      * - `from` must have a balance of at least `amount`.
849      */
850     function _transfer(
851         address from,
852         address to,
853         uint256 amount
854     ) internal virtual {
855         require(from != address(0), "ERC20: transfer from the zero address");
856         require(to != address(0), "ERC20: transfer to the zero address");
857 
858         _beforeTokenTransfer(from, to, amount);
859 
860         uint256 fromBalance = _balances[from];
861         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
862         unchecked {
863             _balances[from] = fromBalance - amount;
864         }
865         _balances[to] += amount;
866 
867         emit Transfer(from, to, amount);
868 
869         _afterTokenTransfer(from, to, amount);
870     }
871 
872     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
873      * the total supply.
874      *
875      * Emits a {Transfer} event with `from` set to the zero address.
876      *
877      * Requirements:
878      *
879      * - `account` cannot be the zero address.
880      */
881     function _mint(address account, uint256 amount) internal virtual {
882         require(account != address(0), "ERC20: mint to the zero address");
883 
884         _beforeTokenTransfer(address(0), account, amount);
885 
886         _totalSupply += amount;
887         _balances[account] += amount;
888         emit Transfer(address(0), account, amount);
889 
890         _afterTokenTransfer(address(0), account, amount);
891     }
892 
893     /**
894      * @dev Destroys `amount` tokens from `account`, reducing the
895      * total supply.
896      *
897      * Emits a {Transfer} event with `to` set to the zero address.
898      *
899      * Requirements:
900      *
901      * - `account` cannot be the zero address.
902      * - `account` must have at least `amount` tokens.
903      */
904     function _burn(address account, uint256 amount) internal virtual {
905         require(account != address(0), "ERC20: burn from the zero address");
906 
907         _beforeTokenTransfer(account, address(0), amount);
908 
909         uint256 accountBalance = _balances[account];
910         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
911         unchecked {
912             _balances[account] = accountBalance - amount;
913         }
914         _totalSupply -= amount;
915 
916         emit Transfer(account, address(0), amount);
917 
918         _afterTokenTransfer(account, address(0), amount);
919     }
920 
921     /**
922      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
923      *
924      * This internal function is equivalent to `approve`, and can be used to
925      * e.g. set automatic allowances for certain subsystems, etc.
926      *
927      * Emits an {Approval} event.
928      *
929      * Requirements:
930      *
931      * - `owner` cannot be the zero address.
932      * - `spender` cannot be the zero address.
933      */
934     function _approve(
935         address owner,
936         address spender,
937         uint256 amount
938     ) internal virtual {
939         require(owner != address(0), "ERC20: approve from the zero address");
940         require(spender != address(0), "ERC20: approve to the zero address");
941 
942         _allowances[owner][spender] = amount;
943         emit Approval(owner, spender, amount);
944     }
945 
946     /**
947      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
948      *
949      * Does not update the allowance amount in case of infinite allowance.
950      * Revert if not enough allowance is available.
951      *
952      * Might emit an {Approval} event.
953      */
954     function _spendAllowance(
955         address owner,
956         address spender,
957         uint256 amount
958     ) internal virtual {
959         uint256 currentAllowance = allowance(owner, spender);
960         if (currentAllowance != type(uint256).max) {
961             require(currentAllowance >= amount, "ERC20: insufficient allowance");
962             unchecked {
963                 _approve(owner, spender, currentAllowance - amount);
964             }
965         }
966     }
967 
968     /**
969      * @dev Hook that is called before any transfer of tokens. This includes
970      * minting and burning.
971      *
972      * Calling conditions:
973      *
974      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
975      * will be transferred to `to`.
976      * - when `from` is zero, `amount` tokens will be minted for `to`.
977      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
978      * - `from` and `to` are never both zero.
979      *
980      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
981      */
982     function _beforeTokenTransfer(
983         address from,
984         address to,
985         uint256 amount
986     ) internal virtual {}
987 
988     /**
989      * @dev Hook that is called after any transfer of tokens. This includes
990      * minting and burning.
991      *
992      * Calling conditions:
993      *
994      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
995      * has been transferred to `to`.
996      * - when `from` is zero, `amount` tokens have been minted for `to`.
997      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
998      * - `from` and `to` are never both zero.
999      *
1000      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1001      */
1002     function _afterTokenTransfer(
1003         address from,
1004         address to,
1005         uint256 amount
1006     ) internal virtual {}
1007 }
1008 
1009 // File: contracts/Gummies/GummiesStaking.sol
1010 
1011 //SPDX-License-Identifier: MIT
1012 pragma solidity 0.8.7;
1013 
1014 /**
1015  * @title Doodories Staking Platform
1016  * @author Decentralized Devs - Angelo
1017  */
1018 
1019 
1020 
1021 
1022 
1023 
1024 
1025 
1026 
1027 
1028 
1029 
1030 contract GummiesStaking is ERC20("GUM", "GUM"), Ownable{
1031     using SafeMath for uint256;
1032     bool paused = false;
1033 	IERC721 nft; 
1034     
1035     uint256 private STAKINGREWARD = 100 ether ;
1036     uint256 private LEGENDARYREWARD  = 500 ether;
1037     mapping(uint256 => bool) private legendaries;
1038     mapping(uint256 => address) public tokenIdOwners;
1039     mapping(address => uint256) public lastClaimTime;
1040     mapping(address => uint256) public numberTokensStaked;
1041     mapping(address => uint256) public numberLegendaryCount;
1042     mapping(address => uint256) private _balances;
1043     mapping(address => bool) public staff;
1044     mapping(address => mapping(uint256 => uint256)) public ownerTokenIds;
1045     
1046    
1047     modifier updateReward(address account) {
1048         uint256 reward = getRewards(account);
1049         lastClaimTime[account] = block.timestamp;
1050         _balances[account] += reward;
1051         _;
1052     }
1053 
1054     modifier onlyAllowedContracts {
1055         require(staff[msg.sender] || msg.sender == owner());
1056         _;
1057     }
1058 
1059     constructor(address _nftAddress){
1060 		nft = IERC721(_nftAddress);
1061 	}
1062 
1063     function initLegendaries(uint256[] calldata tokenIds, bool state) public onlyOwner{
1064             unchecked{
1065                 uint256 len = tokenIds.length;
1066                 for (uint256 i = 0; i < len; i++) {
1067                     uint256 tokenId = tokenIds[i];
1068                     legendaries[tokenId] = state;
1069                 }
1070             }
1071     }
1072 
1073     function isLegendary(uint256 tokenId) public view returns(bool){
1074         return legendaries[tokenId];
1075     }
1076 
1077     function setStakingReward(uint256 val) public onlyOwner{
1078         STAKINGREWARD = val;
1079     }
1080 
1081 
1082     function setLegendaryreward(uint256 val) public onlyOwner{
1083         LEGENDARYREWARD = val;
1084     }
1085 
1086     function setStaff(address user, bool state) public onlyOwner{
1087         staff[user]= state;
1088     }
1089 
1090     function mint(address user, uint256 amount) public onlyAllowedContracts {
1091         _mint(user, amount);
1092     }
1093 
1094      function burn(address user, uint256 amount) public onlyAllowedContracts {
1095         _burn(user, amount);
1096     }
1097 
1098     function viewRewards(address account) public  view returns(uint256){
1099         uint256 rewards = getRewards(account);
1100         return rewards;
1101     }
1102 
1103     function getRewards(address account) internal view returns(uint256) {
1104             uint256 _cReward = (numberTokensStaked[account] - numberLegendaryCount[account]) * STAKINGREWARD;
1105             uint256 _legendaryReward = numberLegendaryCount[account] * LEGENDARYREWARD;
1106             uint256 totalReward = _cReward + _legendaryReward; 
1107             uint256 _lastClaimed = lastClaimTime[account];
1108             return totalReward.mul(block.timestamp.sub(_lastClaimed)).div(86400);
1109     }
1110 
1111     function getBalance(address account) public view returns(uint256){
1112         uint256 pendingReward = getRewards(account);
1113         return pendingReward + _balances[account];
1114     }
1115 
1116     function claimRewards() updateReward(msg.sender) external {
1117         uint256 reward = _balances[msg.sender];
1118         _balances[msg.sender] = 0;
1119         if(numberTokensStaked[msg.sender] > 4){
1120             uint256 bonus = calculateBonus(reward, msg.sender);
1121             _mint(msg.sender, bonus);
1122         }else{
1123             _mint(msg.sender, reward);
1124         }
1125     } 
1126 
1127     function viewRewardWithBonus(address account) public view returns(uint256){
1128             uint256 bal = getBalance(account);
1129             
1130              if(numberTokensStaked[msg.sender] > 4){
1131                  uint256 bonus = calculateBonus(bal, msg.sender);
1132                  return bonus;
1133         }else{
1134             return bal;
1135         }
1136     }
1137 
1138 
1139     function calculateBonus(uint256 reward, address account) internal  view returns(uint256){
1140         uint256 _numStaked = numberTokensStaked[account];
1141         if(_numStaked >= 15){
1142             return reward.mul(120).div(100);
1143         }else if(_numStaked >= 10){
1144             return reward.mul(110).div(100);
1145         }else if(_numStaked >= 5){
1146             return reward.mul(105).div(100);
1147         }else{
1148             return reward;
1149         }
1150     }
1151 
1152      function getUserstakedIds(address _user) public view returns (uint256[] memory){
1153         uint256 len = numberTokensStaked[_user];
1154         uint256[] memory temp = new uint[](len);
1155         for (uint256 i = 0; i < len; ++i) {
1156              temp[i] = ownerTokenIds[_user][i];
1157         }
1158         return temp;
1159     }
1160 
1161     function stake(uint256[] calldata tokenIds) updateReward(msg.sender) external {
1162         require(!paused,"Contract is paused");
1163         unchecked {
1164             uint256 len = tokenIds.length;
1165             uint256 numStaked = numberTokensStaked[msg.sender];
1166             for (uint256 i = 0; i < len; i++) {
1167                 uint256 tokenId = tokenIds[i];
1168                 if(legendaries[tokenId]) {
1169                     numberLegendaryCount[msg.sender]++;
1170                 }
1171                 tokenIdOwners[tokenId] = msg.sender;
1172                 ownerTokenIds[msg.sender][numStaked] = tokenId;
1173                 numStaked++;
1174                 nft.transferFrom(msg.sender,address(this),tokenId);
1175             }
1176             numberTokensStaked[msg.sender] = numStaked;
1177         }
1178     }
1179 
1180     function unstake(uint256[] calldata tokenIds) updateReward(msg.sender) external {
1181         unchecked {
1182             uint256 len = tokenIds.length;
1183             
1184 
1185             for (uint256 i = 0; i < len; i++) {
1186                uint256 tokenId = tokenIds[i];
1187                if(legendaries[tokenId]) {
1188                     numberLegendaryCount[msg.sender]--;
1189                 }
1190                require(tokenIdOwners[tokenId] == msg.sender, "You dont own this ID");
1191                removeFromUserStakedTokens(msg.sender, tokenId);
1192                
1193                    numberTokensStaked[msg.sender]--;
1194                
1195                delete tokenIdOwners[tokenId];
1196                   nft.transferFrom(
1197                         address(this),
1198                         msg.sender,
1199                         tokenId
1200                     );
1201             }
1202               
1203           
1204         }
1205     }
1206 
1207     function togglePause() public onlyOwner{
1208         paused = !paused;
1209     }
1210 
1211     function removeFromUserStakedTokens(address user, uint256 tokenId) internal {
1212         uint256 _numStaked = numberTokensStaked[user];
1213         for (uint256 j = 0; j < _numStaked; ++j) {
1214                 if (ownerTokenIds[user][j] == tokenId) {
1215                     uint256 lastIndex = _numStaked - 1;
1216                     ownerTokenIds[user][j] = ownerTokenIds[user][
1217                         lastIndex
1218                     ];
1219                     delete ownerTokenIds[user][lastIndex];
1220                     break;
1221                 }
1222             }
1223     }
1224 
1225 
1226 
1227  
1228    
1229 
1230    
1231 
1232 }