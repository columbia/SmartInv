1 // SPDX-License-Identifier: BSD-3-Clause
2 pragma solidity 0.6.11;
3 
4 interface IERC20 {
5 
6     function totalSupply() external view returns (uint256);
7 
8     /**
9      * @dev Returns the amount of tokens owned by `account`.
10      */
11     function balanceOf(address account) external view returns (uint256);
12 
13     /**
14      * @dev Moves `amount` tokens from the caller's account to `recipient`.
15      *
16      * Returns a boolean value indicating whether the operation succeeded.
17      *
18      * Emits a {Transfer} event.
19      */
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     /**
23      * @dev Returns the remaining number of tokens that `spender` will be
24      * allowed to spend on behalf of `owner` through {transferFrom}. This is
25      * zero by default.
26      *
27      * This value changes when {approve} or {transferFrom} are called.
28      */
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     /**
32      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * IMPORTANT: Beware that changing an allowance with this method brings the risk
37      * that someone may use both the old and the new allowance by unfortunate
38      * transaction ordering. One possible solution to mitigate this race
39      * condition is to first reduce the spender's allowance to 0 and set the
40      * desired value afterwards:
41      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
42      *
43      * Emits an {Approval} event.
44      */
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Moves `amount` tokens from `sender` to `recipient` using the
49      * allowance mechanism. `amount` is then deducted from the caller's
50      * allowance.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Emitted when `value` tokens are moved from one account (`from`) to
60      * another (`to`).
61      *
62      * Note that `value` may be zero.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     /**
67      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
68      * a call to {approve}. `value` is the new allowance.
69      */
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 /**
75  * @dev Wrappers over Solidity's arithmetic operations with added overflow
76  * checks.
77  *
78  * Arithmetic operations in Solidity wrap on overflow. This can easily result
79  * in bugs, because programmers usually assume that an overflow raises an
80  * error, which is the standard behavior in high level programming languages.
81  * `SafeMath` restores this intuition by reverting the transaction when an
82  * operation overflows.
83  *
84  * Using this library instead of the unchecked operations eliminates an entire
85  * class of bugs, so it's recommended to use it always.
86  */
87 library SafeMath {
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b <= a, errorMessage);
131         uint256 c = a - b;
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the multiplication of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `*` operator.
141      *
142      * Requirements:
143      *
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts with custom message when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 abstract contract Context {
231     function _msgSender() internal view virtual returns (address payable) {
232         return msg.sender;
233     }
234 
235     function _msgData() internal view virtual returns (bytes memory) {
236         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
237         return msg.data;
238     }
239 }
240 
241 
242 /**
243  * @dev Contract module which provides a basic access control mechanism, where
244  * there is an account (an owner) that can be granted exclusive access to
245  * specific functions.
246  *
247  * By default, the owner account will be the one that deploys the contract. This
248  * can later be changed with {transferOwnership}.
249  *
250  * This module is used through inheritance. It will make available the modifier
251  * `onlyOwner`, which can be applied to your functions to restrict their use to
252  * the owner.
253  */
254 contract Ownable is Context {
255     address private _owner;
256 
257     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
258 
259     /**
260      * @dev Initializes the contract setting the deployer as the initial owner.
261      */
262     constructor () internal {
263         address msgSender = _msgSender();
264         _owner = msgSender;
265         emit OwnershipTransferred(address(0), msgSender);
266     }
267 
268     /**
269      * @dev Returns the address of the current owner.
270      */
271     function owner() public view returns (address) {
272         return _owner;
273     }
274 
275     /**
276      * @dev Throws if called by any account other than the owner.
277      */
278     modifier onlyOwner() {
279         require(_owner == _msgSender(), "Ownable: caller is not the owner");
280         _;
281     }
282 
283     /**
284      * @dev Leaves the contract without owner. It will not be possible to call
285      * `onlyOwner` functions anymore. Can only be called by the current owner.
286      *
287      * NOTE: Renouncing ownership will leave the contract without an owner,
288      * thereby removing any functionality that is only available to the owner.
289      */
290     function renounceOwnership() public virtual onlyOwner {
291         emit OwnershipTransferred(_owner, address(0));
292         _owner = address(0);
293     }
294 
295     /**
296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
297      * Can only be called by the current owner.
298      */
299     function transferOwnership(address newOwner) public virtual onlyOwner {
300         require(newOwner != address(0), "Ownable: new owner is the zero address");
301         emit OwnershipTransferred(_owner, newOwner);
302         _owner = newOwner;
303     }
304 }
305 
306 
307 // pragma solidity >=0.5.0;
308 
309 interface IUniswapV2Factory {
310     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
311 
312     function feeTo() external view returns (address);
313     function feeToSetter() external view returns (address);
314 
315     function getPair(address tokenA, address tokenB) external view returns (address pair);
316     function allPairs(uint) external view returns (address pair);
317     function allPairsLength() external view returns (uint);
318 
319     function createPair(address tokenA, address tokenB) external returns (address pair);
320 
321     function setFeeTo(address) external;
322     function setFeeToSetter(address) external;
323 }
324 
325 
326 // pragma solidity >=0.5.0;
327 
328 interface IUniswapV2Pair {
329     event Approval(address indexed owner, address indexed spender, uint value);
330     event Transfer(address indexed from, address indexed to, uint value);
331 
332     function name() external pure returns (string memory);
333     function symbol() external pure returns (string memory);
334     function decimals() external pure returns (uint8);
335     function totalSupply() external view returns (uint);
336     function balanceOf(address owner) external view returns (uint);
337     function allowance(address owner, address spender) external view returns (uint);
338 
339     function approve(address spender, uint value) external returns (bool);
340     function transfer(address to, uint value) external returns (bool);
341     function transferFrom(address from, address to, uint value) external returns (bool);
342 
343     function DOMAIN_SEPARATOR() external view returns (bytes32);
344     function PERMIT_TYPEHASH() external pure returns (bytes32);
345     function nonces(address owner) external view returns (uint);
346 
347     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
348 
349     event Mint(address indexed sender, uint amount0, uint amount1);
350     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
351     event Swap(
352         address indexed sender,
353         uint amount0In,
354         uint amount1In,
355         uint amount0Out,
356         uint amount1Out,
357         address indexed to
358     );
359     event Sync(uint112 reserve0, uint112 reserve1);
360 
361     function MINIMUM_LIQUIDITY() external pure returns (uint);
362     function factory() external view returns (address);
363     function token0() external view returns (address);
364     function token1() external view returns (address);
365     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
366     function price0CumulativeLast() external view returns (uint);
367     function price1CumulativeLast() external view returns (uint);
368     function kLast() external view returns (uint);
369 
370     function mint(address to) external returns (uint liquidity);
371     function burn(address to) external returns (uint amount0, uint amount1);
372     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
373     function skim(address to) external;
374     function sync() external;
375 
376     function initialize(address, address) external;
377 }
378 
379 // pragma solidity >=0.6.2;
380 
381 interface IUniswapV2Router01 {
382     function factory() external pure returns (address);
383     function WETH() external pure returns (address);
384 
385     function addLiquidity(
386         address tokenA,
387         address tokenB,
388         uint amountADesired,
389         uint amountBDesired,
390         uint amountAMin,
391         uint amountBMin,
392         address to,
393         uint deadline
394     ) external returns (uint amountA, uint amountB, uint liquidity);
395     function addLiquidityETH(
396         address token,
397         uint amountTokenDesired,
398         uint amountTokenMin,
399         uint amountETHMin,
400         address to,
401         uint deadline
402     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
403     function removeLiquidity(
404         address tokenA,
405         address tokenB,
406         uint liquidity,
407         uint amountAMin,
408         uint amountBMin,
409         address to,
410         uint deadline
411     ) external returns (uint amountA, uint amountB);
412     function removeLiquidityETH(
413         address token,
414         uint liquidity,
415         uint amountTokenMin,
416         uint amountETHMin,
417         address to,
418         uint deadline
419     ) external returns (uint amountToken, uint amountETH);
420     function removeLiquidityWithPermit(
421         address tokenA,
422         address tokenB,
423         uint liquidity,
424         uint amountAMin,
425         uint amountBMin,
426         address to,
427         uint deadline,
428         bool approveMax, uint8 v, bytes32 r, bytes32 s
429     ) external returns (uint amountA, uint amountB);
430     function removeLiquidityETHWithPermit(
431         address token,
432         uint liquidity,
433         uint amountTokenMin,
434         uint amountETHMin,
435         address to,
436         uint deadline,
437         bool approveMax, uint8 v, bytes32 r, bytes32 s
438     ) external returns (uint amountToken, uint amountETH);
439     function swapExactTokensForTokens(
440         uint amountIn,
441         uint amountOutMin,
442         address[] calldata path,
443         address to,
444         uint deadline
445     ) external returns (uint[] memory amounts);
446     function swapTokensForExactTokens(
447         uint amountOut,
448         uint amountInMax,
449         address[] calldata path,
450         address to,
451         uint deadline
452     ) external returns (uint[] memory amounts);
453     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
454         external
455         payable
456         returns (uint[] memory amounts);
457     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
458         external
459         returns (uint[] memory amounts);
460     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
461         external
462         returns (uint[] memory amounts);
463     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
464         external
465         payable
466         returns (uint[] memory amounts);
467 
468     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
469     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
470     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
471     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
472     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
473 }
474 
475 
476 // pragma solidity >=0.6.2;
477 
478 interface IUniswapV2Router02 is IUniswapV2Router01 {
479     function removeLiquidityETHSupportingFeeOnTransferTokens(
480         address token,
481         uint liquidity,
482         uint amountTokenMin,
483         uint amountETHMin,
484         address to,
485         uint deadline
486     ) external returns (uint amountETH);
487     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
488         address token,
489         uint liquidity,
490         uint amountTokenMin,
491         uint amountETHMin,
492         address to,
493         uint deadline,
494         bool approveMax, uint8 v, bytes32 r, bytes32 s
495     ) external returns (uint amountETH);
496 
497     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
498         uint amountIn,
499         uint amountOutMin,
500         address[] calldata path,
501         address to,
502         uint deadline
503     ) external;
504     function swapExactETHForTokensSupportingFeeOnTransferTokens(
505         uint amountOutMin,
506         address[] calldata path,
507         address to,
508         uint deadline
509     ) external payable;
510     function swapExactTokensForETHSupportingFeeOnTransferTokens(
511         uint amountIn,
512         uint amountOutMin,
513         address[] calldata path,
514         address to,
515         uint deadline
516     ) external;
517 }
518 
519 
520 contract Cavapoo is Context, IERC20, Ownable {
521     using SafeMath for uint256;
522 
523     mapping (address => uint256) private _rOwned;
524     mapping (address => uint256) private _tOwned;
525     mapping (address => mapping (address => uint256)) private _allowances;
526 
527     mapping (address => bool) private _isExcludedFromFee;
528 
529     mapping (address => bool) private _isExcluded;
530     address[] private _excluded;
531    
532     uint256 private constant MAX = ~uint256(0);
533     uint256 private _tTotal = 10_000_000_000 * 10**6 * 10**9;
534     uint256 private _rTotal = (MAX - (MAX % _tTotal));
535     uint256 private _tFeeTotal;
536 
537     string private _name = "Cavapoo";
538     string private _symbol = "CAVA";
539     uint8 private _decimals = 9;
540     
541     uint256 public _taxFee = 3;
542     uint256 private _previousTaxFee = _taxFee;
543     
544     uint256 public _liquidityFee = 4;
545     uint256 private _previousLiquidityFee = _liquidityFee;
546 
547     IUniswapV2Router02 public immutable uniswapV2Router;
548     address public immutable uniswapV2Pair;
549     
550     bool private inSwapAndLiquify;
551     bool public swapAndLiquifyEnabled = true;
552     
553     uint256 public _maxTxAmount = 100_000_000 * 10**6 * 10**9;
554     uint256 private constant numTokensSellToAddToLiquidity = 500_000 * 10**6 * 10**9;
555     
556     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
557     event SwapAndLiquifyEnabledUpdated(bool enabled);
558     event SwapAndLiquify(
559         uint256 tokensSwapped,
560         uint256 ethReceived,
561         uint256 tokensIntoLiquidity
562     );
563     
564     modifier lockTheSwap {
565         inSwapAndLiquify = true;
566         _;
567         inSwapAndLiquify = false;
568     }
569     
570     constructor () public {
571         _rOwned[_msgSender()] = _rTotal;
572         
573         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
574          // Create a uniswap pair for this new token
575         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
576             .createPair(address(this), _uniswapV2Router.WETH());
577 
578         // set the rest of the contract variables
579         uniswapV2Router = _uniswapV2Router;
580         
581         //exclude owner and this contract from fee
582         _isExcludedFromFee[owner()] = true;
583         _isExcludedFromFee[address(this)] = true;
584         
585         emit Transfer(address(0), _msgSender(), _tTotal);
586     }
587 
588     function name() public view returns (string memory) {
589         return _name;
590     }
591 
592     function symbol() public view returns (string memory) {
593         return _symbol;
594     }
595 
596     function decimals() public view returns (uint8) {
597         return _decimals;
598     }
599 
600     function totalSupply() public view override returns (uint256) {
601         return _tTotal;
602     }
603 
604     function balanceOf(address account) public view override returns (uint256) {
605         if (_isExcluded[account]) return _tOwned[account];
606         return tokenFromReflection(_rOwned[account]);
607     }
608 
609     function transfer(address recipient, uint256 amount) public override returns (bool) {
610         _transfer(_msgSender(), recipient, amount);
611         return true;
612     }
613 
614     function allowance(address owner, address spender) public view override returns (uint256) {
615         return _allowances[owner][spender];
616     }
617 
618     function approve(address spender, uint256 amount) public override returns (bool) {
619         _approve(_msgSender(), spender, amount);
620         return true;
621     }
622 
623     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
624         _transfer(sender, recipient, amount);
625         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
626         return true;
627     }
628 
629     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
630         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
631         return true;
632     }
633 
634     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
635         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
636         return true;
637     }
638 
639     function isExcludedFromReward(address account) public view returns (bool) {
640         return _isExcluded[account];
641     }
642 
643     function totalFees() public view returns (uint256) {
644         return _tFeeTotal;
645     }
646 
647     function deliver(uint256 tAmount) public {
648         address sender = _msgSender();
649         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
650         (uint256 rAmount,,,,,) = _getValues(tAmount);
651         _rOwned[sender] = _rOwned[sender].sub(rAmount);
652         _rTotal = _rTotal.sub(rAmount);
653         _tFeeTotal = _tFeeTotal.add(tAmount);
654     }
655 
656     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
657         require(tAmount <= _tTotal, "Amount must be less than supply");
658         if (!deductTransferFee) {
659             (uint256 rAmount,,,,,) = _getValues(tAmount);
660             return rAmount;
661         } else {
662             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
663             return rTransferAmount;
664         }
665     }
666 
667     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
668         require(rAmount <= _rTotal, "Amount must be less than total reflections");
669         uint256 currentRate =  _getRate();
670         return rAmount.div(currentRate);
671     }
672 
673     function excludeFromReward(address account) public onlyOwner() {
674         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
675         require(!_isExcluded[account], "Account is already excluded");
676         if(_rOwned[account] > 0) {
677             _tOwned[account] = tokenFromReflection(_rOwned[account]);
678         }
679         _isExcluded[account] = true;
680         _excluded.push(account);
681     }
682 
683     function includeInReward(address account) external onlyOwner() {
684         require(_isExcluded[account], "Account is not excluded");
685         for (uint256 i = 0; i < _excluded.length; i++) {
686             if (_excluded[i] == account) {
687                 _excluded[i] = _excluded[_excluded.length - 1];
688                 _tOwned[account] = 0;
689                 _isExcluded[account] = false;
690                 _excluded.pop();
691                 break;
692             }
693         }
694     }
695         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
696         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
697         _tOwned[sender] = _tOwned[sender].sub(tAmount);
698         _rOwned[sender] = _rOwned[sender].sub(rAmount);
699         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
700         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
701         _takeLiquidity(tLiquidity);
702         _reflectFee(rFee, tFee);
703         emit Transfer(sender, recipient, tTransferAmount);
704     }
705     
706         function excludeFromFee(address account) public onlyOwner {
707         _isExcludedFromFee[account] = true;
708     }
709     
710     function includeInFee(address account) public onlyOwner {
711         _isExcludedFromFee[account] = false;
712     }
713     
714     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
715         _taxFee = taxFee;
716     }
717     
718     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
719         _liquidityFee = liquidityFee;
720     }
721    
722     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
723         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
724             10**2
725         );
726     }
727 
728     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
729         swapAndLiquifyEnabled = _enabled;
730         emit SwapAndLiquifyEnabledUpdated(_enabled);
731     }
732     
733      //to receive ETH from uniswapV2Router when swapping
734     receive() external payable {}
735 
736     function _reflectFee(uint256 rFee, uint256 tFee) private {
737         _rTotal = _rTotal.sub(rFee);
738         _tFeeTotal = _tFeeTotal.add(tFee);
739     }
740 
741     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
742         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
743         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
744         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
745     }
746 
747     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
748         uint256 tFee = calculateTaxFee(tAmount);
749         uint256 tLiquidity = calculateLiquidityFee(tAmount);
750         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
751         return (tTransferAmount, tFee, tLiquidity);
752     }
753 
754     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
755         uint256 rAmount = tAmount.mul(currentRate);
756         uint256 rFee = tFee.mul(currentRate);
757         uint256 rLiquidity = tLiquidity.mul(currentRate);
758         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
759         return (rAmount, rTransferAmount, rFee);
760     }
761 
762     function _getRate() private view returns(uint256) {
763         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
764         return rSupply.div(tSupply);
765     }
766 
767     function _getCurrentSupply() private view returns(uint256, uint256) {
768         uint256 rSupply = _rTotal;
769         uint256 tSupply = _tTotal;      
770         for (uint256 i = 0; i < _excluded.length; i++) {
771             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
772             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
773             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
774         }
775         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
776         return (rSupply, tSupply);
777     }
778     
779     function _takeLiquidity(uint256 tLiquidity) private {
780         uint256 currentRate =  _getRate();
781         uint256 rLiquidity = tLiquidity.mul(currentRate);
782         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
783         if(_isExcluded[address(this)])
784             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
785     }
786     
787     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
788         return _amount.mul(_taxFee).div(
789             10**2
790         );
791     }
792 
793     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
794         return _amount.mul(_liquidityFee).div(
795             10**2
796         );
797     }
798     
799     function removeAllFee() private {
800         if(_taxFee == 0 && _liquidityFee == 0) return;
801         
802         _previousTaxFee = _taxFee;
803         _previousLiquidityFee = _liquidityFee;
804         
805         _taxFee = 0;
806         _liquidityFee = 0;
807     }
808     
809     function restoreAllFee() private {
810         _taxFee = _previousTaxFee;
811         _liquidityFee = _previousLiquidityFee;
812     }
813     
814     function isExcludedFromFee(address account) public view returns(bool) {
815         return _isExcludedFromFee[account];
816     }
817 
818     function _approve(address owner, address spender, uint256 amount) private {
819         require(owner != address(0), "ERC20: approve from the zero address");
820         require(spender != address(0), "ERC20: approve to the zero address");
821 
822         _allowances[owner][spender] = amount;
823         emit Approval(owner, spender, amount);
824     }
825 
826     function _transfer(
827         address from,
828         address to,
829         uint256 amount
830     ) private {
831         require(from != address(0), "ERC20: transfer from the zero address");
832         require(to != address(0), "ERC20: transfer to the zero address");
833         require(amount > 0, "Transfer amount must be greater than zero");
834         if(from != owner() && to != owner())
835             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
836 
837         // is the token balance of this contract address over the min number of
838         // tokens that we need to initiate a swap + liquidity lock?
839         // also, don't get caught in a circular liquidity event.
840         // also, don't swap & liquify if sender is uniswap pair.
841         uint256 contractTokenBalance = balanceOf(address(this));
842         
843         if(contractTokenBalance >= _maxTxAmount)
844         {
845             contractTokenBalance = _maxTxAmount;
846         }
847         
848         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
849         if (
850             overMinTokenBalance &&
851             !inSwapAndLiquify &&
852             from != uniswapV2Pair &&
853             swapAndLiquifyEnabled
854         ) {
855             contractTokenBalance = numTokensSellToAddToLiquidity;
856             //add liquidity
857             swapAndLiquify(contractTokenBalance);
858         }
859         
860         //indicates if fee should be deducted from transfer
861         bool takeFee = true;
862         
863         //if any account belongs to _isExcludedFromFee account then remove the fee
864         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
865             takeFee = false;
866         }
867         
868         //transfer amount, it will take tax, burn, liquidity fee
869         _tokenTransfer(from,to,amount,takeFee);
870     }
871 
872     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
873         // split the contract balance into halves
874         uint256 half = contractTokenBalance.div(2);
875         uint256 otherHalf = contractTokenBalance.sub(half);
876 
877         // capture the contract's current ETH balance.
878         // this is so that we can capture exactly the amount of ETH that the
879         // swap creates, and not make the liquidity event include any ETH that
880         // has been manually sent to the contract
881         uint256 initialBalance = address(this).balance;
882 
883         // swap tokens for ETH
884         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
885 
886         // how much ETH did we just swap into?
887         uint256 newBalance = address(this).balance.sub(initialBalance);
888 
889         // add liquidity to uniswap
890         addLiquidity(otherHalf, newBalance);
891         
892         emit SwapAndLiquify(half, newBalance, otherHalf);
893     }
894 
895     function swapTokensForEth(uint256 tokenAmount) private {
896         // generate the uniswap pair path of token -> weth
897         address[] memory path = new address[](2);
898         path[0] = address(this);
899         path[1] = uniswapV2Router.WETH();
900 
901         _approve(address(this), address(uniswapV2Router), tokenAmount);
902 
903         // make the swap
904         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
905             tokenAmount,
906             0, // accept any amount of ETH
907             path,
908             address(this),
909             block.timestamp
910         );
911     }
912 
913     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
914         // approve token transfer to cover all possible scenarios
915         _approve(address(this), address(uniswapV2Router), tokenAmount);
916 
917         // add the liquidity
918         // and lock the liquidity in this contract
919         uniswapV2Router.addLiquidityETH{value: ethAmount}(
920             address(this),
921             tokenAmount,
922             0, // slippage is unavoidable
923             0, // slippage is unavoidable
924             address(this),
925             block.timestamp
926         );
927     }
928 
929     //this method is responsible for taking all fee, if takeFee is true
930     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
931         if(!takeFee)
932             removeAllFee();
933         
934         if (_isExcluded[sender] && !_isExcluded[recipient]) {
935             _transferFromExcluded(sender, recipient, amount);
936         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
937             _transferToExcluded(sender, recipient, amount);
938         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
939             _transferStandard(sender, recipient, amount);
940         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
941             _transferBothExcluded(sender, recipient, amount);
942         } else {
943             _transferStandard(sender, recipient, amount);
944         }
945         
946         if(!takeFee)
947             restoreAllFee();
948     }
949 
950     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
951         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
952         _rOwned[sender] = _rOwned[sender].sub(rAmount);
953         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
954         _takeLiquidity(tLiquidity);
955         _reflectFee(rFee, tFee);
956         emit Transfer(sender, recipient, tTransferAmount);
957     }
958 
959     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
960         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
961         _rOwned[sender] = _rOwned[sender].sub(rAmount);
962         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
963         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
964         _takeLiquidity(tLiquidity);
965         _reflectFee(rFee, tFee);
966         emit Transfer(sender, recipient, tTransferAmount);
967     }
968 
969     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
970         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
971         _tOwned[sender] = _tOwned[sender].sub(tAmount);
972         _rOwned[sender] = _rOwned[sender].sub(rAmount);
973         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
974         _takeLiquidity(tLiquidity);
975         _reflectFee(rFee, tFee);
976         emit Transfer(sender, recipient, tTransferAmount);
977     }
978     
979     // additional function to address ether in the contract left after swap
980     // can be used by admins to buyback and burn the tokens or for other purposes
981     // related to the project
982     function withdrawLeftoverEther() external onlyOwner {
983         msg.sender.transfer(address(this).balance);
984     }
985 
986 }