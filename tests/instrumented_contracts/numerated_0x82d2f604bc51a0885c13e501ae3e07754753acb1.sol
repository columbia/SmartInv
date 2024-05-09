1 // SPDX-License-Identifier: MIT
2 /**
3 
4 $DOSHI
5 
6 🐕🐈🐕🐈🐕🐈
7 
8 $DOSHI Unleashing the Purr-fection Of $DOGE and $TOSHI community into Ethereum Network. 
9 
10 Bridging two communities into one greater power and purpose. 
11 
12 Tokenomics: 
13 
14 2% Initial Bag "will remove limits soon"
15 2% Initial Txn "will remove limits soon"
16 2% in Token Numbers. 
17 17,777,777,777,778
18 
19 2/2 Tax for Marketing and Buyback 
20 Smart Contract Renounce
21 
22 TG- https://t.me/DogeToshi_ETH
23 TWITTER- https://twitter.com/DogeToshi_ETH
24 WEBSITE- https://dogetoshierc20.com
25 
26 **/
27 pragma solidity 0.8.20;
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 }
34 
35 interface IERC20 {
36     function totalSupply() external view returns (uint256);
37     function balanceOf(address account) external view returns (uint256);
38     function transfer(address recipient, uint256 amount) external returns (bool);
39     function allowance(address owner, address spender) external view returns (uint256);
40     function approve(address spender, uint256 amount) external returns (bool);
41     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 library SafeMath {
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69         return c;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75 
76     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         return c;
80     }
81 
82 }
83 
84 contract Ownable is Context {
85     address private _owner;
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     constructor () {
89         address msgSender = _msgSender();
90         _owner = msgSender;
91         emit OwnershipTransferred(address(0), msgSender);
92     }
93 
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     modifier onlyOwner() {
99         require(_owner == _msgSender(), "Ownable: caller is not the owner");
100         _;
101     }
102 
103     function renounceOwnership() public virtual onlyOwner {
104         emit OwnershipTransferred(_owner, address(0));
105         _owner = address(0);
106     }
107 
108 }
109 
110 interface IUniswapV2Factory {
111     function createPair(address tokenA, address tokenB) external returns (address pair);
112 }
113 
114 interface IUniswapV2Router02 {
115     function swapExactTokensForETHSupportingFeeOnTransferTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external;
122     function factory() external pure returns (address);
123     function WETH() external pure returns (address);
124     function addLiquidityETH(
125         address token,
126         uint amountTokenDesired,
127         uint amountTokenMin,
128         uint amountETHMin,
129         address to,
130         uint deadline
131     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
132 }
133 
134 contract DOSHI is Context, IERC20, Ownable {
135     using SafeMath for uint256;
136     mapping (address => uint256) private _balances;
137     mapping (address => mapping (address => uint256)) private _allowances;
138     mapping (address => bool) private _isExcludedFromFee;
139     mapping (address => bool) private _buyerMap;
140     mapping (address => bool) private bots;
141     mapping(address => uint256) private _holderLastTransferTimestamp;
142     bool public transferDelayEnabled = false;
143     address payable private _taxWallet;
144 
145     uint256 private _initialBuyTax=25;
146     uint256 private _initialSellTax=20;
147     uint256 private _finalBuyTax=2;
148     uint256 private _finalSellTax=2;
149     uint256 private _reduceBuyTaxAt=1;
150     uint256 private _reduceSellTaxAt=40;
151     uint256 private _preventSwapBefore=40;
152     uint256 private _buyCount=0;
153 
154     uint8 private constant _decimals = 9;
155     uint256 private constant _tTotal = 888888888888888 * 10**_decimals;
156     string private constant _name = unicode"DogeToshi";
157     string private constant _symbol = unicode"DOSHI";
158     uint256 public _maxTxAmount =   17777777777778 * 10**_decimals;
159     uint256 public _maxWalletSize = 17777777777778 * 10**_decimals;
160     uint256 public _taxSwapThreshold=4444444444444 * 10**_decimals;
161     uint256 public _maxTaxSwap=4444444444444 * 10**_decimals;
162 
163     IUniswapV2Router02 private uniswapV2Router;
164     address private uniswapV2Pair;
165     bool private tradingOpen;
166     bool private inSwap = false;
167     bool private swapEnabled = false;
168 
169     event MaxTxAmountUpdated(uint _maxTxAmount);
170     modifier lockTheSwap {
171         inSwap = true;
172         _;
173         inSwap = false;
174     }
175 
176     constructor () {
177         _taxWallet = payable(_msgSender());
178         _balances[_msgSender()] = _tTotal;
179         _isExcludedFromFee[owner()] = true;
180         _isExcludedFromFee[address(this)] = true;
181         _isExcludedFromFee[_taxWallet] = true;
182 
183         emit Transfer(address(0), _msgSender(), _tTotal);
184     }
185 
186     function name() public pure returns (string memory) {
187         return _name;
188     }
189 
190     function symbol() public pure returns (string memory) {
191         return _symbol;
192     }
193 
194     function decimals() public pure returns (uint8) {
195         return _decimals;
196     }
197 
198     function totalSupply() public pure override returns (uint256) {
199         return _tTotal;
200     }
201 
202     function balanceOf(address account) public view override returns (uint256) {
203         return _balances[account];
204     }
205 
206     function transfer(address recipient, uint256 amount) public override returns (bool) {
207         _transfer(_msgSender(), recipient, amount);
208         return true;
209     }
210 
211     function allowance(address owner, address spender) public view override returns (uint256) {
212         return _allowances[owner][spender];
213     }
214 
215     function approve(address spender, uint256 amount) public override returns (bool) {
216         _approve(_msgSender(), spender, amount);
217         return true;
218     }
219 
220     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
221         _transfer(sender, recipient, amount);
222         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
223         return true;
224     }
225 
226     function _approve(address owner, address spender, uint256 amount) private {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 
233     function _transfer(address from, address to, uint256 amount) private {
234         require(from != address(0), "ERC20: transfer from the zero address");
235         require(to != address(0), "ERC20: transfer to the zero address");
236         require(amount > 0, "Transfer amount must be greater than zero");
237         uint256 taxAmount=0;
238         if (from != owner() && to != owner()) {
239             require(!bots[from] && !bots[to]);
240 
241             if (transferDelayEnabled) {
242                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
243                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
244                   _holderLastTransferTimestamp[tx.origin] = block.number;
245                 }
246             }
247 
248             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
249                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
250                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
251                 if(_buyCount<_preventSwapBefore){
252                   require(!isContract(to));
253                 }
254                 _buyCount++;
255                 _buyerMap[to]=true;
256             }
257 
258 
259             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
260             if(to == uniswapV2Pair && from!= address(this) ){
261                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
262                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
263                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
264             }
265 
266             uint256 contractTokenBalance = balanceOf(address(this));
267             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
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
291         if(tokenAmount==0){return;}
292         if(!tradingOpen){return;}
293         address[] memory path = new address[](2);
294         path[0] = address(this);
295         path[1] = uniswapV2Router.WETH();
296         _approve(address(this), address(uniswapV2Router), tokenAmount);
297         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
298             tokenAmount,
299             0,
300             path,
301             address(this),
302             block.timestamp
303         );
304     }
305 
306     function removeLimits() external onlyOwner{
307         _maxTxAmount = _tTotal;
308         _maxWalletSize=_tTotal;
309         transferDelayEnabled=false;
310         emit MaxTxAmountUpdated(_tTotal);
311     }
312 
313     function sendETHToFee(uint256 amount) private {
314         _taxWallet.transfer(amount);
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
332     receive() external payable {}
333 
334     function isContract(address account) private view returns (bool) {
335         uint256 size;
336         assembly {
337             size := extcodesize(account)
338         }
339         return size > 0;
340     }
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
353 
354     
355     
356     
357 }