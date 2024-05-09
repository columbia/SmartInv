1 /* Scorcher is the first contract to utilize the utility of Pyro: PyroBurn.
2 Scorcher features:
3 🔥 3% to a true burn where the tokens are deducted from the supply creating a hyper-defaltionary token.
4 🔥 3% for auto LP to ensure an evergrowing Liquidity Pool.
5 🔥 3% to PyroBurn contract where it buys and burns Pyro.
6 🔥 A 9% Jeet Killer tax at launch to help deter snipers.
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.4;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 }
66 
67 library Address {
68         
69     function isContract(address account) internal view returns (bool) {
70         
71         bytes32 codehash;
72         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
73         // solhint-disable-next-line no-inline-assembly
74         assembly { codehash := extcodehash(account) }
75         return (codehash != accountHash && codehash != 0x0);
76     }
77 
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
82         (bool success, ) = recipient.call{ value: amount }("");
83         require(success, "Address: unable to send value, recipient may have reverted");
84     }
85 
86     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
87         return functionCall(target, data, "Address: low-level call failed");
88     }
89 
90     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
91         return _functionCallWithValue(target, data, 0, errorMessage);
92     }
93 
94     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
96     }
97 
98     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
99         require(address(this).balance >= value, "Address: insufficient balance for call");
100         return _functionCallWithValue(target, data, value, errorMessage);
101     }
102 
103     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
104         require(isContract(target), "Address: call to non-contract");
105 
106         // solhint-disable-next-line avoid-low-level-calls
107         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
108         if (success) {
109             return returndata;
110         } else {
111             // Look for revert reason and bubble it up if present
112             if (returndata.length > 0) {
113                 
114                 assembly {
115                     let returndata_size := mload(returndata)
116                     revert(add(32, returndata), returndata_size)
117                 }
118             } else {
119                 revert(errorMessage);
120             }
121         }
122     }
123 }
124 
125 contract Ownable is Context {
126     address private _owner;
127     address private _previousOwner;
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     constructor() {
131         address msgSender = _msgSender();
132         _owner = msgSender;
133         emit OwnershipTransferred(address(0), msgSender);
134     }
135 
136     function owner() public view returns (address) {
137         return _owner;
138     }
139 
140     modifier onlyOwner() {
141         require(_owner == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     function renounceOwnership() public virtual onlyOwner {
146         emit OwnershipTransferred(_owner, address(0));
147         _owner = address(0);
148     }
149     
150     function transferOwnership(address newOwner) public virtual onlyOwner {
151         require(newOwner != address(0), "Ownable: new owner is the zero address");
152         _transferOwnership(newOwner);
153     }
154 
155     function _transferOwnership(address newOwner) internal virtual {
156         address oldOwner = _owner;
157         _owner = newOwner;
158         emit OwnershipTransferred(oldOwner, newOwner);
159     }
160 }
161 
162 interface IUniswapV2Factory {
163     function createPair(address tokenA, address tokenB) external returns (address pair);
164 }
165 
166 interface IUniswapV2Router01 {
167     function factory() external pure returns (address);
168     function WETH() external pure returns (address);
169 
170     function addLiquidity(
171         address tokenA,
172         address tokenB,
173         uint amountADesired,
174         uint amountBDesired,
175         uint amountAMin,
176         uint amountBMin,
177         address to,
178         uint deadline
179     ) external returns (uint amountA, uint amountB, uint liquidity);
180     function addLiquidityETH(
181         address token,
182         uint amountTokenDesired,
183         uint amountTokenMin,
184         uint amountETHMin,
185         address to,
186         uint deadline
187     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
188     function removeLiquidity(
189         address tokenA,
190         address tokenB,
191         uint liquidity,
192         uint amountAMin,
193         uint amountBMin,
194         address to,
195         uint deadline
196     ) external returns (uint amountA, uint amountB);
197     function removeLiquidityETH(
198         address token,
199         uint liquidity,
200         uint amountTokenMin,
201         uint amountETHMin,
202         address to,
203         uint deadline
204     ) external returns (uint amountToken, uint amountETH);
205     function removeLiquidityWithPermit(
206         address tokenA,
207         address tokenB,
208         uint liquidity,
209         uint amountAMin,
210         uint amountBMin,
211         address to,
212         uint deadline,
213         bool approveMax, uint8 v, bytes32 r, bytes32 s
214     ) external returns (uint amountA, uint amountB);
215     function removeLiquidityETHWithPermit(
216         address token,
217         uint liquidity,
218         uint amountTokenMin,
219         uint amountETHMin,
220         address to,
221         uint deadline,
222         bool approveMax, uint8 v, bytes32 r, bytes32 s
223     ) external returns (uint amountToken, uint amountETH);
224     function swapExactTokensForTokens(
225         uint amountIn,
226         uint amountOutMin,
227         address[] calldata path,
228         address to,
229         uint deadline
230     ) external returns (uint[] memory amounts);
231     function swapTokensForExactTokens(
232         uint amountOut,
233         uint amountInMax,
234         address[] calldata path,
235         address to,
236         uint deadline
237     ) external returns (uint[] memory amounts);
238     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
239         external
240         payable
241         returns (uint[] memory amounts);
242     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
243         external
244         returns (uint[] memory amounts);
245     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
246         external
247         returns (uint[] memory amounts);
248     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
249         external
250         payable
251         returns (uint[] memory amounts);
252 
253     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
254     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
255     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
256     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
257     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
258 }
259 
260 interface IUniswapV2Router02 is IUniswapV2Router01 {
261     function swapExactTokensForETHSupportingFeeOnTransferTokens(
262         uint256 amountIn,
263         uint256 amountOutMin,
264         address[] calldata path,
265         address to,
266         uint256 deadline
267     ) external;
268     function swapExactETHForTokensSupportingFeeOnTransferTokens(
269         uint amountOutMin,
270         address[] calldata path,
271         address to,
272         uint deadline
273     ) external payable;
274     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
275         uint amountIn,
276         uint amountOutMin,
277         address[] calldata path,
278         address to,
279         uint deadline
280     ) external;
281     function factory() external pure returns (address);
282     function WETH() external pure returns (address);
283     function addLiquidityETH(
284         address token,
285         uint256 amountTokenDesired,
286         uint256 amountTokenMin,
287         uint256 amountETHMin,
288         address to,
289         uint256 deadline
290     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
291     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
292     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
293     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
294     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
295     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
296 }
297 
298 contract Scorcher is Context, IERC20, Ownable {
299     using SafeMath for uint256;
300     using Address for address;
301 
302     string private constant _name = "Scorcher";
303     string private constant _symbol = "SCOR";
304     uint8 private constant _decimals = 6;
305     mapping(address => uint256) private _balances;
306 
307     mapping(address => mapping(address => uint256)) private _allowances;
308     mapping(address => bool) private _isExcludedFromFee;
309     uint256 public _tTotal = 1000 * 1e3 * 1e6; //1,000,000
310 
311     uint256 public _maxWalletAmount = 20 * 1e3 * 1e6; //2%
312     uint256 public j_maxtxn = 10 * 1e3 * 1e6; //1%
313     uint256 public swapAmount = 7 * 1e2 * 1e6; //.07%
314     uint256 private buyPyroUpperLimit = 100 * 1e14; // 0.01
315 
316     // fees
317     uint256 public j_liqBuy = 3; 
318     uint256 public j_burnBuy = 3;
319     uint256 public j_pyroBuy = 3;
320     uint256 public j_jeetBuy = 0;
321 
322     uint256 public j_liqSell = 3; 
323     uint256 public j_burnSell = 3;
324     uint256 public j_pyroSell = 3;
325     uint256 public j_jeetSell = 9;
326  
327     uint256 private j_previousLiqFee = j_liqFee;
328     uint256 private j_previousBurnFee = j_burnFee;
329     uint256 private j_previousPyroFee = j_pyroFee;
330     uint256 private j_previousJeetTax = j_jeetTax;
331     
332     uint256 private j_liqFee;
333     uint256 private j_burnFee;
334     uint256 private j_pyroFee;
335     uint256 private j_jeetTax;
336 
337     uint256 public _totalBurned;
338 
339     struct FeeBreakdown {
340         uint256 tLiq;
341         uint256 tBurn;
342         uint256 tPyro;
343         uint256 tJeet;
344         uint256 tAmount;
345     }
346 
347     mapping(address => bool) private bots;
348     address payable private scorcherWallet = payable(0x1bac9F80D0a91faC0DEbbb4953927e588733b74d);
349     address payable public dead = payable(0x000000000000000000000000000000000000dEaD);
350     address PYRO = 0x89568569DA9C83CB35E59F92f5Df2F6CA829EEeE;
351 
352     IUniswapV2Router02 public uniswapV2Router;
353     address public uniswapV2Pair;
354 
355     bool private swapping = false;
356     bool public burnMode = false;
357 
358     modifier lockSwap {
359         swapping = true;
360         _;
361         swapping = false;
362     }
363 
364     constructor() {
365         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
366         uniswapV2Router = _uniswapV2Router;
367         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
368         
369         _balances[_msgSender()] = _tTotal;
370         _isExcludedFromFee[owner()] = true;
371         _isExcludedFromFee[scorcherWallet] = true;
372         _isExcludedFromFee[dead] = true;
373         _isExcludedFromFee[address(this)] = true;
374         emit Transfer(address(0), _msgSender(), _tTotal);
375     }
376 
377     function name() public pure returns (string memory) {
378         return _name;
379     }
380 
381     function symbol() public pure returns (string memory) {
382         return _symbol;
383     }
384 
385     function decimals() public pure returns (uint8) {
386         return _decimals;
387     }
388 
389     function totalSupply() public view override returns (uint256) {
390         return _tTotal;
391     }
392 
393     function balanceOf(address account) public view override returns (uint256) {
394         return _balances[account];
395     }
396     
397     function transfer(address recipient, uint256 amount) external override returns (bool) {
398         _transfer(_msgSender(), recipient, amount);
399         return true;
400     }
401 
402     function allowance(address owner, address spender) external view override returns (uint256) {
403         return _allowances[owner][spender];
404     }
405 
406     function approve(address spender, uint256 amount) external override returns (bool) {
407         _approve(_msgSender(), spender, amount);
408         return true;
409     }
410 
411     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
412         _transfer(sender, recipient, amount);
413         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
414         return true;
415     }
416 
417     function totalBurned() public view returns (uint256) {
418         return _totalBurned;
419     }
420 
421     function burning(address _account, uint _amount) private {  
422         require( _amount <= balanceOf(_account));
423         _balances[_account] = _balances[_account].sub(_amount);
424         _tTotal = _tTotal.sub(_amount);
425         _totalBurned = _totalBurned.add(_amount);
426         emit Transfer(_account, address(0), _amount);
427     }
428 
429     function removeAllFee() private {
430         if (j_burnFee == 0 && j_liqFee == 0 && j_pyroFee == 0 && j_jeetTax == 0) return;
431         j_previousBurnFee = j_burnFee;
432         j_previousLiqFee = j_liqFee;
433         j_previousPyroFee = j_pyroFee;
434         j_previousJeetTax = j_jeetTax;
435 
436         j_burnFee = 0;
437         j_liqFee = 0;
438         j_pyroFee = 0;
439         j_jeetTax = 0;
440     }
441     
442     function restoreAllFee() private {
443         j_liqFee = j_previousLiqFee;
444         j_burnFee = j_previousBurnFee;
445         j_pyroFee = j_previousPyroFee;
446         j_jeetTax = j_previousJeetTax;
447     }
448 
449     function removeJeetTax() external {
450         require(_msgSender() == scorcherWallet);
451         j_jeetSell = 0;
452     }
453 
454     function _approve(address owner, address spender, uint256 amount) private {
455         require(owner != address(0), "ERC20: approve from the zero address");
456         require(spender != address(0), "ERC20: approve to the zero address");
457         _allowances[owner][spender] = amount;
458         emit Approval(owner, spender, amount);
459     }
460     
461     function _transfer(address from, address to, uint256 amount) private {
462         require(from != address(0), "ERC20: transfer from the zero address");
463         require(to != address(0), "ERC20: transfer to the zero address");
464         require(amount > 0, "Transfer amount must be greater than zero");
465         require(!bots[from] && !bots[to]);
466 
467         bool takeFee = true;
468 
469         if (from != owner() && to != owner() && from != address(this) && to != address(this)) {
470 
471             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ((!_isExcludedFromFee[from] || !_isExcludedFromFee[to]))) {
472                 require(balanceOf(to).add(amount) <= _maxWalletAmount, "You are being greedy. Exceeding Max Wallet.");
473                 require(amount <= j_maxtxn, "Slow down buddy...there is a max transaction");
474             }
475 
476             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !bots[to] && !bots[from]) {
477                 j_liqFee = j_liqBuy;
478                 j_burnFee = j_burnBuy;
479                 j_pyroFee = j_pyroBuy;
480                 j_jeetTax = j_jeetBuy;
481             }
482                 
483             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !bots[to] && !bots[from]) {
484                 j_liqFee = j_liqSell;
485                 j_burnFee = j_burnSell;
486                 j_pyroFee = j_pyroSell;
487                 j_jeetTax = j_jeetSell;
488             }
489            
490             if (!swapping && from != uniswapV2Pair) {
491 
492                 uint256 contractTokenBalance = balanceOf(address(this));
493 
494                 if (contractTokenBalance > swapAmount) {
495                     swapAndLiquify(contractTokenBalance);
496                 }
497 
498                 uint256 contractETHBalance = address(this).balance;
499             
500                 if (!burnMode && (contractETHBalance > 0)) {
501                     sendETHToFee(address(this).balance);
502                 } else if (burnMode && (contractETHBalance > buyPyroUpperLimit)) {
503                         uint256 buyAmount = (contractETHBalance.div(2));
504                     buyPyro(buyAmount);
505                 }                    
506             }
507         }
508 
509         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
510             takeFee = false;
511         }
512         
513         _transferAgain(from, to, amount, takeFee);
514         restoreAllFee();
515     }
516 
517     function setMaxTxn(uint256 maxTransaction) external {
518         require(maxTransaction >= 10 * 1e3 * 1e6,"negative ghost rider");
519         require(_msgSender() == scorcherWallet);
520         j_maxtxn = maxTransaction;
521     }
522 
523     function swapTokensForEth(uint256 tokenAmount) private lockSwap {
524         address[] memory path = new address[](2);
525         path[0] = address(this);
526         path[1] = uniswapV2Router.WETH();
527         _approve(address(this), address(uniswapV2Router), tokenAmount);
528         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
529     }
530 
531     function swapETHForTokens(uint256 amount) private {
532         // generate the uniswap pair path of token -> weth
533         address[] memory path = new address[](2);
534         path[0] = uniswapV2Router.WETH();
535         path[1] = address(PYRO);
536 
537       // make the swap
538         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
539             0, // accept any amount of Tokens
540             path,
541             dead, // Burn address
542             block.timestamp
543         );        
544     }
545 
546     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
547         _approve(address(this), address(uniswapV2Router), tokenAmount);
548 
549         // add the liquidity
550         uniswapV2Router.addLiquidityETH{value: ethAmount}(
551             address(this),
552             tokenAmount,
553             0, // slippage is unavoidable
554             0, // slippage is unavoidable
555             scorcherWallet,
556             block.timestamp
557           );
558     }
559   
560     function swapAndLiquify(uint256 contractTokenBalance) private lockSwap {
561         uint256 autoLPamount = j_liqFee.mul(contractTokenBalance).div(j_burnFee.add(j_pyroFee).add(j_jeetTax).add(j_liqFee));
562         uint256 half =  autoLPamount.div(2);
563         uint256 otherHalf = contractTokenBalance.sub(half);
564         uint256 initialBalance = address(this).balance;
565         swapTokensForEth(otherHalf);
566         uint256 newBalance = ((address(this).balance.sub(initialBalance)).mul(half)).div(otherHalf);
567         addLiquidity(half, newBalance);
568     }
569 
570     function sendETHToFee(uint256 amount) private {
571         scorcherWallet.transfer(amount);
572     }
573 
574     function manualSwap() external {
575         require(_msgSender() == scorcherWallet);
576         uint256 contractBalance = balanceOf(address(this));
577         if (contractBalance > 0) {
578             swapTokensForEth(contractBalance);
579         }
580     }
581 
582     function manualSend() external {
583         require(_msgSender() == scorcherWallet);
584         uint256 contractETHBalance = address(this).balance;
585         if (contractETHBalance > 0) {
586             sendETHToFee(contractETHBalance);
587         }
588     }
589 
590     function _transferAgain(address sender, address recipient, uint256 amount, bool takeFee) private {
591         if (!takeFee) { 
592                 removeAllFee();
593         }
594         
595         FeeBreakdown memory fees;
596         fees.tBurn = amount.mul(j_burnFee).div(100);
597         fees.tLiq = amount.mul(j_liqFee).div(100);
598         fees.tPyro = amount.mul(j_pyroFee).div(100);
599         fees.tJeet = amount.mul(j_jeetTax).div(100);
600         
601         fees.tAmount = amount.sub(fees.tPyro).sub(fees.tJeet).sub(fees.tBurn).sub(fees.tLiq);
602 
603         uint256 amountPreBurn = amount.sub(fees.tBurn);
604         burning(sender, fees.tBurn);
605 
606         _balances[sender] = _balances[sender].sub(amountPreBurn);
607         _balances[recipient] = _balances[recipient].add(fees.tAmount);
608         _balances[address(this)] = _balances[address(this)].add(fees.tPyro).add(fees.tJeet).add(fees.tBurn.add(fees.tLiq));
609         
610         if(burnMode && sender != uniswapV2Pair && sender != address(this) && sender != address(uniswapV2Router) && (recipient == address(uniswapV2Router) || recipient == uniswapV2Pair)) {
611             burning(uniswapV2Pair, fees.tBurn);
612         }
613 
614         emit Transfer(sender, recipient, fees.tAmount);
615         restoreAllFee();
616     }
617     
618     receive() external payable {}
619 
620     function setMaxWalletAmount(uint256 maxWalletAmount) external {
621         require(_msgSender() == scorcherWallet);
622         require(maxWalletAmount > _tTotal.div(200), "Amount must be greater than 0.5% of supply");
623         _maxWalletAmount = maxWalletAmount;
624     }
625 
626     function setSwapAmount(uint256 _swapAmount) external {
627         require(_msgSender() == scorcherWallet);
628         swapAmount = _swapAmount;
629     }
630 
631     function turnOnTheBurn() public onlyOwner {
632         burnMode = true;
633     }
634 
635     function buyPyro(uint256 amount) private {
636     	if (amount > 0) {
637     	    swapETHForTokens(amount);
638 	    }
639     }
640 
641     function setBuyPyroRate(uint256 buyPyroToken) external {
642         require(_msgSender() == scorcherWallet);
643         buyPyroUpperLimit = buyPyroToken;
644     }
645 
646 }