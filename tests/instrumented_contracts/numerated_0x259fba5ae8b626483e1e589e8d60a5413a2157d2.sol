1 pragma solidity ^0.8.4;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return payable(msg.sender);
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 
15 interface IERC20 {
16 
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25     
26 
27 }
28 
29 library SafeMath {
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53 
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56 
57         return c;
58     }
59 
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 
70         return c;
71     }
72 
73     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74         return mod(a, b, "SafeMath: modulo by zero");
75     }
76 
77     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b != 0, errorMessage);
79         return a % b;
80     }
81 }
82 
83 library Address {
84 
85     function isContract(address account) internal view returns (bool) {
86         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
87         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
88         // for accounts without code, i.e. `keccak256('')`
89         bytes32 codehash;
90         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
91         // solhint-disable-next-line no-inline-assembly
92         assembly { codehash := extcodehash(account) }
93         return (codehash != accountHash && codehash != 0x0);
94     }
95 
96     function sendValue(address payable recipient, uint256 amount) internal {
97         require(address(this).balance >= amount, "Address: insufficient balance");
98 
99         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
100         (bool success, ) = recipient.call{ value: amount }("");
101         require(success, "Address: unable to send value, recipient may have reverted");
102     }
103 
104 
105     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
106       return functionCall(target, data, "Address: low-level call failed");
107     }
108 
109     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
110         return _functionCallWithValue(target, data, 0, errorMessage);
111     }
112 
113     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
115     }
116 
117     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
118         require(address(this).balance >= value, "Address: insufficient balance for call");
119         return _functionCallWithValue(target, data, value, errorMessage);
120     }
121 
122     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
123         require(isContract(target), "Address: call to non-contract");
124 
125         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
126         if (success) {
127             return returndata;
128         } else {
129             
130             if (returndata.length > 0) {
131                 assembly {
132                     let returndata_size := mload(returndata)
133                     revert(add(32, returndata), returndata_size)
134                 }
135             } else {
136                 revert(errorMessage);
137             }
138         }
139     }
140 }
141 
142 contract Ownable is Context {
143     address private _owner;
144     address private _previousOwner;
145     uint256 private _lockTime;
146 
147     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148 
149     constructor () {
150         address msgSender = _msgSender();
151         _owner = msgSender;
152         emit OwnershipTransferred(address(0), msgSender);
153     }
154 
155     function owner() public view returns (address) {
156         return _owner;
157     }   
158     
159     modifier onlyOwner() {
160         require(_owner == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163     
164     function renounceOwnership() public virtual onlyOwner {
165         emit OwnershipTransferred(_owner, address(0));
166         _owner = address(0);
167     }
168 
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         emit OwnershipTransferred(_owner, newOwner);
172         _owner = newOwner;
173     }
174 }
175 
176 // pragma solidity >=0.5.0;
177 
178 interface IUniswapV2Factory {
179     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
180 
181     function feeTo() external view returns (address);
182     function feeToSetter() external view returns (address);
183 
184     function getPair(address tokenA, address tokenB) external view returns (address pair);
185     function allPairs(uint) external view returns (address pair);
186     function allPairsLength() external view returns (uint);
187 
188     function createPair(address tokenA, address tokenB) external returns (address pair);
189 
190     function setFeeTo(address) external;
191     function setFeeToSetter(address) external;
192 }
193 
194 
195 // pragma solidity >=0.5.0;
196 
197 interface IUniswapV2Pair {
198     event Approval(address indexed owner, address indexed spender, uint value);
199     event Transfer(address indexed from, address indexed to, uint value);
200 
201     function name() external pure returns (string memory);
202     function symbol() external pure returns (string memory);
203     function decimals() external pure returns (uint8);
204     function totalSupply() external view returns (uint);
205     function balanceOf(address owner) external view returns (uint);
206     function allowance(address owner, address spender) external view returns (uint);
207 
208     function approve(address spender, uint value) external returns (bool);
209     function transfer(address to, uint value) external returns (bool);
210     function transferFrom(address from, address to, uint value) external returns (bool);
211 
212     function DOMAIN_SEPARATOR() external view returns (bytes32);
213     function PERMIT_TYPEHASH() external pure returns (bytes32);
214     function nonces(address owner) external view returns (uint);
215 
216     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
217     
218     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
219     event Swap(
220         address indexed sender,
221         uint amount0In,
222         uint amount1In,
223         uint amount0Out,
224         uint amount1Out,
225         address indexed to
226     );
227     event Sync(uint112 reserve0, uint112 reserve1);
228 
229     function MINIMUM_LIQUIDITY() external pure returns (uint);
230     function factory() external view returns (address);
231     function token0() external view returns (address);
232     function token1() external view returns (address);
233     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
234     function price0CumulativeLast() external view returns (uint);
235     function price1CumulativeLast() external view returns (uint);
236     function kLast() external view returns (uint);
237 
238     function burn(address to) external returns (uint amount0, uint amount1);
239     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
240     function skim(address to) external;
241     function sync() external;
242 
243     function initialize(address, address) external;
244 }
245 
246 // pragma solidity >=0.6.2;
247 
248 interface IUniswapV2Router01 {
249     function factory() external pure returns (address);
250     function WETH() external pure returns (address);
251 
252     function addLiquidity(
253         address tokenA,
254         address tokenB,
255         uint amountADesired,
256         uint amountBDesired,
257         uint amountAMin,
258         uint amountBMin,
259         address to,
260         uint deadline
261     ) external returns (uint amountA, uint amountB, uint liquidity);
262     function addLiquidityETH(
263         address token,
264         uint amountTokenDesired,
265         uint amountTokenMin,
266         uint amountETHMin,
267         address to,
268         uint deadline
269     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
270     function removeLiquidity(
271         address tokenA,
272         address tokenB,
273         uint liquidity,
274         uint amountAMin,
275         uint amountBMin,
276         address to,
277         uint deadline
278     ) external returns (uint amountA, uint amountB);
279     function removeLiquidityETH(
280         address token,
281         uint liquidity,
282         uint amountTokenMin,
283         uint amountETHMin,
284         address to,
285         uint deadline
286     ) external returns (uint amountToken, uint amountETH);
287     function removeLiquidityWithPermit(
288         address tokenA,
289         address tokenB,
290         uint liquidity,
291         uint amountAMin,
292         uint amountBMin,
293         address to,
294         uint deadline,
295         bool approveMax, uint8 v, bytes32 r, bytes32 s
296     ) external returns (uint amountA, uint amountB);
297     function removeLiquidityETHWithPermit(
298         address token,
299         uint liquidity,
300         uint amountTokenMin,
301         uint amountETHMin,
302         address to,
303         uint deadline,
304         bool approveMax, uint8 v, bytes32 r, bytes32 s
305     ) external returns (uint amountToken, uint amountETH);
306     function swapExactTokensForTokens(
307         uint amountIn,
308         uint amountOutMin,
309         address[] calldata path,
310         address to,
311         uint deadline
312     ) external returns (uint[] memory amounts);
313     function swapTokensForExactTokens(
314         uint amountOut,
315         uint amountInMax,
316         address[] calldata path,
317         address to,
318         uint deadline
319     ) external returns (uint[] memory amounts);
320     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
321         external
322         payable
323         returns (uint[] memory amounts);
324     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
325         external
326         returns (uint[] memory amounts);
327     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
328         external
329         returns (uint[] memory amounts);
330     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
331         external
332         payable
333         returns (uint[] memory amounts);
334 
335     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
336     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
337     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
338     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
339     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
340 }
341 
342 
343 
344 // pragma solidity >=0.6.2;
345 
346 interface IUniswapV2Router02 is IUniswapV2Router01 {
347     function removeLiquidityETHSupportingFeeOnTransferTokens(
348         address token,
349         uint liquidity,
350         uint amountTokenMin,
351         uint amountETHMin,
352         address to,
353         uint deadline
354     ) external returns (uint amountETH);
355     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
356         address token,
357         uint liquidity,
358         uint amountTokenMin,
359         uint amountETHMin,
360         address to,
361         uint deadline,
362         bool approveMax, uint8 v, bytes32 r, bytes32 s
363     ) external returns (uint amountETH);
364 
365     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
366         uint amountIn,
367         uint amountOutMin,
368         address[] calldata path,
369         address to,
370         uint deadline
371     ) external;
372     function swapExactETHForTokensSupportingFeeOnTransferTokens(
373         uint amountOutMin,
374         address[] calldata path,
375         address to,
376         uint deadline
377     ) external payable;
378     function swapExactTokensForETHSupportingFeeOnTransferTokens(
379         uint amountIn,
380         uint amountOutMin,
381         address[] calldata path,
382         address to,
383         uint deadline
384     ) external;
385 }
386 
387 contract FLOKIPUP is Context, IERC20, Ownable {
388     using SafeMath for uint256;
389     using Address for address;
390     
391     address payable public marketingAddress = payable(0xEaf4ab38B1026A1C0b7EF5b28DbFD7A6B275ECDD); 
392     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
393     mapping (address => uint256) private _rOwned;
394     mapping (address => uint256) private _tOwned;
395     mapping (address => mapping (address => uint256)) private _allowances;
396     
397    
398     mapping (address => bool) private _isExcludedFromFee;
399     mapping (address => bool) private _isExcluded;
400     address[] private _excluded;
401    
402     uint256 private constant MAX = ~uint256(0);
403     uint256 private _tTotal = 1e12 * 10**9;
404     uint256 private _rTotal = (MAX - (MAX % _tTotal));
405     uint256 private _tFeeTotal;
406 
407     string private _name = "Floki Pup";
408     string private _symbol = "FLOKIPUP";
409     uint8 private _decimals = 9;
410 
411     //1% redistribution, 8% marketing. Total tax = 9%
412     uint256 public _taxFee = 1;
413     uint256 private _previousTaxFee = _taxFee;
414     uint256 public _liquidityFee = 8;
415     uint256 private _previousLiquidityFee = _liquidityFee;
416     
417     
418     
419     IUniswapV2Router02 public uniswapV2Router;
420     address public uniswapV2Pair;
421     
422     bool inSwap;
423     
424     bool tradingOpen = false;
425     
426     event SwapETHForTokens(
427         uint256 amountIn,
428         address[] path
429     );
430     
431     event SwapTokensForETH(
432         uint256 amountIn,
433         address[] path
434     );
435     
436     modifier lockTheSwap {
437         inSwap = true;
438         _;
439         inSwap = false;
440     }
441     
442 
443     constructor () {
444         _rOwned[_msgSender()] = _rTotal;
445         emit Transfer(address(0), _msgSender(), _tTotal);
446     }
447     
448     function initContract() external onlyOwner() {
449         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
450         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
451         .createPair(address(this), _uniswapV2Router.WETH());
452 
453         uniswapV2Router = _uniswapV2Router;
454 
455         _isExcludedFromFee[owner()] = true;
456         _isExcludedFromFee[address(this)] = true;
457     }
458     
459     function openTrading() external onlyOwner() {
460         tradingOpen = true;
461     }
462 
463     function name() public view returns (string memory) {
464         return _name;
465     }
466 
467     function symbol() public view returns (string memory) {
468         return _symbol;
469     }
470 
471     function decimals() public view returns (uint8) {
472         return _decimals;
473     }
474 
475     function totalSupply() public view override returns (uint256) {
476         return _tTotal;
477     }
478 
479     function balanceOf(address account) public view override returns (uint256) {
480         if (_isExcluded[account]) return _tOwned[account];
481         return tokenFromReflection(_rOwned[account]);
482     }
483 
484     function transfer(address recipient, uint256 amount) public override returns (bool) {
485         _transfer(_msgSender(), recipient, amount);
486         return true;
487     }
488 
489     function allowance(address owner, address spender) public view override returns (uint256) {
490         return _allowances[owner][spender];
491     }
492 
493     function approve(address spender, uint256 amount) public override returns (bool) {
494         _approve(_msgSender(), spender, amount);
495         return true;
496     }
497 
498     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
499         _transfer(sender, recipient, amount);
500         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
501         return true;
502     }
503 
504     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
505         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
506         return true;
507     }
508 
509     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
510         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
511         return true;
512     }
513 
514     function isExcludedFromReward(address account) public view returns (bool) {
515         return _isExcluded[account];
516     }
517 
518     function totalFees() public view returns (uint256) {
519         return _tFeeTotal;
520     }
521     
522   
523     
524     function deliver(uint256 tAmount) public {
525         address sender = _msgSender();
526         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
527         (uint256 rAmount,,,,,) = _getValues(tAmount);
528         _rOwned[sender] = _rOwned[sender].sub(rAmount);
529         _rTotal = _rTotal.sub(rAmount);
530         _tFeeTotal = _tFeeTotal.add(tAmount);
531     }
532   
533 
534     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
535         require(tAmount <= _tTotal, "Amount must be less than supply");
536         if (!deductTransferFee) {
537             (uint256 rAmount,,,,,) = _getValues(tAmount);
538             return rAmount;
539         } else {
540             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
541             return rTransferAmount;
542         }
543     }
544 
545     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
546         require(rAmount <= _rTotal, "Amount must be less than total reflections");
547         uint256 currentRate =  _getRate();
548         return rAmount.div(currentRate);
549     }
550 
551     function excludeFromReward(address account) public onlyOwner() {
552 
553         require(!_isExcluded[account], "Account is already excluded");
554         if(_rOwned[account] > 0) {
555             _tOwned[account] = tokenFromReflection(_rOwned[account]);
556         }
557         _isExcluded[account] = true;
558         _excluded.push(account);
559     }
560 
561     function includeInReward(address account) external onlyOwner() {
562         require(_isExcluded[account], "Account is already excluded");
563         for (uint256 i = 0; i < _excluded.length; i++) {
564             if (_excluded[i] == account) {
565                 _excluded[i] = _excluded[_excluded.length - 1];
566                 _tOwned[account] = 0;
567                 _isExcluded[account] = false;
568                 _excluded.pop();
569                 break;
570             }
571         }
572     }
573 
574     function _approve(address owner, address spender, uint256 amount) private {
575         require(owner != address(0), "ERC20: approve from the zero address");
576         require(spender != address(0), "ERC20: approve to the zero address");
577 
578         _allowances[owner][spender] = amount;
579         emit Approval(owner, spender, amount);
580     }
581 
582     function _transfer(
583         address from,
584         address to,
585         uint256 amount
586     ) private {
587         require(from != address(0), "ERC20: transfer from the zero address");
588         require(to != address(0), "ERC20: transfer to the zero address");
589         require(amount > 0, "Transfer amount must be greater than zero");
590        if (from!= owner() && to!= owner()) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
591 
592        
593         uint256 contractTokenBalance = balanceOf(address(this));
594         
595         if (!inSwap && to == uniswapV2Pair) {
596             if(contractTokenBalance > 0) {
597                 if(contractTokenBalance > 0)
598                 swapTokens(contractTokenBalance);    
599             }
600         }
601         
602         bool takeFee = false;
603         
604         //take fee only on swaps
605         if ( (from==uniswapV2Pair || to==uniswapV2Pair) && !(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {
606             takeFee = true;
607         }
608         
609         _tokenTransfer(from,to,amount,takeFee);
610     }
611 
612     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
613         swapTokensForEth(contractTokenBalance);
614         
615         //Send to Marketing address
616         uint256 contractETHBalance = address(this).balance;
617         if(contractETHBalance > 0) {
618             sendETHToFee(address(this).balance);
619         }
620     }
621     
622     function sendETHToFee(uint256 amount) private {
623         marketingAddress.transfer(amount);
624     }
625     
626 
627    
628     function swapTokensForEth(uint256 tokenAmount) private {
629         // generate the uniswap pair path of token -> weth
630         address[] memory path = new address[](2);
631         path[0] = address(this);
632         path[1] = uniswapV2Router.WETH();
633 
634         _approve(address(this), address(uniswapV2Router), tokenAmount);
635 
636         // make the swap
637         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
638             tokenAmount,
639             0, // accept any amount of ETH
640             path,
641             address(this), // The contract
642             block.timestamp
643         );
644         
645         emit SwapTokensForETH(tokenAmount, path);
646     }
647     
648 
649     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
650         // approve token transfer to cover all possible scenarios
651         _approve(address(this), address(uniswapV2Router), tokenAmount);
652 
653         // add the liquidity
654         uniswapV2Router.addLiquidityETH{value: ethAmount}(
655             address(this),
656             tokenAmount,
657             0, // slippage is unavoidable
658             0, // slippage is unavoidable
659             owner(),
660             block.timestamp
661         );
662     }
663 
664     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
665         if(!takeFee)
666             removeAllFee();
667         
668         if (_isExcluded[sender] && !_isExcluded[recipient]) {
669             _transferFromExcluded(sender, recipient, amount);
670         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
671             _transferToExcluded(sender, recipient, amount);
672         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
673             _transferBothExcluded(sender, recipient, amount);
674         } else {
675             _transferStandard(sender, recipient, amount);
676         }
677         
678         if(!takeFee)
679             restoreAllFee();
680     }
681 
682     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
683         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
684         _rOwned[sender] = _rOwned[sender].sub(rAmount);
685         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
686         _takeLiquidity(tLiquidity);
687         _reflectFee(rFee, tFee);
688         emit Transfer(sender, recipient, tTransferAmount);
689     }
690 
691     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
692         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
693         _rOwned[sender] = _rOwned[sender].sub(rAmount);
694         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
695         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
696         _takeLiquidity(tLiquidity);
697         _reflectFee(rFee, tFee);
698         emit Transfer(sender, recipient, tTransferAmount);
699     }
700 
701     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
702         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
703         _tOwned[sender] = _tOwned[sender].sub(tAmount);
704         _rOwned[sender] = _rOwned[sender].sub(rAmount);
705         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
706         _takeLiquidity(tLiquidity);
707         _reflectFee(rFee, tFee);
708         emit Transfer(sender, recipient, tTransferAmount);
709     }
710 
711     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
712         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
713         _tOwned[sender] = _tOwned[sender].sub(tAmount);
714         _rOwned[sender] = _rOwned[sender].sub(rAmount);
715         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
716         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
717         _takeLiquidity(tLiquidity);
718         _reflectFee(rFee, tFee);
719         emit Transfer(sender, recipient, tTransferAmount);
720     }
721 
722     function _reflectFee(uint256 rFee, uint256 tFee) private {
723         _rTotal = _rTotal.sub(rFee);
724         _tFeeTotal = _tFeeTotal.add(tFee);
725     }
726 
727     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
728         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
729         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
730         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
731     }
732 
733     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
734         uint256 tFee = calculateTaxFee(tAmount);
735         uint256 tLiquidity = calculateLiquidityFee(tAmount);
736         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
737         return (tTransferAmount, tFee, tLiquidity);
738     }
739 
740     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
741         uint256 rAmount = tAmount.mul(currentRate);
742         uint256 rFee = tFee.mul(currentRate);
743         uint256 rLiquidity = tLiquidity.mul(currentRate);
744         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
745         return (rAmount, rTransferAmount, rFee);
746     }
747 
748     function _getRate() private view returns(uint256) {
749         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
750         return rSupply.div(tSupply);
751     }
752 
753     function _getCurrentSupply() private view returns(uint256, uint256) {
754         uint256 rSupply = _rTotal;
755         uint256 tSupply = _tTotal;      
756         for (uint256 i = 0; i < _excluded.length; i++) {
757             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
758             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
759             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
760         }
761         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
762         return (rSupply, tSupply);
763     }
764     
765     function _takeLiquidity(uint256 tLiquidity) private {
766         uint256 currentRate =  _getRate();
767         uint256 rLiquidity = tLiquidity.mul(currentRate);
768         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
769         if(_isExcluded[address(this)])
770             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
771     }
772     
773     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
774         return _amount.mul(_taxFee).div(
775             10**2
776         );
777     }
778     
779     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
780         return _amount.mul(_liquidityFee).div(
781             10**2
782         );
783     }
784     
785     function removeAllFee() private {
786         if(_taxFee == 0 && _liquidityFee == 0) return;
787         
788         _previousTaxFee = _taxFee;
789         _previousLiquidityFee = _liquidityFee;
790         
791         _taxFee = 0;
792         _liquidityFee = 0;
793     }
794     
795     function restoreAllFee() private {
796         _taxFee = _previousTaxFee;
797         _liquidityFee = _previousLiquidityFee;
798     }
799 
800     function isExcludedFromFee(address account) public view returns(bool) {
801         return _isExcludedFromFee[account];
802     }
803     
804     function excludeFromFee(address account) public onlyOwner {
805         _isExcludedFromFee[account] = true;
806     }
807     
808     function includeInFee(address account) public onlyOwner {
809         _isExcludedFromFee[account] = false;
810     }
811     
812     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
813         marketingAddress = payable(_marketingAddress);
814     }
815     
816     function transferToAddressETH(address payable recipient, uint256 amount) private {
817         recipient.transfer(amount);
818     }
819     
820     
821     
822 
823      //to recieve ETH from uniswapV2Router when swaping
824     receive() external payable {}
825 }