1 // File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * > Note: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: openzeppelin-solidity-2.3.0/contracts/token/ERC20/IERC20.sol
80 
81 pragma solidity ^0.5.0;
82 
83 /**
84  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
85  * the optional functions; to access them see `ERC20Detailed`.
86  */
87 interface IERC20 {
88     /**
89      * @dev Returns the amount of tokens in existence.
90      */
91     function totalSupply() external view returns (uint256);
92 
93     /**
94      * @dev Returns the amount of tokens owned by `account`.
95      */
96     function balanceOf(address account) external view returns (uint256);
97 
98     /**
99      * @dev Moves `amount` tokens from the caller's account to `recipient`.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a `Transfer` event.
104      */
105     function transfer(address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Returns the remaining number of tokens that `spender` will be
109      * allowed to spend on behalf of `owner` through `transferFrom`. This is
110      * zero by default.
111      *
112      * This value changes when `approve` or `transferFrom` are called.
113      */
114     function allowance(address owner, address spender) external view returns (uint256);
115 
116     /**
117      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * > Beware that changing an allowance with this method brings the risk
122      * that someone may use both the old and the new allowance by unfortunate
123      * transaction ordering. One possible solution to mitigate this race
124      * condition is to first reduce the spender's allowance to 0 and set the
125      * desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      *
128      * Emits an `Approval` event.
129      */
130     function approve(address spender, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Moves `amount` tokens from `sender` to `recipient` using the
134      * allowance mechanism. `amount` is then deducted from the caller's
135      * allowance.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a `Transfer` event.
140      */
141     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Emitted when `value` tokens are moved from one account (`from`) to
145      * another (`to`).
146      *
147      * Note that `value` may be zero.
148      */
149     event Transfer(address indexed from, address indexed to, uint256 value);
150 
151     /**
152      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
153      * a call to `approve`. `value` is the new allowance.
154      */
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 // File: @uniswap/v2-core/contracts/libraries/Math.sol
159 
160 pragma solidity =0.5.16;
161 
162 // a library for performing various math operations
163 
164 library Math {
165     function min(uint x, uint y) internal pure returns (uint z) {
166         z = x < y ? x : y;
167     }
168 
169     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
170     function sqrt(uint y) internal pure returns (uint z) {
171         if (y > 3) {
172             z = y;
173             uint x = y / 2 + 1;
174             while (x < z) {
175                 z = x;
176                 x = (y / x + x) / 2;
177             }
178         } else if (y != 0) {
179             z = 1;
180         }
181     }
182 }
183 
184 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
185 
186 pragma solidity >=0.5.0;
187 
188 interface IUniswapV2Pair {
189     event Approval(address indexed owner, address indexed spender, uint value);
190     event Transfer(address indexed from, address indexed to, uint value);
191 
192     function name() external pure returns (string memory);
193     function symbol() external pure returns (string memory);
194     function decimals() external pure returns (uint8);
195     function totalSupply() external view returns (uint);
196     function balanceOf(address owner) external view returns (uint);
197     function allowance(address owner, address spender) external view returns (uint);
198 
199     function approve(address spender, uint value) external returns (bool);
200     function transfer(address to, uint value) external returns (bool);
201     function transferFrom(address from, address to, uint value) external returns (bool);
202 
203     function DOMAIN_SEPARATOR() external view returns (bytes32);
204     function PERMIT_TYPEHASH() external pure returns (bytes32);
205     function nonces(address owner) external view returns (uint);
206 
207     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
208 
209     event Mint(address indexed sender, uint amount0, uint amount1);
210     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
211     event Swap(
212         address indexed sender,
213         uint amount0In,
214         uint amount1In,
215         uint amount0Out,
216         uint amount1Out,
217         address indexed to
218     );
219     event Sync(uint112 reserve0, uint112 reserve1);
220 
221     function MINIMUM_LIQUIDITY() external pure returns (uint);
222     function factory() external view returns (address);
223     function token0() external view returns (address);
224     function token1() external view returns (address);
225     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
226     function price0CumulativeLast() external view returns (uint);
227     function price1CumulativeLast() external view returns (uint);
228     function kLast() external view returns (uint);
229 
230     function mint(address to) external returns (uint liquidity);
231     function burn(address to) external returns (uint amount0, uint amount1);
232     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
233     function skim(address to) external;
234     function sync() external;
235 
236     function initialize(address, address) external;
237 }
238 
239 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
240 
241 pragma solidity >=0.5.0;
242 
243 interface IUniswapV2Factory {
244     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
245 
246     function feeTo() external view returns (address);
247     function feeToSetter() external view returns (address);
248 
249     function getPair(address tokenA, address tokenB) external view returns (address pair);
250     function allPairs(uint) external view returns (address pair);
251     function allPairsLength() external view returns (uint);
252 
253     function createPair(address tokenA, address tokenB) external returns (address pair);
254 
255     function setFeeTo(address) external;
256     function setFeeToSetter(address) external;
257 }
258 
259 // File: openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol
260 
261 pragma solidity ^0.5.0;
262 
263 /**
264  * @dev Wrappers over Solidity's arithmetic operations with added overflow
265  * checks.
266  *
267  * Arithmetic operations in Solidity wrap on overflow. This can easily result
268  * in bugs, because programmers usually assume that an overflow raises an
269  * error, which is the standard behavior in high level programming languages.
270  * `SafeMath` restores this intuition by reverting the transaction when an
271  * operation overflows.
272  *
273  * Using this library instead of the unchecked operations eliminates an entire
274  * class of bugs, so it's recommended to use it always.
275  */
276 library SafeMath {
277     /**
278      * @dev Returns the addition of two unsigned integers, reverting on
279      * overflow.
280      *
281      * Counterpart to Solidity's `+` operator.
282      *
283      * Requirements:
284      * - Addition cannot overflow.
285      */
286     function add(uint256 a, uint256 b) internal pure returns (uint256) {
287         uint256 c = a + b;
288         require(c >= a, "SafeMath: addition overflow");
289 
290         return c;
291     }
292 
293     /**
294      * @dev Returns the subtraction of two unsigned integers, reverting on
295      * overflow (when the result is negative).
296      *
297      * Counterpart to Solidity's `-` operator.
298      *
299      * Requirements:
300      * - Subtraction cannot overflow.
301      */
302     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
303         require(b <= a, "SafeMath: subtraction overflow");
304         uint256 c = a - b;
305 
306         return c;
307     }
308 
309     /**
310      * @dev Returns the multiplication of two unsigned integers, reverting on
311      * overflow.
312      *
313      * Counterpart to Solidity's `*` operator.
314      *
315      * Requirements:
316      * - Multiplication cannot overflow.
317      */
318     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
319         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
320         // benefit is lost if 'b' is also tested.
321         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
322         if (a == 0) {
323             return 0;
324         }
325 
326         uint256 c = a * b;
327         require(c / a == b, "SafeMath: multiplication overflow");
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the integer division of two unsigned integers. Reverts on
334      * division by zero. The result is rounded towards zero.
335      *
336      * Counterpart to Solidity's `/` operator. Note: this function uses a
337      * `revert` opcode (which leaves remaining gas untouched) while Solidity
338      * uses an invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      * - The divisor cannot be zero.
342      */
343     function div(uint256 a, uint256 b) internal pure returns (uint256) {
344         // Solidity only automatically asserts when dividing by 0
345         require(b > 0, "SafeMath: division by zero");
346         uint256 c = a / b;
347         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
348 
349         return c;
350     }
351 
352     /**
353      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
354      * Reverts when dividing by zero.
355      *
356      * Counterpart to Solidity's `%` operator. This function uses a `revert`
357      * opcode (which leaves remaining gas untouched) while Solidity uses an
358      * invalid opcode to revert (consuming all remaining gas).
359      *
360      * Requirements:
361      * - The divisor cannot be zero.
362      */
363     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
364         require(b != 0, "SafeMath: modulo by zero");
365         return a % b;
366     }
367 }
368 
369 
370 // File: contracts/5/uniswap/IUniswapV2Router02.sol
371 
372 pragma solidity >=0.5.0;
373 
374 interface IUniswapV2Router02 {
375     function factory() external pure returns (address);
376 
377     function WETH() external pure returns (address);
378 
379     function addLiquidity(
380         address tokenA,
381         address tokenB,
382         uint256 amountADesired,
383         uint256 amountBDesired,
384         uint256 amountAMin,
385         uint256 amountBMin,
386         address to,
387         uint256 deadline
388     )
389         external
390         returns (
391             uint256 amountA,
392             uint256 amountB,
393             uint256 liquidity
394         );
395 
396     function addLiquidityETH(
397         address token,
398         uint256 amountTokenDesired,
399         uint256 amountTokenMin,
400         uint256 amountETHMin,
401         address to,
402         uint256 deadline
403     )
404         external
405         payable
406         returns (
407             uint256 amountToken,
408             uint256 amountETH,
409             uint256 liquidity
410         );
411 
412     function removeLiquidity(
413         address tokenA,
414         address tokenB,
415         uint256 liquidity,
416         uint256 amountAMin,
417         uint256 amountBMin,
418         address to,
419         uint256 deadline
420     ) external returns (uint256 amountA, uint256 amountB);
421 
422     function removeLiquidityETH(
423         address token,
424         uint256 liquidity,
425         uint256 amountTokenMin,
426         uint256 amountETHMin,
427         address to,
428         uint256 deadline
429     ) external returns (uint256 amountToken, uint256 amountETH);
430 
431     function removeLiquidityWithPermit(
432         address tokenA,
433         address tokenB,
434         uint256 liquidity,
435         uint256 amountAMin,
436         uint256 amountBMin,
437         address to,
438         uint256 deadline,
439         bool approveMax,
440         uint8 v,
441         bytes32 r,
442         bytes32 s
443     ) external returns (uint256 amountA, uint256 amountB);
444 
445     function removeLiquidityETHWithPermit(
446         address token,
447         uint256 liquidity,
448         uint256 amountTokenMin,
449         uint256 amountETHMin,
450         address to,
451         uint256 deadline,
452         bool approveMax,
453         uint8 v,
454         bytes32 r,
455         bytes32 s
456     ) external returns (uint256 amountToken, uint256 amountETH);
457 
458     function swapExactTokensForTokens(
459         uint256 amountIn,
460         uint256 amountOutMin,
461         address[] calldata path,
462         address to,
463         uint256 deadline
464     ) external returns (uint256[] memory amounts);
465 
466     function swapTokensForExactTokens(
467         uint256 amountOut,
468         uint256 amountInMax,
469         address[] calldata path,
470         address to,
471         uint256 deadline
472     ) external returns (uint256[] memory amounts);
473 
474     function swapExactETHForTokens(
475         uint256 amountOutMin,
476         address[] calldata path,
477         address to,
478         uint256 deadline
479     ) external payable returns (uint256[] memory amounts);
480 
481     function swapTokensForExactETH(
482         uint256 amountOut,
483         uint256 amountInMax,
484         address[] calldata path,
485         address to,
486         uint256 deadline
487     ) external returns (uint256[] memory amounts);
488 
489     function swapExactTokensForETH(
490         uint256 amountIn,
491         uint256 amountOutMin,
492         address[] calldata path,
493         address to,
494         uint256 deadline
495     ) external returns (uint256[] memory amounts);
496 
497     function swapETHForExactTokens(
498         uint256 amountOut,
499         address[] calldata path,
500         address to,
501         uint256 deadline
502     ) external payable returns (uint256[] memory amounts);
503 
504     function quote(
505         uint256 amountA,
506         uint256 reserveA,
507         uint256 reserveB
508     ) external pure returns (uint256 amountB);
509 
510     function getAmountOut(
511         uint256 amountIn,
512         uint256 reserveIn,
513         uint256 reserveOut
514     ) external pure returns (uint256 amountOut);
515 
516     function getAmountIn(
517         uint256 amountOut,
518         uint256 reserveIn,
519         uint256 reserveOut
520     ) external pure returns (uint256 amountIn);
521 
522     function getAmountsOut(uint256 amountIn, address[] calldata path)
523         external
524         view
525         returns (uint256[] memory amounts);
526 
527     function getAmountsIn(uint256 amountOut, address[] calldata path)
528         external
529         view
530         returns (uint256[] memory amounts);
531 
532     function removeLiquidityETHSupportingFeeOnTransferTokens(
533         address token,
534         uint256 liquidity,
535         uint256 amountTokenMin,
536         uint256 amountETHMin,
537         address to,
538         uint256 deadline
539     ) external returns (uint256 amountETH);
540 
541     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
542         address token,
543         uint256 liquidity,
544         uint256 amountTokenMin,
545         uint256 amountETHMin,
546         address to,
547         uint256 deadline,
548         bool approveMax,
549         uint8 v,
550         bytes32 r,
551         bytes32 s
552     ) external returns (uint256 amountETH);
553 
554     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
555         uint256 amountIn,
556         uint256 amountOutMin,
557         address[] calldata path,
558         address to,
559         uint256 deadline
560     ) external;
561 
562     function swapExactETHForTokensSupportingFeeOnTransferTokens(
563         uint256 amountOutMin,
564         address[] calldata path,
565         address to,
566         uint256 deadline
567     ) external payable;
568 
569     function swapExactTokensForETHSupportingFeeOnTransferTokens(
570         uint256 amountIn,
571         uint256 amountOutMin,
572         address[] calldata path,
573         address to,
574         uint256 deadline
575     ) external;
576 }
577 
578 // File: contracts/5/interfaces/IBank.sol
579 
580 pragma solidity 0.5.16;
581 
582 interface IBank {       
583 
584     /**
585      * @dev Returns the amount of tokens in existence.
586      */
587     function totalSupply() external view returns (uint256);
588 
589     /**
590      * @dev Returns the amount of tokens owned by `account`.
591      */
592     function balanceOf(address account) external view returns (uint256);
593 
594     /**
595      * @dev Moves `amount` tokens from the caller's account to `recipient`.
596      *
597      * Returns a boolean value indicating whether the operation succeeded.
598      *
599      * Emits a `Transfer` event.
600      */
601     function transfer(address recipient, uint256 amount) external returns (bool);
602 
603     /**
604      * @dev Returns the remaining number of tokens that `spender` will be
605      * allowed to spend on behalf of `owner` through `transferFrom`. This is
606      * zero by default.
607      *
608      * This value changes when `approve` or `transferFrom` are called.
609      */
610     function allowance(address owner, address spender) external view returns (uint256);
611 
612     /**
613      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
614      *
615      * Returns a boolean value indicating whether the operation succeeded.
616      *
617      * > Beware that changing an allowance with this method brings the risk
618      * that someone may use both the old and the new allowance by unfortunate
619      * transaction ordering. One possible solution to mitigate this race
620      * condition is to first reduce the spender's allowance to 0 and set the
621      * desired value afterwards:
622      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
623      *
624      * Emits an `Approval` event.
625      */
626     function approve(address spender, uint256 amount) external returns (bool);
627 
628     /**
629      * @dev Moves `amount` tokens from `sender` to `recipient` using the
630      * allowance mechanism. `amount` is then deducted from the caller's
631      * allowance.
632      *
633      * Returns a boolean value indicating whether the operation succeeded.
634      *
635      * Emits a `Transfer` event.
636      */
637     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
638 
639     /// @dev Return the total ETH entitled to the token holders. Be careful of unaccrued interests.
640     function totalETH() external view returns (uint256);
641 
642     /// @dev Add more ETH to the bank. Hope to get some good returns.
643     function deposit() external payable;
644 
645     /// @dev Withdraw ETH from the bank by burning the share tokens.
646     function withdraw(uint256 share) external;
647 
648 }
649 
650 // File: contracts/5/IbETHRouter.sol
651 
652 pragma solidity =0.5.16;
653 
654 
655 
656 
657 
658 
659 
660 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
661 library TransferHelper {
662     function safeApprove(
663         address token,
664         address to,
665         uint256 value
666     ) internal {
667         // bytes4(keccak256(bytes('approve(address,uint256)')));
668         (bool success, bytes memory data) = token.call(
669             abi.encodeWithSelector(0x095ea7b3, to, value)
670         );
671         require(
672             success && (data.length == 0 || abi.decode(data, (bool))),
673             "TransferHelper: APPROVE_FAILED"
674         );
675     }
676 
677     function safeTransfer(
678         address token,
679         address to,
680         uint256 value
681     ) internal {
682         // bytes4(keccak256(bytes('transfer(address,uint256)')));
683         (bool success, bytes memory data) = token.call(
684             abi.encodeWithSelector(0xa9059cbb, to, value)
685         );
686         require(
687             success && (data.length == 0 || abi.decode(data, (bool))),
688             "TransferHelper: TRANSFER_FAILED"
689         );
690     }
691 
692     function safeTransferFrom(
693         address token,
694         address from,
695         address to,
696         uint256 value
697     ) internal {
698         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
699         (bool success, bytes memory data) = token.call(
700             abi.encodeWithSelector(0x23b872dd, from, to, value)
701         );
702         require(
703             success && (data.length == 0 || abi.decode(data, (bool))),
704             "TransferHelper: TRANSFER_FROM_FAILED"
705         );
706     }
707 
708     function safeTransferETH(address to, uint256 value) internal {
709         (bool success, ) = to.call.value(value)(new bytes(0));
710         require(success, "TransferHelper: ETH_TRANSFER_FAILED");
711     }
712 }
713 
714 contract IbETHRouter is Ownable {
715     using SafeMath for uint256;
716 
717     address public router;
718     address public ibETH; 
719     address public alpha;     
720     address public lpToken;     
721 
722     constructor(address _router, address _ibETH, address _alpha) public {
723         router = _router;
724         ibETH = _ibETH;   
725         alpha = _alpha;                             
726         address factory = IUniswapV2Router02(router).factory();   
727         lpToken = IUniswapV2Factory(factory).getPair(ibETH, alpha);                  
728         IUniswapV2Pair(lpToken).approve(router, uint256(-1)); // 100% trust in the router        
729         IBank(ibETH).approve(router, uint256(-1)); // 100% trust in the router        
730         IERC20(alpha).approve(router, uint256(-1)); // 100% trust in the router        
731     }
732 
733     function() external payable {
734         assert(msg.sender == ibETH); // only accept ETH via fallback from the Bank contract
735     }
736 
737     // **** ETH-ibETH FUNCTIONS ****
738     // Get number of ibETH needed to withdraw to get exact amountETH from the Bank
739     function ibETHForExactETH(uint256 amountETH) public view returns (uint256) {
740         uint256 totalETH = IBank(ibETH).totalETH();        
741         return totalETH == 0 ? amountETH : amountETH.mul(IBank(ibETH).totalSupply()).add(totalETH).sub(1).div(totalETH); 
742     }   
743     
744     // Add ETH and Alpha from ibETH-Alpha Pool.
745     // 1. Receive ETH and Alpha from caller.
746     // 2. Wrap ETH to ibETH.
747     // 3. Provide liquidity to the pool.
748     function addLiquidityETH(        
749         uint256 amountAlphaDesired,
750         uint256 amountAlphaMin,
751         uint256 amountETHMin,
752         address to,
753         uint256 deadline
754     )
755         external
756         payable        
757         returns (
758             uint256 amountAlpha,
759             uint256 amountETH,
760             uint256 liquidity
761         ) {                
762         TransferHelper.safeTransferFrom(alpha, msg.sender, address(this), amountAlphaDesired);
763         IBank(ibETH).deposit.value(msg.value)();   
764         uint256 amountIbETHDesired = IBank(ibETH).balanceOf(address(this)); 
765         uint256 amountIbETH;
766         (amountAlpha, amountIbETH, liquidity) = IUniswapV2Router02(router).addLiquidity(
767             alpha,
768             ibETH,
769             amountAlphaDesired,            
770             amountIbETHDesired,
771             amountAlphaMin,            
772             0,
773             to,
774             deadline
775         );         
776         if (amountAlphaDesired > amountAlpha) {
777             TransferHelper.safeTransfer(alpha, msg.sender, amountAlphaDesired.sub(amountAlpha));
778         }                       
779         IBank(ibETH).withdraw(amountIbETHDesired.sub(amountIbETH));        
780         amountETH = msg.value - address(this).balance;
781         if (amountETH > 0) {
782             TransferHelper.safeTransferETH(msg.sender, address(this).balance);
783         }
784         require(amountETH >= amountETHMin, "IbETHRouter: require more ETH than amountETHmin");
785     }
786 
787     /// @dev Compute optimal deposit amount
788     /// @param amtA amount of token A desired to deposit
789     /// @param amtB amonut of token B desired to deposit
790     /// @param resA amount of token A in reserve
791     /// @param resB amount of token B in reserve
792     /// (forked from ./StrategyAddTwoSidesOptimal.sol)
793     function optimalDeposit(
794         uint256 amtA,
795         uint256 amtB,
796         uint256 resA,
797         uint256 resB
798     ) internal pure returns (uint256 swapAmt, bool isReversed) {
799         if (amtA.mul(resB) >= amtB.mul(resA)) {
800             swapAmt = _optimalDepositA(amtA, amtB, resA, resB);
801             isReversed = false;
802         } else {
803             swapAmt = _optimalDepositA(amtB, amtA, resB, resA);
804             isReversed = true;
805         }
806     }
807 
808     /// @dev Compute optimal deposit amount helper
809     /// @param amtA amount of token A desired to deposit
810     /// @param amtB amonut of token B desired to deposit
811     /// @param resA amount of token A in reserve
812     /// @param resB amount of token B in reserve
813     /// (forked from ./StrategyAddTwoSidesOptimal.sol)
814     function _optimalDepositA(
815         uint256 amtA,
816         uint256 amtB,
817         uint256 resA,
818         uint256 resB
819     ) internal pure returns (uint256) {
820         require(amtA.mul(resB) >= amtB.mul(resA), "Reversed");
821 
822         uint256 a = 997;
823         uint256 b = uint256(1997).mul(resA);
824         uint256 _c = (amtA.mul(resB)).sub(amtB.mul(resA));
825         uint256 c = _c.mul(1000).div(amtB.add(resB)).mul(resA);
826 
827         uint256 d = a.mul(c).mul(4);
828         uint256 e = Math.sqrt(b.mul(b).add(d));
829 
830         uint256 numerator = e.sub(b);
831         uint256 denominator = a.mul(2);
832 
833         return numerator.div(denominator);
834     }
835 
836     // Add ibETH and Alpha to ibETH-Alpha Pool.
837     // All ibETH and Alpha supplied are optimally swap and add too ibETH-Alpha Pool.
838     function addLiquidityTwoSidesOptimal(        
839         uint256 amountIbETHDesired,        
840         uint256 amountAlphaDesired,        
841         uint256 amountLPMin,
842         address to,
843         uint256 deadline
844     )
845         external        
846         returns (            
847             uint256 liquidity
848         ) {        
849         if (amountIbETHDesired > 0) {
850             TransferHelper.safeTransferFrom(ibETH, msg.sender, address(this), amountIbETHDesired);    
851         }
852         if (amountAlphaDesired > 0) {
853             TransferHelper.safeTransferFrom(alpha, msg.sender, address(this), amountAlphaDesired);    
854         }        
855         uint256 swapAmt;
856         bool isReversed;
857         {
858             (uint256 r0, uint256 r1, ) = IUniswapV2Pair(lpToken).getReserves();
859             (uint256 ibETHReserve, uint256 alphaReserve) = IUniswapV2Pair(lpToken).token0() == ibETH ? (r0, r1) : (r1, r0);
860             (swapAmt, isReversed) = optimalDeposit(amountIbETHDesired, amountAlphaDesired, ibETHReserve, alphaReserve);
861         }
862         address[] memory path = new address[](2);
863         (path[0], path[1]) = isReversed ? (alpha, ibETH) : (ibETH, alpha);        
864         IUniswapV2Router02(router).swapExactTokensForTokens(swapAmt, 0, path, address(this), now);                
865         (,, liquidity) = IUniswapV2Router02(router).addLiquidity(
866             alpha,
867             ibETH,
868             IERC20(alpha).balanceOf(address(this)),            
869             IBank(ibETH).balanceOf(address(this)),
870             0,            
871             0,
872             to,
873             deadline
874         );        
875         uint256 dustAlpha = IERC20(alpha).balanceOf(address(this));
876         uint256 dustIbETH = IBank(ibETH).balanceOf(address(this));
877         if (dustAlpha > 0) {
878             TransferHelper.safeTransfer(alpha, msg.sender, dustAlpha);
879         }    
880         if (dustIbETH > 0) {
881             TransferHelper.safeTransfer(ibETH, msg.sender, dustIbETH);
882         }                    
883         require(liquidity >= amountLPMin, "IbETHRouter: receive less lpToken than amountLPMin");
884     }
885 
886     // Add ETH and Alpha to ibETH-Alpha Pool.
887     // All ETH and Alpha supplied are optimally swap and add too ibETH-Alpha Pool.
888     function addLiquidityTwoSidesOptimalETH(                
889         uint256 amountAlphaDesired,        
890         uint256 amountLPMin,
891         address to,
892         uint256 deadline
893     )
894         external
895         payable        
896         returns (            
897             uint256 liquidity
898         ) {                
899         if (amountAlphaDesired > 0) {
900             TransferHelper.safeTransferFrom(alpha, msg.sender, address(this), amountAlphaDesired);    
901         }       
902         IBank(ibETH).deposit.value(msg.value)();   
903         uint256 amountIbETHDesired = IBank(ibETH).balanceOf(address(this));                  
904         uint256 swapAmt;
905         bool isReversed;
906         {
907             (uint256 r0, uint256 r1, ) = IUniswapV2Pair(lpToken).getReserves();
908             (uint256 ibETHReserve, uint256 alphaReserve) = IUniswapV2Pair(lpToken).token0() == ibETH ? (r0, r1) : (r1, r0);
909             (swapAmt, isReversed) = optimalDeposit(amountIbETHDesired, amountAlphaDesired, ibETHReserve, alphaReserve);
910         }        
911         address[] memory path = new address[](2);
912         (path[0], path[1]) = isReversed ? (alpha, ibETH) : (ibETH, alpha);        
913         IUniswapV2Router02(router).swapExactTokensForTokens(swapAmt, 0, path, address(this), now);                
914         (,, liquidity) = IUniswapV2Router02(router).addLiquidity(
915             alpha,
916             ibETH,
917             IERC20(alpha).balanceOf(address(this)),            
918             IBank(ibETH).balanceOf(address(this)),
919             0,            
920             0,
921             to,
922             deadline
923         );        
924         uint256 dustAlpha = IERC20(alpha).balanceOf(address(this));
925         uint256 dustIbETH = IBank(ibETH).balanceOf(address(this));
926         if (dustAlpha > 0) {
927             TransferHelper.safeTransfer(alpha, msg.sender, dustAlpha);
928         }    
929         if (dustIbETH > 0) {
930             TransferHelper.safeTransfer(ibETH, msg.sender, dustIbETH);
931         }                    
932         require(liquidity >= amountLPMin, "IbETHRouter: receive less lpToken than amountLPMin");
933     }
934       
935     // Remove ETH and Alpha from ibETH-Alpha Pool.
936     // 1. Remove ibETH and Alpha from the pool.
937     // 2. Unwrap ibETH to ETH.
938     // 3. Return ETH and Alpha to caller.
939     function removeLiquidityETH(        
940         uint256 liquidity,
941         uint256 amountAlphaMin,
942         uint256 amountETHMin,
943         address to,
944         uint256 deadline
945     ) public returns (uint256 amountAlpha, uint256 amountETH) {                  
946         TransferHelper.safeTransferFrom(lpToken, msg.sender, address(this), liquidity);          
947         uint256 amountIbETH;
948         (amountAlpha, amountIbETH) = IUniswapV2Router02(router).removeLiquidity(
949             alpha,
950             ibETH,
951             liquidity,
952             amountAlphaMin,
953             0,
954             address(this),
955             deadline
956         );                        
957         TransferHelper.safeTransfer(alpha, to, amountAlpha); 
958         IBank(ibETH).withdraw(amountIbETH);        
959         amountETH = address(this).balance;
960         if (amountETH > 0) {
961             TransferHelper.safeTransferETH(msg.sender, address(this).balance);
962         }
963         require(amountETH >= amountETHMin, "IbETHRouter: receive less ETH than amountETHmin");                               
964     }
965 
966     // Remove liquidity from ibETH-Alpha Pool and convert all ibETH to Alpha 
967     // 1. Remove ibETH and Alpha from the pool.
968     // 2. Swap ibETH for Alpha.
969     // 3. Return Alpha to caller.   
970     function removeLiquidityAllAlpha(        
971         uint256 liquidity,
972         uint256 amountAlphaMin,        
973         address to,
974         uint256 deadline
975     ) public returns (uint256 amountAlpha) {                  
976         TransferHelper.safeTransferFrom(lpToken, msg.sender, address(this), liquidity);          
977         (uint256 removeAmountAlpha, uint256 removeAmountIbETH) = IUniswapV2Router02(router).removeLiquidity(
978             alpha,
979             ibETH,
980             liquidity,
981             0,
982             0,
983             address(this),
984             deadline
985         );        
986         address[] memory path = new address[](2);
987         path[0] = ibETH;
988         path[1] = alpha;
989         uint256[] memory amounts = IUniswapV2Router02(router).swapExactTokensForTokens(removeAmountIbETH, 0, path, to, deadline);               
990         TransferHelper.safeTransfer(alpha, to, removeAmountAlpha);                        
991         amountAlpha = removeAmountAlpha.add(amounts[1]);
992         require(amountAlpha >= amountAlphaMin, "IbETHRouter: receive less Alpha than amountAlphaMin");                               
993     }       
994 
995     // Swap exact amount of ETH for Token
996     // 1. Receive ETH from caller
997     // 2. Wrap ETH to ibETH.
998     // 3. Swap ibETH for Token    
999     function swapExactETHForAlpha(
1000         uint256 amountAlphaOutMin,        
1001         address to,
1002         uint256 deadline
1003     ) external payable returns (uint256[] memory amounts) {                           
1004         IBank(ibETH).deposit.value(msg.value)();   
1005         address[] memory path = new address[](2);
1006         path[0] = ibETH;
1007         path[1] = alpha;     
1008         uint256[] memory swapAmounts = IUniswapV2Router02(router).swapExactTokensForTokens(IBank(ibETH).balanceOf(address(this)), amountAlphaOutMin, path, to, deadline);
1009         amounts = new uint256[](2);        
1010         amounts[0] = msg.value;
1011         amounts[1] = swapAmounts[1];
1012     }
1013 
1014     // Swap Token for exact amount of ETH
1015     // 1. Receive Token from caller
1016     // 2. Swap Token for ibETH.
1017     // 3. Unwrap ibETH to ETH.
1018     function swapAlphaForExactETH(
1019         uint256 amountETHOut,
1020         uint256 amountAlphaInMax,         
1021         address to,
1022         uint256 deadline
1023     ) external returns (uint256[] memory amounts) {
1024         TransferHelper.safeTransferFrom(alpha, msg.sender, address(this), amountAlphaInMax);
1025         address[] memory path = new address[](2);
1026         path[0] = alpha;
1027         path[1] = ibETH;
1028         IBank(ibETH).withdraw(0);
1029         uint256[] memory swapAmounts = IUniswapV2Router02(router).swapTokensForExactTokens(ibETHForExactETH(amountETHOut), amountAlphaInMax, path, address(this), deadline);                           
1030         IBank(ibETH).withdraw(swapAmounts[1]);
1031         amounts = new uint256[](2);
1032         amounts[0] = swapAmounts[0];
1033         amounts[1] = address(this).balance;
1034         TransferHelper.safeTransferETH(to, address(this).balance);        
1035         if (amountAlphaInMax > amounts[0]) {
1036             TransferHelper.safeTransfer(alpha, msg.sender, amountAlphaInMax.sub(amounts[0]));
1037         }                    
1038     }
1039 
1040     // Swap exact amount of Token for ETH
1041     // 1. Receive Token from caller
1042     // 2. Swap Token for ibETH.
1043     // 3. Unwrap ibETH to ETH.
1044     function swapExactAlphaForETH(
1045         uint256 amountAlphaIn,
1046         uint256 amountETHOutMin,         
1047         address to,
1048         uint256 deadline
1049     ) external returns (uint256[] memory amounts) {
1050         TransferHelper.safeTransferFrom(alpha, msg.sender, address(this), amountAlphaIn); 
1051         address[] memory path = new address[](2);
1052         path[0] = alpha;
1053         path[1] = ibETH;
1054         uint256[] memory swapAmounts = IUniswapV2Router02(router).swapExactTokensForTokens(amountAlphaIn, 0, path, address(this), deadline);                        
1055         IBank(ibETH).withdraw(swapAmounts[1]);        
1056         amounts = new uint256[](2);
1057         amounts[0] = swapAmounts[0];
1058         amounts[1] = address(this).balance;
1059         TransferHelper.safeTransferETH(to, amounts[1]);
1060         require(amounts[1] >= amountETHOutMin, "IbETHRouter: receive less ETH than amountETHmin");                                       
1061     }
1062 
1063     // Swap ETH for exact amount of Token
1064     // 1. Receive ETH from caller
1065     // 2. Wrap ETH to ibETH.
1066     // 3. Swap ibETH for Token    
1067     function swapETHForExactAlpha(
1068         uint256 amountAlphaOut,          
1069         address to,
1070         uint256 deadline
1071     ) external payable returns (uint256[] memory amounts) {             
1072         IBank(ibETH).deposit.value(msg.value)();              
1073         uint256 amountIbETHInMax = IBank(ibETH).balanceOf(address(this));        
1074         address[] memory path = new address[](2);
1075         path[0] = ibETH;
1076         path[1] = alpha;                
1077         uint256[] memory swapAmounts = IUniswapV2Router02(router).swapTokensForExactTokens(amountAlphaOut, amountIbETHInMax, path, to, deadline);                                                
1078         amounts = new uint256[](2);               
1079         amounts[0] = msg.value;
1080         amounts[1] = swapAmounts[1];
1081         // Transfer left over ETH back
1082         if (amountIbETHInMax > swapAmounts[0]) {                         
1083             IBank(ibETH).withdraw(amountIbETHInMax.sub(swapAmounts[0]));                    
1084             amounts[0] = msg.value - address(this).balance;
1085             TransferHelper.safeTransferETH(to, address(this).balance);
1086         }                                       
1087     }   
1088 
1089     /// @dev Recover ERC20 tokens that were accidentally sent to this smart contract.
1090     /// @param token The token contract. Can be anything. This contract should not hold ERC20 tokens.
1091     /// @param to The address to send the tokens to.
1092     /// @param value The number of tokens to transfer to `to`.
1093     function recover(address token, address to, uint256 value) external onlyOwner {        
1094         TransferHelper.safeTransfer(token, to, value);                
1095     }
1096 
1097     /// @dev Recover ETH that were accidentally sent to this smart contract.    
1098     /// @param to The address to send the ETH to.
1099     /// @param value The number of ETH to transfer to `to`.
1100     function recoverETH(address to, uint256 value) external onlyOwner {        
1101         TransferHelper.safeTransferETH(to, value);                
1102     }
1103 }