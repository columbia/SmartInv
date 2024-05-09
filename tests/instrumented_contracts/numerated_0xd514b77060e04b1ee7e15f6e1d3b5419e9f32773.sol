1 // https://twitter.com/0xAgentsAI
2 // https://www.0xagents.io/
3 
4 // File: @openzeppelin/contracts@4.9.0/utils/Context.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts@4.9.0/token/ERC20/IERC20.sol
32 
33 
34 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Emitted when `value` tokens are moved from one account (`from`) to
44      * another (`to`).
45      *
46      * Note that `value` may be zero.
47      */
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     /**
51      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
52      * a call to {approve}. `value` is the new allowance.
53      */
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `to`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address to, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     /**
85      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * IMPORTANT: Beware that changing an allowance with this method brings the risk
90      * that someone may use both the old and the new allowance by unfortunate
91      * transaction ordering. One possible solution to mitigate this race
92      * condition is to first reduce the spender's allowance to 0 and set the
93      * desired value afterwards:
94      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Moves `amount` tokens from `from` to `to` using the
102      * allowance mechanism. `amount` is then deducted from the caller's
103      * allowance.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(address from, address to, uint256 amount) external returns (bool);
110 }
111 
112 // File: @openzeppelin/contracts@4.9.0/token/ERC20/extensions/IERC20Metadata.sol
113 
114 
115 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 
120 /**
121  * @dev Interface for the optional metadata functions from the ERC20 standard.
122  *
123  * _Available since v4.1._
124  */
125 interface IERC20Metadata is IERC20 {
126     /**
127      * @dev Returns the name of the token.
128      */
129     function name() external view returns (string memory);
130 
131     /**
132      * @dev Returns the symbol of the token.
133      */
134     function symbol() external view returns (string memory);
135 
136     /**
137      * @dev Returns the decimals places of the token.
138      */
139     function decimals() external view returns (uint8);
140 }
141 
142 // File: @openzeppelin/contracts@4.9.0/token/ERC20/ERC20.sol
143 
144 
145 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 
150 
151 
152 /**
153  * @dev Implementation of the {IERC20} interface.
154  *
155  * This implementation is agnostic to the way tokens are created. This means
156  * that a supply mechanism has to be added in a derived contract using {_mint}.
157  * For a generic mechanism see {ERC20PresetMinterPauser}.
158  *
159  * TIP: For a detailed writeup see our guide
160  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
161  * to implement supply mechanisms].
162  *
163  * The default value of {decimals} is 18. To change this, you should override
164  * this function so it returns a different value.
165  *
166  * We have followed general OpenZeppelin Contracts guidelines: functions revert
167  * instead returning `false` on failure. This behavior is nonetheless
168  * conventional and does not conflict with the expectations of ERC20
169  * applications.
170  *
171  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
172  * This allows applications to reconstruct the allowance for all accounts just
173  * by listening to said events. Other implementations of the EIP may not emit
174  * these events, as it isn't required by the specification.
175  *
176  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
177  * functions have been added to mitigate the well-known issues around setting
178  * allowances. See {IERC20-approve}.
179  */
180 contract ERC20 is Context, IERC20, IERC20Metadata {
181     mapping(address => uint256) private _balances;
182 
183     mapping(address => mapping(address => uint256)) private _allowances;
184 
185     uint256 private _totalSupply;
186 
187     string private _name;
188     string private _symbol;
189 
190     /**
191      * @dev Sets the values for {name} and {symbol}.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200 
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207 
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215 
216     /**
217      * @dev Returns the number of decimals used to get its user representation.
218      * For example, if `decimals` equals `2`, a balance of `505` tokens should
219      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
220      *
221      * Tokens usually opt for a value of 18, imitating the relationship between
222      * Ether and Wei. This is the default value returned by this function, unless
223      * it's overridden.
224      *
225      * NOTE: This information is only used for _display_ purposes: it in
226      * no way affects any of the arithmetic of the contract, including
227      * {IERC20-balanceOf} and {IERC20-transfer}.
228      */
229     function decimals() public view virtual override returns (uint8) {
230         return 18;
231     }
232 
233     /**
234      * @dev See {IERC20-totalSupply}.
235      */
236     function totalSupply() public view virtual override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241      * @dev See {IERC20-balanceOf}.
242      */
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     /**
248      * @dev See {IERC20-transfer}.
249      *
250      * Requirements:
251      *
252      * - `to` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address to, uint256 amount) public virtual override returns (bool) {
256         address owner = _msgSender();
257         _transfer(owner, to, amount);
258         return true;
259     }
260 
261     /**
262      * @dev See {IERC20-allowance}.
263      */
264     function allowance(address owner, address spender) public view virtual override returns (uint256) {
265         return _allowances[owner][spender];
266     }
267 
268     /**
269      * @dev See {IERC20-approve}.
270      *
271      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
272      * `transferFrom`. This is semantically equivalent to an infinite approval.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      */
278     function approve(address spender, uint256 amount) public virtual override returns (bool) {
279         address owner = _msgSender();
280         _approve(owner, spender, amount);
281         return true;
282     }
283 
284     /**
285      * @dev See {IERC20-transferFrom}.
286      *
287      * Emits an {Approval} event indicating the updated allowance. This is not
288      * required by the EIP. See the note at the beginning of {ERC20}.
289      *
290      * NOTE: Does not update the allowance if the current allowance
291      * is the maximum `uint256`.
292      *
293      * Requirements:
294      *
295      * - `from` and `to` cannot be the zero address.
296      * - `from` must have a balance of at least `amount`.
297      * - the caller must have allowance for ``from``'s tokens of at least
298      * `amount`.
299      */
300     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
301         address spender = _msgSender();
302         _spendAllowance(from, spender, amount);
303         _transfer(from, to, amount);
304         return true;
305     }
306 
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         address owner = _msgSender();
321         _approve(owner, spender, allowance(owner, spender) + addedValue);
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         address owner = _msgSender();
341         uint256 currentAllowance = allowance(owner, spender);
342         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
343         unchecked {
344             _approve(owner, spender, currentAllowance - subtractedValue);
345         }
346 
347         return true;
348     }
349 
350     /**
351      * @dev Moves `amount` of tokens from `from` to `to`.
352      *
353      * This internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `from` cannot be the zero address.
361      * - `to` cannot be the zero address.
362      * - `from` must have a balance of at least `amount`.
363      */
364     function _transfer(address from, address to, uint256 amount) internal virtual {
365         require(from != address(0), "ERC20: transfer from the zero address");
366         require(to != address(0), "ERC20: transfer to the zero address");
367 
368         _beforeTokenTransfer(from, to, amount);
369 
370         uint256 fromBalance = _balances[from];
371         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
372         unchecked {
373             _balances[from] = fromBalance - amount;
374             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
375             // decrementing then incrementing.
376             _balances[to] += amount;
377         }
378 
379         emit Transfer(from, to, amount);
380 
381         _afterTokenTransfer(from, to, amount);
382     }
383 
384     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
385      * the total supply.
386      *
387      * Emits a {Transfer} event with `from` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      */
393     function _mint(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: mint to the zero address");
395 
396         _beforeTokenTransfer(address(0), account, amount);
397 
398         _totalSupply += amount;
399         unchecked {
400             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
401             _balances[account] += amount;
402         }
403         emit Transfer(address(0), account, amount);
404 
405         _afterTokenTransfer(address(0), account, amount);
406     }
407 
408     /**
409      * @dev Destroys `amount` tokens from `account`, reducing the
410      * total supply.
411      *
412      * Emits a {Transfer} event with `to` set to the zero address.
413      *
414      * Requirements:
415      *
416      * - `account` cannot be the zero address.
417      * - `account` must have at least `amount` tokens.
418      */
419     function _burn(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: burn from the zero address");
421 
422         _beforeTokenTransfer(account, address(0), amount);
423 
424         uint256 accountBalance = _balances[account];
425         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
426         unchecked {
427             _balances[account] = accountBalance - amount;
428             // Overflow not possible: amount <= accountBalance <= totalSupply.
429             _totalSupply -= amount;
430         }
431 
432         emit Transfer(account, address(0), amount);
433 
434         _afterTokenTransfer(account, address(0), amount);
435     }
436 
437     /**
438      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
439      *
440      * This internal function is equivalent to `approve`, and can be used to
441      * e.g. set automatic allowances for certain subsystems, etc.
442      *
443      * Emits an {Approval} event.
444      *
445      * Requirements:
446      *
447      * - `owner` cannot be the zero address.
448      * - `spender` cannot be the zero address.
449      */
450     function _approve(address owner, address spender, uint256 amount) internal virtual {
451         require(owner != address(0), "ERC20: approve from the zero address");
452         require(spender != address(0), "ERC20: approve to the zero address");
453 
454         _allowances[owner][spender] = amount;
455         emit Approval(owner, spender, amount);
456     }
457 
458     /**
459      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
460      *
461      * Does not update the allowance amount in case of infinite allowance.
462      * Revert if not enough allowance is available.
463      *
464      * Might emit an {Approval} event.
465      */
466     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
467         uint256 currentAllowance = allowance(owner, spender);
468         if (currentAllowance != type(uint256).max) {
469             require(currentAllowance >= amount, "ERC20: insufficient allowance");
470             unchecked {
471                 _approve(owner, spender, currentAllowance - amount);
472             }
473         }
474     }
475 
476     /**
477      * @dev Hook that is called before any transfer of tokens. This includes
478      * minting and burning.
479      *
480      * Calling conditions:
481      *
482      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
483      * will be transferred to `to`.
484      * - when `from` is zero, `amount` tokens will be minted for `to`.
485      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
486      * - `from` and `to` are never both zero.
487      *
488      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
489      */
490     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
491 
492     /**
493      * @dev Hook that is called after any transfer of tokens. This includes
494      * minting and burning.
495      *
496      * Calling conditions:
497      *
498      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
499      * has been transferred to `to`.
500      * - when `from` is zero, `amount` tokens have been minted for `to`.
501      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
502      * - `from` and `to` are never both zero.
503      *
504      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
505      */
506     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
507 }
508 
509 pragma solidity ^0.8.9;
510 
511 
512 contract AGENT is ERC20 {
513     constructor() ERC20("0xAgentsAI", "AGENT") {
514         _mint(msg.sender, 1000000000000 * 10 ** decimals());
515     }
516 }