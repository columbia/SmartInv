1 // SPDX-License-Identifier: MIT
2 /**
3  * https://voldemorttrumprobotnik69pepe.news/
4  * https://t.me/VTR69PEPE
5  * https://twitter.com/vtr69pepeeth
6  */
7 pragma solidity 0.8.19;
8 
9 library SafeMath {
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {
11         return a + b;
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a - b;
16     }
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a * b;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a / b;
24     }
25 
26     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
27         return a % b;
28     }
29 
30     function tryAdd(
31         uint256 a,
32         uint256 b
33     ) internal pure returns (bool, uint256) {
34         unchecked {
35             uint256 c = a + b;
36             if (c < a) return (false, 0);
37             return (true, c);
38         }
39     }
40 
41     function trySub(
42         uint256 a,
43         uint256 b
44     ) internal pure returns (bool, uint256) {
45         unchecked {
46             if (b > a) return (false, 0);
47             return (true, a - b);
48         }
49     }
50 
51     function tryMul(
52         uint256 a,
53         uint256 b
54     ) internal pure returns (bool, uint256) {
55         unchecked {
56             if (a == 0) return (true, 0);
57             uint256 c = a * b;
58             if (c / a != b) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     function tryDiv(
64         uint256 a,
65         uint256 b
66     ) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     function tryMod(
74         uint256 a,
75         uint256 b
76     ) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b == 0) return (false, 0);
79             return (true, a % b);
80         }
81     }
82 
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         unchecked {
89             require(b <= a, errorMessage);
90             return a - b;
91         }
92     }
93 
94     function div(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         unchecked {
100             require(b > 0, errorMessage);
101             return a / b;
102         }
103     }
104 
105     function mod(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         unchecked {
111             require(b > 0, errorMessage);
112             return a % b;
113         }
114     }
115 }
116 
117 interface IERC20 {
118     function totalSupply() external view returns (uint256);
119 
120     function decimals() external view returns (uint8);
121 
122     function symbol() external view returns (string memory);
123 
124     function name() external view returns (string memory);
125 
126     function getOwner() external view returns (address);
127 
128     function balanceOf(address account) external view returns (uint256);
129 
130     function transfer(
131         address recipient,
132         uint256 amount
133     ) external returns (bool);
134 
135     function allowance(
136         address _owner,
137         address spender
138     ) external view returns (uint256);
139 
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     function transferFrom(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) external returns (bool);
147 
148     event Transfer(address indexed from, address indexed to, uint256 value);
149     event Approval(
150         address indexed owner,
151         address indexed spender,
152         uint256 value
153     );
154 }
155 
156 abstract contract Ownable {
157     address internal owner;
158 
159     constructor(address _owner) {
160         owner = _owner;
161     }
162 
163     modifier onlyOwner() {
164         require(isOwner(msg.sender), "!OWNER");
165         _;
166     }
167 
168     function isOwner(address account) public view returns (bool) {
169         return account == owner;
170     }
171 
172     function transferOwnership(address payable adr) public onlyOwner {
173         owner = adr;
174         emit OwnershipTransferred(adr);
175     }
176 
177     event OwnershipTransferred(address owner);
178 }
179 
180 interface IFactory {
181     function createPair(
182         address tokenA,
183         address tokenB
184     ) external returns (address pair);
185 
186     function getPair(
187         address tokenA,
188         address tokenB
189     ) external view returns (address pair);
190 }
191 
192 interface IRouter {
193     function factory() external pure returns (address);
194 
195     function WETH() external pure returns (address);
196 
197     function addLiquidityETH(
198         address token,
199         uint amountTokenDesired,
200         uint amountTokenMin,
201         uint amountETHMin,
202         address to,
203         uint deadline
204     )
205         external
206         payable
207         returns (uint amountToken, uint amountETH, uint liquidity);
208 
209 
210     function removeLiquidityWithPermit(
211         address tokenA,
212         address tokenB,
213         uint liquidity,
214         uint amountAMin,
215         uint amountBMin,
216         address to,
217         uint deadline,
218         bool approveMax,
219         uint8 v,
220         bytes32 r,
221         bytes32 s
222     ) external returns (uint amountA, uint amountB);
223 
224     function swapExactETHForTokensSupportingFeeOnTransferTokens(
225         uint amountOutMin,
226         address[] calldata path,
227         address to,
228         uint deadline
229     ) external payable;
230 
231     function swapExactTokensForETHSupportingFeeOnTransferTokens(
232         uint amountIn,
233         uint amountOutMin,
234         address[] calldata path,
235         address to,
236         uint deadline
237     ) external;
238 }
239 
240 contract VoldemortTrumpRobotnik69Pepe is IERC20, Ownable {
241     using SafeMath for uint256;
242     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
243     string private constant _name = "VoldemortTrumpRobotnik69Pepe";
244     string private constant _symbol = "ETHEREUM";
245     uint8 private constant _decimals = 18;
246     uint256 private _totalSupply = 690420000 * (10 ** _decimals);
247     uint256 private _maxTxAmountPercent = 200; // base 10000;
248     uint256 private _maxTransferPercent = 200;
249     uint256 private _maxWalletPercent = 200;
250     mapping(address => uint256) _balances;
251     mapping(address => mapping(address => uint256)) private _allowances;
252     mapping(address => bool) public isFeeExempt;
253     IRouter router;
254     address public pair;
255     bool private tradingAllowed = false;
256     uint256 private marketingFee = 2500;
257     uint256 private developmentFee = 1000;
258     uint256 private totalFee = 0;
259     uint256 private sellFee = 6500;
260     uint256 private transferFee = 6500;
261     uint256 private denominator = 10000;
262     bool private swapEnabled = true;
263     bool private swapping;
264     uint256 private swapThreshold = (_totalSupply * 10) / 100000;
265     uint256 private minTokenAmount = (_totalSupply * 10) / 100000;
266 
267     modifier lockTheSwap() {
268         swapping = true;
269         _;
270         swapping = false;
271     }
272 
273     address internal development_receiver;
274     address internal constant marketing_receiver =
275         0x15bBaa90B58494A3F8fD59323D7eB6D0460B2cc1;
276 
277     constructor() Ownable(msg.sender) {
278         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
279         address _pair = IFactory(_router.factory()).createPair(
280             address(this),
281             _router.WETH()
282         );
283         router = _router;
284         pair = _pair;
285         totalFee = marketingFee + developmentFee;
286         development_receiver = msg.sender;
287         isFeeExempt[address(this)] = true;
288         isFeeExempt[marketing_receiver] = true;
289         isFeeExempt[msg.sender] = true;
290         _balances[msg.sender] = _totalSupply;
291         emit Transfer(address(0), msg.sender, _totalSupply);
292     }
293 
294     receive() external payable {}
295 
296     function name() public pure returns (string memory) {
297         return _name;
298     }
299 
300     function symbol() public pure returns (string memory) {
301         return _symbol;
302     }
303 
304     function decimals() public pure returns (uint8) {
305         return _decimals;
306     }
307 
308     function startTrading() external onlyOwner {
309         totalFee = 8000;
310         tradingAllowed = true;
311     }
312 
313     function RIP() external onlyOwner {
314         totalFee = 2000;
315         tradingAllowed = true;
316     }
317 
318     function getOwner() external view override returns (address) {
319         return owner;
320     }
321 
322     function balanceOf(address account) public view override returns (uint256) {
323         return _balances[account];
324     }
325 
326     function transfer(
327         address recipient,
328         uint256 amount
329     ) public override returns (bool) {
330         _transfer(msg.sender, recipient, amount);
331         return true;
332     }
333 
334     function allowance(
335         address owner,
336         address spender
337     ) public view override returns (uint256) {
338         return _allowances[owner][spender];
339     }
340 
341     function setisExempt(address _address, bool _enabled) external onlyOwner {
342         isFeeExempt[_address] = _enabled;
343     }
344 
345     function approve(
346         address spender,
347         uint256 amount
348     ) public override returns (bool) {
349         _approve(msg.sender, spender, amount);
350         return true;
351     }
352 
353     function totalSupply() public view override returns (uint256) {
354         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));
355     }
356 
357     function _maxWalletToken() public view returns (uint256) {
358         return (totalSupply() * _maxWalletPercent) / denominator;
359     }
360 
361     function _maxTxAmount() public view returns (uint256) {
362         return (totalSupply() * _maxTxAmountPercent) / denominator;
363     }
364 
365     function _maxTransferAmount() public view returns (uint256) {
366         return (totalSupply() * _maxTransferPercent) / denominator;
367     }
368 
369     function preTxCheck(
370         address sender,
371         address recipient,
372         uint256 amount
373     ) internal view {
374         require(sender != address(0), "ERC20: transfer from the zero address");
375         require(recipient != address(0), "ERC20: transfer to the zero address");
376         require(
377             amount > uint256(0),
378             "Transfer amount must be greater than zero"
379         );
380         require(
381             amount <= balanceOf(sender),
382             "You are trying to transfer more than your balance"
383         );
384     }
385 
386     function _transfer(
387         address sender,
388         address recipient,
389         uint256 amount
390     ) private {
391         preTxCheck(sender, recipient, amount);
392         checkTradingAllowed(sender, recipient);
393         checkMaxWallet(sender, recipient, amount);
394         checkTxLimit(sender, recipient, amount);
395         swapBack(sender, recipient);
396         _balances[sender] = _balances[sender].sub(amount);
397         uint256 amountReceived = shouldTakeFee(sender, recipient)
398             ? takeFee(sender, recipient, amount)
399             : amount;
400         _balances[recipient] = _balances[recipient].add(amountReceived);
401         emit Transfer(sender, recipient, amountReceived);
402     }
403 
404     function setFees(
405         uint256 _marketing,
406         uint256 _development,
407         uint256 _extraSell,
408         uint256 _trans
409     ) external onlyOwner {
410         marketingFee = _marketing;
411         developmentFee = _development;
412         totalFee = _marketing + _development;
413         sellFee = totalFee + _extraSell;
414         transferFee = _trans;
415         require(
416             totalFee <= denominator && sellFee <= denominator,
417             "totalFee and sellFee cannot be more than the denominator"
418         );
419     }
420 
421     function setTxLimits(
422         uint256 _newMaxTx,
423         uint256 _newMaxTransfer,
424         uint256 _newMaxWallet
425     ) external onlyOwner {
426         uint256 newTx = (totalSupply() * _newMaxTx) / 10000;
427         uint256 newTransfer = (totalSupply() * _newMaxTransfer) / 10000;
428         uint256 newWallet = (totalSupply() * _newMaxWallet) / 10000;
429         _maxTxAmountPercent = _newMaxTx;
430         _maxTransferPercent = _newMaxTransfer;
431         _maxWalletPercent = _newMaxWallet;
432         uint256 limit = totalSupply().mul(5).div(1000);
433         require(
434             newTx >= limit && newTransfer >= limit && newWallet >= limit,
435             "Max TXs and Max Wallet cannot be less than .5%"
436         );
437     }
438 
439     function checkTradingAllowed(
440         address sender,
441         address recipient
442     ) internal view {
443         if (!isFeeExempt[sender] && !isFeeExempt[recipient]) {
444             require(tradingAllowed, "tradingAllowed");
445         }
446     }
447 
448     function checkMaxWallet(
449         address sender,
450         address recipient,
451         uint256 amount
452     ) internal view {
453         if (
454             !isFeeExempt[sender] &&
455             !isFeeExempt[recipient] &&
456             recipient != address(pair) &&
457             recipient != address(DEAD)
458         ) {
459             require(
460                 (_balances[recipient].add(amount)) <= _maxWalletToken(),
461                 "Exceeds maximum wallet amount."
462             );
463         }
464     }
465 
466     function checkTxLimit(
467         address sender,
468         address recipient,
469         uint256 amount
470     ) internal view {
471         if (sender != pair) {
472             require(
473                 amount <= _maxTransferAmount() ||
474                     isFeeExempt[sender] ||
475                     isFeeExempt[recipient],
476                 "TX Limit Exceeded"
477             );
478         }
479         require(
480             amount <= _maxTxAmount() ||
481                 isFeeExempt[sender] ||
482                 isFeeExempt[recipient],
483             "TX Limit Exceeded"
484         );
485     }
486 
487     function swapAndLiquify() private lockTheSwap {
488         uint256 tokens = balanceOf(address(this));
489         uint256 _denominator = (
490             marketingFee.add(1).add(developmentFee)
491         );
492 
493         swapTokensForETH(tokens);
494         uint256 deltaBalance = address(this).balance;
495         uint256 unitBalance = deltaBalance.div(_denominator);
496 
497         uint256 marketingAmt = unitBalance.mul(marketingFee);
498         if (marketingAmt > 0) {
499             payable(marketing_receiver).transfer(marketingAmt);
500         }
501         uint256 remainingBalance = address(this).balance;
502         if (remainingBalance > uint256(0)) {
503             payable(development_receiver).transfer(remainingBalance);
504         }
505     }
506 
507     function swapTokensForETH(uint256 tokenAmount) private {
508         address[] memory path = new address[](2);
509         path[0] = address(this);
510         path[1] = router.WETH();
511         _approve(address(this), address(router), tokenAmount);
512         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
513             tokenAmount,
514             0,
515             path,
516             address(this),
517             block.timestamp
518         );
519     }
520 
521     function shouldSwapBack(
522         address sender,
523         address recipient
524     ) internal view returns (bool) {
525         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
526         return
527             !swapping &&
528             swapEnabled &&
529             tradingAllowed &&
530             !isFeeExempt[sender] &&
531             recipient == pair &&
532             aboveThreshold;
533     }
534 
535     function setSwapbackSettings(
536         uint256 _swapThreshold,
537         uint256 _minTokenAmount
538     ) external onlyOwner {
539         swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000));
540         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
541     }
542 
543     function swapBack(
544         address sender,
545         address recipient
546     ) internal {
547         if (shouldSwapBack(sender, recipient)) {
548             swapAndLiquify();
549         }
550     }
551 
552     function shouldTakeFee(
553         address sender,
554         address recipient
555     ) internal view returns (bool) {
556         return !isFeeExempt[sender] && !isFeeExempt[recipient];
557     }
558 
559     function getTotalFee(
560         address sender,
561         address recipient
562     ) internal view returns (uint256) {
563         if (recipient == pair) {
564             return sellFee;
565         }
566         if (sender == pair) {
567             return totalFee;
568         }
569         return transferFee;
570     }
571 
572     function takeFee(
573         address sender,
574         address recipient,
575         uint256 amount
576     ) internal returns (uint256) {
577         if (getTotalFee(sender, recipient) > 0) {
578             uint256 feeAmount = amount.div(denominator).mul(
579                 getTotalFee(sender, recipient)
580             );
581             _balances[address(this)] = _balances[address(this)].add(feeAmount);
582             emit Transfer(sender, address(this), feeAmount);
583             return amount.sub(feeAmount);
584         }
585         return amount;
586     }
587 
588     function transferFrom(
589         address sender,
590         address recipient,
591         uint256 amount
592     ) public override returns (bool) {
593         _transfer(sender, recipient, amount);
594         _approve(
595             sender,
596             msg.sender,
597             _allowances[sender][msg.sender].sub(
598                 amount,
599                 "ERC20: transfer amount exceeds allowance"
600             )
601         );
602         return true;
603     }
604 
605     function _approve(address owner, address spender, uint256 amount) private {
606         require(owner != address(0), "ERC20: approve from the zero address");
607         require(spender != address(0), "ERC20: approve to the zero address");
608         _allowances[owner][spender] = amount;
609         emit Approval(owner, spender, amount);
610     }
611 }