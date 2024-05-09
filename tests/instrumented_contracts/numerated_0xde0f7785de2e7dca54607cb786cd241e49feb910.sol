1 /***
2 
3        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⣶⣶⣾⣿⣿⣿⣿⣿⣷⣶⣶⣦⣤⣄⣀⡀⠀⠀⠀⠀⠀
4        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⣿⣿⣿⣿⠿⣟⣛⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀⠀⠀
5        ⠀⠀⠀⠀⢰⠶⣶⣶⣶⣦⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠟⠋⠉⡇⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠋⠉⠀⠀⠀                                  
6        ⠀⠀⠀⠀⢸⣷⣄⣙⣿⣿⣿⣿⣿⣿⣿⣫⣭⠿⣭⣝⢿⣿⣦⣄⡇⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀
7        ⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣫⠟⠁⠀⠀⠀⠈⢷⢻⣿⣿⣿⣿⣿⣿⣿⣥⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀
8        ⠀⠀⠀⠀⠀⣾⡟⣷⢻⣿⣿⣿⣿⠃⠀⠀⣠⣤⡀⠀⠘⣟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀
9        ⠀⠀⠀⠀⠀⣿⠀⢸⣏⣿⣿⣿⡏⠀⠀⠀⣿⣿⣇⠀⠀⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀
10        ⠀⠀⠀⠀⠀⢹⠀⠀⣿⣿⣿⡟⠀⠀⠀⠀⣿⣿⣿⠀⠀⣿⣿⠇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀
11        ⠀⠀⠀⠀⠀⣸⣄⡀⢻⣿⠉⠀⠀⠀⠀⠀⠹⠿⠏⠀⣸⣿⣿⡀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀
12        ⠀⠀⠀⠀⠀⢿⣿⣿⣷⡖⠒⠦⢄⣀⣀⣀⣀⠤⠒⢉⣀⡀⠀⠙⣿⣿⣿⣿⣟⠛⠉⠉⠉⠉⠛⠛⠻⢿⣷⠀
13        ⠀⠀⠀⠀⠀⠀⠉⠻⡛⠁⠀⠀⠀⠀⠈⠀⠀⠀⠀⢀⡸⠻⠀⢰⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠈⠂
14        ⠀⠀⠀⠀⠀⠀⠀⠀⠙⠲⣄⠀⠀⠀⠀⠀⠠⠒⠚⠉⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀
15        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠬⠵⣦⠤⣤⠀⠀⣀⣤⣤⣶⣿⠟⠛⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀
16        ⠀⠀⠀⠀⠀⠀⠀⣠⡞⢀⡔⠒⣼⡞⢁⡔⠂⠉⠉⠉⠛⠧⣄⢀⠟⠛⠻⢿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀
17        ⠀⠀⠀⠀⠀⠀⢸⠘⠷⠤⢷⡀⠈⠳⠼⡀⠀⠀⠀⠀⠀⢀⠈⢿⣧⠀⠀⠀⠉⠻⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀
18        ⠀⠀⠀⠀⠀⠀⡠⠓⢦⡤⠔⠛⠲⠤⠤⠵⢴⠀⠀⡄⢰⠈⣇⣿⣿⣧⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀
19        ⠀⠀⠀⠀⠀⠘⠦⠤⠟⣆⠀⠀⠀⠀⠀⠀⢦⣀⣴⣠⣧⣼⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
20        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⢦⣤⣀⣠⣤⣾⣿⣿⣿⡇⠀⠀⠈⠙⠻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⠻⣿⣿⡏⠻⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
22        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡏⠀⢹⣿⣿⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
23        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠒⢋⣿⣿⣿⡒⢬⣿⣿⡧⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠧⠀⠈⠉⢉⡟⠉⢥⣿⣿⠿⠒⠀⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25        ⠀⠀⠀⠀⠀⠀⠀⢀⡸⢄⠀⠀⠀⠀⢣⡀⠀⠀⠀⠀⠀⠀⡸⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26        ⠀⠀⠀⠀⢀⣤⣾⣿⡦⠀⠙⢶⣶⣤⣼⠀⠀⠀⠀⠀⠀⠀⠀⣨⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
27        ⠀⠀⣠⣶⣿⠿⠋⣡⣴⣷⡀⠈⣿⣿⣿⣷⣦⣤⣤⠄⠀⠒⠚⠻⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
28        ⠀⣼⡿⢋⣡⣴⣿⣿⣿⣿⡇⠀⢻⣿⣿⣿⣿⡿⠁⣠⣾⠘⣷⣦⢹⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
29        ⠘⢿⣾⣿⣿⣿⣿⣿⣿⡿⠧⠤⠚⠛⠉⢿⣿⠃⣸⣿⣿⡀⠹⣿⣧⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
30        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣄⣿⣿⣿⣧⠀⢻⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
31        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣇⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
32        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⢿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
33 
34 HarryPotterObamaSonic10Inu (ETHEREUM)
35 Telegram: https://t.me/Ethereum_Erc
36 Website:  https://hpos10ieth.com/
37 Twitter:  https://twitter.com/EthereumHpos10
38 **/
39 
40 // SPDX-License-Identifier: MIT
41 
42 
43 pragma solidity 0.8.20;
44 
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49 }
50 
51 interface IERC20 {
52     function totalSupply() external view returns (uint256);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval (address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 library SafeMath {
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66         return c;
67     }
68 
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         return sub(a, b, "SafeMath: subtraction overflow");
71     }
72 
73     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b <= a, errorMessage);
75         uint256 c = a - b;
76         return c;
77     }
78 
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         if (a == 0) {
81             return 0;
82         }
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85         return c;
86     }
87 
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
93         require(b > 0, errorMessage);
94         uint256 c = a / b;
95         return c;
96     }
97 
98 }
99 
100 contract Ownable is Context {
101     address private _owner;
102     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104     constructor () {
105         address msgSender = _msgSender();
106         _owner = msgSender;
107         emit OwnershipTransferred(address(0), msgSender);
108     }
109 
110     function owner() public view returns (address) {
111         return _owner;
112     }
113 
114     modifier onlyOwner() {
115         require(_owner == _msgSender(), "Ownable: caller is not the owner");
116         _;
117     }
118 
119     function renounceOwnership() public virtual onlyOwner {
120         emit OwnershipTransferred(_owner, address(0));
121         _owner = address(0);
122     }
123 
124 }
125 
126 interface IUniswapV2Factory {
127     function createPair(address tokenA, address tokenB) external returns (address pair);
128 }
129 
130 interface IUniswapV2Router02 {
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138     function factory() external pure returns (address);
139     function WETH() external pure returns (address);
140     function addLiquidityETH(
141         address token,
142         uint amountTokenDesired,
143         uint amountTokenMin,
144         uint amountETHMin,
145         address to,
146         uint deadline
147     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
148 }
149 
150 contract Ethereum is Context, IERC20, Ownable {
151     using SafeMath for uint256;
152     mapping (address => uint256) private _balances;
153     mapping (address => mapping (address => uint256)) private _allowances;
154     mapping (address => bool) private _isExcludedFromFee;
155     mapping (address => bool) private bots;
156     address payable private _taxWallet;
157     uint256 firstBlock;
158 
159     uint256 private _initialBuyTax=18;
160     uint256 private _initialSellTax=19;
161     uint256 private _finalBuyTax=0;
162     uint256 private _finalSellTax=0;
163     uint256 private _reduceBuyTaxAt=18;
164     uint256 private _reduceSellTaxAt=19;
165     uint256 private _preventSwapBefore=30;
166     uint256 private _buyCount=0;
167 
168     uint8 private constant _decimals = 9;
169     uint256 private constant _tTotal = 100000000 * 10**_decimals;
170     string private constant _name = unicode"HarryPotterObamaSonic10Inu";
171     string private constant _symbol = unicode"ETHEREUM";
172     uint256 public _maxTxAmount = 2000000 * 10**_decimals;
173     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
174     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
175     uint256 public _maxTaxSwap= 1000000 * 10**_decimals;
176 
177     IUniswapV2Router02 private uniswapV2Router;
178     address private uniswapV2Pair;
179     bool private tradingOpen;
180     bool private inSwap = false;
181     bool private swapEnabled = false;
182 
183     event MaxTxAmountUpdated(uint _maxTxAmount);
184     modifier lockTheSwap {
185         inSwap = true;
186         _;
187         inSwap = false;
188     }
189 
190     constructor () {
191 
192         _taxWallet = payable(_msgSender());
193         _balances[_msgSender()] = _tTotal;
194         _isExcludedFromFee[owner()] = true;
195         _isExcludedFromFee[address(this)] = true;
196         _isExcludedFromFee[_taxWallet] = true;
197 
198         emit Transfer(address(0), _msgSender(), _tTotal);
199     }
200 
201     function name() public pure returns (string memory) {
202         return _name;
203     }
204 
205     function symbol() public pure returns (string memory) {
206         return _symbol;
207     }
208 
209     function decimals() public pure returns (uint8) {
210         return _decimals;
211     }
212 
213     function totalSupply() public pure override returns (uint256) {
214         return _tTotal;
215     }
216 
217     function balanceOf(address account) public view override returns (uint256) {
218         return _balances[account];
219     }
220 
221     function transfer(address recipient, uint256 amount) public override returns (bool) {
222         _transfer(_msgSender(), recipient, amount);
223         return true;
224     }
225 
226     function allowance(address owner, address spender) public view override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     function approve(address spender, uint256 amount) public override returns (bool) {
231         _approve(_msgSender(), spender, amount);
232         return true;
233     }
234 
235     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
236         _transfer(sender, recipient, amount);
237         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
238         return true;
239     }
240 
241     function _approve(address owner, address spender, uint256 amount) private {
242         require(owner != address(0), "ERC20: approve from the zero address");
243         require(spender != address(0), "ERC20: approve to the zero address");
244         _allowances[owner][spender] = amount;
245         emit Approval(owner, spender, amount);
246     }
247 
248     function _transfer(address from, address to, uint256 amount) private {
249         require(from != address(0), "ERC20: transfer from the zero address");
250         require(to != address(0), "ERC20: transfer to the zero address");
251         require(amount > 0, "Transfer amount must be greater than zero");
252         uint256 taxAmount=0;
253         if (from != owner() && to != owner()) {
254             require(!bots[from] && !bots[to]);
255             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
256 
257             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
258                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
259                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
260 
261                 if (firstBlock + 3  > block.number) {
262                     require(!isContract(to));
263                 }
264                 _buyCount++;
265             }
266 
267             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
268                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
269             }
270 
271             if(to == uniswapV2Pair && from!= address(this) ){
272                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
273             }
274 
275             uint256 contractTokenBalance = balanceOf(address(this));
276             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
277                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
278                 uint256 contractETHBalance = address(this).balance;
279                 if(contractETHBalance > 0) {
280                     sendETHToFee(address(this).balance);
281                 }
282             }
283         }
284 
285         if(taxAmount>0){
286           _balances[address(this)]=_balances[address(this)].add(taxAmount);
287           emit Transfer(from, address(this),taxAmount);
288         }
289         _balances[from]=_balances[from].sub(amount);
290         _balances[to]=_balances[to].add(amount.sub(taxAmount));
291         emit Transfer(from, to, amount.sub(taxAmount));
292     }
293 
294 
295     function min(uint256 a, uint256 b) private pure returns (uint256){
296       return (a>b)?b:a;
297     }
298 
299     function isContract(address account) private view returns (bool) {
300         uint256 size;
301         assembly {
302             size := extcodesize(account)
303         }
304         return size > 0;
305     }
306 
307     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
308         address[] memory path = new address[](2);
309         path[0] = address(this);
310         path[1] = uniswapV2Router.WETH();
311         _approve(address(this), address(uniswapV2Router), tokenAmount);
312         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
313             tokenAmount,
314             0,
315             path,
316             address(this),
317             block.timestamp
318         );
319     }
320 
321     function removeLimits() external onlyOwner{
322         _maxTxAmount = _tTotal;
323         _maxWalletSize=_tTotal;
324         emit MaxTxAmountUpdated(_tTotal);
325     }
326 
327     function sendETHToFee(uint256 amount) private {
328         _taxWallet.transfer(amount);
329     }
330 
331     function addBots(address[] memory bots_) public onlyOwner {
332         for (uint i = 0; i < bots_.length; i++) {
333             bots[bots_[i]] = true;
334         }
335     }
336 
337     function delBots(address[] memory notbot) public onlyOwner {
338       for (uint i = 0; i < notbot.length; i++) {
339           bots[notbot[i]] = false;
340       }
341     }
342 
343     function isBot(address a) public view returns (bool){
344       return bots[a];
345     }
346 
347     function openTrading() external onlyOwner() {
348         require(!tradingOpen,"trading is already open");
349         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
350         _approve(address(this), address(uniswapV2Router), _tTotal);
351         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
352         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
353         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
354         swapEnabled = true;
355         tradingOpen = true;
356         firstBlock = block.number;
357     }
358 
359     receive() external payable {}
360 
361 }