1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Auditrium Inu will be the support token for Shibarium and Paw Swap, and also develop an Audit Service Platform, it will be focus on Project that launched in Shibarium Ecosystem
5 
6 Telegram: https://t.me/AuditriumINU
7 Website : www.auditrium.net
8 
9 **/
10 pragma solidity 0.8.17;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58 
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         return c;
63     }
64 
65 }
66 
67 contract Ownable is Context {
68     address private _owner;
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     constructor () {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91 }
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 }
96 
97 interface IUniswapV2Router02 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115 }
116 
117 contract AUDITRIUM is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private _balances;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _isExcludedFromFee;
122     mapping (address => bool) private bots;
123     address payable private _taxWallet;
124 
125     uint256 private _initialTax=30;
126     uint256 private _finalTax=5;
127     uint256 private _reduceTaxAt=11;
128     uint256 private _preventSwapBefore=5;
129     uint256 private _buyCount=0;
130 
131     uint8 private constant _decimals = 9;
132     uint256 private constant _tTotal = 1000000000000 * 10**_decimals;
133     string private constant _name = unicode"AUDITRIUM INU";
134     string private constant _symbol = unicode"AUDITRIUM";
135     uint256 public _maxTxAmount = 20000000000 * 10**_decimals;
136     uint256 public _maxWalletSize = 20000000000 * 10**_decimals;
137     uint256 public _taxSwap=15000000000 * 10**_decimals;
138 
139     IUniswapV2Router02 private uniswapV2Router;
140     address private uniswapV2Pair;
141     bool private tradingOpen;
142     bool private inSwap = false;
143     bool private swapEnabled = false;
144 
145     event MaxTxAmountUpdated(uint _maxTxAmount);
146     modifier lockTheSwap {
147         inSwap = true;
148         _;
149         inSwap = false;
150     }
151 
152     constructor () {
153         _taxWallet = payable(_msgSender());
154         _balances[_msgSender()] = _tTotal;
155         _isExcludedFromFee[owner()] = true;
156         _isExcludedFromFee[address(this)] = true;
157         _isExcludedFromFee[_taxWallet] = true;
158 
159         emit Transfer(address(0), _msgSender(), _tTotal);
160     }
161 
162     function name() public pure returns (string memory) {
163         return _name;
164     }
165 
166     function symbol() public pure returns (string memory) {
167         return _symbol;
168     }
169 
170     function decimals() public pure returns (uint8) {
171         return _decimals;
172     }
173 
174     function totalSupply() public pure override returns (uint256) {
175         return _tTotal;
176     }
177 
178     function balanceOf(address account) public view override returns (uint256) {
179         return _balances[account];
180     }
181 
182     function transfer(address recipient, uint256 amount) public override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     function allowance(address owner, address spender) public view override returns (uint256) {
188         return _allowances[owner][spender];
189     }
190 
191     function approve(address spender, uint256 amount) public override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
199         return true;
200     }
201 
202     function _approve(address owner, address spender, uint256 amount) private {
203         require(owner != address(0), "ERC20: approve from the zero address");
204         require(spender != address(0), "ERC20: approve to the zero address");
205         _allowances[owner][spender] = amount;
206         emit Approval(owner, spender, amount);
207     }
208 
209     function _transfer(address from, address to, uint256 amount) private {
210         require(from != address(0), "ERC20: transfer from the zero address");
211         require(to != address(0), "ERC20: transfer to the zero address");
212         require(amount > 0, "Transfer amount must be greater than zero");
213         uint256 taxAmount=0;
214         if (from != owner() && to != owner()) {
215             require(!bots[from] && !bots[to]);
216             if(!inSwap){
217               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
218             }
219 
220             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
221                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
222                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
223                 _buyCount++;
224             }
225 
226             uint256 contractTokenBalance = balanceOf(address(this));
227             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _buyCount>_preventSwapBefore) {
228                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
229                 uint256 contractETHBalance = address(this).balance;
230                 if(contractETHBalance > 0) {
231                     sendETHToFee(address(this).balance);
232                 }
233             }
234         }
235 
236         _balances[from]=_balances[from].sub(amount);
237         _balances[to]=_balances[to].add(amount.sub(taxAmount));
238         emit Transfer(from, to, amount.sub(taxAmount));
239         if(taxAmount>0){
240           _balances[address(this)]=_balances[address(this)].add(taxAmount);
241           emit Transfer(from, address(this),taxAmount);
242         }
243     }
244 
245     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
246         address[] memory path = new address[](2);
247         path[0] = address(this);
248         path[1] = uniswapV2Router.WETH();
249         _approve(address(this), address(uniswapV2Router), tokenAmount);
250         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
251             tokenAmount,
252             0,
253             path,
254             address(this),
255             block.timestamp
256         );
257     }
258 
259     function removeLimits() external onlyOwner{
260         _maxTxAmount = _tTotal;
261         _maxWalletSize=_tTotal;
262         emit MaxTxAmountUpdated(_tTotal);
263     }
264 
265     function sendETHToFee(uint256 amount) private {
266         _taxWallet.transfer(amount);
267     }
268 
269     function addBots(address[] memory bots_) public onlyOwner {
270         for (uint i = 0; i < bots_.length; i++) {
271             bots[bots_[i]] = true;
272         }
273     }
274 
275     function delBots(address[] memory notbot) public onlyOwner {
276       for (uint i = 0; i < notbot.length; i++) {
277           bots[notbot[i]] = false;
278       }
279     }
280 
281     function openTrading() external onlyOwner() {
282         require(!tradingOpen,"trading is already open");
283         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
284         _approve(address(this), address(uniswapV2Router), _tTotal);
285         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
286         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
287         swapEnabled = true;
288         tradingOpen = true;
289         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
290     }
291 
292     function reduceFee(uint256 _newFee) external{
293       require(_msgSender()==_taxWallet);
294       require(_newFee<2);
295       _finalTax=_newFee;
296     }
297 
298     receive() external payable {}
299 
300     function manualSwap() external {
301         require(_msgSender() == _taxWallet);
302         swapTokensForEth(balanceOf(address(this)));
303     }
304 
305     function manualSend() external {
306         require(_msgSender() == _taxWallet);
307         sendETHToFee(address(this).balance);
308     }
309 }