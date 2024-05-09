1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Davinci Jeremie $DJBTC
5 
6 Exactly 10 years ago, @davincij15 inviting everyone to risk buying bitcoin for 1$. 
7 If we all listened to him, we are all now having financial freedom. 
8 Are you the guy to hold or not?
9 
10 If you missed $BITCOIN don't missed $DJBTC
11 
12 Telegram:https://t.me/DJBTCERC20
13 Twitter:https://twitter.com/DJBTCERC20
14 Website:https://onedollarbitcoindavinci.com/
15 
16 **/
17 
18 
19 pragma solidity 0.8.17;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library SafeMath {
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71         return c;
72     }
73 
74 }
75 
76 contract Ownable is Context {
77     address private _owner;
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100 }
101 
102 interface IUniswapV2Factory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105 
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116     function addLiquidityETH(
117         address token,
118         uint amountTokenDesired,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
124 }
125 contract DavinciJeremie is Context , IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _balances;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private bots;
131     mapping(address => uint256) private _holderLastTransferTimestamp;
132     bool public transferDelayEnabled = true;
133     address payable private _taxWallet;
134 
135     uint256 private _initialBuyTax=20;
136     uint256 private _initialSellTax=20;
137     uint256 private _finalBuyTax=0;
138     uint256 private _finalSellTax=0;
139     uint256 private _reduceBuyTaxAt=10;
140     uint256 private _reduceSellTaxAt=20;
141     uint256 private _preventSwapBefore=20;
142     uint256 private _buyCount=0;
143 
144     uint8 private constant _decimals = 9;
145     uint256 private constant _tTotal = 21000000 * 10**_decimals;
146     string private constant _name = unicode"Davinci Jeremie";
147     string private constant _symbol = unicode"DJBTC";
148     uint256 public _maxTxAmount = 420000 * 10**_decimals;
149     uint256 public _maxWalletSize = 420000 * 10**_decimals;
150     uint256 public _taxSwapThreshold= 210000 * 10**_decimals;
151     uint256 public _maxTaxSwap= 210000 * 10**_decimals;
152 
153     IUniswapV2Router02 private uniswapV2Router;
154     address private uniswapV2Pair;
155     bool private tradingOpen;
156     bool private inSwap = false;
157     bool private swapEnabled = false;
158 
159     event MaxTxAmountUpdated(uint _maxTxAmount);
160     modifier lockTheSwap {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165 
166     constructor () {
167         _taxWallet = payable(_msgSender());
168         _balances[_msgSender()] = _tTotal;
169         _isExcludedFromFee[owner()] = true;
170         _isExcludedFromFee[address(this)] = true;
171         _isExcludedFromFee[_taxWallet] = true;
172 
173         emit Transfer(address(0), _msgSender(), _tTotal);
174     }
175 
176     function name() public pure returns (string memory) {
177         return _name;
178     }
179 
180     function symbol() public pure returns (string memory) {
181         return _symbol;
182     }
183 
184     function decimals() public pure returns (uint8) {
185         return _decimals;
186     }
187 
188     function totalSupply() public pure override returns (uint256) {
189         return _tTotal;
190     }
191 
192     function balanceOf(address account) public view override returns (uint256) {
193         return _balances[account];
194     }
195 
196     function transfer(address recipient, uint256 amount) public override returns (bool) {
197         _transfer(_msgSender(), recipient, amount);
198         return true;
199     }
200 
201     function allowance(address owner, address spender) public view override returns (uint256) {
202         return _allowances[owner][spender];
203     }
204 
205     function approve(address spender, uint256 amount) public override returns (bool) {
206         _approve(_msgSender(), spender, amount);
207         return true;
208     }
209 
210     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
211         _transfer(sender, recipient, amount);
212         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
213         return true;
214     }
215 
216     function _approve(address owner, address spender, uint256 amount) private {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223     function _transfer(address from, address to, uint256 amount) private {
224         require(from != address(0), "ERC20: transfer from the zero address");
225         require(to != address(0), "ERC20: transfer to the zero address");
226         require(amount > 0, "Transfer amount must be greater than zero");
227         uint256 taxAmount=0;
228         if (from != owner() && to != owner()) {
229             require(!bots[from] && !bots[to]);
230             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
231 
232             if (transferDelayEnabled) {
233                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
234                       require(
235                           _holderLastTransferTimestamp[tx.origin] <
236                               block.number,
237                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
238                       );
239                       _holderLastTransferTimestamp[tx.origin] = block.number;
240                   }
241               }
242 
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
244                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
245                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
246                 _buyCount++;
247             }
248 
249             if(to == uniswapV2Pair && from!= address(this) ){
250                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
251             }
252 
253             uint256 contractTokenBalance = balanceOf(address(this));
254             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
255                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
256                 uint256 contractETHBalance = address(this).balance;
257                 if(contractETHBalance > 0) {
258                     sendETHToFee(address(this).balance);
259                 }
260             }
261         }
262 
263         if(taxAmount>0){
264           _balances[address(this)]=_balances[address(this)].add(taxAmount);
265           emit Transfer(from, address(this),taxAmount);
266         }
267         _balances[from]=_balances[from].sub(amount);
268         _balances[to]=_balances[to].add(amount.sub(taxAmount));
269         emit Transfer(from, to, amount.sub(taxAmount));
270     }
271 
272 
273     function min(uint256 a, uint256 b) private pure returns (uint256){
274       return (a>b)?b:a;
275     }
276 
277     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
278         address[] memory path = new address[](2);
279         path[0] = address(this);
280         path[1] = uniswapV2Router.WETH();
281         _approve(address(this), address(uniswapV2Router), tokenAmount);
282         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
283             tokenAmount,
284             0,
285             path,
286             address(this),
287             block.timestamp
288         );
289     }
290 
291     function removeLimits() external onlyOwner{
292         _maxTxAmount = _tTotal;
293         _maxWalletSize=_tTotal;
294         transferDelayEnabled=false;
295         emit MaxTxAmountUpdated(_tTotal);
296     }
297 
298     function sendETHToFee(uint256 amount) private {
299         _taxWallet.transfer(amount);
300     }
301 
302     function addBots(address[] memory bots_) public onlyOwner {
303         for (uint i = 0; i < bots_.length; i++) {
304             bots[bots_[i]] = true;
305         }
306     }
307 
308     function delBots(address[] memory notbot) public onlyOwner {
309       for (uint i = 0; i < notbot.length; i++) {
310           bots[notbot[i]] = false;
311       }
312     }
313 
314     function isBot(address a) public view returns (bool){
315       return bots[a];
316     }
317 
318     function openTrading() external onlyOwner() {
319         require(!tradingOpen,"trading is already open");
320         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
321         _approve(address(this), address(uniswapV2Router), _tTotal);
322         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
323         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
324         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
325         swapEnabled = true;
326         tradingOpen = true;
327     }
328 
329     
330     function reduceFee(uint256 _newFee) external{
331       require(_msgSender()==_taxWallet);
332       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
333       _finalBuyTax=_newFee;
334       _finalSellTax=_newFee;
335     }
336 
337     receive() external payable {}
338 
339     function manualSwap() external {
340         require(_msgSender()==_taxWallet);
341         uint256 tokenBalance=balanceOf(address(this));
342         if(tokenBalance>0){
343           swapTokensForEth(tokenBalance);
344         }
345         uint256 ethBalance=address(this).balance;
346         if(ethBalance>0){
347           sendETHToFee(ethBalance);
348         }
349     }
350 }