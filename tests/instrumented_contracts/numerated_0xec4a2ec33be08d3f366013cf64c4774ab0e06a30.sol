1 //   https://t.me/ChainWatcher
2 //   https://twitter.com/chainwatcherapp
3 //   https://chainwatcher.medium.com/
4 
5 // SPDX-License-Identifier: Unlicensed
6 pragma solidity ^0.8.17;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; 
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address account) external view returns (uint256);
23 
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     function allowance(address owner, address spender) external view returns (uint256);
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
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 interface IERC20Metadata is IERC20 {
42 
43     function name() external view returns (string memory);
44 
45     function symbol() external view returns (string memory);
46 
47     function decimals() external view returns (uint8);
48 }
49 
50 
51 contract ERC20 is Context, IERC20, IERC20Metadata {
52     mapping (address => uint256) internal _balances;
53 
54     mapping (address => mapping (address => uint256)) internal _allowances;
55 
56     uint256 private _totalSupply;
57 
58     string private _name;
59     string private _symbol;
60 
61     constructor (string memory name_, string memory symbol_) {
62         _name = name_;
63         _symbol = symbol_;
64     }
65 
66 
67     function name() public view virtual override returns (string memory) {
68         return _name;
69     }
70 
71     function symbol() public view virtual override returns (string memory) {
72         return _symbol;
73     }
74 
75     function decimals() public view virtual override returns (uint8) {
76         return 18;
77     }
78 
79     function totalSupply() public view virtual override returns (uint256) {
80         return _totalSupply;
81     }
82 
83     function balanceOf(address account) public view virtual override returns (uint256) {
84         return _balances[account];
85     }
86 
87     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
88         _transfer(_msgSender(), recipient, amount);
89         return true;
90     }
91 
92     function allowance(address owner, address spender) public view virtual override returns (uint256) {
93         return _allowances[owner][spender];
94     }
95 
96     function approve(address spender, uint256 amount) public virtual override returns (bool) {
97         _approve(_msgSender(), spender, amount);
98         return true;
99     }
100 
101     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
102         _transfer(sender, recipient, amount);
103 
104         uint256 currentAllowance = _allowances[sender][_msgSender()];
105         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
106         _approve(sender, _msgSender(), currentAllowance - amount);
107 
108         return true;
109     }
110 
111     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
112         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
113         return true;
114     }
115 
116     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
117         uint256 currentAllowance = _allowances[_msgSender()][spender];
118         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
119         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
120 
121         return true;
122     }
123 
124     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
125         require(sender != address(0), "ERC20: transfer from the zero address");
126         require(recipient != address(0), "ERC20: transfer to the zero address");
127 
128         _beforeTokenTransfer(sender, recipient, amount);
129 
130         uint256 senderBalance = _balances[sender];
131         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
132         _balances[sender] = senderBalance - amount;
133         _balances[recipient] += amount;
134 
135         emit Transfer(sender, recipient, amount);
136     }
137 
138     function _mint(address account, uint256 amount) internal virtual {
139         require(account != address(0), "ERC20: mint to the zero address");
140 
141         _beforeTokenTransfer(address(0), account, amount);
142 
143         _totalSupply += amount;
144         _balances[account] += amount;
145         emit Transfer(address(0), account, amount);
146     }
147 
148     function _burn(address account, uint256 amount) internal virtual {
149         require(account != address(0), "ERC20: burn from the zero address");
150 
151         _beforeTokenTransfer(account, address(0), amount);
152 
153         uint256 accountBalance = _balances[account];
154         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
155         _balances[account] = accountBalance - amount;
156         _totalSupply -= amount;
157 
158         emit Transfer(account, address(0), amount);
159     }
160 
161     function _approve(address owner, address spender, uint256 amount) internal virtual {
162         require(owner != address(0), "ERC20: approve from the zero address");
163         require(spender != address(0), "ERC20: approve to the zero address");
164 
165         _allowances[owner][spender] = amount;
166         emit Approval(owner, spender, amount);
167     }
168 
169     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
170 }
171 
172 library Address{
173     function sendValue(address payable recipient, uint256 amount) internal {
174         require(address(this).balance >= amount, "Address: insufficient balance");
175 
176         (bool success, ) = recipient.call{value: amount}("");
177         require(success, "Address: unable to send value, recipient may have reverted");
178     }
179 }
180 
181 abstract contract Ownable is Context {
182     address private _owner;
183 
184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186     constructor() {
187         _setOwner(_msgSender());
188     }
189 
190     function owner() public view virtual returns (address) {
191         return _owner;
192     }
193 
194     modifier onlyOwner() {
195         require(owner() == _msgSender(), "Ownable: caller is not the owner");
196         _;
197     }
198 
199     function renounceOwnership() public virtual onlyOwner {
200         _setOwner(address(0));
201     }
202 
203     function transferOwnership(address newOwner) public virtual onlyOwner {
204         require(newOwner != address(0), "Ownable: new owner is the zero address");
205         _setOwner(newOwner);
206     }
207 
208     function _setOwner(address newOwner) private {
209         address oldOwner = _owner;
210         _owner = newOwner;
211         emit OwnershipTransferred(oldOwner, newOwner);
212     }
213 }
214 
215 interface IFactory{
216         function createPair(address tokenA, address tokenB) external returns (address pair);
217 }
218 
219 interface IRouter {
220     function factory() external pure returns (address);
221     function WETH() external pure returns (address);
222     function addLiquidityETH(
223         address token,
224         uint amountTokenDesired,
225         uint amountTokenMin,
226         uint amountETHMin,
227         address to,
228         uint deadline
229     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
230 
231     function swapExactTokensForETHSupportingFeeOnTransferTokens(
232         uint amountIn,
233         uint amountOutMin,
234         address[] calldata path,
235         address to,
236         uint deadline) external;
237 }
238 
239 contract ChainWatcher is ERC20, Ownable{
240     using Address for address payable;
241     
242     IRouter public router;
243     address public pair;
244     
245     bool private swapping;
246     bool public swapEnabled;
247     bool public tradingEnabled;
248 
249     uint256 public genesis_block;
250     uint256 public deadblocks = 0;
251     
252     uint256 public swapThreshold = 100_000 * 10e18;
253     uint256 public maxTxAmount = 20_000_000 * 10**18;
254     uint256 public maxWalletAmount = 20_000_000 * 10**18;
255     
256     address public marketingWallet = 0x5244aDAAbE69cECE261309571cA73B776a776A46;
257     address public devWallet = 0x1d3a6b35627D001Be271E24Cc849e4A31b1aEe75;
258     
259     struct Taxes {
260         uint256 marketing;
261         uint256 liquidity; 
262         uint256 dev;
263     }
264     
265     Taxes public taxes = Taxes(30,0,0);
266     Taxes public sellTaxes = Taxes(60,0,0);
267     uint256 public totTax = 30;
268     uint256 public totSellTax = 60;
269     
270     mapping (address => bool) public excludedFromFees;
271     mapping (address => bool) private isBot;
272     
273     modifier inSwap() {
274         if (!swapping) {
275             swapping = true;
276             _;
277             swapping = false;
278         }
279     } 
280        
281     constructor() ERC20("ChainWatcher", "WATCHER") {
282         _mint(msg.sender, 1e9 * 10 ** decimals());
283         excludedFromFees[msg.sender] = true;
284 
285         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
286         address _pair = IFactory(_router.factory())
287             .createPair(address(this), _router.WETH());
288 
289         router = _router;
290         pair = _pair;
291         excludedFromFees[address(this)] = true;
292         excludedFromFees[marketingWallet] = true;
293         excludedFromFees[devWallet] = true;
294     }
295     
296     function _transfer(address sender, address recipient, uint256 amount) internal override {
297         require(amount > 0, "Transfer amount must be greater than zero");
298         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
299                 
300         
301         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
302             require(tradingEnabled, "Trading not active yet");
303             if(genesis_block + deadblocks > block.number){
304                 if(recipient != pair) isBot[recipient] = true;
305                 if(sender != pair) isBot[sender] = true;
306             }
307             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
308             if(recipient != pair){
309                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
310             }
311         }
312 
313         uint256 fee;
314         
315   
316         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
317         
318  
319         else{
320             if(recipient == pair) fee = amount * totSellTax / 100;
321             else fee = amount * totTax / 100;
322         }
323         
324 
325         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
326 
327         super._transfer(sender, recipient, amount - fee);
328         if(fee > 0) super._transfer(sender, address(this) ,fee);
329 
330     }
331 
332     function swapForFees() private inSwap {
333         uint256 contractBalance = balanceOf(address(this));
334         if (contractBalance >= swapThreshold) {
335 
336                     uint256 denominator = totSellTax * 2;
337             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
338             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
339     
340             uint256 initialBalance = address(this).balance;
341     
342             swapTokensForETH(toSwap);
343     
344             uint256 deltaBalance = address(this).balance - initialBalance;
345             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
346             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
347     
348             if(ethToAddLiquidityWith > 0){
349                 // Add liquidity to Uniswap
350                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
351             }
352     
353             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
354             if(marketingAmt > 0){
355                 payable(marketingWallet).sendValue(marketingAmt);
356             }
357             
358             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
359             if(devAmt > 0){
360                 payable(devWallet).sendValue(devAmt);
361             }
362         }
363     }
364 
365 
366     function swapTokensForETH(uint256 tokenAmount) private {
367         address[] memory path = new address[](2);
368         path[0] = address(this);
369         path[1] = router.WETH();
370 
371         _approve(address(this), address(router), tokenAmount);
372 
373         // make the swap
374         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
375 
376     }
377 
378     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
379         // approve token transfer to cover all possible scenarios
380         _approve(address(this), address(router), tokenAmount);
381 
382         // add the liquidity
383         router.addLiquidityETH{value: bnbAmount}(
384             address(this),
385             tokenAmount,
386             0, // slippage is unavoidable
387             0, // slippage is unavoidable
388             devWallet,
389             block.timestamp
390         );
391     }
392 
393     function setSwapEnabled(bool state) external onlyOwner {
394         swapEnabled = state;
395     }
396 
397     function setSwapThreshold(uint256 new_amount) external onlyOwner {
398         swapThreshold = new_amount;
399     }
400 
401     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
402         require(!tradingEnabled, "Trading already active");
403         tradingEnabled = true;
404         swapEnabled = true;
405         genesis_block = block.number;
406         deadblocks = numOfDeadBlocks;
407     }
408 
409     function setTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
410         taxes = Taxes(_marketing, _liquidity, _dev);
411         totTax = _marketing + _liquidity + _dev;
412     }
413 
414     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
415         sellTaxes = Taxes(_marketing, _liquidity, _dev);
416         totSellTax = _marketing + _liquidity + _dev;
417     }
418     
419     function updateMarketingWallet(address newWallet) external onlyOwner{
420         marketingWallet = newWallet;
421     }
422     
423     function updateDevWallet(address newWallet) external onlyOwner{
424         devWallet = newWallet;
425     }
426 
427     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
428         router = _router;
429         pair = _pair;
430     }
431     
432         function addBots(address[] memory isBot_) public onlyOwner {
433         for (uint i = 0; i < isBot_.length; i++) {
434             isBot[isBot_[i]] = true;
435         }
436         }
437     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
438         excludedFromFees[_address] = state;
439     }
440     
441     function updateMaxTxAmount(uint256 amount) external onlyOwner{
442         maxTxAmount = amount * 10**18;
443     }
444     
445     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
446         maxWalletAmount = amount * 10**18;
447     }
448 
449     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
450         IERC20(tokenAddress).transfer(owner(), amount);
451     }
452 
453     function rescueETH(uint256 weiAmount) external onlyOwner{
454         payable(owner()).sendValue(weiAmount);
455     }
456 
457     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
458         uint256 initBalance = address(this).balance;
459         swapTokensForETH(amount);
460         uint256 newBalance = address(this).balance - initBalance;
461         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
462         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
463     }
464 
465     // fallbacks
466     receive() external payable {}
467     
468 }