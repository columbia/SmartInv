1 /*
2    PONGO INU token Official links:                                                                                                               
3   
4 - Website: https://www.pongoinutoken.com
5 - Telegram: https://t.me/pongoinutoken
6 - Twitter: https://twitter.com/pongoinutoken
7 
8 */
9 
10 //SPDX-License-Identifier: UNLICENSED
11 
12 pragma solidity ^0.8.9;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address recipient, uint256 amount)
26         external
27         returns (bool);
28 
29     function allowance(address owner, address spender)
30         external
31         view
32         returns (uint256);
33 
34     function approve(address spender, uint256 amount) external returns (bool);
35 
36     function transferFrom(
37         address sender,
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48 }
49 
50 library SafeMath {
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     function sub(
62         uint256 a,
63         uint256 b,
64         string memory errorMessage
65     ) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68         return c;
69     }
70 
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         if (a == 0) {
73             return 0;
74         }
75         uint256 c = a * b;
76         require(c / a == b, "SafeMath: multiplication overflow");
77         return c;
78     }
79 
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         return div(a, b, "SafeMath: division by zero");
82     }
83 
84     function div(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         require(b > 0, errorMessage);
90         uint256 c = a / b;
91         return c;
92     }
93 }
94 
95 contract Ownable is Context {
96     address private _owner;
97     address private _previousOwner;
98     event OwnershipTransferred(
99         address indexed previousOwner,
100         address indexed newOwner
101     );
102 
103     constructor() {
104         address msgSender = _msgSender();
105         _owner = msgSender;
106         emit OwnershipTransferred(address(0), msgSender);
107     }
108 
109     function owner() public view returns (address) {
110         return _owner;
111     }
112 
113     modifier onlyOwner() {
114         require(_owner == _msgSender(), "Ownable: caller is not the owner");
115         _;
116     }
117 
118     function renounceOwnership() public virtual onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122 }
123 
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB)
126         external
127         returns (address pair);
128 }
129 
130 interface IUniswapV2Router02 {
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint256 amountIn,
133         uint256 amountOutMin,
134         address[] calldata path,
135         address to,
136         uint256 deadline
137     ) external;
138 
139     function factory() external pure returns (address);
140 
141     function WETH() external pure returns (address);
142 
143     function addLiquidityETH(
144         address token,
145         uint256 amountTokenDesired,
146         uint256 amountTokenMin,
147         uint256 amountETHMin,
148         address to,
149         uint256 deadline
150     )
151         external
152         payable
153         returns (
154             uint256 amountToken,
155             uint256 amountETH,
156             uint256 liquidity
157         );
158 }
159 
160 contract PONGO is Context, IERC20, Ownable {
161     using SafeMath for uint256;
162     mapping(address => uint256) private _rOwned;
163     mapping(address => uint256) private _tOwned;
164     mapping(address => mapping(address => uint256)) private _allowances;
165     mapping(address => bool) private _isExcludedFromFee;
166     mapping(address => bool) private bots;
167     mapping(address => uint256) private cooldown;
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private constant _tTotal = 100000000000000 * 10**9;
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172     uint256 private _maxTxAmount = _tTotal;
173     uint256 private openBlock;
174     uint256 public _swapTokensAtAmount = 100000000000 * 10**9; //0.1%
175     uint256 private _maxWalletAmount = _tTotal;
176     uint256 private _feeAddr1;
177     uint256 private _feeAddr2;
178     address payable private _feeAddrWallet1;
179     address payable private _feeAddrWallet2;
180 
181     string private constant _name = "Pongo Inu";
182     string private constant _symbol = "PONGO";
183     uint8 private constant _decimals = 9;
184 
185     IUniswapV2Router02 private uniswapV2Router;
186     address private uniswapV2Pair;
187     bool private tradingOpen;
188     bool private inSwap = false;
189     bool private swapEnabled = false;
190     bool private cooldownEnabled = false;
191     
192     event MaxTxAmountUpdated(uint256 _maxTxAmount);
193     modifier lockTheSwap() {
194         inSwap = true;
195         _;
196         inSwap = false;
197     }
198 
199     constructor() {
200         _feeAddrWallet1 = payable(0x53651d97C17EB17BF6cF89DD61F04e3503ef3092);
201         _feeAddrWallet2 = payable(0x2ABD93A991e8a7eC6ad1744A87F11c91E5CfBe50);
202         _rOwned[_msgSender()] = _rTotal;
203         _isExcludedFromFee[owner()] = true;
204         _isExcludedFromFee[address(this)] = true;
205         _isExcludedFromFee[_feeAddrWallet1] = true;
206         _isExcludedFromFee[_feeAddrWallet2] = true;
207         emit Transfer(
208             address(0xF4d21606B870c619BE1D24A089130d6654B89704),
209             _msgSender(),
210             _tTotal
211         );
212     }
213 
214     function name() public pure returns (string memory) {
215         return _name;
216     }
217 
218     function symbol() public pure returns (string memory) {
219         return _symbol;
220     }
221 
222     function decimals() public pure returns (uint8) {
223         return _decimals;
224     }
225 
226     function totalSupply() public pure override returns (uint256) {
227         return _tTotal;
228     }
229 
230     function balanceOf(address account) public view override returns (uint256) {
231         return tokenFromReflection(_rOwned[account]);
232     }
233 
234     function transfer(address recipient, uint256 amount)
235         public
236         override
237         returns (bool)
238     {
239         _transfer(_msgSender(), recipient, amount);
240         return true;
241     }
242 
243     function allowance(address owner, address spender)
244         public
245         view
246         override
247         returns (uint256)
248     {
249         return _allowances[owner][spender];
250     }
251 
252     function approve(address spender, uint256 amount)
253         public
254         override
255         returns (bool)
256     {
257         _approve(_msgSender(), spender, amount);
258         return true;
259     }
260 
261     function transferFrom(
262         address sender,
263         address recipient,
264         uint256 amount
265     ) public override returns (bool) {
266         _transfer(sender, recipient, amount);
267         _approve(
268             sender,
269             _msgSender(),
270             _allowances[sender][_msgSender()].sub(
271                 amount,
272                 "ERC20: transfer amount exceeds allowance"
273             )
274         );
275         return true;
276     }
277 
278     function setCooldownEnabled(bool onoff) external onlyOwner {
279         cooldownEnabled = onoff;
280     }
281 
282     function tokenFromReflection(uint256 rAmount)
283         private
284         view
285         returns (uint256)
286     {
287         require(
288             rAmount <= _rTotal,
289             "Amount must be less than total reflections"
290         );
291         uint256 currentRate = _getRate();
292         return rAmount.div(currentRate);
293     }
294 
295     function _approve(
296         address owner,
297         address spender,
298         uint256 amount
299     ) private {
300         require(owner != address(0), "ERC20: approve from the zero address");
301         require(spender != address(0), "ERC20: approve to the zero address");
302         _allowances[owner][spender] = amount;
303         emit Approval(owner, spender, amount);
304     }
305 
306     function _transfer(
307         address from,
308         address to,
309         uint256 amount
310     ) private {
311 
312         require(from != address(0), "ERC20: transfer from the zero address");
313         require(to != address(0), "ERC20: transfer to the zero address");
314         require(amount > 0, "Transfer amount must be greater than zero");
315         
316        
317         _feeAddr1 = 4;
318         _feeAddr2 = 8;
319         if (from != owner() && to != owner() && from != address(this)) {
320             
321             
322             require(!bots[from] && !bots[to]);
323             if (
324                 from == uniswapV2Pair &&
325                 to != address(uniswapV2Router) &&
326                 !_isExcludedFromFee[to] &&
327                 cooldownEnabled
328             ) {
329                 
330                 // Not over max tx amount
331                 require(amount <= _maxTxAmount, "Over max transaction amount.");
332                 // Cooldown
333                 require(cooldown[to] < block.timestamp, "Cooldown enforced.");
334                 // Max wallet
335                 require(balanceOf(to) + amount <= _maxWalletAmount, "Over max wallet amount.");
336                 cooldown[to] = block.timestamp + (30 seconds);
337             }
338 
339             if (
340                 to == uniswapV2Pair &&
341                 from != address(uniswapV2Router) &&
342                 !_isExcludedFromFee[from]
343             ) {
344                 _feeAddr1 = 4;
345                 _feeAddr2 = 8;
346             }
347 
348             if (openBlock + 3 >= block.number && from == uniswapV2Pair) {
349                 _feeAddr1 = 99;
350                 _feeAddr2 = 1;
351             }
352 
353             uint256 contractTokenBalance = balanceOf(address(this));
354             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
355             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled) {
356                 
357                 swapTokensForEth(contractTokenBalance);
358                 uint256 contractETHBalance = address(this).balance;
359                 if (contractETHBalance > 0) {
360                     sendETHToFee(address(this).balance);
361                 }
362             }
363         } else {
364             // Only if it's not from or to owner or from contract address.
365             _feeAddr1 = 0;
366             _feeAddr2 = 0;
367         }
368 
369         _tokenTransfer(from, to, amount);
370     }
371 
372     function swapAndLiquifyEnabled(bool enabled) public onlyOwner {
373         inSwap = enabled;
374     }
375 
376     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
377         address[] memory path = new address[](2);
378         path[0] = address(this);
379         path[1] = uniswapV2Router.WETH();
380         _approve(address(this), address(uniswapV2Router), tokenAmount);
381         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
382             tokenAmount,
383             0,
384             path,
385             address(this),
386             block.timestamp
387         );
388     }
389 
390     function sendETHToFee(uint256 amount) private {
391         _feeAddrWallet1.transfer(amount.div(2));
392         _feeAddrWallet2.transfer(amount.div(2));
393     }
394 
395     function setMaxTxAmount(uint256 amount) public onlyOwner {
396         _maxTxAmount = amount * 10**9;
397     }
398     function setMaxWalletAmount(uint256 amount) public onlyOwner {
399         _maxWalletAmount = amount * 10**9;
400     }
401 
402 
403     function openTrading() external onlyOwner {
404         require(!tradingOpen, "trading is already open");
405         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
406             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
407         );
408         uniswapV2Router = _uniswapV2Router;
409         _approve(address(this), address(uniswapV2Router), _tTotal);
410         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
411             .createPair(address(this), _uniswapV2Router.WETH());
412         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
413             address(this),
414             balanceOf(address(this)),
415             0,
416             0,
417             owner(),
418             block.timestamp
419         );
420         swapEnabled = true;
421         cooldownEnabled = true;
422         // .5% 
423         _maxTxAmount = 1000000000001 * 10**9;
424         _maxWalletAmount = 2000000000001 * 10**9;
425         tradingOpen = true;
426         openBlock = block.number;
427         IERC20(uniswapV2Pair).approve(
428             address(uniswapV2Router),
429             type(uint256).max
430         );
431     }
432 
433     function addBot(address theBot) public onlyOwner {
434         bots[theBot] = true;
435     }
436 
437     function delBot(address notbot) public onlyOwner {
438         bots[notbot] = false;
439     }
440 
441 
442     function _tokenTransfer(
443         address sender,
444         address recipient,
445         uint256 amount
446     ) private {
447         _transferStandard(sender, recipient, amount);
448     }
449 
450     function _transferStandard(
451         address sender,
452         address recipient,
453         uint256 tAmount
454     ) private {
455         (
456             uint256 rAmount,
457             uint256 rTransferAmount,
458             uint256 rFee,
459             uint256 tTransferAmount,
460             uint256 tFee,
461             uint256 tTeam
462         ) = _getValues(tAmount);
463         _rOwned[sender] = _rOwned[sender].sub(rAmount);
464         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
465         _takeTeam(tTeam);
466         _reflectFee(rFee, tFee);
467         emit Transfer(sender, recipient, tTransferAmount);
468     }
469 
470     function _takeTeam(uint256 tTeam) private {
471         uint256 currentRate = _getRate();
472         uint256 rTeam = tTeam.mul(currentRate);
473         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
474     }
475 
476     function _reflectFee(uint256 rFee, uint256 tFee) private {
477         _rTotal = _rTotal.sub(rFee);
478         _tFeeTotal = _tFeeTotal.add(tFee);
479     }
480 
481     receive() external payable {}
482 
483     function manualSwap() external {
484         require(_msgSender() == _feeAddrWallet1);
485         uint256 contractBalance = balanceOf(address(this));
486         swapTokensForEth(contractBalance);
487     }
488 
489     function manualSend() external {
490         require(_msgSender() == _feeAddrWallet1);
491         uint256 contractETHBalance = address(this).balance;
492         sendETHToFee(contractETHBalance);
493     }
494 
495     function _getValues(uint256 tAmount)
496         private
497         view
498         returns (
499             uint256,
500             uint256,
501             uint256,
502             uint256,
503             uint256,
504             uint256
505         )
506     {
507         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
508             tAmount,
509             _feeAddr1,
510             _feeAddr2
511         );
512         uint256 currentRate = _getRate();
513         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
514             tAmount,
515             tFee,
516             tTeam,
517             currentRate
518         );
519         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
520     }
521 
522     function _getTValues(
523         uint256 tAmount,
524         uint256 taxFee,
525         uint256 TeamFee
526     )
527         private
528         pure
529         returns (
530             uint256,
531             uint256,
532             uint256
533         )
534     {
535         uint256 tFee = tAmount.mul(taxFee).div(100);
536         uint256 tTeam = tAmount.mul(TeamFee).div(100);
537         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
538         return (tTransferAmount, tFee, tTeam);
539     }
540 
541     function _getRValues(
542         uint256 tAmount,
543         uint256 tFee,
544         uint256 tTeam,
545         uint256 currentRate
546     )
547         private
548         pure
549         returns (
550             uint256,
551             uint256,
552             uint256
553         )
554     {
555         uint256 rAmount = tAmount.mul(currentRate);
556         uint256 rFee = tFee.mul(currentRate);
557         uint256 rTeam = tTeam.mul(currentRate);
558         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
559         return (rAmount, rTransferAmount, rFee);
560     }
561 
562     
563 
564     function _getRate() private view returns (uint256) {
565         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
566         return rSupply.div(tSupply);
567     }
568 
569     function _getCurrentSupply() private view returns (uint256, uint256) {
570         uint256 rSupply = _rTotal;
571         uint256 tSupply = _tTotal;
572         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
573         return (rSupply, tSupply);
574     }
575 }