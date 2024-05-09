1 /**
2 
3 REMEMBER TO GO TO $CHURCH EVERY WEEK and pray to $JESUS and $GOD!
4 
5                   _|_
6                    |
7                   / \
8                  //_\\
9                 //(_)\\
10                  |/^\| 
11        ,%%%%     // \\    ,@@@@@@@,
12      ,%%%%/%%%  //   \\ ,@@@\@@@@/@@,
13  @@@%%%\%%//%%%// === \\ @@\@@@/@@@@@
14 @@@@%%%%\%%%%%// =-=-= \\@@@@\@@@@@@;%#####,
15 @@@@%%%\%%/%%//   ===   \\@@@@@@/@@@%%%######,
16 @@@@@%%%%/%%//|         |\\@\\//@@%%%%%%#/####
17 '@@@@@%%\\/%~ |         | ~ @|| %\\//%%%#####;
18   @@\\//@||   |  __ __  |    || %%||%%'######
19    '@||  ||   | |  |  | |    ||   ||##\//####
20      ||  ||   | | -|- | |    ||   ||'#||###'
21      ||  ||   |_|__|__|_|    ||   ||  ||
22      ||  ||_/`  =======  `\__||_._||  ||
23    __||_/`      =======            `\_||___
24 
25 https://twitter.com/ChurchErc20
26 https://t.me/ChurchPortal
27 https://Churcherc20.com
28 
29 **/
30 
31 pragma solidity 0.8.17;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 }
38 
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41     function balanceOf(address account) external view returns (uint256);
42     function transfer(address recipient, uint256 amount) external returns (bool);
43     function allowance(address owner, address spender) external view returns (uint256);
44     function approve(address spender, uint256 amount) external returns (bool);
45     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 library SafeMath {
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64         return c;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69             return 0;
70         }
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73         return c;
74     }
75 
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return div(a, b, "SafeMath: division by zero");
78     }
79 
80     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         return c;
84     }
85 
86 }
87 
88 contract Ownable is Context {
89     address private _owner;
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     constructor () {
93         address msgSender = _msgSender();
94         _owner = msgSender;
95         emit OwnershipTransferred(address(0), msgSender);
96     }
97 
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     modifier onlyOwner() {
103         require(_owner == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     function renounceOwnership() public virtual onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = address(0);
110     }
111 
112 }
113 
114 interface IUniswapV2Factory {
115     function createPair(address tokenA, address tokenB) external returns (address pair);
116 }
117 
118 interface IUniswapV2Router02 {
119     function swapExactTokensForETHSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external;
126     function factory() external pure returns (address);
127     function WETH() external pure returns (address);
128     function addLiquidityETH(
129         address token,
130         uint amountTokenDesired,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline
135     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
136 }
137 
138 contract CHURCH is Context, IERC20, Ownable {
139     using SafeMath for uint256;
140     mapping (address => uint256) private _balances;
141     mapping (address => mapping (address => uint256)) private _allowances;
142     mapping (address => bool) private _isExcludedFromFee;
143     mapping (address => bool) private bots;
144     mapping(address => uint256) private _holderLastTransferTimestamp;
145     bool public transferDelayEnabled = true;
146     address payable private _taxWallet;
147 
148     uint256 private _initialBuyTax=20;
149     uint256 private _initialSellTax=20;
150     uint256 private _finalBuyTax=0;
151     uint256 private _finalSellTax=0;
152     uint256 private _reduceBuyTaxAt=15;
153     uint256 private _reduceSellTaxAt=25;
154     uint256 private _preventSwapBefore=20;
155     uint256 private _buyCount=0;
156 
157     uint8 private constant _decimals = 9;
158     uint256 private constant _tTotal = 777777777777 * 10**_decimals;
159     string private constant _name = unicode"CHURCH"; 
160     string private constant _symbol = unicode"CHURCH"; 
161     uint256 public _maxTxAmount =   15555555555 * 10**_decimals;
162     uint256 public _maxWalletSize = 15555555555 * 10**_decimals;
163     uint256 public _taxSwapThreshold= 7777777777 * 10**_decimals;
164     uint256 public _maxTaxSwap= 7777777777 * 10**_decimals;
165 
166     IUniswapV2Router02 private uniswapV2Router;
167     address private uniswapV2Pair;
168     bool private tradingOpen;
169     bool private inSwap = false;
170     bool private swapEnabled = false;
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
185 
186         emit Transfer(address(0), _msgSender(), _tTotal);
187     }
188 
189     function name() public pure returns (string memory) {
190         return _name;
191     }
192 
193     function symbol() public pure returns (string memory) {
194         return _symbol;
195     }
196 
197     function decimals() public pure returns (uint8) {
198         return _decimals;
199     }
200 
201     function totalSupply() public pure override returns (uint256) {
202         return _tTotal;
203     }
204 
205     function balanceOf(address account) public view override returns (uint256) {
206         return _balances[account];
207     }
208 
209     function transfer(address recipient, uint256 amount) public override returns (bool) {
210         _transfer(_msgSender(), recipient, amount);
211         return true;
212     }
213 
214     function allowance(address owner, address spender) public view override returns (uint256) {
215         return _allowances[owner][spender];
216     }
217 
218     function approve(address spender, uint256 amount) public override returns (bool) {
219         _approve(_msgSender(), spender, amount);
220         return true;
221     }
222 
223     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
224         _transfer(sender, recipient, amount);
225         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
226         return true;
227     }
228 
229     function _approve(address owner, address spender, uint256 amount) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _transfer(address from, address to, uint256 amount) private {
237         require(from != address(0), "ERC20: transfer from the zero address");
238         require(to != address(0), "ERC20: transfer to the zero address");
239         require(amount > 0, "Transfer amount must be greater than zero");
240         uint256 taxAmount=0;
241         if (from != owner() && to != owner()) {
242             require(!bots[from] && !bots[to]);
243             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
244 
245             if (transferDelayEnabled) {
246                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
247                       require(
248                           _holderLastTransferTimestamp[tx.origin] <
249                               block.number,
250                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
251                       );
252                       _holderLastTransferTimestamp[tx.origin] = block.number;
253                   }
254               }
255 
256             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
257                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
258                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
259                 _buyCount++;
260             }
261 
262             if(to == uniswapV2Pair && from!= address(this) ){
263                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
264             }
265 
266             uint256 contractTokenBalance = balanceOf(address(this));
267             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
268                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
269                 uint256 contractETHBalance = address(this).balance;
270                 if(contractETHBalance > 0) {
271                     sendETHToFee(address(this).balance);
272                 }
273             }
274         }
275 
276         if(taxAmount>0){
277           _balances[address(this)]=_balances[address(this)].add(taxAmount);
278           emit Transfer(from, address(this),taxAmount);
279         }
280         _balances[from]=_balances[from].sub(amount);
281         _balances[to]=_balances[to].add(amount.sub(taxAmount));
282         emit Transfer(from, to, amount.sub(taxAmount));
283     }
284 
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
315     function addBots(address[] memory bots_) public onlyOwner {
316         for (uint i = 0; i < bots_.length; i++) {
317             bots[bots_[i]] = true;
318         }
319     }
320 
321     function delBots(address[] memory notbot) public onlyOwner {
322       for (uint i = 0; i < notbot.length; i++) {
323           bots[notbot[i]] = false;
324       }
325     }
326 
327     function isBot(address a) public view returns (bool){
328       return bots[a];
329     }
330 
331     function openTrading() external onlyOwner() {
332         require(!tradingOpen,"trading is already open");
333         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
334         _approve(address(this), address(uniswapV2Router), _tTotal);
335         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
336         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
337         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
338         swapEnabled = true;
339         tradingOpen = true;
340     }
341 
342     
343     function reduceFee(uint256 _newFee) external{
344       require(_msgSender()==_taxWallet);
345       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
346       _finalBuyTax=_newFee;
347       _finalSellTax=_newFee;
348     }
349 
350     receive() external payable {}
351 
352     function manualSwap() external {
353         require(_msgSender()==_taxWallet);
354         uint256 tokenBalance=balanceOf(address(this));
355         if(tokenBalance>0){
356           swapTokensForEth(tokenBalance);
357         }
358         uint256 ethBalance=address(this).balance;
359         if(ethBalance>0){
360           sendETHToFee(ethBalance);
361         }
362     }
363 }