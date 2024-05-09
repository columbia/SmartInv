1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.18;
4 
5 interface IUniswapV2Factory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function feeToSetter() external view returns (address);
10     function getPair(address tokenA, address tokenB) external view returns (address pair);
11     function allPairs(uint) external view returns (address pair);
12     function allPairsLength() external view returns (uint);
13     function createPair(address tokenA, address tokenB) external returns (address pair);
14     function setFeeTo(address) external;
15     function setFeeToSetter(address) external;
16 }
17 
18 interface IUniswapV2Router01 {
19     function factory() external pure returns (address);
20     function WETH() external pure returns (address);
21 
22     function addLiquidity(
23         address tokenA,
24         address tokenB,
25         uint amountADesired,
26         uint amountBDesired,
27         uint amountAMin,
28         uint amountBMin,
29         address to,
30         uint deadline
31     ) external returns (uint amountA, uint amountB, uint liquidity);
32     function addLiquidityETH(
33         address token,
34         uint amountTokenDesired,
35         uint amountTokenMin,
36         uint amountETHMin,
37         address to,
38         uint deadline
39     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
40     function removeLiquidity(
41         address tokenA,
42         address tokenB,
43         uint liquidity,
44         uint amountAMin,
45         uint amountBMin,
46         address to,
47         uint deadline
48     ) external returns (uint amountA, uint amountB);
49     function removeLiquidityETH(
50         address token,
51         uint liquidity,
52         uint amountTokenMin,
53         uint amountETHMin,
54         address to,
55         uint deadline
56     ) external returns (uint amountToken, uint amountETH);
57     function removeLiquidityWithPermit(
58         address tokenA,
59         address tokenB,
60         uint liquidity,
61         uint amountAMin,
62         uint amountBMin,
63         address to,
64         uint deadline,
65         bool approveMax, uint8 v, bytes32 r, bytes32 s
66     ) external returns (uint amountA, uint amountB);
67     function removeLiquidityETHWithPermit(
68         address token,
69         uint liquidity,
70         uint amountTokenMin,
71         uint amountETHMin,
72         address to,
73         uint deadline,
74         bool approveMax, uint8 v, bytes32 r, bytes32 s
75     ) external returns (uint amountToken, uint amountETH);
76     function swapExactTokensForTokens(
77         uint amountIn,
78         uint amountOutMin,
79         address[] calldata path,
80         address to,
81         uint deadline
82     ) external returns (uint[] memory amounts);
83     function swapTokensForExactTokens(
84         uint amountOut,
85         uint amountInMax,
86         address[] calldata path,
87         address to,
88         uint deadline
89     ) external returns (uint[] memory amounts);
90     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
91         external
92         payable
93         returns (uint[] memory amounts);
94     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
95         external
96         returns (uint[] memory amounts);
97     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
98         external
99         returns (uint[] memory amounts);
100     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
101         external
102         payable
103         returns (uint[] memory amounts);
104 
105     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
106     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
107     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
108     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
109     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
110 }
111 
112 interface IUniswapV2Router02 is IUniswapV2Router01 {
113     function removeLiquidityETHSupportingFeeOnTransferTokens(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external returns (uint amountETH);
121     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
122         address token,
123         uint liquidity,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline,
128         bool approveMax, uint8 v, bytes32 r, bytes32 s
129     ) external returns (uint amountETH);
130 
131     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138     function swapExactETHForTokensSupportingFeeOnTransferTokens(
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external payable;
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external;
151 }
152 
153 interface IERC20 {
154     function totalSupply() external view returns (uint256);
155     function balanceOf(address account) external view returns (uint256);
156     function transfer(address recipient, uint256 amount) external returns (bool);
157     function allowance(address owner, address spender) external view returns (uint256);
158     function approve(address spender, uint256 amount) external returns (bool);
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) external returns (bool);
164    
165     event Transfer(address indexed from, address indexed to, uint256 value);
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 interface IERC20Metadata is IERC20 {
170     function name() external view returns (string memory);
171     function symbol() external view returns (string memory);
172     function decimals() external view returns (uint8);
173 }
174 
175 abstract contract Context {
176     function _msgSender() internal view virtual returns (address) {
177         return msg.sender;
178     }
179 
180     function _msgData() internal view virtual returns (bytes calldata) {
181         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
182         return msg.data;
183     }
184 }
185 
186 abstract contract Ownable is Context {
187     address private _owner;
188 
189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191     constructor () {
192         address msgSender = _msgSender();
193         _owner = msgSender;
194         emit OwnershipTransferred(address(0), msgSender);
195     }
196 
197     function owner() public view returns (address) {
198         return _owner;
199     }
200 
201     modifier onlyOwner() {
202         require(_owner == _msgSender(), "Ownable: caller is not the owner");
203         _;
204     }
205 
206     function renounceOwnership() public virtual onlyOwner {
207         emit OwnershipTransferred(_owner, address(0));
208         _owner = address(0);
209     }
210 
211     function transferOwnership(address newOwner) public virtual onlyOwner {
212         require(newOwner != address(0), "Ownable: new owner is the zero address");
213         emit OwnershipTransferred(_owner, newOwner);
214         _owner = newOwner;
215     }
216 }
217 
218 contract ERC20 is Context, IERC20, IERC20Metadata {
219     mapping(address => uint256) private _balances;
220 
221     mapping(address => mapping(address => uint256)) private _allowances;
222 
223     uint256 private _totalSupply;
224 
225     string private _name;
226     string private _symbol;
227 
228     constructor(string memory name_, string memory symbol_) {
229         _name = name_;
230         _symbol = symbol_;
231     }
232 
233     function name() public view virtual override returns (string memory) {
234         return _name;
235     }
236 
237     function symbol() public view virtual override returns (string memory) {
238         return _symbol;
239     }
240 
241     function decimals() public view virtual override returns (uint8) {
242         return 18;
243     }
244 
245     function totalSupply() public view virtual override returns (uint256) {
246         return _totalSupply;
247     }
248 
249     function balanceOf(address account) public view virtual override returns (uint256) {
250         return _balances[account];
251     }
252 
253     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
254         _transfer(_msgSender(), recipient, amount);
255         return true;
256     }
257 
258     function allowance(address owner, address spender) public view virtual override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     function approve(address spender, uint256 amount) public virtual override returns (bool) {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266 
267     function transferFrom(
268         address sender,
269         address recipient,
270         uint256 amount
271     ) public virtual override returns (bool) {
272         uint256 currentAllowance = _allowances[sender][_msgSender()];
273         if (currentAllowance != type(uint256).max) {
274             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
275             unchecked {
276                 _approve(sender, _msgSender(), currentAllowance - amount);
277             }
278         }
279 
280         _transfer(sender, recipient, amount);
281 
282         return true;
283     }
284 
285     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
286         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
287         return true;
288     }
289 
290     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
291         uint256 currentAllowance = _allowances[_msgSender()][spender];
292         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
293         unchecked {
294             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
295         }
296 
297         return true;
298     }
299 
300     function _transfer(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) internal virtual {
305         require(sender != address(0), "ERC20: transfer from the zero address");
306         require(recipient != address(0), "ERC20: transfer to the zero address");
307 
308         _beforeTokenTransfer(sender, recipient, amount);
309 
310         uint256 senderBalance = _balances[sender];
311         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
312         unchecked {
313             _balances[sender] = senderBalance - amount;
314         }
315         _balances[recipient] += amount;
316 
317         emit Transfer(sender, recipient, amount);
318 
319         _afterTokenTransfer(sender, recipient, amount);
320     }
321 
322     function _init(address account, uint256 amount) internal virtual {
323         require(account != address(0), "ERC20: mint to the zero address");
324 
325         _beforeTokenTransfer(address(0), account, amount);
326 
327         _totalSupply += amount;
328         _balances[account] += amount;
329         emit Transfer(address(0), account, amount);
330 
331         _afterTokenTransfer(address(0), account, amount);
332     }
333 
334     function _burn(address account, uint256 amount) internal virtual {
335         require(account != address(0), "ERC20: burn from the zero address");
336 
337         _beforeTokenTransfer(account, address(0), amount);
338 
339         uint256 accountBalance = _balances[account];
340         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
341         unchecked {
342             _balances[account] = accountBalance - amount;
343         }
344         _totalSupply -= amount;
345 
346         emit Transfer(account, address(0), amount);
347 
348         _afterTokenTransfer(account, address(0), amount);
349     }
350 
351     function _approve(
352         address owner,
353         address spender,
354         uint256 amount
355     ) internal virtual {
356         require(owner != address(0), "ERC20: approve from the zero address");
357         require(spender != address(0), "ERC20: approve to the zero address");
358 
359         _allowances[owner][spender] = amount;
360         emit Approval(owner, spender, amount);
361     }
362 
363     function _beforeTokenTransfer(
364         address from,
365         address to,
366         uint256 amount
367     ) internal virtual {}
368 
369     function _afterTokenTransfer(
370         address from,
371         address to,
372         uint256 amount
373     ) internal virtual {}
374 }
375 
376 contract MuratiAI is ERC20, Ownable {
377     IUniswapV2Router02 public uniswapV2Router;
378     address public  uniswapV2Pair;
379 
380     mapping (address => bool) private _isExcludedFromFees;
381 
382     uint256 public buyFee;
383     uint256 public sellFee;
384     uint256 public walletToWalletTransferFee;
385 
386     address public marketingWallet;
387 
388     bool    public tradingEnabled;
389 
390     uint256 public swapTokensAtAmount;
391     bool    public swapWithLimit;
392     bool    private swapping;
393 
394     event ExcludeFromFees(address indexed account, bool isExcluded);
395     event BuyFeeUpdated(uint256 buyFee);
396     event SellFeeUpdated(uint256 sellFee);
397     event WalletToWalletTransferFeeUpdated(uint256 walletToWalletTransferFee);
398     event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
399     event SwapAndSend(uint256 tokensSwapped, uint256 valueReceived);
400     event SwapWithLimitUpdated(bool swapWithLimit);
401 
402     constructor () ERC20("MuratiAI", "MURATIAI") 
403     {   
404         address newOwner = 0x25840a88575B99F451ed64A1A437793353d22561;
405         transferOwnership(newOwner);
406 
407         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH UniswapV2 Router
408         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
409         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
410             .createPair(address(this), _uniswapV2Router.WETH());
411 
412         uniswapV2Router = _uniswapV2Router;
413         uniswapV2Pair   = _uniswapV2Pair;
414 
415         _approve(address(this), address(uniswapV2Router), type(uint256).max);
416 
417         buyFee  = 3;
418         sellFee = 3;
419         walletToWalletTransferFee = 3;
420 
421         marketingWallet = owner();
422 
423         _isExcludedFromFees[owner()] = true;
424         _isExcludedFromFees[address(0xdead)] = true;
425         _isExcludedFromFees[address(this)] = true;
426 
427         _init(owner(), 1e11 ether);
428         swapTokensAtAmount = totalSupply() / 5000;
429     }
430 
431     receive() external payable {
432 
433   	}
434 
435     function enableTrading() public onlyOwner{
436         require(!tradingEnabled, "Trading is already enabled");
437         tradingEnabled = true;
438     }  
439 
440     function claimStuckTokens(address token) external onlyOwner {
441         if (token == address(0x0)) {
442             (bool success,) = msg.sender.call{value: address(this).balance}("");
443             require(success, "Claim failed");
444             return;
445         }
446         IERC20 ERC20token = IERC20(token);
447         uint256 balance = ERC20token.balanceOf(address(this));
448         ERC20token.transfer(msg.sender, balance);
449     }
450 
451     function excludeFromFees(address account, bool excluded) external onlyOwner{
452         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
453         _isExcludedFromFees[account] = excluded;
454 
455         emit ExcludeFromFees(account, excluded);
456     }
457 
458     function isExcludedFromFees(address account) public view returns(bool) {
459         return _isExcludedFromFees[account];
460     }
461 
462     function setBuyFee(uint256 _buyFee) external onlyOwner {
463         require(_buyFee <= 10, "Buy Fee cannot be more than 10%");
464         buyFee = _buyFee;
465         emit BuyFeeUpdated(buyFee);
466     }
467 
468     function setSellFee(uint256 _sellFee) external onlyOwner {
469         require(_sellFee <= 10, "Sell Fee cannot be more than 10%");
470         sellFee = _sellFee;
471         emit SellFeeUpdated(sellFee);
472     }
473 
474     function setWalletToWalletTransferFee(uint256 _walletToWalletTransferFee) external onlyOwner {
475         require(_walletToWalletTransferFee <= 10, "Wallet to Wallet Transfer Fee cannot be more than 10%");
476         walletToWalletTransferFee = _walletToWalletTransferFee;
477         emit WalletToWalletTransferFeeUpdated(walletToWalletTransferFee);
478     }
479 
480     function changeMarketingWallet(address _marketingWallet) external onlyOwner {
481         require(_marketingWallet != address(0), "Marketing wallet cannot be the zero address");
482         marketingWallet = _marketingWallet;
483     }
484     
485     function _transfer(address from,address to,uint256 amount) internal  override {
486         require(from != address(0), "ERC20: transfer from the zero address");
487         require(to != address(0), "ERC20: transfer to the zero address");
488         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not enabled yet");
489 
490         if (!_isExcludedFromFees[from] && amount == balanceOf(from)) {
491             amount -= 1;
492         }
493        
494         if (amount == 0) {
495             super._transfer(from, to, 0);
496             return;
497         }
498 
499 		uint256 contractTokenBalance = balanceOf(address(this));
500 
501         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
502 
503         if (canSwap &&
504             !swapping &&
505             to == uniswapV2Pair
506         ) {
507             swapping = true;
508 
509             if (swapWithLimit) {
510                 contractTokenBalance = swapTokensAtAmount;
511             }
512 
513             swap(contractTokenBalance);        
514 
515             swapping = false;
516         }
517 
518         uint256 _totalFees;
519         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
520             _totalFees = 0;
521         } else if (from == uniswapV2Pair) {
522             _totalFees = buyFee;
523         } else if (to == uniswapV2Pair) {
524             _totalFees = sellFee;
525         } else {
526             _totalFees = walletToWalletTransferFee;
527         }
528 
529         if (_totalFees > 0) {
530             uint256 fees = (amount * _totalFees) / 100;
531             amount = amount - fees;
532             super._transfer(from, address(this), fees);
533         }
534 
535         super._transfer(from, to, amount);
536     }
537 
538     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
539         require(newAmount > totalSupply() / 1000000, "SwapTokensAtAmount must be greater than 0.0001% of total supply");
540         swapTokensAtAmount = newAmount;
541         emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
542     }
543 
544     function setSwapWithLimit(bool _swapWithLimit) external onlyOwner{
545         swapWithLimit = _swapWithLimit;
546         emit SwapWithLimitUpdated(swapWithLimit);
547     }
548 
549     function swap(uint256 tokenAmount) private {
550         uint256 initialBalance = address(this).balance;
551 
552         address[] memory path = new address[](2);
553         path[0] = address(this);
554         path[1] = uniswapV2Router.WETH();
555 
556         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
557             tokenAmount,
558             0,
559             path,
560             address(this),
561             block.timestamp);
562 
563         uint256 newBalance = address(this).balance - initialBalance;
564 
565         bool success = payable(marketingWallet).send(newBalance);
566         if (success) {
567             emit SwapAndSend(tokenAmount, newBalance);
568         }
569     }
570 }