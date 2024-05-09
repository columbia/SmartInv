1 /**
2 */
3 // SPDX-License-Identifier: MIT
4 /**
5 
6 AMC
7 
8 https://t.me/AmcCoinEth
9 
10 0xbDADBF796ad5098698bFb86f851705ff0b6a9eE5
11 
12 **/
13 
14 pragma solidity 0.8.17;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         return c;
67     }
68 
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }
96 
97 interface IUniswapV2Factory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99 }
100 
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119 }
120 contract AMC is Context , IERC20, Ownable {
121     using SafeMath for uint256;
122     mapping (address => uint256) private _balances;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private bots;
126     mapping(address => uint256) private _holderLastTransferTimestamp;
127     bool public transferDelayEnabled = true;
128     address payable private _taxWallet;
129 
130     uint256 private _initialBuyTax=20;
131     uint256 private _initialSellTax=20;
132     uint256 private _finalBuyTax=0;
133     uint256 private _finalSellTax=0;
134     uint256 private _reduceBuyTaxAt=15;
135     uint256 private _reduceSellTaxAt=25;
136     uint256 private _preventSwapBefore=20;
137     uint256 private _buyCount=0;
138 
139     uint8 private constant _decimals = 9;
140     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
141     string private constant _name = unicode"AMC";
142     string private constant _symbol = unicode"AMC";
143     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
144     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
145     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
146     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
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
224             require(!bots[from] && !bots[to]);
225             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
226 
227             if (transferDelayEnabled) {
228                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
229                       require(
230                           _holderLastTransferTimestamp[tx.origin] <
231                               block.number,
232                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
233                       );
234                       _holderLastTransferTimestamp[tx.origin] = block.number;
235                   }
236               }
237 
238             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
239                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
240                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
241                 _buyCount++;
242             }
243 
244             if(to == uniswapV2Pair && from!= address(this) ){
245                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
246             }
247 
248             uint256 contractTokenBalance = balanceOf(address(this));
249             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
250                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
251                 uint256 contractETHBalance = address(this).balance;
252                 if(contractETHBalance > 0) {
253                     sendETHToFee(address(this).balance);
254                 }
255             }
256         }
257 
258         if(taxAmount>0){
259           _balances[address(this)]=_balances[address(this)].add(taxAmount);
260           emit Transfer(from, address(this),taxAmount);
261         }
262         _balances[from]=_balances[from].sub(amount);
263         _balances[to]=_balances[to].add(amount.sub(taxAmount));
264         emit Transfer(from, to, amount.sub(taxAmount));
265     }
266 
267 
268     function min(uint256 a, uint256 b) private pure returns (uint256){
269       return (a>b)?b:a;
270     }
271 
272     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = uniswapV2Router.WETH();
276         _approve(address(this), address(uniswapV2Router), tokenAmount);
277         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
278             tokenAmount,
279             0,
280             path,
281             address(this),
282             block.timestamp
283         );
284     }
285 
286     function removeLimits() external onlyOwner{
287         _maxTxAmount = _tTotal;
288         _maxWalletSize=_tTotal;
289         transferDelayEnabled=false;
290         emit MaxTxAmountUpdated(_tTotal);
291     }
292 
293     function sendETHToFee(uint256 amount) private {
294         _taxWallet.transfer(amount);
295     }
296 
297     function addBots(address[] memory bots_) public onlyOwner {
298         for (uint i = 0; i < bots_.length; i++) {
299             bots[bots_[i]] = true;
300         }
301     }
302 
303     function delBots(address[] memory notbot) public onlyOwner {
304       for (uint i = 0; i < notbot.length; i++) {
305           bots[notbot[i]] = false;
306       }
307     }
308 
309     function isBot(address a) public view returns (bool){
310       return bots[a];
311     }
312 
313     function openTrading() external onlyOwner() {
314         require(!tradingOpen,"trading is already open");
315         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
316         _approve(address(this), address(uniswapV2Router), _tTotal);
317         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
318         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
319         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
320         swapEnabled = true;
321         tradingOpen = true;
322     }
323 
324     
325     function reduceFee(uint256 _newFee) external{
326       require(_msgSender()==_taxWallet);
327       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
328       _finalBuyTax=_newFee;
329       _finalSellTax=_newFee;
330     }
331 
332     receive() external payable {}
333 
334     function manualSwap() external {
335         require(_msgSender()==_taxWallet);
336         uint256 tokenBalance=balanceOf(address(this));
337         if(tokenBalance>0){
338           swapTokensForEth(tokenBalance);
339         }
340         uint256 ethBalance=address(this).balance;
341         if(ethBalance>0){
342           sendETHToFee(ethBalance);
343         }
344     }
345 }