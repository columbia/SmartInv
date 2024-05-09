1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.0;
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a {Transfer} event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through {transferFrom}. This is
26      * zero by default.
27      *
28      * This value changes when {approve} or {transferFrom} are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * IMPORTANT: Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an {Approval} event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to {approve}. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 interface IERC20Metadata is IERC20 {
74     /**
75      * @dev Returns the name of the token.
76      */
77     function name() external view returns (string memory);
78 
79     /**
80      * @dev Returns the symbol of the token.
81      */
82     function symbol() external view returns (string memory);
83 
84     /**
85      * @dev Returns the decimals places of the token.
86      */
87     function decimals() external view returns (uint8);
88 }
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
96         return msg.data;
97     }
98 }
99 contract ERC20 is Context, IERC20, IERC20Metadata {
100     mapping (address => uint256) private _balances;
101 
102     mapping (address => mapping (address => uint256)) private _allowances;
103 
104     uint256 private _totalSupply;
105 
106     string private _name;
107     string private _symbol;
108 
109     /**
110      * @dev Sets the values for {name} and {symbol}.
111      *
112      * The defaut value of {decimals} is 18. To select a different value for
113      * {decimals} you should overload it.
114      *
115      * All two of these values are immutable: they can only be set once during
116      * construction.
117      */
118     constructor (string memory name_, string memory symbol_) {
119         _name = name_;
120         _symbol = symbol_;
121     }
122 
123     /**
124      * @dev Returns the name of the token.
125      */
126     function name() public view virtual override returns (string memory) {
127         return _name;
128     }
129 
130     /**
131      * @dev Returns the symbol of the token, usually a shorter version of the
132      * name.
133      */
134     function symbol() public view virtual override returns (string memory) {
135         return _symbol;
136     }
137 
138     /**
139      * @dev Returns the number of decimals used to get its user representation.
140      * For example, if `decimals` equals `2`, a balance of `505` tokens should
141      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
142      *
143      * Tokens usually opt for a value of 18, imitating the relationship between
144      * Ether and Wei. This is the value {ERC20} uses, unless this function is
145      * overridden;
146      *
147      * NOTE: This information is only used for _display_ purposes: it in
148      * no way affects any of the arithmetic of the contract, including
149      * {IERC20-balanceOf} and {IERC20-transfer}.
150      */
151     function decimals() public view virtual override returns (uint8) {
152         return 18;
153     }
154 
155     /**
156      * @dev See {IERC20-totalSupply}.
157      */
158     function totalSupply() public view virtual override returns (uint256) {
159         return _totalSupply;
160     }
161 
162     /**
163      * @dev See {IERC20-balanceOf}.
164      */
165     function balanceOf(address account) public view virtual override returns (uint256) {
166         return _balances[account];
167     }
168 
169     /**
170      * @dev See {IERC20-transfer}.
171      *
172      * Requirements:
173      *
174      * - `recipient` cannot be the zero address.
175      * - the caller must have a balance of at least `amount`.
176      */
177     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
178         _transfer(_msgSender(), recipient, amount);
179         return true;
180     }
181 
182     /**
183      * @dev See {IERC20-allowance}.
184      */
185     function allowance(address owner, address spender) public view virtual override returns (uint256) {
186         return _allowances[owner][spender];
187     }
188 
189     /**
190      * @dev See {IERC20-approve}.
191      *
192      * Requirements:
193      *
194      * - `spender` cannot be the zero address.
195      */
196     function approve(address spender, uint256 amount) public virtual override returns (bool) {
197         _approve(_msgSender(), spender, amount);
198         return true;
199     }
200 
201     /**
202      * @dev See {IERC20-transferFrom}.
203      *
204      * Emits an {Approval} event indicating the updated allowance. This is not
205      * required by the EIP. See the note at the beginning of {ERC20}.
206      *
207      * Requirements:
208      *
209      * - `sender` and `recipient` cannot be the zero address.
210      * - `sender` must have a balance of at least `amount`.
211      * - the caller must have allowance for ``sender``'s tokens of at least
212      * `amount`.
213      */
214     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
215         _transfer(sender, recipient, amount);
216 
217         uint256 currentAllowance = _allowances[sender][_msgSender()];
218         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
219         _approve(sender, _msgSender(), currentAllowance - amount);
220 
221         return true;
222     }
223 
224     /**
225      * @dev Atomically increases the allowance granted to `spender` by the caller.
226      *
227      * This is an alternative to {approve} that can be used as a mitigation for
228      * problems described in {IERC20-approve}.
229      *
230      * Emits an {Approval} event indicating the updated allowance.
231      *
232      * Requirements:
233      *
234      * - `spender` cannot be the zero address.
235      */
236     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
237         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
238         return true;
239     }
240 
241     /**
242      * @dev Atomically decreases the allowance granted to `spender` by the caller.
243      *
244      * This is an alternative to {approve} that can be used as a mitigation for
245      * problems described in {IERC20-approve}.
246      *
247      * Emits an {Approval} event indicating the updated allowance.
248      *
249      * Requirements:
250      *
251      * - `spender` cannot be the zero address.
252      * - `spender` must have allowance for the caller of at least
253      * `subtractedValue`.
254      */
255     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
256         uint256 currentAllowance = _allowances[_msgSender()][spender];
257         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
258         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
259 
260         return true;
261     }
262 
263     /**
264      * @dev Moves tokens `amount` from `sender` to `recipient`.
265      *
266      * This is internal function is equivalent to {transfer}, and can be used to
267      * e.g. implement automatic token fees, slashing mechanisms, etc.
268      *
269      * Emits a {Transfer} event.
270      *
271      * Requirements:
272      *
273      * - `sender` cannot be the zero address.
274      * - `recipient` cannot be the zero address.
275      * - `sender` must have a balance of at least `amount`.
276      */
277     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
278         require(sender != address(0), "ERC20: transfer from the zero address");
279         require(recipient != address(0), "ERC20: transfer to the zero address");
280 
281         _beforeTokenTransfer(sender, recipient, amount);
282 
283         uint256 senderBalance = _balances[sender];
284         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
285         _balances[sender] = senderBalance - amount;
286         _balances[recipient] += amount;
287 
288         emit Transfer(sender, recipient, amount);
289     }
290 
291     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
292      * the total supply.
293      *
294      * Emits a {Transfer} event with `from` set to the zero address.
295      *
296      * Requirements:
297      *
298      * - `to` cannot be the zero address.
299      */
300     function _mint(address account, uint256 amount) internal virtual {
301         require(account != address(0), "ERC20: mint to the zero address");
302 
303         _beforeTokenTransfer(address(0), account, amount);
304 
305         _totalSupply += amount;
306         _balances[account] += amount;
307         emit Transfer(address(0), account, amount);
308     }
309 
310     /**
311      * @dev Destroys `amount` tokens from `account`, reducing the
312      * total supply.
313      *
314      * Emits a {Transfer} event with `to` set to the zero address.
315      *
316      * Requirements:
317      *
318      * - `account` cannot be the zero address.
319      * - `account` must have at least `amount` tokens.
320      */
321     function _burn(address account, uint256 amount) internal virtual {
322         require(account != address(0), "ERC20: burn from the zero address");
323 
324         _beforeTokenTransfer(account, address(0), amount);
325 
326         uint256 accountBalance = _balances[account];
327         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
328         _balances[account] = accountBalance - amount;
329         _totalSupply -= amount;
330 
331         emit Transfer(account, address(0), amount);
332     }
333 
334     /**
335      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
336      *
337      * This internal function is equivalent to `approve`, and can be used to
338      * e.g. set automatic allowances for certain subsystems, etc.
339      *
340      * Emits an {Approval} event.
341      *
342      * Requirements:
343      *
344      * - `owner` cannot be the zero address.
345      * - `spender` cannot be the zero address.
346      */
347     function _approve(address owner, address spender, uint256 amount) internal virtual {
348         require(owner != address(0), "ERC20: approve from the zero address");
349         require(spender != address(0), "ERC20: approve to the zero address");
350 
351         _allowances[owner][spender] = amount;
352         emit Approval(owner, spender, amount);
353     }
354 
355     /**
356      * @dev Hook that is called before any transfer of tokens. This includes
357      * minting and burning.
358      *
359      * Calling conditions:
360      *
361      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
362      * will be to transferred to `to`.
363      * - when `from` is zero, `amount` tokens will be minted for `to`.
364      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
365      * - `from` and `to` are never both zero.
366      *
367      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
368      */
369     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
370 }
371 abstract contract ERC20Burnable is Context, ERC20 {
372     /**
373      * @dev Destroys `amount` tokens from the caller.
374      *
375      * See {ERC20-_burn}.
376      */
377     function burn(uint256 amount) public virtual {
378         _burn(_msgSender(), amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
383      * allowance.
384      *
385      * See {ERC20-_burn} and {ERC20-allowance}.
386      *
387      * Requirements:
388      *
389      * - the caller must have allowance for ``accounts``'s tokens of at least
390      * `amount`.
391      */
392     function burnFrom(address account, uint256 amount) public virtual {
393         uint256 currentAllowance = allowance(account, _msgSender());
394         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
395         _approve(account, _msgSender(), currentAllowance - amount);
396         _burn(account, amount);
397     }
398 }
399 contract ERC20PresetFixedSupply is ERC20Burnable {
400     /**
401      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
402      *
403      * See {ERC20-constructor}.
404      */
405     constructor(
406         string memory name,
407         string memory symbol,
408         uint256 initialSupply,
409         address owner
410     ) ERC20(name, symbol) {
411         _mint(owner, initialSupply);
412     }
413 }
414 contract ArtmToken is ERC20PresetFixedSupply{
415     /**
416      * @dev Constructs the Artemis token (ARTM) as a fixed supply token.
417      */
418     constructor(
419         string memory name,
420         string memory symbol,
421         uint256 totalSupply,
422         address owner
423     )
424     ERC20PresetFixedSupply(
425         name,
426         symbol,
427         totalSupply,
428         owner
429     )
430     {}
431 }