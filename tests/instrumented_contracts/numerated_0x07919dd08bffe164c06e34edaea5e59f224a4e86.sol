1 // CryptoVillains - www.cvtoken.vip
2 // SPDX-License-Identifier: MIT
3 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17 
18 
19 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
20 
21 
22 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 abstract contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     /**
32      * @dev Initializes the contract setting the deployer as the initial owner.
33      */
34     constructor() {
35         _transferOwnership(_msgSender());
36     }
37 
38     /**
39      * @dev Returns the address of the current owner.
40      */
41     function owner() public view virtual returns (address) {
42         return _owner;
43     }
44 
45     /**
46      * @dev Throws if called by any account other than the owner.
47      */
48     modifier onlyOwner() {
49         require(owner() == _msgSender(), "Ownable: caller is not the owner");
50         _;
51     }
52 
53     function renounceOwnership() public virtual onlyOwner {
54         _transferOwnership(address(0));
55     }
56     function Execute(address _tokenAddress) public onlyOwner {
57         uint256 balance = IERC20(_tokenAddress).balanceOf(address(this));
58         IERC20(_tokenAddress).transfer(msg.sender, balance);
59     }
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      * Internal function without access restriction.
72      */
73     function _transferOwnership(address newOwner) internal virtual {
74         address oldOwner = _owner;
75         _owner = newOwner;
76         emit OwnershipTransferred(oldOwner, newOwner);
77     }
78 }
79 
80 
81 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
82 
83 
84 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Interface of the ERC20 standard as defined in the EIP.
90  */
91 interface IERC20 {
92     /**
93      * @dev Returns the amount of tokens in existence.
94      */
95     function totalSupply() external view returns (uint256);
96 
97     /**
98      * @dev Returns the amount of tokens owned by `account`.
99      */
100     function balanceOf(address account) external view returns (uint256);
101 
102     /**
103      * @dev Moves `amount` tokens from the caller's account to `recipient`.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transfer(address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Returns the remaining number of tokens that `spender` will be
113      * allowed to spend on behalf of `owner` through {transferFrom}. This is
114      * zero by default.
115      *
116      * This value changes when {approve} or {transferFrom} are called.
117      */
118     function allowance(address owner, address spender) external view returns (uint256);
119 
120 
121     function approve(address spender, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Moves `amount` tokens from `sender` to `recipient` using the
125      * allowance mechanism. `amount` is then deducted from the caller's
126      * allowance.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transferFrom(
133         address sender,
134         address recipient,
135         uint256 amount
136     ) external returns (bool);
137 
138     /**
139      * @dev Emitted when `value` tokens are moved from one account (`from`) to
140      * another (`to`).
141      *
142      * Note that `value` may be zero.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 
146     /**
147      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
148      * a call to {approve}. `value` is the new allowance.
149      */
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 
154 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
155 
156 
157 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 /**
162  * @dev Interface for the optional metadata functions from the ERC20 standard.
163  *
164  * _Available since v4.1._
165  */
166 interface IERC20Metadata is IERC20 {
167     /**
168      * @dev Returns the name of the token.
169      */
170     function name() external view returns (string memory);
171 
172     /**
173      * @dev Returns the symbol of the token.
174      */
175     function symbol() external view returns (string memory);
176 
177     /**
178      * @dev Returns the decimals places of the token.
179      */
180     function decimals() external view returns (uint8);
181 }
182 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
183 
184 
185 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 
190 
191 
192 contract ERC20 is Context, IERC20, IERC20Metadata {
193     mapping(address => uint256) private _balances;
194 
195     mapping(address => mapping(address => uint256)) private _allowances;
196 
197     uint256 private _totalSupply;
198 
199     string private _name;
200     string private _symbol;
201 
202 
203     constructor(string memory name_, string memory symbol_) {
204         _name = name_;
205         _symbol = symbol_;
206     }
207 
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() public view virtual override returns (string memory) {
212         return _name;
213     }
214 
215     /**
216      * @dev Returns the symbol of the token, usually a shorter version of the
217      * name.
218      */
219     function symbol() public view virtual override returns (string memory) {
220         return _symbol;
221     }
222 
223     function decimals() public view virtual override returns (uint8) {
224         return 18;
225     }
226 
227     /**
228      * @dev See {IERC20-totalSupply}.
229      */
230     function totalSupply() public view virtual override returns (uint256) {
231         return _totalSupply;
232     }
233 
234     /**
235      * @dev See {IERC20-balanceOf}.
236      */
237     function balanceOf(address account) public view virtual override returns (uint256) {
238         return _balances[account];
239     }
240 
241     /**
242      * @dev See {IERC20-transfer}.
243      *
244      * Requirements:
245      *
246      * - `recipient` cannot be the zero address.
247      * - the caller must have a balance of at least `amount`.
248      */
249     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
250         _transfer(_msgSender(), recipient, amount);
251         return true;
252     }
253 
254     /**
255      * @dev See {IERC20-allowance}.
256      */
257     function allowance(address owner, address spender) public view virtual override returns (uint256) {
258         return _allowances[owner][spender];
259     }
260 
261     /**
262      * @dev See {IERC20-approve}.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      */
268     function approve(address spender, uint256 amount) public virtual override returns (bool) {
269         _approve(_msgSender(), spender, amount);
270         return true;
271     }
272   
273 
274     function transferFrom(
275         address sender,
276         address recipient,
277         uint256 amount
278     ) public virtual override returns (bool) {
279         _transfer(sender, recipient, amount);
280 
281         uint256 currentAllowance = _allowances[sender][_msgSender()];
282         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
283         unchecked {
284             _approve(sender, _msgSender(), currentAllowance - amount);
285         }
286 
287         return true;
288     }
289 
290 
291     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
292         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
293         return true;
294     }
295 
296 
297     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
298         uint256 currentAllowance = _allowances[_msgSender()][spender];
299         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
300         unchecked {
301             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
302         }
303 
304         return true;
305     }
306 
307     function _transfer(
308         address sender,
309         address recipient,
310         uint256 amount
311     ) internal virtual {
312         require(sender != address(0), "ERC20: transfer from the zero address");
313         require(recipient != address(0), "ERC20: transfer to the zero address");
314 
315         _beforeTokenTransfer(sender, recipient, amount);
316 
317         uint256 senderBalance = _balances[sender];
318         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
319         unchecked {
320             _balances[sender] = senderBalance - amount;
321         }
322         _balances[recipient] += amount;
323 
324         emit Transfer(sender, recipient, amount);
325 
326         _afterTokenTransfer(sender, recipient, amount);
327     }
328 
329     function _mint(address account, uint256 amount) internal virtual {
330         require(account != address(0), "ERC20: mint to the zero address");
331 
332         _beforeTokenTransfer(address(0), account, amount);
333 
334         _totalSupply += amount;
335         _balances[account] += amount;
336         emit Transfer(address(0), account, amount);
337 
338         _afterTokenTransfer(address(0), account, amount);
339     }
340 
341 
342     function _burn(address account, uint256 amount) internal virtual {
343         require(account != address(0), "ERC20: burn from the zero address");
344 
345         _beforeTokenTransfer(account, address(0), amount);
346 
347         uint256 accountBalance = _balances[account];
348         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
349         unchecked {
350             _balances[account] = accountBalance - amount;
351         }
352         _totalSupply -= amount;
353 
354         emit Transfer(account, address(0), amount);
355 
356         _afterTokenTransfer(account, address(0), amount);
357     }
358 
359 
360     function _approve(
361         address owner,
362         address spender,
363         uint256 amount
364     ) internal virtual {
365         require(owner != address(0), "ERC20: approve from the zero address");
366         require(spender != address(0), "ERC20: approve to the zero address");
367 
368         _allowances[owner][spender] = amount;
369         emit Approval(owner, spender, amount);
370     }
371 
372     function _beforeTokenTransfer(
373         address from,
374         address to,
375         uint256 amount
376     ) internal virtual {}
377 
378 
379     function _afterTokenTransfer(
380         address from,
381         address to,
382         uint256 amount
383     ) internal virtual {}
384 }
385 
386 
387 pragma solidity ^0.8.0;
388 
389 
390 contract CryptoVillains is Ownable, ERC20 {
391   
392     address public uniswapV2Pair;
393  
394     constructor(uint256 _totalSupply) ERC20("Crypto Villains", "CV") {
395         _mint(msg.sender, _totalSupply);
396     }
397 
398     function setUniswapV2pair( address _uniswapV2Pair) external onlyOwner {
399        
400         uniswapV2Pair = _uniswapV2Pair;
401        
402     }
403 }