1 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
2 
3 pragma solidity >=0.6.2;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78         external
79         payable
80         returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82         external
83         returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
100 
101 pragma solidity >=0.6.2;
102 
103 
104 interface IUniswapV2Router02 is IUniswapV2Router01 {
105     function removeLiquidityETHSupportingFeeOnTransferTokens(
106         address token,
107         uint liquidity,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountETH);
113     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountETH);
122 
123     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130     function swapExactETHForTokensSupportingFeeOnTransferTokens(
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external payable;
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 }
144 
145 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
146 
147 
148 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 // CAUTION
153 // This version of SafeMath should only be used with Solidity 0.8 or later,
154 // because it relies on the compiler's built in overflow checks.
155 
156 /**
157  * @dev Wrappers over Solidity's arithmetic operations.
158  *
159  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
160  * now has built in overflow checking.
161  */
162 library SafeMath {
163     /**
164      * @dev Returns the addition of two unsigned integers, with an overflow flag.
165      *
166      * _Available since v3.4._
167      */
168     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
169         unchecked {
170             uint256 c = a + b;
171             if (c < a) return (false, 0);
172             return (true, c);
173         }
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
178      *
179      * _Available since v3.4._
180      */
181     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
182         unchecked {
183             if (b > a) return (false, 0);
184             return (true, a - b);
185         }
186     }
187 
188     /**
189      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
190      *
191      * _Available since v3.4._
192      */
193     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
194         unchecked {
195             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196             // benefit is lost if 'b' is also tested.
197             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198             if (a == 0) return (true, 0);
199             uint256 c = a * b;
200             if (c / a != b) return (false, 0);
201             return (true, c);
202         }
203     }
204 
205     /**
206      * @dev Returns the division of two unsigned integers, with a division by zero flag.
207      *
208      * _Available since v3.4._
209      */
210     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
211         unchecked {
212             if (b == 0) return (false, 0);
213             return (true, a / b);
214         }
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
219      *
220      * _Available since v3.4._
221      */
222     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
223         unchecked {
224             if (b == 0) return (false, 0);
225             return (true, a % b);
226         }
227     }
228 
229     /**
230      * @dev Returns the addition of two unsigned integers, reverting on
231      * overflow.
232      *
233      * Counterpart to Solidity's `+` operator.
234      *
235      * Requirements:
236      *
237      * - Addition cannot overflow.
238      */
239     function add(uint256 a, uint256 b) internal pure returns (uint256) {
240         return a + b;
241     }
242 
243     /**
244      * @dev Returns the subtraction of two unsigned integers, reverting on
245      * overflow (when the result is negative).
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      *
251      * - Subtraction cannot overflow.
252      */
253     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
254         return a - b;
255     }
256 
257     /**
258      * @dev Returns the multiplication of two unsigned integers, reverting on
259      * overflow.
260      *
261      * Counterpart to Solidity's `*` operator.
262      *
263      * Requirements:
264      *
265      * - Multiplication cannot overflow.
266      */
267     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a * b;
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers, reverting on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator.
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a / b;
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * reverting when dividing by zero.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a % b;
299     }
300 
301     /**
302      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
303      * overflow (when the result is negative).
304      *
305      * CAUTION: This function is deprecated because it requires allocating memory for the error
306      * message unnecessarily. For custom revert reasons use {trySub}.
307      *
308      * Counterpart to Solidity's `-` operator.
309      *
310      * Requirements:
311      *
312      * - Subtraction cannot overflow.
313      */
314     function sub(
315         uint256 a,
316         uint256 b,
317         string memory errorMessage
318     ) internal pure returns (uint256) {
319         unchecked {
320             require(b <= a, errorMessage);
321             return a - b;
322         }
323     }
324 
325     /**
326      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
327      * division by zero. The result is rounded towards zero.
328      *
329      * Counterpart to Solidity's `/` operator. Note: this function uses a
330      * `revert` opcode (which leaves remaining gas untouched) while Solidity
331      * uses an invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      *
335      * - The divisor cannot be zero.
336      */
337     function div(
338         uint256 a,
339         uint256 b,
340         string memory errorMessage
341     ) internal pure returns (uint256) {
342         unchecked {
343             require(b > 0, errorMessage);
344             return a / b;
345         }
346     }
347 
348     /**
349      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
350      * reverting with custom message when dividing by zero.
351      *
352      * CAUTION: This function is deprecated because it requires allocating memory for the error
353      * message unnecessarily. For custom revert reasons use {tryMod}.
354      *
355      * Counterpart to Solidity's `%` operator. This function uses a `revert`
356      * opcode (which leaves remaining gas untouched) while Solidity uses an
357      * invalid opcode to revert (consuming all remaining gas).
358      *
359      * Requirements:
360      *
361      * - The divisor cannot be zero.
362      */
363     function mod(
364         uint256 a,
365         uint256 b,
366         string memory errorMessage
367     ) internal pure returns (uint256) {
368         unchecked {
369             require(b > 0, errorMessage);
370             return a % b;
371         }
372     }
373 }
374 
375 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
376 
377 
378 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @dev Interface of the ERC165 standard, as defined in the
384  * https://eips.ethereum.org/EIPS/eip-165[EIP].
385  *
386  * Implementers can declare support of contract interfaces, which can then be
387  * queried by others ({ERC165Checker}).
388  *
389  * For an implementation, see {ERC165}.
390  */
391 interface IERC165 {
392     /**
393      * @dev Returns true if this contract implements the interface defined by
394      * `interfaceId`. See the corresponding
395      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
396      * to learn more about how these ids are created.
397      *
398      * This function call must use less than 30 000 gas.
399      */
400     function supportsInterface(bytes4 interfaceId) external view returns (bool);
401 }
402 
403 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
404 
405 
406 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 
411 /**
412  * @dev Required interface of an ERC721 compliant contract.
413  */
414 interface IERC721 is IERC165 {
415     /**
416      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
417      */
418     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
419 
420     /**
421      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
422      */
423     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
424 
425     /**
426      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
427      */
428     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
429 
430     /**
431      * @dev Returns the number of tokens in ``owner``'s account.
432      */
433     function balanceOf(address owner) external view returns (uint256 balance);
434 
435     /**
436      * @dev Returns the owner of the `tokenId` token.
437      *
438      * Requirements:
439      *
440      * - `tokenId` must exist.
441      */
442     function ownerOf(uint256 tokenId) external view returns (address owner);
443 
444     /**
445      * @dev Safely transfers `tokenId` token from `from` to `to`.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must exist and be owned by `from`.
452      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
454      *
455      * Emits a {Transfer} event.
456      */
457     function safeTransferFrom(
458         address from,
459         address to,
460         uint256 tokenId,
461         bytes calldata data
462     ) external;
463 
464     /**
465      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
466      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must exist and be owned by `from`.
473      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
474      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
475      *
476      * Emits a {Transfer} event.
477      */
478     function safeTransferFrom(
479         address from,
480         address to,
481         uint256 tokenId
482     ) external;
483 
484     /**
485      * @dev Transfers `tokenId` token from `from` to `to`.
486      *
487      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
488      *
489      * Requirements:
490      *
491      * - `from` cannot be the zero address.
492      * - `to` cannot be the zero address.
493      * - `tokenId` token must be owned by `from`.
494      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
495      *
496      * Emits a {Transfer} event.
497      */
498     function transferFrom(
499         address from,
500         address to,
501         uint256 tokenId
502     ) external;
503 
504     /**
505      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
506      * The approval is cleared when the token is transferred.
507      *
508      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
509      *
510      * Requirements:
511      *
512      * - The caller must own the token or be an approved operator.
513      * - `tokenId` must exist.
514      *
515      * Emits an {Approval} event.
516      */
517     function approve(address to, uint256 tokenId) external;
518 
519     /**
520      * @dev Approve or remove `operator` as an operator for the caller.
521      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
522      *
523      * Requirements:
524      *
525      * - The `operator` cannot be the caller.
526      *
527      * Emits an {ApprovalForAll} event.
528      */
529     function setApprovalForAll(address operator, bool _approved) external;
530 
531     /**
532      * @dev Returns the account approved for `tokenId` token.
533      *
534      * Requirements:
535      *
536      * - `tokenId` must exist.
537      */
538     function getApproved(uint256 tokenId) external view returns (address operator);
539 
540     /**
541      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
542      *
543      * See {setApprovalForAll}
544      */
545     function isApprovedForAll(address owner, address operator) external view returns (bool);
546 }
547 
548 // File: @openzeppelin/contracts/interfaces/IERC721.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
557 
558 
559 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev Interface of the ERC20 standard as defined in the EIP.
565  */
566 interface IERC20 {
567     /**
568      * @dev Emitted when `value` tokens are moved from one account (`from`) to
569      * another (`to`).
570      *
571      * Note that `value` may be zero.
572      */
573     event Transfer(address indexed from, address indexed to, uint256 value);
574 
575     /**
576      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
577      * a call to {approve}. `value` is the new allowance.
578      */
579     event Approval(address indexed owner, address indexed spender, uint256 value);
580 
581     /**
582      * @dev Returns the amount of tokens in existence.
583      */
584     function totalSupply() external view returns (uint256);
585 
586     /**
587      * @dev Returns the amount of tokens owned by `account`.
588      */
589     function balanceOf(address account) external view returns (uint256);
590 
591     /**
592      * @dev Moves `amount` tokens from the caller's account to `to`.
593      *
594      * Returns a boolean value indicating whether the operation succeeded.
595      *
596      * Emits a {Transfer} event.
597      */
598     function transfer(address to, uint256 amount) external returns (bool);
599 
600     /**
601      * @dev Returns the remaining number of tokens that `spender` will be
602      * allowed to spend on behalf of `owner` through {transferFrom}. This is
603      * zero by default.
604      *
605      * This value changes when {approve} or {transferFrom} are called.
606      */
607     function allowance(address owner, address spender) external view returns (uint256);
608 
609     /**
610      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
611      *
612      * Returns a boolean value indicating whether the operation succeeded.
613      *
614      * IMPORTANT: Beware that changing an allowance with this method brings the risk
615      * that someone may use both the old and the new allowance by unfortunate
616      * transaction ordering. One possible solution to mitigate this race
617      * condition is to first reduce the spender's allowance to 0 and set the
618      * desired value afterwards:
619      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
620      *
621      * Emits an {Approval} event.
622      */
623     function approve(address spender, uint256 amount) external returns (bool);
624 
625     /**
626      * @dev Moves `amount` tokens from `from` to `to` using the
627      * allowance mechanism. `amount` is then deducted from the caller's
628      * allowance.
629      *
630      * Returns a boolean value indicating whether the operation succeeded.
631      *
632      * Emits a {Transfer} event.
633      */
634     function transferFrom(
635         address from,
636         address to,
637         uint256 amount
638     ) external returns (bool);
639 }
640 
641 // File: @openzeppelin/contracts/interfaces/IERC20.sol
642 
643 
644 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
645 
646 pragma solidity ^0.8.0;
647 
648 
649 // File: @openzeppelin/contracts/utils/Context.sol
650 
651 
652 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev Provides information about the current execution context, including the
658  * sender of the transaction and its data. While these are generally available
659  * via msg.sender and msg.data, they should not be accessed in such a direct
660  * manner, since when dealing with meta-transactions the account sending and
661  * paying for execution may not be the actual sender (as far as an application
662  * is concerned).
663  *
664  * This contract is only required for intermediate, library-like contracts.
665  */
666 abstract contract Context {
667     function _msgSender() internal view virtual returns (address) {
668         return msg.sender;
669     }
670 
671     function _msgData() internal view virtual returns (bytes calldata) {
672         return msg.data;
673     }
674 }
675 
676 // File: @openzeppelin/contracts/access/Ownable.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 
684 /**
685  * @dev Contract module which provides a basic access control mechanism, where
686  * there is an account (an owner) that can be granted exclusive access to
687  * specific functions.
688  *
689  * By default, the owner account will be the one that deploys the contract. This
690  * can later be changed with {transferOwnership}.
691  *
692  * This module is used through inheritance. It will make available the modifier
693  * `onlyOwner`, which can be applied to your functions to restrict their use to
694  * the owner.
695  */
696 abstract contract Ownable is Context {
697     address private _owner;
698 
699     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
700 
701     /**
702      * @dev Initializes the contract setting the deployer as the initial owner.
703      */
704     constructor() {
705         _transferOwnership(_msgSender());
706     }
707 
708     /**
709      * @dev Returns the address of the current owner.
710      */
711     function owner() public view virtual returns (address) {
712         return _owner;
713     }
714 
715     /**
716      * @dev Throws if called by any account other than the owner.
717      */
718     modifier onlyOwner() {
719         require(owner() == _msgSender(), "Ownable: caller is not the owner");
720         _;
721     }
722 
723     /**
724      * @dev Leaves the contract without owner. It will not be possible to call
725      * `onlyOwner` functions anymore. Can only be called by the current owner.
726      *
727      * NOTE: Renouncing ownership will leave the contract without an owner,
728      * thereby removing any functionality that is only available to the owner.
729      */
730     function renounceOwnership() public virtual onlyOwner {
731         _transferOwnership(address(0));
732     }
733 
734     /**
735      * @dev Transfers ownership of the contract to a new account (`newOwner`).
736      * Can only be called by the current owner.
737      */
738     function transferOwnership(address newOwner) public virtual onlyOwner {
739         require(newOwner != address(0), "Ownable: new owner is the zero address");
740         _transferOwnership(newOwner);
741     }
742 
743     /**
744      * @dev Transfers ownership of the contract to a new account (`newOwner`).
745      * Internal function without access restriction.
746      */
747     function _transferOwnership(address newOwner) internal virtual {
748         address oldOwner = _owner;
749         _owner = newOwner;
750         emit OwnershipTransferred(oldOwner, newOwner);
751     }
752 }
753 
754 // File: KittPad.sol
755 
756 
757 pragma solidity ^0.8.4;
758 
759 
760 
761 
762 
763 
764 interface IKittPad {
765   function depositRewardsEth() external payable;
766 
767   function getShares(address wallet) external view returns (uint256);
768 
769   function getBoostNfts(address wallet)
770     external
771     view
772     returns (uint256[] memory);
773 }
774 
775 contract KittPad is IKittPad, Ownable {
776   using SafeMath for uint256;
777 
778   struct Reward {
779     mapping(address => uint256) totalExcluded; // excluded reward
780     mapping(address => uint256) totalRealised;
781     uint256 totalRealisedForNft;
782     uint256 totalExcludedForNft;
783     uint256 lastClaim; // used for boosting logic
784   }
785 
786   struct Share {
787     uint256 amount;
788     uint256 amountBase;
789     uint256 stakedTime;
790     uint256 nftStakedTime;
791     uint256[] nftBoostTokenIds;
792   }
793 
794   uint256 public minSecondsBeforeUnstake = 43200;
795   uint256 public minSecondsBeforeUnstakeNFT = 2592000; // 30 days
796   address public shareholderToken;
797   address public nftBoosterToken;
798   uint256 public nftBoostPercentage = 2; // 2% boost per NFT staked
799   uint256 public maxNftsCanBoost = 10;
800   uint256 public totalStakedUsers;
801   uint256 public totalSharesBoosted;
802   uint256 public totalNftStaked;
803   uint256 public totalSharesDeposited; // will only be actual deposited tokens without handling any reflections or otherwise
804   IUniswapV2Router02 router;
805 
806   // amount of shares a user has
807   mapping(address => Share) shares;
808   // reward information per user
809   mapping(address => Reward) public rewards;
810   // staker list
811   address[] public stakers;
812   uint256 public totalRewardsEth;
813   mapping(address => uint256) totalRewardsToken;
814   mapping(address => uint256) rewardsPerShareToken;
815   address[] public prTokenList;
816   uint256 public totalDistributed;
817   uint256 public rewardsEthPerNft;
818 
819   uint256 public constant ACC_FACTOR = 10**36;
820   
821   constructor(
822     address _shareholderToken,
823     address _nftToken
824   ) {
825     shareholderToken = _shareholderToken;
826     nftBoosterToken = _nftToken;
827   }
828 
829   function getPrTokenList() external view returns(address[] memory){
830     return prTokenList;
831   }
832 
833   function stake(uint256 amount) external {
834     _stake(msg.sender, amount);
835   }
836 
837   function stakeNFT(uint256[] memory nftTokenIds) external {
838     address shareholder = msg.sender;
839     require(nftTokenIds.length > 0, "You should stake NFTs more than one.");
840     if (shares[shareholder].nftBoostTokenIds.length > 0)
841       distributeRewardForNft(shareholder);
842     IERC721 nftContract = IERC721(nftBoosterToken);
843     for (uint256 i = 0; i < nftTokenIds.length; i++) {
844       nftContract.transferFrom(shareholder, address(this), nftTokenIds[i]);
845       shares[shareholder].nftBoostTokenIds.push(nftTokenIds[i]);
846     }
847     shares[shareholder].nftStakedTime = block.timestamp;
848     totalNftStaked = totalNftStaked.add(nftTokenIds.length);
849     rewards[shareholder].totalExcludedForNft = getCumulativeRewardsEth(
850       shares[shareholder].nftBoostTokenIds.length
851     );
852   }
853 
854   function unstakeNFT(uint256[] memory nftTokenIds) external {
855     address shareholder = msg.sender;
856     require(
857       shares[shareholder].nftBoostTokenIds.length > 0 &&
858         (nftTokenIds.length == 0 || nftTokenIds.length <= shares[shareholder].nftBoostTokenIds.length),
859       "you can only unstake if you have some staked"
860     );
861     require(
862       block.timestamp > shares[shareholder].nftStakedTime + minSecondsBeforeUnstakeNFT,
863       "must be staked for minimum time and at least one block if no min"
864     );
865 
866     if (shares[shareholder].nftBoostTokenIds.length > 0)
867       distributeRewardForNft(shareholder);
868     IERC721 nftContract = IERC721(nftBoosterToken);
869     if (nftTokenIds.length == 0) {
870       uint i;
871       for (i = 0; i < shares[shareholder].nftBoostTokenIds.length; i++) {
872         nftContract.transferFrom(address(this), shareholder, shares[shareholder].nftBoostTokenIds[i]);
873       }
874       delete shares[shareholder].nftBoostTokenIds;
875     } 
876     else {
877       for (uint256 i = 0; i < nftTokenIds.length; i++) {
878         uint256 j;
879         for (j = 0; j < shares[shareholder].nftBoostTokenIds.length; j++) {
880           if (nftTokenIds[i] == shares[shareholder].nftBoostTokenIds[j]) {
881             break;
882           }
883         }
884         require(j < shares[shareholder].nftBoostTokenIds.length, "Wrong id.");
885         if (j == shares[shareholder].nftBoostTokenIds.length - 1)
886           shares[shareholder].nftBoostTokenIds.pop();
887         else {
888           shares[shareholder].nftBoostTokenIds[j] = shares[shareholder]
889             .nftBoostTokenIds[shares[shareholder].nftBoostTokenIds.length - 1];
890           shares[shareholder].nftBoostTokenIds.pop();
891         }
892         nftContract.transferFrom(address(this), shareholder, nftTokenIds[i]);
893       }
894     }
895     rewards[shareholder].totalExcludedForNft = getCumulativeRewardsEth(
896       shares[shareholder].nftBoostTokenIds.length
897     );
898     totalNftStaked = totalNftStaked.sub(nftTokenIds.length);
899   }
900 
901   function _stake(address shareholder, uint256 amount) private {
902     if (shares[shareholder].amount > 0) {
903       for (uint256 i = 0; i < prTokenList.length; i++) {
904         address rwdToken = prTokenList[i];
905         distributeReward(shareholder, rwdToken);
906       }
907     }
908 
909     IERC20 shareContract = IERC20(shareholderToken);
910     uint256 stakeAmount = amount == 0
911       ? shareContract.balanceOf(shareholder)
912       : amount;
913     uint256 sharesBefore = shares[shareholder].amount;
914 
915     // for compounding we will pass in this contract override flag and assume the tokens
916     // received by the contract during the compounding process are already here, therefore
917     // whatever the amount is passed in is what we care about and leave it at that. If a normal
918     // staking though by a user, transfer tokens from the user to the contract.
919     uint256 finalBaseAdded = stakeAmount;
920 
921     uint256 shareBalanceBefore = shareContract.balanceOf(address(this));
922     shareContract.transferFrom(shareholder, address(this), stakeAmount);
923     finalBaseAdded = shareContract.balanceOf(address(this)).sub(
924       shareBalanceBefore
925     );
926 
927     uint256 finalBoostedAmount = shares[shareholder].amountBase.add(finalBaseAdded);
928 
929     totalSharesDeposited = totalSharesDeposited.add(finalBaseAdded);
930     totalSharesBoosted = totalSharesBoosted.sub(shares[shareholder].amount).add(
931         finalBoostedAmount
932       );
933     shares[shareholder].amountBase += finalBaseAdded;
934     shares[shareholder].amount = finalBoostedAmount;
935     shares[shareholder].stakedTime = block.timestamp;
936     if (sharesBefore == 0 && shares[shareholder].amount > 0) {
937       totalStakedUsers++;
938     }
939     for (uint256 i = 0; i < prTokenList.length; i++) {
940       address rwdToken = prTokenList[i];
941       rewards[shareholder].totalExcluded[rwdToken] = getCumulativeRewardsToken(
942         shares[shareholder].amount,
943         rwdToken
944       );
945     }
946     stakers.push(shareholder);
947   }
948 
949   function _unstake(
950     address account,
951     uint256 boostedAmount
952   ) private {
953     require(
954       shares[account].amount > 0 &&
955         (boostedAmount == 0 || boostedAmount <= shares[account].amount),
956       "you can only unstake if you have some staked"
957     );
958     require(
959       block.timestamp > shares[account].stakedTime + minSecondsBeforeUnstake,
960       "must be staked for minimum time and at least one block if no min"
961     );
962     
963     for (uint256 i = 0; i < prTokenList.length; i++) {
964       address rewardsToken = prTokenList[i];
965       distributeReward(account, rewardsToken);
966     }
967 
968     IERC20 shareContract = IERC20(shareholderToken);
969     uint256 boostedAmountToUnstake = boostedAmount == 0
970       ? shares[account].amount
971       : boostedAmount;
972 
973     uint256 baseAmount = boostedAmountToUnstake;
974 
975     if (boostedAmount == 0) {
976       totalStakedUsers--;
977     }
978 
979     shareContract.transfer(account, baseAmount);
980 
981     totalSharesDeposited = totalSharesDeposited.sub(baseAmount);
982     totalSharesBoosted = totalSharesBoosted.sub(boostedAmountToUnstake);
983     shares[account].amountBase -= baseAmount;
984     shares[account].amount -= boostedAmountToUnstake;
985     for (uint256 i = 0; i < prTokenList.length; i++) {
986       address tkAddr = prTokenList[i];
987       rewards[account].totalExcluded[tkAddr] = getCumulativeRewardsToken(
988         shares[account].amount,
989         tkAddr
990       );
991     }
992   }
993 
994   function unstake(uint256 boostedAmount) external {
995     _unstake(msg.sender, boostedAmount);
996   }
997 
998   function depositRewardsEth() external payable override {
999     require(msg.value > 0, "value must be greater than 0");
1000     require(
1001       totalNftStaked > 0,
1002       "must be shares deposited to be rewarded rewards"
1003     );
1004 
1005     uint256 amount = msg.value;
1006 
1007     totalRewardsEth = totalRewardsEth.add(amount);
1008     rewardsEthPerNft = rewardsEthPerNft.add(
1009       ACC_FACTOR.mul(amount).div(totalNftStaked)
1010     );
1011   }
1012 
1013   function depositRewardsToken(address tokenAddr, uint256 amount) external {
1014     require(amount > 0, "value must be greater than 0");
1015     require(
1016       totalSharesBoosted > 0,
1017       "must be shares deposited to be rewarded rewards"
1018     );
1019 
1020     // transfer token from sender to this contract
1021     IERC20 rewardsToken = IERC20(tokenAddr);
1022     rewardsToken.transferFrom(msg.sender, address(this), amount);
1023 
1024     // register project token to the list
1025     if (totalRewardsToken[tokenAddr] == 0) prTokenList.push(tokenAddr);
1026     // accumulate reward token amount
1027     totalRewardsToken[tokenAddr] = totalRewardsToken[tokenAddr].add(amount);
1028 
1029     // calculate rewarding factor
1030     rewardsPerShareToken[tokenAddr] = rewardsPerShareToken[tokenAddr].add(
1031       ACC_FACTOR.mul(amount).div(totalSharesBoosted)
1032     );
1033   }
1034 
1035   function distributeRewardForNft(address shareholder) internal {
1036     uint256 earnedRewards = getUnpaidEth(shareholder);
1037     if (earnedRewards == 0)
1038       return;
1039     rewards[shareholder].totalRealisedForNft = rewards[shareholder].totalRealisedForNft.add(earnedRewards);
1040     rewards[shareholder].totalExcludedForNft = getCumulativeRewardsEth(shares[shareholder].nftBoostTokenIds.length);
1041     uint256 balanceBefore = address(this).balance;
1042     (bool sent, ) = payable(shareholder).call{ value: earnedRewards }("");
1043     require(sent, "ETH was not successfully sent");
1044     require(
1045       address(this).balance >= balanceBefore - earnedRewards,
1046       "only take proper amount from contract"
1047     );
1048   }
1049 
1050   function distributeReward(
1051     address shareholder,
1052     address rewardsToken
1053   ) internal {
1054     // require(
1055     //   block.timestamp > rewards[shareholder].lastClaim,
1056     //   'can only claim once per block'
1057     // );
1058     if (shares[shareholder].amount == 0) {
1059       return;
1060     }
1061 
1062     uint256 amount = getUnpaidToken(shareholder, rewardsToken);
1063     if (amount == 0) return;
1064 
1065     rewards[shareholder].totalRealised[rewardsToken] = rewards[shareholder]
1066       .totalRealised[rewardsToken]
1067       .add(amount);
1068     rewards[shareholder].totalExcluded[rewardsToken] = getCumulativeRewardsToken(shares[shareholder].amount, rewardsToken);
1069     rewards[shareholder].lastClaim = block.timestamp;
1070 
1071     if (amount > 0) {
1072       totalDistributed = totalDistributed.add(amount);
1073       IERC20 rwdt = IERC20(rewardsToken);
1074       rwdt.transfer(shareholder, amount);
1075     }
1076   }
1077 
1078   function totalClaimed(address rewardsToken) external view returns(uint256) {
1079     return rewards[msg.sender].totalRealised[rewardsToken];
1080   }
1081 
1082   function totalClaimedEth() external view returns(uint256) {
1083     return rewards[msg.sender].totalRealisedForNft;
1084   }
1085 
1086   function claimRewardForKD(address rewardsToken) external {
1087     distributeReward(msg.sender, rewardsToken);
1088   }
1089 
1090   function claimRewardForNft() external {
1091     distributeRewardForNft(msg.sender);
1092   }
1093 
1094   function getUnpaidEth(address shareholder)
1095     public
1096     view
1097     returns (uint256)
1098   {
1099     if (shares[shareholder].nftBoostTokenIds.length == 0) return 0;
1100 
1101     uint256 earnedRewards = getCumulativeRewardsEth(
1102       shares[shareholder].nftBoostTokenIds.length
1103     );
1104     uint256 rewardsExcluded = rewards[shareholder].totalExcludedForNft;
1105     if (earnedRewards <= rewardsExcluded) {
1106       return 0;
1107     }
1108 
1109     return earnedRewards.sub(rewardsExcluded);
1110   }
1111 
1112   function getUnpaidToken(address shareholder, address tokenAddr)
1113     public
1114     view
1115     returns (uint256)
1116   {
1117     if (shares[shareholder].amount == 0) {
1118       return 0;
1119     }
1120 
1121     uint256 earnedRewards = getCumulativeRewardsToken(
1122       shares[shareholder].amount,
1123       tokenAddr
1124     );
1125     uint256 rewardsExcluded = rewards[shareholder].totalExcluded[tokenAddr];
1126     if (earnedRewards <= rewardsExcluded) {
1127       return 0;
1128     }
1129 
1130     return earnedRewards.sub(rewardsExcluded);
1131   }
1132 
1133   function getCumulativeRewardsToken(uint256 share, address tokenAddr)
1134     internal
1135     view
1136     returns (uint256)
1137   {
1138     return share.mul(rewardsPerShareToken[tokenAddr]).div(ACC_FACTOR);
1139   }
1140 
1141   function getCumulativeRewardsEth(uint256 share)
1142     internal
1143     view
1144     returns (uint256)
1145   {
1146     return share.mul(rewardsEthPerNft).div(ACC_FACTOR);
1147   }
1148 
1149   function getBaseShares(address user) external view returns (uint256) {
1150     return shares[user].amountBase;
1151   }
1152 
1153   function getShares(address user) external view override returns (uint256) {
1154     return shares[user].amount;
1155   }
1156 
1157   function getBoostNfts(address user)
1158     public
1159     view
1160     override
1161     returns (uint256[] memory)
1162   {
1163     return shares[user].nftBoostTokenIds;
1164   }
1165 
1166   function setShareholderToken(address _token) external onlyOwner {
1167     shareholderToken = _token;
1168   }
1169 
1170   function setMinSecondsBeforeUnstake(uint256 _seconds) external onlyOwner {
1171     minSecondsBeforeUnstake = _seconds;
1172   }
1173 
1174   function setMinSecondsBeforeUnstakeNft(uint256 _seconds) external onlyOwner {
1175     minSecondsBeforeUnstakeNFT = _seconds;
1176   }
1177 
1178   function setNftBoosterToken(address _nft) external onlyOwner {
1179     nftBoosterToken = _nft;
1180   }
1181 
1182   function setNftBoostPercentage(uint256 _percentage) external onlyOwner {
1183     nftBoostPercentage = _percentage;
1184   }
1185 
1186   function setMaxNftsToBoost(uint256 _amount) external onlyOwner {
1187     maxNftsCanBoost = _amount;
1188   }
1189 
1190   function unstakeAll() public onlyOwner {
1191     if (stakers.length == 0) return;
1192     for (uint256 i = 0; i < stakers.length; i++) {
1193       if (shares[stakers[i]].amount <= 0) continue;
1194       _unstake(stakers[i], 0);
1195     }
1196     delete stakers;
1197   }
1198 
1199   function withdrawAll() external onlyOwner {
1200     unstakeAll();
1201     IERC20 shareContract = IERC20(shareholderToken);
1202     uint256 amount = shareContract.balanceOf(address(this));
1203     shareContract.transfer(owner(), amount);
1204     amount = address(this).balance;
1205     payable(owner()).call{ value: amount, gas: 30000 }("");
1206   }
1207 
1208   receive() external payable {}
1209 }