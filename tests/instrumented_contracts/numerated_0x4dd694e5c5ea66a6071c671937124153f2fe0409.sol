1 //Shib Robot (SHIBROBOT)
2 
3 //Limit Buy yes
4 
5 //Cooldown yes
6 
7 //Bot Protect yes
8 
9 //Deflationary yes
10 
11 //Fee yes
12 
13 //Liqudity dev provides and lock
14 
15 //TG: https://t.me/shibrobotofficial
16 
17 //Website: TBA
18 
19 //CG, CMC listing: Ongoing
20 
21 // SPDX-License-Identifier: Unlicensed
22 pragma solidity ^0.8.4;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 }
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32 
33     function balanceOf(address account) external view returns (uint256);
34 
35     function transfer(address recipient, uint256 amount)
36         external
37         returns (bool);
38 
39     function allowance(address owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     function transferFrom(
47         address sender,
48         address recipient,
49         uint256 amount
50     ) external returns (bool);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(
54         address indexed owner,
55         address indexed spender,
56         uint256 value
57     );
58 }
59 
60 library SafeMath {
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     function sub(
72         uint256 a,
73         uint256 b,
74         string memory errorMessage
75     ) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     function div(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         require(b > 0, errorMessage);
100         uint256 c = a / b;
101         return c;
102     }
103 }
104 
105 contract Ownable is Context {
106     address private _owner;
107     address private _previousOwner;
108     event OwnershipTransferred(
109         address indexed previousOwner,
110         address indexed newOwner
111     );
112 
113     constructor() {
114         address msgSender = _msgSender();
115         _owner = msgSender;
116         emit OwnershipTransferred(address(0), msgSender);
117     }
118 
119     function owner() public view returns (address) {
120         return _owner;
121     }
122 
123     modifier onlyOwner() {
124         require(_owner == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     function renounceOwnership() public virtual onlyOwner {
129         emit OwnershipTransferred(_owner, address(0));
130         _owner = address(0);
131     }
132 }
133 
134 interface IUniswapV2Factory {
135     function createPair(address tokenA, address tokenB)
136         external
137         returns (address pair);
138 }
139 
140 interface IUniswapV2Router02 {
141     function swapExactTokensForETHSupportingFeeOnTransferTokens(
142         uint256 amountIn,
143         uint256 amountOutMin,
144         address[] calldata path,
145         address to,
146         uint256 deadline
147     ) external;
148 
149     function factory() external pure returns (address);
150 
151     function WETH() external pure returns (address);
152 
153     function addLiquidityETH(
154         address token,
155         uint256 amountTokenDesired,
156         uint256 amountTokenMin,
157         uint256 amountETHMin,
158         address to,
159         uint256 deadline
160     )
161         external
162         payable
163         returns (
164             uint256 amountToken,
165             uint256 amountETH,
166             uint256 liquidity
167         );
168 }
169 
170 contract ShibRobot is Context, IERC20, Ownable {
171     using SafeMath for uint256;
172 
173     string private constant _name = "Shib Robot";
174     string private constant _symbol = "SHIBROBOT \xF0\x9F\x90\x95";
175     uint8 private constant _decimals = 9;
176 
177     // RFI
178     mapping(address => uint256) private _rOwned;
179     mapping(address => uint256) private _tOwned;
180     mapping(address => mapping(address => uint256)) private _allowances;
181     mapping(address => bool) private _isExcludedFromFee;
182     uint256 private constant MAX = ~uint256(0);
183     uint256 private constant _tTotal = 1000000000000 * 10**9;
184     uint256 private _rTotal = (MAX - (MAX % _tTotal));
185     uint256 private _tFeeTotal;
186     uint256 private _taxFee = 5;
187     uint256 private _teamFee = 10;
188 
189     // Bot detection
190     mapping(address => bool) private bots;
191     mapping(address => uint256) private cooldown;
192     address payable private _teamAddress;
193     address payable private _marketingFunds;
194     IUniswapV2Router02 private uniswapV2Router;
195     address private uniswapV2Pair;
196     bool private tradingOpen;
197     bool private inSwap = false;
198     bool private swapEnabled = false;
199     bool private cooldownEnabled = false;
200     uint256 private _maxTxAmount = _tTotal;
201 
202     event MaxTxAmountUpdated(uint256 _maxTxAmount);
203     modifier lockTheSwap {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208 
209     constructor(address payable addr1, address payable addr2) {
210         _teamAddress = addr1;
211         _marketingFunds = addr2;
212         _rOwned[_msgSender()] = _rTotal;
213         _isExcludedFromFee[owner()] = true;
214         _isExcludedFromFee[address(this)] = true;
215         _isExcludedFromFee[_teamAddress] = true;
216         _isExcludedFromFee[_marketingFunds] = true;
217         emit Transfer(address(0), _msgSender(), _tTotal);
218     }
219 
220     function name() public pure returns (string memory) {
221         return _name;
222     }
223 
224     function symbol() public pure returns (string memory) {
225         return _symbol;
226     }
227 
228     function decimals() public pure returns (uint8) {
229         return _decimals;
230     }
231 
232     function totalSupply() public pure override returns (uint256) {
233         return _tTotal;
234     }
235 
236     function balanceOf(address account) public view override returns (uint256) {
237         return tokenFromReflection(_rOwned[account]);
238     }
239 
240     function transfer(address recipient, uint256 amount)
241         public
242         override
243         returns (bool)
244     {
245         _transfer(_msgSender(), recipient, amount);
246         return true;
247     }
248 
249     function allowance(address owner, address spender)
250         public
251         view
252         override
253         returns (uint256)
254     {
255         return _allowances[owner][spender];
256     }
257 
258     function approve(address spender, uint256 amount)
259         public
260         override
261         returns (bool)
262     {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266 
267     function transferFrom(
268         address sender,
269         address recipient,
270         uint256 amount
271     ) public override returns (bool) {
272         _transfer(sender, recipient, amount);
273         _approve(
274             sender,
275             _msgSender(),
276             _allowances[sender][_msgSender()].sub(
277                 amount,
278                 "ERC20: transfer amount exceeds allowance"
279             )
280         );
281         return true;
282     }
283 
284     function setCooldownEnabled(bool onoff) external onlyOwner() {
285         cooldownEnabled = onoff;
286     }
287 
288     function tokenFromReflection(uint256 rAmount)
289         private
290         view
291         returns (uint256)
292     {
293         require(
294             rAmount <= _rTotal,
295             "Amount must be less than total reflections"
296         );
297         uint256 currentRate = _getRate();
298         return rAmount.div(currentRate);
299     }
300 
301     function removeAllFee() private {
302         if (_taxFee == 0 && _teamFee == 0) return;
303         _taxFee = 0;
304         _teamFee = 0;
305     }
306 
307     function restoreAllFee() private {
308         _taxFee = 5;
309         _teamFee = 12;
310     }
311 
312     function _approve(
313         address owner,
314         address spender,
315         uint256 amount
316     ) private {
317         require(owner != address(0), "ERC20: approve from the zero address");
318         require(spender != address(0), "ERC20: approve to the zero address");
319         _allowances[owner][spender] = amount;
320         emit Approval(owner, spender, amount);
321     }
322 
323     function _transfer(
324         address from,
325         address to,
326         uint256 amount
327     ) private {
328         require(from != address(0), "ERC20: transfer from the zero address");
329         require(to != address(0), "ERC20: transfer to the zero address");
330         require(amount > 0, "Transfer amount must be greater than zero");
331 
332         if (from != owner() && to != owner()) {
333             if (cooldownEnabled) {
334                 if (
335                     from != address(this) &&
336                     to != address(this) &&
337                     from != address(uniswapV2Router) &&
338                     to != address(uniswapV2Router)
339                 ) {
340                     require(
341                         _msgSender() == address(uniswapV2Router) ||
342                             _msgSender() == uniswapV2Pair,
343                         "ERR: Uniswap only"
344                     );
345                 }
346             }
347             require(amount <= _maxTxAmount);
348             require(!bots[from] && !bots[to]);
349             if (
350                 from == uniswapV2Pair &&
351                 to != address(uniswapV2Router) &&
352                 !_isExcludedFromFee[to] &&
353                 cooldownEnabled
354             ) {
355                 require(cooldown[to] < block.timestamp);
356                 cooldown[to] = block.timestamp + (60 seconds);
357             }
358             uint256 contractTokenBalance = balanceOf(address(this));
359             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
360                 swapTokensForEth(contractTokenBalance);
361                 uint256 contractETHBalance = address(this).balance;
362                 if (contractETHBalance > 0) {
363                     sendETHToFee(address(this).balance);
364                 }
365             }
366         }
367         bool takeFee = true;
368 
369         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
370             takeFee = false;
371         }
372 
373         _tokenTransfer(from, to, amount, takeFee);
374     }
375 
376     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
377         address[] memory path = new address[](2);
378         path[0] = address(this);
379         path[1] = uniswapV2Router.WETH();
380         _approve(address(this), address(uniswapV2Router), tokenAmount);
381         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
382             tokenAmount,
383             0,
384             path,
385             address(this),
386             block.timestamp
387         );
388     }
389 
390     function sendETHToFee(uint256 amount) private {
391         _teamAddress.transfer(amount.div(2));
392         _marketingFunds.transfer(amount.div(2));
393     }
394 
395     function openTrading() external onlyOwner() {
396         require(!tradingOpen, "trading is already open");
397         IUniswapV2Router02 _uniswapV2Router =
398             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
399         uniswapV2Router = _uniswapV2Router;
400         _approve(address(this), address(uniswapV2Router), _tTotal);
401         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
402             .createPair(address(this), _uniswapV2Router.WETH());
403         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
404             address(this),
405             balanceOf(address(this)),
406             0,
407             0,
408             owner(),
409             block.timestamp
410         );
411         swapEnabled = true;
412         cooldownEnabled = true;
413         _maxTxAmount = 2500000000 * 10**9;
414         tradingOpen = true;
415         IERC20(uniswapV2Pair).approve(
416             address(uniswapV2Router),
417             type(uint256).max
418         );
419     }
420 
421     function manualswap() external {
422         require(_msgSender() == _teamAddress);
423         uint256 contractBalance = balanceOf(address(this));
424         swapTokensForEth(contractBalance);
425     }
426 
427     function manualsend() external {
428         require(_msgSender() == _teamAddress);
429         uint256 contractETHBalance = address(this).balance;
430         sendETHToFee(contractETHBalance);
431     }
432 
433     function setBots(address[] memory bots_) public onlyOwner {
434         for (uint256 i = 0; i < bots_.length; i++) {
435             bots[bots_[i]] = true;
436         }
437     }
438 
439     function delBot(address notbot) public onlyOwner {
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
500             _getTValues(tAmount, _taxFee, _teamFee);
501         uint256 currentRate = _getRate();
502         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
503             _getRValues(tAmount, tFee, tTeam, currentRate);
504         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
505     }
506 
507     function _getTValues(
508         uint256 tAmount,
509         uint256 taxFee,
510         uint256 TeamFee
511     )
512         private
513         pure
514         returns (
515             uint256,
516             uint256,
517             uint256
518         )
519     {
520         uint256 tFee = tAmount.mul(taxFee).div(100);
521         uint256 tTeam = tAmount.mul(TeamFee).div(100);
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
559     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
560         require(maxTxPercent > 0, "Amount must be greater than 0");
561         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
562         emit MaxTxAmountUpdated(_maxTxAmount);
563     }
564 }