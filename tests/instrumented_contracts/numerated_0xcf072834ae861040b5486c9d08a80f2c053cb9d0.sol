1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Telegram: https://t.me/Summerofshibariumeth
5 
6 **/
7 pragma solidity 0.8.20;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor () {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88 }
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 }
93 
94 interface IUniswapV2Router02 {
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(
105         address token,
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 }
113 
114 contract SummerOfShibarium is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     mapping(address => uint256) private _holderLastTransferTimestamp;
121     bool public transferDelayEnabled = false;
122     address payable private _taxWallet;
123 
124     uint256 private _initialBuyTax=20;
125     uint256 private _initialSellTax=20;
126     uint256 private _finalBuyTax=1;
127     uint256 private _finalSellTax=1;
128     uint256 private _reduceBuyTaxAt=20;
129     uint256 private _reduceSellTaxAt=30;
130     uint256 private _preventSwapBefore=20;
131     uint256 private _buyCount=0;
132 
133     uint8 private constant _decimals = 8;
134     uint256 private constant _tTotal = 100000000 * 10**_decimals;
135     string private constant _name = unicode"Summer Of Shibarium";
136     string private constant _symbol = unicode"SOS";
137     uint256 public _maxTxAmount =   2000000 * 10**_decimals;
138     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
139     uint256 public _taxSwapThreshold=1000000 * 10**_decimals;
140     uint256 public _maxTaxSwap=1500000 * 10**_decimals;
141 
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147 
148     event MaxTxAmountUpdated(uint _maxTxAmount);
149     modifier lockTheSwap {
150         inSwap = true;
151         _;
152         inSwap = false;
153     }
154 
155     constructor () {
156         _taxWallet = payable(_msgSender());
157         _balances[_msgSender()] = _tTotal;
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[_taxWallet] = true;
161 
162         emit Transfer(address(0), _msgSender(), _tTotal);
163     }
164 
165     function name() public pure returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public pure returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public pure returns (uint8) {
174         return _decimals;
175     }
176 
177     function totalSupply() public pure override returns (uint256) {
178         return _tTotal;
179     }
180 
181     function balanceOf(address account) public view override returns (uint256) {
182         return _balances[account];
183     }
184 
185     function transfer(address recipient, uint256 amount) public override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
202         return true;
203     }
204 
205     function _approve(address owner, address spender, uint256 amount) private {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208         _allowances[owner][spender] = amount;
209         emit Approval(owner, spender, amount);
210     }
211 
212     function _transfer(address from, address to, uint256 amount) private {
213         require(from != address(0), "ERC20: transfer from the zero address");
214         require(to != address(0), "ERC20: transfer to the zero address");
215         require(amount > 0, "Transfer amount must be greater than zero");
216         uint256 taxAmount=0;
217         if (from != owner() && to != owner()) {
218             require(!bots[from] && !bots[to]);
219 
220             if (transferDelayEnabled) {
221                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
222                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
223                   _holderLastTransferTimestamp[tx.origin] = block.number;
224                 }
225             }
226 
227             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
228                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
229                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
230                 if(_buyCount<_preventSwapBefore){
231                   require(!isContract(to));
232                 }
233                 _buyCount++;
234             }
235 
236 
237             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
238             if(to == uniswapV2Pair && from!= address(this) ){
239                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
240                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
241             }
242 
243             uint256 contractTokenBalance = balanceOf(address(this));
244             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
245                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
246                 uint256 contractETHBalance = address(this).balance;
247                 if(contractETHBalance > 0) {
248                     sendETHToFee(address(this).balance);
249                 }
250             }
251         }
252 
253         if(taxAmount>0){
254           _balances[address(this)]=_balances[address(this)].add(taxAmount);
255           emit Transfer(from, address(this),taxAmount);
256         }
257         _balances[from]=_balances[from].sub(amount);
258         _balances[to]=_balances[to].add(amount.sub(taxAmount));
259         emit Transfer(from, to, amount.sub(taxAmount));
260     }
261 
262 
263     function min(uint256 a, uint256 b) private pure returns (uint256){
264       return (a>b)?b:a;
265     }
266 
267     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
268         if(tokenAmount==0){return;}
269         if(!tradingOpen){return;}
270         address[] memory path = new address[](2);
271         path[0] = address(this);
272         path[1] = uniswapV2Router.WETH();
273         _approve(address(this), address(uniswapV2Router), tokenAmount);
274         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
275             tokenAmount,
276             0,
277             path,
278             address(this),
279             block.timestamp
280         );
281     }
282 
283     function removeLimits() external onlyOwner{
284         _maxTxAmount = _tTotal;
285         _maxWalletSize=_tTotal;
286         transferDelayEnabled=false;
287         emit MaxTxAmountUpdated(_tTotal);
288     }
289 
290     function sendETHToFee(uint256 amount) private {
291         _taxWallet.transfer(amount);
292     }
293 
294     function isBot(address a) public view returns (bool){
295       return bots[a];
296     }
297 
298     function openTrading() external onlyOwner() {
299         require(!tradingOpen,"trading is already open");
300         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
301         _approve(address(this), address(uniswapV2Router), _tTotal);
302         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
303         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
304         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
305         swapEnabled = true;
306         tradingOpen = true;
307     }
308 
309     receive() external payable {}
310 
311     function isContract(address account) private view returns (bool) {
312         uint256 size;
313         assembly {
314             size := extcodesize(account)
315         }
316         return size > 0;
317     }
318 
319     function manualSwap() external {
320         require(_msgSender()==_taxWallet);
321         uint256 tokenBalance=balanceOf(address(this));
322         if(tokenBalance>0){
323           swapTokensForEth(tokenBalance);
324         }
325         uint256 ethBalance=address(this).balance;
326         if(ethBalance>0){
327           sendETHToFee(ethBalance);
328         }
329     }
330 
331     
332     
333     
334 }