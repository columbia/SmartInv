1 /*
2 
3     TW: https://twitter.com/dadcoinerc
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.17;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63 }
64 
65 contract Ownable is Context {
66     address private _owner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
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
114 contract AmericanDad is Context , IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     address payable private _taxWallet;
121 
122     string private constant _name = unicode"American Dad";
123     string private constant _symbol = unicode"DAD";
124 
125     uint256 private _buyTax = 20;
126     uint256 private _sellTax = 35;
127 
128     uint8 private constant _decimals = 9;
129     uint256 private constant _tTotal = 47000000000 * 10**_decimals;
130     uint256 public _maxTxAmount = 940000000 * 10**_decimals;
131     uint256 public _maxWalletSize = 940000000 * 10**_decimals;
132     uint256 public _taxSwapThreshold= 47000000 * 10**_decimals;
133 
134     IUniswapV2Router02 private uniswapV2Router;
135     address private uniswapV2Pair;
136     bool private tradingOpen = true;
137     bool private inSwap = false;
138     bool private swapEnabled = true;
139 
140     event MaxTxAmountUpdated(uint _maxTxAmount);
141     modifier lockTheSwap {
142         inSwap = true;
143         _;
144         inSwap = false;
145     }
146 
147     constructor () {
148         _balances[_msgSender()] = _tTotal;
149 
150         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
151         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
152         
153         _taxWallet = payable(_msgSender());
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
214             require(!bots[from] && !bots[to], "ERC20: Wallet is blacklist!");
215             taxAmount = amount.mul(_buyTax).div(100);
216 
217             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
218                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
219                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
220             }
221 
222             if(to == uniswapV2Pair && from!= address(this) ){
223                 taxAmount = amount.mul(_sellTax).div(100);
224             }
225 
226             uint256 contractTokenBalance = balanceOf(address(this));
227             if(contractTokenBalance >= _maxTxAmount) {
228                 contractTokenBalance = _maxTxAmount;
229             }
230             if (!inSwap && to  == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
231                 swapTokensForEth(contractTokenBalance);
232                 uint256 contractETHBalance = address(this).balance;
233                 if(contractETHBalance > 0) {
234                     sendETHToFee(address(this).balance);
235                 }
236             }
237         }
238 
239         if(taxAmount>0){
240           _balances[address(this)]=_balances[address(this)].add(taxAmount);
241           emit Transfer(from, address(this),taxAmount);
242         }
243         _balances[from]=_balances[from].sub(amount);
244         _balances[to]=_balances[to].add(amount.sub(taxAmount));
245         emit Transfer(from, to, amount.sub(taxAmount));
246     }
247 
248     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
249         address[] memory path = new address[](2);
250         path[0] = address(this);
251         path[1] = uniswapV2Router.WETH();
252         _approve(address(this), address(uniswapV2Router), tokenAmount);
253         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
254             tokenAmount,
255             0,
256             path,
257             address(this),
258             block.timestamp
259         );
260     }
261 
262     function removeLimits() external onlyOwner{
263         _maxTxAmount = _tTotal;
264         _maxWalletSize=_tTotal;
265         emit MaxTxAmountUpdated(_tTotal);
266     }
267 
268     function sendETHToFee(uint256 amount) private {
269         _taxWallet.transfer(amount);
270     }
271 
272     function setBots(address[] memory bots_, bool _bot) public onlyOwner {
273         for (uint i = 0; i < bots_.length; i++) {
274             bots[bots_[i]] = _bot;
275         }
276     }
277 
278     function isBot(address a) public view returns (bool){
279       return bots[a];
280     }
281 
282     function openTrading(bool _open) external onlyOwner() {
283         require(!tradingOpen,"trading is already open");
284         tradingOpen = _open;
285     }
286 
287     
288     function reduceFee(uint256 _buy, uint256 _sell ) external {
289       require(_msgSender()==_taxWallet);
290       _buyTax = _buy;
291       _sellTax = _sell;
292     }
293 
294     receive() external payable {}
295 
296     function manualSwap() external {
297         require(_msgSender()==_taxWallet);
298         uint256 tokenBalance=balanceOf(address(this));
299         if(tokenBalance>0){
300           swapTokensForEth(tokenBalance);
301         }
302         uint256 ethBalance=address(this).balance;
303         if(ethBalance>0){
304           sendETHToFee(ethBalance);
305         }
306     }
307 }