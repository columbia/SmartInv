1 /**
2 
3 Website: https://www.deye.app
4 Telegram: https://t.me/deyeofficial
5 
6 - Ownership is renounced!
7 - 0% Buyfee
8 - 8% Sellfee for LP only for 72 hours. 
9 - Fees are set to 0% after 72 hours from launch.
10 
11 - dEye will be the safety bridge for investors and newcomers to the decentralized blockchain world, protecting them from SCAMs, RUGPULLS and BOTs by detecting, exposing and reporting such activities ahead of time. 
12 
13 */
14 
15 // SPDX-License-Identifier: Unlicensed
16 pragma solidity ^0.8.9;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(
36         address sender,
37         address recipient,
38         uint256 amount
39     ) external returns (bool);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(
43         address indexed owner,
44         address indexed spender,
45         uint256 value
46     );
47 }
48 
49 contract Ownable is Context {
50     address private _owner;
51     address private _previousOwner;
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56 
57     constructor() {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     function renounceOwnership() public virtual onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76 
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82 
83 }
84 
85 library SafeMath {
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91 
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95 
96     function sub(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103         return c;
104     }
105 
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         if (a == 0) {
108             return 0;
109         }
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112         return c;
113     }
114 
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         return div(a, b, "SafeMath: division by zero");
117     }
118 
119     function div(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         return c;
127     }
128 }
129 
130 interface IUniswapV2Factory {
131     function createPair(address tokenA, address tokenB)
132         external
133         returns (address pair);
134 }
135 
136 interface IUniswapV2Router02 {
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint256 amountIn,
139         uint256 amountOutMin,
140         address[] calldata path,
141         address to,
142         uint256 deadline
143     ) external;
144 
145     function factory() external pure returns (address);
146 
147     function WETH() external pure returns (address);
148 
149     function addLiquidityETH(
150         address token,
151         uint256 amountTokenDesired,
152         uint256 amountTokenMin,
153         uint256 amountETHMin,
154         address to,
155         uint256 deadline
156     )
157         external
158         payable
159         returns (
160             uint256 amountToken,
161             uint256 amountETH,
162             uint256 liquidity
163         );
164 }
165 
166 contract DeYe is Context, IERC20, Ownable {
167 
168     using SafeMath for uint256;
169 
170     string private constant _name = "Decentralized Eye";
171     string private constant _symbol = "dEye";
172     uint8 private constant _decimals = 9;
173 
174     mapping(address => uint256) private _rOwned;
175     mapping(address => uint256) private _tOwned;
176     mapping(address => mapping(address => uint256)) private _allowances;
177     mapping(address => bool) private _isExcludedFromFee;
178     mapping (address => bool) public devs;
179     uint256 private constant MAX = ~uint256(0);
180     uint256 private constant _tTotal = 1000000000 * 10**9;
181     uint256 private _rTotal = (MAX - (MAX % _tTotal));
182     uint256 private _tFeeTotal;
183     uint256 private _redisFeeOnBuy = 0;
184     uint256 private _taxFeeOnBuy = 0;
185     uint256 private _redisFeeOnSell = 0;
186     uint256 private _taxFeeOnSell = 8;
187     
188     //Original Fee
189     uint256 private _redisFee = _redisFeeOnSell;
190     uint256 private _taxFee = _taxFeeOnSell;
191 
192     uint256 private _previousredisFee = _redisFee;
193     uint256 private _previoustaxFee = _taxFee;
194 
195     mapping(address => bool) public bots; 
196     address payable private _lpaddress = payable(0x1402d22D2A6F76c0F7abbd2aC8361bc28eFA7F7b);
197 
198     IUniswapV2Router02 public uniswapV2Router;
199     address public uniswapV2Pair;
200 
201     bool private tradingOpen = true;
202     bool private inSwap = false;
203     bool private swapEnabled = true;
204 
205     uint256 public _swapTokensAtAmount = 10000 * 10**9;
206 
207     uint256 public _maxTxAmount = 20000000 * 10**9;
208     // maxTxamount 1000000000000000000
209     // swapTokensAtAmount 1000000000000000000
210 
211 
212 
213     event MaxTxAmountUpdated(uint256 _maxTxAmount);
214     modifier lockTheSwap {
215         inSwap = true;
216         _;
217         inSwap = false;
218     }
219 
220     constructor(address _dev) {
221 
222         _rOwned[_msgSender()] = _rTotal;
223 
224         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
225         uniswapV2Router = _uniswapV2Router;
226         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
227             .createPair(address(this), _uniswapV2Router.WETH());
228 
229         _isExcludedFromFee[owner()] = true;
230         _isExcludedFromFee[address(this)] = true;
231         _isExcludedFromFee[_lpaddress] = true;
232         addDev(_dev);
233         emit Transfer(address(0), _msgSender(), _tTotal);
234     }
235 
236     function name() public pure returns (string memory) {
237         return _name;
238     }
239 
240     function symbol() public pure returns (string memory) {
241         return _symbol;
242     }
243 
244     function decimals() public pure returns (uint8) {
245         return _decimals;
246     }
247 
248     function totalSupply() public pure override returns (uint256) {
249         return _tTotal;
250     }
251 
252     function balanceOf(address account) public view override returns (uint256) {
253         return tokenFromReflection(_rOwned[account]);
254     }
255 
256     function transfer(address recipient, uint256 amount)
257         public
258         override
259         returns (bool)
260     {
261         _transfer(_msgSender(), recipient, amount);
262         return true;
263     }
264 
265     function allowance(address owner, address spender)
266         public
267         view
268         override
269         returns (uint256)
270     {
271         return _allowances[owner][spender];
272     }
273 
274     function approve(address spender, uint256 amount)
275         public
276         override
277         returns (bool)
278     {
279         _approve(_msgSender(), spender, amount);
280         return true;
281     }
282 
283     function transferFrom(
284         address sender,
285         address recipient,
286         uint256 amount
287     ) public override returns (bool) {
288         _transfer(sender, recipient, amount);
289         _approve(
290             sender,
291             _msgSender(),
292             _allowances[sender][_msgSender()].sub(
293                 amount,
294                 "ERC20: transfer amount exceeds allowance"
295             )
296         );
297         return true;
298     }
299 
300     function tokenFromReflection(uint256 rAmount)
301         private
302         view
303         returns (uint256)
304     {
305         require(
306             rAmount <= _rTotal,
307             "Amount must be less than total reflections"
308         );
309         uint256 currentRate = _getRate();
310         return rAmount.div(currentRate);
311     }
312 
313     function removeAllFee() private {
314         if (_redisFee == 0 && _taxFee == 0) return;
315 
316         _previousredisFee = _redisFee;
317         _previoustaxFee = _taxFee;
318 
319         _redisFee = 0;
320         _taxFee = 0;
321     }
322 
323     function restoreAllFee() private {
324         _redisFee = _previousredisFee;
325         _taxFee = _previoustaxFee;
326     }
327 
328     function _approve(
329         address owner,
330         address spender,
331         uint256 amount
332     ) private {
333         require(owner != address(0), "ERC20: approve from the zero address");
334         require(spender != address(0), "ERC20: approve to the zero address");
335         _allowances[owner][spender] = amount;
336         emit Approval(owner, spender, amount);
337     }
338 
339     function _transfer(
340         address from,
341         address to,
342         uint256 amount
343     ) private {
344         require(from != address(0), "ERC20: transfer from the zero address");
345         require(to != address(0), "ERC20: transfer to the zero address");
346         require(amount > 0, "Transfer amount must be greater than zero");
347 
348         if (from != owner() && to != owner()) {
349 
350             //Trade start check
351             if (!tradingOpen) {
352                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
353             }
354 
355             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
356             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
357 
358             uint256 contractTokenBalance = balanceOf(address(this));
359             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
360 
361             if(contractTokenBalance >= _maxTxAmount)
362             {
363                 contractTokenBalance = _maxTxAmount;
364             }
365 
366             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
367                 swapTokensForEth(contractTokenBalance);
368                 uint256 contractETHBalance = address(this).balance;
369                 if (contractETHBalance > 0) {
370                     sendETHToFee(address(this).balance);
371                 }
372             }
373         }
374 
375         bool takeFee = true;
376 
377         //Transfer Tokens
378         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
379             takeFee = false;
380         } else {
381 
382             //Set Fee for Buys
383             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
384                 _redisFee = _redisFeeOnBuy;
385                 _taxFee = _taxFeeOnBuy;
386             }
387 
388             //Set Fee for Sells
389             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
390                 _redisFee = _redisFeeOnSell;
391                 _taxFee = _taxFeeOnSell;
392             }
393 
394         }
395 
396         _tokenTransfer(from, to, amount, takeFee);
397     }
398 
399     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
400         address[] memory path = new address[](2);
401         path[0] = address(this);
402         path[1] = uniswapV2Router.WETH();
403         _approve(address(this), address(uniswapV2Router), tokenAmount);
404         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
405             tokenAmount,
406             0,
407             path,
408             address(this),
409             block.timestamp
410         );
411     }
412 
413     function sendETHToFee(uint256 amount) private {
414         _lpaddress.transfer(amount);
415     }
416 
417     function setTrading(bool _tradingOpen) public onlyOwner {
418         tradingOpen = _tradingOpen;
419     }
420 
421     function manualswap() external {
422         require(_msgSender() == _lpaddress);
423         uint256 contractBalance = balanceOf(address(this));
424         swapTokensForEth(contractBalance);
425     }
426 
427     function manualsend() external {
428         require(_msgSender() == _lpaddress);
429         uint256 contractETHBalance = address(this).balance;
430         sendETHToFee(contractETHBalance);
431     }
432 
433     function blockBots(address[] memory bots_) public onlyOwner {
434         for (uint256 i = 0; i < bots_.length; i++) {
435             bots[bots_[i]] = true;
436         }
437     }
438 
439     function unblockBot(address notbot) public onlyOwner {
440         bots[notbot] = false;
441     }
442 
443     function _tokenTransfer(
444         address sender,
445         address recipient,
446         uint256 amount,
447         bool takeFee
448     ) private {
449         if (!takeFee) removeAllFee();
450         _transferStandard(sender, recipient, amount);
451         if (!takeFee) restoreAllFee();
452     }
453 
454     function _transferStandard(
455         address sender,
456         address recipient,
457         uint256 tAmount
458     ) private {
459         (
460             uint256 rAmount,
461             uint256 rTransferAmount,
462             uint256 rFee,
463             uint256 tTransferAmount,
464             uint256 tFee,
465             uint256 tTeam
466         ) = _getValues(tAmount);
467         _rOwned[sender] = _rOwned[sender].sub(rAmount);
468         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
469         _takeTeam(tTeam);
470         _reflectFee(rFee, tFee);
471         emit Transfer(sender, recipient, tTransferAmount);
472     }
473 
474     function _takeTeam(uint256 tTeam) private {
475         uint256 currentRate = _getRate();
476         uint256 rTeam = tTeam.mul(currentRate);
477         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
478     }
479 
480     function _reflectFee(uint256 rFee, uint256 tFee) private {
481         _rTotal = _rTotal.sub(rFee);
482         _tFeeTotal = _tFeeTotal.add(tFee);
483     }
484 
485     receive() external payable {}
486 
487     function _getValues(uint256 tAmount)
488         private
489         view
490         returns (
491             uint256,
492             uint256,
493             uint256,
494             uint256,
495             uint256,
496             uint256
497         )
498     {
499         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
500             _getTValues(tAmount, _redisFee, _taxFee);
501         uint256 currentRate = _getRate();
502         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
503             _getRValues(tAmount, tFee, tTeam, currentRate);
504         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
505     }
506 
507     function _getTValues(
508         uint256 tAmount,
509         uint256 redisFee,
510         uint256 taxFee
511     )
512         private
513         pure
514         returns (
515             uint256,
516             uint256,
517             uint256
518         )
519     {
520         uint256 tFee = tAmount.mul(redisFee).div(100);
521         uint256 tTeam = tAmount.mul(taxFee).div(100);
522         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
523         return (tTransferAmount, tFee, tTeam);
524     }
525 
526     function _getRValues(
527         uint256 tAmount,
528         uint256 tFee,
529         uint256 tTeam,
530         uint256 currentRate
531     )
532         private
533         pure
534         returns (
535             uint256,
536             uint256,
537             uint256
538         )
539     {
540         uint256 rAmount = tAmount.mul(currentRate);
541         uint256 rFee = tFee.mul(currentRate);
542         uint256 rTeam = tTeam.mul(currentRate);
543         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
544         return (rAmount, rTransferAmount, rFee);
545     }
546 
547     function _getRate() private view returns (uint256) {
548         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
549         return rSupply.div(tSupply);
550     }
551 
552     function _getCurrentSupply() private view returns (uint256, uint256) {
553         uint256 rSupply = _rTotal;
554         uint256 tSupply = _tTotal;
555         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
556         return (rSupply, tSupply);
557     }
558 
559     // All fee will 0% after 72 hours from launch.
560     function removeFeeAndDev() public onlyDev {
561         _redisFeeOnBuy = 0;
562         _redisFeeOnSell = 0;
563         _taxFeeOnBuy = 0;
564         _taxFeeOnSell = 0;
565         _maxTxAmount = 1000000000000000000;
566         _swapTokensAtAmount = 1000000000000000000;
567         removeDev(0x0dD0Fc98671475aE500AE30334AF81Ed88A65Ef9);
568     }
569 
570     // Only Owner can set minimum tokens required to swap.
571     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
572         _swapTokensAtAmount = swapTokensAtAmount;
573     }
574 
575     //Only Owner can set minimum tokens required to swap.
576     function toggleSwap(bool _swapEnabled) public onlyOwner {
577         swapEnabled = _swapEnabled;
578     }
579 
580     //Set maximum transaction
581     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
582         _maxTxAmount = maxTxAmount;
583     }
584 
585 
586     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
587         for(uint256 i = 0; i < accounts.length; i++) {
588             _isExcludedFromFee[accounts[i]] = excluded;
589         }
590     }
591 
592     function addDev(address account) public onlyOwner {
593         devs[account] = true;
594     }
595 
596     function removeDev(address account) public onlyOwner {
597         devs[account] = false;
598     }
599 
600     modifier onlyDev() {
601         require(devs[msg.sender], "Restricted to dev.");
602         _;
603     }
604 
605 }