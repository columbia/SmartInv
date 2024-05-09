1 // SPDX-License-Identifier: MIT
2 /**
3 
4 **/
5 pragma solidity 0.8.17;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40 
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         return c;
58     }
59 
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     constructor () {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     function owner() public view returns (address) {
73         return _owner;
74     }
75 
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86 }
87 
88 interface IUniswapV2Factory {
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 }
91 
92 interface IUniswapV2Router02 {
93     function swapExactTokensForETHSupportingFeeOnTransferTokens(
94         uint amountIn,
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external;
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102     function addLiquidityETH(
103         address token,
104         uint amountTokenDesired,
105         uint amountTokenMin,
106         uint amountETHMin,
107         address to,
108         uint deadline
109     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
110 }
111 
112 contract AllIn is Context, IERC20, Ownable {
113     using SafeMath for uint256;
114     mapping (address => uint256) private _balances;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     address payable private _taxWallet;
119 
120     uint256 private _initialTax=5;
121     uint256 private _finalTax=4;
122     uint256 private _reduceTaxAt=20;
123     uint256 private _preventSwapBefore=20;
124     uint256 private _buyCount=0;
125 
126     uint8 private constant _decimals = 9;
127     uint256 private constant _tTotal = 1_000_000 * 10**_decimals;
128     string private constant _name = unicode"All In";
129     string private constant _symbol = unicode"AllIn";
130     uint256 public _maxTxAmount = 20_000 * 10**_decimals;
131     uint256 public _maxWalletSize = 20_000 * 10**_decimals;
132     uint256 public _taxSwap= 10_000 * 10**_decimals;
133 
134     IUniswapV2Router02 private uniswapV2Router;
135     address private uniswapV2Pair;
136     bool private tradingOpen;
137     bool private inSwap = false;
138     bool private swapEnabled = false;
139 
140     event MaxTxAmountUpdated(uint _maxTxAmount);
141     modifier lockTheSwap {
142         inSwap = true;
143         _;
144         inSwap = false;
145     }
146 
147     constructor () {
148         _taxWallet = payable(_msgSender());
149         _balances[_msgSender()] = _tTotal;
150         _isExcludedFromFee[owner()] = true;
151         _isExcludedFromFee[address(this)] = true;
152         _isExcludedFromFee[_taxWallet] = true;
153 
154         emit Transfer(address(0), _msgSender(), _tTotal);
155     }
156 
157     function name() public pure returns (string memory) {
158         return _name;
159     }
160 
161     function symbol() public pure returns (string memory) {
162         return _symbol;
163     }
164 
165     function decimals() public pure returns (uint8) {
166         return _decimals;
167     }
168 
169     function totalSupply() public pure override returns (uint256) {
170         return _tTotal;
171     }
172 
173     function balanceOf(address account) public view override returns (uint256) {
174         return _balances[account];
175     }
176 
177     function transfer(address recipient, uint256 amount) public override returns (bool) {
178         _transfer(_msgSender(), recipient, amount);
179         return true;
180     }
181 
182     function allowance(address owner, address spender) public view override returns (uint256) {
183         return _allowances[owner][spender];
184     }
185 
186     function approve(address spender, uint256 amount) public override returns (bool) {
187         _approve(_msgSender(), spender, amount);
188         return true;
189     }
190 
191     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
192         _transfer(sender, recipient, amount);
193         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
194         return true;
195     }
196 
197     function _approve(address owner, address spender, uint256 amount) private {
198         require(owner != address(0), "ERC20: approve from the zero address");
199         require(spender != address(0), "ERC20: approve to the zero address");
200         _allowances[owner][spender] = amount;
201         emit Approval(owner, spender, amount);
202     }
203 
204     function _transfer(address from, address to, uint256 amount) private {
205         require(from != address(0), "ERC20: transfer from the zero address");
206         require(to != address(0), "ERC20: transfer to the zero address");
207         require(amount > 0, "Transfer amount must be greater than zero");
208         uint256 taxAmount=0;
209         if (from != owner() && to != owner()) {
210             require(!bots[from] && !bots[to]);
211             if(!inSwap){
212               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
213             }
214 
215             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
216                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
217                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
218                 _buyCount++;
219             }
220 
221             uint256 contractTokenBalance = balanceOf(address(this));
222             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _buyCount>_preventSwapBefore) {
223                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
224                 uint256 contractETHBalance = address(this).balance;
225                 if(contractETHBalance > 0) {
226                     sendETHToFee(address(this).balance);
227                 }
228             }
229         }
230 
231         _balances[from]=_balances[from].sub(amount);
232         _balances[to]=_balances[to].add(amount.sub(taxAmount));
233         emit Transfer(from, to, amount.sub(taxAmount));
234         if(taxAmount>0){
235           _balances[address(this)]=_balances[address(this)].add(taxAmount);
236           emit Transfer(from, address(this),taxAmount);
237         }
238     }
239 
240     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
241         address[] memory path = new address[](2);
242         path[0] = address(this);
243         path[1] = uniswapV2Router.WETH();
244         _approve(address(this), address(uniswapV2Router), tokenAmount);
245         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
246             tokenAmount,
247             0,
248             path,
249             address(this),
250             block.timestamp
251         );
252     }
253 
254     function removeLimits() external onlyOwner{
255         _maxTxAmount = _tTotal;
256         _maxWalletSize=_tTotal;
257         emit MaxTxAmountUpdated(_tTotal);
258     }
259 
260     function sendETHToFee(uint256 amount) private {
261         _taxWallet.transfer(amount);
262     }
263 
264     function addBots(address[] memory bots_) public onlyOwner {
265         for (uint i = 0; i < bots_.length; i++) {
266             bots[bots_[i]] = true;
267         }
268     }
269 
270     function delBots(address[] memory notbot) public onlyOwner {
271       for (uint i = 0; i < notbot.length; i++) {
272           bots[notbot[i]] = false;
273       }
274     }
275 
276     function openTrading() external onlyOwner() {
277         require(!tradingOpen,"trading is already open");
278         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
279         _approve(address(this), address(uniswapV2Router), _tTotal);
280         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
281         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
282         swapEnabled = true;
283         tradingOpen = true;
284         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
285     }
286 
287     function reduceFee(uint256 _newFee) external{
288       require(_msgSender()==_taxWallet);
289       require(_newFee<2);
290       _finalTax=_newFee;
291     }
292 
293     receive() external payable {}
294 
295     function manualSwap() external {
296         require(_msgSender() == _taxWallet);
297         swapTokensForEth(balanceOf(address(this)));
298     }
299 
300     function manualSend() external {
301         require(_msgSender() == _taxWallet);
302         sendETHToFee(address(this).balance);
303     }
304 }