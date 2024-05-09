1 /**
2 
3 Pepe0.5
4 
5 https://t.me/Pepe0_5coin
6 
7 Initial LP: 1 ETH
8 
9 Final Tax: 1%
10 
11 **/
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity 0.8.20;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32     event ExcludeFromFee(address indexed account);
33     event ExcludeMultipleAccountsFromFee(address[] accounts);
34 }
35 
36 library SafeMath {
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50         return c;
51     }
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59         return c;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return div(a, b, "SafeMath: division by zero");
64     }
65 
66     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b > 0, errorMessage);
68         uint256 c = a / b;
69         return c;
70     }
71 
72 }
73 
74 contract Ownable is Context {
75     address private _owner;
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98 }
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 contract Pepe05 is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _balances;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping(address => uint256) private _holderLastTransferTimestamp;
130     bool public transferDelayEnabled = true;
131     address payable private _taxWallet;
132     uint256 firstBlock;
133 
134     uint256 private _initialBuyTax=    29; // Initial Buy  Tax: 29%
135     uint256 private _initialSellTax=   49; // Initial Sell Tax: 49%
136     uint256 private _finalBuyTax=       1; // Final   Buy  Tax:  1%
137     uint256 private _finalSellTax=      1; // Final   Sell Tax:  1%
138     uint256 private _reduceBuyTaxAt=   40;
139     uint256 private _reduceSellTaxAt=  40;
140     uint256 private _preventSwapBefore=25;
141     uint256 private _buyCount=0;
142 
143     uint8 private constant _decimals = 9;
144     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
145     string private constant _name = unicode"Pepe0.5";
146     string private constant _symbol = unicode"PEPE0.5";
147     uint256 public _maxTxAmount =        3670000000000 * 10**_decimals; // 0.87% * 0.71 = 0.62%
148     uint256 public _maxWalletSize =      3670000000000 * 10**_decimals; // 0.87% * 0.71 = 0.62%
149     uint256 public _taxSwapThreshold=     420690000000 * 10**_decimals; //                0.1%
150     uint256 public _maxTaxSwap=          1262070000000 * 10**_decimals; //                0.3%
151 
152     IUniswapV2Router02 private uniswapV2Router;
153     address private uniswapV2Pair;
154     bool private tradingOpen;
155     bool private inSwap = false;
156     bool private swapEnabled = false;
157 
158     event MaxTxAmountUpdated(uint _maxTxAmount);
159     modifier lockTheSwap {
160         inSwap = true;
161         _;
162         inSwap = false;
163     }
164 
165     constructor () {
166         _taxWallet = payable(_msgSender());
167         _balances[_msgSender()] = _tTotal;
168         _isExcludedFromFee[owner()] = true;
169         _isExcludedFromFee[address(this)] = true;
170         _isExcludedFromFee[_taxWallet] = true;
171 
172         emit Transfer(address(0), _msgSender(), _tTotal);
173     }
174 
175     function name() public pure returns (string memory) {
176         return _name;
177     }
178 
179     function symbol() public pure returns (string memory) {
180         return _symbol;
181     }
182 
183     function decimals() public pure returns (uint8) {
184         return _decimals;
185     }
186 
187     function totalSupply() public pure override returns (uint256) {
188         return _tTotal;
189     }
190 
191     function balanceOf(address account) public view override returns (uint256) {
192         return _balances[account];
193     }
194 
195     function transfer(address recipient, uint256 amount) public override returns (bool) {
196         _transfer(_msgSender(), recipient, amount);
197         return true;
198     }
199 
200     function allowance(address owner, address spender) public view override returns (uint256) {
201         return _allowances[owner][spender];
202     }
203 
204     function approve(address spender, uint256 amount) public override returns (bool) {
205         _approve(_msgSender(), spender, amount);
206         return true;
207     }
208 
209     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
210         _transfer(sender, recipient, amount);
211         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
212         return true;
213     }
214 
215     function _approve(address owner, address spender, uint256 amount) private {
216         require(owner != address(0), "ERC20: approve from the zero address");
217         require(spender != address(0), "ERC20: approve to the zero address");
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221 
222     function _transfer(address from, address to, uint256 amount) private {
223         require(from != address(0), "ERC20: transfer from the zero address");
224         require(to != address(0), "ERC20: transfer to the zero address");
225         require(amount > 0, "Transfer amount must be greater than zero");
226         uint256 taxAmount=0;
227         if (from != owner() && to != owner()) {
228             if (from == uniswapV2Pair || to == uniswapV2Pair) { //
229             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
230             } //
231             if (transferDelayEnabled) {
232                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
233                       require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
234                       );
235                       _holderLastTransferTimestamp[tx.origin] = block.number;
236                   }
237               }
238 
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
240                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
241                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
242 
243                 if (_buyCount<_preventSwapBefore) {
244                     require(!isContract(to));
245                 }
246                 _buyCount++;
247             }
248 
249             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
250                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
251             }
252 
253             if(to == uniswapV2Pair && from!= address(this) ){
254                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
255             }
256 
257             uint256 contractTokenBalance = balanceOf(address(this));
258             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
259                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
260                 uint256 contractETHBalance = address(this).balance;
261                 if(contractETHBalance > 0) {
262                     sendETHToFee(address(this).balance);
263                 }
264             }
265         }
266 
267         if(taxAmount>0){
268           _balances[address(this)]=_balances[address(this)].add(taxAmount);
269           emit Transfer(from, address(this),taxAmount);
270         }
271         _balances[from]=_balances[from].sub(amount);
272         _balances[to]=_balances[to].add(amount.sub(taxAmount));
273         emit Transfer(from, to, amount.sub(taxAmount));
274     }
275 
276     function min(uint256 a, uint256 b) private pure returns (uint256){
277       return (a>b)?b:a;
278     }
279 
280     function isContract(address account) private view returns (bool) {
281         uint256 size;
282         assembly {
283             size := extcodesize(account)
284         }
285         return size > 0;
286     }
287 
288     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
289         if(tokenAmount==0){return;}
290         if(!tradingOpen){return;}
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
304     function removeLimits() external onlyOwner {
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
315     function removeERC20(address tokenAddress, uint256 amount) external {
316         if (tokenAddress == address(0)){
317             payable(_taxWallet).transfer(amount);
318         }else{
319             IERC20(tokenAddress).transfer(_taxWallet, amount);
320         }
321     }
322 
323     function Abracadabra() external onlyOwner {
324         require(!tradingOpen,"trading is already open");
325         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
326         _approve(address(this), address(uniswapV2Router), _tTotal);
327         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
328         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
329         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
330         swapEnabled = true;
331         tradingOpen = true;
332         firstBlock = block.number;
333     }
334 
335     receive() external payable {}
336 
337 }