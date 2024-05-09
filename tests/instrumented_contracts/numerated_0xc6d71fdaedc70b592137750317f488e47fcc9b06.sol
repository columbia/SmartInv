1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 pragma solidity ^0.8.4;
83 /**
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
100         return msg.data;
101     }
102 }
103 
104 pragma solidity ^0.8.4;
105 /**
106  * @dev Interface for the optional metadata functions from the ERC20 standard.
107  *
108  * _Available since v4.1._
109  */
110 interface IERC20Metadata is IERC20 {
111     /**
112      * @dev Returns the name of the token.
113      */
114     function name() external view returns (string memory);
115 
116     /**
117      * @dev Returns the symbol of the token.
118      */
119     function symbol() external view returns (string memory);
120 
121     /**
122      * @dev Returns the decimals places of the token.
123      */
124     function decimals() external view returns (uint8);
125 }
126 
127 pragma solidity ^0.8.4;
128 
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      *
138      * - Addition cannot overflow.
139      */
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         require(c >= a, "SafeMath: addition overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `*` operator.
183      *
184      * Requirements:
185      *
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b > 0, errorMessage);
232         uint256 c = a / b;
233         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 pragma solidity ^0.8.4;
273 
274 interface IUniswapV2Factory {
275     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
276 
277     function feeTo() external view returns (address);
278     function feeToSetter() external view returns (address);
279 
280     function getPair(address tokenA, address tokenB) external view returns (address pair);
281     function allPairs(uint) external view returns (address pair);
282     function allPairsLength() external view returns (uint);
283 
284     function createPair(address tokenA, address tokenB) external returns (address pair);
285 
286     function setFeeTo(address) external;
287     function setFeeToSetter(address) external;
288 }
289 
290 pragma solidity ^0.8.4;
291 
292 interface IUniswapV2Router01 {
293     function factory() external pure returns (address);
294     function WETH() external pure returns (address);
295 
296     function addLiquidity(
297         address tokenA,
298         address tokenB,
299         uint amountADesired,
300         uint amountBDesired,
301         uint amountAMin,
302         uint amountBMin,
303         address to,
304         uint deadline
305     ) external returns (uint amountA, uint amountB, uint liquidity);
306     function addLiquidityETH(
307         address token,
308         uint amountTokenDesired,
309         uint amountTokenMin,
310         uint amountETHMin,
311         address to,
312         uint deadline
313     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
314     function removeLiquidity(
315         address tokenA,
316         address tokenB,
317         uint liquidity,
318         uint amountAMin,
319         uint amountBMin,
320         address to,
321         uint deadline
322     ) external returns (uint amountA, uint amountB);
323     function removeLiquidityETH(
324         address token,
325         uint liquidity,
326         uint amountTokenMin,
327         uint amountETHMin,
328         address to,
329         uint deadline
330     ) external returns (uint amountToken, uint amountETH);
331     function removeLiquidityWithPermit(
332         address tokenA,
333         address tokenB,
334         uint liquidity,
335         uint amountAMin,
336         uint amountBMin,
337         address to,
338         uint deadline,
339         bool approveMax, uint8 v, bytes32 r, bytes32 s
340     ) external returns (uint amountA, uint amountB);
341     function removeLiquidityETHWithPermit(
342         address token,
343         uint liquidity,
344         uint amountTokenMin,
345         uint amountETHMin,
346         address to,
347         uint deadline,
348         bool approveMax, uint8 v, bytes32 r, bytes32 s
349     ) external returns (uint amountToken, uint amountETH);
350     function swapExactTokensForTokens(
351         uint amountIn,
352         uint amountOutMin,
353         address[] calldata path,
354         address to,
355         uint deadline
356     ) external returns (uint[] memory amounts);
357     function swapTokensForExactTokens(
358         uint amountOut,
359         uint amountInMax,
360         address[] calldata path,
361         address to,
362         uint deadline
363     ) external returns (uint[] memory amounts);
364     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
365         external
366         payable
367         returns (uint[] memory amounts);
368     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
369         external
370         returns (uint[] memory amounts);
371     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
372         external
373         returns (uint[] memory amounts);
374     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
375         external
376         payable
377         returns (uint[] memory amounts);
378 
379     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
380     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
381     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
382     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
383     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
384 }
385 
386 pragma solidity ^0.8.4;
387 
388 interface IUniswapV2Router02 is IUniswapV2Router01 {
389     function removeLiquidityETHSupportingFeeOnTransferTokens(
390         address token,
391         uint liquidity,
392         uint amountTokenMin,
393         uint amountETHMin,
394         address to,
395         uint deadline
396     ) external returns (uint amountETH);
397     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
398         address token,
399         uint liquidity,
400         uint amountTokenMin,
401         uint amountETHMin,
402         address to,
403         uint deadline,
404         bool approveMax, uint8 v, bytes32 r, bytes32 s
405     ) external returns (uint amountETH);
406 
407     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
408         uint amountIn,
409         uint amountOutMin,
410         address[] calldata path,
411         address to,
412         uint deadline
413     ) external;
414     function swapExactETHForTokensSupportingFeeOnTransferTokens(
415         uint amountOutMin,
416         address[] calldata path,
417         address to,
418         uint deadline
419     ) external payable;
420     function swapExactTokensForETHSupportingFeeOnTransferTokens(
421         uint amountIn,
422         uint amountOutMin,
423         address[] calldata path,
424         address to,
425         uint deadline
426     ) external;
427 }
428 
429 pragma solidity ^0.8.4;
430 
431 contract Ownable is Context {
432     address private _owner;
433 
434     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
435 
436     /**
437      * @dev Initializes the contract setting the deployer as the initial owner.
438      */
439     constructor () {
440         address msgSender = _msgSender();
441         _owner = msgSender;
442         emit OwnershipTransferred(address(0), msgSender);
443     }
444 
445     /**
446      * @dev Returns the address of the current owner.
447      */
448     function owner() public view returns (address) {
449         return _owner;
450     }
451 
452     /**
453      * @dev Throws if called by any account other than the owner.
454      */
455     modifier onlyOwner() {
456         require(_owner == _msgSender(), "Ownable: caller is not the owner");
457         _;
458     }
459 
460     /**
461      * @dev Leaves the contract without owner. It will not be possible to call
462      * `onlyOwner` functions anymore. Can only be called by the current owner.
463      *
464      * NOTE: Renouncing ownership will leave the contract without an owner,
465      * thereby removing any functionality that is only available to the owner.
466      */
467     function renounceOwnership() public virtual onlyOwner {
468         emit OwnershipTransferred(_owner, address(0));
469         _owner = address(0);
470     }
471 
472     /**
473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
474      * Can only be called by the current owner.
475      */
476     function transferOwnership(address newOwner) public virtual onlyOwner {
477         require(newOwner != address(0), "Ownable: new owner is the zero address");
478         emit OwnershipTransferred(_owner, newOwner);
479         _owner = newOwner;
480     }
481 }
482 
483 pragma solidity ^0.8.4;
484 
485 contract fafa is Context, IERC20, Ownable {
486     
487     using SafeMath for uint256;
488     mapping (address => uint256) public _rOwned;
489 
490     mapping (address => mapping (address => uint256)) private _allowances;
491     mapping (address => bool) public _isExcludedFromFee;
492     mapping(address => bool) public _isBlacklisted;
493 
494     address public _PresaleAddress = 0x000000000000000000000000000000000000dEaD;
495     bool public liquidityLaunched = false;
496     bool public isFirstLaunch = true;
497     uint256 public lastSnipeTaxBlock;
498     uint8 public snipeBlocks = 0;
499     
500     uint256 private constant MAX = ~uint256(0);
501     uint256 private constant _tTotal = 42069 * (10**10) * (10**9);
502     uint256 private _rTotal = (MAX - (MAX % _tTotal));
503     
504     uint256 private _redisFeeOnBuy = 0;
505     uint256 private _taxFeeOnBuy = 3;
506     
507     uint256 private _redisFeeOnSell = 0;
508     uint256 private _taxFeeOnSell = 3;
509     
510     uint256 private _redisFee;
511     uint256 private _taxFee;
512     
513     string private constant _name = "FAFA";
514     string private constant _symbol = "FAFA";
515     uint8 private constant _decimals = 9;
516     
517 
518     address payable private _marketingAddress = payable(0x5E5fD0DfcaaAa511626a94A114a8834CD13FDe07);
519     address payable private _buybackAddress = payable(0x15ef0B24De666D7147A6cFce68526b53320541a2);
520 
521     IUniswapV2Router02 public uniswapV2Router;
522     address public uniswapV2Pair;
523     
524     bool private inSwap = false;
525     bool private swapEnabled = true;
526     
527     modifier lockTheSwap {
528         inSwap = true;
529         _;
530         inSwap = false;
531     }
532     constructor () {
533         _rOwned[_msgSender()] = _rTotal;
534         
535         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
536         uniswapV2Router = _uniswapV2Router;
537         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
538             .createPair(address(this), _uniswapV2Router.WETH());
539 
540         _isExcludedFromFee[owner()] = true;
541         _isExcludedFromFee[address(this)] = true;
542 
543         _isExcludedFromFee[_marketingAddress] = true;
544         _isExcludedFromFee[_buybackAddress] = true;
545 
546         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
547     }
548 
549     function setSnipeBlocks(uint8 _blocks) external onlyOwner {
550         require(!liquidityLaunched);
551         snipeBlocks = _blocks;
552     }
553 
554     function setPresaleContract(address payable wallet) external onlyOwner{
555         _PresaleAddress = wallet;
556         excludeFromFees(_PresaleAddress, true);
557     }
558 
559     function name() public pure returns (string memory) {
560         return _name;
561     }
562 
563     function symbol() public pure returns (string memory) {
564         return _symbol;
565     }
566 
567     function decimals() public pure returns (uint8) {
568         return _decimals;
569     }
570 
571     function totalSupply() public pure override returns (uint256) {
572         return _tTotal;
573     }
574 
575     function balanceOf(address account) public view override returns (uint256) {
576         return tokenFromReflection(_rOwned[account]);
577     }
578 
579     function transfer(address recipient, uint256 amount) public override returns (bool) {
580         _transfer(_msgSender(), recipient, amount);
581         return true;
582     }
583 
584     function allowance(address owner, address spender) public view override returns (uint256) {
585         return _allowances[owner][spender];
586     }
587 
588     function approve(address spender, uint256 amount) public override returns (bool) {
589         _approve(_msgSender(), spender, amount);
590         return true;
591     }
592 
593     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
594         _transfer(sender, recipient, amount);
595         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
596         return true;
597     }
598 
599     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
600         require(rAmount <= _rTotal, "Amount must be less than total reflections");
601         uint256 currentRate =  _getRate();
602         return rAmount.div(currentRate);
603     }
604 
605     function _approve(address owner, address spender, uint256 amount) private {
606         require(owner != address(0), "ERC20: approve from the zero address");
607         require(spender != address(0), "ERC20: approve to the zero address");
608         _allowances[owner][spender] = amount;
609         emit Approval(owner, spender, amount);
610     }
611 
612     function _transfer(address from, address to, uint256 amount) private {
613         require(from != address(0), "ERC20: transfer from the zero address");
614         require(to != address(0), "ERC20: transfer to the zero address");
615         require(amount > 0, "Transfer amount must be greater than zero");
616         require(!_isBlacklisted[from], 'Blacklisted address');
617 
618         _redisFee = 0;
619         _taxFee = 0;
620 
621         // No adding liquidity before launched
622         if (!liquidityLaunched) {
623             if (to == uniswapV2Pair) {
624                 liquidityLaunched = true;
625                 // high tax ends in x blocks
626                 lastSnipeTaxBlock = block.number + snipeBlocks;
627             }
628         }
629 
630         //antibot block
631         if (from != address(_PresaleAddress)) {
632             if(liquidityLaunched && block.number <= lastSnipeTaxBlock && !isFirstLaunch){
633                 _redisFee = _redisFeeOnBuy;
634                 _taxFee = _taxFeeOnBuy;
635                 _tokenTransfer(from,to,amount);
636                 if (to != address(uniswapV2Pair)) {
637                     _isBlacklisted[to]=true;
638                 }
639                 return;
640             }
641         }
642 
643         if (liquidityLaunched && isFirstLaunch){
644             isFirstLaunch = false;
645         }
646         
647         if (from != owner() && to != owner()) {
648             
649             uint256 contractTokenBalance = balanceOf(address(this));
650             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance > 0) {
651                 swapTokensForEth(contractTokenBalance);
652                 uint256 contractETHBalance = address(this).balance;
653                 if(contractETHBalance > 0) {
654                     sendETHToFee(address(this).balance);
655                 }
656             }
657             
658             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
659                 _redisFee = _redisFeeOnBuy;
660                 _taxFee = _taxFeeOnBuy;
661             }
662     
663             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
664                 _redisFee = _redisFeeOnSell;
665                 _taxFee = _taxFeeOnSell;
666             }
667             
668             if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
669                 _redisFee = 0;
670                 _taxFee = 0;
671             }
672             
673         }
674 
675         _tokenTransfer(from,to,amount);
676     }
677 
678     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
679         address[] memory path = new address[](2);
680         path[0] = address(this);
681         path[1] = uniswapV2Router.WETH();
682         _approve(address(this), address(uniswapV2Router), tokenAmount);
683         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
684             tokenAmount,
685             0,
686             path,
687             address(this),
688             block.timestamp
689         );
690     }
691         
692     function sendETHToFee(uint256 amount) private {
693         uint256 mktAmount = amount.mul(1).div(2);
694         uint256 buybackAmount = amount.sub(mktAmount);
695         _marketingAddress.transfer(mktAmount);
696         _buybackAddress.transfer(buybackAmount);
697     }
698     
699     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
700         _transferStandard(sender, recipient, amount);
701     }
702 
703     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
704         uint256 currentRate =  _getRate();
705         uint256 tTransferAmount = tAmount.sub(tAmount.mul(_redisFee).div(100)).sub(tAmount.mul(_taxFee).div(100));
706         uint256 rAmount = tAmount.mul(currentRate);
707         uint256 rFee = tAmount.mul(_redisFee).div(100).mul(currentRate);
708         uint256 rTeam = tAmount.mul(_taxFee).div(100).mul(currentRate);
709         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
710         _rOwned[sender] = _rOwned[sender].sub(rAmount);
711         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
712         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
713         _reflectFee(rFee);
714         emit Transfer(sender, recipient, tTransferAmount);
715     }
716 
717     /**
718      * only thing to change _rTotal
719      */
720     function _reflectFee(uint256 rFee) private {
721         _rTotal = _rTotal.sub(rFee);
722     }
723 
724     receive() external payable {}
725 
726 	function _getRate() private view returns(uint256) {
727         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
728         return rSupply.div(tSupply);
729     }
730 
731     function _getCurrentSupply() private view returns(uint256, uint256) {
732         uint256 rSupply = _rTotal;
733         uint256 tSupply = _tTotal;      
734         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
735         return (rSupply, tSupply);
736     }
737 
738     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
739     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
740         for(uint256 i = 0; i < accounts.length; i++) {
741             _isExcludedFromFee[accounts[i]] = excluded;
742         }
743         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
744     }
745 
746     event ExcludeFromFees(address indexed account, bool isExcluded);
747     function excludeFromFees(address account, bool excluded) public onlyOwner {
748         _isExcludedFromFee[account] = excluded;
749         emit ExcludeFromFees(account, excluded);
750     }
751 
752     event BlacklistAddress(address indexed account, bool value);
753     function blacklistAddress(address account, bool value) public onlyOwner{
754         _isBlacklisted[account] = value;
755         emit BlacklistAddress(account, value);
756     }
757 
758     event BlacklistMultiAddresses(address[] accounts, bool value);
759     function blacklistMultiAddresses(address[] calldata accounts, bool value) public onlyOwner{
760         for(uint256 i = 0; i < accounts.length; i++) {
761             _isBlacklisted[accounts[i]] = value;
762         }
763         emit BlacklistMultiAddresses(accounts, value);
764     }
765 
766 }