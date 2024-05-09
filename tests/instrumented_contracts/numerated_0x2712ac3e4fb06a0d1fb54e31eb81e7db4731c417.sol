1 /*
2 🔥 Introducing ShiaBurn - Ignite Your Investments! 🔥
3 
4 🚀 Join the revolution of decentralized finance with ShiaBurn ($ShiaB)!
5 
6 🔥 Tokenomics:
7 - 1% Burn of $ShiaB on every transaction
8 - 1% Automatic Liquidity Pool (LP) generation
9 - 3% Burn of $Shia on every transaction
10 
11 🌐 Website: shiaburn.wtf
12 📢 Telegram:  t.me/shiaburnofficial
13 🐦 Twitter:  twitter.com/ShiaBurn
14 */
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.8.4;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 }
73 
74 library Address {
75         
76     function isContract(address account) internal view returns (bool) {
77         
78         bytes32 codehash;
79         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
80         // solhint-disable-next-line no-inline-assembly
81         assembly { codehash := extcodehash(account) }
82         return (codehash != accountHash && codehash != 0x0);
83     }
84 
85     function sendValue(address payable recipient, uint256 amount) internal {
86         require(address(this).balance >= amount, "Address: insufficient balance");
87 
88         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
89         (bool success, ) = recipient.call{ value: amount }("");
90         require(success, "Address: unable to send value, recipient may have reverted");
91     }
92 
93     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
94         return functionCall(target, data, "Address: low-level call failed");
95     }
96 
97     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
98         return _functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
103     }
104 
105     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
106         require(address(this).balance >= value, "Address: insufficient balance for call");
107         return _functionCallWithValue(target, data, value, errorMessage);
108     }
109 
110     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
111         require(isContract(target), "Address: call to non-contract");
112 
113         // solhint-disable-next-line avoid-low-level-calls
114         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
115         if (success) {
116             return returndata;
117         } else {
118             // Look for revert reason and bubble it up if present
119             if (returndata.length > 0) {
120                 
121                 assembly {
122                     let returndata_size := mload(returndata)
123                     revert(add(32, returndata), returndata_size)
124                 }
125             } else {
126                 revert(errorMessage);
127             }
128         }
129     }
130 }
131 
132 contract Ownable is Context {
133     address private _owner;
134     address private _previousOwner;
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     constructor() {
138         address msgSender = _msgSender();
139         _owner = msgSender;
140         emit OwnershipTransferred(address(0), msgSender);
141     }
142 
143     function owner() public view returns (address) {
144         return _owner;
145     }
146 
147     modifier onlyOwner() {
148         require(_owner == _msgSender(), "Ownable: caller is not the owner");
149         _;
150     }
151 
152     function renounceOwnership() public virtual onlyOwner {
153         emit OwnershipTransferred(_owner, address(0));
154         _owner = address(0);
155     }
156     
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         _transferOwnership(newOwner);
160     }
161 
162     function _transferOwnership(address newOwner) internal virtual {
163         address oldOwner = _owner;
164         _owner = newOwner;
165         emit OwnershipTransferred(oldOwner, newOwner);
166     }
167 }
168 
169 interface IUniswapV2Factory {
170     function createPair(address tokenA, address tokenB) external returns (address pair);
171 }
172 
173 interface IUniswapV2Router01 {
174     function factory() external pure returns (address);
175     function WETH() external pure returns (address);
176 
177     function addLiquidity(
178         address tokenA,
179         address tokenB,
180         uint amountADesired,
181         uint amountBDesired,
182         uint amountAMin,
183         uint amountBMin,
184         address to,
185         uint deadline
186     ) external returns (uint amountA, uint amountB, uint liquidity);
187     function addLiquidityETH(
188         address token,
189         uint amountTokenDesired,
190         uint amountTokenMin,
191         uint amountETHMin,
192         address to,
193         uint deadline
194     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
195     function removeLiquidity(
196         address tokenA,
197         address tokenB,
198         uint liquidity,
199         uint amountAMin,
200         uint amountBMin,
201         address to,
202         uint deadline
203     ) external returns (uint amountA, uint amountB);
204     function removeLiquidityETH(
205         address token,
206         uint liquidity,
207         uint amountTokenMin,
208         uint amountETHMin,
209         address to,
210         uint deadline
211     ) external returns (uint amountToken, uint amountETH);
212     function removeLiquidityWithPermit(
213         address tokenA,
214         address tokenB,
215         uint liquidity,
216         uint amountAMin,
217         uint amountBMin,
218         address to,
219         uint deadline,
220         bool approveMax, uint8 v, bytes32 r, bytes32 s
221     ) external returns (uint amountA, uint amountB);
222     function removeLiquidityETHWithPermit(
223         address token,
224         uint liquidity,
225         uint amountTokenMin,
226         uint amountETHMin,
227         address to,
228         uint deadline,
229         bool approveMax, uint8 v, bytes32 r, bytes32 s
230     ) external returns (uint amountToken, uint amountETH);
231     function swapExactTokensForTokens(
232         uint amountIn,
233         uint amountOutMin,
234         address[] calldata path,
235         address to,
236         uint deadline
237     ) external returns (uint[] memory amounts);
238     function swapTokensForExactTokens(
239         uint amountOut,
240         uint amountInMax,
241         address[] calldata path,
242         address to,
243         uint deadline
244     ) external returns (uint[] memory amounts);
245     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
246         external
247         payable
248         returns (uint[] memory amounts);
249     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
250         external
251         returns (uint[] memory amounts);
252     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
253         external
254         returns (uint[] memory amounts);
255     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
256         external
257         payable
258         returns (uint[] memory amounts);
259 
260     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
261     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
262     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
263     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
264     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
265 }
266 
267 interface IUniswapV2Router02 is IUniswapV2Router01 {
268     function swapExactTokensForETHSupportingFeeOnTransferTokens(
269         uint256 amountIn,
270         uint256 amountOutMin,
271         address[] calldata path,
272         address to,
273         uint256 deadline
274     ) external;
275     function swapExactETHForTokensSupportingFeeOnTransferTokens(
276         uint amountOutMin,
277         address[] calldata path,
278         address to,
279         uint deadline
280     ) external payable;
281     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
282         uint amountIn,
283         uint amountOutMin,
284         address[] calldata path,
285         address to,
286         uint deadline
287     ) external;
288     function factory() external pure returns (address);
289     function WETH() external pure returns (address);
290     function addLiquidityETH(
291         address token,
292         uint256 amountTokenDesired,
293         uint256 amountTokenMin,
294         uint256 amountETHMin,
295         address to,
296         uint256 deadline
297     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
298     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
299     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
300     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
301     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
302     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
303 }
304 
305 contract ShiaBurn is Context, IERC20, Ownable {
306     using SafeMath for uint256;
307     using Address for address;
308 
309     string private constant _name = "Shia Burn";
310     string private constant _symbol = "ShiaB";
311     uint8 private constant _decimals = 6;
312     mapping(address => uint256) private _balances;
313 
314     mapping(address => mapping(address => uint256)) private _allowances;
315     mapping(address => bool) private _isExcludedFromFee;
316     uint256 public _tTotal = 1000 * 1e3 * 1e6; //1,000,000
317 
318     uint256 public _maxWalletAmount = 20 * 1e3 * 1e6; //2%
319     uint256 public j_maxtxn = 20 * 1e3 * 1e6; //2%
320     uint256 public swapAmount = 7 * 1e2 * 1e6; //.07%
321     uint256 private buyShiaUpperLimit = 200 * 1e14; // 0.01
322 
323     // fees
324     uint256 public j_liqBuy = 1; 
325     uint256 public j_burnBuy = 1;
326     uint256 public j_shiaBuy = 3;
327     uint256 public j_jeetBuy = 0;
328 
329     uint256 public j_liqSell = 1; 
330     uint256 public j_burnSell = 1;
331     uint256 public j_shiaSell = 3;
332     uint256 public j_jeetSell = 10;
333  
334     uint256 private j_previousLiqFee = j_liqFee;
335     uint256 private j_previousBurnFee = j_burnFee;
336     uint256 private j_previousShiaFee = j_shiaFee;
337     uint256 private j_previousJeetTax = j_jeetTax;
338     
339     uint256 private j_liqFee;
340     uint256 private j_burnFee;
341     uint256 private j_shiaFee;
342     uint256 private j_jeetTax;
343 
344     uint256 public _totalBurned;
345 
346     struct FeeBreakdown {
347         uint256 tLiq;
348         uint256 tBurn;
349         uint256 tShia;
350         uint256 tJeet;
351         uint256 tAmount;
352     }
353 
354     mapping(address => bool) private bots;
355     address payable private shiaburnWallet = payable(0x57E9E4e39452323aAB3b226ed645297C5d98f887);
356     address payable public dead = payable(0x000000000000000000000000000000000000dEaD);
357     address SHIA = 0x43D7E65B8fF49698D9550a7F315c87E67344FB59;
358 
359     IUniswapV2Router02 public uniswapV2Router;
360     address public uniswapV2Pair;
361 
362     bool private swapping = false;
363     bool public burnMode = false;
364 
365     modifier lockSwap {
366         swapping = true;
367         _;
368         swapping = false;
369     }
370 
371     constructor() {
372         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
373         uniswapV2Router = _uniswapV2Router;
374         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
375         
376         _balances[_msgSender()] = _tTotal;
377         _isExcludedFromFee[owner()] = true;
378         _isExcludedFromFee[shiaburnWallet] = true;
379         _isExcludedFromFee[dead] = true;
380         _isExcludedFromFee[address(this)] = true;
381         emit Transfer(address(0), _msgSender(), _tTotal);
382     }
383 
384     function name() public pure returns (string memory) {
385         return _name;
386     }
387 
388     function symbol() public pure returns (string memory) {
389         return _symbol;
390     }
391 
392     function decimals() public pure returns (uint8) {
393         return _decimals;
394     }
395 
396     function totalSupply() public view override returns (uint256) {
397         return _tTotal;
398     }
399 
400     function balanceOf(address account) public view override returns (uint256) {
401         return _balances[account];
402     }
403     
404     function transfer(address recipient, uint256 amount) external override returns (bool) {
405         _transfer(_msgSender(), recipient, amount);
406         return true;
407     }
408 
409     function allowance(address owner, address spender) external view override returns (uint256) {
410         return _allowances[owner][spender];
411     }
412 
413     function approve(address spender, uint256 amount) external override returns (bool) {
414         _approve(_msgSender(), spender, amount);
415         return true;
416     }
417 
418     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
419         _transfer(sender, recipient, amount);
420         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
421         return true;
422     }
423 
424     function totalBurned() public view returns (uint256) {
425         return _totalBurned;
426     }
427 
428     function burning(address _account, uint _amount) private {  
429         require( _amount <= balanceOf(_account));
430         _balances[_account] = _balances[_account].sub(_amount);
431         _tTotal = _tTotal.sub(_amount);
432         _totalBurned = _totalBurned.add(_amount);
433         emit Transfer(_account, address(0), _amount);
434     }
435 
436     function removeAllFee() private {
437         if (j_burnFee == 0 && j_liqFee == 0 && j_shiaFee == 0 && j_jeetTax == 0) return;
438         j_previousBurnFee = j_burnFee;
439         j_previousLiqFee = j_liqFee;
440         j_previousShiaFee = j_shiaFee;
441         j_previousJeetTax = j_jeetTax;
442 
443         j_burnFee = 0;
444         j_liqFee = 0;
445         j_shiaFee = 0;
446         j_jeetTax = 0;
447     }
448     
449     function restoreAllFee() private {
450         j_liqFee = j_previousLiqFee;
451         j_burnFee = j_previousBurnFee;
452         j_shiaFee = j_previousShiaFee;
453         j_jeetTax = j_previousJeetTax;
454     }
455 
456     function removeJeetTax() external {
457         require(_msgSender() == shiaburnWallet);
458         j_jeetSell = 0;
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
483             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !bots[to] && !bots[from]) {
484                 j_liqFee = j_liqBuy;
485                 j_burnFee = j_burnBuy;
486                 j_shiaFee = j_shiaBuy;
487                 j_jeetTax = j_jeetBuy;
488             }
489                 
490             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !bots[to] && !bots[from]) {
491                 j_liqFee = j_liqSell;
492                 j_burnFee = j_burnSell;
493                 j_shiaFee = j_shiaSell;
494                 j_jeetTax = j_jeetSell;
495             }
496            
497             if (!swapping && from != uniswapV2Pair) {
498 
499                 uint256 contractTokenBalance = balanceOf(address(this));
500 
501                 if (contractTokenBalance > swapAmount) {
502                     swapAndLiquify(contractTokenBalance);
503                 }
504 
505                 uint256 contractETHBalance = address(this).balance;
506             
507                 if (!burnMode && (contractETHBalance > 0)) {
508                     sendETHToFee(address(this).balance);
509                 } else if (burnMode && (contractETHBalance > buyShiaUpperLimit)) {
510                         uint256 buyAmount = (contractETHBalance.div(2));
511                     buyShia(buyAmount);
512                 }                    
513             }
514         }
515 
516         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
517             takeFee = false;
518         }
519         
520         _transferAgain(from, to, amount, takeFee);
521         restoreAllFee();
522     }
523 
524     function setMaxTxn(uint256 maxTransaction) external {
525         require(maxTransaction >= 10 * 1e3 * 1e6,"negative ghost rider");
526         require(_msgSender() == shiaburnWallet);
527         j_maxtxn = maxTransaction;
528     }
529 
530     function swapTokensForEth(uint256 tokenAmount) private lockSwap {
531         address[] memory path = new address[](2);
532         path[0] = address(this);
533         path[1] = uniswapV2Router.WETH();
534         _approve(address(this), address(uniswapV2Router), tokenAmount);
535         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
536     }
537 
538     function swapETHForTokens(uint256 amount) private {
539         // generate the uniswap pair path of token -> weth
540         address[] memory path = new address[](2);
541         path[0] = uniswapV2Router.WETH();
542         path[1] = address(SHIA);
543 
544       // make the swap
545         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
546             0, // accept any amount of Tokens
547             path,
548             dead, // Burn address
549             block.timestamp
550         );        
551     }
552 
553     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
554         _approve(address(this), address(uniswapV2Router), tokenAmount);
555 
556         // add the liquidity
557         uniswapV2Router.addLiquidityETH{value: ethAmount}(
558             address(this),
559             tokenAmount,
560             0, // slippage is unavoidable
561             0, // slippage is unavoidable
562             shiaburnWallet,
563             block.timestamp
564           );
565     }
566   
567     function swapAndLiquify(uint256 contractTokenBalance) private lockSwap {
568         uint256 autoLPamount = j_liqFee.mul(contractTokenBalance).div(j_burnFee.add(j_shiaFee).add(j_jeetTax).add(j_liqFee));
569         uint256 half =  autoLPamount.div(2);
570         uint256 otherHalf = contractTokenBalance.sub(half);
571         uint256 initialBalance = address(this).balance;
572         swapTokensForEth(otherHalf);
573         uint256 newBalance = ((address(this).balance.sub(initialBalance)).mul(half)).div(otherHalf);
574         addLiquidity(half, newBalance);
575     }
576 
577     function sendETHToFee(uint256 amount) private {
578         shiaburnWallet.transfer(amount);
579     }
580 
581     function manualSwap() external {
582         require(_msgSender() == shiaburnWallet);
583         uint256 contractBalance = balanceOf(address(this));
584         if (contractBalance > 0) {
585             swapTokensForEth(contractBalance);
586         }
587     }
588 
589     function manualSend() external {
590         require(_msgSender() == shiaburnWallet);
591         uint256 contractETHBalance = address(this).balance;
592         if (contractETHBalance > 0) {
593             sendETHToFee(contractETHBalance);
594         }
595     }
596 
597     function _transferAgain(address sender, address recipient, uint256 amount, bool takeFee) private {
598         if (!takeFee) { 
599                 removeAllFee();
600         }
601         
602         FeeBreakdown memory fees;
603         fees.tBurn = amount.mul(j_burnFee).div(100);
604         fees.tLiq = amount.mul(j_liqFee).div(100);
605         fees.tShia = amount.mul(j_shiaFee).div(100);
606         fees.tJeet = amount.mul(j_jeetTax).div(100);
607         
608         fees.tAmount = amount.sub(fees.tShia).sub(fees.tJeet).sub(fees.tBurn).sub(fees.tLiq);
609 
610         uint256 amountPreBurn = amount.sub(fees.tBurn);
611         burning(sender, fees.tBurn);
612 
613         _balances[sender] = _balances[sender].sub(amountPreBurn);
614         _balances[recipient] = _balances[recipient].add(fees.tAmount);
615         _balances[address(this)] = _balances[address(this)].add(fees.tShia).add(fees.tJeet).add(fees.tBurn.add(fees.tLiq));
616         
617         if(burnMode && sender != uniswapV2Pair && sender != address(this) && sender != address(uniswapV2Router) && (recipient == address(uniswapV2Router) || recipient == uniswapV2Pair)) {
618             burning(uniswapV2Pair, fees.tBurn);
619         }
620 
621         emit Transfer(sender, recipient, fees.tAmount);
622         restoreAllFee();
623     }
624     
625     receive() external payable {}
626 
627     function setMaxWalletAmount(uint256 maxWalletAmount) external {
628         require(_msgSender() == shiaburnWallet);
629         require(maxWalletAmount > _tTotal.div(200), "Amount must be greater than 0.5% of supply");
630         _maxWalletAmount = maxWalletAmount;
631     }
632 
633     function setSwapAmount(uint256 _swapAmount) external {
634         require(_msgSender() == shiaburnWallet);
635         swapAmount = _swapAmount;
636     }
637 
638     function turnOnTheBurn() public onlyOwner {
639         burnMode = true;
640     }
641 
642     function buyShia(uint256 amount) private {
643     	if (amount > 0) {
644     	    swapETHForTokens(amount);
645 	    }
646     }
647 
648     function setBuyShiaRate(uint256 buyShiaToken) external {
649         require(_msgSender() == shiaburnWallet);
650         buyShiaUpperLimit = buyShiaToken;
651     }
652 
653 }