1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.20;
4 
5 /**
6  */
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 
18 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
19 
20 
21 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
22 
23 pragma solidity ^0.8.20;
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 
104 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
105 
106 
107 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
108 
109 pragma solidity ^0.8.20;
110 
111 /**
112  * @dev Interface for the optional metadata functions from the ERC20 standard.
113  *
114  * _Available since v4.1._
115  */
116 interface IERC20Metadata is IERC20 {
117     /**
118      * @dev Returns the name of the token.
119      */
120     function name() external view returns (string memory);
121 
122     /**
123      * @dev Returns the symbol of the token.
124      */
125     function symbol() external view returns (string memory);
126 
127     /**
128      * @dev Returns the decimals places of the token.
129      */
130     function decimals() external view returns (uint8);
131 }
132 
133 
134 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
135 
136 
137 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
138 
139 pragma solidity ^0.8.20;
140 
141 
142 
143 /**
144  * @dev Implementation of the {IERC20} interface.
145  *
146  * This implementation is agnostic to the way tokens are created. This means
147  * that a supply mechanism has to be added in a derived contract using {_mint}.
148  * For a generic mechanism see {ERC20PresetMinterPauser}.
149  *
150  * TIP: For a detailed writeup see our guide
151  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
152  * to implement supply mechanisms].
153  *
154  * We have followed general OpenZeppelin Contracts guidelines: functions revert
155  * instead returning `false` on failure. This behavior is nonetheless
156  * conventional and does not conflict with the expectations of ERC20
157  * applications.
158  *
159  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
160  * This allows applications to reconstruct the allowance for all accounts just
161  * by listening to said events. Other implementations of the EIP may not emit
162  * these events, as it isn't required by the specification.
163  *
164  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
165  * functions have been added to mitigate the well-known issues around setting
166  * allowances. See {IERC20-approve}.
167  */
168 contract ERC20 is Context, IERC20, IERC20Metadata {
169     mapping(address => uint256) private _balances;
170 
171     mapping(address => mapping(address => uint256)) private _allowances;
172 
173     uint256 private _totalSupply;
174 
175     string private _name;
176     string private _symbol;
177 
178     /**
179      * @dev Sets the values for {name} and {symbol}.
180      *
181      * The default value of {decimals} is 18. To select a different value for
182      * {decimals} you should overload it.
183      *
184      * All two of these values are immutable: they can only be set once during
185      * construction.
186      */
187     constructor(string memory name_, string memory symbol_) {
188         _name = name_;
189         _symbol = symbol_;
190     }
191 
192     /**
193      * @dev Returns the name of the token.
194      */
195     function name() public view virtual override returns (string memory) {
196         return _name;
197     }
198 
199     /**
200      * @dev Returns the symbol of the token, usually a shorter version of the
201      * name.
202      */
203     function symbol() public view virtual override returns (string memory) {
204         return _symbol;
205     }
206 
207     /**
208      * @dev Returns the number of decimals used to get its user representation.
209      * For example, if `decimals` equals `2`, a balance of `505` tokens should
210      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
211      *
212      * Tokens usually opt for a value of 18, imitating the relationship between
213      * Ether and Wei. This is the value {ERC20} uses, unless this function is
214      * overridden;
215      *
216      * NOTE: This information is only used for _display_ purposes: it in
217      * no way affects any of the arithmetic of the contract, including
218      * {IERC20-balanceOf} and {IERC20-transfer}.
219      */
220     function decimals() public view virtual override returns (uint8) {
221         return 18;
222     }
223 
224     /**
225      * @dev See {IERC20-totalSupply}.
226      */
227     function totalSupply() public view virtual override returns (uint256) {
228         return _totalSupply;
229     }
230 
231     /**
232      * @dev See {IERC20-balanceOf}.
233      */
234     function balanceOf(address account) public view virtual override returns (uint256) {
235         return _balances[account];
236     }
237 
238     /**
239      * @dev See {IERC20-transfer}.
240      *
241      * Requirements:
242      *
243      * - `recipient` cannot be the zero address.
244      * - the caller must have a balance of at least `amount`.
245      */
246     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-allowance}.
253      */
254     function allowance(address owner, address spender) public view virtual override returns (uint256) {
255         return _allowances[owner][spender];
256     }
257 
258     /**
259      * @dev See {IERC20-approve}.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      */
265     function approve(address spender, uint256 amount) public virtual override returns (bool) {
266         _approve(_msgSender(), spender, amount);
267         return true;
268     }
269 
270     /**
271      * @dev See {IERC20-transferFrom}.
272      *
273      * Emits an {Approval} event indicating the updated allowance. This is not
274      * required by the EIP. See the note at the beginning of {ERC20}.
275      *
276      * Requirements:
277      *
278      * - `sender` and `recipient` cannot be the zero address.
279      * - `sender` must have a balance of at least `amount`.
280      * - the caller must have allowance for ``sender``'s tokens of at least
281      * `amount`.
282      */
283     function transferFrom(
284         address sender,
285         address recipient,
286         uint256 amount
287     ) public virtual override returns (bool) {
288         _transfer(sender, recipient, amount);
289 
290         uint256 currentAllowance = _allowances[sender][_msgSender()];
291         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
292         unchecked {
293             _approve(sender, _msgSender(), currentAllowance - amount);
294         }
295 
296         return true;
297     }
298 
299     /**
300      * @dev Atomically increases the allowance granted to `spender` by the caller.
301      *
302      * This is an alternative to {approve} that can be used as a mitigation for
303      * problems described in {IERC20-approve}.
304      *
305      * Emits an {Approval} event indicating the updated allowance.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      */
311     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
312         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
313         return true;
314     }
315 
316     /**
317      * @dev Atomically decreases the allowance granted to `spender` by the caller.
318      *
319      * This is an alternative to {approve} that can be used as a mitigation for
320      * problems described in {IERC20-approve}.
321      *
322      * Emits an {Approval} event indicating the updated allowance.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      * - `spender` must have allowance for the caller of at least
328      * `subtractedValue`.
329      */
330     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
331         uint256 currentAllowance = _allowances[_msgSender()][spender];
332         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
333         unchecked {
334             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
335         }
336 
337         return true;
338     }
339 
340     /**
341      * @dev Moves `amount` of tokens from `sender` to `recipient`.
342      *
343      * This internal function is equivalent to {transfer}, and can be used to
344      * e.g. implement automatic token fees, slashing mechanisms, etc.
345      *
346      * Emits a {Transfer} event.
347      *
348      * Requirements:
349      *
350      * - `sender` cannot be the zero address.
351      * - `recipient` cannot be the zero address.
352      * - `sender` must have a balance of at least `amount`.
353      */
354     function _transfer(
355         address sender,
356         address recipient,
357         uint256 amount
358     ) internal virtual {
359         require(sender != address(0), "ERC20: transfer from the zero address");
360         require(recipient != address(0), "ERC20: transfer to the zero address");
361 
362         _beforeTokenTransfer(sender, recipient, amount);
363 
364         uint256 senderBalance = _balances[sender];
365         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
366         unchecked {
367             _balances[sender] = senderBalance - amount;
368         }
369         _balances[recipient] += amount;
370 
371         emit Transfer(sender, recipient, amount);
372 
373         _afterTokenTransfer(sender, recipient, amount);
374     }
375 
376     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
377      * the total supply.
378      *
379      * Emits a {Transfer} event with `from` set to the zero address.
380      *
381      * Requirements:
382      *
383      * - `account` cannot be the zero address.
384      */
385     function _mint(address account, uint256 amount) internal virtual {
386         require(account != address(0), "ERC20: mint to the zero address");
387 
388         _beforeTokenTransfer(address(0), account, amount);
389 
390         _totalSupply += amount;
391         _balances[account] += amount;
392         emit Transfer(address(0), account, amount);
393 
394         _afterTokenTransfer(address(0), account, amount);
395     }
396 
397     /**
398      * @dev Destroys `amount` tokens from `account`, reducing the
399      * total supply.
400      *
401      * Emits a {Transfer} event with `to` set to the zero address.
402      *
403      * Requirements:
404      *
405      * - `account` cannot be the zero address.
406      * - `account` must have at least `amount` tokens.
407      */
408     function _burn(address account, uint256 amount) internal virtual {
409         require(account != address(0), "ERC20: burn from the zero address");
410 
411         _beforeTokenTransfer(account, address(0), amount);
412 
413         uint256 accountBalance = _balances[account];
414         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
415         unchecked {
416             _balances[account] = accountBalance - amount;
417         }
418         _totalSupply -= amount;
419 
420         emit Transfer(account, address(0), amount);
421 
422         _afterTokenTransfer(account, address(0), amount);
423     }
424 
425     /**
426      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
427      *
428      * This internal function is equivalent to `approve`, and can be used to
429      * e.g. set automatic allowances for certain subsystems, etc.
430      *
431      * Emits an {Approval} event.
432      *
433      * Requirements:
434      *
435      * - `owner` cannot be the zero address.
436      * - `spender` cannot be the zero address.
437      */
438     function _approve(
439         address owner,
440         address spender,
441         uint256 amount
442     ) internal virtual {
443         require(owner != address(0), "ERC20: approve from the zero address");
444         require(spender != address(0), "ERC20: approve to the zero address");
445 
446         _allowances[owner][spender] = amount;
447         emit Approval(owner, spender, amount);
448     }
449 
450     /**
451      * @dev Hook that is called before any transfer of tokens. This includes
452      * minting and burning.
453      *
454      * Calling conditions:
455      *
456      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
457      * will be transferred to `to`.
458      * - when `from` is zero, `amount` tokens will be minted for `to`.
459      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
460      * - `from` and `to` are never both zero.
461      *
462      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
463      */
464     function _beforeTokenTransfer(
465         address from,
466         address to,
467         uint256 amount
468     ) internal virtual {}
469 
470     /**
471      * @dev Hook that is called after any transfer of tokens. This includes
472      * minting and burning.
473      *
474      * Calling conditions:
475      *
476      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
477      * has been transferred to `to`.
478      * - when `from` is zero, `amount` tokens have been minted for `to`.
479      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
480      * - `from` and `to` are never both zero.
481      *
482      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
483      */
484     function _afterTokenTransfer(
485         address from,
486         address to,
487         uint256 amount
488     ) internal virtual {}
489 }
490 
491 pragma solidity ^0.8.20;
492 
493 contract Bitreum is ERC20 { 
494     constructor() ERC20(unicode"Bitreum", unicode"Bitreum") {
495         _mint(msg.sender, 21000000 * 10 ** decimals());
496     }
497 }