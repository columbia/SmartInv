1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 /**
7  * @dev Implementation of the {IERC20} interface.
8  *
9  * This implementation is agnostic to the way tokens are created. This means
10  * that a supply mechanism has to be added in a derived contract using {_mint}.
11  * For a generic mechanism see {ERC20PresetMinterPauser}.
12  *
13  * TIP: For a detailed writeup see our guide
14  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
15  * to implement supply mechanisms].
16  *
17  * We have followed general OpenZeppelin guidelines: functions revert instead
18  * of returning `false` on failure. This behavior is nonetheless conventional
19  * and does not conflict with the expectations of ERC20 applications.
20  *
21  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
22  * This allows applications to reconstruct the allowance for all accounts just
23  * by listening to said events. Other implementations of the EIP may not emit
24  * these events, as it isn't required by the specification.
25  *
26  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
27  * functions have been added to mitigate the well-known issues around setting
28  * allowances. See {IERC20-approve}.
29  */
30 
31  interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
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
120 abstract contract Context {
121     function _msgSender() internal view virtual returns (address) {
122         return msg.sender;
123     }
124 
125     function _msgData() internal view virtual returns (bytes calldata) {
126         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
127         return msg.data;
128     }
129 }
130 
131 
132 contract ERC20 is Context, IERC20, IERC20Metadata {
133     mapping (address => uint256) private _balances;
134 
135     mapping (address => mapping (address => uint256)) private _allowances;
136 
137     uint256 private _totalSupply;
138 
139     string private _name;
140     string private _symbol;
141 
142     /**
143      * @dev Sets the values for {name} and {symbol}.
144      *
145      * The defaut value of {decimals} is 18. To select a different value for
146      * {decimals} you should overload it.
147      *
148      * All three of these values are immutable: they can only be set once during
149      * construction.
150      */
151     constructor () {
152         _name = "Geton Coin";
153         _symbol = "GETON";
154         _mint(_msgSender(), 154200000000000000);
155     }
156 
157     /**
158      * @dev Returns the name of the token.
159      */
160     function name() public view virtual override returns (string memory) {
161         return _name;
162     }
163 
164     /**
165      * @dev Returns the symbol of the token, usually a shorter version of the
166      * name.
167      */
168     function symbol() public view virtual override returns (string memory) {
169         return _symbol;
170     }
171 
172     /**
173      * @dev Returns the number of decimals used to get its user representation.
174      * For example, if `decimals` equals `2`, a balance of `505` tokens should
175      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
176      *
177      * Tokens usually opt for a value of 18, imitating the relationship between
178      * Ether and Wei. This is the value {ERC20} uses, unless this function is
179      * overloaded;
180      *
181      * NOTE: This information is only used for _display_ purposes: it in
182      * no way affects any of the arithmetic of the contract, including
183      * {IERC20-balanceOf} and {IERC20-transfer}.
184      */
185     function decimals() public view virtual override returns (uint8) {
186         return 8;
187     }
188 
189     /**
190      * @dev See {IERC20-totalSupply}.
191      */
192     function totalSupply() public view virtual override returns (uint256) {
193         return _totalSupply;
194     }
195 
196     /**
197      * @dev See {IERC20-balanceOf}.
198      */
199     function balanceOf(address account) public view virtual override returns (uint256) {
200         return _balances[account];
201     }
202 
203     /**
204      * @dev See {IERC20-transfer}.
205      *
206      * Requirements:
207      *
208      * - `recipient` cannot be the zero address.
209      * - the caller must have a balance of at least `amount`.
210      */
211     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
212         _transfer(_msgSender(), recipient, amount);
213         return true;
214     }
215 
216     /**
217      * @dev See {IERC20-allowance}.
218      */
219     function allowance(address owner, address spender) public view virtual override returns (uint256) {
220         return _allowances[owner][spender];
221     }
222 
223     /**
224      * @dev See {IERC20-approve}.
225      *
226      * Requirements:
227      *
228      * - `spender` cannot be the zero address.
229      */
230     function approve(address spender, uint256 amount) public virtual override returns (bool) {
231         _approve(_msgSender(), spender, amount);
232         return true;
233     }
234 
235     /**
236      * @dev See {IERC20-transferFrom}.
237      *
238      * Emits an {Approval} event indicating the updated allowance. This is not
239      * required by the EIP. See the note at the beginning of {ERC20}.
240      *
241      * Requirements:
242      *
243      * - `sender` and `recipient` cannot be the zero address.
244      * - `sender` must have a balance of at least `amount`.
245      * - the caller must have allowance for ``sender``'s tokens of at least
246      * `amount`.
247      */
248     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
249         _transfer(sender, recipient, amount);
250 
251         uint256 currentAllowance = _allowances[sender][_msgSender()];
252         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
253         _approve(sender, _msgSender(), currentAllowance - amount);
254 
255         return true;
256     }
257 
258     /**
259      * @dev Atomically increases the allowance granted to `spender` by the caller.
260      *
261      * This is an alternative to {approve} that can be used as a mitigation for
262      * problems described in {IERC20-approve}.
263      *
264      * Emits an {Approval} event indicating the updated allowance.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
271         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
272         return true;
273     }
274 
275     /**
276      * @dev Atomically decreases the allowance granted to `spender` by the caller.
277      *
278      * This is an alternative to {approve} that can be used as a mitigation for
279      * problems described in {IERC20-approve}.
280      *
281      * Emits an {Approval} event indicating the updated allowance.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      * - `spender` must have allowance for the caller of at least
287      * `subtractedValue`.
288      */
289     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
290         uint256 currentAllowance = _allowances[_msgSender()][spender];
291         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
292         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
293 
294         return true;
295     }
296 
297     /**
298      * @dev Moves tokens `amount` from `sender` to `recipient`.
299      *
300      * This is internal function is equivalent to {transfer}, and can be used to
301      * e.g. implement automatic token fees, slashing mechanisms, etc.
302      *
303      * Emits a {Transfer} event.
304      *
305      * Requirements:
306      *
307      * - `sender` cannot be the zero address.
308      * - `recipient` cannot be the zero address.
309      * - `sender` must have a balance of at least `amount`.
310      */
311     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
312         require(sender != address(0), "ERC20: transfer from the zero address");
313         require(recipient != address(0), "ERC20: transfer to the zero address");
314 
315         _beforeTokenTransfer(sender, recipient, amount);
316 
317         uint256 senderBalance = _balances[sender];
318         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
319         _balances[sender] = senderBalance - amount;
320         _balances[recipient] += amount;
321 
322         emit Transfer(sender, recipient, amount);
323     }
324 
325     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
326      * the total supply.
327      *
328      * Emits a {Transfer} event with `from` set to the zero address.
329      *
330      * Requirements:
331      *
332      * - `to` cannot be the zero address.
333      */
334     function _mint(address account, uint256 amount) internal virtual {
335         require(account != address(0), "ERC20: mint to the zero address");
336 
337         _beforeTokenTransfer(address(0), account, amount);
338 
339         _totalSupply += amount;
340         _balances[account] += amount;
341         emit Transfer(address(0), account, amount);
342     }
343 
344     /**
345      * @dev Destroys `amount` tokens from `account`, reducing the
346      * total supply.
347      *
348      * Emits a {Transfer} event with `to` set to the zero address.
349      *
350      * Requirements:
351      *
352      * - `account` cannot be the zero address.
353      * - `account` must have at least `amount` tokens.
354      */
355     function _burn(address account, uint256 amount) internal virtual {
356         require(account != address(0), "ERC20: burn from the zero address");
357 
358         _beforeTokenTransfer(account, address(0), amount);
359 
360         uint256 accountBalance = _balances[account];
361         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
362         _balances[account] = accountBalance - amount;
363         _totalSupply -= amount;
364 
365         emit Transfer(account, address(0), amount);
366     }
367 
368     /**
369      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
370      *
371      * This internal function is equivalent to `approve`, and can be used to
372      * e.g. set automatic allowances for certain subsystems, etc.
373      *
374      * Emits an {Approval} event.
375      *
376      * Requirements:
377      *
378      * - `owner` cannot be the zero address.
379      * - `spender` cannot be the zero address.
380      */
381     function _approve(address owner, address spender, uint256 amount) internal virtual {
382         require(owner != address(0), "ERC20: approve from the zero address");
383         require(spender != address(0), "ERC20: approve to the zero address");
384 
385         _allowances[owner][spender] = amount;
386         emit Approval(owner, spender, amount);
387     }
388 
389     /**
390      * @dev Hook that is called before any transfer of tokens. This includes
391      * minting and burning.
392      *
393      * Calling conditions:
394      *
395      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
396      * will be to transferred to `to`.
397      * - when `from` is zero, `amount` tokens will be minted for `to`.
398      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
399      * - `from` and `to` are never both zero.
400      *
401      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
402      */
403     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
404 }