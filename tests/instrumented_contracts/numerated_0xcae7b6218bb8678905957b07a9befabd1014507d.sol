1 // SPDX-License-Identifier: MIT
2 
3 /*
4 ⠀⠀⠀⠀⠀⠀⢀⣠⠤⠔⠒⠒⠒⠒⠒⠢⠤⢤⣀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⢀⠴⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠲⣄⠀⠀⠀
6 ⠀⠀⡰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⠀⠀
7 ⠀⡸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀
8 ⠀⡇⠀⠀⠀⢀⡶⠛⣿⣷⡄⠀⠀⠀⣰⣿⠛⢿⣷⡄⠀⠀⠀⢸⠀
9 ⠀⡇⠀⠀⠀⢸⣷⣶⣿⣿⡇⠀⠀⠀⢻⣿⣶⣿⣿⣿⠀⠀⠀⢸⠀
10 ⠀⡇⠀⠀⠀⠈⠛⠻⠿⠟⠁⠀⠀⠀⠈⠛⠻⠿⠛⠁⠀⠀⠀⢸⠀
11 ⠀⠹⣄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠏⠀
12 ⠀⠀⠈⠢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣚⡁⠀⠀
13 ⠀⠀⠀⠀⠈⠙⠒⢢⡤⠤⠤⠤⠤⠤⠖⠒⠒⠋⠉⠉⠀⠀⠉⠉⢦
14 ⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
15 ⠀⠀⠀⠀⠀⠀⠀⢸⡀⠀⠀⠀⠀⣤⠀⠀⠀⢀⣀⣀⣀⠀⠀⠀⢸
16 ⠀⠀⠀⠀⠀⠀⠀⠈⡇⠀⠀⠀⢠⣿⠀⠀⠀⢸⠀⠀⣿⠀⠀⠀⣸
17 ⠀⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⢸⠘⡆⠀⠀⢸⣀⡰⠋⣆⠀⣠⠇
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⠤⠤⠼⠀⠘⠤⠴⠃⠀⠀⠀⠈⠉⠁⠀
19 || https://yippee.wtf || http://x.com/yippeeth || https://t.me/yippeeETH ||
20 
21    YIPPEE Token is a cryptocurrency project inspired by the 'Yippee' meme from The Powerpuff Girls animated TV series. 
22 While the meme is a symbol of joy and excitement, the token also highlights awareness for Autism spectrum disorder (ASD), 
23 emphasizing its effects on communication and social interaction. With a total supply of 69,000,000 and a 1% marketing tax, YIPPEE Token merges pop culture with a cause. 
24 */
25 
26 pragma solidity 0.8.21;
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 }
33 
34 interface IERC20 {
35     function totalSupply() external view returns (uint256);
36     function balanceOf(address account) external view returns (uint256);
37     function transfer(address recipient, uint256 amount) external returns (bool);
38     function allowance(address owner, address spender) external view returns (uint256);
39     function approve(address spender, uint256 amount) external returns (bool);
40     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 library SafeMath {
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59         return c;
60     }
61 
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         if (a == 0) {
64             return 0;
65         }
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68         return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return div(a, b, "SafeMath: division by zero");
73     }
74 
75     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b > 0, errorMessage);
77         uint256 c = a / b;
78         return c;
79     }
80 
81 }
82 
83 contract Ownable is Context {
84     address private _owner;
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     constructor () {
88         address msgSender = _msgSender();
89         _owner = msgSender;
90         emit OwnershipTransferred(address(0), msgSender);
91     }
92 
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     modifier onlyOwner() {
98         require(_owner == _msgSender(), "Ownable: caller is not the owner");
99         _;
100     }
101 
102     function renounceOwnership() public virtual onlyOwner {
103         emit OwnershipTransferred(_owner, address(0));
104         _owner = address(0);
105     }
106 
107 }
108 
109 interface IUniswapV2Factory {
110     function createPair(address tokenA, address tokenB) external returns (address pair);
111 }
112 
113 interface IUniswapV2Router02 {
114     function swapExactTokensForETHSupportingFeeOnTransferTokens(
115         uint amountIn,
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external;
121     function factory() external pure returns (address);
122     function WETH() external pure returns (address);
123     function addLiquidityETH(
124         address token,
125         uint amountTokenDesired,
126         uint amountTokenMin,
127         uint amountETHMin,
128         address to,
129         uint deadline
130     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
131 }
132 
133 contract YIPPEE is Context, IERC20, Ownable {
134     using SafeMath for uint256;
135 
136     mapping (address => uint256) private _balances;
137     mapping (address => mapping (address => uint256)) private _allowances;
138     mapping (address => bool) private _isExcludedFromFee;
139     mapping(address => uint256) private _holderLastTransferTimestamp;
140     bool public transferDelayEnabled = true;
141     address payable private _taxWallet;
142 
143     // Taxes
144     uint256 private _buyTax = 20;
145     uint256 private _sellTax = 35;
146 
147     uint8 private constant _decimals = 18;
148     uint256 private constant _tTotal = 69000000 * 10**_decimals;
149     string private constant _name = unicode"Yippee";
150     string private constant _symbol = unicode"YIPPEE";
151     uint256 public _maxTxAmount = 690000 * 10**_decimals;
152     uint256 public _maxWalletSize = 690000 * 10**_decimals;
153     uint256 public _taxSwapThreshold= 379500  * 10**_decimals;
154 
155     IUniswapV2Router02 private uniswapV2Router;
156     address private uniswapV2Pair;
157     bool private tradingOpen;
158     bool private inSwap = false;
159     bool private swapEnabled = false;
160 
161     event MaxTxAmountUpdated(uint _maxTxAmount);
162     modifier lockTheSwap {
163         inSwap = true;
164         _;
165         inSwap = false;
166     }
167 
168     constructor (address taxWallet) {
169         _taxWallet = payable(taxWallet);
170         _balances[_msgSender()] = _tTotal;
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[_taxWallet] = true;
174 
175         emit Transfer(address(0), _msgSender(), _tTotal);
176     }
177 
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185 
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189 
190     function totalSupply() public pure override returns (uint256) {
191         return _tTotal;
192     }
193 
194     function balanceOf(address account) public view override returns (uint256) {
195         return _balances[account];
196     }
197 
198     function transfer(address recipient, uint256 amount) public override returns (bool) {
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     function allowance(address owner, address spender) public view override returns (uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount) public override returns (bool) {
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
215         return true;
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229 
230         uint256 taxAmount = 0;
231 
232         if (from != owner() && to != owner()) {
233             if (transferDelayEnabled) {
234                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
235                     require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
236                     _holderLastTransferTimestamp[tx.origin] = block.number;
237                 }
238             }
239 
240             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
241                 taxAmount = amount.mul(_buyTax).div(100);
242                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
243                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
244             }
245 
246             if (to == uniswapV2Pair && from != address(this)) {
247                 taxAmount = amount.mul(_sellTax).div(100);
248             }
249 
250             uint256 contractTokenBalance = balanceOf(address(this));
251             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold) {
252                 if(amount >= _taxSwapThreshold) {
253                     swapTokensForEth(_taxSwapThreshold);
254                 } else {
255                     swapTokensForEth(amount);
256                 }
257             }
258         }
259 
260         if(taxAmount > 0) {
261             _balances[address(this)] = _balances[address(this)].add(taxAmount);
262             emit Transfer(from, address(this), taxAmount);
263         }
264 
265         _balances[from] = _balances[from].sub(amount);
266         _balances[to] = _balances[to].add(amount.sub(taxAmount));
267         emit Transfer(from, to, amount.sub(taxAmount));
268     }
269 
270     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
271         address[] memory path = new address[](2);
272         path[0] = address(this);
273         path[1] = uniswapV2Router.WETH();
274         _approve(address(this), address(uniswapV2Router), tokenAmount);
275         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
276             tokenAmount,
277             0,
278             path,
279             address(_taxWallet),
280             block.timestamp
281         );
282     }
283 
284     function setBuyTax(uint256 tax) external onlyOwner {
285         require(tax <= 30, "Tax should be less than or equal to 30");
286         _buyTax = tax;
287     }
288 
289     function setSellTax(uint256 tax) external onlyOwner {
290         require(tax <= 30, "Tax should be less than or equal to 30");
291         _sellTax = tax;
292     }
293     
294     function removeLimits() external onlyOwner{
295         _maxTxAmount = _tTotal;
296         _maxWalletSize=_tTotal;
297         transferDelayEnabled=false;
298         emit MaxTxAmountUpdated(_tTotal);
299     }
300 
301     function openTrading() external onlyOwner() {
302         require(!tradingOpen,"Trading is already open");
303         uniswapV2Router = IUniswapV2Router02(
304             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
305             );
306         _approve(address(this), address(uniswapV2Router), _tTotal);
307         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
308         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
309         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
310         swapEnabled = true;
311         tradingOpen = true;
312     }
313 
314     receive() external payable {}
315 }