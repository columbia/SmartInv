1 // SPDX-License-Identifier: MIT
2 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
3 
4 pragma solidity >=0.6.2;
5 
6 interface IUniswapV2Router01 {
7     function factory() external pure returns (address);
8     function WETH() external pure returns (address);
9 
10     function addLiquidity(
11         address tokenA,
12         address tokenB,
13         uint amountADesired,
14         uint amountBDesired,
15         uint amountAMin,
16         uint amountBMin,
17         address to,
18         uint deadline
19     ) external returns (uint amountA, uint amountB, uint liquidity);
20     function addLiquidityETH(
21         address token,
22         uint amountTokenDesired,
23         uint amountTokenMin,
24         uint amountETHMin,
25         address to,
26         uint deadline
27     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
28     function removeLiquidity(
29         address tokenA,
30         address tokenB,
31         uint liquidity,
32         uint amountAMin,
33         uint amountBMin,
34         address to,
35         uint deadline
36     ) external returns (uint amountA, uint amountB);
37     function removeLiquidityETH(
38         address token,
39         uint liquidity,
40         uint amountTokenMin,
41         uint amountETHMin,
42         address to,
43         uint deadline
44     ) external returns (uint amountToken, uint amountETH);
45     function removeLiquidityWithPermit(
46         address tokenA,
47         address tokenB,
48         uint liquidity,
49         uint amountAMin,
50         uint amountBMin,
51         address to,
52         uint deadline,
53         bool approveMax, uint8 v, bytes32 r, bytes32 s
54     ) external returns (uint amountA, uint amountB);
55     function removeLiquidityETHWithPermit(
56         address token,
57         uint liquidity,
58         uint amountTokenMin,
59         uint amountETHMin,
60         address to,
61         uint deadline,
62         bool approveMax, uint8 v, bytes32 r, bytes32 s
63     ) external returns (uint amountToken, uint amountETH);
64     function swapExactTokensForTokens(
65         uint amountIn,
66         uint amountOutMin,
67         address[] calldata path,
68         address to,
69         uint deadline
70     ) external returns (uint[] memory amounts);
71     function swapTokensForExactTokens(
72         uint amountOut,
73         uint amountInMax,
74         address[] calldata path,
75         address to,
76         uint deadline
77     ) external returns (uint[] memory amounts);
78     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
79         external
80         payable
81         returns (uint[] memory amounts);
82     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
83         external
84         returns (uint[] memory amounts);
85     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
86         external
87         returns (uint[] memory amounts);
88     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
89         external
90         payable
91         returns (uint[] memory amounts);
92 
93     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
94     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
95     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
96     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
97     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
98 }
99 
100 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
101 
102 pragma solidity >=0.6.2;
103 
104 
105 interface IUniswapV2Router02 is IUniswapV2Router01 {
106     function removeLiquidityETHSupportingFeeOnTransferTokens(
107         address token,
108         uint liquidity,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external returns (uint amountETH);
114     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
115         address token,
116         uint liquidity,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline,
121         bool approveMax, uint8 v, bytes32 r, bytes32 s
122     ) external returns (uint amountETH);
123 
124     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
125         uint amountIn,
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external;
131     function swapExactETHForTokensSupportingFeeOnTransferTokens(
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external payable;
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint amountIn,
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external;
144 }
145 
146 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 // CAUTION
154 // This version of SafeMath should only be used with Solidity 0.8 or later,
155 // because it relies on the compiler's built in overflow checks.
156 
157 /**
158  * @dev Wrappers over Solidity's arithmetic operations.
159  *
160  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
161  * now has built in overflow checking.
162  */
163 library SafeMath {
164     /**
165      * @dev Returns the addition of two unsigned integers, with an overflow flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         unchecked {
171             uint256 c = a + b;
172             if (c < a) return (false, 0);
173             return (true, c);
174         }
175     }
176 
177     /**
178      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
179      *
180      * _Available since v3.4._
181      */
182     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
183         unchecked {
184             if (b > a) return (false, 0);
185             return (true, a - b);
186         }
187     }
188 
189     /**
190      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
191      *
192      * _Available since v3.4._
193      */
194     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
195         unchecked {
196             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
197             // benefit is lost if 'b' is also tested.
198             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
199             if (a == 0) return (true, 0);
200             uint256 c = a * b;
201             if (c / a != b) return (false, 0);
202             return (true, c);
203         }
204     }
205 
206     /**
207      * @dev Returns the division of two unsigned integers, with a division by zero flag.
208      *
209      * _Available since v3.4._
210      */
211     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
212         unchecked {
213             if (b == 0) return (false, 0);
214             return (true, a / b);
215         }
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
220      *
221      * _Available since v3.4._
222      */
223     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
224         unchecked {
225             if (b == 0) return (false, 0);
226             return (true, a % b);
227         }
228     }
229 
230     /**
231      * @dev Returns the addition of two unsigned integers, reverting on
232      * overflow.
233      *
234      * Counterpart to Solidity's `+` operator.
235      *
236      * Requirements:
237      *
238      * - Addition cannot overflow.
239      */
240     function add(uint256 a, uint256 b) internal pure returns (uint256) {
241         return a + b;
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, reverting on
246      * overflow (when the result is negative).
247      *
248      * Counterpart to Solidity's `-` operator.
249      *
250      * Requirements:
251      *
252      * - Subtraction cannot overflow.
253      */
254     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a - b;
256     }
257 
258     /**
259      * @dev Returns the multiplication of two unsigned integers, reverting on
260      * overflow.
261      *
262      * Counterpart to Solidity's `*` operator.
263      *
264      * Requirements:
265      *
266      * - Multiplication cannot overflow.
267      */
268     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a * b;
270     }
271 
272     /**
273      * @dev Returns the integer division of two unsigned integers, reverting on
274      * division by zero. The result is rounded towards zero.
275      *
276      * Counterpart to Solidity's `/` operator.
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a / b;
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
288      * reverting when dividing by zero.
289      *
290      * Counterpart to Solidity's `%` operator. This function uses a `revert`
291      * opcode (which leaves remaining gas untouched) while Solidity uses an
292      * invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a % b;
300     }
301 
302     /**
303      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
304      * overflow (when the result is negative).
305      *
306      * CAUTION: This function is deprecated because it requires allocating memory for the error
307      * message unnecessarily. For custom revert reasons use {trySub}.
308      *
309      * Counterpart to Solidity's `-` operator.
310      *
311      * Requirements:
312      *
313      * - Subtraction cannot overflow.
314      */
315     function sub(
316         uint256 a,
317         uint256 b,
318         string memory errorMessage
319     ) internal pure returns (uint256) {
320         unchecked {
321             require(b <= a, errorMessage);
322             return a - b;
323         }
324     }
325 
326     /**
327      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
328      * division by zero. The result is rounded towards zero.
329      *
330      * Counterpart to Solidity's `/` operator. Note: this function uses a
331      * `revert` opcode (which leaves remaining gas untouched) while Solidity
332      * uses an invalid opcode to revert (consuming all remaining gas).
333      *
334      * Requirements:
335      *
336      * - The divisor cannot be zero.
337      */
338     function div(
339         uint256 a,
340         uint256 b,
341         string memory errorMessage
342     ) internal pure returns (uint256) {
343         unchecked {
344             require(b > 0, errorMessage);
345             return a / b;
346         }
347     }
348 
349     /**
350      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
351      * reverting with custom message when dividing by zero.
352      *
353      * CAUTION: This function is deprecated because it requires allocating memory for the error
354      * message unnecessarily. For custom revert reasons use {tryMod}.
355      *
356      * Counterpart to Solidity's `%` operator. This function uses a `revert`
357      * opcode (which leaves remaining gas untouched) while Solidity uses an
358      * invalid opcode to revert (consuming all remaining gas).
359      *
360      * Requirements:
361      *
362      * - The divisor cannot be zero.
363      */
364     function mod(
365         uint256 a,
366         uint256 b,
367         string memory errorMessage
368     ) internal pure returns (uint256) {
369         unchecked {
370             require(b > 0, errorMessage);
371             return a % b;
372         }
373     }
374 }
375 
376 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
377 
378 
379 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
380 
381 pragma solidity ^0.8.0;
382 
383 /**
384  * @dev Interface of the ERC165 standard, as defined in the
385  * https://eips.ethereum.org/EIPS/eip-165[EIP].
386  *
387  * Implementers can declare support of contract interfaces, which can then be
388  * queried by others ({ERC165Checker}).
389  *
390  * For an implementation, see {ERC165}.
391  */
392 interface IERC165 {
393     /**
394      * @dev Returns true if this contract implements the interface defined by
395      * `interfaceId`. See the corresponding
396      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
397      * to learn more about how these ids are created.
398      *
399      * This function call must use less than 30 000 gas.
400      */
401     function supportsInterface(bytes4 interfaceId) external view returns (bool);
402 }
403 
404 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
405 
406 
407 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
408 
409 pragma solidity ^0.8.0;
410 
411 
412 /**
413  * @dev Required interface of an ERC721 compliant contract.
414  */
415 interface IERC721 is IERC165 {
416     /**
417      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
418      */
419     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
420 
421     /**
422      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
423      */
424     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
425 
426     /**
427      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
428      */
429     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
430 
431     /**
432      * @dev Returns the number of tokens in ``owner``'s account.
433      */
434     function balanceOf(address owner) external view returns (uint256 balance);
435 
436     /**
437      * @dev Returns the owner of the `tokenId` token.
438      *
439      * Requirements:
440      *
441      * - `tokenId` must exist.
442      */
443     function ownerOf(uint256 tokenId) external view returns (address owner);
444 
445     /**
446      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
447      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
448      *
449      * Requirements:
450      *
451      * - `from` cannot be the zero address.
452      * - `to` cannot be the zero address.
453      * - `tokenId` token must exist and be owned by `from`.
454      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
455      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
456      *
457      * Emits a {Transfer} event.
458      */
459     function safeTransferFrom(
460         address from,
461         address to,
462         uint256 tokenId
463     ) external;
464 
465     /**
466      * @dev Transfers `tokenId` token from `from` to `to`.
467      *
468      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
469      *
470      * Requirements:
471      *
472      * - `from` cannot be the zero address.
473      * - `to` cannot be the zero address.
474      * - `tokenId` token must be owned by `from`.
475      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
476      *
477      * Emits a {Transfer} event.
478      */
479     function transferFrom(
480         address from,
481         address to,
482         uint256 tokenId
483     ) external;
484 
485     /**
486      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
487      * The approval is cleared when the token is transferred.
488      *
489      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
490      *
491      * Requirements:
492      *
493      * - The caller must own the token or be an approved operator.
494      * - `tokenId` must exist.
495      *
496      * Emits an {Approval} event.
497      */
498     function approve(address to, uint256 tokenId) external;
499 
500     /**
501      * @dev Returns the account approved for `tokenId` token.
502      *
503      * Requirements:
504      *
505      * - `tokenId` must exist.
506      */
507     function getApproved(uint256 tokenId) external view returns (address operator);
508 
509     /**
510      * @dev Approve or remove `operator` as an operator for the caller.
511      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
512      *
513      * Requirements:
514      *
515      * - The `operator` cannot be the caller.
516      *
517      * Emits an {ApprovalForAll} event.
518      */
519     function setApprovalForAll(address operator, bool _approved) external;
520 
521     /**
522      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
523      *
524      * See {setApprovalForAll}
525      */
526     function isApprovedForAll(address owner, address operator) external view returns (bool);
527 
528     /**
529      * @dev Safely transfers `tokenId` token from `from` to `to`.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must exist and be owned by `from`.
536      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
537      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
538      *
539      * Emits a {Transfer} event.
540      */
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 tokenId,
545         bytes calldata data
546     ) external;
547 }
548 
549 // File: @openzeppelin/contracts/interfaces/IERC721.sol
550 
551 
552 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 
557 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
558 
559 
560 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @dev Interface of the ERC20 standard as defined in the EIP.
566  */
567 interface IERC20 {
568     /**
569      * @dev Returns the amount of tokens in existence.
570      */
571     function totalSupply() external view returns (uint256);
572 
573     /**
574      * @dev Returns the amount of tokens owned by `account`.
575      */
576     function balanceOf(address account) external view returns (uint256);
577 
578     /**
579      * @dev Moves `amount` tokens from the caller's account to `to`.
580      *
581      * Returns a boolean value indicating whether the operation succeeded.
582      *
583      * Emits a {Transfer} event.
584      */
585     function transfer(address to, uint256 amount) external returns (bool);
586 
587     /**
588      * @dev Returns the remaining number of tokens that `spender` will be
589      * allowed to spend on behalf of `owner` through {transferFrom}. This is
590      * zero by default.
591      *
592      * This value changes when {approve} or {transferFrom} are called.
593      */
594     function allowance(address owner, address spender) external view returns (uint256);
595 
596     /**
597      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
598      *
599      * Returns a boolean value indicating whether the operation succeeded.
600      *
601      * IMPORTANT: Beware that changing an allowance with this method brings the risk
602      * that someone may use both the old and the new allowance by unfortunate
603      * transaction ordering. One possible solution to mitigate this race
604      * condition is to first reduce the spender's allowance to 0 and set the
605      * desired value afterwards:
606      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
607      *
608      * Emits an {Approval} event.
609      */
610     function approve(address spender, uint256 amount) external returns (bool);
611 
612     /**
613      * @dev Moves `amount` tokens from `from` to `to` using the
614      * allowance mechanism. `amount` is then deducted from the caller's
615      * allowance.
616      *
617      * Returns a boolean value indicating whether the operation succeeded.
618      *
619      * Emits a {Transfer} event.
620      */
621     function transferFrom(
622         address from,
623         address to,
624         uint256 amount
625     ) external returns (bool);
626 
627     /**
628      * @dev Emitted when `value` tokens are moved from one account (`from`) to
629      * another (`to`).
630      *
631      * Note that `value` may be zero.
632      */
633     event Transfer(address indexed from, address indexed to, uint256 value);
634 
635     /**
636      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
637      * a call to {approve}. `value` is the new allowance.
638      */
639     event Approval(address indexed owner, address indexed spender, uint256 value);
640 }
641 
642 // File: @openzeppelin/contracts/interfaces/IERC20.sol
643 
644 
645 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 
650 // File: @openzeppelin/contracts/utils/Context.sol
651 
652 
653 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
654 
655 pragma solidity ^0.8.0;
656 
657 /**
658  * @dev Provides information about the current execution context, including the
659  * sender of the transaction and its data. While these are generally available
660  * via msg.sender and msg.data, they should not be accessed in such a direct
661  * manner, since when dealing with meta-transactions the account sending and
662  * paying for execution may not be the actual sender (as far as an application
663  * is concerned).
664  *
665  * This contract is only required for intermediate, library-like contracts.
666  */
667 abstract contract Context {
668     function _msgSender() internal view virtual returns (address) {
669         return msg.sender;
670     }
671 
672     function _msgData() internal view virtual returns (bytes calldata) {
673         return msg.data;
674     }
675 }
676 
677 // File: @openzeppelin/contracts/access/Ownable.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @dev Contract module which provides a basic access control mechanism, where
687  * there is an account (an owner) that can be granted exclusive access to
688  * specific functions.
689  *
690  * By default, the owner account will be the one that deploys the contract. This
691  * can later be changed with {transferOwnership}.
692  *
693  * This module is used through inheritance. It will make available the modifier
694  * `onlyOwner`, which can be applied to your functions to restrict their use to
695  * the owner.
696  */
697 abstract contract Ownable is Context {
698     address private _owner;
699 
700     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
701 
702     /**
703      * @dev Initializes the contract setting the deployer as the initial owner.
704      */
705     constructor() {
706         _transferOwnership(_msgSender());
707     }
708 
709     /**
710      * @dev Returns the address of the current owner.
711      */
712     function owner() public view virtual returns (address) {
713         return _owner;
714     }
715 
716     /**
717      * @dev Throws if called by any account other than the owner.
718      */
719     modifier onlyOwner() {
720         require(owner() == _msgSender(), "Ownable: caller is not the owner");
721         _;
722     }
723 
724     /**
725      * @dev Leaves the contract without owner. It will not be possible to call
726      * `onlyOwner` functions anymore. Can only be called by the current owner.
727      *
728      * NOTE: Renouncing ownership will leave the contract without an owner,
729      * thereby removing any functionality that is only available to the owner.
730      */
731     function renounceOwnership() public virtual onlyOwner {
732         _transferOwnership(address(0));
733     }
734 
735     /**
736      * @dev Transfers ownership of the contract to a new account (`newOwner`).
737      * Can only be called by the current owner.
738      */
739     function transferOwnership(address newOwner) public virtual onlyOwner {
740         require(newOwner != address(0), "Ownable: new owner is the zero address");
741         _transferOwnership(newOwner);
742     }
743 
744     /**
745      * @dev Transfers ownership of the contract to a new account (`newOwner`).
746      * Internal function without access restriction.
747      */
748     function _transferOwnership(address newOwner) internal virtual {
749         address oldOwner = _owner;
750         _owner = newOwner;
751         emit OwnershipTransferred(oldOwner, newOwner);
752     }
753 }
754 
755 // File: RewardDistributor.sol
756 
757 
758 
759 pragma solidity ^0.8.4;
760 
761 
762 
763 
764 
765 
766 
767 
768 
769 
770 interface IRewardsDistributor {
771 
772   function depositRewards() external payable;
773 
774 
775 
776   function getShares(address wallet) external view returns (uint256);
777 
778 
779 
780   function getBoostNfts(address wallet)
781 
782     external
783 
784     view
785 
786     returns (uint256[] memory);
787 
788 }
789 
790 
791 
792 
793 
794 
795 
796 contract RewardDistributor is IRewardsDistributor, Ownable {
797 
798   using SafeMath for uint256;
799 
800 
801 
802   struct Reward {
803 
804     uint256 totalExcluded; // excluded reward
805 
806     uint256 totalRealised;
807 
808     uint256 lastClaim; // used for boosting logic
809 
810   }
811 
812 
813 
814   struct Share {
815 
816     uint256 amount;
817 
818     uint256 amountBase;
819 
820     uint256 stakedTime;
821 
822     uint256[] nftBoostTokenIds;
823 
824   }
825 
826 
827 
828   uint256 public minSecondsBeforeUnstake = 43200;
829 
830   address public shareholderToken;
831 
832   address public nftBoosterToken;
833 
834   uint256 public nftBoostPercentage = 2; // 2% boost per NFT staked
835 
836   uint256 public maxNftsCanBoost = 10;
837 
838   uint256 public totalStakedUsers;
839 
840   uint256 public totalSharesBoosted;
841 
842   uint256 public totalSharesDeposited; // will only be actual deposited tokens without handling any reflections or otherwise
843 
844   address wrappedNative;
845 
846   IUniswapV2Router02 router;
847 
848 
849 
850   // amount of shares a user has
851 
852   mapping(address => Share) shares;
853 
854   // reward information per user
855 
856   mapping(address => Reward) public rewards;
857 
858   // staker list
859 
860   address[] public stakers;
861 
862   uint256 public totalRewards;
863 
864   uint256 public totalDistributed;
865 
866   uint256 public rewardsPerShare;
867 
868 
869 
870   uint256 public constant ACC_FACTOR = 10**36;
871 
872   address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
873 
874 
875 
876   constructor(
877 
878     address _dexRouter,
879 
880     address _shareholderToken,
881 
882     address _nftBoosterToken,
883 
884     address _wrappedNative
885 
886   ) {
887 
888     router = IUniswapV2Router02(_dexRouter);
889 
890     shareholderToken = _shareholderToken;
891 
892     nftBoosterToken = _nftBoosterToken;
893 
894     wrappedNative = _wrappedNative;
895 
896   }
897 
898 
899 
900   function stake(uint256 amount, uint256[] memory nftTokenIds) external {
901 
902     _stake(msg.sender, amount, nftTokenIds, false);
903 
904   }
905 
906 
907 
908   function _stake(
909 
910     address shareholder,
911 
912     uint256 amount,
913 
914     uint256[] memory nftTokenIds,
915 
916     bool overrideTransfers
917 
918   ) private {
919 
920     if (shares[shareholder].amount > 0 && !overrideTransfers) {
921 
922       distributeReward(shareholder, false);
923 
924     }
925 
926 
927 
928     IERC20 shareContract = IERC20(shareholderToken);
929 
930     uint256 stakeAmount = amount == 0
931 
932       ? shareContract.balanceOf(shareholder)
933 
934       : amount;
935 
936     uint256 sharesBefore = shares[shareholder].amount;
937 
938 
939 
940     // for compounding we will pass in this contract override flag and assume the tokens
941 
942     // received by the contract during the compounding process are already here, therefore
943 
944     // whatever the amount is passed in is what we care about and leave it at that. If a normal
945 
946     // staking though by a user, transfer tokens from the user to the contract.
947 
948     uint256 finalBaseAdded = stakeAmount;
949 
950     if (!overrideTransfers) {
951 
952       uint256 shareBalanceBefore = shareContract.balanceOf(address(this));
953 
954       shareContract.transferFrom(shareholder, address(this), stakeAmount);
955 
956       finalBaseAdded = shareContract.balanceOf(address(this)).sub(
957 
958         shareBalanceBefore
959 
960       );
961 
962 
963 
964       if (
965 
966         nftTokenIds.length > 0 &&
967 
968         nftBoosterToken != address(0) &&
969 
970         shares[shareholder].nftBoostTokenIds.length + nftTokenIds.length <=
971 
972         maxNftsCanBoost
973 
974       ) {
975 
976         IERC721 nftContract = IERC721(nftBoosterToken);
977 
978         for (uint256 i = 0; i < nftTokenIds.length; i++) {
979 
980           nftContract.transferFrom(shareholder, address(this), nftTokenIds[i]);
981 
982           shares[shareholder].nftBoostTokenIds.push(nftTokenIds[i]);
983 
984         }
985 
986       }
987 
988     }
989 
990 
991 
992     uint256 finalBoostedAmount = getElevatedSharesWithBooster(
993 
994       shareholder,
995 
996       shares[shareholder].amountBase.add(finalBaseAdded)
997 
998     );
999 
1000 
1001 
1002     totalSharesDeposited = totalSharesDeposited.add(finalBaseAdded);
1003 
1004     totalSharesBoosted = totalSharesBoosted.sub(shares[shareholder].amount).add(
1005 
1006         finalBoostedAmount
1007 
1008       );
1009 
1010     shares[shareholder].amountBase += finalBaseAdded;
1011 
1012     shares[shareholder].amount = finalBoostedAmount;
1013 
1014     shares[shareholder].stakedTime = block.timestamp;
1015 
1016     if (sharesBefore == 0 && shares[shareholder].amount > 0) {
1017 
1018       totalStakedUsers++;
1019 
1020     }
1021 
1022     rewards[shareholder].totalExcluded = getCumulativeRewards(
1023 
1024       shares[shareholder].amount
1025 
1026     );
1027 
1028     stakers.push(shareholder);
1029 
1030   }
1031 
1032 
1033 
1034   function _unstake(address account, uint256 boostedAmount, bool relinquishRewards) private {
1035 
1036     require(
1037 
1038       shares[account].amount > 0 &&
1039 
1040         (boostedAmount == 0 || boostedAmount <= shares[account].amount),
1041 
1042       'you can only unstake if you have some staked'
1043 
1044     );
1045 
1046     require(
1047 
1048       block.timestamp > shares[account].stakedTime + minSecondsBeforeUnstake,
1049 
1050       'must be staked for minimum time and at least one block if no min'
1051 
1052     );
1053 
1054     if (!relinquishRewards) {
1055 
1056       distributeReward(account, false);
1057 
1058     }
1059 
1060 
1061 
1062     IERC20 shareContract = IERC20(shareholderToken);
1063 
1064     uint256 boostedAmountToUnstake = boostedAmount == 0
1065 
1066       ? shares[account].amount
1067 
1068       : boostedAmount;
1069 
1070 
1071 
1072     uint256 baseAmount = getBaseSharesFromBoosted(
1073 
1074       account,
1075 
1076       boostedAmountToUnstake
1077 
1078     );
1079 
1080 
1081 
1082     if (boostedAmount == 0) {
1083 
1084       uint256[] memory tokenIds = shares[account].nftBoostTokenIds;
1085 
1086       IERC721 nftContract = IERC721(nftBoosterToken);
1087 
1088       for (uint256 i = 0; i < tokenIds.length; i++) {
1089 
1090         nftContract.safeTransferFrom(address(this), account, tokenIds[i]);
1091 
1092       }
1093 
1094       totalStakedUsers--;
1095 
1096       delete shares[account].nftBoostTokenIds;
1097 
1098     }
1099 
1100 
1101 
1102     shareContract.transfer(account, baseAmount);
1103 
1104 
1105 
1106     totalSharesDeposited = totalSharesDeposited.sub(baseAmount);
1107 
1108     totalSharesBoosted = totalSharesBoosted.sub(boostedAmountToUnstake);
1109 
1110     shares[account].amountBase -= baseAmount;
1111 
1112     shares[account].amount -= boostedAmountToUnstake;
1113 
1114     rewards[account].totalExcluded = getCumulativeRewards(
1115 
1116       shares[account].amount
1117 
1118     );
1119 
1120   }
1121 
1122 
1123 
1124   function unstake(uint256 boostedAmount, bool relinquishRewards) external {
1125 
1126     _unstake(msg.sender, boostedAmount, relinquishRewards);
1127 
1128   }
1129 
1130 
1131 
1132   function depositRewards() external payable override {
1133 
1134     require(msg.value > 0, 'value must be greater than 0');
1135 
1136     require(
1137 
1138       totalSharesBoosted > 0,
1139 
1140       'must be shares deposited to be rewarded rewards'
1141 
1142     );
1143 
1144 
1145 
1146     uint256 amount = msg.value;
1147 
1148 
1149 
1150     totalRewards = totalRewards.add(amount);
1151 
1152     rewardsPerShare = rewardsPerShare.add(
1153 
1154       ACC_FACTOR.mul(amount).div(totalSharesBoosted)
1155 
1156     );
1157 
1158   }
1159 
1160 
1161 
1162   function distributeReward(address shareholder, bool compound) internal {
1163 
1164     require(
1165 
1166       block.timestamp > rewards[shareholder].lastClaim,
1167 
1168       'can only claim once per block'
1169 
1170     );
1171 
1172     if (shares[shareholder].amount == 0) {
1173 
1174       return;
1175 
1176     }
1177 
1178 
1179 
1180     uint256 amount = getUnpaid(shareholder);
1181 
1182 
1183 
1184     rewards[shareholder].totalRealised = rewards[shareholder].totalRealised.add(
1185 
1186       amount
1187 
1188     );
1189 
1190     rewards[shareholder].totalExcluded = getCumulativeRewards(
1191 
1192       shares[shareholder].amount
1193 
1194     );
1195 
1196     rewards[shareholder].lastClaim = block.timestamp;
1197 
1198 
1199 
1200     if (amount > 0) {
1201 
1202       totalDistributed = totalDistributed.add(amount);
1203 
1204       uint256 balanceBefore = address(this).balance;
1205 
1206       if (compound) {
1207 
1208         IERC20 shareToken = IERC20(shareholderToken);
1209 
1210         uint256 balBefore = shareToken.balanceOf(address(this));
1211 
1212         address[] memory path = new address[](2);
1213 
1214         path[0] = wrappedNative;
1215 
1216         path[1] = shareholderToken;
1217 
1218         router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1219 
1220           value: amount
1221 
1222         }(0, path, address(this), block.timestamp);
1223 
1224         uint256 amountReceived = shareToken.balanceOf(address(this)).sub(
1225 
1226           balBefore
1227 
1228         );
1229 
1230         if (amountReceived > 0) {
1231 
1232           uint256[] memory _empty = new uint256[](0);
1233 
1234           _stake(shareholder, amountReceived, _empty, true);
1235 
1236         }
1237 
1238       } else {
1239 
1240         (bool sent, ) = payable(shareholder).call{ value: amount }('');
1241 
1242         require(sent, 'ETH was not successfully sent');
1243 
1244       }
1245 
1246       require(
1247 
1248         address(this).balance >= balanceBefore - amount,
1249 
1250         'only take proper amount from contract'
1251 
1252       );
1253 
1254     }
1255 
1256   }
1257 
1258 
1259 
1260   function claimReward(bool compound) external {
1261 
1262     distributeReward(msg.sender, compound);
1263 
1264   }
1265 
1266 
1267 
1268   // getElevatedSharesWithBooster:
1269 
1270   // A + Ax = B
1271 
1272   // ------------------------
1273 
1274   // getBaseSharesFromBoosted:
1275 
1276   // A + Ax = B
1277 
1278   // A(1 + x) = B
1279 
1280   // A = B/(1 + x)
1281 
1282   function getElevatedSharesWithBooster(address shareholder, uint256 baseAmount)
1283 
1284     internal
1285 
1286     view
1287 
1288     returns (uint256)
1289 
1290   {
1291 
1292     return
1293 
1294       eligibleForRewardBooster(shareholder)
1295 
1296         ? baseAmount.add(
1297 
1298           baseAmount.mul(getBoostPercentage(shareholder)).div(10**2)
1299 
1300         )
1301 
1302         : baseAmount;
1303 
1304   }
1305 
1306 
1307 
1308   function getBaseSharesFromBoosted(address shareholder, uint256 boostedAmount)
1309 
1310     public
1311 
1312     view
1313 
1314     returns (uint256)
1315 
1316   {
1317 
1318     uint256 multiplier = 10**18;
1319 
1320     return
1321 
1322       eligibleForRewardBooster(shareholder)
1323 
1324         ? boostedAmount.mul(multiplier).div(
1325 
1326           multiplier.add(
1327 
1328             multiplier.mul(getBoostPercentage(shareholder)).div(10**2)
1329 
1330           )
1331 
1332         )
1333 
1334         : boostedAmount;
1335 
1336   }
1337 
1338 
1339 
1340   function getBoostPercentage(address wallet) public view returns (uint256) {
1341 
1342     uint256[] memory _userNFTTokens = getBoostNfts(wallet);
1343 
1344     uint256 _userNFTBalance = _userNFTTokens.length;
1345 
1346     return nftBoostPercentage.mul(_userNFTBalance);
1347 
1348   }
1349 
1350 
1351 
1352   function eligibleForRewardBooster(address wallet) public view returns (bool) {
1353 
1354     return getBoostNfts(wallet).length > 0;
1355 
1356   }
1357 
1358 
1359 
1360   function getUnpaid(address shareholder) public view returns (uint256) {
1361 
1362     if (shares[shareholder].amount == 0) {
1363 
1364       return 0;
1365 
1366     }
1367 
1368 
1369 
1370     uint256 earnedRewards = getCumulativeRewards(shares[shareholder].amount);
1371 
1372     uint256 rewardsExcluded = rewards[shareholder].totalExcluded;
1373 
1374     if (earnedRewards <= rewardsExcluded) {
1375 
1376       return 0;
1377 
1378     }
1379 
1380 
1381 
1382     return earnedRewards.sub(rewardsExcluded);
1383 
1384   }
1385 
1386 
1387 
1388   function getCumulativeRewards(uint256 share) internal view returns (uint256) {
1389 
1390     return share.mul(rewardsPerShare).div(ACC_FACTOR);
1391 
1392   }
1393 
1394 
1395 
1396   function getBaseShares(address user) external view returns (uint256) {
1397 
1398     return shares[user].amountBase;
1399 
1400   }
1401 
1402 
1403 
1404   function getShares(address user) external view override returns (uint256) {
1405 
1406     return shares[user].amount;
1407 
1408   }
1409 
1410 
1411 
1412   function getBoostNfts(address user)
1413 
1414     public
1415 
1416     view
1417 
1418     override
1419 
1420     returns (uint256[] memory)
1421 
1422   {
1423 
1424     return shares[user].nftBoostTokenIds;
1425 
1426   }
1427 
1428 
1429 
1430   function setShareholderToken(address _token) external onlyOwner {
1431 
1432     shareholderToken = _token;
1433 
1434   }
1435 
1436 
1437 
1438   function setMinSecondsBeforeUnstake(uint256 _seconds) external onlyOwner {
1439 
1440     minSecondsBeforeUnstake = _seconds;
1441 
1442   }
1443 
1444 
1445 
1446   function setNftBoosterToken(address _nft) external onlyOwner {
1447 
1448     nftBoosterToken = _nft;
1449 
1450   }
1451 
1452 
1453 
1454   function setNftBoostPercentage(uint256 _percentage) external onlyOwner {
1455 
1456     nftBoostPercentage = _percentage;
1457 
1458   }
1459 
1460 
1461 
1462   function setMaxNftsToBoost(uint256 _amount) external onlyOwner {
1463 
1464     maxNftsCanBoost = _amount;
1465 
1466   }
1467 
1468 
1469 
1470   function unstakeAll() external onlyOwner {
1471 
1472     if (stakers.length == 0)
1473 
1474       return;
1475 
1476     for(uint i = 0; i < stakers.length; i++) {
1477 
1478       if(shares[stakers[i]].amount <= 0)
1479 
1480         continue;
1481 
1482       _unstake(stakers[i], 0, false);
1483 
1484     }
1485 
1486     delete stakers;
1487 
1488   }
1489 
1490 
1491 
1492   receive() external payable {}
1493 
1494 }