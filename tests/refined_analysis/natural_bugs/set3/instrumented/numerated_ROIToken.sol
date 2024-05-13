1 /**
2  *Submitted for verification at BscScan.com on 2022-05-10
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2021-07-02
7 */
8 
9 /*
10 
11 Contract by DeFiSCI and Team - built on others previous work w/ a splash of DevTeamSix magic...
12 
13 */
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 pragma solidity ^0.8.4;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return payable(msg.sender);
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 interface IERC20 {
32 
33     function totalSupply() external view returns (uint256);
34     function balanceOf(address account) external view returns (uint256);
35     function transfer(address recipient, uint256 amount) external returns (bool);
36     function allowance(address owner, address spender) external view returns (uint256);
37     function approve(address spender, uint256 amount) external returns (bool);
38     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41     
42 
43 }
44 
45 library SafeMath {
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50 
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76 
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         return div(a, b, "SafeMath: division by zero");
79     }
80 
81     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b > 0, errorMessage);
83         uint256 c = a / b;
84         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85 
86         return c;
87     }
88 
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         return mod(a, b, "SafeMath: modulo by zero");
91     }
92 
93     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         require(b != 0, errorMessage);
95         return a % b;
96     }
97 }
98 
99 library Address {
100 
101     function isContract(address account) internal view returns (bool) {
102         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
103         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
104         // for accounts without code, i.e. `keccak256('')`
105         bytes32 codehash;
106         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
107         // solhint-disable-next-line no-inline-assembly
108         assembly { codehash := extcodehash(account) }
109         return (codehash != accountHash && codehash != 0x0);
110     }
111 
112     function sendValue(address payable recipient, uint256 amount) internal {
113         require(address(this).balance >= amount, "Address: insufficient balance");
114 
115         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
116         (bool success, ) = recipient.call{ value: amount }("");
117         require(success, "Address: unable to send value, recipient may have reverted");
118     }
119 
120 
121     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
122       return functionCall(target, data, "Address: low-level call failed");
123     }
124 
125     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
126         return _functionCallWithValue(target, data, 0, errorMessage);
127     }
128 
129     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
130         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
131     }
132 
133     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
134         require(address(this).balance >= value, "Address: insufficient balance for call");
135         return _functionCallWithValue(target, data, value, errorMessage);
136     }
137 
138     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
142         if (success) {
143             return returndata;
144         } else {
145             
146             if (returndata.length > 0) {
147                 assembly {
148                     let returndata_size := mload(returndata)
149                     revert(add(32, returndata), returndata_size)
150                 }
151             } else {
152                 revert(errorMessage);
153             }
154         }
155     }
156 }
157 
158 contract Ownable is Context {
159     address private _owner;
160     address private _previousOwner;
161     uint256 private _lockTime;
162 
163     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
164 
165     constructor () {
166         address msgSender = _msgSender();
167         _owner = msgSender;
168         emit OwnershipTransferred(address(0), msgSender);
169     }
170 
171     function owner() public view returns (address) {
172         return _owner;
173     }   
174     
175     modifier onlyOwner() {
176         require(_owner == _msgSender(), "Ownable: caller is not the owner");
177         _;
178     }
179     
180     function renounceOwnership() public virtual onlyOwner {
181         emit OwnershipTransferred(_owner, address(0));
182         _owner = address(0);
183     }
184 
185     function transferOwnership(address newOwner) public virtual {
186         require(newOwner != address(0), "Ownable: new owner is the zero address");
187         emit OwnershipTransferred(_owner, newOwner);
188         _owner = newOwner;
189     }
190 
191     function getUnlockTime() public view returns (uint256) {
192         return _lockTime;
193     }
194     
195     function getTime() public view returns (uint256) {
196         return block.timestamp;
197     }
198 
199     function lock(uint256 time) public virtual onlyOwner {
200         _previousOwner = _owner;
201         _owner = address(0);
202         _lockTime = block.timestamp + time;
203         emit OwnershipTransferred(_owner, address(0));
204     }
205     
206     function unlock() public virtual {
207         require(_previousOwner == msg.sender, "You don't have permission to unlock");
208         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
209         emit OwnershipTransferred(_owner, _previousOwner);
210         _owner = _previousOwner;
211     }
212 }
213 
214 
215 // pragma solidity >=0.5.0;
216 
217 interface IUniswapV2Factory {
218     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
219 
220     function feeTo() external view returns (address);
221     function feeToSetter() external view returns (address);
222 
223     function getPair(address tokenA, address tokenB) external view returns (address pair);
224     function allPairs(uint) external view returns (address pair);
225     function allPairsLength() external view returns (uint);
226 
227     function createPair(address tokenA, address tokenB) external returns (address pair);
228 
229     function setFeeTo(address) external;
230     function setFeeToSetter(address) external;
231 }
232 
233 
234 // pragma solidity >=0.5.0;
235 
236 interface IUniswapV2Pair {
237     event Approval(address indexed owner, address indexed spender, uint value);
238     event Transfer(address indexed from, address indexed to, uint value);
239 
240     function name() external pure returns (string memory);
241     function symbol() external pure returns (string memory);
242     function decimals() external pure returns (uint8);
243     function totalSupply() external view returns (uint);
244     function balanceOf(address owner) external view returns (uint);
245     function allowance(address owner, address spender) external view returns (uint);
246 
247     function approve(address spender, uint value) external returns (bool);
248     function transfer(address to, uint value) external returns (bool);
249     function transferFrom(address from, address to, uint value) external returns (bool);
250 
251     function DOMAIN_SEPARATOR() external view returns (bytes32);
252     function PERMIT_TYPEHASH() external pure returns (bytes32);
253     function nonces(address owner) external view returns (uint);
254 
255     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
256     
257     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
258     event Swap(
259         address indexed sender,
260         uint amount0In,
261         uint amount1In,
262         uint amount0Out,
263         uint amount1Out,
264         address indexed to
265     );
266     event Sync(uint112 reserve0, uint112 reserve1);
267 
268     function MINIMUM_LIQUIDITY() external pure returns (uint);
269     function factory() external view returns (address);
270     function token0() external view returns (address);
271     function token1() external view returns (address);
272     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
273     function price0CumulativeLast() external view returns (uint);
274     function price1CumulativeLast() external view returns (uint);
275     function kLast() external view returns (uint);
276 
277     function burn(address to) external returns (uint amount0, uint amount1);
278     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
279     function skim(address to) external;
280     function sync() external;
281 
282     function initialize(address, address) external;
283 }
284 
285 // pragma solidity >=0.6.2;
286 
287 interface IUniswapV2Router01 {
288     function factory() external pure returns (address);
289     function WETH() external pure returns (address);
290 
291     function addLiquidity(
292         address tokenA,
293         address tokenB,
294         uint amountADesired,
295         uint amountBDesired,
296         uint amountAMin,
297         uint amountBMin,
298         address to,
299         uint deadline
300     ) external returns (uint amountA, uint amountB, uint liquidity);
301     function addLiquidityETH(
302         address token,
303         uint amountTokenDesired,
304         uint amountTokenMin,
305         uint amountETHMin,
306         address to,
307         uint deadline
308     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
309     function removeLiquidity(
310         address tokenA,
311         address tokenB,
312         uint liquidity,
313         uint amountAMin,
314         uint amountBMin,
315         address to,
316         uint deadline
317     ) external returns (uint amountA, uint amountB);
318     function removeLiquidityETH(
319         address token,
320         uint liquidity,
321         uint amountTokenMin,
322         uint amountETHMin,
323         address to,
324         uint deadline
325     ) external returns (uint amountToken, uint amountETH);
326     function removeLiquidityWithPermit(
327         address tokenA,
328         address tokenB,
329         uint liquidity,
330         uint amountAMin,
331         uint amountBMin,
332         address to,
333         uint deadline,
334         bool approveMax, uint8 v, bytes32 r, bytes32 s
335     ) external returns (uint amountA, uint amountB);
336     function removeLiquidityETHWithPermit(
337         address token,
338         uint liquidity,
339         uint amountTokenMin,
340         uint amountETHMin,
341         address to,
342         uint deadline,
343         bool approveMax, uint8 v, bytes32 r, bytes32 s
344     ) external returns (uint amountToken, uint amountETH);
345     function swapExactTokensForTokens(
346         uint amountIn,
347         uint amountOutMin,
348         address[] calldata path,
349         address to,
350         uint deadline
351     ) external returns (uint[] memory amounts);
352     function swapTokensForExactTokens(
353         uint amountOut,
354         uint amountInMax,
355         address[] calldata path,
356         address to,
357         uint deadline
358     ) external returns (uint[] memory amounts);
359     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
360         external
361         payable
362         returns (uint[] memory amounts);
363     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
364         external
365         returns (uint[] memory amounts);
366     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
367         external
368         returns (uint[] memory amounts);
369     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
370         external
371         payable
372         returns (uint[] memory amounts);
373 
374     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
375     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
376     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
377     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
378     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
379 }
380 
381 // pragma solidity >=0.6.2;
382 
383 interface IUniswapV2Router02 is IUniswapV2Router01 {
384     function removeLiquidityETHSupportingFeeOnTransferTokens(
385         address token,
386         uint liquidity,
387         uint amountTokenMin,
388         uint amountETHMin,
389         address to,
390         uint deadline
391     ) external returns (uint amountETH);
392     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
393         address token,
394         uint liquidity,
395         uint amountTokenMin,
396         uint amountETHMin,
397         address to,
398         uint deadline,
399         bool approveMax, uint8 v, bytes32 r, bytes32 s
400     ) external returns (uint amountETH);
401 
402     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
403         uint amountIn,
404         uint amountOutMin,
405         address[] calldata path,
406         address to,
407         uint deadline
408     ) external;
409     function swapExactETHForTokensSupportingFeeOnTransferTokens(
410         uint amountOutMin,
411         address[] calldata path,
412         address to,
413         uint deadline
414     ) external payable;
415     function swapExactTokensForETHSupportingFeeOnTransferTokens(
416         uint amountIn,
417         uint amountOutMin,
418         address[] calldata path,
419         address to,
420         uint deadline
421     ) external;
422 }
423 
424 contract ROIToken is Context, IERC20, Ownable {
425     using SafeMath for uint256;
426     using Address for address;
427     
428     address payable public marketingAddress = payable(0x823D23a3fd3b35bacBBf3c71000bE261602eD4B6); // Marketing Address
429     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
430     mapping (address => uint256) private _rOwned;
431     mapping (address => uint256) private _tOwned;
432     mapping (address => mapping (address => uint256)) private _allowances;
433 
434     mapping (address => bool) private _isExcludedFromFee;
435 
436     mapping (address => bool) private _isExcluded;
437     address[] private _excluded;
438    
439     uint256 private constant MAX = ~uint256(0);
440     uint256 private _tTotal = 50 * 10**6 * 10**9;
441     uint256 private _rTotal = (MAX - (MAX % _tTotal));
442     uint256 private _tFeeTotal;
443 
444     string private _name = "Ragnarok Online Invasion";
445     string private _symbol = "$ROI";
446     uint8 private _decimals = 9;
447 
448     struct AddressFee {
449         bool enable;
450         uint256 _taxFee;
451         uint256 _liquidityFee;
452         uint256 _buyTaxFee;
453         uint256 _buyLiquidityFee;
454         uint256 _sellTaxFee;
455         uint256 _sellLiquidityFee;
456     }
457 
458     struct SellHistories {
459         uint256 time;
460         uint256 bnbAmount;
461     }
462 
463     uint256 public _taxFee = 2;
464     uint256 private _previousTaxFee = _taxFee;
465     
466     uint256 public _liquidityFee = 10;
467     uint256 private _previousLiquidityFee = _liquidityFee;
468     
469     uint256 public _buyTaxFee = 2;
470     uint256 public _buyLiquidityFee = 10;
471     
472     uint256 public _sellTaxFee = 7;
473     uint256 public _sellLiquidityFee = 11;
474 
475     uint256 public _startTimeForSwap;
476     uint256 public _intervalMinutesForSwap = 1 * 1 minutes;
477 
478     uint256 public _buyBackRangeRate = 80;
479 
480     // Fee per address
481     mapping (address => AddressFee) public _addressFees;
482 
483     uint256 public marketingDivisor = 4;
484     
485     uint256 public _maxTxAmount = 10000000 * 10**6 * 10**9;
486     uint256 private minimumTokensBeforeSwap = 200000 * 10**6 * 10**9; 
487     uint256 public buyBackSellLimit = 1 * 10**14;
488 
489     // LookBack into historical sale data
490     SellHistories[] public _sellHistories;
491     bool public _isAutoBuyBack = true;
492     uint256 public _buyBackDivisor = 10;
493     uint256 public _buyBackTimeInterval = 5 minutes;
494     uint256 public _buyBackMaxTimeForHistories = 24 * 60 minutes;
495 
496     IUniswapV2Router02 public uniswapV2Router;
497     address public uniswapV2Pair;
498     
499     bool inSwapAndLiquify;
500     bool public swapAndLiquifyEnabled = false;
501     bool public buyBackEnabled = true;
502 
503     bool public _isEnabledBuyBackAndBurn = true;
504     
505     event RewardLiquidityProviders(uint256 tokenAmount);
506     event BuyBackEnabledUpdated(bool enabled);
507     event AutoBuyBackEnabledUpdated(bool enabled);
508     event SwapAndLiquifyEnabledUpdated(bool enabled);
509     event SwapAndLiquify(
510         uint256 tokensSwapped,
511         uint256 ethReceived,
512         uint256 tokensIntoLiqudity
513     );
514 
515     event SwapETHForTokens(
516         uint256 amountIn,
517         address[] path
518     );
519     
520     event SwapTokensForETH(
521         uint256 amountIn,
522         address[] path
523     );
524     
525     modifier lockTheSwap {
526         inSwapAndLiquify = true;
527         _;
528         inSwapAndLiquify = false;
529     }
530     
531     constructor () {
532 
533         _rOwned[_msgSender()] = _rTotal;
534         
535         // Pancake Router Testnet v1
536         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
537         
538         // uniswap Router Testnet v2 - Not existing I guess
539          IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
540 
541         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
542             .createPair(address(this), _uniswapV2Router.WETH());
543 
544         uniswapV2Router = _uniswapV2Router;
545 
546         
547         _isExcludedFromFee[owner()] = true;
548         _isExcludedFromFee[address(this)] = true;
549 
550         _startTimeForSwap = block.timestamp;
551         
552         emit Transfer(address(0), _msgSender(), _tTotal);
553     }
554 
555     function name() public view returns (string memory) {
556         return _name;
557     }
558 
559     function symbol() public view returns (string memory) {
560         return _symbol;
561     }
562 
563     function decimals() public view returns (uint8) {
564         return _decimals;
565     }
566 
567     function totalSupply() public view override returns (uint256) {
568         return _tTotal;
569     }
570 
571     function balanceOf(address account) public view override returns (uint256) {
572         if (_isExcluded[account]) return _tOwned[account];
573         return tokenFromReflection(_rOwned[account]);
574     }
575 
576     function transfer(address recipient, uint256 amount) public override returns (bool) {
577         _transfer(_msgSender(), recipient, amount);
578         return true;
579     }
580 
581     function allowance(address owner, address spender) public view override returns (uint256) {
582         return _allowances[owner][spender];
583     }
584 
585     function approve(address spender, uint256 amount) public override returns (bool) {
586         _approve(_msgSender(), spender, amount);
587         return true;
588     }
589 
590     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
591         _transfer(sender, recipient, amount);
592         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
593         return true;
594     }
595 
596     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
597         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
598         return true;
599     }
600 
601     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
602         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
603         return true;
604     }
605 
606     function isExcludedFromReward(address account) public view returns (bool) {
607         return _isExcluded[account];
608     }
609 
610     function totalFees() public view returns (uint256) {
611         return _tFeeTotal;
612     }
613     
614     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
615         return minimumTokensBeforeSwap;
616     }
617     
618     function buyBackSellLimitAmount() public view returns (uint256) {
619         return buyBackSellLimit;
620     }
621     
622     function deliver(uint256 tAmount) public {
623         address sender = _msgSender();
624         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
625         (uint256 rAmount,,,,,) = _getValues(tAmount);
626         _rOwned[sender] = _rOwned[sender].sub(rAmount);
627         _rTotal = _rTotal.sub(rAmount);
628         _tFeeTotal = _tFeeTotal.add(tAmount);
629     }
630   
631 
632     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
633         require(tAmount <= _tTotal, "Amount must be less than supply");
634         if (!deductTransferFee) {
635             (uint256 rAmount,,,,,) = _getValues(tAmount);
636             return rAmount;
637         } else {
638             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
639             return rTransferAmount;
640         }
641     }
642 
643     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
644         require(rAmount <= _rTotal, "Amount must be less than total reflections");
645         uint256 currentRate =  _getRate();
646         return rAmount.div(currentRate);
647     }
648 
649     function excludeFromReward(address account) public onlyOwner() {
650 
651         require(!_isExcluded[account], "Account is already excluded");
652         if(_rOwned[account] > 0) {
653             _tOwned[account] = tokenFromReflection(_rOwned[account]);
654         }
655         _isExcluded[account] = true;
656         _excluded.push(account);
657     }
658 
659     function includeInReward(address account) external onlyOwner() {
660         require(_isExcluded[account], "Account is not excluded");
661         for (uint256 i = 0; i < _excluded.length; i++) {
662             if (_excluded[i] == account) {
663                 _excluded[i] = _excluded[_excluded.length - 1];
664                 _tOwned[account] = 0;
665                 _isExcluded[account] = false;
666                 _excluded.pop();
667                 break;
668             }
669         }
670     }
671 
672     function _approve(address owner, address spender, uint256 amount) private {
673         require(owner != address(0), "ERC20: approve from the zero address");
674         require(spender != address(0), "ERC20: approve to the zero address");
675 
676         _allowances[owner][spender] = amount;
677         emit Approval(owner, spender, amount);
678     }
679 
680     function _transfer(
681         address from,
682         address to,
683         uint256 amount
684     ) private {
685         require(from != address(0), "ERC20: transfer from the zero address");
686         require(to != address(0), "ERC20: transfer to the zero address");
687         require(amount > 0, "Transfer amount must be greater than zero");
688         if(from != owner() && to != owner()) {
689             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
690         }
691 
692         uint256 contractTokenBalance = balanceOf(address(this));
693         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;    
694 
695         if (to == uniswapV2Pair && balanceOf(uniswapV2Pair) > 0) {
696             SellHistories memory sellHistory;
697             sellHistory.time = block.timestamp;
698             sellHistory.bnbAmount = _getSellBnBAmount(amount);
699 
700             _sellHistories.push(sellHistory);
701         }    
702 
703         // Sell tokens for ETH
704         if (!inSwapAndLiquify && swapAndLiquifyEnabled && balanceOf(uniswapV2Pair) > 0) {
705             if (to == uniswapV2Pair) {
706                 if (overMinimumTokenBalance && _startTimeForSwap + _intervalMinutesForSwap <= block.timestamp) {
707                     _startTimeForSwap = block.timestamp;
708                     contractTokenBalance = minimumTokensBeforeSwap;
709                     swapTokens(contractTokenBalance);    
710                 }  
711 
712                 if (buyBackEnabled) {
713 
714                     uint256 balance = address(this).balance;
715                 
716                     uint256 _bBSLimitMax = buyBackSellLimit;
717 
718                     if (_isAutoBuyBack) {
719 
720                         uint256 sumBnbAmount = 0;
721                         uint256 startTime = block.timestamp - _buyBackTimeInterval;
722                         uint256 cnt = 0;
723 
724                         for (uint i = 0; i < _sellHistories.length; i ++) {
725                             
726                             if (_sellHistories[i].time >= startTime) {
727                                 sumBnbAmount = sumBnbAmount.add(_sellHistories[i].bnbAmount);
728                                 cnt = cnt + 1;
729                             }
730                         }
731 
732                         if (cnt > 0 && _buyBackDivisor > 0) {
733                             _bBSLimitMax = sumBnbAmount.div(cnt).div(_buyBackDivisor);
734                         }
735 
736                         _removeOldSellHistories();
737                     }
738 
739                     uint256 _bBSLimitMin = _bBSLimitMax.mul(_buyBackRangeRate).div(100);
740 
741                     uint256 _bBSLimit = _bBSLimitMin + uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % (_bBSLimitMax - _bBSLimitMin + 1);
742 
743                     if (balance > _bBSLimit) {
744                         buyBackTokens(_bBSLimit);
745                     } 
746                 }
747             }
748             
749         }
750 
751         bool takeFee = true;
752         
753         // If any account belongs to _isExcludedFromFee account then remove the fee
754         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
755             takeFee = false;
756         }
757         else{
758             // Buy
759             if(from == uniswapV2Pair){
760                 removeAllFee();
761                 _taxFee = _buyTaxFee;
762                 _liquidityFee = _buyLiquidityFee;
763             }
764             // Sell
765             if(to == uniswapV2Pair){
766                 removeAllFee();
767                 _taxFee = _sellTaxFee;
768                 _liquidityFee = _sellLiquidityFee;
769             }
770             
771             // If send account has a special fee 
772             if(_addressFees[from].enable){
773                 removeAllFee();
774                 _taxFee = _addressFees[from]._taxFee;
775                 _liquidityFee = _addressFees[from]._liquidityFee;
776                 
777                 // Sell
778                 if(to == uniswapV2Pair){
779                     _taxFee = _addressFees[from]._sellTaxFee;
780                     _liquidityFee = _addressFees[from]._sellLiquidityFee;
781                 }
782             }
783             else{
784                 // If buy account has a special fee
785                 if(_addressFees[to].enable){
786                     //buy
787                     removeAllFee();
788                     if(from == uniswapV2Pair){
789                         _taxFee = _addressFees[to]._buyTaxFee;
790                         _liquidityFee = _addressFees[to]._buyLiquidityFee;
791                     }
792                 }
793             }
794         }
795         
796         _tokenTransfer(from,to,amount,takeFee);
797     }
798 
799     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
800        
801         uint256 initialBalance = address(this).balance;
802         swapTokensForEth(contractTokenBalance);
803         uint256 transferredBalance = address(this).balance.sub(initialBalance);
804 
805         // Send to Marketing address
806         transferToAddressETH(marketingAddress, transferredBalance.mul(marketingDivisor).div(100));
807         
808     }
809     
810 
811     function buyBackTokens(uint256 amount) private lockTheSwap {
812     	if (amount > 0) {
813     	    swapETHForTokens(amount);
814 	    }
815     }
816     
817     function swapTokensForEth(uint256 tokenAmount) private {
818         // Generate the uniswap pair path of token -> WETH
819         address[] memory path = new address[](2);
820         path[0] = address(this);
821         path[1] = uniswapV2Router.WETH();
822 
823         _approve(address(this), address(uniswapV2Router), tokenAmount);
824 
825         // Make the swap
826         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
827             tokenAmount,
828             0, // Accept any amount of ETH
829             path,
830             address(this), // The contract
831             block.timestamp
832         );
833         
834         emit SwapTokensForETH(tokenAmount, path);
835     }
836     
837     function swapETHForTokens(uint256 amount) private {
838         // Generate the uniswap pair path of token -> WETH
839         address[] memory path = new address[](2);
840         path[0] = uniswapV2Router.WETH();
841         path[1] = address(this);
842 
843       // Make the swap
844         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
845             0, // Accept any amount of Tokens
846             path,
847             deadAddress, // Burn address
848             block.timestamp.add(300)
849         );
850         
851         emit SwapETHForTokens(amount, path);
852     }
853     
854     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
855         // Approve token transfer to cover all possible scenarios
856         _approve(address(this), address(uniswapV2Router), tokenAmount);
857 
858         // Add the liquidity
859         uniswapV2Router.addLiquidityETH{value: ethAmount}(
860             address(this),
861             tokenAmount,
862             0, // Slippage is unavoidable
863             0, // Slippage is unavoidable
864             owner(),
865             block.timestamp
866         );
867     }
868 
869     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
870         if(!takeFee)
871             removeAllFee();
872         
873         if (_isExcluded[sender] && !_isExcluded[recipient]) {
874             _transferFromExcluded(sender, recipient, amount);
875         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
876             _transferToExcluded(sender, recipient, amount);
877         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
878             _transferBothExcluded(sender, recipient, amount);
879         } else {
880             _transferStandard(sender, recipient, amount);
881         }
882         
883         if(!takeFee)
884             restoreAllFee();
885     }
886 
887     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
888         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
889         _rOwned[sender] = _rOwned[sender].sub(rAmount);
890         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
891         _takeLiquidity(tLiquidity);
892         _reflectFee(rFee, tFee);
893         emit Transfer(sender, recipient, tTransferAmount);
894     }
895 
896     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
897         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
898 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
899         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
900         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
901         _takeLiquidity(tLiquidity);
902         _reflectFee(rFee, tFee);
903         emit Transfer(sender, recipient, tTransferAmount);
904     }
905 
906     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
907         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
908     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
909         _rOwned[sender] = _rOwned[sender].sub(rAmount);
910         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
911         _takeLiquidity(tLiquidity);
912         _reflectFee(rFee, tFee);
913         emit Transfer(sender, recipient, tTransferAmount);
914     }
915 
916     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
917         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
918     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
919         _rOwned[sender] = _rOwned[sender].sub(rAmount);
920         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
921         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
922         _takeLiquidity(tLiquidity);
923         _reflectFee(rFee, tFee);
924         emit Transfer(sender, recipient, tTransferAmount);
925     }
926 
927     function _reflectFee(uint256 rFee, uint256 tFee) private {
928         _rTotal = _rTotal.sub(rFee);
929         _tFeeTotal = _tFeeTotal.add(tFee);
930     }
931 
932     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
933         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
934         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
935         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
936     }
937 
938     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
939         uint256 tFee = calculateTaxFee(tAmount);
940         uint256 tLiquidity = calculateLiquidityFee(tAmount);
941         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
942         return (tTransferAmount, tFee, tLiquidity);
943     }
944 
945     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
946         uint256 rAmount = tAmount.mul(currentRate);
947         uint256 rFee = tFee.mul(currentRate);
948         uint256 rLiquidity = tLiquidity.mul(currentRate);
949         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
950         return (rAmount, rTransferAmount, rFee);
951     }
952 
953     function _getRate() private view returns(uint256) {
954         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
955         return rSupply.div(tSupply);
956     }
957 
958     function _getCurrentSupply() private view returns(uint256, uint256) {
959         uint256 rSupply = _rTotal;
960         uint256 tSupply = _tTotal;      
961         for (uint256 i = 0; i < _excluded.length; i++) {
962             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
963             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
964             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
965         }
966         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
967         return (rSupply, tSupply);
968     }
969     
970     function _takeLiquidity(uint256 tLiquidity) private {
971         uint256 currentRate =  _getRate();
972         uint256 rLiquidity = tLiquidity.mul(currentRate);
973         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
974         if(_isExcluded[address(this)])
975             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
976     }
977     
978     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
979         return _amount.mul(_taxFee).div(
980             10**2
981         );
982     }
983     
984     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
985         return _amount.mul(_liquidityFee).div(
986             10**2
987         );
988     }
989     
990     function removeAllFee() private {
991         if(_taxFee == 0 && _liquidityFee == 0) return;
992         
993         _previousTaxFee = _taxFee;
994         _previousLiquidityFee = _liquidityFee;
995         
996         _taxFee = 0;
997         _liquidityFee = 0;
998     }
999     
1000     function restoreAllFee() private {
1001         _taxFee = _previousTaxFee;
1002         _liquidityFee = _previousLiquidityFee;
1003     }
1004 
1005     function isExcludedFromFee(address account) public view returns(bool) {
1006         return _isExcludedFromFee[account];
1007     }
1008     
1009     function excludeFromFee(address account) public onlyOwner {
1010         _isExcludedFromFee[account] = true;
1011     }
1012     
1013     function includeInFee(address account) public onlyOwner {
1014         _isExcludedFromFee[account] = false;
1015     }
1016 
1017 
1018     function _getSellBnBAmount(uint256 tokenAmount) private view returns(uint256) {
1019         address[] memory path = new address[](2);
1020 
1021         path[0] = address(this);
1022         path[1] = uniswapV2Router.WETH();
1023 
1024         uint[] memory amounts = uniswapV2Router.getAmountsOut(tokenAmount, path);
1025 
1026         return amounts[1];
1027     }
1028 
1029     function _removeOldSellHistories() private {
1030         uint256 i = 0;
1031         uint256 maxStartTimeForHistories = block.timestamp - _buyBackMaxTimeForHistories;
1032 
1033         for (uint256 j = 0; j < _sellHistories.length; j ++) {
1034 
1035             if (_sellHistories[j].time >= maxStartTimeForHistories) {
1036 
1037                 _sellHistories[i].time = _sellHistories[j].time;
1038                 _sellHistories[i].bnbAmount = _sellHistories[j].bnbAmount;
1039 
1040                 i = i + 1;
1041             }
1042         }
1043 
1044         uint256 removedCnt = _sellHistories.length - i;
1045 
1046         for (uint256 j = 0; j < removedCnt; j ++) {
1047             
1048             _sellHistories.pop();
1049         }
1050         
1051     }
1052 
1053     function SetBuyBackMaxTimeForHistories(uint256 newMinutes) external onlyOwner {
1054         _buyBackMaxTimeForHistories = newMinutes * 1 minutes;
1055     }
1056 
1057     function SetBuyBackDivisor(uint256 newDivisor) external onlyOwner {
1058         _buyBackDivisor = newDivisor;
1059     }
1060 
1061     function GetBuyBackTimeInterval() public view returns(uint256) {
1062         return _buyBackTimeInterval.div(60);
1063     }
1064 
1065     function SetBuyBackTimeInterval(uint256 newMinutes) external onlyOwner {
1066         _buyBackTimeInterval = newMinutes * 1 minutes;
1067     }
1068 
1069     function SetBuyBackRangeRate(uint256 newPercent) external onlyOwner {
1070         require(newPercent <= 100, "The value must not be larger than 100.");
1071         _buyBackRangeRate = newPercent;
1072     }
1073 
1074     function GetSwapMinutes() public view returns(uint256) {
1075         return _intervalMinutesForSwap.div(60);
1076     }
1077 
1078     function SetSwapMinutes(uint256 newMinutes) external onlyOwner {
1079         _intervalMinutesForSwap = newMinutes * 1 minutes;
1080     }
1081     
1082     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1083         _taxFee = taxFee;
1084     }
1085         
1086     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee) external onlyOwner {
1087         _buyTaxFee = buyTaxFee;
1088         _buyLiquidityFee = buyLiquidityFee;
1089     }
1090    
1091     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee) external onlyOwner {
1092         _sellTaxFee = sellTaxFee;
1093         _sellLiquidityFee = sellLiquidityFee;
1094     }
1095     
1096     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner {
1097         _liquidityFee = liquidityFee;
1098     }
1099 
1100     function setBuyBackSellLimit(uint256 buyBackSellSetLimit) external onlyOwner {
1101         buyBackSellLimit = buyBackSellSetLimit;
1102     }
1103 
1104     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
1105         _maxTxAmount = maxTxAmount;
1106     }
1107     
1108     function setMarketingDivisor(uint256 divisor) external onlyOwner {
1109         marketingDivisor = divisor;
1110     }
1111 
1112     function setNumTokensSellToAddToBuyBack(uint256 _minimumTokensBeforeSwap) external onlyOwner {
1113         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1114     }
1115 
1116     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1117         marketingAddress = payable(_marketingAddress);
1118     }
1119 
1120     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1121         swapAndLiquifyEnabled = _enabled;
1122         emit SwapAndLiquifyEnabledUpdated(_enabled);
1123     }
1124     
1125     function setBuyBackEnabled(bool _enabled) public onlyOwner {
1126         buyBackEnabled = _enabled;
1127         emit BuyBackEnabledUpdated(_enabled);
1128     }
1129 
1130     function setAutoBuyBackEnabled(bool _enabled) public onlyOwner {
1131         _isAutoBuyBack = _enabled;
1132         emit AutoBuyBackEnabledUpdated(_enabled);
1133     }
1134     
1135     function prepareForPreSale() external onlyOwner {
1136         setSwapAndLiquifyEnabled(false);
1137         _taxFee = 0;
1138         _liquidityFee = 0;
1139         _maxTxAmount = 1000000000 * 10**6 * 10**9;
1140     }
1141     
1142     function afterPreSale() external onlyOwner {
1143         setSwapAndLiquifyEnabled(true);
1144         _taxFee = 2;
1145         _liquidityFee = 10;
1146         _maxTxAmount = 10000000 * 10**6 * 10**9;
1147     }
1148     
1149     function transferToAddressETH(address payable recipient, uint256 amount) private {
1150         recipient.transfer(amount);
1151     }
1152 
1153     function changeRouterVersion(address _router) public onlyOwner returns(address _pair) {
1154         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
1155         
1156         _pair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
1157         if(_pair == address(0)){
1158             // Pair doesn't exist
1159             _pair = IUniswapV2Factory(_uniswapV2Router.factory())
1160             .createPair(address(this), _uniswapV2Router.WETH());
1161         }
1162         uniswapV2Pair = _pair;
1163 
1164         // Set the router of the contract variables
1165         uniswapV2Router = _uniswapV2Router;
1166     }
1167     
1168      // To recieve ETH from uniswapV2Router when swapping
1169     receive() external payable {}
1170 
1171        
1172     function transferForeignToken(address _token, address _to) public onlyOwner returns(bool _sent){
1173         require(_token != address(this), "Can't let you take all native token");
1174         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1175         _sent = IERC20(_token).transfer(_to, _contractBalance);
1176     }
1177     
1178     function Sweep() external onlyOwner {
1179         uint256 balance = address(this).balance;
1180         payable(owner()).transfer(balance);
1181     }
1182 
1183     function Sweep(uint256 amount) external onlyOwner {
1184         uint256 balance = address(this).balance;
1185         require(amount <= balance, "So many token amount!");
1186         payable(owner()).transfer(amount);
1187     }
1188 
1189     function setAddressFee(address _address, bool _enable, uint256 _addressTaxFee, uint256 _addressLiquidityFee) external onlyOwner {
1190         _addressFees[_address].enable = _enable;
1191         _addressFees[_address]._taxFee = _addressTaxFee;
1192         _addressFees[_address]._liquidityFee = _addressLiquidityFee;
1193     }
1194     
1195     function setBuyAddressFee(address _address, bool _enable, uint256 _addressTaxFee, uint256 _addressLiquidityFee) external onlyOwner {
1196         _addressFees[_address].enable = _enable;
1197         _addressFees[_address]._buyTaxFee = _addressTaxFee;
1198         _addressFees[_address]._buyLiquidityFee = _addressLiquidityFee;
1199     }
1200     
1201     function setSellAddressFee(address _address, bool _enable, uint256 _addressTaxFee, uint256 _addressLiquidityFee) external onlyOwner {
1202         _addressFees[_address].enable = _enable;
1203         _addressFees[_address]._sellTaxFee = _addressTaxFee;
1204         _addressFees[_address]._sellLiquidityFee = _addressLiquidityFee;
1205     }
1206     
1207 }