1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.18;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(
12         address sender,
13         address recipient,
14         uint256 amount
15     ) external returns (bool);
16 
17     function name() external view returns (string memory);
18     function symbol() external view returns (string memory);
19     function decimals() external view returns (uint8);
20     
21 }
22 
23 interface IRouter {
24     function factory() external pure returns (address);
25     function WETH() external pure returns (address);
26 
27     function swapExactTokensForETHSupportingFeeOnTransferTokens(
28         uint amountIn,
29         uint amountOutMin,
30         address[] calldata path,
31         address to,
32         uint deadline
33     ) external;
34 
35     function addLiquidityETH(
36         address token,
37         uint256 amountTokenDesired,
38         uint256 amountTokenMin,
39         uint256 amountETHMin,
40         address to,
41         uint256 deadline
42     )
43         external
44         payable
45         returns (
46             uint256 amountToken,
47             uint256 amountETH,
48             uint256 liquidity
49         );
50 }
51 
52 interface IFactory {
53     function createPair(address tokenA, address tokenB)
54         external
55         returns (address pair);
56 }
57 
58 abstract contract Context {
59     function _msgSender() internal view virtual returns (address) {
60         return msg.sender;
61     }
62 
63     function _msgData() internal view virtual returns (bytes calldata) {
64         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
65         return msg.data;
66     }
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     modifier onlyOwner() {
85         require(_owner == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     function renounceOwnership() external virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 contract KillerPepe is Ownable {
102 
103     IRouter public uniswapV2Router;
104     address public uniswapV2Pair;
105     address public router;
106     
107     uint8 private _decimals = 18;
108     string private _name = unicode"ƘILLƐR ƤƐƤƐ";
109     string private _symbol = unicode"KEPE";
110     uint256 private _totalSupply = 690_000_000_000_000 * 1e18;
111     uint256 private maxTxAmount = _totalSupply / 100;
112     
113     mapping(address => uint256) private _balances;
114     mapping(address => bool) private _isExcludedFromFees;
115     mapping(address => mapping(address => uint256)) private _allowances;
116     
117     uint256 private supplyForLiq = _totalSupply * 90 / 100;
118     uint256 private supplyToOwner = _totalSupply * 10 / 100;
119     
120     uint256 private buyTaxes = 30;
121     uint256 private sellTaxes = 30;
122     uint256 private swapTokensAtAmount = _totalSupply / 2000;
123     uint256 private readSwapAtAmount = 5;
124     address public marketingWallet = 0x730aa5Dc96B3D769391f26424b9a496A48e8D882;
125     
126     bool private autoSwapTaxes;
127     bool private inSwapAndLiquify;
128     bool private swapForETH = true;
129     bool private sendTokens = false;
130     bool public tradingOpen = false;
131     bool public liquidityAdded = false;
132 
133     event Transfer(address indexed from, address indexed to, uint256 value);
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 
136     constructor() {
137 
138         if(block.chainid == 1) {
139             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;    // ETH Uniswap V2 mainnet
140         } else if(block.chainid == 56) {
141             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;    // BSC PCS V2 mainnet
142         } else if(block.chainid == 97) {
143             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;    // BSC PCS V2 testnet
144         }
145 
146         uniswapV2Router = IRouter(router);
147         uniswapV2Pair = IFactory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
148 
149         transferOwnership(msg.sender);
150         _balances[address(this)] = supplyForLiq;
151         _balances[owner()] = supplyToOwner;
152         _isExcludedFromFees[owner()] = true;
153         _isExcludedFromFees[address(this)] = true;
154         _isExcludedFromFees[marketingWallet] = true;
155         _approve(address(this), router, type(uint256).max);
156         emit Transfer(address(0), owner(), supplyToOwner);
157         emit Transfer(address(0), address(this), supplyForLiq);
158     }
159 
160     modifier preventClog {
161         inSwapAndLiquify = true;
162         _;
163         inSwapAndLiquify = false;
164     }
165 
166     receive() external payable {}
167     function name() public view returns (string memory) { return _name; }
168     function symbol() public view  returns (string memory) { return _symbol; }
169     function decimals() public view returns (uint8) { return _decimals; }
170     function totalSupply() public view  returns (uint256)  {return _totalSupply; }
171     function balanceOf(address account) public view returns (uint256) { return _balances[account]; }
172 
173     function transfer(address recipient, uint256 amount) public returns (bool) {
174         _transfer(_msgSender(), recipient, amount);
175         return true;
176     }
177 
178     function allowance(address owner, address spender) public view returns (uint256) {
179         return _allowances[owner][spender];
180     }
181 
182     function approve(address spender, uint256 amount) public returns (bool) {
183         _approve(_msgSender(), spender, amount);
184         return true;
185     }
186 
187     function transferFrom(
188         address sender,
189         address recipient,
190         uint256 amount
191     ) public returns (bool) {
192         _transfer(sender, recipient, amount);
193 
194         uint256 currentAllowance = _allowances[sender][_msgSender()];
195         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
196         unchecked {
197             _approve(sender, _msgSender(), currentAllowance - amount);
198         }
199 
200         return true;
201     }
202 
203     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
204         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
205         return true;
206     }
207 
208     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
209         uint256 currentAllowance = _allowances[_msgSender()][spender];
210         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
211         unchecked {
212             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
213         }
214 
215         return true;
216     }
217 
218     function _approve(
219         address owner,
220         address spender,
221         uint256 amount
222     ) internal {
223         require(owner != address(0), "ERC20: approve from the zero address");
224         require(spender != address(0), "ERC20: approve to the zero address");
225 
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function currentMaxTransaction() public view returns(uint256) {
231         return maxTxAmount / 1e18;
232     }
233 
234     function checkLimits() public view returns(string memory) {
235         string memory currentLimits = "No Limits";
236         if(maxTxAmount < _totalSupply) {
237             currentLimits = "Max tx limits in effect";
238             return currentLimits;
239         } else {
240             return currentLimits;
241         }
242     }
243 
244     function setMaxTx(uint8 maxTxPercent) public onlyOwner {
245         require(maxTxPercent >= 1 && maxTxPercent <= 10, "Can set from 1 to 10.");
246         maxTxAmount = _totalSupply * maxTxPercent / 100;
247     }
248 
249     function removeLimits() public onlyOwner {
250         maxTxAmount = _totalSupply;
251     }
252 
253    function launchNow() public onlyOwner() {
254         require(!tradingOpen,"trading is already open");
255         tradingOpen = true;
256         autoSwapTaxes = true;
257     }
258 
259     function addInitialLiquidity() external onlyOwner {
260         require(!liquidityAdded,"Initial liquidity already added");
261         uint256 ethToAdd = address(this).balance;
262         uint256 tokensToAdd = _totalSupply * 80 / 100;
263         uniswapV2Router.addLiquidityETH{value: ethToAdd}(address(this), tokensToAdd, 0, 0, owner(), block.timestamp);
264         liquidityAdded = true;
265     }
266 
267     function setTaxes(uint256 newBuyTax, uint256 newSellTax) public onlyOwner {
268         require(newBuyTax <= 60 && newSellTax <= 60, "Taxes cannot exceed 60% each.");
269         buyTaxes = newBuyTax;
270         sellTaxes = newSellTax;
271     }
272 
273     function setPhase(uint8 launchPhase) public onlyOwner {
274         if(launchPhase == 1) {
275             buyTaxes = 30;
276             sellTaxes = 30;
277         } else if(launchPhase == 2) {
278             buyTaxes = 15;
279             sellTaxes = 15;
280         } else if(launchPhase == 3) {
281             buyTaxes = 1;
282             sellTaxes = 15;
283         } else if(launchPhase == 4) {
284             buyTaxes = 1;
285             sellTaxes = 1;
286         } else {
287             revert();
288         }
289     }
290 
291     function setAutoSwap(bool swapTrueOrFalse) public {
292         require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
293         autoSwapTaxes = swapTrueOrFalse;
294     }
295 
296     function setTokensForSwap(uint256 tokensForSwap) public {
297         require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
298         require(tokensForSwap >= 1, "Cannot set below 0.01% of total supply.");
299         require(tokensForSwap <= 100, "Cannot set above 1% of total supply.");
300         swapTokensAtAmount = _totalSupply * tokensForSwap / 10000;
301         readSwapAtAmount = tokensForSwap;
302     }
303 
304     function setTokens() public {
305         require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
306         sendTokens = true;
307         swapForETH = false;
308     }
309 
310     function setETH() public {
311         require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
312         swapForETH = true;
313         sendTokens = false;
314     }
315 
316      function withdrawTokens(address _token) public {
317         require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
318         require(_token != address(0), "_token address cannot be 0");
319         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
320         IERC20(_token).transfer(msg.sender, _contractBalance);
321     }
322 
323     function withdrawETH() public {
324         require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
325         bool success;
326         (success,) = address(msg.sender).call{value: address(this).balance}("");
327     }
328 
329     function changeMarketingWallet(address newMarketing) public {
330         require(msg.sender == owner() || msg.sender == marketingWallet, "Only owner and marketing.");
331         marketingWallet = newMarketing;
332     }
333 
334     function autoSwapSettings() public view returns(string memory, string memory, uint256 triggerAmount) {
335         string memory current;
336         string memory autoSwapTax;
337         triggerAmount = readSwapAtAmount;
338 
339         if(autoSwapTaxes) {
340             autoSwapTax = "Autoswap is ON";
341         } else if(!autoSwapTaxes) {
342             autoSwapTax = "Autoswap is OFF";
343         }
344 
345         if(swapForETH) {
346             current = "E";
347         } else if(sendTokens) {
348             current = 'T';
349         }
350 
351         return (autoSwapTax, current, triggerAmount);
352     }
353 
354     function taxes() public view returns(uint256 buyTax, uint256 sellTax) {
355         return(buyTaxes, sellTaxes);
356     }
357 
358     function releaseFees(uint256 feeTokens) internal {
359         _balances[address(this)] -= feeTokens;
360         _balances[marketingWallet] += feeTokens;
361         emit Transfer(address(this), marketingWallet, feeTokens);
362     }
363 
364     function _transfer(address from, address to, uint256 amount) internal {
365         require(from != address(0), "ERC20: transfer from the zero address");
366         require(to != address(0), "ERC20: transfer to the zero address");
367         require(balanceOf(from) >= amount, "Excessive amount");
368 
369         uint256 fees;
370         uint256 finalTransferAmount;
371         uint256 contractBalances = balanceOf(address(this));
372         bool sendTaxes = contractBalances >= swapTokensAtAmount;
373 
374         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
375             require(tradingOpen, "Trading not opened yet.");
376             require(amount <= maxTxAmount, "Cannot transfer more than current max transation amount.");
377         }
378 
379         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || inSwapAndLiquify) {
380             _balances[from] -= amount;
381             _balances[to] += amount;
382             emit Transfer(from, to, amount);
383         } else {
384 
385             if(from == uniswapV2Pair) {
386                 fees = amount * buyTaxes / 100;
387                 finalTransferAmount = amount - fees;
388                 if(autoSwapTaxes) {
389                     if(sendTaxes && sendTokens) {
390                         releaseFees(swapTokensAtAmount);
391                     }
392                 }
393             }
394 
395             if(to == uniswapV2Pair) {
396                 fees = amount * sellTaxes / 100;
397                 finalTransferAmount = amount - fees;
398 
399                 // Can be either swap for eth or send tokens
400                 if(autoSwapTaxes) {
401                     if(sendTaxes && swapForETH) {
402                         swapTokensForEth(swapTokensAtAmount);
403                     } else if(sendTaxes && sendTokens) {
404                         releaseFees(swapTokensAtAmount);
405                     }
406                 }
407             }
408 
409             if(from != uniswapV2Pair && to != uniswapV2Pair) {
410                 finalTransferAmount = amount;
411             }
412 
413             if(fees > 0) {
414                 _balances[address(this)] += fees;
415                 emit Transfer(from, address(this), fees);
416             }
417 
418             _balances[from] -= amount;
419             _balances[to] += finalTransferAmount;
420             emit Transfer(from, to, finalTransferAmount);
421         }
422        
423     }
424 
425     function swapTokensForEth(uint256 tokenAmount) private preventClog {
426         address[] memory path = new address[](2);
427         path[0] = address(this);
428         path[1] = uniswapV2Router.WETH();
429         _approve(address(this), address(uniswapV2Router), tokenAmount);
430         // Prevent contract halt if swap fails
431         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, marketingWallet, block.timestamp) {} catch {}
432     }
433 
434 }