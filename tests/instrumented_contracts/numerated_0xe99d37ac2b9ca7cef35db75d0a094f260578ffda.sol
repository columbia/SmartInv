1 // SPDX-License-Identifier: MIT
2 //
3 // ###    ###   ######          ####      ##########   ##########
4 //  ###  ###    ###  ###       ######     ##########   ##########
5 //   ######     ###   ###     ###  ###    ###          ###      
6 //    ####      ###    ###   ###    ###   ###  #####   ##########
7 //    ####      ###    ###   ###    ###   ###  #####   ##########
8 //   ######     ###   ###     ###  ###    ###    ###   ###      
9 //  ###  ###    ###  ###       ######     ##########   ##########
10 // ###    ###   ######          ####      ##########   ##########
11 //
12 // https://twitter.com/XDogeeth
13 // https://t.me/XDogePortalChannel
14 
15 pragma solidity ^0.8.16;
16 
17 library SafeMath {
18     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
19         unchecked {
20             uint256 c = a + b; if (c < a) return (false, 0); return (true, c); 
21         } 
22     }
23 
24     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             if (b > a)
27                 return (false, 0);
28             return (true, a - b); 
29         }
30     }
31 
32     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             if (a == 0)
35                 return (true, 0);
36             uint256 c = a * b;
37             if (c / a != b)
38                 return (false, 0);
39             return (true, c); 
40         }
41     }
42 
43     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             if (b == 0)
46                 return (false, 0);
47             return (true, a / b);
48         }
49     }
50 
51     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             if (b == 0)
54                 return (false, 0);
55             return (true, a % b);
56         }
57     }
58 
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a + b;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a - b;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a * b;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return a / b;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a % b;
77     }
78 
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         unchecked {
81             require(b <= a, errorMessage);
82             return a - b;
83         }
84     }
85 
86     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         unchecked {
88             require(b > 0, errorMessage);
89             return a / b;
90         }
91     }
92 
93     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         unchecked {
95             require(b > 0, errorMessage);
96             return a % b;
97         }
98     }
99 }
100 
101 interface IERC20 {
102     event Transfer(address indexed from, address indexed to, uint256 value);
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 
105     function name() external view returns (string memory);
106 
107     function symbol() external view returns (string memory);
108 
109     function decimals() external view returns (uint8);
110 
111     function totalSupply() external view returns (uint256);
112 
113     function balanceOf(address account) external view returns (uint256);
114 
115     function transfer(address to, uint256 amount) external returns (bool);
116 
117     function allowance(address owner, address spender) external view returns (uint256);
118 
119     function approve(address spender, uint256 amount) external returns (bool);
120 
121     function transferFrom(address from, address to, uint256 amount) external returns (bool);
122 }
123 
124 interface IUniswapFactoryV2 {
125     function createPair(address tokenA, address tokenB) external returns (address pair);
126 }
127 
128 interface IUniswapRouterV2 {
129     function factory() external view returns (address);
130 
131     function WETH() external view returns (address);
132 
133     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline) external;
138 
139     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn,
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline) external;
144 
145     function swapExactTokensForETH(uint256 amountIn,
146         uint256 amountOutMin,
147         address[] calldata path,
148         address to,
149         uint256 deadline) external;
150 }
151 
152 abstract contract Context {
153     function _msgSender() internal view virtual returns (address) { return msg.sender; }
154     function _msgData() internal view virtual returns (bytes calldata) { return msg.data; }
155 }
156 
157 abstract contract Ownable is Context {
158     address private _owner;
159 
160     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162     constructor() { _transferOwnership(_msgSender()); }
163 
164     modifier onlyOwner() { _checkOwner(); _; }
165 
166     function owner() public view virtual returns (address) { return _owner; }
167 
168     function _checkOwner() internal view virtual { require(owner() == _msgSender(), "Ownable: caller is not the owner"); }
169 
170     function renounceOwnership() public virtual onlyOwner { _transferOwnership(address(0)); }
171 
172     function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), "Ownable: new owner is the zero address"); _transferOwnership(newOwner); }
173 
174     function _transferOwnership(address newOwner) internal virtual { address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner); }
175 }
176 
177 abstract contract ERC20 is Context, IERC20 {
178     mapping(address => uint256) private _balances;
179     mapping(address => mapping(address => uint256)) private _allowances;
180     uint256 private _totalSupply;
181     uint8 private _decimals;
182     string private _name;
183     string private _symbol;
184 
185     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
186         _name = name_;
187         _symbol = symbol_;
188         _decimals = decimals_;
189     }
190 
191     function name() public view virtual override returns (string memory) {
192         return _name;
193     }
194 
195     function symbol() public view virtual override returns (string memory) {
196         return _symbol;
197     }
198 
199     function decimals() public view virtual override returns (uint8) {
200         return _decimals;
201     }
202 
203     function totalSupply() public view virtual override returns (uint256) {
204         return _totalSupply;
205     }
206 
207     function balanceOf(address account) public view virtual override returns (uint256) {
208         return _balances[account];
209     }
210 
211     function transfer(address to, uint256 amount) public virtual override returns (bool) {
212         address owner = _msgSender();
213         _transfer(owner, to, amount);
214         return true;
215     }
216 
217     function allowance(address owner, address spender) public view virtual override returns (uint256) {
218         return _allowances[owner][spender];
219     }
220 
221     function approve(address spender, uint256 amount) public virtual override returns (bool) {
222         address owner = _msgSender();
223         _approve(owner, spender, amount);
224         return true;
225     }
226 
227     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
228         address spender = _msgSender();
229         _spendAllowance(from, spender, amount);
230         _transfer(from, to, amount);
231         return true;
232     }
233 
234     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
235         address owner = _msgSender();
236         _approve(owner, spender, allowance(owner, spender) + addedValue);
237         return true;
238     }
239 
240     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
241         address owner = _msgSender();
242         uint256 currentAllowance = allowance(owner, spender);
243         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
244         unchecked { _approve(owner, spender, currentAllowance - subtractedValue); }
245         return true;
246     }
247 
248     function _transfer(address from, address to, uint256 amount) internal virtual {
249         require(from != address(0), "ERC20: transfer from the zero address");
250         require(to != address(0), "ERC20: transfer to the zero address");
251         _beforeTokenTransfer(from, to, amount);
252         uint256 fromBalance = _balances[from];
253         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
254         unchecked { _balances[from] = fromBalance - amount; _balances[to] += amount; }
255         emit Transfer(from, to, amount);
256         _afterTokenTransfer(from, to, amount);
257     }
258 
259     function _mint(address account, uint256 amount) internal virtual {
260         require(account != address(0), "ERC20: mint to the zero address");
261         _beforeTokenTransfer(address(0), account, amount);
262         _totalSupply += amount;
263         unchecked { _balances[account] += amount; }
264         emit Transfer(address(0), account, amount);
265         _afterTokenTransfer(address(0), account, amount);
266     }
267 
268     function _burn(address account, uint256 amount) internal virtual {
269         require(account != address(0), "ERC20: burn from the zero address");
270         _beforeTokenTransfer(account, address(0), amount);
271         uint256 accountBalance = _balances[account];
272         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
273         unchecked { _balances[account] = accountBalance - amount; _totalSupply -= amount; }
274         emit Transfer(account, address(0), amount);
275         _afterTokenTransfer(account, address(0), amount);
276     }
277 
278     function _approve(address owner, address spender, uint256 amount) internal virtual {
279         require(owner != address(0), "ERC20: approve from the zero address");
280         require(spender != address(0), "ERC20: approve to the zero address");
281         _allowances[owner][spender] = amount;
282         emit Approval(owner, spender, amount);
283     }
284 
285     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
286         uint256 currentAllowance = allowance(owner, spender);
287         if (currentAllowance != type(uint256).max) {
288             require(currentAllowance >= amount, "ERC20: insufficient allowance");
289             unchecked { _approve(owner, spender, currentAllowance - amount); }
290         }
291     }
292 
293     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
294     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
295 }
296 
297 contract TOKEN is ERC20, Ownable {
298     using SafeMath for uint256;
299 
300     IUniswapRouterV2 private router;
301 
302     address public weth;
303     address public mainpair;
304     address public routerAddr = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
305     address public marketingAddr = 0x4613F6c068388466b655547aF9A38FB60058713A;
306 
307     uint256 public lb = 0;
308     uint256 public buyfee = 5;
309     uint256 public sellfee = 20;
310 
311     bool    private _swapping;
312     uint256 private _swapAmount;
313     uint256 private constant _totalSupply = 42 * 10000 * 10000 * (10**18);
314 
315     mapping(address => bool) private _isExcludedFromFees;
316 
317     event Launched(uint256 blockNumber);
318     event FeesUpdated(uint256 buyfee, uint256 sellfee);
319 
320     constructor() ERC20("XDoge", "XDoge", 18) {
321         router = IUniswapRouterV2(routerAddr);
322         weth = router.WETH();
323         mainpair = IUniswapFactoryV2(router.factory()).createPair(weth, address(this));
324 
325         _swapAmount = _totalSupply.div(1000);
326 
327         _isExcludedFromFees[address(this)] = true;
328         _isExcludedFromFees[marketingAddr] = true;
329         _isExcludedFromFees[msg.sender] = true;
330 
331         _mint(msg.sender, _totalSupply);
332 
333         _approve(address(this), routerAddr, ~uint256(0));
334     }
335 
336     receive() external payable {}
337 
338     function excludeFromFees(address[] memory account, bool excluded) public onlyOwner {
339         for (uint256 i = 0; i < account.length; i++) {
340             _isExcludedFromFees[account[i]] = excluded;
341         }
342     }
343 
344     function launch() external onlyOwner {
345         require(lb == 0, "TOKEN: Already launched");
346         lb = block.number;
347         emit Launched(lb);
348     }
349 
350     // fees: (5%, 20%) -> (2%, 2%)
351     function setFees(uint256 _buyfee, uint256 _sellfee) external onlyOwner {
352         require(_buyfee <= buyfee && _sellfee <= sellfee, "TOKEN: Fee too high"); // can't increase fees
353         buyfee = _buyfee;
354         sellfee = _sellfee;
355         emit FeesUpdated(_buyfee, _sellfee);
356     }
357 
358     function getFee(address from, address to) internal view returns (uint256) {
359         if (lb + 3 >= block.number) return 89;
360         if (from == mainpair) return buyfee; // buy or remove liquidity
361         if (to == mainpair) return sellfee; // sell or add liquidity
362         return 0; // transfer
363     }
364 
365     function _transfer(address from, address to, uint256 amount) internal override {
366         require(from != address(0));
367         require(to != address(0));
368         require(amount != 0);
369         require(lb != 0 || from == owner(), "TOKEN: Not launched");
370 
371         if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
372             if (to == mainpair && !_swapping && balanceOf(address(this)) >= _swapAmount) {
373                 _swap();
374             }
375 
376             if (!_swapping) {
377                 uint256 feeAmount = amount.mul(getFee(from, to)).div(100);
378                 if (feeAmount > 0) { amount = amount.sub(feeAmount); super._transfer(from, address(this), feeAmount); }
379                 if (amount > 1) amount = amount.sub(1);
380             }
381         }
382 
383         super._transfer(from, to, amount);
384     }
385 
386     modifier lockTheSwap {
387         _swapping = true;
388         _;
389         _swapping = false;
390     }
391 
392     function _swap() internal lockTheSwap {
393         uint256 amount = balanceOf(address(this));
394         if (amount == 0) return;
395         address[] memory path = new address[](2);
396         path[0] = address(this);
397         path[1] = weth;
398         router.swapExactTokensForETHSupportingFeeOnTransferTokens(amount, 0, path, marketingAddr, block.timestamp);
399     }
400 }