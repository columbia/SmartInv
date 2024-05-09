1 /**
2  
3 */
4 
5 //          https://twitter.com/flatericeth
6 //          Website: https://flateric.io
7 
8 /**
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 
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
121 contract Eric is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => bool) private bots;
127     address payable private _taxWallet;
128 
129     uint256 private _initialTax=0;
130     uint256 private _finalTax=4;
131     uint256 private _reduceTaxAt=75;
132     uint256 private _buyCount=0;
133 
134     uint8 private constant _decimals = 9;
135     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
136     string private constant _name = unicode"Flat Eric";
137     string private constant _symbol = unicode"FLAT";
138     uint256 public _maxTxAmount = 10000000 * 10**_decimals;
139     uint256 public _maxWalletSize = 10000000 * 10**_decimals;
140     uint256 public _taxSwap = 2500000 * 10**_decimals;
141 
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     bool private inSwap = false;
145 
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152 
153     constructor () {
154         _taxWallet = payable(_msgSender());
155         _balances[_msgSender()] = _tTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_taxWallet] = true;
159         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
160         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
161 
162         emit Transfer(address(0), _msgSender(), _tTotal);
163     }
164 
165     function name() public pure returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public pure returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public pure returns (uint8) {
174         return _decimals;
175     }
176 
177     function totalSupply() public pure override returns (uint256) {
178         return _tTotal;
179     }
180 
181     function balanceOf(address account) public view override returns (uint256) {
182         return _balances[account];
183     }
184 
185     function transfer(address recipient, uint256 amount) public override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
202         return true;
203     }
204 
205     function _approve(address owner, address spender, uint256 amount) private {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208         _allowances[owner][spender] = amount;
209         emit Approval(owner, spender, amount);
210     }
211 
212     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
213         _isExcludedFromFee[holder] = exempt;
214     }
215 
216     function _transfer(address from, address to, uint256 amount) private {
217         require(from != address(0), "ERC20: transfer from the zero address");
218         require(to != address(0), "ERC20: transfer to the zero address");
219         require(amount > 0, "Transfer amount must be greater than zero");
220         uint256 taxAmount=0;
221         if (from != owner() && to != owner()) {
222             require(!bots[from] && !bots[to]);
223             if(!inSwap){
224               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
225             }
226 
227             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
228                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
229                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
230                 _buyCount++;
231             }
232 
233             uint256 contractTokenBalance = balanceOf(address(this));
234             if (!inSwap && from != uniswapV2Pair && contractTokenBalance>_taxSwap) {
235                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
236                 uint256 contractETHBalance = address(this).balance;
237                 if(contractETHBalance > 0) {
238                     sendETHToFee(address(this).balance);
239                 }
240             }
241         }
242 
243         _balances[from]=_balances[from].sub(amount);
244         _balances[to]=_balances[to].add(amount.sub(taxAmount));
245         emit Transfer(from, to, amount.sub(taxAmount));
246         if(taxAmount>0){
247           _balances[address(this)]=_balances[address(this)].add(taxAmount);
248           emit Transfer(from, address(this),taxAmount);
249         }
250     }
251 
252     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
253         address[] memory path = new address[](2);
254         path[0] = address(this);
255         path[1] = uniswapV2Router.WETH();
256         _approve(address(this), address(uniswapV2Router), tokenAmount);
257         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
258             tokenAmount,
259             0,
260             path,
261             address(this),
262             block.timestamp
263         );
264     }
265 
266     function removeLimits() external onlyOwner{
267         _maxTxAmount = _tTotal;
268         _maxWalletSize=_tTotal;
269         emit MaxTxAmountUpdated(_tTotal);
270     }
271 
272     function sendETHToFee(uint256 amount) private {
273         _taxWallet.transfer(amount);
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
292     function reduceFee(uint256 _newFee) external{
293       require(_msgSender()==_taxWallet);
294       require(_newFee<6);
295       _finalTax=_newFee;
296     }
297 
298 
299     receive() external payable {}
300 
301     function manualSwap() external {
302         require(_msgSender() == _taxWallet);
303         swapTokensForEth(balanceOf(address(this)));
304     }
305 
306     function manualSend() external {
307         require(_msgSender() == _taxWallet);
308         sendETHToFee(address(this).balance);
309     }
310 
311     function manualSendToken() external {
312         require(_msgSender() == _taxWallet);
313         IERC20(address(this)).transfer(msg.sender, balanceOf(address(this)));
314     }
315 }