1 pragma solidity ^0.8.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 interface IERC20Metadata is IERC20 {
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() external view returns (string memory);
93 
94     /**
95      * @dev Returns the symbol of the token.
96      */
97     function symbol() external view returns (string memory);
98 
99     /**
100      * @dev Returns the decimals places of the token.
101      */
102     function decimals() external view returns (uint8);
103 }
104 
105 contract ERC20 is Context, IERC20, IERC20Metadata {
106     mapping(address => uint256) private _balances;
107 
108     mapping(address => mapping(address => uint256)) private _allowances;
109 
110     uint256 private _totalSupply;
111 
112     string private _name;
113     string private _symbol;
114 
115     /**
116      * @dev Sets the values for {name} and {symbol}.
117      *
118      * The default value of {decimals} is 18. To select a different value for
119      * {decimals} you should overload it.
120      *
121      * All two of these values are immutable: they can only be set once during
122      * construction.
123      */
124     constructor(string memory name_, string memory symbol_) {
125         _name = name_;
126         _symbol = symbol_;
127     }
128 
129     /**
130      * @dev Returns the name of the token.
131      */
132     function name() public view virtual override returns (string memory) {
133         return _name;
134     }
135 
136     /**
137      * @dev Returns the symbol of the token, usually a shorter version of the
138      * name.
139      */
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     /**
145      * @dev Returns the number of decimals used to get its user representation.
146      * For example, if `decimals` equals `2`, a balance of `505` tokens should
147      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
148      *
149      * Tokens usually opt for a value of 18, imitating the relationship between
150      * Ether and Wei. This is the value {ERC20} uses, unless this function is
151      * overridden;
152      *
153      * NOTE: This information is only used for _display_ purposes: it in
154      * no way affects any of the arithmetic of the contract, including
155      * {IERC20-balanceOf} and {IERC20-transfer}.
156      */
157     function decimals() public view virtual override returns (uint8) {
158         return 18;
159     }
160 
161     /**
162      * @dev See {IERC20-totalSupply}.
163      */
164     function totalSupply() public view virtual override returns (uint256) {
165         return _totalSupply;
166     }
167 
168     /**
169      * @dev See {IERC20-balanceOf}.
170      */
171     function balanceOf(address account) public view virtual override returns (uint256) {
172         return _balances[account];
173     }
174 
175     /**
176      * @dev See {IERC20-transfer}.
177      *
178      * Requirements:
179      *
180      * - `recipient` cannot be the zero address.
181      * - the caller must have a balance of at least `amount`.
182      */
183     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     /**
189      * @dev See {IERC20-allowance}.
190      */
191     function allowance(address owner, address spender) public view virtual override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     /**
196      * @dev See {IERC20-approve}.
197      *
198      * Requirements:
199      *
200      * - `spender` cannot be the zero address.
201      */
202     function approve(address spender, uint256 amount) public virtual override returns (bool) {
203         _approve(_msgSender(), spender, amount);
204         return true;
205     }
206 
207     /**
208      * @dev See {IERC20-transferFrom}.
209      *
210      * Emits an {Approval} event indicating the updated allowance. This is not
211      * required by the EIP. See the note at the beginning of {ERC20}.
212      *
213      * Requirements:
214      *
215      * - `sender` and `recipient` cannot be the zero address.
216      * - `sender` must have a balance of at least `amount`.
217      * - the caller must have allowance for ``sender``'s tokens of at least
218      * `amount`.
219      */
220     function transferFrom(
221         address sender,
222         address recipient,
223         uint256 amount
224     ) public virtual override returns (bool) {
225         _transfer(sender, recipient, amount);
226 
227         uint256 currentAllowance = _allowances[sender][_msgSender()];
228         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
229         unchecked {
230             _approve(sender, _msgSender(), currentAllowance - amount);
231         }
232 
233         return true;
234     }
235 
236     /**
237      * @dev Atomically increases the allowance granted to `spender` by the caller.
238      *
239      * This is an alternative to {approve} that can be used as a mitigation for
240      * problems described in {IERC20-approve}.
241      *
242      * Emits an {Approval} event indicating the updated allowance.
243      *
244      * Requirements:
245      *
246      * - `spender` cannot be the zero address.
247      */
248     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
249         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
250         return true;
251     }
252 
253     /**
254      * @dev Atomically decreases the allowance granted to `spender` by the caller.
255      *
256      * This is an alternative to {approve} that can be used as a mitigation for
257      * problems described in {IERC20-approve}.
258      *
259      * Emits an {Approval} event indicating the updated allowance.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      * - `spender` must have allowance for the caller of at least
265      * `subtractedValue`.
266      */
267     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
268         uint256 currentAllowance = _allowances[_msgSender()][spender];
269         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
270         unchecked {
271             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
272         }
273 
274         return true;
275     }
276 
277     /**
278      * @dev Moves `amount` of tokens from `sender` to `recipient`.
279      *
280      * This internal function is equivalent to {transfer}, and can be used to
281      * e.g. implement automatic token fees, slashing mechanisms, etc.
282      *
283      * Emits a {Transfer} event.
284      *
285      * Requirements:
286      *
287      * - `sender` cannot be the zero address.
288      * - `recipient` cannot be the zero address.
289      * - `sender` must have a balance of at least `amount`.
290      */
291     function _transfer(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) internal virtual {
296         require(sender != address(0), "ERC20: transfer from the zero address");
297         require(recipient != address(0), "ERC20: transfer to the zero address");
298 
299         _beforeTokenTransfer(sender, recipient, amount);
300 
301         uint256 senderBalance = _balances[sender];
302         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
303         unchecked {
304             _balances[sender] = senderBalance - amount;
305         }
306         _balances[recipient] += amount;
307 
308         emit Transfer(sender, recipient, amount);
309 
310         _afterTokenTransfer(sender, recipient, amount);
311     }
312 
313     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
314      * the total supply.
315      *
316      * Emits a {Transfer} event with `from` set to the zero address.
317      *
318      * Requirements:
319      *
320      * - `account` cannot be the zero address.
321      */
322     function _mint(address account, uint256 amount) internal virtual {
323         require(account != address(0), "ERC20: mint to the zero address");
324 
325         _beforeTokenTransfer(address(0), account, amount);
326 
327         _totalSupply += amount;
328         _balances[account] += amount;
329         emit Transfer(address(0), account, amount);
330 
331         _afterTokenTransfer(address(0), account, amount);
332     }
333 
334     /**
335      * @dev Destroys `amount` tokens from `account`, reducing the
336      * total supply.
337      *
338      * Emits a {Transfer} event with `to` set to the zero address.
339      *
340      * Requirements:
341      *
342      * - `account` cannot be the zero address.
343      * - `account` must have at least `amount` tokens.
344      */
345     function _burn(address account, uint256 amount) internal virtual {
346         require(account != address(0), "ERC20: burn from the zero address");
347 
348         _beforeTokenTransfer(account, address(0), amount);
349 
350         uint256 accountBalance = _balances[account];
351         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
352         unchecked {
353             _balances[account] = accountBalance - amount;
354         }
355         _totalSupply -= amount;
356 
357         emit Transfer(account, address(0), amount);
358 
359         _afterTokenTransfer(account, address(0), amount);
360     }
361 
362     /**
363      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
364      *
365      * This internal function is equivalent to `approve`, and can be used to
366      * e.g. set automatic allowances for certain subsystems, etc.
367      *
368      * Emits an {Approval} event.
369      *
370      * Requirements:
371      *
372      * - `owner` cannot be the zero address.
373      * - `spender` cannot be the zero address.
374      */
375     function _approve(
376         address owner,
377         address spender,
378         uint256 amount
379     ) internal virtual {
380         require(owner != address(0), "ERC20: approve from the zero address");
381         require(spender != address(0), "ERC20: approve to the zero address");
382 
383         _allowances[owner][spender] = amount;
384         emit Approval(owner, spender, amount);
385     }
386 
387     /**
388      * @dev Hook that is called before any transfer of tokens. This includes
389      * minting and burning.
390      *
391      * Calling conditions:
392      *
393      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
394      * will be transferred to `to`.
395      * - when `from` is zero, `amount` tokens will be minted for `to`.
396      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
397      * - `from` and `to` are never both zero.
398      *
399      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
400      */
401     function _beforeTokenTransfer(
402         address from,
403         address to,
404         uint256 amount
405     ) internal virtual {}
406 
407     /**
408      * @dev Hook that is called after any transfer of tokens. This includes
409      * minting and burning.
410      *
411      * Calling conditions:
412      *
413      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
414      * has been transferred to `to`.
415      * - when `from` is zero, `amount` tokens have been minted for `to`.
416      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
417      * - `from` and `to` are never both zero.
418      *
419      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
420      */
421     function _afterTokenTransfer(
422         address from,
423         address to,
424         uint256 amount
425     ) internal virtual {}
426 }
427 
428 contract MDF is ERC20{
429 
430     constructor(address account, uint256 initSupply) ERC20("MatrixETF DAO Finance", "MDF") public {
431         _mint(account, initSupply);
432     }
433 }