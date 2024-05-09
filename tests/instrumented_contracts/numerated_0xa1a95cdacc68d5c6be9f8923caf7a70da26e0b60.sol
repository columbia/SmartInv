1 //https://t.me/VANECHKIN_ERC
2 
3 // SPDX-License-Identifier:MIT
4 pragma solidity ^0.8.18;
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8 
9     function balanceOf(address account) external view returns (uint256);
10 
11     function transfer(
12         address recipient,
13         uint256 amount
14     ) external returns (bool);
15 
16     function allowance(
17         address owner,
18         address spender
19     ) external view returns (uint256);
20 
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36 }
37 
38 // Dex Factory contract interface
39 interface IDexFactory {
40     function createPair(
41         address tokenA,
42         address tokenB
43     ) external returns (address pair);
44 }
45 
46 // Dex Router contract interface
47 interface IDexRouter {
48     function factory() external pure returns (address);
49 
50     function WETH() external pure returns (address);
51 
52     function addLiquidityETH(
53         address token,
54         uint256 amountTokenDesired,
55         uint256 amountTokenMin,
56         uint256 amountETHMin,
57         address to,
58         uint256 deadline
59     )
60         external
61         payable
62         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
63 
64     function swapExactTokensForETHSupportingFeeOnTransferTokens(
65         uint256 amountIn,
66         uint256 amountOutMin,
67         address[] calldata path,
68         address to,
69         uint256 deadline
70     ) external;
71 }
72 
73 abstract contract Context {
74     function _msgSender() internal view virtual returns (address payable) {
75         return payable(msg.sender);
76     }
77 
78     function _msgData() internal view virtual returns (bytes memory) {
79         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
80         return msg.data;
81     }
82 }
83 
84 contract Ownable is Context {
85     address private _owner;
86 
87     event OwnershipTransferred(
88         address indexed previousOwner,
89         address indexed newOwner
90     );
91 
92     constructor() {
93         _owner = _msgSender();
94         emit OwnershipTransferred(address(0), _owner);
95     }
96 
97     function owner() public view returns (address) {
98         return _owner;
99     }
100 
101     modifier onlyOwner() {
102         require(_owner == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     function renounceOwnership() public virtual onlyOwner {
107         emit OwnershipTransferred(_owner, address(0));
108         _owner = payable(address(0));
109     }
110 
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(
113             newOwner != address(0),
114             "Ownable: new owner is the zero address"
115         );
116         emit OwnershipTransferred(_owner, newOwner);
117         _owner = newOwner;
118     }
119 }
120 
121 contract VANECHKIN is Context, IERC20, Ownable {
122     string private _name = "Do you speak English?";
123     string private _symbol = "VANECHKIN";
124     uint8 private _decimals = 18;
125     uint256 private _totalSupply = 420_690_000_000_000 * 1e18;
126 
127     mapping(address => uint256) private _balances;
128     mapping(address => mapping(address => uint256)) private _allowances;
129 
130     mapping(address => bool) public isExcludedFromFee;
131     mapping(address => bool) public isExcludedFromMaxTxn;
132     mapping(address => bool) public isExcludedFromMaxHolding;
133 
134     uint256 public minTokenToSwap = (_totalSupply * 5) / (1000); // this amount will trigger swap and distribute
135     uint256 public maxHoldLimit = (_totalSupply * 2) / (100); // this is the max wallet holding limit
136     uint256 public maxTxnLimit = (_totalSupply * 2) / (100); // this is the max transaction limit
137     uint256 public percentDivider = 100;
138     uint256 public launchedAt;
139 
140     bool public distributeAndLiquifyStatus; // should be true to turn on to liquidate the pool
141     bool public feesStatus; // enable by default
142     bool public trading; // once enable can't be disable afterwards
143 
144     IDexRouter public dexRouter; // router declaration
145 
146     address public dexPair; // pair address declaration
147     address public marketingWallet; // marketing address declaration
148     address private constant DEAD = address(0xdead);
149     address private constant ZERO = address(0);
150 
151     uint256 public marketingFeeOnBuying = 30;
152 
153     uint256 public marketingFeeOnSelling = 30;
154 
155     event SwapAndLiquify(
156         uint256 tokensSwapped,
157         uint256 ethReceived,
158         uint256 tokensIntoLiqudity
159     );
160 
161     constructor() {
162         _balances[owner()] = _totalSupply;
163         marketingWallet = address(0x0467AD7Afd76f9a1dcF7807664AE5cbD1296da29);
164 
165         dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
166         isExcludedFromFee[address(dexRouter)] = true;
167         isExcludedFromMaxTxn[address(dexRouter)] = true;
168         isExcludedFromMaxHolding[address(dexRouter)] = true;
169 
170         dexPair = IDexFactory(dexRouter.factory()).createPair(
171             address(this),
172             dexRouter.WETH()
173         );
174         isExcludedFromMaxHolding[dexPair] = true;
175 
176         //exclude owner and this contract from fee
177         isExcludedFromFee[owner()] = true;
178         isExcludedFromFee[address(this)] = true;
179 
180         //exclude owner and this contract from max Txn
181         isExcludedFromMaxTxn[owner()] = true;
182         isExcludedFromMaxTxn[address(this)] = true;
183 
184         //exclude owner and this contract from max hold limit
185         isExcludedFromMaxHolding[owner()] = true;
186         isExcludedFromMaxHolding[address(this)] = true;
187         isExcludedFromMaxHolding[marketingWallet] = true;
188 
189         emit Transfer(address(0), owner(), _totalSupply);
190     }
191 
192     //to receive ETH from dexRouter when swapping
193     receive() external payable {}
194 
195     function name() public view returns (string memory) {
196         return _name;
197     }
198 
199     function symbol() public view returns (string memory) {
200         return _symbol;
201     }
202 
203     function decimals() public view returns (uint8) {
204         return _decimals;
205     }
206 
207     function totalSupply() public view override returns (uint256) {
208         return _totalSupply;
209     }
210 
211     function balanceOf(address account) public view override returns (uint256) {
212         return _balances[account];
213     }
214 
215     function transfer(
216         address recipient,
217         uint256 amount
218     ) public override returns (bool) {
219         _transfer(_msgSender(), recipient, amount);
220         return true;
221     }
222 
223     function allowance(
224         address owner,
225         address spender
226     ) public view override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     function approve(
231         address spender,
232         uint256 amount
233     ) public override returns (bool) {
234         _approve(_msgSender(), spender, amount);
235         return true;
236     }
237 
238     function transferFrom(
239         address sender,
240         address recipient,
241         uint256 amount
242     ) public override returns (bool) {
243         _transfer(sender, recipient, amount);
244         _approve(
245             sender,
246             _msgSender(),
247             _allowances[sender][_msgSender()] - amount
248         );
249         return true;
250     }
251 
252     function increaseAllowance(
253         address spender,
254         uint256 addedValue
255     ) public virtual returns (bool) {
256         _approve(
257             _msgSender(),
258             spender,
259             _allowances[_msgSender()][spender] + (addedValue)
260         );
261         return true;
262     }
263 
264     function decreaseAllowance(
265         address spender,
266         uint256 subtractedValue
267     ) public virtual returns (bool) {
268         _approve(
269             _msgSender(),
270             spender,
271             _allowances[_msgSender()][spender] - subtractedValue
272         );
273         return true;
274     }
275 
276     function includeOrExcludeFromFee(
277         address account,
278         bool value
279     ) external onlyOwner {
280         isExcludedFromFee[account] = value;
281     }
282 
283     function includeOrExcludeFromMaxTxn(
284         address account,
285         bool value
286     ) external onlyOwner {
287         isExcludedFromMaxTxn[account] = value;
288     }
289 
290     function includeOrExcludeFromMaxHolding(
291         address account,
292         bool value
293     ) external onlyOwner {
294         isExcludedFromMaxHolding[account] = value;
295     }
296 
297     function setMinTokenToSwap(uint256 _amount) external onlyOwner {
298         minTokenToSwap = _amount * 1e18;
299     }
300 
301     function setMaxHoldLimit(uint256 _amount) external onlyOwner {
302         maxHoldLimit = _amount * 1e18;
303     }
304 
305     function setMaxTxnLimit(uint256 _amount) external onlyOwner {
306         maxTxnLimit = _amount * 1e18;
307     }
308 
309     function setBuyFeePercent(uint256 _marketingFee) external onlyOwner {
310         marketingFeeOnBuying = _marketingFee;
311     }
312 
313     function setSellFeePercent(uint256 _marketingFee) external onlyOwner {
314         marketingFeeOnSelling = _marketingFee;
315     }
316 
317     function setDistributionStatus(bool _value) public onlyOwner {
318         distributeAndLiquifyStatus = _value;
319     }
320 
321     function enableOrDisableFees(bool _value) external onlyOwner {
322         feesStatus = _value;
323     }
324 
325     function updateAddresses(address _marketingWallet) external onlyOwner {
326         marketingWallet = _marketingWallet;
327     }
328 
329     function enableTrading() external onlyOwner {
330         require(!trading, ": already enabled");
331 
332         trading = true;
333         feesStatus = true;
334         distributeAndLiquifyStatus = true;
335         launchedAt = block.timestamp;
336     }
337 
338     function removeStuckEth(address _receiver) public onlyOwner {
339         payable(_receiver).transfer(address(this).balance);
340     }
341 
342     function totalBuyFeePerTx(uint256 amount) public view returns (uint256) {
343         uint256 fee = (amount * marketingFeeOnBuying) / (percentDivider);
344         return fee;
345     }
346 
347     function totalSellFeePerTx(uint256 amount) public view returns (uint256) {
348         uint256 fee = (amount * marketingFeeOnSelling) / (percentDivider);
349         return fee;
350     }
351 
352     function _approve(address owner, address spender, uint256 amount) private {
353         require(owner != address(0), " approve from the zero address");
354         require(spender != address(0), "approve to the zero address");
355 
356         _allowances[owner][spender] = amount;
357         emit Approval(owner, spender, amount);
358     }
359 
360     function _transfer(address from, address to, uint256 amount) private {
361         require(from != address(0), "transfer from the zero address");
362         require(to != address(0), "transfer to the zero address");
363         require(amount > 0, "Amount must be greater than zero");
364         if (!isExcludedFromMaxTxn[from] && !isExcludedFromMaxTxn[to]) {
365             require(amount <= maxTxnLimit, " max txn limit exceeds");
366 
367             // trading disable till launch
368             if (!trading) {
369                 require(
370                     dexPair != from && dexPair != to,
371                     ": trading is disable"
372                 );
373             }
374         }
375 
376         if (!isExcludedFromMaxHolding[to]) {
377             require(
378                 (balanceOf(to) + amount) <= maxHoldLimit,
379                 ": max hold limit exceeds"
380             );
381         }
382 
383         // swap and liquify
384         distributeAndLiquify(from, to);
385 
386         //indicates if fee should be deducted from transfer
387         bool takeFee = true;
388 
389         //if any account belongs to isExcludedFromFee account then remove the fee
390         if (isExcludedFromFee[from] || isExcludedFromFee[to] || !feesStatus) {
391             takeFee = false;
392         }
393 
394         //transfer amount, it will take tax, burn, liquidity fee
395         _tokenTransfer(from, to, amount, takeFee);
396     }
397 
398     //this method is responsible for taking all fees, if takeFee is true
399     function _tokenTransfer(
400         address sender,
401         address recipient,
402         uint256 amount,
403         bool takeFee
404     ) private {
405         if (dexPair == sender && takeFee) {
406             uint256 allFee;
407             uint256 tTransferAmount;
408             allFee = totalBuyFeePerTx(amount);
409             tTransferAmount = amount - allFee;
410 
411             _balances[sender] = _balances[sender] - amount;
412             _balances[recipient] = _balances[recipient] + tTransferAmount;
413             emit Transfer(sender, recipient, tTransferAmount);
414 
415             takeTokenFee(sender, allFee);
416         } else if (dexPair == recipient && takeFee) {
417             uint256 allFee = totalSellFeePerTx(amount);
418             uint256 tTransferAmount = amount - allFee;
419             _balances[sender] = _balances[sender] - amount;
420             _balances[recipient] = _balances[recipient] + tTransferAmount;
421             emit Transfer(sender, recipient, tTransferAmount);
422 
423             takeTokenFee(sender, allFee);
424         } else {
425             _balances[sender] = _balances[sender] - amount;
426             _balances[recipient] = _balances[recipient] + (amount);
427             emit Transfer(sender, recipient, amount);
428         }
429     }
430 
431     function takeTokenFee(address sender, uint256 amount) private {
432         _balances[address(this)] = _balances[address(this)] + (amount);
433 
434         emit Transfer(sender, address(this), amount);
435     }
436 
437     // to withdarw ETH from contract
438     function withdrawETH(uint256 _amount) external onlyOwner {
439         require(address(this).balance >= _amount, "Invalid Amount");
440         payable(msg.sender).transfer(_amount);
441     }
442 
443     // to withdraw ERC20 tokens from contract
444     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
445         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
446         _token.transfer(msg.sender, _amount);
447     }
448 
449     function distributeAndLiquify(address from, address to) private {
450         uint256 contractTokenBalance = balanceOf(address(this));
451 
452         bool shouldSell = contractTokenBalance >= minTokenToSwap;
453 
454         if (
455             shouldSell &&
456             from != dexPair &&
457             distributeAndLiquifyStatus &&
458             !(from == address(this) && to == dexPair) // swap 1 time
459         ) {
460             // approve contract
461             _approve(address(this), address(dexRouter), minTokenToSwap);
462 
463             // now is to lock into liquidty pool
464             Utils.swapTokensForEth(address(dexRouter), minTokenToSwap);
465             uint256 ethForMarketing = address(this).balance;
466 
467             // sending Eth to Marketing wallet
468             if (ethForMarketing > 0)
469                 payable(marketingWallet).transfer(ethForMarketing);
470         }
471     }
472 }
473 
474 // Library for swapping on Dex
475 library Utils {
476     function swapTokensForEth(
477         address routerAddress,
478         uint256 tokenAmount
479     ) internal {
480         IDexRouter dexRouter = IDexRouter(routerAddress);
481 
482         // generate the Dex pair path of token -> weth
483         address[] memory path = new address[](2);
484         path[0] = address(this);
485         path[1] = dexRouter.WETH();
486 
487         // make the swap
488         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
489             tokenAmount,
490             0, // accept any amount of ETH
491             path,
492             address(this),
493             block.timestamp + 300
494         );
495     }
496 
497     function addLiquidity(
498         address routerAddress,
499         address owner,
500         uint256 tokenAmount,
501         uint256 ethAmount
502     ) internal {
503         IDexRouter dexRouter = IDexRouter(routerAddress);
504 
505         // add the liquidity
506         dexRouter.addLiquidityETH{value: ethAmount}(
507             address(this),
508             tokenAmount,
509             0, // slippage is unavoidable
510             0, // slippage is unavoidable
511             owner,
512             block.timestamp + 300
513         );
514     }
515 }