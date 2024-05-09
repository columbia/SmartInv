1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.5;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 interface IERC20Metadata is IERC20 {
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() external view returns (string memory);
91 
92     /**
93      * @dev Returns the symbol of the token.
94      */
95     function symbol() external view returns (string memory);
96 
97     /**
98      * @dev Returns the decimals places of the token.
99      */
100     function decimals() external view returns (uint8);
101 }
102 
103 abstract contract ERC20 is Context, IERC20, IERC20Metadata {
104     mapping (address => uint256) private _balances;
105 
106     mapping (address => mapping (address => uint256)) private _allowances;
107 
108     uint256 private _totalSupply;
109 
110     string private _name;
111     string private _symbol;
112 
113     /**
114      * @dev Sets the values for {name} and {symbol}.
115      *
116      * The defaut value of {decimals} is 18. To select a different value for
117      * {decimals} you should overload it.
118      *
119      * All two of these values are immutable: they can only be set once during
120      * construction.
121      */
122     constructor (string memory name_, string memory symbol_) {
123         _name = name_;
124         _symbol = symbol_;
125     }
126 
127     /**
128      * @dev Returns the name of the token.
129      */
130     function name() public view virtual override returns (string memory) {
131         return _name;
132     }
133 
134     /**
135      * @dev Returns the symbol of the token, usually a shorter version of the
136      * name.
137      */
138     function symbol() public view virtual override returns (string memory) {
139         return _symbol;
140     }
141 
142     /**
143      * @dev Returns the number of decimals used to get its user representation.
144      * For example, if `decimals` equals `2`, a balance of `505` tokens should
145      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
146      *
147      * Tokens usually opt for a value of 18, imitating the relationship between
148      * Ether and Wei. This is the value {ERC20} uses, unless this function is
149      * overridden;
150      *
151      * NOTE: This information is only used for _display_ purposes: it in
152      * no way affects any of the arithmetic of the contract, including
153      * {IERC20-balanceOf} and {IERC20-transfer}.
154      */
155     function decimals() public view virtual override returns (uint8) {
156         return 18;
157     }
158 
159     /**
160      * @dev See {IERC20-totalSupply}.
161      */
162     function totalSupply() public view virtual override returns (uint256) {
163         return _totalSupply;
164     }
165 
166     /**
167      * @dev See {IERC20-balanceOf}.
168      */
169     function balanceOf(address account) public view virtual override returns (uint256) {
170         return _balances[account];
171     }
172 
173     /**
174      * @dev See {IERC20-transfer}.
175      *
176      * Requirements:
177      *
178      * - `recipient` cannot be the zero address.
179      * - the caller must have a balance of at least `amount`.
180      */
181     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
182         _transfer(_msgSender(), recipient, amount);
183         return true;
184     }
185 
186     /**
187      * @dev See {IERC20-allowance}.
188      */
189     function allowance(address owner, address spender) public view virtual override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     /**
194      * @dev See {IERC20-approve}.
195      *
196      * Requirements:
197      *
198      * - `spender` cannot be the zero address.
199      */
200     function approve(address spender, uint256 amount) public virtual override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     /**
206      * @dev See {IERC20-transferFrom}.
207      *
208      * Emits an {Approval} event indicating the updated allowance. This is not
209      * required by the EIP. See the note at the beginning of {ERC20}.
210      *
211      * Requirements:
212      *
213      * - `sender` and `recipient` cannot be the zero address.
214      * - `sender` must have a balance of at least `amount`.
215      * - the caller must have allowance for ``sender``'s tokens of at least
216      * `amount`.
217      */
218     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
219         _transfer(sender, recipient, amount);
220 
221         uint256 currentAllowance = _allowances[sender][_msgSender()];
222         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
223         _approve(sender, _msgSender(), currentAllowance - amount);
224 
225         return true;
226     }
227 
228     /**
229      * @dev Atomically increases the allowance granted to `spender` by the caller.
230      *
231      * This is an alternative to {approve} that can be used as a mitigation for
232      * problems described in {IERC20-approve}.
233      *
234      * Emits an {Approval} event indicating the updated allowance.
235      *
236      * Requirements:
237      *
238      * - `spender` cannot be the zero address.
239      */
240     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
241         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
242         return true;
243     }
244 
245     /**
246      * @dev Atomically decreases the allowance granted to `spender` by the caller.
247      *
248      * This is an alternative to {approve} that can be used as a mitigation for
249      * problems described in {IERC20-approve}.
250      *
251      * Emits an {Approval} event indicating the updated allowance.
252      *
253      * Requirements:
254      *
255      * - `spender` cannot be the zero address.
256      * - `spender` must have allowance for the caller of at least
257      * `subtractedValue`.
258      */
259     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
260         uint256 currentAllowance = _allowances[_msgSender()][spender];
261         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
262         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
263 
264         return true;
265     }
266 
267     /**
268      * @dev Moves tokens `amount` from `sender` to `recipient`.
269      *
270      * This is internal function is equivalent to {transfer}, and can be used to
271      * e.g. implement automatic token fees, slashing mechanisms, etc.
272      *
273      * Emits a {Transfer} event.
274      *
275      * Requirements:
276      *
277      * - `sender` cannot be the zero address.
278      * - `recipient` cannot be the zero address.
279      * - `sender` must have a balance of at least `amount`.
280      */
281     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
282         require(sender != address(0), "ERC20: transfer from the zero address");
283         require(recipient != address(0), "ERC20: transfer to the zero address");
284 
285         _beforeTokenTransfer(sender, recipient, amount);
286 
287         uint256 senderBalance = _balances[sender];
288         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
289         _balances[sender] = senderBalance - amount;
290         _balances[recipient] += amount;
291 
292         emit Transfer(sender, recipient, amount);
293     }
294 
295     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
296      * the total supply.
297      *
298      * Emits a {Transfer} event with `from` set to the zero address.
299      *
300      * Requirements:
301      *
302      * - `to` cannot be the zero address.
303      */
304     function _mint(address account, uint256 amount) internal virtual {
305         require(account != address(0), "ERC20: mint to the zero address");
306 
307         _beforeTokenTransfer(address(0), account, amount);
308 
309         _totalSupply += amount;
310         _balances[account] += amount;
311         emit Transfer(address(0), account, amount);
312     }
313 
314     /**
315      * @dev Destroys `amount` tokens from `account`, reducing the
316      * total supply.
317      *
318      * Emits a {Transfer} event with `to` set to the zero address.
319      *
320      * Requirements:
321      *
322      * - `account` cannot be the zero address.
323      * - `account` must have at least `amount` tokens.
324      */
325     function _burn(address account, uint256 amount) internal virtual {
326         require(account != address(0), "ERC20: burn from the zero address");
327 
328         _beforeTokenTransfer(account, address(0), amount);
329 
330         uint256 accountBalance = _balances[account];
331         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
332         _balances[account] = accountBalance - amount;
333         _totalSupply -= amount;
334 
335         emit Transfer(account, address(0), amount);
336     }
337 
338     /**
339      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
340      *
341      * This internal function is equivalent to `approve`, and can be used to
342      * e.g. set automatic allowances for certain subsystems, etc.
343      *
344      * Emits an {Approval} event.
345      *
346      * Requirements:
347      *
348      * - `owner` cannot be the zero address.
349      * - `spender` cannot be the zero address.
350      */
351     function _approve(address owner, address spender, uint256 amount) internal virtual {
352         require(owner != address(0), "ERC20: approve from the zero address");
353         require(spender != address(0), "ERC20: approve to the zero address");
354 
355         _allowances[owner][spender] = amount;
356         emit Approval(owner, spender, amount);
357     }
358 
359     /**
360      * @dev Hook that is called before any transfer of tokens. This includes
361      * minting and burning.
362      *
363      * Calling conditions:
364      *
365      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
366      * will be to transferred to `to`.
367      * - when `from` is zero, `amount` tokens will be minted for `to`.
368      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
369      * - `from` and `to` are never both zero.
370      *
371      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
372      */
373     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
374 }
375 
376 
377 contract Vabble is ERC20 {
378     constructor() ERC20("Vabble", "VAB") {
379         _mint(msg.sender, 1456250000 * 10 ** decimals());
380     }
381 }