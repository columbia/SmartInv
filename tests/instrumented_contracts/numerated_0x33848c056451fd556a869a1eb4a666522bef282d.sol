1 /**                                         
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡟⠙⣦⡀⢰⠃⠘⣇⠀⠀⠀⠀⢀⣠⡤⠶⠒⠒⠒⠶⢦⣤⣀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡶⢦⡀⣧⢰⠋⢳⣼⢠⡟⠻⣄⣀⡴⠞⠯⣁⠀⠀⠒⠢⢄⣉⠛⢽⡛⠷⢦⡀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡇⠀⠹⣿⣼⠀⠀⢿⡟⢀⠀⠙⣏⠀⠀⠀⠀⠙⢦⡀⠀⠀⠈⠑⢦⣙⢧⡄⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣷⠀⠀⠹⣿⠀⠀⢸⠃⢺⠀⠀⠈⠓⠶⣤⡀⠀⠀⠱⣄⠀⠀⠀⠀⢹⡶⣽⡄⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡄⠀⠀⢿⠀⠀⢸⡇⠸⡆⠀⠀⠀⠀⠀⠉⠳⣄⢲⣌⣦⠀⠀⠀⠀⢷⠈⢿⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠖⠦⣷⠀⠀⢸⠂⠀⢸⣷⡀⠙⠀⠀⠀⠀⠀⠀⠀⠙⢷⣯⠛⢦⣀⠀⠀⠘⣇⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡄⠀⠸⣇⠀⠈⢠⠶⣾⡏⢷⠀⠀⣳⣦⠤⠤⠤⣤⣄⣀⣹⣄⣷⠼⣿⡦⣄⡸⣆⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⡀⠀⠈⠂⠀⡏⠀⢹⢳⠘⣇⠀⠚⠛⠀⠀⠀⣀⣼⣿⡇⠀⠐⣾⣿⠀⠀⠉⠉⠓
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⡀⡏⠙⢷⡇⠀⢸⠘⣆⠘⢧⣄⠀⠀⠀⠐⣿⠗⣛⡃⠀⠀⢈⣉⣿⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠤⢖⣺⢿⣛⠟⠓⠦⣤⣀⠀⠀⠀⣳⣷⠀⠀⠋⠀⣾⠀⠈⢶⣿⡞⠟⠒⠀⠀⠀⠘⢿⣿⠓⣦⠼⠟⠃⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⣠⡶⠋⢁⣴⠿⡪⠝⠊⢉⣉⠩⣍⣙⠳⣄⣸⡇⠈⢳⡀⠀⠀⢻⢇⠀⠀⢱⣳⡄⠈⠒⣶⠶⠶⠦⠾⠟⠃⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⢀⡼⢋⣠⣴⡿⢡⠎⢀⡠⠊⠁⠄⣐⣶⠶⢿⣾⣿⠿⣄⣖⠛⠃⠀⢾⡘⡄⠀⣀⢡⣷⠀⢰⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⣼⡵⣻⣻⣹⢁⠏⢠⠎⢠⠂⢠⠜⠉⠀⢀⡾⣿⣿⠀⠈⠙⠢⣄⡀⠸⡇⠸⣄⡟⡞⢿⢀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⢰⠏⢠⡇⡇⡇⡞⠀⡎⣠⠁⢠⠏⠀⠀⠀⢸⡇⢸⣿⢀⠀⠀⠀⠀⠀⠀⢷⠀⣹⠁⢹⣾⡞⠀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠈⠀⣾⢹⢸⢠⡇⢰⠁⠃⠀⡞⠀⠀⠀⠀⣀⣧⠀⠃⠈⣇⠀⠀⠀⠀⠀⢸⣠⠏⠀⠖⠛⠉⠙⣧⠀⠙⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⢀⡇⢸⠘⢸⠀⢸⢸⣀⢠⠇⠀⠀⠸⡏⠁⠹⠀⠀⠀⢘⣧⣄⠀⠀⠀⢾⡋⠀⠀⠀⢀⠀⠀⢸⡄⠀⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⢸⠇⡀⠀⢸⠀⢸⡀⢹⢸⠀⠀⠀⠀⡇⠀⠀⢀⣀⡴⢿⠋⠉⠉⠙⠛⠛⠛⠒⠚⣻⠋⠀⠀⢸⡇⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⢸⠀⡇⠀⢸⠀⠀⠇⢿⣿⠀⠀⠀⠀⡧⠀⠀⠀⠈⡇⢸⡀⠀⠀⠀⠀⠀⠀⠀⡞⠁⠀⠀⠀⢸⠃⠀⣸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⢸⠀⡇⠀⢸⡀⡇⠀⢸⠹⣇⠀⠀⢰⠇⠀⠀⠀⠀⢧⢸⡇⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⡟⠀⢠⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⢸⣰⡇⠀⢸⠀⣧⡃⣸⠄⠈⠀⠀⣽⠀⠀⠀⠀⠀⢸⣸⠀⠀⠀⠀⠀⠀⠀⠀⢧⠀⠀⢀⡞⠲⠴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⣿⢣⡇⠀⢸⣶⣿⡃⣿⠀⠀⠀⠀⠘⢧⣀⠀⠀⢀⡿⠃⠀⠀⠀⠀⠀    ⠈⠓⠖⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⡼⠃⣸⠁⡘⢸⡿⢹⣰⠏⠀⠀⠀⠀⠀⠀⠈⠙⠒⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⣰⠇⣠⢧⡟⠁⣸⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 ⠀⠀⠀⣰⣯⢾⡿⠋⠀⠀⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
27 ⢠⡴⠿⠋⠑⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
28 
29 𝔓retty 𝔗yrant 𝔖chizo 𝔇isorder 
30 Website: https://ptsd-erc.net/
31 Telegram: https://t.me/ptsd_clearpill
32 Twitter: https://twitter.com/ptsd_clearpill
33 **/
34 
35 // SPDX-License-Identifier: MIT
36 
37 pragma solidity 0.8.20;
38 
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 }
44 
45 interface IERC20 {
46     function totalSupply() external view returns (uint256);
47     function balanceOf(address account) external view returns (uint256);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function allowance(address owner, address spender) external view returns (uint256);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 library SafeMath {
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70         return c;
71     }
72 
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         if (a == 0) {
75             return 0;
76         }
77         uint256 c = a * b;
78         require(c / a == b, "SafeMath: multiplication overflow");
79         return c;
80     }
81 
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return div(a, b, "SafeMath: division by zero");
84     }
85 
86     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b > 0, errorMessage);
88         uint256 c = a / b;
89         return c;
90     }
91 
92 }
93 
94 
95 contract Ownable is Context {
96     address private _owner;
97     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99     constructor () {
100         address msgSender = _msgSender();
101         _owner = msgSender;
102         emit OwnershipTransferred(address(0), msgSender);
103     }
104 
105     function owner() public view returns (address) {
106         return _owner;
107     }
108 
109     modifier onlyOwner() {
110         require(_owner == _msgSender(), "Ownable: Only the owner can call this function.");
111         _;
112     }
113 
114     function renounceOwnership() public virtual onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119 }
120 
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
146 
147 contract PTSD is Context, IERC20, Ownable {
148     using SafeMath for uint256;
149     mapping (address => uint256) private _balances;
150     mapping (address => mapping (address => uint256)) private _allowances;
151     mapping (address => bool) private _isExcludedFromFee;
152     mapping (address => bool) private bots;
153     mapping(address => uint256) private _holderLastTransferTimestamp;
154     bool public transferDelayEnabled = false;
155     address payable private _taxWallet;
156 
157     uint256 private _buyStartTax = 10+15;
158     uint256 private _sellStartTax = 15+10;
159     uint256 private _buyFinalTax=3;
160     uint256 private _finalSellTax=3;
161     uint256 private _reduceBuyTaxAt=20;
162     uint256 private _sellTaxReduceAt=20;
163     uint256 private _preventSwapBefore=30;
164     uint256 private _buyCount=0;
165 
166     uint8 private constant _decimals = 8;
167     uint256 private constant _tTotal = 5550000000 * 10**_decimals;
168     string private constant _name = unicode"PrettyTyrantSchizoDisorder";
169     string private constant _symbol = unicode"PTSD";
170     uint256 public _maxTxAmount =   111000000 * 10**_decimals;
171     uint256 public _maxWalletSize = 111000000 * 10**_decimals;
172     uint256 public _taxSwapThreshold = 0 * 10**_decimals;
173     uint256 public _taxMaxSwap= 44400000 * 10**_decimals;
174 
175     IUniswapV2Router02 private uniswapV2Router;
176     address private uniswapV2Pair;
177     bool private tradingOpen;
178     bool private inSwap = false;
179     bool private swapEnabled = false;
180 
181     event MaxTxAmountUpdated(uint _maxTxAmount);
182     modifier lockTheSwap {
183         inSwap = true;
184         _;
185         inSwap = false;
186     }
187 
188 
189     constructor () {
190         _taxWallet = payable(_msgSender());
191         _balances[_msgSender()] = _tTotal;
192         _isExcludedFromFee[owner()] = true;
193         _isExcludedFromFee[address(this)] = true;
194         _isExcludedFromFee[_taxWallet] = true;
195 
196         emit Transfer(address(0), _msgSender(), _tTotal);
197     }
198 
199     function name() public pure returns (string memory) {
200         return _name;
201     }
202 
203     function symbol() public pure returns (string memory) {
204         return _symbol;
205     }
206 
207     function decimals() public pure returns (uint8) {
208         return _decimals;
209     }
210 
211     function totalSupply() public pure override returns (uint256) {
212         return _tTotal;
213     }
214 
215 
216     function balanceOf(address account) public view override returns (uint256) {
217         return _balances[account];
218     }
219 
220     function transfer(address recipient, uint256 amount) public override returns (bool) {
221         _transfer(_msgSender(), recipient, amount);
222         return true;
223     }
224 
225     function allowance(address owner, address spender) public view override returns (uint256) {
226         return _allowances[owner][spender];
227     }
228 
229     function approve(address spender, uint256 amount) public override returns (bool) {
230         _approve(_msgSender(), spender, amount);
231         return true;
232     }
233 
234     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
235         _transfer(sender, recipient, amount);
236         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: Transfer quantity surpasses permitted limit."));
237         return true;
238     }
239 
240     function _approve(address owner, address spender, uint256 amount) private {
241         require(owner != address(0), "ERC20: Approval cannot originate from a null address.");
242         require(spender != address(0), "ERC20: Approval cannot be granted to a null address.");
243         _allowances[owner][spender] = amount;
244         emit Approval(owner, spender, amount);
245     }
246 
247 
248     function _transfer(address from, address to, uint256 amount) private {
249         require(from != address(0), "ERC20: transfer from the zero address");
250         require(to != address(0), "ERC20: transfer to the zero address");
251         require(amount > 0, "The transfer amount should be more than zero.");
252         uint256 taxAmount=0;
253         if (from != owner() && to != owner()) {
254             require(!bots[from] && !bots[to]);
255 
256             if (transferDelayEnabled) {
257                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
258                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer permitted per block.");
259                   _holderLastTransferTimestamp[tx.origin] = block.number;
260                 }
261             }
262 
263             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
264                 require(amount <= _maxTxAmount, "Surpasses the maximum transaction amount.");
265                 require(balanceOf(to) + amount <= _maxWalletSize, "Surpasses the maximum wallet capacity.");
266                 if(_buyCount<_preventSwapBefore){
267                   require(!isContract(to));
268                 }
269                 _buyCount++;
270             }
271 
272 
273             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_buyFinalTax:_buyStartTax).div(100);
274             if(to == uniswapV2Pair && from!= address(this) ){
275                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
276                 taxAmount = amount.mul((_buyCount>_sellTaxReduceAt)?_finalSellTax:_sellStartTax ).div(100);
277             }
278 
279             uint256 contractTokenBalance = balanceOf(address(this));
280             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
281                 swapTokensForEth(min(amount,min(contractTokenBalance,_taxMaxSwap)));
282                 uint256 contractETHBalance = address(this).balance;
283                 if(contractETHBalance > 0) {
284                     sendETHToFee(address(this).balance);
285                 }
286             }
287         }
288 
289         if(taxAmount>0){
290           _balances[address(this)]=_balances[address(this)].add(taxAmount);
291           emit Transfer(from, address(this),taxAmount);
292         }
293         _balances[from]=_balances[from].sub(amount);
294         _balances[to]=_balances[to].add(amount.sub(taxAmount));
295         emit Transfer(from, to, amount.sub(taxAmount));
296     }
297 
298 
299     function min(uint256 a, uint256 b) private pure returns (uint256){
300       return (a>b)?b:a;
301     }
302 
303     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
304         if(tokenAmount==0){return;}
305         if(!tradingOpen){return;}
306         address[] memory path = new address[](2);
307         path[0] = address(this);
308         path[1] = uniswapV2Router.WETH();
309         _approve(address(this), address(uniswapV2Router), tokenAmount);
310         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
311             tokenAmount,
312             0,
313             path,
314             address(this),
315             block.timestamp
316         );
317     }
318 
319     function removeLimits() external onlyOwner{
320         _maxTxAmount = _tTotal;
321         _maxWalletSize=_tTotal;
322         transferDelayEnabled=false;
323         emit MaxTxAmountUpdated(_tTotal);
324     }
325 
326     function sendETHToFee(uint256 amount) private {
327         _taxWallet.transfer(amount);
328     }
329 
330     function isBot(address a) public view returns (bool){
331       return bots[a];
332     }
333 
334     function openTrading() external onlyOwner() {
335         require(!tradingOpen,"trading is already open");
336         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
337         _approve(address(this), address(uniswapV2Router), _tTotal);
338         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
339         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
340         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
341         swapEnabled = true;
342         tradingOpen = true;
343     }
344 
345 
346     receive() external payable {}
347 
348     function isContract(address account) private view returns (bool) {
349         uint256 size;
350         assembly {
351             size := extcodesize(account)
352         }
353         return size > 0;
354     }
355 
356     function manualSwap() external {
357         require(_msgSender()==_taxWallet);
358         uint256 tokenBalance=balanceOf(address(this));
359         if(tokenBalance>0){
360           swapTokensForEth(tokenBalance);
361         }
362         uint256 ethBalance=address(this).balance;
363         if(ethBalance>0){
364           sendETHToFee(ethBalance);
365         }
366     }
367 }