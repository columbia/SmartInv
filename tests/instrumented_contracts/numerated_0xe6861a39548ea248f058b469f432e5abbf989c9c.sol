1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 abstract contract Ownable {
5     address private _owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     
10     constructor() {
11         _transferOwnership(msg.sender);
12     }
13 
14     
15     function owner() public view virtual returns (address) {
16         return _owner;
17     }
18 
19    
20     modifier onlyOwner() {
21         require(owner() == msg.sender, "Ownable: caller is not the owner");
22         _;
23     }
24 
25     
26     function renounceOwnership() public virtual onlyOwner {
27         _transferOwnership(address(0));
28     }
29 
30    
31     function transferOwnership(address newOwner) public virtual onlyOwner {
32         require(newOwner != address(0), "Ownable: new owner is the zero address");
33         _transferOwnership(newOwner);
34     }
35 
36    
37     function _transferOwnership(address newOwner) internal virtual {
38         address oldOwner = _owner;
39         _owner = newOwner;
40         emit OwnershipTransferred(oldOwner, newOwner);
41     }
42 }
43 
44 
45 interface IUniswapV2Factory {
46     function createPair(
47         address tokenA,
48         address tokenB
49     ) external returns (address pair);
50 }
51 
52 interface IUniswapV2Router {
53     function swapExactTokensForETHSupportingFeeOnTransferTokens(
54         uint256 amountIn,
55         uint256 amountOutMin,
56         address[] calldata path,
57         address to,
58         uint256 deadline
59     ) external;
60 
61     function factory() external pure returns (address);
62 
63     function WETH() external pure returns (address);
64 }
65 
66 
67 
68 contract HADES is Ownable {
69     mapping(address => uint256) public _balances;
70 
71     mapping(address => mapping(address => uint256)) public _allowances;
72 
73     uint256 public _totalSupply;
74 
75     string public _name;
76     string public _symbol;
77     uint8 _decimals;
78 
79     // 
80     address public pairAddress;
81     bool public swapping;
82 
83     uint256 public maxWalletAmount;
84 
85     uint256 public buyFee;
86 
87     uint256 public sellFee;
88 
89     IUniswapV2Router public router;
90 
91     mapping(address => bool) public feeWhiteList;
92     mapping(address => bool) public maxWalletWhiteList;
93 
94     
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 
100     
101     
102     constructor() {
103         _name = "HADES";
104         _symbol = "HADES";
105         _decimals = 18;
106         _mint(msg.sender, (100_000_000 * 10 ** decimals()));
107 
108 
109         maxWalletAmount = 2_000_000 * 10 ** decimals();
110 
111 
112 
113 
114         feeWhiteList[msg.sender] = true;
115         feeWhiteList[address(this)] = true;
116 
117         maxWalletWhiteList[msg.sender] = true;
118         maxWalletWhiteList[address(this)] = true;
119         router = IUniswapV2Router(
120             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
121         );
122         pairAddress = IUniswapV2Factory(router.factory()).createPair(
123             address(this),
124             router.WETH()
125         );
126         maxWalletWhiteList[pairAddress] = true;
127 
128         _approve(msg.sender, address(router), type(uint256).max);
129         _approve(address(this), address(router), type(uint256).max);
130 
131     }
132 
133 
134    
135     function name() public view virtual  returns (string memory) {
136         return _name;
137     }
138 
139 
140     function symbol() public view virtual  returns (string memory) {
141         return _symbol;
142     }
143 
144    
145     function decimals() public view virtual  returns (uint8) {
146         return _decimals;
147     }
148 
149     function totalSupply() public view virtual  returns (uint256) {
150         return _totalSupply;
151     }
152 
153    
154     function balanceOf(address account) public view virtual  returns (uint256) {
155         return _balances[account];
156     }
157 
158  
159     function transfer(address recipient, uint256 amount) public virtual  returns (bool) {
160         _transfer(msg.sender, recipient, amount);
161         return true;
162     }
163 
164     function allowance(address owner, address spender) public view virtual  returns (uint256) {
165         return _allowances[owner][spender];
166     }
167 
168     function updatePairAddress(address _pairAddress) public onlyOwner {
169         pairAddress = _pairAddress;
170     }
171 
172     
173 
174     function updateMaxWalletAmount(uint256 _maxWalletAmount) public onlyOwner {
175         maxWalletAmount = _maxWalletAmount;
176     }
177 
178     function updateFees(uint256 _buyFee, uint256 _sellFee) public onlyOwner {
179         require(_buyFee <=3334);
180         require(_sellFee <=3334);
181         buyFee = _buyFee;
182         sellFee = _sellFee;
183     }
184 
185     function updateFeeWhiteList(address user, bool value) public onlyOwner {
186         feeWhiteList[user] = value;
187     }
188 
189     function updateMaxWalletWhiteList(address user, bool value) public onlyOwner {
190         maxWalletWhiteList[user] = value;
191     }
192 
193  
194     function approve(address spender, uint256 amount) public virtual returns (bool) {
195         _approve(msg.sender, spender, amount);
196         return true;
197     }
198 
199     
200     function transferFrom(
201         address sender,
202         address recipient,
203         uint256 amount
204     ) public virtual  returns (bool) {
205         _transfer(sender, recipient, amount);
206 
207         uint256 currentAllowance = _allowances[sender][msg.sender];
208         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
209         unchecked {
210             _approve(sender, msg.sender, currentAllowance - amount);
211         }
212 
213         return true;
214     }
215 
216   
217     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
218         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
219         return true;
220     }
221 
222  
223     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
224         uint256 currentAllowance = _allowances[msg.sender][spender];
225         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
226         unchecked {
227             _approve(msg.sender, spender, currentAllowance - subtractedValue);
228         }
229 
230         return true;
231     }
232 
233 
234     function _transfer(
235         address sender,
236         address recipient,
237         uint256 amount
238     ) internal virtual {
239         require(sender != address(0), "ERC20: transfer from the zero address");
240         require(recipient != address(0), "ERC20: transfer to the zero address");
241 
242         bool takeFee = true;
243 
244         if (feeWhiteList[sender] || feeWhiteList[recipient]) {
245             takeFee = false;
246         }
247         if (buyFee + sellFee == 0) {
248             takeFee = false;
249         }
250         uint256 fees = 0;
251 
252         if (takeFee) {
253              if (recipient == pairAddress) {
254                 fees = (amount * sellFee) / 10000;
255             }
256             else if (sender == pairAddress) {
257                 fees = (amount*buyFee) / 10000;
258             }
259         }
260 
261         uint256 senderBalance = _balances[sender];
262         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
263 
264         unchecked {
265             _balances[sender] = senderBalance - amount;
266         }
267         if (fees > 0) {
268             amount = amount - fees;
269             _balances[address(this)] += fees;
270             emit Transfer(sender, (address(this)), fees);
271 
272         }
273         _balances[recipient] += amount;
274 
275         if (!maxWalletWhiteList[recipient]) {
276             require(balanceOf(recipient) <= maxWalletAmount);
277         }
278 
279         emit Transfer(sender, recipient, amount);
280 
281     }
282 
283  
284     function _mint(address account, uint256 amount) internal virtual {
285         require(account != address(0), "ERC20: mint to the zero address");
286 
287 
288         _totalSupply += amount;
289         _balances[account] += amount;
290         emit Transfer(address(0), account, amount);
291 
292     }
293 
294    
295     function _burn(address account, uint256 amount) internal virtual {
296         require(account != address(0), "ERC20: burn from the zero address");
297 
298 
299         uint256 accountBalance = _balances[account];
300         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
301         unchecked {
302             _balances[account] = accountBalance - amount;
303         }
304         _totalSupply -= amount;
305 
306         emit Transfer(account, address(0), amount);
307 
308     }
309 
310     function _approve(
311         address owner,
312         address spender,
313         uint256 amount
314     ) internal virtual {
315         require(owner != address(0), "ERC20: approve from the zero address");
316         require(spender != address(0), "ERC20: approve to the zero address");
317 
318         _allowances[owner][spender] = amount;
319         emit Approval(owner, spender, amount);
320     }
321 
322     function swapFee() public {
323         swapping = true;
324         uint256 contractBalance = _balances[address(this)];
325         if (contractBalance == 0) {
326             return;
327         }
328 
329         address[] memory path = new address[](2);
330         path[0] = address(this);
331         path[1] = router.WETH();
332         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
333             contractBalance,
334             0,
335             path,
336             owner(),
337             (block.timestamp)
338         );
339     swapping = false;
340 
341 
342     }
343 }