1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-29
3 */
4 
5 /*
6 
7 Piccolo Inu (PINU)
8 
9 Official Links:
10 
11 Telegram:
12 https://t.me/PiccoloInu
13 
14 Website: 
15 https://www.piccoloinu.com/
16 
17 */
18 
19 // SPDX-License-Identifier: Unlicensed
20 
21 pragma solidity ^0.8.4;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address account) external view returns (uint256);
33 
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(
48         address indexed owner,
49         address indexed spender,
50         uint256 value
51     );
52 }
53 
54 contract Ownable is Context {
55     address private _owner;
56     address private _previousOwner;
57     event OwnershipTransferred(
58         address indexed previousOwner,
59         address indexed newOwner
60     );
61 
62     constructor() {
63         address msgSender = _msgSender();
64         _owner = msgSender;
65         emit OwnershipTransferred(address(0), msgSender);
66     }
67 
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     modifier onlyOwner() {
73         require(_owner == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 }
82 
83 library SafeMath {
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87         return c;
88     }
89 
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         return sub(a, b, "SafeMath: subtraction overflow");
92     }
93 
94     function sub(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         require(b <= a, errorMessage);
100         uint256 c = a - b;
101         return c;
102     }
103 
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         if (a == 0) {
106             return 0;
107         }
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110         return c;
111     }
112 
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116 
117     function div(
118         uint256 a,
119         uint256 b,
120         string memory errorMessage
121     ) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         return c;
125     }
126 }
127 
128 interface IUniswapV2Factory {
129     function createPair(address tokenA, address tokenB)
130         external
131         returns (address pair);
132 }
133 
134 interface IUniswapV2Router02 {
135     function swapExactTokensForETHSupportingFeeOnTransferTokens(
136         uint256 amountIn,
137         uint256 amountOutMin,
138         address[] calldata path,
139         address to,
140         uint256 deadline
141     ) external;
142 
143     function factory() external pure returns (address);
144 
145     function WETH() external pure returns (address);
146 
147     function addLiquidityETH(
148         address token,
149         uint256 amountTokenDesired,
150         uint256 amountTokenMin,
151         uint256 amountETHMin,
152         address to,
153         uint256 deadline
154     )
155         external
156         payable
157         returns (
158             uint256 amountToken,
159             uint256 amountETH,
160             uint256 liquidity
161         );
162 }
163 
164 contract PiccoloInu is Context, IERC20, Ownable {
165     
166     using SafeMath for uint256;
167 
168     string private constant _name = "Piccolo Inu";
169     string private constant _symbol = "PINU";
170     uint8 private constant _decimals = 9;
171 
172     mapping(address => uint256) private _rOwned;
173     mapping(address => uint256) private _tOwned;
174     mapping(address => mapping(address => uint256)) private _allowances;
175     mapping(address => bool) private _isExcludedFromFee;
176     uint256 private constant MAX = ~uint256(0);
177     uint256 private constant _tTotal = 100000000000000 * 10**9;
178     uint256 private _rTotal = (MAX - (MAX % _tTotal));
179     uint256 private _tFeeTotal;
180     
181     //Buy Fee
182     uint256 private _redisFeeOnBuy = 2;
183     uint256 private _taxFeeOnBuy = 7;
184     
185     //Sell Fee
186     uint256 private _redisFeeOnSell = 2;
187     uint256 private _taxFeeOnSell = 7;
188     
189     //Original Fee
190     uint256 private _redisFee = _redisFeeOnSell;
191     uint256 private _taxFee = _taxFeeOnSell;
192     
193     uint256 private _previousredisFee = _redisFee;
194     uint256 private _previoustaxFee = _taxFee;
195     
196     mapping(address => bool) public bots;
197     mapping (address => bool) public preTrader;
198     mapping(address => uint256) private cooldown;
199     
200     address payable private _marketingAddress = payable(0xD8F611f3aE837f94929C0A4217262B9e6Bff7199);
201     
202     IUniswapV2Router02 public uniswapV2Router;
203     address public uniswapV2Pair;
204     
205     bool private tradingOpen;
206     bool private inSwap = false;
207     bool private swapEnabled = true;
208     
209     uint256 public _maxTxAmount = 750000000000 * 10**9; //0.75
210     uint256 public _maxWalletSize = 1500000000000 * 10**9; //1.5
211     uint256 public _swapTokensAtAmount = 10000000000 * 10**9; //0.1
212 
213     event MaxTxAmountUpdated(uint256 _maxTxAmount);
214     modifier lockTheSwap {
215         inSwap = true;
216         _;
217         inSwap = false;
218     }
219 
220     constructor() {
221         
222         _rOwned[_msgSender()] = _rTotal;
223         
224         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
225         uniswapV2Router = _uniswapV2Router;
226         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
227             .createPair(address(this), _uniswapV2Router.WETH());
228 
229         _isExcludedFromFee[owner()] = true;
230         _isExcludedFromFee[address(this)] = true;
231         _isExcludedFromFee[_marketingAddress] = true;
232         
233         preTrader[owner()] = true;
234         
235         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
236         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
237         bots[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
238         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
239         bots[address(0xbcC7f6355bc08f6b7d3a41322CE4627118314763)] = true;
240         bots[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
241         bots[address(0x000000000035B5e5ad9019092C665357240f594e)] = true;
242         bots[address(0x1315c6C26123383a2Eb369a53Fb72C4B9f227EeC)] = true;
243         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
244         bots[address(0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C)] = true;
245         bots[address(0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA)] = true;
246         bots[address(0x42c1b5e32d625b6C618A02ae15189035e0a92FE7)] = true;
247         bots[address(0xA94E56EFc384088717bb6edCccEc289A72Ec2381)] = true;
248         bots[address(0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31)] = true;
249         bots[address(0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27)] = true;
250         bots[address(0xEE2A9147ffC94A73f6b945A6DB532f8466B78830)] = true;
251         bots[address(0xdE2a6d80989C3992e11B155430c3F59792FF8Bb7)] = true;
252         bots[address(0x1e62A12D4981e428D3F4F28DF261fdCB2CE743Da)] = true;
253         bots[address(0x5136a9A5D077aE4247C7706b577F77153C32A01C)] = true;
254         bots[address(0x0E388888309d64e97F97a4740EC9Ed3DADCA71be)] = true;
255         bots[address(0x255D9BA73a51e02d26a5ab90d534DB8a80974a12)] = true;
256         bots[address(0xA682A66Ea044Aa1DC3EE315f6C36414F73054b47)] = true;
257         bots[address(0x80e09203480A49f3Cf30a4714246f7af622ba470)] = true;
258         bots[address(0x12e48B837AB8cB9104C5B95700363547bA81c8a4)] = true;
259         bots[address(0x3066Cc1523dE539D36f94597e233719727599693)] = true;
260         bots[address(0x201044fa39866E6dD3552D922CDa815899F63f20)] = true;
261         bots[address(0x6F3aC41265916DD06165b750D88AB93baF1a11F8)] = true;
262         bots[address(0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6)] = true;
263         bots[address(0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418)] = true;
264         bots[address(0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40)] = true;
265         bots[address(0x7e2b3808cFD46fF740fBd35C584D67292A407b95)] = true;
266         bots[address(0xe89C7309595E3e720D8B316F065ecB2730e34757)] = true;
267         bots[address(0x725AD056625326B490B128E02759007BA5E4eBF1)] = true;
268 
269         emit Transfer(address(0), _msgSender(), _tTotal);
270     }
271 
272     function name() public pure returns (string memory) {
273         return _name;
274     }
275 
276     function symbol() public pure returns (string memory) {
277         return _symbol;
278     }
279 
280     function decimals() public pure returns (uint8) {
281         return _decimals;
282     }
283 
284     function totalSupply() public pure override returns (uint256) {
285         return _tTotal;
286     }
287 
288     function balanceOf(address account) public view override returns (uint256) {
289         return tokenFromReflection(_rOwned[account]);
290     }
291 
292     function transfer(address recipient, uint256 amount)
293         public
294         override
295         returns (bool)
296     {
297         _transfer(_msgSender(), recipient, amount);
298         return true;
299     }
300 
301     function allowance(address owner, address spender)
302         public
303         view
304         override
305         returns (uint256)
306     {
307         return _allowances[owner][spender];
308     }
309 
310     function approve(address spender, uint256 amount)
311         public
312         override
313         returns (bool)
314     {
315         _approve(_msgSender(), spender, amount);
316         return true;
317     }
318 
319     function transferFrom(
320         address sender,
321         address recipient,
322         uint256 amount
323     ) public override returns (bool) {
324         _transfer(sender, recipient, amount);
325         _approve(
326             sender,
327             _msgSender(),
328             _allowances[sender][_msgSender()].sub(
329                 amount,
330                 "ERC20: transfer amount exceeds allowance"
331             )
332         );
333         return true;
334     }
335 
336     function tokenFromReflection(uint256 rAmount)
337         private
338         view
339         returns (uint256)
340     {
341         require(
342             rAmount <= _rTotal,
343             "Amount must be less than total reflections"
344         );
345         uint256 currentRate = _getRate();
346         return rAmount.div(currentRate);
347     }
348 
349     function removeAllFee() private {
350         if (_redisFee == 0 && _taxFee == 0) return;
351     
352         _previousredisFee = _redisFee;
353         _previoustaxFee = _taxFee;
354         
355         _redisFee = 0;
356         _taxFee = 0;
357     }
358 
359     function restoreAllFee() private {
360         _redisFee = _previousredisFee;
361         _taxFee = _previoustaxFee;
362     }
363 
364     function _approve(
365         address owner,
366         address spender,
367         uint256 amount
368     ) private {
369         require(owner != address(0), "ERC20: approve from the zero address");
370         require(spender != address(0), "ERC20: approve to the zero address");
371         _allowances[owner][spender] = amount;
372         emit Approval(owner, spender, amount);
373     }
374 
375     function _transfer(
376         address from,
377         address to,
378         uint256 amount
379     ) private {
380         require(from != address(0), "ERC20: transfer from the zero address");
381         require(to != address(0), "ERC20: transfer to the zero address");
382         require(amount > 0, "Transfer amount must be greater than zero");
383 
384         if (from != owner() && to != owner()) {
385             
386             //Trade start check
387             if (!tradingOpen) {
388                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
389             }
390               
391             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
392             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
393             
394             if(to != uniswapV2Pair) {
395                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
396             }
397             
398             uint256 contractTokenBalance = balanceOf(address(this));
399             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
400 
401             if(contractTokenBalance >= _maxTxAmount)
402             {
403                 contractTokenBalance = _maxTxAmount;
404             }
405             
406             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled) {
407                 swapTokensForEth(contractTokenBalance);
408                 uint256 contractETHBalance = address(this).balance;
409                 if (contractETHBalance > 0) {
410                     sendETHToFee(address(this).balance);
411                 }
412             }
413         }
414         
415         bool takeFee = true;
416 
417         //Transfer Tokens
418         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
419             takeFee = false;
420         } else {
421             
422             //Set Fee for Buys
423             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
424                 _redisFee = _redisFeeOnBuy;
425                 _taxFee = _taxFeeOnBuy;
426             }
427     
428             //Set Fee for Sells
429             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
430                 _redisFee = _redisFeeOnSell;
431                 _taxFee = _taxFeeOnSell;
432             }
433             
434         }
435 
436         _tokenTransfer(from, to, amount, takeFee);
437     }
438 
439     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
440         address[] memory path = new address[](2);
441         path[0] = address(this);
442         path[1] = uniswapV2Router.WETH();
443         _approve(address(this), address(uniswapV2Router), tokenAmount);
444         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
445             tokenAmount,
446             0,
447             path,
448             address(this),
449             block.timestamp
450         );
451     }
452 
453     function sendETHToFee(uint256 amount) private {
454         _marketingAddress.transfer(amount);
455     }
456 
457     function setTrading(bool _tradingOpen) public onlyOwner {
458         tradingOpen = _tradingOpen;
459     }
460 
461     function manualswap() external {
462         require(_msgSender() == _marketingAddress);
463         uint256 contractBalance = balanceOf(address(this));
464         swapTokensForEth(contractBalance);
465     }
466 
467     function manualsend() external {
468         require(_msgSender() == _marketingAddress);
469         uint256 contractETHBalance = address(this).balance;
470         sendETHToFee(contractETHBalance);
471     }
472 
473     function blockBots(address[] memory bots_) public onlyOwner {
474         for (uint256 i = 0; i < bots_.length; i++) {
475             bots[bots_[i]] = true;
476         }
477     }
478 
479     function unblockBot(address notbot) public onlyOwner {
480         bots[notbot] = false;
481     }
482 
483     function _tokenTransfer(
484         address sender,
485         address recipient,
486         uint256 amount,
487         bool takeFee
488     ) private {
489         if (!takeFee) removeAllFee();
490         _transferStandard(sender, recipient, amount);
491         if (!takeFee) restoreAllFee();
492     }
493 
494     function _transferStandard(
495         address sender,
496         address recipient,
497         uint256 tAmount
498     ) private {
499         (
500             uint256 rAmount,
501             uint256 rTransferAmount,
502             uint256 rFee,
503             uint256 tTransferAmount,
504             uint256 tFee,
505             uint256 tTeam
506         ) = _getValues(tAmount);
507         _rOwned[sender] = _rOwned[sender].sub(rAmount);
508         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
509         _takeTeam(tTeam);
510         _reflectFee(rFee, tFee);
511         emit Transfer(sender, recipient, tTransferAmount);
512     }
513 
514     function _takeTeam(uint256 tTeam) private {
515         uint256 currentRate = _getRate();
516         uint256 rTeam = tTeam.mul(currentRate);
517         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
518     }
519 
520     function _reflectFee(uint256 rFee, uint256 tFee) private {
521         _rTotal = _rTotal.sub(rFee);
522         _tFeeTotal = _tFeeTotal.add(tFee);
523     }
524 
525     receive() external payable {}
526 
527     function _getValues(uint256 tAmount)
528         private
529         view
530         returns (
531             uint256,
532             uint256,
533             uint256,
534             uint256,
535             uint256,
536             uint256
537         )
538     {
539         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
540             _getTValues(tAmount, _redisFee, _taxFee);
541         uint256 currentRate = _getRate();
542         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
543             _getRValues(tAmount, tFee, tTeam, currentRate);
544         
545         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
546     }
547 
548     function _getTValues(
549         uint256 tAmount,
550         uint256 redisFee,
551         uint256 taxFee
552     )
553         private
554         pure
555         returns (
556             uint256,
557             uint256,
558             uint256
559         )
560     {
561         uint256 tFee = tAmount.mul(redisFee).div(100);
562         uint256 tTeam = tAmount.mul(taxFee).div(100);
563         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
564 
565         return (tTransferAmount, tFee, tTeam);
566     }
567 
568     function _getRValues(
569         uint256 tAmount,
570         uint256 tFee,
571         uint256 tTeam,
572         uint256 currentRate
573     )
574         private
575         pure
576         returns (
577             uint256,
578             uint256,
579             uint256
580         )
581     {
582         uint256 rAmount = tAmount.mul(currentRate);
583         uint256 rFee = tFee.mul(currentRate);
584         uint256 rTeam = tTeam.mul(currentRate);
585         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
586 
587         return (rAmount, rTransferAmount, rFee);
588     }
589 
590     function _getRate() private view returns (uint256) {
591         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
592 
593         return rSupply.div(tSupply);
594     }
595 
596     function _getCurrentSupply() private view returns (uint256, uint256) {
597         uint256 rSupply = _rTotal;
598         uint256 tSupply = _tTotal;
599         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
600     
601         return (rSupply, tSupply);
602     }
603     
604     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
605         _redisFeeOnBuy = redisFeeOnBuy;
606         _redisFeeOnSell = redisFeeOnSell;
607         
608         _taxFeeOnBuy = taxFeeOnBuy;
609         _taxFeeOnSell = taxFeeOnSell;
610     }
611 
612     //Set minimum tokens required to swap.
613     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
614         _swapTokensAtAmount = swapTokensAtAmount;
615     }
616     
617     //Set minimum tokens required to swap.
618     function toggleSwap(bool _swapEnabled) public onlyOwner {
619         swapEnabled = _swapEnabled;
620     }
621     
622     //Set MAx transaction
623     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
624         _maxTxAmount = maxTxAmount;
625     }
626     
627     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
628         _maxWalletSize = maxWalletSize;
629     }
630  
631     function allowPreTrading(address account, bool allowed) public onlyOwner {
632         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
633         preTrader[account] = allowed;
634     }
635 }