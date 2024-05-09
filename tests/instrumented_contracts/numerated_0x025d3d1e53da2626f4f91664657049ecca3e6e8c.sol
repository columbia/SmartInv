1 /**
2 
3 https://t.me/Elon_Portal
4 
5 https://btsxnxcsd69.com/
6 
7 https://twitter.com/Btsxnxcsd69
8 
9 **/
10 // SPDX-License-Identifier: MIT
11 
12 
13 pragma solidity 0.8.20;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval (address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61 
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         return c;
66     }
67 
68 }
69 
70 contract Ownable is Context {
71     address private _owner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     modifier onlyOwner() {
85         require(_owner == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94 }
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 }
119 
120 contract BoringTeslaSpaceXNeuralXCorpSpankDoge69 is Context, IERC20, Ownable {
121     using SafeMath for uint256;
122     mapping (address => uint256) private _balances;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private bots;
126     address payable private _taxWallet;
127     uint256 firstBlock;
128 
129     uint256 private _initialBuyTax=18;
130     uint256 private _initialSellTax=20;
131     uint256 private _finalBuyTax=1;
132     uint256 private _finalSellTax=1;
133     uint256 private _reduceBuyTaxAt=16;
134     uint256 private _reduceSellTaxAt=17;
135     uint256 private _preventSwapBefore=30;
136     uint256 private _buyCount=0;
137 
138     uint8 private constant _decimals = 9;
139     uint256 private constant _tTotal = 69420000 * 10**_decimals;
140     string private constant _name = unicode"BoringTeslaSpaceXNeuralXCorpSpankDoge69";
141     string private constant _symbol = unicode"ELON";
142     uint256 public _maxTxAmount = 1388400 * 10**_decimals;
143     uint256 public _maxWalletSize = 1388400 * 10**_decimals;
144     uint256 public _taxSwapThreshold= 694200 * 10**_decimals;
145     uint256 public _maxTaxSwap= 694200 * 10**_decimals;
146 
147     IUniswapV2Router02 private uniswapV2Router;
148     address private uniswapV2Pair;
149     bool private tradingOpen;
150     bool private inSwap = false;
151     bool private swapEnabled = false;
152 
153     event MaxTxAmountUpdated(uint _maxTxAmount);
154     modifier lockTheSwap {
155         inSwap = true;
156         _;
157         inSwap = false;
158     }
159 
160     constructor () {
161 
162         _taxWallet = payable(_msgSender());
163         _balances[_msgSender()] = _tTotal;
164         _isExcludedFromFee[owner()] = true;
165         _isExcludedFromFee[address(this)] = true;
166         _isExcludedFromFee[_taxWallet] = true;
167 
168         emit Transfer(address(0), _msgSender(), _tTotal);
169     }
170 
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint8) {
180         return _decimals;
181     }
182 
183     function totalSupply() public pure override returns (uint256) {
184         return _tTotal;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return _balances[account];
189     }
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210 
211     function _approve(address owner, address spender, uint256 amount) private {
212         require(owner != address(0), "ERC20: approve from the zero address");
213         require(spender != address(0), "ERC20: approve to the zero address");
214         _allowances[owner][spender] = amount;
215         emit Approval(owner, spender, amount);
216     }
217 
218     function _transfer(address from, address to, uint256 amount) private {
219         require(from != address(0), "ERC20: transfer from the zero address");
220         require(to != address(0), "ERC20: transfer to the zero address");
221         require(amount > 0, "Transfer amount must be greater than zero");
222         uint256 taxAmount=0;
223         if (from != owner() && to != owner()) {
224             require(!bots[from] && !bots[to]);
225             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
226 
227             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
228                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
229                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
230 
231                 if (firstBlock + 3  > block.number) {
232                     require(!isContract(to));
233                 }
234                 _buyCount++;
235             }
236 
237             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
238                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
239             }
240 
241             if(to == uniswapV2Pair && from!= address(this) ){
242                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
243             }
244 
245             uint256 contractTokenBalance = balanceOf(address(this));
246             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
247                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
248                 uint256 contractETHBalance = address(this).balance;
249                 if(contractETHBalance > 0) {
250                     sendETHToFee(address(this).balance);
251                 }
252             }
253         }
254 
255         if(taxAmount>0){
256           _balances[address(this)]=_balances[address(this)].add(taxAmount);
257           emit Transfer(from, address(this),taxAmount);
258         }
259         _balances[from]=_balances[from].sub(amount);
260         _balances[to]=_balances[to].add(amount.sub(taxAmount));
261         emit Transfer(from, to, amount.sub(taxAmount));
262     }
263 
264 
265     function min(uint256 a, uint256 b) private pure returns (uint256){
266       return (a>b)?b:a;
267     }
268 
269     function isContract(address account) private view returns (bool) {
270         uint256 size;
271         assembly {
272             size := extcodesize(account)
273         }
274         return size > 0;
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
291     function removeLimits() external onlyOwner{
292         _maxTxAmount = _tTotal;
293         _maxWalletSize=_tTotal;
294         emit MaxTxAmountUpdated(_tTotal);
295     }
296 
297     function sendETHToFee(uint256 amount) private {
298         _taxWallet.transfer(amount);
299     }
300 
301     function addBots(address[] memory bots_) public onlyOwner {
302         for (uint i = 0; i < bots_.length; i++) {
303             bots[bots_[i]] = true;
304         }
305     }
306 
307     function delBots(address[] memory notbot) public onlyOwner {
308       for (uint i = 0; i < notbot.length; i++) {
309           bots[notbot[i]] = false;
310       }
311     }
312 
313     function isBot(address a) public view returns (bool){
314       return bots[a];
315     }
316 
317     function openTrading() external onlyOwner() {
318         require(!tradingOpen,"trading is already open");
319         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
320         _approve(address(this), address(uniswapV2Router), _tTotal);
321         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
322         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
323         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
324         swapEnabled = true;
325         tradingOpen = true;
326         firstBlock = block.number;
327     }
328 
329     receive() external payable {}
330 
331 }