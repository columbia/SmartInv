1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 https://t.me/zhduneth
6 https://twitter.com/zhduneth
7 https://zhdun.limo
8 
9 */
10 
11 pragma solidity 0.8.21;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor () {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92 }
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 }
117 
118 contract RealZhdun is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120 
121     mapping (address => uint256) private _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping(address => uint256) private _holderLastTransferTimestamp;
125     bool public transferDelayEnabled = true;
126     address payable private _taxWallet;
127 
128     // Taxes
129     uint256 private _buyTax = 15;
130     uint256 private _sellTax = 20;
131 
132     uint8 private constant _decimals = 18;
133     uint256 private constant _tTotal = 1000000000000 * 10**_decimals;
134     string private constant _name = unicode"RealZhdun";
135     string private constant _symbol = unicode"Ждун";
136     uint256 public _maxTxAmount = 2500000000 * 10**_decimals;
137     uint256 public _maxWalletSize = 2500000000 * 10**_decimals;
138     uint256 public _taxSwapThreshold= 2500000000 * 10**_decimals;
139 
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145 
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152 
153     constructor (address taxWallet) {
154         _taxWallet = payable(taxWallet);
155         _balances[_msgSender()] = _tTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_taxWallet] = true;
159 
160         emit Transfer(address(0), _msgSender(), _tTotal);
161     }
162 
163     function name() public pure returns (string memory) {
164         return _name;
165     }
166 
167     function symbol() public pure returns (string memory) {
168         return _symbol;
169     }
170 
171     function decimals() public pure returns (uint8) {
172         return _decimals;
173     }
174 
175     function totalSupply() public pure override returns (uint256) {
176         return _tTotal;
177     }
178 
179     function balanceOf(address account) public view override returns (uint256) {
180         return _balances[account];
181     }
182 
183     function transfer(address recipient, uint256 amount) public override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     function allowance(address owner, address spender) public view override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     function approve(address spender, uint256 amount) public override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202 
203     function _approve(address owner, address spender, uint256 amount) private {
204         require(owner != address(0), "ERC20: approve from the zero address");
205         require(spender != address(0), "ERC20: approve to the zero address");
206         _allowances[owner][spender] = amount;
207         emit Approval(owner, spender, amount);
208     }
209 
210     function _transfer(address from, address to, uint256 amount) private {
211         require(from != address(0), "ERC20: transfer from the zero address");
212         require(to != address(0), "ERC20: transfer to the zero address");
213         require(amount > 0, "Transfer amount must be greater than zero");
214 
215         uint256 taxAmount = 0;
216 
217         if (from != owner() && to != owner()) {
218             if (transferDelayEnabled) {
219                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
220                     require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
221                     _holderLastTransferTimestamp[tx.origin] = block.number;
222                 }
223             }
224 
225             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
226                 taxAmount = amount.mul(_buyTax).div(100);
227                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
228                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
229             }
230 
231             if (to == uniswapV2Pair && from != address(this)) {
232                 taxAmount = amount.mul(_sellTax).div(100);
233             }
234 
235             uint256 contractTokenBalance = balanceOf(address(this));
236             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold) {
237                 if(amount >= _taxSwapThreshold) {
238                     swapTokensForEth(_taxSwapThreshold);
239                 } else {
240                     swapTokensForEth(amount);
241                 }
242             }
243         }
244 
245         if(taxAmount > 0) {
246             _balances[address(this)] = _balances[address(this)].add(taxAmount);
247             emit Transfer(from, address(this), taxAmount);
248         }
249 
250         _balances[from] = _balances[from].sub(amount);
251         _balances[to] = _balances[to].add(amount.sub(taxAmount));
252         emit Transfer(from, to, amount.sub(taxAmount));
253     }
254 
255     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
256         address[] memory path = new address[](2);
257         path[0] = address(this);
258         path[1] = uniswapV2Router.WETH();
259         _approve(address(this), address(uniswapV2Router), tokenAmount);
260         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
261             tokenAmount,
262             0,
263             path,
264             address(_taxWallet),
265             block.timestamp
266         );
267     }
268 
269     function setBuyTax(uint256 tax) external onlyOwner {
270         require(tax <= 50, "Tax should be less than or equal to 50");
271         _buyTax = tax;
272     }
273 
274     function setSellTax(uint256 tax) external onlyOwner {
275         require(tax <= 50, "Tax should be less than or equal to 50");
276         _sellTax = tax;
277     }
278     
279     function removeLimits() external onlyOwner{
280         _maxTxAmount = _tTotal;
281         _maxWalletSize=_tTotal;
282         transferDelayEnabled=false;
283         emit MaxTxAmountUpdated(_tTotal);
284     }
285 
286     function openTrading() external onlyOwner() {
287         require(!tradingOpen,"Trading is already open");
288         uniswapV2Router = IUniswapV2Router02(
289             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
290             );
291         _approve(address(this), address(uniswapV2Router), _tTotal);
292         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
293         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
294         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
295         swapEnabled = true;
296         tradingOpen = true;
297     }
298 
299     receive() external payable {}
300 }