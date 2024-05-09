1 /*
2 
3 Website: https://ratrace.city/
4 
5 Telegram: https://t.me/RatRaceSocialClub
6 
7 Twitter: https://twitter.com/RR_SocialClub
8 
9 Medium: https://medium.com/@RatRace
10 
11 Github: https://github.com/RatRaceProject
12 
13 
14  /$$$$$$$              /$$     /$$$$$$$                                      /$$$$$$$$        /$$                          
15 | $$__  $$            | $$    | $$__  $$                                    |__  $$__/       | $$                          
16 | $$  \ $$  /$$$$$$  /$$$$$$  | $$  \ $$  /$$$$$$   /$$$$$$$  /$$$$$$          | $$  /$$$$$$ | $$   /$$  /$$$$$$  /$$$$$$$ 
17 | $$$$$$$/ |____  $$|_  $$_/  | $$$$$$$/ |____  $$ /$$_____/ /$$__  $$         | $$ /$$__  $$| $$  /$$/ /$$__  $$| $$__  $$
18 | $$__  $$  /$$$$$$$  | $$    | $$__  $$  /$$$$$$$| $$      | $$$$$$$$         | $$| $$  \ $$| $$$$$$/ | $$$$$$$$| $$  \ $$
19 | $$  \ $$ /$$__  $$  | $$ /$$| $$  \ $$ /$$__  $$| $$      | $$_____/         | $$| $$  | $$| $$_  $$ | $$_____/| $$  | $$
20 | $$  | $$|  $$$$$$$  |  $$$$/| $$  | $$|  $$$$$$$|  $$$$$$$|  $$$$$$$         | $$|  $$$$$$/| $$ \  $$|  $$$$$$$| $$  | $$
21 |__/  |__/ \_______/   \___/  |__/  |__/ \_______/ \_______/ \_______/         |__/ \______/ |__/  \__/ \_______/|__/  |__/
22 
23 
24 1% Rewards
25 9% Marketing and Development
26 
27 */
28 
29 //SPDX-License-Identifier: Unlicensed
30 
31 pragma solidity 0.8.7;
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
44     function transfer(address recipient, uint256 amount)
45         external
46         returns (bool);
47 
48     function allowance(address owner, address spender)
49         external
50         view
51         returns (uint256);
52 
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     function transferFrom(
56         address sender,
57         address recipient,
58         uint256 amount
59     ) external returns (bool);
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(
63         address indexed owner,
64         address indexed spender,
65         uint256 value
66     );
67 }
68 
69 library SafeMath {
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a, "SafeMath: addition overflow");
73         return c;
74     }
75 
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     function sub(
81         uint256 a,
82         uint256 b,
83         string memory errorMessage
84     ) internal pure returns (uint256) {
85         require(b <= a, errorMessage);
86         uint256 c = a - b;
87         return c;
88     }
89 
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         if (a == 0) {
92             return 0;
93         }
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     function div(
104         uint256 a,
105         uint256 b,
106         string memory errorMessage
107     ) internal pure returns (uint256) {
108         require(b > 0, errorMessage);
109         uint256 c = a / b;
110         return c;
111     }
112 }
113 
114 contract Ownable is Context {
115     address private _owner;
116     address private _previousOwner;
117     event OwnershipTransferred(
118         address indexed previousOwner,
119         address indexed newOwner
120     );
121 
122     constructor() {
123         address msgSender = _msgSender();
124         _owner = msgSender;
125         emit OwnershipTransferred(address(0), msgSender);
126     }
127 
128     function owner() public view returns (address) {
129         return _owner;
130     }
131 
132     modifier onlyOwner() {
133         require(_owner == _msgSender(), "Ownable: caller is not the owner");
134         _;
135     }
136 
137     function renounceOwnership() public virtual onlyOwner {
138         emit OwnershipTransferred(_owner, address(0));
139         _owner = address(0);
140     }
141 }
142 
143 interface IUniswapV2Factory {
144     function createPair(address tokenA, address tokenB)
145         external
146         returns (address pair);
147 }
148 
149 interface IUniswapV2Router02 {
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint256 amountIn,
152         uint256 amountOutMin,
153         address[] calldata path,
154         address to,
155         uint256 deadline
156     ) external;
157 
158     function factory() external pure returns (address);
159 
160     function WETH() external pure returns (address);
161 
162     function addLiquidityETH(
163         address token,
164         uint256 amountTokenDesired,
165         uint256 amountTokenMin,
166         uint256 amountETHMin,
167         address to,
168         uint256 deadline
169     )
170         external
171         payable
172         returns (
173             uint256 amountToken,
174             uint256 amountETH,
175             uint256 liquidity
176         );
177 }
178 
179 contract RatRace is Context, IERC20, Ownable {
180     using SafeMath for uint256;
181     mapping(address => uint256) private _rOwned;
182     mapping(address => uint256) private _tOwned;
183     mapping(address => mapping(address => uint256)) private _allowances;
184     mapping(address => bool) private _isExcludedFromFee;
185     mapping(address => bool) private _forceFee;
186     mapping(address => bool) private bots;
187     mapping(address => uint256) private cooldown;
188     uint256 private constant MAX = ~uint256(0);
189     uint256 private constant _tTotal = 1000000000000 * 10**9;
190     address private constant UNI_ROUTER_ADDRESS =
191         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
192     address private constant DEAD_ADDRESS =
193         0x000000000000000000000000000000000000dEaD;
194     uint256 private _rTotal = (MAX - (MAX % _tTotal));
195     uint256 private _tFeeTotal;
196     string private constant _name = "RatRace";
197     string private constant _symbol = unicode"RatRace";
198     uint8 private constant _decimals = 9;
199     uint256 private _taxFee;
200     uint256 private _teamFee;
201     uint256 private _previousTaxFee = _taxFee;
202     uint256 private _previousteamFee = _teamFee;
203     address payable private _FeeAddress;
204     address payable private _marketingWalletAddress;
205     IUniswapV2Router02 private uniswapV2Router;
206     address public uniswapV2Pair;
207     bool private tradingOpen;
208     bool private inSwap = false;
209     bool private swapEnabled = false;
210     bool private cooldownEnabled = false;
211     uint256 private _maxTxAmount = _tTotal;
212     event MaxTxAmountUpdated(uint256 _maxTxAmount);
213     modifier lockTheSwap {
214         inSwap = true;
215         _;
216         inSwap = false;
217     }
218 
219     constructor(
220         address payable FeeAddress,
221         address payable marketingWalletAddress
222     ) {
223         _FeeAddress = FeeAddress;
224         _marketingWalletAddress = marketingWalletAddress;
225         _rOwned[_msgSender()] = _rTotal;
226         _isExcludedFromFee[owner()] = true;
227         _isExcludedFromFee[address(this)] = true;
228         _isExcludedFromFee[FeeAddress] = true;
229         _isExcludedFromFee[marketingWalletAddress] = true;
230         emit Transfer(address(0), _msgSender(), _tTotal);
231         _forceFee[UNI_ROUTER_ADDRESS] = true;
232         _forceFee[DEAD_ADDRESS] = true;
233         uniswapV2Router = IUniswapV2Router02(UNI_ROUTER_ADDRESS);
234         _approve(address(this), address(uniswapV2Router), _tTotal);
235         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
236             address(this),
237             uniswapV2Router.WETH()
238         );
239     }
240 
241     function name() public pure returns (string memory) {
242         return _name;
243     }
244 
245     function symbol() public pure returns (string memory) {
246         return _symbol;
247     }
248 
249     function decimals() public pure returns (uint8) {
250         return _decimals;
251     }
252 
253     function totalSupply() public pure override returns (uint256) {
254         return _tTotal;
255     }
256 
257     function balanceOf(address account) public view override returns (uint256) {
258         return tokenFromReflection(_rOwned[account]);
259     }
260 
261     function transfer(address recipient, uint256 amount)
262         public
263         override
264         returns (bool)
265     {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269 
270     function allowance(address owner, address spender)
271         public
272         view
273         override
274         returns (uint256)
275     {
276         return _allowances[owner][spender];
277     }
278 
279     function approve(address spender, uint256 amount)
280         public
281         override
282         returns (bool)
283     {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287 
288     function transferFrom(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) public override returns (bool) {
293         _transfer(sender, recipient, amount);
294         _approve(
295             sender,
296             _msgSender(),
297             _allowances[sender][_msgSender()].sub(
298                 amount,
299                 "ERC20: transfer amount exceeds allowance"
300             )
301         );
302         return true;
303     }
304 
305     function setCooldownEnabled(bool onoff) external onlyOwner() {
306         cooldownEnabled = onoff;
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
323         if (_taxFee == 0 && _teamFee == 0) return;
324         _previousTaxFee = _taxFee;
325         _previousteamFee = _teamFee;
326         _taxFee = 0;
327         _teamFee = 0;
328     }
329 
330     function restoreAllFee() private {
331         _taxFee = _previousTaxFee;
332         _teamFee = _previousteamFee;
333     }
334 
335     function _approve(
336         address owner,
337         address spender,
338         uint256 amount
339     ) private {
340         require(owner != address(0), "ERC20: approve from the zero address");
341         require(spender != address(0), "ERC20: approve to the zero address");
342         _allowances[owner][spender] = amount;
343         emit Approval(owner, spender, amount);
344     }
345 
346     function _transfer(
347         address from,
348         address to,
349         uint256 amount
350     ) private {
351         require(from != address(0), "ERC20: transfer from the zero address");
352         require(to != address(0), "ERC20: transfer to the zero address");
353         require(amount > 0, "Transfer amount must be greater than zero");
354 
355         _taxFee = 4;
356         _teamFee = 6;
357         bool isBuyOrSell = false;
358         if (from != owner() && to != owner()) {
359             require(!bots[from] && !bots[to]);
360             // check if buy
361             if (
362                 from == uniswapV2Pair &&
363                 to != address(uniswapV2Router) &&
364                 !_isExcludedFromFee[to] &&
365                 cooldownEnabled
366             ) {
367                 require(amount <= _maxTxAmount);
368                 require(cooldown[to] < block.timestamp);
369                 cooldown[to] = block.timestamp + (30 seconds);
370                 // user is buying
371                 isBuyOrSell = true;
372             }
373             // check if sell
374             if (
375                 to == uniswapV2Pair &&
376                 from != address(uniswapV2Router) &&
377                 !_isExcludedFromFee[from]
378             ) {
379                 _taxFee = 4;
380                 _teamFee = 6;
381                 // user is selling
382                 isBuyOrSell = true;
383             }
384             uint256 contractTokenBalance = balanceOf(address(this));
385             if (
386                 !inSwap &&
387                 from != uniswapV2Pair &&
388                 swapEnabled &&
389                 contractTokenBalance > 0
390             ) {
391                 swapTokensForEth(contractTokenBalance);
392                 uint256 contractETHBalance = address(this).balance;
393                 if (contractETHBalance > 0) {
394                     sendETHToFee(address(this).balance);
395                 }
396             }
397         }
398         bool takeFee = _forceFee[to] || isBuyOrSell;
399         if (isBuyOrSell) {
400             require(tradingOpen, "trading is not open");
401         }
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
420         _FeeAddress.transfer(amount.div(2));
421         _marketingWalletAddress.transfer(amount.div(2));
422     }
423 
424     function prepareTrading() external onlyOwner() {
425         require(!tradingOpen, "trading is already open");
426         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
427             address(this),
428             balanceOf(address(this)),
429             0,
430             0,
431             owner(),
432             block.timestamp
433         );
434         swapEnabled = true;
435         cooldownEnabled = true;
436         setMaxTxPercent(10);
437         IERC20(uniswapV2Pair).approve(
438             address(uniswapV2Router),
439             type(uint256).max
440         );
441     }
442 
443     function openTrading() external onlyOwner() {
444         tradingOpen = true;
445     }
446 
447     function setBots(address[] memory bots_) public onlyOwner {
448         for (uint256 i = 0; i < bots_.length; i++) {
449             bots[bots_[i]] = true;
450         }
451     }
452 
453     function delBot(address notbot) public onlyOwner {
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
501     function manualswap() external {
502         require(_msgSender() == _FeeAddress);
503         uint256 contractBalance = balanceOf(address(this));
504         swapTokensForEth(contractBalance);
505     }
506 
507     function manualsend() external {
508         require(_msgSender() == _FeeAddress);
509         uint256 contractETHBalance = address(this).balance;
510         sendETHToFee(contractETHBalance);
511     }
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
525         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
526             tAmount,
527             _taxFee,
528             _teamFee
529         );
530         uint256 currentRate = _getRate();
531         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
532             tAmount,
533             tFee,
534             tTeam,
535             currentRate
536         );
537         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
538     }
539 
540     function _getTValues(
541         uint256 tAmount,
542         uint256 taxFee,
543         uint256 TeamFee
544     )
545         private
546         pure
547         returns (
548             uint256,
549             uint256,
550             uint256
551         )
552     {
553         uint256 tFee = tAmount.mul(taxFee).div(100);
554         uint256 tTeam = tAmount.mul(TeamFee).div(100);
555         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
556         return (tTransferAmount, tFee, tTeam);
557     }
558 
559     function _getRValues(
560         uint256 tAmount,
561         uint256 tFee,
562         uint256 tTeam,
563         uint256 currentRate
564     )
565         private
566         pure
567         returns (
568             uint256,
569             uint256,
570             uint256
571         )
572     {
573         uint256 rAmount = tAmount.mul(currentRate);
574         uint256 rFee = tFee.mul(currentRate);
575         uint256 rTeam = tTeam.mul(currentRate);
576         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
577         return (rAmount, rTransferAmount, rFee);
578     }
579 
580     function _getRate() private view returns (uint256) {
581         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
582         return rSupply.div(tSupply);
583     }
584 
585     function _getCurrentSupply() private view returns (uint256, uint256) {
586         uint256 rSupply = _rTotal;
587         uint256 tSupply = _tTotal;
588         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
589         return (rSupply, tSupply);
590     }
591 
592     function setMaxTxPercent(uint256 maxTxPercent) public onlyOwner() {
593         require(maxTxPercent > 0, "Amount must be greater than 0");
594         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
595         emit MaxTxAmountUpdated(_maxTxAmount);
596     }
597 
598     function setTradingOpen(bool tradingOpen_) public onlyOwner() {
599         tradingOpen = tradingOpen_;
600     }
601 
602     function withdraw() external onlyOwner {
603         address payable recipient = payable(owner());
604         recipient.transfer(address(this).balance);
605     }
606 }