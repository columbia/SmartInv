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
215 contract ThugLifeToken is Context, IERC20Metadata, Ownable {
216     mapping(address => uint256) private _balances;
217 
218     mapping(address => mapping(address => uint256)) private _allowances;
219 
220     uint256 private _totalSupply;
221 
222     string private _name;
223     string private _symbol;
224     uint8 private constant _decimals = 18;
225     uint256 public constant hardCap = 4_200_000_000 * (10 ** _decimals); 
226     bool public transferStatus;
227 
228     /**
229      * @dev Contract constructor.
230      * @param name_ The name of the token.
231      * @param symbol_ The symbol of the token.
232      * @param _to The initial address to mint the total supply to.
233      */
234     constructor(string memory name_, string memory symbol_, address _to) {
235         transferStatus = true;
236         _name = name_;
237         _symbol = symbol_;
238         _mint(_to, hardCap);
239     }
240 
241     /**
242      * @dev Changes token transfer state
243      * @param _status Status flag for transfer
244      */
245 
246     function setTransferStatus(bool _status) public onlyOwner {
247         transferStatus = _status;
248     }
249 
250     /**
251      * @dev Returns the name of the token.
252      * @return The name of the token.
253      */
254     function name() public view virtual override returns (string memory) {
255         return _name;
256     }
257 
258     /**
259      * @dev Returns the symbol of the token.
260      * @return The symbol of the token.
261      */
262     function symbol() public view virtual override returns (string memory) {
263         return _symbol;
264     }
265 
266     /**
267      * @dev Returns the number of decimals used for token display.
268      * @return The number of decimals.
269      */
270     function decimals() public view virtual override returns (uint8) {
271         return _decimals;
272     }
273 
274     /**
275      * @dev Returns the total supply of the token.
276      * @return The total supply.
277      */
278     function totalSupply() public view virtual override returns (uint256) {
279         return _totalSupply;
280     }
281 
282     /**
283      * @dev Returns the balance of the specified account.
284      * @param account The address to check the balance for.
285      * @return The balance of the account.
286      */
287     function balanceOf(
288         address account
289     ) public view virtual override returns (uint256) {
290         return _balances[account];
291     }
292 
293     /**
294      * @dev Transfers tokens from the caller to a specified recipient.
295      * @param recipient The address to transfer tokens to.
296      * @param amount The amount of tokens to transfer.
297      * @return A boolean value indicating whether the transfer was successful.
298      */
299     function transfer(
300         address recipient,
301         uint256 amount
302     ) public virtual override returns (bool) {
303         _transfer(_msgSender(), recipient, amount);
304         return true;
305     }
306 
307     /**
308      * @dev Returns the amount of tokens that the spender is allowed to spend on behalf of the owner.
309      * @param from The address that approves the spending.
310      * @param to The address that is allowed to spend.
311      * @return The remaining allowance for the spender.
312      */
313     function allowance(
314         address from,
315         address to
316     ) public view virtual override returns (uint256) {
317         return _allowances[from][to];
318     }
319 
320     /**
321      * @dev Approves the specified address to spend the specified amount of tokens on behalf of the caller.
322      * @param to The address to approve the spending for.
323      * @param amount The amount of tokens to approve.
324      * @return A boolean value indicating whether the approval was successful.
325      */
326     function approve(
327         address to,
328         uint256 amount
329     ) public virtual override returns (bool) {
330         _approve(_msgSender(), to, amount);
331         return true;
332     }
333 
334     /**
335      * @dev Transfers tokens from one address to another.
336      * @param sender The address to transfer tokens from.
337      * @param recipient The address to transfer tokens to.
338      * @param amount The amount of tokens to transfer.
339      * @return A boolean value indicating whether the transfer was successful.
340      */
341     function transferFrom(
342         address sender,
343         address recipient,
344         uint256 amount
345     ) public virtual override returns (bool) {
346         _transfer(sender, recipient, amount);
347 
348         uint256 currentAllowance = _allowances[sender][_msgSender()];
349         require(
350             currentAllowance >= amount,
351             "ERC20: transfer amount exceeds allowance"
352         );
353         unchecked {
354             _approve(sender, _msgSender(), currentAllowance - amount);
355         }
356 
357         return true;
358     }
359 
360     /**
361      * @dev Increases the allowance of the specified address to spend tokens on behalf of the caller.
362      * @param to The address to increase the allowance for.
363      * @param addedValue The amount of tokens to increase the allowance by.
364      * @return A boolean value indicating whether the increase was successful.
365      */
366     function increaseAllowance(
367         address to,
368         uint256 addedValue
369     ) public virtual returns (bool) {
370         _approve(_msgSender(), to, _allowances[_msgSender()][to] + addedValue);
371         return true;
372     }
373 
374     /**
375      * @dev Decreases the allowance granted by the owner of the tokens to `to` account.
376      * @param to The account allowed to spend the tokens.
377      * @param subtractedValue The amount of tokens to decrease the allowance by.
378      * @return A boolean value indicating whether the operation succeeded.
379      */
380     function decreaseAllowance(
381         address to,
382         uint256 subtractedValue
383     ) public virtual returns (bool) {
384         uint256 currentAllowance = _allowances[_msgSender()][to];
385         require(
386             currentAllowance >= subtractedValue,
387             "ERC20: decreased allowance below zero"
388         );
389         unchecked {
390             _approve(_msgSender(), to, currentAllowance - subtractedValue);
391         }
392 
393         return true;
394     }
395 
396     /**
397      * @dev Transfers `amount` tokens from `sender` to `recipient`.
398      * @param sender The account to transfer tokens from.
399      * @param recipient The account to transfer tokens to.
400      * @param amount The amount of tokens to transfer.
401      */
402     function _transfer(
403         address sender,
404         address recipient,
405         uint256 amount
406     ) internal virtual {
407         require(amount > 0, "ERC20: transfer amount zero");
408         require(sender != address(0), "ERC20: transfer from the zero address");
409         require(recipient != address(0), "ERC20: transfer to the zero address");
410         require(transferStatus ,"tokens transfer functionality paused");
411 
412         uint256 senderBalance = _balances[sender];
413         require(
414             senderBalance >= amount,
415             "ERC20: transfer amount exceeds balance"
416         );
417         unchecked {
418             _balances[sender] = senderBalance - amount;
419         }
420         _balances[recipient] += amount;
421 
422         emit Transfer(sender, recipient, amount);
423     }
424 
425     /**
426      * @dev Creates `amount` tokens and assigns them to `account`.
427      * @param account The account to assign the newly created tokens to.
428      * @param amount The amount of tokens to create.
429      */
430     function _mint(address account, uint256 amount) internal virtual {
431         require(account != address(0), "ERC20: mint to the zero address");
432 
433         _totalSupply += amount;
434         _balances[account] += amount;
435         emit Transfer(address(0), account, amount);
436     }
437 
438     /**
439      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
440      * @param account The account to burn tokens from.
441      * @param amount The amount of tokens to burn.
442      */
443     function _burn(address account, uint256 amount) internal virtual {
444         require(account != address(0), "ERC20: burn from the zero address");
445 
446         uint256 accountBalance = _balances[account];
447         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
448         unchecked {
449             _balances[account] = accountBalance - amount;
450         }
451         _totalSupply -= amount;
452 
453         emit Transfer(account, address(0), amount);
454     }
455 
456     /**
457      * @dev Destroys `amount` tokens from the caller's account, reducing the total supply.
458      * @param amount The amount of tokens to burn.
459      */
460     function burn(uint256 amount) external {
461         _burn(_msgSender(), amount);
462     }
463 
464     /**
465      * @dev Sets `amount` as the allowance of `to` over the caller's tokens.
466      * @param from The account granting the allowance.
467      * @param to The account allowed to spend the tokens.
468      * @param amount The amount of tokens to allow.
469      */
470     function _approve(
471         address from,
472         address to,
473         uint256 amount
474     ) internal virtual {
475         require(from != address(0), "ERC20: approve from the zero address");
476         require(to != address(0), "ERC20: approve to the zero address");
477 
478         _allowances[from][to] = amount;
479         emit Approval(from, to, amount);
480     }
481 }