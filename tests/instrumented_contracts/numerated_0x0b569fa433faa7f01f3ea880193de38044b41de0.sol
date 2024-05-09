1 /**
2 
3 Gencoin Capital is a community-driven token that aims to bring generational wealth 
4 for it's holders. Powered by a unique investment treasury and a turbo-charged tokenomic 
5 system, Gencoin is strategically designed to incentivize holders with token buybacks, 
6 holder giveaways and charity events.
7 
8 Website: https://gencoincapital.finance
9 Telegram: https://t.me/gencoincapital
10 Twitter: https://twitter.com/gencoincapital
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 pragma solidity ^0.8.4;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return payable(msg.sender);
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44 
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b <= a, errorMessage);
54         uint256 c = a - b;
55 
56         return c;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         }
63 
64         uint256 c = a * b;
65         require(c / a == b, "SafeMath: multiplication overflow");
66 
67         return c;
68     }
69 
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return div(a, b, "SafeMath: division by zero");
73     }
74 
75     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b > 0, errorMessage);
77         uint256 c = a / b;
78         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79 
80         return c;
81     }
82 
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         return mod(a, b, "SafeMath: modulo by zero");
85     }
86 
87     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b != 0, errorMessage);
89         return a % b;
90     }
91 }
92 
93 library Address {
94 
95     function isContract(address account) internal view returns (bool) {
96         bytes32 codehash;
97         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
98         assembly { codehash := extcodehash(account) }
99         return (codehash != accountHash && codehash != 0x0);
100     }
101 
102     function sendValue(address payable recipient, uint256 amount) internal {
103         require(address(this).balance >= amount, "Address: insufficient balance");
104 
105         (bool success, ) = recipient.call{ value: amount }("");
106         require(success, "Address: unable to send value, recipient may have reverted");
107     }
108 
109 
110     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
111       return functionCall(target, data, "Address: low-level call failed");
112     }
113 
114     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
115         return _functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
120     }
121 
122     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
123         require(address(this).balance >= value, "Address: insufficient balance for call");
124         return _functionCallWithValue(target, data, value, errorMessage);
125     }
126 
127     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
128         require(isContract(target), "Address: call to non-contract");
129 
130         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
131         if (success) {
132             return returndata;
133         } else {
134             
135             if (returndata.length > 0) {
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 contract Ownable is Context {
148     address private _owner;
149     address private _previousOwner;
150     uint256 private _lockTime;
151 
152     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154     constructor () {
155         address msgSender = _msgSender();
156         _owner = msgSender;
157         emit OwnershipTransferred(address(0), msgSender);
158     }
159 
160     function owner() public view returns (address) {
161         return _owner;
162     }   
163     
164     modifier onlyOwner() {
165         require(_owner == _msgSender(), "Ownable: caller is not the owner");
166         _;
167     }
168     
169     function renounceOwnership() public virtual onlyOwner {
170         emit OwnershipTransferred(_owner, address(0));
171         _owner = address(0);
172     }
173 
174     function transferOwnership(address newOwner) public virtual onlyOwner {
175         require(newOwner != address(0), "Ownable: new owner is the zero address");
176         emit OwnershipTransferred(_owner, newOwner);
177         _owner = newOwner;
178     }
179 }
180 
181 interface IUniswapV2Factory {
182     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
183 
184     function feeTo() external view returns (address);
185     function feeToSetter() external view returns (address);
186 
187     function getPair(address tokenA, address tokenB) external view returns (address pair);
188     function allPairs(uint) external view returns (address pair);
189     function allPairsLength() external view returns (uint);
190 
191     function createPair(address tokenA, address tokenB) external returns (address pair);
192 
193     function setFeeTo(address) external;
194     function setFeeToSetter(address) external;
195 }
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
246 interface IUniswapV2Router01 {
247     function factory() external pure returns (address);
248     function WETH() external pure returns (address);
249 
250     function addLiquidity(
251         address tokenA,
252         address tokenB,
253         uint amountADesired,
254         uint amountBDesired,
255         uint amountAMin,
256         uint amountBMin,
257         address to,
258         uint deadline
259     ) external returns (uint amountA, uint amountB, uint liquidity);
260     function addLiquidityETH(
261         address token,
262         uint amountTokenDesired,
263         uint amountTokenMin,
264         uint amountETHMin,
265         address to,
266         uint deadline
267     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
268     function removeLiquidity(
269         address tokenA,
270         address tokenB,
271         uint liquidity,
272         uint amountAMin,
273         uint amountBMin,
274         address to,
275         uint deadline
276     ) external returns (uint amountA, uint amountB);
277     function removeLiquidityETH(
278         address token,
279         uint liquidity,
280         uint amountTokenMin,
281         uint amountETHMin,
282         address to,
283         uint deadline
284     ) external returns (uint amountToken, uint amountETH);
285     function removeLiquidityWithPermit(
286         address tokenA,
287         address tokenB,
288         uint liquidity,
289         uint amountAMin,
290         uint amountBMin,
291         address to,
292         uint deadline,
293         bool approveMax, uint8 v, bytes32 r, bytes32 s
294     ) external returns (uint amountA, uint amountB);
295     function removeLiquidityETHWithPermit(
296         address token,
297         uint liquidity,
298         uint amountTokenMin,
299         uint amountETHMin,
300         address to,
301         uint deadline,
302         bool approveMax, uint8 v, bytes32 r, bytes32 s
303     ) external returns (uint amountToken, uint amountETH);
304     function swapExactTokensForTokens(
305         uint amountIn,
306         uint amountOutMin,
307         address[] calldata path,
308         address to,
309         uint deadline
310     ) external returns (uint[] memory amounts);
311     function swapTokensForExactTokens(
312         uint amountOut,
313         uint amountInMax,
314         address[] calldata path,
315         address to,
316         uint deadline
317     ) external returns (uint[] memory amounts);
318     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
319         external
320         payable
321         returns (uint[] memory amounts);
322     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
323         external
324         returns (uint[] memory amounts);
325     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
326         external
327         returns (uint[] memory amounts);
328     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
329         external
330         payable
331         returns (uint[] memory amounts);
332 
333     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
334     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
335     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
336     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
337     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
338 }
339 
340 interface IUniswapV2Router02 is IUniswapV2Router01 {
341     function removeLiquidityETHSupportingFeeOnTransferTokens(
342         address token,
343         uint liquidity,
344         uint amountTokenMin,
345         uint amountETHMin,
346         address to,
347         uint deadline
348     ) external returns (uint amountETH);
349     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
350         address token,
351         uint liquidity,
352         uint amountTokenMin,
353         uint amountETHMin,
354         address to,
355         uint deadline,
356         bool approveMax, uint8 v, bytes32 r, bytes32 s
357     ) external returns (uint amountETH);
358 
359     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
360         uint amountIn,
361         uint amountOutMin,
362         address[] calldata path,
363         address to,
364         uint deadline
365     ) external;
366     function swapExactETHForTokensSupportingFeeOnTransferTokens(
367         uint amountOutMin,
368         address[] calldata path,
369         address to,
370         uint deadline
371     ) external payable;
372     function swapExactTokensForETHSupportingFeeOnTransferTokens(
373         uint amountIn,
374         uint amountOutMin,
375         address[] calldata path,
376         address to,
377         uint deadline
378     ) external;
379 }
380 
381 contract GencoinCapital is Context, IERC20, Ownable {
382     using SafeMath for uint256;
383     using Address for address;
384 
385     address payable private devWallet = payable (0xc446883641359C7b192EB7006f27dA97B8F454ac); // Main tax wallet
386     mapping (address => uint256) private _rOwned;
387     mapping (address => uint256) private _tOwned;
388     mapping (address => mapping (address => uint256)) private _allowances;
389     mapping (address => bool) private _isSniper;
390 
391     uint256 public deadBlocks = 5;    
392     uint256 public launchedAtBlock = 0;
393     uint256 public launchedAtTime = 0;
394     
395     mapping (address => bool) private _isExcludedFromFee;
396     mapping (address => bool) private _isMaxWalletExempt;
397     mapping (address => bool) private _isExcluded;
398     address[] private _excluded;
399 
400     struct StaticMaxTax {
401         uint256 maxLiquidity;
402         uint256 maxReflection;
403         uint256 maxTreasury;
404         uint256 maxMarketing;
405         uint256 maxTeamfee;
406     }
407    
408     address DEAD = 0x000000000000000000000000000000000000dEaD;
409 
410     uint8 private _decimals = 9;
411     
412     uint256 private constant MAX = ~uint256(0);
413     uint256 private _tTotal = 1e17 * 10**_decimals;
414     uint256 private _rTotal = (MAX - (MAX % _tTotal));
415     uint256 private _tFeeTotal;
416 
417     string private _name = "Gencoin Capital";
418     string private _symbol = "$GENCAP";
419     
420     uint256 public _maxWalletToken = _tTotal.div(2000).mul(10); //1% of available tokens (500T)
421 
422     bool public maxEthTradesEnabled = true;
423     uint256 public maxEthSell_launch = 1 * 10**18; //Max sell is 1 ETH for 24 hours.
424     uint256 public maxEthSell = 5 * 10**18; //Regular Max sell is 5 ETH.
425 
426     uint256 private swapThreshold = (_tTotal * 5) / 10000;
427     uint256 private swapAmount = (_tTotal * 25) / 10000;
428 
429     uint256 public _buyLiquidityFee = 2; //2%     
430     uint256 public _buyReflectionFee = 1; //1%
431     uint256 public _buyTreasuryFee = 4; //4%
432     uint256 public _buyMarketingFee = 4; //4%
433     uint256 public _buyTeamFee = 2; //2%
434 
435 
436     uint256 public _sellLiquidityFee = 2; //2%
437     uint256 public _sellReflectionFee = 1; //1%
438     uint256 public _sellTreasuryFee = 4; //4%
439     uint256 public _sellMarketingFee = 4; //4%
440     uint256 public _sellTeamFee = 2; //2%
441 
442     StaticMaxTax public staticTax = StaticMaxTax({
443         maxLiquidity: 2, //2%
444         maxReflection: 1, //1%
445         maxTreasury: 4, //4%
446         maxMarketing: 4, //4%
447         maxTeamfee: 2 //2%
448     });
449     
450     uint256 private liquidityFee = _buyLiquidityFee;
451     uint256 private treasuryFee = _buyTreasuryFee;
452     uint256 private marketingFee = _buyMarketingFee;
453     uint256 private teamFee = _buyTeamFee;
454     uint256 private reflectionFee=_buyReflectionFee;
455 
456     uint256 private totalFee = liquidityFee.add(treasuryFee).add(marketingFee).add(teamFee);
457     uint256 private currenttotalFee = totalFee;
458     
459     IUniswapV2Router02 public uniswapV2Router;
460     address public uniswapV2Pair;
461     
462     bool inSwap;
463 
464     address[] path;
465     
466     bool public tradingOpen = false;
467     bool public zeroBuyTaxmode = false;
468     
469     event SwapETHForTokens(
470         uint256 amountIn,
471         address[] path
472     );
473     
474     event SwapTokensForETH(
475         uint256 amountIn,
476         address[] path
477     );
478     
479     modifier lockTheSwap {
480         inSwap = true;
481         _;
482         inSwap = false;
483     }
484     
485     constructor () {
486         _rOwned[_msgSender()] = _rTotal;
487         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
488         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
489 
490         uniswapV2Router = _uniswapV2Router;
491 
492         _isExcludedFromFee[owner()] = true;
493         _isExcludedFromFee[address(this)] = true;
494         _isMaxWalletExempt[owner()] = true;
495         _isMaxWalletExempt[address(this)] = true;
496         _isMaxWalletExempt[uniswapV2Pair] = true;
497         _isMaxWalletExempt[DEAD] = true;
498 
499         path = new address[](2);
500         path[0] = address(this);
501         path[1] = uniswapV2Router.WETH();
502 
503         _approve(address(this), address(uniswapV2Router), MAX);
504         _approve(_msgSender(), address(uniswapV2Router), MAX);
505 
506         emit Transfer(address(0), _msgSender(), _tTotal);
507     }
508     
509     function openTrading() external onlyOwner() {
510         require(!tradingOpen);
511         tradingOpen = true;
512         excludeFromReward(address(this));
513         excludeFromReward(uniswapV2Pair);
514 
515         if(tradingOpen && launchedAtBlock == 0){
516             launchedAtBlock = block.number;
517             launchedAtTime = block.timestamp;
518         }
519     }
520  
521     function setZeroBuyTaxmode(bool _status) external onlyOwner() {
522        zeroBuyTaxmode = _status;
523     }
524     
525     function setNewRouter(address newRouter) external onlyOwner() {
526         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
527         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
528         if (get_pair == address(0)) {
529             uniswapV2Pair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
530         }
531         else {
532             uniswapV2Pair = get_pair;
533         }
534         uniswapV2Router = _newRouter;
535     }
536 
537     function name() public view returns (string memory) {
538         return _name;
539     }
540 
541     function symbol() public view returns (string memory) {
542         return _symbol;
543     }
544 
545     function decimals() public view returns (uint8) {
546         return _decimals;
547     }
548 
549     function totalSupply() public view override returns (uint256) {
550         return _tTotal;
551     }
552 
553     function balanceOf(address account) public view override returns (uint256) {
554         if (_isExcluded[account]) return _tOwned[account];
555         return tokenFromReflection(_rOwned[account]);
556     }
557 
558     function transfer(address recipient, uint256 amount) public override returns (bool) {
559         _transfer(_msgSender(), recipient, amount);
560         return true;
561     }
562 
563     function allowance(address owner, address spender) public view override returns (uint256) {
564         return _allowances[owner][spender];
565     }
566 
567     function approve(address spender, uint256 amount) public override returns (bool) {
568         _approve(_msgSender(), spender, amount);
569         return true;
570     }
571 
572     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
573         _transfer(sender, recipient, amount);
574         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
575         return true;
576     }
577 
578     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
580         return true;
581     }
582 
583     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
584         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
585         return true;
586     }
587 
588     function isExcludedFromReward(address account) public view returns (bool) {
589         return _isExcluded[account];
590     }
591 
592     function totalFees() public view returns (uint256) {
593         return _tFeeTotal;
594     }
595     
596     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
597         require(tAmount <= _tTotal, "Amount must be less than supply");
598         if (!deductTransferFee) {
599             (uint256 rAmount,,,,,) = _getValues(tAmount);
600             return rAmount;
601         } else {
602             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
603             return rTransferAmount;
604         }
605     }
606 
607     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
608         require(rAmount <= _rTotal, "Amount must be less than total reflections");
609         uint256 currentRate =  _getRate();
610         return rAmount.div(currentRate);
611     }
612 
613     function excludeFromReward(address account) public onlyOwner() {
614 
615         if(_rOwned[account] > 0) {
616             _tOwned[account] = tokenFromReflection(_rOwned[account]);
617         }
618         _isExcluded[account] = true;
619         _excluded.push(account);
620     }
621 
622     function includeInReward(address account) external onlyOwner() {
623         require(_isExcluded[account], "Account is already excluded");
624         for (uint256 i = 0; i < _excluded.length; i++) {
625             if (_excluded[i] == account) {
626                 _excluded[i] = _excluded[_excluded.length - 1];
627                 _tOwned[account] = 0;
628                 _isExcluded[account] = false;
629                 _excluded.pop();
630                 break;
631             }
632         }
633     }
634 
635     function _approve(address owner, address spender, uint256 amount) private {
636         require(owner != address(0), "ERC20: approve from the zero address");
637         require(spender != address(0), "ERC20: approve to the zero address");
638 
639         _allowances[owner][spender] = amount;
640         emit Approval(owner, spender, amount);
641     }
642 
643     function _transfer(
644         address from,
645         address to,
646         uint256 amount
647     ) private {
648         require(from != address(0), "ERC20: transfer from the zero address");
649         require(to != address(0), "ERC20: transfer to the zero address");
650         require(amount > 0, "Transfer amount must be greater than zero");
651         require(!_isSniper[to], "You are on the sniper list!");
652         require(!_isSniper[from], "You are on the sniper list!");
653         if (from != owner() && to != owner()) require(tradingOpen, "Trading not yet enabled."); //trading not open yet
654         
655         bool takeFee = false;
656 
657         if (!(_isExcludedFromFee[from] || _isExcludedFromFee[to])) {
658             takeFee = true;
659         }
660 
661         currenttotalFee=totalFee;
662         reflectionFee=_buyReflectionFee;
663 
664         //max wallet holding
665         if(!_isMaxWalletExempt[to] && from != owner() && from == uniswapV2Pair){
666             if(zeroBuyTaxmode){
667                 //adjust max amount according to 0% buy tax
668                 require(amount + balanceOf(to) <= _maxWalletToken , "Total holding is limited");
669             }else{
670                 //adjust max amount according to tax
671                 uint256 baseactualfee = _buyReflectionFee.add(_buyLiquidityFee).add(_buyTreasuryFee).add(_buyMarketingFee).add(_buyTeamFee);
672                 uint256 maxpercent = 100;
673                 baseactualfee = maxpercent.sub(baseactualfee);
674                 require(amount.mul(baseactualfee).div(100) + balanceOf(to) <= _maxWalletToken , "Total holding is limited");
675             }
676         }
677         
678         if(tradingOpen && to == uniswapV2Pair) { //sell
679             reflectionFee = _sellReflectionFee;
680 
681             if (maxEthTradesEnabled) {
682                 uint256 _ethBalance = uniswapV2Router.getAmountsOut(amount, path)[1];
683                 if(block.timestamp <= launchedAtTime + 24 hours) {
684                     require(_ethBalance <= maxEthSell_launch); //max 1 ETH sell for 24 hours.
685                 }else{
686                     require(_ethBalance <= maxEthSell); //max 5 ETH sell after 24 hours.
687                 }
688             }
689 
690             //anti-dump structure for the first 24 hours.
691             if(block.timestamp <= launchedAtTime + 2 hours) {
692                 currenttotalFee = 30; //30%
693             }else if (block.timestamp <= launchedAtTime + 12 hours) {
694                 currenttotalFee = 25; //25%
695             }else if (block.timestamp <= launchedAtTime + 24 hours) {
696                 currenttotalFee = 20; //20%
697             }else{
698                 currenttotalFee = _sellLiquidityFee.add(_sellTreasuryFee).add(_sellMarketingFee).add(_sellTeamFee); //12%+1%reflection
699             }
700         }
701 
702         //antisniper - first 5 blocks
703         if(launchedAtBlock > 0 && ((launchedAtBlock + deadBlocks) >= block.number)){
704                 _isSniper[to]=true;
705         }
706 
707          //on buys only
708         if(zeroBuyTaxmode){
709              if(tradingOpen && from == uniswapV2Pair) {
710                     currenttotalFee=0;
711              }
712         }
713 
714         //sell
715         if (!inSwap && tradingOpen && to == uniswapV2Pair) {    
716             uint256 contractTokenBalance = balanceOf(address(this));           
717             if (contractTokenBalance >= swapThreshold) {
718                 if(contractTokenBalance >= swapAmount) { 
719                     contractTokenBalance = swapAmount; 
720                 }
721                 swapTokens(contractTokenBalance);
722             }      
723         }
724         _tokenTransfer(from,to,amount,takeFee);
725     }
726 
727     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {       
728         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
729         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);       
730         swapTokensForEth(amountToSwap);
731         uint256 amountETH = address(this).balance;
732         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
733         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);    
734         uint256 totalTAXfee = treasuryFee.add(marketingFee).add(teamFee); 
735         uint256 amountETHdev = amountETH.mul(totalTAXfee).div(totalETHFee);
736         uint256 contractETHBalance = address(this).balance;
737         if(contractETHBalance > 0) {
738             sendETHToFee(amountETHdev,devWallet);
739         }
740         if (amountToLiquify > 0) {
741                 addLiquidity(amountToLiquify,amountETHLiquidity);
742         }
743     }
744     
745     function sendETHToFee(uint256 amount,address payable wallet) private {
746         wallet.transfer(amount);
747     }
748     
749     function swapTokensForEth(uint256 tokenAmount) private {
750         _approve(address(this), address(uniswapV2Router), tokenAmount);
751         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);      
752         emit SwapTokensForETH(tokenAmount, path);
753     }
754     
755     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
756         _approve(address(this), address(uniswapV2Router), tokenAmount);
757         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this), tokenAmount, 0, 0, owner(), block.timestamp);
758     }
759 
760     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
761 
762         uint256 _previousReflectionFee=reflectionFee;
763         uint256 _previousTotalFee=currenttotalFee;
764         if(!takeFee){
765             reflectionFee = 0;
766             currenttotalFee = 0;
767         }
768         
769         if (_isExcluded[sender] && !_isExcluded[recipient]) {
770             _transferFromExcluded(sender, recipient, amount);
771         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
772             _transferToExcluded(sender, recipient, amount);
773         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
774             _transferBothExcluded(sender, recipient, amount);
775         } else {
776             _transferStandard(sender, recipient, amount);
777         }
778         
779         if(!takeFee){
780             reflectionFee = _previousReflectionFee;
781             currenttotalFee = _previousTotalFee;
782         }
783     }
784 
785     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
786         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
787         _rOwned[sender] = _rOwned[sender].sub(rAmount);
788         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
789         _takeLiquidity(tLiquidity);
790         _reflectFee(rFee, tFee);
791         emit Transfer(sender, recipient, tTransferAmount);
792     }
793 
794     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
795         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
796         _rOwned[sender] = _rOwned[sender].sub(rAmount);
797         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
798         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
799         _takeLiquidity(tLiquidity);
800         _reflectFee(rFee, tFee);
801         emit Transfer(sender, recipient, tTransferAmount);
802     }
803 
804     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
805         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
806         _tOwned[sender] = _tOwned[sender].sub(tAmount);
807         _rOwned[sender] = _rOwned[sender].sub(rAmount);
808         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
809         _takeLiquidity(tLiquidity);
810         _reflectFee(rFee, tFee);
811         emit Transfer(sender, recipient, tTransferAmount);
812     }
813 
814     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
815         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
816         _tOwned[sender] = _tOwned[sender].sub(tAmount);
817         _rOwned[sender] = _rOwned[sender].sub(rAmount);
818         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
819         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
820         _takeLiquidity(tLiquidity);
821         _reflectFee(rFee, tFee);
822         emit Transfer(sender, recipient, tTransferAmount);
823     }
824 
825     function _reflectFee(uint256 rFee, uint256 tFee) private {
826         _rTotal = _rTotal.sub(rFee);
827         _tFeeTotal = _tFeeTotal.add(tFee);
828     }
829 
830     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
831         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
832         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
833         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
834     }
835 
836     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
837         uint256 tFee = calculateTaxFee(tAmount);
838         uint256 tLiquidity = calculateLiquidityFee(tAmount);
839         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
840         return (tTransferAmount, tFee, tLiquidity);
841     }
842 
843     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
844         uint256 rAmount = tAmount.mul(currentRate);
845         uint256 rFee = tFee.mul(currentRate);
846         uint256 rLiquidity = tLiquidity.mul(currentRate);
847         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
848         return (rAmount, rTransferAmount, rFee);
849     }
850 
851     function _getRate() private view returns(uint256) {
852         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
853         return rSupply.div(tSupply);
854     }
855 
856     function _getCurrentSupply() private view returns(uint256, uint256) {
857         uint256 rSupply = _rTotal;
858         uint256 tSupply = _tTotal;      
859         for (uint256 i = 0; i < _excluded.length; i++) {
860             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
861             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
862             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
863         }
864         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
865         return (rSupply, tSupply);
866     }
867     
868     function _takeLiquidity(uint256 tLiquidity) private {
869         uint256 currentRate =  _getRate();
870         uint256 rLiquidity = tLiquidity.mul(currentRate);
871         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
872         if(_isExcluded[address(this)])
873             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
874     }
875     
876     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
877         return _amount.mul(reflectionFee).div(10**2);
878     }
879     
880     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
881         return _amount.mul(currenttotalFee).div(10**2);
882     }
883     
884     function excludeMultiple(address account) public onlyOwner {
885         _isExcludedFromFee[account] = true;
886     }
887 
888     function excludeFromFee(address[] calldata addresses) public onlyOwner {
889         for (uint256 i; i < addresses.length; ++i) {
890             _isExcludedFromFee[addresses[i]] = true;
891         }
892     }
893      
894     function includeInFee(address account) public onlyOwner {
895         _isExcludedFromFee[account] = false;
896     }
897     
898     function setWallets(address _devWallet) external onlyOwner() {
899         devWallet = payable(_devWallet);
900     }
901 
902     function transferToAddressETH(address payable recipient, uint256 amount) private {
903         recipient.transfer(amount);
904     }
905     
906     function isSniper(address account) public view returns (bool) {
907         return _isSniper[account];
908     }
909     
910     function manage_Snipers(address[] calldata addresses, bool status) public onlyOwner {
911         for (uint256 i; i < addresses.length; ++i) {
912                 _isSniper[addresses[i]] = status;
913         }
914     }
915          
916     function withDrawLeftoverETH(address payable recipient) public onlyOwner {
917         recipient.transfer(address(this).balance);
918     }
919 
920     function withdrawStuckTokens(IERC20 token, address to) public onlyOwner {
921         uint256 balance = token.balanceOf(address(this));
922         token.transfer(to, balance);
923     }
924 
925     function setMaxWalletBase2000(uint256 maxWallet) external onlyOwner() {
926         _maxWalletToken = _tTotal.div(2000).mul(maxWallet);
927     }
928 
929     function setMaxWalletExempt(address _addr) external onlyOwner {
930         _isMaxWalletExempt[_addr] = true;
931     }
932 
933     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
934         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
935         swapAmount = (_tTotal * amountPercent) / amountDivisor;
936     }
937 
938     function setTaxesBuy(uint256 _reflectionFee, uint256 _liquidityFee, uint256 _treasuryFee, uint256 _marketingFee, uint256 _teamFee) external onlyOwner {
939         require(_reflectionFee <= staticTax.maxReflection && 
940         _liquidityFee <= staticTax.maxLiquidity && 
941         _marketingFee <= staticTax.maxMarketing &&
942         _teamFee <= staticTax.maxTeamfee);
943         
944         uint256 total_buy_fee = _reflectionFee.add(_liquidityFee).add(_treasuryFee).add(_marketingFee).add(_teamFee);
945         require(total_buy_fee <= 13); //Max buy fee 13%
946 
947         _buyLiquidityFee = _liquidityFee;
948         _buyReflectionFee = _reflectionFee;
949         _buyTreasuryFee = _treasuryFee;
950         _buyMarketingFee = _marketingFee;
951         _buyTeamFee = _teamFee;       
952 
953         reflectionFee = _reflectionFee;
954         liquidityFee = _liquidityFee;
955         treasuryFee = _treasuryFee;
956         marketingFee = _marketingFee;
957         teamFee = _teamFee;
958         totalFee = liquidityFee.add(treasuryFee).add(marketingFee).add(teamFee);
959     }
960 
961     function setTaxesSell(uint256 _reflectionFee,uint256 _liquidityFee, uint256 _treasuryFee, uint256 _marketingFee, uint256 _teamFee) external onlyOwner {
962         require(_reflectionFee <= staticTax.maxReflection && 
963         _liquidityFee <= staticTax.maxLiquidity && 
964         _marketingFee <= staticTax.maxMarketing &&
965         _teamFee <= staticTax.maxTeamfee);
966         
967         uint256 total_sell_fee = _reflectionFee.add(_liquidityFee).add(_treasuryFee).add(_marketingFee).add(_teamFee);
968         require(total_sell_fee <= 13); //Max sell fee 13%
969 
970         _sellLiquidityFee = _liquidityFee;
971         _sellReflectionFee= _reflectionFee;
972         _sellTreasuryFee = _treasuryFee;
973         _sellMarketingFee = _marketingFee;
974         _sellTeamFee = _teamFee;      
975     }
976 
977     function setEthLimits(uint256 sellVal) external onlyOwner {
978         require(sellVal >= 5 * 10**18);
979         maxEthSell = sellVal * 10**18;      
980     }
981 
982     function setEthLimitsEnabled(bool maxEthTrades) external onlyOwner {
983         maxEthTradesEnabled = maxEthTrades;
984     }    
985 
986     receive() external payable {}
987 }