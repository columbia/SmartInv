1 /**
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⠉⠀⠀⠀⠈⠀⠰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠓⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠈⠢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⡠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⡀⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠐⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⢀⠤⠈⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⡀⠀⠀⠀⠀⠀⠀
10 ⠀⡠⠉⣀⠤⣄⡤⣴⣖⣷⣿⣼⣿⣧⣿⣽⣿⣷⣿⣿⣾⣿⣿⣷⣷⣶⣶⣴⣦⣴⣠⣀⠀ ⠘⢆⠀⠀⠀⠀⠀
11 ⠰⡱⢾⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣄⠈⢂⠀⠀⠀⠀
12 ⠠⣳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣗⠜⠀⠀⠀⠀
13 ⠀⠀⠋⠟⡻⢿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡯⡣⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⡟⠋⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠇⠁⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⢻⠛⠁⠀⠰⣿⡟⠟⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢏⢱⣤⠋⠀⢤⠀⢀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⡅⢲⣶⣷⣿⣶⢏⡤⣠⣙⡾⣿⣿⢿⣟⡿⣽⢋⣞⠯⠳⠉⠐⠛⠁⠀⢀⣾⣗⠩⠆⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠲⡞⣽⣿⡿⣧⣿⣿⣿⣿⣿⡝⣮⢻⡝⢜⣢⠯⠁⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⠙⢍⠿⠟⡻⢽⡻⣵⣿⣾⡷⣞⢫⣅⠀⠀⠀⠀⠀⠀⢀⡾⠉⣧⣿⣿⠀⡆⢄⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠜⢳⣿⣿⢿⣱⣿⡿⢻⡿⣷⣶⣶⡶⠚⠁⠀⣼⣿⣿⣟⣡⠌⢢⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠽⠣⣯⣿⡟⠯⢟⡰⡉⠛⣿⣿⣷⡄⠀⠀⣽⣿⣿⣿⣯⣶⠄⡅
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠊⡀⠀⢀⣠⠞⠋⢤⣋⣟⣹⣿⣷⣙⡌⠻⣿⡁⠀⣾⣿⣿⣿⣿⣿⣿⣟⠇
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⢐⡱⢮⡀⣠⡟⢀⠰⣘⣶⣽⣾⣿⣿⣯⣿⣿⣶⣤⠍⢢⣿⣿⣿⣿⣿⣿⢛⠎⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⢁⡤⠙⠖⡟⣨⠏⠀⠀⣋⠽⣾⣿⣿⣿⣿⡟⡏⠋⠈⠻⣷⡄⢫⠁⠋⠉⠉⠒⠁⠀⠀
24 ⠀⠀⠀⠀⠀⣀⠤⠊⠀⠀⠊⢖⠉⠀⣔⠆⠀⢀⠰⣌⢷⡻⣞⡿⣿⣽⣿⣗⠀⠀⠀⠐⣿⣵⣅⢠⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠰⠁⡀⣤⡤⣴⡄⣝⠀⠀⡚⠀⠀⢂⠱⢊⡾⣹⣽⢻⢟⠿⢛⡊⠸⡀⠀⠀⢸⣿⣿⣦⢹⣦⣔⣠⠀⠀
26 ⠀⠀⠀⠀⢣⢂⣼⡗⠀⠘⣴⢛⠀⠀⠇⢄⢀⠆⡜⠎⢶⡣⢋⠥⠢⠗⠑⠀⠀⠱⣶⠀⠈⠻⣿⣿⣿⣷⣱⢻⠄⠀
27 ⠀⠀⠀⠀⠙⣹⣿⠀⠀⠀⠁⠀⠀⠀⠄⠁⠁⠊⡒⠈⣄⡹⠀⠁⠁⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠙⢽⢯⣿⢶⠃⠀
28 ⠀⠀⠀⠀⠀⠋⠘⠀⠀⠀⠀⠀⠀⠀⠀⠈⢢⠘⠉⠘⡝⠀⠀⠀⠀⠀⠀⡀⠀⠚⠀⠀⠲⣀⠀⠀⠀⠈⠂⠉⠀⠀
29 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠢⡘⠎⠀⠀⠀⠀⡀⢀⢔⡔⡉⢀⡰⢠⢀⠌⡄⠀⠀⠀⠀⠀⠀⠀
30 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⢀⢀⠀⠠⠊⣛⠕⣎⣤⣆⠍⠒⠉⡆⢡⠌⡄⠀⠀⠀⠀⠀⠀
31 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠁⠐⠚⠁⠜⠉⠀⢀⠡⢸⡀⠠⢰⠀⠀⠀⠀⠀⠀
32 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠄⠂⠀⡄⠄⠀⠀⠈⡀⠀⠀⠀⢰⠀⠀⠸⠀⠀⣀⣂⢈⣠⢿⣻⢶⡂⠀⠀⠀⠀⠀
33 ⠀⠀⠀⠀⠀⠀⠀⠀⢰⠉⢄⣠⡡⡐⠀⢄⠠⠀⠠⠀⠀⢀⠀⠈⠀⠀⠘⢤⢤⣲⣯⣟⣮⣿⢾⠿⠀⠀⠀⠀⠀⠀
34 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠮⡻⣿⣷⣿⣞⣳⣬⣵⣒⠄⣄⠀⠀⠀⠀⠀⠀⠀⠁⠁⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
35 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⠙⠛⠿⠿⣿⢷⣧⣷⣦⡎⣅⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
36 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
37 Meet SMURFCAT, known as шайлушай or Shailushai on TikTok. 
38 Brought to life by Nate Hallinan in 2014, we farewell the Matt Furie META and welcome SMURFCAT!
39 Time for a new artist to be cherished in the space.
40 
41 Socials:
42 Website: https://smurfcaterc.com
43 Telegram: https://t.me/smurfcaterc
44 Twitter: https://twitter.com/smurfcaterc
45 */
46 
47 // SPDX-License-Identifier: MIT
48 
49 pragma solidity 0.8.20;
50 
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 }
56 
57 interface IERC20 {
58     function totalSupply() external view returns (uint256);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 library SafeMath {
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a, "SafeMath: addition overflow");
72         return c;
73     }
74 
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b <= a, errorMessage);
81         uint256 c = a - b;
82         return c;
83     }
84 
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         if (a == 0) {
87             return 0;
88         }
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91         return c;
92     }
93 
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         require(b > 0, errorMessage);
100         uint256 c = a / b;
101         return c;
102     }
103 
104 }
105 
106 
107 contract Ownable is Context {
108     address private _owner;
109     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111     constructor () {
112         address msgSender = _msgSender();
113         _owner = msgSender;
114         emit OwnershipTransferred(address(0), msgSender);
115     }
116 
117     function owner() public view returns (address) {
118         return _owner;
119     }
120 
121     modifier onlyOwner() {
122         require(_owner == _msgSender(), "Ownable: caller is not the owner");
123         _;
124     }
125 
126     function renounceOwnership() public virtual onlyOwner {
127         emit OwnershipTransferred(_owner, address(0));
128         _owner = address(0);
129     }
130 
131 }
132 
133 
134 interface IUniswapV2Factory {
135     function createPair(address tokenA, address tokenB) external returns (address pair);
136 }
137 
138 interface IUniswapV2Router02 {
139     function swapExactTokensForETHSupportingFeeOnTransferTokens(
140         uint amountIn,
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external;
146     function factory() external pure returns (address);
147     function WETH() external pure returns (address);
148     function addLiquidityETH(
149         address token,
150         uint amountTokenDesired,
151         uint amountTokenMin,
152         uint amountETHMin,
153         address to,
154         uint deadline
155     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
156 }
157 
158 
159 contract SmurfCat is Context, IERC20, Ownable {
160     using SafeMath for uint256;
161     mapping (address => uint256) private _balances;
162     mapping (address => mapping (address => uint256)) private _allowances;
163     mapping (address => bool) private _isExcludedFromFee;
164     mapping (address => bool) private bots;
165     mapping(address => uint256) private _holderLastTransferTimestamp;
166     bool public transferDelayEnabled = false;
167     address payable private _taxWallet;
168 
169     uint256 private _initialBuyTax=20;
170     uint256 private _initialSellTax=20;
171     uint256 private _finalBuyTax=1;
172     uint256 private _finalSellTax=1;
173     uint256 private _reduceBuyTaxAt=20;
174     uint256 private _reduceSellTaxAt=20;
175     uint256 private _preventSwapBefore=30;
176     uint256 private _buyCount=0;
177 
178     uint8 private constant _decimals = 8;
179     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
180     string private constant _name = unicode"SMURFCAT";
181     string private constant _symbol = unicode"SMURFCAT";
182     uint256 public _maxTxAmount =   17000000 * 10**_decimals;
183     uint256 public _maxWalletSize = 17000000 * 10**_decimals;
184     uint256 public _taxSwapThreshold=0 * 10**_decimals;
185     uint256 public _maxTaxSwap=8000000 * 10**_decimals;
186 
187     IUniswapV2Router02 private uniswapV2Router;
188     address private uniswapV2Pair;
189     bool private tradingOpen;
190     bool private inSwap = false;
191     bool private swapEnabled = false;
192 
193     event MaxTxAmountUpdated(uint _maxTxAmount);
194     modifier lockTheSwap {
195         inSwap = true;
196         _;
197         inSwap = false;
198     }
199 
200 
201     constructor () {
202         _taxWallet = payable(_msgSender());
203         _balances[_msgSender()] = _tTotal;
204         _isExcludedFromFee[owner()] = true;
205         _isExcludedFromFee[address(this)] = true;
206         _isExcludedFromFee[_taxWallet] = true;
207 
208         emit Transfer(address(0), _msgSender(), _tTotal);
209     }
210 
211     function name() public pure returns (string memory) {
212         return _name;
213     }
214 
215     function symbol() public pure returns (string memory) {
216         return _symbol;
217     }
218 
219     function decimals() public pure returns (uint8) {
220         return _decimals;
221     }
222 
223     function totalSupply() public pure override returns (uint256) {
224         return _tTotal;
225     }
226 
227 
228     function balanceOf(address account) public view override returns (uint256) {
229         return _balances[account];
230     }
231 
232     function transfer(address recipient, uint256 amount) public override returns (bool) {
233         _transfer(_msgSender(), recipient, amount);
234         return true;
235     }
236 
237     function allowance(address owner, address spender) public view override returns (uint256) {
238         return _allowances[owner][spender];
239     }
240 
241     function approve(address spender, uint256 amount) public override returns (bool) {
242         _approve(_msgSender(), spender, amount);
243         return true;
244     }
245 
246     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
247         _transfer(sender, recipient, amount);
248         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
249         return true;
250     }
251 
252     function _approve(address owner, address spender, uint256 amount) private {
253         require(owner != address(0), "ERC20: approve from the zero address");
254         require(spender != address(0), "ERC20: approve to the zero address");
255         _allowances[owner][spender] = amount;
256         emit Approval(owner, spender, amount);
257     }
258 
259 
260     function _transfer(address from, address to, uint256 amount) private {
261         require(from != address(0), "ERC20: transfer from the zero address");
262         require(to != address(0), "ERC20: transfer to the zero address");
263         require(amount > 0, "Transfer amount must be greater than zero");
264         uint256 taxAmount=0;
265         if (from != owner() && to != owner()) {
266             require(!bots[from] && !bots[to]);
267 
268             if (transferDelayEnabled) {
269                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
270                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
271                   _holderLastTransferTimestamp[tx.origin] = block.number;
272                 }
273             }
274 
275             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
276                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
277                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
278                 if(_buyCount<_preventSwapBefore){
279                   require(!isContract(to));
280                 }
281                 _buyCount++;
282             }
283 
284 
285             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
286             if(to == uniswapV2Pair && from!= address(this) ){
287                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
288                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
289             }
290 
291             uint256 contractTokenBalance = balanceOf(address(this));
292             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
293                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
294                 uint256 contractETHBalance = address(this).balance;
295                 if(contractETHBalance > 0) {
296                     sendETHToFee(address(this).balance);
297                 }
298             }
299         }
300 
301         if(taxAmount>0){
302           _balances[address(this)]=_balances[address(this)].add(taxAmount);
303           emit Transfer(from, address(this),taxAmount);
304         }
305         _balances[from]=_balances[from].sub(amount);
306         _balances[to]=_balances[to].add(amount.sub(taxAmount));
307         emit Transfer(from, to, amount.sub(taxAmount));
308     }
309 
310 
311     function min(uint256 a, uint256 b) private pure returns (uint256){
312       return (a>b)?b:a;
313     }
314 
315     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
316         if(tokenAmount==0){return;}
317         if(!tradingOpen){return;}
318         address[] memory path = new address[](2);
319         path[0] = address(this);
320         path[1] = uniswapV2Router.WETH();
321         _approve(address(this), address(uniswapV2Router), tokenAmount);
322         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
323             tokenAmount,
324             0,
325             path,
326             address(this),
327             block.timestamp
328         );
329     }
330 
331     function removeLimits() external onlyOwner{
332         _maxTxAmount = _tTotal;
333         _maxWalletSize=_tTotal;
334         transferDelayEnabled=false;
335         emit MaxTxAmountUpdated(_tTotal);
336     }
337 
338     function sendETHToFee(uint256 amount) private {
339         _taxWallet.transfer(amount);
340     }
341 
342     function isBot(address a) public view returns (bool){
343       return bots[a];
344     }
345 
346     function openTrading() external onlyOwner() {
347         require(!tradingOpen,"trading is already open");
348         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
349         _approve(address(this), address(uniswapV2Router), _tTotal);
350         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
351         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
352         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
353         swapEnabled = true;
354         tradingOpen = true;
355     }
356 
357 
358     receive() external payable {}
359 
360     function isContract(address account) private view returns (bool) {
361         uint256 size;
362         assembly {
363             size := extcodesize(account)
364         }
365         return size > 0;
366     }
367 
368     function manualSwap() external {
369         require(_msgSender()==_taxWallet);
370         uint256 tokenBalance=balanceOf(address(this));
371         if(tokenBalance>0){
372           swapTokensForEth(tokenBalance);
373         }
374         uint256 ethBalance=address(this).balance;
375         if(ethBalance>0){
376           sendETHToFee(ethBalance);
377         }
378     }
379 
380     
381     
382     
383 }