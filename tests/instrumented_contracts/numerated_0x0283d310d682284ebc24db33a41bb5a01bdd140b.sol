1 //      88     888888b.   8888888888 8888888888 8888888b.       
2 //  .d88888b.  888  "88b  888        888        888   Y88b      
3 // d88P 88"88b 888  .88P  888        888        888    888      
4 // Y88b.88     8888888K.  8888888    8888888    888   d88P      
5 //  "Y88888b.  888  "Y88b 888        888        8888888P"       
6 //      88"88b 888    888 888        888        888             
7 // Y88b 88.88P 888   d88P 888        888        888             
8 //  "Y88888P"  8888888P"  8888888888 8888888888 888             
9 //      88                                                      
10 //
11 // Website: https://www.beeperc20.com
12 //
13 // Twitter:  https://twitter.com/BeepERC20/
14 //
15 // Whitepaper: https://www.beeperc20.com/whitepaper
16 //
17 // Telegram: https://t.me/BeepERC
18 
19 // File: ITreasuryHandler.sol
20 
21 
22 pragma solidity 0.8.11;
23 
24 /**
25  * @title Treasury handler interface
26  * @dev Any class that implements this interface can be used for protocol-specific operations pertaining to the treasury.
27  */
28 interface ITreasuryHandler {
29     /**
30      * @notice Perform operations before a transfer is executed.
31      * @param benefactor Address of the benefactor.
32      * @param beneficiary Address of the beneficiary.
33      * @param amount Number of tokens in the transfer.
34      */
35     function beforeTransferHandler(
36         address benefactor,
37         address beneficiary,
38         uint256 amount
39     ) external;
40 
41     /**
42      * @notice Perform operations after a transfer is executed.
43      * @param benefactor Address of the benefactor.
44      * @param beneficiary Address of the beneficiary.
45      * @param amount Number of tokens in the transfer.
46      */
47     function afterTransferHandler(
48         address benefactor,
49         address beneficiary,
50         uint256 amount
51     ) external;
52 }
53 // File: ITaxHandler.sol
54 
55 
56 pragma solidity 0.8.11;
57 
58 /**
59  * @title Tax handler interface
60  * @dev Any class that implements this interface can be used for protocol-specific tax calculations.
61  */
62 interface ITaxHandler {
63     /**
64      * @notice Get number of tokens to pay as tax.
65      * @param benefactor Address of the benefactor.
66      * @param beneficiary Address of the beneficiary.
67      * @param amount Number of tokens in the transfer.
68      * @return Number of tokens to pay as tax.
69      */
70     function getTax(
71         address benefactor,
72         address beneficiary,
73         uint256 amount
74     ) external view returns (uint256);
75 }
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         return msg.data;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/access/Ownable.sol
104 
105 
106 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 abstract contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor() {
132         _transferOwnership(_msgSender());
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         _checkOwner();
140         _;
141     }
142 
143     /**
144      * @dev Returns the address of the current owner.
145      */
146     function owner() public view virtual returns (address) {
147         return _owner;
148     }
149 
150     /**
151      * @dev Throws if the sender is not the owner.
152      */
153     function _checkOwner() internal view virtual {
154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
155     }
156 
157     /**
158      * @dev Leaves the contract without owner. It will not be possible to call
159      * `onlyOwner` functions anymore. Can only be called by the current owner.
160      *
161      * NOTE: Renouncing ownership will leave the contract without an owner,
162      * thereby removing any functionality that is only available to the owner.
163      */
164     function renounceOwnership() public virtual onlyOwner {
165         _transferOwnership(address(0));
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Can only be called by the current owner.
171      */
172     function transferOwnership(address newOwner) public virtual onlyOwner {
173         require(newOwner != address(0), "Ownable: new owner is the zero address");
174         _transferOwnership(newOwner);
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      * Internal function without access restriction.
180      */
181     function _transferOwnership(address newOwner) internal virtual {
182         address oldOwner = _owner;
183         _owner = newOwner;
184         emit OwnershipTransferred(oldOwner, newOwner);
185     }
186 }
187 
188 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
189 
190 
191 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @dev Interface of the ERC20 standard as defined in the EIP.
197  */
198 interface IERC20 {
199     /**
200      * @dev Emitted when `value` tokens are moved from one account (`from`) to
201      * another (`to`).
202      *
203      * Note that `value` may be zero.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 value);
206 
207     /**
208      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
209      * a call to {approve}. `value` is the new allowance.
210      */
211     event Approval(address indexed owner, address indexed spender, uint256 value);
212 
213     /**
214      * @dev Returns the amount of tokens in existence.
215      */
216     function totalSupply() external view returns (uint256);
217 
218     /**
219      * @dev Returns the amount of tokens owned by `account`.
220      */
221     function balanceOf(address account) external view returns (uint256);
222 
223     /**
224      * @dev Moves `amount` tokens from the caller's account to `to`.
225      *
226      * Returns a boolean value indicating whether the operation succeeded.
227      *
228      * Emits a {Transfer} event.
229      */
230     function transfer(address to, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Returns the remaining number of tokens that `spender` will be
234      * allowed to spend on behalf of `owner` through {transferFrom}. This is
235      * zero by default.
236      *
237      * This value changes when {approve} or {transferFrom} are called.
238      */
239     function allowance(address owner, address spender) external view returns (uint256);
240 
241     /**
242      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * IMPORTANT: Beware that changing an allowance with this method brings the risk
247      * that someone may use both the old and the new allowance by unfortunate
248      * transaction ordering. One possible solution to mitigate this race
249      * condition is to first reduce the spender's allowance to 0 and set the
250      * desired value afterwards:
251      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252      *
253      * Emits an {Approval} event.
254      */
255     function approve(address spender, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Moves `amount` tokens from `from` to `to` using the
259      * allowance mechanism. `amount` is then deducted from the caller's
260      * allowance.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transferFrom(
267         address from,
268         address to,
269         uint256 amount
270     ) external returns (bool);
271 }
272 
273 // File: BEEP.sol
274 
275 
276 
277 pragma solidity 0.8.11;
278 
279 
280 
281 
282 
283 /**
284  * @title BEEP token contract
285  * @dev The BEEP token has modular systems for tax and treasury handler capabilities.
286  */
287 contract BEEP is IERC20, Ownable {
288     /// @dev Registry of user token balances.
289     mapping(address => uint256) private _balances;
290 
291     /// @dev Registry of addresses users have given allowances to.
292     mapping(address => mapping(address => uint256)) private _allowances;
293 
294     /// @notice The EIP-712 typehash for the contract's domain.
295     bytes32 public constant DOMAIN_TYPEHASH =
296         keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
297 
298     /// @notice The contract implementing tax calculations.
299     ITaxHandler public taxHandler;
300 
301     /// @notice The contract that performs treasury-related operations.
302     ITreasuryHandler public treasuryHandler;
303 
304     /// @notice Emitted when the tax handler contract is changed.
305     event TaxHandlerChanged(address oldAddress, address newAddress);
306 
307     /// @notice Emitted when the treasury handler contract is changed.
308     event TreasuryHandlerChanged(address oldAddress, address newAddress);
309 
310     /// @dev Name of the token.
311     string private _name;
312 
313     /// @dev Symbol of the token.
314     string private _symbol;
315 
316     /**
317      * @param name_ Name of the token.
318      * @param symbol_ Symbol of the token.
319      * @param taxHandlerAddress Initial tax handler contract.
320      * @param treasuryHandlerAddress Initial treasury handler contract.
321      */
322     constructor(
323         string memory name_,
324         string memory symbol_,
325         address taxHandlerAddress,
326         address treasuryHandlerAddress
327     ) {
328         _name = name_;
329         _symbol = symbol_;
330 
331         taxHandler = ITaxHandler(taxHandlerAddress);
332         treasuryHandler = ITreasuryHandler(treasuryHandlerAddress);
333 
334         _balances[_msgSender()] = totalSupply();
335 
336         emit Transfer(address(0), _msgSender(), totalSupply());
337     }
338 
339     /**
340      * @notice Get token name.
341      * @return Name of the token.
342      */
343     function name() public view returns (string memory) {
344         return _name;
345     }
346 
347     /**
348      * @notice Get token symbol.
349      * @return Symbol of the token.
350      */
351     function symbol() external view returns (string memory) {
352         return _symbol;
353     }
354 
355     /**
356      * @notice Get number of decimals used by the token.
357      * @return Number of decimals used by the token.
358      */
359     function decimals() external pure returns (uint8) {
360         return 18;
361     }
362 
363     /**
364      * @notice Get the maximum number of tokens.
365      * @return The maximum number of tokens that will ever be in existence.
366      */
367     function totalSupply() public pure override returns (uint256) {
368         // 1 billion, i.e., 1,000,000,000 tokens.
369         return 1e9 * 1e18;
370     }
371 
372     /**
373      * @notice Get token balance of given given account.
374      * @param account Address to retrieve balance for.
375      * @return The number of tokens owned by `account`.
376      */
377     function balanceOf(address account) external view override returns (uint256) {
378         return _balances[account];
379     }
380 
381     /**
382      * @notice Transfer tokens from caller's address to another.
383      * @param recipient Address to send the caller's tokens to.
384      * @param amount The number of tokens to transfer to recipient.
385      * @return True if transfer succeeds, else an error is raised.
386      */
387     function transfer(address recipient, uint256 amount) external override returns (bool) {
388         _transfer(_msgSender(), recipient, amount);
389         return true;
390     }
391 
392     /**
393      * @notice Get the allowance `owner` has given `spender`.
394      * @param owner The address on behalf of whom tokens can be spent by `spender`.
395      * @param spender The address authorized to spend tokens on behalf of `owner`.
396      * @return The allowance `owner` has given `spender`.
397      */
398     function allowance(address owner, address spender) external view override returns (uint256) {
399         return _allowances[owner][spender];
400     }
401 
402     /**
403      * @notice Approve address to spend caller's tokens.
404      * @dev This method can be exploited by malicious spenders if their allowance is already non-zero. See the following
405      * document for details: https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit.
406      * Ensure the spender can be trusted before calling this method if they've already been approved before. Otherwise
407      * use either the `increaseAllowance`/`decreaseAllowance` functions, or first set their allowance to zero, before
408      * setting a new allowance.
409      * @param spender Address to authorize for token expenditure.
410      * @param amount The number of tokens `spender` is allowed to spend.
411      * @return True if the approval succeeds, else an error is raised.
412      */
413     function approve(address spender, uint256 amount) external override returns (bool) {
414         _approve(_msgSender(), spender, amount);
415         return true;
416     }
417 
418     /**
419      * @notice Transfer tokens from one address to another.
420      * @param sender Address to move tokens from.
421      * @param recipient Address to send the caller's tokens to.
422      * @param amount The number of tokens to transfer to recipient.
423      * @return True if the transfer succeeds, else an error is raised.
424      */
425     function transferFrom(
426         address sender,
427         address recipient,
428         uint256 amount
429     ) external override returns (bool) {
430         _transfer(sender, recipient, amount);
431 
432         uint256 currentAllowance = _allowances[sender][_msgSender()];
433         require(
434             currentAllowance >= amount,
435             "BEEP:transferFrom:ALLOWANCE_EXCEEDED: Transfer amount exceeds allowance."
436         );
437         unchecked {
438             _approve(sender, _msgSender(), currentAllowance - amount);
439         }
440 
441         return true;
442     }
443 
444     /**
445      * @notice Increase spender's allowance.
446      * @param spender Address of user authorized to spend caller's tokens.
447      * @param addedValue The number of tokens to add to `spender`'s allowance.
448      * @return True if the allowance is successfully increased, else an error is raised.
449      */
450     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
451         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
452 
453         return true;
454     }
455 
456     /**
457      * @notice Decrease spender's allowance.
458      * @param spender Address of user authorized to spend caller's tokens.
459      * @param subtractedValue The number of tokens to remove from `spender`'s allowance.
460      * @return True if the allowance is successfully decreased, else an error is raised.
461      */
462     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
463         uint256 currentAllowance = _allowances[_msgSender()][spender];
464         require(
465             currentAllowance >= subtractedValue,
466             "BEEP:decreaseAllowance:ALLOWANCE_UNDERFLOW: Subtraction results in sub-zero allowance."
467         );
468         unchecked {
469             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
470         }
471 
472         return true;
473     }
474 
475     /**
476      * @notice Set new tax handler contract.
477      * @param taxHandlerAddress Address of new tax handler contract.
478      */
479     function setTaxHandler(address taxHandlerAddress) external onlyOwner {
480         address oldTaxHandlerAddress = address(taxHandler);
481         taxHandler = ITaxHandler(taxHandlerAddress);
482 
483         emit TaxHandlerChanged(oldTaxHandlerAddress, taxHandlerAddress);
484     }
485 
486     /**
487      * @notice Set new treasury handler contract.
488      * @param treasuryHandlerAddress Address of new treasury handler contract.
489      */
490     function setTreasuryHandler(address treasuryHandlerAddress) external onlyOwner {
491         address oldTreasuryHandlerAddress = address(treasuryHandler);
492         treasuryHandler = ITreasuryHandler(treasuryHandlerAddress);
493 
494         emit TreasuryHandlerChanged(oldTreasuryHandlerAddress, treasuryHandlerAddress);
495     }
496 
497     /**
498      * @notice Approve spender on behalf of owner.
499      * @param owner Address on behalf of whom tokens can be spent by `spender`.
500      * @param spender Address to authorize for token expenditure.
501      * @param amount The number of tokens `spender` is allowed to spend.
502      */
503     function _approve(
504         address owner,
505         address spender,
506         uint256 amount
507     ) private {
508         require(owner != address(0), "BEEP:_approve:OWNER_ZERO: Cannot approve for the zero address.");
509         require(spender != address(0), "BEEP:_approve:SPENDER_ZERO: Cannot approve to the zero address.");
510 
511         _allowances[owner][spender] = amount;
512 
513         emit Approval(owner, spender, amount);
514     }
515 
516     /**
517      * @notice Transfer `amount` tokens from account `from` to account `to`.
518      * @param from Address the tokens are moved out of.
519      * @param to Address the tokens are moved to.
520      * @param amount The number of tokens to transfer.
521      */
522     function _transfer(
523         address from,
524         address to,
525         uint256 amount
526     ) private {
527         require(from != address(0), "BEEP:_transfer:FROM_ZERO: Cannot transfer from the zero address.");
528         require(to != address(0), "BEEP:_transfer:TO_ZERO: Cannot transfer to the zero address.");
529         require(amount > 0, "BEEP:_transfer:ZERO_AMOUNT: Transfer amount must be greater than zero.");
530         require(amount <= _balances[from], "BEEP:_transfer:INSUFFICIENT_BALANCE: Transfer amount exceeds balance.");
531 
532         treasuryHandler.beforeTransferHandler(from, to, amount);
533 
534         uint256 tax = taxHandler.getTax(from, to, amount);
535         uint256 taxedAmount = amount - tax;
536 
537         _balances[from] -= amount;
538         _balances[to] += taxedAmount;
539 
540         if (tax > 0) {
541             _balances[address(treasuryHandler)] += tax;
542 
543             emit Transfer(from, address(treasuryHandler), tax);
544         }
545 
546         treasuryHandler.afterTransferHandler(from, to, amount);
547 
548         emit Transfer(from, to, taxedAmount);
549     }
550 }