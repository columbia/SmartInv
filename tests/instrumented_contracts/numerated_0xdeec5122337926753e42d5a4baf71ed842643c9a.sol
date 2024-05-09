1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.10;
3  
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9  
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12  
13     function balanceOf(address account) external view returns (uint256);
14  
15     function transfer(address recipient, uint256 amount) external returns (bool);
16  
17     function allowance(address owner, address spender) external view returns (uint256);
18  
19     function approve(address spender, uint256 amount) external returns (bool);
20  
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26  
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(
29         address indexed owner,
30         address indexed spender,
31         uint256 value
32     );
33 }
34  
35 contract Ownable is Context {
36     address private _owner;
37     address private _previousOwner;
38     event OwnershipTransferred(
39         address indexed previousOwner,
40         address indexed newOwner
41     );
42  
43     constructor() {
44         address msgSender = _msgSender();
45         _owner = msgSender;
46         emit OwnershipTransferred(address(0), msgSender);
47     }
48  
49     function owner() public view returns (address) {
50         return _owner;
51     }
52  
53     modifier onlyOwner() {
54         require(_owner == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57  
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62  
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68  
69 }
70  
71 library SafeMath {
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75         return c;
76     }
77  
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         return sub(a, b, "SafeMath: subtraction overflow");
80     }
81  
82     function sub(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89         return c;
90     }
91  
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         if (a == 0) {
94             return 0;
95         }
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98         return c;
99     }
100  
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104  
105     function div(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112         return c;
113     }
114 }
115  
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB)
118         external
119         returns (address pair);
120 }
121  
122 interface IUniswapV2Router02 {
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint256 amountIn,
125         uint256 amountOutMin,
126         address[] calldata path,
127         address to,
128         uint256 deadline
129     ) external;
130  
131     function factory() external pure returns (address);
132  
133     function WETH() external pure returns (address);
134  
135     function addLiquidityETH(
136         address token,
137         uint256 amountTokenDesired,
138         uint256 amountTokenMin,
139         uint256 amountETHMin,
140         address to,
141         uint256 deadline
142     )
143         external
144         payable
145         returns (
146             uint256 amountToken,
147             uint256 amountETH,
148             uint256 liquidity
149         );
150 }
151  
152 contract Revenue is Context, IERC20, Ownable {
153  
154     using SafeMath for uint256;
155  
156     string private constant _name = "Revenue Protocol";
157     string private constant _symbol = "REV";
158     uint8 private constant _decimals = 18;
159  
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 1000000 * 10**18;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168     uint256 private _redisFeeOnBuy = 0;  
169     uint256 private _taxFeeOnBuy = 5;  
170     uint256 private _redisFeeOnSell = 0;  
171     uint256 private _taxFeeOnSell = 5;
172  
173     uint256 private _redisFee = _redisFeeOnSell;
174     uint256 private _taxFee = _taxFeeOnSell;
175  
176     uint256 private _previousredisFee = _redisFee;
177     uint256 private _previoustaxFee = _taxFee;
178  
179     mapping(address => bool) public bots; 
180     mapping (address => uint256) public _buyMap;
181     
182     address payable private _marketingAddress = payable(0x1e7aE5d1aE4D7e68083C1C657d76354CdeBCa38C);
183     address payable private _teamAddress = payable(0x384BbBc68Ef82aB23A754f760A6f0D6190819124); 
184  
185     IUniswapV2Router02 public uniswapV2Router;
186     address public uniswapV2Pair;
187  
188     bool private tradingOpen;
189     bool private inSwap = false;
190     bool private swapEnabled = true;
191  
192     uint256 public _maxTxAmount = 10000 * 10**18; 
193     uint256 public _maxWalletSize = 10000 * 10**18; 
194     uint256 public _swapTokensAtAmount = 10 * 10**18;
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
214         _isExcludedFromFee[_teamAddress] = true;
215         _isExcludedFromFee[_marketingAddress] = true;
216  
217         emit Transfer(address(0), _msgSender(), _tTotal);
218     }
219  
220     function name() public pure returns (string memory) {
221         return _name;
222     }
223  
224     function symbol() public pure returns (string memory) {
225         return _symbol;
226     }
227  
228     function decimals() public pure returns (uint8) {
229         return _decimals;
230     }
231  
232     function totalSupply() public pure override returns (uint256) {
233         return _tTotal;
234     }
235  
236     function balanceOf(address account) public view override returns (uint256) {
237         return tokenFromReflection(_rOwned[account]);
238     }
239  
240     function transfer(address recipient, uint256 amount)
241         public
242         override
243         returns (bool)
244     {
245         _transfer(_msgSender(), recipient, amount);
246         return true;
247     }
248  
249     function allowance(address owner, address spender)
250         public
251         view
252         override
253         returns (uint256)
254     {
255         return _allowances[owner][spender];
256     }
257  
258     function approve(address spender, uint256 amount)
259         public
260         override
261         returns (bool)
262     {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266  
267     function transferFrom(
268         address sender,
269         address recipient,
270         uint256 amount
271     ) public override returns (bool) {
272         _transfer(sender, recipient, amount);
273         _approve(
274             sender,
275             _msgSender(),
276             _allowances[sender][_msgSender()].sub(
277                 amount,
278                 "ERC20: transfer amount exceeds allowance"
279             )
280         );
281         return true;
282     }
283  
284     function tokenFromReflection(uint256 rAmount)
285         private
286         view
287         returns (uint256)
288     {
289         require(
290             rAmount <= _rTotal,
291             "Amount must be less than total reflections"
292         );
293         uint256 currentRate = _getRate();
294         return rAmount.div(currentRate);
295     }
296  
297     function removeAllFee() private {
298         if (_redisFee == 0 && _taxFee == 0) return;
299  
300         _previousredisFee = _redisFee;
301         _previoustaxFee = _taxFee;
302  
303         _redisFee = 0;
304         _taxFee = 0;
305     }
306  
307     function restoreAllFee() private {
308         _redisFee = _previousredisFee;
309         _taxFee = _previoustaxFee;
310     }
311  
312     function _approve(
313         address owner,
314         address spender,
315         uint256 amount
316     ) private {
317         require(owner != address(0), "ERC20: approve from the zero address");
318         require(spender != address(0), "ERC20: approve to the zero address");
319         _allowances[owner][spender] = amount;
320         emit Approval(owner, spender, amount);
321     }
322  
323     function _transfer(
324         address from,
325         address to,
326         uint256 amount
327     ) private {
328         require(from != address(0), "ERC20: transfer from the zero address");
329         require(to != address(0), "ERC20: transfer to the zero address");
330         require(amount > 0, "Transfer amount must be greater than zero");
331  
332         if (from != owner() && to != owner()) {
333  
334             //Trade start check
335             if (!tradingOpen) {
336                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
337             }
338  
339             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
340             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
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
354             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
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
402          uint256 halfAmount = amount / 2;
403 
404         _marketingAddress.transfer(halfAmount);
405         _teamAddress.transfer(halfAmount);
406     }
407  
408     function setTrading(bool _tradingOpen) public onlyOwner {
409         tradingOpen = _tradingOpen;
410     }
411  
412     function manualswap() external {
413         require(_msgSender() == _teamAddress || _msgSender() == _marketingAddress);
414         uint256 contractBalance = balanceOf(address(this));
415         swapTokensForEth(contractBalance);
416     }
417  
418     function manualsend() external {
419         require(_msgSender() == _teamAddress || _msgSender() == _marketingAddress);
420         uint256 contractETHBalance = address(this).balance;
421         sendETHToFee(contractETHBalance);
422     }
423  
424     function blockBots(address[] memory bots_) public onlyOwner {
425         for (uint256 i = 0; i < bots_.length; i++) {
426             bots[bots_[i]] = true;
427         }
428     }
429  
430     function unblockBot(address notbot) public onlyOwner {
431         bots[notbot] = false;
432     }
433  
434     function _tokenTransfer(
435         address sender,
436         address recipient,
437         uint256 amount,
438         bool takeFee
439     ) private {
440         if (!takeFee) removeAllFee();
441         _transferStandard(sender, recipient, amount);
442         if (!takeFee) restoreAllFee();
443     }
444  
445     function _transferStandard(
446         address sender,
447         address recipient,
448         uint256 tAmount
449     ) private {
450         (
451             uint256 rAmount,
452             uint256 rTransferAmount,
453             uint256 rFee,
454             uint256 tTransferAmount,
455             uint256 tFee,
456             uint256 tTeam
457         ) = _getValues(tAmount);
458         _rOwned[sender] = _rOwned[sender].sub(rAmount);
459         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
460         _takeTeam(tTeam);
461         _reflectFee(rFee, tFee);
462         emit Transfer(sender, recipient, tTransferAmount);
463     }
464  
465     function _takeTeam(uint256 tTeam) private {
466         uint256 currentRate = _getRate();
467         uint256 rTeam = tTeam.mul(currentRate);
468         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
469     }
470  
471     function _reflectFee(uint256 rFee, uint256 tFee) private {
472         _rTotal = _rTotal.sub(rFee);
473         _tFeeTotal = _tFeeTotal.add(tFee);
474     }
475  
476     receive() external payable {}
477  
478     function _getValues(uint256 tAmount)
479         private
480         view
481         returns (
482             uint256,
483             uint256,
484             uint256,
485             uint256,
486             uint256,
487             uint256
488         )
489     {
490         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
491             _getTValues(tAmount, _redisFee, _taxFee);
492         uint256 currentRate = _getRate();
493         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
494             _getRValues(tAmount, tFee, tTeam, currentRate);
495         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
496     }
497  
498     function _getTValues(
499         uint256 tAmount,
500         uint256 redisFee,
501         uint256 taxFee
502     )
503         private
504         pure
505         returns (
506             uint256,
507             uint256,
508             uint256
509         )
510     {
511         uint256 tFee = tAmount.mul(redisFee).div(100);
512         uint256 tTeam = tAmount.mul(taxFee).div(100);
513         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
514         return (tTransferAmount, tFee, tTeam);
515     }
516  
517     function _getRValues(
518         uint256 tAmount,
519         uint256 tFee,
520         uint256 tTeam,
521         uint256 currentRate
522     )
523         private
524         pure
525         returns (
526             uint256,
527             uint256,
528             uint256
529         )
530     {
531         uint256 rAmount = tAmount.mul(currentRate);
532         uint256 rFee = tFee.mul(currentRate);
533         uint256 rTeam = tTeam.mul(currentRate);
534         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
535         return (rAmount, rTransferAmount, rFee);
536     }
537  
538     function _getRate() private view returns (uint256) {
539         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
540         return rSupply.div(tSupply);
541     }
542  
543     function _getCurrentSupply() private view returns (uint256, uint256) {
544         uint256 rSupply = _rTotal;
545         uint256 tSupply = _tTotal;
546         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
547         return (rSupply, tSupply);
548     }
549  
550     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
551         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
552         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 99, "Buy tax must be between 0% and 98%");
553         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
554         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 98%");
555 
556         _redisFeeOnBuy = redisFeeOnBuy;
557         _redisFeeOnSell = redisFeeOnSell;
558         _taxFeeOnBuy = taxFeeOnBuy;
559         _taxFeeOnSell = taxFeeOnSell;
560 
561     }
562  
563     //Set minimum tokens required to swap.
564     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
565         _swapTokensAtAmount = swapTokensAtAmount;
566     }
567  
568     //Set minimum tokens required to swap.
569     function toggleSwap(bool _swapEnabled) public onlyOwner {
570         swapEnabled = _swapEnabled;
571     }
572  
573     //Set maximum transaction
574     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
575            _maxTxAmount = maxTxAmount;
576         
577     }
578  
579     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
580         _maxWalletSize = maxWalletSize;
581     }
582  
583     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
584         for(uint256 i = 0; i < accounts.length; i++) {
585             _isExcludedFromFee[accounts[i]] = excluded;
586         }
587     }
588 
589 }