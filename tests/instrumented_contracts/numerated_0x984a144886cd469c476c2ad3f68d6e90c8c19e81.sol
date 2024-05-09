1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.14;
3 
4 //website: http://www.20170904.xyz/
5 //twitter: https://twitter.com/20170904_ERC20
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
112 contract NineFour is Context, IERC20, Ownable {
113     using SafeMath for uint256;
114     mapping (address => uint256) private _balances;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private _whiteList;
118     mapping(address => uint256) private _holderLastTransferTimestamp;
119     bool public transferDelayEnabled = true;
120     address payable private _taxWallet;
121 
122     uint256 private _initialBuyTax=20;
123     uint256 private _initialSellTax=20;
124     uint256 private _finalBuyTax=1;
125     uint256 private _finalSellTax=1;
126     uint256 private _reduceBuyTaxAt=100;
127     uint256 private _reduceSellTaxAt=100;
128     uint256 private _buyCount=0;
129 
130     uint8 private constant _decimals = 9;
131     uint256 private constant _tTotal = 20170904 * 10**_decimals;
132     string private constant _name = unicode"20170904";
133     string private constant _symbol = unicode"94";
134     uint256 public _maxTxAmount = 20000 * 10**_decimals;
135     uint256 public _maxWalletSize = 20000 * 10**_decimals;
136     uint256 public _maxTaxSwap= 20000 * 10**_decimals;
137 
138     IUniswapV2Router02 private uniswapV2Router;
139     address private uniswapV2Pair;
140     bool private tradingOpen;
141     bool private inSwap = false;
142     bool private swapEnabled = false;
143 
144     event MaxTxAmountUpdated(uint _maxTxAmount);
145 
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
159         _whiteList[_taxWallet] = true;
160         _whiteList[address(this)] = true;
161         _whiteList[owner()] = true;
162 
163         emit Transfer(address(0), _msgSender(), _tTotal);
164     }
165 
166     function name() public pure returns (string memory) {
167         return _name;
168     }
169 
170     function symbol() public pure returns (string memory) {
171         return _symbol;
172     }
173 
174     function decimals() public pure returns (uint8) {
175         return _decimals;
176     }
177 
178     function totalSupply() public pure override returns (uint256) {
179         return _tTotal;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return _balances[account];
184     }
185 
186     function transfer(address recipient, uint256 amount) public override returns (bool) {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     function allowance(address owner, address spender) public view override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     function approve(address spender, uint256 amount) public override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
201         _transfer(sender, recipient, amount);
202         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
203         return true;
204     }
205 
206     function _approve(address owner, address spender, uint256 amount) private {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _transfer(address from, address to, uint256 amount) private {
214         require(from != address(0), "ERC20: transfer from the zero address");
215         require(to != address(0), "ERC20: transfer to the zero address");
216         require(amount > 0, "Transfer amount must be greater than zero");
217         uint256 taxAmount=0;
218         if (from != owner() && to != owner()) {
219             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
220 
221             if (transferDelayEnabled) {
222                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
223                       require(
224                           _holderLastTransferTimestamp[tx.origin] <
225                               block.number,
226                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
227                       );
228                       _holderLastTransferTimestamp[tx.origin] = block.number;
229                   }
230               }
231 
232            
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _whiteList[to] ) {
234                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
235                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
236                 _buyCount++;
237             }
238 
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && _whiteList[to] && ! _isExcludedFromFee[to] ) {
240                 require(amount <= _maxTxAmount * 5, "Exceeds the _maxTxAmount.");
241                 require(balanceOf(to) + amount <= _maxWalletSize * 5, "Exceeds the maxWalletSize.");
242                 _buyCount++;
243             }
244 
245             if((to == uniswapV2Pair && from!= address(this)) || (to == uniswapV2Pair && ! _isExcludedFromFee[from]) ){
246                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
247             }
248             
249         }
250 
251         if(taxAmount>0){
252           _balances[_taxWallet]=_balances[_taxWallet].add(taxAmount);
253           emit Transfer(from,_taxWallet,taxAmount);
254         }
255         _balances[from]=_balances[from].sub(amount);
256         _balances[to]=_balances[to].add(amount.sub(taxAmount));
257         emit Transfer(from, to, amount.sub(taxAmount));
258     }
259 
260     function min(uint256 a, uint256 b) private pure returns (uint256){
261       return (a>b)?b:a;
262     }
263 
264     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
265         address[] memory path = new address[](2);
266         path[0] = address(this);
267         path[1] = uniswapV2Router.WETH();
268         _approve(address(this), address(uniswapV2Router), tokenAmount);
269         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
270             tokenAmount,
271             0,
272             path,
273             address(this),
274             block.timestamp
275         );
276     }
277 
278     function removeLimits() external onlyOwner{
279         _maxTxAmount = _tTotal;
280         _maxWalletSize=_tTotal;
281         transferDelayEnabled=false;
282         emit MaxTxAmountUpdated(_tTotal);
283     }
284 
285     function sendETHToFee(uint256 amount) private {
286         _taxWallet.transfer(amount);
287     }
288 
289     function openTrading() external onlyOwner() {
290         require(!tradingOpen,"trading is already open");
291         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
292         _approve(address(this), address(uniswapV2Router), _tTotal);
293         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
294         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
295         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
296         swapEnabled = true;
297         tradingOpen = true;
298     }
299 
300     function reduceFee(uint256 _newFee) external{
301       require(_msgSender()==_taxWallet);
302       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
303       _finalBuyTax=_newFee;
304       _finalSellTax=_newFee;
305     }
306 
307     receive() external payable {}
308 
309     function manualSwap() external {
310         require(_msgSender()==_taxWallet);
311         uint256 tokenBalance=balanceOf(address(this));
312         if(tokenBalance>0){
313           swapTokensForEth(tokenBalance);
314         }
315         uint256 ethBalance=address(this).balance;
316         if(ethBalance>0){
317           sendETHToFee(ethBalance);
318         }
319     }
320 
321     function manualsend() external {
322         uint256 ethBalance=address(this).balance;
323         if(ethBalance>0){
324           sendETHToFee(ethBalance);
325         }
326     }
327 
328     function setWhiteList(address account) public onlyOwner {
329         _whiteList[account] = true;
330     }
331 
332     function bundleSetWhiteList(address[] memory accounts) public onlyOwner {
333         for (uint i = 0;i<accounts.length;i++) {
334             _whiteList[accounts[i]] = true;
335         }
336     }
337 }