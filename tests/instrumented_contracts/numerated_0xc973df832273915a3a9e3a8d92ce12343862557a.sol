1 /*
2 https://www.countdracula.wtf/
3 
4 https://t.me/draculacount666
5 
6 https://twitter.com/draculacount666
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
116 contract DRAC is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     bool public transferDelayEnabled = true;
122 
123     address payable private _devWallet;
124 
125     uint256 private _buyTax = 0;
126     uint256 private _sellTax = 0;
127 
128     uint8 private constant _decimals = 9;
129     uint256 private constant _tTotal = 666666666666 * 10**_decimals;
130     string private constant _name = unicode"Count Dracula";
131     string private constant _symbol = unicode"DRAC";
132     uint256 public _maxTxAmount = 13333333333 * 10**_decimals;
133     uint256 public _maxWalletSize = 13333333333 * 10**_decimals;
134     uint256 public _taxSwapThreshold= 666666666   * 10**_decimals;
135     uint256 public _maxTaxSwap= 6666666666 * 10**_decimals;
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142     bool private enableTransfers = true;
143 
144     event MaxTxAmountUpdated(uint _maxTxAmount);
145     modifier lockTheSwap {
146         inSwap = true;
147         _;
148         inSwap = false;
149     }
150 
151     constructor () {
152         _devWallet = payable(_msgSender());
153         _balances[_msgSender()] = _tTotal;
154         _isExcludedFromFee[owner()] = true;
155         _isExcludedFromFee[address(this)] = true;
156         _isExcludedFromFee[_devWallet] = true;
157 
158         emit Transfer(address(0), _msgSender(), _tTotal);
159     }
160 
161     function name() public pure returns (string memory) {
162         return _name;
163     }
164 
165     function symbol() public pure returns (string memory) {
166         return _symbol;
167     }
168 
169     function decimals() public pure returns (uint8) {
170         return _decimals;
171     }
172 
173     function totalSupply() public pure override returns (uint256) {
174         return _tTotal;
175     }
176 
177     function balanceOf(address account) public view override returns (uint256) {
178         return _balances[account];
179     }
180 
181     function transfer(address recipient, uint256 amount) public override returns (bool) {
182         _transfer(_msgSender(), recipient, amount);
183         return true;
184     }
185 
186     function allowance(address owner, address spender) public view override returns (uint256) {
187         return _allowances[owner][spender];
188     }
189 
190     function approve(address spender, uint256 amount) public override returns (bool) {
191         _approve(_msgSender(), spender, amount);
192         return true;
193     }
194 
195     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
196         _transfer(sender, recipient, amount);
197         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
198         return true;
199     }
200 
201     function _approve(address owner, address spender, uint256 amount) private {
202         require(owner != address(0), "ERC20: approve from the zero address");
203         require(spender != address(0), "ERC20: approve to the zero address");
204         _allowances[owner][spender] = amount;
205         emit Approval(owner, spender, amount);
206     }
207 
208     function _transfer(address from, address to, uint256 amount) private {
209         require(from != address(0), "ERC20: transfer from the zero address");
210         require(to != address(0), "ERC20: transfer to the zero address");
211         require(amount > 0, "Transfer amount must be greater than zero");
212         uint256 taxAmount=0;
213         if (from != owner() && to != owner() && from != _devWallet && to != _devWallet) {
214 
215             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
216                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
217                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
218             }
219 
220             uint256 contractTokenBalance = balanceOf(address(this));
221             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
222                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
223                 uint256 contractETHBalance = address(this).balance;
224                 if(contractETHBalance > 0) {
225                     sendETHToFee(address(this).balance);
226                 }
227             }
228         }
229 
230         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
231             taxAmount = 0;
232         }
233 
234         _balances[from]=_balances[from].sub(amount);
235         _balances[to]=_balances[to].add(amount.sub(taxAmount));
236         emit Transfer(from, to, amount.sub(taxAmount));
237     }
238 
239 
240     function min(uint256 a, uint256 b) private pure returns (uint256){
241       return (a>b)?b:a;
242     }
243 
244     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
245         address[] memory path = new address[](2);
246         path[0] = address(this);
247         path[1] = uniswapV2Router.WETH();
248         _approve(address(this), address(uniswapV2Router), tokenAmount);
249         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
250             tokenAmount,
251             0,
252             path,
253             address(this),
254             block.timestamp
255         );
256     }
257 
258     function removeLimits() external onlyOwner{
259         _maxTxAmount = _tTotal;
260         _maxWalletSize=_tTotal;
261         transferDelayEnabled=false;
262         emit MaxTxAmountUpdated(_tTotal);
263     }
264 
265     function sendETHToFee(uint256 amount) private {
266         _devWallet.transfer(amount);
267     }
268 
269     function openTrading() external onlyOwner() {
270         require(!tradingOpen,"trading is already open");
271         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
272         _approve(address(this), address(uniswapV2Router), _tTotal);
273         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
274         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
275         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
276         swapEnabled = true;
277         tradingOpen = true;
278     }
279 
280     receive() external payable {}
281 
282     function manualSend() external {
283         require(_msgSender()==_devWallet);
284         uint256 ethBalance=address(this).balance;
285         if(ethBalance>0){
286             sendETHToFee(ethBalance);
287         }
288     }
289 
290     function manualSwap() external {
291         require(_msgSender() == _devWallet);
292         uint256 tokenBalance=balanceOf(address(this));
293         if(tokenBalance>0){
294           swapTokensForEth(tokenBalance);
295         }
296         uint256 ethBalance=address(this).balance;
297         if(ethBalance>0){
298           sendETHToFee(address(this).balance);
299         }
300     }
301 }