1 /*
2 
3 https://t.me/KeyContest
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.20;
10 
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
25     event Approval (address indexed owner, address indexed spender, uint256 value);
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
116 contract KMC is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping (address => bool) private bots;
122     address payable private _taxWallet;
123     uint256 firstBlock;
124 
125     uint256 private _initialBuyTax=18;
126     uint256 private _initialSellTax=30;
127     uint256 private _finalBuyTax=1;
128     uint256 private _finalSellTax=1;
129     uint256 private _reduceBuyTaxAt=10;
130     uint256 private _reduceSellTaxAt=20;
131     uint256 private _preventSwapBefore=20;
132     uint256 private _buyCount=0;
133 
134     uint8 private constant _decimals = 9;
135     uint256 private constant _tTotal = 100000000 * 10**_decimals;
136     string private constant _name = unicode"KEY MEASURING CONTEST";
137     string private constant _symbol = unicode"KMC";
138     uint256 public _maxTxAmount = 2000000 * 10**_decimals;
139     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
140     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
141     uint256 public _maxTaxSwap= 1000000 * 10**_decimals;
142 
143     IUniswapV2Router02 private uniswapV2Router;
144     address private uniswapV2Pair;
145     bool private tradingOpen;
146     bool private inSwap = false;
147     bool private swapEnabled = false;
148 
149     event MaxTxAmountUpdated(uint _maxTxAmount);
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155 
156     constructor () {
157 
158         _taxWallet = payable(_msgSender());
159         _balances[_msgSender()] = _tTotal;
160         _isExcludedFromFee[owner()] = true;
161         _isExcludedFromFee[address(this)] = true;
162         _isExcludedFromFee[_taxWallet] = true;
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
179     function totalSupply() public pure override returns (uint256) {
180         return _tTotal;
181     }
182 
183     function balanceOf(address account) public view override returns (uint256) {
184         return _balances[account];
185     }
186 
187     function transfer(address recipient, uint256 amount) public override returns (bool) {
188         _transfer(_msgSender(), recipient, amount);
189         return true;
190     }
191 
192     function allowance(address owner, address spender) public view override returns (uint256) {
193         return _allowances[owner][spender];
194     }
195 
196     function approve(address spender, uint256 amount) public override returns (bool) {
197         _approve(_msgSender(), spender, amount);
198         return true;
199     }
200 
201     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
202         _transfer(sender, recipient, amount);
203         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
204         return true;
205     }
206 
207     function _approve(address owner, address spender, uint256 amount) private {
208         require(owner != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210         _allowances[owner][spender] = amount;
211         emit Approval(owner, spender, amount);
212     }
213 
214     function _transfer(address from, address to, uint256 amount) private {
215         require(from != address(0), "ERC20: transfer from the zero address");
216         require(to != address(0), "ERC20: transfer to the zero address");
217         require(amount > 0, "Transfer amount must be greater than zero");
218         uint256 taxAmount=0;
219         if (from != owner() && to != owner()) {
220             require(!bots[from] && !bots[to]);
221             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
222 
223             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
224                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
225                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
226 
227                 if (firstBlock + 3  > block.number) {
228                     require(!isContract(to));
229                 }
230                 _buyCount++;
231             }
232 
233             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
234                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
235             }
236 
237             if(to == uniswapV2Pair && from!= address(this) ){
238                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
239             }
240 
241             uint256 contractTokenBalance = balanceOf(address(this));
242             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
243                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
244                 uint256 contractETHBalance = address(this).balance;
245                 if(contractETHBalance > 0) {
246                     sendETHToFee(address(this).balance);
247                 }
248             }
249         }
250 
251         if(taxAmount>0){
252           _balances[address(this)]=_balances[address(this)].add(taxAmount);
253           emit Transfer(from, address(this),taxAmount);
254         }
255         _balances[from]=_balances[from].sub(amount);
256         _balances[to]=_balances[to].add(amount.sub(taxAmount));
257         emit Transfer(from, to, amount.sub(taxAmount));
258     }
259 
260 
261     function min(uint256 a, uint256 b) private pure returns (uint256){
262       return (a>b)?b:a;
263     }
264 
265     function isContract(address account) private view returns (bool) {
266         uint256 size;
267         assembly {
268             size := extcodesize(account)
269         }
270         return size > 0;
271     }
272 
273     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
274         address[] memory path = new address[](2);
275         path[0] = address(this);
276         path[1] = uniswapV2Router.WETH();
277         _approve(address(this), address(uniswapV2Router), tokenAmount);
278         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
279             tokenAmount,
280             0,
281             path,
282             address(this),
283             block.timestamp
284         );
285     }
286 
287     function removeLimits() external onlyOwner{
288         _maxTxAmount = _tTotal;
289         _maxWalletSize=_tTotal;
290         emit MaxTxAmountUpdated(_tTotal);
291     }
292 
293     function sendETHToFee(uint256 amount) private {
294         _taxWallet.transfer(amount);
295     }
296 
297     function addBots(address[] memory bots_) public onlyOwner {
298         for (uint i = 0; i < bots_.length; i++) {
299             bots[bots_[i]] = true;
300         }
301     }
302 
303     function delBots(address[] memory notbot) public onlyOwner {
304       for (uint i = 0; i < notbot.length; i++) {
305           bots[notbot[i]] = false;
306       }
307     }
308 
309     function isBot(address a) public view returns (bool){
310       return bots[a];
311     }
312 
313     function openTrading() external onlyOwner() {
314         require(!tradingOpen,"trading is already open");
315         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
316         _approve(address(this), address(uniswapV2Router), _tTotal);
317         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
318         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
319         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
320         swapEnabled = true;
321         tradingOpen = true;
322         firstBlock = block.number;
323     }
324 
325     receive() external payable {}
326 
327 }