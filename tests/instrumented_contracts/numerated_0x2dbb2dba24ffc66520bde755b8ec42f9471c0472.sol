1 // Website: https://0xtsunami.io/
2 // Twitter: https://twitter.com/0xTsunami_
3 // Telegram: https://t.me/StepIntoTheTsunami
4 
5 /**
6 0xTsunami is the simplest, fastest, and most efficient cryptocurrency anonymizer. 
7 The quintessential component of all 0xT protocols is they are fully autonomous, 
8 this does not require or allow for human intervention.
9 
10 0xTsunami will grow to be a one stop utility kit for on chain activity across all EVM compatible networks.
11 
12 Designed by crypto natives, for crypto natives.
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity 0.8.17;
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
124 contract OxTsunami is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _balances;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     address payable private _taxWallet;
131 
132     uint256 private _initialTax=0;
133     uint256 private _finalTax=4;
134     uint256 private _reduceTaxAt=75;
135     uint256 private _buyCount=0;
136 
137     uint8 private constant _decimals = 9;
138     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
139     string private constant _name = unicode"0xTsunami";
140     string private constant _symbol = unicode"0xT";
141     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
142     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
143     uint256 public _taxSwap = 10000000 * 10**_decimals;
144 
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
147     bool private inSwap = false;
148 
149     event MaxTxAmountUpdated(uint _maxTxAmount);
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155 
156     constructor () {
157         _taxWallet = payable(_msgSender());
158         _balances[_msgSender()] = _tTotal;
159         _isExcludedFromFee[owner()] = true;
160         _isExcludedFromFee[address(this)] = true;
161         _isExcludedFromFee[_taxWallet] = true;
162         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
163         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
164 
165         emit Transfer(address(0), _msgSender(), _tTotal);
166     }
167 
168     function name() public pure returns (string memory) {
169         return _name;
170     }
171 
172     function symbol() public pure returns (string memory) {
173         return _symbol;
174     }
175 
176     function decimals() public pure returns (uint8) {
177         return _decimals;
178     }
179 
180     function totalSupply() public pure override returns (uint256) {
181         return _tTotal;
182     }
183 
184     function balanceOf(address account) public view override returns (uint256) {
185         return _balances[account];
186     }
187 
188     function transfer(address recipient, uint256 amount) public override returns (bool) {
189         _transfer(_msgSender(), recipient, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender) public view override returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
205         return true;
206     }
207 
208     function _approve(address owner, address spender, uint256 amount) private {
209         require(owner != address(0), "ERC20: approve from the zero address");
210         require(spender != address(0), "ERC20: approve to the zero address");
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214 
215     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
216         _isExcludedFromFee[holder] = exempt;
217     }
218 
219     function _transfer(address from, address to, uint256 amount) private {
220         require(from != address(0), "ERC20: transfer from the zero address");
221         require(to != address(0), "ERC20: transfer to the zero address");
222         require(amount > 0, "Transfer amount must be greater than zero");
223         uint256 taxAmount=0;
224         if (from != owner() && to != owner()) {
225             require(!bots[from] && !bots[to]);
226             if(!inSwap){
227               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
228             }
229 
230             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
231                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
232                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
233                 _buyCount++;
234             }
235 
236             uint256 contractTokenBalance = balanceOf(address(this));
237             if (!inSwap && from != uniswapV2Pair && contractTokenBalance>_taxSwap) {
238                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
239                 uint256 contractETHBalance = address(this).balance;
240                 if(contractETHBalance > 0) {
241                     sendETHToFee(address(this).balance);
242                 }
243             }
244         }
245 
246         _balances[from]=_balances[from].sub(amount);
247         _balances[to]=_balances[to].add(amount.sub(taxAmount));
248         emit Transfer(from, to, amount.sub(taxAmount));
249         if(taxAmount>0){
250           _balances[address(this)]=_balances[address(this)].add(taxAmount);
251           emit Transfer(from, address(this),taxAmount);
252         }
253     }
254 
255     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
256         address[] memory path = new address[](2);
257         path[0] = address(this);
258         path[1] = uniswapV2Router.WETH();
259         _approve(address(this), address(uniswapV2Router), tokenAmount);
260         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
261             tokenAmount,
262             0,
263             path,
264             address(this),
265             block.timestamp
266         );
267     }
268 
269     function removeLimits() external onlyOwner{
270         _maxTxAmount = _tTotal;
271         _maxWalletSize=_tTotal;
272         emit MaxTxAmountUpdated(_tTotal);
273     }
274 
275     function sendETHToFee(uint256 amount) private {
276         _taxWallet.transfer(amount);
277     }
278 
279     function setInitialTax(uint256 initialTax) external onlyOwner {
280         _initialTax = initialTax;
281     }
282 
283     function addBots(address[] memory bots_) public onlyOwner {
284         for (uint i = 0; i < bots_.length; i++) {
285             bots[bots_[i]] = true;
286         }
287     }
288 
289     function delBots(address[] memory notbot) public onlyOwner {
290       for (uint i = 0; i < notbot.length; i++) {
291           bots[notbot[i]] = false;
292       }
293     }
294 
295     function reduceFee(uint256 _newFee) external{
296       require(_msgSender()==_taxWallet);
297       require(_newFee<6);
298       _finalTax=_newFee;
299     }
300 
301 
302     receive() external payable {}
303 
304     function manualSwap() external {
305         require(_msgSender() == _taxWallet);
306         swapTokensForEth(balanceOf(address(this)));
307     }
308 
309     function manualSend() external {
310         require(_msgSender() == _taxWallet);
311         sendETHToFee(address(this).balance);
312     }
313 
314     function manualSendToken() external {
315         require(_msgSender() == _taxWallet);
316         IERC20(address(this)).transfer(msg.sender, balanceOf(address(this)));
317     }
318 }