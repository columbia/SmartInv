1 // SPDX-License-Identifier: unlicense
2 
3 /*
4 * 
5 * ███╗   ███╗███████╗██╗███████╗██╗  ██╗██╗   ██╗
6 * ████╗ ████║██╔════╝██║██╔════╝██║  ██║██║   ██║
7 * ██╔████╔██║█████╗  ██║███████╗███████║██║   ██║
8 * ██║╚██╔╝██║██╔══╝  ██║╚════██║██╔══██║██║   ██║
9 * ██║ ╚═╝ ██║███████╗██║███████║██║  ██║╚██████╔╝
10 * ╚═╝     ╚═╝╚══════╝╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ 
11 */
12 
13 
14 // MEISHU ETH
15 // Version: 20220303001
16 // Website: https://meishu.io/
17 // Twitter: https://mobile.twitter.com/meishu_official (@meishu_official)
18 // TG: https://t.me/meishu_official
19 // Instagram: https://www.instagram.com/meishu_official/
20 
21 
22 pragma solidity ^0.8.7;
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
172 contract Meishu is Context, IERC20, Ownable {
173  
174     using SafeMath for uint256;
175  
176     string private constant _name = "Meishu";//
177     string private constant _symbol = "MEISHU";//
178     uint8 private constant _decimals = 9;
179  
180     mapping(address => uint256) private _rOwned;
181     mapping(address => uint256) private _tOwned;
182     mapping(address => mapping(address => uint256)) private _allowances;
183     mapping(address => bool) private _isExcludedFromFee;
184     uint256 private constant MAX = ~uint256(0);
185     uint256 private constant _tTotal = 777000000 * 10**9;
186     uint256 private _rTotal = (MAX - (MAX % _tTotal));
187     uint256 private _tFeeTotal;
188     uint256 public launchBlock;
189  
190     //Buy Fee
191     uint256 private _redisFeeOnBuy = 0;//
192     uint256 private _taxFeeOnBuy = 8;//
193  
194     //Sell Fee
195     uint256 private _redisFeeOnSell = 0;//
196     uint256 private _taxFeeOnSell = 20;//
197  
198     //Original Fee
199     uint256 private _redisFee = _redisFeeOnSell;
200     uint256 private _taxFee = _taxFeeOnSell;
201  
202     uint256 private _previousredisFee = _redisFee;
203     uint256 private _previoustaxFee = _taxFee;
204  
205     mapping(address => bool) public bots;
206     mapping(address => uint256) private cooldown;
207  
208     address payable private _developmentAddress = payable(0xc315aA89008A7D6F45F396Ce679d1130e8E69Dce);//
209     address payable private _marketingAddress = payable(0x3bd9B286F98BeA2a85438C2A2ab2Cb8b86CB0c17);//
210  
211     IUniswapV2Router02 public uniswapV2Router;
212     address public uniswapV2Pair;
213  
214     bool private tradingOpen;
215     bool private inSwap = false;
216     bool private swapEnabled = true;
217  
218     uint256 public _maxTxAmount = 777000 * 10**9; //
219     uint256 public _maxWalletSize = 2331000 * 10**9; //
220     uint256 public _swapTokensAtAmount = 233100 * 10**9; //
221  
222     event MaxTxAmountUpdated(uint256 _maxTxAmount);
223     modifier lockTheSwap {
224         inSwap = true;
225         _;
226         inSwap = false;
227     }
228  
229     constructor() {
230  
231         _rOwned[_msgSender()] = _rTotal;
232  
233         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
234         uniswapV2Router = _uniswapV2Router;
235         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
236             .createPair(address(this), _uniswapV2Router.WETH());
237  
238         _isExcludedFromFee[owner()] = true;
239         _isExcludedFromFee[address(this)] = true;
240         _isExcludedFromFee[_developmentAddress] = true;
241         _isExcludedFromFee[_marketingAddress] = true;
242   
243         emit Transfer(address(0), _msgSender(), _tTotal);
244     }
245  
246     function name() public pure returns (string memory) {
247         return _name;
248     }
249  
250     function symbol() public pure returns (string memory) {
251         return _symbol;
252     }
253  
254     function decimals() public pure returns (uint8) {
255         return _decimals;
256     }
257  
258     function totalSupply() public pure override returns (uint256) {
259         return _tTotal;
260     }
261  
262     function balanceOf(address account) public view override returns (uint256) {
263         return tokenFromReflection(_rOwned[account]);
264     }
265  
266     function transfer(address recipient, uint256 amount)
267         public
268         override
269         returns (bool)
270     {
271         _transfer(_msgSender(), recipient, amount);
272         return true;
273     }
274  
275     function allowance(address owner, address spender)
276         public
277         view
278         override
279         returns (uint256)
280     {
281         return _allowances[owner][spender];
282     }
283  
284     function approve(address spender, uint256 amount)
285         public
286         override
287         returns (bool)
288     {
289         _approve(_msgSender(), spender, amount);
290         return true;
291     }
292  
293     function transferFrom(
294         address sender,
295         address recipient,
296         uint256 amount
297     ) public override returns (bool) {
298         _transfer(sender, recipient, amount);
299         _approve(
300             sender,
301             _msgSender(),
302             _allowances[sender][_msgSender()].sub(
303                 amount,
304                 "ERC20: transfer amount exceeds allowance"
305             )
306         );
307         return true;
308     }
309  
310     function tokenFromReflection(uint256 rAmount)
311         private
312         view
313         returns (uint256)
314     {
315         require(
316             rAmount <= _rTotal,
317             "Amount must be less than total reflections"
318         );
319         uint256 currentRate = _getRate();
320         return rAmount.div(currentRate);
321     }
322  
323     function removeAllFee() private {
324         if (_redisFee == 0 && _taxFee == 0) return;
325  
326         _previousredisFee = _redisFee;
327         _previoustaxFee = _taxFee;
328  
329         _redisFee = 0;
330         _taxFee = 0;
331     }
332  
333     function restoreAllFee() private {
334         _redisFee = _previousredisFee;
335         _taxFee = _previoustaxFee;
336     }
337  
338     function _approve(
339         address owner,
340         address spender,
341         uint256 amount
342     ) private {
343         require(owner != address(0), "ERC20: approve from the zero address");
344         require(spender != address(0), "ERC20: approve to the zero address");
345         _allowances[owner][spender] = amount;
346         emit Approval(owner, spender, amount);
347     }
348  
349     function _transfer(
350         address from,
351         address to,
352         uint256 amount
353     ) private {
354         require(from != address(0), "ERC20: transfer from the zero address");
355         require(to != address(0), "ERC20: transfer to the zero address");
356         require(amount > 0, "Transfer amount must be greater than zero");
357  
358         if (from != owner() && to != owner()) {
359  
360             //Trade start check
361             if (!tradingOpen) {
362                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
363             }
364  
365             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
366             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
367  
368             if(block.number <= launchBlock + 2 && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
369                 bots[to] = true;
370             } 
371  
372             if(to != uniswapV2Pair) {
373                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
374             }
375  
376             uint256 contractTokenBalance = balanceOf(address(this));
377             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
378  
379             if(contractTokenBalance >= _maxTxAmount)
380             {
381                 contractTokenBalance = _maxTxAmount;
382             }
383  
384             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
385                 swapTokensForEth(contractTokenBalance);
386                 uint256 contractETHBalance = address(this).balance;
387                 if (contractETHBalance > 0) {
388                     sendETHToFee(address(this).balance);
389                 }
390             }
391         }
392  
393         bool takeFee = true;
394  
395         //Transfer Tokens
396         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
397             takeFee = false;
398         } else {
399  
400             //Set Fee for Buys
401             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
402                 _redisFee = _redisFeeOnBuy;
403                 _taxFee = _taxFeeOnBuy;
404             }
405  
406             //Set Fee for Sells
407             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
408                 _redisFee = _redisFeeOnSell;
409                 _taxFee = _taxFeeOnSell;
410             }
411  
412         }
413  
414         _tokenTransfer(from, to, amount, takeFee);
415     }
416  
417     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
418         address[] memory path = new address[](2);
419         path[0] = address(this);
420         path[1] = uniswapV2Router.WETH();
421         _approve(address(this), address(uniswapV2Router), tokenAmount);
422         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
423             tokenAmount,
424             0,
425             path,
426             address(this),
427             block.timestamp
428         );
429     }
430  
431     function sendETHToFee(uint256 amount) private {
432         _developmentAddress.transfer(amount.mul(4).div(22));
433         _marketingAddress.transfer(amount.mul(18).div(22));
434     }
435  
436     function setTrading(bool _tradingOpen) public onlyOwner {
437         tradingOpen = _tradingOpen;
438         launchBlock = block.number;
439     }
440  
441     function manualswap() external {
442         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
443         uint256 contractBalance = balanceOf(address(this));
444         swapTokensForEth(contractBalance);
445     }
446  
447     function manualsend() external {
448         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
449         uint256 contractETHBalance = address(this).balance;
450         sendETHToFee(contractETHBalance);
451     }
452  
453     function blockBots(address[] memory bots_) public onlyOwner {
454         for (uint256 i = 0; i < bots_.length; i++) {
455             bots[bots_[i]] = true;
456         }
457     }
458  
459     function unblockBot(address notbot) public onlyOwner {
460         bots[notbot] = false;
461     }
462  
463     function _tokenTransfer(
464         address sender,
465         address recipient,
466         uint256 amount,
467         bool takeFee
468     ) private {
469         if (!takeFee) removeAllFee();
470         _transferStandard(sender, recipient, amount);
471         if (!takeFee) restoreAllFee();
472     }
473  
474     function _transferStandard(
475         address sender,
476         address recipient,
477         uint256 tAmount
478     ) private {
479         (
480             uint256 rAmount,
481             uint256 rTransferAmount,
482             uint256 rFee,
483             uint256 tTransferAmount,
484             uint256 tFee,
485             uint256 tTeam
486         ) = _getValues(tAmount);
487         _rOwned[sender] = _rOwned[sender].sub(rAmount);
488         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
489         _takeTeam(tTeam);
490         _reflectFee(rFee, tFee);
491         emit Transfer(sender, recipient, tTransferAmount);
492     }
493  
494     function _takeTeam(uint256 tTeam) private {
495         uint256 currentRate = _getRate();
496         uint256 rTeam = tTeam.mul(currentRate);
497         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
498     }
499  
500     function _reflectFee(uint256 rFee, uint256 tFee) private {
501         _rTotal = _rTotal.sub(rFee);
502         _tFeeTotal = _tFeeTotal.add(tFee);
503     }
504  
505     receive() external payable {}
506  
507     function _getValues(uint256 tAmount)
508         private
509         view
510         returns (
511             uint256,
512             uint256,
513             uint256,
514             uint256,
515             uint256,
516             uint256
517         )
518     {
519         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
520             _getTValues(tAmount, _redisFee, _taxFee);
521         uint256 currentRate = _getRate();
522         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
523             _getRValues(tAmount, tFee, tTeam, currentRate);
524  
525         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
526     }
527  
528     function _getTValues(
529         uint256 tAmount,
530         uint256 redisFee,
531         uint256 taxFee
532     )
533         private
534         pure
535         returns (
536             uint256,
537             uint256,
538             uint256
539         )
540     {
541         uint256 tFee = tAmount.mul(redisFee).div(100);
542         uint256 tTeam = tAmount.mul(taxFee).div(100);
543         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
544  
545         return (tTransferAmount, tFee, tTeam);
546     }
547  
548     function _getRValues(
549         uint256 tAmount,
550         uint256 tFee,
551         uint256 tTeam,
552         uint256 currentRate
553     )
554         private
555         pure
556         returns (
557             uint256,
558             uint256,
559             uint256
560         )
561     {
562         uint256 rAmount = tAmount.mul(currentRate);
563         uint256 rFee = tFee.mul(currentRate);
564         uint256 rTeam = tTeam.mul(currentRate);
565         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
566  
567         return (rAmount, rTransferAmount, rFee);
568     }
569  
570     function _getRate() private view returns (uint256) {
571         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
572  
573         return rSupply.div(tSupply);
574     }
575  
576     function _getCurrentSupply() private view returns (uint256, uint256) {
577         uint256 rSupply = _rTotal;
578         uint256 tSupply = _tTotal;
579         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
580  
581         return (rSupply, tSupply);
582     }
583  
584     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
585         _redisFeeOnBuy = redisFeeOnBuy;
586         _redisFeeOnSell = redisFeeOnSell;
587  
588         _taxFeeOnBuy = taxFeeOnBuy;
589         _taxFeeOnSell = taxFeeOnSell;
590     }
591  
592     //Set minimum tokens required to swap.
593     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
594         _swapTokensAtAmount = swapTokensAtAmount;
595     }
596  
597     //Set minimum tokens required to swap.
598     function toggleSwap(bool _swapEnabled) public onlyOwner {
599         swapEnabled = _swapEnabled;
600     }
601  
602  
603     //Set maximum transaction
604     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
605         _maxTxAmount = maxTxAmount;
606     }
607  
608     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
609         _maxWalletSize = maxWalletSize;
610     }
611  
612     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
613         for(uint256 i = 0; i < accounts.length; i++) {
614             _isExcludedFromFee[accounts[i]] = excluded;
615         }
616     }
617 }