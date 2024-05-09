1 pragma solidity ^0.5.10;
2 
3 // File: openzeppelin-solidity/contracts/utils/Address.sol
4 
5 /**
6  * @dev Collection of functions related to the address type,
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * This test is non-exhaustive, and there may be false-negatives: during the
13      * execution of a contract's constructor, its address will be reported as
14      * not containing a contract.
15      *
16      * > It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      */
19     function isContract(address account) internal view returns (bool) {
20         // This method relies in extcodesize, which returns 0 for contracts in
21         // construction, since the code is only stored at the end of the
22         // constructor execution.
23 
24         uint256 size;
25         // solhint-disable-next-line no-inline-assembly
26         assembly { size := extcodesize(account) }
27         return size > 0;
28     }
29 }
30 
31 // File: openzeppelin-solidity/contracts/introspection/ERC165Checker.sol
32 
33 /**
34  * @dev Library used to query support of an interface declared via `IERC165`.
35  *
36  * Note that these functions return the actual result of the query: they do not
37  * `revert` if an interface is not supported. It is up to the caller to decide
38  * what to do in these cases.
39  */
40 library ERC165Checker {
41     // As per the EIP-165 spec, no interface should ever match 0xffffffff
42     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
43 
44     /*
45      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
46      */
47     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
48 
49     /**
50      * @dev Returns true if `account` supports the `IERC165` interface,
51      */
52     function _supportsERC165(address account) internal view returns (bool) {
53         // Any contract that implements ERC165 must explicitly indicate support of
54         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
55         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
56             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
57     }
58 
59     /**
60      * @dev Returns true if `account` supports the interface defined by
61      * `interfaceId`. Support for `IERC165` itself is queried automatically.
62      *
63      * See `IERC165.supportsInterface`.
64      */
65     function _supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
66         // query support of both ERC165 as per the spec and support of _interfaceId
67         return _supportsERC165(account) &&
68             _supportsERC165Interface(account, interfaceId);
69     }
70 
71     /**
72      * @dev Returns true if `account` supports all the interfaces defined in
73      * `interfaceIds`. Support for `IERC165` itself is queried automatically.
74      *
75      * Batch-querying can lead to gas savings by skipping repeated checks for
76      * `IERC165` support.
77      *
78      * See `IERC165.supportsInterface`.
79      */
80     function _supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
81         // query support of ERC165 itself
82         if (!_supportsERC165(account)) {
83             return false;
84         }
85 
86         // query support of each interface in _interfaceIds
87         for (uint256 i = 0; i < interfaceIds.length; i++) {
88             if (!_supportsERC165Interface(account, interfaceIds[i])) {
89                 return false;
90             }
91         }
92 
93         // all interfaces supported
94         return true;
95     }
96 
97     /**
98      * @notice Query if a contract implements an interface, does not check ERC165 support
99      * @param account The address of the contract to query for support of an interface
100      * @param interfaceId The interface identifier, as specified in ERC-165
101      * @return true if the contract at account indicates support of the interface with
102      * identifier interfaceId, false otherwise
103      * @dev Assumes that account contains a contract that supports ERC165, otherwise
104      * the behavior of this method is undefined. This precondition can be checked
105      * with the `supportsERC165` method in this library.
106      * Interface identification is specified in ERC-165.
107      */
108     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
109         // success determines whether the staticcall succeeded and result determines
110         // whether the contract at account indicates support of _interfaceId
111         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
112 
113         return (success && result);
114     }
115 
116     /**
117      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
118      * @param account The address of the contract to query for support of an interface
119      * @param interfaceId The interface identifier, as specified in ERC-165
120      * @return success true if the STATICCALL succeeded, false otherwise
121      * @return result true if the STATICCALL succeeded and the contract at account
122      * indicates support of the interface with identifier interfaceId, false otherwise
123      */
124     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
125         private
126         view
127         returns (bool success, bool result)
128     {
129         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
130 
131         // solhint-disable-next-line no-inline-assembly
132         assembly {
133             let encodedParams_data := add(0x20, encodedParams)
134             let encodedParams_size := mload(encodedParams)
135 
136             let output := mload(0x40)    // Find empty storage location using "free memory pointer"
137             mstore(output, 0x0)
138 
139             success := staticcall(
140                 30000,                   // 30k gas
141                 account,                 // To addr
142                 encodedParams_data,
143                 encodedParams_size,
144                 output,
145                 0x20                     // Outputs are 32 bytes long
146             )
147 
148             result := mload(output)      // Load the result
149         }
150     }
151 }
152 
153 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
154 
155 /**
156  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
157  * the optional functions; to access them see `ERC20Detailed`.
158  */
159 interface IERC20 {
160     /**
161      * @dev Returns the amount of tokens in existence.
162      */
163     function totalSupply() external view returns (uint256);
164 
165     /**
166      * @dev Returns the amount of tokens owned by `account`.
167      */
168     function balanceOf(address account) external view returns (uint256);
169 
170     /**
171      * @dev Moves `amount` tokens from the caller's account to `recipient`.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a `Transfer` event.
176      */
177     function transfer(address recipient, uint256 amount) external returns (bool);
178 
179     /**
180      * @dev Returns the remaining number of tokens that `spender` will be
181      * allowed to spend on behalf of `owner` through `transferFrom`. This is
182      * zero by default.
183      *
184      * This value changes when `approve` or `transferFrom` are called.
185      */
186     function allowance(address owner, address spender) external view returns (uint256);
187 
188     /**
189      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * > Beware that changing an allowance with this method brings the risk
194      * that someone may use both the old and the new allowance by unfortunate
195      * transaction ordering. One possible solution to mitigate this race
196      * condition is to first reduce the spender's allowance to 0 and set the
197      * desired value afterwards:
198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199      *
200      * Emits an `Approval` event.
201      */
202     function approve(address spender, uint256 amount) external returns (bool);
203 
204     /**
205      * @dev Moves `amount` tokens from `sender` to `recipient` using the
206      * allowance mechanism. `amount` is then deducted from the caller's
207      * allowance.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * Emits a `Transfer` event.
212      */
213     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Emitted when `value` tokens are moved from one account (`from`) to
217      * another (`to`).
218      *
219      * Note that `value` may be zero.
220      */
221     event Transfer(address indexed from, address indexed to, uint256 value);
222 
223     /**
224      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
225      * a call to `approve`. `value` is the new allowance.
226      */
227     event Approval(address indexed owner, address indexed spender, uint256 value);
228 }
229 
230 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
231 
232 /**
233  * @dev Wrappers over Solidity's arithmetic operations with added overflow
234  * checks.
235  *
236  * Arithmetic operations in Solidity wrap on overflow. This can easily result
237  * in bugs, because programmers usually assume that an overflow raises an
238  * error, which is the standard behavior in high level programming languages.
239  * `SafeMath` restores this intuition by reverting the transaction when an
240  * operation overflows.
241  *
242  * Using this library instead of the unchecked operations eliminates an entire
243  * class of bugs, so it's recommended to use it always.
244  */
245 library SafeMath {
246     /**
247      * @dev Returns the addition of two unsigned integers, reverting on
248      * overflow.
249      *
250      * Counterpart to Solidity's `+` operator.
251      *
252      * Requirements:
253      * - Addition cannot overflow.
254      */
255     function add(uint256 a, uint256 b) internal pure returns (uint256) {
256         uint256 c = a + b;
257         require(c >= a, "SafeMath: addition overflow");
258 
259         return c;
260     }
261 
262     /**
263      * @dev Returns the subtraction of two unsigned integers, reverting on
264      * overflow (when the result is negative).
265      *
266      * Counterpart to Solidity's `-` operator.
267      *
268      * Requirements:
269      * - Subtraction cannot overflow.
270      */
271     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
272         require(b <= a, "SafeMath: subtraction overflow");
273         uint256 c = a - b;
274 
275         return c;
276     }
277 
278     /**
279      * @dev Returns the multiplication of two unsigned integers, reverting on
280      * overflow.
281      *
282      * Counterpart to Solidity's `*` operator.
283      *
284      * Requirements:
285      * - Multiplication cannot overflow.
286      */
287     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
288         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
289         // benefit is lost if 'b' is also tested.
290         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
291         if (a == 0) {
292             return 0;
293         }
294 
295         uint256 c = a * b;
296         require(c / a == b, "SafeMath: multiplication overflow");
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the integer division of two unsigned integers. Reverts on
303      * division by zero. The result is rounded towards zero.
304      *
305      * Counterpart to Solidity's `/` operator. Note: this function uses a
306      * `revert` opcode (which leaves remaining gas untouched) while Solidity
307      * uses an invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      * - The divisor cannot be zero.
311      */
312     function div(uint256 a, uint256 b) internal pure returns (uint256) {
313         // Solidity only automatically asserts when dividing by 0
314         require(b > 0, "SafeMath: division by zero");
315         uint256 c = a / b;
316         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
317 
318         return c;
319     }
320 
321     /**
322      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
323      * Reverts when dividing by zero.
324      *
325      * Counterpart to Solidity's `%` operator. This function uses a `revert`
326      * opcode (which leaves remaining gas untouched) while Solidity uses an
327      * invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      * - The divisor cannot be zero.
331      */
332     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
333         require(b != 0, "SafeMath: modulo by zero");
334         return a % b;
335     }
336 }
337 
338 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
339 
340 /**
341  * @dev Implementation of the `IERC20` interface.
342  *
343  * This implementation is agnostic to the way tokens are created. This means
344  * that a supply mechanism has to be added in a derived contract using `_mint`.
345  * For a generic mechanism see `ERC20Mintable`.
346  *
347  * *For a detailed writeup see our guide [How to implement supply
348  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
349  *
350  * We have followed general OpenZeppelin guidelines: functions revert instead
351  * of returning `false` on failure. This behavior is nonetheless conventional
352  * and does not conflict with the expectations of ERC20 applications.
353  *
354  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
355  * This allows applications to reconstruct the allowance for all accounts just
356  * by listening to said events. Other implementations of the EIP may not emit
357  * these events, as it isn't required by the specification.
358  *
359  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
360  * functions have been added to mitigate the well-known issues around setting
361  * allowances. See `IERC20.approve`.
362  */
363 contract ERC20 is IERC20 {
364     using SafeMath for uint256;
365 
366     mapping (address => uint256) private _balances;
367 
368     mapping (address => mapping (address => uint256)) private _allowances;
369 
370     uint256 private _totalSupply;
371 
372     /**
373      * @dev See `IERC20.totalSupply`.
374      */
375     function totalSupply() public view returns (uint256) {
376         return _totalSupply;
377     }
378 
379     /**
380      * @dev See `IERC20.balanceOf`.
381      */
382     function balanceOf(address account) public view returns (uint256) {
383         return _balances[account];
384     }
385 
386     /**
387      * @dev See `IERC20.transfer`.
388      *
389      * Requirements:
390      *
391      * - `recipient` cannot be the zero address.
392      * - the caller must have a balance of at least `amount`.
393      */
394     function transfer(address recipient, uint256 amount) public returns (bool) {
395         _transfer(msg.sender, recipient, amount);
396         return true;
397     }
398 
399     /**
400      * @dev See `IERC20.allowance`.
401      */
402     function allowance(address owner, address spender) public view returns (uint256) {
403         return _allowances[owner][spender];
404     }
405 
406     /**
407      * @dev See `IERC20.approve`.
408      *
409      * Requirements:
410      *
411      * - `spender` cannot be the zero address.
412      */
413     function approve(address spender, uint256 value) public returns (bool) {
414         _approve(msg.sender, spender, value);
415         return true;
416     }
417 
418     /**
419      * @dev See `IERC20.transferFrom`.
420      *
421      * Emits an `Approval` event indicating the updated allowance. This is not
422      * required by the EIP. See the note at the beginning of `ERC20`;
423      *
424      * Requirements:
425      * - `sender` and `recipient` cannot be the zero address.
426      * - `sender` must have a balance of at least `value`.
427      * - the caller must have allowance for `sender`'s tokens of at least
428      * `amount`.
429      */
430     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
431         _transfer(sender, recipient, amount);
432         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
433         return true;
434     }
435 
436     /**
437      * @dev Atomically increases the allowance granted to `spender` by the caller.
438      *
439      * This is an alternative to `approve` that can be used as a mitigation for
440      * problems described in `IERC20.approve`.
441      *
442      * Emits an `Approval` event indicating the updated allowance.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      */
448     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
449         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
450         return true;
451     }
452 
453     /**
454      * @dev Atomically decreases the allowance granted to `spender` by the caller.
455      *
456      * This is an alternative to `approve` that can be used as a mitigation for
457      * problems described in `IERC20.approve`.
458      *
459      * Emits an `Approval` event indicating the updated allowance.
460      *
461      * Requirements:
462      *
463      * - `spender` cannot be the zero address.
464      * - `spender` must have allowance for the caller of at least
465      * `subtractedValue`.
466      */
467     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
468         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
469         return true;
470     }
471 
472     /**
473      * @dev Moves tokens `amount` from `sender` to `recipient`.
474      *
475      * This is internal function is equivalent to `transfer`, and can be used to
476      * e.g. implement automatic token fees, slashing mechanisms, etc.
477      *
478      * Emits a `Transfer` event.
479      *
480      * Requirements:
481      *
482      * - `sender` cannot be the zero address.
483      * - `recipient` cannot be the zero address.
484      * - `sender` must have a balance of at least `amount`.
485      */
486     function _transfer(address sender, address recipient, uint256 amount) internal {
487         require(sender != address(0), "ERC20: transfer from the zero address");
488         require(recipient != address(0), "ERC20: transfer to the zero address");
489 
490         _balances[sender] = _balances[sender].sub(amount);
491         _balances[recipient] = _balances[recipient].add(amount);
492         emit Transfer(sender, recipient, amount);
493     }
494 
495     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
496      * the total supply.
497      *
498      * Emits a `Transfer` event with `from` set to the zero address.
499      *
500      * Requirements
501      *
502      * - `to` cannot be the zero address.
503      */
504     function _mint(address account, uint256 amount) internal {
505         require(account != address(0), "ERC20: mint to the zero address");
506 
507         _totalSupply = _totalSupply.add(amount);
508         _balances[account] = _balances[account].add(amount);
509         emit Transfer(address(0), account, amount);
510     }
511 
512      /**
513      * @dev Destoys `amount` tokens from `account`, reducing the
514      * total supply.
515      *
516      * Emits a `Transfer` event with `to` set to the zero address.
517      *
518      * Requirements
519      *
520      * - `account` cannot be the zero address.
521      * - `account` must have at least `amount` tokens.
522      */
523     function _burn(address account, uint256 value) internal {
524         require(account != address(0), "ERC20: burn from the zero address");
525 
526         _totalSupply = _totalSupply.sub(value);
527         _balances[account] = _balances[account].sub(value);
528         emit Transfer(account, address(0), value);
529     }
530 
531     /**
532      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
533      *
534      * This is internal function is equivalent to `approve`, and can be used to
535      * e.g. set automatic allowances for certain subsystems, etc.
536      *
537      * Emits an `Approval` event.
538      *
539      * Requirements:
540      *
541      * - `owner` cannot be the zero address.
542      * - `spender` cannot be the zero address.
543      */
544     function _approve(address owner, address spender, uint256 value) internal {
545         require(owner != address(0), "ERC20: approve from the zero address");
546         require(spender != address(0), "ERC20: approve to the zero address");
547 
548         _allowances[owner][spender] = value;
549         emit Approval(owner, spender, value);
550     }
551 
552     /**
553      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
554      * from the caller's allowance.
555      *
556      * See `_burn` and `_approve`.
557      */
558     function _burnFrom(address account, uint256 amount) internal {
559         _burn(account, amount);
560         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
561     }
562 }
563 
564 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
565 
566 /**
567  * @dev Interface of the ERC165 standard, as defined in the
568  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
569  *
570  * Implementers can declare support of contract interfaces, which can then be
571  * queried by others (`ERC165Checker`).
572  *
573  * For an implementation, see `ERC165`.
574  */
575 interface IERC165 {
576     /**
577      * @dev Returns true if this contract implements the interface defined by
578      * `interfaceId`. See the corresponding
579      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
580      * to learn more about how these ids are created.
581      *
582      * This function call must use less than 30 000 gas.
583      */
584     function supportsInterface(bytes4 interfaceId) external view returns (bool);
585 }
586 
587 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
588 
589 /**
590  * @dev Implementation of the `IERC165` interface.
591  *
592  * Contracts may inherit from this and call `_registerInterface` to declare
593  * their support of an interface.
594  */
595 contract ERC165 is IERC165 {
596     /*
597      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
598      */
599     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
600 
601     /**
602      * @dev Mapping of interface ids to whether or not it's supported.
603      */
604     mapping(bytes4 => bool) private _supportedInterfaces;
605 
606     constructor () internal {
607         // Derived contracts need only register support for their own interfaces,
608         // we register support for ERC165 itself here
609         _registerInterface(_INTERFACE_ID_ERC165);
610     }
611 
612     /**
613      * @dev See `IERC165.supportsInterface`.
614      *
615      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
616      */
617     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
618         return _supportedInterfaces[interfaceId];
619     }
620 
621     /**
622      * @dev Registers the contract as an implementer of the interface defined by
623      * `interfaceId`. Support of the actual ERC165 interface is automatic and
624      * registering its interface id is not required.
625      *
626      * See `IERC165.supportsInterface`.
627      *
628      * Requirements:
629      *
630      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
631      */
632     function _registerInterface(bytes4 interfaceId) internal {
633         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
634         _supportedInterfaces[interfaceId] = true;
635     }
636 }
637 
638 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
639 
640 /**
641  * @title IERC1363 Interface
642  * @author Vittorio Minacori (https://github.com/vittominacori)
643  * @dev Interface for a Payable Token contract as defined in
644  *  https://github.com/ethereum/EIPs/issues/1363
645  */
646 contract IERC1363 is IERC20, ERC165 {
647     /*
648      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
649      * 0x4bbee2df ===
650      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
651      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
652      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
653      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
654      */
655 
656     /*
657      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
658      * 0xfb9ec8ce ===
659      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
660      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
661      */
662 
663     /**
664      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
665      * @param to address The address which you want to transfer to
666      * @param value uint256 The amount of tokens to be transferred
667      * @return true unless throwing
668      */
669     function transferAndCall(address to, uint256 value) public returns (bool);
670 
671     /**
672      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
673      * @param to address The address which you want to transfer to
674      * @param value uint256 The amount of tokens to be transferred
675      * @param data bytes Additional data with no specified format, sent in call to `to`
676      * @return true unless throwing
677      */
678     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool);
679 
680     /**
681      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
682      * @param from address The address which you want to send tokens from
683      * @param to address The address which you want to transfer to
684      * @param value uint256 The amount of tokens to be transferred
685      * @return true unless throwing
686      */
687     function transferFromAndCall(address from, address to, uint256 value) public returns (bool);
688 
689 
690     /**
691      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
692      * @param from address The address which you want to send tokens from
693      * @param to address The address which you want to transfer to
694      * @param value uint256 The amount of tokens to be transferred
695      * @param data bytes Additional data with no specified format, sent in call to `to`
696      * @return true unless throwing
697      */
698     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool);
699 
700     /**
701      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
702      * and then call `onApprovalReceived` on spender.
703      * Beware that changing an allowance with this method brings the risk that someone may use both the old
704      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
705      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
706      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
707      * @param spender address The address which will spend the funds
708      * @param value uint256 The amount of tokens to be spent
709      */
710     function approveAndCall(address spender, uint256 value) public returns (bool);
711 
712     /**
713      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
714      * and then call `onApprovalReceived` on spender.
715      * Beware that changing an allowance with this method brings the risk that someone may use both the old
716      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
717      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
718      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
719      * @param spender address The address which will spend the funds
720      * @param value uint256 The amount of tokens to be spent
721      * @param data bytes Additional data with no specified format, sent in call to `spender`
722      */
723     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool);
724 }
725 
726 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
727 
728 /**
729  * @title IERC1363Receiver Interface
730  * @author Vittorio Minacori (https://github.com/vittominacori)
731  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
732  *  from ERC1363 token contracts as defined in
733  *  https://github.com/ethereum/EIPs/issues/1363
734  */
735 contract IERC1363Receiver {
736     /*
737      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
738      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
739      */
740 
741     /**
742      * @notice Handle the receipt of ERC1363 tokens
743      * @dev Any ERC1363 smart contract calls this function on the recipient
744      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
745      * transfer. Return of other than the magic value MUST result in the
746      * transaction being reverted.
747      * Note: the token contract address is always the message sender.
748      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
749      * @param from address The address which are token transferred from
750      * @param value uint256 The amount of tokens transferred
751      * @param data bytes Additional data with no specified format
752      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
753      *  unless throwing
754      */
755     function onTransferReceived(address operator, address from, uint256 value, bytes memory data) public returns (bytes4); // solhint-disable-line  max-line-length
756 }
757 
758 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
759 
760 /**
761  * @title IERC1363Spender Interface
762  * @author Vittorio Minacori (https://github.com/vittominacori)
763  * @dev Interface for any contract that wants to support approveAndCall
764  *  from ERC1363 token contracts as defined in
765  *  https://github.com/ethereum/EIPs/issues/1363
766  */
767 contract IERC1363Spender {
768     /*
769      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
770      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
771      */
772 
773     /**
774      * @notice Handle the approval of ERC1363 tokens
775      * @dev Any ERC1363 smart contract calls this function on the recipient
776      * after an `approve`. This function MAY throw to revert and reject the
777      * approval. Return of other than the magic value MUST result in the
778      * transaction being reverted.
779      * Note: the token contract address is always the message sender.
780      * @param owner address The address which called `approveAndCall` function
781      * @param value uint256 The amount of tokens to be spent
782      * @param data bytes Additional data with no specified format
783      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
784      *  unless throwing
785      */
786     function onApprovalReceived(address owner, uint256 value, bytes memory data) public returns (bytes4);
787 }
788 
789 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
790 
791 /**
792  * @title ERC1363
793  * @author Vittorio Minacori (https://github.com/vittominacori)
794  * @dev Implementation of an ERC1363 interface
795  */
796 contract ERC1363 is ERC20, IERC1363 {
797     using Address for address;
798 
799     /*
800      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
801      * 0x4bbee2df ===
802      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
803      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
804      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
805      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
806      */
807     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
808 
809     /*
810      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
811      * 0xfb9ec8ce ===
812      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
813      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
814      */
815     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
816 
817     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
818     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
819     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
820 
821     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
822     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
823     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
824 
825     constructor() public {
826         // register the supported interfaces to conform to ERC1363 via ERC165
827         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
828         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
829     }
830 
831     function transferAndCall(address to, uint256 value) public returns (bool) {
832         return transferAndCall(to, value, "");
833     }
834 
835     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool) {
836         require(transfer(to, value));
837         require(_checkAndCallTransfer(msg.sender, to, value, data));
838         return true;
839     }
840 
841     function transferFromAndCall(address from, address to, uint256 value) public returns (bool) {
842         return transferFromAndCall(from, to, value, "");
843     }
844 
845     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool) {
846         require(transferFrom(from, to, value));
847         require(_checkAndCallTransfer(from, to, value, data));
848         return true;
849     }
850 
851     function approveAndCall(address spender, uint256 value) public returns (bool) {
852         return approveAndCall(spender, value, "");
853     }
854 
855     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool) {
856         approve(spender, value);
857         require(_checkAndCallApprove(spender, value, data));
858         return true;
859     }
860 
861     /**
862      * @dev Internal function to invoke `onTransferReceived` on a target address
863      *  The call is not executed if the target address is not a contract
864      * @param from address Representing the previous owner of the given token value
865      * @param to address Target address that will receive the tokens
866      * @param value uint256 The amount mount of tokens to be transferred
867      * @param data bytes Optional data to send along with the call
868      * @return whether the call correctly returned the expected magic value
869      */
870     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
871         if (!to.isContract()) {
872             return false;
873         }
874         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
875             msg.sender, from, value, data
876         );
877         return (retval == _ERC1363_RECEIVED);
878     }
879 
880     /**
881      * @dev Internal function to invoke `onApprovalReceived` on a target address
882      *  The call is not executed if the target address is not a contract
883      * @param spender address The address which will spend the funds
884      * @param value uint256 The amount of tokens to be spent
885      * @param data bytes Optional data to send along with the call
886      * @return whether the call correctly returned the expected magic value
887      */
888     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
889         if (!spender.isContract()) {
890             return false;
891         }
892         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
893             msg.sender, value, data
894         );
895         return (retval == _ERC1363_APPROVED);
896     }
897 }
898 
899 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
900 
901 /**
902  * @dev Optional functions from the ERC20 standard.
903  */
904 contract ERC20Detailed is IERC20 {
905     string private _name;
906     string private _symbol;
907     uint8 private _decimals;
908 
909     /**
910      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
911      * these values are immutable: they can only be set once during
912      * construction.
913      */
914     constructor (string memory name, string memory symbol, uint8 decimals) public {
915         _name = name;
916         _symbol = symbol;
917         _decimals = decimals;
918     }
919 
920     /**
921      * @dev Returns the name of the token.
922      */
923     function name() public view returns (string memory) {
924         return _name;
925     }
926 
927     /**
928      * @dev Returns the symbol of the token, usually a shorter version of the
929      * name.
930      */
931     function symbol() public view returns (string memory) {
932         return _symbol;
933     }
934 
935     /**
936      * @dev Returns the number of decimals used to get its user representation.
937      * For example, if `decimals` equals `2`, a balance of `505` tokens should
938      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
939      *
940      * Tokens usually opt for a value of 18, imitating the relationship between
941      * Ether and Wei.
942      *
943      * > Note that this information is only used for _display_ purposes: it in
944      * no way affects any of the arithmetic of the contract, including
945      * `IERC20.balanceOf` and `IERC20.transfer`.
946      */
947     function decimals() public view returns (uint8) {
948         return _decimals;
949     }
950 }
951 
952 // File: openzeppelin-solidity/contracts/access/Roles.sol
953 
954 /**
955  * @title Roles
956  * @dev Library for managing addresses assigned to a Role.
957  */
958 library Roles {
959     struct Role {
960         mapping (address => bool) bearer;
961     }
962 
963     /**
964      * @dev Give an account access to this role.
965      */
966     function add(Role storage role, address account) internal {
967         require(!has(role, account), "Roles: account already has role");
968         role.bearer[account] = true;
969     }
970 
971     /**
972      * @dev Remove an account's access to this role.
973      */
974     function remove(Role storage role, address account) internal {
975         require(has(role, account), "Roles: account does not have role");
976         role.bearer[account] = false;
977     }
978 
979     /**
980      * @dev Check if an account has this role.
981      * @return bool
982      */
983     function has(Role storage role, address account) internal view returns (bool) {
984         require(account != address(0), "Roles: account is the zero address");
985         return role.bearer[account];
986     }
987 }
988 
989 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
990 
991 contract MinterRole {
992     using Roles for Roles.Role;
993 
994     event MinterAdded(address indexed account);
995     event MinterRemoved(address indexed account);
996 
997     Roles.Role private _minters;
998 
999     constructor () internal {
1000         _addMinter(msg.sender);
1001     }
1002 
1003     modifier onlyMinter() {
1004         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
1005         _;
1006     }
1007 
1008     function isMinter(address account) public view returns (bool) {
1009         return _minters.has(account);
1010     }
1011 
1012     function addMinter(address account) public onlyMinter {
1013         _addMinter(account);
1014     }
1015 
1016     function renounceMinter() public {
1017         _removeMinter(msg.sender);
1018     }
1019 
1020     function _addMinter(address account) internal {
1021         _minters.add(account);
1022         emit MinterAdded(account);
1023     }
1024 
1025     function _removeMinter(address account) internal {
1026         _minters.remove(account);
1027         emit MinterRemoved(account);
1028     }
1029 }
1030 
1031 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
1032 
1033 /**
1034  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
1035  * which have permission to mint (create) new tokens as they see fit.
1036  *
1037  * At construction, the deployer of the contract is the only minter.
1038  */
1039 contract ERC20Mintable is ERC20, MinterRole {
1040     /**
1041      * @dev See `ERC20._mint`.
1042      *
1043      * Requirements:
1044      *
1045      * - the caller must have the `MinterRole`.
1046      */
1047     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1048         _mint(account, amount);
1049         return true;
1050     }
1051 }
1052 
1053 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
1054 
1055 /**
1056  * @dev Extension of `ERC20Mintable` that adds a cap to the supply of tokens.
1057  */
1058 contract ERC20Capped is ERC20Mintable {
1059     uint256 private _cap;
1060 
1061     /**
1062      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1063      * set once during construction.
1064      */
1065     constructor (uint256 cap) public {
1066         require(cap > 0, "ERC20Capped: cap is 0");
1067         _cap = cap;
1068     }
1069 
1070     /**
1071      * @dev Returns the cap on the token's total supply.
1072      */
1073     function cap() public view returns (uint256) {
1074         return _cap;
1075     }
1076 
1077     /**
1078      * @dev See `ERC20Mintable.mint`.
1079      *
1080      * Requirements:
1081      *
1082      * - `value` must not cause the total supply to go over the cap.
1083      */
1084     function _mint(address account, uint256 value) internal {
1085         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
1086         super._mint(account, value);
1087     }
1088 }
1089 
1090 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
1091 
1092 /**
1093  * @dev Extension of `ERC20` that allows token holders to destroy both their own
1094  * tokens and those that they have an allowance for, in a way that can be
1095  * recognized off-chain (via event analysis).
1096  */
1097 contract ERC20Burnable is ERC20 {
1098     /**
1099      * @dev Destoys `amount` tokens from the caller.
1100      *
1101      * See `ERC20._burn`.
1102      */
1103     function burn(uint256 amount) public {
1104         _burn(msg.sender, amount);
1105     }
1106 
1107     /**
1108      * @dev See `ERC20._burnFrom`.
1109      */
1110     function burnFrom(address account, uint256 amount) public {
1111         _burnFrom(account, amount);
1112     }
1113 }
1114 
1115 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1116 
1117 /**
1118  * @dev Contract module which provides a basic access control mechanism, where
1119  * there is an account (an owner) that can be granted exclusive access to
1120  * specific functions.
1121  *
1122  * This module is used through inheritance. It will make available the modifier
1123  * `onlyOwner`, which can be aplied to your functions to restrict their use to
1124  * the owner.
1125  */
1126 contract Ownable {
1127     address private _owner;
1128 
1129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1130 
1131     /**
1132      * @dev Initializes the contract setting the deployer as the initial owner.
1133      */
1134     constructor () internal {
1135         _owner = msg.sender;
1136         emit OwnershipTransferred(address(0), _owner);
1137     }
1138 
1139     /**
1140      * @dev Returns the address of the current owner.
1141      */
1142     function owner() public view returns (address) {
1143         return _owner;
1144     }
1145 
1146     /**
1147      * @dev Throws if called by any account other than the owner.
1148      */
1149     modifier onlyOwner() {
1150         require(isOwner(), "Ownable: caller is not the owner");
1151         _;
1152     }
1153 
1154     /**
1155      * @dev Returns true if the caller is the current owner.
1156      */
1157     function isOwner() public view returns (bool) {
1158         return msg.sender == _owner;
1159     }
1160 
1161     /**
1162      * @dev Leaves the contract without owner. It will not be possible to call
1163      * `onlyOwner` functions anymore. Can only be called by the current owner.
1164      *
1165      * > Note: Renouncing ownership will leave the contract without an owner,
1166      * thereby removing any functionality that is only available to the owner.
1167      */
1168     function renounceOwnership() public onlyOwner {
1169         emit OwnershipTransferred(_owner, address(0));
1170         _owner = address(0);
1171     }
1172 
1173     /**
1174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1175      * Can only be called by the current owner.
1176      */
1177     function transferOwnership(address newOwner) public onlyOwner {
1178         _transferOwnership(newOwner);
1179     }
1180 
1181     /**
1182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1183      */
1184     function _transferOwnership(address newOwner) internal {
1185         require(newOwner != address(0), "Ownable: new owner is the zero address");
1186         emit OwnershipTransferred(_owner, newOwner);
1187         _owner = newOwner;
1188     }
1189 }
1190 
1191 // File: eth-token-recover/contracts/TokenRecover.sol
1192 
1193 /**
1194  * @title TokenRecover
1195  * @author Vittorio Minacori (https://github.com/vittominacori)
1196  * @dev Allow to recover any ERC20 sent into the contract for error
1197  */
1198 contract TokenRecover is Ownable {
1199 
1200     /**
1201      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1202      * @param tokenAddress The token contract address
1203      * @param tokenAmount Number of tokens to be sent
1204      */
1205     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1206         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1207     }
1208 }
1209 
1210 // File: ico-maker/contracts/access/roles/OperatorRole.sol
1211 
1212 contract OperatorRole {
1213     using Roles for Roles.Role;
1214 
1215     event OperatorAdded(address indexed account);
1216     event OperatorRemoved(address indexed account);
1217 
1218     Roles.Role private _operators;
1219 
1220     constructor() internal {
1221         _addOperator(msg.sender);
1222     }
1223 
1224     modifier onlyOperator() {
1225         require(isOperator(msg.sender));
1226         _;
1227     }
1228 
1229     function isOperator(address account) public view returns (bool) {
1230         return _operators.has(account);
1231     }
1232 
1233     function addOperator(address account) public onlyOperator {
1234         _addOperator(account);
1235     }
1236 
1237     function renounceOperator() public {
1238         _removeOperator(msg.sender);
1239     }
1240 
1241     function _addOperator(address account) internal {
1242         _operators.add(account);
1243         emit OperatorAdded(account);
1244     }
1245 
1246     function _removeOperator(address account) internal {
1247         _operators.remove(account);
1248         emit OperatorRemoved(account);
1249     }
1250 }
1251 
1252 // File: ico-maker/contracts/token/ERC20/BaseERC20Token.sol
1253 
1254 /**
1255  * @title BaseERC20Token
1256  * @author Vittorio Minacori (https://github.com/vittominacori)
1257  * @dev Implementation of the BaseERC20Token
1258  */
1259 contract BaseERC20Token is ERC20Detailed, ERC20Capped, ERC20Burnable, OperatorRole, TokenRecover {
1260 
1261     event MintFinished();
1262     event TransferEnabled();
1263 
1264     // indicates if minting is finished
1265     bool private _mintingFinished = false;
1266 
1267     // indicates if transfer is enabled
1268     bool private _transferEnabled = false;
1269 
1270     /**
1271      * @dev Tokens can be minted only before minting finished.
1272      */
1273     modifier canMint() {
1274         require(!_mintingFinished);
1275         _;
1276     }
1277 
1278     /**
1279      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1280      */
1281     modifier canTransfer(address from) {
1282         require(_transferEnabled || isOperator(from));
1283         _;
1284     }
1285 
1286     /**
1287      * @param name Name of the token
1288      * @param symbol A symbol to be used as ticker
1289      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1290      * @param cap Maximum number of tokens mintable
1291      * @param initialSupply Initial token supply
1292      */
1293     constructor(
1294         string memory name,
1295         string memory symbol,
1296         uint8 decimals,
1297         uint256 cap,
1298         uint256 initialSupply
1299     )
1300         public
1301         ERC20Detailed(name, symbol, decimals)
1302         ERC20Capped(cap)
1303     {
1304         if (initialSupply > 0) {
1305             _mint(owner(), initialSupply);
1306         }
1307     }
1308 
1309     /**
1310      * @return if minting is finished or not.
1311      */
1312     function mintingFinished() public view returns (bool) {
1313         return _mintingFinished;
1314     }
1315 
1316     /**
1317      * @return if transfer is enabled or not.
1318      */
1319     function transferEnabled() public view returns (bool) {
1320         return _transferEnabled;
1321     }
1322 
1323     /**
1324      * @dev Function to mint tokens
1325      * @param to The address that will receive the minted tokens.
1326      * @param value The amount of tokens to mint.
1327      * @return A boolean that indicates if the operation was successful.
1328      */
1329     function mint(address to, uint256 value) public canMint returns (bool) {
1330         return super.mint(to, value);
1331     }
1332 
1333     /**
1334      * @dev Transfer token to a specified address
1335      * @param to The address to transfer to.
1336      * @param value The amount to be transferred.
1337      * @return A boolean that indicates if the operation was successful.
1338      */
1339     function transfer(address to, uint256 value) public canTransfer(msg.sender) returns (bool) {
1340         return super.transfer(to, value);
1341     }
1342 
1343     /**
1344      * @dev Transfer tokens from one address to another.
1345      * @param from address The address which you want to send tokens from
1346      * @param to address The address which you want to transfer to
1347      * @param value uint256 the amount of tokens to be transferred
1348      * @return A boolean that indicates if the operation was successful.
1349      */
1350     function transferFrom(address from, address to, uint256 value) public canTransfer(from) returns (bool) {
1351         return super.transferFrom(from, to, value);
1352     }
1353 
1354     /**
1355      * @dev Function to stop minting new tokens.
1356      */
1357     function finishMinting() public onlyOwner canMint {
1358         _mintingFinished = true;
1359 
1360         emit MintFinished();
1361     }
1362 
1363     /**
1364    * @dev Function to enable transfers.
1365    */
1366     function enableTransfer() public onlyOwner {
1367         _transferEnabled = true;
1368 
1369         emit TransferEnabled();
1370     }
1371 
1372     /**
1373      * @dev remove the `operator` role from address
1374      * @param account Address you want to remove role
1375      */
1376     function removeOperator(address account) public onlyOwner {
1377         _removeOperator(account);
1378     }
1379 
1380     /**
1381      * @dev remove the `minter` role from address
1382      * @param account Address you want to remove role
1383      */
1384     function removeMinter(address account) public onlyOwner {
1385         _removeMinter(account);
1386     }
1387 }
1388 
1389 // File: ico-maker/contracts/token/ERC1363/BaseERC1363Token.sol
1390 
1391 /**
1392  * @title BaseERC1363Token
1393  * @author Vittorio Minacori (https://github.com/vittominacori)
1394  * @dev Implementation of the BaseERC20Token with ERC1363 behaviours
1395  */
1396 contract BaseERC1363Token is BaseERC20Token, ERC1363 {
1397 
1398     /**
1399      * @param name Name of the token
1400      * @param symbol A symbol to be used as ticker
1401      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1402      * @param cap Maximum number of tokens mintable
1403      * @param initialSupply Initial token supply
1404      */
1405     constructor(
1406         string memory name,
1407         string memory symbol,
1408         uint8 decimals,
1409         uint256 cap,
1410         uint256 initialSupply
1411     )
1412         public
1413         BaseERC20Token(name, symbol, decimals, cap, initialSupply)
1414     {} // solhint-disable-line no-empty-blocks
1415 }
1416 
1417 // File: contracts/ERC20Token.sol
1418 
1419 /**
1420  * @title ERC20Token
1421  * @author Vittorio Minacori (https://github.com/vittominacori)
1422  * @dev Implementation of a BaseERC1363Token
1423  */
1424 contract ERC20Token is BaseERC1363Token {
1425 
1426     string public builtOn = "https://vittominacori.github.io/erc20-generator";
1427 
1428     constructor(
1429         string memory name,
1430         string memory symbol,
1431         uint8 decimals,
1432         uint256 cap,
1433         uint256 initialSupply,
1434         bool transferEnabled
1435     )
1436         public
1437         BaseERC1363Token(name, symbol, decimals, cap, initialSupply)
1438     {
1439         if (transferEnabled) {
1440             enableTransfer();
1441         }
1442     }
1443 }