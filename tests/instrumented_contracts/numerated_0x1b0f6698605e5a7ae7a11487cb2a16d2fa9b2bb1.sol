1 /**
2 */
3 
4 // SPDX-License-Identifier: MIT
5 
6 /**
7 
8 ERMAHGERD
9 
10 
11 TERLERGRERM: https://t.me/ermahgerdvip
12 WERBSERT: https://ermahgerd.vip/
13 TWERTER: https://twitter.com/ermahgerdvip
14 TRERNSLERTER: https://ermahgerd.jmillerdesign.com/#!/translate
15 
16 https://knowyourmeme.com/memes/ermahgerd
17 
18 */
19 
20 
21 pragma solidity 0.8.20;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         return c;
74     }
75 
76 }
77 
78 contract Ownable is Context {
79     address private _owner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 interface IUniswapV2Router02 {
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118     function addLiquidityETH(
119         address token,
120         uint amountTokenDesired,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
126 }
127 
128 contract ERMAHGERD is Context, IERC20, Ownable {
129     using SafeMath for uint256;
130     mapping (address => uint256) private _balances;
131     mapping (address => mapping (address => uint256)) private _allowances;
132     mapping (address => bool) private _isExcludedFromFee;
133     address payable private _taxWallet;
134     uint256 firstBlock;
135 
136     uint256 private _initialBuyTax=20;
137     uint256 private _initialSellTax=20;
138     uint256 private _finalBuyTax=1;
139     uint256 private _finalSellTax=1;
140     uint256 private _reduceBuyTaxAt=20;
141     uint256 private _reduceSellTaxAt=20;
142     uint256 private _preventSwapBefore=20;
143     uint256 private _buyCount=0;
144 
145     uint8 private constant _decimals = 9;
146     uint256 private constant _tTotal = 69420000 * 10**_decimals;
147     string private constant _name = unicode"ERMAHGERD";
148     string private constant _symbol = unicode"ERMAHGERD";
149     uint256 public _maxTxAmount =   694200 * 10**_decimals;
150     uint256 public _maxWalletSize = 694200 * 10**_decimals;
151     uint256 public _taxSwapThreshold= 694200 * 10**_decimals;
152     uint256 public _maxTaxSwap= 694200 * 10**_decimals;
153 
154     IUniswapV2Router02 private uniswapV2Router;
155     address private uniswapV2Pair;
156     bool private tradingOpen;
157     bool private inSwap = false;
158     bool private swapEnabled = false;
159 
160     event MaxTxAmountUpdated(uint _maxTxAmount);
161     modifier lockTheSwap {
162         inSwap = true;
163         _;
164         inSwap = false;
165     }
166 
167     constructor () {
168 
169         _taxWallet = payable(_msgSender());
170         _balances[_msgSender()] = _tTotal;
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[_taxWallet] = true;
174         
175         emit Transfer(address(0), _msgSender(), _tTotal);
176     }
177 
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185 
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189 
190     function totalSupply() public pure override returns (uint256) {
191         return _tTotal;
192     }
193 
194     function balanceOf(address account) public view override returns (uint256) {
195         return _balances[account];
196     }
197 
198     function transfer(address recipient, uint256 amount) public override returns (bool) {
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     function allowance(address owner, address spender) public view override returns (uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount) public override returns (bool) {
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
215         return true;
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229         uint256 taxAmount=0;
230         if (from != owner() && to != owner()) {
231             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
232 
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
234                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
235                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
236 
237                 if (firstBlock + 3  > block.number) {
238                     require(!isContract(to));
239                 }
240                 _buyCount++;
241             }
242 
243             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
244                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
245             }
246 
247             if(to == uniswapV2Pair && from!= address(this) ){
248                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
249             }
250 
251             uint256 contractTokenBalance = balanceOf(address(this));
252             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
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
275     function isContract(address account) private view returns (bool) {
276         uint256 size;
277         assembly {
278             size := extcodesize(account)
279         }
280         return size > 0;
281     }
282 
283     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
284         address[] memory path = new address[](2);
285         path[0] = address(this);
286         path[1] = uniswapV2Router.WETH();
287         _approve(address(this), address(uniswapV2Router), tokenAmount);
288         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
289             tokenAmount,
290             0,
291             path,
292             address(this),
293             block.timestamp
294         );
295     }
296 
297     function removeLimits() external onlyOwner{
298         _maxTxAmount = _tTotal;
299         _maxWalletSize=_tTotal;
300         emit MaxTxAmountUpdated(_tTotal);
301     }
302 
303     function sendETHToFee(uint256 amount) private {
304         _taxWallet.transfer(amount);
305     }
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
316         firstBlock = block.number;
317     }
318 
319     receive() external payable {}
320 }