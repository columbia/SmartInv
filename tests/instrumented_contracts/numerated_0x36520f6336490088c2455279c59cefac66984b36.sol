1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Emitted when `value` tokens are moved from one account (`from`) to
11      * another (`to`).
12      *
13      * Note that `value` may be zero.
14      */
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     /**
18      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
19      * a call to {approve}. `value` is the new allowance.
20      */
21     event Approval(
22         address indexed owner,
23         address indexed spender,
24         uint256 value
25     );
26 
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `to`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address to, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(
54         address owner,
55         address spender
56     ) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `from` to `to` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address from,
85         address to,
86         uint256 amount
87     ) external returns (bool);
88 }
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  *
93  * _Available since v4.1._
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 /**
113  * @dev Provides information about the current execution context, including the
114  * sender of the transaction and its data. While these are generally available
115  * via msg.sender and msg.data, they should not be accessed in such a direct
116  * manner, since when dealing with meta-transactions the account sending and
117  * paying for execution may not be the actual sender (as far as an application
118  * is concerned).
119  *
120  * This contract is only required for intermediate, library-like contracts.
121  */
122 abstract contract Context {
123     function _msgSender() internal view virtual returns (address) {
124         return msg.sender;
125     }
126 
127     function _msgData() internal view virtual returns (bytes calldata) {
128         return msg.data;
129     }
130 }
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
147     event OwnershipTransferred(
148         address indexed previousOwner,
149         address indexed newOwner
150     );
151 
152     /**
153      * @dev Initializes the contract setting the deployer as the initial owner.
154      */
155     constructor() {
156         _transferOwnership(_msgSender());
157     }
158 
159     /**
160      * @dev Throws if called by any account other than the owner.
161      */
162     modifier onlyOwner() {
163         _checkOwner();
164         _;
165     }
166 
167     /**
168      * @dev Returns the address of the current owner.
169      */
170     function owner() public view virtual returns (address) {
171         return _owner;
172     }
173 
174     /**
175      * @dev Throws if the sender is not the owner.
176      */
177     function _checkOwner() internal view virtual {
178         require(owner() == _msgSender(), "Ownable: caller is not the owner");
179     }
180 
181     /**
182      * @dev Leaves the contract without owner. It will not be possible to call
183      * `onlyOwner` functions. Can only be called by the current owner.
184      *
185      * NOTE: Renouncing ownership will leave the contract without an owner,
186      * thereby disabling any functionality that is only available to the owner.
187      */
188     function renounceOwnership() public virtual onlyOwner {
189         _transferOwnership(address(0));
190     }
191 
192     /**
193      * @dev Transfers ownership of the contract to a new account (`newOwner`).
194      * Can only be called by the current owner.
195      */
196     function transferOwnership(address newOwner) public virtual onlyOwner {
197         require(
198             newOwner != address(0),
199             "Ownable: new owner is the zero address"
200         );
201         _transferOwnership(newOwner);
202     }
203 
204     /**
205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
206      * Internal function without access restriction.
207      */
208     function _transferOwnership(address newOwner) internal virtual {
209         address oldOwner = _owner;
210         _owner = newOwner;
211         emit OwnershipTransferred(oldOwner, newOwner);
212     }
213 }
214 
215 contract CopiumToken is Context, IERC20Metadata, Ownable {
216     mapping(address => uint256) private _balances;
217 
218     mapping(address => mapping(address => uint256)) private _allowances;
219 
220     uint256 private _totalSupply;
221 
222     string private _name;
223     string private _symbol;
224     uint8 private constant _decimals = 18;
225     uint256 public constant hardCap = 1_000_000_000 * (10 ** _decimals); //1 billion
226 
227     /**
228      * @dev Contract constructor.
229      * @param name_ The name of the token.
230      * @param symbol_ The symbol of the token.
231      * @param _to The initial address to mint the total supply to.
232      */
233     constructor(string memory name_, string memory symbol_, address _to) {
234         _name = name_;
235         _symbol = symbol_;
236         _mint(_to, hardCap);
237     }
238 
239     /**
240      * @dev Returns the name of the token.
241      * @return The name of the token.
242      */
243     function name() public view virtual override returns (string memory) {
244         return _name;
245     }
246 
247     /**
248      * @dev Returns the symbol of the token.
249      * @return The symbol of the token.
250      */
251     function symbol() public view virtual override returns (string memory) {
252         return _symbol;
253     }
254 
255     /**
256      * @dev Returns the number of decimals used for token display.
257      * @return The number of decimals.
258      */
259     function decimals() public view virtual override returns (uint8) {
260         return _decimals;
261     }
262 
263     /**
264      * @dev Returns the total supply of the token.
265      * @return The total supply.
266      */
267     function totalSupply() public view virtual override returns (uint256) {
268         return _totalSupply;
269     }
270 
271     /**
272      * @dev Returns the balance of the specified account.
273      * @param account The address to check the balance for.
274      * @return The balance of the account.
275      */
276     function balanceOf(
277         address account
278     ) public view virtual override returns (uint256) {
279         return _balances[account];
280     }
281 
282     /**
283      * @dev Transfers tokens from the caller to a specified recipient.
284      * @param recipient The address to transfer tokens to.
285      * @param amount The amount of tokens to transfer.
286      * @return A boolean value indicating whether the transfer was successful.
287      */
288     function transfer(
289         address recipient,
290         uint256 amount
291     ) public virtual override returns (bool) {
292         _transfer(_msgSender(), recipient, amount);
293         return true;
294     }
295 
296     /**
297      * @dev Returns the amount of tokens that the spender is allowed to spend on behalf of the owner.
298      * @param from The address that approves the spending.
299      * @param to The address that is allowed to spend.
300      * @return The remaining allowance for the spender.
301      */
302     function allowance(
303         address from,
304         address to
305     ) public view virtual override returns (uint256) {
306         return _allowances[from][to];
307     }
308 
309     /**
310      * @dev Approves the specified address to spend the specified amount of tokens on behalf of the caller.
311      * @param to The address to approve the spending for.
312      * @param amount The amount of tokens to approve.
313      * @return A boolean value indicating whether the approval was successful.
314      */
315     function approve(
316         address to,
317         uint256 amount
318     ) public virtual override returns (bool) {
319         _approve(_msgSender(), to, amount);
320         return true;
321     }
322 
323     /**
324      * @dev Transfers tokens from one address to another.
325      * @param sender The address to transfer tokens from.
326      * @param recipient The address to transfer tokens to.
327      * @param amount The amount of tokens to transfer.
328      * @return A boolean value indicating whether the transfer was successful.
329      */
330     function transferFrom(
331         address sender,
332         address recipient,
333         uint256 amount
334     ) public virtual override returns (bool) {
335         _transfer(sender, recipient, amount);
336 
337         uint256 currentAllowance = _allowances[sender][_msgSender()];
338         require(
339             currentAllowance >= amount,
340             "ERC20: transfer amount exceeds allowance"
341         );
342         unchecked {
343             _approve(sender, _msgSender(), currentAllowance - amount);
344         }
345 
346         return true;
347     }
348 
349     /**
350      * @dev Increases the allowance of the specified address to spend tokens on behalf of the caller.
351      * @param to The address to increase the allowance for.
352      * @param addedValue The amount of tokens to increase the allowance by.
353      * @return A boolean value indicating whether the increase was successful.
354      */
355     function increaseAllowance(
356         address to,
357         uint256 addedValue
358     ) public virtual returns (bool) {
359         _approve(_msgSender(), to, _allowances[_msgSender()][to] + addedValue);
360         return true;
361     }
362 
363     /**
364      * @dev Decreases the allowance granted by the owner of the tokens to `to` account.
365      * @param to The account allowed to spend the tokens.
366      * @param subtractedValue The amount of tokens to decrease the allowance by.
367      * @return A boolean value indicating whether the operation succeeded.
368      */
369     function decreaseAllowance(
370         address to,
371         uint256 subtractedValue
372     ) public virtual returns (bool) {
373         uint256 currentAllowance = _allowances[_msgSender()][to];
374         require(
375             currentAllowance >= subtractedValue,
376             "ERC20: decreased allowance below zero"
377         );
378         unchecked {
379             _approve(_msgSender(), to, currentAllowance - subtractedValue);
380         }
381 
382         return true;
383     }
384 
385     /**
386      * @dev Transfers `amount` tokens from `sender` to `recipient`.
387      * @param sender The account to transfer tokens from.
388      * @param recipient The account to transfer tokens to.
389      * @param amount The amount of tokens to transfer.
390      */
391     function _transfer(
392         address sender,
393         address recipient,
394         uint256 amount
395     ) internal virtual {
396         require(amount > 0, "ERC20: transfer amount zero");
397         require(sender != address(0), "ERC20: transfer from the zero address");
398         require(recipient != address(0), "ERC20: transfer to the zero address");
399 
400         uint256 senderBalance = _balances[sender];
401         require(
402             senderBalance >= amount,
403             "ERC20: transfer amount exceeds balance"
404         );
405         unchecked {
406             _balances[sender] = senderBalance - amount;
407         }
408         _balances[recipient] += amount;
409 
410         emit Transfer(sender, recipient, amount);
411     }
412 
413     /**
414      * @dev Creates `amount` tokens and assigns them to `account`.
415      * @param account The account to assign the newly created tokens to.
416      * @param amount The amount of tokens to create.
417      */
418     function _mint(address account, uint256 amount) internal virtual {
419         require(account != address(0), "ERC20: mint to the zero address");
420 
421         _totalSupply += amount;
422         _balances[account] += amount;
423         emit Transfer(address(0), account, amount);
424     }
425 
426     /**
427      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
428      * @param account The account to burn tokens from.
429      * @param amount The amount of tokens to burn.
430      */
431     function _burn(address account, uint256 amount) internal virtual {
432         require(account != address(0), "ERC20: burn from the zero address");
433 
434         uint256 accountBalance = _balances[account];
435         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
436         unchecked {
437             _balances[account] = accountBalance - amount;
438         }
439         _totalSupply -= amount;
440 
441         emit Transfer(account, address(0), amount);
442     }
443 
444     /**
445      * @dev Destroys `amount` tokens from the caller's account, reducing the total supply.
446      * @param amount The amount of tokens to burn.
447      */
448     function burn(uint256 amount) external {
449         _burn(_msgSender(), amount);
450     }
451 
452     /**
453      * @dev Sets `amount` as the allowance of `to` over the caller's tokens.
454      * @param from The account granting the allowance.
455      * @param to The account allowed to spend the tokens.
456      * @param amount The amount of tokens to allow.
457      */
458     function _approve(
459         address from,
460         address to,
461         uint256 amount
462     ) internal virtual {
463         require(from != address(0), "ERC20: approve from the zero address");
464         require(to != address(0), "ERC20: approve to the zero address");
465 
466         _allowances[from][to] = amount;
467         emit Approval(from, to, amount);
468     }
469 }