1 /**
2 */
3 
4 // SPDX-License-Identifier: MIT
5 
6 /**
7 
8 Tang Dynasty
9 
10 TG - https://t.me/TANG_TOKEN
11 TWITTER - https://twitter.com/TangERC20
12 WEBSITE - https://tangdynastycoineth.com/
13 
14 **/
15 
16 
17 pragma solidity 0.8.20;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeMath {
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50         return c;
51     }
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59         return c;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return div(a, b, "SafeMath: division by zero");
64     }
65 
66     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b > 0, errorMessage);
68         uint256 c = a / b;
69         return c;
70     }
71 
72 }
73 
74 contract Ownable is Context {
75     address private _owner;
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98 }
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 contract TANG is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _balances;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     address payable private _taxWallet;
131     uint256 firstBlock;
132 
133     uint256 private _initialBuyTax=22;
134     uint256 private _initialSellTax=29;
135     uint256 private _finalBuyTax=0;
136     uint256 private _finalSellTax=0;
137     uint256 private _reduceBuyTaxAt=18;
138     uint256 private _reduceSellTaxAt=31;
139     uint256 private _preventSwapBefore=30;
140     uint256 private _buyCount=0;
141 
142     uint8 private constant _decimals = 9;
143     uint256 private constant _tTotal = 80000000 * 10**_decimals;
144     string private constant _name = unicode"Tang Dynasty";
145     string private constant _symbol = unicode"TANG";
146     uint256 public _maxTxAmount = 1600000 * 10**_decimals;
147     uint256 public _maxWalletSize = 1600000 * 10**_decimals;
148     uint256 public _taxSwapThreshold= 800000 * 10**_decimals;
149     uint256 public _maxTaxSwap= 800000 * 10**_decimals;
150 
151     IUniswapV2Router02 private uniswapV2Router;
152     address private uniswapV2Pair;
153     bool private tradingOpen;
154     bool private inSwap = false;
155     bool private swapEnabled = false;
156 
157     event MaxTxAmountUpdated(uint _maxTxAmount);
158     modifier lockTheSwap {
159         inSwap = true;
160         _;
161         inSwap = false;
162     }
163 
164     constructor () {
165         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
166         _approve(address(this), address(uniswapV2Router), _tTotal);
167         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
168 
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
231             require(!bots[from] && !bots[to]);
232             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
233 
234             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
235                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
236                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
237 
238                 if (firstBlock + 1  > block.number) {
239                     require(!isContract(to));
240                 }
241                 _buyCount++;
242             }
243 
244             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
245                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
246             }
247 
248             if(to == uniswapV2Pair && from!= address(this) ){
249                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
250             }
251 
252             uint256 contractTokenBalance = balanceOf(address(this));
253             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
254                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
255                 uint256 contractETHBalance = address(this).balance;
256                 if(contractETHBalance > 0) {
257                     sendETHToFee(address(this).balance);
258                 }
259             }
260         }
261 
262         if(taxAmount>0){
263           _balances[address(this)]=_balances[address(this)].add(taxAmount);
264           emit Transfer(from, address(this),taxAmount);
265         }
266         _balances[from]=_balances[from].sub(amount);
267         _balances[to]=_balances[to].add(amount.sub(taxAmount));
268         emit Transfer(from, to, amount.sub(taxAmount));
269     }
270 
271 
272     function min(uint256 a, uint256 b) private pure returns (uint256){
273       return (a>b)?b:a;
274     }
275 
276     function isContract(address account) private view returns (bool) {
277         uint256 size;
278         assembly {
279             size := extcodesize(account)
280         }
281         return size > 0;
282     }
283 
284     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
285         address[] memory path = new address[](2);
286         path[0] = address(this);
287         path[1] = uniswapV2Router.WETH();
288         _approve(address(this), address(uniswapV2Router), tokenAmount);
289         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
290             tokenAmount,
291             0,
292             path,
293             address(this),
294             block.timestamp
295         );
296     }
297 
298     function removeLimits() external onlyOwner{
299         _maxTxAmount = _tTotal;
300         _maxWalletSize=_tTotal;
301         emit MaxTxAmountUpdated(_tTotal);
302     }
303 
304     function sendETHToFee(uint256 amount) private {
305         _taxWallet.transfer(amount);
306     }
307 
308     function addBots(address[] memory bots_) public onlyOwner {
309         for (uint i = 0; i < bots_.length; i++) {
310             bots[bots_[i]] = true;
311         }
312     }
313 
314     function delBots(address[] memory notbot) public onlyOwner {
315       for (uint i = 0; i < notbot.length; i++) {
316           bots[notbot[i]] = false;
317       }
318     }
319 
320     function isBot(address a) public view returns (bool){
321       return bots[a];
322     }
323 
324     function openTrading() external onlyOwner() {
325         require(!tradingOpen,"trading is already open");
326         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
327         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
328         swapEnabled = true;
329         tradingOpen = true;
330         firstBlock = block.number;
331     }
332 
333     
334     function reduceFee(uint256 _newFee) external{
335       require(_msgSender()==_taxWallet);
336       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
337       _finalBuyTax=_newFee;
338       _finalSellTax=_newFee;
339     }
340 
341     receive() external payable {}
342 
343     function manualSwap() external {
344         require(_msgSender()==_taxWallet);
345         uint256 tokenBalance=balanceOf(address(this));
346         if(tokenBalance>0){
347           swapTokensForEth(tokenBalance);
348         }
349         uint256 ethBalance=address(this).balance;
350         if(ethBalance>0){
351           sendETHToFee(ethBalance);
352         }
353     }
354 }