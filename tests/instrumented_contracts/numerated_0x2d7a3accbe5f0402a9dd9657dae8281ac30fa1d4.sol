1 /**
2 From the shadows, a master of stealth and sabotage emerges, unleashing a feline frenzy upon any challenger that dares stand in its way. In a world of generic mutts, Kitty Ninja reigns supreme!
3 
4 https://kittyninja.io
5 https://t.me/kinja_eth
6 https://twitter.com/kinja_eth
7 
8 */
9 
10 
11 
12 pragma solidity ^0.8.4;
13  
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19  
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22  
23     function balanceOf(address account) external view returns (uint256);
24  
25     function transfer(address recipient, uint256 amount) external returns (bool);
26  
27     function allowance(address owner, address spender) external view returns (uint256);
28  
29     function approve(address spender, uint256 amount) external returns (bool);
30  
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36  
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44  
45 contract Ownable is Context {
46     address private _owner;
47     address private _previousOwner;
48     event OwnershipTransferred(
49         address indexed previousOwner,
50         address indexed newOwner
51     );
52  
53     constructor() {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58  
59     function owner() public view returns (address) {
60         return _owner;
61     }
62  
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67  
68     function renounceOwnership() public virtual onlyOwner {
69         emit OwnershipTransferred(_owner, address(0));
70         _owner = address(0);
71     }
72  
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78  
79 }
80  
81 library SafeMath {
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a, "SafeMath: addition overflow");
85         return c;
86     }
87  
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         return sub(a, b, "SafeMath: subtraction overflow");
90     }
91  
92     function sub(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99         return c;
100     }
101  
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         if (a == 0) {
104             return 0;
105         }
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108         return c;
109     }
110  
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114  
115     function div(
116         uint256 a,
117         uint256 b,
118         string memory errorMessage
119     ) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         return c;
123     }
124 }
125  
126 interface IUniswapV2Factory {
127     function createPair(address tokenA, address tokenB)
128         external
129         returns (address pair);
130 }
131  
132 interface IUniswapV2Router02 {
133     function swapExactTokensForETHSupportingFeeOnTransferTokens(
134         uint256 amountIn,
135         uint256 amountOutMin,
136         address[] calldata path,
137         address to,
138         uint256 deadline
139     ) external;
140  
141     function factory() external pure returns (address);
142  
143     function WETH() external pure returns (address);
144  
145     function addLiquidityETH(
146         address token,
147         uint256 amountTokenDesired,
148         uint256 amountTokenMin,
149         uint256 amountETHMin,
150         address to,
151         uint256 deadline
152     )
153         external
154         payable
155         returns (
156             uint256 amountToken,
157             uint256 amountETH,
158             uint256 liquidity
159         );
160 }
161  
162 contract KittyNinja is Context, IERC20, Ownable {
163  
164     using SafeMath for uint256;
165  
166     string private constant _name = "KittyNinja";//
167     string private constant _symbol = "KINJA";//
168     uint8 private constant _decimals = 9;
169  
170     mapping(address => uint256) private _rOwned;
171     mapping(address => uint256) private _tOwned;
172     mapping(address => mapping(address => uint256)) private _allowances;
173     mapping(address => bool) private _isExcludedFromFee;
174     uint256 private constant MAX = ~uint256(0);
175     uint256 private constant _tTotal = 10000000 * 10**9;
176     uint256 private _rTotal = (MAX - (MAX % _tTotal));
177     uint256 private _tFeeTotal;
178     uint256 public launchBlock;
179  
180     //Buy Fee
181     uint256 private _redisFeeOnBuy = 1;//
182     uint256 private _taxFeeOnBuy = 13;//
183  
184     //Sell Fee
185     uint256 private _redisFeeOnSell = 1;//
186     uint256 private _taxFeeOnSell = 15;//
187  
188     //Original Fee
189     uint256 private _redisFee = _redisFeeOnSell;
190     uint256 private _taxFee = _taxFeeOnSell;
191  
192     uint256 private _previousredisFee = _redisFee;
193     uint256 private _previoustaxFee = _taxFee;
194  
195     mapping(address => bool) public bots;
196     mapping(address => uint256) private cooldown;
197  
198     address payable private _developmentAddress = payable(0xDe4726D3375C4021366b71c2912F25Ec9B57AdC0);//
199     address payable private _marketingAddress = payable(0xdBbA4731D0487740f885e8f519ECe6DEE379F379);//
200  
201     IUniswapV2Router02 public uniswapV2Router;
202     address public uniswapV2Pair;
203  
204     bool private tradingOpen;
205     bool private inSwap = false;
206     bool private swapEnabled = true;
207  
208     uint256 public _maxTxAmount = 30000 * 10**9; //
209     uint256 public _maxWalletSize = 60000 * 10**9; //
210     uint256 public _swapTokensAtAmount = 10000 * 10**9; //
211  
212     event MaxTxAmountUpdated(uint256 _maxTxAmount);
213     modifier lockTheSwap {
214         inSwap = true;
215         _;
216         inSwap = false;
217     }
218  
219     constructor() {
220  
221         _rOwned[_msgSender()] = _rTotal;
222  
223         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
224         uniswapV2Router = _uniswapV2Router;
225         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
226             .createPair(address(this), _uniswapV2Router.WETH());
227  
228         _isExcludedFromFee[owner()] = true;
229         _isExcludedFromFee[address(this)] = true;
230         _isExcludedFromFee[_developmentAddress] = true;
231         _isExcludedFromFee[_marketingAddress] = true;
232  
233         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
234         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
235         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
236         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
237         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
238         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
239         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
240         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
241         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
242         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
243         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;
244  
245  
246         emit Transfer(address(0), _msgSender(), _tTotal);
247     }
248  
249     function name() public pure returns (string memory) {
250         return _name;
251     }
252  
253     function symbol() public pure returns (string memory) {
254         return _symbol;
255     }
256  
257     function decimals() public pure returns (uint8) {
258         return _decimals;
259     }
260  
261     function totalSupply() public pure override returns (uint256) {
262         return _tTotal;
263     }
264  
265     function balanceOf(address account) public view override returns (uint256) {
266         return tokenFromReflection(_rOwned[account]);
267     }
268  
269     function transfer(address recipient, uint256 amount)
270         public
271         override
272         returns (bool)
273     {
274         _transfer(_msgSender(), recipient, amount);
275         return true;
276     }
277  
278     function allowance(address owner, address spender)
279         public
280         view
281         override
282         returns (uint256)
283     {
284         return _allowances[owner][spender];
285     }
286  
287     function approve(address spender, uint256 amount)
288         public
289         override
290         returns (bool)
291     {
292         _approve(_msgSender(), spender, amount);
293         return true;
294     }
295  
296     function transferFrom(
297         address sender,
298         address recipient,
299         uint256 amount
300     ) public override returns (bool) {
301         _transfer(sender, recipient, amount);
302         _approve(
303             sender,
304             _msgSender(),
305             _allowances[sender][_msgSender()].sub(
306                 amount,
307                 "ERC20: transfer amount exceeds allowance"
308             )
309         );
310         return true;
311     }
312  
313     function tokenFromReflection(uint256 rAmount)
314         private
315         view
316         returns (uint256)
317     {
318         require(
319             rAmount <= _rTotal,
320             "Amount must be less than total reflections"
321         );
322         uint256 currentRate = _getRate();
323         return rAmount.div(currentRate);
324     }
325  
326     function removeAllFee() private {
327         if (_redisFee == 0 && _taxFee == 0) return;
328  
329         _previousredisFee = _redisFee;
330         _previoustaxFee = _taxFee;
331  
332         _redisFee = 0;
333         _taxFee = 0;
334     }
335  
336     function restoreAllFee() private {
337         _redisFee = _previousredisFee;
338         _taxFee = _previoustaxFee;
339     }
340  
341     function _approve(
342         address owner,
343         address spender,
344         uint256 amount
345     ) private {
346         require(owner != address(0), "ERC20: approve from the zero address");
347         require(spender != address(0), "ERC20: approve to the zero address");
348         _allowances[owner][spender] = amount;
349         emit Approval(owner, spender, amount);
350     }
351  
352     function _transfer(
353         address from,
354         address to,
355         uint256 amount
356     ) private {
357         require(from != address(0), "ERC20: transfer from the zero address");
358         require(to != address(0), "ERC20: transfer to the zero address");
359         require(amount > 0, "Transfer amount must be greater than zero");
360  
361         if (from != owner() && to != owner()) {
362  
363             //Trade start check
364             if (!tradingOpen) {
365                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
366             }
367  
368             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
369             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
370  
371             if(block.number <= launchBlock && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
372                 bots[to] = true;
373             } 
374  
375             if(to != uniswapV2Pair) {
376                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
377             }
378  
379             uint256 contractTokenBalance = balanceOf(address(this));
380             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
381  
382             if(contractTokenBalance >= _maxTxAmount)
383             {
384                 contractTokenBalance = _maxTxAmount;
385             }
386  
387             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
388                 swapTokensForEth(contractTokenBalance);
389                 uint256 contractETHBalance = address(this).balance;
390                 if (contractETHBalance > 0) {
391                     sendETHToFee(address(this).balance);
392                 }
393             }
394         }
395  
396         bool takeFee = true;
397  
398         //Transfer Tokens
399         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
400             takeFee = false;
401         } else {
402  
403             //Set Fee for Buys
404             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
405                 _redisFee = _redisFeeOnBuy;
406                 _taxFee = _taxFeeOnBuy;
407             }
408  
409             //Set Fee for Sells
410             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
411                 _redisFee = _redisFeeOnSell;
412                 _taxFee = _taxFeeOnSell;
413             }
414  
415         }
416  
417         _tokenTransfer(from, to, amount, takeFee);
418     }
419  
420     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
421         address[] memory path = new address[](2);
422         path[0] = address(this);
423         path[1] = uniswapV2Router.WETH();
424         _approve(address(this), address(uniswapV2Router), tokenAmount);
425         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
426             tokenAmount,
427             0,
428             path,
429             address(this),
430             block.timestamp
431         );
432     }
433  
434     function sendETHToFee(uint256 amount) private {
435         _developmentAddress.transfer(amount.div(2));
436         _marketingAddress.transfer(amount.div(2));
437     }
438  
439     function setTrading(bool _tradingOpen) public onlyOwner {
440         tradingOpen = _tradingOpen;
441         launchBlock = block.number;
442     }
443  
444     function manualswap() external {
445         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
446         uint256 contractBalance = balanceOf(address(this));
447         swapTokensForEth(contractBalance);
448     }
449  
450     function manualsend() external {
451         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
452         uint256 contractETHBalance = address(this).balance;
453         sendETHToFee(contractETHBalance);
454     }
455  
456     function blockBots(address[] memory bots_) public onlyOwner {
457         for (uint256 i = 0; i < bots_.length; i++) {
458             bots[bots_[i]] = true;
459         }
460     }
461  
462     function unblockBot(address notbot) public onlyOwner {
463         bots[notbot] = false;
464     }
465  
466     function _tokenTransfer(
467         address sender,
468         address recipient,
469         uint256 amount,
470         bool takeFee
471     ) private {
472         if (!takeFee) removeAllFee();
473         _transferStandard(sender, recipient, amount);
474         if (!takeFee) restoreAllFee();
475     }
476  
477     function _transferStandard(
478         address sender,
479         address recipient,
480         uint256 tAmount
481     ) private {
482         (
483             uint256 rAmount,
484             uint256 rTransferAmount,
485             uint256 rFee,
486             uint256 tTransferAmount,
487             uint256 tFee,
488             uint256 tTeam
489         ) = _getValues(tAmount);
490         _rOwned[sender] = _rOwned[sender].sub(rAmount);
491         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
492         _takeTeam(tTeam);
493         _reflectFee(rFee, tFee);
494         emit Transfer(sender, recipient, tTransferAmount);
495     }
496  
497     function _takeTeam(uint256 tTeam) private {
498         uint256 currentRate = _getRate();
499         uint256 rTeam = tTeam.mul(currentRate);
500         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
501     }
502  
503     function _reflectFee(uint256 rFee, uint256 tFee) private {
504         _rTotal = _rTotal.sub(rFee);
505         _tFeeTotal = _tFeeTotal.add(tFee);
506     }
507  
508     receive() external payable {}
509  
510     function _getValues(uint256 tAmount)
511         private
512         view
513         returns (
514             uint256,
515             uint256,
516             uint256,
517             uint256,
518             uint256,
519             uint256
520         )
521     {
522         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
523             _getTValues(tAmount, _redisFee, _taxFee);
524         uint256 currentRate = _getRate();
525         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
526             _getRValues(tAmount, tFee, tTeam, currentRate);
527  
528         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
529     }
530  
531     function _getTValues(
532         uint256 tAmount,
533         uint256 redisFee,
534         uint256 taxFee
535     )
536         private
537         pure
538         returns (
539             uint256,
540             uint256,
541             uint256
542         )
543     {
544         uint256 tFee = tAmount.mul(redisFee).div(100);
545         uint256 tTeam = tAmount.mul(taxFee).div(100);
546         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
547  
548         return (tTransferAmount, tFee, tTeam);
549     }
550  
551     function _getRValues(
552         uint256 tAmount,
553         uint256 tFee,
554         uint256 tTeam,
555         uint256 currentRate
556     )
557         private
558         pure
559         returns (
560             uint256,
561             uint256,
562             uint256
563         )
564     {
565         uint256 rAmount = tAmount.mul(currentRate);
566         uint256 rFee = tFee.mul(currentRate);
567         uint256 rTeam = tTeam.mul(currentRate);
568         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
569  
570         return (rAmount, rTransferAmount, rFee);
571     }
572  
573     function _getRate() private view returns (uint256) {
574         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
575  
576         return rSupply.div(tSupply);
577     }
578  
579     function _getCurrentSupply() private view returns (uint256, uint256) {
580         uint256 rSupply = _rTotal;
581         uint256 tSupply = _tTotal;
582         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
583  
584         return (rSupply, tSupply);
585     }
586  
587     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
588         _redisFeeOnBuy = redisFeeOnBuy;
589         _redisFeeOnSell = redisFeeOnSell;
590  
591         _taxFeeOnBuy = taxFeeOnBuy;
592         _taxFeeOnSell = taxFeeOnSell;
593     }
594  
595     //Set minimum tokens required to swap.
596     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
597         _swapTokensAtAmount = swapTokensAtAmount;
598     }
599  
600     //Set minimum tokens required to swap.
601     function toggleSwap(bool _swapEnabled) public onlyOwner {
602         swapEnabled = _swapEnabled;
603     }
604  
605  
606     //Set maximum transaction
607     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
608         _maxTxAmount = maxTxAmount;
609     }
610  
611     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
612         _maxWalletSize = maxWalletSize;
613     }
614  
615     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
616         for(uint256 i = 0; i < accounts.length; i++) {
617             _isExcludedFromFee[accounts[i]] = excluded;
618         }
619     }
620 }