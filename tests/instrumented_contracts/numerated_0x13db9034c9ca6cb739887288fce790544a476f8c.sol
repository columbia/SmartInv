1 /*
2 
3 TAIYO (TAIYO)
4 
5 Website: https://tsukiverse.com
6 Telegram: https://t.me/TsukiInu
7 Twitter: https://twitter.com/missiontsuki
8 
9 */
10 
11 // SPDX-License-Identifier: Unlicensed
12 
13 pragma solidity ^0.8.4;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
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
156 contract TAIYO is Context, IERC20, Ownable {
157     using SafeMath for uint256;
158 
159     string private constant _name = "TAIYO";
160     string private constant _symbol = "TAIYO";
161     uint8 private constant _decimals = 9;
162 
163     mapping(address => uint256) private _rOwned;
164     mapping(address => uint256) private _tOwned;
165     mapping(address => mapping(address => uint256)) private _allowances;
166     mapping(address => bool) private _isExcludedFromFee;
167     uint256 private constant MAX = ~uint256(0);
168     uint256 private constant _tTotal = 100000000000000 * 10**9;
169     uint256 private _rTotal = (MAX - (MAX % _tTotal));
170     uint256 private _tFeeTotal;
171     uint256 private _taiyor = 2;
172     uint256 private _taiyot = 12;
173     uint256 private _previoustaiyor = _taiyor;
174     uint256 private _previoustaiyot = _taiyot;
175     mapping(address => bool) private bots;
176     mapping(address => uint256) private cooldown;
177     address payable private _teamAddress;
178     address payable private _marketingFunds;
179     IUniswapV2Router02 public uniswapV2Router;
180     address public uniswapV2Pair;
181     bool private tradingOpen;
182     bool private inSwap = false;
183     bool private swapEnabled = true;
184     uint256 public _maxTxAmount = 500000000000 * 10**9;
185 
186     event MaxTxAmountUpdated(uint256 _maxTxAmount);
187     modifier lockTheSwap {
188         inSwap = true;
189         _;
190         inSwap = false;
191     }
192 
193     constructor(address payable addr1, address payable addr2) {
194         _teamAddress = addr1;
195         _marketingFunds = addr2;
196         _rOwned[_msgSender()] = _rTotal;
197         
198         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
199         uniswapV2Router = _uniswapV2Router;
200         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
201             .createPair(address(this), _uniswapV2Router.WETH());
202 
203         _isExcludedFromFee[owner()] = true;
204         _isExcludedFromFee[address(this)] = true;
205         _isExcludedFromFee[_teamAddress] = true;
206         _isExcludedFromFee[_marketingFunds] = true;
207         emit Transfer(address(0), _msgSender(), _tTotal);
208     }
209 
210     function name() public pure returns (string memory) {
211         return _name;
212     }
213 
214     function symbol() public pure returns (string memory) {
215         return _symbol;
216     }
217 
218     function decimals() public pure returns (uint8) {
219         return _decimals;
220     }
221 
222     function totalSupply() public pure override returns (uint256) {
223         return _tTotal;
224     }
225 
226     function balanceOf(address account) public view override returns (uint256) {
227         return tokenFromReflection(_rOwned[account]);
228     }
229 
230     function transfer(address recipient, uint256 amount)
231         public
232         override
233         returns (bool)
234     {
235         _transfer(_msgSender(), recipient, amount);
236         return true;
237     }
238 
239     function allowance(address owner, address spender)
240         public
241         view
242         override
243         returns (uint256)
244     {
245         return _allowances[owner][spender];
246     }
247 
248     function approve(address spender, uint256 amount)
249         public
250         override
251         returns (bool)
252     {
253         _approve(_msgSender(), spender, amount);
254         return true;
255     }
256 
257     function transferFrom(
258         address sender,
259         address recipient,
260         uint256 amount
261     ) public override returns (bool) {
262         _transfer(sender, recipient, amount);
263         _approve(
264             sender,
265             _msgSender(),
266             _allowances[sender][_msgSender()].sub(
267                 amount,
268                 "ERC20: transfer amount exceeds allowance"
269             )
270         );
271         return true;
272     }
273 
274     function tokenFromReflection(uint256 rAmount)
275         private
276         view
277         returns (uint256)
278     {
279         require(
280             rAmount <= _rTotal,
281             "Amount must be less than total reflections"
282         );
283         uint256 currentRate = _getRate();
284         return rAmount.div(currentRate);
285     }
286 
287     function removeAllFee() private {
288         if (_taiyor == 0 && _taiyot == 0) return;
289     
290         _previoustaiyor = _taiyor;
291         _previoustaiyot = _taiyot;
292         
293         _taiyor = 0;
294         _taiyot = 0;
295     }
296 
297     function restoreAllFee() private {
298         _taiyor = _previoustaiyor;
299         _taiyot = _previoustaiyot;
300     }
301 
302     function _approve(
303         address owner,
304         address spender,
305         uint256 amount
306     ) private {
307         require(owner != address(0), "ERC20: approve from the zero address");
308         require(spender != address(0), "ERC20: approve to the zero address");
309         _allowances[owner][spender] = amount;
310         emit Approval(owner, spender, amount);
311     }
312 
313     function _transfer(
314         address from,
315         address to,
316         uint256 amount
317     ) private {
318         require(from != address(0), "ERC20: transfer from the zero address");
319         require(to != address(0), "ERC20: transfer to the zero address");
320         require(amount > 0, "Transfer amount must be greater than zero");
321 
322         if (from != owner() && to != owner()) {
323             
324             //Trade start check
325             if (from == uniswapV2Pair || to == uniswapV2Pair) { 
326                 require(tradingOpen, "Trading is not enabled yet");
327             }
328               
329             require(amount <= _maxTxAmount);
330             require(!bots[from] && !bots[to]);
331             
332             uint256 contractTokenBalance = balanceOf(address(this));
333             if(contractTokenBalance >= _maxTxAmount)
334             {
335                 contractTokenBalance = _maxTxAmount;
336             }
337             
338             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
339                 swapTokensForEth(contractTokenBalance);
340                 uint256 contractETHBalance = address(this).balance;
341                 if (contractETHBalance > 0) {
342                     sendETHToFee(address(this).balance);
343                 }
344             }
345         }
346         bool takeFee = true;
347 
348         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
349             takeFee = false;
350         }
351 
352         _tokenTransfer(from, to, amount, takeFee);
353     }
354 
355     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
356         address[] memory path = new address[](2);
357         path[0] = address(this);
358         path[1] = uniswapV2Router.WETH();
359         _approve(address(this), address(uniswapV2Router), tokenAmount);
360         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
361             tokenAmount,
362             0,
363             path,
364             address(this),
365             block.timestamp
366         );
367     }
368 
369     function sendETHToFee(uint256 amount) private {
370         _teamAddress.transfer(amount.div(2));
371         _marketingFunds.transfer(amount.div(2));
372     }
373 
374     function launchTaiyo() external onlyOwner() {
375         require(!tradingOpen, "trading is already started");
376         tradingOpen = true;
377     }
378 
379     function manualswap() external {
380         require(_msgSender() == _teamAddress);
381         uint256 contractBalance = balanceOf(address(this));
382         swapTokensForEth(contractBalance);
383     }
384 
385     function manualsend() external {
386         require(_msgSender() == _teamAddress);
387         uint256 contractETHBalance = address(this).balance;
388         sendETHToFee(contractETHBalance);
389     }
390 
391     function blockBots(address[] memory bots_) public onlyOwner {
392         for (uint256 i = 0; i < bots_.length; i++) {
393             bots[bots_[i]] = true;
394         }
395     }
396 
397     function unblockBot(address notbot) public onlyOwner {
398         bots[notbot] = false;
399     }
400 
401     function _tokenTransfer(
402         address sender,
403         address recipient,
404         uint256 amount,
405         bool takeFee
406     ) private {
407         if (!takeFee) removeAllFee();
408         _transferStandard(sender, recipient, amount);
409         if (!takeFee) restoreAllFee();
410     }
411 
412     function _transferStandard(
413         address sender,
414         address recipient,
415         uint256 tAmount
416     ) private {
417         (
418             uint256 rAmount,
419             uint256 rTransferAmount,
420             uint256 rFee,
421             uint256 tTransferAmount,
422             uint256 tFee,
423             uint256 tTeam
424         ) = _getValues(tAmount);
425         _rOwned[sender] = _rOwned[sender].sub(rAmount);
426         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
427         _takeTeam(tTeam);
428         _reflectFee(rFee, tFee);
429         emit Transfer(sender, recipient, tTransferAmount);
430     }
431 
432     function _takeTeam(uint256 tTeam) private {
433         uint256 currentRate = _getRate();
434         uint256 rTeam = tTeam.mul(currentRate);
435         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
436     }
437 
438     function _reflectFee(uint256 rFee, uint256 tFee) private {
439         _rTotal = _rTotal.sub(rFee);
440         _tFeeTotal = _tFeeTotal.add(tFee);
441     }
442 
443     receive() external payable {}
444 
445     function _getValues(uint256 tAmount)
446         private
447         view
448         returns (
449             uint256,
450             uint256,
451             uint256,
452             uint256,
453             uint256,
454             uint256
455         )
456     {
457         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
458             _getTValues(tAmount, _taiyor, _taiyot);
459         uint256 currentRate = _getRate();
460         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
461             _getRValues(tAmount, tFee, tTeam, currentRate);
462         
463         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
464     }
465 
466     function _getTValues(
467         uint256 tAmount,
468         uint256 taiyor,
469         uint256 taiyot
470     )
471         private
472         pure
473         returns (
474             uint256,
475             uint256,
476             uint256
477         )
478     {
479         uint256 tFee = tAmount.mul(taiyor).div(100);
480         uint256 tTeam = tAmount.mul(taiyot).div(100);
481         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
482 
483         return (tTransferAmount, tFee, tTeam);
484     }
485 
486     function _getRValues(
487         uint256 tAmount,
488         uint256 tFee,
489         uint256 tTeam,
490         uint256 currentRate
491     )
492         private
493         pure
494         returns (
495             uint256,
496             uint256,
497             uint256
498         )
499     {
500         uint256 rAmount = tAmount.mul(currentRate);
501         uint256 rFee = tFee.mul(currentRate);
502         uint256 rTeam = tTeam.mul(currentRate);
503         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
504 
505         return (rAmount, rTransferAmount, rFee);
506     }
507 
508     function _getRate() private view returns (uint256) {
509         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
510 
511         return rSupply.div(tSupply);
512     }
513 
514     function _getCurrentSupply() private view returns (uint256, uint256) {
515         uint256 rSupply = _rTotal;
516         uint256 tSupply = _tTotal;
517         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
518     
519         return (rSupply, tSupply);
520     }
521 
522     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
523         require(maxTxPercent > 0, "Amount must be greater than 0");
524         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
525         emit MaxTxAmountUpdated(_maxTxAmount);
526     }
527     
528     function modtaiyor(uint256 taiyor) external onlyOwner() {
529         require(taiyor >= 0 && taiyor <= 25, 'taiyor should be in 0 - 25');
530         _taiyor = taiyor;
531     }
532 
533     function modtaiyot(uint256 taiyot) external onlyOwner() {
534         require(taiyot >= 0 && taiyot <= 25, 'taiyot should be in 0 - 25');
535         _taiyot = taiyot;
536     }
537  
538 }