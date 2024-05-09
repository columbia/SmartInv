1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
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
16     function transfer(address recipient, uint256 amount) external returns (bool);
17  
18     function allowance(address owner, address spender) external view returns (uint256);
19  
20     function approve(address spender, uint256 amount) external returns (bool);
21  
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27  
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35  
36 contract Ownable is Context {
37     address internal _owner;
38     address private _previousOwner;
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43  
44     constructor() {
45         address msgSender = _msgSender();
46         _owner = msgSender;
47         emit OwnershipTransferred(address(0), msgSender);
48     }
49  
50     function owner() public view returns (address) {
51         return _owner;
52     }
53  
54     modifier onlyOwner() {
55         require(_owner == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58  
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63  
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69  
70 }
71 
72 library SafeMath {
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a, "SafeMath: addition overflow");
76         return c;
77     }
78  
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82  
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90         return c;
91     }
92  
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         if (a == 0) {
95             return 0;
96         }
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99         return c;
100     }
101  
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105  
106     function div(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b > 0, errorMessage);
112         uint256 c = a / b;
113         return c;
114     }
115 }
116  
117 interface IUniswapV2Factory {
118     function createPair(address tokenA, address tokenB)
119         external
120         returns (address pair);
121 }
122  
123 interface IUniswapV2Router02 {
124     function swapExactTokensForETHSupportingFeeOnTransferTokens(
125         uint256 amountIn,
126         uint256 amountOutMin,
127         address[] calldata path,
128         address to,
129         uint256 deadline
130     ) external;
131  
132     function factory() external pure returns (address);
133  
134     function WETH() external pure returns (address);
135  
136     function addLiquidityETH(
137         address token,
138         uint256 amountTokenDesired,
139         uint256 amountTokenMin,
140         uint256 amountETHMin,
141         address to,
142         uint256 deadline
143     )
144         external
145         payable
146         returns (
147             uint256 amountToken,
148             uint256 amountETH,
149             uint256 liquidity
150         );
151 }
152  
153 contract GGCOIN  is Context, IERC20, Ownable {
154  
155     using SafeMath for uint256;
156  
157     string private constant _name = "Good Game";
158     string private constant _symbol = "GG";
159     uint8 private constant _decimals = 9;
160  
161     mapping(address => uint256) private _rOwned;
162     mapping(address => uint256) private _tOwned;
163     mapping(address => mapping(address => uint256)) private _allowances;
164     mapping(address => bool) private _isExcludedFromFee;
165     mapping(address => bool) private _isExcludedFromMax;
166     uint256 private constant MAX = ~uint256(0);
167     uint256 private constant _tTotal = 1_000_000_000 * 10**9;
168     uint256 private _rTotal = (MAX - (MAX % _tTotal));
169     uint256 private _tFeeTotal;
170     uint256 private _redisFeeOnBuy = 0;  
171     uint256 private _taxFeeOnBuy = 25;  
172     uint256 private _redisFeeOnSell = 0;  
173     uint256 private _taxFeeOnSell = 40;
174  
175     uint256 private _redisFee = _redisFeeOnSell;
176     uint256 private _taxFee = _taxFeeOnSell;
177  
178     uint256 private _previousredisFee = _redisFee;
179     uint256 private _previoustaxFee = _taxFee;
180  
181     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
182     address payable private _developmentAddress = payable(0x8d9a3C6FbCCdC62c8DbECCE5646D249D054dC4F6); 
183     address payable private _marketingAddress = payable(0xF4e4f992e4B0BE7c767Db3F90Ad8b96ed2d2729B);
184  
185     IUniswapV2Router02 public uniswapV2Router;
186     address public uniswapV2Pair;
187  
188     bool private tradingOpen;
189     bool private inSwap = false;
190     bool private swapEnabled = true;
191  
192     uint256 public _maxTxAmount = _tTotal.mul(100).div(100);
193     uint256 public _maxWalletSize = _tTotal.mul(3).div(100); 
194     uint256 public _swapTokensAtAmount = _tTotal.mul(1).div(1000);
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
206  
207         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
208         uniswapV2Router = _uniswapV2Router;
209         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
210             .createPair(address(this), _uniswapV2Router.WETH());
211  
212         _isExcludedFromFee[owner()] = true;
213         _isExcludedFromFee[address(this)] = true;
214         _isExcludedFromFee[_developmentAddress] = true;
215         _isExcludedFromFee[_marketingAddress] = true;
216         _isExcludedFromMax[owner()] = true;
217         _isExcludedFromMax[address(this)] = true;
218         _isExcludedFromMax[_developmentAddress] = true;
219         _isExcludedFromMax[_marketingAddress] = true;
220  
221         emit Transfer(address(0), _msgSender(), _tTotal);
222     }
223  
224     function name() public pure returns (string memory) {
225         return _name;
226     }
227  
228     function symbol() public pure returns (string memory) {
229         return _symbol;
230     }
231  
232     function decimals() public pure returns (uint8) {
233         return _decimals;
234     }
235  
236     function totalSupply() public pure override returns (uint256) {
237         return _tTotal;
238     }
239  
240     function balanceOf(address account) public view override returns (uint256) {
241         return tokenFromReflection(_rOwned[account]);
242     }
243  
244     function transfer(address recipient, uint256 amount)
245         public
246         override
247         returns (bool)
248     {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252  
253     function allowance(address owner, address spender)
254         public
255         view
256         override
257         returns (uint256)
258     {
259         return _allowances[owner][spender];
260     }
261  
262     function approve(address spender, uint256 amount)
263         public
264         override
265         returns (bool)
266     {
267         _approve(_msgSender(), spender, amount);
268         return true;
269     }
270  
271     function transferFrom(
272         address sender,
273         address recipient,
274         uint256 amount
275     ) public override returns (bool) {
276         _transfer(sender, recipient, amount);
277         _approve(
278             sender,
279             _msgSender(),
280             _allowances[sender][_msgSender()].sub(
281                 amount,
282                 "ERC20: transfer amount exceeds allowance"
283             )
284         );
285         return true;
286     }
287  
288     function tokenFromReflection(uint256 rAmount)
289         private
290         view
291         returns (uint256)
292     {
293         require(
294             rAmount <= _rTotal,
295             "Amount must be less than total reflections"
296         );
297         uint256 currentRate = _getRate();
298         return rAmount.div(currentRate);
299     }
300  
301     function removeAllFee() private {
302         if (_redisFee == 0 && _taxFee == 0) return;
303  
304         _previousredisFee = _redisFee;
305         _previoustaxFee = _taxFee;
306  
307         _redisFee = 0;
308         _taxFee = 0;
309     }
310  
311     function restoreAllFee() private {
312         _redisFee = _previousredisFee;
313         _taxFee = _previoustaxFee;
314     }
315  
316     function _approve(
317         address owner,
318         address spender,
319         uint256 amount
320     ) private {
321         require(owner != address(0), "ERC20: approve from the zero address");
322         require(spender != address(0), "ERC20: approve to the zero address");
323         _allowances[owner][spender] = amount;
324         emit Approval(owner, spender, amount);
325     }
326  
327     function _transfer(
328         address from,
329         address to,
330         uint256 amount
331     ) private {
332         require(from != address(0), "ERC20: transfer from the zero address");
333         require(to != address(0), "ERC20: transfer to the zero address");
334         require(amount > 0, "Transfer amount must be greater than zero");
335  
336         if (from != owner() && to != owner()) {
337  
338             //Trade start check
339             if (!tradingOpen) {
340                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
341             }
342 
343             if (!_isExcludedFromMax[from]){
344                 require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
345             }
346             
347             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
348  
349             if(to != uniswapV2Pair && !_isExcludedFromMax[to]) {
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
372         //Transfer Tokens
373         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
374             takeFee = false;
375         } else {
376  
377             //Set Fee for Buys
378             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
379                 _redisFee = _redisFeeOnBuy;
380                 _taxFee = _taxFeeOnBuy;
381             }
382  
383             //Set Fee for Sells
384             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
385                 _redisFee = _redisFeeOnSell;
386                 _taxFee = _taxFeeOnSell;
387             }
388  
389         }
390  
391         _tokenTransfer(from, to, amount, takeFee);
392     }
393  
394     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
395         address[] memory path = new address[](2);
396         path[0] = address(this);
397         path[1] = uniswapV2Router.WETH();
398         _approve(address(this), address(uniswapV2Router), tokenAmount);
399         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
400             tokenAmount,
401             0,
402             path,
403             address(this),
404             block.timestamp
405         );
406     }
407  
408     function sendETHToFee(uint256 amount) private {
409         _marketingAddress.transfer(amount.mul(4).div(5));
410         _developmentAddress.transfer(amount.mul(1).div(5));
411     }
412  
413     function setTrading(bool _tradingOpen) public onlyOwner {
414         tradingOpen = _tradingOpen;
415     }
416  
417     function manualswap() external {
418         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
419         uint256 contractBalance = balanceOf(address(this));
420         swapTokensForEth(contractBalance);
421     }
422  
423     function manualsend() external {
424         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
425         uint256 contractETHBalance = address(this).balance;
426         sendETHToFee(contractETHBalance);
427     }
428  
429     function blockBots(address[] memory bots_) public onlyOwner {
430         for (uint256 i = 0; i < bots_.length; i++) {
431             bots[bots_[i]] = true;
432         }
433     }
434  
435     function unblockBot(address notbot) public onlyOwner {
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
496             _getTValues(tAmount, _redisFee, _taxFee);
497         uint256 currentRate = _getRate();
498         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
499             _getRValues(tAmount, tFee, tTeam, currentRate);
500         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
501     }
502  
503     function _getTValues(
504         uint256 tAmount,
505         uint256 redisFee,
506         uint256 taxFee
507     )
508         private
509         pure
510         returns (
511             uint256,
512             uint256,
513             uint256
514         )
515     {
516         uint256 tFee = tAmount.mul(redisFee).div(100);
517         uint256 tTeam = tAmount.mul(taxFee).div(100);
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
555     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
556         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 0, "Buy rewards must be between 0% and 0%");
557         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 99, "Buy tax must be between 0% and 99%");
558         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 0, "Sell rewards must be between 0% and 0%");
559         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 99%");
560 
561         _redisFeeOnBuy = redisFeeOnBuy;
562         _redisFeeOnSell = redisFeeOnSell;
563         _taxFeeOnBuy = taxFeeOnBuy;
564         _taxFeeOnSell = taxFeeOnSell;
565 
566     }
567  
568     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
569         _swapTokensAtAmount = swapTokensAtAmount;
570     }
571  
572     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
573         require(amountPercent>0);
574         _maxWalletSize = (_tTotal * amountPercent ) / 100;
575     }
576 
577     function removeLimits() external onlyOwner{
578         _maxTxAmount = _tTotal;
579         _maxWalletSize = _tTotal;
580     }
581 
582 
583 }