1 /**
2      ____                 ________            ____  _     
3    / __ )__  ____  __   /_  __/ /_  ___     / __ \(_)___ 
4   / __  / / / / / / /    / / / __ \/ _ \   / / / / / __ \
5  / /_/ / /_/ / /_/ /    / / / / / /  __/  / /_/ / / /_/ /
6 /_____/\__,_/\__, /    /_/ /_/ /_/\___/  /_____/_/ .___/ 
7             /____/                              /_/      
8             
9             
10     TG: https://t.me/buythediptoken
11     Twitter: https://twitter.com/buythediptoken
12 */
13 
14 
15 // SPDX-License-Identifier: Unlicensed
16 pragma solidity ^0.8.4;
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
29     function transfer(address recipient, uint256 amount)
30         external
31         returns (bool);
32 
33     function allowance(address owner, address spender)
34         external
35         view
36         returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(
48         address indexed owner,
49         address indexed spender,
50         uint256 value
51     );
52 }
53 
54 library SafeMath {
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58         return c;
59     }
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return sub(a, b, "SafeMath: subtraction overflow");
63     }
64 
65     function sub(
66         uint256 a,
67         uint256 b,
68         string memory errorMessage
69     ) internal pure returns (uint256) {
70         require(b <= a, errorMessage);
71         uint256 c = a - b;
72         return c;
73     }
74 
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         if (a == 0) {
77             return 0;
78         }
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81         return c;
82     }
83 
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     function div(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b > 0, errorMessage);
94         uint256 c = a / b;
95         return c;
96     }
97 }
98 
99 contract Ownable is Context {
100     address private _owner;
101     address private _previousOwner;
102     event OwnershipTransferred(
103         address indexed previousOwner,
104         address indexed newOwner
105     );
106 
107     constructor() {
108         address msgSender = _msgSender();
109         _owner = msgSender;
110         emit OwnershipTransferred(address(0), msgSender);
111     }
112 
113     function owner() public view returns (address) {
114         return _owner;
115     }
116 
117     modifier onlyOwner() {
118         require(_owner == _msgSender(), "Ownable: caller is not the owner");
119         _;
120     }
121 
122     function renounceOwnership() public virtual onlyOwner {
123         emit OwnershipTransferred(_owner, address(0));
124         _owner = address(0);
125     }
126 }
127 
128 interface IUniswapV2Factory {
129     function createPair(address tokenA, address tokenB)
130         external
131         returns (address pair);
132 }
133 
134 interface IUniswapV2Router02 {
135     function swapExactTokensForETHSupportingFeeOnTransferTokens(
136         uint256 amountIn,
137         uint256 amountOutMin,
138         address[] calldata path,
139         address to,
140         uint256 deadline
141     ) external;
142 
143     function factory() external pure returns (address);
144 
145     function WETH() external pure returns (address);
146 
147     function addLiquidityETH(
148         address token,
149         uint256 amountTokenDesired,
150         uint256 amountTokenMin,
151         uint256 amountETHMin,
152         address to,
153         uint256 deadline
154     )
155         external
156         payable
157         returns (
158             uint256 amountToken,
159             uint256 amountETH,
160             uint256 liquidity
161         );
162 }
163 
164 contract BuyTheDip is Context, IERC20, Ownable {
165     using SafeMath for uint256;
166 
167     string private constant _name = "Buy The Dip!";
168     string private constant _symbol = "BuyTheDip \xF0\x9F\x86\x99";
169     uint8 private constant _decimals = 9;
170 
171     // RFI
172     mapping(address => uint256) private _rOwned;
173     mapping(address => uint256) private _tOwned;
174     mapping(address => mapping(address => uint256)) private _allowances;
175     mapping(address => bool) private _isExcludedFromFee;
176     uint256 private constant MAX = ~uint256(0);
177     uint256 private constant _tTotal = 1000000000000 * 10**9;
178     uint256 private _rTotal = (MAX - (MAX % _tTotal));
179     uint256 private _tFeeTotal;
180     uint256 private _taxFee = 2;
181     uint256 private _teamFee = 10;
182 
183     // Bot detection
184     mapping(address => bool) private bots;
185     mapping(address => uint256) private cooldown;
186     address payable private _teamAddress;
187     address payable private _marketingFunds;
188     IUniswapV2Router02 private uniswapV2Router;
189     address private uniswapV2Pair;
190     bool private tradingOpen;
191     bool private inSwap = false;
192     bool private swapEnabled = false;
193     bool private cooldownEnabled = false;
194     uint256 private _maxTxAmount = _tTotal;
195 
196     event MaxTxAmountUpdated(uint256 _maxTxAmount);
197     modifier lockTheSwap {
198         inSwap = true;
199         _;
200         inSwap = false;
201     }
202 
203     constructor(address payable addr1, address payable addr2) {
204         _teamAddress = addr1;
205         _marketingFunds = addr2;
206         _rOwned[_msgSender()] = _rTotal;
207         _isExcludedFromFee[owner()] = true;
208         _isExcludedFromFee[address(this)] = true;
209         _isExcludedFromFee[_teamAddress] = true;
210         _isExcludedFromFee[_marketingFunds] = true;
211         emit Transfer(address(0), _msgSender(), _tTotal);
212     }
213 
214     function name() public pure returns (string memory) {
215         return _name;
216     }
217 
218     function symbol() public pure returns (string memory) {
219         return _symbol;
220     }
221 
222     function decimals() public pure returns (uint8) {
223         return _decimals;
224     }
225 
226     function totalSupply() public pure override returns (uint256) {
227         return _tTotal;
228     }
229 
230     function balanceOf(address account) public view override returns (uint256) {
231         return tokenFromReflection(_rOwned[account]);
232     }
233 
234     function transfer(address recipient, uint256 amount)
235         public
236         override
237         returns (bool)
238     {
239         _transfer(_msgSender(), recipient, amount);
240         return true;
241     }
242 
243     function allowance(address owner, address spender)
244         public
245         view
246         override
247         returns (uint256)
248     {
249         return _allowances[owner][spender];
250     }
251 
252     function approve(address spender, uint256 amount)
253         public
254         override
255         returns (bool)
256     {
257         _approve(_msgSender(), spender, amount);
258         return true;
259     }
260 
261     function transferFrom(
262         address sender,
263         address recipient,
264         uint256 amount
265     ) public override returns (bool) {
266         _transfer(sender, recipient, amount);
267         _approve(
268             sender,
269             _msgSender(),
270             _allowances[sender][_msgSender()].sub(
271                 amount,
272                 "ERC20: transfer amount exceeds allowance"
273             )
274         );
275         return true;
276     }
277 
278     function setCooldownEnabled(bool onoff) external onlyOwner() {
279         cooldownEnabled = onoff;
280     }
281 
282     function tokenFromReflection(uint256 rAmount)
283         private
284         view
285         returns (uint256)
286     {
287         require(
288             rAmount <= _rTotal,
289             "Amount must be less than total reflections"
290         );
291         uint256 currentRate = _getRate();
292         return rAmount.div(currentRate);
293     }
294 
295     function removeAllFee() private {
296         if (_taxFee == 0 && _teamFee == 0) return;
297         _taxFee = 0;
298         _teamFee = 0;
299     }
300 
301     function restoreAllFee() private {
302         _taxFee = 2;
303         _teamFee = 10;
304     }
305 
306     function _approve(
307         address owner,
308         address spender,
309         uint256 amount
310     ) private {
311         require(owner != address(0), "ERC20: approve from the zero address");
312         require(spender != address(0), "ERC20: approve to the zero address");
313         _allowances[owner][spender] = amount;
314         emit Approval(owner, spender, amount);
315     }
316 
317     function _transfer(
318         address from,
319         address to,
320         uint256 amount
321     ) private {
322         require(from != address(0), "ERC20: transfer from the zero address");
323         require(to != address(0), "ERC20: transfer to the zero address");
324         require(amount > 0, "Transfer amount must be greater than zero");
325 
326         if (from != owner() && to != owner()) {
327             if (cooldownEnabled) {
328                 if (
329                     from != address(this) &&
330                     to != address(this) &&
331                     from != address(uniswapV2Router) &&
332                     to != address(uniswapV2Router)
333                 ) {
334                     require(
335                         _msgSender() == address(uniswapV2Router) ||
336                             _msgSender() == uniswapV2Pair,
337                         "ERR: Uniswap only"
338                     );
339                 }
340             }
341             require(amount <= _maxTxAmount);
342             require(!bots[from] && !bots[to]);
343             if (
344                 from == uniswapV2Pair &&
345                 to != address(uniswapV2Router) &&
346                 !_isExcludedFromFee[to] &&
347                 cooldownEnabled
348             ) {
349                 require(cooldown[to] < block.timestamp);
350                 cooldown[to] = block.timestamp + (15 seconds);
351             }
352             uint256 contractTokenBalance = balanceOf(address(this));
353             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
354                 swapTokensForEth(contractTokenBalance);
355                 uint256 contractETHBalance = address(this).balance;
356                 if (contractETHBalance > 0) {
357                     sendETHToFee(address(this).balance);
358                 }
359             }
360         }
361         bool takeFee = true;
362 
363         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
364             takeFee = false;
365         }
366 
367         _tokenTransfer(from, to, amount, takeFee);
368     }
369 
370     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
371         address[] memory path = new address[](2);
372         path[0] = address(this);
373         path[1] = uniswapV2Router.WETH();
374         _approve(address(this), address(uniswapV2Router), tokenAmount);
375         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
376             tokenAmount,
377             0,
378             path,
379             address(this),
380             block.timestamp
381         );
382     }
383 
384     function sendETHToFee(uint256 amount) private {
385         _teamAddress.transfer(amount.div(2));
386         _marketingFunds.transfer(amount.div(2));
387     }
388 
389     function openTrading() external onlyOwner() {
390         require(!tradingOpen, "trading is already open");
391         IUniswapV2Router02 _uniswapV2Router =
392             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
393         uniswapV2Router = _uniswapV2Router;
394         _approve(address(this), address(uniswapV2Router), _tTotal);
395         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
396             .createPair(address(this), _uniswapV2Router.WETH());
397         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
398             address(this),
399             balanceOf(address(this)),
400             0,
401             0,
402             owner(),
403             block.timestamp
404         );
405         swapEnabled = true;
406         cooldownEnabled = true;
407         _maxTxAmount = 2500000000 * 10**9;
408         tradingOpen = true;
409         IERC20(uniswapV2Pair).approve(
410             address(uniswapV2Router),
411             type(uint256).max
412         );
413     }
414 
415     function manualswap() external {
416         require(_msgSender() == _teamAddress);
417         uint256 contractBalance = balanceOf(address(this));
418         swapTokensForEth(contractBalance);
419     }
420 
421     function manualsend() external {
422         require(_msgSender() == _teamAddress);
423         uint256 contractETHBalance = address(this).balance;
424         sendETHToFee(contractETHBalance);
425     }
426 
427     function setBots(address[] memory bots_) public onlyOwner {
428         for (uint256 i = 0; i < bots_.length; i++) {
429             bots[bots_[i]] = true;
430         }
431     }
432 
433     function delBot(address notbot) public onlyOwner {
434         bots[notbot] = false;
435     }
436 
437     function _tokenTransfer(
438         address sender,
439         address recipient,
440         uint256 amount,
441         bool takeFee
442     ) private {
443         if (!takeFee) removeAllFee();
444         _transferStandard(sender, recipient, amount);
445         if (!takeFee) restoreAllFee();
446     }
447 
448     function _transferStandard(
449         address sender,
450         address recipient,
451         uint256 tAmount
452     ) private {
453         (
454             uint256 rAmount,
455             uint256 rTransferAmount,
456             uint256 rFee,
457             uint256 tTransferAmount,
458             uint256 tFee,
459             uint256 tTeam
460         ) = _getValues(tAmount);
461         _rOwned[sender] = _rOwned[sender].sub(rAmount);
462         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
463         _takeTeam(tTeam);
464         _reflectFee(rFee, tFee);
465         emit Transfer(sender, recipient, tTransferAmount);
466     }
467 
468     function _takeTeam(uint256 tTeam) private {
469         uint256 currentRate = _getRate();
470         uint256 rTeam = tTeam.mul(currentRate);
471         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
472     }
473 
474     function _reflectFee(uint256 rFee, uint256 tFee) private {
475         _rTotal = _rTotal.sub(rFee);
476         _tFeeTotal = _tFeeTotal.add(tFee);
477     }
478 
479     receive() external payable {}
480 
481     function _getValues(uint256 tAmount)
482         private
483         view
484         returns (
485             uint256,
486             uint256,
487             uint256,
488             uint256,
489             uint256,
490             uint256
491         )
492     {
493         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
494             _getTValues(tAmount, _taxFee, _teamFee);
495         uint256 currentRate = _getRate();
496         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
497             _getRValues(tAmount, tFee, tTeam, currentRate);
498         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
499     }
500 
501     function _getTValues(
502         uint256 tAmount,
503         uint256 taxFee,
504         uint256 TeamFee
505     )
506         private
507         pure
508         returns (
509             uint256,
510             uint256,
511             uint256
512         )
513     {
514         uint256 tFee = tAmount.mul(taxFee).div(100);
515         uint256 tTeam = tAmount.mul(TeamFee).div(100);
516         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
517         return (tTransferAmount, tFee, tTeam);
518     }
519 
520     function _getRValues(
521         uint256 tAmount,
522         uint256 tFee,
523         uint256 tTeam,
524         uint256 currentRate
525     )
526         private
527         pure
528         returns (
529             uint256,
530             uint256,
531             uint256
532         )
533     {
534         uint256 rAmount = tAmount.mul(currentRate);
535         uint256 rFee = tFee.mul(currentRate);
536         uint256 rTeam = tTeam.mul(currentRate);
537         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
538         return (rAmount, rTransferAmount, rFee);
539     }
540 
541     function _getRate() private view returns (uint256) {
542         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
543         return rSupply.div(tSupply);
544     }
545 
546     function _getCurrentSupply() private view returns (uint256, uint256) {
547         uint256 rSupply = _rTotal;
548         uint256 tSupply = _tTotal;
549         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
550         return (rSupply, tSupply);
551     }
552 
553     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
554         require(maxTxPercent > 0, "Amount must be greater than 0");
555         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
556         emit MaxTxAmountUpdated(_maxTxAmount);
557     }
558 }