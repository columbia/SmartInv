1 /*
2 
3 $MOAI - AI for Everyone
4 
5 https://moai.wtf/
6 https://t.me/MOAIPortal
7 https://twitter.com/moai_erc20
8 https://more-ai.gitbook.io
9 
10 */
11 
12 pragma solidity 0.8.21;
13 // SPDX-License-Identifier: MIT
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
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61 
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         return c;
66     }
67 
68 }
69 
70 contract Ownable is Context {
71     address private _owner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     modifier onlyOwner() {
85         require(_owner == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94 }
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 }
119 
120 contract MOAI is Context, IERC20, Ownable {
121     using SafeMath for uint256;
122     mapping (address => uint256) private _balances;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     address payable private _devWallet;
126     address payable private _marketingWallet;
127 
128     string private constant _name =    unicode"MORE AI";
129     string private constant _symbol =  unicode"MOAI";
130     uint8 private constant _decimals = 18;
131     uint256 private constant _tTotal = 1 * 1e8 * 10**_decimals;
132     uint256 private _BuyTax=           15;
133     uint256 private _SellTax=          35;
134     uint256 public _maxTxAmount =      _tTotal * 1 / 100;
135     uint256 public _maxWalletSize =    _tTotal * 2 / 100;
136     uint256 public _taxSwapThreshold=  _tTotal * 5 / 10000;
137     uint256 public _maxTaxSwap=        _tTotal * 1 / 100;
138 
139     IUniswapV2Router02 private uniswapV2Router;
140     address private uniswapV2Pair;
141     bool private tradingOpen;
142     bool private inSwap = false;
143     bool private swapEnabled = false;
144 
145     event MaxTxAmountUpdated(uint _maxTxAmount);
146     modifier lockTheSwap {
147         inSwap = true;
148         _;
149         inSwap = false;
150     }
151 
152     constructor () {
153         _devWallet = payable(_msgSender());
154         _marketingWallet = payable(0x9326d33bc815977634a1b37DF66813de63b189AD);
155         _balances[_msgSender()] = _tTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_devWallet] = true;
159         _isExcludedFromFee[_marketingWallet] = true;
160 
161         emit Transfer(address(0), _msgSender(), _tTotal);
162     }
163 
164     function name() public pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function buyTax() public view returns (uint256) {
177         return _BuyTax;
178     }
179 
180     function sellTax() public view returns (uint256) {
181         return _SellTax;
182     }
183 
184     function totalSupply() public pure override returns (uint256) {
185         return _tTotal;
186     }
187 
188     function balanceOf(address account) public view override returns (uint256) {
189         return _balances[account];
190     }
191 
192     function transfer(address recipient, uint256 amount) public override returns (bool) {
193         _transfer(_msgSender(), recipient, amount);
194         return true;
195     }
196 
197     function allowance(address owner, address spender) public view override returns (uint256) {
198         return _allowances[owner][spender];
199     }
200 
201     function approve(address spender, uint256 amount) public override returns (bool) {
202         _approve(_msgSender(), spender, amount);
203         return true;
204     }
205 
206     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
207         _transfer(sender, recipient, amount);
208         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
209         return true;
210     }
211 
212     function _approve(address owner, address spender, uint256 amount) private {
213         require(owner != address(0), "ERC20: approve from the zero address");
214         require(spender != address(0), "ERC20: approve to the zero address");
215         _allowances[owner][spender] = amount;
216         emit Approval(owner, spender, amount);
217     }
218 
219     function _transfer(address from, address to, uint256 amount) private {
220         require(from != address(0), "ERC20: transfer from the zero address");
221         require(to != address(0), "ERC20: transfer to the zero address");
222         require(amount > 0, "Transfer amount must be greater than zero");
223         uint256 taxAmount=0;
224         if (from != owner() && to != owner() && from != _marketingWallet && to != _marketingWallet && from != _devWallet && to != _devWallet) {
225 
226             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
227                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
228                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the _maxWalletSize.");
229             }
230             
231             if(from == uniswapV2Pair && to != address(this)){
232                 taxAmount = amount.mul(_BuyTax).div(100);
233             }
234             if(to == uniswapV2Pair && from != address(this)){
235                 taxAmount = amount.mul(_SellTax).div(100);
236             }
237 
238             uint256 contractTokenBalance = balanceOf(address(this));
239             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
240                 uint256 amountToSwap = (amount < contractTokenBalance && amount < _maxTaxSwap) ? amount : (contractTokenBalance < _maxTaxSwap) ? contractTokenBalance : _maxTaxSwap;
241                 swapTokensForEth(amountToSwap);
242                 uint256 contractETHBalance = address(this).balance;
243                 if(contractETHBalance > 0) {
244                     sendETHToFee(address(this).balance);
245                 }
246             }
247         }
248 
249         if(taxAmount>0){
250           _balances[address(this)]=_balances[address(this)].add(taxAmount);
251           emit Transfer(from, address(this),taxAmount);
252         }
253         _balances[from]=_balances[from].sub(amount);
254         _balances[to]=_balances[to].add(amount.sub(taxAmount));
255         emit Transfer(from, to, amount.sub(taxAmount));
256     }
257 
258     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
259         if(tokenAmount==0){return;}
260         if(!tradingOpen){return;}
261         address[] memory path = new address[](2);
262         path[0] = address(this);
263         path[1] = uniswapV2Router.WETH();
264         _approve(address(this), address(uniswapV2Router), tokenAmount);
265         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
266             tokenAmount,
267             0,
268             path,
269             address(this),
270             block.timestamp
271         );
272     }
273 
274     function removeLimits() external onlyOwner{
275         _maxTxAmount = _tTotal;
276         _maxWalletSize=_tTotal;
277         emit MaxTxAmountUpdated(_tTotal);
278     }
279 
280     function updateTax(uint256 BuyTax, uint256 SellTax) external onlyOwner {
281         _BuyTax = BuyTax;
282         _SellTax= SellTax; 
283     }
284 
285     function manualSwap() external onlyOwner {
286         uint256 tokenBalance=balanceOf(address(this));
287         if(tokenBalance>0){
288           swapTokensForEth(tokenBalance);
289         }
290         uint256 ethBalance=address(this).balance;
291         if(ethBalance>0){
292           sendETHToFee(ethBalance);
293         }
294     }
295 
296     function sendETHToFee(uint256 amount) private {
297         _marketingWallet.transfer(amount);
298     }
299 
300     function openTrading() external onlyOwner() {
301         require(!tradingOpen,"Trading is already open");
302         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
303         _approve(address(this), address(uniswapV2Router), _tTotal);
304         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
305         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
306         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
307         swapEnabled = true;
308         tradingOpen = true;
309     }
310 
311     receive() external payable {}
312   
313 }