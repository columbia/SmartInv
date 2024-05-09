1 /*
2 https://lettucehands.rip/
3 
4 https://t.me/lettucehandsETH
5 
6 https://twitter.com/lettucehandsETH
7 
8 
9 ██╗     ███████╗████████╗████████╗██╗   ██╗ ██████╗███████╗    ██╗  ██╗ █████╗ ███╗   ██╗██████╗ ███████╗
10 ██║     ██╔════╝╚══██╔══╝╚══██╔══╝██║   ██║██╔════╝██╔════╝    ██║  ██║██╔══██╗████╗  ██║██╔══██╗██╔════╝
11 ██║     █████╗     ██║      ██║   ██║   ██║██║     █████╗      ███████║███████║██╔██╗ ██║██║  ██║███████╗
12 ██║     ██╔══╝     ██║      ██║   ██║   ██║██║     ██╔══╝      ██╔══██║██╔══██║██║╚██╗██║██║  ██║╚════██║
13 ███████╗███████╗   ██║      ██║   ╚██████╔╝╚██████╗███████╗    ██║  ██║██║  ██║██║ ╚████║██████╔╝███████║
14 ╚══════╝╚══════╝   ╚═╝      ╚═╝    ╚═════╝  ╚═════╝╚══════╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝
15                                                                                                          
16 
17       _                                                        .          
18    ___/   ___    ___.   ___  , __     ____        __.  , __    |   ,    . 
19   /   | .'   ` .'   ` .'   ` |'  `.  (          .'   \ |'  `.  |   |    ` 
20  ,'   | |----' |    | |----' |    |  `--.       |    | |    |  |   |    | 
21  `___,' `.___,  `---| `.___, /    | \___.'       `._.' /    | /\__  `---|.
22       `         \___/                                               \___/ 
23 
24 */
25 
26 // pragma solidity ^0.8.9; 
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 }
33 
34 interface IERC20 {
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address account) external view returns (uint256);
38 
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     function approve(address spender, uint256 amount) external returns (bool);
44 
45     function transferFrom(
46         address sender,
47         address recipient,
48         uint256 amount
49     ) external returns (bool);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(
53         address indexed owner,
54         address indexed spender,
55         uint256 value
56     );
57 }
58 
59 contract Ownable is Context {
60     address private _owner;
61     address private _previousOwner;
62     event OwnershipTransferred(
63         address indexed previousOwner,
64         address indexed newOwner
65     );
66 
67     constructor() {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 
93 }
94 
95 library SafeMath {
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99         return c;
100     }
101 
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         return sub(a, b, "SafeMath: subtraction overflow");
104     }
105 
106     function sub(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b <= a, errorMessage);
112         uint256 c = a - b;
113         return c;
114     }
115 
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) {
118             return 0;
119         }
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128 
129     function div(
130         uint256 a,
131         uint256 b,
132         string memory errorMessage
133     ) internal pure returns (uint256) {
134         require(b > 0, errorMessage);
135         uint256 c = a / b;
136         return c;
137     }
138 }
139 
140 interface IUniswapV2Factory {
141     function createPair(address tokenA, address tokenB)
142         external
143         returns (address pair);
144 }
145 
146 interface IUniswapV2Router02 {
147     function swapExactTokensForETHSupportingFeeOnTransferTokens(
148         uint256 amountIn,
149         uint256 amountOutMin,
150         address[] calldata path,
151         address to,
152         uint256 deadline
153     ) external;
154 
155     function factory() external pure returns (address);
156 
157     function WETH() external pure returns (address);
158 
159     function addLiquidityETH(
160         address token,
161         uint256 amountTokenDesired,
162         uint256 amountTokenMin,
163         uint256 amountETHMin,
164         address to,
165         uint256 deadline
166     )
167         external
168         payable
169         returns (
170             uint256 amountToken,
171             uint256 amountETH,
172             uint256 liquidity
173         );
174 }
175 
176 contract LettuceHands is Context, IERC20, Ownable {
177 
178     using SafeMath for uint256;
179 
180     string private constant _name = "lettuce hands";
181     string private constant _symbol = "LHANDS";
182     uint8 private constant _decimals = 9;
183 
184     mapping(address => uint256) private _rOwned;
185     mapping(address => uint256) private _tOwned;
186     mapping(address => mapping(address => uint256)) private _allowances;
187     mapping(address => bool) private _isExcludedFromFee;
188     uint256 private constant MAX = ~uint256(0);
189     uint256 private constant _tTotal = 420000000000 * 10**9;
190     uint256 private _rTotal = (MAX - (MAX % _tTotal));
191     uint256 private _tFeeTotal;
192     uint256 private _redisFeeOnBuy = 0;
193     uint256 private _taxFeeOnBuy = 15;
194     uint256 private _redisFeeOnSell = 0;
195     uint256 private _taxFeeOnSell = 30;
196 
197     IUniswapV2Router02 public uniswapV2Router;
198     address public uniswapV2Pair;
199 
200     //Original Fee
201     uint256 private _redisFee = _redisFeeOnSell;
202     uint256 private _taxFee = _taxFeeOnSell;
203 
204     uint256 private _previousredisFee = _redisFee;
205     uint256 private _previoustaxFee = _taxFee;
206 
207     mapping (address => uint256) public _buyMap;
208     address payable private _marketingAddress = payable(0xe26F30e2405240d704b60a8D207Bb761039cC692);
209 
210     uint256 public _maxTxAmount = 10500000000 * 10**9;
211     uint256 public _maxWalletSize = 10500000000 * 10**9;
212     uint256 public _swapTokensAtAmount = 420000000 * 10**9;
213 
214     bool private tradingOpen = true;
215     bool private inSwap = false;
216     bool private swapEnabled = true;
217 
218     event MaxTxAmountUpdated(uint256 _maxTxAmount);
219     modifier lockTheSwap {
220         inSwap = true;
221         _;
222         inSwap = false;
223     }
224 
225     constructor() {
226 
227         _rOwned[_msgSender()] = _rTotal;
228 
229         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
230         uniswapV2Router = _uniswapV2Router;
231         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
232             .createPair(address(this), _uniswapV2Router.WETH());
233 
234         _isExcludedFromFee[owner()] = true;
235         _isExcludedFromFee[address(this)] = true;
236         _isExcludedFromFee[_marketingAddress] = true;
237 
238         emit Transfer(address(0), _msgSender(), _tTotal);
239     }
240 
241     function name() public pure returns (string memory) {
242         return _name;
243     }
244 
245     function symbol() public pure returns (string memory) {
246         return _symbol;
247     }
248 
249     function decimals() public pure returns (uint8) {
250         return _decimals;
251     }
252 
253     function totalSupply() public pure override returns (uint256) {
254         return _tTotal;
255     }
256 
257     function balanceOf(address account) public view override returns (uint256) {
258         return tokenFromReflection(_rOwned[account]);
259     }
260 
261     function transfer(address recipient, uint256 amount)
262         public
263         override
264         returns (bool)
265     {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269 
270     function allowance(address owner, address spender)
271         public
272         view
273         override
274         returns (uint256)
275     {
276         return _allowances[owner][spender];
277     }
278 
279     function approve(address spender, uint256 amount)
280         public
281         override
282         returns (bool)
283     {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287 
288     function transferFrom(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) public override returns (bool) {
293         _transfer(sender, recipient, amount);
294         _approve(
295             sender,
296             _msgSender(),
297             _allowances[sender][_msgSender()].sub(
298                 amount,
299                 "ERC20: transfer amount exceeds allowance"
300             )
301         );
302         return true;
303     }
304 
305     function tokenFromReflection(uint256 rAmount)
306         private
307         view
308         returns (uint256)
309     {
310         require(
311             rAmount <= _rTotal,
312             "Amount must be less than total reflections"
313         );
314         uint256 currentRate = _getRate();
315         return rAmount.div(currentRate);
316     }
317 
318     function removeAllFee() private {
319         if (_redisFee == 0 && _taxFee == 0) return;
320 
321         _previousredisFee = _redisFee;
322         _previoustaxFee = _taxFee;
323 
324         _redisFee = 0;
325         _taxFee = 0;
326     }
327 
328     function restoreAllFee() private {
329         _redisFee = _previousredisFee;
330         _taxFee = _previoustaxFee;
331     }
332 
333     function _approve(
334         address owner,
335         address spender,
336         uint256 amount
337     ) private {
338         require(owner != address(0), "ERC20: approve from the zero address");
339         require(spender != address(0), "ERC20: approve to the zero address");
340         _allowances[owner][spender] = amount;
341         emit Approval(owner, spender, amount);
342     }
343 
344     function _transfer(
345         address from,
346         address to,
347         uint256 amount
348     ) private {
349         require(from != address(0), "ERC20: transfer from the zero address");
350         require(to != address(0), "ERC20: transfer to the zero address");
351         require(amount > 0, "Transfer amount must be greater than zero");
352 
353         if (from != owner() && to != owner()) {
354 
355             //Trade start check
356             if (!tradingOpen) {
357                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
358             }
359 
360             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
361 
362             if(to != uniswapV2Pair) {
363                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
364             }
365 
366             uint256 contractTokenBalance = balanceOf(address(this));
367             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
368 
369             if(contractTokenBalance >= _maxTxAmount)
370             {
371                 contractTokenBalance = _maxTxAmount;
372             }
373 
374             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
375                 swapTokensForEth(contractTokenBalance);
376                 uint256 contractETHBalance = address(this).balance;
377                 if (contractETHBalance > 0) {
378                     sendETHToFee(address(this).balance);
379                 }
380             }
381         }
382 
383         bool takeFee = true;
384 
385         //Transfer Tokens
386         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
387             takeFee = false;
388         } else {
389 
390             //Set Fee for Buys
391             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
392                 _taxFee = _taxFeeOnBuy;
393                 _redisFee = _redisFeeOnBuy;
394             }
395 
396             //Set Fee for Sells
397             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
398                 _taxFee = _taxFeeOnSell;
399                 _redisFee = _redisFeeOnSell;
400             }
401 
402         }
403 
404         _tokenTransfer(from, to, amount, takeFee);
405     }
406 
407     function sendETHToFee(uint256 amount) private {
408         _marketingAddress.transfer(amount);
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
425     function manualswap() external {
426         require(_msgSender() == _marketingAddress);
427         uint256 contractBalance = balanceOf(address(this));
428         swapTokensForEth(contractBalance);
429     }
430 
431     function manualsend() external {
432         require(_msgSender() == _marketingAddress);
433         uint256 contractETHBalance = address(this).balance;
434         sendETHToFee(contractETHBalance);
435     }
436 
437     function startTrading(bool _tradingOpen) public onlyOwner {
438         tradingOpen = _tradingOpen;
439     }
440 
441     function _tokenTransfer(
442         address sender,
443         address recipient,
444         uint256 amount,
445         bool takeFee
446     ) private {
447         if (!takeFee) removeAllFee();
448         _transferStandard(sender, recipient, amount);
449         if (!takeFee) restoreAllFee();
450     }
451 
452     function _transferStandard(
453         address sender,
454         address recipient,
455         uint256 tAmount
456     ) private {
457         (
458             uint256 rAmount,
459             uint256 rTransferAmount,
460             uint256 rFee,
461             uint256 tTransferAmount,
462             uint256 tFee,
463             uint256 tTeam
464         ) = _getValues(tAmount);
465         _rOwned[sender] = _rOwned[sender].sub(rAmount);
466         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
467         _takeTeam(tTeam);
468         _reflectFee(rFee, tFee);
469         emit Transfer(sender, recipient, tTransferAmount);
470     }
471 
472     function _takeTeam(uint256 tTeam) private {
473         uint256 currentRate = _getRate();
474         uint256 rTeam = tTeam.mul(currentRate);
475         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
476     }
477 
478     function _reflectFee(uint256 rFee, uint256 tFee) private {
479         _rTotal = _rTotal.sub(rFee);
480         _tFeeTotal = _tFeeTotal.add(tFee);
481     }
482 
483     receive() external payable {}
484 
485     function _getValues(uint256 tAmount)
486         private
487         view
488         returns (
489             uint256,
490             uint256,
491             uint256,
492             uint256,
493             uint256,
494             uint256
495         )
496     {
497         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
498             _getTValues(tAmount, _redisFee, _taxFee);
499         uint256 currentRate = _getRate();
500         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
501             _getRValues(tAmount, tFee, tTeam, currentRate);
502         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
503     }
504 
505     function _getTValues(
506         uint256 tAmount,
507         uint256 redisFee,
508         uint256 taxFee
509     )
510         private
511         pure
512         returns (
513             uint256,
514             uint256,
515             uint256
516         )
517     {
518         uint256 tFee = tAmount.mul(redisFee).div(100);
519         uint256 tTeam = tAmount.mul(taxFee).div(100);
520         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
521         return (tTransferAmount, tFee, tTeam);
522     }
523 
524     function _getRValues(
525         uint256 tAmount,
526         uint256 tFee,
527         uint256 tTeam,
528         uint256 currentRate
529     )
530         private
531         pure
532         returns (
533             uint256,
534             uint256,
535             uint256
536         )
537     {
538         uint256 rAmount = tAmount.mul(currentRate);
539         uint256 rFee = tFee.mul(currentRate);
540         uint256 rTeam = tTeam.mul(currentRate);
541         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
542         return (rAmount, rTransferAmount, rFee);
543     }
544 
545     function _getRate() private view returns (uint256) {
546         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
547         return rSupply.div(tSupply);
548     }
549 
550     function _getCurrentSupply() private view returns (uint256, uint256) {
551         uint256 rSupply = _rTotal;
552         uint256 tSupply = _tTotal;
553         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
554         return (rSupply, tSupply);
555     }
556 
557     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
558         _redisFeeOnBuy = redisFeeOnBuy;
559         _redisFeeOnSell = redisFeeOnSell;
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
583 }