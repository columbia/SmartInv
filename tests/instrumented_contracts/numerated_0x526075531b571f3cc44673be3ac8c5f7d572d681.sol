1 // $KICHI - The mysterious and powerful goddess who ruled over luck and fortune in Japan.
2 // https://medium.com/@kichijotenerc20
3 
4 // SPDX-License-Identifier: unlicense
5 
6 pragma solidity ^0.8.15;
7  
8 abstract contract Context 
9 {
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
20     function transfer(address recipient, uint256 amount) external returns (bool);
21  
22     function allowance(address owner, address spender) external view returns (uint256);
23  
24     function approve(address spender, uint256 amount) external returns (bool);
25  
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31  
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(
34         address indexed owner,
35         address indexed spender,
36         uint256 value
37     );
38 }
39  
40 contract Ownable is Context {
41     address private _owner;
42     address private _previousOwner;
43     event OwnershipTransferred(
44         address indexed previousOwner,
45         address indexed newOwner
46     );
47  
48     constructor() {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53  
54     function owner() public view returns (address) {
55         return _owner;
56     }
57  
58     modifier onlyOwner() {
59         require(_owner == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62  
63     function renounceOwnership() public virtual onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67  
68     function transferOwnership(address newOwner) public virtual onlyOwner {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73  
74 }
75  
76 library SafeMath {
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "SafeMath: addition overflow");
80         return c;
81     }
82  
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86  
87     function sub(
88         uint256 a,
89         uint256 b,
90         string memory errorMessage
91     ) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94         return c;
95     }
96  
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         if (a == 0) {
99             return 0;
100         }
101         uint256 c = a * b;
102         require(c / a == b, "SafeMath: multiplication overflow");
103         return c;
104     }
105  
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109  
110     function div(
111         uint256 a,
112         uint256 b,
113         string memory errorMessage
114     ) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         return c;
118     }
119 }
120  
121 interface IUniswapV2Factory {
122     function createPair(address tokenA, address tokenB)
123         external
124         returns (address pair);
125 }
126  
127 interface IUniswapV2Router02 {
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint256 amountIn,
130         uint256 amountOutMin,
131         address[] calldata path,
132         address to,
133         uint256 deadline
134     ) external;
135  
136     function factory() external pure returns (address);
137  
138     function WETH() external pure returns (address);
139  
140     function addLiquidityETH(
141         address token,
142         uint256 amountTokenDesired,
143         uint256 amountTokenMin,
144         uint256 amountETHMin,
145         address to,
146         uint256 deadline
147     )
148         external
149         payable
150         returns (
151             uint256 amountToken,
152             uint256 amountETH,
153             uint256 liquidity
154         );
155 }
156  
157 contract Kichijoten is Context, IERC20, Ownable {
158  
159     using SafeMath for uint256;
160  
161     string private constant _name = "Kichijoten";
162     string private constant _symbol = "KICHI";
163     uint8 private constant _decimals = 9;
164  
165     mapping(address => uint256) private _rOwned;
166     mapping(address => uint256) private _tOwned;
167     mapping(address => mapping(address => uint256)) private _allowances;
168     mapping(address => bool) private _isExcludedFromFee;
169     uint256 private constant MAX = ~uint256(0);
170     uint256 private constant _tTotal = 10000000000 * 10**9;
171     uint256 private _rTotal = (MAX - (MAX % _tTotal));
172     uint256 private _tFeeTotal;
173     uint256 public launchBlock;
174  
175     uint256 private _redisFeeOnBuy = 0;
176     uint256 private _taxFeeOnBuy = 20;
177  
178     uint256 private _redisFeeOnSell = 0;
179     uint256 private _taxFeeOnSell = 20;
180  
181     uint256 private _redisFee = _redisFeeOnSell;
182     uint256 private _taxFee = _taxFeeOnSell;
183  
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186  
187     mapping(address => bool) public bots;
188     mapping(address => uint256) private cooldown;
189  
190     address payable private _developmentAddress = payable(0x1DF98815cd573d36fF91e34Fd2fA01220e2AfaaD);
191     address payable private _marketingAddress = payable(0x1DF98815cd573d36fF91e34Fd2fA01220e2AfaaD);
192  
193     IUniswapV2Router02 public uniswapV2Router;
194     address public uniswapV2Pair;
195  
196     bool private tradingOpen;
197     bool private inSwap = false;
198     bool private swapEnabled = true;
199  
200     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000); 
201     uint256 public _maxWalletSize = _tTotal.mul(20).div(1000); 
202     uint256 public _swapTokensAtAmount = _tTotal.mul(8).div(1000); 
203  
204     event MaxTxAmountUpdated(uint256 _maxTxAmount);
205     modifier lockTheSwap {
206         inSwap = true;
207         _;
208         inSwap = false;
209     }
210  
211     constructor() {
212  
213         _rOwned[_msgSender()] = _rTotal;
214  
215         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
216         uniswapV2Router = _uniswapV2Router;
217         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
218             .createPair(address(this), _uniswapV2Router.WETH());
219  
220         _isExcludedFromFee[owner()] = true;
221         _isExcludedFromFee[address(this)] = true;
222         _isExcludedFromFee[_developmentAddress] = true;
223         _isExcludedFromFee[_marketingAddress] = true;
224   
225         emit Transfer(address(0), _msgSender(), _tTotal);
226     }
227  
228     function name() public pure returns (string memory) {
229         return _name;
230     }
231  
232     function symbol() public pure returns (string memory) {
233         return _symbol;
234     }
235  
236     function decimals() public pure returns (uint8) {
237         return _decimals;
238     }
239  
240     function totalSupply() public pure override returns (uint256) {
241         return _tTotal;
242     }
243  
244     function balanceOf(address account) public view override returns (uint256) {
245         return tokenFromReflection(_rOwned[account]);
246     }
247  
248     function transfer(address recipient, uint256 amount)
249         public
250         override
251         returns (bool)
252     {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256  
257     function allowance(address owner, address spender)
258         public
259         view
260         override
261         returns (uint256)
262     {
263         return _allowances[owner][spender];
264     }
265  
266     function approve(address spender, uint256 amount)
267         public
268         override
269         returns (bool)
270     {
271         _approve(_msgSender(), spender, amount);
272         return true;
273     }
274  
275     function transferFrom(
276         address sender,
277         address recipient,
278         uint256 amount
279     ) public override returns (bool) {
280         _transfer(sender, recipient, amount);
281         _approve(
282             sender,
283             _msgSender(),
284             _allowances[sender][_msgSender()].sub(
285                 amount,
286                 "ERC20: transfer amount exceeds allowance"
287             )
288         );
289         return true;
290     }
291  
292     function tokenFromReflection(uint256 rAmount)
293         private
294         view
295         returns (uint256)
296     {
297         require(
298             rAmount <= _rTotal,
299             "Amount must be less than total reflections"
300         );
301         uint256 currentRate = _getRate();
302         return rAmount.div(currentRate);
303     }
304  
305     function removeAllFee() private {
306         if (_redisFee == 0 && _taxFee == 0) return;
307  
308         _previousredisFee = _redisFee;
309         _previoustaxFee = _taxFee;
310  
311         _redisFee = 0;
312         _taxFee = 0;
313     }
314  
315     function restoreAllFee() private {
316         _redisFee = _previousredisFee;
317         _taxFee = _previoustaxFee;
318     }
319  
320     function _approve(
321         address owner,
322         address spender,
323         uint256 amount
324     ) private {
325         require(owner != address(0), "ERC20: approve from the zero address");
326         require(spender != address(0), "ERC20: approve to the zero address");
327         _allowances[owner][spender] = amount;
328         emit Approval(owner, spender, amount);
329     }
330  
331     function _transfer(
332         address from,
333         address to,
334         uint256 amount
335     ) private {
336         require(from != address(0), "ERC20: transfer from the zero address");
337         require(to != address(0), "ERC20: transfer to the zero address");
338         require(amount > 0, "Transfer amount must be greater than zero");
339  
340         if (from != owner() && to != owner()) {
341  
342             if (!tradingOpen) {
343                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
344             }
345  
346             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
347             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
348  
349             if(to != uniswapV2Pair) {
350                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
351             }
352  
353             uint256 contractTokenBalance = balanceOf(address(this));
354             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
355  
356             if(contractTokenBalance >= _maxTxAmount)
357             {
358                 contractTokenBalance = _maxTxAmount;
359             }
360  
361             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
362                 swapTokensForEth(contractTokenBalance);
363                 uint256 contractETHBalance = address(this).balance;
364                 if (contractETHBalance > 0) {
365                     sendETHToFee(address(this).balance);
366                 }
367             }
368         }
369  
370         bool takeFee = true;
371  
372         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
373             takeFee = false;
374         } else {
375  
376             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
377                 _redisFee = _redisFeeOnBuy;
378                 _taxFee = _taxFeeOnBuy;
379             }
380  
381             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
382                 _redisFee = _redisFeeOnSell;
383                 _taxFee = _taxFeeOnSell;
384             }
385  
386         }
387  
388         _tokenTransfer(from, to, amount, takeFee);
389     }
390  
391     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
392         address[] memory path = new address[](2);
393         path[0] = address(this);
394         path[1] = uniswapV2Router.WETH();
395         _approve(address(this), address(uniswapV2Router), tokenAmount);
396         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
397             tokenAmount,
398             0,
399             path,
400             address(this),
401             block.timestamp
402         );
403     }
404  
405     function sendETHToFee(uint256 amount) private {
406         _developmentAddress.transfer(amount.div(2));
407         _marketingAddress.transfer(amount.div(2));
408     }
409  
410     function toredo(bool _tradingOpen) public onlyOwner {
411         tradingOpen = _tradingOpen;
412         launchBlock = block.number;
413     }
414  
415     function manualswap() external {
416         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
417         uint256 contractBalance = balanceOf(address(this));
418         swapTokensForEth(contractBalance);
419     }
420  
421     function manualsend() external {
422         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
423         uint256 contractETHBalance = address(this).balance;
424         sendETHToFee(contractETHBalance);
425     }
426  
427     function blockBots(address[] memory bots_) public onlyOwner {
428         for (uint256 i = 0; i < bots_.length; i++) {
429             bots[bots_[i]] = true;
430         }
431     }
432  
433     function unblockBot(address notbot) public onlyOwner {
434         bots[notbot] = false;
435     }
436  
437     function _tokenTransfer(
438         address sender,
439         address recipient,
440         uint256 amount,
441         bool takeFee
442     ) private {
443         if (!takeFee) removeAllFee();
444         _transferStandard(sender, recipient, amount);
445         if (!takeFee) restoreAllFee();
446     }
447  
448     function _transferStandard(
449         address sender,
450         address recipient,
451         uint256 tAmount
452     ) private {
453         (
454             uint256 rAmount,
455             uint256 rTransferAmount,
456             uint256 rFee,
457             uint256 tTransferAmount,
458             uint256 tFee,
459             uint256 tTeam
460         ) = _getValues(tAmount);
461         _rOwned[sender] = _rOwned[sender].sub(rAmount);
462         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
463         _takeTeam(tTeam);
464         _reflectFee(rFee, tFee);
465         emit Transfer(sender, recipient, tTransferAmount);
466     }
467  
468     function _takeTeam(uint256 tTeam) private {
469         uint256 currentRate = _getRate();
470         uint256 rTeam = tTeam.mul(currentRate);
471         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
472     }
473  
474     function _reflectFee(uint256 rFee, uint256 tFee) private {
475         _rTotal = _rTotal.sub(rFee);
476         _tFeeTotal = _tFeeTotal.add(tFee);
477     }
478  
479     receive() external payable {}
480  
481     function _getValues(uint256 tAmount)
482         private
483         view
484         returns (
485             uint256,
486             uint256,
487             uint256,
488             uint256,
489             uint256,
490             uint256
491         )
492     {
493         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
494             _getTValues(tAmount, _redisFee, _taxFee);
495         uint256 currentRate = _getRate();
496         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
497             _getRValues(tAmount, tFee, tTeam, currentRate);
498  
499         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
500     }
501  
502     function _getTValues(
503         uint256 tAmount,
504         uint256 redisFee,
505         uint256 taxFee
506     )
507         private
508         pure
509         returns (
510             uint256,
511             uint256,
512             uint256
513         )
514     {
515         uint256 tFee = tAmount.mul(redisFee).div(100);
516         uint256 tTeam = tAmount.mul(taxFee).div(100);
517         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
518  
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
540  
541         return (rAmount, rTransferAmount, rFee);
542     }
543  
544     function _getRate() private view returns (uint256) {
545         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
546  
547         return rSupply.div(tSupply);
548     }
549  
550     function _getCurrentSupply() private view returns (uint256, uint256) {
551         uint256 rSupply = _rTotal;
552         uint256 tSupply = _tTotal;
553         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
554  
555         return (rSupply, tSupply);
556     }
557  
558     function ReduceFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
559         _redisFeeOnBuy = redisFeeOnBuy;
560         _redisFeeOnSell = redisFeeOnSell;
561  
562         _taxFeeOnBuy = taxFeeOnBuy;
563         _taxFeeOnSell = taxFeeOnSell;
564     }
565  
566     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
567         _swapTokensAtAmount = swapTokensAtAmount;
568     }
569  
570     function toggleSwap(bool _swapEnabled) public onlyOwner {
571         swapEnabled = _swapEnabled;
572     }
573 
574     function removeLimit () external onlyOwner{
575         _maxTxAmount = _tTotal;
576         _maxWalletSize = _tTotal;
577     }
578  
579     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
580         _maxTxAmount = maxTxAmount;
581     }
582  
583     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
584         _maxWalletSize = maxWalletSize;
585     }
586  
587     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
588         for(uint256 i = 0; i < accounts.length; i++) {
589             _isExcludedFromFee[accounts[i]] = excluded;
590         }
591     }
592 }