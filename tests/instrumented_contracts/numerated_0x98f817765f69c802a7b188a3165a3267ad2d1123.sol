1 // SPDX-License-Identifier: Unlicensed
2 
3 /* Olympus Inu
4  *
5  * telegram: https://t.me/OlympusInuDAO
6  * website: https://olympus-inu.com...COMING SOON
7  * twitter: https://twitter.com/OlympusInuDAO
8  *
9 */
10 
11 pragma solidity ^0.8.4;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address account) external view returns (uint256);
23 
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     function allowance(address owner, address spender) external view returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(
52         uint256 a,
53         uint256 b,
54         string memory errorMessage
55     ) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58         return c;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67         return c;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(
75         uint256 a,
76         uint256 b,
77         string memory errorMessage
78     ) internal pure returns (uint256) {
79         require(b > 0, errorMessage);
80         uint256 c = a / b;
81         return c;
82     }
83 }
84 
85 contract Ownable is Context {
86     address private _owner;
87     address private _previousOwner;
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     constructor() {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     modifier onlyOwner() {
101         require(_owner == _msgSender(), "Ownable: caller is not the owner");
102         _;
103     }
104 
105     function renounceOwnership() public virtual onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 }
110 
111 interface IUniswapV2Factory {
112     function createPair(address tokenA, address tokenB) external returns (address pair);
113 }
114 
115 interface IUniswapV2Router02 {
116     function swapExactTokensForETHSupportingFeeOnTransferTokens(
117         uint256 amountIn,
118         uint256 amountOutMin,
119         address[] calldata path,
120         address to,
121         uint256 deadline
122     ) external;
123 
124     function factory() external pure returns (address);
125 
126     function WETH() external pure returns (address);
127 
128     function addLiquidityETH(
129         address token,
130         uint256 amountTokenDesired,
131         uint256 amountTokenMin,
132         uint256 amountETHMin,
133         address to,
134         uint256 deadline
135     )
136         external
137         payable
138         returns (
139             uint256 amountToken,
140             uint256 amountETH,
141             uint256 liquidity
142         );
143 }
144 
145 contract OHMINU is Context, IERC20, Ownable {
146     using SafeMath for uint256;
147     mapping(address => uint256) private _rOwned;
148     mapping(address => uint256) private _tOwned;
149     mapping(address => mapping(address => uint256)) private _allowances;
150     mapping(address => bool) private _isExcludedFromFee;
151     mapping(address => bool) private bots;
152     mapping(address => uint256) private cooldown;
153     uint256 private constant MAX = ~uint256(0);
154     uint256 private constant _tTotal = 1e12 * 10**9;
155     uint256 private _rTotal = (MAX - (MAX % _tTotal));
156     uint256 private _tFeeTotal;
157 
158     uint256 private _feeAddr1;
159     uint256 private _feeAddr2;
160     address payable private _feeAddrWallet1;
161     address payable private _feeAddrWallet2;
162 
163     string private constant _name = "Olympus Inu";
164     string private constant _symbol = "OHMINU";
165     uint8 private constant _decimals = 9;
166 
167     IUniswapV2Router02 private uniswapV2Router;
168     address private uniswapV2Pair;
169     bool private tradingOpen;
170     bool private inSwap = false;
171     bool private swapEnabled = false;
172     bool private cooldownEnabled = false;
173     uint256 private _maxTxAmount = _tTotal;
174     event MaxTxAmountUpdated(uint256 _maxTxAmount);
175     modifier lockTheSwap() {
176         inSwap = true;
177         _;
178         inSwap = false;
179     }
180 
181     constructor() {
182         _feeAddrWallet1 = payable(0x3027D1dBb279CD2bd40046F6e44D8A31c3c92177);
183         _feeAddrWallet2 = payable(0x3027D1dBb279CD2bd40046F6e44D8A31c3c92177);
184         _rOwned[_msgSender()] = _rTotal;
185         _isExcludedFromFee[owner()] = true;
186         _isExcludedFromFee[address(this)] = true;
187         _isExcludedFromFee[_feeAddrWallet1] = true;
188         _isExcludedFromFee[_feeAddrWallet2] = true;
189         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
190     }
191 
192     function name() public pure returns (string memory) {
193         return _name;
194     }
195 
196     function symbol() public pure returns (string memory) {
197         return _symbol;
198     }
199 
200     function decimals() public pure returns (uint8) {
201         return _decimals;
202     }
203 
204     function totalSupply() public pure override returns (uint256) {
205         return _tTotal;
206     }
207 
208     function balanceOf(address account) public view override returns (uint256) {
209         return tokenFromReflection(_rOwned[account]);
210     }
211 
212     function transfer(address recipient, uint256 amount) public override returns (bool) {
213         _transfer(_msgSender(), recipient, amount);
214         return true;
215     }
216 
217     function allowance(address owner, address spender) public view override returns (uint256) {
218         return _allowances[owner][spender];
219     }
220 
221     function approve(address spender, uint256 amount) public override returns (bool) {
222         _approve(_msgSender(), spender, amount);
223         return true;
224     }
225 
226     function transferFrom(
227         address sender,
228         address recipient,
229         uint256 amount
230     ) public override returns (bool) {
231         _transfer(sender, recipient, amount);
232         _approve(
233             sender,
234             _msgSender(),
235             _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
236         );
237         return true;
238     }
239 
240     function setCooldownEnabled(bool onoff) external onlyOwner {
241         cooldownEnabled = onoff;
242     }
243 
244     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
245         require(rAmount <= _rTotal, "Amount must be less than total reflections");
246         uint256 currentRate = _getRate();
247         return rAmount.div(currentRate);
248     }
249 
250     function _approve(
251         address owner,
252         address spender,
253         uint256 amount
254     ) private {
255         require(owner != address(0), "ERC20: approve from the zero address");
256         require(spender != address(0), "ERC20: approve to the zero address");
257         _allowances[owner][spender] = amount;
258         emit Approval(owner, spender, amount);
259     }
260 
261     function _transfer(
262         address from,
263         address to,
264         uint256 amount
265     ) private {
266         require(from != address(0), "ERC20: transfer from the zero address");
267         require(to != address(0), "ERC20: transfer to the zero address");
268         require(amount > 0, "Transfer amount must be greater than zero");
269         _feeAddr1 = 2;
270         _feeAddr2 = 10;
271         if (from != owner() && to != owner()) {
272             require(!bots[from] && !bots[to]);
273             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
274                 // Cooldown
275                 require(amount <= _maxTxAmount);
276                 require(cooldown[to] < block.timestamp);
277                 cooldown[to] = block.timestamp + (30 seconds);
278             }
279 
280             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !_isExcludedFromFee[from]) {
281                 _feeAddr1 = 2;
282                 _feeAddr2 = 10;
283             }
284             
285             uint256 contractTokenBalance = balanceOf(address(this));
286 
287             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
288                 if (contractTokenBalance > 0) {
289                     if (contractTokenBalance > balanceOf(uniswapV2Pair).mul(5).div(100)) {
290                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(5).div(100);
291                     }
292                     swapTokensForEth(contractTokenBalance);
293                 }
294 
295                 uint256 contractETHBalance = address(this).balance;
296                 if (contractETHBalance > 0) {
297                     sendETHToFee(address(this).balance);
298                 }
299             }
300         }
301 
302         _tokenTransfer(from, to, amount);
303     }
304 
305     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
306         address[] memory path = new address[](2);
307         path[0] = address(this);
308         path[1] = uniswapV2Router.WETH();
309         _approve(address(this), address(uniswapV2Router), tokenAmount);
310         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
311             tokenAmount,
312             0,
313             path,
314             address(this),
315             block.timestamp
316         );
317     }
318 
319     function sendETHToFee(uint256 amount) private {
320         _feeAddrWallet1.transfer(amount.div(2));
321         _feeAddrWallet2.transfer(amount.div(2));
322     }
323 
324     function openTrading() external onlyOwner {
325         require(!tradingOpen, "trading is already open");
326         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
327         uniswapV2Router = _uniswapV2Router;
328         _approve(address(this), address(uniswapV2Router), _tTotal);
329         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
330             address(this),
331             _uniswapV2Router.WETH()
332         );
333         uniswapV2Router.addLiquidityETH{ value: address(this).balance }(
334             address(this),
335             balanceOf(address(this)),
336             0,
337             0,
338             owner(),
339             block.timestamp
340         );
341         swapEnabled = true;
342         cooldownEnabled = true;
343         _maxTxAmount = 0.75 * 10**10 * 10**9; // 1.5% of 50% burn
344         tradingOpen = true;
345         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint256).max);
346     }
347 
348     function setBots(address[] memory bots_) public onlyOwner {
349         for (uint256 i = 0; i < bots_.length; i++) {
350             bots[bots_[i]] = true;
351         }
352     }
353 
354     function removeStrictTxLimit() public onlyOwner {
355         _maxTxAmount = 1e12 * 10**9;
356     }
357 
358     function delBot(address notbot) public onlyOwner {
359         bots[notbot] = false;
360     }
361 
362     function _tokenTransfer(
363         address sender,
364         address recipient,
365         uint256 amount
366     ) private {
367         _transferStandard(sender, recipient, amount);
368     }
369 
370     function _transferStandard(
371         address sender,
372         address recipient,
373         uint256 tAmount
374     ) private {
375         (
376             uint256 rAmount,
377             uint256 rTransferAmount,
378             uint256 rFee,
379             uint256 tTransferAmount,
380             uint256 tFee,
381             uint256 tTeam
382         ) = _getValues(tAmount);
383         _rOwned[sender] = _rOwned[sender].sub(rAmount);
384         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
385         _takeTeam(tTeam);
386         _reflectFee(rFee, tFee);
387         emit Transfer(sender, recipient, tTransferAmount);
388     }
389 
390     function _takeTeam(uint256 tTeam) private {
391         uint256 currentRate = _getRate();
392         uint256 rTeam = tTeam.mul(currentRate);
393         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
394     }
395 
396     function _reflectFee(uint256 rFee, uint256 tFee) private {
397         _rTotal = _rTotal.sub(rFee);
398         _tFeeTotal = _tFeeTotal.add(tFee);
399     }
400 
401     receive() external payable {}
402 
403     function manualswap() external {
404         require(_msgSender() == _feeAddrWallet1);
405         uint256 contractBalance = balanceOf(address(this));
406         swapTokensForEth(contractBalance);
407     }
408 
409     function manualsend() external {
410         require(_msgSender() == _feeAddrWallet1);
411         uint256 contractETHBalance = address(this).balance;
412         sendETHToFee(contractETHBalance);
413     }
414 
415     function _getValues(uint256 tAmount)
416         private
417         view
418         returns (
419             uint256,
420             uint256,
421             uint256,
422             uint256,
423             uint256,
424             uint256
425         )
426     {
427         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
428         uint256 currentRate = _getRate();
429         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
430         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
431     }
432 
433     function _getTValues(
434         uint256 tAmount,
435         uint256 taxFee,
436         uint256 TeamFee
437     )
438         private
439         pure
440         returns (
441             uint256,
442             uint256,
443             uint256
444         )
445     {
446         uint256 tFee = tAmount.mul(taxFee).div(100);
447         uint256 tTeam = tAmount.mul(TeamFee).div(100);
448         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
449         return (tTransferAmount, tFee, tTeam);
450     }
451 
452     function _getRValues(
453         uint256 tAmount,
454         uint256 tFee,
455         uint256 tTeam,
456         uint256 currentRate
457     )
458         private
459         pure
460         returns (
461             uint256,
462             uint256,
463             uint256
464         )
465     {
466         uint256 rAmount = tAmount.mul(currentRate);
467         uint256 rFee = tFee.mul(currentRate);
468         uint256 rTeam = tTeam.mul(currentRate);
469         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
470         return (rAmount, rTransferAmount, rFee);
471     }
472 
473     function _getRate() private view returns (uint256) {
474         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
475         return rSupply.div(tSupply);
476     }
477 
478     function _getCurrentSupply() private view returns (uint256, uint256) {
479         uint256 rSupply = _rTotal;
480         uint256 tSupply = _tTotal;
481         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
482         return (rSupply, tSupply);
483     }
484 }