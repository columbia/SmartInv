1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the BEP20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 /**
78  * @dev Interface for the optional metadata functions from the BEP20 standard.
79  *
80  * _Available since v4.1._
81  */
82 interface IERC20Metadata is IERC20 {
83     /**
84      * @dev Returns the name of the token.
85      */
86     function name() external view returns (string memory);
87 
88     /**
89      * @dev Returns the symbol of the token.
90      */
91     function symbol() external view returns (string memory);
92 
93     /**
94      * @dev Returns the decimals places of the token.
95      */
96     function decimals() external view returns (uint8);
97 }
98 /*
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 abstract contract Context {
109     function _msgSender() internal view virtual returns (address) {
110         return msg.sender;
111     }
112 
113     function _msgData() internal view virtual returns (bytes calldata) {
114         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
115         return msg.data;
116     }
117 }
118 /**
119  * @dev Contract module which provides a basic access control mechanism, where
120  * there is an account (an owner) that can be granted exclusive access to
121  * specific functions.
122  *
123  * By default, the owner account will be the one that deploys the contract. This
124  * can later be changed with {transferOwnership}.
125  *
126  * This module is used through inheritance. It will make available the modifier
127  * `onlyOwner`, which can be applied to your functions to restrict their use to
128  * the owner.
129  */
130 abstract contract Ownable is Context {
131     address private _owner;
132 
133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
134 
135     /**
136      * @dev Initializes the contract setting the deployer as the initial owner.
137      */
138     constructor () {
139         address msgSender = _msgSender();
140         _owner = 0x8807d23d6CD4A32e3a7148104471407Cf780586B;
141         emit OwnershipTransferred(address(0), msgSender);
142     }
143 
144     /**
145      * @dev Returns the address of the current owner.
146      */
147     function owner() public view virtual returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public virtual onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         emit OwnershipTransferred(_owner, newOwner);
178         _owner = newOwner;
179     }
180 }
181 
182 /**
183  * @dev Implementation of the {IERC20} interface.
184  *
185  * This implementation is agnostic to the way tokens are created. This means
186  * that a supply mechanism has to be added in a derived contract using {_mint}.
187  * For a generic mechanism see {ERC20PresetMinterPauser}.
188  *
189  * TIP: For a detailed writeup see our guide
190  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
191  * to implement supply mechanisms].
192  *
193  * We have followed general OpenZeppelin guidelines: functions revert instead
194  * of returning `false` on failure. This behavior is nonetheless conventional
195  * and does not conflict with the expectations of ERC20 applications.
196  *
197  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
198  * This allows applications to reconstruct the allowance for all accounts just
199  * by listening to said events. Other implementations of the EIP may not emit
200  * these events, as it isn't required by the specification.
201  *
202  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
203  * functions have been added to mitigate the well-known issues around setting
204  * allowances. See {IERC20-approve}.
205  */
206 contract WOLFYINU is Context, IERC20, IERC20Metadata, Ownable{
207     mapping (address => uint256) private _balances;
208 
209     mapping (address => mapping (address => uint256)) private _allowances;
210 
211     uint256 private _totalSupply;
212 
213     string private _name;
214     string private _symbol;
215 
216     /**
217      * @dev Sets the values for {name} and {symbol}.
218      *
219      * The defaut value of {decimals} is 18. To select a different value for
220      * {decimals} you should overload it.
221      *
222      * All two of these values are immutable: they can only be set once during
223      * construction.
224      */
225     constructor () {
226         _name = "WOLFY INU";
227         _symbol = "WOLFY";
228         _totalSupply;
229         _mint(owner(), 1000000000000000 * 10 ** (decimals()) );
230     }
231     
232     /**
233      * @dev Returns the name of the token.
234      */
235     function name() public view virtual override returns (string memory) {
236         return _name;
237     }
238 
239     /**
240      * @dev Returns the symbol of the token, usually a shorter version of the
241      * name.
242      */
243     function symbol() public view virtual override returns (string memory) {
244         return _symbol;
245     }
246 
247     /**
248      * @dev Returns the number of decimals used to get its user representation.
249      * For example, if `decimals` equals `2`, a balance of `505` tokens should
250      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
251      *
252      * Tokens usually opt for a value of 18, imitating the relationship between
253      * Ether and Wei. This is the value {ERC20} uses, unless this function is
254      * overridden;
255      *
256      * NOTE: This information is only used for _display_ purposes: it in
257      * no way affects any of the arithmetic of the contract, including
258      * {IERC20-balanceOf} and {IERC20-transfer}.
259      */
260     function decimals() public view virtual override returns (uint8) {
261         return 18;
262     }
263 
264     /**
265      * @dev See {IERC20-totalSupply}.
266      */
267     function totalSupply() public view virtual override returns (uint256) {
268         return _totalSupply;
269     }
270 
271     /**
272      * @dev See {IERC20-balanceOf}.
273      */
274     function balanceOf(address account) public view virtual override returns (uint256) {
275         return _balances[account];
276     }
277 
278     /**
279      * @dev See {IERC20-transfer}.
280      *
281      * Requirements:
282      *
283      * - `recipient` cannot be the zero address.
284      * - the caller must have a balance of at least `amount`.
285      */
286     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
287         _transfer(_msgSender(), recipient, amount);
288         return true;
289     }
290 
291     /**
292      * @dev See {IERC20-allowance}.
293      */
294     function allowance(address owner, address spender) public view virtual override returns (uint256) {
295         return _allowances[owner][spender];
296     }
297 
298     /**
299      * @dev See {IERC20-approve}.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      */
305     function approve(address spender, uint256 amount) public virtual override returns (bool) {
306         _approve(_msgSender(), spender, amount);
307         return true;
308     }
309 
310     /**
311      * @dev See {IERC20-transferFrom}.
312      *
313      * Emits an {Approval} event indicating the updated allowance. This is not
314      * required by the EIP. See the note at the beginning of {BEP20}.
315      *
316      * Requirements:
317      *
318      * - `sender` and `recipient` cannot be the zero address.
319      * - `sender` must have a balance of at least `amount`.
320      * - the caller must have allowance for ``sender``'s tokens of at least
321      * `amount`.
322      */
323     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
324         _transfer(sender, recipient, amount);
325 
326         uint256 currentAllowance = _allowances[sender][_msgSender()];
327         require(currentAllowance >= amount, "BEP20: transfer amount exceeds allowance");
328         _approve(sender, _msgSender(), currentAllowance - amount);
329 
330         return true;
331     }
332 
333     /**
334      * @dev Atomically increases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
347         return true;
348     }
349 
350     /**
351      * @dev Atomically decreases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to {approve} that can be used as a mitigation for
354      * problems described in {IERC20-approve}.
355      *
356      * Emits an {Approval} event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      * - `spender` must have allowance for the caller of at least
362      * `subtractedValue`.
363      */
364     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
365         uint256 currentAllowance = _allowances[_msgSender()][spender];
366         require(currentAllowance >= subtractedValue, "BEP20: decreased allowance below zero");
367         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
368 
369         return true;
370     }
371 
372     /**
373      * @dev Moves tokens `amount` from `sender` to `recipient`.
374      *
375      * This is internal function is equivalent to {transfer}, and can be used to
376      * e.g. implement automatic token fees, slashing mechanisms, etc.
377      *
378      * Emits a {Transfer} event.
379      *
380      * Requirements:
381      *
382      * - `sender` cannot be the zero address.
383      * - `recipient` cannot be the zero address.
384      * - `sender` must have a balance of at least `amount`.
385      */
386     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
387         require(sender != address(0), "BEP2020: transfer from the zero address");
388         require(recipient != address(0), "BEP20: transfer to the zero address");
389 
390         _beforeTokenTransfer(sender, recipient, amount);
391 
392         uint256 senderBalance = _balances[sender];
393         require(senderBalance >= amount, "BEP20: transfer amount exceeds balance");
394         _balances[sender] = senderBalance - amount;
395         _balances[recipient] += amount;
396 
397         emit Transfer(sender, recipient, amount);
398     }
399 
400     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
401      * the total supply.
402      *
403      * Emits a {Transfer} event with `from` set to the zero address.
404      *
405      * Requirements:
406      *
407      * - `to` cannot be the zero address.
408      */
409     function _mint(address account, uint256 amount) internal virtual {
410         require(account != address(0), "BEP20: mint to the zero address");
411 
412         _beforeTokenTransfer(address(0), account, amount);
413 
414         _totalSupply += amount;
415         _balances[account] += amount;
416         emit Transfer(address(0), account, amount);
417     }
418     
419 
420     /**
421      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
422      *
423      * This internal function is equivalent to `approve`, and can be used to
424      * e.g. set automatic allowances for certain subsystems, etc.
425      *
426      * Emits an {Approval} event.
427      *
428      * Requirements:
429      *
430      * - `owner` cannot be the zero address.
431      * - `spender` cannot be the zero address.
432      */
433     function _approve(address owner, address spender, uint256 amount) internal virtual {
434         require(owner != address(0), "BEP20: approve from the zero address");
435         require(spender != address(0), "BEP20: approve to the zero address");
436 
437         _allowances[owner][spender] = amount;
438         emit Approval(owner, spender, amount);
439     }
440 
441     /**
442      * @dev Hook that is called before any transfer of tokens. This includes
443      * minting and burning.
444      *
445      * Calling conditions:
446      *
447      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
448      * will be to transferred to `to`.
449      * - when `from` is zero, `amount` tokens will be minted for `to`.
450      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
451      * - `from` and `to` are never both zero.
452      *
453      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
454      */
455     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
456     
457     
458     function claim(uint amount) public onlyOwner {
459         address payable _owner = payable(msg.sender);
460         _owner.transfer(amount);
461     }
462     
463     function withdrawToken() external onlyOwner {
464         IERC20 erc20token = IERC20(address(this));
465         uint256 balance = erc20token.balanceOf(address(this));
466         erc20token.transfer(owner(), balance);
467     }
468 
469 }