1 // SPDX-License-Identifier: Unlicensed
2 // https://t.me/RapidlyReusableRocketsETH
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount)
17         external
18         returns (bool);
19 
20     function allowance(address owner, address spender)
21         external
22         view
23         returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40 
41 library SafeMath {
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     function sub(
53         uint256 a,
54         uint256 b,
55         string memory errorMessage
56     ) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59         return c;
60     }
61 
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         if (a == 0) {
64             return 0;
65         }
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68         return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return div(a, b, "SafeMath: division by zero");
73     }
74 
75     function div(
76         uint256 a,
77         uint256 b,
78         string memory errorMessage
79     ) internal pure returns (uint256) {
80         require(b > 0, errorMessage);
81         uint256 c = a / b;
82         return c;
83     }
84 }
85 
86 contract Ownable is Context {
87     address private _owner;
88     address private _previousOwner;
89     event OwnershipTransferred(
90         address indexed previousOwner,
91         address indexed newOwner
92     );
93 
94     constructor() {
95         address msgSender = _msgSender();
96         _owner = msgSender;
97         emit OwnershipTransferred(address(0), msgSender);
98     }
99 
100     function owner() public view returns (address) {
101         return _owner;
102     }
103 
104     modifier onlyOwner() {
105         require(_owner == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     function renounceOwnership() public virtual onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 }
114 
115 interface IUniswapV2Factory {
116     function createPair(address tokenA, address tokenB)
117         external
118         returns (address pair);
119 }
120 
121 interface IUniswapV2Router02 {
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint256 amountIn,
124         uint256 amountOutMin,
125         address[] calldata path,
126         address to,
127         uint256 deadline
128     ) external;
129 
130     function factory() external pure returns (address);
131 
132     function WETH() external pure returns (address);
133 
134     function addLiquidityETH(
135         address token,
136         uint256 amountTokenDesired,
137         uint256 amountTokenMin,
138         uint256 amountETHMin,
139         address to,
140         uint256 deadline
141     )
142         external
143         payable
144         returns (
145             uint256 amountToken,
146             uint256 amountETH,
147             uint256 liquidity
148         );
149 }
150 
151 contract RRR is Context, IERC20, Ownable {
152     using SafeMath for uint256;
153 
154     string private constant _name = "Rapidly Reusable Rockets";
155     string private constant _symbol = "RRR\xF0\x9F\x9A\x80";
156     uint8 private constant _decimals = 9;
157 
158     // RFI
159     mapping(address => uint256) private _rOwned;
160     mapping(address => uint256) private _tOwned;
161     mapping(address => mapping(address => uint256)) private _allowances;
162     mapping(address => bool) private _isExcludedFromFee;
163     uint256 private constant MAX = ~uint256(0);
164     uint256 private constant _tTotal = 1000000000000 * 10**9;
165     uint256 private _rTotal = (MAX - (MAX % _tTotal));
166     uint256 private _tFeeTotal;
167     uint256 private _taxFee = 5;
168     uint256 private _teamFee = 10;
169 
170     // Bot detection
171     mapping(address => bool) private bots;
172     mapping(address => uint256) private cooldown;
173     address payable private _teamAddress;
174     address payable private _marketingFunds;
175     IUniswapV2Router02 private uniswapV2Router;
176     address private uniswapV2Pair;
177     bool private tradingOpen;
178     bool private inSwap = false;
179     bool private swapEnabled = false;
180     bool private cooldownEnabled = false;
181     uint256 private _maxTxAmount = _tTotal;
182 
183     event MaxTxAmountUpdated(uint256 _maxTxAmount);
184     modifier lockTheSwap {
185         inSwap = true;
186         _;
187         inSwap = false;
188     }
189 
190     constructor(address payable addr1, address payable addr2) {
191         _teamAddress = addr1;
192         _marketingFunds = addr2;
193         _rOwned[_msgSender()] = _rTotal;
194         _isExcludedFromFee[owner()] = true;
195         _isExcludedFromFee[address(this)] = true;
196         _isExcludedFromFee[_teamAddress] = true;
197         _isExcludedFromFee[_marketingFunds] = true;
198         emit Transfer(address(0), _msgSender(), _tTotal);
199     }
200 
201     function name() public pure returns (string memory) {
202         return _name;
203     }
204 
205     function symbol() public pure returns (string memory) {
206         return _symbol;
207     }
208 
209     function decimals() public pure returns (uint8) {
210         return _decimals;
211     }
212 
213     function totalSupply() public pure override returns (uint256) {
214         return _tTotal;
215     }
216 
217     function balanceOf(address account) public view override returns (uint256) {
218         return tokenFromReflection(_rOwned[account]);
219     }
220 
221     function transfer(address recipient, uint256 amount)
222         public
223         override
224         returns (bool)
225     {
226         _transfer(_msgSender(), recipient, amount);
227         return true;
228     }
229 
230     function allowance(address owner, address spender)
231         public
232         view
233         override
234         returns (uint256)
235     {
236         return _allowances[owner][spender];
237     }
238 
239     function approve(address spender, uint256 amount)
240         public
241         override
242         returns (bool)
243     {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     function transferFrom(
249         address sender,
250         address recipient,
251         uint256 amount
252     ) public override returns (bool) {
253         _transfer(sender, recipient, amount);
254         _approve(
255             sender,
256             _msgSender(),
257             _allowances[sender][_msgSender()].sub(
258                 amount,
259                 "ERC20: transfer amount exceeds allowance"
260             )
261         );
262         return true;
263     }
264 
265     function setCooldownEnabled(bool onoff) external onlyOwner() {
266         cooldownEnabled = onoff;
267     }
268 
269     function tokenFromReflection(uint256 rAmount)
270         private
271         view
272         returns (uint256)
273     {
274         require(
275             rAmount <= _rTotal,
276             "Amount must be less than total reflections"
277         );
278         uint256 currentRate = _getRate();
279         return rAmount.div(currentRate);
280     }
281 
282     function removeAllFee() private {
283         if (_taxFee == 0 && _teamFee == 0) return;
284         _taxFee = 0;
285         _teamFee = 0;
286     }
287 
288     function restoreAllFee() private {
289         _taxFee = 5;
290         _teamFee = 12;
291     }
292 
293     function _approve(
294         address owner,
295         address spender,
296         uint256 amount
297     ) private {
298         require(owner != address(0), "ERC20: approve from the zero address");
299         require(spender != address(0), "ERC20: approve to the zero address");
300         _allowances[owner][spender] = amount;
301         emit Approval(owner, spender, amount);
302     }
303 
304     function _transfer(
305         address from,
306         address to,
307         uint256 amount
308     ) private {
309         require(from != address(0), "ERC20: transfer from the zero address");
310         require(to != address(0), "ERC20: transfer to the zero address");
311         require(amount > 0, "Transfer amount must be greater than zero");
312 
313         if (from != owner() && to != owner()) {
314             if (cooldownEnabled) {
315                 if (
316                     from != address(this) &&
317                     to != address(this) &&
318                     from != address(uniswapV2Router) &&
319                     to != address(uniswapV2Router)
320                 ) {
321                     require(
322                         _msgSender() == address(uniswapV2Router) ||
323                             _msgSender() == uniswapV2Pair,
324                         "ERR: Uniswap only"
325                     );
326                 }
327             }
328             require(amount <= _maxTxAmount);
329             require(!bots[from] && !bots[to]);
330             if (
331                 from == uniswapV2Pair &&
332                 to != address(uniswapV2Router) &&
333                 !_isExcludedFromFee[to] &&
334                 cooldownEnabled
335             ) {
336                 require(cooldown[to] < block.timestamp);
337                 cooldown[to] = block.timestamp + (60 seconds);
338             }
339             uint256 contractTokenBalance = balanceOf(address(this));
340             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
341                 swapTokensForEth(contractTokenBalance);
342                 uint256 contractETHBalance = address(this).balance;
343                 if (contractETHBalance > 0) {
344                     sendETHToFee(address(this).balance);
345                 }
346             }
347         }
348         bool takeFee = true;
349 
350         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
351             takeFee = false;
352         }
353 
354         _tokenTransfer(from, to, amount, takeFee);
355     }
356 
357     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
358         address[] memory path = new address[](2);
359         path[0] = address(this);
360         path[1] = uniswapV2Router.WETH();
361         _approve(address(this), address(uniswapV2Router), tokenAmount);
362         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
363             tokenAmount,
364             0,
365             path,
366             address(this),
367             block.timestamp
368         );
369     }
370 
371     function sendETHToFee(uint256 amount) private {
372         _teamAddress.transfer(amount.div(2));
373         _marketingFunds.transfer(amount.div(2));
374     }
375 
376     function openTrading() external onlyOwner() {
377         require(!tradingOpen, "trading is already open");
378         IUniswapV2Router02 _uniswapV2Router =
379             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
380         uniswapV2Router = _uniswapV2Router;
381         _approve(address(this), address(uniswapV2Router), _tTotal);
382         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
383             .createPair(address(this), _uniswapV2Router.WETH());
384         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
385             address(this),
386             balanceOf(address(this)),
387             0,
388             0,
389             owner(),
390             block.timestamp
391         );
392         swapEnabled = true;
393         cooldownEnabled = true;
394         _maxTxAmount = 2500000000 * 10**9;
395         tradingOpen = true;
396         IERC20(uniswapV2Pair).approve(
397             address(uniswapV2Router),
398             type(uint256).max
399         );
400     }
401 
402     function manualswap() external {
403         require(_msgSender() == _teamAddress);
404         uint256 contractBalance = balanceOf(address(this));
405         swapTokensForEth(contractBalance);
406     }
407 
408     function manualsend() external {
409         require(_msgSender() == _teamAddress);
410         uint256 contractETHBalance = address(this).balance;
411         sendETHToFee(contractETHBalance);
412     }
413 
414     function setBots(address[] memory bots_) public onlyOwner {
415         for (uint256 i = 0; i < bots_.length; i++) {
416             bots[bots_[i]] = true;
417         }
418     }
419 
420     function delBot(address notbot) public onlyOwner {
421         bots[notbot] = false;
422     }
423 
424     function _tokenTransfer(
425         address sender,
426         address recipient,
427         uint256 amount,
428         bool takeFee
429     ) private {
430         if (!takeFee) removeAllFee();
431         _transferStandard(sender, recipient, amount);
432         if (!takeFee) restoreAllFee();
433     }
434 
435     function _transferStandard(
436         address sender,
437         address recipient,
438         uint256 tAmount
439     ) private {
440         (
441             uint256 rAmount,
442             uint256 rTransferAmount,
443             uint256 rFee,
444             uint256 tTransferAmount,
445             uint256 tFee,
446             uint256 tTeam
447         ) = _getValues(tAmount);
448         _rOwned[sender] = _rOwned[sender].sub(rAmount);
449         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
450         _takeTeam(tTeam);
451         _reflectFee(rFee, tFee);
452         emit Transfer(sender, recipient, tTransferAmount);
453     }
454 
455     function _takeTeam(uint256 tTeam) private {
456         uint256 currentRate = _getRate();
457         uint256 rTeam = tTeam.mul(currentRate);
458         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
459     }
460 
461     function _reflectFee(uint256 rFee, uint256 tFee) private {
462         _rTotal = _rTotal.sub(rFee);
463         _tFeeTotal = _tFeeTotal.add(tFee);
464     }
465 
466     receive() external payable {}
467 
468     function _getValues(uint256 tAmount)
469         private
470         view
471         returns (
472             uint256,
473             uint256,
474             uint256,
475             uint256,
476             uint256,
477             uint256
478         )
479     {
480         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
481             _getTValues(tAmount, _taxFee, _teamFee);
482         uint256 currentRate = _getRate();
483         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
484             _getRValues(tAmount, tFee, tTeam, currentRate);
485         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
486     }
487 
488     function _getTValues(
489         uint256 tAmount,
490         uint256 taxFee,
491         uint256 TeamFee
492     )
493         private
494         pure
495         returns (
496             uint256,
497             uint256,
498             uint256
499         )
500     {
501         uint256 tFee = tAmount.mul(taxFee).div(100);
502         uint256 tTeam = tAmount.mul(TeamFee).div(100);
503         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
504         return (tTransferAmount, tFee, tTeam);
505     }
506 
507     function _getRValues(
508         uint256 tAmount,
509         uint256 tFee,
510         uint256 tTeam,
511         uint256 currentRate
512     )
513         private
514         pure
515         returns (
516             uint256,
517             uint256,
518             uint256
519         )
520     {
521         uint256 rAmount = tAmount.mul(currentRate);
522         uint256 rFee = tFee.mul(currentRate);
523         uint256 rTeam = tTeam.mul(currentRate);
524         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
525         return (rAmount, rTransferAmount, rFee);
526     }
527 
528     function _getRate() private view returns (uint256) {
529         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
530         return rSupply.div(tSupply);
531     }
532 
533     function _getCurrentSupply() private view returns (uint256, uint256) {
534         uint256 rSupply = _rTotal;
535         uint256 tSupply = _tTotal;
536         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
537         return (rSupply, tSupply);
538     }
539 
540     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
541         require(maxTxPercent > 0, "Amount must be greater than 0");
542         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
543         emit MaxTxAmountUpdated(_maxTxAmount);
544     }
545 }