1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.8;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function decimals() external view returns (uint8);
8 
9     function symbol() external view returns (string memory);
10 
11     function name() external view returns (string memory);
12 
13     function getOwner() external view returns (address);
14 
15     function balanceOf(address account) external view returns (uint256);
16 
17     function transfer(address recipient, uint256 amount) external returns (bool);
18 
19     function allowance(address _owner, address spender) external view returns (uint256);
20 
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 interface IFactoryV2 {
34     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
35 
36     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
37 
38     function createPair(address tokenA, address tokenB) external returns (address lpPair);
39 }
40 
41 interface IV2Pair {
42     function factory() external view returns (address);
43 
44     function getReserves()
45         external
46         view
47         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
48 
49     function sync() external;
50 }
51 
52 interface IRouter01 {
53     function factory() external pure returns (address);
54 
55     function WETH() external pure returns (address);
56 
57     function addLiquidityETH(
58         address token,
59         uint amountTokenDesired,
60         uint amountTokenMin,
61         uint amountETHMin,
62         address to,
63         uint deadline
64     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
65 
66     function addLiquidity(
67         address tokenA,
68         address tokenB,
69         uint amountADesired,
70         uint amountBDesired,
71         uint amountAMin,
72         uint amountBMin,
73         address to,
74         uint deadline
75     ) external returns (uint amountA, uint amountB, uint liquidity);
76 
77     function swapExactETHForTokens(
78         uint amountOutMin,
79         address[] calldata path,
80         address to,
81         uint deadline
82     ) external payable returns (uint[] memory amounts);
83 
84     function getAmountsOut(
85         uint amountIn,
86         address[] calldata path
87     ) external view returns (uint[] memory amounts);
88 
89     function getAmountsIn(
90         uint amountOut,
91         address[] calldata path
92     ) external view returns (uint[] memory amounts);
93 }
94 
95 interface IRouter02 is IRouter01 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103 
104     function swapExactETHForTokensSupportingFeeOnTransferTokens(
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external payable;
110 
111     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
112         uint amountIn,
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external;
118 
119     function swapExactTokensForTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external returns (uint[] memory amounts);
126 }
127 
128 contract WoofMeister is IERC20 {
129     //IRouter02 dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //BSC Mainnet
130     //IRouter02 dexRouter = IRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1); //BSC Testnet
131     //IRouter02 dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //ETH Mainnet
132     IRouter02 dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //ETH Goerli
133     address payable public marketingWallet = payable(0x31E403D6A22f75F46498b56199EcD809874609C2);
134 
135     string private constant _name = "WOOFMEISTER";
136     string private constant _symbol = "WOOFME";
137     uint8 private constant _decimals = 18;
138     uint256 private constant _totalSupply = 100_000_000_000_000 * 10 ** (_decimals);
139     address private _owner;
140 
141     mapping(address => mapping(address => uint256)) private _allowances;
142     mapping(address => uint256) private _balances;
143     mapping(address => bool) public _whitelistAddress;
144 
145     uint256 maxWalletPercent = 15; //1.5% as default
146     uint256 minAmountConvert = 100_000_000_000 * 10 ** (_decimals);
147     uint8 maximumImpactForTransfer = 50;
148     bool inSwap;
149     address public pairAddress;
150 
151     uint256 tax = 200;
152     uint256 taxAntibot = 3000;
153     uint256 public timeTradeOpen = 0;
154     uint256 public timeAntiBot = 5;
155 
156     modifier onlyOwner() {
157         require(_owner == msg.sender, "Only owner");
158         _;
159     }
160 
161     modifier inSwapFlag() {
162         inSwap = true;
163         _;
164         inSwap = false;
165     }
166 
167     constructor() payable {
168         _owner = msg.sender;
169         _balances[_owner] = _totalSupply;
170         _whitelistAddress[_owner] = true;
171         _whitelistAddress[address(this)] = true;
172         _approve(_owner, address(dexRouter), type(uint256).max);
173         _approve(address(this), address(dexRouter), type(uint256).max);
174         pairAddress = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
175     }
176 
177     function totalSupply() external pure override returns (uint256) {
178         if (_totalSupply == 0) {
179             revert();
180         }
181         return _totalSupply;
182     }
183 
184     function decimals() external pure override returns (uint8) {
185         if (_totalSupply == 0) {
186             revert();
187         }
188         return _decimals;
189     }
190 
191     function symbol() external pure override returns (string memory) {
192         return _symbol;
193     }
194 
195     function name() external pure override returns (string memory) {
196         return _name;
197     }
198 
199     function getOwner() external view override returns (address) {
200         return _owner;
201     }
202 
203     function allowance(address holder, address spender) external view override returns (uint256) {
204         return _allowances[holder][spender];
205     }
206 
207     function balanceOf(address account) public view override returns (uint256) {
208         return _balances[account];
209     }
210 
211     function transferOwner(address _newOwner) public onlyOwner {
212         _owner = _newOwner;
213     }
214 
215     function approve(address spender, uint256 amount) external override returns (bool) {
216         _approve(msg.sender, spender, amount);
217         return true;
218     }
219 
220     function _approve(address sender, address spender, uint256 amount) internal {
221         require(sender != address(0), "ERC20: Zero Address");
222         require(spender != address(0), "ERC20: Zero Address");
223         _allowances[sender][spender] = amount;
224         emit Approval(sender, spender, amount);
225     }
226 
227     function transfer(address recipient, uint256 amount) public override returns (bool) {
228         _transfer(msg.sender, recipient, amount);
229         return true;
230     }
231 
232     function transferFrom(
233         address sender,
234         address recipient,
235         uint256 amount
236     ) external override returns (bool) {
237         require(_allowances[sender][msg.sender] >= amount, "Insufficient allowance.");
238         _allowances[sender][msg.sender] -= amount;
239         _transfer(sender, recipient, amount);
240         return true;
241     }
242 
243     function setTimeForTradeOpenning(uint256 _timeOpen) public onlyOwner {
244         require(_timeOpen > 0, "Invalid parameter.");
245         timeTradeOpen = _timeOpen;
246     }
247 
248     function setTimeAntibot(uint256 _timeAntiInMinutes) public onlyOwner {
249         require(_timeAntiInMinutes > 0, "Invalid parameter.");
250         timeAntiBot = _timeAntiInMinutes;
251     }
252 
253     function setAntibotTax(uint256 _newAntibotTax) public onlyOwner {
254         require(_newAntibotTax > 0, "Invalid parameter.");
255         taxAntibot = _newAntibotTax;
256     }
257 
258     function isEnableTrade() public view returns (bool) {
259         bool isEnable = false;
260         if (block.timestamp >= timeTradeOpen) {
261             isEnable = true;
262         }
263         return isEnable;
264     }
265 
266     function isAntiSniperEnable() public view returns (bool) {
267         bool isEnable = false;
268         if (block.timestamp <= (timeTradeOpen + timeAntiBot * 60)) {
269             isEnable = true;
270         }
271         return isEnable;
272     }
273 
274     function getRateForTrade() public view returns (uint256) {
275         uint256 realTax = tax;
276         if (isAntiSniperEnable()) {
277             realTax = taxAntibot;
278         }
279         return realTax;
280     }
281 
282     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
283         require(amount <= balanceOf(from), "Insufficient funds.");
284         if (to == pairAddress && timeTradeOpen == 0) {
285             timeTradeOpen = block.timestamp;
286         }
287         uint256 currentWalletBalance = balanceOf(to);
288         uint maximumAmountTokenPerWallet = (_totalSupply * maxWalletPercent) / 1000;
289         if ((currentWalletBalance + amount) > maximumAmountTokenPerWallet) {
290             if (to != address(0) && to != pairAddress && to != address(this)) {
291                 revert("A wallet can only hold up to a specified percentage of the total supply.");
292             }
293         }
294         if (!_whitelistAddress[from] && !_whitelistAddress[to] && to == pairAddress) {
295             bool enableTrade = isEnableTrade();
296             if (enableTrade) {
297                 if (!inSwap) {
298                     uint256 contractBalance = balanceOf(address(this));
299                     if (contractBalance >= minAmountConvert) {
300                         uint256 maximumSwapAmount = balanceOf(pairAddress) /
301                             maximumImpactForTransfer;
302                         if (contractBalance > maximumSwapAmount)
303                             contractBalance = maximumSwapAmount;
304                         bool payFee = convertAccumulateFee(contractBalance);
305                         require(payFee, "Failed to convert accumulated fees.");
306                     }
307                 }
308                 uint256 realTax = getRateForTrade();
309                 uint256 taxAmount = (amount * realTax) / 10000;
310                 _balances[from] -= amount;
311                 _balances[address(this)] += taxAmount;
312                 emit Transfer(from, address(this), taxAmount);
313                 _balances[to] += (amount - taxAmount);
314                 emit Transfer(from, to, amount - taxAmount);
315             } else {
316                 revert("Not open for trading.");
317             }
318         } else {
319             _balances[from] -= amount;
320             _balances[to] += amount;
321             emit Transfer(from, to, amount);
322         }
323         return true;
324     }
325 
326     function convertAccumulateFee(uint256 contractBalance) internal inSwapFlag returns (bool) {
327         if (_allowances[address(this)][address(dexRouter)] != type(uint256).max) {
328             _allowances[address(this)][address(dexRouter)] = type(uint256).max;
329         }
330         address[] memory path = new address[](2);
331         path[0] = address(this);
332         path[1] = dexRouter.WETH();
333         try
334             dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
335                 contractBalance,
336                 0,
337                 path,
338                 address(this),
339                 block.timestamp
340             )
341         {} catch {
342             return false;
343         }
344         (bool success, ) = marketingWallet.call{value: address(this).balance}("");
345         require(success, "Failed to transfer fee to marketing wallet.");
346         return true;
347     }
348 
349     function setTax(uint256 _newTax) public onlyOwner {
350         require(_newTax <= 200, "Tax cannot be  more than 2%.");
351         tax = _newTax;
352     }
353 
354     function setMinAmountConvert(uint256 _minAmountConvert) public onlyOwner {
355         minAmountConvert = _minAmountConvert;
356     }
357 
358     function setMaximumImpactForTransfer(uint8 _maximumImpactForTransfer) public onlyOwner {
359         require(_maximumImpactForTransfer > 1, "Invalid parameter.");
360         maximumImpactForTransfer = _maximumImpactForTransfer;
361     }
362 
363     function setMaxWalletPercent(uint256 _newPercent) public onlyOwner {
364         require(_newPercent > 0 && _newPercent < 1000, "Invalid parameter.");
365         maxWalletPercent = _newPercent;
366     }
367 
368     function setMarketingWallet(address payable _marketingWallet) public onlyOwner {
369         require(
370             _marketingWallet != marketingWallet,
371             "It must be different from the current marketing wallet."
372         );
373         require(_marketingWallet != address(0), "It must not be a zero wallet.");
374         marketingWallet = payable(_marketingWallet);
375     }
376 
377     function setWhiteList(address _whitelist) public onlyOwner {
378         _whitelistAddress[_whitelist] = true;
379     }
380 
381     function removeWhiteList(address _removeWhitelist) public onlyOwner {
382         _whitelistAddress[_removeWhitelist] = false;
383     }
384 
385     function airdrop(address recipient, uint256 amount) external onlyOwner {
386         _transfer(msg.sender, recipient, amount * 10 ** _decimals);
387     }
388 
389     function airdropInternal(address recipient, uint256 amount) internal {
390         _transfer(msg.sender, recipient, amount);
391     }
392 
393     function airdropArray(
394         address[] calldata newholders,
395         uint256[] calldata amounts
396     ) external onlyOwner {
397         require(newholders.length == amounts.length, "They must be the same length.");
398         uint256 iterator = 0;
399         while (iterator < newholders.length) {
400             require(newholders[iterator] != address(0), "Invalid airdrop holder.");
401             require(amounts[iterator] > 0, "Invalid airdrop amount.");
402             airdropInternal(newholders[iterator], amounts[iterator] * 10 ** _decimals);
403             iterator += 1;
404         }
405     }
406 
407 
408 
409     receive() external payable {}
410 }