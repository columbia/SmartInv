1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-23
3 */
4 
5 //ElonFloki (ElonFloki)
6 //Elon Musk's SHIB name is Floki
7 //Powerful Bot Protect yes
8 
9 //2% Deflationary yes
10 //Telegram: https://t.me/ElonFlokiOfficial
11 
12 //CG, CMC listing: Ongoing
13 //Fair Launch
14 //Community Driven - 100% Community Owned!
15 
16 
17 // SPDX-License-Identifier: Unlicensed
18 pragma solidity ^0.8.4;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28 
29     function balanceOf(address account) external view returns (uint256);
30 
31     function transfer(address recipient, uint256 amount)
32         external
33         returns (bool);
34 
35     function allowance(address owner, address spender)
36         external
37         view
38         returns (uint256);
39 
40     function approve(address spender, uint256 amount) external returns (bool);
41 
42     function transferFrom(
43         address sender,
44         address recipient,
45         uint256 amount
46     ) external returns (bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(
50         address indexed owner,
51         address indexed spender,
52         uint256 value
53     );
54 }
55 
56 library SafeMath {
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     function sub(
68         uint256 a,
69         uint256 b,
70         string memory errorMessage
71     ) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74         return c;
75     }
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) {
79             return 0;
80         }
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83         return c;
84     }
85 
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     function div(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         require(b > 0, errorMessage);
96         uint256 c = a / b;
97         return c;
98     }
99 }
100 
101 contract Ownable is Context {
102     address private _owner;
103     address private _previousOwner;
104     event OwnershipTransferred(
105         address indexed previousOwner,
106         address indexed newOwner
107     );
108 
109     constructor() {
110         address msgSender = _msgSender();
111         _owner = msgSender;
112         emit OwnershipTransferred(address(0), msgSender);
113     }
114 
115     function owner() public view returns (address) {
116         return _owner;
117     }
118 
119     modifier onlyOwner() {
120         require(_owner == _msgSender(), "Ownable: caller is not the owner");
121         _;
122     }
123 
124     function renounceOwnership() public virtual onlyOwner {
125         emit OwnershipTransferred(_owner, address(0));
126         _owner = address(0);
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
166 contract ElonFloki is Context, IERC20, Ownable {
167     using SafeMath for uint256;
168 
169     string private constant _name = "ElonFloki | t.me/ElonFlokiOfficial";
170     string private constant _symbol = "ElonFloki\xF0\x9F\x90\x95";
171     uint8 private constant _decimals = 9;
172 
173     // RFI
174     mapping(address => uint256) private _rOwned;
175     mapping(address => uint256) private _tOwned;
176     mapping(address => mapping(address => uint256)) private _allowances;
177     mapping(address => bool) private _isExcludedFromFee;
178     uint256 private constant MAX = ~uint256(0);
179     uint256 private constant _tTotal = 1000000000000 * 10**9;
180     uint256 private _rTotal = (MAX - (MAX % _tTotal));
181     uint256 private _tFeeTotal;
182     uint256 private _taxFee = 2;
183     uint256 private _teamFee = 3;
184 
185     // Bot detection
186     mapping(address => bool) private bots;
187     mapping(address => uint256) private cooldown;
188     address payable private _teamAddress;
189     address payable private _marketingFunds;
190     IUniswapV2Router02 private uniswapV2Router;
191     address private uniswapV2Pair;
192     bool private tradingOpen;
193     bool private inSwap = false;
194     bool private swapEnabled = false;
195     bool private cooldownEnabled = false;
196     uint256 private _maxTxAmount = _tTotal;
197 
198     event MaxTxAmountUpdated(uint256 _maxTxAmount);
199     modifier lockTheSwap {
200         inSwap = true;
201         _;
202         inSwap = false;
203     }
204 
205     constructor(address payable addr1, address payable addr2) {
206         _teamAddress = addr1;
207         _marketingFunds = addr2;
208         _rOwned[_msgSender()] = _rTotal;
209         _isExcludedFromFee[owner()] = true;
210         _isExcludedFromFee[address(this)] = true;
211         _isExcludedFromFee[_teamAddress] = true;
212         _isExcludedFromFee[_marketingFunds] = true;
213         emit Transfer(address(0), _msgSender(), _tTotal);
214     }
215 
216     function name() public pure returns (string memory) {
217         return _name;
218     }
219 
220     function symbol() public pure returns (string memory) {
221         return _symbol;
222     }
223 
224     function decimals() public pure returns (uint8) {
225         return _decimals;
226     }
227 
228     function totalSupply() public pure override returns (uint256) {
229         return _tTotal;
230     }
231 
232     function balanceOf(address account) public view override returns (uint256) {
233         return tokenFromReflection(_rOwned[account]);
234     }
235 
236     function transfer(address recipient, uint256 amount)
237         public
238         override
239         returns (bool)
240     {
241         _transfer(_msgSender(), recipient, amount);
242         return true;
243     }
244 
245     function allowance(address owner, address spender)
246         public
247         view
248         override
249         returns (uint256)
250     {
251         return _allowances[owner][spender];
252     }
253 
254     function approve(address spender, uint256 amount)
255         public
256         override
257         returns (bool)
258     {
259         _approve(_msgSender(), spender, amount);
260         return true;
261     }
262 
263     function transferFrom(
264         address sender,
265         address recipient,
266         uint256 amount
267     ) public override returns (bool) {
268         _transfer(sender, recipient, amount);
269         _approve(
270             sender,
271             _msgSender(),
272             _allowances[sender][_msgSender()].sub(
273                 amount,
274                 "ERC20: transfer amount exceeds allowance"
275             )
276         );
277         return true;
278     }
279 
280     function setCooldownEnabled(bool onoff) external onlyOwner() {
281         cooldownEnabled = onoff;
282     }
283 
284     function tokenFromReflection(uint256 rAmount)
285         private
286         view
287         returns (uint256)
288     {
289         require(
290             rAmount <= _rTotal,
291             "Amount must be less than total reflections"
292         );
293         uint256 currentRate = _getRate();
294         return rAmount.div(currentRate);
295     }
296 
297     function removeAllFee() private {
298         if (_taxFee == 0 && _teamFee == 0) return;
299         _taxFee = 0;
300         _teamFee = 0;
301     }
302 
303     function restoreAllFee() private {
304         _taxFee = 2;
305         _teamFee = 3;
306     }
307 
308     function _approve(
309         address owner,
310         address spender,
311         uint256 amount
312     ) private {
313         require(owner != address(0), "ERC20: approve from the zero address");
314         require(spender != address(0), "ERC20: approve to the zero address");
315         _allowances[owner][spender] = amount;
316         emit Approval(owner, spender, amount);
317     }
318 
319     function _transfer(
320         address from,
321         address to,
322         uint256 amount
323     ) private {
324         require(from != address(0), "ERC20: transfer from the zero address");
325         require(to != address(0), "ERC20: transfer to the zero address");
326         require(amount > 0, "Transfer amount must be greater than zero");
327 
328         if (from != owner() && to != owner()) {
329             if (cooldownEnabled) {
330                 if (
331                     from != address(this) &&
332                     to != address(this) &&
333                     from != address(uniswapV2Router) &&
334                     to != address(uniswapV2Router)
335                 ) {
336                     require(
337                         _msgSender() == address(uniswapV2Router) ||
338                             _msgSender() == uniswapV2Pair,
339                         "ERR: Uniswap only"
340                     );
341                 }
342             }
343             require(amount <= _maxTxAmount);
344             require(!bots[from] && !bots[to]);
345             if (
346                 from == uniswapV2Pair &&
347                 to != address(uniswapV2Router) &&
348                 !_isExcludedFromFee[to] &&
349                 cooldownEnabled
350             ) {
351                 require(cooldown[to] < block.timestamp);
352                 cooldown[to] = block.timestamp + (60 seconds);
353             }
354             uint256 contractTokenBalance = balanceOf(address(this));
355             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
356                 swapTokensForEth(contractTokenBalance);
357                 uint256 contractETHBalance = address(this).balance;
358                 if (contractETHBalance > 0) {
359                     sendETHToFee(address(this).balance);
360                 }
361             }
362         }
363         bool takeFee = true;
364 
365         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
366             takeFee = false;
367         }
368 
369         _tokenTransfer(from, to, amount, takeFee);
370     }
371 
372     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
373         address[] memory path = new address[](2);
374         path[0] = address(this);
375         path[1] = uniswapV2Router.WETH();
376         _approve(address(this), address(uniswapV2Router), tokenAmount);
377         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
378             tokenAmount,
379             0,
380             path,
381             address(this),
382             block.timestamp
383         );
384     }
385 
386     function sendETHToFee(uint256 amount) private {
387         _teamAddress.transfer(amount.mul(4).div(10));
388         _marketingFunds.transfer(amount.mul(6).div(10));
389     }
390 
391     function openTrading() external onlyOwner() {
392         require(!tradingOpen, "trading is already open");
393         IUniswapV2Router02 _uniswapV2Router =
394             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
395         uniswapV2Router = _uniswapV2Router;
396         _approve(address(this), address(uniswapV2Router), _tTotal);
397         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
398             .createPair(address(this), _uniswapV2Router.WETH());
399         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
400             address(this),
401             balanceOf(address(this)),
402             0,
403             0,
404             owner(),
405             block.timestamp
406         );
407         swapEnabled = true;
408         cooldownEnabled = true;
409         _maxTxAmount = 2500000000 * 10**9;
410         tradingOpen = true;
411         IERC20(uniswapV2Pair).approve(
412             address(uniswapV2Router),
413             type(uint256).max
414         );
415     }
416 
417     function manualswap() external {
418         require(_msgSender() == _teamAddress);
419         uint256 contractBalance = balanceOf(address(this));
420         swapTokensForEth(contractBalance);
421     }
422 
423     function manualsend() external {
424         require(_msgSender() == _teamAddress);
425         uint256 contractETHBalance = address(this).balance;
426         sendETHToFee(contractETHBalance);
427     }
428 
429     function setBots(address[] memory bots_) public onlyOwner {
430         for (uint256 i = 0; i < bots_.length; i++) {
431             bots[bots_[i]] = true;
432         }
433     }
434 
435     function delBot(address notbot) public onlyOwner {
436         bots[notbot] = false;
437     }
438 
439     function _tokenTransfer(
440         address sender,
441         address recipient,
442         uint256 amount,
443         bool takeFee
444     ) private {
445         if (!takeFee) removeAllFee();
446         _transferStandard(sender, recipient, amount);
447         if (!takeFee) restoreAllFee();
448     }
449 
450     function _transferStandard(
451         address sender,
452         address recipient,
453         uint256 tAmount
454     ) private {
455         (
456             uint256 rAmount,
457             uint256 rTransferAmount,
458             uint256 rFee,
459             uint256 tTransferAmount,
460             uint256 tFee,
461             uint256 tTeam
462         ) = _getValues(tAmount);
463         _rOwned[sender] = _rOwned[sender].sub(rAmount);
464         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
465         _takeTeam(tTeam);
466         _reflectFee(rFee, tFee);
467         emit Transfer(sender, recipient, tTransferAmount);
468     }
469 
470     function _takeTeam(uint256 tTeam) private {
471         uint256 currentRate = _getRate();
472         uint256 rTeam = tTeam.mul(currentRate);
473         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
474     }
475 
476     function _reflectFee(uint256 rFee, uint256 tFee) private {
477         _rTotal = _rTotal.sub(rFee);
478         _tFeeTotal = _tFeeTotal.add(tFee);
479     }
480 
481     receive() external payable {}
482 
483     function _getValues(uint256 tAmount)
484         private
485         view
486         returns (
487             uint256,
488             uint256,
489             uint256,
490             uint256,
491             uint256,
492             uint256
493         )
494     {
495         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
496             _getTValues(tAmount, _taxFee, 12);
497         uint256 currentRate = _getRate();
498         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
499             _getRValues(tAmount, tFee, tTeam, currentRate);
500         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
501     }
502 
503     function _getTValues(
504         uint256 tAmount,
505         uint256 taxFee,
506         uint256 TeamFee
507     )
508         private
509         pure
510         returns (
511             uint256,
512             uint256,
513             uint256
514         )
515     {
516         uint256 tFee = tAmount.mul(taxFee).div(100);
517         uint256 tTeam = tAmount.mul(TeamFee).div(100);
518         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
519         return (tTransferAmount, tFee, tTeam);
520     }
521 
522     function _getRValues(
523         uint256 tAmount,
524         uint256 tFee,
525         uint256 tTeam,
526         uint256 currentRate
527     )
528         private
529         pure
530         returns (
531             uint256,
532             uint256,
533             uint256
534         )
535     {
536         uint256 rAmount = tAmount.mul(currentRate);
537         uint256 rFee = tFee.mul(currentRate);
538         uint256 rTeam = tTeam.mul(currentRate);
539         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
540         return (rAmount, rTransferAmount, rFee);
541     }
542 
543     function _getRate() private view returns (uint256) {
544         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
545         return rSupply.div(tSupply);
546     }
547 
548     function _getCurrentSupply() private view returns (uint256, uint256) {
549         uint256 rSupply = _rTotal;
550         uint256 tSupply = _tTotal;
551         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
552         return (rSupply, tSupply);
553     }
554 
555     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
556         require(maxTxPercent > 0, "Amount must be greater than 0");
557         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
558         emit MaxTxAmountUpdated(_maxTxAmount);
559     }
560 }