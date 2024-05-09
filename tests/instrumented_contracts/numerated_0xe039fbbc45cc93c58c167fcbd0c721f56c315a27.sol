1 // Twitter: https://twitter.com/Tele_Bridge
2 // Telegram: https://t.me/TeleBridge_Chat
3 // Telebridge bot: https://t.me/Telebridge_tg_bot
4 
5 // SPDX-License-Identifier: MIT
6 
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
114 contract Telebridge is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     address payable private _taxWallet;
121     address payable private _revshareWallet;
122 
123     uint256 private _initialTax=20;
124     uint256 private _finalTax=5;
125     uint256 private _reduceTaxAt=25;
126     uint256 private _buyCount=0;
127 
128     uint8 private constant _decimals = 9;
129     uint256 private constant _tTotal = 10000 * 10**_decimals;
130     string private constant _name = unicode"Telebridge";
131     string private constant _symbol = unicode"Bridge";
132     uint256 public _maxTxAmount = 100 * 10**_decimals;
133     uint256 public _maxWalletSize = 200 * 10**_decimals;
134     uint256 public _taxSwap = 100 * 10**_decimals;
135 
136     IUniswapV2Router02 private uniswapV2Router;
137     address private uniswapV2Pair;
138     bool private inSwap = false;
139 
140     event MaxTxAmountUpdated(uint _maxTxAmount);
141     modifier lockTheSwap {
142         inSwap = true;
143         _;
144         inSwap = false;
145     }
146 
147     constructor () {
148         _taxWallet = payable(_msgSender());
149         _revshareWallet = payable(address(0xd9940D138aB18C3C28812cbA5E1c7488A179255C));
150         _balances[_msgSender()] = _tTotal;
151         _isExcludedFromFee[owner()] = true;
152         _isExcludedFromFee[address(this)] = true;
153         _isExcludedFromFee[_taxWallet] = true;
154         _isExcludedFromFee[_revshareWallet] = true;
155         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
156         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
157 
158         emit Transfer(address(0), _msgSender(), _tTotal);
159     }
160 
161     function name() public pure returns (string memory) {
162         return _name;
163     }
164 
165     function symbol() public pure returns (string memory) {
166         return _symbol;
167     }
168 
169     function decimals() public pure returns (uint8) {
170         return _decimals;
171     }
172 
173     function totalSupply() public pure override returns (uint256) {
174         return _tTotal;
175     }
176 
177     function balanceOf(address account) public view override returns (uint256) {
178         return _balances[account];
179     }
180 
181     function transfer(address recipient, uint256 amount) public override returns (bool) {
182         _transfer(_msgSender(), recipient, amount);
183         return true;
184     }
185 
186     function allowance(address owner, address spender) public view override returns (uint256) {
187         return _allowances[owner][spender];
188     }
189 
190     function approve(address spender, uint256 amount) public override returns (bool) {
191         _approve(_msgSender(), spender, amount);
192         return true;
193     }
194 
195     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
196         _transfer(sender, recipient, amount);
197         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
198         return true;
199     }
200 
201     function _approve(address owner, address spender, uint256 amount) private {
202         require(owner != address(0), "ERC20: approve from the zero address");
203         require(spender != address(0), "ERC20: approve to the zero address");
204         _allowances[owner][spender] = amount;
205         emit Approval(owner, spender, amount);
206     }
207 
208     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
209         _isExcludedFromFee[holder] = exempt;
210     }
211 
212     function _transfer(address from, address to, uint256 amount) private {
213         require(from != address(0), "ERC20: transfer from the zero address");
214         require(to != address(0), "ERC20: transfer to the zero address");
215         require(amount > 0, "Transfer amount must be greater than zero");
216         uint256 taxAmount=0;
217         if (from != owner() && to != owner()) {
218             require(!bots[from] && !bots[to]);
219             if(!inSwap){
220               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
221             }
222 
223             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
224                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
225                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
226                 _buyCount++;
227             }
228 
229             uint256 contractTokenBalance = balanceOf(address(this));
230             if (!inSwap && from != uniswapV2Pair && contractTokenBalance>_taxSwap) {
231                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
232                 uint256 contractETHBalance = address(this).balance;
233                 if(contractETHBalance > 0) {
234                     sendETHToRevShare(address(this).balance.div(5));
235                     sendETHToFee(address(this).balance);
236                 }
237             }
238         }
239 
240         if(taxAmount>0){
241             _balances[address(this)]=_balances[address(this)].add(taxAmount);
242             emit Transfer(from, address(this),taxAmount);
243           }
244         _balances[from]=_balances[from].sub(amount);
245         _balances[to]=_balances[to].add(amount.sub(taxAmount));
246         emit Transfer(from, to, amount.sub(taxAmount));
247     }
248 
249     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
250         address[] memory path = new address[](2);
251         path[0] = address(this);
252         path[1] = uniswapV2Router.WETH();
253         _approve(address(this), address(uniswapV2Router), tokenAmount);
254         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
255             tokenAmount,
256             0,
257             path,
258             address(this),
259             block.timestamp
260         );
261     }
262 
263     function removeLimits() external onlyOwner{
264         _maxTxAmount = _tTotal;
265         _maxWalletSize=_tTotal;
266         emit MaxTxAmountUpdated(_tTotal);
267     }
268 
269     function sendETHToFee(uint256 amount) private {
270         _taxWallet.transfer(amount);
271     }
272 
273     function sendETHToRevShare(uint256 amount) private {
274         _revshareWallet.transfer(amount);
275     }
276 
277     function setInitialTax(uint256 initialTax) external onlyOwner {
278         _initialTax = initialTax;
279     }
280 
281     function addBots(address[] memory bots_) public onlyOwner {
282         for (uint i = 0; i < bots_.length; i++) {
283             bots[bots_[i]] = true;
284         }
285     }
286 
287     function delBots(address[] memory notbot) public onlyOwner {
288       for (uint i = 0; i < notbot.length; i++) {
289           bots[notbot[i]] = false;
290       }
291     }
292 
293     function reduceFee(uint256 _newFee) external{
294       require(_msgSender()==_taxWallet);
295       require(_newFee<6);
296       _finalTax=_newFee;
297     }
298 
299 
300     receive() external payable {}
301 
302     function manualSwap() external {
303         require(_msgSender() == _taxWallet);
304         swapTokensForEth(balanceOf(address(this)));
305     }
306 
307     function manualSend() external {
308         require(_msgSender() == _taxWallet);
309         sendETHToFee(address(this).balance);
310     }
311 
312     function manualSendToken() external {
313         require(_msgSender() == _taxWallet);
314         IERC20(address(this)).transfer(msg.sender, balanceOf(address(this)));
315     }
316 }