1 // Tg: https://t.me/wrappedpepedogeshibafloki20
2 // Website: https://wrappedpepedogeshibafloki20.com/
3 //
4 // It's time to join the movement and become part of the $META revolution! Fade at your own risk, anon!
5 //
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity 0.8.12;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; 
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
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
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 interface IERC20Metadata is IERC20 {
44 
45     function name() external view returns (string memory);
46 
47     function symbol() external view returns (string memory);
48 
49     function decimals() external view returns (uint8);
50 }
51 
52 
53 contract ERC20 is Context, IERC20, IERC20Metadata {
54     mapping (address => uint256) internal _balances;
55 
56     mapping (address => mapping (address => uint256)) internal _allowances;
57 
58     uint256 private _totalSupply;
59 
60     string private _name;
61     string private _symbol;
62 
63     constructor (string memory name_, string memory symbol_) {
64         _name = name_;
65         _symbol = symbol_;
66     }
67 
68 
69     function name() public view virtual override returns (string memory) {
70         return _name;
71     }
72 
73     function symbol() public view virtual override returns (string memory) {
74         return _symbol;
75     }
76 
77     function decimals() public view virtual override returns (uint8) {
78         return 18;
79     }
80 
81     function totalSupply() public view virtual override returns (uint256) {
82         return _totalSupply;
83     }
84 
85     function balanceOf(address account) public view virtual override returns (uint256) {
86         return _balances[account];
87     }
88 
89     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
90         _transfer(_msgSender(), recipient, amount);
91         return true;
92     }
93 
94     function allowance(address owner, address spender) public view virtual override returns (uint256) {
95         return _allowances[owner][spender];
96     }
97 
98     function approve(address spender, uint256 amount) public virtual override returns (bool) {
99         _approve(_msgSender(), spender, amount);
100         return true;
101     }
102 
103     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
104         _transfer(sender, recipient, amount);
105 
106         uint256 currentAllowance = _allowances[sender][_msgSender()];
107         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
108         _approve(sender, _msgSender(), currentAllowance - amount);
109 
110         return true;
111     }
112 
113     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
114         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
115         return true;
116     }
117 
118     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
119         uint256 currentAllowance = _allowances[_msgSender()][spender];
120         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
121         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
122 
123         return true;
124     }
125 
126     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
127         require(sender != address(0), "ERC20: transfer from the zero address");
128         require(recipient != address(0), "ERC20: transfer to the zero address");
129 
130         _beforeTokenTransfer(sender, recipient, amount);
131 
132         uint256 senderBalance = _balances[sender];
133         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
134         _balances[sender] = senderBalance - amount;
135         _balances[recipient] += amount;
136 
137         emit Transfer(sender, recipient, amount);
138     }
139 
140     function _mint(address account, uint256 amount) internal virtual {
141         require(account != address(0), "ERC20: mint to the zero address");
142 
143         _beforeTokenTransfer(address(0), account, amount);
144 
145         _totalSupply += amount;
146         _balances[account] += amount;
147         emit Transfer(address(0), account, amount);
148     }
149 
150     function _burn(address account, uint256 amount) internal virtual {
151         require(account != address(0), "ERC20: burn from the zero address");
152 
153         _beforeTokenTransfer(account, address(0), amount);
154 
155         uint256 accountBalance = _balances[account];
156         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
157         _balances[account] = accountBalance - amount;
158         _totalSupply -= amount;
159 
160         emit Transfer(account, address(0), amount);
161     }
162 
163     function _approve(address owner, address spender, uint256 amount) internal virtual {
164         require(owner != address(0), "ERC20: approve from the zero address");
165         require(spender != address(0), "ERC20: approve to the zero address");
166 
167         _allowances[owner][spender] = amount;
168         emit Approval(owner, spender, amount);
169     }
170 
171     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
172 }
173 
174 library Address{
175     function sendValue(address payable recipient, uint256 amount) internal {
176         require(address(this).balance >= amount, "Address: insufficient balance");
177 
178         (bool success, ) = recipient.call{value: amount}("");
179         require(success, "Address: unable to send value, recipient may have reverted");
180     }
181 }
182 
183 abstract contract Ownable is Context {
184     address private _owner;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     constructor() {
189         _setOwner(_msgSender());
190     }
191 
192     function owner() public view virtual returns (address) {
193         return _owner;
194     }
195 
196     modifier onlyOwner() {
197         require(owner() == _msgSender(), "Ownable: caller is not the owner");
198         _;
199     }
200 
201     function renounceOwnership() public virtual onlyOwner {
202         _setOwner(address(0));
203     }
204 
205     function transferOwnership(address newOwner) public virtual onlyOwner {
206         require(newOwner != address(0), "Ownable: new owner is the zero address");
207         _setOwner(newOwner);
208     }
209 
210     function _setOwner(address newOwner) private {
211         address oldOwner = _owner;
212         _owner = newOwner;
213         emit OwnershipTransferred(oldOwner, newOwner);
214     }
215 }
216 
217 interface IFactory{
218         function createPair(address tokenA, address tokenB) external returns (address pair);
219 }
220 
221 interface IRouter {
222     function factory() external pure returns (address);
223     function WETH() external pure returns (address);
224     function addLiquidityETH(
225         address token,
226         uint amountTokenDesired,
227         uint amountTokenMin,
228         uint amountETHMin,
229         address to,
230         uint deadline
231     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
232 
233     function swapExactTokensForETHSupportingFeeOnTransferTokens(
234         uint amountIn,
235         uint amountOutMin,
236         address[] calldata path,
237         address to,
238         uint deadline) external;
239 }
240 
241 contract WrappedPepeDogeShibaFloki20 is ERC20, Ownable{
242     using Address for address payable;
243     
244     IRouter public router;
245     address public pair;
246     
247     bool private swapping;
248     bool public swapEnabled;
249     bool public tradingEnabled;
250 
251     uint256 public genesis_block;
252     uint256 public deadblocks = 0;
253     
254     uint256 public swapThreshold = 10_000 * 10e18;
255     uint256 public maxTxAmount = 2_000_000 * 10**18;
256     uint256 public maxWalletAmount = 2_000_000 * 10**18;
257     
258     address public marketingWallet = 0x30f5e026E6fe6fc7c2260f7Fd1C02495D024CbF8;
259     address public devWallet = 0x9FaE9460848E755B543D0129Fa6B4325e4801060;
260     
261     struct Taxes {
262         uint256 marketing;
263         uint256 liquidity; 
264         uint256 dev;
265     }
266     
267     Taxes public taxes = Taxes(20,0,10);
268     Taxes public sellTaxes = Taxes(20,0,10);
269     uint256 public totTax = 30;
270     uint256 public totSellTax = 30;
271     
272     mapping (address => bool) public excludedFromFees;
273     mapping (address => bool) private isBot;
274     
275     modifier inSwap() {
276         if (!swapping) {
277             swapping = true;
278             _;
279             swapping = false;
280         }
281     }
282         
283     constructor() ERC20("WrappedPepeDogeShibaFloki2.0", "META") {
284         _mint(msg.sender, 1e8 * 10 ** decimals());
285         excludedFromFees[msg.sender] = true;
286 
287         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
288         address _pair = IFactory(_router.factory())
289             .createPair(address(this), _router.WETH());
290 
291         router = _router;
292         pair = _pair;
293         excludedFromFees[address(this)] = true;
294         excludedFromFees[marketingWallet] = true;
295         excludedFromFees[devWallet] = true;
296     }
297     
298     function _transfer(address sender, address recipient, uint256 amount) internal override {
299         require(amount > 0, "Transfer amount must be greater than zero");
300         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
301                 
302         
303         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
304             require(tradingEnabled, "Trading not active yet");
305             if(genesis_block + deadblocks > block.number){
306                 if(recipient != pair) isBot[recipient] = true;
307                 if(sender != pair) isBot[sender] = true;
308             }
309             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
310             if(recipient != pair){
311                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
312             }
313         }
314 
315         uint256 fee;
316         
317   
318         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
319         
320  
321         else{
322             if(recipient == pair) fee = amount * totSellTax / 100;
323             else fee = amount * totTax / 100;
324         }
325         
326 
327         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
328 
329         super._transfer(sender, recipient, amount - fee);
330         if(fee > 0) super._transfer(sender, address(this) ,fee);
331 
332     }
333 
334     function swapForFees() private inSwap {
335         uint256 contractBalance = balanceOf(address(this));
336         if (contractBalance >= swapThreshold) {
337 
338                     uint256 denominator = totSellTax * 2;
339             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
340             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
341     
342             uint256 initialBalance = address(this).balance;
343     
344             swapTokensForETH(toSwap);
345     
346             uint256 deltaBalance = address(this).balance - initialBalance;
347             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
348             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
349     
350             if(ethToAddLiquidityWith > 0){
351                 // Add liquidity to Uniswap
352                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
353             }
354     
355             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
356             if(marketingAmt > 0){
357                 payable(marketingWallet).sendValue(marketingAmt);
358             }
359             
360             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
361             if(devAmt > 0){
362                 payable(devWallet).sendValue(devAmt);
363             }
364         }
365     }
366 
367 
368     function swapTokensForETH(uint256 tokenAmount) private {
369         address[] memory path = new address[](2);
370         path[0] = address(this);
371         path[1] = router.WETH();
372 
373         _approve(address(this), address(router), tokenAmount);
374 
375         // make the swap
376         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
377 
378     }
379 
380     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
381         // approve token transfer to cover all possible scenarios
382         _approve(address(this), address(router), tokenAmount);
383 
384         // add the liquidity
385         router.addLiquidityETH{value: bnbAmount}(
386             address(this),
387             tokenAmount,
388             0, // slippage is unavoidable
389             0, // slippage is unavoidable
390             devWallet,
391             block.timestamp
392         );
393     }
394 
395     function setSwapEnabled(bool state) external onlyOwner {
396         swapEnabled = state;
397     }
398 
399     function setSwapThreshold(uint256 new_amount) external onlyOwner {
400         swapThreshold = new_amount;
401     }
402 
403     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
404         require(!tradingEnabled, "Trading already active");
405         tradingEnabled = true;
406         swapEnabled = true;
407         genesis_block = block.number;
408         deadblocks = numOfDeadBlocks;
409     }
410 
411     function setBuyTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
412         taxes = Taxes(_marketing, _liquidity, _dev);
413         totTax = _marketing + _liquidity + _dev;
414     }
415 
416     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
417         sellTaxes = Taxes(_marketing, _liquidity, _dev);
418         totSellTax = _marketing + _liquidity + _dev;
419     }
420     
421     function UpdateMarketingWallet(address newWallet) external onlyOwner{
422         marketingWallet = newWallet;
423     }
424     
425     function UpdateTeamWallet(address newWallet) external onlyOwner{
426         devWallet = newWallet;
427     }
428 
429     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
430         router = _router;
431         pair = _pair;
432     }
433     
434         function addBots(address[] memory isBot_) public onlyOwner {
435         for (uint i = 0; i < isBot_.length; i++) {
436             isBot[isBot_[i]] = true;
437         }
438         }
439     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
440         excludedFromFees[_address] = state;
441     }
442     
443     function updateMaxTxAmount(uint256 amount) external onlyOwner{
444         maxTxAmount = amount * 10**18;
445     }
446     
447     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
448         maxWalletAmount = amount * 10**18;
449     }
450 
451     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
452         IERC20(tokenAddress).transfer(owner(), amount);
453     }
454 
455     function rescueETH(uint256 weiAmount) external onlyOwner{
456         payable(owner()).sendValue(weiAmount);
457     }
458 
459     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
460         uint256 initBalance = address(this).balance;
461         swapTokensForETH(amount);
462         uint256 newBalance = address(this).balance - initBalance;
463         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
464         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
465     }
466 
467     // fallbacks
468     receive() external payable {}
469     
470 }