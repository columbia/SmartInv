1 pragma solidity ^0.5.0;
2 
3 /*****************************************************************************
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  */
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a, "SafeMath: addition overflow");
11 
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b <= a, "SafeMath: subtraction overflow");
17 
18         return a - b;
19     }
20 
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b, "SafeMath: multiplication overflow");
28 
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b > 0, "SafeMath: division by zero");
34         uint256 c = a / b;
35         
36         return c;
37     }
38 }
39 
40 /*****************************************************************************
41  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
42  * the optional functions; to access them see `ERC20Detailed`.
43  */
44 interface IERC20 {
45     /**
46      * @dev Returns the amount of tokens in existence.
47      */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `recipient`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a `Transfer` event.
61      */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through `transferFrom`. This is
67      * zero by default.
68      *
69      * This value changes when `approve` or `transferFrom` are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * > Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an `Approval` event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a `Transfer` event.
97      */
98     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
102      * another (`to`).
103      *
104      * Note that `value` may be zero.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110      * a call to `approve`. `value` is the new allowance.
111      */
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 /*****************************************************************************
116  * @dev Basic implementation of the `IERC20` interface.
117  */
118 contract ERC20 is IERC20 {
119     using SafeMath for uint256;
120 
121     mapping (address => uint256) private _balances;
122 
123     mapping (address => mapping (address => uint256)) private _allowances;
124 
125     uint256 private _totalSupply;
126 
127     /**
128      * @dev See `IERC20.totalSupply`.
129      */
130     function totalSupply() public view returns (uint256) {
131         return _totalSupply;
132     }
133 
134     /**
135      * @dev See `IERC20.balanceOf`.
136      */
137     function balanceOf(address account) public view returns (uint256) {
138         return _balances[account];
139     }
140 
141     /**
142      * @dev See `IERC20.transfer`.
143      *
144      * Requirements:
145      *
146      * - `recipient` cannot be the zero address.
147      * - the caller must have a balance of at least `amount`.
148      */
149     function transfer(address recipient, uint256 amount) public returns (bool) {
150         _transfer(msg.sender, recipient, amount);
151         return true;
152     }
153 
154     /**
155      * @dev See `IERC20.allowance`.
156      */
157     function allowance(address owner, address spender) public view returns (uint256) {
158         return _allowances[owner][spender];
159     }
160 
161     /**
162      * @dev See `IERC20.approve`.
163      *
164      * Requirements:
165      *
166      * - `spender` cannot be the zero address.
167      */
168     function approve(address spender, uint256 value) public returns (bool) {
169         _approve(msg.sender, spender, value);
170         return true;
171     }
172 
173     /**
174      * @dev See `IERC20.transferFrom`.
175      *
176      * Emits an `Approval` event indicating the updated allowance. This is not
177      * required by the EIP. See the note at the beginning of `ERC20`;
178      *
179      * Requirements:
180      * - `sender` and `recipient` cannot be the zero address.
181      * - `sender` must have a balance of at least `value`.
182      * - the caller must have allowance for `sender`'s tokens of at least
183      * `amount`.
184      */
185     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
186         _transfer(sender, recipient, amount);
187         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
188         return true;
189     }
190 
191     /**
192      * @dev Atomically increases the allowance granted to `spender` by the caller.
193      *
194      * This is an alternative to `approve` that can be used as a mitigation for
195      * problems described in `IERC20.approve`.
196      *
197      * Emits an `Approval` event indicating the updated allowance.
198      *
199      * Requirements:
200      *
201      * - `spender` cannot be the zero address.
202      */
203     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
204         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
205         return true;
206     }
207 
208     /**
209      * @dev Atomically decreases the allowance granted to `spender` by the caller.
210      *
211      * This is an alternative to `approve` that can be used as a mitigation for
212      * problems described in `IERC20.approve`.
213      *
214      * Emits an `Approval` event indicating the updated allowance.
215      *
216      * Requirements:
217      *
218      * - `spender` cannot be the zero address.
219      * - `spender` must have allowance for the caller of at least
220      * `subtractedValue`.
221      */
222     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
223         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
224         return true;
225     }
226 
227     /**
228      * @dev Moves tokens `amount` from `sender` to `recipient`.
229      *
230      * This is internal function is equivalent to `transfer`, and can be used to
231      * e.g. implement automatic token fees, slashing mechanisms, etc.
232      *
233      * Emits a `Transfer` event.
234      *
235      * Requirements:
236      *
237      * - `sender` cannot be the zero address.
238      * - `recipient` cannot be the zero address.
239      * - `sender` must have a balance of at least `amount`.
240      */
241     function _transfer(address sender, address recipient, uint256 amount) internal {
242         require(sender != address(0), "ERC20: transfer from the zero address");
243         require(recipient != address(0), "ERC20: transfer to the zero address");
244 
245         _balances[sender] = _balances[sender].sub(amount);
246         _balances[recipient] = _balances[recipient].add(amount);
247         emit Transfer(sender, recipient, amount);
248     }
249 
250     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
251      * the total supply.
252      *
253      * Emits a `Transfer` event with `from` set to the zero address.
254      *
255      * Requirements
256      *
257      * - `to` cannot be the zero address.
258      */
259     function _mint(address account, uint256 amount) internal {
260         require(account != address(0), "ERC20: mint to the zero address");
261 
262         _totalSupply = _totalSupply.add(amount);
263         _balances[account] = _balances[account].add(amount);
264         emit Transfer(address(0), account, amount);
265     }
266 
267      /**
268      * @dev Destoys `amount` tokens from `account`, reducing the
269      * total supply.
270      *
271      * Emits a `Transfer` event with `to` set to the zero address.
272      *
273      * Requirements
274      *
275      * - `account` cannot be the zero address.
276      * - `account` must have at least `amount` tokens.
277      */
278     function _burn(address account, uint256 value) internal {
279         require(account != address(0), "ERC20: burn from the zero address");
280 
281         _totalSupply = _totalSupply.sub(value);
282         _balances[account] = _balances[account].sub(value);
283         emit Transfer(account, address(0), value);
284     }
285 
286     /**
287      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
288      *
289      * This is internal function is equivalent to `approve`, and can be used to
290      * e.g. set automatic allowances for certain subsystems, etc.
291      *
292      * Emits an `Approval` event.
293      *
294      * Requirements:
295      *
296      * - `owner` cannot be the zero address.
297      * - `spender` cannot be the zero address.
298      */
299     function _approve(address owner, address spender, uint256 value) internal {
300         require(owner != address(0), "ERC20: approve from the zero address");
301         require(spender != address(0), "ERC20: approve to the zero address");
302 
303         _allowances[owner][spender] = value;
304         emit Approval(owner, spender, value);
305     }
306 
307     /**
308      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
309      * from the caller's allowance.
310      *
311      * See `_burn` and `_approve`.
312      */
313     function _burnFrom(address account, uint256 amount) internal {
314         _burn(account, amount);
315         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
316     }
317 }
318 
319 /*****************************************************************************
320  * @dev Contract module which provides a basic access control mechanism, where
321  * there is an account (an owner) that can be granted exclusive access to
322  * specific functions.
323  *
324  * This module is used through inheritance. It will make available the modifier
325  * `onlyOwner`, which can be aplied to your functions to restrict their use to
326  * the owner.
327  */
328 contract Ownable {
329     address private _owner;
330 
331     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
332 
333     /**
334      * @dev Initializes the contract setting the deployer as the initial owner.
335      */
336     constructor () internal {
337         _owner = msg.sender;
338         emit OwnershipTransferred(address(0), _owner);
339     }
340 
341     /**
342      * @dev Returns the address of the current owner.
343      */
344     function owner() public view returns (address) {
345         return _owner;
346     }
347 
348     /**
349      * @dev Throws if called by any account other than the owner.
350      */
351     modifier onlyOwner() {
352         require(isOwner(), "Ownable: caller is not the owner");
353         _;
354     }
355 
356     /**
357      * @dev Returns true if the caller is the current owner.
358      */
359     function isOwner() public view returns (bool) {
360         return msg.sender == _owner;
361     }
362 
363     /**
364      * @dev Transfers ownership of the contract to a new account (`newOwner`).
365      * Can only be called by the current owner.
366      */
367     function transferOwnership(address newOwner) public onlyOwner {
368         require(newOwner != address(0), "Ownable: new owner is the zero address");
369         emit OwnershipTransferred(_owner, newOwner);
370         _owner = newOwner;
371     }
372 }
373 
374 /**
375  * @title Pausable
376  * @dev Base contract which allows children to implement an emergency stop mechanism.
377  */
378 contract Pausable is Ownable {
379     event Paused();
380     event Unpaused();
381 
382     bool public paused = false;
383     
384     /**
385      * @dev Modifier to make a function callable only when the contract is not paused.
386      */
387     modifier whenNotPaused() {
388         require(!paused);
389         _;
390     }
391 
392     /**
393      * @dev Modifier to make a function callable only when the contract is paused.
394      */
395     modifier whenPaused() {
396         require(paused);
397         _;
398     }
399 
400     /**
401      * @dev called by the owner to pause, triggers stopped state
402      */
403     function pause() public onlyOwner whenNotPaused {
404         paused = true;
405         emit Paused();
406     }
407 
408     /**
409      * @dev called by the owner to unpause, returns to normal state
410      */
411     function unpause() public onlyOwner whenPaused {
412         paused = false;
413         emit Unpaused();
414     }
415 }
416 
417 /**
418  * @title Pausable token
419  * @dev ERC20 modified with pausable transfers.
420  **/
421 contract ERC20Pausable is ERC20, Pausable {
422     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
423         return super.transfer(to, value);
424     }
425 
426     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
427         return super.transferFrom(from, to, value);
428     }
429 
430     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
431         return super.approve(spender, value);
432     }
433 
434     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
435         return super.increaseAllowance(spender, addedValue);
436     }
437 
438     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
439         return super.decreaseAllowance(spender, subtractedValue);
440     }
441 }
442 
443 /*****************************************************************************
444  * @title KardiachainToken
445  * @dev KardiachainToken is an ERC20 implementation of the KardiaChain ecosystem token. 
446  * All tokens are initially pre-assigned to the creator, and can later be distributed 
447  * freely using transfer transferFrom and other ERC20 functions.
448  */
449  
450 contract KardiachainToken is Ownable, ERC20Pausable {
451     string public constant name = "KardiaChain Token";
452     string public constant symbol = "KAI";
453     uint8 public constant decimals = 18;
454 
455     uint256 public constant initialSupply = 5 * 10 ** 9 * 10 ** uint256(decimals); // 5Bn Tokens
456 
457     /**
458      * @dev Constructor that gives msg.sender all of existing tokens.
459      */
460     constructor () public {
461         _mint(msg.sender, initialSupply);
462     }
463 
464     /**
465      * @dev Destoys `amount` tokens from the caller.
466      *
467      * See `ERC20._burn`.
468      */
469     function burn(uint256 amount) public {
470         _burn(msg.sender, amount);
471     }
472 
473     /**
474      * @dev See `ERC20._burnFrom`.
475      */
476     function burnFrom(address account, uint256 amount) public {
477         _burnFrom(account, amount);
478     }
479     
480     event DepositReceived(address indexed from, uint256 value);
481 }