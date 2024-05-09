1 // SPDX-License-Identifier:MIT
2 
3 pragma solidity ^0.8.10;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address _account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount)
19         external
20         returns (bool);
21     function allowance(address owner, address spender)
22         external
23         view
24         returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor() {
51         _setOwner(_msgSender());
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view virtual returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any _account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(owner() == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     function renounceOwnership() public virtual onlyOwner {
70         _setOwner(address(0));
71     }
72 
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(
75             newOwner != address(0),
76             "Ownable: new owner is the zero address"
77         );
78         _setOwner(newOwner);
79     }
80 
81     function _setOwner(address newOwner) private {
82         address oldOwner = _owner;
83         _owner = newOwner;
84         emit OwnershipTransferred(oldOwner, newOwner);
85     }
86 }
87 
88 library SafeMath {
89 
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93 
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return sub(a, b, "SafeMath: subtraction overflow");
99     }
100 
101     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         require(b <= a, errorMessage);
103         uint256 c = a - b;
104 
105         return c;
106     }
107 
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         if (a == 0) {
110             return 0;
111         }
112 
113         uint256 c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115 
116         return c;
117     }
118 
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122 
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         return mod(a, b, "SafeMath: modulo by zero");
133     }
134 
135     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b != 0, errorMessage);
137         return a % b;
138     }
139 }
140 
141 interface IDexSwapFactory {
142     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
143     function createPair(address tokenA, address tokenB) external returns (address pair);
144 }
145 
146 interface IDexSwapPair {
147     event Approval(address indexed owner, address indexed spender, uint value);
148     event Transfer(address indexed from, address indexed to, uint value);
149 
150     function name() external pure returns (string memory);
151     function symbol() external pure returns (string memory);
152     function decimals() external pure returns (uint8);
153     function totalSupply() external view returns (uint);
154     function balanceOf(address owner) external view returns (uint);
155     function allowance(address owner, address spender) external view returns (uint);
156 
157     function approve(address spender, uint value) external returns (bool);
158     function transfer(address to, uint value) external returns (bool);
159     function transferFrom(address from, address to, uint value) external returns (bool);
160 
161     function DOMAIN_SEPARATOR() external view returns (bytes32);
162     function PERMIT_TYPEHASH() external pure returns (bytes32);
163     function nonces(address owner) external view returns (uint);
164 
165     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
166     
167     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
168     event Swap(
169         address indexed sender,
170         uint amount0In,
171         uint amount1In,
172         uint amount0Out,
173         uint amount1Out,
174         address indexed to
175     );
176     event Sync(uint112 reserve0, uint112 reserve1);
177 
178     function MINIMUM_LIQUIDITY() external pure returns (uint);
179     function factory() external view returns (address);
180     function token0() external view returns (address);
181     function token1() external view returns (address);
182     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
183     function price0CumulativeLast() external view returns (uint);
184     function price1CumulativeLast() external view returns (uint);
185     function kLast() external view returns (uint);
186 
187     function burn(address to) external returns (uint amount0, uint amount1);
188     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
189     function skim(address to) external;
190     function sync() external;
191 
192     function initialize(address, address) external;
193 }
194 
195 interface IDexSwapRouter {
196     function factory() external pure returns (address);
197     function WETH() external pure returns (address);
198     function addLiquidityETH(
199         address token,
200         uint amountTokenDesired,
201         uint amountTokenMin,
202         uint amountETHMin,
203         address to,
204         uint deadline
205     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
206     function swapExactTokensForETHSupportingFeeOnTransferTokens(
207         uint amountIn,
208         uint amountOutMin,
209         address[] calldata path,
210         address to,
211         uint deadline
212     ) external;
213 
214 }
215 
216 contract AlienToken is Context, IERC20, Ownable {
217 
218     using SafeMath for uint256;
219 
220     string private _name = "Alien Milady";
221     string private _symbol = "ALIEN";
222     uint8 private _decimals = 18; 
223 
224     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
225     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
226 
227     uint256 public _buyMarketingFee = 2;
228     uint256 public _sellMarketingFee = 2;
229 
230     address public Marketing = address(0xC59585ddF9236e67264944Ea1aFC9394a61e84bf);
231     
232     uint256 feedenominator = 100;
233 
234     mapping (address => uint256) _balances;
235     mapping (address => mapping (address => uint256)) private _allowances;
236 
237     mapping (address => bool) public isExcludedFromFee;
238     mapping (address => bool) public isMarketPair;
239     mapping (address => bool) public isWalletLimitExempt;
240     mapping (address => bool) public isTxLimitExempt;
241 
242     uint256 private _totalSupply = 1_000_000_000 * 10**_decimals;
243 
244     uint256 public _maxTxAmount =  _totalSupply.mul(1).div(100);     // 1%
245     uint256 public _walletMax = _totalSupply.mul(1).div(100);        // 1%
246 
247     uint256 public swapThreshold = 500_000 * 10**_decimals;
248 
249     uint256 public launchedAt;
250     uint256 public launchedAtTimestamp;
251     bool public normalizeTrade;
252 
253     bool tradingActive;
254 
255     bool public swapEnabled = true;
256     bool public swapbylimit = false;
257     bool public EnableTxLimit = true;
258     bool public checkWalletLimit = true;
259 
260     IDexSwapRouter public dexRouter;
261     address public dexPair;
262 
263     bool inSwap;
264 
265     modifier swapping() {
266         inSwap = true;
267         _;
268         inSwap = false;
269     }
270     
271     event SwapTokensForETH(
272         uint256 amountIn,
273         address[] path
274     );
275 
276     constructor() {
277 
278         address _owner = address(0xe938F21c80D9D344C8e7ebC989113Db63cb26bFd);
279 
280         IDexSwapRouter _dexRouter = IDexSwapRouter(
281             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
282         );
283 
284         dexPair = IDexSwapFactory(_dexRouter.factory()).createPair(
285             address(this),
286             _dexRouter.WETH()
287         );
288 
289         dexRouter = _dexRouter;
290 
291         isExcludedFromFee[address(this)] = true;
292         isExcludedFromFee[_owner] = true;
293         isExcludedFromFee[address(dexRouter)] = true;
294 
295         isWalletLimitExempt[_owner] = true;
296         isWalletLimitExempt[address(dexPair)] = true;
297         isWalletLimitExempt[address(dexRouter)] = true;
298         isWalletLimitExempt[address(this)] = true;
299         isWalletLimitExempt[deadAddress] = true;
300         isWalletLimitExempt[zeroAddress] = true;
301         
302         isTxLimitExempt[deadAddress] = true;
303         isTxLimitExempt[zeroAddress] = true;
304         isTxLimitExempt[_owner] = true;
305         isTxLimitExempt[address(this)] = true;
306         isTxLimitExempt[address(dexRouter)] = true;
307 
308         isMarketPair[address(dexPair)] = true;
309 
310         _allowances[address(this)][address(dexRouter)] = ~uint256(0);
311         _allowances[address(this)][address(dexPair)] = ~uint256(0);
312 
313         _balances[_owner] = _totalSupply;
314         emit Transfer(address(0), _owner, _totalSupply);
315     }
316 
317     function name() public view returns (string memory) {
318         return _name;
319     }
320 
321     function symbol() public view returns (string memory) {
322         return _symbol;
323     }
324 
325     function decimals() public view returns (uint8) {
326         return _decimals;
327     }
328 
329     function totalSupply() public view override returns (uint256) {
330         return _totalSupply;
331     }
332 
333     function balanceOf(address account) public view override returns (uint256) {
334        return _balances[account];     
335     }
336 
337     function allowance(address owner, address spender) public view override returns (uint256) {
338         return _allowances[owner][spender];
339     }
340     
341     function getCirculatingSupply() public view returns (uint256) {
342         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
343     }
344 
345     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
347         return true;
348     }
349 
350     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
351         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
352         return true;
353     }
354 
355     function approve(address spender, uint256 amount) public override returns (bool) {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     function _approve(address owner, address spender, uint256 amount) private {
361         require(owner != address(0), "ERC20: approve from the zero address");
362         require(spender != address(0), "ERC20: approve to the zero address");
363 
364         _allowances[owner][spender] = amount;
365         emit Approval(owner, spender, amount);
366     }
367 
368      //to recieve ETH from Router when swaping
369     receive() external payable {}
370 
371     function transfer(address recipient, uint256 amount) public override returns (bool) {
372         _transfer(_msgSender(), recipient, amount);
373         return true;
374     }
375 
376     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
377         _transfer(sender, recipient, amount);
378         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
379         return true;
380     }
381 
382     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
383 
384         require(sender != address(0), "ERC20: transfer from the zero address");
385         require(recipient != address(0), "ERC20: transfer to the zero address");
386         require(amount > 0, "Transfer amount must be greater than zero");
387     
388         if (inSwap) {
389             return _basicTransfer(sender, recipient, amount);
390         }
391         else {
392 
393             if (!tradingActive) {
394                 require(isExcludedFromFee[sender] || isExcludedFromFee[recipient],"Trading is not active.");
395             }
396 
397             if (launchedAt != 0 && !normalizeTrade) {
398                 dynamicTaxSetter();
399             }
400 
401             uint256 contractTokenBalance = balanceOf(address(this));
402             bool overMinimumTokenBalance = contractTokenBalance >= swapThreshold;
403 
404             if (overMinimumTokenBalance && !inSwap && !isMarketPair[sender] && swapEnabled) {
405                 swapBack(contractTokenBalance);
406             }
407 
408             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
409                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
410             } 
411             
412             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
413 
414             uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);
415 
416             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
417                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Max Wallet Limit Exceeded!!");
418             }
419 
420             _balances[recipient] = _balances[recipient].add(finalAmount);
421 
422             emit Transfer(sender, recipient, finalAmount);
423             return true;
424 
425         }
426 
427     }
428 
429     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
430         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
431         _balances[recipient] = _balances[recipient].add(amount);
432         emit Transfer(sender, recipient, amount);
433         return true;
434     }
435     
436     function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {
437         if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
438             return true;
439         }
440         else if (isMarketPair[sender] || isMarketPair[recipient]) {
441             return false;
442         }
443         else {
444             return false;
445         }
446     }
447 
448     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
449         
450         uint feeAmount;
451 
452         unchecked {
453 
454             if(isMarketPair[sender]) { 
455                 feeAmount = amount.mul(_buyMarketingFee).div(feedenominator);
456             } 
457             else if(isMarketPair[recipient]) { 
458                 feeAmount = amount.mul(_sellMarketingFee).div(feedenominator);
459             }
460 
461             if(feeAmount > 0) {
462                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
463                 emit Transfer(sender, address(this), feeAmount);
464             }
465 
466             return amount.sub(feeAmount);
467         }
468         
469     }
470 
471     function launch() public onlyOwner {
472         require(launchedAt == 0, "Already launched!");
473         launchedAt = block.number;
474         launchedAtTimestamp = block.timestamp;
475         tradingActive = true;
476         swapEnabled = true;
477     }
478 
479     function dynamicTaxSetter() internal {
480         if (block.number <= launchedAt + 2) {
481             dynamicSetter(99,99);
482         }
483         if (block.number > launchedAt + 2 && block.number <= launchedAt + 20) {
484             dynamicSetter(45,45);
485         }
486         if (block.number > launchedAt + 20 && block.number <= launchedAt + 100) {
487             dynamicSetter(5,5);
488         }
489         if (block.number > launchedAt + 100) {
490             dynamicSetter(2,2);
491             normalizeTrade = true;
492         }
493             
494     }
495 
496     function dynamicSetter(uint _buy, uint _Sell) internal {
497         _buyMarketingFee = _buy;
498         _sellMarketingFee = _Sell;
499     }
500 
501 
502     function swapBack(uint contractBalance) internal swapping {
503 
504         if(swapbylimit) contractBalance = swapThreshold;
505 
506         uint256 initialBalance = address(this).balance;
507         swapTokensForEth(contractBalance);
508         uint256 amountReceived = address(this).balance.sub(initialBalance);
509 
510        if(amountReceived > 0) payable(Marketing).transfer(amountReceived);
511 
512     }
513 
514     function swapTokensForEth(uint256 tokenAmount) private {
515         // generate the uniswap pair path of token -> weth
516         address[] memory path = new address[](2);
517         path[0] = address(this);
518         path[1] = dexRouter.WETH();
519 
520         _approve(address(this), address(dexRouter), tokenAmount);
521 
522         // make the swap
523         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
524             tokenAmount,
525             0, // accept any amount of ETH
526             path,
527             address(this), // The contract
528             block.timestamp
529         );
530         
531         emit SwapTokensForETH(tokenAmount, path);
532     }
533 
534     function rescueFunds() external onlyOwner { 
535         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
536         require(os,"Transaction Failed!!");
537     }
538 
539     function rescueTokens(address _token,address recipient,uint _amount) external onlyOwner {
540         (bool success, ) = address(_token).call(abi.encodeWithSignature('transfer(address,uint256)',  recipient, _amount));
541         require(success, 'Token payment failed');
542     }
543 
544     function setFee(uint _buyFee, uint _sellFee) external onlyOwner {    
545         _buyMarketingFee = _buyFee;
546         _sellMarketingFee = _sellFee;
547     }
548 
549     function enableTxLimit(bool _status) external onlyOwner {
550         EnableTxLimit = _status;
551     }
552 
553     function enableWalletLimit(bool _status) external onlyOwner {
554         checkWalletLimit = _status;
555     }
556 
557     function excludeFromFee(address _adr,bool _status) external onlyOwner {
558         isExcludedFromFee[_adr] = _status;
559     }
560 
561     function excludeWalletLimit(address _adr,bool _status) external onlyOwner {
562         isWalletLimitExempt[_adr] = _status;
563     }
564 
565     function excludeTxLimit(address _adr,bool _status) external onlyOwner {
566         isTxLimitExempt[_adr] = _status;
567     }
568 
569     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
570         _walletMax = newLimit;
571     }
572 
573     function setTxLimit(uint256 newLimit) external onlyOwner() {
574         _maxTxAmount = newLimit;
575     }
576     
577     function setMarketingWallet(address _newWallet) external onlyOwner {
578         Marketing = _newWallet;
579     }
580 
581     function setMarketPair(address _pair, bool _status) external onlyOwner {
582         isMarketPair[_pair] = _status;
583         if(_status) {
584             isWalletLimitExempt[_pair] = _status;
585         }
586     }
587 
588     function setSwapBackSettings(bool _enabled, bool _limited)
589         external
590         onlyOwner
591     {
592         swapEnabled = _enabled;
593         swapbylimit = _limited;
594     }
595 
596     function setSwapthreshold(uint _threshold) external onlyOwner {
597         swapThreshold = _threshold;
598     }
599 
600     function setManualRouter(address _router) external onlyOwner {
601         dexRouter = IDexSwapRouter(_router);
602     }
603 
604     function setManualPair(address _pair) external onlyOwner {
605         dexPair = _pair;
606     }
607 
608 
609 }