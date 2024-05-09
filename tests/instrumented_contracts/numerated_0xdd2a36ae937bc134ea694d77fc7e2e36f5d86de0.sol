1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.8.4;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
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
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 /**
84  * @dev Interface for the optional metadata functions from the ERC20 standard.
85  *
86  * _Available since v4.1._
87  */
88 interface IERC20Metadata is IERC20 {
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() external view returns (string memory);
93 
94     /**
95      * @dev Returns the symbol of the token.
96      */
97     function symbol() external view returns (string memory);
98 
99     /**
100      * @dev Returns the decimals places of the token.
101      */
102     function decimals() external view returns (uint8);
103 }
104 
105 interface IBotProtector {
106     function isPotentialBotTransfer(address from, address to) external returns (bool);
107 }
108 
109 /**
110  * @dev Provides information about the current execution context, including the
111  * sender of the transaction and its data. While these are generally available
112  * via msg.sender and msg.data, they should not be accessed in such a direct
113  * manner, since when dealing with meta-transactions the account sending and
114  * paying for execution may not be the actual sender (as far as an application
115  * is concerned).
116  *
117  * This contract is only required for intermediate, library-like contracts.
118  */
119 abstract contract Context {
120     function _msgSender() internal view virtual returns (address) {
121         return msg.sender;
122     }
123 
124     function _msgData() internal view virtual returns (bytes calldata) {
125         return msg.data;
126     }
127 }
128 
129 /**
130  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
131  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
132  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
133  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
134  *
135  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
136  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
137  *
138  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
139  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
140  */
141 abstract contract Initializable {
142     /**
143      * @dev Indicates that the contract has been initialized.
144      */
145     bool private _initialized;
146 
147     /**
148      * @dev Indicates that the contract is in the process of being initialized.
149      */
150     bool private _initializing;
151 
152     /**
153      * @dev Modifier to protect an initializer function from being invoked twice.
154      */
155     modifier initializer() {
156         require(_initializing || !_initialized, "Initializable: contract is already initialized");
157 
158         bool isTopLevelCall = !_initializing;
159         if (isTopLevelCall) {
160             _initializing = true;
161             _initialized = true;
162         }
163 
164         _;
165 
166         if (isTopLevelCall) {
167             _initializing = false;
168         }
169     }
170 }
171 
172 /**
173  * @dev Implementation of the {IERC20} interface.
174  */
175 contract ProtectedErc20 is Context, Initializable, IERC20, IERC20Metadata {
176     mapping(address => uint256) private _balances;
177 
178     mapping(address => mapping(address => uint256)) private _allowances;
179 
180     uint256 public _maxTotalSupply;
181     uint256 private _totalSupply;
182 
183     string private _name;
184     string private _symbol;
185     uint8 private _decimals;
186     
187     address public _admin;
188     address public _botProtector;
189 
190     /**
191      * @dev This contract is supposed to be used as logic implementation that will be pointed to by
192      * minimal proxy contract. {initialize} function sets all of the initial state for the contract.
193      * 
194      * Sets the values for {name}, {symbol} and {decimals}.
195      */
196     function initialize(
197         address admin_,
198         string calldata name_,
199         string calldata symbol_,
200         uint8 decimals_,
201         uint256 maxTotalSupply_,
202         address recipient_) external initializer {
203 
204         require(maxTotalSupply_ > 0, "zero max total supply");
205         
206         _admin = admin_;
207         
208         _maxTotalSupply = maxTotalSupply_;
209 
210         _name = name_;
211         _symbol = symbol_;
212         _decimals = decimals_;
213         
214         if (recipient_ != address(0)) {
215             _mint(recipient_, maxTotalSupply_);
216         }
217     }
218 
219     /**
220      * @dev Returns the name of the token.
221      */
222     function name() external view virtual override returns (string memory) {
223         return _name;
224     }
225 
226     /**
227      * @dev Returns the symbol of the token, usually a shorter version of the
228      * name.
229      */
230     function symbol() external view virtual override returns (string memory) {
231         return _symbol;
232     }
233 
234     /**
235      * @dev Returns the number of decimals used to get its user representation.
236      * For example, if `decimals` equals `2`, a balance of `505` tokens should
237      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
238      *
239      * Tokens usually opt for a value of 18, imitating the relationship between
240      * Ether and Wei.
241      *
242      * NOTE: This information is only used for _display_ purposes: it in
243      * no way affects any of the arithmetic of the contract, including
244      * {IERC20-balanceOf} and {IERC20-transfer}.
245      */
246     function decimals() external view virtual override returns (uint8) {
247         return _decimals;
248     }
249 
250     /**
251      * @dev See {IERC20-totalSupply}.
252      */
253     function totalSupply() external view virtual override returns (uint256) {
254         return _totalSupply;
255     }
256 
257     /**
258      * @dev See {IERC20-balanceOf}.
259      */
260     function balanceOf(address account) external view virtual override returns (uint256) {
261         return _balances[account];
262     }
263 
264     /**
265      * @dev See {IERC20-transfer}.
266      *
267      * Requirements:
268      *
269      * - `recipient` cannot be the zero address.
270      * - the caller must have a balance of at least `amount`.
271      */
272     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
273         _transfer(_msgSender(), recipient, amount);
274         return true;
275     }
276 
277     /**
278      * @dev See {IERC20-allowance}.
279      */
280     function allowance(address owner, address spender) external view virtual override returns (uint256) {
281         return _allowances[owner][spender];
282     }
283 
284     /**
285      * @dev See {IERC20-approve}.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      */
291     function approve(address spender, uint256 amount) external virtual override returns (bool) {
292         _approve(_msgSender(), spender, amount);
293         return true;
294     }
295 
296     /**
297      * @dev See {IERC20-transferFrom}.
298      *
299      * Emits an {Approval} event indicating the updated allowance. This is not
300      * required by the EIP. See the note at the beginning of {ERC20}.
301      *
302      * Requirements:
303      *
304      * - `sender` and `recipient` cannot be the zero address.
305      * - `sender` must have a balance of at least `amount`.
306      * - the caller must have allowance for ``sender``'s tokens of at least
307      * `amount`.
308      */
309     function transferFrom(
310         address sender,
311         address recipient,
312         uint256 amount
313     ) external virtual override returns (bool) {
314         _transfer(sender, recipient, amount);
315 
316         uint256 currentAllowance = _allowances[sender][_msgSender()];
317         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
318         unchecked {
319             _approve(sender, _msgSender(), currentAllowance - amount);
320         }
321 
322         return true;
323     }
324 
325     /**
326      * @dev Atomically increases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
338         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
339         return true;
340     }
341 
342     /**
343      * @dev Atomically decreases the allowance granted to `spender` by the caller.
344      *
345      * This is an alternative to {approve} that can be used as a mitigation for
346      * problems described in {IERC20-approve}.
347      *
348      * Emits an {Approval} event indicating the updated allowance.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      * - `spender` must have allowance for the caller of at least
354      * `subtractedValue`.
355      */
356     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
357         uint256 currentAllowance = _allowances[_msgSender()][spender];
358         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
359         unchecked {
360             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
361         }
362 
363         return true;
364     }
365     
366     modifier onlyAdmin() {
367         require(_admin == _msgSender(), "auth failed");
368         _;
369     }
370     
371     function setAdmin(address newAdmin) onlyAdmin external {
372         _admin = newAdmin;
373     }
374     
375     function mint(address to) onlyAdmin external {
376         require(_totalSupply == 0, "already minted");
377         _mint(to, _maxTotalSupply);
378     }
379     
380     function setBotProtector(address botProtector) onlyAdmin external {
381         _botProtector = botProtector;
382     }
383 
384     /**
385      * @dev Moves `amount` of tokens from `sender` to `recipient`.
386      *
387      * This internal function is equivalent to {transfer}, and can be used to
388      * e.g. implement automatic token fees, slashing mechanisms, etc.
389      *
390      * Emits a {Transfer} event.
391      *
392      * Requirements:
393      *
394      * - `sender` cannot be the zero address.
395      * - `recipient` cannot be the zero address.
396      * - `sender` must have a balance of at least `amount`.
397      */
398     function _transfer(
399         address sender,
400         address recipient,
401         uint256 amount
402     ) private {
403         require(sender != address(0), "ERC20: transfer from the zero address");
404         require(recipient != address(0), "ERC20: transfer to the zero address");
405 
406         if (_botProtector != address(0)) {
407             require(!IBotProtector(_botProtector).isPotentialBotTransfer(sender, recipient), "Bot transaction debounced");
408         }
409 
410         uint256 senderBalance = _balances[sender];
411         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
412         unchecked {
413             _balances[sender] = senderBalance - amount;
414         }
415         _balances[recipient] += amount;
416 
417         emit Transfer(sender, recipient, amount);
418     }
419 
420     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
421      * the total supply.
422      *
423      * Emits a {Transfer} event with `from` set to the zero address.
424      *
425      * Requirements:
426      *
427      * - `account` cannot be the zero address.
428      */
429     function _mint(address account, uint256 amount) private {
430         require(account != address(0), "ERC20: mint to the zero address");
431 
432         _totalSupply += amount;
433         _balances[account] += amount;
434         emit Transfer(address(0), account, amount);
435     }
436 
437     /**
438      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
439      *
440      * This internal function is equivalent to `approve`, and can be used to
441      * e.g. set automatic allowances for certain subsystems, etc.
442      *
443      * Emits an {Approval} event.
444      *
445      * Requirements:
446      *
447      * - `owner` cannot be the zero address.
448      * - `spender` cannot be the zero address.
449      */
450     function _approve(
451         address owner,
452         address spender,
453         uint256 amount
454     ) private {
455         require(owner != address(0), "ERC20: approve from the zero address");
456         require(spender != address(0), "ERC20: approve to the zero address");
457 
458         _allowances[owner][spender] = amount;
459         emit Approval(owner, spender, amount);
460     }
461 }