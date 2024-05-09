1 /*
2 
3 █▀▄▀█ ▄▀█ █▀█ █ █▀█ ▄▀█ █▄░█ █▀▄ █▀ █▀█ █▄░█ █ █▀▀ █▄▀ █ █▀ █▀ █▄▄ █ ▀█▀ █▀▀ █▀█ █ █▄░█ ▄█ █▀█ █▀█ █▄▀
4 █░▀░█ █▀█ █▀▄ █ █▄█ █▀█ █░▀█ █▄▀ ▄█ █▄█ █░▀█ █ █▄▄ █░█ █ ▄█ ▄█ █▄█ █ ░█░ █▄▄ █▄█ █ █░▀█ ░█ █▄█ █▄█ █░█
5 ___________________
6 
7 Website: https://marioandsonickiss100k.com/
8 
9 Telegram: https://t.me/MASKB100K
10 
11 Twitter: https://twitter.com/MASKB100K
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity 0.8.19;
18 
19 library SafeMath {
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a + b;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return a - b;
26     }
27 
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a * b;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return a / b;
34     }
35 
36     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37         return a % b;
38     }
39 
40     function tryAdd(
41         uint256 a,
42         uint256 b
43     ) internal pure returns (bool, uint256) {
44         unchecked {
45             uint256 c = a + b;
46             if (c < a) return (false, 0);
47             return (true, c);
48         }
49     }
50 
51     function trySub(
52         uint256 a,
53         uint256 b
54     ) internal pure returns (bool, uint256) {
55         unchecked {
56             if (b > a) return (false, 0);
57             return (true, a - b);
58         }
59     }
60 
61     function tryMul(
62         uint256 a,
63         uint256 b
64     ) internal pure returns (bool, uint256) {
65         unchecked {
66             if (a == 0) return (true, 0);
67             uint256 c = a * b;
68             if (c / a != b) return (false, 0);
69             return (true, c);
70         }
71     }
72 
73     function tryDiv(
74         uint256 a,
75         uint256 b
76     ) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b == 0) return (false, 0);
79             return (true, a / b);
80         }
81     }
82 
83     function tryMod(
84         uint256 a,
85         uint256 b
86     ) internal pure returns (bool, uint256) {
87         unchecked {
88             if (b == 0) return (false, 0);
89             return (true, a % b);
90         }
91     }
92 
93     function sub(
94         uint256 a,
95         uint256 b,
96         string memory errorMessage
97     ) internal pure returns (uint256) {
98         unchecked {
99             require(b <= a, errorMessage);
100             return a - b;
101         }
102     }
103 
104     function div(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         unchecked {
110             require(b > 0, errorMessage);
111             return a / b;
112         }
113     }
114 
115     function mod(
116         uint256 a,
117         uint256 b,
118         string memory errorMessage
119     ) internal pure returns (uint256) {
120         unchecked {
121             require(b > 0, errorMessage);
122             return a % b;
123         }
124     }
125 }
126 
127 interface IERC20 {
128     function totalSupply() external view returns (uint256);
129 
130     function decimals() external view returns (uint8);
131 
132     function symbol() external view returns (string memory);
133 
134     function name() external view returns (string memory);
135 
136     function getOwner() external view returns (address);
137 
138     function balanceOf(address account) external view returns (uint256);
139 
140     function transfer(
141         address recipient,
142         uint256 amount
143     ) external returns (bool);
144 
145     function allowance(
146         address _owner,
147         address spender
148     ) external view returns (uint256);
149 
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     function transferFrom(
153         address sender,
154         address recipient,
155         uint256 amount
156     ) external returns (bool);
157 
158     event Transfer(address indexed from, address indexed to, uint256 value);
159     event Approval(
160         address indexed owner,
161         address indexed spender,
162         uint256 value
163     );
164 }
165 
166 abstract contract Ownable {
167     address internal owner;
168 
169     constructor(address _owner) {
170         owner = _owner;
171     }
172 
173     modifier onlyOwner() {
174         require(isOwner(msg.sender), "!OWNER");
175         _;
176     }
177 
178     function isOwner(address account) public view returns (bool) {
179         return account == owner;
180     }
181 
182     function transferOwnership(address payable adr) public onlyOwner {
183         owner = adr;
184         emit OwnershipTransferred(adr);
185     }
186 
187     event OwnershipTransferred(address owner);
188 }
189 
190 interface IFactory {
191     function createPair(
192         address tokenA,
193         address tokenB
194     ) external returns (address pair);
195 
196     function getPair(
197         address tokenA,
198         address tokenB
199     ) external view returns (address pair);
200 }
201 
202 interface IRouter {
203     function factory() external pure returns (address);
204 
205     function WETH() external pure returns (address);
206 
207     function addLiquidityETH(
208         address token,
209         uint amountTokenDesired,
210         uint amountTokenMin,
211         uint amountETHMin,
212         address to,
213         uint deadline
214     )
215         external
216         payable
217         returns (uint amountToken, uint amountETH, uint liquidity);
218 
219 
220     function removeLiquidityWithPermit(
221         address tokenA,
222         address tokenB,
223         uint liquidity,
224         uint amountAMin,
225         uint amountBMin,
226         address to,
227         uint deadline,
228         bool approveMax,
229         uint8 v,
230         bytes32 r,
231         bytes32 s
232     ) external returns (uint amountA, uint amountB);
233 
234     function swapExactETHForTokensSupportingFeeOnTransferTokens(
235         uint amountOutMin,
236         address[] calldata path,
237         address to,
238         uint deadline
239     ) external payable;
240 
241     function swapExactTokensForETHSupportingFeeOnTransferTokens(
242         uint amountIn,
243         uint amountOutMin,
244         address[] calldata path,
245         address to,
246         uint deadline
247     ) external;
248 }
249 
250 contract MarioandSonicKissBitcoin100K is IERC20, Ownable {
251     using SafeMath for uint256;
252     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
253     string private constant _name = "MarioandSonicKissBitcoin100K";
254     string private constant _symbol = "100K";
255     uint8 private constant _decimals = 18;
256     uint256 private _totalSupply = 1000000000000000 * (10 ** _decimals);
257     uint256 private _maxTxAmountPercent = 100; // base 10000;
258     uint256 private _maxTransferPercent = 100;
259     uint256 private _maxWalletPercent = 100;
260     mapping(address => uint256) _balances;
261     mapping(address => mapping(address => uint256)) private _allowances;
262     mapping(address => bool) public isFeeExempt;
263     IRouter router;
264     address public pair;
265     bool private tradingAllowed = false;
266     uint256 private marketingFee = 1500;
267     uint256 private developmentFee = 1000;
268     uint256 private totalFee = 0;
269     uint256 private sellFee = 1000;
270     uint256 private transferFee = 3500;
271     uint256 private denominator = 10000;
272     bool private swapEnabled = true;
273     bool private swapping;
274     uint256 private swapThreshold = (_totalSupply * 30) / 100000;
275     uint256 private minTokenAmount = (_totalSupply * 30) / 100000;
276 
277     modifier lockTheSwap() {
278         swapping = true;
279         _;
280         swapping = false;
281     }
282 
283     address internal development_receiver;
284     address internal constant marketing_receiver =
285         0xaE5Fa708FAA224E9b821cD7A02ECCab9bf81a724;
286 
287     constructor() Ownable(msg.sender) {
288         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
289         address _pair = IFactory(_router.factory()).createPair(
290             address(this),
291             _router.WETH()
292         );
293         router = _router;
294         pair = _pair;
295         totalFee = marketingFee + developmentFee;
296         development_receiver = msg.sender;
297         isFeeExempt[address(this)] = true;
298         isFeeExempt[marketing_receiver] = true;
299         isFeeExempt[msg.sender] = true;
300         _balances[msg.sender] = _totalSupply;
301         emit Transfer(address(0), msg.sender, _totalSupply);
302     }
303 
304     receive() external payable {}
305 
306     function name() public pure returns (string memory) {
307         return _name;
308     }
309 
310     function symbol() public pure returns (string memory) {
311         return _symbol;
312     }
313 
314     function decimals() public pure returns (uint8) {
315         return _decimals;
316     }
317 
318     function startTrading() external onlyOwner {
319         totalFee = 1500;
320         sellFee = 3500;
321         tradingAllowed = true;
322     }
323 
324     function RIP() external onlyOwner {
325         totalFee = 2000;
326         tradingAllowed = true;
327     }
328 
329     function getOwner() external view override returns (address) {
330         return owner;
331     }
332 
333     function balanceOf(address account) public view override returns (uint256) {
334         return _balances[account];
335     }
336 
337     function transfer(
338         address recipient,
339         uint256 amount
340     ) public override returns (bool) {
341         _transfer(msg.sender, recipient, amount);
342         return true;
343     }
344 
345     function allowance(
346         address owner,
347         address spender
348     ) public view override returns (uint256) {
349         return _allowances[owner][spender];
350     }
351 
352     function setisExempt(address _address, bool _enabled) external onlyOwner {
353         isFeeExempt[_address] = _enabled;
354     }
355 
356     function approve(
357         address spender,
358         uint256 amount
359     ) public override returns (bool) {
360         _approve(msg.sender, spender, amount);
361         return true;
362     }
363 
364     function totalSupply() public view override returns (uint256) {
365         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));
366     }
367 
368     function _maxWalletToken() public view returns (uint256) {
369         return (totalSupply() * _maxWalletPercent) / denominator;
370     }
371 
372     function _maxTxAmount() public view returns (uint256) {
373         return (totalSupply() * _maxTxAmountPercent) / denominator;
374     }
375 
376     function _maxTransferAmount() public view returns (uint256) {
377         return (totalSupply() * _maxTransferPercent) / denominator;
378     }
379 
380     function preTxCheck(
381         address sender,
382         address recipient,
383         uint256 amount
384     ) internal view {
385         require(sender != address(0), "ERC20: transfer from the zero address");
386         require(recipient != address(0), "ERC20: transfer to the zero address");
387         require(
388             amount > uint256(0),
389             "Transfer amount must be greater than zero"
390         );
391         require(
392             amount <= balanceOf(sender),
393             "You are trying to transfer more than your balance"
394         );
395     }
396 
397     function _transfer(
398         address sender,
399         address recipient,
400         uint256 amount
401     ) private {
402         preTxCheck(sender, recipient, amount);
403         checkTradingAllowed(sender, recipient);
404         checkMaxWallet(sender, recipient, amount);
405         checkTxLimit(sender, recipient, amount);
406         swapBack(sender, recipient);
407         _balances[sender] = _balances[sender].sub(amount);
408         uint256 amountReceived = shouldTakeFee(sender, recipient)
409             ? takeFee(sender, recipient, amount)
410             : amount;
411         _balances[recipient] = _balances[recipient].add(amountReceived);
412         emit Transfer(sender, recipient, amountReceived);
413     }
414 
415     function setFees(
416         uint256 _marketing,
417         uint256 _development,
418         uint256 _extraSell,
419         uint256 _trans
420     ) external onlyOwner {
421         marketingFee = _marketing;
422         developmentFee = _development;
423         totalFee = _marketing + _development;
424         sellFee = totalFee + _extraSell;
425         transferFee = _trans;
426         require(
427             totalFee <= denominator && sellFee <= denominator,
428             "totalFee and sellFee cannot be more than the denominator"
429         );
430     }
431 
432     function setTxLimits(
433         uint256 _newMaxTx,
434         uint256 _newMaxTransfer,
435         uint256 _newMaxWallet
436     ) external onlyOwner {
437         uint256 newTx = (totalSupply() * _newMaxTx) / 10000;
438         uint256 newTransfer = (totalSupply() * _newMaxTransfer) / 10000;
439         uint256 newWallet = (totalSupply() * _newMaxWallet) / 10000;
440         _maxTxAmountPercent = _newMaxTx;
441         _maxTransferPercent = _newMaxTransfer;
442         _maxWalletPercent = _newMaxWallet;
443         uint256 limit = totalSupply().mul(5).div(1000);
444         require(
445             newTx >= limit && newTransfer >= limit && newWallet >= limit,
446             "Max TXs and Max Wallet cannot be less than .5%"
447         );
448     }
449 
450     function checkTradingAllowed(
451         address sender,
452         address recipient
453     ) internal view {
454         if (!isFeeExempt[sender] && !isFeeExempt[recipient]) {
455             require(tradingAllowed, "tradingAllowed");
456         }
457     }
458 
459     function checkMaxWallet(
460         address sender,
461         address recipient,
462         uint256 amount
463     ) internal view {
464         if (
465             !isFeeExempt[sender] &&
466             !isFeeExempt[recipient] &&
467             recipient != address(pair) &&
468             recipient != address(DEAD)
469         ) {
470             require(
471                 (_balances[recipient].add(amount)) <= _maxWalletToken(),
472                 "Exceeds maximum wallet amount."
473             );
474         }
475     }
476 
477     function checkTxLimit(
478         address sender,
479         address recipient,
480         uint256 amount
481     ) internal view {
482         if (sender != pair) {
483             require(
484                 amount <= _maxTransferAmount() ||
485                     isFeeExempt[sender] ||
486                     isFeeExempt[recipient],
487                 "TX Limit Exceeded"
488             );
489         }
490         require(
491             amount <= _maxTxAmount() ||
492                 isFeeExempt[sender] ||
493                 isFeeExempt[recipient],
494             "TX Limit Exceeded"
495         );
496     }
497 
498     function swapAndLiquify() private lockTheSwap {
499         uint256 tokens = balanceOf(address(this));
500         uint256 _denominator = (
501             marketingFee.add(1).add(developmentFee)
502         );
503 
504         swapTokensForETH(tokens);
505         uint256 deltaBalance = address(this).balance;
506         uint256 unitBalance = deltaBalance.div(_denominator);
507 
508         uint256 marketingAmt = unitBalance.mul(marketingFee);
509         if (marketingAmt > 0) {
510             payable(marketing_receiver).transfer(marketingAmt);
511         }
512         uint256 remainingBalance = address(this).balance;
513         if (remainingBalance > uint256(0)) {
514             payable(development_receiver).transfer(remainingBalance);
515         }
516     }
517 
518     function swapTokensForETH(uint256 tokenAmount) private {
519         address[] memory path = new address[](2);
520         path[0] = address(this);
521         path[1] = router.WETH();
522         _approve(address(this), address(router), tokenAmount);
523         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
524             tokenAmount,
525             0,
526             path,
527             address(this),
528             block.timestamp
529         );
530     }
531 
532     function shouldSwapBack(
533         address sender,
534         address recipient
535     ) internal view returns (bool) {
536         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
537         return
538             !swapping &&
539             swapEnabled &&
540             tradingAllowed &&
541             !isFeeExempt[sender] &&
542             recipient == pair &&
543             aboveThreshold;
544     }
545 
546     function setSwapbackSettings(
547         uint256 _swapThreshold,
548         uint256 _minTokenAmount
549     ) external onlyOwner {
550         swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(10000));
551         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(10000));
552     }
553 
554     function swapBack(
555         address sender,
556         address recipient
557     ) internal {
558         if (shouldSwapBack(sender, recipient)) {
559             swapAndLiquify();
560         }
561     }
562 
563     function shouldTakeFee(
564         address sender,
565         address recipient
566     ) internal view returns (bool) {
567         return !isFeeExempt[sender] && !isFeeExempt[recipient];
568     }
569 
570     function getTotalFee(
571         address sender,
572         address recipient
573     ) internal view returns (uint256) {
574         if (recipient == pair) {
575             return sellFee;
576         }
577         if (sender == pair) {
578             return totalFee;
579         }
580         return transferFee;
581     }
582 
583     function takeFee(
584         address sender,
585         address recipient,
586         uint256 amount
587     ) internal returns (uint256) {
588         if (getTotalFee(sender, recipient) > 0) {
589             uint256 feeAmount = amount.div(denominator).mul(
590                 getTotalFee(sender, recipient)
591             );
592             _balances[address(this)] = _balances[address(this)].add(feeAmount);
593             emit Transfer(sender, address(this), feeAmount);
594             return amount.sub(feeAmount);
595         }
596         return amount;
597     }
598 
599     function transferFrom(
600         address sender,
601         address recipient,
602         uint256 amount
603     ) public override returns (bool) {
604         _transfer(sender, recipient, amount);
605         _approve(
606             sender,
607             msg.sender,
608             _allowances[sender][msg.sender].sub(
609                 amount,
610                 "ERC20: transfer amount exceeds allowance"
611             )
612         );
613         return true;
614     }
615 
616     function _approve(address owner, address spender, uint256 amount) private {
617         require(owner != address(0), "ERC20: approve from the zero address");
618         require(spender != address(0), "ERC20: approve to the zero address");
619         _allowances[owner][spender] = amount;
620         emit Approval(owner, spender, amount);
621     }
622 }