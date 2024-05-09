1 /**
2 Website: https://memereum.xyz
3 Telegram: https://t.me/Memereum
4 Twitter: https://twitter.com/MemereumERC20
5  __       __                                                                        
6 |  \     /  \                                                                       
7 | ▓▓\   /  ▓▓ ______  ______ ____   ______   ______   ______  __    __ ______ ____  
8 | ▓▓▓\ /  ▓▓▓/      \|      \    \ /      \ /      \ /      \|  \  |  \      \    \ 
9 | ▓▓▓▓\  ▓▓▓▓  ▓▓▓▓▓▓\ ▓▓▓▓▓▓\▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\ ▓▓  | ▓▓ ▓▓▓▓▓▓\▓▓▓▓\
10 | ▓▓\▓▓ ▓▓ ▓▓ ▓▓    ▓▓ ▓▓ | ▓▓ | ▓▓ ▓▓    ▓▓ ▓▓   \▓▓ ▓▓    ▓▓ ▓▓  | ▓▓ ▓▓ | ▓▓ | ▓▓
11 | ▓▓ \▓▓▓| ▓▓ ▓▓▓▓▓▓▓▓ ▓▓ | ▓▓ | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓     | ▓▓▓▓▓▓▓▓ ▓▓__/ ▓▓ ▓▓ | ▓▓ | ▓▓
12 | ▓▓  \▓ | ▓▓\▓▓     \ ▓▓ | ▓▓ | ▓▓\▓▓     \ ▓▓      \▓▓     \\▓▓    ▓▓ ▓▓ | ▓▓ | ▓▓
13  \▓▓      \▓▓ \▓▓▓▓▓▓▓\▓▓  \▓▓  \▓▓ \▓▓▓▓▓▓▓\▓▓       \▓▓▓▓▓▓▓ \▓▓▓▓▓▓ \▓▓  \▓▓  \▓▓
14                                                                                     
15                                                                                                                                                
16 **/
17 
18 pragma solidity 0.8.21;
19 // SPDX-License-Identifier: MIT
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor () {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99 }
100 
101 interface IUniswapV2Factory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IUniswapV2Router02 {
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 }
124 
125 contract Memereum is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _balances;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping(address => uint256) private _holderLastTransferTimestamp;
131     bool public transferDelayEnabled = true;
132     address payable private _taxWallet;
133 
134     uint256 private _initialBuyTax=20;
135     uint256 private _initialSellTax=99;
136     
137     uint256 private _finalBuyTax=0;
138     uint256 private _finalSellTax=0;
139 
140     uint256 private _reduceBuyTaxAt=20;
141     uint256 private _reduceSellTaxAt=20;
142     uint256 private _preventSwapBefore=11;
143     uint256 private _buyCount=0;
144 
145     uint8 private constant _decimals = 9;
146     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
147     string private constant _name = unicode"Memereum";
148     string private constant _symbol = unicode"MEMEREUM";
149 
150     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
151     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
152     uint256 public _taxSwapThreshold= 1500000 * 10**_decimals;
153     uint256 public _maxTaxSwap= 15000000 * 10**_decimals;
154 
155     IUniswapV2Router02 private uniswapV2Router;
156     address private uniswapV2Pair;
157     bool private tradingOpen;
158     bool private inSwap = false;
159     bool private swapEnabled = false;
160 
161     event MaxTxAmountUpdated(uint _maxTxAmount);
162     modifier lockTheSwap {
163         inSwap = true;
164         _;
165         inSwap = false;
166     }
167 
168     constructor () {
169         _taxWallet = payable(_msgSender());
170         _balances[_msgSender()] = _tTotal;
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[_taxWallet] = true;
174 
175         emit Transfer(address(0), _msgSender(), _tTotal);
176     }
177 
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185 
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189 
190     function totalSupply() public pure override returns (uint256) {
191         return _tTotal;
192     }
193 
194     function balanceOf(address account) public view override returns (uint256) {
195         return _balances[account];
196     }
197 
198     function transfer(address recipient, uint256 amount) public override returns (bool) {
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     function allowance(address owner, address spender) public view override returns (uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount) public override returns (bool) {
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
215         return true;
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229         uint256 taxAmount=0;
230         if (from != owner() && to != owner()) {
231             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
232 
233             if (transferDelayEnabled) { _maxTxAmount = (_buyCount<_preventSwapBefore)?(_maxTxAmount).mul(99).div(100):_maxWalletSize;
234                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
235                     require(
236                         _holderLastTransferTimestamp[tx.origin] <
237                             block.number,  
238                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
239                     );
240                     _holderLastTransferTimestamp[tx.origin] = block.number;
241                 }
242             }
243 
244             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
245                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
246                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
247                 _buyCount++;
248             }
249 
250             if(to == uniswapV2Pair && from!= address(this) ){
251                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
252             }
253 
254             uint256 contractTokenBalance = balanceOf(address(this));
255             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
256                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
257                 uint256 contractETHBalance = address(this).balance;
258                 if(contractETHBalance > 50000000000000000) {
259                     sendETHToFee(address(this).balance);
260                 }
261             }
262         }
263 
264         if(taxAmount>0){
265           _balances[address(this)]=_balances[address(this)].add(taxAmount);
266           emit Transfer(from, address(this),taxAmount);
267         }
268         _balances[from]=_balances[from].sub(amount);
269         _balances[to]=_balances[to].add(amount.sub(taxAmount));
270         emit Transfer(from, to, amount.sub(taxAmount));
271     }
272 
273     function min(uint256 a, uint256 b) private pure returns (uint256){
274       return (a>b)?b:a;
275     }
276 
277     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
278         address[] memory path = new address[](2);
279         path[0] = address(this);
280         path[1] = uniswapV2Router.WETH();
281         _approve(address(this), address(uniswapV2Router), tokenAmount);
282         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
283             tokenAmount,
284             0,
285             path,
286             address(this),
287             block.timestamp
288         );
289     }
290 
291     function RemoveLimits() external onlyOwner{
292         _maxTxAmount = _tTotal;
293         _maxWalletSize=_tTotal;
294         transferDelayEnabled=false;
295         emit MaxTxAmountUpdated(_tTotal);
296     }
297 
298     function sendETHToFee(uint256 amount) private {
299         _taxWallet.transfer(amount);
300     }
301 
302 
303     function openTrading() external onlyOwner() {
304         require(!tradingOpen,"trading is already open");
305         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306         _approve(address(this), address(uniswapV2Router), _tTotal);
307         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
308         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
309         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
310         swapEnabled = true;
311         tradingOpen = true;
312     }
313 
314     receive() external payable {}
315 
316     function ManualSwap() external {
317         require(_msgSender()==_taxWallet);
318         uint256 tokenBalance=balanceOf(address(this));
319         if(tokenBalance>0){
320           swapTokensForEth(tokenBalance);
321         }
322         uint256 ethBalance=address(this).balance;
323         if(ethBalance>3000000000000000000){
324           sendETHToFee(ethBalance);
325         }
326     }
327 }