1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
173 
174 
175 
176 pragma solidity ^0.8.0;
177 
178 
179 /**
180  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
181  * @dev See https://eips.ethereum.org/EIPS/eip-721
182  */
183 interface IERC721Enumerable is IERC721 {
184     /**
185      * @dev Returns the total amount of tokens stored by the contract.
186      */
187     function totalSupply() external view returns (uint256);
188 
189     /**
190      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
191      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
192      */
193     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
194 
195     /**
196      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
197      * Use along with {totalSupply} to enumerate all tokens.
198      */
199     function tokenByIndex(uint256 index) external view returns (uint256);
200 }
201 
202 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
203 
204 
205 
206 pragma solidity ^0.8.0;
207 
208 // CAUTION
209 // This version of SafeMath should only be used with Solidity 0.8 or later,
210 // because it relies on the compiler's built in overflow checks.
211 
212 /**
213  * @dev Wrappers over Solidity's arithmetic operations.
214  *
215  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
216  * now has built in overflow checking.
217  */
218 library SafeMath {
219     /**
220      * @dev Returns the addition of two unsigned integers, with an overflow flag.
221      *
222      * _Available since v3.4._
223      */
224     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         unchecked {
226             uint256 c = a + b;
227             if (c < a) return (false, 0);
228             return (true, c);
229         }
230     }
231 
232     /**
233      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
234      *
235      * _Available since v3.4._
236      */
237     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
238         unchecked {
239             if (b > a) return (false, 0);
240             return (true, a - b);
241         }
242     }
243 
244     /**
245      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
246      *
247      * _Available since v3.4._
248      */
249     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
252             // benefit is lost if 'b' is also tested.
253             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
254             if (a == 0) return (true, 0);
255             uint256 c = a * b;
256             if (c / a != b) return (false, 0);
257             return (true, c);
258         }
259     }
260 
261     /**
262      * @dev Returns the division of two unsigned integers, with a division by zero flag.
263      *
264      * _Available since v3.4._
265      */
266     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
267         unchecked {
268             if (b == 0) return (false, 0);
269             return (true, a / b);
270         }
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
275      *
276      * _Available since v3.4._
277      */
278     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (b == 0) return (false, 0);
281             return (true, a % b);
282         }
283     }
284 
285     /**
286      * @dev Returns the addition of two unsigned integers, reverting on
287      * overflow.
288      *
289      * Counterpart to Solidity's `+` operator.
290      *
291      * Requirements:
292      *
293      * - Addition cannot overflow.
294      */
295     function add(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a + b;
297     }
298 
299     /**
300      * @dev Returns the subtraction of two unsigned integers, reverting on
301      * overflow (when the result is negative).
302      *
303      * Counterpart to Solidity's `-` operator.
304      *
305      * Requirements:
306      *
307      * - Subtraction cannot overflow.
308      */
309     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
310         return a - b;
311     }
312 
313     /**
314      * @dev Returns the multiplication of two unsigned integers, reverting on
315      * overflow.
316      *
317      * Counterpart to Solidity's `*` operator.
318      *
319      * Requirements:
320      *
321      * - Multiplication cannot overflow.
322      */
323     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
324         return a * b;
325     }
326 
327     /**
328      * @dev Returns the integer division of two unsigned integers, reverting on
329      * division by zero. The result is rounded towards zero.
330      *
331      * Counterpart to Solidity's `/` operator.
332      *
333      * Requirements:
334      *
335      * - The divisor cannot be zero.
336      */
337     function div(uint256 a, uint256 b) internal pure returns (uint256) {
338         return a / b;
339     }
340 
341     /**
342      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
343      * reverting when dividing by zero.
344      *
345      * Counterpart to Solidity's `%` operator. This function uses a `revert`
346      * opcode (which leaves remaining gas untouched) while Solidity uses an
347      * invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
354         return a % b;
355     }
356 
357     /**
358      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
359      * overflow (when the result is negative).
360      *
361      * CAUTION: This function is deprecated because it requires allocating memory for the error
362      * message unnecessarily. For custom revert reasons use {trySub}.
363      *
364      * Counterpart to Solidity's `-` operator.
365      *
366      * Requirements:
367      *
368      * - Subtraction cannot overflow.
369      */
370     function sub(
371         uint256 a,
372         uint256 b,
373         string memory errorMessage
374     ) internal pure returns (uint256) {
375         unchecked {
376             require(b <= a, errorMessage);
377             return a - b;
378         }
379     }
380 
381     /**
382      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
383      * division by zero. The result is rounded towards zero.
384      *
385      * Counterpart to Solidity's `/` operator. Note: this function uses a
386      * `revert` opcode (which leaves remaining gas untouched) while Solidity
387      * uses an invalid opcode to revert (consuming all remaining gas).
388      *
389      * Requirements:
390      *
391      * - The divisor cannot be zero.
392      */
393     function div(
394         uint256 a,
395         uint256 b,
396         string memory errorMessage
397     ) internal pure returns (uint256) {
398         unchecked {
399             require(b > 0, errorMessage);
400             return a / b;
401         }
402     }
403 
404     /**
405      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
406      * reverting with custom message when dividing by zero.
407      *
408      * CAUTION: This function is deprecated because it requires allocating memory for the error
409      * message unnecessarily. For custom revert reasons use {tryMod}.
410      *
411      * Counterpart to Solidity's `%` operator. This function uses a `revert`
412      * opcode (which leaves remaining gas untouched) while Solidity uses an
413      * invalid opcode to revert (consuming all remaining gas).
414      *
415      * Requirements:
416      *
417      * - The divisor cannot be zero.
418      */
419     function mod(
420         uint256 a,
421         uint256 b,
422         string memory errorMessage
423     ) internal pure returns (uint256) {
424         unchecked {
425             require(b > 0, errorMessage);
426             return a % b;
427         }
428     }
429 }
430 
431 // File: @openzeppelin/contracts/utils/Context.sol
432 
433 
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev Provides information about the current execution context, including the
439  * sender of the transaction and its data. While these are generally available
440  * via msg.sender and msg.data, they should not be accessed in such a direct
441  * manner, since when dealing with meta-transactions the account sending and
442  * paying for execution may not be the actual sender (as far as an application
443  * is concerned).
444  *
445  * This contract is only required for intermediate, library-like contracts.
446  */
447 abstract contract Context {
448     function _msgSender() internal view virtual returns (address) {
449         return msg.sender;
450     }
451 
452     function _msgData() internal view virtual returns (bytes calldata) {
453         return msg.data;
454     }
455 }
456 
457 // File: @openzeppelin/contracts/access/Ownable.sol
458 
459 
460 
461 pragma solidity ^0.8.0;
462 
463 
464 /**
465  * @dev Contract module which provides a basic access control mechanism, where
466  * there is an account (an owner) that can be granted exclusive access to
467  * specific functions.
468  *
469  * By default, the owner account will be the one that deploys the contract. This
470  * can later be changed with {transferOwnership}.
471  *
472  * This module is used through inheritance. It will make available the modifier
473  * `onlyOwner`, which can be applied to your functions to restrict their use to
474  * the owner.
475  */
476 abstract contract Ownable is Context {
477     address private _owner;
478 
479     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
480 
481     /**
482      * @dev Initializes the contract setting the deployer as the initial owner.
483      */
484     constructor() {
485         _setOwner(_msgSender());
486     }
487 
488     /**
489      * @dev Returns the address of the current owner.
490      */
491     function owner() public view virtual returns (address) {
492         return _owner;
493     }
494 
495     /**
496      * @dev Throws if called by any account other than the owner.
497      */
498     modifier onlyOwner() {
499         require(owner() == _msgSender(), "Ownable: caller is not the owner");
500         _;
501     }
502 
503     /**
504      * @dev Leaves the contract without owner. It will not be possible to call
505      * `onlyOwner` functions anymore. Can only be called by the current owner.
506      *
507      * NOTE: Renouncing ownership will leave the contract without an owner,
508      * thereby removing any functionality that is only available to the owner.
509      */
510     function renounceOwnership() public virtual onlyOwner {
511         _setOwner(address(0));
512     }
513 
514     /**
515      * @dev Transfers ownership of the contract to a new account (`newOwner`).
516      * Can only be called by the current owner.
517      */
518     function transferOwnership(address newOwner) public virtual onlyOwner {
519         require(newOwner != address(0), "Ownable: new owner is the zero address");
520         _setOwner(newOwner);
521     }
522 
523     function _setOwner(address newOwner) private {
524         address oldOwner = _owner;
525         _owner = newOwner;
526         emit OwnershipTransferred(oldOwner, newOwner);
527     }
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
531 
532 
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @dev Interface of the ERC20 standard as defined in the EIP.
538  */
539 interface IERC20 {
540     /**
541      * @dev Returns the amount of tokens in existence.
542      */
543     function totalSupply() external view returns (uint256);
544 
545     /**
546      * @dev Returns the amount of tokens owned by `account`.
547      */
548     function balanceOf(address account) external view returns (uint256);
549 
550     /**
551      * @dev Moves `amount` tokens from the caller's account to `recipient`.
552      *
553      * Returns a boolean value indicating whether the operation succeeded.
554      *
555      * Emits a {Transfer} event.
556      */
557     function transfer(address recipient, uint256 amount) external returns (bool);
558 
559     /**
560      * @dev Returns the remaining number of tokens that `spender` will be
561      * allowed to spend on behalf of `owner` through {transferFrom}. This is
562      * zero by default.
563      *
564      * This value changes when {approve} or {transferFrom} are called.
565      */
566     function allowance(address owner, address spender) external view returns (uint256);
567 
568     /**
569      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
570      *
571      * Returns a boolean value indicating whether the operation succeeded.
572      *
573      * IMPORTANT: Beware that changing an allowance with this method brings the risk
574      * that someone may use both the old and the new allowance by unfortunate
575      * transaction ordering. One possible solution to mitigate this race
576      * condition is to first reduce the spender's allowance to 0 and set the
577      * desired value afterwards:
578      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
579      *
580      * Emits an {Approval} event.
581      */
582     function approve(address spender, uint256 amount) external returns (bool);
583 
584     /**
585      * @dev Moves `amount` tokens from `sender` to `recipient` using the
586      * allowance mechanism. `amount` is then deducted from the caller's
587      * allowance.
588      *
589      * Returns a boolean value indicating whether the operation succeeded.
590      *
591      * Emits a {Transfer} event.
592      */
593     function transferFrom(
594         address sender,
595         address recipient,
596         uint256 amount
597     ) external returns (bool);
598 
599     /**
600      * @dev Emitted when `value` tokens are moved from one account (`from`) to
601      * another (`to`).
602      *
603      * Note that `value` may be zero.
604      */
605     event Transfer(address indexed from, address indexed to, uint256 value);
606 
607     /**
608      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
609      * a call to {approve}. `value` is the new allowance.
610      */
611     event Approval(address indexed owner, address indexed spender, uint256 value);
612 }
613 
614 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
615 
616 
617 
618 pragma solidity ^0.8.0;
619 
620 
621 /**
622  * @dev Interface for the optional metadata functions from the ERC20 standard.
623  *
624  * _Available since v4.1._
625  */
626 interface IERC20Metadata is IERC20 {
627     /**
628      * @dev Returns the name of the token.
629      */
630     function name() external view returns (string memory);
631 
632     /**
633      * @dev Returns the symbol of the token.
634      */
635     function symbol() external view returns (string memory);
636 
637     /**
638      * @dev Returns the decimals places of the token.
639      */
640     function decimals() external view returns (uint8);
641 }
642 
643 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
644 
645 
646 
647 pragma solidity ^0.8.0;
648 
649 
650 
651 
652 /**
653  * @dev Implementation of the {IERC20} interface.
654  *
655  * This implementation is agnostic to the way tokens are created. This means
656  * that a supply mechanism has to be added in a derived contract using {_mint}.
657  * For a generic mechanism see {ERC20PresetMinterPauser}.
658  *
659  * TIP: For a detailed writeup see our guide
660  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
661  * to implement supply mechanisms].
662  *
663  * We have followed general OpenZeppelin Contracts guidelines: functions revert
664  * instead returning `false` on failure. This behavior is nonetheless
665  * conventional and does not conflict with the expectations of ERC20
666  * applications.
667  *
668  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
669  * This allows applications to reconstruct the allowance for all accounts just
670  * by listening to said events. Other implementations of the EIP may not emit
671  * these events, as it isn't required by the specification.
672  *
673  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
674  * functions have been added to mitigate the well-known issues around setting
675  * allowances. See {IERC20-approve}.
676  */
677 contract ERC20 is Context, IERC20, IERC20Metadata {
678     mapping(address => uint256) private _balances;
679 
680     mapping(address => mapping(address => uint256)) private _allowances;
681 
682     uint256 private _totalSupply;
683 
684     string private _name;
685     string private _symbol;
686 
687     /**
688      * @dev Sets the values for {name} and {symbol}.
689      *
690      * The default value of {decimals} is 18. To select a different value for
691      * {decimals} you should overload it.
692      *
693      * All two of these values are immutable: they can only be set once during
694      * construction.
695      */
696     constructor(string memory name_, string memory symbol_) {
697         _name = name_;
698         _symbol = symbol_;
699     }
700 
701     /**
702      * @dev Returns the name of the token.
703      */
704     function name() public view virtual override returns (string memory) {
705         return _name;
706     }
707 
708     /**
709      * @dev Returns the symbol of the token, usually a shorter version of the
710      * name.
711      */
712     function symbol() public view virtual override returns (string memory) {
713         return _symbol;
714     }
715 
716     /**
717      * @dev Returns the number of decimals used to get its user representation.
718      * For example, if `decimals` equals `2`, a balance of `505` tokens should
719      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
720      *
721      * Tokens usually opt for a value of 18, imitating the relationship between
722      * Ether and Wei. This is the value {ERC20} uses, unless this function is
723      * overridden;
724      *
725      * NOTE: This information is only used for _display_ purposes: it in
726      * no way affects any of the arithmetic of the contract, including
727      * {IERC20-balanceOf} and {IERC20-transfer}.
728      */
729     function decimals() public view virtual override returns (uint8) {
730         return 18;
731     }
732 
733     /**
734      * @dev See {IERC20-totalSupply}.
735      */
736     function totalSupply() public view virtual override returns (uint256) {
737         return _totalSupply;
738     }
739 
740     /**
741      * @dev See {IERC20-balanceOf}.
742      */
743     function balanceOf(address account) public view virtual override returns (uint256) {
744         return _balances[account];
745     }
746 
747     /**
748      * @dev See {IERC20-transfer}.
749      *
750      * Requirements:
751      *
752      * - `recipient` cannot be the zero address.
753      * - the caller must have a balance of at least `amount`.
754      */
755     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
756         _transfer(_msgSender(), recipient, amount);
757         return true;
758     }
759 
760     /**
761      * @dev See {IERC20-allowance}.
762      */
763     function allowance(address owner, address spender) public view virtual override returns (uint256) {
764         return _allowances[owner][spender];
765     }
766 
767     /**
768      * @dev See {IERC20-approve}.
769      *
770      * Requirements:
771      *
772      * - `spender` cannot be the zero address.
773      */
774     function approve(address spender, uint256 amount) public virtual override returns (bool) {
775         _approve(_msgSender(), spender, amount);
776         return true;
777     }
778 
779     /**
780      * @dev See {IERC20-transferFrom}.
781      *
782      * Emits an {Approval} event indicating the updated allowance. This is not
783      * required by the EIP. See the note at the beginning of {ERC20}.
784      *
785      * Requirements:
786      *
787      * - `sender` and `recipient` cannot be the zero address.
788      * - `sender` must have a balance of at least `amount`.
789      * - the caller must have allowance for ``sender``'s tokens of at least
790      * `amount`.
791      */
792     function transferFrom(
793         address sender,
794         address recipient,
795         uint256 amount
796     ) public virtual override returns (bool) {
797         _transfer(sender, recipient, amount);
798 
799         uint256 currentAllowance = _allowances[sender][_msgSender()];
800         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
801         unchecked {
802             _approve(sender, _msgSender(), currentAllowance - amount);
803         }
804 
805         return true;
806     }
807 
808     /**
809      * @dev Atomically increases the allowance granted to `spender` by the caller.
810      *
811      * This is an alternative to {approve} that can be used as a mitigation for
812      * problems described in {IERC20-approve}.
813      *
814      * Emits an {Approval} event indicating the updated allowance.
815      *
816      * Requirements:
817      *
818      * - `spender` cannot be the zero address.
819      */
820     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
821         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
822         return true;
823     }
824 
825     /**
826      * @dev Atomically decreases the allowance granted to `spender` by the caller.
827      *
828      * This is an alternative to {approve} that can be used as a mitigation for
829      * problems described in {IERC20-approve}.
830      *
831      * Emits an {Approval} event indicating the updated allowance.
832      *
833      * Requirements:
834      *
835      * - `spender` cannot be the zero address.
836      * - `spender` must have allowance for the caller of at least
837      * `subtractedValue`.
838      */
839     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
840         uint256 currentAllowance = _allowances[_msgSender()][spender];
841         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
842         unchecked {
843             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
844         }
845 
846         return true;
847     }
848 
849     /**
850      * @dev Moves `amount` of tokens from `sender` to `recipient`.
851      *
852      * This internal function is equivalent to {transfer}, and can be used to
853      * e.g. implement automatic token fees, slashing mechanisms, etc.
854      *
855      * Emits a {Transfer} event.
856      *
857      * Requirements:
858      *
859      * - `sender` cannot be the zero address.
860      * - `recipient` cannot be the zero address.
861      * - `sender` must have a balance of at least `amount`.
862      */
863     function _transfer(
864         address sender,
865         address recipient,
866         uint256 amount
867     ) internal virtual {
868         require(sender != address(0), "ERC20: transfer from the zero address");
869         require(recipient != address(0), "ERC20: transfer to the zero address");
870 
871         _beforeTokenTransfer(sender, recipient, amount);
872 
873         uint256 senderBalance = _balances[sender];
874         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
875         unchecked {
876             _balances[sender] = senderBalance - amount;
877         }
878         _balances[recipient] += amount;
879 
880         emit Transfer(sender, recipient, amount);
881 
882         _afterTokenTransfer(sender, recipient, amount);
883     }
884 
885     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
886      * the total supply.
887      *
888      * Emits a {Transfer} event with `from` set to the zero address.
889      *
890      * Requirements:
891      *
892      * - `account` cannot be the zero address.
893      */
894     function _mint(address account, uint256 amount) internal virtual {
895         require(account != address(0), "ERC20: mint to the zero address");
896 
897         _beforeTokenTransfer(address(0), account, amount);
898 
899         _totalSupply += amount;
900         _balances[account] += amount;
901         emit Transfer(address(0), account, amount);
902 
903         _afterTokenTransfer(address(0), account, amount);
904     }
905 
906     /**
907      * @dev Destroys `amount` tokens from `account`, reducing the
908      * total supply.
909      *
910      * Emits a {Transfer} event with `to` set to the zero address.
911      *
912      * Requirements:
913      *
914      * - `account` cannot be the zero address.
915      * - `account` must have at least `amount` tokens.
916      */
917     function _burn(address account, uint256 amount) internal virtual {
918         require(account != address(0), "ERC20: burn from the zero address");
919 
920         _beforeTokenTransfer(account, address(0), amount);
921 
922         uint256 accountBalance = _balances[account];
923         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
924         unchecked {
925             _balances[account] = accountBalance - amount;
926         }
927         _totalSupply -= amount;
928 
929         emit Transfer(account, address(0), amount);
930 
931         _afterTokenTransfer(account, address(0), amount);
932     }
933 
934     /**
935      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
936      *
937      * This internal function is equivalent to `approve`, and can be used to
938      * e.g. set automatic allowances for certain subsystems, etc.
939      *
940      * Emits an {Approval} event.
941      *
942      * Requirements:
943      *
944      * - `owner` cannot be the zero address.
945      * - `spender` cannot be the zero address.
946      */
947     function _approve(
948         address owner,
949         address spender,
950         uint256 amount
951     ) internal virtual {
952         require(owner != address(0), "ERC20: approve from the zero address");
953         require(spender != address(0), "ERC20: approve to the zero address");
954 
955         _allowances[owner][spender] = amount;
956         emit Approval(owner, spender, amount);
957     }
958 
959     /**
960      * @dev Hook that is called before any transfer of tokens. This includes
961      * minting and burning.
962      *
963      * Calling conditions:
964      *
965      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
966      * will be transferred to `to`.
967      * - when `from` is zero, `amount` tokens will be minted for `to`.
968      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
969      * - `from` and `to` are never both zero.
970      *
971      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
972      */
973     function _beforeTokenTransfer(
974         address from,
975         address to,
976         uint256 amount
977     ) internal virtual {}
978 
979     /**
980      * @dev Hook that is called after any transfer of tokens. This includes
981      * minting and burning.
982      *
983      * Calling conditions:
984      *
985      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
986      * has been transferred to `to`.
987      * - when `from` is zero, `amount` tokens have been minted for `to`.
988      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
989      * - `from` and `to` are never both zero.
990      *
991      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
992      */
993     function _afterTokenTransfer(
994         address from,
995         address to,
996         uint256 amount
997     ) internal virtual {}
998 }
999 
1000 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1001 
1002 
1003 
1004 pragma solidity ^0.8.0;
1005 
1006 
1007 
1008 /**
1009  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1010  * tokens and those that they have an allowance for, in a way that can be
1011  * recognized off-chain (via event analysis).
1012  */
1013 abstract contract ERC20Burnable is Context, ERC20 {
1014     /**
1015      * @dev Destroys `amount` tokens from the caller.
1016      *
1017      * See {ERC20-_burn}.
1018      */
1019     function burn(uint256 amount) public virtual {
1020         _burn(_msgSender(), amount);
1021     }
1022 
1023     /**
1024      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1025      * allowance.
1026      *
1027      * See {ERC20-_burn} and {ERC20-allowance}.
1028      *
1029      * Requirements:
1030      *
1031      * - the caller must have allowance for ``accounts``'s tokens of at least
1032      * `amount`.
1033      */
1034     function burnFrom(address account, uint256 amount) public virtual {
1035         uint256 currentAllowance = allowance(account, _msgSender());
1036         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1037         unchecked {
1038             _approve(account, _msgSender(), currentAllowance - amount);
1039         }
1040         _burn(account, amount);
1041     }
1042 }
1043 
1044 // File: contracts/Token.sol
1045 
1046 // contracts/Token.sol
1047 
1048 pragma solidity ^0.8.0;
1049 
1050 
1051 
1052 
1053 
1054 contract Token is ERC20Burnable, Ownable {
1055     using SafeMath for uint256;
1056 
1057     uint256 public MAX_WALLET_STAKED = 10;
1058     uint256 public EMISSIONS_RATE = 11574070000000;
1059     uint256 public CLAIM_END_TIME = 1641013200;
1060 
1061     address nullAddress = 0x0000000000000000000000000000000000000000;
1062 
1063     address public nfTokenAddress;
1064 
1065     //Mapping of mouse to timestamp
1066     mapping(uint256 => uint256) internal tokenIdToTimeStamp;
1067 
1068     //Mapping of mouse to staker
1069     mapping(uint256 => address) internal tokenIdToStaker;
1070 
1071     //Mapping of staker to NFT id
1072     mapping(address => uint256[]) internal stakerToTokenIds;
1073 
1074     constructor() ERC20("Token", "TKN") {}
1075 
1076     function setNfTokenAddress(address _nfTokenAddress) public onlyOwner {
1077         nfTokenAddress = _nfTokenAddress;
1078         return;
1079     }
1080 
1081     function getTokensStaked(address staker)
1082         public
1083         view
1084         returns (uint256[] memory)
1085     {
1086         return stakerToTokenIds[staker];
1087     }
1088 
1089     function remove(address staker, uint256 index) internal {
1090         if (index >= stakerToTokenIds[staker].length) return;
1091 
1092         for (uint256 i = index; i < stakerToTokenIds[staker].length - 1; i++) {
1093             stakerToTokenIds[staker][i] = stakerToTokenIds[staker][i + 1];
1094         }
1095         stakerToTokenIds[staker].pop();
1096     }
1097 
1098     function removeTokenIdFromStaker(address staker, uint256 tokenId) internal {
1099         for (uint256 i = 0; i < stakerToTokenIds[staker].length; i++) {
1100             if (stakerToTokenIds[staker][i] == tokenId) {
1101                 //This is the tokenId to remove;
1102                 remove(staker, i);
1103             }
1104         }
1105     }
1106 
1107     function stakeByIds(uint256[] memory tokenIds) public {
1108         require(
1109             stakerToTokenIds[msg.sender].length + tokenIds.length <=
1110                 MAX_WALLET_STAKED,
1111             "Must have less than 10 tokens staked!"
1112         );
1113 
1114         for (uint256 i = 0; i < tokenIds.length; i++) {
1115             require(
1116                 IERC721(nfTokenAddress).ownerOf(tokenIds[i]) == msg.sender &&
1117                     tokenIdToStaker[tokenIds[i]] == nullAddress,
1118                 "Token must be stakable by you!"
1119             );
1120 
1121             IERC721(nfTokenAddress).transferFrom(
1122                 msg.sender,
1123                 address(this),
1124                 tokenIds[i]
1125             );
1126 
1127             stakerToTokenIds[msg.sender].push(tokenIds[i]);
1128 
1129             tokenIdToTimeStamp[tokenIds[i]] = block.timestamp;
1130             tokenIdToStaker[tokenIds[i]] = msg.sender;
1131         }
1132     }
1133 
1134     function unstakeAll() public {
1135         require(
1136             stakerToTokenIds[msg.sender].length > 0,
1137             "Must have at least one token staked!"
1138         );
1139         uint256 totalRewards = 0;
1140 
1141         for (uint256 i = stakerToTokenIds[msg.sender].length; i > 0; i--) {
1142             uint256 tokenId = stakerToTokenIds[msg.sender][i - 1];
1143 
1144             IERC721(nfTokenAddress).transferFrom(
1145                 address(this),
1146                 msg.sender,
1147                 tokenId
1148             );
1149 
1150             totalRewards =
1151                 totalRewards +
1152                 ((block.timestamp - tokenIdToTimeStamp[tokenId]) *
1153                     EMISSIONS_RATE);
1154 
1155             removeTokenIdFromStaker(msg.sender, tokenId);
1156 
1157             tokenIdToStaker[tokenId] = nullAddress;
1158         }
1159 
1160         _mint(msg.sender, totalRewards);
1161     }
1162 
1163     function unstakeByIds(uint256[] memory tokenIds) public {
1164         uint256 totalRewards = 0;
1165 
1166         for (uint256 i = 0; i < tokenIds.length; i++) {
1167             require(
1168                 tokenIdToStaker[tokenIds[i]] == msg.sender,
1169                 "Message Sender was not original staker!"
1170             );
1171 
1172             IERC721(nfTokenAddress).transferFrom(
1173                 address(this),
1174                 msg.sender,
1175                 tokenIds[i]
1176             );
1177 
1178             totalRewards =
1179                 totalRewards +
1180                 ((block.timestamp - tokenIdToTimeStamp[tokenIds[i]]) *
1181                     EMISSIONS_RATE);
1182 
1183             removeTokenIdFromStaker(msg.sender, tokenIds[i]);
1184 
1185             tokenIdToStaker[tokenIds[i]] = nullAddress;
1186         }
1187 
1188         _mint(msg.sender, totalRewards);
1189     }
1190 
1191     function claimByTokenId(uint256 tokenId) public {
1192         require(
1193             tokenIdToStaker[tokenId] == msg.sender,
1194             "Token is not claimable by you!"
1195         );
1196         require(block.timestamp < CLAIM_END_TIME, "Claim period is over!");
1197 
1198         _mint(
1199             msg.sender,
1200             ((block.timestamp - tokenIdToTimeStamp[tokenId]) * EMISSIONS_RATE)
1201         );
1202 
1203         tokenIdToTimeStamp[tokenId] = block.timestamp;
1204     }
1205 
1206     function claimAll() public {
1207         require(block.timestamp < CLAIM_END_TIME, "Claim period is over!");
1208         uint256[] memory tokenIds = stakerToTokenIds[msg.sender];
1209         uint256 totalRewards = 0;
1210 
1211         for (uint256 i = 0; i < tokenIds.length; i++) {
1212             require(
1213                 tokenIdToStaker[tokenIds[i]] == msg.sender,
1214                 "Token is not claimable by you!"
1215             );
1216 
1217             totalRewards =
1218                 totalRewards +
1219                 ((block.timestamp - tokenIdToTimeStamp[tokenIds[i]]) *
1220                     EMISSIONS_RATE);
1221 
1222             tokenIdToTimeStamp[tokenIds[i]] = block.timestamp;
1223         }
1224 
1225         _mint(msg.sender, totalRewards);
1226     }
1227 
1228     function getAllRewards(address staker) public view returns (uint256) {
1229         uint256[] memory tokenIds = stakerToTokenIds[staker];
1230         uint256 totalRewards = 0;
1231 
1232         for (uint256 i = 0; i < tokenIds.length; i++) {
1233             totalRewards =
1234                 totalRewards +
1235                 ((block.timestamp - tokenIdToTimeStamp[tokenIds[i]]) *
1236                     EMISSIONS_RATE);
1237         }
1238 
1239         return totalRewards;
1240     }
1241 
1242     function getRewardsByTokenId(uint256 tokenId)
1243         public
1244         view
1245         returns (uint256)
1246     {
1247         require(
1248             tokenIdToStaker[tokenId] != nullAddress,
1249             "Token is not staked!"
1250         );
1251 
1252         uint256 secondsStaked = block.timestamp - tokenIdToTimeStamp[tokenId];
1253 
1254         return secondsStaked * EMISSIONS_RATE;
1255     }
1256 
1257     function getStaker(uint256 tokenId) public view returns (address) {
1258         return tokenIdToStaker[tokenId];
1259     }
1260 }