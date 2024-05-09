1 pragma solidity ^0.8.1;
2 
3 // SPDX-License-Identifier: MIT
4 
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 interface IERC20Metadata is IERC20 {
77     /**
78      * @dev Returns the name of the token.
79      */
80     function name() external view returns (string memory);
81 
82     /**
83      * @dev Returns the symbol of the token.
84      */
85     function symbol() external view returns (string memory);
86 
87     /**
88      * @dev Returns the decimals places of the token.
89      */
90     function decimals() external view returns (uint8);
91 }
92 
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
100         return msg.data;
101     }
102 }
103 
104 contract ERC20 is Context, IERC20, IERC20Metadata {
105     mapping (address => uint256) private _balances;
106 
107     mapping (address => mapping (address => uint256)) private _allowances;
108 
109     uint256 private _totalSupply;
110 
111     string private _name;
112     string private _symbol;
113 
114     /**
115      * @dev Sets the values for {name} and {symbol}.
116      *
117      * The defaut value of {decimals} is 18. To select a different value for
118      * {decimals} you should overload it.
119      *
120      * All two of these values are immutable: they can only be set once during
121      * construction.
122      */
123     constructor (string memory name_, string memory symbol_) {
124         _name = name_;
125         _symbol = symbol_;
126     }
127 
128     /**
129      * @dev Returns the name of the token.
130      */
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135     /**
136      * @dev Returns the symbol of the token, usually a shorter version of the
137      * name.
138      */
139     function symbol() public view virtual override returns (string memory) {
140         return _symbol;
141     }
142 
143     /**
144      * @dev Returns the number of decimals used to get its user representation.
145      * For example, if `decimals` equals `2`, a balance of `505` tokens should
146      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
147      *
148      * Tokens usually opt for a value of 18, imitating the relationship between
149      * Ether and Wei. This is the value {ERC20} uses, unless this function is
150      * overloaded;
151      *
152      * NOTE: This information is only used for _display_ purposes: it in
153      * no way affects any of the arithmetic of the contract, including
154      * {IERC20-balanceOf} and {IERC20-transfer}.
155      */
156     function decimals() public view virtual override returns (uint8) {
157         return 18;
158     }
159 
160     /**
161      * @dev See {IERC20-totalSupply}.
162      */
163     function totalSupply() public view virtual override returns (uint256) {
164         return _totalSupply;
165     }
166 
167     /**
168      * @dev See {IERC20-balanceOf}.
169      */
170     function balanceOf(address account) public view virtual override returns (uint256) {
171         return _balances[account];
172     }
173 
174     /**
175      * @dev See {IERC20-transfer}.
176      *
177      * Requirements:
178      *
179      * - `recipient` cannot be the zero address.
180      * - the caller must have a balance of at least `amount`.
181      */
182     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     /**
188      * @dev See {IERC20-allowance}.
189      */
190     function allowance(address owner, address spender) public view virtual override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     /**
195      * @dev See {IERC20-approve}.
196      *
197      * Requirements:
198      *
199      * - `spender` cannot be the zero address.
200      */
201     function approve(address spender, uint256 amount) public virtual override returns (bool) {
202         _approve(_msgSender(), spender, amount);
203         return true;
204     }
205 
206     /**
207      * @dev See {IERC20-transferFrom}.
208      *
209      * Emits an {Approval} event indicating the updated allowance. This is not
210      * required by the EIP. See the note at the beginning of {ERC20}.
211      *
212      * Requirements:
213      *
214      * - `sender` and `recipient` cannot be the zero address.
215      * - `sender` must have a balance of at least `amount`.
216      * - the caller must have allowance for ``sender``'s tokens of at least
217      * `amount`.
218      */
219     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
220         _transfer(sender, recipient, amount);
221 
222         uint256 currentAllowance = _allowances[sender][_msgSender()];
223         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
224         _approve(sender, _msgSender(), currentAllowance - amount);
225 
226         return true;
227     }
228 
229     /**
230      * @dev Atomically increases the allowance granted to `spender` by the caller.
231      *
232      * This is an alternative to {approve} that can be used as a mitigation for
233      * problems described in {IERC20-approve}.
234      *
235      * Emits an {Approval} event indicating the updated allowance.
236      *
237      * Requirements:
238      *
239      * - `spender` cannot be the zero address.
240      */
241     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
242         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
243         return true;
244     }
245 
246     /**
247      * @dev Atomically decreases the allowance granted to `spender` by the caller.
248      *
249      * This is an alternative to {approve} that can be used as a mitigation for
250      * problems described in {IERC20-approve}.
251      *
252      * Emits an {Approval} event indicating the updated allowance.
253      *
254      * Requirements:
255      *
256      * - `spender` cannot be the zero address.
257      * - `spender` must have allowance for the caller of at least
258      * `subtractedValue`.
259      */
260     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
261         uint256 currentAllowance = _allowances[_msgSender()][spender];
262         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
263         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
264 
265         return true;
266     }
267 
268     /**
269      * @dev Moves tokens `amount` from `sender` to `recipient`.
270      *
271      * This is internal function is equivalent to {transfer}, and can be used to
272      * e.g. implement automatic token fees, slashing mechanisms, etc.
273      *
274      * Emits a {Transfer} event.
275      *
276      * Requirements:
277      *
278      * - `sender` cannot be the zero address.
279      * - `recipient` cannot be the zero address.
280      * - `sender` must have a balance of at least `amount`.
281      */
282     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
283         require(sender != address(0), "ERC20: transfer from the zero address");
284         require(recipient != address(0), "ERC20: transfer to the zero address");
285 
286         _beforeTokenTransfer(sender, recipient, amount);
287 
288         uint256 senderBalance = _balances[sender];
289         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
290         _balances[sender] = senderBalance - amount;
291         _balances[recipient] += amount;
292 
293         emit Transfer(sender, recipient, amount);
294     }
295 
296     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
297      * the total supply.
298      *
299      * Emits a {Transfer} event with `from` set to the zero address.
300      *
301      * Requirements:
302      *
303      * - `to` cannot be the zero address.
304      */
305     function _mint(address account, uint256 amount) internal virtual {
306         require(account != address(0), "ERC20: mint to the zero address");
307 
308         _beforeTokenTransfer(address(0), account, amount);
309 
310         _totalSupply += amount;
311         _balances[account] += amount;
312         emit Transfer(address(0), account, amount);
313     }
314 
315     /**
316      * @dev Destroys `amount` tokens from `account`, reducing the
317      * total supply.
318      *
319      * Emits a {Transfer} event with `to` set to the zero address.
320      *
321      * Requirements:
322      *
323      * - `account` cannot be the zero address.
324      * - `account` must have at least `amount` tokens.
325      */
326     function _burn(address account, uint256 amount) internal virtual {
327         require(account != address(0), "ERC20: burn from the zero address");
328 
329         _beforeTokenTransfer(account, address(0), amount);
330 
331         uint256 accountBalance = _balances[account];
332         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
333         _balances[account] = accountBalance - amount;
334         _totalSupply -= amount;
335 
336         emit Transfer(account, address(0), amount);
337     }
338 
339     /**
340      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
341      *
342      * This internal function is equivalent to `approve`, and can be used to
343      * e.g. set automatic allowances for certain subsystems, etc.
344      *
345      * Emits an {Approval} event.
346      *
347      * Requirements:
348      *
349      * - `owner` cannot be the zero address.
350      * - `spender` cannot be the zero address.
351      */
352     function _approve(address owner, address spender, uint256 amount) internal virtual {
353         require(owner != address(0), "ERC20: approve from the zero address");
354         require(spender != address(0), "ERC20: approve to the zero address");
355 
356         _allowances[owner][spender] = amount;
357         emit Approval(owner, spender, amount);
358     }
359 
360     /**
361      * @dev Hook that is called before any transfer of tokens. This includes
362      * minting and burning.
363      *
364      * Calling conditions:
365      *
366      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
367      * will be to transferred to `to`.
368      * - when `from` is zero, `amount` tokens will be minted for `to`.
369      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
370      * - `from` and `to` are never both zero.
371      *
372      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
373      */
374     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
375 }
376 
377 
378 contract ProjectSenpai is ERC20 {
379     constructor () public ERC20("ProjectSenpai", "SENPAI") {
380         _mint(msg.sender, 21000000 * (10 ** uint256(decimals())));
381     }
382 }