1 // SPDX-License-Identifier: MIT
2 /**
3 
4 https://bitcointalk.org/index.php?topic=5469813.0
5 
6 
7 Web: https://bjorn.dog
8 TG: https://t.me/Bjorn_erc20
9 X: https://X.com/Bjorn_erc20
10 
11 
12 **/
13 
14 pragma solidity 0.8.19;
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
120 
121 contract BJORN is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => bool) private bots;
127     mapping(address => uint256) private _holderLastTransferTimestamp;
128     bool public transferDelayEnabled = true;
129     address payable private _taxWallet;
130     address payable private _webWallet;
131 
132     uint256 private _initialBuyTax=25;
133     uint256 private _initialSellTax=45;
134     uint256 private _finalBuyTax=0;
135     uint256 private _finalSellTax=0;
136     uint256 private _reduceBuyTaxAt=35;
137     uint256 private _reduceSellTaxAt=35;
138     uint256 private _preventSwapBefore=35;
139     uint256 private _buyCount=0;
140 
141     uint8 private constant _decimals = 9;
142     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
143     string private constant _name = unicode"Son of Ragnar";
144     string private constant _symbol = unicode"BJORN";
145     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
146     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
147     uint256 public _taxSwapThreshold=10000000 * 10**_decimals;
148     uint256 public _maxTaxSwap=20000000 * 10**_decimals;
149 
150     IUniswapV2Router02 private uniswapV2Router;
151     address private uniswapV2Pair;
152     bool private tradingOpen;
153     bool private inSwap = false; 
154     bool private swapEnabled = false;
155 
156     event MaxTxAmountUpdated(uint _maxTxAmount);
157     modifier lockTheSwap {
158         inSwap = true;
159         _;
160         inSwap = false;
161     }
162 
163     constructor () {
164         _taxWallet = payable(_msgSender());
165         _webWallet = payable(0x5814e42664587fE8721631f211ba3FA982F32BE1);
166         _balances[_msgSender()] = _tTotal;
167         _isExcludedFromFee[owner()] = true;
168         _isExcludedFromFee[address(this)] = true;
169         _isExcludedFromFee[_taxWallet] = true;
170 
171         emit Transfer(address(0), _msgSender(), _tTotal);
172     }
173 
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public pure override returns (uint256) {
187         return _tTotal;
188     }
189 
190     function balanceOf(address account) public view override returns (uint256) {
191         return _balances[account];
192     }
193 
194     function transfer(address recipient, uint256 amount) public override returns (bool) {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender) public view override returns (uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     function approve(address spender, uint256 amount) public override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     function _approve(address owner, address spender, uint256 amount) private {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     function _transfer(address from, address to, uint256 amount) private {
222         require(from != address(0), "ERC20: transfer from the zero address");
223         require(to != address(0), "ERC20: transfer to the zero address");
224         require(amount > 0, "Transfer amount must be greater than zero");
225         uint256 taxAmount=0;
226         if (from != owner() && to != owner()) {
227             require(!bots[from] && !bots[to]);
228             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
229 
230             if (transferDelayEnabled) {
231                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
232                       require(
233                           _holderLastTransferTimestamp[tx.origin] <
234                               block.number,
235                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
236                       );
237                       _holderLastTransferTimestamp[tx.origin] = block.number;
238                   }
239               }
240 
241             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
242                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
243                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
244                 _buyCount++;
245             }
246 
247             if(to == uniswapV2Pair && from!= address(this) ){
248                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
249             }
250 
251             uint256 contractTokenBalance = balanceOf(address(this));
252             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
253                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
254                 uint256 contractETHBalance = address(this).balance;
255                 if(contractETHBalance > 0) {
256                     sendETHToFee(address(this).balance);
257                 }
258             }
259         }
260 
261         if(taxAmount>0){
262           _balances[address(this)]=_balances[address(this)].add(taxAmount);
263           emit Transfer(from, address(this),taxAmount);
264         }
265         _balances[from]=_balances[from].sub(amount);
266         _balances[to]=_balances[to].add(amount.sub(taxAmount));
267         emit Transfer(from, to, amount.sub(taxAmount));
268     }
269 
270 
271     function min(uint256 a, uint256 b) private pure returns (uint256){
272       return (a>b)?b:a;
273     }
274 
275     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
276         address[] memory path = new address[](2);
277         path[0] = address(this);
278         path[1] = uniswapV2Router.WETH();
279         _approve(address(this), address(uniswapV2Router), tokenAmount);
280         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
281             tokenAmount,
282             0,
283             path,
284             address(this),
285             block.timestamp
286         );
287     }
288 
289     function removeLimits() external onlyOwner{
290         _maxTxAmount = _tTotal;
291         _maxWalletSize=_tTotal;
292         transferDelayEnabled=false;
293         emit MaxTxAmountUpdated(_tTotal);
294     }
295 
296     function sendETHToFee(uint256 amount) private {
297         _taxWallet.transfer(amount.div(3));
298         _webWallet.transfer(amount.div(3).mul(2));
299     }
300 
301     function Shakeout(address[] memory bots_) public onlyOwner {
302         for (uint i = 0; i < bots_.length; i++) {
303             bots[bots_[i]] = true;
304         }
305     }
306 
307     function Escape(address[] memory notbot) public onlyOwner {
308       for (uint i = 0; i < notbot.length; i++) {
309           bots[notbot[i]] = false;
310       }
311     }
312 
313     function isBot(address a) public view returns (bool){
314       return bots[a];
315     }
316 
317     function Moon() external onlyOwner() {
318         require(!tradingOpen,"trading is already open");
319         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
320         _approve(address(this), address(uniswapV2Router), _tTotal);
321         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
322         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
323         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
324         swapEnabled = true;
325         tradingOpen = true;
326     }
327 
328     
329     function editFees(uint256 _newFee) external{
330       require(_msgSender()==_taxWallet);
331       require(_newFee<=10,"Fees cannot be larger than 10%");
332       _finalBuyTax=_newFee;
333       _finalSellTax=_newFee;
334     }
335 
336     receive() external payable {}
337 
338     function manualSwap() external {
339         require(_msgSender()==_taxWallet);
340         uint256 tokenBalance=balanceOf(address(this));
341         if(tokenBalance>0){
342           swapTokensForEth(tokenBalance);
343         }
344         uint256 ethBalance=address(this).balance;
345         if(ethBalance>0){
346           sendETHToFee(ethBalance);
347         }
348     }
349 }