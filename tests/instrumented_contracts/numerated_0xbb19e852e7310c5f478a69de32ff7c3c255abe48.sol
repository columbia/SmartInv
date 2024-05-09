1 // 1goonrich token ($1goonrich)
2 
3 
4 //   $$\                                                    $$\           $$\       
5 // $$$$ |                                                   \__|          $$ |      
6 // \_$$ |  $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$$\   $$$$$$\  $$\  $$$$$$$\ $$$$$$$\  
7 //   $$ | $$  __$$\ $$  __$$\ $$  __$$\ $$  __$$\ $$  __$$\ $$ |$$  _____|$$  __$$\ 
8 //   $$ | $$ /  $$ |$$ /  $$ |$$ /  $$ |$$ |  $$ |$$ |  \__|$$ |$$ /      $$ |  $$ |
9 //   $$ | $$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |      $$ |$$ |      $$ |  $$ |
10 // $$$$$$\\$$$$$$$ |\$$$$$$  |\$$$$$$  |$$ |  $$ |$$ |      $$ |\$$$$$$$\ $$ |  $$ |
11 // \______|\____$$ | \______/  \______/ \__|  \__|\__|      \__| \_______|\__|  \__|
12 //        $$\   $$ |                                                                
13 //        \$$$$$$  |                                                                
14 //         \______/                                                                 
15 
16 
17 // Telegram: https://t.me/onegoonrichtoken
18 
19 // SPDX-License-Identifier: Unlicensed
20 
21 pragma solidity ^0.8.4;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address account) external view returns (uint256);
33 
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract Ownable is Context {
47     address private _owner;
48     address private _previousOwner;
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53 
54     constructor() {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     function renounceOwnership() public virtual onlyOwner {
70         emit OwnershipTransferred(_owner, address(0));
71         _owner = address(0);
72     }
73 }
74 
75 library SafeMath {
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79         return c;
80     }
81 
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     function sub(
87         uint256 a,
88         uint256 b,
89         string memory errorMessage
90     ) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93         return c;
94     }
95 
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         if (a == 0) {
98             return 0;
99         }
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     function div(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         return c;
117     }
118 }
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB)
122         external
123         returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint256 amountIn,
129         uint256 amountOutMin,
130         address[] calldata path,
131         address to,
132         uint256 deadline
133     ) external;
134 
135     function factory() external pure returns (address);
136 
137     function WETH() external pure returns (address);
138 
139     function addLiquidityETH(
140         address token,
141         uint256 amountTokenDesired,
142         uint256 amountTokenMin,
143         uint256 amountETHMin,
144         address to,
145         uint256 deadline
146     )
147         external
148         payable
149         returns (
150             uint256 amountToken,
151             uint256 amountETH,
152             uint256 liquidity
153         );
154 }
155 
156 contract onegoonrich is Context, IERC20, Ownable {
157     using SafeMath for uint256;
158 
159     string private constant _name = "1goonrich token";
160     string private constant _symbol = "1goonrich";
161     uint8 private constant _decimals = 9;
162 
163     // RFI
164     mapping(address => uint256) private _rOwned;
165     mapping(address => uint256) private _tOwned;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private constant _tTotal = 1000000000000 * 10**9;
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172     uint256 private _taxFee = 2;
173     uint256 private _teamFee = 2;
174 
175     // Bot detection
176     mapping(address => bool) private bots;
177     mapping(address => uint256) private cooldown;
178     address payable private _teamAddress;
179     address payable private _marketingFunds;
180     IUniswapV2Router02 private uniswapV2Router;
181     address private uniswapV2Pair;
182     bool private tradingOpen;
183     bool private inSwap = false;
184     bool private swapEnabled = false;
185     bool private cooldownEnabled = false;
186     uint256 private _maxTxAmount = _tTotal;
187     uint256 private _cooldownSeconds = 40;
188 
189     event MaxTxAmountUpdated(uint256 _maxTxAmount);
190     modifier lockTheSwap {
191         inSwap = true;
192         _;
193         inSwap = false;
194     }
195 
196     constructor(address payable addr1, address payable addr2) {
197         _teamAddress = addr1;
198         _marketingFunds = addr2;
199         _rOwned[_msgSender()] = _rTotal;
200         _isExcludedFromFee[owner()] = true;
201         _isExcludedFromFee[address(this)] = true;
202         _isExcludedFromFee[_teamAddress] = true;
203         _isExcludedFromFee[_marketingFunds] = true;
204         emit Transfer(address(0), _msgSender(), _tTotal);
205     }
206 
207     function name() public pure returns (string memory) {
208         return _name;
209     }
210 
211     function symbol() public pure returns (string memory) {
212         return _symbol;
213     }
214 
215     function decimals() public pure returns (uint8) {
216         return _decimals;
217     }
218 
219     function totalSupply() public pure override returns (uint256) {
220         return _tTotal;
221     }
222 
223     function balanceOf(address account) public view override returns (uint256) {
224         return tokenFromReflection(_rOwned[account]);
225     }
226 
227     function transfer(address recipient, uint256 amount) public override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     function allowance(address owner, address spender) public view override returns (uint256) {
233         return _allowances[owner][spender];
234     }
235 
236     function approve(address spender, uint256 amount) public override returns (bool) {
237         _approve(_msgSender(), spender, amount);
238         return true;
239     }
240 
241     function transferFrom(
242         address sender,
243         address recipient,
244         uint256 amount
245     ) public override returns (bool) {
246         _transfer(sender, recipient, amount);
247         _approve(
248             sender,
249             _msgSender(),
250             _allowances[sender][_msgSender()].sub(
251                 amount,
252                 "ERC20: transfer amount exceeds allowance"
253             )
254         );
255         return true;
256     }
257 
258     function setCooldownEnabled(bool isEnabled) external onlyOwner() {
259         cooldownEnabled = isEnabled;
260     }
261 
262     function tokenFromReflection(uint256 rAmount)
263         private
264         view
265         returns (uint256)
266     {
267         require(
268             rAmount <= _rTotal,
269             "Amount must be less than total reflections"
270         );
271         uint256 currentRate = _getRate();
272         return rAmount.div(currentRate);
273     }
274 
275     function removeAllFee() private {
276         if (_taxFee == 0 && _teamFee == 0) return;
277         _taxFee = 0;
278         _teamFee = 0;
279     }
280 
281     function restoreAllFee() private {
282         _taxFee = 5;
283         _teamFee = 10;
284     }
285 
286     function _approve(
287         address owner,
288         address spender,
289         uint256 amount
290     ) private {
291         require(owner != address(0), "ERC20: approve from the zero address");
292         require(spender != address(0), "ERC20: approve to the zero address");
293         _allowances[owner][spender] = amount;
294         emit Approval(owner, spender, amount);
295     }
296 
297     function _transfer(
298         address from,
299         address to,
300         uint256 amount
301     ) private {
302         require(from != address(0), "ERC20: transfer from the zero address");
303         require(to != address(0), "ERC20: transfer to the zero address");
304         require(amount > 0, "Transfer amount must be greater than zero");
305 
306         if (from != owner() && to != owner()) {
307             if (cooldownEnabled) {
308                 if (
309                     from != address(this) &&
310                     to != address(this) &&
311                     from != address(uniswapV2Router) &&
312                     to != address(uniswapV2Router)
313                 ) {
314                     require(
315                         _msgSender() == address(uniswapV2Router) ||
316                             _msgSender() == uniswapV2Pair,
317                         "ERR: Uniswap only"
318                     );
319                 }
320             }
321             require(!bots[from] && !bots[to]);
322             if (
323                 from == uniswapV2Pair &&
324                 to != address(uniswapV2Router) &&
325                 !_isExcludedFromFee[to] &&
326                 cooldownEnabled
327             ) {
328                 require(cooldown[to] < block.timestamp);
329                 require(amount <= _maxTxAmount);
330                 cooldown[to] = block.timestamp + (_cooldownSeconds * 1 seconds);
331             }
332             uint256 contractTokenBalance = balanceOf(address(this));
333             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
334                 swapTokensForEth(contractTokenBalance);
335                 uint256 contractETHBalance = address(this).balance;
336                 if (contractETHBalance > 0) {
337                     sendETHToFee(address(this).balance);
338                 }
339             }
340         }
341         bool takeFee = true;
342 
343         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
344             takeFee = false;
345         }
346 
347         _tokenTransfer(from, to, amount, takeFee);
348     }
349 
350     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
351         address[] memory path = new address[](2);
352         path[0] = address(this);
353         path[1] = uniswapV2Router.WETH();
354         _approve(address(this), address(uniswapV2Router), tokenAmount);
355         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
356             tokenAmount,
357             0,
358             path,
359             address(this),
360             block.timestamp
361         );
362     }
363 
364     function sendETHToFee(uint256 amount) private {
365         _teamAddress.transfer(amount.div(2));
366         _marketingFunds.transfer(amount.div(2));
367     }
368 
369     function addLiquidityETH() external onlyOwner() {
370         require(!tradingOpen, "trading is already started");
371         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
372         uniswapV2Router = _uniswapV2Router;
373         _approve(address(this), address(uniswapV2Router), _tTotal);
374         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
375             .createPair(address(this), _uniswapV2Router.WETH());
376         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
377             address(this),
378             balanceOf(address(this)),
379             0,
380             0,
381             owner(),
382             block.timestamp
383         );
384         swapEnabled = true;
385         cooldownEnabled = true;
386         _taxFee = 1;
387         _teamFee = 10;
388         _maxTxAmount = 5000000000 * 10**9;
389         tradingOpen = true;
390         IERC20(uniswapV2Pair).approve(
391             address(uniswapV2Router),
392             type(uint256).max
393         );
394     }
395 
396     function blockBots(address[] memory bots_) public onlyOwner {
397         for (uint256 i = 0; i < bots_.length; i++) {
398             bots[bots_[i]] = true;
399         }
400     }
401 
402     function unblockBot(address notbot) public onlyOwner {
403         bots[notbot] = false;
404     }
405 
406     function _tokenTransfer(
407         address sender,
408         address recipient,
409         uint256 amount,
410         bool takeFee
411     ) private {
412         if (!takeFee) removeAllFee();
413         _transferStandard(sender, recipient, amount);
414         if (!takeFee) restoreAllFee();
415     }
416 
417     function _transferStandard(
418         address sender,
419         address recipient,
420         uint256 tAmount
421     ) private {
422         (
423             uint256 rAmount,
424             uint256 rTransferAmount,
425             uint256 rFee,
426             uint256 tTransferAmount,
427             uint256 tFee,
428             uint256 tTeam
429         ) = _getValues(tAmount);
430         _rOwned[sender] = _rOwned[sender].sub(rAmount);
431         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
432         _takeTeam(tTeam);
433         _reflectFee(rFee, tFee);
434         emit Transfer(sender, recipient, tTransferAmount);
435     }
436 
437     function _takeTeam(uint256 tTeam) private {
438         uint256 currentRate = _getRate();
439         uint256 rTeam = tTeam.mul(currentRate);
440         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
441     }
442 
443     function _reflectFee(uint256 rFee, uint256 tFee) private {
444         _rTotal = _rTotal.sub(rFee);
445         _tFeeTotal = _tFeeTotal.add(tFee);
446     }
447 
448     receive() external payable {}
449 
450     function _getValues(uint256 tAmount)
451         private
452         view
453         returns (
454             uint256,
455             uint256,
456             uint256,
457             uint256,
458             uint256,
459             uint256
460         )
461     {
462         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
463             _getTValues(tAmount, _taxFee, _teamFee);
464         uint256 currentRate = _getRate();
465         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
466             _getRValues(tAmount, tFee, tTeam, currentRate);
467         
468         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
469     }
470 
471     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee)
472         private
473         pure
474         returns (
475             uint256,
476             uint256,
477             uint256
478         )
479     {
480         uint256 tFee = tAmount.mul(taxFee).div(100);
481         uint256 tTeam = tAmount.mul(TeamFee).div(100);
482         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
483 
484         return (tTransferAmount, tFee, tTeam);
485     }
486 
487     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate)
488         private
489         pure
490         returns (
491             uint256,
492             uint256,
493             uint256
494         )
495     {
496         uint256 rAmount = tAmount.mul(currentRate);
497         uint256 rFee = tFee.mul(currentRate);
498         uint256 rTeam = tTeam.mul(currentRate);
499         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
500 
501         return (rAmount, rTransferAmount, rFee);
502     }
503 
504     function _getRate() private view returns (uint256) {
505         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
506 
507         return rSupply.div(tSupply);
508     }
509 
510     function _getCurrentSupply() private view returns (uint256, uint256) {
511         uint256 rSupply = _rTotal;
512         uint256 tSupply = _tTotal;
513         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
514 
515         return (rSupply, tSupply);
516     }
517 
518     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
519         require(maxTxPercent > 0, "Amount must be greater than 0");
520         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
521         emit MaxTxAmountUpdated(_maxTxAmount);
522     }
523 
524     function setCooldownSeconds(uint256 cooldownSecs) external onlyOwner() {
525         require(cooldownSecs > 0, "Secs must be greater than 0");
526         _cooldownSeconds = cooldownSecs;
527     }
528 }