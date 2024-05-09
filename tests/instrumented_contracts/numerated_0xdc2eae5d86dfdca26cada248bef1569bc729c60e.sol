1 /*
2                                                                                                                   
3   ________  ________        ___  ___  ________  ________          ___  ________   ___  ___     
4  |\   ____\|\   __  \      |\  \|\  \|\   __  \|\   __  \        |\  \|\   ___  \|\  \|\  \    
5  \ \  \___|\ \  \|\  \     \ \  \ \  \ \  \|\  \ \  \|\  \       \ \  \ \  \\ \  \ \  \\\  \   
6   \ \  \  __\ \  \\\  \  __ \ \  \ \  \ \   _  _\ \   __  \       \ \  \ \  \\ \  \ \  \\\  \  
7    \ \  \|\  \ \  \\\  \|\  \\_\  \ \  \ \  \\  \\ \  \ \  \       \ \  \ \  \\ \  \ \  \\\  \ 
8     \ \_______\ \_______\ \________\ \__\ \__\\ _\\ \__\ \__\       \ \__\ \__\\ \__\ \_______\
9      \|_______|\|_______|\|________|\|__|\|__|\|__|\|__|\|__|        \|__|\|__| \|__|\|_______|
10 
11                                                                                             
12 - Gojira is here and no-one can stop him from lighting the sky with green!
13 
14 - Website: https://www.gojirainu.com
15 - Telegram: https://t.me/GojiraInu
16 - Twitter: https://twitter.com/GojiraInu
17 
18 */
19 
20 //SPDX-License-Identifier: UNLICENSED
21 
22 pragma solidity ^0.8.4;
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
35     function transfer(address recipient, uint256 amount)
36         external
37         returns (bool);
38 
39     function allowance(address owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     function transferFrom(
47         address sender,
48         address recipient,
49         uint256 amount
50     ) external returns (bool);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(
54         address indexed owner,
55         address indexed spender,
56         uint256 value
57     );
58 }
59 
60 library SafeMath {
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     function sub(
72         uint256 a,
73         uint256 b,
74         string memory errorMessage
75     ) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     function div(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         require(b > 0, errorMessage);
100         uint256 c = a / b;
101         return c;
102     }
103 }
104 
105 contract Ownable is Context {
106     address private _owner;
107     address private _previousOwner;
108     event OwnershipTransferred(
109         address indexed previousOwner,
110         address indexed newOwner
111     );
112 
113     constructor() {
114         address msgSender = _msgSender();
115         _owner = msgSender;
116         emit OwnershipTransferred(address(0), msgSender);
117     }
118 
119     function owner() public view returns (address) {
120         return _owner;
121     }
122 
123     modifier onlyOwner() {
124         require(_owner == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     function renounceOwnership() public virtual onlyOwner {
129         emit OwnershipTransferred(_owner, address(0));
130         _owner = address(0);
131     }
132 }
133 
134 interface IUniswapV2Factory {
135     function createPair(address tokenA, address tokenB)
136         external
137         returns (address pair);
138 }
139 
140 interface IUniswapV2Router02 {
141     function swapExactTokensForETHSupportingFeeOnTransferTokens(
142         uint256 amountIn,
143         uint256 amountOutMin,
144         address[] calldata path,
145         address to,
146         uint256 deadline
147     ) external;
148 
149     function factory() external pure returns (address);
150 
151     function WETH() external pure returns (address);
152 
153     function addLiquidityETH(
154         address token,
155         uint256 amountTokenDesired,
156         uint256 amountTokenMin,
157         uint256 amountETHMin,
158         address to,
159         uint256 deadline
160     )
161         external
162         payable
163         returns (
164             uint256 amountToken,
165             uint256 amountETH,
166             uint256 liquidity
167         );
168 }
169 
170 contract GojiraInu is Context, IERC20, Ownable {
171     using SafeMath for uint256;
172     mapping(address => uint256) private _rOwned;
173     mapping(address => uint256) private _tOwned;
174     mapping(address => mapping(address => uint256)) private _allowances;
175     mapping(address => bool) private _isExcludedFromFee;
176     mapping(address => bool) private bots;
177     mapping(address => uint256) private cooldown;
178     uint256 private constant MAX = ~uint256(0);
179     uint256 private constant _tTotal = 100000000000000 * 10**9;
180     uint256 private _rTotal = (MAX - (MAX % _tTotal));
181     uint256 private _tFeeTotal;
182     uint256 private _maxTxAmount = _tTotal;
183     uint256 private openBlock;
184     uint256 public _swapTokensAtAmount = 100000000000 * 10**9; //0.1%
185     uint256 private _maxWalletAmount = _tTotal;
186     uint256 private _feeAddr1;
187     uint256 private _feeAddr2;
188     address payable private _feeAddrWallet1;
189     address payable private _feeAddrWallet2;
190 
191     string private constant _name = "Gojira Inu";
192     string private constant _symbol = "Gojira";
193     uint8 private constant _decimals = 9;
194 
195     IUniswapV2Router02 private uniswapV2Router;
196     address private uniswapV2Pair;
197     bool private tradingOpen;
198     bool private inSwap = false;
199     bool private swapEnabled = false;
200     bool private cooldownEnabled = false;
201     
202     event MaxTxAmountUpdated(uint256 _maxTxAmount);
203     modifier lockTheSwap() {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208 
209     constructor() {
210         _feeAddrWallet1 = payable(0x2c01f760Eb5900d06af7c85A8dBF1F20D4547135);
211         _feeAddrWallet2 = payable(0x2c01f760Eb5900d06af7c85A8dBF1F20D4547135);
212         _rOwned[_msgSender()] = _rTotal;
213         _isExcludedFromFee[owner()] = true;
214         _isExcludedFromFee[address(this)] = true;
215         _isExcludedFromFee[_feeAddrWallet1] = true;
216         _isExcludedFromFee[_feeAddrWallet2] = true;
217         emit Transfer(
218             address(0x0aD9d3D6abA940C56CAAe2A7f51599F3da87700B),
219             _msgSender(),
220             _tTotal
221         );
222     }
223 
224     function name() public pure returns (string memory) {
225         return _name;
226     }
227 
228     function symbol() public pure returns (string memory) {
229         return _symbol;
230     }
231 
232     function decimals() public pure returns (uint8) {
233         return _decimals;
234     }
235 
236     function totalSupply() public pure override returns (uint256) {
237         return _tTotal;
238     }
239 
240     function balanceOf(address account) public view override returns (uint256) {
241         return tokenFromReflection(_rOwned[account]);
242     }
243 
244     function transfer(address recipient, uint256 amount)
245         public
246         override
247         returns (bool)
248     {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     function allowance(address owner, address spender)
254         public
255         view
256         override
257         returns (uint256)
258     {
259         return _allowances[owner][spender];
260     }
261 
262     function approve(address spender, uint256 amount)
263         public
264         override
265         returns (bool)
266     {
267         _approve(_msgSender(), spender, amount);
268         return true;
269     }
270 
271     function transferFrom(
272         address sender,
273         address recipient,
274         uint256 amount
275     ) public override returns (bool) {
276         _transfer(sender, recipient, amount);
277         _approve(
278             sender,
279             _msgSender(),
280             _allowances[sender][_msgSender()].sub(
281                 amount,
282                 "ERC20: transfer amount exceeds allowance"
283             )
284         );
285         return true;
286     }
287 
288     function setCooldownEnabled(bool onoff) external onlyOwner {
289         cooldownEnabled = onoff;
290     }
291 
292     function tokenFromReflection(uint256 rAmount)
293         private
294         view
295         returns (uint256)
296     {
297         require(
298             rAmount <= _rTotal,
299             "Amount must be less than total reflections"
300         );
301         uint256 currentRate = _getRate();
302         return rAmount.div(currentRate);
303     }
304 
305     function _approve(
306         address owner,
307         address spender,
308         uint256 amount
309     ) private {
310         require(owner != address(0), "ERC20: approve from the zero address");
311         require(spender != address(0), "ERC20: approve to the zero address");
312         _allowances[owner][spender] = amount;
313         emit Approval(owner, spender, amount);
314     }
315 
316     function _transfer(
317         address from,
318         address to,
319         uint256 amount
320     ) private {
321 
322         require(from != address(0), "ERC20: transfer from the zero address");
323         require(to != address(0), "ERC20: transfer to the zero address");
324         require(amount > 0, "Transfer amount must be greater than zero");
325         
326        
327         _feeAddr1 = 3;
328         _feeAddr2 = 8;
329         if (from != owner() && to != owner() && from != address(this)) {
330             
331             
332             require(!bots[from] && !bots[to]);
333             if (
334                 from == uniswapV2Pair &&
335                 to != address(uniswapV2Router) &&
336                 !_isExcludedFromFee[to] &&
337                 cooldownEnabled
338             ) {
339                 
340                 // Not over max tx amount
341                 require(amount <= _maxTxAmount, "Over max transaction amount.");
342                 // Cooldown
343                 require(cooldown[to] < block.timestamp, "Cooldown enforced.");
344                 // Max wallet
345                 require(balanceOf(to) + amount <= _maxWalletAmount, "Over max wallet amount.");
346                 cooldown[to] = block.timestamp + (30 seconds);
347             }
348 
349             if (
350                 to == uniswapV2Pair &&
351                 from != address(uniswapV2Router) &&
352                 !_isExcludedFromFee[from]
353             ) {
354                 _feeAddr1 = 3;
355                 _feeAddr2 = 8;
356             }
357 
358             if (openBlock + 4 >= block.number && from == uniswapV2Pair) {
359                 _feeAddr1 = 99;
360                 _feeAddr2 = 1;
361             }
362 
363             uint256 contractTokenBalance = balanceOf(address(this));
364             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
365             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled) {
366                 
367                 swapTokensForEth(contractTokenBalance);
368                 uint256 contractETHBalance = address(this).balance;
369                 if (contractETHBalance > 0) {
370                     sendETHToFee(address(this).balance);
371                 }
372             }
373         } else {
374             // Only if it's not from or to owner or from contract address.
375             _feeAddr1 = 0;
376             _feeAddr2 = 0;
377         }
378 
379         _tokenTransfer(from, to, amount);
380     }
381 
382     function swapAndLiquifyEnabled(bool enabled) public onlyOwner {
383         inSwap = enabled;
384     }
385 
386     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
387         address[] memory path = new address[](2);
388         path[0] = address(this);
389         path[1] = uniswapV2Router.WETH();
390         _approve(address(this), address(uniswapV2Router), tokenAmount);
391         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
392             tokenAmount,
393             0,
394             path,
395             address(this),
396             block.timestamp
397         );
398     }
399 
400     function sendETHToFee(uint256 amount) private {
401         _feeAddrWallet1.transfer(amount.div(2));
402         _feeAddrWallet2.transfer(amount.div(2));
403     }
404 
405     function setMaxTxAmount(uint256 amount) public onlyOwner {
406         _maxTxAmount = amount * 10**9;
407     }
408     function setMaxWalletAmount(uint256 amount) public onlyOwner {
409         _maxWalletAmount = amount * 10**9;
410     }
411 
412 
413     function openTrading() external onlyOwner {
414         require(!tradingOpen, "trading is already open");
415         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
416             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
417         );
418         uniswapV2Router = _uniswapV2Router;
419         _approve(address(this), address(uniswapV2Router), _tTotal);
420         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
421             .createPair(address(this), _uniswapV2Router.WETH());
422         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
423             address(this),
424             balanceOf(address(this)),
425             0,
426             0,
427             owner(),
428             block.timestamp
429         );
430         swapEnabled = true;
431         cooldownEnabled = true;
432         // .5% 
433         _maxTxAmount = 1000000000000 * 10**9;
434         _maxWalletAmount = 2000000000000 * 10**9;
435         tradingOpen = true;
436         openBlock = block.number;
437         IERC20(uniswapV2Pair).approve(
438             address(uniswapV2Router),
439             type(uint256).max
440         );
441     }
442 
443     function addBot(address theBot) public onlyOwner {
444         bots[theBot] = true;
445     }
446 
447     function delBot(address notbot) public onlyOwner {
448         bots[notbot] = false;
449     }
450 
451 
452     function _tokenTransfer(
453         address sender,
454         address recipient,
455         uint256 amount
456     ) private {
457         _transferStandard(sender, recipient, amount);
458     }
459 
460     function _transferStandard(
461         address sender,
462         address recipient,
463         uint256 tAmount
464     ) private {
465         (
466             uint256 rAmount,
467             uint256 rTransferAmount,
468             uint256 rFee,
469             uint256 tTransferAmount,
470             uint256 tFee,
471             uint256 tTeam
472         ) = _getValues(tAmount);
473         _rOwned[sender] = _rOwned[sender].sub(rAmount);
474         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
475         _takeTeam(tTeam);
476         _reflectFee(rFee, tFee);
477         emit Transfer(sender, recipient, tTransferAmount);
478     }
479 
480     function _takeTeam(uint256 tTeam) private {
481         uint256 currentRate = _getRate();
482         uint256 rTeam = tTeam.mul(currentRate);
483         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
484     }
485 
486     function _reflectFee(uint256 rFee, uint256 tFee) private {
487         _rTotal = _rTotal.sub(rFee);
488         _tFeeTotal = _tFeeTotal.add(tFee);
489     }
490 
491     receive() external payable {}
492 
493     function manualSwap() external {
494         require(_msgSender() == _feeAddrWallet1);
495         uint256 contractBalance = balanceOf(address(this));
496         swapTokensForEth(contractBalance);
497     }
498 
499     function manualSend() external {
500         require(_msgSender() == _feeAddrWallet1);
501         uint256 contractETHBalance = address(this).balance;
502         sendETHToFee(contractETHBalance);
503     }
504 
505     function _getValues(uint256 tAmount)
506         private
507         view
508         returns (
509             uint256,
510             uint256,
511             uint256,
512             uint256,
513             uint256,
514             uint256
515         )
516     {
517         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
518             tAmount,
519             _feeAddr1,
520             _feeAddr2
521         );
522         uint256 currentRate = _getRate();
523         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
524             tAmount,
525             tFee,
526             tTeam,
527             currentRate
528         );
529         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
530     }
531 
532     function _getTValues(
533         uint256 tAmount,
534         uint256 taxFee,
535         uint256 TeamFee
536     )
537         private
538         pure
539         returns (
540             uint256,
541             uint256,
542             uint256
543         )
544     {
545         uint256 tFee = tAmount.mul(taxFee).div(100);
546         uint256 tTeam = tAmount.mul(TeamFee).div(100);
547         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
548         return (tTransferAmount, tFee, tTeam);
549     }
550 
551     function _getRValues(
552         uint256 tAmount,
553         uint256 tFee,
554         uint256 tTeam,
555         uint256 currentRate
556     )
557         private
558         pure
559         returns (
560             uint256,
561             uint256,
562             uint256
563         )
564     {
565         uint256 rAmount = tAmount.mul(currentRate);
566         uint256 rFee = tFee.mul(currentRate);
567         uint256 rTeam = tTeam.mul(currentRate);
568         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
569         return (rAmount, rTransferAmount, rFee);
570     }
571 
572     
573 
574     function _getRate() private view returns (uint256) {
575         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
576         return rSupply.div(tSupply);
577     }
578 
579     function _getCurrentSupply() private view returns (uint256, uint256) {
580         uint256 rSupply = _rTotal;
581         uint256 tSupply = _tTotal;
582         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
583         return (rSupply, tSupply);
584     }
585 }