1 /*
2 
3 Web: https://knowyourdev.com/
4 
5 Twitter: https://twitter.com/KnowYourDevERC
6 
7 TG: https://t.me/KnowYourDevERC20
8 
9 
10 
11 KYD bot: t.me/KYDERC20Bot
12 
13 
14 */
15 // SPDX-License-Identifier: Unlicensed
16 pragma solidity ^0.8.18;
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40 contract Ownable is Context {
41     address private _owner;
42     address private _previousOwner;
43     event OwnershipTransferred(
44         address indexed previousOwner,
45         address indexed newOwner
46     );
47     constructor() {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52     function owner() public view returns (address) {
53         return _owner;
54     }
55     modifier onlyOwner() {
56         require(_owner == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63  
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69 }
70 library SafeMath {
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74         return c;
75     }
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79     function sub(
80         uint256 a,
81         uint256 b,
82         string memory errorMessage
83     ) internal pure returns (uint256) {
84         require(b <= a, errorMessage);
85         uint256 c = a - b;
86         return c;
87     }
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         if (a == 0) {
90             return 0;
91         }
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94         return c;
95     }
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99     function div(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         return c;
107     }
108 }
109 interface IUniswapV2Factory {
110     function createPair(address tokenA, address tokenB)
111         external
112         returns (address pair);
113 }
114 interface IUniswapV2Router02 {
115     function swapExactTokensForETHSupportingFeeOnTransferTokens(
116         uint256 amountIn,
117         uint256 amountOutMin,
118         address[] calldata path,
119         address to,
120         uint256 deadline
121     ) external;
122     function factory() external pure returns (address);
123     function WETH() external pure returns (address);
124     function addLiquidityETH(
125         address token,
126         uint256 amountTokenDesired,
127         uint256 amountTokenMin,
128         uint256 amountETHMin,
129         address to,
130         uint256 deadline
131     )
132         external
133         payable
134         returns (
135             uint256 amountToken,
136             uint256 amountETH,
137             uint256 liquidity
138         );
139 }
140 contract KnowYourDevERC is Context, IERC20, Ownable {
141     using SafeMath for uint256;
142     string private constant _name = "KnowYourDev";
143     string private constant _symbol = "KYD";
144     uint8 private constant _decimals = 9;
145     mapping(address => uint256) private _rOwned;
146     mapping(address => uint256) private _tOwned;
147     mapping(address => mapping(address => uint256)) private _allowances;
148     mapping(address => bool) private _isExcludedFromFee;
149     uint256 private constant MAX = ~uint256(0);
150     uint256 private constant _tTotal = 1000000000 * 10**9;
151     uint256 private _rTotal = (MAX - (MAX % _tTotal));
152     uint256 private _tFeeTotal;
153     uint256 private _redisFeeOnBuy = 0;  
154     uint256 private _taxFeeOnBuy = 25;  
155     uint256 private _redisFeeOnSell = 0;  
156     uint256 private _taxFeeOnSell = 30;
157  
158     //Original Fee
159     uint256 private _redisFee = 0;
160     uint256 private _taxFee = _taxFeeOnSell;
161  
162     uint256 private _previousredisFee = _redisFee;
163     uint256 private _previoustaxFee = _taxFee;
164  
165     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
166     address payable public _developmentAddress;
167     address payable public  _marketingAddress;
168  
169     IUniswapV2Router02 public uniswapV2Router;
170     address public uniswapV2Pair;
171  
172     bool private tradingOpen;
173     bool private inSwap = false;
174     bool private swapEnabled = true;
175  
176     uint256 public _maxTxAmount = 10000000 * 10**9; 
177     uint256 public _maxWalletSize = 10000000 * 10**9; 
178     uint256 public _swapTokensAtAmount = 2000000 * 10**9;
179  
180     event MaxTxAmountUpdated(uint256 _maxTxAmount);
181     modifier lockTheSwap {
182         inSwap = true;
183         _;
184         inSwap = false;
185     }
186  
187     constructor() {
188  
189         _rOwned[_msgSender()] = _rTotal;
190 
191         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
192         uniswapV2Router = _uniswapV2Router;
193         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
194             .createPair(address(this), _uniswapV2Router.WETH());
195         _developmentAddress = payable(owner());
196         _marketingAddress = payable(owner());
197         _isExcludedFromFee[owner()] = true;
198         _isExcludedFromFee[address(this)] = true;
199         _isExcludedFromFee[_developmentAddress] = true;
200         _isExcludedFromFee[_marketingAddress] = true;
201  
202         emit Transfer(address(0), _msgSender(), _tTotal);
203     }
204  
205     function name() public pure returns (string memory) {
206         return _name;
207     }
208  
209     function symbol() public pure returns (string memory) {
210         return _symbol;
211     }
212  
213     function decimals() public pure returns (uint8) {
214         return _decimals;
215     }
216  
217     function totalSupply() public pure override returns (uint256) {
218         return _tTotal;
219     }
220  
221     function balanceOf(address account) public view override returns (uint256) {
222         return tokenFromReflection(_rOwned[account]);
223     }
224  
225     function transfer(address recipient, uint256 amount)
226         public
227         override
228         returns (bool)
229     {
230         _transfer(_msgSender(), recipient, amount);
231         return true;
232     }
233  
234     function allowance(address owner, address spender)
235         public
236         view
237         override
238         returns (uint256)
239     {
240         return _allowances[owner][spender];
241     }
242  
243     function approve(address spender, uint256 amount)
244         public
245         override
246         returns (bool)
247     {
248         _approve(_msgSender(), spender, amount);
249         return true;
250     }
251  
252     function transferFrom(
253         address sender,
254         address recipient,
255         uint256 amount
256     ) public override returns (bool) {
257         _transfer(sender, recipient, amount);
258         _approve(
259             sender,
260             _msgSender(),
261             _allowances[sender][_msgSender()].sub(
262                 amount,
263                 "ERC20: transfer amount exceeds allowance"
264             )
265         );
266         return true;
267     }
268  
269     function tokenFromReflection(uint256 rAmount)
270         private
271         view
272         returns (uint256)
273     {
274         require(
275             rAmount <= _rTotal,
276             "Amount must be less than total reflections"
277         );
278         uint256 currentRate = _getRate();
279         return rAmount.div(currentRate);
280     }
281  
282     function removeAllFee() private {
283         if (_redisFee == 0 && _taxFee == 0) return;
284  
285         _previousredisFee = _redisFee;
286         _previoustaxFee = _taxFee;
287  
288         _redisFee = 0;
289         _taxFee = 0;
290     }
291  
292     function restoreAllFee() private {
293         _redisFee = _previousredisFee;
294         _taxFee = _previoustaxFee;
295     }
296  
297     function _approve(
298         address owner,
299         address spender,
300         uint256 amount
301     ) private {
302         require(owner != address(0), "ERC20: approve from the zero address");
303         require(spender != address(0), "ERC20: approve to the zero address");
304         _allowances[owner][spender] = amount;
305         emit Approval(owner, spender, amount);
306     }
307  
308     function _transfer(
309         address from,
310         address to,
311         uint256 amount
312     ) private {
313         require(from != address(0), "ERC20: transfer from the zero address");
314         require(to != address(0), "ERC20: transfer to the zero address");
315         require(amount > 0, "Transfer amount must be greater than zero");
316  
317         if (from != owner() && to != owner()) {
318  
319             //Trade start check
320             if (!tradingOpen) {
321                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
322             }
323  
324             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
325             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
326  
327             if(to != uniswapV2Pair) {
328                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
329             }
330  
331             uint256 contractTokenBalance = balanceOf(address(this));
332             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
333  
334             if(contractTokenBalance >= _swapTokensAtAmount)
335             {
336                 contractTokenBalance = _swapTokensAtAmount;
337             }
338  
339             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
340                 swapTokensForEth(contractTokenBalance);
341                 uint256 contractETHBalance = address(this).balance;
342                 if (contractETHBalance > 0) {
343                     sendETHToFee(address(this).balance);
344                 }
345             }
346         }
347  
348         bool takeFee = true;
349  
350         //Transfer Tokens
351         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
352             takeFee = false;
353         } else {
354  
355             //Set Fee for Buys
356             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
357                 _redisFee = _redisFeeOnBuy;
358                 _taxFee = _taxFeeOnBuy;
359             }
360  
361             //Set Fee for Sells
362             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
363                 _redisFee = _redisFeeOnSell;
364                 _taxFee = _taxFeeOnSell;
365             }
366  
367         }
368  
369         _tokenTransfer(from, to, amount, takeFee);
370     }
371  
372     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
373         address[] memory path = new address[](2);
374         path[0] = address(this);
375         path[1] = uniswapV2Router.WETH();
376         _approve(address(this), address(uniswapV2Router), tokenAmount);
377         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
378             tokenAmount,
379             0,
380             path,
381             address(this),
382             block.timestamp
383         );
384     }
385  
386     function sendETHToFee(uint256 amount) private {
387         _marketingAddress.transfer(amount);
388     }
389      function TradeOpen() public onlyOwner {
390         tradingOpen = true;
391     }
392      function manualswap() external {
393         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
394         uint256 contractBalance = balanceOf(address(this));
395         swapTokensForEth(contractBalance);
396     }
397  
398     function manualsend() external {
399         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
400         uint256 contractETHBalance = address(this).balance;
401         sendETHToFee(contractETHBalance);
402     }
403  
404     function BlacklistWallets(address[] memory bots_) public onlyOwner {
405         for (uint256 i = 0; i < bots_.length; i++) {
406             bots[bots_[i]] = true;
407         }
408     }
409     function unBlacklistWallet(address notbot) public onlyOwner {
410         bots[notbot] = false;
411     }
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
528     function updateTaxes(uint256 _buyTaxes, uint256 _sellTaxes) public onlyOwner {
529         _taxFeeOnBuy = _buyTaxes;
530         _taxFeeOnSell = _sellTaxes;
531     }
532     function _setSwapbackThreshold(uint256 _amount) public onlyOwner {
533         _swapTokensAtAmount = _amount * 10**9;
534     }
535     function _toggleSwapback(bool _swapEnabled) public onlyOwner {
536         swapEnabled = _swapEnabled;
537     }
538     function _excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
539         for(uint256 i = 0; i < accounts.length; i++) {
540             _isExcludedFromFee[accounts[i]] = excluded;
541         }
542     }
543     function _setMaxTx(uint256 maxTxAmount) public onlyOwner {
544            _maxTxAmount = maxTxAmount;       
545     }
546     function _setMaxWallet(uint256 maxWalletSize) public onlyOwner {
547         _maxWalletSize = maxWalletSize;
548     }
549     function removeLimits() public onlyOwner {
550         _maxTxAmount = _tTotal;
551         _maxWalletSize = _tTotal;
552     }
553     function _changeWallets(address _marketing,address _development) public onlyOwner{
554         _marketingAddress = payable(_marketing);
555         _developmentAddress = payable(_development);
556     }
557 }