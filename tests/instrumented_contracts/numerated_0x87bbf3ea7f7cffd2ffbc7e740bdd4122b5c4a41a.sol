1 // SPDX-License-Identifier: MIT
2 /*
3 TG: https://t.me/XPEPE_ETH
4  */
5 pragma solidity 0.8.20;
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
112 contract XPEPE is Context, IERC20, Ownable {
113     using SafeMath for uint256;
114     mapping (address => uint256) private _balances;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping(address => uint256) private _holderLastTransferTimestamp;
118     bool public transferDelayEnabled = true;
119     address payable private _taxWallet;
120 
121     uint256 private _initialBuyTax=15;
122     uint256 private _initialSellTax=15;
123     uint256 private _finalBuyTax=1;
124     uint256 private _finalSellTax=1;
125     uint256 private _reduceBuyTaxAt=25;
126     uint256 private _reduceSellTaxAt=30;
127     uint256 private _preventSwapBefore=30;
128     uint256 private _buyCount=0;
129 
130     uint8 private constant _decimals = 9;
131     uint256 private constant _tTotal = 10000000000 * 10**_decimals;
132     string private constant _name = unicode"𝕏 PEPE";
133     string private constant _symbol = unicode"𝕏PEPE";
134     uint256 public _maxTxAmount = 200000000 * 10**_decimals;
135     uint256 public _maxWalletSize = 200000000 * 10**_decimals;
136     uint256 public _taxSwapThreshold= 125500001 * 10**_decimals;
137     uint256 public _maxTaxSwap= 150000000 * 10**_decimals;
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
215             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
216 
217             if (transferDelayEnabled) {
218                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
219                       require(
220                           _holderLastTransferTimestamp[tx.origin] <
221                               block.number,
222                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
223                       );
224                       _holderLastTransferTimestamp[tx.origin] = block.number;
225                   }
226               }
227 
228             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
229                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
230                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
231                 _buyCount++;
232             }
233 
234             if(to == uniswapV2Pair && from!= address(this) ){
235                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
236             }
237 
238             uint256 contractTokenBalance = balanceOf(address(this));
239             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
240                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
241                 uint256 contractETHBalance = address(this).balance;
242                 if(contractETHBalance > 0) {
243                     sendETHToFee(address(this).balance);
244                 }
245             }
246         }
247 
248         if(taxAmount>0){
249           _balances[address(this)]=_balances[address(this)].add(taxAmount);
250           emit Transfer(from, address(this),taxAmount);
251         }
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
287 
288     function openTrading() external onlyOwner() {
289         require(!tradingOpen,"trading is already open");
290         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
291         _approve(address(this), address(uniswapV2Router), _tTotal);
292         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
293         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
294         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
295         swapEnabled = true;
296         tradingOpen = true;
297     }
298 
299     receive() external payable {}
300 
301     function manualSwap() external {
302         require(_msgSender()==_taxWallet);
303         uint256 tokenBalance=balanceOf(address(this));
304         if(tokenBalance>0){
305           swapTokensForEth(tokenBalance);
306         }
307         uint256 ethBalance=address(this).balance;
308         if(ethBalance>0){
309           sendETHToFee(ethBalance);
310         }
311     }
312 }