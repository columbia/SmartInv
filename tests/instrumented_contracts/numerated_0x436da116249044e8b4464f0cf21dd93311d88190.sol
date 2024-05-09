1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
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
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 interface IERC20Metadata is IERC20 {
91     /**
92      * @dev Returns the name of the token.
93      */
94     function name() external view returns (string memory);
95 
96     /**
97      * @dev Returns the symbol of the token.
98      */
99     function symbol() external view returns (string memory);
100 
101     /**
102      * @dev Returns the decimals places of the token.
103      */
104     function decimals() external view returns (uint8);
105 }
106 
107 
108 /**
109  * @dev Implementation of the {IERC20} interface.
110  *
111  * This implementation is agnostic to the way tokens are created. This means
112  * that a supply mechanism has to be added in a derived contract using {_mint}.
113  * For a generic mechanism see {ERC20PresetMinterPauser}.
114  *
115  * TIP: For a detailed writeup see our guide
116  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
117  * to implement supply mechanisms].
118  *
119  * We have followed general OpenZeppelin guidelines: functions revert instead
120  * of returning `false` on failure. This behavior is nonetheless conventional
121  * and does not conflict with the expectations of ERC20 applications.
122  *
123  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
124  * This allows applications to reconstruct the allowance for all accounts just
125  * by listening to said events. Other implementations of the EIP may not emit
126  * these events, as it isn't required by the specification.
127  *
128  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
129  * functions have been added to mitigate the well-known issues around setting
130  * allowances. See {IERC20-approve}.
131  */
132 contract ERC20 is Context, IERC20, IERC20Metadata {
133     mapping(address => uint256) private _balances;
134 
135     mapping(address => mapping(address => uint256)) private _allowances;
136 
137     uint256 private _totalSupply;
138 
139     string private _name;
140     string private _symbol;
141 
142     /**
143      * @dev Sets the values for {name} and {symbol}.
144      *
145      * The default value of {decimals} is 18. To select a different value for
146      * {decimals} you should overload it.
147      *
148      * All two of these values are immutable: they can only be set once during
149      * construction.
150      */
151     constructor(string memory name_, string memory symbol_) {
152         _name = name_;
153         _symbol = symbol_;
154     }
155 
156     /**
157      * @dev Returns the name of the token.
158      */
159     function name() public view virtual override returns (string memory) {
160         return _name;
161     }
162 
163     /**
164      * @dev Returns the symbol of the token, usually a shorter version of the
165      * name.
166      */
167     function symbol() public view virtual override returns (string memory) {
168         return _symbol;
169     }
170 
171     /**
172      * @dev Returns the number of decimals used to get its user representation.
173      * For example, if `decimals` equals `2`, a balance of `505` tokens should
174      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
175      *
176      * Tokens usually opt for a value of 18, imitating the relationship between
177      * Ether and Wei. This is the value {ERC20} uses, unless this function is
178      * overridden;
179      *
180      * NOTE: This information is only used for _display_ purposes: it in
181      * no way affects any of the arithmetic of the contract, including
182      * {IERC20-balanceOf} and {IERC20-transfer}.
183      */
184     function decimals() public view virtual override returns (uint8) {
185         return 18;
186     }
187 
188     /**
189      * @dev See {IERC20-totalSupply}.
190      */
191     function totalSupply() public view virtual override returns (uint256) {
192         return _totalSupply;
193     }
194 
195     /**
196      * @dev See {IERC20-balanceOf}.
197      */
198     function balanceOf(address account) public view virtual override returns (uint256) {
199         return _balances[account];
200     }
201 
202     /**
203      * @dev See {IERC20-transfer}.
204      *
205      * Requirements:
206      *
207      * - `recipient` cannot be the zero address.
208      * - the caller must have a balance of at least `amount`.
209      */
210     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     /**
216      * @dev See {IERC20-allowance}.
217      */
218     function allowance(address owner, address spender) public view virtual override returns (uint256) {
219         return _allowances[owner][spender];
220     }
221 
222     /**
223      * @dev See {IERC20-approve}.
224      *
225      * Requirements:
226      *
227      * - `spender` cannot be the zero address.
228      */
229     function approve(address spender, uint256 amount) public virtual override returns (bool) {
230         _approve(_msgSender(), spender, amount);
231         return true;
232     }
233 
234     /**
235      * @dev See {IERC20-transferFrom}.
236      *
237      * Emits an {Approval} event indicating the updated allowance. This is not
238      * required by the EIP. See the note at the beginning of {ERC20}.
239      *
240      * Requirements:
241      *
242      * - `sender` and `recipient` cannot be the zero address.
243      * - `sender` must have a balance of at least `amount`.
244      * - the caller must have allowance for ``sender``'s tokens of at least
245      * `amount`.
246      */
247     function transferFrom(
248         address sender,
249         address recipient,
250         uint256 amount
251     ) public virtual override returns (bool) {
252         _transfer(sender, recipient, amount);
253 
254         uint256 currentAllowance = _allowances[sender][_msgSender()];
255         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
256         unchecked {
257             _approve(sender, _msgSender(), currentAllowance - amount);
258         }
259 
260         return true;
261     }
262 
263     /**
264      * @dev Atomically increases the allowance granted to `spender` by the caller.
265      *
266      * This is an alternative to {approve} that can be used as a mitigation for
267      * problems described in {IERC20-approve}.
268      *
269      * Emits an {Approval} event indicating the updated allowance.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
276         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
277         return true;
278     }
279 
280     /**
281      * @dev Atomically decreases the allowance granted to `spender` by the caller.
282      *
283      * This is an alternative to {approve} that can be used as a mitigation for
284      * problems described in {IERC20-approve}.
285      *
286      * Emits an {Approval} event indicating the updated allowance.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      * - `spender` must have allowance for the caller of at least
292      * `subtractedValue`.
293      */
294     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
295         uint256 currentAllowance = _allowances[_msgSender()][spender];
296         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
297         unchecked {
298             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
299         }
300 
301         return true;
302     }
303 
304     /**
305      * @dev Moves `amount` of tokens from `sender` to `recipient`.
306      *
307      * This internal function is equivalent to {transfer}, and can be used to
308      * e.g. implement automatic token fees, slashing mechanisms, etc.
309      *
310      * Emits a {Transfer} event.
311      *
312      * Requirements:
313      *
314      * - `sender` cannot be the zero address.
315      * - `recipient` cannot be the zero address.
316      * - `sender` must have a balance of at least `amount`.
317      */
318     function _transfer(
319         address sender,
320         address recipient,
321         uint256 amount
322     ) internal virtual {
323         require(sender != address(0), "ERC20: transfer from the zero address");
324         // require(recipient != address(0), "ERC20: transfer to the zero address");
325 
326         _beforeTokenTransfer(sender, recipient, amount);
327 
328         uint256 senderBalance = _balances[sender];
329         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
330         unchecked {
331             _balances[sender] = senderBalance - amount;
332         }
333         _balances[recipient] += amount;
334 
335         emit Transfer(sender, recipient, amount);
336     }
337 
338     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
339      * the total supply.
340      *
341      * Emits a {Transfer} event with `from` set to the zero address.
342      *
343      * Requirements:
344      *
345      * - `account` cannot be the zero address.
346      */
347     function _mint(address account, uint256 amount) internal virtual {
348         require(account != address(0), "ERC20: mint to the zero address");
349 
350         _beforeTokenTransfer(address(0), account, amount);
351 
352         _totalSupply += amount;
353         _balances[account] += amount;
354         emit Transfer(address(0), account, amount);
355     }
356 
357     /**
358      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
359      *
360      * This internal function is equivalent to `approve`, and can be used to
361      * e.g. set automatic allowances for certain subsystems, etc.
362      *
363      * Emits an {Approval} event.
364      *
365      * Requirements:
366      *
367      * - `owner` cannot be the zero address.
368      * - `spender` cannot be the zero address.
369      */
370     function _approve(
371         address owner,
372         address spender,
373         uint256 amount
374     ) internal virtual {
375         require(owner != address(0), "ERC20: approve from the zero address");
376         require(spender != address(0), "ERC20: approve to the zero address");
377 
378         _allowances[owner][spender] = amount;
379         emit Approval(owner, spender, amount);
380     }
381 
382     /**
383      * @dev Hook that is called before any transfer of tokens. This includes
384      * minting and burning.
385      *
386      * Calling conditions:
387      *
388      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
389      * will be to transferred to `to`.
390      * - when `from` is zero, `amount` tokens will be minted for `to`.
391      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
392      * - `from` and `to` are never both zero.
393      *
394      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
395      */
396     function _beforeTokenTransfer(
397         address from,
398         address to,
399         uint256 amount
400     ) internal virtual {}
401 }
402 
403 
404 contract ERC20PresetFixedSupply is ERC20 {
405     /**
406      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
407      *
408      * See {ERC20-constructor}.
409      */
410     constructor(
411         string memory name,
412         string memory symbol,
413         uint256 initialSupply,
414         address owner
415     ) ERC20(name, symbol) {
416         _mint(owner, initialSupply);
417     }
418 }
419 
420 contract Colizeum is ERC20PresetFixedSupply {
421     uint256 HARDCAP = 1e9 * 1e18;
422     constructor() ERC20PresetFixedSupply("Colizeum", "ZEUM", HARDCAP, msg.sender) {
423     }
424 }