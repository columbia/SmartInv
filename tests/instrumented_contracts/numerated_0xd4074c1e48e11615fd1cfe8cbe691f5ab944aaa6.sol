1 // SPDX-License-Identifier: MIT
2 
3 // Website: https://www.thetrustco.in/
4 
5 pragma solidity 0.8.12;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; 
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 interface IERC20Metadata is IERC20 {
41 
42     function name() external view returns (string memory);
43 
44     function symbol() external view returns (string memory);
45 
46     function decimals() external view returns (uint8);
47 }
48 
49 
50 contract ERC20 is Context, IERC20, IERC20Metadata {
51     mapping (address => uint256) internal _balances;
52 
53     mapping (address => mapping (address => uint256)) internal _allowances;
54 
55     uint256 private _totalSupply;
56 
57     string private _name;
58     string private _symbol;
59 
60     constructor (string memory name_, string memory symbol_) {
61         _name = name_;
62         _symbol = symbol_;
63     }
64 
65 
66     function name() public view virtual override returns (string memory) {
67         return _name;
68     }
69 
70     function symbol() public view virtual override returns (string memory) {
71         return _symbol;
72     }
73 
74     function decimals() public view virtual override returns (uint8) {
75         return 18;
76     }
77 
78     function totalSupply() public view virtual override returns (uint256) {
79         return _totalSupply;
80     }
81 
82     function balanceOf(address account) public view virtual override returns (uint256) {
83         return _balances[account];
84     }
85 
86     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
87         _transfer(_msgSender(), recipient, amount);
88         return true;
89     }
90 
91     function allowance(address owner, address spender) public view virtual override returns (uint256) {
92         return _allowances[owner][spender];
93     }
94 
95     function approve(address spender, uint256 amount) public virtual override returns (bool) {
96         _approve(_msgSender(), spender, amount);
97         return true;
98     }
99 
100     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
101         _transfer(sender, recipient, amount);
102 
103         uint256 currentAllowance = _allowances[sender][_msgSender()];
104         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
105         _approve(sender, _msgSender(), currentAllowance - amount);
106 
107         return true;
108     }
109 
110     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
111         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
112         return true;
113     }
114 
115     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
116         uint256 currentAllowance = _allowances[_msgSender()][spender];
117         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
118         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
119 
120         return true;
121     }
122 
123     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
124         require(sender != address(0), "ERC20: transfer from the zero address");
125         require(recipient != address(0), "ERC20: transfer to the zero address");
126 
127         _beforeTokenTransfer(sender, recipient, amount);
128 
129         uint256 senderBalance = _balances[sender];
130         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
131         _balances[sender] = senderBalance - amount;
132         _balances[recipient] += amount;
133 
134         emit Transfer(sender, recipient, amount);
135     }
136 
137     function _mint(address account, uint256 amount) internal virtual {
138         require(account != address(0), "ERC20: mint to the zero address");
139 
140         _beforeTokenTransfer(address(0), account, amount);
141 
142         _totalSupply += amount;
143         _balances[account] += amount;
144         emit Transfer(address(0), account, amount);
145     }
146 
147     function _burn(address account, uint256 amount) internal virtual {
148         require(account != address(0), "ERC20: burn from the zero address");
149 
150         _beforeTokenTransfer(account, address(0), amount);
151 
152         uint256 accountBalance = _balances[account];
153         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
154         _balances[account] = accountBalance - amount;
155         _totalSupply -= amount;
156 
157         emit Transfer(account, address(0), amount);
158     }
159 
160     function _approve(address owner, address spender, uint256 amount) internal virtual {
161         require(owner != address(0), "ERC20: approve from the zero address");
162         require(spender != address(0), "ERC20: approve to the zero address");
163 
164         _allowances[owner][spender] = amount;
165         emit Approval(owner, spender, amount);
166     }
167 
168     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
169 }
170 
171 library Address{
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(address(this).balance >= amount, "Address: insufficient balance");
174 
175         (bool success, ) = recipient.call{value: amount}("");
176         require(success, "Address: unable to send value, recipient may have reverted");
177     }
178 }
179 
180 abstract contract Ownable is Context {
181     address private _owner;
182 
183     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
184 
185     constructor() {
186         _setOwner(_msgSender());
187     }
188 
189     function owner() public view virtual returns (address) {
190         return _owner;
191     }
192 
193     modifier onlyOwner() {
194         require(owner() == _msgSender(), "Ownable: caller is not the owner");
195         _;
196     }
197 
198     function renounceOwnership() public virtual onlyOwner {
199         _setOwner(address(0));
200     }
201 
202     function transferOwnership(address newOwner) public virtual onlyOwner {
203         require(newOwner != address(0), "Ownable: new owner is the zero address");
204         _setOwner(newOwner);
205     }
206 
207     function _setOwner(address newOwner) private {
208         address oldOwner = _owner;
209         _owner = newOwner;
210         emit OwnershipTransferred(oldOwner, newOwner);
211     }
212 }
213 
214 interface IFactory{
215         function createPair(address tokenA, address tokenB) external returns (address pair);
216 }
217 
218 interface IRouter {
219     function factory() external pure returns (address);
220     function WETH() external pure returns (address);
221     function addLiquidityETH(
222         address token,
223         uint amountTokenDesired,
224         uint amountTokenMin,
225         uint amountETHMin,
226         address to,
227         uint deadline
228     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
229 
230     function swapExactTokensForETHSupportingFeeOnTransferTokens(
231         uint amountIn,
232         uint amountOutMin,
233         address[] calldata path,
234         address to,
235         uint deadline) external;
236 }
237 
238 contract Trust is ERC20, Ownable{
239     using Address for address payable;
240     
241     IRouter public router;
242     address public pair;
243     
244     bool private swapping;
245     bool public swapEnabled;
246     bool public tradingEnabled;
247 
248     uint256 public genesis_block;
249     uint256 public deadblocks = 0;
250     
251     uint256 public swapThreshold;
252     uint256 public maxTxAmount;
253     uint256 public maxWalletAmount;
254     
255     address public marketingWallet = 0x84874cD121274690D972137e65C8AcA0937d0Af6;
256     address public devWallet = 0x84874cD121274690D972137e65C8AcA0937d0Af6;
257     
258     struct Taxes {
259         uint256 marketing;
260         uint256 liquidity; 
261     }
262     
263     Taxes public taxes = Taxes(15,0);
264     Taxes public sellTaxes = Taxes(30,0);
265     uint256 public totTax = 15;
266     uint256 public totSellTax = 30;
267     
268     mapping (address => bool) public excludedFromFees;
269     mapping (address => bool) private isBot;
270     
271     modifier inSwap() {
272         if (!swapping) {
273             swapping = true;
274             _;
275             swapping = false;
276         }
277     }
278         
279     constructor() ERC20("TRUST", "TRUST") {
280         _mint(msg.sender, 69e9 * 10 ** decimals());
281         excludedFromFees[msg.sender] = true;
282 
283         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
284         address _pair = IFactory(_router.factory())
285             .createPair(address(this), _router.WETH());
286 
287         router = _router;
288         pair = _pair;
289         excludedFromFees[address(this)] = true;
290         excludedFromFees[marketingWallet] = true;
291         excludedFromFees[devWallet] = true;
292 
293         swapThreshold = totalSupply() * 1 / 10000;// 0.01% 
294         maxTxAmount = totalSupply() * 2 / 100; // 2% maxTransactionAmountTxn;
295         maxWalletAmount = totalSupply() * 2 / 100; // 2% maxWallet
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
338             uint256 denominator = totSellTax * 2;
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
359         }
360     }
361 
362 
363     function swapTokensForETH(uint256 tokenAmount) private {
364         address[] memory path = new address[](2);
365         path[0] = address(this);
366         path[1] = router.WETH();
367 
368         _approve(address(this), address(router), tokenAmount);
369 
370         // make the swap
371         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
372 
373     }
374 
375     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
376         // approve token transfer to cover all possible scenarios
377         _approve(address(this), address(router), tokenAmount);
378 
379         // add the liquidity
380         router.addLiquidityETH{value: bnbAmount}(
381             address(this),
382             tokenAmount,
383             0, // slippage is unavoidable
384             0, // slippage is unavoidable
385             devWallet,
386             block.timestamp
387         );
388     }
389 
390     function setSwapEnabled(bool state) external onlyOwner {
391         swapEnabled = state;
392     }
393 
394     function setSwapThreshold(uint256 new_amount) external onlyOwner {
395         swapThreshold = new_amount;
396     }
397 
398     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
399         require(!tradingEnabled, "Trading already active");
400         tradingEnabled = true;
401         swapEnabled = true;
402         genesis_block = block.number;
403         deadblocks = numOfDeadBlocks;
404     }
405 
406     function setBuyTaxes(uint256 _marketing, uint256 _liquidity) external onlyOwner{
407         taxes = Taxes(_marketing, _liquidity);
408         totTax = _marketing + _liquidity;
409     }
410 
411     function setSellTaxes(uint256 _marketing, uint256 _liquidity) external onlyOwner{
412         sellTaxes = Taxes(_marketing, _liquidity);
413         totSellTax = _marketing + _liquidity ;
414     }
415     
416     function updateMarketingWallet(address newWallet) external onlyOwner{
417         marketingWallet = newWallet;
418     }
419     
420     function updatePeppaWallet(address newWallet) external onlyOwner{
421         devWallet = newWallet;
422     }
423 
424     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
425         router = _router;
426         pair = _pair;
427     }
428     
429     function addBots(address[] memory isBot_) public onlyOwner {
430         for (uint i = 0; i < isBot_.length; i++) {
431             isBot[isBot_[i]] = true;
432         }
433     }
434     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
435         excludedFromFees[_address] = state;
436     }
437     
438     function updateMaxTxAmount(uint256 _percen) external onlyOwner{
439         maxTxAmount = totalSupply() * _percen / 100;
440     }
441     
442     function updateMaxWalletAmount(uint256 _percen) external onlyOwner{
443         maxWalletAmount = totalSupply() * _percen / 100;
444     }
445 
446     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
447         IERC20(tokenAddress).transfer(owner(), amount);
448     }
449 
450     function rescueETH(uint256 weiAmount) external onlyOwner{
451         payable(owner()).sendValue(weiAmount);
452     }
453 
454     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
455         uint256 initBalance = address(this).balance;
456         swapTokensForETH(amount);
457         uint256 newBalance = address(this).balance - initBalance;
458         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
459         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
460     }
461 
462     // fallbacks
463     receive() external payable {}
464     
465 }