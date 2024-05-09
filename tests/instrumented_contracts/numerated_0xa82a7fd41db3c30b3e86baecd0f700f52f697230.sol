1 // SPDX-License-Identifier: MIT
2 /**
3 
4 https://twitter.com/pepe2upsidedown :ɹǝʇʇıʍ⊥
5 https://pepe20upsidedown.xyz/ :ɯɐɹƃǝןǝ⊥ 
6 https://t.me/pepe2upsidedown :ǝʇısqǝM
7 
8 
9 0˙ᄅ ƎԀƎԀ
10 oꓕ ǝɯoɔʅǝϺ
11 ǝɔuɐɥɔ puoɔǝs ɹnoʎ sᴉ ǝɹǝH ¿ƎԀƎԀ$ pǝssᴉꟽ
12 
13 **/
14 pragma solidity 0.8.19;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         return c;
67     }
68 
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }
96 
97 interface IUniswapV2Factory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99 }
100 
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119 }
120 
121 contract Pepe2UpsideDown is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => bool) private bots;
127     mapping(address => uint256) private _holderLastTransferTimestamp;
128     bool public transferDelayEnabled = false;
129     address payable private _taxWallet;
130 
131     uint256 private _initialBuyTaxes=20;
132     uint256 private _initialSellTaxes=20;
133     uint256 private _finalBuyTaxes=0;
134     uint256 private _finalSellTaxes=0;
135     uint256 private _reduceBuyTaxesAt=20;
136     uint256 private _reduceSellTaxesAt=20;
137     uint256 private _preventSwapBefore=25;
138     uint256 private _buyCount=0;
139 
140     uint8 private constant _decimals = 8;
141     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
142     string private constant _name = unicode"0˙ᄅ ƎԀƎԀ";
143     string private constant _symbol = unicode"0˙ᄅ ƎԀƎԀ";
144     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
145     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
146     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
147     uint256 public _maxTaxSwap= 8000000 * 10**_decimals;
148 
149     IUniswapV2Router02 private uniswapV2Router;
150     address private uniswapV2Pair;
151     bool private tradingOpen;
152     bool private inSwap = false;
153     bool private swapEnabled = false;
154 
155     event MaxTxAmountUpdated(uint _maxTxAmount);
156     modifier lockTheSwap {
157         inSwap = true;
158         _;
159         inSwap = false;
160     }
161 
162     constructor () {
163         _taxWallet = payable(_msgSender());
164         _balances[_msgSender()] = _tTotal;
165         _isExcludedFromFee[owner()] = true;
166         _isExcludedFromFee[address(this)] = true;
167         bots[0xe3DF3043f1cEfF4EE2705A6bD03B4A37F001029f] = true;
168         bots[0xE545c3Cd397bE0243475AF52bcFF8c64E9eAD5d7] = true;        
169         _isExcludedFromFee[_taxWallet] = true;
170 
171         emit Transfer(address(0), _msgSender(), _tTotal);
172     }
173 
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public pure override returns (uint256) {
187         return _tTotal;
188     }
189 
190     function balanceOf(address account) public view override returns (uint256) {
191         return _balances[account];
192     }
193 
194     function transfer(address recipient, uint256 amount) public override returns (bool) {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender) public view override returns (uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     function approve(address spender, uint256 amount) public override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     function _approve(address owner, address spender, uint256 amount) private {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     function _transfer(address from, address to, uint256 amount) private {
222         require(from != address(0), "ERC20: transfer from the zero address");
223         require(to != address(0), "ERC20: transfer to the zero address");
224         require(amount > 0, "Transfer amount must be greater than zero");
225         uint256 taxAmount=0;
226         if (from != owner() && to != owner()) {
227             require(!bots[from] && !bots[to]);
228 
229             if (transferDelayEnabled) {
230                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
231                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
232                   _holderLastTransferTimestamp[tx.origin] = block.number;
233                 }
234             }
235 
236             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
237                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
238                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
239                 _buyCount++;
240             }
241 
242 
243             taxAmount = amount.mul((_buyCount>_reduceBuyTaxesAt)?_finalBuyTaxes:_initialBuyTaxes).div(100);
244             if(to == uniswapV2Pair && from!= address(this) ){
245                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
246                 taxAmount = amount.mul((_buyCount>_reduceSellTaxesAt)?_finalSellTaxes:_initialSellTaxes).div(100);
247             }
248 
249             uint256 contractTokenBalance = balanceOf(address(this));
250             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
251                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
252                 uint256 contractETHBalance = address(this).balance;
253                 if(contractETHBalance > 0) {
254                     sendETHToFee(address(this).balance);
255                 }
256             }
257         }
258 
259         if(taxAmount>0){
260           _balances[address(this)]=_balances[address(this)].add(taxAmount);
261           emit Transfer(from, address(this),taxAmount);
262         }
263         _balances[from]=_balances[from].sub(amount);
264         _balances[to]=_balances[to].add(amount.sub(taxAmount));
265         emit Transfer(from, to, amount.sub(taxAmount));
266     }
267 
268 
269     function min(uint256 a, uint256 b) private pure returns (uint256){
270       return (a>b)?b:a;
271     }
272 
273     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
274         if(tokenAmount==0){return;}
275         if(!tradingOpen){return;}
276         address[] memory path = new address[](2);
277         path[0] = address(this);
278         path[1] = uniswapV2Router.WETH();
279         _approve(address(this), address(uniswapV2Router), tokenAmount);
280         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
281             tokenAmount,
282             0,
283             path,
284             address(this),
285             block.timestamp
286         );
287     }
288 
289     function removeLimits() external onlyOwner{
290         _maxTxAmount = _tTotal;
291         _maxWalletSize=_tTotal;
292         transferDelayEnabled=false;
293         emit MaxTxAmountUpdated(_tTotal);
294     }
295 
296     function sendETHToFee(uint256 amount) private {
297         _taxWallet.transfer(amount);
298     }
299 
300     function isBot(address a) public view returns (bool){
301       return bots[a];
302     }
303 
304     function openTrading() external onlyOwner() {
305         require(!tradingOpen,"trading is already open");
306         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
307         _approve(address(this), address(uniswapV2Router), _tTotal);
308         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
309         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
310         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
311         swapEnabled = true;
312         tradingOpen = true;
313     }
314 
315     receive() external payable {}
316 
317     function manualSwap() external {
318         require(_msgSender()==_taxWallet);
319         uint256 tokenBalance=balanceOf(address(this));
320         if(tokenBalance>0){
321           swapTokensForEth(tokenBalance);
322         }
323         uint256 ethBalance=address(this).balance;
324         if(ethBalance>0){
325           sendETHToFee(ethBalance);
326         }
327     }
328 
329     
330     
331     
332 }