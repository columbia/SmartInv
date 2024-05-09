1 // SPDX-License-Identifier: MIT
2 
3 /** 
4 
5 Welcome to Hay Classic, so as you know the original Hay Coin has too many wallets that can dump the coin at anytime, it's now time to launch a classic version, without
6 people that can absolutely destroy the chart. We will have 0/0 tax, this is for peace of mind, this is for the people.
7 
8 
9 
10 Join the classic community - https://t.me/hayclassic
11 
12 Website - https://hayclassic.vip/
13 Twitter - https://twitter.com/HayClassic_ERC
14 
15 **/
16 
17 
18 
19 pragma solidity 0.8.20;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library SafeMath {
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71         return c;
72     }
73 
74 }
75 
76 contract Ownable is Context {
77     address private _owner;
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100 }
101 
102 interface IUniswapV2Factory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105 
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116     function addLiquidityETH(
117         address token,
118         uint amountTokenDesired,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
124 }
125 
126 contract HAY is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _balances;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     mapping (address => bool) private bots;
132     mapping(address => uint256) private _holderLastTransferTimestamp;
133     bool public transferDelayEnabled = true;
134     address payable private _taxWallet;
135 
136     uint256 private _initialBuyTax=5;
137     uint256 private _initialSellTax=43;
138     uint256 private _finalBuyTax=0;
139     uint256 private _finalSellTax=0;
140     uint256 private _reduceBuyTaxAt=10;
141     uint256 private _reduceSellTaxAt=10;
142     uint256 private _preventSwapBefore=15;
143     uint256 private _buyCount=0;
144 
145     uint8 private constant _decimals = 9; // This can stay at 9, but 18 is recommended for wider compatibility
146     uint256 private constant _tTotal = 1000000 * 10**_decimals; // Total supply is 1,000,000 tokens
147     string private constant _name = unicode"HAY CLASSIC";
148     string private constant _symbol = unicode"HAY";
149 
150     // Assuming you burned 999,999 tokens and have 1 token left
151     uint256 private constant _effectiveTotal = 1 * 10**_decimals; 
152     uint256 public _maxTxAmount = _effectiveTotal * 2 / 100; // 0.02 tokens
153     uint256 public _maxWalletSize = _effectiveTotal * 2 / 100; // 0.02 tokens
154     uint256 public _taxSwapThreshold = _effectiveTotal / 1000; // 0.001 tokens
155     uint256 public _maxTaxSwap = _effectiveTotal * 17 / 1000; // 0.017 tokens
156 
157 
158     IUniswapV2Router02 private uniswapV2Router;
159     address private uniswapV2Pair;
160     bool private tradingOpen;
161     bool private inSwap = false;
162     bool private swapEnabled = false;
163 
164     event MaxTxAmountUpdated(uint _maxTxAmount);
165     modifier lockTheSwap {
166         inSwap = true;
167         _;
168         inSwap = false;
169     }
170 
171     constructor () {
172         _taxWallet = payable(_msgSender());
173         _balances[_msgSender()] = _tTotal;
174         _isExcludedFromFee[owner()] = true;
175         _isExcludedFromFee[address(this)] = true;
176         _isExcludedFromFee[_taxWallet] = true;
177 
178         emit Transfer(address(0), _msgSender(), _tTotal);
179     }
180 
181     function name() public pure returns (string memory) {
182         return _name;
183     }
184 
185     function symbol() public pure returns (string memory) {
186         return _symbol;
187     }
188 
189     function decimals() public pure returns (uint8) {
190         return _decimals;
191     }
192 
193     function totalSupply() public pure override returns (uint256) {
194         return _tTotal;
195     }
196 
197     function balanceOf(address account) public view override returns (uint256) {
198         return _balances[account];
199     }
200 
201     function transfer(address recipient, uint256 amount) public override returns (bool) {
202         _transfer(_msgSender(), recipient, amount);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view override returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     function approve(address spender, uint256 amount) public override returns (bool) {
211         _approve(_msgSender(), spender, amount);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
218         return true;
219     }
220 
221     function _approve(address owner, address spender, uint256 amount) private {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 
228     function _transfer(address from, address to, uint256 amount) private {
229         require(from != address(0), "ERC20: transfer from the zero address");
230         require(to != address(0), "ERC20: transfer to the zero address");
231         require(amount > 0, "Transfer amount must be greater than zero");
232         uint256 taxAmount=0;
233         if (from != owner() && to != owner()) {
234             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
235 
236             if (transferDelayEnabled) {
237                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
238                       require(
239                           _holderLastTransferTimestamp[tx.origin] <
240                               block.number,
241                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
242                       );
243                       _holderLastTransferTimestamp[tx.origin] = block.number;
244                   }
245               }
246 
247             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
248                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
249                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
250                 _buyCount++;
251             }
252 
253             if(to == uniswapV2Pair && from!= address(this) ){
254                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
255             }
256 
257             uint256 contractTokenBalance = balanceOf(address(this));
258             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
259                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
260                 uint256 contractETHBalance = address(this).balance;
261                 if(contractETHBalance > 50000000000000000) {
262                     sendETHToFee(address(this).balance);
263                 }
264             }
265         }
266 
267         if(taxAmount>0){
268           _balances[address(this)]=_balances[address(this)].add(taxAmount);
269           emit Transfer(from, address(this),taxAmount);
270         }
271         _balances[from]=_balances[from].sub(amount);
272         _balances[to]=_balances[to].add(amount.sub(taxAmount));
273         emit Transfer(from, to, amount.sub(taxAmount));
274     }
275 
276 
277     function min(uint256 a, uint256 b) private pure returns (uint256){
278       return (a>b)?b:a;
279     }
280 
281     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
282         address[] memory path = new address[](2);
283         path[0] = address(this);
284         path[1] = uniswapV2Router.WETH();
285         _approve(address(this), address(uniswapV2Router), tokenAmount);
286         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
287             tokenAmount,
288             0,
289             path,
290             address(this),
291             block.timestamp
292         );
293     }
294 
295     function removeLimits() external onlyOwner{
296         _maxTxAmount = _tTotal;
297         _maxWalletSize=_tTotal;
298         transferDelayEnabled=false;
299         emit MaxTxAmountUpdated(_tTotal);
300     }
301 
302     function sendETHToFee(uint256 amount) private {
303         _taxWallet.transfer(amount);
304     }
305 
306 
307     function openTrading() external onlyOwner() {
308         require(!tradingOpen,"trading is already open");
309         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
310         _approve(address(this), address(uniswapV2Router), _tTotal);
311         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
312         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
313         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
314         swapEnabled = true;
315         tradingOpen = true;
316     }
317 
318     receive() external payable {}
319 
320     function manualSwap() external {
321         require(_msgSender()==_taxWallet);
322         uint256 tokenBalance=balanceOf(address(this));
323         if(tokenBalance>0){
324           swapTokensForEth(tokenBalance);
325         }
326         uint256 ethBalance=address(this).balance;
327         if(ethBalance>0){
328           sendETHToFee(ethBalance);
329         }
330     }
331 }