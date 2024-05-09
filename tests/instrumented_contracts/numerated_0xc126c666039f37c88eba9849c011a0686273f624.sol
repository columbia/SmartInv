1 /**
2  *
3 */
4 
5 /**
6 */
7 
8 // SPDX-License-Identifier: MIT
9 /**
10 
11 NOOT NOOT 
12 
13 https://t.me/nootnootETH
14 
15 
16 
17 
18 **/
19 
20 
21 pragma solidity 0.8.17;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         return c;
74     }
75 
76 }
77 
78 contract Ownable is Context {
79     address private _owner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 interface IUniswapV2Router02 {
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116     function factory() external pure returns (address);
117     function WETH() external pure returns (address);
118     function addLiquidityETH(
119         address token,
120         uint amountTokenDesired,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
126 }
127 
128 contract NOOT is Context, IERC20, Ownable {
129     using SafeMath for uint256;
130     mapping (address => uint256) private _balances;
131     mapping (address => mapping (address => uint256)) private _allowances;
132     mapping (address => bool) private _isExcludedFromFee;
133     mapping (address => bool) private bots;
134     mapping(address => uint256) private _holderLastTransferTimestamp;
135     bool public transferDelayEnabled = true;
136     address payable private _taxWallet;
137 
138     uint256 private _initialBuyTax=15;
139     uint256 private _initialSellTax=25;
140     uint256 private _finalBuyTax=0;
141     uint256 private _finalSellTax=0;
142     uint256 private _reduceBuyTaxAt=15;
143     uint256 private _reduceSellTaxAt=20;
144     uint256 private _preventSwapBefore=20;
145     uint256 private _buyCount=0;
146 
147     uint8 private constant _decimals = 9;
148     uint256 private constant _tTotal = 1000000 * 10**_decimals;
149     string private constant _name = unicode"NOOT NOOT";
150     string private constant _symbol = unicode"NOOT";
151     uint256 public _maxTxAmount = 20000 * 10**_decimals;
152     uint256 public _maxWalletSize = 20000 * 10**_decimals;
153     uint256 public _taxSwapThreshold= 20000 * 10**_decimals;
154     uint256 public _maxTaxSwap= 20000 * 10**_decimals;
155 
156     IUniswapV2Router02 private uniswapV2Router;
157     address private uniswapV2Pair;
158     bool private tradingOpen;
159     bool private inSwap = false;
160     bool private swapEnabled = false;
161 
162     event MaxTxAmountUpdated(uint _maxTxAmount);
163     modifier lockTheSwap {
164         inSwap = true;
165         _;
166         inSwap = false;
167     }
168 
169     constructor () {
170         _taxWallet = payable(_msgSender());
171         _balances[_msgSender()] = _tTotal;
172         _isExcludedFromFee[owner()] = true;
173         _isExcludedFromFee[address(this)] = true;
174         _isExcludedFromFee[_taxWallet] = true;
175 
176         emit Transfer(address(0), _msgSender(), _tTotal);
177     }
178 
179     function name() public pure returns (string memory) {
180         return _name;
181     }
182 
183     function symbol() public pure returns (string memory) {
184         return _symbol;
185     }
186 
187     function decimals() public pure returns (uint8) {
188         return _decimals;
189     }
190 
191     function totalSupply() public pure override returns (uint256) {
192         return _tTotal;
193     }
194 
195     function balanceOf(address account) public view override returns (uint256) {
196         return _balances[account];
197     }
198 
199     function transfer(address recipient, uint256 amount) public override returns (bool) {
200         _transfer(_msgSender(), recipient, amount);
201         return true;
202     }
203 
204     function allowance(address owner, address spender) public view override returns (uint256) {
205         return _allowances[owner][spender];
206     }
207 
208     function approve(address spender, uint256 amount) public override returns (bool) {
209         _approve(_msgSender(), spender, amount);
210         return true;
211     }
212 
213     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
214         _transfer(sender, recipient, amount);
215         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
216         return true;
217     }
218 
219     function _approve(address owner, address spender, uint256 amount) private {
220         require(owner != address(0), "ERC20: approve from the zero address");
221         require(spender != address(0), "ERC20: approve to the zero address");
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 
226     function _transfer(address from, address to, uint256 amount) private {
227         require(from != address(0), "ERC20: transfer from the zero address");
228         require(to != address(0), "ERC20: transfer to the zero address");
229         require(amount > 0, "Transfer amount must be greater than zero");
230         uint256 taxAmount=0;
231         if (from != owner() && to != owner()) {
232             require(!bots[from] && !bots[to]);
233             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
234 
235             if (transferDelayEnabled) {
236                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
237                       require(
238                           _holderLastTransferTimestamp[tx.origin] <
239                               block.number,
240                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
241                       );
242                       _holderLastTransferTimestamp[tx.origin] = block.number;
243                   }
244               }
245 
246             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
247                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
248                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
249                 _buyCount++;
250             }
251 
252             if(to == uniswapV2Pair && from!= address(this) ){
253                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
254             }
255 
256             uint256 contractTokenBalance = balanceOf(address(this));
257             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
258                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
259                 uint256 contractETHBalance = address(this).balance;
260                 if(contractETHBalance > 0) {
261                     sendETHToFee(address(this).balance);
262                 }
263             }
264         }
265 
266         if(taxAmount>0){
267           _balances[address(this)]=_balances[address(this)].add(taxAmount);
268           emit Transfer(from, address(this),taxAmount);
269         }
270         _balances[from]=_balances[from].sub(amount);
271         _balances[to]=_balances[to].add(amount.sub(taxAmount));
272         emit Transfer(from, to, amount.sub(taxAmount));
273     }
274 
275 
276     function min(uint256 a, uint256 b) private pure returns (uint256){
277       return (a>b)?b:a;
278     }
279 
280     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
281         address[] memory path = new address[](2);
282         path[0] = address(this);
283         path[1] = uniswapV2Router.WETH();
284         _approve(address(this), address(uniswapV2Router), tokenAmount);
285         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
286             tokenAmount,
287             0,
288             path,
289             address(this),
290             block.timestamp
291         );
292     }
293 
294     function removeLimits() external onlyOwner{
295         _maxTxAmount = _tTotal;
296         _maxWalletSize=_tTotal;
297         transferDelayEnabled=false;
298         emit MaxTxAmountUpdated(_tTotal);
299     }
300 
301     function sendETHToFee(uint256 amount) private {
302         _taxWallet.transfer(amount);
303     }
304 
305     function addBots(address[] memory bots_) public onlyOwner {
306         for (uint i = 0; i < bots_.length; i++) {
307             bots[bots_[i]] = true;
308         }
309     }
310 
311     function delBots(address[] memory notbot) public onlyOwner {
312       for (uint i = 0; i < notbot.length; i++) {
313           bots[notbot[i]] = false;
314       }
315     }
316 
317     function isBot(address a) public view returns (bool){
318       return bots[a];
319     }
320 
321     function openTrading() external onlyOwner() {
322         require(!tradingOpen,"trading is already open");
323         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
324         _approve(address(this), address(uniswapV2Router), _tTotal);
325         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
326         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
327         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
328         swapEnabled = true;
329         tradingOpen = true;
330     }
331 
332     
333     function reduceFee(uint256 _newFee) external{
334       require(_msgSender()==_taxWallet);
335       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
336       _finalBuyTax=_newFee;
337       _finalSellTax=_newFee;
338     }
339 
340     receive() external payable {}
341 
342     function manualSwap() external {
343         require(_msgSender()==_taxWallet);
344         uint256 tokenBalance=balanceOf(address(this));
345         if(tokenBalance>0){
346           swapTokensForEth(tokenBalance);
347         }
348         uint256 ethBalance=address(this).balance;
349         if(ethBalance>0){
350           sendETHToFee(ethBalance);
351         }
352     }
353 }