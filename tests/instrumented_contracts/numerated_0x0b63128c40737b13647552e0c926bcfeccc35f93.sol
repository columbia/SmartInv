1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
109 
110 
111 
112 pragma solidity ^0.8.0;
113 
114 
115 
116 /**
117  * @dev Implementation of the {IERC20} interface.
118  *
119  * This implementation is agnostic to the way tokens are created. This means
120  * that a supply mechanism has to be added in a derived contract using {_mint}.
121  * For a generic mechanism see {ERC20PresetMinterPauser}.
122  *
123  * TIP: For a detailed writeup see our guide
124  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
125  * to implement supply mechanisms].
126  *
127  * We have followed general OpenZeppelin guidelines: functions revert instead
128  * of returning `false` on failure. This behavior is nonetheless conventional
129  * and does not conflict with the expectations of ERC20 applications.
130  *
131  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
132  * This allows applications to reconstruct the allowance for all accounts just
133  * by listening to said events. Other implementations of the EIP may not emit
134  * these events, as it isn't required by the specification.
135  *
136  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
137  * functions have been added to mitigate the well-known issues around setting
138  * allowances. See {IERC20-approve}.
139  */
140 contract ERC20 is Context, IERC20 {
141     mapping (address => uint256) private _balances;
142 
143     mapping (address => mapping (address => uint256)) private _allowances;
144 
145     uint256 private _totalSupply;
146 
147     string private _name;
148     string private _symbol;
149 
150     /**
151      * @dev Sets the values for {name} and {symbol}.
152      *
153      * The defaut value of {decimals} is 18. To select a different value for
154      * {decimals} you should overload it.
155      *
156      * All three of these values are immutable: they can only be set once during
157      * construction.
158      */
159     constructor (string memory name_, string memory symbol_) {
160         _name = name_;
161         _symbol = symbol_;
162     }
163 
164     /**
165      * @dev Returns the name of the token.
166      */
167     function name() public view virtual returns (string memory) {
168         return _name;
169     }
170 
171     /**
172      * @dev Returns the symbol of the token, usually a shorter version of the
173      * name.
174      */
175     function symbol() public view virtual returns (string memory) {
176         return _symbol;
177     }
178 
179     /**
180      * @dev Returns the number of decimals used to get its user representation.
181      * For example, if `decimals` equals `2`, a balance of `505` tokens should
182      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
183      *
184      * Tokens usually opt for a value of 18, imitating the relationship between
185      * Ether and Wei. This is the value {ERC20} uses, unless this function is
186      * overloaded;
187      *
188      * NOTE: This information is only used for _display_ purposes: it in
189      * no way affects any of the arithmetic of the contract, including
190      * {IERC20-balanceOf} and {IERC20-transfer}.
191      */
192     function decimals() public view virtual returns (uint8) {
193         return 18;
194     }
195 
196     /**
197      * @dev See {IERC20-totalSupply}.
198      */
199     function totalSupply() public view virtual override returns (uint256) {
200         return _totalSupply;
201     }
202 
203     /**
204      * @dev See {IERC20-balanceOf}.
205      */
206     function balanceOf(address account) public view virtual override returns (uint256) {
207         return _balances[account];
208     }
209 
210     /**
211      * @dev See {IERC20-transfer}.
212      *
213      * Requirements:
214      *
215      * - `recipient` cannot be the zero address.
216      * - the caller must have a balance of at least `amount`.
217      */
218     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
219         _transfer(_msgSender(), recipient, amount);
220         return true;
221     }
222 
223     /**
224      * @dev See {IERC20-allowance}.
225      */
226     function allowance(address owner, address spender) public view virtual override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     /**
231      * @dev See {IERC20-approve}.
232      *
233      * Requirements:
234      *
235      * - `spender` cannot be the zero address.
236      */
237     function approve(address spender, uint256 amount) public virtual override returns (bool) {
238         _approve(_msgSender(), spender, amount);
239         return true;
240     }
241 
242     /**
243      * @dev See {IERC20-transferFrom}.
244      *
245      * Emits an {Approval} event indicating the updated allowance. This is not
246      * required by the EIP. See the note at the beginning of {ERC20}.
247      *
248      * Requirements:
249      *
250      * - `sender` and `recipient` cannot be the zero address.
251      * - `sender` must have a balance of at least `amount`.
252      * - the caller must have allowance for ``sender``'s tokens of at least
253      * `amount`.
254      */
255     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
256         _transfer(sender, recipient, amount);
257 
258         uint256 currentAllowance = _allowances[sender][_msgSender()];
259         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
260         _approve(sender, _msgSender(), currentAllowance - amount);
261 
262         return true;
263     }
264 
265     /**
266      * @dev Atomically increases the allowance granted to `spender` by the caller.
267      *
268      * This is an alternative to {approve} that can be used as a mitigation for
269      * problems described in {IERC20-approve}.
270      *
271      * Emits an {Approval} event indicating the updated allowance.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
278         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
279         return true;
280     }
281 
282     /**
283      * @dev Atomically decreases the allowance granted to `spender` by the caller.
284      *
285      * This is an alternative to {approve} that can be used as a mitigation for
286      * problems described in {IERC20-approve}.
287      *
288      * Emits an {Approval} event indicating the updated allowance.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      * - `spender` must have allowance for the caller of at least
294      * `subtractedValue`.
295      */
296     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
297         uint256 currentAllowance = _allowances[_msgSender()][spender];
298         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
299         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
300 
301         return true;
302     }
303 
304     /**
305      * @dev Moves tokens `amount` from `sender` to `recipient`.
306      *
307      * This is internal function is equivalent to {transfer}, and can be used to
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
318     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
319         require(sender != address(0), "ERC20: transfer from the zero address");
320         require(recipient != address(0), "ERC20: transfer to the zero address");
321 
322         _beforeTokenTransfer(sender, recipient, amount);
323 
324         uint256 senderBalance = _balances[sender];
325         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
326         _balances[sender] = senderBalance - amount;
327         _balances[recipient] += amount;
328 
329         emit Transfer(sender, recipient, amount);
330     }
331 
332     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
333      * the total supply.
334      *
335      * Emits a {Transfer} event with `from` set to the zero address.
336      *
337      * Requirements:
338      *
339      * - `to` cannot be the zero address.
340      */
341     function _mint(address account, uint256 amount) internal virtual {
342         require(account != address(0), "ERC20: mint to the zero address");
343 
344         _beforeTokenTransfer(address(0), account, amount);
345 
346         _totalSupply += amount;
347         _balances[account] += amount;
348         emit Transfer(address(0), account, amount);
349     }
350 
351     /**
352      * @dev Destroys `amount` tokens from `account`, reducing the
353      * total supply.
354      *
355      * Emits a {Transfer} event with `to` set to the zero address.
356      *
357      * Requirements:
358      *
359      * - `account` cannot be the zero address.
360      * - `account` must have at least `amount` tokens.
361      */
362     function _burn(address account, uint256 amount) internal virtual {
363         require(account != address(0), "ERC20: burn from the zero address");
364 
365         _beforeTokenTransfer(account, address(0), amount);
366 
367         uint256 accountBalance = _balances[account];
368         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
369         _balances[account] = accountBalance - amount;
370         _totalSupply -= amount;
371 
372         emit Transfer(account, address(0), amount);
373     }
374 
375     /**
376      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
377      *
378      * This internal function is equivalent to `approve`, and can be used to
379      * e.g. set automatic allowances for certain subsystems, etc.
380      *
381      * Emits an {Approval} event.
382      *
383      * Requirements:
384      *
385      * - `owner` cannot be the zero address.
386      * - `spender` cannot be the zero address.
387      */
388     function _approve(address owner, address spender, uint256 amount) internal virtual {
389         require(owner != address(0), "ERC20: approve from the zero address");
390         require(spender != address(0), "ERC20: approve to the zero address");
391 
392         _allowances[owner][spender] = amount;
393         emit Approval(owner, spender, amount);
394     }
395 
396     /**
397      * @dev Hook that is called before any transfer of tokens. This includes
398      * minting and burning.
399      *
400      * Calling conditions:
401      *
402      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
403      * will be to transferred to `to`.
404      * - when `from` is zero, `amount` tokens will be minted for `to`.
405      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
406      * - `from` and `to` are never both zero.
407      *
408      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
409      */
410     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
411 }
412 
413 // File: contracts/Liti/wrappedLiti.sol
414 
415 
416 
417 pragma solidity >=0.7.0;
418 
419 
420 contract wLitiCapital is ERC20 {
421     address litiAddress;
422 
423     event Wrapped(address user, uint256 amount);
424     event Unwrapped(address user, uint256 amount);
425 
426     constructor(address _litiAddress) ERC20("wLitiCapital", "wLITI") {
427         litiAddress = _litiAddress;
428     }
429 
430     /*
431      * Receives {amount} of shares (LITI) and mint {amount} fo wLITI Token
432      * the conversion is one to one but the wrapped token has 18 decimal points.
433      *
434      * Emits {Wrapped} event
435      *
436      * Requirements:
437      *       user account should ahev approved this contract to transfer
438      *       the {amount} of shres from LITI token contract
439      */
440     function wrap(uint256 amount) public {
441         IERC20 liti = IERC20(litiAddress);
442         require(liti.transferFrom(msg.sender, address(this), amount));
443         _mint(msg.sender, 5000 * amount * (10**18));
444         emit Wrapped(msg.sender, amount);
445     }
446 
447     /*
448      * Burns {amount} of wLITI and transfer {amount} fo LITI to user
449      *
450      * Emits {unwrapped} event
451      *
452      * Requirements:
453      *       user account should ahev approved this contract to transfer
454      *       the {amount} of shres from LITI token contract
455      */
456     function unwrap(uint256 amount) public {
457         _burn(msg.sender, 5000 * amount * (10**18));
458         IERC20 liti = IERC20(litiAddress);
459         require(liti.transfer(msg.sender, amount));
460         emit Unwrapped(msg.sender, amount);
461     }
462 }