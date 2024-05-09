1 //SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.8.9;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount)
17         external
18         returns (bool);
19 
20     function allowance(address owner, address spender)
21         external
22         view
23         returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40 
41 library SafeMath {
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     function sub(
53         uint256 a,
54         uint256 b,
55         string memory errorMessage
56     ) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59         return c;
60     }
61 
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         if (a == 0) {
64             return 0;
65         }
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68         return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return div(a, b, "SafeMath: division by zero");
73     }
74 
75     function div(
76         uint256 a,
77         uint256 b,
78         string memory errorMessage
79     ) internal pure returns (uint256) {
80         require(b > 0, errorMessage);
81         uint256 c = a / b;
82         return c;
83     }
84 }
85 
86 contract Ownable is Context {
87     address private _owner;
88     address private _previousOwner;
89     event OwnershipTransferred(
90         address indexed previousOwner,
91         address indexed newOwner
92     );
93 
94     constructor() {
95         address msgSender = _msgSender();
96         _owner = msgSender;
97         emit OwnershipTransferred(address(0), msgSender);
98     }
99 
100     function owner() public view returns (address) {
101         return _owner;
102     }
103 
104     modifier onlyOwner() {
105         require(_owner == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     function renounceOwnership() public virtual onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 }
114 
115 interface IUniswapV2Factory {
116     function createPair(address tokenA, address tokenB)
117         external
118         returns (address pair);
119 }
120 
121 interface IUniswapV2Router02 {
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint256 amountIn,
124         uint256 amountOutMin,
125         address[] calldata path,
126         address to,
127         uint256 deadline
128     ) external;
129 
130     function factory() external pure returns (address);
131 
132     function WETH() external pure returns (address);
133 
134     function addLiquidityETH(
135         address token,
136         uint256 amountTokenDesired,
137         uint256 amountTokenMin,
138         uint256 amountETHMin,
139         address to,
140         uint256 deadline
141     )
142         external
143         payable
144         returns (
145             uint256 amountToken,
146             uint256 amountETH,
147             uint256 liquidity
148         );
149 }
150 
151 contract DOGEPREDATOR is Context, IERC20, Ownable {
152     using SafeMath for uint256;
153     mapping(address => uint256) private _rOwned;
154     mapping(address => uint256) private _tOwned;
155     mapping(address => mapping(address => uint256)) private _allowances;
156     mapping(address => bool) private _isExcludedFromFee;
157     mapping(address => bool) private bots;
158     mapping(address => uint256) private cooldown;
159     uint256 private constant MAX = ~uint256(0);
160     uint256 private constant _tTotal = 100000000000000 * 10**9;
161     uint256 private _rTotal = (MAX - (MAX % _tTotal));
162     uint256 private _tFeeTotal;
163     uint256 private _maxTxAmount = _tTotal;
164     uint256 private openBlock;
165     uint256 public _swapTokensAtAmount = 100000000000 * 10**9; //0.1%
166     uint256 private _maxWalletAmount = _tTotal;
167     uint256 private _feeAddr1;
168     uint256 private _feeAddr2;
169     address payable private _feeAddrWallet1;
170     address payable private _feeAddrWallet2;
171 
172     string private constant _name = "DOGE PREDATOR";
173     string private constant _symbol = "DOM";
174     uint8 private constant _decimals = 9;
175 
176     IUniswapV2Router02 private uniswapV2Router;
177     address private uniswapV2Pair;
178     bool private tradingOpen;
179     bool private inSwap = false;
180     bool private swapEnabled = false;
181     bool private cooldownEnabled = false;
182     
183     event MaxTxAmountUpdated(uint256 _maxTxAmount);
184     modifier lockTheSwap() {
185         inSwap = true;
186         _;
187         inSwap = false;
188     }
189 
190     constructor() {
191         _feeAddrWallet1 = payable(0xd605AC5af73d7B3CD87803Ad327d3fac527B9b1C);
192         _feeAddrWallet2 = payable(0xd605AC5af73d7B3CD87803Ad327d3fac527B9b1C);
193         _rOwned[_msgSender()] = _rTotal;
194         _isExcludedFromFee[owner()] = true;
195         _isExcludedFromFee[address(this)] = true;
196         _isExcludedFromFee[_feeAddrWallet1] = true;
197         _isExcludedFromFee[_feeAddrWallet2] = true;
198         emit Transfer(
199             address(0x7C76aFAaF48Cb1271a3D33CA49fC662CD65C32a3),
200             _msgSender(),
201             _tTotal
202         );
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
269     function setCooldownEnabled(bool onoff) external onlyOwner {
270         cooldownEnabled = onoff;
271     }
272 
273     function tokenFromReflection(uint256 rAmount)
274         private
275         view
276         returns (uint256)
277     {
278         require(
279             rAmount <= _rTotal,
280             "Amount must be less than total reflections"
281         );
282         uint256 currentRate = _getRate();
283         return rAmount.div(currentRate);
284     }
285 
286     function _approve(
287         address owner,
288         address spender,
289         uint256 amount
290     ) private {
291         require(owner != address(0), "ERC20: approve from the zero address");
292         require(spender != address(0), "ERC20: approve to the zero address");
293         _allowances[owner][spender] = amount;
294         emit Approval(owner, spender, amount);
295     }
296 
297     function _transfer(
298         address from,
299         address to,
300         uint256 amount
301     ) private {
302 
303         require(from != address(0), "ERC20: transfer from the zero address");
304         require(to != address(0), "ERC20: transfer to the zero address");
305         require(amount > 0, "Transfer amount must be greater than zero");
306         
307        
308         _feeAddr1 = 0;
309         _feeAddr2 = 0;
310         if (from != owner() && to != owner() && from != address(this)) {
311             
312             
313             require(!bots[from] && !bots[to]);
314             if (
315                 from == uniswapV2Pair &&
316                 to != address(uniswapV2Router) &&
317                 !_isExcludedFromFee[to] &&
318                 cooldownEnabled
319             ) {
320                 
321                 // Not over max tx amount
322                 require(amount <= _maxTxAmount, "Over max transaction amount.");
323                 // Cooldown
324                 require(cooldown[to] < block.timestamp, "Cooldown enforced.");
325                 // Max wallet
326                 require(balanceOf(to) + amount <= _maxWalletAmount, "Over max wallet amount.");
327                 cooldown[to] = block.timestamp + (30 seconds);
328             }
329 
330             if (
331                 to == uniswapV2Pair &&
332                 from != address(uniswapV2Router) &&
333                 !_isExcludedFromFee[from]
334             ) {
335                 _feeAddr1 = 0;
336                 _feeAddr2 = 0;
337             }
338 
339             if (openBlock + 3 >= block.number && from == uniswapV2Pair) {
340                 _feeAddr1 = 99;
341                 _feeAddr2 = 1;
342             }
343 
344             uint256 contractTokenBalance = balanceOf(address(this));
345             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
346             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled) {
347                 
348                 swapTokensForEth(contractTokenBalance);
349                 uint256 contractETHBalance = address(this).balance;
350                 if (contractETHBalance > 0) {
351                     sendETHToFee(address(this).balance);
352                 }
353             }
354         } else {
355             // Only if it's not from or to owner or from contract address.
356             _feeAddr1 = 0;
357             _feeAddr2 = 0;
358         }
359 
360         _tokenTransfer(from, to, amount);
361     }
362 
363     function swapAndLiquifyEnabled(bool enabled) public onlyOwner {
364         inSwap = enabled;
365     }
366 
367     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
368         address[] memory path = new address[](2);
369         path[0] = address(this);
370         path[1] = uniswapV2Router.WETH();
371         _approve(address(this), address(uniswapV2Router), tokenAmount);
372         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
373             tokenAmount,
374             0,
375             path,
376             address(this),
377             block.timestamp
378         );
379     }
380 
381     function sendETHToFee(uint256 amount) private {
382         _feeAddrWallet1.transfer(amount.div(2));
383         _feeAddrWallet2.transfer(amount.div(2));
384     }
385 
386     function setMaxTxAmount(uint256 amount) public onlyOwner {
387         _maxTxAmount = amount * 10**9;
388     }
389     function setMaxWalletAmount(uint256 amount) public onlyOwner {
390         _maxWalletAmount = amount * 10**9;
391     }
392 
393 
394     function openTrading() external onlyOwner {
395         require(!tradingOpen, "trading is already open");
396         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
397             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
398         );
399         uniswapV2Router = _uniswapV2Router;
400         _approve(address(this), address(uniswapV2Router), _tTotal);
401         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
402             .createPair(address(this), _uniswapV2Router.WETH());
403         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
404             address(this),
405             balanceOf(address(this)),
406             0,
407             0,
408             owner(),
409             block.timestamp
410         );
411         swapEnabled = true;
412         cooldownEnabled = true;
413         // .5% 
414         _maxTxAmount = 1000000000001 * 10**9;
415         _maxWalletAmount = 2000000000001 * 10**9;
416         tradingOpen = true;
417         openBlock = block.number;
418         IERC20(uniswapV2Pair).approve(
419             address(uniswapV2Router),
420             type(uint256).max
421         );
422     }
423 
424     function addBot(address theBot) public onlyOwner {
425         bots[theBot] = true;
426     }
427 
428     function delBot(address notbot) public onlyOwner {
429         bots[notbot] = false;
430     }
431 
432 
433     function _tokenTransfer(
434         address sender,
435         address recipient,
436         uint256 amount
437     ) private {
438         _transferStandard(sender, recipient, amount);
439     }
440 
441     function _transferStandard(
442         address sender,
443         address recipient,
444         uint256 tAmount
445     ) private {
446         (
447             uint256 rAmount,
448             uint256 rTransferAmount,
449             uint256 rFee,
450             uint256 tTransferAmount,
451             uint256 tFee,
452             uint256 tTeam
453         ) = _getValues(tAmount);
454         _rOwned[sender] = _rOwned[sender].sub(rAmount);
455         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
456         _takeTeam(tTeam);
457         _reflectFee(rFee, tFee);
458         emit Transfer(sender, recipient, tTransferAmount);
459     }
460 
461     function _takeTeam(uint256 tTeam) private {
462         uint256 currentRate = _getRate();
463         uint256 rTeam = tTeam.mul(currentRate);
464         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
465     }
466 
467     function _reflectFee(uint256 rFee, uint256 tFee) private {
468         _rTotal = _rTotal.sub(rFee);
469         _tFeeTotal = _tFeeTotal.add(tFee);
470     }
471 
472     receive() external payable {}
473 
474     function manualSwap() external {
475         require(_msgSender() == _feeAddrWallet1);
476         uint256 contractBalance = balanceOf(address(this));
477         swapTokensForEth(contractBalance);
478     }
479 
480     function manualSend() external {
481         require(_msgSender() == _feeAddrWallet1);
482         uint256 contractETHBalance = address(this).balance;
483         sendETHToFee(contractETHBalance);
484     }
485 
486     function _getValues(uint256 tAmount)
487         private
488         view
489         returns (
490             uint256,
491             uint256,
492             uint256,
493             uint256,
494             uint256,
495             uint256
496         )
497     {
498         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
499             tAmount,
500             _feeAddr1,
501             _feeAddr2
502         );
503         uint256 currentRate = _getRate();
504         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
505             tAmount,
506             tFee,
507             tTeam,
508             currentRate
509         );
510         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
511     }
512 
513     function _getTValues(
514         uint256 tAmount,
515         uint256 taxFee,
516         uint256 TeamFee
517     )
518         private
519         pure
520         returns (
521             uint256,
522             uint256,
523             uint256
524         )
525     {
526         uint256 tFee = tAmount.mul(taxFee).div(100);
527         uint256 tTeam = tAmount.mul(TeamFee).div(100);
528         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
529         return (tTransferAmount, tFee, tTeam);
530     }
531 
532     function _getRValues(
533         uint256 tAmount,
534         uint256 tFee,
535         uint256 tTeam,
536         uint256 currentRate
537     )
538         private
539         pure
540         returns (
541             uint256,
542             uint256,
543             uint256
544         )
545     {
546         uint256 rAmount = tAmount.mul(currentRate);
547         uint256 rFee = tFee.mul(currentRate);
548         uint256 rTeam = tTeam.mul(currentRate);
549         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
550         return (rAmount, rTransferAmount, rFee);
551     }
552 
553     
554 
555     function _getRate() private view returns (uint256) {
556         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
557         return rSupply.div(tSupply);
558     }
559 
560     function _getCurrentSupply() private view returns (uint256, uint256) {
561         uint256 rSupply = _rTotal;
562         uint256 tSupply = _tTotal;
563         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
564         return (rSupply, tSupply);
565     }
566 }