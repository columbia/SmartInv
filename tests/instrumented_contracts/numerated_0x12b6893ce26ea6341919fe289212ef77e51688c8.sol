1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
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
116 // File: @openzeppelin/contracts/utils/Context.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 // File: @openzeppelin/contracts/access/Ownable.sol
144 
145 
146 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 
151 /**
152  * @dev Contract module which provides a basic access control mechanism, where
153  * there is an account (an owner) that can be granted exclusive access to
154  * specific functions.
155  *
156  * By default, the owner account will be the one that deploys the contract. This
157  * can later be changed with {transferOwnership}.
158  *
159  * This module is used through inheritance. It will make available the modifier
160  * `onlyOwner`, which can be applied to your functions to restrict their use to
161  * the owner.
162  */
163 abstract contract Ownable is Context {
164     address private _owner;
165 
166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167 
168     /**
169      * @dev Initializes the contract setting the deployer as the initial owner.
170      */
171     constructor() {
172         _transferOwnership(_msgSender());
173     }
174 
175     /**
176      * @dev Throws if called by any account other than the owner.
177      */
178     modifier onlyOwner() {
179         _checkOwner();
180         _;
181     }
182 
183     /**
184      * @dev Returns the address of the current owner.
185      */
186     function owner() public view virtual returns (address) {
187         return _owner;
188     }
189 
190     /**
191      * @dev Throws if the sender is not the owner.
192      */
193     function _checkOwner() internal view virtual {
194         require(owner() == _msgSender(), "Ownable: caller is not the owner");
195     }
196 
197     /**
198      * @dev Leaves the contract without owner. It will not be possible to call
199      * `onlyOwner` functions anymore. Can only be called by the current owner.
200      *
201      * NOTE: Renouncing ownership will leave the contract without an owner,
202      * thereby removing any functionality that is only available to the owner.
203      */
204     function renounceOwnership() public virtual onlyOwner {
205         _transferOwnership(address(0));
206     }
207 
208     /**
209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
210      * Can only be called by the current owner.
211      */
212     function transferOwnership(address newOwner) public virtual onlyOwner {
213         require(newOwner != address(0), "Ownable: new owner is the zero address");
214         _transferOwnership(newOwner);
215     }
216 
217     /**
218      * @dev Transfers ownership of the contract to a new account (`newOwner`).
219      * Internal function without access restriction.
220      */
221     function _transferOwnership(address newOwner) internal virtual {
222         address oldOwner = _owner;
223         _owner = newOwner;
224         emit OwnershipTransferred(oldOwner, newOwner);
225     }
226 }
227 
228 // File: TAMA.sol
229 
230 
231 
232 pragma solidity 0.8.9;
233 
234 
235 
236 
237 contract Token is Context, IERC20Metadata, Ownable {
238     mapping(address => uint256) private _balances;
239 
240     mapping(address => mapping(address => uint256)) private _allowances;
241 
242     uint256 private _totalSupply;
243 
244     string private _name;
245     string private _symbol;
246     uint8 private constant _decimals = 18;
247     uint256 public constant hardCap = 2_000_000_000 * (10**_decimals); //2 billion
248     uint256 public constant mintHardCap = 1_400_000_000 * (10**_decimals); //1.4 billion
249     uint256 public constant lockedSupply = hardCap - mintHardCap; //600 million
250     uint256 public mintable = mintHardCap;
251     uint256 public locking_start;
252     uint256 public locking_end;
253     uint256 public mintedLockedSupply;
254 
255     event LockStarted(uint256 startTime, uint256 endTime);
256 
257     constructor(
258         string memory name_,
259         string memory symbol_,
260         uint256 _mintAmount,
261         uint256 lockingStartTime,
262         uint256 lockingEndTime
263     ) Ownable() {
264         require(
265             _mintAmount > 0 && _mintAmount <= mintHardCap,
266             "Invalid mint amount"
267         );
268         require(
269             lockingStartTime >= block.timestamp,
270             "Start time is in the past"
271         );
272         require(lockingEndTime > lockingStartTime, "Invalid end time");
273         _name = name_;
274         _symbol = symbol_;
275         mintable -= _mintAmount;
276         _mint(owner(), _mintAmount);
277         locking_start = lockingStartTime;
278         locking_end = lockingEndTime;
279         emit LockStarted(locking_start, locking_end);
280     }
281 
282     function mint(uint256 amount) external onlyOwner {
283         require(amount > 0 && amount <= mintable, "Amount out of bounds");
284         mintable -= amount;
285         _mint(owner(), amount);
286     }
287 
288     function mintLockedSupply() external onlyOwner {
289         uint256 amount = mintableLockedAmount();
290         if (amount > 0) {
291             mintedLockedSupply += amount;
292             _mint(owner(), amount);
293         } else {
294             revert("Nothing to mint");
295         }
296     }
297 
298     function mintableLockedAmount() public view returns (uint256 finalAmount) {
299         if (block.timestamp <= locking_start) {
300             finalAmount = 0;
301         } else if (
302             block.timestamp > locking_start && block.timestamp < locking_end
303         ) {
304             uint256 timePassed = (block.timestamp - locking_start) *
305                 (10**_decimals);
306             uint256 totalLock = (lockedSupply * timePassed) /
307                 ((locking_end - locking_start) * (10**_decimals));
308             finalAmount = (totalLock - mintedLockedSupply);
309         } else {
310             finalAmount = lockedSupply - mintedLockedSupply;
311         }
312     }
313 
314     function name() public view virtual override returns (string memory) {
315         return _name;
316     }
317 
318     function symbol() public view virtual override returns (string memory) {
319         return _symbol;
320     }
321 
322     function decimals() public view virtual override returns (uint8) {
323         return _decimals;
324     }
325 
326     function totalSupply() public view virtual override returns (uint256) {
327         return _totalSupply;
328     }
329 
330     function balanceOf(address account)
331         public
332         view
333         virtual
334         override
335         returns (uint256)
336     {
337         return _balances[account];
338     }
339 
340     function transfer(address recipient, uint256 amount)
341         public
342         virtual
343         override
344         returns (bool)
345     {
346         _transfer(_msgSender(), recipient, amount);
347         return true;
348     }
349 
350     function allowance(address from, address to)
351         public
352         view
353         virtual
354         override
355         returns (uint256)
356     {
357         return _allowances[from][to];
358     }
359 
360     function approve(address to, uint256 amount)
361         public
362         virtual
363         override
364         returns (bool)
365     {
366         _approve(_msgSender(), to, amount);
367         return true;
368     }
369 
370     function transferFrom(
371         address sender,
372         address recipient,
373         uint256 amount
374     ) public virtual override returns (bool) {
375         _transfer(sender, recipient, amount);
376 
377         uint256 currentAllowance = _allowances[sender][_msgSender()];
378         require(
379             currentAllowance >= amount,
380             "ERC20: transfer amount exceeds allowance"
381         );
382         unchecked {
383             _approve(sender, _msgSender(), currentAllowance - amount);
384         }
385 
386         return true;
387     }
388 
389     function increaseAllowance(address to, uint256 addedValue)
390         public
391         virtual
392         returns (bool)
393     {
394         _approve(_msgSender(), to, _allowances[_msgSender()][to] + addedValue);
395         return true;
396     }
397 
398     function decreaseAllowance(address to, uint256 subtractedValue)
399         public
400         virtual
401         returns (bool)
402     {
403         uint256 currentAllowance = _allowances[_msgSender()][to];
404         require(
405             currentAllowance >= subtractedValue,
406             "ERC20: decreased allowance below zero"
407         );
408         unchecked {
409             _approve(_msgSender(), to, currentAllowance - subtractedValue);
410         }
411 
412         return true;
413     }
414 
415     function _transfer(
416         address sender,
417         address recipient,
418         uint256 amount
419     ) internal virtual {
420         require(sender != address(0), "ERC20: transfer from the zero address");
421         require(recipient != address(0), "ERC20: transfer to the zero address");
422 
423         uint256 senderBalance = _balances[sender];
424         require(
425             senderBalance >= amount,
426             "ERC20: transfer amount exceeds balance"
427         );
428         unchecked {
429             _balances[sender] = senderBalance - amount;
430         }
431         _balances[recipient] += amount;
432 
433         emit Transfer(sender, recipient, amount);
434     }
435 
436     function _mint(address account, uint256 amount) internal virtual {
437         require(account != address(0), "ERC20: mint to the zero address");
438 
439         _totalSupply += amount;
440         _balances[account] += amount;
441         emit Transfer(address(0), account, amount);
442     }
443 
444     function _burn(address account, uint256 amount) internal virtual {
445         require(account != address(0), "ERC20: burn from the zero address");
446 
447         uint256 accountBalance = _balances[account];
448         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
449         unchecked {
450             _balances[account] = accountBalance - amount;
451         }
452         _totalSupply -= amount;
453 
454         emit Transfer(account, address(0), amount);
455     }
456 
457     function burn(uint256 amount) external {
458         _burn(_msgSender(), amount);
459     }
460 
461     function _approve(
462         address from,
463         address to,
464         uint256 amount
465     ) internal virtual {
466         require(from != address(0), "ERC20: approve from the zero address");
467         require(to != address(0), "ERC20: approve to the zero address");
468 
469         _allowances[from][to] = amount;
470         emit Approval(from, to, amount);
471     }
472 }