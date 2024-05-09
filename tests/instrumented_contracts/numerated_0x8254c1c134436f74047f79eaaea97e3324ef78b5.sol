1 // SPDX-License-Identifier: UNLICENSED 
2 
3 pragma solidity ^0.6.12;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 
17 /**
18  * @dev Interface of the ERC20 standard as defined in the EIP.
19  */
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations with added overflow
95  * checks.
96  *
97  * Arithmetic operations in Solidity wrap on overflow. This can easily result
98  * in bugs, because programmers usually assume that an overflow raises an
99  * error, which is the standard behavior in high level programming languages.
100  * `SafeMath` restores this intuition by reverting the transaction when an
101  * operation overflows.
102  *
103  * Using this library instead of the unchecked operations eliminates an entire
104  * class of bugs, so it's recommended to use it always.
105  */
106  
107 library SafeMath {
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      *
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return sub(a, b, "SafeMath: subtraction overflow");
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b <= a, errorMessage);
151         uint256 c = a - b;
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `*` operator.
161      *
162      * Requirements:
163      *
164      * - Multiplication cannot overflow.
165      */
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168         // benefit is lost if 'b' is also tested.
169         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
170         if (a == 0) {
171             return 0;
172         }
173 
174         uint256 c = a * b;
175         require(c / a == b, "SafeMath: multiplication overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         return div(a, b, "SafeMath: division by zero");
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209         require(b > 0, errorMessage);
210         uint256 c = a / b;
211         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
229         return mod(a, b, "SafeMath: modulo by zero");
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts with custom message when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245         require(b != 0, errorMessage);
246         return a % b;
247     }
248 }
249 
250 
251 contract Ownable is Context {
252     address private _owner;
253     
254     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255 
256     /**
257      * @dev Initializes the contract setting the deployer as the initial owner.
258      */
259     constructor () internal {
260         address msgSender = _msgSender();
261         _owner = _msgSender();
262         emit OwnershipTransferred(address(0), msgSender);
263     }
264 
265     /**
266      * @dev Returns the address of the current owner.
267      */
268     function owner() public view returns (address) {
269         return _owner;
270     }
271 
272     /**
273      * @dev Throws if called by any account other than the owner.
274      */
275     modifier onlyOwner() {
276         require(_owner == _msgSender(), "Ownable: caller is not the owner");
277         _;
278     }
279 
280      /**
281      * @dev Leaves the contract without owner. It will not be possible to call
282      * `onlyOwner` functions anymore. Can only be called by the current owner.
283      *
284      * NOTE: Renouncing ownership will leave the contract without an owner,
285      * thereby removing any functionality that is only available to the owner.
286      */
287     function renounceOwnership() public virtual onlyOwner {
288         emit OwnershipTransferred(_owner, address(0));
289         _owner = address(0);
290     }
291 
292     /**
293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
294      * Can only be called by the current owner.
295      */
296     function transferOwnership(address newOwner) public virtual onlyOwner {
297         require(newOwner != address(0), "Ownable: new owner is the zero address");
298         emit OwnershipTransferred(_owner, newOwner);
299         _owner = newOwner;
300     }
301 }
302 
303 // pragma solidity >=0.5.0;
304 
305 interface IUniswapFactory {
306     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
307 
308     function createPair(address tokenA, address tokenB) external returns (address pair);
309 
310 }
311 
312 // pragma solidity >=0.5.0;
313 
314 interface IUniswapPair {
315     event Approval(address indexed owner, address indexed spender, uint value);
316     event Transfer(address indexed from, address indexed to, uint value);
317 
318     function name() external pure returns (string memory);
319     function symbol() external pure returns (string memory);
320     function decimals() external pure returns (uint8);
321     function totalSupply() external view returns (uint);
322     function balanceOf(address owner) external view returns (uint);
323     function allowance(address owner, address spender) external view returns (uint);
324 
325     function approve(address spender, uint value) external returns (bool);
326     function transfer(address to, uint value) external returns (bool);
327     function transferFrom(address from, address to, uint value) external returns (bool);
328 
329 
330     function factory() external view returns (address);
331 }
332 
333 // pragma solidity >=0.6.2;
334 
335 interface IUniswapRouter01 {
336     function factory() external pure returns (address);
337     function WETH() external pure returns (address);
338 
339     function addLiquidityETH(
340         address token,
341         uint amountTokenDesired,
342         uint amountTokenMin,
343         uint amountETHMin,
344         address to,
345         uint deadline
346     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
347   
348     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
349         external
350         returns (uint[] memory amounts);
351   
352 }
353 
354 
355 
356 // pragma solidity >=0.6.2;
357 
358 interface IUniswapRouter02 is IUniswapRouter01 {
359     function swapExactTokensForETHSupportingFeeOnTransferTokens(
360         uint amountIn,
361         uint amountOutMin,
362         address[] calldata path,
363         address to,
364         uint deadline
365     ) external;
366 }
367 
368 contract Ichigo is Context, IERC20, Ownable {
369     using SafeMath for uint256;
370 
371     mapping (address => uint256) private _rOwned;
372     mapping (address => uint256) private _tOwned;
373     mapping (address => mapping (address => uint256)) private _allowances;
374     mapping (address => bool) private _isExcludedFromFee;
375 
376     mapping (address => bool) private _isExcluded;
377     address[] private _excluded;
378    
379     uint256 private constant MAX = ~uint256(0);
380     uint256 private _tTotal = 100000000000 * 10**6 * 10**9;
381     uint256 private _rTotal = (MAX - (MAX % _tTotal));
382     uint256 private _tFeeTotal;
383 
384     string private _name = "Ichigo Inu";
385     string private _symbol = "Ichigo";
386     uint8 private _decimals = 9;
387     
388     uint256 public _taxFee = 1;
389     uint256 private _previousTaxFee = _taxFee;
390     
391     uint256 public _liquidityFee = 9; //(3% liquidityAddition + 3% marketing  + 3% buybacks)
392     uint256 private _previousLiquidityFee = _liquidityFee;
393     
394 
395     //No limit
396     uint256 public _maxTxAmount = _tTotal;
397     address payable wallet;
398     address payable wallet2;
399     IUniswapRouter02 public uniswapRouter;
400     address public uniswapPair;
401     address private constant burnAddress = 0x000000000000000000000000000000000000dEaD;
402     
403     bool inSwapAndLiquify;
404     bool public swapAndLiquifyEnabled = false;
405     bool private launched = false;
406     uint256 public launchedAt;
407     uint256 private minTokensBeforeSwap = 8;
408     
409     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
410     event SwapAndLiquifyEnabledUpdated(bool enabled);
411     event SwapAndLiquify(
412         uint256 tokensSwapped,
413         uint256 ethReceived,
414         uint256 tokensIntoLiqudity
415     );
416     
417     modifier lockTheSwap {
418         inSwapAndLiquify = true;
419          _;
420         inSwapAndLiquify = false;
421     }
422     
423     constructor () public {
424         _rOwned[_msgSender()] = _rTotal;
425         wallet = payable(0x8579dE54d14ffeb5554C10AFD3Da25D15cD3De9a);
426         wallet2  = payable(0x8579dE54d14ffeb5554C10AFD3Da25D15cD3De9a);
427         
428          IUniswapRouter02 _uniswapV2Router = IUniswapRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
429         uniswapPair = IUniswapFactory(_uniswapV2Router.factory())
430             .createPair(address(this), _uniswapV2Router.WETH());
431 
432         uniswapRouter = _uniswapV2Router;
433         
434         
435         //exclude owner and this contract from fee
436         _isExcludedFromFee[wallet] = true;
437         _isExcludedFromFee[owner()] = true;
438         _isExcludedFromFee[address(this)] = true;
439 
440         emit Transfer(address(0), _msgSender(), _tTotal);
441     }
442 
443     function name() public view returns (string memory) {
444         return _name;
445     }
446 
447     function symbol() public view returns (string memory) {
448         return _symbol;
449     }
450 
451     function decimals() public view returns (uint8) {
452         return _decimals;
453     }
454 
455     function totalSupply() public view override returns (uint256) {
456         return _tTotal;
457     }
458 
459     function balanceOf(address account) public view override returns (uint256) {
460         if (_isExcluded[account]) return _tOwned[account];
461         return tokenFromReflection(_rOwned[account]);
462     }
463 
464     function transfer(address recipient, uint256 amount) public override returns (bool) {
465         _transfer(_msgSender(), recipient, amount);
466         return true;
467     }
468 
469     function allowance(address owner, address spender) public view override returns (uint256) {
470         return _allowances[owner][spender];
471     }
472 
473     function approve(address spender, uint256 amount) public override returns (bool) {
474         _approve(_msgSender(), spender, amount);
475         return true;
476     }
477 
478     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
479         _transfer(sender, recipient, amount);
480         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
481         return true;
482     }
483 
484     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
485         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
486         return true;
487     }
488 
489     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
490         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
491         return true;
492     }
493 
494     function isExcludedFromReward(address account) public view returns (bool) {
495         return _isExcluded[account];
496     }
497 
498     function totalFees() public view returns (uint256) {
499         return _tFeeTotal;
500     }
501 
502     function deliver(uint256 tAmount) public {
503         address sender = _msgSender();
504         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
505         (uint256 rAmount,,,,,) = _getValues(tAmount);
506         _rOwned[sender] = _rOwned[sender].sub(rAmount);
507         _rTotal = _rTotal.sub(rAmount);
508         _tFeeTotal = _tFeeTotal.add(tAmount);
509     }
510 
511     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
512         require(tAmount <= _tTotal, "Amount must be less than supply");
513         if (!deductTransferFee) {
514             (uint256 rAmount,,,,,) = _getValues(tAmount);
515             return rAmount;
516         } else {
517             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
518             return rTransferAmount;
519         }
520     }
521 
522     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
523         require(rAmount <= _rTotal, "Amount must be less than total reflections");
524         uint256 currentRate =  _getRate();
525         return rAmount.div(currentRate);
526     }
527 
528     function excludeFromReward(address account) public onlyOwner() {
529         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude uniswap router.');
530         require(!_isExcluded[account], "Account is already excluded");
531         if(_rOwned[account] > 0) {
532             _tOwned[account] = tokenFromReflection(_rOwned[account]);
533         }
534         _isExcluded[account] = true;
535         _excluded.push(account);
536     }
537 
538     function includeInReward(address account) external onlyOwner() {
539         require(_isExcluded[account], "Account is already excluded");
540         for (uint256 i = 0; i < _excluded.length; i++) {
541             if (_excluded[i] == account) {
542                 _excluded[i] = _excluded[_excluded.length - 1];
543                 _tOwned[account] = 0;
544                 _isExcluded[account] = false;
545                 _excluded.pop();
546                 break;
547             }
548         }
549     }
550     
551     function _approve(address owner, address spender, uint256 amount) private {
552         require(owner != address(0));
553         require(spender != address(0));
554 
555         _allowances[owner][spender] = amount;
556         emit Approval(owner, spender, amount);
557     }
558 
559     bool public limit = true;
560     
561     function changeLimit() public onlyOwner(){
562         require(limit == true, 'limit is already false');
563             limit = false;
564     }
565     
566     function openTrading() external onlyOwner() {
567         launched = true;
568         launchedAt = block.number;
569         swapAndLiquifyEnabled = true;
570     }
571     
572     function _transfer(
573         address from,
574         address to,
575         uint256 amount
576     ) private {
577         require(from != address(0), "ERC20: transfer from the zero address");
578         require(to != address(0), "ERC20: transfer to the zero address");
579         require(amount > 0, "Transfer amount must be greater than zero");
580         require(from == owner() || to == owner() || launched, "Not launched yet");
581         
582         if (block.number == launchedAt || block.number == launchedAt + 1){
583             if (from == uniswapPair && from != owner() && to != owner()){
584             to = burnAddress;
585         }
586     }
587         if(limit == true && !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && to != burnAddress){
588             if(to != uniswapPair && from == uniswapPair){
589                 require(((balanceOf(to).add(amount)) <= 200000000000 * 10**4 * 10**9));
590             }
591             require(amount <= 100000000000 * 10**4 * 10**9, 'Transfer amount must be less');
592             }
593             
594         if(from != owner() && to != owner())
595             require(amount <= _maxTxAmount);
596 
597         // is the token balance of this contract address over the min number of
598         // tokens that we need to initiate a swap + liquidity lock?
599         // also, don't get caught in a circular liquidity event.
600         // also, don't swap & liquify if sender is uniswap pair.
601     
602         uint256 contractTokenBalance = balanceOf(address(this));
603         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
604         if (
605             overMinTokenBalance &&
606             !inSwapAndLiquify &&
607             from != uniswapPair &&
608             swapAndLiquifyEnabled
609         ) {
610             //add liquidity
611             swapAndLiquify(contractTokenBalance);
612         }
613         
614         //indicates if fee should be deducted from transfer
615         bool takeFee = true;
616         
617         //if any account belongs to _isExcludedFromFee account then remove the fee
618         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
619             takeFee = false;
620         }
621         
622         //transfer amount, it will take tax, burn, liquidity fee
623         _tokenTransfer(from,to,amount,takeFee);
624     }
625     
626     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
627         // split the contract balance into halves
628         uint256 forLiquidity = contractTokenBalance.div(2);
629         uint256 devExp = contractTokenBalance.div(4);
630         uint256 forRewards = contractTokenBalance.div(4);
631         // split the liquidity
632         uint256 half = forLiquidity.div(2);
633         uint256 otherHalf = forLiquidity.sub(half);
634         // capture the contract's current ETH balance.
635         // this is so that we can capture exactly the amount of ETH that the
636         // swap creates, and not make the liquidity event include any ETH that
637         // has been manually sent to the contract
638         uint256 initialBalance = address(this).balance;
639 
640         // swap tokens for ETH
641         swapTokensForEth(half.add(devExp).add(forRewards)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
642 
643         // how much ETH did we just swap into?
644         uint256 Balance = address(this).balance.sub(initialBalance);
645         uint256 oneThird = Balance.div(3);
646         wallet.transfer(oneThird);
647         wallet2.transfer(oneThird);
648 
649         // add liquidity to uniswap
650         addLiquidity(otherHalf, oneThird);
651         
652         emit SwapAndLiquify(half, oneThird, otherHalf);
653     }
654        
655 
656      
657     function swapTokensForEth(uint256 tokenAmount) private {
658         // generate the uniswap pair path of token -> weth
659         address[] memory path = new address[](2);
660         path[0] = address(this);
661         path[1] = uniswapRouter.WETH();
662 
663         _approve(address(this), address(uniswapRouter), tokenAmount);
664 
665         // make the swap
666         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
667             tokenAmount,
668             0, // accept any amount of ETH
669             path,
670             address(this),
671             block.timestamp
672         );
673     }
674 
675     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
676         // approve token transfer to cover all possible scenarios
677         _approve(address(this), address(uniswapRouter), tokenAmount);
678 
679         // add the liquidity
680         uniswapRouter.addLiquidityETH{value: ethAmount}(
681             address(this),
682             tokenAmount,
683             0, // slippage is unavoidable
684             0, // slippage is unavoidable
685             wallet,
686             block.timestamp
687         );
688     }
689 
690     //this method is responsible for taking all fee, if takeFee is true
691     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
692         if(!takeFee)
693             removeAllFee();
694         
695         if (_isExcluded[sender] && !_isExcluded[recipient]) {
696             _transferFromExcluded(sender, recipient, amount);
697         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
698             _transferToExcluded(sender, recipient, amount);
699         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
700             _transferStandard(sender, recipient, amount);
701         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
702             _transferBothExcluded(sender, recipient, amount);
703         } else {
704             _transferStandard(sender, recipient, amount);
705         }
706         
707         if(!takeFee)
708             restoreAllFee();
709     }
710 
711     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
712         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
713         _rOwned[sender] = _rOwned[sender].sub(rAmount);
714         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
715         _takeLiquidity(tLiquidity);
716         _reflectFee(rFee, tFee);
717         emit Transfer(sender, recipient, tTransferAmount);
718     }
719 
720     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
721         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
722         _rOwned[sender] = _rOwned[sender].sub(rAmount);
723         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
724         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
725         _takeLiquidity(tLiquidity);
726         _reflectFee(rFee, tFee);
727         emit Transfer(sender, recipient, tTransferAmount);
728     }
729 
730     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
731         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
732         _tOwned[sender] = _tOwned[sender].sub(tAmount);
733         _rOwned[sender] = _rOwned[sender].sub(rAmount);
734         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
735         _takeLiquidity(tLiquidity);
736         _reflectFee(rFee, tFee);
737         emit Transfer(sender, recipient, tTransferAmount);
738     }
739 
740     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
741         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
742         _tOwned[sender] = _tOwned[sender].sub(tAmount);
743         _rOwned[sender] = _rOwned[sender].sub(rAmount);
744         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
745         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
746         _takeLiquidity(tLiquidity);
747         _reflectFee(rFee, tFee);
748         emit Transfer(sender, recipient, tTransferAmount);
749     }
750 
751     function _reflectFee(uint256 rFee, uint256 tFee) private {
752         _rTotal = _rTotal.sub(rFee);
753         _tFeeTotal = _tFeeTotal.add(tFee);
754     }
755 
756     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
757         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
758         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
759         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
760     }
761 
762     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
763         uint256 tFee = calculateTaxFee(tAmount);
764         uint256 tLiquidity = calculateLiquidityFee(tAmount);
765         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
766         return (tTransferAmount, tFee, tLiquidity);
767     }
768 
769     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
770         uint256 rAmount = tAmount.mul(currentRate);
771         uint256 rFee = tFee.mul(currentRate);
772         uint256 rLiquidity = tLiquidity.mul(currentRate);
773         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
774         return (rAmount, rTransferAmount, rFee);
775     }
776 
777     function _getRate() private view returns(uint256) {
778         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
779         return rSupply.div(tSupply);
780     }
781 
782     function _getCurrentSupply() private view returns(uint256, uint256) {
783         uint256 rSupply = _rTotal;
784         uint256 tSupply = _tTotal;      
785         for (uint256 i = 0; i < _excluded.length; i++) {
786             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
787             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
788             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
789         }
790         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
791         return (rSupply, tSupply);
792     }
793     
794     function _takeLiquidity(uint256 tLiquidity) private {
795         uint256 currentRate =  _getRate();
796         uint256 rLiquidity = tLiquidity.mul(currentRate);
797         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
798         if(_isExcluded[address(this)])
799             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
800     }
801     
802     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
803         return _amount.mul(_taxFee).div(
804             10**2
805         );
806     }
807 
808     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
809         return _amount.mul(_liquidityFee).div(
810             10**2
811         );
812     }
813     
814     function removeAllFee() private {
815         if(_taxFee == 0 && _liquidityFee == 0) return;
816         
817         _previousTaxFee = _taxFee;
818         _previousLiquidityFee = _liquidityFee;
819         
820         _taxFee = 0;
821         _liquidityFee = 0;
822     }
823     
824     function restoreAllFee() private {
825         _taxFee = _previousTaxFee;
826         _liquidityFee = _previousLiquidityFee;
827     }
828     
829     function isExcludedFromFee(address account) public view returns(bool) {
830         return _isExcludedFromFee[account];
831     }
832     
833     function excludeFromFee(address account) public onlyOwner {
834         _isExcludedFromFee[account] = true;
835     }
836     
837     function includeInFee(address account) public onlyOwner {
838         _isExcludedFromFee[account] = false;
839     }
840     
841     
842     function setMinTokensBeforeSwap(uint256 amount) external onlyOwner {
843         minTokensBeforeSwap = amount;
844     }
845    
846     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
847          require(maxTxPercent <= 20, "Maximum tax limit is 20 percent");
848         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
849             10**2
850         );
851     }
852 
853     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
854         swapAndLiquifyEnabled = _enabled;
855         emit SwapAndLiquifyEnabledUpdated(_enabled);
856     }
857     
858      //to recieve ETH from uniswapRouter when swaping
859     receive() external payable {}
860 }