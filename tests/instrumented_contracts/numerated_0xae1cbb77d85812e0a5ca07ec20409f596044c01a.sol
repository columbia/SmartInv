1 /**
2 
3 ▒▒▒▒▒▄██████████▄▒▒▒▒▒
4 ▒▒▒▄██████████████▄▒▒▒
5 ▒▒██████████████████▒▒
6 ▒▐███▀▀▀▀▀██▀▀▀▀▀███▌▒
7 ▒███▒▒▌■▐▒▒▒▒▌■▐▒▒███▒
8 ▒▐██▄▒▀▀▀▒▒▒▒▀▀▀▒▄██▌▒
9 ▒▒▀████▒▄▄▒▒▄▄▒████▀▒▒
10 ▒▒▐███▒▒▒▀▒▒▀▒▒▒███▌▒▒
11 ▒▒███▒▒▒▒▒▒▒▒▒▒▒▒███▒▒
12 ▒▒▒██▒▒▀▀▀▀▀▀▀▀▒▒██▒▒▒
13 ▒▒▒▐██▄▒▒▒▒▒▒▒▒▄██▌▒▒▒
14 ▒▒▒▒▀████████████▀▒▒▒▒
15 
16 YOU GUYS GAVE $20 MILLION TO A FUCKING APE  
17 
18 MISSED $BEN, $PSYOP, $LOYAL, $FINALE, AND #FF6000? DON'T MISS $MILKIT
19 
20 THE COMBINED MILKING POWER OF ALL OF THEM!
21 
22 https://www.milkit.vip
23 
24 https://twitter.com/MILKITCOIN
25 
26 https://t.me/MILKITCOIN
27 
28 */
29 pragma solidity 0.8.17;
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 }
36 
37 interface IERC20 {
38     function totalSupply() external view returns (uint256);
39     function balanceOf(address account) external view returns (uint256);
40     function transfer(address recipient, uint256 amount) external returns (bool);
41     function allowance(address owner, address spender) external view returns (uint256);
42     function approve(address spender, uint256 amount) external returns (bool);
43     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 library SafeMath {
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52         return c;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58 
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62         return c;
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         return div(a, b, "SafeMath: division by zero");
76     }
77 
78     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b > 0, errorMessage);
80         uint256 c = a / b;
81         return c;
82     }
83 
84 }
85 
86 contract Ownable is Context {
87     address private _owner;
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     constructor () {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     modifier onlyOwner() {
101         require(_owner == _msgSender(), "Ownable: caller is not the owner");
102         _;
103     }
104 
105     function renounceOwnership() public virtual onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110 }
111 
112 interface IUniswapV2Factory {
113     function createPair(address tokenA, address tokenB) external returns (address pair);
114 }
115 
116 interface IUniswapV2Router02 {
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint amountIn,
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external;
124     function factory() external pure returns (address);
125     function WETH() external pure returns (address);
126     function addLiquidityETH(
127         address token,
128         uint amountTokenDesired,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline
133     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
134 }
135 
136 contract MILKIT is Context, IERC20, Ownable {
137     using SafeMath for uint256;
138     mapping (address => uint256) private _balances;
139     mapping (address => mapping (address => uint256)) private _allowances;
140     mapping (address => bool) private _isExcludedFromFee;
141     mapping (address => bool) private bots;
142     mapping(address => uint256) private _holderLastTransferTimestamp;
143     bool public transferDelayEnabled = true;
144     address payable private _taxWallet;
145 
146     uint256 private _initialBuyTax=26;
147     uint256 private _initialSellTax=26;
148     uint256 private _finalBuyTax=0;
149     uint256 private _finalSellTax=0;
150     uint256 private _reduceBuyTaxAt=18;
151     uint256 private _reduceSellTaxAt=25;
152     uint256 private _preventSwapBefore=20;
153     uint256 private _buyCount=0;
154 
155     uint8 private constant _decimals = 9;
156     uint256 private constant _tTotal = 420420420420 * 10**_decimals;
157     string private constant _name = unicode"BenPysopLoyalFinaleFF6000Inu"; 
158     string private constant _symbol = unicode"MILKIT"; 
159     uint256 public _maxTxAmount =    6000000000 * 10**_decimals;
160     uint256 public _maxWalletSize = 6000000000 * 10**_decimals;
161     uint256 public _taxSwapThreshold= 2000000000 * 10**_decimals;
162     uint256 public _maxTaxSwap= 2000000000 * 10**_decimals;
163 
164     IUniswapV2Router02 private uniswapV2Router;
165     address private uniswapV2Pair;
166     bool private tradingOpen;
167     bool private inSwap = false;
168     bool private swapEnabled = false;
169 
170     address private _uncxLocker = 0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214;
171 
172     event MaxTxAmountUpdated(uint _maxTxAmount);
173     modifier lockTheSwap {
174         inSwap = true;
175         _;
176         inSwap = false;
177     }
178 
179     constructor () {
180         _taxWallet = payable(_msgSender());
181         _balances[_msgSender()] = _tTotal;
182         _isExcludedFromFee[owner()] = true;
183         _isExcludedFromFee[address(this)] = true;
184         _isExcludedFromFee[_taxWallet] = true;
185         _isExcludedFromFee[_uncxLocker] = true;
186 
187         emit Transfer(address(0), _msgSender(), _tTotal);
188     }
189 
190     function name() public pure returns (string memory) {
191         return _name;
192     }
193 
194     function symbol() public pure returns (string memory) {
195         return _symbol;
196     }
197 
198     function decimals() public pure returns (uint8) {
199         return _decimals;
200     }
201 
202     function totalSupply() public pure override returns (uint256) {
203         return _tTotal;
204     }
205 
206     function balanceOf(address account) public view override returns (uint256) {
207         return _balances[account];
208     }
209 
210     function transfer(address recipient, uint256 amount) public override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     function allowance(address owner, address spender) public view override returns (uint256) {
216         return _allowances[owner][spender];
217     }
218 
219     function approve(address spender, uint256 amount) public override returns (bool) {
220         _approve(_msgSender(), spender, amount);
221         return true;
222     }
223 
224     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
225         _transfer(sender, recipient, amount);
226         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
227         return true;
228     }
229 
230     function _approve(address owner, address spender, uint256 amount) private {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237     function _transfer(address from, address to, uint256 amount) private {
238         require(from != address(0), "ERC20: transfer from the zero address");
239         require(to != address(0), "ERC20: transfer to the zero address");
240         require(amount > 0, "Transfer amount must be greater than zero");
241         uint256 taxAmount=0;
242         if (from != owner() && to != owner()) {
243             require(!bots[from] && !bots[to]);
244             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
245 
246             if (transferDelayEnabled) {
247                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
248                       require(
249                           _holderLastTransferTimestamp[tx.origin] <
250                               block.number,
251                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
252                       );
253                       _holderLastTransferTimestamp[tx.origin] = block.number;
254                   }
255               }
256 
257             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
258                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
259                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
260                 _buyCount++;
261             }
262 
263             if(to == uniswapV2Pair && from!= address(this) ){
264                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
265             }
266 
267             uint256 contractTokenBalance = balanceOf(address(this));
268             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
269                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
270                 uint256 contractETHBalance = address(this).balance;
271                 if(contractETHBalance > 0) {
272                     sendETHToFee(address(this).balance);
273                 }
274             }
275         }
276 
277         if(taxAmount>0){
278           _balances[address(this)]=_balances[address(this)].add(taxAmount);
279           emit Transfer(from, address(this),taxAmount);
280         }
281         _balances[from]=_balances[from].sub(amount);
282         _balances[to]=_balances[to].add(amount.sub(taxAmount));
283         emit Transfer(from, to, amount.sub(taxAmount));
284     }
285 
286 
287     function min(uint256 a, uint256 b) private pure returns (uint256){
288       return (a>b)?b:a;
289     }
290 
291     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
292         address[] memory path = new address[](2);
293         path[0] = address(this);
294         path[1] = uniswapV2Router.WETH();
295         _approve(address(this), address(uniswapV2Router), tokenAmount);
296         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
297             tokenAmount,
298             0,
299             path,
300             address(this),
301             block.timestamp
302         );
303     }
304 
305     function removeLimits() external onlyOwner{
306         _maxTxAmount = _tTotal;
307         _maxWalletSize=_tTotal;
308         transferDelayEnabled=false;
309         emit MaxTxAmountUpdated(_tTotal);
310     }
311 
312     function sendETHToFee(uint256 amount) private {
313         _taxWallet.transfer(amount);
314     }
315 
316     function addBots(address[] memory bots_) public onlyOwner {
317         for (uint i = 0; i < bots_.length; i++) {
318             bots[bots_[i]] = true;
319         }
320     }
321 
322     function delBots(address[] memory notbot) public onlyOwner {
323       for (uint i = 0; i < notbot.length; i++) {
324           bots[notbot[i]] = false;
325       }
326     }
327 
328     function isBot(address a) public view returns (bool){
329       return bots[a];
330     }
331 
332     function openTrading() external onlyOwner() {
333         require(!tradingOpen,"trading is already open");
334         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
335         _approve(address(this), address(uniswapV2Router), _tTotal);
336         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
337         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
338         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
339         swapEnabled = true;
340         tradingOpen = true;
341     }
342 
343     
344     function reduceFee(uint256 _newFee) external{
345       require(_msgSender()==_taxWallet);
346       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
347       _finalBuyTax=_newFee;
348       _finalSellTax=_newFee;
349     }
350 
351     receive() external payable {}
352 
353     function manualSwap() external {
354         require(_msgSender()==_taxWallet);
355         uint256 tokenBalance=balanceOf(address(this));
356         if(tokenBalance>0){
357           swapTokensForEth(tokenBalance);
358         }
359         uint256 ethBalance=address(this).balance;
360         if(ethBalance>0){
361           sendETHToFee(ethBalance);
362         }
363     }
364 }