1 /**
2 
3    https://x.com/erchelium
4 
5    https://t.me/Helium_ERC
6     
7 **/
8 // SPDX-License-Identifier: Unlicensed
9 
10 pragma solidity 0.8.18;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount)
24         external
25         returns (bool);
26 
27     function allowance(address owner, address spender)
28         external
29         view
30         returns (uint256);
31 
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 contract Ownable is Context {
49     address private _owner;
50     address private _previousOwner;
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     constructor() {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     function transferOwnership(address newOwner) public onlyOwner {
72         _transferOwnership(newOwner);
73     }
74 
75     function _transferOwnership(address newOwner) internal {
76         require(
77             newOwner != address(0),
78             "Ownable: new owner is the zero address"
79         );
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 }
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB)
92         external
93         returns (address pair);
94 }
95 
96 interface IUniswapV2Router02 {
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint256 amountIn,
99         uint256 amountOutMin,
100         address[] calldata path,
101         address to,
102         uint256 deadline
103     ) external;
104 
105     function factory() external pure returns (address);
106 
107     function WETH() external pure returns (address);
108 }
109 
110 contract Helium is Context, IERC20, Ownable {
111     uint256 private constant _totalSupply = 10_000_000e18;
112     uint256 private constant onePercent = 100_000e18;
113     uint256 private constant minSwap = 25_000e18;
114     uint8 private constant _decimals = 18;
115 
116     IUniswapV2Router02 immutable uniswapV2Router;
117     address immutable uniswapV2Pair;
118     address immutable WETH;
119     address payable immutable marketingWallet;
120 
121 
122     mapping(address => uint256) private _balance;
123     mapping(address => mapping(address => uint256)) private _allowances;
124     mapping(address => bool) private _isExcludedFromFeeWallet;
125 
126     uint256 public buyTax;
127     uint256 public sellTax;
128 
129     uint8 private launch;
130     uint8 private inSwapAndLiquify;
131 
132     uint256 private launchBlock;
133     uint256 public maxTxAmount = onePercent * 2; //max Tx for first mins after launch
134 
135     string private constant _name = "Helium";
136     string private constant _symbol = "HE";
137 
138     constructor() {
139         uniswapV2Router = IUniswapV2Router02(
140             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
141         );
142         WETH = uniswapV2Router.WETH();
143         buyTax = 25;
144         sellTax = 25;
145 
146         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
147             address(this),
148             WETH
149         );
150 
151         marketingWallet = payable(msg.sender);
152         _balance[msg.sender] = _totalSupply;
153         _isExcludedFromFeeWallet[marketingWallet] = true;
154         _isExcludedFromFeeWallet[msg.sender] = true;
155         _isExcludedFromFeeWallet[address(this)] = true;
156         _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
157             .max;
158         _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
159         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
160             .max;
161 
162         emit Transfer(address(0), _msgSender(), _totalSupply);
163     }
164 
165     function name() public pure returns (string memory) {
166         return _name;
167     }
168 
169     function marketingAddress() public view returns (address) {
170         return marketingWallet;
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
182         return _totalSupply;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return _balance[account];
187     }
188 
189     function transfer(address recipient, uint256 amount)
190         public
191         override
192         returns (bool)
193     {
194         _transfer(_msgSender(), recipient, amount);
195         return true;
196     }
197 
198     function allowance(address owner, address spender)
199         public
200         view
201         override
202         returns (uint256)
203     {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount)
208         public
209         override
210         returns (bool)
211     {
212         _approve(_msgSender(), spender, amount);
213         return true;
214     }
215 
216     function transferFrom(
217         address sender,
218         address recipient,
219         uint256 amount
220     ) public override returns (bool) {
221         _transfer(sender, recipient, amount);
222         _approve(
223             sender,
224             _msgSender(),
225             _allowances[sender][_msgSender()] - amount
226         );
227         return true;
228     }
229 
230     function _approve(
231         address owner,
232         address spender,
233         uint256 amount
234     ) private {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237         _allowances[owner][spender] = amount;
238         emit Approval(owner, spender, amount);
239     }
240 
241     function openTrading() external onlyOwner {
242         launch = 1;
243         launchBlock = block.number;
244     }
245 
246     function addExcludedWallet(address wallet) external onlyOwner {
247         _isExcludedFromFeeWallet[wallet] = true;
248     }
249 
250     function removeLimits() external onlyOwner {
251         maxTxAmount = _totalSupply;
252     }
253 
254     function changeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
255         require(newBuyTax < 26, "Cannot set buy tax greater than 26%");
256         require(newSellTax < 41, "Cannot set sell tax greater than 41%");
257         buyTax = newBuyTax;
258         sellTax = newSellTax;
259     }
260 
261     function _transfer(
262         address from,
263         address to,
264         uint256 amount
265     ) private {
266         require(from != address(0), "ERC20: transfer from the zero address");
267         require(amount > 1e9, "Min transfer amt");
268 
269         uint256 _tax;
270         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
271             _tax = 0;
272         } else {
273             require(
274                 launch != 0 && amount <= maxTxAmount,
275                 "Launch / Max TxAmount 1% at launch"
276             );
277 
278             if (inSwapAndLiquify == 1) {
279                 //No tax transfer
280                 _balance[from] -= amount;
281                 _balance[to] += amount;
282 
283                 emit Transfer(from, to, amount);
284                 return;
285             }
286 
287             if (from == uniswapV2Pair) {
288                 _tax = buyTax;
289             } else if (to == uniswapV2Pair) {
290                 uint256 tokensToSwap = _balance[address(this)];
291                 if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
292                     if (tokensToSwap > onePercent) {
293                         tokensToSwap = onePercent;
294                     }
295                     inSwapAndLiquify = 1;
296                     address[] memory path = new address[](2);
297                     path[0] = address(this);
298                     path[1] = WETH;
299                     uniswapV2Router
300                         .swapExactTokensForETHSupportingFeeOnTransferTokens(
301                             tokensToSwap,
302                             0,
303                             path,
304                             marketingWallet,
305                             block.timestamp
306                         );
307                     inSwapAndLiquify = 0;
308                 }
309                 _tax = sellTax;
310             } else {
311                 _tax = 0;
312             }
313         }
314 
315         //Is there tax for sender|receiver?
316         if (_tax != 0) {
317             //Tax transfer
318             uint256 taxTokens = (amount * _tax) / 100;
319             uint256 transferAmount = amount - taxTokens;
320 
321             _balance[from] -= amount;
322             _balance[to] += transferAmount;
323             _balance[address(this)] += taxTokens;
324             emit Transfer(from, address(this), taxTokens);
325             emit Transfer(from, to, transferAmount);
326         } else {
327             //No tax transfer
328             _balance[from] -= amount;
329             _balance[to] += amount;
330 
331             emit Transfer(from, to, amount);
332         }
333     }
334 
335     receive() external payable {}
336 }