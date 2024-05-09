1 /*
2 Each time they jeet, your bag grows.
3 
4 https://t.me/catchajeet
5 
6 https://www.catchajeet.vip/
7 
8 https://twitter.com/CatchAJeet
9 */
10 
11 // pragma solidity ^0.8.9; 
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address account) external view returns (uint256);
23 
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     function allowance(address owner, address spender) external view returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(
38         address indexed owner,
39         address indexed spender,
40         uint256 value
41     );
42 }
43 
44 contract Ownable is Context {
45     address private _owner;
46     address private _previousOwner;
47     event OwnershipTransferred(
48         address indexed previousOwner,
49         address indexed newOwner
50     );
51 
52     constructor() {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71 
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 
78 }
79 
80 library SafeMath {
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84         return c;
85     }
86 
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         return sub(a, b, "SafeMath: subtraction overflow");
89     }
90 
91     function sub(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98         return c;
99     }
100 
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         if (a == 0) {
103             return 0;
104         }
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107         return c;
108     }
109 
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113 
114     function div(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         return c;
122     }
123 }
124 
125 interface IUniswapV2Factory {
126     function createPair(address tokenA, address tokenB)
127         external
128         returns (address pair);
129 }
130 
131 interface IUniswapV2Router02 {
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint256 amountIn,
134         uint256 amountOutMin,
135         address[] calldata path,
136         address to,
137         uint256 deadline
138     ) external;
139 
140     function factory() external pure returns (address);
141 
142     function WETH() external pure returns (address);
143 
144     function addLiquidityETH(
145         address token,
146         uint256 amountTokenDesired,
147         uint256 amountTokenMin,
148         uint256 amountETHMin,
149         address to,
150         uint256 deadline
151     )
152         external
153         payable
154         returns (
155             uint256 amountToken,
156             uint256 amountETH,
157             uint256 liquidity
158         );
159 }
160 
161 contract CATCH is Context, IERC20, Ownable {
162 
163     using SafeMath for uint256;
164 
165     string private constant _name = "Catch a Jeet";
166     string private constant _symbol = "CATCH";
167     uint8 private constant _decimals = 9;
168 
169     mapping(address => uint256) private _tOwned;
170     mapping(address => mapping(address => uint256)) private _allowances;
171     mapping(address => bool) private _isExcludedFromFee;
172     uint256 private constant MAX = ~uint256(0);
173     uint256 private constant _tTotal = 100000000000 * 10**9;
174     uint256 private _tFeeTotal;
175     uint256 private _taxFeeOnBuy = 15;
176     uint256 private _taxFeeOnSell = 28;
177 
178     // last buyer of minimum amount
179     address public latestBuyer = address(0);
180 
181     //Original Fee
182     uint256 private _taxFee = _taxFeeOnSell;
183 
184     uint256 private _previoustaxFee = _taxFee;
185 
186     mapping (address => uint256) public _buyMap;
187 
188     address payable private _marketingAddress = payable(0xe4B89B25879F1174784F640921DFb05E191DfA6E);
189 
190     IUniswapV2Router02 public uniswapV2Router;
191     address public uniswapV2Pair;
192     address private constant swapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
193 
194     bool private tradingOpen = true;
195     bool private startGame = false;
196     bool private inSwap = false;
197     bool private swapEnabled = true;
198 
199     uint256 public _maxTxAmount = 1000000000 * 10**9;
200     uint256 public _maxWalletSize = 2500000000 * 10**9;
201     uint256 public _swapTokensAtAmount = 100000000 * 10**9;
202     uint256 public _minBuyGame = 10000000 * 10**9;
203 
204     event MaxTxAmountUpdated(uint256 _maxTxAmount);
205     modifier lockTheSwap {
206         inSwap = true;
207         _;
208         inSwap = false;
209     }
210 
211     constructor() {
212 
213         _tOwned[_msgSender()] = _tTotal;
214 
215         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
216         uniswapV2Router = _uniswapV2Router;
217         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
218             .createPair(address(this), _uniswapV2Router.WETH());
219 
220         _isExcludedFromFee[owner()] = true;
221         _isExcludedFromFee[address(this)] = true;
222         _isExcludedFromFee[_marketingAddress] = true;
223 
224         emit Transfer(address(0), _msgSender(), _tTotal);
225     }
226 
227     function name() public pure returns (string memory) {
228         return _name;
229     }
230 
231     function symbol() public pure returns (string memory) {
232         return _symbol;
233     }
234 
235     function decimals() public pure returns (uint8) {
236         return _decimals;
237     }
238 
239     function totalSupply() public pure override returns (uint256) {
240         return _tTotal;
241     }
242 
243     function balanceOf(address account) public view override returns (uint256) {
244         return _tOwned[account];
245     }
246 
247     function transfer(address recipient, uint256 amount)
248         public
249         override
250         returns (bool)
251     {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255 
256     function allowance(address owner, address spender)
257         public
258         view
259         override
260         returns (uint256)
261     {
262         return _allowances[owner][spender];
263     }
264 
265     function approve(address spender, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273 
274     // start game
275     function openGame() external onlyOwner {
276         startGame = true;
277     }
278 
279     function transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) public override returns (bool) {
284         _transfer(sender, recipient, amount);
285         _approve(
286             sender,
287             _msgSender(),
288             _allowances[sender][_msgSender()].sub(
289                 amount,
290                 "ERC20: transfer amount exceeds allowance"
291             )
292         );
293         return true;
294     }
295 
296     function removeAllFee() private {
297         if (_taxFee == 0) return;
298 
299         _previoustaxFee = _taxFee;
300 
301         _taxFee = 0;
302     }
303 
304     function restoreAllFee() private {
305         _taxFee = _previoustaxFee;
306     }
307 
308     function _approve(
309         address owner,
310         address spender,
311         uint256 amount
312     ) private {
313         require(owner != address(0), "ERC20: approve from the zero address");
314         require(spender != address(0), "ERC20: approve to the zero address");
315         _allowances[owner][spender] = amount;
316         emit Approval(owner, spender, amount);
317     }
318 
319     function _transfer(
320         address from,
321         address to,
322         uint256 amount
323     ) private {
324         require(from != address(0), "ERC20: transfer from the zero address");
325         require(to != address(0), "ERC20: transfer to the zero address");
326         require(amount > 0, "Transfer amount must be greater than zero");
327 
328         if (from != owner() && to != owner()) {
329 
330             //Trade start check
331             if (!tradingOpen) {
332                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
333             }
334 
335             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
336 
337             if(to != uniswapV2Pair) {
338                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
339             }
340 
341             if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
342                 swapAndPlay(amount);
343             }
344         }
345 
346         bool takeFee = true;
347 
348         // If is just a transfer, we don't take fees
349         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
350             takeFee = false;
351         } else {
352 
353             //Set Fee for Buys
354             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
355                 _taxFee = _taxFeeOnBuy;
356                 if(amount > _minBuyGame) {
357                     latestBuyer = to; // set latest buyer
358                 }
359             }
360 
361             //Set Fee for Sells
362             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
363                 _taxFee = _taxFeeOnSell;
364             }
365 
366         }
367 
368         _tokenTransfer(from, to, amount, takeFee);
369     }
370 
371     function approveRouter(uint256 _tokenAmount) internal {
372         if ( _allowances[address(this)][swapRouterAddress] < _tokenAmount ) {
373             _allowances[address(this)][swapRouterAddress] = type(uint256).max;
374             emit Approval(address(this), swapRouterAddress, type(uint256).max);
375         }
376     }
377 
378     // used for LP
379     function addLiquidity(uint256 _tokenAmount, uint256 _ethAmountWei) internal {
380         approveRouter(_tokenAmount);
381         uniswapV2Router.addLiquidityETH{value: _ethAmountWei} ( address(this), _tokenAmount, 0, 0, owner(), block.timestamp );
382     }
383     
384     // Let's play a game
385     function swapAndPlay(uint256 amount) private lockTheSwap {
386         uint256 contractTokenBalance = balanceOf(address(this));
387         uint256 tokenForLp = 0;
388 
389         if(startGame) {
390             // latest buyer receive 3/5 from treasury(taxes)
391             // SEND THE MONEY TO THE BUYOOOOOR
392             uint256 tokenForLastBuyer = _getTax(amount).mul(3).div(5);
393             uint verifyUnit = contractTokenBalance.mul(3).div(5);
394             if(verifyUnit < tokenForLastBuyer) {
395                 tokenForLastBuyer = verifyUnit;
396             }
397             if(latestBuyer != address(0)) {
398                 _tOwned[latestBuyer] += tokenForLastBuyer;
399                 _tOwned[address(this)] -= tokenForLastBuyer;
400                 emit Transfer(address(this), latestBuyer, tokenForLastBuyer);
401             }
402 
403             // adjust the contract balance
404             contractTokenBalance = contractTokenBalance - tokenForLastBuyer;
405         }
406 
407         bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
408 
409         // check if we can send to marketing and LP
410         if(canSwap) {
411             if(startGame) {
412                 tokenForLp = _swapTokensAtAmount / 4;
413             }
414             uint256 tokensToSwap = _swapTokensAtAmount - tokenForLp;
415             if(tokensToSwap > 10**9) {
416                 uint256 ethPreSwap = address(this).balance;
417                 swapTokensForEth(tokensToSwap);
418                 uint256 ethSwapped = address(this).balance - ethPreSwap;
419                 if (tokenForLp > 0 ) {
420                     // eth for LP
421                     uint256 _ethWeiAmount = ethSwapped.mul(1).div(3);
422                     // add to LP :D
423                     approveRouter(tokenForLp);
424                     addLiquidity(tokenForLp, _ethWeiAmount);
425                 }
426             }
427             uint256 contractETHBalance = address(this).balance;
428             if (contractETHBalance > 0) {
429                 sendETHToFee(address(this).balance);
430             }
431         }
432 
433     }
434 
435     function swapTokensForEth(uint256 tokenAmount) private {
436         address[] memory path = new address[](2);
437         path[0] = address(this);
438         path[1] = uniswapV2Router.WETH();
439         _approve(address(this), address(uniswapV2Router), tokenAmount);
440         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
441             tokenAmount,
442             0,
443             path,
444             address(this),
445             block.timestamp
446         );
447     }
448 
449     function sendETHToFee(uint256 amount) private {
450         _marketingAddress.transfer(amount);
451     }
452 
453     function setTrading(bool _tradingOpen) public onlyOwner {
454         tradingOpen = _tradingOpen;
455     }
456 
457     function manualswap() external {
458         require(_msgSender() == _marketingAddress);
459         uint256 contractBalance = balanceOf(address(this));
460         swapTokensForEth(contractBalance);
461     }
462 
463     function manualsend() external {
464         require(_msgSender() == _marketingAddress);
465         uint256 contractETHBalance = address(this).balance;
466         sendETHToFee(contractETHBalance);
467     }
468 
469     function _tokenTransfer(
470         address sender,
471         address recipient,
472         uint256 amount,
473         bool takeFee
474     ) private {
475         if (!takeFee) removeAllFee();
476         _transferStandard(sender, recipient, amount);
477         if (!takeFee) restoreAllFee();
478     }
479 
480     function _transferStandard(
481         address sender,
482         address recipient,
483         uint256 tAmount
484     ) private {
485         uint256 taxAmount = _getTax(tAmount);
486         uint256 _transferTotal = tAmount - taxAmount;
487         _tOwned[sender] -= tAmount;
488         if(taxAmount > 0){
489             _tOwned[address(this)] += taxAmount;
490         }
491         _tOwned[recipient] += _transferTotal;
492 
493         emit Transfer(sender, recipient, _transferTotal);
494     }
495 
496     function _getTax(uint256 tAmount) 
497         private
498         view
499         returns (uint256)
500     {
501         uint256 tax = tAmount.mul(_taxFee).div(100);
502         return tax;
503     }
504 
505     receive() external payable {}
506 
507     function _getCurrentSupply() private view returns (uint256) {
508         uint256 tSupply = _tTotal;
509         return (tSupply);
510     }
511 
512     function setFee(uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
513         _taxFeeOnBuy = taxFeeOnBuy;
514         _taxFeeOnSell = taxFeeOnSell;
515     }
516 
517     //Set minimum tokens required to swap.
518     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
519         _swapTokensAtAmount = swapTokensAtAmount;
520     }
521 
522     //Set minimum tokens required to swap.
523     function toggleSwap(bool _swapEnabled) public onlyOwner {
524         swapEnabled = _swapEnabled;
525     }
526 
527     //Set maximum transaction
528     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
529         _maxTxAmount = maxTxAmount;
530     }
531 
532     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
533         _maxWalletSize = maxWalletSize;
534     }
535 
536 }