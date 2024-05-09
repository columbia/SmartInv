1 //Salt Bae Inu (SaltBaeInu)
2 
3 
4 //TG: https://t.me/saltbaeinu
5 //Twitter: https://twitter.com/inu_salt
6 //Website: TBA
7 
8 /*
9 .....................................................................................
10 ....................................:O8@8O8:.........................................
11 ..................................8@@Oo@@o::8O.......................................
12 ...................8:O:oo:......:@@@@8@88oOoo:8:.....................................
13 ...................8oo8o:8:O....@@8oo8@888OOo::8.....................................
14 ..............ooo8.8ooooOo::8..@@@8OOO@888@@O::O:....................................
15 ...............OOoo8OOOOOOo:8.o@@8OoooooO@@O:o:oO....................................
16 ................:@OoooOOOOOO:8:8@OoooooooooO8ooO:....................................
17 ..................O8ooooooooo@.O8o8OoooooOOOOOO8.....................................
18 ....................8Oooooooo8.88ooOOo8oooOOOO@......................................
19 .....................@OoOOO8@..:OOO@@88:8@88@o.......................................
20 .....................8Ooo:oOo..o88OooOO:OOOOoOO888:..................................
21 .....................O8Oo::o8:.OO8O88@OO8Oo8Ooo:.::.o................................
22 .....................888Oooo8....o@OOOoOO@Oooo8::.:o.:...............................
23 .....................@8oOo:oo8..:oOO@OO888oooo:oO.:::8...............................
24 ....................o8OoOo:::oO...oo.ooOooooo:ooOO..:o...............................
25 ....................8OoOOoooooOooo:..:o:.8OOOoooOO:..8...............................
26 ...................:8OOOOooo:::8ooooo:...:oo:oOoo:...:o..............................
27 ...................88OOooooooo::8oo::o::o:...:o:.....8:o.............................
28 ...................88OOoooooooooOoooo..oo.:ooo::ooo..8OO:............................
29 ...................o88Ooooooo:ooOOooooo..oo:.:oooooo88oo8............................
30 ....................88OOooooo:oOOoOoo:oo:.:.oo......:8Oooo...........................
31 .....................88OOOooo:oOOOooooooooo....oo....8OOo@...........................
32 .......................O@@@@8OOOoooOooooooooo:.......8OOo8...........................
33 ...........................@OOoOoO:ooooooooo:..:oo..:8OOO8:..........................
34 ............................@oOOooooo:ooooooooo:...:.88OoO:..........................
35 ............................88oOOoOoooooooooooooo:...888ooo..........................
36 .............................@OOOOOOOooooooooooooo:..88888::.........................
37 .............................8OOoOOOOooooooooo:oooo..88@8o8:.........................
38 .............................O@oOOOOOOOo:oooooooo:...@8o:o:o8........................
39 .............................O@ooooooooooooooooOoOOo8@@8OOOo:o.......................
40 .............................@@@@@8OOooooooooOooooO@@@@88@@O:O.......................
41 ............................:@@@@O@@@8OO8@O@@@@8:::@@@@@@@@8oo.......................
42 .................OooO...:o:.:@@@8@@@@@o.O@@8.@@@O..@@@@@@@@@@......::................
43 ...............O8.@OO88.:8:.88.::..8@O:.O8:...:@O..:...8@..:..o:O:.oO.oO.............
44 ..............:@8:@:@@8....o@@8@8:.:@@:.O@@..@@@O..@@o.:@8@8o..@:..::..O:............
45 ..............oO:oo:O8O.O@o.8:.o@..:@@o.O@@..88oO..@@:.:O..@O..@o..@@@@o.............
46 ...............OO@88..o8o:o8:OOoOOOo88OOO8.OOO8:8OO8OO8:oOoOO8oOoOOooOO..............
47 .....................................................................................
48 */
49 
50 //Limit Buy
51 //Cooldown
52 //Bot Protect
53 //Liqudity dev provides and lock
54 //CG, CMC listing: Ongoing
55 // SPDX-License-Identifier: Unlicensed
56 
57 pragma solidity ^0.8.4;
58 
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address) {
61         return msg.sender;
62     }
63 }
64 
65 interface IERC20 {
66     function totalSupply() external view returns (uint256);
67 
68     function balanceOf(address account) external view returns (uint256);
69 
70     function transfer(address recipient, uint256 amount)
71         external
72         returns (bool);
73 
74     function allowance(address owner, address spender)
75         external
76         view
77         returns (uint256);
78 
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     event Approval(
89         address indexed owner,
90         address indexed spender,
91         uint256 value
92     );
93 }
94 
95 library SafeMath {
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99         return c;
100     }
101 
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         return sub(a, b, "SafeMath: subtraction overflow");
104     }
105 
106     function sub(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b <= a, errorMessage);
112         uint256 c = a - b;
113         return c;
114     }
115 
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) {
118             return 0;
119         }
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128 
129     function div(
130         uint256 a,
131         uint256 b,
132         string memory errorMessage
133     ) internal pure returns (uint256) {
134         require(b > 0, errorMessage);
135         uint256 c = a / b;
136         return c;
137     }
138 }
139 
140 contract Ownable is Context {
141     address private _owner;
142     address private _previousOwner;
143     event OwnershipTransferred(
144         address indexed previousOwner,
145         address indexed newOwner
146     );
147 
148     constructor() {
149         address msgSender = _msgSender();
150         _owner = msgSender;
151         emit OwnershipTransferred(address(0), msgSender);
152     }
153 
154     function owner() public view returns (address) {
155         return _owner;
156     }
157 
158     modifier onlyOwner() {
159         require(_owner == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     function renounceOwnership() public virtual onlyOwner {
164         emit OwnershipTransferred(_owner, address(0));
165         _owner = address(0);
166     }
167 }
168 
169 interface IUniswapV2Factory {
170     function createPair(address tokenA, address tokenB)
171         external
172         returns (address pair);
173 }
174 
175 interface IUniswapV2Router02 {
176     function swapExactTokensForETHSupportingFeeOnTransferTokens(
177         uint256 amountIn,
178         uint256 amountOutMin,
179         address[] calldata path,
180         address to,
181         uint256 deadline
182     ) external;
183 
184     function factory() external pure returns (address);
185 
186     function WETH() external pure returns (address);
187 
188     function addLiquidityETH(
189         address token,
190         uint256 amountTokenDesired,
191         uint256 amountTokenMin,
192         uint256 amountETHMin,
193         address to,
194         uint256 deadline
195     )
196         external
197         payable
198         returns (
199             uint256 amountToken,
200             uint256 amountETH,
201             uint256 liquidity
202         );
203 }
204 
205 contract SaltBaeInu is Context, IERC20, Ownable {
206     using SafeMath for uint256;
207 
208     string private constant _name = "Salt Bae Inu";
209     string private constant _symbol = "\xF0\x9F\xA7\x82SALTINU\xF0\x9F\xA5\xA9";
210     uint8 private constant _decimals = 9;
211 
212     // RFI
213     mapping(address => uint256) private _rOwned;
214     mapping(address => uint256) private _tOwned;
215     mapping(address => mapping(address => uint256)) private _allowances;
216     mapping(address => bool) private _isExcludedFromFee;
217     uint256 private constant MAX = ~uint256(0);
218     uint256 private constant _tTotal = 1000000000000 * 10**9;
219     uint256 private _rTotal = (MAX - (MAX % _tTotal));
220     uint256 private _tFeeTotal;
221     uint256 private _taxFee = 5;
222     uint256 private _teamFee = 10;
223 
224     // Bot detection
225     mapping(address => bool) private bots;
226     mapping(address => uint256) private cooldown;
227     address payable private _teamAddress;
228     address payable private _marketingFunds;
229     IUniswapV2Router02 private uniswapV2Router;
230     address private uniswapV2Pair;
231     bool private tradingOpen;
232     bool private inSwap = false;
233     bool private swapEnabled = false;
234     bool private cooldownEnabled = false;
235     uint256 private _maxTxAmount = _tTotal;
236 
237     event MaxTxAmountUpdated(uint256 _maxTxAmount);
238     modifier lockTheSwap {
239         inSwap = true;
240         _;
241         inSwap = false;
242     }
243 
244     constructor(address payable addr1, address payable addr2) {
245         _teamAddress = addr1;
246         _marketingFunds = addr2;
247         _rOwned[_msgSender()] = _rTotal;
248         _isExcludedFromFee[owner()] = true;
249         _isExcludedFromFee[address(this)] = true;
250         _isExcludedFromFee[_teamAddress] = true;
251         _isExcludedFromFee[_marketingFunds] = true;
252         emit Transfer(address(0), _msgSender(), _tTotal);
253     }
254 
255     function name() public pure returns (string memory) {
256         return _name;
257     }
258 
259     function symbol() public pure returns (string memory) {
260         return _symbol;
261     }
262 
263     function decimals() public pure returns (uint8) {
264         return _decimals;
265     }
266 
267     function totalSupply() public pure override returns (uint256) {
268         return _tTotal;
269     }
270 
271     function balanceOf(address account) public view override returns (uint256) {
272         return tokenFromReflection(_rOwned[account]);
273     }
274 
275     function transfer(address recipient, uint256 amount)
276         public
277         override
278         returns (bool)
279     {
280         _transfer(_msgSender(), recipient, amount);
281         return true;
282     }
283 
284     function allowance(address owner, address spender)
285         public
286         view
287         override
288         returns (uint256)
289     {
290         return _allowances[owner][spender];
291     }
292 
293     function approve(address spender, uint256 amount)
294         public
295         override
296         returns (bool)
297     {
298         _approve(_msgSender(), spender, amount);
299         return true;
300     }
301 
302     function transferFrom(
303         address sender,
304         address recipient,
305         uint256 amount
306     ) public override returns (bool) {
307         _transfer(sender, recipient, amount);
308         _approve(
309             sender,
310             _msgSender(),
311             _allowances[sender][_msgSender()].sub(
312                 amount,
313                 "ERC20: transfer amount exceeds allowance"
314             )
315         );
316         return true;
317     }
318 
319     function setCooldownEnabled(bool onoff) external onlyOwner() {
320         cooldownEnabled = onoff;
321     }
322 
323     function tokenFromReflection(uint256 rAmount)
324         private
325         view
326         returns (uint256)
327     {
328         require(
329             rAmount <= _rTotal,
330             "Amount must be less than total reflections"
331         );
332         uint256 currentRate = _getRate();
333         return rAmount.div(currentRate);
334     }
335 
336     function removeAllFee() private {
337         if (_taxFee == 0 && _teamFee == 0) return;
338         _taxFee = 0;
339         _teamFee = 0;
340     }
341 
342     function restoreAllFee() private {
343         _taxFee = 5;
344         _teamFee = 12;
345     }
346 
347     function _approve(
348         address owner,
349         address spender,
350         uint256 amount
351     ) private {
352         require(owner != address(0), "ERC20: approve from the zero address");
353         require(spender != address(0), "ERC20: approve to the zero address");
354         _allowances[owner][spender] = amount;
355         emit Approval(owner, spender, amount);
356     }
357 
358     function _transfer(
359         address from,
360         address to,
361         uint256 amount
362     ) private {
363         require(from != address(0), "ERC20: transfer from the zero address");
364         require(to != address(0), "ERC20: transfer to the zero address");
365         require(amount > 0, "Transfer amount must be greater than zero");
366 
367         if (from != owner() && to != owner()) {
368             if (cooldownEnabled) {
369                 if (
370                     from != address(this) &&
371                     to != address(this) &&
372                     from != address(uniswapV2Router) &&
373                     to != address(uniswapV2Router)
374                 ) {
375                     require(
376                         _msgSender() == address(uniswapV2Router) ||
377                             _msgSender() == uniswapV2Pair,
378                         "ERR: Uniswap only"
379                     );
380                 }
381             }
382             require(amount <= _maxTxAmount);
383             require(!bots[from] && !bots[to]);
384             if (
385                 from == uniswapV2Pair &&
386                 to != address(uniswapV2Router) &&
387                 !_isExcludedFromFee[to] &&
388                 cooldownEnabled
389             ) {
390                 require(cooldown[to] < block.timestamp);
391                 cooldown[to] = block.timestamp + (15 seconds);
392             }
393             uint256 contractTokenBalance = balanceOf(address(this));
394             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
395                 swapTokensForEth(contractTokenBalance);
396                 uint256 contractETHBalance = address(this).balance;
397                 if (contractETHBalance > 0) {
398                     sendETHToFee(address(this).balance);
399                 }
400             }
401         }
402         bool takeFee = true;
403 
404         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
405             takeFee = false;
406         }
407 
408         _tokenTransfer(from, to, amount, takeFee);
409     }
410 
411     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
412         address[] memory path = new address[](2);
413         path[0] = address(this);
414         path[1] = uniswapV2Router.WETH();
415         _approve(address(this), address(uniswapV2Router), tokenAmount);
416         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
417             tokenAmount,
418             0,
419             path,
420             address(this),
421             block.timestamp
422         );
423     }
424 
425     function sendETHToFee(uint256 amount) private {
426         _teamAddress.transfer(amount.div(2));
427         _marketingFunds.transfer(amount.div(2));
428     }
429 
430     function openTrading() external onlyOwner() {
431         require(!tradingOpen, "trading is already open");
432         IUniswapV2Router02 _uniswapV2Router =
433             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
434         uniswapV2Router = _uniswapV2Router;
435         _approve(address(this), address(uniswapV2Router), _tTotal);
436         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
437             .createPair(address(this), _uniswapV2Router.WETH());
438         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
439             address(this),
440             balanceOf(address(this)),
441             0,
442             0,
443             owner(),
444             block.timestamp
445         );
446         swapEnabled = true;
447         cooldownEnabled = true;
448         _maxTxAmount = 2500000000 * 10**9;
449         tradingOpen = true;
450         IERC20(uniswapV2Pair).approve(
451             address(uniswapV2Router),
452             type(uint256).max
453         );
454     }
455 
456     function manualswap() external {
457         require(_msgSender() == _teamAddress);
458         uint256 contractBalance = balanceOf(address(this));
459         swapTokensForEth(contractBalance);
460     }
461 
462     function manualsend() external {
463         require(_msgSender() == _teamAddress);
464         uint256 contractETHBalance = address(this).balance;
465         sendETHToFee(contractETHBalance);
466     }
467 
468     function setBots(address[] memory bots_) public onlyOwner {
469         for (uint256 i = 0; i < bots_.length; i++) {
470             bots[bots_[i]] = true;
471         }
472     }
473 
474     function delBot(address notbot) public onlyOwner {
475         bots[notbot] = false;
476     }
477 
478     function _tokenTransfer(
479         address sender,
480         address recipient,
481         uint256 amount,
482         bool takeFee
483     ) private {
484         if (!takeFee) removeAllFee();
485         _transferStandard(sender, recipient, amount);
486         if (!takeFee) restoreAllFee();
487     }
488 
489     function _transferStandard(
490         address sender,
491         address recipient,
492         uint256 tAmount
493     ) private {
494         (
495             uint256 rAmount,
496             uint256 rTransferAmount,
497             uint256 rFee,
498             uint256 tTransferAmount,
499             uint256 tFee,
500             uint256 tTeam
501         ) = _getValues(tAmount);
502         _rOwned[sender] = _rOwned[sender].sub(rAmount);
503         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
504         _takeTeam(tTeam);
505         _reflectFee(rFee, tFee);
506         emit Transfer(sender, recipient, tTransferAmount);
507     }
508 
509     function _takeTeam(uint256 tTeam) private {
510         uint256 currentRate = _getRate();
511         uint256 rTeam = tTeam.mul(currentRate);
512         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
513     }
514 
515     function _reflectFee(uint256 rFee, uint256 tFee) private {
516         _rTotal = _rTotal.sub(rFee);
517         _tFeeTotal = _tFeeTotal.add(tFee);
518     }
519 
520     receive() external payable {}
521 
522     function _getValues(uint256 tAmount)
523         private
524         view
525         returns (
526             uint256,
527             uint256,
528             uint256,
529             uint256,
530             uint256,
531             uint256
532         )
533     {
534         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
535             _getTValues(tAmount, _taxFee, _teamFee);
536         uint256 currentRate = _getRate();
537         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
538             _getRValues(tAmount, tFee, tTeam, currentRate);
539         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
540     }
541 
542     function _getTValues(
543         uint256 tAmount,
544         uint256 taxFee,
545         uint256 TeamFee
546     )
547         private
548         pure
549         returns (
550             uint256,
551             uint256,
552             uint256
553         )
554     {
555         uint256 tFee = tAmount.mul(taxFee).div(100);
556         uint256 tTeam = tAmount.mul(TeamFee).div(100);
557         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
558         return (tTransferAmount, tFee, tTeam);
559     }
560 
561     function _getRValues(
562         uint256 tAmount,
563         uint256 tFee,
564         uint256 tTeam,
565         uint256 currentRate
566     )
567         private
568         pure
569         returns (
570             uint256,
571             uint256,
572             uint256
573         )
574     {
575         uint256 rAmount = tAmount.mul(currentRate);
576         uint256 rFee = tFee.mul(currentRate);
577         uint256 rTeam = tTeam.mul(currentRate);
578         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
579         return (rAmount, rTransferAmount, rFee);
580     }
581 
582     function _getRate() private view returns (uint256) {
583         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
584         return rSupply.div(tSupply);
585     }
586 
587     function _getCurrentSupply() private view returns (uint256, uint256) {
588         uint256 rSupply = _rTotal;
589         uint256 tSupply = _tTotal;
590         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
591         return (rSupply, tSupply);
592     }
593 
594     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
595         require(maxTxPercent > 0, "Amount must be greater than 0");
596         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
597         emit MaxTxAmountUpdated(_maxTxAmount);
598     }
599 }