1 /**
2 
3 Conceptually speaking, what really causes growth, appreciation and gain is the work of the collective and not of the individual. We believe in true decentralization.
4 We can call it hive mind, or collective intelligence. The concept is easy, togheter we are strong.
5 So this is a call for arms, Unite as a community, fight the market, and we all shall prevail.
6 Thus we are ONE.
7 
8 */
9 //SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.5;
11 
12 
13 library SafeMath {
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18 
19 
20 
21         return c;
22     }
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
27         require(b <= a, errorMessage);
28         uint256 c = a - b;
29 
30 
31 
32 
33         return c;
34     }
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         return div(a, b, "SafeMath: division by zero");
47     }
48     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         // Solidity only automatically asserts when dividing by 0
50         require(b > 0, errorMessage);
51         uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53 
54         return c;
55     }
56 }
57 
58 interface IBEP20 {
59     function totalSupply() external view returns (uint256);
60     function decimals() external view returns (uint8);
61     function symbol() external view returns (string memory);
62     function name() external view returns (string memory);
63     function getOwner() external view returns (address);
64     function balanceOf(address account) external view returns (uint256);
65     function transfer(address recipient, uint256 amount) external returns (bool);
66     function allowance(address _owner, address spender) external view returns (uint256);
67     function approve(address spender, uint256 amount) external returns (bool);
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 
75 
76 abstract contract Auth {
77     address internal owner;
78     mapping (address => bool) internal authorizations;
79 
80 
81 
82 
83     constructor(address _owner) {
84         owner = _owner;
85         authorizations[_owner] = true;
86     }
87 
88 
89 
90 
91     
92     modifier onlyOwner() {
93         require(isOwner(msg.sender), "!OWNER"); _;
94     }
95 
96 
97 
98 
99     
100     modifier authorized() {
101         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
102     }
103 
104 
105 
106 
107     
108     function authorize(address adr) public onlyOwner {
109         authorizations[adr] = true;
110     }
111 
112 
113 
114 
115     /**
116      * Remove address' authorization. Owner only
117      */
118     function unauthorize(address adr) public onlyOwner {
119         authorizations[adr] = false;
120     }
121 
122 
123 
124 
125     /**
126      * Check if address is owner
127      */
128     function isOwner(address account) public view returns (bool) {
129         return account == owner;
130     }
131 
132 
133 
134 
135     /**
136      * Return address' authorization status
137      */
138     function isAuthorized(address adr) public view returns (bool) {
139         return authorizations[adr];
140     }
141 
142 
143 
144 
145     /**
146      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
147      */
148     function transferOwnership(address payable adr) public onlyOwner {
149         owner = adr;
150         authorizations[adr] = true;
151         emit OwnershipTransferred(adr);
152     }
153 
154 
155 
156 
157     event OwnershipTransferred(address owner);
158 }
159 
160 
161 interface IDEXFactory {
162     function createPair(address tokenA, address tokenB) external returns (address pair);
163 }
164 
165 interface IDEXRouter {
166     function factory() external pure returns (address);
167     function WETH() external pure returns (address);
168 
169     function addLiquidity(
170         address tokenA,
171         address tokenB,
172         uint amountADesired,
173         uint amountBDesired,
174         uint amountAMin,
175         uint amountBMin,
176         address to,
177         uint deadline
178     ) external returns (uint amountA, uint amountB, uint liquidity);
179 
180 
181 
182 
183     function addLiquidityETH(
184         address token,
185         uint amountTokenDesired,
186         uint amountTokenMin,
187         uint amountETHMin,
188         address to,
189         uint deadline
190     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
191 
192 
193 
194 
195     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
196         uint amountIn,
197         uint amountOutMin,
198         address[] calldata path,
199         address to,
200         uint deadline
201     ) external;
202 
203 
204 
205 
206     function swapExactETHForTokensSupportingFeeOnTransferTokens(
207         uint amountOutMin,
208         address[] calldata path,
209         address to,
210         uint deadline
211     ) external payable;
212 
213 
214 
215 
216     function swapExactTokensForETHSupportingFeeOnTransferTokens(
217         uint amountIn,
218         uint amountOutMin,
219         address[] calldata path,
220         address to,
221         uint deadline
222     ) external;
223 }
224 
225 
226 
227 
228 contract ONE is IBEP20, Auth {
229     using SafeMath for uint256;
230 
231     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
232     address DEAD = 0x000000000000000000000000000000000000dEaD;
233     address ZERO = 0x0000000000000000000000000000000000000000;
234 
235     string constant _name = "Collective Intelligence";
236     string constant _symbol = "ONE";
237     uint8 constant _decimals = 18;
238 
239     uint256 _totalSupply = 9999999 * (10 ** _decimals);
240     uint256 public _maxTxAmount = (_totalSupply * 2) / 100; 
241     uint256 public _maxWalletSize = (_totalSupply * 2) / 100; 
242 
243     mapping (address => uint256) _balances;
244     mapping (address => mapping (address => uint256)) _allowances;
245 
246     mapping (address => bool) isFeeExempt;
247     mapping (address => bool) isTxLimitExempt;
248 
249     uint256 liquidityFee = 0;
250     uint256 BBFee = 1;
251     uint256 totalFee = 1;
252     uint256 feeDenominator = 100;
253     
254     address private marketingReceiver = 0x7daf8CDe768e997E6337734F55FDDfF33823351f;
255 
256     IDEXRouter public router;
257     address public pair;
258     uint256 public launchedAt;
259 
260     bool public swapEnabled = true;
261     uint256 public swapThreshold = _totalSupply / 1000000 * 1; // 0.3%
262     bool inSwap;
263     modifier swapping() { inSwap = true; _; inSwap = false; }
264 
265     constructor () Auth(msg.sender) {
266         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
267         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
268         _allowances[address(this)][address(router)] = type(uint256).max;
269 
270 
271 
272 
273         address _owner = owner;
274         isFeeExempt[_owner] = true;
275         isTxLimitExempt[_owner] = true;
276 
277 
278 
279 
280         _balances[_owner] = _totalSupply;
281         emit Transfer(address(0), _owner, _totalSupply);
282     }
283 
284 
285 
286 
287     receive() external payable { }
288 
289 
290 
291 
292     function totalSupply() external view override returns (uint256) { return _totalSupply; }
293     function decimals() external pure override returns (uint8) { return _decimals; }
294     function symbol() external pure override returns (string memory) { return _symbol; }
295     function name() external pure override returns (string memory) { return _name; }
296     function getOwner() external view override returns (address) { return owner; }
297     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
298     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
299 
300 
301 
302 
303     function approve(address spender, uint256 amount) public override returns (bool) {
304         _allowances[msg.sender][spender] = amount;
305         emit Approval(msg.sender, spender, amount);
306         return true;
307     }
308 
309 
310 
311 
312     function approveMax(address spender) external returns (bool) {
313         return approve(spender, type(uint256).max);
314     }
315 
316 
317 
318 
319     function transfer(address recipient, uint256 amount) external override returns (bool) {
320         return _transferFrom(msg.sender, recipient, amount);
321     }
322 
323 
324 
325 
326     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
327         if(_allowances[sender][msg.sender] != type(uint256).max){
328             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
329         }
330 
331 
332 
333 
334         return _transferFrom(sender, recipient, amount);
335     }
336 
337 
338 
339 
340     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
341         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
342         
343         checkTxLimit(sender, amount);
344         
345         if (recipient != pair && recipient != DEAD) {
346             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletSize, "Transfer amount exceeds the bag size.");
347         }
348         
349         if(shouldSwapBack()){ swapBack(); }
350 
351 
352 
353 
354         if(!launched() && recipient == pair){ require(_balances[sender] > 0); launch(); }
355 
356 
357 
358 
359         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
360 
361 
362 
363 
364         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
365         _balances[recipient] = _balances[recipient].add(amountReceived);
366 
367 
368 
369 
370         emit Transfer(sender, recipient, amountReceived);
371         return true;
372     }
373     
374     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
375         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
376         _balances[recipient] = _balances[recipient].add(amount);
377         emit Transfer(sender, recipient, amount);
378         return true;
379     }
380 
381 
382 
383 
384     function checkTxLimit(address sender, uint256 amount) internal view {
385         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
386     }
387     
388     function shouldTakeFee(address sender) internal view returns (bool) {
389         return !isFeeExempt[sender];
390     }
391 
392 
393 
394 
395 
396 
397 
398 
399     function takeFee(address sender, uint256 amount) internal returns (uint256) {
400         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
401 
402 
403 
404 
405         _balances[address(this)] = _balances[address(this)].add(feeAmount);
406         emit Transfer(sender, address(this), feeAmount);
407 
408 
409 
410 
411         return amount.sub(feeAmount);
412     }
413 
414 
415 
416 
417     function shouldSwapBack() internal view returns (bool) {
418         return msg.sender != pair
419         && !inSwap
420         && swapEnabled
421         && _balances[address(this)] >= swapThreshold;
422     }
423 
424 
425 
426 
427     function swapBack() internal swapping {
428         uint256 contractTokenBalance = balanceOf(address(this));
429         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
430         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
431 
432 
433 
434 
435         address[] memory path = new address[](2);
436         path[0] = address(this);
437         path[1] = WETH;
438 
439 
440 
441 
442         uint256 balanceBefore = address(this).balance;
443 
444 
445 
446 
447         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
448             amountToSwap,
449             0,
450             path,
451             address(this),
452             block.timestamp
453         );
454         uint256 amountETH = address(this).balance.sub(balanceBefore);
455         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
456         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
457         uint256 amountETHMarket = amountETH.mul(BBFee).div(totalETHFee);
458 
459 
460 
461 
462         (bool OPSuccess, /* bytes memory data */) = payable(marketingReceiver).call{value: amountETHMarket, gas: 30000}("");
463         require(OPSuccess, "receiver rejected ETH transfer");
464         addLiquidity(amountToLiquify, amountETHLiquidity);
465     }
466 
467 
468 
469 
470     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
471     if(tokenAmount > 0){
472             router.addLiquidityETH{value: ETHAmount}(
473                 address(this),
474                 tokenAmount,
475                 0,
476                 0,
477                 address(this),
478                 block.timestamp
479             );
480             emit AutoLiquify(ETHAmount, tokenAmount);
481         }
482     }
483 
484 
485 
486 
487     function buyTokens(uint256 amount, address to) internal swapping {
488         address[] memory path = new address[](2);
489         path[0] = WETH;
490         path[1] = address(this);
491 
492 
493 
494 
495         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
496             0,
497             path,
498             to,
499             block.timestamp
500         );
501     }
502 
503 
504 
505 
506     function launched() internal view returns (bool) {
507         return launchedAt != 0;
508     }
509 
510 
511 
512 
513     function launch() internal {
514         launchedAt = block.number;
515     }
516 
517 
518 
519 
520     function setTxLimit(uint256 amount) external authorized {
521         require(amount >= _totalSupply / 1000);
522         _maxTxAmount = amount;
523     }
524 
525 
526 
527 
528    function setMaxWallet(uint256 amount) external onlyOwner() {
529         require(amount >= _totalSupply / 1000 );
530         _maxWalletSize = amount;
531     }    
532 
533 
534 
535 
536     function setIsFeeExempt(address holder, bool exempt) external authorized {
537         isFeeExempt[holder] = exempt;
538     }
539 
540 
541 
542 
543     function setIsTxLimitExempt(address holder, bool exempt) external authorized {
544         isTxLimitExempt[holder] = exempt;
545     }
546 
547 
548 
549 
550     function setFees(uint256 _liquidityFee, uint256 _BBFee, uint256 _feeDenominator) external authorized {
551         liquidityFee = _liquidityFee;
552         BBFee = _BBFee;
553         totalFee = _liquidityFee.add(_BBFee);
554         feeDenominator = _feeDenominator;
555     }
556 
557 
558 
559 
560     function setFeeReceiver(address _marketingReceiver) external authorized {
561         marketingReceiver = _marketingReceiver;
562     }
563 
564 
565 
566 
567     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
568         swapEnabled = _enabled;
569         swapThreshold = _amount;
570     }
571 
572 
573 
574     function getCirculatingSupply() public view returns (uint256) {
575         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
576     }
577 
578 
579 
580 
581     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
582         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
583     }
584 
585 
586 
587 
588     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
589         return getLiquidityBacking(accuracy) > target;
590     }
591     
592     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
593 }