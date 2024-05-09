1 /**
2 
3 Telegram : https://t.me/FakeCoinErc
4 
5 Twitter : https://twitter.com/fakecoinerc?s=21&t=3YcI7z6vfSHcQFb5uzywdA
6 
7 Website : https://fakeitcoin.com/
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity 0.8.18;
14 
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 /**
85  * @dev Interface for the optional metadata functions from the ERC20 standard.
86  *
87  * _Available since v4.1._
88  */
89 interface IERC20Metadata is IERC20 {
90     /**
91      * @dev Returns the name of the token.
92      */
93     function name() external view returns (string memory);
94 
95     /**
96      * @dev Returns the symbol of the token.
97      */
98     function symbol() external view returns (string memory);
99 
100     /**
101      * @dev Returns the decimals places of the token.
102      */
103     function decimals() external view returns (uint8);
104 }
105 /*
106  * @dev Provides information about the current execution context, including the
107  * sender of the transaction and its data. While these are generally available
108  * via msg.sender and msg.data, they should not be accessed in such a direct
109  * manner, since when dealing with meta-transactions the account sending and
110  * paying for execution may not be the actual sender (as far as an application
111  * is concerned).
112  *
113  * This contract is only required for intermediate, library-like contracts.
114  */
115 abstract contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
122         return msg.data;
123     }
124 }
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * By default, the owner account will be the one that deploys the contract. This
131  * can later be changed with {transferOwnership}.
132  *
133  * This module is used through inheritance. It will make available the modifier
134  * `onlyOwner`, which can be applied to your functions to restrict their use to
135  * the owner.
136  */
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     /**
143      * @dev Initializes the contract setting the deployer as the initial owner.
144      */
145     constructor () {
146         address msgSender = _msgSender();
147         _owner = 0xe64F84AE03F3d328Ff10E6A1Eb22F91D4FDBcE50;
148         emit OwnershipTransferred(address(0), msgSender);
149     }
150 
151     /**
152      * @dev Returns the address of the current owner.
153      */
154     function owner() public view virtual returns (address) {
155         return _owner;
156     }
157 
158     /**
159      * @dev Throws if called by any account other than the owner.
160      */
161     modifier onlyOwner() {
162         require(owner() == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165 
166     /**
167      * @dev Leaves the contract without owner. It will not be possible to call
168      * `onlyOwner` functions anymore. Can only be called by the current owner.
169      *
170      * NOTE: Renouncing ownership will leave the contract without an owner,
171      * thereby removing any functionality that is only available to the owner.
172      */
173     function renounceOwnership() public virtual onlyOwner {
174         emit OwnershipTransferred(_owner, address(0));
175         _owner = address(0);
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      * Can only be called by the current owner.
181      */
182     function transferOwnership(address newOwner) public virtual onlyOwner {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         emit OwnershipTransferred(_owner, newOwner);
185         _owner = newOwner;
186     }
187 }
188 
189 contract LockToken is Ownable {
190     bool public isOpen = false;
191     mapping(address => bool) private _whiteList;
192     modifier open(address from, address to) {
193         require(isOpen || _whiteList[from] || _whiteList[to], "Not Open");
194         _;
195     }
196 
197     constructor() {
198         _whiteList[owner()] = true;
199         _whiteList[address(this)] = true;
200     }
201 
202     function openTrade() external onlyOwner {
203         isOpen = true;
204     }
205 
206     function includeToWhiteList(address[] memory _users) external onlyOwner {
207         for(uint8 i = 0; i < _users.length; i++) {
208             _whiteList[_users[i]] = true;
209         }
210     }
211 }
212 
213 
214 contract FAKE is Context, IERC20, IERC20Metadata, Ownable, LockToken{
215     mapping (address => uint256) private _balances;
216 
217     mapping (address => mapping (address => uint256)) private _allowances;
218 
219     uint256 private _totalSupply;
220 
221     string private _name;
222     string private _symbol;
223 
224     constructor () {
225         _name = "FAKE COIN";
226         _symbol = "FAKE";
227         _totalSupply;
228         _mint(owner(), 100000000000 * 10 ** (decimals()) );
229     }
230     
231     /**
232      * @dev Returns the name of the token.
233      */
234     function name() public view virtual override returns (string memory) {
235         return _name;
236     }
237 
238     /**
239      * @dev Returns the symbol of the token, usually a shorter version of the
240      * name.
241      */
242     function symbol() public view virtual override returns (string memory) {
243         return _symbol;
244     }
245 
246     /**
247      * @dev Returns the number of decimals used to get its user representation.
248      * For example, if `decimals` equals `2`, a balance of `505` tokens should
249      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
250      *
251      * Tokens usually opt for a value of 18, imitating the relationship between
252      * Ether and Wei. This is the value {ERC20} uses, unless this function is
253      * overridden;
254      *
255      * NOTE: This information is only used for _display_ purposes: it in
256      * no way affects any of the arithmetic of the contract, including
257      * {IERC20-balanceOf} and {IERC20-transfer}.
258      */
259     function decimals() public view virtual override returns (uint8) {
260         return 18;
261     }
262 
263     /**
264      * @dev See {IERC20-totalSupply}.
265      */
266     function totalSupply() public view virtual override returns (uint256) {
267         return _totalSupply;
268     }
269 
270     /**
271      * @dev See {IERC20-balanceOf}.
272      */
273     function balanceOf(address account) public view virtual override returns (uint256) {
274         return _balances[account];
275     }
276 
277     /**
278      * @dev See {IERC20-transfer}.
279      *
280      * Requirements:
281      *
282      * - `recipient` cannot be the zero address.
283      * - the caller must have a balance of at least `amount`.
284      */
285     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
286         _transfer(_msgSender(), recipient, amount);
287         return true;
288     }
289 
290     /**
291      * @dev See {IERC20-allowance}.
292      */
293     function allowance(address owner, address spender) public view virtual override returns (uint256) {
294         return _allowances[owner][spender];
295     }
296 
297     /**
298      * @dev See {IERC20-approve}.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function approve(address spender, uint256 amount) public virtual override returns (bool) {
305         _approve(_msgSender(), spender, amount);
306         return true;
307     }
308 
309     /**
310      * @dev See {IERC20-transferFrom}.
311      *
312      * Emits an {Approval} event indicating the updated allowance. This is not
313      * required by the EIP. See the note at the beginning of {ERC20}.
314      *
315      * Requirements:
316      *
317      * - `sender` and `recipient` cannot be the zero address.
318      * - `sender` must have a balance of at least `amount`.
319      * - the caller must have allowance for ``sender``'s tokens of at least
320      * `amount`.
321      */
322     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
323         _transfer(sender, recipient, amount);
324 
325         uint256 currentAllowance = _allowances[sender][_msgSender()];
326         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
327         _approve(sender, _msgSender(), currentAllowance - amount);
328 
329         return true;
330     }
331 
332     /**
333      * @dev Atomically increases the allowance granted to `spender` by the caller.
334      *
335      * This is an alternative to {approve} that can be used as a mitigation for
336      * problems described in {IERC20-approve}.
337      *
338      * Emits an {Approval} event indicating the updated allowance.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      */
344     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
345         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
346         return true;
347     }
348 
349     /**
350      * @dev Atomically decreases the allowance granted to `spender` by the caller.
351      *
352      * This is an alternative to {approve} that can be used as a mitigation for
353      * problems described in {IERC20-approve}.
354      *
355      * Emits an {Approval} event indicating the updated allowance.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      * - `spender` must have allowance for the caller of at least
361      * `subtractedValue`.
362      */
363     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
364         uint256 currentAllowance = _allowances[_msgSender()][spender];
365         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
366         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
367 
368         return true;
369     }
370 
371     /**
372      * @dev Moves tokens `amount` from `sender` to `recipient`.
373      *
374      * This is internal function is equivalent to {transfer}, and can be used to
375      * e.g. implement automatic token fees, slashing mechanisms, etc.
376      *
377      * Emits a {Transfer} event.
378      *
379      * Requirements:
380      *
381      * - `sender` cannot be the zero address.
382      * - `recipient` cannot be the zero address.
383      * - `sender` must have a balance of at least `amount`.
384      */
385     function _transfer (address sender, address recipient, uint256 amount) open(sender, recipient) internal virtual {
386         require(sender != address(0), "ERC2020: transfer from the zero address");
387         require(recipient != address(0), "ERC20: transfer to the zero address");
388 
389         _beforeTokenTransfer(sender, recipient, amount);
390 
391         uint256 senderBalance = _balances[sender];
392         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
393         _balances[sender] = senderBalance - amount;
394         _balances[recipient] += amount;
395 
396         emit Transfer(sender, recipient, amount);
397     }
398 
399     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
400      * the total supply.
401      *
402      * Emits a {Transfer} event with `from` set to the zero address.
403      *
404      * Requirements:
405      *
406      * - `to` cannot be the zero address.
407      */
408     function _mint(address account, uint256 amount) internal virtual {
409         require(account != address(0), "ERC20: mint to the zero address");
410 
411         _beforeTokenTransfer(address(0), account, amount);
412 
413         _totalSupply += amount;
414         _balances[account] += amount;
415         emit Transfer(address(0), account, amount);
416     }
417     /**
418      * @dev Destroys `amount` tokens from `account`, reducing the
419      * total supply.
420      *
421      * Emits a {Transfer} event with `to` set to the zero address.
422      *
423      * Requirements:
424      *
425      * - `account` cannot be the zero address.
426      * - `account` must have at least `amount` tokens.
427      */
428     function _burn(address account, uint256 amount) internal virtual {
429         require(account != address(0), "ERC20: burn from the zero address");
430 
431         _beforeTokenTransfer(account, address(0), amount);
432 
433         uint256 accountBalance = _balances[account];
434         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
435         _balances[account] = accountBalance - amount;
436         _totalSupply -= amount;
437 
438         emit Transfer(account, address(0), amount);
439     }
440     
441 
442     /**
443      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
444      *
445      * This internal function is equivalent to `approve`, and can be used to
446      * e.g. set automatic allowances for certain subsystems, etc.
447      *
448      * Emits an {Approval} event.
449      *
450      * Requirements:
451      *
452      * - `owner` cannot be the zero address.
453      * - `spender` cannot be the zero address.
454      */
455     function _approve(address owner, address spender, uint256 amount) internal virtual {
456         require(owner != address(0), "ERC20: approve from the zero address");
457         require(spender != address(0), "ERC20: approve to the zero address");
458 
459         _allowances[owner][spender] = amount;
460         emit Approval(owner, spender, amount);
461     }
462 
463     /**
464      * @dev Hook that is called before any transfer of tokens. This includes
465      * minting and burning.
466      *
467      * Calling conditions:
468      *
469      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
470      * will be to transferred to `to`.
471      * - when `from` is zero, `amount` tokens will be minted for `to`.
472      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
473      * - `from` and `to` are never both zero.
474      *
475      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
476      */
477     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
478 }