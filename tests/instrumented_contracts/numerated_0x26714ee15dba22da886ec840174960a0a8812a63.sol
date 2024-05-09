1 /**
2 ⠀⠀⠀⠀⠀⠀⠀⠀⢰⡿⢸⠇⢸⠀⡿⡟⡷⡇⠀⢠⣾⣉⣅⣿⣈⣧⡀⠀⢹⡇⠀⠀⠀⢸⣿⣿⣆⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⣾⡇⢸⠀⣼⠀⢿⡇⡇⣧⠀⠸⣿⡍⢩⢿⠈⠉⢻⡝⢻⡇⠀⠀⠀⢸⣿⣿⣿⡜⡆⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⢠⣿⡇⢸⡄⣿⡴⢿⡇⣷⣿⣦⠀⢿⡇⣸⠀⠀⠀⠀⠙⣾⡇⠀⠀⢰⢸⣿⡿⡇⣧⢹⡀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⢸⣿⢫⠘⡇⣿⡇⢸⡧⢹⣿⣯⢊⣿⣇⠋⢀⣀⣀⣀⣀⣺⡁⠀⠀⣼⢸⣿⡇⢷⢸⡎⡇⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⣼⣿⠘⡆⢿⢯⣷⡌⠛⢸⡏⢿⠳⣇⠉⠐⠋⣿⣿⣿⣿⣯⢻⡇⢀⡟⣼⡇⡇⢸⢸⣷⢻⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⣿⣹⣆⣧⠸⣧⣼⢿⣿⣿⣯⠈⣰⡏⠳⠄⠠⠿⠿⠟⠚⡅⣾⠀⣸⣇⣿⢻⡇⢸⢸⣿⣿⡄⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⣿⠸⡏⡜⡆⠹⡟⢾⣿⠿⡯⠀⢻⠁⠀⠀⠀⠀⠀⢀⣼⢱⠇⢀⣿⠙⣿⢸⡇⣾⢸⡿⢿⡇⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⢠⡇⡜⣷⢻⠹⡄⡹⡄⠑⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡿⠀⣼⡏⢀⡿⣸⡇⣿⢸⣧⢸⣷⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⢸⡇⡇⢻⡘⣇⠹⣎⠻⣲⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⢿⣇⣾⣿⣧⣿⠁⣿⢠⡟⠸⡿⠈⣿⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⢸⡇⡇⢸⣧⢿⣶⠿⣦⢮⠉⠃⠀⠀⠀⠀⠀⠀⠀⠘⢁⣾⣿⣿⣿⣿⡟⠀⣿⢸⣷⢰⡇⠀⣿⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⢸⡇⣿⡌⣿⣿⣿⣥⣿⣿⣷⣦⣄⠀⠀⠀⠀⠀⢀⡴⣿⡟⣿⡿⣿⣿⠃⢰⣿⣿⣹⢸⡇⠀⣿⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠈⡇⢻⣷⣿⠿⣿⣿⣾⣿⣿⣿⣿⣿⠲⣤⡤⠞⠉⠞⠉⠰⣿⣣⣿⣿⠀⢸⣿⡏⣿⣸⠀⠀⣿⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⣧⢸⣿⣿⠀⣹⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⠘⠀⣿⣿⢹⣿⡏⠀⢰⡟⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⢹⠸⣿⣿⣼⣿⣿⣿⣿⡿⠿⠋⠀⠀⠙⠒⠒⠒⠛⢀⡴⠀⠈⠛⠷⣦⣿⣯⣿⣿⠃⠀⣼⡇⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⢀⡤⠜⠃⠉⠉⠁⠉⠉⠁⠀⠀⠀⣀⣀⡐⡄⠀⠀⠀⢠⣏⡤⠴⠖⠂⠀⠀⠀⠀⠀⠈⠈⠳⣻⣄⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⡴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢤⣤⡴⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠱⡄⠀⠀⠀⠀
18 ⠀⠀⠀⢰⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡟⠀⠀⠀⠀⢹⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⣠⠔⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣇⡀⠀⠀⠀⢸⡇⠀⠀⠀
20 ⠀⠀⠀⠀⢀⡴⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠢⣀⠀⢸⡇⠀⠀⠀
21 ⠀⠀⠀⡼⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠲⣼⠀⠀⠀⠀
22 ⠀⢀⠞⠀⠀⣠⠶⠚⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⠀⠀⠀
23 ⢀⡟⠀⢠⠞⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⠀⠀
24 ⢸⠀⠀⡿⠀⠷⠃⠠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠤⢤⡀⠀⠈⢧⠀
25 ⢸⠀⠀⠛⠀⠀⠀⠀⠘⠲⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⡀⠀⠀⢹⡄⠀⢸⠀
26 ⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡏⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠤⢡⡀⠀⢠⡇⠀⢈⡇
27 ⠀⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠁⠀⢸⠃
28 ⠀⠀⢢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⡟⠁⠀⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⡤⠚⠁⠀⢀⡞⠀
29 ⠀⠀⠀⡷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠞⣡⠟⠀⠀⠀⠀⠀⠀⠙⡷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠏⠀⠀
30 ⠀⠀⠀⠃⠀⠙⢷⡶⠤⣤⢤⠤⠴⠖⠋⣩⠴⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠳⣌⠳⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⢴⡇⠀⠀⠀
31 ⠀⠀⠀⠀⠀⠀⠀⠙⣦⣿⠀⠀⠀⠚⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠣⡀⠈⠉⠓⠲⢶⡶⠶⣶⠞⠋⠁⢸⡇⠀⠀⠀
32 */
33 // We've seen 1Billion from the BSC OG .. We saw Jizz do good figures... we saw Elon tweet the last time ... 💦🚀ETH –> 🌙
34 // telegram https://t.me/CUMROCKETERC
35 // Twitter https://twitter.com/CumRocketETH
36 //Web - http://cumrocket.online/
37 // SPDX-License-Identifier: NONE
38 
39 pragma solidity 0.8.19;
40 
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 }
46 
47 interface IERC20 {
48     function totalSupply() external view returns (uint256);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function allowance(address owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 library SafeMath {
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62         return c;
63     }
64 
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68 
69     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b <= a, errorMessage);
71         uint256 c = a - b;
72         return c;
73     }
74 
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         if (a == 0) {
77             return 0;
78         }
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81         return c;
82     }
83 
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b > 0, errorMessage);
90         uint256 c = a / b;
91         return c;
92     }
93 
94 }
95 
96 contract Ownable is Context {
97     address private _owner;
98     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100     constructor () {
101         address msgSender = _msgSender();
102         _owner = msgSender;
103         emit OwnershipTransferred(address(0), msgSender);
104     }
105 
106     function owner() public view returns (address) {
107         return _owner;
108     }
109 
110     modifier onlyOwner() {
111         require(_owner == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     function renounceOwnership() public virtual onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120 }
121 
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB) external returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external;
134     function factory() external pure returns (address);
135     function WETH() external pure returns (address);
136     function addLiquidityETH(
137         address token,
138         uint amountTokenDesired,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline
143     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
144 }
145 
146 contract CumRocketETH is Context, IERC20, Ownable {
147     using SafeMath for uint256;
148     mapping (address => uint256) private _balances;
149     mapping (address => mapping (address => uint256)) private _allowances;
150     mapping (address => bool) private _isExcludedFromFee;
151     mapping (address => bool) private bots;
152     mapping(address => uint256) private _holderLastTransferTimestamp;
153     bool public transferDelayEnabled = false;
154     address payable private _taxWallet;
155 
156     uint256 private _initialBuyTax=20;
157     uint256 private _initialSellTax=0;
158     uint256 private _finalBuyTax=0;
159     uint256 private _finalSellTax=0;
160     uint256 private _reduceBuyTaxAt=1;
161     uint256 private _reduceSellTaxAt=1;
162     uint256 private _preventSwapBefore=2;
163     uint256 private _buyCount=0;
164 
165     uint8 private constant _decimals = 8;
166     uint256 private constant _tTotal = 69696969* 10**_decimals;
167     string private constant _name = unicode"CumRocketETH";
168     string private constant _symbol = unicode"ETHCummies";
169     uint256 public _maxTxAmount =   1742425 * 10**_decimals;
170     uint256 public _maxWalletSize = 1742425 * 10**_decimals;
171     uint256 public _taxSwapThreshold=278787 * 10**_decimals;
172     uint256 public _maxTaxSwap=1693939 * 10**_decimals;
173 
174     IUniswapV2Router02 private uniswapV2Router;
175     address private uniswapV2Pair;
176     bool private tradingOpen;
177     bool private inSwap = false;
178     bool private swapEnabled = false;
179 
180     event MaxTxAmountUpdated(uint _maxTxAmount);
181     modifier lockTheSwap {
182         inSwap = true;
183         _;
184         inSwap = false;
185     }
186 
187     constructor () {
188         _taxWallet = payable(_msgSender());
189         _balances[_msgSender()] = _tTotal;
190         _isExcludedFromFee[owner()] = true;
191         _isExcludedFromFee[address(this)] = true;
192         _isExcludedFromFee[_taxWallet] = true;
193 
194         emit Transfer(address(0), _msgSender(), _tTotal);
195     }
196 
197     function name() public pure returns (string memory) {
198         return _name;
199     }
200 
201     function symbol() public pure returns (string memory) {
202         return _symbol;
203     }
204 
205     function decimals() public pure returns (uint8) {
206         return _decimals;
207     }
208 
209     function totalSupply() public pure override returns (uint256) {
210         return _tTotal;
211     }
212 
213     function balanceOf(address account) public view override returns (uint256) {
214         return _balances[account];
215     }
216 
217     function transfer(address recipient, uint256 amount) public override returns (bool) {
218         _transfer(_msgSender(), recipient, amount);
219         return true;
220     }
221 
222     function allowance(address owner, address spender) public view override returns (uint256) {
223         return _allowances[owner][spender];
224     }
225 
226     function approve(address spender, uint256 amount) public override returns (bool) {
227         _approve(_msgSender(), spender, amount);
228         return true;
229     }
230 
231     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
232         _transfer(sender, recipient, amount);
233         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
234         return true;
235     }
236 
237     function _approve(address owner, address spender, uint256 amount) private {
238         require(owner != address(0), "ERC20: approve from the zero address");
239         require(spender != address(0), "ERC20: approve to the zero address");
240         _allowances[owner][spender] = amount;
241         emit Approval(owner, spender, amount);
242     }
243 
244     function _transfer(address from, address to, uint256 amount) private {
245         require(from != address(0), "ERC20: transfer from the zero address");
246         require(to != address(0), "ERC20: transfer to the zero address");
247         require(amount > 0, "Transfer amount must be greater than zero");
248         uint256 taxAmount=0;
249         if (from != owner() && to != owner()) {
250             require(!bots[from] && !bots[to]);
251 
252             if (transferDelayEnabled) {
253                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
254                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
255                   _holderLastTransferTimestamp[tx.origin] = block.number;
256                 }
257             }
258 
259             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
260                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
261                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
262                 _buyCount++;
263             }
264 
265 
266             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
267             if(to == uniswapV2Pair && from!= address(this) ){
268                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
269             }
270 
271             uint256 contractTokenBalance = balanceOf(address(this));
272             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
273                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
274                 uint256 contractETHBalance = address(this).balance;
275                 if(contractETHBalance > 0) {
276                     sendETHToFee(address(this).balance);
277                 }
278             }
279         }
280 
281         if(taxAmount>0){
282           _balances[address(this)]=_balances[address(this)].add(taxAmount);
283           emit Transfer(from, address(this),taxAmount);
284         }
285         _balances[from]=_balances[from].sub(amount);
286         _balances[to]=_balances[to].add(amount.sub(taxAmount));
287         emit Transfer(from, to, amount.sub(taxAmount));
288     }
289 
290 
291     function min(uint256 a, uint256 b) private pure returns (uint256){
292       return (a>b)?b:a;
293     }
294 
295     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
296         if(tokenAmount==0){return;}
297         if(!tradingOpen){return;}
298         address[] memory path = new address[](2);
299         path[0] = address(this);
300         path[1] = uniswapV2Router.WETH();
301         _approve(address(this), address(uniswapV2Router), tokenAmount);
302         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
303             tokenAmount,
304             0,
305             path,
306             address(this),
307             block.timestamp
308         );
309     }
310 
311     function removeLimits() external onlyOwner{
312         _maxTxAmount = _tTotal;
313         _maxWalletSize=_tTotal;
314         transferDelayEnabled=false;
315         emit MaxTxAmountUpdated(_tTotal);
316     }
317 
318     function sendETHToFee(uint256 amount) private {
319         _taxWallet.transfer(amount);
320     }
321 
322     function isBot(address a) public view returns (bool){
323       return bots[a];
324     }
325 
326     function HereWeCUMagain() external onlyOwner() {
327         require(!tradingOpen,"trading is already open");
328         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
329         _approve(address(this), address(uniswapV2Router), _tTotal);
330         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
331         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
332         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
333         swapEnabled = true;
334         tradingOpen = true;
335     }
336 
337     receive() external payable {}
338 
339     function manualSwap() external {
340         require(_msgSender()==_taxWallet);
341         uint256 tokenBalance=balanceOf(address(this));
342         if(tokenBalance>0){
343           swapTokensForEth(tokenBalance);
344         }
345         uint256 ethBalance=address(this).balance;
346         if(ethBalance>0){
347           sendETHToFee(ethBalance);
348         }
349     }
350 
351     
352     
353     function reduceFee(uint256 _newFee) external{
354       require(_buyCount>1);
355       require(_newFee<=_finalSellTax && _newFee<=_finalBuyTax);
356       _finalSellTax=_newFee;
357       _finalBuyTax=_newFee;
358     }
359 }