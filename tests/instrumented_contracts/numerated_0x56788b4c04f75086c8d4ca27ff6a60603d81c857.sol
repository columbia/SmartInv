1 // SPDX-License-Identifier: MIT
2 /**
3 
4 $RVLVR - Revolver Revenue Share Sniper
5 
6 https://t.me/revolvershare
7 https://rvlvrshare.net/
8 https://twitter.com/RevolverERC
9 https://medium.com/@RevolverERC
10 https://revolver-rev-share-sniper.gitbook.io/what-is-usdrvlvr/
11 
12 **/
13 pragma solidity 0.8.20;
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
120 contract Revolver is Context, IERC20, Ownable {
121     using SafeMath for uint256;
122     mapping (address => uint256) private _balances;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private bots;
126     mapping(address => uint256) private _holderLastTransferTimestamp;
127     bool public transferDelayEnabled = false;
128     address payable private _taxWallet;
129 
130     uint256 private _initialBuyTax=20;
131     uint256 private _initialSellTax=32;
132     uint256 private _finalBuyTax=4;
133     uint256 private _finalSellTax=4;
134     uint256 private _reduceBuyTaxAt=30;
135     uint256 private _reduceSellTaxAt=30;
136     uint256 private _preventSwapBefore=30;
137     uint256 private _buyCount=0;
138 
139     uint8 private constant _decimals = 9;
140     uint256 private constant _tTotal = 10000000 * 10**_decimals;
141     string private constant _name = "Revolver Revenue Share Sniper";
142     string private constant _symbol = "RVLVR";
143     uint256 public _maxTxAmount =   10000000 * 10**_decimals;
144     uint256 public _maxWalletSize = 200000 * 10**_decimals;
145     uint256 public _taxSwapThreshold= 50000 * 10**_decimals;
146     uint256 public _maxTaxSwap= 50000 * 10**_decimals;
147 
148     IUniswapV2Router02 private uniswapV2Router;
149     address private uniswapV2Pair;
150     bool private tradingOpen;
151     bool private inSwap = false;
152     bool private swapEnabled = false;
153 
154     event MaxTxAmountUpdated(uint _maxTxAmount);
155     modifier lockTheSwap {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160 
161     constructor () {
162         _taxWallet = payable(_msgSender());
163         _balances[_msgSender()] = _tTotal;
164         _isExcludedFromFee[owner()] = true;
165         _isExcludedFromFee[address(this)] = true;
166         _isExcludedFromFee[_taxWallet] = true;
167 
168         emit Transfer(address(0), _msgSender(), _tTotal);
169     }
170 
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint8) {
180         return _decimals;
181     }
182 
183     function totalSupply() public pure override returns (uint256) {
184         return _tTotal;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return _balances[account];
189     }
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210 
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
224          if (from != owner() && to != owner()) {
225     
226 
227 
228             if (transferDelayEnabled) {
229                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
230                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
231                   _holderLastTransferTimestamp[tx.origin] = block.number;
232                 }
233             }
234 
235             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
236                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
237                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
238                 if(_buyCount<_preventSwapBefore){
239                   require(!isContract(to));
240                 }
241                 _buyCount++;
242             }
243 
244 
245             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
246             if(to == uniswapV2Pair && from!= address(this) ){
247                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
248                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
249             }
250 
251             uint256 contractTokenBalance = balanceOf(address(this));
252             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
253                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
254                 uint256 contractETHBalance = address(this).balance;
255                 if(contractETHBalance > 0) {
256                     sendETHToFee(address(this).balance);
257                 }
258             }
259         }
260 
261         if(taxAmount>0){
262           _balances[address(this)]=_balances[address(this)].add(taxAmount);
263           emit Transfer(from, address(this),taxAmount);
264         }
265         _balances[from]=_balances[from].sub(amount);
266         _balances[to]=_balances[to].add(amount.sub(taxAmount));
267         emit Transfer(from, to, amount.sub(taxAmount));
268     }
269 
270 
271     function min(uint256 a, uint256 b) private pure returns (uint256){
272       return (a>b)?b:a;
273     }
274 
275     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
276         if(tokenAmount==0){return;}
277         if(!tradingOpen){return;}
278         address[] memory path = new address[](2);
279         path[0] = address(this);
280         path[1] = uniswapV2Router.WETH();
281         _approve(address(this), address(uniswapV2Router), tokenAmount);
282         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
283             tokenAmount,
284             0,
285             path,
286             address(this),
287             block.timestamp
288         );
289     }
290 
291     function removeLimits() external onlyOwner{
292         _maxTxAmount = _tTotal;
293         _maxWalletSize=_tTotal;
294         transferDelayEnabled=false;
295         emit MaxTxAmountUpdated(_tTotal);
296     }
297 
298     function sendETHToFee(uint256 amount) private {
299         _taxWallet.transfer(amount);
300     }
301 
302 
303     function openTrading() external onlyOwner() {
304         require(!tradingOpen,"trading is already open");
305         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306         _approve(address(this), address(uniswapV2Router), _tTotal);
307         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
308         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
309         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
310         swapEnabled = true;
311         tradingOpen = true;
312     }
313 
314     receive() external payable {}
315 
316     function isContract(address account) private view returns (bool) {
317         uint256 size;
318         assembly {
319             size := extcodesize(account)
320         }
321         return size > 0;
322     }
323 
324 }