1 // https://t.me/KaizenEthereum
2 // Welcome to Kaizen 改善
3 
4 // SPDX-License-Identifier: MIT
5 pragma solidity ^0.8.16;
6 
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a, "SafeMath: addition overflow");
11         return c;
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");
16     }
17 
18     function sub(
19         uint256 a,
20         uint256 b,
21         string memory errorMessage
22     ) internal pure returns (uint256) {
23         require(b <= a, errorMessage);
24         uint256 c = a - b;
25         return c;
26     }
27 
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34         return c;
35     }
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40 
41     function div(
42         uint256 a,
43         uint256 b,
44         string memory errorMessage
45     ) internal pure returns (uint256) {
46         require(b > 0, errorMessage);
47         uint256 c = a / b;
48         return c;
49     }
50 }
51 
52 interface IERC20 {
53     function totalSupply() external view returns (uint256);
54 
55     function decimals() external view returns (uint8);
56 
57     function symbol() external view returns (string memory);
58 
59     function name() external view returns (string memory);
60 
61     function getOwner() external view returns (address);
62 
63     function balanceOf(address account) external view returns (uint256);
64 
65     function transfer(address recipient, uint256 amount)
66         external
67         returns (bool);
68 
69     function allowance(address _owner, address spender)
70         external
71         view
72         returns (uint256);
73 
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     event Transfer(address indexed from, address indexed to, uint256 value);
83     event Approval(
84         address indexed owner,
85         address indexed spender,
86         uint256 value
87     );
88 }
89 
90 interface DexFactory {
91     function createPair(address tokenA, address tokenB)
92         external
93         returns (address pair);
94 }
95 
96 interface DexRouter {
97     function factory() external pure returns (address);
98 
99     function WETH() external pure returns (address);
100 
101     function addLiquidityETH(
102         address token,
103         uint256 amountTokenDesired,
104         uint256 amountTokenMin,
105         uint256 amountETHMin,
106         address to,
107         uint256 deadline
108     )
109         external
110         payable
111         returns (
112             uint256 amountToken,
113             uint256 amountETH,
114             uint256 liquidity
115         );
116 
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint256 amountIn,
119         uint256 amountOutMin,
120         address[] calldata path,
121         address to,
122         uint256 deadline
123     ) external;
124 }
125 
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address payable) {
128         return payable(msg.sender);
129     }
130 
131     function _msgData() internal view virtual returns (bytes memory) {
132         this;
133         return msg.data;
134     }
135 }
136 
137 contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(
141         address indexed previousOwner,
142         address indexed newOwner
143     );
144 
145     constructor() {
146         address msgSender = _msgSender();
147         _owner = msgSender;
148         authorizations[_owner] = true;
149         emit OwnershipTransferred(address(0), msgSender);
150     }
151 
152     mapping(address => bool) internal authorizations;
153 
154     function owner() public view returns (address) {
155         return _owner;
156     }
157 
158     modifier onlyOwner() {
159         require(_owner == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     function renounceOwnership() public virtual onlyOwner {
164         emit OwnershipTransferred(_owner, address(0));
165         _owner = address(0);
166     }
167 
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(
170             newOwner != address(0),
171             "Ownable: new owner is the zero address"
172         );
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 }
177 
178 contract Kaizen is Ownable, IERC20 {
179 
180     using SafeMath for uint256;
181 
182     string private constant _name = "Kaizen";
183     string private constant _symbol = "Kai";
184 
185     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
186     address private constant ZERO = 0x0000000000000000000000000000000000000000;
187     address private routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
188 
189     uint8 private constant _decimals = 18;
190     uint256 private _totalSupply = 1000000000000 * (10**_decimals);
191 
192     uint256 public _maxTxAmount = (_totalSupply * 10) / 1000;
193     uint256 public _walletMax = (_totalSupply * 20) / 1000;
194 
195     bool public restrictWhales = true;
196 
197     mapping(address => uint256) private _balances;
198     mapping(address => mapping(address => uint256)) private _allowances;
199 
200     mapping(address => bool) public isFeeExempt;
201     mapping(address => bool) public isTxLimitExempt;
202 
203     uint256 public liquidityFee = 1;
204     uint256 public marketingFee = 2;
205     uint256 public devFee = 1;
206 
207     uint256 public totalFee = 4;
208     uint256 public totalFeeIfSelling = 4;
209 
210     bool public takeBuyFee = true;
211     bool public takeSellFee = true;
212     bool public takeTransferFee = true;
213 
214     address private lpWallet;
215     address private projectAddress;
216     address private teamAddress;
217 
218     DexRouter public router;
219     address public pair;
220     mapping(address => bool) public isPair;
221 
222     uint256 public launchedAt;
223 
224     bool public tradingOpen = false;
225     bool private inSwapAndLiquify;
226     bool public swapAndLiquifyEnabled = true;
227     bool public swapAndLiquifyByLimitOnly = false;
228 
229     uint256 public swapThreshold = (_totalSupply * 2) / 2000;
230 
231     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
232 
233     modifier lockTheSwap() {
234         inSwapAndLiquify = true;
235         _;
236         inSwapAndLiquify = false;
237     }
238 
239     constructor() {
240         router = DexRouter(routerAddress);
241         pair = DexFactory(router.factory()).createPair(
242             router.WETH(),
243             address(this)
244         );
245 
246         isPair[pair] = true;
247 
248         lpWallet = msg.sender;
249         projectAddress = 0x3FcB61f71cc80D04E6166F415A9243a8b1af4fcE;
250         teamAddress = 0x3eb6335455a0FaaD765B831bb8b6F33b15cB273B;
251 
252         _allowances[address(this)][address(router)] = type(uint256).max;
253         _allowances[address(this)][address(pair)] = type(uint256).max;
254 
255         isFeeExempt[msg.sender] = true;
256         isFeeExempt[address(this)] = true;
257         isFeeExempt[DEAD] = true;
258 
259         isTxLimitExempt[msg.sender] = true;
260         isTxLimitExempt[pair] = true;
261         isTxLimitExempt[DEAD] = true;
262 
263         isFeeExempt[projectAddress] = true;
264         totalFee = liquidityFee.add(marketingFee).add(devFee);
265         totalFeeIfSelling = totalFee;
266 
267         _balances[msg.sender] = _totalSupply;
268         emit Transfer(address(0), msg.sender, _totalSupply);
269     }
270 
271     receive() external payable {}
272 
273     function name() external pure override returns (string memory) {
274         return _name;
275     }
276 
277     function symbol() external pure override returns (string memory) {
278         return _symbol;
279     }
280 
281     function decimals() external pure override returns (uint8) {
282         return _decimals;
283     }
284 
285     function totalSupply() external view override returns (uint256) {
286         return _totalSupply;
287     }
288 
289     function getOwner() external view override returns (address) {
290         return owner();
291     }
292 
293     function balanceOf(address account) public view override returns (uint256) {
294         return _balances[account];
295     }
296 
297     function allowance(address holder, address spender)
298         external
299         view
300         override
301         returns (uint256)
302     {
303         return _allowances[holder][spender];
304     }
305 
306     function getCirculatingSupply() public view returns (uint256) {
307         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
308     }
309 
310     function approve(address spender, uint256 amount)
311         public
312         override
313         returns (bool)
314     {
315         _allowances[msg.sender][spender] = amount;
316         emit Approval(msg.sender, spender, amount);
317         return true;
318     }
319 
320     function newWalletLimit(uint256 newLimit) external onlyOwner {
321         require(newLimit >= 5, "Wallet Limit needs to be at least 0.5%");
322         _walletMax = (_totalSupply * newLimit) / 1000;
323     }
324 
325     function newTxLimit(uint256 newLimit) external onlyOwner {
326         require(newLimit >= 5, "Wallet Limit needs to be at least 0.5%");
327         _maxTxAmount = (_totalSupply * newLimit) / 1000;
328     }
329 
330     function openTrading() public onlyOwner {
331         tradingOpen = true;
332     }
333 
334     function feeWhitelist(address holder, bool exempt) external onlyOwner {
335         isFeeExempt[holder] = exempt;
336     }
337 
338     function txLimitWhitelist(address holder, bool exempt) external onlyOwner {
339         isTxLimitExempt[holder] = exempt;
340     }
341 
342     function grantCompletePermissions(address target) public onlyOwner {
343         authorizations[target] = true;
344         isFeeExempt[target] = true;
345         isTxLimitExempt[target] = true;
346     }
347 
348     function changeFees(
349         uint256 newLiqFee,
350         uint256 newMarketingFee,
351         uint256 newDevFee,
352         uint256 extraSellFee
353     ) external onlyOwner {
354         liquidityFee = newLiqFee;
355         marketingFee = newMarketingFee;
356         devFee = newDevFee;
357 
358         totalFee = liquidityFee.add(marketingFee).add(devFee);
359         totalFeeIfSelling = totalFee + extraSellFee;
360         require(totalFeeIfSelling + totalFee < 25);
361     }
362 
363     function isAuth(address _address, bool status) public onlyOwner {
364         authorizations[_address] = status;
365     }
366 
367     function changePair(address _address, bool status) public onlyOwner {
368         isPair[_address] = status;
369     }
370 
371     function changeTakeBuyfee(bool status) public onlyOwner {
372         takeBuyFee = status;
373     }
374 
375     function changeTakeSellfee(bool status) public onlyOwner {
376         takeSellFee = status;
377     }
378 
379     function changeTakeTransferfee(bool status) public onlyOwner {
380         takeTransferFee = status;
381     }
382 
383     function changeSwapbackSettings(bool status, uint256 newAmount)
384         public
385         onlyOwner
386     {
387         swapAndLiquifyEnabled = status;
388         swapThreshold = newAmount;
389     }
390 
391     function changeWallets(
392         address newMktWallet,
393         address newDevWallet,
394         address newLpWallet
395     ) public onlyOwner {
396         lpWallet = newLpWallet;
397         projectAddress = newMktWallet;
398         teamAddress = newDevWallet;
399     }
400 
401     function removeERC20(address tokenAddress, uint256 tokens)
402         public
403         onlyOwner
404         returns (bool success)
405     {
406         require(tokenAddress != address(this), "Cant remove the native token");
407         return IERC20(tokenAddress).transfer(msg.sender, tokens);
408     }
409 
410     function removeEther(uint256 amountPercentage) external onlyOwner {
411         uint256 amountETH = address(this).balance;
412         payable(msg.sender).transfer((amountETH * amountPercentage) / 100);
413     }
414 
415     function approveMax(address spender) external returns (bool) {
416         return approve(spender, type(uint256).max);
417     }
418 
419     function launched() internal view returns (bool) {
420         return launchedAt != 0;
421     }
422 
423     function launch() internal {
424         launchedAt = block.number;
425     }
426 
427     function checkTxLimit(address sender, uint256 amount) internal view {
428         require(
429             amount <= _maxTxAmount || isTxLimitExempt[sender],
430             "TX Limit Exceeded"
431         );
432     }
433 
434     function failsCaptcha(address addr) internal view returns (bool) {
435         uint256 size;
436         assembly {
437             size := extcodesize(addr)
438         }
439         return size > 0;
440     }
441 
442     function transfer(address recipient, uint256 amount)
443         external
444         override
445         returns (bool)
446     {
447         return _transferFrom(msg.sender, recipient, amount);
448     }
449 
450     function _basicTransfer(
451         address sender,
452         address recipient,
453         uint256 amount
454     ) internal returns (bool) {
455         _balances[sender] = _balances[sender].sub(
456             amount,
457             "Insufficient Balance"
458         );
459         _balances[recipient] = _balances[recipient].add(amount);
460         emit Transfer(sender, recipient, amount);
461         return true;
462     }
463 
464     function transferFrom(
465         address sender,
466         address recipient,
467         uint256 amount
468     ) external override returns (bool) {
469         if (_allowances[sender][msg.sender] != type(uint256).max) {
470             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
471                 .sub(amount, "Insufficient Allowance");
472         }
473         return _transferFrom(sender, recipient, amount);
474     }
475 
476     function _transferFrom(
477         address sender,
478         address recipient,
479         uint256 amount
480     ) internal returns (bool) {
481         if (inSwapAndLiquify) {
482             return _basicTransfer(sender, recipient, amount);
483         }
484         if (!authorizations[sender] && !authorizations[recipient]) {
485             require(tradingOpen, "");
486         }
487 
488         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit");
489         if (
490             isPair[recipient] &&
491             !inSwapAndLiquify &&
492             swapAndLiquifyEnabled &&
493             _balances[address(this)] >= swapThreshold
494         ) {
495             swapBackAndPair();
496         }
497         if (!launched() && isPair[recipient]) {
498             require(_balances[sender] > 0, "");
499             launch();
500         }
501 
502         //Exchange tokens
503         _balances[sender] = _balances[sender].sub(amount, "");
504 
505         if (!isTxLimitExempt[recipient] && restrictWhales) {
506             require(_balances[recipient].add(amount) <= _walletMax, "");
507         }
508 
509         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient]
510             ? takeFee(sender, recipient, amount)
511             : amount;
512         _balances[recipient] = _balances[recipient].add(finalAmount);
513 
514         emit Transfer(sender, recipient, finalAmount);
515         return true;
516     }
517 
518     function takeFee(
519         address sender,
520         address recipient,
521         uint256 amount
522     ) internal returns (uint256) {
523         uint256 feeApplicable = 0;
524         if (isPair[recipient] && takeSellFee) {
525             feeApplicable = totalFeeIfSelling;
526         }
527         if (isPair[sender] && takeBuyFee) {
528             feeApplicable = totalFee;
529         }
530         if (!isPair[sender] && !isPair[recipient]) {
531             if (takeTransferFee) {
532                 feeApplicable = totalFeeIfSelling;
533             } else {
534                 feeApplicable = 0;
535             }
536         }
537 
538         uint256 feeAmount = amount.mul(feeApplicable).div(100);
539 
540         _balances[address(this)] = _balances[address(this)].add(feeAmount);
541         emit Transfer(sender, address(this), feeAmount);
542 
543         return amount.sub(feeAmount);
544     }
545 
546     function swapBackAndPair() internal lockTheSwap {
547         uint256 tokensToLiquify = _balances[address(this)];
548         uint256 amountToLiquify = tokensToLiquify
549             .mul(liquidityFee)
550             .div(totalFee)
551             .div(2);
552         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
553 
554         address[] memory path = new address[](2);
555         path[0] = address(this);
556         path[1] = router.WETH();
557 
558         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
559             amountToSwap,
560             0,
561             path,
562             address(this),
563             block.timestamp
564         );
565 
566         uint256 amountETH = address(this).balance;
567 
568         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
569 
570         uint256 amountETHLiquidity = amountETH
571             .mul(liquidityFee)
572             .div(totalETHFee)
573             .div(2);
574         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
575             totalETHFee
576         );
577         uint256 amountETHDev = amountETH.mul(devFee).div(totalETHFee);
578 
579         (bool tmpSuccess1, ) = payable(projectAddress).call{
580             value: amountETHMarketing,
581             gas: 30000
582         }("");
583         tmpSuccess1 = false;
584 
585         (tmpSuccess1, ) = payable(teamAddress).call{
586             value: amountETHDev,
587             gas: 30000
588         }("");
589         tmpSuccess1 = false;
590 
591         if (amountToLiquify > 0) {
592             router.addLiquidityETH{value: amountETHLiquidity}(
593                 address(this),
594                 amountToLiquify,
595                 0,
596                 0,
597                 lpWallet,
598                 block.timestamp
599             );
600             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
601         }
602     }
603 
604 }