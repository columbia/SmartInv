1 // SPDX-License-Identifier: MIT
2 
3 
4 /** 
5 Name Landwolf 
6 
7 Ticker:  LANDWOLF 
8 
9 Telegram : https://t.me/LandWolfToken_erc
10 
11 Twitter : https://twitter.com/Landwolfcoinerc
12 
13 Website : https://www.landwolf.top/
14 **/
15 
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
125 contract Landwolf  is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _balances;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private bots;
131     mapping(address => uint256) private _holderLastTransferTimestamp;
132     bool public transferDelayEnabled = true;
133     address payable private _taxWallet;
134 
135     uint256 private _initialBuyTax=20;
136     uint256 private _initialSellTax=25;
137     uint256 private _finalBuyTax=1;
138     uint256 private _finalSellTax=1;
139     uint256 private _reduceBuyTaxAt=25;
140     uint256 private _reduceSellTaxAt=25;
141     uint256 private _preventSwapBefore=15;
142     uint256 private _buyCount=0;
143 
144     uint8 private constant _decimals = 9;
145     uint256 private constant _tTotal = 100000000 * 10**_decimals;
146     string private constant _name = unicode"Landwolf ";
147     string private constant _symbol = unicode"LANDWOLF";
148     uint256 public _maxTxAmount = 2000000 * 10**_decimals;
149     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
150     uint256 public _taxSwapThreshold= 300000 * 10**_decimals;
151     uint256 public _maxTaxSwap= 1700000 * 10**_decimals;
152 
153     IUniswapV2Router02 private uniswapV2Router;
154     address private uniswapV2Pair;
155     bool private tradingOpen;
156     bool private inSwap = false;
157     bool private swapEnabled = false;
158 
159     event MaxTxAmountUpdated(uint _maxTxAmount);
160     modifier lockTheSwap {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165 
166     constructor () {
167         _taxWallet = payable(_msgSender());
168         _balances[_msgSender()] = _tTotal;
169         _isExcludedFromFee[owner()] = true;
170         _isExcludedFromFee[address(this)] = true;
171         _isExcludedFromFee[_taxWallet] = true;
172 
173         emit Transfer(address(0), _msgSender(), _tTotal);
174     }
175 
176     function name() public pure returns (string memory) {
177         return _name;
178     }
179 
180     function symbol() public pure returns (string memory) {
181         return _symbol;
182     }
183 
184     function decimals() public pure returns (uint8) {
185         return _decimals;
186     }
187 
188     function totalSupply() public pure override returns (uint256) {
189         return _tTotal;
190     }
191 
192     function balanceOf(address account) public view override returns (uint256) {
193         return _balances[account];
194     }
195 
196     function transfer(address recipient, uint256 amount) public override returns (bool) {
197         _transfer(_msgSender(), recipient, amount);
198         return true;
199     }
200 
201     function allowance(address owner, address spender) public view override returns (uint256) {
202         return _allowances[owner][spender];
203     }
204 
205     function approve(address spender, uint256 amount) public override returns (bool) {
206         _approve(_msgSender(), spender, amount);
207         return true;
208     }
209 
210     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
211         _transfer(sender, recipient, amount);
212         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
213         return true;
214     }
215 
216     function _approve(address owner, address spender, uint256 amount) private {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223     function _transfer(address from, address to, uint256 amount) private {
224         require(from != address(0), "ERC20: transfer from the zero address");
225         require(to != address(0), "ERC20: transfer to the zero address");
226         require(amount > 0, "Transfer amount must be greater than zero");
227         uint256 taxAmount=0;
228         if (from != owner() && to != owner()) {
229             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
230 
231             if (transferDelayEnabled) {
232                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
233                       require(
234                           _holderLastTransferTimestamp[tx.origin] <
235                               block.number,
236                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
237                       );
238                       _holderLastTransferTimestamp[tx.origin] = block.number;
239                   }
240               }
241 
242             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
243                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
244                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
245                 _buyCount++;
246             }
247 
248             if(to == uniswapV2Pair && from!= address(this) ){
249                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
250             }
251 
252             uint256 contractTokenBalance = balanceOf(address(this));
253             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
254                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
255                 uint256 contractETHBalance = address(this).balance;
256                 if(contractETHBalance > 50000000000000000) {
257                     sendETHToFee(address(this).balance);
258                 }
259             }
260         }
261 
262         if(taxAmount>0){
263           _balances[address(this)]=_balances[address(this)].add(taxAmount);
264           emit Transfer(from, address(this),taxAmount);
265         }
266         _balances[from]=_balances[from].sub(amount);
267         _balances[to]=_balances[to].add(amount.sub(taxAmount));
268         emit Transfer(from, to, amount.sub(taxAmount));
269     }
270 
271 
272     function min(uint256 a, uint256 b) private pure returns (uint256){
273       return (a>b)?b:a;
274     }
275 
276     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
277         address[] memory path = new address[](2);
278         path[0] = address(this);
279         path[1] = uniswapV2Router.WETH();
280         _approve(address(this), address(uniswapV2Router), tokenAmount);
281         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
282             tokenAmount,
283             0,
284             path,
285             address(this),
286             block.timestamp
287         );
288     }
289 
290     function removeLimits() external onlyOwner{
291         _maxTxAmount = _tTotal;
292         _maxWalletSize=_tTotal;
293         transferDelayEnabled=false;
294         emit MaxTxAmountUpdated(_tTotal);
295     }
296 
297     function sendETHToFee(uint256 amount) private {
298         _taxWallet.transfer(amount);
299     }
300 
301 
302     function openTrading() external onlyOwner() {
303         require(!tradingOpen,"trading is already open");
304         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
305         _approve(address(this), address(uniswapV2Router), _tTotal);
306         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
307         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
308         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
309         swapEnabled = true;
310         tradingOpen = true;
311     }
312 
313     receive() external payable {}
314 
315     function manualSwap() external {
316         require(_msgSender()==_taxWallet);
317         uint256 tokenBalance=balanceOf(address(this));
318         if(tokenBalance>0){
319           swapTokensForEth(tokenBalance);
320         }
321         uint256 ethBalance=address(this).balance;
322         if(ethBalance>0){
323           sendETHToFee(ethBalance);
324         }
325     }
326 }