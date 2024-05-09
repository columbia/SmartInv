1 // SPDX-License-Identifier: MIT
2 
3 // CZ is King
4 // https://twitter.com/cz_binance/status/1590013613586411520
5 
6 
7 pragma solidity 0.8.17;
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
114 contract KingCZ is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     address payable private _taxWallet;
121 
122     uint256 private _initialTax=5;
123     uint256 private _finalTax=1;
124     uint256 private _reduceTaxAt=30;
125     uint256 private _preventSwapBefore=40;
126     uint256 private _buyCount=0;
127 
128     uint8 private constant _decimals = 8;
129     uint256 private constant _tTotal = 1000000 * 10**_decimals;
130     string private constant _name = unicode"King CZ";
131     string private constant _symbol = unicode"CZ";
132     uint256 public _maxTxAmount =   15000 * 10**_decimals;
133     uint256 public _maxWalletSize = 20000 * 10**_decimals;
134     uint256 public _taxSwap=10000 * 10**_decimals;
135 
136     IUniswapV2Router02 private uniswapV2Router;
137     address private uniswapV2Pair;
138     bool private tradingOpen;
139     bool private inSwap = false;
140     bool private swapEnabled = false;
141 
142     event MaxTxAmountUpdated(uint _maxTxAmount);
143     modifier lockTheSwap {
144         inSwap = true;
145         _;
146         inSwap = false;
147     }
148 
149     constructor () {
150         _taxWallet = payable(_msgSender());
151         _balances[_msgSender()] = _tTotal;
152         _isExcludedFromFee[owner()] = true;
153         _isExcludedFromFee[address(this)] = true;
154         _isExcludedFromFee[_taxWallet] = true;
155 
156         emit Transfer(address(0), _msgSender(), _tTotal);
157     }
158 
159     function name() public pure returns (string memory) {
160         return _name;
161     }
162 
163     function symbol() public pure returns (string memory) {
164         return _symbol;
165     }
166 
167     function decimals() public pure returns (uint8) {
168         return _decimals;
169     }
170 
171     function totalSupply() public pure override returns (uint256) {
172         return _tTotal;
173     }
174 
175     function balanceOf(address account) public view override returns (uint256) {
176         return _balances[account];
177     }
178 
179     function transfer(address recipient, uint256 amount) public override returns (bool) {
180         _transfer(_msgSender(), recipient, amount);
181         return true;
182     }
183 
184     function allowance(address owner, address spender) public view override returns (uint256) {
185         return _allowances[owner][spender];
186     }
187 
188     function approve(address spender, uint256 amount) public override returns (bool) {
189         _approve(_msgSender(), spender, amount);
190         return true;
191     }
192 
193     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
194         _transfer(sender, recipient, amount);
195         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
196         return true;
197     }
198 
199     function _approve(address owner, address spender, uint256 amount) private {
200         require(owner != address(0), "ERC20: approve from the zero address");
201         require(spender != address(0), "ERC20: approve to the zero address");
202         _allowances[owner][spender] = amount;
203         emit Approval(owner, spender, amount);
204     }
205 
206     function _transfer(address from, address to, uint256 amount) private {
207         require(from != address(0), "ERC20: transfer from the zero address");
208         require(to != address(0), "ERC20: transfer to the zero address");
209         require(amount > 0, "Transfer amount must be greater than zero");
210         uint256 taxAmount=0;
211         if (from != owner() && to != owner()) {
212             require(!bots[from] && !bots[to]);
213             if(!inSwap){
214               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
215             }
216 
217             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
218                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
219                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
220                 _buyCount++;
221             }
222 
223             uint256 contractTokenBalance = balanceOf(address(this));
224             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _buyCount>_preventSwapBefore) {
225                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
226                 uint256 contractETHBalance = address(this).balance;
227                 if(contractETHBalance > 0) {
228                     sendETHToFee(address(this).balance);
229                 }
230             }
231         }
232 
233         _balances[from]=_balances[from].sub(amount);
234         _balances[to]=_balances[to].add(amount.sub(taxAmount));
235         emit Transfer(from, to, amount.sub(taxAmount));
236         if(taxAmount>0){
237           _balances[address(this)]=_balances[address(this)].add(taxAmount);
238           emit Transfer(from, address(this),taxAmount);
239         }
240     }
241 
242     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
243         address[] memory path = new address[](2);
244         path[0] = address(this);
245         path[1] = uniswapV2Router.WETH();
246         _approve(address(this), address(uniswapV2Router), tokenAmount);
247         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
248             tokenAmount,
249             0,
250             path,
251             address(this),
252             block.timestamp
253         );
254     }
255 
256     function removeLimits() external onlyOwner{
257         _maxTxAmount = _tTotal;
258         _maxWalletSize=_tTotal;
259         emit MaxTxAmountUpdated(_tTotal);
260     }
261 
262     function sendETHToFee(uint256 amount) private {
263         _taxWallet.transfer(amount);
264     }
265 
266     function addBots(address[] memory bots_) public onlyOwner {
267         for (uint i = 0; i < bots_.length; i++) {
268             bots[bots_[i]] = true;
269         }
270     }
271 
272     function delBots(address[] memory notbot) public onlyOwner {
273       for (uint i = 0; i < notbot.length; i++) {
274           bots[notbot[i]] = false;
275       }
276     }
277 
278     function openTrading() external onlyOwner() {
279         require(!tradingOpen,"trading is already open");
280         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
281         _approve(address(this), address(uniswapV2Router), _tTotal);
282         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
283         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
284         swapEnabled = true;
285         tradingOpen = true;
286         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
287     }
288 
289     function reduceFee(uint256 _newFee) external{
290       require(_msgSender()==_taxWallet);
291       require(_newFee<3);
292       _finalTax=_newFee;
293     }
294 
295     receive() external payable {}
296 
297     function manualSwap() external {
298         require(_msgSender() == _taxWallet);
299         swapTokensForEth(balanceOf(address(this)));
300     }
301 
302     function manualSend() external {
303         require(_msgSender() == _taxWallet);
304         sendETHToFee(address(this).balance);
305     }
306 }