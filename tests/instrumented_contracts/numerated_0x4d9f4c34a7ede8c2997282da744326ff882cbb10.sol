1 //Official token contract for Yakisoba
2 //Follow us on twitter: https://twitter.com/yakisobatoken
3 //SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.9;
6 
7 interface ERC20 {
8 
9     function totalSupply() external view returns (uint256);
10     function decimals() external view returns (uint8);
11     function symbol() external view returns (string memory);
12     function name() external view returns (string memory);
13     function getOwner() external view returns (address);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address _owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 
22 }
23 
24 abstract contract Ownable {
25 
26     address internal owner;
27     address private _previousOwner;
28     uint256 private _lockTime;
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32     constructor(address _owner) {
33         owner = _owner;
34     }
35 
36     modifier onlyOwner() {
37         require(msg.sender == owner, "not owner"); 
38         _;
39     }
40 
41     function isOwner(address account) public view returns (bool) {
42         return account == owner;
43     }
44 
45     function transferOwnership(address newOwner) public virtual onlyOwner {
46         require(newOwner != address(0), "Ownable: new owner is the zero address");
47         emit OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 
51 }
52 
53 interface IDEXFactory {
54     function createPair(address tokenA, address tokenB) external returns (address pair);
55     function getPair(address tokenA, address tokenB) external view returns (address pair);
56 }
57 
58 interface IDEXRouter {
59 
60     function factory() external pure returns (address);
61     function WETH() external pure returns (address);
62     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
63     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
64 }
65 
66 contract YAKISOBA is ERC20, Ownable {
67 
68     // Events
69     event SetMaxWallet(uint256 maxWalletToken);
70     event SetSwapBackSettings(bool enabled, uint256 swapThreshold);
71     event SetIsFeeExempt(address holder, bool enabled);
72     event SetIsTxLimitExempt(address holder, bool enabled);
73     event StuckBalanceSent(uint256 amountETH, address recipient);
74 
75     // Mappings
76     mapping (address => uint256) _balances;
77     mapping (address => mapping (address => uint256)) _allowances;
78     mapping (address => bool) public isFeeExempt;
79     mapping (address => bool) public isTxLimitExempt;
80 
81     // Basic Contract Info
82     string constant _name = "YAKISOBA";
83     string constant _symbol = "NOOD";
84     uint8 constant _decimals = 18;
85     uint256 _totalSupply = 420000000000 * (10 ** _decimals); 
86     
87     // Max wallet
88     uint256 public _maxWalletSize = (_totalSupply * 20) / 1000;
89     uint256 public _maxTxSize = (_totalSupply * 20) / 1000;
90 
91     // Fee receiver    
92     uint256 public BurnFeeBuy = 10;
93     uint256 public MarketingFeeBuy = 100;
94     uint256 public LiquidityFeeBuy = 10;
95 
96     uint256 public BurnFeeSell = 10;
97     uint256 public MarketingFeeSell = 430;
98     uint256 public LiquidityFeeSell = 10;
99 
100     uint256 public TotalFees = BurnFeeBuy + BurnFeeSell + MarketingFeeBuy + MarketingFeeSell + LiquidityFeeBuy + LiquidityFeeSell;
101 
102     // Fee receiver & Dead Wallet
103     address public DevWallet;
104     address public MarketingWallet;
105     address constant private DEAD = 0x000000000000000000000000000000000000dEaD;
106 
107     // Router
108     IDEXRouter public router;
109     address public pair;
110 
111     bool public swapEnabled = true;
112     uint256 public swapThreshold = _totalSupply / 10000 * 3;
113 
114     bool public isTradingEnabled = false;
115     address public tradingEnablerRole;
116     uint256 public tradingTimestamp;
117 
118     bool inSwap;
119     modifier swapping() { inSwap = true; _; inSwap = false; }
120 
121     constructor(address _marketingWallet, address _router) Ownable(msg.sender) {
122 
123         router = IDEXRouter(_router);
124         _allowances[address(this)][address(router)] = type(uint256).max;
125 
126         address _owner = owner;
127         DevWallet = msg.sender;
128         MarketingWallet = _marketingWallet;
129 
130         isFeeExempt[_owner] = true;
131         isTxLimitExempt[_owner] = true;
132 
133         isFeeExempt[MarketingWallet] = true;
134         isTxLimitExempt[MarketingWallet] = true; 
135 
136         tradingEnablerRole = _owner;
137         tradingTimestamp = block.timestamp;
138 
139         _balances[msg.sender] = _totalSupply * 100 / 100;
140 
141         emit Transfer(address(0), msg.sender, _totalSupply * 100 / 100);
142 
143     }
144 
145     receive() external payable { }
146 
147 // Basic Internal Functions
148 
149     function totalSupply() external view override returns (uint256) { return _totalSupply; }
150     function decimals() external pure override returns (uint8) { return _decimals; }
151     function symbol() external pure override returns (string memory) { return _symbol; }
152     function name() external pure override returns (string memory) { return _name; }
153     function getOwner() external view override returns (address) { return owner; }
154     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
155     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
156 
157     function approve(address spender, uint256 amount) public override returns (bool) {
158         _allowances[msg.sender][spender] = amount;
159         emit Approval(msg.sender, spender, amount);
160         return true;
161     }
162 
163     function approveMax(address spender) external returns (bool) {
164         return approve(spender, type(uint256).max);
165     }
166 
167     function transfer(address recipient, uint256 amount) external override returns (bool) {
168         return _transferFrom(msg.sender, recipient, amount);
169     }
170 
171     ////////////////////////////////////////////////
172     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
173         if(_allowances[sender][msg.sender] != type(uint256).max){
174             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - (amount);
175         }
176 
177         return _transferFrom(sender, recipient, amount);
178 
179     }
180 
181     function getPair() public onlyOwner {
182         pair = IDEXFactory(router.factory()).getPair(address(this), router.WETH());
183         if (pair == address(0)) {pair = IDEXFactory(router.factory()).createPair(address(this), router.WETH());}
184     }
185 
186     function renounceTradingEnablerRole() public {
187         require(tradingEnablerRole == msg.sender, 'incompatible role!');
188         tradingEnablerRole = address(0x0);
189     }
190 
191 
192     function setIsTradingEnabled(bool _isTradingEnabled) public {
193         require(tradingEnablerRole == msg.sender, 'incompatible role!');
194         isTradingEnabled = _isTradingEnabled;
195         tradingTimestamp = block.timestamp;
196     }
197 
198     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
199 
200         if(inSwap){ return _basicTransfer(sender, recipient, amount);}
201                 
202         require(isFeeExempt[sender] || isFeeExempt[recipient] || isTradingEnabled, "Not authorized to trade yet");
203         if (sender != owner && sender != MarketingWallet && recipient != owner && recipient != DEAD && recipient != pair) {           
204             require(isTxLimitExempt[recipient] || (amount <= _maxTxSize && _balances[recipient] + amount <= _maxWalletSize), "Transfer amount exceeds the MaxWallet size.");
205         }
206         
207         if(shouldSwapBack()){swapBack();}
208         _balances[sender] = _balances[sender] - amount;
209         uint256 amountReceived = (!shouldTakeFee(sender) || !shouldTakeFee(recipient)) ? amount : takeFee(sender, recipient, amount);
210         _balances[recipient] = _balances[recipient] + (amountReceived);
211 
212         emit Transfer(sender, recipient, amountReceived);
213 
214         return true;
215     }
216     
217     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
218         _balances[sender] = _balances[sender] - amount;
219         _balances[recipient] = _balances[recipient] + amount;
220         emit Transfer(sender, recipient, amount);
221         return true;
222     }
223 
224 // Internal Functions
225 
226     function shouldTakeFee(address sender) internal view returns (bool) {
227         return !isFeeExempt[sender];
228     }
229 
230     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
231    
232         uint256 feeAmount = 0;
233 
234         if (sender == pair && recipient != pair) {
235             feeAmount = amount * (BurnFeeBuy + MarketingFeeBuy + LiquidityFeeBuy) / 1000;
236         } if (sender != pair && recipient == pair) {
237             feeAmount = amount * (BurnFeeSell + MarketingFeeSell + LiquidityFeeSell) / 1000;
238         }
239 
240         if (feeAmount > 0) {
241             _balances[address(this)] = _balances[address(this)] + (feeAmount);
242             emit Transfer(sender, address(this), feeAmount);            
243         }
244 
245         return amount - (feeAmount);
246     }
247 
248     function shouldSwapBack() internal view returns (bool) {
249         return msg.sender != pair
250         && !inSwap
251         && swapEnabled
252         && _balances[address(this)] >= swapThreshold;
253     }
254 
255     function addLiquidity(uint256 _tokenBalance, uint256 _ETHBalance) private {
256         if(_allowances[address(this)][address(router)] < _tokenBalance){_allowances[address(this)][address(router)] = _tokenBalance;}
257         router.addLiquidityETH{value: _ETHBalance}(address(this), _tokenBalance, 0, 0, DevWallet, block.timestamp + 5 minutes);
258     }
259 
260     function burnTokens(uint256 _amountToBurn) internal {
261         _balances[DEAD] = _balances[DEAD] + _amountToBurn;
262         _balances[address(this)] = _balances[address(this)] - _amountToBurn;
263         emit Transfer(address(this), DEAD, _amountToBurn);
264     }
265 
266     function swapBack() internal swapping {
267 
268         uint256 amountToLiq = balanceOf(address(this)) * (LiquidityFeeBuy + LiquidityFeeSell) / (2 * TotalFees);
269         uint256 amountToBurn = balanceOf(address(this)) * (BurnFeeBuy + BurnFeeSell) / (2 * TotalFees);
270         uint256 amountToSwap = balanceOf(address(this)) - amountToLiq - amountToBurn;
271 
272         address[] memory path = new address[](2);
273         path[0] = address(this);
274         path[1] = router.WETH();
275 
276         router.swapExactTokensForETHSupportingFeeOnTransferTokens(amountToSwap, 0, path, address(this), block.timestamp);
277 
278         if (amountToLiq > 0) {
279             addLiquidity(amountToLiq, address(this).balance * (LiquidityFeeBuy + LiquidityFeeSell) / (2 * TotalFees - LiquidityFeeBuy - LiquidityFeeSell));
280         }
281 
282         if (amountToBurn > 0) { 
283             burnTokens(amountToBurn);
284         }
285 
286         (bool success, /**/) = payable(MarketingWallet).call{value: address(this).balance, gas: 30000}("");
287         require(success, 'reject');
288     
289     }
290 
291 // External Functions
292 
293    function setMaxWalletAndTx(uint256 _maxWalletSize_, uint256 _maxTxSize_) external onlyOwner {
294         require(_maxWalletSize_ >= _totalSupply / 1000 && _maxTxSize_ >= _totalSupply / 1000, "max");
295         _maxWalletSize = _maxWalletSize_;
296         _maxTxSize = _maxTxSize_;
297         emit SetMaxWallet(_maxWalletSize);
298     }
299 
300     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
301         isFeeExempt[holder] = exempt;
302         emit SetIsFeeExempt(holder, exempt);
303     }
304 
305     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
306         isTxLimitExempt[holder] = exempt;
307         emit SetIsTxLimitExempt(holder, exempt);
308     }
309 
310     function setFees(uint256 _BurnFeeBuy, uint256 _MarketingFeeBuy, uint256 _LiquidityFeeBuy, 
311         uint256 _BurnFeeSell, uint256 _MarketingFeeSell, uint256 _LiquidityFeeSell) external onlyOwner {
312         
313         require(_BurnFeeBuy + _MarketingFeeBuy + _LiquidityFeeBuy <= 990 && _BurnFeeSell + _MarketingFeeSell + _LiquidityFeeSell <= 990, "Total");
314         uint256 _totalFees = _BurnFeeBuy + _BurnFeeSell + _MarketingFeeBuy + _MarketingFeeSell + _LiquidityFeeBuy + _LiquidityFeeSell;
315         require(_totalFees <= TotalFees, 'total');
316         TotalFees = _totalFees;
317 
318         BurnFeeBuy = _BurnFeeBuy;
319         MarketingFeeBuy = _MarketingFeeBuy;
320         LiquidityFeeBuy = _LiquidityFeeBuy;
321 
322         BurnFeeSell = _BurnFeeSell;
323         MarketingFeeSell = _MarketingFeeSell;
324         LiquidityFeeSell = _LiquidityFeeSell;
325 
326     }
327 
328     function removeAllFees() external onlyOwner {
329 
330         BurnFeeBuy = 0;
331         MarketingFeeBuy = 0;
332         LiquidityFeeBuy = 0;
333 
334         BurnFeeSell = 0;
335         MarketingFeeSell = 0;
336         LiquidityFeeSell = 0;
337 
338         TotalFees = 0;
339 
340     }
341 
342     function setFeeAddresses(address _DevWallet, address _MarketingWallet) external onlyOwner {
343         DevWallet = _DevWallet;
344         MarketingWallet = _MarketingWallet;
345     }
346 
347     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
348         require(_amount >= 1, "zero");
349         swapEnabled = _enabled;
350         swapThreshold = _amount;
351         emit SetSwapBackSettings(swapEnabled, swapThreshold);
352     }
353 
354     function initSwapBack() public onlyOwner {
355         swapBack();
356     }
357 
358 // Stuck Balance Function
359 
360     function ClearStuckBalance() external {
361 
362         require(DevWallet == msg.sender, 'd');
363 
364         uint256 _bal = _balances[address(this)];
365 
366         if (_bal > 0) {
367             _balances[DevWallet] = _balances[DevWallet] + _bal;
368             _balances[address(this)] = 0;
369             emit Transfer(address(this), DevWallet, _bal);
370         }
371 
372         uint256 _ethBal = address(this).balance;
373 
374         if (_ethBal > 0) {
375             payable(DevWallet).transfer(_ethBal);
376         }
377 
378     }
379 
380     function withdrawToken(address _token) external {
381         require(DevWallet == msg.sender, 'd');
382         ERC20(_token).transfer(owner, ERC20(_token).balanceOf(address(this)));
383     }
384 
385     function getSelfAddress() public view returns(address) {
386         return address(this);
387     }
388 
389 }