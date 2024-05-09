1 // SPDX-License-Identifier: MIT
2 /**
3 
4 4Chan Classic   4ChanC
5 
6 4Chan Classic launched to uphold the fundamental principles of decentralization 
7 and immutability. It aims to preserve the integrity of every transaction on the blockchain. 
8 4Chan Classic's main goal is to maintain a decentralized and immutable financial ecosystem, 
9 where trust and security reign supreme. 
10 
11 If you look deep within the blockchain, you’ll notice flaws and errors in the system. 
12 We are at war with serial devs who take advantage of the innocent. This is our chance to fight for decentralization.
13 
14 https://t.me/fourchanclassic
15 https://twitter.com/fourchanclassic
16 http://4chanclassic.com/
17 
18 **/
19 pragma solidity 0.8.20;
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
125 
126 contract FourChan is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _balances;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     mapping (address => bool) private _buyerMap;
132     mapping (address => bool) private bots;
133     mapping(address => uint256) private _holderLastTransferTimestamp;
134     bool public transferDelayEnabled = false;
135     address payable private _taxWallet;
136 
137     uint256 private _initialBuyTax=13;
138     uint256 private _initialSellTax=50;
139     uint256 private _finalBuyTax=0;
140     uint256 private _finalSellTax=1;
141     uint256 private _reduceBuyTaxAt=1;
142     uint256 private _reduceSellTaxAt=20;
143     uint256 private _preventSwapBefore=20;
144     uint256 private _buyCount=0;
145 
146     uint8 private constant _decimals = 9;
147     uint256 private constant _tTotal = 100000000000000000 * 10**_decimals;
148     string private constant _name = unicode"4Chan Classic";
149     string private constant _symbol = unicode"4ChanC";
150     uint256 public _maxTxAmount =   2000000000000000 * 10**_decimals;
151     uint256 public _maxWalletSize = 2000000000000000 * 10**_decimals;
152     uint256 public _taxSwapThreshold=500000000000000 * 10**_decimals;
153     uint256 public _maxTaxSwap=500000000000000 * 10**_decimals;
154 
155     IUniswapV2Router02 private uniswapV2Router;
156     address private uniswapV2Pair;
157     bool private tradingOpen;
158     bool private inSwap = false;
159     bool private swapEnabled = false;
160 
161     event MaxTxAmountUpdated(uint _maxTxAmount);
162     modifier lockTheSwap {
163         inSwap = true;
164         _;
165         inSwap = false;
166     }
167 
168     constructor () {
169         _taxWallet = payable(_msgSender());
170         _balances[_msgSender()] = _tTotal;
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[_taxWallet] = true;
174 
175         emit Transfer(address(0), _msgSender(), _tTotal);
176     }
177 
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185 
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189 
190     function totalSupply() public pure override returns (uint256) {
191         return _tTotal;
192     }
193 
194     function balanceOf(address account) public view override returns (uint256) {
195         return _balances[account];
196     }
197 
198     function transfer(address recipient, uint256 amount) public override returns (bool) {
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     function allowance(address owner, address spender) public view override returns (uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount) public override returns (bool) {
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
215         return true;
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229         uint256 taxAmount=0;
230         if (from != owner() && to != owner()) {
231             require(!bots[from] && !bots[to]);
232 
233             if (transferDelayEnabled) {
234                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
235                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
236                   _holderLastTransferTimestamp[tx.origin] = block.number;
237                 }
238             }
239 
240             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
241                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
242                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
243                 if(_buyCount<_preventSwapBefore){
244                   require(!isContract(to));
245                 }
246                 _buyCount++;
247                 _buyerMap[to]=true;
248             }
249 
250 
251             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
252             if(to == uniswapV2Pair && from!= address(this) ){
253                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
254                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
255                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
256             }
257 
258             uint256 contractTokenBalance = balanceOf(address(this));
259             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
260                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
261                 uint256 contractETHBalance = address(this).balance;
262                 if(contractETHBalance > 0) {
263                     sendETHToFee(address(this).balance);
264                 }
265             }
266         }
267 
268         if(taxAmount>0){
269           _balances[address(this)]=_balances[address(this)].add(taxAmount);
270           emit Transfer(from, address(this),taxAmount);
271         }
272         _balances[from]=_balances[from].sub(amount);
273         _balances[to]=_balances[to].add(amount.sub(taxAmount));
274         emit Transfer(from, to, amount.sub(taxAmount));
275     }
276 
277 
278     function min(uint256 a, uint256 b) private pure returns (uint256){
279       return (a>b)?b:a;
280     }
281 
282     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
283         if(tokenAmount==0){return;}
284         if(!tradingOpen){return;}
285         address[] memory path = new address[](2);
286         path[0] = address(this);
287         path[1] = uniswapV2Router.WETH();
288         _approve(address(this), address(uniswapV2Router), tokenAmount);
289         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
290             tokenAmount,
291             0,
292             path,
293             address(this),
294             block.timestamp
295         );
296     }
297 
298     function removeLimits() external onlyOwner{
299         _maxTxAmount = _tTotal;
300         _maxWalletSize=_tTotal;
301         transferDelayEnabled=false;
302         emit MaxTxAmountUpdated(_tTotal);
303     }
304 
305     function sendETHToFee(uint256 amount) private {
306         _taxWallet.transfer(amount);
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
324     receive() external payable {}
325 
326     function isContract(address account) private view returns (bool) {
327         uint256 size;
328         assembly {
329             size := extcodesize(account)
330         }
331         return size > 0;
332     }
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
345 
346     
347     
348     
349 }