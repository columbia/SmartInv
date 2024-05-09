1 // SPDX-License-Identifier: MIT
2 
3 /*
4 https://medium.com/@qilin30122022/chapter-1-f38038f73654
5 
6 */
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
114 contract QILIN is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     mapping(address => uint256) private _holderLastTransferTimestamp;
121     bool public transferDelayEnabled = true;
122     address payable private _taxWallet;
123 
124     uint256 private _initialBuyTax=10;
125     uint256 private _initialSellTax=20;
126     uint256 private _finalTax=3;
127     uint256 private _reduceBuyTaxAt=30;
128     uint256 private _reduceSellTaxAt=50;
129     uint256 private _preventSwapBefore=10;
130     uint256 private _buyCount=0;
131 
132     uint8 private constant _decimals = 8;
133     uint256 private constant _tTotal = 1000000 * 10**_decimals;
134     string private constant _name = unicode"SON OF THE DRAGON";
135     string private constant _symbol = unicode"QILIN";
136     uint256 public _maxTxAmount =   20000 * 10**_decimals;
137     uint256 public _maxWalletSize = 30000 * 10**_decimals;
138     uint256 public _taxSwapThreshold=5000 * 10**_decimals;
139     uint256 public _maxTaxSwap=20000 * 10**_decimals;
140 
141     IUniswapV2Router02 private uniswapV2Router;
142     address private uniswapV2Pair;
143     bool private tradingOpen;
144     bool private inSwap = false;
145     bool private swapEnabled = false;
146 
147     event MaxTxAmountUpdated(uint _maxTxAmount);
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153 
154     constructor () {
155         _taxWallet = payable(_msgSender());
156         _balances[_msgSender()] = _tTotal;
157         _isExcludedFromFee[owner()] = true;
158         _isExcludedFromFee[address(this)] = true;
159         _isExcludedFromFee[_taxWallet] = true;
160 
161         emit Transfer(address(0), _msgSender(), _tTotal);
162     }
163 
164     function name() public pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() public pure override returns (uint256) {
177         return _tTotal;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return _balances[account];
182     }
183 
184     function transfer(address recipient, uint256 amount) public override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function _approve(address owner, address spender, uint256 amount) private {
205         require(owner != address(0), "ERC20: approve from the zero address");
206         require(spender != address(0), "ERC20: approve to the zero address");
207         _allowances[owner][spender] = amount;
208         emit Approval(owner, spender, amount);
209     }
210 
211     function _transfer(address from, address to, uint256 amount) private {
212         require(from != address(0), "ERC20: transfer from the zero address");
213         require(to != address(0), "ERC20: transfer to the zero address");
214         require(amount > 0, "Transfer amount must be greater than zero");
215         uint256 taxAmount=0;
216         if (from != owner() && to != owner()) {
217             require(!bots[from] && !bots[to]);
218             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalTax:_initialBuyTax).div(100);
219 
220             if (transferDelayEnabled) {
221                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
222                       require(
223                           _holderLastTransferTimestamp[tx.origin] <
224                               block.number,
225                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
226                       );
227                       _holderLastTransferTimestamp[tx.origin] = block.number;
228                   }
229               }
230 
231             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
232                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
233                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
234                 _buyCount++;
235             }
236 
237             if(to == uniswapV2Pair && from!= address(this) ){
238                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalTax:_initialSellTax).div(100);
239             }
240 
241             uint256 contractTokenBalance = balanceOf(address(this));
242             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
243                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
244                 uint256 contractETHBalance = address(this).balance;
245                 if(contractETHBalance > 0) {
246                     sendETHToFee(address(this).balance);
247                 }
248             }
249         }
250 
251         _balances[from]=_balances[from].sub(amount);
252         _balances[to]=_balances[to].add(amount.sub(taxAmount));
253         emit Transfer(from, to, amount.sub(taxAmount));
254         if(taxAmount>0){
255           _balances[address(this)]=_balances[address(this)].add(taxAmount);
256           emit Transfer(from, address(this),taxAmount);
257         }
258     }
259 
260 
261     function min(uint256 a, uint256 b) private pure returns (uint256){
262       return (a>b)?b:a;
263     }
264 
265     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
266         address[] memory path = new address[](2);
267         path[0] = address(this);
268         path[1] = uniswapV2Router.WETH();
269         _approve(address(this), address(uniswapV2Router), tokenAmount);
270         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
271             tokenAmount,
272             0,
273             path,
274             address(this),
275             block.timestamp
276         );
277     }
278 
279     function removeLimits() external onlyOwner{
280         _maxTxAmount = _tTotal;
281         _maxWalletSize=_tTotal;
282         transferDelayEnabled=false;
283         emit MaxTxAmountUpdated(_tTotal);
284     }
285 
286     function sendETHToFee(uint256 amount) private {
287         _taxWallet.transfer(amount);
288     }
289 
290     function addBots(address[] memory bots_) public onlyOwner {
291         for (uint i = 0; i < bots_.length; i++) {
292             bots[bots_[i]] = true;
293         }
294     }
295 
296     function delBots(address[] memory notbot) public onlyOwner {
297       for (uint i = 0; i < notbot.length; i++) {
298           bots[notbot[i]] = false;
299       }
300     }
301 
302     function isBot(address a) public view returns (bool){
303       return bots[a];
304     }
305 
306     function openTrading() external onlyOwner() {
307         require(!tradingOpen,"trading is already open");
308         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
309         _approve(address(this), address(uniswapV2Router), _tTotal);
310         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
311         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
312         swapEnabled = true;
313         tradingOpen = true;
314         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
315     }
316 
317     
318     function reduceFee(uint256 _newFee) external{
319       require(_buyCount>400);
320       require(_newFee<=_finalTax);
321       _finalTax=_newFee;
322     }
323 
324     receive() external payable {}
325 
326     function manualSwap() external {
327         uint256 tokenBalance=balanceOf(address(this));
328         if(tokenBalance>0){
329           swapTokensForEth(tokenBalance);
330         }
331         uint256 ethBalance=address(this).balance;
332         if(ethBalance>0){
333           sendETHToFee(ethBalance);
334         }
335     }
336 }