1 /**
2 TG: https://t.me/babypepe2erc
3 */
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity 0.8.20;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor () {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87 }
88 
89 interface IUniswapV2Factory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IUniswapV2Router02 {
94     function swapExactTokensForETHSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103     function addLiquidityETH(
104         address token,
105         uint amountTokenDesired,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
111 }
112 
113 contract BabyPepeTwo is Context, IERC20, Ownable {
114     using SafeMath for uint256;
115     mapping (address => uint256) private _balances;
116     mapping (address => mapping (address => uint256)) private _allowances;
117     mapping (address => bool) private _isExcludedFromFee;
118     address payable private _taxWallet;
119     uint256 firstBlock;
120 
121     uint256 private _initialBuyTax=23;
122     uint256 private _initialSellTax=30;
123     uint256 private _finalBuyTax=0;
124     uint256 private _finalSellTax=0;
125     uint256 private _reduceBuyTaxAt=10;
126     uint256 private _reduceSellTaxAt=10;
127     uint256 private _preventSwapBefore=20;
128     uint256 private _buyCount=0;
129 
130     uint8 private constant _decimals = 9;
131     uint256 private constant _tTotal = 100000000 * 10**_decimals;
132     string private constant _name = unicode"Baby PEPE 2.0";
133     string private constant _symbol = unicode"BPEPE 2.0";
134     uint256 public _maxTxAmount =   2000000 * 10**_decimals;
135     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
136     uint256 public _taxSwapThreshold= 900000 * 10**_decimals;
137     uint256 public _maxTaxSwap= 900000 * 10**_decimals;
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
153 
154         _taxWallet = payable(_msgSender());
155         _balances[_msgSender()] = _tTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_taxWallet] = true;
159         
160         emit Transfer(address(0), _msgSender(), _tTotal);
161     }
162 
163     function name() public pure returns (string memory) {
164         return _name;
165     }
166 
167     function symbol() public pure returns (string memory) {
168         return _symbol;
169     }
170 
171     function decimals() public pure returns (uint8) {
172         return _decimals;
173     }
174 
175     function totalSupply() public pure override returns (uint256) {
176         return _tTotal;
177     }
178 
179     function balanceOf(address account) public view override returns (uint256) {
180         return _balances[account];
181     }
182 
183     function transfer(address recipient, uint256 amount) public override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     function allowance(address owner, address spender) public view override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     function approve(address spender, uint256 amount) public override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202 
203     function _approve(address owner, address spender, uint256 amount) private {
204         require(owner != address(0), "ERC20: approve from the zero address");
205         require(spender != address(0), "ERC20: approve to the zero address");
206         _allowances[owner][spender] = amount;
207         emit Approval(owner, spender, amount);
208     }
209 
210     function _transfer(address from, address to, uint256 amount) private {
211         require(from != address(0), "ERC20: transfer from the zero address");
212         require(to != address(0), "ERC20: transfer to the zero address");
213         require(amount > 0, "Transfer amount must be greater than zero");
214         uint256 taxAmount=0;
215         if (from != owner() && to != owner()) {
216             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
217 
218             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
219                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
220                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
221 
222                 if (firstBlock + 3  > block.number) {
223                     require(!isContract(to));
224                 }
225                 _buyCount++;
226             }
227 
228             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
229                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
230             }
231 
232             if(to == uniswapV2Pair && from!= address(this) ){
233                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
234             }
235 
236             uint256 contractTokenBalance = balanceOf(address(this));
237             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
238                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
239                 uint256 contractETHBalance = address(this).balance;
240                 if(contractETHBalance > 0) {
241                     sendETHToFee(address(this).balance);
242                 }
243             }
244         }
245 
246         if(taxAmount>0){
247           _balances[address(this)]=_balances[address(this)].add(taxAmount);
248           emit Transfer(from, address(this),taxAmount);
249         }
250         _balances[from]=_balances[from].sub(amount);
251         _balances[to]=_balances[to].add(amount.sub(taxAmount));
252         emit Transfer(from, to, amount.sub(taxAmount));
253     }
254 
255 
256     function min(uint256 a, uint256 b) private pure returns (uint256){
257       return (a>b)?b:a;
258     }
259 
260     function isContract(address account) private view returns (bool) {
261         uint256 size;
262         assembly {
263             size := extcodesize(account)
264         }
265         return size > 0;
266     }
267 
268     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = uniswapV2Router.WETH();
272         _approve(address(this), address(uniswapV2Router), tokenAmount);
273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp
279         );
280     }
281 
282     function removeLimits() external onlyOwner{
283         _maxTxAmount = _tTotal;
284         _maxWalletSize=_tTotal;
285         emit MaxTxAmountUpdated(_tTotal);
286     }
287 
288     function sendETHToFee(uint256 amount) private {
289         _taxWallet.transfer(amount);
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
301         firstBlock = block.number;
302     }
303 
304     receive() external payable {}
305 }