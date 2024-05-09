1 //https://www.finerc.vip/
2 //https://t.me/FINEerc
3 
4 // SPDX-License-Identifier:MIT
5 pragma solidity ^0.8.18;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address account) external view returns (uint256);
11 
12     function transfer(
13         address recipient,
14         uint256 amount
15     ) external returns (bool);
16 
17     function allowance(
18         address owner,
19         address spender
20     ) external view returns (uint256);
21 
22     function approve(address spender, uint256 amount) external returns (bool);
23 
24     function transferFrom(
25         address sender,
26         address recipient,
27         uint256 amount
28     ) external returns (bool);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 // Dex Factory contract interface
40 interface IDexFactory {
41     function createPair(
42         address tokenA,
43         address tokenB
44     ) external returns (address pair);
45 }
46 
47 // Dex Router contract interface
48 interface IDexRouter {
49     function factory() external pure returns (address);
50 
51     function WETH() external pure returns (address);
52 
53     function addLiquidityETH(
54         address token,
55         uint256 amountTokenDesired,
56         uint256 amountTokenMin,
57         uint256 amountETHMin,
58         address to,
59         uint256 deadline
60     )
61         external
62         payable
63         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
64 
65     function swapExactTokensForETHSupportingFeeOnTransferTokens(
66         uint256 amountIn,
67         uint256 amountOutMin,
68         address[] calldata path,
69         address to,
70         uint256 deadline
71     ) external;
72 }
73 
74 abstract contract Context {
75     function _msgSender() internal view virtual returns (address payable) {
76         return payable(msg.sender);
77     }
78 
79     function _msgData() internal view virtual returns (bytes memory) {
80         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
81         return msg.data;
82     }
83 }
84 
85 contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(
89         address indexed previousOwner,
90         address indexed newOwner
91     );
92 
93     constructor() {
94         _owner = _msgSender();
95         emit OwnershipTransferred(address(0), _owner);
96     }
97 
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     modifier onlyOwner() {
103         require(_owner == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     function renounceOwnership() public virtual onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = payable(address(0));
110     }
111 
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(
114             newOwner != address(0),
115             "Ownable: new owner is the zero address"
116         );
117         emit OwnershipTransferred(_owner, newOwner);
118         _owner = newOwner;
119     }
120 }
121 
122 contract FINE is Context, IERC20, Ownable {
123     string private _name = "FINE";
124     string private _symbol = "FINE";
125     uint8 private _decimals = 18;
126     uint256 private _totalSupply = 420_690_000_000_000 * 1e18;
127 
128     mapping(address => uint256) private _balances;
129     mapping(address => mapping(address => uint256)) private _allowances;
130 
131     mapping(address => bool) public isExcludedFromFee;
132     mapping(address => bool) public isExcludedFromMaxTxn;
133     mapping(address => bool) public isExcludedFromMaxHolding;
134 
135     uint256 public minTokenToSwap = (_totalSupply * 5) / (10000); // this amount will trigger swap and distribute
136     uint256 public maxHoldLimit = (_totalSupply * 2) / (100); // this is the max wallet holding limit
137     uint256 public maxTxnLimit = (_totalSupply * 2) / (100); // this is the max transaction limit
138     uint256 public percentDivider = 100;
139     uint256 public launchedAt;
140 
141     bool public distributeAndLiquifyStatus; // should be true to turn on to liquidate the pool
142     bool public feesStatus; // enable by default
143     bool public trading; // once enable can't be disable afterwards
144 
145     IDexRouter public dexRouter; // router declaration
146 
147     address public dexPair; // pair address declaration
148     address public marketingWallet; // marketing address declaration
149     address private constant DEAD = address(0xdead);
150     address private constant ZERO = address(0);
151 
152     uint256 public marketingFeeOnBuying = 30;
153 
154     uint256 public marketingFeeOnSelling = 30;
155 
156     event SwapAndLiquify(
157         uint256 tokensSwapped,
158         uint256 ethReceived,
159         uint256 tokensIntoLiqudity
160     );
161 
162     constructor() {
163         _balances[owner()] = _totalSupply;
164         marketingWallet = address(0x189c327BD021bA1CcF0be4692d46cD571416C3e8);
165 
166         dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
167         isExcludedFromFee[address(dexRouter)] = true;
168         isExcludedFromMaxTxn[address(dexRouter)] = true;
169         isExcludedFromMaxHolding[address(dexRouter)] = true;
170 
171         dexPair = IDexFactory(dexRouter.factory()).createPair(
172             address(this),
173             dexRouter.WETH()
174         );
175         isExcludedFromMaxHolding[dexPair] = true;
176 
177         //exclude owner and this contract from fee
178         isExcludedFromFee[owner()] = true;
179         isExcludedFromFee[address(this)] = true;
180 
181         //exclude owner and this contract from max Txn
182         isExcludedFromMaxTxn[owner()] = true;
183         isExcludedFromMaxTxn[address(this)] = true;
184 
185         //exclude owner and this contract from max hold limit
186         isExcludedFromMaxHolding[owner()] = true;
187         isExcludedFromMaxHolding[address(this)] = true;
188         isExcludedFromMaxHolding[marketingWallet] = true;
189 
190         emit Transfer(address(0), owner(), _totalSupply);
191     }
192 
193     //to receive ETH from dexRouter when swapping
194     receive() external payable {}
195 
196     function name() public view returns (string memory) {
197         return _name;
198     }
199 
200     function symbol() public view returns (string memory) {
201         return _symbol;
202     }
203 
204     function decimals() public view returns (uint8) {
205         return _decimals;
206     }
207 
208     function totalSupply() public view override returns (uint256) {
209         return _totalSupply;
210     }
211 
212     function balanceOf(address account) public view override returns (uint256) {
213         return _balances[account];
214     }
215 
216     function transfer(
217         address recipient,
218         uint256 amount
219     ) public override returns (bool) {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     function allowance(
225         address owner,
226         address spender
227     ) public view override returns (uint256) {
228         return _allowances[owner][spender];
229     }
230 
231     function approve(
232         address spender,
233         uint256 amount
234     ) public override returns (bool) {
235         _approve(_msgSender(), spender, amount);
236         return true;
237     }
238 
239     function transferFrom(
240         address sender,
241         address recipient,
242         uint256 amount
243     ) public override returns (bool) {
244         _transfer(sender, recipient, amount);
245         _approve(
246             sender,
247             _msgSender(),
248             _allowances[sender][_msgSender()] - amount
249         );
250         return true;
251     }
252 
253     function increaseAllowance(
254         address spender,
255         uint256 addedValue
256     ) public virtual returns (bool) {
257         _approve(
258             _msgSender(),
259             spender,
260             _allowances[_msgSender()][spender] + (addedValue)
261         );
262         return true;
263     }
264 
265     function decreaseAllowance(
266         address spender,
267         uint256 subtractedValue
268     ) public virtual returns (bool) {
269         _approve(
270             _msgSender(),
271             spender,
272             _allowances[_msgSender()][spender] - subtractedValue
273         );
274         return true;
275     }
276 
277     function includeOrExcludeFromFee(
278         address account,
279         bool value
280     ) external onlyOwner {
281         isExcludedFromFee[account] = value;
282     }
283 
284     function includeOrExcludeFromMaxTxn(
285         address account,
286         bool value
287     ) external onlyOwner {
288         isExcludedFromMaxTxn[account] = value;
289     }
290 
291     function includeOrExcludeFromMaxHolding(
292         address account,
293         bool value
294     ) external onlyOwner {
295         isExcludedFromMaxHolding[account] = value;
296     }
297 
298     function setMinTokenToSwap(uint256 _amount) external onlyOwner {
299         minTokenToSwap = _amount * 1e18;
300     }
301 
302     function setMaxHoldLimit(uint256 _amount) external onlyOwner {
303         maxHoldLimit = _amount * 1e18;
304     }
305 
306     function setMaxTxnLimit(uint256 _amount) external onlyOwner {
307         maxTxnLimit = _amount * 1e18;
308     }
309 
310     function setBuyFeePercent(uint256 _marketingFee) external onlyOwner {
311         marketingFeeOnBuying = _marketingFee;
312     }
313 
314     function setSellFeePercent(uint256 _marketingFee) external onlyOwner {
315         marketingFeeOnSelling = _marketingFee;
316     }
317 
318     function setDistributionStatus(bool _value) public onlyOwner {
319         distributeAndLiquifyStatus = _value;
320     }
321 
322     function enableOrDisableFees(bool _value) external onlyOwner {
323         feesStatus = _value;
324     }
325 
326     function updateAddresses(address _marketingWallet) external onlyOwner {
327         marketingWallet = _marketingWallet;
328     }
329 
330     function enableTrading() external onlyOwner {
331         require(!trading, ": already enabled");
332 
333         trading = true;
334         feesStatus = true;
335         distributeAndLiquifyStatus = true;
336         launchedAt = block.timestamp;
337     }
338 
339     function removeStuckEth(address _receiver) public onlyOwner {
340         payable(_receiver).transfer(address(this).balance);
341     }
342 
343     function totalBuyFeePerTx(uint256 amount) public view returns (uint256) {
344         uint256 fee = (amount * marketingFeeOnBuying) / (percentDivider);
345         return fee;
346     }
347 
348     function totalSellFeePerTx(uint256 amount) public view returns (uint256) {
349         uint256 fee = (amount * marketingFeeOnSelling) / (percentDivider);
350         return fee;
351     }
352 
353     function _approve(address owner, address spender, uint256 amount) private {
354         require(owner != address(0), " approve from the zero address");
355         require(spender != address(0), "approve to the zero address");
356 
357         _allowances[owner][spender] = amount;
358         emit Approval(owner, spender, amount);
359     }
360 
361     function _transfer(address from, address to, uint256 amount) private {
362         require(from != address(0), "transfer from the zero address");
363         require(to != address(0), "transfer to the zero address");
364         require(amount > 0, "Amount must be greater than zero");
365         if (!isExcludedFromMaxTxn[from] && !isExcludedFromMaxTxn[to]) {
366             require(amount <= maxTxnLimit, " max txn limit exceeds");
367 
368             // trading disable till launch
369             if (!trading) {
370                 require(
371                     dexPair != from && dexPair != to,
372                     ": trading is disable"
373                 );
374             }
375         }
376 
377         if (!isExcludedFromMaxHolding[to]) {
378             require(
379                 (balanceOf(to) + amount) <= maxHoldLimit,
380                 ": max hold limit exceeds"
381             );
382         }
383 
384         // swap and liquify
385         distributeAndLiquify(from, to);
386 
387         //indicates if fee should be deducted from transfer
388         bool takeFee = true;
389 
390         //if any account belongs to isExcludedFromFee account then remove the fee
391         if (isExcludedFromFee[from] || isExcludedFromFee[to] || !feesStatus) {
392             takeFee = false;
393         }
394 
395         //transfer amount, it will take tax, burn, liquidity fee
396         _tokenTransfer(from, to, amount, takeFee);
397     }
398 
399     //this method is responsible for taking all fees, if takeFee is true
400     function _tokenTransfer(
401         address sender,
402         address recipient,
403         uint256 amount,
404         bool takeFee
405     ) private {
406         if (dexPair == sender && takeFee) {
407             uint256 allFee;
408             uint256 tTransferAmount;
409             allFee = totalBuyFeePerTx(amount);
410             tTransferAmount = amount - allFee;
411 
412             _balances[sender] = _balances[sender] - amount;
413             _balances[recipient] = _balances[recipient] + tTransferAmount;
414             emit Transfer(sender, recipient, tTransferAmount);
415 
416             takeTokenFee(sender, allFee);
417         } else if (dexPair == recipient && takeFee) {
418             uint256 allFee = totalSellFeePerTx(amount);
419             uint256 tTransferAmount = amount - allFee;
420             _balances[sender] = _balances[sender] - amount;
421             _balances[recipient] = _balances[recipient] + tTransferAmount;
422             emit Transfer(sender, recipient, tTransferAmount);
423 
424             takeTokenFee(sender, allFee);
425         } else {
426             _balances[sender] = _balances[sender] - amount;
427             _balances[recipient] = _balances[recipient] + (amount);
428             emit Transfer(sender, recipient, amount);
429         }
430     }
431 
432     function takeTokenFee(address sender, uint256 amount) private {
433         _balances[address(this)] = _balances[address(this)] + (amount);
434 
435         emit Transfer(sender, address(this), amount);
436     }
437 
438     // to withdarw ETH from contract
439     function withdrawETH(uint256 _amount) external onlyOwner {
440         require(address(this).balance >= _amount, "Invalid Amount");
441         payable(msg.sender).transfer(_amount);
442     }
443 
444     // to withdraw ERC20 tokens from contract
445     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
446         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
447         _token.transfer(msg.sender, _amount);
448     }
449 
450     function distributeAndLiquify(address from, address to) private {
451         uint256 contractTokenBalance = balanceOf(address(this));
452 
453         bool shouldSell = contractTokenBalance >= minTokenToSwap;
454 
455         if (
456             shouldSell &&
457             from != dexPair &&
458             distributeAndLiquifyStatus &&
459             !(from == address(this) && to == dexPair) // swap 1 time
460         ) {
461             // approve contract
462             _approve(address(this), address(dexRouter), minTokenToSwap);
463 
464             // now is to lock into liquidty pool
465             Utils.swapTokensForEth(address(dexRouter), minTokenToSwap);
466             uint256 ethForMarketing = address(this).balance;
467 
468             // sending Eth to Marketing wallet
469             if (ethForMarketing > 0)
470                 payable(marketingWallet).transfer(ethForMarketing);
471         }
472     }
473 }
474 
475 // Library for swapping on Dex
476 library Utils {
477     function swapTokensForEth(
478         address routerAddress,
479         uint256 tokenAmount
480     ) internal {
481         IDexRouter dexRouter = IDexRouter(routerAddress);
482 
483         // generate the Dex pair path of token -> weth
484         address[] memory path = new address[](2);
485         path[0] = address(this);
486         path[1] = dexRouter.WETH();
487 
488         // make the swap
489         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
490             tokenAmount,
491             0, // accept any amount of ETH
492             path,
493             address(this),
494             block.timestamp + 300
495         );
496     }
497 
498     function addLiquidity(
499         address routerAddress,
500         address owner,
501         uint256 tokenAmount,
502         uint256 ethAmount
503     ) internal {
504         IDexRouter dexRouter = IDexRouter(routerAddress);
505 
506         // add the liquidity
507         dexRouter.addLiquidityETH{value: ethAmount}(
508             address(this),
509             tokenAmount,
510             0, // slippage is unavoidable
511             0, // slippage is unavoidable
512             owner,
513             block.timestamp + 300
514         );
515     }
516 }