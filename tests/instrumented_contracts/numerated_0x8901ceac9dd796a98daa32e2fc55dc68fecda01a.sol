1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 }
58 
59 library Address {
60         
61     function isContract(address account) internal view returns (bool) {
62         
63         bytes32 codehash;
64         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
65         // solhint-disable-next-line no-inline-assembly
66         assembly { codehash := extcodehash(account) }
67         return (codehash != accountHash && codehash != 0x0);
68     }
69 
70     function sendValue(address payable recipient, uint256 amount) internal {
71         require(address(this).balance >= amount, "Address: insufficient balance");
72 
73         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
74         (bool success, ) = recipient.call{ value: amount }("");
75         require(success, "Address: unable to send value, recipient may have reverted");
76     }
77 
78     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
79         return functionCall(target, data, "Address: low-level call failed");
80     }
81 
82     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
83         return _functionCallWithValue(target, data, 0, errorMessage);
84     }
85 
86     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
87         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
88     }
89 
90     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
91         require(address(this).balance >= value, "Address: insufficient balance for call");
92         return _functionCallWithValue(target, data, value, errorMessage);
93     }
94 
95     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
96         require(isContract(target), "Address: call to non-contract");
97 
98         // solhint-disable-next-line avoid-low-level-calls
99         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
100         if (success) {
101             return returndata;
102         } else {
103             // Look for revert reason and bubble it up if present
104             if (returndata.length > 0) {
105                 
106                 assembly {
107                     let returndata_size := mload(returndata)
108                     revert(add(32, returndata), returndata_size)
109                 }
110             } else {
111                 revert(errorMessage);
112             }
113         }
114     }
115 }
116 
117 contract Ownable is Context {
118     address private _owner;
119     address private _previousOwner;
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     constructor() {
123         address msgSender = _msgSender();
124         _owner = msgSender;
125         emit OwnershipTransferred(address(0), msgSender);
126     }
127 
128     function owner() public view returns (address) {
129         return _owner;
130     }
131 
132     modifier onlyOwner() {
133         require(_owner == _msgSender(), "Ownable: caller is not the owner");
134         _;
135     }
136 
137     function renounceOwnership() public virtual onlyOwner {
138         emit OwnershipTransferred(_owner, address(0));
139         _owner = address(0);
140     }
141     
142     function transferOwnership(address newOwner) public virtual onlyOwner {
143         require(newOwner != address(0), "Ownable: new owner is the zero address");
144         _transferOwnership(newOwner);
145     }
146 
147     function _transferOwnership(address newOwner) internal virtual {
148         address oldOwner = _owner;
149         _owner = newOwner;
150         emit OwnershipTransferred(oldOwner, newOwner);
151     }
152 }
153 
154 interface IUniswapV2Factory {
155     function createPair(address tokenA, address tokenB) external returns (address pair);
156 }
157 
158 interface IUniswapV2Router01 {
159     function factory() external pure returns (address);
160     function WETH() external pure returns (address);
161 
162     function addLiquidity(
163         address tokenA,
164         address tokenB,
165         uint amountADesired,
166         uint amountBDesired,
167         uint amountAMin,
168         uint amountBMin,
169         address to,
170         uint deadline
171     ) external returns (uint amountA, uint amountB, uint liquidity);
172     function addLiquidityETH(
173         address token,
174         uint amountTokenDesired,
175         uint amountTokenMin,
176         uint amountETHMin,
177         address to,
178         uint deadline
179     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
180     function removeLiquidity(
181         address tokenA,
182         address tokenB,
183         uint liquidity,
184         uint amountAMin,
185         uint amountBMin,
186         address to,
187         uint deadline
188     ) external returns (uint amountA, uint amountB);
189     function removeLiquidityETH(
190         address token,
191         uint liquidity,
192         uint amountTokenMin,
193         uint amountETHMin,
194         address to,
195         uint deadline
196     ) external returns (uint amountToken, uint amountETH);
197     function removeLiquidityWithPermit(
198         address tokenA,
199         address tokenB,
200         uint liquidity,
201         uint amountAMin,
202         uint amountBMin,
203         address to,
204         uint deadline,
205         bool approveMax, uint8 v, bytes32 r, bytes32 s
206     ) external returns (uint amountA, uint amountB);
207     function removeLiquidityETHWithPermit(
208         address token,
209         uint liquidity,
210         uint amountTokenMin,
211         uint amountETHMin,
212         address to,
213         uint deadline,
214         bool approveMax, uint8 v, bytes32 r, bytes32 s
215     ) external returns (uint amountToken, uint amountETH);
216     function swapExactTokensForTokens(
217         uint amountIn,
218         uint amountOutMin,
219         address[] calldata path,
220         address to,
221         uint deadline
222     ) external returns (uint[] memory amounts);
223     function swapTokensForExactTokens(
224         uint amountOut,
225         uint amountInMax,
226         address[] calldata path,
227         address to,
228         uint deadline
229     ) external returns (uint[] memory amounts);
230     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
231         external
232         payable
233         returns (uint[] memory amounts);
234     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
235         external
236         returns (uint[] memory amounts);
237     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
238         external
239         returns (uint[] memory amounts);
240     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
241         external
242         payable
243         returns (uint[] memory amounts);
244 
245     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
246     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
247     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
248     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
249     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
250 }
251 
252 interface IUniswapV2Router02 is IUniswapV2Router01 {
253     function swapExactTokensForETHSupportingFeeOnTransferTokens(
254         uint256 amountIn,
255         uint256 amountOutMin,
256         address[] calldata path,
257         address to,
258         uint256 deadline
259     ) external;
260     function swapExactETHForTokensSupportingFeeOnTransferTokens(
261         uint amountOutMin,
262         address[] calldata path,
263         address to,
264         uint deadline
265     ) external payable;
266     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
267         uint amountIn,
268         uint amountOutMin,
269         address[] calldata path,
270         address to,
271         uint deadline
272     ) external;
273     function factory() external pure returns (address);
274     function WETH() external pure returns (address);
275     function addLiquidityETH(
276         address token,
277         uint256 amountTokenDesired,
278         uint256 amountTokenMin,
279         uint256 amountETHMin,
280         address to,
281         uint256 deadline
282     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
283     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
284     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
285     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
286     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
287     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
288 }
289 
290 contract BurntLobster is Context, IERC20, Ownable {
291     using SafeMath for uint256;
292     using Address for address;
293 
294     string private constant _name = "Burnt Lobster";
295     string private constant _symbol = unicode"🔥🦞";
296     uint8 private constant _decimals = 6;
297     mapping(address => uint256) private _balances;
298 
299     mapping(address => mapping(address => uint256)) private _allowances;
300     mapping(address => bool) private _isExcludedFromFee;
301     uint256 public _tTotal = 1000 * 1e3 * 1e6; //1,000,000
302 
303     uint256 public _maxWalletAmount = 20 * 1e3 * 1e6; //2%
304     uint256 public j_maxtxn = 20 * 1e3 * 1e6; //1%
305     uint256 public swapAmount = 7 * 1e2 * 1e6; //.07%
306     uint256 private buyPyroUpperLimit = 100 * 1e14; // 0.01
307 
308     // fees
309     uint256 public j_liqBuy = 3; 
310     uint256 public j_burnBuy = 3;
311     uint256 public j_pyroBuy = 3;
312     uint256 public j_jeetBuy = 0;
313 
314     uint256 public j_liqSell = 3; 
315     uint256 public j_burnSell = 3;
316     uint256 public j_pyroSell = 3;
317     uint256 public j_jeetSell = 9;
318  
319     uint256 private j_previousLiqFee = j_liqFee;
320     uint256 private j_previousBurnFee = j_burnFee;
321     uint256 private j_previousPyroFee = j_pyroFee;
322     uint256 private j_previousJeetTax = j_jeetTax;
323     
324     uint256 private j_liqFee;
325     uint256 private j_burnFee;
326     uint256 private j_pyroFee;
327     uint256 private j_jeetTax;
328 
329     uint256 public _totalBurned;
330 
331     struct FeeBreakdown {
332         uint256 tLiq;
333         uint256 tBurn;
334         uint256 tPyro;
335         uint256 tJeet;
336         uint256 tAmount;
337     }
338 
339     mapping(address => bool) private bots;
340     address payable private scorcherWallet = payable(0x612e05A2Ba306B653DCBe23552856BFD69C11680);
341     address payable private jeetWallet = payable(0x612e05A2Ba306B653DCBe23552856BFD69C11680);
342 
343     address payable public dead = payable(0x000000000000000000000000000000000000dEaD);
344     address PYRO = 0x89568569DA9C83CB35E59F92f5Df2F6CA829EEeE;
345 
346     IUniswapV2Router02 public uniswapV2Router;
347     address public uniswapV2Pair;
348 
349     bool private swapping = false;
350     bool public burnMode = false;
351 
352     modifier lockSwap {
353         swapping = true;
354         _;
355         swapping = false;
356     }
357 
358     constructor() {
359         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
360         uniswapV2Router = _uniswapV2Router;
361         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
362         
363         _balances[_msgSender()] = _tTotal;
364         _isExcludedFromFee[owner()] = true;
365         _isExcludedFromFee[scorcherWallet] = true;
366         _isExcludedFromFee[dead] = true;
367         _isExcludedFromFee[address(this)] = true;
368         emit Transfer(address(0), _msgSender(), _tTotal);
369     }
370 
371     function name() public pure returns (string memory) {
372         return _name;
373     }
374 
375     function symbol() public pure returns (string memory) {
376         return _symbol;
377     }
378 
379     function decimals() public pure returns (uint8) {
380         return _decimals;
381     }
382 
383     function totalSupply() public view override returns (uint256) {
384         return _tTotal;
385     }
386 
387     function balanceOf(address account) public view override returns (uint256) {
388         return _balances[account];
389     }
390     
391     function transfer(address recipient, uint256 amount) external override returns (bool) {
392         _transfer(_msgSender(), recipient, amount);
393         return true;
394     }
395 
396     function allowance(address owner, address spender) external view override returns (uint256) {
397         return _allowances[owner][spender];
398     }
399 
400     function approve(address spender, uint256 amount) external override returns (bool) {
401         _approve(_msgSender(), spender, amount);
402         return true;
403     }
404 
405     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
406         _transfer(sender, recipient, amount);
407         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
408         return true;
409     }
410 
411     function totalBurned() public view returns (uint256) {
412         return _totalBurned;
413     }
414 
415     function burning(address _account, uint _amount) private {  
416         require( _amount <= balanceOf(_account));
417         _balances[_account] = _balances[_account].sub(_amount);
418         _tTotal = _tTotal.sub(_amount);
419         _totalBurned = _totalBurned.add(_amount);
420         emit Transfer(_account, address(0), _amount);
421     }
422 
423     function removeAllFee() private {
424         if (j_burnFee == 0 && j_liqFee == 0 && j_pyroFee == 0 && j_jeetTax == 0) return;
425         j_previousBurnFee = j_burnFee;
426         j_previousLiqFee = j_liqFee;
427         j_previousPyroFee = j_pyroFee;
428         j_previousJeetTax = j_jeetTax;
429 
430         j_burnFee = 0;
431         j_liqFee = 0;
432         j_pyroFee = 0;
433         j_jeetTax = 0;
434     }
435     
436     function restoreAllFee() private {
437         j_liqFee = j_previousLiqFee;
438         j_burnFee = j_previousBurnFee;
439         j_pyroFee = j_previousPyroFee;
440         j_jeetTax = j_previousJeetTax;
441     }
442 
443     function removeJeetTax() external {
444         require(_msgSender() == scorcherWallet);
445         j_jeetSell = 1;
446         j_liqSell = 2;
447         j_liqBuy = 2;
448         j_jeetBuy = 1;
449 
450     }
451 
452     function _approve(address owner, address spender, uint256 amount) private {
453         require(owner != address(0), "ERC20: approve from the zero address");
454         require(spender != address(0), "ERC20: approve to the zero address");
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458     
459     function _transfer(address from, address to, uint256 amount) private {
460         require(from != address(0), "ERC20: transfer from the zero address");
461         require(to != address(0), "ERC20: transfer to the zero address");
462         require(amount > 0, "Transfer amount must be greater than zero");
463         require(!bots[from] && !bots[to]);
464 
465         bool takeFee = true;
466 
467         if (from != owner() && to != owner() && from != address(this) && to != address(this)) {
468 
469             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ((!_isExcludedFromFee[from] || !_isExcludedFromFee[to]))) {
470                 require(balanceOf(to).add(amount) <= _maxWalletAmount, "You are being greedy. Exceeding Max Wallet.");
471                 require(amount <= j_maxtxn, "Slow down buddy...there is a max transaction");
472             }
473             
474 
475             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !bots[to] && !bots[from]) {
476                 j_liqFee = j_liqBuy;
477                 j_burnFee = j_burnBuy;
478                 j_pyroFee = j_pyroBuy;
479                 j_jeetTax = j_jeetBuy;
480             }
481                 
482             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !bots[to] && !bots[from]) {
483                 j_liqFee = j_liqSell;
484                 j_burnFee = j_burnSell;
485                 j_pyroFee = j_pyroSell;
486                 j_jeetTax = j_jeetSell;
487             }
488            
489             if (!swapping && from != uniswapV2Pair) {
490 
491                 uint256 contractTokenBalance = balanceOf(address(this));
492 
493                 if (contractTokenBalance > swapAmount) {
494                     swapAndLiquify(contractTokenBalance);
495                 }
496 
497                 uint256 contractETHBalance = address(this).balance;
498             
499                 if (!burnMode && (contractETHBalance > 0)) {
500                     sendETHToFee(address(this).balance);
501                 } else if (burnMode && (contractETHBalance > buyPyroUpperLimit)) {
502                         uint256 buyAmount = (contractETHBalance.div(2));
503                     buyPyro(buyAmount);
504                 }                    
505             }
506         }
507 
508         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
509             takeFee = false;
510         }
511         
512         _transferAgain(from, to, amount, takeFee);
513         restoreAllFee();
514     }
515 
516     function setMaxTxn(uint256 maxTransaction) external {
517         require(maxTransaction >= 10 * 1e3 * 1e6,"negative ghost rider");
518         require(_msgSender() == scorcherWallet);
519         j_maxtxn = maxTransaction;
520     }
521 
522     function swapTokensForEth(uint256 tokenAmount) private lockSwap {
523         address[] memory path = new address[](2);
524         path[0] = address(this);
525         path[1] = uniswapV2Router.WETH();
526         _approve(address(this), address(uniswapV2Router), tokenAmount);
527         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
528     }
529 
530     function swapETHForTokens(uint256 amount) private {
531         // generate the uniswap pair path of token -> weth
532         address[] memory path = new address[](2);
533         path[0] = uniswapV2Router.WETH();
534         path[1] = address(PYRO);
535 
536       // make the swap
537         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
538             0, // accept any amount of Tokens
539             path,
540             dead, // Burn address
541             block.timestamp
542         );        
543     }
544 
545     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
546         _approve(address(this), address(uniswapV2Router), tokenAmount);
547 
548         // add the liquidity
549         uniswapV2Router.addLiquidityETH{value: ethAmount}(
550             address(this),
551             tokenAmount,
552             0, // slippage is unavoidable
553             0, // slippage is unavoidable
554             scorcherWallet,
555             block.timestamp
556           );
557     }
558   
559     function swapAndLiquify(uint256 contractTokenBalance) private lockSwap {
560         uint256 autoLPamount = j_liqFee.mul(contractTokenBalance).div(j_burnFee.add(j_pyroFee).add(j_jeetTax).add(j_liqFee));
561         uint256 half =  autoLPamount.div(2);
562         uint256 otherHalf = contractTokenBalance.sub(half);
563         uint256 initialBalance = address(this).balance;
564         swapTokensForEth(otherHalf);
565         uint256 newBalance = ((address(this).balance.sub(initialBalance)).mul(half)).div(otherHalf);
566         addLiquidity(half, newBalance);
567     }
568 
569     function sendETHToFee(uint256 amount) private {
570         scorcherWallet.transfer((amount).div(2));
571         jeetWallet.transfer((amount).div(2));
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
646     function setJeetWallet(address payable _address) external onlyOwner {
647         jeetWallet = _address;
648     }
649 
650 }