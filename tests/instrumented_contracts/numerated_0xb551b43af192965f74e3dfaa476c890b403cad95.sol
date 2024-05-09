1 // SPDX-License-Identifier: MIT
2 
3 /**
4     Data bot - $DATA
5     Le Dev is back, and he cooked something for you... 
6     https://t.me/databotERC
7 **/
8 
9 pragma solidity 0.8.20;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64 }
65 
66 contract Ownable is Context {
67     address private _owner;
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     constructor () {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 }
90 
91 interface IUniswapV2Factory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IUniswapV2Router02 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113 }
114 
115 contract DataBot is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _balances;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) private _isExcludedFromFee;
120     mapping (address => bool) private bots;
121     mapping(address => uint256) private _holderLastTransferTimestamp;
122     bool public transferDelayEnabled = false;
123     address payable private _taxWallet;
124 
125     uint256 private _initialBuyTax=20;
126     uint256 private _initialSellTax=40;
127     uint256 private _finalBuyTax=1;
128     uint256 private _finalSellTax=4;
129     uint256 private _reduceBuyTaxAt=10;
130     uint256 private _reduceSellTaxAt=15;
131     uint256 private _preventSwapBefore=50;
132     uint256 private _buyCount=0;
133 
134     uint8 private constant _decimals = 9;
135     uint256 private constant _tTotal = 1_000_000_000 * 10**_decimals;
136     string private constant _name = unicode"Data bot";
137     string private constant _symbol = unicode"DATA";
138     uint256 public _maxTxAmount = 10_000_000 * 10**_decimals;
139     uint256 public _maxWalletSize = 10_000_000 * 10**_decimals;
140     uint256 public _taxSwapThreshold= 5_000_000 * 10**_decimals;
141     uint256 public _maxTaxSwap= 10_000_000 * 10**_decimals;
142 
143     IUniswapV2Router02 private uniswapV2Router;
144     address private uniswapV2Pair;
145     bool private tradingOpen;
146     bool private inSwap = false;
147     bool private swapEnabled = false;
148 
149     event MaxTxAmountUpdated(uint _maxTxAmount);
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155 
156     constructor () {
157         _taxWallet = payable(_msgSender());
158         _balances[_msgSender()] = _tTotal;
159         _isExcludedFromFee[owner()] = true;
160         _isExcludedFromFee[address(this)] = true;
161         _isExcludedFromFee[_taxWallet] = true;
162 
163         emit Transfer(address(0), _msgSender(), _tTotal);
164     }
165 
166     function name() public pure returns (string memory) {
167         return _name;
168     }
169 
170     function symbol() public pure returns (string memory) {
171         return _symbol;
172     }
173 
174     function decimals() public pure returns (uint8) {
175         return _decimals;
176     }
177 
178     function totalSupply() public pure override returns (uint256) {
179         return _tTotal;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return _balances[account];
184     }
185 
186     function transfer(address recipient, uint256 amount) public override returns (bool) {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     function allowance(address owner, address spender) public view override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     function approve(address spender, uint256 amount) public override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
201         _transfer(sender, recipient, amount);
202         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
203         return true;
204     }
205 
206     function _approve(address owner, address spender, uint256 amount) private {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _transfer(address from, address to, uint256 amount) private {
214         require(from != address(0), "ERC20: transfer from the zero address");
215         require(to != address(0), "ERC20: transfer to the zero address");
216         require(amount > 0, "Transfer amount must be greater than zero");
217         uint256 taxAmount=0;
218         if (from != owner() && to != owner()) {
219             
220 
221             if (transferDelayEnabled) {
222                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
223                       require(
224                           _holderLastTransferTimestamp[tx.origin] <
225                               block.number,
226                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
227                       );
228                       _holderLastTransferTimestamp[tx.origin] = block.number;
229                   }
230               }
231 
232             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
233                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
234                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
235                 taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
236                 _buyCount++;
237             }
238 
239             if(to == uniswapV2Pair && from!= address(this) ){
240                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
241             }
242 
243             uint256 contractTokenBalance = balanceOf(address(this));
244             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
245                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
246                 uint256 contractETHBalance = address(this).balance;
247                 if(contractETHBalance > 50000000000000000) {
248                     sendETHToFee(address(this).balance);
249                 }
250             }
251         }
252 
253         if(taxAmount>0){
254           _balances[address(this)]=_balances[address(this)].add(taxAmount);
255           emit Transfer(from, address(this),taxAmount);
256         }
257         _balances[from]=_balances[from].sub(amount);
258         _balances[to]=_balances[to].add(amount.sub(taxAmount));
259         emit Transfer(from, to, amount.sub(taxAmount));
260     }
261 
262 
263     function min(uint256 a, uint256 b) private pure returns (uint256){
264       return (a>b)?b:a;
265     }
266 
267     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
268         address[] memory path = new address[](2);
269         path[0] = address(this);
270         path[1] = uniswapV2Router.WETH();
271         _approve(address(this), address(uniswapV2Router), tokenAmount);
272         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
273             tokenAmount,
274             0,
275             path,
276             address(this),
277             block.timestamp
278         );
279     }
280 
281     function removeLimits() external onlyOwner{
282         _maxTxAmount = _tTotal;
283         _maxWalletSize=_tTotal;
284         transferDelayEnabled=false;
285         emit MaxTxAmountUpdated(_tTotal);
286     }
287 
288     function sendETHToFee(uint256 amount) private {
289         _taxWallet.transfer(amount);
290     }
291 
292 
293     function openTrading() external onlyOwner() {
294         require(!tradingOpen,"trading is already open");
295         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
296         _approve(address(this), address(uniswapV2Router), _tTotal);
297         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
298         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
299         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
300         swapEnabled = true;
301         tradingOpen = true;
302     }
303 
304     receive() external payable {}
305 
306     function manualSwap() external {
307         require(_msgSender()==_taxWallet);
308         uint256 tokenBalance=balanceOf(address(this));
309         if(tokenBalance>0){
310           swapTokensForEth(tokenBalance);
311         }
312         uint256 ethBalance=address(this).balance;
313         if(ethBalance>0){
314           sendETHToFee(ethBalance);
315         }
316     }
317 }