1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 // https://www.noobs-token.com
7 // https://twitter.com/NOOBSERC20
8 
9 pragma solidity ^0.8.0;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
22 
23 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Emitted when `value` tokens are moved from one account (`from`) to
33      * another (`to`).
34      *
35      * Note that `value` may be zero.
36      */
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     /**
40      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
41      * a call to {approve}. `value` is the new allowance.
42      */
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 
45     /**
46      * @dev Returns the amount of tokens in existence.
47      */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `to`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transfer(address to, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through {transferFrom}. This is
67      * zero by default.
68      *
69      * This value changes when {approve} or {transferFrom} are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73  
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `from` to `to` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address from,
87         address to,
88         uint256 amount
89     ) external returns (bool);
90 }
91 
92 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
93 
94 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Interface for the optional metadata functions from the ERC20 standard.
100  *
101  * _Available since v4.1._
102  */
103 interface IERC20Metadata is IERC20 {
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() external view returns (string memory);
108 
109     /**
110      * @dev Returns the symbol of the token.
111      */
112     function symbol() external view returns (string memory);
113 
114     /**
115      * @dev Returns the decimals places of the token.
116      */
117     function decimals() external view returns (uint8);
118 }
119 
120 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
121 
122 
123 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 
128 contract ERC20 is Context, IERC20, IERC20Metadata {
129     mapping(address => uint256) private _balances;
130 
131     mapping(address => mapping(address => uint256)) private _allowances;
132 
133     uint256 private _totalSupply;
134 
135 
136     string private _name;
137     string private _symbol;
138 
139     /**
140      * @dev Sets the values for {name} and {symbol}.
141      *
142      * The default value of {decimals} is 18. To select a different value for
143      * {decimals} you should overload it.
144      *
145      * All two of these values are immutable: they can only be set once during
146      * construction.
147      */
148     constructor(string memory name_, string memory symbol_) {
149         _name = name_;
150         _symbol = symbol_;
151     }
152 
153     /**
154      * @dev Returns the name of the token.
155      */
156     function name() public view virtual override returns (string memory) {
157         return _name;
158     }
159 
160     /**
161      * @dev Returns the symbol of the token, usually a shorter version of the
162      * name.
163      */
164     function symbol() public view virtual override returns (string memory) {
165         return _symbol;
166     }
167 
168   
169     function decimals() public view virtual override returns (uint8) {
170         return 18;
171     }
172 
173     /**
174      * @dev See {IERC20-totalSupply}.
175      */
176     function totalSupply() public view virtual override returns (uint256) {
177         return _totalSupply;
178     }
179 
180     /**
181      * @dev See {IERC20-balanceOf}.
182      */
183     function balanceOf(address account) public view virtual override returns (uint256) {
184         return _balances[account];
185     }
186 
187     /**
188      * @dev See {IERC20-transfer}.
189      *
190      * Requirements:
191      *
192      * - `to` cannot be the zero address.
193      * - the caller must have a balance of at least `amount`.
194      */
195     function transfer(address to, uint256 amount) public virtual override returns (bool) {
196         address owner = _msgSender();
197         _transfer(owner, to, amount);
198         
199         return true;
200     }
201 
202     /**
203      * @dev See {IERC20-allowance}.
204      */
205     function allowance(address owner, address spender) public view virtual override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     /**
210      * @dev See {IERC20-approve}.
211      *
212      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
213      * `transferFrom`. This is semantically equivalent to an infinite approval.
214      *
215      * Requirements:
216      *
217      * - `spender` cannot be the zero address.
218      */
219     function approve(address spender, uint256 amount) public virtual override returns (bool) {
220         address owner = _msgSender();
221         _approve(owner, spender, amount);
222         return true;
223     }
224 
225     function transferFrom(
226         address from,
227         address to,
228         uint256 amount
229         
230     ) public virtual override returns (bool) {
231         
232         address spender = _msgSender();
233         _spendAllowance(from, spender, amount);
234         _transfer(from, to, amount);
235         return true;
236     }
237 
238     
239     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
240         address owner = _msgSender();
241         _approve(owner, spender, allowance(owner, spender) + addedValue);
242         return true;
243     }
244 
245     
246     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
247         address owner = _msgSender();
248         uint256 currentAllowance = allowance(owner, spender);
249         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
250         unchecked {
251             _approve(owner, spender, currentAllowance - subtractedValue);
252         }
253 
254         return true;
255     }
256 
257     /**
258      * @dev Moves `amount` of tokens from `from` to `to`.
259      *
260      * This internal function is equivalent to {transfer}, and can be used to
261      * e.g. implement automatic token fees, slashing mechanisms, etc.
262      *
263      * Emits a {Transfer} event.
264      *
265      * Requirements:
266      *
267      * - `from` cannot be the zero address.
268      * - `to` cannot be the zero address.
269      * - `from` must have a balance of at least `amount`.
270      */
271     function _transfer(
272         address from,
273         address to,
274         uint256 amount
275     ) internal virtual {
276         require(from != address(0), "ERC20: transfer from the zero address");
277         require(to != address(0), "ERC20: transfer to the zero address");
278         
279         _beforeTokenTransfer(from, to, amount);
280 
281         uint256 fromBalance = _balances[from];
282         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
283         unchecked {
284             _balances[from] = fromBalance - amount;
285             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
286             // decrementing then incrementing.
287             _balances[to] += amount;
288         }
289 
290         emit Transfer(from, to, amount);
291 
292         _afterTokenTransfer(from, to, amount);
293     }
294 
295     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
296      * the total supply.
297      *
298      * Emits a {Transfer} event with `from` set to the zero address.
299      *
300      * Requirements:
301      *
302      * - `account` cannot be the zero address.
303      */
304     function _mint(address account, uint256 amount) internal virtual {
305         require(account != address(0), "ERC20: mint to the zero address");
306 
307         _beforeTokenTransfer(address(0), account, amount);
308 
309         _totalSupply += amount;
310         unchecked {
311             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
312             _balances[account] += amount;
313         }
314         emit Transfer(address(0), account, amount);
315 
316         _afterTokenTransfer(address(0), account, amount);
317     }
318 
319     /**
320      * @dev Destroys `amount` tokens from `account`, reducing the
321      * total supply.
322      *
323      * Emits a {Transfer} event with `to` set to the zero address.
324      *
325      * Requirements:
326      *
327      * - `account` cannot be the zero address.
328      * - `account` must have at least `amount` tokens.
329      */
330     function _burn(address account, uint256 amount) internal virtual {
331         require(account != address(0), "ERC20: burn from the zero address");
332 
333         _beforeTokenTransfer(account, address(0), amount);
334 
335         uint256 accountBalance = _balances[account];
336         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
337         unchecked {
338             _balances[account] = accountBalance - amount;
339             // Overflow not possible: amount <= accountBalance <= totalSupply.
340             _totalSupply -= amount;
341         }
342 
343         emit Transfer(account, address(0), amount);
344 
345         _afterTokenTransfer(account, address(0), amount);
346     }
347 
348     function _approve(
349         address owner,
350         address spender,
351         uint256 amount
352     ) internal virtual {
353         require(owner != address(0), "ERC20: approve from the zero address");
354         require(spender != address(0), "ERC20: approve to the zero address");
355 
356         _allowances[owner][spender] = amount;
357         emit Approval(owner, spender, amount);
358     }
359 
360     /**
361      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
362      *
363      * Does not update the allowance amount in case of infinite allowance.
364      * Revert if not enough allowance is available.
365      *
366      * Might emit an {Approval} event.
367      */
368     function _spendAllowance(
369         address owner,
370         address spender,
371         uint256 amount
372     ) internal virtual {
373         uint256 currentAllowance = allowance(owner, spender);
374         if (currentAllowance != type(uint256).max) {
375             require(currentAllowance >= amount, "ERC20: insufficient allowance");
376             unchecked {
377                 _approve(owner, spender, currentAllowance - amount);
378             }
379         }
380     }
381 
382     function _beforeTokenTransfer(
383         address from,
384         address to,
385         uint256 amount
386     ) internal virtual {}
387 
388    
389     function _afterTokenTransfer(
390         address from,
391         address to,
392         uint256 amount
393     ) internal virtual {}
394 }
395 
396 pragma solidity ^0.8.9;
397 
398 contract Token is ERC20 {
399     constructor() ERC20("Noobs", "NOOBS") {
400         _mint(msg.sender, 1000000000 * 10 ** decimals());
401     }
402 }