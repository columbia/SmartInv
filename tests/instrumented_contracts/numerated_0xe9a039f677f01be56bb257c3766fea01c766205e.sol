1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5     Telegram : https://t.me/VTCB10I
6     Website : https://vtcb10i.com/
7     Twitter:  https://twitter.com/VTCB10I
8 
9 */
10 
11 
12 pragma solidity 0.8.20;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract VitalikTrumpCrashBandicoot10Inu is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     address payable private _taxWallet;
125     uint256 firstBlock;
126 
127     uint256 private _initialBuyTax=23;
128     uint256 private _initialSellTax=23;
129     uint256 private _finalBuyTax=1;
130     uint256 private _finalSellTax=1;
131     uint256 private _reduceBuyTaxAt=23;
132     uint256 private _reduceSellTaxAt=25;
133     uint256 private _buyCount=0;
134 
135     uint8 private constant _decimals = 9;
136     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
137     string private constant _name = unicode"VitalikTrumpCrashBandicoot10Inu";
138     string private constant _symbol = unicode"ETHEREUM";
139     uint256 public _maxTxAmount =   8413800000000 * 10**_decimals;
140     uint256 public _maxWalletSize = 8413800000000 * 10**_decimals;
141     uint256 public _taxSwapThreshold= 4206900000000 * 10**_decimals;
142     uint256 public _maxTaxSwap= 4206900000000 * 10**_decimals;
143 
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private inSwap = false;
148     bool private swapEnabled = false;
149 
150     event MaxTxAmountUpdated(uint _maxTxAmount);
151     modifier lockTheSwap {
152         inSwap = true;
153         _;
154         inSwap = false;
155     }
156 
157     constructor () {
158 
159         _taxWallet = payable(_msgSender());
160         _balances[_msgSender()] = _tTotal;
161         _isExcludedFromFee[owner()] = true;
162         _isExcludedFromFee[address(this)] = true;
163         _isExcludedFromFee[_taxWallet] = true;
164         
165         emit Transfer(address(0), _msgSender(), _tTotal);
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
219         uint256 taxAmount=0;
220         if (from != owner() && to != owner()) {
221             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
222 
223             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
224                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
225                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
226 
227                 if (firstBlock + 3  > block.number) {
228                     require(!isContract(to));
229                 }
230                 _buyCount++;
231             }
232 
233             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
234                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
235             }
236 
237             if(to == uniswapV2Pair && from!= address(this) ){
238                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
239             }
240 
241             uint256 contractTokenBalance = balanceOf(address(this));
242             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
243                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
244                 uint256 contractETHBalance = address(this).balance;
245                 if(contractETHBalance > 0) {
246                     sendETHToFee(address(this).balance);
247                 }
248             }
249         }
250 
251         if(taxAmount>0){
252           _balances[address(this)]=_balances[address(this)].add(taxAmount);
253           emit Transfer(from, address(this),taxAmount);
254         }
255         _balances[from]=_balances[from].sub(amount);
256         _balances[to]=_balances[to].add(amount.sub(taxAmount));
257         emit Transfer(from, to, amount.sub(taxAmount));
258     }
259 
260 
261     function min(uint256 a, uint256 b) private pure returns (uint256){
262       return (a>b)?b:a;
263     }
264 
265     function isContract(address account) private view returns (bool) {
266         uint256 size;
267         assembly {
268             size := extcodesize(account)
269         }
270         return size > 0;
271     }
272 
273     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
274         address[] memory path = new address[](2);
275         path[0] = address(this);
276         path[1] = uniswapV2Router.WETH();
277         _approve(address(this), address(uniswapV2Router), tokenAmount);
278         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
279             tokenAmount,
280             0,
281             path,
282             address(this),
283             block.timestamp
284         );
285     }
286 
287     function removeLimits() external onlyOwner{
288         _maxTxAmount = _tTotal;
289         _maxWalletSize=_tTotal;
290         emit MaxTxAmountUpdated(_tTotal);
291     }
292 
293     function sendETHToFee(uint256 amount) private {
294         _taxWallet.transfer(amount);
295     }
296 
297     function openTrading() external onlyOwner() {
298         require(!tradingOpen,"trading is already open");
299         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
300         _approve(address(this), address(uniswapV2Router), _tTotal);
301         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
302         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
303         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
304         swapEnabled = true;
305         tradingOpen = true;
306         firstBlock = block.number;
307     }
308 
309     receive() external payable {}
310 }