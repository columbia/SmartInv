1 /*
2     Telegram : @BabyShinaInu
3     Website : www.BabyShina.com
4 
5 */
6 pragma solidity ^0.8.4;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     function allowance(address owner, address spender) external view returns (uint256);
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 contract Ownable is Context {
40     address private _owner;
41     address private _previousOwner;
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     constructor() {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(_owner == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 }
67 
68 library SafeMath {
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a, "SafeMath: addition overflow");
72         return c;
73     }
74 
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     function sub(
80         uint256 a,
81         uint256 b,
82         string memory errorMessage
83     ) internal pure returns (uint256) {
84         require(b <= a, errorMessage);
85         uint256 c = a - b;
86         return c;
87     }
88 
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         if (a == 0) {
91             return 0;
92         }
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95         return c;
96     }
97 
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     function div(
103         uint256 a,
104         uint256 b,
105         string memory errorMessage
106     ) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         return c;
110     }
111 }
112 
113 interface IUniswapV2Factory {
114     function createPair(address tokenA, address tokenB)
115         external
116         returns (address pair);
117 }
118 
119 interface IUniswapV2Router02 {
120     function swapExactTokensForETHSupportingFeeOnTransferTokens(
121         uint256 amountIn,
122         uint256 amountOutMin,
123         address[] calldata path,
124         address to,
125         uint256 deadline
126     ) external;
127 
128     function factory() external pure returns (address);
129 
130     function WETH() external pure returns (address);
131 
132     function addLiquidityETH(
133         address token,
134         uint256 amountTokenDesired,
135         uint256 amountTokenMin,
136         uint256 amountETHMin,
137         address to,
138         uint256 deadline
139     )
140         external
141         payable
142         returns (
143             uint256 amountToken,
144             uint256 amountETH,
145             uint256 liquidity
146         );
147 }
148 
149 contract BabyShinaInu is Context, IERC20, Ownable {
150     
151     using SafeMath for uint256;
152 
153     string private constant _name = "Baby Shina Inu";
154     string private constant _symbol = "BABYSHI";
155     uint8 private constant _decimals = 9;
156 
157     mapping(address => uint256) private _rOwned;
158     mapping(address => uint256) private _tOwned;
159     mapping(address => mapping(address => uint256)) private _allowances;
160     mapping(address => bool) private _isExcludedFromFee;
161     uint256 private constant MAX = ~uint256(0);
162     uint256 private constant _tTotal = 200000000000 * 10**9;
163     uint256 private _rTotal = (MAX - (MAX % _tTotal));
164     uint256 private _tFeeTotal;
165     
166     //Buy Fee
167     uint256 private _redisFeeOnBuy = 1;
168     uint256 private _taxFeeOnBuy = 10;
169     
170     //Sell Fee
171     uint256 private _redisFeeOnSell = 1;
172     uint256 private _taxFeeOnSell = 10;
173     
174     //Original Fee
175     uint256 private _redisFee = _redisFeeOnSell;
176     uint256 private _taxFee = _taxFeeOnSell;
177     
178     uint256 private _previousredisFee = _redisFee;
179     uint256 private _previoustaxFee = _taxFee;
180     
181     mapping (address => bool) public preTrader;
182     mapping(address => uint256) private cooldown;
183     
184     address payable private _opAddress = payable(0x1d8664A87C0c10D8064FB9cB2eA9E1E5A4678a1B);
185     
186     IUniswapV2Router02 public uniswapV2Router;
187     address public uniswapV2Pair;
188     bool private tradingOpen;
189     bool private inSwap = false;
190     bool private swapEnabled = true;
191     
192     uint256 public _maxTxAmount = 1000000000 * 10**9; //.5 
193     uint256 public _maxWalletSize = 1000000000 * 10**9; //.5
194     uint256 public _swapTokensAtAmount = 200000000 * 10**9; //0.1
195 
196     event MaxTxAmountUpdated(uint256 _maxTxAmount);
197     modifier lockTheSwap {
198         inSwap = true;
199         _;
200         inSwap = false;
201     }
202 
203     constructor() {
204 
205         _rOwned[_msgSender()] = _rTotal;
206         // Uniswap V2 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
207         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
208         uniswapV2Router = _uniswapV2Router;
209         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
210             .createPair(address(this), _uniswapV2Router.WETH());
211 
212         _isExcludedFromFee[owner()] = true;
213         _isExcludedFromFee[address(this)] = true;
214         _isExcludedFromFee[_opAddress] = true;
215         
216         preTrader[owner()] = true;
217         
218         emit Transfer(address(0), _msgSender(), _tTotal);
219     }
220 
221     function name() public pure returns (string memory) {
222         return _name;
223     }
224 
225     function symbol() public pure returns (string memory) {
226         return _symbol;
227     }
228 
229     function decimals() public pure returns (uint8) {
230         return _decimals;
231     }
232 
233     function totalSupply() public pure override returns (uint256) {
234         return _tTotal;
235     }
236 
237     function balanceOf(address account) public view override returns (uint256) {
238         return tokenFromReflection(_rOwned[account]);
239     }
240 
241     function transfer(address recipient, uint256 amount)
242         public
243         override
244         returns (bool)
245     {
246         _transfer(_msgSender(), recipient, amount);
247         return true;
248     }
249 
250     function allowance(address owner, address spender)
251         public
252         view
253         override
254         returns (uint256)
255     {
256         return _allowances[owner][spender];
257     }
258 
259     function approve(address spender, uint256 amount)
260         public
261         override
262         returns (bool)
263     {
264         _approve(_msgSender(), spender, amount);
265         return true;
266     }
267 
268     function transferFrom(
269         address sender,
270         address recipient,
271         uint256 amount
272     ) public override returns (bool) {
273         _transfer(sender, recipient, amount);
274         _approve(
275             sender,
276             _msgSender(),
277             _allowances[sender][_msgSender()].sub(
278                 amount,
279                 "ERC20: transfer amount exceeds allowance"
280             )
281         );
282         return true;
283     }
284 
285     function tokenFromReflection(uint256 rAmount)
286         private
287         view
288         returns (uint256)
289     {
290         require(
291             rAmount <= _rTotal,
292             "Amount must be less than total reflections"
293         );
294         uint256 currentRate = _getRate();
295         return rAmount.div(currentRate);
296     }
297 
298     function removeAllFee() private {
299         if (_redisFee == 0 && _taxFee == 0) return;
300     
301         _previousredisFee = _redisFee;
302         _previoustaxFee = _taxFee;
303         
304         _redisFee = 0;
305         _taxFee = 0;
306     }
307 
308     function restoreAllFee() private {
309         _redisFee = _previousredisFee;
310         _taxFee = _previoustaxFee;
311     }
312 
313     function _approve(
314         address owner,
315         address spender,
316         uint256 amount
317     ) private {
318         require(owner != address(0), "ERC20: approve from the zero address");
319         require(spender != address(0), "ERC20: approve to the zero address");
320         _allowances[owner][spender] = amount;
321         emit Approval(owner, spender, amount);
322     }
323 
324     function _transfer(
325         address from,
326         address to,
327         uint256 amount
328     ) private {
329         require(from != address(0), "ERC20: transfer from the zero address");
330         require(to != address(0), "ERC20: transfer to the zero address");
331         require(amount > 0, "Transfer amount must be greater than zero");
332 
333         if (from != owner() && to != owner()) {
334             
335             //Trade start check
336             if (!tradingOpen) {
337                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
338             }
339               
340             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
341             
342             if(to != uniswapV2Pair) {
343                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
344             }
345             
346             uint256 contractTokenBalance = balanceOf(address(this));
347             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
348 
349             if(contractTokenBalance >= _maxTxAmount)
350             {
351                 contractTokenBalance = _maxTxAmount;
352             }
353             
354             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled) {
355                 swapTokensForEth(contractTokenBalance);
356                 uint256 contractETHBalance = address(this).balance;
357                 if (contractETHBalance > 0) {
358                     sendETHToFee(address(this).balance);
359                 }
360             }
361         }
362         
363         bool takeFee = true;
364 
365         //Transfer Tokens
366         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
367             takeFee = false;
368         } else {
369             
370             //Set Fee for Buys
371             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
372                 _redisFee = _redisFeeOnBuy;
373                 _taxFee = _taxFeeOnBuy;
374             }
375     
376             //Set Fee for Sells
377             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
378                 _redisFee = _redisFeeOnSell;
379                 _taxFee = _taxFeeOnSell;
380             }
381             
382         }
383 
384         _tokenTransfer(from, to, amount, takeFee);
385     }
386 
387     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
388         address[] memory path = new address[](2);
389         path[0] = address(this);
390         path[1] = uniswapV2Router.WETH();
391         _approve(address(this), address(uniswapV2Router), tokenAmount);
392         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
393             tokenAmount,
394             0,
395             path,
396             address(this),
397             block.timestamp
398         );
399     }
400 
401     function sendETHToFee(uint256 amount) private {
402         _opAddress.transfer(amount);
403     }
404 
405     function setTrading(bool _tradingOpen) public onlyOwner {
406         tradingOpen = _tradingOpen;
407     }
408 
409     function manualswap() external {
410         require(_msgSender() == _opAddress);
411         uint256 contractBalance = balanceOf(address(this));
412         swapTokensForEth(contractBalance);
413     }
414 
415     function manualsend() external {
416         require(_msgSender() == _opAddress);
417         uint256 contractETHBalance = address(this).balance;
418         sendETHToFee(contractETHBalance);
419     }
420 
421     function _tokenTransfer(
422         address sender,
423         address recipient,
424         uint256 amount,
425         bool takeFee
426     ) private {
427         if (!takeFee) removeAllFee();
428         _transferStandard(sender, recipient, amount);
429         if (!takeFee) restoreAllFee();
430     }
431 
432     function _transferStandard(
433         address sender,
434         address recipient,
435         uint256 tAmount
436     ) private {
437         (
438             uint256 rAmount,
439             uint256 rTransferAmount,
440             uint256 rFee,
441             uint256 tTransferAmount,
442             uint256 tFee,
443             uint256 tTeam
444         ) = _getValues(tAmount);
445         _rOwned[sender] = _rOwned[sender].sub(rAmount);
446         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
447         _takeTeam(tTeam);
448         _reflectFee(rFee, tFee);
449         emit Transfer(sender, recipient, tTransferAmount);
450     }
451 
452     function _takeTeam(uint256 tTeam) private {
453         uint256 currentRate = _getRate();
454         uint256 rTeam = tTeam.mul(currentRate);
455         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
456     }
457 
458     function _reflectFee(uint256 rFee, uint256 tFee) private {
459         _rTotal = _rTotal.sub(rFee);
460         _tFeeTotal = _tFeeTotal.add(tFee);
461     }
462 
463     receive() external payable {}
464 
465     function _getValues(uint256 tAmount)
466         private
467         view
468         returns (
469             uint256,
470             uint256,
471             uint256,
472             uint256,
473             uint256,
474             uint256
475         )
476     {
477         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
478             _getTValues(tAmount, _redisFee, _taxFee);
479         uint256 currentRate = _getRate();
480         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
481             _getRValues(tAmount, tFee, tTeam, currentRate);
482         
483         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
484     }
485 
486     function _getTValues(
487         uint256 tAmount,
488         uint256 redisFee,
489         uint256 taxFee
490     )
491         private
492         pure
493         returns (
494             uint256,
495             uint256,
496             uint256
497         )
498     {
499         uint256 tFee = tAmount.mul(redisFee).div(100);
500         uint256 tTeam = tAmount.mul(taxFee).div(100);
501         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
502 
503         return (tTransferAmount, tFee, tTeam);
504     }
505 
506     function _getRValues(
507         uint256 tAmount,
508         uint256 tFee,
509         uint256 tTeam,
510         uint256 currentRate
511     )
512         private
513         pure
514         returns (
515             uint256,
516             uint256,
517             uint256
518         )
519     {
520         uint256 rAmount = tAmount.mul(currentRate);
521         uint256 rFee = tFee.mul(currentRate);
522         uint256 rTeam = tTeam.mul(currentRate);
523         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
524 
525         return (rAmount, rTransferAmount, rFee);
526     }
527 
528     function _getRate() private view returns (uint256) {
529         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
530 
531         return rSupply.div(tSupply);
532     }
533 
534     function _getCurrentSupply() private view returns (uint256, uint256) {
535         uint256 rSupply = _rTotal;
536         uint256 tSupply = _tTotal;
537         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
538     
539         return (rSupply, tSupply);
540     }
541     
542     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
543         uint256 _totalbuy = redisFeeOnBuy + taxFeeOnBuy;
544         uint256 _totalsell = redisFeeOnSell + taxFeeOnSell;
545         require(_totalbuy <= 11);
546         require(_totalsell <= 11);
547         _redisFeeOnBuy = redisFeeOnBuy;
548         _redisFeeOnSell = redisFeeOnSell;
549      
550         _taxFeeOnBuy = taxFeeOnBuy;
551         _taxFeeOnSell = taxFeeOnSell;
552     }
553 
554     function removeAllLimits() external{
555         //Call this from opAddress wallet after renounce when you want to lift all limits
556       require(_msgSender() == _opAddress);
557      _maxTxAmount = _tTotal;
558      _maxWalletSize = _tTotal;
559     }
560 
561     function liftAllFees() external{
562         //Call this function after renounce to remove taxes, cannot be restored back
563          require(_msgSender() == _opAddress);
564         _redisFeeOnBuy = 0;
565         _redisFeeOnSell = 0;
566         _taxFeeOnBuy = 0;
567         _taxFeeOnSell = 0;
568 
569     }
570 
571 
572     //Set minimum tokens required to swap.
573     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
574         _swapTokensAtAmount = swapTokensAtAmount;
575     }
576     
577     //Set minimum tokens required to swap.
578     function toggleSwap(bool _swapEnabled) public onlyOwner {
579         swapEnabled = _swapEnabled;
580     }
581     
582     //Set MAx transaction
583     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
584         require(maxTxAmount >= 1000000000);
585         _maxTxAmount = maxTxAmount * 10**9 ;
586     }
587     
588     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
589         require(maxWalletSize >= 1000000000);
590         _maxWalletSize = maxWalletSize * 10**9 ;
591     }
592  
593     function allowPreTrading(address account, bool allowed) public onlyOwner {
594         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
595         preTrader[account] = allowed;
596     }
597 }