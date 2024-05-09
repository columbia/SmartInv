1 // Twitter: https://twitter.com/FriendsWB_bot
2 // Telegram: https://t.me/FriendsWB_bot
3 
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity 0.8.17;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor () {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87 }
88 
89 interface IUniswapV2Factory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IUniswapV2Router02 {
94     function swapExactTokensForETHSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103     function addLiquidityETH(
104         address token,
105         uint amountTokenDesired,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
111 }
112 
113 contract FWB is Context, IERC20, Ownable {
114     using SafeMath for uint256;
115     mapping (address => uint256) private _balances;
116     mapping (address => mapping (address => uint256)) private _allowances;
117     mapping (address => bool) private _isExcludedFromFee;
118     mapping (address => bool) private bots;
119     address payable private _taxWallet;
120     address payable private _revshareWallet;
121 
122     uint256 private _initialTax=20;
123     uint256 private _finalTax=5;
124     uint256 private _reduceTaxAt=25;
125     uint256 private _buyCount=0;
126 
127     uint8 private constant _decimals = 9;
128     uint256 private constant _tTotal = 100000 * 10**_decimals;
129     string private constant _name = unicode"Friends With Benefits";
130     string private constant _symbol = unicode"FWB";
131     uint256 public _maxTxAmount = 1000 * 10**_decimals;
132     uint256 public _maxWalletSize = 2000 * 10**_decimals;
133     uint256 public _taxSwap = 1000 * 10**_decimals;
134 
135     IUniswapV2Router02 private uniswapV2Router;
136     address private uniswapV2Pair;
137     bool private inSwap = false;
138 
139     event MaxTxAmountUpdated(uint _maxTxAmount);
140     modifier lockTheSwap {
141         inSwap = true;
142         _;
143         inSwap = false;
144     }
145 
146     constructor () {
147         _taxWallet = payable(_msgSender());
148         _revshareWallet = payable(address(0x2A47f0A05aBD385d8e720981D5aC9B3C3157108e));
149         _balances[_msgSender()] = _tTotal;
150         _isExcludedFromFee[owner()] = true;
151         _isExcludedFromFee[address(this)] = true;
152         _isExcludedFromFee[_taxWallet] = true;
153         _isExcludedFromFee[_revshareWallet] = true;
154         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
155         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
156 
157         emit Transfer(address(0), _msgSender(), _tTotal);
158     }
159 
160     function name() public pure returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() public pure returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() public pure returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() public pure override returns (uint256) {
173         return _tTotal;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return _balances[account];
178     }
179 
180     function transfer(address recipient, uint256 amount) public override returns (bool) {
181         _transfer(_msgSender(), recipient, amount);
182         return true;
183     }
184 
185     function allowance(address owner, address spender) public view override returns (uint256) {
186         return _allowances[owner][spender];
187     }
188 
189     function approve(address spender, uint256 amount) public override returns (bool) {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
195         _transfer(sender, recipient, amount);
196         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
197         return true;
198     }
199 
200     function _approve(address owner, address spender, uint256 amount) private {
201         require(owner != address(0), "ERC20: approve from the zero address");
202         require(spender != address(0), "ERC20: approve to the zero address");
203         _allowances[owner][spender] = amount;
204         emit Approval(owner, spender, amount);
205     }
206 
207     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
208         _isExcludedFromFee[holder] = exempt;
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
229             if (!inSwap && from != uniswapV2Pair && contractTokenBalance>_taxSwap) {
230                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
231                 uint256 contractETHBalance = address(this).balance;
232                 if(contractETHBalance > 0) {
233                     sendETHToRevShare(address(this).balance.div(5));
234                     sendETHToFee(address(this).balance);
235                 }
236             }
237         }
238 
239         if(taxAmount>0){
240             _balances[address(this)]=_balances[address(this)].add(taxAmount);
241             emit Transfer(from, address(this),taxAmount);
242           }
243         _balances[from]=_balances[from].sub(amount);
244         _balances[to]=_balances[to].add(amount.sub(taxAmount));
245         emit Transfer(from, to, amount.sub(taxAmount));
246     }
247 
248     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
249         address[] memory path = new address[](2);
250         path[0] = address(this);
251         path[1] = uniswapV2Router.WETH();
252         _approve(address(this), address(uniswapV2Router), tokenAmount);
253         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
254             tokenAmount,
255             0,
256             path,
257             address(this),
258             block.timestamp
259         );
260     }
261 
262     function removeLimits() external onlyOwner{
263         _maxTxAmount = _tTotal;
264         _maxWalletSize=_tTotal;
265         emit MaxTxAmountUpdated(_tTotal);
266     }
267 
268     function sendETHToFee(uint256 amount) private {
269         _taxWallet.transfer(amount);
270     }
271 
272     function sendETHToRevShare(uint256 amount) private {
273         _revshareWallet.transfer(amount);
274     }
275 
276     function setInitialTax(uint256 initialTax) external onlyOwner {
277         _initialTax = initialTax;
278     }
279 
280     function addBots(address[] memory bots_) public onlyOwner {
281         for (uint i = 0; i < bots_.length; i++) {
282             bots[bots_[i]] = true;
283         }
284     }
285 
286     function delBots(address[] memory notbot) public onlyOwner {
287       for (uint i = 0; i < notbot.length; i++) {
288           bots[notbot[i]] = false;
289       }
290     }
291 
292     function setFee(uint256 _newFee) external{
293       require(_msgSender()==_taxWallet);
294       _finalTax=_newFee;
295     }
296 
297 
298     receive() external payable {}
299 
300     function manualSwap() external {
301         require(_msgSender() == _taxWallet);
302         swapTokensForEth(balanceOf(address(this)));
303     }
304 
305     function manualSend() external {
306         require(_msgSender() == _taxWallet);
307         sendETHToFee(address(this).balance);
308     }
309 
310     function manualSendToken() external {
311         require(_msgSender() == _taxWallet);
312         IERC20(address(this)).transfer(msg.sender, balanceOf(address(this)));
313     }
314 }