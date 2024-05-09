1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
2 // SPDX-License-Identifier: MIT
3 
4 
5 
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
23         return msg.data;
24     }
25 }
26 
27 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
28 
29 
30 
31 
32 
33 
34 /**
35  * @dev Interface for the optional metadata functions from the ERC20 standard.
36  *
37  * _Available since v4.1._
38  */
39 
40 
41 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
42 
43 
44 
45 
46 /**
47  * @dev Interface of the ERC20 standard as defined in the EIP.
48  */
49 interface IERC20 {
50     /**
51      * @dev Returns the amount of tokens in existence.
52      */
53     function totalSupply() external view returns (uint256);
54 
55     /**
56      * @dev Returns the amount of tokens owned by `account`.
57      */
58     function balanceOf(address account) external view returns (uint256);
59 
60     /**
61      * @dev Moves `amount` tokens from the caller's account to `recipient`.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     /**
79      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * IMPORTANT: Beware that changing an allowance with this method brings the risk
84      * that someone may use both the old and the new allowance by unfortunate
85      * transaction ordering. One possible solution to mitigate this race
86      * condition is to first reduce the spender's allowance to 0 and set the
87      * desired value afterwards:
88      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Moves `amount` tokens from `sender` to `recipient` using the
96      * allowance mechanism. `amount` is then deducted from the caller's
97      * allowance.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address sender,
105         address recipient,
106         uint256 amount
107     ) external returns (bool);
108 
109     /**
110      * @dev Emitted when `value` tokens are moved from one account (`from`) to
111      * another (`to`).
112      *
113      * Note that `value` may be zero.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 
117     /**
118      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
119      * a call to {approve}. `value` is the new allowance.
120      */
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
125 
126 
127 
128 
129 
130 
131 
132 
133 /**
134  * @dev Implementation of the {IERC20} interface.
135  *
136  * This implementation is agnostic to the way tokens are created. This means
137  * that a supply mechanism has to be added in a derived contract using {_mint}.
138  * For a generic mechanism see {ERC20PresetMinterPauser}.
139  *
140  * TIP: For a detailed writeup see our guide
141  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
142  * to implement supply mechanisms].
143  *
144  * We have followed general OpenZeppelin guidelines: functions revert instead
145  * of returning `false` on failure. This behavior is nonetheless conventional
146  * and does not conflict with the expectations of ERC20 applications.
147  *
148  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
149  * This allows applications to reconstruct the allowance for all accounts just
150  * by listening to said events. Other implementations of the EIP may not emit
151  * these events, as it isn't required by the specification.
152  *
153  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
154  * functions have been added to mitigate the well-known issues around setting
155  * allowances. See {IERC20-approve}.
156  */
157  interface IERC20Metadata is IERC20 {
158     /**
159      * @dev Returns the name of the token.
160      */
161     function name() external view returns (string memory);
162 
163     /**
164      * @dev Returns the symbol of the token.
165      */
166     function symbol() external view returns (string memory);
167 
168     /**
169      * @dev Returns the decimals places of the token.
170      */
171     function decimals() external view returns (uint8);
172 }
173 contract ERC20 is Context, IERC20, IERC20Metadata {
174     mapping(address => uint256) private _balances;
175 
176     mapping(address => mapping(address => uint256)) private _allowances;
177 
178     uint256 private _totalSupply;
179 
180     string private _name;
181     string private _symbol;
182 
183     /**
184      * @dev Sets the values for {name} and {symbol}.
185      *
186      * The default value of {decimals} is 18. To select a different value for
187      * {decimals} you should overload it.
188      *
189      * All two of these values are immutable: they can only be set once during
190      * construction.
191      */
192     constructor(string memory name_, string memory symbol_) {
193         _name = name_;
194         _symbol = symbol_;
195     }
196 
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() public view virtual override returns (string memory) {
201         return _name;
202     }
203 
204     /**
205      * @dev Returns the symbol of the token, usually a shorter version of the
206      * name.
207      */
208     function symbol() public view virtual override returns (string memory) {
209         return _symbol;
210     }
211 
212     /**
213      * @dev Returns the number of decimals used to get its user representation.
214      * For example, if `decimals` equals `2`, a balance of `505` tokens should
215      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
216      *
217      * Tokens usually opt for a value of 18, imitating the relationship between
218      * Ether and Wei. This is the value {ERC20} uses, unless this function is
219      * overridden;
220      *
221      * NOTE: This information is only used for _display_ purposes: it in
222      * no way affects any of the arithmetic of the contract, including
223      * {IERC20-balanceOf} and {IERC20-transfer}.
224      */
225     function decimals() public view virtual override returns (uint8) {
226         return 18;
227     }
228 
229     /**
230      * @dev See {IERC20-totalSupply}.
231      */
232     function totalSupply() public view virtual override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev See {IERC20-balanceOf}.
238      */
239     function balanceOf(address account) public view virtual override returns (uint256) {
240         return _balances[account];
241     }
242 
243     /**
244      * @dev See {IERC20-transfer}.
245      *
246      * Requirements:
247      *
248      * - `recipient` cannot be the zero address.
249      * - the caller must have a balance of at least `amount`.
250      */
251     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See {IERC20-allowance}.
258      */
259     function allowance(address owner, address spender) public view virtual override returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     /**
264      * @dev See {IERC20-approve}.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function approve(address spender, uint256 amount) public virtual override returns (bool) {
271         _approve(_msgSender(), spender, amount);
272         return true;
273     }
274 
275     /**
276      * @dev See {IERC20-transferFrom}.
277      *
278      * Emits an {Approval} event indicating the updated allowance. This is not
279      * required by the EIP. See the note at the beginning of {ERC20}.
280      *
281      * Requirements:
282      *
283      * - `sender` and `recipient` cannot be the zero address.
284      * - `sender` must have a balance of at least `amount`.
285      * - the caller must have allowance for ``sender``'s tokens of at least
286      * `amount`.
287      */
288     function transferFrom(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) public virtual override returns (bool) {
293         _transfer(sender, recipient, amount);
294 
295         uint256 currentAllowance = _allowances[sender][_msgSender()];
296         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
297         unchecked {
298             _approve(sender, _msgSender(), currentAllowance - amount);
299         }
300 
301         return true;
302     }
303 
304     /**
305      * @dev Atomically increases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
317         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
318         return true;
319     }
320 
321     /**
322      * @dev Atomically decreases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      * - `spender` must have allowance for the caller of at least
333      * `subtractedValue`.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         uint256 currentAllowance = _allowances[_msgSender()][spender];
337         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
338         unchecked {
339             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
340         }
341 
342         return true;
343     }
344 
345     /**
346      * @dev Moves `amount` of tokens from `sender` to `recipient`.
347      *
348      * This internal function is equivalent to {transfer}, and can be used to
349      * e.g. implement automatic token fees, slashing mechanisms, etc.
350      *
351      * Emits a {Transfer} event.
352      *
353      * Requirements:
354      *
355      * - `sender` cannot be the zero address.
356      * - `recipient` cannot be the zero address.
357      * - `sender` must have a balance of at least `amount`.
358      */
359     function _transfer(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) internal virtual {
364         require(sender != address(0), "ERC20: transfer from the zero address");
365         require(recipient != address(0), "ERC20: transfer to the zero address");
366 
367         _beforeTokenTransfer(sender, recipient, amount);
368 
369         uint256 senderBalance = _balances[sender];
370         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
371         unchecked {
372             _balances[sender] = senderBalance - amount;
373         }
374         _balances[recipient] += amount;
375 
376         emit Transfer(sender, recipient, amount);
377 
378         _afterTokenTransfer(sender, recipient, amount);
379     }
380 
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a {Transfer} event with `from` set to the zero address.
385      *
386      * Requirements:
387      *
388      * - `account` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: mint to the zero address");
392 
393         _beforeTokenTransfer(address(0), account, amount);
394 
395         _totalSupply += amount;
396         _balances[account] += amount;
397         emit Transfer(address(0), account, amount);
398 
399         _afterTokenTransfer(address(0), account, amount);
400     }
401 
402     /**
403      * @dev Destroys `amount` tokens from `account`, reducing the
404      * total supply.
405      *
406      * Emits a {Transfer} event with `to` set to the zero address.
407      *
408      * Requirements:
409      *
410      * - `account` cannot be the zero address.
411      * - `account` must have at least `amount` tokens.
412      */
413     function _burn(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: burn from the zero address");
415 
416         _beforeTokenTransfer(account, address(0), amount);
417 
418         uint256 accountBalance = _balances[account];
419         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
420         unchecked {
421             _balances[account] = accountBalance - amount;
422         }
423         _totalSupply -= amount;
424 
425         emit Transfer(account, address(0), amount);
426 
427         _afterTokenTransfer(account, address(0), amount);
428     }
429 
430     /**
431      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
432      *
433      * This internal function is equivalent to `approve`, and can be used to
434      * e.g. set automatic allowances for certain subsystems, etc.
435      *
436      * Emits an {Approval} event.
437      *
438      * Requirements:
439      *
440      * - `owner` cannot be the zero address.
441      * - `spender` cannot be the zero address.
442      */
443     function _approve(
444         address owner,
445         address spender,
446         uint256 amount
447     ) internal virtual {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450 
451         _allowances[owner][spender] = amount;
452         emit Approval(owner, spender, amount);
453     }
454 
455     /**
456      * @dev Hook that is called before any transfer of tokens. This includes
457      * minting and burning.
458      *
459      * Calling conditions:
460      *
461      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
462      * will be transferred to `to`.
463      * - when `from` is zero, `amount` tokens will be minted for `to`.
464      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
465      * - `from` and `to` are never both zero.
466      *
467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
468      */
469     function _beforeTokenTransfer(
470         address from,
471         address to,
472         uint256 amount
473     ) internal virtual {}
474 
475     /**
476      * @dev Hook that is called after any transfer of tokens. This includes
477      * minting and burning.
478      *
479      * Calling conditions:
480      *
481      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
482      * has been transferred to `to`.
483      * - when `from` is zero, `amount` tokens have been minted for `to`.
484      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
485      * - `from` and `to` are never both zero.
486      *
487      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
488      */
489     function _afterTokenTransfer(
490         address from,
491         address to,
492         uint256 amount
493     ) internal virtual {}
494 }
495 
496 // File: Simp69.sol
497 pragma solidity ^0.8.9;
498 
499 contract SIMP69 is ERC20{
500 
501 constructor() ERC20('One Percent for Irene','SIMP'){
502     _mint(msg.sender,69696969696969 * 10**18);
503 }
504 }