1 // Telegram: https://t.me/blockhub_portal
2 // Twitter:  https://twitter.com/blockhub_social
3 // Website:  https://www.blockhub.pro/
4 //
5 // Step into a New Era of Digital Expression
6 //
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.12;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; 
18         return msg.data;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24 
25     function balanceOf(address account) external view returns (uint256);
26 
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33     function transferFrom(
34         address sender,
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 interface IERC20Metadata is IERC20 {
45 
46     function name() external view returns (string memory);
47 
48     function symbol() external view returns (string memory);
49 
50     function decimals() external view returns (uint8);
51 }
52 
53 
54 contract ERC20 is Context, IERC20, IERC20Metadata {
55     mapping (address => uint256) internal _balances;
56 
57     mapping (address => mapping (address => uint256)) internal _allowances;
58 
59     uint256 private _totalSupply;
60 
61     string private _name;
62     string private _symbol;
63 
64     constructor (string memory name_, string memory symbol_) {
65         _name = name_;
66         _symbol = symbol_;
67     }
68 
69 
70     function name() public view virtual override returns (string memory) {
71         return _name;
72     }
73 
74     function symbol() public view virtual override returns (string memory) {
75         return _symbol;
76     }
77 
78     function decimals() public view virtual override returns (uint8) {
79         return 18;
80     }
81 
82     function totalSupply() public view virtual override returns (uint256) {
83         return _totalSupply;
84     }
85 
86     function balanceOf(address account) public view virtual override returns (uint256) {
87         return _balances[account];
88     }
89 
90     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
91         _transfer(_msgSender(), recipient, amount);
92         return true;
93     }
94 
95     function allowance(address owner, address spender) public view virtual override returns (uint256) {
96         return _allowances[owner][spender];
97     }
98 
99     function approve(address spender, uint256 amount) public virtual override returns (bool) {
100         _approve(_msgSender(), spender, amount);
101         return true;
102     }
103 
104     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
105         _transfer(sender, recipient, amount);
106 
107         uint256 currentAllowance = _allowances[sender][_msgSender()];
108         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
109         _approve(sender, _msgSender(), currentAllowance - amount);
110 
111         return true;
112     }
113 
114     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
115         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
116         return true;
117     }
118 
119     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
120         uint256 currentAllowance = _allowances[_msgSender()][spender];
121         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
122         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
123 
124         return true;
125     }
126 
127     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
128         require(sender != address(0), "ERC20: transfer from the zero address");
129         require(recipient != address(0), "ERC20: transfer to the zero address");
130 
131         _beforeTokenTransfer(sender, recipient, amount);
132 
133         uint256 senderBalance = _balances[sender];
134         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
135         _balances[sender] = senderBalance - amount;
136         _balances[recipient] += amount;
137 
138         emit Transfer(sender, recipient, amount);
139     }
140 
141     function _mint(address account, uint256 amount) internal virtual {
142         require(account != address(0), "ERC20: mint to the zero address");
143 
144         _beforeTokenTransfer(address(0), account, amount);
145 
146         _totalSupply += amount;
147         _balances[account] += amount;
148         emit Transfer(address(0), account, amount);
149     }
150 
151     function _burn(address account, uint256 amount) internal virtual {
152         require(account != address(0), "ERC20: burn from the zero address");
153 
154         _beforeTokenTransfer(account, address(0), amount);
155 
156         uint256 accountBalance = _balances[account];
157         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
158         _balances[account] = accountBalance - amount;
159         _totalSupply -= amount;
160 
161         emit Transfer(account, address(0), amount);
162     }
163 
164     function _approve(address owner, address spender, uint256 amount) internal virtual {
165         require(owner != address(0), "ERC20: approve from the zero address");
166         require(spender != address(0), "ERC20: approve to the zero address");
167 
168         _allowances[owner][spender] = amount;
169         emit Approval(owner, spender, amount);
170     }
171 
172     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
173 }
174 
175 library Address{
176     function sendValue(address payable recipient, uint256 amount) internal {
177         require(address(this).balance >= amount, "Address: insufficient balance");
178 
179         (bool success, ) = recipient.call{value: amount}("");
180         require(success, "Address: unable to send value, recipient may have reverted");
181     }
182 }
183 
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     constructor() {
190         _setOwner(_msgSender());
191     }
192 
193     function owner() public view virtual returns (address) {
194         return _owner;
195     }
196 
197     modifier onlyOwner() {
198         require(owner() == _msgSender(), "Ownable: caller is not the owner");
199         _;
200     }
201 
202     function renounceOwnership() public virtual onlyOwner {
203         _setOwner(address(0));
204     }
205 
206     function transferOwnership(address newOwner) public virtual onlyOwner {
207         require(newOwner != address(0), "Ownable: new owner is the zero address");
208         _setOwner(newOwner);
209     }
210 
211     function _setOwner(address newOwner) private {
212         address oldOwner = _owner;
213         _owner = newOwner;
214         emit OwnershipTransferred(oldOwner, newOwner);
215     }
216 }
217 
218 interface IFactory{
219         function createPair(address tokenA, address tokenB) external returns (address pair);
220 }
221 
222 interface IRouter {
223     function factory() external pure returns (address);
224     function WETH() external pure returns (address);
225     function addLiquidityETH(
226         address token,
227         uint amountTokenDesired,
228         uint amountTokenMin,
229         uint amountETHMin,
230         address to,
231         uint deadline
232     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
233 
234     function swapExactTokensForETHSupportingFeeOnTransferTokens(
235         uint amountIn,
236         uint amountOutMin,
237         address[] calldata path,
238         address to,
239         uint deadline) external;
240 }
241 
242 contract BlockHub is ERC20, Ownable{
243     using Address for address payable;
244     
245     IRouter public router;
246     address public pair;
247     
248     bool private swapping;
249     bool public swapEnabled;
250     bool public tradingEnabled;
251 
252     uint256 public genesis_block;
253     uint256 public deadblocks = 0;
254     
255     uint256 public swapThreshold = 10_000 * 10e18;
256     uint256 public maxTxAmount = 2_000_000 * 10**18;
257     uint256 public maxWalletAmount = 2_000_000 * 10**18;
258     
259     address public marketingWallet = 0xC460622c115537f05137C407Ad17b06bb115bE8b;
260     address public devWallet = 0xe2Ea4Ceb5f8608f2956ED7ca13C7301C29431b8E;
261     
262     struct Taxes {
263         uint256 marketing;
264         uint256 liquidity; 
265         uint256 dev;
266     }
267     
268     Taxes public taxes = Taxes(23,0,9);
269     Taxes public sellTaxes = Taxes(19,0,6);
270     uint256 public totTax = 32;
271     uint256 public totSellTax = 25;
272     
273     mapping (address => bool) public excludedFromFees;
274     mapping (address => bool) private isBot;
275     
276     modifier inSwap() {
277         if (!swapping) {
278             swapping = true;
279             _;
280             swapping = false;
281         }
282     }
283         
284     constructor() ERC20("BlockHub", "HUB") {
285         _mint(msg.sender, 1e8 * 10 ** decimals());
286         excludedFromFees[msg.sender] = true;
287 
288         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
289         address _pair = IFactory(_router.factory())
290             .createPair(address(this), _router.WETH());
291 
292         router = _router;
293         pair = _pair;
294         excludedFromFees[address(this)] = true;
295         excludedFromFees[marketingWallet] = true;
296         excludedFromFees[devWallet] = true;
297     }
298     
299     function _transfer(address sender, address recipient, uint256 amount) internal override {
300         require(amount > 0, "Transfer amount must be greater than zero");
301         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
302                 
303         
304         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
305             require(tradingEnabled, "Trading not active yet");
306             if(genesis_block + deadblocks > block.number){
307                 if(recipient != pair) isBot[recipient] = true;
308                 if(sender != pair) isBot[sender] = true;
309             }
310             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
311             if(recipient != pair){
312                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
313             }
314         }
315 
316         uint256 fee;
317         
318   
319         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
320         
321  
322         else{
323             if(recipient == pair) fee = amount * totSellTax / 100;
324             else fee = amount * totTax / 100;
325         }
326         
327 
328         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
329 
330         super._transfer(sender, recipient, amount - fee);
331         if(fee > 0) super._transfer(sender, address(this) ,fee);
332 
333     }
334 
335     function swapForFees() private inSwap {
336         uint256 contractBalance = balanceOf(address(this));
337         if (contractBalance >= swapThreshold) {
338 
339                     uint256 denominator = totSellTax * 2;
340             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
341             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
342     
343             uint256 initialBalance = address(this).balance;
344     
345             swapTokensForETH(toSwap);
346     
347             uint256 deltaBalance = address(this).balance - initialBalance;
348             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
349             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
350     
351             if(ethToAddLiquidityWith > 0){
352                 // Add liquidity to Uniswap
353                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
354             }
355     
356             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
357             if(marketingAmt > 0){
358                 payable(marketingWallet).sendValue(marketingAmt);
359             }
360             
361             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
362             if(devAmt > 0){
363                 payable(devWallet).sendValue(devAmt);
364             }
365         }
366     }
367 
368 
369     function swapTokensForETH(uint256 tokenAmount) private {
370         address[] memory path = new address[](2);
371         path[0] = address(this);
372         path[1] = router.WETH();
373 
374         _approve(address(this), address(router), tokenAmount);
375 
376         // make the swap
377         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
378 
379     }
380 
381     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
382         // approve token transfer to cover all possible scenarios
383         _approve(address(this), address(router), tokenAmount);
384 
385         // add the liquidity
386         router.addLiquidityETH{value: bnbAmount}(
387             address(this),
388             tokenAmount,
389             0, // slippage is unavoidable
390             0, // slippage is unavoidable
391             devWallet,
392             block.timestamp
393         );
394     }
395 
396     function setSwapEnabled(bool state) external onlyOwner {
397         swapEnabled = state;
398     }
399 
400     function setSwapThreshold(uint256 new_amount) external onlyOwner {
401         swapThreshold = new_amount;
402     }
403 
404     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
405         require(!tradingEnabled, "Trading already active");
406         tradingEnabled = true;
407         swapEnabled = true;
408         genesis_block = block.number;
409         deadblocks = numOfDeadBlocks;
410     }
411 
412     function setBuyTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
413         taxes = Taxes(_marketing, _liquidity, _dev);
414         totTax = _marketing + _liquidity + _dev;
415     }
416 
417     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
418         sellTaxes = Taxes(_marketing, _liquidity, _dev);
419         totSellTax = _marketing + _liquidity + _dev;
420     }
421     
422     function updateMarketingWallet(address newWallet) external onlyOwner{
423         marketingWallet = newWallet;
424     }
425     
426     function updateDevWallet(address newWallet) external onlyOwner{
427         devWallet = newWallet;
428     }
429 
430     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
431         router = _router;
432         pair = _pair;
433     }
434     
435         function addBots(address[] memory isBot_) public onlyOwner {
436         for (uint i = 0; i < isBot_.length; i++) {
437             isBot[isBot_[i]] = true;
438         }
439         }
440     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
441         excludedFromFees[_address] = state;
442     }
443     
444     function updateMaxTx(uint256 amount) external onlyOwner{
445         maxTxAmount = amount * 10**18;
446     }
447     
448     function updateMaxWallet(uint256 amount) external onlyOwner{
449         maxWalletAmount = amount * 10**18;
450     }
451 
452     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
453         IERC20(tokenAddress).transfer(owner(), amount);
454     }
455 
456     function rescueETH(uint256 weiAmount) external onlyOwner{
457         payable(owner()).sendValue(weiAmount);
458     }
459 
460     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
461         uint256 initBalance = address(this).balance;
462         swapTokensForETH(amount);
463         uint256 newBalance = address(this).balance - initBalance;
464         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
465         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
466     }
467 
468     // fallbacks
469     receive() external payable {}
470     
471 }