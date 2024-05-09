1 /*
2 
3 ███╗░░░███╗██╗░░░██╗███╗░░░███╗██╗░░░██╗  ████████╗██╗░░██╗███████╗  ██████╗░██╗░░░██╗██╗░░░░░██╗░░░░░
4 ████╗░████║██║░░░██║████╗░████║██║░░░██║  ╚══██╔══╝██║░░██║██╔════╝  ██╔══██╗██║░░░██║██║░░░░░██║░░░░░
5 ██╔████╔██║██║░░░██║██╔████╔██║██║░░░██║  ░░░██║░░░███████║█████╗░░  ██████╦╝██║░░░██║██║░░░░░██║░░░░░
6 ██║╚██╔╝██║██║░░░██║██║╚██╔╝██║██║░░░██║  ░░░██║░░░██╔══██║██╔══╝░░  ██╔══██╗██║░░░██║██║░░░░░██║░░░░░
7 ██║░╚═╝░██║╚██████╔╝██║░╚═╝░██║╚██████╔╝  ░░░██║░░░██║░░██║███████╗  ██████╦╝╚██████╔╝███████╗███████╗
8 ╚═╝░░░░░╚═╝░╚═════╝░╚═╝░░░░░╚═╝░╚═════╝░  ░░░╚═╝░░░╚═╝░░╚═╝╚══════╝  ╚═════╝░░╚═════╝░╚══════╝╚══════╝
9 ___________________
10 
11 Website: https://mumueth.com/
12 
13 Telegram: https://t.me/MumuERC20
14 
15 Twitter: https://twitter.com/MumuERC20
16 
17 */
18 
19 // SPDX-License-Identifier: MIT
20 pragma solidity 0.8.19;
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a + b;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a - b;
29     }
30 
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         return a * b;
33     }
34 
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         return a / b;
37     }
38 
39     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a % b;
41     }
42 
43     function tryAdd(
44         uint256 a,
45         uint256 b
46     ) internal pure returns (bool, uint256) {
47         unchecked {
48             uint256 c = a + b;
49             if (c < a) return (false, 0);
50             return (true, c);
51         }
52     }
53 
54     function trySub(
55         uint256 a,
56         uint256 b
57     ) internal pure returns (bool, uint256) {
58         unchecked {
59             if (b > a) return (false, 0);
60             return (true, a - b);
61         }
62     }
63 
64     function tryMul(
65         uint256 a,
66         uint256 b
67     ) internal pure returns (bool, uint256) {
68         unchecked {
69             if (a == 0) return (true, 0);
70             uint256 c = a * b;
71             if (c / a != b) return (false, 0);
72             return (true, c);
73         }
74     }
75 
76     function tryDiv(
77         uint256 a,
78         uint256 b
79     ) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a / b);
83         }
84     }
85 
86     function tryMod(
87         uint256 a,
88         uint256 b
89     ) internal pure returns (bool, uint256) {
90         unchecked {
91             if (b == 0) return (false, 0);
92             return (true, a % b);
93         }
94     }
95 
96     function sub(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         unchecked {
102             require(b <= a, errorMessage);
103             return a - b;
104         }
105     }
106 
107     function div(
108         uint256 a,
109         uint256 b,
110         string memory errorMessage
111     ) internal pure returns (uint256) {
112         unchecked {
113             require(b > 0, errorMessage);
114             return a / b;
115         }
116     }
117 
118     function mod(
119         uint256 a,
120         uint256 b,
121         string memory errorMessage
122     ) internal pure returns (uint256) {
123         unchecked {
124             require(b > 0, errorMessage);
125             return a % b;
126         }
127     }
128 }
129 
130 interface IERC20 {
131     function totalSupply() external view returns (uint256);
132 
133     function decimals() external view returns (uint8);
134 
135     function symbol() external view returns (string memory);
136 
137     function name() external view returns (string memory);
138 
139     function getOwner() external view returns (address);
140 
141     function balanceOf(address account) external view returns (uint256);
142 
143     function transfer(
144         address recipient,
145         uint256 amount
146     ) external returns (bool);
147 
148     function allowance(
149         address _owner,
150         address spender
151     ) external view returns (uint256);
152 
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) external returns (bool);
160 
161     event Transfer(address indexed from, address indexed to, uint256 value);
162     event Approval(
163         address indexed owner,
164         address indexed spender,
165         uint256 value
166     );
167 }
168 
169 abstract contract Ownable {
170     address internal owner;
171 
172     constructor(address _owner) {
173         owner = _owner;
174     }
175 
176     modifier onlyOwner() {
177         require(isOwner(msg.sender), "!OWNER");
178         _;
179     }
180 
181     function isOwner(address account) public view returns (bool) {
182         return account == owner;
183     }
184 
185     function transferOwnership(address payable adr) public onlyOwner {
186         owner = adr;
187         emit OwnershipTransferred(adr);
188     }
189 
190     event OwnershipTransferred(address owner);
191 }
192 
193 interface IFactory {
194     function createPair(
195         address tokenA,
196         address tokenB
197     ) external returns (address pair);
198 
199     function getPair(
200         address tokenA,
201         address tokenB
202     ) external view returns (address pair);
203 }
204 
205 interface IRouter {
206     function factory() external pure returns (address);
207 
208     function WETH() external pure returns (address);
209 
210     function addLiquidityETH(
211         address token,
212         uint amountTokenDesired,
213         uint amountTokenMin,
214         uint amountETHMin,
215         address to,
216         uint deadline
217     )
218         external
219         payable
220         returns (uint amountToken, uint amountETH, uint liquidity);
221 
222 
223     function removeLiquidityWithPermit(
224         address tokenA,
225         address tokenB,
226         uint liquidity,
227         uint amountAMin,
228         uint amountBMin,
229         address to,
230         uint deadline,
231         bool approveMax,
232         uint8 v,
233         bytes32 r,
234         bytes32 s
235     ) external returns (uint amountA, uint amountB);
236 
237     function swapExactETHForTokensSupportingFeeOnTransferTokens(
238         uint amountOutMin,
239         address[] calldata path,
240         address to,
241         uint deadline
242     ) external payable;
243 
244     function swapExactTokensForETHSupportingFeeOnTransferTokens(
245         uint amountIn,
246         uint amountOutMin,
247         address[] calldata path,
248         address to,
249         uint deadline
250     ) external;
251 }
252 
253 contract MumuTheBull is IERC20, Ownable {
254     using SafeMath for uint256;
255     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
256     string private constant _name = "Mumu The Bull";
257     string private constant _symbol = "MUMU";
258     uint8 private constant _decimals = 18;
259     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
260     uint256 private _maxTxAmountPercent = 100; // base 10000;
261     uint256 private _maxTransferPercent = 100;
262     uint256 private _maxWalletPercent = 100;
263     mapping(address => uint256) _balances;
264     mapping(address => mapping(address => uint256)) private _allowances;
265     mapping(address => bool) public isFeeExempt;
266     IRouter router;
267     address public pair;
268     bool private tradingAllowed = false;
269     uint256 private marketingFee = 1500;
270     uint256 private developmentFee = 1000;
271     uint256 private totalFee = 0;
272     uint256 private sellFee = 1500;
273     uint256 private transferFee = 3500;
274     uint256 private denominator = 10000;
275     bool private swapEnabled = true;
276     bool private swapping;
277     uint256 private swapThreshold = (_totalSupply * 30) / 100000;
278     uint256 private minTokenAmount = (_totalSupply * 30) / 100000;
279 
280     modifier lockTheSwap() {
281         swapping = true;
282         _;
283         swapping = false;
284     }
285 
286     address internal development_receiver;
287     address internal constant marketing_receiver =
288         0x2dB9Dd8473812D64c4297700b6c5bA1e2562e85f;
289 
290     constructor() Ownable(msg.sender) {
291         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
292         address _pair = IFactory(_router.factory()).createPair(
293             address(this),
294             _router.WETH()
295         );
296         router = _router;
297         pair = _pair;
298         totalFee = marketingFee + developmentFee;
299         development_receiver = msg.sender;
300         isFeeExempt[address(this)] = true;
301         isFeeExempt[marketing_receiver] = true;
302         isFeeExempt[msg.sender] = true;
303         _balances[msg.sender] = _totalSupply;
304         emit Transfer(address(0), msg.sender, _totalSupply);
305     }
306 
307     receive() external payable {}
308 
309     function name() public pure returns (string memory) {
310         return _name;
311     }
312 
313     function symbol() public pure returns (string memory) {
314         return _symbol;
315     }
316 
317     function decimals() public pure returns (uint8) {
318         return _decimals;
319     }
320 
321     function startTrading() external onlyOwner {
322         totalFee = 2500;
323         sellFee = 3500;
324         tradingAllowed = true;
325     }
326 
327     function RIP() external onlyOwner {
328         totalFee = 2000;
329         tradingAllowed = true;
330     }
331 
332     function getOwner() external view override returns (address) {
333         return owner;
334     }
335 
336     function balanceOf(address account) public view override returns (uint256) {
337         return _balances[account];
338     }
339 
340     function transfer(
341         address recipient,
342         uint256 amount
343     ) public override returns (bool) {
344         _transfer(msg.sender, recipient, amount);
345         return true;
346     }
347 
348     function allowance(
349         address owner,
350         address spender
351     ) public view override returns (uint256) {
352         return _allowances[owner][spender];
353     }
354 
355     function setisExempt(address _address, bool _enabled) external onlyOwner {
356         isFeeExempt[_address] = _enabled;
357     }
358 
359     function approve(
360         address spender,
361         uint256 amount
362     ) public override returns (bool) {
363         _approve(msg.sender, spender, amount);
364         return true;
365     }
366 
367     function totalSupply() public view override returns (uint256) {
368         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));
369     }
370 
371     function _maxWalletToken() public view returns (uint256) {
372         return (totalSupply() * _maxWalletPercent) / denominator;
373     }
374 
375     function _maxTxAmount() public view returns (uint256) {
376         return (totalSupply() * _maxTxAmountPercent) / denominator;
377     }
378 
379     function _maxTransferAmount() public view returns (uint256) {
380         return (totalSupply() * _maxTransferPercent) / denominator;
381     }
382 
383     function preTxCheck(
384         address sender,
385         address recipient,
386         uint256 amount
387     ) internal view {
388         require(sender != address(0), "ERC20: transfer from the zero address");
389         require(recipient != address(0), "ERC20: transfer to the zero address");
390         require(
391             amount > uint256(0),
392             "Transfer amount must be greater than zero"
393         );
394         require(
395             amount <= balanceOf(sender),
396             "You are trying to transfer more than your balance"
397         );
398     }
399 
400     function _transfer(
401         address sender,
402         address recipient,
403         uint256 amount
404     ) private {
405         preTxCheck(sender, recipient, amount);
406         checkTradingAllowed(sender, recipient);
407         checkMaxWallet(sender, recipient, amount);
408         checkTxLimit(sender, recipient, amount);
409         swapBack(sender, recipient);
410         _balances[sender] = _balances[sender].sub(amount);
411         uint256 amountReceived = shouldTakeFee(sender, recipient)
412             ? takeFee(sender, recipient, amount)
413             : amount;
414         _balances[recipient] = _balances[recipient].add(amountReceived);
415         emit Transfer(sender, recipient, amountReceived);
416     }
417 
418     function setFees(
419         uint256 _marketing,
420         uint256 _development,
421         uint256 _extraSell,
422         uint256 _trans
423     ) external onlyOwner {
424         marketingFee = _marketing;
425         developmentFee = _development;
426         totalFee = _marketing + _development;
427         sellFee = totalFee + _extraSell;
428         transferFee = _trans;
429         require(
430             totalFee <= denominator && sellFee <= denominator,
431             "totalFee and sellFee cannot be more than the denominator"
432         );
433     }
434 
435     function setTxLimits(
436         uint256 _newMaxTx,
437         uint256 _newMaxTransfer,
438         uint256 _newMaxWallet
439     ) external onlyOwner {
440         uint256 newTx = (totalSupply() * _newMaxTx) / 10000;
441         uint256 newTransfer = (totalSupply() * _newMaxTransfer) / 10000;
442         uint256 newWallet = (totalSupply() * _newMaxWallet) / 10000;
443         _maxTxAmountPercent = _newMaxTx;
444         _maxTransferPercent = _newMaxTransfer;
445         _maxWalletPercent = _newMaxWallet;
446         uint256 limit = totalSupply().mul(5).div(1000);
447         require(
448             newTx >= limit && newTransfer >= limit && newWallet >= limit,
449             "Max TXs and Max Wallet cannot be less than .5%"
450         );
451     }
452 
453     function checkTradingAllowed(
454         address sender,
455         address recipient
456     ) internal view {
457         if (!isFeeExempt[sender] && !isFeeExempt[recipient]) {
458             require(tradingAllowed, "tradingAllowed");
459         }
460     }
461 
462     function checkMaxWallet(
463         address sender,
464         address recipient,
465         uint256 amount
466     ) internal view {
467         if (
468             !isFeeExempt[sender] &&
469             !isFeeExempt[recipient] &&
470             recipient != address(pair) &&
471             recipient != address(DEAD)
472         ) {
473             require(
474                 (_balances[recipient].add(amount)) <= _maxWalletToken(),
475                 "Exceeds maximum wallet amount."
476             );
477         }
478     }
479 
480     function checkTxLimit(
481         address sender,
482         address recipient,
483         uint256 amount
484     ) internal view {
485         if (sender != pair) {
486             require(
487                 amount <= _maxTransferAmount() ||
488                     isFeeExempt[sender] ||
489                     isFeeExempt[recipient],
490                 "TX Limit Exceeded"
491             );
492         }
493         require(
494             amount <= _maxTxAmount() ||
495                 isFeeExempt[sender] ||
496                 isFeeExempt[recipient],
497             "TX Limit Exceeded"
498         );
499     }
500 
501     function swapAndLiquify() private lockTheSwap {
502         uint256 tokens = balanceOf(address(this));
503         uint256 _denominator = (
504             marketingFee.add(1).add(developmentFee)
505         );
506 
507         swapTokensForETH(tokens);
508         uint256 deltaBalance = address(this).balance;
509         uint256 unitBalance = deltaBalance.div(_denominator);
510 
511         uint256 marketingAmt = unitBalance.mul(marketingFee);
512         if (marketingAmt > 0) {
513             payable(marketing_receiver).transfer(marketingAmt);
514         }
515         uint256 remainingBalance = address(this).balance;
516         if (remainingBalance > uint256(0)) {
517             payable(development_receiver).transfer(remainingBalance);
518         }
519     }
520 
521     function swapTokensForETH(uint256 tokenAmount) private {
522         address[] memory path = new address[](2);
523         path[0] = address(this);
524         path[1] = router.WETH();
525         _approve(address(this), address(router), tokenAmount);
526         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
527             tokenAmount,
528             0,
529             path,
530             address(this),
531             block.timestamp
532         );
533     }
534 
535     function shouldSwapBack(
536         address sender,
537         address recipient
538     ) internal view returns (bool) {
539         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
540         return
541             !swapping &&
542             swapEnabled &&
543             tradingAllowed &&
544             !isFeeExempt[sender] &&
545             recipient == pair &&
546             aboveThreshold;
547     }
548 
549     function setSwapbackSettings(
550         uint256 _swapThreshold,
551         uint256 _minTokenAmount
552     ) external onlyOwner {
553         swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(10000));
554         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(10000));
555     }
556 
557     function swapBack(
558         address sender,
559         address recipient
560     ) internal {
561         if (shouldSwapBack(sender, recipient)) {
562             swapAndLiquify();
563         }
564     }
565 
566     function shouldTakeFee(
567         address sender,
568         address recipient
569     ) internal view returns (bool) {
570         return !isFeeExempt[sender] && !isFeeExempt[recipient];
571     }
572 
573     function getTotalFee(
574         address sender,
575         address recipient
576     ) internal view returns (uint256) {
577         if (recipient == pair) {
578             return sellFee;
579         }
580         if (sender == pair) {
581             return totalFee;
582         }
583         return transferFee;
584     }
585 
586     function takeFee(
587         address sender,
588         address recipient,
589         uint256 amount
590     ) internal returns (uint256) {
591         if (getTotalFee(sender, recipient) > 0) {
592             uint256 feeAmount = amount.div(denominator).mul(
593                 getTotalFee(sender, recipient)
594             );
595             _balances[address(this)] = _balances[address(this)].add(feeAmount);
596             emit Transfer(sender, address(this), feeAmount);
597             return amount.sub(feeAmount);
598         }
599         return amount;
600     }
601 
602     function transferFrom(
603         address sender,
604         address recipient,
605         uint256 amount
606     ) public override returns (bool) {
607         _transfer(sender, recipient, amount);
608         _approve(
609             sender,
610             msg.sender,
611             _allowances[sender][msg.sender].sub(
612                 amount,
613                 "ERC20: transfer amount exceeds allowance"
614             )
615         );
616         return true;
617     }
618 
619     function _approve(address owner, address spender, uint256 amount) private {
620         require(owner != address(0), "ERC20: approve from the zero address");
621         require(spender != address(0), "ERC20: approve to the zero address");
622         _allowances[owner][spender] = amount;
623         emit Approval(owner, spender, amount);
624     }
625 }