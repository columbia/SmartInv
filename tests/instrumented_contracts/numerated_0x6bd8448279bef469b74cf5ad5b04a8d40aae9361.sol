1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 // https://www.blokchayn.com/
7 
8 pragma solidity ^0.8.0;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
21 
22 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Emitted when `value` tokens are moved from one account (`from`) to
32      * another (`to`).
33      *
34      * Note that `value` may be zero.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     /**
39      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
40      * a call to {approve}. `value` is the new allowance.
41      */
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `to`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address to, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72  
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `from` to `to` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address from,
86         address to,
87         uint256 amount
88     ) external returns (bool);
89 }
90 
91 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
92 
93 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Interface for the optional metadata functions from the ERC20 standard.
99  *
100  * _Available since v4.1._
101  */
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
120 
121 
122 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 
127 contract ERC20 is Context, IERC20, IERC20Metadata {
128     mapping(address => uint256) private _balances;
129 
130     mapping(address => mapping(address => uint256)) private _allowances;
131 
132     uint256 private _totalSupply;
133 
134 
135     string private _name;
136     string private _symbol;
137 
138     /**
139      * @dev Sets the values for {name} and {symbol}.
140      *
141      * The default value of {decimals} is 18. To select a different value for
142      * {decimals} you should overload it.
143      *
144      * All two of these values are immutable: they can only be set once during
145      * construction.
146      */
147     constructor(string memory name_, string memory symbol_) {
148         _name = name_;
149         _symbol = symbol_;
150     }
151 
152     /**
153      * @dev Returns the name of the token.
154      */
155     function name() public view virtual override returns (string memory) {
156         return _name;
157     }
158 
159     /**
160      * @dev Returns the symbol of the token, usually a shorter version of the
161      * name.
162      */
163     function symbol() public view virtual override returns (string memory) {
164         return _symbol;
165     }
166 
167   
168     function decimals() public view virtual override returns (uint8) {
169         return 18;
170     }
171 
172     /**
173      * @dev See {IERC20-totalSupply}.
174      */
175     function totalSupply() public view virtual override returns (uint256) {
176         return _totalSupply;
177     }
178 
179     /**
180      * @dev See {IERC20-balanceOf}.
181      */
182     function balanceOf(address account) public view virtual override returns (uint256) {
183         return _balances[account];
184     }
185 
186     /**
187      * @dev See {IERC20-transfer}.
188      *
189      * Requirements:
190      *
191      * - `to` cannot be the zero address.
192      * - the caller must have a balance of at least `amount`.
193      */
194     function transfer(address to, uint256 amount) public virtual override returns (bool) {
195         address owner = _msgSender();
196         _transfer(owner, to, amount);
197         
198         return true;
199     }
200 
201     /**
202      * @dev See {IERC20-allowance}.
203      */
204     function allowance(address owner, address spender) public view virtual override returns (uint256) {
205         return _allowances[owner][spender];
206     }
207 
208     /**
209      * @dev See {IERC20-approve}.
210      *
211      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
212      * `transferFrom`. This is semantically equivalent to an infinite approval.
213      *
214      * Requirements:
215      *
216      * - `spender` cannot be the zero address.
217      */
218     function approve(address spender, uint256 amount) public virtual override returns (bool) {
219         address owner = _msgSender();
220         _approve(owner, spender, amount);
221         return true;
222     }
223 
224     function transferFrom(
225         address from,
226         address to,
227         uint256 amount
228         
229     ) public virtual override returns (bool) {
230         
231         address spender = _msgSender();
232         _spendAllowance(from, spender, amount);
233         _transfer(from, to, amount);
234         return true;
235     }
236 
237     
238     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
239         address owner = _msgSender();
240         _approve(owner, spender, allowance(owner, spender) + addedValue);
241         return true;
242     }
243 
244     
245     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
246         address owner = _msgSender();
247         uint256 currentAllowance = allowance(owner, spender);
248         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
249         unchecked {
250             _approve(owner, spender, currentAllowance - subtractedValue);
251         }
252 
253         return true;
254     }
255 
256     /**
257      * @dev Moves `amount` of tokens from `from` to `to`.
258      *
259      * This internal function is equivalent to {transfer}, and can be used to
260      * e.g. implement automatic token fees, slashing mechanisms, etc.
261      *
262      * Emits a {Transfer} event.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `from` must have a balance of at least `amount`.
269      */
270     function _transfer(
271         address from,
272         address to,
273         uint256 amount
274     ) internal virtual {
275         require(from != address(0), "ERC20: transfer from the zero address");
276         require(to != address(0), "ERC20: transfer to the zero address");
277         
278         _beforeTokenTransfer(from, to, amount);
279 
280         uint256 fromBalance = _balances[from];
281         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
282         unchecked {
283             _balances[from] = fromBalance - amount;
284             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
285             // decrementing then incrementing.
286             _balances[to] += amount;
287         }
288 
289         emit Transfer(from, to, amount);
290 
291         _afterTokenTransfer(from, to, amount);
292     }
293 
294     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
295      * the total supply.
296      *
297      * Emits a {Transfer} event with `from` set to the zero address.
298      *
299      * Requirements:
300      *
301      * - `account` cannot be the zero address.
302      */
303     function _mint(address account, uint256 amount) internal virtual {
304         require(account != address(0), "ERC20: mint to the zero address");
305 
306         _beforeTokenTransfer(address(0), account, amount);
307 
308         _totalSupply += amount;
309         unchecked {
310             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
311             _balances[account] += amount;
312         }
313         emit Transfer(address(0), account, amount);
314 
315         _afterTokenTransfer(address(0), account, amount);
316     }
317 
318     /**
319      * @dev Destroys `amount` tokens from `account`, reducing the
320      * total supply.
321      *
322      * Emits a {Transfer} event with `to` set to the zero address.
323      *
324      * Requirements:
325      *
326      * - `account` cannot be the zero address.
327      * - `account` must have at least `amount` tokens.
328      */
329     function _burn(address account, uint256 amount) internal virtual {
330         require(account != address(0), "ERC20: burn from the zero address");
331 
332         _beforeTokenTransfer(account, address(0), amount);
333 
334         uint256 accountBalance = _balances[account];
335         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
336         unchecked {
337             _balances[account] = accountBalance - amount;
338             // Overflow not possible: amount <= accountBalance <= totalSupply.
339             _totalSupply -= amount;
340         }
341 
342         emit Transfer(account, address(0), amount);
343 
344         _afterTokenTransfer(account, address(0), amount);
345     }
346 
347     function _approve(
348         address owner,
349         address spender,
350         uint256 amount
351     ) internal virtual {
352         require(owner != address(0), "ERC20: approve from the zero address");
353         require(spender != address(0), "ERC20: approve to the zero address");
354 
355         _allowances[owner][spender] = amount;
356         emit Approval(owner, spender, amount);
357     }
358 
359     /**
360      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
361      *
362      * Does not update the allowance amount in case of infinite allowance.
363      * Revert if not enough allowance is available.
364      *
365      * Might emit an {Approval} event.
366      */
367     function _spendAllowance(
368         address owner,
369         address spender,
370         uint256 amount
371     ) internal virtual {
372         uint256 currentAllowance = allowance(owner, spender);
373         if (currentAllowance != type(uint256).max) {
374             require(currentAllowance >= amount, "ERC20: insufficient allowance");
375             unchecked {
376                 _approve(owner, spender, currentAllowance - amount);
377             }
378         }
379     }
380 
381     function _beforeTokenTransfer(
382         address from,
383         address to,
384         uint256 amount
385     ) internal virtual {}
386 
387    
388     function _afterTokenTransfer(
389         address from,
390         address to,
391         uint256 amount
392     ) internal virtual {}
393 }
394 
395 pragma solidity ^0.8.9;
396 
397 contract Token is ERC20 {
398     constructor() ERC20("Blokchayn", "BLOK") {
399         _mint(msg.sender, 1000000000 * 10 ** decimals());
400     }
401 }