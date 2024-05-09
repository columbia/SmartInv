1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9   /**
10    * @dev Emitted when `value` tokens are moved from one account (`from`) to
11    * another (`to`).
12    *
13    * Note that `value` may be zero.
14    */
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 
17   /**
18    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
19    * a call to {approve}. `value` is the new allowance.
20    */
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 
23   /**
24    * @dev Returns the amount of tokens in existence.
25    */
26   function totalSupply() external view returns (uint256);
27 
28   /**
29    * @dev Returns the amount of tokens owned by `account`.
30    */
31   function balanceOf(address account) external view returns (uint256);
32 
33   /**
34    * @dev Moves `amount` tokens from the caller's account to `to`.
35    *
36    * Returns a boolean value indicating whether the operation succeeded.
37    *
38    * Emits a {Transfer} event.
39    */
40   function transfer(address to, uint256 amount) external returns (bool);
41 
42   /**
43    * @dev Returns the remaining number of tokens that `spender` will be
44    * allowed to spend on behalf of `owner` through {transferFrom}. This is
45    * zero by default.
46    *
47    * This value changes when {approve} or {transferFrom} are called.
48    */
49   function allowance(address owner, address spender) external view returns (uint256);
50 
51   /**
52    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53    *
54    * Returns a boolean value indicating whether the operation succeeded.
55    *
56    * IMPORTANT: Beware that changing an allowance with this method brings the risk
57    * that someone may use both the old and the new allowance by unfortunate
58    * transaction ordering. One possible solution to mitigate this race
59    * condition is to first reduce the spender's allowance to 0 and set the
60    * desired value afterwards:
61    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62    *
63    * Emits an {Approval} event.
64    */
65   function approve(address spender, uint256 amount) external returns (bool);
66 
67   /**
68    * @dev Moves `amount` tokens from `from` to `to` using the
69    * allowance mechanism. `amount` is then deducted from the caller's
70    * allowance.
71    *
72    * Returns a boolean value indicating whether the operation succeeded.
73    *
74    * Emits a {Transfer} event.
75    */
76   function transferFrom(address from, address to, uint256 amount) external returns (bool);
77 }
78 
79 /**
80  * @dev Interface for the optional metadata functions from the ERC20 standard.
81  *
82  * _Available since v4.1._
83  */
84 interface IERC20Metadata is IERC20 {
85   /**
86    * @dev Returns the name of the token.
87    */
88   function name() external view returns (string memory);
89 
90   /**
91    * @dev Returns the symbol of the token.
92    */
93   function symbol() external view returns (string memory);
94 
95   /**
96    * @dev Returns the decimals places of the token.
97    */
98   function decimals() external view returns (uint8);
99 }
100 
101 /**
102  * @dev Provides information about the current execution context, including the
103  * sender of the transaction and its data. While these are generally available
104  * via msg.sender and msg.data, they should not be accessed in such a direct
105  * manner, since when dealing with meta-transactions the account sending and
106  * paying for execution may not be the actual sender (as far as an application
107  * is concerned).
108  *
109  * This contract is only required for intermediate, library-like contracts.
110  */
111 abstract contract Context {
112   function _msgSender() internal view virtual returns (address) {
113     return msg.sender;
114   }
115 
116   function _msgData() internal view virtual returns (bytes calldata) {
117     return msg.data;
118   }
119 }
120 
121 /**
122  * @dev Contract module which provides a basic access control mechanism, where
123  * there is an account (an owner) that can be granted exclusive access to
124  * specific functions.
125  *
126  * By default, the owner account will be the one that deploys the contract. This
127  * can later be changed with {transferOwnership}.
128  *
129  * This module is used through inheritance. It will make available the modifier
130  * `onlyOwner`, which can be applied to your functions to restrict their use to
131  * the owner.
132  */
133 abstract contract Ownable is Context {
134   address private _owner;
135 
136   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138   /**
139    * @dev Initializes the contract setting the deployer as the initial owner.
140    */
141   constructor() {
142     _transferOwnership(_msgSender());
143   }
144 
145   /**
146    * @dev Throws if called by any account other than the owner.
147    */
148   modifier onlyOwner() {
149     _checkOwner();
150     _;
151   }
152 
153   /**
154    * @dev Returns the address of the current owner.
155    */
156   function owner() public view virtual returns (address) {
157     return _owner;
158   }
159 
160   /**
161    * @dev Throws if the sender is not the owner.
162    */
163   function _checkOwner() internal view virtual {
164     require(owner() == _msgSender(), 'Ownable: caller is not the owner');
165   }
166 
167   /**
168    * @dev Leaves the contract without owner. It will not be possible to call
169    * `onlyOwner` functions. Can only be called by the current owner.
170    *
171    * NOTE: Renouncing ownership will leave the contract without an owner,
172    * thereby disabling any functionality that is only available to the owner.
173    */
174   function renounceOwnership() public virtual onlyOwner {
175     _transferOwnership(address(0));
176   }
177 
178   /**
179    * @dev Transfers ownership of the contract to a new account (`newOwner`).
180    * Can only be called by the current owner.
181    */
182   function transferOwnership(address newOwner) public virtual onlyOwner {
183     require(newOwner != address(0), 'Ownable: new owner is the zero address');
184     _transferOwnership(newOwner);
185   }
186 
187   /**
188    * @dev Transfers ownership of the contract to a new account (`newOwner`).
189    * Internal function without access restriction.
190    */
191   function _transferOwnership(address newOwner) internal virtual {
192     address oldOwner = _owner;
193     _owner = newOwner;
194     emit OwnershipTransferred(oldOwner, newOwner);
195   }
196 }
197 
198 contract XRP20Token is Context, IERC20Metadata, Ownable {
199   mapping(address => uint256) private _balances;
200 
201   mapping(address => mapping(address => uint256)) private _allowances;
202 
203   uint256 private _totalSupply;
204 
205   string private _name;
206   string private _symbol;
207   uint8 private constant _decimals = 18;
208   uint256 public constant hardCap = 100_000_000_000 * (10 ** _decimals); //100 billion
209   mapping(address => bool) public isWhitelisted;
210 
211   /**
212    * @dev Contract constructor.
213    * @param name_ The name of the token.
214    * @param symbol_ The symbol of the token.
215    * @param _to The initial address to mint the total supply to.
216    */
217   constructor(string memory name_, string memory symbol_, address _to) {
218     _name = name_;
219     _symbol = symbol_;
220     _mint(_to, hardCap);
221   }
222 
223   /**
224    * @dev change whitelist status of a particular address
225    * @param _address address of the user to change status
226    * @param _status bool value for the status
227    */
228   function whitelistAddress(address _address, bool _status) external onlyOwner {
229     isWhitelisted[_address] = _status;
230   }
231 
232   /**
233    * @dev Returns the name of the token.
234    * @return The name of the token.
235    */
236   function name() public view virtual override returns (string memory) {
237     return _name;
238   }
239 
240   /**
241    * @dev Returns the symbol of the token.
242    * @return The symbol of the token.
243    */
244   function symbol() public view virtual override returns (string memory) {
245     return _symbol;
246   }
247 
248   /**
249    * @dev Returns the number of decimals used for token display.
250    * @return The number of decimals.
251    */
252   function decimals() public view virtual override returns (uint8) {
253     return _decimals;
254   }
255 
256   /**
257    * @dev Returns the total supply of the token.
258    * @return The total supply.
259    */
260   function totalSupply() public view virtual override returns (uint256) {
261     return _totalSupply;
262   }
263 
264   /**
265    * @dev Returns the balance of the specified account.
266    * @param account The address to check the balance for.
267    * @return The balance of the account.
268    */
269   function balanceOf(address account) public view virtual override returns (uint256) {
270     return _balances[account];
271   }
272 
273   /**
274    * @dev Transfers tokens from the caller to a specified recipient.
275    * @param recipient The address to transfer tokens to.
276    * @param amount The amount of tokens to transfer.
277    * @return A boolean value indicating whether the transfer was successful.
278    */
279   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
280     uint256 burnTax = isWhitelisted[_msgSender()] || isWhitelisted[recipient] ? 0 : (amount / 1000);
281     if (burnTax > 0) _burn(_msgSender(), burnTax);
282     _transfer(_msgSender(), recipient, amount - burnTax);
283     return true;
284   }
285 
286   /**
287    * @dev Returns the amount of tokens that the spender is allowed to spend on behalf of the owner.
288    * @param from The address that approves the spending.
289    * @param to The address that is allowed to spend.
290    * @return The remaining allowance for the spender.
291    */
292   function allowance(address from, address to) public view virtual override returns (uint256) {
293     return _allowances[from][to];
294   }
295 
296   /**
297    * @dev Approves the specified address to spend the specified amount of tokens on behalf of the caller.
298    * @param to The address to approve the spending for.
299    * @param amount The amount of tokens to approve.
300    * @return A boolean value indicating whether the approval was successful.
301    */
302   function approve(address to, uint256 amount) public virtual override returns (bool) {
303     _approve(_msgSender(), to, amount);
304     return true;
305   }
306 
307   /**
308    * @dev Transfers tokens from one address to another.
309    * @param sender The address to transfer tokens from.
310    * @param recipient The address to transfer tokens to.
311    * @param amount The amount of tokens to transfer.
312    * @return A boolean value indicating whether the transfer was successful.
313    */
314   function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
315     uint256 burnTax = isWhitelisted[sender] || isWhitelisted[recipient] ? 0 : (amount / 1000);
316     if (burnTax > 0) _burn(sender, burnTax);
317     _transfer(sender, recipient, amount - burnTax);
318     uint256 currentAllowance = _allowances[sender][_msgSender()];
319     require(currentAllowance >= amount, 'ERC20: transfer amount exceeds allowance');
320     unchecked {
321       _approve(sender, _msgSender(), currentAllowance - amount);
322     }
323 
324     return true;
325   }
326 
327   /**
328    * @dev Increases the allowance of the specified address to spend tokens on behalf of the caller.
329    * @param to The address to increase the allowance for.
330    * @param addedValue The amount of tokens to increase the allowance by.
331    * @return A boolean value indicating whether the increase was successful.
332    */
333   function increaseAllowance(address to, uint256 addedValue) public virtual returns (bool) {
334     _approve(_msgSender(), to, _allowances[_msgSender()][to] + addedValue);
335     return true;
336   }
337 
338   /**
339    * @dev Decreases the allowance granted by the owner of the tokens to `to` account.
340    * @param to The account allowed to spend the tokens.
341    * @param subtractedValue The amount of tokens to decrease the allowance by.
342    * @return A boolean value indicating whether the operation succeeded.
343    */
344   function decreaseAllowance(address to, uint256 subtractedValue) public virtual returns (bool) {
345     uint256 currentAllowance = _allowances[_msgSender()][to];
346     require(currentAllowance >= subtractedValue, 'ERC20: decreased allowance below zero');
347     unchecked {
348       _approve(_msgSender(), to, currentAllowance - subtractedValue);
349     }
350 
351     return true;
352   }
353 
354   /**
355    * @dev Transfers `amount` tokens from `sender` to `recipient`.
356    * @param sender The account to transfer tokens from.
357    * @param recipient The account to transfer tokens to.
358    * @param amount The amount of tokens to transfer.
359    */
360   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
361     require(amount > 0, 'ERC20: transfer amount zero');
362     require(sender != address(0), 'ERC20: transfer from the zero address');
363     require(recipient != address(0), 'ERC20: transfer to the zero address');
364 
365     uint256 senderBalance = _balances[sender];
366     require(senderBalance >= amount, 'ERC20: transfer amount exceeds balance');
367     unchecked {
368       _balances[sender] = senderBalance - amount;
369     }
370     _balances[recipient] += amount;
371 
372     emit Transfer(sender, recipient, amount);
373   }
374 
375   /**
376    * @dev Creates `amount` tokens and assigns them to `account`.
377    * @param account The account to assign the newly created tokens to.
378    * @param amount The amount of tokens to create.
379    */
380   function _mint(address account, uint256 amount) internal virtual {
381     require(account != address(0), 'ERC20: mint to the zero address');
382 
383     _totalSupply += amount;
384     _balances[account] += amount;
385     emit Transfer(address(0), account, amount);
386   }
387 
388   /**
389    * @dev Destroys `amount` tokens from `account`, reducing the total supply.
390    * @param account The account to burn tokens from.
391    * @param amount The amount of tokens to burn.
392    */
393   function _burn(address account, uint256 amount) internal virtual {
394     require(account != address(0), 'ERC20: burn from the zero address');
395 
396     uint256 accountBalance = _balances[account];
397     require(accountBalance >= amount, 'ERC20: burn amount exceeds balance');
398     unchecked {
399       _balances[account] = accountBalance - amount;
400     }
401     _totalSupply -= amount;
402 
403     emit Transfer(account, address(0), amount);
404   }
405 
406   /**
407    * @dev Destroys `amount` tokens from the caller's account, reducing the total supply.
408    * @param amount The amount of tokens to burn.
409    */
410   function burn(uint256 amount) external {
411     _burn(_msgSender(), amount);
412   }
413 
414   /**
415    * @dev Sets `amount` as the allowance of `to` over the caller's tokens.
416    * @param from The account granting the allowance.
417    * @param to The account allowed to spend the tokens.
418    * @param amount The amount of tokens to allow.
419    */
420   function _approve(address from, address to, uint256 amount) internal virtual {
421     require(from != address(0), 'ERC20: approve from the zero address');
422     require(to != address(0), 'ERC20: approve to the zero address');
423 
424     _allowances[from][to] = amount;
425     emit Approval(from, to, amount);
426   }
427 }