1 /*
2 
3 Cerberus AI - $CAI
4 
5 CAI is our in-house Telegram bot that leverages true state-of-the-art AI (Artificial Intelligence) in order to safeguard chats from various attacks.
6 
7 https://cerberusai.tech
8 https://twitter.com/cerberusaierc20
9 https://medium.com/@cerberusaierc20
10 https://t.me/CerberusAIBot
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 pragma solidity 0.8.20;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44 
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         return div(a, b, "SafeMath: division by zero");
62     }
63 
64     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         return c;
68     }
69 
70 }
71 
72 contract Ownable is Context {
73     address private _owner;
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     constructor () {
77         address msgSender = _msgSender();
78         _owner = msgSender;
79         emit OwnershipTransferred(address(0), msgSender);
80     }
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     function renounceOwnership() public virtual onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95 
96 }
97 
98 interface IUniswapV2Factory {
99     function createPair(address tokenA, address tokenB) external returns (address pair);
100 }
101 
102 interface IUniswapV2Router02 {
103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external;
110     function factory() external pure returns (address);
111     function WETH() external pure returns (address);
112     function addLiquidityETH(
113         address token,
114         uint amountTokenDesired,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
120 }
121 
122 contract CAI is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping (address => uint256) private _balances;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     address payable private _marketingWallet;
128 
129     string private constant _name =    unicode"Cerberus AI";
130     string private constant _symbol =  unicode"CAI";
131     uint8 private constant _decimals = 18;
132     uint256 private constant _tTotal = 1 * 1e5 * 10**_decimals;
133     uint256 private _BuyTax=           25;
134     uint256 private _SellTax=          25;
135     uint256 private _noSwapBefore=     20;
136     uint256 private _buyCount=         0;
137     uint256 public _maxTxAmount =      _tTotal * 1 / 100;
138     uint256 public _maxWalletSize =    _tTotal * 2 / 100;
139     uint256 public _taxSwapThreshold=  _tTotal * 5 / 10000;
140     uint256 public _maxTaxSwap=        _tTotal * 1 / 100;
141 
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147 
148     event MaxTxAmountUpdated(uint _maxTxAmount);
149     modifier lockTheSwap {
150         inSwap = true;
151         _;
152         inSwap = false;
153     }
154 
155     constructor () {
156         _marketingWallet = payable(_msgSender());
157         _balances[_msgSender()] = _tTotal;
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[_marketingWallet] = true;
161 
162         emit Transfer(address(0), _msgSender(), _tTotal);
163     }
164 
165     function name() public pure returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public pure returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public pure returns (uint8) {
174         return _decimals;
175     }
176 
177     function buyTax() public view returns (uint256) {
178         return _BuyTax;
179     }
180 
181     function sellTax() public view returns (uint256) {
182         return _SellTax;
183     }
184 
185     function buyCount() public view returns (uint256) {
186         return _buyCount;
187     }
188 
189     function totalSupply() public pure override returns (uint256) {
190         return _tTotal;
191     }
192 
193     function balanceOf(address account) public view override returns (uint256) {
194         return _balances[account];
195     }
196 
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
214         return true;
215     }
216 
217     function _approve(address owner, address spender, uint256 amount) private {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function _transfer(address from, address to, uint256 amount) private {
225         require(from != address(0), "ERC20: transfer from the zero address");
226         require(to != address(0), "ERC20: transfer to the zero address");
227         require(amount > 0, "Transfer amount must be greater than zero");
228         uint256 taxAmount=0;
229         if (from != owner() && to != owner() && from != _marketingWallet && to != _marketingWallet) {
230 
231             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
232                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
233                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the _maxWalletSize.");
234                 _buyCount++;
235             }
236 
237             taxAmount = amount.mul(_BuyTax).div(100);            
238             if(to == uniswapV2Pair && from!= address(this)){
239                 taxAmount = amount.mul(_SellTax).div(100);
240             }
241 
242             uint256 contractTokenBalance = balanceOf(address(this));
243             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_noSwapBefore) {
244                 uint256 amountToSwap = (amount < contractTokenBalance && amount < _maxTaxSwap) ? amount : (contractTokenBalance < _maxTaxSwap) ? contractTokenBalance : _maxTaxSwap;
245                 swapTokensForEth(amountToSwap);
246                 uint256 contractETHBalance = address(this).balance;
247                 if(contractETHBalance > 0) {
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
262     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
263         if(tokenAmount==0){return;}
264         if(!tradingOpen){return;}
265         address[] memory path = new address[](2);
266         path[0] = address(this);
267         path[1] = uniswapV2Router.WETH();
268         _approve(address(this), address(uniswapV2Router), tokenAmount);
269         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
270             tokenAmount,
271             0,
272             path,
273             address(this),
274             block.timestamp
275         );
276     }
277 
278     function removeLimits() external onlyOwner{
279         _maxTxAmount = _tTotal;
280         _maxWalletSize=_tTotal;
281         emit MaxTxAmountUpdated(_tTotal);
282     }
283 
284     function sendETHToFee(uint256 amount) private {
285         _marketingWallet.transfer(amount);
286     }
287 
288     function openTrading() external onlyOwner() {
289         require(!tradingOpen,"trading is already open");
290         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
291         _approve(address(this), address(uniswapV2Router), _tTotal);
292         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
293         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
294         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
295         swapEnabled = true;
296         tradingOpen = true;
297     }
298 
299     receive() external payable {}
300 
301     function manualSwap() external onlyOwner {
302         uint256 tokenBalance=balanceOf(address(this));
303         if(tokenBalance>0){
304           swapTokensForEth(tokenBalance);
305         }
306         uint256 ethBalance=address(this).balance;
307         if(ethBalance>0){
308           sendETHToFee(ethBalance);
309         }
310     }
311 
312     function updateTax(uint256 BuyTax, uint256 SellTax) external onlyOwner {
313         _BuyTax = BuyTax;
314         _SellTax= SellTax; 
315     }
316   
317 }