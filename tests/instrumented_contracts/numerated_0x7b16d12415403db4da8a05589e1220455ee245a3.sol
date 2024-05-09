1 /**
2 
3     purrrr
4 
5     Telegram: https://t.me/CattoOfficial
6     Twitter: https://twitter.com/Catto_ERC
7     Website: https://catto.vip/
8 
9 
10 **/
11 
12 // SPDX-License-Identifier: Unlicensed
13 
14 pragma solidity 0.8.18;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24 
25     function balanceOf(address account) external view returns (uint256);
26 
27     function transfer(address recipient, uint256 amount)
28         external
29         returns (bool);
30 
31     function allowance(address owner, address spender)
32         external
33         view
34         returns (uint256);
35 
36     function approve(address spender, uint256 amount) external returns (bool);
37 
38     function transferFrom(
39         address sender,
40         address recipient,
41         uint256 amount
42     ) external returns (bool);
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(
46         address indexed owner,
47         address indexed spender,
48         uint256 value
49     );
50 }
51 
52 contract Ownable is Context {
53     address private _owner;
54     address private _previousOwner;
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     constructor() {
61         address msgSender = _msgSender();
62         _owner = msgSender;
63         emit OwnershipTransferred(address(0), msgSender);
64     }
65 
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     function transferOwnership(address newOwner) public onlyOwner {
76         _transferOwnership(newOwner);
77     }
78 
79     function _transferOwnership(address newOwner) internal {
80         require(
81             newOwner != address(0),
82             "Ownable: new owner is the zero address"
83         );
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 }
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB)
96         external
97         returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint256 amountIn,
103         uint256 amountOutMin,
104         address[] calldata path,
105         address to,
106         uint256 deadline
107     ) external;
108 
109     function factory() external pure returns (address);
110 
111     function WETH() external pure returns (address);
112 }
113 
114 contract Catto is Context, IERC20, Ownable {
115     uint256 private constant _totalSupply = 100_000_000e18;
116     uint256 private constant onePercent = 2_000_000e18;
117     uint256 private constant minSwap = 250_000e18;
118     uint8 private constant _decimals = 18;
119 
120     IUniswapV2Router02 immutable uniswapV2Router;
121     address immutable uniswapV2Pair;
122     address immutable WETH;
123     address payable immutable marketingWallet;
124 
125     uint256 public buyTax;
126     uint256 public sellTax;
127 
128     uint8 private launch;
129     uint8 private inSwapAndLiquify;
130 
131     uint256 private launchBlock;
132     uint256 public maxTxAmount = onePercent; //max Tx for first mins after launch
133 
134     string private constant _name = "Catto";
135     string private constant _symbol = "CATTO";
136 
137     mapping(address => uint256) private _balance;
138     mapping(address => mapping(address => uint256)) private _allowances;
139     mapping(address => bool) private _isExcludedFromFeeWallet;
140 
141     constructor() {
142         uniswapV2Router = IUniswapV2Router02(
143             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
144         );
145         WETH = uniswapV2Router.WETH();
146         buyTax = 30;
147         sellTax = 40;
148 
149         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
150             address(this),
151             WETH
152         );
153 
154         marketingWallet = payable(0x851aF38B2E610eb56EC648cb3a2c657042E1940A);
155         _balance[msg.sender] = _totalSupply;
156         _isExcludedFromFeeWallet[marketingWallet] = true;
157         _isExcludedFromFeeWallet[msg.sender] = true;
158         _isExcludedFromFeeWallet[address(this)] = true;
159         _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
160             .max;
161         _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
162         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
163             .max;
164 
165         emit Transfer(address(0), _msgSender(), _totalSupply);
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
181         return _totalSupply;
182     }
183 
184     function balanceOf(address account) public view override returns (uint256) {
185         return _balance[account];
186     }
187 
188     function transfer(address recipient, uint256 amount)
189         public
190         override
191         returns (bool)
192     {
193         _transfer(_msgSender(), recipient, amount);
194         return true;
195     }
196 
197     function allowance(address owner, address spender)
198         public
199         view
200         override
201         returns (uint256)
202     {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount)
207         public
208         override
209         returns (bool)
210     {
211         _approve(_msgSender(), spender, amount);
212         return true;
213     }
214 
215     function transferFrom(
216         address sender,
217         address recipient,
218         uint256 amount
219     ) public override returns (bool) {
220         _transfer(sender, recipient, amount);
221         _approve(
222             sender,
223             _msgSender(),
224             _allowances[sender][_msgSender()] - amount
225         );
226         return true;
227     }
228 
229     function _approve(
230         address owner,
231         address spender,
232         uint256 amount
233     ) private {
234         require(owner != address(0), "ERC20: approve from the zero address");
235         require(spender != address(0), "ERC20: approve to the zero address");
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 
240     function openTrading() external onlyOwner {
241         launch = 1;
242         launchBlock = block.number;
243     }
244 
245     function addExcludedWallet(address wallet) external onlyOwner {
246         _isExcludedFromFeeWallet[wallet] = true;
247     }
248 
249     function removeLimits() external onlyOwner {
250         maxTxAmount = _totalSupply;
251     }
252 
253     function changeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
254         buyTax = newBuyTax;
255         sellTax = newSellTax;
256     }
257 
258     function _transfer(
259         address from,
260         address to,
261         uint256 amount
262     ) private {
263         require(from != address(0), "ERC20: transfer from the zero address");
264         require(amount > 1e9, "Min transfer amt");
265 
266         uint256 _tax;
267         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
268             _tax = 0;
269         } else {
270             require(
271                 launch != 0 && amount <= maxTxAmount,
272                 "Launch / Max TxAmount 2% at launch"
273             );
274 
275             if (inSwapAndLiquify == 1) {
276                 //No tax transfer
277                 _balance[from] -= amount;
278                 _balance[to] += amount;
279 
280                 emit Transfer(from, to, amount);
281                 return;
282             }
283 
284             if (from == uniswapV2Pair) {
285                 _tax = buyTax;
286             } else if (to == uniswapV2Pair) {
287                 uint256 tokensToSwap = _balance[address(this)];
288                 if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
289                     if (tokensToSwap > onePercent) {
290                         tokensToSwap = onePercent;
291                     }
292                     inSwapAndLiquify = 1;
293                     address[] memory path = new address[](2);
294                     path[0] = address(this);
295                     path[1] = WETH;
296                     uniswapV2Router
297                         .swapExactTokensForETHSupportingFeeOnTransferTokens(
298                             tokensToSwap,
299                             0,
300                             path,
301                             marketingWallet,
302                             block.timestamp
303                         );
304                     inSwapAndLiquify = 0;
305                 }
306                 _tax = sellTax;
307             } else {
308                 _tax = 0;
309             }
310         }
311 
312         //Is there tax for sender|receiver?
313         if (_tax != 0) {
314             //Tax transfer
315             uint256 taxTokens = (amount * _tax) / 100;
316             uint256 transferAmount = amount - taxTokens;
317 
318             _balance[from] -= amount;
319             _balance[to] += transferAmount;
320             _balance[address(this)] += taxTokens;
321             emit Transfer(from, address(this), taxTokens);
322             emit Transfer(from, to, transferAmount);
323         } else {
324             //No tax transfer
325             _balance[from] -= amount;
326             _balance[to] += amount;
327 
328             emit Transfer(from, to, amount);
329         }
330     }
331 
332     receive() external payable {}
333 }