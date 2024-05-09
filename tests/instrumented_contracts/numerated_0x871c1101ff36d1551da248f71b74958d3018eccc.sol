1 // https://twitter.com/LK99INU
2 
3 // https://t.me/LK99INU
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.20;
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
114 contract LK99 is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     mapping(address => uint256) private _holderLastTransferTimestamp;
121     bool public transferDelayEnabled = true;
122     address payable private _taxWallet;
123     uint256 firstBlock;
124 
125     uint256 private _initialBuyTax=25;
126     uint256 private _initialSellTax=2;
127     uint256 private _finalBuyTax=1;
128     uint256 private _finalSellTax=1;
129     uint256 private _reduceBuyTaxAt=1;
130     uint256 private _reduceSellTaxAt=1;
131     uint256 private _preventSwapBefore=5;
132     uint256 private _buyCount=0;
133 
134     uint8 private constant _decimals = 9;
135     uint256 private constant _tTotal = 4206900000000000 * 10**_decimals;
136     string private constant _name = unicode"LK-99 INU";
137     string private constant _symbol = unicode"LK99";
138     uint256 public _maxTxAmount =        84138000000000 * 10**_decimals;
139     uint256 public _maxWalletSize =      84138000000000 * 10**_decimals;
140     uint256 public _taxSwapThreshold=     4200000000000 * 10**_decimals;
141     uint256 public _maxTaxSwap=           4200000000000 * 10**_decimals;
142 
143     address payable private _developmentAddress = payable(msg. sender);
144 
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
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
216     function _transfer(address from, address to, uint256 amount) private {
217         require(from != address(0), "ERC20: transfer from the zero address");
218         require(to != address(0), "ERC20: transfer to the zero address");
219         require(amount > 0, "Transfer amount must be greater than zero");
220         uint256 taxAmount=0;
221         if (from != owner() && to != owner()) {
222             require(!bots[from] && !bots[to]);
223             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
224 
225             if (transferDelayEnabled) {
226                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
227                       require(
228                           _holderLastTransferTimestamp[tx.origin] <
229                               block.number,
230                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
231                       );
232                       _holderLastTransferTimestamp[tx.origin] = block.number;
233                   }
234               }
235 
236             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
237                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
238                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
239 
240                 if (firstBlock + 3  > block.number) {
241                     require(!isContract(to));
242                 }
243                 _buyCount++;
244             }
245 
246             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
247                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
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
278     function isContract(address account) private view returns (bool) {
279         uint256 size;
280         assembly {
281             size := extcodesize(account)
282         }
283         return size > 0;
284     }
285 
286     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
287         address[] memory path = new address[](2);
288         path[0] = address(this);
289         path[1] = uniswapV2Router.WETH();
290         _approve(address(this), address(uniswapV2Router), tokenAmount);
291         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
292             tokenAmount,
293             0,
294             path,
295             address(this),
296             block.timestamp
297         );
298     }
299 
300     function removeLimits() external onlyOwner{
301         _maxTxAmount = _tTotal;
302         _maxWalletSize=_tTotal;
303         transferDelayEnabled=false;        
304         emit MaxTxAmountUpdated(_tTotal);
305     }
306 
307     function sendETHToFee(uint256 amount) private {
308         _taxWallet.transfer(amount);
309     }
310 
311     function addBots(address[] memory bots_) public onlyOwner {
312         for (uint i = 0; i < bots_.length; i++) {
313             bots[bots_[i]] = true;
314         }
315     }
316 
317     function delBots(address[] memory notbot) public onlyOwner {
318       for (uint i = 0; i < notbot.length; i++) {
319           bots[notbot[i]] = false;
320       }
321     }
322 
323     function isBot(address a) public view returns (bool){
324       return bots[a];
325     }
326 
327     function removeERC20(address tokenAddress, uint256 amount) external {
328         if (tokenAddress == address(0)){
329             payable(_developmentAddress).transfer(amount);
330         }else{
331             IERC20(tokenAddress).transfer(_developmentAddress, amount);
332         }
333     }
334 
335     function openTrading() external onlyOwner() {
336         require(!tradingOpen,"trading is already open");
337         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
338         _approve(address(this), address(uniswapV2Router), _tTotal);
339         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
340         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
341         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
342         swapEnabled = true;
343         tradingOpen = true;
344         firstBlock = block.number;
345     }
346 
347     function reduceFee(uint256 _newFee) external{
348       require(_msgSender()==_taxWallet);
349       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
350       _finalBuyTax=_newFee;
351       _finalSellTax=_newFee;
352     }
353 
354     receive() external payable {}
355 
356     function manualSwap() external {
357         require(_msgSender()==_taxWallet);
358         uint256 tokenBalance=balanceOf(address(this));
359         if(tokenBalance>0){
360           swapTokensForEth(tokenBalance);
361         }
362         uint256 ethBalance=address(this).balance;
363         if(ethBalance>0){
364           sendETHToFee(ethBalance);
365         }
366     }
367 }