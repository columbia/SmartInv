1 // File: github/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
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
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) external returns (bool);
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
108 
109 pragma solidity ^0.8.0;
110 
111 
112 /**
113  * @dev Interface for the optional metadata functions from the ERC20 standard.
114  *
115  * _Available since v4.1._
116  */
117 interface IERC20Metadata is IERC20 {
118     /**
119      * @dev Returns the name of the token.
120      */
121     function name() external view returns (string memory);
122 
123     /**
124      * @dev Returns the symbol of the token.
125      */
126     function symbol() external view returns (string memory);
127 
128     /**
129      * @dev Returns the decimals places of the token.
130      */
131     function decimals() external view returns (uint8);
132 }
133 
134 
135 pragma solidity ^0.8.0;
136 
137 
138 
139 
140 /**
141  * @dev Implementation of the {IERC20} interface.
142  *
143  * This implementation is agnostic to the way tokens are created. This means
144  * that a supply mechanism has to be added in a derived contract using {_mint}.
145  * For a generic mechanism see {ERC20PresetMinterPauser}.
146  *
147  * TIP: For a detailed writeup see our guide
148  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
149  * to implement supply mechanisms].
150  *
151  * We have followed general OpenZeppelin Contracts guidelines: functions revert
152  * instead returning `false` on failure. This behavior is nonetheless
153  * conventional and does not conflict with the expectations of ERC20
154  * applications.
155  *
156  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
157  * This allows applications to reconstruct the allowance for all accounts just
158  * by listening to said events. Other implementations of the EIP may not emit
159  * these events, as it isn't required by the specification.
160  *
161  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
162  * functions have been added to mitigate the well-known issues around setting
163  * allowances. See {IERC20-approve}.
164  */
165 contract ERC20 is Context, IERC20, IERC20Metadata {
166     mapping(address => uint256) private _balances;
167 
168     mapping(address => mapping(address => uint256)) private _allowances;
169 
170     uint256 private _totalSupply;
171 
172     string private _name;
173     string private _symbol;
174 
175     /**
176      * @dev Sets the values for {name} and {symbol}.
177      *
178      * The default value of {decimals} is 18. To select a different value for
179      * {decimals} you should overload it.
180      *
181      * All two of these values are immutable: they can only be set once during
182      * construction.
183      */
184     constructor(string memory name_, string memory symbol_) {
185         _name = name_;
186         _symbol = symbol_;
187     }
188 
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() public view virtual override returns (string memory) {
193         return _name;
194     }
195 
196     /**
197      * @dev Returns the symbol of the token, usually a shorter version of the
198      * name.
199      */
200     function symbol() public view virtual override returns (string memory) {
201         return _symbol;
202     }
203 
204     /**
205      * @dev Returns the number of decimals used to get its user representation.
206      * For example, if `decimals` equals `2`, a balance of `505` tokens should
207      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
208      *
209      * Tokens usually opt for a value of 18, imitating the relationship between
210      * Ether and Wei. This is the value {ERC20} uses, unless this function is
211      * overridden;
212      *
213      * NOTE: This information is only used for _display_ purposes: it in
214      * no way affects any of the arithmetic of the contract, including
215      * {IERC20-balanceOf} and {IERC20-transfer}.
216      */
217     function decimals() public view virtual override returns (uint8) {
218         return 3;
219     }
220 
221     /**
222      * @dev See {IERC20-totalSupply}.
223      */
224     function totalSupply() public view virtual override returns (uint256) {
225         return _totalSupply;
226     }
227 
228     /**
229      * @dev See {IERC20-balanceOf}.
230      */
231     function balanceOf(address account) public view virtual override returns (uint256) {
232         return _balances[account];
233     }
234 
235     /**
236      * @dev See {IERC20-transfer}.
237      *
238      * Requirements:
239      *
240      * - `recipient` cannot be the zero address.
241      * - the caller must have a balance of at least `amount`.
242      */
243     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
244         _transfer(_msgSender(), recipient, amount);
245         return true;
246     }
247 
248     /**
249      * @dev See {IERC20-allowance}.
250      */
251     function allowance(address owner, address spender) public view virtual override returns (uint256) {
252         return _allowances[owner][spender];
253     }
254 
255     /**
256      * @dev See {IERC20-approve}.
257      *
258      * Requirements:
259      *
260      * - `spender` cannot be the zero address.
261      */
262     function approve(address spender, uint256 amount) public virtual override returns (bool) {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266 
267     /**
268      * @dev See {IERC20-transferFrom}.
269      *
270      * Emits an {Approval} event indicating the updated allowance. This is not
271      * required by the EIP. See the note at the beginning of {ERC20}.
272      *
273      * Requirements:
274      *
275      * - `sender` and `recipient` cannot be the zero address.
276      * - `sender` must have a balance of at least `amount`.
277      * - the caller must have allowance for ``sender``'s tokens of at least
278      * `amount`.
279      */
280     function transferFrom(
281         address sender,
282         address recipient,
283         uint256 amount
284     ) public virtual override returns (bool) {
285         _transfer(sender, recipient, amount);
286 
287         uint256 currentAllowance = _allowances[sender][_msgSender()];
288         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
289         unchecked {
290             _approve(sender, _msgSender(), currentAllowance - amount);
291         }
292 
293         return true;
294     }
295 
296     /**
297      * @dev Atomically increases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to {approve} that can be used as a mitigation for
300      * problems described in {IERC20-approve}.
301      *
302      * Emits an {Approval} event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      */
308     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
309         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
310         return true;
311     }
312 
313     /**
314      * @dev Atomically decreases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      * - `spender` must have allowance for the caller of at least
325      * `subtractedValue`.
326      */
327     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
328         uint256 currentAllowance = _allowances[_msgSender()][spender];
329         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
330         unchecked {
331             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
332         }
333 
334         return true;
335     }
336 
337     /**
338      * @dev Moves `amount` of tokens from `sender` to `recipient`.
339      *
340      * This internal function is equivalent to {transfer}, and can be used to
341      * e.g. implement automatic token fees, slashing mechanisms, etc.
342      *
343      * Emits a {Transfer} event.
344      *
345      * Requirements:
346      *
347      * - `sender` cannot be the zero address.
348      * - `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      */
351     function _transfer(
352         address sender,
353         address recipient,
354         uint256 amount
355     ) internal virtual {
356         require(sender != address(0), "ERC20: transfer from the zero address");
357         require(recipient != address(0), "ERC20: transfer to the zero address");
358 
359         _beforeTokenTransfer(sender, recipient, amount);
360 
361         uint256 senderBalance = _balances[sender];
362         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
363         unchecked {
364             _balances[sender] = senderBalance - amount;
365         }
366         _balances[recipient] += amount;
367 
368         emit Transfer(sender, recipient, amount);
369 
370         _afterTokenTransfer(sender, recipient, amount);
371     }
372 
373     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
374      * the total supply.
375      *
376      * Emits a {Transfer} event with `from` set to the zero address.
377      *
378      * Requirements:
379      *
380      * - `account` cannot be the zero address.
381      */
382     function _mint(address account, uint256 amount) internal virtual {
383         require(account != address(0), "ERC20: mint to the zero address");
384 
385         _beforeTokenTransfer(address(0), account, amount);
386 
387         _totalSupply += amount;
388         _balances[account] += amount;
389         emit Transfer(address(0), account, amount);
390 
391         _afterTokenTransfer(address(0), account, amount);
392     }
393 
394     /**
395      * @dev Destroys `amount` tokens from `account`, reducing the
396      * total supply.
397      *
398      * Emits a {Transfer} event with `to` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      * - `account` must have at least `amount` tokens.
404      */
405     function _burn(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: burn from the zero address");
407 
408         _beforeTokenTransfer(account, address(0), amount);
409 
410         uint256 accountBalance = _balances[account];
411         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
412         unchecked {
413             _balances[account] = accountBalance - amount;
414         }
415         _totalSupply -= amount;
416 
417         emit Transfer(account, address(0), amount);
418 
419         _afterTokenTransfer(account, address(0), amount);
420     }
421 
422     /**
423      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
424      *
425      * This internal function is equivalent to `approve`, and can be used to
426      * e.g. set automatic allowances for certain subsystems, etc.
427      *
428      * Emits an {Approval} event.
429      *
430      * Requirements:
431      *
432      * - `owner` cannot be the zero address.
433      * - `spender` cannot be the zero address.
434      */
435     function _approve(
436         address owner,
437         address spender,
438         uint256 amount
439     ) internal virtual {
440         require(owner != address(0), "ERC20: approve from the zero address");
441         require(spender != address(0), "ERC20: approve to the zero address");
442 
443         _allowances[owner][spender] = amount;
444         emit Approval(owner, spender, amount);
445     }
446 
447     /**
448      * @dev Hook that is called before any transfer of tokens. This includes
449      * minting and burning.
450      *
451      * Calling conditions:
452      *
453      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
454      * will be transferred to `to`.
455      * - when `from` is zero, `amount` tokens will be minted for `to`.
456      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
457      * - `from` and `to` are never both zero.
458      *
459      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
460      */
461     function _beforeTokenTransfer(
462         address from,
463         address to,
464         uint256 amount
465     ) internal virtual {}
466 
467     /**
468      * @dev Hook that is called after any transfer of tokens. This includes
469      * minting and burning.
470      *
471      * Calling conditions:
472      *
473      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
474      * has been transferred to `to`.
475      * - when `from` is zero, `amount` tokens have been minted for `to`.
476      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
477      * - `from` and `to` are never both zero.
478      *
479      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
480      */
481     function _afterTokenTransfer(
482         address from,
483         address to,
484         uint256 amount
485     ) internal virtual {}
486 }
487 
488 
489 pragma solidity ^0.8.0; 
490 
491 
492 contract ATNTToken is ERC20 {
493     uint public INITIAL_SUPPLY = 1000000000000;
494     
495     //constructor() public ERC20("ARTIZEN Token", "ATNT"){
496     constructor() ERC20("ARTIZEN Token", "ATNT"){
497         _mint(msg.sender, INITIAL_SUPPLY);
498     }
499 }