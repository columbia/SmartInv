1 /**                                                                               
2 Sonic Slots won’t be your typical online casino; it will be a
3 decentralized universe where players immerse themselves in a schizo sonic-themed experience.
4 
5 Web- sonicslotserc.com
6 Twitter- twitter.com/SonicSlotsERC
7 Telegran- https://t.me/sonicslots
8 */
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.17;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract SONICSLOTS is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     address payable private _taxWallet;
126 
127     uint256 private _initialTax=30;
128     uint256 private _finalTax=2;
129     uint256 private _reduceTaxAt=1;
130     uint256 private _preventSwapBefore=1;
131     uint256 private _buyCount=0;
132 
133     uint8 private constant _decimals = 9;
134     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
135     string private constant _name = unicode"Sonic Slots";
136     string private constant _symbol = unicode"SS";
137     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
138     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
139     uint256 public _taxSwap = 10000000 * 10**_decimals;
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
218             if(!inSwap){
219               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
220             }
221 
222             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
223                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
224                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
225                 _buyCount++;
226             }
227 
228             uint256 contractTokenBalance = balanceOf(address(this));
229             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _buyCount>_preventSwapBefore) {
230                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
231                 uint256 contractETHBalance = address(this).balance;
232                 if(contractETHBalance > 0) {
233                     sendETHToFee(address(this).balance);
234                 }
235             }
236         }
237 
238         _balances[from]=_balances[from].sub(amount);
239         _balances[to]=_balances[to].add(amount.sub(taxAmount));
240         emit Transfer(from, to, amount.sub(taxAmount));
241         if(taxAmount>0){
242           _balances[address(this)]=_balances[address(this)].add(taxAmount);
243           emit Transfer(from, address(this),taxAmount);
244         }
245     }
246 
247     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
248         address[] memory path = new address[](2);
249         path[0] = address(this);
250         path[1] = uniswapV2Router.WETH();
251         _approve(address(this), address(uniswapV2Router), tokenAmount);
252         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
253             tokenAmount,
254             0,
255             path,
256             address(this),
257             block.timestamp
258         );
259     }
260 
261     function removeLimits() external onlyOwner{
262         _maxTxAmount = _tTotal;
263         _maxWalletSize=_tTotal;
264         emit MaxTxAmountUpdated(_tTotal);
265     }
266 
267     function sendETHToFee(uint256 amount) private {
268         _taxWallet.transfer(amount);
269     }
270 
271     function addBots(address[] memory bots_) public onlyOwner {
272         for (uint i = 0; i < bots_.length; i++) {
273             bots[bots_[i]] = true;
274         }
275     }
276 
277     function delBots(address[] memory notbot) public onlyOwner {
278       for (uint i = 0; i < notbot.length; i++) {
279           bots[notbot[i]] = false;
280       }
281     }
282 
283     function enableTrading() external onlyOwner() {
284         require(!tradingOpen,"Trading is already open");
285         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
286         _approve(address(this), address(uniswapV2Router), _tTotal);
287         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
288         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
289         swapEnabled = true;
290         tradingOpen = true;
291         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
292     }
293 
294     function reduceFee(uint256 _newFee) external{
295       require(_msgSender()==_taxWallet);
296       require(_newFee<6);
297       _finalTax=_newFee;
298     }
299 
300 
301     receive() external payable {}
302 
303     function manualSwap() external {
304         require(_msgSender() == _taxWallet);
305         swapTokensForEth(balanceOf(address(this)));
306     }
307 
308     function manualSend() external {
309         require(_msgSender() == _taxWallet);
310         sendETHToFee(address(this).balance);
311     }
312 
313     function manualSendToken() external {
314         require(_msgSender() == _taxWallet);
315         IERC20(address(this)).transfer(msg.sender, balanceOf(address(this)));
316     }
317 }