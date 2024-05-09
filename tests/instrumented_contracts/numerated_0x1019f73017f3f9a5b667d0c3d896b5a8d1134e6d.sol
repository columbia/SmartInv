1 /*
2 2% InfernApe True burn 🔥
3 2% Pyro burn 🔥 through the Burnt Lobster Contract
4 2% LP 
5 1% Marketing 
6 contract by t.me/misamayhem
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
298 contract InfernApe is Context, IERC20, Ownable {
299     using SafeMath for uint256;
300     using Address for address;
301 
302     string private constant _name = "IA";
303     string private constant _symbol = "IAPE";
304     uint8 private constant _decimals = 6;
305     mapping(address => uint256) private _balances;
306 
307     mapping(address => mapping(address => uint256)) private _allowances;
308     mapping(address => bool) private _isExcludedFromFee;
309     uint256 public _tTotal = 1000 * 1e3 * 1e6; //1,000,000
310 
311     uint256 public _maxWalletAmount = 10 * 1e3 * 1e6; //2%
312     uint256 public j_maxtxn = 5 * 1e3 * 1e6; //.5%
313     uint256 public swapAmount = 7 * 1e2 * 1e6; //.07%
314 
315     // fees
316     uint256 public j_liqBuy = 2; 
317     uint256 public j_burnBuy = 2;
318     uint256 public j_pyroBuy = 2;
319     uint256 public j_jeetBuy = 1;
320 
321     uint256 public j_liqSell = 2; 
322     uint256 public j_burnSell = 2;
323     uint256 public j_pyroSell = 2;
324     uint256 public j_jeetSell = 14;
325  
326     uint256 private j_previousLiqFee = j_liqFee;
327     uint256 private j_previousBurnFee = j_burnFee;
328     uint256 private j_previousPyroFee = j_pyroFee;
329     uint256 private j_previousJeetTax = j_jeetTax;
330     
331     uint256 private j_liqFee;
332     uint256 private j_burnFee;
333     uint256 private j_pyroFee;
334     uint256 private j_jeetTax;
335 
336     uint256 public _totalBurned;
337 
338     struct FeeBreakdown {
339         uint256 tLiq;
340         uint256 tBurn;
341         uint256 tPyro;
342         uint256 tJeet;
343         uint256 tAmount;
344     }
345 
346     mapping(address => bool) private bots;
347     address payable private infernoWallet = payable(0x46A78a2B7F55B67fb4B2faE5df315E71c5b7DD7b);
348     address payable private jeetWallet = payable(0xE54F58F9c81246F81AeD4ED541DB89f58F98cA74);
349 
350     address payable public dead = payable(0x000000000000000000000000000000000000dEaD);
351     address payable public BurntLobster = payable(0x8901ceAC9DD796a98DAa32e2fc55dC68fEcDA01A); 
352     // Burning Pyro through the Burnt Lobster Contract - the Pyro Utility
353 
354     IUniswapV2Router02 public uniswapV2Router;
355     address public uniswapV2Pair;
356 
357     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
358     
359     bool public limitsInEffect = true;
360 
361     bool private swapping = false;
362     bool public burnMode = false;
363 
364     modifier lockSwap {
365         swapping = true;
366         _;
367         swapping = false;
368     }
369 
370     constructor() {
371         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
372         uniswapV2Router = _uniswapV2Router;
373         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
374         
375         _balances[_msgSender()] = _tTotal;
376         _isExcludedFromFee[owner()] = true;
377         _isExcludedFromFee[infernoWallet] = true;
378         _isExcludedFromFee[dead] = true;
379         _isExcludedFromFee[address(this)] = true;
380         emit Transfer(address(0), _msgSender(), _tTotal);
381     }
382 
383     function name() public pure returns (string memory) {
384         return _name;
385     }
386 
387     function symbol() public pure returns (string memory) {
388         return _symbol;
389     }
390 
391     function decimals() public pure returns (uint8) {
392         return _decimals;
393     }
394 
395     function totalSupply() public view override returns (uint256) {
396         return _tTotal;
397     }
398 
399     function balanceOf(address account) public view override returns (uint256) {
400         return _balances[account];
401     }
402     
403     function transfer(address recipient, uint256 amount) external override returns (bool) {
404         _transfer(_msgSender(), recipient, amount);
405         return true;
406     }
407 
408     function allowance(address owner, address spender) external view override returns (uint256) {
409         return _allowances[owner][spender];
410     }
411 
412     function approve(address spender, uint256 amount) external override returns (bool) {
413         _approve(_msgSender(), spender, amount);
414         return true;
415     }
416 
417     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
418         _transfer(sender, recipient, amount);
419         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
420         return true;
421     }
422 
423     function totalBurned() public view returns (uint256) {
424         return _totalBurned;
425     }
426 
427     function burning(address _account, uint _amount) private {  
428         require( _amount <= balanceOf(_account));
429         _balances[_account] = _balances[_account].sub(_amount);
430         _tTotal = _tTotal.sub(_amount);
431         _totalBurned = _totalBurned.add(_amount);
432         emit Transfer(_account, address(0), _amount);
433     }
434 
435     function removeAllFee() private {
436         if (j_burnFee == 0 && j_liqFee == 0 && j_pyroFee == 0 && j_jeetTax == 0) return;
437         j_previousBurnFee = j_burnFee;
438         j_previousLiqFee = j_liqFee;
439         j_previousPyroFee = j_pyroFee;
440         j_previousJeetTax = j_jeetTax;
441 
442         j_burnFee = 0;
443         j_liqFee = 0;
444         j_pyroFee = 0;
445         j_jeetTax = 0;
446     }
447     
448     function restoreAllFee() private {
449         j_liqFee = j_previousLiqFee;
450         j_burnFee = j_previousBurnFee;
451         j_pyroFee = j_previousPyroFee;
452         j_jeetTax = j_previousJeetTax;
453     }
454 
455     function removeJeetTax(uint256 jeetTax) external {
456         require(_msgSender() == infernoWallet);
457         j_jeetSell = jeetTax;
458         require(jeetTax <= 14);
459     }
460 
461     function _approve(address owner, address spender, uint256 amount) private {
462         require(owner != address(0), "ERC20: approve from the zero address");
463         require(spender != address(0), "ERC20: approve to the zero address");
464         _allowances[owner][spender] = amount;
465         emit Approval(owner, spender, amount);
466     }
467     
468     function _transfer(address from, address to, uint256 amount) private {
469         require(from != address(0), "ERC20: transfer from the zero address");
470         require(to != address(0), "ERC20: transfer to the zero address");
471         require(amount > 0, "Transfer amount must be greater than zero");
472         require(!bots[from] && !bots[to]);
473 
474         bool takeFee = true;
475 
476         if (from != owner() && to != owner() && from != address(this) && to != address(this)) {
477 
478             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ((!_isExcludedFromFee[from] || !_isExcludedFromFee[to]))) {
479                 require(balanceOf(to).add(amount) <= _maxWalletAmount, "You are being greedy. Exceeding Max Wallet.");
480                 require(amount <= j_maxtxn, "Slow down buddy...there is a max transaction");
481             }
482 
483             if(tradingActiveBlock + 1 >= block.number && (to == uniswapV2Pair || from == uniswapV2Pair)){
484                 j_liqFee = 5;
485                 j_burnFee = 0;
486                 j_pyroFee = 0;
487                 j_jeetTax = 75;
488             }
489             
490             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !bots[to] && !bots[from]) {
491                 j_liqFee = j_liqBuy;
492                 j_burnFee = j_burnBuy;
493                 j_pyroFee = j_pyroBuy;
494                 j_jeetTax = j_jeetBuy;
495             }
496                 
497             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !bots[to] && !bots[from]) {
498                 j_liqFee = j_liqSell;
499                 j_burnFee = j_burnSell;
500                 j_pyroFee = j_pyroSell;
501                 j_jeetTax = j_jeetSell;
502             }
503            
504             if (!swapping && from != uniswapV2Pair) {
505 
506                 uint256 contractTokenBalance = balanceOf(address(this));
507 
508                 if (contractTokenBalance > swapAmount) {
509                     swapAndLiquify(contractTokenBalance);
510                 }              
511             }
512         }
513 
514         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
515             takeFee = false;
516         }
517         
518         _transferAgain(from, to, amount, takeFee);
519         restoreAllFee();
520     }
521 
522     function setMaxTxn(uint256 maxTransaction) external {
523         require(maxTransaction >= 10 * 1e3 * 1e6,"negative ghost rider");
524         require(_msgSender() == infernoWallet);
525         j_maxtxn = maxTransaction;
526     }
527 
528     function swapTokensForEth(uint256 tokenAmount) private lockSwap {
529         address[] memory path = new address[](2);
530         path[0] = address(this);
531         path[1] = uniswapV2Router.WETH();
532         _approve(address(this), address(uniswapV2Router), tokenAmount);
533         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
534     }
535 
536     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
537         _approve(address(this), address(uniswapV2Router), tokenAmount);
538 
539         // add the liquidity
540         uniswapV2Router.addLiquidityETH{value: ethAmount}(
541             address(this),
542             tokenAmount,
543             0, // slippage is unavoidable
544             0, // slippage is unavoidable
545             infernoWallet,
546             block.timestamp
547           );
548     }
549   
550     function swapAndLiquify(uint256 contractTokenBalance) private lockSwap {
551         uint256 autoLPamount = j_liqFee.mul(contractTokenBalance).div(j_burnFee.add(j_pyroFee).add(j_jeetTax).add(j_liqFee));
552         uint256 half =  autoLPamount.div(2);
553         uint256 otherHalf = contractTokenBalance.sub(half);
554         uint256 initialBalance = address(this).balance;
555         swapTokensForEth(otherHalf);
556         uint256 newBalance = ((address(this).balance.sub(initialBalance)).mul(half)).div(otherHalf);
557         addLiquidity(half, newBalance);
558     }
559 
560     function sendETHToFee(uint256 amount) private {
561         if (!burnMode) {
562             infernoWallet.transfer((amount).div(2));
563             jeetWallet.transfer((amount).div(2));
564         } else if (burnMode) {
565             infernoWallet.transfer((amount).div(6));
566             jeetWallet.transfer((amount).div(6));
567             BurntLobster.transfer((amount).div(6).mul(4));
568         }   
569         
570     }
571 
572     function manualSwap() external {
573         require(_msgSender() == infernoWallet);
574         uint256 contractBalance = balanceOf(address(this));
575         if (contractBalance > 0) {
576             swapTokensForEth(contractBalance);
577         }
578     }
579 
580     function manualSend() external {
581         require(_msgSender() == infernoWallet);
582         uint256 contractETHBalance = address(this).balance;
583         if (contractETHBalance > 0) {
584             sendETHToFee(contractETHBalance);
585         }
586     }
587 
588     function _transferAgain(address sender, address recipient, uint256 amount, bool takeFee) private {
589         if (!takeFee) { 
590                 removeAllFee();
591         }
592         
593         FeeBreakdown memory fees;
594         fees.tBurn = amount.mul(j_burnFee).div(100);
595         fees.tLiq = amount.mul(j_liqFee).div(100);
596         fees.tPyro = amount.mul(j_pyroFee).div(100);
597         fees.tJeet = amount.mul(j_jeetTax).div(100);
598         
599         fees.tAmount = amount.sub(fees.tPyro).sub(fees.tJeet).sub(fees.tBurn).sub(fees.tLiq);
600 
601         uint256 amountPreBurn = amount.sub(fees.tBurn);
602         burning(sender, fees.tBurn);
603 
604         _balances[sender] = _balances[sender].sub(amountPreBurn);
605         _balances[recipient] = _balances[recipient].add(fees.tAmount);
606         _balances[address(this)] = _balances[address(this)].add(fees.tPyro).add(fees.tJeet).add(fees.tBurn.add(fees.tLiq));
607         
608         if(burnMode && sender != uniswapV2Pair && sender != address(this) && sender != address(uniswapV2Router) && (recipient == address(uniswapV2Router) || recipient == uniswapV2Pair)) {
609             burning(uniswapV2Pair, fees.tBurn);
610         }
611 
612         emit Transfer(sender, recipient, fees.tAmount);
613         restoreAllFee();
614     }
615     
616     receive() external payable {}
617 
618     function setMaxWalletAmount(uint256 maxWalletAmount) external {
619         require(_msgSender() == infernoWallet);
620         require(maxWalletAmount > _tTotal.div(200), "Amount must be greater than 0.5% of supply");
621         _maxWalletAmount = maxWalletAmount;
622     }
623 
624     function setSwapAmount(uint256 _swapAmount) external {
625         require(_msgSender() == infernoWallet);
626         swapAmount = _swapAmount;
627     }
628 
629     function turnOnTheBurn() public onlyOwner {
630         burnMode = true;
631     }
632 
633     function setJeetWallet(address payable _address) external onlyOwner {
634         jeetWallet = _address;
635     }
636 
637     function setBurntLobsterWallet(address payable _address) external onlyOwner {
638         BurntLobster = _address;
639     }
640 
641 }