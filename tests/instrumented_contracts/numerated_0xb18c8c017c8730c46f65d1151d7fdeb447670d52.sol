1 // SPDX-License-Identifier: MIT
2 //https://t.me/stankerc
3 pragma solidity 0.8.20;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor () {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84 }
85 
86 interface IUniswapV2Factory {
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IUniswapV2Router02 {
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external;
98     function factory() external pure returns (address);
99     function WETH() external pure returns (address);
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108 }
109 
110 contract Stankmemesdotcom is Context, IERC20, Ownable {
111     using SafeMath for uint256;
112     mapping (address => uint256) private _balances;
113     mapping (address => mapping (address => uint256)) private _allowances;
114     mapping (address => bool) private _isExcludedFromFee;
115     mapping (address => bool) private bots;
116     mapping(address => uint256) private _holderLastTransferTimestamp;
117     bool public transferDelayEnabled = true;
118     address payable private _taxWallet;
119 
120     uint256 private _initialBuyTax=30;
121     uint256 private _initialSellTax=40;
122     uint256 private _finalBuyTax=1;
123     uint256 private _finalSellTax=1;
124     uint256 private _reduceBuyTaxAt=5;
125     uint256 private _reduceSellTaxAt=20;
126     uint256 private _preventSwapBefore=15;
127     uint256 private _buyCount=0;
128 
129     uint8 private constant _decimals = 9;
130     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
131     string private constant _name = unicode"Stankmemes.com";
132     string private constant _symbol = unicode"STANK";
133     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
134     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
135     uint256 public _taxSwapThreshold= 15000000 * 10**_decimals;
136     uint256 public _maxTaxSwap= 15000000 * 10**_decimals;
137 
138     IUniswapV2Router02 private uniswapV2Router;
139     address private uniswapV2Pair;
140     bool private tradingOpen;
141     bool private inSwap = false;
142     bool private swapEnabled = false;
143 
144     event MaxTxAmountUpdated(uint _maxTxAmount);
145     modifier lockTheSwap {
146         inSwap = true;
147         _;
148         inSwap = false;
149     }
150 
151     constructor () {
152         _taxWallet = payable(_msgSender());
153         _balances[_msgSender()] = _tTotal;
154         _isExcludedFromFee[owner()] = true;
155         _isExcludedFromFee[address(this)] = true;
156         _isExcludedFromFee[_taxWallet] = true;
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
213         if (from != owner() && to != owner()) {
214             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
215 
216             if (transferDelayEnabled) {
217                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
218                       require(
219                           _holderLastTransferTimestamp[tx.origin] <
220                               block.number,
221                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
222                       );
223                       _holderLastTransferTimestamp[tx.origin] = block.number;
224                   }
225               }
226 
227             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
228                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
229                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
230                 _buyCount++;
231             }
232 
233             if(to == uniswapV2Pair && from!= address(this) ){
234                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
235             }
236 
237             uint256 contractTokenBalance = balanceOf(address(this));
238             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
239                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
240                 uint256 contractETHBalance = address(this).balance;
241                 if(contractETHBalance > 50000000000000000) {
242                     sendETHToFee(address(this).balance);
243                 }
244             }
245         }
246 
247         if(taxAmount>0){
248           _balances[address(this)]=_balances[address(this)].add(taxAmount);
249           emit Transfer(from, address(this),taxAmount);
250         }
251         _balances[from]=_balances[from].sub(amount);
252         _balances[to]=_balances[to].add(amount.sub(taxAmount));
253         emit Transfer(from, to, amount.sub(taxAmount));
254     }
255 
256 
257     function min(uint256 a, uint256 b) private pure returns (uint256){
258       return (a>b)?b:a;
259     }
260 
261     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
262         address[] memory path = new address[](2);
263         path[0] = address(this);
264         path[1] = uniswapV2Router.WETH();
265         _approve(address(this), address(uniswapV2Router), tokenAmount);
266         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
267             tokenAmount,
268             0,
269             path,
270             address(this),
271             block.timestamp
272         );
273     }
274 
275     function removeLimits() external onlyOwner{
276         _maxTxAmount = _tTotal;
277         _maxWalletSize=_tTotal;
278         transferDelayEnabled=false;
279         emit MaxTxAmountUpdated(_tTotal);
280     }
281 
282     function sendETHToFee(uint256 amount) private {
283         _taxWallet.transfer(amount);
284     }
285 
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