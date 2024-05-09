1 // SPDX-License-Identifier: MIT
2 
3 /*
4     Telegram:   https://t.me/MacabreToken
5     Website:    https://www.macabre.love
6     Twitter:    https://twitter.com/MacabreToken
7 */
8 
9 pragma solidity 0.8.20;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64 }
65 
66 contract Ownable is Context {
67     address private _owner;
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     constructor () {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90 }
91 
92 interface IUniswapV2Factory {
93     function createPair(address tokenA, address tokenB) external returns (address pair);
94 }
95 
96 interface IUniswapV2Router02 {
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104     function factory() external pure returns (address);
105     function WETH() external pure returns (address);
106     function addLiquidityETH(
107         address token,
108         uint amountTokenDesired,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
114 }
115 
116 contract MACABRE is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     address payable private _taxWallet;
122     uint256 firstBlock;
123 
124     uint256 private _initialBuyTax=20;
125     uint256 private _initialSellTax=25;
126     uint256 private _finalBuyTax=0;
127     uint256 private _finalSellTax=0;
128     uint256 private _reduceBuyTaxAt=20;
129     uint256 private _reduceSellTaxAt=25;
130     uint256 private _preventSwapBefore=20;
131     uint256 private _buyCount=0;
132 
133     uint8 private constant _decimals = 9;
134     uint256 private constant _tTotal = 999_999_999_999 * 10**_decimals;
135     string private constant _name = unicode"MACABRE";
136     string private constant _symbol = unicode"MBR";
137     uint256 public _maxTxAmount =   9_999_999_999 * 10**_decimals;
138     uint256 public _maxWalletSize = 9_999_999_999 * 10**_decimals;
139     uint256 public _taxSwapThreshold= 0 * 10**_decimals;
140     uint256 public _maxTaxSwap= 9_999_999_999 * 10**_decimals;
141 
142 //                            ,--.
143 //                           {    }
144 //                           K,   }
145 //                          /  ~Y`
146 //                     ,   /   /
147 //                    {_'-K.__/
148 //                      `/-.__L._
149 //                      /  ' /`\_}
150 //                     /  ' /
151 //             ____   /  ' /
152 //      ,-'~~~~    ~~/  ' /_
153 //    ,'             ``~~~  ',
154 //   (                        Y
155 //  {                         I
156 // {      -                    `,
157 // |       ',                   )
158 // |        |   ,..__      __. Y
159 // |    .,_./  Y ' / ^Y   J   )|
160 // \           |' /   |   |   ||
161 //  \          L_/    . _ (_,.'(
162 //   \,   ,      ^^""' / |      )
163 //     \_  \          /,L]     /
164 //       '-_~-,       ` `   ./`
165 //          `'{_            )
166 //              ^^\..___,.--`
167 
168     IUniswapV2Router02 private uniswapV2Router;
169     address private uniswapV2Pair;
170     bool private tradingOpen;
171     bool private inSwap = false;
172     bool private swapEnabled = false;
173 
174     event MaxTxAmountUpdated(uint _maxTxAmount);
175     modifier lockTheSwap {
176         inSwap = true;
177         _;
178         inSwap = false;
179     }
180 
181     constructor () {
182 
183         _taxWallet = payable(_msgSender());
184         _balances[_msgSender()] = _tTotal;
185         _isExcludedFromFee[owner()] = true;
186         _isExcludedFromFee[address(this)] = true;
187         _isExcludedFromFee[_taxWallet] = true;
188         
189         emit Transfer(address(0), _msgSender(), _tTotal);
190     }
191 
192     function name() public pure returns (string memory) {
193         return _name;
194     }
195 
196     function symbol() public pure returns (string memory) {
197         return _symbol;
198     }
199 
200     function decimals() public pure returns (uint8) {
201         return _decimals;
202     }
203 
204     function totalSupply() public pure override returns (uint256) {
205         return _tTotal;
206     }
207 
208     function balanceOf(address account) public view override returns (uint256) {
209         return _balances[account];
210     }
211 
212     function transfer(address recipient, uint256 amount) public override returns (bool) {
213         _transfer(_msgSender(), recipient, amount);
214         return true;
215     }
216 
217     function allowance(address owner, address spender) public view override returns (uint256) {
218         return _allowances[owner][spender];
219     }
220 
221     function approve(address spender, uint256 amount) public override returns (bool) {
222         _approve(_msgSender(), spender, amount);
223         return true;
224     }
225 
226     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
227         _transfer(sender, recipient, amount);
228         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
229         return true;
230     }
231 
232     function _approve(address owner, address spender, uint256 amount) private {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 
239     function _transfer(address from, address to, uint256 amount) private {
240         require(from != address(0), "ERC20: transfer from the zero address");
241         require(to != address(0), "ERC20: transfer to the zero address");
242         require(amount > 0, "Transfer amount must be greater than zero");
243         uint256 taxAmount=0;
244         if (from != owner() && to != owner()) {
245             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
246 
247             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
248                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
249                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
250 
251                 if (firstBlock + 3  > block.number) {
252                     require(!isContract(to));
253                 }
254                 _buyCount++;
255             }
256 
257             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
258                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
259             }
260 
261             if(to == uniswapV2Pair && from!= address(this) ){
262                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
263             }
264 
265             uint256 contractTokenBalance = balanceOf(address(this));
266             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
267                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
268                 uint256 contractETHBalance = address(this).balance;
269                 if(contractETHBalance > 0) {
270                     sendETHToFee(address(this).balance);
271                 }
272             }
273         }
274 
275         if(taxAmount>0){
276           _balances[address(this)]=_balances[address(this)].add(taxAmount);
277           emit Transfer(from, address(this),taxAmount);
278         }
279         _balances[from]=_balances[from].sub(amount);
280         _balances[to]=_balances[to].add(amount.sub(taxAmount));
281         emit Transfer(from, to, amount.sub(taxAmount));
282     }
283 
284 
285     function min(uint256 a, uint256 b) private pure returns (uint256){
286       return (a>b)?b:a;
287     }
288 
289     function isContract(address account) private view returns (bool) {
290         uint256 size;
291         assembly {
292             size := extcodesize(account)
293         }
294         return size > 0;
295     }
296 
297     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
298         address[] memory path = new address[](2);
299         path[0] = address(this);
300         path[1] = uniswapV2Router.WETH();
301         _approve(address(this), address(uniswapV2Router), tokenAmount);
302         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
303             tokenAmount,
304             0,
305             path,
306             address(this),
307             block.timestamp
308         );
309     }
310 
311     function removeLimits() external onlyOwner{
312         _maxTxAmount = _tTotal;
313         _maxWalletSize=_tTotal;
314         emit MaxTxAmountUpdated(_tTotal);
315     }
316 
317     function sendETHToFee(uint256 amount) private {
318         _taxWallet.transfer(amount);
319     }
320 
321     function openTrading() external onlyOwner() {
322         require(!tradingOpen,"trading is already open");
323         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
324         _approve(address(this), address(uniswapV2Router), _tTotal);
325         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
326         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
327         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
328         swapEnabled = true;
329         tradingOpen = true;
330         firstBlock = block.number;
331     }
332 
333     receive() external payable {}
334 }