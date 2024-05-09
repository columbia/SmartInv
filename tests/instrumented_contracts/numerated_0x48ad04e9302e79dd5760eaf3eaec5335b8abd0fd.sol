1 // File: @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol
2 
3 pragma solidity >=0.4.24 <0.7.0;
4 
5 
6 /**
7  * @title Initializable
8  *
9  * @dev Helper contract to support initializer functions. To use it, replace
10  * the constructor with a function that has the `initializer` modifier.
11  * WARNING: Unlike constructors, initializer functions must be manually
12  * invoked. This applies both to deploying an Initializable contract, as well
13  * as extending an Initializable contract via inheritance.
14  * WARNING: When used with inheritance, manual care must be taken to not invoke
15  * a parent initializer twice, or ensure that all initializers are idempotent,
16  * because this is not dealt with automatically as with constructors.
17  */
18 contract Initializable {
19 
20   /**
21    * @dev Indicates that the contract has been initialized.
22    */
23   bool private initialized;
24 
25   /**
26    * @dev Indicates that the contract is in the process of being initialized.
27    */
28   bool private initializing;
29 
30   /**
31    * @dev Modifier to use in the initializer function of a contract.
32    */
33   modifier initializer() {
34     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
35 
36     bool isTopLevelCall = !initializing;
37     if (isTopLevelCall) {
38       initializing = true;
39       initialized = true;
40     }
41 
42     _;
43 
44     if (isTopLevelCall) {
45       initializing = false;
46     }
47   }
48 
49   /// @dev Returns true if and only if the function is running in the constructor
50   function isConstructor() private view returns (bool) {
51     // extcodesize checks the size of the code stored in an address, and
52     // address returns the current address. Since the code is still not
53     // deployed when running a constructor, any checks on its code size will
54     // yield zero, making it an effective way to detect if a contract is
55     // under construction or not.
56     address self = address(this);
57     uint256 cs;
58     assembly { cs := extcodesize(self) }
59     return cs == 0;
60   }
61 
62   // Reserved storage space to allow for layout changes in the future.
63   uint256[50] private ______gap;
64 }
65 
66 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol
67 
68 pragma solidity ^0.6.0;
69 
70 
71 /*
72  * @dev Provides information about the current execution context, including the
73  * sender of the transaction and its data. While these are generally available
74  * via msg.sender and msg.data, they should not be accessed in such a direct
75  * manner, since when dealing with GSN meta-transactions the account sending and
76  * paying for execution may not be the actual sender (as far as an application
77  * is concerned).
78  *
79  * This contract is only required for intermediate, library-like contracts.
80  */
81 contract ContextUpgradeSafe is Initializable {
82     // Empty internal constructor, to prevent people from mistakenly deploying
83     // an instance of this contract, which should be used via inheritance.
84 
85     function __Context_init() internal initializer {
86         __Context_init_unchained();
87     }
88 
89     function __Context_init_unchained() internal initializer {
90 
91 
92     }
93 
94 
95     function _msgSender() internal view virtual returns (address payable) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view virtual returns (bytes memory) {
100         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
101         return msg.data;
102     }
103 
104     uint256[50] private __gap;
105 }
106 
107 // File: @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol
108 
109 pragma solidity ^0.6.0;
110 
111 
112 /**
113  * @dev Contract module which provides a basic access control mechanism, where
114  * there is an account (an owner) that can be granted exclusive access to
115  * specific functions.
116  *
117  * By default, the owner account will be the one that deploys the contract. This
118  * can later be changed with {transferOwnership}.
119  *
120  * This module is used through inheritance. It will make available the modifier
121  * `onlyOwner`, which can be applied to your functions to restrict their use to
122  * the owner.
123  */
124 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132 
133     function __Ownable_init() internal initializer {
134         __Context_init_unchained();
135         __Ownable_init_unchained();
136     }
137 
138     function __Ownable_init_unchained() internal initializer {
139 
140 
141         address msgSender = _msgSender();
142         _owner = msgSender;
143         emit OwnershipTransferred(address(0), msgSender);
144 
145     }
146 
147 
148     /**
149      * @dev Returns the address of the current owner.
150      */
151     function owner() public view returns (address) {
152         return _owner;
153     }
154 
155     /**
156      * @dev Throws if called by any account other than the owner.
157      */
158     modifier onlyOwner() {
159         require(_owner == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     /**
164      * @dev Leaves the contract without owner. It will not be possible to call
165      * `onlyOwner` functions anymore. Can only be called by the current owner.
166      *
167      * NOTE: Renouncing ownership will leave the contract without an owner,
168      * thereby removing any functionality that is only available to the owner.
169      */
170     function renounceOwnership() public virtual onlyOwner {
171         emit OwnershipTransferred(_owner, address(0));
172         _owner = address(0);
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Can only be called by the current owner.
178      */
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         emit OwnershipTransferred(_owner, newOwner);
182         _owner = newOwner;
183     }
184 
185     uint256[49] private __gap;
186 }
187 
188 // File: contracts/interfaces/IWETH9.sol
189 
190 pragma solidity >=0.5.0;
191 
192 interface IWETH {
193     function deposit() external payable;
194     function transfer(address to, uint value) external returns (bool);
195     function withdraw(uint) external;
196 }
197 
198 // File: contracts/interfaces/IFeeApprover.sol
199 
200 
201 
202 pragma solidity 0.6.12;
203 
204 interface IFeeApprover {
205 
206     function sync() external;
207 
208     function setFeeMultiplier(uint _feeMultiplier) external;
209     function feePercentX100() external view returns (uint);
210 
211     function setTokenUniswapPair(address _tokenUniswapPair) external;
212    
213     function setCoreTokenAddress(address _coreTokenAddress) external;
214     function updateTxState() external;
215     function calculateAmountsAfterFee(        
216         address sender, 
217         address recipient, 
218         uint256 amount
219     ) external  returns (uint256 transferToAmount, uint256 transferToFeeBearerAmount);
220 
221     function setPaused() external;
222  
223 
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
227 
228 
229 
230 pragma solidity ^0.6.0;
231 
232 /**
233  * @dev Interface of the ERC20 standard as defined in the EIP.
234  */
235 interface IERC20 {
236     /**
237      * @dev Returns the amount of tokens in existence.
238      */
239     function totalSupply() external view returns (uint256);
240 
241     /**
242      * @dev Returns the amount of tokens owned by `account`.
243      */
244     function balanceOf(address account) external view returns (uint256);
245 
246     /**
247      * @dev Moves `amount` tokens from the caller's account to `recipient`.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transfer(address recipient, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Returns the remaining number of tokens that `spender` will be
257      * allowed to spend on behalf of `owner` through {transferFrom}. This is
258      * zero by default.
259      *
260      * This value changes when {approve} or {transferFrom} are called.
261      */
262     function allowance(address owner, address spender) external view returns (uint256);
263 
264     /**
265      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
266      *
267      * Returns a boolean value indicating whether the operation succeeded.
268      *
269      * IMPORTANT: Beware that changing an allowance with this method brings the risk
270      * that someone may use both the old and the new allowance by unfortunate
271      * transaction ordering. One possible solution to mitigate this race
272      * condition is to first reduce the spender's allowance to 0 and set the
273      * desired value afterwards:
274      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275      *
276      * Emits an {Approval} event.
277      */
278     function approve(address spender, uint256 amount) external returns (bool);
279 
280     /**
281      * @dev Moves `amount` tokens from `sender` to `recipient` using the
282      * allowance mechanism. `amount` is then deducted from the caller's
283      * allowance.
284      *
285      * Returns a boolean value indicating whether the operation succeeded.
286      *
287      * Emits a {Transfer} event.
288      */
289     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
290 
291     /**
292      * @dev Emitted when `value` tokens are moved from one account (`from`) to
293      * another (`to`).
294      *
295      * Note that `value` may be zero.
296      */
297     event Transfer(address indexed from, address indexed to, uint256 value);
298 
299     /**
300      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
301      * a call to {approve}. `value` is the new allowance.
302      */
303     event Approval(address indexed owner, address indexed spender, uint256 value);
304 }
305 
306 // File: contracts/libraries/Math.sol
307 
308 pragma solidity 0.6.12;
309 
310 // a library for performing various math operations
311 
312 library Math {
313     function min(uint x, uint y) internal pure returns (uint z) {
314         z = x < y ? x : y;
315     }
316 
317     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
318     function sqrt(uint y) internal pure returns (uint z) {
319         if (y > 3) {
320             z = y;
321             uint x = y / 2 + 1;
322             while (x < z) {
323                 z = x;
324                 x = (y / x + x) / 2;
325             }
326         } else if (y != 0) {
327             z = 1;
328         }
329     }
330 }
331 
332 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
333 
334 pragma solidity >=0.5.0;
335 
336 interface IUniswapV2Pair {
337     event Approval(address indexed owner, address indexed spender, uint value);
338     event Transfer(address indexed from, address indexed to, uint value);
339 
340     function name() external pure returns (string memory);
341     function symbol() external pure returns (string memory);
342     function decimals() external pure returns (uint8);
343     function totalSupply() external view returns (uint);
344     function balanceOf(address owner) external view returns (uint);
345     function allowance(address owner, address spender) external view returns (uint);
346 
347     function approve(address spender, uint value) external returns (bool);
348     function transfer(address to, uint value) external returns (bool);
349     function transferFrom(address from, address to, uint value) external returns (bool);
350 
351     function DOMAIN_SEPARATOR() external view returns (bytes32);
352     function PERMIT_TYPEHASH() external pure returns (bytes32);
353     function nonces(address owner) external view returns (uint);
354 
355     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
356 
357     event Mint(address indexed sender, uint amount0, uint amount1);
358     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
359     event Swap(
360         address indexed sender,
361         uint amount0In,
362         uint amount1In,
363         uint amount0Out,
364         uint amount1Out,
365         address indexed to
366     );
367     event Sync(uint112 reserve0, uint112 reserve1);
368 
369     function MINIMUM_LIQUIDITY() external pure returns (uint);
370     function factory() external view returns (address);
371     function token0() external view returns (address);
372     function token1() external view returns (address);
373     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
374     function price0CumulativeLast() external view returns (uint);
375     function price1CumulativeLast() external view returns (uint);
376     function kLast() external view returns (uint);
377 
378     function mint(address to) external returns (uint liquidity);
379     function burn(address to) external returns (uint amount0, uint amount1);
380     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
381     function skim(address to) external;
382     function sync() external;
383 
384     function initialize(address, address) external;
385 }
386 
387 // File: @openzeppelin/contracts/math/SafeMath.sol
388 
389 
390 
391 pragma solidity ^0.6.0;
392 
393 /**
394  * @dev Wrappers over Solidity's arithmetic operations with added overflow
395  * checks.
396  *
397  * Arithmetic operations in Solidity wrap on overflow. This can easily result
398  * in bugs, because programmers usually assume that an overflow raises an
399  * error, which is the standard behavior in high level programming languages.
400  * `SafeMath` restores this intuition by reverting the transaction when an
401  * operation overflows.
402  *
403  * Using this library instead of the unchecked operations eliminates an entire
404  * class of bugs, so it's recommended to use it always.
405  */
406 library SafeMath {
407     /**
408      * @dev Returns the addition of two unsigned integers, reverting on
409      * overflow.
410      *
411      * Counterpart to Solidity's `+` operator.
412      *
413      * Requirements:
414      *
415      * - Addition cannot overflow.
416      */
417     function add(uint256 a, uint256 b) internal pure returns (uint256) {
418         uint256 c = a + b;
419         require(c >= a, "SafeMath: addition overflow");
420 
421         return c;
422     }
423 
424     /**
425      * @dev Returns the subtraction of two unsigned integers, reverting on
426      * overflow (when the result is negative).
427      *
428      * Counterpart to Solidity's `-` operator.
429      *
430      * Requirements:
431      *
432      * - Subtraction cannot overflow.
433      */
434     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
435         return sub(a, b, "SafeMath: subtraction overflow");
436     }
437 
438     /**
439      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
440      * overflow (when the result is negative).
441      *
442      * Counterpart to Solidity's `-` operator.
443      *
444      * Requirements:
445      *
446      * - Subtraction cannot overflow.
447      */
448     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
449         require(b <= a, errorMessage);
450         uint256 c = a - b;
451 
452         return c;
453     }
454 
455     /**
456      * @dev Returns the multiplication of two unsigned integers, reverting on
457      * overflow.
458      *
459      * Counterpart to Solidity's `*` operator.
460      *
461      * Requirements:
462      *
463      * - Multiplication cannot overflow.
464      */
465     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
466         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
467         // benefit is lost if 'b' is also tested.
468         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
469         if (a == 0) {
470             return 0;
471         }
472 
473         uint256 c = a * b;
474         require(c / a == b, "SafeMath: multiplication overflow");
475 
476         return c;
477     }
478 
479     /**
480      * @dev Returns the integer division of two unsigned integers. Reverts on
481      * division by zero. The result is rounded towards zero.
482      *
483      * Counterpart to Solidity's `/` operator. Note: this function uses a
484      * `revert` opcode (which leaves remaining gas untouched) while Solidity
485      * uses an invalid opcode to revert (consuming all remaining gas).
486      *
487      * Requirements:
488      *
489      * - The divisor cannot be zero.
490      */
491     function div(uint256 a, uint256 b) internal pure returns (uint256) {
492         return div(a, b, "SafeMath: division by zero");
493     }
494 
495     /**
496      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
497      * division by zero. The result is rounded towards zero.
498      *
499      * Counterpart to Solidity's `/` operator. Note: this function uses a
500      * `revert` opcode (which leaves remaining gas untouched) while Solidity
501      * uses an invalid opcode to revert (consuming all remaining gas).
502      *
503      * Requirements:
504      *
505      * - The divisor cannot be zero.
506      */
507     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
508         require(b > 0, errorMessage);
509         uint256 c = a / b;
510         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
511 
512         return c;
513     }
514 
515     /**
516      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
517      * Reverts when dividing by zero.
518      *
519      * Counterpart to Solidity's `%` operator. This function uses a `revert`
520      * opcode (which leaves remaining gas untouched) while Solidity uses an
521      * invalid opcode to revert (consuming all remaining gas).
522      *
523      * Requirements:
524      *
525      * - The divisor cannot be zero.
526      */
527     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
528         return mod(a, b, "SafeMath: modulo by zero");
529     }
530 
531     /**
532      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
533      * Reverts with custom message when dividing by zero.
534      *
535      * Counterpart to Solidity's `%` operator. This function uses a `revert`
536      * opcode (which leaves remaining gas untouched) while Solidity uses an
537      * invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
544         require(b != 0, errorMessage);
545         return a % b;
546     }
547 }
548 
549 // File: contracts/libraries/UniswapV2Library.sol
550 
551 pragma solidity >=0.5.0;
552 
553 
554 
555 library UniswapV2Library {
556     using SafeMath for uint;
557 
558     // returns sorted token addresses, used to handle return values from pairs sorted in this order
559     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
560         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
561         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
562         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
563     }
564 
565     // calculates the CREATE2 address for a pair without making any external calls
566     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
567         (address token0, address token1) = sortTokens(tokenA, tokenB);
568         pair = address(uint(keccak256(abi.encodePacked(
569                 hex'ff',
570                 factory,
571                 keccak256(abi.encodePacked(token0, token1)),
572                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
573             ))));
574     }
575 
576     // fetches and sorts the reserves for a pair
577     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
578         (address token0,) = sortTokens(tokenA, tokenB);
579         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
580         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
581     }
582 
583     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
584     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
585         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
586         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
587         amountB = amountA.mul(reserveB) / reserveA;
588     }
589 
590     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
591     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
592         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
593         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
594         uint amountInWithFee = amountIn.mul(997);
595         uint numerator = amountInWithFee.mul(reserveOut);
596         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
597         amountOut = numerator / denominator;
598     }
599 
600     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
601     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
602         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
603         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
604         uint numerator = reserveIn.mul(amountOut).mul(1000);
605         uint denominator = reserveOut.sub(amountOut).mul(997);
606         amountIn = (numerator / denominator).add(1);
607     }
608 
609     // performs chained getAmountOut calculations on any number of pairs
610     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
611         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
612         amounts = new uint[](path.length);
613         amounts[0] = amountIn;
614         for (uint i; i < path.length - 1; i++) {
615             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
616             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
617         }
618     }
619 
620     // performs chained getAmountIn calculations on any number of pairs
621     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
622         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
623         amounts = new uint[](path.length);
624         amounts[amounts.length - 1] = amountOut;
625         for (uint i = path.length - 1; i > 0; i--) {
626             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
627             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
628         }
629     }
630 }
631 
632 // File: contracts/ICoreVault.sol
633 
634 pragma solidity ^0.6.0;
635 
636 
637 interface ICoreVault {
638     function addPendingRewards(uint _amount) external;
639         function depositFor(address depositFor, uint256 _pid, uint256 _amount) external;
640 }
641 
642 // File: contracts/COREv1Router.sol
643 
644 pragma solidity 0.6.12;
645 
646 
647 
648 // import "./uniswapv2/interfaces/IUniswapV2Pair.sol";
649 
650 
651 
652 
653 
654 
655 
656 contract COREv1Router is OwnableUpgradeSafe {
657 
658     using SafeMath for uint256;
659     mapping(address => uint256) public hardCORE;
660 
661     address public _coreToken;
662     address public _coreWETHPair;
663     IFeeApprover public _feeApprover;
664     ICoreVault public _coreVault;
665     IWETH public _WETH;
666     address public _uniV2Factory;
667 
668     function initialize(address coreToken, address WETH, address uniV2Factory, address coreWethPair, address feeApprover, address coreVault) public initializer {
669         OwnableUpgradeSafe.__Ownable_init();
670         _coreToken = coreToken;
671         _WETH = IWETH(WETH);
672         _uniV2Factory = uniV2Factory;
673         _feeApprover = IFeeApprover(feeApprover);
674         _coreWETHPair = coreWethPair;
675         _coreVault = ICoreVault(coreVault);
676         refreshApproval();
677     }
678 
679     function refreshApproval() public {
680         IUniswapV2Pair(_coreWETHPair).approve(address(_coreVault), uint(-1));
681     }
682 
683     event FeeApproverChanged(address indexed newAddress, address indexed oldAddress);
684 
685     fallback() external payable {
686         if(msg.sender != address(_WETH)){
687              addLiquidityETHOnly(msg.sender, false);
688         }
689     }
690 
691 
692     function addLiquidityETHOnly(address payable to, bool autoStake) public payable {
693         require(to != address(0), "Invalid address");
694         hardCORE[msg.sender] = hardCORE[msg.sender].add(msg.value);
695 
696         uint256 buyAmount = msg.value.div(2);
697         require(buyAmount > 0, "Insufficient ETH amount");
698         _WETH.deposit{value : msg.value}();
699 
700         (uint256 reserveWeth, uint256 reserveCore) = getPairReserves();
701         uint256 outCore = UniswapV2Library.getAmountOut(buyAmount, reserveWeth, reserveCore);
702         
703         _WETH.transfer(_coreWETHPair, buyAmount);
704 
705         (address token0, address token1) = UniswapV2Library.sortTokens(address(_WETH), _coreToken);
706         IUniswapV2Pair(_coreWETHPair).swap(_coreToken == token0 ? outCore : 0, _coreToken == token1 ? outCore : 0, address(this), "");
707 
708         _addLiquidity(outCore, buyAmount, to, autoStake);
709 
710         _feeApprover.sync();
711     }
712 
713     function _addLiquidity(uint256 coreAmount, uint256 wethAmount, address payable to, bool autoStake) internal {
714         (uint256 wethReserve, uint256 coreReserve) = getPairReserves();
715 
716         uint256 optimalCoreAmount = UniswapV2Library.quote(wethAmount, wethReserve, coreReserve);
717 
718         uint256 optimalWETHAmount;
719         if (optimalCoreAmount > coreAmount) {
720             optimalWETHAmount = UniswapV2Library.quote(coreAmount, coreReserve, wethReserve);
721             optimalCoreAmount = coreAmount;
722         }
723         else
724             optimalWETHAmount = wethAmount;
725 
726         assert(_WETH.transfer(_coreWETHPair, optimalWETHAmount));
727         assert(IERC20(_coreToken).transfer(_coreWETHPair, optimalCoreAmount));
728 
729         if (autoStake) {
730             IUniswapV2Pair(_coreWETHPair).mint(address(this));
731             _coreVault.depositFor(to, 0, IUniswapV2Pair(_coreWETHPair).balanceOf(address(this)));
732         }
733         else
734             IUniswapV2Pair(_coreWETHPair).mint(to);
735         
736 
737         //refund dust
738         if (coreAmount > optimalCoreAmount)
739             IERC20(_coreToken).transfer(to, coreAmount.sub(optimalCoreAmount));
740 
741         if (wethAmount > optimalWETHAmount) {
742             uint256 withdrawAmount = wethAmount.sub(optimalWETHAmount);
743             _WETH.withdraw(withdrawAmount);
744             to.transfer(withdrawAmount);
745         }
746     }
747 
748     function changeFeeApprover(address feeApprover) external onlyOwner {
749         address oldAddress = address(_feeApprover);
750         _feeApprover = IFeeApprover(feeApprover);
751 
752         emit FeeApproverChanged(feeApprover, oldAddress);    
753     }
754 
755 
756     function getLPTokenPerEthUnit(uint ethAmt) public view  returns (uint liquidity){
757         (uint256 reserveWeth, uint256 reserveCore) = getPairReserves();
758         uint256 outCore = UniswapV2Library.getAmountOut(ethAmt.div(2), reserveWeth, reserveCore);
759         uint _totalSupply =  IUniswapV2Pair(_coreWETHPair).totalSupply();
760 
761         (address token0, ) = UniswapV2Library.sortTokens(address(_WETH), _coreToken);
762         (uint256 amount0, uint256 amount1) = token0 == _coreToken ? (outCore, ethAmt.div(2)) : (ethAmt.div(2), outCore);
763         (uint256 _reserve0, uint256 _reserve1) = token0 == _coreToken ? (reserveCore, reserveWeth) : (reserveWeth, reserveCore);
764         liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
765 
766 
767     }
768 
769     function getPairReserves() internal view returns (uint256 wethReserves, uint256 coreReserves) {
770         (address token0,) = UniswapV2Library.sortTokens(address(_WETH), _coreToken);
771         (uint256 reserve0, uint reserve1,) = IUniswapV2Pair(_coreWETHPair).getReserves();
772         (wethReserves, coreReserves) = token0 == _coreToken ? (reserve1, reserve0) : (reserve0, reserve1);
773     }
774 
775 }