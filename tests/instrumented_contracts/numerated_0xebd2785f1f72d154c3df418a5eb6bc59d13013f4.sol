1 // SPDX-License-Identifier: MIT
2 
3 /**
4 http://www.hopiumerc.net/
5 https://t.me/HopiumETH
6 https://twitter.com/hopiumethereum
7 
8 */
9 
10 pragma solidity 0.8.12;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; 
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address account) external view returns (uint256);
27 
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 interface IERC20Metadata is IERC20 {
46 
47     function name() external view returns (string memory);
48 
49     function symbol() external view returns (string memory);
50 
51     function decimals() external view returns (uint8);
52 }
53 
54 
55 contract ERC20 is Context, IERC20, IERC20Metadata {
56     mapping (address => uint256) internal _balances;
57 
58     mapping (address => mapping (address => uint256)) internal _allowances;
59 
60     uint256 private _totalSupply;
61 
62     string private _name;
63     string private _symbol;
64 
65     constructor (string memory name_, string memory symbol_) {
66         _name = name_;
67         _symbol = symbol_;
68     }
69 
70 
71     function name() public view virtual override returns (string memory) {
72         return _name;
73     }
74 
75     function symbol() public view virtual override returns (string memory) {
76         return _symbol;
77     }
78 
79     function decimals() public view virtual override returns (uint8) {
80         return 18;
81     }
82 
83     function totalSupply() public view virtual override returns (uint256) {
84         return _totalSupply;
85     }
86 
87     function balanceOf(address account) public view virtual override returns (uint256) {
88         return _balances[account];
89     }
90 
91     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
92         _transfer(_msgSender(), recipient, amount);
93         return true;
94     }
95 
96     function allowance(address owner, address spender) public view virtual override returns (uint256) {
97         return _allowances[owner][spender];
98     }
99 
100     function approve(address spender, uint256 amount) public virtual override returns (bool) {
101         _approve(_msgSender(), spender, amount);
102         return true;
103     }
104 
105     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
106         _transfer(sender, recipient, amount);
107 
108         uint256 currentAllowance = _allowances[sender][_msgSender()];
109         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
110         _approve(sender, _msgSender(), currentAllowance - amount);
111 
112         return true;
113     }
114 
115     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
116         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
117         return true;
118     }
119 
120     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
121         uint256 currentAllowance = _allowances[_msgSender()][spender];
122         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
123         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
124 
125         return true;
126     }
127 
128     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
129         require(sender != address(0), "ERC20: transfer from the zero address");
130         require(recipient != address(0), "ERC20: transfer to the zero address");
131 
132         _beforeTokenTransfer(sender, recipient, amount);
133 
134         uint256 senderBalance = _balances[sender];
135         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
136         _balances[sender] = senderBalance - amount;
137         _balances[recipient] += amount;
138 
139         emit Transfer(sender, recipient, amount);
140     }
141 
142     function _mint(address account, uint256 amount) internal virtual {
143         require(account != address(0), "ERC20: mint to the zero address");
144 
145         _beforeTokenTransfer(address(0), account, amount);
146 
147         _totalSupply += amount;
148         _balances[account] += amount;
149         emit Transfer(address(0), account, amount);
150     }
151 
152     function _burn(address account, uint256 amount) internal virtual {
153         require(account != address(0), "ERC20: burn from the zero address");
154 
155         _beforeTokenTransfer(account, address(0), amount);
156 
157         uint256 accountBalance = _balances[account];
158         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
159         _balances[account] = accountBalance - amount;
160         _totalSupply -= amount;
161 
162         emit Transfer(account, address(0), amount);
163     }
164 
165     function _approve(address owner, address spender, uint256 amount) internal virtual {
166         require(owner != address(0), "ERC20: approve from the zero address");
167         require(spender != address(0), "ERC20: approve to the zero address");
168 
169         _allowances[owner][spender] = amount;
170         emit Approval(owner, spender, amount);
171     }
172 
173     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
174 }
175 
176 library Address{
177     function sendValue(address payable recipient, uint256 amount) internal {
178         require(address(this).balance >= amount, "Address: insufficient balance");
179 
180         (bool success, ) = recipient.call{value: amount}("");
181         require(success, "Address: unable to send value, recipient may have reverted");
182     }
183 }
184 
185 abstract contract Ownable is Context {
186     address private _owner;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     constructor() {
191         _setOwner(_msgSender());
192     }
193 
194     function owner() public view virtual returns (address) {
195         return _owner;
196     }
197 
198     modifier onlyOwner() {
199         require(owner() == _msgSender(), "Ownable: caller is not the owner");
200         _;
201     }
202 
203     function renounceOwnership() public virtual onlyOwner {
204         _setOwner(address(0));
205     }
206 
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         _setOwner(newOwner);
210     }
211 
212     function _setOwner(address newOwner) private {
213         address oldOwner = _owner;
214         _owner = newOwner;
215         emit OwnershipTransferred(oldOwner, newOwner);
216     }
217 }
218 
219 interface IFactory{
220         function createPair(address tokenA, address tokenB) external returns (address pair);
221 }
222 
223 interface IRouter {
224     function factory() external pure returns (address);
225     function WETH() external pure returns (address);
226     function addLiquidityETH(
227         address token,
228         uint amountTokenDesired,
229         uint amountTokenMin,
230         uint amountETHMin,
231         address to,
232         uint deadline
233     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
234 
235     function swapExactTokensForETHSupportingFeeOnTransferTokens(
236         uint amountIn,
237         uint amountOutMin,
238         address[] calldata path,
239         address to,
240         uint deadline) external;
241 }
242 
243 contract Hopium is ERC20, Ownable{
244     using Address for address payable;
245     
246     IRouter public router;
247     address public pair;
248     
249     bool private swapping;
250     bool public swapEnabled;
251     bool public tradingEnabled;
252 
253     uint256 public genesis_block;
254     uint256 public deadblocks = 0;
255     
256     uint256 public swapThreshold = 10_000 * 10e18;
257     uint256 public maxTxAmount = 1_000_000 * 10**18;
258     uint256 public maxWalletAmount = 1_000_000 * 10**18;
259     
260     address public marketingWallet = 0x58224959eb01f75BbC866EcF5Dae7fB76D9aCC98;
261     address private EcoWallet = 0x8122E948B45c9D3FFe850184E58A4bb07180bDd8;
262     
263     struct Taxes {
264         uint256 marketing;
265         uint256 liquidity; 
266         uint256 dev;
267     }
268     
269     Taxes public taxes = Taxes(15,0,15);
270     Taxes public sellTaxes = Taxes(20,0,20);
271     uint256 public totTax = 30;
272     uint256 public totSellTax = 40;
273     
274     mapping (address => bool) public excludedFromFees;
275     mapping (address => bool) private isBot;
276     
277     modifier inSwap() {
278         if (!swapping) {
279             swapping = true;
280             _;
281             swapping = false;
282         }
283     }
284         
285     constructor() ERC20("Hopium", "Hopium") {
286         _mint(msg.sender, 1e8 * 10 ** decimals());
287         excludedFromFees[msg.sender] = true;
288 
289         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
290         address _pair = IFactory(_router.factory())
291             .createPair(address(this), _router.WETH());
292 
293         router = _router;
294         pair = _pair;
295         excludedFromFees[address(this)] = true;
296         excludedFromFees[marketingWallet] = true;
297         excludedFromFees[EcoWallet] = true;
298     }
299     
300     function _transfer(address sender, address recipient, uint256 amount) internal override {
301         require(amount > 0, "Transfer amount must be greater than zero");
302         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
303                 
304         
305         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
306             require(tradingEnabled, "Trading not active yet");
307             if(genesis_block + deadblocks > block.number){
308                 if(recipient != pair) isBot[recipient] = true;
309                 if(sender != pair) isBot[sender] = true;
310             }
311             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
312             if(recipient != pair){
313                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
314             }
315         }
316 
317         uint256 fee;
318         
319   
320         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
321         
322  
323         else{
324             if(recipient == pair) fee = amount * totSellTax / 100;
325             else fee = amount * totTax / 100;
326         }
327         
328 
329         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
330 
331         super._transfer(sender, recipient, amount - fee);
332         if(fee > 0) super._transfer(sender, address(this) ,fee);
333 
334     }
335 
336     function swapForFees() private inSwap {
337         uint256 contractBalance = balanceOf(address(this));
338         if (contractBalance >= swapThreshold) {
339 
340                     uint256 denominator = totSellTax * 2;
341             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
342             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
343     
344             uint256 initialBalance = address(this).balance;
345     
346             swapTokensForETH(toSwap);
347     
348             uint256 deltaBalance = address(this).balance - initialBalance;
349             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
350             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
351     
352             if(ethToAddLiquidityWith > 0){
353                 // Add liquidity to Uniswap
354                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
355             }
356     
357             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
358             if(marketingAmt > 0){
359                 payable(marketingWallet).sendValue(marketingAmt);
360             }
361             
362             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
363             if(devAmt > 0){
364                 payable(EcoWallet).sendValue(devAmt);
365             }
366         }
367     }
368 
369 
370     function swapTokensForETH(uint256 tokenAmount) private {
371         address[] memory path = new address[](2);
372         path[0] = address(this);
373         path[1] = router.WETH();
374 
375         _approve(address(this), address(router), tokenAmount);
376 
377         // make the swap
378         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
379 
380     }
381 
382     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
383         // approve token transfer to cover all possible scenarios
384         _approve(address(this), address(router), tokenAmount);
385 
386         // add the liquidity
387         router.addLiquidityETH{value: bnbAmount}(
388             address(this),
389             tokenAmount,
390             0, // slippage is unavoidable
391             0, // slippage is unavoidable
392             EcoWallet,
393             block.timestamp
394         );
395     }
396 
397     function setSwapEnabled(bool state) external onlyOwner {
398         swapEnabled = state;
399     }
400 
401     function setSwapThreshold(uint256 new_amount) external onlyOwner {
402         swapThreshold = new_amount;
403     }
404 
405     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
406         require(!tradingEnabled, "Trading already active");
407         tradingEnabled = true;
408         swapEnabled = true;
409         genesis_block = block.number;
410         deadblocks = numOfDeadBlocks;
411     }
412 
413     function setBuyTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
414         taxes = Taxes(_marketing, _liquidity, _dev);
415         totTax = _marketing + _liquidity + _dev;
416     }
417 
418     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
419         sellTaxes = Taxes(_marketing, _liquidity, _dev);
420         totSellTax = _marketing + _liquidity + _dev;
421     }
422     
423     function updateMarketingWallet(address newWallet) external onlyOwner{
424         marketingWallet = newWallet;
425     }
426     
427     function updateTeamWallet(address newWallet) external onlyOwner{
428         EcoWallet = newWallet;
429     }
430 
431     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
432         router = _router;
433         pair = _pair;
434     }
435     
436         function addBots(address[] memory isBot_) public onlyOwner {
437         for (uint i = 0; i < isBot_.length; i++) {
438             isBot[isBot_[i]] = true;
439         }
440         }
441     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
442         excludedFromFees[_address] = state;
443     }
444     
445     function updateMaxTxAmount(uint256 amount) external onlyOwner{
446         maxTxAmount = amount * 10**18;
447     }
448     
449     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
450         maxWalletAmount = amount * 10**18;
451     }
452 
453     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
454         IERC20(tokenAddress).transfer(owner(), amount);
455     }
456 
457     function rescueETH(uint256 weiAmount) external onlyOwner{
458         payable(owner()).sendValue(weiAmount);
459     }
460 
461     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
462         uint256 initBalance = address(this).balance;
463         swapTokensForETH(amount);
464         uint256 newBalance = address(this).balance - initBalance;
465         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
466         if(devPercentage > 0) payable(EcoWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
467     }
468 
469     // fallbacks
470     receive() external payable {}
471     
472 }