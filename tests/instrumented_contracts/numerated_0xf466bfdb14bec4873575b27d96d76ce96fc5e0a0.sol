1 /*
2 
3 DegenBook 📓
4 
5 $DEBOOK | Explore insights on degens, devs, influencers, and more. Use our unique peer-to-peer voting and submission system for the latest trustworthy data.
6 
7 Bot:
8 https://t.me/DegenBookBot
9 
10 Socials:
11 Twitter: https://twitter.com/DegenBook
12 Telegram: https://t.me/degenbook
13 Medium: https://medium.com/@DegenBook
14 Website: https://degenbook.io/
15 GitBook: https://degenbook.gitbook.io
16 Email: degenbook@outlook.com
17 
18 */
19 
20 // SPDX-License-Identifier: MIT
21 pragma solidity 0.8.19;
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
61 interface IERC20 {
62     function totalSupply() external view returns (uint256);
63     function balanceOf(address account) external view returns (uint256);
64     function transfer(address recipient, uint256 amount) external returns (bool);
65     function allowance(address owner, address spender) external view returns (uint256);
66     function approve(address spender, uint256 amount) external returns (bool);
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 interface IUniswapV2Factory {
73     function createPair(address tokenA, address tokenB) external returns (address pair);
74 }
75 
76 interface IUniswapV2Router02 {
77     function swapExactTokensForETHSupportingFeeOnTransferTokens(
78         uint amountIn,
79         uint amountOutMin,
80         address[] calldata path,
81         address to,
82         uint deadline
83     ) external;
84     function factory() external pure returns (address);
85     function WETH() external pure returns (address);
86     function addLiquidityETH(
87         address token,
88         uint amountTokenDesired,
89         uint amountTokenMin,
90         uint amountETHMin,
91         address to,
92         uint deadline
93     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
94 }
95 
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 }
101 
102 contract Ownable is Context {
103     address private _owner;
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     constructor () {
107         address msgSender = _msgSender();
108         _owner = msgSender;
109         emit OwnershipTransferred(address(0), msgSender);
110     }
111 
112     function owner() public view returns (address) {
113         return _owner;
114     }
115 
116     modifier onlyOwner() {
117         require(_owner == _msgSender(), "Ownable: caller is not the owner");
118         _;
119     }
120 
121     function renounceOwnership() public virtual onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 
126 }
127 
128 contract DEBOOK is Context, IERC20, Ownable {
129     using SafeMath for uint256;
130     mapping (address => uint256) private _balances;
131     mapping (address => mapping (address => uint256)) private _allowances;
132     mapping (address => bool) private _isExcludedFromFee;
133     address payable private _taxWallet;
134 
135     string private constant _name =    unicode"DegenBook";
136     string private constant _symbol =  unicode"DEBOOK";
137     uint8 private constant _decimals = 9;
138     uint256 private constant _tTotal = 1 * 1e5 * 10**_decimals;
139     uint256 private _initialBuyFee=    30;
140     uint256 private _reduceBuyFeeAt=   1;
141     uint256 private _BuyFee=           5;
142     uint256 private _SellFee=          45;
143     uint256 private _noSwapBefore=     45;
144     uint256 private _buyCount=         0;
145     uint256 public _maxTxAmount =      _tTotal * 1 / 100;
146     uint256 public _maxWalletSize =    _tTotal * 2 / 100;
147     uint256 public _maxFeeSwap=        _tTotal * 1 / 100;
148     uint256 public _feeSwapThreshold=  _tTotal * 5 / 10000;
149 
150     IUniswapV2Router02 private uniswapV2Router;
151     address private uniswapV2Pair;
152     bool private tradingOpen;
153     bool private inSwap = false;
154     bool private swapEnabled = false;
155 
156     event MaxTxAmountUpdated(uint _maxTxAmount);
157     modifier lockTheSwap {
158         inSwap = true;
159         _;
160         inSwap = false;
161     }
162 
163     constructor () {
164         _taxWallet = payable(_msgSender());
165         _balances[_msgSender()] = _tTotal;
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[_taxWallet] = true;
169 
170         emit Transfer(address(0), _msgSender(), _tTotal);
171     }
172 
173     function name() public pure returns (string memory) {
174         return _name;
175     }
176 
177     function symbol() public pure returns (string memory) {
178         return _symbol;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function buyCount() public view returns (uint256) {
190         return _buyCount;
191     }
192 
193     function buyFee() public view returns (uint256) {
194         return _BuyFee;
195     }
196 
197     function sellFee() public view returns (uint256) {
198         return _SellFee;
199     }
200 
201     function balanceOf(address account) public view override returns (uint256) {
202         return _balances[account];
203     }
204 
205     function transfer(address recipient, uint256 amount) public override returns (bool) {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     function allowance(address owner, address spender) public view override returns (uint256) {
211         return _allowances[owner][spender];
212     }
213 
214     function approve(address spender, uint256 amount) public override returns (bool) {
215         _approve(_msgSender(), spender, amount);
216         return true;
217     }
218 
219     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
220         _transfer(sender, recipient, amount);
221         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
222         return true;
223     }
224 
225     function _approve(address owner, address spender, uint256 amount) private {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232     function _transfer(address from, address to, uint256 amount) private {
233         require(to != address(0), "ERC20: transfer to the zero address");
234         require(from != address(0), "ERC20: transfer from the zero address");
235         require(amount > 0, "Transfer amount must be greater than zero");
236         uint256 feeAmount=0;
237         if (from != owner() && to != owner() && from != _taxWallet && to != _taxWallet) {
238 
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
240                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
241                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the _maxWalletSize.");
242                 _buyCount++;
243             }
244 
245             feeAmount = amount.mul((_buyCount>_reduceBuyFeeAt)?_BuyFee:_initialBuyFee).div(100);        
246             if(to == uniswapV2Pair && from!= address(this)){
247                 feeAmount = amount.mul(_SellFee).div(100);
248             }
249 
250             uint256 contractTokenBalance = balanceOf(address(this));
251             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_feeSwapThreshold && _buyCount>_noSwapBefore) {
252                 uint256 amountToSwap = (amount < contractTokenBalance && amount < _maxFeeSwap) ? amount : (contractTokenBalance < _maxFeeSwap) ? contractTokenBalance : _maxFeeSwap;
253                 swapTokensForEth(amountToSwap);
254                 uint256 contractETHBalance = address(this).balance;
255                 if(contractETHBalance > 0) {
256                     sendETHToFee(address(this).balance);
257                 }
258             }
259         }
260 
261         if(feeAmount>0){
262           _balances[address(this)]=_balances[address(this)].add(feeAmount);
263           emit Transfer(from, address(this),feeAmount);
264         }
265         _balances[from]=_balances[from].sub(amount);
266         _balances[to]=_balances[to].add(amount.sub(feeAmount));
267         emit Transfer(from, to, amount.sub(feeAmount));
268     }
269 
270     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
271         if(tokenAmount==0){return;}
272         if(!tradingOpen){return;}
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = uniswapV2Router.WETH();
276         _approve(address(this), address(uniswapV2Router), tokenAmount);
277         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
278             tokenAmount,
279             0,
280             path,
281             address(this),
282             block.timestamp
283         );
284     }
285 
286     function sendETHToFee(uint256 amount) private {
287         _taxWallet.transfer(amount);
288     }
289 
290     function removeLimits() external onlyOwner{
291         _maxTxAmount = _tTotal;
292         _maxWalletSize=_tTotal;
293         emit MaxTxAmountUpdated(_tTotal);
294     }
295     
296     function updateBuyFee(uint256 BuyFee) external onlyOwner {
297         _BuyFee = BuyFee; 
298     }
299 
300     function updateSellFee(uint256 SellFee) external onlyOwner {
301         _SellFee = SellFee; 
302     }
303 
304     function openDegenBook() external onlyOwner() {
305         require(!tradingOpen,"trading is already open");
306         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
307         _approve(address(this), address(uniswapV2Router), _tTotal);
308         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
309         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
310         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
311         swapEnabled = true;
312         tradingOpen = true;
313     }
314 
315     function manualSwap() external onlyOwner {
316         uint256 tokenBalance=balanceOf(address(this));
317         if(tokenBalance>0){
318           swapTokensForEth(tokenBalance);
319         }
320         uint256 ethBalance=address(this).balance;
321         if(ethBalance>0){
322           sendETHToFee(ethBalance);
323         }
324     }
325 
326     receive() external payable {}
327   
328 }