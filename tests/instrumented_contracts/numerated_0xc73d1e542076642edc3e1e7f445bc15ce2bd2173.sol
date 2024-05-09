1 /*
2 https://www.dowjones69420.com/
3 
4 https://t.me/dowjones69420
5 
6 https://twitter.com/dowjones69420
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
116 contract DJX is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     bool public transferDelayEnabled = true;
122 
123     address payable private _devWallet;
124 
125     uint256 private _buyTax = 1;
126     uint256 private _sellTax = 1;
127 
128     uint8 private constant _decimals = 9;
129     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
130     string private constant _name = unicode"DowJones69420";
131     string private constant _symbol = unicode"DJX";
132     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
133     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
134     uint256 public _taxSwapThreshold= 2000000 * 10**_decimals;
135     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142 
143     event MaxTxAmountUpdated(uint _maxTxAmount);
144     modifier lockTheSwap {
145         inSwap = true;
146         _;
147         inSwap = false;
148     }
149 
150     constructor () {
151         _devWallet = payable(_msgSender());
152         _balances[_msgSender()] = _tTotal;
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[_devWallet] = true;
156 
157         emit Transfer(address(0), _msgSender(), _tTotal);
158     }
159 
160     function name() public pure returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() public pure returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() public pure returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() public pure override returns (uint256) {
173         return _tTotal;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return _balances[account];
178     }
179 
180     function transfer(address recipient, uint256 amount) public override returns (bool) {
181         _transfer(_msgSender(), recipient, amount);
182         return true;
183     }
184 
185     function allowance(address owner, address spender) public view override returns (uint256) {
186         return _allowances[owner][spender];
187     }
188 
189     function approve(address spender, uint256 amount) public override returns (bool) {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
195         _transfer(sender, recipient, amount);
196         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
197         return true;
198     }
199 
200     function _approve(address owner, address spender, uint256 amount) private {
201         require(owner != address(0), "ERC20: approve from the zero address");
202         require(spender != address(0), "ERC20: approve to the zero address");
203         _allowances[owner][spender] = amount;
204         emit Approval(owner, spender, amount);
205     }
206 
207     function _transfer(address from, address to, uint256 amount) private {
208         require(from != address(0), "ERC20: transfer from the zero address");
209         require(to != address(0), "ERC20: transfer to the zero address");
210         require(amount > 0, "Transfer amount must be greater than zero");
211         uint256 taxAmount=0;
212         if (from != owner() && to != owner() && from != _devWallet && to != _devWallet) {
213             taxAmount = amount.mul(_buyTax).div(100);
214 
215             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
216                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
217                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
218             }
219 
220             if(to == uniswapV2Pair && from!= address(this) ){
221                 taxAmount = amount.mul(_sellTax).div(100);
222             }
223 
224             uint256 contractTokenBalance = balanceOf(address(this));
225             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
226                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
227                 uint256 contractETHBalance = address(this).balance;
228                 if(contractETHBalance > 0) {
229                     sendETHToFee(address(this).balance);
230                 }
231             }
232         }
233 
234         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
235             taxAmount = 0;
236         }
237 
238         if(taxAmount > 0){
239           _balances[address(this)]=_balances[address(this)].add(taxAmount);
240           emit Transfer(from, address(this),taxAmount);
241         }
242 
243         _balances[from]=_balances[from].sub(amount);
244         _balances[to]=_balances[to].add(amount.sub(taxAmount));
245         emit Transfer(from, to, amount.sub(taxAmount));
246     }
247 
248 
249     function min(uint256 a, uint256 b) private pure returns (uint256){
250       return (a>b)?b:a;
251     }
252 
253     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
254         address[] memory path = new address[](2);
255         path[0] = address(this);
256         path[1] = uniswapV2Router.WETH();
257         _approve(address(this), address(uniswapV2Router), tokenAmount);
258         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
259             tokenAmount,
260             0,
261             path,
262             address(this),
263             block.timestamp
264         );
265     }
266 
267     function sendETHToFee(uint256 amount) private {
268         _devWallet.transfer(amount);
269     }
270 
271     function setNewFee(uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
272         _buyTax = taxFeeOnBuy;
273         _sellTax = taxFeeOnSell;
274     }
275 
276     function openTrading() external onlyOwner() {
277         require(!tradingOpen,"trading is already open");
278         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
279         _approve(address(this), address(uniswapV2Router), _tTotal);
280         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
281         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
282         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
283         swapEnabled = true;
284         tradingOpen = true;
285     }
286 
287     receive() external payable {}
288 
289     function manualSend() external {
290         require(_msgSender() == _devWallet);
291         uint256 ethBalance=address(this).balance;
292         if(ethBalance>0){
293           sendETHToFee(ethBalance);
294         }
295     }
296 
297     function manualSwap() external {
298         require(_msgSender() == _devWallet);
299         uint256 tokenBalance=balanceOf(address(this));
300         if(tokenBalance>0){
301           swapTokensForEth(tokenBalance);
302         }
303         uint256 ethBalance=address(this).balance;
304         if(ethBalance>0){
305           sendETHToFee(address(this).balance);
306         }
307     }
308 }