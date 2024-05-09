1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @dev Implementation of the {IERC20} interface.
93  */
94 contract ERC20 is Context, IERC20 {
95     using SafeMath for uint256;
96     using Address for address;
97 
98     mapping (address => uint256) private _balances;
99 
100     mapping (address => mapping (address => uint256)) private _allowances;
101 
102     uint256 private _totalSupply;
103 
104     string private _name;
105     string private _symbol;
106     uint8 private _decimals;
107 
108     /**
109      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
110      * a default value of 18.
111      *
112      * To select a different value for {decimals}, use {_setupDecimals}.
113      *
114      * All three of these values are immutable: they can only be set once during
115      * construction.
116      */
117     constructor (string memory name, string memory symbol) public {
118         _name = name;
119         _symbol = symbol;
120         _decimals = 18;
121     }
122 
123     /**
124      * @dev Returns the name of the token.
125      */
126     function name() public view returns (string memory) {
127         return _name;
128     }
129 
130     /**
131      * @dev Returns the symbol of the token, usually a shorter version of the
132      * name.
133      */
134     function symbol() public view returns (string memory) {
135         return _symbol;
136     }
137 
138     /**
139      * @dev Returns the number of decimals used to get its user representation.
140      * For example, if `decimals` equals `2`, a balance of `505` tokens should
141      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
142      */
143     function decimals() public view returns (uint8) {
144         return _decimals;
145     }
146 
147     /**
148      * @dev See {IERC20-totalSupply}.
149      */
150     function totalSupply() public view override returns (uint256) {
151         return _totalSupply;
152     }
153 
154     /**
155      * @dev See {IERC20-balanceOf}.
156      */
157     function balanceOf(address account) public view override returns (uint256) {
158         return _balances[account];
159     }
160 
161     /**
162      * @dev See {IERC20-transfer}.
163      */
164     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
165         _transfer(_msgSender(), recipient, amount);
166         return true;
167     }
168 
169     /**
170      * @dev See {IERC20-allowance}.
171      */
172     function allowance(address owner, address spender) public view virtual override returns (uint256) {
173         return _allowances[owner][spender];
174     }
175 
176     /**
177      * @dev See {IERC20-approve}.
178      */
179     function approve(address spender, uint256 amount) public virtual override returns (bool) {
180         _approve(_msgSender(), spender, amount);
181         return true;
182     }
183 
184     /**
185      * @dev See {IERC20-transferFrom}.
186      *
187      * Emits an {Approval} event indicating the updated allowance. This is not
188      * required by the EIP. See the note at the beginning of {ERC20};
189      */
190     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
191         _transfer(sender, recipient, amount);
192         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
193         return true;
194     }
195 
196     /**
197      * @dev Atomically increases the allowance granted to `spender` by the caller.
198      *
199      * This is an alternative to {approve} that can be used as a mitigation for
200      * problems described in {IERC20-approve}.
201      *
202      * Emits an {Approval} event indicating the updated allowance.
203      */
204     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
205         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
206         return true;
207     }
208 
209     /**
210      * @dev Atomically decreases the allowance granted to `spender` by the caller.
211      *
212      * This is an alternative to {approve} that can be used as a mitigation for
213      * problems described in {IERC20-approve}.
214      *
215      * Emits an {Approval} event indicating the updated allowance.
216      */
217     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
218         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
219         return true;
220     }
221 
222     /**
223      * @dev Moves tokens `amount` from `sender` to `recipient`.
224      *
225      * This is internal function is equivalent to {transfer}, and can be used to
226      * e.g. implement automatic token fees, slashing mechanisms, etc.
227      *
228      * Emits a {Transfer} event.
229      */
230     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
231         require(sender != address(0), "ERC20: transfer from the zero address");
232         require(recipient != address(0), "ERC20: transfer to the zero address");
233 
234         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
235         _balances[recipient] = _balances[recipient].add(amount);
236         emit Transfer(sender, recipient, amount);
237     }
238 
239     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
240      * the total supply.
241      *
242      * Emits a {Transfer} event with `from` set to the zero address.
243      */
244     function _mint(address account, uint256 amount) internal virtual {
245         require(account != address(0), "ERC20: mint to the zero address");
246 
247         _totalSupply = _totalSupply.add(amount);
248         _balances[account] = _balances[account].add(amount);
249         emit Transfer(address(0), account, amount);
250     }
251 
252     /**
253      * @dev Destroys `amount` tokens from `account`, reducing the
254      * total supply.
255      *
256      * Emits a {Transfer} event with `to` set to the zero address.
257      */
258     function _burn(address account, uint256 amount) internal virtual {
259         require(account != address(0), "ERC20: burn from the zero address");
260 
261         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
262         _totalSupply = _totalSupply.sub(amount);
263         emit Transfer(account, address(0), amount);
264     }
265 
266     /**
267      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
268      *
269      * This internal function is equivalent to `approve`, and can be used to
270      * e.g. set automatic allowances for certain subsystems, etc.
271      *
272      * Emits an {Approval} event.
273      */
274     function _approve(address owner, address spender, uint256 amount) internal virtual {
275         require(owner != address(0), "ERC20: approve from the zero address");
276         require(spender != address(0), "ERC20: approve to the zero address");
277 
278         _allowances[owner][spender] = amount;
279         emit Approval(owner, spender, amount);
280     }
281 
282     /**
283      * @dev Sets {decimals} to a value other than the default one of 18.
284      *
285      * WARNING: This function should only be called from the constructor. Most
286      * applications that interact with token contracts will not expect
287      * {decimals} to ever change, and may work incorrectly if it does.
288      */
289     function _setupDecimals(uint8 decimals_) internal {
290         _decimals = decimals_;
291     }
292 }
293 
294 /**
295  * @dev Collection of functions related to the address type
296  */
297 library Address {
298     /**
299      * @dev Returns true if `account` is a contract.
300      *
301      * [IMPORTANT]
302      * ====
303      * It is unsafe to assume that an address for which this function returns
304      * false is an externally-owned account (EOA) and not a contract.
305      *
306      * Among others, `isContract` will return false for the following
307      * types of addresses:
308      *
309      *  - an externally-owned account
310      *  - a contract in construction
311      *  - an address where a contract will be created
312      *  - an address where a contract lived, but was destroyed
313      * ====
314      */
315     function isContract(address account) internal view returns (bool) {
316         // This method relies in extcodesize, which returns 0 for contracts in
317         // construction, since the code is only stored at the end of the
318         // constructor execution.
319 
320         uint256 size;
321         // solhint-disable-next-line no-inline-assembly
322         assembly { size := extcodesize(account) }
323         return size > 0;
324     }
325 
326     /**
327      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
328      * `recipient`, forwarding all available gas and reverting on errors.
329      *
330      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
331      * of certain opcodes, possibly making contracts go over the 2300 gas limit
332      * imposed by `transfer`, making them unable to receive funds via
333      * `transfer`. {sendValue} removes this limitation.
334      *
335      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
336      */
337     function sendValue(address payable recipient, uint256 amount) internal {
338         require(address(this).balance >= amount, "Address: insufficient balance");
339 
340         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
341         (bool success, ) = recipient.call{ value: amount }("");
342         require(success, "Address: unable to send value, recipient may have reverted");
343     }
344 
345     /**
346      * @dev Performs a Solidity function call using a low level `call`. A
347      * plain`call` is an unsafe replacement for a function call: use this
348      * function instead.
349      *
350      * If `target` reverts with a revert reason, it is bubbled up by this
351      * function (like regular Solidity function calls).
352      *
353      * Returns the raw returned data. To convert to the expected return value,
354      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357       return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
367         return _functionCallWithValue(target, data, 0, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but also transferring `value` wei to `target`.
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         return _functionCallWithValue(target, data, value, errorMessage);
387     }
388 
389     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
390         require(isContract(target), "Address: call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 // solhint-disable-next-line no-inline-assembly
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 /**
414  * @dev Contract module which provides a basic access control mechanism, where
415  * there is an account (an owner) that can be granted exclusive access to
416  * specific functions.
417  *
418  * By default, the owner account will be the one that deploys the contract. This
419  * can later be changed with {transferOwnership}.
420  *
421  * This module is used through inheritance. It will make available the modifier
422  * `onlyOwner`, which can be applied to your functions to restrict their use to
423  * the owner.
424  */
425 contract Ownable is Context {
426     address private _owner;
427 
428     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
429 
430     /**
431      * @dev Initializes the contract setting the deployer as the initial owner.
432      */
433     constructor () internal {
434         address msgSender = _msgSender();
435         _owner = msgSender;
436         emit OwnershipTransferred(address(0), msgSender);
437     }
438 
439     /**
440      * @dev Returns the address of the current owner.
441      */
442     function owner() public view returns (address) {
443         return _owner;
444     }
445 
446     /**
447      * @dev Throws if called by any account other than the owner.
448      */
449     modifier onlyOwner() {
450         require(_owner == _msgSender(), "Ownable: caller is not the owner");
451         _;
452     }
453 
454     /**
455      * @dev Leaves the contract without owner. It will not be possible to call
456      * `onlyOwner` functions anymore. Can only be called by the current owner.
457      *
458      * NOTE: Renouncing ownership will leave the contract without an owner,
459      * thereby removing any functionality that is only available to the owner.
460      */
461     function renounceOwnership() public virtual onlyOwner {
462         emit OwnershipTransferred(_owner, address(0));
463         _owner = address(0);
464     }
465 
466     /**
467      * @dev Transfers ownership of the contract to a new account (`newOwner`).
468      * Can only be called by the current owner.
469      */
470     function transferOwnership(address newOwner) public virtual onlyOwner {
471         require(newOwner != address(0), "Ownable: new owner is the zero address");
472         emit OwnershipTransferred(_owner, newOwner);
473         _owner = newOwner;
474     }
475 }
476 
477 /**
478  * @dev Wrappers over Solidity's arithmetic operations with added overflow
479  * checks.
480  *
481  * Arithmetic operations in Solidity wrap on overflow. This can easily result
482  * in bugs, because programmers usually assume that an overflow raises an
483  * error, which is the standard behavior in high level programming languages.
484  * `SafeMath` restores this intuition by reverting the transaction when an
485  * operation overflows.
486  *
487  * Using this library instead of the unchecked operations eliminates an entire
488  * class of bugs, so it's recommended to use it always.
489  */
490 library SafeMath {
491     /**
492      * @dev Returns the addition of two unsigned integers, reverting on
493      * overflow.
494      *
495      * Counterpart to Solidity's `+` operator.
496      */
497     function add(uint256 a, uint256 b) internal pure returns (uint256) {
498         uint256 c = a + b;
499         require(c >= a, "SafeMath: addition overflow");
500 
501         return c;
502     }
503 
504     /**
505      * @dev Returns the subtraction of two unsigned integers, reverting on
506      * overflow (when the result is negative).
507      *
508      * Counterpart to Solidity's `-` operator.
509      */
510     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
511         return sub(a, b, "SafeMath: subtraction overflow");
512     }
513 
514     /**
515      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
516      * overflow (when the result is negative).
517      *
518      * Counterpart to Solidity's `-` operator.
519      */
520     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
521         require(b <= a, errorMessage);
522         uint256 c = a - b;
523 
524         return c;
525     }
526 
527     /**
528      * @dev Returns the multiplication of two unsigned integers, reverting on
529      * overflow.
530      *
531      * Counterpart to Solidity's `*` operator.
532      */
533     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
534         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
535         // benefit is lost if 'b' is also tested.
536         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
537         if (a == 0) {
538             return 0;
539         }
540 
541         uint256 c = a * b;
542         require(c / a == b, "SafeMath: multiplication overflow");
543 
544         return c;
545     }
546 
547     /**
548      * @dev Returns the integer division of two unsigned integers. Reverts on
549      * division by zero. The result is rounded towards zero.
550      *
551      * Counterpart to Solidity's `/` operator. Note: this function uses a
552      * `revert` opcode (which leaves remaining gas untouched) while Solidity
553      * uses an invalid opcode to revert (consuming all remaining gas).
554      */
555     function div(uint256 a, uint256 b) internal pure returns (uint256) {
556         return div(a, b, "SafeMath: division by zero");
557     }
558 
559     /**
560      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
561      * division by zero. The result is rounded towards zero.
562      *
563      * Counterpart to Solidity's `/` operator. Note: this function uses a
564      * `revert` opcode (which leaves remaining gas untouched) while Solidity
565      * uses an invalid opcode to revert (consuming all remaining gas).
566      */
567     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
568         require(b > 0, errorMessage);
569         uint256 c = a / b;
570         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
571 
572         return c;
573     }
574 
575     /**
576      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
577      * Reverts when dividing by zero.
578      *
579      * Counterpart to Solidity's `%` operator. This function uses a `revert`
580      * opcode (which leaves remaining gas untouched) while Solidity uses an
581      * invalid opcode to revert (consuming all remaining gas).
582      */
583     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
584         return mod(a, b, "SafeMath: modulo by zero");
585     }
586 
587     /**
588      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
589      * Reverts with custom message when dividing by zero.
590      *
591      * Counterpart to Solidity's `%` operator. This function uses a `revert`
592      * opcode (which leaves remaining gas untouched) while Solidity uses an
593      * invalid opcode to revert (consuming all remaining gas).
594      */
595     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
596         require(b != 0, errorMessage);
597         return a % b;
598     }
599 }
600 
601 contract ShieldEX is ERC20("ShieldEX", "SLD"), Ownable {
602     constructor () public{
603         _mint(_msgSender(), 1000000000 * 1e18);
604     }
605 }