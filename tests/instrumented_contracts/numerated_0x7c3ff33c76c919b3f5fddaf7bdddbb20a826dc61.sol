1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-29
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-10-13
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 pragma solidity ^0.8.0;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address payable) {
14         return payable(msg.sender);
15     }
16 
17     function _msgData() internal view virtual returns (bytes memory) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 
24 interface IERC20 {
25 
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34     
35 
36 }
37 
38 library SafeMath {
39 
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43 
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54 
55         return c;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62 
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65 
66         return c;
67     }
68 
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 
79         return c;
80     }
81 
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         return mod(a, b, "SafeMath: modulo by zero");
84     }
85 
86     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b != 0, errorMessage);
88         return a % b;
89     }
90 }
91 
92 library Address {
93 
94     function isContract(address account) internal view returns (bool) {
95         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
96         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
97         // for accounts without code, i.e. `keccak256('')`
98         bytes32 codehash;
99         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
100         // solhint-disable-next-line no-inline-assembly
101         assembly { codehash := extcodehash(account) }
102         return (codehash != accountHash && codehash != 0x0);
103     }
104 
105     function sendValue(address payable recipient, uint256 amount) internal {
106         require(address(this).balance >= amount, "Address: insufficient balance");
107 
108         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
109         (bool success, ) = recipient.call{ value: amount }("");
110         require(success, "Address: unable to send value, recipient may have reverted");
111     }
112 
113 
114     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
115       return functionCall(target, data, "Address: low-level call failed");
116     }
117 
118     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
119         return _functionCallWithValue(target, data, 0, errorMessage);
120     }
121 
122     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
127         require(address(this).balance >= value, "Address: insufficient balance for call");
128         return _functionCallWithValue(target, data, value, errorMessage);
129     }
130 
131     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
132         require(isContract(target), "Address: call to non-contract");
133 
134         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
135         if (success) {
136             return returndata;
137         } else {
138             
139             if (returndata.length > 0) {
140                 assembly {
141                     let returndata_size := mload(returndata)
142                     revert(add(32, returndata), returndata_size)
143                 }
144             } else {
145                 revert(errorMessage);
146             }
147         }
148     }
149 }
150 
151 contract Ownable is Context {
152     address private _owner;
153     address private _previousOwner;
154     uint256 private _lockTime;
155 
156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
157 
158     constructor () {
159         address msgSender = _msgSender();
160         _owner = msgSender;
161         emit OwnershipTransferred(address(0), msgSender);
162     }
163 
164     function owner() public view returns (address) {
165         return _owner;
166     }   
167     
168     modifier onlyOwner() {
169         require(_owner == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172     
173     function renounceOwnership() public virtual onlyOwner {
174         emit OwnershipTransferred(_owner, address(0));
175         _owner = address(0);
176     }
177 
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         emit OwnershipTransferred(_owner, newOwner);
181         _owner = newOwner;
182     }
183 }
184 
185 // pragma solidity >=0.5.0;
186 
187 interface IUniswapV2Factory {
188     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
189 
190     function feeTo() external view returns (address);
191     function feeToSetter() external view returns (address);
192 
193     function getPair(address tokenA, address tokenB) external view returns (address pair);
194     function allPairs(uint) external view returns (address pair);
195     function allPairsLength() external view returns (uint);
196 
197     function createPair(address tokenA, address tokenB) external returns (address pair);
198 
199     function setFeeTo(address) external;
200     function setFeeToSetter(address) external;
201 }
202 
203 
204 // pragma solidity >=0.5.0;
205 
206 interface IUniswapV2Pair {
207     event Approval(address indexed owner, address indexed spender, uint value);
208     event Transfer(address indexed from, address indexed to, uint value);
209 
210     function name() external pure returns (string memory);
211     function symbol() external pure returns (string memory);
212     function decimals() external pure returns (uint8);
213     function totalSupply() external view returns (uint);
214     function balanceOf(address owner) external view returns (uint);
215     function allowance(address owner, address spender) external view returns (uint);
216 
217     function approve(address spender, uint value) external returns (bool);
218     function transfer(address to, uint value) external returns (bool);
219     function transferFrom(address from, address to, uint value) external returns (bool);
220 
221     function DOMAIN_SEPARATOR() external view returns (bytes32);
222     function PERMIT_TYPEHASH() external pure returns (bytes32);
223     function nonces(address owner) external view returns (uint);
224 
225     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
226     
227     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
228     event Swap(
229         address indexed sender,
230         uint amount0In,
231         uint amount1In,
232         uint amount0Out,
233         uint amount1Out,
234         address indexed to
235     );
236     event Sync(uint112 reserve0, uint112 reserve1);
237 
238     function MINIMUM_LIQUIDITY() external pure returns (uint);
239     function factory() external view returns (address);
240     function token0() external view returns (address);
241     function token1() external view returns (address);
242     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
243     function price0CumulativeLast() external view returns (uint);
244     function price1CumulativeLast() external view returns (uint);
245     function kLast() external view returns (uint);
246 
247     function burn(address to) external returns (uint amount0, uint amount1);
248     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
249     function skim(address to) external;
250     function sync() external;
251 
252     function initialize(address, address) external;
253 }
254 
255 // pragma solidity >=0.6.2;
256 
257 interface IUniswapV2Router01 {
258     function factory() external pure returns (address);
259     function WETH() external pure returns (address);
260 
261     function addLiquidity(
262         address tokenA,
263         address tokenB,
264         uint amountADesired,
265         uint amountBDesired,
266         uint amountAMin,
267         uint amountBMin,
268         address to,
269         uint deadline
270     ) external returns (uint amountA, uint amountB, uint liquidity);
271     function addLiquidityETH(
272         address token,
273         uint amountTokenDesired,
274         uint amountTokenMin,
275         uint amountETHMin,
276         address to,
277         uint deadline
278     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
279     function removeLiquidity(
280         address tokenA,
281         address tokenB,
282         uint liquidity,
283         uint amountAMin,
284         uint amountBMin,
285         address to,
286         uint deadline
287     ) external returns (uint amountA, uint amountB);
288     function removeLiquidityETH(
289         address token,
290         uint liquidity,
291         uint amountTokenMin,
292         uint amountETHMin,
293         address to,
294         uint deadline
295     ) external returns (uint amountToken, uint amountETH);
296     function removeLiquidityWithPermit(
297         address tokenA,
298         address tokenB,
299         uint liquidity,
300         uint amountAMin,
301         uint amountBMin,
302         address to,
303         uint deadline,
304         bool approveMax, uint8 v, bytes32 r, bytes32 s
305     ) external returns (uint amountA, uint amountB);
306     function removeLiquidityETHWithPermit(
307         address token,
308         uint liquidity,
309         uint amountTokenMin,
310         uint amountETHMin,
311         address to,
312         uint deadline,
313         bool approveMax, uint8 v, bytes32 r, bytes32 s
314     ) external returns (uint amountToken, uint amountETH);
315     function swapExactTokensForTokens(
316         uint amountIn,
317         uint amountOutMin,
318         address[] calldata path,
319         address to,
320         uint deadline
321     ) external returns (uint[] memory amounts);
322     function swapTokensForExactTokens(
323         uint amountOut,
324         uint amountInMax,
325         address[] calldata path,
326         address to,
327         uint deadline
328     ) external returns (uint[] memory amounts);
329     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
330         external
331         payable
332         returns (uint[] memory amounts);
333     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
334         external
335         returns (uint[] memory amounts);
336     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
337         external
338         returns (uint[] memory amounts);
339     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
340         external
341         payable
342         returns (uint[] memory amounts);
343 
344     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
345     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
346     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
347     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
348     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
349 }
350 
351 
352 
353 // pragma solidity >=0.6.2;
354 
355 interface IUniswapV2Router02 is IUniswapV2Router01 {
356     function removeLiquidityETHSupportingFeeOnTransferTokens(
357         address token,
358         uint liquidity,
359         uint amountTokenMin,
360         uint amountETHMin,
361         address to,
362         uint deadline
363     ) external returns (uint amountETH);
364     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
365         address token,
366         uint liquidity,
367         uint amountTokenMin,
368         uint amountETHMin,
369         address to,
370         uint deadline,
371         bool approveMax, uint8 v, bytes32 r, bytes32 s
372     ) external returns (uint amountETH);
373 
374     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
375         uint amountIn,
376         uint amountOutMin,
377         address[] calldata path,
378         address to,
379         uint deadline
380     ) external;
381     function swapExactETHForTokensSupportingFeeOnTransferTokens(
382         uint amountOutMin,
383         address[] calldata path,
384         address to,
385         uint deadline
386     ) external payable;
387     function swapExactTokensForETHSupportingFeeOnTransferTokens(
388         uint amountIn,
389         uint amountOutMin,
390         address[] calldata path,
391         address to,
392         uint deadline
393     ) external;
394 }
395 
396 
397 contract FROGGIES is Context, IERC20, Ownable {
398     using SafeMath for uint256;
399     using Address for address;
400     
401     address payable public marketingWallet = payable(0x981b5f02AEdfb1c3529887158a4bCFe94c16Ab05); // Marketing Wallet
402     mapping (address => uint256) private _rOwned;
403     mapping (address => uint256) private _tOwned;
404     mapping (address => mapping (address => uint256)) private _allowances;
405     mapping (address => bool) private _isSniper;
406     
407 
408     mapping (address => bool) private _isExcludedFromFee;
409     mapping (address => bool) private _isExcluded;
410     address[] private _excluded;
411    
412     uint256 private constant MAX = ~uint256(0);
413     uint256 private _tTotal = 100000000000000000* 10**9;
414     uint256 private _rTotal = (MAX - (MAX % _tTotal));
415     uint256 private _tFeeTotal;
416 
417     string private _name = "Froggies";
418     string private _symbol = "FROGGIES";
419     uint8 private _decimals = 9;
420 
421 
422     uint256 public reflectionFee = 5; // 5% reflectionFee on buys 
423     uint256 public sellFee = 5; // 5% fee on sells, 5% marketing/team/developement
424 
425     uint256 private _taxFee;
426     uint256 private _liquidityFee;
427     
428     uint256 private _feeRate = 2; //contract can sell max 2% price impact in a single transaction
429     uint256 public launchTime;
430 
431     IUniswapV2Router02 public uniswapV2Router;
432     address public uniswapV2Pair;
433     
434     bool inSwap;
435     
436     bool tradingOpen = false;
437     
438     event SwapETHForTokens(
439         uint256 amountIn,
440         address[] path
441     );
442     
443     event SwapTokensForETH(
444         uint256 amountIn,
445         address[] path
446     );
447     
448     modifier lockTheSwap {
449         inSwap = true;
450         _;
451         inSwap = false;
452     }
453     
454 
455     constructor () {
456         _rOwned[_msgSender()] = _rTotal;
457         emit Transfer(address(0), _msgSender(), _tTotal);
458     }
459     
460     function initContract() external onlyOwner() {
461         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
462         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
463         .createPair(address(this), _uniswapV2Router.WETH());
464 
465         uniswapV2Router = _uniswapV2Router;
466 
467         _isExcludedFromFee[owner()] = true;
468         _isExcludedFromFee[address(this)] = true;
469         
470     }
471     
472     function openTrading() external onlyOwner() {
473         tradingOpen = true;
474         launchTime = block.timestamp;
475     }
476 
477     function name() public view returns (string memory) {
478         return _name;
479     }
480 
481     function symbol() public view returns (string memory) {
482         return _symbol;
483     }
484 
485     function decimals() public view returns (uint8) {
486         return _decimals;
487     }
488 
489     function totalSupply() public view override returns (uint256) {
490         return _tTotal;
491     }
492 
493     function balanceOf(address account) public view override returns (uint256) {
494         if (_isExcluded[account]) return _tOwned[account];
495         return tokenFromReflection(_rOwned[account]);
496     }
497 
498     function transfer(address recipient, uint256 amount) public override returns (bool) {
499         _transfer(_msgSender(), recipient, amount);
500         return true;
501     }
502 
503     function allowance(address owner, address spender) public view override returns (uint256) {
504         return _allowances[owner][spender];
505     }
506 
507     function approve(address spender, uint256 amount) public override returns (bool) {
508         _approve(_msgSender(), spender, amount);
509         return true;
510     }
511 
512     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
513         _transfer(sender, recipient, amount);
514         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
515         return true;
516     }
517 
518     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
519         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
520         return true;
521     }
522 
523     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
524         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
525         return true;
526     }
527 
528     function isExcludedFromReward(address account) public view returns (bool) {
529         return _isExcluded[account];
530     }
531 
532     function totalFees() public view returns (uint256) {
533         return _tFeeTotal;
534     }
535     
536     function deliver(uint256 tAmount) public {
537         address sender = _msgSender();
538         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
539         (uint256 rAmount,,,,,) = _getValues(tAmount);
540         _rOwned[sender] = _rOwned[sender].sub(rAmount);
541         _rTotal = _rTotal.sub(rAmount);
542         _tFeeTotal = _tFeeTotal.add(tAmount);
543     }
544   
545 
546     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
547         require(tAmount <= _tTotal, "Amount must be less than supply");
548         if (!deductTransferFee) {
549             (uint256 rAmount,,,,,) = _getValues(tAmount);
550             return rAmount;
551         } else {
552             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
553             return rTransferAmount;
554         }
555     }
556 
557     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
558         require(rAmount <= _rTotal, "Amount must be less than total reflections");
559         uint256 currentRate =  _getRate();
560         return rAmount.div(currentRate);
561     }
562 
563     function excludeFromReward(address account) public onlyOwner() {
564 
565         require(!_isExcluded[account], "Account is already excluded");
566         if(_rOwned[account] > 0) {
567             _tOwned[account] = tokenFromReflection(_rOwned[account]);
568         }
569         _isExcluded[account] = true;
570         _excluded.push(account);
571     }
572 
573     function includeInReward(address account) external onlyOwner() {
574         require(_isExcluded[account], "Account is already excluded");
575         for (uint256 i = 0; i < _excluded.length; i++) {
576             if (_excluded[i] == account) {
577                 _excluded[i] = _excluded[_excluded.length - 1];
578                 _tOwned[account] = 0;
579                 _isExcluded[account] = false;
580                 _excluded.pop();
581                 break;
582             }
583         }
584     }
585 
586     function _approve(address owner, address spender, uint256 amount) private {
587         require(owner != address(0), "ERC20: approve from the zero address");
588         require(spender != address(0), "ERC20: approve to the zero address");
589 
590         _allowances[owner][spender] = amount;
591         emit Approval(owner, spender, amount);
592     }
593 
594     function _transfer(
595         address from,
596         address to,
597         uint256 amount
598     ) private {
599         require(from != address(0), "ERC20: transfer from the zero address");
600         require(to != address(0), "ERC20: transfer to the zero address");
601         require(amount > 0, "Transfer amount must be greater than zero");
602         require(!_isSniper[to], "You have no power here!");
603         require(!_isSniper[from], "You have no power here!");
604         if (from!= owner() && to!= owner()) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
605         
606          bool takeFee = false;
607         //take fee only on swaps
608         if ( (from==uniswapV2Pair || to==uniswapV2Pair) && !(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {
609             takeFee = true;
610         }
611        
612         // buy
613         if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
614             
615             // 5% reflection Fee on buys, no marketing
616             if (takeFee) {
617                 _taxFee = reflectionFee;
618                 _liquidityFee = 0;
619             }
620             
621             //antibot
622             if (block.timestamp == launchTime) {
623                 _isSniper[to] = true;
624             }
625         }
626 
627         //sell
628         if (!inSwap && tradingOpen && to == uniswapV2Pair) {
629             
630             // no reflection on sells, 5% marketing fee
631             if (takeFee) {
632                 _taxFee = 0;
633                 _liquidityFee = sellFee;
634             }
635             
636             uint256 contractTokenBalance = balanceOf(address(this));
637             if(contractTokenBalance > 0) {
638                 if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
639                     contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
640                 }
641                 swapTokens(contractTokenBalance);    
642             }
643           
644         }
645         _tokenTransfer(from,to,amount,takeFee);
646     }
647 
648     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
649         swapTokensForEth(contractTokenBalance);
650         
651         //Send to marketing wallet and buyback wallet
652         uint256 contractETHBalance = address(this).balance;
653         if(contractETHBalance > 0) {
654             sendETHToFee(address(this).balance);
655         }
656     }
657     
658     function sendETHToFee(uint256 amount) private {
659         marketingWallet.transfer(amount.mul(sellFee).div(10));
660     }
661     
662 
663    
664     function swapTokensForEth(uint256 tokenAmount) private {
665         // generate the uniswap pair path of token -> weth
666         address[] memory path = new address[](2);
667         path[0] = address(this);
668         path[1] = uniswapV2Router.WETH();
669 
670         _approve(address(this), address(uniswapV2Router), tokenAmount);
671 
672         // make the swap
673         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
674             tokenAmount,
675             0, // accept any amount of ETH
676             path,
677             address(this), // The contract
678             block.timestamp
679         );
680         
681         emit SwapTokensForETH(tokenAmount, path);
682     }
683     
684 
685     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
686         // approve token transfer to cover all possible scenarios
687         _approve(address(this), address(uniswapV2Router), tokenAmount);
688 
689         // add the liquidity
690         uniswapV2Router.addLiquidityETH{value: ethAmount}(
691             address(this),
692             tokenAmount,
693             0, // slippage is unavoidable
694             0, // slippage is unavoidable
695             owner(),
696             block.timestamp
697         );
698     }
699 
700     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
701         if(!takeFee)
702             removeAllFee();
703         
704         if (_isExcluded[sender] && !_isExcluded[recipient]) {
705             _transferFromExcluded(sender, recipient, amount);
706         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
707             _transferToExcluded(sender, recipient, amount);
708         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
709             _transferBothExcluded(sender, recipient, amount);
710         } else {
711             _transferStandard(sender, recipient, amount);
712         }
713     }
714 
715     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
716         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
717         _rOwned[sender] = _rOwned[sender].sub(rAmount);
718         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
719         _takeLiquidity(tLiquidity);
720         _reflectFee(rFee, tFee);
721         emit Transfer(sender, recipient, tTransferAmount);
722     }
723 
724     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
725         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
726         _rOwned[sender] = _rOwned[sender].sub(rAmount);
727         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
728         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
729         _takeLiquidity(tLiquidity);
730         _reflectFee(rFee, tFee);
731         emit Transfer(sender, recipient, tTransferAmount);
732     }
733 
734     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
735         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
736         _tOwned[sender] = _tOwned[sender].sub(tAmount);
737         _rOwned[sender] = _rOwned[sender].sub(rAmount);
738         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
739         _takeLiquidity(tLiquidity);
740         _reflectFee(rFee, tFee);
741         emit Transfer(sender, recipient, tTransferAmount);
742     }
743 
744     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
745         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
746         _tOwned[sender] = _tOwned[sender].sub(tAmount);
747         _rOwned[sender] = _rOwned[sender].sub(rAmount);
748         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
749         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
750         _takeLiquidity(tLiquidity);
751         _reflectFee(rFee, tFee);
752         emit Transfer(sender, recipient, tTransferAmount);
753     }
754 
755     function _reflectFee(uint256 rFee, uint256 tFee) private {
756         _rTotal = _rTotal.sub(rFee);
757         _tFeeTotal = _tFeeTotal.add(tFee);
758     }
759 
760     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
761         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
762         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
763         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
764     }
765 
766     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
767         uint256 tFee = calculateTaxFee(tAmount);
768         uint256 tLiquidity = calculateLiquidityFee(tAmount);
769         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
770         return (tTransferAmount, tFee, tLiquidity);
771     }
772 
773     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
774         uint256 rAmount = tAmount.mul(currentRate);
775         uint256 rFee = tFee.mul(currentRate);
776         uint256 rLiquidity = tLiquidity.mul(currentRate);
777         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
778         return (rAmount, rTransferAmount, rFee);
779     }
780 
781     function _getRate() private view returns(uint256) {
782         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
783         return rSupply.div(tSupply);
784     }
785 
786     function _getCurrentSupply() private view returns(uint256, uint256) {
787         uint256 rSupply = _rTotal;
788         uint256 tSupply = _tTotal;      
789         for (uint256 i = 0; i < _excluded.length; i++) {
790             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
791             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
792             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
793         }
794         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
795         return (rSupply, tSupply);
796     }
797     
798     function _takeLiquidity(uint256 tLiquidity) private {
799         uint256 currentRate =  _getRate();
800         uint256 rLiquidity = tLiquidity.mul(currentRate);
801         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
802         if(_isExcluded[address(this)])
803             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
804     }
805     
806     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
807         return _amount.mul(_taxFee).div(
808             10**2
809         );
810     }
811     
812     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
813         return _amount.mul(_liquidityFee).div(
814             10**2
815         );
816     }
817     
818     function removeAllFee() private {
819         if(_taxFee == 0 && _liquidityFee == 0) return;
820         
821         _taxFee = 0;
822         _liquidityFee = 0;
823     }
824     
825     function isExcludedFromFee(address account) public view returns(bool) {
826         return _isExcludedFromFee[account];
827     }
828     
829     function excludeFromFee(address account) public onlyOwner {
830         _isExcludedFromFee[account] = true;
831     }
832     
833     function includeInFee(address account) public onlyOwner {
834         _isExcludedFromFee[account] = false;
835     }
836     
837     function setMarketingWallet(address _marketingWallet) external onlyOwner() {
838         marketingWallet = payable(_marketingWallet);
839     }
840    
841     function transferToAddressETH(address payable recipient, uint256 amount) private {
842         recipient.transfer(amount);
843     }
844     
845     function isSniper(address account) public view returns (bool) {
846         return _isSniper[account];
847     }
848     
849     function setFeeRate(uint256 rate) external  onlyOwner() {
850         _feeRate = rate;
851     }
852     
853     function setReflectionFee(uint256 fee) external  onlyOwner() {
854         reflectionFee = fee;
855     }
856     
857     function setSellFee(uint256 fee) external  onlyOwner() {
858         sellFee = fee;
859     }
860    
861      //to recieve ETH from uniswapV2Router when swaping
862     receive() external payable {}
863 }