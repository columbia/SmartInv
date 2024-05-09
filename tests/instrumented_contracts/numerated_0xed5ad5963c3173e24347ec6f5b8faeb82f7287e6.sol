1 /**
2 
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣿⠽⠭⣥⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡴⠞⠉⠁⠀⠀⠀⠀⠉⠉⠛⠶⣤⣀⠀⠀⢀⣤⠴⠞⠛⠉⠉⠉⠛⠶⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠳⣏⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣆⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠏⠀⠀⠀⠀⠀⠀⢀⣠⠤⠤⠤⠤⢤⣄⡀⠀⠀⠹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡄⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⢀⡾⠁⠀⠀⠀⠀⠀⠐⠈⠁⠀⠀⠀⠀⠀⠀⠀⠉⠛⠶⢤⣽⡦⠐⠒⠒⠂⠀⠀⠀⠀⠐⠒⠀⢿⣦⣀⡀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⢀⡞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡤⠤⠤⠤⠤⠠⠌⢻⣆⡀⠀⠀⠀⣀⣀⣀⡀⠤⠤⠄⠠⢉⣙⡿⣆⡀⠀
9 ⠀⠀⠀⠀⣀⣴⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⢶⣛⣩⣶⣶⡾⢯⠿⠷⣖⣦⣤⣍⣿⣴⠖⣋⠭⣷⣶⣶⡶⠒⠒⣶⣒⣠⣀⣙⣿⣆
10 ⠀⠀⢀⠞⠋⠀⡇⠀⠀⠀⠀⠀⠀⢀⣠⡶⣻⡯⣲⡿⠟⢋⣵⣛⣾⣿⣷⡄⠀⠈⠉⠙⠛⢻⣯⠤⠚⠋⢉⣴⣻⣿⣿⣷⣼⠁⠉⠛⠺⣿
11 ⠀⣠⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣟⣫⣿⠟⠉⠀⠀⣾⣿⣻⣿⣤⣿⣿⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⣿⣿⣻⣿⣼⣿⣿⠇⠀⠀⠀⢙
12 ⢠⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⡶⣄⠀⠀⢻⣿⣿⣿⣿⣿⡏⠀⠀⠀⣀⣤⣾⣁⠀⠀⠀⠸⢿⣿⣿⣿⡿⠋⠀⣀⣠⣶⣿
13 ⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠺⢿⣶⣶⣮⣭⣭⣭⣭⡴⢶⣶⣾⠿⠟⠋⠉⠉⠙⠒⠒⠊⠉⠈⠉⠚⠉⠉⢉⣷⡾⠯
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⢈⣽⠟⠁⠀⠀⠀⠀⣄⡀⠀⠀⠀⠀⠀⠀⢀⣴⡾⠟⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⡴⠞⠋⠁⠀⠀⠀⠀⠀⠀⠈⠙⢷⡀⠉⠉⠉⠀⠙⢿⣵⡄⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⡀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣧⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⠟⠋⠉⠀⠀⠉⠛⠛⠛⠛⠷⠶⠶⠶⠶⠤⢤⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡤⢿⣆⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡶⠋⠀⠀⠀⠸⠿⠛⠛⠛⠓⠒⠲⠶⢤⣤⣄⣀⠀⠀⠀⠈⠙⠛⠛⠛⠛⠒⠶⠶⠶⣶⠖⠛⠛⠁⢠⣸⡟⠀
20 ⠀⠀⠀⠀⠀⠀⢰⣆⠀⢸⣧⣤⣤⣤⣤⣤⣤⣤⣤⣤⣀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠓⠒⠲⠦⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣾⠋⠀⠀
21 ⡀⠀⠀⠀⠀⠀⠀⠙⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠛⠲⠶⣶⣤⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡾⠃⠀⠀⠀
22 ⣿⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠛⠛⣳⣶⡶⠟⠉⠀⠀⠀⠀⠀
23 ⠛⢷⣿⣷⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠈⠙⠻⢷⣬⣗⣒⣂⡀⠠⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣤⡴⠾⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠿⠶⠶⠶⠶⣤⣤⣭⣭⣍⣉⣉⣀⣀⣀⣀⣼⣯⡽⠷⠿⠛⠙⠿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
27 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠈⠻⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
28 
29 The one and only LP burnt, 0% tax Baby Pepe on ETH!
30 
31 Telegram: https://t.me/BabyPepeEntry
32 Twitter: https://twitter.com/BabyPepeToken
33 
34 **/
35 
36 pragma solidity 0.8.7;
37 // SPDX-License-Identifier: UNLICENSED
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 }
43 
44 interface IERC20 {
45     function totalSupply() external view returns (uint256);
46     function balanceOf(address account) external view returns (uint256);
47     function transfer(address recipient, uint256 amount) external returns (bool);
48     function allowance(address owner, address spender) external view returns (uint256);
49     function approve(address spender, uint256 amount) external returns (bool);
50     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 library SafeMath {
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59         return c;
60     }
61 
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b <= a, errorMessage);
68         uint256 c = a - b;
69         return c;
70     }
71 
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         if (a == 0) {
74             return 0;
75         }
76         uint256 c = a * b;
77         require(c / a == b, "SafeMath: multiplication overflow");
78         return c;
79     }
80 
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         return div(a, b, "SafeMath: division by zero");
83     }
84 
85     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b > 0, errorMessage);
87         uint256 c = a / b;
88         return c;
89     }
90 
91 }
92 
93 contract Ownable is Context {
94     address private _owner;
95     address private _previousOwner;
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     constructor () {
99         address msgSender = _msgSender();
100         _owner = msgSender;
101         emit OwnershipTransferred(address(0), msgSender);
102     }
103 
104     function owner() public view returns (address) {
105         return _owner;
106     }
107 
108     modifier onlyOwner() {
109         require(_owner == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     function renounceOwnership() public virtual onlyOwner {
114         emit OwnershipTransferred(_owner, address(0));
115         _owner = address(0);
116     }
117 
118 }
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB) external returns (address pair);
122 }
123 
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint amountIn,
127         uint amountOutMin,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external;
132     function factory() external pure returns (address);
133     function WETH() external pure returns (address);
134     function addLiquidityETH(
135         address token,
136         uint amountTokenDesired,
137         uint amountTokenMin,
138         uint amountETHMin,
139         address to,
140         uint deadline
141     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
142 }
143 
144 contract BabyPepe is Context, IERC20, Ownable {
145     using SafeMath for uint256;
146     mapping (address => uint256) private _rOwned;
147     mapping (address => uint256) private _tOwned;
148     mapping (address => mapping (address => uint256)) private _allowances;
149     mapping (address => bool) private _isExcludedFromFee;
150     mapping (address => bool) public bots;
151     mapping (address => uint) private cooldown;
152     uint256 private constant MAX = ~uint256(0);
153     uint256 private constant _tTotal = 1_000_000 * 10**9;
154     uint256 private _rTotal = (MAX - (MAX % _tTotal));
155     uint256 private _tFeeTotal;
156 
157     uint256 public lBlock = 0;
158     uint256 private dBlocks = 0;
159 
160     uint256 private _feeAddr1;
161     uint256 private _feeAddr2;
162     uint256 private _initialTax;
163     uint256 private _finalTax;
164     uint256 private _reduceTaxCountdown;
165     address payable private _feeAddrWallet;
166 
167     string private constant _name = "Baby Pepe";
168     string private constant _symbol = unicode"BPEPE";
169     uint8 private constant _decimals = 9;
170 
171     IUniswapV2Router02 private uniswapV2Router;
172     address private uniswapV2Pair;
173     bool private tradingOpen;
174     bool private inSwap = false;
175     bool private swapEnabled = false;
176     bool private cooldownEnabled = false;
177     uint256 private _maxTxAmount = 1_000_000 * 10**9;
178     uint256 private _maxWalletSize = 20_000 * 10**9;
179     event MaxTxAmountUpdated(uint _maxTxAmount);
180     modifier lockTheSwap {
181         inSwap = true;
182         _;
183         inSwap = false;
184     }
185 
186     constructor () {
187         _feeAddrWallet = payable(_msgSender());
188         _rOwned[_msgSender()] = _rTotal;
189         _isExcludedFromFee[owner()] = true;
190         _isExcludedFromFee[address(this)] = true;
191         _isExcludedFromFee[_feeAddrWallet] = true;
192         _initialTax=15;
193         _finalTax=15;
194         _reduceTaxCountdown=10;
195 
196         emit Transfer(address(0), _msgSender(), _tTotal);
197     }
198 
199     function name() public pure returns (string memory) {
200         return _name;
201     }
202 
203     function symbol() public pure returns (string memory) {
204         return _symbol;
205     }
206 
207     function decimals() public pure returns (uint8) {
208         return _decimals;
209     }
210 
211     function totalSupply() public pure override returns (uint256) {
212         return _tTotal;
213     }
214 
215     function balanceOf(address account) public view override returns (uint256) {
216         return tokenFromReflection(_rOwned[account]);
217     }
218 
219     function transfer(address recipient, uint256 amount) public override returns (bool) {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     function allowance(address owner, address spender) public view override returns (uint256) {
225         return _allowances[owner][spender];
226     }
227 
228     function approve(address spender, uint256 amount) public override returns (bool) {
229         _approve(_msgSender(), spender, amount);
230         return true;
231     }
232 
233     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
234         _transfer(sender, recipient, amount);
235         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
236         return true;
237     }
238 
239     function setCooldownEnabled(bool onoff) external onlyOwner() {
240         cooldownEnabled = onoff;
241     }
242 
243     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
244         require(rAmount <= _rTotal, "Amount must be less than total reflections");
245         uint256 currentRate =  _getRate();
246         return rAmount.div(currentRate);
247     }
248 
249     function _approve(address owner, address spender, uint256 amount) private {
250         require(owner != address(0), "ERC20: approve from the zero address");
251         require(spender != address(0), "ERC20: approve to the zero address");
252         _allowances[owner][spender] = amount;
253         emit Approval(owner, spender, amount);
254     }
255 
256     function _transfer(address from, address to, uint256 amount) private {
257         require(from != address(0), "ERC20: transfer from the zero address");
258         require(to != address(0), "ERC20: transfer to the zero address");
259         require(amount > 0, "Transfer amount must be greater than zero");
260 
261 
262         if (from != owner() && to != owner()) {
263             require(!bots[from] && !bots[to], "Blacklisted.");
264             _feeAddr1 = 0;
265             _feeAddr2 = (_reduceTaxCountdown==0)?_finalTax:_initialTax;
266             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
267                 // Cooldown
268                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
269                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
270                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
271 
272                 if (block.number <= (lBlock + dBlocks)) {
273                     bots[to] = true;
274                 }
275             }
276 
277             uint256 contractTokenBalance = balanceOf(address(this));
278             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
279                 swapTokensForEth(contractTokenBalance);
280                 uint256 contractETHBalance = address(this).balance;
281                 if(contractETHBalance > 0) {
282                     sendETHToFee(address(this).balance);
283                 }
284             }
285         }else{
286           _feeAddr1 = 0;
287           _feeAddr2 = 0;
288         }
289 
290         _tokenTransfer(from,to,amount);
291     }
292 
293     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
294         address[] memory path = new address[](2);
295         path[0] = address(this);
296         path[1] = uniswapV2Router.WETH();
297         _approve(address(this), address(uniswapV2Router), tokenAmount);
298         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
299             tokenAmount,
300             0,
301             path,
302             address(this),
303             block.timestamp
304         );
305     }
306 
307     function removeLimits() external onlyOwner{
308         _maxTxAmount = _tTotal;
309         _maxWalletSize = _tTotal;
310     }
311 
312         function setLowerTax(uint256 newTax) external onlyOwner{
313         require(newTax < _finalTax, "Must be lower then current final tax");
314         _finalTax = (newTax);
315     }
316 
317     function delBot(address notbot) public onlyOwner {
318         bots[notbot] = false;
319     }
320 
321     function sendETHToFee(uint256 amount) private {
322         _feeAddrWallet.transfer(amount);
323     }
324 
325     function openTrading() external onlyOwner() {
326         require(!tradingOpen,"trading is already open");
327         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
328         uniswapV2Router = _uniswapV2Router;
329         _approve(address(this), address(uniswapV2Router), _tTotal);
330         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
331         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
332         swapEnabled = true;
333         cooldownEnabled = true;
334         lBlock = block.number;
335         tradingOpen = true;
336         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
337     }
338 
339     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
340         _transferStandard(sender, recipient, amount);
341     }
342 
343     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
344         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
345         _rOwned[sender] = _rOwned[sender].sub(rAmount);
346         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
347         _takeTeam(tTeam);
348         _reflectFee(rFee, tFee);
349         emit Transfer(sender, recipient, tTransferAmount);
350     }
351 
352     function _takeTeam(uint256 tTeam) private {
353         uint256 currentRate =  _getRate();
354         uint256 rTeam = tTeam.mul(currentRate);
355         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
356     }
357 
358     function _reflectFee(uint256 rFee, uint256 tFee) private {
359         _rTotal = _rTotal.sub(rFee);
360         _tFeeTotal = _tFeeTotal.add(tFee);
361     }
362 
363     receive() external payable {}
364 
365     function manualswap() external {
366         require(_msgSender() == _feeAddrWallet);
367         uint256 contractBalance = balanceOf(address(this));
368         swapTokensForEth(contractBalance);
369     }
370 
371     function manualsend() external {
372         require(_msgSender() == _feeAddrWallet);
373         uint256 contractETHBalance = address(this).balance;
374         sendETHToFee(contractETHBalance);
375     }
376 
377 
378     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
379         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
380         uint256 currentRate =  _getRate();
381         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
382         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
383     }
384 
385     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
386         uint256 tFee = tAmount.mul(taxFee).div(100);
387         uint256 tTeam = tAmount.mul(TeamFee).div(100);
388         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
389         return (tTransferAmount, tFee, tTeam);
390     }
391 
392     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
393         uint256 rAmount = tAmount.mul(currentRate);
394         uint256 rFee = tFee.mul(currentRate);
395         uint256 rTeam = tTeam.mul(currentRate);
396         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
397         return (rAmount, rTransferAmount, rFee);
398     }
399 
400 	function _getRate() private view returns(uint256) {
401         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
402         return rSupply.div(tSupply);
403     }
404 
405     function _getCurrentSupply() private view returns(uint256, uint256) {
406         uint256 rSupply = _rTotal;
407         uint256 tSupply = _tTotal;
408         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
409         return (rSupply, tSupply);
410     }
411 }