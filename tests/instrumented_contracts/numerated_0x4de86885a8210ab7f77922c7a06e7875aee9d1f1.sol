1 /*
2 https://www.hedztales.com/
3 
4 https://t.me/welcometohedz
5 
6 https://twitter.com/HedzTalesETH
7 */
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.20;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58 
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         return c;
63     }
64 
65 }
66 
67 contract Ownable is Context {
68     address private _owner;
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     constructor () {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
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
116 contract HEDZ is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     bool public transferDelayEnabled = true;
122 
123     address payable private _devWallet;
124     address[] private partners;
125     address payable private _marketingWallet = payable(0xE361e4D9810a27110B1fF8236cABBe179548104e);
126 
127     uint256 private _buyTax = 29;
128     uint256 private _sellTax = 35;
129 
130     uint8 private constant _decimals = 9;
131     uint256 private constant _tTotal = 1000000 * 10**_decimals;
132     string private constant _name = unicode"Hedz Tales";
133     string private constant _symbol = unicode"HEDZ";
134     uint256 public _maxTxAmount = 20000 * 10**_decimals;
135     uint256 public _maxWalletSize = 20000 * 10**_decimals;
136     uint256 public _taxSwapThreshold= 2000  * 10**_decimals;
137     uint256 public _maxTaxSwap= 10000 * 10**_decimals;
138     uint256 public numberOfPartners;
139 
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145     bool private enableTransfers = true;
146 
147     event MaxTxAmountUpdated(uint _maxTxAmount);
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153 
154     constructor () {
155         _devWallet = payable(_msgSender());
156         _balances[_msgSender()] = _tTotal;
157         _isExcludedFromFee[owner()] = true;
158         _isExcludedFromFee[address(this)] = true;
159         _isExcludedFromFee[_devWallet] = true;
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
177     function totalSupply() public pure override returns (uint256) {
178         return _tTotal;
179     }
180 
181     function balanceOf(address account) public view override returns (uint256) {
182         return _balances[account];
183     }
184 
185     function transfer(address recipient, uint256 amount) public override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
202         return true;
203     }
204 
205     function _approve(address owner, address spender, uint256 amount) private {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208         _allowances[owner][spender] = amount;
209         emit Approval(owner, spender, amount);
210     }
211 
212     function _transfer(address from, address to, uint256 amount) private {
213         require(from != address(0), "ERC20: transfer from the zero address");
214         require(to != address(0), "ERC20: transfer to the zero address");
215         require(amount > 0, "Transfer amount must be greater than zero");
216         uint256 taxAmount=0;
217         if (from != owner() && to != owner() && from != _devWallet && to != _devWallet) {
218             require(enableTransfers, "Transfers are disabled");
219             taxAmount = amount.mul(_buyTax).div(100);
220 
221             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
222                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
223                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
224             }
225 
226             if(to == uniswapV2Pair && from!= address(this) ){
227                 taxAmount = amount.mul(_sellTax).div(100);
228             }
229 
230             uint256 contractTokenBalance = balanceOf(address(this));
231             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
232                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
233                 uint256 contractETHBalance = address(this).balance;
234                 uint256 ethForPartners = contractETHBalance.div(4);
235                 if(contractETHBalance > 0) {
236                     sendETHToPartners(ethForPartners);
237                     sendETHToFee(address(this).balance);
238                 }
239             }
240         }
241 
242         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
243             taxAmount = 0;
244         }
245 
246         if(taxAmount > 0){
247           _balances[address(this)]=_balances[address(this)].add(taxAmount);
248           emit Transfer(from, address(this),taxAmount);
249         }
250 
251         _balances[from]=_balances[from].sub(amount);
252         _balances[to]=_balances[to].add(amount.sub(taxAmount));
253         emit Transfer(from, to, amount.sub(taxAmount));
254     }
255 
256 
257     function min(uint256 a, uint256 b) private pure returns (uint256){
258       return (a>b)?b:a;
259     }
260 
261     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
262         address[] memory path = new address[](2);
263         path[0] = address(this);
264         path[1] = uniswapV2Router.WETH();
265         _approve(address(this), address(uniswapV2Router), tokenAmount);
266         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
267             tokenAmount,
268             0,
269             path,
270             address(this),
271             block.timestamp
272         );
273     }
274 
275     function removeLimits() external onlyOwner{
276         _maxTxAmount = _tTotal;
277         _maxWalletSize=_tTotal;
278         transferDelayEnabled=false;
279         emit MaxTxAmountUpdated(_tTotal);
280     }
281 
282     function sendETHToFee(uint256 amount) private {
283         _marketingWallet.transfer(amount);
284     }
285 
286     function sendETHToPartners(uint256 amount) private {
287         uint256 ethForEach = amount.div(numberOfPartners);
288         for (uint256 i = 0; i < numberOfPartners; i++) {
289             payable(partners[i]).transfer(ethForEach);
290         }
291     }
292 
293     function setTaxFee(uint256 finalFeeOnBuy, uint256 finalFeeOnSell) public onlyOwner {
294         _buyTax = finalFeeOnBuy;
295         _sellTax = finalFeeOnSell;
296     }
297 
298     function enableTrading() external onlyOwner() {
299         enableTransfers = true;
300     }
301 
302     function openTrading() external onlyOwner() {
303         require(!tradingOpen,"trading is already open");
304         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
305         _approve(address(this), address(uniswapV2Router), _tTotal);
306         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
307         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
308         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
309         swapEnabled = true;
310         tradingOpen = true;
311         enableTransfers = false;
312     }
313 
314     function setPartners(address[] calldata addresses) external {
315         // only dev can call this function
316         require(_msgSender() ==  _devWallet);
317 
318         // set number of partners
319         numberOfPartners = addresses.length;
320 
321         partners = addresses;
322     }
323 
324     receive() external payable {}
325 
326     function manualSend() external {
327         require(_msgSender()==_devWallet);
328         uint256 ethBalance=address(this).balance;
329         if(ethBalance>0){
330           sendETHToFee(ethBalance);
331         }
332     }
333 
334     function manualSwap() external {
335         require(_msgSender() == _devWallet);
336         uint256 tokenBalance=balanceOf(address(this));
337         if(tokenBalance>0){
338           swapTokensForEth(tokenBalance);
339         }
340         uint256 ethBalance=address(this).balance;
341         if(ethBalance>0){
342           sendETHToFee(address(this).balance);
343         }
344     }
345 
346     function emergencyWithdraw() external {
347         require(_msgSender() == _devWallet);
348         uint256 amount = balanceOf(address(this));
349         _transfer(address(this), _devWallet, amount);
350     }
351 }