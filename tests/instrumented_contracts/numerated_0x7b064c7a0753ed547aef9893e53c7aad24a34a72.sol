1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
87 
88  
89 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 // File: @openzeppelin\contracts\utils\Context.sol
116 
117  
118 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
143 
144  
145 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 
150 
151 /**
152  * @dev Implementation of the {IERC20} interface.
153  *
154  * This implementation is agnostic to the way tokens are created. This means
155  * that a supply mechanism has to be added in a derived contract using {_mint}.
156  * For a generic mechanism see {ERC20PresetMinterPauser}.
157  *
158  * TIP: For a detailed writeup see our guide
159  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
160  * to implement supply mechanisms].
161  *
162  * We have followed general OpenZeppelin Contracts guidelines: functions revert
163  * instead returning `false` on failure. This behavior is nonetheless
164  * conventional and does not conflict with the expectations of ERC20
165  * applications.
166  *
167  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
168  * This allows applications to reconstruct the allowance for all accounts just
169  * by listening to said events. Other implementations of the EIP may not emit
170  * these events, as it isn't required by the specification.
171  *
172  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
173  * functions have been added to mitigate the well-known issues around setting
174  * allowances. See {IERC20-approve}.
175  */
176 contract ERC20 is Context, IERC20, IERC20Metadata {
177     mapping(address => uint256) private _balances;
178 
179     mapping(address => mapping(address => uint256)) private _allowances;
180 
181     uint256 private _totalSupply;
182 
183     string private _name;
184     string private _symbol;
185 
186     /**
187      * @dev Sets the values for {name} and {symbol}.
188      *
189      * The default value of {decimals} is 18. To select a different value for
190      * {decimals} you should overload it.
191      *
192      * All two of these values are immutable: they can only be set once during
193      * construction.
194      */
195     constructor(string memory name_, string memory symbol_) {
196         _name = name_;
197         _symbol = symbol_;
198     }
199 
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view virtual override returns (string memory) {
204         return _name;
205     }
206 
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214 
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if `decimals` equals `2`, a balance of `505` tokens should
218      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei. This is the value {ERC20} uses, unless this function is
222      * overridden;
223      *
224      * NOTE: This information is only used for _display_ purposes: it in
225      * no way affects any of the arithmetic of the contract, including
226      * {IERC20-balanceOf} and {IERC20-transfer}.
227      */
228     function decimals() public view virtual override returns (uint8) {
229         return 18;
230     }
231 
232     /**
233      * @dev See {IERC20-totalSupply}.
234      */
235     function totalSupply() public view virtual override returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(address account) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See {IERC20-transfer}.
248      *
249      * Requirements:
250      *
251      * - `to` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address to, uint256 amount) public virtual override returns (bool) {
255         address owner = _msgSender();
256         _transfer(owner, to, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
271      * `transferFrom`. This is semantically equivalent to an infinite approval.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 amount) public virtual override returns (bool) {
278         address owner = _msgSender();
279         _approve(owner, spender, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-transferFrom}.
285      *
286      * Emits an {Approval} event indicating the updated allowance. This is not
287      * required by the EIP. See the note at the beginning of {ERC20}.
288      *
289      * NOTE: Does not update the allowance if the current allowance
290      * is the maximum `uint256`.
291      *
292      * Requirements:
293      *
294      * - `from` and `to` cannot be the zero address.
295      * - `from` must have a balance of at least `amount`.
296      * - the caller must have allowance for ``from``'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(
300         address from,
301         address to,
302         uint256 amount
303     ) public virtual override returns (bool) {
304         address spender = _msgSender();
305         _spendAllowance(from, spender, amount);
306         _transfer(from, to, amount);
307         return true;
308     }
309 
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
323         address owner = _msgSender();
324         _approve(owner, spender, allowance(owner, spender) + addedValue);
325         return true;
326     }
327 
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         address owner = _msgSender();
344         uint256 currentAllowance = allowance(owner, spender);
345         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
346         unchecked {
347             _approve(owner, spender, currentAllowance - subtractedValue);
348         }
349 
350         return true;
351     }
352 
353     /**
354      * @dev Moves `amount` of tokens from `from` to `to`.
355      *
356      * This internal function is equivalent to {transfer}, and can be used to
357      * e.g. implement automatic token fees, slashing mechanisms, etc.
358      *
359      * Emits a {Transfer} event.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `from` must have a balance of at least `amount`.
366      */
367     function _transfer(
368         address from,
369         address to,
370         uint256 amount
371     ) internal virtual {
372         require(from != address(0), "ERC20: transfer from the zero address");
373         require(to != address(0), "ERC20: transfer to the zero address");
374 
375         _beforeTokenTransfer(from, to, amount);
376 
377         uint256 fromBalance = _balances[from];
378         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
379         unchecked {
380             _balances[from] = fromBalance - amount;
381         }
382         _balances[to] += amount;
383 
384         emit Transfer(from, to, amount);
385 
386         _afterTokenTransfer(from, to, amount);
387     }
388 
389     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
390      * the total supply.
391      *
392      * Emits a {Transfer} event with `from` set to the zero address.
393      *
394      * Requirements:
395      *
396      * - `account` cannot be the zero address.
397      */
398     function _mint(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: mint to the zero address");
400 
401         _beforeTokenTransfer(address(0), account, amount);
402 
403         _totalSupply += amount;
404         _balances[account] += amount;
405         emit Transfer(address(0), account, amount);
406 
407         _afterTokenTransfer(address(0), account, amount);
408     }
409 
410     /**
411      * @dev Destroys `amount` tokens from `account`, reducing the
412      * total supply.
413      *
414      * Emits a {Transfer} event with `to` set to the zero address.
415      *
416      * Requirements:
417      *
418      * - `account` cannot be the zero address.
419      * - `account` must have at least `amount` tokens.
420      */
421     function _burn(address account, uint256 amount) internal virtual {
422         require(account != address(0), "ERC20: burn from the zero address");
423 
424         _beforeTokenTransfer(account, address(0), amount);
425 
426         uint256 accountBalance = _balances[account];
427         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
428         unchecked {
429             _balances[account] = accountBalance - amount;
430         }
431         _totalSupply -= amount;
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
451     function _approve(
452         address owner,
453         address spender,
454         uint256 amount
455     ) internal virtual {
456         require(owner != address(0), "ERC20: approve from the zero address");
457         require(spender != address(0), "ERC20: approve to the zero address");
458 
459         _allowances[owner][spender] = amount;
460         emit Approval(owner, spender, amount);
461     }
462 
463     /**
464      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
465      *
466      * Does not update the allowance amount in case of infinite allowance.
467      * Revert if not enough allowance is available.
468      *
469      * Might emit an {Approval} event.
470      */
471     function _spendAllowance(
472         address owner,
473         address spender,
474         uint256 amount
475     ) internal virtual {
476         uint256 currentAllowance = allowance(owner, spender);
477         if (currentAllowance != type(uint256).max) {
478             require(currentAllowance >= amount, "ERC20: insufficient allowance");
479             unchecked {
480                 _approve(owner, spender, currentAllowance - amount);
481             }
482         }
483     }
484 
485     /**
486      * @dev Hook that is called before any transfer of tokens. This includes
487      * minting and burning.
488      *
489      * Calling conditions:
490      *
491      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
492      * will be transferred to `to`.
493      * - when `from` is zero, `amount` tokens will be minted for `to`.
494      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
495      * - `from` and `to` are never both zero.
496      *
497      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
498      */
499     function _beforeTokenTransfer(
500         address from,
501         address to,
502         uint256 amount
503     ) internal virtual {}
504 
505     /**
506      * @dev Hook that is called after any transfer of tokens. This includes
507      * minting and burning.
508      *
509      * Calling conditions:
510      *
511      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
512      * has been transferred to `to`.
513      * - when `from` is zero, `amount` tokens have been minted for `to`.
514      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
515      * - `from` and `to` are never both zero.
516      *
517      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
518      */
519     function _afterTokenTransfer(
520         address from,
521         address to,
522         uint256 amount
523     ) internal virtual {}
524 }
525 
526 // File: contracts\0x8e6105b7eeb8a6841d66f8e82c0f8e126a400b86,Ethereum,ETH,2023-02-27_05-40-53.sol
527 
528  
529 pragma solidity ^0.8.9;
530 contract Ethereum is ERC20 {
531     function decimals() public view virtual override returns (uint8) {
532             return 18;
533             }
534     constructor() ERC20("Ethereum", "ETH") {
535         _mint(msg.sender, 100000000000000000000000000000000000 * 10 ** decimals());
536     }
537 }