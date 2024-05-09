1 /**
2 
3 // SPDX-License-Identifier: MIT
4 /**
5 
6 Return of ARSONIST INU | $ARSONINU
7 
8 Supply: 500,000,000
9 
10 For thousands of years, the species of ARSON INU thrived 
11 thanks to their ability to adapt to harsh condition of drought-deciduous forest. 🌳
12 
13 But one day, a tragic incident took place where the habitat of ARSON INU. 
14 A huge fire swallowed whole the entire forest leaving everything on its way turn into dust.🔥
15 
16 Among all of his breed one ARSON INU survived. It has gain an pliable 
17 power to fire and became the apex predator in the forest on his time.
18 
19 Twitter (https://twitter.com/ARSONINU)
20 Telegram (https://t.me/ARSONINU)  
21 Medium (https://medium.com/@arsonistinuerc20/return-of-arsonist-inu-29249de35abd)
22 
23 
24 **/
25 pragma solidity 0.8.17;
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 }
32 
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35     function balanceOf(address account) external view returns (uint256);
36     function transfer(address recipient, uint256 amount) external returns (bool);
37     function allowance(address owner, address spender) external view returns (uint256);
38     function approve(address spender, uint256 amount) external returns (bool);
39     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 library SafeMath {
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58         return c;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67         return c;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         return c;
78     }
79 
80 }
81 
82 contract Ownable is Context {
83     address private _owner;
84     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86     constructor () {
87         address msgSender = _msgSender();
88         _owner = msgSender;
89         emit OwnershipTransferred(address(0), msgSender);
90     }
91 
92     function owner() public view returns (address) {
93         return _owner;
94     }
95 
96     modifier onlyOwner() {
97         require(_owner == _msgSender(), "Ownable: caller is not the owner");
98         _;
99     }
100 
101     function renounceOwnership() public virtual onlyOwner {
102         emit OwnershipTransferred(_owner, address(0));
103         _owner = address(0);
104     }
105 
106 }
107 
108 interface IUniswapV2Factory {
109     function createPair(address tokenA, address tokenB) external returns (address pair);
110 }
111 
112 interface IUniswapV2Router02 {
113     function swapExactTokensForETHSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120     function factory() external pure returns (address);
121     function WETH() external pure returns (address);
122     function addLiquidityETH(
123         address token,
124         uint amountTokenDesired,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline
129     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
130 }
131 
132 contract ARSONINU is Context, IERC20, Ownable {
133     using SafeMath for uint256;
134     mapping (address => uint256) private _balances;
135     mapping (address => mapping (address => uint256)) private _allowances;
136     mapping (address => bool) private _isExcludedFromFee;
137     mapping (address => bool) private bots;
138     address payable private _taxWallet;
139 
140     uint256 private _initialTax=9;
141     uint256 private _finalTax=6;
142     uint256 private _reduceTaxAt=40;
143     uint256 private _preventSwapBefore=30;
144     uint256 private _buyCount=0;
145 
146     uint8 private constant _decimals = 9;
147     uint256 private constant _tTotal = 500000000 * 10**_decimals;
148     string private constant _name = unicode"Return of ARSONIST INU";
149     string private constant _symbol = unicode"ARSONINU";
150     uint256 public _maxTxAmount = 10000000 * 10**_decimals;
151     uint256 public _maxWalletSize = 10000000 * 10**_decimals;
152     uint256 public _taxSwap=10000000 * 10**_decimals;
153 
154     IUniswapV2Router02 private uniswapV2Router;
155     address private uniswapV2Pair;
156     bool private tradingOpen;
157     bool private inSwap = false;
158     bool private swapEnabled = false;
159 
160     event MaxTxAmountUpdated(uint _maxTxAmount);
161     modifier lockTheSwap {
162         inSwap = true;
163         _;
164         inSwap = false;
165     }
166 
167     constructor () {
168         _taxWallet = payable(_msgSender());
169         _balances[_msgSender()] = _tTotal;
170         _isExcludedFromFee[owner()] = true;
171         _isExcludedFromFee[address(this)] = true;
172         _isExcludedFromFee[_taxWallet] = true;
173 
174         emit Transfer(address(0), _msgSender(), _tTotal);
175     }
176 
177     function name() public pure returns (string memory) {
178         return _name;
179     }
180 
181     function symbol() public pure returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function totalSupply() public pure override returns (uint256) {
190         return _tTotal;
191     }
192 
193     function balanceOf(address account) public view override returns (uint256) {
194         return _balances[account];
195     }
196 
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
214         return true;
215     }
216 
217     function _approve(address owner, address spender, uint256 amount) private {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function _transfer(address from, address to, uint256 amount) private {
225         require(from != address(0), "ERC20: transfer from the zero address");
226         require(to != address(0), "ERC20: transfer to the zero address");
227         require(amount > 0, "Transfer amount must be greater than zero");
228         uint256 taxAmount=0;
229         if (from != owner() && to != owner()) {
230             require(!bots[from] && !bots[to]);
231             if(!inSwap){
232               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
233             }
234 
235             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
236                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
237                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
238                 _buyCount++;
239             }
240 
241             uint256 contractTokenBalance = balanceOf(address(this));
242             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _buyCount>_preventSwapBefore) {
243                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
244                 uint256 contractETHBalance = address(this).balance;
245                 if(contractETHBalance > 0) {
246                     sendETHToFee(address(this).balance);
247                 }
248             }
249         }
250 
251         _balances[from]=_balances[from].sub(amount);
252         _balances[to]=_balances[to].add(amount.sub(taxAmount));
253         emit Transfer(from, to, amount.sub(taxAmount));
254         if(taxAmount>0){
255           _balances[address(this)]=_balances[address(this)].add(taxAmount);
256           emit Transfer(from, address(this),taxAmount);
257         }
258     }
259 
260     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
261         address[] memory path = new address[](2);
262         path[0] = address(this);
263         path[1] = uniswapV2Router.WETH();
264         _approve(address(this), address(uniswapV2Router), tokenAmount);
265         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
266             tokenAmount,
267             0,
268             path,
269             address(this),
270             block.timestamp
271         );
272     }
273 
274     function removeLimits() external onlyOwner{
275         _maxTxAmount = _tTotal;
276         _maxWalletSize=_tTotal;
277         emit MaxTxAmountUpdated(_tTotal);
278     }
279 
280     function sendETHToFee(uint256 amount) private {
281         _taxWallet.transfer(amount);
282     }
283 
284     function addBots(address[] memory bots_) public onlyOwner {
285         for (uint i = 0; i < bots_.length; i++) {
286             bots[bots_[i]] = true;
287         }
288     }
289 
290     function delBots(address[] memory notbot) public onlyOwner {
291       for (uint i = 0; i < notbot.length; i++) {
292           bots[notbot[i]] = false;
293       }
294     }
295 
296     function openTrading() external onlyOwner() {
297         require(!tradingOpen,"trading is already open");
298         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
299         _approve(address(this), address(uniswapV2Router), _tTotal);
300         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
301         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
302         swapEnabled = true;
303         tradingOpen = true;
304         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
305     }
306 
307     function reduceFee(uint256 _newFee) external{
308       require(_msgSender()==_taxWallet);
309       require(_newFee<2);
310       _finalTax=_newFee;
311     }
312 
313     receive() external payable {}
314 
315     function manualSwap() external {
316         require(_msgSender() == _taxWallet);
317         swapTokensForEth(balanceOf(address(this)));
318     }
319 
320     function manualSend() external {
321         require(_msgSender() == _taxWallet);
322         sendETHToFee(address(this).balance);
323     }
324 }