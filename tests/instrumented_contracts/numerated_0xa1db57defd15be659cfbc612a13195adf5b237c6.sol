1 /**
2  * Website :  https://www.manacoin.io/
3  * DApp :     https://app.manacoin.io/
4  * Twitter :  https://twitter.com/ManaCoinETH
5  * Medium :   https://medium.com/@ManaCoinETH
6  * Telegram : https://t.me/ManaCoinETH
7 **/
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity = 0.8.18;
11 
12 interface IERC20 {
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address to, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address from, address to, uint256 amount) external returns (bool);
22 }
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 abstract contract Ownable is Context {
35     address private _owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38     
39     constructor() {
40         _transferOwnership(_msgSender());
41     }
42     
43     modifier onlyOwner() {
44         _checkOwner();
45         _;
46     }
47 
48     function owner() public view virtual returns (address) {
49         return _owner;
50     }
51 
52     function _checkOwner() internal view virtual {
53         require(owner() == _msgSender(), "Ownable: caller is not the owner");
54     }
55 
56     function renounceOwnership() public virtual onlyOwner {
57         _transferOwnership(address(0));
58     }
59 
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _transferOwnership(newOwner);
63     }
64 
65     function _transferOwnership(address newOwner) internal virtual {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 interface IUniswapV2Pair {
73     event Approval(address indexed owner, address indexed spender, uint value);
74     event Transfer(address indexed from, address indexed to, uint value);
75 
76     function name() external pure returns (string memory);
77     function symbol() external pure returns (string memory);
78     function decimals() external pure returns (uint8);
79     function totalSupply() external view returns (uint);
80     function balanceOf(address owner) external view returns (uint);
81     function allowance(address owner, address spender) external view returns (uint);
82 
83     function approve(address spender, uint value) external returns (bool);
84     function transfer(address to, uint value) external returns (bool);
85     function transferFrom(address from, address to, uint value) external returns (bool);
86 
87     function DOMAIN_SEPARATOR() external view returns (bytes32);
88     function PERMIT_TYPEHASH() external pure returns (bytes32);
89     function nonces(address owner) external view returns (uint);
90 
91     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
92 
93     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
94     event Swap(address indexed sender, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out, address indexed to);
95     event Sync(uint112 reserve0, uint112 reserve1);
96 
97     function MINIMUM_LIQUIDITY() external pure returns (uint);
98     function factory() external view returns (address);
99     function token0() external view returns (address);
100     function token1() external view returns (address);
101     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
102     function price0CumulativeLast() external view returns (uint);
103     function price1CumulativeLast() external view returns (uint);
104     function kLast() external view returns (uint);
105 
106     function burn(address to) external returns (uint amount0, uint amount1);
107     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
108     function skim(address to) external;
109     function sync() external;
110 
111     function initialize(address, address) external;
112 }
113 
114 interface IUniswapV2Factory {
115     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
116 
117     function feeTo() external view returns (address);
118     function feeToSetter() external view returns (address);
119 
120     function getPair(address tokenA, address tokenB) external view returns (address pair);
121     function allPairs(uint) external view returns (address pair);
122     function allPairsLength() external view returns (uint);
123 
124     function createPair(address tokenA, address tokenB) external returns (address pair);
125 
126     function setFeeTo(address) external;
127     function setFeeToSetter(address) external;
128 }
129 
130 interface IUniswapV2Router01 {
131     function factory() external pure returns (address);
132     function WETH() external pure returns (address);
133 
134     function addLiquidity(
135         address tokenA,
136         address tokenB,
137         uint amountADesired,
138         uint amountBDesired,
139         uint amountAMin,
140         uint amountBMin,
141         address to,
142         uint deadline
143     ) external returns (uint amountA, uint amountB, uint liquidity);
144     function addLiquidityETH(
145         address token,
146         uint amountTokenDesired,
147         uint amountTokenMin,
148         uint amountETHMin,
149         address to,
150         uint deadline
151     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
152     function removeLiquidity(
153         address tokenA,
154         address tokenB,
155         uint liquidity,
156         uint amountAMin,
157         uint amountBMin,
158         address to,
159         uint deadline
160     ) external returns (uint amountA, uint amountB);
161     function removeLiquidityETH(
162         address token,
163         uint liquidity,
164         uint amountTokenMin,
165         uint amountETHMin,
166         address to,
167         uint deadline
168     ) external returns (uint amountToken, uint amountETH);
169     function removeLiquidityWithPermit(
170         address tokenA,
171         address tokenB,
172         uint liquidity,
173         uint amountAMin,
174         uint amountBMin,
175         address to,
176         uint deadline,
177         bool approveMax, uint8 v, bytes32 r, bytes32 s
178     ) external returns (uint amountA, uint amountB);
179     function removeLiquidityETHWithPermit(
180         address token,
181         uint liquidity,
182         uint amountTokenMin,
183         uint amountETHMin,
184         address to,
185         uint deadline,
186         bool approveMax, uint8 v, bytes32 r, bytes32 s
187     ) external returns (uint amountToken, uint amountETH);
188     function swapExactTokensForTokens(
189         uint amountIn,
190         uint amountOutMin,
191         address[] calldata path,
192         address to,
193         uint deadline
194     ) external returns (uint[] memory amounts);
195     function swapTokensForExactTokens(
196         uint amountOut,
197         uint amountInMax,
198         address[] calldata path,
199         address to,
200         uint deadline
201     ) external returns (uint[] memory amounts);
202     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
203         external
204         payable
205         returns (uint[] memory amounts);
206     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
207         external
208         returns (uint[] memory amounts);
209     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
210         external
211         returns (uint[] memory amounts);
212     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
213         external
214         payable
215         returns (uint[] memory amounts);
216 
217     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
218     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
219     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
220     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
221     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
222 }
223 
224 interface IUniswapV2Router02 is IUniswapV2Router01 {
225     function removeLiquidityETHSupportingFeeOnTransferTokens(
226         address token,
227         uint liquidity,
228         uint amountTokenMin,
229         uint amountETHMin,
230         address to,
231         uint deadline
232     ) external returns (uint amountETH);
233     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
234         address token,
235         uint liquidity,
236         uint amountTokenMin,
237         uint amountETHMin,
238         address to,
239         uint deadline,
240         bool approveMax, uint8 v, bytes32 r, bytes32 s
241     ) external returns (uint amountETH);
242 
243     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
244         uint amountIn,
245         uint amountOutMin,
246         address[] calldata path,
247         address to,
248         uint deadline
249     ) external;
250     function swapExactETHForTokensSupportingFeeOnTransferTokens(
251         uint amountOutMin,
252         address[] calldata path,
253         address to,
254         uint deadline
255     ) external payable;
256     function swapExactTokensForETHSupportingFeeOnTransferTokens(
257         uint amountIn,
258         uint amountOutMin,
259         address[] calldata path,
260         address to,
261         uint deadline
262     ) external;
263 }
264 
265 contract ManaCoin is Ownable, IERC20{
266     string  private _name;
267     string  private _symbol;
268     uint256 private _decimals;
269     uint256 private _totalSupply;
270 
271     uint256 public  maxTxLimit;
272     uint256 public  maxWalletLimit;
273     uint256 public minTokenSwapAmount;
274     address payable public treasuryWallet;
275     uint256 public  swapableRefection;
276     uint256 public  swapableTreasuryTax;
277     bool private _swapping;
278     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
279 
280     uint256 public sellTax;
281     uint256 public buyTax;
282     uint256 public taxSharePercentage;
283     uint256 public totalBurned;
284     uint256 public totalReflected;
285     uint256 public totalLP;
286 
287     IUniswapV2Router02 public dexRouter;
288     address public  lpPair;
289     bool    public  tradingActive;
290     bool    public  isLimit;
291     uint256 public  ethReflectionBasis;
292     uint256 public  reflectionLockPeriod;
293 
294     mapping(address => uint256) private _balances;
295     mapping(address => mapping(address => uint256)) private _allowances;
296 
297     mapping(address => bool)    private _reflectionExcluded;
298     mapping(address => uint256) public  lastReflectionBasis;
299     mapping(address => uint256) public  lastReflectionTimeStamp;
300     mapping(address => uint256) public  totalClaimedReflection;
301     mapping(address => uint256) private _claimableReflection;
302 
303     mapping(address => bool)    public  lpPairs;
304     mapping(address => bool)    private _isExcludedFromTax;
305 
306     event functionType (uint Type, address sender, uint256 amount);
307     event reflectionClaimed (address indexed recipient, uint256 amount);
308     event recoverAllEths(uint256 amount);
309     event excludedFromTaxes (address account);
310     event includeInTaxes(address account);
311     event buyTaxUpdated(uint256 tax);
312     event sellTaxUpdated(uint256 tax);
313     event taxSharePercentageUpdated(uint256 percentage);
314     event reflectionExcluded(address account);
315     event recoverERC20Tokens(address token, uint256 amount);
316 
317     constructor(){
318         _name              = "ManaCoin";
319         _symbol            = "MNC";
320         _decimals          = 18;
321         _totalSupply       = 100000000 * (10 ** _decimals);
322         _balances[owner()] = _balances[owner()] + _totalSupply;
323 
324         treasuryWallet     = payable(0x0aDEAE6683eFB0408542350E89B7B8311C4b6CE2);
325         sellTax            = 20;
326         buyTax             = 15;
327         maxTxLimit         = 2000000000000000000000000;
328         maxWalletLimit     = 2000000000000000000000000;
329         minTokenSwapAmount = (_totalSupply * 21) / 10000;
330         taxSharePercentage   = 50;
331         reflectionLockPeriod = 60; 
332         isLimit = true;
333 
334         dexRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
335         lpPair    = IUniswapV2Factory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
336         lpPairs[lpPair] = true;
337 
338         _approve(owner(), address(dexRouter), type(uint256).max);
339         _approve(address(this), address(dexRouter), type(uint256).max);
340 
341         _isExcludedFromTax[owner()]        = true;
342         _isExcludedFromTax[treasuryWallet] = true;
343         _isExcludedFromTax[address(this)]  = true;
344         _isExcludedFromTax[lpPair]         = true;
345 
346         emit Transfer(address(0), owner(), _totalSupply);
347     }
348 
349     receive() external payable {}
350 
351     function name() public view returns (string memory) {
352         return _name;
353     }
354 
355     function symbol() public view returns (string memory) {
356         return _symbol;
357     }
358 
359     function decimals() public view returns (uint256) {
360         return _decimals;
361     }
362 
363     function totalSupply() public view override returns (uint256) {
364         return _totalSupply;
365     }
366 
367     function balanceOf(address account) public view override returns (uint256) {
368         return _balances[account];
369     }
370 
371     function allowance(address sender, address spender) public view override returns (uint256) {
372         return _allowances[sender][spender];
373     }
374 
375     function approve(address spender, uint256 amount) public override returns (bool) {
376         _approve(msg.sender, spender, amount);
377         return true;
378     }
379 
380     function _approve(address sender, address spender, uint256 amount) private {
381         require(sender  != address(0), "ERC20: Zero Address");
382         require(spender != address(0), "ERC20: Zero Address");
383 
384         _allowances[sender][spender] = amount;
385         emit Approval(sender, spender, amount);
386     }
387 
388     function transfer(address recipient, uint256 amount) public override returns (bool) {
389         require(_msgSender() != address(0), "ERC20: Zero Address");
390         require(recipient != address(0), "ERC20: Zero Address");
391         require(recipient != DEAD, "ERC20: Dead Address");
392         require(_balances[msg.sender] >= amount, "ERC20: Amount exceeds account balance");
393 
394         _transfer(msg.sender, recipient, amount);
395 
396         return true;
397     }
398 
399     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
400         require(_msgSender() != address(0), "ERC20: Zero Address");
401         require(recipient != address(0), "ERC20: Zero Address");
402         require(recipient != DEAD, "ERC20: Dead Address");
403         require(_allowances[sender][msg.sender] >= amount, "ERC20: Insufficient allowance.");
404         require(_balances[sender] >= amount, "ERC20: Amount exceeds sender's account balance");
405 
406         if (_allowances[sender][msg.sender] != type(uint256).max) {
407             _allowances[sender][msg.sender]  = _allowances[sender][msg.sender] + (amount);
408         }
409         _transfer(sender, recipient, amount);
410 
411         return true;
412     }
413 
414     function _transfer(address sender, address recipient, uint256 amount) private {
415 
416         if (sender == owner() && lpPairs[recipient]) {
417             _transferBothExcluded(sender, recipient, amount);
418         }
419         else if (lpPairs[sender] || lpPairs[recipient]){
420             require(tradingActive == true, "ERC20: Trading is not active.");
421             
422             if (_isExcludedFromTax[sender] && !_isExcludedFromTax[recipient]){
423                 if (_checkWalletLimit(recipient, amount) && _checkTxLimit(amount)) {
424                     _transferBuy(sender, recipient, amount); //user buy process
425                 } 
426             }   
427             else if (!_isExcludedFromTax[sender] && _isExcludedFromTax[recipient]){
428                 if (_checkTxLimit(amount)) {
429                     _transferSell(sender, recipient, amount); //user sell process
430                 }
431             }
432             else if (_isExcludedFromTax[sender] && _isExcludedFromTax[recipient]) {
433                 if (sender == owner() || recipient == owner() || sender == address(this) || recipient == address(this)) {
434                     _transferBothExcluded(sender, recipient, amount);
435                 } else if (lpPairs[recipient]) {
436                     if (_checkTxLimit(amount)) {
437                         _transferBothExcluded(sender, recipient, amount);
438                     }
439                 } else if (_checkWalletLimit(recipient, amount) && _checkTxLimit(amount)){
440                     _transferBothExcluded(sender, recipient, amount);
441                 }
442             } 
443         } else {
444             if (sender == owner() || recipient == owner() || sender == address(this) || recipient == address(this)) {
445                     _transferBothExcluded(sender, recipient, amount);
446             } else if(_checkWalletLimit(recipient, amount) && _checkTxLimit(amount)){
447                     _transferBothExcluded(sender, recipient, amount);
448             }
449         }
450     }
451 
452     function _transferBuy(address sender, address recipient, uint256 amount) private { 
453         /// users buy process
454         uint256 randomTaxType  = _generateRandomTaxType();
455         uint256 taxAmount     = amount * (buyTax)/100;
456         uint256 receiveAmount = amount - (taxAmount);
457         // get tax details
458         ( uint256 treasuryAmount, uint256 burnAmount, uint256 lpAmount, uint256 reflectionAmount ) = _getTaxAmount(taxAmount);
459         
460         _claimableReflection[recipient] = _claimableReflection[recipient] + unclaimedReflection(recipient); 
461         lastReflectionBasis[recipient]  = ethReflectionBasis;
462 
463         _balances[sender]        = _balances[sender] - (amount);
464         _balances[recipient]     = _balances[recipient] + (receiveAmount);
465         _balances[address(this)] = _balances[address(this)] + (treasuryAmount);
466         swapableTreasuryTax      = swapableTreasuryTax + (treasuryAmount);
467 
468         if (randomTaxType == 1) {
469             // true burn
470             _burn(sender, burnAmount);
471             emit functionType(randomTaxType, sender, burnAmount);
472         } else if (randomTaxType == 2) {
473             // smart lp
474             _takeLP(sender, lpAmount);
475             emit functionType(randomTaxType, sender, lpAmount);
476         } else if (randomTaxType == 3) {
477             // reflection adding
478             _balances[address(this)] = _balances[address(this)] + (reflectionAmount);
479             swapableRefection        = swapableRefection + (reflectionAmount);
480             totalReflected           = totalReflected + (reflectionAmount);
481             emit functionType(randomTaxType, sender, reflectionAmount);
482         }
483         emit Transfer(sender, recipient, amount);
484     }
485 
486     function _transferSell(address sender, address recipient, uint256 amount) private { 
487         /// users sell process
488         uint256 randomTaxType = _generateRandomTaxType();
489         uint256 taxAmount    = amount * sellTax/100;
490         uint256 sentAmount   = amount - taxAmount;
491         // get sell tax details
492         ( uint256 treasuryAmount, uint256 burnAmount, uint256 lpAmount, uint256 reflectionAmount ) = _getTaxAmount(taxAmount);
493         bool canSwap = swapableTreasuryTax >= minTokenSwapAmount;
494 
495         if(canSwap && !_swapping ) {
496             _swapping = true;
497             _swap(treasuryWallet, minTokenSwapAmount); // treasury swap function
498             _swapping = false;
499             swapableTreasuryTax = swapableTreasuryTax - (minTokenSwapAmount);
500         }
501 
502         _balances[sender]        = _balances[sender] - (amount);
503         _balances[recipient]     = _balances[recipient] + (sentAmount);
504         _balances[address(this)] = _balances[address(this)] + (treasuryAmount);
505         swapableTreasuryTax      = swapableTreasuryTax + (treasuryAmount);
506         
507         if(_balances[sender] == 0) {
508             _claimableReflection[recipient] = 0; // claimable reflection amount initilize
509         }
510         
511         if (randomTaxType == 1) {
512             // true burn
513             _burn(sender, burnAmount); 
514             emit functionType(randomTaxType, sender, burnAmount);
515         } else if (randomTaxType == 2) {
516             // smart lp
517             _takeLP(sender, lpAmount); 
518             emit functionType(randomTaxType, sender, lpAmount);
519         } else if (randomTaxType == 3) {
520             // reflection adding
521             _balances[address(this)] = _balances[address(this)] + (reflectionAmount);
522             swapableRefection        = swapableRefection + (reflectionAmount);
523             totalReflected           = totalReflected + (reflectionAmount);
524             emit functionType(randomTaxType, sender, reflectionAmount);
525         }
526         emit Transfer(sender, recipient, amount);
527     }
528 
529     function _transferBothExcluded(address sender, address recipient, uint256 amount) private {
530         if(recipient == owner() || recipient == address(this)){
531             _balances[sender]    = _balances[sender] - amount;
532             _balances[recipient] = _balances[recipient] + amount;
533         } else {
534             _claimableReflection[recipient] = _claimableReflection[recipient] + unclaimedReflection(recipient); 
535             lastReflectionBasis[recipient]  = ethReflectionBasis;
536 
537             _balances[sender]    = _balances[sender] - amount;
538             _balances[recipient] = _balances[recipient] + amount;
539         }
540 
541         emit Transfer(sender, recipient, amount);
542     }
543 
544     function burn(uint256 amountTokens) public {
545         address sender = msg.sender;
546         require(_balances[sender] >= amountTokens, "ERC20: Burn Amount exceeds account balance");
547         require(amountTokens > 0, "ERC20: Enter some amount to burn");
548 
549         if (amountTokens > 0) {
550             _balances[sender] = _balances[sender] - amountTokens;
551             _burn(sender, amountTokens);
552         }
553     }
554 
555     function _burn(address from, uint256 amount) private {
556         _totalSupply = _totalSupply - amount;
557         totalBurned  = totalBurned + amount;
558         
559         emit Transfer(from, address(0), amount);
560     }
561 
562     function _takeLP(address from, uint256 tax) private {
563         if (tax > 0) {
564             (, , uint256 lp, ) = _getTaxAmount(tax);
565             _balances[lpPair]  = _balances[lpPair] + lp;
566             totalLP = totalLP + lp;
567 
568             emit Transfer(from, lpPair, lp);
569         }
570     }
571 
572     function addReflection() external payable {
573         require (msg.value > 0);
574         ethReflectionBasis = ethReflectionBasis + (msg.value);
575     }
576 
577     function isReflectionExcluded(address account) public view returns (bool) {
578         return _reflectionExcluded[account];
579     }
580 
581     function removeReflectionExcluded(address account) external onlyOwner {
582         require(isReflectionExcluded(account), "ERC20: Account must be excluded");
583 
584         _reflectionExcluded[account] = false;
585     }
586 
587     function addReflectionExcluded(address account) external onlyOwner {
588         _addReflectionExcluded(account);
589         emit reflectionExcluded(account);
590     }
591 
592     function _addReflectionExcluded(address account) internal {
593         require(!isReflectionExcluded(account), "ERC20: Account must not be excluded");
594         _reflectionExcluded[account] = true;
595     }
596 
597     function unclaimedReflection(address addr) public view returns (uint256) {
598         if (addr == lpPair || addr == address(dexRouter)) return 0;
599 
600         uint256 basisDifference = ethReflectionBasis - lastReflectionBasis[addr];
601         return ((basisDifference * balanceOf(addr)) / _totalSupply) + _claimableReflection[addr];
602     }
603 
604     function _claimReflection(address payable addr) internal {
605         uint256 unclaimed = unclaimedReflection(addr);
606         require(unclaimed > 0, "ERC20: Claim amount should be more then 0");
607         require(isReflectionExcluded(addr) == false, "ERC20: Address is excluded to claim reflection");
608         
609         lastReflectionBasis[addr] = ethReflectionBasis;
610         lastReflectionTimeStamp[addr] = block.timestamp; // adding last claim Timestamp
611         _claimableReflection[addr] = 0;
612         addr.transfer(unclaimed);
613         totalClaimedReflection[addr] = totalClaimedReflection[addr] + unclaimed;
614         emit reflectionClaimed(addr, unclaimed);
615     }
616 
617     function claimReflection() external returns (bool) {
618         address _sender = _msgSender();
619         require(!_isContract(_sender), "ERC20: Sender can't be a contract"); 
620         require(lastReflectionTimeStamp[_sender] + reflectionLockPeriod <= block.timestamp, "ERC20: Reflection lock period exists,  try again later");
621         _claimReflection(payable(_sender));
622         return true;
623     }
624 
625     function swapReflection(uint256 amount) public returns (bool) {
626         // everyone can call this function to generate eth reflection
627         require(swapableRefection > 0, "ERC20: Insufficient token to swap");
628         require(swapableRefection >= amount);
629         uint256 currentBalance = address(this).balance;
630         _swap(address(this), amount);
631         swapableRefection = swapableRefection - amount;
632         uint256 ethTransfer = (address(this).balance) - currentBalance;
633         ethReflectionBasis  = ethReflectionBasis + ethTransfer;
634         return true;
635     }
636 
637     function setMinTokensSwapAmount(uint256 newValue) external onlyOwner {
638         require(
639             newValue != minTokenSwapAmount,
640             "Cannot update minTokenSwapAmount to same value"
641         );
642         minTokenSwapAmount = newValue;
643     }
644 
645     function setsellTax(uint256 tax) public onlyOwner {
646         require(tax <= 6, "ERC20: The percentage can't more 6%.");
647         sellTax = tax;
648         emit sellTaxUpdated(tax);
649     }
650 
651     function setbuyTax(uint256 tax) public onlyOwner {
652         require(tax <= 6, "ERC20: The percentage can't more 6%.");
653         buyTax = tax;
654         emit buyTaxUpdated(tax);
655     }
656 
657     function setTaxSharePercentage(uint256 percentage) public onlyOwner {
658         require(percentage <= 100, "ERC20: The percentage can't more then 100");
659         taxSharePercentage = percentage;
660         emit taxSharePercentageUpdated(percentage);
661     }
662 
663     function enableTrading() external onlyOwner {
664         tradingActive = true;
665     }
666 
667     function addLpPair(address pair, bool status) public onlyOwner{
668         lpPairs[pair] = status;
669         _isExcludedFromTax[pair] = status;
670     }
671 
672     function returnNormalTax() public onlyOwner {
673         sellTax = 5;
674         buyTax  = 5;
675         taxSharePercentage = 50;
676     }
677 
678     function removeAllTax() public onlyOwner {
679         sellTax = 0;
680         buyTax  = 0;
681         taxSharePercentage = 0;
682     }
683 
684     function removeAllLimits() public onlyOwner {
685         isLimit = false;
686     }
687 
688     function excludeFromTax(address account) public onlyOwner {
689         require(!_isExcludedFromTax[account], "ERC20: Account is already excluded.");
690         _isExcludedFromTax[account] = true;
691         emit excludedFromTaxes(account);
692     }
693 
694     function includeInTax(address _account) public onlyOwner {
695         require(_isExcludedFromTax[_account], "ERC20: Account is already included.");
696         _isExcludedFromTax[_account] = false;
697         emit includeInTaxes(_account);
698     }
699     
700     function recoverAllEth() public {
701         (bool success, ) = address(treasuryWallet).call{value: address(this).balance}("");
702         if (success) {
703             emit recoverAllEths(address(this).balance);
704         }
705     }
706 
707     function recoverErc20token(address token, uint256 amount) public onlyOwner {
708         require(token != address(this),"can't claim own tokens");
709         IERC20(token).transfer(owner(), amount);
710         emit recoverERC20Tokens(token, amount);
711     }
712 
713     function checkExludedFromTax(address _account) public view returns (bool) {
714         return _isExcludedFromTax[_account];
715     }
716 
717     function _generateRandomTaxType() private view returns (uint256) {
718         return (uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, block.gaslimit, tx.origin, block.number, tx.gasprice))) % 3) + 1;
719     }
720 
721     function _getTaxAmount(uint256 _tax) private view returns (uint256 _treasuryAmount, uint256 Burn, uint256 LP, uint256 Reflection) {
722         uint256 treasuryAmount;
723         uint256 burnAmount;
724         uint256 lpAmount;
725         uint256 reflectionAmount;
726 
727         if (_tax > 0) {
728             treasuryAmount = _tax * ((100 - taxSharePercentage))/100;
729             burnAmount = _tax * (taxSharePercentage)/100;
730             lpAmount = _tax * (taxSharePercentage)/100;
731             reflectionAmount = _tax * (taxSharePercentage)/100;
732         }
733         return (treasuryAmount, burnAmount, lpAmount, reflectionAmount);
734     }
735 
736     function _checkWalletLimit(address recipient, uint256 amount) private view returns(bool){
737         if (isLimit) {
738         require(maxWalletLimit >= balanceOf(recipient) + amount, "ERC20: Wallet limit exceeds");
739         }
740         return true;
741     }
742 
743     function _checkTxLimit(uint256 amount) private view returns(bool){
744         if (isLimit) {
745         require(amount <= maxTxLimit, "ERC20: Transaction limit exceeds");
746         }
747         return true;
748     }
749 
750     function _isContract(address _addr) private view returns (bool){
751         uint32 size;
752         assembly {
753             size := extcodesize(_addr)
754         }
755         return (size > 0);
756     }
757 
758     function _swap(address recipient, uint256 amount) private {
759         address[] memory path = new address[](2);
760         path[0] = address(this);
761         path[1] = dexRouter.WETH();
762 
763         dexRouter.swapExactTokensForETH(
764             amount,
765             0,
766             path,
767             recipient,
768             block.timestamp
769         );
770     }
771 }