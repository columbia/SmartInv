1 /**
2  *Submitted for verification at Etherscan.io on 2022-11-02
3 */
4 
5 /*
6 
7 The NFT fund you wish you could go back in time and invest in. 
8 
9 We will build a gallery, pitch new NFT projects, drop new 
10 collections with established artists from 🇨🇭 and most importantly: 
11 We will lead swiss investor groups and private investors into the CRYPTOSpace.
12 Any NFT that we will buy with the Fund Wallet will be held for at least 1 year.
13 
14 Once an NFT is sold, we buy back tokens and burn them.
15 
16 TELEGRAM: 
17 https://t.me/swissnftfundportal
18 
19 TWITTER:
20 https://twitter.com/swissnftfund
21 
22 WEBSITE:
23 https://www.swissnftfund.io/
24 
25 
26 */
27 
28 
29 
30 // SPDX-License-Identifier: Unlicensed
31 pragma solidity ^0.8.9;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 }
38 
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41 
42     function balanceOf(address account) external view returns (uint256);
43 
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     function transferFrom(
51         address sender,
52         address recipient,
53         uint256 amount
54     ) external returns (bool);
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(
58         address indexed owner,
59         address indexed spender,
60         uint256 value
61     );
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     address private _previousOwner;
67     event OwnershipTransferred(
68         address indexed previousOwner,
69         address indexed newOwner
70     );
71 
72     constructor() {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 
98 }
99 
100 library SafeMath {
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104         return c;
105     }
106 
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         return sub(a, b, "SafeMath: subtraction overflow");
109     }
110 
111     function sub(
112         uint256 a,
113         uint256 b,
114         string memory errorMessage
115     ) internal pure returns (uint256) {
116         require(b <= a, errorMessage);
117         uint256 c = a - b;
118         return c;
119     }
120 
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         if (a == 0) {
123             return 0;
124         }
125         uint256 c = a * b;
126         require(c / a == b, "SafeMath: multiplication overflow");
127         return c;
128     }
129 
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return div(a, b, "SafeMath: division by zero");
132     }
133 
134     function div(
135         uint256 a,
136         uint256 b,
137         string memory errorMessage
138     ) internal pure returns (uint256) {
139         require(b > 0, errorMessage);
140         uint256 c = a / b;
141         return c;
142     }
143 }
144 
145 interface IUniswapV2Factory {
146     function createPair(address tokenA, address tokenB)
147         external
148         returns (address pair);
149 }
150 
151 interface IUniswapV2Router02 {
152     function swapExactTokensForETHSupportingFeeOnTransferTokens(
153         uint256 amountIn,
154         uint256 amountOutMin,
155         address[] calldata path,
156         address to,
157         uint256 deadline
158     ) external;
159 
160     function factory() external pure returns (address);
161 
162     function WETH() external pure returns (address);
163 
164     function addLiquidityETH(
165         address token,
166         uint256 amountTokenDesired,
167         uint256 amountTokenMin,
168         uint256 amountETHMin,
169         address to,
170         uint256 deadline
171     )
172         external
173         payable
174         returns (
175             uint256 amountToken,
176             uint256 amountETH,
177             uint256 liquidity
178         );
179 }
180 
181 contract SWISSNFTFUND is Context, IERC20, Ownable {
182 
183     using SafeMath for uint256;
184 
185     string private constant _name = "Swiss NFT Fund";
186     string private constant _symbol = unicode"swissnftfund";
187     uint8 private constant _decimals = 9;
188 
189     mapping(address => uint256) private _rOwned;
190     mapping(address => uint256) private _tOwned;
191     mapping(address => mapping(address => uint256)) private _allowances;
192     mapping(address => bool) private _isExcludedFromFee;
193     uint256 private constant MAX = ~uint256(0);
194     uint256 private constant _tTotal = 1000000000 * 10**9;
195     uint256 private _rTotal = (MAX - (MAX % _tTotal));
196     uint256 private _tFeeTotal;
197 
198     // Taxes
199     uint256 private _redisFeeOnBuy = 2;
200     uint256 private _taxFeeOnBuy = 8;
201     uint256 private _redisFeeOnSell = 2;
202     uint256 private _taxFeeOnSell = 8;
203 
204     //Original Fee
205     uint256 private _redisFee = _redisFeeOnSell;
206     uint256 private _taxFee = _taxFeeOnSell;
207 
208     uint256 private _previousredisFee = _redisFee;
209     uint256 private _previoustaxFee = _taxFee;
210 
211     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
212     address payable private _developmentAddress = payable(0x975603Ae72f9551d26CeB27A00CD4452f8187768);
213     address payable private _marketingAddress = payable(0xb3881C420b80f148f7d82aA3CE7B9f664d4a2E33);
214 
215     IUniswapV2Router02 public uniswapV2Router;
216     address public uniswapV2Pair;
217 
218     bool private tradingOpen = true;
219     bool private inSwap = false;
220     bool private swapEnabled = true;
221 
222     uint256 public _maxTxAmount = 20000000 * 10**9; // 2%
223     uint256 public _maxWalletSize = 20000000 * 10**9; // 2%
224     uint256 public _swapTokensAtAmount = 15000 * 10**9; // .015%
225 
226     event MaxTxAmountUpdated(uint256 _maxTxAmount);
227     modifier lockTheSwap {
228         inSwap = true;
229         _;
230         inSwap = false;
231     }
232 
233     constructor() {
234 
235         _rOwned[_msgSender()] = _rTotal;
236 
237         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
238         uniswapV2Router = _uniswapV2Router;
239         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
240             .createPair(address(this), _uniswapV2Router.WETH());
241 
242         _isExcludedFromFee[owner()] = true;
243         _isExcludedFromFee[address(this)] = true;
244         _isExcludedFromFee[_developmentAddress] = true;
245         _isExcludedFromFee[_marketingAddress] = true;
246 
247         emit Transfer(address(0), _msgSender(), _tTotal);
248     }
249 
250     function name() public pure returns (string memory) {
251         return _name;
252     }
253 
254     function symbol() public pure returns (string memory) {
255         return _symbol;
256     }
257 
258     function decimals() public pure returns (uint8) {
259         return _decimals;
260     }
261 
262     function totalSupply() public pure override returns (uint256) {
263         return _tTotal;
264     }
265 
266     function balanceOf(address account) public view override returns (uint256) {
267         return tokenFromReflection(_rOwned[account]);
268     }
269 
270     function transfer(address recipient, uint256 amount)
271         public
272         override
273         returns (bool)
274     {
275         _transfer(_msgSender(), recipient, amount);
276         return true;
277     }
278 
279     function allowance(address owner, address spender)
280         public
281         view
282         override
283         returns (uint256)
284     {
285         return _allowances[owner][spender];
286     }
287 
288     function approve(address spender, uint256 amount)
289         public
290         override
291         returns (bool)
292     {
293         _approve(_msgSender(), spender, amount);
294         return true;
295     }
296 
297     function transferFrom(
298         address sender,
299         address recipient,
300         uint256 amount
301     ) public override returns (bool) {
302         _transfer(sender, recipient, amount);
303         _approve(
304             sender,
305             _msgSender(),
306             _allowances[sender][_msgSender()].sub(
307                 amount,
308                 "ERC20: transfer amount exceeds allowance"
309             )
310         );
311         return true;
312     }
313 
314     function tokenFromReflection(uint256 rAmount)
315         private
316         view
317         returns (uint256)
318     {
319         require(
320             rAmount <= _rTotal,
321             "Amount must be less than total reflections"
322         );
323         uint256 currentRate = _getRate();
324         return rAmount.div(currentRate);
325     }
326 
327     function removeAllFee() private {
328         if (_redisFee == 0 && _taxFee == 0) return;
329 
330         _previousredisFee = _redisFee;
331         _previoustaxFee = _taxFee;
332 
333         _redisFee = 0;
334         _taxFee = 0;
335     }
336 
337     function restoreAllFee() private {
338         _redisFee = _previousredisFee;
339         _taxFee = _previoustaxFee;
340     }
341 
342     function _approve(
343         address owner,
344         address spender,
345         uint256 amount
346     ) private {
347         require(owner != address(0), "ERC20: approve from the zero address");
348         require(spender != address(0), "ERC20: approve to the zero address");
349         _allowances[owner][spender] = amount;
350         emit Approval(owner, spender, amount);
351     }
352 
353     function _transfer(
354         address from,
355         address to,
356         uint256 amount
357     ) private {
358         require(from != address(0), "ERC20: transfer from the zero address");
359         require(to != address(0), "ERC20: transfer to the zero address");
360         require(amount > 0, "Transfer amount must be greater than zero");
361 
362         if (from != owner() && to != owner()) {
363 
364             //Trade start check
365             if (!tradingOpen) {
366                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
367             }
368 
369             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
370             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
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
432         _marketingAddress.transfer(amount);
433     }
434 
435     function setTrading(bool _tradingOpen) public onlyOwner {
436         tradingOpen = _tradingOpen;
437     }
438 
439     function manualswap() external {
440         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
441         uint256 contractBalance = balanceOf(address(this));
442         swapTokensForEth(contractBalance);
443     }
444 
445     function manualsend() external {
446         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
447         uint256 contractETHBalance = address(this).balance;
448         sendETHToFee(contractETHBalance);
449     }
450 
451     function blockBots(address[] memory bots_) public onlyOwner {
452         for (uint256 i = 0; i < bots_.length; i++) {
453             bots[bots_[i]] = true;
454         }
455     }
456 
457     function unblockBot(address notbot) public onlyOwner {
458         bots[notbot] = false;
459     }
460 
461     function _tokenTransfer(
462         address sender,
463         address recipient,
464         uint256 amount,
465         bool takeFee
466     ) private {
467         if (!takeFee) removeAllFee();
468         _transferStandard(sender, recipient, amount);
469         if (!takeFee) restoreAllFee();
470     }
471 
472     function _transferStandard(
473         address sender,
474         address recipient,
475         uint256 tAmount
476     ) private {
477         (
478             uint256 rAmount,
479             uint256 rTransferAmount,
480             uint256 rFee,
481             uint256 tTransferAmount,
482             uint256 tFee,
483             uint256 tTeam
484         ) = _getValues(tAmount);
485         _rOwned[sender] = _rOwned[sender].sub(rAmount);
486         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
487         _takeTeam(tTeam);
488         _reflectFee(rFee, tFee);
489         emit Transfer(sender, recipient, tTransferAmount);
490     }
491 
492     function _takeTeam(uint256 tTeam) private {
493         uint256 currentRate = _getRate();
494         uint256 rTeam = tTeam.mul(currentRate);
495         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
496     }
497 
498     function _reflectFee(uint256 rFee, uint256 tFee) private {
499         _rTotal = _rTotal.sub(rFee);
500         _tFeeTotal = _tFeeTotal.add(tFee);
501     }
502 
503     receive() external payable {}
504 
505     function _getValues(uint256 tAmount)
506         private
507         view
508         returns (
509             uint256,
510             uint256,
511             uint256,
512             uint256,
513             uint256,
514             uint256
515         )
516     {
517         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
518             _getTValues(tAmount, _redisFee, _taxFee);
519         uint256 currentRate = _getRate();
520         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
521             _getRValues(tAmount, tFee, tTeam, currentRate);
522         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
523     }
524 
525     function _getTValues(
526         uint256 tAmount,
527         uint256 redisFee,
528         uint256 taxFee
529     )
530         private
531         pure
532         returns (
533             uint256,
534             uint256,
535             uint256
536         )
537     {
538         uint256 tFee = tAmount.mul(redisFee).div(100);
539         uint256 tTeam = tAmount.mul(taxFee).div(100);
540         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
541         return (tTransferAmount, tFee, tTeam);
542     }
543 
544     function _getRValues(
545         uint256 tAmount,
546         uint256 tFee,
547         uint256 tTeam,
548         uint256 currentRate
549     )
550         private
551         pure
552         returns (
553             uint256,
554             uint256,
555             uint256
556         )
557     {
558         uint256 rAmount = tAmount.mul(currentRate);
559         uint256 rFee = tFee.mul(currentRate);
560         uint256 rTeam = tTeam.mul(currentRate);
561         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
562         return (rAmount, rTransferAmount, rFee);
563     }
564 
565     function _getRate() private view returns (uint256) {
566         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
567         return rSupply.div(tSupply);
568     }
569 
570     function _getCurrentSupply() private view returns (uint256, uint256) {
571         uint256 rSupply = _rTotal;
572         uint256 tSupply = _tTotal;
573         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
574         return (rSupply, tSupply);
575     }
576 
577     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
578         _redisFeeOnBuy = redisFeeOnBuy;
579         _redisFeeOnSell = redisFeeOnSell;
580         _taxFeeOnBuy = taxFeeOnBuy;
581         _taxFeeOnSell = taxFeeOnSell;
582     }
583 
584     //Set minimum tokens required to swap.
585     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
586         _swapTokensAtAmount = swapTokensAtAmount;
587     }
588 
589     //Set minimum tokens required to swap.
590     function toggleSwap(bool _swapEnabled) public onlyOwner {
591         swapEnabled = _swapEnabled;
592     }
593 
594     //Set maximum transaction
595     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
596         _maxTxAmount = maxTxAmount;
597     }
598 
599     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
600         _maxWalletSize = maxWalletSize;
601     }
602 
603     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
604         for(uint256 i = 0; i < accounts.length; i++) {
605             _isExcludedFromFee[accounts[i]] = excluded;
606         }
607     }
608 
609 }