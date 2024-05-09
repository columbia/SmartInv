1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25         return c;
26     }
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
31         require(b <= a, errorMessage);
32         uint256 c = a - b;
33         return c;
34     }
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39         uint256 c = a * b;
40         require(c / a == b, "SafeMath: multiplication overflow");
41         return c;
42     }
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         return div(a, b, "SafeMath: division by zero");
45     }
46     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b > 0, errorMessage);
48         uint256 c = a / b;
49         return c;
50     }
51 }
52 
53 contract Ownable is Context {
54     address private _owner;
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     constructor () {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     function renounceOwnership() public virtual onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76 }
77 
78 interface IUniswapV2Factory {
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80 }
81 
82 interface IUniswapV2Router02 {
83     function swapExactTokensForETHSupportingFeeOnTransferTokens(
84         uint amountIn,
85         uint amountOutMin,
86         address[] calldata path,
87         address to,
88         uint deadline
89     ) external;
90     function factory() external pure returns (address);
91     function WETH() external pure returns (address);
92     function addLiquidityETH(
93         address token,
94         uint amountTokenDesired,
95         uint amountTokenMin,
96         uint amountETHMin,
97         address to,
98         uint deadline
99     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
100 }
101 
102 contract NEWS is Context, IERC20, Ownable {
103     using SafeMath for uint256;
104     mapping (address => uint256) private _balances;
105     mapping (address => mapping (address => uint256)) private _allowances;
106     mapping (address => bool) private _isExcludedFromFee;
107     mapping(address => uint256) private _holderLastTransferTimestamp;
108     bool public transferDelayEnabled = false;
109     address payable private _taxWallet;
110 
111     uint256 private _initialBuyTax= 33;
112     uint256 private _initialSellTax= 33;
113     uint256 private _finalBuyTax= 3;
114     uint256 private _finalSellTax= 3;
115     uint256 private _reduceBuyTaxAt= 15;
116     uint256 private _reduceSellTaxAt= 15;
117     uint256 private _preventSwapBefore= 15;
118     uint256 private _buyCount= 0;
119 
120     uint8 private constant _decimals = 8;
121     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
122     string private constant _name = unicode"CRYPTO NEWS";
123     string private constant _symbol = unicode"NEWS";
124     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
125     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
126     uint256 public _taxSwapThreshold=5000000 * 10**_decimals;
127     uint256 public _maxTaxSwap = 5000000 * 10**_decimals;
128 
129     IUniswapV2Router02 private uniswapV2Router;
130     address private uniswapV2Pair;
131     bool private tradingOpen;
132     bool private inSwap = false;
133     bool private swapEnabled = false;
134 
135     event MaxTxAmountUpdated(uint _maxTxAmount);
136 
137     modifier lockTheSwap {
138         inSwap = true;
139         _;
140         inSwap = false;
141     }
142 
143     constructor () {
144         _taxWallet = payable(0x26c0eA6E9F0231dc253CB746Cb61f9fBDDe073e5);
145         _balances[_msgSender()] = _tTotal;
146         _isExcludedFromFee[owner()] = true;
147         _isExcludedFromFee[address(this)] = true;
148         _isExcludedFromFee[_taxWallet] = true;
149 
150         emit Transfer(address(0), _msgSender(), _tTotal);
151     }
152 
153     function name() public pure returns (string memory) {
154         return _name;
155     }
156 
157     function symbol() public pure returns (string memory) {
158         return _symbol;
159     }
160 
161     function decimals() public pure returns (uint8) {
162         return _decimals;
163     }
164 
165     function totalSupply() public pure override returns (uint256) {
166         return _tTotal;
167     }
168 
169     function balanceOf(address account) public view override returns (uint256) {
170         return _balances[account];
171     }
172 
173     function transfer(address recipient, uint256 amount) public override returns (bool) {
174         _transfer(_msgSender(), recipient, amount);
175         return true;
176     }
177 
178     function allowance(address owner, address spender) public view override returns (uint256) {
179         return _allowances[owner][spender];
180     }
181 
182     function approve(address spender, uint256 amount) public override returns (bool) {
183         _approve(_msgSender(), spender, amount);
184         return true;
185     }
186 
187     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
188         _transfer(sender, recipient, amount);
189         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
190         return true;
191     }
192 
193     function getBuyCount() public view returns (uint256) {
194     return _buyCount;
195     }
196 
197     function getTaxes() public view returns (uint256, uint256) {
198     uint256 currentBuyTax = (_buyCount > _reduceBuyTaxAt) ? _finalBuyTax : _initialBuyTax;
199     uint256 currentSellTax = (_buyCount > _reduceSellTaxAt) ? _finalSellTax : _initialSellTax;
200     return (currentBuyTax, currentSellTax);
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
214         uint256 taxAmount=0;
215         if (from != owner() && to != owner() && from != address(this)) {
216             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
217 
218             if (transferDelayEnabled) {
219                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
220                       require(
221                           _holderLastTransferTimestamp[tx.origin] <
222                               block.number,
223                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
224                       );
225                       _holderLastTransferTimestamp[tx.origin] = block.number;
226                   }
227               }
228 
229             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
230                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
231                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
232                 _buyCount++;
233             }
234 
235             if(to == uniswapV2Pair && from!= address(this) ){
236                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
237             }
238 
239             uint256 contractTokenBalance = balanceOf(address(this));
240             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
241                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
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
277         _maxTxAmount = _tTotal;
278         _maxWalletSize=_tTotal;
279         transferDelayEnabled=false;
280         emit MaxTxAmountUpdated(_tTotal);
281     }
282 
283     function sendETHToFee(uint256 amount) private {
284         _taxWallet.transfer(amount);
285     }
286 
287     function openTrading() external onlyOwner() {
288         require(!tradingOpen,"trading is already open");
289         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
290         _approve(address(this), address(uniswapV2Router), _tTotal);
291         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
292         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
293         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
294         swapEnabled = true;
295         tradingOpen = true;
296     }
297 
298     receive() external payable {}
299 
300     function manualSwap() external {
301         require(_msgSender()==_taxWallet);
302         uint256 tokenBalance=balanceOf(address(this));
303         if(tokenBalance>0){
304           swapTokensForEth(tokenBalance);
305         }
306         uint256 ethBalance=address(this).balance;
307         if(ethBalance>0){
308           sendETHToFee(ethBalance);
309         }
310     }
311 }