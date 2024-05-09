1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
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
28 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
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
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
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
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address sender,
94         address recipient,
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
113 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
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
143 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
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
253      * - `recipient` cannot be the zero address.
254      * - the caller must have a balance of at least `amount`.
255      */
256     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
257         _transfer(_msgSender(), recipient, amount);
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
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function approve(address spender, uint256 amount) public virtual override returns (bool) {
276         _approve(_msgSender(), spender, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-transferFrom}.
282      *
283      * Emits an {Approval} event indicating the updated allowance. This is not
284      * required by the EIP. See the note at the beginning of {ERC20}.
285      *
286      * Requirements:
287      *
288      * - `sender` and `recipient` cannot be the zero address.
289      * - `sender` must have a balance of at least `amount`.
290      * - the caller must have allowance for ``sender``'s tokens of at least
291      * `amount`.
292      */
293     function transferFrom(
294         address sender,
295         address recipient,
296         uint256 amount
297     ) public virtual override returns (bool) {
298         _transfer(sender, recipient, amount);
299 
300         uint256 currentAllowance = _allowances[sender][_msgSender()];
301         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
302         unchecked {
303             _approve(sender, _msgSender(), currentAllowance - amount);
304         }
305 
306         return true;
307     }
308 
309     /**
310      * @dev Atomically increases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
322         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
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
341         uint256 currentAllowance = _allowances[_msgSender()][spender];
342         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
343         unchecked {
344             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
345         }
346 
347         return true;
348     }
349 
350     /**
351      * @dev Moves `amount` of tokens from `sender` to `recipient`.
352      *
353      * This internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `sender` cannot be the zero address.
361      * - `recipient` cannot be the zero address.
362      * - `sender` must have a balance of at least `amount`.
363      */
364     function _transfer(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) internal virtual {
369         require(sender != address(0), "ERC20: transfer from the zero address");
370         require(recipient != address(0), "ERC20: transfer to the zero address");
371 
372         _beforeTokenTransfer(sender, recipient, amount);
373 
374         uint256 senderBalance = _balances[sender];
375         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
376         unchecked {
377             _balances[sender] = senderBalance - amount;
378         }
379         _balances[recipient] += amount;
380 
381         emit Transfer(sender, recipient, amount);
382 
383         _afterTokenTransfer(sender, recipient, amount);
384     }
385 
386     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
387      * the total supply.
388      *
389      * Emits a {Transfer} event with `from` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      */
395     function _mint(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: mint to the zero address");
397 
398         _beforeTokenTransfer(address(0), account, amount);
399 
400         _totalSupply += amount;
401         _balances[account] += amount;
402         emit Transfer(address(0), account, amount);
403 
404         _afterTokenTransfer(address(0), account, amount);
405     }
406 
407     /**
408      * @dev Destroys `amount` tokens from `account`, reducing the
409      * total supply.
410      *
411      * Emits a {Transfer} event with `to` set to the zero address.
412      *
413      * Requirements:
414      *
415      * - `account` cannot be the zero address.
416      * - `account` must have at least `amount` tokens.
417      */
418     function _burn(address account, uint256 amount) internal virtual {
419         require(account != address(0), "ERC20: burn from the zero address");
420 
421         _beforeTokenTransfer(account, address(0), amount);
422 
423         uint256 accountBalance = _balances[account];
424         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
425         unchecked {
426             _balances[account] = accountBalance - amount;
427         }
428         _totalSupply -= amount;
429 
430         emit Transfer(account, address(0), amount);
431 
432         _afterTokenTransfer(account, address(0), amount);
433     }
434 
435     /**
436      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
437      *
438      * This internal function is equivalent to `approve`, and can be used to
439      * e.g. set automatic allowances for certain subsystems, etc.
440      *
441      * Emits an {Approval} event.
442      *
443      * Requirements:
444      *
445      * - `owner` cannot be the zero address.
446      * - `spender` cannot be the zero address.
447      */
448     function _approve(
449         address owner,
450         address spender,
451         uint256 amount
452     ) internal virtual {
453         require(owner != address(0), "ERC20: approve from the zero address");
454         require(spender != address(0), "ERC20: approve to the zero address");
455 
456         _allowances[owner][spender] = amount;
457         emit Approval(owner, spender, amount);
458     }
459 
460     /**
461      * @dev Hook that is called before any transfer of tokens. This includes
462      * minting and burning.
463      *
464      * Calling conditions:
465      *
466      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
467      * will be transferred to `to`.
468      * - when `from` is zero, `amount` tokens will be minted for `to`.
469      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
470      * - `from` and `to` are never both zero.
471      *
472      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
473      */
474     function _beforeTokenTransfer(
475         address from,
476         address to,
477         uint256 amount
478     ) internal virtual {}
479 
480     /**
481      * @dev Hook that is called after any transfer of tokens. This includes
482      * minting and burning.
483      *
484      * Calling conditions:
485      *
486      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
487      * has been transferred to `to`.
488      * - when `from` is zero, `amount` tokens have been minted for `to`.
489      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
490      * - `from` and `to` are never both zero.
491      *
492      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
493      */
494     function _afterTokenTransfer(
495         address from,
496         address to,
497         uint256 amount
498     ) internal virtual {}
499 }
500 
501 // File: contracts/token5.sol
502 
503 
504 pragma solidity ^0.8.0;
505 
506 
507 contract Token is ERC20 {
508 
509     constructor () ERC20("JustCarbon Governance Token", "JCG") {
510         _mint(msg.sender, 1000000000 * (10 ** uint256(decimals())));
511     }
512 }