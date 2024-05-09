1 /**
2 
3 Introducing MULTI - the MultiBuyerBot.
4 
5 MultiBuyerBot splits and reduces the gas fees for every multibuyer. 
6 Add the bot as admin in your Telegram group, and experience the magic of collective investing!
7 
8 Telegram: https://t.me/MultiBuyerBot
9 
10 Website: www.multibuyerbot.com
11 Instagram: https://www.instagram.com/multibuyerbot 
12 TikTok: https://www.tiktok.com/@multibuyerbot
13 Twitter: https://twitter.com/MultiBuyerBot
14 
15 
16 **/
17 // SPDX-License-Identifier: MIT
18 
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
126 contract MultiBuyerBot is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _balances;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     address payable private _taxWallet;
132 	address payable private _revshareWallet;
133     uint256 firstBlock;
134 
135     uint256 private _initialBuyTax=20;
136     uint256 private _initialSellTax=30;
137     uint256 private _finalBuyTax=5;
138     uint256 private _finalSellTax=5;
139     uint256 private _reduceBuyTaxAt=30;
140     uint256 private _reduceSellTaxAt=30;
141     uint256 private _preventSwapBefore=30;
142     uint256 private _buyCount=0;
143 
144     uint8 private constant _decimals = 9;
145     uint256 private constant _tTotal = 1000000 * 10**_decimals;
146     string private constant _name = unicode"MultiBuyerBot";
147     string private constant _symbol = unicode"MULTI";
148     uint256 public _maxTxAmount =   30000 * 10**_decimals;
149     uint256 public _maxWalletSize = 30000 * 10**_decimals;
150     uint256 public _taxSwapThreshold= 10000 * 10**_decimals;
151     uint256 public _maxTaxSwap= 10000 * 10**_decimals;
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
167 
168         _taxWallet = payable(_msgSender());
169 		_revshareWallet = payable(address(0x2Fbd42Bf1bED392bbE6DaBe6021d40aE6b8Ffbf2));
170         _balances[_msgSender()] = _tTotal;
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[_taxWallet] = true;
174 		_isExcludedFromFee[_revshareWallet] = true;
175         
176         emit Transfer(address(0), _msgSender(), _tTotal);
177     }
178 	
179 
180     function name() public pure returns (string memory) {
181         return _name;
182     }
183 	
184 
185     function symbol() public pure returns (string memory) {
186         return _symbol;
187     }
188 	
189 
190     function decimals() public pure returns (uint8) {
191         return _decimals;
192     }
193 	
194 
195     function totalSupply() public pure override returns (uint256) {
196         return _tTotal;
197     }
198 	
199 
200     function balanceOf(address account) public view override returns (uint256) {
201         return _balances[account];
202     }
203 	
204 
205     function transfer(address recipient, uint256 amount) public override returns (bool) {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 	
210 
211     function allowance(address owner, address spender) public view override returns (uint256) {
212         return _allowances[owner][spender];
213     }
214 	
215 
216     function approve(address spender, uint256 amount) public override returns (bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 	
221 
222     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
223         _transfer(sender, recipient, amount);
224         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
225         return true;
226     }
227 	
228 
229     function _approve(address owner, address spender, uint256 amount) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236 
237     function _transfer(address from, address to, uint256 amount) private {
238         require(from != address(0), "ERC20: transfer from the zero address");
239         require(to != address(0), "ERC20: transfer to the zero address");
240         require(amount > 0, "Transfer amount must be greater than zero");
241         uint256 taxAmount=0;
242         if (from != owner() && to != owner()) {
243             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
244 
245             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
246                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
247                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
248 
249                 if (firstBlock + 3  > block.number) {
250                     require(!isContract(to));
251                 }
252                 _buyCount++;
253             }
254 
255             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
256                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
257             }
258 
259             if(to == uniswapV2Pair && from!= address(this) ){
260                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
261             }
262 
263             uint256 contractTokenBalance = balanceOf(address(this));
264             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
265                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
266                 uint256 contractETHBalance = address(this).balance;
267                 if(contractETHBalance > 0) {
268 					sendETHToRevShare(address(this).balance.div(5));
269                     sendETHToFee(address(this).balance);
270                 }
271             }
272         }
273 
274         if(taxAmount>0){
275           _balances[address(this)]=_balances[address(this)].add(taxAmount);
276           emit Transfer(from, address(this),taxAmount);
277         }
278         _balances[from]=_balances[from].sub(amount);
279         _balances[to]=_balances[to].add(amount.sub(taxAmount));
280         emit Transfer(from, to, amount.sub(taxAmount));
281     }
282 
283 
284     function min(uint256 a, uint256 b) private pure returns (uint256){
285       return (a>b)?b:a;
286     }
287 
288     function isContract(address account) private view returns (bool) {
289         uint256 size;
290         assembly {
291             size := extcodesize(account)
292         }
293         return size > 0;
294     }
295 
296     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
297         address[] memory path = new address[](2);
298         path[0] = address(this);
299         path[1] = uniswapV2Router.WETH();
300         _approve(address(this), address(uniswapV2Router), tokenAmount);
301         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
302             tokenAmount,
303             0,
304             path,
305             address(this),
306             block.timestamp
307         );
308     }
309 
310     function removeLimits() external onlyOwner{
311         _maxTxAmount = _tTotal;
312         _maxWalletSize=_tTotal;
313         emit MaxTxAmountUpdated(_tTotal);
314     }
315 
316     function sendETHToFee(uint256 amount) private {
317         _taxWallet.transfer(amount);
318     }
319 	
320 	function sendETHToRevShare(uint256 amount) private {
321         _revshareWallet.transfer(amount);
322     }
323 
324     function openTrading() external onlyOwner() {
325         require(!tradingOpen,"trading is already open");
326         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
327         _approve(address(this), address(uniswapV2Router), _tTotal);
328         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
329         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
330         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
331         swapEnabled = true;
332         tradingOpen = true;
333         firstBlock = block.number;
334     }
335 
336     receive() external payable {}
337 }