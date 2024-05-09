1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.4;
3  
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9  
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12  
13     function balanceOf(address account) external view returns (uint256);
14  
15     function transfer(address recipient, uint256 amount) external returns (bool);
16  
17     function allowance(address owner, address spender) external view returns (uint256);
18  
19     function approve(address spender, uint256 amount) external returns (bool);
20  
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26  
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(
29         address indexed owner,
30         address indexed spender,
31         uint256 value
32     );
33 }
34  
35 contract Ownable is Context {
36     address private _owner;
37     address private _previousOwner;
38     event OwnershipTransferred(
39         address indexed previousOwner,
40         address indexed newOwner
41     );
42  
43     constructor() {
44         address msgSender = _msgSender();
45         _owner = msgSender;
46         emit OwnershipTransferred(address(0), msgSender);
47     }
48  
49     function owner() public view returns (address) {
50         return _owner;
51     }
52  
53     modifier onlyOwner() {
54         require(_owner == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57  
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62  
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68  
69 }
70  
71 library SafeMath {
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75         return c;
76     }
77  
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         return sub(a, b, "SafeMath: subtraction overflow");
80     }
81  
82     function sub(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89         return c;
90     }
91  
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         if (a == 0) {
94             return 0;
95         }
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98         return c;
99     }
100  
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104  
105     function div(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112         return c;
113     }
114 }
115  
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB)
118         external
119         returns (address pair);
120 }
121  
122 interface IUniswapV2Router02 {
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint256 amountIn,
125         uint256 amountOutMin,
126         address[] calldata path,
127         address to,
128         uint256 deadline
129     ) external;
130  
131     function factory() external pure returns (address);
132  
133     function WETH() external pure returns (address);
134  
135     function addLiquidityETH(
136         address token,
137         uint256 amountTokenDesired,
138         uint256 amountTokenMin,
139         uint256 amountETHMin,
140         address to,
141         uint256 deadline
142     )
143         external
144         payable
145         returns (
146             uint256 amountToken,
147             uint256 amountETH,
148             uint256 liquidity
149         );
150 }
151  
152 contract StellaCoin is Context, IERC20, Ownable {
153  
154     using SafeMath for uint256;
155  
156     string private constant _name = "Stella Coin";
157     string private constant _symbol = "STELLA";
158     uint8 private constant _decimals = 9;
159  
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 10000000000 * 10**9;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168     uint256 public launchBlock;
169  
170     //Buy Fee
171     uint256 private _redisFeeOnBuy = 0;
172     uint256 private _taxFeeOnBuy = 9;
173  
174     //Sell Fee
175     uint256 private _redisFeeOnSell = 0;
176     uint256 private _taxFeeOnSell = 99;
177  
178     //Original Fee
179     uint256 private _redisFee = _redisFeeOnSell;
180     uint256 private _taxFee = _taxFeeOnSell;
181  
182     uint256 private _previousredisFee = _redisFee;
183     uint256 private _previoustaxFee = _taxFee;
184  
185     mapping(address => bool) public bots;
186     mapping(address => uint256) private cooldown;
187  
188     address payable private _developmentAddress = payable(0x1ffF25E117e31D5Ae9632D5C1e1BFAdCD2977a1c);
189     address payable private _marketingAddress = payable(0xDb8597Fba6dFb3d964d50638276630F960fB15B9);
190  
191     IUniswapV2Router02 public uniswapV2Router;
192     address public uniswapV2Pair;
193  
194     bool private tradingOpen;
195     bool private inSwap = false;
196     bool private swapEnabled = true;
197  
198     uint256 public _maxTxAmount = 250000000 * 10**9; 
199     uint256 public _maxWalletSize = 500000000 * 10**9; 
200     uint256 public _swapTokensAtAmount = 10000000 * 10**9; 
201  
202     event MaxTxAmountUpdated(uint256 _maxTxAmount);
203     modifier lockTheSwap {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208  
209     constructor() {
210  
211         _rOwned[_msgSender()] = _rTotal;
212  
213         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
214         uniswapV2Router = _uniswapV2Router;
215         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
216             .createPair(address(this), _uniswapV2Router.WETH());
217  
218         _isExcludedFromFee[owner()] = true;
219         _isExcludedFromFee[address(this)] = true;
220         _isExcludedFromFee[_developmentAddress] = true;
221         _isExcludedFromFee[_marketingAddress] = true;
222  
223         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
224         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
225         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
226         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
227         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
228         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
229         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
230         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
231         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
232         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
233         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;
234  
235  
236         emit Transfer(address(0), _msgSender(), _tTotal);
237     }
238  
239     function name() public pure returns (string memory) {
240         return _name;
241     }
242  
243     function symbol() public pure returns (string memory) {
244         return _symbol;
245     }
246  
247     function decimals() public pure returns (uint8) {
248         return _decimals;
249     }
250  
251     function totalSupply() public pure override returns (uint256) {
252         return _tTotal;
253     }
254  
255     function balanceOf(address account) public view override returns (uint256) {
256         return tokenFromReflection(_rOwned[account]);
257     }
258  
259     function transfer(address recipient, uint256 amount)
260         public
261         override
262         returns (bool)
263     {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267  
268     function allowance(address owner, address spender)
269         public
270         view
271         override
272         returns (uint256)
273     {
274         return _allowances[owner][spender];
275     }
276  
277     function approve(address spender, uint256 amount)
278         public
279         override
280         returns (bool)
281     {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285  
286     function transferFrom(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) public override returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(
293             sender,
294             _msgSender(),
295             _allowances[sender][_msgSender()].sub(
296                 amount,
297                 "ERC20: transfer amount exceeds allowance"
298             )
299         );
300         return true;
301     }
302  
303     function tokenFromReflection(uint256 rAmount)
304         private
305         view
306         returns (uint256)
307     {
308         require(
309             rAmount <= _rTotal,
310             "Amount must be less than total reflections"
311         );
312         uint256 currentRate = _getRate();
313         return rAmount.div(currentRate);
314     }
315  
316     function removeAllFee() private {
317         if (_redisFee == 0 && _taxFee == 0) return;
318  
319         _previousredisFee = _redisFee;
320         _previoustaxFee = _taxFee;
321  
322         _redisFee = 0;
323         _taxFee = 0;
324     }
325  
326     function restoreAllFee() private {
327         _redisFee = _previousredisFee;
328         _taxFee = _previoustaxFee;
329     }
330  
331     function _approve(
332         address owner,
333         address spender,
334         uint256 amount
335     ) private {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338         _allowances[owner][spender] = amount;
339         emit Approval(owner, spender, amount);
340     }
341  
342     function _transfer(
343         address from,
344         address to,
345         uint256 amount
346     ) private {
347         require(from != address(0), "ERC20: transfer from the zero address");
348         require(to != address(0), "ERC20: transfer to the zero address");
349         require(amount > 0, "Transfer amount must be greater than zero");
350  
351         if (from != owner() && to != owner()) {
352  
353             //Trade start check
354             if (!tradingOpen) {
355                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
356             }
357  
358             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
359             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
360  
361             if(block.number <= launchBlock && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
362                 bots[to] = true;
363             } 
364  
365             if(to != uniswapV2Pair) {
366                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
367             }
368  
369             uint256 contractTokenBalance = balanceOf(address(this));
370             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
371  
372             if(contractTokenBalance >= _maxTxAmount)
373             {
374                 contractTokenBalance = _maxTxAmount;
375             }
376  
377             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
378                 swapTokensForEth(contractTokenBalance);
379                 uint256 contractETHBalance = address(this).balance;
380                 if (contractETHBalance > 0) {
381                     sendETHToFee(address(this).balance);
382                 }
383             }
384         }
385  
386         bool takeFee = true;
387  
388         //Transfer Tokens
389         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
390             takeFee = false;
391         } else {
392  
393             //Set Fee for Buys
394             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
395                 _redisFee = _redisFeeOnBuy;
396                 _taxFee = _taxFeeOnBuy;
397             }
398  
399             //Set Fee for Sells
400             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
401                 _redisFee = _redisFeeOnSell;
402                 _taxFee = _taxFeeOnSell;
403             }
404  
405         }
406  
407         _tokenTransfer(from, to, amount, takeFee);
408     }
409  
410     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
411         address[] memory path = new address[](2);
412         path[0] = address(this);
413         path[1] = uniswapV2Router.WETH();
414         _approve(address(this), address(uniswapV2Router), tokenAmount);
415         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
416             tokenAmount,
417             0,
418             path,
419             address(this),
420             block.timestamp
421         );
422     }
423  
424     function sendETHToFee(uint256 amount) private {
425         _developmentAddress.transfer(amount.mul(33).div(100));
426         _marketingAddress.transfer(amount.mul(67).div(100));
427     }
428  
429     function setTrading(bool _tradingOpen) public onlyOwner {
430         tradingOpen = _tradingOpen;
431         launchBlock = block.number;
432     }
433  
434     function manualswap() external {
435         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
436         uint256 contractBalance = balanceOf(address(this));
437         swapTokensForEth(contractBalance);
438     }
439  
440     function manualsend() external {
441         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
442         uint256 contractETHBalance = address(this).balance;
443         sendETHToFee(contractETHBalance);
444     }
445  
446     function blockBots(address[] memory bots_) public onlyOwner {
447         for (uint256 i = 0; i < bots_.length; i++) {
448             bots[bots_[i]] = true;
449         }
450     }
451  
452     function unblockBot(address notbot) public onlyOwner {
453         bots[notbot] = false;
454     }
455  
456     function _tokenTransfer(
457         address sender,
458         address recipient,
459         uint256 amount,
460         bool takeFee
461     ) private {
462         if (!takeFee) removeAllFee();
463         _transferStandard(sender, recipient, amount);
464         if (!takeFee) restoreAllFee();
465     }
466  
467     function _transferStandard(
468         address sender,
469         address recipient,
470         uint256 tAmount
471     ) private {
472         (
473             uint256 rAmount,
474             uint256 rTransferAmount,
475             uint256 rFee,
476             uint256 tTransferAmount,
477             uint256 tFee,
478             uint256 tTeam
479         ) = _getValues(tAmount);
480         _rOwned[sender] = _rOwned[sender].sub(rAmount);
481         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
482         _takeTeam(tTeam);
483         _reflectFee(rFee, tFee);
484         emit Transfer(sender, recipient, tTransferAmount);
485     }
486  
487     function _takeTeam(uint256 tTeam) private {
488         uint256 currentRate = _getRate();
489         uint256 rTeam = tTeam.mul(currentRate);
490         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
491     }
492  
493     function _reflectFee(uint256 rFee, uint256 tFee) private {
494         _rTotal = _rTotal.sub(rFee);
495         _tFeeTotal = _tFeeTotal.add(tFee);
496     }
497  
498     receive() external payable {}
499  
500     function _getValues(uint256 tAmount)
501         private
502         view
503         returns (
504             uint256,
505             uint256,
506             uint256,
507             uint256,
508             uint256,
509             uint256
510         )
511     {
512         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
513             _getTValues(tAmount, _redisFee, _taxFee);
514         uint256 currentRate = _getRate();
515         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
516             _getRValues(tAmount, tFee, tTeam, currentRate);
517  
518         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
519     }
520  
521     function _getTValues(
522         uint256 tAmount,
523         uint256 redisFee,
524         uint256 taxFee
525     )
526         private
527         pure
528         returns (
529             uint256,
530             uint256,
531             uint256
532         )
533     {
534         uint256 tFee = tAmount.mul(redisFee).div(100);
535         uint256 tTeam = tAmount.mul(taxFee).div(100);
536         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
537  
538         return (tTransferAmount, tFee, tTeam);
539     }
540  
541     function _getRValues(
542         uint256 tAmount,
543         uint256 tFee,
544         uint256 tTeam,
545         uint256 currentRate
546     )
547         private
548         pure
549         returns (
550             uint256,
551             uint256,
552             uint256
553         )
554     {
555         uint256 rAmount = tAmount.mul(currentRate);
556         uint256 rFee = tFee.mul(currentRate);
557         uint256 rTeam = tTeam.mul(currentRate);
558         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
559  
560         return (rAmount, rTransferAmount, rFee);
561     }
562  
563     function _getRate() private view returns (uint256) {
564         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
565  
566         return rSupply.div(tSupply);
567     }
568  
569     function _getCurrentSupply() private view returns (uint256, uint256) {
570         uint256 rSupply = _rTotal;
571         uint256 tSupply = _tTotal;
572         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
573  
574         return (rSupply, tSupply);
575     }
576  
577     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
578         _redisFeeOnBuy = redisFeeOnBuy;
579         _redisFeeOnSell = redisFeeOnSell;
580  
581         _taxFeeOnBuy = taxFeeOnBuy;
582         _taxFeeOnSell = taxFeeOnSell;
583     }
584  
585     //Set minimum tokens required to swap.
586     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
587         _swapTokensAtAmount = swapTokensAtAmount;
588     }
589  
590     //Set minimum tokens required to swap.
591     function toggleSwap(bool _swapEnabled) public onlyOwner {
592         swapEnabled = _swapEnabled;
593     }
594  
595  
596     //Set maximum transaction
597     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
598         _maxTxAmount = maxTxAmount;
599     }
600  
601     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
602         _maxWalletSize = maxWalletSize;
603     }
604  
605     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
606         for(uint256 i = 0; i < accounts.length; i++) {
607             _isExcludedFromFee[accounts[i]] = excluded;
608         }
609     }
610 }