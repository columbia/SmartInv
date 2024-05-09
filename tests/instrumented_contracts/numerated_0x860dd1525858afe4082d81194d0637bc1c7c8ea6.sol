1 // SPDX-License-Identifier: MIT
2 
3 /**
4 Ripple, the renowned crypto company associated with $XRP, has won a legal battle against the SEC, igniting celebration and optimism in the cryptocurrency community. 
5 Ripple represents resilience and innovation in cryptocurrencies, challenging the status quo and revolutionizing digital transactions.
6 As Ripple's memecoin value soared, its community grew stronger, united by their belief in blockchain technology and anticipation of faster, more secure, and accessible financial transactions.
7 Ripple's story showcases the power of decentralized networks to reshape the world, symbolizing hope for a more inclusive and transparent financial system.
8 
9 
10 
11 
12 Twitter: https://x.com/ripplexrp_erc20
13 Telegram: https://t.me/RippleXRP_ERC20
14 Website: ripplexrperc20.com
15 
16 
17 
18 **/
19 
20 pragma solidity 0.8.20;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
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
128 contract ripple is Context, IERC20, Ownable {
129     using SafeMath for uint256;
130     mapping (address => uint256) private _balances;
131     mapping (address => mapping (address => uint256)) private _allowances;
132     mapping (address => bool) private _isExcludedFromFee;
133     mapping (address => bool) private bots;
134     mapping(address => uint256) private _holderLastTransferTimestamp;
135     bool public transferDelayEnabled = true;
136     address payable private _taxWallet;
137 
138     uint256 private _initialBuyTax=15;
139     uint256 private _initialSellTax=29;
140     uint256 private _finalBuyTax=0;
141     uint256 private _finalSellTax=1;
142     uint256 private _reduceBuyTaxAt=39;
143     uint256 private _reduceSellTaxAt=29;
144     uint256 private _preventSwapBefore=15;
145     uint256 private _buyCount=0;
146 
147     uint8 private constant _decimals = 9;
148     uint256 private constant _tTotal = 100000000 * 10**_decimals;
149     string private constant _name = unicode"Ripple";
150     string private constant _symbol = unicode"XRP";
151     uint256 public _maxTxAmount = 800000 * 10**_decimals;
152     uint256 public _maxWalletSize = 1500000 * 10**_decimals;
153     uint256 public _taxSwapThreshold= 500000 * 10**_decimals;
154     uint256 public _maxTaxSwap= 500000 * 10**_decimals;
155 
156     IUniswapV2Router02 private uniswapV2Router;
157     address private uniswapV2Pair;
158     bool private tradingOpen;
159     bool private inSwap = false;
160     bool private swapEnabled = false;
161 
162     event MaxTxAmountUpdated(uint _maxTxAmount);
163     modifier lockTheSwap {
164         inSwap = true;
165         _;
166         inSwap = false;
167     }
168 
169     constructor () {
170         _taxWallet = payable(_msgSender());
171         _balances[_msgSender()] = _tTotal;
172         _isExcludedFromFee[owner()] = true;
173         _isExcludedFromFee[address(this)] = true;
174         _isExcludedFromFee[_taxWallet] = true;
175 
176         emit Transfer(address(0), _msgSender(), _tTotal);
177     }
178 
179     function name() public pure returns (string memory) {
180         return _name;
181     }
182 
183     function symbol() public pure returns (string memory) {
184         return _symbol;
185     }
186 
187     function decimals() public pure returns (uint8) {
188         return _decimals;
189     }
190 
191     function totalSupply() public pure override returns (uint256) {
192         return _tTotal;
193     }
194 
195     function balanceOf(address account) public view override returns (uint256) {
196         return _balances[account];
197     }
198 
199     function transfer(address recipient, uint256 amount) public override returns (bool) {
200         _transfer(_msgSender(), recipient, amount);
201         return true;
202     }
203 
204     function openTrading() external onlyOwner() {
205         require(!tradingOpen,"trading is already open");
206         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
207         _approve(address(this), address(uniswapV2Router), _tTotal);
208         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
209         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
210         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
211         swapEnabled = true;
212         tradingOpen = true;
213     }
214 
215     function allowance(address owner, address spender) public view override returns (uint256) {
216         return _allowances[owner][spender];
217     }
218 
219     function approve(address spender, uint256 amount) public override returns (bool) {
220         _approve(_msgSender(), spender, amount);
221         return true;
222     }
223 
224     
225 
226     function _approve(address owner, address spender, uint256 amount) private {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 
233     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
234         _transfer(sender, recipient, amount);
235         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
236         return true;
237     }
238 
239     function _transfer(address from, address to, uint256 amount) private {
240         require(from != address(0), "ERC20: transfer from the zero address");
241         require(to != address(0), "ERC20: transfer to the zero address");
242         require(amount > 0, "Transfer amount must be greater than zero");
243         uint256 taxAmount=0;
244         if (from != owner() && to != owner()) {
245             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
246 
247             if (transferDelayEnabled) {
248                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
249                       require(
250                           _holderLastTransferTimestamp[tx.origin] <
251                               block.number,
252                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
253                       );
254                       _holderLastTransferTimestamp[tx.origin] = block.number;
255                   }
256               }
257 
258             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
259                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
260                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
261                 _buyCount++;
262             }
263 
264             if(to == uniswapV2Pair && from!= address(this) ){
265                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
266             }
267 
268             uint256 contractTokenBalance = balanceOf(address(this));
269             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
270                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
271                 uint256 contractETHBalance = address(this).balance;
272                 if(contractETHBalance > 50000000000000000) {
273                     sendETHToFee(address(this).balance);
274                 }
275             }
276         }
277 
278         if(taxAmount>0){
279           _balances[address(this)]=_balances[address(this)].add(taxAmount);
280           emit Transfer(from, address(this),taxAmount);
281         }
282         _balances[from]=_balances[from].sub(amount);
283         _balances[to]=_balances[to].add(amount.sub(taxAmount));
284         emit Transfer(from, to, amount.sub(taxAmount));
285     }
286 
287 
288     function min(uint256 a, uint256 b) private pure returns (uint256){
289       return (a>b)?b:a;
290     }
291 
292    
293 
294     function removeLimits() external onlyOwner{
295         _maxTxAmount = _tTotal;
296         _maxWalletSize=_tTotal;
297         transferDelayEnabled=false;
298         emit MaxTxAmountUpdated(_tTotal);
299     }
300     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
301         address[] memory path = new address[](2);
302         path[0] = address(this);
303         path[1] = uniswapV2Router.WETH();
304         _approve(address(this), address(uniswapV2Router), tokenAmount);
305         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
306             tokenAmount,
307             0,
308             path,
309             address(this),
310             block.timestamp
311         );
312     }
313     function sendETHToFee(uint256 amount) private {
314         _taxWallet.transfer(amount);
315     }
316 
317 
318     receive() external payable {}
319 
320     function Ripple() external {
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