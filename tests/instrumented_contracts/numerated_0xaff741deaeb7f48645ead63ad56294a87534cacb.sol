1 pragma solidity ^0.5.15;
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * This test is non-exhaustive, and there may be false-negatives: during the
13      * execution of a contract's constructor, its address will be reported as
14      * not containing a contract.
15      *
16      * IMPORTANT: It is unsafe to assume that an address for which this
17      * function returns false is an externally-owned account (EOA) and not a
18      * contract.
19      */
20     function isContract(address account) internal view returns (bool) {
21         // This method relies in extcodesize, which returns 0 for contracts in
22         // construction, since the code is only stored at the end of the
23         // constructor execution.
24 
25         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
26         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
27         // for accounts without code, i.e. `keccak256('')`
28         bytes32 codehash;
29         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
30         // solhint-disable-next-line no-inline-assembly
31         assembly { codehash := extcodehash(account) }
32         return (codehash != 0x0 && codehash != accountHash);
33     }
34 
35     /**
36      * @dev Converts an `address` into `address payable`. Note that this is
37      * simply a type cast: the actual underlying value is not changed.
38      *
39      * _Available since v2.4.0._
40      */
41     function toPayable(address account) internal pure returns (address payable) {
42         return address(uint160(account));
43     }
44 
45     /**
46      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
47      * `recipient`, forwarding all available gas and reverting on errors.
48      *
49      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
50      * of certain opcodes, possibly making contracts go over the 2300 gas limit
51      * imposed by `transfer`, making them unable to receive funds via
52      * `transfer`. {sendValue} removes this limitation.
53      *
54      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
55      *
56      * IMPORTANT: because control is transferred to `recipient`, care must be
57      * taken to not create reentrancy vulnerabilities. Consider using
58      * {ReentrancyGuard} or the
59      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
60      *
61      * _Available since v2.4.0._
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         // solhint-disable-next-line avoid-call-value
67         (bool success, ) = recipient.call.value(amount)("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 }
71 
72 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
73 
74 /**
75  * @dev Library used to query support of an interface declared via {IERC165}.
76  *
77  * Note that these functions return the actual result of the query: they do not
78  * `revert` if an interface is not supported. It is up to the caller to decide
79  * what to do in these cases.
80  */
81 library ERC165Checker {
82     // As per the EIP-165 spec, no interface should ever match 0xffffffff
83     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
84 
85     /*
86      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
87      */
88     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
89 
90     /**
91      * @dev Returns true if `account` supports the {IERC165} interface,
92      */
93     function _supportsERC165(address account) internal view returns (bool) {
94         // Any contract that implements ERC165 must explicitly indicate support of
95         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
96         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
97             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
98     }
99 
100     /**
101      * @dev Returns true if `account` supports the interface defined by
102      * `interfaceId`. Support for {IERC165} itself is queried automatically.
103      *
104      * See {IERC165-supportsInterface}.
105      */
106     function _supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
107         // query support of both ERC165 as per the spec and support of _interfaceId
108         return _supportsERC165(account) &&
109             _supportsERC165Interface(account, interfaceId);
110     }
111 
112     /**
113      * @dev Returns true if `account` supports all the interfaces defined in
114      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
115      *
116      * Batch-querying can lead to gas savings by skipping repeated checks for
117      * {IERC165} support.
118      *
119      * See {IERC165-supportsInterface}.
120      */
121     function _supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
122         // query support of ERC165 itself
123         if (!_supportsERC165(account)) {
124             return false;
125         }
126 
127         // query support of each interface in _interfaceIds
128         for (uint256 i = 0; i < interfaceIds.length; i++) {
129             if (!_supportsERC165Interface(account, interfaceIds[i])) {
130                 return false;
131             }
132         }
133 
134         // all interfaces supported
135         return true;
136     }
137 
138     /**
139      * @notice Query if a contract implements an interface, does not check ERC165 support
140      * @param account The address of the contract to query for support of an interface
141      * @param interfaceId The interface identifier, as specified in ERC-165
142      * @return true if the contract at account indicates support of the interface with
143      * identifier interfaceId, false otherwise
144      * @dev Assumes that account contains a contract that supports ERC165, otherwise
145      * the behavior of this method is undefined. This precondition can be checked
146      * with the `supportsERC165` method in this library.
147      * Interface identification is specified in ERC-165.
148      */
149     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
150         // success determines whether the staticcall succeeded and result determines
151         // whether the contract at account indicates support of _interfaceId
152         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
153 
154         return (success && result);
155     }
156 
157     /**
158      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
159      * @param account The address of the contract to query for support of an interface
160      * @param interfaceId The interface identifier, as specified in ERC-165
161      * @return success true if the STATICCALL succeeded, false otherwise
162      * @return result true if the STATICCALL succeeded and the contract at account
163      * indicates support of the interface with identifier interfaceId, false otherwise
164      */
165     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
166         private
167         view
168         returns (bool success, bool result)
169     {
170         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
171 
172         // solhint-disable-next-line no-inline-assembly
173         assembly {
174             let encodedParams_data := add(0x20, encodedParams)
175             let encodedParams_size := mload(encodedParams)
176 
177             let output := mload(0x40)    // Find empty storage location using "free memory pointer"
178             mstore(output, 0x0)
179 
180             success := staticcall(
181                 30000,                   // 30k gas
182                 account,                 // To addr
183                 encodedParams_data,
184                 encodedParams_size,
185                 output,
186                 0x20                     // Outputs are 32 bytes long
187             )
188 
189             result := mload(output)      // Load the result
190         }
191     }
192 }
193 
194 // File: @openzeppelin/contracts/GSN/Context.sol
195 
196 /*
197  * @dev Provides information about the current execution context, including the
198  * sender of the transaction and its data. While these are generally available
199  * via msg.sender and msg.data, they should not be accessed in such a direct
200  * manner, since when dealing with GSN meta-transactions the account sending and
201  * paying for execution may not be the actual sender (as far as an application
202  * is concerned).
203  *
204  * This contract is only required for intermediate, library-like contracts.
205  */
206 contract Context {
207     // Empty internal constructor, to prevent people from mistakenly deploying
208     // an instance of this contract, which should be used via inheritance.
209     constructor () internal { }
210     // solhint-disable-previous-line no-empty-blocks
211 
212     function _msgSender() internal view returns (address payable) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view returns (bytes memory) {
217         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
218         return msg.data;
219     }
220 }
221 
222 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
223 
224 /**
225  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
226  * the optional functions; to access them see {ERC20Detailed}.
227  */
228 interface IERC20 {
229     /**
230      * @dev Returns the amount of tokens in existence.
231      */
232     function totalSupply() external view returns (uint256);
233 
234     /**
235      * @dev Returns the amount of tokens owned by `account`.
236      */
237     function balanceOf(address account) external view returns (uint256);
238 
239     /**
240      * @dev Moves `amount` tokens from the caller's account to `recipient`.
241      *
242      * Returns a boolean value indicating whether the operation succeeded.
243      *
244      * Emits a {Transfer} event.
245      */
246     function transfer(address recipient, uint256 amount) external returns (bool);
247 
248     /**
249      * @dev Returns the remaining number of tokens that `spender` will be
250      * allowed to spend on behalf of `owner` through {transferFrom}. This is
251      * zero by default.
252      *
253      * This value changes when {approve} or {transferFrom} are called.
254      */
255     function allowance(address owner, address spender) external view returns (uint256);
256 
257     /**
258      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
259      *
260      * Returns a boolean value indicating whether the operation succeeded.
261      *
262      * IMPORTANT: Beware that changing an allowance with this method brings the risk
263      * that someone may use both the old and the new allowance by unfortunate
264      * transaction ordering. One possible solution to mitigate this race
265      * condition is to first reduce the spender's allowance to 0 and set the
266      * desired value afterwards:
267      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268      *
269      * Emits an {Approval} event.
270      */
271     function approve(address spender, uint256 amount) external returns (bool);
272 
273     /**
274      * @dev Moves `amount` tokens from `sender` to `recipient` using the
275      * allowance mechanism. `amount` is then deducted from the caller's
276      * allowance.
277      *
278      * Returns a boolean value indicating whether the operation succeeded.
279      *
280      * Emits a {Transfer} event.
281      */
282     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
283 
284     /**
285      * @dev Emitted when `value` tokens are moved from one account (`from`) to
286      * another (`to`).
287      *
288      * Note that `value` may be zero.
289      */
290     event Transfer(address indexed from, address indexed to, uint256 value);
291 
292     /**
293      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
294      * a call to {approve}. `value` is the new allowance.
295      */
296     event Approval(address indexed owner, address indexed spender, uint256 value);
297 }
298 
299 // File: @openzeppelin/contracts/math/SafeMath.sol
300 
301 /**
302  * @dev Wrappers over Solidity's arithmetic operations with added overflow
303  * checks.
304  *
305  * Arithmetic operations in Solidity wrap on overflow. This can easily result
306  * in bugs, because programmers usually assume that an overflow raises an
307  * error, which is the standard behavior in high level programming languages.
308  * `SafeMath` restores this intuition by reverting the transaction when an
309  * operation overflows.
310  *
311  * Using this library instead of the unchecked operations eliminates an entire
312  * class of bugs, so it's recommended to use it always.
313  */
314 library SafeMath {
315     /**
316      * @dev Returns the addition of two unsigned integers, reverting on
317      * overflow.
318      *
319      * Counterpart to Solidity's `+` operator.
320      *
321      * Requirements:
322      * - Addition cannot overflow.
323      */
324     function add(uint256 a, uint256 b) internal pure returns (uint256) {
325         uint256 c = a + b;
326         require(c >= a, "SafeMath: addition overflow");
327 
328         return c;
329     }
330 
331     /**
332      * @dev Returns the subtraction of two unsigned integers, reverting on
333      * overflow (when the result is negative).
334      *
335      * Counterpart to Solidity's `-` operator.
336      *
337      * Requirements:
338      * - Subtraction cannot overflow.
339      */
340     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
341         return sub(a, b, "SafeMath: subtraction overflow");
342     }
343 
344     /**
345      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
346      * overflow (when the result is negative).
347      *
348      * Counterpart to Solidity's `-` operator.
349      *
350      * Requirements:
351      * - Subtraction cannot overflow.
352      *
353      * _Available since v2.4.0._
354      */
355     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
356         require(b <= a, errorMessage);
357         uint256 c = a - b;
358 
359         return c;
360     }
361 
362     /**
363      * @dev Returns the multiplication of two unsigned integers, reverting on
364      * overflow.
365      *
366      * Counterpart to Solidity's `*` operator.
367      *
368      * Requirements:
369      * - Multiplication cannot overflow.
370      */
371     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
372         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
373         // benefit is lost if 'b' is also tested.
374         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
375         if (a == 0) {
376             return 0;
377         }
378 
379         uint256 c = a * b;
380         require(c / a == b, "SafeMath: multiplication overflow");
381 
382         return c;
383     }
384 
385     /**
386      * @dev Returns the integer division of two unsigned integers. Reverts on
387      * division by zero. The result is rounded towards zero.
388      *
389      * Counterpart to Solidity's `/` operator. Note: this function uses a
390      * `revert` opcode (which leaves remaining gas untouched) while Solidity
391      * uses an invalid opcode to revert (consuming all remaining gas).
392      *
393      * Requirements:
394      * - The divisor cannot be zero.
395      */
396     function div(uint256 a, uint256 b) internal pure returns (uint256) {
397         return div(a, b, "SafeMath: division by zero");
398     }
399 
400     /**
401      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
402      * division by zero. The result is rounded towards zero.
403      *
404      * Counterpart to Solidity's `/` operator. Note: this function uses a
405      * `revert` opcode (which leaves remaining gas untouched) while Solidity
406      * uses an invalid opcode to revert (consuming all remaining gas).
407      *
408      * Requirements:
409      * - The divisor cannot be zero.
410      *
411      * _Available since v2.4.0._
412      */
413     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
414         // Solidity only automatically asserts when dividing by 0
415         require(b > 0, errorMessage);
416         uint256 c = a / b;
417         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
418 
419         return c;
420     }
421 
422     /**
423      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
424      * Reverts when dividing by zero.
425      *
426      * Counterpart to Solidity's `%` operator. This function uses a `revert`
427      * opcode (which leaves remaining gas untouched) while Solidity uses an
428      * invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      * - The divisor cannot be zero.
432      */
433     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
434         return mod(a, b, "SafeMath: modulo by zero");
435     }
436 
437     /**
438      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
439      * Reverts with custom message when dividing by zero.
440      *
441      * Counterpart to Solidity's `%` operator. This function uses a `revert`
442      * opcode (which leaves remaining gas untouched) while Solidity uses an
443      * invalid opcode to revert (consuming all remaining gas).
444      *
445      * Requirements:
446      * - The divisor cannot be zero.
447      *
448      * _Available since v2.4.0._
449      */
450     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
451         require(b != 0, errorMessage);
452         return a % b;
453     }
454 }
455 
456 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
457 
458 /**
459  * @dev Implementation of the {IERC20} interface.
460  *
461  * This implementation is agnostic to the way tokens are created. This means
462  * that a supply mechanism has to be added in a derived contract using {_mint}.
463  * For a generic mechanism see {ERC20Mintable}.
464  *
465  * TIP: For a detailed writeup see our guide
466  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
467  * to implement supply mechanisms].
468  *
469  * We have followed general OpenZeppelin guidelines: functions revert instead
470  * of returning `false` on failure. This behavior is nonetheless conventional
471  * and does not conflict with the expectations of ERC20 applications.
472  *
473  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
474  * This allows applications to reconstruct the allowance for all accounts just
475  * by listening to said events. Other implementations of the EIP may not emit
476  * these events, as it isn't required by the specification.
477  *
478  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
479  * functions have been added to mitigate the well-known issues around setting
480  * allowances. See {IERC20-approve}.
481  */
482 contract ERC20 is Context, IERC20 {
483     using SafeMath for uint256;
484 
485     mapping (address => uint256) private _balances;
486 
487     mapping (address => mapping (address => uint256)) private _allowances;
488 
489     uint256 private _totalSupply;
490 
491     /**
492      * @dev See {IERC20-totalSupply}.
493      */
494     function totalSupply() public view returns (uint256) {
495         return _totalSupply;
496     }
497 
498     /**
499      * @dev See {IERC20-balanceOf}.
500      */
501     function balanceOf(address account) public view returns (uint256) {
502         return _balances[account];
503     }
504 
505     /**
506      * @dev See {IERC20-transfer}.
507      *
508      * Requirements:
509      *
510      * - `recipient` cannot be the zero address.
511      * - the caller must have a balance of at least `amount`.
512      */
513     function transfer(address recipient, uint256 amount) public returns (bool) {
514         _transfer(_msgSender(), recipient, amount);
515         return true;
516     }
517 
518     /**
519      * @dev See {IERC20-allowance}.
520      */
521     function allowance(address owner, address spender) public view returns (uint256) {
522         return _allowances[owner][spender];
523     }
524 
525     /**
526      * @dev See {IERC20-approve}.
527      *
528      * Requirements:
529      *
530      * - `spender` cannot be the zero address.
531      */
532     function approve(address spender, uint256 amount) public returns (bool) {
533         _approve(_msgSender(), spender, amount);
534         return true;
535     }
536 
537     /**
538      * @dev See {IERC20-transferFrom}.
539      *
540      * Emits an {Approval} event indicating the updated allowance. This is not
541      * required by the EIP. See the note at the beginning of {ERC20};
542      *
543      * Requirements:
544      * - `sender` and `recipient` cannot be the zero address.
545      * - `sender` must have a balance of at least `amount`.
546      * - the caller must have allowance for `sender`'s tokens of at least
547      * `amount`.
548      */
549     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
550         _transfer(sender, recipient, amount);
551         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
552         return true;
553     }
554 
555     /**
556      * @dev Atomically increases the allowance granted to `spender` by the caller.
557      *
558      * This is an alternative to {approve} that can be used as a mitigation for
559      * problems described in {IERC20-approve}.
560      *
561      * Emits an {Approval} event indicating the updated allowance.
562      *
563      * Requirements:
564      *
565      * - `spender` cannot be the zero address.
566      */
567     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
568         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
569         return true;
570     }
571 
572     /**
573      * @dev Atomically decreases the allowance granted to `spender` by the caller.
574      *
575      * This is an alternative to {approve} that can be used as a mitigation for
576      * problems described in {IERC20-approve}.
577      *
578      * Emits an {Approval} event indicating the updated allowance.
579      *
580      * Requirements:
581      *
582      * - `spender` cannot be the zero address.
583      * - `spender` must have allowance for the caller of at least
584      * `subtractedValue`.
585      */
586     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
587         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
588         return true;
589     }
590 
591     /**
592      * @dev Moves tokens `amount` from `sender` to `recipient`.
593      *
594      * This is internal function is equivalent to {transfer}, and can be used to
595      * e.g. implement automatic token fees, slashing mechanisms, etc.
596      *
597      * Emits a {Transfer} event.
598      *
599      * Requirements:
600      *
601      * - `sender` cannot be the zero address.
602      * - `recipient` cannot be the zero address.
603      * - `sender` must have a balance of at least `amount`.
604      */
605     function _transfer(address sender, address recipient, uint256 amount) internal {
606         require(sender != address(0), "ERC20: transfer from the zero address");
607         require(recipient != address(0), "ERC20: transfer to the zero address");
608 
609         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
610         _balances[recipient] = _balances[recipient].add(amount);
611         emit Transfer(sender, recipient, amount);
612     }
613 
614     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
615      * the total supply.
616      *
617      * Emits a {Transfer} event with `from` set to the zero address.
618      *
619      * Requirements
620      *
621      * - `to` cannot be the zero address.
622      */
623     function _mint(address account, uint256 amount) internal {
624         require(account != address(0), "ERC20: mint to the zero address");
625 
626         _totalSupply = _totalSupply.add(amount);
627         _balances[account] = _balances[account].add(amount);
628         emit Transfer(address(0), account, amount);
629     }
630 
631      /**
632      * @dev Destroys `amount` tokens from `account`, reducing the
633      * total supply.
634      *
635      * Emits a {Transfer} event with `to` set to the zero address.
636      *
637      * Requirements
638      *
639      * - `account` cannot be the zero address.
640      * - `account` must have at least `amount` tokens.
641      */
642     function _burn(address account, uint256 amount) internal {
643         require(account != address(0), "ERC20: burn from the zero address");
644 
645         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
646         _totalSupply = _totalSupply.sub(amount);
647         emit Transfer(account, address(0), amount);
648     }
649 
650     /**
651      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
652      *
653      * This is internal function is equivalent to `approve`, and can be used to
654      * e.g. set automatic allowances for certain subsystems, etc.
655      *
656      * Emits an {Approval} event.
657      *
658      * Requirements:
659      *
660      * - `owner` cannot be the zero address.
661      * - `spender` cannot be the zero address.
662      */
663     function _approve(address owner, address spender, uint256 amount) internal {
664         require(owner != address(0), "ERC20: approve from the zero address");
665         require(spender != address(0), "ERC20: approve to the zero address");
666 
667         _allowances[owner][spender] = amount;
668         emit Approval(owner, spender, amount);
669     }
670 
671     /**
672      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
673      * from the caller's allowance.
674      *
675      * See {_burn} and {_approve}.
676      */
677     function _burnFrom(address account, uint256 amount) internal {
678         _burn(account, amount);
679         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
680     }
681 }
682 
683 // File: @openzeppelin/contracts/introspection/IERC165.sol
684 
685 /**
686  * @dev Interface of the ERC165 standard, as defined in the
687  * https://eips.ethereum.org/EIPS/eip-165[EIP].
688  *
689  * Implementers can declare support of contract interfaces, which can then be
690  * queried by others ({ERC165Checker}).
691  *
692  * For an implementation, see {ERC165}.
693  */
694 interface IERC165 {
695     /**
696      * @dev Returns true if this contract implements the interface defined by
697      * `interfaceId`. See the corresponding
698      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
699      * to learn more about how these ids are created.
700      *
701      * This function call must use less than 30 000 gas.
702      */
703     function supportsInterface(bytes4 interfaceId) external view returns (bool);
704 }
705 
706 // File: @openzeppelin/contracts/introspection/ERC165.sol
707 
708 /**
709  * @dev Implementation of the {IERC165} interface.
710  *
711  * Contracts may inherit from this and call {_registerInterface} to declare
712  * their support of an interface.
713  */
714 contract ERC165 is IERC165 {
715     /*
716      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
717      */
718     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
719 
720     /**
721      * @dev Mapping of interface ids to whether or not it's supported.
722      */
723     mapping(bytes4 => bool) private _supportedInterfaces;
724 
725     constructor () internal {
726         // Derived contracts need only register support for their own interfaces,
727         // we register support for ERC165 itself here
728         _registerInterface(_INTERFACE_ID_ERC165);
729     }
730 
731     /**
732      * @dev See {IERC165-supportsInterface}.
733      *
734      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
735      */
736     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
737         return _supportedInterfaces[interfaceId];
738     }
739 
740     /**
741      * @dev Registers the contract as an implementer of the interface defined by
742      * `interfaceId`. Support of the actual ERC165 interface is automatic and
743      * registering its interface id is not required.
744      *
745      * See {IERC165-supportsInterface}.
746      *
747      * Requirements:
748      *
749      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
750      */
751     function _registerInterface(bytes4 interfaceId) internal {
752         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
753         _supportedInterfaces[interfaceId] = true;
754     }
755 }
756 
757 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
758 
759 /**
760  * @title IERC1363 Interface
761  * @author Vittorio Minacori (https://github.com/vittominacori)
762  * @dev Interface for a Payable Token contract as defined in
763  *  https://github.com/ethereum/EIPs/issues/1363
764  */
765 contract IERC1363 is IERC20, ERC165 {
766     /*
767      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
768      * 0x4bbee2df ===
769      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
770      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
771      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
772      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
773      */
774 
775     /*
776      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
777      * 0xfb9ec8ce ===
778      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
779      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
780      */
781 
782     /**
783      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
784      * @param to address The address which you want to transfer to
785      * @param value uint256 The amount of tokens to be transferred
786      * @return true unless throwing
787      */
788     function transferAndCall(address to, uint256 value) public returns (bool);
789 
790     /**
791      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
792      * @param to address The address which you want to transfer to
793      * @param value uint256 The amount of tokens to be transferred
794      * @param data bytes Additional data with no specified format, sent in call to `to`
795      * @return true unless throwing
796      */
797     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool);
798 
799     /**
800      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
801      * @param from address The address which you want to send tokens from
802      * @param to address The address which you want to transfer to
803      * @param value uint256 The amount of tokens to be transferred
804      * @return true unless throwing
805      */
806     function transferFromAndCall(address from, address to, uint256 value) public returns (bool);
807 
808 
809     /**
810      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
811      * @param from address The address which you want to send tokens from
812      * @param to address The address which you want to transfer to
813      * @param value uint256 The amount of tokens to be transferred
814      * @param data bytes Additional data with no specified format, sent in call to `to`
815      * @return true unless throwing
816      */
817     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool);
818 
819     /**
820      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
821      * and then call `onApprovalReceived` on spender.
822      * Beware that changing an allowance with this method brings the risk that someone may use both the old
823      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
824      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
825      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
826      * @param spender address The address which will spend the funds
827      * @param value uint256 The amount of tokens to be spent
828      */
829     function approveAndCall(address spender, uint256 value) public returns (bool);
830 
831     /**
832      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
833      * and then call `onApprovalReceived` on spender.
834      * Beware that changing an allowance with this method brings the risk that someone may use both the old
835      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
836      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
837      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
838      * @param spender address The address which will spend the funds
839      * @param value uint256 The amount of tokens to be spent
840      * @param data bytes Additional data with no specified format, sent in call to `spender`
841      */
842     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool);
843 }
844 
845 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
846 
847 /**
848  * @title IERC1363Receiver Interface
849  * @author Vittorio Minacori (https://github.com/vittominacori)
850  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
851  *  from ERC1363 token contracts as defined in
852  *  https://github.com/ethereum/EIPs/issues/1363
853  */
854 contract IERC1363Receiver {
855     /*
856      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
857      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
858      */
859 
860     /**
861      * @notice Handle the receipt of ERC1363 tokens
862      * @dev Any ERC1363 smart contract calls this function on the recipient
863      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
864      * transfer. Return of other than the magic value MUST result in the
865      * transaction being reverted.
866      * Note: the token contract address is always the message sender.
867      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
868      * @param from address The address which are token transferred from
869      * @param value uint256 The amount of tokens transferred
870      * @param data bytes Additional data with no specified format
871      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
872      *  unless throwing
873      */
874     function onTransferReceived(address operator, address from, uint256 value, bytes memory data) public returns (bytes4); // solhint-disable-line  max-line-length
875 }
876 
877 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
878 
879 /**
880  * @title IERC1363Spender Interface
881  * @author Vittorio Minacori (https://github.com/vittominacori)
882  * @dev Interface for any contract that wants to support approveAndCall
883  *  from ERC1363 token contracts as defined in
884  *  https://github.com/ethereum/EIPs/issues/1363
885  */
886 contract IERC1363Spender {
887     /*
888      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
889      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
890      */
891 
892     /**
893      * @notice Handle the approval of ERC1363 tokens
894      * @dev Any ERC1363 smart contract calls this function on the recipient
895      * after an `approve`. This function MAY throw to revert and reject the
896      * approval. Return of other than the magic value MUST result in the
897      * transaction being reverted.
898      * Note: the token contract address is always the message sender.
899      * @param owner address The address which called `approveAndCall` function
900      * @param value uint256 The amount of tokens to be spent
901      * @param data bytes Additional data with no specified format
902      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
903      *  unless throwing
904      */
905     function onApprovalReceived(address owner, uint256 value, bytes memory data) public returns (bytes4);
906 }
907 
908 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
909 
910 /**
911  * @title ERC1363
912  * @author Vittorio Minacori (https://github.com/vittominacori)
913  * @dev Implementation of an ERC1363 interface
914  */
915 contract ERC1363 is ERC20, IERC1363 {
916     using Address for address;
917 
918     /*
919      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
920      * 0x4bbee2df ===
921      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
922      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
923      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
924      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
925      */
926     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
927 
928     /*
929      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
930      * 0xfb9ec8ce ===
931      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
932      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
933      */
934     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
935 
936     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
937     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
938     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
939 
940     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
941     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
942     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
943 
944     constructor() public {
945         // register the supported interfaces to conform to ERC1363 via ERC165
946         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
947         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
948     }
949 
950     function transferAndCall(address to, uint256 value) public returns (bool) {
951         return transferAndCall(to, value, "");
952     }
953 
954     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool) {
955         require(transfer(to, value));
956         require(_checkAndCallTransfer(msg.sender, to, value, data));
957         return true;
958     }
959 
960     function transferFromAndCall(address from, address to, uint256 value) public returns (bool) {
961         return transferFromAndCall(from, to, value, "");
962     }
963 
964     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool) {
965         require(transferFrom(from, to, value));
966         require(_checkAndCallTransfer(from, to, value, data));
967         return true;
968     }
969 
970     function approveAndCall(address spender, uint256 value) public returns (bool) {
971         return approveAndCall(spender, value, "");
972     }
973 
974     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool) {
975         approve(spender, value);
976         require(_checkAndCallApprove(spender, value, data));
977         return true;
978     }
979 
980     /**
981      * @dev Internal function to invoke `onTransferReceived` on a target address
982      *  The call is not executed if the target address is not a contract
983      * @param from address Representing the previous owner of the given token value
984      * @param to address Target address that will receive the tokens
985      * @param value uint256 The amount mount of tokens to be transferred
986      * @param data bytes Optional data to send along with the call
987      * @return whether the call correctly returned the expected magic value
988      */
989     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
990         if (!to.isContract()) {
991             return false;
992         }
993         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
994             msg.sender, from, value, data
995         );
996         return (retval == _ERC1363_RECEIVED);
997     }
998 
999     /**
1000      * @dev Internal function to invoke `onApprovalReceived` on a target address
1001      *  The call is not executed if the target address is not a contract
1002      * @param spender address The address which will spend the funds
1003      * @param value uint256 The amount of tokens to be spent
1004      * @param data bytes Optional data to send along with the call
1005      * @return whether the call correctly returned the expected magic value
1006      */
1007     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
1008         if (!spender.isContract()) {
1009             return false;
1010         }
1011         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1012             msg.sender, value, data
1013         );
1014         return (retval == _ERC1363_APPROVED);
1015     }
1016 }
1017 
1018 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
1019 
1020 /**
1021  * @dev Optional functions from the ERC20 standard.
1022  */
1023 contract ERC20Detailed is IERC20 {
1024     string private _name;
1025     string private _symbol;
1026     uint8 private _decimals;
1027 
1028     /**
1029      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1030      * these values are immutable: they can only be set once during
1031      * construction.
1032      */
1033     constructor (string memory name, string memory symbol, uint8 decimals) public {
1034         _name = name;
1035         _symbol = symbol;
1036         _decimals = decimals;
1037     }
1038 
1039     /**
1040      * @dev Returns the name of the token.
1041      */
1042     function name() public view returns (string memory) {
1043         return _name;
1044     }
1045 
1046     /**
1047      * @dev Returns the symbol of the token, usually a shorter version of the
1048      * name.
1049      */
1050     function symbol() public view returns (string memory) {
1051         return _symbol;
1052     }
1053 
1054     /**
1055      * @dev Returns the number of decimals used to get its user representation.
1056      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1057      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1058      *
1059      * Tokens usually opt for a value of 18, imitating the relationship between
1060      * Ether and Wei.
1061      *
1062      * NOTE: This information is only used for _display_ purposes: it in
1063      * no way affects any of the arithmetic of the contract, including
1064      * {IERC20-balanceOf} and {IERC20-transfer}.
1065      */
1066     function decimals() public view returns (uint8) {
1067         return _decimals;
1068     }
1069 }
1070 
1071 // File: @openzeppelin/contracts/access/Roles.sol
1072 
1073 /**
1074  * @title Roles
1075  * @dev Library for managing addresses assigned to a Role.
1076  */
1077 library Roles {
1078     struct Role {
1079         mapping (address => bool) bearer;
1080     }
1081 
1082     /**
1083      * @dev Give an account access to this role.
1084      */
1085     function add(Role storage role, address account) internal {
1086         require(!has(role, account), "Roles: account already has role");
1087         role.bearer[account] = true;
1088     }
1089 
1090     /**
1091      * @dev Remove an account's access to this role.
1092      */
1093     function remove(Role storage role, address account) internal {
1094         require(has(role, account), "Roles: account does not have role");
1095         role.bearer[account] = false;
1096     }
1097 
1098     /**
1099      * @dev Check if an account has this role.
1100      * @return bool
1101      */
1102     function has(Role storage role, address account) internal view returns (bool) {
1103         require(account != address(0), "Roles: account is the zero address");
1104         return role.bearer[account];
1105     }
1106 }
1107 
1108 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
1109 
1110 contract MinterRole is Context {
1111     using Roles for Roles.Role;
1112 
1113     event MinterAdded(address indexed account);
1114     event MinterRemoved(address indexed account);
1115 
1116     Roles.Role private _minters;
1117 
1118     constructor () internal {
1119         _addMinter(_msgSender());
1120     }
1121 
1122     modifier onlyMinter() {
1123         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1124         _;
1125     }
1126 
1127     function isMinter(address account) public view returns (bool) {
1128         return _minters.has(account);
1129     }
1130 
1131     function addMinter(address account) public onlyMinter {
1132         _addMinter(account);
1133     }
1134 
1135     function renounceMinter() public {
1136         _removeMinter(_msgSender());
1137     }
1138 
1139     function _addMinter(address account) internal {
1140         _minters.add(account);
1141         emit MinterAdded(account);
1142     }
1143 
1144     function _removeMinter(address account) internal {
1145         _minters.remove(account);
1146         emit MinterRemoved(account);
1147     }
1148 }
1149 
1150 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
1151 
1152 /**
1153  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1154  * which have permission to mint (create) new tokens as they see fit.
1155  *
1156  * At construction, the deployer of the contract is the only minter.
1157  */
1158 contract ERC20Mintable is ERC20, MinterRole {
1159     /**
1160      * @dev See {ERC20-_mint}.
1161      *
1162      * Requirements:
1163      *
1164      * - the caller must have the {MinterRole}.
1165      */
1166     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1167         _mint(account, amount);
1168         return true;
1169     }
1170 }
1171 
1172 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
1173 
1174 /**
1175  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
1176  */
1177 contract ERC20Capped is ERC20Mintable {
1178     uint256 private _cap;
1179 
1180     /**
1181      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1182      * set once during construction.
1183      */
1184     constructor (uint256 cap) public {
1185         require(cap > 0, "ERC20Capped: cap is 0");
1186         _cap = cap;
1187     }
1188 
1189     /**
1190      * @dev Returns the cap on the token's total supply.
1191      */
1192     function cap() public view returns (uint256) {
1193         return _cap;
1194     }
1195 
1196     /**
1197      * @dev See {ERC20Mintable-mint}.
1198      *
1199      * Requirements:
1200      *
1201      * - `value` must not cause the total supply to go over the cap.
1202      */
1203     function _mint(address account, uint256 value) internal {
1204         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
1205         super._mint(account, value);
1206     }
1207 }
1208 
1209 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1210 
1211 /**
1212  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1213  * tokens and those that they have an allowance for, in a way that can be
1214  * recognized off-chain (via event analysis).
1215  */
1216 contract ERC20Burnable is Context, ERC20 {
1217     /**
1218      * @dev Destroys `amount` tokens from the caller.
1219      *
1220      * See {ERC20-_burn}.
1221      */
1222     function burn(uint256 amount) public {
1223         _burn(_msgSender(), amount);
1224     }
1225 
1226     /**
1227      * @dev See {ERC20-_burnFrom}.
1228      */
1229     function burnFrom(address account, uint256 amount) public {
1230         _burnFrom(account, amount);
1231     }
1232 }
1233 
1234 // File: @openzeppelin/contracts/ownership/Ownable.sol
1235 
1236 /**
1237  * @dev Contract module which provides a basic access control mechanism, where
1238  * there is an account (an owner) that can be granted exclusive access to
1239  * specific functions.
1240  *
1241  * This module is used through inheritance. It will make available the modifier
1242  * `onlyOwner`, which can be applied to your functions to restrict their use to
1243  * the owner.
1244  */
1245 contract Ownable is Context {
1246     address private _owner;
1247 
1248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1249 
1250     /**
1251      * @dev Initializes the contract setting the deployer as the initial owner.
1252      */
1253     constructor () internal {
1254         _owner = _msgSender();
1255         emit OwnershipTransferred(address(0), _owner);
1256     }
1257 
1258     /**
1259      * @dev Returns the address of the current owner.
1260      */
1261     function owner() public view returns (address) {
1262         return _owner;
1263     }
1264 
1265     /**
1266      * @dev Throws if called by any account other than the owner.
1267      */
1268     modifier onlyOwner() {
1269         require(isOwner(), "Ownable: caller is not the owner");
1270         _;
1271     }
1272 
1273     /**
1274      * @dev Returns true if the caller is the current owner.
1275      */
1276     function isOwner() public view returns (bool) {
1277         return _msgSender() == _owner;
1278     }
1279 
1280     /**
1281      * @dev Leaves the contract without owner. It will not be possible to call
1282      * `onlyOwner` functions anymore. Can only be called by the current owner.
1283      *
1284      * NOTE: Renouncing ownership will leave the contract without an owner,
1285      * thereby removing any functionality that is only available to the owner.
1286      */
1287     function renounceOwnership() public onlyOwner {
1288         emit OwnershipTransferred(_owner, address(0));
1289         _owner = address(0);
1290     }
1291 
1292     /**
1293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1294      * Can only be called by the current owner.
1295      */
1296     function transferOwnership(address newOwner) public onlyOwner {
1297         _transferOwnership(newOwner);
1298     }
1299 
1300     /**
1301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1302      */
1303     function _transferOwnership(address newOwner) internal {
1304         require(newOwner != address(0), "Ownable: new owner is the zero address");
1305         emit OwnershipTransferred(_owner, newOwner);
1306         _owner = newOwner;
1307     }
1308 }
1309 
1310 // File: eth-token-recover/contracts/TokenRecover.sol
1311 
1312 /**
1313  * @title TokenRecover
1314  * @author Vittorio Minacori (https://github.com/vittominacori)
1315  * @dev Allow to recover any ERC20 sent into the contract for error
1316  */
1317 contract TokenRecover is Ownable {
1318 
1319     /**
1320      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1321      * @param tokenAddress The token contract address
1322      * @param tokenAmount Number of tokens to be sent
1323      */
1324     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1325         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1326     }
1327 }
1328 
1329 // File: ico-maker/contracts/access/roles/OperatorRole.sol
1330 
1331 contract OperatorRole {
1332     using Roles for Roles.Role;
1333 
1334     event OperatorAdded(address indexed account);
1335     event OperatorRemoved(address indexed account);
1336 
1337     Roles.Role private _operators;
1338 
1339     constructor() internal {
1340         _addOperator(msg.sender);
1341     }
1342 
1343     modifier onlyOperator() {
1344         require(isOperator(msg.sender));
1345         _;
1346     }
1347 
1348     function isOperator(address account) public view returns (bool) {
1349         return _operators.has(account);
1350     }
1351 
1352     function addOperator(address account) public onlyOperator {
1353         _addOperator(account);
1354     }
1355 
1356     function renounceOperator() public {
1357         _removeOperator(msg.sender);
1358     }
1359 
1360     function _addOperator(address account) internal {
1361         _operators.add(account);
1362         emit OperatorAdded(account);
1363     }
1364 
1365     function _removeOperator(address account) internal {
1366         _operators.remove(account);
1367         emit OperatorRemoved(account);
1368     }
1369 }
1370 
1371 // File: ico-maker/contracts/token/ERC20/BaseERC20Token.sol
1372 
1373 /**
1374  * @title BaseERC20Token
1375  * @author Vittorio Minacori (https://github.com/vittominacori)
1376  * @dev Implementation of the BaseERC20Token
1377  */
1378 contract BaseERC20Token is ERC20Detailed, ERC20Capped, ERC20Burnable, OperatorRole, TokenRecover {
1379 
1380     event MintFinished();
1381     event TransferEnabled();
1382 
1383     // indicates if minting is finished
1384     bool private _mintingFinished = false;
1385 
1386     // indicates if transfer is enabled
1387     bool private _transferEnabled = false;
1388 
1389     /**
1390      * @dev Tokens can be minted only before minting finished.
1391      */
1392     modifier canMint() {
1393         require(!_mintingFinished);
1394         _;
1395     }
1396 
1397     /**
1398      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1399      */
1400     modifier canTransfer(address from) {
1401         require(_transferEnabled || isOperator(from));
1402         _;
1403     }
1404 
1405     /**
1406      * @param name Name of the token
1407      * @param symbol A symbol to be used as ticker
1408      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1409      * @param cap Maximum number of tokens mintable
1410      * @param initialSupply Initial token supply
1411      */
1412     constructor(
1413         string memory name,
1414         string memory symbol,
1415         uint8 decimals,
1416         uint256 cap,
1417         uint256 initialSupply
1418     )
1419         public
1420         ERC20Detailed(name, symbol, decimals)
1421         ERC20Capped(cap)
1422     {
1423         if (initialSupply > 0) {
1424             _mint(owner(), initialSupply);
1425         }
1426     }
1427 
1428     /**
1429      * @return if minting is finished or not.
1430      */
1431     function mintingFinished() public view returns (bool) {
1432         return _mintingFinished;
1433     }
1434 
1435     /**
1436      * @return if transfer is enabled or not.
1437      */
1438     function transferEnabled() public view returns (bool) {
1439         return _transferEnabled;
1440     }
1441 
1442     /**
1443      * @dev Function to mint tokens
1444      * @param to The address that will receive the minted tokens.
1445      * @param value The amount of tokens to mint.
1446      * @return A boolean that indicates if the operation was successful.
1447      */
1448     function mint(address to, uint256 value) public canMint returns (bool) {
1449         return super.mint(to, value);
1450     }
1451 
1452     /**
1453      * @dev Transfer token to a specified address
1454      * @param to The address to transfer to.
1455      * @param value The amount to be transferred.
1456      * @return A boolean that indicates if the operation was successful.
1457      */
1458     function transfer(address to, uint256 value) public canTransfer(msg.sender) returns (bool) {
1459         return super.transfer(to, value);
1460     }
1461 
1462     /**
1463      * @dev Transfer tokens from one address to another.
1464      * @param from address The address which you want to send tokens from
1465      * @param to address The address which you want to transfer to
1466      * @param value uint256 the amount of tokens to be transferred
1467      * @return A boolean that indicates if the operation was successful.
1468      */
1469     function transferFrom(address from, address to, uint256 value) public canTransfer(from) returns (bool) {
1470         return super.transferFrom(from, to, value);
1471     }
1472 
1473     /**
1474      * @dev Function to stop minting new tokens.
1475      */
1476     function finishMinting() public onlyOwner canMint {
1477         _mintingFinished = true;
1478 
1479         emit MintFinished();
1480     }
1481 
1482     /**
1483    * @dev Function to enable transfers.
1484    */
1485     function enableTransfer() public onlyOwner {
1486         _transferEnabled = true;
1487 
1488         emit TransferEnabled();
1489     }
1490 
1491     /**
1492      * @dev remove the `operator` role from address
1493      * @param account Address you want to remove role
1494      */
1495     function removeOperator(address account) public onlyOwner {
1496         _removeOperator(account);
1497     }
1498 
1499     /**
1500      * @dev remove the `minter` role from address
1501      * @param account Address you want to remove role
1502      */
1503     function removeMinter(address account) public onlyOwner {
1504         _removeMinter(account);
1505     }
1506 }
1507 
1508 // File: ico-maker/contracts/token/ERC1363/BaseERC1363Token.sol
1509 
1510 /**
1511  * @title BaseERC1363Token
1512  * @author Vittorio Minacori (https://github.com/vittominacori)
1513  * @dev Implementation of the BaseERC20Token with ERC1363 behaviours
1514  */
1515 contract BaseERC1363Token is BaseERC20Token, ERC1363 {
1516 
1517     /**
1518      * @param name Name of the token
1519      * @param symbol A symbol to be used as ticker
1520      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1521      * @param cap Maximum number of tokens mintable
1522      * @param initialSupply Initial token supply
1523      */
1524     constructor(
1525         string memory name,
1526         string memory symbol,
1527         uint8 decimals,
1528         uint256 cap,
1529         uint256 initialSupply
1530     )
1531         public
1532         BaseERC20Token(name, symbol, decimals, cap, initialSupply)
1533     {} // solhint-disable-line no-empty-blocks
1534 }
1535 
1536 // File: contracts/ERC20Token.sol
1537 
1538 /**
1539  * @title ERC20Token
1540  * @author Vittorio Minacori (https://github.com/vittominacori)
1541  * @dev Implementation of a BaseERC1363Token
1542  */
1543 contract ERC20Token is BaseERC1363Token {
1544 
1545     string public builtOn = "https://vittominacori.github.io/erc20-generator";
1546 
1547     constructor(
1548         string memory name,
1549         string memory symbol,
1550         uint8 decimals,
1551         uint256 cap,
1552         uint256 initialSupply,
1553         bool transferEnabled
1554     )
1555         public
1556         BaseERC1363Token(name, symbol, decimals, cap, initialSupply)
1557     {
1558         if (transferEnabled) {
1559             enableTransfer();
1560         }
1561     }
1562 }