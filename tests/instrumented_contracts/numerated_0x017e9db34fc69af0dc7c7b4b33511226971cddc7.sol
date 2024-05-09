1 /*
2  ██████╗ ███╗   ██╗       ██████╗██╗  ██╗ █████╗ ██╗███╗   ██╗    ██████╗ ██╗   ██╗███╗   ██╗ █████╗ ███╗   ███╗██╗ ██████╗███████╗
3 ██╔═══██╗████╗  ██║      ██╔════╝██║  ██║██╔══██╗██║████╗  ██║    ██╔══██╗╚██╗ ██╔╝████╗  ██║██╔══██╗████╗ ████║██║██╔════╝██╔════╝
4 ██║   ██║██╔██╗ ██║█████╗██║     ███████║███████║██║██╔██╗ ██║    ██║  ██║ ╚████╔╝ ██╔██╗ ██║███████║██╔████╔██║██║██║     ███████╗
5 ██║   ██║██║╚██╗██║╚════╝██║     ██╔══██║██╔══██║██║██║╚██╗██║    ██║  ██║  ╚██╔╝  ██║╚██╗██║██╔══██║██║╚██╔╝██║██║██║     ╚════██║
6 ╚██████╔╝██║ ╚████║      ╚██████╗██║  ██║██║  ██║██║██║ ╚████║    ██████╔╝   ██║   ██║ ╚████║██║  ██║██║ ╚═╝ ██║██║╚██████╗███████║
7  ╚═════╝ ╚═╝  ╚═══╝       ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    ╚═════╝    ╚═╝   ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝ ╚═════╝╚══════╝
8                                                               OCD                                                                     
9 */
10 // SPDX-License-Identifier:MIT
11 pragma solidity 0.8.18;
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address account) external view returns (uint256);
17 
18     function transfer(
19         address recipient,
20         uint256 amount
21     ) external returns (bool);
22 
23     function allowance(
24         address owner,
25         address spender
26     ) external view returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44 
45 // Dex Factory contract interface
46 interface IDexFactory {
47     function createPair(
48         address tokenA,
49         address tokenB
50     ) external returns (address pair);
51 }
52 
53 // Dex Router contract interface
54 interface IDexRouter {
55     function factory() external pure returns (address);
56 
57     function WETH() external pure returns (address);
58 
59     function addLiquidityETH(
60         address token,
61         uint256 amountTokenDesired,
62         uint256 amountTokenMin,
63         uint256 amountETHMin,
64         address to,
65         uint256 deadline
66     )
67         external
68         payable
69         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
70 
71     function swapExactTokensForETHSupportingFeeOnTransferTokens(
72         uint256 amountIn,
73         uint256 amountOutMin,
74         address[] calldata path,
75         address to,
76         uint256 deadline
77     ) external;
78 }
79 
80 abstract contract Context {
81     function _msgSender() internal view virtual returns (address payable) {
82         return payable(msg.sender);
83     }
84 
85     function _msgData() internal view virtual returns (bytes memory) {
86         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
87         return msg.data;
88     }
89 }
90 
91 contract Ownable is Context {
92     address private _owner;
93 
94     event OwnershipTransferred(
95         address indexed previousOwner,
96         address indexed newOwner
97     );
98 
99     constructor() {
100         _owner = _msgSender();
101         emit OwnershipTransferred(address(0), _owner);
102     }
103 
104     function owner() public view returns (address) {
105         return _owner;
106     }
107 
108     modifier onlyOwner() {
109         require(_owner == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     function renounceOwnership() public virtual onlyOwner {
114         emit OwnershipTransferred(_owner, address(0));
115         _owner = payable(address(0));
116     }
117 
118     function transferOwnership(address newOwner) public virtual onlyOwner {
119         require(
120             newOwner != address(0),
121             "Ownable: new owner is the zero address"
122         );
123         emit OwnershipTransferred(_owner, newOwner);
124         _owner = newOwner;
125     }
126 }
127 
128 abstract contract ReentrancyGuard {
129     uint256 private constant _NOT_ENTERED = 1;
130     uint256 private constant _ENTERED = 2;
131 
132     uint256 private _status;
133 
134     /**
135      * @dev Unauthorized reentrant call.
136      */
137     error ReentrancyGuardReentrantCall();
138 
139     constructor() {
140         _status = _NOT_ENTERED;
141     }
142 
143     modifier nonReentrant() {
144         _nonReentrantBefore();
145         _;
146         _nonReentrantAfter();
147     }
148 
149     function _nonReentrantBefore() private {
150         // On the first call to nonReentrant, _status will be _NOT_ENTERED
151         if (_status == _ENTERED) {
152             revert ReentrancyGuardReentrantCall();
153         }
154 
155         // Any calls to nonReentrant after this point will fail
156         _status = _ENTERED;
157     }
158 
159     function _nonReentrantAfter() private {
160         _status = _NOT_ENTERED;
161     }
162 
163     function _reentrancyGuardEntered() internal view returns (bool) {
164         return _status == _ENTERED;
165     }
166 }
167 
168 // Library dex swap
169 library Utils {
170     function swapTokensForEth(
171         address routerAddress,
172         uint256 tokenAmount
173     ) internal {
174         IDexRouter dexRouter = IDexRouter(routerAddress);
175 
176         // generate the Dex pair path of token -> weth
177         address[] memory path = new address[](2);
178         path[0] = address(this);
179         path[1] = dexRouter.WETH();
180 
181         // make the swap
182         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
183             tokenAmount,
184             0, // accept any amount of ETH
185             path,
186             address(this),
187             block.timestamp + 300
188         );
189     }
190 }
191 
192 //On-Chain Dynamics $OCD
193 
194 contract OCD is Context, IERC20, Ownable, ReentrancyGuard {
195     mapping(address => uint256) private _balances;
196     mapping(address => mapping(address => uint256)) private _allowances;
197 
198     mapping(address => bool) public isExcludedFromFee;
199 
200     string private _name = "On-Chain Dynamics";
201     string private _symbol = "OCD";
202     uint8 private _decimals = 18;
203     uint256 private _totalSupply = 1_000_000_000 * 1e18; //1 Billion
204 
205     uint256 public minSwapAmount = _totalSupply / (2000);
206     uint256 public percentDivider = 100;
207 
208     bool public distributeAndLiquifyStatus = true; 
209     bool public feesStatus = true; // enable by default
210 
211     IDexRouter public dexRouter; //Uniswap  router declaration
212 
213     address public dexPair; //Uniswap  pair address declaration
214     address public marketWallet;
215 
216     address private constant DEAD = address(0xdead);
217 
218     uint256 public marketFeeOnBuy = 0;
219 
220     uint256 public marketFeeOnSell = 0;
221 
222     event ExcludeFromFee(address indexed account, bool isExcluded);
223     event NewSwapAmount(uint256 newAmount);
224     event DistributionStatus(bool Status);
225     event FeeStatus(bool Status);
226     event FeeUpdated(uint256 amount);
227 
228     event marketWalletUpdated(
229         address indexed newWallet,
230         address indexed oldWallet
231     );
232 
233     event SwapAndLiquify(
234         uint256 tokensSwapped,
235         uint256 ethReceived,
236         uint256 tokensIntoLiqudity
237     );
238 
239     constructor() {
240         _balances[
241             address(0xeCAB3064B0FCa52fdcc8422280a927EF8f51fE8D)
242         ] = _totalSupply; // Deployer
243 
244         marketWallet = address(0xdBBa71D308125218B1cD0fa4f93662EbDc28b43D); //Marketing & Development
245 
246         IDexRouter _dexRouter = IDexRouter(
247             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
248         );
249         // Create a dex pair for this new ERC20
250         address _dexPair = IDexFactory(_dexRouter.factory()).createPair(
251             address(this),
252             _dexRouter.WETH()
253         );
254         dexPair = _dexPair;
255 
256         // set the rest of the contract variables
257         dexRouter = _dexRouter;
258 
259         //exclude owner and this contract from fee
260         isExcludedFromFee[owner()] = true;
261         isExcludedFromFee[address(this)] = true;
262         isExcludedFromFee[address(dexRouter)] = true;
263         isExcludedFromFee[
264             address(0x71B5759d73262FBb223956913ecF4ecC51057641)
265         ] = true; // Pinklock
266 
267         emit Transfer(
268             address(0),
269             address(0xeCAB3064B0FCa52fdcc8422280a927EF8f51fE8D),
270             _totalSupply
271         );
272     }
273 
274     //////////////////////////////////////////////////////////////////////////////////////////////////////////////
275     //Ownable functions
276 
277     function setIncludeOrExcludeFromFee(
278         address account,
279         bool value
280     ) external onlyOwner {
281         isExcludedFromFee[account] = value;
282         emit ExcludeFromFee(account, value);
283     }
284 
285     function updateSwapAmount(uint256 _amount) external onlyOwner {
286         require(_amount > 0, "min swap amount should be greater than zero");
287         minSwapAmount = _amount * 1e18;
288         emit NewSwapAmount(minSwapAmount);
289     }
290 
291     function updateBuyFee(uint256 _marketFee) external onlyOwner {
292         require(_marketFee <= 10, "max buy fee is 10");
293         marketFeeOnBuy = _marketFee;
294         emit FeeUpdated(marketFeeOnBuy);
295     }
296 
297     function updateSellFee(uint256 _marketFee) external onlyOwner {
298         require(_marketFee <= 10, "max sell fee is 10");
299         marketFeeOnSell = _marketFee;
300         emit FeeUpdated(marketFeeOnSell);
301     }
302 
303     function setDistributionStatus(bool _value) external onlyOwner {
304         // Check if the new value is different from the current state
305         require(
306             _value != distributeAndLiquifyStatus,
307             "Value must be different from current state"
308         );
309         distributeAndLiquifyStatus = _value;
310         emit DistributionStatus(_value);
311     }
312 
313     function enableOrDisableFees(bool _value) external onlyOwner {
314         // Check if the new value is different from the current state
315         require(
316             _value != feesStatus,
317             "Value must be different from current state"
318         );
319         feesStatus = _value;
320         emit FeeStatus(_value);
321     }
322 
323     function updatemarketWallet(address newmarketWallet) external onlyOwner {
324         require(
325             newmarketWallet != address(0),
326             "Ownable: new marketWallet is the zero address"
327         );
328         emit marketWalletUpdated(newmarketWallet, marketWallet);
329         marketWallet = newmarketWallet;
330     }
331 
332     //////////////////////////////////////////////////////////////////////////////////////////////////////////////
333 
334     //to receive ETH from dexRouter when swapping
335     receive() external payable {}
336 
337     //////////////////////////////////////////////////////////////////////////////////////////////////////////////
338     // Public viewable functions
339 
340     function name() public view returns (string memory) {
341         return _name;
342     }
343 
344     function symbol() public view returns (string memory) {
345         return _symbol;
346     }
347 
348     function decimals() public view returns (uint8) {
349         return _decimals;
350     }
351 
352     function totalSupply() public view override returns (uint256) {
353         return _totalSupply;
354     }
355 
356     function balanceOf(address account) public view override returns (uint256) {
357         return _balances[account];
358     }
359 
360     function transfer(
361         address recipient,
362         uint256 amount
363     ) public override returns (bool) {
364         _transfer(_msgSender(), recipient, amount);
365         return true;
366     }
367 
368     function allowance(
369         address owner,
370         address spender
371     ) public view override returns (uint256) {
372         return _allowances[owner][spender];
373     }
374 
375     function approve(
376         address spender,
377         uint256 amount
378     ) public override returns (bool) {
379         _approve(_msgSender(), spender, amount);
380         return true;
381     }
382 
383     function transferFrom(
384         address sender,
385         address recipient,
386         uint256 amount
387     ) public override returns (bool) {
388         _transfer(sender, recipient, amount);
389         _approve(
390             sender,
391             _msgSender(),
392             _allowances[sender][_msgSender()] - amount
393         );
394         return true;
395     }
396 
397     function increaseAllowance(
398         address spender,
399         uint256 addedValue
400     ) public virtual returns (bool) {
401         _approve(
402             _msgSender(),
403             spender,
404             _allowances[_msgSender()][spender] + (addedValue)
405         );
406         return true;
407     }
408 
409     function decreaseAllowance(
410         address spender,
411         uint256 subtractedValue
412     ) public virtual returns (bool) {
413         _approve(
414             _msgSender(),
415             spender,
416             _allowances[_msgSender()][spender] - subtractedValue
417         );
418         return true;
419     }
420 
421     function totalBuyFeePerTx(uint256 amount) public view returns (uint256) {
422         uint256 fee = (amount * marketFeeOnBuy) / percentDivider;
423         return fee;
424     }
425 
426     function totalSellFeePerTx(uint256 amount) public view returns (uint256) {
427         uint256 fee = (amount * marketFeeOnSell) / percentDivider;
428         return fee;
429     }
430 
431     //////////////////////////////////////////////////////////////////////////////////////////////////////////////
432 
433     function _approve(address owner, address spender, uint256 amount) private {
434         require(owner != address(0), "OCD: approve from the zero address");
435         require(spender != address(0), "OCD: approve to the zero address");
436 
437         _allowances[owner][spender] = amount;
438         emit Approval(owner, spender, amount);
439     }
440 
441     function _transfer(address from, address to, uint256 amount) private {
442         require(from != address(0), "OCD: transfer from the zero address");
443         require(to != address(0), "OCD: transfer to the zero address");
444         require(amount > 0, "OCD: Amount must be greater than zero");
445 
446         // swap and liquify
447         distributeAndLiquify(from, to);
448 
449         //indicates if fee should be deducted from transfer
450         bool takeFee = true;
451 
452         //if any account belongs to isExcludedFromFee account then remove the fee
453         if (isExcludedFromFee[from] || isExcludedFromFee[to] || !feesStatus) {
454             takeFee = false;
455         }
456 
457         //transfer amount, it will take tax, burn, liquidity fee
458         _tokenTransfer(from, to, amount, takeFee);
459     }
460 
461     //this method is responsible for processing all fee, if takeFee is true
462     function _tokenTransfer(
463         address sender,
464         address recipient,
465         uint256 amount,
466         bool takeFee
467     ) private {
468         if (dexPair == sender && takeFee) {
469             uint256 allFee;
470             uint256 tTransferAmount;
471             allFee = totalBuyFeePerTx(amount);
472             tTransferAmount = amount - allFee;
473 
474             _balances[sender] = _balances[sender] - amount;
475             _balances[recipient] = _balances[recipient] + tTransferAmount;
476             emit Transfer(sender, recipient, tTransferAmount);
477 
478             takeTokenFee(sender, allFee);
479         } else if (dexPair == recipient && takeFee) {
480             uint256 allFee = totalSellFeePerTx(amount);
481             uint256 tTransferAmount = amount - allFee;
482             _balances[sender] = _balances[sender] - amount;
483             _balances[recipient] = _balances[recipient] + tTransferAmount;
484             emit Transfer(sender, recipient, tTransferAmount);
485 
486             takeTokenFee(sender, allFee);
487         } else {
488             _balances[sender] = _balances[sender] - amount;
489             _balances[recipient] = _balances[recipient] + (amount);
490             emit Transfer(sender, recipient, amount);
491         }
492     }
493 
494     function takeTokenFee(address sender, uint256 amount) private {
495         _balances[address(this)] = _balances[address(this)] + amount;
496 
497         emit Transfer(sender, address(this), amount);
498     }
499 
500     // to withdarw ETH from contract
501     function withdrawETH(uint256 _amount) external onlyOwner {
502         require(address(this).balance >= _amount, "Invalid Amount");
503         payable(msg.sender).transfer(_amount);
504 
505         emit Transfer(address(this), msg.sender, _amount);
506     }
507 
508     function distributeAndLiquify(address from, address to) private {
509         uint256 contractTokenBalance = balanceOf(address(this));
510 
511         if (
512             contractTokenBalance >= minSwapAmount &&
513             from != dexPair &&
514             distributeAndLiquifyStatus &&
515             !(from == address(this) && to == dexPair) // swap 1 time
516         ) {
517             // approve contract
518             _approve(address(this), address(dexRouter), minSwapAmount);
519 
520             // lock into liquidty pool
521             Utils.swapTokensForEth(address(dexRouter), minSwapAmount);
522             uint256 ethForMarketing = address(this).balance;
523 
524             // sending Eth to Marketing wallet
525             if (ethForMarketing > 0)
526                 payable(marketWallet).transfer(ethForMarketing);
527         }
528     }
529 }