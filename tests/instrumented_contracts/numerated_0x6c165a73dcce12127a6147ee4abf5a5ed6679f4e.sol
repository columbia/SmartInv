1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.13;
3 
4 abstract contract Context {
5 
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor () {
22         address msgSender = _msgSender();
23         _owner = msgSender;
24         emit OwnershipTransferred(address(0), msgSender);
25     }
26 
27     function owner() public view returns (address) {
28         return _owner;
29     }   
30     
31     modifier onlyOwner() {
32         require(_owner == _msgSender(), "Ownable: caller is not the owner");
33         _;
34     }
35 
36     function renounceOwnership() public virtual onlyOwner {
37         emit OwnershipTransferred(_owner, address(0));
38         _owner = address(0);
39     }
40 
41     function transferOwnership(address newOwner) public virtual onlyOwner {
42         require(newOwner != address(0), "Ownable: new owner is the zero address");
43         emit OwnershipTransferred(_owner, newOwner);
44         _owner = newOwner;
45     }
46 }
47 
48 interface IDexRouter {
49     function factory() external pure returns (address);
50     function WETH() external pure returns (address);
51     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
52     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
53     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
54     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
55     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
56 }
57 
58 interface IDexFactory {
59     function getPair(address tokenA, address tokenB) external view returns (address pair);
60     function createPair(address tokenA, address tokenB) external returns (address pair);
61 }
62 
63 interface IERC20 {
64     function totalSupply() external view returns (uint256);
65     function balanceOf(address account) external view returns (uint256);
66     function transfer(address recipient, uint256 amount) external returns (bool);
67     function allowance(address owner, address spender) external view returns (uint256);
68     function approve(address spender, uint256 amount) external returns (bool);
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70     
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract DROIDS is Context, IERC20, Ownable {
76     
77     string constant private _name = "DROIDS";
78     string constant private _symbol = "ROIDS";
79     uint8 constant private _decimals = 18;
80 
81     address public constant  deadAddress = 0x000000000000000000000000000000000000dEaD;
82     address payable public marketingWalletAddress = payable(0x6EdC33ba017bf633c5cD576f2a51E81ad5E84D19); // Marketing Address
83     
84     mapping (address => uint256) private balances;
85     mapping (address => mapping (address => uint256)) private allowances;
86     
87     mapping (address => bool) public isExcludedFromFee;
88     mapping (address => bool) public isMarketPair;
89     mapping (address => bool) public isEarlyBuyer;
90     mapping (address => bool) public isTxLimitExempt;
91     mapping (address => bool) public isWalletLimitExempt;
92 
93     uint256 public buyTax = 50;
94     uint256 public sellTax = 50;
95 
96     uint256 constant private _totalSupply = 1 * 10**9 * 10**_decimals;
97     uint256 public swapThreshold = 250000 * 10**_decimals; 
98     uint256 public maxTxAmount = 10 * 10**6 * 10**_decimals;
99     uint256 public walletMax = 20 * 10**6 * 10**_decimals;
100 
101     IDexRouter public dexRouter;
102     address public lpPair;
103     
104     bool private isInSwap;
105     bool public swapEnabled = true;
106     bool public swapByLimitOnly = false;
107     bool public launched = false;
108     bool public checkWalletLimit = true;
109 
110     event SwapSettingsUpdated(bool swapEnabled_, uint256 swapThreshold_, bool swapByLimitOnly_);
111     event SwapTokensForETH(uint256 amountIn, address[] path);
112     event AccountWhitelisted(address account, bool feeExempt, bool walletLimitExempt, bool txLimitExempt);
113     event RouterVersionChanged(address newRouterAddress);
114     event TaxesChanged(uint256 newBuyTax, uint256 newSellTax);
115     event TaxDistributionChanged(uint256 newLpShare, uint256 newMarketingShare, uint256 newOperationsShare);
116     event MarketingWalletChanged(address marketingWalletAddress_);
117     event OperationsWalletChanged(address operationsWalletAddress_);
118     event AutoLiquidityReceiverChanged(address autoLiquidityReceiver_);
119     event EarlyBuyerUpdated(address account, bool isEarlyBuyer_);
120     event MarketPairUpdated(address account, bool isMarketPair_);
121     event WalletLimitChanged(uint256 walletMax_);
122     event MaxTxAmountChanged(uint256 maxTxAmount_);
123     event MaxWalletCheckChanged(bool checkWalletLimit_);
124 
125     modifier lockTheSwap {
126         isInSwap = true;
127         _;
128         isInSwap = false;
129     }
130     
131     constructor () {
132         
133         dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
134         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
135 
136         isExcludedFromFee[owner()] = true;
137         isExcludedFromFee[address(this)] = true;
138         isExcludedFromFee[address(marketingWalletAddress)] = true;
139 
140         isTxLimitExempt[owner()] = true;
141         isTxLimitExempt[address(this)] = true;
142         isTxLimitExempt[address(marketingWalletAddress)] = true;
143 
144         isWalletLimitExempt[owner()] = true;
145         isWalletLimitExempt[address(lpPair)] = true;
146         isWalletLimitExempt[address(this)] = true;
147         isWalletLimitExempt[address(marketingWalletAddress)] = true;
148         
149         isMarketPair[address(lpPair)] = true;
150 
151         allowances[address(this)][address(dexRouter)] = _totalSupply;
152         balances[_msgSender()] = _totalSupply;
153         emit Transfer(address(0), _msgSender(), _totalSupply);
154     }
155 
156      //to receive ETH from dexRouter when swapping
157     receive() external payable {}
158 
159     function name() public pure returns (string memory) {
160         return _name;
161     }
162 
163     function symbol() public pure returns (string memory) {
164         return _symbol;
165     }
166 
167     function decimals() public pure returns (uint8) {
168         return _decimals;
169     }
170 
171     function totalSupply() public pure override returns (uint256) {
172         return _totalSupply;
173     }
174     
175     function getCirculatingSupply() public view returns (uint256) {
176         return _totalSupply - balanceOf(deadAddress);
177     }
178 
179     function balanceOf(address account) public view override returns (uint256) {
180         return balances[account];
181     }
182 
183     function allowance(address owner_, address spender) public view override returns (uint256) {
184         return allowances[owner_][spender];
185     }
186 
187     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
188         _approve(_msgSender(), spender, allowances[_msgSender()][spender] + addedValue);
189         return true;
190     }
191 
192     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
193         _approve(_msgSender(), spender, allowances[_msgSender()][spender] - subtractedValue);
194         return true;
195     }
196 
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201 
202     function _approve(address owner_, address spender, uint256 amount) private {
203         require(owner_ != address(0), "ERC20: approve from the zero address");
204         require(spender != address(0), "ERC20: approve to the zero address");
205 
206         allowances[owner_][spender] = amount;
207         emit Approval(owner_, spender, amount);
208     }
209 
210     function transfer(address recipient, uint256 amount) public override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(sender, _msgSender(), allowances[sender][_msgSender()] - amount);
218         return true;
219     }
220     
221     function updateRouter(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
222         IDexRouter dexRouter_ = IDexRouter(newRouterAddress); 
223         newPairAddress = IDexFactory(dexRouter_.factory()).getPair(address(this), dexRouter_.WETH());
224 
225         if(newPairAddress == address(0)) { //Create If Doesnt exist
226             newPairAddress = IDexFactory(dexRouter_.factory()).
227                                 createPair(address(this), dexRouter_.WETH());
228         }
229 
230         lpPair = newPairAddress; //Set new pair address
231         dexRouter = dexRouter_; //Set new router address
232 
233         isWalletLimitExempt[address(lpPair)] = true;
234         isMarketPair[address(lpPair)] = true;
235         emit RouterVersionChanged(newRouterAddress);
236     }
237 
238     function setLaunchStatus(bool launched_) public onlyOwner {
239         launched = launched_;
240     }
241 
242     function setIsEarlyBuyer(address account, bool isEarlyBuyer_) public onlyOwner {
243         isEarlyBuyer[account] = isEarlyBuyer_;
244         emit EarlyBuyerUpdated(account, isEarlyBuyer_);
245     }
246 
247     function setMarketPairStatus(address account, bool isMarketPair_) public onlyOwner {
248         isMarketPair[account] = isMarketPair_;
249         emit MarketPairUpdated(account, isMarketPair_);
250     }
251     
252     function setTaxes(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
253         require(newBuyTax <= 300, "Cannot exceed 30%");
254         require(newSellTax <= 300, "Cannot exceed 30%");
255         buyTax = newBuyTax;
256         sellTax = newSellTax;
257         emit TaxesChanged(newBuyTax, newSellTax);
258     }
259 
260     function setMaxTxAmount(uint256 maxTxAmount_) external onlyOwner {
261         maxTxAmount = maxTxAmount_;
262         emit MaxTxAmountChanged(maxTxAmount_);
263     }
264 
265     function setWalletLimit(uint256 walletMax_) external onlyOwner {
266         walletMax  = walletMax_;
267         emit WalletLimitChanged(walletMax_);
268     }
269 
270     function enableDisableWalletLimit(bool checkWalletLimit_) external onlyOwner {
271         checkWalletLimit = checkWalletLimit_;
272         emit MaxWalletCheckChanged(checkWalletLimit_);
273     }
274 
275     function whitelistAccount(address account, bool feeExempt, bool walletLimitExempt, bool txLimitExempt) public onlyOwner {
276         isExcludedFromFee[account] = feeExempt;
277         isWalletLimitExempt[account] = walletLimitExempt;
278         isTxLimitExempt[account] = txLimitExempt;
279         emit AccountWhitelisted(account, feeExempt, walletLimitExempt, txLimitExempt);
280     }
281 
282     function updateSwapSettings(bool swapEnabled_, uint256 swapThreshold_, bool swapByLimitOnly_) public onlyOwner {
283         swapEnabled = swapEnabled_;
284         swapThreshold = swapThreshold_;
285         swapByLimitOnly = swapByLimitOnly_;
286         emit SwapSettingsUpdated(swapEnabled_, swapThreshold_, swapByLimitOnly_);
287     }
288 
289     function setMarketingWalletAddress(address marketingWalletAddress_) external onlyOwner {
290         require(marketingWalletAddress_ != address(0), "New address cannot be zero address");
291         marketingWalletAddress = payable(marketingWalletAddress_);
292         emit MarketingWalletChanged(marketingWalletAddress_);
293     }
294 
295     function transferToAddressETH(address payable recipient, uint256 amount) private {
296         bool success;
297         (success,) = address(recipient).call{value: amount}("");
298     }
299 
300     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
301         if(isInSwap) { 
302             return _basicTransfer(sender, recipient, amount); 
303         } else {
304             require(sender != address(0), "ERC20: transfer from the zero address");
305             require(recipient != address(0), "ERC20: transfer to the zero address");
306             require(!isEarlyBuyer[sender] && !isEarlyBuyer[recipient], "To/from address is blacklisted!");
307 
308             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
309                 require(launched, "Not Launched.");
310                 if(isMarketPair[sender] || isMarketPair[recipient]) {
311                     require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
312                 }
313             }
314 
315             bool isTaxFree = ((!isMarketPair[sender] && !isMarketPair[recipient]) || 
316                                 isExcludedFromFee[sender] || isExcludedFromFee[recipient]);
317 
318             if (!isTaxFree && !isMarketPair[sender] && swapEnabled && !isInSwap) 
319             {
320                 uint256 contractTokenBalance = balanceOf(address(this));
321                 bool overMinimumTokenBalance = contractTokenBalance >= swapThreshold;
322                 if(overMinimumTokenBalance) {
323                     if(swapByLimitOnly)
324                         contractTokenBalance = swapThreshold;
325                     swapAndLiquify(contractTokenBalance);    
326                 }
327             }
328 
329             balances[sender] = balances[sender] - amount;
330 
331             uint256 finalAmount = isTaxFree ? amount : takeFee(sender, recipient, amount);
332 
333             if(checkWalletLimit && !isWalletLimitExempt[recipient])
334                 require((balanceOf(recipient) + finalAmount) <= walletMax);
335 
336             balances[recipient] = balances[recipient] + finalAmount;
337 
338             emit Transfer(sender, recipient, finalAmount);
339             return true;
340         }
341     }
342 
343     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
344         balances[sender] = balances[sender] - amount;
345         balances[recipient] = balances[recipient] + amount;
346         emit Transfer(sender, recipient, amount);
347         return true;
348     }
349 
350     function swapAndLiquify(uint256 tokensForSwap) private lockTheSwap {
351         swapTokensForEth(tokensForSwap);
352         uint256 amountReceived = address(this).balance;
353 
354         if(amountReceived > 0) {
355             transferToAddressETH(marketingWalletAddress, amountReceived);
356         }
357     }
358 
359     function swapTokensForEth(uint256 tokenAmount) private {
360         // generate the uniswap pair path of token -> weth
361         address[] memory path = new address[](2);
362         path[0] = address(this);
363         path[1] = dexRouter.WETH();
364 
365         _approve(address(this), address(dexRouter), tokenAmount);
366 
367         // make the swap
368         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
369             tokenAmount,
370             0, // accept any amount of ETH
371             path,
372             address(this), // The contract
373             block.timestamp
374         );
375         
376         emit SwapTokensForETH(tokenAmount, path);
377     }
378 
379     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
380         uint256 feeAmount = (amount * buyTax) / 1000;   
381         address feeReceiver = address(this);
382 
383         if(isMarketPair[recipient]) {
384             feeAmount = (amount * sellTax) / 1000;   
385         }
386         
387         if(feeAmount > 0) {
388             balances[feeReceiver] = balances[feeReceiver] + feeAmount;
389             emit Transfer(sender, feeReceiver, feeAmount);
390         }
391 
392         return amount - feeAmount;
393     }
394     
395     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
396         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
397         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
398         for(uint256 i = 0; i < wallets.length; i++){
399             _basicTransfer(msg.sender, wallets[i], amountsInTokens[i]);
400         }
401     }
402     
403 }