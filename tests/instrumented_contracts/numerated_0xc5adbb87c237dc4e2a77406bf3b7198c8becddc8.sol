1 /**
2 */
3 // SPDX-License-Identifier: MIT
4 /**
5 
6 OTIS  $OTIS
7 
8 "Freedom through crypto is a strong vision championed by Ben Armstrong, 
9 also known as @Bitboy_crypto. We wholeheartedly believe in his ideas and genuine vision. 
10 As a testament to our support, we are creating a community token dedicated to one of his five dogs. 
11 $OTIS represents his beloved bulldog breed and holds a special place as the favorite dog of his son, Blake."
12 
13 https://t.me/OTIS_ERC20
14 https://twitter.com/OTIS_ERC20
15 https://otisarmstrong.life/
16 
17 **/
18 
19 
20 pragma solidity 0.8.17;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 
75 }
76 
77 contract Ownable is Context {
78     address private _owner;
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     constructor () {
82         address msgSender = _msgSender();
83         _owner = msgSender;
84         emit OwnershipTransferred(address(0), msgSender);
85     }
86 
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     modifier onlyOwner() {
92         require(_owner == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     function renounceOwnership() public virtual onlyOwner {
97         emit OwnershipTransferred(_owner, address(0));
98         _owner = address(0);
99     }
100 
101 }
102 
103 interface IUniswapV2Factory {
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IUniswapV2Router02 {
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115     function factory() external pure returns (address);
116     function WETH() external pure returns (address);
117     function addLiquidityETH(
118         address token,
119         uint amountTokenDesired,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
125 }
126 contract OTIS is Context , IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _balances;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     mapping (address => bool) private bots;
132     mapping(address => uint256) private _holderLastTransferTimestamp;
133     bool public transferDelayEnabled = true;
134     address payable private _taxWallet;
135 
136     uint256 private _initialBuyTax=18;
137     uint256 private _initialSellTax=18;
138     uint256 private _finalBuyTax=0;
139     uint256 private _finalSellTax=0;
140     uint256 private _reduceBuyTaxAt=20;
141     uint256 private _reduceSellTaxAt=20;
142     uint256 private _preventSwapBefore=30;
143     uint256 private _buyCount=0;
144 
145     uint8 private constant _decimals = 9;
146     uint256 private constant _tTotal = 1000000000000 * 10**_decimals;
147     string private constant _name = unicode"OTIS";
148     string private constant _symbol = unicode"OTIS";
149     uint256 public _maxTxAmount = 20000000000 * 10**_decimals;
150     uint256 public _maxWalletSize = 20000000000 * 10**_decimals;
151     uint256 public _taxSwapThreshold= 10000000000 * 10**_decimals;
152     uint256 public _maxTaxSwap= 10000000000 * 10**_decimals;
153 
154     IUniswapV2Router02 private uniswapV2Router;
155     address private uniswapV2Pair;
156     bool private tradingOpen;
157     bool private inSwap = false;
158     bool private swapEnabled = false;
159 
160     event MaxTxAmountUpdated(uint _maxTxAmount);
161     modifier lockTheSwap {
162         inSwap = true;
163         _;
164         inSwap = false;
165     }
166 
167     constructor () {
168         _taxWallet = payable(_msgSender());
169         _balances[_msgSender()] = _tTotal;
170         _isExcludedFromFee[owner()] = true;
171         _isExcludedFromFee[address(this)] = true;
172         _isExcludedFromFee[_taxWallet] = true;
173 
174         emit Transfer(address(0), _msgSender(), _tTotal);
175     }
176 
177     function name() public pure returns (string memory) {
178         return _name;
179     }
180 
181     function symbol() public pure returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function totalSupply() public pure override returns (uint256) {
190         return _tTotal;
191     }
192 
193     function balanceOf(address account) public view override returns (uint256) {
194         return _balances[account];
195     }
196 
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
214         return true;
215     }
216 
217     function _approve(address owner, address spender, uint256 amount) private {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function _transfer(address from, address to, uint256 amount) private {
225         require(from != address(0), "ERC20: transfer from the zero address");
226         require(to != address(0), "ERC20: transfer to the zero address");
227         require(amount > 0, "Transfer amount must be greater than zero");
228         uint256 taxAmount=0;
229         if (from != owner() && to != owner()) {
230             require(!bots[from] && !bots[to]);
231             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
232 
233             if (transferDelayEnabled) {
234                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
235                       require(
236                           _holderLastTransferTimestamp[tx.origin] <
237                               block.number,
238                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
239                       );
240                       _holderLastTransferTimestamp[tx.origin] = block.number;
241                   }
242               }
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
258                 if(contractETHBalance > 0) {
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
273 
274     function min(uint256 a, uint256 b) private pure returns (uint256){
275       return (a>b)?b:a;
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
292     function removeLimits() external onlyOwner{
293         _maxTxAmount = _tTotal;
294         _maxWalletSize=_tTotal;
295         transferDelayEnabled=false;
296         emit MaxTxAmountUpdated(_tTotal);
297     }
298 
299     function sendETHToFee(uint256 amount) private {
300         _taxWallet.transfer(amount);
301     }
302 
303     function addBots(address[] memory bots_) public onlyOwner {
304         for (uint i = 0; i < bots_.length; i++) {
305             bots[bots_[i]] = true;
306         }
307     }
308 
309     function delBots(address[] memory notbot) public onlyOwner {
310       for (uint i = 0; i < notbot.length; i++) {
311           bots[notbot[i]] = false;
312       }
313     }
314 
315     function isBot(address a) public view returns (bool){
316       return bots[a];
317     }
318 
319     function openTrading() external onlyOwner() {
320         require(!tradingOpen,"trading is already open");
321         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
322         _approve(address(this), address(uniswapV2Router), _tTotal);
323         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
324         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
325         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
326         swapEnabled = true;
327         tradingOpen = true;
328     }
329 
330     
331     function reduceFee(uint256 _newFee) external{
332       require(_msgSender()==_taxWallet);
333       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
334       _finalBuyTax=_newFee;
335       _finalSellTax=_newFee;
336     }
337 
338     receive() external payable {}
339 
340     function manualSwap() external {
341         require(_msgSender()==_taxWallet);
342         uint256 tokenBalance=balanceOf(address(this));
343         if(tokenBalance>0){
344           swapTokensForEth(tokenBalance);
345         }
346         uint256 ethBalance=address(this).balance;
347         if(ethBalance>0){
348           sendETHToFee(ethBalance);
349         }
350     }
351 }