1 /**
2  The Simpsons token
3  https://t.me/TheSimpsonToken
4 **/
5 
6 // SPDX-License-Identifier: Unlicensed
7 pragma solidity ^0.8.4;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount)
21         external
22         returns (bool);
23 
24     function allowance(address owner, address spender)
25         external
26         view
27         returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44 
45 library SafeMath {
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     function sub(
57         uint256 a,
58         uint256 b,
59         string memory errorMessage
60     ) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63         return c;
64     }
65 
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         if (a == 0) {
68             return 0;
69         }
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72         return c;
73     }
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return div(a, b, "SafeMath: division by zero");
77     }
78 
79     function div(
80         uint256 a,
81         uint256 b,
82         string memory errorMessage
83     ) internal pure returns (uint256) {
84         require(b > 0, errorMessage);
85         uint256 c = a / b;
86         return c;
87     }
88 }
89 
90 contract Ownable is Context {
91     address private _owner;
92     address private _previousOwner;
93     event OwnershipTransferred(
94         address indexed previousOwner,
95         address indexed newOwner
96     );
97 
98     constructor() {
99         address msgSender = _msgSender();
100         _owner = msgSender;
101         emit OwnershipTransferred(address(0), msgSender);
102     }
103 
104     function owner() public view returns (address) {
105         return _owner;
106     }
107 
108     modifier onlyOwner() {
109         require(_owner == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     function renounceOwnership() public virtual onlyOwner {
114         emit OwnershipTransferred(_owner, address(0));
115         _owner = address(0);
116     }
117 }
118 
119 interface IUniswapV2Factory {
120     function createPair(address tokenA, address tokenB)
121         external
122         returns (address pair);
123 }
124 
125 interface IUniswapV2Router02 {
126     function swapExactTokensForETHSupportingFeeOnTransferTokens(
127         uint256 amountIn,
128         uint256 amountOutMin,
129         address[] calldata path,
130         address to,
131         uint256 deadline
132     ) external;
133 
134     function factory() external pure returns (address);
135 
136     function WETH() external pure returns (address);
137 
138     function addLiquidityETH(
139         address token,
140         uint256 amountTokenDesired,
141         uint256 amountTokenMin,
142         uint256 amountETHMin,
143         address to,
144         uint256 deadline
145     )
146         external
147         payable
148         returns (
149             uint256 amountToken,
150             uint256 amountETH,
151             uint256 liquidity
152         );
153 }
154 
155 contract Simpsons is Context, IERC20, Ownable {
156     using SafeMath for uint256;
157 
158     string private constant _name = "The Simpsons";
159     string private constant _symbol = "SIMPSONS";
160     uint8 private constant _decimals = 9;
161 
162     // RFI
163     mapping(address => uint256) private _rOwned;
164     mapping(address => uint256) private _tOwned;
165     mapping(address => mapping(address => uint256)) private _allowances;
166     mapping(address => bool) private _isExcludedFromFee;
167     uint256 private constant MAX = ~uint256(0);
168     uint256 private constant _tTotal = 1000000000000 * 10**9;
169     uint256 private _rTotal = (MAX - (MAX % _tTotal));
170     uint256 private _tFeeTotal;
171     uint256 private _taxFee = 2;
172     uint256 private _teamFee = 8;
173 
174     // Bot detection
175     mapping(address => bool) private bots;
176     mapping(address => uint256) private cooldown;
177     address payable private _teamAddress;
178     address payable private _marketingFunds;
179     IUniswapV2Router02 private uniswapV2Router;
180     address private uniswapV2Pair;
181     bool private tradingOpen;
182     bool private inSwap = false;
183     bool private swapEnabled = false;
184     bool private cooldownEnabled = false;
185     uint256 private _maxTxAmount = _tTotal;
186 
187     event MaxTxAmountUpdated(uint256 _maxTxAmount);
188     modifier lockTheSwap {
189         inSwap = true;
190         _;
191         inSwap = false;
192     }
193 
194     constructor(address payable addr1, address payable addr2) {
195         _teamAddress = addr1;
196         _marketingFunds = addr2;
197         _rOwned[_msgSender()] = _rTotal;
198         _isExcludedFromFee[owner()] = true;
199         _isExcludedFromFee[address(this)] = true;
200         _isExcludedFromFee[_teamAddress] = true;
201         _isExcludedFromFee[_marketingFunds] = true;
202         emit Transfer(address(0), _msgSender(), _tTotal);
203     }
204 
205     function name() public pure returns (string memory) {
206         return _name;
207     }
208 
209     function symbol() public pure returns (string memory) {
210         return _symbol;
211     }
212 
213     function decimals() public pure returns (uint8) {
214         return _decimals;
215     }
216 
217     function totalSupply() public pure override returns (uint256) {
218         return _tTotal;
219     }
220 
221     function balanceOf(address account) public view override returns (uint256) {
222         return tokenFromReflection(_rOwned[account]);
223     }
224 
225     function transfer(address recipient, uint256 amount)
226         public
227         override
228         returns (bool)
229     {
230         _transfer(_msgSender(), recipient, amount);
231         return true;
232     }
233 
234     function allowance(address owner, address spender)
235         public
236         view
237         override
238         returns (uint256)
239     {
240         return _allowances[owner][spender];
241     }
242 
243     function approve(address spender, uint256 amount)
244         public
245         override
246         returns (bool)
247     {
248         _approve(_msgSender(), spender, amount);
249         return true;
250     }
251 
252     function transferFrom(
253         address sender,
254         address recipient,
255         uint256 amount
256     ) public override returns (bool) {
257         _transfer(sender, recipient, amount);
258         _approve(
259             sender,
260             _msgSender(),
261             _allowances[sender][_msgSender()].sub(
262                 amount,
263                 "ERC20: transfer amount exceeds allowance"
264             )
265         );
266         return true;
267     }
268 
269     function setCooldownEnabled(bool onoff) external onlyOwner() {
270         cooldownEnabled = onoff;
271     }
272 
273     function tokenFromReflection(uint256 rAmount)
274         private
275         view
276         returns (uint256)
277     {
278         require(
279             rAmount <= _rTotal,
280             "Amount must be less than total reflections"
281         );
282         uint256 currentRate = _getRate();
283         return rAmount.div(currentRate);
284     }
285 
286     function removeAllFee() private {
287         if (_taxFee == 0 && _teamFee == 0) return;
288         _taxFee = 0;
289         _teamFee = 0;
290     }
291 
292     function restoreAllFee() private {
293         _taxFee = 2;
294         _teamFee = 8;
295     }
296 
297     function _approve(
298         address owner,
299         address spender,
300         uint256 amount
301     ) private {
302         require(owner != address(0), "ERC20: approve from the zero address");
303         require(spender != address(0), "ERC20: approve to the zero address");
304         _allowances[owner][spender] = amount;
305         emit Approval(owner, spender, amount);
306     }
307 
308     function _transfer(
309         address from,
310         address to,
311         uint256 amount
312     ) private {
313         require(from != address(0), "ERC20: transfer from the zero address");
314         require(to != address(0), "ERC20: transfer to the zero address");
315         require(amount > 0, "Transfer amount must be greater than zero");
316 
317         if (from != owner() && to != owner()) {
318             if (cooldownEnabled) {
319                 if (
320                     from != address(this) &&
321                     to != address(this) &&
322                     from != address(uniswapV2Router) &&
323                     to != address(uniswapV2Router)
324                 ) {
325                     require(
326                         _msgSender() == address(uniswapV2Router) ||
327                             _msgSender() == uniswapV2Pair,
328                         "ERR: Uniswap only"
329                     );
330                 }
331             }
332             require(amount <= _maxTxAmount);
333             require(!bots[from] && !bots[to]);
334             if (
335                 from == uniswapV2Pair &&
336                 to != address(uniswapV2Router) &&
337                 !_isExcludedFromFee[to] &&
338                 cooldownEnabled
339             ) {
340                 require(cooldown[to] < block.timestamp);
341                 cooldown[to] = block.timestamp + (60 seconds);
342             }
343             uint256 contractTokenBalance = balanceOf(address(this));
344             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
345                 swapTokensForEth(contractTokenBalance);
346                 uint256 contractETHBalance = address(this).balance;
347                 if (contractETHBalance > 0) {
348                     sendETHToFee(address(this).balance);
349                 }
350             }
351         }
352         bool takeFee = true;
353 
354         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
355             takeFee = false;
356         }
357 
358         _tokenTransfer(from, to, amount, takeFee);
359     }
360 
361     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
362         address[] memory path = new address[](2);
363         path[0] = address(this);
364         path[1] = uniswapV2Router.WETH();
365         _approve(address(this), address(uniswapV2Router), tokenAmount);
366         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
367             tokenAmount,
368             0,
369             path,
370             address(this),
371             block.timestamp
372         );
373     }
374 
375     function sendETHToFee(uint256 amount) private {
376         _teamAddress.transfer(amount.div(2));
377         _marketingFunds.transfer(amount.div(2));
378     }
379 
380     function openTrading() external onlyOwner() {
381         require(!tradingOpen, "trading is already open");
382         IUniswapV2Router02 _uniswapV2Router =
383             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
384         uniswapV2Router = _uniswapV2Router;
385         _approve(address(this), address(uniswapV2Router), _tTotal);
386         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
387             .createPair(address(this), _uniswapV2Router.WETH());
388         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
389             address(this),
390             balanceOf(address(this)),
391             0,
392             0,
393             owner(),
394             block.timestamp
395         );
396         swapEnabled = true;
397         cooldownEnabled = true;
398         _maxTxAmount = 5000000000 * 10**9;
399         tradingOpen = true;
400         IERC20(uniswapV2Pair).approve(
401             address(uniswapV2Router),
402             type(uint256).max
403         );
404     }
405 
406     function manualswap() external {
407         require(_msgSender() == _teamAddress);
408         uint256 contractBalance = balanceOf(address(this));
409         swapTokensForEth(contractBalance);
410     }
411 
412     function manualsend() external {
413         require(_msgSender() == _teamAddress);
414         uint256 contractETHBalance = address(this).balance;
415         sendETHToFee(contractETHBalance);
416     }
417 
418     function setBots(address[] memory bots_) public onlyOwner {
419         for (uint256 i = 0; i < bots_.length; i++) {
420             bots[bots_[i]] = true;
421         }
422     }
423 
424     function delBot(address notbot) public onlyOwner {
425         bots[notbot] = false;
426     }
427 
428     function _tokenTransfer(
429         address sender,
430         address recipient,
431         uint256 amount,
432         bool takeFee
433     ) private {
434         if (!takeFee) removeAllFee();
435         _transferStandard(sender, recipient, amount);
436         if (!takeFee) restoreAllFee();
437     }
438 
439     function _transferStandard(
440         address sender,
441         address recipient,
442         uint256 tAmount
443     ) private {
444         (
445             uint256 rAmount,
446             uint256 rTransferAmount,
447             uint256 rFee,
448             uint256 tTransferAmount,
449             uint256 tFee,
450             uint256 tTeam
451         ) = _getValues(tAmount);
452         _rOwned[sender] = _rOwned[sender].sub(rAmount);
453         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
454         _takeTeam(tTeam);
455         _reflectFee(rFee, tFee);
456         emit Transfer(sender, recipient, tTransferAmount);
457     }
458 
459     function _takeTeam(uint256 tTeam) private {
460         uint256 currentRate = _getRate();
461         uint256 rTeam = tTeam.mul(currentRate);
462         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
463     }
464 
465     function _reflectFee(uint256 rFee, uint256 tFee) private {
466         _rTotal = _rTotal.sub(rFee);
467         _tFeeTotal = _tFeeTotal.add(tFee);
468     }
469 
470     receive() external payable {}
471 
472     function _getValues(uint256 tAmount)
473         private
474         view
475         returns (
476             uint256,
477             uint256,
478             uint256,
479             uint256,
480             uint256,
481             uint256
482         )
483     {
484         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
485             _getTValues(tAmount, _taxFee, _teamFee);
486         uint256 currentRate = _getRate();
487         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
488             _getRValues(tAmount, tFee, tTeam, currentRate);
489         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
490     }
491 
492     function _getTValues(
493         uint256 tAmount,
494         uint256 taxFee,
495         uint256 TeamFee
496     )
497         private
498         pure
499         returns (
500             uint256,
501             uint256,
502             uint256
503         )
504     {
505         uint256 tFee = tAmount.mul(taxFee).div(100);
506         uint256 tTeam = tAmount.mul(TeamFee).div(100);
507         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
508         return (tTransferAmount, tFee, tTeam);
509     }
510 
511     function _getRValues(
512         uint256 tAmount,
513         uint256 tFee,
514         uint256 tTeam,
515         uint256 currentRate
516     )
517         private
518         pure
519         returns (
520             uint256,
521             uint256,
522             uint256
523         )
524     {
525         uint256 rAmount = tAmount.mul(currentRate);
526         uint256 rFee = tFee.mul(currentRate);
527         uint256 rTeam = tTeam.mul(currentRate);
528         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
529         return (rAmount, rTransferAmount, rFee);
530     }
531 
532     function _getRate() private view returns (uint256) {
533         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
534         return rSupply.div(tSupply);
535     }
536 
537     function _getCurrentSupply() private view returns (uint256, uint256) {
538         uint256 rSupply = _rTotal;
539         uint256 tSupply = _tTotal;
540         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
541         return (rSupply, tSupply);
542     }
543 
544     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
545         require(maxTxPercent > 0, "Amount must be greater than 0");
546         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
547         emit MaxTxAmountUpdated(_maxTxAmount);
548     }
549 }