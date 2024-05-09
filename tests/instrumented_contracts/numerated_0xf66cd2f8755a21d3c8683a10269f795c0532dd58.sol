1 /** 
2  *  SourceUnit: /Users/macos/dev/cLend/contracts/CoreDAO.sol
3 */
4             
5 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
6 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
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
47      * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
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
88 
89 
90 
91 /** 
92  *  SourceUnit: /Users/macos/dev/cLend/contracts/CoreDAO.sol
93 */
94             
95 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
96 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Provides information about the current execution context, including the
102  * sender of the transaction and its data. While these are generally available
103  * via msg.sender and msg.data, they should not be accessed in such a direct
104  * manner, since when dealing with meta-transactions the account sending and
105  * paying for execution may not be the actual sender (as far as an application
106  * is concerned).
107  *
108  * This contract is only required for intermediate, library-like contracts.
109  */
110 abstract contract Context {
111     function _msgSender() internal view virtual returns (address) {
112         return msg.sender;
113     }
114 
115     function _msgData() internal view virtual returns (bytes calldata) {
116         return msg.data;
117     }
118 }
119 
120 
121 
122 
123 /** 
124  *  SourceUnit: /Users/macos/dev/cLend/contracts/CoreDAO.sol
125 */
126             
127 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
128 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
129 
130 pragma solidity ^0.8.0;
131 
132 ////import "../IERC20.sol";
133 
134 /**
135  * @dev Interface for the optional metadata functions from the ERC20 standard.
136  *
137  * _Available since v4.1._
138  */
139 interface IERC20Metadata is IERC20 {
140     /**
141      * @dev Returns the name of the token.
142      */
143     function name() external view returns (string memory);
144 
145     /**
146      * @dev Returns the symbol of the token.
147      */
148     function symbol() external view returns (string memory);
149 
150     /**
151      * @dev Returns the decimals places of the token.
152      */
153     function decimals() external view returns (uint8);
154 }
155 
156 
157 
158 
159 /** 
160  *  SourceUnit: /Users/macos/dev/cLend/contracts/CoreDAO.sol
161 */
162             
163 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
164 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 ////import "./IERC20.sol";
169 ////import "./extensions/IERC20Metadata.sol";
170 ////import "../../utils/Context.sol";
171 
172 /**
173  * @dev Implementation of the {IERC20} interface.
174  *
175  * This implementation is agnostic to the way tokens are created. This means
176  * that a supply mechanism has to be added in a derived contract using {_mint}.
177  * For a generic mechanism see {ERC20PresetMinterPauser}.
178  *
179  * TIP: For a detailed writeup see our guide
180  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
181  * to implement supply mechanisms].
182  *
183  * We have followed general OpenZeppelin Contracts guidelines: functions revert
184  * instead returning `false` on failure. This behavior is nonetheless
185  * conventional and does not conflict with the expectations of ERC20
186  * applications.
187  *
188  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
189  * This allows applications to reconstruct the allowance for all accounts just
190  * by listening to said events. Other implementations of the EIP may not emit
191  * these events, as it isn't required by the specification.
192  *
193  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
194  * functions have been added to mitigate the well-known issues around setting
195  * allowances. See {IERC20-approve}.
196  */
197 contract ERC20 is Context, IERC20, IERC20Metadata {
198     mapping(address => uint256) private _balances;
199 
200     mapping(address => mapping(address => uint256)) private _allowances;
201 
202     uint256 private _totalSupply;
203 
204     string private _name;
205     string private _symbol;
206 
207     /**
208      * @dev Sets the values for {name} and {symbol}.
209      *
210      * The default value of {decimals} is 18. To select a different value for
211      * {decimals} you should overload it.
212      *
213      * All two of these values are immutable: they can only be set once during
214      * construction.
215      */
216     constructor(string memory name_, string memory symbol_) {
217         _name = name_;
218         _symbol = symbol_;
219     }
220 
221     /**
222      * @dev Returns the name of the token.
223      */
224     function name() public view virtual override returns (string memory) {
225         return _name;
226     }
227 
228     /**
229      * @dev Returns the symbol of the token, usually a shorter version of the
230      * name.
231      */
232     function symbol() public view virtual override returns (string memory) {
233         return _symbol;
234     }
235 
236     /**
237      * @dev Returns the number of decimals used to get its user representation.
238      * For example, if `decimals` equals `2`, a balance of `505` tokens should
239      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
240      *
241      * Tokens usually opt for a value of 18, imitating the relationship between
242      * Ether and Wei. This is the value {ERC20} uses, unless this function is
243      * overridden;
244      *
245      * NOTE: This information is only used for _display_ purposes: it in
246      * no way affects any of the arithmetic of the contract, including
247      * {IERC20-balanceOf} and {IERC20-transfer}.
248      */
249     function decimals() public view virtual override returns (uint8) {
250         return 18;
251     }
252 
253     /**
254      * @dev See {IERC20-totalSupply}.
255      */
256     function totalSupply() public view virtual override returns (uint256) {
257         return _totalSupply;
258     }
259 
260     /**
261      * @dev See {IERC20-balanceOf}.
262      */
263     function balanceOf(address account) public view virtual override returns (uint256) {
264         return _balances[account];
265     }
266 
267     /**
268      * @dev See {IERC20-transfer}.
269      *
270      * Requirements:
271      *
272      * - `recipient` cannot be the zero address.
273      * - the caller must have a balance of at least `amount`.
274      */
275     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
276         _transfer(_msgSender(), recipient, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-allowance}.
282      */
283     function allowance(address owner, address spender) public view virtual override returns (uint256) {
284         return _allowances[owner][spender];
285     }
286 
287     /**
288      * @dev See {IERC20-approve}.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      */
294     function approve(address spender, uint256 amount) public virtual override returns (bool) {
295         _approve(_msgSender(), spender, amount);
296         return true;
297     }
298 
299     /**
300      * @dev See {IERC20-transferFrom}.
301      *
302      * Emits an {Approval} event indicating the updated allowance. This is not
303      * required by the EIP. See the note at the beginning of {ERC20}.
304      *
305      * Requirements:
306      *
307      * - `sender` and `recipient` cannot be the zero address.
308      * - `sender` must have a balance of at least `amount`.
309      * - the caller must have allowance for ``sender``'s tokens of at least
310      * `amount`.
311      */
312     function transferFrom(
313         address sender,
314         address recipient,
315         uint256 amount
316     ) public virtual override returns (bool) {
317         _transfer(sender, recipient, amount);
318 
319         uint256 currentAllowance = _allowances[sender][_msgSender()];
320         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
321         unchecked {
322             _approve(sender, _msgSender(), currentAllowance - amount);
323         }
324 
325         return true;
326     }
327 
328     /**
329      * @dev Atomically increases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      */
340     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
341         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
342         return true;
343     }
344 
345     /**
346      * @dev Atomically decreases the allowance granted to `spender` by the caller.
347      *
348      * This is an alternative to {approve} that can be used as a mitigation for
349      * problems described in {IERC20-approve}.
350      *
351      * Emits an {Approval} event indicating the updated allowance.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      * - `spender` must have allowance for the caller of at least
357      * `subtractedValue`.
358      */
359     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
360         uint256 currentAllowance = _allowances[_msgSender()][spender];
361         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
362         unchecked {
363             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
364         }
365 
366         return true;
367     }
368 
369     /**
370      * @dev Moves `amount` of tokens from `sender` to `recipient`.
371      *
372      * This internal function is equivalent to {transfer}, and can be used to
373      * e.g. implement automatic token fees, slashing mechanisms, etc.
374      *
375      * Emits a {Transfer} event.
376      *
377      * Requirements:
378      *
379      * - `sender` cannot be the zero address.
380      * - `recipient` cannot be the zero address.
381      * - `sender` must have a balance of at least `amount`.
382      */
383     function _transfer(
384         address sender,
385         address recipient,
386         uint256 amount
387     ) internal virtual {
388         require(sender != address(0), "ERC20: transfer from the zero address");
389         require(recipient != address(0), "ERC20: transfer to the zero address");
390 
391         _beforeTokenTransfer(sender, recipient, amount);
392 
393         uint256 senderBalance = _balances[sender];
394         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
395         unchecked {
396             _balances[sender] = senderBalance - amount;
397         }
398         _balances[recipient] += amount;
399 
400         emit Transfer(sender, recipient, amount);
401 
402         _afterTokenTransfer(sender, recipient, amount);
403     }
404 
405     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
406      * the total supply.
407      *
408      * Emits a {Transfer} event with `from` set to the zero address.
409      *
410      * Requirements:
411      *
412      * - `account` cannot be the zero address.
413      */
414     function _mint(address account, uint256 amount) internal virtual {
415         require(account != address(0), "ERC20: mint to the zero address");
416 
417         _beforeTokenTransfer(address(0), account, amount);
418 
419         _totalSupply += amount;
420         _balances[account] += amount;
421         emit Transfer(address(0), account, amount);
422 
423         _afterTokenTransfer(address(0), account, amount);
424     }
425 
426     /**
427      * @dev Destroys `amount` tokens from `account`, reducing the
428      * total supply.
429      *
430      * Emits a {Transfer} event with `to` set to the zero address.
431      *
432      * Requirements:
433      *
434      * - `account` cannot be the zero address.
435      * - `account` must have at least `amount` tokens.
436      */
437     function _burn(address account, uint256 amount) internal virtual {
438         require(account != address(0), "ERC20: burn from the zero address");
439 
440         _beforeTokenTransfer(account, address(0), amount);
441 
442         uint256 accountBalance = _balances[account];
443         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
444         unchecked {
445             _balances[account] = accountBalance - amount;
446         }
447         _totalSupply -= amount;
448 
449         emit Transfer(account, address(0), amount);
450 
451         _afterTokenTransfer(account, address(0), amount);
452     }
453 
454     /**
455      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
456      *
457      * This internal function is equivalent to `approve`, and can be used to
458      * e.g. set automatic allowances for certain subsystems, etc.
459      *
460      * Emits an {Approval} event.
461      *
462      * Requirements:
463      *
464      * - `owner` cannot be the zero address.
465      * - `spender` cannot be the zero address.
466      */
467     function _approve(
468         address owner,
469         address spender,
470         uint256 amount
471     ) internal virtual {
472         require(owner != address(0), "ERC20: approve from the zero address");
473         require(spender != address(0), "ERC20: approve to the zero address");
474 
475         _allowances[owner][spender] = amount;
476         emit Approval(owner, spender, amount);
477     }
478 
479     /**
480      * @dev Hook that is called before any transfer of tokens. This includes
481      * minting and burning.
482      *
483      * Calling conditions:
484      *
485      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
486      * will be transferred to `to`.
487      * - when `from` is zero, `amount` tokens will be minted for `to`.
488      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
489      * - `from` and `to` are never both zero.
490      *
491      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
492      */
493     function _beforeTokenTransfer(
494         address from,
495         address to,
496         uint256 amount
497     ) internal virtual {}
498 
499     /**
500      * @dev Hook that is called after any transfer of tokens. This includes
501      * minting and burning.
502      *
503      * Calling conditions:
504      *
505      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
506      * has been transferred to `to`.
507      * - when `from` is zero, `amount` tokens have been minted for `to`.
508      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
509      * - `from` and `to` are never both zero.
510      *
511      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
512      */
513     function _afterTokenTransfer(
514         address from,
515         address to,
516         uint256 amount
517     ) internal virtual {}
518 }
519 
520 
521 /** 
522  *  SourceUnit: /Users/macos/dev/cLend/contracts/CoreDAO.sol
523 */
524 
525 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: UNLICENSED
526 pragma solidity =0.8.6;
527 
528 ////import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
529 
530 /**
531  * @title CoreDAO ERC20 Governance Token
532  * @author CVault Finance
533  */
534 contract CoreDAO is ERC20 {
535     address public constant CORE_DAO_TREASURY = 0xe508a37101FCe81AB412626eE5F1A648244380de;
536 
537     constructor(uint256 startingCOREDAOAmount) ERC20("CORE DAO", "CoreDAO") {
538         _mint(CORE_DAO_TREASURY, startingCOREDAOAmount);
539     }
540 
541     function issue(address to, uint256 amount) public {
542         require(msg.sender == CORE_DAO_TREASURY, "NOT_TREASURY");
543         _mint(to, amount);
544     }
545 
546     function burn(uint256 amount) public {
547         _burn(msg.sender, amount);
548     }
549 }