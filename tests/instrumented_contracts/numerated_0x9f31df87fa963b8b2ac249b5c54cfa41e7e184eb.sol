1 /*
2 
3 Sturdy Inu ($STURDY)
4 
5 stur·dy
6 /ˈstərdē/
7 Definition of sturdy
8 a: firmly built or constituted
9 
10 Total Supply: 1,000,000
11 
12 Buy Tax: 4% ( Marketing / Buy backs & Liquidity)
13 Sell Tax: 4% ( Marketing / Buy backs & Liquidity)
14 
15 5% Marketing Wallet
16 No Dev / Team Tokens
17 
18 3% Max Transaction
19 3% Max Wallet 
20 
21 The viral dance $STURDY is now on the blockchain; W Rizz in the chat. 
22 $STURDY Inu aims to bring back reliability and safety in this meme space, as well as trustworthiness in real world consumer goods.
23 $STURDY assists reassurance in your investment, giving you transparency and a Safe Haven to reap rewards. 
24 Ownership will be renounced and Liquidity will be locked upon launch, will also be extended upon milestones.
25 
26 With the likes of Kai Cenat, Adin Ross, XQC, Andrew Tate, and many more chads; Getting $STURDY has taken over the world by storm. 
27 
28 Congratulations, you’ve found something special.
29 
30 Join us in our expedition to 7, 8, or 9 figure market cap and beyond, as we reach interstellar heights with $STURDY Inu.
31 
32 Twitter : https://twitter.com/sturdyinu
33 Telegram : https://t.me/sturdyinu
34 Website : https://sturdyinu.vercel.app/
35 
36 Auto liq + Marketing 
37 
38 */
39 
40 // SPDX-License-Identifier: Unlicensed
41 pragma solidity ^0.8.9;
42 
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 }
48 
49 interface IERC20 {
50     function totalSupply() external view returns (uint256);
51 
52     function balanceOf(address account) external view returns (uint256);
53 
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     function transferFrom(
61         address sender,
62         address recipient,
63         uint256 amount
64     ) external returns (bool);
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(
68         address indexed owner,
69         address indexed spender,
70         uint256 value
71     );
72 }
73 
74 contract Ownable is Context {
75     address private _owner;
76     address private _previousOwner;
77     event OwnershipTransferred(
78         address indexed previousOwner,
79         address indexed newOwner
80     );
81 
82     constructor() {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 
108 }
109 
110 library SafeMath {
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114         return c;
115     }
116 
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     function sub(
122         uint256 a,
123         uint256 b,
124         string memory errorMessage
125     ) internal pure returns (uint256) {
126         require(b <= a, errorMessage);
127         uint256 c = a - b;
128         return c;
129     }
130 
131     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132         if (a == 0) {
133             return 0;
134         }
135         uint256 c = a * b;
136         require(c / a == b, "SafeMath: multiplication overflow");
137         return c;
138     }
139 
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return div(a, b, "SafeMath: division by zero");
142     }
143 
144     function div(
145         uint256 a,
146         uint256 b,
147         string memory errorMessage
148     ) internal pure returns (uint256) {
149         require(b > 0, errorMessage);
150         uint256 c = a / b;
151         return c;
152     }
153 }
154 
155 interface IUniswapV2Factory {
156     function createPair(address tokenA, address tokenB)
157         external
158         returns (address pair);
159 }
160 
161 interface IUniswapV2Router02 {
162     function swapExactTokensForETHSupportingFeeOnTransferTokens(
163         uint256 amountIn,
164         uint256 amountOutMin,
165         address[] calldata path,
166         address to,
167         uint256 deadline
168     ) external;
169 
170     function factory() external pure returns (address);
171 
172     function WETH() external pure returns (address);
173 
174     function addLiquidityETH(
175         address token,
176         uint256 amountTokenDesired,
177         uint256 amountTokenMin,
178         uint256 amountETHMin,
179         address to,
180         uint256 deadline
181     )
182         external
183         payable
184         returns (
185             uint256 amountToken,
186             uint256 amountETH,
187             uint256 liquidity
188         );
189 }
190 
191 contract SturdyInu is Context, IERC20, Ownable {
192 
193     using SafeMath for uint256;
194 
195     string private constant _name = "Sturdy Inu";
196     string private constant _symbol = "Sturdy";
197     uint8 private constant _decimals = 9;
198 
199     mapping(address => uint256) private _rOwned;
200     mapping(address => uint256) private _tOwned;
201     mapping(address => mapping(address => uint256)) private _allowances;
202     mapping(address => bool) private _isExcludedFromFee;
203     uint256 private constant MAX = ~uint256(0);
204     uint256 private constant _tTotal = 1000000 * 10**9;
205     uint256 private _rTotal = (MAX - (MAX % _tTotal));
206     uint256 private _tFeeTotal;
207     uint256 private _redisFeeOnBuy = 0;
208     uint256 private _taxFeeOnBuy = 4;
209     uint256 private _redisFeeOnSell = 0;
210     uint256 private _taxFeeOnSell = 4;
211 
212     //Original Fee
213     uint256 private _redisFee = _redisFeeOnSell;
214     uint256 private _taxFee = _taxFeeOnSell;
215 
216     uint256 private _previousredisFee = _redisFee;
217     uint256 private _previoustaxFee = _taxFee;
218 
219     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
220     address payable private _developmentAddress = payable(0x17488e47f33207e09453d4C620816A591478A3c9);
221     address payable private _marketingAddress = payable(0x17488e47f33207e09453d4C620816A591478A3c9);
222 
223     IUniswapV2Router02 public uniswapV2Router;
224     address public uniswapV2Pair;
225 
226     bool private tradingOpen;
227     bool private inSwap = false;
228     bool private swapEnabled = true;
229 
230     uint256 public _maxTxAmount = 1000000 * 10**9;
231     uint256 public _maxWalletSize = 10000 * 10**9;
232     uint256 public _swapTokensAtAmount = 1000 * 10**9;
233 
234     event MaxTxAmountUpdated(uint256 _maxTxAmount);
235     modifier lockTheSwap {
236         inSwap = true;
237         _;
238         inSwap = false;
239     }
240 
241     constructor() {
242 
243         _rOwned[_msgSender()] = _rTotal;
244 
245         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
246         uniswapV2Router = _uniswapV2Router;
247         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
248             .createPair(address(this), _uniswapV2Router.WETH());
249 
250         _isExcludedFromFee[owner()] = true;
251         _isExcludedFromFee[address(this)] = true;
252         _isExcludedFromFee[_developmentAddress] = true;
253         _isExcludedFromFee[_marketingAddress] = true;
254 
255         emit Transfer(address(0), _msgSender(), _tTotal);
256     }
257 
258     function name() public pure returns (string memory) {
259         return _name;
260     }
261 
262     function symbol() public pure returns (string memory) {
263         return _symbol;
264     }
265 
266     function decimals() public pure returns (uint8) {
267         return _decimals;
268     }
269 
270     function totalSupply() public pure override returns (uint256) {
271         return _tTotal;
272     }
273 
274     function balanceOf(address account) public view override returns (uint256) {
275         return tokenFromReflection(_rOwned[account]);
276     }
277 
278     function transfer(address recipient, uint256 amount)
279         public
280         override
281         returns (bool)
282     {
283         _transfer(_msgSender(), recipient, amount);
284         return true;
285     }
286 
287     function allowance(address owner, address spender)
288         public
289         view
290         override
291         returns (uint256)
292     {
293         return _allowances[owner][spender];
294     }
295 
296     function approve(address spender, uint256 amount)
297         public
298         override
299         returns (bool)
300     {
301         _approve(_msgSender(), spender, amount);
302         return true;
303     }
304 
305     function transferFrom(
306         address sender,
307         address recipient,
308         uint256 amount
309     ) public override returns (bool) {
310         _transfer(sender, recipient, amount);
311         _approve(
312             sender,
313             _msgSender(),
314             _allowances[sender][_msgSender()].sub(
315                 amount,
316                 "ERC20: transfer amount exceeds allowance"
317             )
318         );
319         return true;
320     }
321 
322     function tokenFromReflection(uint256 rAmount)
323         private
324         view
325         returns (uint256)
326     {
327         require(
328             rAmount <= _rTotal,
329             "Amount must be less than total reflections"
330         );
331         uint256 currentRate = _getRate();
332         return rAmount.div(currentRate);
333     }
334 
335     function removeAllFee() private {
336         if (_redisFee == 0 && _taxFee == 0) return;
337 
338         _previousredisFee = _redisFee;
339         _previoustaxFee = _taxFee;
340 
341         _redisFee = 0;
342         _taxFee = 0;
343     }
344 
345     function restoreAllFee() private {
346         _redisFee = _previousredisFee;
347         _taxFee = _previoustaxFee;
348     }
349 
350     function _approve(
351         address owner,
352         address spender,
353         uint256 amount
354     ) private {
355         require(owner != address(0), "ERC20: approve from the zero address");
356         require(spender != address(0), "ERC20: approve to the zero address");
357         _allowances[owner][spender] = amount;
358         emit Approval(owner, spender, amount);
359     }
360 
361     function _transfer(
362         address from,
363         address to,
364         uint256 amount
365     ) private {
366         require(from != address(0), "ERC20: transfer from the zero address");
367         require(to != address(0), "ERC20: transfer to the zero address");
368         require(amount > 0, "Transfer amount must be greater than zero");
369 
370         if (from != owner() && to != owner()) {
371 
372             //Trade start check
373             if (!tradingOpen) {
374                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
375             }
376 
377             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
378             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
379 
380             if(to != uniswapV2Pair) {
381                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
382             }
383 
384             uint256 contractTokenBalance = balanceOf(address(this));
385             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
386 
387             if(contractTokenBalance >= _maxTxAmount)
388             {
389                 contractTokenBalance = _maxTxAmount;
390             }
391 
392             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
393                 swapTokensForEth(contractTokenBalance);
394                 uint256 contractETHBalance = address(this).balance;
395                 if (contractETHBalance > 0) {
396                     sendETHToFee(address(this).balance);
397                 }
398             }
399         }
400 
401         bool takeFee = true;
402 
403         //Transfer Tokens
404         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
405             takeFee = false;
406         } else {
407 
408             //Set Fee for Buys
409             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
410                 _redisFee = _redisFeeOnBuy;
411                 _taxFee = _taxFeeOnBuy;
412             }
413 
414             //Set Fee for Sells
415             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
416                 _redisFee = _redisFeeOnSell;
417                 _taxFee = _taxFeeOnSell;
418             }
419 
420         }
421 
422         _tokenTransfer(from, to, amount, takeFee);
423     }
424 
425     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
426         address[] memory path = new address[](2);
427         path[0] = address(this);
428         path[1] = uniswapV2Router.WETH();
429         _approve(address(this), address(uniswapV2Router), tokenAmount);
430         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
431             tokenAmount,
432             0,
433             path,
434             address(this),
435             block.timestamp
436         );
437     }
438 
439     function sendETHToFee(uint256 amount) private {
440         _marketingAddress.transfer(amount);
441     }
442 
443     function setTrading(bool _tradingOpen) public onlyOwner {
444         tradingOpen = _tradingOpen;
445     }
446 
447     function manualswap() external {
448         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
449         uint256 contractBalance = balanceOf(address(this));
450         swapTokensForEth(contractBalance);
451     }
452 
453     function manualsend() external {
454         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
455         uint256 contractETHBalance = address(this).balance;
456         sendETHToFee(contractETHBalance);
457     }
458 
459     function blockBots(address[] memory bots_) public onlyOwner {
460         for (uint256 i = 0; i < bots_.length; i++) {
461             bots[bots_[i]] = true;
462         }
463     }
464 
465     function unblockBot(address notbot) public onlyOwner {
466         bots[notbot] = false;
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
485         (
486             uint256 rAmount,
487             uint256 rTransferAmount,
488             uint256 rFee,
489             uint256 tTransferAmount,
490             uint256 tFee,
491             uint256 tTeam
492         ) = _getValues(tAmount);
493         _rOwned[sender] = _rOwned[sender].sub(rAmount);
494         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
495         _takeTeam(tTeam);
496         _reflectFee(rFee, tFee);
497         emit Transfer(sender, recipient, tTransferAmount);
498     }
499 
500     function _takeTeam(uint256 tTeam) private {
501         uint256 currentRate = _getRate();
502         uint256 rTeam = tTeam.mul(currentRate);
503         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
504     }
505 
506     function _reflectFee(uint256 rFee, uint256 tFee) private {
507         _rTotal = _rTotal.sub(rFee);
508         _tFeeTotal = _tFeeTotal.add(tFee);
509     }
510 
511     receive() external payable {}
512 
513     function _getValues(uint256 tAmount)
514         private
515         view
516         returns (
517             uint256,
518             uint256,
519             uint256,
520             uint256,
521             uint256,
522             uint256
523         )
524     {
525         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
526             _getTValues(tAmount, _redisFee, _taxFee);
527         uint256 currentRate = _getRate();
528         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
529             _getRValues(tAmount, tFee, tTeam, currentRate);
530         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
531     }
532 
533     function _getTValues(
534         uint256 tAmount,
535         uint256 redisFee,
536         uint256 taxFee
537     )
538         private
539         pure
540         returns (
541             uint256,
542             uint256,
543             uint256
544         )
545     {
546         uint256 tFee = tAmount.mul(redisFee).div(100);
547         uint256 tTeam = tAmount.mul(taxFee).div(100);
548         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
549         return (tTransferAmount, tFee, tTeam);
550     }
551 
552     function _getRValues(
553         uint256 tAmount,
554         uint256 tFee,
555         uint256 tTeam,
556         uint256 currentRate
557     )
558         private
559         pure
560         returns (
561             uint256,
562             uint256,
563             uint256
564         )
565     {
566         uint256 rAmount = tAmount.mul(currentRate);
567         uint256 rFee = tFee.mul(currentRate);
568         uint256 rTeam = tTeam.mul(currentRate);
569         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
570         return (rAmount, rTransferAmount, rFee);
571     }
572 
573     function _getRate() private view returns (uint256) {
574         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
575         return rSupply.div(tSupply);
576     }
577 
578     function _getCurrentSupply() private view returns (uint256, uint256) {
579         uint256 rSupply = _rTotal;
580         uint256 tSupply = _tTotal;
581         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
582         return (rSupply, tSupply);
583     }
584 
585     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
586         _redisFeeOnBuy = redisFeeOnBuy;
587         _redisFeeOnSell = redisFeeOnSell;
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
602     //Set maximum transaction
603     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
604         _maxTxAmount = maxTxAmount;
605     }
606 
607     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
608         _maxWalletSize = maxWalletSize;
609     }
610 
611     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
612         for(uint256 i = 0; i < accounts.length; i++) {
613             _isExcludedFromFee[accounts[i]] = excluded;
614         }
615     }
616      
617 
618 }