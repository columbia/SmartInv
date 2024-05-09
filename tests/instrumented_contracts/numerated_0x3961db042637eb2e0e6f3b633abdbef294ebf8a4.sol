1 /**
2 Shibereum - Supporting the Shiba Inu Eco-system SHIBEREUM IS A DECENTRALISED MARKETPLACE ON THE ETHEREUM NETWORK, BRINGING VALUE TO THE SHIBA ECO-SYSTEM, AND WITH A GOAL TO BECOME THE AMAZON OF WEB3!
3 
4 Telegram: https://t.me/ShibereumToken
5 
6 Website: https://www.shibereumproject.com/
7 
8 Twitter: https://twitter.com/Shibereum
9 
10 */
11 
12 // SPDX-License-Identifier: unlicense
13 
14 pragma solidity ^0.8.7;
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
135     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
136         uint amountIn,
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external;
142  
143     function factory() external pure returns (address);
144 }
145  
146 contract Shibereum is Context, IERC20, Ownable {
147  
148     using SafeMath for uint256;
149  
150     string private constant _name = "Shibereum";//
151     string private constant _symbol = "SHIBEREUM";//  
152     uint8 private constant _decimals = 9;
153  
154     mapping(address => uint256) private _rOwned;
155     mapping(address => uint256) private _tOwned;
156     mapping(address => mapping(address => uint256)) private _allowances;
157     mapping(address => bool) private _isExcludedFromFee;
158     uint256 private constant MAX = ~uint256(0);
159     uint256 private constant _tTotal = 1_000_000_000_000 * 10**9;
160     uint256 private _rTotal = (MAX - (MAX % _tTotal));
161     uint256 private _tFeeTotal;
162     uint256 public launchBlock;
163  
164     //Buy Fee
165     uint256 private _redisFeeOnBuy = 0;//
166     uint256 private _taxFeeOnBuy = 5;//
167  
168     //Sell Fee
169     uint256 private _redisFeeOnSell = 0;//
170     uint256 private _taxFeeOnSell = 5;//
171  
172     //Original Fee
173     uint256 private _redisFee = _redisFeeOnSell;
174     uint256 private _taxFee = _taxFeeOnSell;
175  
176     uint256 private _previousredisFee = _redisFee;
177     uint256 private _previoustaxFee = _taxFee;
178  
179     mapping(address => bool) public bots;
180     mapping(address => uint256) private cooldown;
181  
182     address private constant _developmentAddress = 0x8104CA37394a2329bc78d63B4084Ef686cB343CE;//
183     address private constant _marketingAddress = 0x8104CA37394a2329bc78d63B4084Ef686cB343CE;//
184  
185     IUniswapV2Router02 immutable public uniswapV2Router;
186     address immutable public uniswapV2Pair;
187     address constant public USDC_ADDRESS = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;    
188     IERC20 immutable USDC = IERC20(USDC_ADDRESS);
189       
190     bool private tradingOpen;
191     bool private inSwap = false;
192     bool private swapEnabled = true;
193  
194     uint256 public _maxTxAmount = 20_000_000_000 * 10**9; //
195     uint256 public _maxWalletSize = 20_000_000_000 * 10**9; //
196     uint256 public _swapTokensAtAmount = 1_000_000_000 * 10**9; //
197  
198     event MaxTxAmountUpdated(uint256 _maxTxAmount);
199     modifier lockTheSwap {
200         inSwap = true;
201         _;
202         inSwap = false;
203     }
204  
205     constructor() {
206  
207         _rOwned[_msgSender()] = _rTotal;
208  
209         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
210         uniswapV2Router = _uniswapV2Router;
211         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
212             .createPair(address(this), USDC_ADDRESS);
213  
214         _isExcludedFromFee[owner()] = true;
215         _isExcludedFromFee[address(this)] = true;
216         _isExcludedFromFee[_developmentAddress] = true;
217         _isExcludedFromFee[_marketingAddress] = true;
218   
219         emit Transfer(address(0), _msgSender(), _tTotal);
220     }
221  
222     function name() public pure returns (string memory) {
223         return _name;
224     }
225  
226     function symbol() public pure returns (string memory) {
227         return _symbol;
228     }
229  
230     function decimals() public pure returns (uint8) {
231         return _decimals;
232     }
233  
234     function totalSupply() public pure override returns (uint256) {
235         return _tTotal;
236     }
237  
238     function balanceOf(address account) public view override returns (uint256) {
239         return tokenFromReflection(_rOwned[account]);
240     }
241  
242     function transfer(address recipient, uint256 amount)
243         public
244         override
245         returns (bool)
246     {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250  
251     function allowance(address owner, address spender)
252         public
253         view
254         override
255         returns (uint256)
256     {
257         return _allowances[owner][spender];
258     }
259  
260     function approve(address spender, uint256 amount)
261         public
262         override
263         returns (bool)
264     {
265         _approve(_msgSender(), spender, amount);
266         return true;
267     }
268  
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) public override returns (bool) {
274         _transfer(sender, recipient, amount);
275         _approve(
276             sender,
277             _msgSender(),
278             _allowances[sender][_msgSender()].sub(
279                 amount,
280                 "ERC20: transfer amount exceeds allowance"
281             )
282         );
283         return true;
284     }
285  
286     function tokenFromReflection(uint256 rAmount)
287         private
288         view
289         returns (uint256)
290     {
291         require(
292             rAmount <= _rTotal,
293             "Amount must be less than total reflections"
294         );
295         uint256 currentRate = _getRate();
296         return rAmount.div(currentRate);
297     }
298  
299     function removeAllFee() private {
300         if (_redisFee == 0 && _taxFee == 0) return;
301  
302         _previousredisFee = _redisFee;
303         _previoustaxFee = _taxFee;
304  
305         _redisFee = 0;
306         _taxFee = 0;
307     }
308  
309     function restoreAllFee() private {
310         _redisFee = _previousredisFee;
311         _taxFee = _previoustaxFee;
312     }
313  
314     function _approve(
315         address owner,
316         address spender,
317         uint256 amount
318     ) private {
319         require(owner != address(0), "ERC20: approve from the zero address");
320         require(spender != address(0), "ERC20: approve to the zero address");
321         _allowances[owner][spender] = amount;
322         emit Approval(owner, spender, amount);
323     }
324  
325     function _transfer(
326         address from,
327         address to,
328         uint256 amount
329     ) private {
330         require(from != address(0), "ERC20: transfer from the zero address");
331         require(to != address(0), "ERC20: transfer to the zero address");
332         require(amount > 0, "Transfer amount must be greater than zero");
333 
334         if(inSwap){
335             return _tokenTransfer(from, to, amount, false);
336         }
337  
338         if (from != _developmentAddress && to != _developmentAddress) {
339  
340             //Trade start check
341             require(tradingOpen, "TOKEN: This account cannot send tokens until trading is enabled");
342             
343             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
344             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
345  
346             if(block.number <= launchBlock + 0 && from == uniswapV2Pair && 
347             to != address(uniswapV2Router) && to != address(this) && to != uniswapV2Pair){   
348                 bots[to] = true;
349             } 
350  
351             if(to != uniswapV2Pair) {
352                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
353             }
354  
355             uint256 contractTokenBalance = balanceOf(address(this));
356             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
357               
358             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled 
359             && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
360                 if(contractTokenBalance >= _maxTxAmount) {
361                     contractTokenBalance = _maxTxAmount;
362                 }
363                 swapTokensForUSDC(contractTokenBalance);
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
385         }
386 
387         _tokenTransfer(from, to, amount, takeFee);
388     }
389  
390     function swapTokensForUSDC(uint256 tokenAmount) private lockTheSwap {
391         address[] memory path = new address[](2);
392         path[0] = address(this);
393         path[1] = USDC_ADDRESS;
394 
395         _approve(address(this), address(uniswapV2Router), tokenAmount);
396         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
397             (tokenAmount.div(2)),
398             0,
399             path,
400             _marketingAddress,
401             block.timestamp
402         );
403 
404         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
405             (tokenAmount.div(2)),
406             0,
407             path,
408             _developmentAddress,
409             block.timestamp
410         );
411 
412     }
413      
414     function setTrading(bool _tradingOpen) public onlyOwner {
415         tradingOpen = _tradingOpen;
416         launchBlock = block.number;
417     }
418  
419     function manualswap() external {
420         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
421         uint256 contractTokenBalance = balanceOf(address(this));
422         swapTokensForUSDC(contractTokenBalance);
423     }
424 
425     function blockBots(address[] memory bots_) public onlyOwner {
426         for (uint256 i = 0; i < bots_.length; i++) {
427             bots[bots_[i]] = true;
428         }
429     }
430  
431     function unblockBot(address notbot) public onlyOwner {
432         bots[notbot] = false;
433     }
434  
435     function _tokenTransfer(
436         address sender,
437         address recipient,
438         uint256 amount,
439         bool takeFee
440     ) private {
441         if (!takeFee) removeAllFee();
442         _transferStandard(sender, recipient, amount);
443         if (!takeFee) restoreAllFee();
444     }
445  
446     function _transferStandard(
447         address sender,
448         address recipient,
449         uint256 tAmount
450     ) private {
451         (
452             uint256 rAmount,
453             uint256 rTransferAmount,
454             uint256 rFee,
455             uint256 tTransferAmount,
456             uint256 tFee,
457             uint256 tTeam
458         ) = _getValues(tAmount);
459         _rOwned[sender] = _rOwned[sender].sub(rAmount);
460         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
461         _takeTeam(tTeam);
462         _reflectFee(rFee, tFee);
463         emit Transfer(sender, recipient, tTransferAmount);
464     }
465  
466     function _takeTeam(uint256 tTeam) private {
467         uint256 currentRate = _getRate();
468         uint256 rTeam = tTeam.mul(currentRate);
469         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
470     }
471  
472     function _reflectFee(uint256 rFee, uint256 tFee) private {
473         _rTotal = _rTotal.sub(rFee);
474         _tFeeTotal = _tFeeTotal.add(tFee);
475     }
476  
477     receive() external payable {}
478  
479     function _getValues(uint256 tAmount)
480         private
481         view
482         returns (
483             uint256,
484             uint256,
485             uint256,
486             uint256,
487             uint256,
488             uint256
489         )
490     {
491         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
492             _getTValues(tAmount, _redisFee, _taxFee);
493         uint256 currentRate = _getRate();
494         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
495             _getRValues(tAmount, tFee, tTeam, currentRate);
496  
497         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
498     }
499  
500     function _getTValues(
501         uint256 tAmount,
502         uint256 redisFee,
503         uint256 taxFee
504     )
505         private
506         pure
507         returns (
508             uint256,
509             uint256,
510             uint256
511         )
512     {
513         uint256 tFee = tAmount.mul(redisFee).div(100);
514         uint256 tTeam = tAmount.mul(taxFee).div(100);
515         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
516  
517         return (tTransferAmount, tFee, tTeam);
518     }
519  
520     function _getRValues(
521         uint256 tAmount,
522         uint256 tFee,
523         uint256 tTeam,
524         uint256 currentRate
525     )
526         private
527         pure
528         returns (
529             uint256,
530             uint256,
531             uint256
532         )
533     {
534         uint256 rAmount = tAmount.mul(currentRate);
535         uint256 rFee = tFee.mul(currentRate);
536         uint256 rTeam = tTeam.mul(currentRate);
537         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
538  
539         return (rAmount, rTransferAmount, rFee); 
540     }
541  
542     function _getRate() private view returns (uint256) {
543         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
544  
545         return rSupply.div(tSupply);
546     }
547  
548     function _getCurrentSupply() private view returns (uint256, uint256) {
549         uint256 rSupply = _rTotal;
550         uint256 tSupply = _tTotal;
551         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
552  
553         return (rSupply, tSupply);
554     }
555  
556     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
557         _redisFeeOnBuy = redisFeeOnBuy;
558         _redisFeeOnSell = redisFeeOnSell;
559  
560         _taxFeeOnBuy = taxFeeOnBuy;
561         _taxFeeOnSell = taxFeeOnSell;
562     }
563  
564     //Set minimum tokens required to swap.
565     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
566         _swapTokensAtAmount = swapTokensAtAmount;
567     }
568  
569     //Set minimum tokens required to swap.
570     function toggleSwap(bool _swapEnabled) public onlyOwner {
571         swapEnabled = _swapEnabled;
572     }
573  
574     //Set maximum transaction
575     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
576         _maxTxAmount = maxTxAmount;
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
588 }