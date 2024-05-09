1 /*
2 
3 🌀 $MIKUSU - Mixer 🌀
4 
5 Mikusu is a revolutionary cryptocurrency mixer that helps you mix funds quickly with low fees via our TG bot in order to retain or regain your anonymity on the blockchain.
6 
7 https://mikusu.pro/
8 https://t.me/MikusuMixer
9 https://twitter.com/mikusumixer
10 https://medium.com/@mikusumixer
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
122 contract MIKUSU is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping (address => uint256) private _balances;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     address payable private _marketingWallet;
128 
129     string private constant _name =    unicode"Mixer";
130     string private constant _symbol =  unicode"MIKUSU";
131     uint8 private constant _decimals = 18;
132     uint256 private constant _tTotal = 1 * 1e6 * 10**_decimals;
133     uint256 private _initialBuyTax=    25;
134     uint256 private _reduceBuyTaxAt=   1;
135     uint256 private _BuyTax=           2;
136     uint256 private _SellTax=          25;
137     uint256 private _noSwapBefore=     35;
138     uint256 private _buyCount=         0;
139     uint256 public _maxTxAmount =      _tTotal * 1 / 100;
140     uint256 public _maxWalletSize =    _tTotal * 2 / 100;
141     uint256 public _taxSwapThreshold=  _tTotal * 5 / 10000;
142     uint256 public _maxTaxSwap=        _tTotal * 1 / 100;
143 
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private inSwap = false;
148     bool private swapEnabled = false;
149 
150     event MaxTxAmountUpdated(uint _maxTxAmount);
151     modifier lockTheSwap {
152         inSwap = true;
153         _;
154         inSwap = false;
155     }
156 
157     constructor () {
158         _marketingWallet = payable(_msgSender());
159         _balances[_msgSender()] = _tTotal;
160         _isExcludedFromFee[owner()] = true;
161         _isExcludedFromFee[address(this)] = true;
162         _isExcludedFromFee[_marketingWallet] = true;
163 
164         emit Transfer(address(0), _msgSender(), _tTotal);
165     }
166 
167     function name() public pure returns (string memory) {
168         return _name;
169     }
170 
171     function symbol() public pure returns (string memory) {
172         return _symbol;
173     }
174 
175     function decimals() public pure returns (uint8) {
176         return _decimals;
177     }
178 
179     function buyTax() public view returns (uint256) {
180         return _BuyTax;
181     }
182 
183     function sellTax() public view returns (uint256) {
184         return _SellTax;
185     }
186 
187     function buyCount() public view returns (uint256) {
188         return _buyCount;
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
204     function allowance(address owner, address spender) public view override returns (uint256) {
205         return _allowances[owner][spender];
206     }
207 
208     function approve(address spender, uint256 amount) public override returns (bool) {
209         _approve(_msgSender(), spender, amount);
210         return true;
211     }
212 
213     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
214         _transfer(sender, recipient, amount);
215         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
216         return true;
217     }
218 
219     function _approve(address owner, address spender, uint256 amount) private {
220         require(owner != address(0), "ERC20: approve from the zero address");
221         require(spender != address(0), "ERC20: approve to the zero address");
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 
226     function _transfer(address from, address to, uint256 amount) private {
227         require(from != address(0), "ERC20: transfer from the zero address");
228         require(to != address(0), "ERC20: transfer to the zero address");
229         require(amount > 0, "Transfer amount must be greater than zero");
230         uint256 taxAmount=0;
231         if (from != owner() && to != owner() && from != _marketingWallet && to != _marketingWallet) {
232 
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
234                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
235                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the _maxWalletSize.");
236                 _buyCount++;
237             }
238 
239             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_BuyTax:_initialBuyTax).div(100);        
240             if(to == uniswapV2Pair && from!= address(this)){
241                 taxAmount = amount.mul(_SellTax).div(100);
242             }
243 
244             uint256 contractTokenBalance = balanceOf(address(this));
245             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_noSwapBefore) {
246                 uint256 amountToSwap = (amount < contractTokenBalance && amount < _maxTaxSwap) ? amount : (contractTokenBalance < _maxTaxSwap) ? contractTokenBalance : _maxTaxSwap;
247                 swapTokensForEth(amountToSwap);
248                 uint256 contractETHBalance = address(this).balance;
249                 if(contractETHBalance > 0) {
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
264     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
265         if(tokenAmount==0){return;}
266         if(!tradingOpen){return;}
267         address[] memory path = new address[](2);
268         path[0] = address(this);
269         path[1] = uniswapV2Router.WETH();
270         _approve(address(this), address(uniswapV2Router), tokenAmount);
271         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
272             tokenAmount,
273             0,
274             path,
275             address(this),
276             block.timestamp
277         );
278     }
279 
280     function removeLimits() external onlyOwner{
281         _maxTxAmount = _tTotal;
282         _maxWalletSize=_tTotal;
283         emit MaxTxAmountUpdated(_tTotal);
284     }
285 
286     function sendETHToFee(uint256 amount) private {
287         _marketingWallet.transfer(amount);
288     }
289 
290     function openTrading() external onlyOwner() {
291         require(!tradingOpen,"trading is already open");
292         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
293         _approve(address(this), address(uniswapV2Router), _tTotal);
294         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
295         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
296         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
297         swapEnabled = true;
298         tradingOpen = true;
299     }
300 
301     receive() external payable {}
302 
303     function manualSwap() external onlyOwner {
304         uint256 tokenBalance=balanceOf(address(this));
305         if(tokenBalance>0){
306           swapTokensForEth(tokenBalance);
307         }
308         uint256 ethBalance=address(this).balance;
309         if(ethBalance>0){
310           sendETHToFee(ethBalance);
311         }
312     }
313 
314     function updateBuyTax(uint256 BuyTax) external onlyOwner {
315         _BuyTax = BuyTax; 
316     }
317 
318     function updateSellTax(uint256 SellTax) external onlyOwner {
319         _SellTax = SellTax; 
320     }
321   
322 }