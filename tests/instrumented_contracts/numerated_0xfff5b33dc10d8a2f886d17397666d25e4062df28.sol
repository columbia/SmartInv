1 // SPDX-License-Identifier: MIT
2 /**
3 
4 https://t.me/FrenERC20
5 
6 https://twitter.com/FrenERC20
7 
8 **/
9 
10 
11 pragma solidity 0.8.17;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor () {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92 }
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 }
117 
118 contract Fren is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _balances;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private bots;
124     mapping(address => uint256) private _holderLastTransferTimestamp;
125     bool public transferDelayEnabled = true;
126     address payable private _taxWallet;
127 
128     uint256 private _initialBuyTax=15;
129     uint256 private _initialSellTax=25;
130     uint256 private _finalBuyTax=0;
131     uint256 private _finalSellTax=0;
132     uint256 private _reduceBuyTaxAt=15;
133     uint256 private _reduceSellTaxAt=20;
134     uint256 private _preventSwapBefore=20;
135     uint256 private _buyCount=0;
136 
137     uint8 private constant _decimals = 9;
138     uint256 private constant _tTotal = 1000000 * 10**_decimals;
139     string private constant _name = unicode"Fren";
140     string private constant _symbol = unicode"Fren";
141     uint256 public _maxTxAmount = 20000 * 10**_decimals;
142     uint256 public _maxWalletSize = 20000 * 10**_decimals;
143     uint256 public _taxSwapThreshold= 20000 * 10**_decimals;
144     uint256 public _maxTaxSwap= 20000 * 10**_decimals;
145 
146     IUniswapV2Router02 private uniswapV2Router;
147     address private uniswapV2Pair;
148     bool private tradingOpen;
149     bool private inSwap = false;
150     bool private swapEnabled = false;
151 
152     event MaxTxAmountUpdated(uint _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158 
159     constructor () {
160         _taxWallet = payable(_msgSender());
161         _balances[_msgSender()] = _tTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_taxWallet] = true;
165 
166         emit Transfer(address(0), _msgSender(), _tTotal);
167     }
168 
169     function name() public pure returns (string memory) {
170         return _name;
171     }
172 
173     function symbol() public pure returns (string memory) {
174         return _symbol;
175     }
176 
177     function decimals() public pure returns (uint8) {
178         return _decimals;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return _balances[account];
187     }
188 
189     function transfer(address recipient, uint256 amount) public override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function _approve(address owner, address spender, uint256 amount) private {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214     }
215 
216     function _transfer(address from, address to, uint256 amount) private {
217         require(from != address(0), "ERC20: transfer from the zero address");
218         require(to != address(0), "ERC20: transfer to the zero address");
219         require(amount > 0, "Transfer amount must be greater than zero");
220         uint256 taxAmount=0;
221         if (from != owner() && to != owner()) {
222             require(!bots[from] && !bots[to]);
223             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
224 
225             if (transferDelayEnabled) {
226                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
227                       require(
228                           _holderLastTransferTimestamp[tx.origin] <
229                               block.number,
230                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
231                       );
232                       _holderLastTransferTimestamp[tx.origin] = block.number;
233                   }
234               }
235 
236             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
237                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
238                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
239                 _buyCount++;
240             }
241 
242             if(to == uniswapV2Pair && from!= address(this) ){
243                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
244             }
245 
246             uint256 contractTokenBalance = balanceOf(address(this));
247             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
248                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
249                 uint256 contractETHBalance = address(this).balance;
250                 if(contractETHBalance > 0) {
251                     sendETHToFee(address(this).balance);
252                 }
253             }
254         }
255 
256         if(taxAmount>0){
257           _balances[address(this)]=_balances[address(this)].add(taxAmount);
258           emit Transfer(from, address(this),taxAmount);
259         }
260         _balances[from]=_balances[from].sub(amount);
261         _balances[to]=_balances[to].add(amount.sub(taxAmount));
262         emit Transfer(from, to, amount.sub(taxAmount));
263     }
264 
265 
266     function min(uint256 a, uint256 b) private pure returns (uint256){
267       return (a>b)?b:a;
268     }
269 
270     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
271         address[] memory path = new address[](2);
272         path[0] = address(this);
273         path[1] = uniswapV2Router.WETH();
274         _approve(address(this), address(uniswapV2Router), tokenAmount);
275         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
276             tokenAmount,
277             0,
278             path,
279             address(this),
280             block.timestamp
281         );
282     }
283 
284     function removeLimits() external onlyOwner{
285         _maxTxAmount = _tTotal;
286         _maxWalletSize=_tTotal;
287         transferDelayEnabled=false;
288         emit MaxTxAmountUpdated(_tTotal);
289     }
290 
291     function sendETHToFee(uint256 amount) private {
292         _taxWallet.transfer(amount);
293     }
294 
295     function addBots(address[] memory bots_) public onlyOwner {
296         for (uint i = 0; i < bots_.length; i++) {
297             bots[bots_[i]] = true;
298         }
299     }
300 
301     function delBots(address[] memory notbot) public onlyOwner {
302       for (uint i = 0; i < notbot.length; i++) {
303           bots[notbot[i]] = false;
304       }
305     }
306 
307     function isBot(address a) public view returns (bool){
308       return bots[a];
309     }
310 
311     function openTrading() external onlyOwner() {
312         require(!tradingOpen,"trading is already open");
313         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
314         _approve(address(this), address(uniswapV2Router), _tTotal);
315         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
316         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
317         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
318         swapEnabled = true;
319         tradingOpen = true;
320     }
321 
322     
323     function reduceFee(uint256 _newFee) external{
324       require(_msgSender()==_taxWallet);
325       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
326       _finalBuyTax=_newFee;
327       _finalSellTax=_newFee;
328     }
329 
330     receive() external payable {}
331 
332     function manualSwap() external {
333         require(_msgSender()==_taxWallet);
334         uint256 tokenBalance=balanceOf(address(this));
335         if(tokenBalance>0){
336           swapTokensForEth(tokenBalance);
337         }
338         uint256 ethBalance=address(this).balance;
339         if(ethBalance>0){
340           sendETHToFee(ethBalance);
341         }
342     }
343 }