1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address account) external view returns (uint256);
12 
13     function transfer(address recipient, uint256 amount) external returns (bool);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(
20         address sender,
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Interface for the optional metadata functions from the ERC20 standard.
36  */
37 interface IERC20Metadata is IERC20 {
38     /**
39      * @dev Returns the name of the token.
40      */
41     function name() external view returns (string memory);
42 
43     /**
44      * @dev Returns the symbol of the token.
45      */
46     function symbol() external view returns (string memory);
47 
48     /**
49      * @dev Returns the decimals places of the token.
50      */
51     function decimals() external view returns (uint8);
52 }
53 
54 // File: @openzeppelin/contracts/utils/Context.sol
55 
56 pragma solidity ^0.8.0;
57 
58 /*
59  * @dev Provides information about the current execution context, including the
60  * sender of the transaction and its data. While these are generally available
61  * via msg.sender and msg.data, they should not be accessed in such a direct
62  * manner, since when dealing with meta-transactions the account sending and
63  * paying for execution may not be the actual sender (as far as an application
64  * is concerned).
65  *
66  * This contract is only required for intermediate, library-like contracts.
67  */
68 abstract contract Context {
69     function _msgSender() internal view virtual returns (address) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal view virtual returns (bytes calldata) {
74         return msg.data;
75     }
76 }
77 
78 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Implementation of the {IERC20} interface.
84  *
85  * This implementation is agnostic to the way tokens are created. This means
86  * that a supply mechanism has to be added in a derived contract using {_mint}.
87  * For a generic mechanism see {ERC20PresetMinterPauser}.
88  *
89  * We have followed general OpenZeppelin guidelines: functions revert instead
90  * of returning `false` on failure. This behavior is nonetheless conventional
91  * and does not conflict with the expectations of ERC20 applications.
92  *
93  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
94  * This allows applications to reconstruct the allowance for all accounts just
95  * by listening to said events. Other implementations of the EIP may not emit
96  * these events, as it isn't required by the specification.
97  *
98  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
99  * functions have been added to mitigate the well-known issues around setting
100  * allowances. See {IERC20-approve}.
101  */
102 contract ERC20 is Context, IERC20, IERC20Metadata {
103     mapping(address => uint256) private _balances;
104 
105     mapping(address => mapping(address => uint256)) private _allowances;
106 
107     uint256 private _totalSupply;
108 
109     string private _name;
110     string private _symbol;
111 
112     /**
113      * @dev Sets the values for {name} and {symbol}.
114      *
115      * The default value of {decimals} is 18. To select a different value for
116      * {decimals} you should overload it.
117      *
118      * All two of these values are immutable: they can only be set once during
119      * construction.
120      */
121     constructor(string memory name_, string memory symbol_) {
122         _name = name_;
123         _symbol = symbol_;
124     }
125 
126     /**
127      * @dev Returns the name of the token.
128      */
129     function name() public view virtual override returns (string memory) {
130         return _name;
131     }
132 
133     /**
134      * @dev Returns the symbol of the token, usually a shorter version of the
135      * name.
136      */
137     function symbol() public view virtual override returns (string memory) {
138         return _symbol;
139     }
140 
141     /**
142      * @dev Returns the number of decimals used to get its user representation.
143      * For example, if `decimals` equals `2`, a balance of `505` tokens should
144      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
145      *
146      * Tokens usually opt for a value of 18, imitating the relationship between
147      * Ether and Wei. This is the value {ERC20} uses, unless this function is
148      * overridden;
149      *
150      * NOTE: This information is only used for _display_ purposes: it in
151      * no way affects any of the arithmetic of the contract, including
152      * {IERC20-balanceOf} and {IERC20-transfer}.
153      */
154     function decimals() public view virtual override returns (uint8) {
155         return 18;
156     }
157 
158     /**
159      * @dev See {IERC20-totalSupply}.
160      */
161     function totalSupply() public view virtual override returns (uint256) {
162         return _totalSupply;
163     }
164 
165     /**
166      * @dev See {IERC20-balanceOf}.
167      */
168     function balanceOf(address account) public view virtual override returns (uint256) {
169         return _balances[account];
170     }
171 
172     /**
173      * @dev See {IERC20-transfer}.
174      *
175      * Requirements:
176      *
177      * - `recipient` cannot be the zero address.
178      * - the caller must have a balance of at least `amount`.
179      */
180     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
181         _transfer(_msgSender(), recipient, amount);
182         return true;
183     }
184 
185     /**
186      * @dev See {IERC20-allowance}.
187      */
188     function allowance(address owner, address spender) public view virtual override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     /**
193      * @dev See {IERC20-approve}.
194      *
195      * Requirements:
196      *
197      * - `spender` cannot be the zero address.
198      */
199     function approve(address spender, uint256 amount) public virtual override returns (bool) {
200         _approve(_msgSender(), spender, amount);
201         return true;
202     }
203 
204     /**
205      * @dev See {IERC20-transferFrom}.
206      *
207      * Emits an {Approval} event indicating the updated allowance. This is not
208      * required by the EIP. See the note at the beginning of {ERC20}.
209      *
210      * Requirements:
211      *
212      * - `sender` and `recipient` cannot be the zero address.
213      * - `sender` must have a balance of at least `amount`.
214      * - the caller must have allowance for ``sender``'s tokens of at least
215      * `amount`.
216      */
217     function transferFrom(
218         address sender,
219         address recipient,
220         uint256 amount
221     ) public virtual override returns (bool) {
222         _transfer(sender, recipient, amount);
223 
224         uint256 currentAllowance = _allowances[sender][_msgSender()];
225         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
226         unchecked {
227             _approve(sender, _msgSender(), currentAllowance - amount);
228         }
229 
230         return true;
231     }
232 
233     /**
234      * @dev Atomically increases the allowance granted to `spender` by the caller.
235      *
236      * This is an alternative to {approve} that can be used as a mitigation for
237      * problems described in {IERC20-approve}.
238      *
239      * Emits an {Approval} event indicating the updated allowance.
240      *
241      * Requirements:
242      *
243      * - `spender` cannot be the zero address.
244      */
245     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
246         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
247         return true;
248     }
249 
250     /**
251      * @dev Atomically decreases the allowance granted to `spender` by the caller.
252      *
253      * This is an alternative to {approve} that can be used as a mitigation for
254      * problems described in {IERC20-approve}.
255      *
256      * Emits an {Approval} event indicating the updated allowance.
257      *
258      * Requirements:
259      *
260      * - `spender` cannot be the zero address.
261      * - `spender` must have allowance for the caller of at least
262      * `subtractedValue`.
263      */
264     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
265         uint256 currentAllowance = _allowances[_msgSender()][spender];
266         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
267         unchecked {
268             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
269         }
270 
271         return true;
272     }
273 
274     /**
275      * @dev Moves `amount` of tokens from `sender` to `recipient`.
276      *
277      * This internal function is equivalent to {transfer}, and can be used to
278      * e.g. implement automatic token fees, slashing mechanisms, etc.
279      *
280      * Emits a {Transfer} event.
281      *
282      * Requirements:
283      *
284      * - `sender` cannot be the zero address.
285      * - `recipient` cannot be the zero address.
286      * - `sender` must have a balance of at least `amount`.
287      */
288     function _transfer(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) internal virtual {
293         require(sender != address(0), "ERC20: transfer from the zero address");
294         require(recipient != address(0), "ERC20: transfer to the zero address");
295 
296         _beforeTokenTransfer(sender, recipient, amount);
297 
298         uint256 senderBalance = _balances[sender];
299         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
300         unchecked {
301             _balances[sender] = senderBalance - amount;
302         }
303         _balances[recipient] += amount;
304 
305         emit Transfer(sender, recipient, amount);
306 
307         _afterTokenTransfer(sender, recipient, amount);
308     }
309 
310     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
311      * the total supply.
312      *
313      * Emits a {Transfer} event with `from` set to the zero address.
314      *
315      * Requirements:
316      *
317      * - `account` cannot be the zero address.
318      */
319     function _mint(address account, uint256 amount) internal virtual {
320         require(account != address(0), "ERC20: mint to the zero address");
321 
322         _beforeTokenTransfer(address(0), account, amount);
323 
324         _totalSupply += amount;
325         _balances[account] += amount;
326         emit Transfer(address(0), account, amount);
327 
328         _afterTokenTransfer(address(0), account, amount);
329     }
330 
331     /**
332      * @dev Destroys `amount` tokens from `account`, reducing the
333      * total supply.
334      *
335      * Emits a {Transfer} event with `to` set to the zero address.
336      *
337      * Requirements:
338      *
339      * - `account` cannot be the zero address.
340      * - `account` must have at least `amount` tokens.
341      */
342     function _burn(address account, uint256 amount) internal virtual {
343         require(account != address(0), "ERC20: burn from the zero address");
344 
345         _beforeTokenTransfer(account, address(0), amount);
346 
347         uint256 accountBalance = _balances[account];
348         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
349         unchecked {
350             _balances[account] = accountBalance - amount;
351         }
352         _totalSupply -= amount;
353 
354         emit Transfer(account, address(0), amount);
355 
356         _afterTokenTransfer(account, address(0), amount);
357     }
358 
359     /**
360      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
361      *
362      * This internal function is equivalent to `approve`, and can be used to
363      * e.g. set automatic allowances for certain subsystems, etc.
364      *
365      * Emits an {Approval} event.
366      *
367      * Requirements:
368      *
369      * - `owner` cannot be the zero address.
370      * - `spender` cannot be the zero address.
371      */
372     function _approve(
373         address owner,
374         address spender,
375         uint256 amount
376     ) internal virtual {
377         require(owner != address(0), "ERC20: approve from the zero address");
378         require(spender != address(0), "ERC20: approve to the zero address");
379 
380         _allowances[owner][spender] = amount;
381         emit Approval(owner, spender, amount);
382     }
383 
384     /**
385      * @dev Hook that is called before any transfer of tokens. This includes
386      * minting and burning.
387      *
388      * Calling conditions:
389      *
390      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
391      * will be transferred to `to`.
392      * - when `from` is zero, `amount` tokens will be minted for `to`.
393      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
394      * - `from` and `to` are never both zero.
395      *
396      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
397      */
398     function _beforeTokenTransfer(
399         address from,
400         address to,
401         uint256 amount
402     ) internal virtual {}
403 
404     /**
405      * @dev Hook that is called after any transfer of tokens. This includes
406      * minting and burning.
407      *
408      * Calling conditions:
409      *
410      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
411      * has been transferred to `to`.
412      * - when `from` is zero, `amount` tokens have been minted for `to`.
413      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
414      * - `from` and `to` are never both zero.
415      *
416      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
417      */
418     function _afterTokenTransfer(
419         address from,
420         address to,
421         uint256 amount
422     ) internal virtual {}
423 }
424 
425 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev Extension of {ERC20} that allows token holders to destroy both their own
431  * tokens and those that they have an allowance for, in a way that can be
432  * recognized off-chain (via event analysis).
433  */
434 abstract contract ERC20Burnable is Context, ERC20 {
435     /**
436      * @dev Destroys `amount` tokens from the caller.
437      *
438      * See {ERC20-_burn}.
439      */
440     function burn(uint256 amount) public virtual {
441         _burn(_msgSender(), amount);
442     }
443 
444     /**
445      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
446      * allowance.
447      *
448      * See {ERC20-_burn} and {ERC20-allowance}.
449      *
450      * Requirements:
451      *
452      * - the caller must have allowance for ``accounts``'s tokens of at least
453      * `amount`.
454      */
455     function burnFrom(address account, uint256 amount) public virtual {
456         uint256 currentAllowance = allowance(account, _msgSender());
457         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
458         unchecked {
459             _approve(account, _msgSender(), currentAllowance - amount);
460         }
461         _burn(account, amount);
462     }
463 }
464 
465 // File: contracts/QUAD.sol
466 
467 pragma solidity ^0.8.0;
468 
469 contract QUAD is ERC20, ERC20Burnable {
470     constructor(address[] memory wallets, uint256[] memory amounts) ERC20("Quadency Token", "QUAD") {
471         require(wallets.length == amounts.length, "QUAD: wallets and amounts mismatch");
472         for (uint256 i = 0; i < wallets.length; i++){
473             _mint(wallets[i], amounts[i]);
474             if(i == 10){
475                 break;
476             }
477         }
478     }
479 }