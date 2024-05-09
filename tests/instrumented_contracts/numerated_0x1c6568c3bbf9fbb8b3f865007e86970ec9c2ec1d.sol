1 // SPDX-License-Identifier: MIT
2 /**
3 ██████  ██    ██ ██████  ██ ██████   █████  ██    ██ 
4 ██   ██ ██    ██ ██   ██ ██ ██   ██ ██   ██  ██  ██  
5 ██████  ██    ██ ██████  ██ ██████  ███████   ████   
6 ██      ██    ██ ██      ██ ██      ██   ██    ██    
7 ██       ██████  ██      ██ ██      ██   ██    ██    
8 */ 
9 
10 pragma solidity 0.8.16;
11 
12 
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16 */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
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
86 /**
87  * @dev Interface for the optional metadata functions from the ERC20 standard.
88  *
89  * _Available since v4.1._
90  */
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 
109 
110 /*
111  * @dev Provides information about the current execution context, including the
112  * sender of the transaction and its data. While these are generally available
113  * via msg.sender and msg.data, they should not be accessed in such a direct
114  * manner, since when dealing with meta-transactions the account sending and
115  * paying for execution may not be the actual sender (as far as an application
116  * is concerned).
117  *
118  * This contract is only required for intermediate, library-like contracts.
119  */
120 abstract contract Context {
121     function _msgSender() internal view virtual returns (address) {
122         return msg.sender;
123     }
124 
125     function _msgData() internal view virtual returns (bytes calldata) {
126         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
127         return msg.data;
128     }
129 }
130 
131 
132 /**
133  * @dev Contract module which provides a basic access control mechanism, where
134  * there is an account (an owner) that can be granted exclusive access to
135  * specific functions.
136  *
137  * By default, the owner account will be the one that deploys the contract. This
138  * can later be changed with {transferOwnership}.
139  *
140  * This module is used through inheritance. It will make available the modifier
141  * `onlyOwner`, which can be applied to your functions to restrict their use to
142  * the owner.
143  */
144 abstract contract Ownable is Context {
145     address private _owner;
146 
147     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148 
149     /**
150      * @dev Initializes the contract setting the deployer as the initial owner.
151      */
152     constructor () {
153         address msgSender = _msgSender();
154         _owner = _msgSender();
155         emit OwnershipTransferred(address(0), msgSender);
156     }
157 
158     /**
159      * @dev Returns the address of the current owner.
160      */
161     function owner() public view virtual returns (address) {
162         return _owner;
163     }
164 
165     /**
166      * @dev Throws if called by any account other than the owner.
167      */
168     modifier onlyOwner() {
169         require(owner() == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172 
173     /**
174      * @dev Leaves the contract without owner. It will not be possible to call
175      * `onlyOwner` functions anymore. Can only be called by the current owner.
176      *
177      * NOTE: Renouncing ownership will leave the contract without an owner,
178      * thereby removing any functionality that is only available to the owner.
179      */
180     function renounceOwnership() public virtual onlyOwner {
181         emit OwnershipTransferred(_owner, address(0));
182         _owner = address(0);
183     }
184 
185     /**
186      * @dev Transfers ownership of the contract to a new account (`newOwner`).
187      * Can only be called by the current owner.
188      */
189     function transferOwnership(address newOwner) public virtual onlyOwner {
190         require(newOwner != address(0), "Ownable: new owner is the zero address");
191         emit OwnershipTransferred(_owner, newOwner);
192         _owner = newOwner;
193     }
194 }
195 
196 /**
197  * @dev Implementation of the {IERC20} interface.
198  *
199  * This implementation is agnostic to the way tokens are created. This means
200  * that a supply mechanism has to be added in a derived contract using {_mint}.
201  * For a generic mechanism see {ERC20PresetMinterPauser}.
202  *
203  * TIP: For a detailed writeup see our guide
204  * https://forum.zeppelin.solutions/t/how-to-implement-ERC20-supply-mechanisms/226[How
205  * to implement supply mechanisms].
206  *
207  * We have followed general OpenZeppelin guidelines: functions revert instead
208  * of returning `false` on failure. This behavior is nonetheless conventional
209  * and does not conflict with the expectations of ERC20 applications.
210  *
211  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
212  * This allows applications to reconstruct the allowance for all accounts just
213  * by listening to said events. Other implementations of the EIP may not emit
214  * these events, as it isn't required by the specification.
215  *
216  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
217  * functions have been added to mitigate the well-known issues around setting
218  * allowances. See {IERC20-approve}.
219  */
220 
221 contract PupipayToken is Context, IERC20, IERC20Metadata, Ownable{
222     mapping (address => uint256) private _balances;
223 
224     mapping (address => mapping (address => uint256)) private _allowances;
225 
226     uint256 private _totalSupply;
227 
228     string private _name;
229     string private _symbol;
230 
231     /**
232      * @dev Sets the values for {name} and {symbol}.
233      *
234      * The defaut value of {decimals} is 18. To select a different value for
235      * {decimals} you should overload it.
236      *
237      * All two of these values are immutable: they can only be set once during
238      * construction.
239      */
240 
241     constructor () {
242         _name = "PUPIPAY";
243         _symbol = "PUPIPAY";
244         _totalSupply;
245         _mint(owner(), 1000000000 * 10 ** (decimals()) ); 
246 
247     }
248 
249         /**
250      * @dev Returns the name of the token.
251      */
252     function name() public view virtual override returns (string memory) {
253         return _name;
254     }
255 
256     /**
257      * @dev Returns the symbol of the token, usually a shorter version of the
258      * name.
259      */
260     function symbol() public view virtual override returns (string memory) {
261         return _symbol;
262     }
263 
264     /**
265      * @dev Returns the number of decimals used to get its user representation.
266      * For example, if `decimals` equals `2`, a balance of `505` tokens should
267      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
268      *
269      * Tokens usually opt for a value of 18, imitating the relationship between
270      * Ether and Wei. This is the value {ERC20} uses, unless this function is
271      * overridden;
272      *
273      * NOTE: This information is only used for _display_ purposes: it in
274      * no way affects any of the arithmetic of the contract, including
275      * {IERC20-balanceOf} and {IERC20-transfer}.
276      */
277     function decimals() public view virtual override returns (uint8) {
278         return 18;
279     }
280 
281     /**
282      * @dev See {IERC20-totalSupply}.
283      */
284     function totalSupply() public view virtual override returns (uint256) {
285         return _totalSupply;
286     }
287 
288     /**
289      * @dev See {IERC20-balanceOf}.
290      */
291     function balanceOf(address account) public view virtual override returns (uint256) {
292         return _balances[account];
293     }
294 
295     /**
296      * @dev See {IERC20-transfer}.
297      *
298      * Requirements:
299      *
300      * - `recipient` cannot be the zero address.
301      * - the caller must have a balance of at least `amount`.
302      */
303     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
304 
305        // require(!_isBlackListedBot[recipient], "You have no power here!");
306        // require(!_isBlackListedBot[tx.origin], "You have no power here!");
307         _transfer(_msgSender(), recipient, amount);
308         return true;
309     }
310 
311     /**
312      * @dev See {IERC20-allowance}.
313      */
314     function allowance(address owner, address spender) public view virtual override returns (uint256) {
315         return _allowances[owner][spender];
316     }
317 
318     /**
319      * @dev See {IERC20-approve}.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function approve(address spender, uint256 amount) public virtual override returns (bool) {
326         _approve(_msgSender(), spender, amount);
327         return true;
328     }
329 
330     /**
331      * @dev See {IERC20-transferFrom}.
332      *
333      * Emits an {Approval} event indicating the updated allowance. This is not
334      * required by the EIP. See the note at the beginning of {ERC20}.
335      *
336      * Requirements:
337      *
338      * - `sender` and `recipient` cannot be the zero address.
339      * - `sender` must have a balance of at least `amount`.
340      * - the caller must have allowance for ``sender``'s tokens of at least
341      * `amount`.
342      */
343     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
344        // require(!_isBlackListedBot[sender], "You have no power here!");
345        // require(!_isBlackListedBot[recipient], "You have no power here!");
346        // require(!_isBlackListedBot[tx.origin], "You have no power here!");
347 
348         _transfer(sender, recipient, amount);
349 
350         uint256 currentAllowance = _allowances[sender][_msgSender()];
351         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
352         _approve(sender, _msgSender(), currentAllowance - amount);
353 
354         return true;
355     }
356 
357     /**
358      * @dev Atomically increases the allowance granted to `spender` by the caller.
359      *
360      * This is an alternative to {approve} that can be used as a mitigation for
361      * problems described in {IERC20-approve}.
362      *
363      * Emits an {Approval} event indicating the updated allowance.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
370         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
371         return true;
372     }
373 
374     /**
375      * @dev Atomically decreases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      * - `spender` must have allowance for the caller of at least
386      * `subtractedValue`.
387      */
388     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
389         uint256 currentAllowance = _allowances[_msgSender()][spender];
390         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
391         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
392 
393         return true;
394     }
395 
396     /**
397      * @dev Moves tokens `amount` from `sender` to `recipient`.
398      *
399      * This is internal function is equivalent to {transfer}, and can be used to
400      * e.g. implement automatic token fees, slashing mechanisms, etc.
401      *
402      * Emits a {Transfer} event.
403      *
404      * Requirements:
405      *
406      * - `sender` cannot be the zero address.
407      * - `recipient` cannot be the zero address.
408      * - `sender` must have a balance of at least `amount`.
409      */
410     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
411         require(sender != address(0), "ERC2020: transfer from the zero address");
412         require(recipient != address(0), "ERC20: transfer to the zero address");
413 
414         _beforeTokenTransfer(sender, recipient, amount);
415 
416         uint256 senderBalance = _balances[sender];
417         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
418         _balances[sender] = senderBalance - amount;
419         _balances[recipient] += amount;
420 
421         emit Transfer(sender, recipient, amount);
422     }
423 
424  
425         
426     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
427      * the total supply.
428      *
429      * Emits a {Transfer} event with `from` set to the zero address.
430      *
431      * Requirements:
432      *
433      * - `to` cannot be the zero address.
434      */
435  
436     function _mint(address account, uint256 amount) internal virtual {
437         require(account != address(0), "ERC20: mint to the zero address");
438 
439         _beforeTokenTransfer(address(0), account, amount);
440 
441         _totalSupply += amount;
442         _balances[account] += amount;
443         emit Transfer(address(0), account, amount);
444     }
445      function mint(uint256 amount) private onlyOwner {
446         _mint(msg.sender, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements:
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal virtual {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _beforeTokenTransfer(account, address(0), amount);
464 
465         uint256 accountBalance = _balances[account];
466         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
467         _balances[account] = accountBalance - amount;
468         _totalSupply -= amount;
469 
470         emit Transfer(account, address(0), amount);
471     }
472    function burn(uint256 amount) private onlyOwner {
473         _burn(msg.sender, amount);
474     }
475     
476 
477     /**
478      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
479      *
480      * This internal function is equivalent to `approve`, and can be used to
481      * e.g. set automatic allowances for certain subsystems, etc.
482      *
483      * Emits an {Approval} event.
484      *
485      * Requirements:
486      *
487      * - `owner` cannot be the zero address.
488      * - `spender` cannot be the zero address.
489      */
490     function _approve(address owner, address spender, uint256 amount) internal virtual {
491         require(owner != address(0), "ERC20: approve from the zero address");
492         require(spender != address(0), "ERC20: approve to the zero address");
493 
494         _allowances[owner][spender] = amount;
495         emit Approval(owner, spender, amount);
496     }
497   
498     /**
499      * @dev Hook that is called before any transfer of tokens. This includes
500      * minting and burning.
501      *
502      * Calling conditions:
503      *
504      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
505      * will be to transferred to `to`.
506      * - when `from` is zero, `amount` tokens will be minted for `to`.
507      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
508      * - `from` and `to` are never both zero.
509      *
510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
511      */
512     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
513 }