1 // ███████╗░█████╗░██████╗░██████╗░███████╗██████╗░░░░███████╗██╗
2 // ╚════██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗░░░██╔════╝██║
3 // ░░███╔═╝███████║██████╔╝██████╔╝█████╗░░██████╔╝░░░█████╗░░██║
4 // ██╔══╝░░██╔══██║██╔═══╝░██╔═══╝░██╔══╝░░██╔══██╗░░░██╔══╝░░██║
5 // ███████╗██║░░██║██║░░░░░██║░░░░░███████╗██║░░██║██╗██║░░░░░██║
6 // ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝
7 // Copyright (C) 2020 zapper, nodar, suhail, seb, apoorv, sumit
8 
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU Affero General Public License as published by
11 // the Free Software Foundation, either version 2 of the License, or
12 // (at your option) any later version.
13 //
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU Affero General Public License for more details.
18 //
19 
20 ///@author Zapper
21 ///@notice this contract adds liquidity to Balancer liquidity pools in one transaction
22 
23 // File: @openzeppelin/contracts/utils/Address.sol
24 
25 pragma solidity ^0.5.5;
26 
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, reverting on
30      * overflow.
31      *
32      * Counterpart to Solidity's `+` operator.
33      *
34      * Requirements:
35      * - Addition cannot overflow.
36      */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, reverting on
46      * overflow (when the result is negative).
47      *
48      * Counterpart to Solidity's `-` operator.
49      *
50      * Requirements:
51      * - Subtraction cannot overflow.
52      */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      * - Subtraction cannot overflow.
65      *
66      * _Available since v2.4.0._
67      */
68     function sub(
69         uint256 a,
70         uint256 b,
71         string memory errorMessage
72     ) internal pure returns (uint256) {
73         require(b <= a, errorMessage);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the multiplication of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `*` operator.
84      *
85      * Requirements:
86      * - Multiplication cannot overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      * - The divisor cannot be zero.
127      *
128      * _Available since v2.4.0._
129      */
130     function div(
131         uint256 a,
132         uint256 b,
133         string memory errorMessage
134     ) internal pure returns (uint256) {
135         // Solidity only automatically asserts when dividing by 0
136         require(b > 0, errorMessage);
137         uint256 c = a / b;
138         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return mod(a, b, "SafeMath: modulo by zero");
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts with custom message when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      *
169      * _Available since v2.4.0._
170      */
171     function mod(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         require(b != 0, errorMessage);
177         return a % b;
178     }
179 }
180 
181 library Address {
182     /**
183      * @dev Returns true if `account` is a contract.
184      *
185      * [IMPORTANT]
186      * ====
187      * It is unsafe to assume that an address for which this function returns
188      * false is an externally-owned account (EOA) and not a contract.
189      *
190      * Among others, `isContract` will return false for the following
191      * types of addresses:
192      *
193      *  - an externally-owned account
194      *  - a contract in construction
195      *  - an address where a contract will be created
196      *  - an address where a contract lived, but was destroyed
197      * ====
198      */
199     function isContract(address account) internal view returns (bool) {
200         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
201         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
202         // for accounts without code, i.e. `keccak256('')`
203         bytes32 codehash;
204 
205 
206             bytes32 accountHash
207          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
208         // solhint-disable-next-line no-inline-assembly
209         assembly {
210             codehash := extcodehash(account)
211         }
212         return (codehash != accountHash && codehash != 0x0);
213     }
214 
215     /**
216      * @dev Converts an `address` into `address payable`. Note that this is
217      * simply a type cast: the actual underlying value is not changed.
218      *
219      * _Available since v2.4.0._
220      */
221     function toPayable(address account)
222         internal
223         pure
224         returns (address payable)
225     {
226         return address(uint160(account));
227     }
228 
229     /**
230      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
231      * `recipient`, forwarding all available gas and reverting on errors.
232      *
233      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
234      * of certain opcodes, possibly making contracts go over the 2300 gas limit
235      * imposed by `transfer`, making them unable to receive funds via
236      * `transfer`. {sendValue} removes this limitation.
237      *
238      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
239      *
240      * IMPORTANT: because control is transferred to `recipient`, care must be
241      * taken to not create reentrancy vulnerabilities. Consider using
242      * {ReentrancyGuard} or the
243      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
244      *
245      * _Available since v2.4.0._
246      */
247     function sendValue(address payable recipient, uint256 amount) internal {
248         require(
249             address(this).balance >= amount,
250             "Address: insufficient balance"
251         );
252 
253         // solhint-disable-next-line avoid-call-value
254         (bool success, ) = recipient.call.value(amount)("");
255         require(
256             success,
257             "Address: unable to send value, recipient may have reverted"
258         );
259     }
260 }
261 
262 interface IERC20 {
263     /**
264      * @dev Returns the amount of tokens in existence.
265      */
266     function totalSupply() external view returns (uint256);
267 
268     /**
269      * @dev Returns the amount of tokens owned by `account`.
270      */
271     function balanceOf(address account) external view returns (uint256);
272 
273     /**
274      * @dev Moves `amount` tokens from the caller's account to `recipient`.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transfer(address recipient, uint256 amount)
281         external
282         returns (bool);
283 
284     /**
285      * @dev Returns the remaining number of tokens that `spender` will be
286      * allowed to spend on behalf of `owner` through {transferFrom}. This is
287      * zero by default.
288      *
289      * This value changes when {approve} or {transferFrom} are called.
290      */
291     function allowance(address owner, address spender)
292         external
293         view
294         returns (uint256);
295 
296     /**
297      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
298      *
299      * Returns a boolean value indicating whether the operation succeeded.
300      *
301      * IMPORTANT: Beware that changing an allowance with this method brings the risk
302      * that someone may use both the old and the new allowance by unfortunate
303      * transaction ordering. One possible solution to mitigate this race
304      * condition is to first reduce the spender's allowance to 0 and set the
305      * desired value afterwards:
306      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
307      *
308      * Emits an {Approval} event.
309      */
310     function approve(address spender, uint256 amount) external returns (bool);
311 
312     /**
313      * @dev Moves `amount` tokens from `sender` to `recipient` using the
314      * allowance mechanism. `amount` is then deducted from the caller's
315      * allowance.
316      *
317      * Returns a boolean value indicating whether the operation succeeded.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transferFrom(
322         address sender,
323         address recipient,
324         uint256 amount
325     ) external returns (bool);
326 
327     /**
328      * @dev Emitted when `value` tokens are moved from one account (`from`) to
329      * another (`to`).
330      *
331      * Note that `value` may be zero.
332      */
333     event Transfer(address indexed from, address indexed to, uint256 value);
334 
335     /**
336      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
337      * a call to {approve}. `value` is the new allowance.
338      */
339     event Approval(
340         address indexed owner,
341         address indexed spender,
342         uint256 value
343     );
344 }
345 
346 library SafeERC20 {
347     using SafeMath for uint256;
348     using Address for address;
349 
350     function safeTransfer(
351         IERC20 token,
352         address to,
353         uint256 value
354     ) internal {
355         callOptionalReturn(
356             token,
357             abi.encodeWithSelector(token.transfer.selector, to, value)
358         );
359     }
360 
361     function safeTransferFrom(
362         IERC20 token,
363         address from,
364         address to,
365         uint256 value
366     ) internal {
367         callOptionalReturn(
368             token,
369             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
370         );
371     }
372 
373     function safeApprove(
374         IERC20 token,
375         address spender,
376         uint256 value
377     ) internal {
378         // safeApprove should only be called when setting an initial allowance,
379         // or when resetting it to zero. To increase and decrease it, use
380         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
381         // solhint-disable-next-line max-line-length
382         require(
383             (value == 0) || (token.allowance(address(this), spender) == 0),
384             "SafeERC20: approve from non-zero to non-zero allowance"
385         );
386         callOptionalReturn(
387             token,
388             abi.encodeWithSelector(token.approve.selector, spender, value)
389         );
390     }
391 
392     function safeIncreaseAllowance(
393         IERC20 token,
394         address spender,
395         uint256 value
396     ) internal {
397         uint256 newAllowance = token.allowance(address(this), spender).add(
398             value
399         );
400         callOptionalReturn(
401             token,
402             abi.encodeWithSelector(
403                 token.approve.selector,
404                 spender,
405                 newAllowance
406             )
407         );
408     }
409 
410     function safeDecreaseAllowance(
411         IERC20 token,
412         address spender,
413         uint256 value
414     ) internal {
415         uint256 newAllowance = token.allowance(address(this), spender).sub(
416             value,
417             "SafeERC20: decreased allowance below zero"
418         );
419         callOptionalReturn(
420             token,
421             abi.encodeWithSelector(
422                 token.approve.selector,
423                 spender,
424                 newAllowance
425             )
426         );
427     }
428 
429     /**
430      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
431      * on the return value: the return value is optional (but if data is returned, it must not be false).
432      * @param token The token targeted by the call.
433      * @param data The call data (encoded using abi.encode or one of its variants).
434      */
435     function callOptionalReturn(IERC20 token, bytes memory data) private {
436         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
437         // we're implementing it ourselves.
438 
439         // A Solidity high level call has three parts:
440         //  1. The target address is checked to verify it contains contract code
441         //  2. The call itself is made, and success asserted
442         //  3. The return value is decoded, which in turn checks the size of the returned data.
443         // solhint-disable-next-line max-line-length
444         require(address(token).isContract(), "SafeERC20: call to non-contract");
445 
446         // solhint-disable-next-line avoid-low-level-calls
447         (bool success, bytes memory returndata) = address(token).call(data);
448         require(success, "SafeERC20: low-level call failed");
449 
450         if (returndata.length > 0) {
451             // Return data is optional
452             // solhint-disable-next-line max-line-length
453             require(
454                 abi.decode(returndata, (bool)),
455                 "SafeERC20: ERC20 operation did not succeed"
456             );
457         }
458     }
459 }
460 
461 contract Context {
462     // Empty internal constructor, to prevent people from mistakenly deploying
463     // an instance of this contract, which should be used via inheritance.
464     constructor() internal {}
465 
466     // solhint-disable-previous-line no-empty-blocks
467 
468     function _msgSender() internal view returns (address payable) {
469         return msg.sender;
470     }
471 
472     function _msgData() internal view returns (bytes memory) {
473         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
474         return msg.data;
475     }
476 }
477 
478 contract Ownable is Context {
479     address private _owner;
480 
481     event OwnershipTransferred(
482         address indexed previousOwner,
483         address indexed newOwner
484     );
485 
486     /**
487      * @dev Initializes the contract setting the deployer as the initial owner.
488      */
489     constructor() internal {
490         address msgSender = _msgSender();
491         _owner = msgSender;
492         emit OwnershipTransferred(address(0), msgSender);
493     }
494 
495     /**
496      * @dev Returns the address of the current owner.
497      */
498     function owner() public view returns (address) {
499         return _owner;
500     }
501 
502     /**
503      * @dev Throws if called by any account other than the owner.
504      */
505     modifier onlyOwner() {
506         require(isOwner(), "Ownable: caller is not the owner");
507         _;
508     }
509 
510     /**
511      * @dev Returns true if the caller is the current owner.
512      */
513     function isOwner() public view returns (bool) {
514         return _msgSender() == _owner;
515     }
516 
517     /**
518      * @dev Leaves the contract without owner. It will not be possible to call
519      * `onlyOwner` functions anymore. Can only be called by the current owner.
520      *
521      * NOTE: Renouncing ownership will leave the contract without an owner,
522      * thereby removing any functionality that is only available to the owner.
523      */
524     function renounceOwnership() public onlyOwner {
525         emit OwnershipTransferred(_owner, address(0));
526         _owner = address(0);
527     }
528 
529     /**
530      * @dev Transfers ownership of the contract to a new account (`newOwner`).
531      * Can only be called by the current owner.
532      */
533     function transferOwnership(address newOwner) public onlyOwner {
534         _transferOwnership(newOwner);
535     }
536 
537     /**
538      * @dev Transfers ownership of the contract to a new account (`newOwner`).
539      */
540     function _transferOwnership(address newOwner) internal {
541         require(
542             newOwner != address(0),
543             "Ownable: new owner is the zero address"
544         );
545         emit OwnershipTransferred(_owner, newOwner);
546         _owner = newOwner;
547     }
548 }
549 
550 contract ReentrancyGuard {
551     bool private _notEntered;
552 
553     constructor() internal {
554         // Storing an initial non-zero value makes deployment a bit more
555         // expensive, but in exchange the refund on every call to nonReentrant
556         // will be lower in amount. Since refunds are capped to a percetange of
557         // the total transaction's gas, it is best to keep them low in cases
558         // like this one, to increase the likelihood of the full refund coming
559         // into effect.
560         _notEntered = true;
561     }
562 
563     /**
564      * @dev Prevents a contract from calling itself, directly or indirectly.
565      * Calling a `nonReentrant` function from another `nonReentrant`
566      * function is not supported. It is possible to prevent this from happening
567      * by making the `nonReentrant` function external, and make it call a
568      * `private` function that does the actual work.
569      */
570     modifier nonReentrant() {
571         // On the first call to nonReentrant, _notEntered will be true
572         require(_notEntered, "ReentrancyGuard: reentrant call");
573 
574         // Any calls to nonReentrant after this point will fail
575         _notEntered = false;
576 
577         _;
578 
579         // By storing the original value once again, a refund is triggered (see
580         // https://eips.ethereum.org/EIPS/eip-2200)
581         _notEntered = true;
582     }
583 }
584 
585 interface IBFactory {
586     function isBPool(address b) external view returns (bool);
587 }
588 
589 interface IBPool {
590     function joinswapExternAmountIn(
591         address tokenIn,
592         uint256 tokenAmountIn,
593         uint256 minPoolAmountOut
594     ) external payable returns (uint256 poolAmountOut);
595 
596     function isBound(address t) external view returns (bool);
597 
598     function getFinalTokens() external view returns (address[] memory tokens);
599 
600     function totalSupply() external view returns (uint256);
601 
602     function getDenormalizedWeight(address token)
603         external
604         view
605         returns (uint256);
606 
607     function getTotalDenormalizedWeight() external view returns (uint256);
608 
609     function getSwapFee() external view returns (uint256);
610 
611     function calcPoolOutGivenSingleIn(
612         uint256 tokenBalanceIn,
613         uint256 tokenWeightIn,
614         uint256 poolSupply,
615         uint256 totalWeight,
616         uint256 tokenAmountIn,
617         uint256 swapFee
618     ) external pure returns (uint256 poolAmountOut);
619 
620     function getBalance(address token) external view returns (uint256);
621 }
622 
623 interface IWETH {
624     function deposit() external payable;
625 
626     function transfer(address to, uint256 value) external returns (bool);
627 
628     function withdraw(uint256) external;
629 }
630 
631 interface IUniswapV2Factory {
632     function getPair(address tokenA, address tokenB)
633         external
634         view
635         returns (address);
636 }
637 
638 interface IUniswapRouter02 {
639     //get estimated amountOut
640     function getAmountsOut(uint256 amountIn, address[] calldata path)
641         external
642         view
643         returns (uint256[] memory amounts);
644 
645     function getAmountsIn(uint256 amountOut, address[] calldata path)
646         external
647         view
648         returns (uint256[] memory amounts);
649 
650     //token 2 token
651     function swapExactTokensForTokens(
652         uint256 amountIn,
653         uint256 amountOutMin,
654         address[] calldata path,
655         address to,
656         uint256 deadline
657     ) external returns (uint256[] memory amounts);
658 
659     function swapTokensForExactTokens(
660         uint256 amountOut,
661         uint256 amountInMax,
662         address[] calldata path,
663         address to,
664         uint256 deadline
665     ) external returns (uint256[] memory amounts);
666 
667     //eth 2 token
668     function swapExactETHForTokens(
669         uint256 amountOutMin,
670         address[] calldata path,
671         address to,
672         uint256 deadline
673     ) external payable returns (uint256[] memory amounts);
674 
675     function swapETHForExactTokens(
676         uint256 amountOut,
677         address[] calldata path,
678         address to,
679         uint256 deadline
680     ) external payable returns (uint256[] memory amounts);
681 
682     //token 2 eth
683     function swapTokensForExactETH(
684         uint256 amountOut,
685         uint256 amountInMax,
686         address[] calldata path,
687         address to,
688         uint256 deadline
689     ) external returns (uint256[] memory amounts);
690 
691     function swapExactTokensForETH(
692         uint256 amountIn,
693         uint256 amountOutMin,
694         address[] calldata path,
695         address to,
696         uint256 deadline
697     ) external returns (uint256[] memory amounts);
698 }
699 
700 contract Balancer_ZapIn_General_V2_6 is ReentrancyGuard, Ownable {
701     using SafeMath for uint256;
702     using Address for address;
703     using SafeERC20 for IERC20;
704     bool public stopped = false;
705     uint16 public goodwill;
706 
707     IBFactory BalancerFactory = IBFactory(
708         0x9424B1412450D0f8Fc2255FAf6046b98213B76Bd
709     );
710     IUniswapV2Factory
711         private constant UniSwapV2FactoryAddress = IUniswapV2Factory(
712         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
713     );
714     IUniswapRouter02 private constant uniswapRouter = IUniswapRouter02(
715         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
716     );
717 
718     address
719         private constant wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
720     address payable
721         public zgoodwillAddress = 0xE737b6AfEC2320f616297e59445b60a11e3eF75F;
722 
723     uint256
724         private constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000;
725 
726     event zap(
727         address zapContract,
728         address userAddress,
729         address tokenAddress,
730         uint256 volume,
731         uint256 timestamp
732     );
733 
734     constructor(uint16 _goodwill) public {
735         goodwill = _goodwill;
736     }
737 
738     // circuit breaker modifiers
739     modifier stopInEmergency {
740         if (stopped) {
741             revert("Temporarily Paused");
742         } else {
743             _;
744         }
745     }
746 
747     /**
748     @notice This function is used to invest in given balancer pool through ETH/ERC20 Tokens
749     @param _FromTokenContractAddress The token used for investment (address(0x00) if ether)
750     @param _ToBalancerPoolAddress The address of balancer pool to zapin
751     @param _amount The amount of ERC to invest
752     @param _minPoolTokens for slippage
753     @return success or failure
754      */
755     function ZapIn(
756         address _FromTokenContractAddress,
757         address _ToBalancerPoolAddress,
758         uint256 _amount,
759         uint256 _minPoolTokens
760     )
761         public
762         payable
763         nonReentrant
764         stopInEmergency
765         returns (uint256 tokensBought)
766     {
767         require(
768             BalancerFactory.isBPool(_ToBalancerPoolAddress),
769             "Invalid Balancer Pool"
770         );
771 
772         emit zap(
773             address(this),
774             msg.sender,
775             _FromTokenContractAddress,
776             _amount,
777             now
778         );
779 
780         if (_FromTokenContractAddress == address(0)) {
781             require(msg.value > 0, "ERR: No ETH sent");
782 
783             //transfer eth to goodwill
784             uint256 goodwillPortion = _transferGoodwill(address(0), msg.value);
785 
786             address _IntermediateToken = _getBestDeal(
787                 _ToBalancerPoolAddress,
788                 msg.value,
789                 _FromTokenContractAddress
790             );
791 
792             tokensBought = _performZapIn(
793                 msg.sender,
794                 _FromTokenContractAddress,
795                 _ToBalancerPoolAddress,
796                 msg.value.sub(goodwillPortion),
797                 _IntermediateToken,
798                 _minPoolTokens
799             );
800 
801             return tokensBought;
802         }
803 
804         require(_amount > 0, "ERR: No ERC sent");
805         require(msg.value == 0, "ERR: ETH sent with tokens");
806 
807         //transfer tokens to contract
808         IERC20(_FromTokenContractAddress).safeTransferFrom(
809             msg.sender,
810             address(this),
811             _amount
812         );
813 
814         //send tokens to goodwill
815         uint256 goodwillPortion = _transferGoodwill(
816             _FromTokenContractAddress,
817             _amount
818         );
819 
820         address _IntermediateToken = _getBestDeal(
821             _ToBalancerPoolAddress,
822             _amount,
823             _FromTokenContractAddress
824         );
825 
826         tokensBought = _performZapIn(
827             msg.sender,
828             _FromTokenContractAddress,
829             _ToBalancerPoolAddress,
830             _amount.sub(goodwillPortion),
831             _IntermediateToken,
832             _minPoolTokens
833         );
834     }
835 
836     /**
837     @notice This function internally called by ZapIn() and EasyZapIn()
838     @param _toWhomToIssue The user address who want to invest
839     @param _FromTokenContractAddress The token used for investment (address(0x00) if ether)
840     @param _ToBalancerPoolAddress The address of balancer pool to zapin
841     @param _amount The amount of ETH/ERC to invest
842     @param _IntermediateToken The token for intermediate conversion before zapin
843     @param _minPoolTokens for slippage
844     @return The quantity of Balancer Pool tokens returned
845      */
846     function _performZapIn(
847         address _toWhomToIssue,
848         address _FromTokenContractAddress,
849         address _ToBalancerPoolAddress,
850         uint256 _amount,
851         address _IntermediateToken,
852         uint256 _minPoolTokens
853     ) internal returns (uint256 tokensBought) {
854         // check if isBound()
855         bool isBound = IBPool(_ToBalancerPoolAddress).isBound(
856             _FromTokenContractAddress
857         );
858 
859         uint256 balancerTokens;
860 
861         if (isBound) {
862             balancerTokens = _enter2Balancer(
863                 _ToBalancerPoolAddress,
864                 _FromTokenContractAddress,
865                 _amount,
866                 _minPoolTokens
867             );
868         } else {
869             // swap tokens or eth
870             uint256 tokenBought;
871             if (_FromTokenContractAddress == address(0)) {
872                 tokenBought = _eth2Token(_amount, _IntermediateToken);
873             } else {
874                 tokenBought = _token2Token(
875                     _FromTokenContractAddress,
876                     _IntermediateToken,
877                     _amount
878                 );
879             }
880 
881             //get BPT
882             balancerTokens = _enter2Balancer(
883                 _ToBalancerPoolAddress,
884                 _IntermediateToken,
885                 tokenBought,
886                 _minPoolTokens
887             );
888         }
889 
890         //transfer tokens to user
891         IERC20(_ToBalancerPoolAddress).safeTransfer(
892             _toWhomToIssue,
893             balancerTokens
894         );
895         return balancerTokens;
896     }
897 
898     /**
899     @notice This function is used to zapin to balancer pool
900     @param _ToBalancerPoolAddress The address of balancer pool to zap in
901     @param _FromTokenContractAddress The token used to zap in
902     @param tokens2Trade The amount of tokens to invest
903     @return The quantity of Balancer Pool tokens returned
904      */
905     function _enter2Balancer(
906         address _ToBalancerPoolAddress,
907         address _FromTokenContractAddress,
908         uint256 tokens2Trade,
909         uint256 _minPoolTokens
910     ) internal returns (uint256 poolTokensOut) {
911         require(
912             IBPool(_ToBalancerPoolAddress).isBound(_FromTokenContractAddress),
913             "Token not bound"
914         );
915 
916         uint256 allowance = IERC20(_FromTokenContractAddress).allowance(
917             address(this),
918             _ToBalancerPoolAddress
919         );
920 
921         if (allowance < tokens2Trade) {
922             IERC20(_FromTokenContractAddress).safeApprove(
923                 _ToBalancerPoolAddress,
924                 uint256(-1)
925             );
926         }
927 
928         poolTokensOut = IBPool(_ToBalancerPoolAddress).joinswapExternAmountIn(
929             _FromTokenContractAddress,
930             tokens2Trade,
931             _minPoolTokens
932         );
933 
934         require(poolTokensOut > 0, "Error in entering balancer pool");
935     }
936 
937     /**
938     @notice This function finds best token from the final tokens of balancer pool
939     @param _ToBalancerPoolAddress The address of balancer pool to zap in
940     @param _amount amount of eth/erc to invest
941     @param _FromTokenContractAddress the token address which is used to invest
942     @return The token address having max liquidity
943      */
944     function _getBestDeal(
945         address _ToBalancerPoolAddress,
946         uint256 _amount,
947         address _FromTokenContractAddress
948     ) internal view returns (address _token) {
949         // If input is not eth or weth
950         if (
951             _FromTokenContractAddress != address(0) &&
952             _FromTokenContractAddress != wethTokenAddress
953         ) {
954             // check if input token or weth is bound and if so return it as intermediate
955             bool isBound = IBPool(_ToBalancerPoolAddress).isBound(
956                 _FromTokenContractAddress
957             );
958             if (isBound) return _FromTokenContractAddress;
959         }
960 
961         bool wethIsBound = IBPool(_ToBalancerPoolAddress).isBound(
962             wethTokenAddress
963         );
964         if (wethIsBound) return wethTokenAddress;
965 
966         //get token list
967         address[] memory tokens = IBPool(_ToBalancerPoolAddress)
968             .getFinalTokens();
969 
970         uint256 amount = _amount;
971         address[] memory path = new address[](2);
972 
973         if (
974             _FromTokenContractAddress != address(0) &&
975             _FromTokenContractAddress != wethTokenAddress
976         ) {
977             path[0] = _FromTokenContractAddress;
978             path[1] = wethTokenAddress;
979             //get eth value for given token
980             amount = uniswapRouter.getAmountsOut(_amount, path)[1];
981         }
982 
983         uint256 maxBPT;
984         path[0] = wethTokenAddress;
985 
986         for (uint256 index = 0; index < tokens.length; index++) {
987             uint256 expectedBPT;
988 
989             if (tokens[index] != wethTokenAddress) {
990                 if (
991                     UniSwapV2FactoryAddress.getPair(
992                         tokens[index],
993                         wethTokenAddress
994                     ) == address(0)
995                 ) {
996                     continue;
997                 }
998 
999                 //get qty of tokens
1000                 path[1] = tokens[index];
1001                 uint256 expectedTokens = uniswapRouter.getAmountsOut(
1002                     amount,
1003                     path
1004                 )[1];
1005 
1006                 //get bpt for given tokens
1007                 expectedBPT = getToken2BPT(
1008                     _ToBalancerPoolAddress,
1009                     expectedTokens,
1010                     tokens[index]
1011                 );
1012 
1013                 //get token giving max BPT
1014                 if (maxBPT < expectedBPT) {
1015                     maxBPT = expectedBPT;
1016                     _token = tokens[index];
1017                 }
1018             } else {
1019                 //get bpt for given weth tokens
1020                 expectedBPT = getToken2BPT(
1021                     _ToBalancerPoolAddress,
1022                     amount,
1023                     tokens[index]
1024                 );
1025             }
1026 
1027             //get token giving max BPT
1028             if (maxBPT < expectedBPT) {
1029                 maxBPT = expectedBPT;
1030                 _token = tokens[index];
1031             }
1032         }
1033     }
1034 
1035     /**
1036     @notice Function gives the expected amount of pool tokens on investing
1037     @param _ToBalancerPoolAddress Address of balancer pool to zapin
1038     @param _IncomingERC The amount of ERC to invest
1039     @param _FromToken Address of token to zap in with
1040     @return Amount of BPT token
1041      */
1042     function getToken2BPT(
1043         address _ToBalancerPoolAddress,
1044         uint256 _IncomingERC,
1045         address _FromToken
1046     ) internal view returns (uint256 tokensReturned) {
1047         uint256 totalSupply = IBPool(_ToBalancerPoolAddress).totalSupply();
1048         uint256 swapFee = IBPool(_ToBalancerPoolAddress).getSwapFee();
1049         uint256 totalWeight = IBPool(_ToBalancerPoolAddress)
1050             .getTotalDenormalizedWeight();
1051         uint256 balance = IBPool(_ToBalancerPoolAddress).getBalance(_FromToken);
1052         uint256 denorm = IBPool(_ToBalancerPoolAddress).getDenormalizedWeight(
1053             _FromToken
1054         );
1055 
1056         tokensReturned = IBPool(_ToBalancerPoolAddress)
1057             .calcPoolOutGivenSingleIn(
1058             balance,
1059             denorm,
1060             totalSupply,
1061             totalWeight,
1062             _IncomingERC,
1063             swapFee
1064         );
1065     }
1066 
1067     /**
1068     @notice This function is used to buy tokens from eth
1069     @param _tokenContractAddress Token address which we want to buy
1070     @return The quantity of token bought
1071      */
1072 
1073     function _eth2Token(uint256 _ethAmt, address _tokenContractAddress)
1074         internal
1075         returns (uint256 tokenBought)
1076     {
1077         if (_tokenContractAddress == wethTokenAddress) {
1078             IWETH(wethTokenAddress).deposit.value(_ethAmt)();
1079             return _ethAmt;
1080         }
1081 
1082         address[] memory path = new address[](2);
1083         path[0] = wethTokenAddress;
1084         path[1] = _tokenContractAddress;
1085         tokenBought = uniswapRouter.swapExactETHForTokens.value(_ethAmt)(
1086             1,
1087             path,
1088             address(this),
1089             deadline
1090         )[path.length - 1];
1091     }
1092 
1093     /**
1094     @notice This function is used to swap tokens
1095     @param _FromTokenContractAddress The token address to swap from
1096     @param _ToTokenContractAddress The token address to swap to
1097     @param tokens2Trade The amount of tokens to swap
1098     @return The quantity of tokens bought
1099      */
1100     function _token2Token(
1101         address _FromTokenContractAddress,
1102         address _ToTokenContractAddress,
1103         uint256 tokens2Trade
1104     ) internal returns (uint256 tokenBought) {
1105         IERC20(_FromTokenContractAddress).safeApprove(
1106             address(uniswapRouter),
1107             tokens2Trade
1108         );
1109 
1110         if (_FromTokenContractAddress != wethTokenAddress) {
1111             if (_ToTokenContractAddress != wethTokenAddress) {
1112                 address[] memory path = new address[](3);
1113                 path[0] = _FromTokenContractAddress;
1114                 path[1] = wethTokenAddress;
1115                 path[2] = _ToTokenContractAddress;
1116                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1117                     tokens2Trade,
1118                     1,
1119                     path,
1120                     address(this),
1121                     deadline
1122                 )[path.length - 1];
1123             } else {
1124                 address[] memory path = new address[](2);
1125                 path[0] = _FromTokenContractAddress;
1126                 path[1] = wethTokenAddress;
1127 
1128                 tokenBought = uniswapRouter.swapExactTokensForTokens(
1129                     tokens2Trade,
1130                     1,
1131                     path,
1132                     address(this),
1133                     deadline
1134                 )[path.length - 1];
1135             }
1136         } else {
1137             address[] memory path = new address[](2);
1138             path[0] = wethTokenAddress;
1139             path[1] = _ToTokenContractAddress;
1140             tokenBought = uniswapRouter.swapExactTokensForTokens(
1141                 tokens2Trade,
1142                 1,
1143                 path,
1144                 address(this),
1145                 deadline
1146             )[path.length - 1];
1147         }
1148 
1149         require(tokenBought > 0, "Error in swapping ERC: 1");
1150     }
1151 
1152     /**
1153     @notice This function is used to calculate and transfer goodwill
1154     @param _tokenContractAddress Token in which goodwill is deducted
1155     @param tokens2Trade The total amount of tokens to be zapped in
1156     @return The quantity of goodwill deducted
1157      */
1158 
1159     function _transferGoodwill(
1160         address _tokenContractAddress,
1161         uint256 tokens2Trade
1162     ) internal returns (uint256 goodwillPortion) {
1163         goodwillPortion = SafeMath.div(
1164             SafeMath.mul(tokens2Trade, goodwill),
1165             10000
1166         );
1167 
1168         if (goodwillPortion == 0) {
1169             return 0;
1170         }
1171 
1172         if (_tokenContractAddress == address(0)) {
1173             Address.sendValue(zgoodwillAddress, goodwillPortion);
1174         } else {
1175             IERC20(_tokenContractAddress).safeTransfer(
1176                 zgoodwillAddress,
1177                 goodwillPortion
1178             );
1179         }
1180     }
1181 
1182     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1183         require(
1184             _new_goodwill >= 0 && _new_goodwill < 10000,
1185             "GoodWill Value not allowed"
1186         );
1187         goodwill = _new_goodwill;
1188     }
1189 
1190     function set_new_zgoodwillAddress(address payable _new_zgoodwillAddress)
1191         public
1192         onlyOwner
1193     {
1194         zgoodwillAddress = _new_zgoodwillAddress;
1195     }
1196 
1197     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1198         uint256 qty = _TokenAddress.balanceOf(address(this));
1199         IERC20(address(_TokenAddress)).safeTransfer(owner(), qty);
1200     }
1201 
1202     // - to Pause the contract
1203     function toggleContractActive() public onlyOwner {
1204         stopped = !stopped;
1205     }
1206 
1207     // - to withdraw any ETH balance sitting in the contract
1208     function withdraw() public onlyOwner {
1209         uint256 contractBalance = address(this).balance;
1210         address payable _to = owner().toPayable();
1211         _to.transfer(contractBalance);
1212     }
1213 
1214     function() external payable {}
1215 }