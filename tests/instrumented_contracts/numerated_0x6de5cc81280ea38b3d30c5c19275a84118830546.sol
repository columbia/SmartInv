1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.20;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; 
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 interface IERC20Metadata is IERC20 {
39 
40     function name() external view returns (string memory);
41 
42     function symbol() external view returns (string memory);
43 
44     function decimals() external view returns (uint8);
45 }
46 
47 
48 contract ERC20 is Context, IERC20, IERC20Metadata {
49     mapping (address => uint256) internal _balances;
50 
51     mapping (address => mapping (address => uint256)) internal _allowances;
52 
53     uint256 private _totalSupply;
54 
55     string private _name;
56     string private _symbol;
57 
58     constructor (string memory name_, string memory symbol_) {
59         _name = name_;
60         _symbol = symbol_;
61     }
62 
63 
64     function name() public view virtual override returns (string memory) {
65         return _name;
66     }
67 
68     function symbol() public view virtual override returns (string memory) {
69         return _symbol;
70     }
71 
72     function decimals() public view virtual override returns (uint8) {
73         return 18;
74     }
75 
76     function totalSupply() public view virtual override returns (uint256) {
77         return _totalSupply;
78     }
79 
80     function balanceOf(address account) public view virtual override returns (uint256) {
81         return _balances[account];
82     }
83 
84     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
85         _transfer(_msgSender(), recipient, amount);
86         return true;
87     }
88 
89     function allowance(address owner, address spender) public view virtual override returns (uint256) {
90         return _allowances[owner][spender];
91     }
92 
93     function approve(address spender, uint256 amount) public virtual override returns (bool) {
94         _approve(_msgSender(), spender, amount);
95         return true;
96     }
97 
98     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
99         _transfer(sender, recipient, amount);
100 
101         uint256 currentAllowance = _allowances[sender][_msgSender()];
102         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
103         _approve(sender, _msgSender(), currentAllowance - amount);
104 
105         return true;
106     }
107 
108     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
109         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
110         return true;
111     }
112 
113     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
114         uint256 currentAllowance = _allowances[_msgSender()][spender];
115         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
116         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
117 
118         return true;
119     }
120 
121     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
122         require(sender != address(0), "ERC20: transfer from the zero address");
123         require(recipient != address(0), "ERC20: transfer to the zero address");
124 
125         _beforeTokenTransfer(sender, recipient, amount);
126 
127         uint256 senderBalance = _balances[sender];
128         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
129         _balances[sender] = senderBalance - amount;
130         _balances[recipient] += amount;
131 
132         emit Transfer(sender, recipient, amount);
133     }
134 
135     function _mint(address account, uint256 amount) internal virtual {
136         require(account != address(0), "ERC20: mint to the zero address");
137 
138         _beforeTokenTransfer(address(0), account, amount);
139 
140         _totalSupply += amount;
141         _balances[account] += amount;
142         emit Transfer(address(0), account, amount);
143     }
144 
145     function _approve(address owner, address spender, uint256 amount) internal virtual {
146         require(owner != address(0), "ERC20: approve from the zero address");
147         require(spender != address(0), "ERC20: approve to the zero address");
148 
149         _allowances[owner][spender] = amount;
150         emit Approval(owner, spender, amount);
151     }
152 
153     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
154 }
155 
156 library Address{
157     function sendValue(address payable recipient, uint256 amount) internal {
158         require(address(this).balance >= amount, "Address: insufficient balance");
159 
160         (bool success, ) = recipient.call{value: amount}("");
161         require(success, "Address: unable to send value, recipient may have reverted");
162     }
163 }
164 
165 abstract contract Ownable is Context {
166     address private _owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     constructor() {
171         _setOwner(_msgSender());
172     }
173 
174     function owner() public view virtual returns (address) {
175         return _owner;
176     }
177 
178     modifier onlyOwner() {
179         require(owner() == _msgSender(), "Ownable: caller is not the owner");
180         _;
181     }
182 
183     function renounceOwnership() public virtual onlyOwner {
184         _setOwner(address(0));
185     }
186 
187     function transferOwnership(address newOwner) public virtual onlyOwner {
188         require(newOwner != address(0), "Ownable: new owner is the zero address");
189         _setOwner(newOwner);
190     }
191 
192     function _setOwner(address newOwner) private {
193         address oldOwner = _owner;
194         _owner = newOwner;
195         emit OwnershipTransferred(oldOwner, newOwner);
196     }
197 }
198 
199 interface IFactory{
200         function createPair(address tokenA, address tokenB) external returns (address pair);
201 }
202 
203 interface IRouter {
204     function factory() external pure returns (address);
205     function WETH() external pure returns (address);
206     function addLiquidityETH(
207         address token,
208         uint amountTokenDesired,
209         uint amountTokenMin,
210         uint amountETHMin,
211         address to,
212         uint deadline
213     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
214 
215     function swapExactTokensForETHSupportingFeeOnTransferTokens(
216         uint amountIn,
217         uint amountOutMin,
218         address[] calldata path,
219         address to,
220         uint deadline) external;
221 }
222 
223 contract BlockRover is ERC20, Ownable{
224     using Address for address payable;
225     
226     IRouter public router;
227     address public pair;
228     
229     bool private swapping;
230     bool public swapEnabled;
231     bool public launched;
232     
233     event TransferForeignToken(address token, uint256 amount);
234     event Launched();
235     event SwapEnabled();
236     event SwapThresholdUpdated();
237     event BuyTaxesUpdated();
238     event SellTaxesUpdated();
239     event MarketingWalletUpdated();
240     event DevWalletUpdated();
241     event ExcludedFromFeesUpdated();
242     event MaxTxAmountUpdated();
243     event MaxWalletAmountUpdated();
244     event StuckEthersCleared();
245     
246     uint256 public swapThreshold = 1000000 * 10**18; //0.1% of total supply
247     uint256 public maxTxAmount = 1000000000 * 10**18; 
248     uint256 public maxWalletAmount = 1000000000 * 10**18;
249     
250     address public marketingWallet = 0x24dE903d71a370b901B0D479C1d0f0aC5fBD4F55;
251     address public devWallet = 0x4495fb3D48759F2e6167957bDF0cde1264368278;
252     
253     struct Taxes {
254         uint256 marketing;
255         uint256 liquidity;
256         uint256 dev;
257      }
258     
259     Taxes public buyTaxes = Taxes(4,0,1);
260     Taxes public sellTaxes = Taxes(4,0,1);
261     uint256 private totBuyTax = 5;
262     uint256 private totSellTax = 5;
263     
264     mapping (address => bool) public excludedFromFees;
265     
266     modifier inSwap() {
267         if (!swapping) {
268             swapping = true;
269             _;
270             swapping = false;
271         }
272     }
273 
274     constructor() ERC20("Block Rover", "ROVER") {
275         _mint(msg.sender, 1000000000 * 10 ** decimals());
276         excludedFromFees[msg.sender] = true;
277 
278         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
279         address _pair = IFactory(_router.factory())
280             .createPair(address(this), _router.WETH());
281 
282         router = _router;
283         pair = _pair;
284         excludedFromFees[address(this)] = true;
285         excludedFromFees[marketingWallet] = true;
286         excludedFromFees[devWallet] = true;
287     }
288     
289     function _transfer(address sender, address recipient, uint256 amount) internal override {
290         require(amount > 0, "Transfer amount must be greater than zero");
291                 
292         
293         if(!excludedFromFees[sender] && !excludedFromFees[recipient] && !swapping){
294             require(launched, "Trading not active yet");
295             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
296             if(recipient != pair){
297                 require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
298             }
299         }
300 
301         uint256 fee;
302           
303         if (swapping || excludedFromFees[sender] || excludedFromFees[recipient]) fee = 0;
304          
305         else{
306             if(recipient == pair) fee = amount * totSellTax / 100;
307             else if(sender == pair) fee = amount * totBuyTax / 100;
308             else fee = 0;
309         }
310         
311         if (swapEnabled && !swapping && sender != pair && fee > 0) swapForFees();
312 
313         super._transfer(sender, recipient, amount - fee);
314         if(fee > 0) super._transfer(sender, address(this) ,fee);
315 
316     }
317     function swapForFees() private inSwap {
318         uint256 contractBalance = balanceOf(address(this));
319 
320         if (contractBalance >= swapThreshold) {
321 
322             uint256 denominator = totSellTax * 2;
323             uint256 tokensToAddLiquidityWith = contractBalance * sellTaxes.liquidity / denominator;
324             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
325     
326             uint256 initialBalance = address(this).balance;
327     
328             swapTokensForETH(toSwap);
329     
330             uint256 deltaBalance = address(this).balance - initialBalance;
331             uint256 unitBalance= deltaBalance / (denominator - sellTaxes.liquidity);
332             uint256 ethToAddLiquidityWith = unitBalance * sellTaxes.liquidity;
333     
334             if(tokensToAddLiquidityWith > 0 && ethToAddLiquidityWith > 0){
335                 // Add liquidity to dex
336                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
337             }
338     
339             uint256 marketingAmt = unitBalance * 2 * sellTaxes.marketing;
340             if(marketingAmt > 0){
341                 payable(marketingWallet).sendValue(marketingAmt);
342             }
343             
344             uint256 devAmt = unitBalance * 2 * sellTaxes.dev;
345             if(devAmt > 0){
346                 payable(devWallet).sendValue(devAmt);
347             }
348         }
349     }
350 
351     function swapTokensForETH(uint256 tokenAmount) private {
352         address[] memory path = new address[](2);
353         path[0] = address(this);
354         path[1] = router.WETH();
355 
356         _approve(address(this), address(router), tokenAmount);
357 
358         // make the swap
359         router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
360     }
361 
362     function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
363         // approve token transfer to cover all possible scenarios
364         _approve(address(this), address(router), tokenAmount);
365 
366         // add the liquidity
367         router.addLiquidityETH{value: bnbAmount}(
368             address(this),
369             tokenAmount,
370             0, // slippage is unavoidable
371             0, // slippage is unavoidable
372             address(0xdead),
373             block.timestamp
374         );
375     }
376     function setSwapEnabled(bool state) external onlyOwner { // to be used only in case of dire emergency
377         swapEnabled = state;
378         emit SwapEnabled();
379     }
380 
381     function setSwapThreshold(uint256 new_amount) external onlyOwner {
382         require(new_amount >= 10000, "Swap amount cannot be lower than 0.001% total supply.");
383         require(new_amount <= 30000000, "Swap amount cannot be higher than 3% total supply.");
384         swapThreshold = new_amount * (10**18);
385         emit SwapThresholdUpdated();
386     }
387 
388     function launch() external onlyOwner{
389         require(!launched, "Trading already active");
390         launched = true;
391         swapEnabled = true;
392         emit Launched();
393     }
394 
395     function setTaxes(uint256 _bmarketing, uint256 _bliquidity, uint256 _bdev, uint256 _smarketing, uint256 _sliquidity, uint256 _sdev) external onlyOwner{
396         buyTaxes = Taxes(_bmarketing, _bliquidity, _bdev);
397         totBuyTax = _bmarketing + _bliquidity + _bdev;
398         sellTaxes = Taxes(_smarketing, _sliquidity, _sdev);
399         totSellTax = _smarketing + _sliquidity + _sdev;
400         require(totBuyTax <= 26,"Total buy fees cannot be greater than 5%");
401         require(totSellTax <= 26,"Total sell fees cannot be greater than 5%");
402         require(totSellTax >= 1,"Total sell fees cannot beless  than 1%");
403     }
404     
405     function updateMarketingWallet(address newWallet) external onlyOwner{
406         excludedFromFees[marketingWallet] = false;
407         require(newWallet != address(0), "Marketing Wallet cannot be zero address");
408         marketingWallet = newWallet;
409         emit MarketingWalletUpdated();     
410     }
411    
412     function updateDevWallet(address newWallet) external onlyOwner{
413         excludedFromFees[devWallet] = false;
414         require(newWallet != address(0), "Dev Wallet cannot be zero address");
415         devWallet = newWallet;
416         emit DevWalletUpdated();
417     }
418 
419     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
420         excludedFromFees[_address] = state;
421         emit ExcludedFromFeesUpdated();
422     }
423     
424     function updateMaxTxAmount(uint256 amount) external onlyOwner{
425         require(amount >= 2500000, "Cannot set maxSell lower than 0.25%");
426         maxTxAmount = amount * (10**18);
427         emit MaxTxAmountUpdated();
428     }
429     
430     function updateMaxWalletAmount(uint256 amount) external onlyOwner{
431         require(amount >= 2500000, "Cannot set maxSell lower than 0.25%");
432         maxWalletAmount = amount * (10**18);
433         emit MaxWalletAmountUpdated();
434     }
435 
436     function withdrawStuckTokens(address _token, address _to) external onlyOwner returns (bool _sent) {
437         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
438         _sent = IERC20(_token).transfer(_to, _contractBalance);
439         emit TransferForeignToken(_token, _contractBalance);
440     }
441 
442     function clearStuckEthers(uint256 amountPercentage) external onlyOwner {
443         uint256 amountETH = address(this).balance;
444         payable(msg.sender).transfer((amountETH * amountPercentage) / 100);
445         emit StuckEthersCleared();
446     }
447 
448 
449     // fallbacks
450     receive() external payable {}
451 }