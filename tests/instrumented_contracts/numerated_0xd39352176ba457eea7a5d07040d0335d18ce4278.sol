1 // Youta Inu ($YOUTA)
2 
3 
4 // Telegram: https://t.me/youtainu
5 
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity ^0.8.4;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 library SafeMath {
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27 
28     function sub(
29         uint256 a,
30         uint256 b,
31         string memory errorMessage
32     ) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35         return c;
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50 
51     function div(
52         uint256 a,
53         uint256 b,
54         string memory errorMessage
55     ) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 }
61 
62 interface IERC20 {
63     function totalSupply() external view returns (uint256);
64 
65     function balanceOf(address account) external view returns (uint256);
66 
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 contract Ownable is Context {
80     address private _owner;
81     address private _previousOwner;
82     event OwnershipTransferred(
83         address indexed previousOwner,
84         address indexed newOwner
85     );
86 
87     constructor() {
88         address msgSender = _msgSender();
89         _owner = msgSender;
90         emit OwnershipTransferred(address(0), msgSender);
91     }
92 
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     modifier onlyOwner() {
98         require(_owner == _msgSender(), "Ownable: caller is not the owner");
99         _;
100     }
101 
102     function renounceOwnership() public virtual onlyOwner {
103         emit OwnershipTransferred(_owner, address(0));
104         _owner = address(0);
105     }
106 }
107 
108 interface IUniswapV2Factory {
109     function createPair(address tokenA, address tokenB)
110         external
111         returns (address pair);
112 }
113 
114 interface IUniswapV2Router02 {
115     function swapExactTokensForETHSupportingFeeOnTransferTokens(
116         uint256 amountIn,
117         uint256 amountOutMin,
118         address[] calldata path,
119         address to,
120         uint256 deadline
121     ) external;
122 
123     function factory() external pure returns (address);
124 
125     function WETH() external pure returns (address);
126 
127     function addLiquidityETH(
128         address token,
129         uint256 amountTokenDesired,
130         uint256 amountTokenMin,
131         uint256 amountETHMin,
132         address to,
133         uint256 deadline
134     )
135         external
136         payable
137         returns (
138             uint256 amountToken,
139             uint256 amountETH,
140             uint256 liquidity
141         );
142 }
143 
144 contract YOUTAINU is Context, IERC20, Ownable {
145     using SafeMath for uint256;
146 
147     string private constant _name = "Youta Inu";
148     string private constant _symbol = "YOUTA";
149     uint8 private constant _decimals = 9;
150 
151     // RFI
152     mapping(address => uint256) private _rOwned;
153     mapping(address => uint256) private _tOwned;
154     mapping(address => mapping(address => uint256)) private _allowances;
155     mapping(address => bool) private _isExcludedFromFee;
156     uint256 private constant MAX = ~uint256(0);
157     uint256 private constant _tTotal = 1000000000000 * 10**9;
158     uint256 private _rTotal = (MAX - (MAX % _tTotal));
159     uint256 private _tFeeTotal;
160     uint256 private _taxFee = 5;
161     uint256 private _teamFee = 10;
162 
163     // Bot detection
164     mapping(address => bool) private bots;
165     mapping(address => uint256) private cooldown;
166     address payable private _teamAddress;
167     address payable private _marketingFunds;
168     IUniswapV2Router02 private uniswapV2Router;
169     address private uniswapV2Pair;
170     bool private tradingOpen;
171     bool private inSwap = false;
172     bool private swapEnabled = false;
173     bool private cooldownEnabled = false;
174     uint256 private _maxTxAmount = _tTotal;
175     uint256 private _cooldownSeconds = 60;
176 
177     event MaxTxAmountUpdated(uint256 _maxTxAmount);
178     modifier lockTheSwap {
179         inSwap = true;
180         _;
181         inSwap = false;
182     }
183 
184     constructor(address payable addr1, address payable addr2) {
185         _teamAddress = addr1;
186         _marketingFunds = addr2;
187         _rOwned[_msgSender()] = _rTotal;
188         _isExcludedFromFee[owner()] = true;
189         _isExcludedFromFee[address(this)] = true;
190         _isExcludedFromFee[_teamAddress] = true;
191         _isExcludedFromFee[_marketingFunds] = true;
192         emit Transfer(address(0), _msgSender(), _tTotal);
193     }
194 
195     function name() public pure returns (string memory) {
196         return _name;
197     }
198 
199     function symbol() public pure returns (string memory) {
200         return _symbol;
201     }
202 
203     function decimals() public pure returns (uint8) {
204         return _decimals;
205     }
206 
207     function totalSupply() public pure override returns (uint256) {
208         return _tTotal;
209     }
210 
211     function balanceOf(address account) public view override returns (uint256) {
212         return tokenFromReflection(_rOwned[account]);
213     }
214 
215     function transfer(address recipient, uint256 amount)
216         public
217         override
218         returns (bool)
219     {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     function allowance(address owner, address spender)
225         public
226         view
227         override
228         returns (uint256)
229     {
230         return _allowances[owner][spender];
231     }
232 
233     function approve(address spender, uint256 amount)
234         public
235         override
236         returns (bool)
237     {
238         _approve(_msgSender(), spender, amount);
239         return true;
240     }
241 
242     function transferFrom(
243         address sender,
244         address recipient,
245         uint256 amount
246     ) public override returns (bool) {
247         _transfer(sender, recipient, amount);
248         _approve(
249             sender,
250             _msgSender(),
251             _allowances[sender][_msgSender()].sub(
252                 amount,
253                 "ERC20: transfer amount exceeds allowance"
254             )
255         );
256         return true;
257     }
258 
259     function setCooldownEnabled(bool onoff) external onlyOwner() {
260         cooldownEnabled = onoff;
261     }
262 
263     function tokenFromReflection(uint256 rAmount)
264         private
265         view
266         returns (uint256)
267     {
268         require(
269             rAmount <= _rTotal,
270             "Amount must be less than total reflections"
271         );
272         uint256 currentRate = _getRate();
273         return rAmount.div(currentRate);
274     }
275 
276     function removeAllFee() private {
277         if (_taxFee == 0 && _teamFee == 0) return;
278         _taxFee = 0;
279         _teamFee = 0;
280     }
281 
282     function restoreAllFee() private {
283         _taxFee = 5;
284         _teamFee = 10;
285     }
286 
287     function _approve(
288         address owner,
289         address spender,
290         uint256 amount
291     ) private {
292         require(owner != address(0), "ERC20: approve from the zero address");
293         require(spender != address(0), "ERC20: approve to the zero address");
294         _allowances[owner][spender] = amount;
295         emit Approval(owner, spender, amount);
296     }
297 
298     function _transfer(
299         address from,
300         address to,
301         uint256 amount
302     ) private {
303         require(from != address(0), "ERC20: transfer from the zero address");
304         require(to != address(0), "ERC20: transfer to the zero address");
305         require(amount > 0, "Transfer amount must be greater than zero");
306 
307         if (from != owner() && to != owner()) {
308             if (cooldownEnabled) {
309                 if (
310                     from != address(this) &&
311                     to != address(this) &&
312                     from != address(uniswapV2Router) &&
313                     to != address(uniswapV2Router)
314                 ) {
315                     require(
316                         _msgSender() == address(uniswapV2Router) ||
317                             _msgSender() == uniswapV2Pair,
318                         "ERR: Uniswap only"
319                     );
320                 }
321             }
322             require(amount <= _maxTxAmount);
323             require(!bots[from] && !bots[to]);
324             if (
325                 from == uniswapV2Pair &&
326                 to != address(uniswapV2Router) &&
327                 !_isExcludedFromFee[to] &&
328                 cooldownEnabled
329             ) {
330                 require(cooldown[to] < block.timestamp);
331                 cooldown[to] = block.timestamp + (_cooldownSeconds * 1 seconds);
332             }
333             uint256 contractTokenBalance = balanceOf(address(this));
334             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
335                 swapTokensForEth(contractTokenBalance);
336                 uint256 contractETHBalance = address(this).balance;
337                 if (contractETHBalance > 0) {
338                     sendETHToFee(address(this).balance);
339                 }
340             }
341         }
342         bool takeFee = true;
343 
344         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
345             takeFee = false;
346         }
347 
348         _tokenTransfer(from, to, amount, takeFee);
349     }
350 
351     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
352         address[] memory path = new address[](2);
353         path[0] = address(this);
354         path[1] = uniswapV2Router.WETH();
355         _approve(address(this), address(uniswapV2Router), tokenAmount);
356         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
357             tokenAmount,
358             0,
359             path,
360             address(this),
361             block.timestamp
362         );
363     }
364 
365     function sendETHToFee(uint256 amount) private {
366         _teamAddress.transfer(amount.div(2));
367         _marketingFunds.transfer(amount.div(2));
368     }
369 
370     function addLiquidityETH() external onlyOwner() {
371         require(!tradingOpen, "trading is already started");
372         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
373         uniswapV2Router = _uniswapV2Router;
374         _approve(address(this), address(uniswapV2Router), _tTotal);
375         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
376             .createPair(address(this), _uniswapV2Router.WETH());
377         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
378             address(this),
379             balanceOf(address(this)),
380             0,
381             0,
382             owner(),
383             block.timestamp
384         );
385         swapEnabled = true;
386         cooldownEnabled = true;
387         _maxTxAmount = 10000000000 * 10**9;
388         tradingOpen = true;
389         IERC20(uniswapV2Pair).approve(
390             address(uniswapV2Router),
391             type(uint256).max
392         );
393     }
394 
395     function manualswap() external {
396         require(_msgSender() == _teamAddress);
397         uint256 contractBalance = balanceOf(address(this));
398         swapTokensForEth(contractBalance);
399     }
400 
401     function manualsend() external {
402         require(_msgSender() == _teamAddress);
403         uint256 contractETHBalance = address(this).balance;
404         sendETHToFee(contractETHBalance);
405     }
406 
407     function blockBots(address[] memory bots_) public onlyOwner {
408         for (uint256 i = 0; i < bots_.length; i++) {
409             bots[bots_[i]] = true;
410         }
411     }
412 
413     function unblockBot(address notbot) public onlyOwner {
414         bots[notbot] = false;
415     }
416 
417     function _tokenTransfer(
418         address sender,
419         address recipient,
420         uint256 amount,
421         bool takeFee
422     ) private {
423         if (!takeFee) removeAllFee();
424         _transferStandard(sender, recipient, amount);
425         if (!takeFee) restoreAllFee();
426     }
427 
428     function _transferStandard(
429         address sender,
430         address recipient,
431         uint256 tAmount
432     ) private {
433         (
434             uint256 rAmount,
435             uint256 rTransferAmount,
436             uint256 rFee,
437             uint256 tTransferAmount,
438             uint256 tFee,
439             uint256 tTeam
440         ) = _getValues(tAmount);
441         _rOwned[sender] = _rOwned[sender].sub(rAmount);
442         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
443         _takeTeam(tTeam);
444         _reflectFee(rFee, tFee);
445         emit Transfer(sender, recipient, tTransferAmount);
446     }
447 
448     function _takeTeam(uint256 tTeam) private {
449         uint256 currentRate = _getRate();
450         uint256 rTeam = tTeam.mul(currentRate);
451         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
452     }
453 
454     function _reflectFee(uint256 rFee, uint256 tFee) private {
455         _rTotal = _rTotal.sub(rFee);
456         _tFeeTotal = _tFeeTotal.add(tFee);
457     }
458 
459     receive() external payable {}
460 
461     function _getValues(uint256 tAmount)
462         private
463         view
464         returns (
465             uint256,
466             uint256,
467             uint256,
468             uint256,
469             uint256,
470             uint256
471         )
472     {
473         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
474             _getTValues(tAmount, _taxFee, _teamFee);
475         uint256 currentRate = _getRate();
476         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
477             _getRValues(tAmount, tFee, tTeam, currentRate);
478         
479         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
480     }
481 
482     function _getTValues(
483         uint256 tAmount,
484         uint256 taxFee,
485         uint256 TeamFee
486     )
487         private
488         pure
489         returns (
490             uint256,
491             uint256,
492             uint256
493         )
494     {
495         uint256 tFee = tAmount.mul(taxFee).div(100);
496         uint256 tTeam = tAmount.mul(TeamFee).div(100);
497         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
498 
499         return (tTransferAmount, tFee, tTeam);
500     }
501 
502     function _getRValues(
503         uint256 tAmount,
504         uint256 tFee,
505         uint256 tTeam,
506         uint256 currentRate
507     )
508         private
509         pure
510         returns (
511             uint256,
512             uint256,
513             uint256
514         )
515     {
516         uint256 rAmount = tAmount.mul(currentRate);
517         uint256 rFee = tFee.mul(currentRate);
518         uint256 rTeam = tTeam.mul(currentRate);
519         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
520 
521         return (rAmount, rTransferAmount, rFee);
522     }
523 
524     function _getRate() private view returns (uint256) {
525         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
526 
527         return rSupply.div(tSupply);
528     }
529 
530     function _getCurrentSupply() private view returns (uint256, uint256) {
531         uint256 rSupply = _rTotal;
532         uint256 tSupply = _tTotal;
533         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
534 
535         return (rSupply, tSupply);
536     }
537 
538     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
539         require(maxTxPercent > 0, "Amount must be greater than 0");
540         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
541         emit MaxTxAmountUpdated(_maxTxAmount);
542     }
543 
544     function setCooldownSeconds(uint256 cooldownSecs) external onlyOwner() {
545         require(cooldownSecs > 0, "Secs must be greater than 0");
546         _cooldownSeconds = cooldownSecs;
547     }
548 }