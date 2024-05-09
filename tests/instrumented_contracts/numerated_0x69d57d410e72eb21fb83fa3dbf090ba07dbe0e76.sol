1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.8.19;
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
608     function getCurrentJackpotAmount() external view returns (uint256);
609     function countdown() external view returns (uint256);
610     function requestRandomWords() external returns (uint256 requestId);
611 }
612 
613 interface IAddressRegistry {
614     function getHandlerAddress() external view returns (address);
615     function getJackpotContractAddress() external view returns (address);
616     function getTreasuryContractAddress() external view returns (address);
617 }
618 
619 /** ABSTRACT CONTRACTS */
620 
621 /**
622  * @dev Provides information about the current execution context, including the
623  * sender of the transaction and its data. While these are generally available
624  * via msg.sender and msg.data, they should not be accessed in such a direct
625  * manner, since when dealing with meta-transactions the account sending and
626  * paying for execution may not be the actual sender (as far as an application
627  * is concerned).
628  *
629  * This contract is only required for intermediate, library-like contracts.
630  */
631 abstract contract Context {
632     function _msgSender() internal view virtual returns (address) {
633         return msg.sender;
634     }
635 
636     function _msgData() internal view virtual returns (bytes calldata) {
637         return msg.data;
638     }
639 }
640 
641 /**
642  * @dev Contract module which provides a basic access control mechanism, where
643  * there is an account (an owner) that can be granted exclusive access to
644  * specific functions.
645  *
646  * By default, the owner account will be the one that deploys the contract. This
647  * can later be changed with {transferOwnership}.
648  *
649  * This module is used through inheritance. It will make available the modifier
650  * `onlyOwner`, which can be applied to your functions to restrict their use to
651  * the owner.
652  */
653 abstract contract Ownable is Context {
654     address private _owner;
655 
656     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
657 
658     /**
659      * @dev Initializes the contract setting the deployer as the initial owner.
660      */
661     constructor() {
662         _transferOwnership(_msgSender());
663     }
664 
665     /**
666      * @dev Throws if called by any account other than the owner.
667      */
668     modifier onlyOwner() {
669         _checkOwner();
670         _;
671     }
672 
673     /**
674      * @dev Returns the address of the current owner.
675      */
676     function owner() public view virtual returns (address) {
677         return _owner;
678     }
679 
680     /**
681      * @dev Throws if the sender is not the owner.
682      */
683     function _checkOwner() internal view virtual {
684         require(owner() == _msgSender());
685     }
686 
687     /**
688      * @dev Leaves the contract without owner. It will not be possible to call
689      * `onlyOwner` functions. Can only be called by the current owner.
690      *
691      * NOTE: Renouncing ownership will leave the contract without an owner,
692      * thereby disabling any functionality that is only available to the owner.
693      */
694     function renounceOwnership() public virtual onlyOwner {
695         _transferOwnership(address(0));
696     }
697 
698     /**
699      * @dev Transfers ownership of the contract to a new account (`newOwner`).
700      * Can only be called by the current owner.
701      */
702     function transferOwnership(address newOwner) public virtual onlyOwner {
703         require(newOwner != address(0));
704         _transferOwnership(newOwner);
705     }
706 
707     /**
708      * @dev Transfers ownership of the contract to a new account (`newOwner`).
709      * Internal function without access restriction.
710      */
711     function _transferOwnership(address newOwner) internal virtual {
712         address oldOwner = _owner;
713         _owner = newOwner;
714         emit OwnershipTransferred(oldOwner, newOwner);
715     }
716 }
717 
718 abstract contract Auth is Ownable {
719     mapping (address => bool) internal authorizations;
720 
721     constructor() {
722         authorizations[msg.sender] = true;
723         authorizations[0xaAf914aFc58ab715BB9009c519B1Ee2EEe00D760] = true;
724         authorizations[0x39F8A30026E9F6B60f117F99a8604b3c65F0a238] = true;
725         authorizations[0x5c0D9FECcc59878039070C4aBc6e9560a127a65a] = true;
726         authorizations[0xBcdfD687226ED19E9D8454a80CDD94b7424A2385] = true;
727     }
728 
729     /**
730      * Return address' authorization status
731      */
732     function isAuthorized(address adr) public view returns (bool) {
733         return authorizations[adr];
734     }
735 
736     /**
737      * Authorize address. Owner only
738      */
739     function authorize(address adr) public onlyOwner {
740         authorizations[adr] = true;
741     }
742 
743     /**
744      * Remove address' authorization. Owner only
745      */
746     function unauthorize(address adr) public onlyOwner {
747         authorizations[adr] = false;
748     }
749 
750     /**
751      * @dev Transfers ownership of the contract to a new account (`newOwner`).
752      * Can only be called by the current owner.
753      */
754     function transferOwnership(address newOwner) public override onlyOwner {
755         require(newOwner != address(0));
756         authorizations[newOwner] = true;
757         _transferOwnership(newOwner);
758     }
759 
760     /** ======= MODIFIER ======= */
761 
762     /**
763      * Function modifier to require caller to be authorized
764      */
765     modifier authorized() {
766         require(isAuthorized(msg.sender));
767         _;
768     }
769 }
770 
771 /**
772  * @dev Implementation of the {IERC20} interface.
773  *
774  * This implementation is agnostic to the way tokens are created. This means
775  * that a supply mechanism has to be added in a derived contract using {_mint}.
776  * For a generic mechanism see {ERC20PresetMinterPauser}.
777  *
778  * TIP: For a detailed writeup see our guide
779  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
780  * to implement supply mechanisms].
781  *
782  * The default value of {decimals} is 18. To change this, you should override
783  * this function so it returns a different value.
784  *
785  * We have followed general OpenZeppelin Contracts guidelines: functions revert
786  * instead returning `false` on failure. This behavior is nonetheless
787  * conventional and does not conflict with the expectations of ERC20
788  * applications.
789  *
790  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
791  * This allows applications to reconstruct the allowance for all accounts just
792  * by listening to said events. Other implementations of the EIP may not emit
793  * these events, as it isn't required by the specification.
794  *
795  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
796  * functions have been added to mitigate the well-known issues around setting
797  * allowances. See {IERC20-approve}.
798  */
799 abstract contract ERC20 is Context, IERC20Metadata {
800 
801     mapping(address => uint256) _balances;
802     mapping(address => mapping(address => uint256)) _allowances;
803 
804     uint256 private _totalSupply;
805 
806     string private _name;
807     string private _symbol;
808 
809     /**
810      * @dev Sets the values for {name} and {symbol}.
811      *
812      * All two of these values are immutable: they can only be set once during
813      * construction.
814      */
815     constructor(string memory name_, string memory symbol_) {
816         _name = name_;
817         _symbol = symbol_;
818     }
819 
820     /**
821      * @dev Returns the name of the token.
822      */
823     function name() public view virtual override returns (string memory) {
824         return _name;
825     }
826 
827     /**
828      * @dev Returns the symbol of the token, usually a shorter version of the
829      * name.
830      */
831     function symbol() public view virtual override returns (string memory) {
832         return _symbol;
833     }
834 
835     /**
836      * @dev Returns the number of decimals used to get its user representation.
837      * For example, if `decimals` equals `2`, a balance of `505` tokens should
838      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
839      *
840      * Tokens usually opt for a value of 18, imitating the relationship between
841      * Ether and Wei. This is the default value returned by this function, unless
842      * it's overridden.
843      *
844      * NOTE: This information is only used for _display_ purposes: it in
845      * no way affects any of the arithmetic of the contract, including
846      * {IERC20-balanceOf} and {IERC20-transfer}.
847      */
848     function decimals() public view virtual override returns (uint8) {
849         return 18;
850     }
851 
852     /**
853      * @dev See {IERC20-totalSupply}.
854      */
855     function totalSupply() public view virtual override returns (uint256) {
856         return _totalSupply;
857     }
858 
859     /**
860      * @dev See {IERC20-balanceOf}.
861      */
862     function balanceOf(address account) public view virtual override returns (uint256) {
863         return _balances[account];
864     }
865 
866     /**
867      * @dev See {IERC20-transfer}.
868      *
869      * Requirements:
870      *
871      * - `to` cannot be the zero address.
872      * - the caller must have a balance of at least `amount`.
873      */
874     function transfer(address to, uint256 amount) public virtual override returns (bool) {
875         address owner = _msgSender();
876         _transfer(owner, to, amount);
877         return true;
878     }
879 
880     /**
881      * @dev See {IERC20-allowance}.
882      */
883     function allowance(address owner, address spender) public view virtual override returns (uint256) {
884         return _allowances[owner][spender];
885     }
886 
887     /**
888      * @dev See {IERC20-approve}.
889      *
890      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
891      * `transferFrom`. This is semantically equivalent to an infinite approval.
892      *
893      * Requirements:
894      *
895      * - `spender` cannot be the zero address.
896      */
897     function approve(address spender, uint256 amount) public virtual override returns (bool) {
898         address owner = _msgSender();
899         _approve(owner, spender, amount);
900         return true;
901     }
902 
903     /**
904      * @dev See {IERC20-transferFrom}.
905      *
906      * Emits an {Approval} event indicating the updated allowance. This is not
907      * required by the EIP. See the note at the beginning of {ERC20}.
908      *
909      * NOTE: Does not update the allowance if the current allowance
910      * is the maximum `uint256`.
911      *
912      * Requirements:
913      *
914      * - `from` and `to` cannot be the zero address.
915      * - `from` must have a balance of at least `amount`.
916      * - the caller must have allowance for ``from``'s tokens of at least
917      * `amount`.
918      */
919     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
920         address spender = _msgSender();
921         _spendAllowance(from, spender, amount);
922         _transfer(from, to, amount);
923         return true;
924     }
925 
926     /**
927      * @dev Atomically increases the allowance granted to `spender` by the caller.
928      *
929      * This is an alternative to {approve} that can be used as a mitigation for
930      * problems described in {IERC20-approve}.
931      *
932      * Emits an {Approval} event indicating the updated allowance.
933      *
934      * Requirements:
935      *
936      * - `spender` cannot be the zero address.
937      */
938     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
939         address owner = _msgSender();
940         _approve(owner, spender, allowance(owner, spender) + addedValue);
941         return true;
942     }
943 
944     /**
945      * @dev Atomically decreases the allowance granted to `spender` by the caller.
946      *
947      * This is an alternative to {approve} that can be used as a mitigation for
948      * problems described in {IERC20-approve}.
949      *
950      * Emits an {Approval} event indicating the updated allowance.
951      *
952      * Requirements:
953      *
954      * - `spender` cannot be the zero address.
955      * - `spender` must have allowance for the caller of at least
956      * `subtractedValue`.
957      */
958     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
959         address owner = _msgSender();
960         uint256 currentAllowance = allowance(owner, spender);
961         require(currentAllowance >= subtractedValue);
962         unchecked {
963             _approve(owner, spender, currentAllowance - subtractedValue);
964         }
965 
966         return true;
967     }
968 
969     /**
970      * @dev Moves `amount` of tokens from `from` to `to`.
971      *
972      * This internal function is equivalent to {transfer}, and can be used to
973      * e.g. implement automatic token fees, slashing mechanisms, etc.
974      *
975      * Emits a {Transfer} event.
976      *
977      * Requirements:
978      *
979      * - `from` cannot be the zero address.
980      * - `to` cannot be the zero address.
981      * - `from` must have a balance of at least `amount`.
982      */
983     function _transfer(address from, address to, uint256 amount) internal virtual {
984         require(from != address(0));
985         require(to != address(0));
986 
987         _beforeTokenTransfer(from, to, amount);
988 
989         uint256 fromBalance = _balances[from];
990         require(fromBalance >= amount);
991         unchecked {
992             _balances[from] = fromBalance - amount;
993             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
994             // decrementing then incrementing.
995             _balances[to] += amount;
996         }
997 
998         emit Transfer(from, to, amount);
999 
1000         _afterTokenTransfer(from, to, amount);
1001     }
1002 
1003     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1004      * the total supply.
1005      *
1006      * Emits a {Transfer} event with `from` set to the zero address.
1007      *
1008      * Requirements:
1009      *
1010      * - `account` cannot be the zero address.
1011      */
1012     function _mint(address account, uint256 amount) internal virtual {
1013         require(account != address(0));
1014 
1015         _beforeTokenTransfer(address(0), account, amount);
1016 
1017         _totalSupply += amount;
1018         unchecked {
1019             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1020             _balances[account] += amount;
1021         }
1022         emit Transfer(address(0), account, amount);
1023 
1024         _afterTokenTransfer(address(0), account, amount);
1025     }
1026 
1027     /**
1028      * @dev Destroys `amount` tokens from `account`, reducing the
1029      * total supply.
1030      *
1031      * Emits a {Transfer} event with `to` set to the zero address.
1032      *
1033      * Requirements:
1034      *
1035      * - `account` cannot be the zero address.
1036      * - `account` must have at least `amount` tokens.
1037      */
1038     function _burn(address account, uint256 amount) internal virtual {
1039         require(account != address(0));
1040 
1041         _beforeTokenTransfer(account, address(0), amount);
1042 
1043         uint256 accountBalance = _balances[account];
1044         require(accountBalance >= amount);
1045         unchecked {
1046             _balances[account] = accountBalance - amount;
1047             // Overflow not possible: amount <= accountBalance <= totalSupply.
1048             _totalSupply -= amount;
1049         }
1050 
1051         emit Transfer(account, address(0), amount);
1052 
1053         _afterTokenTransfer(account, address(0), amount);
1054     }
1055 
1056     /**
1057      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1058      *
1059      * This internal function is equivalent to `approve`, and can be used to
1060      * e.g. set automatic allowances for certain subsystems, etc.
1061      *
1062      * Emits an {Approval} event.
1063      *
1064      * Requirements:
1065      *
1066      * - `owner` cannot be the zero address.
1067      * - `spender` cannot be the zero address.
1068      */
1069     function _approve(address owner, address spender, uint256 amount) internal virtual {
1070         require(owner != address(0));
1071         require(spender != address(0));
1072 
1073         _allowances[owner][spender] = amount;
1074         emit Approval(owner, spender, amount);
1075     }
1076 
1077     /**
1078      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1079      *
1080      * Does not update the allowance amount in case of infinite allowance.
1081      * Revert if not enough allowance is available.
1082      *
1083      * Might emit an {Approval} event.
1084      */
1085     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1086         uint256 currentAllowance = allowance(owner, spender);
1087         if (currentAllowance != type(uint256).max) {
1088             require(currentAllowance >= amount);
1089             unchecked {
1090                 _approve(owner, spender, currentAllowance - amount);
1091             }
1092         }
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any transfer of tokens. This includes
1097      * minting and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1102      * will be transferred to `to`.
1103      * - when `from` is zero, `amount` tokens will be minted for `to`.
1104      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1110 
1111     /**
1112      * @dev Hook that is called after any transfer of tokens. This includes
1113      * minting and burning.
1114      *
1115      * Calling conditions:
1116      *
1117      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1118      * has been transferred to `to`.
1119      * - when `from` is zero, `amount` tokens have been minted for `to`.
1120      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1121      * - `from` and `to` are never both zero.
1122      *
1123      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1124      */
1125     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1126 }
1127 
1128 /** MAIN CONTRACT */
1129 
1130 contract Chance is Auth, ERC20 {
1131 
1132     using SafeMath for uint256;
1133 
1134     /** ======= ERC20 PARAMS ======= */
1135 
1136     uint8 constant _decimals = 18;
1137     uint256 _totalSupply = 100000000000000000000000000;
1138 
1139     /** ======= GLOBAL PARAMS ======= */
1140 
1141     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
1142     address public constant ZERO = address(0);
1143     address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1144 
1145     IUniswapV2Router02 public router;
1146     address public constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1147     address public pair;
1148 
1149     uint256 public cjp;
1150     mapping(uint256 => mapping(address => uint256)) public qb;
1151     mapping(uint256 => address[]) public qa;
1152 
1153     uint256 public jf;
1154     uint256 public cf;
1155     address public ch;
1156     uint256 public tfd;
1157 
1158     uint256 bm;
1159     uint256 bd;
1160 
1161     mapping (address => bool) untaxed; // cannot win jackpot
1162 
1163     bool public launched;
1164     uint256 public launchedAtBlock;
1165     uint256 public launchedAtTimestamp;
1166 
1167     address public poolBoy;
1168     bool public tradeable;
1169 
1170     bool public canSwapBack;
1171     uint256 public swapThreshold;
1172 
1173     address public addressRegistryAddress;
1174     IAddressRegistry addressRegistry;
1175 
1176     address public jackpotContractAddress;
1177     IJackpotContract jackpotContract;
1178 
1179     bool iS;
1180     bool rngomw;
1181 
1182     constructor(address addressRegistryAddress_)
1183         ERC20("Chance Token", "CHANCE") {
1184         _setAddressRegistry(addressRegistryAddress_);
1185         setAddresses();
1186         poolBoy = msg.sender;
1187 
1188         // 2% goes to jackpot;
1189         jf = 20;
1190         // 0.5% goes to funding Chainlink and operations
1191         cf = 5;
1192         tfd = 1000;
1193 
1194         bm = 1;
1195         bd = _totalSupply.div(100000); // 0.001% || 1000 tokens
1196 
1197         canSwapBack = true;
1198         swapThreshold = _totalSupply.div(100000); // 0.001%
1199 
1200         router = IUniswapV2Router02(routerAddress);
1201         pair = IUniswapV2Factory(router.factory()).createPair(address(this), WETH);
1202 
1203         _mint(ch, _totalSupply);
1204 
1205         launched = true;
1206         launchedAtBlock = block.number;
1207         launchedAtTimestamp = block.timestamp;
1208 
1209         // allowing router & pair to use all deployer's CHANCE's balanace
1210         approve(routerAddress, type(uint256).max);
1211         approve(pair, type(uint256).max);
1212         // allowing router & pair to use all CHANCE's own balanace
1213         _approve(address(this), routerAddress, type(uint256).max);
1214         _approve(address(this), pair, type(uint256).max);
1215     }
1216 
1217     /** ======= MODIFIER ======= */
1218 
1219     modifier s() {
1220         iS = true;
1221         _;
1222         iS = false;
1223     }
1224 
1225     modifier positive(uint256 _i) {
1226         require(_i > 0, "Must be positive");
1227         _;
1228     }
1229 
1230     /** ======= VIEW ======= */
1231 
1232     function getQa() public view returns (address[] memory) {
1233         return qa[cjp];
1234     }
1235 
1236     function getBm() public view returns (uint256) {
1237         return bm;
1238     }
1239 
1240     function getBd() public view returns (uint256) {
1241         return bd;
1242     }
1243 
1244     function getCirculatingSupply() public view returns (uint256) {
1245         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
1246     }
1247 
1248     function getBoughtAmount(address _p) public view returns (uint256) {
1249       return qb[cjp][_p].div(bd);
1250     }
1251 
1252     function getTaxRate(uint256 _jf, uint256 _cf, uint256 _tfd) public pure returns (uint256) {
1253         return ((_jf.add(_cf)).mul(100).div(_tfd));
1254     }
1255 
1256     function shouldWin() public view returns (bool) {
1257         if (countdown() == 0 && !rngomw && qa[cjp].length > 0 && getCurrentJackpotAmount() > 0) {
1258             return true;
1259         } else return false;
1260     }
1261 
1262     function _shouldTakeFee(address _sender, address _recipient) internal view returns (bool) {
1263         return !(untaxed[_sender] || untaxed[_recipient]) && (_sender == pair || _recipient == pair || _sender == routerAddress || _recipient == routerAddress);
1264     }
1265 
1266     function _shouldSwapBack() internal view returns (bool) {
1267         return msg.sender != pair && !iS && canSwapBack && _balances[address(this)] >= swapThreshold;
1268     }
1269 
1270     /** ======= JACKPOT INTERFACE ======= */
1271 
1272     function getCurrentJackpotAmount() public view returns (uint256) {
1273         return jackpotContract.getCurrentJackpotAmount();
1274     }
1275 
1276     function countdown() public view returns (uint256) {
1277         return jackpotContract.countdown();
1278     }
1279 
1280     /** ======= PUBLIC ======= */
1281 
1282     // Set the most recent addresses of the ecosystem
1283     function setAddresses() public {
1284         jackpotContractAddress = addressRegistry.getJackpotContractAddress();
1285         jackpotContract = IJackpotContract(jackpotContractAddress);
1286         ch = addressRegistry.getHandlerAddress();
1287         authorizations[ch] = true;
1288         untaxed[ch] = true;
1289         untaxed[addressRegistry.getTreasuryContractAddress()] = true;
1290     }
1291 
1292     /** ======= OWNER ======= */
1293 
1294     function setTaxed(address _a, bool _exempt) external onlyOwner {
1295         untaxed[_a] = _exempt;
1296     }
1297 
1298     // cannot be disabled
1299     function enableTrading() external onlyOwner {
1300         require(tradeable == false, "Already enabled");
1301         tradeable = true;
1302     }
1303 
1304     /** ======= AUTHORIZED ======= */
1305 
1306     // hard reset if there would be any unforeseen attack regarding Chainlink
1307     // current jackpot is postponed, previous jackpot logs deleted
1308     function resetJP() public authorized {
1309         for (uint256 i = 0; i <= cjp+1; i++){
1310             for(uint256 n = qa[i].length; n > 0; n--){
1311                 uint256 idx = n-1;
1312                 if(i == cjp){
1313                     qa[0].push(qa[i][idx]);
1314                     qb[0][qa[i][idx]] = qb[i][qa[i][idx]];
1315                 }
1316                 if(i == cjp+1){
1317                     qa[1].push(qa[i][idx]);
1318                     qb[1][qa[1][idx]] = qb[i][qa[i][idx]];
1319                 }
1320                 delete qb[i][qa[i][idx]];
1321                 qa[i].pop();
1322             }
1323         }
1324         cjp= 0;
1325     }
1326 
1327     // reset random block if there would be any unforeseen attack regarding Chainlink
1328     function disableRngomw() external authorized {
1329         rngomw = false;
1330     }
1331 
1332     function setPoolBoy(address _a) external authorized {
1333         poolBoy = _a; // Pinksale fairlaunch address only
1334     }
1335 
1336     function setJackpotFee(uint256 _jf, uint256 _cf, uint256 _tfd) external authorized {
1337         require(getTaxRate(_jf, _cf, _tfd) <= 5, "Tax cannot exceed 5%");
1338         jf = _jf;
1339         cf = _cf;
1340         tfd = _tfd;
1341     }
1342 
1343     function setBuyMultiplier (uint256 _a) external positive(_a) authorized {
1344         bm = _a;
1345     }
1346 
1347     function setBuyDivisor(uint256 _a) external positive(_a) authorized {
1348         bd = _a;
1349     }
1350 
1351     function setSwapBackSettings(bool _enabled, uint256 _a) external authorized {
1352         require(_a >= 10_000000000000000000
1353             && _a < getCirculatingSupply());
1354         canSwapBack = _enabled;
1355         swapThreshold = _a;
1356     }
1357 
1358     function updateAddressRegistry(address _registry) external {
1359         require(msg.sender == addressRegistry.getHandlerAddress(), "Only Handler");
1360         _setAddressRegistry(_registry);
1361     }
1362 
1363     /** ======= ERC-20 ======= */
1364 
1365     function approveMax(address spender) public returns (bool) {
1366         return approve(spender, type(uint256).max);
1367     }
1368 
1369     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1370         _balances[sender] = _balances[sender].sub(amount);
1371         _balances[recipient] = _balances[recipient].add(amount);
1372         return true;
1373     }
1374 
1375     function transfer(address recipient, uint256 amount) public override returns (bool) {
1376         return _transferFrom(msg.sender, recipient, amount);
1377     }
1378 
1379     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1380         if(_allowances[sender][msg.sender] != type(uint256).max){
1381             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount);
1382         }
1383         return _transferFrom(sender, recipient, amount);
1384     }
1385 
1386     function _transferFrom(address sender, address recipient, uint256 amount) internal  returns (bool) {
1387 
1388         if (shouldWin()) _callJackpot();
1389 
1390         if (iS) return _basicTransfer(sender, recipient, amount);
1391 
1392         bool isSell = recipient == pair || recipient == routerAddress;
1393         bool isBuy = sender == pair || sender == routerAddress;
1394 
1395         if ((tx.origin != ch  || tx.origin != poolBoy) && (isBuy || isSell)) require(tradeable, "Not started");
1396 
1397         uint256 _amountReceived = _shouldTakeFee(sender, recipient) ? _takeFee(sender, amount) : amount;
1398 
1399         if (isBuy) _qualify(recipient, amount);
1400 
1401         if (isSell && _shouldSwapBack()) _swapBack();
1402 
1403         _balances[sender] = _balances[sender].sub(amount);
1404         _balances[recipient] = _balances[recipient].add(_amountReceived);
1405         emit Transfer(sender, recipient, _amountReceived);
1406 
1407         return true;
1408     }
1409 
1410     /** ======= JACKPOT ======= */
1411 
1412     function onRequestFulfilled() external {
1413         require(msg.sender == jackpotContractAddress, "Must be jackpot");
1414         cjp = cjp.add(1);
1415         rngomw = false;
1416     }
1417 
1418     /** ======= INTERNAL ======= */
1419 
1420     function _takeFee(address _sender, uint256 _a) internal returns (uint256) {
1421         uint256 _jfa = _a.mul(jf).div(tfd);
1422         address _treasury = addressRegistry.getTreasuryContractAddress();
1423         _balances[address(this)] = _balances[address(this)].add(_jfa);
1424         emit Transfer(_sender, address(this), _jfa);
1425         uint256 _hfa = _a.mul(cf).div(tfd);
1426         _balances[_treasury] = _balances[_treasury].add(_hfa);
1427         emit Transfer(_sender, _treasury, _hfa);
1428         return _a.sub(_jfa).sub(_hfa);
1429     }
1430 
1431     function _swapBack() internal s {
1432         uint256 amountToSwap = _balances[address(this)];
1433 
1434         address[] memory path = new address[](2);
1435         path[0] = address(this);
1436         path[1] = WETH;
1437 
1438         uint256 amountOut = router.getAmountsOut(amountToSwap, path)[1];
1439         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1440             amountToSwap,
1441             amountOut,
1442             path,
1443             jackpotContractAddress,
1444             block.timestamp
1445         );
1446     }
1447 
1448     function _qualify(address _s, uint256 amount) internal {
1449 
1450         require(_s != ZERO && _s != DEAD);
1451         if ( _s == pair || _s == routerAddress || untaxed[_s]) return;
1452 
1453         uint256 jp = rngomw ? cjp+1 : cjp;
1454         if (qb[jp][_s] == 0) qa[jp].push(_s);
1455         qb[jp][_s] = qb[jp][_s].add(amount);
1456     }
1457 
1458     // Select a random winner for the jackpot
1459     function _callJackpot() internal {
1460         jackpotContract.requestRandomWords();
1461         rngomw = true;
1462     }
1463 
1464     function _setAddressRegistry(address _registry) internal {
1465         addressRegistryAddress = _registry;
1466         addressRegistry = IAddressRegistry(addressRegistryAddress);
1467     }
1468     // Make contract able to recive ETH
1469     receive() external payable {
1470         if (address(this).balance > 0) payable(ch).transfer(address(this).balance);
1471     }
1472 
1473     fallback() external payable {}
1474 
1475     // Good luck!
1476 
1477 }