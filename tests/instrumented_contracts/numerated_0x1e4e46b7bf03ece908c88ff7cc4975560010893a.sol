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
105 /**
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
119 }
120 
121 /**
122  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
123  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
124  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
125  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
126  *
127  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
128  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
129  *
130  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
131  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
132  */
133 abstract contract Initializable {
134     /**
135      * @dev Indicates that the contract has been initialized.
136      */
137     bool private _initialized;
138 
139     /**
140      * @dev Indicates that the contract is in the process of being initialized.
141      */
142     bool private _initializing;
143 
144     /**
145      * @dev Modifier to protect an initializer function from being invoked twice.
146      */
147     modifier initializer() {
148         require(_initializing || !_initialized, "Initializable: contract is already initialized");
149 
150         bool isTopLevelCall = !_initializing;
151         if (isTopLevelCall) {
152             _initializing = true;
153             _initialized = true;
154         }
155 
156         _;
157 
158         if (isTopLevelCall) {
159             _initializing = false;
160         }
161     }
162 }
163 
164 interface IStatsTracker {
165     function updateTransferStats(address asset, address from, address to, uint256 amount) external;
166 }
167 
168 /**
169  * @dev Implementation of the {IERC20} interface.
170  */
171 contract Erc20Token is Context, Initializable, IERC20, IERC20Metadata {
172     mapping(address => uint256) private _balances;
173 
174     mapping(address => mapping(address => uint256)) private _allowances;
175 
176     uint256 public _maxTotalSupply;
177     uint256 private _totalSupply;
178 
179     string private _name;
180     string private _symbol;
181     uint8 private _decimals;
182     
183     address public _admin;
184     address public _adminCandidate;
185     address public _statsTracker;
186     
187     string private constant ERROR_AUTH_FAILED = "auth failed";
188     
189     event AdminChangeRequested(address oldAdmin, address newAdmin);
190     event AdminChangeConfirmed(address oldAdmin, address newAdmin);
191     
192     constructor() initializer {}
193 
194     /**
195      * @dev This contract is supposed to be used as logic implementation that will be pointed to by
196      * minimal proxy contract. {initialize} function sets all of the initial state for the contract.
197      * 
198      * Sets the values for {name}, {symbol} and {decimals}.
199      */
200     function initialize(
201         address admin_,
202         string calldata name_,
203         string calldata symbol_,
204         uint8 decimals_,
205         uint256 maxTotalSupply_,
206         address recipient_,
207         address statsTracker_) external initializer {
208 
209         _ensureNotZeroAddress(admin_);
210         require(maxTotalSupply_ > 0, "zero max total supply");
211         
212         _admin = admin_;
213         
214         _maxTotalSupply = maxTotalSupply_;
215 
216         _name = name_;
217         _symbol = symbol_;
218         _decimals = decimals_;
219         
220         if (recipient_ != address(0)) {
221             _mint(recipient_, maxTotalSupply_);
222         }
223         
224         if (statsTracker_ != address(0)) {
225             _statsTracker = statsTracker_;
226         }
227     }
228 
229     /**
230      * @dev Returns the name of the token.
231      */
232     function name() external view virtual override returns (string memory) {
233         return _name;
234     }
235 
236     /**
237      * @dev Returns the symbol of the token, usually a shorter version of the
238      * name.
239      */
240     function symbol() external view virtual override returns (string memory) {
241         return _symbol;
242     }
243 
244     /**
245      * @dev Returns the number of decimals used to get its user representation.
246      * For example, if `decimals` equals `2`, a balance of `505` tokens should
247      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
248      *
249      * Tokens usually opt for a value of 18, imitating the relationship between
250      * Ether and Wei.
251      *
252      * NOTE: This information is only used for _display_ purposes: it in
253      * no way affects any of the arithmetic of the contract, including
254      * {IERC20-balanceOf} and {IERC20-transfer}.
255      */
256     function decimals() external view virtual override returns (uint8) {
257         return _decimals;
258     }
259 
260     /**
261      * @dev See {IERC20-totalSupply}.
262      */
263     function totalSupply() external view virtual override returns (uint256) {
264         return _totalSupply;
265     }
266 
267     /**
268      * @dev See {IERC20-balanceOf}.
269      */
270     function balanceOf(address account) external view virtual override returns (uint256) {
271         return _balances[account];
272     }
273 
274     /**
275      * @dev See {IERC20-transfer}.
276      *
277      * Requirements:
278      *
279      * - `recipient` cannot be the zero address.
280      * - the caller must have a balance of at least `amount`.
281      */
282     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
283         _transfer(_msgSender(), recipient, amount);
284         return true;
285     }
286 
287     /**
288      * @dev See {IERC20-allowance}.
289      */
290     function allowance(address owner, address spender) external view virtual override returns (uint256) {
291         return _allowances[owner][spender];
292     }
293 
294     /**
295      * @dev See {IERC20-approve}.
296      *
297      * Requirements:
298      *
299      * - `spender` cannot be the zero address.
300      */
301     function approve(address spender, uint256 amount) external virtual override returns (bool) {
302         _approve(_msgSender(), spender, amount);
303         return true;
304     }
305 
306     /**
307      * @dev See {IERC20-transferFrom}.
308      *
309      * Emits an {Approval} event indicating the updated allowance. This is not
310      * required by the EIP. See the note at the beginning of {ERC20}.
311      *
312      * Requirements:
313      *
314      * - `sender` and `recipient` cannot be the zero address.
315      * - `sender` must have a balance of at least `amount`.
316      * - the caller must have allowance for ``sender``'s tokens of at least
317      * `amount`.
318      */
319     function transferFrom(
320         address sender,
321         address recipient,
322         uint256 amount
323     ) external virtual override returns (bool) {
324         _transfer(sender, recipient, amount);
325 
326         uint256 currentAllowance = _allowances[sender][_msgSender()];
327         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
328         unchecked {
329             _approve(sender, _msgSender(), currentAllowance - amount);
330         }
331 
332         return true;
333     }
334 
335     /**
336      * @dev Atomically increases the allowance granted to `spender` by the caller.
337      *
338      * This is an alternative to {approve} that can be used as a mitigation for
339      * problems described in {IERC20-approve}.
340      *
341      * Emits an {Approval} event indicating the updated allowance.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      */
347     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
348         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
349         return true;
350     }
351 
352     /**
353      * @dev Atomically decreases the allowance granted to `spender` by the caller.
354      *
355      * This is an alternative to {approve} that can be used as a mitigation for
356      * problems described in {IERC20-approve}.
357      *
358      * Emits an {Approval} event indicating the updated allowance.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      * - `spender` must have allowance for the caller of at least
364      * `subtractedValue`.
365      */
366     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
367         uint256 currentAllowance = _allowances[_msgSender()][spender];
368         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
369         unchecked {
370             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
371         }
372 
373         return true;
374     }
375     
376     modifier onlyAdmin() {
377         require(_admin == _msgSender(), ERROR_AUTH_FAILED);
378         _;
379     }
380     
381     modifier onlyAdminCandidate {
382         require(_adminCandidate == msg.sender, ERROR_AUTH_FAILED);
383         _;
384     }
385     
386     function changeAdmin(address adminCandidate) onlyAdmin external {
387         _adminCandidate = adminCandidate;
388         emit AdminChangeRequested(_admin, adminCandidate);
389     }
390     
391     function confirmNewAdmin() onlyAdminCandidate external {
392         emit AdminChangeConfirmed(_admin, _adminCandidate);
393         _admin = _adminCandidate;
394         _adminCandidate = address(0);
395     }
396     
397     function mint(address to) onlyAdmin external {
398         require(_totalSupply == 0, "already minted");
399         _mint(to, _maxTotalSupply);
400     }
401     
402     function setStatsTracker(address statsTracker) onlyAdmin external {
403         _statsTracker = statsTracker;
404     }
405 
406     /**
407      * @dev Moves `amount` of tokens from `sender` to `recipient`.
408      *
409      * This internal function is equivalent to {transfer}, and can be used to
410      * e.g. implement automatic token fees, slashing mechanisms, etc.
411      *
412      * Emits a {Transfer} event.
413      *
414      * Requirements:
415      *
416      * - `sender` cannot be the zero address.
417      * - `recipient` cannot be the zero address.
418      * - `sender` must have a balance of at least `amount`.
419      */
420     function _transfer(
421         address sender,
422         address recipient,
423         uint256 amount
424     ) private {
425         require(sender != address(0), "ERC20: transfer from the zero address");
426         require(recipient != address(0), "ERC20: transfer to the zero address");
427 
428         if (_statsTracker != address(0)) {
429             IStatsTracker(_statsTracker).updateTransferStats(address(this), sender, recipient, amount);
430         }
431 
432         uint256 senderBalance = _balances[sender];
433         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
434         unchecked {
435             _balances[sender] = senderBalance - amount;
436         }
437         _balances[recipient] += amount;
438 
439         emit Transfer(sender, recipient, amount);
440     }
441 
442     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
443      * the total supply.
444      *
445      * Emits a {Transfer} event with `from` set to the zero address.
446      *
447      * Requirements:
448      *
449      * - `account` cannot be the zero address.
450      */
451     function _mint(address account, uint256 amount) private {
452         require(account != address(0), "ERC20: mint to the zero address");
453 
454         _totalSupply += amount;
455         _balances[account] += amount;
456         emit Transfer(address(0), account, amount);
457     }
458 
459     /**
460      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
461      *
462      * This internal function is equivalent to `approve`, and can be used to
463      * e.g. set automatic allowances for certain subsystems, etc.
464      *
465      * Emits an {Approval} event.
466      *
467      * Requirements:
468      *
469      * - `owner` cannot be the zero address.
470      * - `spender` cannot be the zero address.
471      */
472     function _approve(
473         address owner,
474         address spender,
475         uint256 amount
476     ) private {
477         require(owner != address(0), "ERC20: approve from the zero address");
478         require(spender != address(0), "ERC20: approve to the zero address");
479 
480         _allowances[owner][spender] = amount;
481         emit Approval(owner, spender, amount);
482     }
483     
484     function _ensureNotZeroAddress(address _addr) private pure {
485         require(_addr != address(0), "zero address");
486     }
487 }