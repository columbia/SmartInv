1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
29  * the optional functions; to access them see {ERC20Detailed}.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86     
87 
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @dev Interface for the optional metadata functions from the ERC20 standard.
106  *
107  * _Available since v4.1._
108  */
109 interface IERC20Metadata is IERC20 {
110     /**
111      * @dev Returns the name of the token.
112      */
113     function name() external view returns (string memory);
114 
115     /**
116      * @dev Returns the symbol of the token.
117      */
118     function symbol() external view returns (string memory);
119 
120     /**
121      * @dev Returns the decimals places of the token.
122      */
123     function decimals() external view returns (uint8);
124 }
125 
126 /**
127  * @dev Implementation of the {IERC20} interface.
128  *
129  * This implementation is agnostic to the way tokens are created. This means
130  * that a supply mechanism has to be added in a derived contract using {_mint}.
131  * For a generic mechanism see {ERC20PresetMinterPauser}.
132  *
133  * TIP: For a detailed writeup see our guide
134  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
135  * to implement supply mechanisms].
136  *
137  * We have followed general OpenZeppelin guidelines: functions revert instead
138  * of returning `false` on failure. This behavior is nonetheless conventional
139  * and does not conflict with the expectations of ERC20 applications.
140  *
141  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
142  * This allows applications to reconstruct the allowance for all accounts just
143  * by listening to said events. Other implementations of the EIP may not emit
144  * these events, as it isn't required by the specification.
145  *
146  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
147  * functions have been added to mitigate the well-known issues around setting
148  * allowances. See {IERC20-approve}.
149  */
150 contract ERC20 is Context, IERC20, IERC20Metadata {
151     mapping (address => uint256) private _balances;
152 
153     mapping (address => mapping (address => uint256)) private _allowances;
154 
155     uint256 private _totalSupply;
156 
157     string private _name;
158     string private _symbol;
159     bool public tokenLocked = false;
160     mapping (address => bool) public RestrictedAddress;
161    
162 
163     /**
164      * @dev Sets the values for {name} and {symbol}.
165      *
166      * The default value of {decimals} is 18. To select a different value for
167      * {decimals} you should overload it.
168      *
169      * All two of these values are immutable: they can only be set once during
170      * construction.
171      */
172     constructor (string memory name_, string memory symbol_) {
173         _name = name_;
174         _symbol = symbol_;
175         
176     }
177 
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() public view virtual override returns (string memory) {
182         return _name;
183     }
184 
185     /**
186      * @dev Returns the symbol of the token, usually a shorter version of the
187      * name.
188      */
189     function symbol() public view virtual override returns (string memory) {
190         return _symbol;
191     }
192 
193     /**
194      * @dev Returns the number of decimals used to get its user representation.
195      * For example, if `decimals` equals `2`, a balance of `505` tokens should
196      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
197      *
198      * Tokens usually opt for a value of 18, imitating the relationship between
199      * Ether and Wei. This is the value {ERC20} uses, unless this function is
200      * overridden;
201      *
202      * NOTE: This information is only used for _display_ purposes: it in
203      * no way affects any of the arithmetic of the contract, including
204      * {IERC20-balanceOf} and {IERC20-transfer}.
205      */
206     function decimals() public view virtual override returns (uint8) {
207         return 18;
208     }
209 
210     /**
211      * @dev See {IERC20-totalSupply}.
212      */
213     function totalSupply() public view virtual override returns (uint256) {
214         return _totalSupply;
215     }
216 
217     /**
218      * @dev See {IERC20-balanceOf}.
219      */
220     function balanceOf(address account) public view virtual override returns (uint256) {
221         return _balances[account];
222     }
223 
224     /**
225      * @dev See {IERC20-transfer}.
226      *
227      * Requirements:
228      *
229      * - `recipient` cannot be the zero address.
230      * - the caller must have a balance of at least `amount`.
231      * 
232      */
233      
234      
235      
236     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
237           require(tokenLocked == false, 'token locked' );
238           require( RestrictedAddress[msg.sender] != true,  'msg.sender restricted from transfers');
239         _transfer(_msgSender(), recipient, amount);
240         return true;
241     }
242 
243     /**
244      * @dev See {IERC20-allowance}.
245      */
246     function allowance(address owner, address spender) public view virtual override returns (uint256) {
247         return _allowances[owner][spender];
248     }
249 
250     /**
251      * @dev See {IERC20-approve}.
252      *
253      * Requirements:
254      *
255      * - `spender` cannot be the zero address.
256      */
257     function approve(address spender, uint256 amount) public virtual override returns (bool) {
258         _approve(_msgSender(), spender, amount);
259         return true;
260     }
261 
262     /**
263      * @dev See {IERC20-transferFrom}.
264      *
265      * Emits an {Approval} event indicating the updated allowance. This is not
266      * required by the EIP. See the note at the beginning of {ERC20}.
267      *
268      * Requirements:
269      *
270      * - `sender` and `recipient` cannot be the zero address.
271      * - `sender` must have a balance of at least `amount`.
272      * - the caller must have allowance for ``sender``'s tokens of at least
273      * `amount`.
274      */
275     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
276           require(tokenLocked == false, 'token locked');
277              require( RestrictedAddress[sender] != true,  'sender restricted from transfers');
278         _transfer(sender, recipient, amount);
279 
280         uint256 currentAllowance = _allowances[sender][_msgSender()];
281         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
282         _approve(sender, _msgSender(), currentAllowance - amount);
283 
284         return true;
285     }
286 
287     /**
288      * @dev Atomically increases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to {approve} that can be used as a mitigation for
291      * problems described in {IERC20-approve}.
292      *
293      * Emits an {Approval} event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
300         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
301         return true;
302     }
303 
304     /**
305      * @dev Atomically decreases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      * - `spender` must have allowance for the caller of at least
316      * `subtractedValue`.
317      */
318     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
319         uint256 currentAllowance = _allowances[_msgSender()][spender];
320         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
321         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
322 
323         return true;
324     }
325 
326     /**
327      * @dev Moves tokens `amount` from `sender` to `recipient`.
328      *
329      * This is internal function is equivalent to {transfer}, and can be used to
330      * e.g. implement automatic token fees, slashing mechanisms, etc.
331      *
332      * Emits a {Transfer} event.
333      *
334      * Requirements:
335      *
336      * - `sender` cannot be the zero address.
337      * - `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `amount`.
339      */
340     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
341         require(sender != address(0), "ERC20: transfer from the zero address");
342         require(recipient != address(0), "ERC20: transfer to the zero address");
343 
344         _beforeTokenTransfer(sender, recipient, amount);
345 
346         uint256 senderBalance = _balances[sender];
347         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
348         _balances[sender] = senderBalance - amount;
349         _balances[recipient] += amount;
350 
351         emit Transfer(sender, recipient, amount);
352     }
353 
354     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
355      * the total supply.
356      *
357      * Emits a {Transfer} event with `from` set to the zero address.
358      *
359      * Requirements:
360      *
361      * - `account` cannot be the zero address.
362      */
363     function _mint(address account, uint256 amount) internal virtual {
364         require(account != address(0), "ERC20: mint to the zero address");
365 
366         _beforeTokenTransfer(address(0), account, amount);
367 
368         _totalSupply += amount;
369         _balances[account] += amount;
370         emit Transfer(address(0), account, amount);
371     }
372 
373     /**
374      * @dev Destroys `amount` tokens from `account`, reducing the
375      * total supply.
376      *
377      * Emits a {Transfer} event with `to` set to the zero address.
378      *
379      * Requirements:
380      *
381      * - `account` cannot be the zero address.
382      * - `account` must have at least `amount` tokens.
383      */
384     function _burn(address account, uint256 amount) internal virtual {
385         require(account != address(0), "ERC20: burn from the zero address");
386 
387         _beforeTokenTransfer(account, address(0), amount);
388 
389         uint256 accountBalance = _balances[account];
390         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
391         _balances[account] = accountBalance - amount;
392         _totalSupply -= amount;
393 
394         emit Transfer(account, address(0), amount);
395     }
396 
397     /**
398      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
399      *
400      * This internal function is equivalent to `approve`, and can be used to
401      * e.g. set automatic allowances for certain subsystems, etc.
402      *
403      * Emits an {Approval} event.
404      *
405      * Requirements:
406      *
407      * - `owner` cannot be the zero address.
408      * - `spender` cannot be the zero address.
409      */
410     function _approve(address owner, address spender, uint256 amount) internal virtual {
411         require(owner != address(0), "ERC20: approve from the zero address");
412         require(spender != address(0), "ERC20: approve to the zero address");
413 
414         _allowances[owner][spender] = amount;
415         emit Approval(owner, spender, amount);
416     }
417 
418     /**
419      * @dev Hook that is called before any transfer of tokens. This includes
420      * minting and burning.
421      *
422      * Calling conditions:
423      *
424      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
425      * will be to transferred to `to`.
426      * - when `from` is zero, `amount` tokens will be minted for `to`.
427      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
428      * - `from` and `to` are never both zero.
429      *
430      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
431      */
432     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
433 }
434 
435 contract SMETA is ERC20 {
436     address owner;
437     string Name = "StarkMeta Token";
438     string Symbol = "SMETA";
439 
440     constructor() ERC20(Name, Symbol) {
441         owner = msg.sender;
442         uint256 initialSupply = 2000000000 * 10**18;
443         _mint(owner, initialSupply);
444     }
445 
446     modifier onlyOwner() {
447         require(owner == msg.sender, "caller is not admin");
448         _;
449     }
450 
451     function BeginTokenLock() external onlyOwner {
452         tokenLocked = true;
453     }
454 
455     function EndTokenLock() external onlyOwner {
456         tokenLocked = false;
457     }
458 
459     function RestrictAddress(address _addressToBeRestricted) public onlyOwner {
460         RestrictedAddress[_addressToBeRestricted] = true;
461     }
462 
463     function UnrestrictAddress(address _addressToBeUnrestricted)
464         public
465         onlyOwner
466     {
467         RestrictedAddress[_addressToBeUnrestricted] = false;
468     }
469 
470     function setNewOwner(address _owner) external onlyOwner {
471         owner = _owner;
472     }
473 
474     function mint(address recipient, uint256 amount) external onlyOwner {
475         require(tokenLocked == false, "token locked");
476         _mint(recipient, amount);
477     }
478 
479     function burn(address recipient, uint256 amount) external onlyOwner {
480         require(tokenLocked == false, "token locked");
481         _burn(recipient, amount);
482     }
483 }