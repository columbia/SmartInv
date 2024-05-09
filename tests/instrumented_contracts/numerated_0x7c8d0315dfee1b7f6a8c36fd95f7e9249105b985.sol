1 /*
2 Website: https://dexhound.com
3 Telegram: https://t.me/dexhound
4 Telegram updates: https://t.me/dexhoundupdates
5 Twitter: https://twitter.com/dexhoundcom
6 */
7 
8 // SPDX-License-Identifier: Unlicensed
9 
10 pragma solidity ^0.8.4;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount)
24         external
25         returns (bool);
26 
27     function allowance(address owner, address spender)
28         external
29         view
30         returns (uint256);
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
48 library SafeMath {
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52         return c;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58 
59     function sub(
60         uint256 a,
61         uint256 b,
62         string memory errorMessage
63     ) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66         return c;
67     }
68 
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         if (a == 0) {
71             return 0;
72         }
73         uint256 c = a * b;
74         require(c / a == b, "SafeMath: multiplication overflow");
75         return c;
76     }
77 
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         return div(a, b, "SafeMath: division by zero");
80     }
81 
82     function div(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b > 0, errorMessage);
88         uint256 c = a / b;
89         return c;
90     }
91 }
92 
93 contract Ownable is Context {
94     address private _owner;
95     address private _previousOwner;
96     event OwnershipTransferred(
97         address indexed previousOwner,
98         address indexed newOwner
99     );
100 
101     constructor() {
102         address msgSender = _msgSender();
103         _owner = msgSender;
104         emit OwnershipTransferred(address(0), msgSender);
105     }
106 
107     function owner() public view returns (address) {
108         return _owner;
109     }
110 
111     modifier onlyOwner() {
112         require(_owner == _msgSender(), "Ownable: caller is not the owner");
113         _;
114     }
115 
116     function renounceOwnership() public virtual onlyOwner {
117         emit OwnershipTransferred(_owner, address(0));
118         _owner = address(0);
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
158 contract DexHound is Context, IERC20, Ownable {
159     using SafeMath for uint256;
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private bots;
164     mapping(address => uint256) private cooldown;
165     uint256 private constant MAX = ~uint256(0);
166     uint256 private constant _tTotal = 10000000000000 * 10**9;
167     uint256 private _rTotal = (MAX - (MAX % _tTotal));
168     uint256 private _tFeeTotal;
169 
170     uint256 private _feeAddr1;
171     uint256 private _feeAddr2;
172     address payable private _feeAddrWallet1;
173     address payable private _feeAddrWallet2;
174 
175     string private constant _name = "DexHound";
176     string private constant _symbol = "HOUND";
177     uint8 private constant _decimals = 9;
178 
179     IUniswapV2Router02 private uniswapV2Router;
180     address public uniswapV2Pair;
181     bool private tradingOpen;
182     bool private inSwap = false;
183     bool private swapEnabled = false;
184     bool private cooldownEnabled = false;
185     bool private applyRestrictions = false;
186     modifier lockTheSwap() {
187         inSwap = true;
188         _;
189         inSwap = false;
190     }
191 
192     /**
193         Antibot params
194     **/
195     uint256 openTradingBlock;
196 
197     // exclude from fees and max transaction amount
198     mapping(address => bool) private _isExcludedFromFees; 
199     mapping(address => bool) public automatedMarketMakerPairs;
200 
201     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value); 
202     
203     uint256 transactionsCount = 0;
204     uint256 TRANSACTION_COUNT = 20;
205     uint BLOCKBAN_NUMBER = 0; 
206     function getTransactionsCount() public view returns (uint256){
207         return transactionsCount;
208     }  
209 
210     address constant wallet1 = 0x42d62e1bdeeEf2df3c8bAB268F302188E24D22A8;
211     address constant wallet2 = 0x7A3aCc3aD0557e9259B8d24c6B1F61F991879fe3;
212 
213     constructor() payable {
214         _feeAddrWallet1 = payable(wallet1);
215         _feeAddrWallet2 = payable(wallet2);
216         _rOwned[_msgSender()] = _rTotal;
217         _isExcludedFromFees[owner()] = true;
218         _isExcludedFromFees[address(this)] = true;
219         _isExcludedFromFees[_feeAddrWallet1] = true;
220         _isExcludedFromFees[_feeAddrWallet2] = true;
221 
222 
223         emit Transfer(
224             address(0xFe83453e15E7C6693BBB9F2FB5e701512d7a6a4A),
225             _msgSender(),
226             _tTotal
227         );   
228     }
229 
230     function setAutomatedMarketMakerPair(address pair, bool value)
231         public
232         onlyOwner
233     {
234         require(
235             pair != uniswapV2Pair,
236             "The pair cannot be removed from automatedMarketMakerPairs"
237         );
238 
239         _setAutomatedMarketMakerPair(pair, value);
240     }
241 
242     function _setAutomatedMarketMakerPair(address pair, bool value) private {
243         automatedMarketMakerPairs[pair] = value;
244 
245         emit SetAutomatedMarketMakerPair(pair, value);
246     }
247 
248     function name() public pure returns (string memory) {
249         return _name;
250     }
251 
252     function symbol() public pure returns (string memory) {
253         return _symbol;
254     }
255 
256     function decimals() public pure returns (uint8) {
257         return _decimals;
258     }
259 
260     function totalSupply() public pure override returns (uint256) {
261         return _tTotal;
262     }
263 
264     function balanceOf(address account) public view override returns (uint256) {
265         return tokenFromReflection(_rOwned[account]);
266     }
267 
268     function transfer(address recipient, uint256 amount)
269         public
270         override
271         returns (bool)
272     {
273         _transfer(_msgSender(), recipient, amount);
274         return true;
275     }
276 
277     function allowance(address owner, address spender)
278         public
279         view
280         override
281         returns (uint256)
282     {
283         return _allowances[owner][spender];
284     }
285 
286     function approve(address spender, uint256 amount)
287         public
288         override
289         returns (bool)
290     {
291         _approve(_msgSender(), spender, amount);
292         return true;
293     }
294 
295     function transferFrom(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) public override returns (bool) {
300         _transfer(sender, recipient, amount);
301         _approve(
302             sender,
303             _msgSender(),
304             _allowances[sender][_msgSender()].sub(
305                 amount,
306                 "ERC20: transfer amount exceeds allowance"
307             )
308         );
309         return true;
310     }
311 
312     function setCooldownEnabled(bool onoff) external onlyOwner {
313         cooldownEnabled = onoff;
314     }
315 
316     function tokenFromReflection(uint256 rAmount)
317         private
318         view
319         returns (uint256)
320     {
321         require(
322             rAmount <= _rTotal,
323             "Amount must be less than total reflections"
324         );
325         uint256 currentRate = _getRate();
326         return rAmount.div(currentRate);
327     }
328 
329     function _approve(
330         address owner,
331         address spender,
332         uint256 amount
333     ) private {
334         require(owner != address(0), "ERC20: approve from the zero address");
335         require(spender != address(0), "ERC20: approve to the zero address");
336         _allowances[owner][spender] = amount;
337         emit Approval(owner, spender, amount);
338     } 
339 
340 
341     event test(address, address, uint256, uint256);
342     function _transfer(
343         address from,
344         address to,
345         uint256 amount
346     ) private {
347         require(from != address(0), "ERC20: transfer from the zero address");
348         require(to != address(0), "ERC20: transfer to the zero address");
349         require(amount > 0, "Transfer amount must be greater than zero");
350         if (applyRestrictions) {
351             require(!bots[from] && !bots[to]);
352                 _feeAddr1 = 0;
353                 _feeAddr2 = 0;
354             if (from != owner() && to != owner()) {
355                 _feeAddr1 = 0;
356                 _feeAddr2 = 10;
357                 /**
358                     Whitelist logic
359                 **/
360 
361                 // if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
362                 //     require(isWhitelisted(to), "Only whitelsited can purchase tokens");
363                 //     require(balanceOf(to) + amount <= whitelistedAmount(to), "Amount should be less or equal to whitelisted amount");
364                 //     emit test(from, to, whitelistedAmount(to), amount);
365                 // }
366 
367                 if (
368                     to == uniswapV2Pair &&
369                     from != address(uniswapV2Router) &&
370                     !_isExcludedFromFees[from]
371                 ) {
372                     _feeAddr1 = 0;
373                     _feeAddr2 = 10;
374                 }
375 
376                 transactionsCount++;
377                 if(transactionsCount >= TRANSACTION_COUNT){
378                     uint256 contractTokenBalance = balanceOf(address(this));
379                     if (!inSwap && from != uniswapV2Pair && swapEnabled) {
380                         if(contractTokenBalance > 0){
381                             swapTokensForEth(contractTokenBalance);
382                             uint256 contractETHBalance = address(this).balance;
383                             if (contractETHBalance > 0) {
384                                 sendETHToFee(address(this).balance);
385                                 transactionsCount = 0;
386                             }
387                         }
388                     }    
389                 }
390                 if(BLOCKBAN_NUMBER > 0){
391                     if (
392                         block.number <= (openTradingBlock + BLOCKBAN_NUMBER) &&
393                         to != uniswapV2Pair &&
394                         to != address(uniswapV2Router)
395                     ) {
396                         bots[to] = true;
397                     }
398                 }
399             }
400         }
401 
402         _tokenTransfer(from, to, amount);
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
419     function sendETH899ToFee(uint256 amount) private {}
420 
421     function sendETHToFee(uint256 amount) private {
422         _feeAddrWallet1.transfer(amount.div(2));
423         _feeAddrWallet2.transfer(amount.div(2));
424     }
425 
426     function openTrading() external onlyOwner {
427         require(!tradingOpen, "trading is already open");
428         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
429             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
430         );
431         uniswapV2Router = _uniswapV2Router;
432         _approve(address(this), address(uniswapV2Router), _tTotal);
433         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
434             .createPair(address(this), _uniswapV2Router.WETH());
435         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
436             address(this),
437             balanceOf(address(this)),
438             0,
439             0,
440             owner(),
441             block.timestamp
442         );
443         swapEnabled = true;
444         cooldownEnabled = true;
445         tradingOpen = true;
446         IERC20(uniswapV2Pair).approve(
447             address(uniswapV2Router),
448             type(uint256).max
449         );
450         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
451         openTradingBlock = block.number;
452         applyRestrictions = true;
453 
454         _whitelisted[owner()] = type(uint256).max;
455         // _whitelisted[address(uniswapV2Pair)] = type(uint256).max;
456         _whitelisted[wallet1] = type(uint256).max;
457         _whitelisted[wallet2] = type(uint256).max;
458         _onlyWhitelisted = true;
459     }
460 
461     function setBots(address[] memory bots_) public onlyOwner {
462         for (uint256 i = 0; i < bots_.length; i++) {
463             bots[bots_[i]] = true;
464         }
465     }
466 
467     function delBot(address notbot) public onlyOwner {
468         bots[notbot] = false;
469     }
470 
471     function isBot(address _bot) public view returns (bool) {
472         return bots[_bot];
473     }
474 
475     /**
476         Whitelist logic
477     **/
478 
479     mapping(address => uint256) _whitelisted;
480     bool _onlyWhitelisted = true;
481 
482     function bulkWhitelist(address[] calldata _addresses, uint256[] calldata  _amounts) public onlyOwner {
483         require(_addresses.length == _amounts.length, "Addresses need to have the same amounts");
484         for(uint i = 0; i < _addresses.length; i++){
485             _whitelisted[_addresses[i]] = _amounts[i] * 10**9;
486         }
487     }
488 
489     function isWhitelisted(address _address) public view returns (bool){
490         return _whitelisted[_address] > 0;
491     }
492 
493     function whitelistedAmount(address _address) public view returns (uint256){
494         return _whitelisted[_address];
495     }
496 
497     function setOnlyWhitelisted(bool flag) public onlyOwner {
498         _onlyWhitelisted = flag;
499     }
500     
501     function onlyWhitelisted() public view returns (bool){
502         return _onlyWhitelisted;
503     }
504     
505     /**
506         Transfer logic
507     **/
508 
509     function _tokenTransfer(
510         address sender,
511         address recipient,
512         uint256 amount
513     ) private {
514         _transferStandard(sender, recipient, amount);
515     }
516 
517     function _transferStandard(
518         address sender,
519         address recipient,
520         uint256 tAmount
521     ) private {
522         (
523             uint256 rAmount,
524             uint256 rTransferAmount,
525             uint256 rFee,
526             uint256 tTransferAmount,
527             uint256 tFee,
528             uint256 tTeam
529         ) = _getValues(tAmount);
530 
531         if (sender != owner() && recipient != owner()) {
532             if (sender == uniswapV2Pair && recipient != address(uniswapV2Router) && onlyWhitelisted()) {
533                 require(isWhitelisted(recipient), "Only whitelsited can purchase tokens");
534                 require(balanceOf(recipient) + tokenFromReflection(rTransferAmount) <= whitelistedAmount(recipient), "Amount should be less or equal to whitelisted amount");
535                 emit test(sender, recipient, whitelistedAmount(recipient), tokenFromReflection(rTransferAmount));
536             }
537         }
538 
539         _rOwned[sender] = _rOwned[sender].sub(rAmount);
540         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
541         _takeTeam(tTeam);
542         _reflectFee(rFee, tFee);
543         emit Transfer(sender, recipient, tTransferAmount);
544     }
545 
546     function _takeTeam(uint256 tTeam) private {
547         uint256 currentRate = _getRate();
548         uint256 rTeam = tTeam.mul(currentRate);
549         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
550     }
551 
552     function _reflectFee(uint256 rFee, uint256 tFee) private {
553         _rTotal = _rTotal.sub(rFee);
554         _tFeeTotal = _tFeeTotal.add(tFee);
555     }
556 
557     receive() external payable {}
558 
559     function manualswap() external {
560         require(_msgSender() == _feeAddrWallet1);
561         uint256 contractBalance = balanceOf(address(this));
562         swapTokensForEth(contractBalance);
563     }
564 
565     function manualsend() external {
566         require(_msgSender() == _feeAddrWallet1);
567         uint256 contractETHBalance = address(this).balance;
568         sendETHToFee(contractETHBalance);
569     }
570 
571     function _getValues(uint256 tAmount)
572         private
573         view
574         returns (
575             uint256,
576             uint256,
577             uint256,
578             uint256,
579             uint256,
580             uint256
581         )
582     {
583         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
584             tAmount,
585             _feeAddr1,
586             _feeAddr2
587         );
588         uint256 currentRate = _getRate();
589         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
590             tAmount,
591             tFee,
592             tTeam,
593             currentRate
594         );
595         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
596     }
597 
598     function _getTValues(
599         uint256 tAmount,
600         uint256 taxFee,
601         uint256 TeamFee
602     )
603         private
604         pure
605         returns (
606             uint256,
607             uint256,
608             uint256
609         )
610     {
611         uint256 tFee = tAmount.mul(taxFee).div(100);
612         uint256 tTeam = tAmount.mul(TeamFee).div(100);
613         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
614         return (tTransferAmount, tFee, tTeam);
615     }
616 
617     function _getRValues(
618         uint256 tAmount,
619         uint256 tFee,
620         uint256 tTeam,
621         uint256 currentRate
622     )
623         private
624         pure
625         returns (
626             uint256,
627             uint256,
628             uint256
629         )
630     {
631         uint256 rAmount = tAmount.mul(currentRate);
632         uint256 rFee = tFee.mul(currentRate);
633         uint256 rTeam = tTeam.mul(currentRate);
634         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
635         return (rAmount, rTransferAmount, rFee);
636     }
637 
638     function _getRate() private view returns (uint256) {
639         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
640         return rSupply.div(tSupply);
641     }
642 
643     function _getCurrentSupply() private view returns (uint256, uint256) {
644         uint256 rSupply = _rTotal;
645         uint256 tSupply = _tTotal;
646         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
647         return (rSupply, tSupply);
648     }
649 }