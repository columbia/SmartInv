1 /**
2 RICARDO COIN
3 
4 TG: https://twitter.com/ricardo_coinerc
5 
6 */
7 
8 // SPDX-License-Identifier: Unlicensed
9 pragma solidity ^0.8.4;
10  
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16  
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19  
20     function balanceOf(address account) external view returns (uint256);
21  
22     function transfer(address recipient, uint256 amount) external returns (bool);
23  
24     function allowance(address owner, address spender) external view returns (uint256);
25  
26     function approve(address spender, uint256 amount) external returns (bool);
27  
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33  
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41  
42 contract Ownable is Context {
43     address private _owner;
44     address private _previousOwner;
45     event OwnershipTransferred(
46         address indexed previousOwner,
47         address indexed newOwner
48     );
49  
50     constructor() {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55  
56     function owner() public view returns (address) {
57         return _owner;
58     }
59  
60     modifier onlyOwner() {
61         require(_owner == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64  
65     function renounceOwnership() public virtual onlyOwner {
66         emit OwnershipTransferred(_owner, address(0));
67         _owner = address(0);
68     }
69  
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75  
76 }
77  
78 library SafeMath {
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82         return c;
83     }
84  
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         return sub(a, b, "SafeMath: subtraction overflow");
87     }
88  
89     function sub(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         require(b <= a, errorMessage);
95         uint256 c = a - b;
96         return c;
97     }
98  
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         if (a == 0) {
101             return 0;
102         }
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105         return c;
106     }
107  
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111  
112     function div(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         return c;
120     }
121 }
122  
123 interface IUniswapV2Factory {
124     function createPair(address tokenA, address tokenB)
125         external
126         returns (address pair);
127 }
128  
129 interface IUniswapV2Router02 {
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint256 amountIn,
132         uint256 amountOutMin,
133         address[] calldata path,
134         address to,
135         uint256 deadline
136     ) external;
137  
138     function factory() external pure returns (address);
139  
140     function WETH() external pure returns (address);
141  
142     function addLiquidityETH(
143         address token,
144         uint256 amountTokenDesired,
145         uint256 amountTokenMin,
146         uint256 amountETHMin,
147         address to,
148         uint256 deadline
149     )
150         external
151         payable
152         returns (
153             uint256 amountToken,
154             uint256 amountETH,
155             uint256 liquidity
156         );
157 }
158  
159 contract RICARDOCOIN is Context, IERC20, Ownable {
160  
161     using SafeMath for uint256;
162  
163     string private constant _name = "RICARDO COIN";//
164     string private constant _symbol = "$RIC";//
165     uint8 private constant _decimals = 9;
166  
167     mapping(address => uint256) private _rOwned;
168     mapping(address => uint256) private _tOwned;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     uint256 private constant MAX = ~uint256(0);
172     uint256 private constant _tTotal = 1000000000 * 10**9;
173     uint256 private _rTotal = (MAX - (MAX % _tTotal));
174     uint256 private _tFeeTotal;
175     uint256 public launchBlock;
176  
177     //Buy Fee
178     uint256 private _redisFeeOnBuy = 0;//
179     uint256 private _taxFeeOnBuy = 25;//
180  
181     //Sell Fee
182     uint256 private _redisFeeOnSell = 0;//
183     uint256 private _taxFeeOnSell = 35;//
184  
185     //Original Fee
186     uint256 private _redisFee = _redisFeeOnSell;
187     uint256 private _taxFee = _taxFeeOnSell;
188  
189     uint256 private _previousredisFee = _redisFee;
190     uint256 private _previoustaxFee = _taxFee;
191  
192     mapping(address => bool) public bots;
193     mapping(address => uint256) private cooldown;
194  
195     address payable private _developmentAddress = payable(0x6f81f3943aa79A28B562e1e4e53a8dD83f97F171);//
196     address payable private _marketingAddress = payable(0x6f81f3943aa79A28B562e1e4e53a8dD83f97F171);//
197  
198     IUniswapV2Router02 public uniswapV2Router;
199     address public uniswapV2Pair;
200  
201     bool private tradingOpen;
202     bool private inSwap = false;
203     bool private swapEnabled = true;
204  
205     uint256 public _maxTxAmount = 10000000 * 10**9; //
206     uint256 public _maxWalletSize = 20000000 * 10**9; //
207     uint256 public _swapTokensAtAmount = 10000 * 10**9; //
208  
209     event MaxTxAmountUpdated(uint256 _maxTxAmount);
210     modifier lockTheSwap {
211         inSwap = true;
212         _;
213         inSwap = false;
214     }
215  
216     constructor() {
217  
218         _rOwned[_msgSender()] = _rTotal;
219  
220         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
221         uniswapV2Router = _uniswapV2Router;
222         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
223             .createPair(address(this), _uniswapV2Router.WETH());
224  
225         _isExcludedFromFee[owner()] = true;
226         _isExcludedFromFee[address(this)] = true;
227         _isExcludedFromFee[_developmentAddress] = true;
228         _isExcludedFromFee[_marketingAddress] = true;
229  
230         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
231         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
232         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
233         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
234         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
235         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
236         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
237         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
238         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
239         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
240         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;
241  
242  
243         emit Transfer(address(0), _msgSender(), _tTotal);
244     }
245  
246     function name() public pure returns (string memory) {
247         return _name;
248     }
249  
250     function symbol() public pure returns (string memory) {
251         return _symbol;
252     }
253  
254     function decimals() public pure returns (uint8) {
255         return _decimals;
256     }
257  
258     function totalSupply() public pure override returns (uint256) {
259         return _tTotal;
260     }
261  
262     function balanceOf(address account) public view override returns (uint256) {
263         return tokenFromReflection(_rOwned[account]);
264     }
265  
266     function transfer(address recipient, uint256 amount)
267         public
268         override
269         returns (bool)
270     {
271         _transfer(_msgSender(), recipient, amount);
272         return true;
273     }
274  
275     function allowance(address owner, address spender)
276         public
277         view
278         override
279         returns (uint256)
280     {
281         return _allowances[owner][spender];
282     }
283  
284     function approve(address spender, uint256 amount)
285         public
286         override
287         returns (bool)
288     {
289         _approve(_msgSender(), spender, amount);
290         return true;
291     }
292  
293     function transferFrom(
294         address sender,
295         address recipient,
296         uint256 amount
297     ) public override returns (bool) {
298         _transfer(sender, recipient, amount);
299         _approve(
300             sender,
301             _msgSender(),
302             _allowances[sender][_msgSender()].sub(
303                 amount,
304                 "ERC20: transfer amount exceeds allowance"
305             )
306         );
307         return true;
308     }
309  
310     function tokenFromReflection(uint256 rAmount)
311         private
312         view
313         returns (uint256)
314     {
315         require(
316             rAmount <= _rTotal,
317             "Amount must be less than total reflections"
318         );
319         uint256 currentRate = _getRate();
320         return rAmount.div(currentRate);
321     }
322  
323     function removeAllFee() private {
324         if (_redisFee == 0 && _taxFee == 0) return;
325  
326         _previousredisFee = _redisFee;
327         _previoustaxFee = _taxFee;
328  
329         _redisFee = 0;
330         _taxFee = 0;
331     }
332  
333     function restoreAllFee() private {
334         _redisFee = _previousredisFee;
335         _taxFee = _previoustaxFee;
336     }
337  
338     function _approve(
339         address owner,
340         address spender,
341         uint256 amount
342     ) private {
343         require(owner != address(0), "ERC20: approve from the zero address");
344         require(spender != address(0), "ERC20: approve to the zero address");
345         _allowances[owner][spender] = amount;
346         emit Approval(owner, spender, amount);
347     }
348  
349     function _transfer(
350         address from,
351         address to,
352         uint256 amount
353     ) private {
354         require(from != address(0), "ERC20: transfer from the zero address");
355         require(to != address(0), "ERC20: transfer to the zero address");
356         require(amount > 0, "Transfer amount must be greater than zero");
357  
358         if (from != owner() && to != owner()) {
359  
360             //Trade start check
361             if (!tradingOpen) {
362                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
363             }
364  
365             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
366             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
367  
368             if(block.number <= launchBlock && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
369                 bots[to] = true;
370             } 
371  
372             if(to != uniswapV2Pair) {
373                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
374             }
375  
376             uint256 contractTokenBalance = balanceOf(address(this));
377             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
378  
379             if(contractTokenBalance >= _maxTxAmount)
380             {
381                 contractTokenBalance = _maxTxAmount;
382             }
383  
384             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
385                 swapTokensForEth(contractTokenBalance);
386                 uint256 contractETHBalance = address(this).balance;
387                 if (contractETHBalance > 0) {
388                     sendETHToFee(address(this).balance);
389                 }
390             }
391         }
392  
393         bool takeFee = true;
394  
395         //Transfer Tokens
396         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
397             takeFee = false;
398         } else {
399  
400             //Set Fee for Buys
401             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
402                 _redisFee = _redisFeeOnBuy;
403                 _taxFee = _taxFeeOnBuy;
404             }
405  
406             //Set Fee for Sells
407             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
408                 _redisFee = _redisFeeOnSell;
409                 _taxFee = _taxFeeOnSell;
410             }
411  
412         }
413  
414         _tokenTransfer(from, to, amount, takeFee);
415     }
416  
417     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
418         address[] memory path = new address[](2);
419         path[0] = address(this);
420         path[1] = uniswapV2Router.WETH();
421         _approve(address(this), address(uniswapV2Router), tokenAmount);
422         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
423             tokenAmount,
424             0,
425             path,
426             address(this),
427             block.timestamp
428         );
429     }
430  
431     function sendETHToFee(uint256 amount) private {
432         _developmentAddress.transfer(amount.div(2));
433         _marketingAddress.transfer(amount.div(2));
434     }
435  
436     function setTrading(bool _tradingOpen) public onlyOwner {
437         tradingOpen = _tradingOpen;
438         launchBlock = block.number;
439     }
440  
441     function manualswap() external {
442         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
443         uint256 contractBalance = balanceOf(address(this));
444         swapTokensForEth(contractBalance);
445     }
446  
447     function manualsend() external {
448         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
449         uint256 contractETHBalance = address(this).balance;
450         sendETHToFee(contractETHBalance);
451     }
452  
453     function blockBots(address[] memory bots_) public onlyOwner {
454         for (uint256 i = 0; i < bots_.length; i++) {
455             bots[bots_[i]] = true;
456         }
457     }
458  
459     function unblockBot(address notbot) public onlyOwner {
460         bots[notbot] = false;
461     }
462  
463     function _tokenTransfer(
464         address sender,
465         address recipient,
466         uint256 amount,
467         bool takeFee
468     ) private {
469         if (!takeFee) removeAllFee();
470         _transferStandard(sender, recipient, amount);
471         if (!takeFee) restoreAllFee();
472     }
473  
474     function _transferStandard(
475         address sender,
476         address recipient,
477         uint256 tAmount
478     ) private {
479         (
480             uint256 rAmount,
481             uint256 rTransferAmount,
482             uint256 rFee,
483             uint256 tTransferAmount,
484             uint256 tFee,
485             uint256 tTeam
486         ) = _getValues(tAmount);
487         _rOwned[sender] = _rOwned[sender].sub(rAmount);
488         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
489         _takeTeam(tTeam);
490         _reflectFee(rFee, tFee);
491         emit Transfer(sender, recipient, tTransferAmount);
492     }
493  
494     function _takeTeam(uint256 tTeam) private {
495         uint256 currentRate = _getRate();
496         uint256 rTeam = tTeam.mul(currentRate);
497         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
498     }
499  
500     function _reflectFee(uint256 rFee, uint256 tFee) private {
501         _rTotal = _rTotal.sub(rFee);
502         _tFeeTotal = _tFeeTotal.add(tFee);
503     }
504  
505     receive() external payable {}
506  
507     function _getValues(uint256 tAmount)
508         private
509         view
510         returns (
511             uint256,
512             uint256,
513             uint256,
514             uint256,
515             uint256,
516             uint256
517         )
518     {
519         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
520             _getTValues(tAmount, _redisFee, _taxFee);
521         uint256 currentRate = _getRate();
522         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
523             _getRValues(tAmount, tFee, tTeam, currentRate);
524  
525         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
526     }
527  
528     function _getTValues(
529         uint256 tAmount,
530         uint256 redisFee,
531         uint256 taxFee
532     )
533         private
534         pure
535         returns (
536             uint256,
537             uint256,
538             uint256
539         )
540     {
541         uint256 tFee = tAmount.mul(redisFee).div(100);
542         uint256 tTeam = tAmount.mul(taxFee).div(100);
543         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
544  
545         return (tTransferAmount, tFee, tTeam);
546     }
547  
548     function _getRValues(
549         uint256 tAmount,
550         uint256 tFee,
551         uint256 tTeam,
552         uint256 currentRate
553     )
554         private
555         pure
556         returns (
557             uint256,
558             uint256,
559             uint256
560         )
561     {
562         uint256 rAmount = tAmount.mul(currentRate);
563         uint256 rFee = tFee.mul(currentRate);
564         uint256 rTeam = tTeam.mul(currentRate);
565         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
566  
567         return (rAmount, rTransferAmount, rFee);
568     }
569  
570     function _getRate() private view returns (uint256) {
571         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
572  
573         return rSupply.div(tSupply);
574     }
575  
576     function _getCurrentSupply() private view returns (uint256, uint256) {
577         uint256 rSupply = _rTotal;
578         uint256 tSupply = _tTotal;
579         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
580  
581         return (rSupply, tSupply);
582     }
583  
584     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
585         _redisFeeOnBuy = redisFeeOnBuy;
586         _redisFeeOnSell = redisFeeOnSell;
587  
588         _taxFeeOnBuy = taxFeeOnBuy;
589         _taxFeeOnSell = taxFeeOnSell;
590     }
591  
592     //Set minimum tokens required to swap.
593     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
594         _swapTokensAtAmount = swapTokensAtAmount;
595     }
596  
597     //Set minimum tokens required to swap.
598     function toggleSwap(bool _swapEnabled) public onlyOwner {
599         swapEnabled = _swapEnabled;
600     }
601  
602  
603     //Set maximum transaction
604     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
605         _maxTxAmount = maxTxAmount;
606     }
607  
608     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
609         _maxWalletSize = maxWalletSize;
610     }
611  
612     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
613         for(uint256 i = 0; i < accounts.length; i++) {
614             _isExcludedFromFee[accounts[i]] = excluded;
615         }
616     }
617 }