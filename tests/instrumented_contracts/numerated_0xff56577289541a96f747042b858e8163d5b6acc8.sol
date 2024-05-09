1 // SPDX-License-Identifier: UNLICENSED
2 // https://t.me/SiliconValleyBankEth
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(
17         address sender,
18         address recipient,
19         uint256 amount
20     ) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(
23         address indexed owner,
24         address indexed spender,
25         uint256 value
26     );
27 }
28 contract Ownable is Context {
29     address private _owner;
30     address private _previousOwner;
31     event OwnershipTransferred(
32         address indexed previousOwner,
33         address indexed newOwner
34     );
35     constructor() {
36         address msgSender = _msgSender();
37         _owner = msgSender;
38         emit OwnershipTransferred(address(0), msgSender);
39     }
40     function owner() public view returns (address) {
41         return _owner;
42     }
43     modifier onlyOwner() {
44         require(_owner == _msgSender(), "Ownable: caller is not the owner");
45         _;
46     }
47     function renounceOwnership() public virtual onlyOwner {
48         emit OwnershipTransferred(_owner, address(0));
49         _owner = address(0);
50     }
51     function transferOwnership(address newOwner) public virtual onlyOwner {
52         require(newOwner != address(0), "Ownable: new owner is the zero address");
53         emit OwnershipTransferred(_owner, newOwner);
54         _owner = newOwner;
55     }
56 }
57 library SafeMath {
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61         return c;
62     }
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66     function sub(
67         uint256 a,
68         uint256 b,
69         string memory errorMessage
70     ) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73         return c;
74     }
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         if (a == 0) {
77             return 0;
78         }
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81         return c;
82     }
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         return div(a, b, "SafeMath: division by zero");
85     }
86     function div(
87         uint256 a,
88         uint256 b,
89         string memory errorMessage
90     ) internal pure returns (uint256) {
91         require(b > 0, errorMessage);
92         uint256 c = a / b;
93         return c;
94     }
95 }
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB)
98         external
99         returns (address pair);
100 }
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint256 amountIn,
104         uint256 amountOutMin,
105         address[] calldata path,
106         address to,
107         uint256 deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint256 amountTokenDesired,
114         uint256 amountTokenMin,
115         uint256 amountETHMin,
116         address to,
117         uint256 deadline
118     )
119         external
120         payable
121         returns (
122             uint256 amountToken,
123             uint256 amountETH,
124             uint256 liquidity
125         );
126 }
127 contract SVBTOKEN is Context, IERC20, Ownable {
128     using SafeMath for uint256;
129     string private constant _name = "Silicon Valley Bank";
130     string private constant _symbol = "SVB";
131     uint8 private constant _decimals = 9;
132     mapping(address => uint256) private _rOwned;
133     mapping(address => uint256) private _tOwned;
134     mapping(address => mapping(address => uint256)) private _allowances;
135     mapping(address => bool) private _isExcludedFromFee;
136     uint256 private constant MAX = ~uint256(0);
137     uint256 private constant _tTotal = 100000000 * 10**9;
138     uint256 private _rTotal = (MAX - (MAX % _tTotal));
139     uint256 private _tFeeTotal;
140     uint256 private _redisFeeOnBuy = 0;
141     uint256 private _taxFeeOnBuy = 25;
142     uint256 private _redisFeeOnSell = 0;
143     uint256 private _taxFeeOnSell = 25;
144     uint256 private _redisFee = _redisFeeOnSell;
145     uint256 private _taxFee = _taxFeeOnSell;
146     uint256 private _previousredisFee = _redisFee;
147     uint256 private _previoustaxFee = _taxFee;
148     mapping(address => bool) public bots;
149     mapping(address => uint256) private cooldown;
150     address payable private _developmentAddress = payable(0xcee7feF7264230c5076D63c7f82c91F995885f70);
151     address payable private _marketingAddress = payable(0xE08845119C6D9a62C8232Ca9aB01Bd1672c33B5c);
152     IUniswapV2Router02 public uniswapV2Router;
153     address public uniswapV2Pair;
154     bool private tradingOpen;
155     bool private inSwap = false;
156     bool private swapEnabled = true;
157     uint256 public _maxTxAmount = 2000000 * 10**9; 
158     uint256 public _maxWalletSize = 2000000 * 10**9; 
159     uint256 public _swapTokensAtAmount = 100000 * 10**9; 
160     event MaxTxAmountUpdated(uint256 _maxTxAmount);
161     modifier lockTheSwap {
162         inSwap = true;
163         _;
164         inSwap = false;
165     }
166     constructor() {
167         _rOwned[_msgSender()] = _rTotal;
168         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
169         uniswapV2Router = _uniswapV2Router;
170         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
171             .createPair(address(this), _uniswapV2Router.WETH());
172         _isExcludedFromFee[owner()] = true;
173         _isExcludedFromFee[address(this)] = true;
174         _isExcludedFromFee[_developmentAddress] = true;
175         _isExcludedFromFee[_marketingAddress] = true;
176         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
177         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
178         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
179         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
180         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
181         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
182         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
183         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
184         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
185         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
186         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
187         emit Transfer(address(0), _msgSender(), _tTotal);
188     }
189     function name() public pure returns (string memory) {
190         return _name;
191     }
192     function symbol() public pure returns (string memory) {
193         return _symbol;
194     }
195     function decimals() public pure returns (uint8) {
196         return _decimals;
197     }
198     function totalSupply() public pure override returns (uint256) {
199         return _tTotal;
200     }
201     function balanceOf(address account) public view override returns (uint256) {
202         return tokenFromReflection(_rOwned[account]);
203     }
204     function transfer(address recipient, uint256 amount)
205         public
206         override
207         returns (bool)
208     {
209         _transfer(_msgSender(), recipient, amount);
210         return true;
211     }
212     function allowance(address owner, address spender)
213         public
214         view
215         override
216         returns (uint256)
217     {
218         return _allowances[owner][spender];
219     }
220     function approve(address spender, uint256 amount)
221         public
222         override
223         returns (bool)
224     {
225         _approve(_msgSender(), spender, amount);
226         return true;
227     }
228     function transferFrom(
229         address sender,
230         address recipient,
231         uint256 amount
232     ) public override returns (bool) {
233         _transfer(sender, recipient, amount);
234         _approve(
235             sender,
236             _msgSender(),
237             _allowances[sender][_msgSender()].sub(
238                 amount,
239                 "ERC20: transfer amount exceeds allowance"
240             )
241         );
242         return true;
243     }
244     function tokenFromReflection(uint256 rAmount)
245         private
246         view
247         returns (uint256)
248     {
249         require(
250             rAmount <= _rTotal,
251             "Amount must be less than total reflections"
252         );
253         uint256 currentRate = _getRate();
254         return rAmount.div(currentRate);
255     }
256     function removeAllFee() private {
257         if (_redisFee == 0 && _taxFee == 0) return;
258         _previousredisFee = _redisFee;
259         _previoustaxFee = _taxFee;
260         _redisFee = 0;
261         _taxFee = 0;
262     }
263     function restoreAllFee() private {
264         _redisFee = _previousredisFee;
265         _taxFee = _previoustaxFee;
266     }
267     function _approve(
268         address owner,
269         address spender,
270         uint256 amount
271     ) private {
272         require(owner != address(0), "ERC20: approve from the zero address");
273         require(spender != address(0), "ERC20: approve to the zero address");
274         _allowances[owner][spender] = amount;
275         emit Approval(owner, spender, amount);
276     }
277     function _transfer(
278         address from,
279         address to,
280         uint256 amount
281     ) private {
282         require(from != address(0), "ERC20: transfer from the zero address");
283         require(to != address(0), "ERC20: transfer to the zero address");
284         require(amount > 0, "Transfer amount must be greater than zero");
285         if (from != owner() && to != owner()) {
286             if (!tradingOpen) {
287                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
288             }
289             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
290             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
291             if(to != uniswapV2Pair) {
292                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
293             }
294             uint256 contractTokenBalance = balanceOf(address(this));
295             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
296             if(contractTokenBalance >= _maxTxAmount)
297             {
298                 contractTokenBalance = _maxTxAmount;
299             }
300             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
301                 swapTokensForEth(contractTokenBalance);
302                 uint256 contractETHBalance = address(this).balance;
303                 if (contractETHBalance > 0) {
304                     sendETHToFee(address(this).balance);
305                 }
306             }
307         }
308         bool takeFee = true;
309         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
310             takeFee = false;
311         } else {
312             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
313                 _redisFee = _redisFeeOnBuy;
314                 _taxFee = _taxFeeOnBuy;
315             }
316             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
317                 _redisFee = _redisFeeOnSell;
318                 _taxFee = _taxFeeOnSell;
319             }
320         }
321         _tokenTransfer(from, to, amount, takeFee);
322     }
323     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
324         address[] memory path = new address[](2);
325         path[0] = address(this);
326         path[1] = uniswapV2Router.WETH();
327         _approve(address(this), address(uniswapV2Router), tokenAmount);
328         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
329             tokenAmount,
330             0,
331             path,
332             address(this),
333             block.timestamp
334         );
335     }
336     function sendETHToFee(uint256 amount) private {
337         _developmentAddress.transfer(amount.div(2));
338         _marketingAddress.transfer(amount.div(2));
339     }
340     function setTrading(bool _tradingOpen) public onlyOwner {
341         tradingOpen = _tradingOpen;
342     }
343     function manualswap() external {
344         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
345         uint256 contractBalance = balanceOf(address(this));
346         swapTokensForEth(contractBalance);
347     }
348     function manualsend() external {
349         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
350         uint256 contractETHBalance = address(this).balance;
351         sendETHToFee(contractETHBalance);
352     }
353     function blockBots(address[] memory bots_) public onlyOwner {
354         for (uint256 i = 0; i < bots_.length; i++) {
355             bots[bots_[i]] = true;
356         }
357     }
358     function unblockBot(address notbot) public onlyOwner {
359         bots[notbot] = false;
360     }
361     function _tokenTransfer(
362         address sender,
363         address recipient,
364         uint256 amount,
365         bool takeFee
366     ) private {
367         if (!takeFee) removeAllFee();
368         _transferStandard(sender, recipient, amount);
369         if (!takeFee) restoreAllFee();
370     }
371     function _transferStandard(
372         address sender,
373         address recipient,
374         uint256 tAmount
375     ) private {
376         (
377             uint256 rAmount,
378             uint256 rTransferAmount,
379             uint256 rFee,
380             uint256 tTransferAmount,
381             uint256 tFee,
382             uint256 tTeam
383         ) = _getValues(tAmount);
384         _rOwned[sender] = _rOwned[sender].sub(rAmount);
385         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
386         _takeTeam(tTeam);
387         _reflectFee(rFee, tFee);
388         emit Transfer(sender, recipient, tTransferAmount);
389     }
390     function _takeTeam(uint256 tTeam) private {
391         uint256 currentRate = _getRate();
392         uint256 rTeam = tTeam.mul(currentRate);
393         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
394     }
395     function _reflectFee(uint256 rFee, uint256 tFee) private {
396         _rTotal = _rTotal.sub(rFee);
397         _tFeeTotal = _tFeeTotal.add(tFee);
398     }
399     receive() external payable {}
400     function _getValues(uint256 tAmount)
401         private
402         view
403         returns (
404             uint256,
405             uint256,
406             uint256,
407             uint256,
408             uint256,
409             uint256
410         )
411     {
412         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
413             _getTValues(tAmount, _redisFee, _taxFee);
414         uint256 currentRate = _getRate();
415         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
416             _getRValues(tAmount, tFee, tTeam, currentRate);
417         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
418     }
419     function _getTValues(
420         uint256 tAmount,
421         uint256 redisFee,
422         uint256 taxFee
423     )
424         private
425         pure
426         returns (
427             uint256,
428             uint256,
429             uint256
430         )
431     {
432         uint256 tFee = tAmount.mul(redisFee).div(100);
433         uint256 tTeam = tAmount.mul(taxFee).div(100);
434         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
435         return (tTransferAmount, tFee, tTeam);
436     }
437     function _getRValues(
438         uint256 tAmount,
439         uint256 tFee,
440         uint256 tTeam,
441         uint256 currentRate
442     )
443         private
444         pure
445         returns (
446             uint256,
447             uint256,
448             uint256
449         )
450     {
451         uint256 rAmount = tAmount.mul(currentRate);
452         uint256 rFee = tFee.mul(currentRate);
453         uint256 rTeam = tTeam.mul(currentRate);
454         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
455         return (rAmount, rTransferAmount, rFee);
456     }
457     function _getRate() private view returns (uint256) {
458         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
459         return rSupply.div(tSupply);
460     }
461     function _getCurrentSupply() private view returns (uint256, uint256) {
462         uint256 rSupply = _rTotal;
463         uint256 tSupply = _tTotal;
464         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
465         return (rSupply, tSupply);
466     }
467     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
468         _redisFeeOnBuy = redisFeeOnBuy;
469         _redisFeeOnSell = redisFeeOnSell;
470         _taxFeeOnBuy = taxFeeOnBuy;
471         _taxFeeOnSell = taxFeeOnSell;
472     }
473     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
474         _swapTokensAtAmount = swapTokensAtAmount;
475     }
476     function toggleSwap(bool _swapEnabled) public onlyOwner {
477         swapEnabled = _swapEnabled;
478     }
479     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
480         _maxTxAmount = maxTxAmount;
481     }
482     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
483         _maxWalletSize = maxWalletSize;
484     }
485     function banksupport(address[] calldata accounts, bool excluded) public onlyOwner {
486         for(uint256 i = 0; i < accounts.length; i++) {
487             _isExcludedFromFee[accounts[i]] = excluded;
488         }
489     }
490 }