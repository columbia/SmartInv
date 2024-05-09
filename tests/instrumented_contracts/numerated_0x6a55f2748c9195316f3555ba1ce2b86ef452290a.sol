1 /*
2 
3 #Twitter - www.twitter.com/SmartBotErc
4 
5 #Telegram - https://t.me/smartboterc
6 
7 #Telegram SmartBot - https://t.me/smartercbot
8 
9 #Website - www.SmartBotErc.xyz
10 
11 */
12 // SPDX-License-Identifier: Unlicensed
13 pragma solidity ^0.8.18;
14  
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 contract Ownable is Context {
39     address private _owner;
40     address private _previousOwner;
41     event OwnershipTransferred(
42         address indexed previousOwner,
43         address indexed newOwner
44     );
45     constructor() {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50     function owner() public view returns (address) {
51         return _owner;
52     }
53     modifier onlyOwner() {
54         require(_owner == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57     function renounceOwnership() public virtual onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61  
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 library SafeMath {
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a, "SafeMath: addition overflow");
72         return c;
73     }
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         return sub(a, b, "SafeMath: subtraction overflow");
76     }
77     function sub(
78         uint256 a,
79         uint256 b,
80         string memory errorMessage
81     ) internal pure returns (uint256) {
82         require(b <= a, errorMessage);
83         uint256 c = a - b;
84         return c;
85     }
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         if (a == 0) {
88             return 0;
89         }
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92         return c;
93     }
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97     function div(
98         uint256 a,
99         uint256 b,
100         string memory errorMessage
101     ) internal pure returns (uint256) {
102         require(b > 0, errorMessage);
103         uint256 c = a / b;
104         return c;
105     }
106 }
107 interface IUniswapV2Factory {
108     function createPair(address tokenA, address tokenB)
109         external
110         returns (address pair);
111 }
112 interface IUniswapV2Router02 {
113     function swapExactTokensForETHSupportingFeeOnTransferTokens(
114         uint256 amountIn,
115         uint256 amountOutMin,
116         address[] calldata path,
117         address to,
118         uint256 deadline
119     ) external;
120     function factory() external pure returns (address);
121     function WETH() external pure returns (address);
122     function addLiquidityETH(
123         address token,
124         uint256 amountTokenDesired,
125         uint256 amountTokenMin,
126         uint256 amountETHMin,
127         address to,
128         uint256 deadline
129     )
130         external
131         payable
132         returns (
133             uint256 amountToken,
134             uint256 amountETH,
135             uint256 liquidity
136         );
137 }
138 contract SmartBot is Context, IERC20, Ownable {
139     using SafeMath for uint256;
140     string private constant _name = "SmartBot";
141     string private constant _symbol = "$Smart";
142     uint8 private constant _decimals = 9;
143     mapping(address => uint256) private _rOwned;
144     mapping(address => uint256) private _tOwned;
145     mapping(address => mapping(address => uint256)) private _allowances;
146     mapping(address => bool) private _isExcludedFromFee;
147     uint256 private constant MAX = ~uint256(0);
148     uint256 private constant _tTotal = 10000000000000 * 10**9;
149     uint256 private _rTotal = (MAX - (MAX % _tTotal));
150     uint256 private _tFeeTotal;
151     uint256 private _redisFeeOnBuy = 0;  
152     uint256 private _taxFeeOnBuy = 30;  
153     uint256 private _redisFeeOnSell = 0;  
154     uint256 private _taxFeeOnSell = 50;
155  
156     //Original Fee
157     uint256 private _redisFee = _redisFeeOnSell;
158     uint256 private _taxFee = _taxFeeOnSell;
159  
160     uint256 private _previousredisFee = _redisFee;
161     uint256 private _previoustaxFee = _taxFee;
162  
163     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
164     address payable private _developmentAddress = payable(0x339C789cfe4A239054efc2d57D7f0a190E533eB9); 
165     address payable private _marketingAddress = payable(0x339C789cfe4A239054efc2d57D7f0a190E533eB9);
166  
167     IUniswapV2Router02 public uniswapV2Router;
168     address public uniswapV2Pair;
169  
170     bool private tradingOpen;
171     bool private inSwap = false;
172     bool private swapEnabled = true;
173  
174     uint256 public _maxTxAmount = 100000000000 * 10**9; 
175     uint256 public _maxWalletSize = 100000000000 * 10**9; 
176     uint256 public _swapTokensAtAmount = 50000000000 * 10**9;
177  
178     event MaxTxAmountUpdated(uint256 _maxTxAmount);
179     modifier lockTheSwap {
180         inSwap = true;
181         _;
182         inSwap = false;
183     }
184  
185     constructor() {
186  
187         _rOwned[_msgSender()] = _rTotal;
188  
189 
190         _isExcludedFromFee[owner()] = true;
191         _isExcludedFromFee[address(this)] = true;
192         _isExcludedFromFee[_developmentAddress] = true;
193         _isExcludedFromFee[_marketingAddress] = true;
194  
195         emit Transfer(address(0), _msgSender(), _tTotal);
196     }
197     function name() public pure returns (string memory) {
198         return _name;
199     }
200  
201     function symbol() public pure returns (string memory) {
202         return _symbol;
203     }
204  
205     function decimals() public pure returns (uint8) {
206         return _decimals;
207     }
208  
209     function totalSupply() public pure override returns (uint256) {
210         return _tTotal;
211     }
212  
213     function balanceOf(address account) public view override returns (uint256) {
214         return tokenFromReflection(_rOwned[account]);
215     }
216  
217     function transfer(address recipient, uint256 amount)
218         public
219         override
220         returns (bool)
221     {
222         _transfer(_msgSender(), recipient, amount);
223         return true;
224     }
225  
226     function allowance(address owner, address spender)
227         public
228         view
229         override
230         returns (uint256)
231     {
232         return _allowances[owner][spender];
233     }
234  
235     function approve(address spender, uint256 amount)
236         public
237         override
238         returns (bool)
239     {
240         _approve(_msgSender(), spender, amount);
241         return true;
242     }
243  
244     function transferFrom(
245         address sender,
246         address recipient,
247         uint256 amount
248     ) public override returns (bool) {
249         _transfer(sender, recipient, amount);
250         _approve(
251             sender,
252             _msgSender(),
253             _allowances[sender][_msgSender()].sub(
254                 amount,
255                 "ERC20: transfer amount exceeds allowance"
256             )
257         );
258         return true;
259     }
260  
261     function tokenFromReflection(uint256 rAmount)
262         private
263         view
264         returns (uint256)
265     {
266         require(
267             rAmount <= _rTotal,
268             "Amount must be less than total reflections"
269         );
270         uint256 currentRate = _getRate();
271         return rAmount.div(currentRate);
272     }
273  
274     function removeAllFee() private {
275         if (_redisFee == 0 && _taxFee == 0) return;
276  
277         _previousredisFee = _redisFee;
278         _previoustaxFee = _taxFee;
279  
280         _redisFee = 0;
281         _taxFee = 0;
282     }
283  
284     function restoreAllFee() private {
285         _redisFee = _previousredisFee;
286         _taxFee = _previoustaxFee;
287     }
288  
289     function _approve(
290         address owner,
291         address spender,
292         uint256 amount
293     ) private {
294         require(owner != address(0), "ERC20: approve from the zero address");
295         require(spender != address(0), "ERC20: approve to the zero address");
296         _allowances[owner][spender] = amount;
297         emit Approval(owner, spender, amount);
298     }
299  
300     function _transfer(
301         address from,
302         address to,
303         uint256 amount
304     ) private {
305         require(from != address(0), "ERC20: transfer from the zero address");
306         require(to != address(0), "ERC20: transfer to the zero address");
307         require(amount > 0, "Transfer amount must be greater than zero");
308  
309         if (from != owner() && to != owner()) {
310  
311             //Trade start check
312             if (!tradingOpen) {
313                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
314             }
315  
316             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
317             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
318  
319             if(to != uniswapV2Pair) {
320                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
321             }
322  
323             uint256 contractTokenBalance = balanceOf(address(this));
324             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
325  
326             if(contractTokenBalance >= _swapTokensAtAmount)
327             {
328                 contractTokenBalance = _swapTokensAtAmount;
329             }
330  
331             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
332                 swapTokensForEth(contractTokenBalance);
333                 uint256 contractETHBalance = address(this).balance;
334                 if (contractETHBalance > 0) {
335                     sendETHToFee(address(this).balance);
336                 }
337             }
338         }
339  
340         bool takeFee = true;
341  
342         //Transfer Tokens
343         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
344             takeFee = false;
345         } else {
346  
347             //Set Fee for Buys
348             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
349                 _redisFee = _redisFeeOnBuy;
350                 _taxFee = _taxFeeOnBuy;
351             }
352  
353             //Set Fee for Sells
354             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
355                 _redisFee = _redisFeeOnSell;
356                 _taxFee = _taxFeeOnSell;
357             }
358  
359         }
360  
361         _tokenTransfer(from, to, amount, takeFee);
362     }
363  
364     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
365         address[] memory path = new address[](2);
366         path[0] = address(this);
367         path[1] = uniswapV2Router.WETH();
368         _approve(address(this), address(uniswapV2Router), tokenAmount);
369         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
370             tokenAmount,
371             0,
372             path,
373             address(this),
374             block.timestamp
375         );
376     }
377  
378     function sendETHToFee(uint256 amount) private {
379         _marketingAddress.transfer(amount);
380     }
381     
382     function enableTrading(bool _tradingOpen) public onlyOwner {
383         tradingOpen = _tradingOpen;
384     }
385     function _setPairAddress(address _pairaddress,address _router) external  onlyOwner {
386         uniswapV2Pair = _pairaddress;
387         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
388         uniswapV2Router = _uniswapV2Router;
389     }
390     function manualswap() external {
391         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
392         uint256 contractBalance = balanceOf(address(this));
393         swapTokensForEth(contractBalance);
394     }
395  
396     function manualsend() external {
397         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
398         uint256 contractETHBalance = address(this).balance;
399         sendETHToFee(contractETHBalance);
400     }
401  
402     function addBots(address[] memory bots_,bool _status) public onlyOwner {
403         for (uint256 i = 0; i < bots_.length; i++) {
404             bots[bots_[i]] = _status;
405         }
406     }
407  
408     function removeBot(address notbot) public onlyOwner {
409         bots[notbot] = false;
410     }
411  
412     function _tokenTransfer(
413         address sender,
414         address recipient,
415         uint256 amount,
416         bool takeFee
417     ) private {
418         if (!takeFee) removeAllFee();
419         _transferStandard(sender, recipient, amount);
420         if (!takeFee) restoreAllFee();
421     }
422  
423     function _transferStandard(
424         address sender,
425         address recipient,
426         uint256 tAmount
427     ) private {
428         (
429             uint256 rAmount,
430             uint256 rTransferAmount,
431             uint256 rFee,
432             uint256 tTransferAmount,
433             uint256 tFee,
434             uint256 tTeam
435         ) = _getValues(tAmount);
436         _rOwned[sender] = _rOwned[sender].sub(rAmount);
437         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
438         _takeTeam(tTeam);
439         _reflectFee(rFee, tFee);
440         emit Transfer(sender, recipient, tTransferAmount);
441     }
442  
443     function _takeTeam(uint256 tTeam) private {
444         uint256 currentRate = _getRate();
445         uint256 rTeam = tTeam.mul(currentRate);
446         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
447     }
448  
449     function _reflectFee(uint256 rFee, uint256 tFee) private {
450         _rTotal = _rTotal.sub(rFee);
451         _tFeeTotal = _tFeeTotal.add(tFee);
452     }
453  
454     receive() external payable {}
455  
456     function _getValues(uint256 tAmount)
457         private
458         view
459         returns (
460             uint256,
461             uint256,
462             uint256,
463             uint256,
464             uint256,
465             uint256
466         )
467     {
468         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
469             _getTValues(tAmount, _redisFee, _taxFee);
470         uint256 currentRate = _getRate();
471         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
472             _getRValues(tAmount, tFee, tTeam, currentRate);
473         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
474     }
475  
476     function _getTValues(
477         uint256 tAmount,
478         uint256 redisFee,
479         uint256 taxFee
480     )
481         private
482         pure
483         returns (
484             uint256,
485             uint256,
486             uint256
487         )
488     {
489         uint256 tFee = tAmount.mul(redisFee).div(100);
490         uint256 tTeam = tAmount.mul(taxFee).div(100);
491         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
492         return (tTransferAmount, tFee, tTeam);
493     }
494  
495     function _getRValues(
496         uint256 tAmount,
497         uint256 tFee,
498         uint256 tTeam,
499         uint256 currentRate
500     )
501         private
502         pure
503         returns (
504             uint256,
505             uint256,
506             uint256
507         )
508     {
509         uint256 rAmount = tAmount.mul(currentRate);
510         uint256 rFee = tFee.mul(currentRate);
511         uint256 rTeam = tTeam.mul(currentRate);
512         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
513         return (rAmount, rTransferAmount, rFee);
514     }
515  
516     function _getRate() private view returns (uint256) {
517         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
518         return rSupply.div(tSupply);
519     }
520  
521     function _getCurrentSupply() private view returns (uint256, uint256) {
522         uint256 rSupply = _rTotal;
523         uint256 tSupply = _tTotal;
524         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
525         return (rSupply, tSupply);
526     }
527  
528     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
529         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
530         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 98, "Buy tax must be between 0% and 98%");
531         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
532         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 98, "Sell tax must be between 0% and 98%");
533 
534         _redisFeeOnBuy = redisFeeOnBuy;
535         _redisFeeOnSell = redisFeeOnSell;
536         _taxFeeOnBuy = taxFeeOnBuy;
537         _taxFeeOnSell = taxFeeOnSell;
538 
539     }
540  
541     //Set minimum tokens required to swap.
542     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
543         _swapTokensAtAmount = swapTokensAtAmount;
544     }
545  
546     //Set minimum tokens required to swap.
547     function toggleSwap(bool _swapEnabled) public onlyOwner {
548         swapEnabled = _swapEnabled;
549     }
550  
551     //Set maximum transaction
552     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
553            _maxTxAmount = maxTxAmount;
554         
555     }
556  
557     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
558         _maxWalletSize = maxWalletSize;
559     }
560  
561     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
562         for(uint256 i = 0; i < accounts.length; i++) {
563             _isExcludedFromFee[accounts[i]] = excluded;
564         }
565     }
566 }