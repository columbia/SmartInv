1 // $UNISHIB
2 
3 // Website: https://unishib.io/
4 
5 // X: https://twitter.com/Unishib_Eth
6 
7 // Telegram Chat: https://t.me/UniShibPortal
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity 0.8.17;
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
90 
91 }
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 }
96 
97 interface IUniswapV2Router02 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115 }
116 contract UNISHIB is Context , IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping (address => bool) private bots;
122     mapping(address => uint256) private _holderLastTransferTimestamp;
123     bool public transferDelayEnabled = true;
124     address payable private _taxWallet;
125     uint256 private _initialBuyTax=25;
126     uint256 private _initialSellTax=35;
127     uint256 private _finalBuyTax=5;
128     uint256 private _finalSellTax=5;
129     uint256 private _reduceBuyTaxAt=25;
130     uint256 private _reduceSellTaxAt=25; 
131     uint256 private _preventSwapBefore=30;
132     uint256 private _buyCount=0;
133 
134     uint8 private constant _decimals = 9;
135     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
136     string private constant _name = "UNISHIB";
137     string private constant _symbol = "UNISHIB";
138     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
139     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
140     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
141     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
142 
143     IUniswapV2Router02 private uniswapV2Router;
144     address private uniswapV2Pair;
145     bool private tradingOpen;
146     bool private inSwap = false;
147     bool private swapEnabled = false;
148 
149     event MaxTxAmountUpdated(uint _maxTxAmount);
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155 
156     constructor () {
157         _taxWallet = payable(_msgSender());
158         _balances[_msgSender()] = _tTotal;
159         _isExcludedFromFee[owner()] = true;
160         _isExcludedFromFee[address(this)] = true;
161         _isExcludedFromFee[_taxWallet] = true;
162 
163         emit Transfer(address(0), _msgSender(), _tTotal);
164     }
165 
166     function name() public pure returns (string memory) {
167         return _name;
168     }
169 
170     function symbol() public pure returns (string memory) {
171         return _symbol;
172     }
173 
174     function decimals() public pure returns (uint8) {
175         return _decimals;
176     }
177 
178     function totalSupply() public pure override returns (uint256) {
179         return _tTotal;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return _balances[account];
184     }
185 
186     function transfer(address recipient, uint256 amount) public override returns (bool) {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     function allowance(address owner, address spender) public view override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     function approve(address spender, uint256 amount) public override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
201         _transfer(sender, recipient, amount);
202         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
203         return true;
204     }
205 
206     function _approve(address owner, address spender, uint256 amount) private {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _transfer(address from, address to, uint256 amount) private {
214         require(from != address(0), "ERC20: transfer from the zero address");
215         require(to != address(0), "ERC20: transfer to the zero address");
216         require(amount > 0, "Transfer amount must be greater than zero");
217         uint256 taxAmount=0;
218         if (from != owner() && to != owner()) {
219             require(!bots[from] && !bots[to]);
220             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
221 
222             if (transferDelayEnabled) {
223                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
224                       require(
225                           _holderLastTransferTimestamp[tx.origin] <
226                               block.number,
227                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
228                       );
229                       _holderLastTransferTimestamp[tx.origin] = block.number;
230                   }
231               }
232               if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
233                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
234                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
235                 _buyCount++;
236             }
237 
238             if(to == uniswapV2Pair && from!= address(this) ){
239                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
240             }
241 
242             uint256 contractTokenBalance = balanceOf(address(this));
243             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
244                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
245                 uint256 contractETHBalance = address(this).balance;
246                 if(contractETHBalance > 0) {
247                     sendETHToFee(address(this).balance);
248                 }
249             }
250         }
251 
252         if(taxAmount>0){
253           _balances[address(this)]=_balances[address(this)].add(taxAmount);
254           emit Transfer(from, address(this),taxAmount);
255         }
256         _balances[from]=_balances[from].sub(amount);
257         _balances[to]=_balances[to].add(amount.sub(taxAmount));
258         emit Transfer(from, to, amount.sub(taxAmount));
259     }
260 
261 
262     function min(uint256 a, uint256 b) private pure returns (uint256){
263       return (a>b)?b:a;
264     }
265 
266     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
267         address[] memory path = new address[](2);
268         path[0] = address(this);
269         path[1] = uniswapV2Router.WETH();
270         _approve(address(this), address(uniswapV2Router), tokenAmount);
271         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
272             tokenAmount,
273             0,
274             path,
275             address(this),
276             block.timestamp
277         );
278     }
279 
280     function removeLimits() external onlyOwner{
281         _maxTxAmount = _tTotal;
282         _maxWalletSize=_tTotal;
283         transferDelayEnabled=false;
284         emit MaxTxAmountUpdated(_tTotal);
285     }
286 
287     function sendETHToFee(uint256 amount) private {
288         _taxWallet.transfer(amount);
289     }
290 
291     function addBots(address[] memory bots_) public onlyOwner {
292         for (uint i = 0; i < bots_.length; i++) {
293             bots[bots_[i]] = true;
294         }
295     }
296 
297     function delBots(address[] memory notbot) public onlyOwner {
298       for (uint i = 0; i < notbot.length; i++) {
299           bots[notbot[i]] = false;
300       }
301     }
302 
303     function isBot(address a) public view returns (bool){
304       return bots[a];
305     }
306 
307     function openTrading() external onlyOwner() {
308         require(!tradingOpen,"trading is already open");
309         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
310         _approve(address(this), address(uniswapV2Router), _tTotal);
311         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
312         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
313         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
314         swapEnabled = true;
315         tradingOpen = true;
316     }
317 
318     
319     function reduceFee(uint256 _newFee) external{
320       require(_msgSender()==_taxWallet);
321       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
322       _finalBuyTax=_newFee;
323       _finalSellTax=_newFee;
324     }
325 
326     receive() external payable {}
327 
328     function manualSwap() external {
329         require(_msgSender()==_taxWallet);
330         uint256 tokenBalance=balanceOf(address(this));
331         if(tokenBalance>0){
332           swapTokensForEth(tokenBalance);
333         }
334         uint256 ethBalance=address(this).balance;
335         if(ethBalance>0){
336           sendETHToFee(ethBalance);
337         }
338     }
339 }