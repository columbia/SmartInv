1 /**
2  * Summary: Woof Token
3  * Website: https://wooftoken.com
4  * Telegram: https://t.me/WoofTokenOfficial
5  * Twitter: https://twitter.com/TheWoofToken
6 */
7 
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: node_modules\@openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
88 
89 
90 
91 pragma solidity ^0.8.0;
92 
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
117 
118 
119 
120 pragma solidity ^0.8.0;
121 
122 /*
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
139         return msg.data;
140     }
141 }
142 
143 /**
144  * @dev Contract module which provides a basic access control mechanism, where
145  * there is an account (an owner) that can be granted exclusive access to
146  * specific functions.
147  *
148  * By default, the owner account will be the one that deploys the contract. This
149  * can later be changed with {transferOwnership}.
150  *
151  * This module is used through inheritance. It will make available the modifier
152  * `onlyOwner`, which can be applied to your functions to restrict their use to
153  * the owner.
154  */
155 abstract contract Ownable {
156     address private _owner;
157 
158     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159 
160     /**
161      * @dev Initializes the contract setting the deployer as the initial owner.
162      */
163     constructor() {
164         address msgSender = msg.sender;
165         _owner = msgSender;
166         emit OwnershipTransferred(address(0), msgSender);
167     }
168 
169     /**
170      * @dev Returns the address of the current owner.
171      */
172     function owner() public view virtual returns (address) {
173         return _owner;
174     }
175 
176     /**
177      * @dev Throws if called by any account other than the owner.
178      */
179     modifier onlyOwner() {
180         require(owner() == msg.sender, "Ownable: caller is not the owner");
181         _;
182     }
183 
184     /**
185      * @dev Leaves the contract without owner. It will not be possible to call
186      * `onlyOwner` functions anymore. Can only be called by the current owner.
187      *
188      * NOTE: Renouncing ownership will leave the contract without an owner,
189      * thereby removing any functionality that is only available to the owner.
190      */
191     function renounceOwnership() public virtual onlyOwner {
192         emit OwnershipTransferred(_owner, address(0));
193         _owner = address(0);
194     }
195 
196     /**
197      * @dev Transfers ownership of the contract to a new account (`newOwner`).
198      * Can only be called by the current owner.
199      */
200     function transferOwnership(address newOwner) public virtual onlyOwner {
201         require(newOwner != address(0), "Ownable: new owner is the zero address");
202         emit OwnershipTransferred(_owner, newOwner);
203         _owner = newOwner;
204     }
205 }
206 
207 
208 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
209 
210 pragma solidity ^0.8.0;
211 
212 
213 
214 
215 /**
216  * @dev Implementation of the {IERC20} interface.
217  *
218  * This implementation is agnostic to the way tokens are created. This means
219  * that a supply mechanism has to be added in a derived contract using {_mint}.
220  * For a generic mechanism see {ERC20PresetMinterPauser}.
221  *
222  * TIP: For a detailed writeup see our guide
223  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
224  * to implement supply mechanisms].
225  *
226  * We have followed general OpenZeppelin guidelines: functions revert instead
227  * of returning `false` on failure. This behavior is nonetheless conventional
228  * and does not conflict with the expectations of ERC20 applications.
229  *
230  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
231  * This allows applications to reconstruct the allowance for all accounts just
232  * by listening to said events. Other implementations of the EIP may not emit
233  * these events, as it isn't required by the specification.
234  *
235  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
236  * functions have been added to mitigate the well-known issues around setting
237  * allowances. See {IERC20-approve}.
238  */
239 contract WoofToken is Context, IERC20, IERC20Metadata, Ownable {
240     mapping (address => uint256) private _balances;
241 
242     mapping (address => mapping (address => uint256)) private _allowances;
243 
244     uint256 private _totalSupply;
245 
246     string private _name;
247     string private _symbol;
248 
249     /**
250      * @dev Sets the values for {name} and {symbol}.
251      *
252      * The defaut value of {decimals} is 18. To select a different value for
253      * {decimals} you should overload it.
254      *
255      * All two of these values are immutable: they can only be set once during
256      * construction.
257      */
258     constructor () {
259         _name = "Woof Token";
260         _symbol = "WOOF";
261         _mint(msg.sender, 1000000000000000 * (10 ** uint256(decimals())));
262     }
263 
264     /**
265      * @dev Returns the name of the token.
266      */
267     function name() public view virtual override returns (string memory) {
268         return _name;
269     }
270 
271     /**
272      * @dev Returns the symbol of the token, usually a shorter version of the
273      * name.
274      */
275     function symbol() public view virtual override returns (string memory) {
276         return _symbol;
277     }
278 
279     /**
280      * @dev Returns the number of decimals used to get its user representation.
281      * For example, if `decimals` equals `2`, a balance of `505` tokens should
282      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
283      *
284      * Tokens usually opt for a value of 18, imitating the relationship between
285      * Ether and Wei. This is the value {ERC20} uses, unless this function is
286      * overridden;
287      *
288      * NOTE: This information is only used for _display_ purposes: it in
289      * no way affects any of the arithmetic of the contract, including
290      * {IERC20-balanceOf} and {IERC20-transfer}.
291      */
292     function decimals() public view virtual override returns (uint8) {
293         return 18;
294     }
295 
296     /**
297      * @dev See {IERC20-totalSupply}.
298      */
299     function totalSupply() public view virtual override returns (uint256) {
300         return _totalSupply;
301     }
302 
303     /**
304      * @dev See {IERC20-balanceOf}.
305      */
306     function balanceOf(address account) public view virtual override returns (uint256) {
307         return _balances[account];
308     }
309 
310     /**
311      * @dev See {IERC20-transfer}.
312      *
313      * Requirements:
314      *
315      * - `recipient` cannot be the zero address.
316      * - the caller must have a balance of at least `amount`.
317      */
318     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
319         _transfer(_msgSender(), recipient, amount);
320         return true;
321     }
322 
323     /**
324      * @dev See {IERC20-allowance}.
325      */
326     function allowance(address owner, address spender) public view virtual override returns (uint256) {
327         return _allowances[owner][spender];
328     }
329 
330     /**
331      * @dev See {IERC20-approve}.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function approve(address spender, uint256 amount) public virtual override returns (bool) {
338         _approve(_msgSender(), spender, amount);
339         return true;
340     }
341 
342     /**
343      * @dev See {IERC20-transferFrom}.
344      *
345      * Emits an {Approval} event indicating the updated allowance. This is not
346      * required by the EIP. See the note at the beginning of {ERC20}.
347      *
348      * Requirements:
349      *
350      * - `sender` and `recipient` cannot be the zero address.
351      * - `sender` must have a balance of at least `amount`.
352      * - the caller must have allowance for ``sender``'s tokens of at least
353      * `amount`.
354      */
355     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
356         _transfer(sender, recipient, amount);
357 
358         uint256 currentAllowance = _allowances[sender][_msgSender()];
359         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
360         _approve(sender, _msgSender(), currentAllowance - amount);
361 
362         return true;
363     }
364 
365     /**
366      * @dev Atomically increases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to {approve} that can be used as a mitigation for
369      * problems described in {IERC20-approve}.
370      *
371      * Emits an {Approval} event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
378         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
379         return true;
380     }
381 
382     /**
383      * @dev Atomically decreases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {IERC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      * - `spender` must have allowance for the caller of at least
394      * `subtractedValue`.
395      */
396     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
397         uint256 currentAllowance = _allowances[_msgSender()][spender];
398         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
399         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
400 
401         return true;
402     }
403 
404     /**
405      * @dev Moves tokens `amount` from `sender` to `recipient`.
406      *
407      * This is internal function is equivalent to {transfer}, and can be used to
408      * e.g. implement automatic token fees, slashing mechanisms, etc.
409      *
410      * Emits a {Transfer} event.
411      *
412      * Requirements:
413      *
414      * - `sender` cannot be the zero address.
415      * - `recipient` cannot be the zero address.
416      * - `sender` must have a balance of at least `amount`.
417      */
418     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
419         require(sender != address(0), "ERC20: transfer from the zero address");
420         require(recipient != address(0), "ERC20: transfer to the zero address");
421 
422         _beforeTokenTransfer(sender, recipient, amount);
423 
424         uint256 senderBalance = _balances[sender];
425         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
426         _balances[sender] = senderBalance - amount;
427         _balances[recipient] += amount;
428 
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements:
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal virtual {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _beforeTokenTransfer(address(0), account, amount);
445 
446         _totalSupply += amount;
447         _balances[account] += amount;
448         emit Transfer(address(0), account, amount);
449     }
450 
451     /**
452      * @dev Destroys `amount` tokens from `account`, reducing the
453      * total supply.
454      *
455      * Emits a {Transfer} event with `to` set to the zero address.
456      *
457      * Requirements:
458      *
459      * - `account` cannot be the zero address.
460      * - `account` must have at least `amount` tokens.
461      */
462     function _burn(address account, uint256 amount) internal virtual {
463         require(account != address(0), "ERC20: burn from the zero address");
464 
465         _beforeTokenTransfer(account, address(0), amount);
466 
467         uint256 accountBalance = _balances[account];
468         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
469         _balances[account] = accountBalance - amount;
470         _totalSupply -= amount;
471 
472         emit Transfer(account, address(0), amount);
473     }
474 
475     /**
476      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
477      *
478      * This internal function is equivalent to `approve`, and can be used to
479      * e.g. set automatic allowances for certain subsystems, etc.
480      *
481      * Emits an {Approval} event.
482      *
483      * Requirements:
484      *
485      * - `owner` cannot be the zero address.
486      * - `spender` cannot be the zero address.
487      */
488     function _approve(address owner, address spender, uint256 amount) internal virtual {
489         require(owner != address(0), "ERC20: approve from the zero address");
490         require(spender != address(0), "ERC20: approve to the zero address");
491 
492         _allowances[owner][spender] = amount;
493         emit Approval(owner, spender, amount);
494     }
495 
496     /**
497      * @dev Hook that is called before any transfer of tokens. This includes
498      * minting and burning.
499      *
500      * Calling conditions:
501      *
502      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
503      * will be to transferred to `to`.
504      * - when `from` is zero, `amount` tokens will be minted for `to`.
505      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
506      * - `from` and `to` are never both zero.
507      *
508      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
509      */
510     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
511 }