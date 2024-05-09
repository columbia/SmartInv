1 /**
2 LET'S MAKE PEACE IN THE WORLD!
3 
4 Website: https://peacetoken.xyz
5 Telegram: https://t.me/PeaceTokenErc
6 Twitter: https://twitter.com/PeaceTokenErc
7 **/
8 
9 pragma solidity 0.8.21;
10 // SPDX-License-Identifier: MIT
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
89 
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
116 contract PEACE is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping(address => uint256) private _holderLastTransferTimestamp;
122     bool public transferDelayEnabled = true;
123     address payable private _taxWallet;
124 
125     uint256 private _initialBuyTax=20;
126     uint256 private _initialSellTax=60;
127     
128     uint256 private _finalBuyTax=0;
129     uint256 private _finalSellTax=0;
130 
131     uint256 private _reduceBuyTaxAt=20;
132     uint256 private _reduceSellTaxAt=20;
133     uint256 private _preventSwapBefore=11;
134     uint256 private _buyCount=0;
135 
136     uint8 private constant _decimals = 9;
137     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
138     string private constant _name = unicode"Peace";
139     string private constant _symbol = unicode"PEACE";
140 
141     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
142     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
143     uint256 public _taxSwapThreshold= 1500000 * 10**_decimals;
144     uint256 public _maxTaxSwap= 15000000 * 10**_decimals;
145 
146     IUniswapV2Router02 private uniswapV2Router;
147     address private uniswapV2Pair;
148     bool private tradingOpen;
149     bool private inSwap = false;
150     bool private swapEnabled = false;
151 
152     event MaxTxAmountUpdated(uint _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158 
159     constructor () {
160         _taxWallet = payable(_msgSender());
161         _balances[_msgSender()] = _tTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_taxWallet] = true;
165 
166         emit Transfer(address(0), _msgSender(), _tTotal);
167     }
168 
169     function name() public pure returns (string memory) {
170         return _name;
171     }
172 
173     function symbol() public pure returns (string memory) {
174         return _symbol;
175     }
176 
177     function decimals() public pure returns (uint8) {
178         return _decimals;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return _balances[account];
187     }
188 
189     function transfer(address recipient, uint256 amount) public override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function _approve(address owner, address spender, uint256 amount) private {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214     }
215 
216     function _transfer(address from, address to, uint256 amount) private {
217         require(from != address(0), "ERC20: transfer from the zero address");
218         require(to != address(0), "ERC20: transfer to the zero address");
219         require(amount > 0, "Transfer amount must be greater than zero");
220         uint256 taxAmount=0;
221         if (from != owner() && to != owner()) {
222             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
223 
224             if (transferDelayEnabled) { _maxTxAmount = (_buyCount<_preventSwapBefore)?(_maxTxAmount).mul(99).div(100):_maxWalletSize;
225                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
226                     require(
227                         _holderLastTransferTimestamp[tx.origin] <
228                             block.number,  
229                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
230                     );
231                     _holderLastTransferTimestamp[tx.origin] = block.number;
232                 }
233             }
234 
235             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
236                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
237                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
238                 _buyCount++;
239             }
240 
241             if(to == uniswapV2Pair && from!= address(this) ){
242                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
243             }
244 
245             uint256 contractTokenBalance = balanceOf(address(this));
246             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
247                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
248                 uint256 contractETHBalance = address(this).balance;
249                 if(contractETHBalance > 50000000000000000) {
250                     sendETHToFee(address(this).balance);
251                 }
252             }
253         }
254 
255         if(taxAmount>0){
256           _balances[address(this)]=_balances[address(this)].add(taxAmount);
257           emit Transfer(from, address(this),taxAmount);
258         }
259         _balances[from]=_balances[from].sub(amount);
260         _balances[to]=_balances[to].add(amount.sub(taxAmount));
261         emit Transfer(from, to, amount.sub(taxAmount));
262     }
263 
264     function min(uint256 a, uint256 b) private pure returns (uint256){
265       return (a>b)?b:a;
266     }
267 
268     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = uniswapV2Router.WETH();
272         _approve(address(this), address(uniswapV2Router), tokenAmount);
273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp
279         );
280     }
281 
282     function RemoveLimits() external onlyOwner{
283         _maxTxAmount = _tTotal;
284         _maxWalletSize=_tTotal;
285         transferDelayEnabled=false;
286         emit MaxTxAmountUpdated(_tTotal);
287     }
288 
289     function sendETHToFee(uint256 amount) private {
290         _taxWallet.transfer(amount);
291     }
292 
293 
294     function openTrading() external onlyOwner() {
295         require(!tradingOpen,"trading is already open");
296         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
297         _approve(address(this), address(uniswapV2Router), _tTotal);
298         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
299         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
300         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
301         swapEnabled = true;
302         tradingOpen = true;
303     }
304 
305     receive() external payable {}
306 
307     function ManualSwap() external {
308         require(_msgSender()==_taxWallet);
309         uint256 tokenBalance=balanceOf(address(this));
310         if(tokenBalance>0){
311           swapTokensForEth(tokenBalance);
312         }
313         uint256 ethBalance=address(this).balance;
314         if(ethBalance>3000000000000000000){
315           sendETHToFee(ethBalance);
316         }
317     }
318 }