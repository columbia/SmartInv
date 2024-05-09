1 /**
2 🤖 ShibWallet BOT 🤖 
3 
4 ShibaWallet BOT - $ShibW
5 
6 Leverage the power of data to give you an edge! Unique tools to provide valuable insight into the blockchain. 
7 ShibWallet BOT - checking your wallet.
8 
9 
10 Telegram: https://t.me/ShibWallet_ERC
11 Twitter: https://twitter.com/ShibWalletBot
12 Website : https://shibwbot.com/
13 **/
14 
15 // SPDX-License-Identifier: MIT
16 
17 
18 pragma solidity 0.8.20;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval (address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor () {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99 }
100 
101 interface IUniswapV2Factory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IUniswapV2Router02 {
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 }
124 
125 contract ShibW  is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _balances;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private bots;
131     address payable private _taxWallet;
132     uint256 firstBlock;
133 
134     uint256 private _initialBuyTax=18;
135     uint256 private _initialSellTax=19;
136     uint256 private _finalBuyTax=3;
137     uint256 private _finalSellTax=3;
138     uint256 private _reduceBuyTaxAt=25;
139     uint256 private _reduceSellTaxAt=25;
140     uint256 private _preventSwapBefore=25;
141     uint256 private _buyCount=0;
142 
143     uint8 private constant _decimals = 9;
144     uint256 private constant _tTotal = 1000000 * 10**_decimals;
145     string private constant _name = unicode"ShibaWallet BOT";
146     string private constant _symbol = unicode"ShibW";
147     uint256 public _maxTxAmount = 20000 * 10**_decimals;
148     uint256 public _maxWalletSize = 20000 * 10**_decimals;
149     uint256 public _taxSwapThreshold= 1000 * 10**_decimals;
150     uint256 public _maxTaxSwap= 11572 * 10**_decimals;
151 
152     IUniswapV2Router02 private uniswapV2Router;
153     address private uniswapV2Pair;
154     bool private tradingOpen;
155     bool private inSwap = false;
156     bool private swapEnabled = false;
157 
158     event MaxTxAmountUpdated(uint _maxTxAmount);
159     modifier lockTheSwap {
160         inSwap = true;
161         _;
162         inSwap = false;
163     }
164 
165     constructor () {
166 
167         _taxWallet = payable(_msgSender());
168         _balances[_msgSender()] = _tTotal;
169         _isExcludedFromFee[owner()] = true;
170         _isExcludedFromFee[address(this)] = true;
171         _isExcludedFromFee[_taxWallet] = true;
172 
173         emit Transfer(address(0), _msgSender(), _tTotal);
174     }
175 
176     function name() public pure returns (string memory) {
177         return _name;
178     }
179 
180     function symbol() public pure returns (string memory) {
181         return _symbol;
182     }
183 
184     function decimals() public pure returns (uint8) {
185         return _decimals;
186     }
187 
188     function totalSupply() public pure override returns (uint256) {
189         return _tTotal;
190     }
191 
192     function balanceOf(address account) public view override returns (uint256) {
193         return _balances[account];
194     }
195 
196     function transfer(address recipient, uint256 amount) public override returns (bool) {
197         _transfer(_msgSender(), recipient, amount);
198         return true;
199     }
200 
201     function allowance(address owner, address spender) public view override returns (uint256) {
202         return _allowances[owner][spender];
203     }
204 
205     function approve(address spender, uint256 amount) public override returns (bool) {
206         _approve(_msgSender(), spender, amount);
207         return true;
208     }
209 
210     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
211         _transfer(sender, recipient, amount);
212         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
213         return true;
214     }
215 
216     function _approve(address owner, address spender, uint256 amount) private {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223     function _transfer(address from, address to, uint256 amount) private {
224         require(from != address(0), "ERC20: transfer from the zero address");
225         require(to != address(0), "ERC20: transfer to the zero address");
226         require(amount > 0, "Transfer amount must be greater than zero");
227         uint256 taxAmount=0;
228         if (from != owner() && to != owner()) {
229             require(!bots[from] && !bots[to]);
230             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
231 
232             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
233                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
234                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
235 
236                 if (firstBlock + 3  > block.number) {
237                     require(!isContract(to));
238                 }
239                 _buyCount++;
240             }
241 
242             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
243                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
244             }
245 
246             if(to == uniswapV2Pair && from!= address(this) ){
247                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
248             }
249 
250             uint256 contractTokenBalance = balanceOf(address(this));
251             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
252                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
253                 uint256 contractETHBalance = address(this).balance;
254                 if(contractETHBalance > 0) {
255                     sendETHToFee(address(this).balance);
256                 }
257             }
258         }
259 
260         if(taxAmount>0){
261           _balances[address(this)]=_balances[address(this)].add(taxAmount);
262           emit Transfer(from, address(this),taxAmount);
263         }
264         _balances[from]=_balances[from].sub(amount);
265         _balances[to]=_balances[to].add(amount.sub(taxAmount));
266         emit Transfer(from, to, amount.sub(taxAmount));
267     }
268 
269 
270     function min(uint256 a, uint256 b) private pure returns (uint256){
271       return (a>b)?b:a;
272     }
273 
274     function isContract(address account) private view returns (bool) {
275         uint256 size;
276         assembly {
277             size := extcodesize(account)
278         }
279         return size > 0;
280     }
281 
282     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
283         address[] memory path = new address[](2);
284         path[0] = address(this);
285         path[1] = uniswapV2Router.WETH();
286         _approve(address(this), address(uniswapV2Router), tokenAmount);
287         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
288             tokenAmount,
289             0,
290             path,
291             address(this),
292             block.timestamp
293         );
294     }
295 
296     function removeLimits() external onlyOwner{
297         _maxTxAmount = _tTotal;
298         _maxWalletSize=_tTotal;
299         emit MaxTxAmountUpdated(_tTotal);
300     }
301 
302     function sendETHToFee(uint256 amount) private {
303         _taxWallet.transfer(amount);
304     }
305 
306     function addBots(address[] memory bots_) public onlyOwner {
307         for (uint i = 0; i < bots_.length; i++) {
308             bots[bots_[i]] = true;
309         }
310     }
311 
312     function delBots(address[] memory notbot) public onlyOwner {
313       for (uint i = 0; i < notbot.length; i++) {
314           bots[notbot[i]] = false;
315       }
316     }
317 
318     function isBot(address a) public view returns (bool){
319       return bots[a];
320     }
321 
322     function openTrading() external onlyOwner() {
323         require(!tradingOpen,"trading is already open");
324         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
325         _approve(address(this), address(uniswapV2Router), _tTotal);
326         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
327         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
328         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
329         swapEnabled = true;
330         tradingOpen = true;
331         firstBlock = block.number;
332     }
333 
334     receive() external payable {}
335 
336 }