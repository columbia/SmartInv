1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
16 
17 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Interface of the ERC20 standard as defined in the EIP.
23  */
24 interface IERC20 {
25     /**
26      * @dev Emitted when `value` tokens are moved from one account (`from`) to
27      * another (`to`).
28      *
29      * Note that `value` may be zero.
30      */
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     /**
34      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
35      * a call to {approve}. `value` is the new allowance.
36      */
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `to`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address to, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67  
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
87 
88 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 
122 contract ERC20 is Context, IERC20, IERC20Metadata {
123     mapping(address => uint256) private _balances;
124 
125     mapping(address => mapping(address => uint256)) private _allowances;
126 
127     uint256 private _totalSupply;
128 
129 
130     string private _name;
131     string private _symbol;
132 
133     /**
134      * @dev Sets the values for {name} and {symbol}.
135      *
136      * The default value of {decimals} is 18. To select a different value for
137      * {decimals} you should overload it.
138      *
139      * All two of these values are immutable: they can only be set once during
140      * construction.
141      */
142     constructor(string memory name_, string memory symbol_) {
143         _name = name_;
144         _symbol = symbol_;
145     }
146 
147     /**
148      * @dev Returns the name of the token.
149      */
150     function name() public view virtual override returns (string memory) {
151         return _name;
152     }
153 
154     /**
155      * @dev Returns the symbol of the token, usually a shorter version of the
156      * name.
157      */
158     function symbol() public view virtual override returns (string memory) {
159         return _symbol;
160     }
161 
162   
163     function decimals() public view virtual override returns (uint8) {
164         return 18;
165     }
166 
167     /**
168      * @dev See {IERC20-totalSupply}.
169      */
170     function totalSupply() public view virtual override returns (uint256) {
171         return _totalSupply;
172     }
173 
174     /**
175      * @dev See {IERC20-balanceOf}.
176      */
177     function balanceOf(address account) public view virtual override returns (uint256) {
178         return _balances[account];
179     }
180 
181     /**
182      * @dev See {IERC20-transfer}.
183      *
184      * Requirements:
185      *
186      * - `to` cannot be the zero address.
187      * - the caller must have a balance of at least `amount`.
188      */
189     function transfer(address to, uint256 amount) public virtual override returns (bool) {
190         address owner = _msgSender();
191         _transfer(owner, to, amount);
192         
193         return true;
194     }
195 
196     /**
197      * @dev See {IERC20-allowance}.
198      */
199     function allowance(address owner, address spender) public view virtual override returns (uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     /**
204      * @dev See {IERC20-approve}.
205      *
206      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
207      * `transferFrom`. This is semantically equivalent to an infinite approval.
208      *
209      * Requirements:
210      *
211      * - `spender` cannot be the zero address.
212      */
213     function approve(address spender, uint256 amount) public virtual override returns (bool) {
214         address owner = _msgSender();
215         _approve(owner, spender, amount);
216         return true;
217     }
218 
219     function transferFrom(
220         address from,
221         address to,
222         uint256 amount
223         
224     ) public virtual override returns (bool) {
225         
226         address spender = _msgSender();
227         _spendAllowance(from, spender, amount);
228         _transfer(from, to, amount);
229         return true;
230     }
231 
232     
233     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
234         address owner = _msgSender();
235         _approve(owner, spender, allowance(owner, spender) + addedValue);
236         return true;
237     }
238 
239     
240     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
241         address owner = _msgSender();
242         uint256 currentAllowance = allowance(owner, spender);
243         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
244         unchecked {
245             _approve(owner, spender, currentAllowance - subtractedValue);
246         }
247 
248         return true;
249     }
250 
251     /**
252      * @dev Moves `amount` of tokens from `from` to `to`.
253      *
254      * This internal function is equivalent to {transfer}, and can be used to
255      * e.g. implement automatic token fees, slashing mechanisms, etc.
256      *
257      * Emits a {Transfer} event.
258      *
259      * Requirements:
260      *
261      * - `from` cannot be the zero address.
262      * - `to` cannot be the zero address.
263      * - `from` must have a balance of at least `amount`.
264      */
265     function _transfer(
266         address from,
267         address to,
268         uint256 amount
269     ) internal virtual {
270         require(from != address(0), "ERC20: transfer from the zero address");
271         require(to != address(0), "ERC20: transfer to the zero address");
272         
273         _beforeTokenTransfer(from, to, amount);
274 
275         uint256 fromBalance = _balances[from];
276         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
277         unchecked {
278             _balances[from] = fromBalance - amount;
279             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
280             // decrementing then incrementing.
281             _balances[to] += amount;
282         }
283 
284         emit Transfer(from, to, amount);
285 
286         _afterTokenTransfer(from, to, amount);
287     }
288 
289     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
290      * the total supply.
291      *
292      * Emits a {Transfer} event with `from` set to the zero address.
293      *
294      * Requirements:
295      *
296      * - `account` cannot be the zero address.
297      */
298     function _mint(address account, uint256 amount) internal virtual {
299         require(account != address(0), "ERC20: mint to the zero address");
300 
301         _beforeTokenTransfer(address(0), account, amount);
302 
303         _totalSupply += amount;
304         unchecked {
305             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
306             _balances[account] += amount;
307         }
308         emit Transfer(address(0), account, amount);
309 
310         _afterTokenTransfer(address(0), account, amount);
311     }
312 
313     /**
314      * @dev Destroys `amount` tokens from `account`, reducing the
315      * total supply.
316      *
317      * Emits a {Transfer} event with `to` set to the zero address.
318      *
319      * Requirements:
320      *
321      * - `account` cannot be the zero address.
322      * - `account` must have at least `amount` tokens.
323      */
324     function _burn(address account, uint256 amount) internal virtual {
325         require(account != address(0), "ERC20: burn from the zero address");
326 
327         _beforeTokenTransfer(account, address(0), amount);
328 
329         uint256 accountBalance = _balances[account];
330         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
331         unchecked {
332             _balances[account] = accountBalance - amount;
333             // Overflow not possible: amount <= accountBalance <= totalSupply.
334             _totalSupply -= amount;
335         }
336 
337         emit Transfer(account, address(0), amount);
338 
339         _afterTokenTransfer(account, address(0), amount);
340     }
341 
342     function _approve(
343         address owner,
344         address spender,
345         uint256 amount
346     ) internal virtual {
347         require(owner != address(0), "ERC20: approve from the zero address");
348         require(spender != address(0), "ERC20: approve to the zero address");
349 
350         _allowances[owner][spender] = amount;
351         emit Approval(owner, spender, amount);
352     }
353 
354     /**
355      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
356      *
357      * Does not update the allowance amount in case of infinite allowance.
358      * Revert if not enough allowance is available.
359      *
360      * Might emit an {Approval} event.
361      */
362     function _spendAllowance(
363         address owner,
364         address spender,
365         uint256 amount
366     ) internal virtual {
367         uint256 currentAllowance = allowance(owner, spender);
368         if (currentAllowance != type(uint256).max) {
369             require(currentAllowance >= amount, "ERC20: insufficient allowance");
370             unchecked {
371                 _approve(owner, spender, currentAllowance - amount);
372             }
373         }
374     }
375 
376     function _beforeTokenTransfer(
377         address from,
378         address to,
379         uint256 amount
380     ) internal virtual {}
381 
382    
383     function _afterTokenTransfer(
384         address from,
385         address to,
386         uint256 amount
387     ) internal virtual {}
388 }
389 
390 pragma solidity ^0.8.12;
391 
392 
393 contract Trinity is ERC20 {
394     constructor() ERC20("Trinity", "Trinity") {
395 
396         _mint(msg.sender, 10000000000 * 10 ** decimals());
397     }
398 }