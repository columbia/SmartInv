1 /**
2  *Submitted for verification at Etherscan.io on 2020-03-24
3 */
4 
5 pragma solidity ^0.5.15;
6 
7 // File: @openzeppelin/contracts/utils/Address.sol
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * This test is non-exhaustive, and there may be false-negatives: during the
17      * execution of a contract's constructor, its address will be reported as
18      * not containing a contract.
19      *
20      * IMPORTANT: It is unsafe to assume that an address for which this
21      * function returns false is an externally-owned account (EOA) and not a
22      * contract.
23      */
24     function isContract(address account) internal view returns (bool) {
25         // This method relies in extcodesize, which returns 0 for contracts in
26         // construction, since the code is only stored at the end of the
27         // constructor execution.
28 
29         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
30         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
31         // for accounts without code, i.e. `keccak256('')`
32         bytes32 codehash;
33         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { codehash := extcodehash(account) }
36         return (codehash != 0x0 && codehash != accountHash);
37     }
38 
39     /**
40      * @dev Converts an `address` into `address payable`. Note that this is
41      * simply a type cast: the actual underlying value is not changed.
42      *
43      * _Available since v2.4.0._
44      */
45     function toPayable(address account) internal pure returns (address payable) {
46         return address(uint160(account));
47     }
48 
49     /**
50      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
51      * `recipient`, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by `transfer`, making them unable to receive funds via
56      * `transfer`. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to `recipient`, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      *
65      * _Available since v2.4.0._
66      */
67     function sendValue(address payable recipient, uint256 amount) internal {
68         require(address(this).balance >= amount, "Address: insufficient balance");
69 
70         // solhint-disable-next-line avoid-call-value
71         (bool success, ) = recipient.call.value(amount)("");
72         require(success, "Address: unable to send value, recipient may have reverted");
73     }
74 }
75 
76 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
77 
78 /**
79  * @dev Library used to query support of an interface declared via {IERC165}.
80  *
81  * Note that these functions return the actual result of the query: they do not
82  * `revert` if an interface is not supported. It is up to the caller to decide
83  * what to do in these cases.
84  */
85 library ERC165Checker {
86     // As per the EIP-165 spec, no interface should ever match 0xffffffff
87     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
88 
89     /*
90      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
91      */
92     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
93 
94     /**
95      * @dev Returns true if `account` supports the {IERC165} interface,
96      */
97     function _supportsERC165(address account) internal view returns (bool) {
98         // Any contract that implements ERC165 must explicitly indicate support of
99         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
100         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
101             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
102     }
103 
104     /**
105      * @dev Returns true if `account` supports the interface defined by
106      * `interfaceId`. Support for {IERC165} itself is queried automatically.
107      *
108      * See {IERC165-supportsInterface}.
109      */
110     function _supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
111         // query support of both ERC165 as per the spec and support of _interfaceId
112         return _supportsERC165(account) &&
113             _supportsERC165Interface(account, interfaceId);
114     }
115 
116     /**
117      * @dev Returns true if `account` supports all the interfaces defined in
118      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
119      *
120      * Batch-querying can lead to gas savings by skipping repeated checks for
121      * {IERC165} support.
122      *
123      * See {IERC165-supportsInterface}.
124      */
125     function _supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
126         // query support of ERC165 itself
127         if (!_supportsERC165(account)) {
128             return false;
129         }
130 
131         // query support of each interface in _interfaceIds
132         for (uint256 i = 0; i < interfaceIds.length; i++) {
133             if (!_supportsERC165Interface(account, interfaceIds[i])) {
134                 return false;
135             }
136         }
137 
138         // all interfaces supported
139         return true;
140     }
141 
142     /**
143      * @notice Query if a contract implements an interface, does not check ERC165 support
144      * @param account The address of the contract to query for support of an interface
145      * @param interfaceId The interface identifier, as specified in ERC-165
146      * @return true if the contract at account indicates support of the interface with
147      * identifier interfaceId, false otherwise
148      * @dev Assumes that account contains a contract that supports ERC165, otherwise
149      * the behavior of this method is undefined. This precondition can be checked
150      * with the `supportsERC165` method in this library.
151      * Interface identification is specified in ERC-165.
152      */
153     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
154         // success determines whether the staticcall succeeded and result determines
155         // whether the contract at account indicates support of _interfaceId
156         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
157 
158         return (success && result);
159     }
160 
161     /**
162      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
163      * @param account The address of the contract to query for support of an interface
164      * @param interfaceId The interface identifier, as specified in ERC-165
165      * @return success true if the STATICCALL succeeded, false otherwise
166      * @return result true if the STATICCALL succeeded and the contract at account
167      * indicates support of the interface with identifier interfaceId, false otherwise
168      */
169     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
170         private
171         view
172         returns (bool success, bool result)
173     {
174         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
175 
176         // solhint-disable-next-line no-inline-assembly
177         assembly {
178             let encodedParams_data := add(0x20, encodedParams)
179             let encodedParams_size := mload(encodedParams)
180 
181             let output := mload(0x40)    // Find empty storage location using "free memory pointer"
182             mstore(output, 0x0)
183 
184             success := staticcall(
185                 30000,                   // 30k gas
186                 account,                 // To addr
187                 encodedParams_data,
188                 encodedParams_size,
189                 output,
190                 0x20                     // Outputs are 32 bytes long
191             )
192 
193             result := mload(output)      // Load the result
194         }
195     }
196 }
197 
198 // File: @openzeppelin/contracts/GSN/Context.sol
199 
200 /*
201  * @dev Provides information about the current execution context, including the
202  * sender of the transaction and its data. While these are generally available
203  * via msg.sender and msg.data, they should not be accessed in such a direct
204  * manner, since when dealing with GSN meta-transactions the account sending and
205  * paying for execution may not be the actual sender (as far as an application
206  * is concerned).
207  *
208  * This contract is only required for intermediate, library-like contracts.
209  */
210 contract Context {
211     // Empty internal constructor, to prevent people from mistakenly deploying
212     // an instance of this contract, which should be used via inheritance.
213     constructor () internal { }
214     // solhint-disable-previous-line no-empty-blocks
215 
216     function _msgSender() internal view returns (address payable) {
217         return msg.sender;
218     }
219 
220     function _msgData() internal view returns (bytes memory) {
221         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
222         return msg.data;
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
227 
228 /**
229  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
230  * the optional functions; to access them see {ERC20Detailed}.
231  */
232 interface IERC20 {
233     /**
234      * @dev Returns the amount of tokens in existence.
235      */
236     function totalSupply() external view returns (uint256);
237 
238     /**
239      * @dev Returns the amount of tokens owned by `account`.
240      */
241     function balanceOf(address account) external view returns (uint256);
242 
243     /**
244      * @dev Moves `amount` tokens from the caller's account to `recipient`.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * Emits a {Transfer} event.
249      */
250     function transfer(address recipient, uint256 amount) external returns (bool);
251 
252     /**
253      * @dev Returns the remaining number of tokens that `spender` will be
254      * allowed to spend on behalf of `owner` through {transferFrom}. This is
255      * zero by default.
256      *
257      * This value changes when {approve} or {transferFrom} are called.
258      */
259     function allowance(address owner, address spender) external view returns (uint256);
260 
261     /**
262      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
263      *
264      * Returns a boolean value indicating whether the operation succeeded.
265      *
266      * IMPORTANT: Beware that changing an allowance with this method brings the risk
267      * that someone may use both the old and the new allowance by unfortunate
268      * transaction ordering. One possible solution to mitigate this race
269      * condition is to first reduce the spender's allowance to 0 and set the
270      * desired value afterwards:
271      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
272      *
273      * Emits an {Approval} event.
274      */
275     function approve(address spender, uint256 amount) external returns (bool);
276 
277     /**
278      * @dev Moves `amount` tokens from `sender` to `recipient` using the
279      * allowance mechanism. `amount` is then deducted from the caller's
280      * allowance.
281      *
282      * Returns a boolean value indicating whether the operation succeeded.
283      *
284      * Emits a {Transfer} event.
285      */
286     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
287 
288     /**
289      * @dev Emitted when `value` tokens are moved from one account (`from`) to
290      * another (`to`).
291      *
292      * Note that `value` may be zero.
293      */
294     event Transfer(address indexed from, address indexed to, uint256 value);
295 
296     /**
297      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
298      * a call to {approve}. `value` is the new allowance.
299      */
300     event Approval(address indexed owner, address indexed spender, uint256 value);
301 }
302 
303 // File: @openzeppelin/contracts/math/SafeMath.sol
304 
305 /**
306  * @dev Wrappers over Solidity's arithmetic operations with added overflow
307  * checks.
308  *
309  * Arithmetic operations in Solidity wrap on overflow. This can easily result
310  * in bugs, because programmers usually assume that an overflow raises an
311  * error, which is the standard behavior in high level programming languages.
312  * `SafeMath` restores this intuition by reverting the transaction when an
313  * operation overflows.
314  *
315  * Using this library instead of the unchecked operations eliminates an entire
316  * class of bugs, so it's recommended to use it always.
317  */
318 library SafeMath {
319     /**
320      * @dev Returns the addition of two unsigned integers, reverting on
321      * overflow.
322      *
323      * Counterpart to Solidity's `+` operator.
324      *
325      * Requirements:
326      * - Addition cannot overflow.
327      */
328     function add(uint256 a, uint256 b) internal pure returns (uint256) {
329         uint256 c = a + b;
330         require(c >= a, "SafeMath: addition overflow");
331 
332         return c;
333     }
334 
335     /**
336      * @dev Returns the subtraction of two unsigned integers, reverting on
337      * overflow (when the result is negative).
338      *
339      * Counterpart to Solidity's `-` operator.
340      *
341      * Requirements:
342      * - Subtraction cannot overflow.
343      */
344     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
345         return sub(a, b, "SafeMath: subtraction overflow");
346     }
347 
348     /**
349      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
350      * overflow (when the result is negative).
351      *
352      * Counterpart to Solidity's `-` operator.
353      *
354      * Requirements:
355      * - Subtraction cannot overflow.
356      *
357      * _Available since v2.4.0._
358      */
359     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
360         require(b <= a, errorMessage);
361         uint256 c = a - b;
362 
363         return c;
364     }
365 
366     /**
367      * @dev Returns the multiplication of two unsigned integers, reverting on
368      * overflow.
369      *
370      * Counterpart to Solidity's `*` operator.
371      *
372      * Requirements:
373      * - Multiplication cannot overflow.
374      */
375     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
376         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
377         // benefit is lost if 'b' is also tested.
378         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
379         if (a == 0) {
380             return 0;
381         }
382 
383         uint256 c = a * b;
384         require(c / a == b, "SafeMath: multiplication overflow");
385 
386         return c;
387     }
388 
389     /**
390      * @dev Returns the integer division of two unsigned integers. Reverts on
391      * division by zero. The result is rounded towards zero.
392      *
393      * Counterpart to Solidity's `/` operator. Note: this function uses a
394      * `revert` opcode (which leaves remaining gas untouched) while Solidity
395      * uses an invalid opcode to revert (consuming all remaining gas).
396      *
397      * Requirements:
398      * - The divisor cannot be zero.
399      */
400     function div(uint256 a, uint256 b) internal pure returns (uint256) {
401         return div(a, b, "SafeMath: division by zero");
402     }
403 
404     /**
405      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
406      * division by zero. The result is rounded towards zero.
407      *
408      * Counterpart to Solidity's `/` operator. Note: this function uses a
409      * `revert` opcode (which leaves remaining gas untouched) while Solidity
410      * uses an invalid opcode to revert (consuming all remaining gas).
411      *
412      * Requirements:
413      * - The divisor cannot be zero.
414      *
415      * _Available since v2.4.0._
416      */
417     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
418         // Solidity only automatically asserts when dividing by 0
419         require(b > 0, errorMessage);
420         uint256 c = a / b;
421         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
422 
423         return c;
424     }
425 
426     /**
427      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
428      * Reverts when dividing by zero.
429      *
430      * Counterpart to Solidity's `%` operator. This function uses a `revert`
431      * opcode (which leaves remaining gas untouched) while Solidity uses an
432      * invalid opcode to revert (consuming all remaining gas).
433      *
434      * Requirements:
435      * - The divisor cannot be zero.
436      */
437     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
438         return mod(a, b, "SafeMath: modulo by zero");
439     }
440 
441     /**
442      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
443      * Reverts with custom message when dividing by zero.
444      *
445      * Counterpart to Solidity's `%` operator. This function uses a `revert`
446      * opcode (which leaves remaining gas untouched) while Solidity uses an
447      * invalid opcode to revert (consuming all remaining gas).
448      *
449      * Requirements:
450      * - The divisor cannot be zero.
451      *
452      * _Available since v2.4.0._
453      */
454     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
455         require(b != 0, errorMessage);
456         return a % b;
457     }
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
461 
462 /**
463  * @dev Implementation of the {IERC20} interface.
464  *
465  * This implementation is agnostic to the way tokens are created. This means
466  * that a supply mechanism has to be added in a derived contract using {_mint}.
467  * For a generic mechanism see {ERC20Mintable}.
468  *
469  * TIP: For a detailed writeup see our guide
470  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
471  * to implement supply mechanisms].
472  *
473  * We have followed general OpenZeppelin guidelines: functions revert instead
474  * of returning `false` on failure. This behavior is nonetheless conventional
475  * and does not conflict with the expectations of ERC20 applications.
476  *
477  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
478  * This allows applications to reconstruct the allowance for all accounts just
479  * by listening to said events. Other implementations of the EIP may not emit
480  * these events, as it isn't required by the specification.
481  *
482  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
483  * functions have been added to mitigate the well-known issues around setting
484  * allowances. See {IERC20-approve}.
485  */
486 contract ERC20 is Context, IERC20 {
487     using SafeMath for uint256;
488 
489     mapping (address => uint256) private _balances;
490 
491     mapping (address => mapping (address => uint256)) private _allowances;
492 
493     uint256 private _totalSupply;
494 
495     /**
496      * @dev See {IERC20-totalSupply}.
497      */
498     function totalSupply() public view returns (uint256) {
499         return _totalSupply;
500     }
501 
502     /**
503      * @dev See {IERC20-balanceOf}.
504      */
505     function balanceOf(address account) public view returns (uint256) {
506         return _balances[account];
507     }
508 
509     /**
510      * @dev See {IERC20-transfer}.
511      *
512      * Requirements:
513      *
514      * - `recipient` cannot be the zero address.
515      * - the caller must have a balance of at least `amount`.
516      */
517     function transfer(address recipient, uint256 amount) public returns (bool) {
518         _transfer(_msgSender(), recipient, amount);
519         return true;
520     }
521 
522     /**
523      * @dev See {IERC20-allowance}.
524      */
525     function allowance(address owner, address spender) public view returns (uint256) {
526         return _allowances[owner][spender];
527     }
528 
529     /**
530      * @dev See {IERC20-approve}.
531      *
532      * Requirements:
533      *
534      * - `spender` cannot be the zero address.
535      */
536     function approve(address spender, uint256 amount) public returns (bool) {
537         _approve(_msgSender(), spender, amount);
538         return true;
539     }
540 
541     /**
542      * @dev See {IERC20-transferFrom}.
543      *
544      * Emits an {Approval} event indicating the updated allowance. This is not
545      * required by the EIP. See the note at the beginning of {ERC20};
546      *
547      * Requirements:
548      * - `sender` and `recipient` cannot be the zero address.
549      * - `sender` must have a balance of at least `amount`.
550      * - the caller must have allowance for `sender`'s tokens of at least
551      * `amount`.
552      */
553     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
554         _transfer(sender, recipient, amount);
555         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
556         return true;
557     }
558 
559     /**
560      * @dev Atomically increases the allowance granted to `spender` by the caller.
561      *
562      * This is an alternative to {approve} that can be used as a mitigation for
563      * problems described in {IERC20-approve}.
564      *
565      * Emits an {Approval} event indicating the updated allowance.
566      *
567      * Requirements:
568      *
569      * - `spender` cannot be the zero address.
570      */
571     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
572         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
573         return true;
574     }
575 
576     /**
577      * @dev Atomically decreases the allowance granted to `spender` by the caller.
578      *
579      * This is an alternative to {approve} that can be used as a mitigation for
580      * problems described in {IERC20-approve}.
581      *
582      * Emits an {Approval} event indicating the updated allowance.
583      *
584      * Requirements:
585      *
586      * - `spender` cannot be the zero address.
587      * - `spender` must have allowance for the caller of at least
588      * `subtractedValue`.
589      */
590     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
591         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
592         return true;
593     }
594 
595     /**
596      * @dev Moves tokens `amount` from `sender` to `recipient`.
597      *
598      * This is internal function is equivalent to {transfer}, and can be used to
599      * e.g. implement automatic token fees, slashing mechanisms, etc.
600      *
601      * Emits a {Transfer} event.
602      *
603      * Requirements:
604      *
605      * - `sender` cannot be the zero address.
606      * - `recipient` cannot be the zero address.
607      * - `sender` must have a balance of at least `amount`.
608      */
609     function _transfer(address sender, address recipient, uint256 amount) internal {
610         require(sender != address(0), "ERC20: transfer from the zero address");
611         require(recipient != address(0), "ERC20: transfer to the zero address");
612 
613         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
614         _balances[recipient] = _balances[recipient].add(amount);
615         emit Transfer(sender, recipient, amount);
616     }
617 
618     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
619      * the total supply.
620      *
621      * Emits a {Transfer} event with `from` set to the zero address.
622      *
623      * Requirements
624      *
625      * - `to` cannot be the zero address.
626      */
627     function _mint(address account, uint256 amount) internal {
628         require(account != address(0), "ERC20: mint to the zero address");
629 
630         _totalSupply = _totalSupply.add(amount);
631         _balances[account] = _balances[account].add(amount);
632         emit Transfer(address(0), account, amount);
633     }
634 
635      /**
636      * @dev Destroys `amount` tokens from `account`, reducing the
637      * total supply.
638      *
639      * Emits a {Transfer} event with `to` set to the zero address.
640      *
641      * Requirements
642      *
643      * - `account` cannot be the zero address.
644      * - `account` must have at least `amount` tokens.
645      */
646     function _burn(address account, uint256 amount) internal {
647         require(account != address(0), "ERC20: burn from the zero address");
648 
649         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
650         _totalSupply = _totalSupply.sub(amount);
651         emit Transfer(account, address(0), amount);
652     }
653 
654     /**
655      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
656      *
657      * This is internal function is equivalent to `approve`, and can be used to
658      * e.g. set automatic allowances for certain subsystems, etc.
659      *
660      * Emits an {Approval} event.
661      *
662      * Requirements:
663      *
664      * - `owner` cannot be the zero address.
665      * - `spender` cannot be the zero address.
666      */
667     function _approve(address owner, address spender, uint256 amount) internal {
668         require(owner != address(0), "ERC20: approve from the zero address");
669         require(spender != address(0), "ERC20: approve to the zero address");
670 
671         _allowances[owner][spender] = amount;
672         emit Approval(owner, spender, amount);
673     }
674 
675     /**
676      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
677      * from the caller's allowance.
678      *
679      * See {_burn} and {_approve}.
680      */
681     function _burnFrom(address account, uint256 amount) internal {
682         _burn(account, amount);
683         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
684     }
685 }
686 
687 // File: @openzeppelin/contracts/introspection/IERC165.sol
688 
689 /**
690  * @dev Interface of the ERC165 standard, as defined in the
691  * https://eips.ethereum.org/EIPS/eip-165[EIP].
692  *
693  * Implementers can declare support of contract interfaces, which can then be
694  * queried by others ({ERC165Checker}).
695  *
696  * For an implementation, see {ERC165}.
697  */
698 interface IERC165 {
699     /**
700      * @dev Returns true if this contract implements the interface defined by
701      * `interfaceId`. See the corresponding
702      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
703      * to learn more about how these ids are created.
704      *
705      * This function call must use less than 30 000 gas.
706      */
707     function supportsInterface(bytes4 interfaceId) external view returns (bool);
708 }
709 
710 // File: @openzeppelin/contracts/introspection/ERC165.sol
711 
712 /**
713  * @dev Implementation of the {IERC165} interface.
714  *
715  * Contracts may inherit from this and call {_registerInterface} to declare
716  * their support of an interface.
717  */
718 contract ERC165 is IERC165 {
719     /*
720      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
721      */
722     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
723 
724     /**
725      * @dev Mapping of interface ids to whether or not it's supported.
726      */
727     mapping(bytes4 => bool) private _supportedInterfaces;
728 
729     constructor () internal {
730         // Derived contracts need only register support for their own interfaces,
731         // we register support for ERC165 itself here
732         _registerInterface(_INTERFACE_ID_ERC165);
733     }
734 
735     /**
736      * @dev See {IERC165-supportsInterface}.
737      *
738      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
739      */
740     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
741         return _supportedInterfaces[interfaceId];
742     }
743 
744     /**
745      * @dev Registers the contract as an implementer of the interface defined by
746      * `interfaceId`. Support of the actual ERC165 interface is automatic and
747      * registering its interface id is not required.
748      *
749      * See {IERC165-supportsInterface}.
750      *
751      * Requirements:
752      *
753      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
754      */
755     function _registerInterface(bytes4 interfaceId) internal {
756         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
757         _supportedInterfaces[interfaceId] = true;
758     }
759 }
760 
761 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
762 
763 /**
764  * @title IERC1363 Interface
765  * @author Vittorio Minacori (https://github.com/vittominacori)
766  * @dev Interface for a Payable Token contract as defined in
767  *  https://github.com/ethereum/EIPs/issues/1363
768  */
769 contract IERC1363 is IERC20, ERC165 {
770     /*
771      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
772      * 0x4bbee2df ===
773      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
774      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
775      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
776      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
777      */
778 
779     /*
780      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
781      * 0xfb9ec8ce ===
782      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
783      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
784      */
785 
786     /**
787      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
788      * @param to address The address which you want to transfer to
789      * @param value uint256 The amount of tokens to be transferred
790      * @return true unless throwing
791      */
792     function transferAndCall(address to, uint256 value) public returns (bool);
793 
794     /**
795      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
796      * @param to address The address which you want to transfer to
797      * @param value uint256 The amount of tokens to be transferred
798      * @param data bytes Additional data with no specified format, sent in call to `to`
799      * @return true unless throwing
800      */
801     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool);
802 
803     /**
804      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
805      * @param from address The address which you want to send tokens from
806      * @param to address The address which you want to transfer to
807      * @param value uint256 The amount of tokens to be transferred
808      * @return true unless throwing
809      */
810     function transferFromAndCall(address from, address to, uint256 value) public returns (bool);
811 
812 
813     /**
814      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
815      * @param from address The address which you want to send tokens from
816      * @param to address The address which you want to transfer to
817      * @param value uint256 The amount of tokens to be transferred
818      * @param data bytes Additional data with no specified format, sent in call to `to`
819      * @return true unless throwing
820      */
821     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool);
822 
823     /**
824      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
825      * and then call `onApprovalReceived` on spender.
826      * Beware that changing an allowance with this method brings the risk that someone may use both the old
827      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
828      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
829      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
830      * @param spender address The address which will spend the funds
831      * @param value uint256 The amount of tokens to be spent
832      */
833     function approveAndCall(address spender, uint256 value) public returns (bool);
834 
835     /**
836      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
837      * and then call `onApprovalReceived` on spender.
838      * Beware that changing an allowance with this method brings the risk that someone may use both the old
839      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
840      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
841      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
842      * @param spender address The address which will spend the funds
843      * @param value uint256 The amount of tokens to be spent
844      * @param data bytes Additional data with no specified format, sent in call to `spender`
845      */
846     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool);
847 }
848 
849 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
850 
851 /**
852  * @title IERC1363Receiver Interface
853  * @author Vittorio Minacori (https://github.com/vittominacori)
854  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
855  *  from ERC1363 token contracts as defined in
856  *  https://github.com/ethereum/EIPs/issues/1363
857  */
858 contract IERC1363Receiver {
859     /*
860      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
861      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
862      */
863 
864     /**
865      * @notice Handle the receipt of ERC1363 tokens
866      * @dev Any ERC1363 smart contract calls this function on the recipient
867      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
868      * transfer. Return of other than the magic value MUST result in the
869      * transaction being reverted.
870      * Note: the token contract address is always the message sender.
871      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
872      * @param from address The address which are token transferred from
873      * @param value uint256 The amount of tokens transferred
874      * @param data bytes Additional data with no specified format
875      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
876      *  unless throwing
877      */
878     function onTransferReceived(address operator, address from, uint256 value, bytes memory data) public returns (bytes4); // solhint-disable-line  max-line-length
879 }
880 
881 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
882 
883 /**
884  * @title IERC1363Spender Interface
885  * @author Vittorio Minacori (https://github.com/vittominacori)
886  * @dev Interface for any contract that wants to support approveAndCall
887  *  from ERC1363 token contracts as defined in
888  *  https://github.com/ethereum/EIPs/issues/1363
889  */
890 contract IERC1363Spender {
891     /*
892      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
893      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
894      */
895 
896     /**
897      * @notice Handle the approval of ERC1363 tokens
898      * @dev Any ERC1363 smart contract calls this function on the recipient
899      * after an `approve`. This function MAY throw to revert and reject the
900      * approval. Return of other than the magic value MUST result in the
901      * transaction being reverted.
902      * Note: the token contract address is always the message sender.
903      * @param owner address The address which called `approveAndCall` function
904      * @param value uint256 The amount of tokens to be spent
905      * @param data bytes Additional data with no specified format
906      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
907      *  unless throwing
908      */
909     function onApprovalReceived(address owner, uint256 value, bytes memory data) public returns (bytes4);
910 }
911 
912 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
913 
914 /**
915  * @title ERC1363
916  * @author Vittorio Minacori (https://github.com/vittominacori)
917  * @dev Implementation of an ERC1363 interface
918  */
919 contract ERC1363 is ERC20, IERC1363 {
920     using Address for address;
921 
922     /*
923      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
924      * 0x4bbee2df ===
925      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
926      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
927      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
928      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
929      */
930     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
931 
932     /*
933      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
934      * 0xfb9ec8ce ===
935      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
936      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
937      */
938     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
939 
940     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
941     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
942     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
943 
944     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
945     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
946     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
947 
948     constructor() public {
949         // register the supported interfaces to conform to ERC1363 via ERC165
950         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
951         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
952     }
953 
954     function transferAndCall(address to, uint256 value) public returns (bool) {
955         return transferAndCall(to, value, "");
956     }
957 
958     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool) {
959         require(transfer(to, value));
960         require(_checkAndCallTransfer(msg.sender, to, value, data));
961         return true;
962     }
963 
964     function transferFromAndCall(address from, address to, uint256 value) public returns (bool) {
965         return transferFromAndCall(from, to, value, "");
966     }
967 
968     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool) {
969         require(transferFrom(from, to, value));
970         require(_checkAndCallTransfer(from, to, value, data));
971         return true;
972     }
973 
974     function approveAndCall(address spender, uint256 value) public returns (bool) {
975         return approveAndCall(spender, value, "");
976     }
977 
978     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool) {
979         approve(spender, value);
980         require(_checkAndCallApprove(spender, value, data));
981         return true;
982     }
983 
984     /**
985      * @dev Internal function to invoke `onTransferReceived` on a target address
986      *  The call is not executed if the target address is not a contract
987      * @param from address Representing the previous owner of the given token value
988      * @param to address Target address that will receive the tokens
989      * @param value uint256 The amount mount of tokens to be transferred
990      * @param data bytes Optional data to send along with the call
991      * @return whether the call correctly returned the expected magic value
992      */
993     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
994         if (!to.isContract()) {
995             return false;
996         }
997         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
998             msg.sender, from, value, data
999         );
1000         return (retval == _ERC1363_RECEIVED);
1001     }
1002 
1003     /**
1004      * @dev Internal function to invoke `onApprovalReceived` on a target address
1005      *  The call is not executed if the target address is not a contract
1006      * @param spender address The address which will spend the funds
1007      * @param value uint256 The amount of tokens to be spent
1008      * @param data bytes Optional data to send along with the call
1009      * @return whether the call correctly returned the expected magic value
1010      */
1011     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
1012         if (!spender.isContract()) {
1013             return false;
1014         }
1015         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1016             msg.sender, value, data
1017         );
1018         return (retval == _ERC1363_APPROVED);
1019     }
1020 }
1021 
1022 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
1023 
1024 /**
1025  * @dev Optional functions from the ERC20 standard.
1026  */
1027 contract ERC20Detailed is IERC20 {
1028     string private _name;
1029     string private _symbol;
1030     uint8 private _decimals;
1031 
1032     /**
1033      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1034      * these values are immutable: they can only be set once during
1035      * construction.
1036      */
1037     constructor (string memory name, string memory symbol, uint8 decimals) public {
1038         _name = name;
1039         _symbol = symbol;
1040         _decimals = decimals;
1041     }
1042 
1043     /**
1044      * @dev Returns the name of the token.
1045      */
1046     function name() public view returns (string memory) {
1047         return _name;
1048     }
1049 
1050     /**
1051      * @dev Returns the symbol of the token, usually a shorter version of the
1052      * name.
1053      */
1054     function symbol() public view returns (string memory) {
1055         return _symbol;
1056     }
1057 
1058     /**
1059      * @dev Returns the number of decimals used to get its user representation.
1060      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1061      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1062      *
1063      * Tokens usually opt for a value of 18, imitating the relationship between
1064      * Ether and Wei.
1065      *
1066      * NOTE: This information is only used for _display_ purposes: it in
1067      * no way affects any of the arithmetic of the contract, including
1068      * {IERC20-balanceOf} and {IERC20-transfer}.
1069      */
1070     function decimals() public view returns (uint8) {
1071         return _decimals;
1072     }
1073 }
1074 
1075 // File: @openzeppelin/contracts/access/Roles.sol
1076 
1077 /**
1078  * @title Roles
1079  * @dev Library for managing addresses assigned to a Role.
1080  */
1081 library Roles {
1082     struct Role {
1083         mapping (address => bool) bearer;
1084     }
1085 
1086     /**
1087      * @dev Give an account access to this role.
1088      */
1089     function add(Role storage role, address account) internal {
1090         require(!has(role, account), "Roles: account already has role");
1091         role.bearer[account] = true;
1092     }
1093 
1094     /**
1095      * @dev Remove an account's access to this role.
1096      */
1097     function remove(Role storage role, address account) internal {
1098         require(has(role, account), "Roles: account does not have role");
1099         role.bearer[account] = false;
1100     }
1101 
1102     /**
1103      * @dev Check if an account has this role.
1104      * @return bool
1105      */
1106     function has(Role storage role, address account) internal view returns (bool) {
1107         require(account != address(0), "Roles: account is the zero address");
1108         return role.bearer[account];
1109     }
1110 }
1111 
1112 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
1113 
1114 contract MinterRole is Context {
1115     using Roles for Roles.Role;
1116 
1117     event MinterAdded(address indexed account);
1118     event MinterRemoved(address indexed account);
1119 
1120     Roles.Role private _minters;
1121 
1122     constructor () internal {
1123         _addMinter(_msgSender());
1124     }
1125 
1126     modifier onlyMinter() {
1127         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1128         _;
1129     }
1130 
1131     function isMinter(address account) public view returns (bool) {
1132         return _minters.has(account);
1133     }
1134 
1135     function addMinter(address account) public onlyMinter {
1136         _addMinter(account);
1137     }
1138 
1139     function renounceMinter() public {
1140         _removeMinter(_msgSender());
1141     }
1142 
1143     function _addMinter(address account) internal {
1144         _minters.add(account);
1145         emit MinterAdded(account);
1146     }
1147 
1148     function _removeMinter(address account) internal {
1149         _minters.remove(account);
1150         emit MinterRemoved(account);
1151     }
1152 }
1153 
1154 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
1155 
1156 /**
1157  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1158  * which have permission to mint (create) new tokens as they see fit.
1159  *
1160  * At construction, the deployer of the contract is the only minter.
1161  */
1162 contract ERC20Mintable is ERC20, MinterRole {
1163     /**
1164      * @dev See {ERC20-_mint}.
1165      *
1166      * Requirements:
1167      *
1168      * - the caller must have the {MinterRole}.
1169      */
1170     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1171         _mint(account, amount);
1172         return true;
1173     }
1174 }
1175 
1176 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
1177 
1178 /**
1179  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
1180  */
1181 contract ERC20Capped is ERC20Mintable {
1182     uint256 private _cap;
1183 
1184     /**
1185      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1186      * set once during construction.
1187      */
1188     constructor (uint256 cap) public {
1189         require(cap > 0, "ERC20Capped: cap is 0");
1190         _cap = cap;
1191     }
1192 
1193     /**
1194      * @dev Returns the cap on the token's total supply.
1195      */
1196     function cap() public view returns (uint256) {
1197         return _cap;
1198     }
1199 
1200     /**
1201      * @dev See {ERC20Mintable-mint}.
1202      *
1203      * Requirements:
1204      *
1205      * - `value` must not cause the total supply to go over the cap.
1206      */
1207     function _mint(address account, uint256 value) internal {
1208         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
1209         super._mint(account, value);
1210     }
1211 }
1212 
1213 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1214 
1215 /**
1216  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1217  * tokens and those that they have an allowance for, in a way that can be
1218  * recognized off-chain (via event analysis).
1219  */
1220 contract ERC20Burnable is Context, ERC20 {
1221     /**
1222      * @dev Destroys `amount` tokens from the caller.
1223      *
1224      * See {ERC20-_burn}.
1225      */
1226     function burn(uint256 amount) public {
1227         _burn(_msgSender(), amount);
1228     }
1229 
1230     /**
1231      * @dev See {ERC20-_burnFrom}.
1232      */
1233     function burnFrom(address account, uint256 amount) public {
1234         _burnFrom(account, amount);
1235     }
1236 }
1237 
1238 // File: @openzeppelin/contracts/ownership/Ownable.sol
1239 
1240 /**
1241  * @dev Contract module which provides a basic access control mechanism, where
1242  * there is an account (an owner) that can be granted exclusive access to
1243  * specific functions.
1244  *
1245  * This module is used through inheritance. It will make available the modifier
1246  * `onlyOwner`, which can be applied to your functions to restrict their use to
1247  * the owner.
1248  */
1249 contract Ownable is Context {
1250     address private _owner;
1251 
1252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1253 
1254     /**
1255      * @dev Initializes the contract setting the deployer as the initial owner.
1256      */
1257     constructor () internal {
1258         _owner = _msgSender();
1259         emit OwnershipTransferred(address(0), _owner);
1260     }
1261 
1262     /**
1263      * @dev Returns the address of the current owner.
1264      */
1265     function owner() public view returns (address) {
1266         return _owner;
1267     }
1268 
1269     /**
1270      * @dev Throws if called by any account other than the owner.
1271      */
1272     modifier onlyOwner() {
1273         require(isOwner(), "Ownable: caller is not the owner");
1274         _;
1275     }
1276 
1277     /**
1278      * @dev Returns true if the caller is the current owner.
1279      */
1280     function isOwner() public view returns (bool) {
1281         return _msgSender() == _owner;
1282     }
1283 
1284     /**
1285      * @dev Leaves the contract without owner. It will not be possible to call
1286      * `onlyOwner` functions anymore. Can only be called by the current owner.
1287      *
1288      * NOTE: Renouncing ownership will leave the contract without an owner,
1289      * thereby removing any functionality that is only available to the owner.
1290      */
1291     function renounceOwnership() public onlyOwner {
1292         emit OwnershipTransferred(_owner, address(0));
1293         _owner = address(0);
1294     }
1295 
1296     /**
1297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1298      * Can only be called by the current owner.
1299      */
1300     function transferOwnership(address newOwner) public onlyOwner {
1301         _transferOwnership(newOwner);
1302     }
1303 
1304     /**
1305      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1306      */
1307     function _transferOwnership(address newOwner) internal {
1308         require(newOwner != address(0), "Ownable: new owner is the zero address");
1309         emit OwnershipTransferred(_owner, newOwner);
1310         _owner = newOwner;
1311     }
1312 }
1313 
1314 // File: eth-token-recover/contracts/TokenRecover.sol
1315 
1316 /**
1317  * @title TokenRecover
1318  * @author Vittorio Minacori (https://github.com/vittominacori)
1319  * @dev Allow to recover any ERC20 sent into the contract for error
1320  */
1321 contract TokenRecover is Ownable {
1322 
1323     /**
1324      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1325      * @param tokenAddress The token contract address
1326      * @param tokenAmount Number of tokens to be sent
1327      */
1328     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1329         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1330     }
1331 }
1332 
1333 // File: ico-maker/contracts/access/roles/OperatorRole.sol
1334 
1335 contract OperatorRole {
1336     using Roles for Roles.Role;
1337 
1338     event OperatorAdded(address indexed account);
1339     event OperatorRemoved(address indexed account);
1340 
1341     Roles.Role private _operators;
1342 
1343     constructor() internal {
1344         _addOperator(msg.sender);
1345     }
1346 
1347     modifier onlyOperator() {
1348         require(isOperator(msg.sender));
1349         _;
1350     }
1351 
1352     function isOperator(address account) public view returns (bool) {
1353         return _operators.has(account);
1354     }
1355 
1356     function addOperator(address account) public onlyOperator {
1357         _addOperator(account);
1358     }
1359 
1360     function renounceOperator() public {
1361         _removeOperator(msg.sender);
1362     }
1363 
1364     function _addOperator(address account) internal {
1365         _operators.add(account);
1366         emit OperatorAdded(account);
1367     }
1368 
1369     function _removeOperator(address account) internal {
1370         _operators.remove(account);
1371         emit OperatorRemoved(account);
1372     }
1373 }
1374 
1375 // File: ico-maker/contracts/token/ERC20/BaseERC20Token.sol
1376 
1377 /**
1378  * @title BaseERC20Token
1379  * @author Vittorio Minacori (https://github.com/vittominacori)
1380  * @dev Implementation of the BaseERC20Token
1381  */
1382 contract BaseERC20Token is ERC20Detailed, ERC20Capped, ERC20Burnable, OperatorRole, TokenRecover {
1383 
1384     event MintFinished();
1385     event TransferEnabled();
1386 
1387     // indicates if minting is finished
1388     bool private _mintingFinished = false;
1389 
1390     // indicates if transfer is enabled
1391     bool private _transferEnabled = false;
1392 
1393     /**
1394      * @dev Tokens can be minted only before minting finished.
1395      */
1396     modifier canMint() {
1397         require(!_mintingFinished);
1398         _;
1399     }
1400 
1401     /**
1402      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1403      */
1404     modifier canTransfer(address from) {
1405         require(_transferEnabled || isOperator(from));
1406         _;
1407     }
1408 
1409     /**
1410      * @param name Name of the token
1411      * @param symbol A symbol to be used as ticker
1412      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1413      * @param cap Maximum number of tokens mintable
1414      * @param initialSupply Initial token supply
1415      */
1416     constructor(
1417         string memory name,
1418         string memory symbol,
1419         uint8 decimals,
1420         uint256 cap,
1421         uint256 initialSupply
1422     )
1423         public
1424         ERC20Detailed(name, symbol, decimals)
1425         ERC20Capped(cap)
1426     {
1427         if (initialSupply > 0) {
1428             _mint(owner(), initialSupply);
1429         }
1430     }
1431 
1432     /**
1433      * @return if minting is finished or not.
1434      */
1435     function mintingFinished() public view returns (bool) {
1436         return _mintingFinished;
1437     }
1438 
1439     /**
1440      * @return if transfer is enabled or not.
1441      */
1442     function transferEnabled() public view returns (bool) {
1443         return _transferEnabled;
1444     }
1445 
1446     /**
1447      * @dev Function to mint tokens
1448      * @param to The address that will receive the minted tokens.
1449      * @param value The amount of tokens to mint.
1450      * @return A boolean that indicates if the operation was successful.
1451      */
1452     function mint(address to, uint256 value) public canMint returns (bool) {
1453         return super.mint(to, value);
1454     }
1455 
1456     /**
1457      * @dev Transfer token to a specified address
1458      * @param to The address to transfer to.
1459      * @param value The amount to be transferred.
1460      * @return A boolean that indicates if the operation was successful.
1461      */
1462     function transfer(address to, uint256 value) public canTransfer(msg.sender) returns (bool) {
1463         return super.transfer(to, value);
1464     }
1465 
1466     /**
1467      * @dev Transfer tokens from one address to another.
1468      * @param from address The address which you want to send tokens from
1469      * @param to address The address which you want to transfer to
1470      * @param value uint256 the amount of tokens to be transferred
1471      * @return A boolean that indicates if the operation was successful.
1472      */
1473     function transferFrom(address from, address to, uint256 value) public canTransfer(from) returns (bool) {
1474         return super.transferFrom(from, to, value);
1475     }
1476 
1477     /**
1478      * @dev Function to stop minting new tokens.
1479      */
1480     function finishMinting() public onlyOwner canMint {
1481         _mintingFinished = true;
1482 
1483         emit MintFinished();
1484     }
1485 
1486     /**
1487    * @dev Function to enable transfers.
1488    */
1489     function enableTransfer() public onlyOwner {
1490         _transferEnabled = true;
1491 
1492         emit TransferEnabled();
1493     }
1494 
1495     /**
1496      * @dev remove the `operator` role from address
1497      * @param account Address you want to remove role
1498      */
1499     function removeOperator(address account) public onlyOwner {
1500         _removeOperator(account);
1501     }
1502 
1503     /**
1504      * @dev remove the `minter` role from address
1505      * @param account Address you want to remove role
1506      */
1507     function removeMinter(address account) public onlyOwner {
1508         _removeMinter(account);
1509     }
1510 }
1511 
1512 // File: ico-maker/contracts/token/ERC1363/BaseERC1363Token.sol
1513 
1514 /**
1515  * @title BaseERC1363Token
1516  * @author Vittorio Minacori (https://github.com/vittominacori)
1517  * @dev Implementation of the BaseERC20Token with ERC1363 behaviours
1518  */
1519 contract BaseERC1363Token is BaseERC20Token, ERC1363 {
1520 
1521     /**
1522      * @param name Name of the token
1523      * @param symbol A symbol to be used as ticker
1524      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1525      * @param cap Maximum number of tokens mintable
1526      * @param initialSupply Initial token supply
1527      */
1528     constructor(
1529         string memory name,
1530         string memory symbol,
1531         uint8 decimals,
1532         uint256 cap,
1533         uint256 initialSupply
1534     )
1535         public
1536         BaseERC20Token(name, symbol, decimals, cap, initialSupply)
1537     {} // solhint-disable-line no-empty-blocks
1538 }
1539 
1540 // File: contracts/ERC20Token.sol
1541 
1542 /**
1543  * @title ERC20Token
1544  * @author Vittorio Minacori (https://github.com/vittominacori)
1545  * @dev Implementation of a BaseERC1363Token
1546  */
1547 contract ERC20Token is BaseERC1363Token {
1548 
1549     string public project = "BlackFortWalletExchange";
1550     string public availableOn = "https://blackfort.exchange";
1551 
1552     constructor(
1553         string memory name,
1554         string memory symbol,
1555         uint8 decimals,
1556         uint256 cap,
1557         uint256 initialSupply,
1558         bool transferEnabled
1559     )
1560         public
1561         BaseERC1363Token(name, symbol, decimals, cap, initialSupply)
1562     {
1563         if (transferEnabled) {
1564             enableTransfer();
1565         }
1566     }
1567 }