1 // SPDX-License-Identifier: MIT
2 
3 /*
4 telegram: https://t.me/ShrempToken
5 x: https://x.com/ShrempToken
6 website: http://shremp.vip/
7 */
8 
9 pragma solidity 0.8.20;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64 }
65 
66 contract Ownable is Context {
67     address private _owner;
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     constructor () {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90 }
91 
92 interface IUniswapV2Factory {
93     function createPair(address tokenA, address tokenB) external returns (address pair);
94 }
95 
96 interface IUniswapV2Router02 {
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104     function factory() external pure returns (address);
105     function WETH() external pure returns (address);
106     function addLiquidityETH(
107         address token,
108         uint amountTokenDesired,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
114 }
115 
116 contract Shremp is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping(address => uint256) private _holderLastTransferTimestamp;
122     bool public transferDelayEnabled = true;
123     address payable private _marketingWallet;
124 
125     uint256 private _initialBuyTax = 18;
126     uint256 private _initialSellTax = 25;
127     uint256 private _finalBuyTax = 2;
128     uint256 private _finalSellTax = 2;
129     uint256 private _reduceBuyTaxAt = 20;
130     uint256 private _reduceSellTaxAt = 25;
131     uint256 private _preventSwapBefore = 25;
132     uint256 private _buyCount = 0;
133 
134     uint8 private constant _decimals = 9;
135     uint256 private constant _tTotal = 100000000 * 10**_decimals;
136     string private constant _name = unicode"Shremp";
137     string private constant _symbol = unicode"SHREMP";
138     uint256 public _maxTxAmount = 2000000 * 10**_decimals;
139     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
140     uint256 public _taxSwapThreshold= 100000 * 10**_decimals;
141     uint256 public _maxTaxSwap= 1000000 * 10**_decimals;
142 
143     IUniswapV2Router02 private uniswapV2Router;
144     address private uniswapV2Pair;
145     bool private tradingOpen;
146     bool private inSwap = false;
147     bool private swapEnabled = false;
148 
149     event MaxTxAmountUpdated(uint _maxTxAmount);
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155 
156     constructor () {
157         _marketingWallet = payable(0x7330F6C184FCCd035d1D32C0FD8aDaA5683086E0);
158         _balances[_msgSender()] = _tTotal.mul(98).div(100);
159         _balances[_marketingWallet] = _tTotal.mul(2).div(100);
160         _isExcludedFromFee[owner()] = true;
161         _isExcludedFromFee[address(this)] = true;
162         _isExcludedFromFee[_marketingWallet] = true;
163 
164         emit Transfer(address(0), _msgSender(), _tTotal.mul(98).div(100));
165         emit Transfer(address(0), _marketingWallet, _tTotal.mul(2).div(100));
166     }
167 
168     function name() public pure returns (string memory) {
169         return _name;
170     }
171 
172     function symbol() public pure returns (string memory) {
173         return _symbol;
174     }
175 
176     function decimals() public pure returns (uint8) {
177         return _decimals;
178     }
179 
180     function totalSupply() public pure override returns (uint256) {
181         return _tTotal;
182     }
183 
184     function balanceOf(address account) public view override returns (uint256) {
185         return _balances[account];
186     }
187 
188     function transfer(address recipient, uint256 amount) public override returns (bool) {
189         _transfer(_msgSender(), recipient, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender) public view override returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
205         return true;
206     }
207 
208     function _approve(address owner, address spender, uint256 amount) private {
209         require(owner != address(0), "ERC20: approve from the zero address");
210         require(spender != address(0), "ERC20: approve to the zero address");
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214 
215     function _transfer(address from, address to, uint256 amount) private {
216         require(from != address(0), "ERC20: transfer from the zero address");
217         require(to != address(0), "ERC20: transfer to the zero address");
218         require(amount > 0, "Transfer amount must be greater than zero");
219         uint256 taxAmount = 0;
220         if (from != owner() && to != owner()) {
221             taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? _finalBuyTax  :_initialBuyTax).div(100);
222 
223             if (transferDelayEnabled) {
224                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
225                       require(
226                           _holderLastTransferTimestamp[tx.origin] < block.number,
227                           "_transfer:: Transfer Delay enabled. Only one purchase per block allowed."
228                       );
229                       _holderLastTransferTimestamp[tx.origin] = block.number;
230                   }
231               }
232 
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
234                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
235                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
236                 _buyCount++;
237             }
238 
239             if (to == uniswapV2Pair && from != address(this)) {
240                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt) ? _finalSellTax : _initialSellTax).div(100);
241             }
242 
243             uint256 contractTokenBalance = balanceOf(address(this));
244             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold && _buyCount > _preventSwapBefore) {
245                 swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
246                 uint256 contractETHBalance = address(this).balance;
247                 if(contractETHBalance > 0) {
248                     sendETHToFee(address(this).balance);
249                 }
250             }
251         }
252 
253         if (taxAmount > 0) {
254           _balances[address(this)] = _balances[address(this)].add(taxAmount);
255           emit Transfer(from, address(this), taxAmount);
256         }
257 
258         _balances[from] = _balances[from].sub(amount);
259         _balances[to] = _balances[to].add(amount.sub(taxAmount));
260         emit Transfer(from, to, amount.sub(taxAmount));
261     }
262 
263 
264     function min(uint256 a, uint256 b) private pure returns (uint256) {
265       return (a > b) ? b : a;
266     }
267 
268     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = uniswapV2Router.WETH();
272         _approve(address(this), address(uniswapV2Router), tokenAmount);
273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp
279         );
280     }
281 
282     function removeLimits() external onlyOwner {
283         _maxTxAmount = _tTotal;
284         _maxWalletSize = _tTotal;
285         transferDelayEnabled = false;
286         emit MaxTxAmountUpdated(_tTotal);
287     }
288 
289     function sendETHToFee(uint256 amount) private {
290         _marketingWallet.transfer(amount);
291     }
292 
293     function openTrading() external onlyOwner() {
294         require(!tradingOpen, "Trading is already open");
295         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
296         _approve(address(this), address(uniswapV2Router), _tTotal);
297         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
298         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp);
299         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
300         swapEnabled = true;
301         tradingOpen = true;
302     }
303 
304     receive() external payable {}
305 }