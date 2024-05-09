1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
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
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(
91         address sender,
92         address recipient,
93         uint256 amount
94     ) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
112 
113 
114 
115 pragma solidity ^0.8.0;
116 
117 
118 /**
119  * @dev Interface for the optional metadata functions from the ERC20 standard.
120  *
121  * _Available since v4.1._
122  */
123 interface IERC20Metadata is IERC20 {
124     /**
125      * @dev Returns the name of the token.
126      */
127     function name() external view returns (string memory);
128 
129     /**
130      * @dev Returns the symbol of the token.
131      */
132     function symbol() external view returns (string memory);
133 
134     /**
135      * @dev Returns the decimals places of the token.
136      */
137     function decimals() external view returns (uint8);
138 }
139 
140 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
141 
142 
143 
144 pragma solidity ^0.8.0;
145 
146 
147 
148 
149 /**
150  * @dev Implementation of the {IERC20} interface.
151  *
152  * This implementation is agnostic to the way tokens are created. This means
153  * that a supply mechanism has to be added in a derived contract using {_mint}.
154  * For a generic mechanism see {ERC20PresetMinterPauser}.
155  *
156  * TIP: For a detailed writeup see our guide
157  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
158  * to implement supply mechanisms].
159  *
160  * We have followed general OpenZeppelin Contracts guidelines: functions revert
161  * instead returning `false` on failure. This behavior is nonetheless
162  * conventional and does not conflict with the expectations of ERC20
163  * applications.
164  *
165  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
166  * This allows applications to reconstruct the allowance for all accounts just
167  * by listening to said events. Other implementations of the EIP may not emit
168  * these events, as it isn't required by the specification.
169  *
170  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
171  * functions have been added to mitigate the well-known issues around setting
172  * allowances. See {IERC20-approve}.
173  */
174 contract ERC20 is Context, IERC20, IERC20Metadata {
175     mapping(address => uint256) private _balances;
176 
177     mapping(address => mapping(address => uint256)) private _allowances;
178 
179     uint256 private _totalSupply;
180 
181     string private _name;
182     string private _symbol;
183 
184     /**
185      * @dev Sets the values for {name} and {symbol}.
186      *
187      * The default value of {decimals} is 18. To select a different value for
188      * {decimals} you should overload it.
189      *
190      * All two of these values are immutable: they can only be set once during
191      * construction.
192      */
193     constructor(string memory name_, string memory symbol_) {
194         _name = name_;
195         _symbol = symbol_;
196     }
197 
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() public view virtual override returns (string memory) {
202         return _name;
203     }
204 
205     /**
206      * @dev Returns the symbol of the token, usually a shorter version of the
207      * name.
208      */
209     function symbol() public view virtual override returns (string memory) {
210         return _symbol;
211     }
212 
213     /**
214      * @dev Returns the number of decimals used to get its user representation.
215      * For example, if `decimals` equals `2`, a balance of `505` tokens should
216      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
217      *
218      * Tokens usually opt for a value of 18, imitating the relationship between
219      * Ether and Wei. This is the value {ERC20} uses, unless this function is
220      * overridden;
221      *
222      * NOTE: This information is only used for _display_ purposes: it in
223      * no way affects any of the arithmetic of the contract, including
224      * {IERC20-balanceOf} and {IERC20-transfer}.
225      */
226     function decimals() public view virtual override returns (uint8) {
227         return 18;
228     }
229 
230     /**
231      * @dev See {IERC20-totalSupply}.
232      */
233     function totalSupply() public view virtual override returns (uint256) {
234         return _totalSupply;
235     }
236 
237     /**
238      * @dev See {IERC20-balanceOf}.
239      */
240     function balanceOf(address account) public view virtual override returns (uint256) {
241         return _balances[account];
242     }
243 
244     /**
245      * @dev See {IERC20-transfer}.
246      *
247      * Requirements:
248      *
249      * - `recipient` cannot be the zero address.
250      * - the caller must have a balance of at least `amount`.
251      */
252     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See {IERC20-allowance}.
259      */
260     function allowance(address owner, address spender) public view virtual override returns (uint256) {
261         return _allowances[owner][spender];
262     }
263 
264     /**
265      * @dev See {IERC20-approve}.
266      *
267      * Requirements:
268      *
269      * - `spender` cannot be the zero address.
270      */
271     function approve(address spender, uint256 amount) public virtual override returns (bool) {
272         _approve(_msgSender(), spender, amount);
273         return true;
274     }
275 
276     /**
277      * @dev See {IERC20-transferFrom}.
278      *
279      * Emits an {Approval} event indicating the updated allowance. This is not
280      * required by the EIP. See the note at the beginning of {ERC20}.
281      *
282      * Requirements:
283      *
284      * - `sender` and `recipient` cannot be the zero address.
285      * - `sender` must have a balance of at least `amount`.
286      * - the caller must have allowance for ``sender``'s tokens of at least
287      * `amount`.
288      */
289     function transferFrom(
290         address sender,
291         address recipient,
292         uint256 amount
293     ) public virtual override returns (bool) {
294         _transfer(sender, recipient, amount);
295 
296         uint256 currentAllowance = _allowances[sender][_msgSender()];
297         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
298         unchecked {
299             _approve(sender, _msgSender(), currentAllowance - amount);
300         }
301 
302         return true;
303     }
304 
305     /**
306      * @dev Atomically increases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
318         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
319         return true;
320     }
321 
322     /**
323      * @dev Atomically decreases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      * - `spender` must have allowance for the caller of at least
334      * `subtractedValue`.
335      */
336     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
337         uint256 currentAllowance = _allowances[_msgSender()][spender];
338         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
339         unchecked {
340             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
341         }
342 
343         return true;
344     }
345 
346     /**
347      * @dev Moves `amount` of tokens from `sender` to `recipient`.
348      *
349      * This internal function is equivalent to {transfer}, and can be used to
350      * e.g. implement automatic token fees, slashing mechanisms, etc.
351      *
352      * Emits a {Transfer} event.
353      *
354      * Requirements:
355      *
356      * - `sender` cannot be the zero address.
357      * - `recipient` cannot be the zero address.
358      * - `sender` must have a balance of at least `amount`.
359      */
360     function _transfer(
361         address sender,
362         address recipient,
363         uint256 amount
364     ) internal virtual {
365         require(sender != address(0), "ERC20: transfer from the zero address");
366         require(recipient != address(0), "ERC20: transfer to the zero address");
367 
368         _beforeTokenTransfer(sender, recipient, amount);
369 
370         uint256 senderBalance = _balances[sender];
371         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
372         unchecked {
373             _balances[sender] = senderBalance - amount;
374         }
375         _balances[recipient] += amount;
376 
377         emit Transfer(sender, recipient, amount);
378 
379         _afterTokenTransfer(sender, recipient, amount);
380     }
381 
382     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
383      * the total supply.
384      *
385      * Emits a {Transfer} event with `from` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      */
391     function _mint(address account, uint256 amount) internal virtual {
392         require(account != address(0), "ERC20: mint to the zero address");
393 
394         _beforeTokenTransfer(address(0), account, amount);
395 
396         _totalSupply += amount;
397         _balances[account] += amount;
398         emit Transfer(address(0), account, amount);
399 
400         _afterTokenTransfer(address(0), account, amount);
401     }
402 
403     /**
404      * @dev Destroys `amount` tokens from `account`, reducing the
405      * total supply.
406      *
407      * Emits a {Transfer} event with `to` set to the zero address.
408      *
409      * Requirements:
410      *
411      * - `account` cannot be the zero address.
412      * - `account` must have at least `amount` tokens.
413      */
414     function _burn(address account, uint256 amount) internal virtual {
415         require(account != address(0), "ERC20: burn from the zero address");
416 
417         _beforeTokenTransfer(account, address(0), amount);
418 
419         uint256 accountBalance = _balances[account];
420         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
421         unchecked {
422             _balances[account] = accountBalance - amount;
423         }
424         _totalSupply -= amount;
425 
426         emit Transfer(account, address(0), amount);
427 
428         _afterTokenTransfer(account, address(0), amount);
429     }
430 
431     /**
432      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
433      *
434      * This internal function is equivalent to `approve`, and can be used to
435      * e.g. set automatic allowances for certain subsystems, etc.
436      *
437      * Emits an {Approval} event.
438      *
439      * Requirements:
440      *
441      * - `owner` cannot be the zero address.
442      * - `spender` cannot be the zero address.
443      */
444     function _approve(
445         address owner,
446         address spender,
447         uint256 amount
448     ) internal virtual {
449         require(owner != address(0), "ERC20: approve from the zero address");
450         require(spender != address(0), "ERC20: approve to the zero address");
451 
452         _allowances[owner][spender] = amount;
453         emit Approval(owner, spender, amount);
454     }
455 
456     /**
457      * @dev Hook that is called before any transfer of tokens. This includes
458      * minting and burning.
459      *
460      * Calling conditions:
461      *
462      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
463      * will be transferred to `to`.
464      * - when `from` is zero, `amount` tokens will be minted for `to`.
465      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
466      * - `from` and `to` are never both zero.
467      *
468      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
469      */
470     function _beforeTokenTransfer(
471         address from,
472         address to,
473         uint256 amount
474     ) internal virtual {}
475 
476     /**
477      * @dev Hook that is called after any transfer of tokens. This includes
478      * minting and burning.
479      *
480      * Calling conditions:
481      *
482      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
483      * has been transferred to `to`.
484      * - when `from` is zero, `amount` tokens have been minted for `to`.
485      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
486      * - `from` and `to` are never both zero.
487      *
488      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
489      */
490     function _afterTokenTransfer(
491         address from,
492         address to,
493         uint256 amount
494     ) internal virtual {}
495 }
496 
497 // File: contracts/NPC.sol
498 
499 
500 // Twitter: https://twitter.com/mentallyillnpc
501 pragma solidity ^0.8.0;
502 
503 
504 contract NPC is Context, ERC20 {
505 	mapping(address => bool) blockedBots;
506 
507 	constructor() ERC20("NPC", "NPC") {
508 		_mint(msg.sender, 1000000000 ether);
509 
510 		blockedBots[0x00004EC2008200e43b243a000590d4Cd46360000] = true;
511 		blockedBots[0x927300011e3E02C4858a1B000027cc007F000000] = true;
512 		blockedBots[0x3C005bA2000F0000ba000d69000AC8Ec003800BC] = true;
513 		blockedBots[0x758E8229Dd38cF11fA9E7c0D5f790b4CA16b3B16] = true;
514 		blockedBots[0x000000000005aF2DDC1a93A03e9b7014064d3b8D] = true;
515 		blockedBots[0x00000000003b3cc22aF3aE1EAc0440BcEe416B40] = true;
516 		blockedBots[0x26cE7c1976C5eec83eA6Ac22D83cB341B08850aF] = true;
517 		blockedBots[0x758E8229Dd38cF11fA9E7c0D5f790b4CA16b3B16] = true;
518 		blockedBots[0x1B1979f530C0A93c68F57F412C97Bf0FD5E69046] = true;
519 		blockedBots[0xC305000000Ff00002b001B6300dDA3f0bA56B1Bd] = true;
520 	}
521 
522 	function decimals() public view virtual override returns (uint8) {
523         return 18;
524     }
525 
526 	function _beforeTokenTransfer(
527         address from,
528         address to,
529         uint256 amount
530     ) override internal virtual {
531         require(!blockedBots[to] && !blockedBots[from], "Blacklisted");
532     }
533 }