1 pragma solidity ^0.8.10;
2 // SPDX-License-Identifier: MIT
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library SafeMath {
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30 
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34         return c;
35     }
36 
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41         uint256 c = a * b;
42         require(c / a == b, "SafeMath: multiplication overflow");
43         return c;
44     }
45 
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49 
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b > 0, errorMessage);
52         uint256 c = a / b;
53         return c;
54     }
55 }
56 
57 contract Ownable is Context {
58     address private _owner;
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     constructor() {
62         address msgSender = _msgSender();
63         _owner = msgSender;
64         emit OwnershipTransferred(address(0), msgSender);
65     }
66 
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     modifier onlyOwner() {
72         require(_owner == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     function renounceOwnership() public virtual onlyOwner {
77         _setOwner(address(0));
78     }
79 
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _setOwner(newOwner);
83     }
84 
85     function _setOwner(address newOwner) private {
86         address oldOwner = _owner;
87         _owner = newOwner;
88         emit OwnershipTransferred(oldOwner, newOwner);
89     }
90 }
91 
92 interface IUniswapV2Factory {
93     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
94 
95     function feeTo() external view returns (address);
96     function feeToSetter() external view returns (address);
97 
98     function getPair(address tokenA, address tokenB) external view returns (address pair);
99     function allPairs(uint) external view returns (address pair);
100     function allPairsLength() external view returns (uint);
101 
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 
104     function setFeeTo(address) external;
105     function setFeeToSetter(address) external;
106 }
107 
108 interface IUniswapV2Router02 {
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint256 amountIn,
111         uint256 amountOutMin,
112         address[] calldata path,
113         address to,
114         uint256 deadline
115     ) external;
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118     function addLiquidityETH(
119         address token,
120         uint256 amountTokenDesired,
121         uint256 amountTokenMin,
122         uint256 amountETHMin,
123         address to,
124         uint256 deadline
125     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
126 }
127 
128 contract NFTMusicStream is Context, IERC20, Ownable {
129     using SafeMath for uint256;
130 
131     string private constant _name = "NFTMUSIC.STREAM";
132     string private constant _symbol = "STREAMER";
133     uint8 private constant _decimals = 9;
134 
135     mapping(address => uint256) private _balances;
136     mapping(address => mapping(address => uint256)) private _allowances;
137     mapping(address => bool) private _isExcludedFromFee;
138 
139     address public immutable deadAddress = address(0);
140 
141     uint256 private constant _tTotal = 1000000000000 * 1e9; //
142     uint256 private _totalFee = 10;
143     uint256 private _storedTotalFee = _totalFee;
144 
145     // For payout calculations
146     uint256 public _payoutAdmin = 20;
147     uint256 public _payoutMarketing = 40;
148     uint256 public _payoutAppDev = 40;
149 
150     address payable private _adminAddress;
151     address payable private _marketingAddress;
152     address payable private _appDevAddress;
153     mapping(address => bool) private _isAdmin;
154 
155     IUniswapV2Router02 private uniswapV2Router;
156     address private uniswapV2Pair;
157     bool private tradingOpen = false;
158     bool private inSwap = false;
159     bool private swapEnabled = false;
160     bool private supportLiquidity = false;
161 
162     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
163     event SwapTokensForETH(uint256 amountIn, address[] path);
164     
165     modifier lockTheSwap {
166         inSwap = true;
167         _;
168         inSwap = false;
169     }
170 
171     constructor(address payable adminFunds, address payable marketingFunds, address payable appDevFunds) {
172 
173         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
174         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
175         uniswapV2Router = _uniswapV2Router;
176 
177         _adminAddress = adminFunds;
178         _marketingAddress = marketingFunds;
179         _appDevAddress = appDevFunds;
180         
181         _balances[_msgSender()] = _tTotal;
182         _isExcludedFromFee[owner()] = true;
183         _isAdmin[owner()] = true;
184         _isExcludedFromFee[address(this)] = true;
185         _isAdmin[address(this)] = true;
186         _isExcludedFromFee[_adminAddress] = true;
187         _isAdmin[_adminAddress] = true;
188         _isExcludedFromFee[_marketingAddress] = true;
189         _isAdmin[_marketingAddress] = true;
190         _isExcludedFromFee[_appDevAddress] = true;
191         _isAdmin[_appDevAddress] = true;
192         emit Transfer(address(0), _msgSender(), _tTotal);
193     }
194 
195     function name() public pure returns (string memory) {
196         return _name;
197     }
198 
199     function symbol() public pure returns (string memory) {
200         return _symbol;
201     }
202 
203     function decimals() public pure returns (uint8) {
204         return _decimals;
205     }
206 
207     function totalSupply() public pure override returns (uint256) {
208         return _tTotal;
209     }
210 
211     function balanceOf(address account) public view override returns (uint256) {
212         return _balances[account];
213     }
214 
215     function transfer(address recipient, uint256 amount) public override returns (bool) {
216         _transfer(_msgSender(), recipient, amount);
217         return true;
218     }
219 
220     function allowance(address owner, address spender) public view override returns (uint256) {
221         return _allowances[owner][spender];
222     }
223 
224     function approve(address spender, uint256 amount) public override returns (bool) {
225         _approve(_msgSender(), spender, amount);
226         return true;
227     }
228 
229     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
230         _transfer(sender, recipient, amount);
231         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
232         return true;
233     }
234     
235     function removeAllFee() private {
236         if (_totalFee == 0) return;
237         _totalFee = 0;
238     }
239 
240     function restoreAllFee() private {
241         _totalFee = _storedTotalFee;
242     }
243 
244     function _approve(address owner, address spender, uint256 amount) private {
245         require(owner != address(0), "ERC20: approve from the zero address");
246         require(spender != address(0), "ERC20: approve to the zero address");
247         _allowances[owner][spender] = amount;
248         emit Approval(owner, spender, amount);
249     }
250 
251     function _transfer(address from, address to, uint256 amount) private {
252         require(from != address(0), "ERC20: transfer from the zero address");
253         require(to != address(0), "ERC20: transfer to the zero address");
254         require(amount > 0, "Transfer amount must be greater than zero");
255 
256         bool takeFee;
257 
258         if (!_isAdmin[from] && !_isAdmin[from]) {
259             require(tradingOpen);
260             takeFee = true;
261 
262             uint256 contractTokenBalance = balanceOf(address(this));
263             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
264 
265                 if (supportLiquidity) {
266                     uint256 liquidityPart = contractTokenBalance.div(2);
267                     swapTokensForEth(liquidityPart);
268                     uint256 newContractBalance = balanceOf(address(this));
269                     swapAndLiquify(newContractBalance);
270                 } else {
271                     swapTokensForEth(contractTokenBalance);
272                 }
273                 uint256 contractETHBalance = address(this).balance;
274                 if (contractETHBalance > 0) {
275                     sendETHToWallets(address(this).balance);
276                 }
277             }
278         }
279 
280         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
281             takeFee = false;
282         }
283 
284         _tokenTransfer(from, to, amount, takeFee);
285         restoreAllFee;
286     }
287 
288     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
289         address[] memory path = new address[](2);
290         path[0] = address(this);
291         path[1] = uniswapV2Router.WETH();
292         _approve(address(this), address(uniswapV2Router), tokenAmount);
293         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
294         emit SwapTokensForETH(tokenAmount, path);
295     }
296 
297       function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
298         uint256 half = contractTokenBalance.div(2);
299         uint256 otherHalf = contractTokenBalance.sub(half);
300         uint256 initialBalance = address(this).balance;
301         swapTokensForEth(half);
302         uint256 newBalance = address(this).balance.sub(initialBalance);
303         addLiquidity(otherHalf, newBalance);
304         emit SwapAndLiquify(half, newBalance, otherHalf);
305     }
306     
307 
308     function sendETHToWallets(uint256 totalETHbeforeSplit) private {
309         if (_payoutAdmin != 0) {
310             uint256 adminCut = totalETHbeforeSplit.mul(_payoutAdmin).div(100);
311             _adminAddress.transfer(adminCut);
312         }
313 
314         if (_payoutMarketing != 0) {
315             uint256 marketingCut = totalETHbeforeSplit.mul(_payoutMarketing).div(100);
316             _marketingAddress.transfer(marketingCut);
317         }
318 
319         if (_payoutAppDev != 0) {
320             uint256 appDevCut = totalETHbeforeSplit.mul(_payoutAppDev).div(100);
321             _appDevAddress.transfer(appDevCut);
322         }
323     }
324     
325     function openTrading() public onlyOwner {
326         tradingOpen = true;
327     }
328 
329     function presaleFinished() external onlyOwner() {
330         swapEnabled = true;
331         supportLiquidity = true;
332     }
333 
334     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
335         _approve(address(this), address(uniswapV2Router), tokenAmount);
336         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this), tokenAmount, 0, 0, address(this), block.timestamp);
337     }
338 
339     function liquiditySupport(bool trueFalse) public onlyOwner {
340         supportLiquidity = trueFalse;
341     }
342 
343     function manualTokenSwap() external {
344         require(_msgSender() == owner());
345         uint256 contractBalance = balanceOf(address(this));
346         swapTokensForEth(contractBalance);
347     }
348 
349     function recoverEthFromContract() external {
350         require(_msgSender() == owner());
351         uint256 contractETHBalance = address(this).balance;
352         sendETHToWallets(contractETHBalance);
353     }
354 
355     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
356         if (!takeFee) removeAllFee();
357         _transferStandard(sender, recipient, amount);
358         if (!takeFee) restoreAllFee();
359     }
360 
361     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
362         (uint256 tTransferAmount, uint256 tTeam) = _getValues(tAmount);
363         _balances[sender] = _balances[sender].sub(tAmount);
364         _balances[recipient] = _balances[recipient].add(tTransferAmount);
365         _takeTeam(tTeam);
366         emit Transfer(sender, recipient, tTransferAmount);
367     }
368 
369     function _takeTeam(uint256 tTeam) private {
370         _balances[address(this)] = _balances[address(this)].add(tTeam);
371     }
372 
373     receive() external payable {}
374 
375     function _getValues(uint256 tAmount) private view returns (uint256, uint256) {
376         (uint256 tTransferAmount, uint256 tTeam) = _getTValues(tAmount, _totalFee);
377         return (tTransferAmount, tTeam);
378     }
379 
380     function _getTValues(uint256 tAmount, uint256 teamFee) private pure returns (uint256, uint256) {
381         uint256 tTeam = tAmount.mul(teamFee).div(100);
382         uint256 tTransferAmount = tAmount.sub(tTeam);
383         return (tTransferAmount, tTeam);
384     }
385 
386     function manualBurn (uint256 amount) external onlyOwner() {
387         require(amount <= balanceOf(owner()), "Amount exceeds available tokens balance");
388         _tokenTransfer(msg.sender, deadAddress, amount, false);
389     }
390 
391     function setRouterAddress(address newRouter) public onlyOwner() {
392         IUniswapV2Router02 _newUniRouter = IUniswapV2Router02(newRouter);
393         uniswapV2Pair = IUniswapV2Factory(_newUniRouter.factory()).createPair(address(this), _newUniRouter.WETH());
394         uniswapV2Router = _newUniRouter;
395     }
396 
397     function setAddressAdmin(address payable newAdminAddress) external onlyOwner() {
398         _isExcludedFromFee[_adminAddress] = false;
399         _isAdmin[_adminAddress] = false;
400         _adminAddress = newAdminAddress;
401         _isExcludedFromFee[newAdminAddress] = true;
402         _isAdmin[newAdminAddress] = true;
403     }
404 
405     function setAddressMarketing(address payable newMarketingAddress) external onlyOwner() {
406         _isExcludedFromFee[_marketingAddress] = false;
407         _isAdmin[_marketingAddress] = false;
408         _marketingAddress = newMarketingAddress;
409         _isExcludedFromFee[newMarketingAddress] = true;
410         _isAdmin[newMarketingAddress] = true;
411     }
412 
413     function setAddressAppDev(address payable newAppDevAddress) external onlyOwner() {
414         _isExcludedFromFee[_appDevAddress] = false;
415         _isAdmin[_appDevAddress] = false;
416         _appDevAddress = newAppDevAddress;
417         _isExcludedFromFee[newAppDevAddress] = true;
418         _isAdmin[newAppDevAddress] = true;
419     }
420 
421     function setPayouts(uint256 newAdminPayout, uint256 newMarketingPayout, uint256 newAppDevPayout) external onlyOwner {
422         require(newAdminPayout + newMarketingPayout + newAppDevPayout == 100, "Values must equal 100");
423         _payoutAdmin = newAdminPayout;
424         _payoutMarketing = newMarketingPayout;
425         _payoutAppDev = newAppDevPayout;
426     }
427     
428     function setFee(uint newFee) external onlyOwner {
429         require(newFee <= 10, "Fee must be less than 10");
430         _totalFee = newFee;
431         _storedTotalFee = newFee;
432     }
433 
434     function setIsAdmin(address payable newIsAdminAddress) external onlyOwner () {
435       _isExcludedFromFee[newIsAdminAddress] = true;
436       _isAdmin[newIsAdminAddress] = true;
437     }
438 
439     function removeIsAdmin(address payable oldIsAdminAddress) external onlyOwner () {
440       _isExcludedFromFee[oldIsAdminAddress] = false;
441       _isAdmin[oldIsAdminAddress] = false;
442     }
443 }