1 /**
2 
3 
4 The main component of bones is calcium carbonate, and the chemical elements they contain are mainly carbon, oxygen, calcium and other trace elements.
5 $BONE $CAL $OXY
6 
7 https://t.me/Oxygen_erc
8 https://twitter.com/Oxygen_erc
9 https://oxytoken.vip/
10 
11 
12 // SPDX-License-Identifier: MIT
13 /**
14 pragma solidity ^0.8.20;
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 
36 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
37 
38 
39 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
40 
41 pragma solidity ^0.8.20;
42 
43 /**
44  * @dev Interface of the ERC20 standard as defined in the EIP.
45  */
46 interface IERC20 {
47     /**
48      * @dev Returns the amount of tokens in existence.
49      */
50     function totalSupply() external view returns (uint256);
51 
52     /**
53      * @dev Returns the amount of tokens owned by `account`.
54      */
55     function balanceOf(address account) external view returns (uint256);
56 
57     /**
58      * @dev Moves `amount` tokens from the caller's account to `recipient`.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Returns the remaining number of tokens that `spender` will be
68      * allowed to spend on behalf of `owner` through {transferFrom}. This is
69      * zero by default.
70      *
71      * This value changes when {approve} or {transferFrom} are called.
72      */
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     /**
76      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * IMPORTANT: Beware that changing an allowance with this method brings the risk
81      * that someone may use both the old and the new allowance by unfortunate
82      * transaction ordering. One possible solution to mitigate this race
83      * condition is to first reduce the spender's allowance to 0 and set the
84      * desired value afterwards:
85      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86      *
87      * Emits an {Approval} event.
88      */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Moves `amount` tokens from `sender` to `recipient` using the
93      * allowance mechanism. `amount` is then deducted from the caller's
94      * allowance.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address sender,
102         address recipient,
103         uint256 amount
104     ) external returns (bool);
105 
106     /**
107      * @dev Emitted when `value` tokens are moved from one account (`from`) to
108      * another (`to`).
109      *
110      * Note that `value` may be zero.
111      */
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 
114     /**
115      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
116      * a call to {approve}. `value` is the new allowance.
117      */
118     event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 
122 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
123 
124 
125 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
126 
127 pragma solidity ^0.8.20;
128 
129 /**
130  * @dev Interface for the optional metadata functions from the ERC20 standard.
131  *
132  * _Available since v4.1._
133  */
134 interface IERC20Metadata is IERC20 {
135     /**
136      * @dev Returns the name of the token.
137      */
138     function name() external view returns (string memory);
139 
140     /**
141      * @dev Returns the symbol of the token.
142      */
143     function symbol() external view returns (string memory);
144 
145     /**
146      * @dev Returns the decimals places of the token.
147      */
148     function decimals() external view returns (uint8);
149 }
150 
151 
152 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
153 
154 
155 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
156 
157 pragma solidity ^0.8.20;
158 
159 
160 
161 /**
162  * @dev Implementation of the {IERC20} interface.
163  *
164  * This implementation is agnostic to the way tokens are created. This means
165  * that a supply mechanism has to be added in a derived contract using {_mint}.
166  * For a generic mechanism see {ERC20PresetMinterPauser}.
167  *
168  * TIP: For a detailed writeup see our guide
169  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
170  * to implement supply mechanisms].
171  *
172  * We have followed general OpenZeppelin Contracts guidelines: functions revert
173  * instead returning `false` on failure. This behavior is nonetheless
174  * conventional and does not conflict with the expectations of ERC20
175  * applications.
176  *
177  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
178  * This allows applications to reconstruct the allowance for all accounts just
179  * by listening to said events. Other implementations of the EIP may not emit
180  * these events, as it isn't required by the specification.
181  *
182  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
183  * functions have been added to mitigate the well-known issues around setting
184  * allowances. See {IERC20-approve}.
185  */
186 contract ERC20 is Context, IERC20, IERC20Metadata {
187     mapping(address => uint256) private _balances;
188 
189     mapping(address => mapping(address => uint256)) private _allowances;
190 
191     uint256 private _totalSupply;
192 
193     string private _name;
194     string private _symbol;
195 
196     /**
197      * @dev Sets the values for {name} and {symbol}.
198      *
199      * The default value of {decimals} is 18. To select a different value for
200      * {decimals} you should overload it.
201      *
202      * All two of these values are immutable: they can only be set once during
203      * construction.
204      */
205     constructor(string memory name_, string memory symbol_) {
206         _name = name_;
207         _symbol = symbol_;
208     }
209 
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() public view virtual override returns (string memory) {
214         return _name;
215     }
216 
217     /**
218      * @dev Returns the symbol of the token, usually a shorter version of the
219      * name.
220      */
221     function symbol() public view virtual override returns (string memory) {
222         return _symbol;
223     }
224 
225     /**
226      * @dev Returns the number of decimals used to get its user representation.
227      * For example, if `decimals` equals `2`, a balance of `505` tokens should
228      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
229      *
230      * Tokens usually opt for a value of 18, imitating the relationship between
231      * Ether and Wei. This is the value {ERC20} uses, unless this function is
232      * overridden;
233      *
234      * NOTE: This information is only used for _display_ purposes: it in
235      * no way affects any of the arithmetic of the contract, including
236      * {IERC20-balanceOf} and {IERC20-transfer}.
237      */
238     function decimals() public view virtual override returns (uint8) {
239         return 18;
240     }
241 
242     /**
243      * @dev See {IERC20-totalSupply}.
244      */
245     function totalSupply() public view virtual override returns (uint256) {
246         return _totalSupply;
247     }
248 
249     /**
250      * @dev See {IERC20-balanceOf}.
251      */
252     function balanceOf(address account) public view virtual override returns (uint256) {
253         return _balances[account];
254     }
255 
256     /**
257      * @dev See {IERC20-transfer}.
258      *
259      * Requirements:
260      *
261      * - `recipient` cannot be the zero address.
262      * - the caller must have a balance of at least `amount`.
263      */
264     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268 
269     /**
270      * @dev See {IERC20-allowance}.
271      */
272     function allowance(address owner, address spender) public view virtual override returns (uint256) {
273         return _allowances[owner][spender];
274     }
275 
276     /**
277      * @dev See {IERC20-approve}.
278      *
279      * Requirements:
280      *
281      * - `spender` cannot be the zero address.
282      */
283     function approve(address spender, uint256 amount) public virtual override returns (bool) {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287 
288     /**
289      * @dev See {IERC20-transferFrom}.
290      *
291      * Emits an {Approval} event indicating the updated allowance. This is not
292      * required by the EIP. See the note at the beginning of {ERC20}.
293      *
294      * Requirements:
295      *
296      * - `sender` and `recipient` cannot be the zero address.
297      * - `sender` must have a balance of at least `amount`.
298      * - the caller must have allowance for ``sender``'s tokens of at least
299      * `amount`.
300      */
301     function transferFrom(
302         address sender,
303         address recipient,
304         uint256 amount
305     ) public virtual override returns (bool) {
306         _transfer(sender, recipient, amount);
307 
308         uint256 currentAllowance = _allowances[sender][_msgSender()];
309         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
310         unchecked {
311             _approve(sender, _msgSender(), currentAllowance - amount);
312         }
313 
314         return true;
315     }
316 
317     /**
318      * @dev Atomically increases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      */
329     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
330         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
331         return true;
332     }
333 
334     /**
335      * @dev Atomically decreases the allowance granted to `spender` by the caller.
336      *
337      * This is an alternative to {approve} that can be used as a mitigation for
338      * problems described in {IERC20-approve}.
339      *
340      * Emits an {Approval} event indicating the updated allowance.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      * - `spender` must have allowance for the caller of at least
346      * `subtractedValue`.
347      */
348     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
349         uint256 currentAllowance = _allowances[_msgSender()][spender];
350         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
351         unchecked {
352             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
353         }
354 
355         return true;
356     }
357 
358     /**
359      * @dev Moves `amount` of tokens from `sender` to `recipient`.
360      *
361      * This internal function is equivalent to {transfer}, and can be used to
362      * e.g. implement automatic token fees, slashing mechanisms, etc.
363      *
364      * Emits a {Transfer} event.
365      *
366      * Requirements:
367      *
368      * - `sender` cannot be the zero address.
369      * - `recipient` cannot be the zero address.
370      * - `sender` must have a balance of at least `amount`.
371      */
372     function _transfer(
373         address sender,
374         address recipient,
375         uint256 amount
376     ) internal virtual {
377         require(sender != address(0), "ERC20: transfer from the zero address");
378         require(recipient != address(0), "ERC20: transfer to the zero address");
379 
380         _beforeTokenTransfer(sender, recipient, amount);
381 
382         uint256 senderBalance = _balances[sender];
383         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
384         unchecked {
385             _balances[sender] = senderBalance - amount;
386         }
387         _balances[recipient] += amount;
388 
389         emit Transfer(sender, recipient, amount);
390 
391         _afterTokenTransfer(sender, recipient, amount);
392     }
393 
394     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
395      * the total supply.
396      *
397      * Emits a {Transfer} event with `from` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      */
403     function _mint(address account, uint256 amount) internal virtual {
404         require(account != address(0), "ERC20: mint to the zero address");
405 
406         _beforeTokenTransfer(address(0), account, amount);
407 
408         _totalSupply += amount;
409         _balances[account] += amount;
410         emit Transfer(address(0), account, amount);
411 
412         _afterTokenTransfer(address(0), account, amount);
413     }
414 
415     /**
416      * @dev Destroys `amount` tokens from `account`, reducing the
417      * total supply.
418      *
419      * Emits a {Transfer} event with `to` set to the zero address.
420      *
421      * Requirements:
422      *
423      * - `account` cannot be the zero address.
424      * - `account` must have at least `amount` tokens.
425      */
426     function _burn(address account, uint256 amount) internal virtual {
427         require(account != address(0), "ERC20: burn from the zero address");
428 
429         _beforeTokenTransfer(account, address(0), amount);
430 
431         uint256 accountBalance = _balances[account];
432         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
433         unchecked {
434             _balances[account] = accountBalance - amount;
435         }
436         _totalSupply -= amount;
437 
438         emit Transfer(account, address(0), amount);
439 
440         _afterTokenTransfer(account, address(0), amount);
441     }
442 
443     /**
444      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
445      *
446      * This internal function is equivalent to `approve`, and can be used to
447      * e.g. set automatic allowances for certain subsystems, etc.
448      *
449      * Emits an {Approval} event.
450      *
451      * Requirements:
452      *
453      * - `owner` cannot be the zero address.
454      * - `spender` cannot be the zero address.
455      */
456     function _approve(
457         address owner,
458         address spender,
459         uint256 amount
460     ) internal virtual {
461         require(owner != address(0), "ERC20: approve from the zero address");
462         require(spender != address(0), "ERC20: approve to the zero address");
463 
464         _allowances[owner][spender] = amount;
465         emit Approval(owner, spender, amount);
466     }
467 
468     /**
469      * @dev Hook that is called before any transfer of tokens. This includes
470      * minting and burning.
471      *
472      * Calling conditions:
473      *
474      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
475      * will be transferred to `to`.
476      * - when `from` is zero, `amount` tokens will be minted for `to`.
477      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
478      * - `from` and `to` are never both zero.
479      *
480      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
481      */
482     function _beforeTokenTransfer(
483         address from,
484         address to,
485         uint256 amount
486     ) internal virtual {}
487 
488     /**
489      * @dev Hook that is called after any transfer of tokens. This includes
490      * minting and burning.
491      *
492      * Calling conditions:
493      *
494      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
495      * has been transferred to `to`.
496      * - when `from` is zero, `amount` tokens have been minted for `to`.
497      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
498      * - `from` and `to` are never both zero.
499      *
500      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
501      */
502     function _afterTokenTransfer(
503         address from,
504         address to,
505         uint256 amount
506     ) internal virtual {}
507 }
508 
509 
510 // File contracts/baped.sol
511 
512 pragma solidity ^0.8.20;
513 
514 contract Oxygen is ERC20 { 
515     constructor() ERC20(unicode"Oxygen", "OXY") {
516         _mint(msg.sender, 420690000 * 10 ** decimals());
517     } 
518 }