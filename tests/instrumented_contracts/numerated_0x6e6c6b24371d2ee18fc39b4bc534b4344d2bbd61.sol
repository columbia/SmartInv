1 //
2 //Telegram: https://t.me/ethshinjutsu
3 //Website: https://www.shinjutsu.com/
4 //
5  /*________  ___  ___  ___  ________         ___  ___  ___  _________  ________  ___  ___     
6 |\   ____\|\  \|\  \|\  \|\   ___  \      |\  \|\  \|\  \|\___   ___\\   ____\|\  \|\  \    
7 \ \  \___|\ \  \\\  \ \  \ \  \\ \  \     \ \  \ \  \\\  \|___ \  \_\ \  \___|\ \  \\\  \   
8  \ \_____  \ \   __  \ \  \ \  \\ \  \  __ \ \  \ \  \\\  \   \ \  \ \ \_____  \ \  \\\  \  
9   \|____|\  \ \  \ \  \ \  \ \  \\ \  \|\  \\_\  \ \  \\\  \   \ \  \ \|____|\  \ \  \\\  \ 
10     ____\_\  \ \__\ \__\ \__\ \__\\ \__\ \________\ \_______\   \ \__\  ____\_\  \ \_______\
11    |\_________\|__|\|__|\|__|\|__| \|__|\|________|\|_______|    \|__| |\_________\|_______|
12    \|_________|                                                        \|_________|         
13 */
14                                                                                             
15 pragma solidity ^0.8.4;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address account) external view returns (uint256);
27 
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 contract Ownable is Context {
49     address private _owner;
50     address private _previousOwner;
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     constructor() {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     function renounceOwnership() public virtual onlyOwner {
72         emit OwnershipTransferred(_owner, address(0));
73         _owner = address(0);
74     }
75     
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81     
82 }
83 
84 library SafeMath {
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90 
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         return sub(a, b, "SafeMath: subtraction overflow");
93     }
94 
95     function sub(
96         uint256 a,
97         uint256 b,
98         string memory errorMessage
99     ) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102         return c;
103     }
104 
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) {
107             return 0;
108         }
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111         return c;
112     }
113 
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     function div(
119         uint256 a,
120         uint256 b,
121         string memory errorMessage
122     ) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         return c;
126     }
127 }
128 
129 interface IUniswapV2Factory {
130     function createPair(address tokenA, address tokenB)
131         external
132         returns (address pair);
133 }
134 
135 interface IUniswapV2Router02 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint256 amountIn,
138         uint256 amountOutMin,
139         address[] calldata path,
140         address to,
141         uint256 deadline
142     ) external;
143 
144     function factory() external pure returns (address);
145 
146     function WETH() external pure returns (address);
147 
148     function addLiquidityETH(
149         address token,
150         uint256 amountTokenDesired,
151         uint256 amountTokenMin,
152         uint256 amountETHMin,
153         address to,
154         uint256 deadline
155     )
156         external
157         payable
158         returns (
159             uint256 amountToken,
160             uint256 amountETH,
161             uint256 liquidity
162         );
163 }
164 
165 contract ShinJutsu is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
166     
167     using SafeMath for uint256;
168 
169     string private constant _name = "Shinjutsu";//////////////////////////
170     string private constant _symbol = "SHINJUTSU";//////////////////////////////////////////////////////////////////////////
171     uint8 private constant _decimals = 9;
172 
173     mapping(address => uint256) private _rOwned;
174     mapping(address => uint256) private _tOwned;
175     mapping(address => mapping(address => uint256)) private _allowances;
176     mapping(address => bool) private _isExcludedFromFee;
177     uint256 private constant MAX = ~uint256(0);
178     uint256 private constant _tTotal = 10000000 * 10**9;
179     uint256 private _rTotal = (MAX - (MAX % _tTotal));
180     uint256 private _tFeeTotal;
181     
182     //Buy Fee
183     uint256 private _redisFeeOnBuy = 2;////////////////////////////////////////////////////////////////////
184     uint256 private _taxFeeOnBuy = 8;//////////////////////////////////////////////////////////////////////
185     
186     //Sell Fee
187     uint256 private _redisFeeOnSell = 2;/////////////////////////////////////////////////////////////////////
188     uint256 private _taxFeeOnSell = 8;/////////////////////////////////////////////////////////////////////
189     
190     //Original Fee
191     uint256 private _redisFee = _redisFeeOnSell;
192     uint256 private _taxFee = _taxFeeOnSell;
193     
194     uint256 private _previousredisFee = _redisFee;
195     uint256 private _previoustaxFee = _taxFee;
196     
197     mapping(address => bool) public bots;
198     mapping (address => bool) public preTrader;
199     mapping(address => uint256) private cooldown;
200     
201     address payable private _developmentAddress = payable(0x88FCcbF88B04Fbed51fA5B175E509c4707D5a8B5);/////////////////////////////////////////////////
202     address payable private _marketingAddress = payable(0x4db0DAa7faE158d37716790F726cC52935899006);///////////////////////////////////////////////////
203     
204     IUniswapV2Router02 public uniswapV2Router;
205     address public uniswapV2Pair;
206     
207     bool private tradingOpen;
208     bool private inSwap = false;
209     bool private swapEnabled = true;
210     
211     uint256 public _maxTxAmount = 10000 * 10**9; //0.1%
212     uint256 public _maxWalletSize = 400000 * 10**9; //4%
213     uint256 public _swapTokensAtAmount = 10000 * 10**9; //0.1%
214 
215     event MaxTxAmountUpdated(uint256 _maxTxAmount);
216     modifier lockTheSwap {
217         inSwap = true;
218         _;
219         inSwap = false;
220     }
221 
222     constructor() {
223         
224         _rOwned[_msgSender()] = _rTotal;
225         
226         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
227         uniswapV2Router = _uniswapV2Router;
228         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
229             .createPair(address(this), _uniswapV2Router.WETH());
230 
231         _isExcludedFromFee[owner()] = true;
232         _isExcludedFromFee[address(this)] = true;
233         _isExcludedFromFee[_developmentAddress] = true;
234         _isExcludedFromFee[_marketingAddress] = true;
235         
236         preTrader[owner()] = true;
237         
238         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
239         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
240         
241 
242         emit Transfer(address(0), _msgSender(), _tTotal);
243     }
244 
245     function name() public pure returns (string memory) {
246         return _name;
247     }
248 
249     function symbol() public pure returns (string memory) {
250         return _symbol;
251     }
252 
253     function decimals() public pure returns (uint8) {
254         return _decimals;
255     }
256 
257     function totalSupply() public pure override returns (uint256) {
258         return _tTotal;
259     }
260 
261     function balanceOf(address account) public view override returns (uint256) {
262         return tokenFromReflection(_rOwned[account]);
263     }
264 
265     function transfer(address recipient, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _transfer(_msgSender(), recipient, amount);
271         return true;
272     }
273 
274     function allowance(address owner, address spender)
275         public
276         view
277         override
278         returns (uint256)
279     {
280         return _allowances[owner][spender];
281     }
282 
283     function approve(address spender, uint256 amount)
284         public
285         override
286         returns (bool)
287     {
288         _approve(_msgSender(), spender, amount);
289         return true;
290     }
291 
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public override returns (bool) {
297         _transfer(sender, recipient, amount);
298         _approve(
299             sender,
300             _msgSender(),
301             _allowances[sender][_msgSender()].sub(
302                 amount,
303                 "ERC20: transfer amount exceeds allowance"
304             )
305         );
306         return true;
307     }
308 
309     function tokenFromReflection(uint256 rAmount)
310         private
311         view
312         returns (uint256)
313     {
314         require(
315             rAmount <= _rTotal,
316             "Amount must be less than total reflections"
317         );
318         uint256 currentRate = _getRate();
319         return rAmount.div(currentRate);
320     }
321 
322     function removeAllFee() private {
323         if (_redisFee == 0 && _taxFee == 0) return;
324     
325         _previousredisFee = _redisFee;
326         _previoustaxFee = _taxFee;
327         
328         _redisFee = 0;
329         _taxFee = 0;
330     }
331 
332     function restoreAllFee() private {
333         _redisFee = _previousredisFee;
334         _taxFee = _previoustaxFee;
335     }
336 
337     function _approve(
338         address owner,
339         address spender,
340         uint256 amount
341     ) private {
342         require(owner != address(0), "ERC20: approve from the zero address");
343         require(spender != address(0), "ERC20: approve to the zero address");
344         _allowances[owner][spender] = amount;
345         emit Approval(owner, spender, amount);
346     }
347 
348     function _transfer(
349         address from,
350         address to,
351         uint256 amount
352     ) private {
353         require(from != address(0), "ERC20: transfer from the zero address");
354         require(to != address(0), "ERC20: transfer to the zero address");
355         require(amount > 0, "Transfer amount must be greater than zero");
356 
357         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
358             
359             //Trade start check
360             if (!tradingOpen) {
361                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
362             }
363               
364             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
365             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
366             
367             if(to != uniswapV2Pair) {
368                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
369             }
370             
371             uint256 contractTokenBalance = balanceOf(address(this));
372             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
373 
374             if(contractTokenBalance >= _maxTxAmount)
375             {
376                 contractTokenBalance = _maxTxAmount;
377             }
378             
379             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
380                 swapTokensForEth(contractTokenBalance);
381                 uint256 contractETHBalance = address(this).balance;
382                 if (contractETHBalance > 0) {
383                     sendETHToFee(address(this).balance);
384                 }
385             }
386         }
387         
388         bool takeFee = true;
389 
390         //Transfer Tokens
391         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
392             takeFee = false;
393         } else {
394             
395             //Set Fee for Buys
396             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
397                 _redisFee = _redisFeeOnBuy;
398                 _taxFee = _taxFeeOnBuy;
399             }
400     
401             //Set Fee for Sells
402             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
403                 _redisFee = _redisFeeOnSell;
404                 _taxFee = _taxFeeOnSell;
405             }
406             
407         }
408 
409         _tokenTransfer(from, to, amount, takeFee);
410     }
411 
412     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
413         address[] memory path = new address[](2);
414         path[0] = address(this);
415         path[1] = uniswapV2Router.WETH();
416         _approve(address(this), address(uniswapV2Router), tokenAmount);
417         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
418             tokenAmount,
419             0,
420             path,
421             address(this),
422             block.timestamp
423         );
424     }
425 
426     function sendETHToFee(uint256 amount) private {
427         _developmentAddress.transfer(amount.div(2));
428         _marketingAddress.transfer(amount.div(2));
429     }
430 
431     function setTrading(bool _tradingOpen) public onlyOwner {
432         tradingOpen = _tradingOpen;
433     }
434 
435     function manualswap() external {
436         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
437         uint256 contractBalance = balanceOf(address(this));
438         swapTokensForEth(contractBalance);
439     }
440 
441     function manualsend() external {
442         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
443         uint256 contractETHBalance = address(this).balance;
444         sendETHToFee(contractETHBalance);
445     }
446 
447     function blockBots(address[] memory bots_) public onlyOwner {
448         for (uint256 i = 0; i < bots_.length; i++) {
449             bots[bots_[i]] = true;
450         }
451     }
452 
453     function unblockBot(address notbot) public onlyOwner {
454         bots[notbot] = false;
455     }
456 
457     function _tokenTransfer(
458         address sender,
459         address recipient,
460         uint256 amount,
461         bool takeFee
462     ) private {
463         if (!takeFee) removeAllFee();
464         _transferStandard(sender, recipient, amount);
465         if (!takeFee) restoreAllFee();
466     }
467 
468     function _transferStandard(
469         address sender,
470         address recipient,
471         uint256 tAmount
472     ) private {
473         (
474             uint256 rAmount,
475             uint256 rTransferAmount,
476             uint256 rFee,
477             uint256 tTransferAmount,
478             uint256 tFee,
479             uint256 tTeam
480         ) = _getValues(tAmount);
481         _rOwned[sender] = _rOwned[sender].sub(rAmount);
482         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
483         _takeTeam(tTeam);
484         _reflectFee(rFee, tFee);
485         emit Transfer(sender, recipient, tTransferAmount);
486     }
487 
488     function _takeTeam(uint256 tTeam) private {
489         uint256 currentRate = _getRate();
490         uint256 rTeam = tTeam.mul(currentRate);
491         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
492     }
493 
494     function _reflectFee(uint256 rFee, uint256 tFee) private {
495         _rTotal = _rTotal.sub(rFee);
496         _tFeeTotal = _tFeeTotal.add(tFee);
497     }
498 
499     receive() external payable {}
500 
501     function _getValues(uint256 tAmount)
502         private
503         view
504         returns (
505             uint256,
506             uint256,
507             uint256,
508             uint256,
509             uint256,
510             uint256
511         )
512     {
513         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
514             _getTValues(tAmount, _redisFee, _taxFee);
515         uint256 currentRate = _getRate();
516         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
517             _getRValues(tAmount, tFee, tTeam, currentRate);
518         
519         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
520     }
521 
522     function _getTValues(
523         uint256 tAmount,
524         uint256 redisFee,
525         uint256 taxFee
526     )
527         private
528         pure
529         returns (
530             uint256,
531             uint256,
532             uint256
533         )
534     {
535         uint256 tFee = tAmount.mul(redisFee).div(100);
536         uint256 tTeam = tAmount.mul(taxFee).div(100);
537         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
538 
539         return (tTransferAmount, tFee, tTeam);
540     }
541 
542     function _getRValues(
543         uint256 tAmount,
544         uint256 tFee,
545         uint256 tTeam,
546         uint256 currentRate
547     )
548         private
549         pure
550         returns (
551             uint256,
552             uint256,
553             uint256
554         )
555     {
556         uint256 rAmount = tAmount.mul(currentRate);
557         uint256 rFee = tFee.mul(currentRate);
558         uint256 rTeam = tTeam.mul(currentRate);
559         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
560 
561         return (rAmount, rTransferAmount, rFee);
562     }
563 
564     function _getRate() private view returns (uint256) {
565         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
566 
567         return rSupply.div(tSupply);
568     }
569 
570     function _getCurrentSupply() private view returns (uint256, uint256) {
571         uint256 rSupply = _rTotal;
572         uint256 tSupply = _tTotal;
573         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
574     
575         return (rSupply, tSupply);
576     }
577     
578     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
579         _redisFeeOnBuy = redisFeeOnBuy;
580         _redisFeeOnSell = redisFeeOnSell;
581         
582         _taxFeeOnBuy = taxFeeOnBuy;
583         _taxFeeOnSell = taxFeeOnSell;
584     }
585 
586     //Set minimum tokens required to swap.
587     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
588         _swapTokensAtAmount = swapTokensAtAmount;
589     }
590     
591     //Set minimum tokens required to swap.
592     function toggleSwap(bool _swapEnabled) public onlyOwner {
593         swapEnabled = _swapEnabled;
594     }
595     
596     
597     //Set MAx transaction
598     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
599         _maxTxAmount = maxTxAmount;
600     }
601     
602     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
603         _maxWalletSize = maxWalletSize;
604     }
605 
606     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
607         for(uint256 i = 0; i < accounts.length; i++) {
608             _isExcludedFromFee[accounts[i]] = excluded;
609         }
610     }
611  
612     function allowPreTrading(address account, bool allowed) public onlyOwner {
613         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
614         preTrader[account] = allowed;
615     }
616 }