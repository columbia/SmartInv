1 // SPDX-License-Identifier: MIT
2 // https://t.me/BabyFLC
3 
4 pragma solidity 0.8.18;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37         return c;
38     }
39 
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         return c;
57     }
58 
59 }
60 
61 contract Ownable is Context {
62     address private _owner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor () {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85 }
86 
87 interface IUniswapV2Factory {
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90 
91 interface IUniswapV2Router02 {
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109 }
110 
111 contract FLC is Context, IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _balances;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     mapping(address => uint256) private _holderLastTransferTimestamp;
117     bool public transferDelayEnabled = true;
118     address payable private _taxWallet;
119 
120     uint256 private _initialBuyTax=25;
121     uint256 private _initialSellTax=40;
122     uint256 private _finalBuyTax=1;
123     uint256 private _finalSellTax=1;
124     uint256 private _reduceBuyTaxAt=25;
125     uint256 private _reduceSellTaxAt=25;
126     uint256 private _preventSwapBefore=25;
127     uint256 private _buyCount=0;
128 
129     uint8 private constant _decimals = 18;
130     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
131     string private constant _name = unicode"BABY Flooring Lab Credit";
132     string private constant _symbol = unicode"BABY FLC";
133     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
134     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
135     uint256 public _taxSwapThreshold= 2000000 * 10**_decimals;
136     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
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
238             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
239                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
240                 uint256 contractETHBalance = address(this).balance;
241                 if(contractETHBalance > 0) {
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
286     function openTrading() external onlyOwner() {
287         require(!tradingOpen,"Trading is already open");
288         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
289         _approve(address(this), address(uniswapV2Router), _tTotal);
290         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
291         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
292         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
293         swapEnabled = true;
294         tradingOpen = true;
295     }
296 
297     receive() external payable {}
298 }//