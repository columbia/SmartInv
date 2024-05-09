1 /*
2 
3 Eterium
4 
5 The low-effort Ethereum Alternative
6 
7 Welcome to Eterium, the retarted brother of Ethereum and the first ever Ethereum-inspired memecoin. 
8 
9 On the back of the success of recent Memecoins and through the lead of experienced developers, the team behind Eterium aims to build the next big thing in the Crypto space. 
10 
11 Join us as we build a worldwide culture token.
12 
13 www.eteriumtoken.com
14 twitter.com/eteriumtoken
15 t.me/eteriumportal
16 
17 */
18 
19 
20 
21 // SPDX-License-Identifier: Unlicensed
22 pragma solidity ^0.8.15;
23  
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 }
29  
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32  
33     function balanceOf(address account) external view returns (uint256);
34  
35     function transfer(address recipient, uint256 amount) external returns (bool);
36  
37     function allowance(address owner, address spender) external view returns (uint256);
38  
39     function approve(address spender, uint256 amount) external returns (bool);
40  
41     function transferFrom(
42         address sender,
43         address recipient,
44         uint256 amount
45     ) external returns (bool);
46  
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(
49         address indexed owner,
50         address indexed spender,
51         uint256 value
52     );
53 }
54  
55 contract Ownable is Context {
56     address private _owner;
57     address private _previousOwner;
58     event OwnershipTransferred(
59         address indexed previousOwner,
60         address indexed newOwner
61     );
62  
63     constructor() {
64         address msgSender = _msgSender();
65         _owner = msgSender;
66         emit OwnershipTransferred(address(0), msgSender);
67     }
68  
69     function owner() public view returns (address) {
70         return _owner;
71     }
72  
73     modifier onlyOwner() {
74         require(_owner == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77  
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82  
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88  
89 }
90  
91 library SafeMath {
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         require(c >= a, "SafeMath: addition overflow");
95         return c;
96     }
97  
98     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99         return sub(a, b, "SafeMath: subtraction overflow");
100     }
101  
102     function sub(
103         uint256 a,
104         uint256 b,
105         string memory errorMessage
106     ) internal pure returns (uint256) {
107         require(b <= a, errorMessage);
108         uint256 c = a - b;
109         return c;
110     }
111  
112     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113         if (a == 0) {
114             return 0;
115         }
116         uint256 c = a * b;
117         require(c / a == b, "SafeMath: multiplication overflow");
118         return c;
119     }
120  
121     function div(uint256 a, uint256 b) internal pure returns (uint256) {
122         return div(a, b, "SafeMath: division by zero");
123     }
124  
125     function div(
126         uint256 a,
127         uint256 b,
128         string memory errorMessage
129     ) internal pure returns (uint256) {
130         require(b > 0, errorMessage);
131         uint256 c = a / b;
132         return c;
133     }
134 }
135  
136 interface IUniswapV2Factory {
137     function createPair(address tokenA, address tokenB)
138         external
139         returns (address pair);
140 }
141  
142 interface IUniswapV2Router02 {
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint256 amountIn,
145         uint256 amountOutMin,
146         address[] calldata path,
147         address to,
148         uint256 deadline
149     ) external;
150  
151     function factory() external pure returns (address);
152  
153     function WETH() external pure returns (address);
154  
155     function addLiquidityETH(
156         address token,
157         uint256 amountTokenDesired,
158         uint256 amountTokenMin,
159         uint256 amountETHMin,
160         address to,
161         uint256 deadline
162     )
163         external
164         payable
165         returns (
166             uint256 amountToken,
167             uint256 amountETH,
168             uint256 liquidity
169         );
170 }
171  
172 contract ETE is Context, IERC20, Ownable {
173  
174     using SafeMath for uint256;
175  
176     string private constant _name = "Eterium";
177     string private constant _symbol = "ETE";
178     uint8 private constant _decimals = 9;
179  
180     mapping(address => uint256) private _rOwned;
181     mapping(address => uint256) private _tOwned;
182     mapping(address => mapping(address => uint256)) private _allowances;
183     mapping(address => bool) private _isExcludedFromFee;
184     uint256 private constant MAX = ~uint256(0);
185     uint256 private constant _tTotal = 10000000000 * 10**9;
186     uint256 private _rTotal = (MAX - (MAX % _tTotal));
187     uint256 private _tFeeTotal;
188     uint256 private _redisFeeOnBuy = 0;  
189     uint256 private _taxFeeOnBuy = 25;  
190     uint256 private _redisFeeOnSell = 0;  
191     uint256 private _taxFeeOnSell = 99;
192  
193     //Original Fee
194     uint256 private _redisFee = _redisFeeOnSell;
195     uint256 private _taxFee = _taxFeeOnSell;
196  
197     uint256 private _previousredisFee = _redisFee;
198     uint256 private _previoustaxFee = _taxFee;
199  
200     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
201     address payable private _developmentAddress = payable(0x535B2bB77468c25EBe21fBc9c78d9a890E7d6a7f); 
202     address payable private _marketingAddress = payable(0x535B2bB77468c25EBe21fBc9c78d9a890E7d6a7f);
203  
204     IUniswapV2Router02 public uniswapV2Router;
205     address public uniswapV2Pair;
206  
207     bool private tradingOpen;
208     bool private inSwap = false;
209     bool private swapEnabled = true;
210  
211     uint256 public _maxTxAmount = 200000000 * 10**9; 
212     uint256 public _maxWalletSize = 200000000 * 10**9; 
213     uint256 public _swapTokensAtAmount = 100000 * 10**9;
214  
215     event MaxTxAmountUpdated(uint256 _maxTxAmount);
216     modifier lockTheSwap {
217         inSwap = true;
218         _;
219         inSwap = false;
220     }
221  
222     constructor() {
223  
224         _rOwned[_msgSender()] = _rTotal;
225  
226         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
227         uniswapV2Router = _uniswapV2Router;
228         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
229             .createPair(address(this), _uniswapV2Router.WETH());
230  
231         _isExcludedFromFee[owner()] = true;
232         _isExcludedFromFee[address(this)] = true;
233         _isExcludedFromFee[_developmentAddress] = true;
234         _isExcludedFromFee[_marketingAddress] = true;
235  
236         emit Transfer(address(0), _msgSender(), _tTotal);
237     }
238  
239     function name() public pure returns (string memory) {
240         return _name;
241     }
242  
243     function symbol() public pure returns (string memory) {
244         return _symbol;
245     }
246  
247     function decimals() public pure returns (uint8) {
248         return _decimals;
249     }
250  
251     function totalSupply() public pure override returns (uint256) {
252         return _tTotal;
253     }
254  
255     function balanceOf(address account) public view override returns (uint256) {
256         return tokenFromReflection(_rOwned[account]);
257     }
258  
259     function transfer(address recipient, uint256 amount)
260         public
261         override
262         returns (bool)
263     {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267  
268     function allowance(address owner, address spender)
269         public
270         view
271         override
272         returns (uint256)
273     {
274         return _allowances[owner][spender];
275     }
276  
277     function approve(address spender, uint256 amount)
278         public
279         override
280         returns (bool)
281     {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285  
286     function transferFrom(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) public override returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(
293             sender,
294             _msgSender(),
295             _allowances[sender][_msgSender()].sub(
296                 amount,
297                 "ERC20: transfer amount exceeds allowance"
298             )
299         );
300         return true;
301     }
302  
303     function tokenFromReflection(uint256 rAmount)
304         private
305         view
306         returns (uint256)
307     {
308         require(
309             rAmount <= _rTotal,
310             "Amount must be less than total reflections"
311         );
312         uint256 currentRate = _getRate();
313         return rAmount.div(currentRate);
314     }
315  
316     function removeAllFee() private {
317         if (_redisFee == 0 && _taxFee == 0) return;
318  
319         _previousredisFee = _redisFee;
320         _previoustaxFee = _taxFee;
321  
322         _redisFee = 0;
323         _taxFee = 0;
324     }
325  
326     function restoreAllFee() private {
327         _redisFee = _previousredisFee;
328         _taxFee = _previoustaxFee;
329     }
330  
331     function _approve(
332         address owner,
333         address spender,
334         uint256 amount
335     ) private {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338         _allowances[owner][spender] = amount;
339         emit Approval(owner, spender, amount);
340     }
341  
342     function _transfer(
343         address from,
344         address to,
345         uint256 amount
346     ) private {
347         require(from != address(0), "ERC20: transfer from the zero address");
348         require(to != address(0), "ERC20: transfer to the zero address");
349         require(amount > 0, "Transfer amount must be greater than zero");
350  
351         if (from != owner() && to != owner()) {
352  
353             //Trade start check
354             if (!tradingOpen) {
355                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
356             }
357  
358             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
359             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
360  
361             if(to != uniswapV2Pair) {
362                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
363             }
364  
365             uint256 contractTokenBalance = balanceOf(address(this));
366             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
367  
368             if(contractTokenBalance >= _maxTxAmount)
369             {
370                 contractTokenBalance = _maxTxAmount;
371             }
372  
373             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
374                 swapTokensForEth(contractTokenBalance);
375                 uint256 contractETHBalance = address(this).balance;
376                 if (contractETHBalance > 0) {
377                     sendETHToFee(address(this).balance);
378                 }
379             }
380         }
381  
382         bool takeFee = true;
383  
384         //Transfer Tokens
385         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
386             takeFee = false;
387         } else {
388  
389             //Set Fee for Buys
390             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
391                 _redisFee = _redisFeeOnBuy;
392                 _taxFee = _taxFeeOnBuy;
393             }
394  
395             //Set Fee for Sells
396             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
397                 _redisFee = _redisFeeOnSell;
398                 _taxFee = _taxFeeOnSell;
399             }
400  
401         }
402  
403         _tokenTransfer(from, to, amount, takeFee);
404     }
405  
406     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
407         address[] memory path = new address[](2);
408         path[0] = address(this);
409         path[1] = uniswapV2Router.WETH();
410         _approve(address(this), address(uniswapV2Router), tokenAmount);
411         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
412             tokenAmount,
413             0,
414             path,
415             address(this),
416             block.timestamp
417         );
418     }
419  
420     function sendETHToFee(uint256 amount) private {
421         _marketingAddress.transfer(amount);
422     }
423  
424     function setTrading(bool _tradingOpen) public onlyOwner {
425         tradingOpen = _tradingOpen;
426     }
427  
428     function manualswap() external {
429         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
430         uint256 contractBalance = balanceOf(address(this));
431         swapTokensForEth(contractBalance);
432     }
433  
434     function manualsend() external {
435         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
436         uint256 contractETHBalance = address(this).balance;
437         sendETHToFee(contractETHBalance);
438     }
439  
440     function blockBots(address[] memory bots_) public onlyOwner {
441         for (uint256 i = 0; i < bots_.length; i++) {
442             bots[bots_[i]] = true;
443         }
444     }
445  
446     function unblockBot(address notbot) public onlyOwner {
447         bots[notbot] = false;
448     }
449  
450     function _tokenTransfer(
451         address sender,
452         address recipient,
453         uint256 amount,
454         bool takeFee
455     ) private {
456         if (!takeFee) removeAllFee();
457         _transferStandard(sender, recipient, amount);
458         if (!takeFee) restoreAllFee();
459     }
460  
461     function _transferStandard(
462         address sender,
463         address recipient,
464         uint256 tAmount
465     ) private {
466         (
467             uint256 rAmount,
468             uint256 rTransferAmount,
469             uint256 rFee,
470             uint256 tTransferAmount,
471             uint256 tFee,
472             uint256 tTeam
473         ) = _getValues(tAmount);
474         _rOwned[sender] = _rOwned[sender].sub(rAmount);
475         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
476         _takeTeam(tTeam);
477         _reflectFee(rFee, tFee);
478         emit Transfer(sender, recipient, tTransferAmount);
479     }
480  
481     function _takeTeam(uint256 tTeam) private {
482         uint256 currentRate = _getRate();
483         uint256 rTeam = tTeam.mul(currentRate);
484         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
485     }
486  
487     function _reflectFee(uint256 rFee, uint256 tFee) private {
488         _rTotal = _rTotal.sub(rFee);
489         _tFeeTotal = _tFeeTotal.add(tFee);
490     }
491  
492     receive() external payable {}
493  
494     function _getValues(uint256 tAmount)
495         private
496         view
497         returns (
498             uint256,
499             uint256,
500             uint256,
501             uint256,
502             uint256,
503             uint256
504         )
505     {
506         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
507             _getTValues(tAmount, _redisFee, _taxFee);
508         uint256 currentRate = _getRate();
509         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
510             _getRValues(tAmount, tFee, tTeam, currentRate);
511         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
512     }
513  
514     function _getTValues(
515         uint256 tAmount,
516         uint256 redisFee,
517         uint256 taxFee
518     )
519         private
520         pure
521         returns (
522             uint256,
523             uint256,
524             uint256
525         )
526     {
527         uint256 tFee = tAmount.mul(redisFee).div(100);
528         uint256 tTeam = tAmount.mul(taxFee).div(100);
529         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
530         return (tTransferAmount, tFee, tTeam);
531     }
532  
533     function _getRValues(
534         uint256 tAmount,
535         uint256 tFee,
536         uint256 tTeam,
537         uint256 currentRate
538     )
539         private
540         pure
541         returns (
542             uint256,
543             uint256,
544             uint256
545         )
546     {
547         uint256 rAmount = tAmount.mul(currentRate);
548         uint256 rFee = tFee.mul(currentRate);
549         uint256 rTeam = tTeam.mul(currentRate);
550         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
551         return (rAmount, rTransferAmount, rFee);
552     }
553  
554     function _getRate() private view returns (uint256) {
555         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
556         return rSupply.div(tSupply);
557     }
558  
559     function _getCurrentSupply() private view returns (uint256, uint256) {
560         uint256 rSupply = _rTotal;
561         uint256 tSupply = _tTotal;
562         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
563         return (rSupply, tSupply);
564     }
565  
566     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
567         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
568         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 98, "Buy tax must be between 0% and 98%");
569         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
570         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 98, "Sell tax must be between 0% and 98%");
571 
572         _redisFeeOnBuy = redisFeeOnBuy;
573         _redisFeeOnSell = redisFeeOnSell;
574         _taxFeeOnBuy = taxFeeOnBuy;
575         _taxFeeOnSell = taxFeeOnSell;
576 
577     }
578  
579     //Set minimum tokens required to swap.
580     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
581         _swapTokensAtAmount = swapTokensAtAmount;
582     }
583  
584     //Set minimum tokens required to swap.
585     function toggleSwap(bool _swapEnabled) public onlyOwner {
586         swapEnabled = _swapEnabled;
587     }
588  
589     //Set maximum transaction
590     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
591            _maxTxAmount = maxTxAmount;
592         
593     }
594  
595     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
596         _maxWalletSize = maxWalletSize;
597     }
598  
599     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
600         for(uint256 i = 0; i < accounts.length; i++) {
601             _isExcludedFromFee[accounts[i]] = excluded;
602         }
603     }
604 
605 }