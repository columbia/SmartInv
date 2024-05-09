1 // SPDX-License-Identifier: MIT
2 
3 // Fluid Token
4 // https://fluid.trade
5 
6 
7 pragma solidity 0.8.21;
8 pragma experimental ABIEncoderV2;
9 
10 abstract contract Ownable {
11     address private _owner;
12 
13     constructor() {
14         _owner = msg.sender;
15     }
16 
17     function owner() public view virtual returns (address) {
18         return _owner;
19     }
20 
21     modifier onlyOwner() {
22         require(owner() == msg.sender, "Ownable: caller is not the owner");
23         _;
24     }
25 
26     function renounceOwnership() public virtual onlyOwner {
27         _owner = address(0);
28     }
29 }
30 
31 library SafeERC20 {
32     function safeTransfer(address token, address to, uint256 value) internal {
33         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.transfer.selector, to, value));
34         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: INTERNAL TRANSFER_FAILED');
35     }
36 }
37 
38 interface IERC20 {
39     function balanceOf(address account) external view returns (uint256);
40     function transfer(address recipient, uint256 amount) external;
41     function approve(address spender, uint256 amount) external returns (bool);
42 }
43 
44 interface IUniswapV2Factory {
45     function createPair(address tokenA, address tokenB) external returns (address pair);
46 }
47 
48 interface IUniswapV2Router02 {
49     function factory() external pure returns (address);
50 
51     function WETH() external pure returns (address);
52 
53     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
54 
55     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
56 }
57 
58 contract Fluid is Ownable {
59     string private constant _name = unicode"Fluid";
60     string private constant _symbol = unicode"FLUID";
61     uint256 private constant _totalSupply = 10_000_000 * 1e18;
62 
63     uint256 public maxTransactionAmount = 120_000 * 1e18; //1.2%
64     uint256 public maxWallet = 120_000 * 1e18; //1.2%
65     uint256 public swapTokensAtAmount = (_totalSupply * 2) / 10000; //0.02%
66 
67     address public revWallet = 0x92795b9dC4Fa484fA8E045f403Eaa028093717Ad;
68     address public treasuryWallet = 0xb6C7BB9592E1dcBF011Ac248DFe5cB3D2220E093;
69     address public teamWallet = 0x243Dc5958513c6B668a4556061D897E72F2f56F7;
70     address public saleContract = 0x1412DcdB4508e199b6F4ee869D50234d59b70F32;
71     address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
72 
73     uint8 public buyTotalFees = 50;
74     uint8 public sellTotalFees = 50;
75 
76     uint8 public revFee = 40;
77     uint8 public treasuryFee = 20;
78     uint8 public teamFee = 40;
79 
80     bool private swapping;
81     bool public limitsInEffect = true;
82     bool private launched;
83 
84     mapping(address => uint256) private _balances;
85     mapping(address => mapping(address => uint256)) private _allowances;
86     mapping(address => bool) private _isExcludedFromFees;
87     mapping(address => bool) private _isExcludedMaxTransactionAmount;
88     mapping(address => bool) private automatedMarketMakerPairs;
89 
90     event SwapAndLiquify(uint256 tokensSwapped, uint256 teamETH, uint256 revETH, uint256 TreasuryETH);
91     event Transfer(address indexed from, address indexed to, uint256 value);
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 
94     IUniswapV2Router02 public constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
95     address public uniswapV2Pair;
96 
97     constructor() {
98 
99         setExcludedFromFees(owner(), true);
100         setExcludedFromFees(address(this), true);
101         setExcludedFromFees(address(0xdead), true);
102         setExcludedFromFees(teamWallet, true);
103         setExcludedFromFees(revWallet, true);
104         setExcludedFromFees(treasuryWallet, true);
105 
106         setExcludedFromMaxTransaction(owner(), true);
107         setExcludedFromMaxTransaction(address(uniswapV2Router), true);
108         setExcludedFromMaxTransaction(address(this), true);
109         setExcludedFromMaxTransaction(address(0xdead), true);
110         setExcludedFromMaxTransaction(address(uniswapV2Pair), true);
111         setExcludedFromMaxTransaction(teamWallet, true);
112         setExcludedFromMaxTransaction(revWallet, true);
113         setExcludedFromMaxTransaction(treasuryWallet, true);
114         setExcludedFromMaxTransaction(saleContract, true);
115 
116 
117         _balances[saleContract] = 6_000_000 * 1e18;
118         emit Transfer(address(0), saleContract, _balances[saleContract]);
119 
120         _balances[treasuryWallet] = 1_500_000 * 1e18;
121         emit Transfer(address(0), treasuryWallet, _balances[treasuryWallet]);
122 
123         _balances[teamWallet] = 500_000 * 1e18;
124         emit Transfer(address(0), teamWallet, _balances[teamWallet]);
125 
126         _balances[address(this)] = 2_000_000 * 1e18;
127         emit Transfer(address(0), address(this), _balances[address(this)]);
128 
129         _approve(address(this), address(uniswapV2Router), type(uint256).max);
130     }
131 
132     receive() external payable {}
133 
134     function name() public pure returns (string memory) {
135         return _name;
136     }
137 
138     function symbol() public pure returns (string memory) {
139         return _symbol;
140     }
141 
142     function decimals() public pure returns (uint8) {
143         return 18;
144     }
145 
146     function totalSupply() public pure returns (uint256) {
147         return _totalSupply;
148     }
149 
150     function balanceOf(address account) public view returns (uint256) {
151         return _balances[account];
152     }
153 
154     function allowance(address owner, address spender) public view returns (uint256) {
155         return _allowances[owner][spender];
156     }
157 
158     function approve(address spender, uint256 amount) external returns (bool) {
159         _approve(msg.sender, spender, amount);
160         return true;
161     }
162 
163     function _approve(address owner, address spender, uint256 amount) private {
164         require(owner != address(0), "ERC20: approve from the zero address");
165         require(spender != address(0), "ERC20: approve to the zero address");
166 
167         _allowances[owner][spender] = amount;
168         emit Approval(owner, spender, amount);
169     }
170 
171     function transfer(address recipient, uint256 amount) external returns (bool) {
172         _transfer(msg.sender, recipient, amount);
173         return true;
174     }
175 
176     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
177         uint256 currentAllowance = _allowances[sender][msg.sender];
178         if (currentAllowance != type(uint256).max) {
179             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
180             unchecked {
181                 _approve(sender, msg.sender, currentAllowance - amount);
182             }
183         }
184 
185         _transfer(sender, recipient, amount);
186 
187         return true;
188     }
189 
190     function _transfer(address from, address to, uint256 amount) private {
191         require(from != address(0), "ERC20: transfer from the zero address");
192         require(to != address(0), "ERC20: transfer to the zero address");
193         require(amount > 0, "Transfer amount must be greater than zero");
194 
195         if (!launched && (from != owner() && from != address(this) && to != owner())) {
196             revert("Trading not enabled");
197         }
198 
199         if (limitsInEffect) {
200             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {
201                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
202                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTx");
203                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
204                 } else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
205                     require(amount <= maxTransactionAmount,"Sell transfer amount exceeds the maxTx");
206                 } else if (!_isExcludedMaxTransactionAmount[to]) {
207                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
208                 }
209             }
210         }
211 
212         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
213 
214         if (canSwap && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
215             swapping = true;
216             swapBack();
217             swapping = false;
218         }
219 
220         bool takeFee = !swapping;
221 
222         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
223             takeFee = false;
224         }
225 
226         uint256 senderBalance = _balances[from];
227         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
228 
229         uint256 fees = 0;
230         if (takeFee) {
231             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
232                 fees = (amount * sellTotalFees) / 1000;
233             } else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
234                 fees = (amount * buyTotalFees) / 1000;
235             }
236 
237             if (fees > 0) {
238                 unchecked {
239                     amount = amount - fees;
240                     _balances[from] -= fees;
241                     _balances[address(this)] += fees;
242                 }
243                 emit Transfer(from, address(this), fees);
244             }
245         }
246         unchecked {
247             _balances[from] -= amount;
248             _balances[to] += amount;
249         }
250         emit Transfer(from, to, amount);
251     }
252 
253     function removeLimits() external onlyOwner {
254         limitsInEffect = false;
255     }
256 
257     function setDistributionFees(uint8 _RevFee, uint8 _TreasuryFee, uint8 _teamFee) external onlyOwner {
258         revFee = _RevFee;
259         treasuryFee = _TreasuryFee;
260         teamFee = _teamFee;
261         require((revFee + treasuryFee + teamFee) == 100, "Distribution must to be equal to 100%");
262     }
263 
264     function setFees(uint8 _buyTotalFees, uint8 _sellTotalFees) external onlyOwner {
265         require(_buyTotalFees <= 50, "Buy fees must be less than or equal to 5%");
266         require(_sellTotalFees <= 50, "Sell fees must be less than or equal to 5%");
267         buyTotalFees = _buyTotalFees;
268         sellTotalFees = _sellTotalFees;
269     }
270 
271     function setExcludedFromFees(address account, bool excluded) public onlyOwner {
272         _isExcludedFromFees[account] = excluded;
273     }
274 
275     function setExcludedFromMaxTransaction(address account, bool excluded) public onlyOwner {
276         _isExcludedMaxTransactionAmount[account] = excluded;
277     }
278 
279     function bulkSendTokens(address[] memory addresses, uint256[] memory amounts) external onlyOwner {
280         require(!launched, "Already launched");
281         for (uint256 i = 0; i < addresses.length; i++) {
282             require(_balances[msg.sender] >= amounts[i], "ERC20: transfer amount exceeds balance");
283             _balances[addresses[i]] += amounts[i];
284             _balances[msg.sender] -= amounts[i];
285             emit Transfer(msg.sender, addresses[i], amounts[i]);
286         }
287     }
288 
289     function openTheFloodGates() external onlyOwner {
290         require(!launched, "Already launched");
291         launched = true;
292     }
293 
294     function fillThePool() external payable onlyOwner {
295         require(!launched, "Already launched");
296 
297         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), WETH);
298 
299         _approve(address(this), address(uniswapV2Pair), type(uint256).max);
300 
301         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
302 
303         automatedMarketMakerPairs[uniswapV2Pair] = true;
304 
305         setExcludedFromMaxTransaction(address(uniswapV2Pair), true);
306 
307         uniswapV2Router.addLiquidityETH{value: msg.value}(
308             address(this),
309             _balances[address(this)],
310             0,
311             0,
312             teamWallet,
313             block.timestamp
314         );
315     }
316 
317     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
318         require(pair != uniswapV2Pair, "The pair cannot be removed");
319         automatedMarketMakerPairs[pair] = value;
320     }
321 
322     function setSwapAtAmount(uint256 newSwapAmount) external onlyOwner {
323         require(newSwapAmount >= (totalSupply() * 1) / 100000, "Swap amount cannot be lower than 0.001% of the supply");
324         require(newSwapAmount <= (totalSupply() * 5) / 1000, "Swap amount cannot be higher than 0.5% of the supply");
325         swapTokensAtAmount = newSwapAmount;
326     }
327 
328     function setMaxTxnAmount(uint256 newMaxTx) external onlyOwner {
329         require(newMaxTx >= ((totalSupply() * 1) / 1000) / 1e18, "Cannot set max transaction lower than 0.1%");
330         maxTransactionAmount = newMaxTx * (10**18);
331     }
332 
333     function setMaxWalletAmount(uint256 newMaxWallet) external onlyOwner {
334         require(newMaxWallet >= ((totalSupply() * 1) / 1000) / 1e18, "Cannot set max wallet lower than 0.1%");
335         maxWallet = newMaxWallet * (10**18);
336     }
337 
338     function updateRevWallet(address newAddress) external onlyOwner {
339         require(newAddress != address(0), "Address cannot be zero");
340         revWallet = newAddress;
341     }
342 
343     function updateTreasuryWallet(address newAddress) external onlyOwner {
344         require(newAddress != address(0), "Address cannot be zero");
345         treasuryWallet = newAddress;
346     }
347 
348     function updateTeamWallet(address newAddress) external onlyOwner {
349         require(newAddress != address(0), "Address cannot be zero");
350         teamWallet = newAddress;
351     }
352 
353     function excludedFromFee(address account) public view returns (bool) {
354         return _isExcludedFromFees[account];
355     }
356 
357     function withdrawStuckToken(address token, address to) external onlyOwner {
358         uint256 _contractBalance = IERC20(token).balanceOf(address(this));
359         SafeERC20.safeTransfer(token, to, _contractBalance); // Use safeTransfer
360     }
361 
362     function withdrawStuckETH(address addr) external onlyOwner {
363         require(addr != address(0), "Invalid address");
364 
365         (bool success, ) = addr.call{value: address(this).balance}("");
366         require(success, "Withdrawal failed");
367     }
368 
369     function swapBack() private {
370         uint256 swapThreshold = swapTokensAtAmount;
371         bool success;
372 
373         if (balanceOf(address(this)) > swapTokensAtAmount * 20) {
374             swapThreshold = swapTokensAtAmount * 20;
375         }
376 
377         address[] memory path = new address[](2);
378         path[0] = address(this);
379         path[1] = WETH;
380 
381         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(swapThreshold, 0, path, address(this), block.timestamp);
382 
383         uint256 ethBalance = address(this).balance;
384         if (ethBalance > 0) {
385             uint256 ethForRev = (ethBalance * revFee) / 100;
386             uint256 ethForTeam = (ethBalance * teamFee) / 100;
387             uint256 ethForTreasury = ethBalance - ethForRev - ethForTeam;
388 
389             (success, ) = address(teamWallet).call{value: ethForTeam}("");
390             (success, ) = address(treasuryWallet).call{value: ethForTreasury}("");
391             (success, ) = address(revWallet).call{value: ethForRev}("");
392 
393             emit SwapAndLiquify(swapThreshold, ethForTeam, ethForRev, ethForTreasury);
394         }
395     }
396 }