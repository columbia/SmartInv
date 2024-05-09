1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 
17 interface IERC20 {
18 
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27     
28 
29 }
30 
31 library SafeMath {
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58 
59         return c;
60     }
61 
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return mod(a, b, "SafeMath: modulo by zero");
77     }
78 
79     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b != 0, errorMessage);
81         return a % b;
82     }
83 }
84 
85 library Address {
86 
87     function isContract(address account) internal view returns (bool) {
88         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
89         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
90         // for accounts without code, i.e. `keccak256('')`
91         bytes32 codehash;
92         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
93         // solhint-disable-next-line no-inline-assembly
94         assembly { codehash := extcodehash(account) }
95         return (codehash != accountHash && codehash != 0x0);
96     }
97 
98     function sendValue(address payable recipient, uint256 amount) internal {
99         require(address(this).balance >= amount, "Address: insufficient balance");
100 
101         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
102         (bool success, ) = recipient.call{ value: amount }("");
103         require(success, "Address: unable to send value, recipient may have reverted");
104     }
105 
106 
107     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
108       return functionCall(target, data, "Address: low-level call failed");
109     }
110 
111     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
112         return _functionCallWithValue(target, data, 0, errorMessage);
113     }
114 
115     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
120         require(address(this).balance >= value, "Address: insufficient balance for call");
121         return _functionCallWithValue(target, data, value, errorMessage);
122     }
123 
124     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
125         require(isContract(target), "Address: call to non-contract");
126 
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131             
132             if (returndata.length > 0) {
133                 assembly {
134                     let returndata_size := mload(returndata)
135                     revert(add(32, returndata), returndata_size)
136                 }
137             } else {
138                 revert(errorMessage);
139             }
140         }
141     }
142 }
143 
144 contract Ownable is Context {
145     address private _owner;
146     address private _previousOwner;
147     uint256 private _lockTime;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151     constructor () {
152         address msgSender = _msgSender();
153         _owner = msgSender;
154         emit OwnershipTransferred(address(0), msgSender);
155     }
156 
157     function owner() public view returns (address) {
158         return _owner;
159     }   
160     
161     modifier onlyOwner() {
162         require(_owner == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165     
166     function renounceOwnership() public virtual onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 }
177 
178 // pragma solidity >=0.5.0;
179 
180 interface IUniswapV2Factory {
181     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
182 
183     function feeTo() external view returns (address);
184     function feeToSetter() external view returns (address);
185 
186     function getPair(address tokenA, address tokenB) external view returns (address pair);
187     function allPairs(uint) external view returns (address pair);
188     function allPairsLength() external view returns (uint);
189 
190     function createPair(address tokenA, address tokenB) external returns (address pair);
191 
192     function setFeeTo(address) external;
193     function setFeeToSetter(address) external;
194 }
195 
196 
197 // pragma solidity >=0.5.0;
198 
199 interface IUniswapV2Pair {
200     event Approval(address indexed owner, address indexed spender, uint value);
201     event Transfer(address indexed from, address indexed to, uint value);
202 
203     function name() external pure returns (string memory);
204     function symbol() external pure returns (string memory);
205     function decimals() external pure returns (uint8);
206     function totalSupply() external view returns (uint);
207     function balanceOf(address owner) external view returns (uint);
208     function allowance(address owner, address spender) external view returns (uint);
209 
210     function approve(address spender, uint value) external returns (bool);
211     function transfer(address to, uint value) external returns (bool);
212     function transferFrom(address from, address to, uint value) external returns (bool);
213 
214     function DOMAIN_SEPARATOR() external view returns (bytes32);
215     function PERMIT_TYPEHASH() external pure returns (bytes32);
216     function nonces(address owner) external view returns (uint);
217 
218     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
219     
220     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
221     event Swap(
222         address indexed sender,
223         uint amount0In,
224         uint amount1In,
225         uint amount0Out,
226         uint amount1Out,
227         address indexed to
228     );
229     event Sync(uint112 reserve0, uint112 reserve1);
230 
231     function MINIMUM_LIQUIDITY() external pure returns (uint);
232     function factory() external view returns (address);
233     function token0() external view returns (address);
234     function token1() external view returns (address);
235     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
236     function price0CumulativeLast() external view returns (uint);
237     function price1CumulativeLast() external view returns (uint);
238     function kLast() external view returns (uint);
239 
240     function burn(address to) external returns (uint amount0, uint amount1);
241     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
242     function skim(address to) external;
243     function sync() external;
244 
245     function initialize(address, address) external;
246 }
247 
248 // pragma solidity >=0.6.2;
249 
250 interface IUniswapV2Router01 {
251     function factory() external pure returns (address);
252     function WETH() external pure returns (address);
253 
254     function addLiquidity(
255         address tokenA,
256         address tokenB,
257         uint amountADesired,
258         uint amountBDesired,
259         uint amountAMin,
260         uint amountBMin,
261         address to,
262         uint deadline
263     ) external returns (uint amountA, uint amountB, uint liquidity);
264     function addLiquidityETH(
265         address token,
266         uint amountTokenDesired,
267         uint amountTokenMin,
268         uint amountETHMin,
269         address to,
270         uint deadline
271     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
272     function removeLiquidity(
273         address tokenA,
274         address tokenB,
275         uint liquidity,
276         uint amountAMin,
277         uint amountBMin,
278         address to,
279         uint deadline
280     ) external returns (uint amountA, uint amountB);
281     function removeLiquidityETH(
282         address token,
283         uint liquidity,
284         uint amountTokenMin,
285         uint amountETHMin,
286         address to,
287         uint deadline
288     ) external returns (uint amountToken, uint amountETH);
289     function removeLiquidityWithPermit(
290         address tokenA,
291         address tokenB,
292         uint liquidity,
293         uint amountAMin,
294         uint amountBMin,
295         address to,
296         uint deadline,
297         bool approveMax, uint8 v, bytes32 r, bytes32 s
298     ) external returns (uint amountA, uint amountB);
299     function removeLiquidityETHWithPermit(
300         address token,
301         uint liquidity,
302         uint amountTokenMin,
303         uint amountETHMin,
304         address to,
305         uint deadline,
306         bool approveMax, uint8 v, bytes32 r, bytes32 s
307     ) external returns (uint amountToken, uint amountETH);
308     function swapExactTokensForTokens(
309         uint amountIn,
310         uint amountOutMin,
311         address[] calldata path,
312         address to,
313         uint deadline
314     ) external returns (uint[] memory amounts);
315     function swapTokensForExactTokens(
316         uint amountOut,
317         uint amountInMax,
318         address[] calldata path,
319         address to,
320         uint deadline
321     ) external returns (uint[] memory amounts);
322     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
323         external
324         payable
325         returns (uint[] memory amounts);
326     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
327         external
328         returns (uint[] memory amounts);
329     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
330         external
331         returns (uint[] memory amounts);
332     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
333         external
334         payable
335         returns (uint[] memory amounts);
336 
337     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
338     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
339     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
340     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
341     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
342 }
343 
344 
345 
346 // pragma solidity >=0.6.2;
347 
348 interface IUniswapV2Router02 is IUniswapV2Router01 {
349     function removeLiquidityETHSupportingFeeOnTransferTokens(
350         address token,
351         uint liquidity,
352         uint amountTokenMin,
353         uint amountETHMin,
354         address to,
355         uint deadline
356     ) external returns (uint amountETH);
357     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
358         address token,
359         uint liquidity,
360         uint amountTokenMin,
361         uint amountETHMin,
362         address to,
363         uint deadline,
364         bool approveMax, uint8 v, bytes32 r, bytes32 s
365     ) external returns (uint amountETH);
366 
367     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
368         uint amountIn,
369         uint amountOutMin,
370         address[] calldata path,
371         address to,
372         uint deadline
373     ) external;
374     function swapExactETHForTokensSupportingFeeOnTransferTokens(
375         uint amountOutMin,
376         address[] calldata path,
377         address to,
378         uint deadline
379     ) external payable;
380     function swapExactTokensForETHSupportingFeeOnTransferTokens(
381         uint amountIn,
382         uint amountOutMin,
383         address[] calldata path,
384         address to,
385         uint deadline
386     ) external;
387 }
388 
389 contract SaintInu is Context, IERC20, Ownable {
390     using SafeMath for uint256;
391     using Address for address;
392     
393     address payable public marketingAddress = payable(0x60a678BFDF15D5c271294acF36fe311e2d4C204D); 
394     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
395     mapping (address => uint256) private _rOwned;
396     mapping (address => uint256) private _tOwned;
397     mapping (address => mapping (address => uint256)) private _allowances;
398     mapping (address => uint) private cooldown;
399    
400     mapping (address => bool) private _isExcludedFromFee;
401     mapping (address => bool) private _isExcluded;
402     address[] private _excluded;
403    
404     uint256 private constant MAX = ~uint256(0);
405     uint256 private _tTotal = 1e12 * 10**9;
406     uint256 private _rTotal = (MAX - (MAX % _tTotal));
407     uint256 private _tFeeTotal;
408 
409     string private _name = "Saint Inu";
410     string private _symbol = "SAINT";
411     uint8 private _decimals = 9;
412 
413 
414     uint256 public _sellFee;
415     uint256 public _buyFee;
416     uint256 public _taxFee;
417     uint256 private _previousTaxFee = _taxFee;
418     uint256 private _liquidityFee;
419     uint256 private _previousLiquidityFee = _liquidityFee;
420     uint256 private _maxTxAmount;
421     
422     
423     IUniswapV2Router02 public uniswapV2Router;
424     address public uniswapV2Pair;
425     
426     bool inSwap;
427     
428     bool tradingOpen = false;
429     
430     event SwapETHForTokens(
431         uint256 amountIn,
432         address[] path
433     );
434     
435     event SwapTokensForETH(
436         uint256 amountIn,
437         address[] path
438     );
439     
440     modifier lockTheSwap {
441         inSwap = true;
442         _;
443         inSwap = false;
444     }
445     
446 
447     constructor () {
448         _rOwned[_msgSender()] = _rTotal;
449         emit Transfer(address(0), _msgSender(), _tTotal);
450     }
451     
452     function initContract() external onlyOwner() {
453         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
454         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
455         .createPair(address(this), _uniswapV2Router.WETH());
456 
457         uniswapV2Router = _uniswapV2Router;
458 
459         _isExcludedFromFee[owner()] = true;
460         _isExcludedFromFee[address(this)] = true;
461     }
462     
463     function oopenTrading() external onlyOwner() {
464         _buyFee = 2;
465         _sellFee = 8;
466         _taxFee=2;
467         tradingOpen = true;
468         _maxTxAmount = 5e9 * 10**9;
469     }
470 
471     function name() public view returns (string memory) {
472         return _name;
473     }
474 
475     function symbol() public view returns (string memory) {
476         return _symbol;
477     }
478 
479     function decimals() public view returns (uint8) {
480         return _decimals;
481     }
482 
483     function totalSupply() public view override returns (uint256) {
484         return _tTotal;
485     }
486 
487     function balanceOf(address account) public view override returns (uint256) {
488         if (_isExcluded[account]) return _tOwned[account];
489         return tokenFromReflection(_rOwned[account]);
490     }
491 
492     function transfer(address recipient, uint256 amount) public override returns (bool) {
493         _transfer(_msgSender(), recipient, amount);
494         return true;
495     }
496 
497     function allowance(address owner, address spender) public view override returns (uint256) {
498         return _allowances[owner][spender];
499     }
500 
501     function approve(address spender, uint256 amount) public override returns (bool) {
502         _approve(_msgSender(), spender, amount);
503         return true;
504     }
505 
506     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
507         _transfer(sender, recipient, amount);
508         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
509         return true;
510     }
511 
512     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
513         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
514         return true;
515     }
516 
517     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
518         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
519         return true;
520     }
521 
522     function isExcludedFromReward(address account) public view returns (bool) {
523         return _isExcluded[account];
524     }
525 
526     function totalFees() public view returns (uint256) {
527         return _tFeeTotal;
528     }
529     
530   
531     
532     function deliver(uint256 tAmount) public {
533         address sender = _msgSender();
534         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
535         (uint256 rAmount,,,,,) = _getValues(tAmount);
536         _rOwned[sender] = _rOwned[sender].sub(rAmount);
537         _rTotal = _rTotal.sub(rAmount);
538         _tFeeTotal = _tFeeTotal.add(tAmount);
539     }
540   
541 
542     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
543         require(tAmount <= _tTotal, "Amount must be less than supply");
544         if (!deductTransferFee) {
545             (uint256 rAmount,,,,,) = _getValues(tAmount);
546             return rAmount;
547         } else {
548             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
549             return rTransferAmount;
550         }
551     }
552 
553     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
554         require(rAmount <= _rTotal, "Amount must be less than total reflections");
555         uint256 currentRate =  _getRate();
556         return rAmount.div(currentRate);
557     }
558 
559     function excludeFromReward(address account) public onlyOwner() {
560 
561         require(!_isExcluded[account], "Account is already excluded");
562         if(_rOwned[account] > 0) {
563             _tOwned[account] = tokenFromReflection(_rOwned[account]);
564         }
565         _isExcluded[account] = true;
566         _excluded.push(account);
567     }
568 
569     function includeInReward(address account) external onlyOwner() {
570         require(_isExcluded[account], "Account is already excluded");
571         for (uint256 i = 0; i < _excluded.length; i++) {
572             if (_excluded[i] == account) {
573                 _excluded[i] = _excluded[_excluded.length - 1];
574                 _tOwned[account] = 0;
575                 _isExcluded[account] = false;
576                 _excluded.pop();
577                 break;
578             }
579         }
580     }
581 
582     function _approve(address owner, address spender, uint256 amount) private {
583         require(owner != address(0), "ERC20: approve from the zero address");
584         require(spender != address(0), "ERC20: approve to the zero address");
585 
586         _allowances[owner][spender] = amount;
587         emit Approval(owner, spender, amount);
588     }
589 
590     function _transfer(
591         address from,
592         address to,
593         uint256 amount
594     ) private {
595         require(from != address(0), "ERC20: transfer from the zero address");
596         require(to != address(0), "ERC20: transfer to the zero address");
597         require(amount > 0, "Transfer amount must be greater than zero");
598        if (from!= owner() && to!= owner()) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
599 
600        
601         // buy
602         if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
603             require(amount <= _maxTxAmount);
604             require(cooldown[to] < block.timestamp);
605             cooldown[to] = block.timestamp + (30 seconds);
606             
607             _liquidityFee = _buyFee;
608             
609         }
610 
611         uint256 contractTokenBalance = balanceOf(address(this));
612         
613         //sell
614         if (!inSwap && to == uniswapV2Pair) {
615             if(contractTokenBalance > 0) {
616                 if(contractTokenBalance > 0)
617                 swapTokens(contractTokenBalance);    
618             }
619             
620             _liquidityFee = _sellFee;
621         }
622         
623         bool takeFee = false;
624         
625         //take fee only on swaps
626         if ( (from==uniswapV2Pair || to==uniswapV2Pair) && !(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {
627             takeFee = true;
628         }
629         
630         _tokenTransfer(from,to,amount,takeFee);
631     }
632 
633     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
634         swapTokensForEth(contractTokenBalance);
635         
636         //Send to Marketing address
637         uint256 contractETHBalance = address(this).balance;
638         if(contractETHBalance > 0) {
639             sendETHToFee(address(this).balance);
640         }
641     }
642     
643     function sendETHToFee(uint256 amount) private {
644         marketingAddress.transfer(amount);
645     }
646     
647 
648    
649     function swapTokensForEth(uint256 tokenAmount) private {
650         // generate the uniswap pair path of token -> weth
651         address[] memory path = new address[](2);
652         path[0] = address(this);
653         path[1] = uniswapV2Router.WETH();
654 
655         _approve(address(this), address(uniswapV2Router), tokenAmount);
656 
657         // make the swap
658         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
659             tokenAmount,
660             0, // accept any amount of ETH
661             path,
662             address(this), // The contract
663             block.timestamp
664         );
665         
666         emit SwapTokensForETH(tokenAmount, path);
667     }
668     
669 
670     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
671         // approve token transfer to cover all possible scenarios
672         _approve(address(this), address(uniswapV2Router), tokenAmount);
673 
674         // add the liquidity
675         uniswapV2Router.addLiquidityETH{value: ethAmount}(
676             address(this),
677             tokenAmount,
678             0, // slippage is unavoidable
679             0, // slippage is unavoidable
680             owner(),
681             block.timestamp
682         );
683     }
684 
685     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
686         if(!takeFee)
687             removeAllFee();
688         
689         if (_isExcluded[sender] && !_isExcluded[recipient]) {
690             _transferFromExcluded(sender, recipient, amount);
691         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
692             _transferToExcluded(sender, recipient, amount);
693         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
694             _transferBothExcluded(sender, recipient, amount);
695         } else {
696             _transferStandard(sender, recipient, amount);
697         }
698         
699         if(!takeFee)
700             restoreAllFee();
701     }
702 
703     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
704         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
705         _rOwned[sender] = _rOwned[sender].sub(rAmount);
706         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
707         _takeLiquidity(tLiquidity);
708         _reflectFee(rFee, tFee);
709         emit Transfer(sender, recipient, tTransferAmount);
710     }
711 
712     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
713         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
714         _rOwned[sender] = _rOwned[sender].sub(rAmount);
715         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
716         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
717         _takeLiquidity(tLiquidity);
718         _reflectFee(rFee, tFee);
719         emit Transfer(sender, recipient, tTransferAmount);
720     }
721 
722     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
723         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
724         _tOwned[sender] = _tOwned[sender].sub(tAmount);
725         _rOwned[sender] = _rOwned[sender].sub(rAmount);
726         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
727         _takeLiquidity(tLiquidity);
728         _reflectFee(rFee, tFee);
729         emit Transfer(sender, recipient, tTransferAmount);
730     }
731 
732     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
733         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
734         _tOwned[sender] = _tOwned[sender].sub(tAmount);
735         _rOwned[sender] = _rOwned[sender].sub(rAmount);
736         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
737         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
738         _takeLiquidity(tLiquidity);
739         _reflectFee(rFee, tFee);
740         emit Transfer(sender, recipient, tTransferAmount);
741     }
742 
743     function _reflectFee(uint256 rFee, uint256 tFee) private {
744         _rTotal = _rTotal.sub(rFee);
745         _tFeeTotal = _tFeeTotal.add(tFee);
746     }
747 
748     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
749         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
750         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
751         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
752     }
753 
754     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
755         uint256 tFee = calculateTaxFee(tAmount);
756         uint256 tLiquidity = calculateLiquidityFee(tAmount);
757         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
758         return (tTransferAmount, tFee, tLiquidity);
759     }
760 
761     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
762         uint256 rAmount = tAmount.mul(currentRate);
763         uint256 rFee = tFee.mul(currentRate);
764         uint256 rLiquidity = tLiquidity.mul(currentRate);
765         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
766         return (rAmount, rTransferAmount, rFee);
767     }
768 
769     function _getRate() private view returns(uint256) {
770         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
771         return rSupply.div(tSupply);
772     }
773 
774     function _getCurrentSupply() private view returns(uint256, uint256) {
775         uint256 rSupply = _rTotal;
776         uint256 tSupply = _tTotal;      
777         for (uint256 i = 0; i < _excluded.length; i++) {
778             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
779             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
780             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
781         }
782         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
783         return (rSupply, tSupply);
784     }
785     
786     function _takeLiquidity(uint256 tLiquidity) private {
787         uint256 currentRate =  _getRate();
788         uint256 rLiquidity = tLiquidity.mul(currentRate);
789         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
790         if(_isExcluded[address(this)])
791             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
792     }
793     
794     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
795         return _amount.mul(_taxFee).div(
796             10**2
797         );
798     }
799     
800     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
801         return _amount.mul(_liquidityFee).div(
802             10**2
803         );
804     }
805     
806     function removeAllFee() private {
807         if(_taxFee == 0 && _liquidityFee == 0) return;
808         
809         _previousTaxFee = _taxFee;
810         _previousLiquidityFee = _liquidityFee;
811         
812         _taxFee = 0;
813         _liquidityFee = 0;
814     }
815     
816     function restoreAllFee() private {
817         _taxFee = _previousTaxFee;
818         _liquidityFee = _previousLiquidityFee;
819     }
820 
821     function isExcludedFromFee(address account) public view returns(bool) {
822         return _isExcludedFromFee[account];
823     }
824     
825     function excludeFromFee(address account) public onlyOwner {
826         _isExcludedFromFee[account] = true;
827     }
828     
829     function includeInFee(address account) public onlyOwner {
830         _isExcludedFromFee[account] = false;
831     }
832     
833     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
834         require (taxFee <= 2, "taxFee can't exceed 2%");
835         _taxFee = taxFee;
836     }
837     
838     function setBuyFee(uint256 buyFee) external onlyOwner() {
839         require (buyFee <= 2, "buy Fee can't exceed 2%");
840         _buyFee = buyFee;
841     }
842     
843     function setSellFee(uint256 sellFee) external onlyOwner() {
844         require (sellFee <= 8, "sell fee can't exceed 8%");
845         _sellFee = sellFee;
846     }
847     
848     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
849         marketingAddress = payable(_marketingAddress);
850     }
851     
852     function transferToAddressETH(address payable recipient, uint256 amount) private {
853         recipient.transfer(amount);
854     }
855     
856     function removeStrictTxLimit() external onlyOwner {
857         _maxTxAmount = 1e12 * 10**9;
858     }
859     
860 
861      //to recieve ETH from uniswapV2Router when swaping
862     receive() external payable {}
863 }