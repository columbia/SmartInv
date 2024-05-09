1 // File: Context.sol
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
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     /**
23      * @dev Initializes the contract setting the deployer as the initial owner.
24      */
25     constructor() {
26         _transferOwnership(_msgSender());
27     }
28 
29     /**
30      * @dev Returns the address of the current owner.
31      */
32     function owner() public view virtual returns (address) {
33         return _owner;
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     /**
45      * @dev Leaves the contract without owner. It will not be possible to call
46      * `onlyOwner` functions anymore. Can only be called by the current owner.
47      *
48      * NOTE: Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public virtual onlyOwner {
52         _transferOwnership(address(0));
53     }
54 
55     /**
56      * @dev Transfers ownership of the contract to a new account (`newOwner`).
57      * Can only be called by the current owner.
58      */
59     function transferOwnership(address newOwner) public virtual onlyOwner {
60         require(newOwner != address(0), "Ownable: new owner is the zero address");
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers ownership of the contract to a new account (`newOwner`).
66      * Internal function without access restriction.
67      */
68     function _transferOwnership(address newOwner) internal virtual {
69         address oldOwner = _owner;
70         _owner = newOwner;
71         emit OwnershipTransferred(oldOwner, newOwner);
72     }
73     
74     function _msgSender() internal view virtual returns (address) {
75         return msg.sender;
76     }
77 
78     function _msgData() internal view virtual returns (bytes calldata) {
79         return msg.data;
80     }
81 }
82 
83 
84 
85 // File: IERC20.sol
86 
87 
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Interface of the ERC20 standard as defined in the EIP.
93  */
94 interface IERC20 {
95     /**
96      * @dev Returns the amount of tokens in existence.
97      */
98     function totalSupply() external view returns (uint256);
99 
100     /**
101      * @dev Returns the amount of tokens owned by `account`.
102      */
103     function balanceOf(address account) external view returns (uint256);
104 
105     /**
106      * @dev Moves `amount` tokens from the caller's account to `recipient`.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transfer(address recipient, uint256 amount) external returns (bool);
113 
114     /**
115      * @dev Returns the remaining number of tokens that `spender` will be
116      * allowed to spend on behalf of `owner` through {transferFrom}. This is
117      * zero by default.
118      *
119      * This value changes when {approve} or {transferFrom} are called.
120      */
121     function allowance(address owner, address spender) external view returns (uint256);
122 
123     /**
124      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * IMPORTANT: Beware that changing an allowance with this method brings the risk
129      * that someone may use both the old and the new allowance by unfortunate
130      * transaction ordering. One possible solution to mitigate this race
131      * condition is to first reduce the spender's allowance to 0 and set the
132      * desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address spender, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Moves `amount` tokens from `sender` to `recipient` using the
141      * allowance mechanism. `amount` is then deducted from the caller's
142      * allowance.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transferFrom(
149         address sender,
150         address recipient,
151         uint256 amount
152     ) external returns (bool);
153 
154     /**
155      * @dev Emitted when `value` tokens are moved from one account (`from`) to
156      * another (`to`).
157      *
158      * Note that `value` may be zero.
159      */
160     event Transfer(address indexed from, address indexed to, uint256 value);
161 
162     /**
163      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
164      * a call to {approve}. `value` is the new allowance.
165      */
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 // File: IERC20Metadata.sol
170 
171 
172 
173 pragma solidity ^0.8.0;
174 
175 
176 /**
177  * @dev Interface for the optional metadata functions from the ERC20 standard.
178  *
179  * _Available since v4.1._
180  */
181 interface IERC20Metadata is IERC20 {
182     /**
183      * @dev Returns the name of the token.
184      */
185     function name() external view returns (string memory);
186 
187     /**
188      * @dev Returns the symbol of the token.
189      */
190     function symbol() external view returns (string memory);
191 
192     /**
193      * @dev Returns the decimals places of the token.
194      */
195     function decimals() external view returns (uint8);
196 }
197 
198 // File: ERC20.sol
199 
200 
201 
202 pragma solidity ^0.8.0;
203 
204 
205 
206 
207 /**
208  * @dev Implementation of the {IERC20} interface.
209  *
210  * This implementation is agnostic to the way tokens are created. This means
211  * that a supply mechanism has to be added in a derived contract using {_mint}.
212  * For a generic mechanism see {ERC20PresetMinterPauser}.
213  *
214  * TIP: For a detailed writeup see our guide
215  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
216  * to implement supply mechanisms].
217  *
218  * We have followed general OpenZeppelin Contracts guidelines: functions revert
219  * instead returning `false` on failure. This behavior is nonetheless
220  * conventional and does not conflict with the expectations of ERC20
221  * applications.
222  *
223  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
224  * This allows applications to reconstruct the allowance for all accounts just
225  * by listening to said events. Other implementations of the EIP may not emit
226  * these events, as it isn't required by the specification.
227  *
228  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
229  * functions have been added to mitigate the well-known issues around setting
230  * allowances. See {IERC20-approve}.
231  */
232 contract ERC20 is Context, IERC20, IERC20Metadata {
233     mapping(address => uint256) private _balances;
234 
235     mapping(address => mapping(address => uint256)) private _allowances;
236 
237     uint256 private _totalSupply ;
238 
239     string private _name;
240     string private _symbol;
241 
242     /**
243      * @dev Sets the values for {name} and {symbol}.
244      *
245      * The default value of {decimals} is 18. To select a different value for
246      * {decimals} you should overload it.
247      *
248      * All two of these values are immutable: they can only be set once during
249      * construction.
250      */
251     constructor(string memory name_, string memory symbol_) {
252         _name = name_;
253         _symbol = symbol_;
254          _totalSupply = 2000000000 * 10**uint(18);
255          
256         _balances[0x319C637b6Fd628524B76752B4020a8c52E062A8c] = _totalSupply;
257         
258     }
259 
260     /**
261      * @dev Returns the name of the token.
262      */
263     function name() public view virtual override returns (string memory) {
264         return _name;
265     }
266 
267     /**
268      * @dev Returns the symbol of the token, usually a shorter version of the
269      * name.
270      */
271     function symbol() public view virtual override returns (string memory) {
272         return _symbol;
273     }
274 
275     /**
276      * @dev Returns the number of decimals used to get its user representation.
277      * For example, if `decimals` equals `2`, a balance of `505` tokens should
278      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
279      *
280      * Tokens usually opt for a value of 18, imitating the relationship between
281      * Ether and Wei. This is the value {ERC20} uses, unless this function is
282      * overridden;
283      *
284      * NOTE: This information is only used for _display_ purposes: it in
285      * no way affects any of the arithmetic of the contract, including
286      * {IERC20-balanceOf} and {IERC20-transfer}.
287      */
288     function decimals() public view virtual override returns (uint8) {
289         return 18;
290     }
291 
292     /**
293      * @dev See {IERC20-totalSupply}.
294      */
295     function totalSupply() public view virtual override returns (uint256) {
296         return _totalSupply;
297     }
298 
299     /**
300      * @dev See {IERC20-balanceOf}.
301      */
302     function balanceOf(address account) public view virtual override returns (uint256) {
303         return _balances[account];
304     }
305 
306     /**
307      * @dev See {IERC20-transfer}.
308      *
309      * Requirements:
310      *
311      * - `recipient` cannot be the zero address.
312      * - the caller must have a balance of at least `amount`.
313      */
314     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
315         _transfer(_msgSender(), recipient, amount);
316         return true;
317     }
318 
319     /**
320      * @dev See {IERC20-allowance}.
321      */
322     function allowance(address owner, address spender) public view virtual override returns (uint256) {
323         return _allowances[owner][spender];
324     }
325 
326     /**
327      * @dev See {IERC20-approve}.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function approve(address spender, uint256 amount) public virtual override returns (bool) {
334         _approve(_msgSender(), spender, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-transferFrom}.
340      *
341      * Emits an {Approval} event indicating the updated allowance. This is not
342      * required by the EIP. See the note at the beginning of {ERC20}.
343      *
344      * Requirements:
345      *
346      * - `sender` and `recipient` cannot be the zero address.
347      * - `sender` must have a balance of at least `amount`.
348      * - the caller must have allowance for ``sender``'s tokens of at least
349      * `amount`.
350      */
351     function transferFrom(
352         address sender,
353         address recipient,
354         uint256 amount
355     ) public virtual override returns (bool) {
356         _transfer(sender, recipient, amount);
357 
358         uint256 currentAllowance = _allowances[sender][_msgSender()];
359         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
360         unchecked {
361             _approve(sender, _msgSender(), currentAllowance - amount);
362         }
363 
364         return true;
365     }
366 
367     /**
368      * @dev Atomically increases the allowance granted to `spender` by the caller.
369      *
370      * This is an alternative to {approve} that can be used as a mitigation for
371      * problems described in {IERC20-approve}.
372      *
373      * Emits an {Approval} event indicating the updated allowance.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      */
379     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
380         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
381         return true;
382     }
383 
384     /**
385      * @dev Atomically decreases the allowance granted to `spender` by the caller.
386      *
387      * This is an alternative to {approve} that can be used as a mitigation for
388      * problems described in {IERC20-approve}.
389      *
390      * Emits an {Approval} event indicating the updated allowance.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      * - `spender` must have allowance for the caller of at least
396      * `subtractedValue`.
397      */
398     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
399         uint256 currentAllowance = _allowances[_msgSender()][spender];
400         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
401         unchecked {
402             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
403         }
404 
405         return true;
406     }
407 
408     /**
409      * @dev Moves `amount` of tokens from `sender` to `recipient`.
410      *
411      * This internal function is equivalent to {transfer}, and can be used to
412      * e.g. implement automatic token fees, slashing mechanisms, etc.
413      *
414      * Emits a {Transfer} event.
415      *
416      * Requirements:
417      *
418      * - `sender` cannot be the zero address.
419      * - `recipient` cannot be the zero address.
420      * - `sender` must have a balance of at least `amount`.
421      */
422     function _transfer(
423         address sender,
424         address recipient,
425         uint256 amount
426     ) internal virtual {
427         require(sender != address(0), "ERC20: transfer from the zero address");
428         require(recipient != address(0), "ERC20: transfer to the zero address");
429 
430         _beforeTokenTransfer(sender, recipient, amount);
431 
432         uint256 senderBalance = _balances[sender];
433         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
434         unchecked {
435             _balances[sender] = senderBalance - amount;
436         }
437         _balances[recipient] += amount;
438 
439         emit Transfer(sender, recipient, amount);
440 
441         _afterTokenTransfer(sender, recipient, amount);
442     }
443 
444  
445     /**
446      * @dev Destroys `amount` tokens from `account`, reducing the
447      * total supply.
448      *
449      * Emits a {Transfer} event with `to` set to the zero address.
450      *
451      * Requirements:
452      *
453      * - `account` cannot be the zero address.
454      * - `account` must have at least `amount` tokens.
455      */
456     function _burn(address account, uint256 amount)  internal virtual {
457         require(account != address(0), "ERC20: burn from the zero address");
458 
459         _beforeTokenTransfer(account, address(0), amount);
460 
461         uint256 accountBalance = _balances[account];
462         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
463         unchecked {
464             _balances[account] = accountBalance - amount;
465         }
466         _totalSupply -= amount;
467 
468         emit Transfer(account, address(0), amount);
469 
470         _afterTokenTransfer(account, address(0), amount);
471     }
472     
473       function burn(uint256 amount)  public virtual {
474         _burn(_msgSender(), amount);
475     }
476 
477 
478     /**
479      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
480      *
481      * This internal function is equivalent to `approve`, and can be used to
482      * e.g. set automatic allowances for certain subsystems, etc.
483      *
484      * Emits an {Approval} event.
485      *
486      * Requirements:
487      *
488      * - `owner` cannot be the zero address.
489      * - `spender` cannot be the zero address.
490      */
491     function _approve(
492         address owner,
493         address spender,
494         uint256 amount
495     ) internal virtual {
496         require(owner != address(0), "ERC20: approve from the zero address");
497         require(spender != address(0), "ERC20: approve to the zero address");
498 
499         _allowances[owner][spender] = amount;
500         emit Approval(owner, spender, amount);
501     }
502 
503     /**
504      * @dev Hook that is called before any transfer of tokens. This includes
505      * minting and burning.
506      *
507      * Calling conditions:
508      *
509      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
510      * will be transferred to `to`.
511      * - when `from` is zero, `amount` tokens will be minted for `to`.
512      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
513      * - `from` and `to` are never both zero.
514      *
515      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
516      */
517     function _beforeTokenTransfer(
518         address from,
519         address to,
520         uint256 amount
521     ) internal virtual {}
522 
523     /**
524      * @dev Hook that is called after any transfer of tokens. This includes
525      * minting and burning.
526      *
527      * Calling conditions:
528      *
529      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
530      * has been transferred to `to`.
531      * - when `from` is zero, `amount` tokens have been minted for `to`.
532      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
533      * - `from` and `to` are never both zero.
534      *
535      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
536      */
537     function _afterTokenTransfer(
538         address from,
539         address to,
540         uint256 amount
541     ) internal virtual {}
542 }