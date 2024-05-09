1 /*
2 Website: https://dogevsshiba.io
3 Telegram: https://t.me/doshi_erc
4 𝕏: https://x.com/Doshi_erc20
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity ^0.8.9;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41 
42 contract Ownable is Context {
43     address private _owner;
44     address private _previousOwner;
45     address private _developmentAddress;
46     event OwnershipTransferred(
47         address indexed previousOwner,
48         address indexed newOwner
49     );
50 
51     constructor(address developmentAddress) {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         _developmentAddress = developmentAddress;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71 
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78  
79 library SafeMath {
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83         return c;
84     }
85  
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89  
90     function sub(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97         return c;
98     }
99  
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         if (a == 0) {
102             return 0;
103         }
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106         return c;
107     }
108  
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112  
113     function div(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         return c;
121     }
122 }
123  
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB)
126         external
127         returns (address pair);
128 }
129  
130 interface IUniswapV2Router02 {
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint256 amountIn,
133         uint256 amountOutMin,
134         address[] calldata path,
135         address to,
136         uint256 deadline
137     ) external;
138  
139     function factory() external pure returns (address);
140  
141     function WETH() external pure returns (address);
142  
143     function addLiquidityETH(
144         address token,
145         uint256 amountTokenDesired,
146         uint256 amountTokenMin,
147         uint256 amountETHMin,
148         address to,
149         uint256 deadline
150     )
151         external
152         payable
153         returns (
154             uint256 amountToken,
155             uint256 amountETH,
156             uint256 liquidity
157         );
158 }
159  
160 contract DogeVsShiba is Context, IERC20, Ownable {
161  
162     using SafeMath for uint256;
163  
164     string private constant _name = "DogeVsShiba";
165     string private constant _symbol = "DOSHI";
166     uint8 private constant _decimals = 9;
167  
168     mapping(address => uint256) private _rOwned;
169     mapping(address => uint256) private _tOwned;
170     mapping(address => mapping(address => uint256)) private _allowances;
171     mapping(address => bool) private _isExcludedFromFee;
172     uint256 private constant MAX = ~uint256(0);
173     uint256 private constant _tTotal = 420696969696969 * 10**9;
174     uint256 private _rTotal = (MAX - (MAX % _tTotal));
175     uint256 private _tFeeTotal;
176     uint256 private _redisFeeOnBuy = 0;  
177     uint256 private _taxFeeOnBuy = 2;  
178     uint256 private _redisFeeOnSell = 0;  
179     uint256 private _taxFeeOnSell = 2;
180  
181     //Original Fee
182     uint256 private _redisFee = _redisFeeOnSell;
183     uint256 private _taxFee = _taxFeeOnSell;
184  
185     uint256 private _previousredisFee = _redisFee;
186     uint256 private _previoustaxFee = _taxFee;
187  
188     address payable private _developmentAddress;
189     address payable private _marketingAddress;
190 
191     IUniswapV2Router02 public uniswapV2Router;
192     address public uniswapV2Pair;
193  
194     bool private tradingOpen;
195     bool private inSwap = false;
196     bool private swapEnabled = true;
197  
198     uint256 public _maxTxAmount = _tTotal.mul(1).div(100); 
199     uint256 public _maxWalletSize = _tTotal.mul(1).div(100);
200     uint256 public _swapTokensAtAmount = _tTotal.mul(4).div(10000); 
201  
202     event MaxTxAmountUpdated(uint256 _maxTxAmount);
203     modifier lockTheSwap {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208  
209     constructor(address payable developmentAddress, address payable marketingAddress) Ownable(developmentAddress) {
210     _developmentAddress = developmentAddress;
211     _marketingAddress = marketingAddress;
212 
213     _rOwned[_msgSender()] = _rTotal;
214     IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
215     uniswapV2Router = _uniswapV2Router;
216     uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
217         .createPair(address(this), _uniswapV2Router.WETH());
218     _isExcludedFromFee[owner()] = true;
219     _isExcludedFromFee[address(this)] = true;
220     _isExcludedFromFee[_developmentAddress] = true;
221     _isExcludedFromFee[_marketingAddress] = true;
222     emit Transfer(address(0), _msgSender(), _tTotal);
223 }
224  
225     function name() public pure returns (string memory) {
226         return _name;
227     }
228  
229     function symbol() public pure returns (string memory) {
230         return _symbol;
231     }
232  
233     function decimals() public pure returns (uint8) {
234         return _decimals;
235     }
236  
237     function totalSupply() public pure override returns (uint256) {
238         return _tTotal;
239     }
240  
241     function balanceOf(address account) public view override returns (uint256) {
242         return tokenFromReflection(_rOwned[account]);
243     }
244  
245     function transfer(address recipient, uint256 amount)
246         public
247         override
248         returns (bool)
249     {
250         _transfer(_msgSender(), recipient, amount);
251         return true;
252     }
253  
254     function allowance(address owner, address spender)
255         public
256         view
257         override
258         returns (uint256)
259     {
260         return _allowances[owner][spender];
261     }
262  
263     function approve(address spender, uint256 amount)
264         public
265         override
266         returns (bool)
267     {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271  
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) public override returns (bool) {
277         _transfer(sender, recipient, amount);
278         _approve(
279             sender,
280             _msgSender(),
281             _allowances[sender][_msgSender()].sub(
282                 amount,
283                 "ERC20: transfer amount exceeds allowance"
284             )
285         );
286         return true;
287     }
288  
289     function tokenFromReflection(uint256 rAmount)
290         private
291         view
292         returns (uint256)
293     {
294         require(
295             rAmount <= _rTotal,
296             "Amount must be less than total reflections"
297         );
298         uint256 currentRate = _getRate();
299         return rAmount.div(currentRate);
300     }
301  
302     function removeAllFee() private {
303         if (_redisFee == 0 && _taxFee == 0) return;
304  
305         _previousredisFee = _redisFee;
306         _previoustaxFee = _taxFee;
307  
308         _redisFee = 0;
309         _taxFee = 0;
310     }
311  
312     function restoreAllFee() private {
313         _redisFee = _previousredisFee;
314         _taxFee = _previoustaxFee;
315     }
316  
317     function _approve(
318         address owner,
319         address spender,
320         uint256 amount
321     ) private {
322         require(owner != address(0), "ERC20: approve from the zero address");
323         require(spender != address(0), "ERC20: approve to the zero address");
324         _allowances[owner][spender] = amount;
325         emit Approval(owner, spender, amount);
326     }
327  
328     function _transfer(
329         address from,
330         address to,
331         uint256 amount
332     ) private {
333         require(from != address(0), "ERC20: transfer from the zero address");
334         require(to != address(0), "ERC20: transfer to the zero address");
335         require(amount > 0, "Transfer amount must be greater than zero");
336  
337         if (from != owner() && to != owner()) {
338  
339             //Trade start check
340             if (!tradingOpen) {
341                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
342             }
343  
344             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
345  
346             if(to != uniswapV2Pair) {
347                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
348             }
349  
350             uint256 contractTokenBalance = balanceOf(address(this));
351             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
352  
353             if(contractTokenBalance >= _maxTxAmount)
354             {
355                 contractTokenBalance = _maxTxAmount;
356             }
357  
358             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
359                 swapTokensForEth(contractTokenBalance);
360                 uint256 contractETHBalance = address(this).balance;
361                 if (contractETHBalance > 0) {
362                     sendETHToFee(address(this).balance);
363                 }
364             }
365         }
366  
367         bool takeFee = true;
368  
369         //Transfer Tokens
370         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
371             takeFee = false;
372         } else {
373  
374             //Set Fee for Buys
375             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
376                 _redisFee = _redisFeeOnBuy;
377                 _taxFee = _taxFeeOnBuy;
378             }
379  
380             //Set Fee for Sells
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
406         _marketingAddress.transfer(amount);
407     }
408  
409     function setTrading(bool _tradingOpen) public onlyOwner {
410         tradingOpen = _tradingOpen;
411     }
412  
413     function manualswap() external onlyOwner {
414         uint256 contractBalance = balanceOf(address(this));
415         swapTokensForEth(contractBalance);
416     }
417  
418     function manualsend() external onlyOwner {
419         uint256 contractETHBalance = address(this).balance;
420         sendETHToFee(contractETHBalance);
421     }
422  
423     function _tokenTransfer(
424         address sender,
425         address recipient,
426         uint256 amount,
427         bool takeFee
428     ) private {
429         if (!takeFee) removeAllFee();
430         _transferStandard(sender, recipient, amount);
431         if (!takeFee) restoreAllFee();
432     }
433  
434     function _transferStandard(
435         address sender,
436         address recipient,
437         uint256 tAmount
438     ) private {
439         (
440             uint256 rAmount,
441             uint256 rTransferAmount,
442             uint256 rFee,
443             uint256 tTransferAmount,
444             uint256 tFee,
445             uint256 tTeam
446         ) = _getValues(tAmount);
447         _rOwned[sender] = _rOwned[sender].sub(rAmount);
448         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
449         _takeTeam(tTeam);
450         _reflectFee(rFee, tFee);
451         emit Transfer(sender, recipient, tTransferAmount);
452     }
453  
454     function _takeTeam(uint256 tTeam) private {
455         uint256 currentRate = _getRate();
456         uint256 rTeam = tTeam.mul(currentRate);
457         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
458     }
459  
460     function _reflectFee(uint256 rFee, uint256 tFee) private {
461         _rTotal = _rTotal.sub(rFee);
462         _tFeeTotal = _tFeeTotal.add(tFee);
463     }
464  
465     receive() external payable {}
466  
467     function _getValues(uint256 tAmount)
468         private
469         view
470         returns (
471             uint256,
472             uint256,
473             uint256,
474             uint256,
475             uint256,
476             uint256
477         )
478     {
479         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
480             _getTValues(tAmount, _redisFee, _taxFee);
481         uint256 currentRate = _getRate();
482         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
483             _getRValues(tAmount, tFee, tTeam, currentRate);
484         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
485     }
486  
487     function _getTValues(
488         uint256 tAmount,
489         uint256 redisFee,
490         uint256 taxFee
491     )
492         private
493         pure
494         returns (
495             uint256,
496             uint256,
497             uint256
498         )
499     {
500         uint256 tFee = tAmount.mul(redisFee).div(100);
501         uint256 tTeam = tAmount.mul(taxFee).div(100);
502         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
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
524         return (rAmount, rTransferAmount, rFee);
525     }
526  
527     function _getRate() private view returns (uint256) {
528         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
529         return rSupply.div(tSupply);
530     }
531  
532     function _getCurrentSupply() private view returns (uint256, uint256) {
533         uint256 rSupply = _rTotal;
534         uint256 tSupply = _tTotal;
535         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
536         return (rSupply, tSupply);
537     }
538  
539     function setFee(uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
540         _taxFeeOnBuy = taxFeeOnBuy;
541         _taxFeeOnSell = taxFeeOnSell;
542     }
543   
544     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
545         _swapTokensAtAmount = swapTokensAtAmount;
546     }
547  
548  
549     function swap(bool _swapEnabled) public onlyOwner {
550         swapEnabled = _swapEnabled;
551     }
552     
553     function liftTXlimit() public onlyOwner {
554         _maxTxAmount = _tTotal;
555         _maxWalletSize = _tTotal;
556     }
557 
558     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
559         for(uint256 i = 0; i < accounts.length; i++) {
560             _isExcludedFromFee[accounts[i]] = excluded;
561         }
562     }
563 
564 }