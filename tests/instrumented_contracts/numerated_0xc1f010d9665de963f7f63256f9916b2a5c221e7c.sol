1 //⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
2 //⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⡀⠄⠄⠄⠄
3 //⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠈⠄⠄⠄⠁⠄⠁⠄⠄⠄⠄⠄
4 //⠄⠄⠄⠄⠄⠄⣀⣀⣤⣤⣴⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣦⣤⣤⣄⣀⡀⠄⠄⠄⠄⠄
5 //⠄⠄⠄⠄⣴⣿⣿⡿⣿⢿⣟⣿⣻⣟⡿⣟⣿⣟⡿⣟⣿⣻⣟⣿⣻⢿⣻⡿⣿⢿⣷⣆⠄⠄⠄
6 //⠄⠄⠄⢘⣿⢯⣷⡿⡿⡿⢿⢿⣷⣯⡿⣽⣞⣷⣻⢯⣷⣻⣾⡿⡿⢿⢿⢿⢯⣟⣞⡮⡀⠄⠄
7 //⠄⠄⠄⢸⢞⠟⠃⣉⢉⠉⠉⠓⠫⢿⣿⣷⢷⣻⣞⣿⣾⡟⠽⠚⠊⠉⠉⠉⠙⠻⣞⢵⠂⠄⠄
8 //⠄⠄⠄⢜⢯⣺⢿⣻⣿⣿⣷⣔⡄⠄⠈⠛⣿⣿⡾⠋⠁⠄⠄⣄⣶⣾⣿⡿⣿⡳⡌⡗⡅⠄⠄
9 //⠄⠄⠄⢽⢱⢳⢹⡪⡞⠮⠯⢯⡻⡬⡐⢨⢿⣿⣿⢀⠐⡥⣻⡻⠯⡳⢳⢹⢜⢜⢜⢎⠆⠄⠄
10 //⠄⠄⠠⣻⢌⠘⠌⡂⠈⠁⠉⠁⠘⠑⢧⣕⣿⣿⣿⢤⡪⠚⠂⠈⠁⠁⠁⠂⡑⠡⡈⢮⠅⠄⠄
11 //⠄⠄⠠⣳⣿⣿⣽⣭⣶⣶⣶⣶⣶⣺⣟⣾⣻⣿⣯⢯⢿⣳⣶⣶⣶⣖⣶⣮⣭⣷⣽⣗⠍⠄⠄
12 //⠄⠄⢀⢻⡿⡿⣟⣿⣻⣽⣟⣿⢯⣟⣞⡷⣿⣿⣯⢿⢽⢯⣿⣻⣟⣿⣻⣟⣿⣻⢿⣿⢀⠄⠄
13 //⠄⠄⠄⡑⡏⠯⡯⡳⡯⣗⢯⢟⡽⣗⣯⣟⣿⣿⣾⣫⢿⣽⠾⡽⣺⢳⡫⡞⡗⡝⢕⠕⠄⠄⠄
14 //⠄⠄⠄⢂⡎⠅⡃⢇⠇⠇⣃⣧⡺⡻⡳⡫⣿⡿⣟⠞⠽⠯⢧⣅⣃⠣⠱⡑⡑⠨⢐⢌⠂⠄⠄
15 //⠄⠄⠄⠐⠼⣦⢀⠄⣶⣿⢿⣿⣧⣄⡌⠂⠢⠩⠂⠑⣁⣅⣾⢿⣟⣷⠦⠄⠄⡤⡇⡪⠄⠄⠄
16 //⠄⠄⠄⠄⠨⢻⣧⡅⡈⠛⠿⠿⠿⠛⠁⠄⢀⡀⠄⠄⠘⠻⠿⠿⠯⠓⠁⢠⣱⡿⢑⠄⠄⠄⠄
17 //⠄⠄⠄⠄⠈⢌⢿⣷⡐⠤⣀⣀⣂⣀⢀⢀⡓⠝⡂⡀⢀⢀⢀⣀⣀⠤⢊⣼⡟⡡⡁⠄⠄⠄⠄
18 //⠄⠄⠄⠄⠄⠈⢢⠚⣿⣄⠈⠉⠛⠛⠟⠿⠿⠟⠿⠻⠻⠛⠛⠉⠄⣠⠾⢑⠰⠈⠄⠄⠄⠄⠄
19 //⠄⠄⠄⠄⠄⠄⠄⠑⢌⠿⣦⡡⣱⣸⣸⣆⠄⠄⠄⣰⣕⢔⢔⠡⣼⠞⡡⠁⠁⠄⠄⠄⠄⠄⠄
20 //⠄⠄⠄⠄⠄⠄⠄⠄⠄⠑⢝⢷⣕⡷⣿⡿⠄⠄⠠⣿⣯⣯⡳⡽⡋⠌⠄⠄⠄⠄⠄⠄⠄⠄⠄
21 //⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠙⢮⣿⣽⣯⠄⠄⢨⣿⣿⡷⡫⠃⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
22 //⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠘⠙⠝⠂⠄⢘⠋⠃⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
23 //⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
24 //⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
25 //
26 //
27 //
28 //
29 // Do they love you or the mask you put on everyday?
30 //
31 //
32 
33 // SPDX-License-Identifier: MIT
34 
35 pragma solidity 0.8.12;
36 
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes calldata) {
43         this; 
44         return msg.data;
45     }
46 }
47 
48 interface IERC20 {
49     function totalSupply() external view returns (uint256);
50 
51     function balanceOf(address account) external view returns (uint256);
52 
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     function transferFrom(
60         address sender,
61         address recipient,
62         uint256 amount
63     ) external returns (bool);
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 interface IERC20Metadata is IERC20 {
71 
72     function name() external view returns (string memory);
73 
74     function symbol() external view returns (string memory);
75 
76     function decimals() external view returns (uint8);
77 }
78 
79 
80 contract ERC20 is Context, IERC20, IERC20Metadata {
81     mapping (address => uint256) internal _balances;
82 
83     mapping (address => mapping (address => uint256)) internal _allowances;
84 
85     uint256 private _totalSupply;
86 
87     string private _name;
88     string private _symbol;
89 
90     constructor (string memory name_, string memory symbol_) {
91         _name = name_;
92         _symbol = symbol_;
93     }
94 
95 
96     function name() public view virtual override returns (string memory) {
97         return _name;
98     }
99 
100     function symbol() public view virtual override returns (string memory) {
101         return _symbol;
102     }
103 
104     function decimals() public view virtual override returns (uint8) {
105         return 18;
106     }
107 
108     function totalSupply() public view virtual override returns (uint256) {
109         return _totalSupply;
110     }
111 
112     function balanceOf(address account) public view virtual override returns (uint256) {
113         return _balances[account];
114     }
115 
116     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
117         _transfer(_msgSender(), recipient, amount);
118         return true;
119     }
120 
121     function allowance(address owner, address spender) public view virtual override returns (uint256) {
122         return _allowances[owner][spender];
123     }
124 
125     function approve(address spender, uint256 amount) public virtual override returns (bool) {
126         _approve(_msgSender(), spender, amount);
127         return true;
128     }
129 
130     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
131         _transfer(sender, recipient, amount);
132 
133         uint256 currentAllowance = _allowances[sender][_msgSender()];
134         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
135         _approve(sender, _msgSender(), currentAllowance - amount);
136 
137         return true;
138     }
139 
140     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
141         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
142         return true;
143     }
144 
145     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
146         uint256 currentAllowance = _allowances[_msgSender()][spender];
147         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
148         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
149 
150         return true;
151     }
152 
153     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
154         require(sender != address(0), "ERC20: transfer from the zero address");
155         require(recipient != address(0), "ERC20: transfer to the zero address");
156 
157         _beforeTokenTransfer(sender, recipient, amount);
158 
159         uint256 senderBalance = _balances[sender];
160         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
161         _balances[sender] = senderBalance - amount;
162         _balances[recipient] += amount;
163 
164         emit Transfer(sender, recipient, amount);
165     }
166 
167     function _mint(address account, uint256 amount) internal virtual {
168         require(account != address(0), "ERC20: mint to the zero address");
169 
170         _beforeTokenTransfer(address(0), account, amount);
171 
172         _totalSupply += amount;
173         _balances[account] += amount;
174         emit Transfer(address(0), account, amount);
175     }
176 
177     function _burn(address account, uint256 amount) internal virtual {
178         require(account != address(0), "ERC20: burn from the zero address");
179 
180         _beforeTokenTransfer(account, address(0), amount);
181 
182         uint256 accountBalance = _balances[account];
183         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
184         _balances[account] = accountBalance - amount;
185         _totalSupply -= amount;
186 
187         emit Transfer(account, address(0), amount);
188     }
189 
190     function _approve(address owner, address spender, uint256 amount) internal virtual {
191         require(owner != address(0), "ERC20: approve from the zero address");
192         require(spender != address(0), "ERC20: approve to the zero address");
193 
194         _allowances[owner][spender] = amount;
195         emit Approval(owner, spender, amount);
196     }
197 
198     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
199 }
200 
201 library Address{
202     function sendValue(address payable recipient, uint256 amount) internal {
203         require(address(this).balance >= amount, "Address: insufficient balance");
204 
205         (bool success, ) = recipient.call{value: amount}("");
206         require(success, "Address: unable to send value, recipient may have reverted");
207     }
208 }
209 
210 abstract contract Ownable is Context {
211     address private _owner;
212 
213     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
214 
215     constructor() {
216         _setOwner(_msgSender());
217     }
218 
219     function owner() public view virtual returns (address) {
220         return _owner;
221     }
222 
223     modifier onlyOwner() {
224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
225         _;
226     }
227 
228     function renounceOwnership() public virtual onlyOwner {
229         _setOwner(address(0));
230     }
231 
232     function transferOwnership(address newOwner) public virtual onlyOwner {
233         require(newOwner != address(0), "Ownable: new owner is the zero address");
234         _setOwner(newOwner);
235     }
236 
237     function _setOwner(address newOwner) private {
238         address oldOwner = _owner;
239         _owner = newOwner;
240         emit OwnershipTransferred(oldOwner, newOwner);
241     }
242 }
243 
244 interface IFactory{
245         function createPair(address tokenA, address tokenB) external returns (address pair);
246 }
247 
248 interface IRouter {
249     function factory() external pure returns (address);
250     function WETH() external pure returns (address);
251     function addLiquidityETH(
252         address token,
253         uint amountTokenDesired,
254         uint amountTokenMin,
255         uint amountETHMin,
256         address to,
257         uint deadline
258     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
259 
260     function swapExactTokensForETHSupportingFeeOnTransferTokens(
261         uint amountIn,
262         uint amountOutMin,
263         address[] calldata path,
264         address to,
265         uint deadline) external;
266 }
267 
268 contract Larp is ERC20, Ownable{
269     using Address for address payable;
270     
271     IRouter public router;
272     address public pair;
273     
274     bool private swapping;
275     bool public swapEnabled;
276     bool public tradingEnabled;
277 
278     uint256 public genesis_block;
279     uint256 public deadblocks = 0;
280     
281     uint256 public swapThreshold = 10_000 * 10e18;
282     uint256 public maxTxAmount = 1_500_000 * 10**18;
283     uint256 public maxWalletAmount = 2_000_000 * 10**18;
284     
285     address public marketingWallet = 0x2DB6c56f7a7E9be08257BD1Fb5B01F838282be9E;
286     address public devWallet = 0x8AfBB98db347747a06A842462b2E614885C80464;
287     
288     struct Taxes {
289         uint256 marketing;
290         uint256 liquidity; 
291         uint256 dev;
292     }
293     
294     Taxes public taxes = Taxes(18,0,17);
295     Taxes public sellTaxes = Taxes(15,0,15);
296     uint256 public totTax = 35;
297     uint256 public totSellTax = 30;
298     
299     mapping (address => bool) public excludedFromFees;
300     mapping (address => bool) private isBot;
301     
302     modifier inSwap() {
303         if (!swapping) {
304             swapping = true;
305             _;
306             swapping = false;
307         }
308     }
309         
310     constructor() ERC20("Larp", "LARP") {
311         _mint(msg.sender, 1e8 * 10 ** decimals());
312         excludedFromFees[msg.sender] = true;
313 
314         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
315         address _pair = IFactory(_router.factory())
316             .createPair(address(this), _router.WETH());
317 
318         router = _router;
319         pair = _pair;
320         excludedFromFees[address(this)] = true;
321         excludedFromFees[marketingWallet] = true;
322         excludedFromFees[devWallet] = true;
323     }
324     
325     function _transfer(address sender, address recipient, uint256 amount) internal override {
326         require(amount > 0, "Transfer amount must be greater than zero");
327         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
328                 
329         
330         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
331             require(tradingEnabled, "Trading not active yet");
332             if(genesis_block + deadblocks > block.number){
333                 if(recipient != pair) isBot[recipient] = true;
334                 if(sender != pair) isBot[sender] = true;
335             }
336             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
337             if(recipient != pair){
338                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
339             }
340         }
341 
342         uint256 fee;
343         
344   
345         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
346         
347  
348         else{
349             if(recipient == pair) fee = amount * totSellTax / 100;
350             else fee = amount * totTax / 100;
351         }
352         
353 
354         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
355 
356         super._transfer(sender, recipient, amount - fee);
357         if(fee > 0) super._transfer(sender, address(this) ,fee);
358 
359     }
360 
361     function swapForFees() private inSwap {
362         uint256 contractBalance = balanceOf(address(this));
363         if (contractBalance >= swapThreshold) {
364 
365                     uint256 denominator = totSellTax * 2;
366             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
367             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
368     
369             uint256 initialBalance = address(this).balance;
370     
371             swapTokensForETH(toSwap);
372     
373             uint256 deltaBalance = address(this).balance - initialBalance;
374             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
375             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
376     
377             if(ethToAddLiquidityWith > 0){
378                 // Add liquidity to Uniswap
379                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
380             }
381     
382             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
383             if(marketingAmt > 0){
384                 payable(marketingWallet).sendValue(marketingAmt);
385             }
386             
387             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
388             if(devAmt > 0){
389                 payable(devWallet).sendValue(devAmt);
390             }
391         }
392     }
393 
394 
395     function swapTokensForETH(uint256 tokenAmount) private {
396         address[] memory path = new address[](2);
397         path[0] = address(this);
398         path[1] = router.WETH();
399 
400         _approve(address(this), address(router), tokenAmount);
401 
402         // make the swap
403         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
404 
405     }
406 
407     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
408         // approve token transfer to cover all possible scenarios
409         _approve(address(this), address(router), tokenAmount);
410 
411         // add the liquidity
412         router.addLiquidityETH{value: bnbAmount}(
413             address(this),
414             tokenAmount,
415             0, // slippage is unavoidable
416             0, // slippage is unavoidable
417             devWallet,
418             block.timestamp
419         );
420     }
421 
422     function setSwapEnabled(bool state) external onlyOwner {
423         swapEnabled = state;
424     }
425 
426     function setSwapThreshold(uint256 new_amount) external onlyOwner {
427         swapThreshold = new_amount;
428     }
429 
430     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
431         require(!tradingEnabled, "Trading already active");
432         tradingEnabled = true;
433         swapEnabled = true;
434         genesis_block = block.number;
435         deadblocks = numOfDeadBlocks;
436     }
437 
438     function setBuyTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
439         taxes = Taxes(_marketing, _liquidity, _dev);
440         totTax = _marketing + _liquidity + _dev;
441     }
442 
443     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
444         sellTaxes = Taxes(_marketing, _liquidity, _dev);
445         totSellTax = _marketing + _liquidity + _dev;
446     }
447     
448     function updateMrktWallet(address newWallet) external onlyOwner{
449         marketingWallet = newWallet;
450     }
451     
452     function updateLarpWallet(address newWallet) external onlyOwner{
453         devWallet = newWallet;
454     }
455 
456     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
457         router = _router;
458         pair = _pair;
459     }
460     
461         function addBots(address[] memory isBot_) public onlyOwner {
462         for (uint i = 0; i < isBot_.length; i++) {
463             isBot[isBot_[i]] = true;
464         }
465         }
466     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
467         excludedFromFees[_address] = state;
468     }
469     
470     function updateMaxTxAmount(uint256 amount) external onlyOwner{
471         maxTxAmount = amount * 10**18;
472     }
473     
474     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
475         maxWalletAmount = amount * 10**18;
476     }
477 
478     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
479         IERC20(tokenAddress).transfer(owner(), amount);
480     }
481 
482     function rescueETH(uint256 weiAmount) external onlyOwner{
483         payable(owner()).sendValue(weiAmount);
484     }
485 
486     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
487         uint256 initBalance = address(this).balance;
488         swapTokensForETH(amount);
489         uint256 newBalance = address(this).balance - initBalance;
490         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
491         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
492     }
493 
494     // fallbacks
495     receive() external payable {}
496     
497 }