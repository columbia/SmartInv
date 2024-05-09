1 //$PUSUKE
2 //Website: https://pusuke.io
3 //WoofBoard: https://app.pusuke.io
4 //Telegram: https://t.me/pusukeETH
5 //Twitter: https://twitter.com/pusukeinutoken
6 
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
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40 
41 contract Ownable is Context {
42     address private _owner;
43     address private _previousOwner;
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     constructor() {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68     
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74     
75 }
76 
77 library SafeMath {
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81         return c;
82     }
83 
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     function sub(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95         return c;
96     }
97 
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104         return c;
105     }
106 
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     function div(
112         uint256 a,
113         uint256 b,
114         string memory errorMessage
115     ) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         return c;
119     }
120 }
121 
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB)
124         external
125         returns (address pair);
126 }
127 
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint256 amountIn,
131         uint256 amountOutMin,
132         address[] calldata path,
133         address to,
134         uint256 deadline
135     ) external;
136 
137     function factory() external pure returns (address);
138 
139     function WETH() external pure returns (address);
140 
141     function addLiquidityETH(
142         address token,
143         uint256 amountTokenDesired,
144         uint256 amountTokenMin,
145         uint256 amountETHMin,
146         address to,
147         uint256 deadline
148     )
149         external
150         payable
151         returns (
152             uint256 amountToken,
153             uint256 amountETH,
154             uint256 liquidity
155         );
156 }
157 
158 contract Pusuke is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
159     
160     using SafeMath for uint256;
161 
162     string private constant _name = "Pusuke Inu";//////////////////////////
163     string private constant _symbol = "PUSUKE";//////////////////////////////////////////////////////////////////////////
164     uint8 private constant _decimals = 9;
165 
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 10000000 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174     
175     //Buy Fee
176     uint256 private _redisFeeOnBuy = 1;
177     uint256 private _taxFeeOnBuy = 12;
178     
179     //Sell Fee
180     uint256 private _redisFeeOnSell = 1;
181     uint256 private _taxFeeOnSell = 14;
182     
183     //Original Fee
184     uint256 private _redisFee = _redisFeeOnSell;
185     uint256 private _taxFee = _taxFeeOnSell;
186     
187     uint256 private _previousredisFee = _redisFee;
188     uint256 private _previoustaxFee = _taxFee;
189     
190     mapping(address => bool) public bots;
191     mapping (address => bool) public preTrader;
192     mapping(address => uint256) private cooldown;
193     
194     address payable private _developmentAddress = payable(0x387d8dcfAD9bf2BA0ea91f514690FC125f66bcb4);/////////////////////////////////////////////////
195     address payable private _marketingAddress = payable(0xD20BAd253C4E297535a32e8003ba7FeBE3876C34);///////////////////////////////////////////////////
196     
197     IUniswapV2Router02 public uniswapV2Router;
198     address public uniswapV2Pair;
199     
200     bool private tradingOpen;
201     bool private inSwap = false;
202     bool private swapEnabled = true;
203     
204     uint256 public _maxTxAmount = 10000 * 10**9; //0.1%
205     uint256 public _maxWalletSize = 400000 * 10**9; //4%
206     uint256 public _swapTokensAtAmount = 10000 * 10**9; //0.1%
207 
208     event MaxTxAmountUpdated(uint256 _maxTxAmount);
209     modifier lockTheSwap {
210         inSwap = true;
211         _;
212         inSwap = false;
213     }
214 
215     constructor() {
216         
217         _rOwned[_msgSender()] = _rTotal;
218         
219         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x03f7724180AA6b939894B5Ca4314783B0b36b329);/////////////////////////////////////////////////
220         uniswapV2Router = _uniswapV2Router;
221         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
222             .createPair(address(this), _uniswapV2Router.WETH());
223 
224         _isExcludedFromFee[owner()] = true;
225         _isExcludedFromFee[address(this)] = true;
226         _isExcludedFromFee[_developmentAddress] = true;
227         _isExcludedFromFee[_marketingAddress] = true;
228         
229         preTrader[owner()] = true;
230         
231         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
232         
233         
234 
235         emit Transfer(address(0), _msgSender(), _tTotal);
236     }
237 
238     function name() public pure returns (string memory) {
239         return _name;
240     }
241 
242     function symbol() public pure returns (string memory) {
243         return _symbol;
244     }
245 
246     function decimals() public pure returns (uint8) {
247         return _decimals;
248     }
249 
250     function totalSupply() public pure override returns (uint256) {
251         return _tTotal;
252     }
253 
254     function balanceOf(address account) public view override returns (uint256) {
255         return tokenFromReflection(_rOwned[account]);
256     }
257 
258     function transfer(address recipient, uint256 amount)
259         public
260         override
261         returns (bool)
262     {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266 
267     function allowance(address owner, address spender)
268         public
269         view
270         override
271         returns (uint256)
272     {
273         return _allowances[owner][spender];
274     }
275 
276     function approve(address spender, uint256 amount)
277         public
278         override
279         returns (bool)
280     {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284 
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) public override returns (bool) {
290         _transfer(sender, recipient, amount);
291         _approve(
292             sender,
293             _msgSender(),
294             _allowances[sender][_msgSender()].sub(
295                 amount,
296                 "ERC20: transfer amount exceeds allowance"
297             )
298         );
299         return true;
300     }
301 
302     function tokenFromReflection(uint256 rAmount)
303         private
304         view
305         returns (uint256)
306     {
307         require(
308             rAmount <= _rTotal,
309             "Amount must be less than total reflections"
310         );
311         uint256 currentRate = _getRate();
312         return rAmount.div(currentRate);
313     }
314 
315     function removeAllFee() private {
316         if (_redisFee == 0 && _taxFee == 0) return;
317     
318         _previousredisFee = _redisFee;
319         _previoustaxFee = _taxFee;
320         
321         _redisFee = 0;
322         _taxFee = 0;
323     }
324 
325     function restoreAllFee() private {
326         _redisFee = _previousredisFee;
327         _taxFee = _previoustaxFee;
328     }
329 
330     function _approve(
331         address owner,
332         address spender,
333         uint256 amount
334     ) private {
335         require(owner != address(0), "ERC20: approve from the zero address");
336         require(spender != address(0), "ERC20: approve to the zero address");
337         _allowances[owner][spender] = amount;
338         emit Approval(owner, spender, amount);
339     }
340 
341     function _transfer(
342         address from,
343         address to,
344         uint256 amount
345     ) private {
346         require(from != address(0), "ERC20: transfer from the zero address");
347         require(to != address(0), "ERC20: transfer to the zero address");
348         require(amount > 0, "Transfer amount must be greater than zero");
349 
350         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
351             
352             //Trade start check
353             if (!tradingOpen) {
354                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
355             }
356               
357             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
358             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
359             
360             if(to != uniswapV2Pair) {
361                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
362             }
363             
364             uint256 contractTokenBalance = balanceOf(address(this));
365             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
366 
367             if(contractTokenBalance >= _maxTxAmount)
368             {
369                 contractTokenBalance = _maxTxAmount;
370             }
371             
372             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
373                 swapTokensForEth(contractTokenBalance);
374                 uint256 contractETHBalance = address(this).balance;
375                 if (contractETHBalance > 0) {
376                     sendETHToFee(address(this).balance);
377                 }
378             }
379         }
380         
381         bool takeFee = true;
382 
383         //Transfer Tokens
384         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
385             takeFee = false;
386         } else {
387             
388             //Set Fee for Buys
389             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
390                 _redisFee = _redisFeeOnBuy;
391                 _taxFee = _taxFeeOnBuy;
392             }
393     
394             //Set Fee for Sells
395             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
396                 _redisFee = _redisFeeOnSell;
397                 _taxFee = _taxFeeOnSell;
398             }
399             
400         }
401 
402         _tokenTransfer(from, to, amount, takeFee);
403     }
404 
405     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
406         address[] memory path = new address[](2);
407         path[0] = address(this);
408         path[1] = uniswapV2Router.WETH();
409         _approve(address(this), address(uniswapV2Router), tokenAmount);
410         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
411             tokenAmount,
412             0,
413             path,
414             address(this),
415             block.timestamp
416         );
417     }
418 
419     function sendETHToFee(uint256 amount) private {
420         _developmentAddress.transfer(amount.div(2));
421         _marketingAddress.transfer(amount.div(2));
422     }
423 
424     function setTrading(bool _tradingOpen) public onlyOwner {
425         tradingOpen = _tradingOpen;
426     }
427 
428     function manualswap() external {
429         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
430         uint256 contractBalance = balanceOf(address(this));
431         swapTokensForEth(contractBalance);
432     }
433 
434     function manualsend() external {
435         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
436         uint256 contractETHBalance = address(this).balance;
437         sendETHToFee(contractETHBalance);
438     }
439 
440     function blockBots(address[] memory bots_) public onlyOwner {
441         for (uint256 i = 0; i < bots_.length; i++) {
442             bots[bots_[i]] = true;
443         }
444     }
445 
446     function unblockBot(address notbot) public onlyOwner {
447         bots[notbot] = false;
448     }
449 
450     function _tokenTransfer(
451         address sender,
452         address recipient,
453         uint256 amount,
454         bool takeFee
455     ) private {
456         if (!takeFee) removeAllFee();
457         _transferStandard(sender, recipient, amount);
458         if (!takeFee) restoreAllFee();
459     }
460 
461     function _transferStandard(
462         address sender,
463         address recipient,
464         uint256 tAmount
465     ) private {
466         (
467             uint256 rAmount,
468             uint256 rTransferAmount,
469             uint256 rFee,
470             uint256 tTransferAmount,
471             uint256 tFee,
472             uint256 tTeam
473         ) = _getValues(tAmount);
474         _rOwned[sender] = _rOwned[sender].sub(rAmount);
475         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
476         _takeTeam(tTeam);
477         _reflectFee(rFee, tFee);
478         emit Transfer(sender, recipient, tTransferAmount);
479     }
480 
481     function _takeTeam(uint256 tTeam) private {
482         uint256 currentRate = _getRate();
483         uint256 rTeam = tTeam.mul(currentRate);
484         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
485     }
486 
487     function _reflectFee(uint256 rFee, uint256 tFee) private {
488         _rTotal = _rTotal.sub(rFee);
489         _tFeeTotal = _tFeeTotal.add(tFee);
490     }
491 
492     receive() external payable {}
493 
494     function _getValues(uint256 tAmount)
495         private
496         view
497         returns (
498             uint256,
499             uint256,
500             uint256,
501             uint256,
502             uint256,
503             uint256
504         )
505     {
506         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
507             _getTValues(tAmount, _redisFee, _taxFee);
508         uint256 currentRate = _getRate();
509         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
510             _getRValues(tAmount, tFee, tTeam, currentRate);
511         
512         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
513     }
514 
515     function _getTValues(
516         uint256 tAmount,
517         uint256 redisFee,
518         uint256 taxFee
519     )
520         private
521         pure
522         returns (
523             uint256,
524             uint256,
525             uint256
526         )
527     {
528         uint256 tFee = tAmount.mul(redisFee).div(100);
529         uint256 tTeam = tAmount.mul(taxFee).div(100);
530         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
531 
532         return (tTransferAmount, tFee, tTeam);
533     }
534 
535     function _getRValues(
536         uint256 tAmount,
537         uint256 tFee,
538         uint256 tTeam,
539         uint256 currentRate
540     )
541         private
542         pure
543         returns (
544             uint256,
545             uint256,
546             uint256
547         )
548     {
549         uint256 rAmount = tAmount.mul(currentRate);
550         uint256 rFee = tFee.mul(currentRate);
551         uint256 rTeam = tTeam.mul(currentRate);
552         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
553 
554         return (rAmount, rTransferAmount, rFee);
555     }
556 
557     function _getRate() private view returns (uint256) {
558         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
559 
560         return rSupply.div(tSupply);
561     }
562 
563     function _getCurrentSupply() private view returns (uint256, uint256) {
564         uint256 rSupply = _rTotal;
565         uint256 tSupply = _tTotal;
566         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
567     
568         return (rSupply, tSupply);
569     }
570     
571     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
572         _redisFeeOnBuy = redisFeeOnBuy;
573         _redisFeeOnSell = redisFeeOnSell;
574         
575         _taxFeeOnBuy = taxFeeOnBuy;
576         _taxFeeOnSell = taxFeeOnSell;
577     }
578 
579     //Set minimum tokens required to swap.
580     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
581         _swapTokensAtAmount = swapTokensAtAmount;
582     }
583     
584     //Set minimum tokens required to swap.
585     function toggleSwap(bool _swapEnabled) public onlyOwner {
586         swapEnabled = _swapEnabled;
587     }
588     
589     
590     //Set MAx transaction
591     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
592         _maxTxAmount = maxTxAmount;
593     }
594     
595     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
596         _maxWalletSize = maxWalletSize;
597     }
598 
599     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
600         for(uint256 i = 0; i < accounts.length; i++) {
601             _isExcludedFromFee[accounts[i]] = excluded;
602         }
603     }
604  
605     function allowPreTrading(address account, bool allowed) public onlyOwner {
606         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
607         preTrader[account] = allowed;
608     }
609 }