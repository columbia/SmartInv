1 // SPDX-License-Identifier: MIT
2 
3 /*
4 MIT License
5 
6 Copyright (c) 2018 requestnetwork
7 Copyright (c) 2018 Fragments, Inc.
8 Copyright (c) 2020 Ditto Money
9 Copyright (c) 2021 Goes Up Higher
10 Copyright (c) 2021 Cryptographic Ultra Money
11 
12 Permission is hereby granted, free of charge, to any person obtaining a copy
13 of this software and associated documentation files (the "Software"), to deal
14 in the Software without restriction, including without limitation the rights
15 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 copies of the Software, and to permit persons to whom the Software is
17 furnished to do so, subject to the following conditions:
18 
19 The above copyright notice and this permission notice shall be included in all
20 copies or substantial portions of the Software.
21 
22 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
25 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
28 SOFTWARE.
29 */
30 
31 pragma solidity ^0.6.0;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address payable) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes memory) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that revert on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, reverts on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
56     // benefit is lost if 'b' is also tested.
57     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58     if (a == 0) {
59       return 0;
60     }
61 
62     uint256 c = a * b;
63     require(c / a == b);
64 
65     return c;
66   }
67 
68   /**
69   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
70   */
71   function div(uint256 a, uint256 b) internal pure returns (uint256) {
72     require(b > 0); // Solidity only automatically asserts when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76     return c;
77   }
78 
79   /**
80   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83     require(b <= a);
84     uint256 c = a - b;
85 
86     return c;
87   }
88 
89   /**
90   * @dev Adds two numbers, reverts on overflow.
91   */
92   function add(uint256 a, uint256 b) internal pure returns (uint256) {
93     uint256 c = a + b;
94     require(c >= a);
95 
96     return c;
97   }
98 
99   /**
100   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
101   * reverts when dividing by zero.
102   */
103   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104     require(b != 0);
105     return a % b;
106   }
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 interface IERC20 {
114   function totalSupply() external view returns (uint256);
115 
116   function balanceOf(address who) external view returns (uint256);
117 
118   function allowance(address owner, address spender)
119     external view returns (uint256);
120 
121   function transfer(address to, uint256 value) external returns (bool);
122 
123   function approve(address spender, uint256 value)
124     external returns (bool);
125 
126   function transferFrom(address from, address to, uint256 value)
127     external returns (bool);
128 
129   event Transfer(
130     address indexed from,
131     address indexed to,
132     uint256 value
133   );
134 
135   event Approval(
136     address indexed owner,
137     address indexed spender,
138     uint256 value
139   );
140 }
141 
142 interface ILP {
143     function sync() external;
144 }
145 
146 
147 abstract contract ERC20Detailed is IERC20 {
148     string private _name;
149     string private _symbol;
150     uint8 private _decimals;
151 
152     /**
153      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
154      * these values are immutable: they can only be set once during
155      * construction.
156      */
157     constructor (string memory name, string memory symbol, uint8 decimals) public {
158         _name = name;
159         _symbol = symbol;
160         _decimals = decimals;
161     }
162 
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() public view returns (string memory) {
167         return _name;
168     }
169 
170     /**
171      * @dev Returns the symbol of the token, usually a shorter version of the
172      * name.
173      */
174     function symbol() public view returns (string memory) {
175         return _symbol;
176     }
177 
178     /**
179      * @dev Returns the number of decimals used to get its user representation.
180      * For example, if `decimals` equals `2`, a balance of `505` tokens should
181      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
182      *
183      * Tokens usually opt for a value of 18, imitating the relationship between
184      * Ether and Wei.
185      *
186      * NOTE: This information is only used for _display_ purposes: it in
187      * no way affects any of the arithmetic of the contract, including
188      * {IERC20-balanceOf} and {IERC20-transfer}.
189      */
190     function decimals() public view returns (uint8) {
191         return _decimals;
192     }
193 }
194 
195 /**
196  * @title SafeMathInt
197  * @dev Math operations for int256 with overflow safety checks.
198  */
199 library SafeMathInt {
200     int256 private constant MIN_INT256 = int256(1) << 255;
201     int256 private constant MAX_INT256 = ~(int256(1) << 255);
202 
203     /**
204      * @dev Multiplies two int256 variables and fails on overflow.
205      */
206     function mul(int256 a, int256 b)
207         internal
208         pure
209         returns (int256)
210     {
211         int256 c = a * b;
212 
213         // Detect overflow when multiplying MIN_INT256 with -1
214         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
215         require((b == 0) || (c / b == a));
216         return c;
217     }
218 
219     /**
220      * @dev Division of two int256 variables and fails on overflow.
221      */
222     function div(int256 a, int256 b)
223         internal
224         pure
225         returns (int256)
226     {
227         // Prevent overflow when dividing MIN_INT256 by -1
228         require(b != -1 || a != MIN_INT256);
229 
230         // Solidity already throws when dividing by 0.
231         return a / b;
232     }
233 
234     /**
235      * @dev Subtracts two int256 variables and fails on overflow.
236      */
237     function sub(int256 a, int256 b)
238         internal
239         pure
240         returns (int256)
241     {
242         int256 c = a - b;
243         require((b >= 0 && c <= a) || (b < 0 && c > a));
244         return c;
245     }
246 
247     /**
248      * @dev Adds two int256 variables and fails on overflow.
249      */
250     function add(int256 a, int256 b)
251         internal
252         pure
253         returns (int256)
254     {
255         int256 c = a + b;
256         require((b >= 0 && c >= a) || (b < 0 && c < a));
257         return c;
258     }
259 
260     /**
261      * @dev Converts to absolute value, and fails on overflow.
262      */
263     function abs(int256 a)
264         internal
265         pure
266         returns (int256)
267     {
268         require(a != MIN_INT256);
269         return a < 0 ? -a : a;
270     }
271 }
272 
273 
274 /**
275  * @title Ownable
276  * @dev The Ownable contract has an owner address, and provides basic authorization control
277  * functions, this simplifies the implementation of "user permissions".
278  */
279 contract Ownable {
280   address private _owner;
281   address private _previousOwner;
282   uint256 private _lockTime;
283 
284 
285   event OwnershipRenounced(address indexed previousOwner);
286   
287   event OwnershipTransferred(
288     address indexed previousOwner,
289     address indexed newOwner
290   );
291 
292 
293   /**
294    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
295    * account.
296    */
297   constructor() public {
298     _owner = msg.sender;
299   }
300 
301   /**
302    * @return the address of the owner.
303    */
304   function owner() public view returns(address) {
305     return _owner;
306   }
307 
308   /**
309    * @dev Throws if called by any account other than the owner.
310    */
311   modifier onlyOwner() {
312     require(isOwner());
313     _;
314   }
315 
316   /**
317    * @return true if `msg.sender` is the owner of the contract.
318    */
319   function isOwner() public view returns(bool) {
320     return msg.sender == _owner;
321   }
322 
323   /**
324    * @dev Allows the current owner to relinquish control of the contract.
325    * @notice Renouncing to ownership will leave the contract without an owner.
326    * It will not be possible to call the functions with the `onlyOwner`
327    * modifier anymore.
328    */
329   function renounceOwnership() public onlyOwner {
330     emit OwnershipRenounced(_owner);
331     _owner = address(0);
332   }
333 
334   /**
335    * @dev Allows the current owner to transfer control of the contract to a newOwner.
336    * @param newOwner The address to transfer ownership to.
337    */
338   function transferOwnership(address newOwner) public onlyOwner {
339     _transferOwnership(newOwner);
340   }
341 
342   /**
343    * @dev Transfers control of the contract to a newOwner.
344    * @param newOwner The address to transfer ownership to.
345    */
346   function _transferOwnership(address newOwner) internal {
347     emit OwnershipTransferred(_owner, newOwner);
348     _owner = newOwner;
349   }
350   
351   function getUnlockTime() public view returns (uint256) {return _lockTime;}
352   	
353   function lock(uint256 time) public virtual onlyOwner {
354 	_previousOwner = _owner;
355 	_owner = address(0);
356 	_lockTime = block.timestamp + time;
357 	emit OwnershipTransferred(_owner, address(0));
358 	}
359 	
360   function unlock() public virtual {
361 	require(_previousOwner == msg.sender, "You don't have permission to unlock");
362 	require(block.timestamp > _lockTime , "Contract is locked");
363 	emit OwnershipTransferred(_owner, _previousOwner);
364 	_owner = _previousOwner;
365 	}
366 }
367 
368 interface IUniswapV2Factory {
369 	event PairCreated(address indexed token0, address indexed token1, address pair, uint);
370 	function feeTo() external view returns (address);
371 	function feeToSetter() external view returns (address);
372 	function getPair(address tokenA, address tokenB) external view returns (address pair);
373 	function allPairs(uint) external view returns (address pair);
374 	function allPairsLength() external view returns (uint);
375 	function createPair(address tokenA, address tokenB) external returns (address pair);
376 	function setFeeTo(address) external;
377 	function setFeeToSetter(address) external;
378 }
379 
380 interface IUniswapV2Pair {
381 	event Approval(address indexed owner, address indexed spender, uint value);
382 	event Transfer(address indexed from, address indexed to, uint value);
383 	function name() external pure returns (string memory);
384 	function symbol() external pure returns (string memory);
385 	function decimals() external pure returns (uint8);
386 	function totalSupply() external view returns (uint);
387 	function balanceOf(address owner) external view returns (uint);
388 	function allowance(address owner, address spender) external view returns (uint);
389 	function approve(address spender, uint value) external returns (bool);
390 	function transfer(address to, uint value) external returns (bool);
391 	function transferFrom(address from, address to, uint value) external returns (bool);
392 	function DOMAIN_SEPARATOR() external view returns (bytes32);
393 	function PERMIT_TYPEHASH() external pure returns (bytes32);
394 	function nonces(address owner) external view returns (uint);
395 	function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
396 	event Mint(address indexed sender, uint amount0, uint amount1);
397 	event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
398 	event Swap(address indexed sender, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out, address indexed to);
399 	event Sync(uint112 reserve0, uint112 reserve1);
400 	function MINIMUM_LIQUIDITY() external pure returns (uint);
401 	function factory() external view returns (address);
402 	function token0() external view returns (address);
403 	function token1() external view returns (address);
404 	function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
405 	function price0CumulativeLast() external view returns (uint);
406 	function price1CumulativeLast() external view returns (uint);
407 	function kLast() external view returns (uint);
408 	function mint(address to) external returns (uint liquidity);
409 	function burn(address to) external returns (uint amount0, uint amount1);
410 	function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
411 	function skim(address to) external;
412 	function sync() external;
413 	function initialize(address, address) external;
414 }
415 
416 interface IUniswapV2Router01 {
417 	function factory() external pure returns (address);
418 	function WETH() external pure returns (address);
419 	function addLiquidity( address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline
420 	) external returns (uint amountA, uint amountB, uint liquidity);
421 	function addLiquidityETH( address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline
422 	) external payable returns (uint amountToken, uint amountETH, uint liquidity);
423 	function removeLiquidity( address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline
424 	) external returns (uint amountA, uint amountB);
425 	function removeLiquidityETH( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline
426 	) external returns (uint amountToken, uint amountETH);
427 	function removeLiquidityWithPermit( address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s
428 	) external returns (uint amountA, uint amountB);
429 	function removeLiquidityETHWithPermit( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s
430 	) external returns (uint amountToken, uint amountETH);
431 	function swapExactTokensForTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline
432 	) external returns (uint[] memory amounts);
433 	function swapTokensForExactTokens( uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline
434 	) external returns (uint[] memory amounts);
435 	function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
436 	function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
437 	function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
438 	function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
439 	function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
440 	function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
441 	function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
442 	function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
443 	function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
444 }
445 
446 interface IUniswapV2Router02 is IUniswapV2Router01 {
447 	function removeLiquidityETHSupportingFeeOnTransferTokens( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline
448 	) external returns (uint amountETH);
449 	function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s
450 	) external returns (uint amountETH);
451 	function swapExactTokensForTokensSupportingFeeOnTransferTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline
452 	) external;
453 	function swapExactETHForTokensSupportingFeeOnTransferTokens( uint amountOutMin, address[] calldata path, address to, uint deadline
454 	) external payable;
455 	function swapExactTokensForETHSupportingFeeOnTransferTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline
456 	) external;
457 }
458 
459 
460 /**
461  * @title CUM ERC20 token
462  * @dev  
463  *      The goal of CUM is to be hardest money.
464  *      Based on the Ampleforth protocol.
465  */
466 contract CUM is Context, ERC20Detailed, Ownable {
467     using SafeMath for uint256;
468     using SafeMathInt for int256;
469     
470     mapping (address => bool) private _isExcludedFromFee;
471 
472 	address BURN_ADDRESS = 0x0000000000000000000000000000000000000001;
473 	address public liq_locker;
474 	
475 	uint256 public _liquidityFee = 4;
476     uint256 private _previousLiquidityFee = _liquidityFee;
477     
478     uint256 public _burnFee = 2;
479 	uint256 private _previousBurnFee = _burnFee;
480 	
481 	IUniswapV2Router02 public immutable uniswapV2Router;
482     address public immutable uniswapV2Pair;
483     
484     bool inSwapAndLiquify;
485     bool public swapAndLiquifyEnabled = true;
486     
487     uint256 public numTokensSellToAddToLiquidity = 66666 * 10**2 * 10**DECIMALS;
488     
489     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
490     event SwapAndLiquifyEnabledUpdated(bool enabled);
491     event SetLPEvent(address lpAddress);
492     event SetLLEvent(address llAddress);
493     event AddressExcluded(address exAddress);
494     event SwapAndLiquify(
495         uint256 tokensSwapped,
496         uint256 ethReceived,
497         uint256 tokensIntoLiqudity
498     );
499     
500     modifier lockTheSwap {
501         inSwapAndLiquify = true;
502         _;
503         inSwapAndLiquify = false;
504     }
505 
506     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
507 
508     // Used for authentication
509     address public master;
510     
511     // LP atomic sync
512     address public lp;
513     ILP public lpContract;
514 
515     modifier onlyMaster() {
516         require(msg.sender == master);
517         _;
518     }
519     
520     // Only the owner can transfer tokens in the initial phase.
521     // This is allow the AMM listing to happen in an orderly fashion.
522     
523     bool public initialDistributionFinished;
524     
525     mapping (address => bool) allowTransfer;
526     
527     modifier initialDistributionLock {
528         require(initialDistributionFinished || isOwner() || allowTransfer[msg.sender]);
529         _;
530     }
531 
532     modifier validRecipient(address to) {
533         require(to != address(0x0));
534         require(to != address(this));
535         _;
536     }
537 
538     uint256 private constant DECIMALS = 9;
539     uint256 private constant MAX_UINT256 = ~uint256(0);
540     
541     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 66666 * 10**6 * 10**DECIMALS;
542 
543     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
544     // Use the highest value that fits in a uint256 for max granularity.
545     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
546 
547     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
548     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
549 
550     uint256 private _totalSupply;
551     uint256 private _gonsPerFragment;
552     mapping(address => uint256) private _gonBalances;
553 
554     // This is denominated in Fragments, because the gons-fragments conversion might change before
555     // it's fully paid.
556     mapping (address => mapping (address => uint256)) private _allowedFragments;
557 
558     /**
559      * @dev Notifies Fragments contract about a new rebase cycle.
560      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
561      * @return The total number of fragments after the supply adjustment.
562      */
563     function rebase(uint256 epoch, int256 supplyDelta)
564         external
565         onlyMaster
566         returns (uint256)
567     {
568         if (supplyDelta == 0) {
569             emit LogRebase(epoch, _totalSupply);
570             return _totalSupply;
571         }
572 
573         if (supplyDelta < 0) {
574             _totalSupply = _totalSupply.sub(uint256(-supplyDelta));
575         } else {
576             _totalSupply = _totalSupply.add(uint256(supplyDelta));
577         }
578 
579         if (_totalSupply > MAX_SUPPLY) {
580             _totalSupply = MAX_SUPPLY;
581         }
582         
583         numTokensSellToAddToLiquidity = _totalSupply.div(10000);
584 
585         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
586         lpContract.sync();
587 
588         emit LogRebase(epoch, _totalSupply);
589         return _totalSupply;
590     }
591 
592     constructor()
593         ERC20Detailed("Cryptographic Ultra Money", "CUM", uint8(DECIMALS))
594         public
595     {
596         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
597         _gonBalances[msg.sender] = TOTAL_GONS;
598         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
599         
600         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
601 		uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
602 		uniswapV2Router = _uniswapV2Router;
603 
604         _isExcludedFromFee[owner()] = true;
605 		_isExcludedFromFee[address(this)] = true;
606 		_isExcludedFromFee[BURN_ADDRESS] = true;
607         initialDistributionFinished = false;
608         emit Transfer(address(0x0), msg.sender, _totalSupply);
609     }
610 
611     /**
612      * @notice Sets a new master
613      */
614     function setMaster(address masterAddress)
615         external
616         onlyOwner
617         returns (uint256)
618     {
619         master = masterAddress;
620     }
621     
622     /**
623      * @notice Sets contract LP address
624      */
625     function setLP(address lpAddress)
626         external
627         onlyOwner
628         returns (uint256)
629     {
630         lp = lpAddress;
631         lpContract = ILP(lp);
632         emit SetLPEvent(lp);
633     }
634     
635     /**
636      * @notice Sets Liquidity Locker address
637      */
638     function setLiqLocker(address llAddress)
639         external
640         onlyOwner
641         returns (uint256)
642     {
643         liq_locker = llAddress;
644         _isExcludedFromFee[liq_locker] = true;
645         emit SetLLEvent(liq_locker);
646     }
647 
648     
649     /**
650      * @notice Adds excluded address
651      */
652     function excludeFromFeeAdd(address exAddress)
653         external
654         onlyOwner
655         returns (uint256)
656     {
657         _isExcludedFromFee[exAddress] = true;
658         emit AddressExcluded(exAddress);
659     }
660     
661     function excludeFromFeeRemove(address exAddress)
662         external
663         onlyOwner
664         returns (uint256)
665     {
666         _isExcludedFromFee[exAddress] = false;
667     }
668 
669     /**
670      * @return The total number of fragments.
671      */
672     function totalSupply()
673         public
674         view
675         override
676         returns (uint256)
677     {
678         return _totalSupply;
679     }
680 
681     /**
682      * @param who The address to query.
683      * @return The balance of the specified address.
684      */
685     function balanceOf(address who)
686         public
687         view
688         override
689         returns (uint256)
690     {
691         return _gonBalances[who].div(_gonsPerFragment);
692     }
693     
694     function _approve(address owner, address spender, uint256 value) internal virtual {
695         require(owner != address(0), "ERC20: approve from the zero address");
696         require(spender != address(0), "ERC20: approve to the zero address");
697 
698         _allowedFragments[owner][spender] = value;
699         emit Approval(owner, spender, value);
700     }
701 
702     /**
703      * @dev Transfer tokens to a specified address.
704      * @param to The address to transfer to.
705      * @param value The amount to be transferred.
706      * @return True on success, false otherwise.
707      */
708     function transfer(address to, uint256 value)
709         public
710         validRecipient(to)
711         initialDistributionLock
712         override
713         returns (bool)
714     {
715         _transfer(_msgSender(), to, value);
716         return true;
717     }
718 
719     /**
720      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
721      * @param owner_ The address which owns the funds.
722      * @param spender The address which will spend the funds.
723      * @return The number of tokens still available for the spender.
724      */
725     function allowance(address owner_, address spender)
726         public
727         view
728         override
729         returns (uint256)
730     {
731         return _allowedFragments[owner_][spender];
732     }
733 
734     /**
735      * @dev Transfer tokens from one address to another.
736      * @param sender The address you want to send tokens from.
737      * @param recipient The address you want to transfer to.
738      * @param value The amount of tokens to be transferred.
739      */
740     function transferFrom(address sender, address recipient, uint256 value)
741         public
742         validRecipient(recipient)
743         override
744         returns (bool)
745     {
746         _transfer(sender, recipient, value);
747         _approve(sender, _msgSender(), _allowedFragments[sender][_msgSender()].sub(value));
748         return true;
749     }
750 
751     /**
752      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
753      * msg.sender. This method is included for ERC20 compatibility.
754      * increaseAllowance and decreaseAllowance should be used instead.
755      * Changing an allowance with this method brings the risk that someone may transfer both
756      * the old and the new allowance - if they are both greater than zero - if a transfer
757      * transaction is mined before the later approve() call is mined.
758      *
759      * @param spender The address which will spend the funds.
760      * @param value The amount of tokens to be spent.
761      */
762     function approve(address spender, uint256 value)
763         public
764         initialDistributionLock
765         override
766         returns (bool)
767     {
768         _allowedFragments[_msgSender()][spender] = value;
769         emit Approval(_msgSender(), spender, value);
770         return true;
771     }
772 
773     /**
774      * @dev Increase the amount of tokens that an owner has allowed to a spender.
775      * This method should be used instead of approve() to avoid the double approval vulnerability
776      * described above.
777      * @param spender The address which will spend the funds.
778      * @param addedValue The amount of tokens to increase the allowance by.
779      */
780     function increaseAllowance(address spender, uint256 addedValue)
781         external
782         initialDistributionLock
783         returns (bool)
784     {
785         _allowedFragments[_msgSender()][spender] = _allowedFragments[_msgSender()][spender].add(addedValue);
786         emit Approval(_msgSender(), spender, _allowedFragments[_msgSender()][spender]);
787         return true;
788     }
789 
790     /**
791      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
792      *
793      * @param spender The address which will spend the funds.
794      * @param subtractedValue The amount of tokens to decrease the allowance by.
795      */
796     function decreaseAllowance(address spender, uint256 subtractedValue)
797         external
798         initialDistributionLock
799         returns (bool)
800     {
801         uint256 oldValue = _allowedFragments[_msgSender()][spender];
802         if (subtractedValue >= oldValue) {
803             _allowedFragments[_msgSender()][spender] = 0;
804         } else {
805             _allowedFragments[_msgSender()][spender] = oldValue.sub(subtractedValue);
806         }
807         emit Approval(_msgSender(), spender, _allowedFragments[_msgSender()][spender]);
808         return true;
809     }
810     
811     function setInitialDistributionFinished()
812         external 
813         onlyOwner 
814     {
815         initialDistributionFinished = true;
816     }
817     
818     function enableTransfer(address _addr)
819         external 
820         onlyOwner 
821     {
822         allowTransfer[_addr] = true;
823     }
824     
825     function removeAllFee() private {
826         if(_burnFee == 0 && _liquidityFee == 0) return;
827         
828         _previousBurnFee = _burnFee;
829         _previousLiquidityFee = _liquidityFee;
830         
831         _burnFee = 0;
832         _liquidityFee = 0;
833     }
834     
835     function restoreAllFee() private {
836         _burnFee = _previousBurnFee;
837         _liquidityFee = _previousLiquidityFee;
838     }
839     
840     function isExcludedFromFee(address account) public view returns(bool) {
841         return _isExcludedFromFee[account];
842     }
843 
844     function _transfer(
845 		address from,
846 		address to,
847 		uint256 amount
848 	) private {
849 		require(from != address(0), "ERC20: transfer from the zero address");
850 		require(to != address(0), "ERC20: transfer to the zero address");
851 		require(amount > 0, "Transfer amount must be greater than zero");
852 		
853 		uint256 contractTokenBalance = balanceOf(address(this));
854 
855         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
856         if (
857             overMinTokenBalance &&
858             !inSwapAndLiquify &&
859             from != uniswapV2Pair &&
860             swapAndLiquifyEnabled
861         ) {
862             contractTokenBalance = numTokensSellToAddToLiquidity;
863             swapAndLiquify(contractTokenBalance);
864         }
865 
866 		bool takeFee = true;
867 		if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
868 			takeFee = false;
869 		}
870 		_tokenTransfer(from, to, amount, takeFee);
871 	}
872 	
873 	function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
874 	    require(burnFee <= 10);
875         _burnFee = burnFee;
876     }
877     
878     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
879 	    require(liquidityFee <= 10);
880         _liquidityFee = liquidityFee;
881     }
882    
883     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
884         swapAndLiquifyEnabled = _enabled;
885         emit SwapAndLiquifyEnabledUpdated(_enabled);
886     }
887     
888     receive() external payable {}
889 
890     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
891         // split the contract balance into halves
892         uint256 half = contractTokenBalance.div(2);
893         uint256 otherHalf = contractTokenBalance.sub(half);
894 
895         // capture the contract's current ETH balance.
896         // this is so that we can capture exactly the amount of ETH that the
897         // swap creates, and not make the liquidity event include any ETH that
898         // has been manually sent to the contract
899         uint256 initialBalance = address(this).balance;
900 
901         // swap tokens for ETH
902         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
903 
904         // how much ETH did we just swap into?
905         uint256 newBalance = address(this).balance.sub(initialBalance);
906 
907         // add liquidity to uniswap
908         addLiquidity(otherHalf, newBalance);
909         
910         emit SwapAndLiquify(half, newBalance, otherHalf);
911     }
912 
913     function swapTokensForEth(uint256 tokenAmount) private {
914         // generate the uniswap pair path of token -> weth
915         address[] memory path = new address[](2);
916         path[0] = address(this);
917         path[1] = uniswapV2Router.WETH();
918 
919         _approve(address(this), address(uniswapV2Router), tokenAmount);
920 
921         // make the swap
922         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
923             tokenAmount,
924             0, // accept any amount of ETH
925             path,
926             address(this),
927             block.timestamp
928         );
929     }
930 
931     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
932         // approve token transfer to cover all possible scenarios
933         _approve(address(this), address(uniswapV2Router), tokenAmount);
934 
935         // add the liquidity
936         uniswapV2Router.addLiquidityETH{value: ethAmount}(
937             address(this),
938             tokenAmount,
939             0, // slippage is unavoidable
940             0, // slippage is unavoidable
941             liq_locker,
942             block.timestamp
943         );
944     }
945 
946 	function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
947 		if(!takeFee)
948 			removeAllFee();		
949 		_transferStandard(sender, recipient, amount);
950 		if(!takeFee)
951 			restoreAllFee();
952 	}
953 	
954 	function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
955 		return _amount.mul(_liquidityFee).div(
956 			10**2
957 		);
958 	}
959 
960 	function calculateBurnFee(uint256 _amount) private view returns (uint256) {
961 		return _amount.mul(_burnFee).div(
962 			10**2
963 		);
964 	}
965 	
966 	function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
967         uint256 tBurn = calculateBurnFee(tAmount);
968         uint256 tLiquidity = calculateLiquidityFee(tAmount);
969         uint256 tTransferAmount = tAmount.sub(tBurn).sub(tLiquidity);
970         return (tTransferAmount, tBurn, tLiquidity);
971     }
972 
973     function _transferBurn(uint256 tBurn) private {
974 		_gonBalances[BURN_ADDRESS] = _gonBalances[BURN_ADDRESS].add(tBurn);
975 	}
976 	
977 	function _takeLiquidity(uint256 tLiquidity) private {
978         _gonBalances[address(this)] = _gonBalances[address(this)].add(tLiquidity);
979     }
980 
981 	function _transferStandard(address sender, address recipient, uint256 tAmount) private {
982 	    uint256 gonValue = tAmount.mul(_gonsPerFragment);
983 	    (uint256 tTransferAmount, uint256 tBurn, uint256 tLiquidity) = _getTValues(gonValue);
984         _gonBalances[sender] = _gonBalances[sender].sub(gonValue);
985 		_gonBalances[recipient] = _gonBalances[recipient].add(tTransferAmount);
986 		_transferBurn(tBurn);
987 		_takeLiquidity(tLiquidity);
988 		emit Transfer(sender, BURN_ADDRESS, tBurn.div(_gonsPerFragment));
989 		emit Transfer(sender, address(this), tLiquidity.div(_gonsPerFragment));
990 		emit Transfer(sender, recipient, tTransferAmount.div(_gonsPerFragment));
991 	}
992 
993 }