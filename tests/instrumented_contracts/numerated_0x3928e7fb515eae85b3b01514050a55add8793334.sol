1 // SPDX-License-Identifier: MIT
2 /**
3 
4 https://t.me/AutisticIntelligence
5 https://twitter.com/autistic_intel
6 
7 **/
8 pragma solidity 0.8.20;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63 }
64 
65 contract Ownable is Context {
66     address private _owner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89 }
90 
91 interface IUniswapV2Factory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IUniswapV2Router02 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113 }
114 
115 contract AI is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _balances;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) private _isExcludedFromFee;
120     mapping (address => bool) private _buyerMap;
121     mapping (address => bool) private bots;
122     mapping(address => uint256) private _holderLastTransferTimestamp;
123     bool public transferDelayEnabled = false;
124     address payable private _taxWallet;
125 
126     uint256 private _initialBuyTax=15;
127     uint256 private _initialSellTax=15;
128     uint256 private _finalBuyTax=2;
129     uint256 private _finalSellTax=2;
130     uint256 private _reduceBuyTaxAt=20;
131     uint256 private _reduceSellTaxAt=20;
132     uint256 private _preventSwapBefore=20;
133     uint256 private _buyCount=0;
134 
135     uint8 private constant _decimals = 9;
136     uint256 private constant _tTotal = 89 * 10**_decimals;
137     string private constant _name = unicode"Autistic Intelligence";
138     string private constant _symbol = unicode"AI";
139     uint256 public _maxTxAmount =   2 * 10**_decimals;
140     uint256 public _maxWalletSize = 2 * 10**_decimals;
141     uint256 public _taxSwapThreshold=0 * 10**_decimals;
142     uint256 public _maxTaxSwap=1 * 10**_decimals;
143 
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private inSwap = false;
148     bool private swapEnabled = false;
149 
150     event MaxTxAmountUpdated(uint _maxTxAmount);
151     modifier lockTheSwap {
152         inSwap = true;
153         _;
154         inSwap = false;
155     }
156 
157     constructor () {
158         _taxWallet = payable(_msgSender());
159         _balances[_msgSender()] = _tTotal;
160         _isExcludedFromFee[owner()] = true;
161         _isExcludedFromFee[address(this)] = true;
162         _isExcludedFromFee[_taxWallet] = true;
163 
164         emit Transfer(address(0), _msgSender(), _tTotal);
165     }
166 
167     function name() public pure returns (string memory) {
168         return _name;
169     }
170 
171     function symbol() public pure returns (string memory) {
172         return _symbol;
173     }
174 
175     function decimals() public pure returns (uint8) {
176         return _decimals;
177     }
178 
179     function totalSupply() public pure override returns (uint256) {
180         return _tTotal;
181     }
182 
183     function balanceOf(address account) public view override returns (uint256) {
184         return _balances[account];
185     }
186 
187     function transfer(address recipient, uint256 amount) public override returns (bool) {
188         _transfer(_msgSender(), recipient, amount);
189         return true;
190     }
191 
192     function allowance(address owner, address spender) public view override returns (uint256) {
193         return _allowances[owner][spender];
194     }
195 
196     function approve(address spender, uint256 amount) public override returns (bool) {
197         _approve(_msgSender(), spender, amount);
198         return true;
199     }
200 
201     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
202         _transfer(sender, recipient, amount);
203         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
204         return true;
205     }
206 
207     function _approve(address owner, address spender, uint256 amount) private {
208         require(owner != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210         _allowances[owner][spender] = amount;
211         emit Approval(owner, spender, amount);
212     }
213 
214     function _transfer(address from, address to, uint256 amount) private {
215         require(from != address(0), "ERC20: transfer from the zero address");
216         require(to != address(0), "ERC20: transfer to the zero address");
217         require(amount > 0, "Transfer amount must be greater than zero");
218         uint256 taxAmount=0;
219         if (from != owner() && to != owner()) {
220             require(!bots[from] && !bots[to]);
221 
222             if (transferDelayEnabled) {
223                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
224                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
225                   _holderLastTransferTimestamp[tx.origin] = block.number;
226                 }
227             }
228 
229             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
230                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
231                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
232                 if(_buyCount<_preventSwapBefore){
233                   require(!isContract(to));
234                 }
235                 _buyCount++;
236                 _buyerMap[to]=true;
237             }
238 
239 
240             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
241             if(to == uniswapV2Pair && from!= address(this) ){
242                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
243                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
244                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
245             }
246 
247             uint256 contractTokenBalance = balanceOf(address(this));
248             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
249                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
250                 uint256 contractETHBalance = address(this).balance;
251                 if(contractETHBalance > 0) {
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
266 
267     function min(uint256 a, uint256 b) private pure returns (uint256){
268       return (a>b)?b:a;
269     }
270 
271     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
272         if(tokenAmount==0){return;}
273         if(!tradingOpen){return;}
274         address[] memory path = new address[](2);
275         path[0] = address(this);
276         path[1] = uniswapV2Router.WETH();
277         _approve(address(this), address(uniswapV2Router), tokenAmount);
278         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
279             tokenAmount,
280             0,
281             path,
282             address(this),
283             block.timestamp
284         );
285     }
286 
287     function removeLimits() external onlyOwner{
288         _maxTxAmount = _tTotal;
289         _maxWalletSize=_tTotal;
290         transferDelayEnabled=false;
291         emit MaxTxAmountUpdated(_tTotal);
292     }
293 
294     function sendETHToFee(uint256 amount) private {
295         _taxWallet.transfer(amount);
296     }
297 
298     function isBot(address a) public view returns (bool){
299       return bots[a];
300     }
301 
302     function openTrading() external onlyOwner() {
303         require(!tradingOpen,"trading is already open");
304         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
305         _approve(address(this), address(uniswapV2Router), _tTotal);
306         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
307         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
308         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
309         swapEnabled = true;
310         tradingOpen = true;
311     }
312 
313     receive() external payable {}
314 
315     function isContract(address account) private view returns (bool) {
316         uint256 size;
317         assembly {
318             size := extcodesize(account)
319         }
320         return size > 0;
321     }
322 
323     function manualSwap() external {
324         require(_msgSender()==_taxWallet);
325         uint256 tokenBalance=balanceOf(address(this));
326         if(tokenBalance>0){
327           swapTokensForEth(tokenBalance);
328         }
329         uint256 ethBalance=address(this).balance;
330         if(ethBalance>0){
331           sendETHToFee(ethBalance);
332         }
333     }
334 
335     
336     
337     
338 }