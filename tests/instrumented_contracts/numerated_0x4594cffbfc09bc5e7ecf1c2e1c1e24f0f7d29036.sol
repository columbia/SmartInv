1 /*
2 _____/\\\\\\\_______________/\\\________/\\\____________/\\\\\_____/\\\_        
3  ___/\\\/////\\\____________\/\\\_____/\\\//____________\/\\\\\\___\/\\\_       
4   __/\\\____\//\\\___________\/\\\__/\\\//_______________\/\\\/\\\__\/\\\_      
5    _\/\\\_____\/\\\___________\/\\\\\\//\\\_______________\/\\\//\\\_\/\\\_     
6     _\/\\\_____\/\\\___________\/\\\//_\//\\\______________\/\\\\//\\\\/\\\_    
7      _\/\\\_____\/\\\___________\/\\\____\//\\\_____________\/\\\_\//\\\/\\\_   
8       _\//\\\____/\\\____________\/\\\_____\//\\\____________\/\\\__\//\\\\\\_  
9        __\///\\\\\\\/_____________\/\\\______\//\\\___________\/\\\___\//\\\\\_ 
10         ____\///////_______________\///________\///____________\///_____\/////__
11 */
12 // SPDX-License-Identifier:MIT
13 pragma solidity 0.8.18;
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24 
25     function allowance(
26         address owner,
27         address spender
28     ) external view returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     event Approval(
41         address indexed owner,
42         address indexed spender,
43         uint256 value
44     );
45 }
46 
47 // Dex Factory contract interface
48 interface IDexFactory {
49     function createPair(
50         address tokenA,
51         address tokenB
52     ) external returns (address pair);
53 }
54 
55 // Dex Router contract interface
56 interface IDexRouter {
57     function factory() external pure returns (address);
58 
59     function WETH() external pure returns (address);
60 
61     function addLiquidityETH(
62         address token,
63         uint256 amountTokenDesired,
64         uint256 amountTokenMin,
65         uint256 amountETHMin,
66         address to,
67         uint256 deadline
68     )
69         external
70         payable
71         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
72 
73     function swapExactTokensForETHSupportingFeeOnTransferTokens(
74         uint256 amountIn,
75         uint256 amountOutMin,
76         address[] calldata path,
77         address to,
78         uint256 deadline
79     ) external;
80 }
81 
82 abstract contract Context {
83     function _msgSender() internal view virtual returns (address payable) {
84         return payable(msg.sender);
85     }
86 
87     function _msgData() internal view virtual returns (bytes memory) {
88         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
89         return msg.data;
90     }
91 }
92 
93 contract Ownable is Context {
94     address private _owner;
95 
96     event OwnershipTransferred(
97         address indexed previousOwner,
98         address indexed newOwner
99     );
100 
101     constructor() {
102         _owner = _msgSender();
103         emit OwnershipTransferred(address(0), _owner);
104     }
105 
106     function owner() public view returns (address) {
107         return _owner;
108     }
109 
110     modifier onlyOwner() {
111         require(_owner == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     function renounceOwnership() public virtual onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = payable(address(0));
118     }
119 
120     function transferOwnership(address newOwner) public virtual onlyOwner {
121         require(
122             newOwner != address(0),
123             "Ownable: new owner is the zero address"
124         );
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128 }
129 
130 abstract contract ReentrancyGuard {
131     // Booleans are more expensive than uint256 or any type that takes up a full
132     // word because each write operation emits an extra SLOAD to first read the
133     // slot's contents, replace the bits taken up by the boolean, and then write
134     // back. This is the compiler's defense against contract upgrades and
135     // pointer aliasing, and it cannot be disabled.
136 
137     // The values being non-zero value makes deployment a bit more expensive,
138     // but in exchange the refund on every call to nonReentrant will be lower in
139     // amount. Since refunds are capped to a percentage of the total
140     // transaction's gas, it is best to keep them low in cases like this one, to
141     // increase the likelihood of the full refund coming into effect.
142     uint256 private constant _NOT_ENTERED = 1;
143     uint256 private constant _ENTERED = 2;
144 
145     uint256 private _status;
146 
147     /**
148      * @dev Unauthorized reentrant call.
149      */
150     error ReentrancyGuardReentrantCall();
151 
152     constructor() {
153         _status = _NOT_ENTERED;
154     }
155 
156     /**
157      * @dev Prevents a contract from calling itself, directly or indirectly.
158      * Calling a `nonReentrant` function from another `nonReentrant`
159      * function is not supported. It is possible to prevent this from happening
160      * by making the `nonReentrant` function external, and making it call a
161      * `private` function that does the actual work.
162      */
163     modifier nonReentrant() {
164         _nonReentrantBefore();
165         _;
166         _nonReentrantAfter();
167     }
168 
169     function _nonReentrantBefore() private {
170         // On the first call to nonReentrant, _status will be _NOT_ENTERED
171         if (_status == _ENTERED) {
172             revert ReentrancyGuardReentrantCall();
173         }
174 
175         // Any calls to nonReentrant after this point will fail
176         _status = _ENTERED;
177     }
178 
179     function _nonReentrantAfter() private {
180         // By storing the original value once again, a refund is triggered (see
181         // https://eips.ethereum.org/EIPS/eip-2200)
182         _status = _NOT_ENTERED;
183     }
184 
185     /**
186      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
187      * `nonReentrant` function in the call stack.
188      */
189     function _reentrancyGuardEntered() internal view returns (bool) {
190         return _status == _ENTERED;
191     }
192 }
193 
194 contract ZeroKnowledgeNetwork is Context, IERC20, Ownable, ReentrancyGuard {
195     mapping(address => uint256) private _balances;
196     mapping(address => mapping(address => uint256)) private _allowances;
197 
198     mapping(address => bool) public isExcludedFromFee;
199     mapping(address => bool) public isExcludedFromMaxHolding;
200 
201     string private _name = "Zero Knowledge Network";
202     string private _symbol = "0KN";
203     uint8 private _decimals = 18;
204     uint256 private _totalSupply = 10_000_000_000 * 1e18; //10 Billion
205 
206     uint256 public minTokenToSwap = _totalSupply / (5000); // this amount will trigger swap and distribute
207     uint256 public maxHoldLimit = (_totalSupply * 5) / 100; // this is the max wallet holding limit
208     uint256 public percentDivider = 100;
209 
210     bool public distributeAndLiquifyStatus = true; // should be true to turn on to liquidate the pool
211     bool public feesStatus = true; // enable by default
212 
213     IDexRouter public dexRouter; // router declaration
214 
215     address public dexPair; // pair address declaration
216     address public OKNTreasuryWallet;
217     address public NodeOperatorRewards =
218         address(0x8bc9063Ca5a59C6FE79c7114916804ae01806d74);
219     address public Seed = address(0xA321B6EdB7f1ae58eA3b494b98917BDAe30cd262);
220     address public Team = address(0x041c89471163B034c302624785438C1E2493Adf8);
221     address public Marketing =
222         address(0x05DB6Dd90464192385Dc4121E39A14B453484De4);
223 
224     address private constant DEAD = address(0xdead);
225     address private constant ZERO = address(0);
226 
227     uint256 public OKNTreasuryFeeOnBuy = 0;
228 
229     uint256 public OKNTreasuryFeeOnSell = 0;
230 
231     event TransferForeignToken(address token, uint256 amount);
232     event ExcludeFromFees(address indexed account, bool isExcluded);
233     event ExcludeFromMaxHolding(address indexed account, bool isExcluded);
234     event UpdatedMaxWalletAmount(uint256 newAmount);
235     event NewSwapAmount(uint256 newAmount);
236     event DistributionStatus(bool Status);
237     event FeeStatus(bool Status);
238     event FeeUpdated(uint256 amount);
239 
240     event OKNTreasuryWalletUpdated(
241         address indexed newWallet,
242         address indexed oldWallet
243     );
244 
245     event SwapAndLiquify(
246         uint256 tokensSwapped,
247         uint256 ethReceived,
248         uint256 tokensIntoLiqudity
249     );
250 
251     constructor() {
252         _balances[NodeOperatorRewards] = (_totalSupply * 30) / 100; //30%
253         _balances[Seed] = (_totalSupply * 10) / 100; //10%
254         _balances[Team] = (_totalSupply * 5) / 100; //5%
255         _balances[Marketing] = (_totalSupply * 10) / 100; //10%
256         _balances[owner()] = (_totalSupply * 45) / 100; //45%
257 
258         OKNTreasuryWallet = address(0x05DB6Dd90464192385Dc4121E39A14B453484De4);
259 
260         IDexRouter _dexRouter = IDexRouter(
261             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
262         );
263         // Create a dex pair for this new ERC20
264         address _dexPair = IDexFactory(_dexRouter.factory()).createPair(
265             address(this),
266             _dexRouter.WETH()
267         );
268         dexPair = _dexPair;
269 
270         // set the rest of the contract variables
271         dexRouter = _dexRouter;
272 
273         //exclude owner and this contract from fee
274         isExcludedFromFee[owner()] = true;
275         isExcludedFromFee[address(this)] = true;
276         isExcludedFromFee[address(dexRouter)] = true;
277         isExcludedFromFee[
278             address(0x71B5759d73262FBb223956913ecF4ecC51057641)
279         ] = true; // Pink Lock
280 
281         //exclude owner and this contract from max hold limit
282         isExcludedFromMaxHolding[owner()] = true;
283         isExcludedFromMaxHolding[address(this)] = true;
284         isExcludedFromMaxHolding[address(dexRouter)] = true;
285         isExcludedFromMaxHolding[dexPair] = true;
286         isExcludedFromMaxHolding[
287             address(0x71B5759d73262FBb223956913ecF4ecC51057641)
288         ] = true; // Pink Lock
289 
290         emit Transfer(
291             address(0),
292             NodeOperatorRewards,
293             (_totalSupply * 30) / 100
294         );
295         emit Transfer(address(0), Seed, (_totalSupply * 10) / 100);
296         emit Transfer(address(0), Team, (_totalSupply * 5) / 100);
297         emit Transfer(address(0), Marketing, (_totalSupply * 10) / 100);
298         emit Transfer(address(0), owner(), (_totalSupply * 45) / 100);
299     }
300 
301     //to receive ETH from dexRouter when swapping
302     receive() external payable {}
303 
304     function name() public view returns (string memory) {
305         return _name;
306     }
307 
308     function symbol() public view returns (string memory) {
309         return _symbol;
310     }
311 
312     function decimals() public view returns (uint8) {
313         return _decimals;
314     }
315 
316     function totalSupply() public view override returns (uint256) {
317         return _totalSupply;
318     }
319 
320     function balanceOf(address account) public view override returns (uint256) {
321         return _balances[account];
322     }
323 
324     function transfer(
325         address recipient,
326         uint256 amount
327     ) public override returns (bool) {
328         _transfer(_msgSender(), recipient, amount);
329         return true;
330     }
331 
332     function allowance(
333         address owner,
334         address spender
335     ) public view override returns (uint256) {
336         return _allowances[owner][spender];
337     }
338 
339     function approve(
340         address spender,
341         uint256 amount
342     ) public override returns (bool) {
343         _approve(_msgSender(), spender, amount);
344         return true;
345     }
346 
347     function transferFrom(
348         address sender,
349         address recipient,
350         uint256 amount
351     ) public override returns (bool) {
352         _transfer(sender, recipient, amount);
353         _approve(
354             sender,
355             _msgSender(),
356             _allowances[sender][_msgSender()] - amount
357         );
358         return true;
359     }
360 
361     function increaseAllowance(
362         address spender,
363         uint256 addedValue
364     ) public virtual returns (bool) {
365         _approve(
366             _msgSender(),
367             spender,
368             _allowances[_msgSender()][spender] + (addedValue)
369         );
370         return true;
371     }
372 
373     function decreaseAllowance(
374         address spender,
375         uint256 subtractedValue
376     ) public virtual returns (bool) {
377         _approve(
378             _msgSender(),
379             spender,
380             _allowances[_msgSender()][spender] - subtractedValue
381         );
382         return true;
383     }
384 
385     function includeOrExcludeFromFee(
386         address account,
387         bool value
388     ) external onlyOwner {
389         isExcludedFromFee[account] = value;
390         emit ExcludeFromFees(account, value);
391     }
392 
393     function includeOrExcludeFromMaxHolding(
394         address account,
395         bool value
396     ) external onlyOwner {
397         isExcludedFromMaxHolding[account] = value;
398         emit ExcludeFromMaxHolding(account, value);
399     }
400 
401     function setMinTokenToSwap(uint256 _amount) external onlyOwner {
402         require(_amount > 0, "min swap amount should be greater than zero");
403         minTokenToSwap = _amount * 1e18;
404         emit NewSwapAmount(minTokenToSwap);
405     }
406 
407     function setMaxHoldLimit(uint256 _amount) external onlyOwner {
408         require(
409             _amount >= ((totalSupply() * 5) / 1000) / 1e18,
410             "Cannot set max wallet amount lower than 0.5%"
411         );
412         maxHoldLimit = _amount * 1e18;
413         emit UpdatedMaxWalletAmount(maxHoldLimit);
414     }
415 
416     function setBuyFeePercent(uint256 _OKNTreasuryFee) external onlyOwner {
417         require(_OKNTreasuryFee <= 10, "max buy fee is 10");
418         OKNTreasuryFeeOnBuy = _OKNTreasuryFee;
419         emit FeeUpdated(OKNTreasuryFeeOnBuy);
420     }
421 
422     function setSellFeePercent(uint256 _OKNTreasuryFee) external onlyOwner {
423         require(_OKNTreasuryFee <= 10, "max sell fee is 10");
424         OKNTreasuryFeeOnSell = _OKNTreasuryFee;
425         emit FeeUpdated(OKNTreasuryFeeOnSell);
426     }
427 
428     function setDistributionStatus(bool _value) external onlyOwner {
429         // Check if the new value is different from the current state
430         require(
431             _value != distributeAndLiquifyStatus,
432             "Value must be different from current state"
433         );
434         distributeAndLiquifyStatus = _value;
435         emit DistributionStatus(_value);
436     }
437 
438     function enableOrDisableFees(bool _value) external onlyOwner {
439         // Check if the new value is different from the current state
440         require(
441             _value != feesStatus,
442             "Value must be different from current state"
443         );
444         feesStatus = _value;
445         emit FeeStatus(_value);
446     }
447 
448     function updateOKNTreasuryWallet(
449         address newOKNTreasuryWallet
450     ) external onlyOwner {
451         require(
452             newOKNTreasuryWallet != address(0),
453             "Ownable: new OKNTreasuryWallet is the zero address"
454         );
455         emit OKNTreasuryWalletUpdated(newOKNTreasuryWallet, OKNTreasuryWallet);
456         OKNTreasuryWallet = newOKNTreasuryWallet;
457     }
458 
459     function totalBuyFeePerTx(uint256 amount) public view returns (uint256) {
460         uint256 fee = (amount * OKNTreasuryFeeOnBuy) / percentDivider;
461         return fee;
462     }
463 
464     function totalSellFeePerTx(uint256 amount) public view returns (uint256) {
465         uint256 fee = (amount * OKNTreasuryFeeOnSell) / percentDivider;
466         return fee;
467     }
468 
469     function _approve(address owner, address spender, uint256 amount) private {
470         require(owner != address(0), "0KN: approve from the zero address");
471         require(spender != address(0), "0KN: approve to the zero address");
472 
473         _allowances[owner][spender] = amount;
474         emit Approval(owner, spender, amount);
475     }
476 
477     function _transfer(address from, address to, uint256 amount) private {
478         require(from != address(0), "0KN: transfer from the zero address");
479         require(to != address(0), "0KN: transfer to the zero address");
480         require(amount > 0, "0KN: Amount must be greater than zero");
481 
482         if (!isExcludedFromMaxHolding[to]) {
483             require(
484                 balanceOf(to) + amount <= maxHoldLimit,
485                 "0KN: max hold limit exceeds"
486             );
487         }
488 
489         // swap and liquify
490         distributeAndLiquify(from, to);
491 
492         //indicates if fee should be deducted from transfer
493         bool takeFee = true;
494 
495         //if any account belongs to isExcludedFromFee account then remove the fee
496         if (isExcludedFromFee[from] || isExcludedFromFee[to] || !feesStatus) {
497             takeFee = false;
498         }
499 
500         //transfer amount, it will take tax, burn, liquidity fee
501         _tokenTransfer(from, to, amount, takeFee);
502     }
503 
504     //this method is responsible for taking all fee, if takeFee is true
505     function _tokenTransfer(
506         address sender,
507         address recipient,
508         uint256 amount,
509         bool takeFee
510     ) private {
511         if (dexPair == sender && takeFee) {
512             uint256 allFee;
513             uint256 tTransferAmount;
514             allFee = totalBuyFeePerTx(amount);
515             tTransferAmount = amount - allFee;
516 
517             _balances[sender] = _balances[sender] - amount;
518             _balances[recipient] = _balances[recipient] + tTransferAmount;
519             emit Transfer(sender, recipient, tTransferAmount);
520 
521             takeTokenFee(sender, allFee);
522         } else if (dexPair == recipient && takeFee) {
523             uint256 allFee = totalSellFeePerTx(amount);
524             uint256 tTransferAmount = amount - allFee;
525             _balances[sender] = _balances[sender] - amount;
526             _balances[recipient] = _balances[recipient] + tTransferAmount;
527             emit Transfer(sender, recipient, tTransferAmount);
528 
529             takeTokenFee(sender, allFee);
530         } else {
531             _balances[sender] = _balances[sender] - amount;
532             _balances[recipient] = _balances[recipient] + (amount);
533             emit Transfer(sender, recipient, amount);
534         }
535     }
536 
537     function takeTokenFee(address sender, uint256 amount) private {
538         _balances[address(this)] = _balances[address(this)] + amount;
539 
540         emit Transfer(sender, address(this), amount);
541     }
542 
543     // to withdarw ETH from contract
544     function withdrawETH(uint256 _amount) external onlyOwner {
545         require(address(this).balance >= _amount, "Invalid Amount");
546         payable(msg.sender).transfer(_amount);
547 
548         emit Transfer(address(this), msg.sender, _amount);
549     }
550 
551     function distributeAndLiquify(address from, address to) private {
552         uint256 contractTokenBalance = balanceOf(address(this));
553 
554         if (
555             contractTokenBalance >= minTokenToSwap &&
556             from != dexPair &&
557             distributeAndLiquifyStatus &&
558             !(from == address(this) && to == dexPair) // swap 1 time
559         ) {
560             // approve contract
561             _approve(address(this), address(dexRouter), minTokenToSwap);
562 
563             // now is to lock into liquidty pool
564             Utils.swapTokensForEth(address(dexRouter), minTokenToSwap);
565             uint256 ethForMarketing = address(this).balance;
566 
567             // sending Eth to Marketing wallet
568             if (ethForMarketing > 0)
569                 payable(OKNTreasuryWallet).transfer(ethForMarketing);
570         }
571     }
572 }
573 
574 // Library for doing a swap on Dex
575 library Utils {
576     function swapTokensForEth(
577         address routerAddress,
578         uint256 tokenAmount
579     ) internal {
580         IDexRouter dexRouter = IDexRouter(routerAddress);
581 
582         // generate the Dex pair path of token -> weth
583         address[] memory path = new address[](2);
584         path[0] = address(this);
585         path[1] = dexRouter.WETH();
586 
587         // make the swap
588         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
589             tokenAmount,
590             0, // accept any amount of ETH
591             path,
592             address(this),
593             block.timestamp + 300
594         );
595     }
596 }