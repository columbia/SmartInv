1 // SPDX-License-Identifier: MIT
2 /**
3    SSSSSSSSSSSSSSS TTTTTTTTTTTTTTTTTTTTTTTDDDDDDDDDDDDD        
4  SS:::::::::::::::ST:::::::::::::::::::::TD::::::::::::DDD     
5 S:::::SSSSSS::::::ST:::::::::::::::::::::TD:::::::::::::::DD   
6 S:::::S     SSSSSSST:::::TT:::::::TT:::::TDDD:::::DDDDD:::::D  
7 S:::::S            TTTTTT  T:::::T  TTTTTT  D:::::D    D:::::D 
8 S:::::S                    T:::::T          D:::::D     D:::::D
9  S::::SSSS                 T:::::T          D:::::D     D:::::D
10   SS::::::SSSSS            T:::::T          D:::::D     D:::::D
11     SSS::::::::SS          T:::::T          D:::::D     D:::::D
12        SSSSSS::::S         T:::::T          D:::::D     D:::::D
13             S:::::S        T:::::T          D:::::D     D:::::D
14             S:::::S        T:::::T          D:::::D    D:::::D 
15 SSSSSSS     S:::::S      TT:::::::TT      DDD:::::DDDDD:::::D  
16 S::::::SSSSSS:::::S      T:::::::::T      D:::::::::::::::DD   
17 S:::::::::::::::SS       T:::::::::T      D::::::::::::DDD     
18  SSSSSSSSSSSSSSS         TTTTTTTTTTT      DDDDDDDDDDDDD        
19 /**
20 pragma solidity ^0.8.15;
21 
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
42 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
43 
44 /**
45  * @dev Interface of the ERC20 standard as defined in the EIP.
46  */
47 interface IERC20 {
48     /**
49      * @dev Returns the amount of tokens in existence.
50      */
51     function totalSupply() external view returns (uint256);
52 
53     /**
54      * @dev Returns the amount of tokens owned by `account`.
55      */
56     function balanceOf(address account) external view returns (uint256);
57 
58     /**
59      * @dev Moves `amount` tokens from the caller's account to `recipient`.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transfer(address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Returns the remaining number of tokens that `spender` will be
69      * allowed to spend on behalf of `owner` through {transferFrom}. This is
70      * zero by default.
71      *
72      * This value changes when {approve} or {transferFrom} are called.
73      */
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     /**
77      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * IMPORTANT: Beware that changing an allowance with this method brings the risk
82      * that someone may use both the old and the new allowance by unfortunate
83      * transaction ordering. One possible solution to mitigate this race
84      * condition is to first reduce the spender's allowance to 0 and set the
85      * desired value afterwards:
86      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
87      *
88      * Emits an {Approval} event.
89      */
90     function approve(address spender, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Moves `amount` tokens from `sender` to `recipient` using the
94      * allowance mechanism. `amount` is then deducted from the caller's
95      * allowance.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address sender,
103         address recipient,
104         uint256 amount
105     ) external returns (bool);
106 
107     /**
108      * @dev Emitted when `value` tokens are moved from one account (`from`) to
109      * another (`to`).
110      *
111      * Note that `value` may be zero.
112      */
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     /**
116      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
117      * a call to {approve}. `value` is the new allowance.
118      */
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
122 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
123 
124 /**
125  * @dev Interface for the optional metadata functions from the ERC20 standard.
126  *
127  * _Available since v4.1._
128  */
129 interface IERC20Metadata is IERC20 {
130     /**
131      * @dev Returns the name of the token.
132      */
133     function name() external view returns (string memory);
134 
135     /**
136      * @dev Returns the symbol of the token.
137      */
138     function symbol() external view returns (string memory);
139 
140     /**
141      * @dev Returns the decimals places of the token.
142      */
143     function decimals() external view returns (uint8);
144 }
145 
146 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
147 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
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
174 pragma solidity ^0.8.15;
175 contract ERC20 is Context, IERC20, IERC20Metadata {
176     mapping(address => uint256) private _balances;
177 
178     mapping(address => mapping(address => uint256)) private _allowances;
179 
180     uint256 private _totalSupply;
181 
182     string private _name;
183     string private _symbol;
184 
185     /**
186      * @dev Sets the values for {name} and {symbol}.
187      *
188      * The default value of {decimals} is 18. To select a different value for
189      * {decimals} you should overload it.
190      *
191      * All two of these values are immutable: they can only be set once during
192      * construction.
193      */
194     constructor(string memory name_, string memory symbol_) {
195         _name = name_;
196         _symbol = symbol_;
197     }
198 
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() public view virtual override returns (string memory) {
203         return _name;
204     }
205 
206     /**
207      * @dev Returns the symbol of the token, usually a shorter version of the
208      * name.
209      */
210     function symbol() public view virtual override returns (string memory) {
211         return _symbol;
212     }
213 
214     /**
215      * @dev Returns the number of decimals used to get its user representation.
216      * For example, if `decimals` equals `2`, a balance of `505` tokens should
217      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
218      *
219      * Tokens usually opt for a value of 18, imitating the relationship between
220      * Ether and Wei. This is the value {ERC20} uses, unless this function is
221      * overridden;
222      *
223      * NOTE: This information is only used for _display_ purposes: it in
224      * no way affects any of the arithmetic of the contract, including
225      * {IERC20-balanceOf} and {IERC20-transfer}.
226      */
227     function decimals() public view virtual override returns (uint8) {
228         return 18;
229     }
230 
231     /**
232      * @dev See {IERC20-totalSupply}.
233      */
234     function totalSupply() public view virtual override returns (uint256) {
235         return _totalSupply;
236     }
237 
238     /**
239      * @dev See {IERC20-balanceOf}.
240      */
241     function balanceOf(address account) public view virtual override returns (uint256) {
242         return _balances[account];
243     }
244 
245     /**
246      * @dev See {IERC20-transfer}.
247      *
248      * Requirements:
249      *
250      * - `recipient` cannot be the zero address.
251      * - the caller must have a balance of at least `amount`.
252      */
253     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
254         _transfer(_msgSender(), recipient, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-allowance}.
260      */
261     function allowance(address owner, address spender) public view virtual override returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     /**
266      * @dev See {IERC20-approve}.
267      *
268      * Requirements:
269      *
270      * - `spender` cannot be the zero address.
271      */
272     function approve(address spender, uint256 amount) public virtual override returns (bool) {
273         _approve(_msgSender(), spender, amount);
274         return true;
275     }
276 
277     /**
278      * @dev See {IERC20-transferFrom}.
279      *
280      * Emits an {Approval} event indicating the updated allowance. This is not
281      * required by the EIP. See the note at the beginning of {ERC20}.
282      *
283      * Requirements:
284      *
285      * - `sender` and `recipient` cannot be the zero address.
286      * - `sender` must have a balance of at least `amount`.
287      * - the caller must have allowance for ``sender``'s tokens of at least
288      * `amount`.
289      */
290     function transferFrom(
291         address sender,
292         address recipient,
293         uint256 amount
294     ) public virtual override returns (bool) {
295         _transfer(sender, recipient, amount);
296 
297         uint256 currentAllowance = _allowances[sender][_msgSender()];
298         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
299         unchecked {
300             _approve(sender, _msgSender(), currentAllowance - amount);
301         }
302 
303         return true;
304     }
305 
306     /**
307      * @dev Atomically increases the allowance granted to `spender` by the caller.
308      *
309      * This is an alternative to {approve} that can be used as a mitigation for
310      * problems described in {IERC20-approve}.
311      *
312      * Emits an {Approval} event indicating the updated allowance.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      */
318     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
319         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
320         return true;
321     }
322 
323     /**
324      * @dev Atomically decreases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      * - `spender` must have allowance for the caller of at least
335      * `subtractedValue`.
336      */
337     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
338         uint256 currentAllowance = _allowances[_msgSender()][spender];
339         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
340         unchecked {
341             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
342         }
343 
344         return true;
345     }
346 
347     /**
348      * @dev Moves `amount` of tokens from `sender` to `recipient`.
349      *
350      * This internal function is equivalent to {transfer}, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a {Transfer} event.
354      *
355      * Requirements:
356      *
357      * - `sender` cannot be the zero address.
358      * - `recipient` cannot be the zero address.
359      * - `sender` must have a balance of at least `amount`.
360      */
361     function _transfer(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) internal virtual {
366         require(sender != address(0), "ERC20: transfer from the zero address");
367         require(recipient != address(0), "ERC20: transfer to the zero address");
368 
369         _beforeTokenTransfer(sender, recipient, amount);
370 
371         uint256 senderBalance = _balances[sender];
372         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
373         unchecked {
374             _balances[sender] = senderBalance - amount;
375         }
376         _balances[recipient] += amount;
377 
378         emit Transfer(sender, recipient, amount);
379 
380         _afterTokenTransfer(sender, recipient, amount);
381     }
382 
383     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
384      * the total supply.
385      *
386      * Emits a {Transfer} event with `from` set to the zero address.
387      *
388      * Requirements:
389      *
390      * - `account` cannot be the zero address.
391      */
392     function _mint(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: mint to the zero address");
394 
395         _beforeTokenTransfer(address(0), account, amount);
396 
397         _totalSupply += amount;
398         _balances[account] += amount;
399         emit Transfer(address(0), account, amount);
400 
401         _afterTokenTransfer(address(0), account, amount);
402     }
403 
404     /**
405      * @dev Destroys `amount` tokens from `account`, reducing the
406      * total supply.
407      *
408      * Emits a {Transfer} event with `to` set to the zero address.
409      *
410      * Requirements:
411      *
412      * - `account` cannot be the zero address.
413      * - `account` must have at least `amount` tokens.
414      */
415     function _burn(address account, uint256 amount) internal virtual {
416         require(account != address(0), "ERC20: burn from the zero address");
417 
418         _beforeTokenTransfer(account, address(0), amount);
419 
420         uint256 accountBalance = _balances[account];
421         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
422         unchecked {
423             _balances[account] = accountBalance - amount;
424         }
425         _totalSupply -= amount;
426 
427         emit Transfer(account, address(0), amount);
428 
429         _afterTokenTransfer(account, address(0), amount);
430     }
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
434      *
435      * This internal function is equivalent to `approve`, and can be used to
436      * e.g. set automatic allowances for certain subsystems, etc.
437      *
438      * Emits an {Approval} event.
439      *
440      * Requirements:
441      *
442      * - `owner` cannot be the zero address.
443      * - `spender` cannot be the zero address.
444      */
445     function _approve(
446         address owner,
447         address spender,
448         uint256 amount
449     ) internal virtual {
450         require(owner != address(0), "ERC20: approve from the zero address");
451         require(spender != address(0), "ERC20: approve to the zero address");
452 
453         _allowances[owner][spender] = amount;
454         emit Approval(owner, spender, amount);
455     }
456 
457     /**
458      * @dev Hook that is called before any transfer of tokens. This includes
459      * minting and burning.
460      *
461      * Calling conditions:
462      *
463      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
464      * will be transferred to `to`.
465      * - when `from` is zero, `amount` tokens will be minted for `to`.
466      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
467      * - `from` and `to` are never both zero.
468      *
469      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
470      */
471     function _beforeTokenTransfer(
472         address from,
473         address to,
474         uint256 amount
475     ) internal virtual {}
476 
477     /**
478      * @dev Hook that is called after any transfer of tokens. This includes
479      * minting and burning.
480      *
481      * Calling conditions:
482      *
483      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
484      * has been transferred to `to`.
485      * - when `from` is zero, `amount` tokens have been minted for `to`.
486      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
487      * - `from` and `to` are never both zero.
488      *
489      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
490      */
491     function _afterTokenTransfer(
492         address from,
493         address to,
494         uint256 amount
495     ) internal virtual {}
496 }
497 // File contracts/stdERC20.sol
498 pragma solidity ^0.8.15;
499 contract STD is ERC20 { 
500     constructor() ERC20("STD", "STD") {
501         _mint(msg.sender, 69000000000 * 10 ** decimals());
502     } 
503 }