1 //   https://t.me/futuramabendercoin
2 //   https://http://futuramabender.com/
3 //   https://twitter.com/bender_erc
4 
5 
6 // SPDX-License-Identifier: Unlicensed
7 pragma solidity ^0.8.17;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; 
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 interface IERC20Metadata is IERC20 {
43 
44     function name() external view returns (string memory);
45 
46     function symbol() external view returns (string memory);
47 
48     function decimals() external view returns (uint8);
49 }
50 
51 
52 contract ERC20 is Context, IERC20, IERC20Metadata {
53     mapping (address => uint256) internal _balances;
54 
55     mapping (address => mapping (address => uint256)) internal _allowances;
56 
57     uint256 private _totalSupply;
58 
59     string private _name;
60     string private _symbol;
61 
62     constructor (string memory name_, string memory symbol_) {
63         _name = name_;
64         _symbol = symbol_;
65     }
66 
67 
68     function name() public view virtual override returns (string memory) {
69         return _name;
70     }
71 
72     function symbol() public view virtual override returns (string memory) {
73         return _symbol;
74     }
75 
76     function decimals() public view virtual override returns (uint8) {
77         return 18;
78     }
79 
80     function totalSupply() public view virtual override returns (uint256) {
81         return _totalSupply;
82     }
83 
84     function balanceOf(address account) public view virtual override returns (uint256) {
85         return _balances[account];
86     }
87 
88     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
89         _transfer(_msgSender(), recipient, amount);
90         return true;
91     }
92 
93     function allowance(address owner, address spender) public view virtual override returns (uint256) {
94         return _allowances[owner][spender];
95     }
96 
97     function approve(address spender, uint256 amount) public virtual override returns (bool) {
98         _approve(_msgSender(), spender, amount);
99         return true;
100     }
101 
102     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
103         _transfer(sender, recipient, amount);
104 
105         uint256 currentAllowance = _allowances[sender][_msgSender()];
106         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
107         _approve(sender, _msgSender(), currentAllowance - amount);
108 
109         return true;
110     }
111 
112     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
113         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
114         return true;
115     }
116 
117     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
118         uint256 currentAllowance = _allowances[_msgSender()][spender];
119         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
120         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
121 
122         return true;
123     }
124 
125     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
126         require(sender != address(0), "ERC20: transfer from the zero address");
127         require(recipient != address(0), "ERC20: transfer to the zero address");
128 
129         _beforeTokenTransfer(sender, recipient, amount);
130 
131         uint256 senderBalance = _balances[sender];
132         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
133         _balances[sender] = senderBalance - amount;
134         _balances[recipient] += amount;
135 
136         emit Transfer(sender, recipient, amount);
137     }
138 
139     function _mint(address account, uint256 amount) internal virtual {
140         require(account != address(0), "ERC20: mint to the zero address");
141 
142         _beforeTokenTransfer(address(0), account, amount);
143 
144         _totalSupply += amount;
145         _balances[account] += amount;
146         emit Transfer(address(0), account, amount);
147     }
148 
149     function _burn(address account, uint256 amount) internal virtual {
150         require(account != address(0), "ERC20: burn from the zero address");
151 
152         _beforeTokenTransfer(account, address(0), amount);
153 
154         uint256 accountBalance = _balances[account];
155         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
156         _balances[account] = accountBalance - amount;
157         _totalSupply -= amount;
158 
159         emit Transfer(account, address(0), amount);
160     }
161 
162     function _approve(address owner, address spender, uint256 amount) internal virtual {
163         require(owner != address(0), "ERC20: approve from the zero address");
164         require(spender != address(0), "ERC20: approve to the zero address");
165 
166         _allowances[owner][spender] = amount;
167         emit Approval(owner, spender, amount);
168     }
169 
170     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
171 }
172 
173 library Address{
174     function sendValue(address payable recipient, uint256 amount) internal {
175         require(address(this).balance >= amount, "Address: insufficient balance");
176 
177         (bool success, ) = recipient.call{value: amount}("");
178         require(success, "Address: unable to send value, recipient may have reverted");
179     }
180 }
181 
182 abstract contract Ownable is Context {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187     constructor() {
188         _setOwner(_msgSender());
189     }
190 
191     function owner() public view virtual returns (address) {
192         return _owner;
193     }
194 
195     modifier onlyOwner() {
196         require(owner() == _msgSender(), "Ownable: caller is not the owner");
197         _;
198     }
199 
200     function renounceOwnership() public virtual onlyOwner {
201         _setOwner(address(0));
202     }
203 
204     function transferOwnership(address newOwner) public virtual onlyOwner {
205         require(newOwner != address(0), "Ownable: new owner is the zero address");
206         _setOwner(newOwner);
207     }
208 
209     function _setOwner(address newOwner) private {
210         address oldOwner = _owner;
211         _owner = newOwner;
212         emit OwnershipTransferred(oldOwner, newOwner);
213     }
214 }
215 
216 interface IFactory{
217         function createPair(address tokenA, address tokenB) external returns (address pair);
218 }
219 
220 interface IRouter {
221     function factory() external pure returns (address);
222     function WETH() external pure returns (address);
223     function addLiquidityETH(
224         address token,
225         uint amountTokenDesired,
226         uint amountTokenMin,
227         uint amountETHMin,
228         address to,
229         uint deadline
230     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
231 
232     function swapExactTokensForETHSupportingFeeOnTransferTokens(
233         uint amountIn,
234         uint amountOutMin,
235         address[] calldata path,
236         address to,
237         uint deadline) external;
238 }
239 
240 contract FuturamaBender is ERC20, Ownable{
241     using Address for address payable;
242     
243     IRouter public router;
244     address public pair;
245     
246     bool private swapping;
247     bool public swapEnabled;
248     bool public tradingEnabled;
249 
250     uint256 public genesis_block;
251     uint256 public deadblocks = 0;
252     
253     uint256 public swapThreshold = 100_000 * 10e18;
254     uint256 public maxTxAmount = 20_000_000 * 10**18;
255     uint256 public maxWalletAmount = 20_000_000 * 10**18;
256     
257     address public marketingWallet = 0x2bE894932E6fF1b9c175DFe038193704a0214c6e;
258     address public devWallet = 0x2bE894932E6fF1b9c175DFe038193704a0214c6e;
259     
260     struct Taxes {
261         uint256 marketing;
262         uint256 liquidity; 
263         uint256 dev;
264     }
265     
266     Taxes public taxes = Taxes(35,0,0);
267     Taxes public sellTaxes = Taxes(45,0,0);
268     uint256 public totTax = 30;
269     uint256 public totSellTax = 30;
270     
271     mapping (address => bool) public excludedFromFees;
272     mapping (address => bool) private isBot;
273     
274     modifier inSwap() {
275         if (!swapping) {
276             swapping = true;
277             _;
278             swapping = false;
279         }
280     } 
281        
282     constructor() ERC20("Futurama Bender", "SENDER") {
283         _mint(msg.sender, 1e9 * 10 ** decimals());
284         excludedFromFees[msg.sender] = true;
285 
286         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
287         address _pair = IFactory(_router.factory())
288             .createPair(address(this), _router.WETH());
289 
290         router = _router;
291         pair = _pair;
292         excludedFromFees[address(this)] = true;
293         excludedFromFees[marketingWallet] = true;
294         excludedFromFees[devWallet] = true;
295     }
296     
297     function _transfer(address sender, address recipient, uint256 amount) internal override {
298         require(amount > 0, "Transfer amount must be greater than zero");
299         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
300                 
301         
302         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
303             require(tradingEnabled, "Trading not active yet");
304             if(genesis_block + deadblocks > block.number){
305                 if(recipient != pair) isBot[recipient] = true;
306                 if(sender != pair) isBot[sender] = true;
307             }
308             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
309             if(recipient != pair){
310                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
311             }
312         }
313 
314         uint256 fee;
315         
316   
317         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
318         
319  
320         else{
321             if(recipient == pair) fee = amount * totSellTax / 100;
322             else fee = amount * totTax / 100;
323         }
324         
325 
326         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
327 
328         super._transfer(sender, recipient, amount - fee);
329         if(fee > 0) super._transfer(sender, address(this) ,fee);
330 
331     }
332 
333     function swapForFees() private inSwap {
334         uint256 contractBalance = balanceOf(address(this));
335         if (contractBalance >= swapThreshold) {
336 
337                     uint256 denominator = totSellTax * 2;
338             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
339             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
340     
341             uint256 initialBalance = address(this).balance;
342     
343             swapTokensForETH(toSwap);
344     
345             uint256 deltaBalance = address(this).balance - initialBalance;
346             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
347             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
348     
349             if(ethToAddLiquidityWith > 0){
350                 // Add liquidity to Uniswap
351                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
352             }
353     
354             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
355             if(marketingAmt > 0){
356                 payable(marketingWallet).sendValue(marketingAmt);
357             }
358             
359             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
360             if(devAmt > 0){
361                 payable(devWallet).sendValue(devAmt);
362             }
363         }
364     }
365 
366 
367     function swapTokensForETH(uint256 tokenAmount) private {
368         address[] memory path = new address[](2);
369         path[0] = address(this);
370         path[1] = router.WETH();
371 
372         _approve(address(this), address(router), tokenAmount);
373 
374         // make the swap
375         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
376 
377     }
378 
379     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
380         // approve token transfer to cover all possible scenarios
381         _approve(address(this), address(router), tokenAmount);
382 
383         // add the liquidity
384         router.addLiquidityETH{value: bnbAmount}(
385             address(this),
386             tokenAmount,
387             0, // slippage is unavoidable
388             0, // slippage is unavoidable
389             devWallet,
390             block.timestamp
391         );
392     }
393 
394     function setSwapEnabled(bool state) external onlyOwner {
395         swapEnabled = state;
396     }
397 
398     function setSwapThreshold(uint256 new_amount) external onlyOwner {
399         swapThreshold = new_amount;
400     }
401 
402     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner{
403         require(!tradingEnabled, "Trading already active");
404         tradingEnabled = true;
405         swapEnabled = true;
406         genesis_block = block.number;
407         deadblocks = numOfDeadBlocks;
408     }
409 
410     function setTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
411         taxes = Taxes(_marketing, _liquidity, _dev);
412         totTax = _marketing + _liquidity + _dev;
413     }
414 
415     function setSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner{
416         sellTaxes = Taxes(_marketing, _liquidity, _dev);
417         totSellTax = _marketing + _liquidity + _dev;
418     }
419     
420     function updateMarketingWallet(address newWallet) external onlyOwner{
421         marketingWallet = newWallet;
422     }
423     
424     function updateDevWallet(address newWallet) external onlyOwner{
425         devWallet = newWallet;
426     }
427 
428     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner{
429         router = _router;
430         pair = _pair;
431     }
432     
433         function addBots(address[] memory isBot_) public onlyOwner {
434         for (uint i = 0; i < isBot_.length; i++) {
435             isBot[isBot_[i]] = true;
436         }
437         }
438     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
439         excludedFromFees[_address] = state;
440     }
441     
442     function updateMaxTxAmount(uint256 amount) external onlyOwner{
443         maxTxAmount = amount * 10**18;
444     }
445     
446     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
447         maxWalletAmount = amount * 10**18;
448     }
449 
450     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner{
451         IERC20(tokenAddress).transfer(owner(), amount);
452     }
453 
454     function rescueETH(uint256 weiAmount) external onlyOwner{
455         payable(owner()).sendValue(weiAmount);
456     }
457 
458     function manualSwap(uint256 amount, uint256 devPercentage, uint256 marketingPercentage) external onlyOwner{
459         uint256 initBalance = address(this).balance;
460         swapTokensForETH(amount);
461         uint256 newBalance = address(this).balance - initBalance;
462         if(marketingPercentage > 0) payable(marketingWallet).sendValue(newBalance * marketingPercentage / (devPercentage + marketingPercentage));
463         if(devPercentage > 0) payable(devWallet).sendValue(newBalance * devPercentage / (devPercentage + marketingPercentage));
464     }
465 
466     // fallbacks
467     receive() external payable {}
468     
469 }