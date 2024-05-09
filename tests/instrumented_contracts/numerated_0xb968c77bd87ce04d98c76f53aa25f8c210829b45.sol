1 /**
2     $TECH
3 
4     Website: https://friendtech.vip/
5     Twitter: https://twitter.com/techerc20
6     Gitbook: https://tech-33.gitbook.io/tech-whitepaper/
7 
8     We aim to create a tech meme, driven and co-created by the community. 
9     This includes the image and persona of $TECH. Everything about $TECH will be crafted by the community.
10     After the token launch, we will gather ideas and opinions from the community on Twitter, 
11     forming our unique image. $TECH will emerge as the first tech meme in the world.
12 **/
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity ^0.8.15;
17 
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
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83     function owner() public view returns (address) {
84         return _owner;
85     }
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }
96 
97 interface IUniFactory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99     function getPair(address tokenA, address tokenB) external returns (address pair);
100 }
101 
102 interface IUniRouter {
103     function factoryV2() external pure returns (address);
104     function factory() external pure returns (address);
105     function WETH() external pure returns (address);
106 
107     function swapExactETHForTokensSupportingFeeOnTransferTokens(
108         uint256 amountOutMin,
109         address[] calldata path,
110         address to,
111         uint256 deadline
112     ) external payable;
113     function swapExactTokensForETHSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120     function addLiquidityETH(
121         address token,
122         uint amountTokenDesired,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
128 }
129 
130 contract TECH is Context, IERC20, Ownable {
131 
132     using SafeMath for uint256;
133 
134     mapping (address => uint256) private _balances;
135     mapping (address => mapping (address => uint256)) private _allowances;
136     mapping (address => bool) private _isExcludedFromFee;
137     mapping (address => bool) private _bots;
138     mapping(address => uint256) private _holderLastTransferTimestamp;
139 
140     IUniRouter private _uniRouter;
141     address private _uniPair;
142     address payable private _taxWallet;
143 
144     bool public transferDelayEnabled = true;
145 
146     uint256 public finalBuyTax = 1;
147     uint256 public finalSellTax = 1;
148     uint256 private _initialBuyTax = 20;
149     uint256 private _initialSellTax = 30;
150     uint256 private _reduceBuyTaxAt = 50;
151     uint256 private _reduceSellTaxAt = 50;
152     uint256 private _preventSwapBefore = 30;
153     uint256 private _buyCount = 0;
154 
155     string private constant _name = "TECH";
156     string private constant _symbol = "TECH";
157     uint8 private constant _decimals = 18;
158     uint256 private constant _tTotal = 420_690_000_000_000 * 10 ** _decimals;
159 
160     bool private _tradingOpen;
161     uint256 public maxWalletSize = _tTotal * 3 / 100;
162     uint256 public maxTxAmount = _tTotal * 2 / 100;
163     uint256 private _taxSwapThreshold = _tTotal * 6 / 1000;
164     uint256 private _maxTaxSwap = _tTotal * 6 / 1000;
165     bool private _inSwap = false;
166     bool private _swapEnabled = false;
167     modifier lockTheSwap {
168         _inSwap = true;
169         _;
170         _inSwap = false;
171     }
172 
173     constructor () {
174         _taxWallet = payable(0x27977CC14E55625c993bc3D0c10C285F9607A1B8);
175         _balances[address(this)] = _tTotal;
176         _isExcludedFromFee[_taxWallet] = true;
177         _isExcludedFromFee[owner()] = true;
178         _isExcludedFromFee[address(this)] = true;
179         _uniRouter = IUniRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
180         _approve(address(this), address(_uniRouter), type(uint256).max);
181         _approve(address(this), address(this), type(uint256).max);
182         _uniPair = IUniFactory(_uniRouter.factory()).createPair(address(this), _uniRouter.WETH());
183         emit Transfer(address(0), address(this), _tTotal);
184     }
185 
186     function name() public pure returns (string memory) {
187         return _name;
188     }
189 
190     function symbol() public pure returns (string memory) {
191         return _symbol;
192     }
193 
194     function decimals() public pure returns (uint8) {
195         return _decimals;
196     }
197 
198     function totalSupply() public pure override returns (uint256) {
199         return _tTotal;
200     }
201 
202     function balanceOf(address account) public view override returns (uint256) {
203         return _balances[account];
204     }
205 
206     function transfer(address recipient, uint256 amount) public override returns (bool) {
207         _transfer(_msgSender(), recipient, amount);
208         return true;
209     }
210 
211     function allowance(address owner, address spender) public view override returns (uint256) {
212         return _allowances[owner][spender];
213     }
214 
215     function approve(address spender, uint256 amount) public override returns (bool) {
216         _approve(_msgSender(), spender, amount);
217         return true;
218     }
219 
220     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
221         _transfer(sender, recipient, amount);
222         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
223         return true;
224     }
225 
226     function _approve(address owner, address spender, uint256 amount) private {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 
233     function _transfer(address from, address to, uint256 amount) private {
234         require(from != address(0), "ERC20: transfer from the zero address");
235         require(to != address(0), "ERC20: transfer to the zero address");
236         require(amount > 0, "Transfer amount must be greater than zero");
237 
238         uint256 taxAmount = 0;
239 
240         if (from != owner() && to != owner()) {
241             require(!_bots[from] && !_bots[to]);
242 
243             if (transferDelayEnabled) {
244                 if (to != address(_uniRouter) && to != address(_uniPair)) {
245                   require(_holderLastTransferTimestamp[tx.origin] < block.number, "Only one transfer per block allowed.");
246                   _holderLastTransferTimestamp[tx.origin] = block.number;
247                 }
248             }
249 
250             // buy with limit
251             if (from == _uniPair && to != address(_uniRouter) && !_isExcludedFromFee[to] ) {
252                 require(_tradingOpen, "not open pls wait");
253                 require(amount <= maxTxAmount, "Exceeds the maxTxAmount.");
254                 require(balanceOf(to) + amount <= maxWalletSize, "Exceeds the maxWalletSize.");
255                 _buyCount++;
256             }
257 
258             // buy
259             if (from == _uniPair && !_isExcludedFromFee[to] ) {
260                 taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? finalBuyTax : _initialBuyTax).div(100);
261             }
262             else if (to == _uniPair && !_isExcludedFromFee[from] ) { // sell
263                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt) ? finalSellTax : _initialSellTax).div(100);
264             }
265             
266             uint256 contractTokenBalance = balanceOf(address(this));
267             if (!_inSwap && to == _uniPair && _swapEnabled && contractTokenBalance > _taxSwapThreshold && _buyCount > _preventSwapBefore) {
268                 _swapTokensForEth(_min(amount, _min(contractTokenBalance, _maxTaxSwap)));
269                 uint256 contractETHBalance = address(this).balance;
270                 if (contractETHBalance > 0) {
271                     _sendETHToFee(address(this).balance);
272                 }
273             }
274         }
275 
276         if (taxAmount > 0) {
277           _balances[address(this)] = _balances[address(this)].add(taxAmount);
278           emit Transfer(from, address(this), taxAmount);
279         }
280 
281         _balances[from] = _balances[from].sub(amount);
282         _balances[to] = _balances[to].add(amount.sub(taxAmount));
283         emit Transfer(from, to, amount.sub(taxAmount));
284     }
285 
286     function _min(uint256 a, uint256 b) private pure returns (uint256){
287         return (a>b)?b:a;
288     }
289 
290     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
291         if (tokenAmount == 0) {return;}
292         if (!_tradingOpen) {return;}
293         address[] memory path = new address[](2);
294         path[0] = address(this);
295         path[1] = _uniRouter.WETH();
296         _approve(address(this), address(_uniRouter), tokenAmount);
297         _uniRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
298             tokenAmount,
299             0,
300             path,
301             address(this),
302             block.timestamp
303         );
304     }
305 
306     function _sendETHToFee(uint256 amount) private {
307         _taxWallet.transfer(amount);
308     }
309 
310     function removeLimits() public onlyOwner{
311         maxTxAmount = _tTotal;
312         maxWalletSize = _tTotal;
313         transferDelayEnabled = false;
314         _reduceSellTaxAt = 20;
315         _reduceBuyTaxAt = 20;
316     }
317 
318     function isBot(address a) public view returns (bool){
319       return _bots[a];
320     }
321 
322     function setBots(address[] memory bots_, bool enable_) public onlyOwner {
323         for (uint i = 0; i < bots_.length; i++) {
324             _bots[bots_[i]] = enable_;
325         }
326     }
327 
328     function goTech() external onlyOwner() {
329         require(!_tradingOpen, "Already open");
330         _uniRouter.addLiquidityETH{value: 1 ether}(address(this), balanceOf(address(this)), 0, 0, _msgSender(), block.timestamp);
331         _swapEnabled = true;
332         _tradingOpen = true;
333     }
334 
335     receive() external payable {}
336 
337     function manualSwap() external {
338         require(_msgSender() == _taxWallet);
339         uint256 tokenBalance = balanceOf(address(this));
340         if (tokenBalance > 0){
341             _swapTokensForEth(tokenBalance);
342         }
343         uint256 ethBalance = address(this).balance;
344         if (ethBalance > 0){
345             _sendETHToFee(ethBalance);
346         }
347     }
348 }