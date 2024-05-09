1 /*
2 
3   Telegram: https://t.me/SnifferBotETH
4   Twitter:  https://twitter.com/SnifferBotETH
5   Website:  http://snifferboteth.com/
6   Bot:      https://t.me/sniffer_mint_wallet_bot
7 
8 */
9 
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity 0.8.21;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract SnifferBot is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping(address => uint256) private _holderLastTransferTimestamp;
125     bool public transferDelayEnabled = true;
126     address payable private _taxWallet;
127 
128     uint256 private _initialBuy = 15;
129     uint256 private _initialSell = 16;
130 
131     uint256 private _reduceTaxAt = 25;
132     uint256 private _initialTax2Time = 5;
133     uint256 private _reduceTaxAt2Time = 28;
134     uint256 private _finalTax = 5;
135     uint256 private _preventSwapBefore = 25;
136     uint256 private _buyCount=0;
137 
138     uint8 private constant _decimals = 9;
139     uint256 private constant _tTotal = 420_690_000_000 * 10**_decimals;
140     string private constant _name = unicode"SnifferBot";
141     string private constant _symbol = unicode"SBOT";
142 
143     uint256 public _maxTxAmount =  2 * (_tTotal/100);
144     uint256 public _maxWalletSize =  2 * (_tTotal/100);
145     uint256 public _taxSwapThreshold=  1 * (_tTotal/1000);
146     uint256 public _maxTaxSwap=  1 * (_tTotal/100);
147 
148     IUniswapV2Router02 private uniswapV2Router;
149     address private uniswapV2Pair;
150     bool private tradingOpen;
151     bool private inSwap = false;
152     bool private swapEnabled = false;
153 
154     event MaxTxAmountUpdated(uint _maxTxAmount);
155     modifier lockTheSwap {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160 
161     constructor () {
162         _taxWallet = payable(_msgSender());
163         _balances[_msgSender()] = _tTotal;
164         _isExcludedFromFee[owner()] = true;
165         _isExcludedFromFee[address(this)] = true;
166         _isExcludedFromFee[_taxWallet] = true;
167 
168         emit Transfer(address(0), _msgSender(), _tTotal);
169     }
170 
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint8) {
180         return _decimals;
181     }
182 
183     function totalSupply() public pure override returns (uint256) {
184         return _tTotal;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return _balances[account];
189     }
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210 
211     function _approve(address owner, address spender, uint256 amount) private {
212         require(owner != address(0), "ERC20: approve from the zero address");
213         require(spender != address(0), "ERC20: approve to the zero address");
214         _allowances[owner][spender] = amount;
215         emit Approval(owner, spender, amount);
216     }
217 
218     function _transfer(address from, address to, uint256 amount) private {
219         require(from != address(0), "ERC20: transfer from the zero address");
220         require(to != address(0), "ERC20: transfer to the zero address");
221         require(amount > 0, "Transfer amount must be greater than zero");
222         uint256 taxAmount=0;
223         if (from != owner() && to != owner()) {
224             taxAmount = amount.mul(_taxBuy()).div(100);
225 
226             if (transferDelayEnabled) {
227                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
228                       require(
229                           _holderLastTransferTimestamp[tx.origin] <
230                               block.number,
231                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
232                       );
233                       _holderLastTransferTimestamp[tx.origin] = block.number;
234                   }
235               }
236 
237             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
238                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
239                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
240                 _buyCount++;
241             }
242 
243             if(to == uniswapV2Pair && from!= address(this) ){
244                 taxAmount = amount.mul(_taxSell()).div(100);
245             }
246 
247             uint256 contractTokenBalance = balanceOf(address(this));
248             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
249                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
250                 uint256 contractETHBalance = address(this).balance;
251                 if(contractETHBalance > 50000000000000000) {
252                     sendETHToFee(address(this).balance);
253                 }
254             }
255         }
256 
257         if(taxAmount>0){
258           _balances[address(this)]=_balances[address(this)].add(taxAmount);
259           emit Transfer(from, address(this),taxAmount);
260         }
261         _balances[from]=_balances[from].sub(amount);
262         _balances[to]=_balances[to].add(amount.sub(taxAmount));
263         emit Transfer(from, to, amount.sub(taxAmount));
264     }
265 
266     function _taxBuy() private view returns (uint256) {
267         if(_buyCount <= _reduceTaxAt){
268             return _initialBuy;
269         }
270         if(_buyCount > _reduceTaxAt && _buyCount <= _reduceTaxAt2Time){
271             return _initialTax2Time;
272         }
273          return _finalTax;
274     }
275 
276     function _taxSell() private view returns (uint256) {
277         if(_buyCount <= _reduceTaxAt){
278             return _initialSell;
279         }
280         if(_buyCount > _reduceTaxAt && _buyCount <= _reduceTaxAt2Time){
281             return _initialTax2Time;
282         }
283          return _finalTax;
284     }
285 
286     function min(uint256 a, uint256 b) private pure returns (uint256){
287       return (a>b)?b:a;
288     }
289 
290     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
291         address[] memory path = new address[](2);
292         path[0] = address(this);
293         path[1] = uniswapV2Router.WETH();
294         _approve(address(this), address(uniswapV2Router), tokenAmount);
295         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
296             tokenAmount,
297             0,
298             path,
299             address(this),
300             block.timestamp
301         );
302     }
303 
304     function removeLimits() external onlyOwner{
305         _maxTxAmount = _tTotal;
306         _maxWalletSize=_tTotal;
307         transferDelayEnabled=false;
308         emit MaxTxAmountUpdated(_tTotal);
309     }
310 
311     function sendETHToFee(uint256 amount) private {
312         _taxWallet.transfer(amount);
313     }
314 
315 
316     function openTrading() external onlyOwner() {
317         require(!tradingOpen,"trading is already open");
318         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
319         _approve(address(this), address(uniswapV2Router), _tTotal);
320         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
321         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
322         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
323         swapEnabled = true;
324         tradingOpen = true;
325     }
326 
327     receive() external payable {}
328 
329     function manualSwap() external {
330         require(_msgSender()==_taxWallet);
331         uint256 tokenBalance=balanceOf(address(this));
332         if(tokenBalance>0){
333           swapTokensForEth(tokenBalance);
334         }
335         uint256 ethBalance=address(this).balance;
336         if(ethBalance>0){
337           sendETHToFee(ethBalance);
338         }
339     }
340 }