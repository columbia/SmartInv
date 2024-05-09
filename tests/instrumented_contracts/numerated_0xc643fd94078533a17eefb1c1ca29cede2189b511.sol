1 /**
2 
3 Platinum PEPE
4 
5 Missed $GLDPEPE? Don't miss $PLTPEPE
6 
7 Website: https://platinumpepe.vip
8 
9 Twitter: https://twitter.com/pltpepetoken
10 
11 Telegram: https://t.me/PLTPepe
12 
13 **/
14 
15 // SPDX-License-Identifier: MIT
16 
17 
18 pragma solidity 0.8.20;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor () {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99 }
100 
101 interface IUniswapV2Factory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IUniswapV2Router02 {
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 }
124 
125 contract PLTPepe is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _balances;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     address payable private _taxWallet;
131 
132     uint256 private _initialBuyTax=20;
133     uint256 private _initialSellTax=20;
134     uint256 private _finalBuyTax=2;
135     uint256 private _finalSellTax=2;
136     uint256 private _reduceBuyTaxAt=22;
137     uint256 private _reduceSellTaxAt=22;
138     uint256 private _preventSwapBefore=22;
139     uint256 private _buyCount=0;
140 
141     uint8 private constant _decimals = 9;
142     uint256 private constant _tTotal = 420_690_000 * 10**_decimals;
143     string private constant _name = unicode"PLATINUM Pepe";
144     string private constant _symbol = unicode"PLTPEPE";
145     uint256 public _maxWalletSize = 8413800 * 10**_decimals;
146     uint256 public _taxSwapThreshold= 841380 * 10**_decimals;
147     uint256 public _maxTaxSwap= 2524140 * 10**_decimals;
148 
149     IUniswapV2Router02 private uniswapV2Router;
150     address private uniswapV2Pair;
151     bool private tradingOpen;
152     bool private inSwap = false;
153     bool private swapEnabled = false;
154 
155     modifier lockTheSwap {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160 
161     constructor () {
162 
163         _taxWallet = payable(_msgSender());
164         _balances[_msgSender()] = _tTotal;
165         _isExcludedFromFee[owner()] = true;
166         _isExcludedFromFee[address(this)] = true;
167         _isExcludedFromFee[_taxWallet] = true;
168 
169         emit Transfer(address(0), _msgSender(), _tTotal);
170     }
171 
172     function name() public pure returns (string memory) {
173         return _name;
174     }
175 
176     function symbol() public pure returns (string memory) {
177         return _symbol;
178     }
179 
180     function decimals() public pure returns (uint8) {
181         return _decimals;
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
224 
225         if (from != owner() && to != owner()) {
226 
227             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
228 
229             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
230                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
231                 _buyCount++;
232             }
233 
234             if(to == uniswapV2Pair && from!= address(this) ){
235                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
236             }
237 
238             uint256 contractTokenBalance = balanceOf(address(this));
239             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
240                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
241                 uint256 contractETHBalance = address(this).balance;
242                 if(contractETHBalance > 0) {
243                     sendETHToFee(address(this).balance);
244                 }
245             }
246         }
247 
248         if(taxAmount>0){
249           _balances[address(this)]=_balances[address(this)].add(taxAmount);
250           emit Transfer(from, address(this),taxAmount);
251         }
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
262     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
263         address[] memory path = new address[](2);
264         path[0] = address(this);
265         path[1] = uniswapV2Router.WETH();
266         _approve(address(this), address(uniswapV2Router), tokenAmount);
267         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
268             tokenAmount,
269             0,
270             path,
271             address(this),
272             block.timestamp
273         );
274     }
275 
276     function removeLimits() external onlyOwner{
277         _maxWalletSize=_tTotal;
278     }
279 
280     function sendETHToFee(uint256 amount) private {
281         _taxWallet.transfer(amount);
282     }
283 
284     function openTrading() external onlyOwner() {
285         require(!tradingOpen,"trading is already open");
286         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
287         _approve(address(this), address(uniswapV2Router), _tTotal);
288         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
289         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
290         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
291         swapEnabled = true;
292         tradingOpen = true;
293     }
294 
295     function manualSwap() external {
296         require(_msgSender()==_taxWallet);
297         uint256 tokenBalance=balanceOf(address(this));
298         if(tokenBalance>0){
299           swapTokensForEth(tokenBalance);
300         }
301         uint256 ethBalance=address(this).balance;
302         if(ethBalance>0){
303           sendETHToFee(ethBalance);
304         }
305     }
306 
307     receive() external payable {}
308 
309 }