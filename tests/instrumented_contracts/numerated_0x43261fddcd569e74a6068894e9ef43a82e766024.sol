1 /**
2 */
3 /**
4 
5      
6 //                                             //
7     The Doggo   
8      Telegram: https://t.me/DoggoOfficial
9      Website : https://doggo.wtf/
10      Twitter : https://twitter.com/Doggo_ERC20
11 //                                             //
12 
13 **/
14 // SPDX-License-Identifier: Unlicensed
15 
16 pragma solidity 0.8.18;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address recipient, uint256 amount)
30         external
31         returns (bool);
32 
33     function allowance(address owner, address spender)
34         external
35         view
36         returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(
48         address indexed owner,
49         address indexed spender,
50         uint256 value
51     );
52 }
53 
54 contract Ownable is Context {
55     address private _owner;
56     address private _previousOwner;
57     event OwnershipTransferred(
58         address indexed previousOwner,
59         address indexed newOwner
60     );
61 
62     constructor() {
63         address msgSender = _msgSender();
64         _owner = msgSender;
65         emit OwnershipTransferred(address(0), msgSender);
66     }
67 
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     modifier onlyOwner() {
73         require(_owner == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     function transferOwnership(address newOwner) public onlyOwner {
78         _transferOwnership(newOwner);
79     }
80 
81     function _transferOwnership(address newOwner) internal {
82         require(
83             newOwner != address(0),
84             "Ownable: new owner is the zero address"
85         );
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 }
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB)
98         external
99         returns (address pair);
100 }
101 
102 interface IUniswapV2Router02 {
103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
104         uint256 amountIn,
105         uint256 amountOutMin,
106         address[] calldata path,
107         address to,
108         uint256 deadline
109     ) external;
110 
111     function factory() external pure returns (address);
112 
113     function WETH() external pure returns (address);
114 }
115 
116 contract DoggoCoin is Context, IERC20, Ownable {
117     uint256 private constant _totalSupply = 420_690_000e18;
118     uint256 private constant onePercent = 8_413_800e18;
119     uint256 private constant minSwap = 250_000e18;
120     uint8 private constant _decimals = 18;
121 
122     IUniswapV2Router02 immutable uniswapV2Router;
123     address immutable uniswapV2Pair;
124     address immutable WETH;
125     address payable immutable marketingWallet;
126 
127     uint256 public buyTax;
128     uint256 public sellTax;
129 
130     uint8 private launch;
131     uint8 private inSwapAndLiquify;
132 
133     uint256 private launchBlock;
134     uint256 public maxTxAmount = onePercent; //max Tx for first mins after launch
135 
136     string private constant _name = "Doggo Coin";
137     string private constant _symbol = "Doggo";
138 
139     mapping(address => uint256) private _balance;
140     mapping(address => mapping(address => uint256)) private _allowances;
141     mapping(address => bool) private _isExcludedFromFeeWallet;
142 
143     constructor() {
144         uniswapV2Router = IUniswapV2Router02(
145             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
146         );
147         WETH = uniswapV2Router.WETH();
148         buyTax = 20;
149         sellTax = 30;
150 
151         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
152             address(this),
153             WETH
154         );
155 
156         marketingWallet = payable(0x84C0E98509849366E0BE66CB372943B73a7509a8);
157         _balance[msg.sender] = _totalSupply;
158         _isExcludedFromFeeWallet[marketingWallet] = true;
159         _isExcludedFromFeeWallet[msg.sender] = true;
160         _isExcludedFromFeeWallet[address(this)] = true;
161         _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
162             .max;
163         _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
164         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
165             .max;
166 
167         emit Transfer(address(0), _msgSender(), _totalSupply);
168     }
169 
170     function name() public pure returns (string memory) {
171         return _name;
172     }
173 
174     function symbol() public pure returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public pure returns (uint8) {
179         return _decimals;
180     }
181 
182     function totalSupply() public pure override returns (uint256) {
183         return _totalSupply;
184     }
185 
186     function balanceOf(address account) public view override returns (uint256) {
187         return _balance[account];
188     }
189 
190     function transfer(address recipient, uint256 amount)
191         public
192         override
193         returns (bool)
194     {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender)
200         public
201         view
202         override
203         returns (uint256)
204     {
205         return _allowances[owner][spender];
206     }
207 
208     function approve(address spender, uint256 amount)
209         public
210         override
211         returns (bool)
212     {
213         _approve(_msgSender(), spender, amount);
214         return true;
215     }
216 
217     function transferFrom(
218         address sender,
219         address recipient,
220         uint256 amount
221     ) public override returns (bool) {
222         _transfer(sender, recipient, amount);
223         _approve(
224             sender,
225             _msgSender(),
226             _allowances[sender][_msgSender()] - amount
227         );
228         return true;
229     }
230 
231     function _approve(
232         address owner,
233         address spender,
234         uint256 amount
235     ) private {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 
242     function openTrading() external onlyOwner {
243         launch = 1;
244         launchBlock = block.number;
245     }
246 
247     function addExcludedWallet(address wallet) external onlyOwner {
248         _isExcludedFromFeeWallet[wallet] = true;
249     }
250 
251     function removeLimits() external onlyOwner {
252         maxTxAmount = _totalSupply;
253     }
254 
255     function changeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
256         buyTax = newBuyTax;
257         sellTax = newSellTax;
258     }
259 
260     function _transfer(
261         address from,
262         address to,
263         uint256 amount
264     ) private {
265         require(from != address(0), "ERC20: transfer from the zero address");
266         require(amount > 1e9, "Min transfer amt");
267 
268         uint256 _tax;
269         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
270             _tax = 0;
271         } else {
272             require(
273                 launch != 0 && amount <= maxTxAmount,
274                 "Launch / Max TxAmount 1% at launch"
275             );
276 
277             if (inSwapAndLiquify == 1) {
278                 //No tax transfer
279                 _balance[from] -= amount;
280                 _balance[to] += amount;
281 
282                 emit Transfer(from, to, amount);
283                 return;
284             }
285 
286             if (from == uniswapV2Pair) {
287                 _tax = buyTax;
288             } else if (to == uniswapV2Pair) {
289                 uint256 tokensToSwap = _balance[address(this)];
290                 if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
291                     if (tokensToSwap > onePercent) {
292                         tokensToSwap = onePercent;
293                     }
294                     inSwapAndLiquify = 1;
295                     address[] memory path = new address[](2);
296                     path[0] = address(this);
297                     path[1] = WETH;
298                     uniswapV2Router
299                         .swapExactTokensForETHSupportingFeeOnTransferTokens(
300                             tokensToSwap,
301                             0,
302                             path,
303                             marketingWallet,
304                             block.timestamp
305                         );
306                     inSwapAndLiquify = 0;
307                 }
308                 _tax = sellTax;
309             } else {
310                 _tax = 0;
311             }
312         }
313 
314         //Is there tax for sender|receiver?
315         if (_tax != 0) {
316             //Tax transfer
317             uint256 taxTokens = (amount * _tax) / 100;
318             uint256 transferAmount = amount - taxTokens;
319 
320             _balance[from] -= amount;
321             _balance[to] += transferAmount;
322             _balance[address(this)] += taxTokens;
323             emit Transfer(from, address(this), taxTokens);
324             emit Transfer(from, to, transferAmount);
325         } else {
326             //No tax transfer
327             _balance[from] -= amount;
328             _balance[to] += amount;
329 
330             emit Transfer(from, to, amount);
331         }
332     }
333 
334     receive() external payable {}
335 }