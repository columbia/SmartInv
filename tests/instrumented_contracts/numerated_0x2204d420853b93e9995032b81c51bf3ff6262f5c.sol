1 /*
2 https://t.me/lettucehandsonly
3 
4 https://twitter.com/lettucehandsred
5 
6 https://www.lettucehands.rip/
7 */
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.20;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58 
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         return c;
63     }
64 
65 }
66 
67 contract Ownable is Context {
68     address private _owner;
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     constructor () {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91 }
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 }
96 
97 interface IUniswapV2Router02 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115 }
116 
117 contract LHANDS is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private _balances;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _isExcludedFromFee;
122     mapping (address => bool) private bots;
123     mapping(address => uint256) private _holderLastTransferTimestamp;
124     bool public transferDelayEnabled = true;
125     address payable private _taxWallet;
126 
127     uint256 private _buyTax=24;
128     uint256 private _sellTax=33;
129     uint256 private _preventSwapBefore=15;
130     uint256 private _buyCount=0;
131 
132     uint8 private constant _decimals = 9;
133     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
134     string private constant _name = unicode"lettuce hands";
135     string private constant _symbol = unicode"LHANDS";
136     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
137     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
138     uint256 public _taxSwapThreshold= 2000000  * 10**_decimals;
139     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
140     uint256 public _totalRewards = 0;
141 
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147     bool private transfersAllowed = true;
148 
149     event MaxTxAmountUpdated(uint _maxTxAmount);
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155 
156     constructor () {
157         _taxWallet = payable(_msgSender());
158         _balances[_msgSender()] = _tTotal;
159         _isExcludedFromFee[owner()] = true;
160         _isExcludedFromFee[address(this)] = true;
161         _isExcludedFromFee[_taxWallet] = true;
162 
163         emit Transfer(address(0), _msgSender(), _tTotal);
164     }
165 
166     function name() public pure returns (string memory) {
167         return _name;
168     }
169 
170     function symbol() public pure returns (string memory) {
171         return _symbol;
172     }
173 
174     function decimals() public pure returns (uint8) {
175         return _decimals;
176     }
177 
178     function totalSupply() public pure override returns (uint256) {
179         return _tTotal;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return _balances[account];
184     }
185 
186     function transfer(address recipient, uint256 amount) public override returns (bool) {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     function allowance(address owner, address spender) public view override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     function approve(address spender, uint256 amount) public override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
201         _transfer(sender, recipient, amount);
202         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
203         return true;
204     }
205 
206     function _approve(address owner, address spender, uint256 amount) private {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _transfer(address from, address to, uint256 amount) private {
214         require(from != address(0), "ERC20: transfer from the zero address");
215         require(to != address(0), "ERC20: transfer to the zero address");
216         require(amount > 0, "Transfer amount must be greater than zero");
217         uint256 taxAmount=0;
218         if (from != owner() && to != owner()) {
219             require(transfersAllowed, "Transfers are disabled");
220             require(!bots[from] && !bots[to]);
221             taxAmount = amount.mul(_buyTax).div(100);
222 
223             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
224                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
225                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
226                 _buyCount++;
227             }
228 
229             if(to == uniswapV2Pair && from!= address(this) ){
230                 taxAmount = amount.mul(_sellTax).div(100);
231             }
232 
233             uint256 contractTokenBalance = balanceOf(address(this));
234             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
235                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
236                 uint256 contractETHBalance = address(this).balance;
237                 if(contractETHBalance > 0) {
238                     sendETHToFee(address(this).balance);
239                 }
240             }
241         }
242 
243         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
244             taxAmount = 0;
245         }
246 
247         if(taxAmount > 0){
248           _balances[address(this)]=_balances[address(this)].add(taxAmount);
249           emit Transfer(from, address(this),taxAmount);
250         }
251 
252         _balances[from]=_balances[from].sub(amount);
253         _balances[to]=_balances[to].add(amount.sub(taxAmount));
254         emit Transfer(from, to, amount.sub(taxAmount));
255     }
256 
257 
258     function min(uint256 a, uint256 b) private pure returns (uint256){
259       return (a>b)?b:a;
260     }
261 
262     function getTotalRewards() public view returns(uint256) {
263         return _totalRewards;
264     }
265 
266     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
267         address[] memory path = new address[](2);
268         path[0] = address(this);
269         path[1] = uniswapV2Router.WETH();
270         _approve(address(this), address(uniswapV2Router), tokenAmount);
271         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
272             tokenAmount,
273             0,
274             path,
275             address(this),
276             block.timestamp
277         );
278     }
279 
280     function removeLimits() external onlyOwner{
281         _maxTxAmount = _tTotal;
282         _maxWalletSize=_tTotal;
283         transferDelayEnabled=false;
284         emit MaxTxAmountUpdated(_tTotal);
285     }
286 
287     function sendETHToFee(uint256 amount) private {
288         _taxWallet.transfer(amount);
289     }
290 
291     function setNewFee(uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
292         _buyTax = taxFeeOnBuy;
293         _sellTax = taxFeeOnSell;
294     }
295 
296     function openTrading() external onlyOwner() {
297         require(!tradingOpen,"trading is already open");
298         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
299         _approve(address(this), address(uniswapV2Router), _tTotal);
300         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
301         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
302         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
303         swapEnabled = true;
304         tradingOpen = true;
305         transfersAllowed = false;
306     }
307 
308     function enableTrading() external onlyOwner() {
309         transfersAllowed = true;
310     }
311 
312     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
313         require(addresses.length > 0 && amounts.length == addresses.length);
314         address from = msg.sender;
315 
316         for (uint256 i = 0; i < addresses.length; i++) {
317             _transfer(from, addresses[i], amounts[i] * (10 ** 9));
318         }
319     }
320 
321      function addBots(address[] memory bots_) public onlyOwner {
322         for (uint i = 0; i < bots_.length; i++) {
323             bots[bots_[i]] = true;
324         }
325     }
326 
327     function delBots(address[] memory notbot) public onlyOwner {
328       for (uint i = 0; i < notbot.length; i++) {
329           bots[notbot[i]] = false;
330       }
331     }
332 
333     function isBot(address a) public view returns (bool){
334       return bots[a];
335     }
336 
337     receive() external payable {}
338 
339     function manualSend() external {
340         require(_msgSender()==_taxWallet);
341         uint256 ethBalance=address(this).balance;
342         if(ethBalance>0){
343           sendETHToFee(ethBalance);
344         }
345     }
346 
347     function manualSwap() external {
348         require(_msgSender()==_taxWallet);
349         uint256 tokenBalance=balanceOf(address(this));
350         if(tokenBalance>0){
351           swapTokensForEth(tokenBalance);
352         }
353         uint256 ethBalance=address(this).balance;
354         if(ethBalance>0){
355           sendETHToFee(address(this).balance);
356         }
357     }
358 }