1 /**
2   
3   
4   This contract was launched by CryptoCurrent's Memecoin Generator found at https://app.thecurrent.io/
5 
6   With this contract you can create your own memecoin with custom settings of taxes.
7    
8 
9  */
10 
11 pragma solidity ^0.6.12;
12 // SPDX-License-Identifier: Unlicensed
13 
14 library Address {
15 
16     function isContract(address account) internal view returns (bool) {
17         uint256 size;
18         // solhint-disable-next-line no-inline-assembly
19         assembly { size := extcodesize(account) }
20         return size > 0;
21     }
22 
23     function sendValue(address payable recipient, uint256 amount) internal {
24         require(address(this).balance >= amount, "Address: insufficient balance");
25 
26         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
27         (bool success, ) = recipient.call{ value: amount }("");
28         require(success, "Address: unable to send value, recipient may have reverted");
29     }
30 
31     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
32       return functionCall(target, data, "Address: low-level call failed");
33     }
34 
35     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
36         return functionCallWithValue(target, data, 0, errorMessage);
37     }
38 
39     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
40         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
41     }
42 
43     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
44         require(address(this).balance >= value, "Address: insufficient balance for call");
45         require(isContract(target), "Address: call to non-contract");
46 
47         // solhint-disable-next-line avoid-low-level-calls
48         (bool success, bytes memory returndata) = target.call{ value: value }(data);
49         return _verifyCallResult(success, returndata, errorMessage);
50     }
51 
52     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
53         if (success) {
54             return returndata;
55         } else {
56             // Look for revert reason and bubble it up if present
57             if (returndata.length > 0) {
58                 // The easiest way to bubble the revert reason is using memory via assembly
59 
60                 // solhint-disable-next-line no-inline-assembly
61                 assembly {
62                     let returndata_size := mload(returndata)
63                     revert(add(32, returndata), returndata_size)
64                 }
65             } else {
66                 revert(errorMessage);
67             }
68         }
69     }
70 }
71 
72 interface IERC20 {
73 
74     function totalSupply() external view returns (uint256);
75 
76 
77     /**
78      * @dev Returns the amount of tokens owned by `account`.
79      */
80     function balanceOf(address account) external view returns (uint256);
81 
82     /**
83      * @dev Moves `amount` tokens from the caller's account to `recipient`.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transfer(address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Returns the remaining number of tokens that `spender` will be
93      * allowed to spend on behalf of `owner` through {transferFrom}. This is
94      * zero by default.
95      *
96      * This value changes when {approve} or {transferFrom} are called.
97      */
98     function allowance(address owner, address spender) external view returns (uint256);
99 
100     /**
101      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * IMPORTANT: Beware that changing an allowance with this method brings the risk
106      * that someone may use both the old and the new allowance by unfortunate
107      * transaction ordering. One possible solution to mitigate this race
108      * condition is to first reduce the spender's allowance to 0 and set the
109      * desired value afterwards:
110      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111      *
112      * Emits an {Approval} event.
113      */
114     function approve(address spender, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Moves `amount` tokens from `sender` to `recipient` using the
118      * allowance mechanism. `amount` is then deducted from the caller's
119      * allowance.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Emitted when `value` tokens are moved from one account (`from`) to
129      * another (`to`).
130      *
131      * Note that `value` may be zero.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     /**
136      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
137      * a call to {approve}. `value` is the new allowance.
138      */
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 
143 
144 /**
145  * @dev Wrappers over Solidity's arithmetic operations with added overflow
146  * checks.
147  *
148  * Arithmetic operations in Solidity wrap on overflow. This can easily result
149  * in bugs, because programmers usually assume that an overflow raises an
150  * error, which is the standard behavior in high level programming languages.
151  * `SafeMath` restores this intuition by reverting the transaction when an
152  * operation overflows.
153  *
154  * Using this library instead of the unchecked operations eliminates an entire
155  * class of bugs, so it's recommended to use it always.
156  */
157  
158 library SafeMath {
159     /**
160      * @dev Returns the addition of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `+` operator.
164      *
165      * Requirements:
166      *
167      * - Addition cannot overflow.
168      */
169     function add(uint256 a, uint256 b) internal pure returns (uint256) {
170         uint256 c = a + b;
171         require(c >= a, "SafeMath: addition overflow");
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187         return sub(a, b, "SafeMath: subtraction overflow");
188     }
189 
190     /**
191      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
192      * overflow (when the result is negative).
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      *
198      * - Subtraction cannot overflow.
199      */
200     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b <= a, errorMessage);
202         uint256 c = a - b;
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the multiplication of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `*` operator.
212      *
213      * Requirements:
214      *
215      * - Multiplication cannot overflow.
216      */
217     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
219         // benefit is lost if 'b' is also tested.
220         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
221         if (a == 0) {
222             return 0;
223         }
224 
225         uint256 c = a * b;
226         require(c / a == b, "SafeMath: multiplication overflow");
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         return div(a, b, "SafeMath: division by zero");
245     }
246 
247     /**
248      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
249      * division by zero. The result is rounded towards zero.
250      *
251      * Counterpart to Solidity's `/` operator. Note: this function uses a
252      * `revert` opcode (which leaves remaining gas untouched) while Solidity
253      * uses an invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b > 0, errorMessage);
261         uint256 c = a / b;
262         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
263 
264         return c;
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * Reverts when dividing by zero.
270      *
271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
272      * opcode (which leaves remaining gas untouched) while Solidity uses an
273      * invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
280         return mod(a, b, "SafeMath: modulo by zero");
281     }
282 
283     /**
284      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
285      * Reverts with custom message when dividing by zero.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b != 0, errorMessage);
297         return a % b;
298     }
299 }
300 
301 abstract contract Context {
302     function _msgSender() internal view virtual returns (address payable) {
303         return msg.sender;
304     }
305 
306     function _msgData() internal view virtual returns (bytes memory) {
307         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
308         return msg.data;
309     }
310 }
311 
312 
313 /**
314  * @dev Collection of functions related to the address type
315  */
316 
317 
318 
319 /**
320  * @dev Contract module which provides a basic access control mechanism, where
321  * there is an account (an owner) that can be granted exclusive access to
322  * specific functions.
323  *
324  * By default, the owner account will be the one that deploys the contract. This
325  * can later be changed with {transferOwnership}.
326  *
327  * This module is used through inheritance. It will make available the modifier
328  * `onlyOwner`, which can be applied to your functions to restrict their use to
329  * the owner.
330  */
331 contract Ownable is Context {
332     address private _owner;
333     address private _previousOwner;
334     uint256 private _lockTime;
335 
336     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
337 
338     /**
339      * @dev Initializes the contract setting the deployer as the initial owner.
340      */
341     constructor () internal {
342         address msgSender = _msgSender();
343         _owner = msgSender;
344        
345         emit OwnershipTransferred(address(0), msgSender);
346     }
347 
348     /**
349      * @dev Returns the address of the current owner.
350      */
351     function owner() public view returns (address) {
352         return _owner;
353     }
354 
355     /**
356      * @dev Throws if called by any account other than the owner.
357      */
358     modifier onlyOwner() {
359         require(_owner == _msgSender(), "Ownable: caller is not the owner");
360         _;
361     }
362 
363      /**
364      * @dev Leaves the contract without owner. It will not be possible to call
365      * `onlyOwner` functions anymore. Can only be called by the current owner.
366      *
367      * NOTE: Renouncing ownership will leave the contract without an owner,
368      * thereby removing any functionality that is only available to the owner.
369      */
370     function renounceOwnership() public virtual onlyOwner {
371         emit OwnershipTransferred(_owner, address(0));
372         _owner = address(0);
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Can only be called by the current owner.
378      */
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(newOwner != address(0), "Ownable: new owner is the zero address");
381         emit OwnershipTransferred(_owner, newOwner);
382         _owner = newOwner;
383     }
384 
385     function getUnlockTime() public view returns (uint256) {
386         return _lockTime;
387     }
388 
389     
390 }
391 
392 // pragma solidity >=0.5.0;
393 
394 interface IUniswapV2Factory {
395     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
396 
397     function feeTo() external view returns (address);
398     function feeToSetter() external view returns (address);
399 
400     function getPair(address tokenA, address tokenB) external view returns (address pair);
401     function allPairs(uint) external view returns (address pair);
402     function allPairsLength() external view returns (uint);
403 
404     function createPair(address tokenA, address tokenB) external returns (address pair);
405 
406     function setFeeTo(address) external;
407     function setFeeToSetter(address) external;
408 }
409 
410 
411 // pragma solidity >=0.5.0;
412 
413 
414 interface IUniswapV2Pair {
415     event Approval(address indexed owner, address indexed spender, uint value);
416     event Transfer(address indexed from, address indexed to, uint value);
417 
418     function name() external pure returns (string memory);
419     function symbol() external pure returns (string memory);
420     function decimals() external pure returns (uint8);
421     function totalSupply() external view returns (uint);
422     function balanceOf(address owner) external view returns (uint);
423     function allowance(address owner, address spender) external view returns (uint);
424 
425     function approve(address spender, uint value) external returns (bool);
426     function transfer(address to, uint value) external returns (bool);
427     function transferFrom(address from, address to, uint value) external returns (bool);
428 
429     function DOMAIN_SEPARATOR() external view returns (bytes32);
430     function PERMIT_TYPEHASH() external pure returns (bytes32);
431     function nonces(address owner) external view returns (uint);
432 
433     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
434 
435     event Mint(address indexed sender, uint amount0, uint amount1);
436     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
437     event Swap(
438         address indexed sender,
439         uint amount0In,
440         uint amount1In,
441         uint amount0Out,
442         uint amount1Out,
443         address indexed to
444     );
445     event Sync(uint112 reserve0, uint112 reserve1);
446 
447     function MINIMUM_LIQUIDITY() external pure returns (uint);
448     function factory() external view returns (address);
449     function token0() external view returns (address);
450     function token1() external view returns (address);
451     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
452     function price0CumulativeLast() external view returns (uint);
453     function price1CumulativeLast() external view returns (uint);
454     function kLast() external view returns (uint);
455 
456     function mint(address to) external returns (uint liquidity);
457     function burn(address to) external returns (uint amount0, uint amount1);
458     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
459     function skim(address to) external;
460     function sync() external;
461 
462     function initialize(address, address) external;
463 }
464 
465 // pragma solidity >=0.6.2;
466 
467 interface IUniswapV2Router01 {
468     function factory() external pure returns (address);
469     function WETH() external pure returns (address);
470 
471     function addLiquidity(
472         address tokenA,
473         address tokenB,
474         uint amountADesired,
475         uint amountBDesired,
476         uint amountAMin,
477         uint amountBMin,
478         address to,
479         uint deadline
480     ) external returns (uint amountA, uint amountB, uint liquidity);
481     function addLiquidityETH(
482         address token,
483         uint amountTokenDesired,
484         uint amountTokenMin,
485         uint amountETHMin,
486         address to,
487         uint deadline
488     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
489     function removeLiquidity(
490         address tokenA,
491         address tokenB,
492         uint liquidity,
493         uint amountAMin,
494         uint amountBMin,
495         address to,
496         uint deadline
497     ) external returns (uint amountA, uint amountB);
498     function removeLiquidityETH(
499         address token,
500         uint liquidity,
501         uint amountTokenMin,
502         uint amountETHMin,
503         address to,
504         uint deadline
505     ) external returns (uint amountToken, uint amountETH);
506     function removeLiquidityWithPermit(
507         address tokenA,
508         address tokenB,
509         uint liquidity,
510         uint amountAMin,
511         uint amountBMin,
512         address to,
513         uint deadline,
514         bool approveMax, uint8 v, bytes32 r, bytes32 s
515     ) external returns (uint amountA, uint amountB);
516     function removeLiquidityETHWithPermit(
517         address token,
518         uint liquidity,
519         uint amountTokenMin,
520         uint amountETHMin,
521         address to,
522         uint deadline,
523         bool approveMax, uint8 v, bytes32 r, bytes32 s
524     ) external returns (uint amountToken, uint amountETH);
525     function swapExactTokensForTokens(
526         uint amountIn,
527         uint amountOutMin,
528         address[] calldata path,
529         address to,
530         uint deadline
531     ) external returns (uint[] memory amounts);
532     function swapTokensForExactTokens(
533         uint amountOut,
534         uint amountInMax,
535         address[] calldata path,
536         address to,
537         uint deadline
538     ) external returns (uint[] memory amounts);
539     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
540         external
541         payable
542         returns (uint[] memory amounts);
543     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
544         external
545         returns (uint[] memory amounts);
546     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
547         external
548         returns (uint[] memory amounts);
549     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
550         external
551         payable
552         returns (uint[] memory amounts);
553 
554     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
555     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
556     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
557     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
558     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
559 }
560 
561 
562 
563 // pragma solidity >=0.6.2;
564 
565 interface IUniswapV2Router02 is IUniswapV2Router01 {
566     function removeLiquidityETHSupportingFeeOnTransferTokens(
567         address token,
568         uint liquidity,
569         uint amountTokenMin,
570         uint amountETHMin,
571         address to,
572         uint deadline
573     ) external returns (uint amountETH);
574     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
575         address token,
576         uint liquidity,
577         uint amountTokenMin,
578         uint amountETHMin,
579         address to,
580         uint deadline,
581         bool approveMax, uint8 v, bytes32 r, bytes32 s
582     ) external returns (uint amountETH);
583 
584     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
585         uint amountIn,
586         uint amountOutMin,
587         address[] calldata path,
588         address to,
589         uint deadline
590     ) external;
591     function swapExactETHForTokensSupportingFeeOnTransferTokens(
592         uint amountOutMin,
593         address[] calldata path,
594         address to,
595         uint deadline
596     ) external payable;
597     function swapExactTokensForETHSupportingFeeOnTransferTokens(
598         uint amountIn,
599         uint amountOutMin,
600         address[] calldata path,
601         address to,
602         uint deadline
603     ) external;
604 }
605 
606 
607 contract ShibaCloud is Context, IERC20, Ownable {
608     using SafeMath for uint256;
609     using Address for address;
610 
611     mapping (address => uint256) private _rOwned;
612     mapping (address => uint256) private _tOwned;
613     mapping (address => mapping (address => uint256)) private _allowances;
614     mapping (address => uint256 ) public lastTran;
615     mapping (address => bool) private _isExcludedFromFee;
616 
617     mapping (address => bool) private _isExcluded;
618     address[] private _excluded;
619    
620     uint256 private constant MAX = ~uint256(0);
621     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
622     uint256 private _rTotal = (MAX - (MAX % _tTotal));
623     uint256 private _tFeeTotal;
624 
625     string private _name ="Shiba Cloud";
626     string private _symbol = "Nimbus";
627     uint8  private _decimals = 9;
628     
629     uint256 public _taxFee = 1;
630     uint256 private _previousTaxFee = _taxFee;
631     
632     uint256 public _liquidityFee = 4;
633     uint256 private _previousLiquidityFee = _liquidityFee;
634     
635    
636     
637     address public WETH;
638     address public burnAddress;
639     address public memeCoinManager;
640     address public devAddress;
641     address private tempSender;
642     uint256 public LiquidityStartTime;
643     bool    public liquiditySubmitted = false;
644     bool    public init = false;
645     bool    public guardTax = false;
646     uint8   public guardTaxAmount = 10;
647     
648     uint256 public toMemeCoinManager;
649     uint256 public toDevAddress;
650     uint256 public toDead;
651     bool public botpro = true;
652     
653     mapping ( address => bool ) public applyGuardTax;
654     mapping ( address => bool ) public blackList;
655     
656 
657     IUniswapV2Router02 public  uniswapV2Router;
658     address public  uniswapV2Pair;
659     
660     bool inSwapAndLiquify;
661     bool public swapAndLiquifyEnabled = true;
662     uint256 public _maxTxAmount = 5000000 * 10**6 * 10**9;
663     uint256 private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**9;
664     
665     
666     event GuardTax ( address taxed, uint256 amount, uint256 penalty );
667     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
668     event SwapAndLiquifyEnabledUpdated(bool enabled);
669     event SwapAndLiquify(
670         uint256 tokensSwapped,
671         uint256 ethReceived,
672         uint256 tokensIntoLiqudity
673     );
674     
675     modifier lockTheSwap {
676         inSwapAndLiquify = true;
677         _;
678         inSwapAndLiquify = false;
679     }
680     
681     constructor () public  {
682         memeCoinManager = msg.sender;
683         
684         setMaxTransactionPercent(1000000);
685         _rOwned[ address(this) ] = _rTotal;
686        
687         
688         
689         devAddress = 0x7cE0E55703F12D03Eb53B918aD6B9EB80d188afB;
690         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
691         WETH =  0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
692         burnAddress = 0x000000000000000000000000000000000000dEaD;
693       
694         //setTestEnvironment();
695         
696         // set the rest of the contract variables
697         
698          _approve(address(this), address(uniswapV2Router), totalSupply());
699         //exclude owner and this contract from fee
700         _isExcludedFromFee[memeCoinManager] = true;
701         _isExcludedFromFee[devAddress] = true;
702         _isExcludedFromFee[address(this)] = true; 
703         _isExcludedFromFee[msg.sender] = true; 
704         
705         toDevAddress = (balanceOf( address(this))*5).div(10**3);
706         toDead = (balanceOf( address(this))*600).div(10**3);
707         
708         
709         _transfer ( address(this), devAddress , toDevAddress );
710         _transfer ( address(this), burnAddress , toDead );
711         _transfer ( address(this), memeCoinManager , balanceOf( address(this)) );
712         
713         setMaxTransactionPercent(1);
714     
715         emit Transfer(address(0), _msgSender(), _tTotal);
716     }
717     
718     function setTestEnvironment()  internal{
719         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
720         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
721         WETH = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;
722         uniswapV2Router = _uniswapV2Router;
723     }
724 
725     function name() public view returns (string memory) {
726         return _name;
727     }
728 
729     function symbol() public view returns (string memory) {
730         return _symbol;
731     }
732 
733     function decimals() public view returns (uint8) {
734         return _decimals;
735     }
736 
737     function totalSupply() public view override returns (uint256) {
738         return _tTotal;
739     }
740 
741     function balanceOf(address account) public view override returns (uint256) {
742         if (_isExcluded[account]) return _tOwned[account];
743         return tokenFromReflection(_rOwned[account]);
744     }
745 
746     function transfer(address recipient, uint256 amount) public override returns (bool) {
747         _transfer(_msgSender(), recipient, amount);
748         return true;
749     }
750 
751     function allowance(address owner, address spender) public view override returns (uint256) {
752         return _allowances[owner][spender];
753     }
754 
755     function approve(address spender, uint256 amount) public override returns (bool) {
756         _approve(_msgSender(), spender, amount);
757         return true;
758     }
759 
760     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
761         _transfer(sender, recipient, amount);
762         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
763         return true;
764     }
765 
766     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
767         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
768         return true;
769     }
770 
771     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
772         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
773         return true;
774     }
775 
776     function isExcludedFromReward(address account) public view returns (bool) {
777         return _isExcluded[account];
778     }
779 
780     function totalFees() public view returns (uint256) {
781         return _tFeeTotal;
782     }
783     
784     function setUniswapPair() public onlyMemeCoinManager {
785      
786         uniswapV2Pair = IUniswapV2Factory(  uniswapV2Router.factory() ).getPair ( address(this), WETH );
787     
788     }
789     
790     function setBotPro ( bool _switch ) public onlyMemeCoinManager {
791         botpro = _switch;
792     }
793 
794     function deliver(uint256 tAmount) public {
795         address sender = _msgSender();
796         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
797         (uint256 rAmount,,,,,) = _getValues(tAmount);
798         _rOwned[sender] = _rOwned[sender].sub(rAmount);
799         _rTotal = _rTotal.sub(rAmount);
800         _tFeeTotal = _tFeeTotal.add(tAmount);
801     }
802 
803     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public   returns(uint256) {
804         require(tAmount <= _tTotal, "Amount must be less than supply");
805         if (!deductTransferFee) {
806             (uint256 rAmount,,,,,) = _getValues(tAmount);
807             return rAmount;
808         } else {
809             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
810             return rTransferAmount;
811         }
812     }
813 
814     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
815         require(rAmount <= _rTotal, "Amount must be less than total reflections");
816         uint256 currentRate =  _getRate();
817         return rAmount.div(currentRate);
818     }
819 
820    
821     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
822         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity ) = _getValues(tAmount);
823         _tOwned[sender] = _tOwned[sender].sub(tAmount);
824         _rOwned[sender] = _rOwned[sender].sub(rAmount);
825         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
826         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
827         _takeLiquidity(tLiquidity);
828         _reflectFee(rFee, tFee);
829         
830         
831         emit Transfer(sender, recipient, tTransferAmount);
832     }
833     
834     function _transferToVault(address sender, address recipient, uint256 tAmount) private {
835         _tOwned[sender] = _tOwned[sender].sub(tAmount);
836         _rOwned[sender] = _rOwned[sender].sub(tAmount);
837         _tOwned[recipient] = _tOwned[recipient].add(tAmount);
838         _rOwned[recipient] = _rOwned[recipient].add(tAmount);        
839         emit Transfer(sender, recipient, tAmount);
840     }
841     
842    
843     /*
844     function setTaxFeePercent(uint256 taxFee) external onlyMemeCoinManager() {
845         _taxFee = taxFee;
846     }
847     
848     function setLiquidityFeePercent(uint256 liquidityFee) external onlyMemeCoinManager() {
849         _liquidityFee = liquidityFee;
850     }
851 
852     function setSwapAndLiquifyEnabled(bool _enabled) public onlyMemeCoinManager {
853         swapAndLiquifyEnabled = _enabled;
854         emit SwapAndLiquifyEnabledUpdated(_enabled);
855     }
856     */  
857      //to recieve ETH from uniswapV2Router when swaping
858     receive() external payable {}
859 
860     function _reflectFee(uint256 rFee, uint256 tFee) private {
861         _rTotal = _rTotal.sub(rFee);
862         _tFeeTotal = _tFeeTotal.add(tFee);
863     }
864 
865   
866     
867     function _getValues(uint256 tAmount ) private  returns (uint256, uint256, uint256, uint256, uint256, uint256 ) {
868         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity ) = _getTValues(tAmount);
869         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity,  _getRate());
870         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
871     }
872 
873     function _getTValues(uint256 tAmount) private  returns (uint256, uint256, uint256 ) {
874         uint256 tFee = calculateTaxFee(tAmount);
875         uint256 tLiquidity = calculateLiquidityFee(tAmount);
876         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
877         return (tTransferAmount, tFee, tLiquidity);
878     }
879     
880    
881 
882     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity ,uint256 currentRate ) private pure returns (uint256, uint256, uint256) {
883         uint256 rAmount = tAmount.mul(currentRate);
884         uint256 rFee = tFee.mul(currentRate);
885         uint256 rLiquidity = tLiquidity.mul(currentRate);
886         
887         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
888         return (rAmount, rTransferAmount, rFee);
889     }
890 
891     function _getRate() private view returns(uint256) {
892         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
893         return rSupply.div(tSupply);
894     }
895 
896     function _getCurrentSupply() private view returns(uint256, uint256) {
897         uint256 rSupply = _rTotal;
898         uint256 tSupply = _tTotal;      
899         for (uint256 i = 0; i < _excluded.length; i++) {
900             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
901             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
902             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
903         }
904         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
905         return (rSupply, tSupply);
906     }
907     
908     function _takeLiquidity(uint256 tLiquidity) private {
909         uint256 currentRate =  _getRate();
910         uint256 rLiquidity = tLiquidity.mul(currentRate);
911         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
912         if(_isExcluded[address(this)])
913             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
914     }
915     
916    
917     
918     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
919         return _amount.mul(_taxFee).div(
920             10**2
921         );
922     }
923 
924     function calculateLiquidityFee(uint256 _amount) private  returns (uint256) {
925         uint256 _mod = _liquidityFee;
926         if ( guardTax ) _mod = addGuardTax ( _mod );
927         return _amount.mul(_mod).div(
928             10**2
929         );
930     } 
931  
932     function addGuardTax (  uint256 _amount ) internal returns ( uint256 ) {
933         
934         if ( tempSender == uniswapV2Pair || tempSender == address(uniswapV2Router ) ) return _amount;
935         uint256 penalty = _amount * guardTaxAmount;
936         emit GuardTax ( tempSender, _amount, penalty );
937         return penalty;
938     } 
939     
940    
941     function setMaxTransactionPercent(uint256 maxTxPercent) public onlyMemeCoinManager() {
942         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
943             10**6
944         );
945     }
946     
947     function setGuardTax ( bool _switch , uint8 _guardTaxAmount) public onlyMemeCoinManager() {
948         guardTax = _switch;
949         guardTaxAmount = _guardTaxAmount;
950     }
951   
952     function blackListAddress( address _address, bool _switch ) public onlyMemeCoinManager {
953         if ( _address == uniswapV2Pair || _address == address(uniswapV2Router)) revert();
954         blackList[_address] = _switch;
955     }
956     
957     function removeAllFee() private {
958         if(_taxFee == 0 && _liquidityFee == 0  ) return;
959         
960         _previousTaxFee = _taxFee;
961         _previousLiquidityFee = _liquidityFee;
962        
963         
964         _taxFee = 0;
965         _liquidityFee = 0;
966         
967       
968     }
969     
970     function restoreAllFee() private {
971         _taxFee = _previousTaxFee;
972         _liquidityFee = _previousLiquidityFee;
973         
974         
975     }
976     
977     function isExcludedFromFee(address account) public view returns(bool) {
978         return _isExcludedFromFee[account];
979     }
980 
981     function _approve(address owner, address spender, uint256 amount) private {
982         require(owner != address(0), "ERC20: approve from the zero address");
983         require(spender != address(0), "ERC20: approve to the zero address");
984 
985         _allowances[owner][spender] = amount;
986         emit Approval(owner, spender, amount);
987     }
988     
989     
990 
991     function _transfer(
992         address from,
993         address to,
994         uint256 amount
995     ) private {
996         require(from != address(0), "ERC20: transfer from the zero address");
997        
998         require(amount > 0, "Transfer amount must be greater than zero");
999         if ( blackList[from] == true ) revert();
1000         if( from != owner() )
1001             require( amount <= _maxTxAmount , "Transfer amount exceeds the maxTxAmount.");
1002         if( from == uniswapV2Pair && botpro == true ) if (  block.timestamp <  lastTran[to] + 20 seconds  ) revert(" Illegal Transaction");
1003         if( from == uniswapV2Pair && botpro == true  ) lastTran[ to ] = block.timestamp;
1004        
1005         
1006         // is the token balance of this contract address over the min number of
1007         // tokens that we need to initiate a swap + liquidity lock?
1008         // also, don't get caught in a circular liquidity event.
1009         // also, don't swap & liquify if sender is uniswap pair.
1010         uint256 contractTokenBalance = balanceOf(address(this));
1011         
1012         if(contractTokenBalance >= _maxTxAmount)
1013         {
1014             contractTokenBalance = _maxTxAmount;
1015         }
1016         
1017         bool overMinTokenBalance = (contractTokenBalance >= numTokensSellToAddToLiquidity);
1018         if (
1019              liquiditySubmitted && overMinTokenBalance &&
1020             !inSwapAndLiquify &&
1021             from != uniswapV2Pair &&
1022             swapAndLiquifyEnabled
1023         ) {
1024             contractTokenBalance = numTokensSellToAddToLiquidity;
1025             //add liquidity
1026             swapAndLiquify(contractTokenBalance);
1027         }
1028         
1029         //indicates if fee should be deducted from transfer
1030         bool takeFee = true;
1031         
1032         //if any account belongs to _isExcludedFromFee account then remove the fee
1033         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1034             takeFee = false;
1035         }
1036         
1037         //transfer amount, it will take tax, burn, liquidity fee
1038         _tokenTransfer(from,to,amount,takeFee);
1039     }
1040 
1041     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1042         // split the contract balance into halves
1043         uint256 half = contractTokenBalance.div(2);
1044         uint256 otherHalf = contractTokenBalance.sub(half);
1045 
1046         // capture the contract's current ETH balance.
1047         // this is so that we can capture exactly the amount of ETH that the
1048         // swap creates, and not make the liquidity event include any ETH that
1049         // has been manually sent to the contract
1050         uint256 initialBalance = address(this).balance;
1051 
1052         // swap tokens for ETH
1053         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1054 
1055         // how much ETH did we just swap into?
1056         uint256 newBalance = address(this).balance.sub(initialBalance);
1057 
1058         // add liquidity to uniswap
1059         addLiquidity(otherHalf, newBalance);
1060         
1061         emit SwapAndLiquify(half, newBalance, otherHalf);
1062     }
1063 
1064     function swapTokensForEth(uint256 tokenAmount) private {
1065         // generate the uniswap pair path of token -> weth
1066         address[] memory path = new address[](2);
1067         path[0] = address(this);
1068         path[1] = uniswapV2Router.WETH();
1069 
1070         _approve(address(this), address(uniswapV2Router), tokenAmount);
1071 
1072         // make the swap
1073         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1074             tokenAmount,
1075             0, // accept any amount of ETH
1076             path,
1077             address(this),
1078             block.timestamp
1079         );
1080     }
1081 
1082     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1083         // approve token transfer to cover all possible scenarios
1084         _approve(address(this), address(uniswapV2Router), tokenAmount);
1085 
1086         // add the liquidity
1087         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1088             address(this),
1089             tokenAmount,
1090             0, // slippage is unavoidable
1091             0, // slippage is unavoidable
1092             0x000000000000000000000000000000000000dEaD,
1093             block.timestamp
1094         );
1095     }
1096     
1097     
1098     
1099     
1100     
1101 
1102     //this method is responsible for taking all fee, if takeFee is true
1103     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1104         if(!takeFee)
1105             removeAllFee();
1106         
1107         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1108             _transferFromExcluded(sender, recipient, amount);
1109         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1110             _transferToExcluded(sender, recipient, amount);
1111         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1112             _transferStandard(sender, recipient, amount);
1113         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1114             _transferBothExcluded(sender, recipient, amount);
1115         } else {
1116             _transferStandard(sender, recipient, amount);
1117         }
1118         
1119         if(!takeFee)
1120             restoreAllFee();
1121     }
1122 
1123 
1124 
1125 
1126     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1127         
1128         tempSender = sender;
1129         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity ) = _getValues(tAmount);
1130         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1131         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1132         _takeLiquidity(tLiquidity);
1133         _reflectFee(rFee, tFee);
1134        
1135         emit Transfer(sender, recipient, tTransferAmount);
1136     }
1137 
1138     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1139         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity ) = _getValues(tAmount);
1140         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1141         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1142         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1143         _takeLiquidity(tLiquidity);
1144         _reflectFee(rFee, tFee);
1145         
1146         emit Transfer(sender, recipient, tTransferAmount);
1147     }
1148 
1149     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1150         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity  ) = _getValues(tAmount);
1151         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1152         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1153         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1154         _takeLiquidity(tLiquidity);
1155         _reflectFee(rFee, tFee);
1156         
1157         emit Transfer(sender, recipient, tTransferAmount);
1158     }
1159     
1160      modifier onlyMemeCoinManager() {
1161         require( memeCoinManager == _msgSender(), "Ownable: caller is not the meme coin manager");
1162         _;
1163     }
1164 
1165 }