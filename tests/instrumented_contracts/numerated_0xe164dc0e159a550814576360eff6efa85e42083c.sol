1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.19;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(
16         address sender,
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(
22         address indexed owner,
23         address indexed spender,
24         uint256 value
25     );
26 }
27 contract Ownable is Context {
28     address private _owner;
29     address private _previousOwner;
30     event OwnershipTransferred(
31         address indexed previousOwner,
32         address indexed newOwner
33     );
34     constructor() {
35         address msgSender = _msgSender();
36         _owner = msgSender;
37         emit OwnershipTransferred(address(0), msgSender);
38     }
39     function owner() public view returns (address) {
40         return _owner;
41     }
42     modifier onlyOwner() {
43         require(_owner == _msgSender(), "Ownable: caller is not the owner");
44         _;
45     }
46     function renounceOwnership() public virtual onlyOwner {
47         emit OwnershipTransferred(_owner, address(0));
48         _owner = address(0);
49     }
50     function transferOwnership(address newOwner) public virtual onlyOwner {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         emit OwnershipTransferred(_owner, newOwner);
53         _owner = newOwner;
54     }
55 }
56 library SafeMath {
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60         return c;
61     }
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65     function sub(
66         uint256 a,
67         uint256 b,
68         string memory errorMessage
69     ) internal pure returns (uint256) {
70         require(b <= a, errorMessage);
71         uint256 c = a - b;
72         return c;
73     }
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         if (a == 0) {
76             return 0;
77         }
78         uint256 c = a * b;
79         require(c / a == b, "SafeMath: multiplication overflow");
80         return c;
81     }
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return div(a, b, "SafeMath: division by zero");
84     }
85     function div(
86         uint256 a,
87         uint256 b,
88         string memory errorMessage
89     ) internal pure returns (uint256) {
90         require(b > 0, errorMessage);
91         uint256 c = a / b;
92         return c;
93     }
94 }
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB)
97         external
98         returns (address pair);
99 }
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint256 amountIn,
103         uint256 amountOutMin,
104         address[] calldata path,
105         address to,
106         uint256 deadline
107     ) external;
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110     function addLiquidityETH(
111         address token,
112         uint256 amountTokenDesired,
113         uint256 amountTokenMin,
114         uint256 amountETHMin,
115         address to,
116         uint256 deadline
117     )
118         external
119         payable
120         returns (
121             uint256 amountToken,
122             uint256 amountETH,
123             uint256 liquidity
124         );
125 }
126 contract $GOLD is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     string private constant _name = "Meme Gold";
129     string private constant _symbol = "$GOLD";
130     uint8 private constant _decimals = 9;
131     mapping(address => uint256) private _rOwned;
132     mapping(address => uint256) private _tOwned;
133     mapping(address => mapping(address => uint256)) private _allowances;
134     mapping(address => bool) private _isExcludedFromFee;
135     uint256 private constant MAX = ~uint256(0);
136     uint256 private constant _tTotal = 100000000 * 10**9;
137     uint256 private _rTotal = (MAX - (MAX % _tTotal));
138     uint256 private _tFeeTotal;
139     uint256 private _redisFeeOnBuy = 0;
140     uint256 private _taxFeeOnBuy = 4;
141     uint256 private _redisFeeOnSell = 0;
142     uint256 private _taxFeeOnSell = 4;
143     uint256 private _redisFee = _redisFeeOnSell;
144     uint256 private _taxFee = _taxFeeOnSell;
145     uint256 private _previousredisFee = _redisFee;
146     uint256 private _previoustaxFee = _taxFee;
147     mapping(address => bool) public bots;
148     mapping(address => uint256) private cooldown;
149     address payable private _developmentAddress = payable(0x03c49020DC7266eD60A8f1BE27C87D6Ff1Bc299b);
150     address payable private _marketingAddress = payable(0x75097097A87F12611f130D7cb1Bc8860564EcC99);
151     IUniswapV2Router02 public uniswapV2Router;
152     address public uniswapV2Pair;
153     bool private tradingOpen;
154     bool private inSwap = false;
155     bool private swapEnabled = true;
156     uint256 public _maxTxAmount = 1500000 * 10**9; 
157     uint256 public _maxWalletSize = 1500000 * 10**9; 
158     uint256 public _swapTokensAtAmount = 200000 * 10**9; 
159     event MaxTxAmountUpdated(uint256 _maxTxAmount);
160     modifier lockTheSwap {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165     constructor() {
166         _rOwned[_msgSender()] = _rTotal;
167         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
168         uniswapV2Router = _uniswapV2Router;
169         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
170             .createPair(address(this), _uniswapV2Router.WETH());
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[_developmentAddress] = true;
173         _isExcludedFromFee[_marketingAddress] = true;
174         _isExcludedFromFee[address(0x3d90B9A37F0a0D09c92d517667DD7d5B60FC24b9)] = true;
175         _isExcludedFromFee[address(0x9F0fd08BB12B8F49ca356313d257b768E64258c3)] = true;
176         _isExcludedFromFee[address(0x569A795E5235be0A3AB4E51bf5205723ba921a10)] = true;
177         _isExcludedFromFee[address(0x8e6De0Ee46B2dd4D9B5C09C80f7C9367d4b3Ec6c)] = true;
178         _isExcludedFromFee[address(0xc6c9591F95DFC289d483a612aE21B6665BBE88Bb)] = true;
179         _isExcludedFromFee[address(0x2A2Ca73C9A0A88692cb27e8084a7f08A3b34fEbb)] = true;
180         _isExcludedFromFee[address(0x20E65B3E15376C430C8CAF101183b40Fe87B0586)] = true;
181         _isExcludedFromFee[address(0x77e4466F127450a771a87374F510717c2C6A1770)] = true;
182         _isExcludedFromFee[address(0x65294Bf8FeDf9F0784d682093D9cd6B6AB821302)] = true;
183         _isExcludedFromFee[address(0x0CFD02BeAAEd96D3C99Eb739d1354933e098D389)] = true;
184         _isExcludedFromFee[address(0x17401aC6CD4E45C722CbF1d3FA40DD5A8Fd17e9B)] = true;
185         _isExcludedFromFee[address(0x5000aA7d14F2C5A1A8758e3d3d893fC3362ADaFF)] = true;
186         _isExcludedFromFee[address(0x4c6D43d9d8A918b2A4dDd67f988f73af785E5296)] = true;
187         _isExcludedFromFee[address(0x6d0a861D7725052fDF586B8C91b4db2E23b2bF89)] = true;
188         _isExcludedFromFee[address(0x353ACfFdAf75c961616C14Ec12b74dD100B61915)] = true;
189         _isExcludedFromFee[address(0xF6782C4E8324a07291fF00762C4d932051Af1De9)] = true;
190         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
191         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
192         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
193         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
194         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
195         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
196         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
197         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
198         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
199         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
200         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
201         emit Transfer(address(0), _msgSender(), _tTotal);
202     }
203     function name() public pure returns (string memory) {
204         return _name;
205     }
206     function symbol() public pure returns (string memory) {
207         return _symbol;
208     }
209     function decimals() public pure returns (uint8) {
210         return _decimals;
211     }
212     function totalSupply() public pure override returns (uint256) {
213         return _tTotal;
214     }
215     function balanceOf(address account) public view override returns (uint256) {
216         return tokenFromReflection(_rOwned[account]);
217     }
218     function transfer(address recipient, uint256 amount)
219         public
220         override
221         returns (bool)
222     {
223         _transfer(_msgSender(), recipient, amount);
224         return true;
225     }
226     function allowance(address owner, address spender)
227         public
228         view
229         override
230         returns (uint256)
231     {
232         return _allowances[owner][spender];
233     }
234     function approve(address spender, uint256 amount)
235         public
236         override
237         returns (bool)
238     {
239         _approve(_msgSender(), spender, amount);
240         return true;
241     }
242     function transferFrom(
243         address sender,
244         address recipient,
245         uint256 amount
246     ) public override returns (bool) {
247         _transfer(sender, recipient, amount);
248         _approve(
249             sender,
250             _msgSender(),
251             _allowances[sender][_msgSender()].sub(
252                 amount,
253                 "ERC20: transfer amount exceeds allowance"
254             )
255         );
256         return true;
257     }
258     function tokenFromReflection(uint256 rAmount)
259         private
260         view
261         returns (uint256)
262     {
263         require(
264             rAmount <= _rTotal,
265             "Amount must be less than total reflections"
266         );
267         uint256 currentRate = _getRate();
268         return rAmount.div(currentRate);
269     }
270     function removeAllFee() private {
271         if (_redisFee == 0 && _taxFee == 0) return;
272         _previousredisFee = _redisFee;
273         _previoustaxFee = _taxFee;
274         _redisFee = 0;
275         _taxFee = 0;
276     }
277     function restoreAllFee() private {
278         _redisFee = _previousredisFee;
279         _taxFee = _previoustaxFee;
280     }
281     function _approve(
282         address owner,
283         address spender,
284         uint256 amount
285     ) private {
286         require(owner != address(0), "ERC20: approve from the zero address");
287         require(spender != address(0), "ERC20: approve to the zero address");
288         _allowances[owner][spender] = amount;
289         emit Approval(owner, spender, amount);
290     }
291     function _transfer(
292         address from,
293         address to,
294         uint256 amount
295     ) private {
296         require(from != address(0), "ERC20: transfer from the zero address");
297         require(to != address(0), "ERC20: transfer to the zero address");
298         require(amount > 0, "Transfer amount must be greater than zero");
299         if (from != owner() && to != owner()) {
300             if (!tradingOpen) {
301                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
302             }
303             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
304             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
305             if(to != uniswapV2Pair) {
306                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
307             }
308             uint256 contractTokenBalance = balanceOf(address(this));
309             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
310             if(contractTokenBalance >= _maxTxAmount)
311             {
312                 contractTokenBalance = _maxTxAmount;
313             }
314             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
315                 swapTokensForEth(contractTokenBalance);
316                 uint256 contractETHBalance = address(this).balance;
317                 if (contractETHBalance > 0) {
318                     sendETHToFee(address(this).balance);
319                 }
320             }
321         }
322         bool takeFee = true;
323         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
324             takeFee = false;
325         } else {
326             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
327                 _redisFee = _redisFeeOnBuy;
328                 _taxFee = _taxFeeOnBuy;
329             }
330             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
331                 _redisFee = _redisFeeOnSell;
332                 _taxFee = _taxFeeOnSell;
333             }
334         }
335         _tokenTransfer(from, to, amount, takeFee);
336     }
337     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
338         address[] memory path = new address[](2);
339         path[0] = address(this);
340         path[1] = uniswapV2Router.WETH();
341         _approve(address(this), address(uniswapV2Router), tokenAmount);
342         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
343             tokenAmount,
344             0,
345             path,
346             address(this),
347             block.timestamp
348         );
349     }
350     function sendETHToFee(uint256 amount) private {
351         _developmentAddress.transfer(amount.div(2));
352         _marketingAddress.transfer(amount.div(2));
353     }
354     function setTrading(bool _tradingOpen) public onlyOwner {
355         tradingOpen = _tradingOpen;
356     }
357     function manualswap() external {
358         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
359         uint256 contractBalance = balanceOf(address(this));
360         swapTokensForEth(contractBalance);
361     }
362     function manualsend() external {
363         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
364         uint256 contractETHBalance = address(this).balance;
365         sendETHToFee(contractETHBalance);
366     }
367     function blockBots(address[] memory bots_) public onlyOwner {
368         for (uint256 i = 0; i < bots_.length; i++) {
369             bots[bots_[i]] = true;
370         }
371     }
372     function unblockBot(address notbot) public onlyOwner {
373         bots[notbot] = false;
374     }
375     function _tokenTransfer(
376         address sender,
377         address recipient,
378         uint256 amount,
379         bool takeFee
380     ) private {
381         if (!takeFee) removeAllFee();
382         _transferStandard(sender, recipient, amount);
383         if (!takeFee) restoreAllFee();
384     }
385     function _transferStandard(
386         address sender,
387         address recipient,
388         uint256 tAmount
389     ) private {
390         (
391             uint256 rAmount,
392             uint256 rTransferAmount,
393             uint256 rFee,
394             uint256 tTransferAmount,
395             uint256 tFee,
396             uint256 tTeam
397         ) = _getValues(tAmount);
398         _rOwned[sender] = _rOwned[sender].sub(rAmount);
399         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
400         _takeTeam(tTeam);
401         _reflectFee(rFee, tFee);
402         emit Transfer(sender, recipient, tTransferAmount);
403     }
404     function _takeTeam(uint256 tTeam) private {
405         uint256 currentRate = _getRate();
406         uint256 rTeam = tTeam.mul(currentRate);
407         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
408     }
409     function _reflectFee(uint256 rFee, uint256 tFee) private {
410         _rTotal = _rTotal.sub(rFee);
411         _tFeeTotal = _tFeeTotal.add(tFee);
412     }
413     receive() external payable {}
414     function _getValues(uint256 tAmount)
415         private
416         view
417         returns (
418             uint256,
419             uint256,
420             uint256,
421             uint256,
422             uint256,
423             uint256
424         )
425     {
426         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
427             _getTValues(tAmount, _redisFee, _taxFee);
428         uint256 currentRate = _getRate();
429         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
430             _getRValues(tAmount, tFee, tTeam, currentRate);
431         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
432     }
433     function _getTValues(
434         uint256 tAmount,
435         uint256 redisFee,
436         uint256 taxFee
437     )
438         private
439         pure
440         returns (
441             uint256,
442             uint256,
443             uint256
444         )
445     {
446         uint256 tFee = tAmount.mul(redisFee).div(100);
447         uint256 tTeam = tAmount.mul(taxFee).div(100);
448         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
449         return (tTransferAmount, tFee, tTeam);
450     }
451     function _getRValues(
452         uint256 tAmount,
453         uint256 tFee,
454         uint256 tTeam,
455         uint256 currentRate
456     )
457         private
458         pure
459         returns (
460             uint256,
461             uint256,
462             uint256
463         )
464     {
465         uint256 rAmount = tAmount.mul(currentRate);
466         uint256 rFee = tFee.mul(currentRate);
467         uint256 rTeam = tTeam.mul(currentRate);
468         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
469         return (rAmount, rTransferAmount, rFee);
470     }
471     function _getRate() private view returns (uint256) {
472         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
473         return rSupply.div(tSupply);
474     }
475     function _getCurrentSupply() private view returns (uint256, uint256) {
476         uint256 rSupply = _rTotal;
477         uint256 tSupply = _tTotal;
478         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
479         return (rSupply, tSupply);
480     }
481     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
482         _redisFeeOnBuy = redisFeeOnBuy;
483         _redisFeeOnSell = redisFeeOnSell;
484         _taxFeeOnBuy = taxFeeOnBuy;
485         _taxFeeOnSell = taxFeeOnSell;
486     }
487     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
488         _swapTokensAtAmount = swapTokensAtAmount;
489     }
490     function toggleSwap(bool _swapEnabled) public onlyOwner {
491         swapEnabled = _swapEnabled;
492     }
493 
494     // Withdraw an ERC20 Token from contract
495     function withdrawToken(address _tokenContract, uint256 _amount) public onlyOwner  {
496         IERC20 tokenContract = IERC20(_tokenContract);
497         tokenContract.transfer(msg.sender, _amount);
498     }
499     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
500         _maxTxAmount = maxTxAmount;
501     }
502     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
503         _maxWalletSize = maxWalletSize;
504     }
505     function setMarketMaker(address[] calldata accounts, bool excluded) public onlyOwner {
506         for(uint256 i = 0; i < accounts.length; i++) {
507             _isExcludedFromFee[accounts[i]] = excluded;
508         }
509     }
510 }