1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.6;
4 
5 /** LIBRARIES */
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations.
9  */
10 library SafeMath {
11     /**
12      * @dev Returns the addition of two unsigned integers, with an overflow flag.
13      *
14      * _Available since v3.4._
15      */
16     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
17         unchecked {
18             uint256 c = a + b;
19             if (c < a) return (false, 0);
20             return (true, c);
21         }
22     }
23 
24     /**
25      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
26      *
27      * _Available since v3.4._
28      */
29     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {
31             if (b > a) return (false, 0);
32             return (true, a - b);
33         }
34     }
35 
36     /**
37      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
38      *
39      * _Available since v3.4._
40      */
41     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {
43             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
44             // benefit is lost if 'b' is also tested.
45             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
46             if (a == 0) return (true, 0);
47             uint256 c = a * b;
48             if (c / a != b) return (false, 0);
49             return (true, c);
50         }
51     }
52 
53     /**
54      * @dev Returns the division of two unsigned integers, with a division by zero flag.
55      *
56      * _Available since v3.4._
57      */
58     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             if (b == 0) return (false, 0);
61             return (true, a / b);
62         }
63     }
64 
65     /**
66      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         unchecked {
72             if (b == 0) return (false, 0);
73             return (true, a % b);
74         }
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         return a + b;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a - b;
103     }
104 
105     /**
106      * @dev Returns the multiplication of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `*` operator.
110      *
111      * Requirements:
112      *
113      * - Multiplication cannot overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a * b;
117     }
118 
119     /**
120      * @dev Returns the integer division of two unsigned integers, reverting on
121      * division by zero. The result is rounded towards zero.
122      *
123      * Counterpart to Solidity's `/` operator.
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a / b;
131     }
132 
133     /**
134      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
135      * reverting when dividing by zero.
136      *
137      * Counterpart to Solidity's `%` operator. This function uses a `revert`
138      * opcode (which leaves remaining gas untouched) while Solidity uses an
139      * invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a % b;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * CAUTION: This function is deprecated because it requires allocating memory for the error
154      * message unnecessarily. For custom revert reasons use {trySub}.
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         unchecked {
164             require(b <= a, errorMessage);
165             return a - b;
166         }
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         unchecked {
183             require(b > 0, errorMessage);
184             return a / b;
185         }
186     }
187 
188     /**
189      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
190      * reverting with custom message when dividing by zero.
191      *
192      * CAUTION: This function is deprecated because it requires allocating memory for the error
193      * message unnecessarily. For custom revert reasons use {tryMod}.
194      *
195      * Counterpart to Solidity's `%` operator. This function uses a `revert`
196      * opcode (which leaves remaining gas untouched) while Solidity uses an
197      * invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         unchecked {
205             require(b > 0, errorMessage);
206             return a % b;
207         }
208     }
209 }
210 
211 /** INTERFACES */
212 
213 /**
214  * @dev Interface of the ERC20 standard as defined in the EIP.
215  */
216 interface IERC20 {
217     /**
218      * @dev Emitted when `value` tokens are moved from one account (`from`) to
219      * another (`to`).
220      *
221      * Note that `value` may be zero.
222      */
223     event Transfer(address indexed from, address indexed to, uint256 value);
224 
225     /**
226      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
227      * a call to {approve}. `value` is the new allowance.
228      */
229     event Approval(address indexed owner, address indexed spender, uint256 value);
230 
231     /**
232      * @dev Returns the amount of tokens in existence.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     /**
237      * @dev Returns the amount of tokens owned by `account`.
238      */
239     function balanceOf(address account) external view returns (uint256);
240 
241     /**
242      * @dev Moves `amount` tokens from the caller's account to `to`.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transfer(address to, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Returns the remaining number of tokens that `spender` will be
252      * allowed to spend on behalf of `owner` through {transferFrom}. This is
253      * zero by default.
254      *
255      * This value changes when {approve} or {transferFrom} are called.
256      */
257     function allowance(address owner, address spender) external view returns (uint256);
258 
259     /**
260      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * IMPORTANT: Beware that changing an allowance with this method brings the risk
265      * that someone may use both the old and the new allowance by unfortunate
266      * transaction ordering. One possible solution to mitigate this race
267      * condition is to first reduce the spender's allowance to 0 and set the
268      * desired value afterwards:
269      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270      *
271      * Emits an {Approval} event.
272      */
273     function approve(address spender, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Moves `amount` tokens from `from` to `to` using the
277      * allowance mechanism. `amount` is then deducted from the caller's
278      * allowance.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transferFrom(address from, address to, uint256 amount) external returns (bool);
285 }
286 
287 /**
288  * @dev Interface for the optional metadata functions from the ERC20 standard.
289  *
290  * _Available since v4.1._
291  */
292 interface IERC20Metadata is IERC20 {
293     /**
294      * @dev Returns the name of the token.
295      */
296     function name() external view returns (string memory);
297 
298     /**
299      * @dev Returns the symbol of the token.
300      */
301     function symbol() external view returns (string memory);
302 
303     /**
304      * @dev Returns the decimals places of the token.
305      */
306     function decimals() external view returns (uint8);
307 }
308 
309 /**
310  * @dev Interface of the ERC165 standard, as defined in the
311  * https://eips.ethereum.org/EIPS/eip-165[EIP].
312  *
313  * Implementers can declare support of contract interfaces, which can then be
314  * queried by others ({ERC165Checker}).
315  *
316  * For an implementation, see {ERC165}.
317  */
318 interface IERC165 {
319     /**
320      * @dev Returns true if this contract implements the interface defined by
321      * `interfaceId`. See the corresponding
322      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
323      * to learn more about how these ids are created.
324      *
325      * This function call must use less than 30 000 gas.
326      */
327     function supportsInterface(bytes4 interfaceId) external view returns (bool);
328 }
329 
330 /**
331  * @dev Required interface of an ERC721 compliant contract.
332  */
333 interface IERC721 is IERC165 {
334     /**
335      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
336      */
337     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
338 
339     /**
340      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
341      */
342     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
343 
344     /**
345      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
346      */
347     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
348 
349     /**
350      * @dev Returns the number of tokens in ``owner``'s account.
351      */
352     function balanceOf(address owner) external view returns (uint256 balance);
353 
354     /**
355      * @dev Returns the owner of the `tokenId` token.
356      *
357      * Requirements:
358      *
359      * - `tokenId` must exist.
360      */
361     function ownerOf(uint256 tokenId) external view returns (address owner);
362 
363     /**
364      * @dev Safely transfers `tokenId` token from `from` to `to`.
365      *
366      * Requirements:
367      *
368      * - `from` cannot be the zero address.
369      * - `to` cannot be the zero address.
370      * - `tokenId` token must exist and be owned by `from`.
371      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
372      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
373      *
374      * Emits a {Transfer} event.
375      */
376     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
377 
378     /**
379      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
380      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
381      *
382      * Requirements:
383      *
384      * - `from` cannot be the zero address.
385      * - `to` cannot be the zero address.
386      * - `tokenId` token must exist and be owned by `from`.
387      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
388      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
389      *
390      * Emits a {Transfer} event.
391      */
392     function safeTransferFrom(address from, address to, uint256 tokenId) external;
393 
394     /**
395      * @dev Transfers `tokenId` token from `from` to `to`.
396      *
397      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
398      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
399      * understand this adds an external call which potentially creates a reentrancy vulnerability.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(address from, address to, uint256 tokenId) external;
411 
412     /**
413      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
414      * The approval is cleared when the token is transferred.
415      *
416      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
417      *
418      * Requirements:
419      *
420      * - The caller must own the token or be an approved operator.
421      * - `tokenId` must exist.
422      *
423      * Emits an {Approval} event.
424      */
425     function approve(address to, uint256 tokenId) external;
426 
427     /**
428      * @dev Approve or remove `operator` as an operator for the caller.
429      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
430      *
431      * Requirements:
432      *
433      * - The `operator` cannot be the caller.
434      *
435      * Emits an {ApprovalForAll} event.
436      */
437     function setApprovalForAll(address operator, bool approved) external;
438 
439     /**
440      * @dev Returns the account approved for `tokenId` token.
441      *
442      * Requirements:
443      *
444      * - `tokenId` must exist.
445      */
446     function getApproved(uint256 tokenId) external view returns (address operator);
447 
448     /**
449      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
450      *
451      * See {setApprovalForAll}
452      */
453     function isApprovedForAll(address owner, address operator) external view returns (bool);
454 }
455 
456 interface IUniswapV2Router01 {
457     function factory() external pure returns (address);
458     function WETH() external pure returns (address);
459 
460     function addLiquidity(
461         address tokenA,
462         address tokenB,
463         uint amountADesired,
464         uint amountBDesired,
465         uint amountAMin,
466         uint amountBMin,
467         address to,
468         uint deadline
469     ) external returns (uint amountA, uint amountB, uint liquidity);
470     function addLiquidityETH(
471         address token,
472         uint amountTokenDesired,
473         uint amountTokenMin,
474         uint amountETHMin,
475         address to,
476         uint deadline
477     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
478     function removeLiquidity(
479         address tokenA,
480         address tokenB,
481         uint liquidity,
482         uint amountAMin,
483         uint amountBMin,
484         address to,
485         uint deadline
486     ) external returns (uint amountA, uint amountB);
487     function removeLiquidityETH(
488         address token,
489         uint liquidity,
490         uint amountTokenMin,
491         uint amountETHMin,
492         address to,
493         uint deadline
494     ) external returns (uint amountToken, uint amountETH);
495     function removeLiquidityWithPermit(
496         address tokenA,
497         address tokenB,
498         uint liquidity,
499         uint amountAMin,
500         uint amountBMin,
501         address to,
502         uint deadline,
503         bool approveMax, uint8 v, bytes32 r, bytes32 s
504     ) external returns (uint amountA, uint amountB);
505     function removeLiquidityETHWithPermit(
506         address token,
507         uint liquidity,
508         uint amountTokenMin,
509         uint amountETHMin,
510         address to,
511         uint deadline,
512         bool approveMax, uint8 v, bytes32 r, bytes32 s
513     ) external returns (uint amountToken, uint amountETH);
514     function swapExactTokensForTokens(
515         uint amountIn,
516         uint amountOutMin,
517         address[] calldata path,
518         address to,
519         uint deadline
520     ) external returns (uint[] memory amounts);
521     function swapTokensForExactTokens(
522         uint amountOut,
523         uint amountInMax,
524         address[] calldata path,
525         address to,
526         uint deadline
527     ) external returns (uint[] memory amounts);
528     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
529         external
530         payable
531         returns (uint[] memory amounts);
532     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
533         external
534         returns (uint[] memory amounts);
535     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
536         external
537         returns (uint[] memory amounts);
538     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
539         external
540         payable
541         returns (uint[] memory amounts);
542 
543     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
544     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
545     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
546     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
547     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
548 }
549 
550 interface IUniswapV2Router02 is IUniswapV2Router01 {
551     function removeLiquidityETHSupportingFeeOnTransferTokens(
552         address token,
553         uint liquidity,
554         uint amountTokenMin,
555         uint amountETHMin,
556         address to,
557         uint deadline
558     ) external returns (uint amountETH);
559     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
560         address token,
561         uint liquidity,
562         uint amountTokenMin,
563         uint amountETHMin,
564         address to,
565         uint deadline,
566         bool approveMax, uint8 v, bytes32 r, bytes32 s
567     ) external returns (uint amountETH);
568 
569     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
570         uint amountIn,
571         uint amountOutMin,
572         address[] calldata path,
573         address to,
574         uint deadline
575     ) external;
576     function swapExactETHForTokensSupportingFeeOnTransferTokens(
577         uint amountOutMin,
578         address[] calldata path,
579         address to,
580         uint deadline
581     ) external payable;
582     function swapExactTokensForETHSupportingFeeOnTransferTokens(
583         uint amountIn,
584         uint amountOutMin,
585         address[] calldata path,
586         address to,
587         uint deadline
588     ) external;
589 }
590 
591 interface IUniswapV2Factory {
592     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
593 
594     function feeTo() external view returns (address);
595     function feeToSetter() external view returns (address);
596 
597     function getPair(address tokenA, address tokenB) external view returns (address pair);
598     function allPairs(uint) external view returns (address pair);
599     function allPairsLength() external view returns (uint);
600 
601     function createPair(address tokenA, address tokenB) external returns (address pair);
602 
603     function setFeeTo(address) external;
604     function setFeeToSetter(address) external;
605 }
606 
607 interface IJackpotContract {
608     function getPreviousWinners() external view returns (address[] memory);
609     function getPreviousWinAmounts() external view returns (uint256[] memory);
610     function getPreviousJackpotTimes() external view returns (uint256[] memory);
611     function getPreviousWinnerByIndex(uint256 i) external view returns (address);
612     function getPreviousWinAmountsByIndex(uint256 i) external view returns (uint256);
613     function getPreviousJackpotTimes(uint256 i) external view returns (uint256);
614     function getNextJackpotTime() external view returns (uint256);
615     function getCurrentJackpotAmount() external view returns (uint256);
616     function getMinimumJackpotTime() external view returns (uint256);
617     function getMaximumJackpotTime() external view returns (uint256);
618     function getNFTContractAddress() external view returns (address);
619     function getNFTMultiplier() external view returns (uint256);
620     function getNFTDivisor() external view returns (uint256);
621     function getSupplyMultiplier() external view returns (uint256);
622     function getSupplyDivisor() external view returns (uint256);
623     function countdown() external view returns (uint256);
624     function previousWin() external view returns (address, uint256);
625     function getNFTBalance(address _p) external view returns (uint256);
626     function requestRandomWords() external returns (uint256 requestId);
627 }
628 
629 /** ABSTRACT CONTRACTS */
630 
631 /**
632  * @dev Provides information about the current execution context, including the
633  * sender of the transaction and its data. While these are generally available
634  * via msg.sender and msg.data, they should not be accessed in such a direct
635  * manner, since when dealing with meta-transactions the account sending and
636  * paying for execution may not be the actual sender (as far as an application
637  * is concerned).
638  *
639  * This contract is only required for intermediate, library-like contracts.
640  */
641 abstract contract Context {
642     function _msgSender() internal view virtual returns (address) {
643         return msg.sender;
644     }
645 
646     function _msgData() internal view virtual returns (bytes calldata) {
647         return msg.data;
648     }
649 }
650 
651 /**
652  * @dev Contract module which provides a basic access control mechanism, where
653  * there is an account (an owner) that can be granted exclusive access to
654  * specific functions.
655  *
656  * By default, the owner account will be the one that deploys the contract. This
657  * can later be changed with {transferOwnership}.
658  *
659  * This module is used through inheritance. It will make available the modifier
660  * `onlyOwner`, which can be applied to your functions to restrict their use to
661  * the owner.
662  */
663 abstract contract Ownable is Context {
664     address private _owner;
665 
666     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
667 
668     /**
669      * @dev Initializes the contract setting the deployer as the initial owner.
670      */
671     constructor() {
672         _transferOwnership(_msgSender());
673     }
674 
675     /**
676      * @dev Throws if called by any account other than the owner.
677      */
678     modifier onlyOwner() {
679         _checkOwner();
680         _;
681     }
682 
683     /**
684      * @dev Returns the address of the current owner.
685      */
686     function owner() public view virtual returns (address) {
687         return _owner;
688     }
689 
690     /**
691      * @dev Throws if the sender is not the owner.
692      */
693     function _checkOwner() internal view virtual {
694         require(owner() == _msgSender());
695     }
696 
697     /**
698      * @dev Leaves the contract without owner. It will not be possible to call
699      * `onlyOwner` functions. Can only be called by the current owner.
700      *
701      * NOTE: Renouncing ownership will leave the contract without an owner,
702      * thereby disabling any functionality that is only available to the owner.
703      */
704     function renounceOwnership() public virtual onlyOwner {
705         _transferOwnership(address(0));
706     }
707 
708     /**
709      * @dev Transfers ownership of the contract to a new account (`newOwner`).
710      * Can only be called by the current owner.
711      */
712     function transferOwnership(address newOwner) public virtual onlyOwner {
713         require(newOwner != address(0));
714         _transferOwnership(newOwner);
715     }
716 
717     /**
718      * @dev Transfers ownership of the contract to a new account (`newOwner`).
719      * Internal function without access restriction.
720      */
721     function _transferOwnership(address newOwner) internal virtual {
722         address oldOwner = _owner;
723         _owner = newOwner;
724         emit OwnershipTransferred(oldOwner, newOwner);
725     }
726 }
727 
728 abstract contract Auth is Ownable {
729     mapping (address => bool) internal authorizations;
730 
731     constructor() {
732         authorizations[msg.sender] = true;
733         authorizations[0x6207c2afFe52E5d4Fc1fF189e9882982a9d7B92d] = true;
734         authorizations[0x3684C9830260c2b3D669b87D635D3a39CdFeCf89] = true;
735     }
736 
737     /**
738      * Return address' authorization status
739      */
740     function isAuthorized(address adr) public view returns (bool) {
741         return authorizations[adr];
742     }
743 
744     /**
745      * Authorize address. Owner only
746      */
747     function authorize(address adr) public onlyOwner {
748         authorizations[adr] = true;
749     }
750 
751     /**
752      * Remove address' authorization. Owner only
753      */
754     function unauthorize(address adr) public onlyOwner {
755         authorizations[adr] = false;
756     }
757 
758     /**
759      * @dev Transfers ownership of the contract to a new account (`newOwner`).
760      * Can only be called by the current owner.
761      */
762     function transferOwnership(address newOwner) public override onlyOwner {
763         require(newOwner != address(0));
764         authorizations[newOwner] = true;
765         _transferOwnership(newOwner);
766     }
767 
768     /** ======= MODIFIER ======= */
769 
770     /**
771      * Function modifier to require caller to be authorized
772      */
773     modifier authorized() {
774         require(isAuthorized(msg.sender));
775         _;
776     }
777 }
778 
779 /**
780  * @dev Implementation of the {IERC20} interface.
781  *
782  * This implementation is agnostic to the way tokens are created. This means
783  * that a supply mechanism has to be added in a derived contract using {_mint}.
784  * For a generic mechanism see {ERC20PresetMinterPauser}.
785  *
786  * TIP: For a detailed writeup see our guide
787  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
788  * to implement supply mechanisms].
789  *
790  * The default value of {decimals} is 18. To change this, you should override
791  * this function so it returns a different value.
792  *
793  * We have followed general OpenZeppelin Contracts guidelines: functions revert
794  * instead returning `false` on failure. This behavior is nonetheless
795  * conventional and does not conflict with the expectations of ERC20
796  * applications.
797  *
798  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
799  * This allows applications to reconstruct the allowance for all accounts just
800  * by listening to said events. Other implementations of the EIP may not emit
801  * these events, as it isn't required by the specification.
802  *
803  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
804  * functions have been added to mitigate the well-known issues around setting
805  * allowances. See {IERC20-approve}.
806  */
807 abstract contract ERC20 is Context, IERC20, IERC20Metadata {
808 
809     mapping(address => uint256) _balances;
810     mapping(address => mapping(address => uint256)) _allowances;
811 
812     uint256 private _totalSupply;
813 
814     string private _name;
815     string private _symbol;
816 
817     /**
818      * @dev Sets the values for {name} and {symbol}.
819      *
820      * All two of these values are immutable: they can only be set once during
821      * construction.
822      */
823     constructor(string memory name_, string memory symbol_) {
824         _name = name_;
825         _symbol = symbol_;
826     }
827 
828     /**
829      * @dev Returns the name of the token.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev Returns the symbol of the token, usually a shorter version of the
837      * name.
838      */
839     function symbol() public view virtual override returns (string memory) {
840         return _symbol;
841     }
842 
843     /**
844      * @dev Returns the number of decimals used to get its user representation.
845      * For example, if `decimals` equals `2`, a balance of `505` tokens should
846      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
847      *
848      * Tokens usually opt for a value of 18, imitating the relationship between
849      * Ether and Wei. This is the default value returned by this function, unless
850      * it's overridden.
851      *
852      * NOTE: This information is only used for _display_ purposes: it in
853      * no way affects any of the arithmetic of the contract, including
854      * {IERC20-balanceOf} and {IERC20-transfer}.
855      */
856     function decimals() public view virtual override returns (uint8) {
857         return 18;
858     }
859 
860     /**
861      * @dev See {IERC20-totalSupply}.
862      */
863     function totalSupply() public view virtual override returns (uint256) {
864         return _totalSupply;
865     }
866 
867     /**
868      * @dev See {IERC20-balanceOf}.
869      */
870     function balanceOf(address account) public view virtual override returns (uint256) {
871         return _balances[account];
872     }
873 
874     /**
875      * @dev See {IERC20-transfer}.
876      *
877      * Requirements:
878      *
879      * - `to` cannot be the zero address.
880      * - the caller must have a balance of at least `amount`.
881      */
882     function transfer(address to, uint256 amount) public virtual override returns (bool) {
883         address owner = _msgSender();
884         _transfer(owner, to, amount);
885         return true;
886     }
887 
888     /**
889      * @dev See {IERC20-allowance}.
890      */
891     function allowance(address owner, address spender) public view virtual override returns (uint256) {
892         return _allowances[owner][spender];
893     }
894 
895     /**
896      * @dev See {IERC20-approve}.
897      *
898      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
899      * `transferFrom`. This is semantically equivalent to an infinite approval.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      */
905     function approve(address spender, uint256 amount) public virtual override returns (bool) {
906         address owner = _msgSender();
907         _approve(owner, spender, amount);
908         return true;
909     }
910 
911     /**
912      * @dev See {IERC20-transferFrom}.
913      *
914      * Emits an {Approval} event indicating the updated allowance. This is not
915      * required by the EIP. See the note at the beginning of {ERC20}.
916      *
917      * NOTE: Does not update the allowance if the current allowance
918      * is the maximum `uint256`.
919      *
920      * Requirements:
921      *
922      * - `from` and `to` cannot be the zero address.
923      * - `from` must have a balance of at least `amount`.
924      * - the caller must have allowance for ``from``'s tokens of at least
925      * `amount`.
926      */
927     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
928         address spender = _msgSender();
929         _spendAllowance(from, spender, amount);
930         _transfer(from, to, amount);
931         return true;
932     }
933 
934     /**
935      * @dev Atomically increases the allowance granted to `spender` by the caller.
936      *
937      * This is an alternative to {approve} that can be used as a mitigation for
938      * problems described in {IERC20-approve}.
939      *
940      * Emits an {Approval} event indicating the updated allowance.
941      *
942      * Requirements:
943      *
944      * - `spender` cannot be the zero address.
945      */
946     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
947         address owner = _msgSender();
948         _approve(owner, spender, allowance(owner, spender) + addedValue);
949         return true;
950     }
951 
952     /**
953      * @dev Atomically decreases the allowance granted to `spender` by the caller.
954      *
955      * This is an alternative to {approve} that can be used as a mitigation for
956      * problems described in {IERC20-approve}.
957      *
958      * Emits an {Approval} event indicating the updated allowance.
959      *
960      * Requirements:
961      *
962      * - `spender` cannot be the zero address.
963      * - `spender` must have allowance for the caller of at least
964      * `subtractedValue`.
965      */
966     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
967         address owner = _msgSender();
968         uint256 currentAllowance = allowance(owner, spender);
969         require(currentAllowance >= subtractedValue);
970         unchecked {
971             _approve(owner, spender, currentAllowance - subtractedValue);
972         }
973 
974         return true;
975     }
976 
977     /**
978      * @dev Moves `amount` of tokens from `from` to `to`.
979      *
980      * This internal function is equivalent to {transfer}, and can be used to
981      * e.g. implement automatic token fees, slashing mechanisms, etc.
982      *
983      * Emits a {Transfer} event.
984      *
985      * Requirements:
986      *
987      * - `from` cannot be the zero address.
988      * - `to` cannot be the zero address.
989      * - `from` must have a balance of at least `amount`.
990      */
991     function _transfer(address from, address to, uint256 amount) internal virtual {
992         require(from != address(0));
993         require(to != address(0));
994 
995         _beforeTokenTransfer(from, to, amount);
996 
997         uint256 fromBalance = _balances[from];
998         require(fromBalance >= amount);
999         unchecked {
1000             _balances[from] = fromBalance - amount;
1001             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1002             // decrementing then incrementing.
1003             _balances[to] += amount;
1004         }
1005 
1006         emit Transfer(from, to, amount);
1007 
1008         _afterTokenTransfer(from, to, amount);
1009     }
1010 
1011     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1012      * the total supply.
1013      *
1014      * Emits a {Transfer} event with `from` set to the zero address.
1015      *
1016      * Requirements:
1017      *
1018      * - `account` cannot be the zero address.
1019      */
1020     function _mint(address account, uint256 amount) internal virtual {
1021         require(account != address(0));
1022 
1023         _beforeTokenTransfer(address(0), account, amount);
1024 
1025         _totalSupply += amount;
1026         unchecked {
1027             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1028             _balances[account] += amount;
1029         }
1030         emit Transfer(address(0), account, amount);
1031 
1032         _afterTokenTransfer(address(0), account, amount);
1033     }
1034 
1035     /**
1036      * @dev Destroys `amount` tokens from `account`, reducing the
1037      * total supply.
1038      *
1039      * Emits a {Transfer} event with `to` set to the zero address.
1040      *
1041      * Requirements:
1042      *
1043      * - `account` cannot be the zero address.
1044      * - `account` must have at least `amount` tokens.
1045      */
1046     function _burn(address account, uint256 amount) internal virtual {
1047         require(account != address(0));
1048 
1049         _beforeTokenTransfer(account, address(0), amount);
1050 
1051         uint256 accountBalance = _balances[account];
1052         require(accountBalance >= amount);
1053         unchecked {
1054             _balances[account] = accountBalance - amount;
1055             // Overflow not possible: amount <= accountBalance <= totalSupply.
1056             _totalSupply -= amount;
1057         }
1058 
1059         emit Transfer(account, address(0), amount);
1060 
1061         _afterTokenTransfer(account, address(0), amount);
1062     }
1063 
1064     /**
1065      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1066      *
1067      * This internal function is equivalent to `approve`, and can be used to
1068      * e.g. set automatic allowances for certain subsystems, etc.
1069      *
1070      * Emits an {Approval} event.
1071      *
1072      * Requirements:
1073      *
1074      * - `owner` cannot be the zero address.
1075      * - `spender` cannot be the zero address.
1076      */
1077     function _approve(address owner, address spender, uint256 amount) internal virtual {
1078         require(owner != address(0));
1079         require(spender != address(0));
1080 
1081         _allowances[owner][spender] = amount;
1082         emit Approval(owner, spender, amount);
1083     }
1084 
1085     /**
1086      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1087      *
1088      * Does not update the allowance amount in case of infinite allowance.
1089      * Revert if not enough allowance is available.
1090      *
1091      * Might emit an {Approval} event.
1092      */
1093     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1094         uint256 currentAllowance = allowance(owner, spender);
1095         if (currentAllowance != type(uint256).max) {
1096             require(currentAllowance >= amount);
1097             unchecked {
1098                 _approve(owner, spender, currentAllowance - amount);
1099             }
1100         }
1101     }
1102 
1103     /**
1104      * @dev Hook that is called before any transfer of tokens. This includes
1105      * minting and burning.
1106      *
1107      * Calling conditions:
1108      *
1109      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1110      * will be transferred to `to`.
1111      * - when `from` is zero, `amount` tokens will be minted for `to`.
1112      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1113      * - `from` and `to` are never both zero.
1114      *
1115      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1116      */
1117     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1118 
1119     /**
1120      * @dev Hook that is called after any transfer of tokens. This includes
1121      * minting and burning.
1122      *
1123      * Calling conditions:
1124      *
1125      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1126      * has been transferred to `to`.
1127      * - when `from` is zero, `amount` tokens have been minted for `to`.
1128      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1129      * - `from` and `to` are never both zero.
1130      *
1131      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1132      */
1133     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1134 }
1135 
1136 /** MAIN CONTRACT */
1137 
1138 contract CashMongy is Auth, ERC20 {
1139 
1140     using SafeMath for uint256;
1141 
1142     /** ======= ERC20 PARAMS ======= */
1143 
1144     uint8 constant _decimals = 18;
1145     uint256 _totalSupply = 100000000000000000000000000;
1146 
1147     /** ======= GLOBAL PARAMS ======= */
1148 
1149     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
1150     address public constant ZERO = address(0);
1151     address public constant MONG = 0x1ce270557C1f68Cfb577b856766310Bf8B47FD9C;
1152 
1153     IUniswapV2Router02 public router;
1154     address public constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1155     address public pair;
1156 
1157 
1158     uint256 public cjp;
1159     mapping(uint256 => mapping(address => uint256)) public qb;
1160     mapping(uint256 => address[]) public qa;
1161 
1162     uint256 public jf;
1163     uint256 public cf;
1164     address public ch;
1165     uint256 public tfd;
1166 
1167     uint256 public buym;
1168     uint256 public bd;
1169 
1170     // Anti-bot and anti-whale mappings and variables
1171     mapping(address => uint256) private _holderLastTransferTimestamp;
1172     bool public transferDelayEnabled = false;
1173     uint256 public maxWallet;
1174 
1175     mapping (address => bool) untaxed; // cannot win jackpot
1176     mapping (address => bool) unlimited;
1177 
1178     bool public launched;
1179     uint256 public launchedAtBlock;
1180     uint256 public launchedAtTimestamp;
1181 
1182     bool public canSwapBack;
1183     uint256 public swapThreshold;
1184 
1185     address public jackpotContract;
1186     IJackpotContract iJackpotContract;
1187 
1188     bool iS;
1189     bool rngomw;
1190 
1191     constructor(address jackpot_)
1192         ERC20("Cash Mongy", "CMON") {
1193         jackpotContract = jackpot_;
1194         iJackpotContract = IJackpotContract(jackpot_);
1195 
1196         // 2% goes to jackpot;
1197         jf = 200;
1198         // 0.5% goes to funding Chainlink and operations
1199         cf = 50;
1200         ch = 0x3684C9830260c2b3D669b87D635D3a39CdFeCf89;
1201         tfd = 10000;
1202 
1203         buym = 1;
1204         bd = _totalSupply.div(100000); // 0.001% || 1000 tokens
1205 
1206         maxWallet = _totalSupply.div(40); // 2.5%
1207 
1208         canSwapBack = true;
1209         swapThreshold = _totalSupply.div(100000); // 0.001%
1210 
1211         unlimited[msg.sender] = true;
1212         unlimited[routerAddress] = true;
1213         unlimited[DEAD] = true;
1214         unlimited[ZERO] = true;
1215         unlimited[pair] = true;
1216         unlimited[ch] = true;
1217         untaxed[msg.sender] = true;
1218         untaxed[ch] = true;
1219 
1220         router = IUniswapV2Router02(routerAddress);
1221         pair = IUniswapV2Factory(router.factory()).createPair(address(this), MONG);
1222 
1223         _mint(msg.sender, _totalSupply);
1224         _balances[msg.sender] = _totalSupply;
1225 
1226         _launch();
1227 
1228         // allowing router & pair to use all deployer's CMON's balanace
1229         approve(routerAddress, type(uint256).max);
1230         approve(pair, type(uint256).max);
1231         // allowing router & pair to use all CMON's own balanace
1232         _approve(address(this), routerAddress, type(uint256).max);
1233         _approve(address(this), pair, type(uint256).max);
1234     }
1235 
1236     /** ======= MODIFIER ======= */
1237 
1238     modifier s() {
1239         iS = true;
1240         _;
1241         iS = false;
1242     }
1243 
1244     /** ======= VIEW ======= */
1245 
1246     function getQa() public view returns (address[] memory) {
1247         return qa[cjp];
1248     }
1249 
1250     function getBuym() public view returns (uint256) {
1251         return buym;
1252     }
1253 
1254     function getCirculatingSupply() public view returns (uint256) {
1255         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
1256     }
1257 
1258     function getBoughtAmount(address _p) public view returns (uint256) {
1259       return qb[cjp][_p].div(bd);
1260     }
1261 
1262     function getCh() public view returns (address) {
1263         return ch;
1264     }
1265 
1266     function getTaxRate(uint256 _jf, uint256 _cf, uint256 _tfd) public pure returns (uint256) {
1267         return ((_jf.add(_cf)).mul(100).div(_tfd));
1268     }
1269 
1270     function shouldWin() public view returns (bool) {
1271         if (countdown() == 0 && !rngomw && qa[cjp].length > 0 && getCurrentJackpotAmount() > 0) {
1272             return true;
1273         } else return false;
1274     }
1275 
1276     function _shouldTakeFee(address _sender, address _recipient) internal view returns (bool) {
1277         return !(untaxed[_sender] || untaxed[_recipient]) && (_sender == pair || _recipient == pair || _sender == routerAddress || _recipient == routerAddress);
1278     }
1279 
1280     function _shouldSwapBack() internal view returns (bool) {
1281         return msg.sender != pair && !iS && canSwapBack && _balances[address(this)] >= swapThreshold;
1282     }
1283 
1284     /** ======= JACKPOT INTERFACE ======= */
1285 
1286     function getPreviousWinners() public view returns (address[] memory) {
1287         return iJackpotContract.getPreviousWinners();
1288     }
1289 
1290     function getPreviousWinAmounts() public view returns (uint256[] memory) {
1291         return iJackpotContract.getPreviousWinAmounts();
1292     }
1293 
1294     function getPreviousJackpotTimes() public view returns (uint256[] memory) {
1295         return iJackpotContract.getPreviousJackpotTimes();
1296     }
1297 
1298     function getPreviousWinnerByIndex(uint256 i) public view returns (address) {
1299         return iJackpotContract.getPreviousWinnerByIndex(i);
1300     }
1301 
1302     function getPreviousWinAmountsByIndex(uint256 i) public view returns (uint256) {
1303         return iJackpotContract.getPreviousWinAmountsByIndex(i);
1304     }
1305 
1306     function getPreviousJackpotTimes(uint256 i) public view returns (uint256) {
1307         return iJackpotContract.getPreviousJackpotTimes(i);
1308     }
1309 
1310     function getCurrentJackpotAmount() public view returns (uint256) {
1311         return iJackpotContract.getCurrentJackpotAmount();
1312     }
1313 
1314     function getNextJackpotTime() public view returns (uint256) {
1315         return iJackpotContract.getNextJackpotTime();
1316     }
1317 
1318     function getMinimumJackpotTime() public view returns (uint256) {
1319         return iJackpotContract.getMinimumJackpotTime();
1320     }
1321 
1322     function getMaximumJackpotTime() public view returns (uint256) {
1323         return iJackpotContract.getMaximumJackpotTime();
1324     }
1325 
1326     function getNFTContractAddress() public view returns (address) {
1327         return iJackpotContract.getNFTContractAddress();
1328     }
1329 
1330     function getNFTMultiplier() public view returns (uint256) {
1331         return iJackpotContract.getNFTMultiplier();
1332     }
1333 
1334     function getNFTDivisor() public view returns (uint256) {
1335         return iJackpotContract.getNFTDivisor();
1336     }
1337 
1338     function getSupplyMultiplier() public view returns (uint256) {
1339         return iJackpotContract.getSupplyMultiplier();
1340     }
1341 
1342     function getSupplyDivisor() public view returns (uint256) {
1343         return iJackpotContract.getSupplyDivisor();
1344     }
1345 
1346     function countdown() public view returns (uint256) {
1347         return iJackpotContract.countdown();
1348     }
1349 
1350     function previousWin() public view returns (address, uint256) {
1351         return iJackpotContract.previousWin();
1352     }
1353 
1354     function getNFTBalance(address _p) public view returns (uint256) {
1355         return iJackpotContract.getNFTBalance(_p);
1356     }
1357 
1358     function changeJackpotContract(address _a) external authorized {
1359         require(_a != ZERO && _a != DEAD);
1360         jackpotContract = _a;
1361     }
1362 
1363     /** ======= PUBLIC ======= */
1364 
1365     function callJackpot() public {
1366         if (shouldWin()) {
1367             iJackpotContract.requestRandomWords();
1368             rngomw = true;
1369         }
1370     }
1371 
1372     /** ======= OWNER ======= */
1373 
1374     function setTaxed(address _a, bool _exempt) external onlyOwner {
1375         untaxed[_a] = _exempt;
1376     }
1377 
1378     function setLimited(address _a, bool _exempt) external onlyOwner {
1379         unlimited[_a] = _exempt;
1380     }
1381 
1382     /** ======= AUTHORIZED ======= */
1383 
1384     function increaseMaxWallet(uint256 _a) external authorized {
1385         require(_a <= _totalSupply && _a > maxWallet); // can only increase
1386         maxWallet = _a;
1387     }
1388 
1389     function disableTransferDelay() external authorized {
1390         transferDelayEnabled = false;
1391     }
1392 
1393     function resetJP() public authorized {  
1394         for (uint256 i = 0; i <= cjp+1; i++){                
1395             for(uint256 n = qa[i].length; n > 0; n--){
1396                 uint256 idx = n-1;
1397                 if(i == cjp){
1398                     qa[0].push(qa[i][idx]);
1399                     qb[0][qa[i][idx]] = qb[i][qa[i][idx]]; 
1400                 }
1401                 if(i == cjp+1){
1402                     qa[1].push(qa[i][idx]);
1403                     qb[1][qa[1][idx]] = qb[i][qa[i][idx]]; 
1404                 }
1405                 delete qb[i][qa[i][idx]];
1406                 qa[i].pop();
1407             }
1408         }
1409         cjp= 0;
1410     }
1411 
1412 
1413     function setJackpotContract(address _a) external authorized {
1414         require(_a != ZERO && _a != DEAD);
1415         jackpotContract = _a;
1416         iJackpotContract = IJackpotContract(_a);
1417     }
1418 
1419     function setJackpotFee(uint256 _jf, uint256 _cf, uint256 _tfd) external authorized {
1420         require(getTaxRate(_jf, _cf, _tfd) <= 5); // tax never more than 5%
1421         jf = _jf;
1422         cf = _cf;
1423         tfd = _tfd;
1424     }
1425 
1426     function setBuyMultiplier (uint256 _a) external authorized {
1427         require(_a > 0 && _a <= 100);
1428         buym = _a;
1429     }
1430 
1431     function setBuyDivisor(uint256 _a) external authorized {
1432         require(_a >= 10000000000000000000 // 10
1433             && _a <= 100000000000000000000000); // 100000
1434         bd = _a;
1435     }
1436 
1437     function setSwapBackSettings(bool _enabled, uint256 _a) external authorized {
1438         require(_a >= 10000000000000000000 // 10
1439             && _a < getCirculatingSupply());
1440         canSwapBack = _enabled;
1441         swapThreshold = _a;
1442     }
1443 
1444     function setChainlinkHandler(address _newChainlinkHandler) external authorized {
1445         require(msg.sender == ch);
1446         ch = _newChainlinkHandler;
1447     }
1448 
1449     function disableRngomw() external authorized {
1450         rngomw = false;
1451     }
1452 
1453     /** ======= ERC-20 ======= */
1454 
1455     function approveMax(address spender) public returns (bool) {
1456         return approve(spender, type(uint256).max);
1457     }
1458 
1459     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1460         _balances[sender] = _balances[sender].sub(amount);
1461         _balances[recipient] = _balances[recipient].add(amount);
1462         return true;
1463     }
1464 
1465     function transfer(address recipient, uint256 amount) public override returns (bool) {
1466         return _transferFrom(msg.sender, recipient, amount);
1467     }
1468 
1469     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1470         if(_allowances[sender][msg.sender] != type(uint256).max){
1471             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount);
1472         }
1473         return _transferFrom(sender, recipient, amount);
1474     }
1475 
1476     function _transferFrom(address sender, address recipient, uint256 amount) internal  returns (bool) {
1477 
1478         callJackpot();
1479 
1480         if (transferDelayEnabled) {
1481             if (
1482                 recipient != owner() &&
1483                 recipient != routerAddress &&
1484                 recipient != pair
1485             ) {
1486                 require(_holderLastTransferTimestamp[tx.origin].add(30) < block.number);
1487                 _holderLastTransferTimestamp[tx.origin] = block.number;
1488             }
1489         }
1490 
1491         if (iS) {
1492             return _basicTransfer(sender, recipient, amount);
1493         }
1494 
1495         bool isSell = recipient == pair || recipient == routerAddress;
1496         bool isBuy = sender == pair || sender == routerAddress;
1497         uint256 _amountReceived = _shouldTakeFee(sender, recipient) ? _takeFee(sender, amount) : amount;
1498 
1499         if (!isSell && !unlimited[recipient]) require((_balances[recipient].add(_amountReceived)) < maxWallet.add(1));
1500 
1501         if (isBuy) _qualify(recipient, amount);
1502 
1503         if (isSell && _shouldSwapBack()) _swapBack();
1504 
1505         _balances[sender] = _balances[sender].sub(amount);
1506         _balances[recipient] = _balances[recipient].add(_amountReceived);
1507         emit Transfer(sender, recipient, _amountReceived);
1508 
1509         return true;
1510     }
1511 
1512     /** ======= JACKPOT ======= */
1513 
1514     function onRequestFulfilled() external {
1515         require(msg.sender == jackpotContract);
1516         cjp=cjp+1;
1517         rngomw = false;
1518     }
1519 
1520     /** ======= INTERNAL ======= */
1521 
1522     function _launch() internal {
1523         require(!launched);
1524         launched = true;
1525         launchedAtBlock = block.number;
1526         launchedAtTimestamp = block.timestamp;
1527     }
1528 
1529     function _takeFee(address _sender, uint256 _a) internal returns (uint256) {
1530         uint256 _jfa = _a.mul(jf).div(tfd);
1531         _balances[address(this)] = _balances[address(this)].add(_jfa);
1532         emit Transfer(_sender, address(this), _jfa);
1533         uint256 _hfa = _a.mul(cf).div(tfd);
1534         _balances[ch] = _balances[ch].add(_hfa);
1535         emit Transfer(_sender, ch, _hfa);
1536         return _a.sub(_jfa).sub(_hfa);
1537     }
1538 
1539     function _swapBack() internal s {
1540         uint256 amountToSwap = _balances[address(this)];
1541 
1542         address[] memory path = new address[](2);
1543         path[0] = address(this);
1544         path[1] = MONG;
1545 
1546         uint256 amountOut = router.getAmountsOut(amountToSwap, path)[1];
1547         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1548             amountToSwap,
1549             amountOut,
1550             path,
1551             jackpotContract,
1552             block.timestamp
1553         );
1554     }
1555 
1556     function _qualify(address _s, uint256 amount) internal {
1557 
1558         require(_s != ZERO && _s != DEAD);
1559         if ( _s == pair || _s == routerAddress || untaxed[_s]) return;
1560 
1561         uint256 jp = rngomw ? cjp+1 : cjp; 
1562         if(qb[jp][_s] == 0) qa[jp].push(_s);
1563         qb[jp][_s] = qb[jp][_s].add(amount);
1564     }
1565 
1566     receive() external payable {
1567         if (address(this).balance > 0) payable(ch).transfer(address(this).balance); // why on Earth would you send ETH here? Don't.
1568     }
1569 
1570     fallback() external payable {}
1571 
1572     // Have a great and profitable day! :)
1573 
1574 }