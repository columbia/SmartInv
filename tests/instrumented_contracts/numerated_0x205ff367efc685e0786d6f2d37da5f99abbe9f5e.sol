1 // 
2 // 
3 // ██████╗░███████╗░█████╗░███╗░░░███╗██╗░░██╗  ░██████╗███╗░░██╗██╗██████╗░███████╗██████╗░
4 // ██╔══██╗██╔════╝██╔══██╗████╗░████║╚██╗██╔╝  ██╔════╝████╗░██║██║██╔══██╗██╔════╝██╔══██╗
5 // ██████╦╝█████╗░░███████║██╔████╔██║░╚███╔╝░  ╚█████╗░██╔██╗██║██║██████╔╝█████╗░░██████╔╝
6 // ██╔══██╗██╔══╝░░██╔══██║██║╚██╔╝██║░██╔██╗░  ░╚═══██╗██║╚████║██║██╔═══╝░██╔══╝░░██╔══██╗
7 // ██████╦╝███████╗██║░░██║██║░╚═╝░██║██╔╝╚██╗  ██████╔╝██║░╚███║██║██║░░░░░███████╗██║░░██║
8 // ╚═════╝░╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝░░╚═╝  ╚═════╝░╚═╝░░╚══╝╚═╝╚═╝░░░░░╚══════╝╚═╝░░╚═╝
9 // All your DeFi trading done swifter and smarter.
10 //
11 // https://beamxsniper.com/
12 // https://t.me/beamx_erc
13 // https://twitter.com/Beamxsniper
14 //
15 
16 pragma solidity 0.8.12;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; 
25         return msg.data;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address account) external view returns (uint256);
33 
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 interface IERC20Metadata is IERC20 {
52 
53     function name() external view returns (string memory);
54 
55     function symbol() external view returns (string memory);
56 
57     function decimals() external view returns (uint8);
58 }
59 
60 
61 contract ERC20 is Context, IERC20, IERC20Metadata {
62     mapping (address => uint256) internal _balances;
63 
64     mapping (address => mapping (address => uint256)) internal _allowances;
65 
66     uint256 private _totalSupply;
67 
68     string private _name;
69     string private _symbol;
70 
71     constructor (string memory name_, string memory symbol_) {
72         _name = name_;
73         _symbol = symbol_;
74     }
75 
76 
77     function name() public view virtual override returns (string memory) {
78         return _name;
79     }
80 
81     function symbol() public view virtual override returns (string memory) {
82         return _symbol;
83     }
84 
85     function decimals() public view virtual override returns (uint8) {
86         return 18;
87     }
88 
89     function totalSupply() public view virtual override returns (uint256) {
90         return _totalSupply;
91     }
92 
93     function balanceOf(address account) public view virtual override returns (uint256) {
94         return _balances[account];
95     }
96 
97     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
98         _transfer(_msgSender(), recipient, amount);
99         return true;
100     }
101 
102     function allowance(address owner, address spender) public view virtual override returns (uint256) {
103         return _allowances[owner][spender];
104     }
105 
106     function approve(address spender, uint256 amount) public virtual override returns (bool) {
107         _approve(_msgSender(), spender, amount);
108         return true;
109     }
110 
111     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
112         _transfer(sender, recipient, amount);
113 
114         uint256 currentAllowance = _allowances[sender][_msgSender()];
115         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
116         _approve(sender, _msgSender(), currentAllowance - amount);
117 
118         return true;
119     }
120 
121     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
122         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
123         return true;
124     }
125 
126     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
127         uint256 currentAllowance = _allowances[_msgSender()][spender];
128         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
129         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
130 
131         return true;
132     }
133 
134     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
135         require(sender != address(0), "ERC20: transfer from the zero address");
136         require(recipient != address(0), "ERC20: transfer to the zero address");
137 
138         _beforeTokenTransfer(sender, recipient, amount);
139 
140         uint256 senderBalance = _balances[sender];
141         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
142         _balances[sender] = senderBalance - amount;
143         _balances[recipient] += amount;
144 
145         emit Transfer(sender, recipient, amount);
146     }
147 
148     function _mint(address account, uint256 amount) internal virtual {
149         require(account != address(0), "ERC20: mint to the zero address");
150 
151         _beforeTokenTransfer(address(0), account, amount);
152 
153         _totalSupply += amount;
154         _balances[account] += amount;
155         emit Transfer(address(0), account, amount);
156     }
157 
158     function _burn(address account, uint256 amount) internal virtual {
159         require(account != address(0), "ERC20: burn from the zero address");
160 
161         _beforeTokenTransfer(account, address(0), amount);
162 
163         uint256 accountBalance = _balances[account];
164         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
165         _balances[account] = accountBalance - amount;
166         _totalSupply -= amount;
167 
168         emit Transfer(account, address(0), amount);
169     }
170 
171     function _approve(address owner, address spender, uint256 amount) internal virtual {
172         require(owner != address(0), "ERC20: approve from the zero address");
173         require(spender != address(0), "ERC20: approve to the zero address");
174 
175         _allowances[owner][spender] = amount;
176         emit Approval(owner, spender, amount);
177     }
178 
179     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
180 }
181 
182 library Address{
183     function sendValue(address payable recipient, uint256 amount) internal {
184         require(address(this).balance >= amount, "Address: insufficient balance");
185 
186         (bool success, ) = recipient.call{value: amount}("");
187         require(success, "Address: unable to send value, recipient may have reverted");
188     }
189 }
190 
191 abstract contract Ownable is Context {
192     address private _owner;
193 
194     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
195 
196     constructor() {
197         _setOwner(_msgSender());
198     }
199 
200     function owner() public view virtual returns (address) {
201         return _owner;
202     }
203 
204     modifier onlyOwner() {
205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
206         _;
207     }
208 
209     function renounceOwnership() public virtual onlyOwner {
210         _setOwner(address(0));
211     }
212 
213     function transferOwnership(address newOwner) public virtual onlyOwner {
214         require(newOwner != address(0), "Ownable: new owner is the zero address");
215         _setOwner(newOwner);
216     }
217 
218     function _setOwner(address newOwner) private {
219         address oldOwner = _owner;
220         _owner = newOwner;
221         emit OwnershipTransferred(oldOwner, newOwner);
222     }
223 }
224 
225 interface IFactory{
226         function createPair(address tokenA, address tokenB) external returns (address pair);
227 }
228 
229 interface IRouter {
230     function factory() external pure returns (address);
231     function WETH() external pure returns (address);
232     function addLiquidityETH(
233         address token,
234         uint amountTokenDesired,
235         uint amountTokenMin,
236         uint amountETHMin,
237         address to,
238         uint deadline
239     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
240 
241     function swapExactTokensForETHSupportingFeeOnTransferTokens(
242         uint amountIn,
243         uint amountOutMin,
244         address[] calldata path,
245         address to,
246         uint deadline) external;
247 }
248 
249 contract BeamXSniper is ERC20, Ownable{
250     using Address for address payable;
251     
252     IRouter public router;
253     address public pair;
254     
255     bool private swapping;
256     bool public swapEnabled;
257     bool public tradingEnabled;
258 
259     uint256 public genesis_block;
260     uint256 public deadblocks = 0;
261     
262     uint256 public swapThreshold = 1_000 * 10e18;
263     uint256 public maxTxAmount = 10_000_000 * 10**18;
264     uint256 public maxWalletAmount = 200_000 * 10**18;
265     
266     address public marketingWallet = 0xFDfBc861f39187991E2C65A4601cC277Db4Dd47D;
267     address public devWallet = 0xFDfBc861f39187991E2C65A4601cC277Db4Dd47D;
268     
269     struct Taxes {
270         uint256 marketing;
271         uint256 liquidity; 
272         uint256 dev;
273     }
274     
275     Taxes public taxes = Taxes(20,0,5);
276     Taxes public sellTaxes = Taxes(20,0,5);
277     uint256 public totTax = 25;
278     uint256 public totSellTax = 25;
279     
280     mapping (address => bool) public excludedFromFees;
281     mapping (address => bool) private isBot;
282     
283     modifier inSwap() {
284         if (!swapping) {
285             swapping = true;
286             _;
287             swapping = false;
288         }
289     }
290         
291     constructor() ERC20("BeamX Sniper", "BMX") {
292         _mint(msg.sender, 1e7 * 10 ** decimals());
293         excludedFromFees[msg.sender] = true;
294 
295         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
296         address _pair = IFactory(_router.factory())
297             .createPair(address(this), _router.WETH());
298 
299         router = _router;
300         pair = _pair;
301         excludedFromFees[address(this)] = true;
302         excludedFromFees[marketingWallet] = true;
303         excludedFromFees[devWallet] = true;
304     }
305     
306     function _transfer(address sender, address recipient, uint256 amount) internal override {
307         require(amount > 0, "Transfer amount must be greater than zero");
308         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
309                 
310         
311         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
312             require(tradingEnabled, "Trading not active yet");
313             if(genesis_block + deadblocks > block.number){
314                 if(recipient != pair) isBot[recipient] = true;
315                 if(sender != pair) isBot[sender] = true;
316             }
317             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
318             if(recipient != pair){
319                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
320             }
321         }
322 
323         uint256 fee;
324         
325   
326         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
327         
328  
329         else{
330             if(recipient == pair) fee = amount * totSellTax / 100;
331             else fee = amount * totTax / 100;
332         }
333         
334 
335         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
336 
337         super._transfer(sender, recipient, amount - fee);
338         if(fee > 0) super._transfer(sender, address(this) ,fee);
339 
340     }
341 
342     function swapForFees() private inSwap {
343         uint256 contractBalance = balanceOf(address(this));
344         if (contractBalance >= swapThreshold) {
345 
346                     uint256 denominator = totSellTax * 2;
347             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
348             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
349     
350             uint256 initialBalance = address(this).balance;
351     
352             swapTokensForETH(toSwap);
353     
354             uint256 deltaBalance = address(this).balance - initialBalance;
355             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
356             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
357     
358             if(ethToAddLiquidityWith > 0){
359                 // Add liquidity to Uniswap
360                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
361             }
362     
363             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
364             if(marketingAmt > 0){
365                 payable(marketingWallet).sendValue(marketingAmt);
366             }
367             
368             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
369             if(devAmt > 0){
370                 payable(devWallet).sendValue(devAmt);
371             }
372         }
373     }
374 
375 
376     function swapTokensForETH(uint256 tokenAmount) private {
377         address[] memory path = new address[](2);
378         path[0] = address(this);
379         path[1] = router.WETH();
380 
381         _approve(address(this), address(router), tokenAmount);
382 
383         // make the swap
384         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
385 
386     }
387 
388     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
389         // approve token transfer to cover all possible scenarios
390         _approve(address(this), address(router), tokenAmount);
391 
392         // add the liquidity
393         router.addLiquidityETH{value: bnbAmount}(
394             address(this),
395             tokenAmount,
396             0, // slippage is unavoidable
397             0, // slippage is unavoidable
398             devWallet,
399             block.timestamp
400         );
401     }
402 
403     function setSwapEnabled(bool state) external onlyOwner {
404         swapEnabled = state;
405     }
406 
407     function setSwapThreshold(uint256 new_amount) external onlyOwner {
408         swapThreshold = new_amount;
409     }
410 
411     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
412         require(!tradingEnabled, "Trading already active");
413         tradingEnabled = true;
414         swapEnabled = true;
415         genesis_block = block.number;
416         deadblocks = numOfDeadBlocks;
417     }
418 
419     function setTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
420         taxes = Taxes(_marketing, _liquidity, _dev);
421         totTax = _marketing + _liquidity + _dev;
422     }
423 
424     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
425         sellTaxes = Taxes(_marketing, _liquidity, _dev);
426         totSellTax = _marketing + _liquidity + _dev;
427     }
428     
429     function updateMarketingWallet(address newWallet) external onlyOwner{
430         marketingWallet = newWallet;
431     }
432     
433     function updateDevWallet(address newWallet) external onlyOwner{
434         devWallet = newWallet;
435     }
436 
437     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
438         router = _router;
439         pair = _pair;
440     }
441     
442         function addBots(address[] memory isBot_) public onlyOwner {
443         for (uint i = 0; i < isBot_.length; i++) {
444             isBot[isBot_[i]] = true;
445         }
446         }
447     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
448         excludedFromFees[_address] = state;
449     }
450     
451     function updateMaxTxAmount(uint256 amount) external onlyOwner{
452         maxTxAmount = amount * 10**18;
453     }
454     
455     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
456         maxWalletAmount = amount * 10**18;
457     }
458 
459     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
460         IERC20(tokenAddress).transfer(owner(), amount);
461     }
462 
463     function rescueETH(uint256 weiAmount) external onlyOwner{
464         payable(owner()).sendValue(weiAmount);
465     }
466 
467     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
468         uint256 initBalance = address(this).balance;
469         swapTokensForETH(amount);
470         uint256 newBalance = address(this).balance - initBalance;
471         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
472         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
473     }
474 
475     // fallbacks
476     receive() external payable {}
477     
478 }