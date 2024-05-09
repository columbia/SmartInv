1 /*
2 
3 %%%%%%%%%%%%%%%%%%%%%%%%%%
4 %%% TOKYOLYMPIC $TKYO %%%
5 %%%%%%%%%%%%%%%%%%%%%%%%%%
6 
7 
8 This is the people’s crypto currency of the 2021 Tokyo Olympic Games!  Everyone should have a chance to win a gold medal, right? Now you can! 
9 $TKYO is the people’s Olympic crypto currency token!
10 
11 Go for GOLD!
12 
13 FASTER. HIGHER. STRONGER - TOGETHER!
14 
15 
16 Official Website :
17 ------------------
18 https://tokyolympic.io
19 
20 
21 Official Social Platforms : 
22 ---------------------------
23 Telegram : https://t.me/TokyoLympic_Official_chat
24 Twitter : https://twitter.com/Tokyolympics1
25 
26 */
27 
28 // SPDX-License-Identifier: Unlicensed
29 
30 pragma solidity ^0.8.4;
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 }
37 
38 interface IERC20 {
39     function totalSupply() external view returns (uint256);
40 
41     function balanceOf(address account) external view returns (uint256);
42 
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     function transferFrom(
50         address sender,
51         address recipient,
52         uint256 amount
53     ) external returns (bool);
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(
57         address indexed owner,
58         address indexed spender,
59         uint256 value
60     );
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     address private _previousOwner;
66     event OwnershipTransferred(
67         address indexed previousOwner,
68         address indexed newOwner
69     );
70 
71     constructor() {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 }
91 
92 library SafeMath {
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         uint256 c = a + b;
95         require(c >= a, "SafeMath: addition overflow");
96         return c;
97     }
98 
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         return sub(a, b, "SafeMath: subtraction overflow");
101     }
102 
103     function sub(
104         uint256 a,
105         uint256 b,
106         string memory errorMessage
107     ) internal pure returns (uint256) {
108         require(b <= a, errorMessage);
109         uint256 c = a - b;
110         return c;
111     }
112 
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         if (a == 0) {
115             return 0;
116         }
117         uint256 c = a * b;
118         require(c / a == b, "SafeMath: multiplication overflow");
119         return c;
120     }
121 
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return div(a, b, "SafeMath: division by zero");
124     }
125 
126     function div(
127         uint256 a,
128         uint256 b,
129         string memory errorMessage
130     ) internal pure returns (uint256) {
131         require(b > 0, errorMessage);
132         uint256 c = a / b;
133         return c;
134     }
135 }
136 
137 interface IUniswapV2Factory {
138     function createPair(address tokenA, address tokenB)
139         external
140         returns (address pair);
141 }
142 
143 interface IUniswapV2Router02 {
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint256 amountIn,
146         uint256 amountOutMin,
147         address[] calldata path,
148         address to,
149         uint256 deadline
150     ) external;
151 
152     function factory() external pure returns (address);
153 
154     function WETH() external pure returns (address);
155 
156     function addLiquidityETH(
157         address token,
158         uint256 amountTokenDesired,
159         uint256 amountTokenMin,
160         uint256 amountETHMin,
161         address to,
162         uint256 deadline
163     )
164         external
165         payable
166         returns (
167             uint256 amountToken,
168             uint256 amountETH,
169             uint256 liquidity
170         );
171 }
172 
173 contract Tokyolympic is Context, IERC20, Ownable {
174     using SafeMath for uint256;
175 
176     string private constant _name = "Tokyolympic";
177     string private constant _symbol = "TKYO";
178     uint8 private constant _decimals = 9;
179 
180     mapping(address => uint256) private _rOwned;
181     mapping(address => uint256) private _tOwned;
182     mapping(address => mapping(address => uint256)) private _allowances;
183     mapping(address => bool) private _isExcludedFromFee;
184     uint256 private constant MAX = ~uint256(0);
185     uint256 private constant _tTotal = 1000000 * 10**9;
186     uint256 private _rTotal = (MAX - (MAX % _tTotal));
187     uint256 private _tFeeTotal;
188     uint256 private _redisT = 1;
189     uint256 private _edistT = 12;
190     uint256 private _previousredisT = _redisT;
191     uint256 private _previousedistT = _edistT;
192     mapping(address => bool) private bots;
193     mapping(address => uint256) private cooldown;
194     address payable private _teamAddress;
195     address payable private _marketingFunds;
196     IUniswapV2Router02 public uniswapV2Router;
197     address public uniswapV2Pair;
198     bool private tradingOpen;
199     bool private inSwap = false;
200     bool private swapEnabled = true;
201     uint256 public _maxTxAmount = 5000 * 10**9;
202 
203     event MaxTxAmountUpdated(uint256 _maxTxAmount);
204     modifier lockTheSwap {
205         inSwap = true;
206         _;
207         inSwap = false;
208     }
209 
210     constructor(address payable addr1, address payable addr2) {
211         _teamAddress = addr1;
212         _marketingFunds = addr2;
213         _rOwned[_msgSender()] = _rTotal;
214         
215         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
216         uniswapV2Router = _uniswapV2Router;
217         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
218             .createPair(address(this), _uniswapV2Router.WETH());
219 
220         _isExcludedFromFee[owner()] = true;
221         _isExcludedFromFee[address(this)] = true;
222         _isExcludedFromFee[_teamAddress] = true;
223         _isExcludedFromFee[_marketingFunds] = true;
224         emit Transfer(address(0), _msgSender(), _tTotal);
225     }
226 
227     function name() public pure returns (string memory) {
228         return _name;
229     }
230 
231     function symbol() public pure returns (string memory) {
232         return _symbol;
233     }
234 
235     function decimals() public pure returns (uint8) {
236         return _decimals;
237     }
238 
239     function totalSupply() public pure override returns (uint256) {
240         return _tTotal;
241     }
242 
243     function balanceOf(address account) public view override returns (uint256) {
244         return tokenFromReflection(_rOwned[account]);
245     }
246 
247     function transfer(address recipient, uint256 amount)
248         public
249         override
250         returns (bool)
251     {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255 
256     function allowance(address owner, address spender)
257         public
258         view
259         override
260         returns (uint256)
261     {
262         return _allowances[owner][spender];
263     }
264 
265     function approve(address spender, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273 
274     function transferFrom(
275         address sender,
276         address recipient,
277         uint256 amount
278     ) public override returns (bool) {
279         _transfer(sender, recipient, amount);
280         _approve(
281             sender,
282             _msgSender(),
283             _allowances[sender][_msgSender()].sub(
284                 amount,
285                 "ERC20: transfer amount exceeds allowance"
286             )
287         );
288         return true;
289     }
290 
291     function tokenFromReflection(uint256 rAmount)
292         private
293         view
294         returns (uint256)
295     {
296         require(
297             rAmount <= _rTotal,
298             "Amount must be less than total reflections"
299         );
300         uint256 currentRate = _getRate();
301         return rAmount.div(currentRate);
302     }
303 
304     function removeAllFee() private {
305         if (_redisT == 0 && _edistT == 0) return;
306     
307         _previousredisT = _redisT;
308         _previousedistT = _edistT;
309         
310         _redisT = 0;
311         _edistT = 0;
312     }
313 
314     function restoreAllFee() private {
315         _redisT = _previousredisT;
316         _edistT = _previousedistT;
317     }
318 
319     function _approve(
320         address owner,
321         address spender,
322         uint256 amount
323     ) private {
324         require(owner != address(0), "ERC20: approve from the zero address");
325         require(spender != address(0), "ERC20: approve to the zero address");
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329 
330     function _transfer(
331         address from,
332         address to,
333         uint256 amount
334     ) private {
335         require(from != address(0), "ERC20: transfer from the zero address");
336         require(to != address(0), "ERC20: transfer to the zero address");
337         require(amount > 0, "Transfer amount must be greater than zero");
338 
339         if (from != owner() && to != owner()) {
340             
341             //Trade start check
342             if (from == uniswapV2Pair || to == uniswapV2Pair) { 
343                 require(tradingOpen, "Trading is not enabled yet");
344             }
345               
346             require(amount <= _maxTxAmount);
347             require(!bots[from] && !bots[to]);
348             
349             uint256 contractTokenBalance = balanceOf(address(this));
350             if(contractTokenBalance >= _maxTxAmount)
351             {
352                 contractTokenBalance = _maxTxAmount;
353             }
354             
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
387         _teamAddress.transfer(amount.div(2));
388         _marketingFunds.transfer(amount.div(2));
389     }
390 
391     function launchTKYO() external onlyOwner() {
392         require(!tradingOpen, "trading is already started");
393         tradingOpen = true;
394     }
395 
396     function manualswap() external {
397         require(_msgSender() == _teamAddress);
398         uint256 contractBalance = balanceOf(address(this));
399         swapTokensForEth(contractBalance);
400     }
401 
402     function manualsend() external {
403         require(_msgSender() == _teamAddress);
404         uint256 contractETHBalance = address(this).balance;
405         sendETHToFee(contractETHBalance);
406     }
407 
408     function blockBots(address[] memory bots_) public onlyOwner {
409         for (uint256 i = 0; i < bots_.length; i++) {
410             bots[bots_[i]] = true;
411         }
412     }
413 
414     function unblockBot(address notbot) public onlyOwner {
415         bots[notbot] = false;
416     }
417 
418     function _tokenTransfer(
419         address sender,
420         address recipient,
421         uint256 amount,
422         bool takeFee
423     ) private {
424         if (!takeFee) removeAllFee();
425         _transferStandard(sender, recipient, amount);
426         if (!takeFee) restoreAllFee();
427     }
428 
429     function _transferStandard(
430         address sender,
431         address recipient,
432         uint256 tAmount
433     ) private {
434         (
435             uint256 rAmount,
436             uint256 rTransferAmount,
437             uint256 rFee,
438             uint256 tTransferAmount,
439             uint256 tFee,
440             uint256 tTeam
441         ) = _getValues(tAmount);
442         _rOwned[sender] = _rOwned[sender].sub(rAmount);
443         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
444         _takeTeam(tTeam);
445         _reflectFee(rFee, tFee);
446         emit Transfer(sender, recipient, tTransferAmount);
447     }
448 
449     function _takeTeam(uint256 tTeam) private {
450         uint256 currentRate = _getRate();
451         uint256 rTeam = tTeam.mul(currentRate);
452         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
453     }
454 
455     function _reflectFee(uint256 rFee, uint256 tFee) private {
456         _rTotal = _rTotal.sub(rFee);
457         _tFeeTotal = _tFeeTotal.add(tFee);
458     }
459 
460     receive() external payable {}
461 
462     function _getValues(uint256 tAmount)
463         private
464         view
465         returns (
466             uint256,
467             uint256,
468             uint256,
469             uint256,
470             uint256,
471             uint256
472         )
473     {
474         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
475             _getTValues(tAmount, _redisT, _edistT);
476         uint256 currentRate = _getRate();
477         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
478             _getRValues(tAmount, tFee, tTeam, currentRate);
479         
480         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
481     }
482 
483     function _getTValues(
484         uint256 tAmount,
485         uint256 redisT,
486         uint256 edistT
487     )
488         private
489         pure
490         returns (
491             uint256,
492             uint256,
493             uint256
494         )
495     {
496         uint256 tFee = tAmount.mul(redisT).div(100);
497         uint256 tTeam = tAmount.mul(edistT).div(100);
498         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
499 
500         return (tTransferAmount, tFee, tTeam);
501     }
502 
503     function _getRValues(
504         uint256 tAmount,
505         uint256 tFee,
506         uint256 tTeam,
507         uint256 currentRate
508     )
509         private
510         pure
511         returns (
512             uint256,
513             uint256,
514             uint256
515         )
516     {
517         uint256 rAmount = tAmount.mul(currentRate);
518         uint256 rFee = tFee.mul(currentRate);
519         uint256 rTeam = tTeam.mul(currentRate);
520         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
521 
522         return (rAmount, rTransferAmount, rFee);
523     }
524 
525     function _getRate() private view returns (uint256) {
526         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
527 
528         return rSupply.div(tSupply);
529     }
530 
531     function _getCurrentSupply() private view returns (uint256, uint256) {
532         uint256 rSupply = _rTotal;
533         uint256 tSupply = _tTotal;
534         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
535     
536         return (rSupply, tSupply);
537     }
538 
539     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
540         require(maxTxPercent > 0, "Amount must be greater than 0");
541         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
542         emit MaxTxAmountUpdated(_maxTxAmount);
543     }
544     
545     function modredisT(uint256 redisT) external onlyOwner() {
546         require(redisT >= 0 && redisT <= 25, 'redisT should be in 0 - 25');
547         _redisT = redisT;
548     }
549 
550     function modedistT(uint256 edistT) external onlyOwner() {
551         require(edistT >= 0 && edistT <= 25, 'edistT should be in 0 - 25');
552         _edistT = edistT;
553     }
554  
555 }