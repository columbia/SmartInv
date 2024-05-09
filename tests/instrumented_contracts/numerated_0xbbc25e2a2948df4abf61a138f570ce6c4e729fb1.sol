1 /***
2 
3      Telegram:  https://t.me/slurpwhale
4 
5 ***/
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.18;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount)
22         external
23         returns (bool);
24 
25     function allowance(address owner, address spender)
26         external
27         view
28         returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
44 }
45 
46 contract Ownable is Context {
47     address private _owner;
48     address private _previousOwner;
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53 
54     constructor() {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     function transferOwnership(address newOwner) public onlyOwner {
70         _transferOwnership(newOwner);
71     }
72 
73     function _transferOwnership(address newOwner) internal {
74         require(
75             newOwner != address(0),
76             "Ownable: new owner is the zero address"
77         );
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 }
87 
88 library SafeMath {
89 
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93 
94         return c;
95     }
96 }
97 
98 interface IUniswapV2Factory {
99     function createPair(address tokenA, address tokenB)
100         external
101         returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint256 amountIn,
107         uint256 amountOutMin,
108         address[] calldata path,
109         address to,
110         uint256 deadline
111     ) external;
112 
113     function factory() external pure returns (address);
114 
115     function WETH() external pure returns (address);
116 }
117 
118 
119 contract ContractSLURP is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     
122     string private constant _name = "Slurp";
123     string private constant _symbol = "SLURP";
124     uint256 private constant _totalSupply = 1_000_000_000_000 * 10**18;
125     uint256 public MinTaxSwapLimit = 1_000_000_000 * 10**18; // 0.1% of the total Supply
126     uint256 public maxWalletlimit = 10_000_000_001 * 10**18; // 1% Maxwalletlimit
127     uint8 private constant _decimals = 18;
128 
129     IUniswapV2Router02 immutable uniswapV2Router;
130     address immutable uniswapV2Pair;
131     address immutable WETH;
132     address payable public marketingWallet;
133 
134     uint256 public buyTax;
135     uint256 public sellTax;
136     uint8 private inSwapAndLiquify;
137 
138     mapping(address => uint256) private _balance;
139     mapping(address => mapping(address => uint256)) private _allowances;
140     mapping(address => bool) private _isExcludedFromFees;
141     
142     bool public isOpen = false;
143     mapping(address => bool) private _whiteList;
144     modifier open(address from, address to) {
145         require(isOpen || _whiteList[from] || _whiteList[to], "Not Open");
146         _;
147     }
148 
149     constructor() {
150         uniswapV2Router = IUniswapV2Router02(
151             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
152         );
153         WETH = uniswapV2Router.WETH();
154         buyTax = 2;
155         sellTax = 2;
156 
157         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
158             address(this),
159             WETH
160         );
161         
162         _whiteList[msg.sender] = true;
163         _whiteList[address(this)] = true;
164 
165         marketingWallet = payable(0xB3B31EF24CEDaF23E652fB0b45888dA947af9aaE);
166         _balance[msg.sender] = _totalSupply;
167         _isExcludedFromFees[marketingWallet] = true;
168         _isExcludedFromFees[msg.sender] = true;
169         _isExcludedFromFees[address(this)] = true;
170         _isExcludedFromFees[address(uniswapV2Router)] = true;
171         _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
172             .max;
173         _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
174         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
175             .max;
176 
177         emit Transfer(address(0), _msgSender(), _totalSupply);
178     }
179 
180     function name() public pure returns (string memory) {
181         return _name;
182     }
183 
184     function symbol() public pure returns (string memory) {
185         return _symbol;
186     }
187 
188     function decimals() public pure returns (uint8) {
189         return _decimals;
190     }
191 
192     function totalSupply() public pure override returns (uint256) {
193         return _totalSupply;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return _balance[account];
198     }
199 
200     function transfer(address recipient, uint256 amount)
201         public
202         override
203         returns (bool)
204     {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     function allowance(address owner, address spender)
210         public
211         view
212         override
213         returns (uint256)
214     {
215         return _allowances[owner][spender];
216     }
217 
218     function approve(address spender, uint256 amount)
219         public
220         override
221         returns (bool)
222     {
223         _approve(_msgSender(), spender, amount);
224         return true;
225     }
226 
227     function transferFrom(
228         address sender,
229         address recipient,
230         uint256 amount
231     ) public override returns (bool) {
232         _transfer(sender, recipient, amount);
233         _approve(
234             sender,
235             _msgSender(),
236             _allowances[sender][_msgSender()] - amount
237         );
238         return true;
239     }
240 
241     function _approve(
242         address owner,
243         address spender,
244         uint256 amount
245     ) private {
246         require(owner != address(0), "ERC20: approve from the zero address");
247         require(spender != address(0), "ERC20: approve to the zero address");
248         _allowances[owner][spender] = amount;
249         emit Approval(owner, spender, amount);
250     }
251     
252     function ExcludeFromFees(address holder, bool exempt) external onlyOwner {
253         _isExcludedFromFees[holder] = exempt;
254     }
255     
256     function ChangeMinTaxSwapLimit(uint256 NewMinTaxSwapLimitAmount) external onlyOwner {
257         MinTaxSwapLimit = NewMinTaxSwapLimitAmount;
258     }
259 
260     function DisableWalletLimit() external onlyOwner {
261         maxWalletlimit = _totalSupply;
262     }
263     
264     function ChangeMarketingWalletAddress(address newAddress) external onlyOwner() {
265         marketingWallet = payable(newAddress);
266     }
267     
268     function EnableTrade() external onlyOwner {
269         isOpen = true;
270     }
271 
272     function includeToWhiteList(address[] memory _users) external onlyOwner {
273         for(uint8 i = 0; i < _users.length; i++) {
274             _whiteList[_users[i]] = true;
275         }
276     }
277 
278     // Contract Coded by @Hassanrazaxv on Fiverr and Telegram
279 
280     function _transfer(
281         address from,
282         address to,
283         uint256 amount
284     ) private {
285         require(from != address(0), "ERC20: transfer from the zero address");
286         require(amount > 1e9, "Min transfer amt");
287         require(isOpen || _whiteList[from] || _whiteList[to], "Not Open");
288 
289         uint256 _tax;
290         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
291             _tax = 0;
292         } else {
293 
294             if (inSwapAndLiquify == 1) {
295                 //No tax transfer
296                 _balance[from] -= amount;
297                 _balance[to] += amount;
298 
299                 emit Transfer(from, to, amount);
300                 return;
301             }
302 
303             if (from == uniswapV2Pair) {
304                 _tax = buyTax;
305                 require(balanceOf(to).add(amount) <= maxWalletlimit);
306             } else if (to == uniswapV2Pair) {
307                 uint256 tokensToSwap = _balance[address(this)];
308                 if (tokensToSwap > MinTaxSwapLimit && inSwapAndLiquify == 0) {
309                     inSwapAndLiquify = 1;
310                     address[] memory path = new address[](2);
311                     path[0] = address(this);
312                     path[1] = WETH;
313                     uniswapV2Router
314                         .swapExactTokensForETHSupportingFeeOnTransferTokens(
315                             tokensToSwap,
316                             0,
317                             path,
318                             marketingWallet,
319                             block.timestamp
320                         );
321                     inSwapAndLiquify = 0;
322                 }
323                 _tax = sellTax;
324             } else {
325                 _tax = 0;
326             }
327         }
328         
329     // Contract Coded by @Hassanrazaxv on Fiverr and Telegram
330 
331         //Is there tax for sender|receiver?
332         if (_tax != 0) {
333             //Tax transfer
334             uint256 taxTokens = (amount * _tax) / 100;
335             uint256 transferAmount = amount - taxTokens;
336 
337             _balance[from] -= amount;
338             _balance[to] += transferAmount;
339             _balance[address(this)] += taxTokens;
340             emit Transfer(from, address(this), taxTokens);
341             emit Transfer(from, to, transferAmount);
342         } else {
343             //No tax transfer
344             _balance[from] -= amount;
345             _balance[to] += amount;
346 
347             emit Transfer(from, to, amount);
348         }
349     }
350 
351     receive() external payable {}
352 }