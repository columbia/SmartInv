1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
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
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `from` to `to` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address from,
94         address to,
95         uint256 amount
96     ) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
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
146 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
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
161  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
162  * to implement supply mechanisms].
163  *
164  * We have followed general OpenZeppelin Contracts guidelines: functions revert
165  * instead returning `false` on failure. This behavior is nonetheless
166  * conventional and does not conflict with the expectations of ERC20
167  * applications.
168  *
169  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
170  * This allows applications to reconstruct the allowance for all accounts just
171  * by listening to said events. Other implementations of the EIP may not emit
172  * these events, as it isn't required by the specification.
173  *
174  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
175  * functions have been added to mitigate the well-known issues around setting
176  * allowances. See {IERC20-approve}.
177  */
178 contract ERC20 is Context, IERC20, IERC20Metadata {
179     mapping(address => uint256) private _balances;
180 
181     mapping(address => mapping(address => uint256)) private _allowances;
182 
183     uint256 private _totalSupply;
184 
185     string private _name;
186     string private _symbol;
187 
188     /**
189      * @dev Sets the values for {name} and {symbol}.
190      *
191      * The default value of {decimals} is 18. To select a different value for
192      * {decimals} you should overload it.
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
223      * Ether and Wei. This is the value {ERC20} uses, unless this function is
224      * overridden;
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
301     function transferFrom(
302         address from,
303         address to,
304         uint256 amount
305     ) public virtual override returns (bool) {
306         address spender = _msgSender();
307         _spendAllowance(from, spender, amount);
308         _transfer(from, to, amount);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically increases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
325         address owner = _msgSender();
326         _approve(owner, spender, _allowances[owner][spender] + addedValue);
327         return true;
328     }
329 
330     /**
331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to {approve} that can be used as a mitigation for
334      * problems described in {IERC20-approve}.
335      *
336      * Emits an {Approval} event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      * - `spender` must have allowance for the caller of at least
342      * `subtractedValue`.
343      */
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         address owner = _msgSender();
346         uint256 currentAllowance = _allowances[owner][spender];
347         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
348         unchecked {
349             _approve(owner, spender, currentAllowance - subtractedValue);
350         }
351 
352         return true;
353     }
354 
355     /**
356      * @dev Moves `amount` of tokens from `sender` to `recipient`.
357      *
358      * This internal function is equivalent to {transfer}, and can be used to
359      * e.g. implement automatic token fees, slashing mechanisms, etc.
360      *
361      * Emits a {Transfer} event.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `from` must have a balance of at least `amount`.
368      */
369     function _transfer(
370         address from,
371         address to,
372         uint256 amount
373     ) internal virtual {
374         require(from != address(0), "ERC20: transfer from the zero address");
375         require(to != address(0), "ERC20: transfer to the zero address");
376 
377         _beforeTokenTransfer(from, to, amount);
378 
379         uint256 fromBalance = _balances[from];
380         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
381         unchecked {
382             _balances[from] = fromBalance - amount;
383         }
384         _balances[to] += amount;
385 
386         emit Transfer(from, to, amount);
387 
388         _afterTokenTransfer(from, to, amount);
389     }
390 
391     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
392      * the total supply.
393      *
394      * Emits a {Transfer} event with `from` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      */
400     function _mint(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: mint to the zero address");
402 
403         _beforeTokenTransfer(address(0), account, amount);
404 
405         _totalSupply += amount;
406         _balances[account] += amount;
407         emit Transfer(address(0), account, amount);
408 
409         _afterTokenTransfer(address(0), account, amount);
410     }
411 
412     /**
413      * @dev Destroys `amount` tokens from `account`, reducing the
414      * total supply.
415      *
416      * Emits a {Transfer} event with `to` set to the zero address.
417      *
418      * Requirements:
419      *
420      * - `account` cannot be the zero address.
421      * - `account` must have at least `amount` tokens.
422      */
423     function _burn(address account, uint256 amount) internal virtual {
424         require(account != address(0), "ERC20: burn from the zero address");
425 
426         _beforeTokenTransfer(account, address(0), amount);
427 
428         uint256 accountBalance = _balances[account];
429         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
430         unchecked {
431             _balances[account] = accountBalance - amount;
432         }
433         _totalSupply -= amount;
434 
435         emit Transfer(account, address(0), amount);
436 
437         _afterTokenTransfer(account, address(0), amount);
438     }
439 
440     /**
441      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
442      *
443      * This internal function is equivalent to `approve`, and can be used to
444      * e.g. set automatic allowances for certain subsystems, etc.
445      *
446      * Emits an {Approval} event.
447      *
448      * Requirements:
449      *
450      * - `owner` cannot be the zero address.
451      * - `spender` cannot be the zero address.
452      */
453     function _approve(
454         address owner,
455         address spender,
456         uint256 amount
457     ) internal virtual {
458         require(owner != address(0), "ERC20: approve from the zero address");
459         require(spender != address(0), "ERC20: approve to the zero address");
460 
461         _allowances[owner][spender] = amount;
462         emit Approval(owner, spender, amount);
463     }
464 
465     /**
466      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
467      *
468      * Does not update the allowance amount in case of infinite allowance.
469      * Revert if not enough allowance is available.
470      *
471      * Might emit an {Approval} event.
472      */
473     function _spendAllowance(
474         address owner,
475         address spender,
476         uint256 amount
477     ) internal virtual {
478         uint256 currentAllowance = allowance(owner, spender);
479         if (currentAllowance != type(uint256).max) {
480             require(currentAllowance >= amount, "ERC20: insufficient allowance");
481             unchecked {
482                 _approve(owner, spender, currentAllowance - amount);
483             }
484         }
485     }
486 
487     /**
488      * @dev Hook that is called before any transfer of tokens. This includes
489      * minting and burning.
490      *
491      * Calling conditions:
492      *
493      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
494      * will be transferred to `to`.
495      * - when `from` is zero, `amount` tokens will be minted for `to`.
496      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
497      * - `from` and `to` are never both zero.
498      *
499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
500      */
501     function _beforeTokenTransfer(
502         address from,
503         address to,
504         uint256 amount
505     ) internal virtual {}
506 
507     /**
508      * @dev Hook that is called after any transfer of tokens. This includes
509      * minting and burning.
510      *
511      * Calling conditions:
512      *
513      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
514      * has been transferred to `to`.
515      * - when `from` is zero, `amount` tokens have been minted for `to`.
516      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
517      * - `from` and `to` are never both zero.
518      *
519      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
520      */
521     function _afterTokenTransfer(
522         address from,
523         address to,
524         uint256 amount
525     ) internal virtual {}
526 }
527 
528 // File: JPCERC20.sol
529 
530 
531 pragma solidity ^0.8.4;
532 
533 
534 contract JPEXCoin is ERC20 {
535     constructor() ERC20("JPEX Coin", "JPC") {
536         _mint(msg.sender, 10000000000000 * 10 ** decimals());
537     }
538 }