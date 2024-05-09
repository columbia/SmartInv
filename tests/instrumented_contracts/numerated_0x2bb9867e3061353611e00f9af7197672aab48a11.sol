1 // SPDX-License-Identifier: Unlicensed
2 
3 /**
4 
5 ░█████╗░███╗░░██╗████████╗██╗███╗░░░███╗░█████╗░
6 ██╔══██╗████╗░██║╚══██╔══╝██║████╗░████║██╔══██╗
7 ███████║██╔██╗██║░░░██║░░░██║██╔████╔██║███████║
8 ██╔══██║██║╚████║░░░██║░░░██║██║╚██╔╝██║██╔══██║
9 ██║░░██║██║░╚███║░░░██║░░░██║██║░╚═╝░██║██║░░██║
10 ╚═╝░░╚═╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝
11 
12  */
13 
14 pragma solidity ^0.8.9;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24 
25     function balanceOf(address account) external view returns (uint256);
26 
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33     function transferFrom(
34         address sender,
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(
41         address indexed owner,
42         address indexed spender,
43         uint256 value
44     );
45 }
46 
47 contract Ownable is Context {
48     address private _owner;
49     address private _previousOwner;
50     event OwnershipTransferred(
51         address indexed previousOwner,
52         address indexed newOwner
53     );
54 
55     constructor() {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     function renounceOwnership() public virtual onlyOwner {
71         emit OwnershipTransferred(_owner, address(0));
72         _owner = address(0);
73     }
74 
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80 
81 }
82 
83 library SafeMath {
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87         return c;
88     }
89 
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         return sub(a, b, "SafeMath: subtraction overflow");
92     }
93 
94     function sub(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         require(b <= a, errorMessage);
100         uint256 c = a - b;
101         return c;
102     }
103 
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         if (a == 0) {
106             return 0;
107         }
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110         return c;
111     }
112 
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116 
117     function div(
118         uint256 a,
119         uint256 b,
120         string memory errorMessage
121     ) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         return c;
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
164 contract AntiMatrix is Context, IERC20, Ownable {
165 
166     using SafeMath for uint256;
167 
168     string private constant _name = "Anti Matrix";
169     string private constant _symbol = "ANTIMA";
170     uint8 private constant _decimals = 9;
171 
172     mapping(address => uint256) private _rOwned;
173     mapping(address => uint256) private _tOwned;
174     mapping(address => mapping(address => uint256)) private _allowances;
175     mapping(address => bool) private _isExcludedFromFee;
176     uint256 private constant MAX = ~uint256(0);
177     uint256 private constant _tTotal = 1000000 * 10**9;
178     uint256 private _rTotal = (MAX - (MAX % _tTotal));
179     uint256 private _tFeeTotal;
180 
181     // Taxes
182     uint256 private _redisFeeOnBuy = 0;
183     uint256 private _taxFeeOnBuy = 10;
184     uint256 private _redisFeeOnSell = 0;
185     uint256 private _taxFeeOnSell = 40;
186 
187     //Original Fee
188     uint256 private _redisFee = _redisFeeOnSell;
189     uint256 private _taxFee = _taxFeeOnSell;
190 
191     uint256 private _previousredisFee = _redisFee;
192     uint256 private _previoustaxFee = _taxFee;
193 
194     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
195     address payable private _developmentAddress = payable(0xA1821B81a2F751A053c1FDb4559D5bB3BaF2B7eC);
196     address payable private _marketingAddress = payable(0xA1821B81a2F751A053c1FDb4559D5bB3BaF2B7eC);
197 
198     IUniswapV2Router02 public uniswapV2Router;
199     address public uniswapV2Pair;
200 
201     bool private tradingOpen = true;
202     bool private inSwap = false;
203     bool private swapEnabled = true;
204 
205     uint256 public _maxTxAmount = 10001 * 10**9; // 1%
206     uint256 public _maxWalletSize = 30001 * 10**9; // 3%
207     uint256 public _swapTokensAtAmount = 10000 * 10**9; // 1%
208 
209     event MaxTxAmountUpdated(uint256 _maxTxAmount);
210     modifier lockTheSwap {
211         inSwap = true;
212         _;
213         inSwap = false;
214     }
215 
216     constructor() {
217 
218         _rOwned[_msgSender()] = _rTotal;
219 
220         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
221         uniswapV2Router = _uniswapV2Router;
222         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
223             .createPair(address(this), _uniswapV2Router.WETH());
224 
225         _isExcludedFromFee[owner()] = true;
226         _isExcludedFromFee[address(this)] = true;
227         _isExcludedFromFee[_developmentAddress] = true;
228         _isExcludedFromFee[_marketingAddress] = true;
229 
230         emit Transfer(address(0), _msgSender(), _tTotal);
231     }
232 
233     function name() public pure returns (string memory) {
234         return _name;
235     }
236 
237     function symbol() public pure returns (string memory) {
238         return _symbol;
239     }
240 
241     function decimals() public pure returns (uint8) {
242         return _decimals;
243     }
244 
245     function totalSupply() public pure override returns (uint256) {
246         return _tTotal;
247     }
248 
249     function balanceOf(address account) public view override returns (uint256) {
250         return tokenFromReflection(_rOwned[account]);
251     }
252 
253     function transfer(address recipient, uint256 amount)
254         public
255         override
256         returns (bool)
257     {
258         _transfer(_msgSender(), recipient, amount);
259         return true;
260     }
261 
262     function allowance(address owner, address spender)
263         public
264         view
265         override
266         returns (uint256)
267     {
268         return _allowances[owner][spender];
269     }
270 
271     function approve(address spender, uint256 amount)
272         public
273         override
274         returns (bool)
275     {
276         _approve(_msgSender(), spender, amount);
277         return true;
278     }
279 
280     function transferFrom(
281         address sender,
282         address recipient,
283         uint256 amount
284     ) public override returns (bool) {
285         _transfer(sender, recipient, amount);
286         _approve(
287             sender,
288             _msgSender(),
289             _allowances[sender][_msgSender()].sub(
290                 amount,
291                 "ERC20: transfer amount exceeds allowance"
292             )
293         );
294         return true;
295     }
296 
297     function tokenFromReflection(uint256 rAmount)
298         private
299         view
300         returns (uint256)
301     {
302         require(
303             rAmount <= _rTotal,
304             "Amount must be less than total reflections"
305         );
306         uint256 currentRate = _getRate();
307         return rAmount.div(currentRate);
308     }
309 
310     function removeAllFee() private {
311         if (_redisFee == 0 && _taxFee == 0) return;
312 
313         _previousredisFee = _redisFee;
314         _previoustaxFee = _taxFee;
315 
316         _redisFee = 0;
317         _taxFee = 0;
318     }
319 
320     function restoreAllFee() private {
321         _redisFee = _previousredisFee;
322         _taxFee = _previoustaxFee;
323     }
324 
325     function _approve(
326         address owner,
327         address spender,
328         uint256 amount
329     ) private {
330         require(owner != address(0), "ERC20: approve from the zero address");
331         require(spender != address(0), "ERC20: approve to the zero address");
332         _allowances[owner][spender] = amount;
333         emit Approval(owner, spender, amount);
334     }
335 
336     function _transfer(
337         address from,
338         address to,
339         uint256 amount
340     ) private {
341         require(from != address(0), "ERC20: transfer from the zero address");
342         require(to != address(0), "ERC20: transfer to the zero address");
343         require(amount > 0, "Transfer amount must be greater than zero");
344 
345         if (from != owner() && to != owner()) {
346 
347             //Trade start check
348             if (!tradingOpen) {
349                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
350             }
351 
352             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
353             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
354 
355             if(to != uniswapV2Pair) {
356                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
357             }
358 
359             uint256 contractTokenBalance = balanceOf(address(this));
360             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
361 
362             if(contractTokenBalance >= _maxTxAmount)
363             {
364                 contractTokenBalance = _maxTxAmount;
365             }
366 
367             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
368                 swapTokensForEth(contractTokenBalance);
369                 uint256 contractETHBalance = address(this).balance;
370                 if (contractETHBalance > 0) {
371                     sendETHToFee(address(this).balance);
372                 }
373             }
374         }
375 
376         bool takeFee = true;
377 
378         //Transfer Tokens
379         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
380             takeFee = false;
381         } else {
382 
383             //Set Fee for Buys
384             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
385                 _redisFee = _redisFeeOnBuy;
386                 _taxFee = _taxFeeOnBuy;
387             }
388 
389             //Set Fee for Sells
390             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
391                 _redisFee = _redisFeeOnSell;
392                 _taxFee = _taxFeeOnSell;
393             }
394 
395         }
396 
397         _tokenTransfer(from, to, amount, takeFee);
398     }
399 
400     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
401         address[] memory path = new address[](2);
402         path[0] = address(this);
403         path[1] = uniswapV2Router.WETH();
404         _approve(address(this), address(uniswapV2Router), tokenAmount);
405         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
406             tokenAmount,
407             0,
408             path,
409             address(this),
410             block.timestamp
411         );
412     }
413 
414     function sendETHToFee(uint256 amount) private {
415         _marketingAddress.transfer(amount);
416     }
417 
418     function setTrading(bool _tradingOpen) public onlyOwner {
419         tradingOpen = _tradingOpen;
420     }
421 
422     function manualswap() external {
423         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
424         uint256 contractBalance = balanceOf(address(this));
425         swapTokensForEth(contractBalance);
426     }
427 
428     function manualsend() external {
429         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
430         uint256 contractETHBalance = address(this).balance;
431         sendETHToFee(contractETHBalance);
432     }
433 
434     function blockBots(address[] memory bots_) public onlyOwner {
435         for (uint256 i = 0; i < bots_.length; i++) {
436             bots[bots_[i]] = true;
437         }
438     }
439 
440     function unblockBot(address notbot) public onlyOwner {
441         bots[notbot] = false;
442     }
443 
444     function _tokenTransfer(
445         address sender,
446         address recipient,
447         uint256 amount,
448         bool takeFee
449     ) private {
450         if (!takeFee) removeAllFee();
451         _transferStandard(sender, recipient, amount);
452         if (!takeFee) restoreAllFee();
453     }
454 
455     function _transferStandard(
456         address sender,
457         address recipient,
458         uint256 tAmount
459     ) private {
460         (
461             uint256 rAmount,
462             uint256 rTransferAmount,
463             uint256 rFee,
464             uint256 tTransferAmount,
465             uint256 tFee,
466             uint256 tTeam
467         ) = _getValues(tAmount);
468         _rOwned[sender] = _rOwned[sender].sub(rAmount);
469         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
470         _takeTeam(tTeam);
471         _reflectFee(rFee, tFee);
472         emit Transfer(sender, recipient, tTransferAmount);
473     }
474 
475     function _takeTeam(uint256 tTeam) private {
476         uint256 currentRate = _getRate();
477         uint256 rTeam = tTeam.mul(currentRate);
478         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
479     }
480 
481     function _reflectFee(uint256 rFee, uint256 tFee) private {
482         _rTotal = _rTotal.sub(rFee);
483         _tFeeTotal = _tFeeTotal.add(tFee);
484     }
485 
486     receive() external payable {}
487 
488     function _getValues(uint256 tAmount)
489         private
490         view
491         returns (
492             uint256,
493             uint256,
494             uint256,
495             uint256,
496             uint256,
497             uint256
498         )
499     {
500         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
501             _getTValues(tAmount, _redisFee, _taxFee);
502         uint256 currentRate = _getRate();
503         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
504             _getRValues(tAmount, tFee, tTeam, currentRate);
505         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
506     }
507 
508     function _getTValues(
509         uint256 tAmount,
510         uint256 redisFee,
511         uint256 taxFee
512     )
513         private
514         pure
515         returns (
516             uint256,
517             uint256,
518             uint256
519         )
520     {
521         uint256 tFee = tAmount.mul(redisFee).div(100);
522         uint256 tTeam = tAmount.mul(taxFee).div(100);
523         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
524         return (tTransferAmount, tFee, tTeam);
525     }
526 
527     function _getRValues(
528         uint256 tAmount,
529         uint256 tFee,
530         uint256 tTeam,
531         uint256 currentRate
532     )
533         private
534         pure
535         returns (
536             uint256,
537             uint256,
538             uint256
539         )
540     {
541         uint256 rAmount = tAmount.mul(currentRate);
542         uint256 rFee = tFee.mul(currentRate);
543         uint256 rTeam = tTeam.mul(currentRate);
544         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
545         return (rAmount, rTransferAmount, rFee);
546     }
547 
548     function _getRate() private view returns (uint256) {
549         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
550         return rSupply.div(tSupply);
551     }
552 
553     function _getCurrentSupply() private view returns (uint256, uint256) {
554         uint256 rSupply = _rTotal;
555         uint256 tSupply = _tTotal;
556         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
557         return (rSupply, tSupply);
558     }
559 
560     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
561         _redisFeeOnBuy = redisFeeOnBuy;
562         _redisFeeOnSell = redisFeeOnSell;
563         _taxFeeOnBuy = taxFeeOnBuy;
564         _taxFeeOnSell = taxFeeOnSell;
565     }
566 
567     //Set minimum tokens required to swap.
568     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
569         _swapTokensAtAmount = swapTokensAtAmount;
570     }
571 
572     //Set minimum tokens required to swap.
573     function toggleSwap(bool _swapEnabled) public onlyOwner {
574         swapEnabled = _swapEnabled;
575     }
576 
577     //Set maximum transaction
578     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
579         _maxTxAmount = maxTxAmount;
580     }
581 
582     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
583         _maxWalletSize = maxWalletSize;
584     }
585 
586     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
587         for(uint256 i = 0; i < accounts.length; i++) {
588             _isExcludedFromFee[accounts[i]] = excluded;
589         }
590     }
591 
592 }