1 //SPDX-License-Identifier: UNLICENSED
2 /*
3  https://areyouwoke.io/
4  https://twitter.com/areyouwoke0
5  Stay woke 
6 We are leaving it to the community to create the next generation of woke via creating the TG. 
7 Show us how well you can do it.
8 The team will be watching and will be helping out along the way.
9 
10   _____ __________________________.___.________   ____ ___  __      __________   ____  __.___________    .__        
11   /  _  \\______   \_   _____/\__  |   |\_____  \ |    |   \/  \    /  \_____  \ |    |/ _|\_   _____/    |__| ____  
12  /  /_\  \|       _/|    __)_  /   |   | /   |   \|    |   /\   \/\/   //   |   \|      <   |    __)_     |  |/  _ \ 
13 /    |    \    |   \|        \ \____   |/    |    \    |  /  \        //    |    \    |  \  |        \    |  (  <_> )
14 \____|__  /____|_  /_______  / / ______|\_______  /______/    \__/\  / \_______  /____|__ \/_______  / /\ |__|\____/ 
15         \/       \/        \/  \/               \/                 \/          \/        \/        \/  \/            
16 
17 */
18 
19 
20 pragma solidity ^0.8.4;
21  
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27  
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30  
31     function balanceOf(address account) external view returns (uint256);
32  
33     function transfer(address recipient, uint256 amount) external returns (bool);
34  
35     function allowance(address owner, address spender) external view returns (uint256);
36  
37     function approve(address spender, uint256 amount) external returns (bool);
38  
39     function transferFrom(
40         address sender,
41         address recipient,
42         uint256 amount
43     ) external returns (bool);
44  
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(
47         address indexed owner,
48         address indexed spender,
49         uint256 value
50     );
51 }
52  
53 contract Ownable is Context {
54     address private _owner;
55     address private _previousOwner;
56     event OwnershipTransferred(
57         address indexed previousOwner,
58         address indexed newOwner
59     );
60  
61     constructor() {
62         address msgSender = _msgSender();
63         _owner = msgSender;
64         emit OwnershipTransferred(address(0), msgSender);
65     }
66  
67     function owner() public view returns (address) {
68         return _owner;
69     }
70  
71     modifier onlyOwner() {
72         require(_owner == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75  
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80  
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         emit OwnershipTransferred(_owner, newOwner);
84         _owner = newOwner;
85     }
86  
87 }
88  
89 library SafeMath {
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93         return c;
94     }
95  
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99  
100     function sub(
101         uint256 a,
102         uint256 b,
103         string memory errorMessage
104     ) internal pure returns (uint256) {
105         require(b <= a, errorMessage);
106         uint256 c = a - b;
107         return c;
108     } 
109     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110         if (a == 0) {
111             return 0;
112         }
113         uint256 c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115         return c;
116     }
117  
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121  
122     function div(
123         uint256 a,
124         uint256 b,
125         string memory errorMessage
126     ) internal pure returns (uint256) {
127         require(b > 0, errorMessage);
128         uint256 c = a / b;
129         return c;
130     }
131 }
132  
133 interface IUniswapV2Factory {
134     function createPair(address tokenA, address tokenB)
135         external
136         returns (address pair);
137 }
138  
139 interface IUniswapV2Router02 {
140     function swapExactTokensForETHSupportingFeeOnTransferTokens(
141         uint256 amountIn,
142         uint256 amountOutMin,
143         address[] calldata path,
144         address to,
145         uint256 deadline
146     ) external;
147  
148     function factory() external pure returns (address);
149  
150     function WETH() external pure returns (address);
151  
152     function addLiquidityETH(
153         address token,
154         uint256 amountTokenDesired,
155         uint256 amountTokenMin,
156         uint256 amountETHMin,
157         address to,
158         uint256 deadline
159     )
160         external
161         payable
162         returns (
163             uint256 amountToken,
164             uint256 amountETH,
165             uint256 liquidity
166         );
167 }
168  
169 contract WOKE is Context, IERC20, Ownable {
170  
171     using SafeMath for uint256;
172  
173     string private constant _name = "WOKE"; 
174     string private constant _symbol = "WOKE"; 
175     uint8 private constant _decimals = 9;
176  
177     mapping(address => uint256) private _rOwned;
178     mapping(address => uint256) private _tOwned;
179     mapping(address => mapping(address => uint256)) private _allowances;
180     mapping(address => bool) private _isExcludedFromFee;
181     uint256 private constant MAX = ~uint256(0);
182 
183     uint256 private constant _tTotal = 1000000 * 10**9; 
184     uint256 private _rTotal = (MAX - (MAX % _tTotal));
185     uint256 private _tFeeTotal;
186  
187     //Buy Fee
188     uint256 private _redisFeeOnBuy = 0;  
189     uint256 private _taxFeeOnBuy = 0;   
190  
191     //Sell Fee
192     uint256 private _redisFeeOnSell = 0; 
193     uint256 private _taxFeeOnSell = 0;  
194 
195     uint256 public totalFees;
196  
197     //Original Fee
198     uint256 private _redisFee = _redisFeeOnSell;
199     uint256 private _taxFee = _taxFeeOnSell;
200  
201     uint256 private _previousredisFee = _redisFee;
202     uint256 private _previoustaxFee = _taxFee;
203  
204     mapping(address => uint256) private cooldown;
205  
206     address payable private _developmentAddress = payable(0xeDe739e1b985361f93a0a53b7940aa609Ce9D877);
207     address payable private _marketingAddress = payable(0xeDe739e1b985361f93a0a53b7940aa609Ce9D877);
208  
209     IUniswapV2Router02 public uniswapV2Router;
210     address public uniswapV2Pair;
211  
212     bool private tradingOpen;
213     bool private inSwap = false;
214     bool private swapEnabled = true;
215  
216     uint256 public _maxTxAmount = 50000 * 10**9;
217     uint256 public _maxWalletSize = 50000 * 10**9; 
218     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
219  
220     event MaxTxAmountUpdated(uint256 _maxTxAmount);
221     modifier lockTheSwap {
222         inSwap = true;
223         _;
224         inSwap = false;
225     }
226  
227     constructor() {
228  
229         _rOwned[_msgSender()] = _rTotal;
230  
231         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
232         uniswapV2Router = _uniswapV2Router;
233         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
234             .createPair(address(this), _uniswapV2Router.WETH());
235  
236         _isExcludedFromFee[owner()] = true;
237         _isExcludedFromFee[address(this)] = true;
238         _isExcludedFromFee[_developmentAddress] = true;
239         _isExcludedFromFee[_marketingAddress] = true;
240  
241  
242         emit Transfer(address(0), _msgSender(), _tTotal);
243     }
244  
245     function name() public pure returns (string memory) {
246         return _name;
247     }
248  
249     function symbol() public pure returns (string memory) {
250         return _symbol;
251     }
252  
253     function decimals() public pure returns (uint8) {
254         return _decimals;
255     }
256  
257     function totalSupply() public pure override returns (uint256) {
258         return _tTotal;
259     }
260  
261     function balanceOf(address account) public view override returns (uint256) {
262         return tokenFromReflection(_rOwned[account]);
263     }
264  
265     function transfer(address recipient, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _transfer(_msgSender(), recipient, amount);
271         return true;
272     }
273  
274     function allowance(address owner, address spender)
275         public
276         view
277         override
278         returns (uint256)
279     {
280         return _allowances[owner][spender];
281     }
282  
283     function approve(address spender, uint256 amount)
284         public
285         override
286         returns (bool)
287     {
288         _approve(_msgSender(), spender, amount);
289         return true;
290     }
291  
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public override returns (bool) {
297         _transfer(sender, recipient, amount);
298         _approve(
299             sender,
300             _msgSender(),
301             _allowances[sender][_msgSender()].sub(
302                 amount,
303                 "ERC20: transfer amount exceeds allowance"
304             )
305         );
306         return true;
307     }
308  
309     function tokenFromReflection(uint256 rAmount)
310         private
311         view
312         returns (uint256)
313     {
314         require(
315             rAmount <= _rTotal,
316             "Amount must be less than total reflections"
317         );
318         uint256 currentRate = _getRate();
319         return rAmount.div(currentRate);
320     }
321  
322     function removeAllFee() private {
323         if (_redisFee == 0 && _taxFee == 0) return;
324  
325         _previousredisFee = _redisFee;
326         _previoustaxFee = _taxFee;
327  
328         _redisFee = 0;
329         _taxFee = 0;
330     }
331  
332     function restoreAllFee() private {
333         _redisFee = _previousredisFee;
334         _taxFee = _previoustaxFee;
335     }
336  
337     function _approve(
338         address owner,
339         address spender,
340         uint256 amount
341     ) private {
342         require(owner != address(0), "ERC20: approve from the zero address");
343         require(spender != address(0), "ERC20: approve to the zero address");
344         _allowances[owner][spender] = amount;
345         emit Approval(owner, spender, amount);
346     }
347  
348     function _transfer(
349         address from,
350         address to,
351         uint256 amount
352     ) private {
353         require(from != address(0), "ERC20: transfer from the zero address");
354         require(to != address(0), "ERC20: transfer to the zero address");
355         require(amount > 0, "Transfer amount must be greater than zero");
356  
357         if (from != owner() && to != owner()) {
358  
359             //Trade start check
360             if (!tradingOpen) {
361                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
362             }
363  
364             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
365  
366             if(to != uniswapV2Pair) {
367                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
368             }
369  
370             uint256 contractTokenBalance = balanceOf(address(this));
371             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
372  
373             if(contractTokenBalance >= _maxTxAmount)
374             {
375                 contractTokenBalance = _maxTxAmount;
376             }
377  
378             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
379                 swapTokensForEth(contractTokenBalance);
380                 uint256 contractETHBalance = address(this).balance;
381                 if (contractETHBalance > 0) {
382                     sendETHToFee(address(this).balance);
383                 }
384             }
385         }
386  
387         bool takeFee = true;
388  
389         //Transfer Tokens
390         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
391             takeFee = false;
392         } else {
393  
394             //Set Fee for Buys
395             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
396                 _redisFee = _redisFeeOnBuy;
397                 _taxFee = _taxFeeOnBuy;
398             }
399  
400             //Set Fee for Sells
401             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
402                 _redisFee = _redisFeeOnSell;
403                 _taxFee = _taxFeeOnSell;
404             }
405  
406         }
407  
408         _tokenTransfer(from, to, amount, takeFee);
409     }
410  
411     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
412         address[] memory path = new address[](2);
413         path[0] = address(this);
414         path[1] = uniswapV2Router.WETH();
415         _approve(address(this), address(uniswapV2Router), tokenAmount);
416         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
417             tokenAmount,
418             0,
419             path,
420             address(this),
421             block.timestamp
422         );
423     }
424  
425     function sendETHToFee(uint256 amount) private {
426         _developmentAddress.transfer(amount.div(2));
427         _marketingAddress.transfer(amount.div(2));
428     }
429  
430     function setTrading(bool _tradingOpen) public onlyOwner {
431         tradingOpen = _tradingOpen;
432     }
433  
434     function manualswap() external {
435         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
436         uint256 contractBalance = balanceOf(address(this));
437         swapTokensForEth(contractBalance);
438     }
439  
440     function manualsend() external {
441         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
442         uint256 contractETHBalance = address(this).balance;
443         sendETHToFee(contractETHBalance);
444     }
445  
446     function _tokenTransfer(
447         address sender,
448         address recipient,
449         uint256 amount,
450         bool takeFee
451     ) private {
452         if (!takeFee) removeAllFee();
453         _transferStandard(sender, recipient, amount);
454         if (!takeFee) restoreAllFee();
455     }
456  
457     function _transferStandard(
458         address sender,
459         address recipient,
460         uint256 tAmount
461     ) private {
462         (
463             uint256 rAmount,
464             uint256 rTransferAmount,
465             uint256 rFee,
466             uint256 tTransferAmount,
467             uint256 tFee,
468             uint256 tTeam
469         ) = _getValues(tAmount);
470         _rOwned[sender] = _rOwned[sender].sub(rAmount);
471         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
472         _takeTeam(tTeam);
473         _reflectFee(rFee, tFee);
474         emit Transfer(sender, recipient, tTransferAmount);
475     }
476  
477     function _takeTeam(uint256 tTeam) private {
478         uint256 currentRate = _getRate();
479         uint256 rTeam = tTeam.mul(currentRate);
480         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
481     }
482  
483     function _reflectFee(uint256 rFee, uint256 tFee) private {
484         _rTotal = _rTotal.sub(rFee);
485         _tFeeTotal = _tFeeTotal.add(tFee);
486     }
487  
488     receive() external payable {}
489  
490     function _getValues(uint256 tAmount)
491         private
492         view
493         returns (
494             uint256,
495             uint256,
496             uint256,
497             uint256,
498             uint256,
499             uint256
500         )
501     {
502         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
503             _getTValues(tAmount, _redisFee, _taxFee);
504         uint256 currentRate = _getRate();
505         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
506             _getRValues(tAmount, tFee, tTeam, currentRate);
507  
508         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
509     }
510  
511     function _getTValues(
512         uint256 tAmount,
513         uint256 redisFee,
514         uint256 taxFee
515     )
516         private
517         pure
518         returns (
519             uint256,
520             uint256,
521             uint256
522         )
523     {
524         uint256 tFee = tAmount.mul(redisFee).div(100);
525         uint256 tTeam = tAmount.mul(taxFee).div(100);
526         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
527  
528         return (tTransferAmount, tFee, tTeam);
529     }
530  
531     function _getRValues(
532         uint256 tAmount,
533         uint256 tFee,
534         uint256 tTeam,
535         uint256 currentRate
536     )
537         private
538         pure
539         returns (
540             uint256,
541             uint256,
542             uint256
543         )
544     {
545         uint256 rAmount = tAmount.mul(currentRate);
546         uint256 rFee = tFee.mul(currentRate);
547         uint256 rTeam = tTeam.mul(currentRate);
548         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
549  
550         return (rAmount, rTransferAmount, rFee);
551     }
552  
553     function _getRate() private view returns (uint256) {
554         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
555  
556         return rSupply.div(tSupply);
557     }
558  
559     function _getCurrentSupply() private view returns (uint256, uint256) {
560         uint256 rSupply = _rTotal;
561         uint256 tSupply = _tTotal;
562         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
563  
564         return (rSupply, tSupply);
565     }
566  
567     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
568         _redisFeeOnBuy = redisFeeOnBuy;
569         _redisFeeOnSell = redisFeeOnSell;
570         _taxFeeOnBuy = taxFeeOnBuy;
571         _taxFeeOnSell = taxFeeOnSell;
572         totalFees = _redisFeeOnBuy + _redisFeeOnSell + _taxFeeOnBuy + _taxFeeOnSell;
573         require(totalFees <= 15, "Must keep fees at 15% or less");
574     }
575  
576     //Set minimum tokens required to swap.
577     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
578         _swapTokensAtAmount = swapTokensAtAmount;
579     }
580  
581     //Set minimum tokens required to swap.
582     function toggleSwap(bool _swapEnabled) public onlyOwner {
583         swapEnabled = _swapEnabled;
584     }
585  
586  
587     //Set max buy amount 
588     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
589         _maxTxAmount = maxTxAmount;
590     }
591 
592     //Set max wallet amount 
593     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
594         _maxWalletSize = maxWalletSize;
595     }
596 
597     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
598         for(uint256 i = 0; i < accounts.length; i++) {
599             _isExcludedFromFee[accounts[i]] = excluded;
600         }
601     }
602 }