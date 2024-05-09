1 /**
2 
3 Telegram: https://t.me/batinueth
4 
5 Website: https://batinu.com/
6 
7                                      .~?5PPJ.                                                                ^77!^.                                   
8                                .:!JPGP5?~!B#~                                                               5#Y7Y5PGPJ!:.                             
9                            :!YPGPJ!:.   !BG~                                                                J#Y    .:!JPGPY!:                         
10                        :75GGY!:       .5#?                         .!7^         ~7~                          J#5         :!YGG5!.                     
11                    .~5GGY~.           P#7                         .BBP#Y       P#P#5                          Y#?            .75BP?:                  
12                 .!PBP7.              ^#G                          7#Y Y#?     J#Y G#^                         :BB               .~5BG7.               
13               ^5BP!.                 .BB.                         P#~  P#~   ~#G  ?#Y                         !#P                  .~PB5^             
14             !GBJ:                     ^GB7.                      :BG   .BB7~7BG:  :BB                       .J#P.                     :JBG~           
15           !BB7.                         !PB57:                   Y#?    .!JYJ!.    G#^                   :7PB5~                         .?BG~         
16         ^GB7                              .!YPGPY7~:.           .BB.               J#J             .^!JPGPJ~.                             .Y#P.       
17       .Y#Y.                                   .:~?Y5PGPP55JJ?7775#J                .GB?^^^^~!7JY5PGP5J!:.                                   :G#7      
18      ^BB~                                             ..:^~!777?7!                   ~JYYYYJ?7!^:.                                            J#5.    
19     7#P.          .GGPPPPPPPPPPPY!.          5BGGGGB#Y    5BBBBBGGBBBBBBB###&^ ^BBBBGG: :PPPPP5^      :GGGBB5 JGGGGPP? .   7GPPPPG: .          !#G.   
20    J#5             &@@@@@@@@@@@@@@&J        ~@&&@@&&&@~   #@@@@@@@&&&&@@@@@@@J ^@&&&&@^ !@@@@@@&?     .&@&&@P 7@@@@@@B .   ?@@@@@@:.            ~#G.  
21   J#5              G&&&&&&GY5G&&&&&@!       #&&&&&&&&&&.. JP55555&&&&&BGGBBB#7 .&&&&&&: !@&&&&&&@P    .&&&&@? .&&&&&&G .   ~@&&&&&..             ~#G. 
22  7#P               G&&&&&@^   5@&&&@P .    Y@&&&&&&&&&@P .       B&&&@~ .      .&&&&&&: !@&&&&&&&@B.  .&&&&@~  B&&&&&G .   :&&&&&# .              ?#5 
23 ~BG.               G&&&&&&?^~J&&&&&#:..   ^&&&&@P:&&&&&@~        B&&&@! .       &&&&&&^ ~@&&&&B@&&@&~ :&&&&&:. Y@&&&&G .    &&&&&# .               P#!
24 G#7 ..:~!7?JYYY55Y B&&&&&&&&&&&@&#?  .   .&&&&&#. Y@&&&&&..      #&&&@! .       &&&&&@^ :&&&&& !&&&&&Y?&&&&&.. 7@&&&&G .    #&&&&B :5P555YJ?7!~:.. !#B
25 ^5GPGP5YJ7!~~^^^^: #&&&&&&!:^~~?&&&BJ.   G@&&&&^ ..#&&&&@P .     #&&&@7 .       &&&&&@~ .&&&&&. :#@&&@&&&&&&.. !@&&&&# .7Y^^&&&&@G :::::^^~!7JY5PPGGG!
26                    #&&&&&&.  .~ #&&&@&. J@&&&&&####&&&&&&@!      &&&&@? .      .&&&&&@! .&&&&@^.  5@&&&&&&&&.. .&&&&&&#???5&&&&&@7 .               .  
27                   .&&&&&&&5??7J#&&&&@& !@&&&&&#####&&&&&&&&.    .&&&&@Y .      .&&&&&@? .&&&&@7 .  ~&@&&&&&&:.  ~&@&&&&@@@@&&&&@P :                   
28                   :@@@@@@@@@@@@@@@@&#^^@@@@@&:......^&@@@@@B .  :@@@@@B .      :@@@@@@Y .&@@@@P . ..:G@@@@@@^     ?B&@@@@@@@@&#7 .                    
29                   :P555PPPPPPPPP5Y7^  5P55PG^ ~PPPPP^~GPPPPG^ . :PPPP5? .      :PPPPPP!  PP5PG5 :PGGJ.7PPGGP...   ?!:!J5PPPY7^...                     
30                                    ~J~~~^:.  ......::. .^~!!^.                         .:~~~:.  ..          .~PGJ7##.                                 
31                                     ^7!:                 .!5GG?.                     .7GBY~.                   :7YJ:                                  
32                                                              ^5BP~                 :YBP~                                                              
33                                                                .7BB7             :5#5:                                                                
34                                                                   !BB7         .J#P:                                                                  
35                                                                     7BG~      !BB~                                                                    
36                                                                      .Y#5.  .5#Y                                                                      
37                                                                        ^GB!^BB~                                                                       
38                                                                         .JBB5.                                                                        
39 */
40 
41 
42 // SPDX-License-Identifier: Unlicensed
43 pragma solidity ^0.8.9;
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
193 contract Batinu is Context, IERC20, Ownable {
194 
195     using SafeMath for uint256;
196 
197     string private constant _name = "Batinu";
198     string private constant _symbol = "BATINU";
199     uint8 private constant _decimals = 9;
200 
201     mapping(address => uint256) private _rOwned;
202     mapping(address => uint256) private _tOwned;
203     mapping(address => mapping(address => uint256)) private _allowances;
204     mapping(address => bool) private _isExcludedFromFee;
205     uint256 private constant MAX = ~uint256(0);
206     uint256 private constant _tTotal = 1000000000 * 10**9;
207     uint256 private _rTotal = (MAX - (MAX % _tTotal));
208     uint256 private _tFeeTotal;
209     uint256 private _redisFeeOnBuy = 1;
210     uint256 private _taxFeeOnBuy = 11;
211     uint256 private _redisFeeOnSell = 1;
212     uint256 private _taxFeeOnSell = 11;
213 
214     //Original Fee
215     uint256 private _redisFee = _redisFeeOnSell;
216     uint256 private _taxFee = _taxFeeOnSell;
217 
218     uint256 private _previousredisFee = _redisFee;
219     uint256 private _previoustaxFee = _taxFee;
220 
221     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
222     address payable private _developmentAddress = payable(0x56ADc952FCe7a1F0ecEE7BD1813ECc2c07F39CD9);
223     address payable private _marketingAddress = payable(0x56ADc952FCe7a1F0ecEE7BD1813ECc2c07F39CD9);
224 
225     IUniswapV2Router02 public uniswapV2Router;
226     address public uniswapV2Pair;
227 
228     bool private tradingOpen;
229     bool private inSwap = false;
230     bool private swapEnabled = true;
231 
232     uint256 public _maxTxAmount = 10000000 * 10**9;
233     uint256 public _maxWalletSize = 25000000 * 10**9;
234     uint256 public _swapTokensAtAmount = 10000 * 10**9;
235 
236     event MaxTxAmountUpdated(uint256 _maxTxAmount);
237     modifier lockTheSwap {
238         inSwap = true;
239         _;
240         inSwap = false;
241     }
242 
243     constructor() {
244 
245         _rOwned[_msgSender()] = _rTotal;
246 
247         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
248         uniswapV2Router = _uniswapV2Router;
249         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
250             .createPair(address(this), _uniswapV2Router.WETH());
251 
252         _isExcludedFromFee[owner()] = true;
253         _isExcludedFromFee[address(this)] = true;
254         _isExcludedFromFee[_developmentAddress] = true;
255         _isExcludedFromFee[_marketingAddress] = true;
256 
257         emit Transfer(address(0), _msgSender(), _tTotal);
258     }
259 
260     function name() public pure returns (string memory) {
261         return _name;
262     }
263 
264     function symbol() public pure returns (string memory) {
265         return _symbol;
266     }
267 
268     function decimals() public pure returns (uint8) {
269         return _decimals;
270     }
271 
272     function totalSupply() public pure override returns (uint256) {
273         return _tTotal;
274     }
275 
276     function balanceOf(address account) public view override returns (uint256) {
277         return tokenFromReflection(_rOwned[account]);
278     }
279 
280     function transfer(address recipient, uint256 amount)
281         public
282         override
283         returns (bool)
284     {
285         _transfer(_msgSender(), recipient, amount);
286         return true;
287     }
288 
289     function allowance(address owner, address spender)
290         public
291         view
292         override
293         returns (uint256)
294     {
295         return _allowances[owner][spender];
296     }
297 
298     function approve(address spender, uint256 amount)
299         public
300         override
301         returns (bool)
302     {
303         _approve(_msgSender(), spender, amount);
304         return true;
305     }
306 
307     function transferFrom(
308         address sender,
309         address recipient,
310         uint256 amount
311     ) public override returns (bool) {
312         _transfer(sender, recipient, amount);
313         _approve(
314             sender,
315             _msgSender(),
316             _allowances[sender][_msgSender()].sub(
317                 amount,
318                 "ERC20: transfer amount exceeds allowance"
319             )
320         );
321         return true;
322     }
323 
324     function tokenFromReflection(uint256 rAmount)
325         private
326         view
327         returns (uint256)
328     {
329         require(
330             rAmount <= _rTotal,
331             "Amount must be less than total reflections"
332         );
333         uint256 currentRate = _getRate();
334         return rAmount.div(currentRate);
335     }
336 
337     function removeAllFee() private {
338         if (_redisFee == 0 && _taxFee == 0) return;
339 
340         _previousredisFee = _redisFee;
341         _previoustaxFee = _taxFee;
342 
343         _redisFee = 0;
344         _taxFee = 0;
345     }
346 
347     function restoreAllFee() private {
348         _redisFee = _previousredisFee;
349         _taxFee = _previoustaxFee;
350     }
351 
352     function _approve(
353         address owner,
354         address spender,
355         uint256 amount
356     ) private {
357         require(owner != address(0), "ERC20: approve from the zero address");
358         require(spender != address(0), "ERC20: approve to the zero address");
359         _allowances[owner][spender] = amount;
360         emit Approval(owner, spender, amount);
361     }
362 
363     function _transfer(
364         address from,
365         address to,
366         uint256 amount
367     ) private {
368         require(from != address(0), "ERC20: transfer from the zero address");
369         require(to != address(0), "ERC20: transfer to the zero address");
370         require(amount > 0, "Transfer amount must be greater than zero");
371 
372         if (from != owner() && to != owner()) {
373 
374             //Trade start check
375             if (!tradingOpen) {
376                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
377             }
378 
379             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
380             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
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
461     function blockBots(address[] memory bots_) public onlyOwner {
462         for (uint256 i = 0; i < bots_.length; i++) {
463             bots[bots_[i]] = true;
464         }
465     }
466 
467     function unblockBot(address notbot) public onlyOwner {
468         bots[notbot] = false;
469     }
470 
471     function _tokenTransfer(
472         address sender,
473         address recipient,
474         uint256 amount,
475         bool takeFee
476     ) private {
477         if (!takeFee) removeAllFee();
478         _transferStandard(sender, recipient, amount);
479         if (!takeFee) restoreAllFee();
480     }
481 
482     function _transferStandard(
483         address sender,
484         address recipient,
485         uint256 tAmount
486     ) private {
487         (
488             uint256 rAmount,
489             uint256 rTransferAmount,
490             uint256 rFee,
491             uint256 tTransferAmount,
492             uint256 tFee,
493             uint256 tTeam
494         ) = _getValues(tAmount);
495         _rOwned[sender] = _rOwned[sender].sub(rAmount);
496         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
497         _takeTeam(tTeam);
498         _reflectFee(rFee, tFee);
499         emit Transfer(sender, recipient, tTransferAmount);
500     }
501 
502     function _takeTeam(uint256 tTeam) private {
503         uint256 currentRate = _getRate();
504         uint256 rTeam = tTeam.mul(currentRate);
505         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
506     }
507 
508     function _reflectFee(uint256 rFee, uint256 tFee) private {
509         _rTotal = _rTotal.sub(rFee);
510         _tFeeTotal = _tFeeTotal.add(tFee);
511     }
512 
513     receive() external payable {}
514 
515     function _getValues(uint256 tAmount)
516         private
517         view
518         returns (
519             uint256,
520             uint256,
521             uint256,
522             uint256,
523             uint256,
524             uint256
525         )
526     {
527         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
528             _getTValues(tAmount, _redisFee, _taxFee);
529         uint256 currentRate = _getRate();
530         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
531             _getRValues(tAmount, tFee, tTeam, currentRate);
532         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
533     }
534 
535     function _getTValues(
536         uint256 tAmount,
537         uint256 redisFee,
538         uint256 taxFee
539     )
540         private
541         pure
542         returns (
543             uint256,
544             uint256,
545             uint256
546         )
547     {
548         uint256 tFee = tAmount.mul(redisFee).div(100);
549         uint256 tTeam = tAmount.mul(taxFee).div(100);
550         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
551         return (tTransferAmount, tFee, tTeam);
552     }
553 
554     function _getRValues(
555         uint256 tAmount,
556         uint256 tFee,
557         uint256 tTeam,
558         uint256 currentRate
559     )
560         private
561         pure
562         returns (
563             uint256,
564             uint256,
565             uint256
566         )
567     {
568         uint256 rAmount = tAmount.mul(currentRate);
569         uint256 rFee = tFee.mul(currentRate);
570         uint256 rTeam = tTeam.mul(currentRate);
571         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
572         return (rAmount, rTransferAmount, rFee);
573     }
574 
575     function _getRate() private view returns (uint256) {
576         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
577         return rSupply.div(tSupply);
578     }
579 
580     function _getCurrentSupply() private view returns (uint256, uint256) {
581         uint256 rSupply = _rTotal;
582         uint256 tSupply = _tTotal;
583         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
584         return (rSupply, tSupply);
585     }
586 
587     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
588         _redisFeeOnBuy = redisFeeOnBuy;
589         _redisFeeOnSell = redisFeeOnSell;
590         _taxFeeOnBuy = taxFeeOnBuy;
591         _taxFeeOnSell = taxFeeOnSell;
592     }
593 
594     //Set minimum tokens required to swap.
595     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
596         _swapTokensAtAmount = swapTokensAtAmount;
597     }
598 
599     //Set minimum tokens required to swap.
600     function toggleSwap(bool _swapEnabled) public onlyOwner {
601         swapEnabled = _swapEnabled;
602     }
603 
604     //Set maximum transaction
605     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
606         _maxTxAmount = maxTxAmount;
607     }
608 
609     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
610         _maxWalletSize = maxWalletSize;
611     }
612 
613     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
614         for(uint256 i = 0; i < accounts.length; i++) {
615             _isExcludedFromFee[accounts[i]] = excluded;
616         }
617     }
618 
619 }