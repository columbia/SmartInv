1 /**
2 
3 Website - https://furabbit.com/
4 Socials - https://linktr.ee/furabbiterc
5 
6  */
7 //SPDX-License-Identifier: MIT
8 
9 
10 pragma solidity ^0.8.5;
11 
12 
13 
14 
15 library SafeMath {
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20 
21 
22 
23         return c;
24     }
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "SafeMath: subtraction overflow");
27     }
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31 
32 
33 
34 
35         return c;
36     }
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44 
45         return c;
46     }
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54 
55         return c;
56     }
57 }
58 
59 interface IBEP20 {
60     function totalSupply() external view returns (uint256);
61     function decimals() external view returns (uint8);
62     function symbol() external view returns (string memory);
63     function name() external view returns (string memory);
64     function getOwner() external view returns (address);
65     function balanceOf(address account) external view returns (uint256);
66     function transfer(address recipient, uint256 amount) external returns (bool);
67     function allowance(address _owner, address spender) external view returns (uint256);
68     function approve(address spender, uint256 amount) external returns (bool);
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 
76 
77 abstract contract Auth {
78     address internal owner;
79     mapping (address => bool) internal authorizations;
80 
81 
82 
83 
84     constructor(address _owner) {
85         owner = _owner;
86         authorizations[_owner] = true;
87     }
88 
89 
90 
91 
92     
93     modifier onlyOwner() {
94         require(isOwner(msg.sender), "!OWNER"); _;
95     }
96 
97 
98 
99 
100     
101     modifier authorized() {
102         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
103     }
104 
105 
106 
107 
108     
109     function authorize(address adr) public onlyOwner {
110         authorizations[adr] = true;
111     }
112 
113 
114     function unauthorize(address adr) public onlyOwner {
115         authorizations[adr] = false;
116     }
117 
118   
119     function isOwner(address account) public view returns (bool) {
120         return account == owner;
121     }
122 
123 
124     function isAuthorized(address adr) public view returns (bool) {
125         return authorizations[adr];
126     }
127 
128     function transferOwnership(address payable adr) public onlyOwner {
129         owner = adr;
130         authorizations[adr] = true;
131         emit OwnershipTransferred(adr);
132     }
133 
134     function RenounceOwnership() public onlyOwner {
135         address adr = address(0x000000000000000000000000000000000000dEaD);
136         owner = adr;
137         authorizations[adr] = true;
138         emit OwnershipTransferred(adr);
139     }
140 
141     event OwnershipTransferred(address owner);
142 }
143 
144 
145 interface IDEXFactory {
146     function createPair(address tokenA, address tokenB) external returns (address pair);
147 }
148 
149 interface IDEXRouter {
150     function factory() external pure returns (address);
151     function WETH() external pure returns (address);
152 
153     function addLiquidity(
154         address tokenA,
155         address tokenB,
156         uint amountADesired,
157         uint amountBDesired,
158         uint amountAMin,
159         uint amountBMin,
160         address to,
161         uint deadline
162     ) external returns (uint amountA, uint amountB, uint liquidity);
163 
164 
165 
166 
167     function addLiquidityETH(
168         address token,
169         uint amountTokenDesired,
170         uint amountTokenMin,
171         uint amountETHMin,
172         address to,
173         uint deadline
174     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
175 
176 
177 
178 
179     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
180         uint amountIn,
181         uint amountOutMin,
182         address[] calldata path,
183         address to,
184         uint deadline
185     ) external;
186 
187 
188 
189 
190     function swapExactETHForTokensSupportingFeeOnTransferTokens(
191         uint amountOutMin,
192         address[] calldata path,
193         address to,
194         uint deadline
195     ) external payable;
196 
197 
198 
199 
200     function swapExactTokensForETHSupportingFeeOnTransferTokens(
201         uint amountIn,
202         uint amountOutMin,
203         address[] calldata path,
204         address to,
205         uint deadline
206     ) external;
207 }
208 
209 
210 
211 
212 contract Fu is IBEP20, Auth {
213     using SafeMath for uint256;
214 
215     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
216     address DEAD = 0x000000000000000000000000000000000000dEaD;
217     address ZERO = 0x0000000000000000000000000000000000000000;
218 
219     string constant _name = unicode"Fú";
220     string constant _symbol = unicode"福";
221     uint8 constant _decimals = 18;
222 
223     uint256 _totalSupply = 100000000 * (10 ** _decimals);
224     uint256 public _maxTxAmount = (_totalSupply * 2) / 100; 
225     uint256 public _maxWalletSize = (_totalSupply * 2) / 100; 
226 
227     mapping (address => uint256) _balances;
228     mapping (address => mapping (address => uint256)) _allowances;
229 
230     mapping (address => bool) isFeeExempt;
231     mapping (address => bool) isTxLimitExempt;
232 
233     uint256 liquidityFee = 1;
234     uint256 YingxiaoFee = 2;
235     uint256 totalFee = 3;
236     uint256 feeDenominator = 100;
237     
238     address private YingxiaoReceiver = 0x6306042291819d72DF8F942a004d53b5E706a2C5;
239     address private liquidityReceiver = 0x6306042291819d72DF8F942a004d53b5E706a2C5;
240 
241     IDEXRouter public router;
242     address public pair;
243     uint256 public launchedAt;
244 
245     bool public swapEnabled = true;
246     uint256 public swapThreshold = _totalSupply / 1000000 * 1; // 0.1%
247     bool inSwap;
248     modifier swapping() { inSwap = true; _; inSwap = false; }
249 
250     constructor () Auth(msg.sender) {
251         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
252         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
253         _allowances[address(this)][address(router)] = type(uint256).max;
254 
255 
256 
257 
258         address _owner = owner;
259         isFeeExempt[_owner] = true;
260         isTxLimitExempt[_owner] = true;
261 
262 
263 
264 
265         _balances[_owner] = _totalSupply;
266         emit Transfer(address(0), _owner, _totalSupply);
267     }
268 
269 
270 
271 
272     receive() external payable { }
273 
274 
275 
276 
277     function totalSupply() external view override returns (uint256) { return _totalSupply; }
278     function decimals() external pure override returns (uint8) { return _decimals; }
279     function symbol() external pure override returns (string memory) { return _symbol; }
280     function name() external pure override returns (string memory) { return _name; }
281     function getOwner() external view override returns (address) { return owner; }
282     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
283     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
284 
285 
286 
287 
288     function approve(address spender, uint256 amount) public override returns (bool) {
289         _allowances[msg.sender][spender] = amount;
290         emit Approval(msg.sender, spender, amount);
291         return true;
292     }
293 
294 
295 
296 
297     function approveMax(address spender) external returns (bool) {
298         return approve(spender, type(uint256).max);
299     }
300 
301 
302 
303 
304     function transfer(address recipient, uint256 amount) external override returns (bool) {
305         return _transferFrom(msg.sender, recipient, amount);
306     }
307 
308 
309 
310 
311     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
312         if(_allowances[sender][msg.sender] != type(uint256).max){
313             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
314         }
315 
316 
317 
318 
319         return _transferFrom(sender, recipient, amount);
320     }
321 
322 
323 
324 
325     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
326         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
327         
328         checkTxLimit(sender, amount);
329         
330         if (recipient != pair && recipient != DEAD) {
331             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletSize, "Transfer amount exceeds the bag size.");
332         }
333         
334         if(shouldSwapBack()){ swapBack(); }
335 
336 
337 
338 
339         if(!launched() && recipient == pair){ require(_balances[sender] > 0); launch(); }
340 
341 
342 
343 
344         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
345 
346 
347 
348 
349         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
350         _balances[recipient] = _balances[recipient].add(amountReceived);
351 
352 
353 
354 
355         emit Transfer(sender, recipient, amountReceived);
356         return true;
357     }
358     
359     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
360         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
361         _balances[recipient] = _balances[recipient].add(amount);
362         emit Transfer(sender, recipient, amount);
363         return true;
364     }
365 
366 
367 
368 
369     function checkTxLimit(address sender, uint256 amount) internal view {
370         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
371     }
372     
373     function shouldTakeFee(address sender) internal view returns (bool) {
374         return !isFeeExempt[sender];
375     }
376 
377 
378 
379 
380 
381 
382 
383 
384     function takeFee(address sender, uint256 amount) internal returns (uint256) {
385         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
386 
387 
388 
389 
390         _balances[address(this)] = _balances[address(this)].add(feeAmount);
391         emit Transfer(sender, address(this), feeAmount);
392 
393 
394 
395 
396         return amount.sub(feeAmount);
397     }
398 
399 
400 
401 
402     function shouldSwapBack() internal view returns (bool) {
403         return msg.sender != pair
404         && !inSwap
405         && swapEnabled
406         && _balances[address(this)] >= swapThreshold;
407     }
408 
409 
410 
411 
412     function swapBack() internal swapping {
413         uint256 contractTokenBalance = balanceOf(address(this));
414         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
415         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
416 
417 
418 
419 
420         address[] memory path = new address[](2);
421         path[0] = address(this);
422         path[1] = WETH;
423 
424 
425 
426 
427         uint256 balanceBefore = address(this).balance;
428 
429 
430 
431 
432         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
433             amountToSwap,
434             0,
435             path,
436             address(this),
437             block.timestamp
438         );
439         uint256 amountETH = address(this).balance.sub(balanceBefore);
440         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
441         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
442         uint256 amountETHMarket = amountETH.mul(YingxiaoFee).div(totalETHFee);
443 
444 
445 
446 
447         (bool OPSuccess, /* bytes memory data */) = payable(YingxiaoReceiver).call{value: amountETHMarket, gas: 30000}("");
448         require(OPSuccess, "receiver rejected ETH transfer");
449         addLiquidityFromSwapBack(amountToLiquify, amountETHLiquidity);
450     }
451 
452 
453 
454 
455     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
456     if(tokenAmount > 0){
457             router.addLiquidityETH{value: ETHAmount}(
458                 address(this),
459                 tokenAmount,
460                 0,
461                 0,
462                 address(this),
463                 block.timestamp
464             );
465             emit AutoLiquify(ETHAmount, tokenAmount);
466         }
467     }
468 
469     // function only used on swapback
470 
471     function addLiquidityFromSwapBack(uint256 tokenAmount, uint256 ETHAmount) private {
472     if(tokenAmount > 0){
473             router.addLiquidityETH{value: ETHAmount}(
474                 address(this),
475                 tokenAmount,
476                 0,
477                 0,
478                 liquidityReceiver,
479                 block.timestamp
480             );
481             emit AutoLiquify(ETHAmount, tokenAmount);
482         }
483     }
484 
485 
486     function buyTokens(uint256 amount, address to) internal swapping {
487         address[] memory path = new address[](2);
488         path[0] = WETH;
489         path[1] = address(this);
490 
491 
492 
493 
494         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
495             0,
496             path,
497             to,
498             block.timestamp
499         );
500     }
501 
502 
503 
504 
505     function launched() internal view returns (bool) {
506         return launchedAt != 0;
507     }
508 
509 
510 
511 
512     function launch() internal {
513         launchedAt = block.number;
514     }
515 
516 
517 
518 
519     function setTxLimit(uint256 amount) external authorized {
520         require(amount >= _totalSupply / 1000);
521         _maxTxAmount = amount;
522     }
523 
524 
525 
526 
527    function setMaxWallet(uint256 amount) external onlyOwner() {
528         require(amount >= _totalSupply / 1000 );
529         _maxWalletSize = amount;
530     }    
531 
532 
533 
534 
535     function setIsFeeExempt(address holder, bool exempt) external authorized {
536         isFeeExempt[holder] = exempt;
537     }
538 
539 
540 
541 
542     function setIsTxLimitExempt(address holder, bool exempt) external authorized {
543         isTxLimitExempt[holder] = exempt;
544     }
545 
546 
547 
548 
549     function setFees(uint256 _liquidityFee, uint256 _YingxiaoFee, uint256 _feeDenominator) external authorized {
550         liquidityFee = _liquidityFee;
551         YingxiaoFee = _YingxiaoFee;
552         totalFee = _liquidityFee.add(_YingxiaoFee);
553         feeDenominator = _feeDenominator;
554     }
555 
556 
557 
558 
559     function setFeeReceiver(address _YingxiaoReceiver) external authorized {
560         YingxiaoReceiver = _YingxiaoReceiver;
561     }
562 
563 
564 
565 
566     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
567         swapEnabled = _enabled;
568         swapThreshold = _amount;
569     }
570 
571 
572 
573     function getCirculatingSupply() public view returns (uint256) {
574         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
575     }
576 
577 
578 
579 
580     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
581         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
582     }
583 
584 
585 
586 
587     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
588         return getLiquidityBacking(accuracy) > target;
589     }
590     
591     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
592 }