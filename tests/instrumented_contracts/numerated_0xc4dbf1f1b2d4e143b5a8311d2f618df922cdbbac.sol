1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 Website: https://devilpepe.vip/
6 Twitter: https://Twitter.com/Devil_Pepe
7 Telegram: t.me/devilpepeJOIN
8 
9 
10 */
11 
12 
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
120 contract DEVILPEPE is Context, IERC20, Ownable {
121     using SafeMath for uint256;
122     mapping (address => uint256) private _balances;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     address payable private _taxWallet;
126     uint256 firstBlock;
127 
128     uint256 private _initialBuyTax=35;
129     uint256 private _initialSellTax=35;
130     uint256 private _finalBuyTax=2;
131     uint256 private _finalSellTax=2;
132     uint256 private _reduceBuyTaxAt=50;
133     uint256 private _reduceSellTaxAt=50;
134     uint256 private _buyCount=0;
135 
136     uint8 private constant _decimals = 9;
137     uint256 private constant _tTotal = 1000000 * 10**_decimals;
138     string private constant _name = unicode"Devil Pepe";
139     string private constant _symbol = unicode"DEVPEPE";
140     uint256 public _maxTxAmount =   10000 * 10**_decimals;
141     uint256 public _maxWalletSize = 10000 * 10**_decimals;
142     uint256 public _taxSwapThreshold= 5000 * 10**_decimals;
143     uint256 public _maxTaxSwap= 5000 * 10**_decimals;
144 
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
147     bool private tradingOpen;
148     bool private inSwap = false;
149     bool private swapEnabled = false;
150 
151     event MaxTxAmountUpdated(uint _maxTxAmount);
152     modifier lockTheSwap {
153         inSwap = true;
154         _;
155         inSwap = false;
156     }
157 
158     constructor () {
159 
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
224             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
225                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
226                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
227 
228                 if (firstBlock + 3  > block.number) {
229                     require(!isContract(to));
230                 }
231                 _buyCount++;
232             }
233 
234             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
235                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
236             }
237 
238             if(to == uniswapV2Pair && from!= address(this) ){
239                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
240             }
241 
242             uint256 contractTokenBalance = balanceOf(address(this));
243             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
244                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
245                 uint256 contractETHBalance = address(this).balance;
246                 if(contractETHBalance > 0) {
247                     sendETHToFee(address(this).balance);
248                 }
249             }
250         }
251 
252         if(taxAmount>0){
253           _balances[address(this)]=_balances[address(this)].add(taxAmount);
254           emit Transfer(from, address(this),taxAmount);
255         }
256         _balances[from]=_balances[from].sub(amount);
257         _balances[to]=_balances[to].add(amount.sub(taxAmount));
258         emit Transfer(from, to, amount.sub(taxAmount));
259     }
260 
261 
262     function min(uint256 a, uint256 b) private pure returns (uint256){
263       return (a>b)?b:a;
264     }
265 
266     function isContract(address account) private view returns (bool) {
267         uint256 size;
268         assembly {
269             size := extcodesize(account)
270         }
271         return size > 0;
272     }
273 
274     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
275         address[] memory path = new address[](2);
276         path[0] = address(this);
277         path[1] = uniswapV2Router.WETH();
278         _approve(address(this), address(uniswapV2Router), tokenAmount);
279         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
280             tokenAmount,
281             0,
282             path,
283             address(this),
284             block.timestamp
285         );
286     }
287 
288     function removeLimits() external onlyOwner{
289         _maxTxAmount = _tTotal;
290         _maxWalletSize=_tTotal;
291         emit MaxTxAmountUpdated(_tTotal);
292     }
293 
294     function sendETHToFee(uint256 amount) private {
295         _taxWallet.transfer(amount);
296     }
297 
298     function openTrading() external onlyOwner() {
299         require(!tradingOpen,"trading is already open");
300         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
301         _approve(address(this), address(uniswapV2Router), _tTotal);
302         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
303         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
304         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
305         swapEnabled = true;
306         tradingOpen = true;
307         firstBlock = block.number;
308     }
309 
310     receive() external payable {}
311 }