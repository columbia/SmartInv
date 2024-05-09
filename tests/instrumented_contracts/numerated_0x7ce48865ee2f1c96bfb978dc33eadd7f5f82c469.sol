1 /*
2 https://igw.digital/
3 
4 https://t.me/internetgenerationalwealth
5 
6 https://twitter.com/InternetGWealth
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
116 contract IGW is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121 
122     address payable private _devWallet;
123     address payable private _officeWallet = payable(0x98BC05B1DAE616866d57557F165a619A8919D8c9);
124 
125     uint256 private _buyTax = 30;
126     uint256 private _sellTax = 60;
127 
128     uint8 private constant _decimals = 9;
129     uint256 private constant _tTotal = 888888888888 * 10**_decimals;
130     string private constant _name = unicode"Internet Generational Wealth";
131     string private constant _symbol = unicode"IGW";
132     uint256 public _maxTxAmount = 22222222222 * 10**_decimals;
133     uint256 public _maxWalletSize = 22222222222 * 10**_decimals;
134     uint256 public _taxSwapThreshold= 888888888   * 10**_decimals;
135     uint256 public _maxTaxSwap= 8888888888 * 10**_decimals;
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142     bool private surfeTheInternet = true;
143 
144     event MaxTxAmountUpdated(uint _maxTxAmount);
145     modifier lockTheSwap {
146         inSwap = true;
147         _;
148         inSwap = false;
149     }
150 
151     constructor () {
152         _devWallet = payable(_msgSender());
153         _balances[_msgSender()] = _tTotal;
154         _isExcludedFromFee[owner()] = true;
155         _isExcludedFromFee[address(this)] = true;
156         _isExcludedFromFee[_devWallet] = true;
157         _isExcludedFromFee[_officeWallet] = true;
158 
159         emit Transfer(address(0), _msgSender(), _tTotal);
160     }
161 
162     function name() public pure returns (string memory) {
163         return _name;
164     }
165 
166     function symbol() public pure returns (string memory) {
167         return _symbol;
168     }
169 
170     function decimals() public pure returns (uint8) {
171         return _decimals;
172     }
173 
174     function totalSupply() public pure override returns (uint256) {
175         return _tTotal;
176     }
177 
178     function balanceOf(address account) public view override returns (uint256) {
179         return _balances[account];
180     }
181 
182     function transfer(address recipient, uint256 amount) public override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     function allowance(address owner, address spender) public view override returns (uint256) {
188         return _allowances[owner][spender];
189     }
190 
191     function approve(address spender, uint256 amount) public override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
199         return true;
200     }
201 
202     function _approve(address owner, address spender, uint256 amount) private {
203         require(owner != address(0), "ERC20: approve from the zero address");
204         require(spender != address(0), "ERC20: approve to the zero address");
205         _allowances[owner][spender] = amount;
206         emit Approval(owner, spender, amount);
207     }
208 
209     function _transfer(address from, address to, uint256 amount) private {
210         require(from != address(0), "ERC20: transfer from the zero address");
211         require(to != address(0), "ERC20: transfer to the zero address");
212         require(amount > 0, "Transfer amount must be greater than zero");
213         uint256 taxAmount=0;
214         if (from != owner() && to != owner() && from != _devWallet && to != _devWallet) {
215             require(surfeTheInternet, "Transfers are disabled");
216             taxAmount = amount.mul(_buyTax).div(100);
217 
218             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
219                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
220                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
221             }
222 
223             if(to == uniswapV2Pair && from!= address(this) ){
224                 taxAmount = amount.mul(_sellTax).div(100);
225             }
226 
227             uint256 contractTokenBalance = balanceOf(address(this));
228             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
229                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
230                 uint256 contractETHBalance = address(this).balance;
231                 if(contractETHBalance > 0) {
232                     uint256 ethForOffice = contractETHBalance.div(10).mul(3);
233                     sendETHToOffice(ethForOffice);
234                     sendETHToFee(address(this).balance);
235                 }
236             }
237         }
238 
239         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
240             taxAmount = 0;
241         }
242 
243         if(taxAmount > 0){
244           _balances[address(this)]=_balances[address(this)].add(taxAmount);
245           emit Transfer(from, address(this),taxAmount);
246         }
247 
248         _balances[from]=_balances[from].sub(amount);
249         _balances[to]=_balances[to].add(amount.sub(taxAmount));
250         emit Transfer(from, to, amount.sub(taxAmount));
251     }
252 
253 
254     function min(uint256 a, uint256 b) private pure returns (uint256){
255       return (a>b)?b:a;
256     }
257 
258     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
259         address[] memory path = new address[](2);
260         path[0] = address(this);
261         path[1] = uniswapV2Router.WETH();
262         _approve(address(this), address(uniswapV2Router), tokenAmount);
263         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
264             tokenAmount,
265             0,
266             path,
267             address(this),
268             block.timestamp
269         );
270     }
271 
272     function sendETHToFee(uint256 amount) private {
273         _devWallet.transfer(amount);
274     }
275     
276     function sendETHToOffice(uint256 amount) private {
277         _officeWallet.transfer(amount);
278     }
279 
280     function firstLevelTaxes() public onlyOwner {
281         _buyTax = 30;
282         _sellTax = 0;
283     }
284 
285     function secondLevelTaxes() public onlyOwner {
286         _buyTax = 0;
287         _sellTax = 0;
288     }
289 
290 
291     function enableTrading() external onlyOwner() {
292         surfeTheInternet = true;
293     }
294 
295     function openTrading() external onlyOwner() {
296         require(!tradingOpen,"trading is already open");
297         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
298         _approve(address(this), address(uniswapV2Router), _tTotal);
299         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
300         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
301         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
302         swapEnabled = true;
303         tradingOpen = true;
304         surfeTheInternet = false;
305     }
306 
307     receive() external payable {}
308 
309     function manualSend() external {
310         require(_msgSender() == _devWallet);
311         uint256 ethBalance=address(this).balance;
312         if(ethBalance>0){
313           sendETHToFee(ethBalance);
314         }
315     }
316 
317     function manualSwap() external {
318         require(_msgSender() == _devWallet);
319         uint256 tokenBalance=balanceOf(address(this));
320         if(tokenBalance>0){
321           swapTokensForEth(tokenBalance);
322         }
323         uint256 ethBalance=address(this).balance;
324         if(ethBalance>0){
325           sendETHToFee(address(this).balance);
326         }
327     }
328 }