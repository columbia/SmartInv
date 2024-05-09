1 /* 
2  ______     ______     __  __     ______        ______     __         ______   __  __     ______    
3 /\  ___\   /\  ___\   /\ \_\ \   /\  __ \      /\  __ \   /\ \       /\  == \ /\ \_\ \   /\  __ \   
4 \ \  __\   \ \ \____  \ \  __ \  \ \ \/\ \     \ \  __ \  \ \ \____  \ \  _-/ \ \  __ \  \ \  __ \  
5  \ \_____\  \ \_____\  \ \_\ \_\  \ \_____\     \ \_\ \_\  \ \_____\  \ \_\    \ \_\ \_\  \ \_\ \_\ 
6   \/_____/   \/_____/   \/_/\/_/   \/_____/      \/_/\/_/   \/_____/   \/_/     \/_/\/_/   \/_/\/_/                                                                                                                          
7 
8 Website: https://echoalpha.io
9 Discord: https://discord.gg/echo
10 Telegram: https://t.me/EchoAlphaIO
11 Twitter: https://twitter.com/EchoAlphaIO
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity 0.8.20;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
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
74 
75 contract Ownable is Context {
76     address private _owner;
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor () {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99 }
100 
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
126 
127 contract Echo is Context, IERC20, Ownable {
128     using SafeMath for uint256;
129     mapping (address => uint256) private _balances;
130     mapping (address => mapping (address => uint256)) private _allowances;
131     mapping (address => bool) private _isExcludedFromFee;
132     mapping (address => bool) private bots;
133     mapping(address => uint256) private _holderLastTransferTimestamp;
134     bool public transferDelayEnabled = false;
135     address payable private _taxWallet;
136 
137     uint256 private _initialBuyTax=20;
138     uint256 private _initialSellTax=20;
139     uint256 private _finalBuyTax=3;
140     uint256 private _finalSellTax=3;
141     uint256 private _reduceBuyTaxAt=20;
142     uint256 private _reduceSellTaxAt=20;
143     uint256 private _preventSwapBefore=30;
144     uint256 private _buyCount=0;
145 
146     uint8 private constant _decimals = 8;
147     uint256 private constant _tTotal = 400000000000000 * 10**_decimals;
148     string private constant _name = unicode"ECHO Alpha";
149     string private constant _symbol = unicode"ECHO";
150     uint256 public _maxTxAmount =   8413800000000 * 10**_decimals;
151     uint256 public _maxWalletSize = 8413800000000 * 10**_decimals;
152     uint256 public _taxSwapThreshold=0 * 10**_decimals;
153     uint256 public _maxTaxSwap=3365520000000 * 10**_decimals;
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
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return _balances[account];
198     }
199 
200     function transfer(address recipient, uint256 amount) public override returns (bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public view override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 amount) public override returns (bool) {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
217         return true;
218     }
219 
220     function _approve(address owner, address spender, uint256 amount) private {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223         _allowances[owner][spender] = amount;
224         emit Approval(owner, spender, amount);
225     }
226 
227 
228     function _transfer(address from, address to, uint256 amount) private {
229         require(from != address(0), "ERC20: transfer from the zero address");
230         require(to != address(0), "ERC20: transfer to the zero address");
231         require(amount > 0, "Transfer amount must be greater than zero");
232         uint256 taxAmount=0;
233         if (from != owner() && to != owner()) {
234             require(!bots[from] && !bots[to]);
235 
236             if (transferDelayEnabled) {
237                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
238                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
239                   _holderLastTransferTimestamp[tx.origin] = block.number;
240                 }
241             }
242 
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
244                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
245                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
246                 if(_buyCount<_preventSwapBefore){
247                   require(!isContract(to));
248                 }
249                 _buyCount++;
250             }
251 
252 
253             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
254             if(to == uniswapV2Pair && from!= address(this) ){
255                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
256                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
257             }
258 
259             uint256 contractTokenBalance = balanceOf(address(this));
260             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
261                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
262                 uint256 contractETHBalance = address(this).balance;
263                 if(contractETHBalance > 0) {
264                     sendETHToFee(address(this).balance);
265                 }
266             }
267         }
268 
269         if(taxAmount>0){
270           _balances[address(this)]=_balances[address(this)].add(taxAmount);
271           emit Transfer(from, address(this),taxAmount);
272         }
273         _balances[from]=_balances[from].sub(amount);
274         _balances[to]=_balances[to].add(amount.sub(taxAmount));
275         emit Transfer(from, to, amount.sub(taxAmount));
276     }
277 
278 
279     function min(uint256 a, uint256 b) private pure returns (uint256){
280       return (a>b)?b:a;
281     }
282 
283     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
284         if(tokenAmount==0){return;}
285         if(!tradingOpen){return;}
286         address[] memory path = new address[](2);
287         path[0] = address(this);
288         path[1] = uniswapV2Router.WETH();
289         _approve(address(this), address(uniswapV2Router), tokenAmount);
290         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
291             tokenAmount,
292             0,
293             path,
294             address(this),
295             block.timestamp
296         );
297     }
298 
299     function removeLimits() external onlyOwner{
300         _maxTxAmount = _tTotal;
301         _maxWalletSize=_tTotal;
302         transferDelayEnabled=false;
303         emit MaxTxAmountUpdated(_tTotal);
304     }
305 
306     function sendETHToFee(uint256 amount) private {
307         _taxWallet.transfer(amount);
308     }
309 
310     function isBot(address a) public view returns (bool){
311       return bots[a];
312     }
313 
314     function openTrading() external onlyOwner() {
315         require(!tradingOpen,"trading is already open");
316         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
317         _approve(address(this), address(uniswapV2Router), _tTotal);
318         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
319         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
320         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
321         swapEnabled = true;
322         tradingOpen = true;
323     }
324 
325 
326     receive() external payable {}
327 
328     function isContract(address account) private view returns (bool) {
329         uint256 size;
330         assembly {
331             size := extcodesize(account)
332         }
333         return size > 0;
334     }
335 
336     function manualSwap() external {
337         require(_msgSender()==_taxWallet);
338         uint256 tokenBalance=balanceOf(address(this));
339         if(tokenBalance>0){
340           swapTokensForEth(tokenBalance);
341         }
342         uint256 ethBalance=address(this).balance;
343         if(ethBalance>0){
344           sendETHToFee(ethBalance);
345         }
346     }
347 
348     
349     
350     
351 }