1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-17
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.9;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Emitted when `value` tokens are moved from one account (`from`) to
15      * another (`to`).
16      *
17      * Note that `value` may be zero.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
23      * a call to {approve}. `value` is the new allowance.
24      */
25     event Approval(
26         address indexed owner,
27         address indexed spender,
28         uint256 value
29     );
30 
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `to`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address to, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(
58         address owner,
59         address spender
60     ) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `from` to `to` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address from,
89         address to,
90         uint256 amount
91     ) external returns (bool);
92 }
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
116 /**
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         return msg.data;
133     }
134 }
135 
136 /**
137  * @dev Contract module which provides a basic access control mechanism, where
138  * there is an account (an owner) that can be granted exclusive access to
139  * specific functions.
140  *
141  * By default, the owner account will be the one that deploys the contract. This
142  * can later be changed with {transferOwnership}.
143  *
144  * This module is used through inheritance. It will make available the modifier
145  * `onlyOwner`, which can be applied to your functions to restrict their use to
146  * the owner.
147  */
148 abstract contract Ownable is Context {
149     address private _owner;
150 
151     event OwnershipTransferred(
152         address indexed previousOwner,
153         address indexed newOwner
154     );
155 
156     /**
157      * @dev Initializes the contract setting the deployer as the initial owner.
158      */
159     constructor() {
160         _transferOwnership(_msgSender());
161     }
162 
163     /**
164      * @dev Throws if called by any account other than the owner.
165      */
166     modifier onlyOwner() {
167         _checkOwner();
168         _;
169     }
170 
171     /**
172      * @dev Returns the address of the current owner.
173      */
174     function owner() public view virtual returns (address) {
175         return _owner;
176     }
177 
178     /**
179      * @dev Throws if the sender is not the owner.
180      */
181     function _checkOwner() internal view virtual {
182         require(owner() == _msgSender(), "Ownable: caller is not the owner");
183     }
184 
185     /**
186      * @dev Leaves the contract without owner. It will not be possible to call
187      * `onlyOwner` functions. Can only be called by the current owner.
188      *
189      * NOTE: Renouncing ownership will leave the contract without an owner,
190      * thereby disabling any functionality that is only available to the owner.
191      */
192     function renounceOwnership() public virtual onlyOwner {
193         _transferOwnership(address(0));
194     }
195 
196     /**
197      * @dev Transfers ownership of the contract to a new account (`newOwner`).
198      * Can only be called by the current owner.
199      */
200     function transferOwnership(address newOwner) public virtual onlyOwner {
201         require(
202             newOwner != address(0),
203             "Ownable: new owner is the zero address"
204         );
205         _transferOwnership(newOwner);
206     }
207 
208     /**
209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
210      * Internal function without access restriction.
211      */
212     function _transferOwnership(address newOwner) internal virtual {
213         address oldOwner = _owner;
214         _owner = newOwner;
215         emit OwnershipTransferred(oldOwner, newOwner);
216     }
217 }
218 
219 contract Token is Context, IERC20Metadata, Ownable {
220     mapping(address => uint256) private _balances;
221 
222     mapping(address => mapping(address => uint256)) private _allowances;
223 
224     uint256 private _totalSupply;
225 
226     string private _name;
227     string private _symbol;
228     uint8 private constant _decimals = 18;
229     uint256 public constant hardCap = 6_666_666_666 * (10 ** _decimals); 
230     bool public transferStatus;
231 
232     /**
233      * @dev Contract constructor.
234      * @param name_ The name of the token.
235      * @param symbol_ The symbol of the token.
236      * @param _to The initial address to mint the total supply to.
237      */
238     constructor(string memory name_, string memory symbol_, address _to) {
239         transferStatus = true;
240         _name = name_;
241         _symbol = symbol_;
242         _mint(_to, hardCap);
243     }
244 
245     /**
246      * @dev Changes token transfer state
247      * @param _status Status flag for transfer
248      */
249 
250     function setTransferStatus(bool _status) public onlyOwner {
251         transferStatus = _status;
252     }
253 
254     /**
255      * @dev Returns the name of the token.
256      * @return The name of the token.
257      */
258     function name() public view virtual override returns (string memory) {
259         return _name;
260     }
261 
262     /**
263      * @dev Returns the symbol of the token.
264      * @return The symbol of the token.
265      */
266     function symbol() public view virtual override returns (string memory) {
267         return _symbol;
268     }
269 
270     /**
271      * @dev Returns the number of decimals used for token display.
272      * @return The number of decimals.
273      */
274     function decimals() public view virtual override returns (uint8) {
275         return _decimals;
276     }
277 
278     /**
279      * @dev Returns the total supply of the token.
280      * @return The total supply.
281      */
282     function totalSupply() public view virtual override returns (uint256) {
283         return _totalSupply;
284     }
285 
286     /**
287      * @dev Returns the balance of the specified account.
288      * @param account The address to check the balance for.
289      * @return The balance of the account.
290      */
291     function balanceOf(
292         address account
293     ) public view virtual override returns (uint256) {
294         return _balances[account];
295     }
296 
297     /**
298      * @dev Transfers tokens from the caller to a specified recipient.
299      * @param recipient The address to transfer tokens to.
300      * @param amount The amount of tokens to transfer.
301      * @return A boolean value indicating whether the transfer was successful.
302      */
303     function transfer(
304         address recipient,
305         uint256 amount
306     ) public virtual override returns (bool) {
307         _transfer(_msgSender(), recipient, amount);
308         return true;
309     }
310 
311     /**
312      * @dev Returns the amount of tokens that the spender is allowed to spend on behalf of the owner.
313      * @param from The address that approves the spending.
314      * @param to The address that is allowed to spend.
315      * @return The remaining allowance for the spender.
316      */
317     function allowance(
318         address from,
319         address to
320     ) public view virtual override returns (uint256) {
321         return _allowances[from][to];
322     }
323 
324     /**
325      * @dev Approves the specified address to spend the specified amount of tokens on behalf of the caller.
326      * @param to The address to approve the spending for.
327      * @param amount The amount of tokens to approve.
328      * @return A boolean value indicating whether the approval was successful.
329      */
330     function approve(
331         address to,
332         uint256 amount
333     ) public virtual override returns (bool) {
334         _approve(_msgSender(), to, amount);
335         return true;
336     }
337 
338     /**
339      * @dev Transfers tokens from one address to another.
340      * @param sender The address to transfer tokens from.
341      * @param recipient The address to transfer tokens to.
342      * @param amount The amount of tokens to transfer.
343      * @return A boolean value indicating whether the transfer was successful.
344      */
345     function transferFrom(
346         address sender,
347         address recipient,
348         uint256 amount
349     ) public virtual override returns (bool) {
350         _transfer(sender, recipient, amount);
351 
352         uint256 currentAllowance = _allowances[sender][_msgSender()];
353         require(
354             currentAllowance >= amount,
355             "ERC20: transfer amount exceeds allowance"
356         );
357         unchecked {
358             _approve(sender, _msgSender(), currentAllowance - amount);
359         }
360 
361         return true;
362     }
363 
364     /**
365      * @dev Increases the allowance of the specified address to spend tokens on behalf of the caller.
366      * @param to The address to increase the allowance for.
367      * @param addedValue The amount of tokens to increase the allowance by.
368      * @return A boolean value indicating whether the increase was successful.
369      */
370     function increaseAllowance(
371         address to,
372         uint256 addedValue
373     ) public virtual returns (bool) {
374         _approve(_msgSender(), to, _allowances[_msgSender()][to] + addedValue);
375         return true;
376     }
377 
378     /**
379      * @dev Decreases the allowance granted by the owner of the tokens to `to` account.
380      * @param to The account allowed to spend the tokens.
381      * @param subtractedValue The amount of tokens to decrease the allowance by.
382      * @return A boolean value indicating whether the operation succeeded.
383      */
384     function decreaseAllowance(
385         address to,
386         uint256 subtractedValue
387     ) public virtual returns (bool) {
388         uint256 currentAllowance = _allowances[_msgSender()][to];
389         require(
390             currentAllowance >= subtractedValue,
391             "ERC20: decreased allowance below zero"
392         );
393         unchecked {
394             _approve(_msgSender(), to, currentAllowance - subtractedValue);
395         }
396 
397         return true;
398     }
399 
400     /**
401      * @dev Transfers `amount` tokens from `sender` to `recipient`.
402      * @param sender The account to transfer tokens from.
403      * @param recipient The account to transfer tokens to.
404      * @param amount The amount of tokens to transfer.
405      */
406     function _transfer(
407         address sender,
408         address recipient,
409         uint256 amount
410     ) internal virtual {
411         require(amount > 0, "ERC20: transfer amount zero");
412         require(sender != address(0), "ERC20: transfer from the zero address");
413         require(recipient != address(0), "ERC20: transfer to the zero address");
414         require(transferStatus ,"tokens transfer functionality paused");
415 
416         uint256 senderBalance = _balances[sender];
417         require(
418             senderBalance >= amount,
419             "ERC20: transfer amount exceeds balance"
420         );
421         unchecked {
422             _balances[sender] = senderBalance - amount;
423         }
424         _balances[recipient] += amount;
425 
426         emit Transfer(sender, recipient, amount);
427     }
428 
429     /**
430      * @dev Creates `amount` tokens and assigns them to `account`.
431      * @param account The account to assign the newly created tokens to.
432      * @param amount The amount of tokens to create.
433      */
434     function _mint(address account, uint256 amount) internal virtual {
435         require(account != address(0), "ERC20: mint to the zero address");
436 
437         _totalSupply += amount;
438         _balances[account] += amount;
439         emit Transfer(address(0), account, amount);
440     }
441 
442     /**
443      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
444      * @param account The account to burn tokens from.
445      * @param amount The amount of tokens to burn.
446      */
447     function _burn(address account, uint256 amount) internal virtual {
448         require(account != address(0), "ERC20: burn from the zero address");
449 
450         uint256 accountBalance = _balances[account];
451         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
452         unchecked {
453             _balances[account] = accountBalance - amount;
454         }
455         _totalSupply -= amount;
456 
457         emit Transfer(account, address(0), amount);
458     }
459 
460     /**
461      * @dev Destroys `amount` tokens from the caller's account, reducing the total supply.
462      * @param amount The amount of tokens to burn.
463      */
464     function burn(uint256 amount) external {
465         _burn(_msgSender(), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `to` over the caller's tokens.
470      * @param from The account granting the allowance.
471      * @param to The account allowed to spend the tokens.
472      * @param amount The amount of tokens to allow.
473      */
474     function _approve(
475         address from,
476         address to,
477         uint256 amount
478     ) internal virtual {
479         require(from != address(0), "ERC20: approve from the zero address");
480         require(to != address(0), "ERC20: approve to the zero address");
481 
482         _allowances[from][to] = amount;
483         emit Approval(from, to, amount);
484     }
485 }