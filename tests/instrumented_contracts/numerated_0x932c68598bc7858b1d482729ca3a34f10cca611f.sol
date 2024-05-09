1 /*
2 *
3 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⣤⣤⣤⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 *⠀⠀⠀⠀⠀⠀⣰⣾⣷⣾⡿⠛⠛⠛⠉⣻⣿⠿⢿⣯⣝⢿⣿⠷⣦⣄⠀⠀⠀⠀⠀⠀⠀
5 *⠀⠀⠀⠀⢀⣼⣿⠛⠉⠙⠿⠦⠀⠀⠀⠉⠁⠀⢀⣈⠙⠿⣿⡀⠈⠙⢿⣦⠀⠀⠀⠀⠀
6 *⠀⠀⠀⢠⣾⣿⠃⠀⠀⢀⣀⡀⠀⠀⠀⠀⣠⠊⠉⠈⠉⠢⠈⠻⣦⡀⠀⠙⣷⡄⠀⠀⠀
7 *⠀⠀⠀⣿⠃⠀⠀⢠⠞⠁⠈⠉⠳⡄⠀⠀⠃⠀⢀⣠⣤⣄⡀⠀⠙⣷⠀⠀⠈⣿⣤⣄⡀
8 *⠀⠀⢸⣟⠀⠀⠀⠇⠀⢀⣀⣤⣀⠀⠀⠀⢠⡞⠉⠉⣿⣿⣷⠀⠀⢹⡇⣠⡾⠋⠁⠙⣷
9 *⠀⠀⠀⣿⡀⠀⠀⢀⡾⠉⠉⢻⣿⣷⠀⠀⠸⣷⣤⣴⣿⡿⠃⠀⠀⢸⣷⠏⠀⠀⠀⠀⣿
10 *⠀⠀⠀⢹⣷⡴⠂⠸⣧⣤⣴⣿⡿⠃⠀⠀⠀⠈⠙⠋⠉⠀⠀⠀⠀⢸⠃⠀⠀⠀⠀⢀⡿
11 *⠀⠀⣴⡟⠁⠀⠀⠀⠈⠙⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢤⣄⣀⣠⡾⠃
12 *⠀⣰⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠉⠁⠀⠀
13 *⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⣰⠞⠉⠁⠈⠻⣦⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⠁⠀⠀⠀⠀
14 *⠀⢻⣇⠀⠀⠀⠀⠀⠀⠀⣼⠃⠀⠀⠀⠀⠀⠸⡇⠀⠀⠀⠀⠀⣠⡼⠟⢳⣄⠀⠀⠀⠀
15 *⠀⠈⢿⣆⠀⠀⠀⠀⠀⠀⣿⡀⠀⠀⠀⠀⠀⣰⠇⢀⣀⣤⡶⠟⠋⠀⢀⠀⠹⣦⡀⠀⠀
16 *⠀⠀⣠⡿⠷⢶⣤⣤⣀⣀⣈⣷⣦⣤⠤⠶⠾⠟⠛⠋⠉⠀⠀⠀⠀⠀⢸⠀⠀⠈⢻⡦⠀
17 *⣠⡾⠋⠀⠀⢠⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⣠⡴⠛⠁⠀
18 *⠉⠳⣦⣄⣀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠟⠋⣧⠀⠀⠀
19 *⠀⣸⠃⠀⣽⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⣸⡇⠀⠀
20 *⠀⠙⠷⣤⡟⠀⠀⠀⢀⣠⣄⠀⠀⠀⠀⢀⣤⢤⡀⠀⠀⠀⢀⠀⠀⠀⢸⣧⡾⠋⠀⠀⠀
21 *⠀⠀⠀⢸⡧⠠⠤⠞⠋⠁⠈⠧⣄⡤⠞⠋⠀⠀⠹⣀⣠⠔⠉⠑⠦⠴⠋⣿⠀⠀⠀⠀⠀
22 *⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠐⠒⠲⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡇⠀⠀⠀⠀
23 *⠀⠀⠀⠘⠷⣤⣤⣄⣀⣀⣀⣀⣀⣀⣠⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡷⠀⠀⠀⠀
24 *⠀⠀⠀⠀⠀⠀⠀⢻⡈⠉⠉⣽⠉⠉⠀⠙⠓⠶⠶⣶⠶⠶⠶⠶⡟⠛⠉⠁⠀⠀⠀⠀⠀
25 *⠀⠀⠀⠀⠀⠀⠀⠀⢷⠤⠄⡇⠀⠀⠀⠀⠀⠀⠀⠸⡦⠤⠤⢴⠇⠀⠀⠀⠀⠀⠀⠀⠀
26 *⠀⠀⠀⠀⠀⠀⠀⢀⣈⣷⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⢻⣄⠀⣸⣄⡀⠀⠀⠀⠀⠀⠀⠀
27 *⠀⠀⠀⠀⠀⠀⣾⣉⣀⣠⣤⠽⠀⠀⠀⠀⠀⠀⠀⠀⠸⠯⣭⣤⣤⣽⡶⠀⠀⠀⠀⠀⠀
28 *
29 */
30 
31 
32 
33 
34 // SPDX-License-Identifier: Unlicensed
35 pragma solidity ^0.8.18;
36  
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 }
42  
43 interface IERC20 {
44     function totalSupply() external view returns (uint256);
45  
46     function balanceOf(address account) external view returns (uint256);
47  
48     function transfer(address recipient, uint256 amount) external returns (bool);
49  
50     function allowance(address owner, address spender) external view returns (uint256);
51  
52     function approve(address spender, uint256 amount) external returns (bool);
53  
54     function transferFrom(
55         address sender,
56         address recipient,
57         uint256 amount
58     ) external returns (bool);
59  
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(
62         address indexed owner,
63         address indexed spender,
64         uint256 value
65     );
66 }
67  
68 contract Ownable is Context {
69     address private _owner;
70     address private _previousOwner;
71     event OwnershipTransferred(
72         address indexed previousOwner,
73         address indexed newOwner
74     );
75  
76     constructor() {
77         address msgSender = _msgSender();
78         _owner = msgSender;
79         emit OwnershipTransferred(address(0), msgSender);
80     }
81  
82     function owner() public view returns (address) {
83         return _owner;
84     }
85  
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90  
91     function renounceOwnership() public virtual onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95  
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101  
102 }
103  
104 library SafeMath {
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108         return c;
109     }
110  
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return sub(a, b, "SafeMath: subtraction overflow");
113     }
114  
115     function sub(
116         uint256 a,
117         uint256 b,
118         string memory errorMessage
119     ) internal pure returns (uint256) {
120         require(b <= a, errorMessage);
121         uint256 c = a - b;
122         return c;
123     }
124  
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         if (a == 0) {
127             return 0;
128         }
129         uint256 c = a * b;
130         require(c / a == b, "SafeMath: multiplication overflow");
131         return c;
132     }
133  
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137  
138     function div(
139         uint256 a,
140         uint256 b,
141         string memory errorMessage
142     ) internal pure returns (uint256) {
143         require(b > 0, errorMessage);
144         uint256 c = a / b;
145         return c;
146     }
147 }
148  
149 interface IUniswapV2Factory {
150     function createPair(address tokenA, address tokenB)
151         external
152         returns (address pair);
153 }
154  
155 interface IUniswapV2Router02 {
156     function swapExactTokensForETHSupportingFeeOnTransferTokens(
157         uint256 amountIn,
158         uint256 amountOutMin,
159         address[] calldata path,
160         address to,
161         uint256 deadline
162     ) external;
163  
164     function factory() external pure returns (address);
165  
166     function WETH() external pure returns (address);
167  
168     function addLiquidityETH(
169         address token,
170         uint256 amountTokenDesired,
171         uint256 amountTokenMin,
172         uint256 amountETHMin,
173         address to,
174         uint256 deadline
175     )
176         external
177         payable
178         returns (
179             uint256 amountToken,
180             uint256 amountETH,
181             uint256 liquidity
182         );
183 }
184  
185 contract SHINCHAN is Context, IERC20, Ownable {
186  
187     using SafeMath for uint256;
188  
189     string private constant _name = "SHINCHAN";
190     string private constant _symbol = "SHINCHAN";
191     uint8 private constant _decimals = 9;
192  
193     mapping(address => uint256) private _rOwned;
194     mapping(address => uint256) private _tOwned;
195     mapping(address => mapping(address => uint256)) private _allowances;
196     mapping(address => bool) private _isExcludedFromFee;
197     uint256 private constant MAX = ~uint256(0);
198     uint256 private constant _tTotal = 1000000000 * 10**9;
199     uint256 private _rTotal = (MAX - (MAX % _tTotal));
200     uint256 private _tFeeTotal;
201     uint256 private _redisFeeOnBuy = 0;  
202     uint256 private _taxFeeOnBuy = 5;  
203     uint256 private _redisFeeOnSell = 0;  
204     uint256 private _taxFeeOnSell = 45;
205  
206     //Original Fee
207     uint256 private _redisFee = _redisFeeOnSell;
208     uint256 private _taxFee = _taxFeeOnSell;
209  
210     uint256 private _previousredisFee = _redisFee;
211     uint256 private _previoustaxFee = _taxFee;
212  
213     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
214     address payable private _developmentAddress = payable(0x260C04c1A563F19Ef056a137049E0E873ca4B2d9); 
215     address payable private _marketingAddress = payable(0x260C04c1A563F19Ef056a137049E0E873ca4B2d9);
216  
217     IUniswapV2Router02 public uniswapV2Router;
218     address public uniswapV2Pair;
219  
220     bool private tradingOpen;
221     bool private inSwap = false;
222     bool private swapEnabled = true;
223  
224     uint256 public _maxTxAmount = 10000000 * 10**9; 
225     uint256 public _maxWalletSize = 10000000 * 10**9; 
226     uint256 public _swapTokensAtAmount = 10000 * 10**9;
227  
228     event MaxTxAmountUpdated(uint256 _maxTxAmount);
229     modifier lockTheSwap {
230         inSwap = true;
231         _;
232         inSwap = false;
233     }
234  
235     constructor() {
236  
237         _rOwned[_msgSender()] = _rTotal;
238  
239         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
240         uniswapV2Router = _uniswapV2Router;
241         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
242             .createPair(address(this), _uniswapV2Router.WETH());
243  
244         _isExcludedFromFee[owner()] = true;
245         _isExcludedFromFee[address(this)] = true;
246         _isExcludedFromFee[_developmentAddress] = true;
247         _isExcludedFromFee[_marketingAddress] = true;
248  
249         emit Transfer(address(0), _msgSender(), _tTotal);
250     }
251  
252     function name() public pure returns (string memory) {
253         return _name;
254     }
255  
256     function symbol() public pure returns (string memory) {
257         return _symbol;
258     }
259  
260     function decimals() public pure returns (uint8) {
261         return _decimals;
262     }
263  
264     function totalSupply() public pure override returns (uint256) {
265         return _tTotal;
266     }
267  
268     function balanceOf(address account) public view override returns (uint256) {
269         return tokenFromReflection(_rOwned[account]);
270     }
271  
272     function transfer(address recipient, uint256 amount)
273         public
274         override
275         returns (bool)
276     {
277         _transfer(_msgSender(), recipient, amount);
278         return true;
279     }
280  
281     function allowance(address owner, address spender)
282         public
283         view
284         override
285         returns (uint256)
286     {
287         return _allowances[owner][spender];
288     }
289  
290     function approve(address spender, uint256 amount)
291         public
292         override
293         returns (bool)
294     {
295         _approve(_msgSender(), spender, amount);
296         return true;
297     }
298  
299     function transferFrom(
300         address sender,
301         address recipient,
302         uint256 amount
303     ) public override returns (bool) {
304         _transfer(sender, recipient, amount);
305         _approve(
306             sender,
307             _msgSender(),
308             _allowances[sender][_msgSender()].sub(
309                 amount,
310                 "ERC20: transfer amount exceeds allowance"
311             )
312         );
313         return true;
314     }
315  
316     function tokenFromReflection(uint256 rAmount)
317         private
318         view
319         returns (uint256)
320     {
321         require(
322             rAmount <= _rTotal,
323             "Amount must be less than total reflections"
324         );
325         uint256 currentRate = _getRate();
326         return rAmount.div(currentRate);
327     }
328  
329     function removeAllFee() private {
330         if (_redisFee == 0 && _taxFee == 0) return;
331  
332         _previousredisFee = _redisFee;
333         _previoustaxFee = _taxFee;
334  
335         _redisFee = 0;
336         _taxFee = 0;
337     }
338  
339     function restoreAllFee() private {
340         _redisFee = _previousredisFee;
341         _taxFee = _previoustaxFee;
342     }
343  
344     function _approve(
345         address owner,
346         address spender,
347         uint256 amount
348     ) private {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351         _allowances[owner][spender] = amount;
352         emit Approval(owner, spender, amount);
353     }
354  
355     function _transfer(
356         address from,
357         address to,
358         uint256 amount
359     ) private {
360         require(from != address(0), "ERC20: transfer from the zero address");
361         require(to != address(0), "ERC20: transfer to the zero address");
362         require(amount > 0, "Transfer amount must be greater than zero");
363  
364         if (from != owner() && to != owner()) {
365  
366             //Trade start check
367             if (!tradingOpen) {
368                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
369             }
370  
371             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
372             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
373  
374             if(to != uniswapV2Pair) {
375                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
376             }
377  
378             uint256 contractTokenBalance = balanceOf(address(this));
379             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
380  
381             if(contractTokenBalance >= _maxTxAmount)
382             {
383                 contractTokenBalance = _maxTxAmount;
384             }
385  
386             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
387                 swapTokensForEth(contractTokenBalance);
388                 uint256 contractETHBalance = address(this).balance;
389                 if (contractETHBalance > 0) {
390                     sendETHToFee(address(this).balance);
391                 }
392             }
393         }
394  
395         bool takeFee = true;
396  
397         //Transfer Tokens
398         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
399             takeFee = false;
400         } else {
401  
402             //Set Fee for Buys
403             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
404                 _redisFee = _redisFeeOnBuy;
405                 _taxFee = _taxFeeOnBuy;
406             }
407  
408             //Set Fee for Sells
409             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
410                 _redisFee = _redisFeeOnSell;
411                 _taxFee = _taxFeeOnSell;
412             }
413  
414         }
415  
416         _tokenTransfer(from, to, amount, takeFee);
417     }
418  
419     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
420         address[] memory path = new address[](2);
421         path[0] = address(this);
422         path[1] = uniswapV2Router.WETH();
423         _approve(address(this), address(uniswapV2Router), tokenAmount);
424         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
425             tokenAmount,
426             0,
427             path,
428             address(this),
429             block.timestamp
430         );
431     }
432  
433     function sendETHToFee(uint256 amount) private {
434         _marketingAddress.transfer(amount);
435     }
436  
437     function setTrading(bool _tradingOpen) public onlyOwner {
438         tradingOpen = _tradingOpen;
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
524         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
525     }
526  
527     function _getTValues(
528         uint256 tAmount,
529         uint256 redisFee,
530         uint256 taxFee
531     )
532         private
533         pure
534         returns (
535             uint256,
536             uint256,
537             uint256
538         )
539     {
540         uint256 tFee = tAmount.mul(redisFee).div(100);
541         uint256 tTeam = tAmount.mul(taxFee).div(100);
542         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
543         return (tTransferAmount, tFee, tTeam);
544     }
545  
546     function _getRValues(
547         uint256 tAmount,
548         uint256 tFee,
549         uint256 tTeam,
550         uint256 currentRate
551     )
552         private
553         pure
554         returns (
555             uint256,
556             uint256,
557             uint256
558         )
559     {
560         uint256 rAmount = tAmount.mul(currentRate);
561         uint256 rFee = tFee.mul(currentRate);
562         uint256 rTeam = tTeam.mul(currentRate);
563         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
564         return (rAmount, rTransferAmount, rFee);
565     }
566  
567     function _getRate() private view returns (uint256) {
568         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
569         return rSupply.div(tSupply);
570     }
571  
572     function _getCurrentSupply() private view returns (uint256, uint256) {
573         uint256 rSupply = _rTotal;
574         uint256 tSupply = _tTotal;
575         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
576         return (rSupply, tSupply);
577     }
578  
579     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
580         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
581         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 98, "Buy tax must be between 0% and 98%");
582         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
583         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 98, "Sell tax must be between 0% and 98%");
584 
585         _redisFeeOnBuy = redisFeeOnBuy;
586         _redisFeeOnSell = redisFeeOnSell;
587         _taxFeeOnBuy = taxFeeOnBuy;
588         _taxFeeOnSell = taxFeeOnSell;
589 
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
602     //Set maximum transaction
603     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
604            _maxTxAmount = maxTxAmount;
605         
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
617 
618 }