1 // SPDX-License-Identifier: Unlicensed
2 /*
3                            ...               ...........                                  
4                         ....          .........................                           
5                       .....       .................................                       
6                     ......     .......................................                    
7                    ......    ...........................................                  
8                  .......   ...............................................                
9                 ........ ........................................    .......              
10                ....................................................      ....             
11                ......................................................       ...           
12               .........................................................       ..          
13               ..........................          ......................       .          
14              .......................                 ....................       .         
15              .....................             ....... ....................      .        
16              ....................    .        .     .    ..................               
17              ...................      .     ..    ..      ..................              
18              ...................       ..        ..       ...................             
19              ...................         .      .         ...................             
20               ..................        .        .        ...................             
21               ..................      ..    ..    .       ...................             
22                ..................    .     .  .          ....................             
23         .       ..................  .......             .....................             
24          .       ...................                  .......................             
25          ..       ....................              .........................             
26           ..       .........................................................              
27            ...       .......................................................              
28             .....     .....................................................               
29               ......     ........................................ ........                
30                 ................................................  .......                 
31                  .............................................   .......                  
32                     ........................................    ......                    
33                        ..................................      .....                      
34                            ..........................         ....                        
35                                 ...............             ....                          
36                                                           ...        
37 
38  https://t.me/ZeroXTornado
39 
40  https://0xTornado.org
41 */
42 
43 pragma solidity 0.8.19;
44 
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49 }
50 
51 interface IERC20 {
52     function totalSupply() external view returns (uint256);
53 
54     function balanceOf(address account) external view returns (uint256);
55 
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(
70         address indexed owner,
71         address indexed spender,
72         uint256 value
73     );
74 }
75 
76 contract Ownable is Context {
77     address private _owner;
78     address private _previousOwner;
79     event OwnershipTransferred(
80         address indexed previousOwner,
81         address indexed newOwner
82     );
83 
84     constructor() {
85         address msgSender = _msgSender();
86         _owner = msgSender;
87         emit OwnershipTransferred(address(0), msgSender);
88     }
89 
90     function owner() public view returns (address) {
91         return _owner;
92     }
93 
94     modifier onlyOwner() {
95         require(_owner == _msgSender(), "Ownable: caller is not the owner");
96         _;
97     }
98 
99     function renounceOwnership() public virtual onlyOwner {
100         emit OwnershipTransferred(_owner, address(0));
101         _owner = address(0);
102     }
103 
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 
110 }
111 
112 library SafeMath {
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         require(c >= a, "SafeMath: addition overflow");
116         return c;
117     }
118 
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     function sub(
124         uint256 a,
125         uint256 b,
126         string memory errorMessage
127     ) internal pure returns (uint256) {
128         require(b <= a, errorMessage);
129         uint256 c = a - b;
130         return c;
131     }
132 
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         if (a == 0) {
135             return 0;
136         }
137         uint256 c = a * b;
138         require(c / a == b, "SafeMath: multiplication overflow");
139         return c;
140     }
141 
142     function div(uint256 a, uint256 b) internal pure returns (uint256) {
143         return div(a, b, "SafeMath: division by zero");
144     }
145 
146     function div(
147         uint256 a,
148         uint256 b,
149         string memory errorMessage
150     ) internal pure returns (uint256) {
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         return c;
154     }
155 }
156 
157 interface IUniswapV2Factory {
158     function createPair(address tokenA, address tokenB)
159         external
160         returns (address pair);
161 }
162 
163 interface IUniswapV2Router02 {
164     function swapExactTokensForETHSupportingFeeOnTransferTokens(
165         uint256 amountIn,
166         uint256 amountOutMin,
167         address[] calldata path,
168         address to,
169         uint256 deadline
170     ) external;
171 
172     function factory() external pure returns (address);
173 
174     function WETH() external pure returns (address);
175 
176     function addLiquidityETH(
177         address token,
178         uint256 amountTokenDesired,
179         uint256 amountTokenMin,
180         uint256 amountETHMin,
181         address to,
182         uint256 deadline
183     )
184         external
185         payable
186         returns (
187             uint256 amountToken,
188             uint256 amountETH,
189             uint256 liquidity
190         );
191 }
192 
193 contract ZeroXTornado is Context, IERC20, Ownable {
194 
195     using SafeMath for uint256;
196 
197     string private constant _name = "0xTornado";
198     string private constant _symbol = "0XT";
199     uint8 private constant _decimals = 9;
200 
201     mapping(address => uint256) private _rOwned;
202     mapping(address => uint256) private _tOwned;
203     mapping(address => mapping(address => uint256)) private _allowances;
204     mapping(address => bool) private _isExcludedFromFee;
205     uint256 private constant MAX = ~uint256(0);
206     uint256 private constant _tTotal = 100000000000 * 10**9;
207     uint256 private _rTotal = (MAX - (MAX % _tTotal));
208     uint256 private _tFeeTotal;
209     uint256 private _redisFeeOnBuy = 0;
210     uint256 private _taxFeeOnBuy = 15;
211     uint256 private _redisFeeOnSell = 0;
212     uint256 private _taxFeeOnSell = 30;
213 
214     //Original Fee
215     uint256 private _redisFee = _redisFeeOnSell;
216     uint256 private _taxFee = _taxFeeOnSell;
217 
218     uint256 private _previousredisFee = _redisFee;
219     uint256 private _previoustaxFee = _taxFee;
220 
221     mapping (address => uint256) public _buyMap;
222     address payable private _developmentAddress = payable(0x6aF7b96b0d10dc82179073a7fa6C5262D265d4c2);
223     address payable private _marketingAddress = payable(0x6aF7b96b0d10dc82179073a7fa6C5262D265d4c2);
224 
225 
226     IUniswapV2Router02 public uniswapV2Router;
227     address public uniswapV2Pair;
228 
229     bool private tradingOpen = true;
230     bool private inSwap = false;
231     bool private swapEnabled = true;
232 
233     uint256 public _maxTxAmount = 3000000000 * 10**9;
234     uint256 public _maxWalletSize = 3000000000 * 10**9;
235     uint256 public _swapTokensAtAmount = 1000000000 * 10**9;
236 
237     event MaxTxAmountUpdated(uint256 _maxTxAmount);
238     modifier lockTheSwap {
239         inSwap = true;
240         _;
241         inSwap = false;
242     }
243 
244     constructor() {
245 
246         _rOwned[_msgSender()] = _rTotal;
247 
248         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
249         uniswapV2Router = _uniswapV2Router;
250         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
251             .createPair(address(this), _uniswapV2Router.WETH());
252 
253         _isExcludedFromFee[owner()] = true;
254         _isExcludedFromFee[address(this)] = true;
255         _isExcludedFromFee[_developmentAddress] = true;
256         _isExcludedFromFee[_marketingAddress] = true;
257 
258         emit Transfer(address(0), _msgSender(), _tTotal);
259     }
260 
261     function name() public pure returns (string memory) {
262         return _name;
263     }
264 
265     function symbol() public pure returns (string memory) {
266         return _symbol;
267     }
268 
269     function decimals() public pure returns (uint8) {
270         return _decimals;
271     }
272 
273     function totalSupply() public pure override returns (uint256) {
274         return _tTotal;
275     }
276 
277     function balanceOf(address account) public view override returns (uint256) {
278         return tokenFromReflection(_rOwned[account]);
279     }
280 
281     function transfer(address recipient, uint256 amount)
282         public
283         override
284         returns (bool)
285     {
286         _transfer(_msgSender(), recipient, amount);
287         return true;
288     }
289 
290     function allowance(address owner, address spender)
291         public
292         view
293         override
294         returns (uint256)
295     {
296         return _allowances[owner][spender];
297     }
298 
299     function approve(address spender, uint256 amount)
300         public
301         override
302         returns (bool)
303     {
304         _approve(_msgSender(), spender, amount);
305         return true;
306     }
307 
308     function transferFrom(
309         address sender,
310         address recipient,
311         uint256 amount
312     ) public override returns (bool) {
313         _transfer(sender, recipient, amount);
314         _approve(
315             sender,
316             _msgSender(),
317             _allowances[sender][_msgSender()].sub(
318                 amount,
319                 "ERC20: transfer amount exceeds allowance"
320             )
321         );
322         return true;
323     }
324 
325     function tokenFromReflection(uint256 rAmount)
326         private
327         view
328         returns (uint256)
329     {
330         require(
331             rAmount <= _rTotal,
332             "Amount must be less than total reflections"
333         );
334         uint256 currentRate = _getRate();
335         return rAmount.div(currentRate);
336     }
337 
338     function removeAllFee() private {
339         if (_redisFee == 0 && _taxFee == 0) return;
340 
341         _previousredisFee = _redisFee;
342         _previoustaxFee = _taxFee;
343 
344         _redisFee = 0;
345         _taxFee = 0;
346     }
347 
348     function restoreAllFee() private {
349         _redisFee = _previousredisFee;
350         _taxFee = _previoustaxFee;
351     }
352 
353     function _approve(
354         address owner,
355         address spender,
356         uint256 amount
357     ) private {
358         require(owner != address(0), "ERC20: approve from the zero address");
359         require(spender != address(0), "ERC20: approve to the zero address");
360         _allowances[owner][spender] = amount;
361         emit Approval(owner, spender, amount);
362     }
363 
364     function _transfer(
365         address from,
366         address to,
367         uint256 amount
368     ) private {
369         require(from != address(0), "ERC20: transfer from the zero address");
370         require(to != address(0), "ERC20: transfer to the zero address");
371         require(amount > 0, "Transfer amount must be greater than zero");
372 
373         if (from != owner() && to != owner()) {
374 
375             //Trade start check
376             if (!tradingOpen) {
377                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
378             }
379 
380             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
381 
382             if(to != uniswapV2Pair) {
383                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
384             }
385 
386             uint256 contractTokenBalance = balanceOf(address(this));
387             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
388 
389             if(contractTokenBalance >= _maxTxAmount)
390             {
391                 contractTokenBalance = _maxTxAmount;
392             }
393 
394             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
395                 swapTokensForEth(contractTokenBalance);
396                 uint256 contractETHBalance = address(this).balance;
397                 if (contractETHBalance > 0) {
398                     sendETHToFee(address(this).balance);
399                 }
400             }
401         }
402 
403         bool takeFee = true;
404 
405         //Transfer Tokens
406         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
407             takeFee = false;
408         } else {
409 
410             //Set Fee for Buys
411             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
412                 _redisFee = _redisFeeOnBuy;
413                 _taxFee = _taxFeeOnBuy;
414             }
415 
416             //Set Fee for Sells
417             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
418                 _redisFee = _redisFeeOnSell;
419                 _taxFee = _taxFeeOnSell;
420             }
421 
422         }
423 
424         _tokenTransfer(from, to, amount, takeFee);
425     }
426 
427     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
428         address[] memory path = new address[](2);
429         path[0] = address(this);
430         path[1] = uniswapV2Router.WETH();
431         _approve(address(this), address(uniswapV2Router), tokenAmount);
432         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
433             tokenAmount,
434             0,
435             path,
436             address(this),
437             block.timestamp
438         );
439     }
440 
441     function sendETHToFee(uint256 amount) private {
442         _marketingAddress.transfer(amount);
443     }
444 
445     function setTrading(bool _tradingOpen) public onlyOwner {
446         tradingOpen = _tradingOpen;
447     }
448 
449     function manualswap() external {
450         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
451         uint256 contractBalance = balanceOf(address(this));
452         swapTokensForEth(contractBalance);
453     }
454 
455     function manualsend() external {
456         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
457         uint256 contractETHBalance = address(this).balance;
458         sendETHToFee(contractETHBalance);
459     }
460 
461     function _tokenTransfer(
462         address sender,
463         address recipient,
464         uint256 amount,
465         bool takeFee
466     ) private {
467         if (!takeFee) removeAllFee();
468         _transferStandard(sender, recipient, amount);
469         if (!takeFee) restoreAllFee();
470     }
471 
472     function _transferStandard(
473         address sender,
474         address recipient,
475         uint256 tAmount
476     ) private {
477         (
478             uint256 rAmount,
479             uint256 rTransferAmount,
480             uint256 rFee,
481             uint256 tTransferAmount,
482             uint256 tFee,
483             uint256 tTeam
484         ) = _getValues(tAmount);
485         _rOwned[sender] = _rOwned[sender].sub(rAmount);
486         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
487         _takeTeam(tTeam);
488         _reflectFee(rFee, tFee);
489         emit Transfer(sender, recipient, tTransferAmount);
490     }
491 
492     function _takeTeam(uint256 tTeam) private {
493         uint256 currentRate = _getRate();
494         uint256 rTeam = tTeam.mul(currentRate);
495         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
496     }
497 
498     function _reflectFee(uint256 rFee, uint256 tFee) private {
499         _rTotal = _rTotal.sub(rFee);
500         _tFeeTotal = _tFeeTotal.add(tFee);
501     }
502 
503     receive() external payable {}
504 
505     function _getValues(uint256 tAmount)
506         private
507         view
508         returns (
509             uint256,
510             uint256,
511             uint256,
512             uint256,
513             uint256,
514             uint256
515         )
516     {
517         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
518             _getTValues(tAmount, _redisFee, _taxFee);
519         uint256 currentRate = _getRate();
520         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
521             _getRValues(tAmount, tFee, tTeam, currentRate);
522         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
523     }
524 
525     function _getTValues(
526         uint256 tAmount,
527         uint256 redisFee,
528         uint256 taxFee
529     )
530         private
531         pure
532         returns (
533             uint256,
534             uint256,
535             uint256
536         )
537     {
538         uint256 tFee = tAmount.mul(redisFee).div(100);
539         uint256 tTeam = tAmount.mul(taxFee).div(100);
540         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
541         return (tTransferAmount, tFee, tTeam);
542     }
543 
544     function _getRValues(
545         uint256 tAmount,
546         uint256 tFee,
547         uint256 tTeam,
548         uint256 currentRate
549     )
550         private
551         pure
552         returns (
553             uint256,
554             uint256,
555             uint256
556         )
557     {
558         uint256 rAmount = tAmount.mul(currentRate);
559         uint256 rFee = tFee.mul(currentRate);
560         uint256 rTeam = tTeam.mul(currentRate);
561         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
562         return (rAmount, rTransferAmount, rFee);
563     }
564 
565     function _getRate() private view returns (uint256) {
566         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
567         return rSupply.div(tSupply);
568     }
569 
570     function _getCurrentSupply() private view returns (uint256, uint256) {
571         uint256 rSupply = _rTotal;
572         uint256 tSupply = _tTotal;
573         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
574         return (rSupply, tSupply);
575     }
576 
577     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
578         _redisFeeOnBuy = redisFeeOnBuy;
579         _redisFeeOnSell = redisFeeOnSell;
580         _taxFeeOnBuy = taxFeeOnBuy;
581         _taxFeeOnSell = taxFeeOnSell;
582     }
583 
584     //Set minimum tokens required to swap.
585     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
586         _swapTokensAtAmount = swapTokensAtAmount;
587     }
588 
589     //Set minimum tokens required to swap.
590     function toggleSwap(bool _swapEnabled) public onlyOwner {
591         swapEnabled = _swapEnabled;
592     }
593 
594     //Set maximum transaction
595     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
596         _maxTxAmount = maxTxAmount;
597     }
598 
599     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
600         _maxWalletSize = maxWalletSize;
601     }
602 
603     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
604         for(uint256 i = 0; i < accounts.length; i++) {
605             _isExcludedFromFee[accounts[i]] = excluded;
606         }
607     }
608 
609 }