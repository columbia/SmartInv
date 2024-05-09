1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 
7 pragma solidity ^0.8.0;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
20 
21 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Emitted when `value` tokens are moved from one account (`from`) to
31      * another (`to`).
32      *
33      * Note that `value` may be zero.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     /**
38      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
39      * a call to {approve}. `value` is the new allowance.
40      */
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 
43     /**
44      * @dev Returns the amount of tokens in existence.
45      */
46     function totalSupply() external view returns (uint256);
47 
48     /**
49      * @dev Returns the amount of tokens owned by `account`.
50      */
51     function balanceOf(address account) external view returns (uint256);
52 
53     /**
54      * @dev Moves `amount` tokens from the caller's account to `to`.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transfer(address to, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Returns the remaining number of tokens that `spender` will be
64      * allowed to spend on behalf of `owner` through {transferFrom}. This is
65      * zero by default.
66      *
67      * This value changes when {approve} or {transferFrom} are called.
68      */
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71  
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `from` to `to` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address from,
85         address to,
86         uint256 amount
87     ) external returns (bool);
88 }
89 
90 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
91 
92 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Interface for the optional metadata functions from the ERC20 standard.
98  *
99  * _Available since v4.1._
100  */
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
119 
120 
121 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 
126 contract ERC20 is Context, IERC20, IERC20Metadata {
127     mapping(address => uint256) private _balances;
128 
129     mapping(address => mapping(address => uint256)) private _allowances;
130 
131     uint256 private _totalSupply;
132 
133 
134     string private _name;
135     string private _symbol;
136 
137     /**
138      * @dev Sets the values for {name} and {symbol}.
139      *
140      * The default value of {decimals} is 18. To select a different value for
141      * {decimals} you should overload it.
142      *
143      * All two of these values are immutable: they can only be set once during
144      * construction.
145      */
146     constructor(string memory name_, string memory symbol_) {
147         _name = name_;
148         _symbol = symbol_;
149     }
150 
151     /**
152      * @dev Returns the name of the token.
153      */
154     function name() public view virtual override returns (string memory) {
155         return _name;
156     }
157 
158     /**
159      * @dev Returns the symbol of the token, usually a shorter version of the
160      * name.
161      */
162     function symbol() public view virtual override returns (string memory) {
163         return _symbol;
164     }
165 
166   
167     function decimals() public view virtual override returns (uint8) {
168         return 18;
169     }
170 
171     /**
172      * @dev See {IERC20-totalSupply}.
173      */
174     function totalSupply() public view virtual override returns (uint256) {
175         return _totalSupply;
176     }
177 
178     /**
179      * @dev See {IERC20-balanceOf}.
180      */
181     function balanceOf(address account) public view virtual override returns (uint256) {
182         return _balances[account];
183     }
184 
185     /**
186      * @dev See {IERC20-transfer}.
187      *
188      * Requirements:
189      *
190      * - `to` cannot be the zero address.
191      * - the caller must have a balance of at least `amount`.
192      */
193     function transfer(address to, uint256 amount) public virtual override returns (bool) {
194         address owner = _msgSender();
195         _transfer(owner, to, amount);
196         
197         return true;
198     }
199 
200     /**
201      * @dev See {IERC20-allowance}.
202      */
203     function allowance(address owner, address spender) public view virtual override returns (uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     /**
208      * @dev See {IERC20-approve}.
209      *
210      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
211      * `transferFrom`. This is semantically equivalent to an infinite approval.
212      *
213      * Requirements:
214      *
215      * - `spender` cannot be the zero address.
216      */
217     function approve(address spender, uint256 amount) public virtual override returns (bool) {
218         address owner = _msgSender();
219         _approve(owner, spender, amount);
220         return true;
221     }
222 
223     function transferFrom(
224         address from,
225         address to,
226         uint256 amount
227         
228     ) public virtual override returns (bool) {
229         
230         address spender = _msgSender();
231         _spendAllowance(from, spender, amount);
232         _transfer(from, to, amount);
233         return true;
234     }
235 
236     
237     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
238         address owner = _msgSender();
239         _approve(owner, spender, allowance(owner, spender) + addedValue);
240         return true;
241     }
242 
243     
244     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
245         address owner = _msgSender();
246         uint256 currentAllowance = allowance(owner, spender);
247         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
248         unchecked {
249             _approve(owner, spender, currentAllowance - subtractedValue);
250         }
251 
252         return true;
253     }
254 
255     /**
256      * @dev Moves `amount` of tokens from `from` to `to`.
257      *
258      * This internal function is equivalent to {transfer}, and can be used to
259      * e.g. implement automatic token fees, slashing mechanisms, etc.
260      *
261      * Emits a {Transfer} event.
262      *
263      * Requirements:
264      *
265      * - `from` cannot be the zero address.
266      * - `to` cannot be the zero address.
267      * - `from` must have a balance of at least `amount`.
268      */
269     function _transfer(
270         address from,
271         address to,
272         uint256 amount
273     ) internal virtual {
274         require(from != address(0), "ERC20: transfer from the zero address");
275         require(to != address(0), "ERC20: transfer to the zero address");
276         
277         _beforeTokenTransfer(from, to, amount);
278 
279         uint256 fromBalance = _balances[from];
280         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
281         unchecked {
282             _balances[from] = fromBalance - amount;
283             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
284             // decrementing then incrementing.
285             _balances[to] += amount;
286         }
287 
288         emit Transfer(from, to, amount);
289 
290         _afterTokenTransfer(from, to, amount);
291     }
292 
293     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
294      * the total supply.
295      *
296      * Emits a {Transfer} event with `from` set to the zero address.
297      *
298      * Requirements:
299      *
300      * - `account` cannot be the zero address.
301      */
302     function _mint(address account, uint256 amount) internal virtual {
303         require(account != address(0), "ERC20: mint to the zero address");
304 
305         _beforeTokenTransfer(address(0), account, amount);
306 
307         _totalSupply += amount;
308         unchecked {
309             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
310             _balances[account] += amount;
311         }
312         emit Transfer(address(0), account, amount);
313 
314         _afterTokenTransfer(address(0), account, amount);
315     }
316 
317     /**
318      * @dev Destroys `amount` tokens from `account`, reducing the
319      * total supply.
320      *
321      * Emits a {Transfer} event with `to` set to the zero address.
322      *
323      * Requirements:
324      *
325      * - `account` cannot be the zero address.
326      * - `account` must have at least `amount` tokens.
327      */
328     function _burn(address account, uint256 amount) internal virtual {
329         require(account != address(0), "ERC20: burn from the zero address");
330 
331         _beforeTokenTransfer(account, address(0), amount);
332 
333         uint256 accountBalance = _balances[account];
334         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
335         unchecked {
336             _balances[account] = accountBalance - amount;
337             // Overflow not possible: amount <= accountBalance <= totalSupply.
338             _totalSupply -= amount;
339         }
340 
341         emit Transfer(account, address(0), amount);
342 
343         _afterTokenTransfer(account, address(0), amount);
344     }
345 
346     function _approve(
347         address owner,
348         address spender,
349         uint256 amount
350     ) internal virtual {
351         require(owner != address(0), "ERC20: approve from the zero address");
352         require(spender != address(0), "ERC20: approve to the zero address");
353 
354         _allowances[owner][spender] = amount;
355         emit Approval(owner, spender, amount);
356     }
357 
358     /**
359      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
360      *
361      * Does not update the allowance amount in case of infinite allowance.
362      * Revert if not enough allowance is available.
363      *
364      * Might emit an {Approval} event.
365      */
366     function _spendAllowance(
367         address owner,
368         address spender,
369         uint256 amount
370     ) internal virtual {
371         uint256 currentAllowance = allowance(owner, spender);
372         if (currentAllowance != type(uint256).max) {
373             require(currentAllowance >= amount, "ERC20: insufficient allowance");
374             unchecked {
375                 _approve(owner, spender, currentAllowance - amount);
376             }
377         }
378     }
379 
380     function _beforeTokenTransfer(
381         address from,
382         address to,
383         uint256 amount
384     ) internal virtual {}
385 
386    
387     function _afterTokenTransfer(
388         address from,
389         address to,
390         uint256 amount
391     ) internal virtual {}
392 }
393 
394 pragma solidity ^0.8.9;
395 
396 contract Token is ERC20 {
397     constructor() ERC20("Enigma", "ENIGMA") {
398         _mint(msg.sender, 1000000000 * 10 ** decimals());
399     }
400 }