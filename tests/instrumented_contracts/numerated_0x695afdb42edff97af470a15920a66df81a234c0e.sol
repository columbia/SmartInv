1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-07
3 */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 
35 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Interface of the ERC20 standard as defined in the EIP.
41  */
42 interface IERC20 {
43     /**
44      * @dev Emitted when `value` tokens are moved from one account (`from`) to
45      * another (`to`).
46      *
47      * Note that `value` may be zero.
48      */
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     /**
52      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
53      * a call to {approve}. `value` is the new allowance.
54      */
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 
57     /**
58      * @dev Returns the amount of tokens in existence.
59      */
60     function totalSupply() external view returns (uint256);
61 
62     /**
63      * @dev Returns the amount of tokens owned by `account`.
64      */
65     function balanceOf(address account) external view returns (uint256);
66 
67     /**
68      * @dev Moves `amount` tokens from the caller's account to `to`.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transfer(address to, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Returns the remaining number of tokens that `spender` will be
78      * allowed to spend on behalf of `owner` through {transferFrom}. This is
79      * zero by default.
80      *
81      * This value changes when {approve} or {transferFrom} are called.
82      */
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     /**
86      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * IMPORTANT: Beware that changing an allowance with this method brings the risk
91      * that someone may use both the old and the new allowance by unfortunate
92      * transaction ordering. One possible solution to mitigate this race
93      * condition is to first reduce the spender's allowance to 0 and set the
94      * desired value afterwards:
95      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
96      *
97      * Emits an {Approval} event.
98      */
99     function approve(address spender, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Moves `amount` tokens from `from` to `to` using the
103      * allowance mechanism. `amount` is then deducted from the caller's
104      * allowance.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(address from, address to, uint256 amount) external returns (bool);
111 }
112 
113 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 
121 /**
122  * @dev Interface for the optional metadata functions from the ERC20 standard.
123  *
124  * _Available since v4.1._
125  */
126 interface IERC20Metadata is IERC20 {
127     /**
128      * @dev Returns the name of the token.
129      */
130     function name() external view returns (string memory);
131 
132     /**
133      * @dev Returns the symbol of the token.
134      */
135     function symbol() external view returns (string memory);
136 
137     /**
138      * @dev Returns the decimals places of the token.
139      */
140     function decimals() external view returns (uint8);
141 }
142 
143 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
144 
145 
146 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 
151 
152 
153 /**
154  * @dev Implementation of the {IERC20} interface.
155  *
156  * This implementation is agnostic to the way tokens are created. This means
157  * that a supply mechanism has to be added in a derived contract using {_mint}.
158  * For a generic mechanism see {ERC20PresetMinterPauser}.
159  *
160  * TIP: For a detailed writeup see our guide
161  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
162  * to implement supply mechanisms].
163  *
164  * The default value of {decimals} is 18. To change this, you should override
165  * this function so it returns a different value.
166  *
167  * We have followed general OpenZeppelin Contracts guidelines: functions revert
168  * instead returning `false` on failure. This behavior is nonetheless
169  * conventional and does not conflict with the expectations of ERC20
170  * applications.
171  *
172  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
173  * This allows applications to reconstruct the allowance for all accounts just
174  * by listening to said events. Other implementations of the EIP may not emit
175  * these events, as it isn't required by the specification.
176  *
177  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
178  * functions have been added to mitigate the well-known issues around setting
179  * allowances. See {IERC20-approve}.
180  */
181 contract ERC20 is Context, IERC20, IERC20Metadata {
182     mapping(address => uint256) private _balances;
183 
184     mapping(address => mapping(address => uint256)) private _allowances;
185 
186     uint256 private _totalSupply;
187 
188     string private _name;
189     string private _symbol;
190 
191     /**
192      * @dev Sets the values for {name} and {symbol}.
193      *
194      * All two of these values are immutable: they can only be set once during
195      * construction.
196      */
197     constructor(string memory name_, string memory symbol_) {
198         _name = name_;
199         _symbol = symbol_;
200     }
201 
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() public view virtual override returns (string memory) {
206         return _name;
207     }
208 
209     /**
210      * @dev Returns the symbol of the token, usually a shorter version of the
211      * name.
212      */
213     function symbol() public view virtual override returns (string memory) {
214         return _symbol;
215     }
216 
217     /**
218      * @dev Returns the number of decimals used to get its user representation.
219      * For example, if `decimals` equals `2`, a balance of `505` tokens should
220      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
221      *
222      * Tokens usually opt for a value of 18, imitating the relationship between
223      * Ether and Wei. This is the default value returned by this function, unless
224      * it's overridden.
225      *
226      * NOTE: This information is only used for _display_ purposes: it in
227      * no way affects any of the arithmetic of the contract, including
228      * {IERC20-balanceOf} and {IERC20-transfer}.
229      */
230     function decimals() public view virtual override returns (uint8) {
231         return 18;
232     }
233 
234     /**
235      * @dev See {IERC20-totalSupply}.
236      */
237     function totalSupply() public view virtual override returns (uint256) {
238         return _totalSupply;
239     }
240 
241     /**
242      * @dev See {IERC20-balanceOf}.
243      */
244     function balanceOf(address account) public view virtual override returns (uint256) {
245         return _balances[account];
246     }
247 
248     /**
249      * @dev See {IERC20-transfer}.
250      *
251      * Requirements:
252      *
253      * - `to` cannot be the zero address.
254      * - the caller must have a balance of at least `amount`.
255      */
256     function transfer(address to, uint256 amount) public virtual override returns (bool) {
257         address owner = _msgSender();
258         _transfer(owner, to, amount);
259         return true;
260     }
261 
262     /**
263      * @dev See {IERC20-allowance}.
264      */
265     function allowance(address owner, address spender) public view virtual override returns (uint256) {
266         return _allowances[owner][spender];
267     }
268 
269     /**
270      * @dev See {IERC20-approve}.
271      *
272      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
273      * `transferFrom`. This is semantically equivalent to an infinite approval.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 amount) public virtual override returns (bool) {
280         address owner = _msgSender();
281         _approve(owner, spender, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See {IERC20-transferFrom}.
287      *
288      * Emits an {Approval} event indicating the updated allowance. This is not
289      * required by the EIP. See the note at the beginning of {ERC20}.
290      *
291      * NOTE: Does not update the allowance if the current allowance
292      * is the maximum `uint256`.
293      *
294      * Requirements:
295      *
296      * - `from` and `to` cannot be the zero address.
297      * - `from` must have a balance of at least `amount`.
298      * - the caller must have allowance for ``from``'s tokens of at least
299      * `amount`.
300      */
301     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
302         address spender = _msgSender();
303         _spendAllowance(from, spender, amount);
304         _transfer(from, to, amount);
305         return true;
306     }
307 
308     /**
309      * @dev Atomically increases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
321         address owner = _msgSender();
322         _approve(owner, spender, allowance(owner, spender) + addedValue);
323         return true;
324     }
325 
326     /**
327      * @dev Atomically decreases the allowance granted to `spender` by the caller.
328      *
329      * This is an alternative to {approve} that can be used as a mitigation for
330      * problems described in {IERC20-approve}.
331      *
332      * Emits an {Approval} event indicating the updated allowance.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      * - `spender` must have allowance for the caller of at least
338      * `subtractedValue`.
339      */
340     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
341         address owner = _msgSender();
342         uint256 currentAllowance = allowance(owner, spender);
343         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
344         unchecked {
345             _approve(owner, spender, currentAllowance - subtractedValue);
346         }
347 
348         return true;
349     }
350 
351     /**
352      * @dev Moves `amount` of tokens from `from` to `to`.
353      *
354      * This internal function is equivalent to {transfer}, and can be used to
355      * e.g. implement automatic token fees, slashing mechanisms, etc.
356      *
357      * Emits a {Transfer} event.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `from` must have a balance of at least `amount`.
364      */
365     function _transfer(address from, address to, uint256 amount) internal virtual {
366         require(from != address(0), "ERC20: transfer from the zero address");
367         require(to != address(0), "ERC20: transfer to the zero address");
368 
369         _beforeTokenTransfer(from, to, amount);
370 
371         uint256 fromBalance = _balances[from];
372         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
373         unchecked {
374             _balances[from] = fromBalance - amount;
375             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
376             // decrementing then incrementing.
377             _balances[to] += amount;
378         }
379 
380         emit Transfer(from, to, amount);
381 
382         _afterTokenTransfer(from, to, amount);
383     }
384 
385     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
386      * the total supply.
387      *
388      * Emits a {Transfer} event with `from` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      */
394     function _mint(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: mint to the zero address");
396 
397         _beforeTokenTransfer(address(0), account, amount);
398 
399         _totalSupply += amount;
400         unchecked {
401             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
402             _balances[account] += amount;
403         }
404         emit Transfer(address(0), account, amount);
405 
406         _afterTokenTransfer(address(0), account, amount);
407     }
408 
409     /**
410      * @dev Destroys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a {Transfer} event with `to` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 amount) internal virtual {
421         require(account != address(0), "ERC20: burn from the zero address");
422 
423         _beforeTokenTransfer(account, address(0), amount);
424 
425         uint256 accountBalance = _balances[account];
426         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
427         unchecked {
428             _balances[account] = accountBalance - amount;
429             // Overflow not possible: amount <= accountBalance <= totalSupply.
430             _totalSupply -= amount;
431         }
432 
433         emit Transfer(account, address(0), amount);
434 
435         _afterTokenTransfer(account, address(0), amount);
436     }
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
440      *
441      * This internal function is equivalent to `approve`, and can be used to
442      * e.g. set automatic allowances for certain subsystems, etc.
443      *
444      * Emits an {Approval} event.
445      *
446      * Requirements:
447      *
448      * - `owner` cannot be the zero address.
449      * - `spender` cannot be the zero address.
450      */
451     function _approve(address owner, address spender, uint256 amount) internal virtual {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454 
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458 
459     /**
460      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
461      *
462      * Does not update the allowance amount in case of infinite allowance.
463      * Revert if not enough allowance is available.
464      *
465      * Might emit an {Approval} event.
466      */
467     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
468         uint256 currentAllowance = allowance(owner, spender);
469         if (currentAllowance != type(uint256).max) {
470             require(currentAllowance >= amount, "ERC20: insufficient allowance");
471             unchecked {
472                 _approve(owner, spender, currentAllowance - amount);
473             }
474         }
475     }
476 
477     /**
478      * @dev Hook that is called before any transfer of tokens. This includes
479      * minting and burning.
480      *
481      * Calling conditions:
482      *
483      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
484      * will be transferred to `to`.
485      * - when `from` is zero, `amount` tokens will be minted for `to`.
486      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
487      * - `from` and `to` are never both zero.
488      *
489      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
490      */
491     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
492 
493     /**
494      * @dev Hook that is called after any transfer of tokens. This includes
495      * minting and burning.
496      *
497      * Calling conditions:
498      *
499      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
500      * has been transferred to `to`.
501      * - when `from` is zero, `amount` tokens have been minted for `to`.
502      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
503      * - `from` and `to` are never both zero.
504      *
505      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
506      */
507     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
508 }
509 
510 // File: contracts/WMOXY.sol
511 
512 pragma solidity ^0.8.18;
513 
514     
515         contract WMOXY is ERC20 {
516             constructor() ERC20("Wrapped MOXY", "wMOXY") {
517                 _mint(msg.sender, 1500000000000000000000000000);
518             }
519         }