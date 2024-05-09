1 /**
2 FOR IMMEDIATE RELEASE
3 
4 "DeSantis Wins the Presidential Race to the White House"
5 Washington, D.C. – November 6, 2024
6 
7 The American people have cast their votes, and the results are in. Governor Ron DeSantis of Florida has secured his place as the 47th President of the United States, marking an historic election that captivated the nation.
8 
9 Governor DeSantis, a proud advocate for fiscal responsibility and personal freedom, campaigned on a platform of economic growth, technological innovation, and American unity. His victory is a reflection of the country's desire for strong leadership and a prosperous future.
10 
11 A key element of the DeSantis campaign was an emphasis on the importance of technology and innovation in driving America's future. This focus was exemplified by a high-profile endorsement from Elon Musk, the owner of Twitter and CEO of SpaceX and Tesla. Musk, a visionary in the tech industry with over 140 million Twitter followers, rallied his vast online community in support of DeSantis, emphasizing their shared commitment to fostering innovation and entrepreneurship in the United States​1​.
12 
13 "Elon Musk's endorsement of our campaign underscores our shared belief that the future of America lies in its ability to innovate and adapt," said President-elect DeSantis. "Our nation has always been at the forefront of technological advances, and we plan to keep it that way."
14 
15 President-elect DeSantis has promised to work closely with leaders in the tech industry, including Musk, to ensure that American innovation continues to thrive. His administration plans to invest in infrastructure, education, and policies that will foster a business-friendly environment where entrepreneurs and companies can thrive.
16 
17 The DeSantis administration also plans to strengthen America's position in the global economy and build on the progress made in recent years. "We are committed to making America the best place in the world to start and grow a business. This is how we ensure that our nation remains a beacon of opportunity and prosperity," DeSantis said.
18 
19 The inauguration of President-elect DeSantis is scheduled for January 20, 2025. The DeSantis team extends its heartfelt thanks to all Americans for their support and looks forward to serving the nation over the next four years.
20 
21 About the DeSantis Campaign:
22 
23 The DeSantis Campaign is committed to fostering a prosperous, united, and innovative America. Governor Ron DeSantis, now President-elect, has dedicated his career to serving the people of Florida and now aims to serve all Americans. He believes in the power of free markets, personal freedom, and American innovation to shape a brighter future for all.
24 
25 //How DeSantis won the race//
26 Governor Ron DeSantis's win in the 2024 Presidential race was significantly boosted by the endorsement of Elon Musk, one of the most influential figures in the tech industry. Musk's support, leveraged through his vast online presence with over 140 million Twitter followers, amplified DeSantis's campaign messages and connected them to a diverse, global audience. 
27 Musk's endorsement also underscored DeSantis's commitment to technological innovation, entrepreneurship, and a forward-looking economic policy, which resonated with a broad base of voters seeking strong and innovative leadership for the future of the United States. This, in turn, solidified DeSantis's standing among voters, ultimately contributing to his victory.
28 
29 https://twitter.com/BillMelugin_/status/1661071316664094720?s=20
30 https://www.foxnews.com/politics/florida-gov-ron-desantis-announce-candidacy-president-wednesday-twitter-sources
31 
32 //Socials + Website will be broadcast via Immutable messages to the deployer. 
33 // 0% Tax after renounce
34 
35 */
36 
37 // SPDX-License-Identifier: MIT
38 pragma solidity ^0.8.9;
39 
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address) {
42         return msg.sender;
43     }
44 }
45 
46 interface IERC20 {
47     function totalSupply() external view returns (uint256);
48 
49     function balanceOf(address account) external view returns (uint256);
50 
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     function transferFrom(
58         address sender,
59         address recipient,
60         uint256 amount
61     ) external returns (bool);
62 
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(
65         address indexed owner,
66         address indexed spender,
67         uint256 value
68     );
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73     address private _previousOwner;
74     event OwnershipTransferred(
75         address indexed previousOwner,
76         address indexed newOwner
77     );
78 
79     constructor() {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         emit OwnershipTransferred(_owner, newOwner);
102         _owner = newOwner;
103     }
104 
105 }
106 
107 library SafeMath {
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111         return c;
112     }
113 
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117 
118     function sub(
119         uint256 a,
120         uint256 b,
121         string memory errorMessage
122     ) internal pure returns (uint256) {
123         require(b <= a, errorMessage);
124         uint256 c = a - b;
125         return c;
126     }
127 
128     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129         if (a == 0) {
130             return 0;
131         }
132         uint256 c = a * b;
133         require(c / a == b, "SafeMath: multiplication overflow");
134         return c;
135     }
136 
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return div(a, b, "SafeMath: division by zero");
139     }
140 
141     function div(
142         uint256 a,
143         uint256 b,
144         string memory errorMessage
145     ) internal pure returns (uint256) {
146         require(b > 0, errorMessage);
147         uint256 c = a / b;
148         return c;
149     }
150 }
151 
152 interface IUniswapV2Factory {
153     function createPair(address tokenA, address tokenB)
154         external
155         returns (address pair);
156 }
157 
158 interface IUniswapV2Router02 {
159     function swapExactTokensForETHSupportingFeeOnTransferTokens(
160         uint256 amountIn,
161         uint256 amountOutMin,
162         address[] calldata path,
163         address to,
164         uint256 deadline
165     ) external;
166 
167     function factory() external pure returns (address);
168 
169     function WETH() external pure returns (address);
170 
171     function addLiquidityETH(
172         address token,
173         uint256 amountTokenDesired,
174         uint256 amountTokenMin,
175         uint256 amountETHMin,
176         address to,
177         uint256 deadline
178     )
179         external
180         payable
181         returns (
182             uint256 amountToken,
183             uint256 amountETH,
184             uint256 liquidity
185         );
186 }
187 
188 contract PresidentRonDeSantis  is Context, IERC20, Ownable {
189 
190     using SafeMath for uint256;
191 
192     string private constant _name = "President Ron DeSantis";
193     string private constant _symbol = "RON";
194     uint8 private constant _decimals = 9;
195 
196     mapping(address => uint256) private _rOwned;
197     mapping(address => uint256) private _tOwned;
198     mapping(address => mapping(address => uint256)) private _allowances;
199     mapping(address => bool) private _isExcludedFromFee;
200     uint256 private constant MAX = ~uint256(0);
201     uint256 private constant _tTotal = 1000000000 * 10**9;
202     uint256 private _rTotal = (MAX - (MAX % _tTotal));
203     uint256 private _tFeeTotal;
204     uint256 private _redisFeeOnBuy = 0;
205     uint256 private _taxFeeOnBuy = 3;
206     uint256 private _redisFeeOnSell = 0;
207     uint256 private _taxFeeOnSell = 3;
208 
209     //Original Fee
210     uint256 private _redisFee = _redisFeeOnSell;
211     uint256 private _taxFee = _taxFeeOnSell;
212 
213     uint256 private _previousredisFee = _redisFee;
214     uint256 private _previoustaxFee = _taxFee;
215 
216     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
217     address payable private _developmentAddress = payable(0x16b769993338d257da8b332206ceE6f7eF86a692);
218     address payable private _marketingAddress = payable(0x16b769993338d257da8b332206ceE6f7eF86a692);
219 
220     IUniswapV2Router02 public uniswapV2Router;
221     address public uniswapV2Pair;
222 
223     bool private tradingOpen;
224     bool private inSwap = false;
225     bool private swapEnabled = true;
226 
227     uint256 public _maxTxAmount = 30000000 * 10**9;
228     uint256 public _maxWalletSize = 30000000 * 10**9;
229     uint256 public _swapTokensAtAmount = 10000 * 10**9;
230 
231     event MaxTxAmountUpdated(uint256 _maxTxAmount);
232     modifier lockTheSwap {
233         inSwap = true;
234         _;
235         inSwap = false;
236     }
237 
238     constructor() {
239 
240         _rOwned[_msgSender()] = _rTotal;
241 
242         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
243         uniswapV2Router = _uniswapV2Router;
244         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
245             .createPair(address(this), _uniswapV2Router.WETH());
246 
247         _isExcludedFromFee[owner()] = true;
248         _isExcludedFromFee[address(this)] = true;
249         _isExcludedFromFee[_developmentAddress] = true;
250         _isExcludedFromFee[_marketingAddress] = true;
251 
252         emit Transfer(address(0), _msgSender(), _tTotal);
253     }
254 
255     function name() public pure returns (string memory) {
256         return _name;
257     }
258 
259     function symbol() public pure returns (string memory) {
260         return _symbol;
261     }
262 
263     function decimals() public pure returns (uint8) {
264         return _decimals;
265     }
266 
267     function totalSupply() public pure override returns (uint256) {
268         return _tTotal;
269     }
270 
271     function balanceOf(address account) public view override returns (uint256) {
272         return tokenFromReflection(_rOwned[account]);
273     }
274 
275     function transfer(address recipient, uint256 amount)
276         public
277         override
278         returns (bool)
279     {
280         _transfer(_msgSender(), recipient, amount);
281         return true;
282     }
283 
284     function allowance(address owner, address spender)
285         public
286         view
287         override
288         returns (uint256)
289     {
290         return _allowances[owner][spender];
291     }
292 
293     function approve(address spender, uint256 amount)
294         public
295         override
296         returns (bool)
297     {
298         _approve(_msgSender(), spender, amount);
299         return true;
300     }
301 
302     function transferFrom(
303         address sender,
304         address recipient,
305         uint256 amount
306     ) public override returns (bool) {
307         _transfer(sender, recipient, amount);
308         _approve(
309             sender,
310             _msgSender(),
311             _allowances[sender][_msgSender()].sub(
312                 amount,
313                 "ERC20: transfer amount exceeds allowance"
314             )
315         );
316         return true;
317     }
318 
319     function tokenFromReflection(uint256 rAmount)
320         private
321         view
322         returns (uint256)
323     {
324         require(
325             rAmount <= _rTotal,
326             "Amount must be less than total reflections"
327         );
328         uint256 currentRate = _getRate();
329         return rAmount.div(currentRate);
330     }
331 
332     function removeAllFee() private {
333         if (_redisFee == 0 && _taxFee == 0) return;
334 
335         _previousredisFee = _redisFee;
336         _previoustaxFee = _taxFee;
337 
338         _redisFee = 0;
339         _taxFee = 0;
340     }
341 
342     function restoreAllFee() private {
343         _redisFee = _previousredisFee;
344         _taxFee = _previoustaxFee;
345     }
346 
347     function _approve(
348         address owner,
349         address spender,
350         uint256 amount
351     ) private {
352         require(owner != address(0), "ERC20: approve from the zero address");
353         require(spender != address(0), "ERC20: approve to the zero address");
354         _allowances[owner][spender] = amount;
355         emit Approval(owner, spender, amount);
356     }
357 
358     function _transfer(
359         address from,
360         address to,
361         uint256 amount
362     ) private {
363         require(from != address(0), "ERC20: transfer from the zero address");
364         require(to != address(0), "ERC20: transfer to the zero address");
365         require(amount > 0, "Transfer amount must be greater than zero");
366 
367         if (from != owner() && to != owner()) {
368 
369             //Trade start check
370             if (!tradingOpen) {
371                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
372             }
373 
374             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
375             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
376 
377             if(to != uniswapV2Pair) {
378                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
379             }
380 
381             uint256 contractTokenBalance = balanceOf(address(this));
382             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
383 
384             if(contractTokenBalance >= _maxTxAmount)
385             {
386                 contractTokenBalance = _maxTxAmount;
387             }
388 
389             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
390                 swapTokensForEth(contractTokenBalance);
391                 uint256 contractETHBalance = address(this).balance;
392                 if (contractETHBalance > 0) {
393                     sendETHToFee(address(this).balance);
394                 }
395             }
396         }
397 
398         bool takeFee = true;
399 
400         //Transfer Tokens
401         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
402             takeFee = false;
403         } else {
404 
405             //Set Fee for Buys
406             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
407                 _redisFee = _redisFeeOnBuy;
408                 _taxFee = _taxFeeOnBuy;
409             }
410 
411             //Set Fee for Sells
412             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
413                 _redisFee = _redisFeeOnSell;
414                 _taxFee = _taxFeeOnSell;
415             }
416 
417         }
418 
419         _tokenTransfer(from, to, amount, takeFee);
420     }
421 
422     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
423         address[] memory path = new address[](2);
424         path[0] = address(this);
425         path[1] = uniswapV2Router.WETH();
426         _approve(address(this), address(uniswapV2Router), tokenAmount);
427         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
428             tokenAmount,
429             0,
430             path,
431             address(this),
432             block.timestamp
433         );
434     }
435 
436     function sendETHToFee(uint256 amount) private {
437         _marketingAddress.transfer(amount);
438     }
439 
440     function setTrading(bool _tradingOpen) public onlyOwner {
441         tradingOpen = _tradingOpen;
442     }
443 
444     function manualswap() external {
445         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
446         uint256 contractBalance = balanceOf(address(this));
447         swapTokensForEth(contractBalance);
448     }
449 
450     function manualsend() external {
451         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
452         uint256 contractETHBalance = address(this).balance;
453         sendETHToFee(contractETHBalance);
454     }
455 
456     function blockBots(address[] memory bots_) public onlyOwner {
457         for (uint256 i = 0; i < bots_.length; i++) {
458             bots[bots_[i]] = true;
459         }
460     }
461 
462     function unblockBot(address notbot) public onlyOwner {
463         bots[notbot] = false;
464     }
465 
466     function _tokenTransfer(
467         address sender,
468         address recipient,
469         uint256 amount,
470         bool takeFee
471     ) private {
472         if (!takeFee) removeAllFee();
473         _transferStandard(sender, recipient, amount);
474         if (!takeFee) restoreAllFee();
475     }
476 
477     function _transferStandard(
478         address sender,
479         address recipient,
480         uint256 tAmount
481     ) private {
482         (
483             uint256 rAmount,
484             uint256 rTransferAmount,
485             uint256 rFee,
486             uint256 tTransferAmount,
487             uint256 tFee,
488             uint256 tTeam
489         ) = _getValues(tAmount);
490         _rOwned[sender] = _rOwned[sender].sub(rAmount);
491         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
492         _takeTeam(tTeam);
493         _reflectFee(rFee, tFee);
494         emit Transfer(sender, recipient, tTransferAmount);
495     }
496 
497     function _takeTeam(uint256 tTeam) private {
498         uint256 currentRate = _getRate();
499         uint256 rTeam = tTeam.mul(currentRate);
500         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
501     }
502 
503     function _reflectFee(uint256 rFee, uint256 tFee) private {
504         _rTotal = _rTotal.sub(rFee);
505         _tFeeTotal = _tFeeTotal.add(tFee);
506     }
507 
508     receive() external payable {}
509 
510     function _getValues(uint256 tAmount)
511         private
512         view
513         returns (
514             uint256,
515             uint256,
516             uint256,
517             uint256,
518             uint256,
519             uint256
520         )
521     {
522         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
523             _getTValues(tAmount, _redisFee, _taxFee);
524         uint256 currentRate = _getRate();
525         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
526             _getRValues(tAmount, tFee, tTeam, currentRate);
527         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
528     }
529 
530     function _getTValues(
531         uint256 tAmount,
532         uint256 redisFee,
533         uint256 taxFee
534     )
535         private
536         pure
537         returns (
538             uint256,
539             uint256,
540             uint256
541         )
542     {
543         uint256 tFee = tAmount.mul(redisFee).div(100);
544         uint256 tTeam = tAmount.mul(taxFee).div(100);
545         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
546         return (tTransferAmount, tFee, tTeam);
547     }
548 
549     function _getRValues(
550         uint256 tAmount,
551         uint256 tFee,
552         uint256 tTeam,
553         uint256 currentRate
554     )
555         private
556         pure
557         returns (
558             uint256,
559             uint256,
560             uint256
561         )
562     {
563         uint256 rAmount = tAmount.mul(currentRate);
564         uint256 rFee = tFee.mul(currentRate);
565         uint256 rTeam = tTeam.mul(currentRate);
566         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
567         return (rAmount, rTransferAmount, rFee);
568     }
569 
570     function _getRate() private view returns (uint256) {
571         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
572         return rSupply.div(tSupply);
573     }
574 
575     function _getCurrentSupply() private view returns (uint256, uint256) {
576         uint256 rSupply = _rTotal;
577         uint256 tSupply = _tTotal;
578         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
579         return (rSupply, tSupply);
580     }
581 
582     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
583         _redisFeeOnBuy = redisFeeOnBuy;
584         _redisFeeOnSell = redisFeeOnSell;
585         _taxFeeOnBuy = taxFeeOnBuy;
586         _taxFeeOnSell = taxFeeOnSell;
587     }
588 
589     //Set minimum tokens required to swap.
590     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
591         _swapTokensAtAmount = swapTokensAtAmount;
592     }
593 
594     //Set minimum tokens required to swap.
595     function toggleSwap(bool _swapEnabled) public onlyOwner {
596         swapEnabled = _swapEnabled;
597     }
598 
599     //Set maximum transaction
600     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
601         _maxTxAmount = maxTxAmount;
602     }
603 
604     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
605         _maxWalletSize = maxWalletSize;
606     }
607 
608     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
609         for(uint256 i = 0; i < accounts.length; i++) {
610             _isExcludedFromFee[accounts[i]] = excluded;
611         }
612     }
613 
614 }