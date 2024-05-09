1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-04
3 */
4 
5 //Lotto Inu (LottoInu)
6 //Limit Buy yes
7 //Cooldown yes
8 //Bot Protect yes
9 //Deflationary yes
10 //Fee yes
11 //Liqudity dev provides and lock
12 //TG: https://t.me/lottoinuofficial
13 //Website: TBA
14 //CG, CMC listing: Ongoing
15 
16 // SPDX-License-Identifier: Unlicensed
17 pragma solidity ^0.8.4;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27 
28     function balanceOf(address account) external view returns (uint256);
29 
30     function transfer(address recipient, uint256 amount)
31         external
32         returns (bool);
33 
34     function allowance(address owner, address spender)
35         external
36         view
37         returns (uint256);
38 
39     function approve(address spender, uint256 amount) external returns (bool);
40 
41     function transferFrom(
42         address sender,
43         address recipient,
44         uint256 amount
45     ) external returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(
49         address indexed owner,
50         address indexed spender,
51         uint256 value
52     );
53 }
54 
55 library SafeMath {
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59         return c;
60     }
61 
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     function sub(
67         uint256 a,
68         uint256 b,
69         string memory errorMessage
70     ) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73         return c;
74     }
75 
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         if (a == 0) {
78             return 0;
79         }
80         uint256 c = a * b;
81         require(c / a == b, "SafeMath: multiplication overflow");
82         return c;
83     }
84 
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return div(a, b, "SafeMath: division by zero");
87     }
88 
89     function div(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         require(b > 0, errorMessage);
95         uint256 c = a / b;
96         return c;
97     }
98 }
99 
100 contract Ownable is Context {
101     address private _owner;
102     address private _previousOwner;
103     event OwnershipTransferred(
104         address indexed previousOwner,
105         address indexed newOwner
106     );
107 
108     constructor() {
109         address msgSender = _msgSender();
110         _owner = msgSender;
111         emit OwnershipTransferred(address(0), msgSender);
112     }
113 
114     function owner() public view returns (address) {
115         return _owner;
116     }
117 
118     modifier onlyOwner() {
119         require(_owner == _msgSender(), "Ownable: caller is not the owner");
120         _;
121     }
122 
123     function renounceOwnership() public virtual onlyOwner {
124         emit OwnershipTransferred(_owner, address(0));
125         _owner = address(0);
126     }
127 }
128 
129 interface IUniswapV2Factory {
130     function createPair(address tokenA, address tokenB)
131         external
132         returns (address pair);
133 }
134 
135 interface IUniswapV2Router02 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint256 amountIn,
138         uint256 amountOutMin,
139         address[] calldata path,
140         address to,
141         uint256 deadline
142     ) external;
143 
144     function factory() external pure returns (address);
145 
146     function WETH() external pure returns (address);
147 
148     function addLiquidityETH(
149         address token,
150         uint256 amountTokenDesired,
151         uint256 amountTokenMin,
152         uint256 amountETHMin,
153         address to,
154         uint256 deadline
155     )
156         external
157         payable
158         returns (
159             uint256 amountToken,
160             uint256 amountETH,
161             uint256 liquidity
162         );
163 }
164 
165 contract LottoInu is Context, IERC20, Ownable {
166     using SafeMath for uint256;
167 
168     string private constant _name = "Lotto Inu";
169     string private constant _symbol = "LottoInu \xF0\x9F\x94\xA5";
170     uint8 private constant _decimals = 9;
171 
172     // RFI
173     mapping(address => uint256) private _rOwned;
174     mapping(address => uint256) private _tOwned;
175     mapping(address => mapping(address => uint256)) private _allowances;
176     mapping(address => bool) private _isExcludedFromFee;
177     uint256 private constant MAX = ~uint256(0);
178     uint256 private constant _tTotal = 1000000000000 * 10**9;
179     uint256 private _rTotal = (MAX - (MAX % _tTotal));
180     uint256 private _tFeeTotal;
181     uint256 private _taxFee = 5;
182     uint256 private _teamFee = 10;
183 
184     // Bot detection
185     mapping(address => bool) private bots;
186     mapping(address => uint256) private cooldown;
187     address payable private _teamAddress;
188     address payable private _marketingFunds;
189     IUniswapV2Router02 private uniswapV2Router;
190     address private uniswapV2Pair;
191     bool private tradingOpen;
192     bool private inSwap = false;
193     bool private swapEnabled = false;
194     bool private cooldownEnabled = false;
195     uint256 private _maxTxAmount = _tTotal;
196 
197     event MaxTxAmountUpdated(uint256 _maxTxAmount);
198     modifier lockTheSwap {
199         inSwap = true;
200         _;
201         inSwap = false;
202     }
203 
204     constructor(address payable addr1, address payable addr2) {
205         _teamAddress = addr1;
206         _marketingFunds = addr2;
207         _rOwned[_msgSender()] = _rTotal;
208         _isExcludedFromFee[owner()] = true;
209         _isExcludedFromFee[address(this)] = true;
210         _isExcludedFromFee[_teamAddress] = true;
211         _isExcludedFromFee[_marketingFunds] = true;
212         emit Transfer(address(0), _msgSender(), _tTotal);
213     }
214 
215     function name() public pure returns (string memory) {
216         return _name;
217     }
218 
219     function symbol() public pure returns (string memory) {
220         return _symbol;
221     }
222 
223     function decimals() public pure returns (uint8) {
224         return _decimals;
225     }
226 
227     function totalSupply() public pure override returns (uint256) {
228         return _tTotal;
229     }
230 
231     function balanceOf(address account) public view override returns (uint256) {
232         return tokenFromReflection(_rOwned[account]);
233     }
234 
235     function transfer(address recipient, uint256 amount)
236         public
237         override
238         returns (bool)
239     {
240         _transfer(_msgSender(), recipient, amount);
241         return true;
242     }
243 
244     function allowance(address owner, address spender)
245         public
246         view
247         override
248         returns (uint256)
249     {
250         return _allowances[owner][spender];
251     }
252 
253     function approve(address spender, uint256 amount)
254         public
255         override
256         returns (bool)
257     {
258         _approve(_msgSender(), spender, amount);
259         return true;
260     }
261 
262     function transferFrom(
263         address sender,
264         address recipient,
265         uint256 amount
266     ) public override returns (bool) {
267         _transfer(sender, recipient, amount);
268         _approve(
269             sender,
270             _msgSender(),
271             _allowances[sender][_msgSender()].sub(
272                 amount,
273                 "ERC20: transfer amount exceeds allowance"
274             )
275         );
276         return true;
277     }
278 
279     function setCooldownEnabled(bool onoff) external onlyOwner() {
280         cooldownEnabled = onoff;
281     }
282 
283     function tokenFromReflection(uint256 rAmount)
284         private
285         view
286         returns (uint256)
287     {
288         require(
289             rAmount <= _rTotal,
290             "Amount must be less than total reflections"
291         );
292         uint256 currentRate = _getRate();
293         return rAmount.div(currentRate);
294     }
295 
296     function removeAllFee() private {
297         if (_taxFee == 0 && _teamFee == 0) return;
298         _taxFee = 0;
299         _teamFee = 0;
300     }
301 
302     function restoreAllFee() private {
303         _taxFee = 5;
304         _teamFee = 12;
305     }
306 
307     function _approve(
308         address owner,
309         address spender,
310         uint256 amount
311     ) private {
312         require(owner != address(0), "ERC20: approve from the zero address");
313         require(spender != address(0), "ERC20: approve to the zero address");
314         _allowances[owner][spender] = amount;
315         emit Approval(owner, spender, amount);
316     }
317 
318     function _transfer(
319         address from,
320         address to,
321         uint256 amount
322     ) private {
323         require(from != address(0), "ERC20: transfer from the zero address");
324         require(to != address(0), "ERC20: transfer to the zero address");
325         require(amount > 0, "Transfer amount must be greater than zero");
326 
327         if (from != owner() && to != owner()) {
328             if (cooldownEnabled) {
329                 if (
330                     from != address(this) &&
331                     to != address(this) &&
332                     from != address(uniswapV2Router) &&
333                     to != address(uniswapV2Router)
334                 ) {
335                     require(
336                         _msgSender() == address(uniswapV2Router) ||
337                             _msgSender() == uniswapV2Pair,
338                         "ERR: Uniswap only"
339                     );
340                 }
341             }
342             require(amount <= _maxTxAmount);
343             require(!bots[from] && !bots[to]);
344             if (
345                 from == uniswapV2Pair &&
346                 to != address(uniswapV2Router) &&
347                 !_isExcludedFromFee[to] &&
348                 cooldownEnabled
349             ) {
350                 require(cooldown[to] < block.timestamp);
351                 cooldown[to] = block.timestamp + (60 seconds);
352             }
353             uint256 contractTokenBalance = balanceOf(address(this));
354             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
355                 swapTokensForEth(contractTokenBalance);
356                 uint256 contractETHBalance = address(this).balance;
357                 if (contractETHBalance > 0) {
358                     sendETHToFee(address(this).balance);
359                 }
360             }
361         }
362         bool takeFee = true;
363 
364         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
365             takeFee = false;
366         }
367 
368         _tokenTransfer(from, to, amount, takeFee);
369     }
370 
371     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
372         address[] memory path = new address[](2);
373         path[0] = address(this);
374         path[1] = uniswapV2Router.WETH();
375         _approve(address(this), address(uniswapV2Router), tokenAmount);
376         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
377             tokenAmount,
378             0,
379             path,
380             address(this),
381             block.timestamp
382         );
383     }
384 
385     function sendETHToFee(uint256 amount) private {
386         _teamAddress.transfer(amount.div(2));
387         _marketingFunds.transfer(amount.div(2));
388     }
389 
390     function openTrading() external onlyOwner() {
391         require(!tradingOpen, "trading is already open");
392         IUniswapV2Router02 _uniswapV2Router =
393             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
394         uniswapV2Router = _uniswapV2Router;
395         _approve(address(this), address(uniswapV2Router), _tTotal);
396         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
397             .createPair(address(this), _uniswapV2Router.WETH());
398         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
399             address(this),
400             balanceOf(address(this)),
401             0,
402             0,
403             owner(),
404             block.timestamp
405         );
406         swapEnabled = true;
407         cooldownEnabled = true;
408         _maxTxAmount = 2500000000 * 10**9;
409         tradingOpen = true;
410         IERC20(uniswapV2Pair).approve(
411             address(uniswapV2Router),
412             type(uint256).max
413         );
414     }
415 
416     function manualswap() external {
417         require(_msgSender() == _teamAddress);
418         uint256 contractBalance = balanceOf(address(this));
419         swapTokensForEth(contractBalance);
420     }
421 
422     function manualsend() external {
423         require(_msgSender() == _teamAddress);
424         uint256 contractETHBalance = address(this).balance;
425         sendETHToFee(contractETHBalance);
426     }
427 
428     function setBots(address[] memory bots_) public onlyOwner {
429         for (uint256 i = 0; i < bots_.length; i++) {
430             bots[bots_[i]] = true;
431         }
432     }
433 
434     function delBot(address notbot) public onlyOwner {
435         bots[notbot] = false;
436     }
437 
438     function _tokenTransfer(
439         address sender,
440         address recipient,
441         uint256 amount,
442         bool takeFee
443     ) private {
444         if (!takeFee) removeAllFee();
445         _transferStandard(sender, recipient, amount);
446         if (!takeFee) restoreAllFee();
447     }
448 
449     function _transferStandard(
450         address sender,
451         address recipient,
452         uint256 tAmount
453     ) private {
454         (
455             uint256 rAmount,
456             uint256 rTransferAmount,
457             uint256 rFee,
458             uint256 tTransferAmount,
459             uint256 tFee,
460             uint256 tTeam
461         ) = _getValues(tAmount);
462         _rOwned[sender] = _rOwned[sender].sub(rAmount);
463         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
464         _takeTeam(tTeam);
465         _reflectFee(rFee, tFee);
466         emit Transfer(sender, recipient, tTransferAmount);
467     }
468 
469     function _takeTeam(uint256 tTeam) private {
470         uint256 currentRate = _getRate();
471         uint256 rTeam = tTeam.mul(currentRate);
472         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
473     }
474 
475     function _reflectFee(uint256 rFee, uint256 tFee) private {
476         _rTotal = _rTotal.sub(rFee);
477         _tFeeTotal = _tFeeTotal.add(tFee);
478     }
479 
480     receive() external payable {}
481 
482     function _getValues(uint256 tAmount)
483         private
484         view
485         returns (
486             uint256,
487             uint256,
488             uint256,
489             uint256,
490             uint256,
491             uint256
492         )
493     {
494         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
495             _getTValues(tAmount, _taxFee, _teamFee);
496         uint256 currentRate = _getRate();
497         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
498             _getRValues(tAmount, tFee, tTeam, currentRate);
499         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
500     }
501 
502     function _getTValues(
503         uint256 tAmount,
504         uint256 taxFee,
505         uint256 TeamFee
506     )
507         private
508         pure
509         returns (
510             uint256,
511             uint256,
512             uint256
513         )
514     {
515         uint256 tFee = tAmount.mul(taxFee).div(100);
516         uint256 tTeam = tAmount.mul(TeamFee).div(100);
517         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
518         return (tTransferAmount, tFee, tTeam);
519     }
520 
521     function _getRValues(
522         uint256 tAmount,
523         uint256 tFee,
524         uint256 tTeam,
525         uint256 currentRate
526     )
527         private
528         pure
529         returns (
530             uint256,
531             uint256,
532             uint256
533         )
534     {
535         uint256 rAmount = tAmount.mul(currentRate);
536         uint256 rFee = tFee.mul(currentRate);
537         uint256 rTeam = tTeam.mul(currentRate);
538         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
539         return (rAmount, rTransferAmount, rFee);
540     }
541 
542     function _getRate() private view returns (uint256) {
543         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
544         return rSupply.div(tSupply);
545     }
546 
547     function _getCurrentSupply() private view returns (uint256, uint256) {
548         uint256 rSupply = _rTotal;
549         uint256 tSupply = _tTotal;
550         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
551         return (rSupply, tSupply);
552     }
553 
554     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
555         require(maxTxPercent > 0, "Amount must be greater than 0");
556         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
557         emit MaxTxAmountUpdated(_maxTxAmount);
558     }
559 }