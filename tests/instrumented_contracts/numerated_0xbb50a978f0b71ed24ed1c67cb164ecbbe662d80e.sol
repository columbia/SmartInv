1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 Telegram: https://t.me/reversepepeportal
6 Twitter: https://x.com/reversepepecoin
7 Website: https://reversepepe.wtf/
8 
9 */
10 
11 pragma solidity 0.8.20;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor () {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92 }
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 }
117 
118 contract pepe is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _balances;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) public marketPair;
124     address payable private _taxWallet;
125     uint256 firstBlock;
126 
127     uint256 private _initialBuyTax=26;
128     uint256 private _initialSellTax=26;
129     uint256 private _finalBuyTax=1;
130     uint256 private _finalSellTax=1;
131     uint256 private _reduceBuyTaxAt=45;
132     uint256 private _reduceSellTaxAt=45;
133     uint256 private _preventSwapBefore=60;
134     uint256 private _buyCount=0;
135 
136     uint8 private constant _decimals = 9;
137     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
138     string private constant _name = unicode"ǝdǝd";
139     string private constant _symbol = unicode"ǝdǝd";
140     uint256 public _maxTxAmount = 2524140000000 * 10**_decimals;
141     uint256 public _maxWalletSize = 2524140000000 * 10**_decimals;
142     uint256 public _taxSwapThreshold= 2524140000000 * 10**_decimals;
143     uint256 public _maxTaxSwap= 2524140000000 * 10**_decimals;
144 
145     IUniswapV2Router02 private uniswapV2Router;
146     address public uniswapV2Pair;
147     bool private tradingOpen;
148     bool private inSwap = false;
149     bool private swapEnabled = false;
150 
151     event MaxTxAmountUpdated(uint _maxTxAmount);
152     modifier lockTheSwap {
153         inSwap = true;
154         _;
155         inSwap = false;
156     }
157 
158     constructor () {
159 
160         _taxWallet = payable(_msgSender());
161         _balances[_msgSender()] = _tTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_taxWallet] = true;
165         
166         emit Transfer(address(0), _msgSender(), _tTotal);
167     }
168 
169     function name() public pure returns (string memory) {
170         return _name;
171     }
172 
173     function symbol() public pure returns (string memory) {
174         return _symbol;
175     }
176 
177     function decimals() public pure returns (uint8) {
178         return _decimals;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return _balances[account];
187     }
188 
189     function transfer(address recipient, uint256 amount) public override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function _approve(address owner, address spender, uint256 amount) private {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214     }
215 
216     function setMarketPair(address addr) public onlyOwner {
217         marketPair[addr] = true;
218     }
219 
220     function _transfer(address from, address to, uint256 amount) private {
221         require(from != address(0), "ERC20: transfer from the zero address");
222         require(to != address(0), "ERC20: transfer to the zero address");
223         require(amount > 0, "Transfer amount must be greater than zero");
224         uint256 taxAmount=0;
225         if (from != owner() && to != owner()) {
226             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
227 
228             if (marketPair[from] && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
229                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
230                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
231 
232                 if (firstBlock + 3  > block.number) {
233                     require(!isContract(to));
234                 }
235                 _buyCount++;
236             }
237 
238             if (!marketPair[to] && ! _isExcludedFromFee[to]) {
239                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
240             }
241 
242             if(marketPair[to] && from!= address(this) ){
243                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
244             }
245 
246             uint256 contractTokenBalance = balanceOf(address(this));
247             if (!inSwap && marketPair[to] && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
248                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
249                 uint256 contractETHBalance = address(this).balance;
250                 if(contractETHBalance > 0) {
251                     sendETHToFee(address(this).balance);
252                 }
253             }
254         }
255 
256         if(taxAmount>0){
257           _balances[address(this)]=_balances[address(this)].add(taxAmount);
258           emit Transfer(from, address(this),taxAmount);
259         }
260         _balances[from]=_balances[from].sub(amount);
261         _balances[to]=_balances[to].add(amount.sub(taxAmount));
262         emit Transfer(from, to, amount.sub(taxAmount));
263     }
264 
265 
266     function min(uint256 a, uint256 b) private pure returns (uint256){
267       return (a>b)?b:a;
268     }
269 
270     function isContract(address account) private view returns (bool) {
271         uint256 size;
272         assembly {
273             size := extcodesize(account)
274         }
275         return size > 0;
276     }
277 
278     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
279         address[] memory path = new address[](2);
280         path[0] = address(this);
281         path[1] = uniswapV2Router.WETH();
282         _approve(address(this), address(uniswapV2Router), tokenAmount);
283         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
284             tokenAmount,
285             0,
286             path,
287             address(this),
288             block.timestamp
289         );
290     }
291 
292     function clearStuckEth() public {
293         require(_msgSender() == _taxWallet);
294         payable(msg.sender).transfer(address(this).balance);
295     }
296 
297     function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public {
298         require(_msgSender() == _taxWallet);
299         IERC20(_tokenAddr).transfer(_to, _amount);
300     }
301 
302     function manualSwap() external {
303         require(_msgSender()==_taxWallet);
304         uint256 tokenBalance=balanceOf(address(this));
305         if(tokenBalance>0){
306           swapTokensForEth(tokenBalance);
307         }
308         uint256 ethBalance=address(this).balance;
309         if(ethBalance>0){
310           sendETHToFee(ethBalance);
311         }
312     }
313 
314     function removeLimits() external onlyOwner{
315         _maxTxAmount = _tTotal;
316         _maxWalletSize=_tTotal;
317         emit MaxTxAmountUpdated(_tTotal);
318     }
319 
320     function sendETHToFee(uint256 amount) private {
321         _taxWallet.transfer(amount);
322     }
323 
324     function openTrading() external onlyOwner() {
325         require(!tradingOpen,"trading is already open");
326         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
327         _approve(address(this), address(uniswapV2Router), _tTotal);
328         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
329         marketPair[address(uniswapV2Pair)] = true;
330         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
331         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
332         swapEnabled = true;
333         tradingOpen = true;
334         firstBlock = block.number;
335     }
336 
337     receive() external payable {}
338 }